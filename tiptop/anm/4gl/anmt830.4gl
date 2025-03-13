# Prog. Version..: '5.30.07-13.06.04(00010)'     #
#
# Pattern name...: anmt830.4gl
# Descriptions...: 利息收入暫估維護作業
# Date & Author..: 99/12/03
# Modify ........: 02/12/19 add gxh011
# Modify.........: No.7354 03/10/28 Kitty 發現gxf06的錯誤
# Modify.........: No.8675 03/11/10 Kitty U.更改時, 可開放修改
#                  起算日期,止算日期,天數(由止算-起算日期),匯率,暫估原幣,暫估本幣原判斷不變
# Modify.........: No.9063 04/01/27 Kammy g_gxh.gxhglno IS NOT NULL應改為
#                                         NOT cl_null(g_gxh.gxhglno)
# Modify.........: No.FUN-4B0052 04/11/25 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0070 04/12/16 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-4C0098 05/01/13 By pengu 報表轉XML
# Modify.........: NO.FUN-550057 05/05/30 By jackie 單據編號加大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610043 06/01/16 By Smapmin 增加新增功能
# Modify.........: No.TQC-630189 06/03/21 By Smapmin 增加產生分錄功能
# Modify.........: No.MOD-640499 06/04/17 By Smapmin 增加確認與取消確認功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.MOD-670053 06/07/17 By Smapmin 調整起算日期與止算日期時,天數與金額要重新計算
# Modify.........: No.FUN-670085 06/07/20 By Smapmin 將分錄類別與單號秀在畫面上
# Modify.........: No.FUN-670060 06/08/03 By Tracy 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680088 06/08/29 By Ray 多帳套處理
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.TQC-690111 06/10/16 By Smapmin 確認碼無法查詢
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710024 07/01/29 By cheunl錯誤訊息匯整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740028 07/04/10 By lora   會計科目加帳套
# Modify.........: No.TQC-740093 07/04/17 By bnlent 在FETCH（）中取帳套
# Modify.........: No.MOD-740431 07/04/24 By cheunl 1、系統并未顯示無法確認的原因,且正常結束
#                                         By bnlent 2、審核時錯誤信息匯整未顯示
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760008 07/06/04 By Carrier 會科加帳套引起的確認功能問題
# Modify.........: No.MOD-770067 07/07/16 By Smapmin 確認後不可刪除
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: Mo:MOD-820160 08/02/26 By Smapmin 刪除時要同步刪掉分錄資料
# Modify.........: No.FUN-810069 08/03/03 By ChenMoyan 取消預算編號的控管
# Modify.........: No.FUN-810069 08/03/04 By lynn s_getbug()新增參數 部門編號afb041,專案代碼afb042
# Modify.........: No.FUN-810045 08/03/03 By rainy 項目管理 gja_file->pja_file
# Modify.........: No.MOD-830060 08/03/11 By Smapmin 分錄存在時才刪除分錄/單別需拋轉傳票時才產生分錄
# Modify.........: No.FUN-830139 08/04/11 By bnlent 1、預算項目BUG修改 2、s_getbug ->s_getbug1 
# Modify.........: No.FUN-830151 08/05/07 By sherry 報表改由CR輸出 
# Modify.........: No.FUN-850038 08/05/12 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-8A0102 08/11/25 By Sarah 增加匯率欄位於幣別欄位之後
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-940180 09/04/14 By Sarah 分錄的摘要值應按照agli121設定帶出
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.TQC-960335 09/06/23 By hongmei FUNCTION t830_firm2()中ROWID=g_nne_rowid錯誤，改為gxh011 = g_gxh.gxh011 AND gxh02 = g_gxh.gxh02 AND gxh03 = g_gxh.gxh03
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980092 09/08/12 By mike 調整anmt830報表,在存單號碼(gxh01)前面增加列印申請號碼(gxh011)                     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A10014 10/10/19 By sabrina 若aza26='0'且幣別=aza17時，利息以365天計算，其餘則用360天計算
# Modify.........: No.TQC-AB0300 10/12/03 By vealxu 對科目npq03做檢查,如果為空,則報錯
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善 
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/06/07 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No:MOD-B70190 11/07/21 By Polly 調整拋轉時，改用s_curr3計算
# Modify.........: No.MOD-C10180 12/01/31 By Polly 1.l_gxh11_r、l_gxh12_r、l_gxh11_tot為null，給予0
#                                                  2.判斷單號如果一樣，l_gxh11_r、l_gxh12_r不需重覆計算
# Modify.........: No:MOD-C20067 12/02/10 By Polly 調整錯誤訊息的顯示
# Modify.........: No:MOD-C20094 12/02/14 By Polly 已確認單據不可再重新產生底稿
# Modify.........: No:MOD-C30704 12/03/15 By wangrr 已存在利息單號不可取消確認
# Modify.........: No:MOD-C40124 12/04/18 By Elise 當定存單為外幣時，anmp830會帶入每日匯率賣出的匯率，應改抓每日匯率買入的匯率
# Modify.........: No:MOD-C80053 12/08/09 By Polly 調整「拋轉傳票」傳入值
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No:MOD-CB0152 12/11/20 By Polly 修正重覆計算已耗用金額問題
# Modify.........: No:FUN-D10116 13/03/07 By Polly 增加作廢功能
# Modify.........: No:MOD-CB0066 13/04/10 By apo 定存單增加作廢條件判斷
# Modify.........: No:MOD-D50056 13/05/08 By Polly 顯示傳票編號增加年度月份抓取條件
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D70090 13/07/18 By fengmy 增加afbacti

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
       g_gxf        RECORD LIKE gxf_file.*,
       g_gxh        RECORD LIKE gxh_file.*,
       g_gxh_t      RECORD LIKE gxh_file.*,
       g_gxh011_t   LIKE gxh_file.gxh011,
       g_gxh02_t    LIKE gxh_file.gxh02,
       g_gxh03_t    LIKE gxh_file.gxh03,
       g_wc,g_sql   STRING,                  #TQC-630166 
       g_nma02      LIKE nma_file.nma02,
       g_date       LIKE cre_file.cre08,     #No.FUN-680107 VARCHAR(10)
       g_last       LIKE type_file.dat,      #No.FUN-680107 DATE
       g_nmydmy1    LIKE nmy_file.nmydmy1,   #MOD-AC0073
       g_nmydmy3    LIKE nmy_file.nmydmy3,   #MOD-AC0073
       p_trno       LIKE type_file.chr50     #NO.FUN-680107 VARCHAR(22)  #TQC-630189
 
DEFINE g_forupd_sql STRING                   #SELECT ... FOR UPDATE SQL 
DEFINE g_before_input_done STRING
 
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03        #No.FUN-680107 VARCHAR(72)
DEFINE g_str        STRING                   #No.FUN-670060 
DEFINE g_wc_gl      STRING                   #No.FUN-670060
DEFINE g_t1         LIKE oay_file.oayslip    #No.FUN-670060 #No.FUN-680107 VARCHAR(5)
DEFINE g_dbs_gl     LIKE type_file.chr21     #No.FUN-680107 VARCHAR(21)       #No.FUN-670060     
 
DEFINE g_row_count  LIKE type_file.num10     #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10     #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10     #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5      #No.FUN-680107 SMALLINT
DEFINE g_bookno     LIKE aza_file.aza81      #MOD-940180 add
DEFINE g_bookno1    LIKE aza_file.aza81      #No.FUN-740028                                                                        
DEFINE g_bookno2    LIKE aza_file.aza82      #No.FUN-740028                                                                        
DEFINE g_flag       LIKE type_file.chr1      #No.FUN-740028  
DEFINE l_sql        STRING                                                 
DEFINE l_table      STRING                                                 
DEFINE g_void       LIKE type_file.chr1      #FUN-D10116 add 
DEFINE g_aag44      LIKE aag_file.aag44      #FUN-D40118 add

MAIN
DEFINE
       p_row,p_col  LIKE type_file.num5      #No.FUN-680107 SMALLINT
 
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
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
    IF p_row = 0 OR p_row IS NULL THEN           # 螢墓位置
       LET p_row = 4
       LET p_col = 15
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
    LET g_sql = "gxh011.gxh_file.gxh011,", #MOD-980092    
                "gxh01.gxh_file.gxh01,gxh02.gxh_file.gxh02,",
                "gxh03.gxh_file.gxh03,gxh14.gxh_file.gxh14,",
                "nma02.nma_file.nma02,gxf24.gxf_file.gxf24,",
                "gxf021.gxf_file.gxf021,gxf26.gxf_file.gxf26,",
                "gxf03.gxf_file.gxf03,gxf05.gxf_file.gxf05,",
                "gxh05.gxh_file.gxh05,gxh06.gxh_file.gxh06,",
                "gxh07.gxh_file.gxh07,gxh12.gxh_file.gxh12,",
                "gxh13.gxh_file.gxh13,gxh11.gxh_file.gxh11,",
                "gxh09.gxh_file.gxh09,gxh10.gxh_file.gxh10,",   #FUN-8A0102 add
                "l_gxh11_r.gxh_file.gxh11,",
                "l_gxh12_r.gxh_file.gxh12,",
                "l_gxh12_tot.gxh_file.gxh12,",
                "t_azi04.azi_file.azi04,",
                "l_azi04.azi_file.azi04,",
                "l_azi07.azi_file.azi07"   #FUN-8A0102 add
                                                                                
    LET l_table = cl_prt_temptable('anmt830',g_sql) CLIPPED                     
    IF l_table = -1 THEN EXIT PROGRAM END IF                                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",         
                "        ?,?,?,?,?)"   #FUN-8A0102 add 2? #MOD-980092 add 1?  
    PREPARE insert_prep FROM g_sql                                              
    IF STATUS THEN                                                              
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                        
    END IF                                                                      
 
    INITIALIZE g_gxh.* TO NULL
    INITIALIZE g_gxh_t.* TO NULL
 
    LET g_plant_new = g_nmz.nmz02p                                                                                                   
    CALL s_getdbs()                                                                                                                  
    LET g_dbs_gl = g_dbs_new       
 
    LET g_forupd_sql = "SELECT * FROM gxh_file WHERE gxh011 = ? AND gxh02 = ? AND gxh03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t830_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW t830_w AT p_row,p_col
        WITH FORM "anm/42f/anmt830"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_action_choice=""
    CALL t830_menu()
 
    CLOSE WINDOW t830_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t830_cs()
    CLEAR FORM
   INITIALIZE g_gxh.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        gxh011,gxh01,gxh02,gxh03,gxh13,gxhglno,gxh15,gxh14,gxh05,gxh06,gxh07,gxh08,gxh09,gxh10,   #TQC-690111
        gxh11,gxh12,
        gxhud01,gxhud02,gxhud03,gxhud04,gxhud05,
        gxhud06,gxhud07,gxhud08,gxhud09,gxhud10,
        gxhud11,gxhud12,gxhud13,gxhud14,gxhud15
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION CONTROLP                        # 沿用所有欄位
            IF INFIELD(gxh14) THEN #銀行代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nma"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = g_gxh.gxh14
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gxh14
               NEXT FIELD gxh14
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
 
        ON ACTION qbe_select
       	   CALL cl_qbe_select()
        ON ACTION qbe_save
	   CALL cl_qbe_save()
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gxhuser', 'gxhgrup') #FUN-980030
    LET g_sql="SELECT gxh011,gxh02,gxh03 FROM gxh_file ",
        " WHERE ",g_wc CLIPPED, "  ORDER BY gxh011,gxh02,gxh03"
    PREPARE t830_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t830_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t830_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM gxh_file WHERE ",g_wc CLIPPED
    PREPARE t830_precount FROM g_sql
    DECLARE t830_count CURSOR FOR t830_precount
