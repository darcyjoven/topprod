# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimi110.4gl
# Descriptions...: 料件分群碼基本資料維護作業-基本/庫存資料
# Date & Author..: 92/01/07 By MAY
# 1992/10/13 Lee: 增加再補貨量的維護(imz99)
# Modify.........: No:7747 03/08/11 By Mandy 在保稅料件型態欄位時, 應該判斷如果是保稅料才應該一定要輸入,否則可以不輸
# Modify.........: No:7703 03/08/25 By Mandy 應該增加 imz24 檢驗否 之欄位於主分群碼中
# Modify.........: No.MOD-480499 04/09/03 By Nicola 若非保稅料件為何一定要輸入保稅料件型態
# Modify.........: No.MOD-4A0063 04/10/05 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0001 04/11/03 By Smapmin 料件分群碼開窗
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
#                  2005/01/05 alex FUN-4C0104 修改 4js bug 定義超長
# Modify.........: No.FUN-510017 05/01/12 By Mandy 報表轉XML
# Modify.........: No.FUN-540025 04/12/29 By Carrier 雙單位修改
# Modify.........: No.FUN-580005 05/08/01 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.TQC-5B0059 05/11/08 By Sarah 列印時,表尾的(接下頁),(結束)超出頁寬
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610080 06/02/09 By Sarah 增加"重複性生產料件"欄位(imz911)
# Modify.........: No.TQC-620019 06/02/22 By Claire 移除mfg0007檢查段
# Modify.........: No.TQC-630220 06/04/04 By Echo 列印條件無法顯示,原因是p_zaa設定第一個欄位設定隱藏，導至列印條件跟著隱藏
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: NO.MOD-660149 06/06/30 BY yiting 參考單位時不做s_umfchk
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-680034 06/08/18 By douzh 增加"會計科目二"欄位(imz391)
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-710032 07/01/12 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.FUN-730061 07/03/28 By kim 行業別架構
# Modify.........: No.CHI-730034 07/04/10 By claire (1)材料類別(2)分群碼增加說明
# Modify.........: No.FUN-710060 07/08/06 By jamie 1.增加欄位imz72"是否需做供應商的管制
#                                                  2.在分群碼的建檔中新增欄位先給default"0" 
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-810099 07/12/28 By Cockroach  報表改為p_query實現
# Modify.........: No.FUN-810016 08/01/15 By ve007  補貨策略增加依訂單需求采購字段
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-830087 08/03/21 By ve007 刪除依訂單需求采購字段 
# Modify.........: No.FUN-810099 08/04/10 By destiny p_query 新增功能修改
# Modify.........: No.FUN-840042 08/04/14 By Wind 自定欄位功能修改
# Modify.........: No.MOD-840177 08/04/21 By Pengu imz150與imz152衛defalut值
# Modify.........: No.MOD-860067 08/06/05 By claire q_aag改用q_aag1
# Modify.........: No.TQC-870001 08/07/01 By claire q_aag1改用q_aag01
# Modify.........: No.MOD-870230 08/07/21 By claire q_aag01->q_aag02
# Modify.........: No.FUN-960141 09/07/24 By dongbg 增加代銷科目欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980063 09/11/03 By jan 新增'icd 資料'page
# Modify.........: No.FUN-9B0099 09/11/17 By douzh 给imz926默认值
# Modify.........: No.FUN-9C0109 09/12/24 By lutingting 只有當業態為零售業時才顯示代銷科目 
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A10004 10/02/28 By chenls 增加批序號頁簽下欄位的控管
# Modify.........: No:MOD-A50111 10/05/18 By Sarah INSERT INTO imz_file前,判斷imz601是否為NULL,若是則default為1
# Modify.........: No:MOD-A50112 10/05/18 By Sarah 複製時,若庫存單位有修改要同步更新到其他單位欄位
# Modify.........: No:MOD-A50099 10/05/20 By Sarah 在imz918或imz921欄位連續勾選、取消、再勾選時,imz919/920/922/923/924/925等欄位開關會異常
# Modify.........: No:MOD-A50171 10/05/25 By Sarah 移除mfg0007檢查段
# Modify.........: No:CHI-A60014 10/06/17 By Summer 增加批號管控否imzicd13
# Modify.........: No.FUN-A80102 10/08/20 By kim GP5.25號機管理
# Modify.........: No.FUN-A80150 10/09/02 By sabrina 新增號機管理頁面及其欄位
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1   料號開窗時篩選掉商戶料號  
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1   開窗BUG處理
# Modify.........: No:MOD-AB0209 10/11/23 By sabrina 不管imzicd04的值為何，imzicd08都要可以維護修改
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.MOD-B30155 11/03/12 By sabrina 若為icd業，則不顯示"批/序號管理"頁籤
# Modify.........: No:FUN-B40096 11/04/29 By zhangll 單身刪除異常報錯修正
# Modify.........: No:FUN-B30192 11/05/03 By shenyang 添加字段imzicd14,imzicd15,imzicd16
# Modify.........: No:FUN-B50106 11/05/20 By lixh1 取消從imz01帶imzicd16的預設值
# Modify.........: Mo:FUN-B30092 11/06/07 By Polly 新增量化單位和量化規格欄位
# Modify.........: No:CHI-B70014 11/07/11 By jason BIN群組不需為必KEY值
# Modify.........: No.FUN-B50096 11/08/17 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
#                                                  增加欄位imz159
# Modify.........: No:CHI-B80083 11/10/08 By johung imz17不使用，mark imz17
# Modify.........: No:TQC-B90236 11/10/09 By zhuhao 增加欄位 imz928，imz929,和一個ACTION 特性維護
# Modify.........: No:FUN-BB0083 11/12/14 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-BC0103 12/01/12 By jason 增加PIN COUNT等欄位for ICD
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30088 12/03/09 by jaosn imz159請給default值'3' imz925請給default值'1'
# Modify.........: No:MOD-C30095 12/03/09 By fengrui 刪除按鈕“建立料件單位換算”
# Modify.........: No:MOD-C30091 12/03/09 By bart 當ima918/ima921都沒有勾選時,ima925應該不需要輸入,請設為noentry
# Modify.........: No:MOD-C30206 12/03/10 By bart 將所有imaaicd13欄位mark掉
# Modify.........: No:FUN-C30023 12/03/13 By bart 主要倉庫後面顯示倉庫名稱
# Modify.........: No:FUN-C30235 12/03/20 By bart 單身備品比率及SPARE數要隱藏
# Modify.........: No:FUN-C30278 12/03/28 By bart 判斷imaicd05改為判斷imaicd04
# Modify.........: No:TQC-C40043 12/04/09 By fengrui 修改刪除后後續操作
# Modify.........: No:TQC-C40044 12/04/10 By fengrui 復制資料時,將原資料的imad_file資料復制,添加imz918控管
# Modify.........: No:TQC-C40038 12/04/10 By fengrui imz929欄位添加aim1145檢驗和控管
# Modify.........: No:TQC-C40078 12/04/12 By fengrui 修正料件狀態對良率、刻號/BIN、DATECODE否控管
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
# Modify.........: No.TQC-C40231 12/05/08 By fengrui 刪除后如果無上下筆資料，則清空變量
# Modify.........: No.TQC-C50127 12/05/15 By fengrui 修正FUN-B40096，問題已於TQC-C40043中處理
# Modify.........: No.FUN-C60046 12/06/18 By bart sma94控制是否顯示特性料件
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C80094 12/08/28 By minpp 在imz39/imz391下面新增imz163/imz1631,oaz92='Y'且大陆版时显示
# Modify.........: No.FUN-CB0052 12/11/19 By xianghui 發票倉庫控管改善
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 抓ime_file資料添加imeacti='Y'條件

DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
 
DEFINE g_imz               RECORD LIKE imz_file.*,
       g_imz_t             RECORD LIKE imz_file.*,
       g_imz_o             RECORD LIKE imz_file.*,
       g_imz01_t           LIKE imz_file.imz01,
       g_imz906            LIKE imz_file.imz906,   #FUN-540025
       g_imz907            LIKE imz_file.imz907,   #FUN-540025
       g_imz908            LIKE imz_file.imz908,   #FUN-540025
       g_gav02             LIKE gav_file.gav02,
       g_gav03             LIKE gav_file.gav03,  
       g_wc,g_sql          STRING,                 #TQC-630166
       g_flag              LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
#No.TQC-B90236 -------------------- add start ---------------------
DEFINE g_imzc               RECORD LIKE imzc_file.*,
       g_ima                RECORD LIKE ima_file.*,
       g_ima_t              RECORD LIKE ima_file.*
#No.TQC-B90236 -------------------- add end -----------------------
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_sma115            LIKE sma_file.sma115   #No.FUN-580005
DEFINE g_sma116            LIKE sma_file.sma116   #No.FUN-580005
DEFINE g_argv1     LIKE imz_file.imz01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE g_imz25_t           LIKE imz_file.imz25    #FUN-BB0083 add
 
MAIN
   DEFINE g_forupd_sql     STRING                 #SELECT ... FOR UPDATE SQL
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730061
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
   INITIALIZE g_imz.* TO NULL
   INITIALIZE g_imz_t.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM imz_file WHERE imz01 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aimi110_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 3 LET p_col = 2
 
   OPEN WINDOW aimi110_w AT p_row,p_col
     WITH FORM "aim/42f/aimi110"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i110_mu_ui()
   CALL cl_set_comp_visible("imzicd06,imzicd02,imzicd03",FALSE)  #FUN-B30192 
   CALL cl_set_comp_visible("imzicd12",FALSE)  #FUN-C30235
   #FUN-C80094--ADD--STR
   SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file WHERE oaz00='0'
   IF g_aza.aza26='2' AND g_oaz.oaz92='Y' THEN
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_visible("imz163,imz1631",TRUE)
      ELSE
         CALL cl_set_comp_visible("imz163",TRUE)
         CALL cl_set_comp_visible("imz1631",FALSE)
      END IF
   ELSE
      CALL cl_set_comp_visible("imz163,imz1631",FALSE)
   END IF
   #FUN-C80094--ADD--END
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL aimi110_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL aimi110_a()
            END IF
         OTHERWISE        
            CALL aimi110_q() 
      END CASE
   END IF

   LET g_action_choice=""
   CALL aimi110_menu()
 
   CLOSE WINDOW aimi110_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
 
END MAIN
 
FUNCTION aimi110_curs()
 
   CLEAR FORM
 
   INITIALIZE g_imz.* TO NULL    #FUN-640213 add
  IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" imz01='",g_argv1,"'"       #FUN-7C0050
  ELSE
   CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       imz01, imz02, imz08, imz25, imz03 ,imz72,                 #FUN-710060 add imz72
     # imzicd05,imzicd01,imzicd06,imzicd02,imzicd03,  #FUN-980063 #FUN-B30192
     # imzicd04,imzicd10,imzicd12,imzicd09,imzicd08,  #FUN-980063 #FUN-B30192
       imzicd05,imzicd01,imzicd16,                                #FUN-B30192
       imzicd04,imzicd10,imzicd12,imzicd14,imzicd15,imzicd09,imzicd08,   #FUN-B30192
     # imzicd13,imzicd79,                             #FUN-980063  #CHI-A60014 add imzicd13   #FUN-B50096 mark imzicd13
       imzicd17,imzicd79,          #FUN-B50096 mark imzicd13 #FUN-BC0103 add imzicd17
       imzicd18,imzicd19,imzicd20,imzicd21,   #FUN-BC0103                                     #	FUN-C80094 mark 
       imz105,imz14, imz147,imz107,imz109,imz903,imz24,imz911,imz022,imz251,   #FUN-610080 加imz911 FUN-B30092 加imz022、imz251
       imz07, imz70, imz37, imz38 ,imz99 ,imz27 ,imz28 ,imz71,imz909, #FUN-540025
      #imz35, imz36, imz23, imz17,   #CHI-B80083 mark
       imz35, imz36, imz23,          #CHI-B80083
       imz918,imz919,imz920,imz921,imz922,imz923,imz924,imz925,           #FUN-A10004 add
       imz928,imz929,                                                    #TQC-B90236  
       imz906,imz907,imz908,imz159,       #FUN-540025   #FUN-B50096 add imz159
       imz12, imz39, imz391,imz163,imz1631,           #FUN-680034 加imz391   #FUN-C80094 add-imz163,imz1631
       imz73,imz731,imz15, imz19, imz21, imz106,      #FUN-960141 加imz73,imz731
       imz09, imz10, imz11,
       imzuser, imzgrup, imzmodu, imzdate, imzacti,imzoriu,imzorig,         #TQC-C40155 add imzoriu,imzorig
       imzud01,imzud02,imzud03,imzud04,imzud05,
       imzud06,imzud07,imzud08,imzud09,imzud10,
       imzud11,imzud12,imzud13,imzud14,imzud15,
       imz156,imz157,imz158                           #FUN-A80150 add
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(imz01) #料件分群碼 #FUN-4B0001
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_imz"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imz01
              NEXT FIELD imz01
         WHEN INFIELD(imz09) #其他分群碼一
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz09
            LET g_qryparam.arg1 = "D"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz09
            CALL aimi110_azf01(g_imz.imz09,'D','d')    #CHI-730034
            NEXT FIELD imz09
         WHEN INFIELD(imz10) #其他分群碼二
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz10
            LET g_qryparam.arg1 = "E"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            CALL aimi110_azf01(g_imz.imz10,'E','d')    #CHI-730034
            DISPLAY g_qryparam.multiret TO imz10
            NEXT FIELD imz10
         WHEN INFIELD(imz11) #其他分群碼三
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz11
            LET g_qryparam.arg1 = "F"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz11
            CALL aimi110_azf01(g_imz.imz11,'F','d')    #CHI-730034
            NEXT FIELD imz11
         WHEN INFIELD(imz12) #其他分群碼四
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz12
            LET g_qryparam.arg1 = "G"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz12
            NEXT FIELD imz12
        #CHI-B80083 -- mark begin --
        #WHEN INFIELD(imz17)
        #   CALL cl_init_qry_var()
        #   LET g_qryparam.form = "q_gfe"
        #   LET g_qryparam.state = "c"
        #   LET g_qryparam.default1 = g_imz.imz17
        #   CALL cl_create_qry() RETURNING g_qryparam.multiret
        #   DISPLAY g_qryparam.multiret TO imz17
        #   NEXT FIELD imz17
        #CHI-B80083 -- mark end --
         WHEN INFIELD(imz907) #FUN-540025
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz907
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz907
            NEXT FIELD imz907
         WHEN INFIELD(imz908) #FUN-540025
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz908
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz908
            NEXT FIELD imz908

