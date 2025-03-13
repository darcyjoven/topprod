# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: anmt820.4gl
# Descriptions...: 定期存款單pledge/pledge解除維護作業
# Date & Author..: 99/05/06 by Iceman FOR TIPTOP 4.00
# Modify.........: 99/05/19 By Kammy
# Modify.........: No.9617 04/06/02 By Kitty 取消確認,判斷傳票號碼時要分質
#                                            押或解
 # Modify.........: No.MOD-470276 04/09/03 By Yuna
#                          1.執行質押作業,還沒有確認之前,更改資料時會累加異動序號
#                          2.異動序號不可輸入
#                          3.質押時,質押對象一定要輸入
#                          4.anmi820的質押傳票編號及日期應改成ref方式
#                          5.質押跟解除質押的按鈕拿掉,改成用新增方式
#                          6.解除質押時,質押日期要押前一筆的質押日期
#                          7.第二次質押時,不該輸入解除質押日期
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: NO.FUN-550057 05/05/30 By jackie 單據編號加大
# Modify.........: No.FUN-5B0092 05/11/29 By Smapmin 定期存款的科目應該先抓取定存銀行其anmi030的科目
#                                                    如果不存在才抓取參數的定存科目
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.MOD-610044 06/01/11 By Smapmin 定存資料顯示有誤
# Modify.........: No.TQC-610041 06/02/07 By Smapmin 本程式以本幣角度產生,故金額改抓 gxf26(本幣金額),
#                                                    產生分錄時幣別請抓取 aza17(本國幣別)
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670060 06/08/02 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-680088 06/08/28 By day 多帳套修改
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah s_def_npq()時,p_key2的地方改成傳gxg02
# Modify.........: No.FUN-710024 07/01/30 By cheunl錯誤訊息匯整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740028 07/04/10 By ARMAN 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810196 08/01/24 By Smapmin 增加分錄檢核
# Modify.........: No.MOD-840279 08/04/24 By bnlent  當質押解除的時候其金額可以修改
# Modify.........: No.FUN-850038 08/05/12 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-8A0204 08/10/29 By Sarah 1.將BEFORE FIELD gxg09的CALL t820_chkgxf()移到AFTER FIELD gxg09
#                                                  2.將BEFORE FIELD gxg09的LET g_gxg.gxg09 = g_today程式段mark掉
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-940285 09/04/22 By lilingyu 當性質(gxg021)為2.質押解除時,需檢查gxg05不可超過之前質押的金額
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.MOD-960131 09/06/10 By mike 當gxg021='2'時,gxg09為必輸欄位   
# Modify.........: No.MOD-980027 09/08/05 By mike after field gxg03 (質押日期)  若gxg021為解除質押時，不須做質押日期與關帳日期之檢核
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.MOD-990179 09/09/21 By mike 增加檢查有沒有分錄底稿       
# Modify.........: No.TQC-9B0162 09/11/19 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/07/13 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-AA0087 11/01/30 By chenmoyan 異動碼設定改善
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/06/07 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No:MOD-B80104 11/08/10 By johung t820_g_gl_1()進入貸方時，清空npq04
# Modify.........: No:TQC-C10011 12/01/04 By yinhy 狀態頁簽的“資料建立者”和“資料建立部門”欄位無法下查詢條件查詢
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30654 12/03/15 By Lori gxg09 要控卡不可小於gxg03，當輸入日期小於時要提示訊息(anm1043)
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No:MOD-CA0030 12/10/04 By Polly  當性質(gxg021)='1'時,不可輸入解除日期(gxg09)
# Modify.........: No:FUN-D10116 13/03/07 By Polly 增加作廢功能
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_gxg                  RECORD LIKE gxg_file.*,#定期存單資料檔
    g_gxg_t                RECORD LIKE gxg_file.*,
    g_gxg_o                RECORD LIKE gxg_file.*,
    g_gxf                  RECORD LIKE gxf_file.*,#定期存單資料檔
    g_gxf_t                RECORD LIKE gxf_file.*,
    g_gxf_o                RECORD LIKE gxf_file.*,
    g_gxg011_t             LIKE gxg_file.gxg011,
    g_gxg02_t              LIKE gxg_file.gxg02,
    g_dbs_gl               LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
    g_plant_gl             LIKE type_file.chr21,  #No.FUN-980059 VARCHAR(21)
    b_gxg                  RECORD LIKE gxg_file.*,
    g_wc,g_sql             STRING, #No.FUN-580092 HCN 
    l_code                 LIKE azo_file.azo06,   #ze01:錯誤訊息代號 #NO.FUN-680107 VARCHAR(7)
    l_stat                 LIKE cre_file.cre08,   #NO.FUN-680107 VARCHAR(10)
    g_nmydmy1              LIKE nmy_file.nmydmy1, #MOD-AC0073
    g_nmydmy3              LIKE nmy_file.nmydmy3, #MOD-AC0073
    g_buf                  LIKE type_file.chr20   #No.FUN-680107 VARCHAR(20)
 
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done STRING
 
DEFINE   g_chr           LIKE type_file.chr2          #No.FUN-680107 VARCHAR(2)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE   g_t1            LIKE oay_file.oayslip        #No.FUN-670060 #No.FUN-680107 VARCHAR(5)
DEFINE   g_str           STRING                       #No.FUN-670060
DEFINE   g_wc_gl         STRING                       #No.FUN-670060
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE   g_void          LIKE type_file.chr1          #FUN-D10116 add
DEFINE   g_aag44         LIKE aag_file.aag44          #FUN-D40118 add

MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0082
DEFINE          l_za05        LIKE type_file.chr1000       #No.FUN-680107   VARCHAR(40)
    DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680107
 
    OPTIONS                                     #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
    INITIALIZE g_gxg.* TO NULL
    INITIALIZE g_gxg_t.* TO NULL
    INITIALIZE g_gxg_o.* TO NULL
    LET g_plant_new = g_nmz.nmz02p
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
    LET g_plant_gl = g_nmz.nmz02p    #No.FUN-980059
    LET g_forupd_sql = "SELECT * FROM gxg_file WHERE gxg011 = ? AND gxg02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t820_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW t820_w AT p_row,p_col
        WITH FORM "anm/42f/anmt820"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
      LET g_action_choice=""
    CALL t820_menu()
 
    CLOSE WINDOW t820_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t820_cs()
    CLEAR FORM
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   INITIALIZE g_gxg.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        gxg021,gxg011,gxgconf,gxg01, gxg02, gxg03 , gxg04, gxg05, gxg06, gxg07, gxg08,
        gxg09, gxg10, gxg11,
        gxguser, gxggrup, gxgmodu, gxgdate, gxgacti,
        gxgoriu, gxgorig,                            #TQC-C10011
        gxgud01,gxgud02,gxgud03,gxgud04,gxgud05,
        gxgud06,gxgud07,gxgud08,gxgud09,gxgud10,
        gxgud11,gxgud12,gxgud13,gxgud14,gxgud15
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(gxg011)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gxf"
                   LET g_qryparam.state= "c"
                   LET g_qryparam.default1 = g_gxg.gxg011
                   LET g_qryparam.default2 = g_gxg.gxg01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxg011
                   NEXT FIELD gxg011
              WHEN INFIELD(gxg02)   #原存銀行
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma"
                   LET g_qryparam.state= "c"
                   LET g_qryparam.default1 = g_gxg.gxg02
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO gxg02
                   NEXT FIELD gxg02
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
       	   CALL cl_qbe_select()
        ON ACTION qbe_save
	   CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gxguser', 'gxggrup')
 
    LET g_sql="SELECT gxg011,gxg02 FROM gxg_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY gxg011"
    PREPARE t820_prepare FROM g_sql             # RUNTIME 編譯
    DECLARE t820_cs                           # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t820_prepare
    LET g_sql =
        "SELECT COUNT(*) FROM gxg_file WHERE ",g_wc CLIPPED
    PREPARE t820_recount FROM g_sql
    DECLARE t820_count CURSOR FOR t820_recount
END FUNCTION
 
