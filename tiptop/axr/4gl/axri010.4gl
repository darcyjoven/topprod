# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axri010.4gl
# Descriptions...: 應收系統單據性質維護作業
# Date & Author..: 95/01/07 By Danny
# Modify.........: 04/08/06 By ching MOD-480185 檢查權限時,g_action_choice未給值
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-4C0087 04/12/15 By DAY   UPDATE中加上ooy10,ooy11
# Modify.........: No.FUN-4C0100 05/02/22 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-540040 05/04/20 By Nicola 新增"需簽核"欄位
# Modify.........: No.FUN-560060 05/06/17 By DAY   單據編號修改
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-590100 05/08/02 By elva 大陸版新增紅衝功能
# Modify.........: No.FUN-580128 05/08/24 By Smapmin "應簽核" & "自動確認" 應為互斥的選項
# Modify.........: NO.FUN-5C0095 06/01/13 By Rosayu 增加有效碼功能
# Modify.........: No.FUN-640246 06/05/02 By Echo 取消"立即確認"與"應簽核"欄位為互斥的選項
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP)
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670060 06/07/17 By Hellen 在欄位"拋轉憑証"后增加"系統是否直接拋轉總帳"以及"總帳單別"兩個欄位
# Modify.........: No.FUN-670060 06/07/18 By Hellen zaa_file是從34區拷貝過來的
# Modify.........: No.FUN-670060 06/08/01 By wujie  直接拋總帳單別開窗修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei欄位類型轉換
# Modify.........: No.FUN-680088 06/08/31 By Ray 新增自動拋轉總帳第二單別
# Modify.........: No.FUN-6A0095 06/10/27 By xumin l_time 轉g_time
# Modify.........: No.FUN-690090 06/10/16 By atsea 增加 是否自動產生內部銀行賬戶資料 欄位
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-770015 07/07/02 By Rayven  發票限額沒有控管，可以輸入負數
# Modify.........: No.TQC-790101 07/09/17 By Judy 報表中無"有效碼"
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
# Modify.........: No.MOD-880085 08/08/13 By Sarah 總帳第二單別(ooygslp1)欄位,請依多帳別時才需要開啟
# Modify.........: No.TQC-930046 09/03/11 By mike 沒有cn3欄位
# Modify.........: No.FUN-8B0019 09/03/07 By lilingyu ooyconf,ooydmy1,ooyglcr,ooygslp四個欄位的卡關重新調整
# Modify.........: No.FUN-960141 09/06/22 By dongbg GP5.2修改:增加單據性質:15,16,17,18,26,27
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960140 09/09/07 By lutingting增加單據性質:32 退款單
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No.TQC-A30128 10/03/24 By lilingyu "發票限額否"為'Y',應控管ooy11不可以是0,為'N'時,應控管ooy11不可以錄入
# Modify.........: No:TQC-A30139 10/03/26 By Carrier 抛转凭证='N'时,红冲字段no_entry
# Modify.........: No:CHI-9C0010 10/11/25 By Summer 當ooytype=31時,不可勾選ooydmy1、ooyglcr、ooydmy2
# Modify.........: No:CHI-B30042 11/03/30 By huangrh 當aoos010勾選流通參數時,隱藏oma00 屬於下列的屬性15/17/18/26/27
# Modify.........: No:TQC-B40042 11/04/08 By yinhy aza50='N'時，隱藏oma00屬於下列的屬性15/17/18/26/27
# Modify.........: No:TQC-B40172 11/04/20 By yinhy 修正TQC-B40042,應判定azw04<>2
# Modify.........: No:TQC-B60109 11/06/16 By lixiang 增加對總帳單別碼數的控管
# Modify.........: No:TQC-B60111 11/06/16 By lixiang 拋磚憑證不勾選時，總賬單別不放開錄入
# Modify.........: No.FUN-B50039 11/07/07 By xianghui 增加自訂欄位
# Modify.........: No.TQC-BA0167 11/10/27 By lixiang 修正TQC-B60109的錯誤
# Modify.........: No.MOD-BB0040 11/11/04 By Polly 修正apygslp/apygslp1長度的抓取，採用aza102長度為主 
# Modify.........: No.TQC-C20335 12/02/21 By yinhy “需簽核”選項和“立即審核”選項應不可以同時勾選
# Modify.........: No.FUN-C70108 12/07/25 By Abby  開放"需簽核"與"自動確認"選項可同時勾選
# Modify.........: No:MOD-C70278 12/07/30 By Polly 增加控卡，該單別已存在交易時不可修改
# Modify.........: No:MOD-CA0134 12/10/23 By Vampire BEFORE FIELD ooytype 取消 IF p_cmd <> 'u' THEN 判斷
# Modify.........: No.FUN-D10058 13/03/07 By lujh aza69不勾選時，隱藏ooydmy3和35性質的單別
# Modify.........: No.FUN-D10101 13/03/07 By lujh 新增單據性質“50：開立發票”，大陸版且不走開票流程時顯示
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ooy_1         DYNAMIC ARRAY OF RECORD   #No:7887
        ooyslip     LIKE ooy_file.ooyslip,
        ooydesc     LIKE ooy_file.ooydesc,
        ooyauno     LIKE ooy_file.ooyauno,
        #ooykind     LIKE ooy_file.ooykind, #FUN-A10109
        ooydmy1     LIKE ooy_file.ooydmy1,
        ooyglcr     LIKE ooy_file.ooyglcr,    #No.FUN-670060
        ooygslp     LIKE ooy_file.ooygslp,    #No.FUN-670060
        ooygslp1    LIKE ooy_file.ooygslp1,   #No.FUN-680088
        ooyconf     LIKE ooy_file.ooyconf,
        ooyprit     LIKE ooy_file.ooyprit,
        ooyapr      LIKE ooy_file.ooyapr,     #No.FUN-540040
        ooytype     LIKE ooy_file.ooytype,
        ooydmy2     LIKE ooy_file.ooydmy2,    #No.FUN-590100
        ooy10       LIKE ooy_file.ooy10,
        ooy11       LIKE ooy_file.ooy11,      #No.FUN-5C0095
        ooyacti     LIKE ooy_file.ooyacti,    #No.FUN-5C0095
        ooydmy3     LIKE ooy_file.ooydmy3,    #No.FUN-690090
        #FUN-B50039-add-str--
        ooyud01     LIKE ooy_file.ooyud01,
        ooyud02     LIKE ooy_file.ooyud02,
        ooyud03     LIKE ooy_file.ooyud03,
        ooyud04     LIKE ooy_file.ooyud04,
        ooyud05     LIKE ooy_file.ooyud05,
        ooyud06     LIKE ooy_file.ooyud06,
        ooyud07     LIKE ooy_file.ooyud07,
        ooyud08     LIKE ooy_file.ooyud08,
        ooyud09     LIKE ooy_file.ooyud09,
        ooyud10     LIKE ooy_file.ooyud10,
        ooyud11     LIKE ooy_file.ooyud11,
        ooyud12     LIKE ooy_file.ooyud12,
        ooyud13     LIKE ooy_file.ooyud13,
        ooyud14     LIKE ooy_file.ooyud14,
        ooyud15     LIKE ooy_file.ooyud15
        #FUN-B50039-add-end--   
 
                    END RECORD,
    g_buf           LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(40)
    g_ooy_t         RECORD                    #程式變數 (舊值)
        ooyslip     LIKE ooy_file.ooyslip,
        ooydesc     LIKE ooy_file.ooydesc,
        ooyauno     LIKE ooy_file.ooyauno,
        #ooykind     LIKE ooy_file.ooykind, #FUN-A10109
        ooydmy1     LIKE ooy_file.ooydmy1,
        ooyglcr     LIKE ooy_file.ooyglcr,    #No.FUN-670060
        ooygslp     LIKE ooy_file.ooygslp,    #No.FUN-670060
        ooygslp1    LIKE ooy_file.ooygslp1,   #No.FUN-680088
        ooyconf     LIKE ooy_file.ooyconf,
        ooyprit     LIKE ooy_file.ooyprit,
        ooyapr      LIKE ooy_file.ooyapr,     #No.FUN-540040
        ooytype     LIKE ooy_file.ooytype,
        ooydmy2     LIKE ooy_file.ooydmy2,    #No.FUN-590100
        ooy10       LIKE ooy_file.ooy10,
        ooy11       LIKE ooy_file.ooy11,      #No.FUN-5C0095
        ooyacti     LIKE ooy_file.ooyacti,    #No.FUN-5C0095 
        ooydmy3     LIKE ooy_file.ooydmy3,    #No.FUN-690090
        #FUN-B50039-add-str--
        ooyud01     LIKE ooy_file.ooyud01,
        ooyud02     LIKE ooy_file.ooyud02,
        ooyud03     LIKE ooy_file.ooyud03,
        ooyud04     LIKE ooy_file.ooyud04,
        ooyud05     LIKE ooy_file.ooyud05,
        ooyud06     LIKE ooy_file.ooyud06,
        ooyud07     LIKE ooy_file.ooyud07,
        ooyud08     LIKE ooy_file.ooyud08,
        ooyud09     LIKE ooy_file.ooyud09,
        ooyud10     LIKE ooy_file.ooyud10,
        ooyud11     LIKE ooy_file.ooyud11,
        ooyud12     LIKE ooy_file.ooyud12,
        ooyud13     LIKE ooy_file.ooyud13,
        ooyud14     LIKE ooy_file.ooyud14,
        ooyud15     LIKE ooy_file.ooyud15
        #FUN-B50039-add-end--
                    END RECORD,
    g_wc2,g_sql     STRING,                   #No.FUN-580092 HCN 
    g_rec_b         LIKE type_file.num5,      #單身筆數   #No.FUN-680123 SMALLINT
    l_ac            LIKE type_file.num5       #目前處理的ARRAY CNT  #No.FUN-680123 SMALLINT
