# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: aapt750.4gl
# Descriptions...: 信用狀close_the_case作業
# Date & Author..: 95/11/10 By Roger
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: 97/04/22 By Star [將apc_file 改為 npp_file,npq_file ]
# Modify.........: No.9646 04/06/08 By kitty I.結案分錄 call s_fsgl,傳的參數alafirm改為alaclos
# Modify.........: No.FUN-4B0054 04/11/23 By ching add 匯率開窗 call s_rate
# Modify.........: No.FUN-550030 05/05/23 By wujie 單據編號加大
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL   CALL s_def_npq() 依設定
#                                                   給摘要與異動碼預設值
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670060 06/08/01 By wujie 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680019 06/08/08 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680029 06/08/18 By Ray 多帳套修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0016 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6B0092 06/11/17 By Smapmin 結案時要先check分錄正確與否
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/04/03 By mike    會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By hongmei 用年度取帳號 
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alaplant該為ala97 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: NO.FUN-990031 09/10/26 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下;开放营运中心可录
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B10050 11/01/20 By Carrier 科目查询自动过滤 & 两套帐内容修改
# Modify.........: No.FUN-AA0087 11/01/27 By Mengxw  異動碼類型設定的改善 
# Modify.........: No:FUN-B40056 11/05/10 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/18 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.MOD-C10130 12/01/18 By Polly 拋轉傳票時，不抓開狀日期(ala08)改抓結案日期(ala771)
# Modify.........: No.FUN-D10065 13/01/15 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1 LIKE ala_file.ala01,      # No.FUN-690028 VARCHAR(20)
    g_ala   RECORD LIKE ala_file.*,
    g_nme   RECORD LIKE nme_file.*,
    g_nmd   RECORD LIKE nmd_file.*,
    g_ala_t RECORD LIKE ala_file.*,
    g_ala01_t LIKE ala_file.ala01,
    g_dbs_gl  LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    g_plant_gl  LIKE type_file.chr21,       # No.FUN-980059 VARCHAR(21),
    g_dbs_nm  LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    gl_no_b,gl_no_e     LIKE abb_file.abb01,        # No.FUN-690028 VARCHAR(16),         #No.FUN-550030
    ala23_24,tot2       LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    ala59_60,tot4       LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
     g_wc,g_sql          string  #No.FUN-580092 HCN
#------for ora修改-------------------
DEFINE g_system         LIKE type_file.chr2        # No.FUN-690028 VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_N              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
#------for ora修改-------------------
 
DEFINE g_forupd_sql STRING          #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_str           STRING     #No.FUN-670060                                                                                   
DEFINE g_wc_gl         STRING     #No.FUN-670060                                                                                   
DEFINE g_t1            LIKE oay_file.oayslip    #No.FUN-670060   #No.FUN-690028 VARCHAR(5)
DEFINE g_bookno1       LIKE aza_file.aza81      #No.FUN-730064  
DEFINE g_bookno2       LIKE aza_file.aza82      #No.FUN-730064 
DEFINE g_bookno        LIKE aza_file.aza82      #No.FUN-B10150
DEFINE g_flag          LIKE type_file.chr1      #No.FUN-730064 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5    #No.FUN-690028 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0055
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1 = ARG_VAL(1)
    LET g_plant_new=g_apz.apz04p
    CALL s_getdbs()
    IF g_dbs_nm = ' ' THEN LET g_dbs_nm = NULL END IF
    LET g_plant_new=g_apz.apz02p
    CALL s_getdbs()
    IF g_dbs_gl = ' ' THEN LET g_dbs_gl = NULL END IF
    IF p_row = 0 OR p_row IS NULL THEN           # 螢墓位置
        LET p_row = 4
        LET p_col = 3
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
    INITIALIZE g_ala.* TO NULL
    INITIALIZE g_ala_t.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM ala_file WHERE ala01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t750_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 17
 
    OPEN WINDOW t750_w AT p_row,p_col WITH FORM "aap/42f/aapt750"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #No.FUN-680029 --begin
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("ala779,ala780",TRUE)
    ELSE
       CALL cl_set_comp_visible("ala779,ala780",FALSE)
    END IF
    #No.FUN-680029 --end
    #FUN-680019...............begin
    CALL cl_set_comp_visible("ala930,gem02b",g_aaz.aaz90='Y')
    #FUN-680019...............end
 
    IF NOT cl_null(g_argv1) THEN CALL t750_q() END IF
 
#   WHILE TRUE
      LET g_action_choice=""
      CALL t750_menu()
#     IF g_action_choice="exit" THEN EXIT WHILE END IF
#   END WHILE
 
    CLOSE WINDOW t750_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION t750_cs()
    CLEAR FORM
    IF cl_null(g_argv1) THEN
   INITIALIZE g_ala.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