FUNCTION t820_menu()
  DEFINE      l_cmd    LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(30)
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            IF g_aza.aza63 != 'Y' THEN
               CALL cl_set_act_visible("maintain_entry2",FALSE)
            ELSE
               CALL cl_set_act_visible("maintain_entry2",TRUE)
            END IF
 
        ON ACTION insert
           LET g_action_choice = 'insert'
           IF cl_chk_act_auth() THEN
              CALL t820_a()
           END IF

        ON ACTION query
            LET g_action_choice = 'query'
            IF cl_chk_act_auth() THEN
                 CALL t820_q()
            END IF

        ON ACTION next
            CALL t820_fetch('N')

        ON ACTION previous
            CALL t820_fetch('P')

        ON ACTION modify
            LET g_action_choice = 'modify'
            IF cl_chk_act_auth() THEN
                 CALL t820_u()
            END IF

        ON ACTION delete
            LET g_action_choice = 'delete'
            IF cl_chk_act_auth() THEN
               CALL t820_r()
            END IF

        ON ACTION confirm
            LET g_action_choice = 'confirm'
            IF cl_chk_act_auth() THEN
               CALL t820_y()
              #CALL cl_set_field_pic(g_gxg.gxgconf,"","","","","")          #FUN-D10116 mark
               CALL cl_set_field_pic(g_gxg.gxgconf,"","","",g_void,"")      #FUN-D10116 add
            END IF

        ON ACTION undo_confirm
            LET g_action_choice = 'undo_confirm'
            IF cl_chk_act_auth() THEN
               CALL t820_z()
              #CALL cl_set_field_pic(g_gxg.gxgconf,"","","","","")          #FUN-D10116 mark
               CALL cl_set_field_pic(g_gxg.gxgconf,"","","",g_void,"")      #FUN-D10116 add
            END IF

       #--------------FUN-D10116---------------(S)
        ON ACTION void
           LET g_action_choice = "void"
           IF cl_chk_act_auth() THEN
              CALL t820_x()
              IF g_gxg.gxgconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_gxg.gxgconf,"","","",g_void,"")
           END IF
       #--------------FUN-D10116---------------(E)

        ON ACTION carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_gxg.gxgconf ='Y'  THEN
                 CALL t820_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
              END IF
           END IF

        ON ACTION undo_carry_voucher
           IF cl_chk_act_auth() THEN
              IF g_gxg.gxgconf ='Y'  THEN
                 CALL t820_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
              END IF
           END IF

        ON ACTION gen_entry
            LET g_action_choice = 'gen_entry'
            IF cl_chk_act_auth() THEN
               IF g_gxg.gxg021 = '1' THEN
                  CALL t820_g_gl(g_gxg.gxg011,4,g_gxg.gxg02)
               ELSE
                  CALL t820_g_gl(g_gxg.gxg011,5,g_gxg.gxg02)
               END IF
            END IF

        ON ACTION maintain_entry
            LET g_action_choice = 'maintain_entry'
            IF cl_chk_act_auth() THEN
               IF g_gxg.gxg021 = '1' THEN
                  CALL s_showmsg_init()                     #No.FUN-710024
                  CALL s_fsgl('NM',4,g_gxg.gxg011,g_gxg.gxg05,
                              g_nmz.nmz02b,g_gxg.gxg02,g_gxg.gxgconf,'0',g_nmz.nmz02p)
                  CALL cl_navigator_setting( g_curs_index, g_row_count )
                  CALL t820_npp02('4','0') 
                  CALL s_showmsg()                     #No.FUN-710024
               ELSE
                  CALL s_showmsg()                     #No.FUN-710024
                  CALL s_fsgl('NM',5,g_gxg.gxg011,g_gxg.gxg09,
                              g_nmz.nmz02b,g_gxg.gxg02,g_gxg.gxgconf,'0',g_nmz.nmz02p)
                  CALL cl_navigator_setting( g_curs_index, g_row_count )
                  CALL t820_npp02('5','0')
                  CALL s_showmsg()                     #No.FUN-710024
               END IF
            END IF
          
        ON ACTION maintain_entry2
            LET g_action_choice = 'maintain_entry2'
            IF cl_chk_act_auth() THEN
               IF g_gxg.gxg021 = '1' THEN
                  CALL s_showmsg_init()                     #No.FUN-710024
                  CALL s_fsgl('NM',4,g_gxg.gxg011,g_gxg.gxg05,
                              g_nmz.nmz02c,g_gxg.gxg02,g_gxg.gxgconf,'1',g_nmz.nmz02p)
                  CALL cl_navigator_setting( g_curs_index, g_row_count )
                  CALL t820_npp02('4','1') 
                  CALL s_showmsg()                     #No.FUN-710024
               ELSE
                  CALL s_showmsg_init()                     #No.FUN-710024
                  CALL s_fsgl('NM',5,g_gxg.gxg011,g_gxg.gxg09,
                              g_nmz.nmz02c,g_gxg.gxg02,g_gxg.gxgconf,'1',g_nmz.nmz02p)
                  CALL cl_navigator_setting( g_curs_index, g_row_count )
                  CALL t820_npp02('5','1')
                  CALL s_showmsg()                     #No.FUN-710024
               END IF
            END IF
 
        ON ACTION help
            CALL cl_show_help()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                                      #No.FUN-550037 hmf
          #CALL cl_set_field_pic(g_gxg.gxgconf,"","","","","")          #FUN-D10116 mark
           CALL cl_set_field_pic(g_gxg.gxgconf,"","","",g_void,"")      #FUN-D10116 add

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION jump
            CALL t820_fetch('/')

        ON ACTION first
            CALL t820_fetch('F')

        ON ACTION last
            CALL t820_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
      
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_gxg.gxg011 IS NOT NULL THEN
                 LET g_doc.column1 = "gxg011"
                 LET g_doc.value1 = g_gxg.gxg011
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
    CLOSE t820_cs
END FUNCTION
 
FUNCTION t820_a()
  DEFINE p_type     LIKE gxg_file.gxg021,   #NO.FUN-680107 VARCHAR(01)
         l_gxf11    LIKE gxf_file.gxf11
    IF s_anmshut(0) THEN RETURN END IF      #檢查權限
    MESSAGE ""
    CLEAR FORM                              # 清螢墓欄位內容
    INITIALIZE g_gxg.* LIKE gxg_file.*
    LET g_gxg011_t = NULL
    LET g_gxg_t.* = g_gxg.*                 # 保留舊值
    LET g_gxg_o.* = g_gxg.*                 # 保留舊值
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_gxg.gxg021  = '1'                 #性質
        LET p_type        = g_gxg.gxg021
        LET g_gxg.gxg03   = g_today             # 異動日期
        LET g_gxg.gxgacti = 'Y'                 # 有效的資料
        LET g_gxg.gxgconf = 'N'                 # confirm的資料
        LET g_gxg.gxguser = g_user              # 使用者
        LET g_gxg.gxgoriu = g_user #FUN-980030
        LET g_gxg.gxgorig = g_grup #FUN-980030
        LET g_gxg.gxggrup = g_grup              # 使用者所屬群
        LET g_gxg.gxgdate = g_today             # 更改日期
 
        LET g_gxg.gxglegal= g_legal
        CALL t820_i("a",p_type)                 # 各欄位輸入
        IF INT_FLAG THEN                        # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_gxg.gxg011 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        SELECT gxf11 INTO l_gxf11 FROM gxf_file WHERE gxf011 = g_gxg.gxg011
        IF SQLCA.sqlcode THEN CONTINUE WHILE END IF
        IF l_gxf11 = 0 OR l_gxf11 = 2 THEN
           LET g_gxg.gxg021 = '1'
        ELSE
           LET g_gxg.gxg021 = '2'
        END IF
        INSERT INTO gxg_file VALUES(g_gxg.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","gxg_file",g_gxg.gxg02,g_gxg.gxg011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
           CONTINUE WHILE
        ELSE
          #-MOD-AC0073-add-
           #---判斷是否立即confirm-----
           LET g_t1 = s_get_doc_no(g_gxg.gxg02)    
           SELECT nmydmy1,nmydmy3 INTO g_nmydmy1,g_nmydmy3
             FROM nmy_file
            WHERE nmyslip = g_t1 AND nmyacti = 'Y'
           IF g_nmydmy3 = 'Y' THEN
              IF cl_confirm('axr-309') THEN
                 IF g_gxg.gxg021 = '1' THEN
                    CALL t820_g_gl(g_gxg.gxg011,4,g_gxg.gxg02)
                 ELSE
                    CALL t820_g_gl(g_gxg.gxg011,5,g_gxg.gxg02)
                 END IF
              END IF
           END IF
           IF g_nmydmy1 = 'Y' THEN CALL t820_y() END IF
          #-MOD-AC0073-end-
           LET g_gxg_t.* = g_gxg.*              # 保存上筆資料
           SELECT gxg011,gxg02 INTO g_gxg.gxg011,g_gxg.gxg02 FROM gxg_file
            WHERE gxg011 = g_gxg.gxg011
              AND gxg02 = g_gxg.gxg02
        END IF
        CALL t820_show()
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t820_i(p_cmd,p_type)
    DEFINE p_cmd         LIKE type_file.chr1,    #狀態 #No.FUN-680107 VARCHAR(1)
           p_type        LIKE gxg_file.gxg021,   #NO.FUN-680107 VARCHAR(01)
           l_flag        LIKE type_file.chr1,    #是否必要欄位有輸入    #No.FUN-680107 VARCHAR(1)
           l_n,l_cnt     LIKE type_file.num5     #No.FUN-680107 SMALLINT 
    DEFINE l_gxg05       LIKE gxg_file.gxg05     #MOD-940285 
    
    INPUT BY NAME g_gxg.gxgoriu,g_gxg.gxgorig,
        g_gxg.gxg021,g_gxg.gxg011,g_gxg.gxg01, g_gxg.gxg02, g_gxg.gxg03,
        g_gxg.gxg04, g_gxg.gxg05, g_gxg.gxg06, g_gxg.gxg07, g_gxg.gxg08,
        g_gxg.gxg09, g_gxg.gxg10, g_gxg.gxg11, g_gxg.gxgacti,
        g_gxg.gxgud01,g_gxg.gxgud02,g_gxg.gxgud03,g_gxg.gxgud04,
        g_gxg.gxgud05,g_gxg.gxgud06,g_gxg.gxgud07,g_gxg.gxgud08,
        g_gxg.gxgud09,g_gxg.gxgud10,g_gxg.gxgud11,g_gxg.gxgud12,
        g_gxg.gxgud13,g_gxg.gxgud14,g_gxg.gxgud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t820_set_entry(p_cmd)
            CALL t820_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("gxg011")
         CALL cl_set_docno_format("gxg01")
 
        AFTER FIELD gxg011         #申請號碼
            IF NOT cl_null(g_gxg.gxg011) THEN
               #-->定存單尚未confirm則不可再輸入相同定存單
               IF p_cmd='a' THEN
                  SELECT COUNT(*) INTO l_cnt FROM gxg_file
                  WHERE gxg011=g_gxg.gxg011 AND gxgconf='N'
                  IF l_cnt >0
                  THEN CALL cl_err(g_gxg.gxg011,'anm-636',0) NEXT FIELD gxg011
                  END IF
               END IF
               IF p_cmd = "a" OR     # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_gxg.gxg011 != g_gxg011_t) THEN
                   CALL t820_gxg011('a',g_gxg.gxg021)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_gxg.gxg011,g_errno,0)
                      LET g_gxg.gxg011 = g_gxg_t.gxg011
                      DISPLAY BY NAME g_gxg.gxg011
                      NEXT FIELD gxg011
                   END IF
                   SELECT MAX(gxg02)+1 INTO g_gxg.gxg02
                      FROM gxg_file WHERE gxg011 = g_gxg.gxg011
                   IF cl_null(g_gxg.gxg02) THEN LET g_gxg.gxg02=1 END IF
                   DISPLAY g_gxg.gxg02 TO gxg02
                 IF g_gxg.gxg021 = '2' THEN  
                    SELECT gxg05 INTO l_gxg05 FROM gxg_file
                     WHERE gxg021 = '1'
                       AND gxg011 = g_gxg.gxg011
                       AND gxgconf = 'Y'
                       AND gxg02 IN(SELECT MAX(gxg02) FROM gxg_file
                                     WHERE gxg021 = '1'
                                       AND gxg011 = g_gxg.gxg011
                                       AND gxgconf = 'Y')
                    LET g_gxg.gxg05 = l_gxg05
                    DISPLAY BY NAME g_gxg.gxg05                     
                  END IF     
               END IF
               CALL t820_nma01('d')     #No:8135
            END IF
 
         BEFORE FIELD gxg03
            IF NOT cl_null(g_gxg.gxg011) THEN
               SELECT COUNT(*) INTO l_n FROM gxg_file
                WHERE gxg011 = g_gxg.gxg011
               IF l_n > 0 THEN                              #檢查gxg_file 重覆
                  SELECT COUNT(*) INTO l_n FROM gxf_file
                   WHERE gxf011 = g_gxg.gxg011
                     AND (gxf22 IS NULL OR gxf22 = ' ')
                     AND (gxf21 IS NOT NULL OR gxf21 <> ' ')
                  IF l_n > 0 THEN
                      IF g_gxg.gxg021 = '2' THEN   #No.MOD-470276
                         NEXT FIELD gxg09
                     END IF
                  END IF
               END IF
            END IF
 
         AFTER FIELD gxg03        #pledge日期
            IF g_gxg.gxg021 = '1' THEN #MOD-980027     
               #FUN-B50090 add begin-------------------------
               #重新抓取關帳日期
               SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
               #FUN-B50090 add -end--------------------------
               IF g_gxg.gxg03 <= g_nmz.nmz10 THEN #no.5261
                  CALL cl_err('','aap-176',1) NEXT FIELD gxg03
               END IF
            END IF #MOD-980027      
         AFTER FIELD gxg05        #pledge金額
            IF g_gxg.gxg05 <= 0 THEN
               CALL cl_err(g_gxg.gxg05,'anm-622',0) NEXT FIELD gxg05
            END IF
            IF g_gxg.gxg05 > g_gxf.gxf26 THEN   #TQC-610041
               CALL cl_err(g_gxg.gxg05,'anm-644',0) NEXT FIELD gxg05
            END IF
            IF NOT cl_null(g_gxg.gxg05) THEN 
              IF g_gxg.gxg021 = '2' THEN 
                SELECT gxg05 INTO l_gxg05 FROM gxg_file
                 WHERE gxg011 = g_gxg.gxg011
                   AND gxg021 = '1'
                   AND gxgconf = 'Y'  
                   AND gxg02 IN(SELECT MAX(gxg02) FROM gxg_file
                                 WHERE gxg011 = g_gxg.gxg011
                                   AND gxg021 = '1'
                                   AND gxgconf = 'Y')    
                 IF cl_null(l_gxg05) THEN LET l_gxg05 = 0 END IF             
                            
                 IF g_gxg.gxg05 > l_gxg05 THEN 
                   CALL cl_err('','anm-087',1)
                   NEXT FIELD gxg05 
                 END IF                            
              END IF 
            END IF 
 
         AFTER FIELD gxg06        #pledge性質

        #-----------------MOD-CA0030------------(S)
         AFTER FIELD gxg021              #性質
            CALL t820_set_entry(p_cmd)
            CALL t820_set_no_entry(p_cmd)
        #-----------------MOD-CA0030------------(E)
 
         BEFORE FIELD gxg09
            IF g_gxg.gxg10 IS NOT NULL THEN   #表已做過"pledge_removed傳票拋轉"
               LET g_errno = 'anm-620'
            END IF
 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0) NEXT FIELD gxg011
            END IF
 
         AFTER FIELD gxg09
            IF NOT cl_null(g_gxg.gxg09) THEN
               #No.MOD-C30654--Begin--
               IF g_gxg.gxg09 < g_gxg.gxg03 THEN
                  CALL cl_err('','anm1043',1)
                  NEXT FIELD gxg09
               END IF
               #No.MOD-C30654--End--
               IF NOT cl_null(g_gxg.gxg011) THEN
                  CALL t820_chkgxf(g_gxg.gxg011)
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0) NEXT FIELD gxg011
               END IF
            END IF
            IF g_gxg.gxg09 <= g_nmz.nmz10 THEN #no.5261
               CALL cl_err('','aap-176',1) NEXT FIELD gxg09
            END IF
 
         AFTER FIELD gxgud01
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud02
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud03
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud04
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud05
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud06
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud07
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud08
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud09
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud10
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud11
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud12
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud13
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud14
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         AFTER FIELD gxgud15
            IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER INPUT
       #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          LET g_gxg.gxguser = s_get_data_owner("gxg_file") #FUN-C10039
          LET g_gxg.gxggrup = s_get_data_group("gxg_file") #FUN-C10039
       LET l_flag='N'
       IF INT_FLAG THEN EXIT INPUT  END IF
       IF g_gxg.gxg011 IS NULL THEN
          LET l_flag='Y'
          DISPLAY BY NAME g_gxg.gxg011
       END IF
       IF g_gxg.gxg04 IS NULL AND g_gxg.gxg021 = '1' THEN   #質押時一定要輸入質押對象
          LET l_flag='Y'
          DISPLAY BY NAME g_gxg.gxg04
       END IF
       IF l_flag='Y' THEN
          CALL cl_err('','9033',0)
          IF p_cmd='a' THEN NEXT FIELD gxg011 END IF
          IF p_cmd='u' THEN NEXT FIELD gxg02 END IF
       END IF
       LET l_flag='N'                                                                                                               
       IF g_gxg.gxg021='2' AND g_gxg.gxg09 IS NULL THEN                                                                             
          LET l_flag='Y'                                                                                                            
          DISPLAY BY NAME g_gxg.gxg09                                                                                               
       END IF                                                                                                                       
       IF l_flag='Y' THEN                                                                                                           
          CALL cl_err('','9033',0)                                                                                                  
          IF p_cmd='a' THEN NEXT FIELD gxg09 END IF                                                                                 
          IF p_cmd='u' THEN NEXT FIELD gxg02 END IF                                                                                 
       END IF                                                                                                                       
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(gxg011)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gxf"
                   LET g_qryparam.default1 = g_gxg.gxg011
                   LET g_qryparam.default2 = g_gxg.gxg01
                   CALL cl_create_qry() RETURNING g_gxg.gxg011,g_gxg.gxg01
                   DISPLAY BY NAME g_gxg.gxg011,g_gxg.gxg01
                   NEXT FIELD gxg011
              WHEN INFIELD(gxg02)   #原存銀行
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma"
                   LET g_qryparam.default1 = g_gxg.gxg02
                   CALL cl_create_qry() RETURNING g_gxg.gxg02
                   DISPLAY BY NAME g_gxg.gxg02
                   NEXT FIELD gxg02
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
 
