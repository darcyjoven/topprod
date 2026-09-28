# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amri503.4gl
# Descriptions...: MRP 版本條件維護
# Date & Author..: 96/05/31 By Roger
# Modify.........: 03/05/17 By Jiunn
#                  帶出指定廠版與限定版別
# Modify.........: No.MOD-530639 05/03/28 By pengu  畫面納入獨立需求檔資料/納入實際訂單檔資料/納入MPS計畫(未開工單)下階料的備料需求等選項Default值為Y
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.FUN-640169 06/04/18 By Sarah 增加msr09是否顯示執行過程
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0041 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-920183 09/03/17 By shiwuying MRP功能改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0006 09/10/06 By Smapmin 新增時,階數預設為99
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A80150 10/09/07 by sabrina 模擬料號來源新增兩個選項"8:訂單計劃批號"、"9:工單計劃批號"
# Modify.........: No.FUN-A90057 10/09/27 By kim GP5.25號機管理
# Modify.........: No.TQC-B10170 11/01/18 By lixh1 開放計劃批號(msr919)查詢
# Modify.........: No.TQC-B20002 11/02/09 By vealxu 計畫批號(msr919)應該要可以修改
# Modify.........: No.TQC-B20002 11/02/09 By vealxu 計畫批號(msr919)應該要可以修改
# Modify.........: No.FUN-B20060 11/03/13 By zhangll 新增msr12
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-BC0225 11/12/22 By ck2yuan BUG修改,修改時資料會跳出別的版本的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_msr   RECORD LIKE msr_file.*,
    g_msr_t RECORD LIKE msr_file.*,
    g_msr_v_t LIKE msr_file.msr_v,
    g_wc,g_sql          STRING,  #No.FUN-580092 HCN      
    g_ima   RECORD LIKE ima_file.*,
    g_pmc   RECORD LIKE pmc_file.*
 
DEFINE g_forupd_sql                STRING   #SELECT ... FOR UPDATE SQL   
DEFINE g_before_input_done         STRING
DEFINE g_cnt                       LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE g_msg                       LIKE type_file.chr1000  #No.FUN-680082 VARCHAR(72)
DEFINE g_row_count                 LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE g_curs_index                LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE g_jump                      LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE mi_no_ask                   LIKE type_file.num5     #No.FUN-680082 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0076
    DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680082 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   INITIALIZE g_msr.* TO NULL
   INITIALIZE g_msr_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM msr_file WHERE msr_v = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i503_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW i503_w AT p_row,p_col
     WITH FORM "amr/42f/amri503"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #WHILE TRUE      ####040512
    LET g_action_choice=""
   #------------------MOD-530639--------
    LET g_msr.incl_id='Y'
    LET g_msr.incl_so='Y'
    #darcy:2024/06/17 add s---
    let g_msr.msr15 = 'Y'
    let g_msr.msr16 = 'Y' #darcy:2024/08/01 add
    #darcy:2024/06/17 add e---
    LET g_msr.msb_expl='Y'
    LET g_msr.mss_expl='Y'
    LET g_msr.msr06='Y'
    LET g_msr.msr07='Y'
    LET g_msr.msr12='Y'  #FUN-B20060 add
    CALL i503_show()
   #---------------MOD-530639 END-------
   CALL i503_menu()
     #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
   #END WHILE    ####040512
 
   CLOSE WINDOW i503_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION i503_cs()
    CLEAR FORM
   INITIALIZE g_msr.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       msr_v,msr01,{msr02,msr03,msr04,msr05,}
    #  lot_type, lot_bm, lot_no1, lot_no2, bdate, edate,          #TQC-B10170
       lot_type, lot_bm, lot_no1, lot_no2,msr919,bdate, edate,    #TQC-B10170
       buk_type, po_days, wo_days,
   #   incl_id, incl_so,                            #No.FUN-920183
       incl_id, incl_mds, msr10, msr11, incl_so,    #No.FUN-920183
       msb_expl, mss_expl,msr06,msr07,msr12,msr09,msr08   #FUN-640169 add msr09  #FUN-B20060 add msr12
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
   #No.FUN-920183 start -----
       ON ACTION controlp
          CASE
             WHEN INFIELD(msr10)
                CALL cl_init_qry_var()
                LET g_qryparam.state = 'c'
                LET g_qryparam.form = "q_msr10"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO msr10
                NEXT FIELD msr10
             WHEN INFIELD(msr11)                                                
                CALL cl_init_qry_var()                                          
                LET g_qryparam.state = 'c'                                      
                LET g_qryparam.form = "q_msr11"                                 
                CALL cl_create_qry() RETURNING g_qryparam.multiret              
                DISPLAY g_qryparam.multiret TO msr11                            
                NEXT FIELD msr11
             OTHERWISE EXIT CASE
          END CASE 
   #No.FUN-920183 end -------
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    LET g_sql="SELECT msr_v FROM msr_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY msr_v"
    PREPARE i503_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i503_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i503_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM msr_file WHERE ",g_wc CLIPPED
    PREPARE i503_precount FROM g_sql
    DECLARE i503_count CURSOR FOR i503_precount
