# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: amdi100.4gl
# Descriptions...: 進項憑證維護作業
# Date & Author..: 95/01/06 By Apple
#                : 96/06/28 By Lynn   G.進項憑證重新產生的
#                :                 進項,退貨折讓 須考慮多工廠
#                : By Charis G.進項憑證重新產生的 S.銷項如ome_file沒有申報年月
#                  無法擷取、銷項申報年月以oma02預設、格式依稅別default
# Modify.........: 97/03/12 By Danny
#                  進項資料擷取時, 若為折讓單, 則取單身之發票號碼
# Modify.........: 98/03/20 By HJC
#                  Add 傳票號碼, 更改輸入畫面
# modify canny(980923):增加 amd30 欄位，confirm碼
#                      amd30 = 'Y' 不能做刪除，修改
# modify canny(981012):不卡跨月未申報資料
# modify canny(981014).dbo.apk_file 為 Grobal ，所以不可以指定 apk_file 之資料庫
# modify ........: 01/05/22 by linda 將銷項及進項資料擷取獨立程式amdp010,amdp020
#                  若原程式_s() ,_g() function 拿掉
#                  新增 function _1() doc_data function
#Modify .........: No:B597 010524 新增 function i100_2() 銷項單身資料維護
# Modify.........: No:7791 03/08/15 By Wiky  C.batch_delete,不要再詢問user'是否確定執行本作業?'
# Modify.........: No:7790 03/08/15 By Wiky 執行delete或C.batch_delete時沒將amf_file拿掉,後續INSERT會有問題
# Modify.........: No:8475 03/10/31 By Kitty amd01,amd02不可為null
# Modify.........: No:8236 03/11/03 By Kitty amf多一個欄位amf022
# Modify.........: No:8771 03/11/25 By Kitty 675行四捨五入處理改call副程式
# Modify.........: No:8770 03/12/01 By Kitty 銷項出貨明細處理顯示有問題
# Modify.........: No:9017 04/01/12 By Kitty plant長度改為10碼
# Modify.........: No:9753 04/07/15 By ching 若為折讓,發票號碼可重複
# Modify.........: No.MOD-470411 04/08/20 Nicola 功能detail為銷項明細，
#                                         改名為sale_detail免跟功能"單身"搞混
# Modify.........: No.MOD-480268 04/08/24 Kammy 確認與整批確認整合，並且加show
#                                               確認圖示
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4C0022 04/12/03 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.FUN-4C0050 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0091 04/12/28 By Kitty  amd17可輸入3,4,amd10改為有輸入時,則為1 or 2,位置移到相關文件
# Modify.........: No.MOD-520116 05/02/24 By Kitty amf022不可為null,否則上下筆移動有問題
# Modify.........: No.MOD-5A0279 05/10/21 By Smapmin QBE條件內年/月應該是amd173/amd174 而非 amd26/amd27
#                                                    發票號碼&格式編號是否重複之判斷有誤
# Modify.........: No.MOD-5A0280 06/01/05 By Smapmin 修改文件資料輸入方式
# Modify.........: No.TQC-620118 06/02/23 By Smapmin 未確認不可賦予流水號
# Modify.........: No.MOD-640493 06/04/17 By Smapmin 銷項明細修改後未UPDATE資料
# Modify.........: No.FUN-660017 06/06/19 By rainy   增加複製功能
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-5B0141 06/06/28 By rainy 銷項格式要可輸入37/38
# Modify.........: No.FUN-680074 06/08/23 By huchenghao  類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0150 06/11/15 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6C0054 06/12/29 By rainy 新增"資產明細"Action
# Modify.........: No.MOD-720010 07/02/05 By Smapmin 修改參數傳遞
# Modify.........: No.MOD-720119 07/02/27 By Smapmin 離開畫面要將畫面關閉
# Modify.........: No.TQC-710064 07/03/01 By rainy 取號錯誤修正,複製時不可輸入單號、來源類別改為不可輸入且來源類別固定為'4'
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740345 07/04/23 By rainy 存檔時再做一次發票號碼檢查
# Modify.........: No.MOD-740387 07/04/24 By rainy 賦予流水號開窗字型有問題
# Modify.........: No.MOD-740496 07/04/30 By Smapmin 經查詢國稅局,若是屬銷退(發票格式33),發票日期也可往前推一個月
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780205 07/08/20 By Smapmin update amd_file的where條件,加入一key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810150 08/01/21 By Smapmin 修正MOD-720010
# Modify.........: No.FUN-840202 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-850072 08/05/14 By Sarah 整批刪除i100_c()段,在刪除前增加詢問cl_delete
# Modify.........: No.FUN-770040 08/06/04 By Smapmin 增加發票聯數欄位
# Modify.........: No.MOD-860113 08/06/12 By Sarah 將DELETE FROM amf_file段搬到i100_fetch()前,否則會刪錯筆
# Modify.........: No.MOD-890140 08/09/17 By Sarah 將No:8770修改部分還原
# Modify.........: No.FUN-8B0048 08/11/24 By Sarah 進項憑證檢核放大至五年內皆可輸入
# Modify.........: No.MOD-8C0071 08/12/10 By Sarah 於AFTER FIELD amd39段檢核欄位長度須為14位
# Modify.........: No.MOD-8C0220 08/12/23 By Sarah 當amd10(通關註記)為空時,amd39不可維護
# Modify.........: No.MOD-960060 09/06/04 By Sarah 將4gl中l_desc相關段落mark
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-8B0081 09/07/27 By hongmei add amd44銷售固定資產
# Modify.........: No.TQC-980095 09/08/13 By mike INSERT INTO amd_file前,判斷若g_amd.amd44是null的話,給予預設值'3'                  
# Modify.........: No.MOD-980174 09/08/21 By mike FUNCTION i100_copy(),復制時應將amd26,amd27清空                                    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-980266 09/08/26 By Carrier amd06/amd07/amd08非負控管
# Modify.........: No.MOD-990126 09/09/14 By mike FUNCTION i100_firm1(),當發票號碼(amd03)不為Null時才需檢查發票號碼+格式是否重復    
# Modify.........: No:MOD-9C0130 09/12/14 By Sarah 1.原先amd-001的卡關是檢查amd26不為NULL,請改成判斷不為NULL且不為0
#                                                  2.若amd26/amd27為0時,畫面請顯示為''
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No.FUN-A10039 10/01/20 By jan 將omd172欄位改為1.應稅 2.零稅 3.免稅 D.空白未使用發票 F.作廢
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A50166 10/05/26 By sabrina 複製時流水號(amd175)要清空
# Modify.........: No:CHI-A80028 10/08/18 By Summer 調整流水號ORDER BY
# Modify.........: No:MOD-A90102 10/09/15 By Dido amd-010 訊息僅限於二三聯發票檢核
# Modify.........: No:MOD-A90178 10/09/29 By Dido amd-011 檢核應排除發票為空白資料
# Modify.........: No:TQC-B10069 11/01/13 By lixh1  整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B40040 11/08/03 By nanbing 將程式改為共享程式，可執行amdi100和amdi101兩支作業
# Modify.........: No.CHI-B90005 11/09/09 By Polly 增加檢核，若amd171 = 26 or 27 時，amd04 不可為空
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C50043 12/05/08 By Elise 格式編號為34時，應該是能進行修改的，但程式會在after field amd05卡住
# Modify.........: No:MOD-C60075 12/06/11 By Polly 針加銷售金額控卡，折讓單折讓金額不可超過此發票金額!
# Modify.........: No:MOD-C70087 12/07/09 By Polly 增加年月輸入檢查
# Modify.........: No:MOD-C70250 12/08/06 By Polly 針對amd171為31,32,35時檢核發票號碼
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:CHI-D10058 13/02/01 By apo AFTER FIELD amd08增加判斷若無發票號碼(g_amd.amd03),則不需進行MOD-C60075的程式段
# Modify.........: No:MOD-D30141 13/03/14 By apo 錯誤訊息提示增加項次(amd02)
# Modify.........: No:CHI-D30021 13/04/01 By apo 格式編號為21,22,25,26,27,28類進項格式的部分,增加扣抵代號為條件值
# Modify.........: No:MOD-CC0245 13/04/03 By apo 針對日商客戶起始期別為07/01，故不可用s_azn來抓取期別
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_amd   RECORD LIKE amd_file.*,
    g_amd_t RECORD LIKE amd_file.*,
    g_amd01_t  LIKE amd_file.amd01,
    g_amd02_t  LIKE amd_file.amd02,
    g_amd021_t LIKE amd_file.amd021,
    g_ary  ARRAY [08] OF RECORD
         plant   LIKE azp_file.azp01,      #No.FUN-680074 VARCHAR(10) #No:9017
         dbs_nem LIKE type_file.chr21      #No.FUN-680074 VARCHAR(21)
    END RECORD
DEFINE tm  RECORD
            byy    LIKE type_file.num5,    #No.FUN-680074 SMALLINT
            bmm    LIKE type_file.num5,    #No.FUN-680074 SMALLINT
            eyy    LIKE type_file.num5,    #No.FUN-680074 SMALLINT
            emm    LIKE type_file.num5     #No.FUN-680074 SMALLINT           
           END RECORD,
    g_wc,g_sql          STRING,  #No.FUN-580092 HCN        #No.FUN-680074
    g_ama08             LIKE ama_file.ama08,
    g_ama09             LIKE ama_file.ama09,
    g_ama10             LIKE ama_file.ama10,
    g_ama12             LIKE ama_file.ama12,
    g_argv1             LIKE amd_file.amd01,
    g_argv2             LIKE amd_file.amd05,
    g_argv3             LIKE amd_file.amd021,
    g_argv4             LIKE type_file.chr1,   #FUN-B40040 
    g_amf           DYNAMIC ARRAY OF RECORD    # 程式變數(Program Variables)
        amf03       LIKE amf_file.amf03,   #
        amf022      LIKE amf_file.amf022,  # No:8236
        amf04       LIKE amf_file.amf04,   #
        amf06       LIKE amf_file.amf06,   #
        amf07       LIKE amf_file.amf07    #
                    END RECORD,
    g_amf_t         RECORD                 # 程式變數 (舊值)
        amf03       LIKE amf_file.amf03,   #
        amf022      LIKE amf_file.amf022,  # No:8236
        amf04       LIKE amf_file.amf04,   #
        amf06       LIKE amf_file.amf06,   #
        amf07       LIKE amf_file.amf07    #
                    END RECORD,
    g_rec_b         LIKE type_file.num5,                # 單身筆數        #No.FUN-680074 SMALLINT
    l_ac            LIKE type_file.num5,                # 目前處理的ARRAY CNT        #No.FUN-680074 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-680074 SMALLINT # 目前處理的SCREEN LINE
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  #No.FUN-680074
DEFINE g_before_input_done   STRING                      #No.FUN-680074
DEFINE g_chr                LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE g_msg                LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(72)
DEFINE g_row_count          LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE g_curs_index         LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE g_jump               LIKE type_file.num10         #No.FUN-680074 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5          #No.FUN-680074 SMALLINT
DEFINE cb                    ui.ComboBox      #FUN-B40040
DEFINE cb2                   ui.ComboBox      #FUN-B40040  
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680074 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    #FUN-B40040 Begin -----
    LET g_argv1 = ARG_VAL(1)   #傳票編號
    LET g_argv2 = ARG_VAL(2)   #帳款日期
    LET g_argv3 = ARG_VAL(3) 
    LET g_argv4 = ARG_VAL(4)  
    IF NOT cl_null(g_argv4) THEN
       IF g_argv4 ='2' THEN
          LET g_prog = 'amdi101'
       ELSE
          LET g_prog = 'amdi100'
       END IF
    ELSE 
       LET g_argv4 = '1'
       LET g_prog= 'amdi100'
    END IF    
    #FUN-B40040 End ------     
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("AMD")) THEN
       EXIT PROGRAM
    END IF
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
 
    INITIALIZE g_amd.* TO NULL
    INITIALIZE g_amd_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM amd_file WHERE  amd01 = ?  AND amd02 = ? AND amd021 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_curl CURSOR  FROM g_forupd_sql    # LOCK CURSOR
    #FUN-B40040 Begin Mark --- 
    #LET g_argv1 = ARG_VAL(1)   #傳票編號
    #LET g_argv2 = ARG_VAL(2)   #帳款日期
    #LET g_argv3 = ARG_VAL(3)
    #FUN-B40040 End Mark ---
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW i100_w AT p_row,p_col
        WITH FORM "amd/42f/amdi100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #FUN-B40040 Begin -------
    IF g_argv4 = '2' THEN 
       CALL cl_set_comp_visible('amd032,amd033,amd126',TRUE)
    ELSE 
    	 CALL cl_set_comp_visible('amd032,amd033,amd126',FALSE)
    END IF 
    IF g_argv4 = '1' THEN 
       LET cb = ui.ComboBox.forName("amd021")
       CALL cb.removeItem('6')
       LET cb2 = ui.ComboBox.forName("amd172")
       CALL cb2.removeItem('4')
    ELSE
 　　　 LET cb = ui.ComboBox.forName("amd021")
       CALL cb.removeItem('1')
       CALL cb.removeItem('2')　
       CALL cb.removeItem('3')
       CALL cb.removeItem('4')
       CALL cb.removeItem('5')　   
    END IF  
    #FUN-B40040 End ----------    
    SELECT * INTO g_ooz.*
      FROM ooz_file
     WHERE ooz00='0'
    IF cl_null(g_ooz.ooz64) THEN LET g_ooz.ooz64='N' END IF
    IF NOT cl_null(g_argv1) THEN CALL i100_q() END IF
 
    LET g_action_choice=""
    CALL i100_menu()
 
    CLOSE WINDOW i100_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