FUNCTION t820_gxg011(p_cmd,p_type)  #申請號碼
    DEFINE p_cmd          LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           p_type         LIKE gxg_file.gxg021,   #NO.FUN-680107 VARCHAR(1)
           l_gxf02        LIKE gxf_file.gxf02,
           l_gxf11        LIKE gxf_file.gxf11,
           l_gxf21        LIKE gxf_file.gxf21,    #MOD-470276(6)
           l_gxf26        LIKE gxf_file.gxf26,    #TQC-610041
           l_gxf03        LIKE gxf_file.gxf03,
           l_gxf05        LIKE gxf_file.gxf05,
           l_gxfconf      LIKE gxf_file.gxfconf,
           l_gxfacti      LIKE gxf_file.gxfacti
 
    LET g_errno = ' '
    SELECT gxf01,gxf02,gxf11,gxf21,gxf26,gxf03,gxf05,gxfacti,gxfconf
      INTO g_gxg.gxg01,l_gxf02,l_gxf11,l_gxf21,l_gxf26,l_gxf03,l_gxf05 ,l_gxfacti,l_gxfconf
      FROM gxf_file
     WHERE gxf011 = g_gxg.gxg011 AND gxf11 !='3' AND gxf11 !='4'
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-624'
                            LET g_gxg.gxg01= NULL
                            LET l_gxf02  = NULL LET l_gxf11 = NULL
                            LET l_gxf26 = NULL LET l_gxf03 = NULL   #TQC-610041
                            LET l_gxf05  = NULL
         WHEN l_gxfacti='N' LET g_errno = '9028'
         WHEN l_gxfconf='N' LET g_errno = '9029'   #No.+450
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN
       DISPLAY BY NAME g_gxg.gxg01
       DISPLAY l_gxf02  TO FORMONLY.gxf02
       DISPLAY l_gxf11  TO FORMONLY.gxf11
       DISPLAY l_gxf26 TO FORMONLY.gxf26  #TQC-610041
       DISPLAY l_gxf03  TO FORMONLY.gxf03
       DISPLAY l_gxf05  TO FORMONLY.gxf05
      RETURN
   END IF
    IF p_cmd ='a' THEN
       IF g_gxg.gxg021 = '2' THEN
          LET g_gxg.gxg03 = l_gxf21
          DISPLAY BY NAME g_gxg.gxg03
       END IF
       IF g_gxg.gxg021 = '2' AND l_gxf11 != '1'
       THEN LET g_errno = 'anm-645'  RETURN
       END IF
       IF g_gxg.gxg021 = '1' AND l_gxf11  = '1'
       THEN LET g_errno = 'anm-646'  RETURN
       END IF
    END IF
    IF p_cmd='d' OR cl_null(g_errno) THEN
       CALL t820_gxf11(l_gxf11)
       LET g_gxf.gxf02 = l_gxf02
       LET g_gxf.gxf11 = l_gxf11
       LET g_gxf.gxf26 = l_gxf26   #TQC-610041
       LET g_gxf.gxf03 = l_gxf03
       LET g_gxf.gxf05 = l_gxf05
       DISPLAY BY NAME g_gxg.gxg01
       DISPLAY l_gxf02  TO FORMONLY.gxf02
       DISPLAY l_gxf11  TO FORMONLY.gxf11
       DISPLAY l_gxf26 TO FORMONLY.gxf26    #TQC-610041
       DISPLAY l_gxf03  TO FORMONLY.gxf03
       DISPLAY l_gxf05  TO FORMONLY.gxf05
    END IF
END FUNCTION
 
FUNCTION t820_nma01(p_cmd)  #抓取銀行名稱
    DEFINE p_cmd        LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
           l_nma01      LIKE nma_file.nma01,
           l_nma02      LIKE nma_file.nma02,
           l_gxf02      LIKE gxf_file.gxf02,
           l_nmaacti    LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT gxf02 INTO l_gxf02 FROM gxf_file WHERE gxf011=g_gxg.gxg011
    SELECT nma02,nmaacti INTO l_nma02,l_nmaacti FROM nma_file
     WHERE nma01 = l_gxf02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                                   LET l_nma02 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY l_nma02 TO nma02_1
    END IF
END FUNCTION
 
FUNCTION t820_display()
  DEFINE l_gxg02  LIKE type_file.num5    #NO.FUN-680107 SMALLINT
 
  LET l_gxg02=g_gxg.gxg02-1
  SELECT gxg03,gxg04,gxg05,gxg06,gxg07,gxg08
    INTO g_gxg.gxg03, g_gxg.gxg04, g_gxg.gxg05,
         g_gxg.gxg06, g_gxg.gxg07, g_gxg.gxg08
    FROM gxg_file WHERE gxg011 =g_gxg.gxg011 AND gxg02 = l_gxg02
 
  DISPLAY BY NAME g_gxg.gxg03,g_gxg.gxg04, g_gxg.gxg05,
                  g_gxg.gxg06,g_gxg.gxg07, g_gxg.gxg08
END FUNCTION
 