END FUNCTION
 
FUNCTION t830_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_aza.aza63 = 'Y' THEN
               CALL cl_set_act_visible("maintain_entry2",TRUE)
            ELSE
               CALL cl_set_act_visible("maintain_entry2",FALSE)
            END IF
 
      #No.+421 將新增功能拿掉,因為per欄位大部份都NOENTRY,有新增時
      #        很多欄位會無法輸入
      #將新增功能remark
       ON ACTION insert
           LET g_action_choice = 'insert'
           IF cl_chk_act_auth() THEN
                CALL t830_a()
           END IF
        ON ACTION query
            LET g_action_choice = 'query'
            IF cl_chk_act_auth() THEN
                 CALL t830_q()
            END IF
        ON ACTION next
            CALL t830_fetch('N')
        ON ACTION previous
            CALL t830_fetch('P')
        ON ACTION modify
            LET g_action_choice = 'modify'
            IF cl_chk_act_auth() THEN
                 CALL t830_u()
            END IF
        ON ACTION delete
            LET g_action_choice = 'delete'
            IF cl_chk_act_auth() THEN
                 CALL t830_r()
            END IF
        ON ACTION output
            LET g_action_choice = 'output'
            IF cl_chk_act_auth() THEN
               CALL t830_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t830_fetch('/')
        ON ACTION first
            CALL t830_fetch('F')
        ON ACTION last
            CALL t830_fetch('L')
 
        ON ACTION carry_voucher                  #傳票拋轉 
           IF cl_chk_act_auth() THEN
              IF g_gxh.gxh15 = 'Y' THEN                                                                                            
                 CALL t830_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
              END IF 
           END IF
        ON ACTION undo_carry_voucher             #傳票拋轉還原  
           IF cl_chk_act_auth() THEN
              IF g_gxh.gxh15 = 'Y' THEN
                 CALL t830_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
              END IF  
           END IF
 
      ON ACTION gen_entry
         LET g_action_choice = 'gen_entry'
         IF cl_chk_act_auth() THEN
            LET p_trno=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
            CALL t830_v(p_trno,'0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL t830_v(p_trno,'1')
            END IF
         END IF
 
      ON ACTION maintain_entry
         LET g_action_choice = 'maintain_entry'
         IF cl_chk_act_auth() THEN
            LET p_trno=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
            CALL s_fsgl('NM',24,p_trno,g_gxh.gxh11,
                        g_nmz.nmz02b,1,'','0',g_nmz.nmz02p)      #No.FUN-680088
            CALL cl_navigator_setting( g_curs_index, g_row_count )      #No.FUN-680088
         END IF
 
      ON ACTION maintain_entry2
         LET g_action_choice = 'maintain_entry2'
         IF cl_chk_act_auth() THEN
            LET p_trno=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
            CALL s_fsgl('NM',24,p_trno,g_gxh.gxh11,
                        g_nmz.nmz02c,1,'','1',g_nmz.nmz02p)
            CALL cl_navigator_setting( g_curs_index, g_row_count )
         END IF
       ON ACTION confirm
          LET g_action_choice = 'confirm'
          IF cl_chk_act_auth() THEN
             CALL t830_firm1()
          END IF
 
       ON ACTION undo_confirm
          LET g_action_choice = 'undo_confirm'
          IF cl_chk_act_auth() THEN
             CALL t830_firm2()
          END IF

       #--------------FUN-D10116---------------(S)
        ON ACTION void
           LET g_action_choice = "void"
           IF cl_chk_act_auth() THEN
              CALL t830_x()
              IF g_gxh.gxh15 = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_gxh.gxh15,"","","",g_void,"")
           END IF
       #--------------FUN-D10116---------------(E
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF g_gxh.gxh011 IS NOT NULL THEN
               LET g_doc.column1 = "gxh011"
               LET g_doc.value1 = g_gxh.gxh011
               CALL cl_doc()
             END IF
          END IF
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t830_cs
END FUNCTION
 
FUNCTION t830_a()
    IF s_anmshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_gxh.* LIKE gxh_file.*
    LET g_gxh.gxh08=0
    LET g_gxh.gxh10=1
    LET g_gxh.gxh11=0
    LET g_gxh.gxh12=0