END FUNCTION
 
FUNCTION i503_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i503_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i503_q()
            END IF
        ON ACTION next
            CALL i503_fetch('N')
        ON ACTION previous
            CALL i503_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i503_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i503_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i503_fetch('/')
        ON ACTION first
            CALL i503_fetch('F')
        ON ACTION last
            CALL i503_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6B0041-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_msr.msr_v IS NOT NULL THEN
                  LET g_doc.column1 = "msr_v"
                  LET g_doc.value1 = g_msr.msr_v
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6B0041-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i503_cs
END FUNCTION
 
 
FUNCTION i503_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_msr.* LIKE msr_file.*
    LET g_msr.msr_v=g_msr_t.msr_v
    LET g_msr_v_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
      #-----------------------MOD-530639---
        LET g_msr.incl_id='Y'
        LET g_msr.incl_so='Y'
        LET g_msr.msb_expl='Y'
        LET g_msr.mss_expl='Y'
        LET g_msr.msr06='Y'
        LET g_msr.msr07='Y'
        LET g_msr.msr12='Y'   #FUN-B20060 add
        LET g_msr.msr09='Y'   #FUN-640169 add
     #-----------MOD-530639 END------------
        LET g_msr.incl_mds = 'N' #No.FUN-920183 add
        LET g_msr.lot_bm = '99'   #MOD-9A0006
        CALL i503_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_msr.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_msr.msr_v IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO msr_file VALUES(g_msr.*)
        IF SQLCA.sqlcode THEN