#               alaplant,ala01,ala08,ala04,ala930,alafirm,ala78,alaclos, #FUN-680019     #No.FUN-980017
                ala97,ala01,ala08,ala04,ala930,alafirm,ala78,alaclos, #FUN-680019        #No.FUN-980017
                ala20,ala21,ala25,ala61,
                ala771,ala773,ala772,ala775,ala777,
                ala75,ala774,ala776,ala778
                #FUN-850038   ---start---
                ,alaud01,alaud02,alaud03,alaud04,alaud05,
                alaud06,alaud07,alaud08,alaud09,alaud10,
                alaud11,alaud12,alaud13,alaud14,alaud15
                #FUN-850038    ----end----
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
          ON ACTION controlp
             CASE
               WHEN INFIELD(ala01) # APO
                    CALL q_ala(TRUE,TRUE,g_ala.ala01)
                               RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ala01
               WHEN INFIELD(ala20) # 幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azi"
                  LET g_qryparam.default1 = g_ala.ala20
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala20
               WHEN INFIELD(ala776) # 科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ala.ala776
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala776
               WHEN INFIELD(ala778) # 科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ala.ala778
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala778
               #No.FUN-680029 --begin
               WHEN INFIELD(ala779) # 科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ala.ala779 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala779
               WHEN INFIELD(ala780) # 科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ala.ala780
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala780
               #No.FUN-680029 --end
               #FUN-680019...............begin
               WHEN INFIELD(ala04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala04
                  NEXT FIELD ala04
               WHEN INFIELD(ala930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ala930
                  NEXT FIELD ala930
               #FUN-680019...............end
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('alauser', 'alagrup') #FUN-980030
    ELSE
       LET g_wc=" ala01='",g_argv1,"'"
    END IF
    LET g_sql="SELECT ala01 FROM ala_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY ala01"
    PREPARE t750_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t750_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t750_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ala_file WHERE ",g_wc CLIPPED
    PREPARE t750_precount FROM g_sql
    DECLARE t750_count CURSOR FOR t750_precount
END FUNCTION
 
FUNCTION t750_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            #No.FUN-680029 --begin
            IF g_aza.aza63 = 'Y' THEN
               CALL cl_set_act_visible("maint_entry2",TRUE)
            ELSE
               CALL cl_set_act_visible("maint_entry2",FALSE)
            END IF
            #No.FUN-680029 --end
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t750_q()
            END IF
        ON ACTION next
            CALL t750_fetch('N')
        ON ACTION previous
            CALL t750_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t750_u()
            END IF
        ON ACTION gen_close_entry
            LET g_action_choice="gen_close_entry"
            IF cl_chk_act_auth() THEN
               CALL t750_g_gl(g_ala.ala01,9,0)
            END IF
        ON ACTION maint_entry
            LET g_action_choice="maint_entry"
            IF cl_chk_act_auth() THEN
              #CALL s_fsgl('LC',9,g_ala.ala01,0,g_apz.apz02b,0,g_ala.alafirm)
               CALL s_fsgl('LC',9,g_ala.ala01,0,g_apz.apz02b,0,g_ala.alaclos,'0',g_apz.apz02p)   #No:9646
               CALL cl_navigator_setting( g_curs_index, g_row_count )  #No.FUN-680029
               CALL t750_npp02('0')  #No.+081 010504 by plum
            END IF
        #No.FUN-680029 --begin
        ON ACTION maint_entry2
            LET g_action_choice="maint_entry2"
            IF cl_chk_act_auth() THEN
               CALL s_fsgl('LC',9,g_ala.ala01,0,g_apz.apz02c,0,g_ala.alaclos,'1',g_apz.apz02p)
               CALL cl_navigator_setting( g_curs_index, g_row_count )
               CALL t750_npp02('1')
            END IF
        #No.FUN-680029 --end
        ON ACTION close_the_case
           LET g_action_choice = "close_the_case"
           IF cl_chk_act_auth() THEN
              CALL t750_close()
              CALL cl_set_field_pic("","","",g_ala.alaclos,"","")
           END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","",g_ala.alaclos,"","")
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL t750_fetch('/')
        ON ACTION first
            CALL t750_fetch('F')
        ON ACTION last
            CALL t750_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
         #No.FUN-670060  --Begin                                                                                                    
        ON ACTION carry_voucher
            IF cl_chk_act_auth() THEN
               IF g_ala.alaclos = 'Y' THEN                                                                                             
                  CALL t750_carry_voucher()                                                                                            
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF                                                                                                                  
            END IF                                                                                                                  
        ON ACTION undo_carry_voucher
            IF cl_chk_act_auth() THEN
               IF g_ala.alaclos = 'Y' THEN                                                                                             
                  CALL t750_undo_carry_voucher()                                                                                       
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF                                                                                                                  
            END IF                                                                                                                  
         #No.FUN-670060  --End  
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
         #No.FUN-6A0016-------add--------str----
         ON ACTION related_document       #相關文件
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
                IF g_ala.ala01 IS NOT NULL THEN
                   LET g_doc.column1 = "ala01"
                   LET g_doc.value1 = g_ala.ala01
                   CALL cl_doc()
                END IF
            END IF
         #No.FUN-6A0016-------add--------end----
 
           LET g_action_choice = "exit"
           CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t750_cs
END FUNCTION
 
 
FUNCTION t750_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_nma10         LIKE nma_file.nma10     # No.FUN-690028 VARCHAR(4)
 
    INPUT BY NAME
        g_ala.ala97,     #FUN-990031 add
        g_ala.ala771,g_ala.ala773,g_ala.ala774,g_ala.ala75,g_ala.ala772,
        g_ala.ala775,g_ala.ala777,g_ala.ala776,g_ala.ala778,
        g_ala.ala779,g_ala.ala780  #No.FUN-680029
        #FUN-850038     ---start---
        ,g_ala.alaud01,g_ala.alaud02,g_ala.alaud03,g_ala.alaud04,
        g_ala.alaud05,g_ala.alaud06,g_ala.alaud07,g_ala.alaud08,
        g_ala.alaud09,g_ala.alaud10,g_ala.alaud11,g_ala.alaud12,
        g_ala.alaud13,g_ala.alaud14,g_ala.alaud15 
        #FUN-850038     ----end----
        WITHOUT DEFAULTS
 
        #FUN-990031--add--str--
        AFTER FIELD ala97
          IF NOT cl_null(g_ala.ala97) THEN
             SELECT count(*) INTO l_n FROM azw_file WHERE azw01 = g_ala.ala97
                AND azw02 = g_legal
             IF l_n = 0 THEN
               CALL cl_err('sel_azw','agl-171',0)
               NEXT FIELD ala97
             END IF
          END IF
       #FUN-990031--add--end
        BEFORE FIELD ala771
            IF g_ala.ala771 IS NULL THEN
               LET g_ala.ala771 = TODAY
               DISPLAY BY NAME g_ala.ala771
            END IF
        AFTER FIELD ala771            #85-10-17
          IF NOT cl_null(g_ala.ala771) THEN
             #FUN-B50090 add begin-------------------------
             #重新抓取關帳日期
             SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
             #FUN-B50090 add -end--------------------------
             IF g_ala.ala771<=g_apz.apz57 THEN
                CALL cl_err(g_ala.ala01,'aap-176',1) RETURN
             END IF 
             #No.FUN-730064   --BEGIN--
             CALL s_get_bookno(YEAR(g_ala.ala771))  RETURNING g_flag,g_bookno1,g_bookno2     #No.TQC-740042
             IF g_flag='1'  THEN    #抓不到帳別
                  CALL cl_err(g_ala.ala771,'aoo-081',1)
                  NEXT FIELD ala771
             END IF 
             #No.FUN-730064  --END--
          END IF
 
        BEFORE FIELD ala773
            LET g_ala.ala773 = tot2 * g_ala.ala21 / 100
            DISPLAY BY NAME g_ala.ala773
 
        AFTER FIELD ala773            #85-10-17
            IF cl_null(g_ala.ala773) THEN
               LET g_ala.ala773 = tot2 * g_ala.ala21 / 100
               DISPLAY BY NAME g_ala.ala773
               NEXT FIELD ala773
            END IF
 
        AFTER FIELD ala774
          IF NOT cl_null(g_ala.ala774) THEN
            LET g_ala.ala775 = g_ala.ala773 * g_ala.ala774
            LET g_ala.ala777 = tot4 - g_ala.ala775
            DISPLAY BY NAME g_ala.ala775,g_ala.ala777
          END IF
 
        AFTER FIELD ala776
            #No.FUN-B10050  --Begin
            #LET g_msg=''
            #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_ala.ala776
            #                                       AND  aag00=g_bookno1     #No.FUN-730064  
            #IF STATUS THEN NEXT FIELD ala776 END IF    #85-10-17
            #DISPLAY g_msg TO FORMONLY.aag02
            IF NOT cl_null(g_ala.ala776) THEN
              CALL t750_aag01(p_cmd,g_bookno1,g_ala.ala776,'1')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ala.ala776,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ala.ala776
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ala.ala776 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_ala.ala776
                 DISPLAY BY NAME g_ala.ala776
                 NEXT FIELD ala776
              END IF
            END IF
            #No.FUN-B10050  --End  
 
        #No.FUN-680029 --begin
        AFTER FIELD ala779
            #No.FUN-B10050  --Begin
            #LET g_msg=''
            #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_ala.ala779
            #                                       AND  aag00=g_bookno2     #No.FUN-730064  
            #IF STATUS THEN NEXT FIELD ala779 END IF
            #DISPLAY g_msg TO FORMONLY.aag02c
            IF NOT cl_null(g_ala.ala779) THEN
              CALL t750_aag01(p_cmd,g_bookno2,g_ala.ala779,'2')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ala.ala779,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ala.ala779
                 LET g_qryparam.arg1 = g_bookno2
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ala.ala779 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_ala.ala779
                 DISPLAY BY NAME g_ala.ala779
                 NEXT FIELD ala779
              END IF
            END IF
            #No.FUN-B10050  --End  
        #No.FUN-680029 --end
 
        AFTER FIELD ala778
            #No.FUN-B10050  --Begin
            #LET g_msg=''
            #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_ala.ala778
            #                                       AND  aag00=g_bookno1      #No.FUN-730064  
            #IF STATUS THEN NEXT FIELD ala778 END IF    #85-10-17
            #DISPLAY g_msg TO FORMONLY.aag02b
            IF NOT cl_null(g_ala.ala778) THEN
              CALL t750_aag01(p_cmd,g_bookno1,g_ala.ala778,'3')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ala.ala778,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ala.ala778
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ala.ala778 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_ala.ala778
                 DISPLAY BY NAME g_ala.ala778
                 NEXT FIELD ala778
              END IF
            END IF
            #No.FUN-B10050  --End  
 
        #No.FUN-680029 --begin
        AFTER FIELD ala780
            #No.FUN-B10050  --Begin
            #LET g_msg=''
            #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_ala.ala780
            #                                        AND aag00=g_bookno2      #No.FUN-730064  
            #IF STATUS THEN NEXT FIELD ala780 END IF
            #DISPLAY g_msg TO FORMONLY.aag02d
            IF NOT cl_null(g_ala.ala780) THEN
              CALL t750_aag01(p_cmd,g_bookno2,g_ala.ala780,'4')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ala.ala780,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ala.ala780
                 LET g_qryparam.arg1 = g_bookno2
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",g_ala.ala780 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_ala.ala780
                 DISPLAY BY NAME g_ala.ala780
                 NEXT FIELD ala780
              END IF
            END IF
            #No.FUN-B10050  --End  
        #No.FUN-680029 --end
 
        #FUN-850038     ---start---
        AFTER FIELD alaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850038     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ala01
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
 
 
       ON ACTION controlp
             CASE
                #FUN-4B0054
                WHEN INFIELD(ala774)
                   CALL s_rate(g_ala.ala20,g_ala.ala774)
                   RETURNING g_ala.ala774
                   DISPLAY BY NAME g_ala.ala774
                #--
               #No.FUN-680029 --begin
               WHEN INFIELD(ala776) # 科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ala.ala776
                  LET g_qryparam.arg1=g_bookno1         #No.FUN-730064
                  CALL cl_create_qry() RETURNING g_ala.ala776
                  DISPLAY BY NAME g_ala.ala776
               WHEN INFIELD(ala778) # 科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ala.ala778
                  LET g_qryparam.arg1=g_bookno1         #No.FUN-730064 
                  CALL cl_create_qry() RETURNING g_ala.ala778
                  DISPLAY BY NAME g_ala.ala778
               WHEN INFIELD(ala779) # 科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ala.ala779 
                  LET g_qryparam.arg1=g_bookno2         #No.FUN-730064
                  CALL cl_create_qry() RETURNING g_ala.ala779
                  DISPLAY BY NAME g_ala.ala779
               WHEN INFIELD(ala780) # 科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ala.ala780
                  LET g_qryparam.arg1=g_bookno2         #No.FUN-730064
                  CALL cl_create_qry() RETURNING g_ala.ala780
                  DISPLAY BY NAME g_ala.ala780
               #No.FUN-680029 --end
             END CASE
 
 
    END INPUT
END FUNCTION
 
FUNCTION t750_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ala.* TO NULL              #No.FUN-6A0016
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t750_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t750_count
    FETCH t750_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t750_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
        INITIALIZE g_ala.* TO NULL
    ELSE
        CALL t750_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t750_fetch(p_flala)
    DEFINE
        p_flala        LIKE type_file.chr1        # No.FUN-690028  VARCHAR(1)
 
    CASE p_flala
        WHEN 'N' FETCH NEXT     t750_cs INTO g_ala.ala01
        WHEN 'P' FETCH PREVIOUS t750_cs INTO g_ala.ala01
        WHEN 'F' FETCH FIRST    t750_cs INTO g_ala.ala01
        WHEN 'L' FETCH LAST     t750_cs INTO g_ala.ala01
        WHEN '/'
            IF NOT mi_no_ask THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump t750_cs INTO g_ala.ala01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
        INITIALIZE g_ala.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flala
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    #No.FUN-730064   --BEGIN--                                                                                                
    CALL s_get_bookno(YEAR(g_ala.ala771))  RETURNING g_flag,g_bookno1,g_bookno2              #No.TQC-740042                                  
    IF g_flag='1'  THEN    #抓不到帳別                                                                                        
       CALL cl_err(g_ala.ala771,'aoo-081',1)                                                                                
    END IF                                                                                                                    
    #No.FUN-730064  --END--  
    SELECT * INTO g_ala.* FROM ala_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ala01 = g_ala.ala01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("sel","ala_file",g_ala.ala01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
 
        CALL t750_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t750_show()
    LET g_ala_t.* = g_ala.*
    LET ala23_24=g_ala.ala23+g_ala.ala24
    LET tot2    =ala23_24- g_ala.ala25
    LET ala59_60=g_ala.ala59+g_ala.ala60
    LET tot4    =ala59_60- g_ala.ala61
    DISPLAY BY NAME
#       g_ala.alaplant,           #No.FUN-980017
        g_ala.ala97,           #No.FUN-980017
        g_ala.ala01,g_ala.ala08,
        g_ala.ala04,g_ala.ala930, #FUN-680019
        g_ala.ala20,g_ala.ala21,
        ala23_24   ,g_ala.ala25,tot2,
        ala59_60   ,g_ala.ala61,tot4,
        g_ala.ala771, g_ala.ala75,g_ala.ala772, g_ala.ala773, g_ala.ala774,
        g_ala.ala775, g_ala.ala776, g_ala.ala777, g_ala.ala778,
        g_ala.ala779, g_ala.ala780,                              #No.FUN-B10150
        g_ala.alafirm, g_ala.alaclos, g_ala.ala78
        #FUN-850038     ---start---
        ,g_ala.alaud01,g_ala.alaud02,g_ala.alaud03,g_ala.alaud04,
        g_ala.alaud05,g_ala.alaud06,g_ala.alaud07,g_ala.alaud08,
        g_ala.alaud09,g_ala.alaud10,g_ala.alaud11,g_ala.alaud12,
        g_ala.alaud13,g_ala.alaud14,g_ala.alaud15 
        #FUN-850038     ----end----
    #No.FUN-B10050  --Begin
    #LET g_msg =''
    #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_ala.ala776
    #                                       AND  aag00=g_bookno1       #No.FUN-730064  
    #DISPLAY g_msg TO aag02
    #LET g_msg =''
    #SELECT aag02 INTO g_msg FROM aag_file WHERE aag01=g_ala.ala778
    #                                        AND aag00=g_bookno1       #No.FUN-730064 
    #DISPLAY g_msg TO aag02b
    CALL t750_aag01('d',g_bookno1,g_ala.ala776,'1')
    CALL t750_aag01('d',g_bookno2,g_ala.ala779,'2')
    CALL t750_aag01('d',g_bookno1,g_ala.ala778,'3')
    CALL t750_aag01('d',g_bookno2,g_ala.ala780,'4')
    #No.FUN-B10050  --End  

    DISPLAY s_costcenter_desc(g_ala.ala04) TO FORMONLY.gem02   #FUN-680019
    DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b #FUN-680019
    CALL cl_set_field_pic("","","",g_ala.alaclos,"","")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t750_u()
    IF g_ala.ala01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ala.* FROM ala_file
     WHERE ala01=g_ala.ala01
    IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_ala.alafirm='N' THEN CALL cl_err('','aap-717',0) RETURN END IF
    IF g_ala.ala78  ='N' THEN CALL cl_err('','aap-721',0) RETURN END IF
    IF g_ala.alaclos ='Y' THEN RETURN END IF   #85-10-17
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ala01_t = g_ala.ala01
    BEGIN WORK
 
    OPEN t750_cl USING g_ala.ala01
    IF STATUS THEN
       CALL cl_err("OPEN t750_cl:", STATUS, 1)
       CLOSE t750_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t750_cl INTO g_ala.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL t750_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t750_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ala.*=g_ala_t.*
            CALL t750_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ala_file SET ala_file.* = g_ala.*    # 更新DB
            WHERE ala01 = g_ala01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","ala_file",g_ala01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
       #No.+081 010504 by plum
        IF g_ala.ala771 != g_ala_t.ala771 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_ala.ala771
            WHERE npp01=g_ala.ala01 AND npp00=9 AND npp011=0
              AND nppsys = 'LC'
           IF STATUS THEN 
#          CALL cl_err('upd npp02:',STATUS,1) #No.FUN-660122
           CALL cl_err3("upd","npp_file",g_ala01_t,"",STATUS,"","upd npp02:",1)  #No.FUN-660122
           END IF
        END IF
       #No.+081..end
        EXIT WHILE
    END WHILE
    CLOSE t750_cl
    COMMIT WORK
END FUNCTION
 
#No.+081 010504 by plum
FUNCTION t750_npp02(p_npptype)      #No.FUN-680029
  DEFINE p_npptype    LIKE npp_file.npptype      #No.FUN-680029
 
  IF g_ala.ala75 IS NULL OR g_ala.ala75=' ' THEN
     UPDATE npp_file SET npp02=g_ala.ala771
        WHERE npp01=g_ala.ala01 AND npp00=9 AND npp011=0
        AND nppsys = 'LC'
        AND npptype = p_npptype      #No.FUN-680029
     IF STATUS THEN 
#    CALL cl_err('upd npp02:',STATUS,1) #No.FUN-660122
     CALL cl_err3("upd","npp_file",g_ala.ala01,"",STATUS,"","upd npp02:",1)  #No.FUN-660122
     END IF
  END IF
END FUNCTION
#No.+081..end
 
FUNCTION t750_close()
    IF g_ala.ala01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_ala.ala01
    IF g_ala.alafirm='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_ala.alafirm='N' THEN CALL cl_err('','aap-717',0) RETURN END IF
    IF g_ala.ala78  ='N' THEN CALL cl_err('','aap-721',0) RETURN END IF
    IF g_ala.alaclos ='Y' THEN RETURN END IF
 
    #-----MOD-6B0092---------
    CALL s_chknpq1(g_ala.ala01,0,9,'0',g_bookno1)     #No.FUN-730064
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL s_chknpq1(g_ala.ala01,0,9,'1',g_bookno2)     #No.FUN-730064  
    END IF
    IF g_success = 'N' THEN
       RETURN
    END IF
    #-----END MOD-6B0092-----
 
    MESSAGE ""
    CALL cl_opmsg('u')
    IF NOT cl_confirm('axr-247') THEN RETURN END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN t750_cl USING g_ala.ala01
   IF STATUS THEN
      CALL cl_err("OPEN t750_cl:", STATUS, 1)
      CLOSE t750_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t750_cl INTO g_ala.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ala.ala01,SQLCA.sqlcode,0)
       CLOSE t750_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   UPDATE ala_file SET alaclos='Y'
    WHERE ala01 = g_ala.ala01
   IF STATUS THEN
#     CALL cl_err('upd alaclose',STATUS,0)   #No.FUN-660122
      CALL cl_err3("upd","ala_file",g_ala.ala01,"",STATUS,"","upd alaclose",1)  #No.FUN-660122
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
   SELECT alaclos INTO g_ala.alaclos FROM ala_file
    WHERE ala01 = g_ala.ala01
   DISPLAY BY NAME g_ala.alaclos
END FUNCTION
 
FUNCTION t750_g_gl(p_apno,p_sw1,p_sw2)
   DEFINE p_apno	LIKE ala_file.ala01
   DEFINE p_sw1		LIKE type_file.num5        # No.FUN-690028 SMALLINT    #1.會計傳票2.會計付款3.出納付款9.close_the_case傳票
   DEFINE p_sw2		LIKE type_file.num5        # No.FUN-690028 SMALLINT    # 0.初開狀    1/2/3.修改
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(70)
   DEFINE l_ala75       LIKE ala_file.ala75
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   LET g_success = 'Y'  #No.FUN-680029
 
   IF p_apno IS NULL THEN RETURN END IF
   #-----MOD-6B0092---------
   IF g_ala.alaclos = 'Y' THEN
      CALL cl_err(g_ala.ala01,'aap-730',0)
      RETURN
   END IF
   #-----END MOD-6B0092-----
 
   SELECT ala75 INTO l_ala75 FROM ala_file
    WHERE ala01=p_apno
   IF NOT cl_null(l_ala75) THEN RETURN END IF
   BEGIN WORK      #No.FUN-680029
     SELECT COUNT(*) INTO l_n FROM npp_file
      WHERE npp01 = p_apno AND npp00 = p_sw1 AND nppsys = 'LC'
        AND npp011= p_sw2
     IF l_n > 0 THEN
        IF NOT s_ask_entry(p_apno) THEN ROLLBACK WORK RETURN END IF #Genero
        #FUN-B40056--add--str--
        LET l_n = 0
        SELECT COUNT(*) INTO l_n FROM tic_file
         WHERE tic04 = p_apno
        IF l_n > 0 THEN
           IF NOT cl_confirm('sub-533') THEN
              ROLLBACK WORK
              RETURN
           ELSE
              DELETE FROM tic_file WHERE tic04 = p_apno
           END IF
        END IF
        #FUN-B40056--add--end--

        DELETE FROM npp_file WHERE npp01 = p_apno
                               AND npp011= p_sw2
                               AND nppsys='LC'
                               AND npp00 = p_sw1
        DELETE FROM npq_file WHERE npq01 = p_apno
                               AND npq011= p_sw2
                               AND npqsys='LC'
                               AND npq00 = p_sw1
     END IF
     #No.FUN-680029 --begin
     CALL t750_g_gl_2(p_apno,p_sw1,p_sw2,'0')    #付款傳票
     IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
        CALL t750_g_gl_2(p_apno,p_sw1,p_sw2,'1')    #付款傳票
     END IF
     IF g_success = 'Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     #No.FUN-680029 --end
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t750_g_gl_2(p_apno,p_sw1,p_sw2,p_npptype)
   DEFINE p_sw1		LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 1.會計傳票  2.付款傳票 3.close_the_case傳票
   DEFINE p_sw2		LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 0.初開狀    1/2/3.修改
   DEFINE p_apno	LIKE ala_file.ala01
   DEFINE p_npptype     LIKE npp_file.npptype      #No.FUN-680029
   DEFINE l_dept	LIKE ala_file.ala04
   DEFINE l_ala		RECORD LIKE ala_file.*
   DEFINE l_pmc03	LIKE pmc_file.pmc03      # No.FUN-690028 VARCHAR(10)
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_aps		RECORD LIKE aps_file.*
   DEFINE l_mesg	LIKE ze_file.ze03      # No.FUN-690028 VARCHAR(30)
   DEFINE l_diff 	LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_aag05       LIKE aag_file.aag05 #FUN-680019
   DEFINE l_aag44       LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-D40118   Add
 
   SELECT * INTO l_ala.* FROM ala_file WHERE ala01 = p_apno
   IF g_ala.alafirm='X' THEN 
      LET g_success = 'N'      #No.FUN-680029
      CALL cl_err('','9024',0) RETURN 
   END IF
   IF STATUS THEN 
      LET g_success = 'N'      #No.FUN-680029
      RETURN 
   END IF
   #No.FUN-B10150  --Begin
   IF p_npptype = '0' THEN
      LET g_bookno = g_bookno1
   ELSE
      LET g_bookno = g_bookno2
   END IF
   #No.FUN-B10150  --End  

   # 首先, Insert 一筆單頭
   INITIALIZE l_npp.* TO NULL
   LET l_npp.nppsys = 'LC'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_ala.ala01      #單號
   LET l_npp.npp011 = p_sw2            #異動序號
   LET l_npp.npptype = p_npptype      #No.FUN-680029
  #No.+081 010504 by plum mod
  #LET l_npp.npp02  = l_ala.ala08      #異動日期 = 開狀日
   LET l_npp.npp02  = l_ala.ala771     #異動日期 = close_the_case日
  #No.+081...end
   LET l_npp.npplegal = g_legal  #FUN-980001
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS THEN 
#  CALL cl_err('ins npp#1',STATUS,1) #No.FUN-660122
   CALL cl_err3("ins","npp_file",l_npp.npp01,l_npp.npp00,STATUS,"","ins npp#1",1)  #No.FUN-660122
   LET g_success = 'N'      #No.FUN-680029
   END IF
 
   # 然後, Insert 其單身
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq00  = p_sw1            #類別
   LET l_npq.npq01  = l_ala.ala01      #單號
   LET l_npq.npq011 = p_sw2            #異動序號
   LET l_npq.npq02 = 0
   LET l_npq.npq07  = 0                #本幣金額
   LET l_npq.npq07f = 0                #原幣金額
   LET l_npq.npq24  = l_ala.ala20      #幣別
   LET l_npq.npq25  = l_ala.ala51      #匯率
   LET l_npq.npqtype = p_npptype       #No.FUN-680029
   IF cl_null(l_npq.npq25) THEN
       LET l_npq.npq25=1
   END IF
#--->借方科目 (銀行存款)
   LET l_npq.npq02 = l_npq.npq02 + 1
   #No.FUN-680029 --begin
#  LET l_npq.npq03 = l_ala.ala776
   IF p_npptype = '0' THEN
      LET l_npq.npq03 = l_ala.ala776
   ELSE
      LET l_npq.npq03 = l_ala.ala779
   END IF
   #No.FUN-680029 --end
   #LET l_npq.npq04 = ''     #FUN-D10065  add
   LET l_npq.npq06 = '1'             #D/C
   LET l_npq.npq07f= l_ala.ala773
   LET l_npq.npq07 = l_ala.ala775
   IF cl_null(l_npq.npq07f) THEN
       LET l_npq.npq07f=0
   END IF
   IF cl_null(l_npq.npq07) THEN
       LET l_npq.npq07=0
   END IF
   #FUN-680019...............begin
   LET l_aag05 = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = l_npq.npq03
   # AND  aag00=g_bookno1       #No.FUN-730064   #No.FUN-B10150
     AND  aag00=g_bookno                         #No.FUN-B10150
   IF l_aag05 = 'Y' THEN
      LET l_npq.npq05 = t750_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
   ELSE
      LET l_npq.npq05 = ' '
   END IF
   #FUN-680019...............end
 
   #FUN-5C0015 06/02/15 BY GILL --START
  #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)       #No.FUN-730064    #No.FUN-B10150
   LET l_npq.npq04 = NULL #FUN-D10065 add
   CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)                          #No.FUN-B10150
   RETURNING l_npq.*
   #FUN-D10065--add--str--
   IF cl_null(l_npq.npq04) THEN
      LET l_npq.npq04 = ''
   END IF
   #FUN-D10065--add--end--
   CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
   #FUN-5C0015 06/02/15 BY GILL --END
 
   LET l_npq.npqlegal = g_legal  #FUN-980001
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN 
#  CALL cl_err('ins npq-1',STATUS,1) #No.FUN-660122
   CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,STATUS,"","ins npq-1",1)  #No.FUN-660122
   LET g_success = 'N'      #No.FUN-680029
   END IF