DEFINE g_forupd_sql STRING                    #SELECT ... FOR UPDATE SQL        
DEFINE g_before_input_done   STRING
DEFINE g_cnt           LIKE type_file.num10    #FUN-680123 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE g_comb           ui.ComboBox    #CHI-B30042
DEFINE g_comb1           ui.ComboBox  
DEFINE g_oaz92         LIKE oaz_file.oaz92  #FUN-D10101  add

MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time            #No.FUN-6A0095
 
   OPEN WINDOW i010_w WITH FORM "axr/42f/axri010"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   #No.FUN-680088 --begin
   IF g_aza.aza63 <> 'Y' THEN
      CALL cl_set_comp_visible("ooygslp1",FALSE)
   END IF
   #No.FUN-680088 --end
 
   #FUN-590100  --begin
   IF g_aza.aza26 != '2' THEN
      CALL cl_set_comp_visible("ooydmy2",FALSE)
      CALL cl_set_comp_visible("ooy10",FALSE)
      CALL cl_set_comp_visible("ooy11",FALSE)
   END IF
   #FUN-590100  --end

   #FUN-D10058--add--str--
   IF g_aza.aza26 = '2' AND g_aza.aza69 = 'N' THEN
      CALL cl_set_comp_visible("ooydmy3",FALSE)
   END IF
   #FUN-D10058--add--end--
   SELECT oaz92 INTO g_oaz92 FROM oaz_file   #FUN-D10101 add 

   LET g_wc2 = '1=1' CALL i010_b_fill(g_wc2)

   CALL i010_menu()
 
   CLOSE WINDOW i010_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-6A0095
END MAIN
 
FUNCTION i010_menu()
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i010_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ooy_1),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i010_q()
   CALL s_getgee('axri010',g_lang,'ooytype') #FUN-A10109
   CALL i010_b_askkey()
END FUNCTION
 
FUNCTION i010_b()
   DEFINE
       l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680123 SMALLINT
       l_n             LIKE type_file.num5,    #檢查重複用         #No.FUN-680123 SMALLINT
       l_lock_sw       LIKE type_file.chr1,    #單身鎖住否         #No.FUN-680123 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,    #FUN-680123 VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,    #No.FUN-680123 VARCHAR(01),
       l_allow_delete  LIKE type_file.chr1     #No.FUN-680123 VARCHAR(01)
   DEFINE l_i          LIKE type_file.num5     #No.FUN-560150      #No.FUN-680123 SMALLINT
   DEFINE g_dbs_gl     STRING                  #No.FUN-670060 
   DEFINE g_plant_gl     STRING                #No.FUN-980059 
   DEFINE l_ooy          STRING,               #No.TQC-B60109
          l_cn         LIKE type_file.num5        #No.TQC-B60109
   DEFINE g_doc_len2   LIKE type_file.num5     #No.MOD-BB0040 add
   DEFINE lc_doc_set   LIKE aza_file.aza41     #No.MOD-BB0040 add
   DEFINE l_sql        STRING                  #MOD-C70278 add
   DEFINE l_len        LIKE type_file.num10    #MOD-C70278 add

    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_ooy_1.clear() END IF
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ooyslip,ooydesc,ooyauno,",
                       #"      ooykind,", #FUN-A10109
                       "       ooydmy1,ooyglcr,ooygslp,ooygslp1,",      #No.FUN-680088
                       "       ooyconf,ooyprit,ooyapr,ooytype,ooydmy2,ooy10,ooy11,ooyacti,ooydmy3,",     #No.FUN-690090 #No.FUN-540040 #FUN-590100#FUN-5C0095 #No.FUN-670060
                       "       ooyud01,ooyud02,ooyud03,ooyud04,ooyud05,ooyud06,ooyud07,ooyud08,",   #FUN-B50039
                       "       ooyud09,ooyud10,ooyud11,ooyud12,ooyud13,ooyud14,ooyud15 ",           #FUN-B50039
                       "  FROM ooy_file WHERE ooyslip = ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_ooy_1 WITHOUT DEFAULTS FROM s_ooy.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
         #---------------------MOD-BB0040------------------------start
          LET lc_doc_set = g_aza.aza102
          CASE lc_doc_set
             WHEN "1"   LET g_doc_len = 3
             WHEN "2"   LET g_doc_len = 4
             WHEN "3"   LET g_doc_len = 5
          END CASE
         #---------------------MOD-BB0040--------------------------end
          #NO.FUN-560150 --start--
         #CALL cl_set_doctype_format("ooyslip")    #MOD-BB0040 移至aza41後
          #NO.FUN-560150 --end--
          CALL cl_set_doctype_format("ooygslp")    #No:TQC-B60109 
          CALL cl_set_doctype_format("ooygslp1")   #No:TQC-B60109
         #---------------------MOD-BB0040------------------------start
          LET lc_doc_set = g_aza.aza41
          CASE lc_doc_set
             WHEN "1"   LET g_doc_len = 3
             WHEN "2"   LET g_doc_len = 4
             WHEN "3"   LET g_doc_len = 5
          END CASE
         #---------------------MOD-BB0040--------------------------end
          CALL cl_set_doctype_format("ooyslip")    #MOD-BB0040 add
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
           #DISPLAY l_ac TO FORMONLY.cn3 #TQC-930046
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET g_ooy_t.* = g_ooy_1[l_ac].*  #BACKUP
               LET p_cmd='u'