FUNCTION t820_gxf11(l_gxf11)
    DEFINE l_gxf11 LIKE type_file.num5    #NO.FUN-680107 SMALLINT
    DEFINE l_code  LIKE zz_file.zz01      #NO.FUN-680107 VARCHAR(07)
    DEFINE l_str   LIKE type_file.chr20   #NO.FUN-680107 VARCHAR(10)
 
    CASE WHEN l_gxf11= 0 LET l_code = 'anm-613'     #存入
         WHEN l_gxf11= 1 LET l_code = 'anm-634'     #pledge
         WHEN l_gxf11= 2 LET l_code = 'anm-638'     #pledge_removed
         WHEN l_gxf11= 3 LET l_code = 'anm-614'     #解約
         OTHERWISE           LET l_code = ' '
    END CASE
    CALL cl_getmsg(l_code,g_lang) RETURNING g_msg
    LET l_str = g_msg[1,10]
    DISPLAY l_str TO sts
END FUNCTION
 
FUNCTION t820_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_gxg.* TO NULL              #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t820_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t820_count
    FETCH t820_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t820_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxg.gxg011,SQLCA.sqlcode,0)
        INITIALIZE g_gxg.* TO NULL
    ELSE
        CALL t820_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t820_fetch(p_flgxg)
    DEFINE
        p_flgxg     LIKE type_file.chr1,    #NO.FUN-680107 VARCHAR(1)
        l_abso      LIKE type_file.num10    #No.FUN-680107
 
    CASE p_flgxg
        WHEN 'N' FETCH NEXT     t820_cs INTO g_gxg.gxg011,g_gxg.gxg02
        WHEN 'P' FETCH PREVIOUS t820_cs INTO g_gxg.gxg011,g_gxg.gxg02
        WHEN 'F' FETCH FIRST    t820_cs INTO g_gxg.gxg011,g_gxg.gxg02
        WHEN 'L' FETCH LAST     t820_cs INTO g_gxg.gxg011,g_gxg.gxg02
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
            FETCH ABSOLUTE g_jump t820_cs INTO g_gxg.gxg011,g_gxg.gxg02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxg.gxg011,SQLCA.sqlcode,0)
        INITIALIZE g_gxg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flgxg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_gxg.* FROM gxg_file          # 重讀DB,因TEMP有不被更新特性
       WHERE gxg011 = g_gxg.gxg011 AND gxg02 = g_gxg.gxg02
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","gxg_file",g_gxg.gxg02,g_gxg.gxg011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_data_owner = g_gxg.gxguser     #No.FUN-4C0063
       LET g_data_group = g_gxg.gxggrup     #No.FUN-4C0063
       CALL t820_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t820_show()
  DEFINE l_gxf11  LIKE gxf_file.gxf11
    LET g_gxg_o.* = g_gxg.*
    LET g_gxg_t.* = g_gxg.*
    DISPLAY BY NAME g_gxg.gxgoriu,g_gxg.gxgorig,
        g_gxg.gxg011,g_gxg.gxg01, g_gxg.gxg02, g_gxg.gxg021, g_gxg.gxg03  ,
        g_gxg.gxg04, g_gxg.gxg05, g_gxg.gxg06, g_gxg.gxg07 , g_gxg.gxg08,
        g_gxg.gxg09, g_gxg.gxg10, g_gxg.gxg11 , g_gxg.gxgconf,
        g_gxg.gxguser, g_gxg.gxggrup, g_gxg.gxgmodu,g_gxg.gxgdate,
        g_gxg.gxgacti,
        g_gxg.gxgud01,g_gxg.gxgud02,g_gxg.gxgud03,g_gxg.gxgud04,
        g_gxg.gxgud05,g_gxg.gxgud06,g_gxg.gxgud07,g_gxg.gxgud08,
        g_gxg.gxgud09,g_gxg.gxgud10,g_gxg.gxgud11,g_gxg.gxgud12,
        g_gxg.gxgud13,g_gxg.gxgud14,g_gxg.gxgud15 
    CALL t820_nma01('d')
    CALL t820_gxg011('d','')
    SELECT gxf11 INTO l_gxf11 FROM gxf_file WHERE gxf011= g_gxg.gxg011
    DISPLAY l_gxf11 TO FORMONLY.gxf11
    CALL t820_gxf11(l_gxf11)
   #------------------------FUN-D10116---------------------------(S)
    IF g_gxg.gxgconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_gxg.gxgconf,"","","",g_void,"")
   #------------------------FUN-D10116---------------------------(E)
   #CALL cl_set_field_pic(g_gxg.gxgconf,"","","","","")          #FUN-D10116 mark
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t820_u()
    IF s_anmshut(0) THEN RETURN END IF                #檢查權限
    SELECT * INTO g_gxg.* FROM gxg_file WHERE gxg011 = g_gxg.gxg011 AND gxg02 = g_gxg.gxg02
    IF STATUS THEN 
       CALL cl_err3("sel","gxg_file",g_gxg.gxg02,g_gxg.gxg011,STATUS,"","",1)  #No.FUN-660148
    RETURN END IF
    IF g_gxg.gxg011 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    #-->檢查資料是否為無效
    IF g_gxg.gxgacti ='N' THEN CALL cl_err(g_gxg.gxg011,'9027',0) RETURN END IF
    #-->已confirm不可修改
    IF g_gxg.gxgconf='Y' THEN CALL cl_err(g_gxg.gxg011,'anm-105',0) RETURN END IF
   #----------------FUN-D10116-------------(S)
    IF g_gxg.gxgconf = 'X' THEN
       CALL cl_err(g_gxg.gxg011,'9024',0)
       RETURN
    END IF
   #----------------FUN-D10116-------------(E)

    MESSAGE ""
    CALL cl_opmsg('u')
LET g_gxg011_t = g_gxg.gxg011
LET g_gxg02_t = g_gxg.gxg02
    LET g_gxg_o.*=g_gxg.*
    BEGIN WORK
    OPEN t820_cl USING g_gxg.gxg011,g_gxg.gxg02
    IF STATUS THEN
       CALL cl_err("OPEN t820_cl:", STATUS, 1)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t820_cl INTO g_gxg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gxg.gxg011,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_gxg.gxgmodu = g_user                #修改者
    LET g_gxg.gxgdate = g_today               #修改日期
    CALL t820_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t820_i("u",g_gxg.gxg021)         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gxg.* = g_gxg_o.*
            CALL t820_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE gxg_file SET gxg_file.* = g_gxg.*    # 更新DB
            WHERE gxg011 = g_gxg011_t AND gxg02 = g_gxg02_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gxg_file",g_gxg_t.gxg02,g_gxg_t.gxg011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        IF g_gxg.gxg021 ='1' THEN
           IF g_gxg.gxg03 != g_gxg_t.gxg03 THEN            # 更改單號
              UPDATE npp_file SET npp02=g_gxg.gxg03
               WHERE npp01=g_gxg.gxg011 AND npp00=4 AND npp011=g_gxg.gxg02
                 AND nppsys = 'NM'
              IF STATUS THEN 
                 CALL cl_err3("upd","npp_file",g_gxg_t.gxg02,g_gxg_t.gxg011,STATUS,"","upd npp02:",1)  #No.FUN-660148
              END IF
            END IF
        ELSE
           IF g_gxg.gxg09 != g_gxg_t.gxg09 THEN       # 更改單號
              UPDATE npp_file SET npp02=g_gxg.gxg09
               WHERE npp01=g_gxg.gxg011 AND npp00=5 AND npp011=g_gxg.gxg02
                 AND nppsys = 'NM'
              IF STATUS THEN 
                 CALL cl_err3("upd","npp_file",g_gxg_t.gxg02,g_gxg_t.gxg011,STATUS,"","upd npp02:",1)  #No.FUN-660148
              END IF
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t820_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t820_npp02(p_cmd,p_npptype)     #No.FUN-680088
  DEFINE p_npptype LIKE npp_file.npptype #No.FUN-680088
  DEFINE p_cmd     LIKE type_file.chr1,  #No.FUN-680107 VARCHAR(1)
         p_date    LIKE type_file.dat    #NO.FUN-680107 DATE
 
    IF p_cmd='4' THEN
       LET p_date=g_gxg.gxg03
    ELSE
       LET p_date=g_gxg.gxg09
    END IF
    UPDATE npp_file SET npp02=p_date
     WHERE npp01=g_gxg.gxg011 AND npp00=p_cmd AND npp011=g_gxg.gxg02
       AND nppsys = 'NM'
       AND npptype = p_npptype  #No.FUN-680088
    IF STATUS THEN 
       LET g_showmsg=g_gxg.gxg011,"/",p_cmd,"/",g_gxg.gxg02,"/",p_npptype        #No.FUN-710024
       CALL s_errmsg("npp01,npp00,npp011,npptype",g_showmsg,"UPD npp_file",SQLCA.sqlcode,0)     #No.FUN-710024
    END IF
END FUNCTION
 
FUNCTION t820_chkgxf(p_gxg011)
   DEFINE p_gxg011 LIKE gxg_file.gxg011
   LET g_errno=''
   SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011 = p_gxg011
   IF STATUS THEN 
      CALL cl_err3("sel","gxf_file",p_gxg011,"",STATUS,"","",1)  #No.FUN-660148
      RETURN END IF
   LET g_gxf_t.*=g_gxf.*
        #若存單狀態仍為0.存入,則不可執行
    CASE WHEN g_gxf.gxf11= 0 LET g_errno = 'anm-645'
        #若存單狀態已為3.解約,則不可執行
         WHEN g_gxf.gxf11= 3 LET g_errno = 'anm-618'
         OTHERWISE           LET g_errno = ''
    END CASE
END FUNCTION
 
