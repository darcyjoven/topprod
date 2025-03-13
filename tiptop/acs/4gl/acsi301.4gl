# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: acsi301.4gl
# Descriptions...: 料件分類附加成本維護作業
# Date & Author..: 92/01/15 By Nora
# 4.0 Release....: 92/07/23 By Jones
# Add i301_delall: 92/12/26 By Jones
# Modify.........: No.FUN-570158 05/08/09 By Sarah 在複製裡增加set_entry段
# Modify.........: No.FUN-660089 06/06/16 By cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-6A0150 06/10/26 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9A0118 09/10/23 By liuxqa 替换ROWID
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_csf           RECORD LIKE csf_file.*,       #附加成本項目 (單頭)
    g_csf_t         RECORD LIKE csf_file.*,       #附加成本項目 (舊值)
    g_csf_o         RECORD LIKE csf_file.*,       #附加成本項目 (舊值)
    g_csf01_t       LIKE csf_file.csf01,   #料件編號 (舊值)
    g_csf02_t       LIKE csf_file.csf02,   #附加成本項目 (舊值)
    g_csg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        csg03       LIKE csg_file.csg03,   #比率成本項目
        smg02       LIKE smg_file.smg02,   #說明
        smg03       LIKE smg_file.smg03,   #成本歸類
        d02         LIKE zaa_file.zaa08    #No.FUN-680071 VARCHAR(12)               #說明
                    END RECORD,
    g_csg_t         RECORD                 #程式變數 (舊值)
        csg03       LIKE csg_file.csg03,   #比率成本項目
        smg02       LIKE smg_file.smg02,   #說明
        smg03       LIKE smg_file.smg03,   #成本歸類
        d02         LIKE zaa_file.zaa08    #No.FUN-680071 VARCHAR(12)               #說明
                    END RECORD,
    g_smg03         LIKE smg_file.smg03,   #成本類別
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680071 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680071 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-680071 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680071 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680071 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8          #No.FUN-6A0064
DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
         RETURNING g_time    #No.FUN-6A0064
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i301_w AT p_row,p_col
         WITH FORM "acs/42f/acsi301"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_forupd_sql =
          "SELECT * FROM csf_file WHERE csf01 = ? AND csf02 = ? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i301_cl CURSOR FROM g_forupd_sql
 
    CALL i301_menu()
    CLOSE WINDOW i301_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
         RETURNING g_time    #No.FUN-6A0064
END MAIN
 
#QBE 查詢資料
FUNCTION i301_curs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_csg.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
   INITIALIZE g_csf.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        csf01,csf02,csf03,csf05,csf04
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE 
                WHEN INFIELD(csf01) 
#                    CALL q_imz(0,0,g_csf.csf01) RETURNING g_csf.csf01
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imz"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO csf01
                     NEXT FIELD csf01
                WHEN INFIELD(csf02)
#                    CALL q_smg(7,29,g_csf.csf02) RETURNING g_csf.csf02
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO csf02
                     NEXT FIELD csf02
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    #資料權限的檢查
 
    CONSTRUCT g_wc2 ON csg03                # 螢幕上取單身條件
            FROM s_csg[1].csg03
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(csg03)
#                    CALL q_smg(7,29,g_csg[1].csg03) RETURNING g_csg[1].csg03
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.state = 'c'
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO csg03
                     NEXT FIELD csg03
                OTHERWISE
                    EXIT CASE
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT csf01,csf02 FROM csf_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY csf01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE csf01, csf02 ",
                   "  FROM csf_file,csg_file ",
                   " WHERE csf01 = csg01 AND csf02 = csg02",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY csf01"
    END IF
 
    PREPARE i301_prepare FROM g_sql
    DECLARE i301_curs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i301_prepare
 
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM csf_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM csf_file,csg_file WHERE ",
                  "csf01=csg01 AND csf02=csg02",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i301_precount FROM g_sql
    DECLARE i301_count CURSOR FOR i301_precount
END FUNCTION
 
