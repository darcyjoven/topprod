# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afai060.4gl
# Descriptions...: 固定資產系統單據性質維護作業
# Date & Author..: 96/04/17 By Sophia
# Modify.........: 97/06/19 By Star  增加拋轉傳票欄位
# Modify.........: No:A099 04/06/29 By Danny 新增大陸版 H.減值準備
# Modify.........: No.MOD-470515 04/07/26 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.MOD-4B0088 04/11/11 By Nicola 進入單身，部門設限與使用者設限，無論 p_zz 怎麼設都無效
# Modify.........: No.FUN-510035 05/01/25 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550034 05/05/11 By ice 編號方法增加3.依年周
# Modify.........: No.FUN-550034 05/05/11 By jackie 單據編號加大
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570008 05/07/07 By Nicola 固定資產系統單據性質維護作業，按“更改”可更改單據編號
# Modify.........: No.FUN-570199 05/07/21 By Claire 程式先「查詢」→「放棄」查詢→「相關文件」會使程式跳開
# Modify.........: No.FUN-580109 05/10/21 By Sarah 新增"需簽核"欄位
# Modify.........: No.FUN-640243 06/05/09 By Echo 取消"立即確認"與"應簽核"欄位為互斥的選項
# Modify.........: No.MOD-660007 06/06/05 By Smapmin 單據性質新增H選項
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-670060 06/07/19 By bnlent 在"拋轉憑証"后面增加"系統自動拋轉總帳"和"自動拋轉總帳單別"兩個欄位
# Modify.........: No.FUN-670060 06/07/19 By bnlent zaa_file是從34區拷貝過來的  
# Modify.........: No.FUN-670060 06/08/02 By wujie  直接拋轉總帳單別開窗修改
# modify.........: no.tqc-670042 06/08/14 by claire 部門及使用者權限修正
# Modify.........: No.FUN-680088 06/08/30 By Ray 新增自動拋轉總帳第二單別
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680088過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-740122 07/04/22 By chenl 修正：設定系統自動拋轉總帳,會開出第二組單別,但參數未設定兩套帳。
# Modify.........: No.FUN-780037 07/07/03 By hongmei 報表格式修改為p_query
# Modify.........: No.TQC-870044 08/07/31 By Vicky 增設:需簽核功能的單別不允許設定自動過帳,自動過帳功能僅提供非簽核單據使用
# Modify.........: No.MOD-8B0024 08/11/04 By Sarah "自動拋轉總帳單別"欄位開窗資料有問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-A10109 10/02/10 By TSD.zeak 取消編碼方式，單據性質改成動態combobox
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B30162 11/03/18 By Sarah 直接過帳='Y',直接確認='N'的資料應不被允許,因為有先後關係
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能 
# Modify.........: No.TQC-B60145 11/06/21 By zhangweib 在自動拋轉總賬單別/自動拋轉總賬單別二的AFTER FIELD中加入對欄位長度的控管
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:FUN-B90004 11/09/19 By Belle 修改對於「自動拋轉總帳單別」欄位的控制
# Modify.........: No:FUN-BB0163 12/01/13 By Sakura 財一、財二依性質預設為"Y"，且同步異動資料不可維護
# Modify.........: No:FUN-BC0035 12/01/13 By Sakura 單據性質(fahtype)：增加選項"K.類別異動"
# Modify.........: No:MOD-C10210 12/02/01 By Polly 修正fahgslp/fahgslp1長度的抓取，採用aza102長度為主
# Modify.........: No:MOD-C20021 12/02/06 By Polly 修正如單身無資料點選時出現錯誤
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 單別增加參數"拋轉傳票(財簽二)"
# Modify.........: No:MOD-C50099 12/05/15 By Polly 單別維護作業更改完後，需重新call s_access_doc
# Modify.........: No:MOD-C70028 12/07/03 By Carrier “财签”“财签二”修改后状态显示异常
# Modify.........: No:MOD-C70278 12/07/30 By Polly 增加控卡，該單別已存在交易時不可修改
# Modify.........: No:TQC-C80094 12/08/14 By Polly 增加單別控卡，該單別已存在交易時不可修改、刪除
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fah_pafaho    LIKE type_file.num5,     #頁數                     #No.FUN-680070 SMALLINT
    g_fah           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        fahslip     LIKE fah_file.fahslip,   #單別
        fahdesc     LIKE fah_file.fahdesc,   #單據名稱
        fahauno     LIKE fah_file.fahauno,   #自動編號否
        #fahdmy5     LIKE fah_file.fahdmy5,   #編號方式 #FUN-A10109
        fahtype     LIKE fah_file.fahtype,   #單據性質
        fahfa1      LIKE fah_file.fahfa1,    #財簽一   #No:FUN-B60140
        fahfa2      LIKE fah_file.fahfa2,    #財簽二   #No:FUN-B60140
        fahprt      LIKE fah_file.fahprt,    #立即列印否
        fahconf     LIKE fah_file.fahconf,   #直接確認否
        fahpost     LIKE fah_file.fahpost,   #直接過帳否
        fahdmy3     LIKE fah_file.fahdmy3,   #拋轉傳票
        fahdmy32    LIKE fah_file.fahdmy32,   #拋轉傳票(財簽二) #FUN-C30313 add
        fahglcr     LIKE fah_file.fahglcr,   #系統自動接拋轉總帳
        fahgslp     LIKE fah_file.fahgslp,   #自動拋轉總帳單別
        fahgslp1    LIKE fah_file.fahgslp1,  #自動拋轉總帳第二單別     #No.FUN-680088
        fahapr      LIKE fah_file.fahapr     #FUN-580109
                    END RECORD,
    g_fah_t         RECORD                   #程式變數 (舊值)
        fahslip     LIKE fah_file.fahslip,   #單別
        fahdesc     LIKE fah_file.fahdesc,   #單據名稱
        fahauno     LIKE fah_file.fahauno,   #自動編號否
        #fahdmy5     LIKE fah_file.fahdmy5,   #編號方式 #FUN-A10109
        fahtype     LIKE fah_file.fahtype,   #單據性質
        fahfa1      LIKE fah_file.fahfa1,    #財簽一   #No:FUN-B60140
        fahfa2      LIKE fah_file.fahfa2,    #財簽二   #No:FUN-B60140
        fahprt      LIKE fah_file.fahprt,    #立即列印否
        fahconf     LIKE fah_file.fahconf,   #直接確認否
        fahpost     LIKE fah_file.fahpost,   #直接過帳否
        fahdmy3     LIKE fah_file.fahdmy3,   #拋轉傳票
        fahdmy32    LIKE fah_file.fahdmy32,  #拋轉傳票(財簽二) #FUN-C30313 add
        fahglcr     LIKE fah_file.fahglcr,   #系統自動拋轉總帳                                                                      
        fahgslp     LIKE fah_file.fahgslp,   #自動拋轉總帳單別       
        fahgslp1    LIKE fah_file.fahgslp1,  #自動拋轉總帳第二單別     #No.FUN-680088
        fahapr      LIKE fah_file.fahapr     #FUN-580109
                    END RECORD,
    g_wc2,g_sql     string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,     #單身筆數                 #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT      #No.FUN-680070 SMALLINT
 
