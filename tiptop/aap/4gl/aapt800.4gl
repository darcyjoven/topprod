# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aapt800.4gl
# Descriptions...: 提單作業
# Date & Author..: 96/01/10 By Roger
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# remark ........: ala26->提單金額 alb12,alb13->提單數量金額
# Modify.........: No.MOD-470303 04/07/28 By ching input construct 順序錯誤
# Modify.........: No.MOD-470303 04/07/28 By ching 費用欄位應可輸入
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-530830 05/03/29 By saki 金額做小數取位
# Modify.........: No.FUN-550030 05/05/23 By wujie 單據編號加大
# Modify.........: No.MOD-5B0265 05/11/24 By Smapmin aapt800已有到貨資料,提單卻可以取消確認
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-640020 06/04/25 By Smapmin 拿掉t800_y1()
# Modify.........: NO.FUN-640019 06/05/23 By rainy  拿掉由前8碼讀取LC檔ala03判斷
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-680019 06/08/09 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-690024 06/09/12 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/15 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti 
# Modify.........: No.FUN-680046 06/09/29 By jamie 1.FUNCTION t800_q() 一開始應清空g_als.*值
#                                                  2.新增action"相關文件"                                                   
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0055 06/10/26 By douzh l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By hellen 本原幣取位修改
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能			
# Modify.........: No.MOD-690072 06/12/05 By Smapmin 預購單號必須確認過後才可建立提單作業
# Modify.........: NO.FUN-710029 07/01/16 By Yiting 外購多單位
# Modify.........: No.MOD-720016 07/02/05 By Smapmin alt05應抓取單價取位
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790116 07/09/20 By Judy 點"運營中心切換"，錄入后切換不成功
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820156 08/02/26 By Smapmin 變數使用錯誤
# Modify.........: No.FUN-850038 08/05/09 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT ARRAY段漏了ON IDLE控制
# Modify.........: No.MOD-860305 08/07/08 By Sarah 預購單號(als03)應控卡,未輸入資料,不可輸單身資料
# Modify.........: No.MOD-870107 08/07/17 By Sarah 自動產生時,數量應扣除已存在於aapt800的數量
# Modify.........: No.MOD-940190 09/04/15 By Sarah 計算單身alt07(原幣金額)應改為alt87(計價數量)*alt05(原幣單價)
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alsplant該為als97 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: NO.FUN-990031 09/10/26 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下;开放营运中心可录
# Modify.........: NO.TQC-9B0069 09/11/23 By jan 拿掉4gl里alsoriu/alsorig兩個欄位的處理
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60056 10/06/22 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.TQC-AB0355 10/12/01 By chenying 加入 FIELD ORDER FORM 属性来解决set_no_entry字段,,mouse点击时当出的问题
# Modify.........: No.FUN-B10030 11/01/19 By Mengxw   Remove "switch_plant"action
# Modify.........: No.MOD-B30635 11/03/22 By Dido FUNCTION t800_set_du_by_origin 變數 l_ac 有誤 
# Modify.........: No.TQC-B40130 11/04/18 By yinhy "預購單號"有值的情況下，要檢查“廠商”和"付款條件”“"幣種"
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.MOD-BA0013 11/10/05 By Dido 檢核 aapt009 與 g_ala 變數抓取處理 
# Modify.........: No.FUN-BB0085 11/12/21 By xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.TQC-C20183 12/02/20 By xianghui 取消FUN-BB0085對AFTER FIELD alt86,alt87的處理,且做出額外處理
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao 單身無資料時提示是否刪除單頭 
# Modify.........: No.MOD-C50158 12/05/25 By Polly 調整抓取 l_tot 變數條件,增加 als_file 的 als03
# Modify.........: No.FUN-C30123 12/05/30 By Lori 部門編號(als04)旁應增加顯示部門名稱(gem02d)
# Modify.........: No.CHI-C30107 12/06/20 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C50149 12/07/03 By Elise 計算查詢筆數時增加考慮到單身的查詢條件(g_wc2)
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:MOD-C70311 12/08/03 By Polly 當分批到單時，應排除已確認的到貨資料
# Modify.........: No:CHI-C80041 12/12/18 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_als        RECORD LIKE als_file.*,
       g_als_t      RECORD LIKE als_file.*,
       g_als_o      RECORD LIKE als_file.*,
       g_als01_t    LIKE als_file.als01,
       g_ala        RECORD LIKE ala_file.*,
       b_alt        RECORD LIKE alt_file.*,
       g_alh        RECORD LIKE alh_file.*,
       g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
       g_statu             LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),       # 是否從新賦予等級
       g_dbs_gl            LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
       g_dbs_nm            LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
       nm_no_b,nm_no_e     LIKE type_file.num10,       # No.FUN-690028 INTEGER,
       gl_no_b,gl_no_e     LIKE oea_file.oea01,      # No.FUN-690028  VARCHAR(16),       #No.FUN-550030
       g_alt        DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        alt02              LIKE alt_file.alt02,
        alt14              LIKE alt_file.alt14,
        alt15              LIKE alt_file.alt15,
        alt11              LIKE alt_file.alt11,
        pmn041             LIKE pmn_file.pmn041,  #FUN-660117 #CHAR(30)
        alt83              LIKE alt_file.alt83, 
        alt84              LIKE alt_file.alt84,
        alt85              LIKE alt_file.alt85,
        alt80              LIKE alt_file.alt80,
        alt81              LIKE alt_file.alt81,
        alt82              LIKE alt_file.alt82,
        alt86              LIKE alt_file.alt86,
        alt87              LIKE alt_file.alt87,
        pmn07              LIKE pmn_file.pmn07,   #FUN-660117
        alt06              LIKE alt_file.alt06,
        alt05              LIKE alt_file.alt05,
        alt07              LIKE alt_file.alt07,
        alt930             LIKE alt_file.alt930,  #FUN-680019
        gem02c             LIKE gem_file.gem02,   #FUN-680019
        altud01            LIKE alt_file.altud01,
        altud02            LIKE alt_file.altud02,
        altud03            LIKE alt_file.altud03,
        altud04            LIKE alt_file.altud04,
        altud05            LIKE alt_file.altud05,
        altud06            LIKE alt_file.altud06,
        altud07            LIKE alt_file.altud07,
        altud08            LIKE alt_file.altud08,
        altud09            LIKE alt_file.altud09,
        altud10            LIKE alt_file.altud10,
        altud11            LIKE alt_file.altud11,
        altud12            LIKE alt_file.altud12,
        altud13            LIKE alt_file.altud13,
        altud14            LIKE alt_file.altud14,
        altud15            LIKE alt_file.altud15
                    END RECORD,
       g_alt_t      RECORD                 #程式變數 (舊值)
        alt02              LIKE alt_file.alt02,
        alt14              LIKE alt_file.alt14,
        alt15              LIKE alt_file.alt15,
        alt11              LIKE alt_file.alt11,
        pmn041             LIKE pmn_file.pmn041,   #FUN-660117 #CHAR(30)
        alt83              LIKE alt_file.alt83, 
        alt84              LIKE alt_file.alt84,
        alt85              LIKE alt_file.alt85,
        alt80              LIKE alt_file.alt80,
        alt81              LIKE alt_file.alt81,
        alt82              LIKE alt_file.alt82,
        alt86              LIKE alt_file.alt86,
        alt87              LIKE alt_file.alt87,
        pmn07              LIKE pmn_file.pmn07,    #FUN-660117
        alt06              LIKE alt_file.alt06,
        alt05              LIKE alt_file.alt05,
        alt07              LIKE alt_file.alt07,
        alt930             LIKE alt_file.alt930,   #FUN-680019
        gem02c             LIKE gem_file.gem02,    #FUN-680019
        altud01            LIKE alt_file.altud01,
        altud02            LIKE alt_file.altud02,
        altud03            LIKE alt_file.altud03,
        altud04            LIKE alt_file.altud04,
        altud05            LIKE alt_file.altud05,
        altud06            LIKE alt_file.altud06,
        altud07            LIKE alt_file.altud07,
        altud08            LIKE alt_file.altud08,
        altud09            LIKE alt_file.altud09,
        altud10            LIKE alt_file.altud10,
        altud11            LIKE alt_file.altud11,
        altud12            LIKE alt_file.altud12,
        altud13            LIKE alt_file.altud13,
        altud14            LIKE alt_file.altud14,
        altud15            LIKE alt_file.altud15
                    END RECORD 
DEFINE g_buf        LIKE type_file.chr1000      #  #No.FUN-690028 VARCHAR(78)
DEFINE g_tot        LIKE type_file.num20_6      # No.FUN-690028 DEC(20,6),  #FUN-4B0079
DEFINE g_rec_b      LIKE type_file.num5         #單身筆數  #No.FUN-690028 SMALLINT
DEFINE z            LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1),
DEFINE l_ac         LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
DEFINE g_forupd_sql STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5 #No.FUN-690028 SMALLINT
DEFINE g_cnt        LIKE type_file.num10        #No.FUN-690028 INTEGER
DEFINE g_i          LIKE type_file.num5         #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000      #No.FUN-690028 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10        #No.FUN-690028 INTEFER
DEFINE g_curs_index LIKE type_file.num10        #No.FUN-690028 INTEGER
DEFINE g_jump       LIKE type_file.num10        #No.FUN-690028 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5         #No.FUN-690028 SMALLINT
DEFINE g_img09      LIKE img_file.img09,
       g_ima25      LIKE ima_file.ima25,
       g_ima44      LIKE ima_file.ima44,
       g_ima31      LIKE ima_file.ima31,
       g_ima906     LIKE ima_file.ima906,
       g_ima907     LIKE ima_file.ima907,
       g_ima908     LIKE ima_file.ima908,
       g_factor     LIKE pmn_file.pmn09,
       g_tot1       LIKE img_file.img10,
       g_qty        LIKE img_file.img10,
       g_flag       LIKE type_file.chr1
DEFINE g_alt80_t    LIKE alt_file.alt80        #FUN-BB0085
DEFINE g_alt83_t    LIKE alt_file.alt83        #FUN-BB0085
#DEFINE g_alt86_t    LIKE alt_file.alt86        #FUN-BB0085   #TQC-C20183
DEFINE g_gem02d     LIKE gem_file.gem02         #No.FUN-C30123 add 
DEFINE g_void       LIKE type_file.chr1      #CHI-C80041

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT #No.FUN-6A0055
 
   OPTIONS
      INPUT NO WRAP,
      FIELD ORDER FORM     #TQC-AB0355 add
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 
   LET p_row = 1 LET p_col = 2
 
   OPEN WINDOW t800_w AT p_row,p_col WITH FORM "aap/42f/aapt800"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL t800_def_form()
 
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("als04",TRUE)
   END IF
   CALL cl_set_comp_visible("als930,gem02b,alt930,gem02c,",g_aaz.aaz90='Y')
 
   CALL t800()
   CLOSE WINDOW t800_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION t800()
   LET g_plant_new=g_apz.apz04p
   CALL s_getdbs()
   LET g_dbs_nm=g_dbs_new
   IF cl_null(g_dbs_nm) THEN LET g_dbs_nm = NULL END IF
   LET g_plant_new=g_apz.apz02p
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
   IF cl_null(g_dbs_gl) THEN LET g_dbs_gl = NULL END IF
 
   INITIALIZE g_als.* TO NULL
   INITIALIZE g_als_t.* TO NULL
   INITIALIZE g_als_o.* TO NULL
   CALL t800_lock_cur()
   WHILE TRUE
      LET g_action_choice = ""
      CALL t800_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
   END WHILE
END FUNCTION
 