#No.FUN-570108 --start--
               LET g_before_input_done = FALSE
               CALL i010_set_entry(p_cmd)
               CALL i010_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570108 --end--
               BEGIN WORK
               OPEN i010_bcl USING g_ooy_t.ooyslip
               IF STATUS THEN
                  CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i010_bcl INTO g_ooy_1[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ooy_t.ooyslip,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET g_before_input_done = FALSE
                  CALL i010_set_entry(p_cmd)
                  CALL i010_set_no_entry(p_cmd)
                  LET g_before_input_done = TRUE
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ooy_1[l_ac].* TO NULL      #900423
            LET g_ooy_t.* = g_ooy_1[l_ac].*         #新輸入資料
            #add by danny 020409  #A013
            LET g_ooy_1[l_ac].ooyauno = 'N'
            LET g_ooy_1[l_ac].ooyconf = 'N'
            LET g_ooy_1[l_ac].ooyprit = 'N'
            LET g_ooy_1[l_ac].ooyapr  = 'N'   #No.FUN-540040
            LET g_ooy_1[l_ac].ooydmy1 = 'N'
            LET g_ooy_1[l_ac].ooyglcr = 'N'   #No.FUN-670060
            LET g_ooy_1[l_ac].ooygslp = NULL  #No.FUN-670060
            LET g_ooy_1[l_ac].ooygslp1= NULL  #No.FUN-680088
            LET g_ooy_1[l_ac].ooydmy2 = 'N'   #FUN-590100
            LET g_ooy_1[l_ac].ooy10 = 'N'
            LET g_ooy_1[l_ac].ooy11 = 0
            LET g_ooy_1[l_ac].ooyacti = 'Y' #FUN-5C0095 add
            LET g_ooy_1[l_ac].ooydmy3 = 'N' #FUN-690090 add
            LET g_before_input_done = FALSE
            CALL i010_set_entry(p_cmd)
            CALL i010_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ooyslip
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_ooy_1[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_ooy_1[l_ac].* TO s_ooy.*
              CALL g_ooy_1.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
         END IF
         INSERT INTO ooy_file(ooyslip,ooydesc,ooyauno,
                              #ooykind, #FUN-A10109 
                              ooyconf,ooyprit,ooyapr,
                              ooydmy1,ooytype,ooyglcr,ooygslp,ooygslp1,ooydmy2,ooy10,ooy11,ooyacti,ooydmy3, #No.FUN-690090 #FUN-590100 #No.FUN-540040 #FUN-5C0095 #No.FUN-670060      #No.FUN-680088
                              ooyud01,ooyud02,ooyud03,ooyud04,ooyud05,ooyud06,ooyud07,ooyud08,   #FUN-B50039
                              ooyud09,ooyud10,ooyud11,ooyud12,ooyud13,ooyud14,ooyud15)           #FUN-B50039
              VALUES(g_ooy_1[l_ac].ooyslip,g_ooy_1[l_ac].ooydesc,g_ooy_1[l_ac].ooyauno,
                     #g_ooy_1[l_ac].ooykind,#FUN-A10109
                     g_ooy_1[l_ac].ooyconf,g_ooy_1[l_ac].ooyprit,
                     g_ooy_1[l_ac].ooyapr,g_ooy_1[l_ac].ooydmy1,g_ooy_1[l_ac].ooytype,   #No.FUN-540040
                     g_ooy_1[l_ac].ooyglcr,g_ooy_1[l_ac].ooygslp,g_ooy_1[l_ac].ooygslp1,                          #No.FUN-670060
                     g_ooy_1[l_ac].ooydmy2,g_ooy_1[l_ac].ooy10,g_ooy_1[l_ac].ooy11,g_ooy_1[l_ac].ooyacti,g_ooy_1[l_ac].ooydmy3, #No.FUN-690090 #FUN-590100 #FUN-5C0095
                     g_ooy_1[l_ac].ooyud01,g_ooy_1[l_ac].ooyud02,g_ooy_1[l_ac].ooyud03,g_ooy_1[l_ac].ooyud04,g_ooy_1[l_ac].ooyud05,       #FUN-B50039
                     g_ooy_1[l_ac].ooyud06,g_ooy_1[l_ac].ooyud07,g_ooy_1[l_ac].ooyud08,g_ooy_1[l_ac].ooyud09,g_ooy_1[l_ac].ooyud10,       #FUN-B50039
                     g_ooy_1[l_ac].ooyud11,g_ooy_1[l_ac].ooyud12,g_ooy_1[l_ac].ooyud13,g_ooy_1[l_ac].ooyud14,g_ooy_1[l_ac].ooyud15)       #FUN-B50039
 
         IF SQLCA.sqlcode THEN
#             CALL cl_err(g_ooy_1[l_ac].ooyslip,SQLCA.sqlcode,0)   #No.FUN-660116
              CALL cl_err3("ins","ooy_file",g_ooy_1[l_ac].ooyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
              CANCEL INSERT
         ELSE
             #FUN-A10109  ===S===
             CALL s_access_doc('a',g_ooy_1[l_ac].ooyauno,g_ooy_1[l_ac].ooytype,
                               g_ooy_1[l_ac].ooyslip,'AXR',g_ooy_1[l_ac].ooyacti)
             #FUN-A10109  ===E===
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
#No.FUN-670060 --start--       
        BEFORE FIELD ooydmy1
              CALL i010_set_entry(p_cmd)
        
        AFTER FIELD ooydmy1
           IF g_ooy_1[l_ac].ooydmy1 = "N" THEN
              LET g_ooy_1[l_ac].ooyglcr = "N"
            #  LET g_ooy_1[l_ac].ooygslp = NULL                       #NO.FUN-8B0019
            #  LET g_ooy_1[l_ac].ooygslp1= NULL      #No.FUN-680088   #NO.FUN-8B0019
              CALL i010_set_no_entry(p_cmd)
              CALL cl_set_comp_entry("ooygslp",FALSE) #No:TQC-B60111
              CALL cl_set_comp_entry("ooygslp1",FALSE) #No:TQC-B60111
           END IF
#No.FUN-690090--begin--                                                                                                   
           IF g_ooy_1[l_ac].ooydmy1 = 'Y' AND g_ooy_1[l_ac].ooytype = '35' THEN                                             
              CALL cl_err('','axr01',1)                                                                                     
                 LET g_ooy_1[l_ac].ooydmy1 = "N"   #No.FUN-690090                                                           
                 NEXT FIELD ooydmy1                                                                                         
           END IF                                                                                                           
           IF g_ooy_1[l_ac].ooytype = '35' THEN                                                                             
              CALL cl_set_comp_entry("ooydmy1",FALSE)                                                                       
           END IF                                                                                                           
#No.FUN-690090--end--         
          #str CHI-9C0010 add
          #當單據性質(ooytype)=31時,不可勾選拋轉傳票(ooydmy1)、
          #是否直接拋轉傳票(ooyglcr)、紅沖(ooydmy2)
           IF g_ooy_1[l_ac].ooytype='31' AND g_ooy_1[l_ac].ooydmy1='Y' THEN
              CALL cl_err('','axr-068',1)
              LET g_ooy_1[l_ac].ooydmy1 = "N"
              DISPLAY BY NAME g_ooy_1[l_ac].ooydmy1
              NEXT FIELD ooydmy1
           END IF
          #end CHI-9C0010 add

#NO.FUN-8B0019- --begin
        ON CHANGE ooydmy1
           IF g_ooy_1[l_ac].ooydmy1 = 'N' THEN 
              LET g_ooy_1[l_ac].ooyglcr = 'N'
            # LET g_ooy_1[l_ac].ooygslp = NULL       #No:TQC-B60109    #No.TQC-BA0167 mark
            # LET g_ooy_1[l_ac].ooygslp1= NULL       #No:TQC-B60109    #No.TQC-BA0167 mark
              DISPLAY BY NAME g_ooy_1[l_ac].ooyglcr
            #                ,g_ooy_1[l_ac].ooygslp,g_ooy_1[l_ac].ooygslp1   #No:TQC-B60109 add ooygslp,ooygslp1 #No.TQC-BA0167 mark
           END IF 
#NO.FUN-8B0019-  --end
     
        BEFORE FIELD ooyglcr
              CALL i010_set_entry(p_cmd)
      
        AFTER FIELD ooyglcr
           IF g_ooy_1[l_ac].ooyglcr = "N" THEN
            #  LET g_ooy_1[l_ac].ooygslp = NULL                        #FUN-8B0019
            #  LET g_ooy_1[l_ac].ooygslp1= NULL      #No.FUN-680088    #FUN-8B0019
            # LET g_ooy_1[l_ac].ooygslp = NULL       #No:TQC-B60109    #No.TQC-BA0167 mark
            # LET g_ooy_1[l_ac].ooygslp1= NULL       #No:TQC-B60109    #No.TQC-BA0167 mark
              CALL i010_set_no_entry(p_cmd)
           END IF
           IF g_ooy_1[l_ac].ooyglcr = "Y" THEN
             #str CHI-9C0010 add
             #當單據性質(ooytype)=31時,不可勾選拋轉傳票(ooydmy1)、
             #是否直接拋轉傳票(ooyglcr)、紅沖(ooydmy2)
              IF g_ooy_1[l_ac].ooytype='31' AND g_ooy_1[l_ac].ooyglcr='Y' THEN
                 CALL cl_err('','axr-068',1)
                 LET g_ooy_1[l_ac].ooyglcr = "N"
                 DISPLAY BY NAME g_ooy_1[l_ac].ooyglcr
                 NEXT FIELD ooyglcr
              END IF
             #end CHI-9C0010 add
             #str MOD-880085 mod
             #CALL cl_set_comp_required("ooygslp,ooygslp1",TRUE)      #No.FUN-680088
              CALL cl_set_comp_required("ooygslp",TRUE)               #No.FUN-680088
              IF g_aza.aza63 = 'Y' THEN
                 CALL cl_set_comp_required("ooygslp1",TRUE)
              END IF
             #end MOD-880085 mod
           #FUN-8B0019  --begin
           ELSE 
         	    CALL cl_set_comp_required("ooygslp",FALSE)
         	    IF g_aza.aza63 = 'Y' THEN 
                 CALL cl_set_comp_required("ooygslp1",FALSE)
              END IF  
           #FUN-8B0019  --end         
           END IF 
 
        AFTER FIELD ooygslp
           IF NOT cl_null(g_ooy_1[l_ac].ooygslp) THEN
              SELECT aac01 FROM aac_file
                 WHERE aac01=g_ooy_1[l_ac].ooygslp AND aacacti = 'Y' AND aac11='1'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aac_file",g_ooy_1[l_ac].ooygslp,"",SQLCA.sqlcode,"","",1)
                 NEXT FIELD ooygslp
              END IF
              #--------No.MOD-BB0040-------------------start
               LET lc_doc_set = g_aza.aza102
               CASE lc_doc_set
                  WHEN "1"   LET g_doc_len2 = 3
                  WHEN "2"   LET g_doc_len2 = 4
                  WHEN "3"   LET g_doc_len2 = 5
               END CASE
              #--------No.MOD-BB0040-------------------end
              #No.TQC-B60109--add--
              LET l_ooy=g_ooy_1[l_ac].ooygslp
              LET l_cn=l_ooy.getlength()
             #IF l_cn=g_doc_len THEN                                    #MOD-BB0040 mark
              IF l_cn=g_doc_len2 THEN                                   #MOD-BB0040 add
                #FOR l_i = 1 TO g_doc_len                               #MOD-BB0040 mark
                 FOR l_i = 1 TO g_doc_len2                              #MOD-BB0040 add
                    IF cl_null(g_ooy_1[l_ac].ooygslp[l_i,l_i]) THEN
                       CALL cl_err(g_ooy_1[l_ac].ooygslp,'sub-146',0)
                       NEXT FIELD ooygslp
                    END IF
                 END FOR
              ELSE
                 CALL cl_err(g_ooy_1[l_ac].ooygslp,'sub-146',0)
                 NEXT FIELD ooygslp
              END IF
              #No.TQC-B60109--end--
           END IF
#No.FUN-670060 --end--
  
        #No.FUN-680088 --begin
        AFTER FIELD ooygslp1
           IF NOT cl_null(g_ooy_1[l_ac].ooygslp1) THEN
              SELECT aac01 FROM aac_file
                 WHERE aac01=g_ooy_1[l_ac].ooygslp1 AND aacacti = 'Y' AND aac11='1'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aac_file",g_ooy_1[l_ac].ooygslp1,"",SQLCA.sqlcode,"","",1)
                 NEXT FIELD ooygslp1
              END IF
             #--------No.MOD-BB0040-------------------start
              LET lc_doc_set = g_aza.aza102
              CASE lc_doc_set
                 WHEN "1"   LET g_doc_len2 = 3
                 WHEN "2"   LET g_doc_len2 = 4
                 WHEN "3"   LET g_doc_len2 = 5
              END CASE
             #--------No.MOD-BB0040-------------------end
              #No.TQC-B60109--add--
              LET l_ooy=g_ooy_1[l_ac].ooygslp1
              LET l_cn=l_ooy.getlength()
             #IF l_cn=g_doc_len THEN                                     #MOD-BB0040 mark
              IF l_cn=g_doc_len2 THEN                                    #MOD-BB0040 add
                #FOR l_i = 1 TO g_doc_len                                #MOD-BB0040 mark
                 FOR l_i = 1 TO g_doc_len2                               #MOD-BB0040 add
                    IF cl_null(g_ooy_1[l_ac].ooygslp1[l_i,l_i]) THEN
                       CALL cl_err(g_ooy_1[l_ac].ooygslp1,'sub-146',0)
                       NEXT FIELD ooygslp1
                    END IF
                 END FOR
              ELSE
                 CALL cl_err(g_ooy_1[l_ac].ooygslp1,'sub-146',0)
                 NEXT FIELD ooygslp1 
              END IF
              #No.TQC-B60109--end--
           END IF
        #No.FUN-680088 --end
 
        AFTER FIELD ooyslip                        #check 編號是否重複
           IF g_ooy_1[l_ac].ooyslip IS NOT NULL THEN
           IF g_ooy_1[l_ac].ooyslip != g_ooy_t.ooyslip OR
           (NOT cl_null(g_ooy_1[l_ac].ooyslip) AND cl_null(g_ooy_t.ooyslip)) THEN
                SELECT count(*) INTO l_n FROM ooy_file
                    WHERE ooyslip = g_ooy_1[l_ac].ooyslip
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ooy_1[l_ac].ooyslip = g_ooy_t.ooyslip
                    NEXT FIELD ooyslip
                END IF
                SELECT count(*) INTO l_n FROM apy_file  #檢查是否和aapi103
                    WHERE apyslip = g_ooy_1[l_ac].ooyslip #單別重覆
                IF l_n > 0 THEN
                    CALL cl_err('','axr-908',0)
                    LET g_ooy_1[l_ac].ooyslip = g_ooy_t.ooyslip
                    NEXT FIELD ooyslip
                END IF
                 #NO.FUN-560150 --start--
                 FOR l_i = 1 TO g_doc_len
                    IF cl_null(g_ooy_1[l_ac].ooyslip[l_i,l_i]) THEN
                       CALL cl_err('','sub-146',0)
                       LET g_ooy_1[l_ac].ooyslip = g_ooy_t.ooyslip
                       NEXT FIELD ooyslip
                    END IF
                 END FOR
                 #NO.FUN-560150 --end--
            END IF
            IF g_ooy_1[l_ac].ooyslip != g_ooy_t.ooyslip THEN  #NO:6842
                UPDATE smv_file  SET smv01=g_ooy_1[l_ac].ooyslip
                 WHERE smv01=g_ooy_t.ooyslip   #NO:單別
                   #AND smv03=g_sys             #NO:系統別  #TQC-670008 remark
                   AND upper(smv03)='AXR'       #NO:系統別  #TQC-670008
                IF SQLCA.sqlcode THEN
#                   CALL cl_err('UPDATE smv_file',SQLCA.sqlcode,0)   #No.FUN-660116
                    CALL cl_err3("upd","smv_file",g_ooy_t.ooyslip,g_sys,SQLCA.sqlcode,"","UPDATE smv_file",1)  #No.FUN-660116
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                UPDATE smu_file  SET smu01=g_ooy_1[l_ac].ooyslip
                 WHERE smu01=g_ooy_t.ooyslip   #NO:單別
                   #AND smu03=g_sys             #NO:系統別 #TQC-670008 remark
                   AND upper(smu03)='AXR'       #NO:系統別 #TQC-670008
                IF SQLCA.sqlcode THEN
#                   CALL cl_err('UPDATE smu_file',SQLCA.sqlcode,0)   #No.FUN-660116
                    CALL cl_err3("upd","smu_file",g_ooy_t.ooyslip,g_sys,SQLCA.sqlcode,"","UPDATE smu_file",1)  #No.FUN-660116
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
             END IF
             END IF
 
#No.FUN-560060-begin
#       AFTER FIELD ooykind
#          IF NOT cl_null(g_ooy[l_ac].ooykind) THEN
#             IF g_ooy[l_ac].ooykind NOT MATCHES '[12]' THEN
#                NEXT FIELD ooykind
#             END IF
#          END IF
#No.FUN-560060-end
 
        AFTER FIELD ooyconf
           IF cl_null(g_ooy_1[l_ac].ooyconf) OR
              g_ooy_1[l_ac].ooyconf NOT MATCHES '[YN]' THEN
              NEXT FIELD ooyconf
           END IF
#FUN-8B0019  --begin 
#           IF g_ooy_1[l_ac].ooydmy1 = 'Y' AND g_ooy_1[l_ac].ooyconf = 'Y' THEN
#            # CALL cl_err(g_ooy[l_ac].ooyconf,'axr-xxx',0)
#              NEXT FIELD ooyconf
#           END IF
#FUN-8B0019 --end
#FUN-580128
        #FUN-640246
        #ON CHANGE ooyconf
        #   IF g_ooy_1[l_ac].ooyconf = 'Y' THEN
        #      LET g_ooy_1[l_ac].ooyapr = 'N'
        #      DISPLAY BY NAME g_ooy_1[l_ac].ooyapr
        #   END IF
 
        #ON CHANGE ooyapr
        #   IF g_ooy_1[l_ac].ooyapr = 'Y' THEN
        #      LET g_ooy_1[l_ac].ooyconf = 'N'
        #      DISPLAY BY NAME g_ooy_1[l_ac].ooyconf
        #   END IF
        #END FUN-640246
#END FUN-580128
        #FUN-C70108 mark str---
        ##No.TQC-C20335  --Begin
        #ON CHANGE ooyconf
        #  IF g_ooy_1[l_ac].ooyapr = 'Y' AND g_ooy_1[l_ac].ooyconf = 'Y' THEN 
        #     CALL cl_err('','axm-066',0)
        #     LET g_ooy_1[l_ac].ooyconf = 'N'
        #     NEXT FIELD ooyconf
        #  END IF

        #ON CHANGE ooyapr
        #  IF g_ooy_1[l_ac].ooyapr = 'Y' AND g_ooy_1[l_ac].ooyconf = 'Y' THEN
        #     CALL cl_err('','axm-066',0)
        #     LET g_ooy_1[l_ac].ooyapr = 'N'
        #     NEXT FIELD ooyapr
        #  END IF
        ##No.TQC-C20335  --End
        #FUN-C70108 mark end---

        BEFORE FIELD ooytype
            #IF p_cmd <> 'u' THEN                              #MOD-C70278 add #MOD-CA0134 mark
               CALL s_getgee('axri010',g_lang,'ooytype') #FUN-A10109
            #END IF                                            #MOD-C70278 add #MOD-CA0134 mark
#CHI-B30042----begin------
            #IF g_aza.aza50='Y' THEN  #No.TQC-B40042
            #IF g_aza.aza50='N' THEN   #No.TQC-B40042  #No.TQC-B40172 mark
            IF g_azw.azw04 <> '2' THEN   #No.TQC-B40172 
               LET g_comb = ui.ComboBox.forName("ooytype")
               CALL g_comb.removeItem('15')
               CALL g_comb.removeItem('16')   #No.TQC-B40172
               CALL g_comb.removeItem('17')
               CALL g_comb.removeItem('18')
               CALL g_comb.removeItem('19')   #No.TQC-B40172
               CALL g_comb.removeItem('26')
               CALL g_comb.removeItem('27')
               CALL g_comb.removeItem('28')   #No.TQC-B40172
            END IF
#CHI-B30042-----end-------

            #FUN-D10058--add--str--
            IF g_aza.aza26 = '2' AND g_aza.aza69 = 'N' THEN
               LET g_comb = ui.ComboBox.forName("ooytype")
               CALL g_comb.removeItem('35')
            END IF
            #FUN-D10058--add--end--
            #FUN-D10101--add--str--
            IF g_aza.aza26 != '2' OR g_oaz92 != 'N' THEN 
              LET g_comb = ui.ComboBox.forName("ooytype")
              CALL g_comb.removeItem('50') 
            END IF 
            #FUN-D10101--add--end-

            CALL i010_set_entry(p_cmd)
 
        AFTER FIELD ooytype
          #IF NOT cl_null(g_ooy_1[l_ac].ooytype) THEN                    #MOD-C70278 mark
          #GP5.2 FUN-960141 add 15 16 17 18 26 27 
          # 11 12 13 14 15 16 17 18 21 22 23 24 25 26 27 30 31 40
          #IF (g_ooy_1[l_ac].ooytype NOT MATCHES '1[1-4]' AND
          #    g_ooy_1[l_ac].ooytype NOT MATCHES '2[1-5]' AND

          #FUN-A10109    START  
          #IF (g_ooy_1[l_ac].ooytype NOT MATCHES '1[1-8]' AND
          #    g_ooy_1[l_ac].ooytype NOT MATCHES '2[1-7]' AND
          ##FUN-960141 end  
          #    #g_ooy_1[l_ac].ooytype NOT MATCHES '3[015]' AND   #No.FUN-690090   #FUN-960140 mark
          #    g_ooy_1[l_ac].ooytype NOT MATCHES '3[0125]' AND    #FUN-960140 
          #    g_ooy_1[l_ac].ooytype NOT MATCHES '4[0]') THEN
          #   NEXT FIELD ooytype
          #END IF
          #FUN-A10109    END
          #END IF                                                         #MOD-C70278 mark
          #No.TQC-A30139  --Begin                                              
          #CALL i010_set_entry(p_cmd)   #No:FUN-690090                          
           CALL i010_set_no_entry(p_cmd)                                        
          #No.TQC-A30139  --End 
          #----------------------MOD-C70278------------------------------(S)
           IF p_cmd='u' AND g_ooy_1[l_ac].ooytype != g_ooy_t.ooytype THEN
              LET l_n = 0
              LET l_len = 0
              LET l_len = length(g_ooy_1[l_ac].ooyslip)
              CASE WHEN (g_ooy_t.ooytype MATCHES '1*' OR g_ooy_t.ooytype MATCHES '2*'
                        OR g_ooy_t.ooytype = '31')
                         LET l_sql = "SELECT COUNT(*) FROM oma_file ",
                                     " WHERE oma01[1,",l_len,"] = '",g_ooy_1[l_ac].ooyslip,"'"
                   WHEN (g_ooy_t.ooytype ='30' OR g_ooy_t.ooytype = '32'
                        OR g_ooy_t.ooytype = '33' OR g_ooy_t.ooytype = '35')
                         LET l_sql = "SELECT COUNT(*) FROM ooa_file ",
                                     " WHERE ooa01[1,",l_len,"] = '",g_ooy_1[l_ac].ooyslip,"'"
                   WHEN (g_ooy_t.ooytype = '40')
                         LET l_sql = "SELECT COUNT(*) FROM ola_file ",
                                     " WHERE ola01[1,",l_len,"] = '",g_ooy_1[l_ac].ooyslip,"'"
              END CASE
              PREPARE i010_ooy_pre FROM l_sql
              DECLARE i010_ooy_cur CURSOR FOR i010_ooy_pre
              OPEN i010_ooy_cur
              FETCH i010_ooy_cur INTO l_n
              IF l_n > 0 THEN
                 CALL cl_err("",'aap-171',0)
                 LET g_ooy_1[l_ac].ooytype = g_ooy_t.ooytype
                 DISPLAY BY NAME g_ooy_1[l_ac].ooytype
                 NEXT FIELD ooytype
              END IF
           END IF
          #----------------------MOD-C70278------------------------------(E)
          #No.FUN-690090--begin--   
           IF g_ooy_1[l_ac].ooytype != '35'  THEN 
              LET g_ooy_1[l_ac].ooydmy3 = 'N' 
           END IF
           IF g_ooy_1[l_ac].ooydmy1 = 'Y' AND g_ooy_1[l_ac].ooytype = '35' THEN
              CALL cl_err('','axr01',1)
              LET g_ooy_1[l_ac].ooytype = NULL   #No.FUN-690090
              NEXT FIELD ooydmy1
           END IF
           IF g_ooy_1[l_ac].ooytype = '35' THEN 
              CALL cl_set_comp_entry("ooydmy1",FALSE)
           END IF 
          #No.FUN-690090 
          #str CHI-9C0010 add
           IF g_ooy_1[l_ac].ooytype='31'  THEN
              LET g_ooy_1[l_ac].ooydmy1 = "N"
              LET g_ooy_1[l_ac].ooyglcr = "N"
              LET g_ooy_1[l_ac].ooydmy2 = "N"
              DISPLAY BY NAME g_ooy_1[l_ac].ooydmy1,
                              g_ooy_1[l_ac].ooyglcr,
                              g_ooy_1[l_ac].ooydmy2
           END IF
          #end CHI-9C0010 add

       #str CHI-9C0010 add
       #當單據性質(ooytype)=31時,不可勾選拋轉傳票(ooydmy1)、
       #是否直接拋轉傳票(ooyglcr)、紅沖(ooydmy2)
        AFTER FIELD ooydmy2
           IF g_ooy_1[l_ac].ooytype='31' AND g_ooy_1[l_ac].ooydmy2='Y' THEN
              CALL cl_err('','axr-068',1)
              LET g_ooy_1[l_ac].ooydmy2 = "N"
              DISPLAY BY NAME g_ooy_1[l_ac].ooydmy2
              NEXT FIELD ooydmy2
           END IF
       #end CHI-9C0010 add
 
        AFTER FIELD ooy10
           IF NOT cl_null(g_ooy_1[l_ac].ooy10) THEN
              IF g_ooy_1[l_ac].ooy10 = 'N' THEN
                 LET g_ooy_1[l_ac].ooy11 = 0          	 
              END IF            
           END IF
          
#TQC-A30128 --begin--
     ON CHANGE ooy10 
        IF g_ooy_1[l_ac].ooy10 = 'Y' THEN 
            CALL cl_set_comp_entry("ooy11",TRUE)             
        END IF 
        IF g_ooy_1[l_ac].ooy10 = 'N' THEN 
            CALL cl_set_comp_entry("ooy11",FALSE)             
        END IF         
#TQC-A30128 --end--
 
        #No.TQC-770015 --start--
        AFTER FIELD ooy11
#TQC-A30128 --begin--
            IF NOT cl_null(g_ooy_1[l_ac].ooy11) THEN               
              IF g_ooy_1[l_ac].ooy10 = 'Y' THEN
                 IF g_ooy_1[l_ac].ooy11 = 0 THEN 
                    CALL cl_err('','alm-808',0)
                    NEXT FIELD ooy11
                 END IF 
              END IF
            END IF   
#TQC-A30128 --end--          
           IF g_ooy_1[l_ac].ooy11 < 0 THEN
              CALL cl_err('','mfg4012',1)
              NEXT FIELD ooy11
           END IF
        #No.TQC-770015 --end--
 
        #FUN-B50039-add-str--
        AFTER FIELD ooyud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ooyud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-B50039-add-end--

        BEFORE DELETE                            #是否取消單身
            IF g_ooy_t.ooyslip IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ooy_file WHERE ooyslip = g_ooy_t.ooyslip
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ooy_t.ooyslip,SQLCA.sqlcode,0)   #No.FUN-660116
                   CALL cl_err3("del","ooy_file",g_ooy_t.ooyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
               #DELETE FROM smv_file WHERE smv01 = g_ooy_t.ooyslip AND smv03=g_sys #NO:6842        #TQC-670008 remark
                DELETE FROM smv_file WHERE smv01 = g_ooy_t.ooyslip AND upper(smv03)='AXR' #NO:6842 #TQC-670008
                IF SQLCA.sqlcode THEN
#                  CALL cl_err('smv_file',SQLCA.sqlcode,0)   #No.FUN-660116
                   CALL cl_err3("del","smv_file",g_ooy_t.ooyslip,g_sys,SQLCA.sqlcode,"","smv_file",1)  #No.FUN-660116
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                #DELETE FROM smu_file WHERE smu01 = g_ooy_t.ooyslip AND smu03=g_sys  #NO:6842  #TQC-670008 remark
                DELETE FROM smu_file WHERE smu01 = g_ooy_t.ooyslip AND upper(smu03)='AXR'      #TQC-670008
                IF SQLCA.sqlcode THEN
#                  CALL cl_err('smv_file',SQLCA.sqlcode,0)   #No.FUN-660116
                   CALL cl_err3("del","smu_file",g_ooy_t.ooyslip,g_sys,SQLCA.sqlcode,"","smu_file",1)  #No.FUN-660116
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                #FUN-A10109  ===S===
                CALL s_access_doc('r','','',g_ooy_t.ooyslip,'AXR','')
                #FUN-A10109  ===E===
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i010_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ooy_1[l_ac].* = g_ooy_t.*
              CLOSE i010_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ooy_1[l_ac].ooyslip,-263,1)
              LET g_ooy_1[l_ac].* = g_ooy_t.*
           ELSE
              UPDATE ooy_file SET ooyslip=g_ooy_1[l_ac].ooyslip,
                                  ooydesc=g_ooy_1[l_ac].ooydesc,
                                  ooyauno=g_ooy_1[l_ac].ooyauno,
                                  #ooykind=g_ooy_1[l_ac].ooykind, #FUN-A10109
                                  ooyconf=g_ooy_1[l_ac].ooyconf,
                                  ooyprit=g_ooy_1[l_ac].ooyprit,
                                  ooyapr =g_ooy_1[l_ac].ooyapr,   #No.FUN-540040
                                  ooydmy1=g_ooy_1[l_ac].ooydmy1,
                                  ooyglcr=g_ooy_1[l_ac].ooyglcr,  #No.FUN-670060
                                  ooygslp=g_ooy_1[l_ac].ooygslp,  #No.FUN-670060
                                  ooygslp1=g_ooy_1[l_ac].ooygslp1,#No.FUN-680088
                                  ooytype=g_ooy_1[l_ac].ooytype,  #MOD-4C0087
                                  ooydmy2=g_ooy_1[l_ac].ooydmy2,  #FUN-590100
                                  ooy10  =g_ooy_1[l_ac].ooy10 ,
                                  ooy11  =g_ooy_1[l_ac].ooy11,    ##MOD-4C0087#FUN-5C0095
                                  ooyacti=g_ooy_1[l_ac].ooyacti,  #FUN-5C0095 add 
                                  ooydmy3=g_ooy_1[l_ac].ooydmy3,  #No.FUN-690090
                                  #FUN-B50039-add-str--
                                  ooyud01 = g_ooy_1[l_ac].ooyud01,
                                  ooyud02 = g_ooy_1[l_ac].ooyud02,
                                  ooyud03 = g_ooy_1[l_ac].ooyud03,
                                  ooyud04 = g_ooy_1[l_ac].ooyud04,
                                  ooyud05 = g_ooy_1[l_ac].ooyud05,
                                  ooyud06 = g_ooy_1[l_ac].ooyud06,
                                  ooyud07 = g_ooy_1[l_ac].ooyud07,
                                  ooyud08 = g_ooy_1[l_ac].ooyud08,
                                  ooyud09 = g_ooy_1[l_ac].ooyud09,
                                  ooyud10 = g_ooy_1[l_ac].ooyud10,
                                  ooyud11 = g_ooy_1[l_ac].ooyud11,
                                  ooyud12 = g_ooy_1[l_ac].ooyud12,
                                  ooyud13 = g_ooy_1[l_ac].ooyud13,
                                  ooyud14 = g_ooy_1[l_ac].ooyud14,
                                  ooyud15 = g_ooy_1[l_ac].ooyud15
                                  #FUN-B50039-add-end--
               WHERE ooyslip=g_ooy_t.ooyslip
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ooy_1[l_ac].ooyslip,SQLCA.sqlcode,0)   #No.FUN-660116
                   CALL cl_err3("upd","ooy_file",g_ooy_t.ooyslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
                   LET g_ooy_1[l_ac].* = g_ooy_t.*
               ELSE
                  #FUN-A10109  ===S===
                  CALL s_access_doc('u',g_ooy_1[l_ac].ooyauno,g_ooy_1[l_ac].ooytype,
                                    g_ooy_t.ooyslip,'AXR',g_ooy_1[l_ac].ooyacti)
                  #FUN-A10109 ===E===
                   MESSAGE 'UPDATE O.K'
                   CLOSE i010_bcl
                   COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ooy_1[l_ac].* = g_ooy_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_ooy_1.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE i010_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i010_bcl
            COMMIT WORK
            #CKP2
            CALL g_ooy_1.deleteElement(g_rec_b+1)
#No.FUN-670060 --start--
        ON ACTION controlp
           CASE
               WHEN INFIELD(ooygslp)   
                    # 得出總帳 database name                                                                                        
                    # g_ooz.ooz02p -> g_plant_new -> s_getdbs() -> g_dbs_new -->                                                    
                     LET g_plant_new= g_ooz.ooz02p                                                                                  
                     CALL s_getdbs()                                                                                                
                     LET g_dbs_gl=g_dbs_new CLIPPED    
                     LET g_plant_gl= g_ooz.ooz02p                 #No.FUN-980059                                                                 
                     CALL s_getdbs()                                                                                                
                    IF g_aaz.aaz70 MATCHES '[yY]' THEN
                     # CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_ooy_1[l_ac].ooygslp,'1',' ',g_user,'AGL')   #No.FUN-980059
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_ooy_1[l_ac].ooygslp,'1',' ',g_user,'AGL') #No.FUN-980059
                       RETURNING g_ooy_1[l_ac].ooygslp
                    ELSE 
                     # CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_ooy_1[l_ac].ooygslp,'1',' ',' ','AGL')   #No.FUN-980059
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_ooy_1[l_ac].ooygslp,'1',' ',' ','AGL') #No.FUN-980059
                       RETURNING g_ooy_1[l_ac].ooygslp
                    END IF
                    DISPLAY BY NAME g_ooy_1[l_ac].ooygslp
                    NEXT FIELD ooygslp
               #No.FUN-680088 --begin
               WHEN INFIELD(ooygslp1)   
                    # 得出總帳 database name                                                                                        
                    # g_ooz.ooz02p -> g_plant_new -> s_getdbs() -> g_dbs_new -->                                                    
                     LET g_plant_new= g_ooz.ooz02p                                                                                  
                     CALL s_getdbs()                                                                                                
                     LET g_dbs_gl=g_dbs_new CLIPPED    
                    IF g_aaz.aaz70 MATCHES '[yY]' THEN
                 #     CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_ooy_1[l_ac].ooygslp1,'1',' ',g_user,'AGL')     #No.FUN-980059
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_ooy_1[l_ac].ooygslp1,'1',' ',g_user,'AGL')   #No.FUN-980059
                       RETURNING g_ooy_1[l_ac].ooygslp1
                    ELSE 
                 #     CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_ooy_1[l_ac].ooygslp1,'1',' ',' ','AGL')        #No.FUN-980059
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_ooy_1[l_ac].ooygslp1,'1',' ',' ','AGL')      #No.FUN-980059
                       RETURNING g_ooy_1[l_ac].ooygslp1
                    END IF
                    DISPLAY BY NAME g_ooy_1[l_ac].ooygslp1
                    NEXT FIELD ooygslp1
               #No.FUN-680088 --end
               OTHERWISE EXIT CASE
           END CASE