LET g_gxh011_t = NULL
LET g_gxh02_t = NULL
LET g_gxh03_t = NULL
    LET g_gxh.gxh15 = 'N'   #MOD-640499
    LET g_gxh.gxhlegal= g_legal
    LET g_gxh_t.*=g_gxh.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t830_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_gxh.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_gxh.gxh011 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_gxh.gxhoriu = g_user      #No.FUN-980030 10/01/04
        LET g_gxh.gxhorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO gxh_file VALUES(g_gxh.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gxh_file",g_gxh.gxh011,g_gxh.gxh02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
           CONTINUE WHILE
        ELSE
          #-MOD-AC0073-add-
           #---判斷是否立即confirm-----
           LET g_t1 = s_get_doc_no(g_gxh.gxh011)    
           SELECT nmydmy1,nmydmy3 INTO g_nmydmy1,g_nmydmy3
             FROM nmy_file
            WHERE nmyslip = g_t1 AND nmyacti = 'Y'
           IF g_nmydmy3 = 'Y' THEN
              IF cl_confirm('axr-309') THEN
                 LET p_trno=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
                 CALL t830_v(p_trno,'0')
                 IF g_aza.aza63 = 'Y' THEN
                    CALL t830_v(p_trno,'1')
                 END IF
              END IF
           END IF
           IF g_nmydmy1 = 'Y' THEN CALL t830_firm1() END IF
          #-MOD-AC0073-end-
           LET g_gxh_t.* = g_gxh.*                # 保存上筆資料
           SELECT gxh011,gxh02,gxh03 INTO g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03 FROM gxh_file
               WHERE gxh011 = g_gxh.gxh011
                 AND gxh02 = g_gxh.gxh02
                 AND gxh03 = g_gxh.gxh03
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t830_i(p_cmd)
DEFINE
       p_cmd           LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
       l_flag          LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
       l_nne112        LIKE nne_file.nne112,    #No:8675
       l_n             LIKE type_file.num5      #No.FUN-680107 SMALLINT
DEFINE l_x             LIKE type_file.chr8      #No.FUN-680107 VARCHAR(8) #MOD-670053
DEFINE p_edate         LIKE type_file.dat       #No.FUN-680107 DATE    #MOD-670053
 
    INPUT BY NAME
        g_gxh.gxh011,g_gxh.gxh01,g_gxh.gxh02,g_gxh.gxh03,g_gxh.gxh13,g_gxh.gxhglno,
        g_gxh.gxh14,g_gxh.gxh05,g_gxh.gxh06,
        g_gxh.gxh07,g_gxh.gxh08,g_gxh.gxh09,
        g_gxh.gxh10,g_gxh.gxh11,g_gxh.gxh12,
        g_gxh.gxhud01,g_gxh.gxhud02,g_gxh.gxhud03,g_gxh.gxhud04,
        g_gxh.gxhud05,g_gxh.gxhud06,g_gxh.gxhud07,g_gxh.gxhud08,
        g_gxh.gxhud09,g_gxh.gxhud10,g_gxh.gxhud11,g_gxh.gxhud12,
        g_gxh.gxhud13,g_gxh.gxhud14,g_gxh.gxhud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t830_set_entry(p_cmd)
            CALL t830_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("gxh011")
         CALL cl_set_docno_format("gxh13")
         CALL cl_set_docno_format("gxf01")
 
        AFTER FIELD gxh011
            IF NOT cl_null(g_gxh.gxh011) THEN
               SELECT * INTO g_gxf.* FROM gxf_file
                WHERE gxf011=g_gxh.gxh011
                  AND gxfconf <> 'X'                 #MOD-CB0066 add
                 IF STATUS THEN 
                    CALL cl_err3("sel","gxf_file",g_gxh.gxh011,"",STATUS,"","anm-286",1)  #No.FUN-660148
                    NEXT FIELD gxh011
               END IF
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_gxh.gxh011 != g_gxh011_t) THEN
               END IF
            END IF
        AFTER FIELD gxh02
        IF NOT cl_null(g_gxh.gxh02) THEN                #TQC-740093
           CALL s_get_bookno(g_gxh.gxh02) RETURNING g_flag,g_bookno1,g_bookno2                                                     
           IF g_flag =  '1' THEN  #抓不到帳別                                                                                       
              CALL cl_err(g_gxh.gxh02,'aoo-081',1)                                                                                  
           NEXT FIELD gxh02                                                                                                      
           END IF  
        END IF                                                                                        
 
        AFTER FIELD gxh03
            IF NOT cl_null(g_gxh.gxh03) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_gxh.gxh011 != g_gxh011_t) THEN
                   SELECT count(*) INTO l_n FROM gxh_file
                       WHERE gxh011 = g_gxh.gxh011
                         AND gxh02 = g_gxh.gxh02
                         AND gxh03 = g_gxh.gxh03
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_gxh.gxh011,-239,0)
                       LET g_gxh.gxh011 = g_gxh011_t
                       DISPLAY BY NAME g_gxh.gxh011
                       NEXT FIELD gxh011
                   END IF
                  LET g_gxh.gxh01 = g_gxf.gxf01
                  LET g_gxh.gxh14 = g_gxf.gxf02
                  LET g_gxh.gxh08 = g_gxf.gxf06
                  LET g_gxh.gxh09 = g_gxf.gxf24
                  LET g_gxh.gxh10 = g_gxf.gxf25
                  LET g_date=g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&&','01'
                  IF g_gxf.gxf04 = '1' THEN
                     LET l_x = g_gxf.gxf03 USING 'yyyymmdd'
                     LET l_x[1,4] = g_gxh.gxh02
                     LET l_x[5,6] = g_gxh.gxh03
                     LET g_gxh.gxh05 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
                     IF cl_null(g_gxh.gxh05) THEN
                        LET g_gxh.gxh05 = MDY(l_x[5,6],1,l_x[1,4])
                        CALL s_last(g_gxh.gxh05) RETURNING p_edate
                        LET l_x[7,8] = DAY(p_edate) USING '&&'
                        LET g_gxh.gxh05 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
                     END IF
                  ELSE
                     IF g_gxh.gxh02=YEAR(g_gxf.gxf03) AND
                        g_gxh.gxh03=MONTH(g_gxf.gxf03) THEN
                        LET g_gxh.gxh05 = g_gxf.gxf03
                     ELSE
                        LET g_gxh.gxh05 = g_date
                     END IF
                  END IF   #MOD-670053
                  IF g_gxh.gxh02=YEAR(g_gxf.gxf05) AND
                     g_gxh.gxh03=MONTH(g_gxf.gxf05) THEN
                     LET g_gxh.gxh06 = g_gxf.gxf05          #No:7354
                  ELSE
                     CALL s_last(g_date) RETURNING g_gxh.gxh06
                  END IF
                  LET g_gxh.gxh07 = g_gxh.gxh06 - g_gxh.gxh05 + 1
                 #IF g_gxf.gxf24 <> g_aza.aza17 THEN     #外幣                         #CHI-A10014 mark
                  IF g_aza.aza26 <> '0' OR g_gxf.gxf24 <> g_aza.aza17 THEN     #外幣   #CHI-A10014 add
                     LET g_gxh.gxh11 = (g_gxf.gxf021*g_gxf.gxf06/100)/360*
                                        g_gxh.gxh07
                  ELSE
                     LET g_gxh.gxh11 = (g_gxf.gxf021*g_gxf.gxf06/100)/365*
                                        g_gxh.gxh07
                  END IF
                  SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
                   WHERE azi01=g_gxh.gxh09
                  CALL cl_digcut(g_gxh.gxh11,t_azi04) RETURNING g_gxh.gxh11
                  LET g_gxh.gxh12 = g_gxh.gxh11 * g_gxh.gxh10
                  CALL cl_digcut(g_gxh.gxh12,g_azi04) RETURNING g_gxh.gxh12
                  DISPLAY BY NAME g_gxh.gxh14,g_gxh.gxh08,g_gxh.gxh09,
                                  g_gxh.gxh10,
                                  g_gxh.gxh05,g_gxh.gxh06,g_gxh.gxh07,
                                  g_gxh.gxh11,g_gxh.gxh12
                  SELECT nma02 INTO g_nma02 FROM nma_file WHERE nma01=g_gxh.gxh14
                  IF STATUS THEN
                     CALL cl_err3("sel","nma_file",g_gxh.gxh14,"",STATUS,"","sel nma:",1)  #No.FUN-660148
                     NEXT FIELD gxh14
                  ELSE
                     DISPLAY g_nma02 TO FORMONLY.nma02
                  END IF
               END IF
            END IF
        AFTER FIELD gxh05
            LET g_gxh.gxh07 = g_gxh.gxh06 - g_gxh.gxh05 + 1
           #IF g_gxf.gxf24 <> g_aza.aza17 THEN     #外幣                         #CHI-A10014 mark
            IF g_aza.aza26 <> '0' OR g_gxf.gxf24 <> g_aza.aza17 THEN     #外幣   #CHI-A10014 add
               LET g_gxh.gxh11 = (g_gxf.gxf021*g_gxf.gxf06/100)/360*
                                  g_gxh.gxh07
            ELSE
               LET g_gxh.gxh11 = (g_gxf.gxf021*g_gxf.gxf06/100)/365*
                                  g_gxh.gxh07
            END IF
            SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
             WHERE azi01=g_gxh.gxh09
            CALL cl_digcut(g_gxh.gxh11,t_azi04) RETURNING g_gxh.gxh11
            LET g_gxh.gxh12 = g_gxh.gxh11 * g_gxh.gxh10
            CALL cl_digcut(g_gxh.gxh12,g_azi04) RETURNING g_gxh.gxh12
            DISPLAY BY NAME g_gxh.gxh07,g_gxh.gxh11,g_gxh.gxh12
 
        AFTER FIELD gxh06
            LET g_gxh.gxh07 = g_gxh.gxh06 - g_gxh.gxh05 + 1
           #IF g_gxf.gxf24 <> g_aza.aza17 THEN     #外幣                         #CHI-A10014 mark
            IF g_aza.aza26 <> '0' OR g_gxf.gxf24 <> g_aza.aza17 THEN     #外幣   #CHI-A10014 add
               LET g_gxh.gxh11 = (g_gxf.gxf021*g_gxf.gxf06/100)/360*
                                  g_gxh.gxh07
            ELSE
               LET g_gxh.gxh11 = (g_gxf.gxf021*g_gxf.gxf06/100)/365*
                                  g_gxh.gxh07
            END IF
            SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
             WHERE azi01=g_gxh.gxh09
            CALL cl_digcut(g_gxh.gxh11,t_azi04) RETURNING g_gxh.gxh11
            LET g_gxh.gxh12 = g_gxh.gxh11 * g_gxh.gxh10
            CALL cl_digcut(g_gxh.gxh12,g_azi04) RETURNING g_gxh.gxh12
            DISPLAY BY NAME g_gxh.gxh07,g_gxh.gxh11,g_gxh.gxh12
 
 
        BEFORE FIELD gxh14
            IF NOT cl_null(g_gxh.gxh03) THEN
               SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011=g_gxh.gxh011
                  AND gxfconf <> 'X'                 #MOD-CB0066 add
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_gxh.gxh011 != g_gxh011_t) THEN
                 LET g_gxh.gxh14 = g_gxf.gxf02
                 LET g_gxh.gxh08 = g_gxf.gxf06
                 LET g_gxh.gxh09 = g_gxf.gxf24
                 LET g_gxh.gxh10 = g_gxf.gxf25
                 LET g_date=g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&&','01'
                 IF g_gxf.gxf04 = '1' THEN
                    LET l_x = g_gxf.gxf03 USING 'yyyymmdd'
                    LET l_x[1,4] = g_gxh.gxh02
                    LET l_x[5,6] = g_gxh.gxh03
                    LET g_gxh.gxh05 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
                    IF cl_null(g_gxh.gxh05) THEN
                       LET g_gxh.gxh05 = MDY(l_x[5,6],1,l_x[1,4])
                       CALL s_last(g_gxh.gxh05) RETURNING p_edate
                       LET l_x[7,8] = DAY(p_edate) USING '&&'
                       LET g_gxh.gxh05 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
                    END IF
                 ELSE
                    IF g_gxh.gxh02=YEAR(g_gxf.gxf03) AND
                       g_gxh.gxh03=MONTH(g_gxf.gxf03) THEN
                       LET g_gxh.gxh05 = g_gxf.gxf03   #TQC-630189
                    ELSE
                       LET g_gxh.gxh05 = g_date   #TQC-630189
                    END IF
                 END IF   #MOD-670053
                 IF g_gxh.gxh02=YEAR(g_gxf.gxf05) AND
                    g_gxh.gxh03=MONTH(g_gxf.gxf05) THEN
                    LET g_gxh.gxh06 = g_gxf.gxf05   #TQC-630189
                 ELSE
                    CALL s_last(g_date) RETURNING g_gxh.gxh06
                 END IF
                 LET g_gxh.gxh07 = g_gxh.gxh06 - g_gxh.gxh05 + 1
                #IF g_gxf.gxf24 <> g_aza.aza17 THEN     #外幣                         #CHI-A10014 mark
                 IF g_aza.aza26 <> '0' OR g_gxf.gxf24 <> g_aza.aza17 THEN     #外幣   #CHI-A10014 add
                    LET g_gxh.gxh11 = (g_gxf.gxf021*g_gxf.gxf06/100)/360*
                                       g_gxh.gxh07
                 ELSE
                    LET g_gxh.gxh11 = (g_gxf.gxf021*g_gxf.gxf06/100)/365*
                                       g_gxh.gxh07
                 END IF
                 SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
                  WHERE azi01=g_gxh.gxh09
                 CALL cl_digcut(g_gxh.gxh11,t_azi04) RETURNING g_gxh.gxh11
                 LET g_gxh.gxh12 = g_gxh.gxh11 * g_gxh.gxh10
                 CALL cl_digcut(g_gxh.gxh12,g_azi04) RETURNING g_gxh.gxh12   #TQC-630189
                 DISPLAY BY NAME g_gxh.gxh14,g_gxh.gxh08,g_gxh.gxh09,
                                 g_gxh.gxh10,
                                 g_gxh.gxh05,g_gxh.gxh06,g_gxh.gxh07,
                                 g_gxh.gxh11,g_gxh.gxh12
                 SELECT nma02 INTO g_nma02 FROM nma_file WHERE nma01=g_gxh.gxh14
                 IF STATUS THEN
                    CALL cl_err3("sel","nma_file",g_gxh.gxh14,"",STATUS,"","sel nma:",1)  #No.FUN-660148
                    NEXT FIELD gxh14 
                 ELSE
                    DISPLAY g_nma02 TO FORMONLY.nma02
                 END IF
               END IF
            END IF
 
        BEFORE FIELD gxh10
            IF NOT cl_null(g_gxh.gxh09) THEN
              #CALL s_curr3(g_gxh.gxh09,g_gxh.gxh06,'S') RETURNING g_gxh.gxh10   #No.MOD-B70190 add #MOD-C40124 mark
               CALL s_curr3(g_gxh.gxh09,g_gxh.gxh06,'B') RETURNING g_gxh.gxh10   #MOD-C40124
               DISPLAY BY NAME g_gxh.gxh10                                       #No.MOD-B70190 add
               SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01 = g_gxh.gxh09
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","azi_file",g_gxh.gxh09,"","anm-040","","sel azi:",1)  #No.FUN-660148
               END IF
            END IF
 
        AFTER FIELD gxh10
          IF NOT cl_null(g_gxh.gxh10) THEN
             CALL cl_digcut(g_gxh.gxh11,t_azi04) RETURNING g_gxh.gxh11
             #-- 本幣利息=原幣利息*Ex.Rate
             LET g_gxh.gxh12 = g_gxh.gxh11 * g_gxh.gxh10
             CALL cl_digcut(g_gxh.gxh12,g_azi04) RETURNING g_gxh.gxh12
             DISPLAY BY NAME g_gxh.gxh11,g_gxh.gxh12
 
             IF g_gxh.gxh09 =g_aza.aza17 THEN
                LET g_gxh.gxh10 =1
                DISPLAY BY NAME g_gxh.gxh10
             END IF
 
          END IF
 
        AFTER FIELD gxh11
            IF g_gxh.gxh11 < 0 THEN NEXT FIELD gxh11 END IF
            IF NOT cl_null(g_gxh.gxh11) THEN
               CALL cl_digcut(g_gxh.gxh11,t_azi04) RETURNING g_gxh.gxh11
               DISPLAY BY NAME g_gxh.gxh11
            END IF
            LET g_gxh.gxh12 = g_gxh.gxh11 * g_gxh.gxh10
            CALL cl_digcut(g_gxh.gxh12,g_azi04) RETURNING g_gxh.gxh12
            DISPLAY BY NAME g_gxh.gxh11,g_gxh.gxh12
 
        AFTER FIELD gxh12
            IF g_gxh.gxh12 < 0 THEN NEXT FIELD gxh12 END IF
            IF NOT cl_null(g_gxh.gxh12) THEN
               CALL cl_digcut(g_gxh.gxh12,g_azi04) RETURNING g_gxh.gxh12
               DISPLAY BY NAME g_gxh.gxh12
            END IF
 
        AFTER FIELD gxhud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gxhud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD gxh011
            END IF
 
 
        ON ACTION CONTROLP                        # 沿用所有欄位
            IF INFIELD(gxh14) THEN #銀行代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nma"
               LET g_qryparam.default1 = g_gxh.gxh14
               CALL cl_create_qry() RETURNING g_gxh.gxh14
               DISPLAY BY NAME g_gxh.gxh14
               NEXT FIELD gxh14
            END IF
            IF INFIELD(gxh10) THEN
                #CALL s_curr3(g_gxh.gxh09,g_gxh.gxh06,'S') RETURNING g_gxh.gxh10   #No.MOD-B70190 add  #MOD-C40124 mark
                 CALL s_curr3(g_gxh.gxh09,g_gxh.gxh06,'B') RETURNING g_gxh.gxh10   #MOD-C40124
                #CALL s_rate(g_gxh.gxh09,g_gxh.gxh10) RETURNING g_gxh.gxh10        #No.MOD-B70190 mark
                 DISPLAY BY NAME g_gxh.gxh10
                 NEXT FIELD gxh10
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
 