#--->借方科目 (轉費用)
   IF l_ala.ala777 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      #No.FUN-680029 --begin
#     LET l_npq.npq03 = l_ala.ala778
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_ala.ala778
      ELSE
         LET l_npq.npq03 = l_ala.ala780
      END IF
      #No.FUN-680029 --end
      #LET l_npq.npq04 = ''    #FUN-D10065  mark
      LET l_npq.npq06 = '1'
      LET l_npq.npq07f= 0
      LET l_npq.npq07 = l_ala.ala777
      IF cl_null(l_npq.npq07f) THEN
          LET l_npq.npq07f=0
      END IF
      IF cl_null(l_npq.npq07) THEN
          LET l_npq.npq07=0
      END IF
 
      #FUN-5C0015 06/02/15 BY GILL --START
     #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)       #No.FUN-730064    #No.FUN-B10150
      LET l_npq.npq04 = NULL #FUN-D10065 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)                          #No.FUN-B10150
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = ''
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34   #FUN-AA0087
      #FUN-5C0015 06/02/15 BY GILL --END
 
      #FUN-680019...............begin
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
      # AND  aag00=g_bookno1       #No.FUN-730064    #No.FUN-B10150
        AND  aag00=g_bookno                          #No.FUN-B10150
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t750_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      #FUN-680019...............end
 
      LET l_npq.npqlegal = g_legal  #FUN-980001
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq-2',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq00,STATUS,"","ins npq-2",1)  #No.FUN-660122
      LET g_success = 'N'      #No.FUN-680029
      END IF
   END IF