#            CALL cl_err('ins msr:',SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("ins","msr_file",g_msr.msr_v,"",SQLCA.SQLCODE,"","ins msr:",1)       #NO.FUN-660107
            CONTINUE WHILE
        ELSE
            LET g_msr_t.* = g_msr.*                # 保存上筆資料
            SELECT msr_v INTO g_msr.msr_v FROM msr_file
                WHERE msr_v = g_msr.msr_v
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i503_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680082 VARCHAR(1)
        l_flag          LIKE type_file.chr1,         #No.FUN-680082 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680082 SMALLINT
 #No.FUN-920183 start -----
   DEFINE l_vld03       LIKE vld_file.vld03
   DEFINE l_vld04       LIKE vld_file.vld04
   DEFINE l_vld06       LIKE vld_file.vld06
   DEFINE l_vld14       LIKE vld_file.vld14
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE lot_type_t    LIKE  msr_file.lot_type
 #No.FUN-920183 end -------
 
    INPUT BY NAME
       g_msr.msr_v,g_msr.msr01,g_msr.msr02,g_msr.msr03,g_msr.msr04,g_msr.msr05,
     # g_msr.lot_type, g_msr.lot_bm, g_msr.lot_no1, g_msr.lot_no2,              #TQC-B20002 mark
       g_msr.lot_type, g_msr.lot_bm, g_msr.lot_no1, g_msr.lot_no2,g_msr.msr919, #TQC-B20002
       g_msr.bdate, g_msr.edate,g_msr.buk_type,g_msr.buk_code,
       g_msr.po_days, g_msr.wo_days,
     # g_msr.incl_id, g_msr.incl_so,           #No.FUN-920183
       g_msr.incl_id,g_msr.incl_mds,g_msr.msr10,g_msr.msr11,g_msr.incl_so,#No.FUN-920183
       g_msr.msb_expl, g_msr.mss_expl,g_msr.msr06,g_msr.msr07,g_msr.msr12,g_msr.msr09,g_msr.msr08   #FUN-640169 add msr09  #FUN-B20060 add msr12
       ,g_msr.msr15,g_msr.msr16,g_msr.msr17,g_msr.msr18,g_msr.msr19,g_msr.msr20,g_msr.msr21,g_msr.msr22,g_msr.msr23,g_msr.msr24,g_msr.msr25 #darcy:2024/06/17 add
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i503_set_entry(p_cmd)
           CALL i503_set_no_entry(p_cmd)
        #No.FUN-920183 start -----
           IF p_cmd = 'u' AND g_msr.lot_type = '6' THEN             
              CALL cl_set_comp_entry("lot_no1,lot_no2",FALSE)
           ELSE 
              CALL cl_set_comp_entry("lot_no1,lot_no2",TRUE)
           END IF
        #No.FUN-920183 end -------
        #TQC-B20002 ------add start------------
           IF p_cmd = 'u' THEN
              CALL cl_set_comp_entry("msr919",TRUE)
           END IF
        #TQC-B20002 ------add end--------------
           LET g_before_input_done = TRUE
           LET lot_type_t = g_msr.lot_type
 
        AFTER FIELD msr_v
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_msr.msr_v != g_msr_v_t) THEN
                SELECT count(*) INTO l_n FROM msr_file
                    WHERE msr_v = g_msr.msr_v
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD msr_v
                END IF
            END IF
 
        BEFORE FIELD buk_type
          CALL i503_set_entry(p_cmd)
 
        AFTER FIELD buk_type
          CALL i503_set_no_entry(p_cmd)
 
        BEFORE FIELD buk_code
           IF g_msr.buk_type!='1' THEN
              LET g_msr.buk_code = NULL
              DISPLAY BY NAME g_msr.buk_code
           END IF
        AFTER FIELD buk_code
         IF g_msr.buk_code IS NOT NULL THEN
           SELECT * FROM rpg_file WHERE rpg01 = g_msr.buk_code
           IF SQLCA.sqlcode THEN
