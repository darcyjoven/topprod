# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: aapt741.4gl
# Descriptions...: 信用狀修改付款作業
# Date & Author..: 95/11/10 By Roger
# Modify.........: 97/04/22 By Star [將apc_file 改為 npp_file,npq_file ]
# Modify.........: No.MOD-4B0022 04/11/03 ching p_bank改用like方式
# Modify.........: No.FUN-4B0054 04/11/23 By ching add 匯率開窗 call s_rate
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-4C0040 04/12/15 By Smapmin 新增alc79付款日期欄位
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify ........: No.FUN-560002 05/06/03 By day  單據編號修改
# Modify.........: NO.MOD-420449 05/07/08 By Yiting 加入g_chkey判斷  key值可更改
# Modify.........: NO.FUN-5C0015 05/12/20 By alana
#                  call s_def_npq.4gl 抓取異動碼、摘要default值
# Modify.........: No.MOD-640018 06/04/13 By Smapmin 加入alc02<>0的條件
# Modify.........: No.FUN-640239 06/04/25 By Smapmin CALL s_bankex2改為CALL s_bankex
# Modify.........: No.FUN-660122 06/06/19 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670060 06/08/01 By Rayven 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680019 06/08/08 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680029 06/08/23 By Rayven 新增多帳套功能
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0016 06/11/15 By jamie 1.FUNCTION_fetch()查詢後應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-690058 06/12/08 By Smapmin 由於銀行類別為'1'時是不須寫入 nme_file 的,故修正為"當銀行類別為2時,就給nme12的值"
# Modify.........: No.FUN-730032 07/03/21 By wujie   網銀功能相關修改，nme新增欄位
# Modify ........: No.FUN-730064 07/04/03 By mike     會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By hongmei 用年度取帳號 
# Modify.........: No.MOD-740346 07/04/23 By Rayven 不使用網銀時不去判斷是否未轉
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780050 07/08/09 By Smapmin 預購修改確認後,才可以執行修改後付款作業
# Modify.........: No.MOD-780066 07/08/09 By Smapmin 增加alc02舊值備份
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850002 08/05/05 By Smapmin 增加列印功能
# Modify.........: No.FUN-850038 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-860090 08/06/26 By sherry 列印功能call aapr741憑証
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980017 09/08/27 By destiny 把alaplant該為ala97 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: NO.FUN-990031 09/10/26 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下;开放营运中心可录
# Modify.........: No.FUN-9A0099 09/10/29 By TSD.apple   GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0012 09/12/02 By ddestiny nem_file补PK，在insert表时给PK字段预设值
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No.FUN-9A0036 10/07/27 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/27 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/27 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:CHI-AA0015 10/11/05 By Summer alc02原為vachar(1)改為Number(5)
# Modify.........: No.FUN-AA0087 11/01/26 By chenmoyan 異動碼設定類型改善
# Modify.........: No.FUN-AA0087 11/01/27 By Mengxw    異動碼類型設定的改善
# Modify.........: No.MOD-B30334 11/03/18 By Dido 若已有開票則不可再修改;寫入nme12=alc01 
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file    
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
# Modify.........: No.FUN-D10065 13/01/15 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1 LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(20),
    g_argv2 LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
    g_ala   RECORD LIKE ala_file.*,
    g_alc   RECORD LIKE alc_file.*,
    g_nme   RECORD LIKE nme_file.*,
    g_nmd   RECORD LIKE nmd_file.*,
    g_alc_t RECORD LIKE alc_file.*,
    g_alc01_t LIKE alc_file.alc01,
    g_alc02_t LIKE alc_file.alc02,
    g_dbs_gl  LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    g_plant_gl  LIKE type_file.chr21,       # No.FUN-980059 VARCHAR(21),
    g_dbs_nm  LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),
    l_cnt     LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    gl_no_b,gl_no_e   LIKE abb_file.abb01,      # No.FUN-690028 VARCHAR(16),     #No.FUN-550030
    g_t1    LIKE oay_file.oayslip,            #No.FUN-550030  #No.FUN-690028 VARCHAR(5)
    g_before_input_done LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    tot       LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
     g_wc,g_sql          string  #No.FUN-580092 HCN
#------for ora修改-------------------
DEFINE g_system         LIKE type_file.chr2        # No.FUN-690028 VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_N              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
#------for ora修改-------------------
 
DEFINE   g_forupd_sql   STRING     #SELECT ... FOR UPDATE SQL
DEFINE   g_chr          LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-690028 INTEGER
 
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_str          STRING     #No.FUN-670060
DEFINE   g_wc_gl        STRING     #No.FUN-670060
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_bookno1      LIKE aza_file.aza81    #No.FUN-730064
DEFINE   g_bookno2      LIKE aza_file.aza82    #No.FUN-730064 
DEFINE   g_bookno3      LIKE aza_file.aza82    #No.FUN-D40118   Add
DEFINE   g_flag         LIKE type_file.chr1    #No.FUN-730064 
DEFINE   g_npq25        LIKE npq_file.npq25    #No.FUN-9A0036
DEFINE   g_azi04_2      LIKE azi_file.azi04    #FUN-A40067

MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 

    LET g_plant_new=g_apz.apz04p
    CALL s_getdbs()
    LET g_dbs_nm=g_dbs_new

    IF cl_null(g_dbs_nm) THEN
       LET g_dbs_nm = NULL
    END IF

    LET g_plant_new=g_apz.apz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new
    IF g_dbs_gl = ' ' THEN
       LET g_dbs_gl = NULL
    END IF

    INITIALIZE g_alc.* TO NULL
    INITIALIZE g_alc_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM alc_file WHERE alc01 = ? AND alc02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t741_cl CURSOR FROM g_forupd_sql
 
    OPEN WINDOW t741_w WITH FORM "aap/42f/aapt741"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    
    CALL cl_set_comp_visible("ala930,gem02b",g_aaz.aaz90='Y')
 
    IF NOT cl_null(g_argv1) THEN CALL t741_q() END IF
 
      LET g_action_choice=""
      CALL t741_menu()
 
    CLOSE WINDOW t741_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t741_cs()
    CLEAR FORM
    IF cl_null(g_argv1) THEN
   INITIALIZE g_alc.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                 alc01,alc24,alc80,alc74,alc08,alc79,alc02,   #MOD-4C0040
                alcfirm,alc78
                #FUN-850038   ---start---
                ,alcud01,alcud02,alcud03,alcud04,alcud05,
                alcud06,alcud07,alcud08,alcud09,alcud10,
                alcud11,alcud12,alcud13,alcud14,alcud15
                #FUN-850038    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
            ON ACTION controlp           #85-10-17
               CASE
                  WHEN INFIELD(alc01) # APO
                       CALL q_ala(TRUE,TRUE,g_alc.alc01)
                            RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO alc01
{
                  WHEN INFIELD(alc81) #外幣支付銀行
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_nma"
                     LET g_qryparam.default1 = g_alc.alc81
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO alc81
                     NEXT FIELD alc81
                  WHEN INFIELD(alc91) #本幣支付銀行
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_nma"
                     LET g_qryparam.default1 = g_alc.alc91
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO alc91
                     NEXT FIELD alc91
                  WHEN INFIELD(alc96) #銀行異動碼
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_nmc"
                     LET g_qryparam.default1 = g_alc.alc96
                     CALL cl_create_qry() RETURNING g_alc.alc96
                     DISPLAY BY NAME g_alc.alc96
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO alc96
                     NEXT FIELD alc96
}
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
          END CONSTRUCT
          LET g_wc = g_wc CLIPPED,cl_get_extra_cond('alcuser', 'alcgrup') #FUN-980030
 
 
      #ELSE LET g_wc=" alc01='",g_argv1,"' AND alc02='",g_argv2,"'" #CHI-AA0015 mark
       ELSE LET g_wc=" alc01='",g_argv1,"' AND alc02=",g_argv2 #CHI-AA0015
    END IF
    LET g_sql="SELECT alc01,alc02 FROM alc_file ", # 組合出 SQL 指令
        #" WHERE ",g_wc CLIPPED, " ORDER BY alc01,alc02"   #MOD-640018
        #" WHERE alc02 <> '0' AND ",g_wc CLIPPED, " ORDER BY alc01,alc02"   #MOD-640018   #MOD-780050
        " WHERE alc02 <> 0 AND alcfirm = 'Y' AND ",g_wc CLIPPED, " ORDER BY alc01,alc02"   #MOD-640018   #MOD-780050 #CHI-AA0015 mod '0'->0
    PREPARE t741_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t741_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t741_prepare
    LET g_sql=
        #"SELECT COUNT(*) FROM alc_file WHERE ",g_wc CLIPPED   #MOD-640018
        #"SELECT COUNT(*) FROM alc_file WHERE alc02 <> '0' AND ",g_wc CLIPPED   #MOD-640018   #MOD-780050
        "SELECT COUNT(*) FROM alc_file WHERE alc02 <> 0 AND alcfirm = 'Y' AND ",g_wc CLIPPED   #MOD-640018   #MOD-780050 #CHI-AA0015 mod '0'->0
    PREPARE t741_precount FROM g_sql
    DECLARE t741_count CURSOR FOR t741_precount
END FUNCTION
 