FUNCTION t800_lock_cur()
 
   LET g_forupd_sql = "SELECT * FROM als_file WHERE als01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t800_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION t800_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM
   CALL g_alt.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
   INITIALIZE g_als.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON
         als97,als01,als03,alsfirm,als02,                              #No.FUN-980017
         als05,als06,als11,als13,
         als10,als04,als930,als07,als21,als22,als23,als08,als09,als14, #FUN-680019
         als31,als32,als33,als34,als35,als36,
         als41,als42,als43,als44,als45,als46,
         als41m,als42m,als43m,als44m,als45m,als46m
         ,alsud01,alsud02,alsud03,alsud04,alsud05,
         alsud06,alsud07,alsud08,alsud09,alsud10,
         alsud11,alsud12,alsud13,alsud14,alsud15
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(als03) # L/C
               CALL q_ala(TRUE,TRUE,g_als.als03) RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO als03
            WHEN INFIELD(als05) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc"
               LET g_qryparam.default1 = g_als.als05
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO als05
            WHEN INFIELD(als06) #PAY TO VENDOR
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc"
               LET g_qryparam.default1 = g_als.als06
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO als06
            WHEN INFIELD(als10) # CURRENCY
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pma"
               LET g_qryparam.default1 = g_als.als10
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO als10
            WHEN INFIELD(als11) # CURRENCY
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_als.als11
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO als11
            WHEN INFIELD(als04) # Dept CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               LET g_qryparam.default1 = g_als.als04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO als04

               #FUN-C30123-add begin---
               IF NOT cl_null(g_als.als04) THEN
                  SELECT gem02 INTO g_gem02d FROM gem_file WHERE gem01= g_als.als04
               ELSE
                  LET g_gem02d = null
               END IF
               DISPLAY g_gem02d TO FORMONLY.gem02d
               NEXT FIELD als04
               #FUN-C30123-add end-----
            WHEN INFIELD(als930)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem4"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO als930
               NEXT FIELD als930
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
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
 
   IF INT_FLAG THEN RETURN END IF
   CONSTRUCT g_wc2 ON alt02,alt14,alt15,alt11,
                      alt83,alt84,alt85,alt80,alt81,alt82,alt86,alt87,  #FUN-710029
                      alt06
                      ,altud01,altud02,altud03,altud04,altud05
                      ,altud06,altud07,altud08,altud09,altud10
                      ,altud11,altud12,altud13,altud14,altud15
           FROM s_alt[1].alt02,s_alt[1].alt14,s_alt[1].alt15,s_alt[1].alt11,
                s_alt[1].alt83,s_alt[1].alt84,s_alt[1].alt85,s_alt[1].alt80,  #FUN-710029
                s_alt[1].alt81,s_alt[1].alt82,s_alt[1].alt86,s_alt[1].alt87,  #FUN-710029
                s_alt[1].alt06
               ,s_alt[1].altud01,s_alt[1].altud02,s_alt[1].altud03
               ,s_alt[1].altud04,s_alt[1].altud05,s_alt[1].altud06
               ,s_alt[1].altud07,s_alt[1].altud08,s_alt[1].altud09
               ,s_alt[1].altud10,s_alt[1].altud11,s_alt[1].altud12
               ,s_alt[1].altud13,s_alt[1].altud14,s_alt[1].altud15
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
		
      ON ACTION controlp
         CASE
            WHEN INFIELD(alt80)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gfe"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO alt80
               NEXT FIELD alt80
            WHEN INFIELD(alt86)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gfe"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO alt86
               NEXT FIELD alt86
            WHEN INFIELD(alt930)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_gem4"
               LET g_qryparam.state = "c"   #多選
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO alt930
               NEXT FIELD alt930
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
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('alsuser', 'alsgrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT als01 FROM als_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY als01"
   ELSE
     #LET g_sql="SELECT als01 FROM als_file,alt_file ",       #MOD-C50149 mark
      LET g_sql="SELECT UNIQUE als01 ",                       #MOD-C50149 add
                "  FROM als_file,alt_file ",                  #MOD-C50149 add
                " WHERE als01=alt01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY als01"
   END IF
   PREPARE t800_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t800_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t800_prepare

   IF g_wc2=' 1=1' THEN                                                 #MOD-C50149 add 
      LET g_sql= "SELECT COUNT(*) FROM als_file WHERE ",g_wc CLIPPED
   ELSE                                                                 #MOD-C50149 add
      LET g_sql= "SELECT COUNT(*) FROM als_file,alt_file ",             #MOD-C50149 add
                 " WHERE als01 = alt01 ",                               #MOD-C50149 add
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED           #MOD-C50149 add
   END IF                                                               #MOD-C50149 add
   PREPARE t800_precount FROM g_sql
   DECLARE t800_count CURSOR FOR t800_precount
END FUNCTION
 
FUNCTION t800_menu()
 
   WHILE TRUE
      CALL t800_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t800_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t800_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t800_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t800_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t800_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t800_out('a')
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_alt),'','')
             END IF
 
         WHEN "expense_data"
            IF cl_chk_act_auth() THEN
               CALL t800_v()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t800_firm1()
               #CALL cl_set_field_pic(g_als.alsfirm,"","","","","") #CHI-C80041
               IF g_als.alsfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
               CALL cl_set_field_pic(g_als.alsfirm,"","","",g_void,"") #CHI-C80041
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t800_firm2()
               #CALL cl_set_field_pic(g_als.alsfirm,"","","","","") #CHI-C8004
               IF g_als.alsfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
               CALL cl_set_field_pic(g_als.alsfirm,"","","",g_void,"") #CHI-C80041
            END IF
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t800_m()
            END IF
         #--FUN-B10030--start--
         # WHEN "switch_plant"
         #   CALL t800_d()
         #--FUN-B10030--end--  
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_als.als01 IS NOT NULL THEN
                 LET g_doc.column1 = "als01"
                 LET g_doc.value1 = g_als.als01
                 CALL cl_doc()
               END IF
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t800_x()
               IF g_als.alsfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_als.alsfirm,"","","",g_void,"")   
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
      CLOSE t800_cs
END FUNCTION
 
