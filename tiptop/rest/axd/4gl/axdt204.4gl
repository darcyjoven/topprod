# Prog. Version..: '5.10.00-08.01.04(00007)'     #
#
# Pattern name...: axdt204.4gl
# Descriptions...: 派車單維護作業
# Date & Author..: 03/12/02 By Carrier
# Modify.........: 04/07/19 By Wiky Bugno:MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4B0082 04/11/10 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY  將變數用Like方式定義
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No:MOD-530870 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: NO.FUN-550026 05/05/20 By jackie 單據編號加大
# Modify.........: No:MOD-560158 05/06/21 By Echo 無與EasyFlow整合，因此刪除link檔裡的整合程式
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_adk    RECORD LIKE adk_file.*,       #派車單單頭檔
    g_adk_t  RECORD LIKE adk_file.*,       #派車單單頭檔(舊值)
    g_adk_o  RECORD LIKE adk_file.*,       #派車單單頭檔(舊值)
    g_adk01_t       LIKE adk_file.adk01,   #派車單單號(舊值)
    g_adk08_t       LIKE adk_file.adk08,   #派車單單號(舊值)
    g_adk_rowid     LIKE type_file.chr18,  #No.FUN-680108 INT
 g_adl           DYNAMIC ARRAY of RECORD#派車單單身檔
        adl02       LIKE adl_file.adl02,   #項次
        adl03       LIKE adl_file.adl03,   #撥出單號
        adl04       LIKE adl_file.adl04,   #撥出單項次
        adg09       LIKE adg_file.adg09,   #
        adg10       LIKE adg_file.adg10,   #
        adl05       LIKE adl_file.adl05,   #撥出數量
        adg11       LIKE adg_file.adg11,   #
        adl06       LIKE adl_file.adl06,   #撥出件數
        adl07       LIKE adl_file.adl07,   #預計扺達日期
        adl08       LIKE adl_file.adl08,   #預計扺達時間
        adl09       LIKE adl_file.adl09,   #實際扺達日期
        adl10       LIKE adl_file.adl10    #實際扺達時間
                    END RECORD,
 g_adl_t         RECORD                 #派車單單身檔 (舊值)
        adl02       LIKE adl_file.adl02,   #項次
        adl03       LIKE adl_file.adl03,   #撥出單號
        adl04       LIKE adl_file.adl04,   #撥出單項次
        adg09       LIKE adg_file.adg09,   #
        adg10       LIKE adg_file.adg10,   #
        adl05       LIKE adl_file.adl05,   #撥出數量
        adg11       LIKE adg_file.adg11,   #
        adl06       LIKE adl_file.adl06,   #撥出件數
        adl07       LIKE adl_file.adl07,   #預計扺達日期
        adl08       LIKE adl_file.adl08,   #預計扺達時間
        adl09       LIKE adl_file.adl09,   #實際扺達日期
        adl10       LIKE adl_file.adl10    #實際扺達時間
                    END RECORD,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(200)
    g_t1            LIKE oay_file.oayslip,  #No.FUN-680108 VARCHAR(05)
    g_wc,g_sql,g_wc2    string,             #No:FUN-580092 HCN
    g_adf       RECORD LIKE adf_file.*,
    g_adg       RECORD LIKE adg_file.*,
    g_rec_b           LIKE type_file.num5,  #單身筆數   #No.FUN-680108 SMALLINT
    g_flag            LIKE type_file.chr1,  #No.FUN-680108 VARCHAR(1)
    l_ac              LIKE type_file.num5   #目前處理的ARRAY CNT    #No.FUN-680108 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5   #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680108 SMALLINT

DEFINE   g_forupd_sql STRING                #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt        LIKE type_file.num10  #No.FUN-680108 INTEGER
DEFINE   g_chr        LIKE adk_file.adkacti #No.FUN-680108 VARCHAR(01)
DEFINE   g_i          LIKE type_file.num5   #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg        LIKE type_file.chr1000#No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10  #No.FUN-680108 INTEGER
DEFINE   g_curs_index LIKE type_file.num10  #No.FUN-680108 INTEGER
DEFINE   g_jump       LIKE type_file.num10  #No.FUN-680108 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5   #No.FUN-680108 SMALLINT
#主程式開
MAIN
DEFINE
    l_tadl  LIKE type_file.chr8     #No.FUN-680108 VARCHAR(8)               #計算被使用時間

    OPTIONS                         #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF

      CALL cl_used(g_prog,l_tadl,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818
        RETURNING l_tadl

    LET g_adk01_t = NULL                   #清除鍵值

    INITIALIZE g_adk_t.* TO NULL
    INITIALIZE g_adk.* TO NULL

    LET p_row = 4 LET p_col = 3

    OPEN WINDOW t204_w AT p_row,p_col WITH FORM "axd/42f/axdt204"
         ATTRIBUTE(STYLE = g_win_style)

    CALL cl_ui_init()

--##
    CALL g_x.clear()
--##

    LET g_forupd_sql="SELECT * FROM adk_file WHERE adk01 = ? FOR UPDATE NOWAIT"

    DECLARE t204_cl CURSOR FROM g_forupd_sql
    CALL t204_menu()    #中文

    CLOSE WINDOW t204_w                 #結束畫面
      CALL cl_used(g_prog,l_tadl,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818
        RETURNING l_tadl
END MAIN

#QBE 查詢資料
FUNCTION t204_cs()
     DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No:FUN-580031

     CLEAR FORM                             #清除畫面
     CALL g_adl.clear()
     CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

  CONSTRUCT BY NAME g_wc ON
                  adk01,adk02,adk03,adk04,adk05,adk06,adk07,#螢幕上取單頭條件
                  adk16,adk13,adk14,adk15,adk08,
                  adk09,adk10,adk11,adk12,adk17,adkconf,adkmksg,
                  adkuser,adkgrup,adkmodu,adkdate,adkacti

        BEFORE CONSTRUCT
            CALL cl_qbe_init()

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adk01)        #need modify
#                    LET g_t1=g_adk.adk01[1,3]
                    LET g_t1 = s_get_doc_no(g_adk.adk01)       #No.FUN-550026
                    #CALL q_adz(FALSE,TRUE,g_t1,19,'axd') RETURNING g_t1 #TQC-670008
                    CALL q_adz(FALSE,TRUE,g_t1,19,'AXD') RETURNING g_t1  #TQC-670008
                    LET g_qryparam.multiret=g_t1
                    DISPLAY g_qryparam.multiret TO adk01
                    NEXT FIELD adk01
                WHEN INFIELD(adk03)
                    #CALL q_adj(0,0,g_adk.adk03) RETURNING g_adk.adk03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adj"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk03
                    NEXT FIELD adk03
                WHEN INFIELD(adk13)
                    #CALL q_gen(0,0,g_adk.adk13) RETURNING g_adk.adk13
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk13
                    NEXT FIELD adk13
                WHEN INFIELD(adk14)
                    #CALL q_gem(0,0,g_adk.adk14) RETURNING g_adk.adk14
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk14
                    NEXT FIELD adk14
                WHEN INFIELD(adk15)
                    #CALL q_obn(0,0,g_adk.adk15) RETURNING g_adk.adk15
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_obn"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk15
                    NEXT FIELD adk15
                WHEN INFIELD(adk08)
                    #CALL q_obw(0,0,g_adk.adk08,g_adk.adk04,g_adk.adk05,g_adk.adk06,g_adk.adk07)
                    #     RETURNING g_adk.adk08
                    CALL q_obw(FALSE,TRUE,g_adk.adk08,g_adk.adk04,g_adk.adk05,g_adk.adk06,g_adk.adk07) RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk08
                    NEXT FIELD adk08
                WHEN INFIELD(adk09)
                    #CALL q_gen(0,0,g_adk.adk09) RETURNING g_adk.adk09
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk09
                    NEXT FIELD adk09
                WHEN INFIELD(adk10)
                    #CALL q_gen(0,0,g_adk.adk10) RETURNING g_adk.adk10
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk10
                    NEXT FIELD adk10
                WHEN INFIELD(adk11)
                    #CALL q_gen(0,0,g_adk.adk11) RETURNING g_adk.adk11
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk11
                    NEXT FIELD adk11
                WHEN INFIELD(adk12)
                    #CALL q_gen(0,0,g_adk.adk12) RETURNING g_adk.adk12
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO adk12
                    NEXT FIELD adk12
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

      #No:FUN-580031 --start--
      ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---
 
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
     CONSTRUCT g_wc2 ON adl02,adl03,adld04,adl05,adl06,  #螢幕上取單身條件
                        adl07,adl08,adl09,adl10
        FROM s_adl[1].adl02,s_adl[1].adl03,s_adl[1].adl04,s_adl[1].adl05,
             s_adl[1].adl06,s_adl[1].adl07,s_adl[1].adl08,s_adl[1].adl09,
             s_adl[1].adl10

        #No:FUN-580031 --start--
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        #No:FUN-580031 ---end---

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adl03)
                #CALL q_adg(5,3,g_adl[l_ac].adl03,g_adl[l_ac].adl04,'')
                #     RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                CALL q_adg(TRUE,FALSE,g_adl[l_ac].adl03,g_adl[l_ac].adl04,'')
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_adl[1].adl03
                NEXT FIELD adl03
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
       LET g_wc = g_wc clipped," AND adkuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND adkgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      LET g_wc = g_wc clipped," AND adkgrup IN ",cl_chk_tgrup_list()
    END IF

    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ROWID, adk01 FROM adk_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY adk01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE adk_file.ROWID, adk01 ",
                  "  FROM adk_file, adl_file ",
                  " WHERE adk01 = adl01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY adk01"
    END IF
    PREPARE t204_prepare FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) EXIT PROGRAM END IF
    DECLARE t204_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t204_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM adk_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct adk01)",
                  " FROM adk_file,adl_file WHERE ",
                  " adk01=adl01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF
    PREPARE t204_precount FROM g_sql
    DECLARE t204_count CURSOR FOR t204_precount
 