FUNCTION t741_menu()
    DEFINE l_cmd        LIKE type_file.chr1000    #FUN-850002
    DEFINE l_wc         STRING   #FUN-850002
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
            #No.FUN-680029 --start--
            IF g_aza.aza63 = 'N' THEN
               CALL cl_set_act_visible("maintain_entry_sheet_2",FALSE)
            END IF
            #No.FUN-680029 --end--
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t741_q()
            END IF
        ON ACTION next
            CALL t741_fetch('N')
        ON ACTION previous
            CALL t741_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t741_u()
            END IF
        #-----FUN-850002---------
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              LET l_wc = 'alc01="',g_alc.alc01,'" AND ',
                         'alc02="',g_alc.alc02,'"'
              #LET l_cmd = "aapr701 '",g_today CLIPPED,"' ''",   #No.FUN-860090
            #   LET l_cmd = "aapr741 '",g_today CLIPPED,"' ''",    #No.FUN-860090  #FUN-C30085 mark
              LET l_cmd = "aapg741 '",g_today CLIPPED,"' ''", #FUN-C30085 add
                          " '",g_lang CLIPPED,"' 'Y' '' '1' '",l_wc CLIPPED,"'"
              DISPLAY l_cmd 
              CALL cl_cmdrun(l_cmd)
           END IF
        #-----END FUN-850002-----
        ON ACTION gen_check
            CALL t741_g_nmd(g_alc.alc91,1,g_alc.alc95,g_alc.alc95)
        ON ACTION gen_entry_sheet
            CALL t741_g_gl(g_alc.alc01,7,g_alc.alc02)
        ON ACTION maintain_entry_sheet
            CALL s_fsgl('LC',7,g_alc.alc01,0,g_apz.apz02b,g_alc.alc02,
                 g_alc.alc78,'0',g_apz.apz02p)  #No.FUN-680029 add '0',g_apz.apz02p
            CALL cl_navigator_setting( g_curs_index, g_row_count )  #No.FUN-680029
            CALL t741_npp02()
        #No.FUN-680029 --start--
        ON ACTION maintain_entry_sheet_2
            CALL s_fsgl('LC',7,g_alc.alc01,0,g_apz.apz02c,g_alc.alc02,
                 g_alc.alc78,'1',g_apz.apz02p)
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL t741_npp02()
        #No.FUN-680029 --end--
 
        #No.FUN-670060 --start-- 
        ON ACTION carry_voucher
            IF cl_chk_act_auth() THEN
               IF g_alc.alc78 = 'Y' THEN 
                  CALL t741_carry_voucher()  
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF  
           END IF  
        ON ACTION undo_carry_voucher 
            IF cl_chk_act_auth() THEN
               IF g_alc.alc78 = 'Y' THEN 
                  CALL t741_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF  
           END IF  
        #No.FUN-670060 --end-- 
 
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t741_y()
               CALL cl_set_field_pic(g_alc.alc78,"","","","","")
            END IF
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t741_z()
               CALL cl_set_field_pic(g_alc.alc78,"","","","","")
            END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic(g_alc.alc78,"","","","","")
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
            CALL t741_fetch('/')
        ON ACTION first
            CALL t741_fetch('F')
        ON ACTION last
            CALL t741_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0016-------add--------str----
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_alc.alc01 IS NOT NULL THEN
                  LET g_doc.column1 = "alc01"
                  LET g_doc.column2 = "alc02"
                  LET g_doc.value1 = g_alc.alc01
                  LET g_doc.value2 = g_alc.alc02
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
    CLOSE t741_cs
END FUNCTION
 
 
FUNCTION t741_i(p_cmd)
    DEFINE   li_result   LIKE type_file.num5      #No.FUN-560002  #No.FUN-690028 SMALLINT
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        g_t1            LIKE oay_file.oayslip,    #No.FUN-550030  #No.FUN-690028 VARCHAR(5)
        l_flag          LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_n             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        #l_nma10	 VARCHAR(4),     #FUN-660117 remark
        l_nma10		LIKE nma_file.nma10, #FUN-660117
        p_kind          LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(10),
        l_nnp06         LIKE nnp_file.nnp06
 
    INPUT BY NAME
         g_ala.ala97,   #FUN-990031     
         g_alc.alc01,  #MOD-420449
         g_alc.alc80,g_alc.alc79,g_alc.alc74,g_alc.alc81,g_alc.alc82,g_alc.alc84,   #MOD-4C0040
        g_alc.alc85,g_alc.alc91,g_alc.alc92,g_alc.alc94,
        g_alc.alc951,g_alc.alc952,g_alc.alc953,g_alc.alc95,
        g_alc.alc96,g_alc.alc93,g_alc.alc83,g_alc.alc76,g_alc.alc931,
        g_alc.alc932
        #FUN-850038     ---start---
        ,g_alc.alcud01,g_alc.alcud02,g_alc.alcud03,g_alc.alcud04,
        g_alc.alcud05,g_alc.alcud06,g_alc.alcud07,g_alc.alcud08,
        g_alc.alcud09,g_alc.alcud10,g_alc.alcud11,g_alc.alcud12,
        g_alc.alcud13,g_alc.alcud14,g_alc.alcud15 
        #FUN-850038     ----end----
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
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

        BEFORE FIELD alc80
          CALL i110_set_entry(p_cmd)
 
        AFTER FIELD alc80
          IF NOT cl_null(g_alc.alc80) THEN
            IF g_alc.alc80 NOT MATCHES "[01]" THEN
               NEXT FIELD alc80
            END IF
            IF g_alc.alc80='0' THEN
               LET g_alc.alc81='' LET g_alc.alc82='' LET g_alc.alc83=NULL
               LET g_alc.alc84='' LET g_alc.alc85=0
               DISPLAY BY NAME g_alc.alc81, g_alc.alc82, g_alc.alc83,
                               g_alc.alc84, g_alc.alc85
            END IF
          END IF
          CALL i110_set_no_entry(p_cmd)
 
        BEFORE FIELD alc96
            IF cl_null(g_alc.alc96) THEN
               LET g_alc.alc96 = g_apz.apz58
               DISPLAY BY NAME g_alc.alc96
            END IF
 
        AFTER FIELD alc96
          IF NOT cl_null(g_alc.alc96) THEN
               CALL t741_alc96(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_alc.alc96,g_errno,0)
                  LET g_alc.alc96 = g_alc_t.alc96
                  DISPLAY BY NAME g_alc.alc96
                  NEXT FIELD alc96
               END IF
            END IF
 
{
        BEFORE FIELD alc81,alc85
            IF g_alc.alc80='0' THEN
            IF cl_ku() THEN NEXT FIELD alc80 ELSE NEXT FIELD alc91 END IF
            END IF
}
        AFTER FIELD alc81
          IF NOT cl_null(g_alc.alc81)  THEN
            SELECT nma10,nma28 INTO l_nma10,g_alc.alc82
                   FROM nma_file WHERE nma01=g_alc.alc81
              IF STATUS THEN 
#             CALL cl_err('sel nma:',STATUS,0)    #No.FUN-660122
              CALL cl_err3("sel","nma_file",g_alc.alc81,"",STATUS,"","sel nma:",1)  #No.FUN-660122
              NEXT FIELD alc81
            END IF
            IF l_nma10!=g_ala.ala20 THEN
               CALL cl_err(l_nma10,'aap-231',0)    #85-10-17
               NEXT FIELD alc81
            END IF
            DISPLAY BY NAME g_alc.alc82
          END IF
 
        AFTER FIELD alc84
          IF NOT cl_null(g_alc.alc84)  THEN
#           IF g_alc.alc84 = 0     THEN NEXT FIELD alc84 END IF
            LET g_alc.alc85 = g_alc.alc34 * g_alc.alc84
            DISPLAY BY NAME g_alc.alc85
          END IF
 
        BEFORE FIELD alc84
            IF g_alc.alc84 = 0 OR g_alc.alc84 IS NULL THEN # 計算平均出帳匯率
               #CALL s_bankex2(g_alc.alc81,g_alc.alc08) RETURNING g_alc.alc84   #FUN-640239
               CALL s_bankex(g_alc.alc81,g_alc.alc08) RETURNING g_alc.alc84   #FUN-640239
               DISPLAY BY NAME g_alc.alc84
            END IF
 
        AFTER FIELD alc91
          IF NOT cl_null(g_alc.alc91) THEN
            SELECT nma10,nma28 INTO l_nma10,g_alc.alc92
                   FROM nma_file WHERE nma01=g_alc.alc91
              IF STATUS THEN 
#             CALL cl_err('sel nma:',STATUS,0)   #No.FUN-660122
              CALL cl_err3("sel","nma_file",g_alc.alc81,"",STATUS,"","sel nma:",1)  #No.FUN-660122
              NEXT FIELD alc91 
            END IF
            IF l_nma10!=g_aza.aza17 THEN
               CALL cl_err(l_nma10,'aap-231',0)    #85-10-17
               NEXT FIELD alc91
            END IF
            DISPLAY BY NAME g_alc.alc92
            IF g_alc.alc94 IS NULL OR g_alc.alc94 = 0 THEN
               LET g_alc.alc94 = g_alc.alc51
            END IF
            IF g_alc.alc80 = '0' AND
              (g_alc.alc951 IS NULL OR g_alc.alc951 = 0) THEN
               LET g_alc.alc951 = g_alc.alc52
            END IF
            IF g_alc.alc952 IS NULL OR g_alc.alc952 = 0 THEN
               LET g_alc.alc952 = g_alc.alc53
            END IF
            IF g_alc.alc953 IS NULL OR g_alc.alc953 = 0 THEN
               LET g_alc.alc953 = g_alc.alc54
            END IF
            #No.8015
            DISPLAY BY NAME g_alc.alc94
            DISPLAY BY NAME g_alc.alc951
            DISPLAY BY NAME g_alc.alc952
            DISPLAY BY NAME g_alc.alc953
 
         END IF
 
        BEFORE FIELD alc931,alc932
            IF g_alc.alc92='2' THEN
               LET g_alc.alc931='' LET g_alc.alc932=''
               DISPLAY BY NAME g_alc.alc931,g_alc.alc932
            END IF
 
