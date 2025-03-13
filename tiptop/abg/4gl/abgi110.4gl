# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi110.4gl
# Descriptions...: 生產預算資料維護作業
# Date & Author..: Julius 02/09/25
# Modi...........: ching  031028 No.8563 單位換算
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-530238 05/03/24 By Smapmin 篩選畫面是英文
# Modify.........: No.FUN-570108 05/07/13 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-5A0004 05/10/07 By Rosayu 刪除資料後筆數不正確
# Modify.........: No.TQC-630053 06/03/07 By Smapmin 複製功能視窗無法顯示中文
#                                                    篩選時,數量應該抓取abgi100的bgm05(預算銷量)
#                                                    產品別/品號開窗要開oba_file
#                                                    單身顯示不正常
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680061 06/08/23 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690023 06/09/12 By jamie 判斷occacti
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0003 06/09/29 By jamie 1.FUNCTION i110_q() 一開始應清空g_bgn_hd.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 g_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760066 07/06/15 By chenl   修正action id
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-970265 09/07/24 By Carrier 數量不可為負
# Modify.........: No.TQC-980121 09/08/27 By lilingyu 生產單位欄位錄入無效值,應先檢查gfe_file,不存在則show報錯訊息,然后再去檢查有無轉化率
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9B0137 09/11/18 By Carrier l_ima55为空时,赋成' '给bgn11,否则插入失败
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 BY vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/22 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B70165 11/07/18 By Polly 修正axr-610、agl-020 訊息條件 
# Modify.........: No.TQC-B70186 11/07/25 By Dido 資料產生 0 期初取消 * -1 
# Modify.........: No.FUN-910088 11/12/30 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao 離開單身時單身無資料時提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bgn_hd        RECORD                       #單頭變數
        bgn01       LIKE bgn_file.bgn01,
        bgn02       LIKE bgn_file.bgn02,
        bgn012      LIKE bgn_file.bgn012,
        bgn013      LIKE bgn_file.bgn013,
        bgn014      LIKE bgn_file.bgn014,
        bgn11       LIKE bgn_file.bgn11,
        bgn11_fac   LIKE bgn_file.bgn11_fac
        END RECORD,
    g_bgn_hd_t      RECORD                       #單頭變數
        bgn01       LIKE bgn_file.bgn01,
        bgn02       LIKE bgn_file.bgn02,
        bgn012      LIKE bgn_file.bgn012,
        bgn013      LIKE bgn_file.bgn013,
        bgn014      LIKE bgn_file.bgn014,
        bgn11       LIKE bgn_file.bgn11,
        bgn11_fac   LIKE bgn_file.bgn11_fac
        END RECORD,
    g_bgn_hd_o      RECORD                       #單頭變數
        bgn01       LIKE bgn_file.bgn01,
        bgn02       LIKE bgn_file.bgn02,
        bgn012      LIKE bgn_file.bgn012,
        bgn013      LIKE bgn_file.bgn013,
        bgn014      LIKE bgn_file.bgn014,
        bgn11       LIKE bgn_file.bgn11,
        bgn11_fac   LIKE bgn_file.bgn11_fac
        END RECORD,
    g_bgn           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
        bgn03       LIKE bgn_file.bgn03,
        bgn04       LIKE bgn_file.bgn04,
        bgn05       LIKE bgn_file.bgn05,
        bgn06       LIKE bgn_file.bgn06,
        bgn07       LIKE bgn_file.bgn07,
        bgn08       LIKE bgn_file.bgn08
        END RECORD,
    g_bgn_t         RECORD                       #程式變數(舊值)
        bgn03       LIKE bgn_file.bgn03,
        bgn04       LIKE bgn_file.bgn04,
        bgn05       LIKE bgn_file.bgn05,
        bgn06       LIKE bgn_file.bgn06,
        bgn07       LIKE bgn_file.bgn07,
        bgn08       LIKE bgn_file.bgn08
        END RECORD,
     g_wc            string,                   #WHERE CONDITION  #No.FUN-580092 HCN
     g_sql           string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數  #No.FUN-680061 SMALLINT
    g_mody          LIKE type_file.chr1,       #單身的鍵值是否改變 #No.FUN-680061 VARCHAR(01)
    l_ac            LIKE type_file.num5,       #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT
    l_gem02         LIKE gem_file.gem02
DEFINE g_imk09      LIKE imk_file.imk09
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE g_i          LIKE type_file.num5          #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03            #No.FUN-680061 VARCHAR(72)
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE g_no_ask     LIKE type_file.num5          #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask
 
MAIN
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0056
    INITIALIZE g_bgn_hd_t.* to NULL
 
    OPEN WINDOW i110_w WITH FORM "abg/42f/abgi110"
       ATTRIBUTE(STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CALL i110_menu()
 
    CLOSE WINDOW i110_w                          #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i110_curs()
    CLEAR FORM #清除畫面
    CALL g_bgn.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INITIALIZE g_bgn_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgn01, bgn013, bgn012, bgn014,bgn11,bgn11_fac,bgn02,
                      bgn03, bgn04, bgn05, bgn06, bgn07, bgn08
         FROM bgn01, bgn013, bgn012, bgn014,bgn11,bgn11_fac, bgn02,
              s_bgn[1].bgn03, s_bgn[1].bgn04, s_bgn[1].bgn05,
              s_bgn[1].bgn06, s_bgn[1].bgn07, s_bgn[1].bgn08
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bgn013)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgn013
                WHEN INFIELD(bgn012)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgn012
                WHEN INFIELD(bgn014)
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.state = "c"
                 #   LET g_qryparam.form ="q_ima"  
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO bgn014
            END CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
     #-----TQC-630053---------
     ON ACTION CONTROLE
        IF INFIELD(bgn014) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.state = "c"
           LET g_qryparam.form ="q_oba"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO bgn014
        END IF
     #-----END TQC-630053-----
 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_SELECT
         	   CALL cl_qbe_SELECT()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN
        CALL i110_show()
        RETURN
    END IF
 
    LET g_sql = "SELECT UNIQUE bgn01, bgn02, bgn012, bgn013, bgn014,",
                "              bgn11,bgn11_fac",
                "  FROM bgn_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY bgn01"
    PREPARE i110_prepare FROM g_sql
    DECLARE i110_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i110_prepare
 
#   LET g_sql = "SELECT UNIQUE bgn01, bgn02, bgn012, bgn013, bgn014",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE bgn01, bgn02, bgn012, bgn013, bgn014",  #No.TQC-720019
                "              bgn11, bgn11_fac                    ",
                "  FROM bgn_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i110_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i110_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i110_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i110_precnt FROM g_sql
    DECLARE i110_cnt CURSOR FOR i110_precnt
END FUNCTION
 
FUNCTION i110_menu()
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
      #@ WHEN "G.自動整批產生"
        #WHEN "btn01"            #No.TQC-760066 mark
         WHEN "data_produce"     #No.TQC-760066 
            IF cl_chk_act_auth() THEN
               CALL i110_g()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i110_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i110_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i110_copy()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i110_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i110_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgn),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
           IF cl_chk_act_auth() THEN
              IF g_bgn_hd.bgn02 IS NOT NULL THEN
                 LET g_doc.column1 = "bgn02"
                 LET g_doc.column2 = "bgn012"
                 LET g_doc.column3 = "bgn013"
                 LET g_doc.column4 = "bgn014"
                 LET g_doc.value1 = g_bgn_hd.bgn02
                 LET g_doc.value2 = g_bgn_hd.bgn012
                 LET g_doc.value3 = g_bgn_hd.bgn013
                 LET g_doc.value4 = g_bgn_hd.bgn014
                 CALL cl_doc()
              END IF 
           END IF
          #No.FUN-6A0003-------add--------end----         
       END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i110_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_bgn.clear()
    INITIALIZE g_bgn_hd TO NULL                  #單頭初始清空
    INITIALIZE g_bgn_hd_o TO NULL                #單頭舊值清空
    LET g_wc= NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i110_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
     IF cl_null(g_bgn_hd.bgn012)  OR
        cl_null(g_bgn_hd.bgn013)  OR
        cl_null(g_bgn_hd.bgn014)  OR
        cl_null(g_bgn_hd.bgn11)  OR
        cl_null(g_bgn_hd.bgn11_fac) OR
        cl_null(g_bgn_hd.bgn02)  THEN
        CONTINUE WHILE
     END IF
        CALL g_bgn.clear()
        LET g_rec_b=0
        CALL i110_b()                            #輸入單身
        LET g_bgn_hd_o.* = g_bgn_hd.*            #保留舊值
        LET g_bgn_hd_t.* = g_bgn_hd.*            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理單頭欄位(bgn01, bgn02, bgn013, bgn014)INPUT