END FUNCTION

#中文的MENU
FUNCTION t204_menu()

   WHILE TRUE
      CALL t204_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL t204_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t204_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL t204_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t204_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL t204_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t204_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         #@WHEN "其他托運物品"
         WHEN "btn01"
            IF NOT cl_null(g_adk.adk01) THEN
               LET g_cmd = "axdi122 '",g_adk.adk01,"'"
               CALL cl_cmdrun(g_cmd CLIPPED)
            END IF
         #WHEN "簽核狀態"                   #MOD-560158
        ##@WHEN "btn02"
        #   IF cl_chk_act_auth() THEN
        #      CALL t204_w()
        #   END IF
         WHEN "confirm"
             IF cl_chk_act_auth() THEN #NO.MOD-4B0082  --begin
               CALL t204_y()
                CALL cl_set_field_pic(g_adk.adkconf,"","","","",g_adk.adkacti)  #NO.MOD-4B0082
             END IF #NO.MOD-4B0082  --begin
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t204_z()
                CALL cl_set_field_pic(g_adk.adkconf,"","","","",g_adk.adkacti)  #NO.MOD-4B0082
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t204_x()
                CALL cl_set_field_pic(g_adk.adkconf,"","","","",g_adk.adkacti)  #NO.MOD-4B0082
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t204_out('o')
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No:FUN-6A0165-------adk--------str----
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_adk.adk01 IS NOT NULL THEN
                LET g_doc.column1 = "adk01"
                LET g_doc.value1 = g_adk.adk01
                CALL cl_doc()
              END IF
        END IF
        #No:FUN-6A0165-------adk--------end----
      END CASE
   END WHILE
END FUNCTION