#              CALL cl_err('sel rpg:',STATUS,0)  #No.FUN-660107
               CALL cl_err3("sel","rpg_file",g_msr.buk_code,"",STATUS,"","sel rpg",1)       #NO.FUN-660107
              NEXT FIELD buk_code
           END IF
         END IF
 
        AFTER FIELD msr08
           IF NOT cl_null(g_msr.msr08) THEN
             SELECT COUNT(*) INTO l_n FROM msp_file WHERE msp01 = g_msr.msr08
             IF l_n=0 THEN
               CALL cl_err(g_msr.msr08,100,0)
               NEXT FIELD msr08
             END IF
           END IF
 
     #No.FUN-920183 start -----
        AFTER FIELD lot_type
           IF g_msr.lot_type = '6' THEN
              IF lot_type_t <> g_msr.lot_type THEN
                 LET g_msr.incl_mds = 'Y'
                 LET g_msr.incl_so = 'N'
              END IF
              CALL cl_set_comp_entry("lot_no1,lot_no2",FALSE)
              CALL cl_set_comp_required("lot_no1",FALSE)
              LET g_msr.lot_no1 = ''
              LET g_msr.lot_no2 = ''
              DISPLAY BY NAME g_msr.lot_no1,g_msr.lot_no2
           ELSE
              IF lot_type_t <> g_msr.lot_type THEN
                 LET g_msr.incl_mds = 'N'
                 LET g_msr.incl_so = 'Y'
              END IF
              CALL cl_set_comp_entry("lot_no1,lot_no2",TRUE)
              CALL cl_set_comp_required("lot_no1",TRUE)
           END IF
          #FUN-A80150---add---start---
           IF g_msr.lot_type MATCHES '[89]' THEN
              CALL cl_set_comp_entry("lot_no2",FALSE)
           END IF
          #FUN-A80150---add---end---
           LET lot_type_t = g_msr.lot_type
           DISPLAY BY NAME g_msr.incl_mds,g_msr.incl_so
 
       #FUN-A80150---add---start---
        AFTER FIELD lot_no1
           IF g_msr.lot_type = '8' THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM oea_file,oeb_file 
               WHERE oea01=oeb01 AND oeb01 = lot_no1 AND oebacti = 'Y'
              IF l_cnt = 0 THEN
                 CALL cl_err(g_msr.lot_no1,'amr-029',1)
                 NEXT FIELD lot_no1
              END IF
           END IF
           IF g_msr.lot_type = '9' THEN
              LET l_cnt=0
              SELECT COUNT(*) INTO l_cnt FROM sfb_file
               WHERE sfb919 = lot_no1 AND sfb04 = '2' 
              IF l_cnt = 0 THEN
                 CALL cl_err(g_msr.lot_no1,'amr-030',1)
                 NEXT FIELD lot_no1
              END IF
           END IF
       #FUN-A80150---add---end---

        AFTER FIELD incl_mds
           IF g_msr.incl_mds = 'Y' AND g_msr.incl_so = 'Y' THEN
              CALL cl_err('','amr-101',0)
              LET g_msr.incl_mds = 'N'
              NEXT FIELD incl_mds
           END IF
 
        AFTER FIELD incl_so
           IF g_msr.incl_mds = 'Y' AND g_msr.incl_so = 'Y' THEN
              CALL cl_err('','amr-101',0)
              LET g_msr.incl_so = 'N'
              NEXT FIELD incl_so
           END IF
        AFTER FIELD msr10,msr11
           IF NOT cl_null(g_msr.msr10) AND NOT cl_null(g_msr.msr11) THEN
              SELECT COUNT(*) INTO l_cnt
                FROM vld_file
               WHERE vld01 = g_msr.msr10
                 AND vld02 = g_msr.msr11
              IF l_cnt = 0 THEN
                 CALL cl_err('','amr-102',0)
                 NEXT FIELD msr10
              END IF
           END IF
     #No.FUN-920183 end -------
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD msr_v
            END IF
        #No.FUN-920183 start -----
            IF g_msr.incl_mds = 'Y' AND (cl_null(g_msr.msr10) OR cl_null(g_msr.msr11)) THEN
               CALL cl_err('','amr-103',0)
               NEXT FIELD msr10
            END IF
            IF g_msr.lot_type = '6' AND (cl_null(g_msr.msr10) OR cl_null(g_msr.msr11)) THEN
               CALL cl_err('','amr-103',0)
               NEXT FIELD msr10
            END IF
            IF g_msr.incl_mds = 'Y' THEN
               SELECT vld03,vld04,vld06,vld14
                 INTO l_vld03,l_vld04,l_vld06,l_vld14
                 FROM vld_file
                WHERE vld01 = g_msr.msr10
                  AND vld02 = g_msr.msr11
               IF g_msr.bdate <> l_vld03 THEN
                  CALL cl_err('','amr-104',0)
                  NEXT FIELD bdate
               END IF
               IF g_msr.edate <> l_vld04 THEN
                  CALL cl_err('','amr-104',0)
                  NEXT FIELD edate
               END IF
               IF g_msr.buk_type <> l_vld06 THEN
                  CALL cl_err('','amr-105',0)
                  NEXT FIELD buk_type
               END IF
               IF g_msr.buk_code <> l_vld14 THEN
                  CALL cl_err('','amr-105',0)
                  NEXT FIELD buk_code
               END IF
            END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(msr10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_vld"
                 LET g_qryparam.default1 = g_msr.msr10
                 LET g_qryparam.default2 = g_msr.msr11
                 CALL cl_create_qry() RETURNING g_msr.msr10,g_msr.msr11
                 DISPLAY BY NAME g_msr.msr10,g_msr.msr11
                 NEXT FIELD msr10
              WHEN INFIELD(msr11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_vld"
                 LET g_qryparam.default1 = g_msr.msr11
                 LET g_qryparam.default2 = g_msr.msr11
                 CALL cl_create_qry() RETURNING g_msr.msr10,g_msr.msr11
                 DISPLAY BY NAME g_msr.msr10,g_msr.msr11
                 NEXT FIELD msr11
              WHEN INFIELD(buk_code)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form="q_rpg"
                 LET g_qryparam.default1 = g_msr.buk_code
                 CALL cl_create_qry() RETURNING g_msr.buk_code
                 DISPLAY BY NAME g_msr.buk_code
                 NEXT FIELD buk_code
              OTHERWISE EXIT CASE
           END CASE
        #No.FUN-920183 end -------
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(msr_v) THEN
        #        LET g_msr.* = g_msr_t.*
        #        CALL i503_show()
        #        NEXT FIELD msr_v
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
 
FUNCTION i503_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_msr.* TO NULL              #No.FUN-6B0041
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i503_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i503_count
    FETCH i503_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i503_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open i503_cs:',SQLCA.sqlcode,0)
        INITIALIZE g_msr.* TO NULL
    ELSE
        CALL i503_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i503_fetch(p_flmsr)
    DEFINE
      # p_flmsr          VARCHAR(1),
        p_flmsr         LIKE type_file.chr1,     #No.FUN-680082 VARCHAR(1)
        l_abso          LIKE type_file.num10     #No.FUN-680082 INTEGER
 
    CASE p_flmsr
        WHEN 'N' FETCH NEXT     i503_cs INTO g_msr.msr_v
        WHEN 'P' FETCH PREVIOUS i503_cs INTO g_msr.msr_v
        WHEN 'F' FETCH FIRST    i503_cs INTO g_msr.msr_v
        WHEN 'L' FETCH LAST     i503_cs INTO g_msr.msr_v
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i503_cs INTO g_msr.msr_v
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_msr.msr_v,SQLCA.sqlcode,0)
        INITIALIZE g_msr.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmsr
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_msr.* FROM msr_file            # 重讀DB,因TEMP有不被更新特性
       WHERE msr_v = g_msr.msr_v
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_msr.msr_v,SQLCA.sqlcode,0) #No.FUN-660107
         CALL cl_err3("sel","msr_file",g_msr.msr_v,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
    ELSE
 
        CALL i503_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i503_show()
    LET g_msr_t.* = g_msr.*
    DISPLAY BY NAME
       g_msr.msr_v,g_msr.msr01,g_msr.msr02,g_msr.msr03,g_msr.msr04,g_msr.msr05,
       g_msr.lot_type, g_msr.lot_bm, g_msr.lot_no1, g_msr.lot_no2,
       g_msr.bdate, g_msr.edate,
       g_msr.buk_type,
       g_msr.po_days, g_msr.wo_days,
       g_msr.incl_id, g_msr.incl_so,
       g_msr.incl_mds,g_msr.msr10,g_msr.msr11,   #No.FUN-920183
       g_msr.msb_expl, g_msr.mss_expl,g_msr.msr06,g_msr.msr07,g_msr.msr12,g_msr.msr09,g_msr.msr08,   #FUN-640169 add msr09  #FUN-B20060 add msr12
       g_msr.msr919   #FUN-A90057
       ,g_msr.msr15,g_msr.msr16,g_msr.msr17,g_msr.msr18,g_msr.msr19,g_msr.msr20,g_msr.msr21,g_msr.msr22,g_msr.msr23,g_msr.msr24,g_msr.msr25 #darcy:2024/06/17 add
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i503_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_msr.msr_v IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
  # SELECT * INTO g_msr.* FROM msr_file WHERE msr01=g_msg.msr01 #No.FUN-920183
  # SELECT * INTO g_msr.* FROM msr_file WHERE msr01=g_msr.msr01 #No.FUN-920183   #MOD-BC0225 mark
    SELECT * INTO g_msr.* FROM msr_file WHERE msr_v=g_msr.msr_v #MOD-BC0225  add
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_msr_v_t = g_msr.msr_v
    BEGIN WORK
 
    OPEN i503_cl USING g_msr.msr_v
    IF STATUS THEN
       CALL cl_err("OPEN i503_cl:", STATUS, 1)
       CLOSE i503_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i503_cl INTO g_msr.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i503_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i503_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_msr.*=g_msr_t.*
            CALL i503_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE msr_file SET msr_file.* = g_msr.*    # 更新DB
            WHERE msr_v = g_msr.msr_v             # COLAUTH?
        IF SQLCA.sqlcode THEN
#            CALL cl_err(g_msr.msr_v,SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("upd","msr_file",g_msr_v_t,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i503_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i503_r()
    IF g_msr.msr_v IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i503_cl USING g_msr.msr_v
    IF STATUS THEN
       CALL cl_err("OPEN i503_cl:", STATUS, 1)
       CLOSE i503_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i503_cl INTO g_msr.*
    IF STATUS THEN CALL cl_err('fetch i503_cl:',STATUS,0) RETURN END IF
    CALL i503_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "msr_v"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_msr.msr_v      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       MESSAGE " Delete msr ..."
       DELETE FROM msr_file WHERE msr_v = g_msr.msr_v
       IF STATUS THEN 
#       CALL cl_err('del msr:',STATUS,0)  #No.FUN-660107
        CALL cl_err3("del","msr_file",g_msr.msr_v,"",STATUS,"","del msr:",1)       #NO.FUN-660107
       RETURN END IF
       MESSAGE " Delete mss ..."
       DELETE FROM mss_file WHERE mss_v = g_msr.msr_v
       IF STATUS THEN 
#       CALL cl_err('del mss:',STATUS,0)  #No.FUN-660107
        CALL cl_err3("del","mss_file",g_msr.msr_v,"",STATUS,"","del mss:",1)       #NO.FUN-660107
       RETURN END IF
       MESSAGE " Delete mst ..."
       DELETE FROM mst_file WHERE mst_v = g_msr.msr_v
       IF STATUS THEN 
#       CALL cl_err('del mst:',STATUS,0)  #No.FUN-660107
        CALL cl_err3("del","mst_file",g_msr.msr_v,"",STATUS,"","del mst:",1)       #NO.FUN-660107
       RETURN END IF
       CLEAR FORM
       OPEN i503_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i503_cs
          CLOSE i503_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i503_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i503_cs
          CLOSE i503_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i503_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i503_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i503_fetch('/')
       END IF
 
    END IF
    CLOSE i503_cl
    COMMIT WORK
END FUNCTION
 
#No.FUN-570110   --start
FUNCTION i503_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1       #No.FUN-680082 VARCHAR(1)
 
   IF INFIELD(buk_type) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("buk_code",TRUE)
   END IF
 
   IF p_cmd = 'a' and (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("msr_v",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i503_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1       #No.FUN-680082 VARCHAR(1)
 
   IF INFIELD(buk_type) OR (NOT g_before_input_done) THEN
      IF g_msr.buk_type!='1' THEN
         LET g_msr.buk_code = NULL
         DISPLAY BY NAME g_msr.buk_code
         CALL cl_set_comp_entry("buk_code",FALSE)
      END IF
   END IF
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("msr_v",FALSE)
   END IF
END FUNCTION
#No.FUN-570110   --end
#Patch....NO.TQC-610035 <001> #