#No.FUN-670060 --end--
        ON ACTION CONTROLN
            CALL i010_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ooyslip) AND l_ac > 1 THEN
                LET g_ooy_1[l_ac].* = g_ooy_1[l_ac-1].*
                NEXT FIELD ooyslip
            END IF
 
        ON ACTION set_user    #NO:6842
             #MOD-480185
            IF NOT cl_null(g_ooy_1[l_ac].ooyslip) THEN
               LET g_action_choice='set_user'
               IF cl_chk_act_auth() THEN
                 #CALL s_smu(g_ooy_1[l_ac].ooyslip,g_sys) #TQC-660133 remark
                  CALL s_smu(g_ooy_1[l_ac].ooyslip,"AXR") #TQC-660133
               END IF
            ELSE
               CALL cl_err('','anm-217',0)
            END IF
            #--
 
        ON ACTION set_dept  #NO:6842
             #MOD-480185
            IF NOT cl_null(g_ooy_1[l_ac].ooyslip) THEN
               LET g_action_choice='set_dept'
               IF cl_chk_act_auth() THEN
                 #CALL s_smv(g_ooy_1[l_ac].ooyslip,g_sys) #TQC-660133 remark
                  CALL s_smv(g_ooy_1[l_ac].ooyslip,"AXR") #TQC-660133
               END IF
            ELSE
               CALL cl_err('','anm-217',0)
            END IF
            #--
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
 
        END INPUT
 
    CLOSE i010_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i010_b_askkey()
    CLEAR FORM
    CALL g_ooy_1.clear()
    #FUN-D10058--add--str--
    IF g_aza.aza26 = '2' AND g_aza.aza69 = 'N' THEN
       LET g_comb = ui.ComboBox.forName("ooytype")
       CALL g_comb.removeItem('35')
    END IF
    #FUN-D10058--add--end--
    CONSTRUCT g_wc2 ON ooyslip,ooydesc,ooyauno,
                       #ooykind, #FUN-A10109
                       ooydmy1,ooyglcr,ooygslp,ooygslp1,      #No.FUN-680088
                       ooyconf,ooyprit,ooyapr,ooytype,ooydmy2,ooy10,ooy11,ooyacti,ooydmy3,    #No.FUN-690090 #FUN-590100   #No.FUN-540040 #FUN-5C0095 #No.FUN-670060
                       ooyud01,ooyud02,ooyud03,ooyud04,ooyud05,ooyud06,ooyud07,ooyud08,       #FUN-B50039
                       ooyud09,ooyud10,ooyud11,ooyud12,ooyud13,ooyud14,ooyud15                #FUN-B50039
            FROM s_ooy[1].ooyslip,s_ooy[1].ooydesc,s_ooy[1].ooyauno,
                 #s_ooy[1].ooykind, #FUN-A10109
                 s_ooy[1].ooydmy1,s_ooy[1].ooyglcr,
                 s_ooy[1].ooygslp,s_ooy[1].ooygslp1,s_ooy[1].ooyconf,                  #No.FUN-670060
                 s_ooy[1].ooyprit,s_ooy[1].ooyapr,s_ooy[1].ooytype,   #No.FUN-540040
                 s_ooy[1].ooydmy2,s_ooy[1].ooy10,s_ooy[1].ooy11,s_ooy[1].ooyacti,s_ooy[1].ooydmy3,   #No.FUN-6900090   #FUN-590100#FUN-5C0095
                 s_ooy[1].ooyud01,s_ooy[1].ooyud02,s_ooy[1].ooyud03,s_ooy[1].ooyud04,s_ooy[1].ooyud05,   #FUN-B50039
                 s_ooy[1].ooyud06,s_ooy[1].ooyud07,s_ooy[1].ooyud08,s_ooy[1].ooyud09,s_ooy[1].ooyud10,   #FUN-B50039
                 s_ooy[1].ooyud11,s_ooy[1].ooyud12,s_ooy[1].ooyud13,s_ooy[1].ooyud14,s_ooy[1].ooyud15    #FUN-B50039 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i010_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(200)
 
    LET g_sql = "SELECT ooyslip,ooydesc,ooyauno,",
                #"      ooykind,", #FUN-A10109
                "       ooydmy1,ooyglcr,ooygslp,ooygslp1,",
                " ooyconf,ooyprit,ooyapr,ooytype,ooydmy2,ooy10,ooy11,ooyacti,ooydmy3,",#No.FUN-690090 #FUN-590100 #No.FUN-540040 #FUN-5C0095 #No.FUN-670060
                " ooyud01,ooyud02,ooyud03,ooyud04,ooyud05,ooyud06,ooyud07,ooyud08,",   #FUN-B50039
                " ooyud09,ooyud10,ooyud11,ooyud12,ooyud13,ooyud14,ooyud15 ",           #FUN-B50039
                " FROM ooy_file",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                " ORDER BY ooytype,ooyslip"
    PREPARE i010_pb FROM g_sql
    DECLARE ooy_curs CURSOR FOR i010_pb
 
    CALL g_ooy_1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ooy_curs INTO g_ooy_1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ooy_1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ooy_1 TO s_ooy.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         DISPLAY "accept"
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
 
 
      #FUN-4B0017
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-7C0043--start--
 FUNCTION i010_out()
    DEFINE
        l_ooy           RECORD LIKE ooy_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680123 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20), # External(Disk) file name
        l_za05          LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40), 
        l_cmd           STRING
    DEFINE l_msg        LIKE type_file.chr1000        #No.FUN-7C0043
    IF g_wc2 IS NULL THEN
    #  CALL cl_err('',-400,0)
       CALL cl_err('','9057',0)
    RETURN END IF
    LET l_msg = 'p_query "axri010" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_msg)                                                                                                           
    RETURN
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#   CALL cl_outnam('axri010') RETURNING l_name
 