#FUN-A10004 --ADD BEGIN
         WHEN INFIELD(imz920)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz920
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz920
         WHEN INFIELD(imz923)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz923
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz923
#FUN-A10004 --ADD END
#No.TQC-B90236 ---- add start -------
         WHEN INFIELD(imz929)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_imz929"   #No.MOD-840254  #No.MOD-840294
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz929
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz929
#No.TQC-B90236 ---- add end ---------
         WHEN INFIELD(imz39) #會計科目
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_aag02"   #MOD-860067 modify  #TQC-870001 modify  #MOD-870230 modify
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz39
            LET g_qryparam.arg1 = g_aza.aza81   #TQC-870001 add
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz39
            NEXT FIELD imz39
         WHEN INFIELD(imz391) #會計科目二
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aag02"   #MOD-860067 modify  #TQC-870001 modify  #MOD-870230 modify
            LET g_qryparam.state = "c" 
            LET g_qryparam.default1 = g_imz.imz391
            LET g_qryparam.arg1 = g_aza.aza82   #TQC-870001 add
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz391
            NEXT FIELD imz391 
        #FUN-C80094--ADD--STR
         WHEN INFIELD(imz163) #發出商品會計科目
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_aag02"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz163
            LET g_qryparam.arg1 = g_aza.aza81
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz163
            NEXT FIELD imz163
         WHEN INFIELD(imz1631) #發出商品會計科目二
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aag02"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz1631
            LET g_qryparam.arg1 = g_aza.aza82   #TQC-870001 add
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz1631
            NEXT FIELD imz1631
         #FUN-C80094--ADD---END 
         WHEN INFIELD(imz73) #代銷科目
            CALL cl_init_qry_var()
            LET g_qryparam.form  = "q_aag02"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz73
            LET g_qryparam.arg1 = g_aza.aza81
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz73
            NEXT FIELD imz73
         WHEN INFIELD(imz731) #代銷科目二
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_aag02" 
            LET g_qryparam.state = "c" 
            LET g_qryparam.default1 = g_imz.imz731
            LET g_qryparam.arg1 = g_aza.aza82 
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz731
            NEXT FIELD imz731 
         WHEN INFIELD(imz23) #倉管員
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gen"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz23
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz23
            CALL aimi110_peo(g_imz.imz23,'d')
            NEXT FIELD imz23
         WHEN INFIELD (imz35) #倉庫別  ##saki..qry有錯誤,q_imd需重建
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_imd"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz35
             LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz35
            NEXT FIELD imz35
         WHEN INFIELD (imz36) #儲位別  ##saki..qry有錯誤,q_ime需重建
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ime"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz36
            LET g_qryparam.arg1 = g_imz.imz35
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz36
            NEXT FIELD imz36
         WHEN INFIELD(imz25) #庫存單位
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gfe"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz25
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz25
            NEXT FIELD imz25
         WHEN INFIELD(imz109)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_azf"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_imz.imz109
            LET g_qryparam.arg1 = 8
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imz109
            CALL aimi110_azf01(g_imz.imz109,'8','d')    #CHI-730034
            NEXT FIELD imz109
         WHEN INFIELD(imzicd01) #母體料號
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_imaicd"
              LET g_qryparam.state    = "c"
              #LET g_qryparam.where    = " imaicd05='1'"    #FUN-AA0059  #FUN-AB0025 remark #FUN-C30278
              LET g_qryparam.where    = " imaicd04='0' OR imaicd04='1'"   #FUN-C30278
          #   LET g_qryparam.where    = " imaicd05='1' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"  #FUN-AA0059  #FUN-AB0025
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imzicd01
              NEXT FIELD imzicd01
    #FUN-B30192--mark
    #     WHEN INFIELD(imzicd02) #外編母體 (預測料號)
    #          CALL cl_init_qry_var()
    #          LET g_qryparam.form     = "q_imaicd"
    #          LET g_qryparam.state    = "c"
    #          LET g_qryparam.where    = " imaicd05='2'"     
    #        #  LET g_qryparam.where  = " imaicd05='2' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"  #FUN-AA0059 #FUN-AB0025 
    #          CALL cl_create_qry() RETURNING g_qryparam.multiret
    #          DISPLAY g_qryparam.multiret TO imzicd02
    #          NEXT FIELD imzicd02
    #     WHEN INFIELD(imzicd03) #外編子體 (客戶下單料號)
    #          CALL cl_init_qry_var()
    #          LET g_qryparam.form     = "q_imaicd"
    #          LET g_qryparam.state    = "c"
    #          LET g_qryparam.where    = " imaicd05='4'"     
    #        #  LET g_qryparam.where    = " imaicd05='4' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"    #FUN-AA0059 #FUN-AB0025
    #          CALL cl_create_qry() RETURNING g_qryparam.multiret
    #          DISPLAY g_qryparam.multiret TO imzicd03
    #          NEXT FIELD imzicd03
    #     WHEN INFIELD(imzicd06) #內編子體 (Wafer料號)
    #          CALL cl_init_qry_var()
    #          LET g_qryparam.form     = "q_imaicd"
    #          LET g_qryparam.state    = "c"
    #          LET g_qryparam.where    = " imaicd04='1'"     
    #        #  LET g_qryparam.where  = " imaicd04='1' AND (ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)" #FUN-AA0059    #FUN-AB0025
    #          CALL cl_create_qry() RETURNING g_qryparam.multiret
    #          DISPLAY g_qryparam.multiret TO imzicd06
    #          NEXT FIELD imzicd06
    #FUN-B30192--mark
         WHEN INFIELD(imzicd10) #作業群組
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_icd11" 
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = 'U'      
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imzicd10
              NEXT FIELD imzicd10
   #FUN-B30192--add--begin
         WHEN INFIELD(imzicd16)
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_imaicd"
              LET g_qryparam.state    = "c"
              #LET g_qryparam.where    = " imaicd04='4'"   #FUN-C30278
              LET g_qryparam.where    = " imaicd04='1'"    #FUN-C30278
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imzicd16
              NEXT FIELD imzicd16
   #FUN-B30192--add--end

  #FUN-B30092 --begin--
         WHEN INFIELD(imz251)
              CALL cl_init_qry_var()
              LET g_qryparam.form   = "q_gfo"     
              LET g_qryparam.state  = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO imz251
              NEXT FIELD imz251
  #FUN-B30092 --end--

         WHEN INFIELD(imzicd79)                                               
              CALL cl_init_qry_var()                                         
              LET g_qryparam.form = "q_icc"                                  
              LET g_qryparam.state = "c"                                     
              CALL cl_create_qry() RETURNING g_qryparam.multiret             
              DISPLAY g_qryparam.multiret TO imzicd79                          
              NEXT FIELD imzicd79
         #FUN-A80150---add---start---
          WHEN INFIELD(imz157)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_gei2"  
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_imz.imz157
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO imz157
         #FUN-A80150---add---end---
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
  END IF  #FUN-7C0050
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imzuser', 'imzgrup')
 
   LET g_sql="SELECT imz01 FROM imz_file ", # 組合出 SQL 指令
       " WHERE ",g_wc CLIPPED, " ORDER BY imz01"
   PREPARE aimi110_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE aimi110_curs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR aimi110_prepare
   LET g_sql=
       "SELECT COUNT(*) FROM imz_file WHERE ",g_wc CLIPPED
   PREPARE aimi110_precount FROM g_sql
   DECLARE aimi110_count CURSOR FOR aimi110_precount
END FUNCTION
 
FUNCTION aimi110_menu()
   DEFINE 
        l_priv1         LIKE zy_file.zy03,       # 使用者執行權限
        l_priv2         LIKE zy_file.zy04,       # 使用者資料權限
        l_priv3         LIKE zy_file.zy05        # 使用部門資料權限
   DEFINE  l_cmd        LIKE type_file.chr1000   #NO.FUN-810099
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL aimi110_a()
           END IF
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL aimi110_q()
           END IF
        ON ACTION next
           CALL aimi110_fetch('N')
        ON ACTION previous
           CALL aimi110_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
              CALL aimi110_u()
           END IF
        ON ACTION invalid
           LET g_action_choice="invalid"
           IF cl_chk_act_auth() THEN
              CALL aimi110_x()
              CALL cl_set_field_pic("","","","","",g_imz.imzacti)
           END IF
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
              CALL aimi110_r()
           END IF
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
              CALL aimi110_copy()
           END IF
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              CALL aimi110_out()
           END IF
        ON ACTION sale_purchase
           LET g_action_choice="sale_purchase"
           IF cl_chk_act_auth() AND g_imz.imz01 IS NOT NULL THEN
              LET l_priv1=g_priv1 LET l_priv2=g_priv2 LET l_priv3=g_priv3
              LET g_msg="aimi111 '",g_imz.imz01,"'"
              CALL cl_cmdrun(g_msg)
              LET g_priv1=l_priv1 LET g_priv2=l_priv2 LET g_priv3=l_priv3
           END IF
        ON ACTION production
           LET g_action_choice="production"
           IF cl_chk_act_auth() AND g_imz.imz01 IS NOT NULL THEN
              LET l_priv1=g_priv1 LET l_priv2=g_priv2 LET l_priv3=g_priv3
              LET g_msg="aimi112 '",g_imz.imz01,"'"
              CALL cl_cmdrun(g_msg)
              LET g_priv1=l_priv1 LET g_priv2=l_priv2 LET g_priv3=l_priv3
           END IF
        ON ACTION cost
           LET g_action_choice="cost"
           IF cl_chk_act_auth() AND g_imz.imz01 IS NOT NULL THEN
              LET l_priv1=g_priv1 LET l_priv2=g_priv2 LET l_priv3=g_priv3
              LET g_msg="aimi113 '",g_imz.imz01,"'"
              CALL cl_cmdrun(g_msg)
              LET g_priv1=l_priv1 LET g_priv2=l_priv2 LET g_priv3=l_priv3
           END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL i110_mu_ui()   #TQC-710032
           CALL cl_set_field_pic("","","","","",g_imz.imzacti)
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL aimi110_fetch('/')
        ON ACTION first
           CALL aimi110_fetch('F')
        ON ACTION last
           CALL aimi110_fetch('L')
        ON ACTION controlg
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
#No.TQC-B90236 ---------------------- add start -------------------
        ON ACTION feature_maintain
           IF cl_chk_act_auth() AND g_imz.imz01 IS NOT NULL THEN
              CALL aimi110_add(g_imz.imz01,g_imz.imz918,g_imz.imz928,g_imz.imz929)
           END IF
#No.TQC-B90236 ---------------------- add end ---------------------
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
           LET g_action_choice = "exit"
           CONTINUE MENU
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_imz.imz01 IS NOT NULL THEN
                 LET g_doc.column1 = "imz01"
                 LET g_doc.value1 = g_imz.imz01
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
    CLOSE aimi110_curs
END FUNCTION
 
 
FUNCTION aimi110_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_imz.* LIKE imz_file.*
    LET g_imz01_t = NULL
    LET g_imz_t.*=g_imz.*
    LET g_imz.imz07 = 'A'
    LET g_imz.imz24 = 'N' #No:7703
    LET g_imz.imz14 = 'N'
    LET g_imz.imz15 = 'N'
    LET g_imz.imz27 = 0
    LET g_imz.imz28 = 0
    LET g_imz.imz31_fac = 1
    LET g_imz.imz37 = '0'
    LET g_imz.imz38 = 0
    LET g_imz.imz99 = 0
    LET g_imz.imz44_fac = 1
    LET g_imz.imz45 = 1
    LET g_imz.imz46 = 0
    LET g_imz.imz47 = 0
    LET g_imz.imz48 = 0
    LET g_imz.imz49 = 0
    LET g_imz.imz491 = 0
    LET g_imz.imz50 = 0
    LET g_imz.imz51 = 1
    LET g_imz.imz52 = 1
    LET g_imz.imz55_fac = 1
    LET g_imz.imz56 = 1
    LET g_imz.imz561 = 0  #最少生產數量
    LET g_imz.imz562 = 0  #生產時損耗率
    LET g_imz.imz59 = 0
    LET g_imz.imz60 = 0
    LET g_imz.imz61 = 0
    LET g_imz.imz62 = 0
    LET g_imz.imz63_fac = 1
    LET g_imz.imz64 = 1
    LET g_imz.imz641 = 1   #最少發料數量
    LET g_imz.imz65 = 0
    LET g_imz.imz66 = 0
    LET g_imz.imz68 = 0
    LET g_imz.imz69 = 0
    LET g_imz.imz70 = 'N'
    LET g_imz.imz107= 'N'
    LET g_imz.imz71 = 0
    LET g_imz.imz86_fac = 1
    LET g_imz.imz871 = 0
    LET g_imz.imz873 = 0
    LET g_imz.imz105 = 'N'
    LET g_imz.imz147 = 'N'
    LET g_imz.imz148 = 0
    LET g_imz.imz903 = 'N'
    LET g_imz.imz911 = 'N'   #FUN-610080
#FUN-A10004 ---ADD BEGIN
    LET g_imz.imz918= 'N'
    LET g_imz.imz919= 'N'
    LET g_imz.imz921= 'N'
    LET g_imz.imz922= 'N'
    LET g_imz.imz924= 'N'
    LET g_imz.imz925= '1'   #MOD-C30088
#FUN-A10004 ---ADD END
    LET g_imz.imz928= 'N'    #TQC-B90236 add
    LET g_imz.imz156= 'N'    #FUN-A80150 add
    LET g_imz.imz157= ' '    #FUN-A80150 add
    LET g_imz.imz158= 'N'    #FUN-A80150 add
    LET g_imz.imz159= '3'    #MOD-C30088
    LET g_imz.imz72 = '0'    #FUN-710060 add
    LET g_imz.imzicd04='9'
    #LET g_imz.imzicd05='6'  #FUN-C30278
    LET g_imz.imzicd05='5'
    LET g_imz.imzicd08='N'
    LET g_imz.imzicd09='N'
#   LET g_imz.imzicd13='N' #CHI-A60014 add   #FUN-B50096
    LET g_imz.imzicd12=0
#FUN-B30192--add--begin
    LET g_imz.imzicd14='0'
#FUN-B30192--add--end
    LET g_imz.imzicd17='3'   #FUN-BC0103
    LET g_imz.imz022= 0      #FUN-B30092 add
   
    IF g_sma.sma115 = 'Y' THEN
       IF g_sma.sma122 MATCHES '[13]' THEN
          LET g_imz.imz906 = '2'
       ELSE
          LET g_imz.imz906 = '3'
       END IF
    ELSE
       LET g_imz.imz906 = '1'
    END IF
#NO.FUN-B30092  ------------------------add start------------------------
    IF cl_null(g_imz.imz022) THEN
       LET g_imz.imz022 = 0
    END IF
