# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: anmt730.4gl
# Descriptions...: 信貸利息暫估維護作業
# Date & Author..: 96/04/10 By Roger
#                : 020326 By Joan 增加報表列印欄位
# Modify.........: No:7945 03/08/28 By Wiky
#                : 1.合約單號要帶出信貸銀行(因信貸銀行noentry)
#                : 2.BEFORE FIELD nnm15時,寫NEXT FIELD NEXT若單號類別及暫估類
#                    別2時會當掉
# Modify.........: No.8609 03/12/26 By Kitty 利息計算提前到止算日輸入完就算
# Modify.........: No.8989 03/12/26 By Kitty 加show user,grup等建檔標準欄位,加確
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-4C0098 05/01/12 By pengu 報表轉XML
# Modify.........: No.FUN-510026 05/01/13 By CoCo 匯率呼叫cl_numfor來format
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.FUN-560250 05/06/29 By Nicola FUNCTION t730_r()中未判斷若有分錄存在時,要刪除!
# Modify.........: No.MOD-580211 05/09/07 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: NO.MOD-5C0141 06/01/20 By Smapmin 更改狀態 單號類別/暫估類別應不可異動
# Modify.........: NO.MOD-640085 06/04/12 By Nicola 單據金額及分錄金額不合，不可確認
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-470001 06/06/07 By rainy 產生分錄時，詢問只產生此筆或依範圍產生
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670060 06/08/02 By wujie  直接拋總帳修改
# Modify.........: No.FUN-680088 06/08/28 By day    多帳套修改
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.MOD-690103 06/10/16 By Smapmin 單據確認時要先檢查分錄底稿
# Modify.........: No.MOD-690106 06/10/16 By Smapmin 利率不需依幣別取位
# Modify.........: No.CHI-6A0004 06/10/30 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改  
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah s_def_npq()時,p_key2與p_key3的地方改成傳nnm02,nnm03
# Modify.........: No.FUN-710024 07/02/05 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740028 07/04/10 By lora   會計科目加帳套
# Modify.........: No.MOD-740290 07/04/23 By Smapmin 檢查分錄時傳遞參數有誤
# Modify.........: No.MOD-740490 07/05/09 By johnray 5.0版更,已產生分錄底稿,但確認時提示無分錄底稿不可確認
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.MOD-790144 07/10/05 By Smapmin 修改變數定義大小
# Modify.........: NO.FUN-7B0026 07/11/13 By zhaijie 報表輸出改為Crystal Report
# Modify.........: No.MOD-810008 08/01/08 By Smapmin locking cursor必須定義在temp table之後
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840102 08/04/29 By hellen  功能調整，提供整批確認功能
# Modify.........: No.FUN-840102 08/05/06 By hellen  確認功能，整批show錯誤訊息列表
# Modify.........: No.FUN-850038 08/05/13 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-860033 08/06/09 By Sarah 產生分錄段不需檢查nmydmy3(拋轉傳票)的值,一律產生;確認段也不需檢查nmydmy3的值,都需做分錄的檢核
# Modify.........: No.FUN-8A0086 08/10/22 By zhaijie添加LET g_success = 'N'
# Modify.........: No.MOD-8C0124 08/12/12 By Sarah t730_out()段抓alg_file時條件應為alg01=g_nnm.nnm14
# Modify.........: No.MOD-8C0251 08/12/31 By Sarah 利息計算的方式應是算頭不算尾,第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920369 09/02/27 By Sarah 拋轉傳票成功後請秀訊息提示
# Modify.........: No.MOD-930162 09/03/16 By lilingyu 拋轉傳票應加會計關帳日期的關卡 
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.MOD-950209 09/05/20 By lilingyu t730_v()段產生分錄,應再增加參數判斷,若利息要回轉,則不可卡關帳日期
# Modify.........: No.MOD-970087 09/07/10 By mike  寫入CR Temptable前判斷若g_nnm.nnm13不為null時(表示已衝暫估),LET l_nnm19=0
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980261 09/08/31 By sabrina 不論什麼情況，都要檢查分錄底稿
# Modify.........: No:TQC-9B0153 09/11/19 By wujie 审核时，nnm12要加上nnm17 
# Modify.........: No:TQC-9B0169 09/11/20 By Carrier 审核时,nnmconf没有实时显示出来
# Modify.........: No:TQC-9B0092 09/12/25 By wujie 数值栏位不能为负数
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
#Modify..........: No.TQC-950167 10/03/04 By vealxu 1.close t730_w1 應該往前移到1830行之前，不然以後的 DISPLAY BY NAME g_nnm.nnmconf會出錯
#                                                   2.RETURNING g_wc不要用g_wc需用別的變數，不然連按兩次列印會prepare出錯
# Modify.........: No.TQC-A40115 10/04/26 By Carrier TQC-960047 追单 & _u() 时用旧值做join条件
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.CHI-A80036 10/08/31 By wuxj  整批确认时应对所有资料做检查
# Modify.........: No:CHI-A10014 10/10/19 By sabrina 若aza26='0'且幣別=aza17時，利息以365天計算，其餘則用360天計算
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.TQC-B10069 11/01/17 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No.FUN-AA0087 11/01/28 By Mengxw 異動碼類型設定的改善
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/06/07 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No:MOD-B90217 11/09/29 By Dido 拋轉傳票時,若 nmz52 = 'Y' 應開窗挑選應計單別
# Modify.........: No.MOD-BA0015 11/10/06 By Dido npq04 需先清空
# Modify.........: No.MOD-BB0070 11/11/07 By Polly 短期的暫估財務分攤費用加入交割服務費用(本幣)(nne46)
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C60200 12/06/26 By Polly 執行列印時，累計利息暫估(l_nnm19)應扣除已沖金額
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.FUN-C50030 13/01/28 By apo 暫估利息增加帶出本金 
# Modify.........: No:FUN-D10116 13/03/07 By Polly 增加作廢功能
# Modify.........: No.TQC-D50022 13/05/03 By fengrui 新增時畫面確認欄位需預設N
# Modify.........: No.FUN-D20010 13/05/20 By Polly 調整本金原幣/本金本幣應為當時融資餘額,而非融資原始金額
# Modify.........: No.FUN-D40118 13/05/22 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nnm        RECORD LIKE nnm_file.*,
    g_nnm_t      RECORD LIKE nnm_file.*,
    g_nnm01_t    LIKE nnm_file.nnm01,
    g_nnm02_t    LIKE nnm_file.nnm02,      #No.TQC-A40115
    g_nnm03_t    LIKE nnm_file.nnm03,      #No.TQC-A40115
    g_wc,g_sql   STRING,                   #TQC-630166 
    p_trno       LIKE npp_file.npp01,      #No:8989 #NO.FUN-680107 VARCHAR(20)   #MOD-790144
    g_alg02      LIKE alg_file.alg02,
    g_snnm18     LIKE ame_file.ame09,      #NO.FUN-680107 decimal(12,0)
    g_snnm19     LIKE ame_file.ame09,      #NO.FUN-680107 decimal(12,0)
    g_tlday      LIKE type_file.dat,       #NO.FUN-680107 DATE
    g_nmydmy1    LIKE nmy_file.nmydmy1,    #MOD-AC0073
    g_nmydmy3    LIKE nmy_file.nmydmy3,    #MOD-AC0073
    g_chr        LIKE type_file.chr1       #No:8989  #No.FUN-680107 VARCHAR(1)
   ,g_npp1       RECORD LIKE npp_file.*    #FUN-A40033
DEFINE g_forupd_sql        STRING          #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done STRING          
DEFINE   g_cnt         LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_msg         LIKE ze_file.ze03       #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   g_jump        LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE   g_str         STRING                  #No.FUN-670060                                                                                   
DEFINE   g_wc_gl       STRING                  #No.FUN-670060 
DEFINE   g_t1          LIKE oay_file.oayslip   #No.FUN-670060 #No.FUN-680107 VARCHAR(5)
DEFINE   g_dbs_gl      LIKE type_file.chr21    #NO.FUN-680107 VARCHAR(21) #No.FUN-670060 
DEFINE   g_bookno1     LIKE aza_file.aza81     #No.FUN-740028                                                                        
DEFINE   g_bookno2     LIKE aza_file.aza82     #No.FUN-740028                                                                        
DEFINE   g_bookno3     LIKE aza_file.aza82     #No.FUN-D40118   Add
DEFINE   g_flag        LIKE type_file.chr1     #No.FUN-740028 
DEFINE   g_sql1        STRING                  #NO.FUN-7B0026 
DEFINE   l_table       STRING                  #NO.FUN-7B0026
DEFINE   g_str1        STRING                  #NO.FUN-7B0026
DEFINE   g_npq25       LIKE npq_file.npq25     #No.FUN-9A0036
DEFINE   g_void        LIKE type_file.chr1     #FUN-D10116 add
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF

    INITIALIZE g_nnm.* TO NULL
    INITIALIZE g_nnm_t.* TO NULL

    LET g_sql1= "nnm01.nnm_file.nnm01,",
                "alg01.alg_file.alg01,",
                "alg02.alg_file.alg02,",
                "nnn02.nnn_file.nnn02,",
                "nnm09.nnm_file.nnm09,",
                "nnm02.nnm_file.nnm02,",
                "nnm03.nnm_file.nnm03,",
                "nnm05.nnm_file.nnm05,",
                "nnm06.nnm_file.nnm06,",
                "nnm07.nnm_file.nnm07,",
                "nnm08.nnm_file.nnm08,",
                "nnm10.nnm_file.nnm10,",
                "nnm11.nnm_file.nnm11,",
                "nnm12.nnm_file.nnm12,",
                "nnm17.nnm_file.nnm17,",
                "nnm13.nnm_file.nnm13,",
                "l_nnm18.nnm_file.nnm12,",
                "l_nnm19.nnm_file.nnm12,",
                "nnm14.nnm_file.nnm14,",
                "nnm15.nnm_file.nnm15,",
                "azi04.azi_file.azi04,",
                "azi07.azi_file.azi07"
    LET  l_table=cl_prt_temptable('anmt730',g_sql1) CLIPPED
    IF   l_table=-1 THEN EXIT PROGRAM END IF
    LET  g_sql1="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,",
               "        ?,?,?,?,?,?,?,?,?,?,",
               "        ?,?)"
         PREPARE insert_prep FROM g_sql1
         IF STATUS THEN 
            CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
         END IF

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    LET g_action_choice=""
    
    LET g_forupd_sql = "SELECT * FROM nnm_file WHERE nnm01 = ? AND nnm02 = ? AND nnm03 = ? FOR UPDATE"   #MOD-810008
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE t730_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR   #MOD-810008

    OPEN WINDOW t730_w WITH FORM "anm/42f/anmt730"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()

    CALL t730_menu()
 
    CLOSE WINDOW t730_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t730_cs()
    CLEAR FORM
   INITIALIZE g_nnm.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        nnm01,nnmconf,nnm02,nnm03,nnm04,nnm15,nnm14,nnmglno,nnm13,nnm05,nnm06,
        nnm07,nnm08,nnm09,nnm10,nnm11,nnm12,nnm17,
        nnmuser,nnmgrup,nnmmodu,nnmdate
        ,nnmud01,nnmud02,nnmud03,nnmud04,nnmud05,
        nnmud06,nnmud07,nnmud08,nnmud09,nnmud10,
        nnmud11,nnmud12,nnmud13,nnmud14,nnmud15
 
        ON ACTION CONTROLP                        # 沿用所有欄位
            IF INFIELD(nnm14) THEN #銀行代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_alg"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = g_nnm.nnm14
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nnm14
               NEXT FIELD nnm14
            END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nnmuser', 'nnmgrup') #FUN-980030
    LET g_sql="SELECT nnm01,nnm02,nnm03 FROM nnm_file ",
        " WHERE ",g_wc CLIPPED, "  ORDER BY nnm01,nnm02,nnm03"
    PREPARE t730_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t730_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t730_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM nnm_file WHERE ",g_wc CLIPPED
    PREPARE t730_precount FROM g_sql
    DECLARE t730_count CURSOR FOR t730_precount
END FUNCTION
 