#No.FUN-560002-begin
        AFTER FIELD alc931
          IF NOT cl_null(g_alc.alc931) THEN
             CALL s_check_no("anm",g_alc.alc931,"","1","","","")
             RETURNING li_result,g_alc.alc931
             IF (NOT li_result) THEN
                NEXT FIELD alc931
             END IF
#           CALL s_nmyslip(g_alc.alc931,'1','ANM')
#           IF g_errno<>' ' THEN NEXT FIELD alc931 END IF
          END IF
#No.FUN-560002-end
 
        AFTER FIELD alc76
            IF NOT cl_null(g_alc.alc76) THEN
               SELECT COUNT(*) INTO l_n FROM nna_file,nma_file
                WHERE nna01 = nma01
                  AND nna01 = g_alc.alc91
                  AND nna02 = g_alc.alc76
               IF l_n = 0 THEN
                  CALL cl_err('','anm-954',0) NEXT FIELD alc76
               END IF
            END IF
 
        AFTER FIELD alc932
            IF g_alc.alc932 IS NOT NULL THEN
               CALL s_chknot(g_alc.alc91,g_alc.alc932,g_alc.alc76)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD alc932
               END IF
            END IF
        AFTER FIELD alc94
          IF NOT cl_null(g_alc.alc94)  THEN
#           IF g_alc.alc94 = 0     THEN NEXT FIELD alc94 END IF
          IF g_alc.alc951 IS NULL OR g_alc.alc951 = 0 THEN    #No:8015
            IF g_alc.alc80='0'
               THEN LET g_alc.alc951=g_alc.alc34 * g_alc.alc94
               ELSE LET g_alc.alc951=0
            END IF
          END IF
          IF g_alc.alc952 IS NULL OR g_alc.alc952 = 0 THEN    #No:8015
          # SELECT alg06 INTO l_alg06 FROM alg_file WHERE alg01=g_ala.ala07
            SELECT nnp06 INTO l_nnp06 FROM nnp_file
             WHERE nnp01=g_ala.ala33 AND nnp03=g_ala.ala35
            LET g_alc.alc952 = g_alc.alc24 * l_nnp06/100 * g_alc.alc94
            IF g_alc.alc952 IS NULL THEN LET g_alc.alc952 = 0 END IF
          END IF
            DISPLAY BY NAME g_alc.alc951,g_alc.alc952
         END IF
        AFTER FIELD alc953
            LET g_alc.alc95 = g_alc.alc951+g_alc.alc952+g_alc.alc953
            DISPLAY BY NAME g_alc.alc95
 
        #FUN-850038     ---start---
        AFTER FIELD alcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD alcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850038     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            LET tot = g_alc.alc85 + g_alc.alc95
            DISPLAY BY NAME tot
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD alc01
            END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION controlp           #85-10-17
            CASE
               WHEN INFIELD(alc81) #外幣支付銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nma"
                  LET g_qryparam.default1 = g_alc.alc81
                  CALL cl_create_qry() RETURNING g_alc.alc81
                  DISPLAY BY NAME g_alc.alc81
                  NEXT FIELD alc81
               WHEN INFIELD(alc91) #本幣支付銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nma"
                  LET g_qryparam.default1 = g_alc.alc91
                  CALL cl_create_qry() RETURNING g_alc.alc91
                  DISPLAY BY NAME g_alc.alc91
                  NEXT FIELD alc91
               WHEN INFIELD(alc96) #銀行異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nmc"
                  LET g_qryparam.default1 = g_alc.alc96
                  CALL cl_create_qry() RETURNING g_alc.alc96
                  DISPLAY BY NAME g_alc.alc96
                  NEXT FIELD alc96
               WHEN INFIELD(alc931) #開票單別
                  LET g_t1=s_get_doc_no(g_alc.alc931)
                  LET g_sys='ANM'
                  #CALL q_nmy(FALSE,FALSE,g_t1,'1',g_sys) RETURNING g_t1  #TQC-670008
                  CALL q_nmy(FALSE,FALSE,g_t1,'1','AAP') RETURNING g_t1   #TQC-670008
                  LET g_alc.alc931=g_t1
                  DISPLAY BY NAME g_alc.alc931
                  NEXT FIELD alc931
                #FUN-4B0054
                WHEN INFIELD(alc84)
                   LET l_nma10=''
                   SELECT nma10 INTO l_nma10 FROM nma_file
                    WHERE nma01=g_alc.alc81
                   CALL s_rate(l_nma10,g_alc.alc84)
                   RETURNING g_alc.alc84
                   DISPLAY BY NAME g_alc.alc84
                   NEXT FIELD alc84
                #--
                #FUN-4B0054
                WHEN INFIELD(alc94)
                   LET l_nma10=''
                   SELECT nma10 INTO l_nma10 FROM nma_file
                    WHERE nma01=g_alc.alc91
                   CALL s_rate(l_nma10,g_alc.alc94)
                   RETURNING g_alc.alc94
                   DISPLAY BY NAME g_alc.alc94
                   NEXT FIELD alc94
                #--
               OTHERWISE
                  EXIT CASE
            END CASE
 
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
 
 
FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    #MOD-420449
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("alc01,alc02",TRUE)
   END IF
   #--END
 
   IF INFIELD(alc80) OR NOT g_before_input_done THEN
      CALL cl_set_comp_entry("alc81,alc83,alc84,alc85",TRUE)
   END IF
 
   IF INFIELD(alc92) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("alc931,alc76,alc932",TRUE)
   END IF
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   l_cnt   LIKE type_file.num5    #MOD-B30334
 
    # MOD-420449
   IF (p_cmd = 'u' AND g_chkey = 'N') AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("alc01",FALSE)
      CALL cl_set_comp_entry("alc02",FALSE)
   END IF
   #--END
 
   IF INFIELD(alc80) OR NOT g_before_input_done THEN
      IF g_alc.alc80 = '0' THEN
         CALL cl_set_comp_entry("alc81,alc83,alc84,alc85",FALSE)
      END IF
   END IF

  #-MOD-B30334-add-
   LET l_cnt = 0
   IF NOT cl_null(g_alc.alc931) THEN
      SELECT COUNT(*) INTO l_cnt 
        FROM nmd_file
       WHERE nmd01 = g_alc.alc931 AND nmd30 <> 'X'
   END IF
  #-MOD-B30334-end-

   IF INFIELD(alc92) OR (NOT g_before_input_done) THEN
     #IF g_alc.alc92 = '2' THEN               #MOD-B30334 mark
      IF g_alc.alc92 = '2' OR l_cnt > 0 THEN  #MOD-B30334
         CALL cl_set_comp_entry("alc931,alc76,alc932",FALSE)  
      END IF
   END IF
END FUNCTION
FUNCTION t741_alc96(p_cmd)
 DEFINE  p_cmd       LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
         l_nmc02     LIKE nmc_file.nmc02,
         l_nmcacti   LIKE nmc_file.nmcacti
 
    LET g_errno = ' '
    SELECT nmc02,nmcacti
      INTO l_nmc02,l_nmcacti FROM nmc_file
      WHERE nmc01 = g_alc.alc96
        AND nmc03 = '2'
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-024' LET l_nmc02 = ' '
         WHEN l_nmcacti  ='N'  LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY l_nmc02 TO FORMONLY.nmc02
    END IF
END FUNCTION
 