FUNCTION t204_a()
DEFINE l_time LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(10)
DEFINE li_result   LIKE type_file.num5     #No.FUN-550026        #No.FUN-680108 SMALLINT
    MESSAGE ""
    CLEAR FORM                             # 清螢墓欄位內容
    CALL g_adl.clear()

    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無新增之功能
    INITIALIZE g_adk.* LIKE adk_file.*
    LET g_adk01_t = NULL
    LET g_adk08_t = NULL
    LET g_adk_t.*=g_adk.*
    LET g_adk.adk04 = g_today
    LET l_time=TIME
    LET g_adk.adk05 = l_time[1,2],l_time[4,5]
    LET g_adk.adk02 = g_today                    #DEFAULT
    LET g_adk.adk13 = g_user                     #DEFAULT
    LET g_adk.adk14 = g_grup                     #DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_adk.adkacti ='Y'                   #有效的資料
        LET g_adk.adkconf ='N'                   #有效的資料
        LET g_adk.adkuser = g_user
        LET g_adk.adkgrup = g_grup               #使用者所屬群
        LET g_adk.adkdate = g_today
        LET g_adk.adk17 = '0'
        CALL t204_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_adk.* TO NULL
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF g_adk.adk01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
#No.FUN-550026 --start--
        CALL s_auto_assign_no("axd",g_adk.adk01,g_adk.adk02,"19","adk_file","adk01","","","")
             RETURNING li_result,g_adk.adk01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_adk.adk01
{
        IF g_adz.adzauno='Y' THEN   #need modify to add adk_file in it
           CALL s_axdauno(g_adk.adk01,g_adk.adk02) RETURNING g_i,g_adk.adk01
           IF g_i THEN #有問題
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
           END IF
           DISPLAY BY NAME g_adk.adk01
        END IF
}
#No.FUN-550026 ---end--
        INSERT INTO adk_file VALUES(g_adk.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        COMMIT WORK
        SELECT ROWID INTO g_adk_rowid FROM adk_file
         WHERE adk01 = g_adk.adk01
        LET g_adk01_t = g_adk.adk01        #保留舊值
        LET g_adk08_t = g_adk.adk08        #保留舊值
        LET g_adk_t.* = g_adk.*

        CALL g_adl.clear()
        LET g_rec_b=0
        CALL t204_b()                   #輸入單身

        EXIT WHILE
    END WHILE
    SELECT * FROM adk_file WHERE adk01 = g_adk.adk01
    IF SQLCA.sqlcode = 0 THEN
       IF g_adz.adzconf = 'Y' THEN CALL t204_y() END IF
       IF g_adz.adzprnt = 'Y' THEN CALL t204_prt() END IF
    END IF
END FUNCTION

FUNCTION t204_i(p_cmd)
    DEFINE
        l_sw            LIKE type_file.chr1,  #檢查必要欄位是否空白   #No.FUN-680108 VARCHAR(1)
        p_cmd           LIKE type_file.chr1,  #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5,  #No.FUN-680108 SMALLINT
        l_obw           RECORD LIKE obw_file.*
    DEFINE li_result    LIKE type_file.num5   #No.FUN-680108 SMALLINT

    CALL t204_adk17()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT BY NAME g_adk.adk01,g_adk.adk02,g_adk.adk03,g_adk.adk04,
                  g_adk.adk05,g_adk.adk06,g_adk.adk07,g_adk.adk16,
                  g_adk.adk13,g_adk.adk14,g_adk.adk15,g_adk.adk17,
                  g_adk.adk08,g_adk.adk09,g_adk.adk10,g_adk.adk11,
                  g_adk.adk12,g_adk.adkmksg,g_adk.adksign,
                  g_adk.adkconf,g_adk.adkuser,g_adk.adkgrup,
                  g_adk.adkmodu,g_adk.adkdate,g_adk.adkacti
                  WITHOUT DEFAULTS HELP 1

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t204_set_entry(p_cmd)
            CALL t204_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550026 --start--
         CALL cl_set_docno_format("adk01")
#No.FUN-550026 ---end---


        AFTER FIELD adk01
#No.FUN-550026 --start--
            IF g_adk.adk01 IS NOT NULL AND (g_adk.adk01!=g_adk01_t) THEN
    CALL s_check_no("axd",g_adk.adk01,g_adk01_t,"19","adk_file","adk01","")
         RETURNING li_result,g_adk.adk01
    DISPLAY BY NAME g_adk.adk01
       IF (NOT li_result) THEN
          NEXT FIELD adk01
       END IF
{
               LET g_t1=g_adk.adk01[1,3]
               SELECT * INTO g_adz.* FROM adz_file WHERE adzslip = g_t1
                  AND adztype = '19'
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adk.adk01,'mfg0014',0)
                  NEXT FIELD adk01
               END IF
               IF p_cmd = 'a' AND cl_null(g_adk.adk01[5,10]) AND g_adz.adzauno='N'
                  THEN NEXT FIELD adk01
               END IF
               IF g_adk.adk01 != g_adk_t.adk01 OR g_adk_t.adk01 IS NULL THEN
                   IF g_adz.adzauno = 'Y'
                     AND NOT cl_chk_data_continue(g_adk.adk01[5,10]) THEN
                      CALL cl_err('','9056',0) NEXT FIELD adk01
                   END IF
                   SELECT count(*) INTO g_cnt FROM adk_file
                       WHERE adk01 = g_adk.adk01
                   IF g_cnt > 0 THEN   #資料重復
                       CALL cl_err(g_adk.adk01,-239,0)
                       LET g_adk.adk01 = g_adk_t.adk01
                       DISPLAY BY NAME g_adk.adk01
                       NEXT FIELD adk01
                   END IF
               END IF
}
#No.FUN-550026 ---end--
               IF p_cmd = "a" THEN
                  LET g_adk.adkmksg=g_adz.adzapr
                  LET g_adk.adksign=g_adz.adzsign
                  DISPLAY BY NAME g_adk.adkmksg
                  DISPLAY BY NAME g_adk.adksign
               END IF
            END IF

     AFTER FIELD adk03
            IF NOT cl_null(g_adk.adk03) THEN
               SELECT COUNT(*) INTO l_n FROM adj_file
                WHERE adj01 = g_adk.adk03
               IF l_n = 0 THEN
                  CALL cl_err(g_adk.adk03,100,0)
                  NEXT FIELD adk03
               END IF
            END IF

        AFTER FIELD adk05
            IF NOT cl_null(g_adk.adk05) THEN
               IF g_adk.adk05 NOT MATCHES '[0-2][0-9][0-5][0-9]' THEN
                  CALL cl_err(g_adk.adk05,'axd-006',0)
                  NEXT FIELD adk05
               END IF
               IF g_adk.adk05 >= '2400' THEN
                  CALL cl_err(g_adk.adk05,'axd-006',0)
                  NEXT FIELD adk05
               END IF
            END IF

        AFTER FIELD adk06
            IF g_adk.adk06 < g_adk.adk04 THEN
               CALL cl_err(g_adk.adk06,'axd-001',0)
               NEXT FIELD adk06
            END IF

        AFTER FIELD adk07
            IF g_adk.adk07 NOT MATCHES '[0-2][0-9][0-5][0-9]' THEN
               CALL cl_err(g_adk.adk07,'axd-006',0)
               NEXT FIELD adk07
            END IF
            IF g_adk.adk07 >= '2400' THEN
               CALL cl_err(g_adk.adk07,'axd-006',0)
               NEXT FIELD adk07
            END IF
            IF g_adk.adk06 = g_adk.adk04 AND g_adk.adk07 < g_adk.adk05 THEN
               CALL cl_err(g_adk.adk07,'axd-001',0)
               NEXT FIELD adk06
            END IF

     AFTER FIELD adk13
            IF NOT cl_null(g_adk.adk13) THEN
               CALL t204_gen02('a','1')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk13 = g_adk_t.adk13
                  DISPLAY BY NAME g_adk.adk13
                  NEXT FIELD adk13
               END IF
               SELECT gen03 INTO g_adk.adk14 FROM gen_file
                WHERE gen01 = g_adk.adk13
               DISPLAY BY NAME g_adk.adk14
            END IF

     AFTER FIELD adk14
            IF NOT cl_null(g_adk.adk14) THEN
               CALL t204_adk14('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk14 = g_adk_t.adk14
                  DISPLAY BY NAME g_adk.adk14
                  NEXT FIELD adk14
               END IF
            END IF

       AFTER FIELD adk15
            IF NOT cl_null(g_adk.adk15) THEN
               SELECT COUNT(*) INTO l_n FROM obn_file
                WHERE obn01 = g_adk.adk15
               IF l_n = 0 THEN
                  CALL cl_err(g_adk.adk15,100,0)
                  NEXT FIELD adk15
               END IF
            END IF

    AFTER FIELD adk08
            IF NOT cl_null(g_adk.adk08) THEN
               SELECT * INTO l_obw.* FROM obw_file
                WHERE obw01 = g_adk.adk08 AND obw07 = '1'
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adk.adk08,'axd-002',0)
                  LET g_adk.adk08 = g_adk_t.adk08
                  NEXT FIELD adk08
               END IF
               CALL t204_oby()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk08 = g_adk_t.adk08
                  DISPLAY BY NAME g_adk.adk08
                  NEXT FIELD adk08
               END IF
               IF g_adk.adk08 <> g_adk08_t OR cl_null(g_adk08_t) THEN
                  LET g_adk.adk09 = l_obw.obw16
                  LET g_adk.adk10 = l_obw.obw17
                  LET g_adk.adk11 = l_obw.obw18
                  LET g_adk.adk12 = l_obw.obw19
                  DISPLAY BY NAME g_adk.adk09
                  DISPLAY BY NAME g_adk.adk10
                  DISPLAY BY NAME g_adk.adk11
                  DISPLAY BY NAME g_adk.adk12
               END IF
            END IF

     AFTER FIELD adk09
            IF NOT cl_null(g_adk.adk09) THEN
               CALL t204_gen02('a','2')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk09 = g_adk_t.adk09
                  DISPLAY BY NAME g_adk.adk09
                  NEXT FIELD adk09
               END IF
            END IF

     AFTER FIELD adk10
            IF NOT cl_null(g_adk.adk10) THEN
               CALL t204_gen02('a','3')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk10 = g_adk_t.adk10
                  DISPLAY BY NAME g_adk.adk10
                  NEXT FIELD adk10
               END IF
            END IF

     AFTER FIELD adk11
            IF NOT cl_null(g_adk.adk11) THEN
               CALL t204_gen02('a','4')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk11 = g_adk_t.adk11
                  DISPLAY BY NAME g_adk.adk11
                  NEXT FIELD adk11
               END IF
            END IF

     AFTER FIELD adk12
            IF NOT cl_null(g_adk.adk12) THEN
               CALL t204_gen02('a','5')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adk.adk12 = g_adk_t.adk12
                  DISPLAY BY NAME g_adk.adk12
                  NEXT FIELD adk12
               END IF
            END IF

        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            CALL t204_oby()
            IF NOT cl_null(g_errno)  THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD adk08
            END IF
      #MOD-650015 --start
      #  ON ACTION CONTROLO                       # 沿用所有欄位
      #      IF INFIELD(adk01) THEN
      #          LET g_adk.* = g_adk_t.*
      #          DISPLAY BY NAME g_adk.* ATTRIBUTE(YELLOW)
      #          NEXT FIELD adk01
      #      END IF
      #MOD-650015 --start
        ON ACTION CONTROLP
           CASE WHEN INFIELD(adk01)        #need modify