FUNCTION t830_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gxh.* TO NULL              #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t830_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t830_count
    FETCH t830_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t830_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxh.gxh011,SQLCA.sqlcode,0)
        INITIALIZE g_gxh.* TO NULL
    ELSE
        CALL t830_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t830_fetch(p_flgxh)
    DEFINE
        p_flgxh         LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10    #No.FUN-680107 INTEGER
 
    CASE p_flgxh
        WHEN 'N' FETCH NEXT     t830_cs INTO g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
        WHEN 'P' FETCH PREVIOUS t830_cs INTO g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
        WHEN 'F' FETCH FIRST    t830_cs INTO g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
        WHEN 'L' FETCH LAST     t830_cs INTO g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
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
            FETCH ABSOLUTE g_jump t830_cs INTO g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxh.gxh011,SQLCA.sqlcode,0)
        INITIALIZE g_gxh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flgxh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_gxh.* FROM gxh_file            # 重讀DB,因TEMP有不被更新特性
       WHERE gxh011 = g_gxh.gxh011 AND gxh02 = g_gxh.gxh02 AND gxh03 = g_gxh.gxh03
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gxh_file",g_gxh.gxh011,g_gxh.gxh02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       CALL s_get_bookno(g_gxh.gxh02) RETURNING g_flag,g_bookno1,g_bookno2
       IF g_flag =  '1' THEN  #抓不到帳別                                                                                       
          CALL cl_err(g_gxh.gxh02,'aoo-081',1)                                                                                  
       END IF                        
 
        CALL t830_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t830_show()
    DEFINE l_npp01 LIKE npp_file.npp01   #FUN-670085
    DEFINE l_npp00 LIKE npp_file.npp00   #FUN-670085
    DEFINE l_cnt   LIKE type_file.num5   #FUN-670085  #No.FUN-680107 SMALLINT
    LET g_gxh_t.* = g_gxh.*
    DISPLAY BY NAME
        g_gxh.gxh011,g_gxh.gxh01,g_gxh.gxh02,g_gxh.gxh03,
        g_gxh.gxh14,g_gxh.gxh05,g_gxh.gxh06,
        g_gxh.gxh07,g_gxh.gxh08,g_gxh.gxh09,
        g_gxh.gxh10,g_gxh.gxh11,g_gxh.gxh12,
        g_gxh.gxhglno,g_gxh.gxh13,g_gxh.gxh15,   #MOD-640499
        g_gxh.gxhud01,g_gxh.gxhud02,g_gxh.gxhud03,g_gxh.gxhud04,
        g_gxh.gxhud05,g_gxh.gxhud06,g_gxh.gxhud07,g_gxh.gxhud08,
        g_gxh.gxhud09,g_gxh.gxhud10,g_gxh.gxhud11,g_gxh.gxhud12,
        g_gxh.gxhud13,g_gxh.gxhud14,g_gxh.gxhud15 
    SELECT nma02 INTO g_nma02 FROM nma_file
     WHERE nma01=g_gxh.gxh14
    DISPLAY g_nma02 TO FORMONLY.nma02
    LET l_npp01=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
    LET l_npp00='24'
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM npp_file WHERE npp01  = l_npp01 AND
                                                   npp00  = l_npp00 AND
                                                   nppsys = 'NM' AND
                                                   npp011  = 1
    IF l_cnt > 0 THEN
       DISPLAY l_npp01 TO FORMONLY.npp01
       DISPLAY l_npp00 TO FORMONLY.npp00
    ELSE
       DISPLAY '' TO FORMONLY.npp01
       DISPLAY '' TO FORMONLY.npp00
    END IF
   #------------------------FUN-D10116---------------------------(S)
    IF g_gxh.gxh15 = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_gxh.gxh15,"","","",g_void,"")
   #------------------------FUN-D10116---------------------------(E)
   #CALL cl_set_field_pic(g_gxh.gxh15,"","","","","")        #MOD-640499 #FUN-D10116 mark
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t830_u()
DEFINE  l_msg   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(60)
    IF s_anmshut(0) THEN RETURN END IF
    IF g_gxh.gxh011 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF NOT cl_null(g_gxh.gxh13) OR NOT cl_null(g_gxh.gxhglno) THEN  #No.9063
       CALL cl_getmsg('aap',g_lang) RETURNING l_msg
       ERROR l_msg CLIPPED  RETURN
    END IF
   #----------------FUN-D10116-------------(S)
    IF g_gxh.gxh15 = 'Y' THEN
       CALL cl_err(g_gxh.gxh011,'anm-105',0)
       RETURN
    END IF
    IF g_gxh.gxh15 = 'X' THEN
       CALL cl_err(g_gxh.gxh011,'9024',0)
       RETURN
    END IF
   #----------------FUN-D10116-------------(E)
    MESSAGE ""
    CALL cl_opmsg('u')
LET g_gxh011_t = g_gxh.gxh011
LET g_gxh02_t = g_gxh.gxh02
LET g_gxh03_t = g_gxh.gxh03
 
    BEGIN WORK
    OPEN t830_cl USING g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
    IF STATUS THEN
       CALL cl_err("OPEN t830_cl:", STATUS, 1)
       CLOSE t830_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t830_cl INTO g_gxh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxh.gxh011,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t830_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t830_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gxh.*=g_gxh_t.*
            CALL t830_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE gxh_file SET gxh_file.* = g_gxh.*    # 更新DB
            WHERE gxh011 = g_gxh011_t AND gxh02 = g_gxh02_t AND gxh03 = g_gxh03_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gxh_file",g_gxh_t.gxh011,g_gxh_t.gxh02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t830_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t830_r()
DEFINE  l_msg   LIKE type_file.chr50     #No.FUN-680107 VARCHAR(50)
DEFINE  l_trno  LIKE type_file.chr50     #MOD-820160 
DEFINE  l_cnt   LIKE type_file.num5      #MOD-830060
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_gxh.gxh011 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_gxh.gxh15 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF   #MOD-770067
   #---------------------FUN-D10116--------------------(S)
    IF g_gxh.gxh15 = 'X' THEN
       CALL cl_err(g_gxh.gxh011,'9024',0)
       RETURN
    END IF
   #---------------------FUN-D10116--------------------(E)
    SELECT * INTO g_gxh.* FROM gxh_file WHERE gxh011 = g_gxh.gxh011
                                          AND gxh02 = g_gxh.gxh02
                                          AND gxh03 = g_gxh.gxh03
    IF g_gxh.gxh13 IS NOT NULL OR g_gxh.gxhglno IS NOT NULL THEN
       CALL cl_getmsg('aap-755',g_lang) RETURNING l_msg
       ERROR l_msg CLIPPED RETURN
    END IF
    BEGIN WORK
    LET g_success='Y'   #MOD-820160
    OPEN t830_cl USING g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
    IF STATUS THEN
       CALL cl_err("OPEN t830_cl:", STATUS, 1)
       CLOSE t830_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t830_cl INTO g_gxh.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxh.gxh011,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t830_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gxh011"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gxh.gxh011      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM gxh_file
              WHERE gxh011 = g_gxh.gxh011
                AND gxh02 = g_gxh.gxh02
                AND gxh03 = g_gxh.gxh03
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","gxh_file",g_gxh.gxh011,'',SQLCA.sqlcode,"","",1)  
          LET g_success='N'
       END IF
       LET l_trno=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
       LET l_cnt = 0  
       SELECT COUNT(*) INTO l_cnt FROM npp_file
          WHERE nppsys='NM'
            AND npp00=24
            AND npp01=l_trno
            AND npp011=1
       IF l_cnt > 0 THEN 
          DELETE FROM npp_file WHERE nppsys='NM'
                                 AND npp00=24
                                 AND npp01=l_trno
                                 AND npp011=1
          IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","npp_file",l_trno,'',SQLCA.sqlcode,"","",1)  
             LET g_success='N'
          END IF
       END IF   
       LET l_cnt = 0  
       SELECT COUNT(*) INTO l_cnt FROM npq_file
          WHERE npqsys='NM'
            AND npq00=24
            AND npq01=l_trno
            AND npq011=1
       IF l_cnt > 0 THEN
          DELETE FROM npq_file WHERE npqsys='NM'
                                 AND npq00=24
                                 AND npq01=l_trno
                                 AND npq011=1
          IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","npq_file",l_trno,'',SQLCA.sqlcode,"","",1)  
             LET g_success='N'
          END IF
       END IF   #MOD-830060

       #FUN-B40056--add--str--
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM tic_file WHERE tic04 = l_trno
       IF l_cnt > 0 THEN
          DELETE FROM tic_file WHERE tic04 = l_trno
          IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","tic_file",l_trno,'',SQLCA.sqlcode,"","",1)
             LET g_success='N'
          END IF
       END IF
       #FUN-B40056--add--end--

       CLEAR FORM
       OPEN t830_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE t830_cl
          CLOSE t830_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       FETCH t830_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t830_cl
          CLOSE t830_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t830_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t830_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t830_fetch('/')
       END IF
    END IF
    CLOSE t830_cl
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
 
#-----------------FUN-D10116---------------------(S)
FUNCTION t830_x()
   DEFINE  l_trno  LIKE type_file.chr50

   IF s_anmshut(0) THEN RETURN END IF
   IF cl_null(g_gxh.gxh011) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK

   OPEN t830_cl USING g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
   IF STATUS THEN
      CALL cl_err("OPEN t830_cl:", STATUS, 1)
      CLOSE t830_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t830_cl INTO g_gxh.*               # 對DB鎖定
   IF STATUS THEN
      CALL cl_err(g_gxh.gxh011,STATUS,0)
      CLOSE t830_cl
      ROLLBACK WORK
      RETURN
   END IF

   IF g_gxh.gxh15 = 'Y' THEN
      CALL cl_err(g_gxh.gxh011,'alm-870',2)
      CLOSE t830_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_gxh.gxh15) THEN
      IF g_gxh.gxh15 = 'N' THEN                        #切換為作廢
         LET l_trno=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
         DELETE FROM npp_file
          WHERE nppsys= 'NM'
            AND npp00 = 24
            AND npp01 = l_trno
            AND npp011 = 1
         IF STATUS THEN
            CALL cl_err3("del","npp_file",g_gxh.gxh011,"",SQLCA.sqlcode,"","",1)
         ELSE
            DELETE FROM npq_file
             WHERE npqsys= 'NM'
               AND npq00 = 24
               AND npq01 = l_trno
               AND npq011 = 1
            IF STATUS THEN
               CALL cl_err3("del","npq_file",g_gxh.gxh011,"",SQLCA.sqlcode,"","",1)
            END IF
         END IF
         LET g_gxh.gxh15 = 'X'
      ELSE                                             #取消作廢
         LET g_gxh.gxh15 = 'N'
      END IF
      UPDATE gxh_file SET gxh15 = g_gxh.gxh15
       WHERE gxh011 = g_gxh.gxh011
         AND gxh02 = g_gxh.gxh02
         AND gxh03 = g_gxh.gxh03
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","gxh_file",g_gxh.gxh011,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_gxh.gxh01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CLOSE t830_cl
   CALL t830_show()                      # 重新顯示