FUNCTION t820_g_gl(p_apno,p_sw1,p_sw2)  
   DEFINE p_apno          LIKE gxg_file.gxg01
   DEFINE l_gxf    RECORD LIKE gxf_file.*
   DEFINE p_sw1           LIKE type_file.num5    #NO.FUN-680107 SMALLINT   #類別: NM(4.定存pledge 5.定存pledge_removed )
   DEFINE p_sw2           LIKE type_file.num5    #NO.FUN-680107 SMALLINT   #序號
   DEFINE l_buf           LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(70)
   DEFINE l_n             LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   IF p_apno IS NULL THEN RETURN END IF
  #-------------------FUN-D10116-------------(S)
   IF g_gxg.gxgconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
  #-------------------FUN-D10116-------------(E)
   SELECT * INTO l_gxf.* FROM gxf_file WHERE gxf011=p_apno
   IF STATUS THEN 
      CALL cl_err3("sel","gxf_file",p_apno,"",STATUS,"","",1)  #No.FUN-660148
      RETURN END IF
   IF g_gxg.gxgconf = 'Y' THEN RETURN END IF
   IF g_gxg.gxgacti='N' THEN CALL cl_err(g_gxg.gxg011,'mfg1000',0) RETURN END IF
   LET g_errno=''
   IF p_sw1= 4  THEN                      #pledge分錄
     #pledge傳票編號不為空白,表已拋轉
      IF NOT cl_null(g_gxg.gxg07) THEN
         CALL cl_err(g_gxg.gxg07,'aap-145',0)
         RETURN
      END IF
   ELSE                                   #pledge_removed分錄
     #pledge_removed傳票編號不為空白,表已拋轉
      IF NOT cl_null(g_gxg.gxg10) THEN
         CALL cl_err(g_gxg.gxg10,'aap-145',0)
         RETURN
      END IF
   END IF
   IF l_gxf.gxf11=3 THEN LET g_errno = 'anm-618' END IF
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(l_gxf.gxf11,g_errno,0) RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM npp_file   #pledge(4,2)  pledge_removed(4,3)
    WHERE npp01 = p_apno AND nppsys='NM' AND npp00=p_sw1 AND npp011 = p_sw2
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_apno) THEN RETURN END IF #Genero

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
      #FUN-B40056--add--end--

      DELETE FROM npp_file WHERE npp01 = p_apno
                             AND npp011= p_sw2
                             AND nppsys='NM'
                             AND npp00 = p_sw1
      DELETE FROM npq_file WHERE npq01 = p_apno
                             AND npq011= p_sw2
                             AND npqsys='NM'
                             AND npq00 = p_sw1
   END IF
   CALL t820_g_gl_1(p_apno,p_sw1,p_sw2,l_gxf.gxf02,'0')
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL t820_g_gl_1(p_apno,p_sw1,p_sw2,l_gxf.gxf02,'1')
   END IF
   CALL cl_getmsg('axm-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
#pledge分錄產生    : 借 其他流動資產  貸 定期存款
#pledge_removed分錄產生: 借 定期存款      貸 其他流動資產
FUNCTION t820_g_gl_1(p_apno,p_sw1,p_sw2,p_gxf02,p_npptype)    #No.FUN-680088
   DEFINE p_npptype     LIKE npp_file.npptype #No.FUN-680088
   DEFINE p_apno        LIKE gxg_file.gxg01,
          p_sw1         LIKE type_file.num5,  #NO.FUN-680107 SMALLINT #類別: 4.pledge  5.pledge_removed
          p_sw2         LIKE type_file.num5,  #NO.FUN-680107 SMALLINT #異動序號
          p_gxf02       LIKE gxf_file.gxf02,  #原存銀行
          l_dept        LIKE gxg_file.gxg04,
          l_gxd11       LIKE gxd_file.gxd11,  #其他流動資產
          l_gxd12       LIKE gxd_file.gxd12,  #定期存款
          l_nma02       LIKE nma_file.nma02,  #銀行簡稱
          l_nma10       LIKE nma_file.nma10,  #存款幣別
          l_nma05       LIKE nma_file.nma05,  #存款科目   #FUN-5B0092
          l_nma051      LIKE nma_file.nma051, #No-FUN-680088
          l_gxg         RECORD LIKE gxg_file.*,
          l_npp         RECORD LIKE npp_file.*,
          l_npq         RECORD LIKE npq_file.*,
          l_mesg        LIKE type_file.chr50   #NO.FUN-680107 VARCHAR(30)
          
			   DEFINE l_flag        LIKE type_file.chr1    #FUN-D40118 add
			   DEFINE l_bookno1     LIKE aza_file.aza81    #FUN-D40118 add  
			   DEFINE l_bookno2     LIKE aza_file.aza82    #FUN-D40118 add
			   DEFINE l_bookno3     LIKE aza_file.aza81    #FUN-D40118 add
 
   LET g_success = 'Y'   #No.FUN-680088
   SELECT * INTO l_gxg.* FROM gxg_file WHERE gxg011 = p_apno
                                         AND gxg02=g_gxg.gxg02
    #FUN-D40118--add--str--
   CALL s_get_bookno(YEAR(l_gxg.gxg03)) RETURNING l_flag,l_bookno1,l_bookno2
   IF l_flag = '1' THEN
      CALL cl_err(YEAR(l_gxg.gxg02),'aoo-081',1)
      LET g_success = 'N'
   END IF
   IF p_npptype = '0' THEN
      LET l_bookno3 = l_bookno1
   ELSE
      LET l_bookno3 = l_bookno2
   END IF 
   #FUN-D40118--add--end--
   IF STATUS THEN 
      CALL cl_err3("sel","gxg_file",p_apno,g_gxg.gxg02,STATUS,"","",1)  #No.FUN-660148
      LET g_success = 'N'   #No.FUN-680088
      RETURN END IF
   INITIALIZE l_npp.* TO NULL
   LET l_npp.npptype = p_npptype  #No.FUN-680088
   LET l_npp.nppsys = 'NM'             #系統別
   LET l_npp.npp00  = p_sw1            #類別
   LET l_npp.npp01  = l_gxg.gxg011     #單號
   LET l_npp.npp011 = p_sw2            #異動序號
   IF p_sw1='4' THEN
      LET l_npp.npp02 = l_gxg.gxg03    #異動日期 = pledge日期
   ELSE
      LET l_npp.npp02 = l_gxg.gxg09
   END IF
 
   LET l_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES (l_npp.*)
   IF STATUS THEN  
      CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,STATUS,"","ins npp#1",1)  #No.FUN-660148
      LET g_success = 'N'   #No.FUN-680088
   END IF
 
   #-->取會計參數
   IF p_npptype = '0' THEN
      SELECT gxd11,gxd12 INTO l_gxd11,l_gxd12 FROM gxd_file
   ELSE
      SELECT gxd111,gxd121 INTO l_gxd11,l_gxd12 FROM gxd_file
   END IF
      IF SQLCA.sqlcode THEN LET l_gxd11 = ' ' LET l_gxd12 = ' ' END IF
 
  SELECT nma02,nma10,nma05,nma051 INTO l_nma02,l_nma10,l_nma05,l_nma051 FROM nma_file   #FUN-5B0092
      WHERE nma01 = p_gxf02
   IF l_nma02 IS NULL THEN LET l_nma02=' ' END IF
   IF l_nma10 IS NULL THEN LET l_nma10=' ' END IF
 
   #--> 借方npq06=1: pledge(其他流動資產),pledge_removed(定期存款)
   INITIALIZE l_npq.* TO NULL
   LET l_npq.npqtype = p_npptype  #No.FUN-680088
   LET l_npq.npqsys = 'NM'              #系統別
   LET l_npq.npq00  = p_sw1             #類別
   LET l_npq.npq01  = l_gxg.gxg011      #單號
   LET l_npq.npq011 = p_sw2             #異動序號
   LET l_npq.npq02  = 1                 #項次
   LET l_npq.npq06  = '1'               #D/C: 借
   LET l_npq.npq07f = l_gxg.gxg05       #原幣金額
   LET l_npq.npq07  = l_gxg.gxg05       #本幣金額
   LET l_npq.npq21  = p_gxf02           #銀行編號
   LET l_npq.npq22  = l_nma02[1,8]      #銀行簡稱
   LET l_npq.npq24  = g_aza.aza17           #幣別   #TQC-610041
   LET l_npq.npq25  = 1                 #匯率: 1
 
   IF p_sw1 = 4 THEN #pledge
      LET l_npq.npq03  = l_gxd11        #其他流動資產之科目
   ELSE              #pledge_removed
      IF cl_null(l_nma05) THEN   #FUN-5B0092
         LET l_npq.npq03 = l_gxd12         #定期存款之科目
      ELSE    #FUN-5B0092
         IF p_npptype = '0' THEN
            LET l_npq.npq03 = l_nma05
         ELSE
            LET l_npq.npq03 = l_nma051
         END IF
      END IF   #FUN-5B0092
   END IF
   CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_gxg.gxg02,'',g_aza.aza81)   #MOD-6C0140     #NO.FUN-740028
    RETURNING  l_npq.*
   CALL s_def_npq31_npq34(l_npq.*,g_aza.aza81)               #FUN-AA0087
   RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
   LET l_npq.npqlegal= g_legal
   
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = l_bookno3 
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,l_bookno3) RETURNING l_flag
      IF l_flag = 'N' THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
   #FUN-D40118--add--end--
   
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq#1",1)  #No.FUN-660148
      LET g_success = 'N'   #No.FUN-680088
   END IF
   MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
 
   #--> 貸方npq06=2: pledge(定期存款),pledge_removed(其他流動資產)
   LET l_npq.npq02  = l_npq.npq02+1     #項次
   LET l_npq.npq06  = '2'               #D/C: 貸
   LET l_npq.npq04  = ''                #MOD-B80104 add
   IF p_sw1 = 4 THEN #pledge
      IF cl_null(l_nma05) THEN   #FUN-5B0092
         LET l_npq.npq03 = l_gxd12         #定期存款之科目
      ELSE    #FUN-5B0092
         IF p_npptype = '0' THEN
            LET l_npq.npq03 = l_nma05
         ELSE
            LET l_npq.npq03 = l_nma051
         END IF
      END IF    #FUN-5B0092
   ELSE              #pledge_removed
      LET l_npq.npq03 = l_gxd11         #其他流動資產之科目
   END IF
   CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_gxg.gxg02,'',g_aza.aza81)   #MOD-6C0140  #NO.FUN-740028
    RETURNING  l_npq.*
   CALL s_def_npq31_npq34(l_npq.*,g_aza.aza81)               #FUN-AA0087
   RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
   LET l_npq.npqlegal= g_legal
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = l_bookno3
      AND aag01 = l_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
      CALL s_chk_ahk(l_npq.npq03,l_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET l_npq.npq03 = ''
      END IF
   END IF
   #FUN-D40118--add--end--
   INSERT INTO npq_file VALUES (l_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","ins npq#3",1)  #No.FUN-660148
      LET g_success = 'N'   #No.FUN-680088
   END IF
   MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07f
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021 
END FUNCTION
 
FUNCTION t820_r()
    DEFINE l_chr LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_gxg.* FROM gxg_file WHERE gxg011 = g_gxg.gxg011 AND gxg02 = g_gxg.gxg02
    IF STATUS THEN 
       CALL cl_err3("sel","gxg_file",g_gxg.gxg02,g_gxg.gxg011,STATUS,"","",1)  #No.FUN-660148
       RETURN 
    END IF
    IF g_gxg.gxg011 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_gxg.gxgacti='N' THEN CALL cl_err(g_gxg.gxg011,'mfg1000',0) RETURN END IF
    IF g_gxg.gxgconf='Y' THEN CALL cl_err(g_gxg.gxg011,'9023',0) RETURN END IF
   #---------------------FUN-D10116--------------------(S)
    IF g_gxg.gxgconf = 'X' THEN
       CALL cl_err(g_gxg.gxg011,'9024',0)
       RETURN
    END IF
   #---------------------FUN-D10116--------------------(E)
    IF g_gxg.gxg07 IS NOT NULL THEN   #表已做過"pledge傳票拋轉"
       CALL cl_err(g_gxg.gxg07,'afa-311',0) RETURN
    END IF
    IF g_gxg.gxg10 IS NOT NULL THEN   #表已做過"pledge_removed傳票拋轉"
       CALL cl_err(g_gxg.gxg10,'afa-311',0) RETURN
    END IF
    BEGIN WORK
    OPEN t820_cl USING g_gxg.gxg011,g_gxg.gxg02
    IF STATUS THEN
       CALL cl_err("OPEN t820_cl:", STATUS, 1)
       CLOSE t820_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t820_cl INTO g_gxg.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_gxg.gxg011,SQLCA.sqlcode,0) RETURN END IF
    CALL t820_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "gxg011"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_gxg.gxg011      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM gxg_file WHERE gxg011 = g_gxg.gxg011 AND gxg02 = g_gxg.gxg02
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","gxg_file",g_gxg.gxg02,g_gxg.gxg011,SQLCA.sqlcode,"","",1)  #No.FUN-660148
       END IF
       DELETE FROM npp_file WHERE nppsys='NM'
                              AND npp01=g_gxg.gxg011
                              AND npp011=g_gxg.gxg02
       DELETE FROM npq_file WHERE npqsys='NM'
                              AND npq01=g_gxg.gxg011
                              AND npq011=g_gxg.gxg02

       #FUN-B40056--add--str--
       DELETE FROM tic_file WHERE tic04 = g_gxg.gxg011
       #FUN-B40056--add--end--

       CLEAR FORM
       OPEN t820_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE t820_cl
          CLOSE t820_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       FETCH t820_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t820_cl
          CLOSE t820_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t820_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t820_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t820_fetch('/')
       END IF
    END IF
    CLOSE t820_cl
    COMMIT WORK
    ERROR "del gxg.npp.npq"   #MOD-610044
END FUNCTION

#-----------------FUN-D10116---------------------(S)
FUNCTION t820_x()
   IF s_anmshut(0) THEN RETURN END IF
   IF cl_null(g_gxg.gxg011) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t820_cl USING g_gxg.gxg011,g_gxg.gxg02
   IF STATUS THEN
      CALL cl_err("OPEN t820_cl:", STATUS, 1)
      CLOSE t820_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t820_cl INTO g_gxg.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gxg.gxg011,SQLCA.sqlcode,0)
      CLOSE t820_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_gxg.gxgconf='Y' THEN
      CALL cl_err(g_gxg.gxg011,'alm-870',2)
      CLOSE t820_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_gxg.gxgconf) THEN
      IF g_gxg.gxgconf = 'N' THEN                      #切換為作廢
         LET g_gxg.gxgconf = 'X'
      ELSE                                             #取消作廢
         LET g_gxg.gxgconf = 'N'
      END IF
      UPDATE gxg_file SET gxgconf = g_gxg.gxgconf
       WHERE gxg011 = g_gxg.gxg011
         AND gxg02 = g_gxg.gxg02
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","gxg_file",g_gxg.gxg01,"",STATUS,"","",1)
         LET g_success = 'N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_gxg.gxg01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CLOSE t820_cl
   CALL t820_show()                      # 重新顯示