FUNCTION t741_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_alc.* TO NULL              #No.FUN-6A0016
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t741_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t741_count
    FETCH t741_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t741_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
        INITIALIZE g_alc.* TO NULL
    ELSE
        CALL t741_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t741_fetch(p_flalc)
    DEFINE
        p_flalc         LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
 
    CASE p_flalc
        WHEN 'N' FETCH NEXT     t741_cs INTO g_alc.alc01,g_alc.alc02
        WHEN 'P' FETCH PREVIOUS t741_cs INTO g_alc.alc01,g_alc.alc02
        WHEN 'F' FETCH FIRST    t741_cs INTO g_alc.alc01,g_alc.alc02
        WHEN 'L' FETCH LAST     t741_cs INTO g_alc.alc01,g_alc.alc02
        WHEN '/'
            IF NOT g_no_ask THEN
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
            FETCH ABSOLUTE g_jump t741_cs
                           INTO g_alc.alc01,g_alc.alc02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
        INITIALIZE g_alc.* TO NULL            #No.FUN-6A0016
        RETURN
    ELSE
       CASE p_flalc
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
     #No.FUN-730064 --begin--
     CALL s_get_bookno(YEAR(g_alc.alc79))   RETURNING g_flag,g_bookno1,g_bookno2     #No.TQC-740042
     IF g_flag='1' THEN # 抓不到帳別
         CALL cl_err(g_alc.alc79,'aoo-081',1)
     END IF
    #No.FUN-730064 --end--
    SELECT * INTO g_alc.* FROM alc_file            # 重讀DB,因TEMP有不被更新特性
       WHERE alc01 = g_alc.alc01 AND alc02 = g_alc.alc02
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("sel","alc_file",g_alc.alc01,g_alc.alc02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
        INITIALIZE g_alc.* TO NULL            #NO.FUN-6A0016
    ELSE
        CALL t741_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t741_show()
    LET g_alc_t.* = g_alc.*
    LET tot = g_alc.alc85 + g_alc.alc95
    SELECT * INTO g_ala.* FROM ala_file WHERE ala01=g_alc.alc01
    DISPLAY BY NAME
#        g_ala.alaplant,g_alc.alc01,g_ala.ala04,g_ala.ala930,g_alc.alc02,g_alc.alc08,g_alc.alc79,   #FUN-680019  #No.FUN-980017
         g_ala.ala97,g_alc.alc01,g_ala.ala04,g_ala.ala930,g_alc.alc02,g_alc.alc08,g_alc.alc79,   #FUN-680019  #No.FUN-980017
        g_alc.alc96,g_ala.ala20,g_alc.alc51,g_ala.ala21,
        g_alc.alc24,g_alc.alc34,g_alc.alc80,g_alc.alc74,
        g_alc.alc81,g_alc.alc82,g_alc.alc83,g_alc.alc84,g_alc.alc85,
        g_alc.alc91,g_alc.alc92,g_alc.alc931,
        g_alc.alc76,g_alc.alc932,g_alc.alc93,
        g_alc.alc94,g_alc.alc951,g_alc.alc952,g_alc.alc953,g_alc.alc95,
        g_alc.alcfirm, g_alc.alc78, tot
        #FUN-850038     ---start---
        ,g_alc.alcud01,g_alc.alcud02,g_alc.alcud03,g_alc.alcud04,
        g_alc.alcud05,g_alc.alcud06,g_alc.alcud07,g_alc.alcud08,
        g_alc.alcud09,g_alc.alcud10,g_alc.alcud11,g_alc.alcud12,
        g_alc.alcud13,g_alc.alcud14,g_alc.alcud15 
        #FUN-850038     ----end----
    CALL t741_alc96('d')
    DISPLAY s_costcenter_desc(g_ala.ala04) TO FORMONLY.gem02   #FUN-680019
    DISPLAY s_costcenter_desc(g_ala.ala930) TO FORMONLY.gem02b #FUN-680019
    CALL cl_set_field_pic(g_alc.alc78,"","","","","")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t741_u()
    IF g_alc.alc01 IS NULL THEN CALL cl_err('',-400,0)  RETURN END IF
    SELECT * INTO g_alc.* FROM alc_file
     WHERE alc01=g_alc.alc01
       AND alc02=g_alc.alc02
       AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
    IF g_alc.alcfirm='N' THEN CALL cl_err('','aap-717',0)  RETURN END IF
    IF g_alc.alc78='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_alc01_t = g_alc.alc01
    LET g_alc02_t = g_alc.alc02   #MOD-780066
    BEGIN WORK
    OPEN t741_cl USING g_alc.alc01,g_alc.alc02
    FETCH t741_cl INTO g_alc.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    CALL t741_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t741_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_alc.*=g_alc_t.*
            CALL t741_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE alc_file SET alc_file.* = g_alc.*    # 更新DB
            WHERE alc01 = g_alc01_t AND alc02 = g_alc02_t            # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","alc_file",g_alc01_t,g_alc02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t741_cl
    COMMIT WORK
END FUNCTION
 
#No.+081 010425 by plum
FUNCTION t741_npp02()
 
  IF cl_null(g_alc.alc74) THEN
      UPDATE npp_file SET npp02=g_alc.alc79   #MOD-4C0040 異動日期改以付款日期為基準
      WHERE npp01=g_alc.alc01 AND npp011=g_alc.alc02
        AND npp00 = 7         AND nppsys = 'LC'
     IF STATUS THEN 
#    CALL cl_err('upd npp02:',STATUS,1) #No.FUN-660122
     CALL cl_err3("upd","npp_file",g_alc.alc01,g_alc.alc02,STATUS,"","upd npp02:",1)  #No.FUN-660122
     END IF
  END IF
 
END FUNCTION
#No.+081 ..end
 
FUNCTION t741_y()
   IF g_alc.alc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_alc.* FROM alc_file
     WHERE alc01=g_alc.alc01
       AND alc02=g_alc.alc02
       AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
       AND alcfirm <> 'X'  #CHI-C80041
   IF g_alc.alcfirm='N' THEN            #85-10-17
      CALL cl_err(g_alc.alc01,'aap-234',0)
      RETURN
   END IF
   IF g_alc.alc78='Y' THEN
      CALL cl_err(g_alc.alc01,'aap-232',0)
      RETURN
   END IF
   IF g_alc.alc91 IS NULL THEN
      CALL cl_err(g_alc.alc01,'aap-233',0)
      RETURN
   END IF
   IF g_alc.alc95 IS NULL OR g_alc.alc95=0 THEN
      CALL cl_err(g_alc.alc01,'aap-235',0)
      RETURN
   END IF
   IF g_alc.alc92='1' AND g_alc.alc931 IS NULL THEN
      CALL cl_err(g_alc.alc01,'aap-236',0)
      RETURN
   END IF
   #IF g_alc.alc92='1' AND g_alc.alc932 IS NULL THEN
   #   CALL cl_err(g_alc.alc01,'aap-237',0)
   #   RETURN
   #END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   INITIALIZE g_nme.* TO NULL
   INITIALIZE g_nmd.* TO NULL
   BEGIN WORK LET g_success='Y'
   OPEN t741_cl USING g_alc.alc01,g_alc.alc02
   FETCH t741_cl INTO g_alc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   CALL s_chknpq1(g_alc.alc01,g_alc.alc02,7,'0',g_bookno1)  #No.FUN-680029 add '0'      #No.FUN-730064 add g_bookno1
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL s_chknpq1(g_alc.alc01,g_alc.alc02,7,'1',g_bookno2)    #No.FUN-730064 add g_bookno1
   END IF
   #No.FUN-680029 --end--
  #CALL s_chknpq(g_alc.alc01,'AP',g_alc.alc02)  #-->NO:0151
   IF g_success = 'N' THEN ROLLBACK WORK RETURN  END IF
   ##--00/03/03 modify
   IF g_alc.alc92 = '1' THEN    #支存應先產生應付票據才可confirm
      IF g_alc.alc931 <> ' ' AND g_alc.alc931 IS NOT NULL THEN
         SELECT COUNT(*) INTO g_cnt FROM nmd_file
         WHERE nmd01 = g_alc.alc931 AND nmd30 <> 'X'
         IF g_cnt = 0 THEN CALL cl_err(g_alc.alc01,'anm-655',0) ROLLBACK WORK
            RETURN
         END IF
      ELSE
         CALL cl_err(g_alc.alc01,'anm-655',0) ROLLBACK WORK RETURN
      END IF
   END IF
   ##-----------------
   IF g_alc.alc80='1' AND g_alc.alc82 MATCHES "[2]" THEN
      CALL t741_y_nme(g_alc.alc81,g_alc.alc84,g_alc.alc34,g_alc.alc85)
                RETURNING g_alc.alc83 DISPLAY BY NAME g_alc.alc83
   END IF
   #-----MOD-690058---------
   #IF g_alc.alc92='1'
   #   THEN LET g_nme.nme12=g_alc.alc931 LET g_nme.nme17=g_alc.alc932
   #   ELSE LET g_nme.nme12=''           LET g_nme.nme17=''  
   #END IF
   IF g_alc.alc92 ='2' THEN
      LET g_nme.nme12 = g_alc.alc01
      LET g_nme.nme17=''
   ELSE                     #No.FUN-9C0012 
      LET g_nme.nme12=''    #No.FUN-9C0012
   END IF
   #-----END MOD-690058-----
   IF g_alc.alc92 MATCHES "[2]" THEN
      CALL t741_y_nme(g_alc.alc91,1,g_alc.alc95,g_alc.alc95)
                RETURNING g_alc.alc93 DISPLAY BY NAME g_alc.alc93
   END IF
   LET g_alc.alc60=g_alc.alc85+g_alc.alc95+g_alc.alc56
   UPDATE alc_file SET alc78 = 'Y', alc83=g_alc.alc83, alc93=g_alc.alc93,
                                    alc60=g_alc.alc60, alc931=g_alc.alc931
          WHERE alc01=g_alc.alc01 AND alc02=g_alc.alc02
   IF STATUS THEN
#     CALL cl_err('',STATUS,0)   #No.FUN-660122
      CALL cl_err3("upd","alc_file",g_alc.alc01,g_alc.alc02,STATUS,"","",1)  #No.FUN-660122
      LET g_success='N'
   END IF
   CALL t741_hu_ala()
   IF g_success='Y'
      THEN COMMIT WORK LET g_alc.alc78 ='Y' DISPLAY BY NAME g_alc.alc78
      ELSE ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t741_hu_ala()
   DEFINE amt1,amt2   LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   SELECT SUM(alc60) INTO amt2 FROM alc_file
          WHERE alc01=g_alc.alc01 AND alc78='Y' AND
                alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
                AND alcfirm <> 'X'  #CHI-C80041
   IF amt2 IS NULL THEN LET amt2=0 END IF
   UPDATE ala_file SET ala60=amt2 WHERE ala01=g_alc.alc01
   IF STATUS THEN
#     CALL cl_err('upd alc60:',STATUS,0)   #No.FUN-660122
      CALL cl_err3("upd","ala_file",g_alc.alc01,"",STATUS,"","upd alc60:",1)  #No.FUN-660122
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t741_y_nme(p_bank,p_ex,p_amt1,p_amt2)
    DEFINE p_bank 	LIKE nme_file.nme01  #MOD-4B0022
    DEFINE p_ex   	LIKE nme_file.nme07  #No.MOD-4B0022
   DEFINE p_amt1,p_amt2	LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_nme021      LIKE type_file.chr8        # No.FUN-690028 VARCHAR(8)
   DEFINE l_serial	LIKE type_file.chr20       # No.FUN-690028 VARCHAR(10)
   DEFINE l_sql         STRING   #MOD-690058

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   IF p_amt2 IS NULL OR p_amt2 = 0 THEN RETURN 0 END IF
   #-----MOD-690058---------
   #LET g_nme.nme00=0
  #LET l_sql = "SELECT MAX(nme00)+1 FROM ",g_dbs_nm,"nme_file"   #FUN-A50102
   LET l_sql = "SELECT MAX(nme00)+1 FROM ",cl_get_target_table(g_plant_new,'nme_file')   #FUN-A50102 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
   PREPARE n1 FROM l_sql
   EXECUTE n1 INTO g_nme.nme00
   IF g_nme.nme00 IS NULL THEN LET g_nme.nme00=1 END IF
   #-----END MOD-690058-----
   LET g_nme.nme01=p_bank
   LET g_nme.nme02=g_alc.alc08
   LET g_nme.nme16=g_alc.alc08
   LET l_nme021=TIME
   LET g_nme.nme021=l_nme021
   LET g_nme.nme03=g_alc.alc96
   LET g_nme.nme04=p_amt1
   LET g_nme.nme05='L/C No.:',g_alc.alc01
   LET g_nme.nme07=p_ex
   LET g_nme.nme08=p_amt2
   LET g_nme.nme12=g_alc.alc01    #MOD-B30334
   SELECT alg01,alg02 INTO g_nme.nme25,g_nme.nme13 FROM alg_file WHERE alg01=g_ala.ala07      #No.FUN-730032
   LET g_nme.nme15=g_ala.ala04
   LET g_nme.nmeacti='Y'                  #85-10-17
   LET g_nme.nmeuser=g_user
   LET g_nme.nmeoriu = g_user #FUN-980030
   LET g_nme.nmeorig = g_grup #FUN-980030
   LET g_nme.nmegrup=g_alc.alcgrup
#No.FUN-730032--begin
   LET g_nme.nme21='1'
   LET g_nme.nme22='11'
   LET g_nme.nme24='9'
#No.FUN-730032--end

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO g_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(g_nme.nme27) THEN
      LET g_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

   LET g_nme.nmelegal = g_legal #FUN-980001
   INSERT INTO nme_file(nme00,nme01,nme02,nme021,nme03,
                        nme04,nme05,nme06,nme07,nme08,
                        nme09,nme10,nme11,nme12,nme13,
                        nme14,nme15,nme16,nme17,nme18,
                        nme19,nme20,nmeacti,nmeuser,nmegrup,
                        nmemodu,nmedate,nme061,nme21,nme22,
                        nme23,nme24,nme25,nmeud01,nmeud02,
                        nmeud03,nmeud04,nmeud05,nmeud06,nmeud07,
                        nmeud08,nmeud09,nmeud10,nmeud11,nmeud12,
                        nmeud13,nmeud14,nmeud15,nme26,nme27,nmelegal,nmeoriu,nmeorig)  #FUN-9A0099   #FUN-B30166 add nme27
           VALUES(g_nme.nme00,g_nme.nme01,g_nme.nme02,g_nme.nme021,g_nme.nme03,
                  g_nme.nme04,g_nme.nme05,g_nme.nme06,g_nme.nme07,g_nme.nme08,
                  g_nme.nme09,g_nme.nme10,g_nme.nme11,g_nme.nme12,g_nme.nme13,
                  g_nme.nme14,g_nme.nme15,g_nme.nme16,g_nme.nme17,g_nme.nme18,
                  g_nme.nme19,g_nme.nme20,g_nme.nmeacti,g_nme.nmeuser,g_nme.nmegrup,
                  g_nme.nmemodu,g_nme.nmedate,g_nme.nme061,g_nme.nme21,g_nme.nme22,
                  g_nme.nme23,g_nme.nme24,g_nme.nme25,g_nme.nmeud01,g_nme.nmeud02,
                  g_nme.nmeud03,g_nme.nmeud04,g_nme.nmeud05,g_nme.nmeud06,g_nme.nmeud07,
                  g_nme.nmeud08,g_nme.nmeud09,g_nme.nmeud10,g_nme.nmeud11,g_nme.nmeud12,
                  g_nme.nmeud13,g_nme.nmeud14,g_nme.nmeud15,g_nme.nme26,g_nme.nme27,g_nme.nmelegal, g_user, g_grup)	# 注意多工廠環境 #FUN-9A0099      #No.FUN-980030 10/01/04  insert columns oriu, orig  #FUN-B30166 add g_nme.nme27
   IF STATUS THEN
#     CALL cl_err('ins nme:',STATUS,1)    #No.FUN-660122
      CALL cl_err3("ins","nme_file",g_nme.nme00,g_nme.nme01,STATUS,"","ins nme",1)  #No.FUN-660122
      LET g_success='N' RETURN l_serial
   END IF
   LET l_serial=SQLCA.SQLERRD[2]
   CALL s_flows_nme(g_nme.*,'1',g_plant)   #No.FUN-B90062 
   #RETURN l_serial   #MOD-690058
   RETURN g_nme.nme00   #MOD-690058
END FUNCTION
 
FUNCTION t741_g_nmd(p_bank,p_ex,p_amt1,p_amt2)
    DEFINE p_bank 	LIKE nme_file.nme01  #MOD-4B0022
    DEFINE p_ex   	LIKE nme_file.nme07  #No.MOD-4B0022
   DEFINE p_amt1,p_amt2 LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_serial	LIKE type_file.chr20       # No.FUN-690028 VARCHAR(10)
   DEFINE l_n		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE li_result   LIKE type_file.num5      #No.FUN-560002  #No.FUN-690028 SMALLINT
 
   BEGIN WORK
   OPEN t741_cl USING g_alc.alc01,g_alc.alc02
   FETCH t741_cl INTO g_alc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM nmd_file
    WHERE nmd01=g_alc.alc931 AND nmd30 <> 'X'
   IF l_n>0 THEN
      CALL cl_err('','aap-741',1)
      ROLLBACK WORK RETURN
   END IF
#No.FUN-560002-begin
      CALL s_auto_assign_no("anm",g_alc.alc931,g_alc.alc08,"1","","","","","")
           RETURNING li_result,g_alc.alc931
      IF (NOT li_result) THEN
         ROLLBACK WORK
         RETURN
      END IF
#  CALL s_nmyauno(g_alc.alc931,g_alc.alc08,'1') RETURNING g_i,g_alc.alc931
#  IF g_i THEN ROLLBACK WORK RETURN END IF
#No.FUN-560002-end
   DISPLAY BY NAME g_alc.alc931
   UPDATE alc_file SET alc931=g_alc.alc931 WHERE alc01 = g_alc.alc01 AND alc02 = g_alc.alc02
   IF STATUS THEN 
#  CALL cl_err('upd alc931:',STATUS,1) #No.FUN-660122
      CALL cl_err3("upd","alc_file",g_alc.alc01,g_alc.alc02,STATUS,"","upd alc931:",1)  #No.FUN-660122
   ROLLBACK WORK RETURN END IF
 
   LET g_nmd.nmd01=g_alc.alc931
   LET g_nmd.nmd02=g_alc.alc932
   LET g_nmd.nmd03=p_bank
   LET g_nmd.nmd04=p_amt1
   LET g_nmd.nmd26=p_amt2
   LET g_nmd.nmd05=g_alc.alc08
   LET g_nmd.nmd07=g_alc.alc08
   LET g_nmd.nmd08=g_ala.ala07
   SELECT alg02 INTO g_nmd.nmd24 FROM alg_file WHERE alg01=g_ala.ala07
   SELECT pmc081 INTO g_nmd.nmd09 FROM pmc_file WHERE pmc01=g_ala.ala07
   LET g_nmd.nmd11=g_alc.alc01
  #LET g_nmd.nmd12='8'
   LET g_nmd.nmd12='1'
   LET g_nmd.nmd13=g_alc.alc08
   LET g_nmd.nmd15=g_alc.alc08
   LET g_nmd.nmd18=g_ala.ala04
   LET g_nmd.nmd19=p_ex
   LET g_nmd.nmd21=g_aza.aza17
   LET g_nmd.nmd28=g_alc.alc08
   LET g_nmd.nmd29=g_alc.alc08
   LET g_nmd.nmd30='N'
   LET g_nmd.nmd31=g_alc.alc76
   LET g_nmd.nmd33 = g_nmd.nmd19                #bug no:A049
   LET g_nmd.nmduser=g_user
   LET g_nmd.nmdgrup=g_alc.alcgrup              #85-10-17
   LET g_nmd.nmdlegal = g_legal #FUN-980001
   LET g_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
   LET g_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO nmd_file VALUES(g_nmd.*)		# 注意多工廠環境
   IF STATUS THEN
#     CALL cl_err('ins nmd:',STATUS,1)   #No.FUN-660122
      CALL cl_err3("ins","nmd_file",g_nmd.nmd01,"",STATUS,"","ins nmd:",1)  #No.FUN-660122
      LET g_success='N' ROLLBACK WORK RETURN
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION t741_z()
   IF g_alc.alc01 IS NULL THEN RETURN END IF
    SELECT * INTO g_alc.* FROM alc_file
     WHERE alc01=g_alc.alc01
       AND alc02=g_alc.alc02
       AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
       AND alcfirm <> 'X'  #CHI-C80041
   IF g_alc.alc78='N' THEN RETURN END IF
#  IF NOT cl_null(g_alc.alc74) THEN RETURN END IF  #No.FUN-670060 mark
 
   #No.FUN-670060 --begin--
   IF NOT cl_null(g_alc.alc74) THEN
      CALL cl_err(g_alc.alc01,'axr-370',0) RETURN
   END IF
   #No.FUN-670060 --end--
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK LET g_success='Y'
   OPEN t741_cl USING g_alc.alc01,g_alc.alc02
   FETCH t741_cl INTO g_alc.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_alc.alc01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   IF g_alc.alc80='1' AND g_alc.alc82 MATCHES "[2]" THEN
      IF g_alc.alc83 IS NOT NULL THEN CALL t741_z_nme(g_alc.alc83) END IF
      LET g_alc.alc83=NULL
   END IF
#  IF g_alc.alc92='1' THEN
#     CALL t741_z_nmd(g_alc.alc931)
#     CALL t741_z_nme(g_alc.alc93)
#     LET g_alc.alc93=NULL
#  END IF
   IF g_alc.alc92='2' THEN
      CALL t741_z_nme(g_alc.alc93)
      LET g_alc.alc93=NULL
   END IF
   UPDATE alc_file SET alc78 = 'N',alc83=g_alc.alc83,alc93=g_alc.alc93
       WHERE alc01=g_alc.alc01 AND alc02=g_alc.alc02
   IF STATUS THEN
      LET g_success='N'
#     CALL cl_err('upd alc:',STATUS,0)   #No.FUN-660122
      CALL cl_err3("upd","alc_file",g_alc.alc01,g_alc.alc02,STATUS,"","upd alc:",1)  #No.FUN-660122
   END IF
   IF g_success='Y' THEN
       LET g_alc.alc78='N'
       DISPLAY BY NAME g_alc.alc78,g_alc.alc83,g_alc.alc93
       COMMIT WORK
   ELSE
       ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t741_z_nme(p_no)
   #DEFINE p_no   VARCHAR(16)	# 開票單號/收支單號 #FUN-660117 remark
   DEFINE p_no   LIKE nmd_file.nmd01	            #FUN-660117 
   DEFINE l_nme24      LIKE nme_file.nme24    #No.FUN-730032
   DEFINE l_aza73      LIKE aza_file.aza73    #No.MOD-740346
 
   #No.MOD-740346 --start--
  #LET g_sql="SELECT aza73 FROM ",g_dbs_nm CLIPPED,"aza_file"   #FUN-A50102
   LET g_sql="SELECT aza73 FROM ",cl_get_target_table(g_plant_new,'aza_file')  #FUN-A50102 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE t741_aza_p FROM g_sql
   DECLARE t741_aza_c CURSOR FOR t741_aza_p
   OPEN t741_aza_c
   FETCH t741_aza_c INTO l_aza73
   IF l_aza73 = 'Y' THEN
   #No.MOD-740346 --end--
#No.FUN-730032--begin
     #LET g_sql="SELECT nme24 FROM ",g_dbs_nm CLIPPED,"nme_file",  #FUN-A50102
      LET g_sql="SELECT nme24 FROM ",cl_get_target_table(g_plant_new,'nme_file'),  #FUN-A50102
                " WHERE nme00=",p_no  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t741_z_nme_p1 FROM g_sql
      FOREACH t741_z_nme_p1 INTO l_nme24
         IF l_nme24 <> '9' THEN
            CALL cl_err('','anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
#No.FUN-730032--end
   END IF #No.MOD-740346
   MESSAGE "del nme:",p_no
   IF p_no IS NULL OR p_no = 0 THEN RETURN END IF
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
   #FUN-B40056  --begin
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),
             " WHERE tic04 in (",
            " SELECT nme12 FROM ",cl_get_target_table(g_plant_new,'nme_file'),
             " WHERE nme00=",p_no," )"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE t741_z_tic_p FROM g_sql
   EXECUTE t741_z_tic_p
   IF STATUS THEN
      CALL cl_err('del tic:',STATUS,1) LET g_success='N' RETURN
   END IF
   #FUN-B40056  --end 
   END IF                 #No.TQC-B70021
  #LET g_sql="DELETE FROM ",g_dbs_nm,"nme_file",  #FUN-A50102
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'nme_file'),  #FUN-A50102
             " WHERE nme00=",p_no
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE t741_z_nme_p FROM g_sql
   EXECUTE t741_z_nme_p
   IF STATUS THEN
      CALL cl_err('del nme:',STATUS,1) LET g_success='N' RETURN
   END IF
    IF STATUS             THEN        #No.MOD-4B0022
      CALL cl_err('no nme deleted:',SQLCA.SQLCODE,1) LET g_success='N' RETURN
   END IF
   