DEFINE g_forupd_sql STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5                         #No.FUN-680070 SMALLINT
DEFINE g_cnt        LIKE type_file.num10     #No.FUN-680070 INTEGER
DEFINE g_i          LIKE type_file.num5      #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE l_cmd        LIKE type_file.chr1000   #No.FUN-780037
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0069
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680070 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW i060_w AT p_row,p_col WITH FORM "afa/42f/afai060"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #No.FUN-680088 --begin
  # IF g_aza.aza63 = 'N' THEN       #NO.FUN-AB0088
    IF g_faa.faa31 = 'N' THEN 
       CALL cl_set_comp_visible("fahgslp1",FALSE)
       CALL cl_set_comp_visible("fahfa2",FALSE)  #No:FUN-B60140
       CALL cl_set_comp_visible("fahdmy32",FALSE)#FUN-C30313 add
    END IF
    #No.FUN-680088 --end
  
    #No:A099
    #-----MOD-660007---------
    #IF g_aza.aza26 = '2' THEN
    #   CALL i060_set_comb()
    #END IF
    #-----END MOD-660007-----
    #end No:A099
 
    LET g_wc2 = '1=1'
    CALL i060_b_fill(g_wc2)
    LET g_fah_pafaho = 0                  #現在單身頁次
    CALL i060_menu()
    CLOSE WINDOW i060_w                   #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
         RETURNING g_time    #No.FUN-6A0069
END MAIN
 
FUNCTION i060_menu()
 
   WHILE TRUE
      CALL i060_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i060_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i060_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-780037---Begin  
               #CALL i060_out()       
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
               LET l_cmd = 'p_query "afai060" "',g_wc2 CLIPPED,'"'               
               CALL cl_cmdrun(l_cmd)                       
               #No.FUN-780037---End	   
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_fah[l_ac].fahslip IS NOT NULL THEN
                  LET g_doc.column1 = "fahslip"
                  LET g_doc.value1 = g_fah[l_ac].fahslip
                  CALL cl_doc()
               END IF
            END IF
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fah),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i060_q()
   CALL s_getgee('afai060',g_lang,'fahtype') #FUN-A10109
   CALL i060_b_askkey()
   LET g_fah_pafaho = 0
END FUNCTION
 