FUNCTION t730_menu()
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_aza.aza63 != 'Y' THEN
               CALL cl_set_act_visible("maint_entry_sheet2",FALSE)
            ELSE
               CALL cl_set_act_visible("maint_entry_sheet2",TRUE)
            END IF
 
        ON ACTION insert
            LET g_action_choice = 'insert'
            IF cl_chk_act_auth() THEN
                 CALL t730_a()
            END IF
        ON ACTION query
            LET g_action_choice = 'query'
            IF cl_chk_act_auth() THEN
                 CALL t730_q()
            END IF
        ON ACTION next
            CALL t730_fetch('N')
        ON ACTION previous
            CALL t730_fetch('P')
        ON ACTION modify
            LET g_action_choice = 'modify'
            IF cl_chk_act_auth() THEN
                 CALL t730_u()
            END IF
        #產生分錄
        ON ACTION gen_entry_sheet
            LET g_action_choice = 'gen_entry_sheet'
            IF cl_chk_act_auth() THEN
		          #FUN-470001 --start
               CALL t730_s()  
               CALL t730_gen_diff() #FUN-A40033
            END IF
 
        #分錄底稿維護
        ON ACTION maint_entry_sheet
            LET g_action_choice = 'maint_entry_sheet'
              LET p_trno=g_nnm.nnm01,g_nnm.nnm02 USING '&&&&',g_nnm.nnm03 USING '&#'
              CALL s_fsgl('NM',18,p_trno,0,g_nmz.nmz02b,0,g_nnm.nnmconf,'0',g_nmz.nmz02p)   #No.FUN-680088
              CALL cl_navigator_setting( g_curs_index, g_row_count )      #No.FUN-680088
      
        ON ACTION maint_entry_sheet2
            LET g_action_choice = 'maint_entry_sheet2'
              LET p_trno=g_nnm.nnm01,g_nnm.nnm02 USING '&&&&',g_nnm.nnm03 USING '&#'
              CALL s_fsgl('NM',18,p_trno,0,g_nmz.nmz02c,0,g_nnm.nnmconf,'1',g_nmz.nmz02p)   #No.FUN-680088
              CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        #確認
         ON ACTION carry_voucher
            IF cl_chk_act_auth() THEN
               IF g_nnm.nnmconf = 'Y' THEN                                                                                            
                  CALL t730_carry_voucher()                                                                                            
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF                                                                                                                  
            END IF                                                                                                                  
         ON ACTION undo_carry_voucher
            IF cl_chk_act_auth() THEN
               IF g_nnm.nnmconf = 'Y' THEN                                                                                            
                  CALL t730_undo_carry_voucher()                                                                                       
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF                                                                                                                  
            END IF                                                                                                                  
        ON ACTION delete
            LET g_action_choice = 'delete'
            IF cl_chk_act_auth() THEN
                 CALL t730_r()
            END IF
 
        ON ACTION confirm
            LET g_action_choice = 'confirm'
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()   #TQC-B10069
               CALL t730_firm1()
               CALL s_showmsg()        #TQC-B10069
              #CALL cl_set_field_pic(g_nnm.nnmconf,"","","","","")        #FUN-D10116 mark
               CALL cl_set_field_pic(g_nnm.nnmconf,"","","",g_void,"")    #FUN-D10116 add
            END IF
 
        ON ACTION undo_confirm
            IF cl_chk_act_auth() THEN
               CALL t730_firm2()
              #CALL cl_set_field_pic(g_nnm.nnmconf,"","","","","")        #FUN-D10116 mark
               CALL cl_set_field_pic(g_nnm.nnmconf,"","","",g_void,"")    #FUN-D10116 add
            END IF
 
       #--------------FUN-D10116---------------(S)
        ON ACTION void
           LET g_action_choice = "void"
           IF cl_chk_act_auth() THEN
              CALL t730_x()
              IF g_nnm.nnmconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_nnm.nnmconf,"","","",g_void,"")
           END IF
       #--------------FUN-D10116---------------(E)

        ON ACTION output
            LET g_action_choice = 'output'
            IF cl_chk_act_auth()
               THEN CALL t730_out()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                                    #No.FUN-550037 hmf
          #CALL cl_set_field_pic(g_nnm.nnmconf,"","","","","")        #FUN-D10116 mark
           CALL cl_set_field_pic(g_nnm.nnmconf,"","","",g_void,"")    #FUN-D10116 add

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL t730_fetch('/')

        ON ACTION first
            CALL t730_fetch('F')

        ON ACTION last
            CALL t730_fetch('L')
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_nnm.nnm01 IS NOT NULL THEN
               LET g_doc.column1 = "nnm01"
               LET g_doc.value1 = g_nnm.nnm01
               CALL cl_doc()
             END IF
          END IF
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t730_cs
END FUNCTION
 
FUNCTION t730_a()
    IF s_anmshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_nnm.* LIKE nnm_file.*
    LET g_nnm.nnm08=0
    LET g_nnm.nnmconf='N'                    #No:8989
    LET g_nnm.nnm10=1
    LET g_nnm.nnm11=0
    LET g_nnm.nnm12=0
    LET g_nnm01_t = NULL
    LET g_nnm02_t = NULL    #No.TQC-A40115
    LET g_nnm03_t = NULL    #No.TQC-A40115
    LET g_nnm_t.*=g_nnm.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_nnm.nnmuser = g_user             #No:8989
        LET g_nnm.nnmoriu = g_user #FUN-980030
        LET g_nnm.nnmorig = g_grup #FUN-980030
        LET g_nnm.nnmgrup = g_grup             #使用者所屬群 No:8989
        LET g_nnm.nnmdate = g_today            #No:8989
        LET g_nnm.nnmlegal= g_legal
 
        CALL t730_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_nnm.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_nnm.nnm01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO nnm_file VALUES(g_nnm.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","nnm_file",g_nnm.nnm01,g_nnm.nnm02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
           CONTINUE WHILE
        ELSE
          #-MOD-AC0073-add-
           #---判斷是否立即confirm-----
           LET g_t1 = s_get_doc_no(g_nnm.nnm01)    
           SELECT nmydmy1,nmydmy3 INTO g_nmydmy1,g_nmydmy3
             FROM nmy_file
            WHERE nmyslip = g_t1 AND nmyacti = 'Y'
           IF g_nmydmy3 = 'Y' THEN
              IF cl_confirm('axr-309') THEN
                 CALL t730_s()  
                 CALL t730_gen_diff() #FUN-A40033
              END IF
           END IF
#TQC-B10069 ---------------------------Begin----------------------------------
          #IF g_nmydmy1 = 'Y' AND g_nmydmy3='N' THEN CALL t730_firm1() END IF
           CALL s_showmsg_init()    
           IF g_nmydmy1 = 'Y' AND g_nmydmy3='N' THEN
              CALL t730_firm1()
           END IF
           CALL s_showmsg()    
#TQC-B10069 ---------------------------End------------------------------------
          #-MOD-AC0073-end-
           LET g_nnm_t.* = g_nnm.*                # 保存上筆資料
           SELECT nnm01,nnm02,nnm03 INTO g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03 FROM nnm_file
               WHERE nnm01 = g_nnm.nnm01
                 AND nnm02 = g_nnm.nnm02
                 AND nnm03 = g_nnm.nnm03
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t730_i(p_cmd)
    DEFINE
        p_cmd        LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_flag       LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE
        l_nne12      LIKE nne_file.nne12,
        l_nne27      LIKE nne_file.nne27,
        l_nnl12      LIKE nnl_file.nnl12,
        l_nne112     LIKE nne_file.nne112,
        l_nng20      LIKE nng_file.nng20 ,
        l_nng21      LIKE nng_file.nng21,
        l_date       LIKE nne_file.nne112,    #MOD-8C0251 add
        l_nne19      LIKE nne_file.nne19      #FUN-C50030 
   DEFINE  l_nne20   LIKE nne_file.nne20      #FUN-D20010 add
 
    DISPLAY BY NAME g_nnm.nnmconf  #TQC-D50022 add

    INPUT BY NAME g_nnm.nnmoriu,g_nnm.nnmorig,
        g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03,
        g_nnm.nnm04,g_nnm.nnm15,g_nnm.nnm14,g_nnm.nnmglno,g_nnm.nnm13,
        g_nnm.nnm05,g_nnm.nnm06,
        g_nnm.nnm07,g_nnm.nnm08,g_nnm.nnm09,
        g_nnm.nnm10,g_nnm.nnm11,g_nnm.nnm12,g_nnm.nnm17,
        g_nnm.nnmuser,g_nnm.nnmgrup,g_nnm.nnmmodu,g_nnm.nnmdate
        ,g_nnm.nnmud01,g_nnm.nnmud02,g_nnm.nnmud03,g_nnm.nnmud04,
        g_nnm.nnmud05,g_nnm.nnmud06,g_nnm.nnmud07,g_nnm.nnmud08,
        g_nnm.nnmud09,g_nnm.nnmud10,g_nnm.nnmud11,g_nnm.nnmud12,
        g_nnm.nnmud13,g_nnm.nnmud14,g_nnm.nnmud15 
 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t730_set_entry(p_cmd)
            CALL t730_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("nnm01")
         CALL cl_set_docno_format("nnm13")
         CALL cl_set_docno_format("nnmglno")
 
        AFTER FIELD nnm01
            IF NOT cl_null(g_nnm.nnm01) THEN
               SELECT COUNT(*) INTO g_cnt FROM nne_file
                WHERE nne01=g_nnm.nnm01 AND nneconf <> 'X'
               SELECT COUNT(*) INTO l_n FROM nng_file
                WHERE nng01=g_nnm.nnm01 AND nngconf <> 'X'
               IF g_cnt + l_n = 0 THEN       #不存在 nne_file or nng_file
                  CALL cl_err('','anm-654',0) NEXT FIELD nnm01
               END IF
            END IF
        AFTER FIELD nnm02
           CALL s_get_bookno(g_nnm.nnm02) RETURNING g_flag,g_bookno1,g_bookno2                                          
           IF g_flag =  '1' THEN  #抓不到帳別                                                                                               
              CALL cl_err(g_nnm.nnm02,'aoo-081',1) 
              NEXT FIELD nnm02                                                                                         
           END IF             
 
 
        AFTER FIELD nnm03
            IF NOT cl_null(g_nnm.nnm03) THEN
               #No.TQC-A40115  --Begin
               # 若輸入或更改且改KEY
               IF p_cmd = "a" OR  p_cmd = "u" AND (g_nnm.nnm01 != g_nnm01_t OR
                  g_nnm.nnm02 != g_nnm02_t OR g_nnm.nnm03 != g_nnm03_t ) THEN
               #No.TQC-A40115  --End  
                   SELECT count(*) INTO l_n FROM nnm_file
                       WHERE nnm01 = g_nnm.nnm01
                         AND nnm02 = g_nnm.nnm02
                         AND nnm03 = g_nnm.nnm03
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_nnm.nnm01,-239,0)
                       LET g_nnm.nnm01 = g_nnm01_t
                       DISPLAY BY NAME g_nnm.nnm01
                       NEXT FIELD nnm01
                   END IF
               END IF
            END IF
 
        BEFORE FIELD nnm04
            CALL t730_set_entry(p_cmd)
 
        AFTER FIELD nnm04
           #LET l_nne12 = ''                        #FUN-C50030 #FUN-D20010 mark
           #LET l_nne19 = ''                        #FUN-C50030 #FUN-D20010 mark
            IF g_nnm.nnm04 NOT MATCHES '[12]' THEN
               NEXT FIELD nnm04
            END IF
            IF NOT cl_null(g_nnm.nnm04) THEN
               IF g_nnm.nnm04='1' THEN   #No:7945
                  SELECT COUNT(*) INTO l_n
                    FROM nne_file
                   WHERE nne01=g_nnm.nnm01
                  IF l_n = 0 THEN
                     CALL cl_err(g_nnm.nnm01,'anm-965',1)
                     NEXT FIELD nnm04
                  END IF
                #---------FUN-D20010----------mark
                ##FUN-C50030--
                # SELECT nne12,nne19 INTO l_nne12,l_nne19 FROM nne_file
                #  WHERE nne01=g_nnm.nnm01
                # DISPLAY l_nne12,l_nne19 TO nne12,nne19        
                ##FUN-C50030--
                #---------FUN-D20010----------mark
               ELSE
                  SELECT COUNT(*) INTO l_n
                    FROM nng_file
                   WHERE nng01=g_nnm.nnm01
                  IF l_n=0 THEN
                     CALL cl_err(g_nnm.nnm01,'anm-966',1)
                     NEXT FIELD nnm04
                  END IF
                #---------FUN-D20010----------mark
                ##FUN-C50030--
                # SELECT nng20,nng22 INTO l_nne12,l_nne19 FROM nng_file
                #  WHERE nng01=g_nnm.nnm01
                # DISPLAY l_nne12,l_nne19 TO nne12,nne19        
                ##FUN-C50030--
                #---------FUN-D20010----------mark
               END IF
               IF g_nnm.nnm04 = '2' THEN
                  LET g_nnm.nnm15='2'
                  DISPLAY BY NAME g_nnm.nnm15
                  CALL t730_nnm01('a')   #No:7945
               END IF
            END IF
            CALL t730_set_no_entry(p_cmd)
 
        AFTER FIELD nnm14
            IF NOT cl_null(g_nnm.nnm14) THEN
               SELECT alg02 INTO g_alg02 FROM alg_file WHERE alg01=g_nnm.nnm14
               IF STATUS THEN
                  CALL cl_err3("sel","alg_file",g_nnm.nnm14,"",STATUS,"","sel alg:",1)  #No.FUN-660148
                  NEXT FIELD nnm14
               ELSE
                  DISPLAY g_alg02 TO FORMONLY.alg02
               END IF
            END IF
 
        AFTER FIELD nnm05
            IF g_nnm.nnm15='1' THEN   #1.短期    #MOD-8C0251 add
               SELECT nne112 INTO l_date FROM nne_file   #MOD-8C0251 mod l_nne112->l_date
                WHERE nne01=g_nnm.nnm01 AND nneconf <> 'X'
            ELSE                      #2.中長貸
               SELECT nng102 INTO l_date FROM nng_file
                WHERE nng01=g_nnm.nnm01 AND nngconf <> 'X'
            END IF
            IF g_nnm.nnm05>g_nnm.nnm06 THEN
               NEXT FIELD nnm06
            ELSE
               #利息計算的方式應是算頭不算尾,
               #第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
               IF g_nnm.nnm06=l_date THEN   #止算日期=融資截止日期    #MOD-8C0251 mod l_nne112->l_date
                  LET g_nnm.nnm07 = g_nnm.nnm06 - g_nnm.nnm05
               ELSE
                  LET g_nnm.nnm07 = g_nnm.nnm06 - g_nnm.nnm05 + 1
               END IF
                 DISPLAY BY NAME g_nnm.nnm07
            END IF
 
        AFTER FIELD nnm06        #85-10-30
            IF g_nnm.nnm15='1' THEN   #1.短期
               SELECT nne112 INTO l_date FROM nne_file
                WHERE nne01=g_nnm.nnm01 AND nneconf <> 'X'
            ELSE                      #2.中長貸
               SELECT nng082 INTO l_date FROM nng_file
                WHERE nng01=g_nnm.nnm01 AND nngconf <> 'X'
            END IF
            IF g_nnm.nnm05>g_nnm.nnm06 THEN
               NEXT FIELD nnm05
            ELSE
               #利息計算的方式應是算頭不算尾,
               #第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
               IF g_nnm.nnm06=l_date THEN   #止算日期=融資截止日期    #MOD-8C0251 mod l_nne112->l_date
                  LET g_nnm.nnm07 = g_nnm.nnm06 - g_nnm.nnm05
               ELSE
                  LET g_nnm.nnm07 = g_nnm.nnm06 - g_nnm.nnm05 + 1
               END IF
               DISPLAY BY NAME g_nnm.nnm07
               CALL t730_nnm11()
            END IF
           #-----------FUN-D20010--------------------(S)
            LET l_nne12 = ''   
            LET l_nne19 = ''  
            LET l_nne20 = ''
            LET l_nne27 = '' 
            IF NOT cl_null(g_nnm.nnm04) THEN
               IF g_nnm.nnm04 = '1' THEN  
                  SELECT nne12,nne19 INTO l_nne12,l_nne19 FROM nne_file
                   WHERE nne01 = g_nnm.nnm01
               ELSE
                  SELECT nng20,nng22 INTO l_nne12,l_nne19 FROM nng_file
                   WHERE nng01 = g_nnm.nnm01
               END IF

               SELECT SUM(nnl11),SUM(nnl13) INTO l_nne27,l_nne20
                 FROM nnl_file,nnk_file
                WHERE nnl04 = g_nnm.nnm01
                  AND nnl01 = nnk01
                  AND nnk02 <= g_nnm.nnm06
                  AND nnkconf = 'Y'
               IF cl_null(l_nne27) THEN LET l_nne27 = 0 END IF
               IF cl_null(l_nne20) THEN LET l_nne20 = 0 END IF
               LET l_nne12 = l_nne12 - l_nne27
               LET l_nne19 = l_nne19 - l_nne20
               DISPLAY l_nne12,l_nne19 TO nne12,nne19
            END IF
           #-----------FUN-D20010--------------------(E)
 
        AFTER FIELD nnm09   #幣別
            IF NOT cl_null(g_nnm.nnm09) THEN
               SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01 = g_nnm.nnm09
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","azi_file",g_nnm.nnm09,"","anm-040","","sel azi:",1)  #No.FUN-660148
                  NEXT FIELD nnm09
               END IF
            END IF
 
        AFTER FIELD nnm08
           CALL t730_nnm11()
           IF g_nnm.nnm08 <0 THEN                                               
              CALL cl_err(g_nnm.nnm08,'aim-391',1)                              
              LET g_nnm.nnm08 = g_nnm_t.nnm08                                   
              NEXT FIELD nnm08                                                  
           END IF                                                               
 
        AFTER FIELD nnm10
             #移到function
             CALL t730_nnm11()
 
            IF g_nnm.nnm09 =g_aza.aza17 THEN
               LET g_nnm.nnm10  =1
                   DISPLAY BY NAME g_nnm.nnm10
             END IF
             #--END
 
        AFTER FIELD nnm15
            IF g_nnm.nnm15 NOT MATCHES'[12]' THEN NEXT FIELD nnm15 END IF
            IF NOT cl_null(g_nnm.nnm15) THEN
               CALL t730_nnm01('a')   #No:7945
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_nnm.nnm15 = g_nnm_t.nnm15
                  DISPLAY BY NAME g_nnm.nnm15
                  DISPLAY g_nnm.nnm14 TO nnm14
                  DISPLAY '' TO FORMONLY.alg02
                  NEXT FIELD nnm15
               END IF
            END IF
 
        #----------------------------------------------------------------#
        AFTER FIELD nnm11
            IF g_nnm.nnm11 < 0 THEN NEXT FIELD nnm11 END IF
            IF NOT cl_null(g_nnm.nnm11) THEN
               CALL cl_digcut(g_nnm.nnm11,t_azi04) RETURNING g_nnm.nnm11
               DISPLAY BY NAME g_nnm.nnm11
            END IF
 
        AFTER FIELD nnm12
            IF g_nnm.nnm12 < 0 THEN NEXT FIELD nnm12 END IF
            IF NOT cl_null(g_nnm.nnm12) THEN
               CALL cl_digcut(g_nnm.nnm12,g_azi04) RETURNING g_nnm.nnm12
               DISPLAY BY NAME g_nnm.nnm12
            END IF
 
        AFTER FIELD nnm17
            IF g_nnm.nnm17 < 0 THEN NEXT FIELD nnm17 END IF
            IF NOT cl_null(g_nnm.nnm17) THEN
               CALL cl_digcut(g_nnm.nnm17,g_azi04) RETURNING g_nnm.nnm17
               DISPLAY BY NAME g_nnm.nnm17
            END IF
        #-------------------------------------------------------------
        AFTER FIELD nnmud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnmud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nnm.nnmuser = s_get_data_owner("nnm_file") #FUN-C10039
           LET g_nnm.nnmgrup = s_get_data_group("nnm_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD nnm01
            END IF
 
        ON ACTION CONTROLP                        # 沿用所有欄位
            IF INFIELD(nnm14) THEN #銀行代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_alg"
               LET g_qryparam.default1 = g_nnm.nnm14
               CALL cl_create_qry() RETURNING g_nnm.nnm14
               DISPLAY BY NAME g_nnm.nnm14
               NEXT FIELD nnm14
            END IF
              IF INFIELD(nnm10) THEN
                   CALL s_rate(g_nnm.nnm09,g_nnm.nnm10) RETURNING g_nnm.nnm10
                   DISPLAY BY NAME g_nnm.nnm10
                   NEXT FIELD nnm10
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
 
 
    END INPUT
END FUNCTION
FUNCTION t730_nnm01(p_cmd)
DEFINE
 p_cmd      LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
 l_nng04    LIKE nng_file.nng04,
 l_conf     LIKE nng_file.nngconf,
 l_alg02    LIKE alg_file.alg02
 
  LET g_errno=''
  IF g_nnm.nnm15='1' THEN
      SELECT nne04,nneconf INTO g_nnm.nnm14,l_conf
        FROM nne_file
       WHERE nne01=g_nnm.nnm01
         AND nneconf='Y'
  ELSE
      SELECT nng04,nngconf INTO g_nnm.nnm14,l_conf
        FROM nng_file
       WHERE nng01=g_nnm.nnm01
         AND nngconf='Y'
  END IF
 
  CASE
      WHEN SQLCA.sqlcode=100   LET g_errno='anm-964'
                               LET g_nnm.nnm14= NULL
                               LET l_conf = NULL
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
  END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY g_nnm.nnm14 TO nnm14
      SELECT alg02 INTO l_alg02 FROM alg_file
       WHERE alg01=g_nnm.nnm14
      IF SQLCA.sqlcode THEN LET l_alg02=' ' END IF
      DISPLAY l_alg02 TO FORMONLY.alg02
   END IF
END FUNCTION
 
FUNCTION t730_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nnm.* TO NULL              #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t730_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t730_count
    FETCH t730_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t730_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnm.nnm01,SQLCA.sqlcode,0)
        INITIALIZE g_nnm.* TO NULL
    ELSE
        CALL t730_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t730_fetch(p_flnnm)
    DEFINE
        p_flnnm  LIKE type_file.chr1,    #NO.FUN-680107 VARCHAR(1)
        l_abso   LIKE type_file.num10    #No.FUN-680107 INTEGER
 
    CASE p_flnnm
        WHEN 'N' FETCH NEXT     t730_cs INTO g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
        WHEN 'P' FETCH PREVIOUS t730_cs INTO g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
        WHEN 'F' FETCH FIRST    t730_cs INTO g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
        WHEN 'L' FETCH LAST     t730_cs INTO g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
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
            FETCH ABSOLUTE g_jump t730_cs INTO g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnm.nnm01,SQLCA.sqlcode,0)
        INITIALIZE g_nnm.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnnm
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL s_get_bookno(g_nnm.nnm02) RETURNING g_flag,g_bookno1,g_bookno2                                      
           IF g_flag =  '1' THEN  #抓不到帳別                                                                                       
              CALL cl_err(g_nnm.nnm02,'aoo-081',1)                                                                                  
           END IF                                                                                                                   
 
    SELECT * INTO g_nnm.* FROM nnm_file            # 重讀DB,因TEMP有不被更新特性
       WHERE nnm01 = g_nnm.nnm01 AND nnm02 = g_nnm.nnm02 AND nnm03 = g_nnm.nnm03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","nnm_file",g_nnm.nnm01,g_nnm.nnm02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_data_owner = g_nnm.nnmuser     #No.FUN-4C0063
       LET g_data_group = g_nnm.nnmgrup     #No.FUN-4C0063
       CALL t730_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION t730_show()