END FUNCTION
#-----------------FUN-D10116---------------------(E)

FUNCTION t830_out()
 DEFINE l_i             LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
        l_za05          LIKE type_file.chr50,   #No.FUN-680107 VARCHAR(40)
        l_gxf           RECORD LIKE  gxf_file.*,
        l_nma02         LIKE nma_file.nma02,
        sr              RECORD LIKE  gxh_file.*,                                            
        sr1             RECORD LIKE  gxf_file.*,                                  
        l_gxh11_r       LIKE gxh_file.gxh11,                                   
        l_gxh12_r       LIKE gxh_file.gxh12,                                   
        l_gxh12_tot     LIKE gxh_file.gxh12,                                   
        l_azi04         LIKE azi_file.azi04,                                   
        l_azi07         LIKE azi_file.azi07,      #FUN-8A0102 add
        l_gxh011_t      LIKE gxh_file.gxh011      #MOD-C10180 add 

    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN
    END IF
 
    CALL cl_del_data(l_table)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     
    LET g_sql="SELECT gxh_file.*,gxf_file.*,nma02 FROM gxh_file ",
              " LEFT JOIN nma_file ON gxh14=nma_file.nma01",
              " LEFT JOIN gxf_file ON gxh011=gxf_file.gxf011",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY gxh011,gxh02,gxh03"                        #MOD-C10180 add
    PREPARE t830_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t830_co  CURSOR FOR t830_p1
 
    #START REPORT t830_rep TO l_name      #No.FUN-830151
    LET l_gxh011_t = ' '                                            #MOD-C10180 add 
    FOREACH t830_co INTO g_gxh.*,l_gxf.*,l_nma02
       IF STATUS THEN CALL cl_err('fore t830_co:',STATUS,1) EXIT FOREACH END IF
       LET l_gxh11_r = 0                                                       
       LET l_gxh12_r = 0                                                       
       SELECT SUM(gxh11),SUM(gxh12) INTO l_gxh11_r,l_gxh12_r                   
         FROM gxh_file                                                         
       #WHERE gxh01 = g_gxh.gxh01                                        #MOD-C10180 mark
        WHERE gxh011 = g_gxh.gxh011                                      #MOD-C10180 add 
          AND (gxh13 IS NULL OR gxh13 = ' ')                                   
       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_gxf.gxf24         
       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=g_gxh.gxh09         
       SELECT azi07 INTO l_azi07 FROM azi_file WHERE azi01=g_gxh.gxh09   #FUN-8A0102 add
       LET l_gxh12_tot = 0                                                     
       SELECT SUM(gxh12) INTO l_gxh12_tot                                      
         FROM gxh_file                                                         
        WHERE (gxh13 IS NULL OR gxh13 = ' ')                                   
      #---------------------------------MOD-C10180------------------------start
       IF cl_null(l_gxh11_r) THEN LET l_gxh11_r = 0 END IF
       IF cl_null(l_gxh12_r) THEN LET l_gxh12_r = 0 END IF
       IF cl_null(l_gxh12_tot) THEN LET l_gxh12_tot = 0 END IF
       IF l_gxh011_t = g_gxh.gxh011 THEN
          LET l_gxh11_r = 0
          LET l_gxh12_r = 0
       END IF
       LET l_gxh011_t = g_gxh.gxh011
      #---------------------------------MOD-C10180--------------------------end
       EXECUTE insert_prep USING
          g_gxh.gxh011, #MOD-980092      
          g_gxh.gxh01,g_gxh.gxh02,g_gxh.gxh03,g_gxh.gxh14,l_nma02,
          l_gxf.gxf24,l_gxf.gxf021,l_gxf.gxf26,l_gxf.gxf03,l_gxf.gxf05,
          g_gxh.gxh05,g_gxh.gxh06,g_gxh.gxh07,g_gxh.gxh12,g_gxh.gxh13,
          g_gxh.gxh11,g_gxh.gxh09,g_gxh.gxh10,   #FUN-8A0102 add gxh10
          l_gxh11_r,l_gxh12_r,l_gxh12_tot,t_azi04,l_azi04,l_azi07   #FUN-8A0102 add l_azi07
    END FOREACH
 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'gxh011,gxh01,gxh02,gxh03,gxh13,gxhglno,gxh15,gxh14,  
                     gxh05,gxh06,gxh07,gxh08,gxh09,gxh10,gxh11,gxh12 ')         
            RETURNING g_str                                                     
    END IF                                                                      
    LET g_str = g_str,";",g_azi04                                               
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED          
    CALL cl_prt_cs3('anmt830','anmt830',l_sql,g_str)                            
END FUNCTION
 
FUNCTION t830_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gxh011,gxh02,gxh03",TRUE)     #No:8675   #TQC-610043
   END IF
END FUNCTION
 
FUNCTION t830_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gxh011,gxh02,gxh03",FALSE)    #No:8675   #TQC-610043
   END IF
END FUNCTION
 
 
FUNCTION t830_v(p_trno,p_npptype)
 DEFINE p_npptype LIKE npp_file.npptype     #No.FUN-680088
 DEFINE l_n       LIKE type_file.num10,     #No.FUN-680107 INTEGER
        g_npp     RECORD LIKE npp_file.*,
        g_npq     RECORD LIKE npq_file.*,
        p_trno    LIKE type_file.chr50,     #No.FUN-680107 VARCHAR(22)
        l_nms71   LIKE nms_file.nms71,
        l_nms70   LIKE nms_file.nms70,
 l_bdate,l_edate  LIKE type_file.dat        #No.FUN-680107 DATE
 DEFINE l_nmydmy3 LIKE nmy_file.nmydmy3     #MOD-830060
 DEFINE l_flag    LIKE type_file.chr1       #FUN-D40118 add
 
 #-------------------FUN-D10116-------------(S)
  IF g_gxh.gxh15 = 'X' THEN
     CALL cl_err('','9024',0)
     RETURN
  END IF
 #-------------------FUN-D10116-------------(E)

 LET g_success = 'Y'      #No.FUN-680088
 SELECT * INTO g_gxh.* FROM gxh_file
    WHERE gxh011=g_gxh.gxh011 AND gxh02=g_gxh.gxh02 AND gxh03=g_gxh.gxh03
 LET l_nmydmy3=''
 LET g_t1 = s_get_doc_no(g_gxh.gxh011)                                                                                          
 SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file
   WHERE nmyslip = g_t1 
 IF l_nmydmy3 <>'Y' THEN
    RETURN
 END IF
 IF g_gxh.gxh011 IS NULL THEN 
    LET g_success = 'N'      #No.FUN-680088
    RETURN 
 END IF

#---------------------MOD-C20094-------------------start
 IF g_gxh.gxh15 = 'Y' THEN
    CALL cl_err(g_gxh.gxh011,'afa-350',1)
    LET g_success = 'N'
    RETURN
 END IF
