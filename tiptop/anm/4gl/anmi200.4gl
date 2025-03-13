# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi200.4gl
# Descriptions...: 轉帳媒體格式設定作業
# Date & Author..: FUN-870037 08/09/02 BY yiting
# Modify.........: FUN-8B0107 08/11/25 by Yiting
# Modify.........: NO.TQC-910036 09/01/20 BY yiting 如選為固定值，進入row先指定為"文字"
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0082 09/11/12 By liuxqa standard sql
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: NO.FUN-970077 10/03/11 By chenmoyan add aph18,aph19,pmf11,pmf12
# Modify.........: No.FUN-A20010 10/03/11 By chenmoyan add aph20
# Modify.........: No.FUN-A50016 10/05/06 by rainy cl_get_column_info傳入參數修改
# Modify.........: No.FUN-A70145 10/07/30 By alex 調整ASE SQL
# Modify.........: No.FUN-960162 10/08/22 By vealxu 加開欄位提供選取 nma10,nmt01,nmt02,nmt04,nmt14 
# Modify.........: No.FUN-960150 10/08/22 By vealxu add pmc55,pmc56 
# Modify.........: No.FUN-A90024 10/11/16 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50053 11/07/08 By zhangweib 添加nsb23全形/半形欄位
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-B80039 11/08/04 By Polly 修正AFTER FIELD nsb03，應l_ac > 0 才需做 -1 的檢核
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: NO.FUN-AA0008 12/07/03 BY bart nsb19 = '4'時，轉出長度不可為0
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
    g_nsa           RECORD LIKE nsa_file.*,       
    g_nsa_t         RECORD LIKE nsa_file.*,      
    g_nsa_o         RECORD LIKE nsa_file.*,     
    g_nsa01_t       LIKE nsa_file.nsa01,       
    g_nsb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nsb02       LIKE nsb_file.nsb02,
        nsb03       LIKE nsb_file.nsb03,
        nsb04       LIKE nsb_file.nsb04,
        nsb05       LIKE nsb_file.nsb05,
        gat03       LIKE gat_file.gat03, 
        nsb06       LIKE nsb_file.nsb06,
        nsb07       LIKE nsb_file.nsb07, 
        nsb08       LIKE nsb_file.nsb08,
        nsb09       LIKE nsb_file.nsb09,
        nsb10       LIKE nsb_file.nsb10,
        nsb16       LIKE nsb_file.nsb16,
        nsb18       LIKE nsb_file.nsb18,
        nsb21       LIKE type_file.chr1,
        nsb11       LIKE nsb_file.nsb11,
        nsb12       LIKE nsb_file.nsb12,
        nsb13       LIKE nsb_file.nsb13,
        nsb14       LIKE nsb_file.nsb14,
        nsb15       LIKE nsb_file.nsb15,
        nsb19       LIKE nsb_file.nsb19,
        nsb22       LIKE nsb_file.nsb22,
        nsb20       LIKE nsb_file.nsb20,
        nsb17       LIKE nsb_file.nsb17
       ,nsb23       LIKE nsb_file.nsb23  #FUN-B50053   Add
                    END RECORD,
    g_nsb_t         RECORD    #程式變數(Program Variables)
        nsb02       LIKE nsb_file.nsb02,
        nsb03       LIKE nsb_file.nsb03,
        nsb04       LIKE nsb_file.nsb04,
        nsb05       LIKE nsb_file.nsb05,
        gat03       LIKE gat_file.gat03, 
        nsb06       LIKE nsb_file.nsb06,
        nsb07       LIKE nsb_file.nsb07,
        nsb08       LIKE nsb_file.nsb08,
        nsb09       LIKE nsb_file.nsb09,
        nsb10       LIKE nsb_file.nsb10,
        nsb16       LIKE nsb_file.nsb16,
        nsb18       LIKE nsb_file.nsb18,
        nsb21       LIKE type_file.chr1,
        nsb11       LIKE nsb_file.nsb11,
        nsb12       LIKE nsb_file.nsb12,
        nsb13       LIKE nsb_file.nsb13,
        nsb14       LIKE nsb_file.nsb14,
        nsb15       LIKE nsb_file.nsb15,
        nsb19       LIKE nsb_file.nsb19,
        nsb22       LIKE nsb_file.nsb22,
        nsb20       LIKE nsb_file.nsb20,
        nsb17       LIKE nsb_file.nsb17
       ,nsb23       LIKE nsb_file.nsb23  #FUN-B50053   Add
                    END RECORD,
    g_wc,g_wc2,g_sql     string,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_sql                STRING
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL    
DEFINE g_before_input_done  LIKE type_file.num5 
DEFINE g_db_type       LIKE type_file.chr3                   #FUN-9B0082 mod
DEFINE   g_cnt          LIKE type_file.num10  
DEFINE   g_i            LIKE type_file.num5  
DEFINE   g_msg          LIKE type_file.chr1000  
DEFINE   g_curs_index   LIKE type_file.num10    
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_jump         LIKE type_file.num10  
DEFINE   g_no_ask       LIKE type_file.num5 
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time                
 
    LET g_forupd_sql = "SELECT * FROM nsa_file WHERE nsa01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW i200_w WITH FORM "anm/42f/anmi200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL i200_menu()
 
    CLOSE WINDOW i200_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time     
END MAIN
 