FUNCTION i110_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
    l_n     LIKE type_file.num5     #No.FUN-680061 SMALLINT
 
    LET l_n = 0
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    DISPLAY g_bgn_hd.bgn01, g_bgn_hd.bgn013, g_bgn_hd.bgn012,
            g_bgn_hd.bgn014,
            g_bgn_hd.bgn11 , g_bgn_hd.bgn11_fac ,
            g_bgn_hd.bgn02
         TO bgn01, bgn013, bgn012, bgn014,bgn11,bgn11_fac, bgn02
 
    INPUT BY NAME
        g_bgn_hd.bgn01, g_bgn_hd.bgn013, g_bgn_hd.bgn012,
        g_bgn_hd.bgn014,
        g_bgn_hd.bgn11 , g_bgn_hd.bgn11_fac,
        g_bgn_hd.bgn02
    WITHOUT DEFAULTS HELP 1
 
#No.FUN-570108--begin
        BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL i110_set_entry(p_cmd)
        CALL i110_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
#No.FUN-570108--end
 
        AFTER FIELD bgn01
            IF g_bgn_hd.bgn01 IS NULL THEN
                LET g_bgn_hd.bgn01 = " "
            END IF
 
        AFTER FIELD bgn013
            IF NOT cl_null(g_bgn_hd.bgn013) THEN
                CALL i110_bgn013('a',g_bgn_hd.bgn013)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD bgn013
                END IF
            END IF
 
        AFTER FIELD bgn012
            IF NOT cl_null(g_bgn_hd.bgn012) THEN
                CALL i110_bgn012('a',g_bgn_hd.bgn012)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD bgn012
                END IF
            END IF
 
        AFTER FIELD bgn014
            IF NOT cl_null(g_bgn_hd.bgn014) THEN
                #FUN-AA0059 -----------------------add start----------------------
                IF NOT s_chk_item_no(g_bgn_hd.bgn014,'') THEN
                   CALL cl_err('',g_errno,1)
                    NEXT FIELD bgn014
                END IF 
                #FUN-AA0059 ----------------_ --add end------------------------- 
                CALL i110_bgn014('a',g_bgn_hd.bgn014)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD bgn014
                END IF
 
                IF cl_null(g_bgn_hd.bgn11) THEN
                   SELECT ima55 INTO g_bgn_hd.bgn11
                     FROM ima_file
                    WHERE ima01=g_bgn_hd.bgn014
                    DISPLAY BY NAME g_bgn_hd.bgn11
                END IF
            END IF
 
     AFTER FIELD bgn11
         IF NOT cl_null(g_bgn_hd.bgn11 ) THEN
             CALL i110_bgn11('a',g_bgn_hd.bgn11 )
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD bgn11
             END IF
         END IF
 
        AFTER FIELD bgn02
            IF g_bgn_hd.bgn02 < 1 THEN
                NEXT FIELD bgn02
            END IF
 
        ON ACTION CONTROLF                       #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bgn013)
                #   CALL q_occ(10, 3, g_bgn_hd.bgn013)
                #       RETURNING g_bgn_hd.bgn013
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_occ"
                    LET g_qryparam.default1 = g_bgn_hd.bgn013
                    CALL cl_create_qry() RETURNING g_bgn_hd.bgn013
                    DISPLAY g_bgn_hd.bgn013 TO bgn013
                WHEN INFIELD(bgn012)
                #   CALL q_gem(11, 3, g_bgn_hd.bgn012)
                #       RETURNING g_bgn_hd.bgn012
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_bgn_hd.bgn012
                    CALL cl_create_qry() RETURNING g_bgn_hd.bgn012
                    DISPLAY g_bgn_hd.bgn012 TO bgn012
                WHEN INFIELD(bgn014)
                #   CALL q_ima(10, 3, g_bgn_hd.bgn014)
                #       RETURNING g_bgn_hd.bgn014
#FUN-AA0059 --Begin--
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.form ="q_ima"   
               #     LET g_qryparam.default1=g_bgn_hd.bgn014
               #     CALL cl_create_qry() RETURNING g_bgn_hd.bgn014
                    CALL q_sel_ima(FALSE, "q_ima", "", g_bgn_hd.bgn014 , "", "", "", "" ,"",'' )  RETURNING g_bgn_hd.bgn014 
#FUN-AA0059 --End--
                    DISPLAY g_bgn_hd.bgn014 TO bgn014
            END CASE
       ON ACTION CONTROLE
           CASE
               WHEN INFIELD(bgn014)
               #   CALL q_oba(10,3, g_bgn_hd.bgn014)
               #       RETURNING g_bgn_hd.bgn014
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oba"
                   LET g_qryparam.default1 = g_bgn_hd.bgn014
                   CALL cl_create_qry() RETURNING g_bgn_hd.bgn014
                   DISPLAY g_bgn_hd.bgn014 TO bgn014
           END CASE
 
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
 
FUNCTION i110_bgn013(p_cmd,p_key)  #客戶編號
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgn_file.bgn013,
           l_occ02   LIKE occ_file.occ02,
           l_occacti LIKE occ_file.occacti
 
    LET g_errno = " "
    SELECT occ02,occacti INTO l_occ02,l_occacti
      FROM occ_file WHERE occ01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2732'
                                   LET l_occ02 = ' '
         WHEN l_occacti='N' LET g_errno = '9028'
        #FUN-690023------mod-------
         WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
        #FUN-690023------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_bgn_hd.bgn013 = 'ALL' THEN
       LET g_errno = ' ' LET l_occ02 = 'ALL'
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_occ02 TO FORMONLY.occ02
    END IF
END FUNCTION
 
FUNCTION i110_bgn012(p_cmd,p_key)  #部門編號
    DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgn_file.bgn012,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = " "
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET l_gem02 = ' '
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_bgn_hd.bgn012 = 'ALL' THEN
       LET g_errno = ' ' LET l_gem02 = 'ALL'
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION i110_bgn014(p_cmd,p_key)
 DEFINE l_ima02   LIKE ima_file.ima02,
        l_ima021  LIKE ima_file.ima021,
        l_ima01   LIKE ima_file.ima01 ,
        l_ima25   LIKE ima_file.ima25 ,
        l_imaacti LIKE ima_file.imaacti,
        p_key     LIKE bgn_file.bgn014,
        p_cmd     LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
    FROM ima_file  WHERE ima01 = p_key
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL
                                 LET l_ima021=NULl
                                 LET l_imaacti = NULL
       WHEN l_imaacti='N'        LET g_errno = '9028'
      #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 IF NOT cl_null(g_errno) THEN
    SELECT oba02 INTO l_ima02 FROM oba_file WHERE oba01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno= 'mfg0002'
                                   LET l_ima02 = NULL
         OTHERWISE                 LET g_errno= SQLCA.SQLCODE USING '-------'
    END CASE
 END IF
 
 LET l_ima01=''
 SELECT ima01 INTO l_ima01 FROM ima_file
  WHERE ima01=p_key
 IF cl_null(l_ima01) THEN
    SELECT bgg06 INTO l_ima01 FROM bgg_file
    #WHERE bgg01=g_bgn_hd.bgm01  #No.TQC-970265
     WHERE bgg01=g_bgn_hd.bgn01  #No.TQC-970265
       AND bgg02=p_key
 END IF
 SELECT ima25 INTO l_ima25 FROM ima_file
  WHERE ima01=l_ima01
 
 IF cl_null(g_errno)  OR p_cmd = 'd' THEN
    DISPLAY l_ima02  TO FORMONLY.ima02
    DISPLAY l_ima021 TO FORMONLY.ima021
    DISPLAY l_ima25  TO FORMONLY.ima25
 END IF
 