#---------------------MOD-C20094---------------------end 

 IF NOT cl_null(g_gxh.gxhglno) THEN
    CALL cl_err(g_gxh.gxh011,'aap-122',1)
    LET g_success = 'N'      #No.FUN-680088
    RETURN
 END IF
 
 IF NOT cl_null(g_gxh.gxh13) THEN
    CALL cl_err(g_gxh.gxh011,'anm-038',1)
    LET g_success = 'N'      #No.FUN-680088
    RETURN
 END IF
 
 #FUN-B50090 add begin-------------------------
 #重新抓取關帳日期
 SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
 #FUN-B50090 add -end--------------------------
 IF g_gxh.gxh05 <= g_nmz.nmz10 THEN
    CALL cl_err(g_gxh.gxh011,'aap-176',1)
    LET g_success = 'N'      #No.FUN-680088
    RETURN
 END IF
 IF g_gxh.gxh06 <= g_nmz.nmz10 THEN
    CALL cl_err(g_gxh.gxh011,'aap-176',1)
    LET g_success = 'N'      #No.FUN-680088
    RETURN
 END IF
 
 SELECT COUNT(*) INTO l_n FROM npq_file
  WHERE npqsys='NM' AND npq00=24 AND npq01=p_trno AND npq011=1   #MOD-640499
 IF l_n > 0 THEN
    IF p_npptype ='0' THEN      #No.FUN-680088
       IF NOT s_ask_entry(g_gxh.gxh011) THEN
          LET g_success = 'N'      #No.FUN-680088
          RETURN
       END IF
       #FUN-B40056--add--str--
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM tic_file
        WHERE tic04 = p_trno
       IF l_n > 0 THEN
          IF NOT cl_confirm('sub-533') THEN
             LET g_success = 'N' 
             RETURN
          END IF
       END IF
       #FUN-B40056--add--end--
    END IF      #No.FUN-680088
 END IF

 #FUN-B40056--add--str--
 DELETE FROM tic_file WHERE tic04 = p_trno
 #FUN-B40056--add--end-- 

 DELETE FROM npp_file
  WHERE nppsys = 'NM'
    AND npp00 = 24   #MOD-640499
    AND npp01 = p_trno
    AND npp011 = 1
    AND npptype = p_npptype      #No.FUN-680088
 
 DELETE FROM npq_file
  WHERE npqsys = 'NM'
    AND npq00 = 24   #MOD-640499
    AND npq01 = p_trno
    AND npq011 = 1
    AND npqtype = p_npptype      #No.FUN-680088
 
 INITIALIZE g_npp.* TO NULL
 LET g_npp.nppsys='NM'
 LET g_npp.npp00=24   #MOD-640499
 LET g_npp.npp01=p_trno
 LET g_npp.npp011=1
 LET g_npp.npptype = p_npptype      #No.FUN-680088
 IF g_aza.aza63 = 'Y' THEN
    IF p_npptype = '0' THEN
       CALL s_azmm01(g_gxh.gxh02,g_gxh.gxh03,g_nmz.nmz02p,g_nmz.nmz02b) RETURNING l_bdate,l_edate
    ELSE
       CALL s_azmm01(g_gxh.gxh02,g_gxh.gxh03,g_nmz.nmz02p,g_nmz.nmz02c) RETURNING l_bdate,l_edate
    END IF
 ELSE
    CALL s_azn01(g_gxh.gxh02,g_gxh.gxh03) RETURNING l_bdate,l_edate
 END IF
 LET g_npp.npp02=l_edate
 
 LET g_npp.npplegal= g_legal
 INSERT INTO npp_file VALUES(g_npp.*)
 IF SQLCA.sqlcode THEN
    CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","insert npp_file",1)  #No.FUN-660148
    LET g_success = 'N'      #No.FUN-680088
    RETURN
 ELSE
    DISPLAY g_npp.npp00 TO FORMONLY.npp00
    DISPLAY g_npp.npp01 TO FORMONLY.npp01
 END IF
 
 IF p_npptype = '0' THEN
    SELECT nms71,nms70 INTO l_nms71,l_nms70 FROM nms_file
     WHERE nms01=' ' OR nms01 IS NULL
 ELSE
    SELECT nms711,nms701 INTO l_nms71,l_nms70 FROM nms_file
     WHERE nms01=' ' OR nms01 IS NULL
 END IF
 
 CALL s_get_bookno(g_gxh.gxh02) RETURNING g_flag,g_bookno1,g_bookno2
 IF g_flag = '1' THEN
    CALL cl_err(g_gxh.gxh02,'aoo-081',1)
 END IF
 IF p_npptype = '0' THEN
    LET g_bookno = g_bookno1
 ELSE
    LET g_bookno = g_bookno2
 END IF
 
 INITIALIZE g_npq.* TO NULL
 LET g_npq.npqsys = g_npp.nppsys
 LET g_npq.npq00  = g_npp.npp00
 LET g_npq.npq01  = g_npp.npp01
 LET g_npq.npq011 = g_npp.npp011
 
 LET g_npq.npq02=1
 LET g_npq.npq06='1'
 LET g_npq.npq07f=g_gxh.gxh11
 LET g_npq.npq07=g_gxh.gxh12
 LET g_npq.npq24=g_gxh.gxh09
 LET g_npq.npq25=g_gxh.gxh10
 LET g_npq.npq03=l_nms71
 LET g_npq.npqtype = p_npptype      #No.FUN-680088
 LET g_npq.npq04=''
 CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03,g_bookno)
      RETURNING g_npq.*
 CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34     #FUN-AA0087
 LET g_npq.npqlegal= g_legal
 #FUN-D40118--add--str--
 SELECT aag44 INTO g_aag44 FROM aag_file
  WHERE aag00 = g_bookno
    AND aag01 = g_npq.npq03
 IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
    CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
    IF l_flag = 'N'   THEN
        LET g_npq.npq03 = ''
    END IF
 END IF
 #FUN-D40118--add--end--
 INSERT INTO npq_file VALUES(g_npq.*)
 IF SQLCA.sqlcode THEN
    CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,SQLCA.sqlcode,"","insert npq_file",1)  #No.FUN-660148
    LET g_success = 'N'      #No.FUN-680088
    RETURN
 END IF
 
 
 LET g_npq.npq02=g_npq.npq02+1
 LET g_npq.npq06='2'
 LET g_npq.npq07f=g_gxh.gxh11
 LET g_npq.npq07=g_gxh.gxh12
 LET g_npq.npq24=g_gxh.gxh09
 LET g_npq.npq25=g_gxh.gxh10
 LET g_npq.npq03=l_nms70
 LET g_npq.npq04=''
 CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03,g_bookno)
      RETURNING g_npq.*
 
 CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34     #FUN-AA0087
 LET g_npq.npqlegal= g_legal
 #FUN-D40118--add--str--
 SELECT aag44 INTO g_aag44 FROM aag_file
  WHERE aag00 = g_bookno
    AND aag01 = g_npq.npq03
 IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
    CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
    IF l_flag = 'N'   THEN
        LET g_npq.npq03 = ''
    END IF
 END IF
 #FUN-D40118--add--end--
 INSERT INTO npq_file VALUES(g_npq.*)
 IF SQLCA.sqlcode THEN
    CALL cl_err3("ins","npq_file",g_npp.npp00,g_npp.npp01,SQLCA.sqlcode,"","insert npq_file",1)  #No.FUN-660148
    LET g_success = 'N'      #No.FUN-680088
    RETURN
 END IF
 CALL cl_err('','aap-055',0)   #MOD-640499
 CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021   
END FUNCTION
 
FUNCTION t830_firm1()
DEFINE l_n             LIKE type_file.num5     #No.FUN-670060  #No.FUN-680107 SMALLINT
DEFINE l_bdate,l_edate LIKE type_file.dat      #No.FUN-680107 DATE #No.FUN-670060
DEFINE l_npp01 LIKE npp_file.npp01             #No.MOD-740431
DEFINE l_npp00 LIKE npp_file.npp00             #No.MOD-740431
DEFINE l_cnt   LIKE type_file.num5             #No.MOD-740431
 
  SELECT * INTO g_gxh.* FROM gxh_file WHERE gxh011 = g_gxh.gxh011 AND gxh02 = g_gxh.gxh02 AND gxh03 = g_gxh.gxh03
 
  IF g_gxh.gxh15 = 'Y' THEN
     RETURN
  END IF
 #---------------FUN-D10116--------(S)
  IF g_gxh.gxh15 = 'X' THEN
     CALL cl_err('','9024',0)
     RETURN
  END IF
 #---------------FUN-D10116--------(E)

  LET l_npp01=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
  LET l_npp00='24'
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM npp_file WHERE npp01  = l_npp01 AND
                                                 npp00  = l_npp00 AND
                                                 nppsys = 'NM' AND
                                                 npp011  = 1
  IF l_cnt = 0 THEN
     LET l_npp01 = ' '
  END IF
  IF cl_null(l_npp01) THEN
     CALL cl_err('','anm-321',1)
     RETURN
  END IF
 
  IF NOT cl_confirm('axm-108') THEN RETURN END IF
  LET g_success = 'Y'
  BEGIN WORK
  OPEN t830_cl USING g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
  IF STATUS THEN
     CALL cl_err("OPEN t830_cl:", STATUS, 1)
     CLOSE t830_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t830_cl INTO g_gxh.*               # 對DB鎖定
  IF STATUS THEN
     CALL cl_err(g_gxh.gxh011,STATUS,0)
     ROLLBACK WORK
     RETURN
  END IF
  #檢查分錄底稿平衡正確否
  LET p_trno=g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'
 
 
  LET g_t1 = s_get_doc_no(g_gxh.gxh011)                                                                                          
  SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = g_t1 
  IF SQLCA.sqlcode THEN                                                                                                         
     CALL cl_err3("sel","nmy_file",g_t1,"",STATUS,"","sel nmydmy3:",1)  
     LET g_success='N'                                                                                                          
  END IF  
  IF g_nmy.nmyglcr = 'N' THEN 
     CALL t830_chknpq(p_trno,'NM',1,'0',g_bookno1)    #No.TQC-760008  
     IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
        CALL t830_chknpq(p_trno,'NM',1,'1',g_bookno2) #No.TQC-760008 
     END IF
  END IF
  IF g_nmy.nmyglcr = 'Y' THEN 
     SELECT COUNT(*) INTO l_n FROM npq_file 
      WHERE npqsys= 'NM'
        AND npq00 = 24
        AND npq01 = p_trno
        AND npq011=1
     IF l_n = 0 THEN
        CALL t830_gen_glcr(g_gxh.*,g_nmy.*)
     END IF
     IF g_success = 'Y' THEN 
        CALL t830_chknpq(p_trno,'NM',1,'0',g_bookno1)    #No.TQC-760008  
        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           CALL t830_chknpq(p_trno,'NM',1,'1',g_bookno2) #No.TQC-760008 
        END IF
     END IF
  END IF 
  CALL s_showmsg()                         #No.MOD-740431 
  IF g_success = 'N' THEN
     ROLLBACK WORK
     RETURN
  END IF
  UPDATE gxh_file SET gxh15 = 'Y' WHERE gxh011 = g_gxh.gxh011 AND gxh02 = g_gxh.gxh02 AND gxh03 = g_gxh.gxh03
  IF g_success = 'Y' THEN
     COMMIT WORK
     LET g_gxh.gxh15 = 'Y'
     DISPLAY BY NAME g_gxh.gxh15
    #CALL cl_set_field_pic(g_gxh.gxh15,"","","","","")        #FUN-D10116 mark
     CALL cl_set_field_pic(g_gxh.gxh15,"","","",g_void,"")    #FUN-D10116 add
  ELSE
     ROLLBACK WORK
  END IF
  CALL s_azn01(g_gxh.gxh02,g_gxh.gxh03) RETURNING l_bdate,l_edate
  IF g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
     LET g_wc_gl = 'npp01 = "',p_trno,'" AND npp011 = 1'
     LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",l_edate,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
     CALL cl_cmdrun_wait(g_str) 
     SELECT gxhglno INTO g_gxh.gxhglno FROM gxh_file                                                                 
      WHERE gxh011 = g_gxh.gxh011                                                                                                    
        AND gxh02  = g_gxh.gxh02       #MOD-D50056 add
        AND gxh03  = g_gxh.gxh03       #MOD-D50056 add
     DISPLAY BY NAME g_gxh.gxhglno
  END IF                                                                                                                           
END FUNCTION
 