END FUNCTION
 
FUNCTION t741_z_nmd(p_no)
   DEFINE p_no       LIKE nmd_file.nmd01      # No.FUN-690028 VARCHAR(16)    #No.FUN-560002
   MESSAGE "del nmd:",p_no
  #LET g_sql="DELETE FROM ",g_dbs_nm,"nmd_file",   #FUN-A50102
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'nmd_file'),  #FUN-A50102
             " WHERE nmd01='",p_no,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE t741_z_nmd_p FROM g_sql
   EXECUTE t741_z_nmd_p
   IF STATUS THEN
      CALL cl_err('del nmd:',STATUS,1) LET g_success='N' RETURN
   END IF
    IF STATUS             THEN           #No.MOD-4B0022
      CALL cl_err('no nmd deleted:',SQLCA.SQLCODE,1) LET g_success='N' RETURN
   END IF
END FUNCTION
 
FUNCTION t741_g_gl(p_apno,p_sw1,p_sw2)
   DEFINE p_apno	LIKE alc_file.alc01
   DEFINE p_sw1		LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 5
   DEFINE p_sw2		LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 0.初開狀   1/2/3.修改
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_alc74       LIKE alc_file.alc74
 
   LET g_success = 'Y'  #No.FUN-680029
   IF p_apno IS NULL THEN RETURN END IF
   SELECT alc74 INTO l_alc74 FROM alc_file
    WHERE alc01=p_apno
      AND alc02=p_sw2
      AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
      AND alcfirm <> 'X'  #CHI-C80041
   IF NOT cl_null(l_alc74) THEN RETURN END IF
   BEGIN WORK  #No.FUN-680029
   SELECT COUNT(*) INTO l_n FROM npp_file
          WHERE npp01 = p_apno AND npp00 = p_sw1 AND npp011 = p_sw2
            AND nppsys= 'LC'
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_apno) THEN RETURN END IF  #Genero

      #FUN-B40056--add--str--
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM tic_file
       WHERE tic04 = p_apno
      IF l_n > 0 THEN
         IF NOT cl_confirm('sub-533') THEN
            RETURN
         END IF
      END IF
      DELETE FROM tic_file WHERE tic04 = p_apno
      IF STATUS THEN
         CALL cl_err3("del","tic_file",p_apno,p_sw2,STATUS,"","del tic:",1)
         ROLLBACK WORK 
         RETURN
      END IF
      #FUN-B40056--add--end--

      DELETE FROM npp_file WHERE npp01 = p_apno
                             AND npp011= p_sw2
                             AND nppsys='LC'
                             AND npp00 = p_sw1
      IF STATUS THEN 