END MAIN
 
FUNCTION i100_curs()
    CLEAR FORM
    CALL g_amf.clear()
    IF cl_null(g_argv1) THEN
       WHILE TRUE
   INITIALIZE g_amd.* TO NULL    #No.FUN-750051
          CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          amd01, amd02, amd021,amd28 ,amd22,
          amd173,amd174,amd29,amd126, amd031, amd03 ,amd032,amd05,   #FUN-770040 #FUN-B40040 add amd126,amd032 
          amd04, amd033,amd171,amd17, amd172,amd08,  #FUN-B40040 add amd033
          amd07, amd06, amd09, amd30,                      #No.FUN-4C0091
          amd25, amd26, amd27, amd175,amd44,     #FUN-8B0081 add amd44
          amduser,amdgrup,amdmodu,amddate
         ,amdud01,amdud02,amdud03,amdud04,amdud05,
          amdud06,amdud07,amdud08,amdud09,amdud10,
          amdud11,amdud12,amdud13,amdud14,amdud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
            ON ACTION CONTROLP
               CASE
                 WHEN INFIELD(amd22)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_ama"
                    LET g_qryparam.state    ="c"
                    LET g_qryparam.default1 = g_amd.amd22
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO amd22
                    NEXT FIELD amd22
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
          IF INT_FLAG THEN  EXIT WHILE  END IF
          IF g_wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
          EXIT WHILE
       END WHILE
    ELSE LET g_wc = " amd28 = '",g_argv1 CLIPPED,"'"   #MOD-720010
    END IF
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('amduser', 'amdgrup')
    #FUN-B40040 Begin ---
    IF g_argv4 = '1' THEN
       LET g_wc = g_wc CLIPPED," AND amd021 <> '6' "
    ELSE
      LET g_wc = g_wc CLIPPED," AND amd021 = '6' "   
    END IF
    #FUN-B40040 End --- 
    LET g_sql="SELECT amd01,amd02,amd021 FROM amd_file ",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY amd01,amd02,amd021"
    PREPARE i100_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i100_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM amd_file WHERE ",g_wc CLIPPED
    PREPARE i100_countpre FROM g_sql
    DECLARE i100_count                        # SCROLL CURSOR
         CURSOR WITH HOLD FOR i100_countpre
END FUNCTION
 
FUNCTION i100_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            #FUN-B40040 Begin ---
            IF g_argv4 = '2' THEN
               CALL DIALOG.setActionActive( "insert", 0 )
               CALL DIALOG.setActionActive( "modify", 0 )
               CALL DIALOG.setActionActive( "reproduce", 0 )
               CALL DIALOG.setActionActive( "delete", 0 )
               CALL cl_set_act_visible("confirm,undo_confirm,batch_delete,gen_pur_vou",FALSE) 
               CALL cl_set_act_visible("give_s_n,sale_detail,asset_detail",FALSE) 
            END IF 
            #FUN-B40040 End --- 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i100_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i100_q()
            END IF
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i100_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i100_r()
            END IF
 
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
                CALL i100_copy()
           END IF
 
        ON ACTION batch_delete
            LET g_action_choice="batch_delete"
            IF cl_chk_act_auth() THEN
                CALL i100_c()
            END IF
        ON ACTION gen_pur_vou
            LET g_action_choice="gen_pur_vou"
            IF cl_chk_act_auth() THEN
                 CALL cl_cmdrun("amdp020")
            END IF
        ON ACTION gen_sls_vou
            LET g_action_choice="gen_sls_vou"
            IF cl_chk_act_auth() THEN
               IF g_argv4 = '1' THEN      #FUN-B40040 add
                  CALL cl_cmdrun("amdp010")
               #FUN-B40040 Begin ---
               ELSE                         
                  CALL cl_cmdrun("amdp011")    
               END IF 
               #FUN-B40040 End ---
            END IF
        ON ACTION give_s_n
            LET g_action_choice="give_s_n"
            IF cl_chk_act_auth() THEN
                 CALL i100_t()
            END IF
        ON ACTION doc_data
           LET g_action_choice="doc_data"
           IF cl_chk_act_auth() THEN
              CALL i100_1()
           END IF
        ON ACTION sale_detail   #No.MOD-470411
           LET g_action_choice="sale_detail"
           IF cl_chk_act_auth() THEN
               CALL i100_2('0') #FUN-6C0054 加傳參數0
           END IF
        ON ACTION asset_detail    #資產明細
           LET g_action_choice="asset_detail"
           IF cl_chk_act_auth() THEN
               CALL i100_2('1')
           END IF
        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()          #TQC-B10069  
               CALL i100_firm1()
               CALL cl_set_field_pic(g_amd.amd30,"","","","",g_amd.amdacti)
               CALL s_showmsg()               #TQC-B10069
            END IF
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()          #TQC-B10069 
               CALL i100_firm2()
               CALL cl_set_field_pic(g_amd.amd30,"","","","",g_amd.amdacti)
               CALL s_showmsg()               #TQC-B10069
            END IF
 
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic(g_amd.amd30,"","","","",g_amd.amdacti)
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION first
           CALL i100_fetch('F')
        ON ACTION previous
           CALL i100_fetch('P')
        ON ACTION jump
           CALL i100_fetch('/')
        ON ACTION next
           CALL i100_fetch('N')
        ON ACTION last
           CALL i100_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION related_document             #相關文件"                        
         LET g_action_choice="related_document"           
            IF cl_chk_act_auth() THEN                     
               IF g_amd.amd01 IS NOT NULL THEN            
                  LET g_doc.column1 = "amd01"               
                  LET g_doc.column2 = "amd02"     
                  LET g_doc.column3 = "amd021"          
                  LET g_doc.value1 = g_amd.amd01            
                  LET g_doc.value2 = g_amd.amd02   
                  LET g_doc.value3 = g_amd.amd021         
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
    CLOSE i100_curs