#   LET g_sql="SELECT * FROM ooy_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i010_co                         # SCROLL CURSOR
#        CURSOR FOR i010_p1
 
#   START REPORT i010_rep TO l_name
 
#   FOREACH i010_co INTO l_ooy.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i010_rep(l_ooy.*)
#   END FOREACH
 
#   FINISH REPORT i010_rep
#   LET l_cmd = "chmod 777 ",l_name
#   RUN l_cmd
 
#   CLOSE i010_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i010_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680123  VARCHAR(1),
#       sr RECORD LIKE ooy_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ooytype,sr.ooyslip
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED, pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[41],g_x[40],g_x[43],g_x[42]#TQC-790101 add g_x[43]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINT COLUMN g_c[31],sr.ooyslip,
#                 COLUMN g_c[32],sr.ooydesc,
#                 COLUMN g_c[33],sr.ooyauno,
#                 COLUMN g_c[34],sr.ooykind,
#                 COLUMN g_c[35],sr.ooyconf,
#                 COLUMN g_c[36],sr.ooyprit,
#                 COLUMN g_c[37],sr.ooydmy1,
#                 COLUMN g_c[38],sr.ooyglcr,
#                 COLUMN g_c[39],sr.ooygslp,
#                 COLUMN g_c[41],sr.ooygslp1,      #No.FUN-680088
#                 COLUMN g_c[40],sr.ooytype,
#                 COLUMN g_c[43],sr.ooyacti,       #TQC-790101 add
#                 COLUMN g_c[42],sr.ooydmy3        #No.FUN-690090
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end--
FUNCTION i010_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF INFIELD(ooytype) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ooydmy2",TRUE)  #No.TQC-A30139
      CALL cl_set_comp_entry("ooy10",TRUE)
      CALL cl_set_comp_entry("ooy11",TRUE)
   END IF