END FUNCTION
 
FUNCTION i110_bgn014c(p_cmd,p_key)
 DEFINE l_ima02   LIKE ima_file.ima02,
        l_ima021  LIKE ima_file.ima021,
        l_ima01   LIKE ima_file.ima01 ,
        l_ima25   LIKE ima_file.ima25 ,
        l_imaacti LIKE ima_file.imaacti,
        p_key     LIKE bgn_file.bgn014,
        p_cmd     LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
    FROM ima_file  WHERE ima01 = p_key
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL
                                 LET l_ima021=NULl
                                 LET l_imaacti = NULL
       WHEN l_imaacti='N'        LET g_errno = '9028'
      #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 IF NOT cl_null(g_errno) THEN
    SELECT oba02 INTO l_ima02 FROM oba_file WHERE oba01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno= 'mfg0002'
                                   LET l_ima02 = NULL
         OTHERWISE                 LET g_errno= SQLCA.SQLCODE USING '-------'
    END CASE
 END IF
 
END FUNCTION
 
FUNCTION i110_bgn11(p_cmd,p_key)
 DEFINE l_gfeacti LIKE gfe_file.gfeacti,
        l_ima25   LIKE ima_file.ima25  ,
        l_ima01   LIKE ima_file.ima01  ,
        p_key     LIKE bgn_file.bgn11,
        l_fac     LIKE pml_file.pml09,
        p_cmd     LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti
    FROM gfe_file  WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                                 LET l_gfeacti = NULL
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
IF cl_null(g_errno) THEN         #TQC-980121 
  LET l_ima01=''
  SELECT ima01 INTO l_ima01 FROM ima_file
   WHERE ima01=g_bgn_hd.bgn014
  IF cl_null(l_ima01) THEN
     SELECT bgg06 INTO l_ima01 FROM bgg_file
      WHERE bgg01=g_bgn_hd.bgn01
        AND bgg02=g_bgn_hd.bgn014
  END IF
  SELECT ima25 INTO l_ima25 FROM ima_file
   WHERE ima01=l_ima01
  CALL s_umfchk(l_ima01,p_key,l_ima25)
  RETURNING g_i,l_fac
  IF g_i = 1 THEN
    LET g_errno='abm-731'
    LET l_fac = 1
  END IF
  IF p_cmd='a' THEN
     LET g_bgn_hd.bgn11_fac=l_fac
  END IF
END IF                           #TQC-980121
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_ima25  TO FORMONLY.ima25
     DISPLAY l_fac    TO bgn11_fac
  END IF
END FUNCTION
 
FUNCTION i110_bgn11c(p_cmd,p_key,p_key2,p_key3)
 DEFINE l_gfeacti LIKE gfe_file.gfeacti,
        l_ima25   LIKE ima_file.ima25  ,
        l_ima01   LIKE ima_file.ima01  ,
        p_key     LIKE bgn_file.bgn11,
        p_key2    LIKE bgn_file.bgn01,
        p_key3    LIKE bgn_file.bgn014,
        l_fac     LIKE pml_file.pml09,    #NO.FUN-680061 DEC(16,8) 
        p_cmd     LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti
    FROM gfe_file  WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                                 LET l_gfeacti = NULL
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  LET l_ima01=''
  SELECT ima01 INTO l_ima01 FROM ima_file
   WHERE ima01=g_bgn_hd.bgn014
  IF cl_null(l_ima01) THEN
     SELECT bgg06 INTO l_ima01 FROM bgg_file
      WHERE bgg01=p_key2
        AND bgg02=p_key3
  END IF
  SELECT ima25 INTO l_ima25 FROM ima_file
   WHERE ima01=l_ima01
  CALL s_umfchk(l_ima01,p_key,l_ima25)
  RETURNING g_i,l_fac
  IF g_i = 1 THEN
    LET g_errno='abm-731'
    LET l_fac = 1
  END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_fac    TO obgn11_fac
  END IF
  RETURN l_fac
END FUNCTION
 