#QBE 查詢資料
FUNCTION i200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01 
 
    CLEAR FORM                             #清除畫面
    CALL g_nsb.clear()
    CALL cl_set_head_visible("","YES")      
 
   INITIALIZE g_nsa.* TO NULL 
    CONSTRUCT BY NAME g_wc ON nsa01,nsa02,nsa03,nsa04,nsa05,nsa06
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
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
 
    CONSTRUCT g_wc2 ON nsb02,nsb03        # 螢幕上取單身條件
                      ,nsb23              #FUN-B50053   Add
         FROM s_nsb[1].nsb02,s_nsb[1].nsb03 
             ,s_nsb[1].nsb23              #FUN-B50053   Add
 
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
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT nsa01 FROM nsa_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE nsa_file.nsa01 ",
                   "  FROM nsa_file, nsb_file",
                   " WHERE nsa01 = nsb01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE i200_prepare FROM g_sql
    DECLARE i200_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i200_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM nsa_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT nsa01) FROM nsa_file,nsb_file WHERE ",
                  "nsb01=nsa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i200_precount FROM g_sql
    DECLARE i200_count CURSOR FOR i200_precount
 
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
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i200_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i200_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i200_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "trans_code"
            LET g_msg = "anmi201 '",g_nsa.nsa01,"'"
            CALL cl_cmdrun(g_msg)
    
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nsb),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nsa.nsa01 IS NOT NULL THEN
                 LET g_doc.column1 = "nsa01"
                 LET g_doc.value1 = g_nsa.nsa01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0079-------add--------end----
 
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION i200_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_nsb.clear()
 
    INITIALIZE g_nsa.* LIKE nsa_file.*             #DEFAULT 設定
    LET g_nsa01_t = NULL
    LET g_nsa_t.* = g_nsa.*
    LET g_nsa_o.* = g_nsa.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i200_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_nsa.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_nsa.nsa01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
 
        INSERT INTO nsa_file(nsa01,nsa02,nsa03,nsa04,nsa05,nsa06) 
                      VALUES(g_nsa.nsa01,g_nsa.nsa02,g_nsa.nsa03,
                             g_nsa.nsa04,g_nsa.nsa05,g_nsa.nsa06)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
           CALL cl_err3("ins","nsa_file",g_nsa.nsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
           CONTINUE WHILE
        END IF
 
        SELECT nsa01 INTO g_nsa.nsa01 FROM nsa_file
         WHERE nsa01 = g_nsa.nsa01
        LET g_nsa01_t = g_nsa.nsa01        #保留舊值
        LET g_nsa_t.* = g_nsa.*
 
        CALL g_nsb.clear()
        LET g_rec_b = 0 
 
        CALL i200_b()                      #輸入單身
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i200_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_nsa.nsa01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
 
    LET g_nsa01_t = g_nsa.nsa01
    LET g_nsa_o.* = g_nsa.*
    LET g_nsa_t.* = g_nsa.*
 
    BEGIN WORK
 
    OPEN i200_cl USING g_nsa.nsa01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nsa.nsa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i200_cl ROLLBACK WORK RETURN
    END IF
 
    FETCH i200_cl INTO g_nsa.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nsa.nsa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE i200_cl ROLLBACK WORK RETURN
    END IF
 
    CALL i200_show()
 
    WHILE TRUE
        LET g_nsa01_t = g_nsa.nsa01
        CALL i200_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_nsa.*=g_nsa_t.*
            CALL i200_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
        IF g_nsa.nsa01 != g_nsa01_t THEN  
           UPDATE nsb_file SET nsb01 = g_nsa.nsa01 WHERE nsb01 = g_nsa01_t
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","nsb_file",g_nsa01_t,"",SQLCA.sqlcode,"","nsb",1)  #No.FUN-660167
              CONTINUE WHILE  
           END IF
        END IF
 
        UPDATE nsa_file SET nsa01 = g_nsa.nsa01, nsa02 = g_nsa.nsa02 ,
                            nsa03 = g_nsa.nsa03, nsa04 = g_nsa.nsa04,
                            nsa05 = g_nsa.nsa05, nsa06 = g_nsa.nsa06
         WHERE nsa01 = g_nsa.nsa01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","nsa_file",g_nsa01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
           CONTINUE WHILE
        END IF
 
        EXIT WHILE
    END WHILE
 
    CLOSE i200_cl
    COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION i200_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680137 VARCHAR(1)
    l_n1            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680137 VARCHAR(1)
 
    DISPLAY BY NAME g_nsa.nsa01,g_nsa.nsa02 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME
        g_nsa.nsa01,g_nsa.nsa02,g_nsa.nsa03,
        g_nsa.nsa04,g_nsa.nsa06,g_nsa.nsa05
        WITHOUT DEFAULTS 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i200_set_entry(p_cmd)
           CALL i200_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
        
        AFTER FIELD nsa01      
           IF NOT cl_null(g_nsa.nsa01) THEN
              IF g_nsa.nsa01 != g_nsa01_t OR cl_null(g_nsa01_t) THEN
                 SELECT count(*) INTO g_cnt FROM nsa_file
                  WHERE nsa01 = g_nsa.nsa01
                 IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_nsa.nsa01,-239,0)
                    LET g_nsa.nsa01 = g_nsa01_t
                    DISPLAY BY NAME g_nsa.nsa01 
                    NEXT FIELD nsa01
                 ELSE
                    LET g_nsa.nsa04 = g_nsa.nsa01    #FUN-8B0107 add 
                    DISPLAY BY NAME g_nsa.nsa04      #FUN-8B0107 add
                 END IF
              END IF
              LET g_nsa_o.nsa01 = g_nsa.nsa01
           END IF
             
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
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
FUNCTION i200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nsa.* TO NULL              #FUN-6B0079
 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt 
    CALL i200_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_nsa.* TO NULL
        RETURN
    END IF
 
    MESSAGE " SEARCHING ! " 
 
    OPEN i200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_nsa.* TO NULL
    ELSE
       OPEN i200_count
       FETCH i200_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt 
       CALL i200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i200_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i200_cs INTO g_nsa.nsa01
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_nsa.nsa01
        WHEN 'F' FETCH FIRST    i200_cs INTO g_nsa.nsa01
        WHEN 'L' FETCH LAST     i200_cs INTO g_nsa.nsa01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump 
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
            FETCH ABSOLUTE g_jump i200_cs INTO g_nsa.nsa01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nsa.nsa01,SQLCA.sqlcode,0)
        INITIALIZE g_nsa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_nsa.* FROM nsa_file WHERE nsa01 = g_nsa.nsa01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","nsa_file",g_nsa.nsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_nsa.* TO NULL
        RETURN
    END IF
    LET g_data_owner = ''      #FUN-4C0057 add
    LET g_data_group = ''      #FUN-4C0057 add
    CALL i200_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i200_show()
    LET g_nsa_t.* = g_nsa.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
        g_nsa.nsa01,g_nsa.nsa02,g_nsa.nsa03,g_nsa.nsa04,g_nsa.nsa05,g_nsa.nsa06 
    CALL i200_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i200_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1      #No.FUN-680137 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_nsa.nsa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    BEGIN WORK
 
    OPEN i200_cl USING g_nsa.nsa01
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_nsa.nsa01,SQLCA.sqlcode,0)
       CLOSE i200_cl ROLLBACK WORK RETURN 
    END IF
 
    FETCH i200_cl INTO g_nsa.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_nsa.nsa01,SQLCA.sqlcode,0)
       CLOSE i200_cl ROLLBACK WORK RETURN 
    END IF
 
    CALL i200_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nsa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nsa.nsa01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM nsa_file WHERE nsa01 = g_nsa.nsa01
        DELETE FROM nsb_file WHERE nsb01 = g_nsa.nsa01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","nsa_file",g_nsa.nsa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
        ELSE
           CLEAR FORM
           CALL g_nsb.clear()
    	   INITIALIZE g_nsa.* LIKE nsa_file.*             #DEFAULT 設定
           OPEN i200_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE i200_cs
              CLOSE i200_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH i200_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i200_cs
              CLOSE i200_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i200_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i200_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i200_fetch('/')
           END IF
        END IF
    END IF
 
    CLOSE i200_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
