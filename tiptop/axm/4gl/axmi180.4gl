# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi180.4gl
# Descriptions...: 產品別預計產量維護作業
# Date & Author..: 00/12/28 By Mandy
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.MOD-560204 05/06/28 By pengu  查詢出資料後，點選[修改]鈕，[新增]鈕也無任何回應
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.TQC-650082 06/06/14 By alexstar (下一頁)(結尾)靠右
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0079 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740135 07/04/23 By arman “生產數量”錄入負數時候，系統沒有提示錯誤，只是光標停那不動
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-840049 08/04/11 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0025 10/12/15 By chenying opn03為smallint型，需要去掉單引號
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_opm           RECORD LIKE opm_file.*,
    g_opm_t         RECORD LIKE opm_file.*,
    g_opm_o         RECORD LIKE opm_file.*,
    g_opm01_t       LIKE opm_file.opm01,
    g_opm02_t       LIKE opm_file.opm02,
    g_opm03_t       LIKE opm_file.opm03,
    g_opn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        opn04       LIKE opn_file.opn04,   #月份
        opn05       LIKE opn_file.opn05    #計劃數量
                    END RECORD,
    g_opn_t         RECORD                 #程式變數 (舊值)
        opn04       LIKE opn_file.opn04,   #月份
        opn05       LIKE opn_file.opn05    #計劃數量
                    END RECORD,
    g_ima02         LIKE ima_file.ima02,
    g_ima021        LIKE ima_file.ima021,
   #g_wc,g_wc2      LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(300)
   #g_sql           LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(300)
    g_wc,g_wc2      STRING, #TQC-630166  
    g_sql           STRING, #TQC-630166    
    g_t1            LIKE type_file.chr3,                  #No.FUN-680137 VARCHAR(3)
    g_rec_b         LIKE type_file.num5,   #單身筆數      #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_cmd           LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(200)
    g_rpg           ARRAY[36] OF LIKE type_file.num5    #第 xxx 期時距期別所含的日曆天數。#No.FUN-680137 SMALLINT 
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_head1    STRING   
 
 
#主程式開始
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING  #No.TQC-720019
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680137
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680137 SMALLINT
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE   l_table        STRING,                      ### FUN-840049 ###                                                                
         g_str          STRING                       ### FUN-840049 ###                                                                
 
 
MAIN
#DEFINE       l_time    LIKE type_file.chr8            #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
 