#NO.FUN-B30092 --------------------------add end------------------------
    LET g_imz.imz909 = 0
    LET g_imz.imz926 = 'N'       #FUN-9B0099
    LET g_wc = NULL
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imz.imzacti ='Y'                   #有效的資料
        LET g_imz.imzuser = g_user
        LET g_imz.imzoriu = g_user #FUN-980030
        LET g_imz.imzorig = g_grup #FUN-980030
        LET g_imz.imzgrup = g_grup               #使用者所屬群
        LET g_imz.imzdate = g_today
        LET g_imz.imz100  ='N'
        LET g_imz.imz101  ='1'
        LET g_imz.imz102  ='1'
        LET g_imz.imz103  ='0'
        LET g_imz.imz108  ='N'
        LET g_imz.imz110  ='1'
        LET g_imz.imz130  ='1'
 
        CALL aimi110_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_imz.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_imz.imz01 IS NULL OR g_imz.imz01 = ' '  # KEY 不可空白
           THEN CONTINUE WHILE
        END IF
{&}     IF g_imz.imz35 IS NULL THEN LET g_imz.imz35 = ' ' END IF
        IF g_imz.imz36 IS NULL THEN LET g_imz.imz36 = ' ' END IF
        LET g_imz.imz86=g_imz.imz25
       #IF cl_null(g_imz.imz17) THEN LET g_imz.imz17=g_imz.imz25 END IF   #CHI-B80083 mark
        IF cl_null(g_imz.imz31) THEN
           LET g_imz.imz31=g_imz.imz25
           LET g_imz.imz31_fac=1
        END IF
        IF cl_null(g_imz.imz44) THEN
           LET g_imz.imz44=g_imz.imz25
           LET g_imz.imz44_fac=1
        END IF
        IF cl_null(g_imz.imz55) THEN
           LET g_imz.imz55=g_imz.imz25
           LET g_imz.imz55_fac=1
        END IF
        IF cl_null(g_imz.imz63) THEN
           LET g_imz.imz63=g_imz.imz25
           LET g_imz.imz63_fac=1
        END IF
        IF cl_null(g_imz.imz150) THEN LET g_imz.imz150 = '0' END IF
        IF cl_null(g_imz.imz152) THEN LET g_imz.imz152 = '0' END IF
        IF cl_null(g_imz.imz601) THEN LET g_imz.imz601 = 1 END IF   #MOD-A50111 add
        IF cl_null(g_imz.imz156) THEN LET g_imz.imz156 ='N' END IF  #FUN-A80102
        IF cl_null(g_imz.imz157) THEN LET g_imz.imz157 =' ' END IF  #FUN-A80102
        IF cl_null(g_imz.imz158) THEN LET g_imz.imz158 ='N' END IF  #FUN-A80102
        IF cl_null(g_imz.imz022) THEN LET g_imz.imz022 = '0' END IF  #FUN-B30192
       #FUN-B50106 ------------Begin-----------------
        IF cl_null(g_imz.imzicd14) THEN LET g_imz.imzicd14 = 0 END IF
        IF cl_null(g_imz.imzicd15) THEN LET g_imz.imzicd15 = 0 END IF  
       #FUN-B50106 ------------End-------------------   
        INSERT INTO imz_file VALUES(g_imz.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        ELSE
            LET g_imz_t.* = g_imz.*                # 保存上筆資料
            SELECT imz01 INTO g_imz.imz01 FROM imz_file
                WHERE imz01 = g_imz.imz01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION aimi110_i(p_cmd)
   DEFINE   p_cmd      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_direct   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            l_gen02    LIKE gen_file.gen02,
            l_sw       LIKE type_file.chr1,    #FUN-540025  #No.FUN-690026 VARCHAR(1)
            l_factor   LIKE img_file.img21,    #FUN-540025
            l_n        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
            l_imd02    LIKE imd_file.imd02     #FUN-C30023
   DEFINE   li_result  LIKE type_file.num5     #FUN-730061
   DEFINE   l_chose    LIKE type_file.num5     #TQC-B90236
   DEFINE l_ima918       LIKE ima_file.ima918  #TQC-C40038
   DEFINE   l_imd10     LIKE imd_file.imd10   #FUN-CB0052
   DISPLAY BY NAME g_imz.imzuser,g_imz.imzgrup,g_imz.imzdate,g_imz.imzacti,
           #       g_imz.imzicd04,g_imz.imzicd05,g_imz.imzicd08,g_imz.imzicd09,g_imz.imzicd13  #FUN-980063  #CHI-A60014 add imzicd13 FUN-B50096
                   g_imz.imzicd04,g_imz.imzicd05,g_imz.imzicd08,g_imz.imzicd09                 #FUN-B50096    
   DISPLAY BY NAME g_imz.imz906,g_imz.imz907,g_imz.imz908,g_imz.imz159,g_imz.imz909            #FUN-540025  #FUN-B50096 add imz159
   DISPLAY BY NAME g_imz.imzicd17   #FUN-BC0103
   INPUT BY NAME g_imz.imzoriu,g_imz.imzorig,g_imz.imz01,g_imz.imz02,g_imz.imz08,g_imz.imz25,g_imz.imz03,g_imz.imz72,g_imz.imz04,     #FUN-710060 add imz72
       #         g_imz.imzicd05,g_imz.imzicd01,g_imz.imzicd06,  #FUN-980063  #FUN-B30192
       #         g_imz.imzicd02,g_imz.imzicd03,g_imz.imzicd04,  #FUN-980063  #FUN-B30192
       #         g_imz.imzicd10,g_imz.imzicd12,g_imz.imzicd09,  #FUN-980063  #FUN-B30192
                 g_imz.imzicd05,g_imz.imzicd01,g_imz.imzicd16,g_imz.imzicd04,               #FUN-B30192
                 g_imz.imzicd10,g_imz.imzicd12,g_imz.imzicd14,g_imz.imzicd15,g_imz.imzicd09, #FUN-B30192
       #         g_imz.imzicd08,g_imz.imzicd13,g_imz.imzicd79,  #FUN-980063 #CHI-A60014 add imzicd13  #FUN-B50096
                 g_imz.imzicd08,g_imz.imzicd17,g_imz.imzicd79,                 #FUN-B50096 mark imzicd13 #FUN-BC0103 add imzicd17
                 g_imz.imzicd18,g_imz.imzicd19,g_imz.imzicd20,g_imz.imzicd21,   #FUN-BC0103      
                 g_imz.imz105,g_imz.imz14,g_imz.imz147,g_imz.imz107,g_imz.imz109,
                 g_imz.imz903,g_imz.imz24,g_imz.imz911,g_imz.imz07,g_imz.imz70,g_imz.imz37,g_imz.imz38,   #FUN-610080 加imz911
                 g_imz.imz99,g_imz.imz27,g_imz.imz28,g_imz.imz71,g_imz.imz909, #FUN-540025
                 g_imz.imz35,
                #g_imz.imz36,g_imz.imz23,g_imz.imz17,   #CHI-B80083 mark
                 g_imz.imz36,g_imz.imz23,               #CHI-B80083 mark
                 g_imz.imz918,g_imz.imz919,g_imz.imz920,g_imz.imz921,           #FUN-A10004 --ADD
                 g_imz.imz922,g_imz.imz923,g_imz.imz924,g_imz.imz925,           #FUN-A10004 --ADD
                 g_imz.imz928,g_imz.imz929,                                     #TQC-B90236 --ADD
                 g_imz.imz906,g_imz.imz907,g_imz.imz908,g_imz.imz159,           #FUN-540025   #FUN-B50096 add imz159
                 g_imz.imz12,g_imz.imz39,g_imz.imz391,g_imz.imz163,g_imz.imz1631,  #FUN-680034 加imz391  #FUN-C80094 add--imz163,imz1631
                 g_imz.imz73,g_imz.imz731,g_imz.imz15,    #FUN-960141 加imz73,imz731
                 g_imz.imz19,g_imz.imz21,g_imz.imz106,g_imz.imz09,
                 g_imz.imz10,g_imz.imz11,g_imz.imzuser,g_imz.imzgrup,
                 g_imz.imzmodu,g_imz.imzdate,g_imz.imzacti,
                 g_imz.imzud01,g_imz.imzud02,g_imz.imzud03,g_imz.imzud04,
                 g_imz.imzud05,g_imz.imzud06,g_imz.imzud07,g_imz.imzud08,
                 g_imz.imzud09,g_imz.imzud10,g_imz.imzud11,g_imz.imzud12,
                 g_imz.imzud13,g_imz.imzud14,g_imz.imzud15, 
                 g_imz.imz156,g_imz.imz157,g_imz.imz158,                    #FUN-A80150 add
                 g_imz.imz022,g_imz.imz251                                  #FUN-B30092 add
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         CALL i110_set_no_required()  #FUN-540025
         CALL i110_set_required()     #FUN-540025
         LET g_before_input_done = TRUE
         #FUN-BB0083---add---str
         IF p_cmd = 'u' THEN
            LET g_imz25_t = g_imz.imz25
         END IF
         IF p_cmd = 'a' THEN
            LET g_imz25_t = NULL
         END IF 
         #FUN-BB0083---add---end
      AFTER FIELD imz01
         IF NOT cl_null(g_imz.imz01) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_imz.imz01 != g_imz01_t) THEN
               SELECT count(*) INTO l_n FROM imz_file
                WHERE imz01 = g_imz.imz01
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_imz.imz01,-239,0)
                  LET g_imz.imz01 = g_imz01_t
                  DISPLAY BY NAME g_imz.imz01
                  NEXT FIELD imz01
               END IF
            END IF
         END IF
 
      AFTER FIELD imz02
         LET g_imz_o.imz02 = g_imz.imz02
 
      AFTER FIELD imz08  #來源碼
         IF g_imz.imz08 NOT MATCHES "[CTDAMPXKUVRZS]"
            AND g_imz.imz08 IS NOT NULL
            THEN CALL cl_err(g_imz.imz08,'mfg1001',0)
               LET g_imz.imz08 = g_imz_o.imz08
               DISPLAY BY NAME g_imz.imz08
               NEXT FIELD imz08
         END IF
         LET g_imz_o.imz08 = g_imz.imz08
 
      AFTER FIELD imz03
         LET l_direct = 'D'

#NO.FUN-B30092  ------------------------add start------------------------
       AFTER FIELD imz022  #量化單位
          IF NOT cl_null(g_imz.imz022) THEN
             IF g_imz.imz022 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD CURRENT
             END IF
          END IF
          IF cl_null(g_imz.imz022) THEN
             LET g_imz.imz022 = 0
          END IF

       AFTER FIELD imz251
          IF NOT cl_null(g_imz.imz251) THEN
             CALL i110_imz251_chk()
             IF NOT cl_null(g_errno) THEN CALL cl_err('',g_errno,0) NEXT FIELD CURRENT END IF END IF
#NO.FUN-B30092 --------------------------add end------------------------
 
        AFTER FIELD imz24  #檢驗否
            LET l_direct = 'U'
 
      AFTER FIELD imz14  #工程料件
         LET g_imz_o.imz14 = g_imz.imz14
         LET l_direct = 'U'
 
       BEFORE FIELD imz15    #No.MOD-480499
         CALL i110_set_entry(p_cmd)
 
       AFTER FIELD imz15  #保稅料件    #No.MOD-480499
         CALL i110_set_no_entry(p_cmd)
 
#@@@@@可使為消耗性料件 1.多倉儲管理(sma12 = 'y')
#@@@@@                 2.使用製程(sma54 = 'y')
      AFTER FIELD imz70  #消耗料件
         IF (g_imz_o.imz70 IS NULL) OR (g_imz_t.imz70 IS NULL)
            OR (g_imz.imz70 != g_imz_o.imz70) THEN
            IF g_imz.imz70 NOT MATCHES "[YN]"
               AND g_imz.imz70 IS NOT NULL THEN
               CALL cl_err(g_imz.imz70,'mfg1002',0)
               LET g_imz.imz70 = g_imz_o.imz70
               DISPLAY BY NAME g_imz.imz70
               NEXT FIELD imz70
            END IF
           #str MOD-A50171 mark
           #IF (g_imz.imz70 matches'[Yy]'
           #   AND (g_sma.sma12 matches'[Nn]'
           #   OR g_sma.sma54 matches'[Nn]')) THEN
           #   CALL cl_err(g_imz.imz70,'mfg0007',0)
           #   LET g_imz.imz70 = g_imz_o.imz70
           #   DISPLAY BY NAME g_imz.imz70
           #   NEXT FIELD imz70
           #END IF
           #end MOD-A50171 mark
         END IF
         LET g_imz_o.imz70 = g_imz.imz70
 
      AFTER FIELD imz105    #NO:6843
 
      AFTER FIELD imz106  #保稅料件型態
         IF g_imz.imz15 = 'Y' AND (NOT cl_null(g_imz.imz15)) THEN
            IF cl_null(g_imz.imz106) OR g_imz.imz106 NOT MATCHES '[123]' THEN
               NEXT FIELD imz106
            END IF
         ELSE
            IF NOT cl_null(g_imz.imz106) THEN
               IF g_imz.imz106 NOT MATCHES '[123]' THEN
                  NEXT FIELD imz106
               END IF
            END IF
         END IF
         LET g_imz_o.imz106 = g_imz.imz106
 
      AFTER FIELD imz107  #插件位置
 
       AFTER FIELD imz147  #插件位置與QPA是否要勾稽
 
       AFTER FIELD imz109
         IF g_imz.imz109 IS NOT NULL AND g_imz.imz109 != ' ' THEN
            IF (g_imz_o.imz109 IS NULL) OR
               (g_imz.imz109 != g_imz_o.imz109) THEN
               SELECT azf01 FROM azf_file
                WHERE azf01=g_imz.imz109 AND azf02='8'
                  AND azfacti='Y'
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","imz_file",g_imz.imz109,"","mfg1306","","",1)  #No.FUN-660156
                  LET g_imz.imz109 = g_imz_o.imz109
                  DISPLAY BY NAME g_imz.imz109
                  NEXT FIELD imz109
               END IF
               CALL aimi110_azf01(g_imz.imz109,'8','a')    #CHI-730034
             END IF
          END IF
          LET g_imz_o.imz109 = g_imz.imz109
 
      AFTER FIELD imz09                     #其他分群碼一
         IF g_imz.imz09 IS NOT NULL AND g_imz.imz09 != ' ' THEN
            IF (g_imz_o.imz09 IS NULL) OR (g_imz.imz09 != g_imz_o.imz09) THEN
               SELECT azf01 FROM azf_file
                WHERE azf01=g_imz.imz09 AND azf02='D' #6818
                  AND azfacti='Y'
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","azf_file",g_imz.imz09,"","mfg1306","","",1)  #No.FUN-660156
                  LET g_imz.imz09 = g_imz_o.imz09
                  DISPLAY BY NAME g_imz.imz09
                  NEXT FIELD imz09
               END IF
               CALL aimi110_azf01(g_imz.imz09,'D','a')    #CHI-730034
            END IF
         END IF
         LET g_imz_o.imz09 = g_imz.imz09
 
      AFTER FIELD imz10                     #其他分群碼二
         IF g_imz.imz10 IS NOT NULL AND g_imz.imz10 != ' ' THEN
            IF (g_imz_o.imz10 IS NULL) OR (g_imz.imz10 != g_imz_o.imz10) THEN
               SELECT azf01 FROM azf_file
                WHERE azf01=g_imz.imz10 AND azf02='E' #6818
                  AND azfacti='Y'
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","azf_file",g_imz.imz10,"","mfg1306","","",1)  #No.FUN-660156
                  LET g_imz.imz10 = g_imz_o.imz10
                  DISPLAY BY NAME g_imz.imz10
                  NEXT FIELD imz10
               END IF
               CALL aimi110_azf01(g_imz.imz10,'E','a')    #CHI-730034
            END IF
         END IF
         LET g_imz_o.imz10 = g_imz.imz10
 
      AFTER FIELD imz11                     #其他分群碼三
         IF g_imz.imz11 IS NOT NULL AND g_imz.imz11 != ' ' THEN
            IF (g_imz_o.imz11 IS NULL ) OR (g_imz_o.imz11 != g_imz.imz11) THEN
               SELECT azf01 FROM azf_file
                WHERE azf01=g_imz.imz11 AND azf02='F' #6818
                  AND azfacti='Y'
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","azf_file",g_imz.imz11,"","mfg1306","","",1)  #No.FUN-660156
                  LET g_imz.imz11 = g_imz_o.imz11
                  DISPLAY BY NAME g_imz.imz11
                  NEXT FIELD imz11
               END IF
               CALL aimi110_azf01(g_imz.imz11,'F','a')    #CHI-730034
            END IF
         END IF
         LET g_imz_o.imz11 = g_imz.imz11
 
      AFTER FIELD imz12                     #其他分群碼四
         IF g_imz.imz12 IS NOT NULL AND g_imz.imz12 != ' ' THEN
            IF (g_imz_o.imz12 IS NULL) OR (g_imz_o.imz12 != g_imz.imz12) THEN
               SELECT azf01 FROM azf_file
                WHERE azf01=g_imz.imz12 AND azf02='G' #6818
                  AND azfacti='Y'
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","azf_file",g_imz.imz12,"","mfg1306","","",1)  #No.FUN-660156
                  LET g_imz.imz12 = g_imz_o.imz12
                  DISPLAY BY NAME g_imz.imz12
                  NEXT FIELD imz12
               END IF
            END IF
         END IF
         LET g_imz_o.imz12 = g_imz.imz12
 
      AFTER FIELD imz07
         IF g_imz.imz07 NOT MATCHES'[ABC]' AND g_imz.imz07 IS NOT NULL THEN
            CALL cl_err(g_imz.imz07,'mfg0009',0)
            LET g_imz.imz07 = g_imz_o.imz07
            DISPLAY BY NAME g_imz.imz07
            NEXT FIELD imz07
         END IF
         LET g_imz_o.imz07 = g_imz.imz07
 
      BEFORE FIELD imz37
         CALL i110_set_entry(p_cmd)
 
      AFTER FIELD imz37  #補貨策略碼
         IF g_imz.imz37 NOT MATCHES "[012345]"  AND           #No.FUN-810016 --mark--
            (g_imz.imz37 IS NOT NULL OR g_imz.imz37 !=' ') THEN
            CALL cl_err(g_imz.imz37,'mfg1003',0)
            LET g_imz.imz37 = g_imz_o.imz37
            DISPLAY BY NAME g_imz.imz37
            NEXT FIELD imz37
         END IF
         LET g_imz_o.imz37 = g_imz.imz37
         CALL i110_set_no_entry(p_cmd)
 
      AFTER FIELD imz38
         #FUN-BB0083---add---str
         IF NOT i100_imz38_check() THEN 
            NEXT FIELD imz38
         END IF
         #FUN-BB0083---add---end
         #FUN-BB0083---mark---str
         #IF NOT cl_null(g_imz.imz38) AND g_imz.imz38 < 0 THEN
         #   CALL cl_err(g_imz.imz38,'mfg0013',0)
         #   LET g_imz.imz38 = g_imz_o.imz38
         #   DISPLAY BY NAME g_imz.imz38
         #   NEXT FIELD imz38
         #END IF
         #LET g_imz_o.imz38 = g_imz.imz38
         #FUN-BB0083---mark---end
 
      AFTER FIELD imz99	#再補貨量
         #FUN-BB0083---add---str
         LET g_imz.imz99 = s_digqty(g_imz.imz99,g_imz.imz44)
         DISPLAY BY NAME g_imz.imz99
         #FUN-BB0083---add---end
         IF NOT cl_null(g_imz.imz99) AND g_imz.imz99 < 0 THEN
            CALL cl_err(g_imz.imz99,'mfg0013',0)
            LET g_imz.imz99 = g_imz_o.imz99
            DISPLAY BY NAME g_imz.imz99
            NEXT FIELD imz99
         END IF
         LET g_imz_o.imz99 = g_imz.imz99
 
     #CHI-B80083 -- mark begin --
     #AFTER FIELD imz17                     #銷售統計單位
     #   IF g_imz.imz17 IS NOT NULL AND g_imz.imz17 != ' ' THEN
     #      IF (g_imz_o.imz17 IS NULL) OR (g_imz_o.imz17 != g_imz.imz17) THEN
     #         SELECT gfe01 FROM gfe_file
     #          WHERE gfe01=g_imz.imz17
     #            AND gfeacti IN ('Y','y')
     #         IF SQLCA.sqlcode  THEN
     #            CALL cl_err3("sel","gfe_file",g_imz.imz17,"","mfg0019","","",1)  #No.FUN-660156
     #            LET g_imz.imz17 = g_imz_o.imz17
     #            DISPLAY BY NAME g_imz.imz17
     #            NEXT FIELD imz17
     #         END IF
     #      END IF
     #   END IF
     #   LET g_imz_o.imz17 = g_imz.imz17
     #CHI-B80083 -- mark end -- 

      BEFORE FIELD imz906
         CALL i110_set_entry(p_cmd)
 
      AFTER FIELD imz906
         IF NOT cl_null(g_imz.imz906) THEN
            IF g_sma.sma115 = 'Y' THEN
               IF g_imz.imz906 IS NULL THEN
                  CALL cl_err(g_imz.imz906,'aim-998',0)
                  NEXT FIELD imz906
               END IF
               IF g_sma.sma122 = '1' THEN
                  IF g_imz.imz906 = '3' THEN
                     CALL cl_err('','asm-322',1)
                     NEXT FIELD imz906
                  END IF
               END IF
               IF g_sma.sma122 = '2' THEN
                  IF g_imz.imz906 = '2' THEN
                     CALL cl_err('','asm-323',1)
                     NEXT FIELD imz906
                  END IF
               END IF
               IF g_imz.imz906 <> '1' THEN
                  IF cl_null(g_imz.imz907) THEN
                     LET g_imz.imz907 = g_imz.imz25
                     DISPLAY BY NAME g_imz.imz907
                  END IF
               END IF
               IF g_sma.sma116 MATCHES '[123]' THEN   #No.FUN-610076
                  IF cl_null(g_imz.imz908) THEN
                     LET g_imz.imz908 = g_imz.imz25
                     DISPLAY BY NAME g_imz.imz908
                  END IF
               END IF
            END IF
            IF g_imz906 <> g_imz.imz906 AND g_imz906 IS NOT NULL AND p_cmd = 'u' THEN
               IF NOT cl_confirm('aim-999') THEN
                  LET g_imz.imz906=g_imz906
                  DISPLAY BY NAME g_imz.imz906
                  NEXT FIELD imz906
               END IF
            END IF
         END IF
         CALL i110_set_no_entry(p_cmd)
 
      AFTER FIELD imz907
         IF NOT cl_null(g_imz.imz907) THEN
            SELECT gfe01 FROM gfe_file
             WHERE gfe01=g_imz.imz907
               AND gfeacti IN ('Y','y')
            IF SQLCA.sqlcode  THEN
               CALL cl_err3("sel","gfe_file",g_imz.imz907,"","mfg0019","","",1)  #No.FUN-660156
               LET g_imz.imz907 = g_imz_o.imz907
               DISPLAY BY NAME g_imz.imz907
               NEXT FIELD imz907
            END IF
            IF NOT cl_null(g_imz.imz25) THEN
               IF g_imz.imz906 <> '3' THEN   #NO.MOD-660149
                   #母子單位時,第二單位必須和ima25有轉換率
                   CALL s_umfchk('',g_imz.imz907,g_imz.imz25)
                        RETURNING l_sw,l_factor
                   IF l_sw THEN
                      CALL cl_err(g_imz.imz907,'abm-731',0)
                      NEXT FIELD imz907
                   END IF
               END IF                        #NO.MOD-660149
            END IF
            IF g_imz907 <> g_imz.imz907 AND g_imz907 IS NOT NULL AND p_cmd = 'u' THEN
               IF NOT cl_confirm('aim-999') THEN
                  LET g_imz.imz907=g_imz907
                  DISPLAY BY NAME g_imz.imz907
                  NEXT FIELD imz907
               END IF
            END IF
         END IF
 
      BEFORE FIELD imz908
         IF cl_null(g_imz.imz908) THEN
            IF g_sma.sma116 MATCHES '[123]' THEN   #No.FUN-610076
               LET g_imz.imz908 = g_imz.imz25
               DISPLAY BY NAME g_imz.imz908
            END IF
         END IF
 
      AFTER FIELD imz908
         IF NOT cl_null(g_imz.imz908) THEN
            SELECT gfe01 FROM gfe_file
             WHERE gfe01=g_imz.imz908
               AND gfeacti IN ('Y','y')
            IF SQLCA.sqlcode  THEN
               CALL cl_err3("sel","gfe_file",g_imz.imz908,"","mfg0019","","",1)  #No.FUN-660156
               LET g_imz.imz908 = g_imz_o.imz908
               DISPLAY BY NAME g_imz.imz908
               NEXT FIELD imz908
            END IF
            IF NOT cl_null(g_imz.imz25) THEN
               IF g_imz.imz906 <> '3' THEN    #NO.MOD-660149
                   #母子單位時,第二單位必須和ima25有轉換率
                   CALL s_umfchk('',g_imz.imz908,g_imz.imz25)
                        RETURNING l_sw,l_factor
                   IF l_sw THEN
                      CALL cl_err(g_imz.imz908,'abm-731',0)
                      NEXT FIELD imz908
                   END IF
               END IF                         #NO.MOD-660149
            END IF
            IF g_imz908 <> g_imz.imz908 AND g_imz908 IS NOT NULL AND p_cmd = 'u' THEN
               IF NOT cl_confirm('aim-999') THEN
                  LET g_imz.imz908=g_imz908
                  DISPLAY BY NAME g_imz.imz908
                  NEXT FIELD imz908
               END IF
            END IF
         END IF
 