DEFINE li_return    LIKE type_file.num5
DEFINE l_nsb08      LIKE type_file.chr20
DEFINE l_scale      LIKE type_file.num5 
DEFINE l_length     LIKE ztb_file.ztb08
DEFINE l_length1    LIKE ztb_file.ztb08  
DEFINE i            LIKE type_file.num5
DEFINE l_azw05      LIKE  azw_file.azw05   #FUN-A50016

    LET g_db_type=cl_db_get_database_type()    #FUN-9B0082 add
    LET g_action_choice = ""
 
    IF g_nsa.nsa01 IS NULL THEN RETURN END IF
 
    LET g_forupd_sql = "SELECT nsb02,nsb03,nsb04,nsb05,'',nsb06,",  
                       "      nsb07,nsb08,nsb09,nsb10,nsb16,nsb18,",  
                       "       nsb21,nsb11,nsb12,nsb13,nsb14,nsb15,",
                       "       nsb19,nsb22,nsb20,nsb17,nsb23",   #FUN-B50053   Add
                       " FROM nsb_file ",
                       "  WHERE nsb01 = ? AND nsb02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    CALL cl_query_prt_temptable()     #No.FUN-A90024
 
    INPUT ARRAY g_nsb WITHOUT DEFAULTS FROM s_nsb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_nsb_t.* = g_nsb[l_ac].*  #BACKUP
               OPEN i200_bcl USING g_nsa.nsa01, g_nsb_t.nsb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nsb_t.nsb03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i200_bcl INTO g_nsb[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_nsb_t.nsb03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF 
                  SELECT gat03 INTO g_nsb[l_ac].gat03
                    FROM gat_file
                   WHERE gat01 = g_nsb[l_ac].nsb05
                     AND gat02 = g_lang
                  SELECT gaq03 INTO g_nsb[l_ac].nsb07
                    FROM gaq_file
                   WHERE gaq01 = g_nsb[l_ac].nsb06
                     AND gaq02 = g_lang
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            CALL i200_set_entry_b()
           #CALL i200_set_no_entry_b()    #FUN-960162  
            CALL i200_set_required_b() 
            CALL i200_set_no_required_b() 
 
        BEFORE FIELD nsb02 
            IF cl_null(g_nsb[l_ac].nsb02) THEN
               SELECT MAX(nsb02)+10 INTO g_nsb[l_ac].nsb02 FROM nsb_file
                WHERE nsb01=g_nsa.nsa01
               IF cl_null(g_nsb[l_ac].nsb02) THEN 
                  LET g_nsb[l_ac].nsb02=10
               END IF
            END IF
 
        AFTER FIELD nsb02 
            IF NOT cl_null(g_nsb[l_ac].nsb02) THEN
               IF g_nsb_t.nsb02 != g_nsb[l_ac].nsb02 
                  OR cl_null(g_nsb_t.nsb02) THEN
                  SELECT COUNT(*) INTO g_cnt FROM nsb_file
                   WHERE nsb01=g_nsa.nsa01 AND nsb02=g_nsb[l_ac].nsb02
                  IF g_cnt >0 THEN
                     CALL cl_err(g_nsa.nsa01,-239,0)
                     NEXT FIELD nsb02
                  END IF
               END IF
            END IF
 
        AFTER FIELD nsb03
            IF NOT cl_null(g_nsb[l_ac].nsb03) THEN
                IF l_ac > 1 THEN
                    IF g_nsb[l_ac].nsb03 < g_nsb[l_ac-1].nsb03 THEN
                        CALL cl_err(g_nsb[l_ac].nsb03,'anm1002',0)
                        NEXT FIELD nsb03
                    END IF
               #END IF             #No.MOD-B80039 mark
                    IF g_nsb[l_ac].nsb03 = '3' THEN
                       IF (g_nsb[l_ac-1].nsb03 != '2' AND
                           g_nsb[l_ac-1].nsb03 != '3') THEN
                           CALL cl_err('','anm1003',0)
                           NEXT FIELD nsb03
                       END IF
                    END IF
                END IF              #No.MOD-B80039 add
            END IF
       
        BEFORE FIELD nsb04
           CALL i200_set_entry_b()
           CALL i200_set_no_required_b() 
         
 
        AFTER FIELD nsb04
            IF NOT cl_null(g_nsb[l_ac].nsb04) THEN
                IF g_nsb[l_ac].nsb04 = '1' THEN
                    #LET g_nsb[l_ac].nsb08 = 'N'
                    LET g_nsb[l_ac].nsb08 = 'C'   #TQC-910036 mod
                    LET g_nsb[l_ac].nsb05 = ''
                    LET g_nsb[l_ac].nsb06 = '' 
                    LET g_nsb[l_ac].gat03 = ''  
                    LET g_nsb[l_ac].nsb07 = '' 
                END IF
                IF g_nsb[l_ac].nsb04 = '2' THEN
                    LET g_nsb[l_ac].nsb09 = ''
                    LET g_nsb[l_ac].nsb10 = ''
                END IF
                IF g_nsb[l_ac].nsb04 = '3' THEN
                    LET g_nsb[l_ac].nsb08 = 'D'
                    LET g_nsb[l_ac].nsb05 = ''  
                    LET g_nsb[l_ac].nsb06 = ''  
                    LET g_nsb[l_ac].nsb09 = ''  
                    LET g_nsb[l_ac].nsb10 = ''  
                    LET g_nsb[l_ac].gat03 = '' 
                    LET g_nsb[l_ac].nsb07 = ''
                END IF
                IF (g_nsb[l_ac].nsb04 = '4' OR 
                   g_nsb[l_ac].nsb04 = '41' OR 
                   g_nsb[l_ac].nsb04 = '5') THEN
                    LET g_nsb[l_ac].nsb08 = 'L'
                    LET g_nsb[l_ac].nsb05 = ''  
                    LET g_nsb[l_ac].nsb06 = ''  
                    LET g_nsb[l_ac].nsb09 = ''  
                    LET g_nsb[l_ac].nsb10 = ''  
                    LET g_nsb[l_ac].gat03 = ''  
                    LET g_nsb[l_ac].nsb07 = '' 
                END IF
                IF (g_nsb[l_ac].nsb04 = '6' OR g_nsb[l_ac].nsb04 = '61' OR
                    g_nsb[l_ac].nsb04 = '62' OR g_nsb[l_ac].nsb04 = '63' OR g_nsb[l_ac].nsb04 = '8') THEN   
                    LET g_nsb[l_ac].nsb08 = 'C'
                    LET g_nsb[l_ac].nsb05 = ''  
                    LET g_nsb[l_ac].nsb06 = ''  
                    LET g_nsb[l_ac].nsb09 = ''  
                    LET g_nsb[l_ac].nsb10 = ''  
                    LET g_nsb[l_ac].gat03 = ''
                    LET g_nsb[l_ac].nsb07 = ''
                END IF
                IF g_nsb[l_ac].nsb04 = '7' THEN
                    LET g_nsb[l_ac].nsb08 = 'D'
                    LET g_nsb[l_ac].nsb05 = ''  
                    LET g_nsb[l_ac].nsb06 = ''  
                    LET g_nsb[l_ac].nsb09 = ''  
                    LET g_nsb[l_ac].nsb10 = ''  
                    LET g_nsb[l_ac].gat03 = '' 
                    LET g_nsb[l_ac].nsb07 = ''
                END IF
                IF g_nsb[l_ac].nsb04 > = '91' THEN
                    LET g_nsb[l_ac].nsb08 = 'N'
                    LET g_nsb[l_ac].nsb05 = ''  
                    LET g_nsb[l_ac].nsb06 = ''  
                    LET g_nsb[l_ac].nsb09 = ''  
                    LET g_nsb[l_ac].nsb10 = ''  
                    LET g_nsb[l_ac].gat03 = '' 
                    LET g_nsb[l_ac].nsb07 = ''
                END IF
                IF g_nsb[l_ac].nsb03 <> '3' AND 
                   g_nsb[l_ac].nsb04 = '5' THEN
                       CALL cl_err('','anm1005',0)
                       NEXT FIELD nsb03
                END IF
                IF g_nsb[l_ac].nsb03 <> '2' AND 
                   g_nsb[l_ac].nsb04 = '41' THEN
                       CALL cl_err('','anm1005',0)
                       NEXT FIELD nsb03
                END IF
            END IF
            DISPLAY BY NAME g_nsb[l_ac].nsb08
            DISPLAY BY NAME g_nsb[l_ac].nsb05
            DISPLAY BY NAME g_nsb[l_ac].nsb06
            DISPLAY BY NAME g_nsb[l_ac].nsb09
            DISPLAY BY NAME g_nsb[l_ac].nsb10
            DISPLAY BY NAME g_nsb[l_ac].gat03   
            DISPLAY BY NAME g_nsb[l_ac].nsb07  
          # CALL i200_set_no_entry_b()          #FUN-960162  
            CALL i200_set_required_b() 
 
        BEFORE FIELD nsb05                      #TQC-910036
           CALL i200_set_entry_b()              #TQC-910036
            
        AFTER FIELD nsb05
           IF NOT cl_null(g_nsb[l_ac].nsb05) THEN
              IF cl_null(g_nsb_t.nsb05) OR 
                  (g_nsb_t.nsb05 <> g_nsb[l_ac].nsb05) THEN
                 CALL i200_check_table(g_nsb[l_ac].nsb05)
                      RETURNING li_return
                 IF li_return = 0 THEN
                    NEXT FIELD nsb05
                 END IF
              END IF
              SELECT gat03 INTO g_nsb[l_ac].gat03
                FROM gat_file
               WHERE gat01 = g_nsb[l_ac].nsb05
                 AND gat02 = g_lang
           ELSE                                    #TQC-910036
               LET g_nsb[l_ac].nsb06 = ''          #TQC-910036
               DISPLAY BY NAME g_nsb[l_ac].nsb06   #TQC-910036
               LET g_nsb[l_ac].nsb07 = ''          #TQC-910036
               DISPLAY BY NAME g_nsb[l_ac].nsb07   #TQC-910036
               LET g_nsb[l_ac].nsb08 = ''          #TQC-910036
               DISPLAY BY NAME g_nsb[l_ac].nsb08   #TQC-910036
               LET g_nsb[l_ac].nsb16 = ''          #TQC-910036
               DISPLAY BY NAME g_nsb[l_ac].nsb16   #TQC-910036
               LET g_nsb[l_ac].gat03 = ''          #TQC-910036
               DISPLAY BY NAME g_nsb[l_ac].gat03   #TQC-910036
           END IF                                  #TQC-910036
          #CALL i200_set_no_entry_b()              #TQC-910036   #FUN-960162 mark 
            
 
        AFTER FIELD nsb06
           IF NOT cl_null(g_nsb[l_ac].nsb06) THEN
              IF cl_null(g_nsb_t.nsb06) OR g_nsb_t.nsb06 <> g_nsb[l_ac].nsb06 THEN
                 CALL i200_check_field(g_nsb[l_ac].nsb06,g_nsb[l_ac].nsb05)
                      RETURNING li_return,g_nsb[l_ac].nsb08
                 IF li_return = 0 THEN
                    NEXT FIELD nsb06
                 END IF
              END IF
              SELECT gaq03 INTO g_nsb[l_ac].nsb07
                FROM gaq_file
               WHERE gaq01 = g_nsb[l_ac].nsb06
                 AND gaq02 = g_lang
              IF (g_nsb_t.nsb06 <> g_nsb[l_ac].nsb06) OR 
                cl_null(g_nsb_t.nsb06) THEN  #TQC-910036
#FUN-9B0082 mod --begin
                  #SELECT lower(data_type),to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),data_scale
                  #  INTO l_nsb08,g_nsb[l_ac].nsb16,g_nsb[l_ac].nsb18
                  #  FROM all_tab_columns
                  # WHERE lower(owner)='ds'
                  #   AND lower(column_name)= g_nsb[l_ac].nsb06

                  #---FUN-A90024---start-----
                  #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
                  #目前統一用sch_file紀錄TIPTOP資料結構
                  #CASE g_db_type
                  #   WHEN "IFX"
                  #      LET l_sql="SELECT b.coltype ",
                  #                "  FROM systables a,syscolumns b",
                  #                " WHERE a.tabname = '",g_nsb[l_ac].nsb05 CLIPPED,"'",
                  #                "   AND a.tabid = b.tabid",
                  #                "   AND b.colname = '",g_nsb[l_ac].nsb06 CLIPPED,"'"
                  #      PREPARE i200_ifx FROM l_sql
                  #      EXECUTE i200_ifx INTO l_nsb08
                  #      LET g_nsb[l_ac].nsb18 = 0
                  #      IF l_nsb08 = 5 or l_nsb08 = 261 THEN
                  #         LET g_nsb[l_ac].nsb18 = l_nsb08 MOD 16
                  #      END IF
                  ##FUN-A50016 begin
                  #      CALL s_get_azw05(g_plant) RETURNING l_azw05
                  #      #CALL cl_get_column_info(g_dbs,g_nsb[l_ac].nsb05,g_nsb[l_ac].nsb06) RETURNING l_nsb08,g_nsb[l_ac].nsb16
                  #      CALL cl_get_column_info(l_azw05,g_nsb[l_ac].nsb05,g_nsb[l_ac].nsb06) RETURNING l_nsb08,g_nsb[l_ac].nsb16
                  ##FUN-A50016 end
                  # 
                  #   WHEN "MSV"
                  #      LET l_sql="SELECT a.scale ",
                  #                " FROM sys.all_columns a,sys.types b ",
                  #                " WHERE a.object_id = object_id('",g_nsb[l_ac].nsb05 CLIPPED,"')",
                  #                "   AND a.name = '",g_nsb[l_ac].nsb06,"'",
                  #                "   AND a.system_type_id = b.user_type_id "
                  #      PREPARE i200_msv FROM l_sql
                  #      EXECUTE i200_msv INTO g_nsb[l_ac].nsb18
                  ##FUN-A50016 begin
                  #      CALL s_get_azw05(g_plant) RETURNING l_azw05
                  #      #CALL cl_get_column_info(g_dbs,g_nsb[l_ac].nsb05,g_nsb[l_ac].nsb06) RETURNING l_nsb08,g_nsb[l_ac].nsb16
                  #      CALL cl_get_column_info(l_azw05,g_nsb[l_ac].nsb05,g_nsb[l_ac].nsb06) RETURNING l_nsb08,g_nsb[l_ac].nsb16
                  ##FUN-A50016 end
                  #   WHEN "ASE"     #FUN-A70145
                  #      LET l_sql="SELECT a.scale ",
                  #                " FROM sys.all_columns a,sys.types b ",
                  #                " WHERE a.object_id = object_id('",g_nsb[l_ac].nsb05 CLIPPED,"')",
                  #                "   AND a.name = '",g_nsb[l_ac].nsb06,"'",
                  #                "   AND a.system_type_id = b.user_type_id "
                  #      PREPARE i200_ase FROM l_sql
                  #      EXECUTE i200_ase INTO g_nsb[l_ac].nsb18
                  #      CALL s_get_azw05(g_plant) RETURNING l_azw05
                  #      CALL cl_get_column_info(l_azw05,g_nsb[l_ac].nsb05,g_nsb[l_ac].nsb06) RETURNING l_nsb08,g_nsb[l_ac].nsb16
                  #
                  #   WHEN "ORA"
                  #      LET l_sql="SELECT data_scale ",
                  #                "  FROM all_tab_columns",
                  #                "  WHERE lower(owner)='ds'",
                  #                "   AND lower(column_name)= '",g_nsb[l_ac].nsb06,"'"
                  #      PREPARE i200_ora FROM l_sql
                  #      EXECUTE i200_ora INTO g_nsb[l_ac].nsb18
                  ##FUN-A50016 begin
                  #      CALL s_get_azw05(g_plant) RETURNING l_azw05
                  #      #CALL cl_get_column_info(g_dbs,g_nsb[l_ac].nsb05,g_nsb[l_ac].nsb06) RETURNING l_nsb08,g_nsb[l_ac].nsb16
                  #      CALL cl_get_column_info(l_azw05,g_nsb[l_ac].nsb05,g_nsb[l_ac].nsb06) RETURNING l_nsb08,g_nsb[l_ac].nsb16
                  #FUN-A50016 end
                  #END CASE

                  CALL cl_query_prt_getlength(g_nsb[l_ac].nsb06, 'N', 's', 0)
                  SELECT xabc06, xabc04, xabc05 INTO l_nsb08, g_nsb[l_ac].nsb16, g_nsb[l_ac].nsb18 
                    FROM xabc WHERE xabc02 = g_nsb[l_ac].nsb06
                  IF g_nsb[l_ac].nsb18 = -1 THEN
                     LET g_nsb[l_ac].nsb18 = NULL
                  END IF
                  #---FUN-A90024---end------- 
                  #CALL i200_gettype(g_cnt,l_nsb08,g_nsb[l_ac].nsb16,g_nsb[l_ac].nsb18)
#FUN-9B0082 mod --end
                   DISPLAY BY NAME g_nsb[l_ac].nsb16
                   DISPLAY BY NAME g_nsb[l_ac].nsb18
              END IF
           ELSE
              LET g_nsb[l_ac].nsb07 = ''
              DISPLAY BY NAME g_nsb[l_ac].nsb07
           END IF
 
        BEFORE FIELD nsb08
            CALL i200_set_entry_b()
       
        AFTER FIELD nsb08
            IF g_nsb[l_ac].nsb04 = '1' AND g_nsb[l_ac].nsb08 = 'N' THEN
                LET g_nsb[l_ac].nsb10 = '' 
            END IF
            IF g_nsb[l_ac].nsb04 = '1' AND g_nsb[l_ac].nsb08 = 'C' THEN
                LET g_nsb[l_ac].nsb09 = ''
            END IF
            IF g_nsb[l_ac].nsb08 <> 'N' THEN
                LET g_nsb[l_ac].nsb11 = '' 
                LET g_nsb[l_ac].nsb12 = '' 
                LET g_nsb[l_ac].nsb13 = '' 
                LET g_nsb[l_ac].nsb14 = '' 
                LET g_nsb[l_ac].nsb15 = '' 
                LET g_nsb[l_ac].nsb18 = 0
                LET g_nsb[l_ac].nsb21 = 'N'
            END IF
            IF g_nsb[l_ac].nsb08 = 'N' THEN
                LET g_nsb[l_ac].nsb19 = '2'
            ELSE
                LET g_nsb[l_ac].nsb19 = '1'
            END IF
            DISPLAY BY NAME g_nsb[l_ac].nsb11
            DISPLAY BY NAME g_nsb[l_ac].nsb12
            DISPLAY BY NAME g_nsb[l_ac].nsb13
            DISPLAY BY NAME g_nsb[l_ac].nsb14
            DISPLAY BY NAME g_nsb[l_ac].nsb15
            DISPLAY BY NAME g_nsb[l_ac].nsb18
            DISPLAY BY NAME g_nsb[l_ac].nsb21
            DISPLAY BY NAME g_nsb[l_ac].nsb19
          # CALL i200_set_no_entry_b()        #FUN-960162  
 
        AFTER FIELD nsb16 
            IF g_nsb[l_ac].nsb16 < 0 THEN
                CALL cl_err('','anm1004',0)
                NEXT FIELD nsb16
            END IF
        #---FUN-AA0008 start--
            IF g_nsb[l_ac].nsb22 = '+' THEN
                IF g_nsb[l_ac].nsb19 <> '5' THEN
                    IF (cl_null(g_nsb[l_ac].nsb16) OR g_nsb[l_ac].nsb16 = 0) THEN
                        CALL cl_err('','anm-293',0)
                        NEXT FIELD nsb16
                    END IF
                END IF
            END IF

        AFTER INPUT
            IF g_nsb[l_ac].nsb16 < 0 THEN
                CALL cl_err('','anm1004',0)
                NEXT FIELD nsb16
            END IF
            IF g_nsb[l_ac].nsb22 = '+' THEN
                IF g_nsb[l_ac].nsb19 <> '5' THEN
                    IF (cl_null(g_nsb[l_ac].nsb16) OR g_nsb[l_ac].nsb16 = 0) THEN
                        CALL cl_err('','anm-293',0)
                        NEXT FIELD nsb16
                    END IF
                END IF
            END IF
        #--FUN-AA0008 end------
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_nsb[l_ac].* TO NULL
            LET g_nsb_t.* = g_nsb[l_ac].*         #新輸入資料
            LET g_nsb[l_ac].nsb03 = '2'
            LET g_nsb[l_ac].nsb04 = '2'
            LET g_nsb[l_ac].nsb20 = 'Y'
            LET g_nsb[l_ac].nsb21 = 'N'
            LET g_nsb[l_ac].nsb18 = 0
            LET g_nsb[l_ac].nsb09 = 0 USING '#'
            LET g_nsb[l_ac].nsb23 = 1   #FUN-B50053   Add
            CALL cl_show_fld_cont()    
            CALL i200_set_entry_b()
          # CALL i200_set_no_entry_b()    #FUN-960162 
            CALL i200_set_required_b() 
            CALL i200_set_no_required_b() 
            NEXT FIELD nsb02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO nsb_file(nsb01,nsb02,nsb03,nsb04,nsb05,nsb06,nsb07,nsb08,nsb09,  
                                  nsb10,nsb11,nsb12,nsb13,nsb14,nsb15,nsb16,nsb17,nsb18,
                                  nsb19,nsb20,nsb21,nsb22,nsb23)  #FUN-B50053   Add  
                          VALUES(g_nsa.nsa01,
                                 g_nsb[l_ac].nsb02,
                                 g_nsb[l_ac].nsb03,
                                 g_nsb[l_ac].nsb04,
                                 g_nsb[l_ac].nsb05,
                                 g_nsb[l_ac].nsb06,
                                 g_nsb[l_ac].nsb07, 
                                 g_nsb[l_ac].nsb08,
                                 g_nsb[l_ac].nsb09,
                                 g_nsb[l_ac].nsb10,
                                 g_nsb[l_ac].nsb11,
                                 g_nsb[l_ac].nsb12,
                                 g_nsb[l_ac].nsb13,
                                 g_nsb[l_ac].nsb14,
                                 g_nsb[l_ac].nsb15,
                                 g_nsb[l_ac].nsb16,
                                 g_nsb[l_ac].nsb17, 
                                 g_nsb[l_ac].nsb18,
                                 g_nsb[l_ac].nsb19,
                                 g_nsb[l_ac].nsb20,
                                 g_nsb[l_ac].nsb21,
                                 g_nsb[l_ac].nsb22
                                ,g_nsb[l_ac].nsb23  #FUN-B50053   Add
                                 )
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","nsb_file",g_nsa.nsa01,g_nsb[l_ac].nsb02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               CANCEL INSERT
            ELSE
               COMMIT WORK
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_nsb_t.nsb02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN 
                  CANCEL DELETE
               END IF
                
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               
               DELETE FROM nsb_file 
                WHERE nsb01 = g_nsa.nsa01 
                  AND nsb02 = g_nsb_t.nsb02
               IF SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("del","nsb_file",g_nsa.nsa01,g_nsb_t.nsb02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  ROLLBACK WORK
                  CANCEL DELETE 
               END IF
 
               COMMIT WORK
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_nsb[l_ac].* = g_nsb_t.*
               CLOSE i200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_nsb[l_ac].nsb02,-263,1)
               LET g_nsb[l_ac].* = g_nsb_t.*
            ELSE
               UPDATE nsb_file SET nsb02=g_nsb[l_ac].nsb02,
                                   nsb03=g_nsb[l_ac].nsb03,
                                   nsb04=g_nsb[l_ac].nsb04,
                                   nsb05=g_nsb[l_ac].nsb05,
                                   nsb06=g_nsb[l_ac].nsb06,
                                   nsb07=g_nsb[l_ac].nsb07,   
                                   nsb08=g_nsb[l_ac].nsb08,
                                   nsb09=g_nsb[l_ac].nsb09,
                                   nsb10=g_nsb[l_ac].nsb10,
                                   nsb11=g_nsb[l_ac].nsb11,
                                   nsb12=g_nsb[l_ac].nsb12,
                                   nsb13=g_nsb[l_ac].nsb13,
                                   nsb14=g_nsb[l_ac].nsb14,
                                   nsb15=g_nsb[l_ac].nsb15,
                                   nsb16=g_nsb[l_ac].nsb16,
                                   nsb17=g_nsb[l_ac].nsb17, 
                                   nsb18=g_nsb[l_ac].nsb18,
                                   nsb19=g_nsb[l_ac].nsb19,
                                   nsb20=g_nsb[l_ac].nsb20,
                                   nsb21=g_nsb[l_ac].nsb21,
                                   nsb22=g_nsb[l_ac].nsb22
                                  ,nsb23=g_nsb[l_ac].nsb23   #FUN-B50053   Add
                WHERE nsb01 = g_nsa.nsa01 
                  AND nsb02 = g_nsb_t.nsb02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","nsb_file",g_nsa.nsa01,g_nsb_t.nsb02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  LET g_nsb[l_ac].* = g_nsb_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac   #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_nsb[l_ac].* = g_nsb_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_nsb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE i200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032 add
 
            CLOSE i200_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLP                                                        
           CASE                                                                   
               WHEN INFIELD(nsb05)
                 CALL q_gat(FALSE,TRUE,g_nsb[l_ac].nsb05,g_nsa.nsa03)
                      RETURNING g_nsb[l_ac].nsb05
                 DISPLAY BY NAME g_nsb[l_ac].nsb05
               WHEN INFIELD(nsb06)                                             
                 CALL q_gaq2(FALSE,TRUE,g_nsb[l_ac].nsb06,g_nsb[l_ac].nsb05)
                      RETURNING g_nsb[l_ac].nsb06
                 DISPLAY BY NAME g_nsb[l_ac].nsb06
           END CASE                                                               
 
        ON ACTION CONTROLO                        # 沿用所有欄位
            IF l_ac > 1 THEN
               LET g_nsb[l_ac].* = g_nsb[l_ac-1].*
               NEXT FIELD nsb02
            END IF
 
        ON ACTION controls                                  #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")                #No.FUN-6A0092
   
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
    CLOSE i200_bcl
    COMMIT WORK
    CALL i200_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i200_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM nsa_file WHERE nsa01 = g_nsa.nsa01
         INITIALIZE g_nsa.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200) 
 
    LET g_sql = "SELECT nsb02,nsb03,nsb04,nsb05,'',nsb06,",
                "       nsb07,nsb08,nsb09,nsb10,nsb16,nsb18,",
                "       nsb21,nsb11,nsb12,nsb13,nsb14,nsb15,",
                "       nsb19,nsb22,nsb20,nsb17,nsb23",   #FUN-B50053   Add
                " FROM nsb_file ",
                " WHERE nsb01 ='",g_nsa.nsa01,"'",  #單頭
                " AND ",p_wc2 CLIPPED,              #單身
                " ORDER BY 1" 
 
    PREPARE i200_pb FROM g_sql
    DECLARE nsb_curs                       #CURSOR
        CURSOR FOR i200_pb
 
    CALL g_nsb.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH nsb_curs INTO g_nsb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT gat03 INTO g_nsb[g_cnt].gat03
          FROM gat_file
         WHERE gat01 = g_nsb[g_cnt].nsb05
           AND gat02 = g_lang
        SELECT gaq03 INTO g_nsb[g_cnt].nsb07
          FROM gaq_file
         WHERE gaq01 = g_nsb[g_cnt].nsb06
           AND gaq02 = g_lang
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    
    END FOREACH
    CALL g_nsb.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt-1               #告訴I.單身筆數
 