FUNCTION i060_b()
   DEFINE l_ac_t          LIKE type_file.num5    #未取消的ARRAY CNT   #No.FUN-680070 SMALLINT
   DEFINE l_n             LIKE type_file.num5    #檢查重複用          #No.FUN-680070 SMALLINT
   DEFINE l_lock_sw       LIKE type_file.chr1    #單身鎖住否          #No.FUN-680070 VARCHAR(1)
   DEFINE l_aa            LIKE type_file.chr5    #No.FUN-550034       #No.FUN-680070 VARCHAR(05)
   DEFINE p_cmd           LIKE type_file.chr1    #處理狀態            #No.FUN-680070 VARCHAR(1)
   DEFINE l_allow_insert  LIKE type_file.chr1    #可新增否            #No.FUN-680070 VARCHAR(1)
   DEFINE l_allow_delete  LIKE type_file.chr1    #可刪除否            #No.FUN-680070 VARCHAR(1)
   DEFINE l_i             LIKE type_file.num5    #No.FUN-560150       #No.FUN-680070 SMALLINT
   DEFINE g_dbs_gl        STRING                 #No.FUN-670060 
   DEFINE g_plant_gl      STRING                 #No.FUN-980059 
   DEFINE l_str           STRING                 #TQC-B60145   Add
   DEFINE g_doc_len2      LIKE type_file.num5    #MOD-C10210 add
   DEFINE lc_doc_set      LIKE aza_file.aza41    #MOD-C10210 add
   DEFINE l_sql           STRING                 #MOD-C70278 add
   DEFINE l_len           LIKE type_file.num10   #MOD-C70278 add
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fah.clear() END IF
 
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fahslip,fahdesc,fahauno,",
                       #"       fahdmy5,", #FUN-A10109
                       "       fahtype,fahfa1,fahfa2,",   #No:FUN-B60140
                       "       fahprt,fahconf,fahpost,fahdmy3,fahdmy32,fahglcr,fahgslp,fahgslp1 ", #No.FUN-670060       #No.FUN-680088 #FUN-C30313 add fahdmy32
                       "      ,fahapr ",   #FUN-580109 增加需簽核欄位
                       "  FROM fah_file ",
                       " WHERE fahslip= ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i060_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_fah WITHOUT DEFAULTS FROM s_fah.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
          #-----------------MOD-C20021-------移至BEFORE ROW段----------start
          ##FUN-BB0163-----being add
          # LET g_before_input_done = FALSE
          # CALL i060_set_entry(p_cmd)
          # CALL i060_set_no_entry(p_cmd)
          # LET g_before_input_done = TRUE
          ##FUN-BB0163-----end add
          #-----------------MOD-C20021-------移至BEFORE ROW段------------end
            
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
           #---------------------MOD-C10210------------------------start
            LET lc_doc_set = g_aza.aza102
            CASE lc_doc_set
               WHEN "1"   LET g_doc_len = 3
               WHEN "2"   LET g_doc_len = 4
               WHEN "3"   LET g_doc_len = 5
            END CASE
            CALL cl_set_doctype_format("fahgslp")
            CALL cl_set_doctype_format("fahgslp1")
            LET lc_doc_set = g_aza.aza41
            CASE lc_doc_set
               WHEN "1"   LET g_doc_len = 3
               WHEN "2"   LET g_doc_len = 4
               WHEN "3"   LET g_doc_len = 5
            END CASE
         #---------------------MOD-C10210--------------------------end
            #NO.FUN-560150 --start--
            CALL cl_set_doctype_format("fahslip")
            #NO.FUN-560150 --end--
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            #No.MOD-C70028  --Begin
            ##----------------------------MOD-C20021------------------start
            # LET g_before_input_done = FALSE
            # CALL i060_set_entry(p_cmd)
            # CALL i060_set_no_entry(p_cmd)
            # LET g_before_input_done = TRUE
            ##----------------------------MOD-C20021--------------------end
            #No.MOD-C70028  --End  
        #   LET g_fah_t.* = g_fah[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           #IF g_fah_t.fahslip IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_fah_t.* = g_fah[l_ac].*  #BACKUP
 
                BEGIN WORK
                OPEN i060_bcl USING g_fah_t.fahslip
                IF STATUS THEN
                   CALL cl_err("OPEN i060_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i060_bcl INTO g_fah[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fah_t.fahslip,SQLCA.sqlcode,0)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL i060_set_entry(p_cmd)     #No.FUN-570008
                CALL i060_set_no_entry(p_cmd)  #No.FUN-570008
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD fahslip
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fah[l_ac].* TO NULL      #900423
            LET g_fah[l_ac].fahauno = 'Y'         #Body default
            #LET g_fah[l_ac].fahdmy5 = '1' #FUN-A10109
            LET g_fah[l_ac].fahprt  = 'N'
            LET g_fah[l_ac].fahconf = 'N'
            LET g_fah[l_ac].fahpost = 'N'
            LET g_fah[l_ac].fahdmy3 = 'N'
            LET g_fah[l_ac].fahdmy32 = 'N'  #FUN-C30313 add
            LET g_fah[l_ac].fahglcr = 'N'   #No.FUN-670060 
            LET g_fah[l_ac].fahgslp = NULL  #No.FUN-670060 
            LET g_fah[l_ac].fahgslp1= NULL  #No.FUN-680088
            LET g_fah[l_ac].fahapr  = 'N'   #FUN-580109
            LET g_fah[l_ac].fahfa1  = 'Y'   #No:FUN-B60140 #FUN-BB0163 N-->Y
            LET g_fah[l_ac].fahfa2  = 'N'   #No:FUN-B60140
            LET g_fah_t.* = g_fah[l_ac].*   #新輸入資料
            CALL i060_set_entry(p_cmd)      #No.FUN-570008
            CALL i060_set_no_entry(p_cmd)   #No.FUN-570008
            CALL cl_show_fld_cont()         #FUN-550037(smin)
            NEXT FIELD fahslip
 
        AFTER INSERT
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fah[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fah[l_ac].* TO s_fah.*
              CALL g_fah.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
            INSERT INTO fah_file(fahslip,fahdesc,fahauno,
                                 #fahdmy5, #FUN-A10109
                                #fahtype,fahprt,fahconf,fahpost,fahdmy3)                                   #FUN-580109 mark
                                 fahtype,fahprt,fahconf,fahpost,fahdmy3,fahdmy32, #FUN-C30313
                                 fahglcr,fahgslp,fahgslp1,fahapr,   #FUN-580109  #No.FUN-670060    #No.FUN-680088  #No:FUN-B60140
                                 fahfa1,fahfa2)  #No:FUN-B60140 
                VALUES(g_fah[l_ac].fahslip,g_fah[l_ac].fahdesc,
                        g_fah[l_ac].fahauno,
                        #g_fah[l_ac].fahdmy5, #FUN-A10109
                        g_fah[l_ac].fahtype,g_fah[l_ac].fahprt,
                        g_fah[l_ac].fahconf,g_fah[l_ac].fahpost,
                       #g_fah[l_ac].fahdmy3)                                           #FUN-580109 mark
                        g_fah[l_ac].fahdmy3,g_fah[l_ac].fahdmy32,g_fah[l_ac].fahglcr,  #FUN-C30313
                        g_fah[l_ac].fahgslp,g_fah[l_ac].fahgslp1,g_fah[l_ac].fahapr,   #FUN-580109  #No.FUN-670060       #No.FUN-680088  #No:FUN-B60140
                        g_fah[l_ac].fahfa1,g_fah[l_ac].fahfa2)  #No:FUN-B60140        
    IF SQLCA.sqlcode THEN
#              CALL cl_err(g_fah[l_ac].fahslip,SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fah_file",g_fah[l_ac].fahslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
              #LET g_fah[l_ac].* = g_fah_t.*
               CANCEL INSERT
            ELSE
               #FUN-A10109  ===S===
               CALL s_access_doc('a',g_fah[l_ac].fahauno,g_fah[l_ac].fahtype,
                                 g_fah[l_ac].fahslip,'AFA','Y')
               #FUN-A10109  ===E===
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
       #AFTER FIELD fahslip
       #    IF NOT cl_null(g_fah[l_ac].fahslip) THEN      #不可空白
       #       LET g_fah[l_ac].fahslip = g_fah_t.fahslip
       #       NEXT FIELD fahslip
       #    END IF
 
       #BEFORE FIELD fahdesc
       #    IF cl_null(g_fah[l_ac].fahslip) THEN      #不可空白
       #       LET g_fah[l_ac].fahslip = g_fah_t.fahslip
       #       NEXT FIELD fahslip
       #    END IF
 
        AFTER FIELD fahslip
          IF NOT cl_null(g_fah[l_ac].fahslip) THEN      #不可空白
            IF g_fah[l_ac].fahslip != g_fah_t.fahslip OR  #check 編號是否重複
              (g_fah[l_ac].fahslip IS NOT NULL AND g_fah_t.fahslip IS NULL) THEN
                SELECT count(*) INTO l_n FROM fah_file
                    WHERE fahslip = g_fah[l_ac].fahslip
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fah[l_ac].fahslip = g_fah_t.fahslip
                    NEXT FIELD fahslip
                END IF
                #NO.FUN-560150 --start--
                FOR l_i = 1 TO g_doc_len
                   IF cl_null(g_fah[l_ac].fahslip[l_i,l_i]) THEN
                      CALL cl_err('','sub-146',0)
                      LET g_fah[l_ac].fahslip = g_fah_t.fahslip
                      NEXT FIELD fahslip
                   END IF
                END FOR
                #NO.FUN-560150 --end--
            END IF
         END IF
        #LET g_fah[l_ac].fahslip=fgl_dialog_getbuffer()  #TQC-670042 mark
        #----------------------TQC-C80094------------------------------(S)
         IF NOT cl_null(g_fah_t.fahslip) THEN
            IF p_cmd='u' AND g_fah[l_ac].fahslip != g_fah_t.fahslip THEN
               LET l_n = 0
               LET l_len = 0
               LET l_len = length(g_fah[l_ac].fahslip)
               CASE WHEN (g_fah_t.fahtype ='1')
                          LET l_sql = "SELECT COUNT(*) FROM faq_file ",
                                      " WHERE faq01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype ='3')
                          LET l_sql = "SELECT COUNT(*) FROM fas_file ",
                                      " WHERE fas01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = '4')
                          LET l_sql = "SELECT COUNT(*) FROM fbe_file ",
                                      " WHERE fbe01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = '5' OR g_fah_t.fahtype = '6')
                          LET l_sql = "SELECT COUNT(*) FROM fbg_file ",
                                      " WHERE fbg01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = '7')
                          LET l_sql = "SELECT COUNT(*) FROM fay_file ",
                                      " WHERE fay01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = '8')
                          LET l_sql = "SELECT COUNT(*) FROM fba_file ",
                                      " WHERE fba01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = '9')
                          LET l_sql = "SELECT COUNT(*) FROM fbc_file ",
                                      " WHERE fbc01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'A')
                          LET l_sql = "SELECT COUNT(*) FROM fau_file ",
                                      " WHERE fau01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'B')
                          LET l_sql = "SELECT COUNT(*) FROM faw_file ",
                                      " WHERE faw01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'C')
                          LET l_sql = "SELECT COUNT(*) FROM fbl_file ",
                                      " WHERE fbl01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'D')
                          LET l_sql = "SELECT COUNT(*) FROM fec_file ",
                                      " WHERE fec01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'E')
                          LET l_sql = "SELECT COUNT(*) FROM fee_file ",
                                      " WHERE fee01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'F')
                          LET l_sql = "SELECT COUNT(*) FROM fgh_file ",
                                      " WHERE fgh01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'H')
                          LET l_sql = "SELECT COUNT(*) FROM fbs_file ",
                                      " WHERE fbs01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'I')
                          LET l_sql = "SELECT COUNT(*) FROM fbo_file ",
                                      " WHERE fbo01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'J')
                          LET l_sql = "SELECT COUNT(*) FROM fbq_file ",
                                      " WHERE fbq01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                    WHEN (g_fah_t.fahtype = 'K')
                          LET l_sql = "SELECT COUNT(*) FROM fbx_file ",
                                      " WHERE fbx01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
               END CASE
               PREPARE i060_fah_pre1 FROM l_sql
               DECLARE i060_fah_cur1 CURSOR FOR i060_fah_pre1
               OPEN i060_fah_cur1
               FETCH i060_fah_cur1 INTO l_n
               IF l_n > 0 THEN
                  CALL cl_err("",'aap-171',0)
                  LET g_fah[l_ac].fahslip = g_fah_t.fahslip
                  DISPLAY BY NAME g_fah[l_ac].fahslip
                  NEXT FIELD fahslip
               END IF
            END IF
         END IF
        #----------------------TQC-C80094------------------------------(E)
         IF g_fah[l_ac].fahslip != g_fah_t.fahslip THEN  #NO:6842
            UPDATE smv_file  SET smv01=g_fah[l_ac].fahslip
             WHERE smv01=g_fah_t.fahslip   #NO:單別
              #AND smv03=g_sys             #NO:系統別  #TQC-670008 remark
               AND upper(smv03)='AFA'      #NO:系統別  #TQC-670008
            IF SQLCA.sqlcode THEN
#               CALL cl_err('UPDATE smv_file',SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("upd","smv_file",g_fah_t.fahslip,g_sys,SQLCA.sqlcode,"","UPDATE smv_file",1)  #No.FUN-660136
                LET l_ac_t = l_ac
                EXIT INPUT
            END IF
            UPDATE smu_file  SET smu01=g_fah[l_ac].fahslip
             WHERE smu01=g_fah_t.fahslip   #NO:單別
               #AND smu03=g_sys             #NO:系統別 #TQC-670008 remark
               AND upper(smu03)='AFA'       #NO:系統別 #TQC-670008
            IF SQLCA.sqlcode THEN
#               CALL cl_err('UPDATE smu_file',SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("upd","smu_file",g_fah_t.fahslip,g_sys,SQLCA.sqlcode,"","UPDATE smu_file",1)  #No.FUN-660136
                LET l_ac_t = l_ac
                EXIT INPUT
            END IF
            #FUN-A10109  ===S===
            CALL s_access_doc('u',g_fah[l_ac].fahauno,g_fah[l_ac].fahtype,
                              g_fah_t.fahslip,'AFA','Y')
            #FUN-A10109 ===E===
         END IF
 
#       AFTER FIELD fahdmy5                #No.FUN-550034
#           IF g_fah[l_ac].fahdmy5 NOT MATCHES '[12]' OR
#              cl_null(g_fah[l_ac].fahdmy5) THEN
#              LET g_fah[l_ac].fahdmy5 = g_fah_t.fahdmy5
#              NEXT FIELD fahdmy5
#           END IF
 
        AFTER FIELD fahtype
           #No:A099
           #IF g_aza.aza26 = '2' THEN   #MOD-660007
           #FUN-A10109 TSD.zeak ===S===
           #IF g_fah[l_ac].fahtype NOT MATCHES '[1-9ABCDEFGH]' THEN
            IF g_fah[l_ac].fahtype NOT MATCHES '[1-9ABCDEFGHIJK]' THEN  #No:FUN-B60140 #FUN-BC0035 add K
               NEXT FIELD fahtype
            END IF
           #----------------------MOD-C70278------------------------------(S)
            IF NOT cl_null(g_fah_t.fahtype) THEN
               IF p_cmd='u' AND g_fah[l_ac].fahtype != g_fah_t.fahtype THEN
                  LET l_n = 0
                  LET l_len = 0
                  LET l_len = length(g_fah[l_ac].fahslip)
                  CASE WHEN (g_fah_t.fahtype ='1')
                             LET l_sql = "SELECT COUNT(*) FROM faq_file ",
                                         " WHERE faq01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype ='3')
                             LET l_sql = "SELECT COUNT(*) FROM fas_file ",
                                         " WHERE fas01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = '4')
                             LET l_sql = "SELECT COUNT(*) FROM fbe_file ",
                                         " WHERE fbe01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = '5' OR g_fah_t.fahtype = '6')
                             LET l_sql = "SELECT COUNT(*) FROM fbg_file ",
                                         " WHERE fbg01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = '7')
                             LET l_sql = "SELECT COUNT(*) FROM fay_file ",
                                         " WHERE fay01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = '8')
                             LET l_sql = "SELECT COUNT(*) FROM fba_file ",
                                         " WHERE fba01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = '9')
                             LET l_sql = "SELECT COUNT(*) FROM fbc_file ",
                                         " WHERE fbc01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'A')
                             LET l_sql = "SELECT COUNT(*) FROM fau_file ",
                                         " WHERE fau01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'B')
                             LET l_sql = "SELECT COUNT(*) FROM faw_file ",
                                         " WHERE faw01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'C')
                             LET l_sql = "SELECT COUNT(*) FROM fbl_file ",
                                         " WHERE fbl01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'D')
                             LET l_sql = "SELECT COUNT(*) FROM fec_file ",
                                         " WHERE fec01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'E')
                             LET l_sql = "SELECT COUNT(*) FROM fee_file ",
                                         " WHERE fee01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'F')
                             LET l_sql = "SELECT COUNT(*) FROM fgh_file ",
                                         " WHERE fgh01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'H')
                             LET l_sql = "SELECT COUNT(*) FROM fbs_file ",
                                         " WHERE fbs01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'I')
                             LET l_sql = "SELECT COUNT(*) FROM fbo_file ",
                                         " WHERE fbo01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'J')
                             LET l_sql = "SELECT COUNT(*) FROM fbq_file ",
                                         " WHERE fbq01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                       WHEN (g_fah_t.fahtype = 'K')
                             LET l_sql = "SELECT COUNT(*) FROM fbx_file ",
                                         " WHERE fbx01[1,",l_len,"] = '",g_fah[l_ac].fahslip,"'"
                  END CASE
                  PREPARE i060_fah_pre FROM l_sql
                  DECLARE i060_fah_cur CURSOR FOR i060_fah_pre
                  OPEN i060_fah_cur
                  FETCH i060_fah_cur INTO l_n
                  IF l_n > 0 THEN
                     CALL cl_err("",'aap-171',0)
                     LET g_fah[l_ac].fahtype = g_fah_t.fahtype
                     DISPLAY BY NAME g_fah[l_ac].fahtype
                     NEXT FIELD fahtype
                  END IF
               END IF
            END IF
           #----------------------MOD-C70278------------------------------(E)
           #FUN-A10109 TSD.zeak ===E===
            CALL i060_set_entry(p_cmd)    #FUN-BB0163 add
            CALL i060_set_no_entry(p_cmd) #FUN-BB0163 add
           #-----MOD-660007---------
           #ELSE
           #   IF g_fah[l_ac].fahtype NOT MATCHES '[1-9ABCDEFG]' THEN
           #      NEXT FIELD fahtype
           #   END IF
           #END IF
           #-----END MOD-660007-----
           #end No:A099
           #CALL i060_fahtype(g_fah[l_ac].fahtype,l_ac)

        #NO.FUN-670060---start---
        BEFORE FIELD fahdmy3
            CALL i060_set_entry(p_cmd)
 
        AFTER FIELD fahdmy3
           IF g_fah[l_ac].fahdmy3 = 'Y' and g_fah[l_ac].fahconf ='Y' THEN
              CALL cl_err(g_fah[l_ac].fahdmy3,'afa-343',0)
              LET g_fah[l_ac].fahdmy3  = g_fah_t.fahdmy3
              DISPLAY BY NAME g_fah[l_ac].fahdmy3
              NEXT FIELD fahconf 
           END IF    
#No.FUN-670060 --start--                 
           IF  g_fah[l_ac].fahdmy3 = 'N' THEN
               LET g_fah[l_ac].fahglcr = 'N'    #No.FUN-670060 
              #LET g_fah[l_ac].fahgslp = NULL   #FUN-B90004 mark    #No.FUN-670060 
              #LET g_fah[l_ac].fahgslp1 = NULL  #FUN-B90004 mark    #No.FUN-680088
               CALL i060_set_no_entry(p_cmd)
           END IF

       #FUN-A10109 TSD.zeak ===S===
        BEFORE FIELD fahtype 
           IF p_cmd <> 'u' THEN                                          #MOD-C70278 add
              CALL s_getgee('afai060',g_lang,'fahtype') #FUN-A10109
           END IF                                                        #MOD-C70278 add
       #FUN-A10109 TSD.zeak ===E===

       #FUN-B90004--Begin--
        ON CHANGE fahdmy3
           IF g_fah[l_ac].fahdmy3 = 'N' THEN 
              LET g_fah[l_ac].fahglcr = 'N'
              DISPLAY BY NAME g_fah[l_ac].fahglcr
           END IF
       #FUN-B90004---End---
 
       #FUN-C30313---add---START
        BEFORE FIELD fahdmy32
           IF g_fah[l_ac].fahfa2 = 'Y' THEN
              CALL i060_set_entry(p_cmd)
           ELSE
              CALL i060_set_no_entry(p_cmd)
           END IF
       #FUN-C30313---add---END
 
        BEFORE FIELD fahglcr   #No.FUN-670060 
             CALL i060_set_entry(p_cmd)
        AFTER FIELD fahglcr
             IF g_fah[l_ac].fahglcr = 'N' THEN
            #LET g_fah[l_ac].fahgslp = NULL      #FUN-B90004
            #LET g_fah[l_ac].fahgslp1= NULL      #FUN-B90004      #No.FUN-680088
             CALL i060_set_no_entry(p_cmd)
             END IF
            #No.MOD-740122--begin--
            #IF g_fah[l_ac].fahglcr = 'Y' THEN
            #CALL cl_set_comp_required("fahgslp,fahgslp1",TRUE) 
            #END IF
             IF g_fah[l_ac].fahglcr = 'Y' THEN
                CALL cl_set_comp_required("fahgslp",TRUE)
               #IF g_aza.aza63='Y' THEN     #NO.FUN-AB0088
                IF g_faa.faa31 ='Y' THEN
                   CALL cl_set_comp_required("fahgslp1",TRUE)
                END IF
            #FUN-B90004--Begin--
             ELSE
               CALL cl_set_comp_required("fahgslp",FALSE)
              #IF g_aza.aza63 = 'Y' THEN                #FUN-B90004 Mark 
               IF g_faa.faa31 = 'Y' THEN                #FUN-B90004
                 CALL cl_set_comp_required("fahgslp1",FALSE)
               END IF
              #FUN-B90004---End---
             END IF
            #No.MOD-740122--end--
#No.FUN-670060 --end--   
        AFTER FIELD fahgslp                                                                                                         
           IF NOT cl_null(g_fah[l_ac].fahgslp) THEN                                                                               
#TQC-B60145   ---start   Add
              LET l_str = g_fah[l_ac].fahgslp
             #---------------------MOD-C10210------------------------start
              LET lc_doc_set = g_aza.aza102
              CASE lc_doc_set
                 WHEN "1"   LET g_doc_len2 = 3
                 WHEN "2"   LET g_doc_len2 = 4
                 WHEN "3"   LET g_doc_len2 = 5
              END CASE
             #IF l_str.getlength() > g_doc_len THEN
              IF l_str.getlength() > g_doc_len2 THEN
             #---------------------MOD-C10210--------------------------end
                 CALL cl_err(g_fah[l_ac].fahgslp,'sub-141',1)
                 NEXT FIELD fahgslp
              END IF
#TQC-B60145   ---end     Add
              SELECT aac01 FROM aac_file                                                                                            
                 WHERE aac01=g_fah[l_ac].fahgslp AND aacacti = 'Y' AND aac11='1'                                                  
              IF SQLCA.sqlcode THEN                                                                                                 
                 CALL cl_err3("sel","aac_file",g_fah[l_ac].fahgslp,"",SQLCA.sqlcode,"","",1)                                      
                 NEXT FIELD fahgslp                                                                                                 
              END IF                                                                                                                
           END IF                    
 
        #No.FUN-680088 --begin
        AFTER FIELD fahgslp1
           IF NOT cl_null(g_fah[l_ac].fahgslp1) THEN                                                                               
#TQC-B60145   ---start   Add
              LET l_str = g_fah[l_ac].fahgslp1
             #---------------------MOD-C10210------------------------start
              LET lc_doc_set = g_aza.aza102
              CASE lc_doc_set
                 WHEN "1"   LET g_doc_len2 = 3
                 WHEN "2"   LET g_doc_len2 = 4
                 WHEN "3"   LET g_doc_len2 = 5
              END CASE
             #IF l_str.getlength() > g_doc_len THEN
              IF l_str.getlength() > g_doc_len2 THEN
             #---------------------MOD-C10210--------------------------end
                 CALL cl_err(g_fah[l_ac].fahgslp1,'sub-141',1)
                 NEXT FIELD fahgslp1
              END IF
#TQC-B60145   ---end     Add
              SELECT aac01 FROM aac_file                                                                                            
                 WHERE aac01=g_fah[l_ac].fahgslp1 AND aacacti = 'Y' AND aac11='1'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","aac_file",g_fah[l_ac].fahgslp1,"",SQLCA.sqlcode,"","",1)
                 NEXT FIELD fahgslp1
              END IF                                                                                                                
           END IF                    
        #No.FUN-680088 --end
 
       #start FUN-580109
       #FUN-640243
       # ON CHANGE fahconf
       #    IF g_fah[l_ac].fahconf = 'Y' THEN
       #       LET g_fah[l_ac].fahapr = 'N'
       #       DISPLAY BY NAME g_fah[l_ac].fahapr
       #    END IF
 
       # ON CHANGE fahapr
       #    IF g_fah[l_ac].fahapr = 'Y' THEN
       #       LET g_fah[l_ac].fahconf = 'N'
       #       DISPLAY BY NAME g_fah[l_ac].fahconf
       #    END IF
       #END FUN-640243
       #end FUN-580109

       #str MOD-B30162 add
        BEFORE FIELD fahconf
           CALL i060_set_entry(p_cmd)

        ON CHANGE fahconf
           IF g_fah[l_ac].fahconf = 'N' THEN 
              LET g_fah[l_ac].fahpost = 'N'
              DISPLAY BY NAME g_fah[l_ac].fahpost 
           END IF

        AFTER FIELD fahconf
           IF g_fah[l_ac].fahconf = 'N' THEN 
              LET g_fah[l_ac].fahpost = 'N'
              CALL i060_set_no_entry(p_cmd)
           END IF
           
       #end MOD-B30162 add
 
       #No.MOD-C70028  --Begin
       AFTER FIELD fahfa2
          DISPLAY BY NAME g_fah[l_ac].fahfa2
       #No.MOD-C70028  --End

       #-----NO.TQC-870044-----
        ON CHANGE fahpost
           IF g_fah[l_ac].fahpost = "Y" THEN
              IF g_fah[l_ac].fahapr = "Y" THEN
                 CALL cl_err('','afa-358',0)
                 LET g_fah[l_ac].fahpost = "N"
                 NEXT FIELD fahpost
              END IF
           END IF
 
        ON CHANGE fahapr
           IF g_fah[l_ac].fahapr = "Y" THEN
             IF g_fah[l_ac].fahpost = "Y" THEN
                CALL cl_err('','afa-358',0)
                LET g_fah[l_ac].fahapr = "N"
                NEXT FIELD fahapr
             END IF
           END IF
 
      #-----END NO.TQC-870044----
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_fah_t.fahslip IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
               #----------------------TQC-C80094------------------------------(S)
                LET l_n = 0
                LET l_len = 0
                LET l_len = length(g_fah[l_ac].fahslip)
                CASE WHEN (g_fah_t.fahtype ='1')
                           LET l_sql = "SELECT COUNT(*) FROM faq_file ",
                                       " WHERE faq01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype ='3')
                           LET l_sql = "SELECT COUNT(*) FROM fas_file ",
                                       " WHERE fas01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = '4')
                           LET l_sql = "SELECT COUNT(*) FROM fbe_file ",
                                       " WHERE fbe01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = '5' OR g_fah_t.fahtype = '6')
                           LET l_sql = "SELECT COUNT(*) FROM fbg_file ",
                                       " WHERE fbg01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = '7')
                           LET l_sql = "SELECT COUNT(*) FROM fay_file ",
                                       " WHERE fay01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = '8')
                           LET l_sql = "SELECT COUNT(*) FROM fba_file ",
                                       " WHERE fba01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = '9')
                           LET l_sql = "SELECT COUNT(*) FROM fbc_file ",
                                       " WHERE fbc01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'A')
                           LET l_sql = "SELECT COUNT(*) FROM fau_file ",
                                       " WHERE fau01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'B')
                           LET l_sql = "SELECT COUNT(*) FROM faw_file ",
                                       " WHERE faw01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'C')
                           LET l_sql = "SELECT COUNT(*) FROM fbl_file ",
                                       " WHERE fbl01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'D')
                           LET l_sql = "SELECT COUNT(*) FROM fec_file ",
                                       " WHERE fec01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'E')
                           LET l_sql = "SELECT COUNT(*) FROM fee_file ",
                                       " WHERE fee01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'F')
                           LET l_sql = "SELECT COUNT(*) FROM fgh_file ",
                                       " WHERE fgh01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'H')
                           LET l_sql = "SELECT COUNT(*) FROM fbs_file ",
                                       " WHERE fbs01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'I')
                           LET l_sql = "SELECT COUNT(*) FROM fbo_file ",
                                       " WHERE fbo01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'J')
                           LET l_sql = "SELECT COUNT(*) FROM fbq_file ",
                                       " WHERE fbq01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                     WHEN (g_fah_t.fahtype = 'K')
                           LET l_sql = "SELECT COUNT(*) FROM fbx_file ",
                                       " WHERE fbx01[1,",l_len,"] = '",g_fah_t.fahslip,"'"
                END CASE
                PREPARE i060_fah_pre2 FROM l_sql
                DECLARE i060_fah_cur2 CURSOR FOR i060_fah_pre2
                OPEN i060_fah_cur2
                FETCH i060_fah_cur2 INTO l_n
                IF l_n > 0 THEN
                   CALL cl_err("",'aap-171',0)
                   LET g_fah[l_ac].fahslip = g_fah_t.fahslip
                   DISPLAY BY NAME g_fah[l_ac].fahslip
                   NEXT FIELD fahslip
                END IF
               #----------------------TQC-C80094------------------------------(E)
                INITIALIZE g_doc.* TO NULL                  #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "fahslip"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_fah[l_ac].fahslip      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                                #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM fah_file WHERE fahslip = g_fah_t.fahslip
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fah_t.fahslip,SQLCA.sqlcode,0)    #No.FUN-660136
                   CALL cl_err3("del","fah_file",g_fah_t.fahslip,g_sys,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                DELETE FROM smv_file WHERE smv01 = g_fah_t.fahslip
                    #AND smv03=g_sys  #NO:6842  #TQC-670008 remark
                    AND upper(smv03)='AFA'      #TQC-670008
                IF SQLCA.sqlcode THEN
#                  CALL cl_err('fav_file',SQLCA.sqlcode,0)   #No.FUN-660136
                   CALL cl_err3("del","smv_file",g_fah_t.fahslip,g_sys,SQLCA.sqlcode,"","fav_file",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                DELETE FROM smu_file WHERE smu01 = g_fah_t.fahslip
                   #AND smu03=g_sys   #NO:6842  #TQC-670008 remark
                   AND upper(smu03)='AFA'       #TQC-670008
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_fah_t.fahslip,SQLCA.sqlcode,0)   #No.FUN-660136
                   CALL cl_err3("del","smu_file",g_fah_t.fahslip,g_sys,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
 
                #FUN-A10109  ===S===
                CALL s_access_doc('r','','',g_fah_t.fahslip,'AFA','')
                #FUN-A10109  ===E===
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i060_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_fah[l_ac].* = g_fah_t.*
            CLOSE i060_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fah[l_ac].fahslip,-263,1)
             LET g_fah[l_ac].* = g_fah_t.*
         ELSE
            UPDATE fah_file SET
                   fahslip=g_fah[l_ac].fahslip,fahdesc=g_fah[l_ac].fahdesc,
                   fahauno=g_fah[l_ac].fahauno, 
                   #fahdmy5=g_fah[l_ac].fahdmy5, #FUN-A10109
                   fahtype=g_fah[l_ac].fahtype, fahprt=g_fah[l_ac].fahprt,
                   fahconf=g_fah[l_ac].fahconf, fahpost=g_fah[l_ac].fahpost,
                   fahdmy3=g_fah[l_ac].fahdmy3,fahdmy32=g_fah[l_ac].fahdmy32,fahglcr =g_fah[l_ac].fahglcr,  #No.FUN-670060 #FUN-C30313 
                   fahgslp=g_fah[l_ac].fahgslp,fahgslp1=g_fah[l_ac].fahgslp1,      #No.FUN-680088
                   fahapr =g_fah[l_ac].fahapr,#No:FUN-B60140   #FUN-580108
                   fahfa1 =g_fah[l_ac].fahfa1,fahfa2=g_fah[l_ac].fahfa2  #No:FUN-B60140
             WHERE fahslip= g_fah_t.fahslip
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fah[l_ac].fahslip,SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("upd","fah_file",g_fah_t.fahslip,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                LET g_fah[l_ac].* = g_fah_t.*
             ELSE
                CALL s_access_doc('a',g_fah[l_ac].fahauno,g_fah[l_ac].fahtype,         #MOD-C50099 add
                                  g_fah[l_ac].fahslip,'AFA','Y')                       #MOD-C50099 add
                MESSAGE 'UPDATE O.K'
                CLOSE i060_bcl
                COMMIT WORK
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_fah[l_ac].* = g_fah_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_fah.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
              END IF
              CLOSE i060_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #FUN-BB0163-----being add
           IF g_fah[l_ac].fahfa1='N' AND g_fah[l_ac].fahfa2='N' THEN
              CALL cl_err('','afa-418',0)
              NEXT FIELD fahfa1
           END IF
           #FUN-BB0163-----end add            
         # LET g_fah_t.* = g_fah[l_ac].*
           LET l_ac_t = l_ac
           CLOSE i060_bcl
           COMMIT WORK
           #CKP2
           CALL g_fah.deleteElement(g_rec_b+1)
 
#No.FUN-670060 --start--                                                                                                            
        ON ACTION controlp                                                                                                          
           CASE                                                                                                                     
               WHEN INFIELD(fahgslp)    
                    # 得出總帳 database name                                                                                             
                    # g_faa.faa02p -> g_plant_new -> s_getdbs() -> g_dbs_new -->                                                         
                     LET g_plant_new= g_faa.faa02p                                                                                       
                     CALL s_getdbs()                                                                                                     
                     LET g_dbs_gl=g_dbs_new CLIPPED                                                                                             
                     LET g_plant_gl = g_faa.faa02p     #No.FUN-980059
                    IF g_aaz.aaz70 MATCHES '[yY]' THEN                                                                              
                   #   CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_fah[l_ac].fahgslp,'1',' ',g_user,'AGL')   #MOD-8B0024 mod    #No.FUN-980059
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_fah[l_ac].fahgslp,'1',' ',g_user,'AGL')   #MOD-8B0024 mod  #No.FUN-980059
                       RETURNING g_fah[l_ac].fahgslp                                                                              
                    ELSE                                                                                                            
                  #    CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_fah[l_ac].fahgslp,'1',' ',' ','AGL')   #MOD-8B0024 mod       #No.FUN-980059
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_fah[l_ac].fahgslp,'1',' ',' ','AGL')   #MOD-8B0024 mod     #No.FUN-980059
                       RETURNING g_fah[l_ac].fahgslp                                                                              
                    END IF                                                                                                          
                    DISPLAY BY NAME g_fah[l_ac].fahgslp                                                                           
                    NEXT FIELD fahgslp                                                                                              
               #No.FUN-680088 --begin
               WHEN INFIELD(fahgslp1)
                    # 得出總帳 database name                                                                                             
                    # g_faa.faa02p -> g_plant_new -> s_getdbs() -> g_dbs_new -->                                                         
                     LET g_plant_new= g_faa.faa02p                                                                                       
                     CALL s_getdbs()                                                                                                     
                     LET g_dbs_gl=g_dbs_new CLIPPED                                                                                             
                    IF g_aaz.aaz70 MATCHES '[yY]' THEN                                                                              
                 #     CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_fah[l_ac].fahgslp1,'1',' ',g_user,'AGL')   #MOD-8B0024 mod    #No.FUN-980059
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_fah[l_ac].fahgslp1,'1',' ',g_user,'AGL')   #MOD-8B0024 mod  #No.FUN-980059
                       RETURNING g_fah[l_ac].fahgslp1                                                                              
                    ELSE                                                                                                            
                 #     CALL q_m_aac(FALSE,TRUE,g_dbs_gl,g_fah[l_ac].fahgslp1,'1',' ',' ','AGL')   #MOD-8B0024 mod       #No.FUN-980059
                       CALL q_m_aac(FALSE,TRUE,g_plant_gl,g_fah[l_ac].fahgslp1,'1',' ',' ','AGL')   #MOD-8B0024 mod     #No.FUN-980059
                       RETURNING g_fah[l_ac].fahgslp1                                                                              
                    END IF                                                                                                          
                    DISPLAY BY NAME g_fah[l_ac].fahgslp1                                                                           
                    NEXT FIELD fahgslp1                                                                                              
                #No.FUN-680088 --end
               OTHERWISE EXIT CASE                                                                                                  
           END CASE                                                                                                                 