#--->貸方科目(銀行存款-原幣保證金)
   LET l_npq.npq02 = l_npq.npq02 + 1
   #No.FUN-680029 --begin
#  LET l_npq.npq03 = l_ala.ala41
   IF p_npptype = '0' THEN
      LET l_npq.npq03 = l_ala.ala41 
   ELSE
      LET l_npq.npq03 = l_ala.ala411
   END IF
   #No.FUN-680029 --end
   #LET l_npq.npq04 = ''   #FUN-D10065  mark
   LET l_npq.npq06 = '2'
   LET l_npq.npq07f= l_ala.ala773
   LET l_npq.npq07 = l_ala.ala775 + l_ala.ala777
   IF cl_null(l_npq.npq07f) THEN
       LET l_npq.npq07f=0
   END IF
   IF cl_null(l_npq.npq07) THEN
       LET l_npq.npq07=0
   END IF
 
   #FUN-5C0015 06/02/15 BY GILL --START
  #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)     #No.FUN-730064    #No.FUN-B10150
   LET l_npq.npq04 = NULL #FUN-D10065 add
   CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)                        #No.FUN-B10150
   RETURNING l_npq.*
   #FUN-D10065--add--str--
   IF cl_null(l_npq.npq04) THEN
      LET l_npq.npq04 = ''
   END IF
   #FUN-D10065--add--end--
   CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
   #FUN-5C0015 06/02/15 BY GILL --END
 
   #FUN-680019...............begin
   LET l_aag05 = ''
   SELECT aag05 INTO l_aag05 FROM aag_file
    WHERE aag01 = l_npq.npq03
   # AND  aag00=g_bookno1       #No.FUN-730064   #No.FUN-B10150
     AND  aag00=g_bookno                         #No.FUN-B10150
   IF l_aag05 = 'Y' THEN
      LET l_npq.npq05 = t750_set_npq05(l_ala.ala04,l_ala.ala930) #FUN-680019
   ELSE
      LET l_npq.npq05 = ' '
   END IF
   #FUN-680019...............end
 
   LET l_npq.npqlegal = g_legal  #FUN-980001
  #FUN-D40118 ---Add--- Start
   SELECT aag44 INTO l_aag44 FROM aag_file
    WHERE aag00 = g_bookno
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
  #FUN-D40118 ---Add--- End
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN 
#  CALL cl_err('ins npq-3',STATUS,1) #No.FUN-660122
   CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq00,STATUS,"","ins npq-3",1)  #No.FUN-660122
   LET g_success = 'N'      #No.FUN-680029
   END IF
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
#No.FUN-670060  --Begin
FUNCTION t750_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE l_apygslp1   LIKE apy_file.apygslp1  #No.FUN-680029
  DEFINE li_result    LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",  #FUN-A50102
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_ala.ala75,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre2 FROM l_sql
    DECLARE aba_cs2 CURSOR FOR aba_pre2
    OPEN aba_cs2
    FETCH aba_cs2 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_ala.ala75,'aap-991',1)
       RETURN
    END IF
 
    #開窗作業
    LET g_plant_new= g_apz.apz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
    LET g_plant_gl= g_apz.apz02p   #No.FUN-980059
 
    OPEN WINDOW t750p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("axrt200_p")
     
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("gl_no1",FALSE)
    END IF
    #No.FUN-680029 --end--
     
    INPUT l_apygslp,l_apygslp1 WITHOUT DEFAULTS FROM FORMONLY.gl_no,FORMONLY.gl_no1  #No.FUN-680029
    
       AFTER FIELD gl_no