#                    LET g_t1=g_adk.adk01[1,3]
                    LET g_t1 = s_get_doc_no(g_adk.adk01)       #No.FUN-550026
                    #CALL q_adz(FALSE,FALSE,g_t1,19,'axd') RETURNING g_t1 #TQC-670008
                    CALL q_adz(FALSE,FALSE,g_t1,19,'AXD') RETURNING g_t1  #TQC-670008

#                    LET g_adk.adk01[1,3]=g_t1
                    LET g_adk.adk01 = g_t1      #No.FUN-550026
                    DISPLAY BY NAME g_adk.adk01
                    NEXT FIELD adk01
                WHEN INFIELD(adk03)
                    #CALL q_adj(0,0,g_adk.adk03) RETURNING g_adk.adk03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adj"
                    LET g_qryparam.default1 = g_adk.adk03
                    CALL cl_create_qry() RETURNING g_adk.adk03
#                    CALL FGL_DIALOG_SETBUFFER( g_adk.adk03 )
                    DISPLAY BY NAME g_adk.adk03
                    NEXT FIELD adk03
                WHEN INFIELD(adk13)
                    #CALL q_gen(0,0,g_adk.adk13) RETURNING g_adk.adk13
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk13
                    CALL cl_create_qry() RETURNING g_adk.adk13
#                    CALL FGL_DIALOG_SETBUFFER( g_adk.adk13 )
                    DISPLAY BY NAME g_adk.adk13
                    NEXT FIELD adk13
                WHEN INFIELD(adk14)
                    #CALL q_gem(0,0,g_adk.adk14) RETURNING g_adk.adk14
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_adk.adk14
                    CALL cl_create_qry() RETURNING g_adk.adk14
#                    CALL FGL_DIALOG_SETBUFFER( g_adk.adk14 )
                    DISPLAY BY NAME g_adk.adk14
                    NEXT FIELD adk14
                WHEN INFIELD(adk15)
                    #CALL q_obn(0,0,g_adk.adk15) RETURNING g_adk.adk15
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_obn"
                    LET g_qryparam.default1 = g_adk.adk15
                    CALL cl_create_qry() RETURNING g_adk.adk15
#                    CALL FGL_DIALOG_SETBUFFER( g_adk.adk15 )
                    DISPLAY BY NAME g_adk.adk15
                    NEXT FIELD adk15
                WHEN INFIELD(adk08)
                    #CALL q_obw(0,0,g_adk.adk08,g_adk.adk04,g_adk.adk05,g_adk.adk06,g_adk.adk07)
                    #     RETURNING g_adk.adk08
                    CALL q_obw(FALSE,FALSE,g_adk.adk08,g_adk.adk04,g_adk.adk05,g_adk.adk06,g_adk.adk07)
                         RETURNING g_adk.adk08
                    DISPLAY BY NAME g_adk.adk08
                    NEXT FIELD adk08
                WHEN INFIELD(adk09)
                    #CALL q_gen(0,0,g_adk.adk09) RETURNING g_adk.adk09
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk09
                    CALL cl_create_qry() RETURNING g_adk.adk09
#                    CALL FGL_DIALOG_SETBUFFER( g_adk.adk09 )
                    DISPLAY BY NAME g_adk.adk09
                    NEXT FIELD adk09
                WHEN INFIELD(adk10)
                    #CALL q_gen(0,0,g_adk.adk10) RETURNING g_adk.adk10
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk10
                    CALL cl_create_qry() RETURNING g_adk.adk10
#                    CALL FGL_DIALOG_SETBUFFER( g_adk.adk10 )
                    DISPLAY BY NAME g_adk.adk10
                    NEXT FIELD adk10
                WHEN INFIELD(adk11)
                    #CALL q_gen(0,0,g_adk.adk11) RETURNING g_adk.adk11
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk11
                    CALL cl_create_qry() RETURNING g_adk.adk11
#                    CALL FGL_DIALOG_SETBUFFER( g_adk.adk11 )
                    DISPLAY BY NAME g_adk.adk11
                    NEXT FIELD adk11
                WHEN INFIELD(adk12)
                    #CALL q_gen(0,0,g_adk.adk12) RETURNING g_adk.adk12
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adk.adk12
                    CALL cl_create_qry() RETURNING g_adk.adk12
#                    CALL FGL_DIALOG_SETBUFFER( g_adk.adk12 )
                    DISPLAY BY NAME g_adk.adk12
                    NEXT FIELD adk12
                OTHERWISE EXIT CASE
            END CASE

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                       # 欄位說明
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

FUNCTION t204_adk17()
    DEFINE l_str LIKE type_file.chr8   #No.FUN-680108 VARCHAR(08)

    CASE g_adk.adk17
         WHEN '0' CALL cl_getmsg('apy-558',g_lang) RETURNING l_str
         WHEN '1' CALL cl_getmsg('apy-559',g_lang) RETURNING l_str
         WHEN 'S' CALL cl_getmsg('apy-561',g_lang) RETURNING l_str
         WHEN 'R' CALL cl_getmsg('apy-562',g_lang) RETURNING l_str
         WHEN 'W' CALL cl_getmsg('apy-563',g_lang) RETURNING l_str
    END CASE
    DISPLAY l_str TO FORMONLY.desc

END FUNCTION