FUNCTION t830_chknpq(p_no,p_sys,p_npq011,p_npptype,p_bookno)  #No.TQC-760008 
  DEFINE p_npptype  LIKE npp_file.npptype  #No.FUN-680088
  DEFINE p_no       LIKE npq_file.npq01,   #No.FUN-680107 VARCHAR(22)
         p_sys      LIKE ooy_file.ooytype, #No.FUN-680107 VARCHAR(2)
         p_npq011   LIKE npq_file.npq011,
         p_bookno   LIKE aaa_file.aaa01,   #No.TQC-760008
         l_count    LIKE type_file.num5,   #No.FUN-680107 SMALLINT
         amtd,amtc  LIKE npq_file.npq07,
         l_npp      RECORD LIKE npp_file.*,
         l_npq      RECORD LIKE npq_file.*,
         l_aag      RECORD LIKE aag_file.*,
         l_aaz72    LIKE aaz_file.aaz72,
         l_azn02    LIKE azn_file.azn02,
         l_azn04    LIKE azn_file.azn04,
         l_afb04    LIKE afb_file.afb04,
         l_afb15    LIKE afb_file.afb15,
         l_afb041   LIKE afb_file.afb041,  #FUN-810069
         l_afb042   LIKE afb_file.afb042,  #FUN-810069
         l_bookno   LIKE apz_file.apz02b,
         l_flag     LIKE type_file.num10,  #No.FUN-680107 INTEGER
         l_afb07    LIKE afb_file.afb07,
         l_amt      LIKE npq_file.npq07,
         l_aag05    LIKE aag_file.aag05,
         l_tol      LIKE npq_file.npq07,
         l_tol1     LIKE npq_file.npq07,
         l_buf      LIKE type_file.chr50,  #No.FUN-680107 VARCHAR(40)
         l_buf1     LIKE type_file.chr50,  #No.FUN-680107 VARCHAR(40)
         total_t    LIKE npq_file.npq07,
         l_cnt      LIKE type_file.num5,   #No.FUN-680107 SMALLINT
         l_dept     LIKE gem_file.gem01,
         l_sql      STRING
        ,n1         LIKE type_file.num5     #TQC-AB0300 
 
 
  #取總帳系統參數
  LET l_sql = "SELECT aaz72  FROM ",
              "aaz_file WHERE aaz00 = '0' "
  PREPARE chk_pregl FROM l_sql
  DECLARE chk_curgl CURSOR FOR chk_pregl
  OPEN chk_curgl
  FETCH chk_curgl INTO l_aaz72
  IF SQLCA.sqlcode THEN LET l_aaz72 = '1' END IF
 
  IF p_npptype = '0' THEN
     SELECT nmz02b INTO l_bookno FROM nmz_file
      WHERE nmz00 = '0'
  ELSE
     SELECT nmz02c INTO l_bookno FROM nmz_file
      WHERE nmz00 = '0'
  END IF
 
 
  LET l_count = 0
  SELECT COUNT(*) INTO l_count FROM npq_file
     WHERE npq01 = p_no AND npqsys = p_sys AND npq011 = p_npq011
       AND npqtype = p_npptype      #No.FUN-680088
  IF l_count = 0 THEN
     CALL cl_err(p_no,'aap-995',1)
     LET g_success = 'N'
  END IF
 
  SELECT sum(npq07) INTO amtd FROM npq_file
         WHERE npq01 = p_no AND npq06 = '1' #--->借方合計
          AND npqsys = p_sys
          AND npq011 = p_npq011
          AND npqtype = p_npptype      #No.FUN-680088
  IF cl_null(amtd) THEN
     CALL cl_err(p_no,'aap-401',1)
     LET g_success='N'
  END IF
 
  SELECT sum(npq07) INTO amtc FROM npq_file
         WHERE npq01 = p_no AND npq06 = '2' #--->貸方合計
          AND npqsys = p_sys
          AND npq011 = p_npq011
          AND npqtype = p_npptype      #No.FUN-680088
  IF cl_null(amtc) THEN
     CALL cl_err(p_no,'aap-402',1)
     LET g_success='N'
  END IF
 
  #-->必須要有分錄
  IF (amtd = 0 OR amtc=0) THEN
     CALL cl_err(p_no,'aap-261',1) LET g_success='N'
  END IF
  #-->借貸要平
  IF amtd != amtc THEN
     CALL cl_err(p_no,'aap-058',1) LET g_success='N'
  END IF
 
 
  DECLARE npq_cur CURSOR FOR
   SELECT npq_file.*,aag_file.*
     FROM npq_file LEFT OUTER JOIN aag_file ON npq03 = aag01 AND aag00 = p_bookno
    WHERE npq01 = p_no
      AND npqsys = p_sys
      AND npq011 = p_npq011
      AND npqtype = p_npptype        #No.FUN-680088
    IF STATUS THEN CALL cl_err('decl cursor',STATUS,1)   
     LET g_success='N'
  END IF
 
  CALL s_showmsg_init()                #No.FUN-710024
  FOREACH npq_cur INTO l_npq.*,l_aag.*
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          

  #TQC-AB0300 ---add start------
  #對科目npq03做檢查,如果為空,則報錯
  SELECT count(*) INTO n1 FROM aag_file
   WHERE aag00 = p_bookno
     AND aag01 = l_aag.aag01
     AND aag03 = '2'   
     AND aag07 IN ('2','3')
  IF cl_null(n1) OR n1 = 0 THEN
     CALL s_errmsg('','',l_npq.npq03,"aap-401",1)
     LET g_success='N'
  END IF
  #TQC-AB0300 ---add end------------------

  #若科目有部門管理者,應check部門欄位
  IF l_aag.aag05='Y' THEN
     IF cl_null(l_npq.npq05) THEN
       #CALL s_errmsg('','',l_npq.npq03,"aap-278",1)  #No.FUN-710024 #MOD-C20067 mark
        CALL s_errmsg('','',l_npq.npq03,"aap-287",1)  #MOD-C20067 add
        LET g_success='N'
     END IF
     SELECT gem01 FROM gem_file WHERE gem01=l_npq.npq05
                                AND gemacti='Y'
     IF STATUS THEN
        CALL s_errmsg("gem01",l_npq.npq05,"SEL gem_file","aap-039",1)    #No.FUN-710024
        LET g_success='N'
     END IF
 
     #若有部門管理應Check其部門是否為拒絕部門
     IF l_aaz72 = '2' THEN
        SELECT COUNT(*) INTO l_cnt FROM aab_file
         WHERE aab01 = l_npq.npq03   #科目
           AND aab02 = l_npq.npq05   #部門
           AND aab00 = p_bookno      #No.TQC-760008
        IF l_cnt = 0 THEN
           LET g_showmsg = l_npq.npq03,"/",l_npq.npq05  #No.FUN-710024
           CALL s_errmsg('aab01,aab02',g_showmsg,l_npq.npq03,"agl-209",1) #No.FUN-710024
           LET g_success='N'
        END IF
     ELSE
        SELECT COUNT(*) INTO l_cnt FROM aab_file
         WHERE aab01 = l_npq.npq03   #科目
           AND aab02 = l_npq.npq05   #部門
           AND aab00 = p_bookno      #No.TQC-760008
        IF l_cnt > 0 THEN 
           LET g_showmsg=l_npq.npq03,"/",l_npq.npq05   #No.FUN-710024
           CALL s_errmsg("aab01,aab02",g_showmsg,"SEL aab_file","agl-207",1) #No.FUN-710024
           LET g_success='N'
        END IF
     END IF
  #針對不做部門管理,其部門應為空白
  ELSE
     IF NOT cl_null(l_npq.npq05) THEN
        LET g_showmsg=l_npq.npq03,"/",l_npq.npq05   #No.FUN-710024
        CALL s_errmsg("aab01,aab02",g_showmsg,"SEL aab_file","agl-216",1) #No.FUN-710024
        LET g_success='N'
     END IF
  END IF
 
  #若科目須做預算控制，預算編號不可空白(modi in 99/12/14 NO:0911)
  IF l_aag.aag21 = 'Y' THEN
          #考慮是否預算超限
          SELECT * INTO l_npp.* FROM npp_file WHERE npp01 = p_no
          IF g_aza.aza63 = 'Y' THEN
             SELECT aznn02,aznn04 INTO l_azn02,l_azn04  FROM aznn_file #No.FUN-830139 azn_file->aznn_file
              WHERE aznn01 = l_npp.npp02                               #No.FUN-830139 azn01->aznn01
                AND aznn00 = l_bookno
          ELSE
             SELECT azn02,azn04 INTO l_azn02,l_azn04  FROM azn_file
              WHERE azn01 = l_npp.npp02
          END IF
          IF cl_null(l_npq.npq05) THEN
             LET l_dept='@'
          ELSE
             LET l_dept = l_npq.npq05
          END IF
          IF cl_null(l_npq.npq08) THEN LET l_npq.npq08 = ' ' END IF #MOD-CB0152
          IF cl_null(l_npq.npq35) THEN LET l_npq.npq35 = ' ' END IF #MOD-CB0152
          SELECT afb04,afb15,afb041,afb042 INTO l_afb04,l_afb15,l_afb041,l_afb042   #FUN-810069
            FROM afb_file WHERE afb00 = l_bookno AND
                                afb01 = l_npq.npq36 AND               #No.FUN-830139
                                afb02 = l_npq.npq03 AND
                               #afb03 = l_azn02 AND afb04 = l_dept   #MOD-CB0152 mark
                                afb03 = l_azn02 AND afb041 = l_dept  #MOD-CB0152
                               #AND afb041 = l_npq.npq05 AND afb042 = l_npq.npq08        #FUN-810069  #MOD-CB0152 mark
                                AND afb04 = l_npq.npq35 AND afb042 = l_npq.npq08                      #MOD-CB0152
                                AND afbacti = 'Y'                                        #FUN-D70090
          IF SQLCA.sqlcode THEN
             LET g_showmsg=l_bookno,"/",l_npq.npq36,"/",l_npq.npq03,"/",l_azn02,"/",l_dept     #No.FUN-710024 #No.FUN-830139
             CALL s_errmsg("afb00,afb01,afb02,afb03,afb04",g_showmsg,"SEL afb_file",SQLCA.sqlcode,1)  #No.FUN-710024
          END IF
          IF l_aag.aag23 = 'N' THEN
             LET l_afb04 = ' '
             LET l_afb042 = ' '
          END IF
          CALL s_getbug1(l_bookno,l_npq.npq36,l_npq.npq03,
                        l_azn02,l_afb04,l_afb041,l_afb042,l_azn04,p_npptype)    #FUN-810069
               RETURNING l_flag,l_afb07,l_amt
          IF l_flag THEN CALL cl_err('','agl-139',1) END IF #若不成功
          IF l_afb07  != '1' THEN #要做超限控制
              SELECT aag05 INTO l_aag05 FROM aag_file
                 WHERE aag01 = l_npq.npq03
                   AND aag00 = p_bookno
              IF l_aag05 = 'Y' THEN
                 SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
                        WHERE npq01 = npp01
                          AND npq03 = l_npq.npq03
                          AND npq36 = l_npq.npq36 AND npq06 = '1' #借方 #No.FUN-830139
                          AND npq05 = l_npq.npq05
                          AND YEAR(npp02) = l_azn02
                          AND MONTH(npp02)= l_azn04
                          AND npqtype = p_npptype      #No.FUN-680088
                 IF SQLCA.sqlcode OR l_tol IS NULL THEN
                    LET l_tol = 0
                 END IF
                 SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
                        WHERE npq01 = npp01
                          AND npq03 = l_npq.npq03
                          AND npq36 = l_npq.npq36 AND npq06 = '2' #貸方 #No.FUN-830139
                          AND npq05 = l_npq.npq05
                          AND YEAR(npp02) = l_azn02
                          AND MONTH(npp02)= l_azn04
                          AND npqtype = p_npptype      #No.FUN-680088
                 IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
                    LET l_tol1 = 0
                 END IF
              ELSE
                 SELECT SUM(npq07) INTO l_tol FROM npq_file,npp_file
                        WHERE npq01 = npp01
                          AND npq03 = l_npq.npq03
                          AND npq36 = l_npq.npq36 AND npq06 = '1' #借方 #No.FUN-830139
                          AND YEAR(npp02) = l_azn02
                          AND MONTH(npp02)= l_azn04
                          AND npqtype = p_npptype      #No.FUN-680088
                 IF SQLCA.sqlcode OR l_tol IS NULL THEN
                    LET l_tol = 0
                 END IF
                 SELECT SUM(npq07) INTO l_tol1 FROM npq_file,npp_file
                        WHERE npq01 = npp01
                          AND npq03 = l_npq.npq03
                          AND npq36 = l_npq.npq36 AND npq06 = '2' #貸方 #No.FUN-830139
                          AND YEAR(npp02) = l_azn02
                          AND MONTH(npp02)= l_azn04
                          AND npqtype = p_npptype      #No.FUN-680088
                 IF SQLCA.sqlcode OR l_tol1 IS NULL THEN
                    LET l_tol1 = 0
                 END IF
              END IF
 
              IF l_aag.aag06 = '1' THEN #借餘
                    LET total_t = l_tol - l_tol1   #借減貸
              ELSE #貸餘
                    LET total_t = l_tol1 - l_tol   #貸減借
              END IF
              LET l_amt = l_amt + l_npq.npq07            #MOD-CB0152 add
             #IF total_t > l_amt THEN #借餘大於預算金額  #MOD-CB0152 mark
              IF l_npq.npq07 > l_amt THEN                #MOD-CB0152 add
                 CASE l_afb07
                      WHEN '2'
                           CALL cl_getmsg('agl-140',0) RETURNING l_buf
                           CALL cl_getmsg('agl-141',0) RETURNING l_buf1
                           ERROR l_npq.npq03 CLIPPED,' ',
                                 l_buf CLIPPED,' ',total_t,
                                 l_buf1 CLIPPED,' ',l_amt
                      WHEN '3'
                           CALL cl_getmsg('agl-142',0) RETURNING l_buf
                           CALL cl_getmsg('agl-143',0) RETURNING l_buf1    #No.FUN-830139 l_buf ->l_buf1
                           ERROR l_npq.npq03 CLIPPED,' ',
                                 l_buf CLIPPED,' ',total_t,
                                 l_buf1 CLIPPED,' ',l_amt
                           LET g_success='N'
                 END CASE
              END IF
          END IF
   END IF
   #若科目須做專案管理，專案編號不可空白
   IF l_aag.aag23 = 'Y' THEN
      IF cl_null(l_npq.npq08) THEN
         CALL s_errmsg('',l_npq.npq03,'',"agl-922",1)    #No.FUN-710024
         LET g_success='N'
      ELSE
          SELECT * FROM pja_file WHERE pja01 = l_npq.npq08 AND pjaacti = 'Y'    #FUN-810045
                                   AND pjaclose = 'N'                           #FUN-960038
          IF STATUS = 100 THEN
             CALL s_errmsg("pja01",l_npq.npq08,"SEL pja_file",SQLCA.sqlcode,1)   #No.FUN-710024     #FUN-810045 gja->pja
             LET g_success='N'
          END IF
      END IF
   END IF
 
 
   #若科目有異動碼管理者,應check異動碼欄位
   IF (l_aag.aag151='2' OR     #異動碼-1控制方式
      l_aag.aag151='3') AND    #   1:可輸入,  可空白
      cl_null(l_npq.npq11)     #   2.必須輸入,不需檢查
      THEN                 #   3.必須輸入, 必須檢查
      CALL s_errmsg('',l_npq.npq03,'',"aap-288",1)       #No.FUN-710024
      LET g_success='N'
   END IF
   IF (l_aag.aag161='2' OR     #異動碼-1控制方式
      l_aag.aag161='3') AND    #   1:可輸入,  可空白
      cl_null(l_npq.npq12)     #   2.必須輸入,不需檢查
      THEN                 #   3.必須輸入, 必須檢查
      CALL s_errmsg('',l_npq.npq03,'',"aap-288",1)     #No.FUN-710024
      LET g_success='N'
   END IF
   IF (l_aag.aag171='2' OR     #異動碼-1控制方式
      l_aag.aag171='3') AND    #   1:可輸入,  可空白
      cl_null(l_npq.npq13)     #   2.必須輸入,不需檢查
      THEN                 #   3.必須輸入, 必須檢查
      CALL s_errmsg('',l_npq.npq03,'',"aap-288",1)      #No.FUN-710024
      LET g_success='N'
   END IF
   IF (l_aag.aag181='2' OR     #異動碼-1控制方式
      l_aag.aag181='3') AND    #   1:可輸入,  可空白
      cl_null(l_npq.npq14)     #   2.必須輸入,不需檢查
      THEN                 #   3.必須輸入, 必須檢查
      CALL s_errmsg('',l_npq.npq03,'',"aap-288",1)      #No.FUN-710024
      LET g_success='N'
   END IF
 END FOREACH
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF                                                                                                                          
END FUNCTION
 