FUNCTION i110_u()
 
    IF s_shut(0) THEN
        RETURN
    END IF
    IF g_bgn_hd.bgn01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bgn_hd_t.bgn01 = g_bgn_hd.bgn01
    LET g_bgn_hd_t.bgn02 = g_bgn_hd.bgn02
    LET g_bgn_hd_t.bgn012 = g_bgn_hd.bgn012
    LET g_bgn_hd_t.bgn013 = g_bgn_hd.bgn013
    LET g_bgn_hd_t.bgn014 = g_bgn_hd.bgn014
    LET g_bgn_hd_t.bgn11  = g_bgn_hd.bgn11
    LET g_bgn_hd_t.bgn11_fac = g_bgn_hd.bgn11_fac
    BEGIN WORK
    WHILE TRUE
        CALL i110_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bgn_hd.bgn01 = g_bgn_hd_t.bgn01
            LET g_bgn_hd.bgn02 = g_bgn_hd_t.bgn02
            LET g_bgn_hd.bgn012 = g_bgn_hd_t.bgn012
            LET g_bgn_hd.bgn013 = g_bgn_hd_t.bgn013
            LET g_bgn_hd.bgn014 = g_bgn_hd_t.bgn014
            LET g_bgn_hd.bgn11  = g_bgn_hd_t.bgn11
            LET g_bgn_hd.bgn11_fac = g_bgn_hd_t.bgn11_fac
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bgn_file
           SET bgn01 = g_bgn_hd.bgn01,
               bgn02 = g_bgn_hd.bgn02,
               bgn012 = g_bgn_hd.bgn012,
               bgn013 = g_bgn_hd.bgn013,
               bgn014 = g_bgn_hd.bgn014,
               bgn11  = g_bgn_hd.bgn11 ,
               bgn11_fac = g_bgn_hd.bgn11_fac
         WHERE bgn01 = g_bgn_hd_t.bgn01
           AND bgn02 = g_bgn_hd_t.bgn02
           AND bgn012 = g_bgn_hd_t.bgn012
           AND bgn013 = g_bgn_hd_t.bgn013
           AND bgn014 = g_bgn_hd_t.bgn014
           AND bgn11  = g_bgn_hd_t.bgn11
           AND bgn11_fac = g_bgn_hd_t.bgn11_fac
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("upd","bgn_file",g_bgn_hd_t.bgn01,g_bgn_hd_t.bgn02,SQLCA.sqlcode,"","",1) #FUN-660105
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#Query 查詢
FUNCTION i110_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bgn_hd.* TO NULL          #No.FUN-6A0003    
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bgn.clear()
    DISPLAY '     ' TO FORMONLY.cnt
    CALL i110_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i110_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bgn TO NULL
    ELSE
        OPEN i110_cnt
        FETCH i110_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i110_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i110_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1    #處理方式  #No.FUN-680061 VARCHAR(01)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i110_cs INTO g_bgn_hd.bgn01, g_bgn_hd.bgn02,
                                             g_bgn_hd.bgn012,g_bgn_hd.bgn013,
                                             g_bgn_hd.bgn014,
                                             g_bgn_hd.bgn11 ,g_bgn_hd.bgn11_fac
        WHEN 'P' FETCH PREVIOUS i110_cs INTO g_bgn_hd.bgn01, g_bgn_hd.bgn02,
                                             g_bgn_hd.bgn012,g_bgn_hd.bgn013,
                                             g_bgn_hd.bgn014,
                                             g_bgn_hd.bgn11 ,g_bgn_hd.bgn11_fac
        WHEN 'F' FETCH FIRST    i110_cs INTO g_bgn_hd.bgn01, g_bgn_hd.bgn02,
                                             g_bgn_hd.bgn012,g_bgn_hd.bgn013,
                                             g_bgn_hd.bgn014,
                                             g_bgn_hd.bgn11 ,g_bgn_hd.bgn11_fac
        WHEN 'L' FETCH LAST     i110_cs INTO g_bgn_hd.bgn01, g_bgn_hd.bgn02,
                                             g_bgn_hd.bgn012,g_bgn_hd.bgn013,
                                             g_bgn_hd.bgn014,
                                             g_bgn_hd.bgn11 ,g_bgn_hd.bgn11_fac
        WHEN '/'
         IF (NOT g_no_ask) THEN             #No.FUN-6A0057 g_no_ask
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
         FETCH ABSOLUTE g_jump i110_cs INTO g_bgn_hd.bgn01, g_bgn_hd.bgn02,
                                            g_bgn_hd.bgn012,g_bgn_hd.bgn013,
                                            g_bgn_hd.bgn014,
                                            g_bgn_hd.bgn11 ,g_bgn_hd.bgn11_fac
         LET g_no_ask = FALSE              #No.FUN-6A0057 g_no_ask
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgn_hd.bgn01, SQLCA.sqlcode, 0)
        INITIALIZE g_bgn_hd.* TO NULL  #TQC-6B0105
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
       CALL i110_show()
    END IF
  { SELECT UNIQUE bgn01, bgn02, bgn012, bgn013, bgn014,bgn11,bgn11_fac
      FROM bgn_file
     WHERE bgn01 = g_bgn_hd.bgn01
       AND bgn02 = g_bgn_hd.bgn02
       AND bgn012 = g_bgn_hd.bgn012
       AND bgn013 = g_bgn_hd.bgn013
       AND bgn014 = g_bgn_hd.bgn014
       AND bgn11  = g_bgn_hd.bgn11
       AND bgn11_fac = g_bgn_hd.bgn11_fac
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgn_hd.bgn01, SQLCA.sqlcode, 0)
        INITIALIZE g_bgn TO NULL
        RETURN
    END IF   }
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i110_show()
 
    INITIALIZE l_gem02 TO NULL
 
    LET g_bgn_hd.* = g_bgn_hd.*                  #保存單頭舊值
    DISPLAY BY NAME g_bgn_hd.bgn01,              #顯示單頭值
                    g_bgn_hd.bgn02,
                    g_bgn_hd.bgn012,
                    g_bgn_hd.bgn013,
                    g_bgn_hd.bgn014,
                    g_bgn_hd.bgn11 ,
                    g_bgn_hd.bgn11_fac
 
    CALL i110_bgn013('d',g_bgn_hd.bgn013)
    CALL i110_bgn012('d',g_bgn_hd.bgn012)
    CALL i110_bgn014('d',g_bgn_hd.bgn014)
    CALL i110_bgn11('d',g_bgn_hd.bgn11 )
 
    CALL i110_b_fill(g_wc) #單身
    CALL i110_sum()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i110_r()
DEFINE
    l_chr LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_bgn_hd.bgn01 IS NULL THEN
        CALL cl_err('', -400, 0)
        RETURN
    END IF
    BEGIN WORK
    CALL i110_show()
    IF cl_delh(0,0) THEN                         #詢問是否取消資料
        INITIALIZE g_doc.* TO NULL              #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bgn02"             #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bgn012"            #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bgn013"            #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bgn014"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bgn_hd.bgn02       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bgn_hd.bgn012      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bgn_hd.bgn013      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_bgn_hd.bgn014      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                      #No.FUN-9B0098 10/02/24
        DELETE FROM bgn_file
         WHERE bgn01 = g_bgn_hd.bgn01
           AND bgn02 = g_bgn_hd.bgn02
           AND bgn012 = g_bgn_hd.bgn012
           AND bgn013 = g_bgn_hd.bgn013
           AND bgn014 = g_bgn_hd.bgn014
           AND bgn11  = g_bgn_hd.bgn11
           AND bgn11_fac = g_bgn_hd.bgn11_fac
 
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_bgn_hd.bgn01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("del","bgn_file",g_bgn_hd.bgn01,g_bgn_hd.bgn02,SQLCA.sqlcode,"","",1) #FUN-660105
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i110_pre_x                  #No.TQC-720019
            PREPARE i110_pre_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i110_pre_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_bgn.clear()
            OPEN i110_cnt
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i110_cs
               CLOSE i110_cnt
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i110_cnt INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i110_cs
               CLOSE i110_cnt
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i110_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i110_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET g_no_ask = TRUE                #No.FUN-6A0057 g_no_ask
               CALL i110_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#處理單身欄位(bgn03, bgn04, bgn05, bgn06, bgn07, bgn08)輸入
FUNCTION i110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用   #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否   #No.FUN-680061 VARCHAR(01)
    l_exit_sw       LIKE type_file.chr1,    #Esc結束INPUT ARRAY 否 #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,    #處理狀態     #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否     #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否     #No.FUN-680061 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_bgn_hd.bgn01 IS NULL THEN
        RETURN
    END IF
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT bgn03, bgn04, bgn05, bgn06, bgn07, bgn08 FROM bgn_file ",
        "  WHERE bgn01 = ? AND bgn02 = ? AND bgn012 = ? AND bgn013 = ? ",
        " AND bgn014 = ? AND bgn11  = ? AND bgn11_fac = ? AND bgn03 = ? ",
        " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bgn WITHOUT DEFAULTS FROM s_bgn.*
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
            LET l_lock_sw = 'N'                  #DEFAULT
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_bgn_t.* = g_bgn[l_ac].*    #BACKUP
                OPEN i110_bcl USING g_bgn_hd.bgn01,g_bgn_hd.bgn02,g_bgn_hd.bgn012,g_bgn_hd.bgn013,g_bgn_hd.bgn014,g_bgn_hd.bgn11,g_bgn_hd.bgn11_fac,g_bgn_t.bgn03
                IF STATUS THEN
                   CALL cl_err("OPEN i110_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bgn_t.bgn03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   FETCH i110_bcl INTO g_bgn[l_ac].*
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bgn[l_ac].* TO NULL
            LET g_bgn[l_ac].bgn05=0
            LET g_bgn[l_ac].bgn06=0
            LET g_bgn[l_ac].bgn07=0
            LET g_bgn[l_ac].bgn08=0
            LET g_bgn_t.* = g_bgn[l_ac].*        #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO bgn_file(bgn01,bgn012,bgn013,bgn014,bgn02,bgn03, #No.MOD-470041
                                 bgn04,bgn05,bgn06,bgn07,bgn08,bgn09,
                                 bgn10,bgn11,bgn11_fac)
                 VALUES(g_bgn_hd.bgn01,g_bgn_hd.bgn012,g_bgn_hd.bgn013,
                        g_bgn_hd.bgn014,g_bgn_hd.bgn02,g_bgn[l_ac].bgn03,
                        g_bgn[l_ac].bgn04,g_bgn[l_ac].bgn05,g_bgn[l_ac].bgn06,
                        g_bgn[l_ac].bgn07,g_bgn[l_ac].bgn08,'','',
                        g_bgn_hd.bgn11,g_bgn_hd.bgn11_fac)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bgn[l_ac].bgn03,SQLCA.sqlcode,0) #FUN-660105
                CALL cl_err3("ins","bgn_file",g_bgn_hd.bgn01,g_bgn_hd.bgn02,SQLCA.sqlcode,"","",1) #FUN-660105
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                CALL i110_sum()
                COMMIT WORK
            END IF
 
        AFTER FIELD bgn03
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_bgn[l_ac].bgn03) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_bgn_hd.bgn02
            IF g_azm.azm02 = 1 THEN
              #IF g_bgn[l_ac].bgn03 > 12 OR g_bgn[l_ac].bgn03 < 1 THEN   #NO.MOD-B70165 mark
               IF g_bgn[l_ac].bgn03 > 12 OR g_bgn[l_ac].bgn03 < 0 THEN   #NO.MOD-B70165 add
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bgn03
               END IF
            ELSE
              #IF g_bgn[l_ac].bgn03 > 13 OR g_bgn[l_ac].bgn03 < 1 THEN    #NO.MOD-B70165 mark
               IF g_bgn[l_ac].bgn03 > 13 OR g_bgn[l_ac].bgn03 < 0 THEN    #NO.MOD-B70165 add
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bgn03
               END IF
            END IF