FUNCTION t204_adl04(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1      #No.FUN-680108 VARCHAR(01)

        LET g_errno = ' '
        SELECT adf_file.*,adg_file.* INTO g_adf.*,g_adg.*
          FROM adg_file,adf_file,add_file,ade_file
         WHERE adg01 = adf01
           AND adg01 = g_adl[l_ac].adl03
           AND adg02 = g_adl[l_ac].adl04
           AND adfacti = 'Y' AND adf10 = '1'
           AND add01 = ade01
           AND adg03 = ade01 AND adg04 = ade02
           AND ade13 = 'N' AND addacti = 'Y'
        IF SQLCA.sqlcode THEN
           LET g_errno = SQLCA.SQLCODE USING '-------'
        END IF
        IF cl_null(g_errno) OR p_cmd = 'd' THEN
           LET g_adl[l_ac].adg09 = g_adg.adg09
           LET g_adl[l_ac].adg10 = g_adg.adg10
           LET g_adl[l_ac].adg11 = g_adg.adg11
           IF p_cmd = 'a' OR g_adl[l_ac].adl03 <> g_adl_t.adl03
              OR g_adl[l_ac].adl04 <> g_adl_t.adl04 THEN
              LET g_adl[l_ac].adl05 = g_adg.adg12-g_adg.adg17
              LET g_adl[l_ac].adl07 = g_adf.adf06
           END IF
        END IF
END FUNCTION

FUNCTION t204_gen02(p_cmd,p_code)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
        p_code      LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
        l_gen01     LIKE gen_file.gen01,
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti

  LET g_errno = ' '
  CASE WHEN p_code = '1' LET l_gen01 = g_adk.adk13
       WHEN p_code = '2' LET l_gen01 = g_adk.adk09
       WHEN p_code = '3' LET l_gen01 = g_adk.adk10
       WHEN p_code = '4' LET l_gen01 = g_adk.adk11
       WHEN p_code = '5' LET l_gen01 = g_adk.adk12
  END CASE
  SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
   WHERE gen01 = l_gen01

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET l_gen01 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
  CASE WHEN p_code = '1' DISPLAY l_gen02 TO FORMONLY.gen02
       WHEN p_code = '2' DISPLAY l_gen02 TO FORMONLY.gen02a
       WHEN p_code = '3' DISPLAY l_gen02 TO FORMONLY.gen02b
       WHEN p_code = '4' DISPLAY l_gen02 TO FORMONLY.gen02c
       WHEN p_code = '5' DISPLAY l_gen02 TO FORMONLY.gen02d
  END CASE
  END IF
END FUNCTION

FUNCTION t204_oby()
DEFINE l_n  LIKE type_file.num5     #No.FUN-680108 SMALLINT

    LET g_errno = ' '
    #用于判斷預計出車時間或是返回時間是否在暫停使用記錄中存在
    #如果這兩者之一的時間在區域內表示當前不能用
    SELECT COUNT(*) INTO l_n FROM oby_file
     WHERE oby01 = g_adk.adk08
       AND (((oby02 < g_adk.adk04 OR    #出車時間在暫停範圍內
             (oby02 = g_adk.adk04 AND oby03 < g_adk.adk05)) AND
             (oby04 > g_adk.adk04 OR
             (oby04 = g_adk.adk04 AND oby05 > g_adk.adk05)))
        OR  ((oby02 < g_adk.adk06 OR    #返回時間在暫停範圍內
             (oby02 = g_adk.adk06 AND oby03 < g_adk.adk07)) AND
             (oby04 > g_adk.adk06 OR
             (oby04 = g_adk.adk06 AND oby05 > g_adk.adk07)))
        OR  ((oby02 > g_adk.adk04 OR    #暫停時間包含在範圍內
             (oby02 = g_adk.adk04 AND oby03 >= g_adk.adk05)) AND
             (oby04 < g_adk.adk06 OR
             (oby04 = g_adk.adk06 AND oby05 <= g_adk.adk07))))
    IF l_n > 0 THEN
       LET g_errno = 'axd-005'
    END IF
END FUNCTION

FUNCTION t204_adk14(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(01)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti

  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
                          WHERE gem01 = g_adk.adk14

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET g_adk.adk14 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION

FUNCTION t204_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_adk.* TO NULL               #No.FUN-6A0165

    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_adl.clear()

    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(GREEN)
    CALL t204_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Waiting...." ATTRIBUTE(REVERSE)
    OPEN t204_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        INITIALIZE g_adk.* TO NULL
    ELSE
        OPEN t204_count
        FETCH t204_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t204_t('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION t204_t(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680108 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     t204_cs INTO g_adk_rowid,g_adk.adk01
        WHEN 'P' FETCH PREVIOUS t204_cs INTO g_adk_rowid,g_adk.adk01
        WHEN 'F' FETCH FIRST    t204_cs INTO g_adk_rowid,g_adk.adk01
        WHEN 'L' FETCH LAST     t204_cs INTO g_adk_rowid,g_adk.adk01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
#              PROMPT g_msg CLIPPED,': ' FOR l_abso
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
                ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t204_cs INTO g_adk_rowid,g_adk.adk01
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_adk.* TO NULL   #No.TQC-6B0105
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

    SELECT * INTO g_adk.* FROM adk_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_adk_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
    ELSE
         LET g_data_owner=g_adk.adkuser           #FUN-4C0052權限控管
         LET g_data_group=g_adk.adkgrup
 
        CALL t204_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION t204_show()
    DEFINE l_str LIKE type_file.chr8    #No.FUN-680108 VARCHAR(08)

    LET g_adk_t.* = g_adk.*
 DISPLAY BY NAME g_adk.adk01,g_adk.adk02,g_adk.adk03,g_adk.adk04,
                    g_adk.adk05,g_adk.adk06,g_adk.adk07,g_adk.adk16,
                    g_adk.adk13,g_adk.adk14,g_adk.adk15,g_adk.adk17,
                    g_adk.adk08,g_adk.adk09,g_adk.adk10,g_adk.adk11,
                    g_adk.adk12,g_adk.adkmksg,g_adk.adksign,g_adk.adkuser,
                    g_adk.adkgrup,g_adk.adkmodu,g_adk.adkdate,g_adk.adkacti,
                    g_adk.adkconf
     CALL cl_set_field_pic(g_adk.adkconf,"","","","",g_adk.adkacti)  #NO.MOD-4B0082
    CALL t204_gen02('d','1')
    CALL t204_gen02('d','2')
    CALL t204_gen02('d','3')
    CALL t204_gen02('d','4')
    CALL t204_gen02('d','5')
    CALL t204_adk14('d')
    CALL t204_adk17()
    CALL t204_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION t204_u()
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_adk.adk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'mfg1000',0)
        RETURN
    END IF
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'9022',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_adk01_t = g_adk.adk01
    LET g_adk08_t = g_adk.adk08
    LET g_adk_t.* = g_adk.*
    LET g_adk_o.* = g_adk.*
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
       CLOSE t204_cl ROLLBACK WORK RETURN
    END IF
    LET g_adk.adkmodu=g_user                     #修改者
    LET g_adk.adkdate = g_today                  #修改日期
    CALL t204_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t204_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_adk.*=g_adk_t.*
            CALL t204_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_adk.adk01 != g_adk01_t THEN
            UPDATE adl_file SET adl01= g_adk.adk01
                    WHERE adl01 = g_adk01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err('update adl:',SQLCA.sqlcode,0)
               CONTINUE WHILE
            END IF
        END IF
        UPDATE adk_file SET adk_file.* = g_adk.*    # 更新DB
         WHERE ROWID = g_adk_rowid             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t204_cl
    COMMIT WORK
END FUNCTION

FUNCTION t204_x()
    DEFINE
        l_chr LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF
    IF g_adk.adk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'9022',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t204_show()
    IF cl_exp(0,0,g_adk.adkacti) THEN
        LET g_chr=g_adk.adkacti
        IF g_adk.adkacti='Y' THEN
            LET g_adk.adkacti='N'
        ELSE
            LET g_adk.adkacti='Y'
        END IF
        UPDATE adk_file
            SET adkacti=g_adk.adkacti,
               adkmodu=g_user, adkdate=g_today
            WHERE ROWID=g_adk_rowid
        IF STATUS=100 THEN
            CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
            LET g_adk.adkacti=g_chr
        END IF
        DISPLAY BY NAME g_adk.adkacti ATTRIBUTE(RED)
    END IF
    CLOSE t204_cl
    COMMIT WORK
END FUNCTION

FUNCTION t204_r()
    DEFINE l_chr LIKE type_file.chr1      #No.FUN-680108 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF
    IF g_adk.adk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'9022',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t204_show()
    IF cl_delh(15,16) THEN
        DELETE FROM adk_file WHERE ROWID = g_adk_rowid
        IF STATUS=100 THEN
           CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        ELSE
           DELETE FROM adl_file WHERE adl01=g_adk.adk01
           CLEAR FORM
           CALL g_adl.clear()
--mi
         OPEN t204_count
         FETCH t204_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t204_cl
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t204_t('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t204_t('/')
         END IF
--#
        END IF
    END IF
    CLOSE t204_cl
    COMMIT WORK
END FUNCTION

#單身
FUNCTION t204_b()
DEFINE
    l_buf           LIKE adl_file.adl03, #儲存尚在使用中之下游檔案之檔名 #No.FUN-680108 VARCHAR(80)
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT   #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用   #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否   #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態     #No.FUN-680108 VARCHAR(1)
    l_bcur          LIKE type_file.chr1,   #'1':表存放位置有值,'2':則為NULL#No.FUN-680108 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,   #可新增否     #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否     #No.FUN-680108 SMALLINT

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF
    IF g_adk.adk01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkacti MATCHES'[Nn]' THEN
       CALL cl_err(g_adk.adk01,'mfg1000',0)
       RETURN
    END IF
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_adk.adk01,'9022',0)
        RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql=" SELECT adl02,adl03,adl04,'','',adl05,'',",
                     "        adl06,adl07,adl08,adl09,adl10",
                     "   FROM adl_file",
                     "  WHERE adl02=? AND adl01=?",
                     "    FOR UPDATE NOWAIT"
    DECLARE t204_bcl CURSOR FROM g_forupd_sql

      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_adl WITHOUT DEFAULTS FROM s_adl.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT

            BEGIN WORK
            OPEN t204_cl USING g_adk.adk01
            IF STATUS THEN
               CALL cl_err("OPEN t204_cl:", STATUS, 1)
               CLOSE t204_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t204_cl INTO g_adk.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
                CLOSE t204_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_adl_t.* = g_adl[l_ac].*  #BACKUP
                OPEN t204_bcl USING g_adl_t.adl02,g_adk.adk01
                IF STATUS THEN
                   CALL cl_err("OPEN t204_bcl:", STATUS, 1)
                   LET l_lock_sw='Y'
                ELSE
                   FETCH t204_bcl INTO g_adl[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_adl_t.adl02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   CALL t204_adl04('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adl[l_ac].* TO NULL      #900423
            LET g_adl_t.* = g_adl[l_ac].*     #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adl02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO adl_file(adl01,adl02,adl03,adl04,adl05,adl06,
                                  adl07,adl08,adl09,adl10)  #No.MOD-470041
                        VALUES(g_adk.adk01,
                               g_adl[l_ac].adl02, g_adl[l_ac].adl03,
                               g_adl[l_ac].adl04, g_adl[l_ac].adl05,
                               g_adl[l_ac].adl06, g_adl[l_ac].adl07,
                               g_adl[l_ac].adl08, g_adl[l_ac].adl09,
                               g_adl[l_ac].adl10)
            IF SQLCA.SQLcode  THEN
                CALL cl_err(g_adl[l_ac].adl02,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF

        BEFORE FIELD adl02                        # dgeeault 序號
            IF g_adl[l_ac].adl02 IS NULL or g_adl[l_ac].adl02 = 0 THEN
                SELECT max(adl02)+1 INTO g_adl[l_ac].adl02 FROM adl_file
                    WHERE adl01 = g_adk.adk01
                IF g_adl[l_ac].adl02 IS NULL THEN
                    LET g_adl[l_ac].adl02 = 1
                END IF
            END IF

        AFTER FIELD adl02
            IF g_adl[l_ac].adl02 IS NOT NULL AND
               (g_adl[l_ac].adl02 != g_adl_t.adl02 OR
                g_adl_t.adl02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM adl_file
                 WHERE adl01 = g_adk.adk01
                   AND adl02 = g_adl[l_ac].adl02
                IF l_n > 0 THEN
                    CALL cl_err(g_adl[l_ac].adl02,-239,0)
                    LET g_adl[l_ac].adl02 = g_adl_t.adl02
                    NEXT FIELD adl02
                END IF
            END IF

        AFTER FIELD adl03
            IF NOT cl_null(g_adl[l_ac].adl03) THEN
               SELECT * FROM adf_file WHERE adf01 = g_adl[l_ac].adl03
                  AND adfacti = 'Y' AND adf10 = '1'
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adl[l_ac].adl03,SQLCA.sqlcode,0)
                  LET g_adl[l_ac].adl03 = g_adl_t.adl03
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adl[l_ac].adl03
                  #------MOD-5A0095 END------------
                  NEXT FIELD adl03
               END IF
            END IF

        AFTER FIELD adl04
            IF NOT cl_null(g_adl[l_ac].adl04) THEN
               CALL t204_adl04(p_cmd)
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adl[l_ac].adl04 = g_adl_t.adl04
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adl[l_ac].adl04
                  #------MOD-5A0095 END------------
                  NEXT FIELD adl03
               END IF
            END IF

        AFTER FIELD adl05
            IF g_adl[l_ac].adl05 < 0 THEN NEXT FIELD adl05 END IF
            IF g_adl[l_ac].adl05 > (g_adg.adg12-g_adg.adg17) THEN
               CALL cl_err(g_adl[l_ac].adl05,'axd-004',0)
               NEXT FIELD adl05
            END IF

        AFTER FIELD adl06
            IF g_adl[l_ac].adl06 < 0 THEN
               NEXT FIELD adl06
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_adl_t.adl02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM adl_file
                    WHERE adl01=g_adk.adk01 AND adl02 = g_adl_t.adl02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adl_t.adl02,SQLCA.sqlcode,0)
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
               LET g_adl[l_ac].* = g_adl_t.*
               CLOSE t204_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adl[l_ac].adl02,-263,1)
               LET g_adl[l_ac].* = g_adl_t.*
            ELSE
    UPDATE adl_file 
       SET adl02=g_adl[l_ac].adl02,adl03=g_adl[l_ac].adl03,        
           adl04=g_adl[l_ac].adl04,adl05=g_adl[l_ac].adl05,        
           adl06=g_adl[l_ac].adl06,adl07=g_adl[l_ac].adl07,        
           adl08=g_adl[l_ac].adl08,adl09=g_adl[l_ac].adl09,        
           adl10=g_adl[l_ac].adl10                       
     WHERE CURRENT OF t204_bcl 
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adl[l_ac].adl02,SQLCA.sqlcode,0)
                  LET g_adl[l_ac].* = g_adl_t.*
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
                  LET g_adl[l_ac].* = g_adl_t.*
               END IF
               CLOSE t204_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t204_bcl
            COMMIT WORK
      #MOD-650015 --start
      #  ON ACTION CONTROLO                       #沿用所有欄位
      #      IF INFIELD(adl02) AND l_ac > 1 THEN
      #          LET g_adl[l_ac].* = g_adl[l_ac-1].*
      #          NEXT FIELD adl02
      #      END IF
      #MOD-650015 --start
        ON ACTION CONTROLN
            CALL t204_b_askkey()
            EXIT INPUT

        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adl03)
                #CALL q_adg(5,3,g_adl[l_ac].adl03,g_adl[l_ac].adl04,'')
                #     RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                CALL q_adg(FALSE,FALSE,g_adl[l_ac].adl03,g_adl[l_ac].adl04,'')
                     RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                NEXT FIELD adl03
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
     LET g_adk.adkmodu = g_user
     LET g_adk.adkdate = g_today
     UPDATE adk_file SET adkmodu = g_adk.adkmodu,adkdate = g_adk.adkdate
      WHERE adk01 = g_adk.adk01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err('upd adk',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_adk.adkmodu,g_adk.adkdate
    #FUN-5B0113-end

    CLOSE t204_bcl
    COMMIT WORK
#   call t204_delall()
END FUNCTION

FUNCTION t204_delall()
    SELECT COUNT(*) INTO g_cnt FROM adl_file
        WHERE adl01 = g_adk.adk01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM adk_file WHERE adk01 = g_adk.adk01
    END IF
END FUNCTION

FUNCTION t204_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CONSTRUCT l_wc ON adl02,adl03,adld04,adl05,adl06,  #螢幕上取單身條件
                      adl07,adl08,adl09,adl10
       FROM s_adl[1].adl02,s_adl[1].adl03,s_adl[1].adl04,s_adl[1].adl05,
            s_adl[1].adl06,s_adl[1].adl07,s_adl[1].adl08,s_adl[1].adl09,
            s_adl[1].adl10

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adl03)
                #CALL q_adg(5,3,g_adl[l_ac].adl03,g_adl[l_ac].adl04,'')
                #     RETURNING g_adl[l_ac].adl03,g_adl[l_ac].adl04
                CALL q_adg(FALSE,FALSE,g_adl[l_ac].adl03,g_adl[l_ac].adl04,'')
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_adl[1].adl03
                NEXT FIELD adl03
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
    CALL t204_b_fill(l_wc)