DEFINE   l_nne12       LIKE nne_file.nne12     #FUN-C50030
DEFINE   l_nne19       LIKE nne_file.nne19     #FUN-C50030
DEFINE   l_nne20       LIKE nne_file.nne20     #FUN-D20010 add
DEFINE   l_nne27       LIKE nne_file.nne27     #FUN-D20010 add

    LET g_nnm_t.* = g_nnm.*
    DISPLAY BY NAME g_nnm.nnmoriu,g_nnm.nnmorig,
        g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03,
        g_nnm.nnm04,g_nnm.nnm15,g_nnm.nnm14,g_nnm.nnm05,g_nnm.nnm06,
        g_nnm.nnm07,g_nnm.nnm08,g_nnm.nnm09,
        g_nnm.nnm10,g_nnm.nnm11,g_nnm.nnm12,g_nnm.nnm17,
        g_nnm.nnmglno,g_nnm.nnm13,g_nnm.nnmconf,#No:8989
        g_nnm.nnmuser,g_nnm.nnmgrup,g_nnm.nnmmodu,g_nnm.nnmdate
        ,g_nnm.nnmud01,g_nnm.nnmud02,g_nnm.nnmud03,g_nnm.nnmud04,
        g_nnm.nnmud05,g_nnm.nnmud06,g_nnm.nnmud07,g_nnm.nnmud08,
        g_nnm.nnmud09,g_nnm.nnmud10,g_nnm.nnmud11,g_nnm.nnmud12,
        g_nnm.nnmud13,g_nnm.nnmud14,g_nnm.nnmud15 
       #FUN-C50030--
        LET l_nne12 = ''   
        LET l_nne19 = ''  
        IF g_nnm.nnm04='1' THEN  
           SELECT nne12,nne19 INTO l_nne12,l_nne19 FROM nne_file
            WHERE nne01=g_nnm.nnm01
          #DISPLAY l_nne12,l_nne19 TO nne12,nne19        #FUN-D20010 mark
        ELSE
           SELECT nng20,nng22 INTO l_nne12,l_nne19 FROM nng_file
            WHERE nng01=g_nnm.nnm01
          #DISPLAY l_nne12,l_nne19 TO nne12,nne19        #FUN-D20010 mark
        END IF
       #FUN-C50030--
       #-----------FUN-D20010--------------------(S)
        LET l_nne20 = ''
        LET l_nne27 = ''
        SELECT SUM(nnl11),SUM(nnl13) INTO l_nne27,l_nne20
          FROM nnl_file,nnk_file
         WHERE nnl04 = g_nnm.nnm01
           AND nnl01 = nnk01
           AND nnk02 <= g_nnm.nnm06
           AND nnkconf = 'Y'
        IF cl_null(l_nne27) THEN LET l_nne27 = 0 END IF
        IF cl_null(l_nne20) THEN LET l_nne20 = 0 END IF
        LET l_nne12 = l_nne12 - l_nne27
        LET l_nne19 = l_nne19 - l_nne20
        DISPLAY l_nne12,l_nne19 TO nne12,nne19
       #-----------FUN-D20010--------------------(E)
   CALL t730_nnm01('d')  #No:7945
  #------------------------FUN-D10116---------------------------(S)
   IF g_nnm.nnmconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_nnm.nnmconf,"","","",g_void,"")
  #------------------------FUN-D10116---------------------------(E)
  #CALL cl_set_field_pic(g_nnm.nnmconf,"","","","","")        #FUN-D10116 mark
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t730_u()
DEFINE  l_msg  LIKE ze_file.ze03  #NO.FUN-680107 VARCHAR(60)
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nnm.nnm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_nnm.nnmconf='Y' THEN CALL cl_err('','anm-137',1) RETURN END IF  #No:8989
   #----------------FUN-D10116-------------(S)
    IF g_nnm.nnmconf = 'X' THEN
       CALL cl_err(g_nnm.nnm01,'9024',0)
       RETURN
    END IF
   #----------------FUN-D10116-------------(E)
    IF g_nnm.nnm13 IS NOT NULL OR g_nnm.nnmglno IS NOT NULL THEN
       CALL cl_getmsg('aap',g_lang) RETURNING l_msg
       ERROR l_msg CLIPPED  RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_nnm01_t = g_nnm.nnm01
    LET g_nnm02_t = g_nnm.nnm02      #No.TQC-A40115
    LET g_nnm03_t = g_nnm.nnm03      #No.TQC-A40115
    BEGIN WORK
    OPEN t730_cl USING g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
    IF STATUS THEN
       CALL cl_err("OPEN t730_cl:", STATUS, 1)
       CLOSE t730_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t730_cl INTO g_nnm.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnm.nnm01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_nnm.nnmmodu = g_user                #No:8989
    LET g_nnm.nnmdate = g_today               #No:8989
    CALL t730_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t730_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_nnm.*=g_nnm_t.*
            CALL t730_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE nnm_file SET nnm_file.* = g_nnm.*    # 更新DB
        #   WHERE nnm01 = g_nnm.nnm01 AND nnm02 = g_nnm.nnm02 AND nnm03 = g_nnm.nnm03             # COLAUTH?  #No.TQC-A40115
            WHERE nnm01 = g_nnm01_t   AND nnm02 = g_nnm02_t   AND nnm03 = g_nnm03_t               # COLAUTH?  #No.TQC-A40115
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","nnm_file",g_nnm01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t730_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t730_r()
DEFINE  l_msg  LIKE ze_file.ze03  #NO.FUN-680107 VARCHAR(50)
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nnm.nnm01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_nnm.nnmconf='Y' THEN CALL cl_err('','anm-139',1) RETURN END IF  #No:8989
   #----------------FUN-D10116-------------(S)
    IF g_nnm.nnmconf = 'X' THEN
       CALL cl_err(g_nnm.nnm01,'9024',0)
       RETURN
    END IF
   #----------------FUN-D10116-------------(E)
    SELECT * INTO g_nnm.* FROM nnm_file WHERE nnm01 = g_nnm.nnm01
                                          AND nnm02 = g_nnm.nnm02
                                          AND nnm03 = g_nnm.nnm03
    IF g_nnm.nnm13 IS NOT NULL OR g_nnm.nnmglno IS NOT NULL THEN
       CALL cl_getmsg('aap-755',g_lang) RETURNING l_msg
       ERROR l_msg CLIPPED RETURN
    END IF
    BEGIN WORK
    OPEN t730_cl USING g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
    IF STATUS THEN
       CALL cl_err("OPEN t730_cl:", STATUS, 1)
       CLOSE t730_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t730_cl INTO g_nnm.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnm.nnm01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t730_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nnm01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nnm.nnm01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM nnm_file
        WHERE nnm01 = g_nnm.nnm01
          AND nnm02 = g_nnm.nnm02
          AND nnm03 = g_nnm.nnm03
 
      LET p_trno=g_nnm.nnm01,g_nnm.nnm02 USING '&&&&',g_nnm.nnm03 USING '&#'
      DELETE FROM npp_file
       WHERE nppsys = 'NM'
         AND npp00 = 18
         AND npp01 = p_trno
         AND npp011 = 0
 
      DELETE FROM npq_file
       WHERE npqsys = 'NM'
         AND npq00 = 18
         AND npq01 = p_trno
         AND npq011 = 0
         
       #FUN-B40056--add--str--
       DELETE FROM tic_file WHERE tic04 = p_trno
       #FUN-B40056--add--end-- 

       CLEAR FORM
       OPEN t730_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE t730_cl
          CLOSE t730_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       FETCH t730_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t730_cl
          CLOSE t730_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t730_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t730_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t730_fetch('/')
       END IF
    END IF
    CLOSE t730_cl
    COMMIT WORK