END FUNCTION
 
 
FUNCTION i100_a()
  DEFINE l_amd02 LIKE amd_file.amd02,
          l_str   LIKE type_file.chr6            #No.FUN-680074 VARCHAR(06)
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_amf.clear()
    INITIALIZE g_amd.* TO NULL
    LET g_amd_t.*=g_amd.*
    LET g_amd01_t = NULL
    LET g_amd02_t = NULL
    LET g_amd021_t = NULL
    LET g_amd.amd021= g_argv3
    LET g_amd.amd28 = g_argv1    #No.+166 010531 by linda add
    IF cl_null(g_argv1) THEN LET g_amd.amd021= '4' END IF
    LET g_amd.amd173= YEAR(g_argv2)
    LET g_amd.amd174= MONTH(g_argv2)
    LET g_amd.amd06 = 0
    LET g_amd.amd07 = 0
    LET g_amd.amd08 = 0
    LET g_amd.amd25 = g_plant
    LET g_amd.amd30 = 'N'
    LET g_amd.amd033 = '1' #FUN-B40040
    LET g_amd.amduser = g_user
    LET g_amd.amdoriu = g_user #FUN-980030
    LET g_amd.amdorig = g_grup #FUN-980030
    LET g_amd.amdgrup = g_grup               #使用者所屬群
    LET g_amd.amddate = g_today
    LET g_amd.amdacti = 'Y'
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i100_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_amd.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_amf.clear()
            EXIT WHILE
        END IF
            LET l_str = g_amd.amd173 using '&&&&',g_amd.amd174 using'&&'
            CASE g_aza.aza41
              WHEN "1"
                LET g_amd.amd01 = 'zzz-',l_str
              WHEN "2"
                LET g_amd.amd01 = 'zzzz-',l_str
              WHEN "3"
                LET g_amd.amd01 = 'zzzzz-',l_str
            END CASE
        SELECT max(amd02) INTO l_amd02 FROM amd_file
                                      WHERE amd01 = g_amd.amd01
                                        AND amd021= g_amd.amd021
        IF cl_null(l_amd02) THEN LET l_amd02 = 0 END IF
        LET g_amd.amd02 = l_amd02 + 1
        IF g_amd.amd01 IS NULL OR g_amd.amd02 IS NULL OR
           g_amd.amd021 IS NULL THEN
            CONTINUE WHILE
        END IF
        LET g_amd.amd06 = g_amd.amd07 + g_amd.amd08
        IF cl_null(g_amd.amd28) THEN LET g_amd.amd28 = ' ' END IF
 
        LET g_amd.amdlegal = g_legal #No.FUN-980004
        IF cl_null(g_amd.amd44) THEN LET g_amd.amd44 = '3' END IF #TQC-980095    
        INSERT INTO amd_file VALUES(g_amd.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","amd_file",g_amd.amd01,g_amd.amd02,SQLCA.sqlcode,"","",1)    #No.FUN-660093
            CONTINUE WHILE
        ELSE
            DISPLAY BY NAME g_amd.amd01
            DISPLAY BY NAME g_amd.amd02
            DISPLAY BY NAME g_amd.amd021
            LET g_amd_t.* = g_amd.*                # 保存上筆資料
            SELECT amd01,amd02,amd021 INTO g_amd.amd01,g_amd.amd02,g_amd.amd021 FROM amd_file
             WHERE amd01 = g_amd.amd01
               AND amd02 = g_amd.amd02
               AND amd021= g_amd.amd021
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i100_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
        l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入        #No.FUN-680074 VARCHAR(1)
        l_type          LIKE type_file.chr3,          #No.FUN-680074 VARCHAR(3)
        l_gem02         LIKE gem_file.gem02,
        l_amb01         LIKE type_file.num5,          #No.FUN-680074 SMALLINT
        l_amb02         LIKE type_file.num5,          #No.FUN-680074 SMALLINT
        l_amb03         LIKE amb_file.amb03,          #No.FUN-680074 VARCHAR(2)
        l_amd07         LIKE amd_file.amd07,          #FUN-4C0022
        l_tax           LIKE amd_file.amd07,          #FUN-4C0022
        l_diff          LIKE amd_file.amd07,          #FUN-4C0022
        l_num           LIKE type_file.num5,          #No.FUN-680074 SMALLINT
        t_bdate,t_edate LIKE type_file.dat,           #No.FUN-680074 DATE
        l_bdate,l_edate LIKE type_file.dat,           #No.FUN-680074 DATE
        l_n             LIKE type_file.num5           #No.FUN-680074 SMALLINT
    DEFINE l_amd08_p    LIKE amd_file.amd08           #MOD-C60075 add  
    DEFINE l_amd08_m    LIKE amd_file.amd08           #MOD-C60075 add
    DEFINE l_oom        RECORD LIKE oom_file.*        #MOD-C70250 add
    DEFINE l_errmsg     STRING                        #CHI-D30021
 
    DISPLAY BY NAME g_amd.amd30,g_amd.amduser,g_amd.amdgrup,
                    g_amd.amdmodu,g_amd.amddate
    INPUT BY NAME g_amd.amdoriu,g_amd.amdorig,
          g_amd.amd01, g_amd.amd02, g_amd.amd021,g_amd.amd28 ,g_amd.amd22,
          g_amd.amd173,g_amd.amd174,g_amd.amd29, g_amd.amd031, g_amd.amd03 ,g_amd.amd05,   #FUN-770040
          g_amd.amd04, g_amd.amd171,g_amd.amd17, g_amd.amd172,g_amd.amd08,
          g_amd.amd07, g_amd.amd06, g_amd.amd09, g_amd.amd30,             #No.FUN-4C0091
          g_amd.amd126,g_amd.amd032,g_amd.amd033,  #FUN-B40040  add
          g_amd.amd25, g_amd.amd26, g_amd.amd27, g_amd.amd175,g_amd.amd44,    #FUN-8B0081 add amd44
	  g_amd.amduser,g_amd.amdgrup,g_amd.amdmodu,g_amd.amddate
         ,g_amd.amdud01,g_amd.amdud02,g_amd.amdud03,g_amd.amdud04,
          g_amd.amdud05,g_amd.amdud06,g_amd.amdud07,g_amd.amdud08,
          g_amd.amdud09,g_amd.amdud10,g_amd.amdud11,g_amd.amdud12,
          g_amd.amdud13,g_amd.amdud14,g_amd.amdud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i100_set_entry(p_cmd)
           CALL i100_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        BEFORE FIELD amd172
           CALL i100_set_entry(p_cmd)
 
 
 
        AFTER FIELD amd171
            IF (g_amd.amd171 NOT MATCHES '2[1-9]' AND             #no:7393
                g_amd.amd171 NOT MATCHES '3[1-8]') THEN    #FUN-5B0141
                NEXT FIELD amd171
            END IF
            IF NOT cl_null(g_amd.amd171) THEN
               IF g_amd.amd171 = '28' OR g_amd.amd171='29' THEN
                  LET g_amd.amd29 = '2'
                  DISPLAY BY NAME g_amd.amd29
               END IF
               #如果29一定要1這是規定
               IF g_amd.amd171 = '29' THEN
                  LET g_amd.amd172='1'
                  DISPLAY BY NAME g_amd.amd172
               END IF
              #--------------------MOD-C70250----------------------(S)
               IF g_amd.amd171 = '31' OR g_amd.amd171 = '32' OR
                  g_amd.amd171 = '35' THEN
                  IF g_amd.amd031 != 'X' THEN
                     LET l_amb01=YEAR(g_amd.amd05)
                     LET l_amb02=MONTH(g_amd.amd05)
                     SELECT * INTO l_oom.* FROM oom_file
                       WHERE oom07 <= g_amd.amd03
                         AND oom08 >= g_amd.amd03
                         AND oom01 = l_amb01
                         AND oom02 <= l_amb02
                         AND oom021 >= l_amb02
                         AND oom04 = g_amd.amd031
                     IF STATUS THEN
                        CALL cl_err(g_amd.amd03,'axr-128',0)
                        NEXT FIELD amd03
                     END IF
                  END IF
               END IF
              #--------------------MOD-C70250----------------------(E)
            END IF
 
            IF NOT cl_null(g_amd.amd03) OR g_amd.amd03 <> ' ' THEN  #MOD-A90178 
              #--CHI-D30021--(S)
               IF g_amd.amd171 = '21' OR g_amd.amd171 = '22' OR
                  g_amd.amd171 = '25' OR g_amd.amd171 = '26' OR
                  g_amd.amd171 = '27' OR g_amd.amd171 = '28' THEN

                  LET l_errmsg = 'amd-042'
                  SELECT COUNT(*) INTO l_n FROM amd_file
                   WHERE amd03 =g_amd.amd03
                     AND amd171=g_amd.amd171
                     AND amd17 =g_amd.amd17 
               ELSE
                  LET l_errmsg = 'amd-011'
              #--CHI-D30021--(E)
                  SELECT COUNT(*) INTO l_n FROM amd_file
                   WHERE amd03 =g_amd.amd03
                     AND amd171=g_amd.amd171
               END IF   #CHI-D30021
               IF p_cmd='u' AND g_amd.amd171=g_amd_t.amd171 THEN
                  IF l_n>1  AND g_amd.amd171 <> '23' AND
                                g_amd.amd171 <> '24' AND
                                g_amd.amd171 <> '29' AND
                                g_amd.amd171 <> '33' AND
                                g_amd.amd171 <> '34' THEN
                    #CALL cl_err('','amd-011',1)   #CHI-D30021 mark
                     CALL cl_err('',l_errmsg,1)    #CHI-D30021
                     NEXT FIELD amd171
                  END IF
               ELSE
                  IF l_n>0  AND g_amd.amd171 <> '23' AND
                                g_amd.amd171 <> '24' AND
                                g_amd.amd171 <> '29' AND
                                g_amd.amd171 <> '33' AND
                                g_amd.amd171 <> '34' THEN
                    #CALL cl_err('','amd-011',1)   #CHI-D30021 mark
                     CALL cl_err('',l_errmsg,1)    #CHI-D30021
                     NEXT FIELD amd171   #MOD-5A0279
                  END IF
               END IF   #MOD-5A0279
            END IF      #MOD-A90178
           #------------------------CHI-B90005---------------------------------START
            IF (g_amd.amd171 = '26' OR g_amd.amd171 = '27')  AND cl_null(g_amd.amd04) THEN
               NEXT FIELD amd04
            END IF
           #------------------------CHI-B90005-----------------------------------END
            LET g_amd_t.amd171=g_amd.amd171   #MOD-5A0279
 
        AFTER FIELD amd17
            #進項則一定要輸入扣抵代號
            IF g_amd.amd171 MATCHES '2*' THEN
               IF cl_null(g_amd.amd17) THEN NEXT FIELD amd17 END IF
            END IF
            IF NOT cl_null(g_amd.amd171) AND g_amd.amd17 NOT MATCHES '[1234]' THEN    #No.FUN-4C0091
               NEXT FIELD amd17
            END IF
           #--CHI-D30021--(S)
            IF NOT cl_null(g_amd.amd03) OR g_amd.amd03 <> ' ' THEN 
               IF g_amd.amd171 = '21' OR g_amd.amd171 = '22' OR
                  g_amd.amd171 = '25' OR g_amd.amd171 = '26' OR
                  g_amd.amd171 = '27' OR g_amd.amd171 = '28' THEN

                  SELECT COUNT(*) INTO l_n FROM amd_file
                   WHERE amd03 =g_amd.amd03
                     AND amd171=g_amd.amd171
                     AND amd17 =g_amd.amd17 
                  IF p_cmd='u' AND g_amd.amd17=g_amd_t.amd17 THEN
                     IF l_n>1  AND g_amd.amd171 <> '23' AND
                                   g_amd.amd171 <> '24' AND
                                   g_amd.amd171 <> '29' AND
                                   g_amd.amd171 <> '33' AND
                                   g_amd.amd171 <> '34' THEN
                        CALL cl_err('','amd-042',1)
                        NEXT FIELD amd17
                     END IF
                  ELSE
                     IF l_n>0  AND g_amd.amd171 <> '23' AND
                                   g_amd.amd171 <> '24' AND
                                   g_amd.amd171 <> '29' AND
                                   g_amd.amd171 <> '33' AND
                                   g_amd.amd171 <> '34' THEN
                        CALL cl_err('','amd-042',1)
                        NEXT FIELD amd17 
                     END IF
                  END IF 
               END IF 
            END IF     
           #--CHI-D30021--(E)
 
        AFTER FIELD amd172
            IF g_amd.amd172 NOT MATCHES '[123DF]' THEN NEXT FIELD amd172 END IF  #FUN-A10039
            IF g_amd.amd171='29' AND g_amd.amd172!='1' THEN
               NEXT FIELD amd172
            END IF
            CALL i100_set_no_entry(p_cmd)
 
       #---------------------------MOD-C70087--------------------------(S)
        AFTER FIELD amd173
            IF g_amd.amd173 IS NOT NULL THEN
               IF g_amd.amd173 < 1000 OR g_amd.amd173 > 2100 THEN
                  CALL cl_err('','afa-370',0)                        #年度資料錯誤
                  NEXT FIELD amd173
               END IF
            END IF

       #---------------------------MOD-C70087--------------------------(E)

        AFTER FIELD amd05
            IF NOT cl_null(g_amd.amd171) THEN
               # 判斷起始日期即可
              #IF g_amd.amd171 MATCHES '2*' OR g_amd.amd171 = '33' THEN   # 進項若申報月數 '2'   #MOD-740496  ##MOD-C50043 mark
               IF g_amd.amd171 MATCHES '2*' OR (g_amd.amd171 = '33' OR g_amd.amd171 = '34') THEN  #MOD-C50043
                  # 已申報 97/02 則本期可申報資料為 97/01 - 97/04
                 #CALL s_azn01(g_ama08,g_ama09)                          #上期期初  #MOD-CC0245 mark       
                 #     RETURNING t_bdate,t_edate                         #MOD-CC0245 mark
                  LET t_bdate  = MDY(g_ama09,1,g_ama08)                  #MOD-CC0245 add
                  # 進項憑證允許5年內資料皆可申報,
                  # 已申報 97/02 則本期可申報資料最早為 92/02
                  LET t_bdate=t_bdate-5 UNITS YEAR                       #FUN-8B0048
                                                   # 本期期末
               ELSE
                 #CALL s_azn01(g_ama08,g_ama09)    # 銷項只可申報本期資料 #MOD-CC0245 mark
                 #     RETURNING t_bdate,t_edate                          #MOD-CC0245 mark
                  LET t_edate  = MDY(g_ama09+1,1,g_ama08) - 1             #MOD-CC0245 add
                  LET t_bdate=t_edate+1
               END IF
               IF t_bdate > g_amd.amd05 THEN
                  CALL cl_err(t_bdate,'amd-004',0)
                  NEXT FIELD amd05
               END IF
   	      #不用判斷發票字
   	       IF  g_amd.amd29 = '1' AND
	          (g_amd.amd171 = '21' OR g_amd.amd171 = '22' OR
   		   g_amd.amd171 = '25') THEN
                  IF NOT cl_null(g_amd.amd03) THEN
                     LET l_amb01=YEAR(g_amd.amd05)
                     LET l_amb02=MONTH(g_amd.amd05)
                     LET l_amb03=g_amd.amd03[1,2]
                     CALL s_apkchk(l_amb01,l_amb02,l_amb03,g_amd.amd171)
                            RETURNING g_errno,g_msg
                     IF NOT cl_null(g_msg) THEN
                        CALL cl_getmsg('aap-766',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
                        PROMPT g_msg  CLIPPED FOR CHAR g_chr
                        IF g_chr MATCHES '[Yy]' THEN
                           IF NOT cl_null(g_errno) THEN NEXT FIELD amd03 END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF
 
        BEFORE FIELD amd07
            #原 #IF p_cmd='a' THEN ,下改下面判斷...
            IF ((g_amd.amd08 != g_amd_t.amd08) OR g_amd_t.amd08 IS NULL) OR
               ((g_amd.amd07 != g_amd_t.amd07) OR g_amd_t.amd07 IS NULL) OR
               (g_amd.amd172 <> g_amd_t.amd172) THEN
               IF g_amd.amd172='1' THEN
                  LET l_amd07 = g_amd.amd08 * 0.05     #有小數
                  LET g_amd.amd07 = g_amd.amd08 * 0.05
                  LET g_amd.amd07=cl_digcut(g_amd.amd07,g_azi04)    #No:8771
               ELSE
                  LET g_amd.amd07=0
               END IF
               DISPLAY BY NAME g_amd.amd07
            END IF
 
        AFTER FIELD amd08
            IF NOT cl_null(g_amd.amd08) THEN
               IF g_amd.amd08 < 0 THEN
                  CALL cl_err(g_amd.amd08,'axm-179',0)
                  NEXT FIELD amd08
               END IF
               IF NOT cl_null(g_amd.amd03) THEN   #CHI-D10058
                  #----------------------MOD-C60075-----------------(S)
                   IF g_amd.amd171 = '23' OR g_amd.amd171 = '24' OR
                      g_amd.amd171 = '29' OR g_amd.amd171 = '33' OR
                      g_amd.amd171 = '34' OR g_amd.amd171 = '38'THEN
                      SELECT amd08 INTO l_amd08_p FROM amd_file
                       WHERE amd03 = g_amd.amd03
                         AND amd171 NOT IN ('23','24','29','33','34','38')

                      SELECT SUM(amd08) INTO l_amd08_m FROM amd_file
                       WHERE amd03 = g_amd.amd03
                         AND amd171 IN ('23','24','29','33','34','38')
                      IF cl_null(l_amd08_p) THEN LET l_amd08_p = 0 END IF
                      IF cl_null(l_amd08_m) THEN LET l_amd08_m = 0 END IF
                      LET l_amd08_m = l_amd08_m + g_amd.amd08
                      IF l_amd08_p < l_amd08_m THEN
                         CALL cl_err(g_amd.amd08,'aap-062',0)
                         NEXT FIELD amd08
                      END IF
                   END IF
                  #----------------------MOD-C60075-----------------(E)
               END IF   #CHI-D10058 
            END IF
 
 
 
        AFTER FIELD amd07
            IF cl_null(g_amd.amd07) THEN LET g_amd.amd07 = 0 END IF
            IF NOT cl_null(g_amd.amd07) THEN
               IF g_amd.amd07 < 0 THEN
                  CALL cl_err(g_amd.amd07,'axm-179',0)
                  NEXT FIELD amd07
               END IF
               IF (g_amd.amd07 != g_amd_t.amd07) OR g_amd_t.amd07 IS NULL THEN
                  IF g_amd.amd172 = '1' THEN
                     LET l_tax = g_amd.amd08 * 0.05
                     LET l_diff = g_amd.amd07 - l_tax
                     IF l_diff > 1 OR l_diff < -1 THEN
                        IF NOT cl_confirm('aap-320') THEN
                           NEXT FIELD amd07
                        END IF
                     END IF
                  ELSE
                     IF g_amd.amd07 != 0 THEN
                        NEXT FIELD amd07
                     END IF
                  END IF
               END IF
               LET g_amd.amd06 = g_amd.amd07 + g_amd.amd08
               DISPLAY BY NAME g_amd.amd06
               LET g_amd_t.amd07=g_amd.amd07
            END IF
 
        AFTER FIELD amd04
            IF NOT cl_null(g_amd.amd04) THEN
               IF g_aza.aza21 = 'Y' AND NOT s_chkban(g_amd.amd04) THEN
                  CALL cl_err('','aoo-080',0) NEXT FIELD amd04
               END IF
            END IF
 
        AFTER FIELD amd174
            IF NOT cl_null(g_amd.amd174) THEN
               CALL s_azn01(g_amd.amd173,g_amd.amd174)
                    RETURNING l_bdate,l_edate
               IF l_bdate < t_bdate THEN
                  CALL cl_err(t_bdate,'amd-005',0)
                  NEXT FIELD amd174
               END IF
              #------------------------MOD-C70087-------------------(S)
               IF g_amd.amd174 > 12 OR g_amd.amd174 < 1 THEN
                  CALL cl_err('','afa-371',0)                    #年度資料錯誤
                  NEXT FIELD amd174
               END IF
              #------------------------MOD-C70087-------------------(E)
            END IF
 
        AFTER FIELD amd09
            IF NOT cl_null(g_amd.amd09) THEN
               IF g_amd.amd09 != 'A' THEN NEXT FIELD amd09 END IF
            END IF
 
 
        AFTER FIELD amd03
            IF NOT cl_null(g_amd.amd03) THEN
               LET l_num = LENGTH(g_amd.amd03)
               IF g_amd.amd171 = '28' OR g_amd.amd171='29'    #bug no:7393
               THEN IF l_num != 14 THEN
                       CALL cl_err(g_amd.amd03,'amd-009',0)
                       NEXT FIELD amd03
                    END IF
               ELSE
                  #不檢查發票字軌,不檢查發票
                  IF g_amd.amd29 !='2' THEN
                   #IF l_num != 10 THEN                                                 #MOD-A90102 mark
                    IF l_num != 10 AND (g_amd.amd031 = '2' OR g_amd.amd031 = '3') THEN  #MOD-A90102
                       CALL cl_err(g_amd.amd03,'amd-010',0)
                       NEXT FIELD amd03
                    END IF
                  END IF
               END IF
              #--------------------MOD-C70250----------------------(S)
               IF NOT cl_null(g_amd.amd171) AND (g_amd.amd171 = '31' OR g_amd.amd171 = '32' OR
                  g_amd.amd171 = '35') THEN
                  IF g_amd.amd031 != 'X' THEN
                     LET l_amb01=YEAR(g_amd.amd05)
                     LET l_amb02=MONTH(g_amd.amd05)
                     SELECT * INTO l_oom.* FROM oom_file
                       WHERE oom07 <= g_amd.amd03
                         AND oom08 >= g_amd.amd03
                         AND oom01 = l_amb01
                         AND oom02 <= l_amb02
                         AND oom021 >= l_amb02
                         AND oom04 = g_amd.amd031
                     IF STATUS THEN
                        CALL cl_err(g_amd.amd03,'axr-128',0)
                        NEXT FIELD amd03
                     END IF
                  END IF
               END IF
              #--------------------MOD-C70250----------------------(E)
               IF g_amd.amd03 <> ' ' THEN  #MOD-A90178 
                 #--CHI-D30021--(S)
                  IF g_amd.amd171 = '21' OR g_amd.amd171 = '22' OR
                     g_amd.amd171 = '25' OR g_amd.amd171 = '26' OR
                     g_amd.amd171 = '27' OR g_amd.amd171 = '28' THEN

                     LET l_errmsg = 'amd-042'
                     SELECT COUNT(*) INTO l_n FROM amd_file
                      WHERE amd03 =g_amd.amd03
                        AND amd171=g_amd.amd171
                        AND amd17 =g_amd.amd17 
                  ELSE
                     LET l_errmsg = 'amd-011'
                 #--CHI-D30021--(E)
                     SELECT COUNT(*) INTO l_n FROM amd_file
                      WHERE amd03 =g_amd.amd03
                        AND amd171=g_amd.amd171
                  END IF   #CHI-D30021
                  IF p_cmd='u' AND g_amd.amd03=g_amd_t.amd03 THEN
                     IF l_n>1  AND g_amd.amd171 <> '23' AND
                                   g_amd.amd171 <> '24' AND
                                   g_amd.amd171 <> '29' AND
                                   g_amd.amd171 <> '33' AND
                                   g_amd.amd171 <> '34' THEN
                       #CALL cl_err('','amd-011',1)   #CHI-D30021 mark
                        CALL cl_err('',l_errmsg,1)    #CHI-D30021
                        NEXT FIELD amd03
                     END IF
                  ELSE
                     IF l_n>0  AND g_amd.amd171 <> '23' AND
                                   g_amd.amd171 <> '24' AND
                                   g_amd.amd171 <> '29' AND
                                   g_amd.amd171 <> '33' AND
                                   g_amd.amd171 <> '34' THEN
                       #CALL cl_err('','amd-011',1)   #CHI-D30021 mark
                        CALL cl_err('',l_errmsg,1)    #CHI-D30021
                        NEXT FIELD amd03
                     END IF
                  END IF    #MOD-5A0279
               END IF    #MOD-A90178
            END IF
            LET g_amd_t.amd03=g_amd.amd03   #MOD-5A0279
 
        AFTER FIELD amd22
            IF NOT cl_null(g_amd.amd22) THEN
               CALL i100_amd22(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_amd.amd01,g_errno,0)
                  DISPLAY BY NAME g_amd.amd22
                  NEXT FIELD amd22
               END IF
            END IF
 
        AFTER FIELD amdud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD amdud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_amd.amduser = s_get_data_owner("amd_file") #FUN-C10039
           LET g_amd.amdgrup = s_get_data_group("amd_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF NOT cl_null(g_amd.amd03) THEN
               LET l_num = LENGTH(g_amd.amd03)
               IF g_amd.amd171 = '28' OR g_amd.amd171='29'  THEN 
                 IF l_num != 14 THEN
                       CALL cl_err(g_amd.amd03,'amd-009',0)
                       NEXT FIELD amd03
                 END IF
               ELSE
                  IF g_amd.amd29 !='2' THEN
                   #IF l_num != 10 THEN                                                 #MOD-A90102 mark
                    IF l_num != 10 AND (g_amd.amd031 = '2' OR g_amd.amd031 = '3') THEN  #MOD-A90102
                       CALL cl_err(g_amd.amd03,'amd-010',0)
                       NEXT FIELD amd03
                    END IF
                  END IF
               END IF
               IF g_amd.amd03 <> ' ' THEN  #MOD-A90178 
                 #--CHI-D30021--(S)
                  IF g_amd.amd171 = '21' OR g_amd.amd171 = '22' OR
                     g_amd.amd171 = '25' OR g_amd.amd171 = '26' OR
                     g_amd.amd171 = '27' OR g_amd.amd171 = '28' THEN
 
                     LET l_errmsg = 'amd-042'
                     SELECT COUNT(*) INTO l_n FROM amd_file
                      WHERE amd03 =g_amd.amd03
                        AND amd171=g_amd.amd171
                        AND amd17 =g_amd.amd17 
                  ELSE
                     LET l_errmsg = 'amd-011'
                 #--CHI-D30021--(E)
                     SELECT COUNT(*) INTO l_n FROM amd_file
                      WHERE amd03 =g_amd.amd03
                        AND amd171=g_amd.amd171
                  END IF   #CHI-D30021
                  IF p_cmd='u' AND g_amd.amd03=g_amd_t.amd03 THEN
                     IF l_n>1  AND g_amd.amd171 <> '23' AND
                                   g_amd.amd171 <> '24' AND
                                   g_amd.amd171 <> '29' AND
                                   g_amd.amd171 <> '33' AND
                                   g_amd.amd171 <> '34' THEN
                       #CALL cl_err('','amd-011',1)   #CHI-D30021 mark
                        CALL cl_err('',l_errmsg,1)    #CHI-D30021
                        NEXT FIELD amd03
                     END IF
                  ELSE
                     IF l_n>0  AND g_amd.amd171 <> '23' AND
                                   g_amd.amd171 <> '24' AND
                                   g_amd.amd171 <> '29' AND
                                   g_amd.amd171 <> '33' AND
                                   g_amd.amd171 <> '34' THEN
                       #CALL cl_err('','amd-011',1)   #CHI-D30021 mark
                        CALL cl_err('',l_errmsg,1)    #CHI-D30021
                        NEXT FIELD amd03
                     END IF
                  END IF  
               END IF       #MOD-A90178 
              #------------------------CHI-B90005---------------------------------START
               IF (g_amd.amd171 = '26' OR g_amd.amd171 = '27') AND cl_null(g_amd.amd04) THEN
                  NEXT FIELD amd04
               END IF
              #------------------------CHI-B90005-----------------------------------END
            END IF
	    IF g_amd.amd29 = '1' AND
	      (g_amd.amd171 = '21' OR g_amd.amd171 = '22' OR
	       g_amd.amd171 = '25') THEN
               IF cl_null(g_amd.amd03)
               THEN DISPLAY BY NAME g_amd.amd03
                  NEXT FIELD amd03
               END IF
               IF NOT cl_null(g_amd.amd03) THEN
                  LET l_amb01=YEAR(g_amd.amd05)
                  LET l_amb02=MONTH(g_amd.amd05)
                  LET l_amb03=g_amd.amd03[1,2]
                  CALL s_apkchk(l_amb01,l_amb02,l_amb03,g_amd.amd171)
                      RETURNING g_errno,g_msg
                  IF NOT cl_null(g_msg) THEN
                     ERROR g_msg,' invoice =',g_amd.amd03,
	               ' SQLCODE=',g_errno
                     CALL cl_getmsg('aap-766',g_lang) RETURNING g_msg
                     LET INT_FLAG = 0  ######add for prompt bug
                      PROMPT g_msg  CLIPPED FOR CHAR g_chr
                  
                     ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                     
                     ON ACTION about         #MOD-4C0121
                        CALL cl_about()      #MOD-4C0121
                     
                     ON ACTION help          #MOD-4C0121
                        CALL cl_show_help()  #MOD-4C0121
                     
                     ON ACTION controlg      #MOD-4C0121
                        CALL cl_cmdask()     #MOD-4C0121
                  
                  
                     END PROMPT
                     IF g_chr MATCHES '[Yy]' THEN
                        IF g_errno='1' OR g_errno='2'  THEN
                           NEXT FIELD amd05
                        ELSE
                           IF g_errno='3'  THEN
                              NEXT FIELD amd03
                           ELSE
                              NEXT FIELD amd171
                           END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF
#不卡金額是否為零 980910..canny
 
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(amd22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     ="q_ama"
                 LET g_qryparam.default1 = g_amd.amd22
                 CALL cl_create_qry() RETURNING g_amd.amd22
                 DISPLAY BY NAME g_amd.amd22
                 NEXT FIELD amd22
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
 
FUNCTION i100_amd22(p_cmd)              #部門代號
DEFINE
    p_cmd      LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
    l_ama02    LIKE ama_file.ama02,
    l_ama03    LIKE ama_file.ama03,
    l_gem02    LIKE gem_file.gem02,
    l_amaacti  LIKE ama_file.amaacti
 
    LET g_errno = ' '
    SELECT ama02,ama03,ama08,ama09,ama10,ama12,amaacti,gem02
      INTO l_ama02,l_ama03,g_ama08,g_ama09,g_ama10,g_ama12,l_amaacti,l_gem02
      FROM ama_file LEFT OUTER JOIN gem_file ON ama_file.ama01=gem_file.gem01
     WHERE ama01 = g_amd.amd22 
      CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'amd-002'
                                  LET l_gem02 = NULL LET l_ama02 = ' '
                                  LET l_ama03 = ' '
         WHEN l_amaacti = 'N'     LET g_errno = '9028'
         OTHERWISE
          LET g_errno = SQLCA.SQLCODE USING'-------'
      END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
       DISPLAY l_ama02 TO FORMONLY.ama02
       DISPLAY l_ama03 TO FORMONLY.ama03
    END IF
END FUNCTION
 
FUNCTION i100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_amd.* TO NULL                #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i100_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_amf.clear()
        RETURN
    END IF
    OPEN i100_count
    FETCH i100_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i100_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amd.amd01,SQLCA.sqlcode,0)
        INITIALIZE g_amd.* TO NULL
    ELSE
        CALL i100_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i100_fetch(p_flamd)
    DEFINE
        p_flamd         LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
        l_abso          LIKE type_file.num10,         #No.FUN-680074 INTEGER
        l_amd171        LIKE amd_file.amd171
 
    CASE p_flamd
        WHEN 'N' FETCH NEXT     i100_curs INTO g_amd.amd01,
                                               g_amd.amd02,g_amd.amd021
        WHEN 'P' FETCH PREVIOUS i100_curs INTO g_amd.amd01,
                                               g_amd.amd02,g_amd.amd021
        WHEN 'F' FETCH FIRST    i100_curs INTO g_amd.amd01,
                                               g_amd.amd02,g_amd.amd021
        WHEN 'L' FETCH LAST     i100_curs INTO g_amd.amd01,
                                               g_amd.amd02,g_amd.amd021
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
            FETCH ABSOLUTE g_jump i100_curs INTO g_amd.amd01,
                                                  g_amd.amd02,g_amd.amd021
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amd.amd01,SQLCA.sqlcode,0)
        INITIALIZE g_amd.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flamd
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_amd.* FROM amd_file            # 重讀DB,因TEMP有不被更新特性
     WHERE amd01 = g_amd.amd01 AND amd02 = g_amd.amd02 AND amd021 = g_amd.amd021 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","amd_file",g_amd.amd01,g_amd.amd02,SQLCA.sqlcode,"","",1)  #No.FUN-660093
    ELSE
       LET g_data_owner = g_amd.amduser     #No.FUN-4C0050
       LET g_data_group = g_amd.amdgrup     #No.FUN-4C0050
       CALL i100_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i100_show()
  DEFINE l_ama02  LIKE ama_file.ama02,
         l_ama03  LIKE ama_file.ama03 
 
    LET g_amd_t.* = g_amd.*
    DISPLAY BY NAME g_amd.amdoriu,g_amd.amdorig,
          g_amd.amd01, g_amd.amd02, g_amd.amd021,g_amd.amd28 ,g_amd.amd22,
          g_amd.amd173,g_amd.amd174,g_amd.amd29, g_amd.amd031, g_amd.amd03 ,g_amd.amd05,   #FUN-770040
          g_amd.amd04, g_amd.amd171,g_amd.amd17, g_amd.amd172,g_amd.amd08,
          g_amd.amd07, g_amd.amd06, g_amd.amd09,  g_amd.amd30,          #No.FUN-4C0091
          g_amd.amd25, g_amd.amd26, g_amd.amd27, g_amd.amd175,g_amd.amd44, #FUN-8B0081 add amd44
          g_amd.amd126,g_amd.amd032,g_amd.amd033,  #FUN-B40040  add
          g_amd.amduser,g_amd.amdgrup,g_amd.amdmodu,g_amd.amddate
         ,g_amd.amdud01,g_amd.amdud02,g_amd.amdud03,g_amd.amdud04,
          g_amd.amdud05,g_amd.amdud06,g_amd.amdud07,g_amd.amdud08,
          g_amd.amdud09,g_amd.amdud10,g_amd.amdud11,g_amd.amdud12,
          g_amd.amdud13,g_amd.amdud14,g_amd.amdud15 
    IF g_amd.amd26=0 THEN DISPLAY '' TO amd26 END IF
    IF g_amd.amd27=0 THEN DISPLAY '' TO amd27 END IF
    CALL i100_amd22('d')
    CALL cl_set_field_pic(g_amd.amd30,"","","","",g_amd.amdacti) #No.MOD-480268
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_amd.amd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_amd.amd30 = 'Y' THEN CALL cl_err(g_amd.amd01,'axr-101',0) RETURN END IF
 
    IF NOT cl_null(g_amd.amd26) AND g_amd.amd26 != 0 THEN   #MOD-9C0130
        CALL cl_err(g_amd.amd01,'amd-001',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
LET g_amd01_t = g_amd.amd01
LET g_amd02_t = g_amd.amd02
LET g_amd021_t = g_amd.amd021
    BEGIN WORK
    OPEN i100_curl USING g_amd.amd01,g_amd.amd02,g_amd.amd021
    IF STATUS THEN
       CALL cl_err("OPEN i100_curl:", STATUS, 1)
       CLOSE i100_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_curl INTO g_amd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amd.amd01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_amd.amdmodu=g_user                     #修改者
    LET g_amd.amddate = g_today                  #修改日期
    CALL i100_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i100_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_amd.*=g_amd_t.*
            CALL i100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE amd_file SET amd_file.* = g_amd.*    # 更新DB
         WHERE amd01 = g_amd01_t AND amd02 = g_amd02_t AND amd021 = g_amd021_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","amd_file",g_amd01_t,g_amd02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660093
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i100_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_r()
    DEFINE l_chr LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_amd.amd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_amd.amd30 = 'Y' THEN CALL cl_err(g_amd.amd01,'axr-101',0) RETURN END IF
 
    IF NOT cl_null(g_amd.amd26) AND g_amd.amd26 != 0 THEN   #MOD-9C0130
        CALL cl_err(g_amd.amd01,'amd-001',0)
        RETURN
    END IF
    BEGIN WORK
    LET g_success='Y'
    OPEN i100_curl USING g_amd.amd01,g_amd.amd02,g_amd.amd021
    IF STATUS THEN
       CALL cl_err("OPEN i100_curl:", STATUS, 1)
       CLOSE i100_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_curl INTO g_amd.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_amd.amd01,SQLCA.sqlcode,0) RETURN END IF
    CALL i100_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "amd01"          #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "amd02"          #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "amd021"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_amd.amd01       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_amd.amd02       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_amd.amd021      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
        DELETE FROM amd_file WHERE amd01 = g_amd.amd01 AND amd02 = g_amd.amd02 AND amd021 = g_amd.amd021 
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","amd_file",g_amd.amd01,g_amd.amd02,SQLCA.sqlcode,"","",1)  #No.FUN-660093
           LET g_success='N'
        ELSE
           DELETE FROM amf_file
            WHERE amf01=g_amd.amd01
              AND amf02=g_amd.amd02
              AND amf021=g_amd.amd021
           IF SQLCA.SQLCODE THEN 
              CALL cl_err3("del","amf_file",g_amd.amd01,g_amd.amd02,STATUS,"","del amf",1)   #No.FUN-660093
              LET g_success='N'
           END IF
           CLEAR FORM
           CALL g_amf.clear()
           OPEN i100_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE i100_curs
              CLOSE i100_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH i100_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i100_curs
              CLOSE i100_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i100_curs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i100_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i100_fetch('/')
           END IF
        END IF
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
   ELSE ROLLBACK WORK END IF
END FUNCTION
 
#  amdi100_s(amdi100_g) -> amdp101 -> amdi100_t
FUNCTION i100_t()
 DEFINE  l_sql   STRING,                              #No.FUN-680074
         l_no           LIKE type_file.chr18,       #No.FUN-680074 INT # saki 20070821 rowid chr18 -> num10 
         l_maxno,l_eno  LIKE type_file.num10,         #No.FUN-680074 INTEGER
         l_yy,l_mm      LIKE type_file.num5,          #No.FUN-680074 SMALLINT
         l_wc           LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(200)
l_amd01   LIKE amd_file.amd01,
l_amd171  LIKE amd_file.amd171,
l_amd02   LIKE amd_file.amd02,
l_amd021  LIKE amd_file.amd021,
         l_amd172 LIKE amd_file.amd172,
         l_amd17  LIKE amd_file.amd17
DEFINE p_row,p_col      LIKE type_file.num5           #No.FUN-680074 SMALLINT
 
    LET p_row = 12 LET p_col = 40
 
   OPEN WINDOW i100_w1 AT p_row,p_col WITH FORM "amd/42f/amdi100_o"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("amdi100_o")
 
    LET l_eno = 1
    LET l_yy = YEAR(g_today)
    LET l_mm  = MONTH(g_today) -1
 
    CONSTRUCT BY NAME l_wc ON amd22,amd05
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(amd22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     ="q_gem"
                 LET g_qryparam.state    ="c"
                 LET g_qryparam.default1 = g_amd.amd22
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO amd22
                 NEXT FIELD amd22
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
    IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i100_w1 RETURN  END IF
 
    LET tm.byy=YEAR(g_today)
    LET tm.eyy=YEAR(g_today)
    LET tm.bmm=MONTH(g_today)
    LET tm.emm=MONTH(g_today)
 
    INPUT BY NAME tm.byy,tm.bmm,tm.eyy,tm.emm,l_eno  WITHOUT DEFAULTS
      AFTER FIELD bmm
         IF tm.bmm > 12 OR tm.bmm < 1 THEN NEXT FIELD bmm END IF
      AFTER FIELD eyy
         IF tm.eyy < tm.byy THEN NEXT FIELD eyy END IF
      AFTER FIELD emm
         IF tm.emm > 12 OR tm.emm < 1 THEN NEXT FIELD emm END IF
         IF tm.byy+tm.bmm > tm.eyy+tm.emm THEN
            NEXT FIELD emm
         END IF
 
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
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
    IF INT_FLAG THEN LET INT_FLAG = 0  CLOSE WINDOW i100_w1 RETURN END IF
 
    CALL cl_wait()
{%%}    LET l_sql="SELECT amd01,amd02,amd021,amd171,amd17,amd172 FROM amd_file ",
              " WHERE ",l_wc CLIPPED,
              "   AND (amd173*12+amd174) BETWEEN ",
                      (tm.byy*12+tm.bmm)," AND ",
                      (tm.eyy*12+tm.emm),
              "   AND amd30 = 'Y' ",   #TQC-620118
             #"  ORDER BY amd172,amd17,amd171,amd01" #CHI-A80028 mark
              "  ORDER BY amd171,amd22,amd03" #CHI-A80028
    PREPARE i100_preno FROM l_sql
    DECLARE i100_curno
            CURSOR WITH HOLD FOR i100_preno
 
    IF l_eno is null or l_eno = ' ' THEN LET l_eno = 1 END IF
    FOREACH i100_curno INTO l_amd01,l_amd02,l_amd021,l_amd171,l_amd17 ,l_amd172
       IF SQLCA.sqlcode THEN
          CALL cl_err('i100_curno',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       #-->流水號
       message l_eno
       UPDATE amd_file SET amd175 = l_eno WHERE amd01 = l_amd01 AND amd02 = l_amd02 AND amd021 = l_amd021 
       IF SQLCA.sqlerrd[3] = 0 OR SQLCA.sqlcode
       THEN 
            CALL cl_err3("upd","amd_file",g_amd01_t,g_amd02_t,SQLCA.sqlcode,"","update chk",1)  #No.FUN-660093
            EXIT FOREACH
       END IF
       LET l_eno = l_eno + 1
    END FOREACH
    CALL cl_end(0,0)
    CLOSE WINDOW i100_w1
END FUNCTION
 
FUNCTION duplicate(l_plant,n)     #檢查輸入之工廠編號是否重覆
   DEFINE l_plant      LIKE azp_file.azp01
   DEFINE l_idx, n     LIKE type_file.num10      #No.FUN-680074 INTEGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].plant = l_plant THEN
          LET l_plant = ''
       END IF
   END FOR
   RETURN l_plant
END FUNCTION
 
FUNCTION i100_c()
  DEFINE l_sql     STRING        #No.FUN-680074
  DEFINE l_amd01   LIKE amd_file.amd01
  DEFINE l_amd02   LIKE amd_file.amd02
  DEFINE l_amd021  LIKE amd_file.amd021
 
   CLEAR FORM
   CALL g_amf.clear()
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
          amd01,amd02,
          amd26,amd27, amd021,amd175,amd44,amd28,  #FUN-8B0081 add amd44
          amd031,amd03,amd05,amd08,amd07,amd06,   #FUN-770040
          amd04,amd173,amd174,amd171,amd17,
          amd172,
          amd09,amd22,amd25,                     #No.FUN-4C0091
          amduser,amdgrup,amdmodu,amddate
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(amd22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     ="q_gem"
                 LET g_qryparam.state    ="c"
                 LET g_qryparam.default1 = g_amd.amd22
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO amd22
                 NEXT FIELD amd22
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
      IF INT_FLAG THEN EXIT WHILE END IF
      IF g_wc=' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
      EXIT WHILE
   END WHILE
   BEGIN WORK
   LET g_success = 'Y'
 
   IF cl_delete() THEN   #FUN-850072 add
       INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "amd01"          #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "amd02"          #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "amd021"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_amd.amd01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_amd.amd02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_amd.amd021      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()#No.FUN-9B0098 10/02/24
      #將原EXECUTE改寫成FOREACH FOR delete amf_file
      LET l_sql = "SELECT amd01,amd02,amd021 ",
                  "  FROM amd_file ",
                  " WHERE (amd26 IS NULL OR amd26 = 0 )",
                  "   AND amd30 = 'N' ",                  #未confirm可以刪除
                  "   AND ",g_wc CLIPPED
      PREPARE i100_c_pre FROM l_sql
      DECLARE i100_c_cur CURSOR FOR i100_c_pre
      CALL cl_wait()
      FOREACH i100_c_cur INTO l_amd01,l_amd02,l_amd021
          DELETE FROM amd_file
           WHERE amd01 =l_amd01
             AND amd02 =l_amd02
             AND amd021=l_amd021
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","amd_file",l_amd01,l_amd02,STATUS,"","del amd",1)  #No.FUN-660093
             LET g_success = 'N'
          END IF
          DELETE FROM amf_file
           WHERE amf01 =l_amd01
             AND amf02 =l_amd02
             AND amf021=l_amd021
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","amf_file",l_amd01,l_amd02,STATUS,"","del amf",1)   #No.FUN-660093
             LET g_success = 'N'
          END IF
         IF INT_FLAG THEN
            LET INT_FLAG=0
            CALL cl_err('','amd-013',1)
            LET g_success = 'N'
            ROLLBACK WORK
            RETURN
         END IF
      END FOREACH
   END IF   #FUN-850072 add
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_end(0,0)
   ELSE
      ROLLBACK WORK
   END IF
  
END FUNCTION
 
FUNCTION i100_firm1()
  DEFINE only_one  LIKE type_file.chr1      #No.FUN-680074 VARCHAR(1)
  DEFINE l_sql     STRING                   #No.FUN-680074
  DEFINE l_n       LIKE type_file.num5      #NO:7457        #No.FUN-680074 SMALLINT
  DEFINE l_amd01   LIKE amd_file.amd01      #NO:7457
  DEFINE l_amd02   LIKE amd_file.amd02      #NO:7457
  DEFINE l_amd021  LIKE amd_file.amd021     #NO:7457
  DEFINE l_amd03   LIKE amd_file.amd03      #NO:7457
  DEFINE l_amd171  LIKE amd_file.amd171     #NO:7457
  DEFINE l_errmsg  STRING                   #MOD-D30141
 
   LET g_success = 'Y'
   IF g_amd.amd01 IS NULL OR g_amd.amd02 IS NULL THEN
   #  CALL cl_err('','aqc-052',0)    #No:8475      #TQC-B10069
      CALL s_errmsg("amd01","","",'aqc-052',1)     #TQC-B10069
      LET g_success = 'N'                          #TQC-B10069
   #  RETURN    #TQC-B10069
   END IF
   IF not cl_null(g_amd.amd26) AND g_amd.amd26 <>0 THEN
   #  CALL cl_err(g_amd.amd01,'amd-001',0)         #TQC-B10069
      CALL s_errmsg("amd26",g_amd.amd01,g_amd.amd26,'amd-001',1)     #TQC-B10069
      LET g_success = 'N'                          #TQC-B10069
   #  RETURN    #TQC-B10069
   END IF
#TQC-B10069 --------------------------Begin-------------------------------------------
#  IF g_amd.amd30 = 'Y' THEN CALL cl_err(g_amd.amd01,'9023',0) RETURN END IF
   IF g_amd.amd30 = 'Y' THEN     
      LET l_errmsg=g_amd.amd01 CLIPPED,"/",g_amd.amd02 CLIPPED     #MOD-D30141
     #CALL s_errmsg("amd30",g_amd.amd01,g_amd.amd30,'9023',1)      #MOD-D30141 mark   #TQC-B10069
      CALL s_errmsg("amd01,amd02",l_errmsg,g_amd.amd30,'9023',1)   #MOD-D30141 
      LET g_success = 'N'                                         #TQC-B10069
   END IF
#TQC-B10069 --------------------------End--------------------------------------------- 
 
   OPEN WINDOW i100_c_w AT 8,18 WITH FORM "amd/42f/amdi100_c"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("amdi100_c")
 
 
   LET only_one = '1'
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i100_c_w
      RETURN
   END IF
 
   IF only_one = '1' THEN
      LET g_wc = " amd01 = '",g_amd.amd01,"'",
                 " AND amd02 = ",g_amd.amd02,
                 " AND amd021= '",g_amd.amd021,"' "
   ELSE
      CONSTRUCT BY NAME g_wc ON amd01,amd02,amd021,amd173,amd174,amd03,amd22   #MOD-5A0279
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
          ON ACTION CONTROLP
             CASE
               WHEN INFIELD(amd22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_gem"
                  LET g_qryparam.state    ="c"
                  LET g_qryparam.default1 = g_amd.amd22
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO amd22
                  NEXT FIELD amd22
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
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i100_c_w
         RETURN
      END IF
   END IF
   IF NOT cl_confirm('aap-222') THEN
      CLOSE WINDOW i100_c_w   #MOD-720119
      RETURN
   END IF
   CLOSE WINDOW i100_c_w
 
   BEGIN WORK
   #==>改寫原來,是為check 發票+格式是否為重覆!
   CALL cl_wait()
   LET l_sql = " SELECT amd01,amd02,amd021,amd03,amd171 FROM amd_file ",
               " WHERE  (amd26 IS NULL OR amd26 = 0 ) ",
               "   AND amd30 = 'N' ",                  #未confirm可以刪除
               "   AND ",g_wc CLIPPED
   PREPARE i100_c_pre3 FROM l_sql
   DECLARE i100_c_cur3 CURSOR FOR i100_c_pre3
 
   FOREACH i100_c_cur3 INTO l_amd01,l_amd02,l_amd021,l_amd03,l_amd171
     #IF NOT cl_null(l_amd03) THEN  #MOD-990126                    #MOD-A90178 mark 
      IF NOT cl_null(l_amd03) OR l_amd03 <> ' ' THEN  #MOD-990126  #MOD-A90178
        #--CHI-D30021--(S)
         IF g_amd.amd171 = '21' OR g_amd.amd171 = '22' OR
            g_amd.amd171 = '25' OR g_amd.amd171 = '26' OR
            g_amd.amd171 = '27' OR g_amd.amd171 = '28' THEN

            LET l_errmsg = 'amd-042'
            SELECT COUNT(*) INTO l_n FROM amd_file
             WHERE amd03 =g_amd.amd03
               AND amd171=g_amd.amd171
               AND amd17 =g_amd.amd17 
         ELSE
            LET l_errmsg = 'amd-011'
        #--CHI-D30021--(E)
            SELECT COUNT(*) INTO l_n FROM amd_file
          WHERE amd03 =l_amd03
            AND amd171=l_amd171
         END IF   #CHI-D30021
         IF l_n > 1 AND l_amd171 <> '23' AND #超過1筆
                        l_amd171 <> '24' AND
                        l_amd171 <> '29' AND
                        l_amd171 <> '33' AND
                        l_amd171 <> '34' THEN
           # CALL cl_err(l_amd03,'amd-011',1)               #TQC-B10069
           # CALL s_errmsg("",l_amd01,l_amd02,'amd-011',1)  #CHI-D30021 mark   #TQC-B10069
             CALL s_errmsg("",l_amd01,l_amd02,l_errmsg,1)   #CHI-D30021
             LET g_success='N'
           # EXIT FOREACH           #TQC-B10069
             CONTINUE FOREACH       #TQC-B10069
         END IF
      END IF #MOD-990126          
       IF l_amd01 IS NULL OR l_amd02 IS NULL THEN
        # CALL cl_err('','aqc-052',0)          #TQC-B10069
          CALL s_errmsg("","","",'aqc-052',1)  #TQC-B10069    
          LET g_success='N'
        # EXIT FOREACH             #TQC-B10069
          CONTINUE FOREACH         #TQC-B10069
       END IF
       UPDATE amd_file SET amd30='Y'
        WHERE amd01=l_amd01
          AND amd02=l_amd02
          AND amd021=l_amd021
       IF SQLCA.sqlcode THEN 
       #  CALL cl_err3("upd","amd_file",g_amd01_t,g_amd02_t,STATUS,"","upd amd30",1)   #No.FUN-660093  #TQC-B10069
          CALL s_errmsg("",g_amd01_t,"upd amd30",STATUS,1)   #TQC-B10069
          LET g_success = 'N'
       END IF
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK    
      CALL cl_end(0,0)
   ELSE ROLLBACK WORK END IF   
 
   SELECT * INTO g_amd.* FROM amd_file WHERE amd01 = g_amd.amd01
                                         AND amd02 = g_amd.amd02
                                         AND amd021= g_amd.amd021
   DISPLAY BY NAME g_amd.amd30
END FUNCTION
 
FUNCTION i100_firm2()
  DEFINE l_sql     STRING                       #No.FUN-680074
  DEFINE only_one  LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
   LET g_success = 'Y' #TQC-B10069
   IF g_amd.amd01 IS NULL OR g_amd.amd02 IS NULL THEN
     #CALL cl_err('','aqc-052',0)    #No:8475  #TQC-B10069
      CALL s_errmsg("","","",'aqc-052',1)      #TQC-B10069 
   #  RETURN    #TQC-B10069
   END IF
   IF not cl_null(g_amd.amd26) AND g_amd.amd26 <>0 THEN
     #CALL cl_err(g_amd.amd01,'amd-001',0)     #TQC-B10069  
      CALL s_errmsg("amd26","g_amd.amd01","",'amd-001',1)      #TQC-B10069  
   #  RETURN    #TQC-B10069
   END IF
#TQC-B10069 -------------------------------Begin----------------------------
  #IF g_amd.amd30 = 'N' THEN CALL cl_err(g_amd.amd01,'9025',0) RETURN END IF
   IF g_amd.amd30 = 'N' THEN 
      CALL s_errmsg("amd30",g_amd.amd01,"",'9025',1)   
   END IF
#TQC-B10069 -------------------------------End------------------------------ 
   OPEN WINDOW i100_u_w AT 8,18 WITH FORM "amd/42f/amdi100_u"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("amdi100_u")
 
 
   LET only_one = '1'
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i100_u_w
      RETURN
   END IF
 
   IF only_one = '1' THEN
      LET g_wc = " amd01 = '",g_amd.amd01,"'",
                 " AND amd02 = ",g_amd.amd02,
                 " AND amd021= '",g_amd.amd021,"' "
   ELSE
      CONSTRUCT BY NAME g_wc ON amd01,amd02,amd021,amd173,amd174,amd03,amd22   #MOD-5A0279
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
          ON ACTION CONTROLP
             CASE
               WHEN INFIELD(amd22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_gem"
                  LET g_qryparam.state    ="c"
                  LET g_qryparam.default1 = g_amd.amd22
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO amd22
                  NEXT FIELD amd22
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
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW i100_u_w
         RETURN
      END IF
   END IF
   IF NOT cl_confirm('aap-224') THEN
      CLOSE WINDOW i100_u_w   #MOD-720119
      RETURN
   END IF
   CLOSE WINDOW i100_u_w
 
   BEGIN WORK
   LET g_success = 'Y'
   #------已申報之年月不可confirm---------
   LET l_sql = "UPDATE amd_file SET amd30 = 'N'",
               " WHERE (amd26 IS NULL OR amd26 = 0 )",
	       "   AND amd30 = 'Y'",                   #未confirm可以刪除
               "   AND ",g_wc CLIPPED
   PREPARE i100_c_pre2 FROM l_sql
   CALL cl_wait()
   EXECUTE i100_c_pre2
   IF SQLCA.sqlcode THEN
    # CALL cl_err('del amd',STATUS,0)             #TQC-B10069
      CALL s_errmsg("","","del amd",'STATUS',1)   #TQC-B10069
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_end(0,0)
   ELSE ROLLBACK WORK END IF
   SELECT * INTO g_amd.* FROM amd_file WHERE amd01 = g_amd.amd01
                                         AND amd02 = g_amd.amd02
                                         AND amd021= g_amd.amd021
   DISPLAY BY NAME g_amd.amd30
END FUNCTION
 
FUNCTION i100_1()
   DEFINE l_cnt        LIKE type_file.num10         #No.FUN-680074 INTEGER
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680074 SMALLINT
   DEFINE l_num        LIKE type_file.num5          #MOD-8C0071 add
 
    IF g_amd.amd01 IS NULL THEN RETURN END IF
    IF g_amd.amd171 MATCHES '2*' THEN RETURN END IF
 
    LET p_row = 10 LET p_col = 18
    OPEN WINDOW i1001_w AT p_row,p_col WITH FORM "amd/42f/amdi100_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("amdi100_1")
 
 
    LET g_action_choice = "modify"
    IF NOT cl_chk_act_auth() THEN
 
       DISPLAY BY NAME g_amd.amd40,g_amd.amd41,g_amd.amd42,g_amd.amd43,
                       g_amd.amd35,g_amd.amd36,g_amd.amd37,
                       g_amd.amd38,g_amd.amd39,g_amd.amd10        #No.FUN-4C0091
 
       PROMPT ">" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       END PROMPT
       CLOSE WINDOW i1001_w
       RETURN
    END IF
 
    INPUT BY NAME g_amd.amd40,g_amd.amd41,g_amd.amd42,g_amd.amd43,
                  g_amd.amd35,g_amd.amd10,g_amd.amd36,g_amd.amd37,
                  g_amd.amd38,g_amd.amd39              #No.FUN-4C0091
          WITHOUT DEFAULTS
 
    BEFORE INPUT
       CALL i1001_set_entry()
       CALL i1001_set_no_entry()
 
 
    AFTER FIELD amd40
       SELECT count(*) INTO l_cnt  FROM occ_file
        WHERE occ01=g_amd.amd40
          AND occacti ='Y'
       IF l_cnt =0 THEN
           CALL cl_err(g_amd.amd40,'aap-129',0)
           LET g_amd.amd40=' '
           LET g_amd.amd41=' '
           DISPLAY BY NAME g_amd.amd40
           DISPLAY BY NAME g_amd.amd41
           NEXT FIELD amd40
       END IF
       IF g_amd_t.amd40 IS NULL OR g_amd.amd40 != g_amd_t.amd40 THEN
           CALL i100_amd40('a')
       END IF
 
    AFTER FIELD amd35
       IF NOT cl_null(g_amd.amd35) THEN
          IF g_amd.amd35 NOT MATCHES '[1234567]' THEN
             NEXT FIELD amd35
          END IF
       END IF
 
    AFTER FIELD amd36
       IF g_amd.amd10='1' AND cl_null(g_amd.amd36) THEN
          NEXT FIELD amd36
       END IF
 
    AFTER FIELD amd37
       IF g_amd.amd10='1' AND cl_null(g_amd.amd37) THEN
          NEXT FIELD amd37
       END IF
 
    AFTER FIELD amd38
       IF g_amd.amd10='2' AND cl_null(g_amd.amd38) THEN
          NEXT FIELD amd38
       END IF
 
    AFTER FIELD amd39
       IF g_amd.amd10='2' AND cl_null(g_amd.amd39) THEN
          NEXT FIELD amd39
       END IF
       IF g_amd.amd10='2' AND NOT cl_null(g_amd.amd39) THEN
          LET l_num = 0
          LET l_num = LENGTH(g_amd.amd39)
          IF l_num != 14 THEN
             CALL cl_err(g_amd.amd39,'amd-017',0)
             NEXT FIELD amd39
          END IF
       END IF
 
    AFTER FIELD amd10
       IF NOT cl_null(g_amd.amd10) THEN
          IF g_amd.amd10 NOT MATCHES '[12]' THEN
             NEXT FIELD amd10
          END IF
       END IF   #MOD-8C0220 add
          CALL i1001_set_entry()
          CALL i1001_set_no_entry()
 
   AFTER INPUT
     IF INT_FLAG THEN
        LET g_amd.amd40 = g_amd_t.amd40
        LET g_amd.amd41 = g_amd_t.amd41
        LET g_amd.amd42 = g_amd_t.amd42
        LET g_amd.amd43 = g_amd_t.amd43
        LET g_amd.amd35 = g_amd_t.amd35
        LET g_amd.amd10 = g_amd_t.amd10
        LET g_amd.amd36 = g_amd_t.amd36
        LET g_amd.amd37 = g_amd_t.amd37
        LET g_amd.amd38 = g_amd_t.amd38
        LET g_amd.amd39 = g_amd_t.amd39
        EXIT INPUT
     END IF
     CALL i1001_set_entry()
     CALL i1001_set_no_entry()
     IF g_amd.amd10='1' AND cl_null(g_amd.amd36) THEN
        NEXT FIELD amd36
     END IF
     IF g_amd.amd10='1' AND cl_null(g_amd.amd37) THEN
        NEXT FIELD amd37
     END IF
     IF g_amd.amd10='2' AND cl_null(g_amd.amd38) THEN
        NEXT FIELD amd38
     END IF
     IF g_amd.amd10='2' AND cl_null(g_amd.amd39) THEN
        NEXT FIELD amd39
     END IF
 
 
 
       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(amd40)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ"
               LET g_qryparam.default1 = g_amd.amd40
               CALL cl_create_qry() RETURNING g_amd.amd40
               DISPLAY BY NAME g_amd.amd40
               NEXT FIELD amd40
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
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW i1001_w RETURN END IF
    CLOSE WINDOW i1001_w
    LET g_amd_t.*=g_amd.*
    UPDATE amd_file SET amd10 = g_amd.amd10,             #No.FUN-4C0091
                        amd35 = g_amd.amd35,
                        amd36 = g_amd.amd36,
                        amd37 = g_amd.amd37,
                        amd38 = g_amd.amd38,
                        amd39 = g_amd.amd39 ,
                        amd40 = g_amd.amd40 ,
                        amd41 = g_amd.amd41 ,
                        amd42 = g_amd.amd42 ,
                        amd43 = g_amd.amd43
           WHERE amd01 = g_amd.amd01
             AND amd02=g_amd.amd02    #NO.3325
             AND amd021 = g_amd.amd021   #MOD-780205
    IF SQLCA.SQLCODE THEN              #No.FUN-4C0091
       CALL cl_err3("upd","amd_file",g_amd01_t,g_amd02_t,SQLCA.SQLCODE,"","update amd",1)   #No.FUN-660093
    END IF
END FUNCTION
 
FUNCTION i100_amd40(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
    SELECT occ02 INTO g_amd.amd41
      FROM occ_file
     WHERE occ01 = g_amd.amd40
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
 WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
       DISPLAY BY NAME g_amd.amd41                         #no:0015
END FUNCTION
 
 
#detail資料 010524 add by linda for 零稅率清單用
FUNCTION i100_2(p_type)   #FUN-6C0054 傳銷項明細或資產明細
DEFINE
    l_ac_t          LIKE type_file.num5,                # 未取消的ARRAY CNT #No.FUN-680074 SMALLINT
    l_n             LIKE type_file.num5,                # 檢查重複用        #No.FUN-680074 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                # 單身鎖住否        #No.FUN-680074 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                # 處理狀態          #No.FUN-680074 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #可新增否           #No.FUN-680074 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                 #可刪除否           #No.FUN-680074 VARCHAR(1)
DEFINE p_row,p_col  LIKE type_file.num5                                     #No.FUN-680074 SMALLINT
DEFINE p_type       LIKE type_file.chr1                 #0:銷項明細 1:資產明細
 
    IF s_shut(0) THEN RETURN END IF
    IF g_amd.amd01 IS NULL OR g_amd.amd02 IS NULL THEN
        RETURN
    END IF
  IF p_type = '0' THEN   #FUN-6C0054 add
    IF g_amd.amd171[1,1]='2' OR g_amd.amd172!='2' THEN    #no:7392
        RETURN
    END IF
  ELSE
    IF NOT (g_amd.amd171 MATCHES "2[125]" AND g_amd.amd17 = '2') THEN
       RETURN
    END IF
  END IF
    LET p_row = 6 LET p_col = 3
    OPEN WINDOW i100_w2 AT p_row,p_col
         WITH FORM "amd/42f/amdi100_2"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("amdi100_2")
 
    CALL i100_b_fill()
    IF g_amd.amd30='Y' THEN
       DISPLAY ARRAY g_amf TO s_amf.* ATTRIBUTE(COUNT=g_rec_b)
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
       END DISPLAY
       CLOSE WINDOW i100_w2
       RETURN
    END IF
    LET g_action_choice = ""
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT amf03,amf022,amf04,amf06,amf07 ", #No:8236
                       "  FROM amf_file   ",
                       " WHERE amf01 ='",g_amd.amd01,"'",
                       "   AND amf02 ='",g_amd.amd02,"'",        #No:8770   #MOD-890140 mark還原
                       "   AND amf021='",g_amd.amd021,"'",
                       "   AND amf03 = ? ",                      #No:8236
                       "   AND amf022 = ? FOR UPDATE "           #No:8236
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_amf WITHOUT DEFAULTS FROM s_amf.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'            # DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_amf_t.* = g_amf[l_ac].*  #BACKUP
                BEGIN WORK
                OPEN i100_bcl USING g_amf_t.amf03,g_amf_t.amf022 #No:8236
                IF STATUS THEN
                   CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i100_bcl INTO g_amf[l_ac].*
                IF STATUS THEN
                   CALL cl_err(g_amf_t.amf03,STATUS,1)
                   LET l_lock_sw = "Y"
                END IF
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_amf[l_ac].* TO NULL
            LET g_amf_t.* = g_amf[l_ac].*          # 新輸入資料
            LET g_amf[l_ac].amf07 = 0
             LET g_amf[l_ac].amf022 = ' '           #No.MOD-520116
            NEXT FIELD amf03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
               CLOSE i100_bcl
            END IF
            INSERT INTO amf_file(amf01,amf02,amf021,amf022,amf03,amf04,amf06,amf07,amflegal) #No:8236 #No.FUN-980004
                          VALUES(g_amd.amd01,g_amd.amd02,g_amd.amd021, g_amf[l_ac].amf022, #No:8236
                                 g_amf[l_ac].amf03, g_amf[l_ac].amf04,
                                 g_amf[l_ac].amf06,g_amf[l_ac].amf07,g_legal) #No.FUN-980004
            IF STATUS THEN
               CALL cl_err3("ins","amf_file",g_amd.amd01,g_amd.amd02,STATUS,"","",1)   #No.FUN-660093
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD amf03
            IF g_amf[l_ac].amf03 IS NULL THEN
               SELECT MAX(amf03)+1 INTO g_amf[l_ac].amf03
                 FROM amf_file
                WHERE amf01=g_amd.amd01
                  AND amf02=g_amd.amd02 #No:8770   #MOD-890140 mark還原
                  AND amf021=g_amd.amd021
               IF SQLCA.SQLCODE OR g_amf[l_ac].amf03 IS NULL THEN
                  LET g_amf[l_ac].amf03=1
               END IF
            END IF
 
        AFTER FIELD amf03                          # check 序號是否重複
          IF g_amf[l_ac].amf03 IS NOT NULL THEN
             IF g_amf[l_ac].amf03 IS NOT NULL AND
               (g_amf[l_ac].amf03 != g_amf_t.amf03 OR
                g_amf_t.amf03 IS NULL) THEN
                SELECT count(*) INTO l_n
                    FROM amf_file
                   WHERE amf01=g_amd.amd01
                     AND amf02=g_amd.amd02 #No:8770   #MOD-890140 mark還原
                     AND amf021=g_amd.amd021
                     AND amf03 = g_amf[l_ac].amf03
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_amf[l_ac].amf03 = g_amf_t.amf03
                    NEXT FIELD amf03
                END IF
             END IF
          END IF
 
        AFTER FIELD amf04                          # check 序號是否重複
            IF g_amf[l_ac].amf04 IS NOT NULL AND
               g_amf[l_ac].amf04 <>'MISC' THEN
               SELECT ima02 INTO g_amf[l_ac].amf06
                 FROM ima_file
                 WHERE ima01 = g_amf[l_ac].amf04
                DISPLAY g_amf[l_ac].amf06 TO s_amf[l_sl].amf06
            END IF
 
        BEFORE DELETE                            # 是否取消單身
            IF g_amf_t.amf03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM amf_file
                 WHERE amf01 =g_amd.amd01
                   AND amf02 =g_amd.amd02
                   AND amf021=g_amd.amd021
                   AND amf03 =g_amf_t.amf03
                   AND amf022=g_amf_t.amf022 #No:8236
                IF STATUS THEN
                   CALL cl_err3("del","amf_file",g_amd.amd01,g_amd.amd02,STATUS,"","",1)   #No.FUN-660093
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i100_bcl
                COMMIT WORK
            END IF
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_amf[l_ac].* = g_amf_t.*
              CLOSE i100_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_amf[l_ac].amf03,-263,1)
              LET g_amf[l_ac].* = g_amf_t.*
           ELSE
               UPDATE amf_file SET
                      amf022=g_amf[l_ac].amf022, #No:8236
                      amf03 =g_amf[l_ac].amf03,
                      amf04 =g_amf[l_ac].amf04,
                      amf06 =g_amf[l_ac].amf06,
                      amf07 =g_amf[l_ac].amf07
               WHERE amf01 =g_amd.amd01
                 AND amf02 =g_amd.amd02
                 AND amf021=g_amd.amd021
                 AND amf022=g_amf_t.amf022       #No:8236
                 AND amf03 =g_amf_t.amf03
              IF STATUS THEN
                 CALL cl_err3("upd","amf_file",g_amd01_t,g_amd02_t,STATUS,"","",1)   #No.FUN-660093
                 LET g_amf[l_ac].* = g_amf_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i100_bcl
              END IF
           END IF
 
        AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_amf[l_ac].* = g_amf_t.*
          #FUN-D30032--add--str--
             ELSE
                 CALL g_amf.deleteElement(l_ac) 
          #FUN-D30032--add--end--
             END IF
             CLOSE i100_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
           UPDATE amf_file SET
                  amf022=g_amf[l_ac].amf022, 
                  amf03 =g_amf[l_ac].amf03,
                  amf04 =g_amf[l_ac].amf04,
                  amf06 =g_amf[l_ac].amf06,
                  amf07 =g_amf[l_ac].amf07
           WHERE amf01 =g_amd.amd01
             AND amf02 =g_amd.amd02
             AND amf021=g_amd.amd021
             AND amf022=g_amf_t.amf022       #No:8236
             AND amf03 =g_amf_t.amf03
          IF STATUS THEN
             CALL cl_err3("upd","amf_file",g_amd01_t,g_amd02_t,STATUS,"","",1)   #No.FUN-660093
             LET g_amf[l_ac].* = g_amf_t.*
          ELSE
             MESSAGE 'UPDATE O.K'
             CLOSE i100_bcl
          END IF
          LET l_ac_t = l_ac
          CLOSE i100_bcl
          COMMIT WORK
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(amf04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.default1 = g_amf[l_ac].amf04
                  CALL cl_create_qry() RETURNING g_amf[l_ac].amf04
                   DISPLAY BY NAME g_amf[l_ac].amf04         #No.MOD-490344
                  NEXT FIELD amf04
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(amf03) AND l_ac > 1 THEN
                LET g_amf[l_ac].* = g_amf[l_ac-1].*
                NEXT FIELD amf03
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        END INPUT
 
    COMMIT WORK
    CLOSE i100_bcl
    CLOSE WINDOW i100_w2
END FUNCTION
 
FUNCTION i100_b_fill()                           # BODY FILL UP
DEFINE
    p_wc          LIKE type_file.chr1000   #No.FUN-680074 VARCHAR(200)
 
    LET g_sql = "SELECT amf03,amf022,amf04,amf06,amf07", #No:8236
                " FROM amf_file ",
                " WHERE amf01 = '",g_amd.amd01,"' ",
                "   AND amf02 = ",g_amd.amd02, #No:8770   #MOD-890140 mark還原
		"   AND amf021 = '",g_amd.amd021,"' ",
                " ORDER BY 1"
    PREPARE i100_prepare2 FROM g_sql
    DECLARE zy_curs CURSOR FOR i100_prepare2
    CALL g_amf.clear()
    LET g_cnt = 1
    FOREACH zy_curs INTO g_amf[g_cnt].*    # 單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('FOREACH:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('FOREACH:',STATUS,1) END IF
    CALL g_amf.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i100_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
   IF p_cmd = 'a' OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("amd28,amd172,amd031,amd03,amd22,amd08,amd07,amd05,   #FUN-770040
                              amd09",TRUE)             #No.FUN-4C0091
   END IF
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("amd07,amd08",TRUE)
   END IF
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680074 VARCHAR(1)
 
   IF p_cmd = 'u' AND (NOT g_before_input_done) THEN
      IF g_amd.amd172 = 'F' THEN  #FUN-A10039
         CALL cl_set_comp_entry("amd28,amd172,amd031,amd03,amd22,amd08,amd07,amd05,   #FUN-770040
                                 amd09",FALSE)            #No.FUN-4C0091
      END IF
   END IF
   IF g_ama12 = 'N' AND (NOT g_before_input_done) THEN
      IF g_amd.amd021 MATCHES '[235]' THEN
         CALL cl_set_comp_entry("amd07,amd08",FALSE)
      END IF
   END IF
END FUNCTION
 
FUNCTION i1001_set_entry()
   CALL cl_set_comp_entry("amd36,amd37,amd38,amd39",TRUE)
END FUNCTION
 
 
FUNCTION i1001_set_no_entry()
   IF g_amd.amd10='1' THEN
      CALL cl_set_comp_entry("amd38,amd39",FALSE)
      LET g_amd.amd38=''
      LET g_amd.amd39=''
      DISPLAY BY NAME g_amd.amd38,g_amd.amd39
   ELSE
      IF g_amd.amd10='2' THEN   #MOD-8C0220 add
         CALL cl_set_comp_entry("amd36,amd37",FALSE)
         LET g_amd.amd36=''
         LET g_amd.amd37=''
         DISPLAY BY NAME g_amd.amd36,g_amd.amd37
      ELSE
         CALL cl_set_comp_entry("amd36,amd37,amd38,amd39",FALSE)
         LET g_amd.amd36=''
         LET g_amd.amd37=''
         LET g_amd.amd38=''
         LET g_amd.amd39=''
         DISPLAY BY NAME g_amd.amd36,g_amd.amd37,g_amd.amd38,g_amd.amd39
      END IF
   END IF
END FUNCTION
 
FUNCTION i100_copy()
   DEFINE l_aaa LIKE type_file.chr1000                     #No.FUN-680074 VARCHAR(500)
   DEFINE l_str LIKE type_file.chr6                          #No.FUN-680074 VARCHAR(6) 
   DEFINE
       l_n                   LIKE type_file.num5,          #No.FUN-680074 SMALLINT
       l_newno,l_oldno       LIKE amd_file.amd01,
       l_amd02,l_old_amd02   LIKE amd_file.amd02,
       l_amd021,l_old_amd021 LIKE amd_file.amd021 
   DEFINE l_amd173           LIKE amd_file.amd173,  #TQC-710064
          l_amd174           LIKE amd_file.amd174   #TQC-710064
 
   IF s_shut(0) THEN RETURN END IF
   IF g_amd.amd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
   END IF
   
   
   CALL cl_set_comp_entry("amd01,amd021",TRUE)
   INPUT l_amd173,l_amd174 FROM amd173,amd174
       BEFORE INPUT
         LET l_newno = ' '
         LET l_amd021 = '4'
         DISPLAY l_newno TO amd01
         DISPLAY NULL TO amd02
         DISPLAY l_amd021 TO amd021
         LET g_amd.amd26 = ' '  #MOD-980174                                                                                         
         LET g_amd.amd27 = ' '  #MOD-980174                                                                                         
         DISPLAY BY NAME g_amd.amd26,g_amd.amd27 #MOD-980174  
 
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
 
   CALL cl_set_comp_entry("amd01,amd021",FALSE)
 
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_amd.amd01,g_amd.amd02,g_amd.amd021
       RETURN
   END IF
 
    LET l_str = l_amd173 using '&&&&',l_amd174 using'&&'
    CASE g_aza.aza41
      WHEN "1"
        LET l_newno = 'zzz-',l_str
      WHEN "2"
        LET l_newno = 'zzzz-',l_str
      WHEN "3"
        LET l_newno = 'zzzzz-',l_str
    END CASE
 
   SELECT max(amd02) INTO l_amd02 FROM amd_file
    WHERE amd01 = l_newno
    AND amd021= l_amd021
   IF cl_null(l_amd02) THEN LET l_amd02 = 0 END IF
   LET l_amd02 = l_amd02 + 1
 
 
   DROP TABLE x
   SELECT * FROM amd_file
       WHERE amd01 = g_amd.amd01 AND amd02 = g_amd.amd02 AND amd021 = g_amd.amd021 
       INTO TEMP x
   UPDATE x
       SET amd01=l_newno,    #資料鍵值
           amd02= l_amd02,
           amd021 = l_amd021,
           amd25 = g_plant,
           amd26 = g_amd.amd26, #MOD-980174                                                                                         
           amd27 = g_amd.amd27, #MOD-980174   
           amd30 = 'N',
           amd173 = l_amd173, #TQC-710064
           amd174 = l_amd174, #TQC-710064
           amduser=g_user,   #資料所有者
           amdgrup=g_grup,   #資料所有者所屬群
           amdmodu=NULL,     #資料修改日期
           amddate=g_today,  #資料建立日期
           amdacti='Y',      #有效資料
           amd175=NULL       #流水號     #MOD-A50166 add
 
   INSERT INTO amd_file
       SELECT * FROM x
 
   IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","amd_file",l_newno,"",SQLCA.sqlcode,"","",1)    #No.FUN-660093
   ELSE
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_amd.amd01
       LET l_old_amd02 = g_amd.amd02
       LET l_old_amd021 = g_amd.amd021
 
       SELECT amd_file.* INTO g_amd.* FROM amd_file
             WHERE amd01 = l_newno
               AND amd02 = l_amd02
               AND amd021= l_amd021
 
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","amd_file",l_newno,"",SQLCA.sqlcode,"","",1) #No.FUN-660093
          RETURN
       END IF
  
       CALL i100_u()
       #FUN-C30027---begin
       #SELECT amd_file.* INTO g_amd.* FROM amd_file
       #               WHERE amd01 = l_oldno
       #                 AND amd02 = l_old_amd02
       #                 AND amd021= l_old_amd021
       #IF SQLCA.sqlcode THEN
       #   CALL cl_err3("sel","amd_file",l_newno,"",SQLCA.sqlcode,"","",1)    #No.FUN-660093
       #END IF
       #FUN-C30027---end
   END IF
   CALL i100_show()
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14

