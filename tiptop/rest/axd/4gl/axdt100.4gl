#
# Pattern name...: axdt100.4gl
# Descriptions...: 客戶庫存調整作業
# Date & Author..: 03/12/04 By Carrier
# Modify.........: 04/07/19 By Wiky Bugno:MOD-470041 修改INSERT INTO...
# Modify.........: No:MOD-4B0082 04/11/10 By Carrier
# Modify.........: No:MOD-4B0067 04/11/10 By Elva 將變數用Like方式定義
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No:FUN-550026 05/05/20 By jackie 單據編號加大
# Modify.........: No:MOD-570124 05/07/06 By Carrier 批號為空，則賦為' ',不做分銷控管的客戶輸入時予于提醒
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-690023 06/09/19 By jamie 判斷occacti
# Modify.........: No:FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: Mo:FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No:TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:TQC-790087 07/09/14 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_ads    RECORD LIKE ads_file.*,       #客戶庫存調整單頭檔
    g_ads_t  RECORD LIKE ads_file.*,       #客戶庫存調整單頭檔(舊值)
    g_ads_o  RECORD LIKE ads_file.*,       #客戶庫存調整單頭檔(舊值)
    g_ads01_t       LIKE ads_file.ads01,   #庫存調整號(舊值)
    g_ads_rowid     LIKE type_file.chr18,         #No.FUN-680108 INT
 g_adt           DYNAMIC ARRAY OF RECORD    #客戶庫存調整單身檔
        adt02       LIKE adt_file.adt02,   #項次
        adt03       LIKE adt_file.adt03,   #商品編號
        ima02       LIKE ima_file.ima02,   #品名
        adt05       LIKE adt_file.adt05,   #單位
        adt06       LIKE adt_file.adt06,   #數量
        adt04       LIKE adt_file.adt04,   #批號
        adt07       LIKE adt_file.adt07    #備注
                    END RECORD,
 g_adt_t         RECORD                 #客戶庫存調整單身檔 (舊值)
        adt02       LIKE adt_file.adt02,   #項次
        adt03       LIKE adt_file.adt03,   #商品編號
        ima02       LIKE ima_file.ima02,   #品名
        adt05       LIKE adt_file.adt05,   #單位
        adt06       LIKE adt_file.adt06,   #數量
        adt04       LIKE adt_file.adt04,   #批號
        adt07       LIKE adt_file.adt07    #備注
                    END RECORD,
    g_cmd           LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(200)
    g_t1            LIKE oay_file.oayslip, #No.FUN-550026        #No.FUN-680108 VARCHAR(055555)
    g_wc,g_sql,g_wc2    string,            #No:FUN-580092 HCN   
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680108 SMALLINT 
    g_flag          LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680108 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE   g_forupd_sql    STRING                 #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_chr           LIKE ads_file.adsacti  #No.FUN-680108 VARCHAR(01)
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(72)
DEFINE   g_before_input_done  LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE   g_type          LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(02)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5     #No.FUN-680108 SMALLINT   #No.FUN-6A0078
#主程式開始
MAIN
DEFINE
    l_tadt           LIKE type_file.chr8                #計算被使用時間   #No.FUN-680108 VARCHAR(8)

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
# Prog. Version..: '5.10.00-08.01.04(00007)'     #

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
    IF INT_FLAG THEN EXIT PROGRAM END IF

      CALL cl_used(g_prog,l_tadt,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818
        RETURNING l_tadt
    LET g_ads01_t = NULL                   #清除鍵值
    INITIALIZE g_ads_t.* TO NULL
    INITIALIZE g_ads.* TO NULL
       LET p_row = 4 LET p_col = 8

    OPEN WINDOW t100_w AT p_row,p_col           #顯示畫面
        WITH FORM "axd/42f/axdt100"
         ATTRIBUTE(STYLE = g_win_style)

    CALL cl_ui_init()
    CALL g_x.clear()
    LET g_forupd_sql ="SELECT * FROM ads_file WHERE ads01 = ? FOR UPDATE NOWAIT"
    DECLARE t100_cl CURSOR FROM g_forupd_sql
    CALL t100_menu()    #中文

    CLOSE WINDOW t100_w                 #結束畫面
      CALL cl_used(g_prog,l_tadt,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818
        RETURNING l_tadt
END MAIN

#QBE 查詢資料
FUNCTION t100_cs()
     DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No:FUN-580031

     CLEAR FORM                             #清除畫面
     CALL g_adt.clear()
     CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

  CONSTRUCT BY NAME g_wc ON
                  ads01,ads02,ads06,ads03,ads04,ads05,
                  adsconf,adspost,
                  adsuser,adsgrup,adsmodu,adsdate,adsacti

        BEFORE CONSTRUCT
            CALL cl_qbe_init()                     #No:FUN-580031

        ON ACTION CONTROLP
           CASE WHEN INFIELD(ads01)
                   CALL cl_init_qry_var()
#                    LET g_t1=g_ads.ads01[1,3]
                    LET g_t1 = s_get_doc_no(g_ads.ads01)       #No.FUN-550026
                   #CALL q_adz(FALSE,TRUE,g_t1,'20','axd') RETURNING g_t1  #TQC-670008 remark
                    CALL q_adz(FALSE,TRUE,g_t1,'20','AXD') RETURNING g_t1  #TQC-670008
                    LET g_qryparam.multiret=g_t1
                    DISPLAY g_qryparam.multiret TO ads01
                    NEXT FIELD ads01
               WHEN INFIELD(ads03)
                    #CALL q_gen(0,0,g_add.add03) RETURNING g_add.add03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_occ"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ads.ads03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ads03
                    NEXT FIELD ads03
                WHEN INFIELD(ads04)
                    #CALL q_gem(0,0,g_add.add04) RETURNING g_add.add04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ads.ads04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ads04
                    NEXT FIELD ads04
                WHEN INFIELD(ads05)
                    #CALL q_gem(0,0,g_add.add04) RETURNING g_add.add04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_ads.ads05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ads05
                    NEXT FIELD ads05
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

           #No:FUN-580031 --start--
           ON ACTION qbe_select
               CALL cl_qbe_list() RETURNING lc_qbe_sn
               CALL cl_qbe_display_condition(lc_qbe_sn)
           #No:FUN-580031 ---end---

       END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
     CONSTRUCT g_wc2 ON adt02,adt03,adtd05,adt06,adt04,  #螢幕上取單身條件
                        adt07
        FROM s_adt[1].adt02,s_adt[1].adt03,s_adt[1].adt05,
             s_adt[1].adt06,s_adt[1].adt04,s_adt[1].adt07

        #No:FUN-580031 --start--
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        #No:FUN-580031 ---end---

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD (adt03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_ima"
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_adt[1].adt03
                 NEXT FIELD adt03
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

        #No:FUN-580031 --start--
        ON ACTION qbe_save
            CALL cl_qbe_save()
        #No:FUN-580031 ---end---
 
        END CONSTRUCT
    IF INT_FLAG THEN  RETURN END IF
    IF g_priv2='4' THEN                           #只能使用自己的資料
       LET g_wc = g_wc clipped," AND adsuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND adsgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      LET g_wc = g_wc clipped," AND adsgrup IN ",cl_chk_tgrup_list()
    END IF

    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ROWID, ads01 FROM ads_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 2"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ads_file.ROWID, ads01 ",
                  "  FROM ads_file, adt_file ",
                  " WHERE ads01 = adt01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 2"
    END IF
    PREPARE t100_prepare FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) EXIT PROGRAM END IF
    DECLARE t100_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t100_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ads_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct ads01)",
                  " FROM ads_file,adt_file WHERE ",
                  " ads01=adt01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF
    PREPARE t100_precount FROM g_sql
    DECLARE t100_count CURSOR FOR t100_precount
END FUNCTION

#中文的MENU
FUNCTION t100_menu()
   WHILE TRUE
      CALL t100_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t100_a()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t100_q()
            END IF

         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t100_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t100_u()
            END IF

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t100_x()
                CALL cl_set_field_pic(g_ads.adsconf,"",g_ads.adspost,"","",g_ads.adsacti)  #NO.MOD-4B0082
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t100_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t100_copy()
            END IF

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_y()
                CALL cl_set_field_pic(g_ads.adsconf,"",g_ads.adspost,"","",g_ads.adsacti)  #NO.MOD-4B0082
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_w()
                CALL cl_set_field_pic(g_ads.adsconf,"",g_ads.adspost,"","",g_ads.adsacti)  #NO.MOD-4B0082
            END IF

         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t100_s()
                CALL cl_set_field_pic(g_ads.adsconf,"",g_ads.adspost,"","",g_ads.adsacti)  #NO.MOD-4B0082
            END IF

         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t100_z()
                CALL cl_set_field_pic(g_ads.adsconf,"",g_ads.adspost,"","",g_ads.adsacti)  #NO.MOD-4B0082
            END IF

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()

         #No:FUN-6A0165-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ads.ads01 IS NOT NULL THEN
                 LET g_doc.column1 = "ads01"
                 LET g_doc.value1 = g_ads.ads01
                 CALL cl_doc()
               END IF
         END IF
         #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE

END FUNCTION

#Add  輸入
FUNCTION t100_a()
DEFINE li_result   LIKE type_file.num5        #No.FUN-550026        #No.FUN-680108 SMALLINT
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無新增之功能
    CLEAR FORM
    CALL g_adt.clear()                                  # 清螢墓欄位內容
    INITIALIZE g_ads.* LIKE ads_file.*
    LET g_ads01_t = NULL
    LET g_ads_t.*=g_ads.*
    LET g_ads.ads02 = g_today                    #DEFAULT
    LET g_ads.ads04 = g_user                     #DEFAULT
    LET g_ads.ads05 = g_grup                     #DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ads.adsacti ='Y'                   #有效的資料
        LET g_ads.adsconf ='N'                   #有效的資料
        LET g_ads.adspost ='N'                   #有效的資料
        LET g_ads.adsuser = g_user
        LET g_ads.adsgrup = g_grup               #使用者所屬群
        LET g_ads.adsdate = g_today
        CALL t100_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_ads.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        IF g_ads.ads01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
#No.FUN-550026 --start--
        CALL s_auto_assign_no("axd",g_ads.ads01,g_ads.ads02,"20","ads_file","ads01","","","")
             RETURNING li_result,g_ads.ads01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_ads.ads01
{
        IF g_adz.adzauno='Y' THEN   #need modify to add ads_file in it
           CALL s_axdauno(g_ads.ads01,g_ads.ads02) RETURNING g_i,g_ads.ads01
           IF g_i THEN #有問題
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
           END IF
           DISPLAY BY NAME g_ads.ads01
        END IF
}
#No.FUN-550026 ---end--
        INSERT INTO ads_file VALUES(g_ads.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        COMMIT WORK
        SELECT ROWID INTO g_ads_rowid FROM ads_file
         WHERE ads01 = g_ads.ads01
        LET g_ads01_t = g_ads.ads01        #保留舊值
        LET g_ads_t.* = g_ads.*
        CALL g_adt.clear()
        LET g_rec_b=0
        CALL t100_b()                   #輸入單身
    SELECT * FROM ads_file WHERE ads01=g_ads.ads01
    IF SQLCA.sqlcode =0 THEN
    IF g_adz.adzconf = 'Y' THEN CALL t100_y() END IF
    END IF
    EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION t100_i(p_cmd)
    DEFINE
        l_sw            LIKE type_file.chr1,   #檢查必要欄位是否空白    #No.FUN-680108 VARCHAR(1)
        p_cmd           LIKE type_file.chr1,                            #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5,                            #No.FUN-680108 SMALLINT
        l_obw           RECORD LIKE obw_file.*
    DEFINE li_result   LIKE type_file.num5     #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT BY NAME g_ads.ads01,g_ads.ads02,g_ads.ads06,g_ads.ads03,
                  g_ads.ads04,g_ads.ads05,g_ads.adsconf,g_ads.adspost,
                  g_ads.adsuser,g_ads.adsgrup,
                  g_ads.adsmodu,g_ads.adsdate,g_ads.adsacti
                  WITHOUT DEFAULTS HELP 1
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t100_set_entry(p_cmd)
            CALL t100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550026 --start--
         CALL cl_set_docno_format("ads01")
#No.FUN-550026 ---end---

        AFTER FIELD ads01
            IF NOT cl_null(g_ads.ads01) AND (g_ads.ads01!=g_ads01_t) THEN   #No.FUN-550026
#No.FUN-550026 --start--
    CALL s_check_no("axd",g_ads.ads01,g_ads01_t,"20","ads_file","ads01","")
         RETURNING li_result,g_ads.ads01
    DISPLAY BY NAME g_ads.ads01
       IF (NOT li_result) THEN
          NEXT FIELD ads01
       END IF
{
            LET g_t1 = g_ads.ads01[1,3]
            SELECT * INTO g_adz.* FROM adz_file WHERE adzslip = g_t1
               AND adztype = '20'
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ads.ads01,'mfg0014',0)
               NEXT FIELD ads01
            END IF
            IF p_cmd = 'a' AND cl_null(g_ads.ads01[5,10]) AND g_adz.adzauno='N'
               THEN NEXT FIELD ads01
            END IF
            IF g_ads.ads01 != g_ads_t.ads01 OR g_ads_t.ads01 IS NULL THEN
                IF g_adz.adzauno = 'Y'
                   AND NOT cl_chk_data_continue(g_ads.ads01[5,10]) THEN
                   CALL cl_err('','9056',0) NEXT FIELD ads01
                END IF
                SELECT count(*) INTO g_cnt FROM ads_file
                    WHERE ads01 = g_ads.ads01
                IF g_cnt > 0 THEN   #資料重復
                    CALL cl_err(g_ads.ads01,-239,0)
                    LET g_ads.ads01 = g_ads_t.ads01
                    DISPLAY BY NAME g_ads.ads01
                    NEXT FIELD ads01
                END IF
            END IF
}
#No.FUN-550026 ---end--
         END IF

     AFTER FIELD ads03
            IF NOT cl_null(g_ads.ads03) THEN
            CALL t100_ads03('a')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               LET g_ads.ads03 = g_ads_t.ads03
               DISPLAY BY NAME g_ads.ads03
               NEXT FIELD ads03
            END IF
        END IF
 
     AFTER FIELD ads04
           IF NOT cl_null(g_ads.ads04) THEN
             CALL t100_ads04('a')
             IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               LET g_ads.ads04 = g_ads_t.ads04
               DISPLAY BY NAME g_ads.ads04
               NEXT FIELD ads04
             END IF
             SELECT gen03 INTO g_ads.ads05 FROM gen_file
             WHERE gen01 = g_ads.ads04
             DISPLAY BY NAME g_ads.ads04
           END IF
 
     AFTER FIELD ads05
            IF NOT cl_null(g_ads.ads05) THEN
            CALL t100_ads05('a')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               LET g_ads.ads05 = g_ads_t.ads05
               DISPLAY BY NAME g_ads.ads05
               NEXT FIELD ads05
            END IF
            END IF

        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                 #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

        ON ACTION CONTROLP
           CASE WHEN INFIELD(ads01)
#                    LET g_t1=g_ads.ads01[1,3]
                    LET g_t1 = s_get_doc_no(g_ads.ads01)       #No.FUN-550026
                    #CALL q_adz(FALSE,FALSE,g_t1,'20','axd') RETURNING g_t1 #TQC-670008 remark
                    CALL q_adz(FALSE,FALSE,g_t1,'20','AXD') RETURNING g_t1  #TQC-670008
#                    LET g_ads.ads01[1,3]=g_t1
                    LET g_ads.ads01 = g_t1       #No.FUN-550026
                    DISPLAY BY NAME g_ads.ads01
                    NEXT FIELD ads01
                WHEN INFIELD(ads03)
                    #CALL q_gen(0,0,g_add.add03) RETURNING g_add.add03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_occ"
                    LET g_qryparam.default1 = g_ads.ads03
                    CALL cl_create_qry() RETURNING g_ads.ads03
                    DISPLAY BY NAME g_ads.ads03
                    NEXT FIELD ads03
                WHEN INFIELD(ads04)
                    #CALL q_gem(0,0,g_add.add04) RETURNING g_add.add04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_ads.ads04
                    CALL cl_create_qry() RETURNING g_ads.ads04
                    DISPLAY BY NAME g_ads.ads04
                    NEXT FIELD ads04
                WHEN INFIELD(ads05)
                    #CALL q_gem(0,0,g_add.add04) RETURNING g_add.add04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_ads.ads05
                    CALL cl_create_qry() RETURNING g_ads.ads05
                    DISPLAY BY NAME g_ads.ads05
                    NEXT FIELD ads05
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

FUNCTION t100_ads03(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_occ02     LIKE occ_file.occ02,
         l_occ31     LIKE occ_file.occ31,  #No.MOD-570124
        l_occacti   LIKE occ_file.occacti

  LET g_errno = ' '
   #No.MOD-570124  --begin
  SELECT occ02,occ31,occacti INTO l_occ02,l_occ31,l_occacti FROM occ_file
   WHERE occ01 = g_ads.ads03
  IF cl_null(l_occ31) THEN LET l_occ31='N' END IF

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-045'
                                 LET g_ads.ads03 = NULL
       WHEN l_occacti='N' LET g_errno = '9028'
  #FUN-690023------mod-------
        WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690023------mod-------       
       WHEN l_occ31='N'   LET g_errno = 'axd-115'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
   #No.MOD-570124  --end
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_occ02 TO FORMONLY.occ02
  END IF
END FUNCTION

FUNCTION t100_adt03(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_ima02     LIKE ima_file.ima02,
        l_ima25     LIKE ima_file.ima25,
        l_imaacti   LIKE ima_file.imaacti

  LET g_errno = ' '
  SELECT ima02,imaacti,ima25
    INTO g_adt[l_ac].ima02,l_imaacti,g_adt[l_ac].adt05
    FROM ima_file
   WHERE ima01 = g_adt[l_ac].adt03

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-003'  #No.MOD-570124
                                 LET g_adt[l_ac].adt03 = NULL
                                 LET g_adt[l_ac].adt05 = NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
   #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
   #FUN-690022------mod-------       
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  #------MOD-5A0095 START----------
  DISPLAY BY NAME g_adt[l_ac].ima02
  DISPLAY BY NAME g_adt[l_ac].adt05
  #------MOD-5A0095 END------------
END FUNCTION

FUNCTION t100_ads04(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti

  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
   WHERE gen01 = g_ads.ads04

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET g_ads.ads04 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION

FUNCTION t100_ads05(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti

  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
                          WHERE gem01 = g_ads.ads05

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET g_ads.ads05 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION

FUNCTION t100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ads.* TO NULL               #NO.FUN-6A0165     
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM	
    CALL g_adt.clear()
    DISPLAY '   ' TO FORMONLY.cnt            #ATTRIBUTE(GREEN)
    CALL t100_cs()                           # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t100_cs  #USING g_ads.ads01         # 從DB產生合乎條件TEMP(0-30秒)
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ads.* TO NULL           #顯示合乎條件筆數
    ELSE
        OPEN t100_count
        FETCH t100_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t100_t('F')
    END IF
END FUNCTION

FUNCTION t100_t(p_flag)
    DEFINE
        p_flag           LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

    CASE p_flag
        WHEN 'N' FETCH NEXT     t100_cs INTO g_ads_rowid,g_ads.ads01
        WHEN 'P' FETCH PREVIOUS t100_cs INTO g_ads_rowid,g_ads.ads01
        WHEN 'F' FETCH FIRST    t100_cs INTO g_ads_rowid,g_ads.ads01
        WHEN 'L' FETCH LAST     t100_cs INTO g_ads_rowid,g_ads.ads01
        WHEN '/'
         IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
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
         FETCH ABSOLUTE g_jump t100_cs INTO g_ads_rowid,g_ads.ads01
         LET mi_no_ask = FALSE   #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ads.* TO NULL   #No.TQC-6B0105
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

    SELECT * INTO g_ads.* FROM ads_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_ads_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
    ELSE
         LET g_data_owner=g_ads.adsuser           #FUN-4C0052權限控管
         LET g_data_group=g_ads.adsgrup
         CALL t100_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION t100_show()
    LET g_ads_t.* = g_ads.*
    DISPLAY BY NAME g_ads.ads01,g_ads.ads02,g_ads.ads03,g_ads.ads04,
                    g_ads.ads05,g_ads.ads06,g_ads.adsconf,
                    g_ads.adspost,g_ads.adsuser,g_ads.adsgrup,
                    g_ads.adsmodu,g_ads.adsdate,g_ads.adsacti
     CALL cl_set_field_pic(g_ads.adsconf,"",g_ads.adspost,"","",g_ads.adsacti)  #NO.MOD-4B0082
    CALL t100_ads03('d')
    CALL t100_ads04('d')
    CALL t100_ads05('d')
    CALL t100_b_fill(g_wc2)
#    CALL t100_adt03('d')
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION t100_u()
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_ads.ads01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ads.* FROM ads_file WHERE ads01=g_ads.ads01
    IF g_ads.adsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ads.ads01,'mfg1000',0) RETURN
    END IF
    IF g_ads.adsconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_ads.ads01,'9022',0) RETURN
    END IF
    IF g_ads.adspost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_ads.ads01,'afa-101',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ads01_t = g_ads.ads01
    LET g_ads_t.* = g_ads.*
    LET g_ads_o.* = g_ads.*
    BEGIN WORK
    OPEN t100_cl USING g_ads.ads01
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:",STATUS,1)
       CLOSE t100_cl ROLLBACK WORK RETURN
    END IF
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
       CLOSE t100_cl ROLLBACK WORK RETURN
    END IF
    FETCH t100_cl INTO g_ads.*               # 對DB鎖定
    LET g_ads.adsmodu=g_user                     #修改者
    LET g_ads.adsdate = g_today                  #修改日期
    CALL t100_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t100_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ads.*=g_ads_t.*
            CALL t100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ads.ads01 != g_ads01_t THEN
            UPDATE adt_file SET adt01= g_ads.ads01
                    WHERE adt01 = g_ads01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err('update adt:',SQLCA.sqlcode,0)
               CONTINUE WHILE
            END IF
        END IF
        UPDATE ads_file SET ads_file.* = g_ads.*    # 更新DB
         WHERE ROWID = g_ads_rowid             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t100_cl
    COMMIT WORK
END FUNCTION

FUNCTION t100_x()
    DEFINE
        l_chr LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF
    IF g_ads.ads01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ads.adsconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_ads.ads01,'9022',0)
        RETURN
    END IF
    IF g_ads.adspost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_ads.ads01,'afa-101',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t100_cl USING g_ads.ads01
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_ads.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t100_show()
    IF cl_exp(0,0,g_ads.adsacti) THEN
        LET g_chr=g_ads.adsacti
        IF g_ads.adsacti='Y' THEN
            LET g_ads.adsacti='N'
        ELSE
            LET g_ads.adsacti='Y'
        END IF
        UPDATE ads_file
            SET adsacti=g_ads.adsacti,
               adsmodu=g_user, adsdate=g_today
            WHERE ROWID=g_ads_rowid
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
            LET g_ads.adsacti=g_chr
        END IF
        DISPLAY BY NAME g_ads.adsacti ATTRIBUTE(RED)
    END IF
    CLOSE t100_cl
    COMMIT WORK
END FUNCTION

FUNCTION t100_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF
    IF g_ads.ads01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ads.adsconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_ads.ads01,'9022',0)
        RETURN
    END IF
    IF g_ads.adspost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_ads.ads01,'afa-101',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t100_cl USING g_ads.ads01
        IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_ads.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t100_show()
    IF cl_delh(15,16) THEN
        DELETE FROM ads_file WHERE ROWID = g_ads_rowid
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
        ELSE
           DELETE FROM adt_file WHERE adt01=g_ads.ads01
           CLEAR FORM
           CALL g_adt.clear()
           OPEN t100_count
           FETCH t100_count INTO g_row_count
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN t100_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL t100_t('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE    #No.FUN-6A0078
              CALL t100_t('/')
           END IF
        END IF
    END IF
    CLOSE t100_cl
    COMMIT WORK
END FUNCTION

#單身
FUNCTION t100_b()
DEFINE
    l_buf           LIKE adt_file.adt03,  #儲存尚在使用中之下游檔案之檔名  #No.FUN-680108 VARCHAR(80)
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT               #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用                      #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否                      #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態                        #No.FUN-680108 VARCHAR(1)
    l_bcur          LIKE type_file.chr1000, #'1':表存放位置有值,'2':則為NULL #No.FUN-680108 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否                        #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5                                      #No.FUN-680108 SMALLINT

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_ads.ads01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_ads.* FROM ads_file WHERE ads01=g_ads.ads01
    IF g_ads.adsacti MATCHES'[Nn]' THEN
       CALL cl_err(g_ads.ads01,'mfg1000',0)
       RETURN
    END IF
    IF g_ads.adsconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_ads.ads01,'9022',0)
        RETURN
    END IF
    IF g_ads.adspost ='Y' THEN    #檢查資料是否為過帳
        CALL cl_err(g_ads.ads01,'afa-101',0)
        RETURN
    END IF
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

    CALL cl_opmsg('b')
 LET g_forupd_sql="SELECT adt02,adt03,'',adt05,adt06,adt04,adt07",
                     " FROM adt_file",
                     " WHERE adt02=?",
	             " AND adt01=?",
                     " FOR UPDATE NOWAIT"
    DECLARE t100_bcl CURSOR FROM g_forupd_sql
    LET l_ac_t = 0

        INPUT ARRAY g_adt WITHOUT DEFAULTS FROM s_adt.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
              OPEN t100_cl USING g_ads.ads01
              IF STATUS THEN
                 CALL cl_err("OPEN t100_cl:", STATUS, 1)
                 CLOSE t100_cl
                 ROLLBACK WORK
                 RETURN
              END IF
              FETCH t100_cl INTO g_ads.*               # 對DB鎖定
              IF SQLCA.sqlcode THEN
                CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
                CLOSE t100_cl ROLLBACK WORK RETURN
              END IF
              IF g_rec_b >= l_ac THEN
                 LET p_cmd='u'
                 LET g_adt_t.* = g_adt[l_ac].*  #BACKUP
                 OPEN t100_bcl USING g_adt_t.adt02,g_ads.ads01              #表示更改狀態
 
               IF STATUS THEN
                  CALL cl_err("OPEN t100_bcl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t100_bcl INTO g_adt[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_adt_t.adt02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  CALL t100_adt03('d')
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adt[l_ac].* TO NULL      #900423
            LET g_adt_t.* = g_adt[l_ac].*     #新輸入資料
             #No.MOD-570124  --begin
            LET g_adt[l_ac].adt04=' '
             #No.MOD-570124  --end
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adt02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
          INSERT INTO adt_file(adt01,adt02,adt03,adt04,adt05,adt06,adt07) #No.MOD-470041
                               VALUES(g_ads.ads01,
                               g_adt[l_ac].adt02, g_adt[l_ac].adt03,
                               g_adt[l_ac].adt04, g_adt[l_ac].adt05,
                               g_adt[l_ac].adt06, g_adt[l_ac].adt07)
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_adt[l_ac].adt02,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF

        BEFORE FIELD adt02                        # dgeeault 序號
            IF g_adt[l_ac].adt02 IS NULL or g_adt[l_ac].adt02 = 0 THEN
                SELECT max(adt02)+1 INTO g_adt[l_ac].adt02 FROM adt_file
                    WHERE adt01 = g_ads.ads01
                IF g_adt[l_ac].adt02 IS NULL THEN
                    LET g_adt[l_ac].adt02 = 1
                END IF
            END IF

        AFTER FIELD adt02
            IF NOT cl_null(g_adt[l_ac].adt02) AND
               (g_adt[l_ac].adt02 != g_adt_t.adt02 OR
                g_adt_t.adt02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM adt_file
                 WHERE adt01 = g_ads.ads01
                   AND adt02 = g_adt[l_ac].adt02
                IF l_n > 0 THEN
                    CALL cl_err(g_adt[l_ac].adt02,-239,0)
                    LET g_adt[l_ac].adt02 = g_adt_t.adt02
                    NEXT FIELD adt02
                END IF
            END IF


        AFTER FIELD adt03
            CALL t100_adt03('a')
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               LET g_adt[l_ac].adt03 = g_adt_t.adt03
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_adt[l_ac].adt03
               #------MOD-5A0095 END------------
               NEXT FIELD adt03
            END IF

         #No.MOD-570124  --begin
        AFTER FIELD adt04
            IF cl_null(g_adt[l_ac].adt04) THEN
               LET g_adt[l_ac].adt04=' '
               DISPLAY BY NAME g_adt[l_ac].adt04
            END IF
         #No.MOD-570124  --end

        BEFORE DELETE                            #是否取消單身
            IF g_adt_t.adt02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM adt_file
                    WHERE adt01=g_ads.ads01 AND adt02 = g_adt_t.adt02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adt_t.adt02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_adt[l_ac].* = g_adt_t.*
               CLOSE t100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adt[l_ac].adt02,-263,1)
               LET g_adt[l_ac].* = g_adt_t.*
            ELSE
     UPDATE adt_file
SET adt02=g_adt[l_ac].adt02,adt03=g_adt[l_ac].adt03,
    adt04=g_adt[l_ac].adt04,adt05=g_adt[l_ac].adt05,
    adt06=g_adt[l_ac].adt06,adt07=g_adt[l_ac].adt07
    WHERE CURRENT OF t100_bcl
               IF SQLCA.sqlcode OR STATUS = 100 THEN
                   CALL cl_err(g_adt[l_ac].adt02,SQLCA.sqlcode,0)
                   LET g_adt[l_ac].* = g_adt_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_adt[l_ac].* = g_adt_t.*
               END IF
               CLOSE t100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t100_bcl
            COMMIT WORK

        ON ACTION CONTROLN
            CALL t100_b_askkey()
            EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(adt02) AND l_ac > 1 THEN
                LET g_adt[l_ac].* = g_adt[l_ac-1].*
                NEXT FIELD adt02
            END IF

        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adt03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ima"
                  LET g_qryparam.default1=g_adt[l_ac].adt03
                  CALL cl_create_qry() RETURNING g_adt[l_ac].adt03
                  NEXT FIELD adt03
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

    #FUN-5B0113-begin
     LET g_ads.adsmodu = g_user
     LET g_ads.adsdate = g_today
     UPDATE ads_file SET adsmodu = g_ads.adsmodu,adsdate = g_ads.adsdate
      WHERE ads01 = g_ads.ads01
     IF SQLCA.SQLCODE OR STATUS = 100 THEN
        CALL cl_err('upd ads',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_ads.adsmodu,g_ads.adsdate
    #FUN-5B0113-end

    CLOSE t100_bcl
    COMMIT WORK
    CALL t100_delall()
END FUNCTION

FUNCTION t100_delall()
    SELECT COUNT(*) INTO g_cnt FROM adt_file
        WHERE adt01 = g_ads.ads01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM ads_file WHERE ads01 = g_ads.ads01
    END IF
END FUNCTION

FUNCTION t100_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CONSTRUCT l_wc ON adt02,adt03,adtd05,adt06,adt04,  #螢幕上取單身條件
                      adt07
       FROM s_adt[1].adt02,s_adt[1].adt03,s_adt[1].adt05,
            s_adt[1].adt06,s_adt[1].adt04,s_adt[1].adt07

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ade03) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade03
                  NEXT FIELD ade03
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
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t100_b_fill(l_wc)
END FUNCTION

FUNCTION t100_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(400)

    LET g_sql =
    "SELECT adt02,adt03,ima02,adt05,adt06,adt04,adt07",
       " FROM adt_file,ima_file",
       " WHERE adt01 = '",g_ads.ads01,"' AND ",p_wc CLIPPED ,
       "   AND ima01 = adt03 ",
       " ORDER BY 1"
    PREPARE t100_prepare2 FROM g_sql      #預備一下
    DECLARE adt_cs CURSOR FOR t100_prepare2
    CALL g_adt.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH adt_cs INTO g_adt[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_adt.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION

FUNCTION t100_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adt TO s_adt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
 
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
         CALL t100_t('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION previous
         CALL t100_t('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION jump
         CALL t100_t('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION next
         CALL t100_t('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION last
         CALL t100_t('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
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

      ON ACTION related_document                #No:FUN-6A0165  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION



FUNCTION t100_copy()
DEFINE
    l_newno         LIKE ads_file.ads01,
    l_oldno         LIKE ads_file.ads01
DEFINE li_result   LIKE type_file.num5        #No.FUN-550026        #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_ads.ads01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL t100_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno FROM ads01
#No.FUN-550026 --start--
        BEFORE INPUT
            CALL cl_set_docno_format("ads01")
#No.FUN-550026 ---end---

        AFTER FIELD ads01
            IF l_newno IS NULL THEN
                NEXT FIELD ads01
            END IF
#No.FUN-550026 --start--
    CALL s_check_no("axd",l_newno,"","20","ads_file","ads01","")
         RETURNING li_result,l_newno
    DISPLAY l_newno TO ads01
       IF (NOT li_result) THEN
          NEXT FIELD ads01
       END IF

{
            LET g_t1 = l_newno[1,3]
            SELECT * INTO g_adz.* FROM adz_file WHERE adzslip = g_t1
               AND adztype = '20'
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_newno,'mfg0014',0)
               NEXT FIELD ads01
            END IF

            IF cl_null(l_newno[5,10]) AND g_adz.adzauno='N'
               THEN NEXT FIELD ads01
            END IF
            IF g_adz.adzauno='Y' THEN   #need modify to add ads_file in it
               CALL s_axdauno(l_newno,g_ads.ads02) RETURNING g_i,l_newno
               IF g_i THEN #有問題
                  NEXT FIELD ads01
               END IF
               DISPLAY l_newno TO ads01
            END IF

            SELECT count(*) INTO g_cnt FROM ads_file
                WHERE ads01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD ads01
            END IF
}
#No.FUN-550026 ---end--

        ON ACTION CONTROLP
           CASE WHEN INFIELD(ads01)
#                    LET g_t1=l_newno[1,3]
                    LET g_t1 = s_get_doc_no(l_newno)       #No.FUN-550026
                   #CALL q_adz(FALSE,FALSE,g_t1,'20','axd') RETURNING g_t1 #TQC-670008 remark
                    CALL q_adz(FALSE,FALSE,g_t1,'20','AXD') RETURNING g_t1 #TQC-670008
#                    LET l_newno[1,3]=g_t1
                    LET l_newno = g_t1       #No.FUN-550026
                    DISPLAY l_newno TO ads01
                    NEXT FIELD ads01
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM ads_file
        WHERE ads01=g_ads.ads01
        INTO TEMP y
    UPDATE y
        SET y.ads01=l_newno,    #資料鍵值
            y.adsuser = g_user,
            y.adsgrup = g_grup,
            y.adsdate = g_today,
            y.adsacti = 'Y',
            y.adsconf = 'N',
            y.adspost = 'N'
    INSERT INTO ads_file  #複製單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL  cl_err(l_newno,SQLCA.sqlcode,0)
    END IF
    DROP TABLE x
    SELECT * FROM adt_file
       WHERE adt01 = g_ads.ads01
       INTO TEMP x
    UPDATE x
       SET adt01 = l_newno
    INSERT INTO adt_file    #複製單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_newno,SQLCA.sqlcode,0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno = g_ads.ads01
        SELECT ROWID,ads_file.* INTO g_ads_rowid,g_ads.* FROM ads_file
               WHERE ads01 =  l_newno
        CALL t100_u()
        CALL t100_show()
        LET g_ads.ads01 = l_oldno
        SELECT ROWID,ads_file.* INTO g_ads_rowid,g_ads.* FROM ads_file
               WHERE ads01 = g_ads.ads01
        CALL t100_show()
    END IF
    DISPLAY BY NAME g_ads.ads01
END FUNCTION

FUNCTION t100_y() #確認
    IF g_ads.ads01 IS NULL THEN RETURN END IF
    SELECT * INTO g_ads.* FROM ads_file WHERE ads01=g_ads.ads01
    IF g_ads.adsacti='N' THEN
       CALL cl_err(g_ads.ads01,'mfg1000',0)
       RETURN
    END IF
    IF g_ads.adsconf='Y' THEN RETURN END IF
    IF g_ads.adspost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK
    OPEN t100_cl USING g_ads.ads01
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_ads.*  # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
            CLOSE t100_cl
            ROLLBACK WORK
            RETURN
        END IF

    UPDATE ads_file SET adsconf='Y'
        WHERE ads01 = g_ads.ads01
    IF STATUS THEN
        CALL cl_err('upd adsconf',STATUS,0)
        LET g_success='N'
    END IF
    IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_cmmsg(1)
    ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(1)
    END IF
    SELECT adsconf INTO g_ads.adsconf FROM ads_file
        WHERE ads01 = g_ads.ads01
    DISPLAY BY NAME g_ads.adsconf
END FUNCTION

FUNCTION t100_w() #取消確認
    IF g_ads.ads01 IS NULL THEN RETURN END IF
    SELECT * INTO g_ads.* FROM ads_file WHERE ads01=g_ads.ads01
    IF g_ads.adsconf='N' THEN RETURN END IF
    IF g_ads.adspost='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK
    OPEN t100_cl USING g_ads.ads01
    IF STATUS THEN
       CALL cl_err("OPEN t202_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_ads.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)
            CLOSE t100_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE ads_file SET adsconf='N'
            WHERE ads01 = g_ads.ads01
        IF STATUS THEN
            CALL cl_err('upd cofconf',STATUS,0)
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT adsconf INTO g_ads.adsconf FROM ads_file
            WHERE ads01 = g_ads.ads01
        DISPLAY BY NAME g_ads.adsconf
END FUNCTION

FUNCTION t100_s()
DEFINE l_cnt  LIKE type_file.num10   #No.FUN-680108 INTEGER
   IF s_shut(0) THEN RETURN END IF
   IF g_ads.ads01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_ads.* FROM ads_file WHERE ads01=g_ads.ads01

   IF g_ads.adsacti='N' THEN
      CALL cl_err(g_ads.ads01,'mfg1000',0)
      RETURN
   END IF
   IF g_ads.adspost = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_ads.adsconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF

   SELECT COUNT(*) INTO l_cnt FROM adt_file WHERE adt01=g_ads.ads01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   IF NOT cl_confirm('mfg0176') THEN RETURN END IF

   BEGIN WORK LET g_success = 'Y'

   OPEN t100_cl USING g_ads.ads01
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF    FETCH t100_cl INTO g_ads.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t100_cl ROLLBACK WORK RETURN
   END IF

   CALL t100_s1()
   IF SQLCA.SQLCODE THEN LET g_success='N' END IF

   IF g_success = 'Y' THEN
      UPDATE ads_file SET adspost='Y' WHERE ads01=g_ads.ads01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd adspost: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK RETURN
      END IF
      LET g_ads.adspost='Y'
      DISPLAY BY NAME g_ads.adspost ATTRIBUTE(REVERSE)
      COMMIT WORK
   ELSE
      LET g_ads.adspost='N'
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION

FUNCTION t100_s1()
  DEFINE b_adt RECORD LIKE adt_file.*
  DEFINE p_adt RECORD
               adt03  LIKE adt_file.adt03,   #商品編號
               adt04  LIKE adt_file.adt04,   #批號
               adt05  LIKE adt_file.adt05,   #單位
               adt06  LIKE adt_file.adt06    #數量
               END RECORD

  #對于adt中的每一筆都要insert到adq_file中
  DECLARE t100_s1_c1 CURSOR FOR
  SELECT * FROM adt_file WHERE adt01=g_ads.ads01
  FOREACH t100_s1_c1 INTO b_adt.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_adt.adt03) THEN CONTINUE FOREACH END IF
      CALL t100_update1(b_adt.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
  #之所以做group by是為了防止在adt_file中出現相同料號，相同批次的數據，且
  #其總數量和adp_file.adp05的和為大于零的值，但是由于先后順序中間會使adp05
  #的值小于零，而造成不能過帳的情況
  DECLARE t100_s1_c2 CURSOR FOR
   SELECT adt03,adt04,adt05,SUM(adt06) FROM adt_file
    WHERE adt01=g_ads.ads01
    GROUP BY adt03,adt04,adt05
  FOREACH t100_s1_c2 INTO p_adt.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(p_adt.adt03) THEN CONTINUE FOREACH END IF
      CALL t100_update2(p_adt.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION

FUNCTION t100_update1(p_adt)
  DEFINE p_adt  RECORD LIKE adt_file.*,
         l_buf  LIKE adt_file.adt03         #No.FUN-680108 VARCHAR(60)

    INSERT INTO adq_file(adq01,adq02,adq03,adq04,adq05,adq06,
                         adq07,adq08,adq09,adq10) #No.MOD-470041
                  VALUES(g_ads.ads03,p_adt.adt03,p_adt.adt04,
                         g_ads.ads02,g_ads.ads01,p_adt.adt05,
                         p_adt.adt06,1,p_adt.adt06,'3')
    IF SQLCA.sqlcode THEN
      #IF SQLCA.sqlcode = -239  THEN             #TQC-790087 mark
       IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
          LET l_buf = p_adt.adt03 CLIPPED,' ',p_adt.adt04 CLIPPED
          CALL cl_err(l_buf,'axd-031',1)
          LET g_success='N' RETURN
       ELSE
          LET l_buf = p_adt.adt03 CLIPPED,' ',p_adt.adt04 CLIPPED
          CALL cl_err(l_buf,SQLCA.sqlcode,1)
          LET g_success='N' RETURN
       END IF
    END IF
    MESSAGE p_adt.adt03,' ',p_adt.adt04,' post ok!'
    SLEEP 0.5
END FUNCTION

FUNCTION t100_update2(p_adt)
  DEFINE p_adt   RECORD
                 adt03  LIKE adt_file.adt03,   #商品編號
                 adt04  LIKE adt_file.adt04,   #批號
                 adt05  LIKE adt_file.adt05,   #單位
                 adt06  LIKE adt_file.adt06    #數量
                 END RECORD,
         l_buf   LIKE adt_file.adt03,        #No.FUN-680108 VARCHAR(60)
         l_ima71 LIKE ima_file.ima71,
         l_adp05 LIKE adp_file.adp05,
         l_cnt   LIKE type_file.num5          #No.FUN-680108 SMALLINT

    SELECT COUNT(*),SUM(adp05) INTO l_cnt,l_adp05 FROM adp_file
     WHERE adp01 = g_ads.ads03
       AND adp02 = p_adt.adt03 AND adp03 = p_adt.adt04
    IF l_cnt > 0 THEN   #已存在該客戶資料
       IF l_adp05 + p_adt.adt06 < 0 THEN    #累計這次的數量小于零
          LET l_buf = p_adt.adt03 CLIPPED,' ',p_adt.adt04 CLIPPED
          CALL cl_err(l_buf,'axd-008',1)
          LET g_success='N' RETURN
       END IF

       UPDATE adp_file SET adp05 = adp05 + p_adt.adt06
        WHERE adp01 = g_ads.ads03 AND adp02 = p_adt.adt03
          AND adp03 = p_adt.adt04
       IF STATUS THEN
          CALL cl_err('update adp',STATUS,1)
          LET g_success='N' RETURN
       END IF
    ELSE
       SELECT ima71 INTO l_ima71 FROM ima_file
        WHERE ima01 = p_adt.adt03
        INSERT INTO adp_file(adp01,adp02,adp03,adp04,adp05,adp06,adp07) #No.MOD-470041
       VALUES(g_ads.ads03,p_adt.adt03,p_adt.adt04,p_adt.adt05,
              p_adt.adt06,l_ima71+g_ads.ads02,g_ads.ads02)
       IF STATUS THEN
          CALL cl_err('insert adp',STATUS,1)
          LET g_success='N' RETURN
       END IF
    END IF

    MESSAGE p_adt.adt03,' ',p_adt.adt04,' post ok!'
    SLEEP 0.5
END FUNCTION

FUNCTION t100_z()
DEFINE l_cnt  LIKE type_file.num10   #No.FUN-680108 INTEGER
   IF s_shut(0) THEN RETURN END IF
   IF g_ads.ads01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_ads.* FROM ads_file WHERE ads01=g_ads.ads01

   IF g_ads.adspost = 'N' THEN CALL cl_err('','mfg0178',0) RETURN END IF
   IF g_ads.adsconf = 'N' THEN CALL cl_err('','mfg3550',0) RETURN END IF

   IF NOT cl_confirm('asf-663') THEN RETURN END IF

   BEGIN WORK LET g_success = 'Y'

    OPEN t100_cl USING g_ads.ads01  #No.MOD-570124
   FETCH t100_cl INTO g_ads.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ads.ads01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t100_cl ROLLBACK WORK RETURN
   END IF

   CALL t100_z1()
   IF SQLCA.SQLCODE THEN LET g_success='N' END IF

   IF g_success = 'Y' THEN
      UPDATE ads_file SET adspost='N' WHERE ads01=g_ads.ads01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd adspost: ',SQLCA.SQLCODE,1)
         ROLLBACK WORK RETURN
      END IF
      LET g_ads.adspost='N'
      DISPLAY BY NAME g_ads.adspost ATTRIBUTE(REVERSE)
      COMMIT WORK
   ELSE
      LET g_ads.adspost='Y'
      ROLLBACK WORK
   END IF
   MESSAGE ''
END FUNCTION

FUNCTION t100_z1()
  DEFINE b_adt RECORD LIKE adt_file.*
  DEFINE p_adt RECORD
               adt03  LIKE adt_file.adt03,   #商品編號
               adt04  LIKE adt_file.adt04,   #批號
               adt05  LIKE adt_file.adt05,   #單位
               adt06  LIKE adt_file.adt06    #數量
               END RECORD

  #對于adt中的每一筆都要insert到adq_file中
  DECLARE t100_z1_c1 CURSOR FOR SELECT * FROM adt_file WHERE adt01=g_ads.ads01
  FOREACH t100_z1_c1 INTO b_adt.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_adt.adt03) THEN CONTINUE FOREACH END IF
      CALL t100_update3(b_adt.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
  #之所以做group by是為了防止在adt_file中出現相同料號，相同批次的數據，且
  #其總數量和adp_file.adp05的和為大于零的值，但是由于先后順序中間會使adp05
  #的值小于零，而造成不能過帳的情況
  DECLARE t100_z1_c2 CURSOR FOR
   SELECT adt03,adt04,adt05,SUM(adt06) FROM adt_file
    WHERE adt01=g_ads.ads01
    GROUP BY adt03,adt04,adt05
  FOREACH t100_z1_c2 INTO p_adt.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(p_adt.adt03) THEN CONTINUE FOREACH END IF
      CALL t100_update4(p_adt.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION

FUNCTION t100_update3(p_adt)
  DEFINE p_adt  RECORD LIKE adt_file.*,
         l_buf  LIKE adt_file.adt03       #No.FUN-680108 VARCHAR(60)

    DELETE FROM adq_file WHERE adq01 = g_ads.ads03
       AND adq02 = p_adt.adt03 AND adq03 = p_adt.adt04
       AND adq04 = g_ads.ads02
    IF STATUS THEN
       LET l_buf = p_adt.adt03 CLIPPED,' ',p_adt.adt04 CLIPPED
       CALL cl_err(l_buf,STATUS,1)
       LET g_success='N' RETURN
    END IF
    MESSAGE p_adt.adt03,' ',p_adt.adt04,' undo post ok!'
    SLEEP 0.5
END FUNCTION

FUNCTION t100_update4(p_adt)
  DEFINE p_adt   RECORD
                 adt03  LIKE adt_file.adt03,   #商品編號
                 adt04  LIKE adt_file.adt04,   #批號
                 adt05  LIKE adt_file.adt05,   #單位
                 adt06  LIKE adt_file.adt06    #數量
                 END RECORD,
         l_buf   LIKE adt_file.adt03,        #No.FUN-680108 VARCHAR(60)
         l_adp05 LIKE adp_file.adp05,
         l_cnt   LIKE type_file.num5          #No.FUN-680108 SMALLINT

    SELECT SUM(adp05) INTO l_adp05 FROM adp_file
     WHERE adp01 = g_ads.ads03
       AND adp02 = p_adt.adt03 AND adp03 = p_adt.adt04
    IF l_adp05 - p_adt.adt06 < 0 THEN    #累計這次的數量小于零
       LET l_buf = p_adt.adt03 CLIPPED,' ',p_adt.adt04 CLIPPED
       CALL cl_err(l_buf,'axd-008',1)
       LET g_success='N' RETURN
    END IF

    UPDATE adp_file SET adp05 = adp05 - p_adt.adt06
     WHERE adp01 = g_ads.ads03 AND adp02 = p_adt.adt03
       AND adp03 = p_adt.adt04
    IF STATUS THEN
       CALL cl_err('update adp',STATUS,1)
       LET g_success='N' RETURN
    END IF

    MESSAGE p_adt.adt03,' ',p_adt.adt04,'undo post ok!'
    SLEEP 0.5
END FUNCTION

{
FUNCTION t100_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    sr              RECORD
        ads01       LIKE ads_file.ads01,   #倉庫別
        adsacti     LIKE ads_file.adsacti,
        adt02       LIKE adt_file.adt02,   #存放位置
        adt04       LIKE adt_file.adt04,   #類別
        adt05       LIKE adt_file.adt05,   #可用否
        adt06       LIKE adt_file.adt06,   #MRP可用否
        adt07       LIKE adt_file.adt07,   #保稅
        adt08       LIKE adt_file.adt08,   #使用方式
        adt09       LIKE adt_file.adt09,   #會計科目
        adt10       LIKE adt_file.adt10,   #發料順序
        adt11       LIKE adt_file.adt11    #領料順序
                    END RECORD,
    l_name          LIKE type_file.chr20,          #No.FUN-680108 VARCHAR(20)             #External(Disk) file name
    l_za05          LIKE za_file.za05  #No.FUN-680108 VARCHAR(40)              #

    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
    LET l_name = 'axdt100.out'
    CALL cl_outnam('axdt100') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'axdt100'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT ads01,adsacti,adt02,adt04,adt05,",
              " adt06,adt07,adt08,adt09,adt10,adt11 ",
              " FROM ads_file,adt_file",  # 組合出 SQL 指令
              " WHERE ads01=adt01 AND ",g_wc CLIPPED
    PREPARE t100_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t100_co                         # CURSOR
        CURSOR FOR t100_p1

    START REPORT t100_rep TO l_name

    FOREACH t100_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t100_rep(sr.*)
    END FOREACH

    FINISH REPORT t100_rep

    CLOSE t100_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT t100_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
    sr              RECORD 
        ads01       LIKE ads_file.ads01,   #倉庫別
        adsacti     LIKE ads_file.adsacti,
        adt02       LIKE adt_file.adt02,   #存放位置
        adt04       LIKE adt_file.adt04,   #類別
        adt05       LIKE adt_file.adt05,   #可用否
        adt06       LIKE adt_file.adt06,   #MRP可用否
        adt07       LIKE adt_file.adt07,   #保稅
        adt08       LIKE adt_file.adt08,   #使用方式
        adt09       LIKE adt_file.adt09,   #會計科目
        adt10       LIKE adt_file.adt10,   #發料順序
        adt11       LIKE adt_file.adt11    #領料順序
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.ads01,sr.adt02

    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT COLUMN 5,g_x[11] CLIPPED,COLUMN 44,g_x[12] CLIPPED
            PRINT COLUMN 5,g_x[13] CLIPPED,COLUMN 44,g_x[14] CLIPPED
            PRINT "    ---------- ----------  -   -   -",
                  "   -   -  ------------------------ ---- ----"
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.ads01  #倉庫別
            IF sr.adsacti = 'N' THEN PRINT '*'; END IF
            PRINT COLUMN 5,sr.ads01,' ';
        ON EVERY ROW
            PRINT COLUMN 16,sr.adt02,
                  COLUMN 28,sr.adt04,
                  COLUMN 32,sr.adt05,
                  COLUMN 36,sr.adt06,
                  COLUMN 40,sr.adt07,
                  COLUMN 44,sr.adt08,
                  COLUMN 47,sr.adt09,
                  COLUMN 72,sr.adt10 USING "###&",
                  COLUMN 77,sr.adt11 USING "###&"
        AFTER GROUP OF sr.ads01
            PRINT
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
FUNCTION t100_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ads01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t100_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ads01",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO:MOD-5A0095 <001,002> #
#Patch....NO:TQC-610037 <001> #