#            IF g_bgn[l_ac].bgn03 < 0 OR g_bgn[l_ac].bgn03 > 12 THEN
#                NEXT FIELD bgn03
#No.TQC-720032 -- end --
            ELSE
                IF g_bgn_t.bgn03 <> g_bgn[l_ac].bgn03 THEN
                    LET l_n = 0
                    SELECT COUNT(*)
                      INTO l_n
                      FROM bgn_file
                     WHERE bgn01 = g_bgn_hd.bgn01
                       AND bgn02 = g_bgn_hd.bgn02
                       AND bgn012 = g_bgn_hd.bgn012
                       AND bgn013 = g_bgn_hd.bgn013
                       AND bgn014 = g_bgn_hd.bgn014
                       AND bgn11  = g_bgn_hd.bgn11
                       AND bgn11_fac = g_bgn_hd.bgn11_fac
                       AND bgn03 = g_bgn[l_ac].bgn03
                    IF l_n > 0 THEN
                        CALL cl_err(g_bgn[l_ac].bgn03, -239, 0)
                        NEXT FIELD bgn03
                    END IF
                END IF
            END IF  
 
        #No.TQC-970265  --Begin
        AFTER FIELD bgn04
            LET g_bgn[l_ac].bgn04 = s_digqty(g_bgn[l_ac].bgn04,g_bgn_hd.bgn11)   #FUN-910088--add--
            DISPLAY BY NAME g_bgn[l_ac].bgn04                                    #FUN-910088--add--
           #IF g_bgn[l_ac].bgn04 < 0 THEN                            #No.MOD-B70165 mark
            IF g_bgn[l_ac].bgn03 > 0 AND g_bgn[l_ac].bgn04 < 0 THEN  #No.MOD-B70165 add
               CALL cl_err(g_bgn[l_ac].bgn04,'axr-610',0)
               NEXT FIELD bgn04
            END IF
        #No.TQC-970265  --End  
 
        AFTER FIELD bgn05
            IF g_bgn[l_ac].bgn05 < 0 THEN
               CALL cl_err(g_bgn[l_ac].bgn05,'axm-179',0)  #No.TQC-970265
               NEXT FIELD bgn05
            END IF
 
        AFTER FIELD bgn06
            IF g_bgn[l_ac].bgn06 < 0 THEN
               CALL cl_err(g_bgn[l_ac].bgn06,'axm-179',0)  #No.TQC-970265
               NEXT FIELD bgn06
            END IF
 
        AFTER FIELD bgn07
            IF g_bgn[l_ac].bgn07 < 0 THEN
               CALL cl_err(g_bgn[l_ac].bgn07,'axm-179',0)  #No.TQC-970265
               NEXT FIELD bgn07
            END IF
 
        AFTER FIELD bgn08
            IF g_bgn[l_ac].bgn08 < 0 THEN
               CALL cl_err(g_bgn[l_ac].bgn08,'axm-179',0)  #No.TQC-970265
               NEXT FIELD bgn08
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bgn_t.bgn03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bgn_file             #刪除該筆單身資料
                 WHERE bgn01 = g_bgn_hd.bgn01
                   AND bgn02 = g_bgn_hd.bgn02
                   AND bgn012 = g_bgn_hd.bgn012
                   AND bgn013 = g_bgn_hd.bgn013
                   AND bgn014 = g_bgn_hd.bgn014
                   AND bgn11  = g_bgn_hd.bgn11
                   AND bgn11_fac = g_bgn_hd.bgn11_fac
                   AND bgn03 = g_bgn_t.bgn03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bgn_t.bgn03,SQLCA.sqlcode,0) #FUN-660105
                    CALL cl_err3("del","bgn_file",g_bgn_hd.bgn01,g_bgn_t.bgn03,SQLCA.sqlcode,"","",1) #FUN-660105
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL i110_sum()
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bgn[l_ac].* = g_bgn_t.*
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgn[l_ac].bgn03,-263,1)
               LET g_bgn[l_ac].* = g_bgn_t.*
            ELSE
               UPDATE bgn_file
                  SET bgn03 = g_bgn[l_ac].bgn03,
                      bgn04 = g_bgn[l_ac].bgn04,
                      bgn05 = g_bgn[l_ac].bgn05,
                      bgn06 = g_bgn[l_ac].bgn06,
                      bgn07 = g_bgn[l_ac].bgn07,
                      bgn08 = g_bgn[l_ac].bgn08
                WHERE CURRENT OF i110_bcl
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bgn[l_ac].bgn03, SQLCA.sqlcode, 0) #FUN-660105
                   CALL cl_err3("upd","bgn_file",g_bgn[l_ac].bgn03,"",SQLCA.sqlcode,"","",1) #FUN-660105
                   LET g_bgn[l_ac].* = g_bgn_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CALL i110_sum()
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bgn[l_ac].* = g_bgn_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i110_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE i110_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i110_b_askkey()
            EXIT INPUT
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(bgn03) AND l_ac > 1 THEN
                LET g_bgn[l_ac].* = g_bgn[l_ac-1].*
                NEXT FIELD bgn03
            END IF
 
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
    CALL i110_delHeader()   #CHI-C30002 add
    CLOSE i110_bcl
    COMMIT WORK
#   CALL i110_delall()      #CHI-C30002 mark
END FUNCTION
 
#CHI-C30002 ------- add ------- begin
FUNCTION i110_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
        DELETE FROM bgn_file
         WHERE bgn01 = g_bgn_hd.bgn01
           AND bgn02 = g_bgn_hd.bgn02
           AND bgn012 = g_bgn_hd.bgn012
           AND bgn013 = g_bgn_hd.bgn013
           AND bgn014 = g_bgn_hd.bgn014
           AND bgn11  = g_bgn_hd.bgn11
           AND bgn11_fac = g_bgn_hd.bgn11_fac
        INITIALIZE g_bgn_hd.* TO NULL
        CLEAR FORM
     END IF
  END IF
END FUNCTION
#CHI-C30002 ------- add ------- end