END FUNCTION

FUNCTION t204_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc   LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(400)

    LET g_sql =
    "SELECT adl02,adl03,adl04,adg09,adg10,adl05,adg11,adl06,",
       " adl07,adl08,adl09,adl10",
       " FROM adl_file,OUTER adg_file",
       " WHERE adl01 = '",g_adk.adk01,"' AND ",p_wc CLIPPED ,
       "   AND adg_file.adg01 = adl03 AND adg_file.adg02 = adl04 ",
       " ORDER BY 1"
    PREPARE t204_prepare2 FROM g_sql      #預備一下
    DECLARE adl_cs CURSOR FOR t204_prepare2

    #單身 ARRAY 乾洗
    CALL g_adl.clear()
    LET g_cnt = 1
    FOREACH adl_cs INTO g_adl[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adl.deleteElement(g_cnt)

    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t204_bp(p_ud)
DEFINE
    p_ud    LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adl TO s_adl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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
         CALL t204_t('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL t204_t('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump
         CALL t204_t('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL t204_t('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION last
         CALL t204_t('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
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
           CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY
       ON ACTION controlg
          LET g_action_choice="controlg"
          EXIT DISPLAY
       ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

       ON ACTION confirm
          LET g_action_choice="confirm"
          EXIT DISPLAY
       ON ACTION undo_confirm
          LET g_action_choice="undo_confirm"
          EXIT DISPLAY
     #@ON ACTION 其他托運物品
       ON ACTION btn01
          LET g_action_choice="btn01"
          EXIT DISPLAY
     #@ON ACTION 簽核狀況
      #ON ACTION btn02
      #   LET g_action_choice="btn02"
      #   EXIT DISPLAY
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

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t204_copy()
DEFINE
    l_newno         LIKE adk_file.adk01,
    l_oldno         LIKE adk_file.adk01
DEFINE li_result   LIKE type_file.num5    #No.FUN-550026  #No.FUN-680108 SMALLINT

    IF s_shut(0) THEN RETURN END IF
    IF g_adk.adk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL t204_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno FROM adk01
#No.FUN-550026 --start--
	  BEFORE INPUT
	     CALL cl_set_docno_format("adk01")
#No.FUN-550026 ---end---

        AFTER FIELD adk01
            IF l_newno IS NULL THEN
                NEXT FIELD adk01
            END IF
#No.FUN-550026 --start--
    CALL s_check_no("axd",l_newno,"","19","adk_file","adk01","")
         RETURNING li_result,l_newno
    DISPLAY l_newno TO adk01
       IF (NOT li_result) THEN
          NEXT FIELD adk01
       END IF
{
            LET g_t1 = l_newno[1,3]
            SELECT * INTO g_adz.* FROM adz_file WHERE adzslip = g_t1
               AND adztype = '19'
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_newno,'mfg0014',0)
               NEXT FIELD adk01
            END IF
            IF g_adz.adzauno='Y' THEN   #need modify to add adk_file in it
               CALL s_axdauno(l_newno,g_adk.adk02) RETURNING g_i,l_newno
               IF g_i THEN #有問題
                  NEXT FIELD adk01
               END IF
               DISPLAY l_newno TO adk01
            END IF

            SELECT count(*) INTO g_cnt FROM adk_file
                WHERE adk01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD adk01
            END IF
}
#No.FUN-550026 ---end--

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adk01)        #need modify
#                    LET g_t1=l_newno[1,3]
                    LET g_t1 = s_get_doc_no(l_newno)       #No.FUN-550026
                    #CALL q_adz(FALSE,FALSE,g_t1,19,'axd') RETURNING g_t1 #TQC-670008
                    CALL q_adz(FALSE,FALSE,g_t1,19,'AXD') RETURNING g_t1  #TQC-670008
#                    LET l_newno[1,3]=g_t1
                    LET l_newno = g_t1       #No.FUN-550026
                    DISPLAY l_newno TO adk01
                    NEXT FIELD adk01
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
    SELECT * FROM adk_file
        WHERE adk01=g_adk.adk01
        INTO TEMP y
    UPDATE y
        SET y.adk01=l_newno,    #資料鍵值
            y.adkuser = g_user,
            y.adkgrup = g_grup,
            y.adkdate = g_today,
            y.adkacti = 'Y',
            y.adkconf = 'N'
    INSERT INTO adk_file  #複製單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL  cl_err(l_newno,SQLCA.sqlcode,0)
    END IF
    DROP TABLE x
    SELECT * FROM adl_file
       WHERE adl01 = g_adk.adk01
       INTO TEMP x
    UPDATE x
       SET adl01 = l_newno
    INSERT INTO adl_file    #複製單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_newno,SQLCA.sqlcode,0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno = g_adk.adk01
        SELECT ROWID,adk_file.* INTO g_adk_rowid,g_adk.* FROM adk_file
               WHERE adk01 =  l_newno
        CALL t204_u()
        CALL t204_show()
        LET g_adk.adk01 = l_oldno
        SELECT ROWID,adk_file.* INTO g_adk_rowid,g_adk.* FROM adk_file
               WHERE adk01 = g_adk.adk01
        CALL t204_show()
    END IF
    DISPLAY BY NAME g_adk.adk01
END FUNCTION

FUNCTION t204_y() #確認
    IF g_adk.adk01 IS NULL THEN RETURN END IF
    IF g_adk.adk08 IS NULL THEN RETURN END IF
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkconf='Y' THEN RETURN END IF
    IF g_adk.adkacti='N' THEN RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM adm_file WHERE adm01 = g_adk.adk01
    IF g_cnt = 0 THEN
       IF NOT cl_confirm('axd-015') THEN RETURN END IF
    ELSE
       IF NOT cl_confirm('axm-108') THEN RETURN END IF
    END IF

    CALL t204_oby()
    IF NOT cl_null(g_errno)  THEN
       CALL cl_err('',g_errno,0)
       RETURN
    END IF

    LET g_success='Y'
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        CLOSE t204_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL t204_y1()
    IF SQLCA.SQLCODE THEN LET g_success='N' END IF

    IF g_success = 'Y' THEN
       UPDATE adk_file SET adkconf='Y',adk17='1'
        WHERE adk01 = g_adk.adk01
       IF STATUS THEN
          CALL cl_err('upd adkconf',STATUS,0)
          ROLLBACK WORK
          RETURN
       END IF
    ELSE
       ROLLBACK WORK
       RETURN
    END IF
    SELECT adkconf,adk17 INTO g_adk.adkconf,g_adk.adk17 FROM adk_file
        WHERE adk01 = g_adk.adk01
    DISPLAY BY NAME g_adk.adkconf
    DISPLAY BY NAME g_adk.adk17
    CALL t204_adk17()
END FUNCTION

FUNCTION t204_y1()
  DEFINE b_adl RECORD
               adl02  LIKE adl_file.adl02,   #項次
               adl03  LIKE adl_file.adl03,   #撥出單號
               adl04  LIKE adl_file.adl04,   #撥出單項次
               adl05  LIKE adl_file.adl05    #撥出數量
               END RECORD

  #對于adl中的每一筆都要insert到adq_file中
  DECLARE t204_y1_c1 CURSOR FOR
   SELECT adl02,adl03,adl04,adl05 FROM adl_file WHERE adl01=g_adk.adk01
  FOREACH t204_y1_c1 INTO b_adl.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(b_adl.adl03) THEN CONTINUE FOREACH END IF
      CALL t204_y2(b_adl.*)
      IF g_success='N' THEN RETURN END IF
  END FOREACH
END FUNCTION

FUNCTION t204_y2(p_adl)
  DEFINE p_adl   RECORD
                 adl02  LIKE adl_file.adl02,   #項次
                 adl03  LIKE adl_file.adl03,   #撥出單號
                 adl04  LIKE adl_file.adl04,   #撥出單項次
                 adl05  LIKE adl_file.adl05    #撥出數量
                 END RECORD,
         l_buf   LIKE adl_file.adl03,          #No.FUN-680108 VARCHAR(100)
         l_adl05 LIKE adl_file.adl05,
         l_adg12 LIKE adg_file.adg12

  SELECT adg12-adg17 INTO l_adg12 FROM adg_file,adf_file   #當前撥出單總數量
   WHERE adg01 = p_adl.adl03 AND adg02 = p_adl.adl04
     AND adf01 = adg01 AND adfacti = 'Y'
     AND adf10 = '1'

  SELECT SUM(adl05) INTO l_adl05 FROM adl_file,adk_file   #已撥出數量
   WHERE adk01 = adl01
     AND adl01 <> g_adk.adk01
     AND adl03 = p_adl.adl03
     AND adl04 = p_adl.adl04
     AND adkacti = 'Y'
     AND adkconf = 'Y'
   GROUP BY adl03,adl04

  IF l_adl05 + p_adl.adl05 > l_adg12 THEN
     LET l_buf = p_adl.adl03 CLIPPED,' ',p_adl.adl04 CLIPPED,
                 ' ',p_adl.adl05 CLIPPED
     CALL cl_err(l_buf CLIPPED,'axd-009',1)
     LET g_success = 'N' RETURN
  END IF
END FUNCTION

FUNCTION t204_z() #取消確認
    IF g_adk.adk01 IS NULL THEN RETURN END IF
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkconf='N' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK
    OPEN t204_cl USING g_adk.adk01
    IF STATUS THEN
       CALL cl_err("OPEN t204_cl:", STATUS, 1)
       CLOSE t204_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t204_cl INTO g_adk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        CLOSE t204_cl
        ROLLBACK WORK
        RETURN
    END IF
    UPDATE adk_file SET adkconf='N',adk17='0'
        WHERE adk01 = g_adk.adk01
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
    SELECT adkconf,adk17 INTO g_adk.adkconf,g_adk.adk17 FROM adk_file
        WHERE adk01 = g_adk.adk01
    DISPLAY BY NAME g_adk.adkconf
    DISPLAY BY NAME g_adk.adk17
    CALL t204_adk17()
END FUNCTION

FUNCTION t204_prt()
   IF cl_confirm('mfg3242') THEN CALL t204_out('a') END IF
END FUNCTION

FUNCTION t204_out(p_cmd)
   DEFINE l_cmd         LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(200)
          p_cmd         LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
          l_prog        LIKE zz_file.zz01,     #No.FUN-680108 VARCHAR(10)
          l_wc,l_wc2    LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(50)
          l_prtway      LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
          l_lang        LIKE type_file.chr1    # Prog. Version..: '5.10.00-08.01.04(0.中文/1.英文/2.簡體)    #No.FUN-680108 VARCHAR(1)

   IF cl_null(g_adk.adk01) THEN CALL cl_err('','-400',0) RETURN END IF
   OPTIONS FORM LINE FIRST + 1
 #NO.MOD-4B0082  --begin
#   LET p_row = 3 LET p_col = 3
#   OPEN WINDOW w1 AT p_row,p_col WITH 2 ROWS, 75 COLUMNS
#        ATTRIBUTE(STYLE = g_win_style)
   MENU ""
        ON ACTION Vehicle_Dispatching_List
                 LET l_prog='axdr205'
                 EXIT MENU
        ON ACTION Vehicle_Dispatching_Detail_List
                 LET l_prog='axdr209'
                 EXIT MENU

       ON ACTION exit
          EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 


        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

   END MENU
   IF NOT cl_null(l_prog) THEN #BugNo:5548
      IF l_prog = 'axdr205' OR p_cmd = 'a' THEN
         LET l_wc='adk01="',g_adk.adk01,'"'
      ELSE
         LET l_wc=g_wc CLIPPED,' AND ',g_wc2
      END IF
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
       WHERE zz01 = l_prog
      IF SQLCA.sqlcode OR l_wc2 IS NULL OR l_wc = ' ' THEN
         LET l_wc2 = " 'Y' 'Y' 'Y' "
      END IF
      LET l_cmd = l_prog CLIPPED,
              " '",g_today CLIPPED,"' '",g_user,"' ", #TQC-610088
              " '",g_lang CLIPPED,"' 'Y' ' ' '1'",    #TQC-610088
              " '",l_wc CLIPPED,"' ",l_wc2
      CALL cl_cmdrun(l_cmd)
   END IF
#   CLOSE WINDOW w1
#   OPTIONS FORM LINE FIRST + 2
 #NO.MOD-4B0082  --end
END FUNCTION

 #MOD-560158
#FUNCTION t204_w()
#DEFINE   l_formNum  LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(80)
#
#  IF g_aza.aza23 matches '[ Nn]' THEN      #未設定與 EasyFlow 簽核
#     CALL cl_err('aza23','mfg3551',0)
#     RETURN
#  END IF
#
#  IF g_adk.adk01 IS NULL OR g_adk.adk01 = ' ' THEN   #尚未查詢資料
#     CALL cl_err('', -400, 0)
#     RETURN
#  END IF
#
#  IF g_adk.adk17 NOT MATCHES "[S1WR]" THEN
#     RETURN
#  END IF
#
#  #No:8176
#  LET l_formNum = g_adk.adk01 CLIPPED, "{+}adk02=", g_adk.adk02
#  CALL aws_efstat(l_formNum)
#  ##
#END FUNCTION
 #END MOD-560158

FUNCTION t204_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1) 

   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("adk01",TRUE)
   END IF

END FUNCTION

FUNCTION t204_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1     #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("adk01",FALSE)
       END IF
   END IF

END FUNCTION
#Patch....NO:MOD-5A0095 <001,002> #
#Patch....NO:TQC-610037 <001,002> #