#No.FUN-670060 --start--
   IF INFIELD(ooydmy1) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ooyglcr",TRUE)
      CALL cl_set_comp_entry("ooydmy2",TRUE)  #No.TQC-A30139
   #   CALL cl_set_comp_entry("ooygslp,ooygslp1",TRUE)      #No.FUN-680088   #NO.FUN-8B0019
   END IF
   IF INFIELD(ooyglcr) OR (NOT g_before_input_done) THEN  
      CALL cl_set_comp_entry("ooygslp,ooygslp1",TRUE)      #No.FUN-680088
   END IF
#No.FUN-670060 --end--
   #NO.FUN-8B0019-  --begin
   IF NOT g_before_input_done THEN 
      CALL cl_set_comp_entry("ooygslp,ooygslp1",TRUE)
   END IF 
   #NO.FUN-8B0019  --end
#No.FUN-570108 --start--
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ooyslip",TRUE)
   END IF
#No.FUN-570108 --end--
#  CALL cl_set_comp_entry("ooydmy2",TRUE)  #FUN-590100  #No.TQC-A30139
 
#No.FUN-690090 --start--
   IF g_ooy_1[l_ac].ooytype MATCHES '35'  THEN
      CALL cl_set_comp_entry("ooydmy3",TRUE)  ELSE
      LET g_ooy_1[l_ac].ooydmy3 = 'N' 
      CALL cl_set_comp_entry("ooydmy1",TRUE)
   END IF