#     CALL cl_err('del npp:',STATUS,0) #No.FUN-660122
      CALL cl_err3("del","npp_file",p_apno,p_sw2,STATUS,"","del npp:",1)  #No.FUN-660122
      ROLLBACK WORK  #No.FUN-680029
      RETURN END IF
      DELETE FROM npq_file WHERE npq01 = p_apno
                             AND npq011= p_sw2
                             AND npqsys='LC'
                             AND npq00 = p_sw1
      IF STATUS THEN 
#     CALL cl_err('del npq:',STATUS,0) #No.FUN-660122
      CALL cl_err3("del","npq_file",p_apno,p_sw2,STATUS,"","del npq:",1)  #No.FUN-660122
      ROLLBACK WORK  #No.FUN-680029
      RETURN END IF
   END IF
   CALL t741_g_gl_2(p_apno,p_sw1,p_sw2,'0')    #付款傳票  #No.FUN-680029
   #No.FUN-680029 --start--
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL t741_g_gl_2(p_apno,p_sw1,p_sw2,'1')
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   #No.FUN-680029 --end--
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t741_g_gl_2(p_apno,p_sw1,p_sw2,p_npptype)  #No.FUN-680029 add p_npptype
   DEFINE p_sw1         LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 1.會計傳票 2.會計付款 2.出納付款
   DEFINE p_sw2         LIKE type_file.num5        # No.FUN-690028 SMALLINT	# 0.初開狀   1/2/3.修改
   DEFINE p_apno	LIKE alc_file.alc01
   DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_dept	LIKE ala_file.ala04
   DEFINE l_alc		RECORD LIKE alc_file.*
   #DEFINE l_pmc03 VARCHAR(10)             #FUN-660117 remark 
   DEFINE l_pmc03	LIKE pmc_file.pmc03  #FUN-660117
   DEFINE l_msg     	LIKE ze_file.ze03      # No.FUN-690028 VARCHAR(30)
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_aps		RECORD LIKE aps_file.*
   DEFINE l_mesg	LIKE ze_file.ze03      # No.FUN-690028 VARCHAR(30)
   DEFINE l_diff 	LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aaa03       LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   LET g_bookno3 = Null   #No.FUN-D40118   Add
 
   SELECT * INTO l_alc.* FROM alc_file WHERE alc01 = p_apno AND alc02 = p_sw2
                                         AND alc02 <> 0   #MOD-640018 #CHI-AA0015 mod '0'->0
                                         AND alcfirm <> 'X'  #CHI-C80041
   IF STATUS THEN
      LET g_success = 'N'  #No.FUN-680029
      RETURN
   END IF
   IF g_apz.apz13 = 'Y'
      THEN LET l_dept = g_ala.ala04
      ELSE LET l_dept = ' '
   END IF
   SELECT * INTO l_aps.* FROM aps_file WHERE aps01 = l_dept
   IF STATUS THEN INITIALIZE l_aps.* TO NULL END IF
   IF p_npptype = '0' THEN  #No.FUN-680029
      IF l_aps.aps231 IS NULL THEN LET l_aps.aps231 = g_ala.ala42 END IF
   #No.FUN-680029 --start--
   ELSE
      IF l_aps.aps236 IS NULL THEN LET l_aps.aps236 = g_ala.ala421 END IF
   END IF
   #No.FUN-680029 --end--
   CALL cl_getmsg('aap-111',g_lang) RETURNING l_mesg 	#預估保險費
   # 首先, Insert 一筆單頭
   INITIALIZE l_npp.* TO NULL
   LET l_npp.nppsys = 'LC'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_alc.alc01      #單號
   LET l_npp.npp011 = p_sw2            #異動序號
  #No.+081 010425 by plum
    LET l_npp.npp02  = l_alc.alc79      #MOD-4C0040 異動日期改以付款日期為基準
  #No.+081 ..end
   LET l_npp.npptype = p_npptype  #No.FUN-680029
   LET l_npp.npplegal = g_legal #FUN-980001
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS THEN 
#  CALL cl_err('ins npp#1',STATUS,1) #No.FUN-660122
   CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,STATUS,"","ins npp#1",1)  #No.FUN-660122
   LET g_success = 'N'  #No.FUN-680029
   END IF
 
   # 然後, Insert 其單身
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqsys = 'LC'             #系統別
   LET l_npq.npq01 = l_alc.alc01
   LET l_npq.npq00 = p_sw1
   LET l_npq.npq011= p_sw2
   LET l_npq.npq02 = 0
   LET l_npq.npq07  = 0                #本幣金額
   LET l_npq.npq24  = g_ala.ala20      #幣別
   LET l_npq.npq25  = l_alc.alc51      #匯率
   LET g_npq25      = l_npq.npq25      #No.FUN-9A0036
   LET l_npq.npqtype = p_npptype       #No.FUN-680029

  #No.FUN-D40118 ---Add--- Start
   IF l_npq.npqtype = '1' THEN
      LET g_bookno3 = g_bookno2
   ELSE
      LET g_bookno3 = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End
 
   #-->廠商簡稱
   SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=g_ala.ala05
   IF SQLCA.sqlcode THEN LET l_pmc03 = ' ' END IF