END FUNCTION
#-----------------FUN-D10116---------------------(E)
 
FUNCTION t820_y()                  #過帳更新定期存單資料檔
    DEFINE l_gxgconf  LIKE gxg_file.gxgconf,
           l_gxgacti  LIKE gxg_file.gxgacti,
           l_n        LIKE type_file.num5,       #No.FUN-680107 SMALLINT
           l_gxg02    LIKE gxg_file.gxg02
    DEFINE l_flag1    LIKE type_file.chr1        #MOD-810196
    DEFINE l_bookno1  LIKE aza_file.aza81        #MOD-810196
    DEFINE l_bookno2  LIKE aza_file.aza82        #MOD-810196
    DEFINE l_gxg05    LIKE gxg_file.gxg05        #MOD-940285
     
     IF g_gxg.gxg011 IS NULL THEN CALL cl_err('','anm-623',0) RETURN END IF
     CALL s_get_doc_no(g_gxg.gxg011) RETURNING g_t1
     SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
     SELECT * INTO g_gxg.* FROM gxg_file WHERE gxg011=g_gxg.gxg011
                                           AND gxg02=g_gxg.gxg02
     IF g_gxg.gxgconf='Y' THEN CALL cl_err('','9023',0) RETURN END IF
    #---------------FUN-D10116--------(S)
     IF g_gxg.gxgconf = 'X' THEN
        CALL cl_err('','9024',0)
        RETURN
     END IF
    #---------------FUN-D10116--------(E)
     SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011=g_gxg.gxg011
     IF STATUS THEN
        CALL cl_err3("sel","gxf_file",g_gxg.gxg011,"",STATUS,"","sel gxf:",1)  #No.FUN-660148
        RETURN
     END IF
     IF g_gxg.gxg02 > 1 THEN
        LET l_gxg02 = g_gxg.gxg02 - 1
        SELECT COUNT(*) INTO l_n FROM gxg_file
         WHERE gxg011=g_gxg.gxg011 AND gxg02=l_gxg02 AND gxgconf='Y'
        IF l_n = 0 THEN CALL cl_err('','anm-268',0) RETURN END IF
     END IF
    #FUN-B50090 add begin-------------------------
     #重新抓取關帳日期
     SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
    #FUN-B50090 add -end--------------------------
     IF NOT cl_null(g_gxg.gxg09) THEN
        #-->立帳日期不可小於關帳日期
        IF g_gxg.gxg09 <= g_nmz.nmz10 THEN #no.5261
           CALL cl_err(g_gxg.gxg011,'aap-176',1) RETURN
        END IF
     ELSE
        #-->立帳日期不可小於關帳日期
        IF g_gxg.gxg03 <= g_nmz.nmz10 THEN #no.5261
           CALL cl_err(g_gxg.gxg011,'aap-176',1) RETURN
        END IF
     END IF
     IF g_gxg.gxg021 = '2' THEN 
        SELECT gxg05 INTO l_gxg05 FROM gxg_file
         WHERE gxg011 = g_gxg.gxg011
           AND gxg021 = '1'
           AND gxgconf = 'Y'  
           AND gxg02 IN(SELECT MAX(gxg02) FROM gxg_file
                         WHERE gxg011 = g_gxg.gxg011
                           AND gxg021 = '1'
                           AND gxgconf = 'Y')    
        IF cl_null(l_gxg05) THEN LET l_gxg05 = 0 END IF
        IF cl_null(g_gxg.gxg05) THEN LET g_gxg.gxg05 = 0 END IF
                                                
        IF g_gxg.gxg05 > l_gxg05 THEN 
           CALL cl_err('','anm-087',1)
           RETURN 
        END IF                            
     END IF 
     IF NOT cl_confirm('axm-108') THEN RETURN END IF
     LET g_success='Y'
     BEGIN WORK
     CALL s_get_bookno(YEAR(g_gxg.gxg03)) RETURNING l_flag1,l_bookno1,l_bookno2
     IF l_flag1 = '1' THEN
        CALL cl_err(YEAR(g_gxg.gxg02),'aoo-081',1)
        LET g_success = 'N'
     END IF
     IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN
        CALL s_chknpq(g_gxg.gxg011,'NM',g_gxg.gxg02,'0',l_bookno1)
        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           CALL s_chknpq(g_gxg.gxg011,'NM',g_gxg.gxg02,'1',l_bookno2)
        END IF
        IF g_success = 'N' THEN RETURN END IF
       #增加檢查有沒有分錄底稿                                                                                                      
        SELECT COUNT(*) INTO l_n FROM npq_file                                                                                      
         WHERE npq01  = g_gxg.gxg011                                                                                                
           AND npq011 = g_gxg.gxg02                                                                                                 
           AND npqsys = 'NM'                                                                                                        
           AND npq00 IN ('4','5')                                                                                                   
        IF l_n = 0 THEN CALL cl_err('','anm-322',1) RETURN END IF                                                                   
     END IF
 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN   #MOD-810196
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_gxg.gxg011
         AND npq011 = g_gxg.gxg02
         AND npqsys = 'NM'
         AND npq00 IN ('4','5')
      IF l_n = 0 THEN
         CALL t820_gen_glcr(g_gxg.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN
         CALL s_chknpq(g_gxg.gxg011,'NM',g_gxg.gxg02,'0',l_bookno1)
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_gxg.gxg011,'NM',g_gxg.gxg02,'1',l_bookno2)
         END IF
         IF g_success = 'N' THEN RETURN END IF
      END IF
   END IF
     OPEN t820_cl USING g_gxg.gxg011,g_gxg.gxg02
     IF STATUS THEN
        CALL cl_err("OPEN t820_cl:", STATUS, 1)
        CLOSE t820_cl
        ROLLBACK WORK
        RETURN
     END IF
     FETCH t820_cl INTO g_gxg.*               # 對DB鎖定
     IF SQLCA.sqlcode THEN
         CALL cl_err(g_gxg.gxg011,SQLCA.sqlcode,0)
         ROLLBACK WORK RETURN
     END IF
        IF NOT cl_null(g_gxg.gxg09) THEN
           CALL t820_release_y()                 #pledge_removedconfirm
        ELSE
           CALL t820_pledge_y()                  #pledgeconfirm
        END IF
        UPDATE gxg_file SET gxgconf = 'Y'
         WHERE gxg011=g_gxg.gxg011
           AND gxg02=g_gxg.gxg02
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
           CALL cl_err3("upd","gxg_file",g_gxg.gxg011,g_gxg.gxg02,STATUS,"","upd gxg:",1)  #No.FUN-660148
           LET g_success='N'
        END IF
     IF g_success='Y' THEN
        LET g_gxg.gxgconf ='Y' COMMIT WORK
     ELSE
        LET g_gxg.gxgconf = 'N' ROLLBACK WORK
     END IF
     DISPLAY g_gxg.gxgconf TO gxgconf
   IF g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_gxg.gxg011,'" AND npp011 = ',g_gxg.gxg02
      IF g_gxg.gxg021 = '1' THEN
         LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_gxg.gxg03,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
         CALL cl_cmdrun_wait(g_str)
         SELECT gxg07,gxg08 INTO g_gxg.gxg07,g_gxg.gxg08 FROM gxg_file
          WHERE gxg011 = g_gxg.gxg011
            AND gxg02 = g_gxg.gxg02
         DISPLAY BY NAME g_gxg.gxg07
         DISPLAY BY NAME g_gxg.gxg08
      ELSE
         LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_gxg.gxg09,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
         CALL cl_cmdrun_wait(g_str)
         SELECT gxg10,gxg11 INTO g_gxg.gxg10,g_gxg.gxg11 FROM gxg_file
          WHERE gxg011 = g_gxg.gxg011
            AND gxg02 = g_gxg.gxg02
         DISPLAY BY NAME g_gxg.gxg10
         DISPLAY BY NAME g_gxg.gxg11
      END IF    
   END IF
   CALL t820_show()