#No.FUN-690090 --end--
 
 #TQC-A30128 --begin--
   IF g_ooy_1[l_ac].ooy10 = 'Y' THEN 
      CALL cl_set_comp_entry("ooy11",TRUE)
   END IF 
 #TQC-A30128 --end--
END FUNCTION
 
FUNCTION i010_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
 
   IF INFIELD(ooytype) OR (NOT g_before_input_done) THEN
      IF g_aza.aza26 != '2' OR
         (g_ooy_1[l_ac].ooytype NOT MATCHES '1*' AND
          g_ooy_1[l_ac].ooytype NOT MATCHES '2*') THEN
         CALL cl_set_comp_entry("ooy10",FALSE)
         CALL cl_set_comp_entry("ooy11",FALSE)
      END IF
   END IF
#No.FUN-670060 --start--
   IF INFIELD(ooydmy1) OR (NOT g_before_input_done) THEN  
      IF g_ooy_1[l_ac].ooydmy1 = "N" THEN
         CALL cl_set_comp_entry("ooyglcr",FALSE)
        #str MOD-880085 mod
        #CALL cl_set_comp_entry("ooygslp,ooygslp1",FALSE)
        # CALL cl_set_comp_entry("ooygslp",FALSE)     #NO.FUN-8B0019
         IF g_aza.aza63 != 'Y' THEN
            CALL cl_set_comp_visible("ooygslp1",FALSE)
         END IF
        #end MOD-880085 mod
      END IF
   END IF