END FUNCTION
 
#-----------------FUN-D10116---------------------(S)
FUNCTION t730_x()
   DEFINE  l_trno  LIKE type_file.chr50

   IF s_anmshut(0) THEN RETURN END IF
   IF cl_null(g_nnm.nnm01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK

   OPEN t730_cl USING g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
   IF STATUS THEN
      CALL cl_err("OPEN t730_cl:", STATUS, 1)
      CLOSE t730_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t730_cl INTO g_nnm.*               # 對DB鎖定
   IF STATUS THEN
      CALL cl_err(g_nnm.nnm01,SQLCA.sqlcode,0)
      CLOSE t730_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF g_nnm.nnmconf = 'Y' THEN
      CALL cl_err(g_nnm.nnm01,'alm-870',2)
      CLOSE t730_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_nnm.nnmconf) THEN
      LET l_trno=g_nnm.nnm01,g_nnm.nnm02 USING '&&&&',g_nnm.nnm03 USING '&#'
      IF g_nnm.nnmconf = 'N' THEN                        #切換為作廢
         DELETE FROM npp_file
          WHERE nppsys= 'NM'
            AND npp00 = 18
            AND npp01 = l_trno
            AND npp011 = 0
         IF STATUS THEN
            CALL cl_err3("del","npp_file",g_nnm.nnm01,"",SQLCA.sqlcode,"","",1)
         ELSE
            DELETE FROM npq_file
             WHERE npqsys= 'NM'
               AND npq00 = 18
               AND npq01 = l_trno
               AND npq011 = 0
            IF STATUS THEN
               CALL cl_err3("del","npq_file",g_nnm.nnm01,"",SQLCA.sqlcode,"","",1)
            END IF
         END IF
         LET g_nnm.nnmconf = 'X'
      ELSE                                             #取消作廢
         LET g_nnm.nnmconf = 'N'
      END IF
      UPDATE nnm_file SET nnmconf = g_nnm.nnmconf
       WHERE nnm01 = g_nnm.nnm01
         AND nnm02 = g_nnm.nnm02
         AND nnm03 = g_nnm.nnm03

      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","nnm_file",g_nnm.nnm01,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_nnm.nnm01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CLOSE t730_cl
   CALL t730_show()                      # 重新顯示
END FUNCTION
#-----------------FUN-D10116---------------------(E)

FUNCTION t730_out()
    DEFINE
        l_i      LIKE type_file.num5,     #No.FUN-680107 SMALLINT
        l_name   LIKE type_file.chr20,    # External(Disk) file name #No.FUN-680107 VARCHAR(20)
        l_za05   LIKE za_file.za05        #No.FUN-680107 VARCHAR(40)
 DEFINE l_alg01  LIKE alg_file.alg01      #NO.FUN-7B0026
 DEFINE l_alg02  LIKE alg_file.alg02      #NO.FUN-7B0026
 DEFINE l_nnn01  LIKE nnn_file.nnn01      #NO.FUN-7B0026
 DEFINE l_nnn02  LIKE nnn_file.nnn02      #NO.FUN-7B0026
 DEFINE l_tsum1,l_tsum2,l_tsum3,l_tsum4  LIKE type_file.num20_6   #NO.FUN-7B0026
 DEFINE l_nnm18,l_nnm19  LIKE  nnm_file.nnm12       #NO.FUN-7B0026
 DEFINE l_sql    STRING                   #NO.FUN-7B0026  #MOD-B90217 mod char1000 -> STRING
 DEFINE l_wc     STRING                   #No.TQC-950167  #MOD-B90217 mod char1000 -> STRING
    CALL cl_del_data(l_table)                       #NO.FUN-7B0026
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang  #NO.FUN-7B0026
    SELECT zz05 INTO g_zz05 FROM  zz_file  WHERE  zz01='anmt730'  #NO.FUN-7B0026
 
    LET l_sql="SELECT * FROM nnm_file ",
              " WHERE ",g_wc CLIPPED
    PREPARE t730_p1 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    DECLARE t730_co CURSOR FOR t730_p1     
    FOREACH t730_co INTO g_nnm.*
        IF STATUS THEN CALL cl_err('fore t730_co:',STATUS,1) EXIT FOREACH END IF
    
        SELECT alg01,alg02 INTO l_alg01,l_alg02 FROM alg_file
         WHERE alg01 = g_nnm.nnm14   #MOD-8C0124
 
        IF g_nnm.nnm15='1' THEN
              SELECT nne06 INTO l_nnn01 FROM nne_file
               WHERE nne01 =g_nnm.nnm01
              SELECT nnn02 INTO l_nnn02 FROM nnn_file
               WHERE nnn01 = l_nnn01
              SELECT nne24+nne25+nne29+nne37+nne46 INTO l_tsum1 FROM nne_file   #MOD-BB0070 add nne46
               WHERE nne01=g_nnm.nnm01
              SELECT nng55+nng57+nng59+nng61 INTO l_tsum3 FROM nng_file
               WHERE nng01=g_nnm.nnm01
              SELECT sum(nnm17) INTO l_tsum2 FROM nnm_file
               WHERE nnm01=g_nnm.nnm01
                 AND nnm02<=g_nnm.nnm02 AND nnm03<=g_nnm.nnm03
              IF l_tsum1 IS NULL THEN LET l_tsum1=0 END IF
              IF l_tsum2 IS NULL THEN LET l_tsum2=0 END IF
              LET l_nnm18 = (l_tsum1 + l_tsum3) - l_tsum2
             #LET l_nnm19 = g_nnm.nnm12                            #MOD-C60200 mark
        
        ELSE
              SELECT nng24 INTO l_nnn01 FROM nng_file
               WHERE nng01 = g_nnm.nnm01
              SELECT nnn02 INTO l_nnn02 FROM nnn_file
               WHERE nnn01 = l_nnn01
             #------------MOD-C60200--------------------------mark
             #SELECT sum(nnm12) INTO l_tsum1 FROM nnm_file
             # WHERE nnm01 = g_nnm.nnm01
             #   AND nnm13 IS NULL
             #SELECT sum(nnj13) INTO l_tsum2 FROM nnj_file,nni_file
             # WHERE nni01=nnj01
             #   AND nnj03=g_nnm.nnm01
             #   AND nni02>g_tlday
             #   AND nnj06>=g_tlday
             #------------MOD-C60200--------------------------mark
              SELECT nng55+nng57+nng59+nng61 INTO l_tsum3 FROM nng_file
               WHERE nng01=g_nnm.nnm01
              SELECT sum(nnm17) INTO l_tsum4 FROM nnm_file
               WHERE nnm01=g_nnm.nnm01
                 AND nnm02<=g_nnm.nnm02 AND nnm03<=g_nnm.nnm03
             #IF l_tsum1 IS NULL THEN LET l_tsum1=0 END IF          #MOD-C60200 mark
             #IF l_tsum2 IS NULL THEN LET l_tsum2=0 END IF          #MOD-C60200 mark
              LET l_nnm18 = l_tsum3 - l_tsum4
             #LET l_nnm19 = l_tsum1 + l_tsum2                       #MOD-C60200 mark
         END IF
           LET l_nnm19 = g_nnm.nnm12                                #MOD-C60200 add 
           LET g_snnm18 = g_snnm18 + l_nnm18
           LET g_snnm19 = g_snnm19 + l_nnm19
 
        SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
            WHERE azi01=g_nnm.nnm09
        IF NOT cl_null(g_nnm.nnm13) THEN LET l_nnm19=0 END IF #MOD-970087
      EXECUTE insert_prep USING 
         g_nnm.nnm01,l_alg01,l_alg02,l_nnn02,g_nnm.nnm09,g_nnm.nnm02,g_nnm.nnm03,
         g_nnm.nnm05,g_nnm.nnm06,g_nnm.nnm07,g_nnm.nnm08,g_nnm.nnm10,g_nnm.nnm11,
         g_nnm.nnm12,g_nnm.nnm17,g_nnm.nnm13,l_nnm18,l_nnm19,g_nnm.nnm14,
        g_nnm.nnm15,t_azi04,t_azi07 
    END FOREACH
     LET g_sql1 ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED     #NO.FUN-7B0026
     IF  g_zz05='Y' THEN
          CALL cl_wcchp(g_wc,'nnm01,nnmconf,nnm02,nnm03,nnm04,nnm15,nnm14,
                              nnmglno,nnm13,nnm05,nnm06,nnm07,nnm08,nnm09,
                              nnm10,nnm11,nnm12,nnm17,nnmuser,nnmgrup,nnmmodu,
                              nnmdate')
#          RETURNING g_wc             #No.TQC-950167
           RETURNING l_wc             #No.TQC-950167
     END IF   
#     LET g_str1=g_wc,";",g_azi04     #No.TQC-950167
      LET g_str1=l_wc,";",g_azi04     #No.TQC-950167
     CALL cl_prt_cs3('anmt730','anmt730',g_sql1,g_str1)
 
 
END FUNCTION
FUNCTION t730_firm1()                         #No:8989 add
   DEFINE l_aa         LIKE type_file.dat     #NO.FUN-680107 DATE
   DEFINE p_trno       LIKE npp_file.npp01    #NO.FUN-680107 VARCHAR(20)   #MOD-790144
   DEFINE g_t1         LIKE oay_file.oayslip  #No.MOD-690103
   DEFINE l_npq07_t1   LIKE npq_file.npq07    #No.FUN-840102 add
   DEFINE l_npq07_t1_1 LIKE npq_file.npq07    #No.FUN-840102 add
   DEFINE l_nnn06      LIKE nnn_file.nnn06    #No.FUN-840102 add
   DEFINE l_nppcnt     LIKE type_file.num5    #No.MOD-740490
   DEFINE l_npqcnt     LIKE type_file.num5    #No.MOD-740490
   DEFINE l_forupd_sql STRING                 #No.FUN-840102
   DEFINE l_sql        STRING                 #No.FUN-840102
   DEFINE only_one     LIKE type_file.chr1    #No.FUN-840102
   DEFINE l_nnm        RECORD LIKE nnm_file.* #No.FUN-840102
   DEFINE l_nmy        RECORD LIKE nmy_file.* #No.FUN-840102
   DEFINE l_flag       LIKE type_file.chr1    #No.FUN-840102
   DEFINE l_bookno1    LIKE aza_file.aza81    #No.FUN-840102                                                                        
   DEFINE l_bookno2    LIKE aza_file.aza82    #No.FUN-840102
 
   SELECT * INTO g_nnm.* FROM nnm_file WHERE nnm01 = g_nnm.nnm01 AND nnm02 = g_nnm.nnm02 AND nnm03 = g_nnm.nnm03
  #-----------------FUN-D10116------mark
  #IF g_nnm.nnmconf='Y' THEN 
  ##  CALL cl_err('','9023',1)    #No.FUN-840102增加報錯訊息    #TQC-B10069
  #   CALL s_errmsg("nnm01",g_nnm.nnm01,"",'9023',1)            #TQC-B10069
  ##  RETURN       #TQC-B10069  
  #END IF
  #-----------------FUN-D10116------mark
   LET g_success='Y'
   
   BEGIN WORK
   
   LET only_one = '1'
 
   OPEN WINDOW t730_w1 AT 8,18 WITH FORM "anm/42f/anmt730_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("anmt730_1")
 
   LET only_one = '1'
   CALL cl_set_head_visible("","YES")
 
   INPUT BY NAME only_one WITHOUT DEFAULTS
   
      AFTER FIELD only_one
         IF NOT cl_null(only_one) THEN
            IF only_one NOT MATCHES "[12]" THEN
               NEXT FIELD only_one
            END IF
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
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      CLOSE WINDOW t730_w1
      RETURN
   END IF
   
   IF only_one = '1' THEN
      LET g_wc = " nnm01 = '",g_nnm.nnm01,"' "," AND ",
                 " nnm02 = '",g_nnm.nnm02,"' "," AND ",
                 " nnm03 = '",g_nnm.nnm03,"' "
   ELSE
      CALL cl_set_head_visible("","YES")
 
      CONSTRUCT BY NAME g_wc ON nnm01,nnm02,nnm03,nnm04,nnm15,nnm14
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nnm14)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_alg"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_nnm.nnm14
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnm14
                  NEXT FIELD nnm14
               OTHERWISE EXIT CASE
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
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         LET g_success = 'N'
         CLOSE WINDOW t730_w1
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('aap-222') THEN
      LET g_success = 'N'
      CLOSE WINDOW t730_w1
      RETURN
   END IF
   
   OPEN t730_cl USING g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
   IF STATUS THEN
   #  CALL cl_err("OPEN t730_cl:", STATUS, 1)     #TQC-B10069 
      CALL s_errmsg("nnm01",g_nnm.nnm01,"OPEN t730_cl:",STATUS,1)  #TQC-B10069
      LET g_success='N'                                            #TQC-B10069
      CLOSE t730_cl
      ROLLBACK WORK
      CLOSE WINDOW t730_w1       #No.FUN-840102 add 080429
      RETURN
   END IF
   
   FETCH t730_cl INTO g_nnm.*    #對DB鎖定
   IF STATUS THEN 
   #  CALL cl_err(g_nnm.nnm01,STATUS,0)               #TQC-B10069
      CALL s_errmsg("nnm01",g_nnm.nnm01,"",STATUS,1)  #TQC-B10069
      LET g_success='N'                               #TQC-B10069
      ROLLBACK WORK 
      CLOSE WINDOW t730_w1       #No.FUN-840102 add 080429
      RETURN 
   END IF
   
   LET l_forupd_sql = "SELECT * FROM nnm_file  WHERE nnm01 = ? ",
                      "   AND nnm02 = ? ",
                      "   AND nnm03 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE t730_firm1_cl CURSOR FROM l_forupd_sql
   
   LET l_sql = "SELECT * FROM nnm_file",
               " WHERE ",g_wc CLIPPED 