END FUNCTION
 
FUNCTION t820_pledge_y()
     IF g_success='N' THEN RETURN END IF
     SELECT * INTO g_gxg.*  FROM gxg_file WHERE gxg011=g_gxg.gxg011
                                            AND gxg02=g_gxg.gxg02
     UPDATE gxf_file SET  gxf11 = '1',
                          gxf08 = g_gxg.gxg04,
                          gxf09 = g_gxg.gxg05,
                          gxf10 = g_gxg.gxg06,
                          gxf21 = g_gxg.gxg03,
                          gxf22 = NULL
                    WHERE gxf011 = g_gxg.gxg011
    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","gxf_file",g_gxg.gxg011,"","b_gxg.gxg04","","UPDATE gxf_file error",1)  #No.FUN-660148
       LET g_success = 'N'
    END IF
    MESSAGE g_gxg.gxg011 CLIPPED,' pledge!'
END FUNCTION
 
FUNCTION t820_release_y()
    CALL t820_chkgxf(g_gxg.gxg011)              #檢查是否可執行pledge_removedconfirm
    IF g_gxg.gxg10 IS NOT NULL THEN            #表已做過"pledge_removed傳票拋轉"
       LET g_errno = 'anm-620'
    END IF
 
    IF NOT cl_null(g_errno) THEN
       CALL cl_err('',g_errno,0) LET g_success='N'
       RETURN
    END IF
    IF g_success='N' THEN RETURN END IF
    SELECT * INTO g_gxg.*  FROM gxg_file WHERE gxg011=g_gxg.gxg011
                                           AND gxg02=g_gxg.gxg02
    UPDATE gxf_file SET  gxf22=g_gxg.gxg09,gxf11 = 2
                  WHERE gxf011=g_gxg.gxg011
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","gxf_file",g_gxg.gxg011,"",STATUS,"","upd gxg",1)  #No.FUN-660148
       LET g_success='N'
    END IF
    MESSAGE g_gxg.gxg011 CLIPPED,' release pledege!'
END FUNCTION
 