##CHI-C30002 ------ mark ------- begin
#FUNCTION i110_delall()
#   SELECT COUNT(*)
#     INTO g_cnt
#     FROM bgn_file
#    WHERE bgn01 = g_bgn_hd.bgn01
#      AND bgn02 = g_bgn_hd.bgn02
#      AND bgn012 = g_bgn_hd.bgn012
#      AND bgn013 = g_bgn_hd.bgn013
#      AND bgn014 = g_bgn_hd.bgn014
#      AND bgn11  = g_bgn_hd.bgn11
#      AND bgn11_fac = g_bgn_hd.bgn11_fac
#   IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料
#       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#       ERROR g_msg CLIPPED
#       DELETE FROM bgn_file
#        WHERE bgn01 = g_bgn_hd.bgn01
#          AND bgn02 = g_bgn_hd.bgn02
#          AND bgn012 = g_bgn_hd.bgn012
#          AND bgn013 = g_bgn_hd.bgn013
#          AND bgn014 = g_bgn_hd.bgn014
#          AND bgn11  = g_bgn_hd.bgn11
#          AND bgn11_fac = g_bgn_hd.bgn11_fac
#   END IF
##END FUNCTION
#CHI-C30002 ------ add ------ end
 
#單身重查
FUNCTION i110_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON bgn03, bgn04, bgn05, bgn06, bgn07, bgn08
         FROM s_bgn[1].bgn03, s_bgn[1].bgn04, s_bgn[1].bgn05,
              s_bgn[1].bgn06, s_bgn[1].bgn07, s_bgn[1].bgn08
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
                 ON ACTION qbe_SELECT
         	   CALL cl_qbe_SELECT()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i110_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2)                      #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000, #No.FUN-680061 VARCHAR(200)
    l_cnt    LIKE type_file.num5     #No.FUN-680061 SMALLINT
 
    IF cl_null(p_wc2) THEN LET p_wc2=' 1=1' END IF
 
    LET g_sql =
        "SELECT bgn03, bgn04, bgn05, bgn06, bgn07, bgn08, ''",
        "  FROM bgn_file",
        " WHERE bgn01 ='",g_bgn_hd.bgn01,"' ",
        "   AND bgn02 ='",g_bgn_hd.bgn02,"' ",
        "   AND bgn012 ='",g_bgn_hd.bgn012,"' ",
        "   AND bgn013 ='",g_bgn_hd.bgn013,"' ",
        "   AND bgn014 ='",g_bgn_hd.bgn014,"' ",
        "   AND bgn11  ='",g_bgn_hd.bgn11,"' ",
       #"   AND bgn11_fac ='",g_bgn_hd.bgn11_fac,"' ",
        "   AND bgn11_fac =",g_bgn_hd.bgn11_fac,
        "   AND ", p_wc2 CLIPPED,
        " ORDER BY bgn03"
    PREPARE i110_pb
       FROM g_sql
    DECLARE i110_bcs                             #SCROLL CURSOR
     CURSOR FOR i110_pb
 
    CALL g_bgn.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH i110_bcs INTO g_bgn[g_cnt].*         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bgn.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i110_copy()
DEFINE
    old_ver     LIKE bgn_file.bgn01,        #原版本 #NO.FUN-680061 VARCHAR(10)
    oyy         LIKE bgn_file.bgn02,        #原年度 #NO.FUN-680061 SMALLINT
    obgn013     LIKE bgn_file.bgn013,       #客戶編號
    obgn012     LIKE bgn_file.bgn012,       #部門編號
    obgn014     LIKE bgn_file.bgn014,       #產品分類
    obgn11      LIKE bgn_file.bgn11 ,       #
    obgn11_fac  LIKE bgn_file.bgn11_fac,    #
    new_ver     LIKE bgn_file.bgn01,        #新版本 #NO.FUN-680061 VARCHAR(10)
    nyy         LIKE bgn_file.bgn02,        #新年度 #NO.FUN-680061 SMALLINT
    l_i         LIKE type_file.num10,       #拷貝筆數  #No.FUN-680061 INTEGER
    l_bgn       RECORD  LIKE bgn_file.*     #複製用buffer
 
 
    OPEN WINDOW i110_c_w AT 11,20 WITH FORM "abg/42f/abgi110_c"
        ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_locale("abgi110_c")   #TQC-630053
 
    IF STATUS THEN
       CALL cl_err('open window i110_c_w:',STATUS,0)
       RETURN
    END IF
 WHILE TRUE
    LET old_ver = g_bgn_hd.bgn01
    LET oyy = g_bgn_hd.bgn02
    LET obgn013 = g_bgn_hd.bgn013
    LET obgn012 = g_bgn_hd.bgn012
    LET obgn014 = g_bgn_hd.bgn014
    LET obgn11  = g_bgn_hd.bgn11
    LET obgn11_fac = g_bgn_hd.bgn11_fac
    LET new_ver = NULL
    LET nyy = NULL
 
    INPUT BY NAME
        old_ver, oyy, obgn013, obgn012, obgn014,obgn11,obgn11_fac,
        new_ver, nyy
        WITHOUT DEFAULTS
 
        AFTER FIELD old_ver
            IF old_ver IS NULL THEN
                LET old_ver = ' '
            END IF
 
        AFTER FIELD oyy
            IF cl_null(oyy) OR oyy < 0 THEN
                NEXT FIELD oyy
            END IF
 
        AFTER FIELD obgn013
            IF cl_null(obgn013) THEN
                NEXT FIELD obgn013
            ELSE
                CALL i110_bgn013('a',obgn013)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD obgn013
                END IF
            END IF
 
        AFTER FIELD obgn012
            IF cl_null(obgn012) THEN
                NEXT FIELD obgn012
            ELSE
                CALL i110_bgn012('a',obgn012)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD obgn012
                END IF
            END IF
 
        AFTER FIELD obgn014
            IF cl_null(obgn014) THEN
                NEXT FIELD obgn014
            ELSE
                CALL i110_bgn014c('a',obgn014)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD obgn014
                END IF
            END IF
 
       AFTER FIELD obgn11
         IF cl_null(obgn11 ) THEN
             NEXT FIELD obgn11
         ELSE
             CALL i110_bgn11c('a',obgn11,old_ver,obgn014 )
             RETURNING obgn11_fac
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD obgn11
             END IF
         END IF
 
        AFTER FIELD new_ver
            IF new_ver IS NULL THEN
                LET new_ver = ' '
            END IF
 
        AFTER FIELD nyy
            IF cl_null(nyy) OR nyy < 0 THEN
                NEXT FIELD nyy
            END IF
 
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
        LET INT_FLAG=0
        CLOSE WINDOW i110_c_w
        RETURN
    END IF
    IF cl_null(new_ver) OR cl_null(nyy      ) THEN
       CONTINUE WHILE
    END IF
    EXIT WHILE
  END WHILE
    CLOSE WINDOW i110_c_w
    CALL cl_set_head_visible("","YES")   #Np.FUN-6B0033
    BEGIN WORK
    LET g_success='Y'
    DECLARE i110_c CURSOR FOR
        SELECT *
          FROM bgn_file
         WHERE bgn01 = old_ver
           AND bgn02 = oyy
           AND bgn013 = obgn013
           AND bgn012 = obgn012
           AND bgn014 = obgn014
           AND bgn11  = obgn11
           AND bgn11_fac = obgn11_fac
    LET l_i = 0
    FOREACH i110_c INTO l_bgn.*
        LET l_i = l_i+1
        LET l_bgn.bgn01 = new_ver
        LET l_bgn.bgn02 = nyy
        INSERT INTO bgn_file VALUES(l_bgn.*)
        IF STATUS THEN