FUNCTION i301_menu()
 
   WHILE TRUE
      CALL i301_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i301_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i301_q()
            END IF
           #NEXT OPTION "next"
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i301_r()
            END IF
           #NEXT OPTION "next" 
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i301_u()
            END IF
           #NEXT OPTION "next" 
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i301_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i301_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-6A0150-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_csf.csf01 IS NOT NULL THEN
                LET g_doc.column1 = "csf01"
                LET g_doc.column2 = "csf02"
                LET g_doc.value1 = g_csf.csf01
                LET g_doc.value2 = g_csf.csf02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0150-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i301_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_csg.clear()
    INITIALIZE g_csf.* LIKE csf_file.*             #DEFAULT 設定
    LET g_csf01_t = NULL
    LET g_csf02_t = NULL
    #預設值及將數值類變數清成零
    LET g_csf_t.* = g_csf.*
    LET g_csf_o.* = g_csf.*
    LET g_csf.csf05 = 0
    LET g_csf.csf04 = 0
    CALL cl_opmsg('a')
    WHILE TRUE
{
        LET g_csf.csfuser=g_user
        LET g_csf.csfgrup=g_grup
        LET g_csf.csfdate=g_today
        LET g_csf.csfacti='Y'              #資料有效
}
        CALL i301_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_csf.csf01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO csf_file VALUES (g_csf.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
           LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
#          CALL cl_err(g_msg,SQLCA.sqlcode,1)   #No.FUN-660089
           CALL cl_err3("ins","csf_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
           CONTINUE WHILE
        END IF
        LET g_csf_t.* = g_csf.*
        LET g_csf_o.* = g_csf.*
        CALL g_csg.clear()
        LET g_rec_b = 0
        SELECT csf01,csf02 INTO g_csf.csf01,g_csf.csf02 FROM csf_file
            WHERE csf01 = g_csf.csf01 
              AND csf02 = g_csf.csf02
        LET g_csf01_t = g_csf.csf01        #保留舊值
        LET g_csf02_t = g_csf.csf02        #保留舊值
        IF g_csf.csf04 IS NOT NULL AND g_csf.csf04 > 0 THEN
           CALL i301_b()                   #輸入單身
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i301_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_csf.csf01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_csf01_t = g_csf.csf01
    LET g_csf02_t = g_csf.csf02
    BEGIN WORK
 
    OPEN i301_cl USING g_csf.csf01,g_csf.csf02
    IF STATUS THEN
       CALL cl_err("OPEN i301_cl:", STATUS, 1)
       CLOSE i301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i301_cl INTO g_csf.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
       CALL cl_err(g_msg,SQLCA.sqlcode,0)      	# 資料被他人LOCK
       CLOSE i301_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i301_show()
    WHILE TRUE
        LET g_csf01_t = g_csf.csf01
        LET g_csf02_t = g_csf.csf02
        CALL i301_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_csf.*=g_csf_t.*
           CALL i301_show()
           CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        IF g_csf.csf01 != g_csf01_t OR g_csf.csf02 != g_csf02_t THEN # 更改單號
            UPDATE csg_file SET csg01 = g_csf.csf01,
                                csg02 = g_csf.csf02
                WHERE csg01 = g_csf01_t AND csg02 = g_csf02_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('csg',SQLCA.sqlcode,0)    #No.FUN-660089
                CALL cl_err3("upd","csg_file",g_csf.csf01,g_csf.csf02,SQLCA.sqlcode,"","csg",1)  #No.FUN-660089
                CONTINUE WHILE
            END IF
        END IF
        UPDATE csf_file SET csf_file.* = g_csf.*
            WHERE csf01 = g_csf.csf01 AND csf02 = g_csf.csf02 
        IF SQLCA.sqlcode THEN
           LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
#          CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660089
           CALL cl_err3("upd","csf_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i301_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i301_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改  #No.FUN-680071 VARCHAR(1)
    l_msg1          LIKE ze_file.ze03,    #No.FUN-680071 VARCHAR(12)
    l_msg           LIKE ze_file.ze03     #No.FUN-680071 VARCHAR(12)
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
    INPUT BY NAME 
        g_csf.csf01,g_csf.csf02,g_csf.csf03,g_csf.csf05,g_csf.csf04
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i301_set_entry(p_cmd)
            CALL i301_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD csf01                  #PART NO.
            IF NOT cl_null(g_csf.csf01) THEN
                CALL i301_csf01('a',g_csf.csf01)
                IF g_chr = 'E' THEN
                   CALL cl_err(g_csf.csf01,'mfg3179',0)
                   LET g_csf.csf01 = g_csf_o.csf01
                   DISPLAY BY NAME g_csf.csf01
                   NEXT FIELD csf01
                END IF
                LET g_csf_o.csf01 = g_csf.csf01
            END IF
 
        AFTER FIELD csf02                  #COST ITEM 
            IF NOT cl_null(g_csf.csf02) THEN
                IF (g_csf.csf01 != g_csf01_t OR g_csf.csf02 != g_csf02_t) OR
                   (g_csf01_t IS NULL) THEN
                    SELECT count(*) INTO g_cnt FROM csf_file
                        WHERE csf01 = g_csf.csf01 AND csf02 = g_csf.csf02
                    IF g_cnt > 0 THEN   #資料重複
                        LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
                        CALL cl_err(g_msg,-239,0)
                        LET g_csf.csf01 = g_csf01_t
                        LET g_csf.csf02 = g_csf02_t
                        DISPLAY BY NAME g_csf.csf01 
                        DISPLAY BY NAME g_csf.csf02 
                        NEXT FIELD csf01
                    END IF
                END IF
                CALL i301_csf02('a',g_csf.csf02)
                IF g_chr = 'E'  THEN
                   CALL cl_err(g_csf.csf02,'mfg1313',0)
                   LET g_csf.csf02 = g_csf_o.csf02
                   DISPLAY BY NAME g_csf.csf02
                   NEXT FIELD csf02
                END IF
                LET g_csf.csf03 = g_smg03
                CALL i301_item(g_smg03) RETURNING l_msg
                DISPLAY l_msg TO FORMONLY.d01
            END IF
                
        AFTER FIELD csf05
           IF g_csf.csf05 IS NULL THEN
              LET g_csf.csf05 = 0
              DISPLAY BY NAME g_csf.csf05
           END IF
           IF g_csf.csf05 < 0 THEN
              CALL cl_err(g_csf.csf05,'mfg5034',0)
              LET g_csf.csf05 = g_csf_o.csf05
              DISPLAY BY NAME g_csf.csf05
              NEXT FIELD csf05
           END IF
           LET g_csf_o.csf05 = g_csf.csf05
                
        AFTER FIELD csf04
           IF g_csf.csf04 IS NULL THEN
              LET g_csf.csf04 = 0
              DISPLAY BY NAME g_csf.csf04
           END IF
           IF g_csf.csf04 < 0 THEN
              CALL cl_err(g_csf.csf04,'mfg5034',0)
              LET g_csf.csf04 = g_csf_o.csf04
              DISPLAY BY NAME g_csf.csf04
              NEXT FIELD csf04
           END IF
           LET g_csf_o.csf04 = g_csf.csf04
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
        ON ACTION CONTROLP
            CASE 
                WHEN INFIELD(csf01) 
#                    CALL q_imz(0,0,g_csf.csf01) RETURNING g_csf.csf01
#                    CALL FGL_DIALOG_SETBUFFER( g_csf.csf01 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imz"
                     LET g_qryparam.default1 = g_csf.csf01
                     CALL cl_create_qry() RETURNING g_csf.csf01
#                    CALL FGL_DIALOG_SETBUFFER( g_csf.csf01 )
                     CALL i301_csf01('a',g_csf.csf01)
                     NEXT FIELD csf01
                WHEN INFIELD(csf02)
#                    CALL q_smg(7,29,g_csf.csf02) RETURNING g_csf.csf02
#                    CALL FGL_DIALOG_SETBUFFER( g_csf.csf02 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_csf.csf02
                     CALL cl_create_qry() RETURNING g_csf.csf02
#                    CALL FGL_DIALOG_SETBUFFER( g_csf.csf02 )
                     CALL i301_csf02('a',g_csf.csf02)
                     NEXT FIELD csf02
                OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION qry_additional_item
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_csd"
                     LET g_qryparam.default1 = g_csf.csf01
                     CALL cl_create_qry() RETURNING g_csf.csf02
                    #CALL FGL_DIALOG_SETBUFFER( g_csf.csf02 )
                     DISPLAY BY NAME g_csf.csf02
                     NEXT FIELD csd02
 
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
END FUNCTION
 
FUNCTION i301_csf01(p_cmd,l_csf01)   # PART NO.
    DEFINE     p_cmd    LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
               l_imz02  LIKE imz_file.imz02,  
       	       l_csf01  LIKE csf_file.csf01,
               l_imzacti LIKE imz_file.imzacti
    LET g_chr = ' '
    SELECT imz02,imzacti INTO 
           l_imz02,l_imzacti FROM imz_file
           WHERE imz01 = l_csf01 
    IF SQLCA.sqlcode THEN
       LET g_chr = 'E' 
    ELSE 
       IF l_imzacti = 'N' THEN
          LET g_chr = 'E'
       END IF
    END IF
    IF cl_null(g_chr) OR p_cmd = 'd' THEN
       DISPLAY l_imz02 TO imz02
    END IF
END FUNCTION
 
FUNCTION i301_csf02(p_cmd,l_csf02)
    DEFINE  p_cmd     LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
 	    l_csf02   LIKE csf_file.csf02,
            l_msg     LIKE ze_file.ze03,      #No.FUN-680071 VARCHAR(12)
            l_msg1    LIKE ze_file.ze03,      #No.FUN-680071 VARCHAR(12)
            l_smgacti LIKE smg_file.smgacti,
            l_smg02   LIKE smg_file.smg02
    LET g_chr = ' '
    SELECT smg02,smg03,smgacti INTO l_smg02,g_smg03,l_smgacti
          FROM smg_file WHERE smg01 = l_csf02
    IF SQLCA.sqlcode THEN
       LET g_chr = 'E' 
       LET g_smg03 = ' '
    ELSE 
       IF l_smgacti = 'N' THEN
          LET g_smg03 = ' '
          LET l_smg02 = ' '
          LET g_chr = 'E'
       END IF
    END IF
    IF cl_null(g_chr) OR p_cmd = 'd' THEN
       DISPLAY l_smg02 TO smg02
       DISPLAY g_smg03 TO csf03
       CALL i301_item(g_smg03) RETURNING l_msg
       DISPLAY l_msg TO FORMONLY.d01
    END IF
END FUNCTION
 
FUNCTION i301_item(l_csf03)
    DEFINE  l_csf03  LIKE  csf_file.csf03, #成本類別
            l_msg    LIKE ze_file.ze03,   #No.FUN-680071 VARCHAR(12)
            l_cnt    LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
			CASE l_csf03
				WHEN '1' CALL cl_getmsg('mfg6053',g_lang) RETURNING l_msg
				WHEN '2' CALL cl_getmsg('mfg6054',g_lang) RETURNING l_msg
				WHEN '3' CALL cl_getmsg('mfg6055',g_lang) RETURNING l_msg
				WHEN '4' CALL cl_getmsg('mfg6056',g_lang) RETURNING l_msg
				WHEN '5' CALL cl_getmsg('mfg6057',g_lang) RETURNING l_msg
				WHEN '9' CALL cl_getmsg('mfg6058',g_lang) RETURNING l_msg
				OTHERWISE LET l_msg = ' '
			END CASE
			RETURN l_msg
END FUNCTION
  
#Query 查詢
FUNCTION i301_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_csf.* TO NULL               #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_csg.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i301_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i301_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_csf.* TO NULL
    ELSE
       OPEN i301_count
       FETCH i301_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL i301_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i301_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680071 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680071 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i301_curs INTO g_csf.csf01,
                                                           g_csf.csf02
        WHEN 'P' FETCH PREVIOUS i301_curs INTO g_csf.csf01,
                                                           g_csf.csf02
        WHEN 'F' FETCH FIRST    i301_curs INTO g_csf.csf01,
                                                           g_csf.csf02
        WHEN 'L' FETCH LAST     i301_curs INTO g_csf.csf01,
                                                           g_csf.csf02
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
            FETCH ABSOLUTE g_jump i301_curs INTO g_csf.csf01,g_csf.csf02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_csf.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_csf.* FROM csf_file WHERE csf01 = g_csf.csf01 AND csf02 = g_csf.csf02 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660089
        CALL cl_err3("sel","csf_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
        INITIALIZE g_csf.* TO NULL
        RETURN
    END IF
    CALL i301_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i301_show()
    DEFINE   l_msg   LIKE ze_file.ze03,    #No.FUN-680071 VARCHAR(12)
             l_msg1  LIKE ze_file.ze03     #No.FUN-680071 VARCHAR(12)
    LET g_csf_t.* = g_csf.*                #保存單頭舊值
    LET g_csf_o.* = g_csf.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
        g_csf.csf01,g_csf.csf02,g_csf.csf03,
        g_csf.csf04,g_csf.csf05
    CALL i301_csf01('d',g_csf.csf01)
    CALL i301_csf02('d',g_csf.csf02)
    CALL i301_item(g_csf.csf03) RETURNING l_msg
    DISPLAY l_msg TO FORMONLY.d01
    CALL i301_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i301_r()
    IF g_csf.csf01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i301_cl USING g_csf.csf01,g_csf.csf02
    IF STATUS THEN
       CALL cl_err("OPEN i301_cl:", STATUS, 1)
       CLOSE i301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i301_cl INTO g_csf.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
        CALL cl_err(g_msg,SQLCA.sqlcode,0)          	#資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL i301_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "csf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "csf02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_csf.csf01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_csf.csf02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM csf_file WHERE csf01 = g_csf.csf01 AND csf02 = g_csf.csf02   #No.TQC-9A0118 mod
       DELETE FROM csg_file WHERE csg01 = g_csf.csf01 
                              AND csg02 = g_csf.csf02
       IF SQLCA.sqlcode THEN 
#         CALL cl_err('delete:',SQLCA.sqlcode,0)   #No.FUN-660089
          CALL cl_err3("del","csg_file",g_csf.csf01,g_csf.csf02,SQLCA.sqlcode,"","delete:",1)  #No.FUN-660089
       END IF
       CLEAR FORM 
       CALL g_csg.clear()
       OPEN i301_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i301_curs
          CLOSE i301_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i301_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i301_curs
          CLOSE i301_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i301_curs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i301_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i301_fetch('/')
       END IF
    END IF
    CLOSE i301_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i301_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680071 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680071 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680071 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680071 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680071 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680071 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_csf.csf01 IS NULL OR 
       g_csf.csf04 IS NULL OR g_csf.csf04 = 0 THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT csg03 ",
                       "  FROM csg_file ",
                       "  WHERE csg01= ? ",
                       "   AND csg02= ? ",
                       "   AND csg03= ? ",
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i301_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_csg
              WITHOUT DEFAULTS
              FROM s_csg.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            DISPLAY "BEFORE ROW"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            OPEN i301_cl USING g_csf.csf01,g_csf.csf02
            IF STATUS THEN
               CALL cl_err("OPEN i301_cl:", STATUS, 1)
               CLOSE i301_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i301_cl INTO g_csf.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
               CALL cl_err(g_msg,SQLCA.sqlcode,0)      	# 資料被他人LOCK
               CLOSE i301_cl
               ROLLBACK WORK
               RETURN
            END IF
           #IF g_csg_t.csg03 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_csg_t.* = g_csg[l_ac].*  #BACKUP
                OPEN i301_bcl USING g_csf.csf01,g_csf.csf02,g_csg_t.csg03
                IF STATUS THEN
                    CALL cl_err("OPEN i301_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i301_bcl INTO g_csg[l_ac].* 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_csg_t.csg03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    CALL i301_csg03(' ')           #for referenced field
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            DISPLAY"BEFORE INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO csg_file(csg01,csg02,csg03)
            VALUES(g_csf.csf01,g_csf.csf02,
                   g_csg[l_ac].csg03)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_csg[l_ac].csg03,SQLCA.sqlcode,0)   #No.FUN-660089
                CALL cl_err3("ins","csg_file",g_csg[l_ac].csg03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_csg[l_ac].* TO NULL      #900423
            LET g_csg_t.* = g_csg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD csg03
 
        AFTER FIELD csg03
            IF g_csg[l_ac].csg03 IS NOT NULL THEN   # 重要欄位不可空白
               IF g_csg[l_ac].csg03 != g_csg_t.csg03 OR
                  g_csg_t.csg03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM csg_file
                       WHERE csg01 = g_csf.csf01 AND csg02 = g_csf.csf02 AND
                             csg03 = g_csg[l_ac].csg03
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_csg[l_ac].csg03 = g_csg_t.csg03
                       NEXT FIELD csg03
                   END IF
               END IF
               CALL i301_csg03('a')
               IF g_chr = 'E' THEN
                  IF g_chr = 'E' THEN
                     CALL cl_err('','mfg1313',0)
                  END IF
                  LET g_csg[l_ac].csg03=g_csg_t.csg03
                  NEXT FIELD csg03
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_csg_t.csg03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM csg_file
                    WHERE csg01 = g_csf.csf01 AND csg02 = g_csf.csf02 AND
                          csg03 = g_csg_t.csg03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_csg_t.csg03,SQLCA.sqlcode,0)   #No.FUN-660089
                    CALL cl_err3("del","csg_file",g_csg_t.csg03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_csg[l_ac].* = g_csg_t.*
               CLOSE i301_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_csg[l_ac].csg03,-263,1)
               LET g_csg[l_ac].* = g_csg_t.*
            ELSE
                UPDATE csg_file 
                   SET csg03 = g_csg[l_ac].csg03
                 WHERE csg01=g_csf.csf01 
                   AND csg02=g_csf.csf02 
                   AND csg03=g_csg_t.csg03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_csg[l_ac].csg03,SQLCA.sqlcode,0)   #No.FUN-660089
                    CALL cl_err3("upd","csg_file",g_csg[l_ac].csg03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
                    LET g_csg[l_ac].* = g_csg_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40080
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_csg[l_ac].* = g_csg_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_csg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i301_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40080
            CLOSE i301_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(csg03)
#                    CALL q_smg(7,29,g_csg[l_ac].csg03) RETURNING g_csg[l_ac].csg03
#                    CALL FGL_DIALOG_SETBUFFER( g_csg[l_ac].csg03 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = g_csg[l_ac].csg03
                     CALL cl_create_qry() RETURNING g_csg[l_ac].csg03
#                    CALL FGL_DIALOG_SETBUFFER( g_csg[l_ac].csg03 )
                     CALL i301_csg03('a')
                     NEXT FIELD csg03
                OTHERWISE
                    EXIT CASE
            END CASE
 
      # ON ACTION CONTROLN
      #     CALL i301_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(csg03) AND l_ac > 1 THEN
                LET g_csg[l_ac].* = g_csg[l_ac-1].*
                NEXT FIELD csg03
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
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                                
        
        END INPUT
#       CALL i301_delall()
    CALL i301_delHeader()     #CHI-C30002 add
    CLOSE i301_bcl
    COMMIT WORK
END FUNCTION

#CHI-C30002 -------- add -------- begin   
FUNCTION i301_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM csf_file WHERE csf01 = g_csf.csf01
         INITIALIZE g_csf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i301_delall()
#   SELECT COUNT(*) INTO g_cnt FROM csg_file
#       WHERE csg01 = g_csf.csf01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM csf_file WHERE csf01 = g_csf.csf01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
   
FUNCTION  i301_csg03(p_cmd)     #COST ITEM 
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(1)
    l_msg           LIKE ze_file.ze03,      #No.FUN-680071 VARCHAR(12)
    l_smgacti       LIKE smg_file.smgacti
 
    SELECT smg02,smg03,smgacti
        INTO g_csg[l_ac].smg02,g_csg[l_ac].smg03,l_smgacti
        FROM smg_file
        WHERE smg01 = g_csg[l_ac].csg03
    DISPLAY "SELECT smg_file"
    DISPLAY "SQLCA.SQLCDE=",SQLCA.SQLCODE
    IF SQLCA.sqlcode THEN
        LET g_chr = 'E'
        LET g_csg[l_ac].smg02 = NULL
        LET g_csg[l_ac].smg03 = NULL
        DISPLAY " LET g_csg[l_ac].smg02 = NULL"
        DISPLAY " LET g_csg[l_ac].smg03 = NULL"
        RETURN
    ELSE
        IF l_smgacti='N' THEN
           LET g_chr = 'E'
           RETURN
        END IF
    END IF
    LET g_chr = ' '
    IF p_cmd = 'd' OR cl_null(g_chr)  THEN
       CALL i301_item(g_csg[l_ac].smg03) RETURNING l_msg
       LET g_csg[l_ac].d02 = l_msg
    END IF
END FUNCTION
 
FUNCTION i301_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(200)
 
    CLEAR smg02,smg03                     #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON csg03
            FROM s_csg[1].csg03
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
    CALL i301_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i301_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(200)
    l_msg           LIKE ze_file.ze03       #No.FUN-680071 VARCHAR(12)
 
    LET g_sql =
        "SELECT csg03,smg02,smg03",
        " FROM csg_file LEFT JOIN smg_file ON csg03 = smg_file.smg01",
        " WHERE csg01 ='",g_csf.csf01,"' AND",  #單頭-1
              " csg02 ='",g_csf.csf02,"' AND",  #單頭-2
        p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i301_pb FROM g_sql
    DECLARE csg_curs                       #SCROLL CURSOR
        CURSOR FOR i301_pb
 
    CALL g_csg.clear()
    LET g_cnt = 1
    FOREACH csg_curs INTO g_csg[g_cnt].*   #單身 ARRAY 填充
        CALL i301_item(g_csg[g_cnt].smg03) RETURNING g_csg[g_cnt].d02
        DISPLAY l_msg TO FORMONLY.d01
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
    CALL g_csg.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i301_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_csg TO s_csg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
         CALL i301_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i301_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL i301_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i301_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL i301_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
 
      ON ACTION related_document                #No.FUN-6A0150  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                               
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i301_copy()
DEFINE
    l_newno1         LIKE csf_file.csf01,    #PART NO.
    l_newno2         LIKE csf_file.csf02,    #COST ITEM 
    l_oldno1         LIKE csf_file.csf01,    #PART NO.
    l_oldno2         LIKE csf_file.csf02     #COST ITEM 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_csf.csf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-570158
    CALL i301_set_entry('a')          #FUN-570158
    LET g_before_input_done = FALSE   #FUN-570158
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
   #DISPLAY "" AT 1,1
    INPUT l_newno1,l_newno2 FROM csf01,csf02
 
        AFTER FIELD csf01
            IF NOT cl_null(l_newno1) THEN
                CALL i301_csf01('a',l_newno1)
                IF g_chr = 'E' THEN
                   CALL cl_err(l_newno1,'mfg3179',0)
                   LET l_newno1= NULL
                   DISPLAY l_newno1 TO csf01
                   NEXT FIELD csf01
                END IF
            END IF
 
        AFTER FIELD csf02
            IF NOT cl_null(l_newno2) THEN
                SELECT count(*) INTO g_cnt FROM csf_file
                    WHERE csf01 = l_newno1 AND csf02 = l_newno2
                IF g_cnt > 0 THEN
                    LET g_msg = l_newno1 CLIPPED,'+',l_newno2
                    CALL cl_err(g_msg,-239,0)
                    NEXT FIELD csf01
                END IF
                CALL i301_csf02('a',l_newno2)
                IF g_chr = 'E'  THEN
                   CALL cl_err(l_newno2,'mfg1313',0)
                   LET l_newno2= NULL
                   DISPLAY l_newno2 TO csf02
                   NEXT FIELD csf02
                END IF
                LET g_csf.csf03 = g_smg03
            END IF
        ON ACTION CONTROLP
            CASE 
                WHEN INFIELD(csf01) 
#                    CALL q_imz(0,0,l_newno1) RETURNING l_newno1
#                    CALL FGL_DIALOG_SETBUFFER( l_newno1 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imz"
                     LET g_qryparam.default1 = l_newno1
                     CALL cl_create_qry() RETURNING l_newno1
#                     CALL FGL_DIALOG_SETBUFFER( l_newno1 )
                     CALL i301_csf01('a',l_newno1)
                     NEXT FIELD csf01
                WHEN INFIELD(csf02)
#                    CALL q_smg(7,29,l_newno2) RETURNING l_newno2
#                    CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_smg"
                     LET g_qryparam.default1 = l_newno2
                     CALL cl_create_qry() RETURNING l_newno2
#                     CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                     CALL i301_csf02('a',l_newno2)
                     NEXT FIELD csf02
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
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_csf.csf01 
        DISPLAY BY NAME g_csf.csf02 
        RETURN
    END IF
	DROP TABLE y
    SELECT * FROM csf_file         #單頭複製
        WHERE csf01=g_csf.csf01 AND csf02=g_csf.csf02
        INTO TEMP y
    UPDATE y
        SET y.csf01=l_newno1,   #新的鍵值-1
            y.csf02=l_newno2,   #新的鍵值-2
			y.csf03=g_csf.csf03
    INSERT INTO csf_file
        SELECT * FROM y
 
    DROP TABLE x
    SELECT * FROM csg_file         #單身複製
        WHERE csg01=g_csf.csf01 AND csg02=g_csf.csf02
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660089
        CALL cl_err3("ins","x",g_csf.csf01,g_csf.csf02,SQLCA.sqlcode,"","",1)  #No.FUN-660089
        RETURN
    END IF
    UPDATE x
        SET csg01=l_newno1, csg02=l_newno2
    INSERT INTO csg_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg=g_csf.csf01 CLIPPED,'+',g_csf.csf02
#       CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660089
        CALL cl_err3("ins","csg_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660089
        RETURN
    END IF
    LET l_oldno1 = g_csf.csf01
    LET l_oldno2 = g_csf.csf02
    SELECT csf_file.* INTO g_csf.* FROM csf_file 
             WHERE csf01 = l_newno1 AND csf02 = l_newno2
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660089
       CALL cl_err3("sel","csf_file",l_newno1,l_newno2,SQLCA.sqlcode,"","",1)  #No.FUN-660089
    END IF
    CALL i301_u()
    IF g_csf.csf04 IS NOT NULL AND g_csf.csf04 > 0 THEN
       CALL i301_b()
    END IF
#FUN-C30027---begin
#    LET  g_csf.csf01 = l_oldno1
#    LET  g_csf.csf02 = l_oldno2
#
#    SELECT csf_file.* INTO g_csf.* FROM csf_file 
#             WHERE csf01 = l_oldno1 AND csf02 = l_oldno2
#    IF SQLCA.sqlcode THEN
##      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660089
#       CALL cl_err3("sel","csf_file",l_oldno1,l_oldno2,SQLCA.sqlcode,"","",1)  #No.FUN-660089
#    END IF
#FUN-C30027---end
	CALL i301_show()

    DISPLAY BY NAME g_csf.csf01 
    DISPLAY BY NAME g_csf.csf02 
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1 CLIPPED,l_newno2,') O.K'
        
END FUNCTION
#genero
#單頭
FUNCTION i301_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("csf01,csf02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i301_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680071 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("csf01,csf02",FALSE)
       END IF
   END IF
 
END FUNCTION