#No.FUN-670060 --end--          
 
        ON ACTION CONTROLN
            CALL i060_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fahslip) AND l_ac > 1 THEN
                LET g_fah[l_ac].* = g_fah[l_ac-1].*
                NEXT FIELD fahslip
            END IF
 
        ON ACTION set_user      #bug no:4948,NO:6842
           # Genero改為不只第一個欄位可用
           # CASE
           #     WHEN INFIELD(fahslip)
                  #LET g_fah[l_ac].fahslip=fgl_dialog_getbuffer()  #TQC-670042 mark
                IF NOT cl_null(g_fah[l_ac].fahslip) THEN
                    LET g_action_choice="set_user"    #No.MOD-4B0088
                   IF cl_chk_act_auth()
                  #THEN CALL s_smu(g_fah[l_ac].fahslip,g_sys) #TQC-660133 remark
                   THEN CALL s_smu(g_fah[l_ac].fahslip,"AFA") #TQC-660133
                   END IF
                ELSE
                   CALL cl_err('','anm-217',0)
                END IF
           #END CASE
 
        ON ACTION set_dept      #NO:6842
           # Genero改為不只第一個欄位可用
           #CASE
           #     WHEN INFIELD(fahslip)
                  #LET g_fah[l_ac].fahslip=fgl_dialog_getbuffer()  #TQC-670042 mark
                  IF NOT cl_null(g_fah[l_ac].fahslip) THEN
                      LET g_action_choice="set_dept"    #No.MOD-4B0088
                     IF cl_chk_act_auth() THEN
                       #CALL s_smv(g_fah[l_ac].fahslip,g_sys) #TQC-660133 remark
                        CALL s_smv(g_fah[l_ac].fahslip,"AFA") #TQC-660133
                     END IF
                  ELSE
                     CALL cl_err('','anm-217',0)
                  END IF
          # END CASE
 
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
 
    CLOSE i060_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i060_b_askkey()
    CLEAR FORM
   CALL g_fah.clear()
    CONSTRUCT g_wc2 ON fahslip,fahdesc,fahauno,
                       #fahdmy5,#FUN-A10109
                       fahtype,fahfa1,fahfa2,fahprt,  #No:FUN-B60140
                       fahconf,fahpost,fahdmy3,fahdmy32,fahglcr,fahgslp,fahgslp1,      #No.FUN-680088 #FUN-C30313
                       fahapr      #FUN-580109  #No.FUN-670060 
            FROM s_fah[1].fahslip,s_fah[1].fahdesc,s_fah[1].fahauno,
                 #s_fah[1].fahdmy5, #FUN-A10109
                 s_fah[1].fahtype,s_fah[1].fahfa1,s_fah[1].fahfa2,s_fah[1].fahprt, #No:FUN-B60140
                 s_fah[1].fahconf,s_fah[1].fahpost,s_fah[1].fahdmy3,s_fah[1].fahdmy32, #FUN-C30313
                 s_fah[1].fahglcr,s_fah[1].fahgslp,s_fah[1].fahgslp1,      #No.FUN-680088
                 s_fah[1].fahapr   #FUN-580109
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    LET g_fah_pafaho = 1
    CALL i060_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i060_b_fill(p_wc2)             #BODY FILL UP