#              "   AND nnmconf = 'N' "   #No.TQC-A40115
   PREPARE t730_firm1_1 FROM l_sql
   DECLARE t730_confirm CURSOR WITH HOLD FOR t730_firm1_1
   
   INITIALIZE l_nnm.* TO NULL
  #CALL s_showmsg_init()      #TQC-B10069
   FOREACH t730_confirm INTO l_nnm.*
      IF STATUS THEN
         CALL s_errmsg('','','foreach',STATUS,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      
      IF g_success='N' THEN 
         LET g_totsuccess='N'
         LET g_success="Y"  
      END IF               
      
#No.CHI-A80036   ----BEGIN---
      IF l_nnm.nnmconf = 'Y' THEN
         CALL s_errmsg('','',l_nnm.nnm01,'9023',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
#No.CHI-A80036   ----END----
     #------------------FUN-D10116---------------(S)
      IF l_nnm.nnmconf = 'X' THEN
         CALL s_errmsg("nnm01",g_nnm.nnm01,"",'9024',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
     #------------------FUN-D10116---------------(E)

      OPEN t730_firm1_cl USING l_nnm.nnm01,l_nnm.nnm02,l_nnm.nnm03
      IF STATUS THEN
         CALL s_errmsg('','','OPEN t730_firm1_cl:',STATUS,1)
         CLOSE t730_firm1_cl
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
   
      FETCH t730_firm1_cl INTO l_nnm.*            #對DB鎖定
      IF STATUS THEN 
         CALL cl_err(l_nnm.nnm01,STATUS,0)
         LET g_showmsg = l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03
         CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,'OPEN t730_firm1_cl:',STATUS,1) 
         LET g_success = 'N' 
         CONTINUE FOREACH
      END IF
 
     #FUN-B50090 add begin-------------------------
     #重新抓取關帳日期
     SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
     #FUN-B50090 add -end--------------------------
     #-->年月不可小於關帳日期
      LET l_aa = s_monend (l_nnm.nnm02,l_nnm.nnm03)
      IF l_aa <= g_nmz.nmz10 THEN
         LET g_showmsg = l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03
         CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,'','aap-176',1) 
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
   
      LET p_trno = l_nnm.nnm01,l_nnm.nnm02 USING '&&&&',l_nnm.nnm03 USING '&#'
      SELECT COUNT(*) INTO l_nppcnt FROM npp_file where npp01 = p_trno
      SELECT COUNT(*) INTO l_npqcnt FROM npq_file where npq01 = p_trno
      IF cl_null(l_nppcnt) OR cl_null(l_npqcnt) OR l_nppcnt = 0 OR l_npqcnt = 0 THEN
         LET g_showmsg = l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03  #add
         CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,'','anm-322',1)  #add
         LET g_success = 'N'                                          #add
         CONTINUE FOREACH                                             #add
      END IF
 
      LET p_trno = l_nnm.nnm01,l_nnm.nnm02 USING '&&&&',l_nnm.nnm03 USING '&#'
      SELECT SUM(npq07) INTO l_npq07_t1 #No.FUN-840102 add       
        FROM npq_file
       WHERE npqsys = "NM" 
         AND npq00= 18
         AND npq01=p_trno  
         AND npq011= 0 
         AND npq06='1'
         AND npqtype='0'                #No.FUN-680088
         
      IF cl_null(l_nnm.nnm17) THEN LET l_nnm.nnm17 = 0 END IF    #No.TQC-9B0153
      IF l_nnm.nnm12 + l_nnm.nnm17 <> l_npq07_t1 THEN   #No.TQC-9B0153
         LET g_showmsg = l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03,"/",l_nnm.nnm12
         CALL s_errmsg('nnm01,nnm02,nnm03,nnm12',g_showmsg,'','aap-065',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      
      IF g_aza.aza63 = 'Y' THEN
         SELECT SUM(npq07) INTO l_npq07_t1_1 #No.FUN-840102 add
           FROM npq_file
          WHERE npqsys = "NM" 
            AND npq00= 18
            AND npq01=p_trno 
            AND npq011= 0 
            AND npq06='1'
            AND npqtype='1'                  #No.FUN-680088
         IF cl_null(l_nnm.nnm17) THEN LET l_nnm.nnm17 = 0 END IF    #No.TQC-9B0153
         IF l_nnm.nnm12 + l_nnm.nnm17 <> l_npq07_t1 THEN   #No.TQC-9B0153
            CALL cl_err("","aap-065",1)      #mark
            LET g_showmsg = l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03,"/",l_nnm.nnm12
            CALL s_errmsg('nnm01,nnm02,nnm03,nnm12',g_showmsg,'','aap-065',1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      END IF
 
 
      LET g_t1 = l_nnm.nnm01[1,g_doc_len]
      SELECT nmydmy3 INTO l_nmy.nmydmy3                #No.FUN-840102 add 
        FROM nmy_file 
       WHERE nmyslip = g_t1
       
      SELECT nnn06 INTO l_nnn06                        #No.FUN-840102 add
        FROM nnn_file 
       WHERE nnn01 IN
            (SELECT nne06 
               FROM nne_file 
              WHERE nne01 = l_nnm.nnm01)               #No.FUN-840102 add
         CALL s_get_bookno(l_nnm.nnm02) RETURNING l_flag,l_bookno1,l_bookno2
         CALL s_chknpq(p_trno,'NM',0,'0',g_bookno1)    #MOD-740290    #No.FUN-840102 mark   #MOD-860033 mark回復
         IF g_aza.aza63 ='Y' AND g_success ='Y' THEN
            CALL s_chknpq(p_trno,'NM',0,'1',l_bookno2) #No.FUN-840102 add
         END IF
 
      CALL s_get_doc_no(l_nnm.nnm01) RETURNING g_t1    #No.FUN-840102 add
      SELECT * INTO l_nmy.*                            #No.FUN-840102 add
       FROM nmy_file 
      WHERE nmyslip = g_t1
 
      IF l_nmy.nmyglcr = 'Y' THEN                      #No.FUN-840102 add                                                                                     
         SELECT COUNT(*) INTO g_cnt FROM npq_file                                                                                      
          WHERE npqsys = 'NM'
            AND npq00 = 18
            AND npq01 = p_trno
            AND npq011 = 0
         IF g_cnt =0 THEN                                                                                                              
            CALL t730_gen_glcr(l_nnm.*,l_nmy.*)        #No.FUN-840102 add
         END IF
                                                                                                                                 
         IF g_success = 'Y' THEN
            LET p_trno = l_nnm.nnm01,l_nnm.nnm02 USING '&&&&',l_nnm.nnm03 USING '&#'
            SELECT SUM(npq07) INTO l_npq07_t1          #No.FUN-840102 add
              FROM npq_file
             WHERE npqsys = "NM" 
               AND npq00= 18
               AND npq01=p_trno 
               AND npq011= 0 
               AND npq06='1'
               AND npqtype='0'                         #No.FUN-680088
            IF cl_null(l_nnm.nnm17) THEN LET l_nnm.nnm17 = 0 END IF    #No.TQC-9B0153
            IF l_nnm.nnm12 + l_nnm.nnm17 <> l_npq07_t1 THEN   #No.TQC-9B0153
               LET g_showmsg = l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03,"/",l_nnm.nnm12
               CALL s_errmsg('nnm01,nnm02,nnm03,nnm12',g_showmsg,'','aap-065',1)
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
            
            IF g_aza.aza63 = 'Y' THEN
               SELECT SUM(npq07) INTO l_npq07_t1       #No.FUN-840102 add            
                 FROM npq_file
                WHERE npqsys = "NM" 
                  AND npq00= 18
                  AND npq01=p_trno 
                  AND npq011= 0 
                  AND npq06='1'
                  AND npqtype='1'
               IF cl_null(l_nnm.nnm17) THEN LET l_nnm.nnm17 = 0 END IF    #No.TQC-9B0153
               IF l_nnm.nnm12 + l_nnm.nnm17 <> l_npq07_t1 THEN   #No.TQC-9B0153
                  LET g_showmsg = l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03,"/",l_nnm.nnm12
                  CALL s_errmsg('nnm01,nnm02,nnm03,nnm12',g_showmsg,'','aap-065',1)
                  LET g_success = 'N'
                  CONTINUE FOREACH
               END IF
            END IF
         END IF                                                                                                                        
      END IF                                                                                                                          
    
      IF g_success='N' THEN 
         CONTINUE FOREACH                 #No.FUN-840102 add
      END IF
 
      UPDATE nnm_file SET nnmconf = 'Y'   
       WHERE nnm01 = l_nnm.nnm01          #No.FUN-840102 add
         AND nnm02 = l_nnm.nnm02          #No.FUN-840102 add
         AND nnm03 = l_nnm.nnm03          #No.FUN-840102 add
 
 
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = l_nnm.nnm01,"/",l_nnm.nnm02,"/",l_nnm.nnm03,"/"
         CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,'',SQLCA.sqlcode,1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
   END FOREACH          
 
   IF g_totsuccess="N" THEN 
      LET g_success="N"   
   END IF                
      
  #CALL s_showmsg()           #TQC-B10069
   
      CLOSE WINDOW t730_w1       #No.TQC-9B0169
   
      IF g_success = 'Y' THEN
         LET g_nnm.nnmconf = 'Y'
         DISPLAY BY NAME g_nnm.nnmconf
         COMMIT WORK
      ELSE
         LET g_nnm.nnmconf = 'N'
         ROLLBACK WORK
      END IF   
      
      IF g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN                                                                  
         LET p_trno = g_nnm.nnm01,g_nnm.nnm02 USING '&&&&',g_nnm.nnm03 USING '&#'
         LET g_wc_gl = 'npp01 = "',p_trno,'" AND npp011 = 0'                                                                      
         LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nnm.nnm06,"' 'Y' '1' 'Y'"   #No.FUN-680088#FUN-860040
         CALL cl_cmdrun_wait(g_str)                                                                                                    
         SELECT nnmglno INTO g_nnm.nnmglno FROM nnm_file                                                                                   
          WHERE nnm01 = g_nnm.nnm01                                                                                                    
          DISPLAY BY NAME g_nnm.nnmglno                                                                                                 
         IF NOT cl_null(g_nnm.nnmglno) THEN
         #  CALL cl_err(g_nnm.nnmglno,"anm-710",0)                 #TQC-B10069
            CALL s_errmsg('nnm01',g_nnm.nnmglno,'','anm-710',1)    #TQC-B10069
            LET g_success='N'                                      #TQC-B10069  
         ELSE
         #  CALL cl_err("","anm-711",0)                            #TQC-B10069    
            CALL s_errmsg('nnm01',g_nnm.nnmglno,'','anm-711',1)    #TQC-B10069
            LET g_success='N'                                      #TQC-B10069    
         END IF
      END IF                                                                                                                           
     #CALL cl_set_field_pic(g_nnm.nnmconf,"","","","","")       #MOD-AC0073 #FUN-D10116 mark
      CALL cl_set_field_pic(g_nnm.nnmconf,"","","",g_void,"")   #FUN-D10116 add
END FUNCTION
 
FUNCTION t730_firm2()                      #No:8989 add
   DEFINE l_cnt     LIKE type_file.num10   #NO.FUN-680107 INTEGER
   DEFINE l_aa      LIKE type_file.dat     #NO.FUN-680107 DATE
   DEFINE l_aba19   LIKE aba_file.aba19    #No.FUN-670060
   DEFINE l_dbs     STRING                 #No.FUN-670060
   DEFINE l_sql     STRING
 
   SELECT * INTO g_nnm.* FROM nnm_file WHERE nnm01 = g_nnm.nnm01 AND nnm02 = g_nnm.nnm02 AND nnm03 = g_nnm.nnm03
   IF g_nnm.nnmconf='N' THEN RETURN END IF
  #----------------FUN-D10116-------------(S)
   IF g_nnm.nnmconf = 'X' THEN
      CALL cl_err(g_nnm.nnm01,'9024',0)
      RETURN
   END IF
  #----------------FUN-D10116-------------(E)
   LET l_aa = s_monend (g_nnm.nnm02,g_nnm.nnm03)
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
   #FUN-B50090 add -end--------------------------
   IF l_aa <= g_nmz.nmz10 THEN
      CALL cl_err(g_nnm.nnm01,'aap-176',1) RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原 
   CALL s_get_doc_no(g_nnm.nnm01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nnm.nnmglno) THEN
      IF g_nmy.nmyglcr != 'Y' THEN
         CALL cl_err(g_nnm.nnm01,'axr-370',0) RETURN 
      END IF 
   END IF 
   IF g_nmy.nmyglcr = 'Y' THEN                                                                              
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nnm.nnmglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nnm.nnmglno,'axr-071',1)
         RETURN                                                                                                                     
      END IF                                                                                                                        
   END IF                                                                                                                           
   LET g_success='Y'

   #CHI-C90052 add begin---
   IF g_nmy.nmyglcr = 'Y' AND g_nmy.nmydmy3 = 'Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nnm.nnmglno,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT nnmglno INTO g_nnm.nnmglno FROM nnm_file
       WHERE nnm01 = g_nnm.nnm01
      IF NOT cl_null(g_nnm.nnmglno) THEN
         CALL cl_err(g_nnm.nnmglno,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_nnm.nnmglno
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
   OPEN t730_cl USING g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
   IF STATUS THEN
      CALL cl_err("OPEN t730_cl:", STATUS, 1)
      CLOSE t730_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t730_cl INTO g_nnm.*               # 對DB鎖定
   IF STATUS THEN CALL cl_err(g_nnm.nnm01,STATUS,0) ROLLBACK WORK RETURN END IF
   IF g_success='N' THEN ROLLBACK WORK RETURN END IF
   UPDATE nnm_file SET nnmconf = 'N' WHERE nnm01 = g_nnm.nnm01 AND nnm02 = g_nnm.nnm02 AND nnm03 = g_nnm.nnm03
   IF g_success='Y'
      THEN COMMIT WORK LET g_nnm.nnmconf ='N' DISPLAY BY NAME  g_nnm.nnmconf
      ELSE ROLLBACK WORK
   END IF

   #CHI-C90052 mark begin---
   #IF g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN 
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nnm.nnmglno,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str) 
   #   SELECT nnmglno INTO g_nnm.nnmglno FROM nnm_file 
   #    WHERE nnm01 = g_nnm.nnm01
   #   DISPLAY BY NAME g_nnm.nnmglno
   #END IF 
   #CHI-C90052 mark end-----
END FUNCTION
 
FUNCTION t730_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nnm01,nnm02,nnm03",TRUE)
   END IF
   IF INFIELD(nnm04) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nnm15",TRUE)
   END IF
   CALL cl_set_comp_entry("nnm04,nnm15",TRUE)
END FUNCTION
 
FUNCTION t730_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nnm01,nnm02,nnm03",FALSE)
   END IF
   IF INFIELD(nnm04) OR (NOT g_before_input_done) THEN
      IF g_nnm.nnm04 = '2' THEN
         CALL cl_set_comp_entry("nnm15",FALSE)
      END IF
   END IF
   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("nnm04,nnm15",FALSE)
   END IF
END FUNCTION
FUNCTION t730_nnm11()
  DEFINE l_nne12 LIKE nne_file.nne12,
         l_nne27 LIKE nne_file.nne27,
         l_nnl12 LIKE nnl_file.nnl12,
         l_nng20 LIKE nng_file.nng20,
         l_nng21 LIKE nng_file.nng21
 
 #IF g_nnm.nnm09 = g_aza.aza17                         #CHI-A10014 mark
  IF g_aza.aza26 = '0' AND g_nnm.nnm09 = g_aza.aza17   #CHI-A10014 add
     THEN LET g_i=365    # 本幣一年採365天
     ELSE LET g_i=360    # 外幣一年採360天
  END IF
  IF g_nnm.nnm04 = '1' THEN     #融資
         SELECT nne12,nne27 INTO l_nne12,l_nne27 FROM nne_file
             WHERE nne01=g_nnm.nnm01 AND nneconf <> 'X'
         SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
          WHERE nnl01=nnk01 AND nnl03='1' AND nnl04=g_nnm.nnm01
            AND nnk02 > g_nnm.nnm06 AND nnkconf='Y'
         IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
         LET l_nne27 = l_nne27 - l_nnl12    #已還金額
         IF cl_null(l_nne27) THEN LET l_nne27=0 END IF
         #-- 原幣利息=(貸款金額-已還金額)*(利率*/100/g_i)*天數 ------
         LET g_nnm.nnm11=(l_nne12-l_nne27)*(g_nnm.nnm08/100/g_i)
                         *g_nnm.nnm07
     CALL cl_digcut(g_nnm.nnm11,t_azi04) RETURNING g_nnm.nnm11
     #-- 本幣利息=原幣利息*Ex.Rate
     LET g_nnm.nnm12 = g_nnm.nnm11 * g_nnm.nnm10
     CALL cl_digcut(g_nnm.nnm12,g_azi04) RETURNING g_nnm.nnm12
  ELSE                          #中長貸
     SELECT nng20,nng21 INTO l_nng20,l_nng21 FROM nng_file
             WHERE nng01=g_nnm.nnm01 AND nngconf <> 'X'
      SELECT SUM(nnl12/nnk23) INTO l_nnl12 FROM nnl_file,nnk_file
         WHERE nnl01=nnk01 AND nnl03='2' AND nnl04=g_nnm.nnm01
           AND nnk02 > g_nnm.nnm06 AND nnkconf='Y'
      IF cl_null(l_nnl12) THEN LET l_nnl12=0 END IF
      LET l_nng21 = l_nng21 - l_nnl12   #已還金額
      IF cl_null(l_nng21) THEN LET l_nng21=0 END IF
       #-- 原幣利息=(貸款金額-已還金額)*(利率*/100/g_i)*天數 ------
       LET g_nnm.nnm11 =(l_nng20-l_nng21) * (g_nnm.nnm08/100/g_i)
                        * g_nnm.nnm07
     CALL cl_digcut(g_nnm.nnm11,t_azi04) RETURNING g_nnm.nnm11
     #-- 本幣利息=原幣利息*Ex.Rate
     LET g_nnm.nnm12 = g_nnm.nnm11 * g_nnm.nnm10
     CALL cl_digcut(g_nnm.nnm12,g_azi04) RETURNING g_nnm.nnm12
   END IF
   DISPLAY BY NAME g_nnm.nnm11,g_nnm.nnm12
END FUNCTION
 
#產生分錄底稿
FUNCTION t730_s()
  DEFINE l_wc      STRING   #No.FUN-680107 VARCHAR(200) #MOD-B90217 mod char1000 -> STRING
  DEFINE l_nnm     RECORD LIKE nnm_file.*
  DEFINE only_one  LIKE type_file.chr1      #NO.FUN-680107 VARCHAR(1)
  DEFINE l_t1      LIKE oay_file.oayslip    #NO.FUN-680107 VARCHAR(5)   
  DEFINE l_cnt     LIKE type_file.num5      #No.FUN-680107 SMALLINT
  DEFINE l_nmydmy3 LIKE type_file.chr1      #NO.FUN-680107 VARCHAR(1)
  DEFINE p_trno    LIKE npp_file.npp01     #NO.FUN-680107 VARCHAR(20)   #MOD-790144
 
 
  BEGIN WORK
  OPEN t730_cl USING g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03
  IF STATUS THEN
     CALL cl_err("OPEN t730_cl:", STATUS, 1)
     CLOSE t730_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  IF g_nnm.nnmconf = 'Y' THEN
     CALL cl_err('','anm-232',1)
     RETURN
  END IF
 
 #----------------FUN-D10116-------------(S)
  IF g_nnm.nnmconf = 'X' THEN
     CALL cl_err(g_nnm.nnm01,'9024',0)
     RETURN
  END IF
 #----------------FUN-D10116-------------(E)

  FETCH t730_cl INTO g_nnm.*
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_nnm.nnm01,SQLCA.sqlcode,0)
     CLOSE t730_cl 
     ROLLBACK WORK 
     RETURN 
  ELSE 
     COMMIT WORK
  END IF
 
 
  OPEN WINDOW t730_w3 AT 4,11
          WITH FORM "anm/42f/anmt7303"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("anmt7303")
 
 
  LET only_one = '1'
  INPUT BY NAME only_one WITHOUT DEFAULTS
    AFTER FIELD only_one
      IF only_one IS NULL THEN 
         NEXT FIELD only_one 
      END IF
      IF only_one NOT MATCHES "[12]" THEN 
         NEXT FIELD only_one 
      END IF
  
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about
       CALL cl_about()
 
    ON ACTION help
       CALL cl_show_help()
 
    ON ACTION controlp
       CALL cl_cmdask()
  END INPUT 
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW t730_w3
     RETURN
  END IF  
 
  IF only_one = '1' THEN
     IF g_nnm.nnmconf = 'X' THEN
        CALL cl_err('','9024',0) 
        CLOSE WINDOW t730_w2 
        RETURN
     END IF
     LET l_wc = "     nnm01 = '",g_nnm.nnm01,"'",
                " AND nnm02 ='",g_nnm.nnm02,"'",
                " AND nnm03 ='",g_nnm.nnm03,"'"
                
  ELSE
     CONSTRUCT BY NAME l_wc ON nnm01,nnm05,nnm06
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
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
 
     IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW t730_w3
        RETURN
     END IF
  END IF
  CLOSE WINDOW t730_w3
 
  LET l_nnm.* = g_nnm.*   # backup old value
  MESSAGE "WORKING !"
 
  LET g_sql = "SELECT * FROM nnm_file ",
              " WHERE nnmconf <> 'X' AND ",l_wc CLIPPED, " ORDER BY nnm01"
  PREPARE t730_v_p FROM g_sql
  DECLARE t730_v_c CURSOR WITH HOLD FOR t730_v_p
  LET g_success='Y' 
  BEGIN WORK 
  CALL s_showmsg_init()
  FOREACH t730_v_c INTO g_nnm.*
     IF g_success='N' THEN                                                                                                         
        LET g_totsuccess='N'                                                                                                       
        LET g_success="Y"                                                                                                          
     END IF                                                                                                                        
 
     IF STATUS THEN 
        LET g_success='N'               #FUN-8A0086 
        EXIT FOREACH 
     END IF
 
     IF g_nnm.nnmconf='Y' THEN
        CALL cl_getmsg('anm-232',g_lang) RETURNING g_msg
        MESSAGE g_nnm.nnm01,g_msg
        sleep 1
        CONTINUE FOREACH
     END IF
 
     LET l_t1 = s_get_doc_no(g_nnm.nnm01)
 
        IF NOT cl_null(g_nnm.nnmglno) THEN
           CALL cl_getmsg('aap-122',g_lang) RETURNING g_msg
           MESSAGE g_nnm.nnm01,g_msg
           sleep 1
           CONTINUE FOREACH
        END IF
        LET p_trno=g_nnm.nnm01,g_nnm.nnm02 USING '&&&&',g_nnm.nnm03 USING '&#'
        CALL t730_v(p_trno,'0')
        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           CALL t730_v(p_trno,'1')
        END IF
  END FOREACH
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
 
  CALL s_showmsg() #No.FUN-710024
  IF g_success='Y' THEN 
     COMMIT WORK 
  ELSE 
     ROLLBACK WORK 
  END IF 
 
  LET g_nnm.*=l_nnm.*
  MESSAGE " "
    