#--->借方科目 (應付帳款)
   LET l_npq.npq07f = l_alc.alc34
   LET l_npq.npq07  =
         (l_alc.alc52+l_alc.alc53+l_alc.alc54+l_alc.alc55+l_alc.alc57)
   IF l_npq.npq07 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         IF l_alc.alc73 IS NULL
            THEN LET l_npq.npq03 = g_ala.ala42     #應付科目
            ELSE LET l_npq.npq03 = l_alc.alc43     #銀存過渡科目
         END IF
      #No.FUN-680029 --start--
      ELSE
         IF l_alc.alc73 IS NULL
            THEN LET l_npq.npq03 = g_ala.ala421
            ELSE LET l_npq.npq03 = l_alc.alc431
         END IF
      END IF
      #No.FUN-680029 --end--
      #FUN-D10065--mark--str--
      #LET l_npq.npq04 = g_ala.ala01 CLIPPED,' ',{l_alc.alc02,' ',}     # L/C NO
      #                  g_ala.ala20 CLIPPED,' ',       # CURR
      #                 # l_alc.alc24 USING '<<<<<<<<<<'        # Amt
      #                  g_ala.ala34 USING '<<<<<<<<<<'
      #FUN-D10065--mark--end--
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
        AND  aag00 = g_bookno1            #No.FUN-730064 
      IF l_aag05 = 'Y' THEN
         #LET l_npq.npq05 = g_ala.ala04     #部門 #FUN-680019
         LET l_npq.npq05 = t741_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '1'             #D/C
      LET l_npq.npq21 = g_ala.ala05     #廠商編號
      LET l_npq.npq22 = l_pmc03         #廠商簡稱
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)    #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = g_ala.ala01 CLIPPED,' ',{l_alc.alc02,' ',}      # L/C NO
                           g_ala.ala20 CLIPPED,' ',        # CURR
                           g_ala.ala34 USING '<<<<<<<<<<'
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal #FUN-980001
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq-1',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq-1",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
   END IF
#--->借方科目 (差異)
   LET l_diff = (l_alc.alc85+l_alc.alc95) -
                (l_alc.alc52+l_alc.alc53+l_alc.alc54+l_alc.alc55+l_alc.alc57)
   IF l_diff != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF p_npptype = '0' THEN  #No.FUN-680029
         LET l_npq.npq03 = g_ala.ala41
      #No.FUN-680029 --start--
      ELSE
         LET l_npq.npq03 = g_ala.ala411
      END IF
      #No.FUN-680029 --end--
      CALL cl_getmsg('aap-745',g_lang) RETURNING l_msg
      #LET l_npq.npq04 = l_msg   #FUN-D10065  mark
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = g_bookno1    #No.FUN-730064 
      IF l_aag05 = 'Y' THEN
         #LET l_npq.npq05 = g_ala.ala04     #部門 #FUN-680019
         LET l_npq.npq05 = t741_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq06 = '1'
      LET l_npq.npq07f = 0
      IF l_npq.npq07f < 0 THEN
         LET l_npq.npq06 = '2' LET l_npq.npq07f = l_npq.npq07f * -1
      END IF
      LET l_npq.npq21 = g_ala.ala05     #廠商
      LET l_npq.npq22 = l_pmc03         #廠商
      LET l_npq.npq07 = l_diff
      LET l_npq.npq24 = g_aza.aza17     #MOD-B30334
      LET l_npq.npq25 = 1               #MOD-B30334
      LET g_npq25 = l_npq.npq25         #MOD-B30334 
      LET l_npq.npq04 = NULL #FUN-D10065 add
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)    #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = l_msg
      END IF
      #FUN-D10065--add--end--

      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal #FUN-980001
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = '' 
         END IF 
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq-2',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq-2",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
   END IF
#--->貸方科目(銀行存款-原幣保證金)
   IF l_alc.alc85 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF g_apz.apz52 = '1' AND l_alc.alc82='1' THEN
         IF p_npptype = '0' THEN  #No.FUN-680029
            LET l_npq.npq03 = l_aps.aps24	# 貸: 應付票據
         #No.FUN-680029 --start--
         ELSE
            LET l_npq.npq03 = l_aps.aps241
         END IF
         #No.FUN-680029 --end--
      ELSE
         LET l_npq.npq03 = 'bankacct'	# 貸: 銀行存款
         IF p_npptype = '0' THEN  #No.FUN-680029
            SELECT nma05 INTO l_npq.npq03
              FROM nma_file WHERE nma01=l_alc.alc81
         #No.FUN-680029 --start--
         ELSE
            SELECT nma051 INTO l_npq.npq03
              FROM nma_file WHERE nma01=l_alc.alc81
         END IF
         #No.FUN-680029 --end--
      END IF
      CALL cl_getmsg('aap-747',g_lang) RETURNING l_msg
      #FUN-D10065--mark--str--
      #LET l_npq.npq04 = g_ala.ala01 CLIPPED,' ',{l_alc.alc02,' ',}
      #                  l_msg
      #FUN-D10065--mark--end--
     #FUN-680019...............begin
     #LET l_npq.npq05 = ''
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
        AND  aag00 = g_bookno1      #No.FUN-730064 
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t741_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
     #FUN-680019...............end
      LET l_npq.npq06 = '2'
      LET l_npq.npq07f = l_alc.alc34
      LET l_npq.npq21 = ''
      LET l_npq.npq22 = ''
      LET l_npq.npq07 = l_alc.alc85
      LET l_npq.npq24  = g_ala.ala20      #幣別 #MOD-B30334
      LET l_npq.npq25  = l_alc.alc84            #MOD-B30334
      LET l_npq.npq04 = NULL #FUN-D10065 add
      LET g_npq25 = l_npq.npq25                 #MOD-B30334
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)    #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = g_ala.ala01 CLIPPED,' ',{l_alc.alc02,' ',}
                           l_msg
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal #FUN-980001
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = '' 
         END IF 
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS THEN 
#     CALL cl_err('ins npq-3',STATUS,1) #No.FUN-660122
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq-3",1)  #No.FUN-660122
      LET g_success = 'N'  #No.FUN-680029
      END IF
   END IF