FUNCTION t800_a()
   IF s_aapshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_alt.clear()
   INITIALIZE g_als.* LIKE als_file.*
   LET g_als_t.* = g_als.*
   LET g_als01_t = NULL
   LET g_als.als97=g_plant                    #No.FUN-980017
   LET g_als.als02 = g_today
   LET g_als.als12 = 1
   LET g_als.als13 = 0
   LET g_als.alsfirm = 'N'
   LET g_als.als04=g_grup #FUN-680019
   LET g_als.als930=s_costcenter(g_als.als04) #FUN-680019
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_als.alsacti ='Y'                   # 有效的資料
      LET g_als.alsuser = g_user
      LET g_als.alsgrup = g_grup               # 使用者所屬群
      LET g_als.alsdate = g_today
      LET g_als.alsinpd = g_today
      LET g_als.alslegal = g_legal   #FUN-980001
      CALL t800_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_als.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_alt.clear()
         EXIT WHILE
      END IF
      IF g_als.als01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      LET g_als.alsoriu = g_user      #No.FUN-980030 10/01/04
      LET g_als.alsorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO als_file VALUES(g_als.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","als_file",g_als.als01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      ELSE
         LET g_als_t.* = g_als.*               # 保存上筆資料
         SELECT als01 INTO g_als.als01 FROM als_file
          WHERE als01 = g_als.als01
      END IF
      FOR g_i = 1 TO g_alt.getLength() INITIALIZE g_alt[g_i].* TO NULL END FOR
      LET g_rec_b = 0                    #No.FUN-680064
      CALL t800_b('0')
      IF NOT cl_null(g_als.als01) THEN  #CHI-C30002 add
         IF cl_confirm('aap-126') THEN CALL t800_out('a') END IF
      END IF          #CHI-C30002 add
      CALL t800_firm1()
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t800_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
       l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
       g_t1            LIKE oay_file.oayslip,  #No.FUN-550030  #No.FUN-690028 VARCHAR(5)
       l_dept          LIKE als_file.als04,    #Dept  #FUN-660117 #CHAR(10)
       l_amt           LIKE type_file.num20_6, # No.FUN-690028 DEC(20,6),  #FUN-4B0079
       l_cnt           LIKE type_file.num5,    #No.FUN-690028 SMALLINT
       l_pmc03         LIKE pmc_file.pmc03,
       l_pmc03b        LIKE pmc_file.pmc03,
       l_n             LIKE type_file.num5     #No.FUN-690028 SMALLINT
 
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
    INPUT BY NAME #g_als.alsoriu,g_als.alsorig,    #FUN-99003新增時報,這兩個欄位不在畫面上  
        g_als.als97,g_als.als01,g_als.als03,g_als.alsfirm,g_als.als02,        #No.FUN-980017
        g_als.als05,g_als.als06,g_als.als11,g_als.als13,
        g_als.als10,g_als.als04,g_als.als930,g_als.als07,g_als.als21, #FUN-680019
        g_als.als22,g_als.als23,g_als.als08,g_als.als09,g_als.als14,
        g_als.als31,g_als.als32,g_als.als33,g_als.als34,g_als.als35,g_als.als36,
        g_als.als41,g_als.als42,g_als.als43,g_als.als44,g_als.als45,g_als.als46,
        g_als.als41m,g_als.als42m,g_als.als43m,g_als.als44m,
        g_als.als45m,g_als.als46m
        ,g_als.alsud01,g_als.alsud02,g_als.alsud03,g_als.alsud04,
        g_als.alsud05,g_als.alsud06,g_als.alsud07,g_als.alsud08,
        g_als.alsud09,g_als.alsud10,g_als.alsud11,g_als.alsud12,
        g_als.alsud13,g_als.alsud14,g_als.alsud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t800_set_entry(p_cmd)
         CALL t800_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
  
        AFTER FIELD als97
          IF NOT cl_null(g_als.als97) THEN
             SELECT count(*) INTO l_n FROM azw_file WHERE azw01 = g_als.als97
                AND azw02 = g_legal
             IF l_n = 0 THEN
               CALL cl_err('sel_azw','agl-171',0)
               NEXT FIELD als97
             END IF
          END IF
 
        AFTER FIELD als01
           IF NOT cl_null(g_als.als01) THEN
              IF (g_als.als01 != g_als01_t) OR (g_als01_t IS NULL) THEN
                 SELECT count(*) INTO g_cnt FROM als_file
                  WHERE als01 = g_als.als01
                 IF g_cnt > 0 THEN                   # 資料重複
                    CALL cl_err(g_als.als01,-239,0)
                    LET g_als.als01 = g_als01_t
                    DISPLAY BY NAME g_als.als01
                    NEXT FIELD als01
                 END IF
              END IF
 

              INITIALIZE g_alh.* TO NULL
              SELECT * INTO g_alh.* FROM alh_file
               WHERE alh30=g_als.als01 AND alh00='1'
              IF STATUS=0 AND p_cmd='a' THEN
                 LET g_als.als04=g_alh.alh04
                 LET g_als.als10=g_alh.alh10
                 LET g_als.als03=g_alh.alh03
                 LET g_als.als05=g_alh.alh05
                 DISPLAY BY NAME g_als.als04,g_als.als10,g_als.als03,g_als.als05
                 #FUN-C30123-add begin---
                 IF NOT cl_null(g_als.als04) THEN
                    SELECT gem02 INTO g_gem02d FROM gem_file WHERE gem01= g_als.als04
                 ELSE
                    LET g_gem02d = null
                 END IF
                 DISPLAY g_gem02d TO FORMONLY.gem02d
                 #FUN-C30123-add end----
              END IF
           END IF
 
        AFTER FIELD als04
           IF NOT cl_null(g_als.als04) THEN
              IF g_als_o.als04 IS NULL OR g_als.als04 != g_als_o.als04 THEN
                 CALL t800_als04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_als.als04,g_errno,0)
                    LET g_als.als04 = g_als_o.als04
                    DISPLAY BY NAME g_als.als04
                    NEXT FIELD als04
                 END IF
                 #FUN-C30123-add begin---
                 IF NOT cl_null(g_als.als04) THEN
                    SELECT gem02 INTO g_gem02d FROM gem_file WHERE gem01= g_als.als04
                 ELSE
                    LET g_gem02d = null
                 END IF
                 DISPLAY g_gem02d TO FORMONLY.gem02d
                 #FUN-C30123-add end----
              END IF
              LET g_als_o.als04 = g_als.als04
           END IF
 
        AFTER FIELD als10
           IF NOT cl_null(g_als.als10) THEN
              SELECT COUNT(*) INTO l_cnt FROM pma_file
               WHERE pma01=g_als.als10  AND pma11 IN ('2','3','4','6','7','8')
              IF STATUS OR l_cnt = 0 THEN
                 CALL cl_err('sel pma:','aap-016',0)
                 NEXT FIELD als10 
              END IF
              #No.TQC-B40130  --Begin
              IF NOT cl_null(g_als.als03) THEN
                 SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_als.als03 #MOD-BA0013
                 IF g_als.als10 <> g_ala.ala02 THEN
                    CALL cl_err(g_als.als10,'aapt010',0)
                    LET g_als.als10 = g_als_t.als10
                    NEXT FIELD als10 
                 END IF
              END IF
              #No.TQC-B40130  --End
           END IF
 
        AFTER FIELD als03
           IF NOT cl_null(g_als.als03) THEN
              INITIALIZE g_ala.* TO NULL
              IF g_als.als03 IS NOT NULL THEN
                 SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_als.als03
                 IF STATUS THEN
                    CALL cl_err3("sel","ala_file",g_als.als03,"",STATUS,"","sel ala:",1)  #No.FUN-660122
                    NEXT FIELD als03 
                 END IF
                 IF g_ala.alafirm <> 'Y' THEN   #MOD-690072
                    CALL cl_err("alafirm<>'Y'",'aap-084',0) NEXT FIELD als03   #MOD-690072
                 END IF
                 IF p_cmd='a' OR g_als_t.als03 != g_als.als03 THEN
                    LET g_als.als05=g_ala.ala05
                    LET g_als.als06=g_ala.ala06
                    LET g_als.als11=g_ala.ala20
                    LET g_als.als10=g_ala.ala02
                    LET g_als.als04=g_ala.ala04
                    IF g_als.als05 <> g_als_t.als05 THEN
                       SELECT pmc03 INTO l_pmc03 FROM pmc_file
                        WHERE pmc01=g_als.als05
                       DISPLAY l_pmc03 TO FORMONLY.pmc03
                    END IF
                    IF g_als.als06 <> g_als_t.als06 THEN
                       SELECT pmc03 INTO l_pmc03b FROM pmc_file
                        WHERE pmc01=g_als.als06
                       DISPLAY l_pmc03b TO FORMONLY.pmc03b
                    END IF
                    IF g_als.als11 <> g_als_t.als11 THEN
                       CALL s_curr3(g_als.als11,g_als.als02,g_apz.apz33) #FUN-640022
                       RETURNING g_als.als12
                       DISPLAY BY NAME g_als.als12
                    END IF
                    DISPLAY BY NAME g_als.als05,g_als.als06,g_als.als11,
                                    g_als.als10,g_als.als04
                    #FUN-C30123-add begin---
                    IF NOT cl_null(g_als.als04) THEN
                       SELECT gem02 INTO g_gem02d FROM gem_file WHERE gem01= g_als.als04
                    ELSE
                       LET g_gem02d = null
                    END IF
                    DISPLAY g_gem02d TO FORMONLY.gem02d
                    #FUN-C30123-add end----
                 END IF
              END IF
           END IF
 
        AFTER FIELD als05
           IF NOT cl_null(g_als.als05) THEN
              CALL t800_als05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_als.als05,g_errno,0)
                 LET g_als.als05 = g_als_t.als05
                 DISPLAY BY NAME g_als.als05
                 NEXT FIELD als05
              END IF
              #No.TQC-B40130  --Begin
              IF NOT cl_null(g_als.als03) THEN
                 SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_als.als03 #MOD-BA0013
                 IF g_als.als05 <> g_ala.ala05 THEN
                    CALL cl_err(g_als.als05,'aapt007',0)
                    LET g_als.als05 = g_als_t.als05
                    NEXT FIELD als05 
                 END IF
              END IF
              #No.TQC-B40130  --End
           END IF
              
 
        AFTER FIELD als06
           IF NOT cl_null(g_als.als06) THEN
              CALL t800_als06('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_als.als06,g_errno,0)
                 LET g_als.als06 = g_als_t.als06
                 DISPLAY BY NAME g_als.als06
                 NEXT FIELD als06
              END IF
              #No.TQC-B40130  --Begin
              IF NOT cl_null(g_als.als03) THEN
                 SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_als.als03 #MOD-BA0013
                 IF g_als.als06 <> g_ala.ala06 THEN
                    CALL cl_err(g_als.als06,'aapt008',0)
                    LET g_als.als06 = g_als_t.als06
                    NEXT FIELD als06 
                 END IF
              END IF
              #No.TQC-B40130  --End
           END IF
 
        AFTER FIELD als11
           IF NOT cl_null(g_als.als11) THEN
              SELECT azi02 INTO g_buf FROM azi_file WHERE azi01=g_als.als11
              IF STATUS THEN
                 CALL cl_err3("sel","azi_file",g_als.als11,"",STATUS,"","sel azi:",1)  #No.FUN-660122
                 NEXT FIELD als11
              END IF
              #No.TQC-B40130  --Begin
              IF NOT cl_null(g_als.als03) THEN
                 SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_als.als03 #MOD-BA0013
                 IF g_als.als11 <> g_ala.ala20 THEN     #MOD-BA0013 mod ala11 - > ala20
                    CALL cl_err(g_als.als11,'aapt009',0)
                    LET g_als.als11 = g_als_t.als11
                    NEXT FIELD als11 
                 END IF
              END IF
              #No.TQC-B40130  --End
           END IF
 
        AFTER FIELD als31
           LET g_als.als31 = cl_digcut(g_als.als31,g_azi04)
           DISPLAY BY NAME g_als.als31
 
        AFTER FIELD als32
           LET g_als.als32 = cl_digcut(g_als.als32,g_azi04)
           DISPLAY BY NAME g_als.als32
 
        AFTER FIELD als33
           LET g_als.als33 = cl_digcut(g_als.als33,g_azi04)
           DISPLAY BY NAME g_als.als33
 
        AFTER FIELD als34
           LET g_als.als34 = cl_digcut(g_als.als34,g_azi04)
           DISPLAY BY NAME g_als.als34
 
        AFTER FIELD als35
           LET g_als.als35 = cl_digcut(g_als.als35,g_azi04)
           DISPLAY BY NAME g_als.als35
 
        AFTER FIELD als36
           LET g_als.als36 = cl_digcut(g_als.als36,g_azi04)
           DISPLAY BY NAME g_als.als36
 
        AFTER FIELD als41
           LET g_als.als41 = cl_digcut(g_als.als41,g_azi04)
           DISPLAY BY NAME g_als.als41
 
        AFTER FIELD als42
           LET g_als.als42 = cl_digcut(g_als.als42,g_azi04)
           DISPLAY BY NAME g_als.als42
 
        AFTER FIELD als43
           LET g_als.als43 = cl_digcut(g_als.als43,g_azi04)
           DISPLAY BY NAME g_als.als43
 
        AFTER FIELD als44
           LET g_als.als44 = cl_digcut(g_als.als44,g_azi04)
           DISPLAY BY NAME g_als.als44
 
        AFTER FIELD als45
           LET g_als.als45 = cl_digcut(g_als.als45,g_azi04)
           DISPLAY BY NAME g_als.als45
 
        AFTER FIELD als46
           LET g_als.als46 = cl_digcut(g_als.als46,g_azi04)
           DISPLAY BY NAME g_als.als46
         
        AFTER FIELD als930 
           IF NOT s_costcenter_chk(g_als.als930) THEN
              LET g_als.als930=g_als_t.als930
              DISPLAY BY NAME g_als.als930
              DISPLAY NULL TO FORMONLY.gem02b
              NEXT FIELD als930
           ELSE
              DISPLAY s_costcenter_desc(g_als.als930) TO FORMONLY.gem02b
           END IF
 
        AFTER FIELD alsud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alsud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_als.alsuser = s_get_data_owner("als_file") #FUN-C10039
           LET g_als.alsgrup = s_get_data_group("als_file") #FUN-C10039
           LET l_flag='N'
           IF INT_FLAG THEN EXIT INPUT END IF
           IF cl_null(g_als.als31) THEN LET g_als.als31=0 END IF   #85-10-18
           IF cl_null(g_als.als32) THEN LET g_als.als32=0 END IF
           IF cl_null(g_als.als33) THEN LET g_als.als33=0 END IF
           IF cl_null(g_als.als34) THEN LET g_als.als34=0 END IF
           IF cl_null(g_als.als35) THEN LET g_als.als35=0 END IF
           IF cl_null(g_als.als36) THEN LET g_als.als36=0 END IF
           IF cl_null(g_als.als41) THEN LET g_als.als41=0 END IF   #85-10-18
           IF cl_null(g_als.als42) THEN LET g_als.als42=0 END IF
           IF cl_null(g_als.als43) THEN LET g_als.als43=0 END IF
           IF cl_null(g_als.als44) THEN LET g_als.als44=0 END IF
           IF cl_null(g_als.als45) THEN LET g_als.als45=0 END IF
           IF cl_null(g_als.als46) THEN LET g_als.als46=0 END IF
 
        ON KEY(F1)
           NEXT FIELD als01
 
        ON KEY(F2)
           NEXT FIELD als05
 

        ON ACTION controlp
           CASE
              WHEN INFIELD(als03) # L/C
                 CALL q_ala(FALSE,TRUE,g_als.als03) RETURNING g_als.als03
                 DISPLAY BY NAME g_als.als03
              WHEN INFIELD(als05) #PAY TO VENDOR
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc"
                 LET g_qryparam.default1 = g_als.als05
                 CALL cl_create_qry() RETURNING g_als.als05
                 DISPLAY BY NAME g_als.als05
                 CALL t800_als05('d')
              WHEN INFIELD(als06) #PAY TO VENDOR
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc"
                 LET g_qryparam.default1 = g_als.als06
                 CALL cl_create_qry() RETURNING g_als.als06
                 DISPLAY BY NAME g_als.als06
                 CALL t800_als06('d')
              WHEN INFIELD(als10) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pma"
                 LET g_qryparam.default1 = g_als.als10
                 CALL cl_create_qry() RETURNING g_als.als10
                 DISPLAY BY NAME g_als.als10
              WHEN INFIELD(als11) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_als.als11
                 CALL cl_create_qry() RETURNING g_als.als11
                 DISPLAY BY NAME g_als.als11
              WHEN INFIELD(als04) # Dept CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_als.als04
                 CALL cl_create_qry() RETURNING g_als.als04
                 DISPLAY BY NAME g_als.als04

                 #FUN-C30123-add begin---
                 IF NOT cl_null(g_als.als04) THEN
                    SELECT gem02 INTO g_gem02d FROM gem_file WHERE gem01= g_als.als04
                 ELSE
                    LET g_gem02d = null
                 END IF
                 DISPLAY g_gem02d TO FORMONLY.gem02d
                 NEXT FIELD als04
                 #FUN-C30123-add end-----
              WHEN INFIELD(als930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_als.als930
                 DISPLAY BY NAME g_als.als930
                 NEXT FIELD als930
              OTHERWISE EXIT CASE
           END CASE
 
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
 
FUNCTION t800_als04(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_gemacti LIKE gem_file.gemacti
    DEFINE l_dept     LIKE als_file.als04    #Dept  #FUN-660117
 
    SELECT gemacti INTO l_gemacti
      FROM gem_file WHERE gem01 = g_als.als04
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
         WHEN l_gemacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    IF p_cmd != 'a' THEN RETURN END IF
    IF g_apz.apz13 = 'Y' THEN
       LET l_dept = g_als.als04
    ELSE
       LET l_dept = ' '
    END IF
END FUNCTION
 
FUNCTION t800_als05(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_pmc05   LIKE pmc_file.pmc05
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmc22   LIKE pmc_file.pmc22
    DEFINE l_pmc30   LIKE pmc_file.pmc30
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmc05,pmc22,pmc30,pmcacti
           INTO l_pmc03,l_pmc05,l_pmc22,l_pmc30,l_pmcacti FROM pmc_file
           WHERE pmc01 = g_als.als05
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038' 
         WHEN l_pmc05   = '0'     LET g_errno = 'aap-032'    #No.FUN-690025
         WHEN l_pmc05   = '3'     LET g_errno = 'aap-033'    #No.FUN-690025
         WHEN l_pmc30   = '1'     LET g_errno = 'aap-103'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    DISPLAY l_pmc03 TO FORMONLY.pmc03
END FUNCTION
 
FUNCTION t800_als06(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmcacti
           INTO l_pmc03,l_pmcacti FROM pmc_file
           WHERE pmc01 = g_als.als06
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-000'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    DISPLAY l_pmc03 TO FORMONLY.pmc03b
END FUNCTION
 
FUNCTION t800_als11(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
    DEFINE l_aziacti LIKE azi_file.aziacti
 
    SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = g_als.als11
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
         WHEN l_aziacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF g_als.als12 = 1 AND g_als.als11 != g_aza.aza17 THEN
       CALL s_curr3(g_als.als11,g_als.als02,g_apz.apz33) RETURNING g_als.als12 #FUN-640022
    END IF
END FUNCTION
 
FUNCTION t800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_als.* TO NULL              #FUN-680046
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t800_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_alt.clear()
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t800_count
    FETCH t800_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t800_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_als.als01,SQLCA.sqlcode,0)
       INITIALIZE g_als.* TO NULL
    ELSE
       CALL t800_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t800_fetch(p_flals)
    DEFINE
        p_flals          LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flals
        WHEN 'N' FETCH NEXT     t800_cs INTO g_als.als01
        WHEN 'P' FETCH PREVIOUS t800_cs INTO g_als.als01
        WHEN 'F' FETCH FIRST    t800_cs INTO g_als.als01
        WHEN 'L' FETCH LAST     t800_cs INTO g_als.als01
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
            FETCH ABSOLUTE g_jump t800_cs INTO g_als.als01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_als.als01,SQLCA.sqlcode,0)
       INITIALIZE g_als.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flals
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_als.* FROM als_file       # 重讀DB,因TEMP有不被更新特性
     WHERE als01 = g_als.als01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","als_file",g_als.als01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
       LET g_data_owner = g_als.alsuser     #No.FUN-4C0047
       LET g_data_group = g_als.alsgrup     #No.FUN-4C0047
       CALL t800_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t800_show()
   LET g_als_t.* = g_als.*
   DISPLAY BY NAME  #g_als.alsoriu,g_als.alsorig, #TQC-9B0069
        g_als.als97,g_als.als01,g_als.als03,g_als.alsfirm,g_als.als02,         #No.FUN-980017
        g_als.als05,g_als.als06,g_als.als11,g_als.als13,
        g_als.als04,g_als.als930,g_als.als10,g_als.als07,g_als.als21, #FUN-680019
        g_als.als22,g_als.als23,g_als.als08,g_als.als09,g_als.als14,
        g_als.als31,g_als.als32,g_als.als33,g_als.als34,g_als.als35,g_als.als36,
        g_als.als41,g_als.als42,g_als.als43,g_als.als44,g_als.als45,g_als.als46,
        g_als.als41m,g_als.als42m,g_als.als43m,g_als.als44m,
        g_als.als45m,g_als.als46m
        ,g_als.alsud01,g_als.alsud02,g_als.alsud03,g_als.alsud04,
        g_als.alsud05,g_als.alsud06,g_als.alsud07,g_als.alsud08,
        g_als.alsud09,g_als.alsud10,g_als.alsud11,g_als.alsud12,
        g_als.alsud13,g_als.alsud14,g_als.alsud15 
   CALL t800_als05('d')
   CALL t800_als06('d')
   CALL t800_b_tot('d')
   CALL t800_b_fill(g_wc2)
   #CALL cl_set_field_pic(g_als.alsfirm,"","","","","") #CHI-C80041
   IF g_als.alsfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_als.alsfirm,"","","",g_void,"") #CHI-C80041

   #FUN-C30123-add begin---
   IF NOT cl_null(g_als.als04) THEN
      SELECT gem02 INTO g_gem02d FROM gem_file WHERE gem01= g_als.als04
   ELSE
      LET g_gem02d = null
   END IF
   DISPLAY g_gem02d TO FORMONLY.gem02d
   #FUN-C30123-add end-----

   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t800_u()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_als.als01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_als.* FROM als_file
    WHERE als01=g_als.als01
   IF g_als.alsfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_als.alsfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_als.alsacti ='N' THEN CALL cl_err(g_als.als01,'9027',0) RETURN END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   OPEN t800_cl USING g_als.als01
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t800_cl INTO g_als.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_als.als01,SQLCA.sqlcode,0)
      ROLLBACK WORK RETURN
   END IF
   LET g_als01_t = g_als.als01
   LET g_als_o.*=g_als.*
   LET g_als.alsmodu=g_user                     #修改者
   LET g_als.alsdate = g_today                  #修改日期
   CALL t800_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t800_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_als.*=g_als_t.*
         #FUN-C30123-add begin---
         IF NOT cl_null(g_als.als04) THEN
            SELECT gem02 INTO g_gem02d FROM gem_file WHERE gem01= g_als.als04
            DISPLAY g_gem02d TO FORMONLY.gem02d
         ELSE
            LET g_gem02d = null
         END IF
         DISPLAY g_gem02d TO FORMONLY.gem02d
         #FUN-C30123-add end-----
         CALL t800_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE als_file SET als_file.* = g_als.*    # 更新DB
       WHERE als01 = g_als01_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","als_file",g_als01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      END IF
      CALL t800_b_tot('d')
      EXIT WHILE
   END WHILE
   CLOSE t800_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t800_v()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_als.als01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_als.* FROM als_file
    WHERE als01=g_als.als01
   IF g_als.alsacti ='N' THEN CALL cl_err(g_als.als01,'9027',0) RETURN END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
   OPEN t800_cl USING g_als.als01
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t800_cl INTO g_als.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN CALL cl_err(g_als.als01,SQLCA.sqlcode,0) RETURN END IF
   CALL t800_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t800_i2()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_als.*=g_als_t.*
         CALL t800_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE als_file SET als_file.* = g_als.*    # 更新DB
       WHERE als01 = g_als01_t             # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","als_file",g_als.als01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t800_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t800_i2()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
    INPUT BY NAME g_als.als41,g_als.als41m,g_als.als42,g_als.als42m,
                  g_als.als43,g_als.als43m,g_als.als44,g_als.als44m,
                  g_als.als45,g_als.als45m,g_als.als46,g_als.als46m
                  WITHOUT DEFAULTS
 
        BEFORE FIELD als41m
           IF g_als.als41!=0 AND g_als.als41 IS NOT NULL AND
              g_als.als41m IS NULL THEN
              LET g_als.als41m = g_today USING 'YYYYMM'
              DISPLAY BY NAME g_als.als41m
           END IF
 
        BEFORE FIELD als42m
           IF g_als.als42!=0 AND g_als.als42 IS NOT NULL AND
              g_als.als42m IS NULL THEN
              LET g_als.als42m = g_today USING 'YYYYMM'
              DISPLAY BY NAME g_als.als42m
           END IF
 
        BEFORE FIELD als43m
           IF g_als.als43!=0 AND g_als.als43 IS NOT NULL AND
              g_als.als43m IS NULL THEN
              LET g_als.als43m = g_today USING 'YYYYMM'
              DISPLAY BY NAME g_als.als43m
           END IF
 
        BEFORE FIELD als44m
           IF g_als.als44!=0 AND g_als.als44 IS NOT NULL AND
              g_als.als44m IS NULL THEN
              LET g_als.als44m = g_today USING 'YYYYMM'
              DISPLAY BY NAME g_als.als44m
           END IF
 
        BEFORE FIELD als45m
           IF g_als.als45!=0 AND g_als.als45 IS NOT NULL AND
              g_als.als45m IS NULL THEN
              LET g_als.als45m = g_today USING 'YYYYMM'
              DISPLAY BY NAME g_als.als45m
           END IF
 
        BEFORE FIELD als46m
           IF g_als.als46!=0 AND g_als.als46 IS NOT NULL AND
              g_als.als46m IS NULL THEN
              LET g_als.als46m = g_today USING 'YYYYMM'
              DISPLAY BY NAME g_als.als46m
           END IF
 
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(g_als.als41) THEN LET g_als.als41=0 END IF   #85-10-18
            IF cl_null(g_als.als42) THEN LET g_als.als42=0 END IF
            IF cl_null(g_als.als43) THEN LET g_als.als43=0 END IF
            IF cl_null(g_als.als44) THEN LET g_als.als44=0 END IF
            IF cl_null(g_als.als45) THEN LET g_als.als45=0 END IF
            IF cl_null(g_als.als46) THEN LET g_als.als46=0 END IF
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
 
FUNCTION t800_r()
   DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cnt   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   IF s_aapshut(0) THEN RETURN END IF
   IF g_als.als01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_als.* FROM als_file
    WHERE als01=g_als.als01
   IF g_als.alsfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_als.alsfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   BEGIN WORK
 
   OPEN t800_cl USING g_als.als01
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t800_cl INTO g_als.*
   IF SQLCA.sqlcode THEN CALL cl_err(g_als.als01,SQLCA.sqlcode,0) RETURN END IF
   CALL t800_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "als01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_als.als01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM als_file WHERE als01 = g_als.als01
      IF STATUS THEN 
      CALL cl_err3("del","als_file",g_als.als01,"",STATUS,"","del als:",1)  #No.FUN-660122
      RETURN END IF
      DELETE FROM alt_file WHERE alt01 = g_als.als01
      IF STATUS THEN 
      CALL cl_err('del alt:',STATUS,0) #No.FUN-660122
      CALL cl_err3("del","alt_file",g_als.als01,"",STATUS,"","del alt:",1)  #No.FUN-660122
      RETURN END IF
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980001 add plant,legal
      VALUES ('saapt800',g_user,g_today,g_msg,g_als.als01,'delete',g_plant,g_legal) #FUN-980001 add plant,legal
      CLEAR FORM
      CALL g_alt.clear()
      INITIALIZE g_als.* TO NULL
      OPEN t800_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t800_cl
         CLOSE t800_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t800_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t800_cl
         CLOSE t800_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t800_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t800_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t800_fetch('/')
      END IF
   END IF
   CLOSE t800_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t800_m()
   DEFINE i,j            LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE g_apd     DYNAMIC ARRAY OF RECORD
                    apd02            LIKE apd_file.apd02,
                    apd03            LIKE apd_file.apd03
                    END RECORD,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690028 SMALLINT
 
   IF g_als.als01 IS NULL THEN RETURN END IF
 
 
   OPEN WINDOW t800_m_w AT 8,30 WITH FORM "aap/42f/aapt710_3"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt710_3")
 
 
   DECLARE t800_m_c CURSOR FOR
           SELECT apd02,apd03 FROM apd_file
             WHERE apd01 = g_als.als01
             ORDER BY apd02
   LET i = 1
   FOREACH t800_m_c INTO g_apd[i].*
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_apd.deleteElement(i)
   LET i = i -1
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_apd WITHOUT DEFAULTS FROM s_apd.*
         ATTRIBUTE(COUNT= i ,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
 
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE INPUT        #TQC-860021
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
   END INPUT                   #TQC-860021
   CLOSE WINDOW t800_m_w
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET j = ARR_COUNT()
   BEGIN WORK
   LET g_success = 'Y'
   WHILE TRUE
      DELETE FROM apd_file
       WHERE apd01 = g_als.als01
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err3("del","apd_file",g_als.als01,"",SQLCA.sqlcode,"","t800_m(ckp#1):",1)  #No.FUN-660122
         EXIT WHILE
      END IF
      FOR i = 1 TO g_apd.getLength()
         IF g_apd[i].apd03 IS NULL THEN CONTINUE FOR END IF
         INSERT INTO apd_file (apd01,apd02,apd03,apdlegal) #FUN-980001 add plant,legal
                VALUES(g_als.als01,g_apd[i].apd02,g_apd[i].apd03,g_legal) #FUN-980001 add plant,legal
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("ins","apd_file",g_als.als01,"",SQLCA.sqlcode,"","t800_m(ckp#2):",1)  #No.FUN-660122
            EXIT WHILE
         END IF
      END FOR
      EXIT WHILE
   END WHILE
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t800_firm1()
   IF g_als.als01 IS NULL THEN RETURN END IF
   IF g_als.alsfirm='Y' THEN RETURN END IF          #CHI-C30107 add
   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 add
    SELECT * INTO g_als.* FROM als_file
     WHERE als01=g_als.als01
   IF g_als.alsfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_als.alsfirm='Y' THEN RETURN END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT apz57 FROM apz_file ",
              " WHERE apz00 = '0'"
   PREPARE t600_apz57_p FROM g_sql
   EXECUTE t600_apz57_p INTO g_apz.apz57
#FUN-B50090 add -end--------------------------
   IF g_als.als02<=g_apz.apz57 THEN
      CALL cl_err(g_ala.ala01,'aap-176',1) RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM alt_file
    WHERE alt01=g_als.als01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   BEGIN WORK LET g_success='Y'
   OPEN t800_cl USING g_als.als01
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t800_cl INTO g_als.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_als.als01,SQLCA.sqlcode,0)
      ROLLBACK WORK RETURN
   END IF
   UPDATE als_file SET alsfirm = 'Y' WHERE als01 = g_als.als01
   IF STATUS THEN
      CALL cl_err3("upd","als_file",g_als.als01,"",STATUS,"","upd alsfirm:",1)  #No.FUN-660122
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_als.alsfirm ='Y'
      DISPLAY BY NAME g_als.alsfirm
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t800_firm2()
   IF g_als.als01 IS NULL THEN RETURN END IF
    SELECT * INTO g_als.* FROM als_file
     WHERE als01=g_als.als01
   IF g_als.alsfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_als.alsfirm='N' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM alk_file
    WHERE alk01 = g_als.als01
   IF g_cnt > 0 THEN
      CALL cl_err(g_als.als01,'aap-759',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
   LET g_success='Y'
   OPEN t800_cl USING g_als.als01
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t800_cl INTO g_als.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_als.als01,SQLCA.sqlcode,0)
      ROLLBACK WORK RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期 
   LET g_sql ="SELECT apz57 FROM apz_file ",
              " WHERE apz00 = '0'" 
   PREPARE t600_apz57_p1 FROM g_sql
   EXECUTE t600_apz57_p1 INTO g_apz.apz57
#FUN-B50090 add -end--------------------------
   IF g_als.als02<=g_apz.apz57 THEN
      CALL cl_err(g_ala.ala01,'aap-176',1) RETURN
   END IF
   UPDATE als_file SET alsfirm = 'N' WHERE als01 = g_als.als01
   IF STATUS THEN
      CALL cl_err3("upd","als_file",g_als.als01,"",STATUS,"","uod alsfirm:",1)  #No.FUN-660122
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
      RETURN
   END IF
   LET g_als.alsfirm ='N'
   DISPLAY BY NAME  g_als.alsfirm
END FUNCTION
 

 
FUNCTION t800_b_tot(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE tot1,tot2 LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
 
   LET tot1=0 LET tot2=0
   SELECT SUM(alt07) INTO tot1 FROM alt_file WHERE alt01=g_als.als01
   IF STATUS THEN 
      CALL cl_err3("sel","alt_file",g_als.als01,"",STATUS,"","sel sum(alt07):",1)  #No.FUN-660122
      LET z='N'
   END IF
   DISPLAY BY NAME tot1
   IF p_cmd='u' THEN
      LET g_als.als13=tot1
      DISPLAY BY NAME g_als.als13
      UPDATE als_file SET als13=g_als.als13 WHERE als01=g_als.als01
   END IF
END FUNCTION
 
FUNCTION t800_out(p_cmd)
   DEFINE p_cmd                LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_cmd                LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          l_wc          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = " als01='",g_als.als01,"'"             # "新增"則印單張
      ELSE LET l_wc = g_wc CLIPPED                               # 其他則印多張
   END IF
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0) END IF
 #  LET l_cmd = 'aapr800',  #FUN-C30085 mark
   LET l_cmd = 'aapg800',  #FUN-C30085 add
               ' "',g_today CLIPPED,'"',
               ' ""',
               ' "',g_lang CLIPPED,'"',
               ' "Y" ',
               ' ""',
               ' "1" ',
               ' "',l_wc CLIPPED,'"'
   CALL cl_cmdrun(l_cmd CLIPPED)
   ERROR ' '
display "l_cmd=???",l_cmd
END FUNCTION
#--FUN-B10030--start-- 
#FUNCTION t800_d()
#   DEFINE l_plant    LIKE azp_file.azp01, #FUN-660117
#          l_dbs      LIKE azp_file.azp03  #FUN-660117
 
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   CALL cl_ins_del_sid(2,'') #FUN-980030  #FUN-990069
#   CLOSE DATABASE #TQC-790116
#   DATABASE l_dbs
#   CALL cl_ins_del_sid(1,l_plant) #FUN-980030  #FUN-990069
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs
#   CALL s_chgdbs()              #FUN-B10030
#   CALL cl_ui_init()
#   CALL t800_lock_cur()
#END FUNCTION
#--FUN-B10030--end-- 
FUNCTION t800_b(p_mod_seq)
DEFINE p_mod_seq       LIKE type_file.chr1,    # No.FUN-690028 VARCHAR(1),                #修改次數 (0表開狀)
       l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-690028 SMALLINT
DEFINE l_tf            LIKE type_file.chr1     #FUN-BB0085
 
   LET g_action_choice = ""
   IF s_aapshut(0) THEN RETURN END IF
   IF g_als.als01 IS NULL THEN RETURN END IF
   SELECT * INTO g_als.* FROM als_file WHERE als01=g_als.als01
   IF g_als.alsfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_als.alsfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_als.als97 !=g_plant THEN CALL cl_err('','aap-707',0)RETURN END IF    #No.FUN-980017
  #預購單號應控卡，未輸入資料，不可輸單身資料
   IF cl_null(g_als.als03) THEN
      CALL cl_err('','aap-827',1) RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM alt_file WHERE alt01 = g_als.als01
   IF l_n = 0 THEN
      IF cl_confirm('aap-718') THEN
         CALL t800_g_b()            # 依 入庫單 (rvv_file) 產生
         CALL t800_b_fill('1=1')
      END IF
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT alt02,alt14,alt15,alt11,'',",
                      "       alt83,alt84,alt85,alt80,alt81,alt82,alt86,alt87,",  #FUN-710029
                      "       '',",
                      "       alt06,alt05,alt07,alt930,''",  #FUN-680019
                      ",altud01,altud02,altud03,altud04,altud05,",
                      "altud06,altud07,altud08,altud09,altud10,",
                      "altud11,altud12,altud13,altud14,altud15",
                      "  FROM alt_file",
                      " WHERE alt01=? AND alt02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_alt WITHOUT DEFAULTS FROM s_alt.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
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
         OPEN t800_cl USING g_als.als01
         IF STATUS THEN
            CALL cl_err("OPEN t800_cl:", STATUS, 1)
            CLOSE t800_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t800_cl INTO g_als.*               # 對DB鎖定
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_als.als01,SQLCA.sqlcode,0)
            ROLLBACK WORK RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET g_alt_t.* = g_alt[l_ac].*
            LET g_alt80_t = g_alt[l_ac].alt80    #FUN-BB0085
            LET g_alt83_t = g_alt[l_ac].alt83    #FUN-BB0085
           #LET g_alt86_t = g_alt[l_ac].alt86    #FUN-BB0085  #TQC-C20183
            LET p_cmd='u'
            OPEN t800_bcl USING g_als.als01,g_alt_t.alt02
            IF STATUS THEN
               CALL cl_err("OPEN t800_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            END IF
            FETCH t800_bcl INTO g_alt[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_alt_t.alt02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            LET g_alt[l_ac].gem02c = s_costcenter_desc(g_alt[l_ac].alt930) #FUN-680019
            LET g_alt[l_ac].pmn041 = g_alt_t.pmn041
            LET g_alt[l_ac].pmn07  = g_alt_t.pmn07
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_alt[l_ac].* TO NULL
         LET g_alt[l_ac].alt05 = 0
         LET g_alt[l_ac].alt06 = 0
         LET g_alt[l_ac].alt07 = 0
         LET g_alt[l_ac].alt81 = 0    #FUN-710029
         LET g_alt[l_ac].alt82 = 0    #FUN-710029
         LET g_alt[l_ac].alt84 = 0    #FUN-710029
         LET g_alt[l_ac].alt85 = 0    #FUN-710029
         LET g_alt[l_ac].alt87 = 0    #FUN-710029
         LET g_alt[l_ac].alt930 = g_als.als930 #FUN-680019
         LET g_alt[l_ac].gem02c = s_costcenter_desc(g_alt[l_ac].alt930) #FUN-680019
         LET g_alt_t.* = g_alt[l_ac].*         #新輸入資料
         LET g_alt80_t = ''          #FUN-BB0085
         LET g_alt83_t = ''          #FUN-BB0085
        #LET g_alt86_t = ''          #FUN-BB0085  #TQC-C20183
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         IF g_sma.sma115 = 'Y' THEN
            IF NOT cl_null(g_alt[l_ac].alt11) THEN
               SELECT ima44,ima31 INTO g_ima44,g_ima31
                 FROM ima_file WHERE ima01=g_alt[l_ac].alt11
 
               CALL s_chk_va_setting(g_alt[l_ac].alt11)
                    RETURNING g_flag,g_ima906,g_ima907
 
               CALL s_chk_va_setting1(g_alt[l_ac].alt11)
                    RETURNING g_flag,g_ima908
            END IF
         END IF
         CALL t800_set_required() 
         CALL t800_set_entry_b(p_cmd)
         CALL t800_set_no_entry_b(p_cmd)
         NEXT FIELD alt02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            EXIT INPUT
         END IF
         INSERT INTO alt_file(alt01,alt02,alt14,
                              alt15,alt11,alt06,alt05,alt07,alt930, #FUN-680019
                              alt80,alt81,alt82,alt83,alt84,alt85,alt86,alt87   #FUN-710029
                             ,altud01,altud02,altud03,
                              altud04,altud05,altud06,
                              altud07,altud08,altud09,
                              altud10,altud11,altud12,
                              altud13,altud14,altud15,altlegal) #FUN-980001 add legal
          VALUES(g_als.als01, g_alt[l_ac].alt02,
                 g_alt[l_ac].alt14,g_alt[l_ac].alt15,
                 g_alt[l_ac].alt11,g_alt[l_ac].alt06,
                 g_alt[l_ac].alt05,g_alt[l_ac].alt07,g_alt[l_ac].alt930, #FUN-680019
                 g_alt[l_ac].alt80,g_alt[l_ac].alt81,g_alt[l_ac].alt82,  #FUN-710029
                 g_alt[l_ac].alt83,g_alt[l_ac].alt84,g_alt[l_ac].alt85,  #FUN-710029
                 g_alt[l_ac].alt86,g_alt[l_ac].alt87                    #FUN-710029
                ,g_alt[l_ac].altud01, g_alt[l_ac].altud02,
                 g_alt[l_ac].altud03, g_alt[l_ac].altud04,
                 g_alt[l_ac].altud05, g_alt[l_ac].altud06,
                 g_alt[l_ac].altud07, g_alt[l_ac].altud08,
                 g_alt[l_ac].altud09, g_alt[l_ac].altud10,
                 g_alt[l_ac].altud11, g_alt[l_ac].altud12,
                 g_alt[l_ac].altud13, g_alt[l_ac].altud14,
                 g_alt[l_ac].altud15, g_legal) #FUN-980001 add legal
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","alt_file",g_als.als01,g_alt[l_ac].alt02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
            CALL t800_b_tot('u')
         END IF
 
      BEFORE FIELD alt02                        #default 序號
         IF g_alt[l_ac].alt02 IS NULL OR g_alt[l_ac].alt02 = 0 THEN
            SELECT max(alt02)+1
              INTO g_alt[l_ac].alt02
              FROM alt_file
             WHERE alt01 = g_als.als01
            IF g_alt[l_ac].alt02 IS NULL THEN
               LET g_alt[l_ac].alt02 = 1
            END IF
         END IF
 
      AFTER FIELD alt02                        #check 序號是否重複
         IF NOT cl_null(g_alt[l_ac].alt02) THEN
            IF g_alt[l_ac].alt02 != g_alt_t.alt02 OR g_alt_t.alt02 IS NULL THEN
               SELECT count(*) INTO l_n
                 FROM alt_file
                WHERE alt01 = g_als.als01
                  AND alt02 = g_alt[l_ac].alt02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_alt[l_ac].alt02 = g_alt_t.alt02
                  NEXT FIELD alt02
               END IF
            END IF
         END IF
 
      BEFORE FIELD alt14
         CALL t800_set_entry_b(p_cmd)
 
      AFTER FIELD alt14
         IF cl_null(g_alt[l_ac].alt14) THEN      #85-10-18
            NEXT FIELD alt14
         ELSE
            CALL t800_alt14()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alt[l_ac].alt14,g_errno,1)  #85-10-18
               NEXT FIELD alt14
            END IF
         END IF
         CALL t800_set_no_entry_b(p_cmd)
 
      AFTER FIELD alt15
         IF g_alt[l_ac].alt14!='MISC' AND cl_null(g_alt[l_ac].alt15) THEN
            NEXT FIELD alt15
         END IF
         IF g_alt[l_ac].alt15 IS NOT NULL THEN
            CALL t800_alt15()
            IF NOT cl_null(g_errno) THEN
               LET g_alt[l_ac].alt14=g_alt_t.alt14
               LET g_alt[l_ac].alt15=g_alt_t.alt15
               NEXT FIELD alt14
            END IF
         END IF
 
      AFTER FIELD alt05
         IF NOT cl_null(g_alt[l_ac].alt05) THEN
            IF g_sma.sma116 MATCHES '[02]' THEN
               LET g_alt[l_ac].alt87 = g_alt[l_ac].alt06
            END IF
            SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = g_als.als11   #NO.CHI-6A0004   #MOD-720016
            LET g_alt[l_ac].alt05 = cl_digcut(g_alt[l_ac].alt05,t_azi03)   #NO.CHI-6A0004   #MOD-720016
            LET g_alt[l_ac].alt07 = g_alt[l_ac].alt06 * g_alt[l_ac].alt05
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11   #MOD-720016
            LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)   #NO.CHI-6A0004
         END IF
 
      AFTER FIELD alt06
         CALL t800_alt06_check()                      #FUN-BB0085
         #FUN-BB0085----mark----str----
         #IF NOT cl_null(g_alt[l_ac].alt06) THEN
         #   IF g_sma.sma116 MATCHES '[02]' THEN
         #      LET g_alt[l_ac].alt87 = g_alt[l_ac].alt06
         #   END IF
         #   LET g_alt[l_ac].alt07 = g_alt[l_ac].alt06 * g_alt[l_ac].alt05
         #   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11   #NO.CHI-6A0004
         #   LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)   #NO.CHI-6A0004
         #   CALL t800_qty_chk()
         #END IF
         #FUN-BB0085----mark----end----
 
      AFTER FIELD alt07
         IF cl_null(g_alt[l_ac].alt07) THEN
            LET g_alt[l_ac].alt07=0
         ELSE
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11   
            LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)
         END IF
 
      BEFORE FIELD alt11
         CALL t800_set_no_required()       
         CALL t800_set_entry_b(p_cmd)
 
      AFTER FIELD alt11
         CALL t800_set_no_entry_b(p_cmd)
         CALL t800_set_required()
         IF g_sma.sma115 = 'Y' THEN
            CALL s_chk_va_setting(g_alt[l_ac].alt11)
                 RETURNING g_flag,g_ima906,g_ima907
            IF g_flag=1 THEN
               NEXT FIELD alt11
            END IF
            CALL s_chk_va_setting1(g_alt[l_ac].alt11)
                 RETURNING g_flag,g_ima908
            IF g_flag=1 THEN
               NEXT FIELD alt05
            END IF
            IF g_ima906 = '3' THEN
               LET g_alt[l_ac].alt83=g_ima907
               LET g_alt[l_ac].alt85=s_digqty(g_alt[l_ac].alt85,g_alt[l_ac].alt83)    #FUN-BB0085
               DISPLAY BY NAME g_alt[l_ac].alt85                                      #FUN-BB0085
            END IF
            IF g_sma.sma116 MATCHES '[13]' THEN   
               LET g_alt[l_ac].alt86=g_ima908
            END IF
            SELECT ima44,ima31 INTO g_ima44,g_ima31
              FROM ima_file WHERE ima01=g_alt[l_ac].alt11
            IF cl_null(g_alt[l_ac].alt80) AND  
               cl_null(g_alt[l_ac].alt83) THEN
               CALL t800_du_default(p_cmd)
            END IF
        END IF
        CALL t800_set_required()
 
      BEFORE FIELD alt83
         IF NOT cl_null(g_alt[l_ac].alt11) THEN
            SELECT ima44,ima31 INTO g_ima44,g_ima31
              FROM ima_file WHERE ima01=g_alt[l_ac].alt11
         END IF
         CALL t800_set_no_required()
 
      AFTER FIELD alt83  #第二單位
         IF cl_null(g_alt[l_ac].alt11) THEN NEXT FIELD alt11 END IF
         IF NOT cl_null(g_alt[l_ac].alt83) THEN
            SELECT gfe02 INTO g_buf FROM gfe_file
             WHERE gfe01=g_alt[l_ac].alt83
               AND gfeacti='Y'
            IF STATUS THEN
               CALL cl_err3("sel","gfe_file",g_alt[l_ac].alt83,"",STATUS,"","gfe:",1)
               NEXT FIELD alt83
            END IF
            CALL s_du_umfchk(g_alt[l_ac].alt11,'','','',
                             g_ima44,g_alt[l_ac].alt83,g_ima906)
                 RETURNING g_errno,g_factor
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alt[l_ac].alt83,g_errno,1)
               NEXT FIELD alt83
            END IF
            IF cl_null(g_alt_t.alt83) OR g_alt_t.alt83 <> g_alt[l_ac].alt83 THEN
               LET g_alt[l_ac].alt84 = g_factor
            END IF
            CALL t800_alt85_check(p_cmd) RETURNING l_tf     #FUN-BB0085
         END IF
         CALL t800_du_data_to_correct()
         CALL t800_set_required()
         CALL cl_show_fld_cont()  
         #FUN-BB0085-add-str--
         IF NOT cl_null(g_alt[l_ac].alt83) THEN
            IF NOT l_tf THEN NEXT FIELD alt85 END IF
         END IF 
         #FUN-BB0085-add-end--
 
      AFTER FIELD alt84  #第二轉換率
         IF NOT cl_null(g_alt[l_ac].alt84) THEN
            IF g_alt[l_ac].alt84=0 THEN
               NEXT FIELD alt84
            END IF
         END IF
 
      AFTER FIELD alt85  #第二數量
         IF NOT t800_alt85_check(p_cmd) THEN NEXT FIELD alt85 END IF       #FUN-BB0085
         #FUN-BB0085----mark----str----
         #IF NOT cl_null(g_alt[l_ac].alt85) THEN
         #   IF g_alt[l_ac].alt85 < 0 THEN
         #      CALL cl_err('','aim-391',1) 
         #      NEXT FIELD alt85
         #   END IF
         #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
         #      g_alt_t.alt85 <> g_alt[l_ac].alt85 THEN
         #      IF g_ima906='3' THEN
         #         LET g_tot=g_alt[l_ac].alt85*g_alt[l_ac].alt84
         #         IF cl_null(g_alt[l_ac].alt82) OR g_alt[l_ac].alt82=0 THEN #CHI-960022
         #            LET g_alt[l_ac].alt82=g_tot*g_alt[l_ac].alt81
         #            DISPLAY BY NAME g_alt[l_ac].alt82                      #CHI-960022
         #         END IF                                                    #CHI-960022 
         #      END IF
         #   END IF
         #END IF
         #IF cl_null(g_alt[l_ac].alt86) THEN
         #   LET g_alt[l_ac].alt87 = 0
         #ELSE
         #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
         #         (g_alt_t.alt81 <> g_alt[l_ac].alt81 OR
         #          g_alt_t.alt82 <> g_alt[l_ac].alt82 OR
         #          g_alt_t.alt84 <> g_alt[l_ac].alt84 OR
         #          g_alt_t.alt85 <> g_alt[l_ac].alt85 OR
         #          g_alt_t.alt86 <> g_alt[l_ac].alt86) THEN
         #      CALL t800_set_alt87()
         #   END IF
         #END IF
         #CALL cl_show_fld_cont()  
         #FUN-BB0085----mark----end----
 
      AFTER FIELD alt80  #第一單位
         IF cl_null(g_alt[l_ac].alt11) THEN NEXT FIELD alt11 END IF
         IF NOT cl_null(g_alt[l_ac].alt80) THEN
            SELECT gfe02 INTO g_buf FROM gfe_file
             WHERE gfe01=g_alt[l_ac].alt80
               AND gfeacti='Y'
            IF STATUS THEN
               CALL cl_err3("sel","gfe_file",g_alt[l_ac].alt80,"",STATUS,"","gfe:",1)
               NEXT FIELD alt80
            END IF
            IF p_cmd = 'a' OR  p_cmd = 'u' AND
                  (g_alt_t.alt81 <> g_alt[l_ac].alt81 OR
                   g_alt_t.alt82 <> g_alt[l_ac].alt82 OR
                   g_alt_t.alt84 <> g_alt[l_ac].alt84 OR
                   g_alt_t.alt85 <> g_alt[l_ac].alt85 OR
                   g_alt_t.alt86 <> g_alt[l_ac].alt86) THEN
               CALL t800_set_alt87()
            END IF
            CALL t800_alt82_check(p_cmd) RETURNING l_tf    #FUN-BB0085
         END IF
         CALL cl_show_fld_cont()         
         #FUN-BB0085-add-str--
         IF NOT cl_null(g_alt[l_ac].alt80) THEN
            IF NOT l_tf THEN NEXT FIELD alt82 END IF
         END IF
         #FUN-BB0085-add-end--
 
      AFTER FIELD alt81  #第一轉換率
         IF NOT cl_null(g_alt[l_ac].alt81) THEN
            IF g_alt[l_ac].alt81=0 THEN
               NEXT FIELD alt81
            END IF
         END IF
 
      AFTER FIELD alt82  #第一數量
         IF NOT t800_alt82_check(p_cmd) THEN NEXT FIELD alt82 END IF        #FUN-BB0085
         #FUN-BB0085----mark----str----
         #IF NOT cl_null(g_alt[l_ac].alt82) THEN
         #   IF g_alt[l_ac].alt82 < 0 THEN
         #      CALL cl_err('','aim-391',1)  
         #      NEXT FIELD alt82
         #   END IF
         #END IF
         #CALL t800_set_origin_field()
         #IF cl_null(g_alt[l_ac].alt86) THEN
         #   LET g_alt[l_ac].alt87 = 0
         #ELSE
         #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
         #         (g_alt_t.alt81 <> g_alt[l_ac].alt81 OR
         #          g_alt_t.alt82 <> g_alt[l_ac].alt82 OR
         #          g_alt_t.alt84 <> g_alt[l_ac].alt84 OR
         #          g_alt_t.alt85 <> g_alt[l_ac].alt85 OR
         #          g_alt_t.alt86 <> g_alt[l_ac].alt86) THEN
         #      CALL t800_set_alt87()
         #   END IF
         #END IF
         #CALL cl_show_fld_cont()                   #No.FUN-560197
         #FUN-BB0085----mark----end---- 

      BEFORE FIELD alt86
         IF NOT cl_null(g_alt[l_ac].alt11) THEN
            SELECT ima44,ima31 INTO g_ima44,g_ima31
              FROM ima_file WHERE ima01=g_alt[l_ac].alt11
         END IF
         CALL t800_set_no_required()
 
      AFTER FIELD alt86
         IF cl_null(g_alt[l_ac].alt11) THEN NEXT FIELD alt11 END IF
         IF NOT cl_null(g_alt[l_ac].alt86) THEN
            SELECT gfe02 INTO g_buf FROM gfe_file
             WHERE gfe01=g_alt[l_ac].alt86
               AND gfeacti='Y'
            IF STATUS THEN
               CALL cl_err3("sel","gfe_file",g_alt[l_ac].alt86,"",STATUS,"","gfe:",1)
               NEXT FIELD alt86
            END IF
            CALL s_du_umfchk(g_alt[l_ac].alt11,'','','',
                             g_ima44,g_alt[l_ac].alt86,'1')
                RETURNING g_errno,g_factor
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_alt[l_ac].alt86,g_errno,1)  
               NEXT FIELD alt86
            END IF
          # CALL t800_alt87_check() RETURNING l_tf   #FUN-BB0085  #TQC-C20183 mark
         END IF
         CALL t800_set_required()
         #TQC-C20183-mark-str---
         ##FUN-BB0085-add-str--
         #IF NOT cl_null(g_alt[l_ac].alt86) THEN
         #   IF NOT l_tf THEN NEXT FIELD alt87 END IF 
         #END IF
         ##FUN-BB0085-add-end--
         #TQC-C20183-mark-end--
 
      BEFORE FIELD alt87
         IF g_sma.sma115 = 'Y' THEN
            IF p_cmd = 'a' OR  p_cmd = 'u' AND
               (g_alt_t.alt81 <> g_alt[l_ac].alt81 OR
                g_alt_t.alt82 <> g_alt[l_ac].alt82 OR
                g_alt_t.alt84 <> g_alt[l_ac].alt84 OR
                g_alt_t.alt85 <> g_alt[l_ac].alt85 OR
                g_alt_t.alt86 <> g_alt[l_ac].alt86) THEN
               CALL t800_set_alt87()
            END IF
         ELSE
            IF g_alt[l_ac].alt87 = 0 OR
               g_alt_t.alt86 <> g_alt[l_ac].alt86 THEN
               CALL t800_set_alt87()
            END IF
         END IF
 
      AFTER FIELD alt87
         #IF NOT t800_alt87_check() THEN NEXT FIELD alt87 END IF    #FUN-BB0085     #TQC-C20183 mark
         #TQC-C20183----mod-----str-------------
         IF NOT cl_null(g_alt[l_ac].alt87) AND NOT cl_null(g_alt[l_ac].alt86) THEN
            LET g_alt[l_ac].alt87 = s_digqty(g_alt[l_ac].alt87,g_alt[l_ac].alt86)
            DISPLAY BY NAME g_alt[l_ac].alt87
         END IF         
         IF NOT cl_null(g_alt[l_ac].alt87) THEN
            IF g_alt[l_ac].alt87 < 0 THEN
               CALL cl_err('','aim-391',1)
               NEXT FIELD alt87
            END IF
            LET g_alt[l_ac].alt07 = g_alt[l_ac].alt87 * g_alt[l_ac].alt05
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11
            LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)
         END IF
         ##FUN-BB0085----mark----str----
         #IF NOT cl_null(g_alt[l_ac].alt87) THEN
         #   IF g_alt[l_ac].alt87 < 0 THEN
         #      CALL cl_err('','aim-391',1)  
         #      NEXT FIELD alt87
         #   END IF
         #   LET g_alt[l_ac].alt07 = g_alt[l_ac].alt87 * g_alt[l_ac].alt05
         #   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11
         #   LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)
         #END IF
         ##FUN-BB0085----mark----str----
         #TQC-C20183----mod-----end------------
 
      AFTER FIELD altud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD altud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_alt_t.alt02 > 0 AND g_alt_t.alt02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM alt_file
             WHERE alt01 = g_als.als01
               AND alt02 = g_alt_t.alt02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","alt_file",g_als.als01,g_alt_t.alt02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
            CALL t800_b_tot('u')
         END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_alt[l_ac].* = g_alt_t.*
             CLOSE t800_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_alt[l_ac].alt02,-263,1)
             LET g_alt[l_ac].* = g_alt_t.*
          ELSE
             CALL t800_set_origin_field()  
 
             IF g_sma.sma115 = 'Y' THEN
                IF NOT cl_null(g_alt[l_ac].alt11) THEN
                   SELECT ima44,ima31 INTO g_ima44,g_ima31
                     FROM ima_file WHERE ima01=g_alt[l_ac].alt11
                END IF
 
                CALL s_chk_va_setting(g_alt[l_ac].alt11)
                     RETURNING g_flag,g_ima906,g_ima907
                IF g_flag=1 THEN
                   NEXT FIELD alt11
                END IF
                CALL s_chk_va_setting1(g_alt[l_ac].alt11)
                     RETURNING g_flag,g_ima908
                IF g_flag=1 THEN
                   NEXT FIELD alt02
                END IF
                CALL t800_du_data_to_correct()
                CALL t800_set_origin_field()
             END IF
             LET g_alt[l_ac].alt07 = g_alt[l_ac].alt87 * g_alt[l_ac].alt05
             SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11
             LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)
             UPDATE alt_file SET alt02 = g_alt[l_ac].alt02 ,
                                 alt14 = g_alt[l_ac].alt14,
                                 alt15 = g_alt[l_ac].alt15,
                                 alt11 = g_alt[l_ac].alt11,
                                 alt06 = g_alt[l_ac].alt06,
                                 alt05 = g_alt[l_ac].alt05,
                                 alt07 = g_alt[l_ac].alt07,
                                 alt930= g_alt[l_ac].alt930, #FUN-680019
                                 alt80 = g_alt[l_ac].alt80,  #FUN-710029
                                 alt81 = g_alt[l_ac].alt81,  #FUN-710029
                                 alt82 = g_alt[l_ac].alt82,  #FUN-710029
                                 alt83 = g_alt[l_ac].alt83,  #FUN-710029
                                 alt84 = g_alt[l_ac].alt84,  #FUN-710029
                                 alt85 = g_alt[l_ac].alt85,  #FUN-710029
                                 alt86 = g_alt[l_ac].alt86,  #FUN-710029
                                 alt87 = g_alt[l_ac].alt87   #FUN-710029
                                ,altud01 = g_alt[l_ac].altud01,
                                 altud02 = g_alt[l_ac].altud02,
                                 altud03 = g_alt[l_ac].altud03,
                                 altud04 = g_alt[l_ac].altud04,
                                 altud05 = g_alt[l_ac].altud05,
                                 altud06 = g_alt[l_ac].altud06,
                                 altud07 = g_alt[l_ac].altud07,
                                 altud08 = g_alt[l_ac].altud08,
                                 altud09 = g_alt[l_ac].altud09,
                                 altud10 = g_alt[l_ac].altud10,
                                 altud11 = g_alt[l_ac].altud11,
                                 altud12 = g_alt[l_ac].altud12,
                                 altud13 = g_alt[l_ac].altud13,
                                 altud14 = g_alt[l_ac].altud14,
                                 altud15 = g_alt[l_ac].altud15
                                 #FUN-850038 --end-- 
 
              WHERE alt01=g_als.als01 AND alt02=g_alt_t.alt02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","alt_file",g_als.als01,g_alt_t.alt02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_alt[l_ac].* = g_alt_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
                CALL t800_b_tot('u')
             END IF
          END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac   #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_alt[l_ac].* = g_alt_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_alt.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE t800_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032 add 
         CLOSE t800_bcl
         COMMIT WORK
         CALL t800_b_tot('u')
 

 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(alt80) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_alt[l_ac].alt80
                 CALL cl_create_qry() RETURNING g_alt[l_ac].alt80
                 DISPLAY BY NAME g_alt[l_ac].alt80
                 NEXT FIELD alt80
            WHEN INFIELD(alt83) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_alt[l_ac].alt83
                 CALL cl_create_qry() RETURNING g_alt[l_ac].alt83
                 DISPLAY BY NAME g_alt[l_ac].alt83
                 NEXT FIELD alt83
            WHEN INFIELD(alt86) #單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_alt[l_ac].alt86
                 CALL cl_create_qry() RETURNING g_alt[l_ac].alt86
                 DISPLAY BY NAME g_alt[l_ac].alt86
                 NEXT FIELD alt86
            WHEN INFIELD(alt930)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gem4"
               CALL cl_create_qry() RETURNING g_alt[l_ac].alt930
               DISPLAY BY NAME g_alt[l_ac].alt930
               NEXT FIELD alt930
         END CASE
        
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(alt02) AND l_ac > 1 THEN
            LET g_alt[l_ac].* = g_alt[l_ac-1].*
            LET g_alt[l_ac].alt02 = NULL   #TQC-620018
            NEXT FIELD alt02
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION regen_body    #No.MOD-480514
         CALL t800_g_b()      # 依 入庫單 (rvv_file) 產生
         CALL t800_b_fill('1=1')
         EXIT INPUT
 
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
   UPDATE als_file SET alsmodu=g_user,
                       alsdate=g_today
                 WHERE als01  =g_als.als01
 
   CALL t800_delHeader()  #CHI-C30002 add
   CLOSE t800_bcl
   COMMIT WORK
 
