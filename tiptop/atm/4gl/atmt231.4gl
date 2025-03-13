# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmt231.4gl
# Descriptions...: 現金折扣單維護作業
# Date & Author..: 06/01/05 By day
# Modify.........: No.TQC-650111 06/05/25 By day 復制時，已扣金額與已返金額都不可復制
# Modify.........: No.FUN-660104 06/06/19 By cl Error Message 調整
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680120 06/08/31 By chen 類型轉換
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690025 06/09/20 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: Mo.FUN-6A0072 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0043 06/11/14 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: No.TQC-710043 07/01/11 By wujie 隱藏有效碼欄位 
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750022 07/05/10 By sherry 報表打印寬度不對
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7C0076 07/12/07 By wujie   若此現金折扣單已經存在于訂單或者出貨單或者銷退單中，則應不可取消審核
#                                                    若此現金折扣單已經存在于未審核的訂單或者未過賬的出貨單,未過賬的銷退單中，則應不可結案
# Modify.........: No.TQC-7C0108 07/12/10 By wujie   若有對應已經審核的訂單，但是此訂單尚未做出貨單，也不可結案
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-820033 08/03/06 By Judy 增加新功能
# Modify.........: No.FUN-850163 08/06/19 By lilingyu 改成CR報表
#                                08/09/16 By Cockroach CR 21-->31
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980160 09/08/21 By Dido 最大筆變數與資料處理問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990111 09/09/11 By sherry 1、過合同編號的時候作業會當掉 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.TQC-AC0029 10/12/03 By lilingyu 刪除資料時,並未一併刪除tqv_file資料
# Modify.........: No.TQC-AC0035 10/12/16 By lilingyu 根據sop流程,訂單單號欄位改為非必填
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D10114 13/01/24 By Sakura 隱藏非直營KAB(tqw19)欄位
# Modify.........: No:FUN-D20039 13/01/20 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_tqw       RECORD LIKE tqw_file.*,
       g_tqw_t     RECORD LIKE tqw_file.*,  #備份舊值
       g_tqw01_t   LIKE tqw_file.tqw01,     #Key值備份
       g_wc        string,                  #儲存 user 的查詢條件
       g_sql       STRING                  #組 sql 用
#FUN-820033 --begin--
DEFINE g_tqv       DYNAMIC ARRAY OF RECORD
                   tqv02     LIKE tqv_file.tqv02,
                   tqv03     LIKE tqv_file.tqv03,
                   tqv04     LIKE tqv_file.tqv04,
                   tqv04_oaj02  LIKE oaj_file.oaj02,
                   tqv05     LIKE tqv_file.tqv05,
                   tqv06     LIKE tqv_file.tqv06,
                   tqv07     LIKE tqv_file.tqv07 
                   END RECORD
DEFINE g_tqv_t     RECORD
                   tqv02     LIKE tqv_file.tqv02,
                   tqv03     LIKE tqv_file.tqv03,
                   tqv04     LIKE tqv_file.tqv04,
                   tqv04_oaj02  LIKE oaj_file.oaj02,
                   tqv05     LIKE tqv_file.tqv05,
                   tqv06     LIKE tqv_file.tqv06,
                   tqv07     LIKE tqv_file.tqv07 
                   END RECORD
DEFINE i,j,k       LIKE type_file.num5
DEFINE l_ac        LIKE type_file.num5
DEFINE l_allow_insert        LIKE type_file.num5,
       l_allow_delete        LIKE type_file.num5,
       l_allow_update        LIKE type_file.num5
#FUN-820033 --end--
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令        #No.FUN-680120 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose            #No.FUN-680120 SMALLINT
DEFINE g_msg                 LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數                   #No.FUN-680120 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數           #No.FUN-680120 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5         #是否開啟指定筆視窗        #No.FUN-680120 SMALLINT   #No.FUN-6A0072
DEFINE g_t1                  LIKE oay_file.oayslip        #No.FUN-680120 VARCHAR(5)
DEFINE l_chr  LIKE type_file.chr1                         #No.FUN-680120 VARCHAR(1)
DEFINE g_chr2 LIKE type_file.chr1                         #No.FUN-680120 VARCHAR(1)
DEFINE g_chr3 LIKE type_file.chr1                         #No.FUN-680120 VARCHAR(1)
DEFINE g_chr4 LIKE type_file.chr1                         #No.FUN-680120 VARCHAR(1)
DEFINE g_chr5 LIKE type_file.chr1                         #No.FUN-680120 VARCHAR(1)
 
DEFINE l_table               STRING                       #NO.FUN-850163 
DEFINE gg_sql                STRING                       #NO.FUN-850163 
DEFINE g_str                 STRING                       #NO.FUN-850163 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680120 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6B0014
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
    #NO.FUN-850163 --Begin--
   LET gg_sql ="tqw01.tqw_file.tqw01,", 
               "tqw03.tqw_file.tqw03,", 
               "gem02.gem_file.gem02,", 
               "tqw02.tqw_file.tqw02,", 
               "tqw04.tqw_file.tqw04,", 
               "gen02.gen_file.gen02,", 
               "tqw20.tqw_file.tqw20,", 
               "tqw07.tqw_file.tqw07,", 
               "l_desc1.adj_file.adj02,",
               "tqw05.tqw_file.tqw05,",
               "tqw08.tqw_file.tqw08,", 
               "occ02.occ_file.occ02,", 
               "tqw17.tqw_file.tqw17,", 
               "tqw18.tqw_file.tqw18,", 
               "a.tqw_file.tqw07,", 
               "tqw11.tqw_file.tqw11,", 
               "tqw12.tqw_file.tqw12,", 
               "tqw13.tqw_file.tqw13,",
               "tqw14.tqw_file.tqw14,",
               "tqw081.tqw_file.tqw081,",
               "tqw15.tqw_file.tqw15,",
               "azf03.azf_file.azf03,", 
               "b.tqw_file.tqw07,",
               "tqw10.tqw_file.tqw10,",
               "tqw06.tqw_file.tqw06,",
              #"tqw19.tqw_file.tqw19,", #FUN-D10114 mark
               "tqw16.tqw_file.tqw16,",
               "tqw09.tqw_file.tqw09,", 
               "l_desc.adj_file.adj02" 
               
  LET l_table = cl_prt_temptable('atmt231',gg_sql) CLIPPED
  IF  l_table = -1 THEN EXIT PROGRAM END IF 
  LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" #FUN-D10114 delete 1 ?
  PREPARE insert_prep FROM gg_sql 
  IF STATUS THEN 
     CALL cl_err('insert_prep:',STATUS,1)               
     EXIT PROGRAM
  END IF 
  
 #NO.FUN-850163  --End--
   
   INITIALIZE g_tqw.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM tqw_file WHERE tqw01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t231_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW t231_w AT p_row,p_col WITH FORM "atm/42f/atmt231"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
#No.TQC-710043--begin                                                                                                               
   CALL cl_set_comp_visible("tqwacti,tqw19",FALSE) #FUN-D10114 add tqw19                                                                                       
#No.TQC-710043--end  
   LET g_action_choice = ""
   CALL t231_menu()
 
   CLOSE WINDOW t231_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION t231_curs()