END FUNCTION 
 
#產生分錄底稿
FUNCTION t730_s1(p_nnm)
  DEFINE l_wc      STRING     #NO.FUN-910082
  DEFINE p_nnm     RECORD LIKE nnm_file.*
  DEFINE l_t1      LIKE oay_file.oayslip
  DEFINE l_cnt     LIKE type_file.num5
  DEFINE l_nmydmy3 LIKE type_file.chr1
  DEFINE l_trno    LIKE npp_file.npp01
  
  LET l_t1 = s_get_doc_no(p_nnm.nnm01)
 
     IF NOT cl_null(p_nnm.nnmglno) THEN
        CALL cl_getmsg('aap-122',g_lang) RETURNING g_msg
        CALL s_errmsg('nnm01',p_nnm.nnm01,'',g_msg,0)
     END IF
 
     LET l_trno = p_nnm.nnm01,p_nnm.nnm02 USING '&&&&',p_nnm.nnm03 USING '&#'
     CALL t730_v1(l_trno,p_nnm.*,'0')
     IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
        CALL t730_v1(l_trno,p_nnm.*,'1')
     END IF
    
END FUNCTION 
 
FUNCTION t730_v(p_trno,p_npptype)   #No.FUN-680088
   DEFINE p_npptype   LIKE npp_file.npptype    #No.FUN-680088
   DEFINE l_n         LIKE type_file.num10,    #No.FUN-680107 INTEGER
          p_trno      LIKE npp_file.npp01,    #NO.FUN-680107 VARCHAR(20)   #MOD-790144
          l_buf       LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(70)
          l_nmq       RECORD LIKE nmq_file.*,
          g_npp       RECORD LIKE npp_file.*,
          g_npq       RECORD LIKE npq_file.*,
          l_aag05     LIKE aag_file.aag05
   DEFINE l_aaa03     LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE l_azi04_2   LIKE azi_file.azi04    #FUN-A40067
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
                                                                                   
   CALL s_get_bookno(g_nnm.nnm02) RETURNING g_flag,g_bookno1,g_bookno2                                       
   IF g_flag =  '1' THEN  #抓不到帳別                                                                                       
      CALL cl_err(g_nnm.nnm02,'aoo-081',1)                                                                                  
   END IF                                                                                                                   

  #No.FUN-D40118 ---Add--- Start
   IF p_npptype = '1' THEN
      LET g_bookno3 = g_bookno2
   ELSE
      LET g_bookno3 = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End

   SELECT * INTO g_nnm.* FROM nnm_file
   WHERE nnm01 = g_nnm.nnm01 AND nnm02=g_nnm.nnm02 AND nnm03=g_nnm.nnm03
   IF p_trno IS NULL THEN RETURN END IF
   IF g_nnm.nnmconf='Y' THEN CALL cl_err(g_nnm.nnm01,'anm-232',0) RETURN END IF
   IF NOT cl_null(g_nnm.nnmglno) THEN
      CALL s_errmsg('','',g_nnm.nnm01,'aap-122',0) RETURN   #No.FUN-710024
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
   #FUN-B50090 add -end--------------------------
   #-->起算日期不可小於關帳日期
    IF g_nnm.nnm05 <= g_nmz.nmz10 AND g_nmz.nmz52 = 'N' THEN  #MOD-950209
      CALL s_errmsg('','',g_nnm.nnm01,'aap-176',0) RETURN   #No.FUN-710024
   END IF
   #-->止算日期不可小於關帳日期
   IF g_nnm.nnm06 <= g_nmz.nmz10 THEN
      CALL s_errmsg('','',g_nnm.nnm01,'aap-176',0) RETURN   #No.FUN-710024
   END IF
   #單號每月相同,所以要加上年月
   #--判斷是否已有分錄底稿
   IF p_npptype = '0' THEN  #No.FUN-680088
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys='NM' AND npq00=18 AND npq01=p_trno AND npq011=0
      IF l_n > 0 THEN
         CALL cl_getmsg('axm-056',g_lang) RETURNING g_msg
         LET l_buf = '(',p_trno CLIPPED,')',"\n",g_msg  #加單號會太長會當掉
         WHILE TRUE
            PROMPT l_buf CLIPPED FOR CHAR g_chr
            IF g_chr MATCHES "[12]" THEN EXIT WHILE END IF
         END WHILE
         IF g_chr = '1' THEN RETURN END IF
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=18 AND npq01=p_trno AND npq011=0
         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = p_trno
         #FUN-B40056--add--end--
      END IF
   END IF   #No.FUN-680088
   INITIALIZE g_npp.* TO NULL