END FUNCTION

#CHI-C30002 ------- add ------- begin
FUNCTION t800_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_als.als01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM als_file ",
                  "  WHERE als01 LIKE '",l_slip,"%' ",
                  "    AND als01 > '",g_als.als01,"'"
      PREPARE t800_pb1 FROM l_sql 
      EXECUTE t800_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t800_x()
         IF g_als.alsfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_als.alsfirm,"","","",g_void,"") 
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN #CHI-C80041
         DELETE FROM als_file WHERE als01 = g_als.als01
         INITIALIZE g_als.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 ------- add ------- end
 
FUNCTION t800_alt14()
    LET g_errno = " "
    IF g_alt[l_ac].alt14='MISC' THEN RETURN END IF
   #FUN-A60056--mod--str--
   #SELECT COUNT(*) INTO g_cnt FROM pmm_file
   # WHERE pmm01 = g_alt[l_ac].alt14 AND pmm18='Y'
    LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_als.als97,'pmm_file'),
                " WHERE pmm01 = '",g_alt[l_ac].alt14,"' AND pmm18='Y'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_als.als97) RETURNING g_sql
    PREPARE sel_cou_pmm FROM g_sql
    EXECUTE sel_cou_pmm INTO g_cnt
   #FUN-A60056--mod--end
    IF g_cnt=0 THEN LET g_errno='100' RETURN END IF
    IF g_als.als03 IS NOT NULL THEN
       SELECT COUNT(*) INTO g_cnt FROM alb_file
        WHERE alb01 = g_als.als03 AND alb04 = g_alt[l_ac].alt14
       IF g_cnt=0 THEN LET g_errno='aap-719' RETURN END IF
    END IF