#FUN-A10004 ---ADD BEGIN
      BEFORE FIELD imz918
         CALL i110_set_entry(p_cmd)

      ON CHANGE imz918
         IF cl_null(g_imz.imz918) OR g_imz.imz918 = 'N' THEN
            LET g_imz.imz919 = 'N'
            LET g_imz.imz920 = NULL
            CALL i110_set_no_required()
            DISPLAY BY NAME g_imz.imz919
            DISPLAY BY NAME g_imz.imz920
         END IF
         CALL i110_set_no_entry(p_cmd)

      #TQC-C40044--add--str--
      AFTER FIELD imz918
         IF cl_null(g_imz.imz918) OR g_imz.imz918 = 'N' THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM imzc_file
               WHERE imzc01 = g_imz.imz01
                 AND imzc03 = 2
            IF l_n > 0 THEN
               CALL cl_err('','aim1157',0)
               LET g_imz.imz918 = 'Y'
               DISPLAY BY NAME g_imz.imz918
               NEXT FIELD imz918
            END IF
         END IF
      #TQC-C40044--add--end--

      BEFORE FIELD imz919
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_required()   #No.MOD-840257

     #AFTER FIELD imz919  #MOD-A50099 mark
      ON CHANGE imz919    #MOD-A50099
         CALL i110_set_no_entry(p_cmd)
         CALL i110_set_required()   #No.MOD-840257

      AFTER FIELD imz920
         IF NOT cl_null(g_imz.imz920) THEN
            SELECT COUNT(*) INTO l_n FROM geh_file,gei_file   #No.MOD-840254  #No.MOD-840294
             WHERE geh04 = '5'   #No.MOD-840254
               AND geh01 = gei03  #No.MOD-840294
               AND gei01 = g_imz.imz920   #No.MOD-840254  #No.MOD-840294
            IF l_n = 0 THEN
               CALL cl_err(g_imz.imz920,'aoo-112',0)
               NEXT FIELD imz920
            END IF
         END IF

      BEFORE FIELD imz921
         CALL i110_set_entry(p_cmd)

      ON CHANGE imz921
         IF cl_null(g_imz.imz921) OR g_imz.imz921 = 'N' THEN
            LET g_imz.imz922 = 'N'
            LET g_imz.imz923 = NULL
            CALL i110_set_no_required()
            DISPLAY BY NAME g_imz.imz922
            DISPLAY BY NAME g_imz.imz923
         END IF
         CALL i110_set_no_entry(p_cmd)

      BEFORE FIELD imz922
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_required()   #No.MOD-840257

     #AFTER FIELD imz922  #MOD-A50099 mark
      ON CHANGE imz922    #MOD-A50099
         CALL i110_set_no_entry(p_cmd)
         CALL i110_set_required()   #No.MOD-840257

      AFTER FIELD imz923
         IF NOT cl_null(g_imz.imz923) THEN
            SELECT COUNT(*) INTO l_n FROM geh_file,gei_file   #No.MOD-840254  #No.MOD-840294
             WHERE geh04 = '6'   #No.MOD-840254
               AND geh01 = gei03  #No.MOD-840294
               AND gei01 = g_imz.imz923   #No.MOD-840254
            IF l_n = 0 THEN
               CALL cl_err(g_imz.imz923,'aoo-112',0)
               NEXT FIELD imz923
            END IF
         END IF

      AFTER FIELD imz925
         IF g_imz.imz925 NOT MATCHES '[123]' THEN
            NEXT FIELD imz925
         END IF
#N0.TQC-B90236 ------------- add start ----------------
      AFTER FIELD imz928
         IF cl_null(g_imz.imz928) THEN
            CALL cl_err('',1205,0)
            NEXT FIELD imz928
         ELSE
            IF g_imz.imz928 = "N" THEN
               CALL cl_set_comp_entry('imz929',TRUE)
            ELSE 
               LET g_imz.imz929 = ''
               CALL cl_set_comp_entry('imz929',FALSE)
            END IF
         END IF  
      ON CHANGE imz928
         IF g_imz.imz928 = "N" THEN
            CALL cl_set_comp_entry('imz929',TRUE)
         ELSE
            LET g_imz.imz929 = ''
            CALL cl_set_comp_entry('imz929',FALSE)
         END IF

      AFTER FIELD imz929
         IF NOT cl_null(g_imz.imz929) THEN
            SELECT COUNT(ima01) INTO l_chose FROM ima_file WHERE ima928 = "Y" AND ima01=g_imz.imz929
            IF l_chose = 0 THEN
               CALL cl_err('','aim1116',0)
               LET g_imz.imz929=g_imz_t.imz929
               NEXT FIELD imz929
            END IF
            #TQC-C40038--add--str--
            SELECT ima918 INTO l_ima918 FROM ima_file
             WHERE ima01 = g_imz.imz929
            IF l_ima918 = 'Y' AND g_imz.imz918 <> 'Y' THEN
               CALL cl_err('','aim1145',0)
               LET g_imz.imz929 = g_imz_t.imz929
               NEXT FIELD imz929
            END IF
            #TQC-C40038--add--end--
         END IF