#FUN-A40067 --Begin
   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = g_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03
#FUN-A40067 --End
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =18
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=0
   LET g_npp.npp02 =g_nnm.nnm06
   LET g_npp.npptype = p_npptype   #No.FUN-680088
 
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
      UPDATE npp_file SET npp02=g_npp.npp02
          WHERE nppsys='NM' AND npp00=18 AND npp01=p_trno AND npp011=0
            AND npptype = p_npptype  #No.FUN-680088
      IF SQLCA.SQLCODE THEN 
         LET g_showmsg = 'NM',"/",18,"/",p_trno,"/",0,"/",p_npptype       #No.FUN-710024
         CALL s_errmsg('nppsys,npp00,npp011,npptype',g_showmsg,'upd npp:',STATUS,0) #No.FUN-710024
         RETURN END IF
   END IF
   IF SQLCA.SQLCODE THEN 
      LET g_showmsg = g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00  #No.FUN-710024
      CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp:',STATUS,0)       #No.FUN-710024
      RETURN END IF
   #--單身
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npqtype = p_npptype   #No.FUN-680088
   SELECT * INTO l_nmq.* FROM nmq_file
   IF g_nnm.nnm12<>0 THEN
      #---------------------利息費用------------------------------#
      #分錄底稿單身檔 借:利息費用
         LET g_npq.npq02 = 1             #項次
         LET g_npq.npq04 = NULL                        #MOD-BA0015 
         LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
         LET g_npq.npq07 = g_nnm.nnm12   #本幣金額
         LET g_npq.npq07f= g_nnm.nnm11   #原幣金額
 
         LET g_npq.npq24 = g_nnm.nnm09   #原幣幣別
         LET g_npq.npq25 = g_nnm.nnm10   #匯率
         LET g_npq25     = g_npq.npq25   #No.FUN-9A0036
         IF p_npptype = '0' THEN
            LET g_npq.npq03 = l_nmq.nmq01   #利息科目
         ELSE
            LET g_npq.npq03 = l_nmq.nmq011  #利息科目
         END IF
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                   AND aag00=g_bookno1      #No.FUN-740028
         IF l_aag05='N' THEN
            LET g_npq.npq05 = ''
         ELSE
            IF g_nnm.nnm15='1' THEN
               SELECT nne44 INTO g_npq.npq05 FROM nne_file
                WHERE nne01=g_nnm.nnm01
            ELSE
               LET g_npq.npq05=g_nnm.nnmgrup    #長貸沒打部門取不到
            END IF
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03,g_bookno1)   #No.FUN-740028
              RETURNING  g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
         LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00   #No.FUN-710024
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_1:',STATUS,1) #No.FUN-710024
            LET g_success='N'
         END IF
      #--貸方:--------------應付利息------------------------------#
         LET g_npq.npq02 = g_npq.npq02+1
         IF p_npptype = '0' THEN
            LET g_npq.npq03 = l_nmq.nmq10
         ELSE
            LET g_npq.npq03 = l_nmq.nmq101
         END IF
         LET g_npq.npq04 = NULL                        #MOD-BA0015 
         LET g_npq.npq06 = '2'
         LET g_npq.npq07 = g_nnm.nnm12
         LET g_npq.npq07f= g_nnm.nnm11
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                   AND aag00=g_bookno1     #No.FUN-740028
         IF l_aag05='N' THEN
            LET g_npq.npq05 = ''
         ELSE
            IF g_nnm.nnm15='1' THEN
               SELECT nne44 INTO g_npq.npq05 FROM nne_file
                WHERE nne01=g_nnm.nnm01
            ELSE
               LET g_npq.npq05=g_nnm.nnmgrup    #長貸沒打部門取不到
            END IF
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03,g_bookno1)  #No.FUN-740028
              RETURNING  g_npq.*
           
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
 
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         LET g_npq.npqlegal= g_legal
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00    #No.FUN-710024
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_c1:',STATUS,1) #No.FUN-710024
            LET g_success='N' END IF
   END IF
   IF g_nnm.nnm17<>0 THEN
      #---------------------其他費用------------------------------#
      #分錄底稿單身檔 借:其他費用
         IF cl_null(g_npq.npq02) THEN LET g_npq.npq02=0 END IF
         LET g_npq.npq02 = g_npq.npq02+1 #項次
         IF p_npptype = '0' THEN
            LET g_npq.npq03 = l_nmq.nmq02   #其他費用
         ELSE
            LET g_npq.npq03 = l_nmq.nmq021  #其他費用
         END IF
         LET g_npq.npq04 = NULL                        #MOD-BA0015 
         LET g_npq.npq06 = '1'           #借貸別 (1.借 2.貸)
         LET g_npq.npq07 = g_nnm.nnm17   #本幣金額
         SELECT azi04 INTO t_azi04 FROM azi_file                             #NO.CHI-6A0004
          WHERE azi01=g_nnm.nnm09
         LET g_npq.npq07f= cl_digcut(g_nnm.nnm17/g_nnm.nnm10,t_azi04)   #原幣金額 #NO.CHI-6A0004
         LET g_npq.npq24 = g_nnm.nnm09   #原幣幣別
         LET g_npq.npq25 = g_nnm.nnm10   #匯率
         LET g_npq25     = g_npq.npq25   #No.FUN-9A0036
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                   AND aag00=g_bookno1    #No.FUN-740028
         IF l_aag05='N' THEN
            LET g_npq.npq05 = ''
         ELSE
            IF g_nnm.nnm15='1' THEN
               SELECT nne44 INTO g_npq.npq05 FROM nne_file
                WHERE nne01=g_nnm.nnm01
            ELSE
               LET g_npq.npq05=g_nnm.nnmgrup    #長貸沒打部門取不到
            END IF
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_nnm.nnm01,g_nnm.nnm02,g_nnm.nnm03,g_bookno1)   #No.FUN-740028  
              RETURNING  g_npq.*
                
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
         LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00    #No.FUN-710024
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_1:',STATUS,1) #No.FUN-710024
            LET g_success='N'
         END IF
      #--貸方:--------------預付利息------------------------------#
         LET g_npq.npq02 = g_npq.npq02+1
         IF p_npptype = '0' THEN
            LET g_npq.npq03 = l_nmq.nmq11
         ELSE
            LET g_npq.npq03 = l_nmq.nmq111
         END IF
         LET g_npq.npq04 = NULL                        #MOD-BA0015 
         LET g_npq.npq06 = '2'
         LET g_npq.npq07 = g_nnm.nnm17   #本幣金額
         SELECT azi04 INTO t_azi04 FROM azi_file     #NO.CHI-6A0004
          WHERE azi01=g_nnm.nnm09
         LET g_npq.npq07f= cl_digcut(g_nnm.nnm17/g_nnm.nnm10,t_azi04)#原幣金額  #NO.CHI-6A0004
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                   AND aag00=g_bookno1     #No.FUN-740028
         IF l_aag05='N' THEN
            LET g_npq.npq05 = ''
         ELSE
            IF g_nnm.nnm15='1' THEN
               SELECT nne44 INTO g_npq.npq05 FROM nne_file
                WHERE nne01=g_nnm.nnm01
            ELSE
               LET g_npq.npq05=g_nnm.nnmgrup    #長貸沒打部門取不到
            END IF
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_nnm.nnm02,g_nnm.nnm03,g_bookno1)   #No.FUN-740028
              RETURNING  g_npq.*
         
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
         LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00    #No.FUN-710024
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_c1:',STATUS,1) #No.FUN-710024
            LET g_success='N' END IF
     END IF
     CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021 
   #--產生完成
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED

   LET g_npp1.* = g_npp.*   #FUN-A40033
END FUNCTION
 
FUNCTION t730_v1(p_trno,p_nnm,p_npptype)
   DEFINE p_npptype   LIKE npp_file.npptype
   DEFINE p_nnm       RECORD LIKE nnm_file.*
   DEFINE l_n         LIKE type_file.num10
   DEFINE p_trno      LIKE npp_file.npp01
   DEFINE l_buf       LIKE type_file.chr1000
   DEFINE l_nmq       RECORD LIKE nmq_file.*
   DEFINE g_npp       RECORD LIKE npp_file.*
   DEFINE g_npq       RECORD LIKE npq_file.*
   DEFINE l_aag05     LIKE aag_file.aag05
   DEFINE l_flag       LIKE type_file.chr1
   DEFINE l_bookno1    LIKE aza_file.aza81                                                             
   DEFINE l_bookno2    LIKE aza_file.aza82                                                                                     
   DEFINE l_aaa03     LIKE aaa_file.aaa03 #FUN-A40067                           
   DEFINE l_azi04_2   LIKE azi_file.azi04 #FUN-A40067
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
                                                                                   
   CALL s_get_bookno(p_nnm.nnm02) RETURNING l_flag,l_bookno1,l_bookno2                                       
   IF l_flag =  '1' THEN          #抓不到帳別                                                                                       
      CALL s_errmsg('nnm02',p_nnm.nnm02,'','aoo-081',1)                                                                                 
   END IF                                                                                                                   
 
  #No.FUN-D40118 ---Add--- Start
   IF p_npptype = '1' THEN
      LET g_bookno3 = g_bookno2
   ELSE
      LET g_bookno3 = g_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End
 
   IF p_trno IS NULL THEN 
      RETURN 
   END IF
   IF p_nnm.nnmconf = 'Y' THEN
      LET g_showmsg = p_nnm.nnm01,"/",p_nnm.nnm02,"/",p_nnm.nnm03 
      CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,'','anm-232',1) 
      RETURN 
   END IF
   
   IF NOT cl_null(p_nnm.nnmglno) THEN
      LET g_showmsg = p_nnm.nnm01,"/",p_nnm.nnm02,"/",p_nnm.nnm03 
      CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,'','aap-122',0)
      RETURN
   END IF
 
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
   #FUN-B50090 add -end--------------------------
   #-->起算日期不可小於關帳日期
   IF p_nnm.nnm05 <= g_nmz.nmz10 THEN
      LET g_showmsg = p_nnm.nnm01,"/",p_nnm.nnm02,"/",p_nnm.nnm03,"/",p_nnm.nnm05 
      CALL s_errmsg('nnm01,nnm02,nnm03,nnm05',g_showmsg,'','aap-176',0) 
      RETURN
   END IF
 
   #-->止算日期不可小於關帳日期
   IF p_nnm.nnm06 <= g_nmz.nmz10 THEN
      LET g_showmsg = p_nnm.nnm01,"/",p_nnm.nnm02,"/",p_nnm.nnm03,"/",p_nnm.nnm06 
      CALL s_errmsg('nnm01,nnm02,nnm03,nnm06',g_showmsg,'','aap-176',0) 
      RETURN
   END IF
 
   #--判斷是否已有分錄底稿
   IF p_npptype = '0' THEN
      SELECT COUNT(*) INTO l_n 
        FROM npq_file
       WHERE npqsys = 'NM' 
         AND npq00 = 18 
         AND npq01 = p_trno 
         AND npq011 = 0
      IF l_n > 0 THEN
         LET g_showmsg = p_nnm.nnm01,"/",p_nnm.nnm02,"/",p_nnm.nnm03
         CALL s_errmsg('nnm01,nnm02,nnm03',g_showmsg,'','anm-189',1)
         RETURN 
      END IF
   END IF
   
   INITIALIZE g_npp.* TO NULL

#FUN-A40067 --Begin
   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = l_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03