END FUNCTION
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nsb TO s_nsb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
                              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION trans_code
         LET g_action_choice="trans_code"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
      ON ACTION controls                                  #No.FUN-6A0092                                                          
         CALL cl_set_head_visible("","AUTO")                #No.FUN-6A0092  
 
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
   
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i200_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("nsa01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("nsa01",FALSE)
    END IF
 
END FUNCTION
 
 
FUNCTION i200_set_entry_b()
 
    CALL cl_set_comp_entry("nsb05,nsb06,nsb08,nsb09,nsb10,nsb11,nsb12,nsb13
                            nsb14,nsb15,nsb18,nsb21",TRUE)
 
END FUNCTION
 
FUNCTION i200_set_no_entry_b()
 
#    IF g_nsb[l_ac].nsb04 = '1' THEN
#        CALL cl_set_comp_entry("nsb05,nsb06",FALSE)
#    END IF
    IF g_nsb[l_ac].nsb04 = '2' THEN
        CALL cl_set_comp_entry("nsb08,nsb09,nsb10",FALSE)
    END IF
    IF g_nsb[l_ac].nsb04 = '3' THEN
        CALL cl_set_comp_entry("nsb05,nsb06,nsb08,nsb09,nsb10",FALSE)
    END IF
    IF (g_nsb[l_ac].nsb04 = '4' OR g_nsb[l_ac].nsb04 = '5' OR 
       g_nsb[l_ac].nsb04 = '41') THEN
        CALL cl_set_comp_entry("nsb05,nsb06,nsb08,nsb09,nsb10",FALSE)
    END IF
    IF (g_nsb[l_ac].nsb04 = '6' OR g_nsb[l_ac].nsb04 = '61' OR 
        g_nsb[l_ac].nsb04 = '62' OR g_nsb[l_ac].nsb04 = '63'
        OR g_nsb[l_ac].nsb04 = '8') THEN
        CALL cl_set_comp_entry("nsb05,nsb06,nsb08,nsb09,nsb10",FALSE)
    END IF
    IF g_nsb[l_ac].nsb04 = '7' THEN
        CALL cl_set_comp_entry("nsb05,nsb06,nsb08,nsb09,nsb10",FALSE)
    END IF
    IF g_nsb[l_ac].nsb04 > = '91' THEN
        CALL cl_set_comp_entry("nsb05,nsb06",FALSE)
    END IF
    IF g_nsb[l_ac].nsb04 = '1' AND g_nsb[l_ac].nsb08 = 'N' THEN
        CALL cl_set_comp_entry("nsb10",FALSE)
    END IF
    IF g_nsb[l_ac].nsb04 = '1' AND g_nsb[l_ac].nsb08 = 'C' THEN
        CALL cl_set_comp_entry("nsb09",FALSE)
    END IF
    IF g_nsb[l_ac].nsb08 <> 'N' THEN
        CALL cl_set_comp_entry("nsb11,nsb12,nsb13,nsb14,nsb15,nsb18,nsb21",FALSE)
    END IF
     
    #--TQC-910036 start--
    IF cl_null(g_nsb[l_ac].nsb05) AND cl_null(g_nsb[l_ac].nsb06) THEN
        CALL cl_set_comp_entry("nsb06",FALSE)
    END IF
    #--TQC-910036 end----
 
END FUNCTION
 
FUNCTION i200_check_table(p_table)
DEFINE l_cnt   LIKE type_file.num5
DEFINE p_table STRING
DEFINE l_str   STRING
 
   IF (p_table != 'apa_file'
      AND p_table != 'aph_file'
      AND p_table != 'apk_file'
      AND p_table != 'cpf_file'
      AND p_table != 'nma_file'
      AND p_table != 'nme_file'
      AND p_table != 'nmt_file'   #FUN-960162 add
      AND p_table != 'pmc_file'
      AND p_table != 'pmd_file'
      AND p_table != 'pmf_file'
      AND p_table != 'zo_file') THEN
      LET l_cnt = 0 
   ELSE
      LET l_cnt = 1
   END IF
 
   IF l_cnt = 0 THEN
      LET l_str= p_table
      CALL cl_err(l_str,'anm1014',0)
      RETURN 0
   ELSE
      RETURN 1
   END IF
 
END FUNCTION
 
FUNCTION i200_check_field(p_field,p_table)
DEFINE p_field       STRING
DEFINE p_table       STRING
DEFINE l_str         STRING
DEFINE ls_sql        STRING
DEFINE l_status      LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_tok         base.StringTokenizer
DEFINE l_type1       LIKE type_file.chr50
DEFINE l_type        STRING
DEFINE l_data_type   LIKE type_file.chr50
DEFINE g_db_type     LIKE type_file.chr3
DEFINE l_data_length LIKE type_file.chr8         #FUN-A90024
DEFINE l_sch01       LIKE sch_file.sch01         #FUN-A90024
DEFINE l_sch02       LIKE sch_file.sch01         #FUN-A90024
 
 
#--TQC-910036 start---
   CASE
       WHEN g_nsb[l_ac].nsb05  = 'apa_file'
           IF g_nsb[l_ac].nsb06 != 'apa06' THEN
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       WHEN g_nsb[l_ac].nsb05 = 'aph_file'
           IF (g_nsb[l_ac].nsb06 != 'aph13' AND
               g_nsb[l_ac].nsb06 != 'aph18' AND   #FUN-970077 add
               g_nsb[l_ac].nsb06 != 'aph20' AND   #FUN-A20010 add
               g_nsb[l_ac].nsb06 != 'aph19') THEN #FUN-970077 add
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       WHEN g_nsb[l_ac].nsb05 = 'apk_file'   
           IF (g_nsb[l_ac].nsb06 != 'apk03' AND
               g_nsb[l_ac].nsb06 != 'apk04' AND
               g_nsb[l_ac].nsb06 != 'apk05' AND
               g_nsb[l_ac].nsb06 != 'apk06' AND
               g_nsb[l_ac].nsb06 != 'apk07' AND
               g_nsb[l_ac].nsb06 != 'apk08' AND
               g_nsb[l_ac].nsb06 != 'apk12') THEN
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       WHEN g_nsb[l_ac].nsb05 ='cpf_file'   
           IF (g_nsb[l_ac].nsb06 != 'cpf02' AND
               g_nsb[l_ac].nsb06 != 'cpf07' AND
               g_nsb[l_ac].nsb06 != 'cpf11' AND
               g_nsb[l_ac].nsb06 != 'cpf15' AND
               g_nsb[l_ac].nsb06 != 'cpf43' AND
               g_nsb[l_ac].nsb06 != 'cpf44') THEN
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       WHEN g_nsb[l_ac].nsb05 ='nma_file'   
           IF (g_nsb[l_ac].nsb06 != 'nma04' AND
               g_nsb[l_ac].nsb06 != 'nma08' AND
               g_nsb[l_ac].nsb06 != 'nma10' AND  
               g_nsb[l_ac].nsb06 != 'nma39' AND
               g_nsb[l_ac].nsb06 != 'nma44') THEN
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       #FUN-960162 -----------------add start---------------                                                   
       WHEN g_nsb[l_ac].nsb05 ='nmt_file'                                       
           IF (g_nsb[l_ac].nsb06 != 'nmt01' AND                                 
               g_nsb[l_ac].nsb06 != 'nmt02' AND                                 
               g_nsb[l_ac].nsb06 != 'nmt04' AND                                 
               g_nsb[l_ac].nsb06 != 'nmt14') THEN                               
               LET l_str= p_table,"+",p_field                                   
               CALL cl_err(l_str,'anm1013',0)                                   
               RETURN 0,NULL                                                    
           END IF                                                               
       #FUN-960162---------------add end-------------------
       WHEN g_nsb[l_ac].nsb05 ='pmc_file'   
           IF (g_nsb[l_ac].nsb06 != 'pmc081' AND
               g_nsb[l_ac].nsb06 != 'pmc091' AND
               g_nsb[l_ac].nsb06 != 'pmc10'  AND
               g_nsb[l_ac].nsb06 != 'pmc11'  AND
               g_nsb[l_ac].nsb06 != 'pmc24'  AND
               g_nsb[l_ac].nsb06 != 'pmc28'  AND
               g_nsb[l_ac].nsb06 != 'pmc281' AND
               g_nsb[l_ac].nsb06 != 'pmc55' AND   #FUN-960150 add               
               g_nsb[l_ac].nsb06 != 'pmc56' AND   #FUN-960150 add   
               g_nsb[l_ac].nsb06 != 'pmc904') THEN
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       WHEN g_nsb[l_ac].nsb05 ='nme_file'   
           IF (g_nsb[l_ac].nsb06 != 'nme01' AND
               g_nsb[l_ac].nsb06 != 'nme02' AND
               g_nsb[l_ac].nsb06 != 'nme04' AND
               g_nsb[l_ac].nsb06 != 'nme08' AND
               g_nsb[l_ac].nsb06 != 'nme10' AND
               g_nsb[l_ac].nsb06 != 'nme12' AND
               g_nsb[l_ac].nsb06 != 'nme13' AND
               g_nsb[l_ac].nsb06 != 'nme16' AND
               g_nsb[l_ac].nsb06 != 'nme22' AND
               g_nsb[l_ac].nsb06 != 'nme25') THEN
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       WHEN g_nsb[l_ac].nsb05 ='pmd_file'   
           IF (g_nsb[l_ac].nsb06 != 'pmd02' AND
               g_nsb[l_ac].nsb06 != 'pmd03' AND
               g_nsb[l_ac].nsb06 != 'pmd07' AND
               g_nsb[l_ac].nsb06 != 'pmd07') THEN
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       WHEN g_nsb[l_ac].nsb05 ='pmf_file'   
           IF (g_nsb[l_ac].nsb06 != 'pmf02' AND
               g_nsb[l_ac].nsb06 != 'pmf03' AND
               g_nsb[l_ac].nsb06 != 'pmf09' AND
               g_nsb[l_ac].nsb06 != 'pmf11' AND    #FUN-970077 add 
               g_nsb[l_ac].nsb06 != 'pmf13' AND    #FUN-A20010 add
               g_nsb[l_ac].nsb06 != 'pmf12' AND    #FUN-970077 add
               g_nsb[l_ac].nsb06 != 'pmf10') THEN 
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       WHEN g_nsb[l_ac].nsb05 ='zo_file'   
           IF (g_nsb[l_ac].nsb06 ! = 'zo02'  AND
               g_nsb[l_ac].nsb06 ! = 'zo041' AND 
               g_nsb[l_ac].nsb06 ! = 'zo05'  AND
               g_nsb[l_ac].nsb06 ! = 'zo06'  AND
               g_nsb[l_ac].nsb06 ! = 'zo09') THEN
               LET l_str= p_table,"+",p_field
               CALL cl_err(l_str,'anm1013',0)
               RETURN 0,NULL
           END IF
       OTHERWISE
           RETURN 0,NULL
           EXIT CASE
   END CASE 
   #--TQC-910036 end-------------------------------
 
   LET g_db_type=cl_db_get_database_type()
   LET l_type = NULL
   LET l_type1= NULL
   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構  
   #CASE g_db_type  
   #    WHEN "IFX" 
   #         LET ls_sql =
   #             "SELECT coltype",
   #             " FROM syscolumns c,systables t",
   #             " WHERE c.tabid=t.tabid AND t.tabname='",p_table,"'",
   #             "   AND c.colname='",p_field,"'"
   #    WHEN "ORA"   
   #         LET ls_sql =
   #             "SELECT DATA_TYPE FROM user_tab_columns",
   #             " WHERE lower(table_name)='",p_table,"'",
   #             "   AND lower(column_name)='",p_field,"'"
   #END CASE   
   #PREPARE i200_pre1 FROM ls_sql
   #DECLARE i200_sys1 CURSOR FOR i200_pre1
   #OPEN i200_sys1
   #FETCH i200_sys1 INTO l_type1
   LET l_sch01 = p_table
   LET l_sch02 = p_field
   SELECT COUNT(*) INTO l_cnt FROM sch_file 
     WHERE sch01 = l_sch01 AND sch02 = l_sch02
   IF l_cnt = 0 THEN
      LET l_type = ''
   ELSE
      CALL cl_get_column_info('ds', p_table, p_field) 
          RETURNING l_type1, l_data_length
   END IF
   #---FUN-A90024---end-------  
   LET l_type = l_type1 CLIPPED
   LET l_type = l_type.trim()
   IF cl_null(l_type) THEN
      LET l_str= p_table,"+",p_field
      CALL cl_err(l_str,NOTFOUND,0)
      RETURN 0,NULL
   ELSE
      #---FUN-A90024---start-----
      #CASE g_db_type  
      #    WHEN "IFX" 
      #         CASE l_type
      #              WHEN '0'         LET l_data_type = 'C'
      #              WHEN '13'        LET l_data_type = 'C'
      #              WHEN '7'         LET l_data_type = 'D'
      #              OTHERWISE        LET l_data_type = 'N'
      #         END CASE
      #    WHEN "ORA" 
      #         CASE l_type
      #              WHEN 'VARCHAR2'              LET l_data_type = 'C'
      #              WHEN 'VARCHAR'               LET l_data_type = 'C'
      #              WHEN 'DATE'                  LET l_data_type = 'D'
      #              OTHERWISE                    LET l_data_type = 'N'
      #         END CASE
      #END CASE
      CASE l_type
           WHEN 'char'                  LET l_data_type = 'C'
           WHEN 'varchar2'              LET l_data_type = 'C'
           WHEN 'varchar'               LET l_data_type = 'C'
           WHEN 'nvarchar'              LET l_data_type = 'C'
           WHEN 'nvarchar2'             LET l_data_type = 'C'
           WHEN 'date'                  LET l_data_type = 'D'
           OTHERWISE                    LET l_data_type = 'N'
      END CASE
      #---FUN-A90024---end-------        
   END IF
   RETURN 1,l_data_type
END FUNCTION
 
FUNCTION i200_gettype(p_cnt,l_type,l_length,l_scale)
DEFINE p_cnt LIKE type_file.num5
DEFINE l_length   LIKE type_file.num20_6
DEFINE l_length1  LIKE type_file.chr20
DEFINE l_type     LIKE ztb_file.ztb03
DEFINE l_sql      STRING
DEFINE g_err      STRING
DEFINE l_scale      LIKE type_file.num5 
 
        CASE WHEN l_type = 'varchar2'
                  LET l_length1=g_nsb[l_ac].nsb16 USING "####"
                  LET g_nsb[l_ac].nsb16 = l_length1 CLIPPED
             WHEN l_type = 'number'
                  LET l_length1=g_nsb[l_ac].nsb16 USING "####"
                  LET g_nsb[l_ac].nsb16=l_length1 CLIPPED
                  LET l_length1=l_scale
#                  IF l_length1<>'0' THEN
#                     LET g_nsb[l_ac].nsb16 = g_nsb[l_ac].nsb16 CLIPPED,',',l_length1 CLIPPED
#                  END IF
             WHEN l_type = 'date'
                  LET g_nsb[l_ac].nsb16 = 10
        END CASE
 
END FUNCTION
 
FUNCTION i200_set_no_required_b()
  CALL cl_set_comp_required("nsb05,nsb06",FALSE)
END FUNCTION
 
FUNCTION i200_set_required_b()   
  IF g_nsb[l_ac].nsb04 = '2' THEN
      CALL cl_set_comp_required("nsb05,nsb06",TRUE)
  END IF
END FUNCTION
 
FUNCTION i200_copy()
    DEFINE
        l_newno1        LIKE nmv_file.nmv01,
        l_oldno1        LIKE nmv_file.nmv01,
        p_cmd           LIKE type_file.chr1,      
        l_input         LIKE type_file.chr1      
    DEFINE l_cnt        LIKE type_file.num5
 
    IF g_nsa.nsa01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    BEGIN WORK
 
    INPUT l_newno1 FROM nsa01
 
        BEFORE INPUT
         LET l_input='N'
         
        AFTER FIELD nsa01      
           IF NOT cl_null(l_newno1) THEN
               SELECT count(*) INTO l_cnt FROM nsa_file
                WHERE nsa01 = l_newno1
               IF l_cnt > 0 THEN   #資料重複
                  CALL cl_err(l_newno1,-239,0)
                  LET g_nsa.nsa01 = g_nsa01_t
                  NEXT FIELD nsa01
               END IF
           END IF
 
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_nsa.nsa01
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM nsa_file
        WHERE nsa01=g_nsa.nsa01
        INTO TEMP x
    UPDATE x
        SET nsa01=l_newno1
    INSERT INTO nsa_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","nsa_file",g_nsa.nsa01,"",SQLCA.sqlcode,"","",0) #No.FUN-B80067---調整至回滾事務前--- 
        ROLLBACK WORK
        RETURN 
    END IF
 
    DROP TABLE y
 
    SELECT * FROM nsb_file         #單身複製
        WHERE nsb01=g_nsa.nsa01
        INTO TEMP y
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)
       RETURN
    END IF
 
    UPDATE y SET nsb01=l_newno1
 
    INSERT INTO nsb_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","nsb_file","","",SQLCA.sqlcode,"","",1) #No.FUN-B80067---調整至回滾事務前--- 
       ROLLBACK WORK
       RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
    LET l_oldno1 = g_nsa.nsa01
    SELECT nsa_file.* INTO g_nsa.* 
      FROM nsa_file WHERE nsa01 = l_newno1
    CALL i200_b()
    #FUN-C80046---begin
    #SELECT nsa_file.* INTO g_nsa.* 
    #  FROM nsa_file WHERE nsa01 = l_oldno1
    #CALL i200_show()
    #FUN-C80046---end
END FUNCTION
 