#No.TQC-B90236 ------------- add end -----------------  
#FUN-A10004 ---ADD END
 
      AFTER FIELD imz35  #倉庫別
{&}      IF  g_imz.imz35 IS NULL THEN LET g_imz.imz35 = ' ' END IF
{&}      IF  g_imz_o.imz35 IS NULL THEN LET g_imz_o.imz35 = ' ' END IF
         IF g_imz.imz35 IS NOT NULL AND g_imz.imz35 !=' ' THEN
            IF cl_null(g_imz_o.imz35) OR (g_imz.imz35 != g_imz_o.imz35) THEN
               SELECT imd01 FROM imd_file
                WHERE imd01=g_imz.imz35  AND imdacti='Y'
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","imd_file",g_imz.imz35,"",
                               "mfg1100","","",1)  #No.FUN-660156
                  LET g_imz.imz35 = g_imz_o.imz35
                  DISPLAY BY NAME g_imz.imz35
                  NEXT FIELD imz35
               END IF
            END IF
            #FUN-CB0052--add--str--
            SELECT imd10 INTO l_imd10 FROM imd_file
             WHERE imd01 = g_imz.imz35 AND imdacti='Y'
            IF l_imd10 MATCHES '[Ii]' THEN
               CALL cl_err(l_imd10,'axm-693',0)
               NEXT FIELD imz35
            END IF
            #FUN-CB0052--add--end--
         END IF
         LET g_imz_o.imz35 = g_imz.imz35
         #FUN-C30023---begin
         IF cl_null(g_imz.imz35) THEN
            LET l_imd02 = NULL 
            DISPLAY l_imd02 TO imd02
         ELSE
            SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = g_imz.imz35
            DISPLAY l_imd02 TO imd02
         END IF 
         #FUN-C30023---end
	IF NOT s_imechk(g_imz.imz35,g_imz.imz36) THEN NEXT FIELD imz36 END IF  #FUN-D40103 ad
 
      AFTER FIELD imz36  #儲位別
{&}      IF  g_imz.imz36 IS NULL THEN LET g_imz.imz36 = ' ' END IF
{&}      IF  g_imz_o.imz36 IS NULL THEN LET g_imz_o.imz36 = ' ' END IF
	#FUN-D40103--mark--str--
        # IF g_imz.imz36 IS NOT NULL AND g_imz.imz36 !=' '
        # THEN IF cl_null(g_imz_o.imz36) OR (g_imz.imz36 != g_imz_o.imz36)
        #       THEN SELECT ime01 FROM ime_file
        #                   WHERE ime01=g_imz.imz35 AND ime02=g_imz.imz36
        #           IF SQLCA.sqlcode THEN
        #               CALL cl_err3("sel","ime_file",g_imz.imz36,"",
        #                            "mfg1100","","",1)  #No.FUN-660156
        #                           LET g_imz.imz36 = g_imz_o.imz36
        #                           DISPLAY BY NAME g_imz.imz36
        #                           NEXT FIELD imz36
        #            END IF
        #      END IF
        # END IF
	 #FUN-D40103--mark--end--
         #FUN-D40103--add--str--
         IF NOT s_imechk(g_imz.imz35,g_imz.imz36) THEN
            LET g_imz.imz36 = g_imz_o.imz36
            DISPLAY BY NAME g_imz.imz36
            NEXT FIELD imz36
         END IF 
         #FUN-D40103--add--end--
         LET g_imz_o.imz36 = g_imz.imz36
 
      AFTER FIELD imz39  #會計科目, 可空白, 須存在
         IF g_imz.imz39 IS NOT NULL THEN
            IF g_sma.sma03='Y' THEN
               IF NOT s_actchk3(g_imz.imz39,g_aza.aza81) THEN  #No.FUN-730033
                  CALL cl_err('','aim-395','0')
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_imz.imz39 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz39 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_imz.imz39
                  DISPLAY BY NAME g_imz.imz39  
                  #FUN-B10049--end                     
                  NEXT FIELD imz39
               END IF
            END IF
         END IF
 
      AFTER FIELD imz391  #會計科目二, 可空白, 須存在
         IF g_imz.imz391 IS NOT NULL THEN                                                                                            
            IF g_sma.sma03='Y' THEN                                                                                                 
               IF NOT s_actchk3(g_imz.imz391,g_aza.aza82) THEN  #No.FUN-730033 
                  CALL cl_err('','aim-395','0')       
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_imz.imz391 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza82  
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz391 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_imz.imz391
                  DISPLAY BY NAME g_imz.imz391  
                  #FUN-B10049--end                                                                                                 
                  NEXT FIELD imz391                                                                                                  
               END IF                                                                                                               
            END IF                                                                                                                  
         END IF
      #FUN-C80094---ADD---STR
      AFTER FIELD imz163 #發出商品會計科目, 可空白, 須存在
         IF g_imz.imz163 IS NOT NULL THEN
            IF g_sma.sma03='Y' THEN
               IF NOT s_actchk3(g_imz.imz163,g_aza.aza81) THEN
                  CALL cl_err('','aim-395','0')
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_imz.imz163
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_aza.aza81
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz163 CLIPPED,"%' "
                  CALL cl_create_qry() RETURNING g_imz.imz163
                  DISPLAY BY NAME g_imz.imz163
                  NEXT FIELD imz163
               END IF
            END IF
         END IF
      AFTER FIELD imz1631  #發出商品會計科目二, 可空白, 須存在
         IF g_imz.imz1631 IS NOT NULL THEN
            IF g_sma.sma03='Y' THEN
               IF NOT s_actchk3(g_imz.imz1631,g_aza.aza82) THEN  #No.FUN-730033
                  CALL cl_err('','aim-395','0')
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_imz.imz1631
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_aza.aza82
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz1631 CLIPPED,"%' "

                  CALL cl_create_qry() RETURNING g_imz.imz1631
                  DISPLAY BY NAME g_imz.imz1631
                  NEXT FIELD imz1631
               END IF
            END IF
         END IF
      #FUN-C80094--ADD--END 
      AFTER FIELD imz73  #代銷科目, 可空白, 須存在
         IF g_imz.imz73 IS NOT NULL THEN
            IF g_sma.sma03='Y' THEN
               IF NOT s_actchk3(g_imz.imz73,g_aza.aza81) THEN
                  CALL cl_err('','aim-395','0')
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_imz.imz73 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz73 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_imz.imz73
                  DISPLAY BY NAME g_imz.imz73  
                  #FUN-B10049--end                   
                  NEXT FIELD imz73
               END IF
            END IF
         END IF
 
      AFTER FIELD imz731  #代銷科目二, 可空白, 須存在
         IF g_imz.imz731 IS NOT NULL THEN                                                                                            
            IF g_sma.sma03='Y' THEN                                                                                                 
               IF NOT s_actchk3(g_imz.imz731,g_aza.aza82) THEN
                  CALL cl_err('','aim-395','0')       
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_imz.imz731 
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza82  
                  LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imz.imz731 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_imz.imz731
                  DISPLAY BY NAME g_imz.imz731  
                  #FUN-B10049--end                                                                                                 
                  NEXT FIELD imz731                                                                                                  
               END IF                                                                                                               
            END IF                                                                                                                  
         END IF
 
      AFTER FIELD imz71
         IF NOT cl_null(g_imz.imz71) AND g_imz.imz71 < 0 THEN
            CALL cl_err(g_imz.imz71,'mfg0013',0)
            LET g_imz.imz71 = g_imz_o.imz71
            DISPLAY BY NAME g_imz.imz71
            NEXT FIELD imz71
         END IF
         LET g_imz_o.imz71 = g_imz.imz71
 
      AFTER FIELD imz909
         IF NOT cl_null(g_imz.imz909) AND g_imz.imz909 < 0 THEN
            CALL cl_err(g_imz.imz909,'32406',0)
            LET g_imz.imz909 = g_imz_o.imz909
            DISPLAY BY NAME g_imz.imz909
            NEXT FIELD imz909
         END IF
         LET g_imz_o.imz909 = g_imz.imz909
 
      AFTER FIELD imz23            #倉管員
         IF g_imz.imz23 IS NOT NULL THEN
            IF (g_imz_o.imz23 IS NULL) or (g_imz.imz23 != g_imz_o.imz23) THEN
               CALL aimi110_peo(g_imz.imz23,'a')
               IF g_chr = 'E' THEN
                  CALL cl_err(g_imz.imz23,'mfg3096',0)
                  LET g_imz.imz23 = g_imz_o.imz23
                  DISPLAY BY NAME g_imz.imz23
                  NEXT FIELD imz23
               END IF
            END IF
         ELSE LET l_gen02 = NULL
              DISPLAY l_gen02 TO gen02
         END IF
         LET g_imz_o.imz23 = g_imz.imz23
 
      AFTER FIELD imz25            #庫存單位
         IF g_imz.imz25 IS NOT NULL THEN
            IF (g_imz_o.imz25 IS NULL) OR (g_imz_o.imz25 != g_imz.imz25) THEN
              #str MOD-A50112 add
               #當執行複製功能後,修改了庫存單位要同步更新到其他單位欄位
               IF g_action_choice="reproduce" THEN
                 #LET g_imz.imz17 =g_imz.imz25        #銷售統計單位   #CHI-B80083 mark
                  LET g_imz.imz31 =g_imz.imz25        #銷售單位
                  LET g_imz.imz31_fac=1               #銷售單位/庫存單位換算率
                  LET g_imz.imz44 =g_imz.imz25        #採購單位
                  LET g_imz.imz44_fac=1               #採購單位/庫存單位換算率
                  LET g_imz.imz55 =g_imz.imz25        #生產單位
                  LET g_imz.imz55_fac=1               #生產單位/庫存單位換算率
                  LET g_imz.imz63 =g_imz.imz25        #發料單位
                  LET g_imz.imz63_fac=1               #發料單位/庫存單位換算率
                  LET g_imz.imz86 =g_imz.imz25        #成本單位
                  LET g_imz.imz86_fac=1               #成本單位/庫存單位換算率
                  IF g_sma.sma115 = 'N' THEN
                     LET g_imz.imz906 = '1'           #單位使用方式1.單一單位2.母子單位3.參考單位
                     LET g_imz.imz907 = NULL
                  ELSE
                     LET g_imz.imz907 = g_imz.imz25   #第二單位
                  END IF
                  IF g_sma.sma116 = '0' THEN
                     LET g_imz.imz908 = NULL
                  ELSE
                     LET g_imz.imz908 = g_imz.imz25   #計價單位
                  END IF
                 #DISPLAY BY NAME g_imz.imz17,g_imz.imz25,   #CHI-B80083 mark
                  DISPLAY BY NAME g_imz.imz25,               #CHI-B80083
                                  g_imz.imz906,g_imz.imz907,g_imz.imz908
               END IF
              #end MOD-A50112 add
               SELECT gfe01 FROM gfe_file
                WHERE gfe01=g_imz.imz25 AND gfeacti IN ('y','Y')
               IF SQLCA.sqlcode THEN 
                  CALL cl_err3("sel","gfe_file",g_imz.imz25,"",
                               "mfg1200","","",1)  #No.FUN-660156
                  LET g_imz.imz25 = g_imz_o.imz25
                  DISPLAY BY NAME g_imz.imz25
                  NEXT FIELD imz25
               END IF
            END IF
         END IF
         LET g_imz_o.imz25 = g_imz.imz25
         LET l_direct = 'D'
         LET g_imz.imz86=g_imz.imz25
         #FUN-BB0083---add---str
         IF g_imz.imz37 != '0' THEN
            LET g_imz.imz38 = s_digqty(g_imz.imz38,g_imz.imz25)
            DISPLAY BY NAME g_imz.imz38
         ELSE
            IF NOT i100_imz38_check() THEN 
               LET g_imz25_t = g_imz.imz25
               NEXT FIELD imz38
            END IF
            LET g_imz25_t = g_imz.imz25
         END IF
         #FUN-BB0083---add---end
         
 
      AFTER FIELD imz27
          IF NOT cl_null(g_imz.imz27) AND g_imz.imz27 < 0 THEN
             CALL cl_err(g_imz.imz27,'mfg0013',0)
             LET g_imz.imz27 = g_imz_o.imz27
             DISPLAY BY NAME g_imz.imz27
             NEXT FIELD imz27
          END IF
          LET g_imz_o.imz27 = g_imz.imz27
          LET l_direct = 'U'
 
      AFTER FIELD imz28
          IF NOT cl_null(g_imz.imz28) AND g_imz.imz28 < 0 THEN
             CALL cl_err(g_imz.imz28,'mfg0013',0)
             LET g_imz.imz28 = g_imz_o.imz28
             DISPLAY BY NAME g_imz.imz28
             NEXT FIELD imz28
          END IF
          LET g_imz_o.imz28=g_imz.imz28
 
      AFTER FIELD imz903
          IF g_imz.imz903 NOT MATCHES "[YN]" AND NOT cl_null(g_imz.imz903) THEN
             CALL cl_err(g_imz.imz903,'mfg1002',0)
             LET g_imz.imz903 = g_imz_o.imz903
             DISPLAY BY NAME g_imz.imz903
             NEXT FIELD imz903
          END IF
          LET g_imz_o.imz903 = g_imz.imz903
 
      AFTER FIELD imz911
          IF g_imz.imz911 NOT MATCHES "[YN]" AND NOT cl_null(g_imz.imz911) THEN
             CALL cl_err(g_imz.imz911,'mfg1002',0)
             LET g_imz.imz911 = g_imz_o.imz911
             DISPLAY BY NAME g_imz.imz911
             NEXT FIELD imz911
          END IF
          LET g_imz_o.imz911 = g_imz.imz911
 
     AFTER FIELD imzicd01
         IF NOT i110_ind_icd_chk_item('imzicd01',g_imz.imzicd01) THEN
            LET g_imz.imzicd01=g_imz_o.imzicd01
            NEXT FIELD CURRENT
         ELSE
            CALL i110_ind_icd_set_default(g_imz.imzicd05,g_imz.imzicd01)
         END IF
         #FUN-C30278---begin
         IF g_imz.imzicd04 = '1' OR g_imz.imzicd04 = '2' THEN  
            IF NOT cl_null(g_imz.imzicd01) THEN 
               SELECT imaicd14 INTO g_imz.imzicd14 FROM imaicd_file WHERE imaicd00 = g_imz.imzicd01
               DISPLAY BY NAME g_imz.imzicd14
            END IF 
         END IF 
         #FUN-C30278---end
    #FUN-B50106 ------------------Begin--------------------
         #IF g_imz.imzicd04 MATCHES'[1234]' THEN          #CHI-B70014 mark
         #   CALL cl_set_comp_required("imzicd01",TRUE)   #CHI-B70014 mark
         #ELSE                                            #CHI-B70014 mark
         #   CALL cl_set_comp_required("imzicd01",FALSE)  #CHI-B70014 mark
         #END IF                                          #CHI-B70014 mark 
    #FUN-B50106 ------------------End----------------------     
#FUN-B30192--mark
#     AFTER FIELD imzicd02
#        IF NOT i110_ind_icd_chk_item('imzicd02',g_imz.imzicd02) THEN
#           LET g_imz.imzicd02=g_imz_o.imzicd02
#           NEXT FIELD CURRENT
#        END IF

#     AFTER FIELD imzicd03
#        IF NOT i110_ind_icd_chk_item('imzicd03',g_imz.imzicd03) THEN
#           LET g_imz.imzicd03=g_imz_o.imzicd03
#           NEXT FIELD CURRENT
#        END IF
#FUN-B30192--mark      
      BEFORE FIELD imzicd04 
         CALL i110_set_entry(p_cmd)
      #FUN-C30278---begin
     #MOD-AB0209---mark---start---
     #ON CHANGE imzicd04
     #   #因為s_icdpost設定 當imaicd04 = 3 或4時，強制要求必須走"刻號/BIN管理"
     #   IF g_imz.imzicd04 MATCHES '[34]' THEN
     #      LET g_imz.imzicd08='Y'
     #      DISPLAY BY NAME g_imz.imzicd08
     #   END IF
     #   CALL i110_set_no_entry(p_cmd)
     #MOD-AB0209---mark---end--- 
      BEFORE FIELD imzicd08 
        CALL i110_set_entry(p_cmd)
        CALL i110_set_no_entry(p_cmd)
#FUN-B30192--mark
#     AFTER FIELD imzicd06
#        IF NOT i110_ind_icd_chk_item('imzicd06',g_imz.imzicd06) THEN
#           LET g_imz.imzicd06=g_imz_o.imzicd06
#           NEXT FIELD CURRENT
#        END IF
#FUN-B30192--mark       

    #FUN-B30192--add--begin
      AFTER FIELD imzicd04     
    #FUN-B50106 ------------------Begin--------------------
         #IF g_imz.imzicd04 MATCHES'[1234]' THEN          #CHI-B70014 mark
         #   CALL cl_set_comp_required("imzicd01",TRUE)   #CHI-B70014 mark
         #ELSE                                            #CHI-B70014 mark
         #   CALL cl_set_comp_required("imzicd01",FALSE)  #CHI-B70014 mark
         #END IF                                          #CHI-B70014 mark
    #FUN-B50106 ------------------End----------------------          
    #    IF g_imz.imzicd04 = '1' THEN         #FUN-B50106  mark
    #       LET g_imz.imzicd16 = g_imz.imz01  #FUN-B50106  mark
    #    END IF                               #FUN-B50106  mark
         CALL i110_set_no_entry(p_cmd)  #TQC-C40078 add       
      AFTER FIELD imzicd15
            IF  g_imz.imzicd15 < 0 THEN
              CALL cl_err('','aec-020',0)
              NEXT FIELD imzicd15
            END IF  
     #FUN-B30192--add--end 
     #FUN-B50106 ----------Begin-----------
      AFTER FIELD imzicd16
         IF NOT cl_null(g_imz.imzicd16) THEN
            LET l_n = 0 
            SELECT COUNT(*) INTO l_n FROM imaicd_file
             WHERE imaicd00 = g_imz.imzicd16
               AND imaicd04 = '1'
            IF l_n < 1 THEN
               CALL cl_err('','aim-029',0)
               NEXT FIELD imzicd16
            END IF 
         END IF
     #FUN-B50106 ----------End-------------
       
      AFTER FIELD imzicd10
         IF NOT i110_ind_icd_chk_imzicd10(g_imz.imzicd10) THEN
            LET g_imz.imzicd10=g_imz_o.imzicd10
            NEXT FIELD CURRENT
         END IF

      ON CHANGE imzicd05
         IF g_imz.imzicd05<>g_imz_o.imzicd05 OR g_imz_o.imzicd05 IS NULL THEN
            CALL i110_ind_icd_set_default(g_imz.imzicd05,g_imz.imzicd01)
         END IF
      #FUN-C30278---begin
      AFTER FIELD imzicd05
         IF g_imz.imzicd05 = '6' THEN
            LET g_imz.imzicd04 = '9'
            DISPLAY BY NAME g_imz.imzicd04
         END IF
      #FUN-C30278---end
      #FUN-BC0103 --START--
      AFTER FIELD imzicd17
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)         
      #FUN-BC0103 --END--
      
      AFTER FIELD imzicd79
         IF NOT cl_null(g_imz.imzicd79) THEN
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM icc_file
             WHERE icc01 = g_imz.imzicd79
               AND iccacti = 'Y'
            IF l_n = 0 THEN
               CALL cl_err('',100,0)
               NEXT FIELD imzicd79
            END IF
         END IF
     #FUN-A80150---add---start---
      BEFORE FIELD imz156
         CALL i110_set_entry(p_cmd)

      ON CHANGE imz156
         CALL i110_set_no_entry(p_cmd)

      AFTER FIELD imz157
         IF NOT cl_null(g_imz.imz157) THEN
            SELECT COUNT(*) INTO l_n FROM geh_file,gei_file   
             WHERE geh04 = '5'  
               AND geh01 = gei03 
               AND gei01 = g_imz.imz157  
            IF l_n = 0 THEN
               CALL cl_err(g_imz.imz157,'aoo-112',0)
               NEXT FIELD imz157
            END IF
         END IF
     #FUN-A80150---add---end---

      #FUN-B30192(S)
      ON CHANGE imzicd04
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)         
      #FUN-B30192(E)
    #FUN-B50106 ------------------Begin--------------------
         #IF g_imz.imzicd04 MATCHES'[1234]' THEN          #CHI-B70014 mark
         #   CALL cl_set_comp_required("imzicd01",TRUE)   #CHI-B70014 mark
         #ELSE                                            #CHI-B70014 mark
         #   CALL cl_set_comp_required("imzicd01",FALSE)  #CHI-B70014 mark 
         #END IF                                          #CHI-B70014 mark
    #FUN-B50106 ------------------End----------------------

      AFTER FIELD imzud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD imzud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER INPUT
         LET g_imz.imzuser = s_get_data_owner("imz_file") #FUN-C10039
         LET g_imz.imzgrup = s_get_data_group("imz_file") #FUN-C10039
          IF g_sma.sma115 = 'Y' THEN
             IF g_imz.imz906 IS NULL THEN
                NEXT FIELD imz906
             END IF
          END IF
          IF g_sma.sma122 = '1' THEN
             IF g_imz.imz906 = '3' THEN
                CALL cl_err('','asm-322',1)
                NEXT FIELD imz906
             END IF
          END IF
          IF g_sma.sma122 = '2' THEN
             IF g_imz.imz906 = '2' THEN
                CALL cl_err('','asm-323',1)
                NEXT FIELD imz906
             END IF
          END IF
#TQC-B90236-----add---end---
          
      ON ACTION create_unit
         CALL cl_cmdrun('aooi101 ')
 
      ON ACTION crt_material_cate_code
         CALL cl_cmdrun('aooi305 ')
 