DEFINE ls STRING
 
    CLEAR FORM
    INITIALIZE g_tqw.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
       #FUN-820033 --begin--
       #tqw01,tqw02,tqw20,tqw05,tqw17,tqw18,tqw11,tqw15,
       #tqw06,tqw16,tqw09,tqw03,tqw04,tqw07,tqw08,tqw081,tqw19,tqw10,
       #tqwuser,tqwgrup,tqwmodu,tqwdate,tqwacti
        tqw01,tqw02,tqw22,tqw20,tqw21,tqw05,tqw23,tqw17,tqw18,tqw11,tqw15,
        tqw06,tqw16,tqw03,tqw04,tqw07,tqw08,tqw19,tqw10,tqw09,
        tqwuser,tqwgrup,tqwmodu,tqwdate,tqwacti
       #FUN-820033 --end--
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(tqw01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_tqw1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw01
                 NEXT FIELD tqw01
               #FUN-820033 --begin--
               WHEN INFIELD(tqw22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_tqp04"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw22
                 NEXT FIELD tqw22
               WHEN INFIELD(tqw23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_oea03a"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw23
                 NEXT FIELD tqw23
               #FUN-820033 --end--
               WHEN INFIELD(tqw05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_occ3"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw05
                 NEXT FIELD tqw05
               WHEN INFIELD(tqw17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw17
                 NEXT FIELD tqw17
               WHEN INFIELD(tqw11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gec1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw11
                 NEXT FIELD tqw11
               WHEN INFIELD(tqw15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
#                LET g_qryparam.form = "q_tqe2"     #No.FUN-6B0065
                 LET g_qryparam.form = "q_azf2"     #No.FUN-6B0065
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw15
                 NEXT FIELD tqw15
               WHEN INFIELD(tqw06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aad1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw06
                 NEXT FIELD tqw06
               WHEN INFIELD(tqw03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw03
                 NEXT FIELD tqw03
               WHEN INFIELD(tqw04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gen"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw04
                 NEXT FIELD tqw04
               WHEN INFIELD(tqw19)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aee1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tqw19
                 NEXT FIELD tqw19
              OTHERWISE
                 EXIT CASE
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
          CALL cl_qbe_select()
      ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND tqwuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND tqwgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND tqwgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tqwuser', 'tqwgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT tqw01 FROM tqw_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY tqw01"
    PREPARE t231_prepare FROM g_sql
    DECLARE t231_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t231_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM tqw_file WHERE ",g_wc CLIPPED
    PREPARE t231_precount FROM g_sql
    DECLARE t231_count CURSOR FOR t231_precount
END FUNCTION
 
FUNCTION t231_menu()
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(100)
 
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t231_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t231_q()
            END IF
        ON ACTION next
            CALL t231_fetch('N')
        ON ACTION previous
            CALL t231_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t231_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t231_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL t231_copy()
            END IF
        ON ACTION approving
            LET g_action_choice="approving"
            IF cl_chk_act_auth() THEN
                 CALL t231_approving()
            END IF
        ON ACTION unapproving
            LET g_action_choice="unapproving"
            IF cl_chk_act_auth() THEN
                 CALL t231_unapproving()
            END IF
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
                 CALL t231_confirm()
            END IF
        ON ACTION unconfirm
            LET g_action_choice="unconfirm"
            IF cl_chk_act_auth() THEN
                 CALL t231_unconfirm()
            END IF
        ON ACTION close_the_case
            LET g_action_choice="close_the_case"
            IF cl_chk_act_auth() THEN
                 CALL t231_close()
            END IF
        ON ACTION undo_close
            LET g_action_choice="undo_close"
            IF cl_chk_act_auth() THEN
                 CALL t231_unclose()
            END IF
        ON ACTION void
            LET g_action_choice="void"
            IF cl_chk_act_auth() THEN
                 CALL t231_x(1)
            END IF
        #FUN-D20039 ---------------sta
        ON ACTION undo_void
            LET g_action_choice="undo_void"
            IF cl_chk_act_auth() THEN
                 CALL t231_x(2)
            END IF
        #FUN-D20039 ---------------end

        #FUN-820033 --begin--
        ON ACTION discount
            LET g_action_choice="discount"
             IF cl_chk_act_auth() THEN
                CALL t231_g_b()
             END IF
        #FUN-820033 --end--
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                 CALL t231_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t231_fetch('/')
        ON ACTION first
            CALL t231_fetch('F')
        ON ACTION last
            CALL t231_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 	
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_tqw.tqw01 IS NOT NULL THEN
                 LET g_doc.column1 = "tqw01"
                 LET g_doc.value1 = g_tqw.tqw01
                 CALL cl_doc()
              END IF
           END IF
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t231_cs
END FUNCTION
 
FUNCTION t231_a()
 DEFINE li_result LIKE type_file.num5          #No.FUN-680120 SMALLINT
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_tqw.* LIKE tqw_file.*
    LET g_tqw01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tqw.tqwuser = g_user
        LET g_tqw.tqworiu = g_user #FUN-980030
        LET g_tqw.tqworig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_tqw.tqwgrup = g_grup               #使用者所屬群
        LET g_tqw.tqwdate = g_today
        LET g_tqw.tqwacti = 'Y'
        LET g_tqw.tqw10 = '1'
        LET g_tqw.tqw20 = '1'
        LET g_tqw.tqw21 = '1'   #FUN-820033
        LET g_tqw.tqw07 = 1
        LET g_tqw.tqw02 = g_today
        LET g_tqw.tqw08 = 0
        LET g_tqw.tqw081= 0
        CALL t231_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_tqw.* TO NULL
            LET INT_FLAG = 0
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_tqw.tqw01 IS NULL THEN
           CONTINUE WHILE
        END IF
        BEGIN WORK
        #CALL s_auto_assign_no("axm",g_tqw.tqw01,g_tqw.tqw02,"04","tqw_file","tqw01","","","")  #FUN-A70130
        CALL s_auto_assign_no("atm",g_tqw.tqw01,g_tqw.tqw02,"U5","tqw_file","tqw01","","","")  #FUN-A70130
             RETURNING li_result,g_tqw.tqw01                                    
        IF (NOT li_result) THEN                                                 
           CONTINUE WHILE                                                       
        END IF                                                                  
        DISPLAY BY NAME g_tqw.tqw01        
        LET g_tqw.tqwlegal = g_legal #FUN-980009
        LET g_tqw.tqwplant = g_plant #FUN-980009
        INSERT INTO tqw_file VALUES(g_tqw.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("ins","tqw_file",g_tqw.tqw01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CONTINUE WHILE
        ELSE
            SELECT tqw01 INTO g_tqw.tqw01 FROM tqw_file
             WHERE tqw01 = g_tqw.tqw01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
    COMMIT WORK
END FUNCTION
 
FUNCTION t231_i(p_cmd)
   DEFINE li_result   LIKE type_file.num5           #No.FUN-680120 SMALLINT
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_flag    LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            l_input   LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
            a         LIKE tqw_file.tqw07,
            b         LIKE tqw_file.tqw07,
            l_gen02   LIKE gen_file.gen02,
            l_gem02   LIKE gem_file.gem02,
            l_n       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
            g_n       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
            l_n1      LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
   DISPLAY BY NAME
        g_tqw.tqw01,g_tqw.tqw02,g_tqw.tqw03,g_tqw.tqw04,g_tqw.tqw05,
#       g_tqw.tqw06,g_tqw.tqw07,g_tqw.tqw08,g_tqw.tqw081,g_tqw.tqw09,g_tqw.tqw10, #FUN-820033
        g_tqw.tqw06,g_tqw.tqw07,g_tqw.tqw08,g_tqw.tqw09,g_tqw.tqw10,  #FUN-820033
#       g_tqw.tqw11,g_tqw.tqw12,g_tqw.tqw13,g_tqw.tqw14,g_tqw.tqw15,  #FUN-820033
        g_tqw.tqw11,g_tqw.tqw15,    #FUN-820033
        g_tqw.tqw16,g_tqw.tqw17,g_tqw.tqw18,g_tqw.tqw19,g_tqw.tqw20,
        g_tqw.tqw21,g_tqw.tqw22,g_tqw.tqw23,   #FUN-820033
        g_tqw.tqwuser,g_tqw.tqwgrup,
        g_tqw.tqwmodu,g_tqw.tqwdate,g_tqw.tqwacti
 
   INPUT BY NAME g_tqw.tqworiu,g_tqw.tqworig,
        g_tqw.tqw01,g_tqw.tqw02,g_tqw.tqw22,g_tqw.tqw20, #FUN-820033 add tqw22
        g_tqw.tqw21,g_tqw.tqw05,g_tqw.tqw23,  #FUN-820033 add tqw21,tqw23
        g_tqw.tqw17,g_tqw.tqw18,
        g_tqw.tqw11,g_tqw.tqw15,
#       g_tqw.tqw06,g_tqw.tqw16,g_tqw.tqw09,g_tqw.tqw03,g_tqw.tqw04, #FUN-820033
        g_tqw.tqw06,g_tqw.tqw16,g_tqw.tqw03,g_tqw.tqw04, #FUN-820033
        g_tqw.tqw07,g_tqw.tqw08,g_tqw.tqw19,g_tqw.tqw09 #FUN-820033 add tqw08,tqw09
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t231_set_entry(p_cmd)
          CALL t231_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          LET i = 1    #MOD-990111 add     
 
      AFTER FIELD tqw01
         IF NOT cl_null(g_tqw.tqw01) THEN
            IF g_tqw.tqw01 != g_tqw01_t OR g_tqw01_t IS NULL THEN
               #CALL s_check_no("axm",g_tqw.tqw01,"","04","tqw_file","tqw01","") #FUN-A70130
               CALL s_check_no("atm",g_tqw.tqw01,"","U5","tqw_file","tqw01","") #FUN-A70130
                  RETURNING li_result,g_tqw.tqw01
               DISPLAY BY NAME g_tqw.tqw01
               IF (NOT li_result) THEN
                  NEXT FIELD tqw01
               END IF
            END IF
         END IF
     
      #FUN-820033 --begin--
      AFTER FIELD tqw22
         IF NOT cl_null(g_tqw.tqw22) THEN
            SELECT COUNT(*) INTO l_n FROM tqp_file
             WHERE tqp01 = g_tqw.tqw22 AND tqp04 = '3'
            IF l_n = 0 THEN
               CALL cl_err3("sel","tqp_file",g_tqw.tqw22,"",'100',"","",0)
               NEXT FIELD tqw22
            END IF
	 ELSE 				#TQC-980160
            LET g_tqv[i].tqv03 = NULL	#TQC-980160		
         END IF
      #FUN-820033 --end--
 
      AFTER FIELD tqw20
         IF NOT cl_null(g_tqw.tqw20) THEN
            IF g_tqw.tqw20 NOT MATCHES "[1234]" THEN
               NEXT FIELD tqw20
            END IF
           #-TQC-980160-add-
	    IF g_tqw.tqw20 = '3' OR g_tqw.tqw20 = '4' THEN
               LET g_tqv[i].tqv03 = NULL			
            END IF
           #-TQC-980160-end-
         END IF
 
      #FUN-820033 --begin--
      BEFORE FIELD tqw21
          CALL t231_set_entry(p_cmd)
  
      AFTER FIELD tqw21
         CALL t231_set_no_entry(p_cmd)  
      #FUN-820033 --end--
 
      AFTER FIELD tqw05
         IF NOT cl_null(g_tqw.tqw05) THEN
            SELECT * FROM occ_file
             WHERE occ01  = g_tqw.tqw05
               AND occacti= 'Y'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_tqw.tqw05,100,0)   #No.FUN-660104
               CALL cl_err3("sel","occ_file",g_tqw.tqw05,"",100,"","",1)   #No.FUN-660104
 	       LET g_tqw.tqw05 = g_tqw_t.tqw05
               NEXT FIELD tqw05
   	    ELSE
               CALL t231_tqw05('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_tqw.tqw05 = g_tqw_t.tqw05
                  NEXT FIELD tqw05
               END IF
               IF cl_null(g_tqw_t.tqw05) OR 
                  g_tqw.tqw05 != g_tqw_t.tqw05 THEN
                  SELECT occ42,occ41 INTO g_tqw.tqw17,g_tqw.tqw11
                    FROM occ_file
                   WHERE occ01=g_tqw.tqw05
                   CALL t231_tqw11('d')
                   CALL s_curr3(g_tqw.tqw17,g_tqw.tqw02,g_oaz.oaz52)
                        RETURNING g_tqw.tqw18
                  LET g_tqw.tqw04 = g_user
                  LET g_tqw.tqw03 = g_grup
                  DISPLAY BY NAME g_tqw.tqw18,g_tqw.tqw03,g_tqw.tqw04
                  DISPLAY BY NAME g_tqw.tqw17,g_tqw.tqw11
                  SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_user
                  SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_grup
                  DISPLAY l_gen02 TO FORMONLY.gen02
                  DISPLAY l_gem02 TO FORMONLY.gem02
               END IF
    	    END IF
         END IF
 
      #FUN-820033 --begin--
      BEFORE FIELD tqw23
         CALL t231_set_entry(p_cmd)
         CALL t231_set_no_entry(p_cmd)
 
      AFTER FIELD tqw23
#TQC-AC0035 --begin--
#         IF g_tqw.tqw21 != '2' THEN
#            IF cl_null(g_tqw.tqw23) THEN
#               CALL cl_err('','aap-099',0)
#               NEXT FIELD tqw23
#            END IF
#         END IF
#TQC-AC0035 --end--
         IF NOT cl_null(g_tqw.tqw23) THEN
            SELECT COUNT(*) INTO l_n FROM oea_file
             WHERE oea03 = g_tqw.tqw05 AND oeaconf = 'N' AND oea12 = g_tqw.tqw22
            IF l_n = 0 THEN
               CALL cl_err3("sel","oea_file",g_tqw.tqw23,"",'100',"","",0)
               NEXT FIELD tqw23
            END IF
         END IF
      #FUN-820033 --end--
 
      AFTER FIELD tqw17
         IF NOT cl_null(g_tqw.tqw17) THEN
            SELECT * FROM azi_file
             WHERE azi01   = g_tqw.tqw17
               AND aziacti = 'Y'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_tqw.tqw17,100,0)   #No.FUN-660104
               CALL cl_err3("sel","azi_file",g_tqw.tqw17,"",100,"","",1)   #No.FUN-660104
 	       LET g_tqw.tqw17 = g_tqw_t.tqw17
               NEXT FIELD tqw17
            ELSE
               CALL s_curr3(g_tqw.tqw17,g_tqw.tqw02,g_oaz.oaz52)
                    RETURNING g_tqw.tqw18
               DISPLAY BY NAME g_tqw.tqw18
            END IF
         END IF
 
      AFTER FIELD tqw11
         IF NOT cl_null(g_tqw.tqw11) THEN
            SELECT * FROM gec_file
             WHERE gec01  = g_tqw.tqw11
               AND gec011 = '2'   #銷項稅
               AND gecacti= 'Y'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_tqw.tqw11,100,0)   #No.FUN-660104
               CALL cl_err3("sel","gec_file",g_tqw.tqw11,"",100,"","",1)   #No.FUN-660104
 	       LET g_tqw.tqw11 = g_tqw_t.tqw11
               NEXT FIELD tqw11
   	    ELSE
               CALL t231_tqw11('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_tqw.tqw11 = g_tqw_t.tqw11
                  NEXT FIELD tqw11
               END IF
    	    END IF
         END IF
 
      AFTER FIELD tqw15
         IF NOT cl_null(g_tqw.tqw15) THEN
#No.FUN-6B0065 --begin                                                                                                          
#           SELECT * FROM tqe_file
#            WHERE tqe01  = g_tqw.tqw15
#              AND tqe03  = '3'
#              AND tqeacti= 'Y'
            SELECT * FROM azf_file
             WHERE azf01  = g_tqw.tqw15
               AND azf09  = '3'
               AND azfacti= 'Y'
#No.FUN-6B0065 --end
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_tqw.tqw15,100,0)   #No.FUN-660104
#              CALL cl_err3("sel","tqe_file",g_tqw.tqw15,"",100,"","",1)   #No.FUN-660104     #No.FUN-6B0065
               CALL cl_err3("sel","azf_file",g_tqw.tqw15,"",100,"","",1)   #No.FUN-660104     #No.FUN-6B0065
 	       LET g_tqw.tqw15 = g_tqw_t.tqw15
               NEXT FIELD tqw15
   	    ELSE
               CALL t231_tqw15('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_tqw.tqw15 = g_tqw_t.tqw15
                  NEXT FIELD tqw15
               END IF
    	    END IF
         END IF
 
      AFTER FIELD tqw06
         IF NOT cl_null(g_tqw.tqw06) THEN
            SELECT * FROM aad_file
             WHERE aad01  = g_tqw.tqw06
               AND aadacti= 'Y'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_tqw.tqw06,100,0)   #No.FUN-660104
               CALL cl_err3("sel","aad_file",g_tqw.tqw06,"",100,"","",1)   #No.FUN-660104
 	       LET g_tqw.tqw06 = g_tqw_t.tqw06
               NEXT FIELD tqw06
   	    ELSE
               IF g_tqw.tqw06 <> g_tqw_t.tqw06 OR cl_null(g_tqw.tqw16) THEN
                  CALL t231_tqw06('a')
    	          IF NOT cl_null(g_errno)  THEN
	             CALL cl_err('',g_errno,0)
 	             LET g_tqw.tqw06 = g_tqw_t.tqw06
                     NEXT FIELD tqw06
                  END IF
               END IF
    	    END IF
         END IF
 
      AFTER FIELD tqw03
         IF NOT cl_null(g_tqw.tqw03) THEN
            SELECT * FROM gem_file
             WHERE gem01  = g_tqw.tqw03
               AND gemacti= 'Y'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_tqw.tqw03,100,0)   #No.FUN-660104
               CALL cl_err3("sel","gem_file",g_tqw.tqw03,"",100,"","",1)   #No.FUN-660104
 	       LET g_tqw.tqw03 = g_tqw_t.tqw03
               NEXT FIELD tqw03
   	    ELSE
               CALL t231_tqw03('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_tqw.tqw03 = g_tqw_t.tqw03
                  NEXT FIELD tqw03
               END IF
    	    END IF
         END IF
 
      AFTER FIELD tqw04
         IF NOT cl_null(g_tqw.tqw04) THEN
            SELECT * FROM gen_file
             WHERE gen01  = g_tqw.tqw04
               AND genacti= 'Y'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_tqw.tqw04,100,0)   #No.FUN-660104
               CALL cl_err3("sel","gen_file",g_tqw.tqw04,"",100,"","",1)   #No.FUN-660104
 	       LET g_tqw.tqw04 = g_tqw_t.tqw04
               NEXT FIELD tqw04
   	    ELSE
               CALL t231_tqw04('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_tqw.tqw04 = g_tqw_t.tqw04
                  NEXT FIELD tqw04
               END IF
    	    END IF
         END IF
 
     AFTER FIELD tqw07
        IF NOT cl_null(g_tqw.tqw07) THEN
           IF g_tqw.tqw07=0 THEN
              CALL cl_err('','atm-378',1)   #應返金額不可為0
              NEXT FIELD tqw07
           END IF
           LET a = g_tqw.tqw07 - g_tqw.tqw08
           LET b = g_tqw.tqw08 - g_tqw.tqw081
           DISPLAY a TO FORMONLY.a
           DISPLAY b TO FORMONLY.b
        END IF
 
      AFTER FIELD tqw19
         IF NOT cl_null(g_tqw.tqw19) THEN
            SELECT * FROM aee_file
             WHERE aee03   = g_tqw.tqw19
               AND aeeacti = 'Y'
            IF SQLCA.sqlcode = 100 THEN
            #  CALL cl_err(g_tqw.tqw19,100,0)   #No.FUN-660104
               CALL cl_err3("sel","aee_file",g_tqw.tqw19,"",100,"","",1)   #No.FUN-660104
 	       LET g_tqw.tqw19 = g_tqw_t.tqw19
               NEXT FIELD tqw19
            END IF
         END IF
 
      AFTER INPUT
         LET g_tqw.tqwuser = s_get_data_owner("tqw_file") #FUN-C10039
         LET g_tqw.tqwgrup = s_get_data_group("tqw_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_tqw.tqw01 IS NULL THEN
               DISPLAY BY NAME g_tqw.tqw01
               NEXT FIELD tqw01
            END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(tqw01)
                LET g_t1 = s_get_doc_no(g_tqw.tqw01)    
               #CALL q_oay(FALSE,FALSE,g_t1,'04','tqw_file') RETURNING g_t1   #TQC-670008 remark
                CALL q_oay(FALSE,FALSE,g_t1,'U5','ATM') RETURNING g_t1        #TQC-670008    #FUN-A70130
                LET g_tqw.tqw01=g_t1          
                DISPLAY BY NAME g_tqw.tqw01
                NEXT FIELD tqw01
           #FUN-820033 --begin--
           WHEN INFIELD(tqw22)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_tqp04"
              LET g_qryparam.default1 = g_tqw.tqw22
              CALL cl_create_qry() RETURNING g_tqw.tqw22
              DISPLAY BY NAME g_tqw.tqw22
              NEXT FIELD tqw22
           WHEN INFIELD(tqw23)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_oea03a"
              LET g_qryparam.default1 = g_tqw.tqw23
              LET g_qryparam.arg1 = g_tqw.tqw05
              LET g_qryparam.arg2 = g_tqw.tqw22
              CALL cl_create_qry() RETURNING g_tqw.tqw23
              DISPLAY BY NAME g_tqw.tqw23
              NEXT FIELD tqw23
           #FUN-820033 --end--
           WHEN INFIELD(tqw05)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ3"
              LET g_qryparam.default1 = g_tqw.tqw05
              CALL cl_create_qry() RETURNING g_tqw.tqw05
              CALL t231_tqw05('a')
              DISPLAY BY NAME g_tqw.tqw05
              NEXT FIELD tqw05
           WHEN INFIELD(tqw17)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_azi"
              LET g_qryparam.default1 = g_tqw.tqw17
              CALL cl_create_qry() RETURNING g_tqw.tqw17
              DISPLAY BY NAME g_tqw.tqw17
              NEXT FIELD tqw17
           WHEN INFIELD(tqw18)
              CALL s_rate(g_tqw.tqw17,g_tqw.tqw18)
              RETURNING g_tqw.tqw18
              DISPLAY BY NAME g_tqw.tqw18
              NEXT FIELD tqw18
           WHEN INFIELD(tqw11)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gec1"
              LET g_qryparam.default1 = g_tqw.tqw11
              CALL cl_create_qry() RETURNING g_tqw.tqw11
              CALL t231_tqw11('a')
              DISPLAY BY NAME g_tqw.tqw11
              NEXT FIELD tqw11
           WHEN INFIELD(tqw15)
              CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_tqe2"     #No.FUN-6B0065
              LET g_qryparam.form = "q_azf2"     #No.FUN-6B0065
              LET g_qryparam.default1 = g_tqw.tqw15
              CALL cl_create_qry() RETURNING g_tqw.tqw15
              CALL t231_tqw15('a')
              DISPLAY BY NAME g_tqw.tqw15
              NEXT FIELD tqw15
           WHEN INFIELD(tqw06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aad1"
              LET g_qryparam.default1 = g_tqw.tqw06
              CALL cl_create_qry() RETURNING g_tqw.tqw06
              CALL t231_tqw06('a')
              DISPLAY BY NAME g_tqw.tqw06
              NEXT FIELD tqw06
           WHEN INFIELD(tqw03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.default1 = g_tqw.tqw03
              CALL cl_create_qry() RETURNING g_tqw.tqw03
              CALL t231_tqw03('a')
              DISPLAY BY NAME g_tqw.tqw03
              NEXT FIELD tqw03
           WHEN INFIELD(tqw04)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_tqw.tqw04
              CALL cl_create_qry() RETURNING g_tqw.tqw04
              CALL t231_tqw04('a')
              DISPLAY BY NAME g_tqw.tqw04
              NEXT FIELD tqw04
           WHEN INFIELD(tqw19)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_aee1"
              LET g_qryparam.default1 = g_tqw.tqw19
              CALL cl_create_qry() RETURNING g_tqw.tqw19
              DISPLAY BY NAME g_tqw.tqw19
              NEXT FIELD tqw19
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
   END INPUT
END FUNCTION
 
FUNCTION t231_tqw05(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_occ02    LIKE occ_file.occ02,
   l_occ06    LIKE occ_file.occ06,
   l_occ1004  LIKE occ_file.occ1004,
   l_occacti  LIKE occ_file.occacti
 
   LET g_errno=''
   SELECT occ02,occacti,occ1004,occ06
     INTO l_occ02,l_occacti,l_occ1004,l_occ06
     FROM occ_file
    WHERE occ01=g_tqw.tqw05
   CASE
       WHEN SQLCA.sqlcode=100         LET g_errno='anm-027'
                                      LET l_occ02=NULL
       WHEN l_occacti='N'             LET g_errno='9028'
       WHEN l_occacti MATCHES '[PH]'  LET g_errno='9038'     #No.FUN-690023
 
     # WHEN l_occ1004<>'3'            LET g_errno='atm-008'  #No.FUN-690025
       WHEN l_occ1004<>'1'            LET g_errno='atm-008'  #No.FUN-690025
       WHEN l_occ06<>'1'              LET g_errno='atm-009'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_occ02 TO FORMONLY.occ02
   END IF
END FUNCTION
 
FUNCTION t231_tqw11(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_gec04    LIKE gec_file.gec04,
   l_gec05    LIKE gec_file.gec05,
   l_gec07    LIKE gec_file.gec07,
   l_gecacti  LIKE gec_file.gecacti
 
   LET g_errno=''
   SELECT gec04,gec05,gec07,gecacti INTO l_gec04,l_gec05,l_gec07,l_gecacti
     FROM gec_file
    WHERE gec01 = g_tqw.tqw11
      AND gec011= '2'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_gec04=NULL
                                LET l_gec05=NULL
                                LET l_gec07=NULL
       WHEN l_gecacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno) THEN
      LET g_tqw.tqw12=l_gec04
      LET g_tqw.tqw13=l_gec05
      LET g_tqw.tqw14=l_gec07
      DISPLAY BY NAME g_tqw.tqw12,g_tqw.tqw13,g_tqw.tqw14
   END IF
END FUNCTION
 
FUNCTION t231_tqw15(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
#No.FUN-6B0065 --begin                                                                                                          
#  l_tqe02    LIKE tqe_file.tqe02,
#  l_tqeacti  LIKE tqe_file.tqeacti
   l_azf03    LIKE azf_file.azf03,
   l_azfacti  LIKE azf_file.azfacti
#No.FUN-6B0065 --end
 
   LET g_errno=''
#No.FUN-6B0065 --begin                                                                                                          
#  SELECT tqe02,tqeacti INTO l_tqe02,l_tqeacti
#    FROM tqe_file
#   WHERE tqe01=g_tqw.tqw15
   SELECT azf03,azfacti INTO l_azf03,l_azfacti
     FROM azf_file
    WHERE azf01=g_tqw.tqw15
#No.FUN-6B0065 --end
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
#                               LET l_tqe02=NULL     #No.FUN-6B0065
                                LET l_azf03=NULL     #No.FUN-6B0065
#      WHEN l_tqeacti='N'       LET g_errno='9028'     #No.FUN-6B0065
       WHEN l_azfacti='N'       LET g_errno='9028'     #No.FUN-6B0065
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
#     DISPLAY l_tqe02 TO FORMONLY.tqe02     #No.FUN-6B0065
      DISPLAY l_azf03 TO FORMONLY.azf03     #No.FUN-6B0065
   END IF
END FUNCTION
 
FUNCTION t231_tqw06(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_aad02    LIKE aad_file.aad02,
   l_aadacti  LIKE aad_file.aadacti
 
   LET g_errno=''
   SELECT aad02,aadacti INTO l_aad02,l_aadacti
     FROM aad_file
    WHERE aad01=g_tqw.tqw06
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_aad02=NULL
       WHEN l_aadacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      LET g_tqw.tqw16=l_aad02
   END IF
END FUNCTION
 
FUNCTION t231_tqw03(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_gem02    LIKE gem_file.gem02,
   l_gemacti  LIKE gem_file.gemacti
 
   LET g_errno=''
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01=g_tqw.tqw03
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_gem02=NULL
       WHEN l_gemacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
FUNCTION t231_tqw04(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
   l_gen02    LIKE gen_file.gen02,
   l_genacti  LIKE gen_file.genacti
 
   LET g_errno=''
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01=g_tqw.tqw04
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='anm-027'
                                LET l_gen02=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno) THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
 
 
FUNCTION t231_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_tqw.* TO NULL            #No.FUN-6B0043
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t231_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_tqw.tqw01 = NULL   #MOD-660086 add
       CLEAR FORM
       RETURN
    END IF
    OPEN t231_count
    FETCH t231_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t231_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
        INITIALIZE g_tqw.* TO NULL
    ELSE
        CALL t231_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t231_fetch(p_fltqw)
    DEFINE
        p_fltqw          LIKE type_file.chr1             #No.FUN-680120 VARCHAR(1)
 
    CASE p_fltqw
        WHEN 'N' FETCH NEXT     t231_cs INTO g_tqw.tqw01
        WHEN 'P' FETCH PREVIOUS t231_cs INTO g_tqw.tqw01
        WHEN 'F' FETCH FIRST    t231_cs INTO g_tqw.tqw01
        WHEN 'L' FETCH LAST     t231_cs INTO g_tqw.tqw01
        WHEN '/'
            IF (NOT mi_no_ask) THEN  #No.FUN-6A0072
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about
                     CALL cl_about()
 
                  ON ACTION help
                     CALL cl_show_help()
 
                  ON ACTION controlg
                     CALL cl_cmdask()
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t231_cs INTO g_tqw.tqw01
            LET mi_no_ask = FALSE   #No.FUN-6A0072
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
        INITIALIZE g_tqw.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_fltqw
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_tqw.* FROM tqw_file    # 重讀DB,因EMP有不被更新特性
       WHERE tqw01 = g_tqw.tqw01
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)   #No.FUN-660104
        CALL cl_err3("sel","tqw_file",g_tqw.tqw01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
    ELSE
        LET g_data_owner=g_tqw.tqwuser
        LET g_data_group=g_tqw.tqwgrup
        LET g_data_plant = g_tqw.tqwplant #FUN-980030
        CALL t231_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t231_show()
    DEFINE a              LIKE tqw_file.tqw07
    DEFINE b              LIKE tqw_file.tqw07
 
    LET g_tqw_t.* = g_tqw.*
    DISPLAY BY NAME g_tqw.tqworiu,g_tqw.tqworig,
        g_tqw.tqw01,g_tqw.tqw02,g_tqw.tqw03,g_tqw.tqw04,g_tqw.tqw05,
#       g_tqw.tqw06,g_tqw.tqw07,g_tqw.tqw08,g_tqw.tqw081,g_tqw.tqw09,g_tqw.tqw10, #FUN-820033
        g_tqw.tqw06,g_tqw.tqw07,g_tqw.tqw08,g_tqw.tqw09,g_tqw.tqw10, #FUN-820033
#       g_tqw.tqw11,g_tqw.tqw12,g_tqw.tqw13,g_tqw.tqw14,g_tqw.tqw15, #FUN-820033
        g_tqw.tqw11,g_tqw.tqw15,      #FUN-820033
        g_tqw.tqw16,g_tqw.tqw17,g_tqw.tqw18,g_tqw.tqw19,g_tqw.tqw20,
        g_tqw.tqw21,g_tqw.tqw22,g_tqw.tqw23,   #FUN-820033
        g_tqw.tqwuser,g_tqw.tqwgrup,
        g_tqw.tqwmodu,g_tqw.tqwdate,g_tqw.tqwacti
    LET a = g_tqw.tqw07 - g_tqw.tqw08
    LET b = g_tqw.tqw08 - g_tqw.tqw081
    DISPLAY a TO FORMONLY.a
    DISPLAY b TO FORMONLY.b
 
    CALL t231_tqw05('d')
    CALL t231_tqw11('d')
    CALL t231_tqw15('d')
    CALL t231_tqw03('d')
    CALL t231_tqw04('d')
 
    LET g_chr2= 'N'                                                             
    LET g_chr3= 'N'                                                             
    LET g_chr4= 'N'                                                             
    LET g_chr5= 'N'                                                             
    CASE g_tqw.tqw10                                                            
       WHEN '2' LET g_chr2= 'Y'                                                 
       WHEN '3' LET g_chr3= 'Y'                                                 
       WHEN '4' LET g_chr4= 'Y'                                                 
       WHEN '5' LET g_chr5= 'Y'                                                 
    END CASE                             
    CALL cl_set_field_pic1(g_chr3,"","",g_chr4,g_chr5,"",g_chr2,"") 
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t231_u()
    IF g_tqw.tqw01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_tqw.tqw10 = '5' THEN
        CALL cl_err('',9022,0)
        RETURN
    END IF
    IF g_tqw.tqw10 != '1' THEN
        CALL cl_err('','atm-226',1)
        RETURN
    END IF
 
    SELECT * INTO g_tqw.* FROM tqw_file
     WHERE tqw01 = g_tqw.tqw01
    IF g_tqw.tqwacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tqw01_t = g_tqw.tqw01
    BEGIN WORK
 
    OPEN t231_cl USING g_tqw.tqw01
    IF STATUS THEN
       CALL cl_err("OPEN t231_cl:", STATUS, 1)
       CLOSE t231_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t231_cl INTO g_tqw.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_tqw.tqwmodu=g_user                  #修改者
    LET g_tqw.tqwdate=g_today                 #修改日期
    CALL t231_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t231_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tqw.*=g_tqw_t.*
            CALL t231_show()
            EXIT WHILE
        END IF
        UPDATE tqw_file SET tqw_file.* = g_tqw.*    # 更新DB
            WHERE tqw01 = g_tqw01_t
        IF SQLCA.sqlcode THEN
        #   CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("upd","tqw_file",g_tqw.tqw01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t231_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t231_r()
    IF g_tqw.tqw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_tqw.tqw10 = '5' THEN
        CALL cl_err('',9021,0)
        RETURN
    END IF
    IF g_tqw.tqw10 != '1' THEN
        CALL cl_err('','atm-226',1)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t231_cl USING g_tqw.tqw01
    IF STATUS THEN
       CALL cl_err("OPEN t231_cl:", STATUS, 0)
       CLOSE t231_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t231_cl INTO g_tqw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t231_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tqw01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tqw.tqw01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM tqw_file
        WHERE tqw01 = g_tqw.tqw01

#TQC-AC0029 --begin--
       DELETE FROM tqv_file
        WHERE tqv01 = g_tqw.tqw01
#TQC-AC0029 --end--
        
       CLEAR FORM
       OPEN t231_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t231_cs
          CLOSE t231_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t231_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t231_cs
          CLOSE t231_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t231_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t231_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE   #No.FUN-6A0072
          CALL t231_fetch('/')
       END IF
    END IF
    CLOSE t231_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t231_out()
    DEFINE
        l_tqw           RECORD LIKE tqw_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)               # External(Disk) file name
        sr              RECORD
                        tqw        RECORD LIKE tqw_file.*,
                        a          LIKE tqw_file.tqw07,
                        b          LIKE tqw_file.tqw07,
                        occ02      LIKE occ_file.occ02,
#                       tqe02      LIKE tqe_file.tqe02,     #No.FUN-6B0065
                        azf03      LIKE azf_file.azf03,     #No.FUN-6B0065
                        gem02      LIKE gem_file.gem02,
                        gen02      LIKE gen_file.gen02
                        END RECORD
 
    DEFINE l_desc1      LIKE   adj_file.adj02      #NO.FUN-850163
    DEFINE l_desc       LIKE   adj_file.adj02      #NO.FUN-850163
    DEFINE l_a          LIKE   tqw_file.tqw07      #NO.FUN-850163
    DEFINE l_b          LIKE   tqw_file.tqw07      #NO.FUN-850163                        
                        
    IF cl_null(g_wc) THEN
       LET g_wc=" tqw01='",g_tqw.tqw01,"'"
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'atmt231'
 
    LET g_sql="SELECT tqw_file.*,'','','','','','' ",
              "  FROM tqw_file ",
              " WHERE ",g_wc CLIPPED
 
    PREPARE t231_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t231_co                         # CURSOR
        CURSOR FOR t231_p1
 
#    CALL cl_outnam('atmt231') RETURNING l_name   #NO.FUN-850163
    LET g_len = 80
#    START REPORT t231_rep TO l_name              #NO.FUN-850163
 
    FOREACH t231_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        SELECT occ02 INTO sr.occ02 FROM occ_file
         WHERE occ01 = sr.tqw.tqw05
#No.FUN-6B0065 --begin                                                                                                          
#       SELECT tqe02 INTO sr.tqe02 FROM tqe_file
#        WHERE tqe01 = sr.tqw.tqw15
        SELECT azf03 INTO sr.azf03 FROM azf_file
         WHERE azf01 = sr.tqw.tqw15
#No.FUN-6B0065 --end
        SELECT gem02 INTO sr.gem02 FROM gem_file
         WHERE gem01 = sr.tqw.tqw03
        SELECT gen02 INTO sr.gen02 FROM gen_file
         WHERE gen01 = sr.tqw.tqw04
        LET sr.a = sr.tqw.tqw07 - sr.tqw.tqw08
        LET sr.b = sr.tqw.tqw08 - sr.tqw.tqw081
#NO.FUN-850163  --Begin--
#        OUTPUT TO REPORT t231_rep(sr.*)
       CASE sr.tqw.tqw20
                WHEN '1' CALL cl_getmsg('atm-075',g_lang) RETURNING l_desc1
                WHEN '2' CALL cl_getmsg('atm-076',g_lang) RETURNING l_desc1
                WHEN '3' CALL cl_getmsg('atm-077',g_lang) RETURNING l_desc1
                WHEN '4' CALL cl_getmsg('atm-078',g_lang) RETURNING l_desc1
           END CASE
      CASE sr.tqw.tqw10
                WHEN '1' CALL cl_getmsg('aem-010',g_lang) RETURNING l_desc
                WHEN '2' CALL cl_getmsg('afa-067',g_lang) RETURNING l_desc
                WHEN '3' CALL cl_getmsg('atm-006',g_lang) RETURNING l_desc
                WHEN '4' CALL cl_getmsg('asf-852',g_lang) RETURNING l_desc
                WHEN '5' CALL cl_getmsg('mfg3217',g_lang) RETURNING l_desc
           END CASE
      EXECUTE insert_prep USING 
              sr.tqw.tqw01,sr.tqw.tqw03,sr.gem02,sr.tqw.tqw02,sr.tqw.tqw04,sr.gen02,
              sr.tqw.tqw20,sr.tqw.tqw07,l_desc1 ,sr.tqw.tqw05,sr.tqw.tqw08,sr.occ02,
              sr.tqw.tqw17,sr.tqw.tqw18,sr.a    ,sr.tqw.tqw11,sr.tqw.tqw12,sr.tqw.tqw13,
              sr.tqw.tqw14,sr.tqw.tqw081,sr.tqw.tqw15,sr.azf03,sr.b,sr.tqw.tqw10,sr.tqw.tqw06,
             #sr.tqw.tqw19,sr.tqw.tqw16,sr.tqw.tqw09,l_desc    #FUN-D10114 mark                
              sr.tqw.tqw16,sr.tqw.tqw09,l_desc                 #FUN-D10114 add   
           
       
     #NO.FUN-850163  --End--
    END FOREACH
#NO.FUN-850163  --Begin--
#    FINISH REPORT t231_rep
 
#    CLOSE t231_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
   LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
   
   IF g_zz05 = 'Y' THEN 
      CALL cl_wcchp(g_wc,'tqw01,tqw02,tqw22,tqw20,tqw21,tqw05,tqw23,tqw17,
                          tqw18,tqw11,tqw15,tqw06,tqw16,tqw03,tqw04,tqw07,
                          tqw08,tqw19,tqw10,tqw09,tqwuser,tqwgrup,tqwmodu,
                          tqwdate,tqwacti')
 
        RETURNING g_wc
   ELSE
   	   LET g_wc = ""
   END IF 
   
   LET g_str = g_wc
   
   CALL cl_prt_cs3('atmt231','atmt231',gg_sql,g_str)
 #NO.FUN-850163  --End--    
END FUNCTION
 
#NO.FUN-850163  --Begin--
#REPORT t231_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#       l_desc          LIKE adj_file.adj02,             #No.FUN-680120 VARCHAR(20)
#       l_desc1         LIKE adj_file.adj02,             #No.FUN-680120 VARCHAR(20)
#       sr              RECORD
#                       tqw        RECORD LIKE tqw_file.*,
#                       a          LIKE tqw_file.tqw07,
#                       b          LIKE tqw_file.tqw07,
#                       occ02      LIKE occ_file.occ02,
##                       tqe02      LIKE tqe_file.tqe02,     #No.FUN-6B0065
#                       azf03      LIKE azf_file.azf03,     #No.FUN-6B0065
#                       gem02      LIKE gem_file.gem02,
#                       gen02      LIKE gen_file.gen02
#                       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.tqw.tqw01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-10),'FROM:',g_user CLIPPED    #No.TQC-750022
#           PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           PRINT ' '
#           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#               COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#           PRINT ' '
#           PRINT "================================================================================"     #No.TQC-750022
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#          CASE sr.tqw.tqw20
#               WHEN '1' CALL cl_getmsg('atm-075',g_lang) RETURNING l_desc1
#               WHEN '2' CALL cl_getmsg('atm-076',g_lang) RETURNING l_desc1
#               WHEN '3' CALL cl_getmsg('atm-077',g_lang) RETURNING l_desc1
#               WHEN '4' CALL cl_getmsg('atm-078',g_lang) RETURNING l_desc1
#          END CASE
#          PRINT COLUMN 01,g_x[11] CLIPPED,sr.tqw.tqw01 CLIPPED,
#                COLUMN 40,g_x[12] CLIPPED,sr.tqw.tqw03 CLIPPED,' ',sr.gem02 CLIPPED
#          PRINT COLUMN 01,g_x[13] CLIPPED,sr.tqw.tqw02 CLIPPED,
#                COLUMN 40,g_x[14] CLIPPED,sr.tqw.tqw04 CLIPPED,' ',sr.gen02 CLIPPED
#          PRINT COLUMN 01,g_x[28] CLIPPED,sr.tqw.tqw20 CLIPPED,' ',l_desc1 CLIPPED,
#                COLUMN 40,g_x[16] CLIPPED,sr.tqw.tqw07
#          PRINT COLUMN 01,g_x[15] CLIPPED,sr.tqw.tqw05 CLIPPED,' ',sr.occ02 CLIPPED,
#                COLUMN 40,g_x[18] CLIPPED,sr.tqw.tqw08
#          PRINT COLUMN 01,g_x[17] CLIPPED,sr.tqw.tqw17 CLIPPED,' ',sr.tqw.tqw18 CLIPPED,
#                COLUMN 40,g_x[20] CLIPPED,sr.a
#          PRINT COLUMN 01,g_x[19] CLIPPED,sr.tqw.tqw11 CLIPPED,' ',sr.tqw.tqw12 CLIPPED,
#                '%  ',sr.tqw.tqw13 CLIPPED,' ',sr.tqw.tqw14 CLIPPED,
#                COLUMN 40,g_x[22] CLIPPED,sr.tqw.tqw081
##          PRINT COLUMN 01,g_x[21] CLIPPED,sr.tqw.tqw15 CLIPPED,' ',sr.tqe02 CLIPPED,     #No.FUN-6B0065
#          PRINT COLUMN 01,g_x[21] CLIPPED,sr.tqw.tqw15 CLIPPED,' ',sr.azf03 CLIPPED,     #No.FUN-6B0065
#                COLUMN 40,g_x[24] CLIPPED,sr.b
#          CASE sr.tqw.tqw10
#               WHEN '1' CALL cl_getmsg('aem-010',g_lang) RETURNING l_desc
#               WHEN '2' CALL cl_getmsg('afa-067',g_lang) RETURNING l_desc
#               WHEN '3' CALL cl_getmsg('atm-006',g_lang) RETURNING l_desc
#               WHEN '4' CALL cl_getmsg('asf-852',g_lang) RETURNING l_desc
#               WHEN '5' CALL cl_getmsg('mfg3217',g_lang) RETURNING l_desc
#          END CASE
#          PRINT COLUMN 01,g_x[23] CLIPPED,sr.tqw.tqw10 CLIPPED,' ',l_desc CLIPPED,
#                COLUMN 40,g_x[26] CLIPPED,sr.tqw.tqw19 CLIPPED
#          PRINT COLUMN 01,g_x[25] CLIPPED,sr.tqw.tqw06 CLIPPED,' ',sr.tqw.tqw16 CLIPPED
#          PRINT COLUMN 01,g_x[27] CLIPPED,sr.tqw.tqw09 CLIPPED
#          SKIP TO TOP OF PAGE
 
#END REPORT
#NO.FUN-850163  --End--
 
 
FUNCTION t231_approving()
DEFINE l_n        LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqw.tqw01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqw.* FROM tqw_file WHERE tqw01=g_tqw.tqw01
    IF g_tqw.tqw10='5' THEN
       CALL cl_err(g_tqw.tqw01,9024,0)
       RETURN
    END IF
    IF g_tqw.tqw10!='1' THEN   #不在開立狀態，不可申請審核!
       CALL cl_err('','atm-221',1)
       RETURN
    END IF
    IF NOT cl_confirm('atm-232') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t231_cl USING g_tqw.tqw01
    IF STATUS THEN
       CALL cl_err("OPEN t231_cl:", STATUS, 1)
       CLOSE t231_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t231_cl INTO g_tqw.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
        CLOSE t231_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE tqw_file SET tqw10='2'
     WHERE tqw01 = g_tqw.tqw01
    IF STATUS THEN
    #  CALL cl_err('upd tqw10',STATUS,0)   #No.FUN-660104
       CALL cl_err3("upd","tqw_file",g_tqw.tqw01,"",STATUS,"","upd tqw10",1)   #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tqw10 INTO g_tqw.tqw10 FROM tqw_file
     WHERE tqw01 = g_tqw.tqw01
    DISPLAY BY NAME g_tqw.tqw10
    LET g_chr2= 'N'                                                             
    LET g_chr3= 'N'                                                             
    LET g_chr4= 'N'                                                             
    LET g_chr5= 'N'                                                             
    CASE g_tqw.tqw10                                                            
       WHEN '2' LET g_chr2= 'Y'                                                 
       WHEN '3' LET g_chr3= 'Y'                                                 
       WHEN '4' LET g_chr4= 'Y'                                                 
       WHEN '5' LET g_chr5= 'Y'                                                 
    END CASE                             
    CALL cl_set_field_pic1(g_chr3,"","",g_chr4,g_chr5,"",g_chr2,"") 
 
END FUNCTION
 
FUNCTION t231_unapproving()
DEFINE l_n LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqw.tqw01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqw.* FROM tqw_file WHERE tqw01=g_tqw.tqw01
    IF g_tqw.tqw10='5' THEN
       CALL cl_err(g_tqw.tqw01,9024,0)
       RETURN
    END IF
    IF g_tqw.tqw10!='2' THEN
       CALL cl_err('','atm-231',1)  #不在已申請狀態，不可取消申請！
       RETURN
    END IF
    IF NOT cl_confirm('atm-233') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
        OPEN t231_cl USING g_tqw.tqw01
        IF STATUS THEN
           CALL cl_err("OPEN t231_cl:", STATUS, 1)
           CLOSE t231_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t231_cl INTO g_tqw.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
            CLOSE t231_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE tqw_file SET tqw10='1'
            WHERE tqw01 = g_tqw.tqw01
        IF STATUS THEN
        #   CALL cl_err('upd tqw10',STATUS,0)   #No.FUN-660104
            CALL cl_err3("upd","tqw_file",g_tqw.tqw01,"",STATUS,"","upd tqw10",1)   #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT tqw10 INTO g_tqw.tqw10 FROM tqw_file
            WHERE tqw01 = g_tqw.tqw01
        DISPLAY BY NAME g_tqw.tqw10
        LET g_chr2= 'N'                                                             
        LET g_chr3= 'N'                                                             
        LET g_chr4= 'N'                                                             
        LET g_chr5= 'N'                                                             
        CASE g_tqw.tqw10                                                            
           WHEN '2' LET g_chr2= 'Y'                                                 
           WHEN '3' LET g_chr3= 'Y'                                                 
           WHEN '4' LET g_chr4= 'Y'                                                 
           WHEN '5' LET g_chr5= 'Y'                                                 
        END CASE                             
        CALL cl_set_field_pic1(g_chr3,"","",g_chr4,g_chr5,"",g_chr2,"") 
END FUNCTION
 
FUNCTION t231_confirm()
DEFINE l_n        LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqw.tqw01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqw.* FROM tqw_file WHERE tqw01=g_tqw.tqw01
    IF g_tqw.tqw10='5' THEN
       CALL cl_err(g_tqw.tqw01,9024,0)
       RETURN
    END IF
    IF g_tqw.tqw10!='2' THEN   #不在申請狀態，不可審核!
       CALL cl_err('','atm-227',1)
       RETURN
    END IF
    IF NOT cl_confirm('aap-222') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t231_cl USING g_tqw.tqw01
    IF STATUS THEN
       CALL cl_err("OPEN t231_cl:", STATUS, 1)
       CLOSE t231_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t231_cl INTO g_tqw.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
        CLOSE t231_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE tqw_file SET tqw10='3'
     WHERE tqw01 = g_tqw.tqw01
    IF STATUS THEN
    #  CALL cl_err('upd tqw10',STATUS,0)   #No.FUN-660104
       CALL cl_err3("upd","tqw_file",g_tqw.tqw01,"",STATUS,"","upd tqw10",1)   #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tqw10 INTO g_tqw.tqw10 FROM tqw_file
     WHERE tqw01 = g_tqw.tqw01
    DISPLAY BY NAME g_tqw.tqw10
    LET g_chr2= 'N'                                                             
    LET g_chr3= 'N'                                                             
    LET g_chr4= 'N'                                                             
    LET g_chr5= 'N'                                                             
    CASE g_tqw.tqw10                                                            
       WHEN '2' LET g_chr2= 'Y'                                                 
       WHEN '3' LET g_chr3= 'Y'                                                 
       WHEN '4' LET g_chr4= 'Y'                                                 
       WHEN '5' LET g_chr5= 'Y'                                                 
    END CASE                             
    CALL cl_set_field_pic1(g_chr3,"","",g_chr4,g_chr5,"",g_chr2,"") 
 
END FUNCTION
 
FUNCTION t231_unconfirm()
DEFINE l_n LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
#No.TQC-7C0076  --begin
    SELECT COUNT(*) INTO l_n FROM oga_file,ogb_file WHERE ogb1007 =g_tqw.tqw01 AND oga01 =ogb01 AND oga55 <>'9'
    IF l_n > 0 THEN CALL cl_err(g_tqw.tqw01,'atm-565',1) RETURN END IF       
    SELECT COUNT(*) INTO l_n FROM oea_file,oeb_file WHERE oeb1007 =g_tqw.tqw01 AND oea01 =oeb01 
    IF l_n > 0 THEN CALL cl_err(g_tqw.tqw01,'atm-565',1) RETURN END IF      
    SELECT COUNT(*) INTO l_n FROM oha_file,ohb_file WHERE ohb1007 =g_tqw.tqw01 AND oha01 =ohb01 AND oha55 <>'9'
    IF l_n > 0 THEN CALL cl_err(g_tqw.tqw01,'atm-565',1) RETURN END IF
#No.TQC-7C0076  --end
    IF g_tqw.tqw01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqw.* FROM tqw_file WHERE tqw01=g_tqw.tqw01
    IF g_tqw.tqw10='5' THEN
       CALL cl_err(g_tqw.tqw01,9024,0)
       RETURN
    END IF
    IF g_tqw.tqw10!='3' THEN
       CALL cl_err('','9025',1)  #不在已審核狀態，不可取消審核！
       RETURN
    END IF
    IF NOT cl_confirm('aap-224') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
        OPEN t231_cl USING g_tqw.tqw01
        IF STATUS THEN
           CALL cl_err("OPEN t231_cl:", STATUS, 1)
           CLOSE t231_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t231_cl INTO g_tqw.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
            CLOSE t231_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE tqw_file SET tqw10='2'
            WHERE tqw01 = g_tqw.tqw01
        IF STATUS THEN
        #   CALL cl_err('upd tqw10',STATUS,0)   #No.FUN-660104
            CALL cl_err3("upd","tqw_file",g_tqw.tqw01,"",STATUS,"","upd tqw10",1)   #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT tqw10 INTO g_tqw.tqw10 FROM tqw_file
            WHERE tqw01 = g_tqw.tqw01
        DISPLAY BY NAME g_tqw.tqw10
        LET g_chr2= 'N'                                                             
        LET g_chr3= 'N'                                                             
        LET g_chr4= 'N'                                                             
        LET g_chr5= 'N'                                                             
        CASE g_tqw.tqw10                                                            
           WHEN '2' LET g_chr2= 'Y'                                                 
           WHEN '3' LET g_chr3= 'Y'                                                 
           WHEN '4' LET g_chr4= 'Y'                                                 
           WHEN '5' LET g_chr5= 'Y'                                                 
        END CASE                             
        CALL cl_set_field_pic1(g_chr3,"","",g_chr4,g_chr5,"",g_chr2,"") 
END FUNCTION
 
FUNCTION t231_close()
DEFINE l_n        LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqw.tqw01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqw.* FROM tqw_file WHERE tqw01=g_tqw.tqw01
#No.TQC-7C0076  --begin
    SELECT COUNT(*) INTO l_n FROM oga_file,ogb_file WHERE ogb1007 =g_tqw.tqw01 AND oga01 =ogb01 AND ogapost ='N'
    IF l_n > 0 THEN CALL cl_err(g_tqw.tqw01,'atm-567',1) RETURN END IF       
    SELECT COUNT(*) INTO l_n FROM oea_file,oeb_file WHERE oeb1007 =g_tqw.tqw01 AND oea01 =oeb01 AND oea49 ='0'
    IF l_n > 0 THEN CALL cl_err(g_tqw.tqw01,'atm-566',1) RETURN END IF      
    SELECT COUNT(*) INTO l_n FROM oha_file,ohb_file WHERE ohb1007 =g_tqw.tqw01 AND oha01 =ohb01 AND ohapost ='N'
    IF l_n > 0 THEN CALL cl_err(g_tqw.tqw01,'atm-568',1) RETURN END IF
#No.TQC-7C0108 --begin
    SELECT COUNT(ogb31) INTO l_n FROM ogb_file,oea_file,oeb_file
     WHERE oeb1007 =g_tqw.tqw01 AND oea01 =oeb01 AND oea49 ='1' 
       AND oea01 <>ogb31 
    IF l_n > 0 THEN CALL cl_err(g_tqw.tqw01,'atm-570',1) RETURN END IF      
#No.TQC-7C0108 --end
#No.TQC-7C0076  --end
    IF g_tqw.tqw10='5' THEN
       CALL cl_err(g_tqw.tqw01,9024,0)
       RETURN
    END IF
    IF g_tqw.tqw10!='3' THEN
       CALL cl_err('','9026',1) #不在審核狀態，不可結案!
       RETURN
    END IF
    IF NOT cl_confirm('lib-003') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t231_cl USING g_tqw.tqw01
    IF STATUS THEN
       CALL cl_err("OPEN t231_cl:", STATUS, 1)
       CLOSE t231_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t231_cl INTO g_tqw.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
        CLOSE t231_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE tqw_file SET tqw10='4'
     WHERE tqw01 = g_tqw.tqw01
    IF STATUS THEN
    #  CALL cl_err('upd tqw10',STATUS,0)   #No.FUN-660104
       CALL cl_err3("upd","tqw_file",g_tqw.tqw01,"",STATUS,"","upd tqw10",1)   #No.FUN-660104
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT tqw10 INTO g_tqw.tqw10 FROM tqw_file
     WHERE tqw01 = g_tqw.tqw01
    DISPLAY BY NAME g_tqw.tqw10
    LET g_chr2= 'N'                                                             
    LET g_chr3= 'N'                                                             
    LET g_chr4= 'N'                                                             
    LET g_chr5= 'N'                                                             
    CASE g_tqw.tqw10                                                            
       WHEN '2' LET g_chr2= 'Y'                                                 
       WHEN '3' LET g_chr3= 'Y'                                                 
       WHEN '4' LET g_chr4= 'Y'                                                 
       WHEN '5' LET g_chr5= 'Y'                                                 
    END CASE                             
    CALL cl_set_field_pic1(g_chr3,"","",g_chr4,g_chr5,"",g_chr2,"") 
 
END FUNCTION
 
FUNCTION t231_unclose()
DEFINE l_n LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
    IF g_tqw.tqw01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tqw.* FROM tqw_file WHERE tqw01=g_tqw.tqw01
    IF g_tqw.tqw10='5' THEN
       CALL cl_err(g_tqw.tqw01,9024,0)
       RETURN
    END IF
    IF g_tqw.tqw10!='4' THEN
       CALL cl_err('','atm-005',1)  #不在結案狀態，不可撤銷結案!
       RETURN
    END IF
    IF NOT cl_confirm('lib-004') THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
        OPEN t231_cl USING g_tqw.tqw01
        IF STATUS THEN
           CALL cl_err("OPEN t231_cl:", STATUS, 1)
           CLOSE t231_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t231_cl INTO g_tqw.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
            CLOSE t231_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE tqw_file SET tqw10='3'
            WHERE tqw01 = g_tqw.tqw01
        IF STATUS THEN
        #   CALL cl_err('upd tqw10',STATUS,0)   #No.FUN-660104
            CALL cl_err3("upd","tqw_file",g_tqw.tqw01,"",STATUS,"","upd tqw10",1)   #No.FUN-660104
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT tqw10 INTO g_tqw.tqw10 FROM tqw_file
            WHERE tqw01 = g_tqw.tqw01
        DISPLAY BY NAME g_tqw.tqw10
        LET g_chr2= 'N'                                                             
        LET g_chr3= 'N'                                                             
        LET g_chr4= 'N'                                                             
        LET g_chr5= 'N'                                                             
        CASE g_tqw.tqw10                                                            
           WHEN '2' LET g_chr2= 'Y'                                                 
           WHEN '3' LET g_chr3= 'Y'                                                 
           WHEN '4' LET g_chr4= 'Y'                                                 
           WHEN '5' LET g_chr5= 'Y'                                                 
        END CASE                             
        CALL cl_set_field_pic1(g_chr3,"","",g_chr4,g_chr5,"",g_chr2,"") 
END FUNCTION
 
FUNCTION t231_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("tqw01",TRUE)
     END IF
 
    #FUN-820033 --begin--
    IF p_cmd = 'u' OR p_cmd = 'a' THEN
       CALL cl_set_comp_entry("tqw21",TRUE)
    END IF
 
    IF p_cmd = 'u' OR p_cmd = 'a' THEN
       CALL cl_set_comp_entry("tqw23",TRUE)
    END IF
    #FUN-820033 --end--
END FUNCTION
 
FUNCTION t231_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("tqw01",FALSE)
    END IF
 
    #FUN-820033 --begin--
    IF (p_cmd = 'u' OR p_cmd = 'a') AND g_tqw.tqw20 = '2' THEN
       LET g_tqw.tqw21 = '1' 
       CALL cl_set_comp_entry("tqw21",FALSE)
    END IF
 
    IF (p_cmd = 'u' OR p_cmd = 'a') AND g_tqw.tqw21 = '2' THEN
       LET g_tqw.tqw23 = ' ' 
       CALL cl_set_comp_entry("tqw23",FALSE)
    END IF
    #FUN-820033 --end--
END FUNCTION
 
FUNCTION t231_copy()
    DEFINE l_cnt        LIKE type_file.num10       #No.FUN-680120 INTEGER
    DEFINE li_result    LIKE type_file.num5        #No.FUN-680120 SMALLINT
    DEFINE
        l_newno         LIKE tqw_file.tqw01,
        l_oldno         LIKE tqw_file.tqw01,
        l_newdate       LIKE tqw_file.tqw02,
        p_cmd     LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
        g_n       LIKE type_file.num5,             #No.FUN-680120 SMALLINT
        l_input   LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1) 
 
    IF g_tqw.tqw01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_tqw.tqw10 = '5' THEN
        CALL cl_err('',9024,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL t231_set_entry('a')
    LET g_before_input_done = TRUE
    LET l_newdate=g_today
  
    INPUT l_newno,l_newdate FROM tqw01,tqw02
 
    BEFORE INPUT
    CALL cl_set_docno_format("tqw01")
 
 
        AFTER FIELD tqw01
              IF cl_null(l_newno[1,g_doc_len] )THEN
                 NEXT FIELD tqw01
              END IF
              #CALL s_check_no("axm",l_newno,"","04","tqw_file","tqw01","")  #FUN-A70130
              CALL s_check_no("atm",l_newno,"","U5","tqw_file","tqw01","")  #FUN-A70130
                 RETURNING li_result,l_newno                                  
              DISPLAY l_newno TO tqw01                                        
              IF (NOT li_result) THEN                                         
                   NEXT FIELD tqw01                                           
              END IF    
              
        AFTER FIELD tqw02       
              IF cl_null(l_newdate) THEN
                 NEXT FIELD tqw02
              END IF  
               
              BEGIN WORK 
              #CALL s_auto_assign_no("axm",l_newno,l_newdate,"04","tqw_file","tqw01","","","") #FUN-A70130
              CALL s_auto_assign_no("atm",l_newno,l_newdate,"U5","tqw_file","tqw01","","","") #FUN-A70130
                 RETURNING li_result,l_newno
              IF (NOT li_result) THEN
                 NEXT FIELD tqw01
              END IF
              DISPLAY l_newno TO tqw01           
 
              ON ACTION CONTROLP
                 CASE
                   WHEN INFIELD(tqw01) 
                        LET g_t1 = s_get_doc_no(l_newno) 
                        CALL q_oay(FALSE,FALSE,g_t1,'U5','atm') RETURNING g_t1    #FUN-A70130   
                        LET l_newno=g_t1  
                        DISPLAY l_newno TO tqw01
                        NEXT FIELD tqw01
                   END CASE
 
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
        DISPLAY BY NAME g_tqw.tqw01
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM tqw_file
        WHERE tqw01=g_tqw.tqw01
        INTO TEMP y
    UPDATE y
        SET tqw01=l_newno,    #資料鍵值
            tqw02=l_newdate,
            tqw10='1',
            tqw07=0,
            tqw08=0,   #No.TQC-650111
            tqw081=0,  #No.TQC-650111
            tqw20='1',
            tqwacti='Y',      #資料有效碼
            tqwuser=g_user,   #資料所有者
            tqwgrup=g_grup,   #資料所有者所屬群
            tqwmodu=NULL,     #資料修改日期
            tqwdate=g_today   #資料建立日期
    INSERT INTO tqw_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)   #No.FUN-660104
        CALL cl_err3("ins","tqw_file",g_tqw.tqw01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_tqw.tqw01
        LET g_tqw.tqw01 = l_newno
        LET g_tqw.tqw02 = l_newdate
        SELECT tqw01,tqw_file.* INTO g_tqw.tqw01,g_tqw.* FROM tqw_file
               WHERE tqw01=l_newno
        CALL t231_u()
        #SELECT tqw01,tqw_file.* INTO g_tqw.tqw01,g_tqw.* FROM tqw_file  #FUN-C80046
        #       WHERE tqw01=l_oldno  #FUN-C80046
    END IF
    #LET g_tqw.tqw01 = l_oldno  #FUN-C80046
    CALL t231_show()
END FUNCTION
 
FUNCTION t231_x(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废
 
    IF g_tqw.tqw01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_tqw.tqw10='5' THEN RETURN END IF
    ELSE
       IF g_tqw.tqw10<>'5' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
    IF g_tqw.tqw10 MATCHES '[234]' THEN CALL cl_err('','atm-046',1) RETURN END IF
    BEGIN WORK
 
    OPEN t231_cl USING g_tqw.tqw01
    IF STATUS THEN
       CALL cl_err("OPEN t231_cl:", STATUS, 1)
       CLOSE t231_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t231_cl INTO g_tqw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t231_show()
    IF g_tqw.tqw10='1' THEN LET l_chr='N' END IF
    IF g_tqw.tqw10='5' THEN LET l_chr='Y' END IF
    IF cl_void(0,0,l_chr) THEN
       LET g_chr=g_tqw.tqw10
       IF g_tqw.tqw10='1' THEN
           LET g_tqw.tqw10='5'
       ELSE
           LET g_tqw.tqw10='1'
       END IF
    END IF
    UPDATE tqw_file
        SET tqw10=g_tqw.tqw10
        WHERE tqw01=g_tqw.tqw01
    IF SQLCA.SQLERRD[3]=0 THEN
    #   CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)   #No.FUN-660104
        CALL cl_err3("upd","tqw_file",g_tqw.tqw01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        LET g_tqw.tqw10=g_chr
    END IF
    DISPLAY BY NAME g_tqw.tqw10
    CLOSE t231_cl
    COMMIT WORK
    LET g_chr2= 'N'                                                             
    LET g_chr3= 'N'                                                             
    LET g_chr4= 'N'                                                             
    LET g_chr5= 'N'                                                             
    CASE g_tqw.tqw10                                                            
       WHEN '2' LET g_chr2= 'Y'                                                 
       WHEN '3' LET g_chr3= 'Y'                                                 
       WHEN '4' LET g_chr4= 'Y'                                                 
       WHEN '5' LET g_chr5= 'Y'                                                 
    END CASE                             
    CALL cl_set_field_pic1(g_chr3,"","",g_chr4,g_chr5,"",g_chr2,"") 
END FUNCTION
#FUN-820033 --begin--
FUNCTION t231_g_b()
DEFINE m_tqw       RECORD LIKE tqw_file.* 
DEFINE l_sql       STRING
DEFINE l_rec_tqv_b LIKE type_file.num10
DEFINE l_sum       LIKE tqw_file.tqw07
DEFINE l_sum_tqv05 LIKE tqv_file.tqv05
#DEFINE l_max_rec   LIKE type_file.num5		#TQC-980160 mark
DEFINE l_lock_sw   LIKE type_file.chr1
DEFINE p_cmd       LIKE type_file.chr1
DEFINE l_tqs07     LIKE tqs_file.tqs07
 
   IF cl_null(g_tqw.tqw01) THEN RETURN END IF
   IF g_tqw.tqw10 != '1' THEN
      CALL cl_err('','atm-239',0)
      RETURN
   END IF
   
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t231_cl USING g_tqw.tqw01
   IF STATUS THEN
      CALL cl_err("OPEN t231_cl k:",STATUS,1)
      CLOSE t231_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t231_cl INTO m_tqw.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,0)
      CLOSE t231_cl
      ROLLBACK WORK
      RETURN
   END IF
   COMMIT WORK
   OPEN WINDOW t231_g_b_w AT 2,2 WITH FORM "atm/42f/atmt231_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("atmt231_1")
 
   CALL g_tqv.clear()
   LET g_cnt =1
 
   LET l_sql = "SELECT tqv02,tqv03,tqv04,'',tqv05,tqv06,tqv07",
               "  FROM tqv_file",
               " WHERE tqv01 = ?",
               " ORDER BY tqv02"
   PREPARE t231_tqv_pb FROM l_sql
   DECLARE tqv_curs CURSOR FOR t231_tqv_pb
 
   LET l_sum = 0
   FOREACH tqv_curs USING g_tqw.tqw01 INTO g_tqv[g_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     LET i = g_cnt
     CALL t231_tqv04('d')
     IF cl_null(g_tqv[g_cnt].tqv05) THEN
        LET g_tqv[g_cnt].tqv05 = 0 
     END IF
     LET l_sum = l_sum + g_tqv[g_cnt].tqv05
     LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_tqv.deleteElement(g_cnt)
 
   LET l_rec_tqv_b = g_cnt -1
   DISPLAY l_rec_tqv_b TO FORMONLY.cn2
  
   LET i = 1
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_allow_update = TRUE
 
   DISPLAY 'g_tqv.getlength():', g_tqv.getLength()
   INPUT ARRAY g_tqv WITHOUT DEFAULTS FROM s_tqv.*
        #ATTRIBUTE(COUNT=l_rec_tqv_b,MAXCOUNT=l_max_rec,UNBUFFERED,	#TQC-980160 mark
         ATTRIBUTE(COUNT=l_rec_tqv_b,MAXCOUNT=g_max_rec,UNBUFFERED,	#TQC-980160
             INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INSERT
          LET i = ARR_CURR()
          LET p_cmd = 'a'
          INITIALIZE g_tqv[i].* TO NULL
          LET g_tqv_t.* = g_tqv[i].*
          NEXT FIELD tqv02
 
        AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO tqv_file(tqv01,tqv02,tqv03,tqv04,tqv05,tqv06,tqv07,
                               tqvplant,tqvlegal) #FUN-980009
           VALUES(g_tqw.tqw01,g_tqv[i].tqv02,g_tqv[i].tqv03,g_tqv[i].tqv04,
                  g_tqv[i].tqv05,g_tqv[i].tqv06,g_tqv[i].tqv07,
                  g_plant,g_legal)                 #FUN-980009
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","tqv_file",g_tqw.tqw01,g_tqv[i].tqv02,SQLCA.sqlcode,"","ins tqv:",1)
             LET g_success = 'N'
             CANCEL INSERT
          ELSE  
             LET l_rec_tqv_b = l_rec_tqv_b + 1
             MESSAGE "insert ok"
             DISPLAY l_rec_tqv_b TO FORMONLY.cn2
          END IF
 
 
        BEFORE INPUT
           IF l_rec_tqv_b != 0 THEN
              CALL fgl_set_arr_curr(i)
           END IF
           CALL t231_set_entry_b(p_cmd)
           CALL t231_set_no_entry_b(p_cmd)
 
        BEFORE ROW
           LET p_cmd = ''
           LET i = ARR_CURR()
           LET l_lock_sw = 'N' 
           IF l_rec_tqv_b >= i THEN
              LET p_cmd = 'u'
              LET g_tqv_t.* = g_tqv[i].*
              OPEN tqv_curs USING g_tqw.tqw01
              IF STATUS THEN
                 CALL cl_err("OPEN i010_bcl:",STATUS,1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH tqv_curs INTO g_tqv[i].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tqw.tqw01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t231_tqv04('d')
              END IF
           END IF
 
        BEFORE FIELD tqv02
           IF cl_null(g_tqv[i].tqv02) OR g_tqv[i].tqv02 = 0 THEN
              SELECT MAX(tqv02)+1 INTO g_tqv[i].tqv02 FROM tqv_file
               WHERE tqv01 = g_tqw.tqw01
              IF cl_null(g_tqv[i].tqv02) THEN
                 LET g_tqv[i].tqv02 = 1
              END IF
           END IF
 
        AFTER FIELD tqv02
           IF g_tqv_t.tqv02 IS NULL OR
              g_tqv_t.tqv02 != g_tqv[i].tqv02 THEN
              SELECT COUNT(*) INTO g_cnt FROM tqv_file
               WHERE tqv01 = g_tqw.tqw01 
              IF g_cnt > 0  THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD tqv02
              END IF
           END IF
 
        BEFORE FIELD tqv03
           CALL t231_set_entry_b(p_cmd)
           CALL t231_set_no_entry_b(p_cmd)
 
        AFTER FIELD tqv03 
           IF NOT cl_null(g_tqv[i].tqv03) THEN
              IF g_tqw.tqw20 = '1' THEN
                 SELECT COUNT(*) INTO g_cnt FROM tqr_file
                  WHERE tqr02 = g_tqv[i].tqv03
                 IF g_cnt = 0 THEN
                    CALL cl_err3("sel","tqr_file",g_tqv[i].tqv03,"",'100',"","",0)
                    NEXT FIELD tqv03
                 END IF
              END IF
              IF g_tqw.tqw20 = '2' THEN
                 SELECT COUNT(*) INTO g_cnt FROM tqs_file
                  WHERE tqs02 = g_tqv[i].tqv03 AND tqs09 = 'Y' 
                    AND tqs07 IN ('2','3')
                 IF g_cnt = 0 THEN
                    CALL cl_err3("sel","tqr_file",g_tqv[i].tqv03,"",'100',"","",0)
                    NEXT FIELD tqv03
                 END IF
              END IF
              IF p_cmd = 'a' OR (p_cmd = 'u' 
                                 AND (g_tqv[i].tqv03 != g_tqv_t.tqv03)) THEN
                 IF g_tqw.tqw20 = '2' THEN
                    SELECT tqs03 INTO g_tqv[i].tqv04 FROM tqs_file
                     WHERE tqs01 = g_tqw.tqw01 AND tqs02 = g_tqv[i].tqv02
                    SELECT tqs07 INTO l_tqs07 FROM tqs_file
                     WHERE tqs01 = g_tqw.tqw01 AND tqs02 = g_tqv[i].tqv02
                    IF l_tqs07 = '3' THEN
                       SELECT tqs08 INTO g_tqv[i].tqv05 FROM tqs_file
                        WHERE tqs01 = g_tqw.tqw01 AND tqs02 = g_tqv[i].tqv02
                          AND tqs07 = l_tqs07
                    END IF
                    SELECT tqs06 INTO g_tqv[i].tqv06 FROM tqs_file
                     WHERE tqs01 = g_tqw.tqw01 AND tqs02 = g_tqv[i].tqv02
                 END IF
              END IF
           END IF
 
        BEFORE FIELD tqv04
           CALL t231_set_entry_b(p_cmd)
           CALL t231_set_no_entry_b(p_cmd)
 
        AFTER FIELD tqv04
           IF NOT cl_null(g_tqv[i].tqv04) THEN
              CALL t231_tqv04('d')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tqv[i].tqv04,g_errno,1)
                 LET g_tqv[i].tqv04 = NULL
                 NEXT FIELD tqv04
              END IF
              IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_tqv[i].tqv04 != g_tqv_t.tqv04
                                                  OR g_tqv_t.tqv04 IS NULL)) THEN
                     SELECT COUNT(*) INTO g_cnt FROM oaj_file
                      WHERE oaj01 = g_tqv[i].tqv04 AND oajacti = 'Y'
                     IF g_cnt = 0 THEN
                        CALL cl_err3("sel","oaj_file",g_tqv[i].tqv04,"",'100',"","",0)
                        NEXT FIELD tqv04
                     END IF
              END IF
           END IF
 
        AFTER FIELD tqv05
           IF NOT cl_null(g_tqv[i].tqv05) THEN
              IF g_tqv[i].tqv05 <= 0 THEN
                 CALL cl_err('','anm-995',0)
                 NEXT FIELD tqv05
              END IF
           END IF
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(tqv04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oaj"
                LET g_qryparam.default1 = g_tqv[i].tqv04
                CALL cl_create_qry() RETURNING g_tqv[i].tqv04
                DISPLAY g_tqv[i].tqv04 TO tqv04
                NEXT FIELD tqv04
           END CASE
 
        BEFORE DELETE
           IF g_tqv[i].tqv02 > 0 AND g_tqv_t.tqv02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              DELETE FROM tqv_file
               WHERE tqv01 = g_tqw.tqw01 AND tqv02 = g_tqv_t.tqv02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","tqv_file",g_tqw.tqw01,g_tqv_t.tqv02,SQLCA.sqlcode,"","",1)
                 CANCEL DELETE
              END IF
              LET l_rec_tqv_b = l_rec_tqv_b -1
              MESSAGE "delete ok"
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tqv[i].* = g_tqv_t.*
              LET g_success = 'N'
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tqv[l_ac].tqv02,-263,1)
              LET g_tqv[l_ac].* = g_tqv_t.*
           ELSE
              IF l_allow_update = TRUE THEN
                 UPDATE tqv_file SET tqv02 = g_tqv[i].tqv02,
                                     tqv03 = g_tqv[i].tqv03,
                                     tqv04 = g_tqv[i].tqv04,
                                     tqv05 = g_tqv[i].tqv05,
                                     tqv06 = g_tqv[i].tqv06,
                                     tqv07 = g_tqv[i].tqv07
                  WHERE tqv01 = g_tqw.tqw01
                    AND tqv02 = g_tqv_t.tqv02
                 IF STATUS OR SQLCA.sqlcode THEN
                    CALL cl_err3("upd","tqv_file",g_tqw.tqw01,g_tqv_t.tqv02,SQLCA.sqlcode,"","upd tqv:",1)
                    LET g_success = 'N'
                    LET g_tqv[i].* = g_tqv_t.*
                 ELSE
                    MESSAGE "update ok"
                 END IF
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tqv[l_ac].* = g_tqv_t.*
              END IF
              LET g_success = 'N'
              EXIT INPUT
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
 
        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
 
   END INPUT  
   IF INT_FLAG THEN
      LET g_success = 'N'
      LET INT_FLAG = 0
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      MESSAGE "commit"
   ELSE
      ROLLBACK WORK
      MESSAGE "RollBack"
   END IF
 
   SELECT SUM(tqv05) INTO l_sum_tqv05 FROM tqv_file WHERE tqv01 = g_tqw.tqw01
   IF l_sum_tqv05 <> g_tqw.tqw07 THEN
      CALL cl_err('','atm-134',1)
      COMMIT WORK
      CLOSE WINDOW t231_g_b_w
      CALL t231_g_b()
   END IF
 
   CLOSE WINDOW t231_g_b_w
 
END FUNCTION
 
FUNCTION t231_tqv04(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_oaj02   LIKE oaj_file.oaj02
DEFINE l_oajacti LIKE oaj_file.oajacti
 
 LET g_errno = ' '
 SELECT oaj02,oajacti INTO l_oaj02,l_oajacti FROM oaj_file
  WHERE oaj01 = g_tqv[i].tqv04
 
   CASE 
      WHEN SQLCA.sqlcode=100   LET g_errno ='100'
                               LET l_oaj02 = NULL
      WHEN l_oajacti = 'N'     LET g_errno ='9028'
      OTHERWISE 
           LET g_errno =SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_tqv[i].tqv04_oaj02 = l_oaj02
      IF SQLCA.sqlcode THEN
         LET g_tqv[i].tqv04_oaj02 = NULL
      END IF
   END IF
END FUNCTION
 
FUNCTION t231_set_entry_b(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
 
    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("tqv03",TRUE)
    END IF
 
    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("tqv04",TRUE)
    END IF
END FUNCTION
 
FUNCTION t231_set_no_entry_b(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
 
    IF g_tqw.tqw22 IS NULL OR (g_tqw.tqw20 = '3' OR g_tqw.tqw20 = '4') THEN
      #LET g_tqv[i].tqv03 = NULL		#TQC-980160 mark
       CALL cl_set_comp_entry("tqv03",FALSE)
    END IF
 
    IF g_tqw.tqw22 IS NULL OR (g_tqw.tqw20 != '2') THEN
       CALL cl_set_comp_entry("tqv04",FALSE)
    END IF
END FUNCTION
#FUN-820033 --end--