DEFINE
    p_wc2 LIKE type_file.chr1000        #No.FUN-680070 VARCHAR(200)
 
    LET g_sql =
        "SELECT fahslip,fahdesc,fahauno,",
        #"      fahdmy5,", #FUN-A10109
        "       fahtype,fahfa1,fahfa2,fahprt,",  #No:FUN-B60140
        "       fahconf,fahpost,fahdmy3,fahdmy32,fahglcr,fahgslp,fahgslp1",  #No.FUN-670060  #No.FUN-680088 #FUN-C30313
        "      ,fahapr ",   #FUN-580109
        " FROM fah_file",
        " WHERE ", p_wc2 CLIPPED,       #單身
        " ORDER BY 1"
    PREPARE i060_pb FROM g_sql
    DECLARE fah_curs CURSOR FOR i060_pb
 
    CALL g_fah.clear()
 
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH fah_curs INTO g_fah[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,0)
         EXIT FOREACH
      END IF
     #CALL i060_fahdesc(g_fah[g_cnt].fahdesc,g_cnt)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
    END FOREACH
    MESSAGE ""
    CALL g_fah.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i060_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fah TO s_fah.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
 
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
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #No:A099
         #-----MOD-660007---------
         #IF g_aza.aza26 = '2' THEN
         #   CALL i060_set_comb()
         #END IF
         #-----END MOD-660007-----
         #end No:A099
 
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
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE      #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i060_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-680070 SMALLINT
        l_name          LIKE type_file.chr1000, # External(Disk) file name     #No.FUN-680070 VARCHAR(20)
        l_za05          LIKE type_file.chr1000, #No.FUN-680070 VARCHAR(40)
        sr    RECORD LIKE fah_file.*
 
    IF g_wc2 IS NULL THEN