#NO.FUN-B30092  ------------------------add start------------------------
      ON ACTION quantifying
         CALL cl_cmdrun("aooi104 ")
#NO.FUN-B30092 --------------------------add end------------------------

      ON ACTION unit_conversion
         CALL cl_cmdrun("aooi102 ")
 
      #MOD-C30095--mark--str--
      #ON ACTION create_item
      #   CALL cl_cmdrun("aooi103 ")
      #MOD-C30095--mark--end--
 
      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(imz09) #其他分群碼一
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz09
                LET g_qryparam.arg1 = "D"
                CALL cl_create_qry() RETURNING g_imz.imz09
                DISPLAY BY NAME g_imz.imz09
                CALL aimi110_azf01(g_imz.imz09,'D','d')    #CHI-730034
                NEXT FIELD imz09
             WHEN INFIELD(imz10) #其他分群碼二
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz10
                LET g_qryparam.arg1 = "E"
                CALL cl_create_qry() RETURNING g_imz.imz10
                DISPLAY BY NAME g_imz.imz10
                CALL aimi110_azf01(g_imz.imz10,'E','d')    #CHI-730034
                NEXT FIELD imz10
             WHEN INFIELD(imz11) #其他分群碼三
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz11
                LET g_qryparam.arg1 = "F"
                CALL cl_create_qry() RETURNING g_imz.imz11
                DISPLAY BY NAME g_imz.imz11
                CALL aimi110_azf01(g_imz.imz11,'F','d')    #CHI-730034
                NEXT FIELD imz11
             WHEN INFIELD(imz12) #其他分群碼四
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz12
                LET g_qryparam.arg1 = "G"
                CALL cl_create_qry() RETURNING g_imz.imz12
                DISPLAY BY NAME g_imz.imz12
                NEXT FIELD imz12
            #CHI-B80083 -- mark begin --
            #WHEN INFIELD(imz17)
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form = "q_gfe"
            #   LET g_qryparam.default1 = g_imz.imz17
            #   CALL cl_create_qry() RETURNING g_imz.imz17
            #   DISPLAY BY NAME g_imz.imz17
            #   NEXT FIELD imz17
            #CHI-B80083 -- mark end --
             WHEN INFIELD(imz907) #FUN-540025
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_imz.imz907
                CALL cl_create_qry() RETURNING g_imz.imz907
                DISPLAY BY NAME g_imz.imz907
                NEXT FIELD imz907
             WHEN INFIELD(imz908) #FUN-540025
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_imz.imz908
                CALL cl_create_qry() RETURNING g_imz.imz908
                DISPLAY BY NAME g_imz.imz908
                NEXT FIELD imz908

#FUN-A10004 ----ADD BEGIN
            WHEN INFIELD(imz920)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
               LET g_qryparam.default1 = g_imz.imz920
               LET g_qryparam.where = " geh04='5'"   #No.MOD-840254
               CALL cl_create_qry() RETURNING g_imz.imz920
               DISPLAY g_imz.imz920 TO imz920
            WHEN INFIELD(imz923)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gei2"   #No.MOD-840254  #No.MOD-840294
               LET g_qryparam.default1 = g_imz.imz923
               LET g_qryparam.where = " geh04='6'"   #No.MOD-840254
               CALL cl_create_qry() RETURNING g_imz.imz923
               DISPLAY g_imz.imz923 TO imz923
#FUN-A10004 ----ADD END
#No.TQC-B90236 ---- add start -------
            WHEN INFIELD(imz929)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imz929_1"   #No.MOD-840254  #No.MOD-840294
               LET g_qryparam.default1 = g_imz.imz929
               CALL cl_create_qry() RETURNING g_imz.imz929
               DISPLAY g_imz.imz929 TO imz929
               NEXT FIELD imz929
#No.TQC-B90236 ---- add end ---------

             WHEN INFIELD(imz39) #會計科目
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"   #MOD-860067 modify  #TQC-870001 modify  #MOD-870230 modify
                LET g_qryparam.default1 = g_imz.imz39
                LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
                CALL cl_create_qry() RETURNING g_imz.imz39
                DISPLAY BY NAME g_imz.imz39
                NEXT FIELD imz39
             WHEN INFIELD(imz391) #會計科目二
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form = "q_aag02"   #MOD-860067 modify  #TQC-870001 modify  #MOD-870230 modify
                LET g_qryparam.default1 = g_imz.imz391                                                                               
                LET g_qryparam.arg1 = g_aza.aza82  #No.FUN-730033
                CALL cl_create_qry() RETURNING g_imz.imz391
                DISPLAY BY NAME g_imz.imz391
                NEXT FIELD imz391 
             #FUN-C80094---ADD--STR
              WHEN INFIELD(imz163) #發出商品會計科目
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.default1 = g_imz.imz163
                LET g_qryparam.arg1 = g_aza.aza81
                CALL cl_create_qry() RETURNING g_imz.imz163
                DISPLAY BY NAME g_imz.imz163
                NEXT FIELD imz163
             WHEN INFIELD(imz1631) #發出商品會計科目二
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.default1 = g_imz.imz1631
                LET g_qryparam.arg1 = g_aza.aza82
                CALL cl_create_qry() RETURNING g_imz.imz1631
                DISPLAY BY NAME g_imz.imz1631
                NEXT FIELD imz1631
             #FUN-C80094--ADD--END 
             WHEN INFIELD(imz73) #代銷科目
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.default1 = g_imz.imz73
                LET g_qryparam.arg1 = g_aza.aza81
                CALL cl_create_qry() RETURNING g_imz.imz73
                DISPLAY BY NAME g_imz.imz73
                NEXT FIELD imz73
             WHEN INFIELD(imz731) #代銷科目二
                CALL cl_init_qry_var()                                                                                              
                LET g_qryparam.form = "q_aag02" 
                LET g_qryparam.default1 = g_imz.imz731                                                                               
                LET g_qryparam.arg1 = g_aza.aza82 
                CALL cl_create_qry() RETURNING g_imz.imz731
                DISPLAY BY NAME g_imz.imz731
                NEXT FIELD imz731  
             WHEN INFIELD(imz23) #倉管員
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gen"
                LET g_qryparam.default1 = g_imz.imz23
                CALL cl_create_qry() RETURNING g_imz.imz23
                DISPLAY BY NAME g_imz.imz23
                CALL aimi110_peo(g_imz.imz23,'d')
                NEXT FIELD imz23
             WHEN INFIELD (imz35) #倉庫別  ##saki..qry有錯誤,q_imd需重建
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd"
                LET g_qryparam.default1 = g_imz.imz35
                 LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                CALL cl_create_qry() RETURNING g_imz.imz35
                DISPLAY BY NAME g_imz.imz35
                NEXT FIELD imz35
             WHEN INFIELD (imz36) #儲位別  ##saki..qry有錯誤,q_ime需重建
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ime"
                LET g_qryparam.default1 = g_imz.imz36
                 LET g_qryparam.arg1     = g_imz.imz35 #倉庫編號 #MOD-4A0063
                 LET g_qryparam.arg2     = 'SW'        #倉庫類別 #MOD-4A0063
                CALL cl_create_qry() RETURNING g_imz.imz36
                DISPLAY BY NAME g_imz.imz36
                NEXT FIELD imz36
             WHEN INFIELD(imz25) #庫存單位
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_imz.imz25
                CALL cl_create_qry() RETURNING g_imz.imz25
                DISPLAY BY NAME g_imz.imz25
                NEXT FIELD imz25
             WHEN INFIELD(imz109)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azf"
                LET g_qryparam.default1 = g_imz.imz109
                LET g_qryparam.arg1 = 8
                CALL cl_create_qry() RETURNING g_imz.imz109
                DISPLAY BY NAME g_imz.imz109
                NEXT FIELD imz109
             WHEN INFIELD(imzicd01) #母體料號
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imaicd"
                #LET g_qryparam.where    = " imaicd05='1'"   #FUN-C30278
                LET g_qryparam.where    = " imaicd04='0' OR imaicd04='1'"   #FUN-C30278
                LET g_qryparam.default1 = g_imz.imzicd01
                CALL cl_create_qry() RETURNING g_imz.imzicd01
                DISPLAY BY NAME g_imz.imzicd01
                NEXT FIELD imzicd01

#NO.FUN-B30092  ------------------------add start------------------------
               WHEN INFIELD(imz251)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfo" 
                  LET g_qryparam.default1 = g_imz.imz251
                  CALL cl_create_qry() RETURNING g_imz.imz251
                  DISPLAY BY NAME g_imz.imz251
                  NEXT FIELD imz251
#NO.FUN-B30092 --------------------------add end------------------------
#FUN-B30192--mark
#             WHEN INFIELD(imzicd02) #外編母體 (預測料號)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_imaicd"
#                LET g_qryparam.where    = " imaicd05='2'"
#                LET g_qryparam.default1 = g_imz.imzicd02
#                CALL cl_create_qry() RETURNING g_imz.imzicd02
#                DISPLAY BY NAME g_imz.imzicd02
#                NEXT FIELD imzicd02
#             WHEN INFIELD(imzicd03) #外編子體 (客戶下單料號)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_imaicd"
#                LET g_qryparam.where    = " imaicd05='4'"
#                LET g_qryparam.default1 = g_imz.imzicd03
#                CALL cl_create_qry() RETURNING g_imz.imzicd03
#                DISPLAY BY NAME g_imz.imzicd03
#                NEXT FIELD imzicd03
#             WHEN INFIELD(imzicd06) #內編子體 (Wafer料號)
#                CALL cl_init_qry_var()
#                LET g_qryparam.form     = "q_imaicd"
#                LET g_qryparam.where    = " imaicd04='1'"
#                LET g_qryparam.default1 = g_imz.imzicd06
#                CALL cl_create_qry() RETURNING g_imz.imzicd06
#                DISPLAY BY NAME g_imz.imzicd06
#                NEXT FIELD imzicd06
#FUN-B30192--mark
#FUN-B30192--add--begin
             WHEN INFIELD(imzicd16)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_imaicd"
                #LET g_qryparam.where    = " imaicd04='4'"  #FUN-C30278
                LET g_qryparam.where    = " imaicd04='1'"   #FUN-C30278
                LET g_qryparam.default1 = g_imz.imzicd16
                CALL cl_create_qry() RETURNING g_imz.imzicd16
                DISPLAY BY NAME g_imz.imzicd16
                NEXT FIELD imzicd16
#FUN-B30192--add--end      
             WHEN INFIELD(imzicd10) #作業群組
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_icd11" 
                LET g_qryparam.arg1 = 'U'  
                LET g_qryparam.default1 = g_imz.imzicd10
                CALL cl_create_qry() RETURNING g_imz.imzicd10
                DISPLAY BY NAME g_imz.imzicd10
                NEXT FIELD imzicd10
             WHEN INFIELD(imzicd79)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_icc"
                LET g_qryparam.default1 = g_imz.imzicd79
                CALL cl_create_qry() RETURNING g_imz.imzicd79
                DISPLAY BY NAME g_imz.imzicd79
                NEXT FIELD imzicd79
            #FUN-A80150---add---start---
             WHEN INFIELD(imz157)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gei2"   
                LET g_qryparam.default1 = g_imz.imz157
                LET g_qryparam.where = " geh04='5'"   
                CALL cl_create_qry() RETURNING g_imz.imz157
                DISPLAY g_imz.imz157 TO imz157
            #FUN-A80150---add---end---
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
#No.TQC-B90236 ----------------- add start ----------------------------
    IF g_imz_t.imz928= "Y" AND g_imz.imz928= "N" THEN
       DELETE FROM imzc_file WHERE imzc01 = g_imz.imz01
    END IF
    IF g_imz.imz929 != g_imz_t.imz929
       OR (cl_null(g_imz.imz929) AND NOT cl_null(g_imz_t.imz929))
       OR (NOT cl_null(g_imz.imz929) AND  cl_null(g_imz_t.imz929)) THEN
       DELETE FROM imzc_file WHERE imzc01= g_imz.imz01
       LET g_sql= "SELECT * FROM imac_file WHERE imac01='", g_imz.imz929,"'"
       PREPARE aimi_bc FROM g_sql
       DECLARE aimi_cs CURSOR FOR aimi_bc
       FOREACH aimi_cs INTO g_imzc.*
          INSERT INTO imzc_file(imzc01,imzc02,imzc03,imzc04,imzc05,imzcuser,imzcgrup,imzcorig,imzcoriu)
          VALUES(g_imz.imz01,g_imzc.imzc02,g_imzc.imzc03,g_imzc.imzc04,'',g_user,g_grup,g_grup,g_user)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","imzc_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)
             RETURN
          END IF
       END FOREACH
       CALL aimi110_add(g_imz.imz01,g_imz.imz918,g_imz.imz928,g_imz.imz929)
    END IF
#No.TQC-B90236 ----------------- add end ------------------------------

END FUNCTION

#NO.FUN-B30092  ------------------------add start------------------------
FUNCTION i110_imz251_chk()
 DEFINE l_gfo01    LIKE gfo_file.gfo01
 DEFINE l_gfoacti  LIKE gfo_file.gfoacti

 LET g_errno= ""
 SELECT gfo01,gfoacti INTO l_gfo01,l_gfoacti FROM gfo_file
 WHERE gfo01 = g_imz.imz251

 CASE
   WHEN SQLCA.SQLCODE =100  LET g_errno = 'mfg0019'
   WHEN l_gfoacti ='N'      LET g_errno = 'aec-090'
                             LET l_gfo01 = NULL
                             LET l_gfoacti = NULL
    OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
END FUNCTION
#NO.FUN-B30092 --------------------------add end------------------------
 
FUNCTION i110_ind_icd_chk_item(p_feld,p_value)
   DEFINE p_feld  LIKE gaq_file.gaq01 #欄位名稱
   DEFINE p_value LIKE ima_file.ima01 #欄位值
   DEFINE l_imzicd05 LIKE imz_file.imzicd05 #料件特性 : 1.母體料號(BODY) 2.預測料號(外編母體) 3.光罩 4.外編子體 5.生產性料號 6.原物料
   DEFINE l_imzicd04 LIKE imz_file.imzicd04

   IF cl_null(p_value) THEN
      RETURN TRUE
   END IF
   #FUN-C30278---begin
   #SELECT imzicd04,imzicd05
   #  INTO l_imzicd04,l_imzicd05
   #  FROM imz_file,ima_file
   # WHERE ima01=p_value
   #   AND imz01 = ima06
   SELECT imaicd04,imaicd05 INTO l_imzicd04,l_imzicd05
     FROM imz_file,ima_file,imaicd_file
    WHERE ima01=p_value AND imz01=ima06 AND ima01=imaicd00
   #FUN-C30278---end
    
   CASE
      WHEN SQLCA.sqlcode<>0
         CALL cl_err3("sel","ima_file",p_value,"",100,"","",1)
      #WHEN (p_feld="imzicd01") AND (l_imzicd05<>"1")  #母體料號   #FUN-C30278
      WHEN (p_feld="imzicd01") AND (l_imzicd04<>"0" AND l_imzicd04<>"1")  #母體料號  #FUN-C30278
         CALL cl_err(p_value,"aic-100",1)
      WHEN (p_feld="imzicd02") AND (l_imzicd05<>"2")  #外編母體 (預測料號)
         CALL cl_err(p_value,"aic-101",1)
      WHEN (p_feld="imzicd03") AND (l_imzicd05<>"4")  #外編子體 (客戶下單料號)
         CALL cl_err(p_value,"aic-102",1)
      WHEN (p_feld="imzicd06") AND (NOT l_imzicd04 MATCHES '[12]')  #內編子體 (Wafer料號)
         CALL cl_err(p_value,"aic-103",1)
      OTHERWISE
         RETURN TRUE
   END CASE
   RETURN FALSE
END FUNCTION