FUNCTION t820_z()           #過帳還原定期存單資料檔為空白
    DEFINE l_gxgconf  LIKE gxg_file.gxgconf,
           l_gxgacti  LIKE gxg_file.gxgacti,
           l_gxg      RECORD LIKE gxg_file.*,
           l_before_gxg02  LIKE gxg_file.gxg02,
           l_gxg011   LIKE gxg_file.gxg011,
           max_gxg02  LIKE gxg_file.gxg02
    DEFINE l_aba19    LIKE aba_file.aba19   #No.FUN-670060
    DEFINE l_sql      LIKE type_file.chr1000#No.FUN-680107 VARCHAR(1000)
    DEFINE l_dbs      STRING
 
     IF g_gxg.gxg011 IS NULL THEN CALL cl_err('','anm-623',0) RETURN END IF
     IF g_gxg.gxgconf='N' THEN CALL cl_err('','9025',0) RETURN END IF
    #---------------FUN-D10116--------(S)
     IF g_gxg.gxgconf = 'X' THEN
        CALL cl_err('','9024',0)
        RETURN
     END IF
    #---------------FUN-D10116--------(E)
     SELECT * INTO g_gxf.* FROM gxf_file WHERE gxf011=g_gxg.gxg011
     IF STATUS THEN
        CALL cl_err3("sel","gxf_file",g_gxg.gxg011,"",STATUS,"","sel gxf:",1)  #No.FUN-660148
        RETURN
     END IF
     SELECT * INTO g_gxg.* FROM gxg_file
      WHERE gxg011=g_gxg.gxg011 AND gxg02=g_gxg.gxg02
     IF STATUS THEN
        CALL cl_err3("sel","gxg_file",g_gxg.gxg011,g_gxg.gxg02,STATUS,"","sel gxg:",1)  #No.FUN-660148
        RETURN 
     END IF
     IF g_gxg.gxgconf='N' THEN CALL cl_err('','9025',0) RETURN END IF
 
     IF g_gxg.gxg021 = '2' AND g_gxf.gxf11 = '3' THEN   #合約解除
        CALL cl_err(g_gxf.gxf011,'anm-618',0) RETURN
     END IF
 
     #-->若非最大異動序號不可undo_confirm
     SELECT MAX(gxg02) INTO max_gxg02 FROM gxg_file
      WHERE gxg011=g_gxg.gxg011
     IF g_gxg.gxg02 <> max_gxg02 THEN
        CALL cl_err(g_gxg.gxg02,'anm-631',0) RETURN
     END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_gxg.gxg011) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_gxg.gxg07) OR NOT cl_null(g_gxg.gxg08) THEN
      IF NOT (g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_gxg.gxg011,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
      IF g_gxg.gxg021 = '1' THEN
         #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
         LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                     "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                     "    AND aba01 = '",g_gxg.gxg07,"'"
      ELSE
         #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
         LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                     "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                     "    AND aba01 = '",g_gxg.gxg10,"'"
      END IF 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
         PREPARE aba_pre1 FROM l_sql
         DECLARE aba_cs1 CURSOR FOR aba_pre1
         OPEN aba_cs1
         FETCH aba_cs1 INTO l_aba19
         IF l_aba19 = 'Y' THEN
            IF g_gxg.gxg021 = '1' THEN
               CALL cl_err(g_gxg.gxg07,'axr-071',1)
            ELSE 
               CALL cl_err(g_gxg.gxg10,'axr-071',1)
            END IF
            RETURN
         END IF
   END IF
     IF NOT cl_confirm('aim-302') THEN RETURN END IF
     #-->傳票已拋轉則不可undo_confirm
     IF g_gxg.gxg021 = '1' AND NOT cl_null(g_gxg.gxg07) AND g_nmy.nmyglcr = 'N' THEN #No.9617
        CALL cl_err(g_gxg.gxg011,'axr-310',0)
        RETURN
     END IF
     IF g_gxg.gxg021='2' AND NOT cl_null(g_gxg.gxg10) AND g_nmy.nmyglcr = 'N' THEN #No.9617
        CALL cl_err(g_gxg.gxg011,'axr-310',0)
        RETURN
     END IF
    #FUN-B50090 add begin-------------------------
     #重新抓取關帳日期
     SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
    #FUN-B50090 add -end--------------------------
     IF NOT cl_null(g_gxg.gxg09) THEN
        #-->立帳日期不可小於關帳日期
        IF g_gxg.gxg09 <= g_nmz.nmz10 THEN #no.5261
           CALL cl_err(g_gxg.gxg011,'aap-176',1) RETURN
        END IF
     ELSE
        #-->立帳日期不可小於關帳日期
        IF g_gxg.gxg03 <= g_nmz.nmz10 THEN #no.5261
           CALL cl_err(g_gxg.gxg011,'aap-176',1) RETURN
        END IF
     END IF
     LET g_success='Y'
    #--------------------------------CHI-C90051-----------------------------(S)
     IF g_nmy.nmyglcr = 'Y' AND g_nmy.nmydmy3 = 'Y' THEN
        IF g_gxg.gxg021 = '1' THEN
           LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxg.gxg07,"' 'Y'"
           CALL cl_cmdrun_wait(g_str)
           SELECT gxg07,gxg08 INTO g_gxg.gxg07,g_gxg.gxg08 FROM gxg_file
            WHERE gxg011 = g_gxg.gxg011
           DISPLAY BY NAME g_gxg.gxg07
           DISPLAY BY NAME g_gxg.gxg08
           IF NOT cl_null(g_gxg.gxg07) THEN
              CALL cl_err('','aap-929',0)
              RETURN
           END IF
        ELSE
           LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxg.gxg10,"' 'Y'"
           CALL cl_cmdrun_wait(g_str)
           SELECT gxg10,gxg11 INTO g_gxg.gxg10,g_gxg.gxg11 FROM gxg_file
            WHERE gxg011 = g_gxg.gxg011
           DISPLAY BY NAME g_gxg.gxg10
           DISPLAY BY NAME g_gxg.gxg11
           IF NOT cl_null(g_gxg.gxg10) THEN
              CALL cl_err('','aap-929',0)
              RETURN
           END IF
        END IF
     END IF
    #--------------------------------CHI-C90051-----------------------------(E)
     BEGIN WORK
     OPEN t820_cl USING g_gxg.gxg011,g_gxg.gxg02
     IF STATUS THEN
        CALL cl_err("OPEN t820_cl:", STATUS, 1)
        CLOSE t820_cl
        ROLLBACK WORK
        RETURN
     END IF
     FETCH t820_cl INTO g_gxg.*               # 對DB鎖定
     IF SQLCA.sqlcode THEN
         CALL cl_err(g_gxg.gxg011,SQLCA.sqlcode,0)
         RETURN
     END IF
     IF g_gxg.gxg02 > 1 THEN    #非第一筆異動
        INITIALIZE l_gxg.* TO NULL
        LET l_before_gxg02 = g_gxg.gxg02 - 1
        SELECT * INTO l_gxg.* FROM gxg_file
         WHERE gxg011 = g_gxg.gxg011
           AND gxg02 = l_before_gxg02
           CALL t820_pledge_z(l_gxg.*)            #pledgeundo_confirm
           CALL t820_release_z(l_gxg.*)           #pledge_removedundo_confirm
     ELSE
        LET g_gxg.gxg02 = g_gxg.gxg02 - 1
        IF g_gxg.gxg09 IS NULL THEN
           CALL t820_pledge_z(g_gxg.*)            #pledgeundo_confirm
        ELSE
           CALL t820_release_z(g_gxg.*)           #pledge_removedundo_confirm
        END IF
        LET g_gxg.gxg02 = g_gxg.gxg02 + 1
     END IF
        UPDATE gxg_file SET gxgconf = 'N'
         WHERE gxg011 = g_gxg.gxg011 AND gxg02 = g_gxg.gxg02
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("upd","gxg_file",g_gxg.gxg011,g_gxg.gxg02,STATUS,"","upd gxgconf:",1)  #No.FUN-660148
              LET g_success='N'
           END IF
     IF g_success='Y' THEN
        COMMIT WORK LET g_gxg.gxgconf ='N'
     ELSE
        ROLLBACK WORK LET g_gxg.gxgconf='Y'
     END IF
     DISPLAY g_gxg.gxgconf TO gxgconf
    #--------------------------------CHI-C90051-----------------------------mark
    #IF g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
    #   IF g_gxg.gxg021 = '1' THEN
    #      LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxg.gxg07,"' 'Y'"
    #      CALL cl_cmdrun_wait(g_str)
    #      SELECT gxg07,gxg08 INTO g_gxg.gxg07,g_gxg.gxg08 FROM gxg_file
    #       WHERE gxg011 = g_gxg.gxg011
    #      DISPLAY BY NAME g_gxg.gxg07
    #      DISPLAY BY NAME g_gxg.gxg08
    #   ELSE
    #      LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxg.gxg10,"' 'Y'"
    #      CALL cl_cmdrun_wait(g_str)
    #      SELECT gxg10,gxg11 INTO g_gxg.gxg10,g_gxg.gxg11 FROM gxg_file
    #       WHERE gxg011 = g_gxg.gxg011
    #      DISPLAY BY NAME g_gxg.gxg10
    #      DISPLAY BY NAME g_gxg.gxg11
    #   END IF
    #END IF
    #--------------------------------CHI-C90051-----------------------------mark
     CALL t820_show()
END FUNCTION
 
FUNCTION t820_pledge_z(l_gxg)
  DEFINE l_gxg    RECORD LIKE gxg_file.*,
         l_chr    LIKE type_file.chr1      #No.FUN-680107  VARCHAR(1)
 
     IF l_gxg.gxg02 >= 1 THEN
        IF l_gxg.gxg09 IS NOT NULL THEN
           LET l_chr = '2'
        ELSE
           LET l_chr = '1'
        END IF
        UPDATE gxf_file SET  gxf08 = l_gxg.gxg04,
                             gxf09 = l_gxg.gxg05,
                             gxf10 = l_gxg.gxg06,
                             gxf11 = l_chr,
                             gxf21 = l_gxg.gxg03
         WHERE gxf011 = l_gxg.gxg011
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","gxf_file",l_gxg.gxg011,"",STATUS,"","upd gxf:",1)  #No.FUN-660148
            LET g_success = 'N'
         END IF
     ELSE
        IF NOT cl_null(g_gxf.gxf22) THEN
           CALL cl_err('','anm-267',0) LET g_success='N' RETURN
        END IF
        UPDATE gxf_file SET  gxf08 = ' ',
                             gxf09 = 0,
                             gxf10 = ' ',
                             gxf11 = '0',
                             gxf21 = NULL
         WHERE gxf011 = l_gxg.gxg011
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","gxf_file",l_gxg.gxg011,"",STATUS,"","upd gxf2:",1)  #No.FUN-660148
            LET g_success = 'N'
         END IF
     END IF
        MESSAGE l_gxg.gxg011
END FUNCTION
 
FUNCTION t820_release_z(l_gxg)
  DEFINE l_gxg   RECORD LIKE gxg_file.*,
         l_chr   LIKE type_file.chr1       #No.FUN-680107 VARCHAR(1)
 
    IF l_gxg.gxg02 >=  1 THEN
       IF l_gxg.gxg09 IS NOT NULL THEN
          LET l_chr = '2'
       ELSE
          LET l_chr = '1'
       END IF
       UPDATE gxf_file SET gxf22 = l_gxg.gxg09,gxf11= l_chr
        WHERE gxf011=l_gxg.gxg011
    ELSE
       CALL t820_chkgxf(l_gxg.gxg011)               #檢查是否可執行pledge_removedconfirm
       IF g_gxg.gxg10 IS NOT NULL THEN             #表已做過"pledge_removed傳票拋轉"
          LET g_errno = 'anm-620'
       END IF
 
       IF NOT cl_null(g_errno) THEN
          CALL cl_err('',g_errno,0) LET g_success='N'
          RETURN
       END IF
       UPDATE gxf_file SET gxf22 = NULL,gxf11 = '1'
        WHERE gxf011=l_gxg.gxg011
    END IF
    IF STATUS THEN
       CALL cl_err3("upd","gxf_file",l_gxg.gxg011,"",STATUS,"","upd gxg",1)  #No.FUN-660148
       LET g_success='N'
    END IF
    MESSAGE l_gxg.gxg011
END FUNCTION
 
FUNCTION t820_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107  VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("gxg011",TRUE) #No.MOD-470276(2)
   END IF

   IF g_gxg.gxg021 <> '1' THEN                      #MOD-CA0030 add
      CALL cl_set_comp_entry("gxg09",TRUE)          #MOD-CA0030 add
   END IF                                           #MOD-CA0030 add

END FUNCTION
 
FUNCTION t820_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("gxg011",FALSE) #No.MOD-470276(2)
   END IF

   IF g_gxg.gxg021 = '1' THEN                      #MOD-CA0030 add
      CALL cl_set_comp_entry("gxg09",FALSE)        #MOD-CA0030 add
   END IF                                          #MOD-CA0030 add

END FUNCTION
 
FUNCTION t820_gen_glcr(p_gxg,p_nmy)
  DEFINE p_gxg     RECORD LIKE gxg_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_gxg.gxg011,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    IF g_gxg.gxg021 = '1' THEN
       CALL t820_g_gl(g_gxg.gxg011,4,g_gxg.gxg02)
    ELSE
       CALL t820_g_gl(g_gxg.gxg011,5,g_gxg.gxg02)
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t820_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5          #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
    IF g_gxg.gxg021 = '1' THEN 
       IF NOT cl_null(g_gxg.gxg07) OR g_gxg.gxg07 IS NOT NULL THEN
          CALL cl_err(g_gxg.gxg07,'aap-618',1)
          RETURN 
       END IF 
    ELSE 
       IF NOT cl_null(g_gxg.gxg10) OR g_gxg.gxg10 IS NOT NULL THEN 
          CALL cl_err(g_gxg.gxg10,'aap-618',1) 
          RETURN 
       END IF 
    END IF 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxg.gxg011) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN  #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxg.gxg10,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_gxg.gxg10,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
       #開窗作業
       LET g_plant_new= g_nmz.nmz02p
       CALL s_getdbs()
       LET g_dbs_gl=g_dbs_new      # 得資料庫名稱
 
       OPEN WINDOW t200p AT 5,10 WITH FORM "axr/42f/axrt200_p" 
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_locale("axrt200_p")
        
       INPUT l_nmygslp WITHOUT DEFAULTS FROM FORMONLY.gl_no
    
          AFTER FIELD gl_no
             CALL s_check_no("agl",l_nmygslp,"","1","aac_file","aac01",g_plant_gl) #No.FUN-560190 #TQC-9B0162
                   RETURNING li_result,l_nmygslp
             IF (NOT li_result) THEN
                NEXT FIELD gl_no
             END IF
     
          AFTER INPUT
             IF INT_FLAG THEN
                EXIT INPUT 
             END IF
             IF cl_null(l_nmygslp) THEN
                CALL cl_err('','9033',0)
                NEXT FIELD gl_no  
             END IF
    
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG
             CALL cl_cmdask()
          ON ACTION CONTROLP
             IF INFIELD(gl_no) THEN
                CALL q_m_aac(FALSE,TRUE,g_plant_gl,l_nmygslp,'1',' ',' ','AGL') #No.FUN-980059
                RETURNING l_nmygslp
                DISPLAY l_nmygslp TO FORMONLY.gl_no
                NEXT FIELD gl_no
             END IF
    
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
    END IF
    IF cl_null(l_nmygslp) OR (cl_null(g_nmy.nmygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680088 
       CALL cl_err(g_gxg.gxg011,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_gxg.gxg011,'" AND npp011 = ',g_gxg.gxg02
    IF g_gxg.gxg021 = '1' THEN
       LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_gxg.gxg03,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
       CALL cl_cmdrun_wait(g_str)
       SELECT gxg07,gxg08 INTO g_gxg.gxg07,g_gxg.gxg08 FROM gxg_file
        WHERE gxg011 = g_gxg.gxg011
          AND gxg02 = g_gxg.gxg02
       DISPLAY BY NAME g_gxg.gxg07
       DISPLAY BY NAME g_gxg.gxg08
    ELSE 
       LET g_str="anmp100 '",g_wc_gl CLIPPED,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_gxg.gxg09,"' 'Y' '1' 'Y' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"'"  #No.FUN-680088#FUN-860040
       CALL cl_cmdrun_wait(g_str)
       SELECT gxg10,gxg11 INTO g_gxg.gxg10,g_gxg.gxg11 FROM gxg_file
        WHERE gxg011 = g_gxg.gxg011
          AND gxg02 = g_gxg.gxg02
       DISPLAY BY NAME g_gxg.gxg10
       DISPLAY BY NAME g_gxg.gxg11
    END IF
END FUNCTION
 
FUNCTION t820_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000   #No.FUN-680107  VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF g_gxg.gxg021 = '1' THEN 
       IF cl_null(g_gxg.gxg07) OR g_gxg.gxg07 IS NULL THEN 
          CALL cl_err(g_gxg.gxg07,'aap-619',1)
          RETURN 
       END IF
    ELSE 
       IF cl_null(g_gxg.gxg10) OR g_gxg.gxg10 IS NULL THEN
          CALL cl_err(g_gxg.gxg10,'aap-619',1)
          RETURN 
       END IF
    END IF 
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_gxg.gxg01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
    IF g_gxg.gxg021 = '1' THEN
       #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxg.gxg07,"'"
    ELSE
       #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_gxg.gxg10,"'"
    END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       IF g_gxg.gxg021 = '1' THEN
          CALL cl_err(g_gxg.gxg07,'axr-071',1)
       ELSE
          CALL cl_err(g_gxg.gxg10,'axr-071',1)
       END IF
       RETURN
    END IF
 
    IF g_gxg.gxg021 = '1' THEN
       LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxg.gxg07,"' 'Y'"
       CALL cl_cmdrun_wait(g_str)
       SELECT gxg07,gxg08 INTO g_gxg.gxg07,g_gxg.gxg08 FROM gxg_file
        WHERE gxg011 = g_gxg.gxg011
       DISPLAY BY NAME g_gxg.gxg07
       DISPLAY BY NAME g_gxg.gxg08
    ELSE
       LET g_str="anmp110 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_gxg.gxg10,"' 'Y'"
       CALL cl_cmdrun_wait(g_str)
       SELECT gxg10,gxg11 INTO g_gxg.gxg10,g_gxg.gxg11 FROM gxg_file
        WHERE gxg011 = g_gxg.gxg011
       DISPLAY BY NAME g_gxg.gxg10
       DISPLAY BY NAME g_gxg.gxg11
    END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18