#           CALL cl_err('ins bgn:',STATUS,1) #FUN-660105
            CALL cl_err3("ins","bgn_file",l_bgn.bgn01,l_bgn.bgn02,STATUS,"","ins bgn:",1) #FUN-660105
            LET g_success='N'
        END IF
    END FOREACH
    IF g_success='Y' THEN
        COMMIT WORK
        #FUN-C30027---begin
        LET g_bgn_hd.bgn01 = new_ver
        LET g_bgn_hd.bgn02 = nyy
        LET g_bgn_hd.bgn013 = obgn013
        LET g_bgn_hd.bgn012 = obgn012
        LET g_bgn_hd.bgn014 = obgn014
        LET g_bgn_hd.bgn11 = obgn11
        LET g_bgn_hd.bgn11_fac = obgn11_fac
        LET g_wc = '1=1'
        CALL i110_show()          
        #FUN-C30027---end 
        MESSAGE l_i, ' rows copied!'
    ELSE
        ROLLBACK WORK
        MESSAGE 'rollback work!'
    END IF
END FUNCTION
 
FUNCTION i110_g()
DEFINE
    l_bgm       RECORD
        bgm01   LIKE bgm_file.bgm01,        #原版本
        bgm02   LIKE bgm_file.bgm02,        #原年度
        bgm014  LIKE bgm_file.bgm014,       #客戶編號
        bgm015  LIKE bgm_file.bgm015,       #部門編號
        bgm017  LIKE bgm_file.bgm017        #產品分類
        END RECORD,
    new_ver     LIKE bgn_file.bgn01,        #新版本 #NO.FUN-680061 VARCHAR(10)
    nyy         LIKE bgn_file.bgn02,        #新年度 #NO.FUN-680061 SMALLINT
    g_per       LIKE aao_file.aao05,        #調整率 #NO.FUN-680061 DEC(15,3)
    g_yy        LIKE type_file.num5,        #期初庫存擷取年月 #FUN-680061 SMALLINT
    g_mm        LIKE type_file.num5,        #期初庫存擷取年月 #FUN-680061 SMALLINT
    l_i         LIKE type_file.num10,       #拷貝筆數         #No.FUN-680061 INTEGER
    t_bgn       RECORD  LIKE bgn_file.*,    #複製用buffer
    p_bgn       RECORD  LIKE bgn_file.*,    #複製用buffer
    l_bgn       RECORD  LIKE bgn_file.*,    #複製用buffer
    l_sql       LIKE type_file.chr1000,     #No.FUN-680061 VARCHAR(300)
    l_ima25     LIKE ima_file.ima25,
    l_ima55     LIKE ima_file.ima55,
    l_img09     LIKE img_file.img09,
    l_img10     LIKE img_file.img10,
    l_img10_t   LIKE img_file.img10,
    l_imk09_t   LIKE imk_file.imk09,
    l_imk09     LIKE imk_file.imk09,
    l_bgg06     LIKE bgg_file.bgg06,
    l_fac       LIKE bgn_file.bgn11_fac
DEFINE l_gfe03        LIKE gfe_file.gfe03
 
    IF s_shut(0) THEN RETURN END IF
    OPEN WINDOW i110_g_w AT 10,16 WITH FORM "abg/42f/abgi110_g"
        ATTRIBUTE(STYLE = g_win_style)
     CALL cl_ui_locale("abgi110_g")    #MOD-530238
    IF STATUS THEN
       CALL cl_err('open window i110_g_w:',STATUS,0)
       RETURN
    END IF
 
    INITIALIZE l_bgm.* TO NULL
    LET new_ver = NULL
    LET nyy = NULL
 
    CONSTRUCT g_wc ON bgm01, bgm02, bgm014, bgm015, bgm017
         FROM bgm01, bgm02, bgm014, bgm015, bgm017
 
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
                 ON ACTION qbe_SELECT
         	   CALL cl_qbe_SELECT()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG  THEN
        LET INT_FLAG = 0
        CLOSE WINDOW i110_g_w
        RETURN
    END IF
 
    LET new_ver = NULL
    LET nyy = NULL
    LET g_per=0
    LET g_yy=NULL
    LET g_mm=NULL
 
    INPUT new_ver,nyy,g_per,g_yy,g_mm  WITHOUT DEFAULTS
     FROM FORMONLY.new_ver,FORMONLY.nyy,FORMONLY.per,FORMONLY.yy,FORMONLY.mm
 
        AFTER FIELD new_ver
            IF new_ver IS NULL THEN
                LET new_ver = ' '
            END IF
 
        AFTER FIELD nyy
          IF cl_null(nyy) OR nyy < 1 THEN
             NEXT FIELD nyy
          END IF
 
        AFTER FIELD per
          IF cl_null(g_per) THEN NEXT FIELD per END IF
 
        BEFORE FIELD yy
          LET g_yy=nyy-1 LET g_mm=12
          DISPLAY g_yy TO FORMONLY.yy
          DISPLAY g_mm TO FORMONLY.mm
 
        AFTER FIELD yy
          IF cl_null(g_yy) OR g_yy>=nyy THEN NEXT FIELD yy END IF
 
        AFTER FIELD mm
          IF cl_null(g_mm) THEN NEXT FIELD mm END IF
 
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
 
    IF INT_FLAG
        THEN LET INT_FLAG=0
        CLOSE WINDOW i110_g_w
        RETURN
    END IF
 
    IF cl_sure(0,0) THEN
        #期初庫存年月
        LET l_sql = " SELECT img09,SUM(imk09) FROM img_file,imk_file,imd_file ",
                    " WHERE img01=imk01 ",
                    "   AND img02=imk02 ",
                    "   AND img03=imk03 ",
                    "   AND img04=imk04 ",
                    "   AND imk05=",g_yy," AND imk06=",g_mm,
                    "   AND imk02=imd01 AND imd11='Y' ",
                    "   AND imk01=? ",
                    " GROUP BY img09 "
        PREPARE i110_imk_pre  FROM l_sql
        DECLARE i110_imk CURSOR FOR i110_imk_pre
 
        LET l_sql = "SELECT bgm01, bgm017, bgm02, bgm03,bgm08, ",
                    #"       SUM(bgm04)",   #TQC-630053
                    "        SUM(bgm05)",   #TQC-630053
                    "  FROM bgm_file ",
                    " WHERE ",g_wc CLIPPED,
                    " GROUP BY bgm01, bgm02 ,bgm08,bgm017,bgm03",
                    " ORDER BY bgm01, bgm02 ,bgm08,bgm017,bgm03"
        PREPARE i110_g_pre  FROM l_sql
        DECLARE i110_g CURSOR FOR i110_g_pre
        FOREACH i110_g INTO t_bgn.bgn01,t_bgn.bgn014,t_bgn.bgn02,t_bgn.bgn03,
                            t_bgn.bgn11,t_bgn.bgn04
            IF SQLCA.sqlcode THEN
                CALL cl_err('i110_g',SQLCA.sqlcode,0) EXIT FOREACH
            END IF
            INITIALIZE l_bgn.* TO NULL
            LET l_bgn.bgn01  =new_ver
            LET l_bgn.bgn02  =nyy
            LET l_bgn.bgn03  =t_bgn.bgn03
            LET l_bgn.bgn012='ALL'
            LET l_bgn.bgn013='ALL'
            LET l_bgn.bgn014 =t_bgn.bgn014
            LET l_bgn.bgn05  =0
            LET l_bgn.bgn06  =0
            LET l_bgn.bgn07  =0
            LET l_bgn.bgn08  =0
 
            LET l_bgg06=''
            SELECT ima01 INTO l_bgg06
              FROM ima_file
             WHERE ima01=l_bgn.bgn014
            IF cl_null(l_bgg06) THEN
              SELECT bgg06 into l_bgg06
                FROM bgg_file
               WHERE bgg01=l_bgn.bgn01
                 AND bgg02=l_bgn.bgn014
            END IF
            SELECT ima25,ima55 into l_ima25,l_ima55
              FROM ima_file
             WHERE ima01=l_bgg06
            #No.TQC-9B0137  --Begin                                             
            IF cl_null(l_ima55) THEN LET l_ima55 = ' ' END IF                   
            #No.TQC-9B0137  --End  
            LET l_bgn.bgn11  =l_ima55
            CALL s_umfchk(l_bgg06,l_bgn.bgn11,l_ima25)
            RETURNING g_i,l_fac
            IF g_i THEN LET l_fac=1 END IF
            LET l_bgn.bgn11_fac  =l_fac
 
            #-->考慮單位小數取位
            SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = l_bgn.bgn11
            IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
 
            IF t_bgn.bgn03=1 THEN
               LET l_imk09_t=0
               FOREACH i110_imk  USING l_bgg06
                  INTO l_img09,l_imk09
                   CALL s_umfchk(l_bgg06,l_img09    ,l_bgn.bgn11)
                   RETURNING g_i,l_fac
                   IF g_i THEN LET l_fac=1 END IF
                   LET l_imk09_t=l_imk09_t + l_imk09*l_fac
               END FOREACH
               LET l_bgn.bgn03=0
              #LET l_bgn.bgn04=l_imk09_t*l_fac*-1    #TQC-B70186 mark
               LET l_bgn.bgn04=l_imk09_t*l_fac       #TQC-B70186
               CALL cl_digcut(l_bgn.bgn04,l_gfe03) RETURNING l_bgn.bgn04
               IF cl_null(l_bgn.bgn04) THEN LET l_bgn.bgn04=0 END IF
               INSERT INTO bgn_file VALUES(l_bgn.*)
               IF SQLCA.sqlcode THEN