#當料件特性='5',帶入相關預設值
FUNCTION i110_ind_icd_set_default(p_imzicd05,p_imzicd01)
   DEFINE p_imzicd01 LIKE imz_file.imzicd01
   DEFINE p_imzicd05 LIKE imz_file.imzicd05
   DEFINE l_imzicd02 LIKE imz_file.imzicd02
   DEFINE l_imzicd03 LIKE imz_file.imzicd03
   DEFINE l_imzicd04 LIKE imz_file.imzicd04
   DEFINE l_imzicd06 LIKE imz_file.imzicd06
   DEFINE l_imzicd10 LIKE imz_file.imzicd10

   IF cl_null(p_imzicd01) OR cl_null(p_imzicd05) THEN
      RETURN
   END IF

   CASE p_imzicd05
      WHEN "5"
         SELECT imzicd02,imzicd03,imzicd04,imzicd06,imzicd10
           INTO l_imzicd02,l_imzicd03,l_imzicd04,l_imzicd06,l_imzicd10
           FROM imz_file,ima_file
          WHERE ima01=p_imzicd01
            AND imz01=ima06
         IF cl_null(g_imz.imzicd02) THEN
            LET g_imz.imzicd02 = l_imzicd02
         END IF
         IF cl_null(g_imz.imzicd03) THEN
            LET g_imz.imzicd03 = l_imzicd03
         END IF
         IF cl_null(g_imz.imzicd04) THEN
            LET g_imz.imzicd04 = l_imzicd04
         END IF
         #IF cl_null(g_imz.imzicd05) THEN  #FUN-C30278
         IF cl_null(g_imz.imzicd06) THEN#FUN-C30278
            LET g_imz.imzicd06 = l_imzicd06
         END IF
         IF cl_null(g_imz.imzicd10) THEN
            LET g_imz.imzicd10 = l_imzicd10
         END IF
         DISPLAY BY NAME g_imz.imzicd02,g_imz.imzicd03,
                         g_imz.imzicd04,g_imz.imzicd06,
                         g_imz.imzicd10
      WHEN "6" #6.原物料 沒有作業群組
         LET l_imzicd10 = NULL
         DISPLAY BY NAME l_imzicd10
      OTHERWISE
         IF cl_null(g_imz.imzicd10) THEN
            SELECT imzicd10 INTO g_imz.imzicd10 FROM imz_file,ima_file
                                           WHERE ima01=p_imzicd01
                                             AND imz01=ima06
            DISPLAY BY NAME g_imz.imzicd10
         END IF
   END CASE
END FUNCTION

FUNCTION i110_ind_icd_chk_imzicd10(p_imzicd10)
  DEFINE p_imzicd10 LIKE imz_file.imzicd10
  DEFINE l_icd01    LIKE icd_file.icd01
  DEFINE l_icd02    LIKE icd_file.icd02
  DEFINE l_icdacti  LIKE icd_file.icdacti

  IF cl_null(p_imzicd10) THEN
     RETURN TRUE
  END IF
  SELECT icd01,icd02,icdacti
    INTO l_icd01,l_icd02,l_icdacti
    FROM icd_file
   WHERE icd01=p_imzicd10
     AND icd02='U'        #No.TQC-910034 add
  CASE
     WHEN SQLCA.sqlcode<>0
        CALL cl_err3("sel","icd_file",p_imzicd10,"",100,"","",1)
     WHEN cl_null(l_icdacti) OR l_icdacti<>'Y'
        CALL cl_err3("sel","icd_file",p_imzicd10,"","apm-800","","",1)
     WHEN cl_null(l_icd02) OR l_icd02<>'U'
        CALL cl_err3("sel","icd_file",p_imzicd10,"","aic-317","","",1)
     OTHERWISE
       RETURN TRUE
  END CASE
  RETURN FALSE
END FUNCTION


FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imz01",TRUE)
   END IF
 
   IF INFIELD(imz37) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imz38,imz99",TRUE)
   END IF
 
    IF INFIELD(imz15) OR (NOT g_before_input_done) THEN    #No.MOD-480499
      CALL cl_set_comp_entry("imz19,imz21,imz106",TRUE)
   END IF
 
   IF (NOT g_before_input_done) THEN                      #FUN-540025
      CALL cl_set_comp_entry("imz906,imz907,imz908",TRUE)
   END IF
 
   IF INFIELD(imz906) OR (NOT g_before_input_done) THEN   #FUN-540025
      CALL cl_set_comp_entry("imz907",TRUE)
   END IF
   #FUN-B30192--add--begin
   IF g_imz.imzicd04 = '0' OR g_imz.imzicd04 = '1' OR g_imz.imzicd04 = '2' THEN  #FUN-C30278
      CALL cl_set_comp_entry("imzicd14",TRUE)
   END IF   
   #FUN-B30192--add--end
   CALL cl_set_comp_entry("imzicd17,imzicd18,imzicd19,imzicd20,imzicd21",TRUE)   #FUN-BC0103
   CALL cl_set_comp_entry("imz918,imz919,imz920,imz921",TRUE)   #FUN-A10004 ---ADD
   #MOD-C30091---begin
   #CALL cl_set_comp_entry("imz922,imz923,imz924,imz925",TRUE)   #FUN-A10004 ---ADD
   CALL cl_set_comp_entry("imz922,imz923,imz924",TRUE)
   IF g_imz.imz918 = 'Y' OR g_imz.imz921 = 'Y' THEN 
      CALL cl_set_comp_entry("imz925",TRUE)  
   ELSE
      CALL cl_set_comp_entry("imz925",FALSE) 
   END IF 
   #MOD-C30091---end
  #MOD-AB0209---mark---start--- 
  #IF s_industry('icd') THEN
  #   CALL cl_set_comp_entry("imzicd08",TRUE)  
  #END IF
  #MOD-AB0209---mark---end---
  #FUN-A80150---add---start---
   IF g_imz.imz156 = 'Y' THEN
      CALL cl_set_comp_entry("imz157",TRUE)
   END IF
  #FUN-A80150---add---end---
 
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("imz01",FALSE)
   END IF
 
   IF g_sma.sma12 MATCHES '[nN]' AND (g_before_input_done) THEN
     #CALL cl_set_comp_entry("imz36,imz27,imz28,imz71,imz25,imz17,imz19,imz21,imz106,imz903",FALSE)   #CHI-B80083 mark
      CALL cl_set_comp_entry("imz36,imz27,imz28,imz71,imz25,imz19,imz21,imz106,imz903",FALSE)         #CHI-B80083
   END IF
 
   IF INFIELD(imz37) OR (NOT g_before_input_done) THEN
      IF g_imz.imz37 != '0' THEN
         CALL cl_set_comp_entry("imz38,imz99",FALSE)
      END IF
   END IF
 
    IF INFIELD(imz15) OR (NOT g_before_input_done) THEN    #No.MOD-480499
      IF g_imz.imz15="N" THEN
         CALL cl_set_comp_entry("imz19,imz21,imz106",FALSE)
      END IF
   END IF
 
    IF NOT g_before_input_done THEN
       IF g_sma.sma115 = 'N' THEN
          LET g_imz.imz906 = '1'
          LET g_imz.imz907 = NULL
          DISPLAY BY NAME g_imz.imz906,g_imz.imz907
          CALL cl_set_comp_entry("imz906,imz907",FALSE)
       ELSE
          IF cl_null(g_imz.imz907) THEN
             LET g_imz.imz907 = g_imz.imz25
             DISPLAY BY NAME g_imz.imz907
          END IF
       END IF
       IF g_sma.sma116 = '0' THEN   #No.FUN-610076
          LET g_imz.imz908 = NULL
          DISPLAY BY NAME g_imz.imz908
          CALL cl_set_comp_entry("imz908",FALSE)
       ELSE
          IF cl_null(g_imz.imz908) THEN
             LET g_imz.imz908 = g_imz.imz25
             DISPLAY BY NAME g_imz.imz908
          END IF
       END IF
    END IF
    IF g_imz.imz906 = '1' THEN
       LET g_imz.imz907 = NULL
       DISPLAY BY NAME g_imz.imz907
       CALL cl_set_comp_entry("imz907",FALSE)
    END IF

#FUN-A10004 ---ADD BEGIN
#   SELECT COUNT(*) INTO l_n FROM imgs_file
#    WHERE imgs01 = g_ima.ima01
#   IF l_n > 0 THEN
#      CALL cl_set_comp_entry("ima918,ima919,ima920,ima921",FALSE)
#      CALL cl_set_comp_entry("ima922,ima923,ima924,ima925",FALSE)
#   END IF
   #FUN-B30192--add--begin 
   IF g_imz.imzicd04 <> '0' AND g_imz.imzicd04 <> '1' AND g_imz.imzicd04 <> '2' THEN  #FUN-C30278
      CALL cl_set_comp_entry("imzicd14",FALSE)
      LET g_imz.imzicd14 = 0
   END IF   
   #FUN-B30192--add--end
   #FUN-BC0103 --START--
   IF g_imz.imzicd04 <> '3' THEN         
     CALL cl_set_comp_entry("imzicd17",FALSE) 
   END IF 
   IF g_imz.imzicd17 <> '2' THEN         
     CALL cl_set_comp_entry("imzicd18,imzicd19,imzicd20,imzicd21",FALSE) 
   END IF 
   #FUN-BC0103 --END--
   IF g_imz.imz918 = 'N' THEN
      CALL cl_set_comp_entry("imz919",FALSE)
   ELSE                                      #MOD-A50099 add
      CALL cl_set_comp_entry("imz919",TRUE)  #MOD-A50099 add
   END IF

   IF g_imz.imz919 = 'N' THEN
      CALL cl_set_comp_entry("imz920",FALSE)
   ELSE                                      #MOD-A50099 add
      CALL cl_set_comp_entry("imz920",TRUE)  #MOD-A50099 add
   END IF

   IF g_imz.imz921 = 'N' THEN
      CALL cl_set_comp_entry("imz922,imz924",FALSE)
   ELSE                                             #MOD-A50099 add
      CALL cl_set_comp_entry("imz922,imz924",TRUE)  #MOD-A50099 add
   END IF

   IF g_imz.imz922 = 'N' THEN
      CALL cl_set_comp_entry("imz923",FALSE)
   ELSE                                      #MOD-A50099 add
      CALL cl_set_comp_entry("imz923",TRUE)  #MOD-A50099 add
   END IF

   IF g_imz.imz918 = 'N' AND g_imz.imz921 = 'N' THEN
      CALL cl_set_comp_entry("imz925",FALSE)
   ELSE                                      #MOD-A50099 add
      CALL cl_set_comp_entry("imz925",TRUE)  #MOD-A50099 add
   END IF
#FUN-A10004 ---ADD END
  #MOD-AB0209---mark---start--- 
  ##因為s_icdpost設定 當imaicd04 = 3 或4時，強制要求必須走"刻號/BIN管理"
  #IF s_industry('icd') THEN
  #   IF g_imz.imzicd04 MATCHES '[34]' THEN
  #      CALL cl_set_comp_entry("imzicd08",FALSE)
  #   END IF  
  #END IF
  #MOD-AB0209---mark---end---
  #FUN-A80150---add---start---
   IF g_imz.imz156 = 'N' THEN
      CALL cl_set_comp_entry("imz157",FALSE)
   ELSE
      CALL cl_set_comp_entry("imz157",TRUE)
   END IF
  #FUN-A80150---add---end---
END FUNCTION
 
FUNCTION i110_set_required()
 
  IF g_sma.sma115= 'Y' THEN
     CALL cl_set_comp_required("imz907",TRUE)
  END IF
 
  IF g_sma.sma116 MATCHES '[123]' THEN   #No.FUN-610076
     CALL cl_set_comp_required("imz908",TRUE)
  END IF

#FUN-A10004 ---ADD BEGIN
   IF g_imz.imz919 = "Y" THEN
      CALL cl_set_comp_required("imz920",TRUE)
   END IF

   IF g_imz.imz922 = "Y" THEN
      CALL cl_set_comp_required("imz923",TRUE)
   END IF
#FUN-A10004 ---ADD END 
END FUNCTION
 
FUNCTION i110_set_no_required()
 
  CALL cl_set_comp_required("imz907",FALSE)
  CALL cl_set_comp_required("imz908",FALSE)

  CALL cl_set_comp_required("imz920,imz923",FALSE)   #FUN-A10004 ---ADD 
END FUNCTION
 
FUNCTION aimi110_azf01(p_key,p_key2,p_cmd)    #類別
    DEFINE p_key     LIKE azf_file.azf01,
           p_cmd     LIKE type_file.chr1,
           p_key2    LIKE azf_file.azf02,
           l_azf03   LIKE azf_file.azf03,
           l_azfacti LIKE azf_file.azfacti
 
    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_azf03=NULL
        LET g_chr = 'E'
    ELSE SELECT azf03,azfacti INTO l_azf03,l_azfacti
           FROM azf_file
               WHERE azf01 = p_key
                 AND azf02 = p_key2
            IF SQLCA.sqlcode THEN
                LET g_chr = 'E'
                LET l_azf03 = NULL
            ELSE
                IF l_azfacti matches'[Nn]' THEN
                    LET g_chr = 'E'
                END IF
            END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd' THEN
       CASE  p_key2
          WHEN "8"
                DISPLAY l_azf03 TO azf03
          WHEN "D"
                DISPLAY l_azf03 TO azf03_1
          WHEN "E"
                DISPLAY l_azf03 TO azf03_2
          WHEN "F"
                DISPLAY l_azf03 TO azf03_3
          OTHERWISE 
       END CASE
  END IF
END FUNCTION
 
FUNCTION aimi110_peo(p_key,p_cmd)    #人員
    DEFINE p_key     LIKE gen_file.gen01,
           p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_chr = ' '
    IF p_key IS NULL THEN
        LET l_gen02=NULL
        LET g_chr = 'E'
    ELSE SELECT gen02,genacti INTO l_gen02,l_genacti
           FROM gen_file
               WHERE gen01 = p_key
            IF SQLCA.sqlcode THEN
                LET g_chr = 'E'
                LET l_gen02 = NULL
            ELSE
                IF l_genacti matches'[Nn]' THEN
                    LET g_chr = 'E'
                END IF
            END IF
    END IF
    IF g_chr = ' ' OR p_cmd = 'd'
       THEN DISPLAY l_gen02 TO gen02
  END IF
END FUNCTION
 