END FUNCTION
 
FUNCTION t800_alt15()
    DEFINE l_pmn      RECORD LIKE pmn_file.*
    DEFINE l_alb      RECORD LIKE alb_file.*
    DEFINE l_alb01    LIKE alb_file.alb01      #FUN-660117  #CHAR(20)
    DEFINE l_tot      LIKE type_file.num20_6   #MOD-870107 add
 
    LET g_errno = " "
    IF g_alt[l_ac].alt14='MISC' THEN RETURN END IF
    LET l_alb01 = NULL
    SELECT MAX(alb01) INTO l_alb01 FROM alb_file
     WHERE alb04=g_alt[l_ac].alt14 AND alb05=g_alt[l_ac].alt15
    IF g_als.als03 IS NULL AND l_alb01 IS NOT NULL THEN
       CALL cl_err(l_alb01,'aap-750',1)
       LET g_errno=1 RETURN
    END IF
    IF g_als.als03 IS NOT NULL THEN
       SELECT * INTO l_alb.* FROM alb_file
        WHERE alb01 = g_als.als03
          AND alb04 = g_alt[l_ac].alt14 AND alb05 = g_alt[l_ac].alt15
       IF STATUS THEN LET g_errno='aap-240' RETURN END IF
       LET g_alt[l_ac].alt11 = l_alb.alb11
       LET g_alt[l_ac].alt05 = l_alb.alb06
       SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = g_als.als11   #NO.CHI-6A0004   #MOD-720016
       LET g_alt[l_ac].alt05 = cl_digcut(g_alt[l_ac].alt05,t_azi03)        #NO.CHI-6A0004     #MOD-720016
       IF g_alt[l_ac].alt06 = 0 THEN
          LET g_alt[l_ac].alt06 = (l_alb.alb07 - l_alb.alb12)
         #數量應扣除已存在於aapt800的數量
          LET l_tot = 0
          SELECT SUM(alt06) INTO l_tot 
           #FROM alt_file                        #MOD-C50158 mark
            FROM alt_file,als_file               #MOD-C50158 add
           WHERE alt14 = g_alt[l_ac].alt14 
             AND alt15 = g_alt[l_ac].alt15
             AND alt01 = als01                   #MOD-C50158 add
             AND als03 = g_als.als03             #MOD-C50158 add
             AND alsfirm <> 'X'                  #CHI-C80041
             AND (als01 NOT IN (SELECT alk01 FROM alk_file              #MOD-C70311 add
                                WHERE alkfirm = 'Y' ))                  #MOD-C70311 add
          IF cl_null(l_tot) THEN LET l_tot = 0 END IF
          IF l_tot != 0 THEN
             LET g_alt[l_ac].alt06 = g_alt[l_ac].alt06-l_tot
             LET g_alt[l_ac].alt87 = g_alt[l_ac].alt87 - l_tot          #MOD-C70311 add
          END IF
          LET g_alt[l_ac].alt07 = g_alt[l_ac].alt06 * g_alt[l_ac].alt05
          SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11   #NO.CHI-6A0004
          LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)        #NO.CHI-6A0004
       END IF
    END IF
   #FUN-A60056--mod--str--
   #SELECT * INTO l_pmn.* FROM pmn_file
   # WHERE pmn01 = g_alt[l_ac].alt14 AND pmn02 = g_alt[l_ac].alt15
    LET g_sql = "SELECT * FROM ",cl_get_target_table(g_als.als97,'pmn_file'),
                " WHERE pmn01 = '",g_alt[l_ac].alt14,"'",
                "   AND pmn02 = '",g_alt[l_ac].alt15,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql,g_als.als97) RETURNING g_sql
    PREPARE sel_pmn FROM g_sql
    EXECUTE sel_pmn INTO l_pmn.*
   #FUN-A60056--mod--end
 
    IF STATUS THEN LET g_errno='aap-241' RETURN END IF
    LET g_alt[l_ac].alt11 = l_pmn.pmn04
    LET g_alt[l_ac].alt05 = l_pmn.pmn31
    SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = g_als.als11   #NO.CHI-6A0004   #MOD-720016
    LET g_alt[l_ac].alt05 = cl_digcut(g_alt[l_ac].alt05,t_azi03)        #NO.CHI-6A0004   #MOD-720016
    LET g_alt[l_ac].pmn041=l_pmn.pmn041
    LET g_alt[l_ac].pmn07 =l_pmn.pmn07
    IF g_alt[l_ac].alt06 = 0 THEN
       LET g_alt[l_ac].alt06 = l_pmn.pmn20
       LET g_alt[l_ac].alt07 = g_alt[l_ac].alt06 * g_alt[l_ac].alt05
       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11   #NO.CHI-6A0004
       LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)        #NO.CHI-6A0004
    END IF
    LET g_alt[l_ac].alt930=l_pmn.pmn930 #FUN-680019
    LET g_alt[l_ac].gem02c=s_costcenter_desc(g_alt[l_ac].alt930) #FUN-680019
    DISPLAY BY NAME g_alt[l_ac].alt930,g_alt[l_ac].gem02c