#--->貸方科目(銀行存款-本幣保證金+手續費)
   IF l_alc.alc95 != 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF g_apz.apz52 = '1' AND l_alc.alc92='1' THEN
         IF p_npptype = '0' THEN  #No.FUN-680029
            LET l_npq.npq03 = l_aps.aps24	# 貸: 應付票據
         #No.FUN-680029 --start--
         ELSE
            LET l_npq.npq03 = l_aps.aps241
         END IF
         #No.FUN-680029 --end--
      ELSE
         LET l_npq.npq03 = 'bankacct'	# 貸: 銀行存款
         IF p_npptype = '0' THEN  #No.FUN-680029
            SELECT nma05 INTO l_npq.npq03
              FROM nma_file WHERE nma01=l_alc.alc91
         #No.FUN-680029 --start--
         ELSE
            SELECT nma051 INTO l_npq.npq03
              FROM nma_file WHERE nma01=l_alc.alc91
         END IF
         #No.FUN-680029 --end--
      END IF
     #IF l_alc.alc85 != 0 THEN                      #MOD-B30334 mark
      IF l_alc.alc85 != 0 OR l_alc.alc951 = 0 THEN  #MOD-B30334
         CALL cl_getmsg('aap-748',g_lang) RETURNING l_msg
         #LET l_npq.npq04 = g_ala.ala01 CLIPPED,' ',{l_alc.alc02,' ',}    #FUN-D10065  mark
         #                  l_msg                                         #FUN-D10065  mark
         LET l_npq.npq07f = 0
         LET l_npq.npq24  = g_aza.aza17      #幣別  #MOD-B30334
         LET l_npq.npq25  = 1                #匯率  #MOD-B30334
      ELSE 
         CALL cl_getmsg('aap-749',g_lang) RETURNING l_msg
         #LET l_npq.npq04 = g_ala.ala01 CLIPPED,' ',{l_alc.alc02,' ',}    #FUN-D10065  mark
         #                  l_msg                                         #FUN-D10065  mark
         LET l_npq.npq07f = l_alc.alc34
         LET l_npq.npq24  = g_ala.ala20      #幣別  #MOD-B30334
         LET l_npq.npq25  = l_alc.alc51      #匯率  #MOD-B30334
      END IF
     #FUN-680019...............begin
      LET g_npq25 = l_npq.npq25              #MOD-B30334
     #LET l_npq.npq05 = ''
      LET l_aag05 = ''
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
        AND  aag00 = g_bookno1    #No.FUN-730064 
      IF l_aag05 = 'Y' THEN
         LET l_npq.npq05 = t741_set_npq05(g_ala.ala04,g_ala.ala930) #FUN-680019
      ELSE
         LET l_npq.npq05 = ' '
      END IF
     #FUN-680019...............end
      LET l_npq.npq06 = '2'
      LET l_npq.npq21 = ''
      LET l_npq.npq22 = ''
      LET l_npq.npq07 = l_alc.alc95
      #NO.FUN-5C0015 ---start
      LET l_npq.npq04 = NULL #FUN-D10065 add
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)    #No.FUN-730064
      RETURNING l_npq.*
      #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04 = g_ala.ala01 CLIPPED,' ',{l_alc.alc02,' ',}
                           l_msg
      END IF
      #FUN-D10065--add--end--
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
      #No.FUN-5C0015 ---end
      LET l_npq.npqlegal = g_legal #FUN-980001
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = '' 
         END IF 
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
#     CALL cl_err('ins npq-3',STATUS,1) #No.FUN-660122
      IF STATUS THEN                    #No.FUN-660122
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq-3",1)  #No.FUN-660122
         LET g_success = 'N'  #No.FUN-680029
      END IF                            #No.FUN-660122
   END IF
   CALL t110_gen_diff(l_npp.*)          #FUN-A40033
END FUNCTION
 
#No.FUN-670060 --start--
FUNCTION t741_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE l_apygslp1   LIKE apy_file.apygslp1  #No.FUN-680029
  DEFINE li_result    LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE g_t1         LIKE oay_file.oayslip  #No.FUN-690028 VARCHAR(5)
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",  #FUN-A50102
    LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_alc.alc74,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre2 FROM l_sql
    DECLARE aba_cs2 CURSOR FOR aba_pre2
    OPEN aba_cs2
    FETCH aba_cs2 INTO l_n
    IF l_n > 0 THEN
       CALL cl_err(g_alc.alc74,'aap-991',1)
       RETURN
    END IF
 
    #開窗作業
    LET g_plant_new= g_apz.apz02p
    CALL s_getdbs()
    LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
    LET g_plant_gl= g_apz.apz02p   #No.FUN-980059
 
    OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("axrt200_p")
     
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("gl_no1",FALSE)
    END IF
    #No.FUN-680029 --end--
     
    INPUT l_apygslp,l_apygslp1 WITHOUT DEFAULTS FROM FORMONLY.gl_no,FORMONLY.gl_no1  #No.FUN-680029
    
       AFTER FIELD gl_no
#         CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_dbs_gl)       #TQC-9B0162 mark
          CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_plant_gl)     #TQC-9B0162
                RETURNING li_result,l_apygslp
          IF (NOT li_result) THEN
             NEXT FIELD gl_no
          END IF
 
       #No.FUN-680088 --start--
       AFTER FIELD gl_no1
#         CALL s_check_no("agl",l_apygslp1,"","1","aac_file","aac01",g_dbs_gl)      #TQC-9B0162 mark
          CALL s_check_no("agl",l_apygslp,"","1","aac_file","aac01",g_plant_gl)     #TQC-9B0162
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
    CLOSE WINDOW t200p  
 
    IF INT_FLAG = 1 THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    IF cl_null(l_apygslp) OR (cl_null(l_apygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680029
       CALL cl_err(g_alc.alc01,'axr-070',1)
       RETURN
    END IF
    CALL s_get_doc_no(l_apygslp) RETURNING g_t1
    LET g_wc_gl = 'npp01 = "',g_alc.alc01,'" AND npp011 = ',g_alc.alc02
    LET g_str="aapp800 '",g_wc_gl CLIPPED,"' '",g_plant,"' '6' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_t1,"' '",g_alc.alc08,"' 'Y' '0' 'Y' '",g_apz.apz02c,"' '",l_apygslp1,"'"  #No.FUN-680029
    CALL cl_cmdrun_wait(g_str)
    SELECT alc74 INTO g_alc.alc74 FROM alc_file
     WHERE alc01 = g_alc.alc01
       AND alc02 = g_alc.alc02  #No.FUN-680029
    DISPLAY BY NAME g_alc.alc74
    
END FUNCTION
 
FUNCTION t741_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_alc.alc74,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_alc.alc74,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp810 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_alc.alc74,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT alc74 INTO g_alc.alc74 FROM alc_file
     WHERE alc01 = g_alc.alc01
       AND alc02 = g_alc.alc02  #No.FUN-680029
    DISPLAY BY NAME g_alc.alc74
END FUNCTION
#No.FUN-670060 --end--   
 
#FUN-680019...............begin
FUNCTION t741_set_npq05(p_dept,p_ala930)
DEFINE p_dept   LIKE gem_file.gem01,
       p_ala930 LIKE ala_file.ala930
       
   IF g_aaz.aaz90='Y' THEN
      RETURN p_ala930
   ELSE
      RETURN p_dept
   END IF
END FUNCTION
#No.FUN-A40033 --Begin
FUNCTION t110_gen_diff(p_npp)
DEFINE p_npp   RECORD LIKE npp_file.*
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_aag44          LIKE aag_file.aag44   #No.FUN-D40118   Add
DEFINE l_flag           LIKE type_file.chr1   #No.FUN-D40118   Add
   IF p_npp.npptype = '1' THEN
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno2
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = p_npp.npp00
            AND npq01 = p_npp.npp01
            AND npq011= p_npp.npp011
            AND npqsys= p_npp.nppsys
         LET l_npq1.npqtype = p_npp.npptype
         LET l_npq1.npq00 = p_npp.npp00
         LET l_npq1.npq01 = p_npp.npp01
         LET l_npq1.npq011= p_npp.npp011
         LET l_npq1.npqsys= p_npp.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal = g_legal
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno1,l_npq1.npq03,g_prog,l_npq1.npq01,'','')
         RETURNING l_npq1.npq04
         #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = '' 
            END IF 
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",p_npp.npp01,"",STATUS,"","",1) #FUN-670091
            LET g_success = 'N'
            ROLLBACK WORK
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
#FUN-680019...............end
#Patch....NO.TQC-610035 <001> #