FUNCTION aimi110_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL aimi110_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN aimi110_count
    FETCH aimi110_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN aimi110_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        INITIALIZE g_imz.* TO NULL
    ELSE
        CALL aimi110_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION aimi110_fetch(p_flimz)
    DEFINE
        p_flimz         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_abso          LIKE type_file.num10    #No.FUN-690026 INTEGER
 
    CASE p_flimz
        WHEN 'N' FETCH NEXT     aimi110_curs INTO g_imz.imz01
        WHEN 'P' FETCH PREVIOUS aimi110_curs INTO g_imz.imz01
        WHEN 'F' FETCH FIRST    aimi110_curs INTO g_imz.imz01
        WHEN 'L' FETCH LAST     aimi110_curs INTO g_imz.imz01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
                  PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
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
            FETCH ABSOLUTE g_jump aimi110_curs INTO g_imz.imz01 --改g_jump
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        INITIALIZE g_imz.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flimz
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_imz.* FROM imz_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imz01 = g_imz.imz01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","imz_file",g_imz.imz01,"",
                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_imz.imzuser #FUN-4C0053
        LET g_data_group = g_imz.imzgrup #FUN-4C0053
        CALL aimi110_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi110_show()
    DEFINE l_imd02 LIKE imd_file.imd02
    LET g_imz_t.* = g_imz.*
    DISPLAY BY NAME g_imz.imzoriu,g_imz.imzorig,
        g_imz.imz01, g_imz.imz02, g_imz.imz03, g_imz.imz72, g_imz.imz04, #FUN-710060 add imz72
        g_imz.imz07, g_imz.imz08, g_imz.imz24, g_imz.imz14, g_imz.imz15, #No:7703 add imz24
        g_imz.imz70, g_imz.imz105,g_imz.imz107,g_imz.imz147,
        g_imz.imz109,g_imz.imz37, g_imz.imz38, g_imz.imz99,
        g_imz.imz39, g_imz.imz391,g_imz.imz163,g_imz.imz1631,            #FUN-680034 加imz391 #FUN-C80094 add--imz163,imz1631
        g_imz.imz73, g_imz.imz731,g_imz.imz09, g_imz.imz10, g_imz.imz11, #FUN-960141 加imz73,imz731
        g_imz.imz12, g_imz.imz23, g_imz.imz35, g_imz.imz36,
        g_imz.imz27, g_imz.imz28, g_imz.imz71, g_imz.imz25,
       #g_imz.imz17, g_imz.imz19, g_imz.imz21, g_imz.imz903, g_imz.imz911,   #FUN-610080 加imz911   #CHI-B80083 mark
        g_imz.imz19, g_imz.imz21, g_imz.imz903, g_imz.imz911,                #CHI-B80083
        g_imz.imz918,g_imz.imz919,g_imz.imz920,g_imz.imz921,                 #FUN-A10004 --ADD
        g_imz.imz922,g_imz.imz923,g_imz.imz924,g_imz.imz925,                 #FUN-A10004 --ADD
        g_imz.imz928,g_imz.imz929,
        g_imz.imz906,g_imz.imz907,g_imz.imz908,g_imz.imz909, #FUN-540025
     #  g_imz.imzicd01,g_imz.imzicd02,g_imz.imzicd03,g_imz.imzicd04,  #FUN-980063  #FUN-B30192
     #  g_imz.imzicd05,g_imz.imzicd06,g_imz.imzicd08,g_imz.imzicd09,g_imz.imzicd13,  #FUN-980063 #CHI-A60014 add imzicd13#FUN-B30192
     #  g_imz.imzicd10,g_imz.imzicd12,g_imz.imzicd79,                 #FUN-980063 #FUN-B30192
        g_imz.imzicd01,g_imz.imzicd16,g_imz.imzicd04,                                #FUN-B30192
        #g_imz.imzicd05,g_imz.imzicd08,g_imz.imzicd09,g_imz.imzicd13,                 #FUN-B30192  #MOD-C30206 mark
        g_imz.imzicd05,g_imz.imzicd08,g_imz.imzicd09,                                #FUN-B50096 mark imzicd13   
        g_imz.imzicd10,g_imz.imzicd12,g_imz.imzicd14,g_imz.imzicd15,g_imz.imzicd17,g_imz.imzicd79,  #FUN-B30192 #FUN-BC0103 add imzicd17
        g_imz.imzicd18,g_imz.imzicd19,g_imz.imzicd20,g_imz.imzicd21,   #FUN-BC0103
        g_imz.imz106, g_imz.imzuser, g_imz.imzgrup, g_imz.imzmodu,
        g_imz.imzdate, g_imz.imzacti,
        g_imz.imzud01,g_imz.imzud02,g_imz.imzud03,g_imz.imzud04,
        g_imz.imzud05,g_imz.imzud06,g_imz.imzud07,g_imz.imzud08,
        g_imz.imzud09,g_imz.imzud10,g_imz.imzud11,g_imz.imzud12,
        g_imz.imzud13,g_imz.imzud14,g_imz.imzud15,
        g_imz.imz156,g_imz.imz157,g_imz.imz158,                     #FUN-A80150 add
        g_imz.imz022,g_imz.imz251,g_imz.imz159                      #FUN-B30092 add    #FUN-B50096 add imz159
        #FUN-C30023---begin
        IF cl_null(g_imz.imz35) THEN
           LET l_imd02 = NULL 
           DISPLAY l_imd02 TO imd02
        ELSE
           SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = g_imz.imz35
           DISPLAY l_imd02 TO imd02
        END IF 
        #FUN-C30023---end
    CALL aimi110_azf01(g_imz.imz109,'8','d')
    CALL aimi110_azf01(g_imz.imz09,'D','d')
    CALL aimi110_azf01(g_imz.imz10,'E','d')
    CALL aimi110_azf01(g_imz.imz11,'F','d')
    CALL aimi110_azf01(g_imz.imz12,'G','d')
    CALL aimi110_peo(g_imz.imz23,'d')
    CALL cl_set_field_pic("","","","","",g_imz.imzacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi110_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_imz.* FROM imz_file WHERE imz01=g_imz.imz01
    IF g_imz.imzacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imz.imz01,'mfg1000',0)
        RETURN
    END IF
#TQC-B90236---add---begin---
    IF g_imz.imz928='Y' THEN
       CALL cl_set_comp_entry('imz929',FALSE)
    ELSE
       CALL cl_set_comp_entry('imz929',TRUE)
    END IF
#TQC-B90236---add---end-----
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imz01_t = g_imz.imz01
    LET g_imz_o.* = g_imz.*
    LET g_imz906  = g_imz.imz906 #FUN-540025
    LET g_imz907  = g_imz.imz907 #FUN-540025
    LET g_imz908  = g_imz.imz908 #FUN-540025
    BEGIN WORK
    OPEN aimi110_curl USING g_imz.imz01
    FETCH aimi110_curl INTO g_imz.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_imz.imzmodu=g_user                     #修改者
    LET g_imz.imzdate = g_today                  #修改日期
 
    CALL aimi110_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi110_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imz_t.imzdate=g_imz_o.imzdate        #TQC-C40219
            LET g_imz_t.imzmodu=g_imz_o.imzmodu        #TQC-C40219
            LET g_imz.*=g_imz_t.*     #TQC-C40155 #TQC-C40219
           #LET g_imz.*=g_imz_o.*     #TQC-C40155 #TQC-C40219
            CALL aimi110_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
{&}     IF g_imz.imz35 IS NULL THEN LET g_imz.imz35 = ' ' END IF
        IF g_imz.imz36 IS NULL THEN LET g_imz.imz36 = ' ' END IF
        UPDATE imz_file SET imz_file.* = g_imz.*    # 更新DB
            WHERE imz01 = g_imz01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","imz_file",g_imz_t.imz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE aimi110_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION aimi110_x()
    DEFINE
        l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN aimi110_curl USING g_imz.imz01
    FETCH aimi110_curl INTO g_imz.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL aimi110_show()
    SELECT ima06 FROM ima_file WHERE ima06=g_imz.imz01
                                 AND imaacti IN ('Y','y')
    IF STATUS =0 OR STATUS=-284
       THEN # CALL cl_err(g_imz.imz01,'mfg9045',0)       #No.FUN-660156
              CALL cl_err3("sel","ima_file",g_imz.imz01,"","mfg9045","","",1)  #No.FUN-660156
            RETURN
    END IF
    IF cl_exp(0,0,g_imz.imzacti) THEN
        LET g_chr=g_imz.imzacti
        IF g_imz.imzacti='Y' THEN
            LET g_imz.imzacti='N'
        ELSE
            LET g_imz.imzacti='Y'
        END IF
        UPDATE imz_file
            SET imzacti=g_imz.imzacti,
                imzmodu=g_user, imzdate=g_today
            WHERE imz01=g_imz.imz01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           LET g_imz.imzacti=g_chr
        END IF
        DISPLAY BY NAME g_imz.imzacti
    END IF
    CLOSE aimi110_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION aimi110_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN aimi110_curl USING g_imz.imz01
    FETCH aimi110_curl INTO g_imz.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0) RETURN END IF
    CALL aimi110_show()
    SELECT ima06 FROM ima_file WHERE ima06=g_imz.imz01
                                 AND imaacti IN ('Y','y')
    IF STATUS =0 OR STATUS =-284
       THEN # CALL cl_err(g_imz.imz01,'mfg9045',0)  #No.FUN-660156
              CALL cl_err3("sel","ima_file",g_imz.imz01,"","mfg9045","","",1)  #No.FUN-660156
            RETURN
    END IF
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imz01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imz.imz01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM imz_file WHERE imz01 = g_imz.imz01
        IF SQLCA.SQLERRD[3]=0
           THEN # CALL cl_err(g_imz.imz01,SQLCA.sqlcode,0)  #No.FUN-660156
                  CALL cl_err3("del","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           ELSE CLEAR FORM
        END IF
#No.TQC-B90236 ----------------- add start ----------------
        DELETE FROM imzc_file WHERE imzc01 = g_imz_t.imz01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","imzc_file",g_imzc.imzc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
        ELSE 
           CLEAR FORM
        END IF
#No.TQC-B90236 ----------------- add end ------------------
    END IF
         OPEN aimi110_count
         #TQC-C50127--mark--str--
         ##FUN-B40096 add
         #IF STATUS THEN
         #   CLOSE aimi110_count
         #   RETURN
         #END IF
         ##FUN-B40096 add--end
         #TQC-C50127--mark--end--
         FETCH aimi110_count INTO g_row_count
         #TQC-C50127--mark--str--
         ##FUN-B40096 add
         #IF STATUS THEN
         #   CLOSE aimi110_count
         #   RETURN
         #END IF
         ##FUN-B40096 add--end
         #TQC-C50127--mark--end--
         DISPLAY g_row_count TO FORMONLY.cnt
         MESSAGE 'DELETE O.K'     #TQC-C40043  add
         OPEN aimi110_curs
         #TQC-C40043--mark--str--
         #IF g_curs_index = g_row_count + 1 THEN
         #   LET g_jump = g_row_count
         #   CALL aimi110_fetch('L')
         #ELSE
         #   LET g_jump = g_curs_index
         #   LET mi_no_ask = TRUE
         #   CALL aimi110_fetch('/')
         #END IF
         #TQC-C40043--mark--end--
         #TQC-C40043--add--str--
         IF g_row_count >= 1 THEN
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
            ELSE
               LET g_jump = g_curs_index
            END IF
            LET mi_no_ask = TRUE
            CALL aimi110_fetch('/')
         ELSE
            INITIALIZE g_imz.* TO NULL    #TQC-C40231 add
         END IF
         #TQC-C40043--add--end--
    CLOSE aimi110_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION aimi110_copy()
    DEFINE
        l_imz           RECORD LIKE imz_file.*,
        l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_newno,l_oldno LIKE imz_file.imz01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imz.imz01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

#FUN-B30092 --begin--
    IF cl_null(g_imz.imz022) THEN
       LET g_imz.imz022 = 0
    END IF
#FUN-B30092 --end--
 
    LET g_before_input_done = FALSE
    CALL i110_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM imz01
        AFTER FIELD imz01
            IF l_newno IS NULL OR l_newno = ' '  THEN
                NEXT FIELD imz01
            END IF
            SELECT count(*) INTO g_cnt FROM imz_file
                WHERE imz01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD imz01
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
        DISPLAY BY NAME g_imz.imz01
        RETURN
    END IF
    LET l_imz.* = g_imz.*
    LET l_imz.imz01  =l_newno   #資料鍵值
    LET l_imz.imzuser=g_user    #資料所有者
    LET l_imz.imzgrup=g_grup    #資料所有者所屬群
    LET l_imz.imzmodu=NULL      #資料修改日期
    LET l_imz.imzdate=g_today   #資料建立日期
    LET l_imz.imzacti='Y'       #有效資料
    IF l_imz.imz35 IS NULL THEN LET l_imz.imz35 = ' ' END IF
    IF l_imz.imz36 IS NULL THEN LET l_imz.imz36 = ' ' END IF
    LET l_imz.imz86=l_imz.imz25
    IF cl_null(l_imz.imz150) THEN LET l_imz.imz150 = '0' END IF
    IF cl_null(l_imz.imz152) THEN LET l_imz.imz152 = '0' END IF
    IF cl_null(g_imz.imz601) THEN LET g_imz.imz601 = 1 END IF   #MOD-A50111 add
    LET l_imz.imzoriu = g_user      #No.FUN-980030 10/01/04
    LET l_imz.imzorig = g_grup      #No.FUN-980030 10/01/04
    IF cl_null(l_imz.imz156) THEN LET l_imz.imz156 ='N' END IF  #FUN-A80102
    IF cl_null(l_imz.imz157) THEN LET l_imz.imz157 =' ' END IF  #FUN-A80102
    IF cl_null(l_imz.imz158) THEN LET l_imz.imz158 ='N' END IF  #FUN-A80102
    IF cl_null(g_imz.imz022) THEN LET g_imz.imz022 =0   END IF  #FUN-B30192
   #FUN-B50106 ------------Begin-----------------
    IF cl_null(g_imz.imzicd14) THEN LET g_imz.imzicd14 = 0 END IF
    IF cl_null(g_imz.imzicd15) THEN LET g_imz.imzicd15 = 0 END IF
   #FUN-B50106 ------------End-------------------
    INSERT INTO imz_file VALUES (l_imz.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","imz_file",g_imz.imz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        #TQC-C40044--add--str--
        DROP TABLE y
        SELECT * FROM imzc_file WHERE  imzc01 = g_imz.imz01 INTO TEMP y
        UPDATE y
           SET imzc01 = l_newno,
               imzcuser=g_user,    #資料所有者
               imzcgrup=g_grup,    #資料所有者所屬群
               imzcorig=g_grup,
               imzcoriu=g_user
        INSERT INTO imzc_file SELECT * FROM y
        IF SQLCA.sqlcode THEN
           CALL cl_err(l_newno,SQLCA.sqlcode,0)
        END IF
        #TQC-C40044--add--end--
        LET l_oldno = g_imz.imz01
        SELECT imz_file.* INTO g_imz.* FROM imz_file
                       WHERE imz01 = l_newno
        CALL aimi110_u()
        #SELECT imz_file.* INTO g_imz.* FROM imz_file  #FUN-C30027
        #               WHERE imz01 = l_oldno          #FUN-C30027
    END IF
    CALL aimi110_show()
END FUNCTION
 
FUNCTION aimi110_out()
   DEFINE  l_cmd          LIKE type_file.chr1000  #NO.FUN-810099
   IF cl_null(g_wc) AND NOT cl_null(g_imz.imz01) THEN                                                                               
      LET g_wc=" imz01='",g_imz.imz01,"'"                                                                                           
   END IF                                                                                                                           
   IF g_wc IS NULL THEN                                                                                                             
      CALL cl_err('','9057',0) RETURN                                                                                               
   END IF 
   LET l_cmd = 'p_query "aimi110" "',g_wc CLIPPED,'"'                                                                               
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN
END FUNCTION

FUNCTION i110_mu_ui()
   CALL cl_set_comp_visible("imz906",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("imz907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("imz908",g_sma.sma116 MATCHES '[123]')  #No.FUN-610076
   CALL cl_set_comp_visible("group044",g_sma.sma116 MATCHES '[123]' OR g_sma.sma115='Y')  #No.FUN-610076
   CALL cl_set_comp_visible("imz391",g_aza.aza63='Y')     #FUN-680034                                
   CALL cl_set_comp_visible("page13",g_sma.sma124!='icd')   #MOD-B30155 add 
   
   IF g_azw.azw04 = '2' THEN
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_visible("imz73,imz731",TRUE)
      ELSE
         CALL cl_set_comp_visible("imz73",TRUE)
         CALL cl_set_comp_visible("imz731",FALSE)
      END IF
   ELSE
      CALL cl_set_comp_visible("imz73,imz731",FALSE)
   END IF
   IF g_sma.sma122='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("imz907",g_msg CLIPPED)
   END IF
   
   IF g_sma.sma122='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("imz907",g_msg CLIPPED)
   END IF
   IF NOT s_industry('icd') THEN
      CALL cl_set_comp_visible("page17,page18,imzicd17",FALSE)   #FUN-BC0103 add page18,imzicd17      
   END IF

  #FUN-A80150---add---start---
   IF g_sma.sma1421 = 'Y' THEN
      CALL cl_set_comp_visible("machine_management",TRUE)
   ELSE
      CALL cl_set_comp_visible("machine_management",FALSE)
   END IF
  #FUN-A80150---add---end---
  #FUN-C60046---begin
  IF g_sma.sma94 = 'Y' THEN
     CALL cl_set_comp_visible("imz928,imz929,Group2",TRUE)
     CALL cl_set_act_visible("feature_maintain",TRUE)
  ELSE 
     CALL cl_set_comp_visible("imz928,imz929,Group2",FALSE)
     CALL cl_set_act_visible("feature_maintain",FALSE)
  END IF 
  #FUN-C60046---end
END FUNCTION
#No.FUN-9C0072 精簡程式碼
#FUN-BB0083---add---str
FUNCTION i100_imz38_check()
#imz38 的單位 imz25  

   IF NOT cl_null(g_imz.imz25) AND NOT cl_null(g_imz.imz38) THEN
      IF cl_null(g_imz_t.imz38) OR cl_null(g_imz25_t) OR g_imz_t.imz38 != g_imz.imz38 OR g_imz25_t != g_imz.imz25 THEN 
         LET g_imz.imz38=s_digqty(g_imz.imz38,g_imz.imz25)
         DISPLAY BY NAME g_imz.imz38  
      END IF  
   END IF
   IF NOT cl_null(g_imz.imz38) AND g_imz.imz38 < 0 THEN
            CALL cl_err(g_imz.imz38,'mfg0013',0)
            LET g_imz.imz38 = g_imz_o.imz38
            DISPLAY BY NAME g_imz.imz38
            RETURN FALSE
         END IF
         LET g_imz_o.imz38 = g_imz.imz38
RETURN TRUE 
END FUNCTION
#FUN-BB0083---add---end