#      CALL cl_err('',-400,0) RETURN END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('afai060') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * ",   #組合出 SQL 指令
              "  FROM fah_file ",
              " WHERE ",g_wc2 CLIPPED
#No.FUN-780037-----Begin
#   PREPARE i060_p1 FROM g_sql                 # RUNTIME 編譯
#   DECLARE i060_co                            # SCROLL CURSOR
#        CURSOR FOR i060_p1
 
#   START REPORT i060_rep TO l_name
 
#   FOREACH i060_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,0) 
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i060_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i060_rep
 
#   CLOSE i060_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-780037-----End
END FUNCTION
#No.FUN-780037-----Begin
{
REPORT i060_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680070 VARCHAR(1),
        sr   RECORD LIKE fah_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fahtype,sr.fahslip
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                  g_x[38],g_x[39],g_x[40],g_x[41],g_x[43],g_x[42]   #FUN-580109 增加需簽核欄位      #No.FUN-680088
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
          PRINT COLUMN g_c[31],sr.fahslip,
                COLUMN g_c[32],sr.fahdesc,
                COLUMN g_c[33],sr.fahauno,
                COLUMN g_c[34],sr.fahdmy5, 
                COLUMN g_c[35],sr.fahtype,
                COLUMN g_c[36],sr.fahprt,
                COLUMN g_c[37],sr.fahconf,
                COLUMN g_c[38],sr.fahpost,
                COLUMN g_c[39],sr.fahdmy3,
                COLUMN g_c[40],sr.fahglcr, #No.FUN-670060 
                COLUMN g_c[41],sr.fahgslp, #No.FUN-670060 
                COLUMN g_c[43],sr.fahgslp1,#No.FUN-680088
                COLUMN g_c[42],sr.fahapr   #FUN-580109 增加需簽核欄位
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-780037------End
#No:A099
#-----MOD-660007---------
#FUNCTION i060_set_comb()
#  DEFINE comb_value STRING
#  DEFINE comb_item  STRING
# 
#    LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H'
#    CALL cl_getmsg('afa-390',g_lang) RETURNING comb_item
#    CALL cl_set_combo_items('fahtype',comb_value,comb_item)
#END FUNCTION
#-----END MOD-660007-----
#end No:A099
 
#-----No.FUN-570008-----
FUNCTION i060_set_entry(p_cmd)
 DEFINE   p_cmd     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
#No.FUN-670060 --start--  
   IF INFIELD(fahdmy3) OR (NOT g_before_input_done) THEN                                                                            
      CALL cl_set_comp_entry("fahglcr",TRUE)                                                                                        
     #CALL cl_set_comp_entry("fahgslp,fahgslp1",TRUE)      #FUN-B90004 mark #No.FUN-680088
   END IF                     
   IF INFIELD(fahglcr) OR (NOT g_before_input_done) THEN                                                                            
      CALL cl_set_comp_entry("fahgslp,fahgslp1",TRUE)      #No.FUN-680088
   END IF 
  #FUN-B90004--Begin--
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("fahgslp,fahgslp1",TRUE)
   END IF
  #FUN-B90004---End---
#No.FUN-670060 --start--  
   IF p_cmd = 'a' THEN                                                                                                              
      CALL cl_set_comp_entry("fahslip",TRUE)                                                                                        
   END IF                                       
  #str MOD-B30162 add
   IF INFIELD(fahconf) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fahpost",TRUE)
   END IF
  #end MOD-B30162 add
   #FUN-BB0163-----being add
   IF g_fah[l_ac].fahtype MATCHES '[789H]' THEN
      CALL cl_set_comp_entry("fahfa1,fahfa2",TRUE)
   END IF 
   #FUN-BB0163-----end add

  #FUN-C30313---add---START
   IF g_fah[l_ac].fahfa2 = 'Y' THEN
     CALL cl_set_comp_entry("fahdmy32",TRUE)
   END IF
  #FUN-C30313---add---END

END FUNCTION
 
FUNCTION i060_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
  #FUN-B90004--Begin Mark--
  #IF p_cmd = 'u' AND g_chkey = 'N' THEN
  #   CALL cl_set_comp_entry("fahslip",FALSE)
  #END IF
  #FUN-B90004---End Mark--
 
#No.FUN-670060 --start-- 
   IF INFIELD(fahdmy3) OR (NOT g_before_input_done) THEN                                                           
      IF g_fah[l_ac].fahdmy3 = "N" THEN   
         CALL cl_set_comp_entry("fahglcr",FALSE)
        #CALL cl_set_comp_entry("fahgslp,fahgslp1",FALSE)      #FUN-B90004 #No.FUN-680088
      END IF                                                                                                                        
   END IF                                                                                                  
  #FUN-B90004--Begin--
  #IF INFIELD(fahglcr) OR (NOT g_before_input_done) THEN 
  #   IF g_fah[l_ac].fahglcr = "N" THEN 
  #      CALL cl_set_comp_entry("fahgslp,fahgslp1",FALSE)       #No.FUN-680088
  #   END IF 
  #FUN-B90004---End---

  #No.FUN-670060 --
  #str MOD-B30162 add
   IF INFIELD(fahconf) OR (NOT g_before_input_done) THEN
      IF g_fah[l_ac].fahconf = "N" THEN                                                                                    
         CALL cl_set_comp_entry("fahpost",FALSE)
      END IF
   END IF
  #end MOD-B30162 add
   #FUN-BB0163-----being add
   IF g_fah[l_ac].fahtype NOT MATCHES '[789H]' THEN
      LET g_fah[l_ac].fahfa1 = 'Y'
      LET g_fah[l_ac].fahfa2 ='Y'
      #No.MOD-C70028  --Begin
      DISPLAY BY NAME g_fah[l_ac].fahfa1
      DISPLAY BY NAME g_fah[l_ac].fahfa2
      #No.MOD-C70028  --End  
      CALL cl_set_comp_entry("fahfa1,fahfa2",FALSE)
   END IF 
   #FUN-BB0163-----end add

  #FUN-C30313---add---START
   IF g_fah[l_ac].fahfa2 = 'N' THEN
      LET g_fah[l_ac].fahdmy32 = 'N'
      CALL cl_set_comp_entry("fahdmy32",FALSE)
   END IF
  #FUN-C30313---add---END

END FUNCTION
#-----No.FUN-570008 END-----
 
#Patch....NO.MOD-5A0095 <> #