#         CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_dbs_gl)        #TQC-9B0162 mark
          CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_plant_gl)      #TQC-9B0162
                RETURNING li_result,l_apygslp
          IF (NOT li_result) THEN
             NEXT FIELD gl_no
          END IF
 
       #No.FUN-680088 --start--
       AFTER FIELD gl_no1
#         CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_dbs_gl)       #TQC-9B0162 mark
          CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_plant_gl)     #TQC-9B0162
                RETURNING li_result,l_apygslp1
          IF (NOT li_result) THEN
             NEXT FIELD gl_no1
          END IF
       #No.FUN-680088 --end--
    
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT 
          END IF
          IF cl_null(l_apygslp) THEN
             CALL cl_err('','9033',0)
             NEXT FIELD gl_no  
          END IF
 
          #No.FUN-680088 --start--
          IF cl_null(l_apygslp1) AND g_aza.aza63 = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD gl_no1 
          END IF
          #No.FUN-680088 --end--
    
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
       ON ACTION CONTROLP
          IF INFIELD(gl_no) THEN
#            CALL q_m_aac(FALSE,TRUE,g_dbs_gl,l_apygslp,'1',' ',' ','AGL')    #No.FUN-980059
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp,'1',' ',' ','AGL')  #No.FUN-980059
             RETURNING l_apygslp
             DISPLAY l_apygslp TO FORMONLY.gl_no
             NEXT FIELD gl_no
          END IF
 
          #No.FUN-680088 --start--
          IF INFIELD(gl_no1) THEN