FUNCTION t830_firm2()
  DEFINE l_cnt        LIKE type_file.num10    #No.FUN-680107 INTEGER
  DEFINE l_aba19      LIKE aba_file.aba19     #No.FUN-670060
  DEFINE l_dbs        STRING                  #No.FUN-670060
  DEFINE l_sql        STRING
 
  SELECT * INTO g_gxh.* FROM gxh_file WHERE gxh011 = g_gxh.gxh011 AND gxh02 = g_gxh.gxh02 AND gxh03 = g_gxh.gxh03  #TQC-960335 add
 
  IF g_gxh.gxh15 = 'N' THEN
     RETURN
  END IF
 #---------------FUN-D10116--------(S)
  IF g_gxh.gxh15 = 'X' THEN
     CALL cl_err('','9024',0)
     RETURN
  END IF
 #---------------FUN-D10116--------(E)
  #MOD-C30704--add--str
  IF NOT cl_null(g_gxh.gxh13) THEN
     CALL cl_err(g_gxh.gxh011,'anm-191',0)
     RETURN
  END IF
  #MOD-C30704--add--end 
 
  #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原 
  CALL s_get_doc_no(g_gxh.gxh011) RETURNING g_t1
  SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
  IF NOT cl_null(g_gxh.gxhglno) THEN
     IF NOT (g_nmy.nmyglcr = 'Y') THEN
        CALL cl_err(g_gxh.gxh011,'axr-370',0) RETURN 
     END IF 
  END IF 
  IF g_nmy.nmyglcr = 'Y' THEN                                                                              
     #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
     LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                 "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                 "    AND aba01 = '",g_gxh.gxhglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
     PREPARE aba_pre FROM l_sql
     DECLARE aba_cs CURSOR FOR aba_pre
     OPEN aba_cs
     FETCH aba_cs INTO l_aba19
     IF l_aba19 = 'Y' THEN
        CALL cl_err(g_gxh.gxhglno,'axr-071',1)
        RETURN                                                                                                                     
     END IF                                                                                                                        
  END IF                                                                                                                           
  IF NOT cl_confirm('axm-109') THEN RETURN END IF
  LET g_success = 'Y'
 #--------------------------------CHI-C90051-----------------------------(S)
  IF g_nmy.nmyglcr = 'Y' AND g_nmy.nmydmy3 = 'Y' THEN
     LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxh.gxhglno,"' 'Y'"
     CALL cl_cmdrun_wait(g_str)
     SELECT gxhglno INTO g_gxh.gxhglno FROM gxh_file
      WHERE gxh011 = g_gxh.gxh011
        AND gxh02  = g_gxh.gxh02       #MOD-D50056 add
        AND gxh03  = g_gxh.gxh03       #MOD-D50056 add
     DISPLAY BY NAME g_gxh.gxhglno
     IF NOT cl_null(g_gxh.gxhglno) THEN
        CALL cl_err('','aap-929',0)
        RETURN
     END IF
  END IF
 #--------------------------------CHI-C90051-----------------------------(E)
  BEGIN WORK
  OPEN t830_cl USING g_gxh.gxh011,g_gxh.gxh02,g_gxh.gxh03
  IF STATUS THEN
     CALL cl_err("OPEN t830_cl:", STATUS, 1)
     CLOSE t830_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t830_cl INTO g_gxh.*               # 對DB鎖定
  IF STATUS THEN
     CALL cl_err(g_gxh.gxh011,STATUS,0)
     ROLLBACK WORK
     RETURN
  END IF
 
  IF g_success='N' THEN
     ROLLBACK WORK
     RETURN
  END IF
  UPDATE gxh_file SET gxh15 = 'N' WHERE gxh011 = g_gxh.gxh011 AND gxh02 = g_gxh.gxh02 AND gxh03 = g_gxh.gxh03
  IF g_success='Y' THEN
     COMMIT WORK
     LET g_gxh.gxh15 ='N'
     DISPLAY BY NAME g_gxh.gxh15
    #CALL cl_set_field_pic(g_gxh.gxh15,"","","","","")        #FUN-D10116 mark
     CALL cl_set_field_pic(g_gxh.gxh15,"","","",g_void,"")    #FUN-D10116 add
  ELSE
     ROLLBACK WORK
  END IF
 #--------------------------------CHI-C90051-----------------------------mark
 #IF g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN 
 #   LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxh.gxhglno,"' 'Y'"
 #   CALL cl_cmdrun_wait(g_str) 
 #   SELECT gxhglno INTO g_gxh.gxhglno FROM gxh_file 
 #    WHERE gxh011 = g_gxh.gxh011
 #   DISPLAY BY NAME g_gxh.gxhglno
 #END IF 
 #--------------------------------CHI-C90051-----------------------------mark
END FUNCTION
 
FUNCTION t830_gen_glcr(p_gxh,p_nmy)
  DEFINE p_gxh     RECORD LIKE gxh_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_gxh.gxh011,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t830_v(p_trno,'0')
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL t830_v(p_trno,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t830_carry_voucher()
  DEFINE l_nmygslp        LIKE nmy_file.nmygslp
  DEFINE li_result        LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_bdate,l_edate  LIKE type_file.dat      #No.FUN-680107 DATE  
  DEFINE l_dbs            STRING
  DEFINE l_sql            STRING
  DEFINE l_n              LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_gxh.gxhglno) OR g_gxh.gxhglno IS NOT NULL THEN
       CALL cl_err(g_gxh.gxhglno,'aap-618',1) 
       RETURN 
    END IF 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxh.gxh011) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxh.gxhglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_gxh.gxhglno,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1)  #FUN-940036
       RETURN
    END IF
    IF cl_null(l_nmygslp) OR (cl_null(g_nmy.nmygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680088
       CALL cl_err(g_gxh.gxh011,'axr-070',1)
       RETURN
    END IF
    LET p_trno = g_gxh.gxh011,g_gxh.gxh02 USING '&&&&',g_gxh.gxh03 USING '&#'             #MOD-C80053 add
    LET g_wc_gl = 'npp01 = "',p_trno,'" AND npp011 = 1'
    CALL s_azn01(g_gxh.gxh02,g_gxh.gxh03) RETURNING l_bdate,l_edate
    LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",l_edate,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str) 
     SELECT gxhglno INTO g_gxh.gxhglno FROM gxh_file 
      WHERE gxh011 = g_gxh.gxh011
        AND gxh02  = g_gxh.gxh02       #MOD-D50056 add
        AND gxh03  = g_gxh.gxh03       #MOD-D50056 add
     DISPLAY BY NAME g_gxh.gxhglno
END FUNCTION
 
FUNCTION t830_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING
 
    IF cl_null(g_gxh.gxhglno) OR g_gxh.gxhglno IS NULL THEN
       CALL cl_err(g_gxh.gxhglno,'aap-619',1)
       RETURN
    END IF 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF 
 
    CALL s_get_doc_no(g_gxh.gxhglno) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new   #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_gxh.gxhglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_gxh.gxh13,'axr-071',1)
       RETURN
    END IF
    LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxh.gxhglno,"' 'Y'"
    CALL cl_cmdrun_wait(g_str) 
    SELECT gxhglno INTO g_gxh.gxhglno FROM gxh_file 
     WHERE gxh011 = g_gxh.gxh011
       AND gxh02  = g_gxh.gxh02       #MOD-D50056 add
       AND gxh03  = g_gxh.gxh03       #MOD-D50056 add
    DISPLAY BY NAME g_gxh.gxhglno
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18