### *** FUN-840049 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "opm01.opm_file.opm01,",
                "oba02.oba_file.oba02,",
                "opm02.opm_file.opm02,",
                "opm03.opm_file.opm03,",
                "opn04.opn_file.opn04,",
                "opn05.opn_file.opn05"
    LET l_table = cl_prt_temptable('axmi180',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                        
                " VALUES(?, ?, ?, ?, ?,?)"                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
    LET g_forupd_sql =
         "SELECT * FROM opm_file WHERE opm01=? AND opm02=? AND opm03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i180_cl CURSOR FROM g_forupd_sql
    LET p_row = 2 LET p_col = 10
 
    OPEN WINDOW i180_w AT p_row,p_col             #顯示畫面
         WITH FORM "axm/42f/axmi180"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL i180_menu()
    CLOSE WINDOW i180_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION i180_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_opn.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_opm.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
        opm01,opm02,opm03
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE WHEN INFIELD(opm01)
#                 CALL q_oba(05,03,g_opm.opm01) RETURNING g_opm.opm01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oba"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO opm01
                  NEXT FIELD opm01
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('opmuser', 'opmgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON opn04,opn05
            FROM s_opn[1].opn04,s_opn[1].opn05
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
 
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT UNIQUE opm01,opm02,opm03 FROM opm_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1,2,3 "
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE opm01,opm02,opm03 ",
                   "  FROM opm_file, opn_file",
                   " WHERE opm01 = opn01",
                   "   AND opm02 = opn02",
                   "   AND opm03 = opn03",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1,2,3 "
    END IF
 
    PREPARE i180_prepare FROM g_sql
    DECLARE i180_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i180_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
#       LET g_sql="SELECT COUNT(*) FROM opm_file WHERE ",g_wc CLIPPED      #No.TQC-720019
        LET g_sql_tmp="SELECT UNIQUE opm01,opm02,opm03 FROM opm_file WHERE ",g_wc CLIPPED, #No.TQC-720019
                      " INTO TEMP x "  #No.TQC-720019
    ELSE
#       LET g_sql = "SELECT opm01,opm02,opm03 ",      #No.TQC-720019
        LET g_sql_tmp = "SELECT opm01,opm02,opm03 ",  #No.TQC-720019
                    "  FROM opm_file, opn_file",
                    " WHERE opm01 = opn01",
                    "   AND opm02 = opn02",
                    "   AND opm03 = opn03",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " ORDER BY 1,2,3 ",
                    " INTO TEMP x "
    END IF
    #No.TQC-720019  --Begin
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
#   PREPARE i180_precount_x  FROM g_sql      #No.TQC-720019
    PREPARE i180_precount_x  FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i180_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
    #No.TQC-720019  --End  
 
    PREPARE i180_precount FROM g_sql
    DECLARE i180_count CURSOR FOR i180_precount
END FUNCTION
 
FUNCTION i180_menu()
 
   WHILE TRUE
      CALL i180_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i180_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i180_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i180_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i180_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i180_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i180_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_opn),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_opm.opm01 IS NOT NULL THEN
                LET g_doc.column1 = "opm01"
                LET g_doc.column2 = "opm02"
                LET g_doc.value1 = g_opm.opm01
                LET g_doc.value2 = g_opm.opm02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i180_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_opn.clear()
    INITIALIZE g_opm.* LIKE opm_file.*             #DEFAULT 設定
    LET g_opm01_t = NULL
    LET g_opm02_t = NULL
    LET g_opm03_t = NULL
    LET g_opm_o.* = g_opm.*
    #FUN-980010 add plant & legal 
    LET g_opm.opmplant = g_plant 
    LET g_opm.opmlegal = g_legal 
    #FUN-980010 end plant & legal 
    
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_opm.opm03 = YEAR(g_today)    #年度
        CALL i180_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_opm.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_opm.opm01 IS NULL OR
           g_opm.opm02 IS NULL OR
           g_opm.opm03 IS NULL THEN        # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_opm.opmoriu = g_user      #No.FUN-980030 10/01/04
        LET g_opm.opmorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO opm_file VALUES (g_opm.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_opm.opm01,SQLCA.sqlcode,1)   #No.FUN-660167
            CALL cl_err3("ins","opm_file",g_opm.opm01,g_opm.opm02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        SELECT opm1,opm2,opm3 INTO g_opm.opm01,g_opm.opm02,g_opm.opm03 FROM opm_file
            WHERE opm01 = g_opm.opm01
              AND opm02 = g_opm.opm02
              AND opm03 = g_opm.opm03
        LET g_opm01_t = g_opm.opm01        #保留舊值,產品別
        LET g_opm02_t = g_opm.opm02        #保留舊值,版本
        LET g_opm03_t = g_opm.opm03        #保留舊值,年度
        LET g_opm_t.* = g_opm.*
        CALL g_opn.clear()
        LET g_rec_b = 0
        CALL i180_g()                   #產生單身預設值
        CALL i180_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i180_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_opm.opm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_opm01_t = g_opm.opm01
    LET g_opm02_t = g_opm.opm02
    LET g_opm03_t = g_opm.opm03
    LET g_opm_o.* = g_opm.*
    BEGIN WORK
 
    OPEN i180_cl USING g_opm.opm01,g_opm.opm02,g_opm.opm03
    IF STATUS THEN
       CALL cl_err("OPEN i180_cl:", STATUS, 1)
       CLOSE i180_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i180_cl INTO g_opm.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_opm.opm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i180_cl ROLLBACK WORK RETURN
    END IF
    CALL i180_show()
    WHILE TRUE
        CALL i180_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_opm.*=g_opm_t.*
            CALL i180_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_opm.opm01 != g_opm01_t OR g_opm.opm02 != g_opm02_t
           OR g_opm.opm03 != g_opm03_t THEN            # 更改單號
            UPDATE opn_file SET opn01 = g_opm.opm01,
                                opn02 = g_opm.opm02,
                                opn03 = g_opm.opm03
                WHERE opn01 = g_opm01_t
                  AND opn02 = g_opm02_t
                  AND opn03 = g_opm03_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('cod',SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("upd","opn_file",g_opm01_t,g_opm02_t,SQLCA.sqlcode,"","cod",1)  #No.FUN-660167
                CONTINUE WHILE 
            END IF
        END IF
        UPDATE opm_file SET opm_file.* = g_opm.*
            WHERE opm01=g_opm01_t AND opm02=g_opm02_t AND opm03=g_opm03_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_opm.opm01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","opm_file",g_opm01_t,g_opm02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i180_cl
	COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i180_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入      #No.FUN-680137 VARCHAR(1)
    l_n1            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改               #No.FUN-680137 VARCHAR(1)
    l_exit_input    LIKE type_file.num5           #No.FUN-680137 SMALLINT
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME g_opm.opm01,g_opm.opm02,g_opm.opm03
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i180_set_entry(p_cmd)
            CALL i180_set_no_entry(p_cmd) RETURNING l_exit_input
            IF l_exit_input THEN
                #--No: MOD-560204 add
                CALL i180_set_entry(p_cmd)
                CALL cl_err('','axm-914',1)
               #--end
                EXIT INPUT
            END IF
            LET g_before_input_done = TRUE
 
        AFTER FIELD opm01 #產品別
            IF NOT cl_null(g_opm.opm01) THEN
                CALL i180_opm01('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0) NEXT FIELD opm01
                END IF
            END IF
 
        AFTER FIELD opm03 #年度
            IF NOT cl_null(g_opm.opm03) THEN
                IF g_opm_t.opm01 != g_opm.opm01 OR g_opm_t.opm02 != g_opm.opm02
                   OR g_opm_t.opm03 != g_opm.opm03 THEN
                    SELECT COUNT(*) INTO l_n FROM opm_file
                        WHERE opm01=g_opm.opm01
                          AND opm02=g_opm.opm02
                          AND opm03=g_opm.opm03
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_opm.opm01 = g_opm_t.opm01
                        LET g_opm.opm02 = g_opm_t.opm02
                        LET g_opm.opm03 = g_opm_t.opm03
                        NEXT FIELD opm01
                    END IF
                END IF
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(opm01)
#                 CALL q_oba(05,03,g_opm.opm01) RETURNING g_opm.opm01
#                 CALL FGL_DIALOG_SETBUFFER( g_opm.opm01 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oba"
                  LET g_qryparam.default1 = g_opm.opm01
                  CALL cl_create_qry() RETURNING g_opm.opm01
#                  CALL FGL_DIALOG_SETBUFFER( g_opm.opm01 )
                  DISPLAY BY NAME g_opm.opm01
                  NEXT FIELD opm01
           END CASE
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(opm01) THEN
      #          LET g_opm.* = g_opm_t.*
      #          DISPLAY BY NAME g_opm.*
      #          NEXT FIELD opm01
      #      END IF
      #MOD-650015 --start
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
FUNCTION i180_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_opm.* TO NULL               #No.FUN-6B0079 add
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    MESSAGE ""
    CALL i180_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_opm.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i180_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_opm.* TO NULL
    ELSE
        OPEN i180_count
        FETCH i180_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i180_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i180_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i180_cs INTO g_opm.opm01,
                                             g_opm.opm02,g_opm.opm03
        WHEN 'P' FETCH PREVIOUS i180_cs INTO g_opm.opm01,
                                             g_opm.opm02,g_opm.opm03
        WHEN 'F' FETCH FIRST    i180_cs INTO g_opm.opm01,
                                             g_opm.opm02,g_opm.opm03
        WHEN 'L' FETCH LAST     i180_cs INTO g_opm.opm01,
                                             g_opm.opm02,g_opm.opm03
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
 
            FETCH ABSOLUTE g_jump i180_cs INTO g_opm.opm01,
                                               g_opm.opm02,g_opm.opm03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_opm.opm01,SQLCA.sqlcode,0)
        INITIALIZE g_opm.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_opm.* FROM opm_file WHERE opm01=g_opm.opm01 AND opm02=g_opm.opm02 AND opm03=g_opm.opm03
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_opm.opm01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","opm_file",g_opm.opm01,g_opm.opm02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_opm.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_opm.opmuser      #FUN-4C0057 add
    LET g_data_group = g_opm.opmgrup      #FUN-4C0057 add
    LET g_data_plant = g_opm.opmplant #FUN-980030
    CALL i180_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i180_show()
    LET g_opm_t.* = g_opm.*                #保存單頭舊值
    DISPLAY BY NAME g_opm.opm01,g_opm.opm02,g_opm.opm03
    CALL i180_opm01('d')
    CALL i180_b_fill(g_wc2)                 #單身
    CALL i180_sum()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i180_x()
 DEFINE  l_sure  LIKE type_file.chr1     #No.FUN-680137  VARCHAR(1) 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_opm.opm01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i180_cl USING g_opm.opm01,g_opm.opm02,g_opm.opm03
    IF STATUS THEN
       CALL cl_err("OPEN i180_cl:", STATUS, 1)
       CLOSE i180_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i180_cl INTO g_opm.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_opm.opm01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i180_cl ROLLBACK WORK RETURN
    END IF
    CALL i180_show()
    IF cl_exp(0,0,g_opm.opmacti) THEN
        LET g_chr=g_opm.opmacti
        IF g_opm.opmacti='Y' THEN
            LET g_opm.opmacti='N'
        ELSE
            LET g_opm.opmacti='Y'
        END IF
        UPDATE opm_file                    #更改有效碼
            SET opmacti=g_opm.opmacti
            WHERE opm01=g_opm.opm01
              AND opm02=g_opm.opm02
              AND opm03=g_opm.opm03
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_opm.opm01,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","opm_file",g_opm.opm01,g_opm.opm02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_opm.opmacti=g_chr
        END IF
    END IF
    CLOSE i180_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i180_r()
    DEFINE l_chr,l_sure  LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_opm.opm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i180_cl USING g_opm.opm01,g_opm.opm02,g_opm.opm03
    IF STATUS THEN
       CALL cl_err("OPEN i180_cl:", STATUS, 1)
       CLOSE i180_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i180_cl INTO g_opm.*
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_opm.opm01,SQLCA.sqlcode,0)
      CLOSE i180_cl ROLLBACK WORK  RETURN
    END IF
    CALL i180_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "opm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "opm02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_opm.opm01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_opm.opm02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM opm_file WHERE opm01 = g_opm.opm01
                               AND opm02 = g_opm.opm02
                               AND opm03 = g_opm.opm03
        DELETE FROM opn_file WHERE opn01 = g_opm.opm01
                               AND opn02 = g_opm.opm02
                               AND opn03 = g_opm.opm03
        CLEAR FORM
        CALL g_opn.clear()
        INITIALIZE g_opm.* TO NULL
        DROP TABLE x  #No.TQC-720019
        PREPARE i180_precount_x2 FROM g_sql_tmp  #No.TQC-720019
        EXECUTE i180_precount_x2                 #No.TQC-720019
        OPEN i180_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE i180_cs
           CLOSE i180_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH i180_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i180_cs
           CLOSE i180_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i180_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i180_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i180_fetch('/')
        END IF
    END IF
    CLOSE i180_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i180_b()
DEFINE
    l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_row,l_col     LIKE type_file.num5,        #分段輸入之行,列數        #No.FUN-680137 SMALLINT
    l_n,l_cnt,l_i   LIKE type_file.num5,        #檢查重複用               #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,        #單身鎖住否               #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,        #處理狀態                 #No.FUN-680137 VARCHAR(1)
    g_cmd           LIKE gbc_file.gbc05,        #No.FUN-680137  VARCHAR(100)
    l_possible      LIKE type_file.num5,        #用來設定判斷重複的可能性 #No.FUN-680137 SMALLINT
    l_day           LIKE type_file.num10,       #No.FUN-680137 INTEGER
    l_flag          LIKE type_file.num10,       #No.FUN-680137 INTEGER
    l_jump          LIKE type_file.num5,        #判斷是否跳過AFTER ROW的處理 #No.FUN-680137 SMALLINT
    l_allow_insert  LIKE type_file.num5,        #可新增否                    #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5         #可刪除否                    #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF g_opm.opm01 IS NULL OR
       g_opm.opm02 IS NULL OR
       g_opm.opm03 IS NULL THEN
       RETURN
    END IF
    IF g_opm.opmacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_opm.opm01,'aom-000',0) #本資料為無效資料, 不可更改
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT opn04,opn05 ",
      " FROM opn_file ",
      "  WHERE opn01= ? ",
      "   AND opn02= ? ",
      "   AND opn03= ? ",
      "   AND opn04= ? ",
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i180_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_opn
              WITHOUT DEFAULTS
              FROM s_opn.*
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
            BEGIN WORK
 
            OPEN i180_cl USING g_opm.opm01,g_opm.opm02,g_opm.opm03
            IF STATUS THEN
               CALL cl_err("OPEN i180_cl:", STATUS, 1)
               CLOSE i180_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i180_cl INTO g_opm.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_opm.opm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i180_cl ROLLBACK WORK RETURN
            END IF
           #IF g_opn_t.opn04 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_opn_t.* = g_opn[l_ac].*  #BACKUP
 
                OPEN i180_bcl USING g_opm.opm01,g_opm.opm02,g_opm.opm03,g_opn_t.opn04
                IF STATUS THEN
                    CALL cl_err("OPEN i180_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i180_bcl INTO g_opn[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_opn_t.opn04,SQLCA.sqlcode,1)
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
            INSERT INTO opn_file(opn01,opn02,opn03,opn04,opn05,opnplant,opnlegal)  #FUN-980005 add plant & legal 
            VALUES(g_opm.opm01,g_opm.opm02,g_opm.opm03,
                   g_opn[l_ac].opn04,g_opn[l_ac].opn05,
                   g_plant,g_legal)   #FUN-980010
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_opn[l_ac].opn04,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","opn_file",g_opm.opm01,g_opn[l_ac].opn04,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE 'INSERT O.K'
	        COMMIT WORK
                CALL i180_sum()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_opn[l_ac].* TO NULL          #900423
            LET g_opn_t.* = g_opn[l_ac].*             #新輸入資料
            LET g_opn[l_ac].opn05 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD opn04
 
        AFTER FIELD opn04                        #check 月份是否重複
            IF NOT cl_null(g_opn[l_ac].opn04) THEN
                IF g_opn[l_ac].opn04 != g_opn_t.opn04 OR
                   g_opn_t.opn04 IS NULL THEN
                    SELECT COUNT(*) INTO l_n FROM opn_file
                        WHERE opn01 = g_opm.opm01
                          AND opn02 = g_opm.opm02
                          AND opn03 = g_opm.opm03
                          AND opn04 = g_opn[l_ac].opn04
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_opn[l_ac].opn04 = g_opn_t.opn04
                        NEXT FIELD opn04
                    END IF
                END IF
                IF g_opn[l_ac].opn04 < 1 OR g_opn[l_ac].opn04 > 12 THEN
                    NEXT FIELD opn04
                END IF
            END IF
 
        AFTER FIELD opn05 #生產數量
            IF NOT cl_null(g_opn[l_ac].opn05) THEN
                IF g_opn[l_ac].opn05 < 0 THEN
                    CALL cl_err("",'axr-610',0)           #No.TQC-740135
                    NEXT FIELD opn05
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_opn_t.opn04 >=1 AND g_opn_t.opn04 <= 12 AND
               g_opn_t.opn04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM opn_file
                    WHERE opn01 = g_opm.opm01
                      AND opn02 = g_opm.opm02
                      AND opn03 = g_opm.opm03
                      AND opn04 = g_opn_t.opn04
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_opn_t.opn05,SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("del","opn_file",g_opm.opm01,g_opn_t.opn04,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL i180_sum()
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_opn[l_ac].* = g_opn_t.*
               CLOSE i180_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_opn[l_ac].opn04,-263,1)
                LET g_opn[l_ac].* = g_opn_t.*
            ELSE
                UPDATE opn_file SET
                         opn04 = g_opn[l_ac].opn04,
                         opn05 = g_opn[l_ac].opn05
                    WHERE opn01=g_opm.opm01
                      AND opn02=g_opm.opm02
                      AND opn03=g_opm.opm03
                      AND opn04=g_opn_t.opn04
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_opn[l_ac].opn04,SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("upd","opn_file",g_opm.opm01,g_opn_t.opn04,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    LET g_opn[l_ac].* = g_opn_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
		    COMMIT WORK
                    CALL i180_sum()
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_opn[l_ac].* = g_opn_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_opn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i180_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i180_bcl
            COMMIT WORK
 
       #ON ACTION CONTROLN
       #    CALL i180_b_askkey()
       #    EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(opn04) AND l_ac > 1 THEN
                LET g_opn[l_ac].* = g_opn[l_ac-1].*
                NEXT FIELD opn04
            END IF
 
        ON ACTION controls                             #No.FUN-6A0092
           CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
  
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
 
    CLOSE i180_bcl
    COMMIT WORK
 
    MESSAGE ''
 
#   CALL i180_delall() #CHI-C30002 mark
    CALL i180_delHeader()     #CHI-C30002 add
END FUNCTION
 
FUNCTION i180_sum()
    DEFINE l_opn05  LIKE opn_file.opn05
 
    SELECT SUM(opn05) INTO l_opn05 FROM opn_file
        WHERE opn01 = g_opm.opm01
          AND opn02 = g_opm.opm02
          AND opn03 = g_opm.opm03
    IF cl_null(l_opn05) THEN LET l_opn05 = 0 END IF
    DISPLAY l_opn05 TO FORMONLY.sum
END FUNCTION
 
FUNCTION i180_g()
    DEFINE i       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
           j       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
           l_mm    LIKE type_file.num5,          #No.FUN-680137 smallint  #月
           l_dd    LIKE type_file.num5,          #No.FUN-680137 smallint  #日
           l_yy    LIKE type_file.num5           #No.FUN-680137 smallint  #年
 
    LET g_success='Y'
    BEGIN WORK
    #將 array 裡的資料 insert into opn_file
    FOR i = 1 TO 12
        LET g_opn[i].opn04 = i
        INSERT INTO opn_file (opn01,opn02,opn03,opn04,opn05,opnplant,opnlegal)  #FUN-980010 add plant & legal 
                  VALUES(g_opm.opm01,g_opm.opm02,g_opm.opm03,
                         g_opn[i].opn04,0,g_plant,g_legal)
        IF STATUS OR SQLCA.SQLCODE THEN
#           CALL cl_err('ins opn:',SQLCA.SQLCODE,1)   #No.FUN-660167
            CALL cl_err3("ins","opn_file",g_opm.opm01,g_opn[i].opn04,SQLCA.SQLCODE,"","ins opn",1)  #No.FUN-660167
            LET g_success='N'
        END IF
    END FOR
    IF g_success='N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
    CALL i180_b_fill(' 1=1')
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i180_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM opm_file WHERE opm01 = g_opm.opm01
                                AND opm02=g_opm.opm02
                                AND opm03=g_opm.opm03
         INITIALIZE g_opm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i180_delall()
#   SELECT COUNT(*) INTO g_cnt FROM opn_file
#       WHERE opn01=g_opm.opm01
#         AND opn02=g_opm.opm02
#         AND opn03=g_opm.opm03
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM opm_file WHERE opm01 = g_opm.opm01
#                             AND opm02=g_opm.opm02
#                             AND opm03=g_opm.opm03
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i180_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    CONSTRUCT l_wc2 ON opn04,opn05
            FROM s_opn[1].opn04,s_opn[1].opn05
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
    CALL i180_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i180_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql =
        "SELECT opn04,opn05 ",
        " FROM opn_file",
        " WHERE opn01 ='",g_opm.opm01,"'",  #單頭
        "   AND opn02 ='",g_opm.opm02,"'",
#       "   AND opn03 ='",g_opm.opm03,"'",   #TQC-AB0025 mark
        "   AND opn03 = ",g_opm.opm03    ,   #TQC-AB0025 add
        "   AND ",p_wc2 CLIPPED,            #單身
        " ORDER BY 1"
 
    PREPARE i180_pb FROM g_sql
    DECLARE opn_curs                       #CURSOR
        CURSOR WITH HOLD FOR i180_pb
 
    CALL g_opn.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH opn_curs INTO g_opn[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_opn.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i180_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_opn TO s_opn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i180_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i180_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i180_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i180_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i180_fetch('L')
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
 
 
FUNCTION i180_opm01(p_cmd)  #產品類別
    DEFINE l_oba02   LIKE oba_file.oba02,
           p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
    LET g_errno = " "
    SELECT oba02 INTO l_oba02 FROM oba_file
        WHERE oba01 = g_opm.opm01
 
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-005' #無此產品分類
          OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF cl_null(g_errno) THEN
         DISPLAY l_oba02 TO FORMONLY.oba02
     END IF
END FUNCTION
 
FUNCTION i180_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    sr              RECORD
        opm01       LIKE opm_file.opm01,
        oba02       LIKE oba_file.oba02,
        opm02       LIKE opm_file.opm02,
        opm03       LIKE opm_file.opm03,
        opn04       LIKE opn_file.opn04,
        opn05       LIKE opn_file.opn05
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680137 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #No.FUN-680137 VARCHAR(40)
 
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-840049 *** ##                                                      
   CALL cl_del_data(l_table)                                                                                                        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           #FUN-840049                                   
   #------------------------------ CR (2) ------------------------------#
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT opm01,oba02,opm02,opm03,opn04,opn05 ",
              "  FROM opm_file LEFT OUTER JOIN oba_file ON opm_file.opm01=oba_file.oba01,opn_file",
              " WHERE opm01 = opn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
              "   AND opm02 = opn02 ",
              "   AND opm03 = opn03 ",
              " ORDER BY opm01,opm02,opm03,opn04 "
    PREPARE i180_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
    DECLARE i180_co                           # CURSOR
        CURSOR WITH HOLD FOR i180_p1
 
    LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi180') RETURNING l_name                                         #FUN-840049 mark
#   START REPORT i180_rep TO l_name                                                    #FUN-840049 mark
    LET l_n = 0
    FOREACH i180_co INTO sr.*
        LET l_n = l_n + 1
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
 
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-840049 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                 sr.opm01,sr.oba02,sr.opm02,sr.opm03,sr.opn04,sr.opn05
     #------------------------------ CR (3) ------------------------------#
 
#       OUTPUT TO REPORT i180_rep(sr.*)                                                #FUN-840049 mark
    END FOREACH
 
#   FINISH REPORT i180_rep                                                             #FUN-840049 mark
 
    CLOSE i180_co
    ERROR ""
 
#No.FUN-840049--begin                                                                                                               
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(g_wc,'opm01,opm02,opm03')                                                                             
              RETURNING g_wc                                                                                                       
      END IF                                                                                                                        
#No.FUN-840049--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-840049 **** ##                                                        
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = g_wc                                                                                                               
    CALL cl_prt_cs3('axmi180','axmi180',g_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#
 
#   CALL cl_prt(l_name,' ','1',g_len)                                                  #FUN-840049 mark
END FUNCTION
 
#NO.FUN-840049 -Mark--Begin--#
#REPORT i180_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
#   l_sql1          LIKE gbc_file.gbc05,          #No.FUN-680137 VARCHAR(100)
#   l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#   sr              RECORD
#       opm01       LIKE opm_file.opm01,
#       oba02       LIKE oba_file.oba02,
#       opm02       LIKE opm_file.opm02,
#       opm03       LIKE opm_file.opm03,
#       opn04       LIKE opn_file.opn04,
#       opn05       LIKE opn_file.opn05
#                   END RECORD,
#       l_gem02     LIKE type_file.chr8,          #No.FUN-680137
#       l_gen02     LIKE type_file.chr8,          #No.FUN-680137
#       l_str       LIKE adj_file.adj02           #No.FUN-680137
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.opm01,sr.opm02,sr.opm03,sr.opn04
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           PRINT g_dash
#           LET g_head1 = g_x[09] CLIPPED,sr.opm01 CLIPPED, ' ',sr.oba02
#           PRINT g_head1
#           LET g_head1 = g_x[10] CLIPPED,sr.opm02 CLIPPED,' ',
#                         g_x[11] CLIPPED,sr.opm03
#           PRINT g_head1
#           PRINT g_dash
#           PRINT g_x[31],
#                 g_x[32]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.opm03
#           SKIP TO TOP OF PAGE
#
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.opn04 USING '########',
#                 COLUMN g_c[32],sr.opn05 USING '##########&.&&&'
#       AFTER GROUP OF sr.opm03
#           PRINT g_dash2
#           PRINT COLUMN g_c[31],g_x[12] CLIPPED,
#                 COLUMN g_c[32],GROUP SUM(sr.opn05) USING '##########&.&&&'
 
#       ON LAST ROW
#           PRINT g_dash
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
#           PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #TQC-650082
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #TQC-650082
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-840049 -Mark--End--#
 
#genero
#單頭
FUNCTION i180_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("opm01,opm02,opm03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i180_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("opm01,opm02,opm03",FALSE)
           RETURN TRUE
       ELSE
           RETURN FALSE
       END IF
   ELSE
       RETURN FALSE
   END IF
 
END FUNCTION
#Patch....NO.TQC-610037 <001> #
#No.FUN-870144