#            CALL q_m_aac(FALSE,TRUE,g_dbs_gl,l_apygslp1,'1',' ',' ','AGL')   #No.FUN-980059
             CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_apygslp1,'1',' ',' ','AGL') #No.FUN-980059
             RETURNING l_apygslp1
             DISPLAY l_apygslp1 TO FORMONLY.gl_no1
             NEXT FIELD gl_no1
          END IF
          #No.FUN-680088 --end--
    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
    
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
    
       ON ACTION exit  #加離開功能genero
          LET INT_FLAG = 1
          EXIT INPUT
 
    END INPUT
    CLOSE WINDOW t750p  
 
    IF INT_FLAG = 1 THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF cl_null(l_apygslp) OR (cl_null(l_apygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680029
       CALL cl_err(g_ala.ala01,'axr-070',1)
       RETURN
    END IF
    LET g_t1=s_get_doc_no(l_apygslp)
    LET g_wc_gl = 'npp01 = "',g_ala.ala01,'" AND npp011 =0 '
   #LET g_str="aapp800 '",g_wc_gl CLIPPED,"' '",g_plant,"' '7' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_t1,"' '",g_ala.ala08,"' 'Y' '0' 'Y' '",g_apz.apz02c,"' '",l_apygslp1,"'"   #No.FUN-680029 #MOD-C10130 mark
    LET g_str="aapp800 '",g_wc_gl CLIPPED,"' '",g_plant,"' '7' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_t1,"' '",g_ala.ala771,"' 'Y' '0' 'Y' '",g_apz.apz02c,"' '",l_apygslp1,"'"  #MOD-C10130 add
    CALL cl_cmdrun_wait(g_str)
    SELECT ala75 INTO g_ala.ala75 FROM ala_file where ala01 =g_ala.ala01
    DISPLAY BY NAME g_ala.ala75
    
END FUNCTION
 
FUNCTION t750_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102 
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_ala.ala75,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_ala.ala72,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp810 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_ala.ala75,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT ala75 INTO g_ala.ala75 FROM ala_file where ala01 =g_ala.ala01
    DISPLAY BY NAME g_ala.ala75
END FUNCTION
#No.FUN-670060  --End  
 
#FUN-680019...............begin
FUNCTION t750_set_npq05(p_dept,p_ala930)
DEFINE p_dept   LIKE gem_file.gem01,
       p_ala930 LIKE ala_file.ala930
       
   IF g_aaz.aaz90='Y' THEN
      RETURN p_ala930
   ELSE
      RETURN p_dept
   END IF
END FUNCTION
#FUN-680019...............end

#No.FUN-B10050  --Begin
FUNCTION t750_aag01(p_cmd,p_aag00,p_aag01,p_type)
    DEFINE p_cmd        LIKE type_file.chr1
    DEFINE p_aag00      LIKE aag_file.aag00
    DEFINE p_aag01      LIKE aag_file.aag01
    DEFINE p_type       LIKE type_file.chr1
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag03      LIKE aag_file.aag03
    DEFINE l_aag07      LIKE aag_file.aag07
    DEFINE l_acti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aag03,aag07,aagacti
      INTO l_aag02,l_aag03,l_aag07,l_acti
      FROM aag_file 
     WHERE aag00 = p_aag00
       AND aag01 = p_aag01

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-021'
         WHEN l_acti  ='N'         LET g_errno = '9028'
         WHEN l_aag07  = '1'       LET g_errno = 'agl-015'
         WHEN l_aag03 != '2'       LET g_errno = 'agl-201'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       CASE p_type
            WHEN '1'  DISPLAY l_aag02 TO FORMONLY.aag02
            WHEN '2'  DISPLAY l_aag02 TO FORMONLY.aag02c
            WHEN '3'  DISPLAY l_aag02 TO FORMONLY.aag02b
            WHEN '4'  DISPLAY l_aag02 TO FORMONLY.aag02d
       END CASE
    END IF
END FUNCTION
#No.FUN-B10050  --End  