#                  CALL cl_err('ins bgn',STATUS,1) #FUN-660105
                   CALL cl_err3("ins","bgn_file",l_bgn.bgn01,l_bgn.bgn02,STATUS,"","ins bgn:",1) #FUN-660105
               END IF
            END IF
            LET l_bgn.bgn03=t_bgn.bgn03
            LET l_bgn.bgn04=0
            INITIALIZE p_bgn.* TO NULL
            LET p_bgn.bgn03=l_bgn.bgn03-1
            SELECT * INTO p_bgn.* FROM bgn_file
             WHERE bgn01=l_bgn.bgn01
               AND bgn012=l_bgn.bgn012
               AND bgn013=l_bgn.bgn013
               AND bgn014=l_bgn.bgn014
               AND bgn02=l_bgn.bgn02
               AND bgn11=l_bgn.bgn11
               AND bgn11_fac=l_bgn.bgn11_fac
               AND bgn03=p_bgn.bgn03
            IF STATUS THEN
#              CALL cl_err('sel p_bgn err',STATUS,1) #FUN-660105
               CALL cl_err3("sel","bgn_file",l_bgn.bgn01,l_bgn.bgn02,STATUS,"","sel p_bgn err",1) #FUN-660105
            END IF
            CALL s_umfchk(l_bgg06,t_bgn.bgn11,l_bgn.bgn11)
            RETURNING g_i,l_fac
            IF g_i THEN LET l_fac=1 END IF
            #LET l_bgn.bgn04=t_bgn.bgn04*l_fac + p_bgn.bgn04   #TQC-630053
            LET l_bgn.bgn04=t_bgn.bgn04*l_fac   #TQC-630053
            LET l_bgn.bgn04=l_bgn.bgn04*(1+g_per/100)
            CALL cl_digcut(l_bgn.bgn04,l_gfe03) RETURNING l_bgn.bgn04
            IF cl_null(l_bgn.bgn04) THEN LET l_bgn.bgn04=0 END IF
            INSERT INTO bgn_file VALUES (l_bgn.*)
            IF STATUS THEN
#               CALL cl_err('ins bgn',STATUS,1) #FUN-660105
                CALL cl_err3("ins","bgn_file",l_bgn.bgn01,l_bgn.bgn02,STATUS,"","ins bgn",1) #FUN-660105
            END IF
        END FOREACH
    END IF
    CLOSE WINDOW i110_g_w
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
END FUNCTION
 
#單身顯示
FUNCTION i110_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_bgn TO s_bgn.* ATTRIBUTE(COUNT=g_rec_b)   #TQC-630053
   DISPLAY ARRAY g_bgn TO s_bgn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)   #TQC-630053
      BEFORE DISPLAY
 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      #@ ON ACTION "G.自動整批產生"
     #ON ACTION btn01                            #No.TQC-760066 mark
      ON ACTION data_produce                     #No.TQC-760066 
        #LET g_action_choice="btn01"             #No.TQC-760066 mark
         LET g_action_choice="data_produce"      #No.TQC-760066 
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i110_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i110_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i110_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i110_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i110_fetch('L')
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
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
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
 
 
FUNCTION i110_sum()
    DEFINE
        l_tot5  LIKE bgn_file.bgn05,
        l_tot6  LIKE bgn_file.bgn06,
        l_tot7  LIKE bgn_file.bgn07,
        l_tot8  LIKE bgn_file.bgn08
 
    LET l_tot5 = 0
    LET l_tot6 = 0
    LET l_tot7 = 0
    LET l_tot8 = 0
 
    SELECT SUM(bgn05*bgn04), SUM(bgn06*bgn04),
           SUM(bgn07*bgn04), SUM(bgn08*bgn04)
      INTO l_tot5, l_tot6, l_tot7, l_tot8
      FROM bgn_file
     WHERE bgn01 = g_bgn_hd.bgn01
       AND bgn02 = g_bgn_hd.bgn02
       AND bgn012 = g_bgn_hd.bgn012
       AND bgn013 = g_bgn_hd.bgn013
       AND bgn014 = g_bgn_hd.bgn014
       AND bgn11  = g_bgn_hd.bgn11
       AND bgn11_fac = g_bgn_hd.bgn11_fac
       AND bgn03 <>0
    IF cl_null(l_tot5) THEN LET l_tot5 = 0 END IF
    IF cl_null(l_tot6) THEN LET l_tot6 = 0 END IF
    IF cl_null(l_tot7) THEN LET l_tot7 = 0 END IF
    IF cl_null(l_tot8) THEN LET l_tot8 = 0 END IF
 
    DISPLAY l_tot5, l_tot6, l_tot7, l_tot8
         TO tot5, tot6, tot7, tot8
 
END FUNCTION
 
FUNCTION i110_out()
DEFINE l_cmd         LIKE type_file.chr1000,       #No.FUN-680061 VARCHAR(400)
       l_wc,l_wc2    LIKE type_file.chr1000,       #No.FUN-680061 VARCHAR(300)
       l_prtway      LIKE zz_file.zz22
 
   IF cl_null(g_wc) THEN
      #-----TQC-610054---------
      LET l_wc=' bgn012="',g_bgn_hd.bgn012,'" ',
               ' AND bgn013="',g_bgn_hd.bgn013,'" ',
               ' AND bgn014="',g_bgn_hd.bgn014,'" '
      #LET l_wc=' bgn01="',g_bgn_hd.bgn01,'" ',
      #         ' AND bgn02="',g_bgn_hd.bgn02,'" ',
      #         ' AND bgn014="',g_bgn_hd.bgn014,'" '
      #-----END TQC-610054-----
   ELSE
      LET l_wc=g_wc CLIPPED
   END IF
   LET l_cmd = "abgr504 ",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",' ',
               #"'",l_wc CLIPPED,"'"    #TQC-610054
               "\"",l_wc CLIPPED,"\""," '' '' '' 'NNN' 'NNN' "   #TQC-610054
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
 
 
END FUNCTION
 
#No.FUN-570108--begin
FUNCTION i110_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("bgn01,bgn012,bgn013,bgn014,bgn02,bgn11,bgn11_fac",TRUE)
   END IF
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("bgn01,bgn012,bgn013,bgn014,bgn02,bgn11,bgn11_fac",FALSE)
   END IF
END FUNCTION
#No.FUN-570108--end
#Patch....NO.TQC-610035 <001,002> #