#FUN-8B0019  --begin   
#   IF INFIELD(ooyglcr) OR (NOT g_before_input_done) THEN
#      IF g_ooy_1[l_ac].ooyglcr = "N" THEN
#        #str MOD-880085 mod
#        #CALL cl_set_comp_entry("ooygslp,ooygslp1",FALSE)
#         CALL cl_set_comp_entry("ooygslp",FALSE)
#         IF g_aza.aza63 != 'Y' THEN
#            CALL cl_set_comp_visible("ooygslp1",FALSE)
#         END IF
#        #end MOD-880085 mod
#      END IF
#   END IF
#FUN-8B0019  --end
#No.FUN-670060 --end--
 
#No.FUN-570108 --start--
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ooyslip",FALSE)
   END IF
#No.FUN-570108 --end--
   #FUN-590100  --begin
   IF g_ooy_1[l_ac].ooytype MATCHES '1*' OR g_ooy_1[l_ac].ooydmy1 = 'N' THEN
      CALL cl_set_comp_entry("ooydmy2",FALSE)
   END IF
   #FUN-590100  --end
 
#No.FUN-690090 --begin--
   IF g_ooy_1[l_ac].ooytype NOT MATCHES '35'  THEN
      CALL cl_set_comp_entry("ooydmy3",FALSE)
   END IF
   
#No.FUN-690090 --end--

 #TQC-A30128 --begin--
   IF g_ooy_1[l_ac].ooy10 = 'N' THEN 
      CALL cl_set_comp_entry("ooy11",FALSE)
   END IF 
 #TQC-A30128 --end-- 
END FUNCTION
#Patch....NO.TQC-610037 <001,002,003,004,005,006,008,015,016,017,018,019,020,021> #