END FUNCTION
 
FUNCTION t800_qty_chk()
    DEFINE l_alb07,l_totqty     LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
    IF g_alt[l_ac].alt14='MISC'  THEN RETURN END IF
    IF g_alt[l_ac].alt14 IS NULL THEN RETURN END IF
    SELECT alb07 INTO l_alb07            # 取原LC預購量
      FROM alb_file
     WHERE alb01=g_als.als03
       AND alb04=g_alt[l_ac].alt14 AND alb05=g_alt[l_ac].alt15
    SELECT SUM(alt06) INTO l_totqty      # 取總共已到貨量(除本筆外)
      FROM als_file,alt_file
     WHERE als03=g_als.als03 AND als01=alt01
       AND alt14=g_alt[l_ac].alt14 AND alt15=g_alt[l_ac].alt15
       AND als01!=g_als.als01
       AND alsfirm <> 'X'                  #CHI-C80041
    IF l_totqty IS NULL THEN LET l_totqty=0 END IF
    LET l_totqty = l_totqty + g_alt[l_ac].alt06
    IF l_totqty > l_alb07 THEN
       CALL cl_err('','aap-242',0)
    END IF
END FUNCTION
 
FUNCTION t800_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON alt02,alt14,alt15,alt11,
                       alt83,alt84,alt85,alt80,alt81,alt82,alt86,alt87,  #FUN-710029
                       alt06
            FROM s_alt[1].alt02,
                 s_alt[1].alt14,s_alt[1].alt15,s_alt[1].alt11,
                 s_alt[1].alt83,s_alt[1].alt84,s_alt[1].alt85,   #FUN-710029
                 s_alt[1].alt80,s_alt[1].alt81,s_alt[1].alt82,   #FUN-710029
                 s_alt[1].alt86,s_alt[1].alt87,                  #FUN-710029
                 s_alt[1].alt06
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t800_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t800_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
    LET g_sql = "SELECT alt02,alt14,alt15,alt11,pmn041,",
                "       alt83,alt84,alt85,alt80,alt81,alt82,alt86,alt87,",  #FUN-710029
                "       pmn07,",
                "       alt06,alt05,alt07,alt930,''", #FUN-680019
                ",altud01,altud02,altud03,altud04,altud05,",
                "altud06,altud07,altud08,altud09,altud10,",
                "altud11,altud12,altud13,altud14,altud15", 
               #FUN-A60056--mod--str--
               #" FROM alt_file LEFT OUTER JOIN pmn_file ON alt_file.alt14 = pmn_file.pmn01 AND alt_file.alt15 = pmn_file.pmn02",
                " FROM alt_file LEFT OUTER JOIN ",cl_get_target_table(g_als.als97,'pmn_file'),
                "                 ON alt_file.alt14 = pmn_file.pmn01 AND alt_file.alt15 = pmn_file.pmn02",
               #FUN-A60056--mod--end
                " WHERE alt01 ='",g_als.als01,"'",
                "   AND ",p_wc2 CLIPPED,                     #單身
                " ORDER BY 1"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-A60056
    CALL cl_parse_qry_sql(g_sql,g_als.als97) RETURNING g_sql    #FUN-A60056
    PREPARE t800_pb FROM g_sql
    DECLARE alt_curs CURSOR FOR t800_pb
 
    CALL g_alt.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH alt_curs INTO g_alt[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_alt[g_cnt].gem02c=s_costcenter_desc(g_alt[g_cnt].alt930) #FUN-680019
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_alt.deleteElement(g_cnt)
    LET g_rec_b=(g_cnt-1)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_alt TO s_alt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t800_fetch('L')
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
         CALL t800_def_form()      #NO.FUN-7100290
         #CALL cl_set_field_pic(g_als.alsfirm,"","","","","") #CHI-C80041
         IF g_als.alsfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
         CALL cl_set_field_pic(g_als.alsfirm,"","","",g_void,"") #CHI-C80041
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 費用資料
      ON ACTION expense_data
         LET g_action_choice="expense_data"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
      #@ON ACTION 工廠切換
      #--FUN-B10030--start--
      # ON ACTION switch_plant
      #   LET g_action_choice="switch_plant"
      #   EXIT DISPLAY
      #--FUN-B10030--end--
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
 
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY                      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t800_g_b()
   DEFINE l_tot            LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_sql            LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(600)
   DEFINE l_alt            RECORD LIKE alt_file.*
   DEFINE l_ima44          LIKE ima_file.ima44      #MOD-B30635
   DEFINE l_ima31          LIKE ima_file.ima31      #MOD-B30635
   DEFINE l_ima906         LIKE ima_file.ima906     #MOD-B30635
   DEFINE l_ima907         LIKE ima_file.ima907     #MOD-B30635
   DEFINE l_ima908         LIKE ima_file.ima908     #MOD-B30635
   DEFINE l_factor         LIKE ima_file.ima31_fac  #MOD-B30635
 
   IF g_als.als01 IS NULL THEN RETURN END IF
   DECLARE t800_g_b_c1 CURSOR WITH HOLD FOR
      #----------------------MOD-C70311---------------------------(S)
      #--MOD-C70311--mark
      #SELECT '',alb02,alb06,(alb07-alb12),(alb08-alb13),alb11,alb04,alb05,
      #      #'',alb80,alb81,alb82,alb83,alb84,alb85,alb86,alb87      #FUN-710029 #MOD-B30635 mark 
      #       alb930,alb80,alb81,alb82,alb83,alb84,alb85,alb86,alb87              #MOD-B30635 add alb930 
      #  FROM alb_file WHERE alb01=g_als.als03
      #--MOD-C70311--mark
       SELECT '',alb02,alb06,(alb07-alb12),(alb08-alb13),
              alb11,alb04,alb05,alb930,alb80,
              alb81,alb82,alb83,alb84,alb85,
              alb86,(alb87 - alb12)
         FROM alb_file WHERE alb01 = g_als.als03
      #----------------------MOD-C70311---------------------------(S)
   FOREACH t800_g_b_c1 INTO l_alt.*
      IF l_alt.alt06 <= 0 THEN CONTINUE FOREACH END IF
      LET l_alt.alt01=g_als.als01
     #自動產生時,數量應扣除已存在於aapt800的數量
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_als.als11
      LET l_tot = 0
      SELECT SUM(alt06) INTO l_tot 
       #FROM alt_file                        #MOD-C50158 mark
        FROM alt_file,als_file               #MOD-C50158 add
       WHERE alt14 = l_alt.alt14 
         AND alt15 = l_alt.alt15
         AND alt01 = als01                   #MOD-C50158 add
         AND als03 = g_als.als03             #MOD-C50158 add
         AND alsfirm <> 'X'                  #CHI-C80041
         AND (als01 NOT IN (SELECT alk01 FROM alk_file              #MOD-C70311 add
                            WHERE alkfirm = 'Y' ))                  #MOD-C70311 add
      IF cl_null(l_tot) THEN LET l_tot = 0 END IF
      IF l_tot != 0 THEN
         LET l_alt.alt06=l_alt.alt06-l_tot
         LET l_alt.alt07=l_alt.alt05*l_alt.alt06
         LET l_alt.alt07=cl_digcut(l_alt.alt07,t_azi04)
         LET l_alt.alt87 = l_alt.alt87 - l_tot                       #MOD-C70311 add
      END IF
      IF g_sma.sma115 = 'Y' THEN
        #CALL t800_set_du_by_origin('b') #MOD-B30635 mark
        #-MOD-B30635-add-
         SELECT ima44,ima906,ima907,ima908 INTO l_ima44,l_ima906,l_ima907,l_ima908
           FROM ima_file 
          WHERE ima01 = l_alt.alt11
         
         IF cl_null(l_alt.alt80) THEN
            LET l_alt.alt80 = l_alt.alt86
            LET l_alt.alt82 = l_alt.alt07
         END IF
         
         IF l_ima906 = '1' THEN  #不使用雙單位
            LET l_alt.alt83 = NULL
            LET l_alt.alt84 = NULL
            LET l_alt.alt85 = NULL
         ELSE
            IF cl_null(l_alt.alt83) THEN
               LET l_alt.alt83 = l_ima907
               CALL s_du_umfchk(l_alt.alt11,'','','',l_alt.alt86,l_ima907,l_ima906)
                    RETURNING g_errno,l_factor
               LET l_alt.alt84 = l_factor
               LET l_alt.alt85 = 0
            END IF
         END IF
         IF cl_null(l_alt.alt86) THEN
            LET l_alt.alt86 = l_alt.alt86
            LET l_alt.alt87 = l_alt.alt06
         END IF
        #-MOD-B30635-end-
      END IF
      LET l_alt.altlegal = g_legal #FUN-980001
      INSERT INTO alt_file VALUES (l_alt.*)
   END FOREACH
   CALL t800_b_tot('u')
END FUNCTION
 
FUNCTION t800_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("als01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t800_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("als01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t800_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF INFIELD(alt14) THEN
      CALL cl_set_comp_entry("alt11",TRUE)
   END IF
 
   CALL cl_set_comp_entry("alt81,alt83,alt84,alt85,alt87",TRUE)
 
END FUNCTION
 
FUNCTION t800_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF INFIELD(alt14) THEN
      IF g_alt[l_ac].alt14 != 'MISC' THEN
         CALL cl_set_comp_entry("alt11",FALSE)
      END IF
   END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("alt83,alt84,alt85",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("alt83",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("alt84,alt81",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("alt87",FALSE)
   END IF
END FUNCTION
 
FUNCTION t800_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("alt83,alt85,alt80,alt82",FALSE)
      CALL cl_set_comp_visible("pmn07,alt06",TRUE)
   ELSE
      CALL cl_set_comp_visible("alt83,alt84,alt85,alt80,alt81,alt82",TRUE)
      CALL cl_set_comp_visible("pmn07,alt06",FALSE)
   END IF
 
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_visible("alt86,alt87",FALSE)
   END IF
 
   CALL cl_set_comp_visible("alt84,alt81",FALSE)
 
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt82",g_msg CLIPPED)
   END IF
 
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("alt82",g_msg CLIPPED)
   END IF
   CALL cl_set_comp_visible("alt930,gem02",g_aaz.aaz90='Y')
END FUNCTION
 
FUNCTION t800_set_required()
   IF g_sma.sma115 = 'Y' THEN
       #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
       IF g_ima906 = '3' THEN
            CALL cl_set_comp_required("alt83,alt85,alt80,alt82",TRUE)
       END IF
       #單位不同,轉換率,數量必KEY
       IF NOT cl_null(g_alt[l_ac].alt80) THEN
          CALL cl_set_comp_required("alt82",TRUE)
       END IF
       IF NOT cl_null(g_alt[l_ac].alt83) THEN
          CALL cl_set_comp_required("alt85",TRUE)
       END IF
       IF g_sma.sma116 NOT MATCHES '[02]' THEN
            IF NOT cl_null(g_alt[l_ac].alt86) THEN
                CALL cl_set_comp_required("alt87",TRUE)
            END IF
       END IF
   END IF
END FUNCTION
 
FUNCTION t800_set_no_required()
  CALL cl_set_comp_required("alt83,alt84,alt85,alt80,alt81,alt82,alt86,alt87",FALSE)
END FUNCTION
 
#default 雙單位/轉換率/數量
FUNCTION t800_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima31  LIKE ima_file.ima31,
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima908 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_unit3  LIKE img_file.img09,     #計價單位
            l_qty3   LIKE img_file.img10,     #計價數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    LET l_item = g_alt[l_ac].alt11
    SELECT ima44,ima31,ima906,ima907,ima908
      INTO l_ima44,l_ima31,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_item
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_ima44,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
 
    LET l_unit1 = l_ima44
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF
 
    IF p_cmd = 'a' THEN
       LET g_alt[l_ac].alt83=l_unit2
       LET g_alt[l_ac].alt84=l_fac2
       LET g_alt[l_ac].alt85=l_qty2
       LET g_alt[l_ac].alt80=l_unit1
       LET g_alt[l_ac].alt81=l_fac1
       LET g_alt[l_ac].alt82=l_qty1
       LET g_alt[l_ac].alt86=l_unit3
       LET g_alt[l_ac].alt87=l_qty3
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t800_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pmn_file.pmn84,
            l_qty2   LIKE pmn_file.pmn85,
            l_fac1   LIKE pmn_file.pmn81,
            l_qty1   LIKE pmn_file.pmn82,
            l_factor LIKE ima_file.ima31_fac,  
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44
 
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=g_alt[l_ac].alt11
    IF SQLCA.sqlcode = 100 THEN
       IF g_alt[l_ac].alt11 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_alt[l_ac].alt84
    LET l_qty2=g_alt[l_ac].alt85
    LET l_fac1=g_alt[l_ac].alt81
    LET l_qty1=g_alt[l_ac].alt82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_alt[l_ac].alt86=g_alt[l_ac].alt80
                   LET g_alt[l_ac].alt06=l_qty1    #MOD-820156
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_alt[l_ac].alt86=l_ima44
                   LET g_alt[l_ac].alt06=l_tot   #MOD-820156
          WHEN '3' LET g_alt[l_ac].alt86=g_alt[l_ac].alt80
                   LET g_alt[l_ac].alt06=l_qty1   #MOD-820156
                   IF l_qty2 <> 0 THEN
                      LET g_alt[l_ac].alt84=l_qty1/l_qty2
                   ELSE
                      LET g_alt[l_ac].alt84=0
                   END IF
       END CASE
       LET g_alt[l_ac].alt06 = s_digqty(g_alt[l_ac].alt06,g_alt[l_ac].pmn07)   #FUN-BB0085
    END IF
    LET g_factor = 1
    CALL s_umfchk(g_alt[l_ac].alt11,g_alt[l_ac].alt86,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    IF g_sma.sma116 ='0' OR g_sma.sma116 ='2' THEN
       LET g_alt[l_ac].alt87 = g_alt[l_ac].alt06   #MOD-940190
    END IF
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t800_du_data_to_correct()
   IF cl_null(g_alt[l_ac].alt80) THEN
      LET g_alt[l_ac].alt81 = NULL
      LET g_alt[l_ac].alt82 = NULL
   END IF
 
   IF cl_null(g_alt[l_ac].alt83) THEN
      LET g_alt[l_ac].alt84 = NULL
      LET g_alt[l_ac].alt85 = NULL
   END IF
 
   IF cl_null(g_alt[l_ac].alt86) THEN
      LET g_alt[l_ac].alt87 = NULL
   END IF
   DISPLAY BY NAME g_alt[l_ac].alt81
   DISPLAY BY NAME g_alt[l_ac].alt82
   DISPLAY BY NAME g_alt[l_ac].alt84
   DISPLAY BY NAME g_alt[l_ac].alt85
   DISPLAY BY NAME g_alt[l_ac].alt86
   DISPLAY BY NAME g_alt[l_ac].alt87
 
END FUNCTION
 
FUNCTION t800_set_alt87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor  LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_alt[l_ac].alt11
 
    IF SQLCA.sqlcode =100 THEN
       IF g_alt[l_ac].alt11 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_alt[l_ac].alt84
       LET l_qty2=g_alt[l_ac].alt85
       LET l_fac1=g_alt[l_ac].alt81
       LET l_qty1=g_alt[l_ac].alt82
    ELSE
       LET l_fac1=g_alt[l_ac].alt86
       LET l_qty1=g_alt[l_ac].alt07
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    IF g_sma.sma115 = 'Y' THEN
       CALL s_umfchk(g_alt[l_ac].alt11,g_alt[l_ac].pmn07,g_alt[l_ac].alt86)
            RETURNING g_cnt,l_factor
    ELSE
    CALL s_umfchk(g_alt[l_ac].alt11,l_ima44,g_alt[l_ac].alt86)
          RETURNING g_cnt,l_factor
    END IF                                   #No.CHI-960052
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET l_tot = s_digqty(l_tot,g_alt[l_ac].alt86)    #FUN-BB0085
    LET g_alt[l_ac].alt87 = l_tot
END FUNCTION
 
FUNCTION t800_set_du_by_origin(p_code)
  DEFINE l_ima44    LIKE ima_file.ima44,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_alt11    LIKE alt_file.alt11,
         l_factor   LIKE ima_file.ima31_fac,  #No.FUN-680136  DECIMAL(16,8),
         p_code     LIKE type_file.chr1       #No.FUN-680136  VARCHAR(01)
 
    LET l_alt11 = g_alt[l_ac].alt11
    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_alt11
 
    IF cl_null(g_alt[l_ac].alt80) THEN
       LET g_alt[l_ac].alt80 = g_alt[l_ac].alt86
       LET g_alt[l_ac].alt82 = g_alt[l_ac].alt07
    END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET g_alt[l_ac].alt83 = NULL
       LET g_alt[l_ac].alt84 = NULL
       LET g_alt[l_ac].alt85 = NULL
    ELSE
       IF cl_null(g_alt[l_ac].alt83) THEN
          LET g_alt[l_ac].alt83 = l_ima907
          CALL s_du_umfchk(l_alt11,'','','',g_alt[l_ac].alt86,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET g_alt[l_ac].alt84 = l_factor
          LET g_alt[l_ac].alt85 = 0
       END IF
    END IF
    IF cl_null(g_alt[l_ac].alt86) THEN
       LET g_alt[l_ac].alt86 = g_alt[l_ac].alt86
       LET g_alt[l_ac].alt87 = g_alt[l_ac].alt06   #MOD-940190
    END IF
END FUNCTION

#FUN-BB0085--------add--------str--------
FUNCTION t800_alt06_check()
   IF NOT cl_null(g_alt[l_ac].alt06) AND NOT cl_null(g_alt[l_ac].pmn07) THEN 
      LET g_alt[l_ac].alt06 = s_digqty(g_alt[l_ac].alt06,g_alt[l_ac].pmn07)
      DISPLAY BY NAME g_alt[l_ac].alt06
   END IF 
 
   IF NOT cl_null(g_alt[l_ac].alt06) THEN
      IF g_sma.sma116 MATCHES '[02]' THEN
         LET g_alt[l_ac].alt87 = g_alt[l_ac].alt06
      END IF
      LET g_alt[l_ac].alt07 = g_alt[l_ac].alt06 * g_alt[l_ac].alt05
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11   #NO.CHI-6A0004
      LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)   #NO.CHI-6A0004
      CALL t800_qty_chk()
   END IF
END FUNCTION

FUNCTION t800_alt82_check(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1 
   IF NOT cl_null(g_alt[l_ac].alt82) AND NOT cl_null(g_alt[l_ac].alt80) THEN 
      IF cl_null(g_alt80_t) OR g_alt80_t != g_alt[l_ac].alt80 OR 
         cl_null(g_alt_t.alt82) OR g_alt_t.alt82 != g_alt[l_ac].alt82 THEN 
         LET g_alt[l_ac].alt82 = s_digqty(g_alt[l_ac].alt82,g_alt[l_ac].alt80)
         DISPLAY BY NAME g_alt[l_ac].alt82
      END IF
   END IF

   IF NOT cl_null(g_alt[l_ac].alt82) THEN
      IF g_alt[l_ac].alt82 < 0 THEN
         CALL cl_err('','aim-391',1)
         RETURN FALSE    
      END IF
   END IF
   CALL t800_set_origin_field()
   IF cl_null(g_alt[l_ac].alt86) THEN
      LET g_alt[l_ac].alt87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_alt_t.alt81 <> g_alt[l_ac].alt81 OR
             g_alt_t.alt82 <> g_alt[l_ac].alt82 OR
             g_alt_t.alt84 <> g_alt[l_ac].alt84 OR
             g_alt_t.alt85 <> g_alt[l_ac].alt85 OR
             g_alt_t.alt86 <> g_alt[l_ac].alt86) THEN
         CALL t800_set_alt87()
      END IF
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION

FUNCTION t800_alt85_check(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1 
   IF NOT cl_null(g_alt[l_ac].alt85) AND NOT cl_null(g_alt[l_ac].alt83) THEN 
      IF cl_null(g_alt83_t) OR g_alt83_t != g_alt[l_ac].alt83 OR 
         cl_null(g_alt_t.alt85) OR g_alt_t.alt85 != g_alt[l_ac].alt85 THEN 
         LET g_alt[l_ac].alt85 = s_digqty(g_alt[l_ac].alt85,g_alt[l_ac].alt83)
         DISPLAY BY NAME g_alt[l_ac].alt85
      END IF
   END IF 

   IF NOT cl_null(g_alt[l_ac].alt85) THEN
      IF g_alt[l_ac].alt85 < 0 THEN
         CALL cl_err('','aim-391',1)
         RETURN FALSE    
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_alt_t.alt85 <> g_alt[l_ac].alt85 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_alt[l_ac].alt85*g_alt[l_ac].alt84
            IF cl_null(g_alt[l_ac].alt82) OR g_alt[l_ac].alt82=0 THEN
               LET g_alt[l_ac].alt82=g_tot*g_alt[l_ac].alt81
               LET g_alt[l_ac].alt82=s_digqty(g_alt[l_ac].alt82,g_alt[l_ac].alt80) 
               DISPLAY BY NAME g_alt[l_ac].alt82
            END IF
         END IF
      END IF
   END IF
   IF cl_null(g_alt[l_ac].alt86) THEN
      LET g_alt[l_ac].alt87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
            (g_alt_t.alt81 <> g_alt[l_ac].alt81 OR
             g_alt_t.alt82 <> g_alt[l_ac].alt82 OR
             g_alt_t.alt84 <> g_alt[l_ac].alt84 OR
             g_alt_t.alt85 <> g_alt[l_ac].alt85 OR
             g_alt_t.alt86 <> g_alt[l_ac].alt86) THEN
         CALL t800_set_alt87()
      END IF
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION

#TQC-C20183-----------mark--------------str---------------------------
#FUNCTION t800_alt87_check()
#   IF NOT cl_null(g_alt[l_ac].alt87) AND NOT cl_null(g_alt[l_ac].alt86) THEN 
#      IF cl_null(g_alt86_t) OR g_alt86_t != g_alt[l_ac].alt86 OR 
#         cl_null(g_alt_t.alt87) OR g_alt_t.alt87 != g_alt[l_ac].alt87 THEN 
#         LET g_alt[l_ac].alt87 = s_digqty(g_alt[l_ac].alt87,g_alt[l_ac].alt86)
#         DISPLAY BY NAME g_alt[l_ac].alt87
#      END IF 
#   END IF  
# 
#   IF NOT cl_null(g_alt[l_ac].alt87) THEN
#      IF g_alt[l_ac].alt87 < 0 THEN
#         CALL cl_err('','aim-391',1)
#         RETURN FALSE    
#      END IF
#      LET g_alt[l_ac].alt07 = g_alt[l_ac].alt87 * g_alt[l_ac].alt05
#      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_als.als11
#      LET g_alt[l_ac].alt07 = cl_digcut(g_alt[l_ac].alt07,t_azi04)
#   END IF
#   RETURN TRUE
#END FUNCTION
#TQC-C20183------------mark--------------end------------------------------
#FUN-BB0085--------add--------end--------
#No.FUN-9C0077 程式精簡
#CHI-C80041---begin
FUNCTION t800_x()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_als.als01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t800_cl USING g_als.als01
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t800_cl INTO g_als.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_als.als01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t800_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_als.alsfirm = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_als.alsfirm)   THEN 
        LET l_chr=g_als.alsfirm
        IF g_als.alsfirm='N' THEN 
            LET g_als.alsfirm='X' 
        ELSE
            LET g_als.alsfirm='N'
        END IF
        UPDATE als_file
            SET alsfirm=g_als.alsfirm,  
                alsmodu=g_user,
                alsdate=g_today
            WHERE als01=g_als.als01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","als_file",g_als.als01,"",SQLCA.sqlcode,"","",1)  
            LET g_als.alsfirm=l_chr 
        END IF
        DISPLAY BY NAME g_als.alsfirm 
   END IF
 
   CLOSE t800_cl
   COMMIT WORK
   CALL cl_flow_notify(g_als.als01,'V')
 
END FUNCTION
#CHI-C80041---end