#FUN-A40067 --End

   LET g_npp.nppsys = 'NM'
   LET g_npp.npp00 = 18
   LET g_npp.npp01 = p_trno
   LET g_npp.npp011= 0
   LET g_npp.npp02 = p_nnm.nnm06
   LET g_npp.npptype = p_npptype
   
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
      UPDATE npp_file SET npp02=g_npp.npp02
       WHERE nppsys = 'NM' 
         AND npp00 = 18 
         AND npp01 = p_trno
         AND npp011 = 0
         AND npptype = p_npptype
      IF SQLCA.SQLCODE THEN 
         LET g_showmsg = 'NM',"/",18,"/",p_trno,"/",0,"/",p_npptype
         CALL s_errmsg('nppsys,npp00,npp011,npptype',g_showmsg,'upd npp:',STATUS,0)
         RETURN END IF
   END IF
   IF SQLCA.SQLCODE THEN 
      LET g_showmsg = g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00
      CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp:',STATUS,0)
      RETURN 
   END IF
   #--單身
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npqtype = p_npptype
   
   SELECT * INTO l_nmq.* FROM nmq_file
 
   IF p_nnm.nnm12 <> 0 THEN
      #---------------------利息費用------------------------------#
      #分錄底稿單身檔 借:利息費用
      LET g_npq.npq02 = 1                      #項次
      LET g_npq.npq04 = NULL                        #MOD-BA0015 
      LET g_npq.npq06 = '1'                    #借貸別 (1.借 2.貸)
      LET g_npq.npq07 = p_nnm.nnm12            #本幣金額
      LET g_npq.npq07f= p_nnm.nnm11            #原幣金額
 
      LET g_npq.npq24 = p_nnm.nnm09            #原幣幣別
      LET g_npq.npq25 = p_nnm.nnm10            #匯率
      LET g_npq25     = g_npq.npq25            #No.FUN-9A0036
 
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = l_nmq.nmq01         #利息科目
      ELSE
         LET g_npq.npq03 = l_nmq.nmq011        #利息科目
      END IF
 
      SELECT aag05 INTO l_aag05 
        FROM aag_file 
       WHERE aag01 = g_npq.npq03
         AND aag00 = l_bookno1
         
      IF l_aag05='N' THEN
         LET g_npq.npq05 = ''
      ELSE
         IF p_nnm.nnm15='1' THEN
            SELECT nne44 INTO g_npq.npq05 
              FROM nne_file
             WHERE nne01 = p_nnm.nnm01
         ELSE
            LET g_npq.npq05 = p_nnm.nnmgrup    #長貸沒打部門取不到
         END IF
      END IF
 
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,p_nnm.nnm01,p_nnm.nnm02,p_nnm.nnm03,l_bookno1)
           RETURNING  g_npq.*
      
      CALL s_def_npq31_npq34(g_npq.*,l_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN
         LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00
         CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_1:',STATUS,1)
         LET g_success='N'
      END IF
      
      #--貸方:--------------應付利息------------------------------#
      LET g_npq.npq02 = g_npq.npq02 + 1
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = l_nmq.nmq10
      ELSE
         LET g_npq.npq03 = l_nmq.nmq101
      END IF
 
      LET g_npq.npq04 = NULL                        #MOD-BA0015 
      LET g_npq.npq06 = '2'
      LET g_npq.npq07 = p_nnm.nnm12
      LET g_npq.npq07f= p_nnm.nnm11
      
      SELECT aag05 INTO l_aag05 
        FROM aag_file
       WHERE aag01 = g_npq.npq03
         AND aag00 = l_bookno1
         
      IF l_aag05='N' THEN
         LET g_npq.npq05 = ''
      ELSE
         IF p_nnm.nnm15 = '1' THEN
            SELECT nne44 INTO g_npq.npq05 
             FROM nne_file
             WHERE nne01 = p_nnm.nnm01
         ELSE
            LET g_npq.npq05 = p_nnm.nnmgrup    #長貸沒打部門取不到
         END IF
      END IF
      
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,p_nnm.nnm01,p_nnm.nnm02,p_nnm.nnm03,l_bookno1)
           RETURNING  g_npq.*
       
      CALL s_def_npq31_npq34(g_npq.*,l_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN 
         LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00
         CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_c1:',STATUS,1)
         LET g_success='N' 
      END IF
   END IF
   
   IF p_nnm.nnm17 <> 0 THEN
      #---------------------其他費用------------------------------#
      #分錄底稿單身檔 借:其他費用
      IF cl_null(g_npq.npq02) THEN 
         LET g_npq.npq02 = 0 
      END IF
      
      LET g_npq.npq02 = g_npq.npq02+1          #項次
 
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = l_nmq.nmq02         #其他費用
      ELSE
         LET g_npq.npq03 = l_nmq.nmq021        #其他費用
      END IF
 
      LET g_npq.npq04 = NULL                        #MOD-BA0015 
      LET g_npq.npq06 = '1'                    #借貸別 (1.借 2.貸)
      LET g_npq.npq07 = p_nnm.nnm17            #本幣金額
      
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01 = p_nnm.nnm09
       
      LET g_npq.npq07f= cl_digcut(p_nnm.nnm17/p_nnm.nnm10,t_azi04)    #原幣金額
      LET g_npq.npq24 = p_nnm.nnm09            #原幣幣別
      LET g_npq.npq25 = p_nnm.nnm10            #匯率
      LET g_npq25     = g_npq.npq25            #No.FUN-9A0036

 
      SELECT aag05 INTO l_aag05 
        FROM aag_file 
       WHERE aag01 = g_npq.npq03
         AND aag00 = l_bookno1
         
      IF l_aag05='N' THEN
         LET g_npq.npq05 = ''
      ELSE
         IF p_nnm.nnm15='1' THEN
            SELECT nne44 INTO g_npq.npq05 
              FROM nne_file
             WHERE nne01 = p_nnm.nnm01
         ELSE
            LET g_npq.npq05 = p_nnm.nnmgrup    #長貸沒打部門取不到
         END IF
      END IF
 
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,p_nnm.nnm01,p_nnm.nnm02,p_nnm.nnm03,l_bookno1)
           RETURNING  g_npq.*
        
      CALL s_def_npq31_npq34(g_npq.*,l_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN
         LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00
         CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_1:',STATUS,1)
         LET g_success='N'
      END IF
         
      #--貸方:--------------預付利息------------------------------#
      LET g_npq.npq02 = g_npq.npq02+1
 
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = l_nmq.nmq11
      ELSE
         LET g_npq.npq03 = l_nmq.nmq111
      END IF
 
      LET g_npq.npq04 = NULL                        #MOD-BA0015 
      LET g_npq.npq06 = '2'
      LET g_npq.npq07 = g_nnm.nnm17               #本幣金額
      
      SELECT azi04 INTO t_azi04 
        FROM azi_file
       WHERE azi01 = p_nnm.nnm09
       
      LET g_npq.npq07f = cl_digcut(p_nnm.nnm17/p_nnm.nnm10,t_azi04)   #原幣金額
      
      SELECT aag05 INTO l_aag05 
        FROM aag_file 
       WHERE aag01 = g_npq.npq03
         AND aag00 = l_bookno1
 
      IF l_aag05='N' THEN
         LET g_npq.npq05 = ''
      ELSE
         IF p_nnm.nnm15='1' THEN
            SELECT nne44 INTO g_npq.npq05 
              FROM nne_file
             WHERE nne01 = p_nnm.nnm01
         ELSE
            LET g_npq.npq05 = p_nnm.nnmgrup       #長貸沒打部門取不到
         END IF
      END IF
 
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,p_nnm.nnm02,p_nnm.nnm03,l_bookno1)
           RETURNING  g_npq.*
       
      CALL s_def_npq31_npq34(g_npq.*,l_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087 
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN 
         LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00
         CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq_c1:',STATUS,1)
         LET g_success='N' 
      END IF
   END IF
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021 
   #--產生完成
   LET g_npp1.* = g_npp.*   #FUN-A40033
 
END FUNCTION
 
FUNCTION t730_gen_glcr(p_nnm,p_nmy)
   DEFINE p_nnm RECORD LIKE nnm_file.*
   DEFINE p_nmy RECORD LIKE nmy_file.*
 
   IF cl_null(p_nmy.nmygslp) THEN
      CALL s_errmsg('nnm01',p_nnm.nnm01,'','axr-070',1)     #No.FUN-840102 add
      LET g_success = 'N'
      RETURN
   END IF       
   CALL t730_s1(p_nnm.*)    #No.FUN-840102 add
   CALL t730_gen_diff()       #No.FUN-A40033
   IF g_success = 'N' THEN 
      RETURN 
   END IF
 
END FUNCTION
 
FUNCTION t730_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE l_nmygslp1   LIKE nmy_file.nmygslp    #MOD-B90217
  DEFINE li_result    LIKE type_file.num5      #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5      #No.FUN-680107 SMALLINT
  DEFINE l_aaa07      LIKE aaa_file.aaa07      #MOD-930162
 
    IF NOT cl_null(g_nnm.nnmglno) OR g_nnm.nnmglno IS NOT NULL THEN
       CALL cl_err(g_nnm.nnmglno,'aap-618',1) 
       RETURN 
    END IF 
    LET INT_FLAG = 0    #MOD-B90217 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
   SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01=g_nmz.nmz02b
   IF g_nnm.nnm06 <= l_aaa07 THEN
      CALL cl_err('','axm-164',1)
      RETURN
   END IF
 
    CALL s_get_doc_no(g_nnm.nnm01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmz.nmz52 = 'N' THEN   #MOD-B90217
       IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
          LET l_nmygslp = g_nmy.nmygslp
          #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
          #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
          LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                      "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                      "    AND aba01 = '",g_nnm.nnmglno,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
          PREPARE aba_pre5 FROM l_sql
          DECLARE aba_cs5 CURSOR FOR aba_pre5
          OPEN aba_cs5
          FETCH aba_cs5 INTO l_n
          IF l_n > 0 THEN
             CALL cl_err(g_nnm.nnmglno,'aap-991',1)
             RETURN
          END IF
       ELSE
          CALL cl_err('','aap-936',1) #FUN-940036
          RETURN
       END IF
   #-MOD-B90217-add-
    ELSE
       #開窗作業
       LET g_plant_new= g_nmz.nmz02p
 
       OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_locale("axrt200_p")
        
       INPUT l_nmygslp,l_nmygslp1 WITHOUT DEFAULTS FROM FORMONLY.gl_no,FORMONLY.gl_no1

          BEFORE INPUT
             IF g_aza.aza63 <> 'Y' THEN
                CALL cl_set_comp_visible("gl_no1",FALSE)
             ELSE
                CALL cl_set_comp_entry("gl_no1",TRUE)
             END IF
    
          AFTER FIELD gl_no
             CALL s_check_no("agl",l_nmygslp,"","3","aac_file","aac01",g_plant_new) 
                   RETURNING li_result,l_nmygslp
             IF (NOT li_result) THEN
                NEXT FIELD gl_no
             END IF
     
          AFTER FIELD gl_no1
             CALL s_check_no("agl",l_nmygslp1,"","3","aac_file","aac01",g_plant_new) 
                   RETURNING li_result,l_nmygslp1
             IF (NOT li_result) THEN
                NEXT FIELD gl_no1
             END IF

          AFTER INPUT
             IF INT_FLAG THEN
                EXIT INPUT 
             END IF
             IF cl_null(l_nmygslp) THEN
                CALL cl_err('','9033',0)
                NEXT FIELD gl_no  
             END IF
    
          ON ACTION cancel 
             EXIT INPUT

          ON ACTION CONTROLR
             CALL cl_show_req_fields()

          ON ACTION CONTROLG
             CALL cl_cmdask()

          ON ACTION CONTROLP
             IF INFIELD(gl_no) THEN
                CALL q_m_aac(FALSE,TRUE,g_plant_new,l_nmygslp,'3',' ',' ','AGL') 
                RETURNING l_nmygslp
                DISPLAY l_nmygslp TO FORMONLY.gl_no
                NEXT FIELD gl_no
             END IF
             IF INFIELD(gl_no1) THEN
                CALL q_m_aac(FALSE,TRUE,g_plant_new,l_nmygslp1,'3',' ',' ','AGL') 
                RETURNING l_nmygslp1
                DISPLAY l_nmygslp1 TO FORMONLY.gl_no1
                NEXT FIELD gl_no1
             END IF

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
     
          ON ACTION about         
             CALL cl_about()    
     
          ON ACTION help    
             CALL cl_show_help() 
     
          ON ACTION exit  
             LET INT_FLAG = 1
             EXIT INPUT
 
       END INPUT
       CLOSE WINDOW t200p  
       IF INT_FLAG = 1 THEN RETURN END IF
       LET g_nmy.nmygslp1 = l_nmygslp1
    END IF
   #-MOD-B90217-end-
    IF cl_null(l_nmygslp) THEN
       CALL cl_err(g_nnm.nnm01,'axr-070',1)
       RETURN
    END IF
    IF g_aza.aza63 = 'Y' AND cl_null(g_nmy.nmygslp1) THEN
       CALL cl_err(g_nnm.nnm01,'axr-070',1)
       RETURN
    END IF
    LET p_trno=g_nnm.nnm01,g_nnm.nnm02 USING '&&&&',g_nnm.nnm03 USING '&#'
    LET g_wc_gl = 'npp01 = "',p_trno,'" AND npp011 = 0'                                                                      
    LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nnm.nnm06,"' 'Y' '1' 'Y'"   #No.FUN-680088#FUN-860040
 
    CALL cl_cmdrun_wait(g_str)
    SELECT nnmglno,nnm14 INTO g_nnm.nnmglno,g_nnm.nnm14 FROM nnm_file
     WHERE nnm01 = g_nnm.nnm01
    DISPLAY BY NAME g_nnm.nnmglno
    DISPLAY BY NAME g_nnm.nnm14
    IF NOT cl_null(g_nnm.nnmglno) THEN
       CALL cl_err(g_nnm.nnmglno,"anm-710",0)
    ELSE
       CALL cl_err("","anm-711",0)
    END IF
    
END FUNCTION
 
FUNCTION t730_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING
 
    IF cl_null(g_nnm.nnmglno) OR g_nnm.nnmglno IS NULL THEN
       CALL cl_err(g_nnm.nnmglno,'aap-619',1) 
       RETURN 
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nnm.nnm01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   #IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036         #MOD-B90217 mark
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) AND g_nmz.nmz52 = 'N' THEN #MOD-B90217 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
 
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnm.nnmglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nnm.nnmglno,'axr-071',1)
       RETURN
    END IF
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nnm.nnmglno,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT nnmglno INTO g_nnm.nnmglno FROM nnm_file
     WHERE nnm01 = g_nnm.nnm01
    DISPLAY BY NAME g_nnm.nnmglno
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15
#FUN-A40033 --Begin
FUNCTION t730_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   IF g_npp1.npptype = '1' THEN
      LET g_bookno3 = g_bookno2   #No.FUN-D40118   Add
      CALL s_get_bookno(YEAR(g_nnm.nnm02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(g_nnm.nnm02),'aoo-081',1)
         RETURN
      END IF
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno2
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp1.npp00
         AND npq01 = g_npp1.npp01
         AND npq011= g_npp1.npp011
         AND npqsys= g_npp1.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp1.npp00
         AND npq01 = g_npp1.npp01
         AND npq011= g_npp1.npp011
         AND npqsys= g_npp1.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp1.npp00
            AND npq01 = g_npp1.npp01
            AND npq011= g_npp1.npp011
            AND npqsys= g_npp1.nppsys
         LET l_npq1.npqtype = g_npp1.npptype
         LET l_npq1.npq00 = g_npp1.npp00
         LET l_npq1.npq01 = g_npp1.npp01
         LET l_npq1.npq011= g_npp1.npp011
         LET l_npq1.npqsys= g_npp1.nppsys
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
         LET l_npq1.npq07f  = l_npq1.npq07
         LET l_npq1.npqlegal= g_legal
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp1.npp01,"",STATUS,"","",1) #FUN-670091
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End

