# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saimi103.4gl
# Descriptions...: 料件基本資料維護作業-採購資料
# Date & Author..: 91/11/01 By Wu
#             註 : 於 _u()之後,更新相關的TABLE pmh_file,pmi_file 92/01/23 BY Lin
#------MODIFICATIION-------MODIFICATION-------MODIFIACTION-------
# 1992/04/30 David: Add field ima531
# 1992/06/18 Lin: 畫面上增加 [採購資料處理狀況](ima93[3,3])的input查詢
# 1992/10/13 Lee: 增加再補貨量的維護(ima99)
#------BugFIXED------------BugFIXED-----------BugFIXED-----------
# 1993/08/09 Pin: 採購期間數&期間月數,則不可兩者皆為零
#                 最近期間採購日期應修改
#                  By Melody    來源碼為'M'時,補貨策略改為可選0.再訂購點
#                  97/07/31     By Melody  pmi_file 取消
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-4A0026 04/10/04 By Smapmin imi103 檢驗碼 'Y' 但 aimi103 檢驗碼 'Null'
# Modify.........: No.FUN-4A0041 04/10/06 By Echo 料號開窗
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/28 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-630040 06/03/14 By Nicola 加入ima913,ima914二個欄位
# Modify.........: No.MOD-640061 06/04/09 By Nicola 勾選[統購否]後,開窗登打[採購中心代碼]挑選其一後,其後面的簡稱不會帶入!
#                                                   將原已勾選的[統購否]清空後,[採購中心代碼及其簡稱]不會自動清空!
# Modify.........: No.FUN-650022 06/05/23 By kim 建議如果有使用計價單位,是否可以在 ima91(平均單價)/ima53(最新單價)/ima531(市價),將單位基礎show 出來
# Modify.........: No.FUN-650134 06/05/25 By Sarah 當庫存單位與採購單位不同時，應Default帶出"採購/庫存單位換算率"
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/13 By rainy 連續二次查詢key值時,若第二次查詢不到key值時, 會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/15 By Carrier 欄位型態用LIKE定義
# Modify.........: NO.FUN-680129 06/09/15 By rainy 多單位且為母子單位時，採購單位=庫存單位且不能修改
# Modify.........: No.FUN-680046 06/10/11 By jamie 1.FUNCTION aimi103()_q 一開始應清空g_ima.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740088 07/04/13 By chenl   安全存量不可為負數。
# Modify.........: No.FUN-740176 07/04/24 By kim 廠商基本資料設定在「停止交易」時，料件主檔的「主要供應商」應該就不可輸入才對。
# Modify.........: No.MOD-7A0102 07/10/18 By Carol 調整圖形顯示
# Modify.........: NO.MOD-7A0192 07/10/30 BY yiting 按action "建立料件單位轉換"  應該帶料號至開啟視窗中
# Modify.........: NO.FUN-810016 08/01/14 By ve007 增加采購收貨替代欄位
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840029 08/04/21 By sherry 報表改由CR輸出
# Modify.........: No.FUN-850115 08/05/21 BY DUKE ADD APS料件供應商 ACTION
# Modify.........: No.FUN-870012 08/06/23 BY DUKE
# Modify.........: No.CHI-860042 08/07/17 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.FUN-860085 08/07/29 By sherry 增加維護計價單位
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.TQC-910003 09/01/03 BY DUKE MOVE OLD APS TABLE
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-930078 09/03/13 By Duke REMOVE APS ACTION
# Modify.........: No.FUN-930108 09/03/24 By zhaijie添加ima926-"AVL否"欄位
# Modify.........: No.MOD-940255 09/05/21 By Pengu 廠商代號自行輸入後按enter沒有show簡稱
# Modify.........: No.TQC-980279 09/08/28 By sherry ima913不可以為NULL         
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.TQC-9B0071 09/11/17 By sherry ima150,ima152 給default
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No.MOD-A60092 10/06/14 By Sarah 若找不到新供應商資料,應新增一筆新供應商的pmh_file資料,然後將舊供應商的pmh03改為N
# Modify.........: No.FUN-A50011 10/07/12 By yangfeng 添加aimi100中對子料件的更新 
# Modify.........: No.FUN-A80063 10/08/13 By wujie    添加aimi100中ima101和ima102的item
# Modify.........: No.FUN-A90017 10/09/09 By yinhy 畫面增加一個欄位,電子採購料件,IF aza95="N" THEN 此欄位不可視
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號)
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No:FUN-AB0025 11/11/10 By lixh1  開窗BUG處理
# Modify.........: No.TQC-AB0195 10/12/01 By chenying 在錄入時管控主要供應商資料是否已審核
# Modify.........: No.MOD-AC0161 10/12/18 By vealxu call 's_upd_ima_subparts('的程式段，都要先判斷如果行業別是鞋服業才做
# Modify.........: No:TQC-AC0406 10/12/31 By baogc 添加對ima914欄位的控管
# Modify.........: No:TQC-B20007 11/02/12 By destiny show的时候未显示oriu,orig
# Modify.........: No:MOD-B30316 11/03/16 By Pengu 修改單位批量時，應檢核與最小數量合理性
# Modify.........: No.CHI-B70017 11/07/12 By jason ICD "PO對Blanket PO替代原則"欄位要隱藏
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
# Modify.........: No.FUN-B90102 11/10/18 By qiaozy 服飾開發：子料件不可修改，母料件需要把ima資料更新到子料件中
# Modify.........: No:FUN-BB0086 11/11/29 By tanxc 增加數量欄位小數取位
# Modify.........: No.FUN-B80032 11/12/15 By yangxf ima_file 更新揮寫rtepos

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30075 12/03/09 by Elise insert into pmh_file段，pmh08給固定值N的部分，改給ima24
# Modify.........: No:MOD-C40093 12/04/13 By Elise 判斷有錯時LET l_flag='Y' 做完DISPLAY BY NAME的動作後,直接NEXT FIELD當下欄位.
# Modify.........: No.TQC-C40155 12/04/18 By xianghui 修改時點取消，還原成舊值的處理
# Modify.........: No.TQC-C40219 12/04/24 By xianghui 修正TQC-C40155的問題
# Modify.........: No.TQC-C50253 12/05/31 By lixh1 補貨策略=’5’時,ima88/ima89/ima90設置為必須欄位
# Modify.........: No.MOD-C90164 12/10/11 By Elise 修正 MOD-C30075
# Modify.........: No.MOD-C90232 12/10/12 By Elise 未更新有碼效，故將CHI-910021修改部分mark
# Modify.........: No.MOD-CA0001 12/10/12 By Elise 主要供應商清空後，不將該廠商有效碼設為N
# Modify.........: No.CHI-C50068 12/11/06 By bart 增加MRP允許交期延後天數
# MOdify.........: No.FUN-C90100 12/10/09 By xianghui 增加ima171和ima172兩個欄位
# MOdify.........: No.MOD-D40034 13/04/09 By bart 預設「檢驗程度」、「檢驗水準」、「級數」
# Modify.........: No.CHI-D30005 13/04/09 By Elise 串查apmi600第一個參數g_argv1為廠商代號,第二個g_argv2為執行功能
# Modify.........: No.160525 16/05/25     By guanyao 采购员可以录入多个，批次修改采购员

DATABASE ds
 
#GLOBALS "../../config/top.global"#mark by guanyao160525
GLOBALS "../../../tiptop/config/top.global"#add by guanyao160525
GLOBALS "../../../tiptop/aim/4gl/aimi100.global"
GLOBALS "../../../tiptop/sub/4gl/s_data_center.global"   #No.FUN-7C0010

GLOBALS
   DEFINE g_iml01         LIKE iml_file.iml01    #類別代號 (假單頭)
END GLOBALS
 
  DEFINE
    g_argv1       LIKE ima_file.ima01,
    b_ima         DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                  b_ima01  LIKE ima_file.ima01,   #料件編號
                  b_ima02  LIKE ima_file.ima02,   #品名
                  b_ima021 LIKE ima_file.ima021   #規格
                  END RECORD,
    g_ima         RECORD LIKE ima_file.*,
    g_ima_t       RECORD LIKE ima_file.*,
    g_ima_o       RECORD LIKE ima_file.*,
    g_ima01_t     LIKE ima_file.ima01,
    g_sw          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_s           LIKE type_file.chr1,    #料件處理狀況  #No.FUN-690026 VARCHAR(1)
    g_sta         LIKE ze_file.ze03,      #補貨策略碼的說明 #No.FUN-690026 VARCHAR(10)
    g_flag1       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_wc,g_sql    STRING                  #TQC-630166
 
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_rec_b             LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_geu02             LIKE geu_file.geu02    #No.FUN-630040
DEFINE g_str               STRING                 #No.FUN-840029   
DEFINE g_vmk01             LIKE vmk_file.vmk01    #No.FUN-850115
DEFINE g_vmk02             LIKE vmk_file.vmk02    #No.FUN-850115
DEFINE g_ima44_t           LIKE ima_file.ima44    #No.FUN-BB0086 

FUNCTION aimi103(p_argv1,p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          p_argv1       LIKE ima_file.ima01

   WHENEVER ERROR CALL cl_err_msg_log
 
   INITIALIZE g_ima.* TO NULL
   INITIALIZE g_ima_t.* TO NULL
 
   LET g_flag1 = p_cmd
   LET g_forupd_sql ="SELECT * FROM ima_file  WHERE ima01 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE aimi103_curl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET g_argv1 = p_argv1
 
   OPEN WINDOW aimi103_w WITH FORM "aim/42f/aimi103"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("ima908",g_sma.sma116 MATCHES '[123]')
   
   IF g_aza.aza95 = "N" THEN
      CALL cl_set_comp_visible("ima927",FALSE)
   END IF  

   #CHI-B70017 --START--
   IF s_industry('icd') THEN
      CALL cl_set_comp_visible("ima152",FALSE)
   END IF
   #CHI-B70017 --END--
 
   IF g_argv1 IS NOT NULL AND g_argv1 !=' ' THEN
      CALL aimi103_q()
   END IF
 
   WHILE TRUE
      LET g_action_choice=""
 
      CALL aimi103_menu()
 
      IF g_action_choice = "exit" THEN 
         EXIT WHILE
      END IF
   END WHILE
 
   CLOSE WINDOW aimi103_w
 
END FUNCTION
 
FUNCTION aimi103_curs()
 
   CLEAR FORM
 
   IF g_argv1 IS NULL OR g_argv1 = " " THEN
      
      INITIALIZE g_ima.* TO NULL   #FUN-640213 add
 
      CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021,ima08,ima05,ima25,
                                ima03,ima04,ima43,ima44,   #ima44_fac,   #FUN-650134 mark
                                ima150,ima152,              #No.FUN-810016  
                                ima926,ima927,              #No.FUN-930108 add ima926  #No.FUN-A90017 add ima927
                                ima45,ima46,ima51,ima52,ima47,ima54,ima908, #FUN-860085
                                ima104,ima53,ima91,ima531,ima532,ima50,
                                ima48,ima49,ima491,ima72,ima171,ima172,ima721,ima103,ima37, #CHI-C50068   #FUN-C90100 add ima171,ima172
                                ima27,ima109,imaud11,ima38,ima99,ima88,ima89,ima90,
                                ima881,ima24,ima100,ima101,ima102,
                                ima913,ima914,      #No.FUN-630040
                                imauser,imagrup,imamodu,imadate,imaacti
                                ,imaoriu,imaorig  #TQC-B90177 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ima01)
#FUN-AA0059 --Begin--
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"  #FUN-AB0025
                CALL cl_create_qry() RETURNING g_qryparam.multiret
              #  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret     #FUN-AB0025
#FUN-AA0059 --End--
                DISPLAY g_qryparam.multiret TO ima01
                NEXT FIELD ima01
 
               WHEN INFIELD(ima54)                       #供應商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ima.ima54
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima54
                  CALL aimi103_ima54('d')
                  NEXT FIELD ima54
               WHEN INFIELD(ima43)                       #採購員(ima43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ima.ima43
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima43
                  CALL aimi103_peo(g_ima.ima43,'d')
                  NEXT FIELD ima43
               WHEN INFIELD(ima44)                       #採購單位(ima44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ima.ima44
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima44
                  NEXT FIELD ima44
               WHEN INFIELD(ima914)   #No.FUN-630040
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima914
                 NEXT FIELD ima914
               WHEN INFIELD(ima109)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "8"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima109
                  NEXT FIELD ima109
               WHEN INFIELD(ima908) #FUN-860085
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_ima.ima908
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima908
                  NEXT FIELD ima908
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
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      LET g_s=NULL
 
      INPUT g_s WITHOUT DEFAULTS FROM s
 
         AFTER FIELD s  #資料處理狀況
            IF g_s NOT MATCHES '[YN]' THEN
               NEXT FIELD s
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
 
      IF INT_FLAG THEN RETURN END IF
 
      MESSAGE ' WAIT '
 
      IF g_s IS NOT NULL THEN
         LET g_wc=g_wc CLIPPED," AND ima93[3,3] matches '",g_s,"' "
      END IF
   ELSE
      LET g_wc = " ima01 = '",g_argv1,"'"
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
 
   LET g_sql="SELECT ima01 FROM ima_file ",
            #" WHERE ",g_wc CLIPPED, " ORDER BY ima01"                      #FUN-A90049 mark
             " WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED, " ORDER BY ima01"     #FUN-A90049 add
   PREPARE aimi103_prepare FROM g_sql
   DECLARE aimi103_curs SCROLL CURSOR WITH HOLD FOR aimi103_prepare
 
 # LET g_sql= "SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED                  #FUN-A90049 mark
   LET g_sql= "SELECT COUNT(*) FROM ima_file WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED #FUN-A90049 add
   PREPARE aimi103_precount FROM g_sql
   DECLARE aimi103_count CURSOR FOR aimi103_precount
 
END FUNCTION
 
FUNCTION aimi103_menu()
   DEFINE l_cmd LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(80)
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
     
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL aimi103_q()
            END IF
        ON ACTION next
            CALL aimi103_fetch('N')
        ON ACTION previous
            CALL aimi103_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL aimi103_u()
            END IF
        #@ON ACTION 料件/供應商查詢
        ON ACTION qry_item_vender
		LET l_cmd="apmq210 ",g_ima.ima01
            CALL cl_cmdrun(l_cmd CLIPPED)
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL aimi103_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL aimi103_fetch('/')
        ON ACTION first
            CALL aimi103_fetch('F')
        ON ACTION last
            CALL aimi103_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CALL i103_show_pic()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
          LET g_action_choice = "exit"
          CONTINUE MENU
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_ima.ima01 IS NOT NULL THEN
                 LET g_doc.column1 = "ima01"
                 LET g_doc.value1 = g_ima.ima01
                 CALL cl_doc()
              END IF
          END IF
 
        ON ACTION create_supplier
           LET g_action_choice="create_supplier"
           IF cl_chk_act_auth() THEN
             #LET l_cmd = "apmi600 '1' '",g_ima.ima54,"'"   #CHI-D30005 mark
              LET l_cmd = "apmi600 '",g_ima.ima54,"' '1' "  #CHI-D30005
              CALL cl_cmdrun_wait(l_cmd)
           END IF
 
        ON ACTION create_item
           LET g_action_choice="create_item"
           IF cl_chk_act_auth() THEN
              LET l_cmd = "aooi103 '",g_ima.ima01,"'"
              CALL cl_cmdrun_wait(l_cmd)
           END IF
 #str-----add by guanyao160525
        ON ACTION genggai_cai
           LET g_action_choice="genggai_cai"
           IF cl_chk_act_auth() THEN
              CALL i103_cai()
           END IF 
 #end-----add by guanyao160525
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
 
    END MENU
    CLOSE aimi103_curs
END FUNCTION
 
FUNCTION aimi103_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_ima08         LIKE ima_file.ima08,
          l_n             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_direct2       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_direct3       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_direct4       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_count         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_ima46         LIKE ima_file.ima46,
          l_flag          LIKE type_file.chr1   		 #是否必要欄位有輸入  #No.FUN-690026 VARCHAR(1)
   DEFINE l_pmc05  LIKE pmc_file.pmc05         #TQC-AB0195 add
   DEFINE   l_case        STRING   #No.FUN-BB0086 add 
   DEFINE l_chk_flag      LIKE type_file.chr1  #No.FUN-BB0086 add 
   
   DISPLAY BY NAME g_ima.imauser,g_ima.imagrup,g_ima.imadate,g_ima.imaacti
   DISPLAY g_s TO FORMONLY.s
 
   INPUT BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021,g_ima.ima08,   #No.FUN-570110
                 g_ima.ima05,g_ima.ima25,g_ima.ima03,#g_ima.ima04,
                 g_ima.ima43,g_ima.ima44,   #g_ima.ima44_fac,   #FUN-650134 mark
                 g_ima.ima150,g_ima.ima152,                     #No.FUN-810016
                 g_ima.ima926,g_ima.ima927,                     #FUN-930108--add  #FUN-A90017 add ima927
                 g_ima.ima45,
                 g_ima.ima46,g_ima.ima51,g_ima.ima52,g_ima.ima47,
                 g_ima.ima54,g_ima.ima908,g_ima.ima104,g_ima.ima53,g_ima.ima91,
                 g_ima.ima531,g_ima.ima532,g_ima.ima50,g_ima.ima48,
                 g_ima.ima49,g_ima.ima491,g_ima.ima72,
                 g_ima.ima171,g_ima.ima172,                   #FUN-C90100
                 g_ima.ima721,  #CHI-C50068
                 g_ima.ima103,g_ima.ima37,g_ima.ima27,g_ima.ima109,g_ima.imaud11,
                 g_ima.ima38,g_ima.ima99,g_ima.ima88,
                 g_ima.ima89,g_ima.ima90,g_ima.ima881,
                 g_ima.ima24,g_ima.ima100,g_ima.ima101,g_ima.ima102,
                 g_ima.ima913,g_ima.ima914,    #No.FUN-630040
                 g_ima.imauser,g_ima.imagrup,g_ima.imamodu,
                 g_ima.imadate,g_ima.imaacti
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i103_set_entry(p_cmd)
         CALL i103_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         LET g_ima.ima927 = "Y"
         #No.FUN-BB0086--add--start--
         IF p_cmd='u' THEN 
            LET g_ima44_t = g_ima.ima44
         END IF 
         IF p_cmd='a' THEN 
            LET g_ima44_t = NULL 
         END IF 
         #No.FUN-BB0086--add--start--
         
      BEFORE FIELD ima37
         CALL i103_set_entry(p_cmd)
 
      AFTER FIELD ima37  #補貨策略碼
         IF g_ima.ima37 NOT MATCHES "[012345]" THEN
            CALL cl_err(g_ima.ima37,'mfg1003',0)
            LET g_ima.ima37 = g_ima_o.ima37
            DISPLAY BY NAME g_ima.ima37
            NEXT FIELD ima37
         END IF
         CALL s_opc(g_ima.ima37) RETURNING g_sta
         #來源碼不為採購料件時, 補貨策略碼不可為'0' (再訂購點)
         IF g_ima.ima37='0' AND g_ima.ima08 NOT MATCHES '[MPVZ]' THEN
            CALL cl_err(g_ima.ima37,'mfg3201',0)
            LET g_ima.ima37 = g_ima_o.ima37
            DISPLAY BY NAME g_ima.ima37
            NEXT FIELD ima37
         END IF
         LET g_ima_o.ima37 = g_ima.ima37
         CALL i103_set_no_entry(p_cmd)
 
      AFTER FIELD ima27
        #No.FUN-BB0086---start---add---
        LET g_ima.ima27=s_digqty(g_ima.ima27, g_ima.ima25)
        DISPLAY BY NAME g_ima.ima27
        #No.FUN-BB0086---end---add---
         IF g_ima.ima27<0 THEN 
            CALL cl_err(g_ima.ima27,'mfg4012',0)
            NEXT FIELD ima27
         END IF 

       AFTER FIELD ima109
           IF NOT cl_null(g_ima.ima109) THEN
              IF (g_ima_o.ima109 IS NULL) OR
                 (g_ima.ima109 != g_ima_o.ima109) THEN
                  IF NOT i103_chk_ima109() THEN
                     NEXT FIELD ima109
                  END IF
              END IF
           END IF
           LET g_ima_o.ima109 = g_ima.ima109

           
      AFTER FIELD ima54
        IF (g_ima_o.ima54 IS NULL) OR (g_ima.ima54 != g_ima_o.ima54)
            OR (g_ima_o.ima54 IS NOT NULL AND g_ima.ima54 IS NULL)
          THEN CALL aimi103_ima54('a')
               IF g_chr='E' THEN
                  CALL cl_err(g_ima.ima54,'mfg3001',0)
                  LET g_ima.ima54 = g_ima_o.ima54
                  DISPLAY BY NAME  g_ima.ima54
                  NEXT FIELD ima54
               END IF
         END IF
         LET g_ima_o.ima54 = g_ima.ima54
         IF g_ima.ima54 IS NOT NULL  THEN
            select pmc01 FROM pmc_file
              WHERE pmc01 = g_ima.ima54
            IF SQLCA.sqlcode then 
               call cl_err(g_ima.ima54,'3014',0)  #FUN-930078 ADD 
               NEXT FIELD ima54
            END IF
            #TQC-AB0195-------add--------str------------------
            SELECT pmc05  INTO l_pmc05 FROM pmc_file
               WHERE pmc01 = g_ima.ima54
            IF l_pmc05 <> '1' THEN
               CALL cl_err(g_ima.ima54,'mfg1602',1)
               NEXT FIELD ima54
            END IF
            #TQC-AB0195-------add--------end------------------   
         END IF 
 
      BEFORE FIELD ima908
         IF cl_null(g_ima.ima908) THEN
            IF g_sma.sma116 MATCHES '[123]' THEN    #No.FUN-610076
               LET g_ima.ima908 = g_ima.ima25
               DISPLAY BY NAME g_ima.ima908
            END IF
         END IF
 
      AFTER FIELD ima908
         IF NOT i103_chk_ima908(p_cmd) THEN
            NEXT FIELD ima908
         END IF
 
 
      AFTER FIELD ima103  #購料特性
         IF g_ima.ima103 not matches'[012]' THEN
            NEXT FIELD ima103
         END IF
 
      AFTER FIELD ima43            #採購員
         IF (g_ima_o.ima43 IS NULL) OR (g_ima.ima43 != g_ima_o.ima43)
            OR (g_ima_o.ima43 IS NOT NULL AND g_ima.ima43 IS NULL) THEN
            CALL aimi103_peo(g_ima.ima43,'a')
            IF g_chr = 'E' THEN
               CALL cl_err(g_ima.ima43,'mfg1312',0)
               LET g_ima.ima43 = g_ima_o.ima43
               DISPLAY BY NAME g_ima.ima43
               NEXT FIELD ima43
            END IF
         END IF
         LET g_ima_o.ima43 = g_ima.ima43
 
      BEFORE FIELD ima44
         CALL i103_set_entry(p_cmd)
         IF g_ima_o.ima44 IS NULL AND g_ima.ima44 IS NULL THEN
            LET g_ima.ima44=g_ima.ima25
            LET g_ima_o.ima44=g_ima.ima25
            DISPLAY BY NAME g_ima.ima44
         END IF
 
      AFTER FIELD ima44           #採購單位
         IF g_ima.ima44 IS NULL THEN
            LET g_ima.ima44=g_ima.ima25
            DISPLAY BY NAME g_ima.ima44
         END IF
         IF g_ima.ima08 matches'[PVZ]' AND (g_ima.ima44 IS NULL
                                            OR g_ima.ima44 = ' ') THEN
            LET g_ima.ima44 = g_ima_o.ima44
            DISPLAY BY NAME g_ima.ima44
            NEXT FIELD ima44
         END IF
         IF g_ima.ima44 = g_ima.ima25 THEN
            LET g_ima.ima44_fac = 1
            DISPLAY BY NAME g_ima.ima44_fac
            LET g_ima_o.ima44 = g_ima.ima44
            LET g_ima_o.ima44_fac = g_ima.ima44_fac
         END IF
         IF g_ima.ima44 IS NOT NULL THEN
            IF (g_ima_o.ima44 IS NULL) OR (g_ima.ima44 != g_ima_o.ima44) THEN
               SELECT gfe01 FROM gfe_file
                WHERE gfe01 = g_ima.ima44
                  AND gfeacti IN ('Y','y')
               IF SQLCA.sqlcode  THEN
                  CALL cl_err3("sel","gfe_file",g_ima.ima44,"",
                               "mfg1006","","",1)  #No.FUN-660156
                  LET g_ima.ima44 = g_ima_o.ima44
                  DISPLAY BY NAME  g_ima.ima44
                  NEXT FIELD ima44
               ELSE
                  IF g_ima.ima44 = g_ima.ima25 THEN
                     LET g_ima.ima44_fac = 1
                  ELSE
                     CALL s_umfchk(g_ima.ima01,g_ima.ima44,g_ima.ima25)
                         RETURNING g_sw,g_ima.ima44_fac
                     IF g_sw = '1' THEN
                        CALL cl_err(g_ima.ima25,'mfg1206',0)
                        LET g_ima.ima44 = g_ima_o.ima44
                        DISPLAY BY NAME g_ima.ima44
                        LET g_ima.ima44_fac = g_ima_o.ima44_fac
                        DISPLAY BY NAME g_ima.ima44_fac
                        NEXT FIELD ima44
                     END IF
                  END IF
               END IF
               DISPLAY BY NAME g_ima.ima44_fac
            END IF
         END IF
         LET g_ima_o.ima44 = g_ima.ima44
         LET g_ima_o.ima44_fac = g_ima.ima44_fac
         CALL i103_set_no_entry(p_cmd)
         #FUN-BB0086---add---start
         LET l_case = ""
         IF NOT cl_null(g_ima.ima99) AND g_ima.ima99<>0 THEN
            IF g_ima.ima37 != '0' THEN 
               LET g_ima.ima99=s_digqty(g_ima.ima99,g_ima.ima44)
               DISPLAY BY NAME g_ima.ima99
            ELSE 
               IF NOT i103_ima99_check() THEN
                  LET l_case = "ima99"
               END IF
            END IF 
         END IF 
         IF NOT cl_null(g_ima.ima88) AND g_ima.ima88<>0 THEN
            IF g_ima.ima37 != '5' THEN 
               LET g_ima.ima88=s_digqty(g_ima.ima88,g_ima.ima44)
               DISPLAY BY NAME g_ima.ima88
            ELSE 
               CALL i103_ima88_check(l_direct2,l_direct3) RETURNING l_chk_flag,l_direct2,l_direct3
               IF NOT l_chk_flag THEN
                  LET l_case = "ima88"
               END IF
            END IF 
         END IF
         IF NOT cl_null(g_ima.ima45) AND g_ima.ima45<>0 THEN
            IF NOT i103_ima45_check() THEN
               LET l_case = "ima45"
            END IF
         END IF 
         IF NOT cl_null(g_ima.ima46) AND g_ima.ima46<>0 THEN
            IF NOT i103_ima46_check() THEN
               LET l_case = "ima46"
            END IF
         END IF 
         IF NOT cl_null(g_ima.ima51) AND g_ima.ima51<>0 THEN
            CALL i103_ima51_check(l_direct2,l_direct3) RETURNING l_chk_flag,l_direct2,l_direct3
            IF NOT l_chk_flag THEN
               LET l_case = "ima51"
            END IF
         END IF 
         IF NOT cl_null(g_ima.ima52) AND g_ima.ima52<>0 THEN
            CALL i103_ima52_check(l_direct4) RETURNING l_chk_flag,l_direct4
            IF NOT l_chk_flag THEN
               LET l_case = "ima52"
            END IF
         END IF 

         LET g_ima44_t = g_ima.ima44
         CASE l_case
            WHEN "ima45"
               NEXT FIELD ima45
            WHEN "ima46"
               NEXT FIELD ima46
            WHEN "ima51"
                NEXT FIELD ima51
            WHEN "ima52"
                NEXT FIELD ima52
            WHEN "ima88"
                NEXT FIELD ima88
            WHEN "ima99"
                NEXT FIELD ima99
            OTHERWISE EXIT CASE
         END CASE
         #FUN-BB0086---add---end   
 
       AFTER FIELD ima104        #廠商分配限量
          IF g_ima.ima104 IS NULL OR g_ima.ima104 < 0
          THEN LET g_ima.ima104 = 0
               DISPLAY BY NAME g_ima.ima104
          END IF
 
     AFTER FIELD ima53          #最近採購單價
         IF (g_ima.ima53 < 0) #genero
         THEN CALL cl_err(g_ima.ima53,'mfg3331',0)
              LET g_ima.ima53 = g_ima_o.ima53
              DISPLAY BY NAME g_ima.ima53
              NEXT FIELD ima53
         END IF
         LET g_ima_o.ima53 = g_ima.ima53
         LET l_direct = 'D'
 
    AFTER FIELD ima91          #平均採購單價
        IF g_ima.ima91 <= 0  #genero
        THEN CALL cl_err(g_ima.ima91,'mfg1322',0)
             LET g_ima.ima91 = g_ima_o.ima91
             DISPLAY BY NAME g_ima.ima91
             NEXT FIELD ima91
        END IF
        LET g_ima_o.ima91 = g_ima.ima91
 
       BEFORE FIELD ima531         #市價
          IF g_flag1 ='a' THEN
             LET g_ima.ima53 = g_ima.ima531
             DISPLAY BY NAME g_ima.ima53
          END IF
 
      AFTER FIELD ima531         #市價
         IF g_ima.ima531 <  0  #genero
               THEN CALL cl_err(g_ima.ima531,'mfg1322',0)
			   NEXT FIELD ima531
         END IF
         LET g_ima_o.ima531 = g_ima.ima531
 
      AFTER FIELD ima532
         LET l_direct2='D'
         LET l_direct3='D'
 
 
        #再補貨點
        AFTER FIELD ima38
           #No.FUN-BB0086---start---add---
           LET g_ima.ima38=s_digqty(g_ima.ima38, g_ima.ima25)
           DISPLAY BY NAME g_ima.ima38
           #No.FUN-BB0086---end---add---
            IF g_ima.ima38 <= 0 #genero
               THEN CALL cl_err(g_ima.ima38,'mfg1322',0)
                    LET g_ima.ima38 = g_ima_o.ima38
                    DISPLAY BY NAME g_ima.ima38
                    NEXT FIELD ima38
            END IF
            LET g_ima_o.ima38 = g_ima.ima38
            LET l_direct2='U'
 
        AFTER FIELD ima99
           IF NOT i103_ima99_check()  THEN NEXT FIELD ima99 END IF   #FUN-BB0086--add--
           #FUN-BB0086--mark--start--
           # IF g_ima.ima99 <= 0
           #    THEN CALL cl_err(g_ima.ima99,'mfg1322',0)
           #         LET g_ima.ima99 = g_ima_o.ima99
           #         DISPLAY BY NAME g_ima.ima99
           #         NEXT FIELD ima99
           # END IF
           # LET g_ima_o.ima99 = g_ima.ima99
           #FUN-BB0086--mark--end--
 
        AFTER FIELD ima88
           CALL i103_ima88_check(l_direct2,l_direct3) RETURNING l_chk_flag,l_direct2,l_direct3   #FUN-BB0086--add--
           IF NOT l_chk_flag THEN NEXT FIELD ima88 END IF   #FUN-BB0086--add--
             #FUN-BB0086--mark--start--
             #IF g_ima.ima88 <= 0 #genero
             #   THEN  CALL cl_err(g_ima.ima88,'mfg1322',0)
             #         LET g_ima.ima88 = g_ima_o.ima88
             #         DISPLAY BY NAME g_ima.ima88
             #         NEXT FIELD ima88
             #END IF
             #LET g_ima_o.ima88 = g_ima.ima88
             #LET l_direct2='U'
             #LET l_direct3='U'
             #FUN-BB0086--mark--end--
 
        AFTER FIELD ima89
                      IF g_ima.ima89 < 0 THEN
                         CALL cl_err(g_ima.ima89,'mfg0013',0)
                         LET g_ima.ima89 = g_ima_o.ima89
                         DISPLAY BY NAME g_ima.ima89
                         NEXT FIELD ima89
                      END IF
             LET g_ima_o.ima89 = g_ima.ima89
 
        AFTER FIELD ima90
                 IF g_ima.ima90 < 0 THEN
                    CALL cl_err(g_ima.ima90,'mfg0013',0)
                    NEXT FIELD ima90
                 END IF
             IF g_ima.ima37='5' THEN
                IF g_ima.ima89 =0 AND g_ima.ima90=0
                   THEN CALL cl_err(g_ima.ima37,'mfg9221',0)
                        NEXT FIELD ima89
                END IF
             END IF
 
        AFTER FIELD ima51          #經濟訂購量
           CALL i103_ima51_check(l_direct2,l_direct3) RETURNING l_chk_flag,l_direct2,l_direct3  #FUN-BB0086--add--
           IF NOT l_chk_flag THEN NEXT FIELD ima51 END IF    #FUN-BB0086--add--
           #FUN-BB0086--mark--start--
           #  IF g_ima.ima51 <= 0  #genero
           #     THEN  CALL cl_err(g_ima.ima51,'mfg1322',0)
           #           LET g_ima.ima51 = g_ima_o.ima51
           #           DISPLAY BY NAME g_ima.ima51
           #           NEXT FIELD ima51
           #  END IF
           #  LET g_ima_o.ima51 = g_ima.ima51
           #  LET l_direct2='U'
           #  LET l_direct3='U'
           #FUN-BB0086--mark--end--
 
        AFTER FIELD ima52          #平均訂購量
           CALL i103_ima52_check(l_direct4) RETURNING l_chk_flag,l_direct4   #FUN-BB0086--add--
           IF NOT l_chk_flag THEN NEXT FIELD ima52 END IF    #FUN-BB0086--add--
           #FUN-BB0086--mark--start--
           #  IF g_ima.ima52 <= 0  #genero
           #     THEN  CALL cl_err(g_ima.ima52,'mfg1322',0)
           #           LET g_ima.ima52 = g_ima_o.ima52
           #           DISPLAY BY NAME g_ima.ima52
           #           NEXT FIELD ima52
           #  END IF
           #  LET g_ima_o.ima52 = g_ima.ima52
           # LET l_direct4='D'
           #FUN-BB0086--mark--end--
 
        AFTER FIELD ima45          #採購單位批量
           IF NOT i103_ima45_check()  THEN NEXT FIELD ima45 END IF    #FUN-BB0086--add--
           #No.FUN-BB0086---start---mark---
           #  IF g_ima.ima45 < 0 #genero
           #     THEN CALL cl_err(g_ima.ima45,'mfg0013',0)
           #          LET g_ima.ima45 = g_ima_o.ima45
           #          DISPLAY BY NAME g_ima.ima45
           #         NEXT FIELD ima45
           #  END IF
           # #-------------No:MOD-B30316 add
           #  IF NOT cl_null(g_ima.ima45) AND g_ima.ima45 != g_ima_o.ima45 THEN
           #     IF g_ima.ima46 >1 THEN  #採購批量<1時,不控制
           #       IF (g_ima.ima46 mod g_ima.ima45) != 0 THEN
           #          CALL aimi103_size()
           #       END IF
           #     END IF
           #  END IF
           # #-------------No:MOD-B30316 end
           #  LET g_ima_o.ima45 = g_ima.ima45
           #No.FUN-BB0086---end---mark---
 
 
        AFTER FIELD ima48          #採購安全期
             IF g_ima.ima48 < 0 #genero
                THEN  CALL cl_err(g_ima.ima48,'mfg0013',0)
                      LET g_ima.ima48 = g_ima_o.ima48
                      DISPLAY BY NAME  g_ima.ima48
                      NEXT FIELD ima48
             END IF
             LET g_ima_o.ima48 = g_ima.ima48
             LET l_direct4='U'
 
        AFTER FIELD ima50          #請購安全期
             IF g_ima.ima50 IS NULL OR g_ima.ima50 = ' '
                 OR g_ima.ima50 < 0
                THEN  CALL cl_err(g_ima.ima50,'mfg0013',0)
                      LET g_ima.ima50 = g_ima_o.ima50
                      DISPLAY BY NAME g_ima.ima50
                      NEXT FIELD ima50
             END IF
             LET g_ima_o.ima50 = g_ima.ima50
 
        AFTER FIELD ima49          #到廠前置期
             IF g_ima.ima49 IS NULL OR g_ima.ima49 = ' '
                 OR g_ima.ima49 < 0
                THEN  CALL cl_err(g_ima.ima49,'mfg0013',0)
                      LET g_ima.ima49 = g_ima_o.ima49
                      DISPLAY BY NAME g_ima.ima49
                      NEXT FIELD ima49
             END IF
             LET g_ima_o.ima49 = g_ima.ima49
 
        AFTER FIELD ima491          #入庫前置期
             IF g_ima.ima491 IS NULL OR g_ima.ima491 = ' '
                 OR g_ima.ima491 < 0
                THEN  CALL cl_err(g_ima.ima491,'mfg0013',0)
                      LET g_ima.ima491 = g_ima_o.ima491
                      DISPLAY BY NAME g_ima.ima491
                      NEXT FIELD ima491
             END IF
             LET g_ima_o.ima491 = g_ima.ima491
 
        AFTER FIELD ima46          #最少採購數量
           IF NOT i103_ima46_check()  THEN NEXT FIELD ima46 END IF   #FUN-BB0086--add--
           #No.FUN-BB0086---start---mark---
           #  IF g_ima.ima46 IS NULL OR g_ima.ima46 = ' '
           #      OR g_ima.ima46 < 0
           #     THEN
           #          CALL cl_err(g_ima.ima46,'mfg0013',0)
           #          LET g_ima.ima46 = g_ima_o.ima46
           #          DISPLAY BY NAME g_ima.ima46
           #          NEXT FIELD ima46
           #  END IF
           #  IF g_ima_o.ima46 IS NULL OR (g_ima.ima46 != g_ima_o.ima46) THEN
           #     IF g_ima.ima45 >1 THEN  #採購批量<1時,不控制
           #       IF (g_ima.ima46 mod g_ima.ima45) != 0 THEN
           #          CALL aimi103_size()
           #       END IF
           #     END IF
           # END IF
           #  LET g_ima_o.ima46 = g_ima.ima46
           #No.FUN-BB0086---end---mark---
 
        AFTER FIELD ima47          #採購損耗率
             IF g_ima.ima47 IS NULL OR g_ima.ima47 = ' '
                 OR g_ima.ima47 < 0  OR g_ima.ima47 > 100
                THEN CALL cl_err(g_ima.ima47,'mfg1332',0)
                     LET g_ima.ima47 = g_ima_o.ima47
                     DISPLAY BY NAME g_ima.ima47
                     NEXT FIELD ima47
             END IF
             LET g_ima_o.ima47 = g_ima.ima47
 
        AFTER FIELD ima100
             IF g_ima.ima100 IS NULL OR g_ima.ima100 = ' '
                 OR g_ima.ima100 NOT MATCHES '[NTR]' THEN
                 LET g_ima.ima100 = g_ima_o.ima100
                 DISPLAY BY NAME g_ima.ima100
                 NEXT FIELD ima100
             END IF
             LET g_ima_o.ima100 = g_ima.ima100
 
        AFTER FIELD ima101
             IF g_ima.ima101 IS NULL OR g_ima.ima101 = ' '
                 OR g_ima.ima101 NOT MATCHES '[1234]' THEN   #No.FUN-A80063 add 34
                 LET g_ima.ima101 = g_ima_o.ima101
                 DISPLAY BY NAME g_ima.ima101
                 NEXT FIELD ima101
             END IF
             LET g_ima_o.ima101 = g_ima.ima101
#No.FUN-A80063 --begin
             IF g_ima_t.ima101 IS NULL OR g_ima_t.ima101 <> g_ima.ima101 THEN 
                IF g_ima.ima102 MATCHES '[567]' AND g_ima.ima101 MATCHES '[12]' THEN 
                   CALL cl_err('','aqc-045',1)
                   LET g_ima.ima101 = g_ima_t.ima101
                   NEXT FIELD ima101
                END IF 
             END IF 
#No.FUN-A80063 --end


#No.FUN-A80063 --begin
       BEFORE FIELD ima102
         CALL i103_combo()
#No.FUN-A80063 --end
 
        AFTER FIELD ima102
             IF g_ima.ima102 IS NULL OR g_ima.ima102 = ' ' THEN
                 LET g_ima.ima102 = g_ima_o.ima102
                 DISPLAY BY NAME g_ima.ima102
                 NEXT FIELD ima102
             END IF
             IF g_ima.ima101='1' AND g_ima.ima102 NOT MATCHES '[123]' THEN
                 LET g_ima.ima102 = g_ima_o.ima102
                 DISPLAY BY NAME g_ima.ima102
                 NEXT FIELD ima102
             END IF
             IF g_ima.ima101='2' AND g_ima.ima102 NOT MATCHES '[1234]' THEN
                 LET g_ima.ima102 = g_ima_o.ima102
                 DISPLAY BY NAME g_ima.ima102
                 NEXT FIELD ima102
             END IF
#No.MOD-A80063 --begin
             IF (g_ima.ima101='3' OR g_ima.ima101='4')  AND g_ima.ima102 NOT MATCHES '[1234567]' THEN
                 LET g_ima.ima102 = g_ima_o.ima102
                 DISPLAY BY NAME g_ima.ima102
                 NEXT FIELD ima102
             END IF
#No.MOD-A80063 --end 
             LET g_ima_o.ima102 = g_ima.ima102
 
        BEFORE FIELD ima913
           CALL i103_set_entry(p_cmd)

#TQC-AC0406 --ADD-BEGIN----
        ON CHANGE ima913
           CALL i103_set_entry(p_cmd)
           CALL i103_set_no_entry(p_cmd) 
#TQC-AC0406 --ADD-END------

        AFTER FIELD ima913
           IF g_ima.ima913 = "N" THEN
              LET g_ima.ima914 = ""
              LET g_geu02 = ""
              DISPLAY g_ima.ima914,g_geu02 TO ima914,geu02
           END IF
           CALL i103_set_no_entry(p_cmd)
           
        AFTER FIELD ima914
           IF NOT cl_null(g_ima.ima914) THEN
              IF g_ima.ima914 != g_ima_o.ima914 OR cl_null(g_ima_o.ima914) THEN   #No.MOD-640061
                 SELECT geu02 INTO g_geu02 FROM geu_file
                  WHERE geu01 = g_ima.ima914
                    AND geu00 = "4"
                 IF STATUS THEN
                    CALL cl_err3("sel","geu_file",g_ima.ima914,"",
                                 "anm-027","","",1)  #No.FUN-660156
                    NEXT FIELD ima914
                 ELSE
                    DISPLAY g_geu02 TO geu02
                 END IF
              END IF
           END IF
 
        AFTER INPUT
 
           LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
           LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_ima.ima37 NOT MATCHES "[012345]"  OR
                   g_ima.ima37 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima37
               NEXT FIELD ima37  #MOD-C40093 add
            END IF
            #來源碼不為採購料件時, 補貨策略碼不可為'0' (再訂購點)
            IF g_ima.ima37='0' AND g_ima.ima08 NOT MATCHES '[MPVZ]' THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima37
               NEXT FIELD ima37  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima103) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima103
               NEXT FIELD ima103  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima44) THEN
               LET g_ima.ima44=g_ima.ima25
               #No.FUN-BB0086--add--start--
               LET g_ima.ima45 = s_digqty(g_ima.ima45,g_ima.ima44)
               LET g_ima.ima46 = s_digqty(g_ima.ima46,g_ima.ima44)
               LET g_ima.ima51 = s_digqty(g_ima.ima51,g_ima.ima44)
               LET g_ima.ima52 = s_digqty(g_ima.ima52,g_ima.ima44)
               LET g_ima.ima88 = s_digqty(g_ima.ima88,g_ima.ima44)
               LET g_ima.ima99 = s_digqty(g_ima.ima99,g_ima.ima44)
               DISPLAY BY NAME g_ima.ima45,g_ima.ima46,g_ima.ima51,g_ima.ima52,g_ima.ima88,g_ima.ima99
               #No.FUN-BB0086--add--end--
               DISPLAY BY NAME g_ima.ima44
            END IF
            IF g_ima.ima44_fac IS NULL OR g_ima.ima44_fac<=0 THEN
               LET l_flag='Y'     #採購單位轉換因子
               DISPLAY BY NAME g_ima.ima44_fac
               NEXT FIELD ima44_fac  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima27) OR g_ima.ima27 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima27
               NEXT FIELD ima27  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima104) OR g_ima.ima104 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima104
               NEXT FIELD ima104  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima100) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima100
               NEXT FIELD ima100  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima101) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima101
               NEXT FIELD ima101  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima102) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima102
               NEXT FIELD ima102  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima53) OR g_ima.ima53 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima53
               NEXT FIELD ima53  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima531) OR g_ima.ima531 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima531
               NEXT FIELD ima531  #MOD-C40093 add
            END IF
            IF cl_null(g_ima.ima48) OR g_ima.ima48 < 0 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima48
               NEXT FIELD ima48  #MOD-C40093 add
            END IF
            IF g_ima.ima50 IS NULL OR g_ima.ima50 = ' '
                 OR g_ima.ima50 < 0 THEN   #請購安全期
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima50
               NEXT FIELD ima50  #MOD-C40093 add
            END IF
            IF g_ima.ima49 IS NULL OR g_ima.ima49 = ' '
                 OR g_ima.ima49 < 0 THEN   #到廠前置期
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima49
               NEXT FIELD ima49  #MOD-C40093 add
            END IF
            IF g_ima.ima491 IS NULL OR g_ima.ima491 = ' '
                 OR g_ima.ima491 < 0 THEN  #入庫前置期
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima491
               NEXT FIELD ima491  #MOD-C40093 add
            END IF
            IF g_ima.ima37='0' AND
	     ((g_ima.ima38 IS NULL OR g_ima.ima38 = ' ' OR g_ima.ima38 < 0) OR
	      (g_ima.ima99 IS NULL OR g_ima.ima99=' ' OR g_ima.ima99<0))
	      THEN   #再補貨點及再補貨量
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima38
               NEXT FIELD ima38  #MOD-C40093 add
            END IF
            IF g_ima.ima37 = '5' AND (g_ima.ima88 IS NULL OR
                   g_ima.ima88 = ' ' OR g_ima.ima88 <= 0 ) THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima88
               NEXT FIELD ima88  #MOD-C40093 add
            END IF
            IF g_ima.ima37 = '5' AND (g_ima.ima89 IS NULL OR
                g_ima.ima89 = ' ') AND
                (g_ima.ima90 IS NULL OR g_ima.ima90 = ' ') THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima89
               NEXT FIELD ima89  #MOD-C40093 add
            END IF
            IF g_ima.ima51 IS NULL OR g_ima.ima51 = ' '
                 OR g_ima.ima51 <= 0 THEN  #經濟訂購量
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima51
               NEXT FIELD ima51  #MOD-C40093 add
            END IF
            IF g_ima.ima52 IS NULL OR g_ima.ima52 = ' '
                 OR g_ima.ima52 <= 0 THEN #平均訂購量
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima52
               NEXT FIELD ima52  #MOD-C40093 add
            END IF
            IF  g_ima.ima08 matches'[PVZ]' AND  #採購單位
                 (g_ima.ima44 IS NULL  OR g_ima.ima44 = ' ') THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima44
               NEXT FIELD ima44  #MOD-C40093 add
            END IF
            IF g_ima.ima45 IS NULL OR g_ima.ima45 = ' '
                OR g_ima.ima45 < 0 THEN  #採購單位批量
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima45
               NEXT FIELD ima45  #MOD-C40093 add
            END IF
            IF g_ima.ima46 IS NULL OR g_ima.ima46 = ' '
                 OR g_ima.ima46 < 0 THEN  #最少採購數量
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima46
               NEXT FIELD ima46  #MOD-C40093 add
            END IF
            IF g_ima.ima47 IS NULL OR g_ima.ima47 = ' '
                 OR g_ima.ima47 < 0 THEN #採購損耗率
               LET l_flag='Y'
               DISPLAY BY NAME g_ima.ima47
               NEXT FIELD ima47  #MOD-C40093 add
            END IF
            IF g_ima.ima913 IS NULL OR g_ima.ima913 = ' ' THEN                                                                      
               LET l_flag='Y'                                                                                                       
               DISPLAY BY NAME g_ima.ima913 
               NEXT FIELD ima913  #MOD-C40093 add                                                                                        
            END IF                                                                                                                  
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD ima37
            END IF
 
        ON ACTION create_unit
           CALL cl_cmdrun("aooi101 ")
 
        ON ACTION unit_conversion
           CALL cl_cmdrun("aooi102 ")
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ima54)                       #供應商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc10" #FUN-740176
                 LET g_qryparam.default1 = g_ima.ima54
                 CALL cl_create_qry() RETURNING g_ima.ima54
                  DISPLAY BY NAME g_ima.ima54
                  CALL aimi103_ima54('d')
                  NEXT FIELD ima54
               WHEN INFIELD(ima43)                       #採購員(ima43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.state = "c"  #add by guanyao160525
                 LET g_qryparam.default1 = g_ima.ima43
                 CALL cl_create_qry() RETURNING g_ima.ima43
                  DISPLAY BY NAME g_ima.ima43
                  CALL aimi103_peo(g_ima.ima43,'d')
                  NEXT FIELD ima43
               WHEN INFIELD(ima109)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "8"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima109
                  NEXT FIELD ima109
               WHEN INFIELD(ima44)                       #採購單位(ima44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_ima.ima44
                 CALL cl_create_qry() RETURNING g_ima.ima44
                  DISPLAY BY NAME g_ima.ima44
                  NEXT FIELD ima44
               WHEN INFIELD(ima914)     #No.FUN-630040
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_geu"
                  LET g_qryparam.arg1 ="4"
                  LET g_qryparam.default1 = g_ima.ima914
                  CALL cl_create_qry() RETURNING g_ima.ima914
                  DISPLAY BY NAME g_ima.ima914
                  NEXT FIELD ima914
              WHEN INFIELD(ima908)  #FUN-860085
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_ima.ima908
                CALL cl_create_qry() RETURNING g_ima.ima908
                DISPLAY BY NAME g_ima.ima908
                NEXT FIELD ima908
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION update
         IF NOT cl_null(g_ima.ima01) THEN
            LET g_doc.column1 = "ima01"
            LET g_doc.value1 = g_ima.ima01
            CALL cl_fld_doc("ima04")
         END IF
 
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
 
FUNCTION aimi103_size()  #供應廠商
   DEFINE l_count   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_ima46   LIKE ima_file.ima46
 
   LET l_count = g_ima.ima46 MOD g_ima.ima45
   IF l_count != 0 THEN
      LET l_count = g_ima.ima46/ g_ima.ima45
      LET l_ima46 = ( l_count + 1 ) * g_ima.ima45
      CALL cl_getmsg('mfg0047',g_lang) RETURNING g_msg
 
      WHILE g_chr IS NULL OR g_chr NOT MATCHES'[YNyn]'
         LET INT_FLAG = 0  ######add for prompt bug
         PROMPT g_msg CLIPPED,'(',l_ima46,')',':' FOR g_chr
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
            EXIT WHILE
         END IF
      END WHILE
 
      IF g_chr ='Y' OR g_chr = 'y'  THEN
         LET g_ima.ima46 = l_ima46
      END IF
      DISPLAY BY NAME g_ima.ima45   #No.FUN-BB0086
      DISPLAY BY NAME g_ima.ima46
   END IF
 
   LET g_chr = NULL
 
END FUNCTION
 
FUNCTION aimi103_ima54(p_cmd)  #供應廠商
   DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_pmc03   LIKE pmc_file.pmc03,
          l_pmcacti LIKE pmc_file.pmcacti,
          l_pmc05   LIKE pmc_file.pmc05  #FUN-740176
 
   LET g_chr = ' '
   IF g_ima.ima54 IS NULL THEN
      LET l_pmc03=NULL
   ELSE
      SELECT pmc03,pmcacti,pmc05  #FUN-740176
        INTO l_pmc03,l_pmcacti,l_pmc05 #FUN-740176
        FROM pmc_file
       WHERE pmc01 = g_ima.ima54
      IF SQLCA.sqlcode THEN
         LET g_chr = 'E'
         LET l_pmc03 = NULL
      ELSE
         IF l_pmcacti='N' THEN
            LET g_chr = 'E'
         END IF
         IF l_pmc05='3' THEN
            LET g_chr = 'E'
         END IF
      END IF
   END IF
 
   IF (g_chr = ' ' OR p_cmd = 'd')  THEN
      DISPLAY l_pmc03 TO pmc03
   END IF
 
END FUNCTION
 
FUNCTION aimi103_peo(p_key,p_cmd)    #人員
   DEFINE #p_key     LIKE gen_file.gen01,   #mark by guanyao160525
          p_key     LIKE type_file.chr1000, #add by guanyao160525
          p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_genacti LIKE gen_file.genacti,
          #l_gen02   LIKE gen_file.gen02     #mark by guanyao160525
          l_gen02   LIKE type_file.chr1000   #add by guanyao160525
   DEFINE lst_token base.StringTokenizer     #add by guanyao160525
   DEFINE p_tok1    LIKE type_file.chr1000  #add by guanyao160525
   DEFINE l_n,i       LIKE type_file.num5      #add by guanyao160525
   DEFINE l_gen02_1   LIKE gen_file.gen02      #add by guanyao160525
 
   LET g_chr = ' '
   IF p_key IS NULL THEN
      LET l_gen02=NULL
   ELSE
      #str----add by guanyao160525
      SELECT instr(p_key,'|') INTO l_n FROM dual 
      IF l_n >0 THEN 
         LET lst_token = base.StringTokenizer.create(p_key,"|")
         LET l_n  = 1
         WHILE lst_token.hasMoreTokens()
           LET p_tok1 = lst_token.nextToken()
           SELECT gen02,genacti INTO l_gen02_1,l_genacti
             FROM gen_file
            WHERE gen01 = p_tok1
           IF SQLCA.sqlcode THEN
              LET l_gen02 = NULL
              LET g_success = 'N'
              CALL s_errmsg('gen01',p_tok1,'',STATUS,1)
           ELSE
              IF l_genacti='N' THEN
                 LET g_success = 'N'
                 CALL s_errmsg('gen01',p_tok1,'',STATUS,1)
              ELSE 
                 IF l_n> 1 THEN 
                    IF NOT cl_null(l_gen02_1) THEN 
                       LET l_gen02 = l_gen02 CLIPPED,'|',l_gen02_1 CLIPPED
                    END IF 
                 ELSE 
                    LET l_gen02 = l_gen02_1
                 END IF 
              END IF
            END IF    
         LET l_n = l_n+1
         CONTINUE WHILE    
         END WHILE  
      ELSE 
      #end----add by guanyao160525
      SELECT gen02,genacti INTO l_gen02,l_genacti
        FROM gen_file
       WHERE gen01 = p_key
      IF SQLCA.sqlcode THEN
         LET l_gen02 = NULL
         LET g_chr = 'E'
      ELSE
         IF l_genacti='N' THEN
            LET g_chr = 'E'
         END IF
      END IF
      END IF #add by guanyao160525
   END IF
#str---add by guanyao160525
   IF g_success = 'N' THEN 
      LET g_chr = 'E'
   END IF 
#end---add by guanyao160525
 
   IF g_chr = ' ' OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO gen02
   END IF
 
END FUNCTION
 
FUNCTION aimi103_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   LET g_ima.ima927 = "N"
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_ima.* TO NULL             #No.FUN-680046
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL aimi103_curs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      RETURN
   END IF
   OPEN aimi103_count
   FETCH aimi103_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN aimi103_curs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL
   ELSE
       CALL aimi103_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION aimi103_fetch(p_flima)
    DEFINE
        p_flima          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flima
        WHEN 'N' FETCH NEXT     aimi103_curs INTO g_ima.ima01
        WHEN 'P' FETCH PREVIOUS aimi103_curs INTO g_ima.ima01
        WHEN 'F' FETCH FIRST    aimi103_curs INTO g_ima.ima01
        WHEN 'L' FETCH LAST     aimi103_curs INTO g_ima.ima01
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
            FETCH ABSOLUTE g_jump aimi103_curs INTO g_ima.ima01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flima
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_ima.* FROM ima_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ima01 = g_ima.ima01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ima_file",g_ima.ima01,"",
                     SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_ima.imauser #FUN-4C0053
        LET g_data_group = g_ima.imagrup #FUN-4C0053
        CALL aimi103_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION aimi103_show()
    DEFINE ls_ima04       STRING
    DEFINE ls_pic_url     STRING
 
    LET g_geu02=""  
    LET g_ima_t.* = g_ima.*
    LET g_s=g_ima.ima93[3,3]
	MESSAGE ''
    DISPLAY g_s TO FORMONLY.s
    DISPLAY BY NAME
      g_ima.ima01, g_ima.ima05, g_ima.ima08,  g_ima.ima25,
      g_ima.ima02, g_ima.ima021, g_ima.ima03,
      g_ima.ima37, g_ima.ima103,    g_ima.ima43,
      g_ima.ima44, g_ima.ima44_fac,
      g_ima.ima150,g_ima.ima152,       #No.FUN-810016--add--
      g_ima.ima926,g_ima.ima927,       #No.FUN-930108--add-- #No.FUN-A90017 add ima927 
      g_ima.ima27, g_ima.ima109,g_ima.imaud11,g_ima.ima54,
      g_ima.ima908, #FUN-650022
      g_ima.ima104,g_ima.ima53, g_ima.ima91, g_ima.ima531, g_ima.ima532,
      g_ima.ima38, g_ima.ima99, g_ima.ima88, g_ima.ima89, g_ima.ima90,
      g_ima.ima881,g_ima.ima24,g_ima.ima51, g_ima.ima52,  #No.MOD-4A0026
      g_ima.ima48, g_ima.ima50, g_ima.ima49, g_ima.ima491, g_ima.ima72, 
      g_ima.ima171,g_ima.ima172,                 #FUN-C90100
      g_ima.ima721, #CHI-C50068
      g_ima.ima45, g_ima.ima46, g_ima.ima47,
      g_ima.ima100,g_ima.ima101,g_ima.ima102,g_ima.ima913,g_ima.ima914,  #No.FUN-630040
      g_ima.imauser, g_ima.imagrup, g_ima.imamodu,
      g_ima.imadate, g_ima.imaacti,
      g_ima.imaoriu,g_ima.imaorig   #TQC-B20007
 
      LET g_vmk02 = g_ima.ima54   #FUN-850115  add 
 
   SELECT geu02 INTO g_geu02 FROM geu_file
    WHERE geu01 = g_ima.ima914
 
   DISPLAY g_geu02 TO geu02
 
    CALL s_opc(g_ima.ima37) RETURNING g_sta
    CALL aimi103_ima54('d')
    CALL aimi103_peo(g_ima.ima43,'d')
 
    CALL i103_show_pic()
 
   LET g_doc.column1 = "ima01"
   LET g_doc.value1 = g_ima.ima01
   CALL cl_get_fld_doc("ima04")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION aimi103_u()
    DEFINE l_ima   RECORD LIKE ima_file.*           #FUN-B80032
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_ima.imaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ima.ima01,'mfg1000',0)
        RETURN
    END IF

#FUN-B90102----add--begin---- 服飾行業，子料件不可更改
    IF s_industry('slk') THEN
       IF g_ima.ima151='N' AND g_ima.imaag='@CHILD' THEN
          CALL cl_err(g_ima.ima01,'axm_665',1)
          RETURN
       END IF
    END IF
#FUN-B90102----add--end---

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ima01_t = g_ima.ima01
    LET g_ima_o.* = g_ima.*
    BEGIN WORK     #No.+205 mark 拿掉
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN aimi103_curl USING g_ima01_t
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN aimi103_curl:", STATUS, 1)
       CLOSE aimi103_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH aimi103_curl INTO g_ima.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0) 
        RETURN
    END IF
    IF g_ima.ima150 IS NULL OR cl_null(g_ima.ima150) THEN
       LET g_ima.ima150 = '0'
    END IF
    IF g_ima.ima152 is null OR cl_null(g_ima.ima152) THEN
       LET g_ima.ima152 = '0'
    END IF
    LET g_ima.imamodu = g_user                   #修改者
    LET g_ima.imadate = g_today                  #修改日期
    CALL aimi103_show()                          # 顯示最新資料
    WHILE TRUE
        CALL aimi103_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ima_t.imadate=g_ima_o.imadate        #TQC-C40219
            LET g_ima_t.imamodu=g_ima_o.imamodu        #TQC-C40219
            LET g_ima.*=g_ima_t.*      #TQC-C40155  #TQC-C40219
           #LET g_ima.*=g_ima_o.*      #TQC-C40155  #TQC-C40219
            CALL aimi103_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
       #FUN-B80032---------STA-------
        SELECT * INTO l_ima.*
          FROM ima_file
         WHERE ima01 = g_ima.ima01
         IF l_ima.ima02 <> g_ima.ima02 OR l_ima.ima021 <> g_ima.ima021
            OR l_ima.ima25 <> g_ima.ima25 OR l_ima.ima45 <> g_ima.ima45
            OR l_ima.ima151 <> g_ima.ima151 THEN
            IF g_aza.aza88 = 'Y' THEN
               UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima.ima01 AND rtepos = '3'
            END IF
         END IF
       #FUN-B80032---------END-------
        LET g_ima.ima93[3,3] = 'Y'
        UPDATE ima_file SET ima_file.* = g_ima.*    # 更新DB
            WHERE ima01 = g_ima01_t              # COLAUTH?
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","ima_file",g_ima01_t,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
#No.FUN-A50011 ---begin---
        ELSE 
#MOD-AC0161----------------mod start-----------
#FUN-B90102----------MARK---BEGIN-------------
#            IF s_industry('slk') THEN
#               IF g_ima.ima151 = 'Y' THEN
#                  CALL s_upd_ima_subparts(g_ima.ima01)
#               END IF
#            END IF 
#FUN-B90102---------MARK----END---------------
#MOD-AC0161----------------mod end-------------
#No.FUN-A50011  ---end---
        END IF
 
        #NO.FUN-850115 判斷是否料件供應商是否相同,不同時則刪除
         
        IF g_sma.sma901='Y' then
           IF (g_ima.ima54 <> g_vmk02) or (cl_null(g_ima.ima54)) THEN
              DELETE  from  vmk_file where vmk01=g_ima.ima01 and vmk02=g_vmk02 
           END IF
        END IF
 
        #更新 [料件/供應商檔](pmh_file).....  92/01/23 BY Lin
        IF g_ima.ima54 IS NOT NULL THEN
           SELECT pmh01 FROM pmh_file   #新的
            WHERE pmh01=g_ima.ima01 AND pmh02=g_ima.ima54
              AND pmh13=g_aza.aza17
              AND pmh21 = ' '                                             #CHI-860042                                          
              AND pmh22 = '1'                                             #CHI-860042
              AND pmh23 = ' '                                             #No.CHI-960033
             #AND pmhacti = 'Y'                                           #CHI-910021  #MOD-C90232 mark
           IF SQLCA.sqlcode THEN    #新的不存在,將舊的供應商直接改成新的供應商
              IF g_ima_t.ima54 IS NOT NULL THEN
                #str MOD-A60092 mod
                #UPDATE pmh_file SET pmh02 = g_ima.ima54,
                #                    pmh03 = 'Y',
                #                    pmhacti = 'Y',
                #                    pmhmodu = g_user,
                #                    pmhdate = g_today
                # WHERE pmh01 = g_ima.ima01
                #   AND pmh02 = g_ima_t.ima54
                #   AND pmh13 = g_aza.aza17
                #   AND pmh21 = ' '                                             #CHI-860042                                         
                #   AND pmh22 = '1'                                             #CHI-860042
                #   AND pmh23 = ' '                                             #No.CHI-960033
                #若找不到新供應商資料,應新增一筆新供應商的pmh_file資料,然後將舊供應商的pmh03改為N
                 #1.新增一筆新供應商的pmh_file資料
                 INSERT INTO pmh_file(pmh01,pmh02,pmh03,pmh04,pmh05,  #No:MOD-470041    #舊的也不存在,則新增一筆
                                      pmh06,pmh07,pmh08,pmh09,pmh10,
                                      pmh11,pmh12,pmh13,pmh14,pmh15,
                                      pmh16,pmhacti,pmhuser,pmhgrup,
                                      pmhmodu,pmhdate,pmh21,pmh22,pmh23,
                                      pmhoriu,pmhorig,pmh25)   #No:FUN-AA0015
                 VALUES(g_ima.ima01,g_ima.ima54,'Y','','0',
                       #g_today,'','N',' ','',             #MOD-C30075 mark
                       #g_today,'','g_ima.ima24',' ','',   #MOD-C30075  #MOD-C90164 mark 
                        #g_today,'',g_ima.ima24,' ','',     #MOD-C90164  #MOD-D40034
                        #100,0,g_aza.aza17,1,'',  #MOD-D40034
                        #'','Y',g_user,g_grup,'',g_today,' ','1',' ',g_user,g_grup,'N')   #No:FUN-AA0015  #MOD-D40034
                        g_today,'',g_ima.ima24,g_ima.ima100,'',  #MOD-D40034
                        100,0,g_aza.aza17,1,g_ima.ima101,  #MOD-D40034
                        g_ima.ima102,'Y',g_user,g_grup,'',g_today,' ','1',' ',g_user,g_grup,'N')   #MOD-D40034
                 #2.將舊供應商的pmh03改為N                                
                 UPDATE pmh_file SET pmh03 = 'N',                         
                                     pmhacti = 'Y',                       
                                     pmhmodu = g_user,
                                     pmhdate = g_today
                  WHERE pmh01 = g_ima.ima01
                    AND pmh02 = g_ima_t.ima54
                    AND pmh13 = g_aza.aza17
                    AND pmh21 = ' '
                    AND pmh22 = '1'
                    AND pmh23 = ' '
                #end MOD-A60092 mod
              ELSE
                 INSERT INTO pmh_file(pmh01,pmh02,pmh03,pmh04,pmh05,  #No.MOD-470041    #舊的也不存在,則新增一筆
                                      pmh06,pmh07,pmh08,pmh09,pmh10,
                                      pmh11,pmh12,pmh13,pmh14,pmh15,
                                      pmh16,pmhacti,pmhuser,pmhgrup,
                                      pmhmodu,pmhdate,pmh21,pmh22,pmh23,  #CHI-8C0017 Add pmh21,pmh22  #MOD-A60092 add pmh23
                                      pmhoriu,pmhorig,pmh25)   #No:FUN-AA0015
                 VALUES(g_ima.ima01,g_ima.ima54,'Y','','0',
                       #g_today,'','N',' ','',                #MOD-A60092 mod  #MOD-C30075 mark
                       #g_today,'','g_ima.ima24',' ','',      #MOD-A60092 mod  #MOD-C30075  #MOD-C90164 mark
                        #g_today,'',g_ima.ima24,' ','',        #MOD-C90164   #MOD-D40034
                        #100,0,g_aza.aza17,1,'',  #MOD-D40034
                        #'','Y',g_user,g_grup,'',g_today,' ','1',' ',g_user,g_grup,'N')   #No:FUN-AA0015  #CHI-8C0017 Add '','1'  #No.FUN-980030 10/01/04  insert columns oriu, orig  #MOD-A60092 add ' ' #MOD-D40034
                        g_today,'',g_ima.ima24,g_ima.ima100,'',   #MOD-D40034
                        100,0,g_aza.aza17,1,g_ima.ima101,  #MOD-D40034
                        g_ima.ima102,'Y',g_user,g_grup,'',g_today,' ','1',' ',g_user,g_grup,'N')  #MOD-D40034
              END IF
           ELSE
              UPDATE pmh_file SET pmh03='Y',
                                  pmhacti='Y',
                                  pmhmodu=g_user,
                                  pmhdate=g_today
               WHERE pmh01=g_ima.ima01
                 AND pmh02=g_ima.ima54
                 AND pmh13=g_aza.aza17
                 AND pmh21 = ' '                                             #CHI-860042                                            
                 AND pmh22 = '1'                                             #CHI-860042
                 AND pmh23 = ' '                                             #No.CHI-960033
             IF g_ima_t.ima54 IS NOT NULL THEN #新的為NULL時,將原來的
                UPDATE pmh_file                #主要供應商之值改成'N'
                   SET pmh03='N',
                       pmhmodu=g_user,
                       pmhdate=g_today
                 WHERE pmh01=g_ima.ima01 AND pmh02=g_ima_t.ima54
                   AND pmh13=g_aza.aza17
                   AND pmh21 = ' '                                            #CHI-860042                                           
                   AND pmh22 = '1'                                            #CHI-860042
                   AND pmh23 = ' '                                            #No.CHI-960033
             END IF
           END IF
       #MOD-CA0001 mark---S
       #ELSE
       #   IF g_ima_t.ima54 IS NOT NULL THEN #新的為NULL時,將原來的
       #      UPDATE pmh_file                #供應商之值改成無效
       #         SET pmhacti='N',
       #             pmhmodu=g_user,
       #             pmhdate=g_today
       #       WHERE pmh01=g_ima.ima01 AND pmh02=g_ima_t.ima54
       #         AND pmh13=g_aza.aza17
       #         AND pmh21 = ' '                                             #CHI-860042                                          
       #         AND pmh22 = '1'                                             #CHI-860042
       #         AND pmh23 = ' '                                             #No.CHI-960033
       #   END IF
       #MOD-CA0001 mark---E
        END IF
        DISPLAY 'Y' TO FORMONLY.s
        EXIT WHILE
    END WHILE
    CLOSE aimi103_curl

#FUN-B90102----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
    IF s_industry('slk') THEN
       IF g_ima.ima151='Y' THEN
          CALL i103_ins_ima()
       END IF
    END IF
#FUN-B90102----add--end---

    COMMIT WORK  #No.+205 mark 拿掉
END FUNCTION

#FUN-B90102----add--begin---- 服飾行業，母料件更改后修改，更新子料件資料
FUNCTION i103_ins_ima()
         
   UPDATE ima_file set
                      ima08=g_ima.ima08,
                      ima05=g_ima.ima05,ima25=g_ima.ima25,ima03=g_ima.ima03,
                      ima43=g_ima.ima43,ima44=g_ima.ima44,
                      ima150=g_ima.ima150,ima152=g_ima.ima152,
                      ima926=g_ima.ima926,ima927=g_ima.ima927,
                      ima45=g_ima.ima45,
                      ima46=g_ima.ima46,ima51=g_ima.ima51,ima52=g_ima.ima52,ima47=g_ima.ima47,
                      ima54=g_ima.ima54,ima908=g_ima.ima908,ima104=g_ima.ima104,ima53=g_ima.ima53,ima91=g_ima.ima91,
                      ima531=g_ima.ima531,ima532=g_ima.ima532,ima50=g_ima.ima50,ima48=g_ima.ima48,
                      ima49=g_ima.ima49,ima491=g_ima.ima491,ima72=g_ima.ima72,ima721=g_ima.ima721, #CHI-C50068
                      ima103=g_ima.ima103,ima37=g_ima.ima37,ima27=g_ima.ima27,ima109=g_ima.ima109,imaud11=g_ima.imaud11,
                      ima38=g_ima.ima38,ima99=g_ima.ima99,ima88=g_ima.ima88,
                      ima89=g_ima.ima89,ima90=g_ima.ima90,ima881=g_ima.ima881,
                      ima24=g_ima.ima24,ima100=g_ima.ima100,ima101=g_ima.ima101,ima102=g_ima.ima102,
                      ima913=g_ima.ima913,ima914=g_ima.ima914,
                      imamodu=g_ima.imamodu,
                      imadate=g_ima.imadate
   WHERE ima01 in (SELECT imx000 FROM imx_file WHERE imx00=g_ima.ima01)
   
    
END FUNCTION
#FUN-B90102----add--end---
 
FUNCTION aimi103_out()
    DEFINE
        sr              RECORD LIKE ima_file.*,
        sr2             RECORD
                          pmc03   LIKE pmc_file.pmc03,
                          gen02   LIKE gen_file.gen02
                        END RECORD,
        l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
        l_za05          LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
        l_chr           LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimi103' #No.FUN-840029
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql=" SELECT ima_file.*,pmc03,gen02 FROM ima_file ",
              " LEFT OUTER JOIN pmc_file ON ima_file.ima54=pmc_file.pmc01 ",
              " LEFT OUTER JOIN gen_file ON ima_file.ima43=gen_file.gen01 ",
              " WHERE ",g_wc CLIPPED
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'ima01,ima02,ima021,ima08,ima05,ima25,                
                                ima03,ima04,ima43,ima44,                        
                                ima45,ima46,ima51,ima52,ima47,ima54,            
                                ima104,ima53,ima91,ima531,ima532,ima50,         
                                ima48,ima49,ima491,ima72,ima171,ima172,ima721,ima103,ima37,        
                                ima27,ima109,ima38,ima99,ima88,ima89,ima90,            
                                ima881,ima24,ima100,ima101,ima102,              
                                ima913,ima914,                                  
                                imauser,imagrup,imamodu,imadate,imaacti')   #CHI-C50068 add ima721     #FUN-C90100 add ima171,ima172
       RETURNING g_str                                                          
    END IF                                                                      
    CALL cl_prt_cs1('aimi103','aimi103',g_sql,g_str)                            
END FUNCTION
 
FUNCTION i103_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF INFIELD(ima37) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ima38,ima99,ima88,ima89,ima90,imaud11",TRUE)
      CALL cl_set_comp_required("ima88,ima89,ima90",FALSE)      #TQC-C50253
   END IF
 
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("ima50,ima44",TRUE)  #FUN-680129 add ima44
   END IF
 
 # IF INFIELD(ima913) OR (NOT g_before_input_done) THEN     #TQC-AC0406 MARK
   IF g_ima.ima913 = 'Y' THEN                               #TQC-AC0406 ADD
      IF INFIELD(ima913) OR (NOT g_before_input_done) THEN  #TQC-AC0406 ADD
         CALL cl_set_comp_entry("ima914",TRUE)
         CALL cl_set_comp_required("ima914",TRUE)
      END IF
   END IF                                                   #TQC-AC0406 ADD
 
END FUNCTION
 
FUNCTION i103_set_no_entry(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF INFIELD(ima37) OR (NOT g_before_input_done) THEN
      IF g_ima.ima37 != '0' THEN
         IF g_ima.ima37='5' THEN
            CALL cl_set_comp_entry("ima38,ima99",FALSE)
         ELSE
            CALL cl_set_comp_entry("ima38,ima99,ima88,ima89,ima90",FALSE)
         END IF
      ELSE
         CALL cl_set_comp_entry("ima88,ima89,ima90",FALSE)
      END IF
   END IF
 
   IF NOT g_before_input_done THEN
      IF g_sma.sma31='N' THEN
         CALL cl_set_comp_entry("ima50",FALSE)
      END IF
   END IF
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("ima01",FALSE)
   END IF
 
   IF g_ima.ima913 = "N" THEN
      CALL cl_set_comp_entry("ima914",FALSE)
      CALL cl_set_comp_required("ima914",FALSE)
   END IF
 
   IF g_sma.sma115 = 'Y' AND g_ima.ima906 ='2' THEN
     LET g_ima.ima44 = g_ima.ima25
     #No.FUN-BB0086--add--start--
     LET g_ima.ima45 = s_digqty(g_ima.ima45,g_ima.ima44)
     LET g_ima.ima46 = s_digqty(g_ima.ima46,g_ima.ima44)
     LET g_ima.ima51 = s_digqty(g_ima.ima51,g_ima.ima44)
     LET g_ima.ima52 = s_digqty(g_ima.ima52,g_ima.ima44)
     LET g_ima.ima88 = s_digqty(g_ima.ima88,g_ima.ima44)
     LET g_ima.ima99 = s_digqty(g_ima.ima99,g_ima.ima44)
     DISPLAY BY NAME g_ima.ima45,g_ima.ima46,g_ima.ima51,g_ima.ima52,g_ima.ima88,g_ima.ima99
     #No.FUN-BB0086--add--end--
     DISPLAY BY NAME g_ima.ima44
     CALL cl_set_comp_entry("ima44",FALSE)
   END IF

#TQC-C50253 -------------Begin--------------
   IF g_ima.ima37 = '5' THEN
      CALL cl_set_comp_required("ima88,ima89,ima90",TRUE)
   END IF 
#TQC-C50253 -------------End---------------- 

END FUNCTION
 
FUNCTION i103_show_pic()
   
     LET g_chr='N'
     IF g_ima.ima1010='1' THEN                                                                                             
        LET g_chr='Y'                                                                                                      
     END IF
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,""  ,g_ima.imaacti,""    ,"")
                           #確認 ,核准,過帳,結案,作廢,有效         ,申請  ,留置
     #圖形顯示
END FUNCTION
 
 
FUNCTION i103_aps()
  DEFINE  l_cmd LIKE type_file.chr1000
  DEFINE  l_vmk RECORD LIKE vmk_file.*    
 
 
     IF cl_null(g_ima.ima01) THEN
        CALL cl_err('',-400,1)
        RETURN
     END IF
     IF cl_null(g_ima.ima54) THEN
        CALL cl_err('','arm-034',1)
        RETURN
     END IF
     SELECT vmk01,vmk02 FROM vmk_file
      WHERE vmk01 = g_ima.ima01
         AND vmk02 = g_ima.ima54
     IF SQLCA.SQLCODE=100 THEN
        LET l_vmk.vmk01 = g_ima.ima01
        LET l_vmk.vmk02 = g_ima.ima54
        LET l_vmk.vmk05 = 999999
        LET l_vmk.vmk10 = 0
        LET l_vmk.vmk11 = 1
        LET l_vmk.vmk12 = 0
        LET l_vmk.vmk13 = 1
        LET l_vmk.vmk15 = 0
        LET l_vmk.vmk16 = 0
        LET l_vmk.vmk17 = 0
        INSERT INTO vmk_file VALUES(l_vmk.*)
           IF STATUS THEN
              CALL cl_err3("ins","vmk_file",l_vmk.vmk01,l_vmk.vmk02,SQLCA.sqlcode,
                           "","",1)
           END IF
     END IF
     LET l_cmd = "apsi309 '",g_ima.ima01,"' '",g_ima.ima54,"'"
     CALL cl_cmdrun(l_cmd)
END FUNCTION
 
FUNCTION i103_chk_ima908(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE l_factor LIKE img_file.img21
 
   IF cl_null(g_ima.ima908) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT gfe01 FROM gfe_file ",
             "WHERE gfe01='",g_ima.ima908,"' ",
             "AND gfeacti IN ('Y','y')"
   IF SQLCA.sqlcode  THEN
         CALL cl_err3("sel","gfe_file",g_ima.ima908,"","mfg0019","","",1)  
         LET g_ima.ima908 = g_ima_o.ima908
         DISPLAY BY NAME g_ima.ima908
         RETURN FALSE
   END IF
   #計價單位時,計價單位必須和ima25有轉換率
   CALL s_du_umfchk(g_ima.ima01,'','','',g_ima.ima25,
                    g_ima.ima908,'2')
        RETURNING g_errno,l_factor
   IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_ima.ima01,g_errno,1)   #TQC-6C0026 modify 0->1
         RETURN FALSE
   END IF
   IF g_ima_o.ima908 <> g_ima_o.ima908 AND
      g_ima_o.ima908 IS NOT NULL AND
      p_cmd = 'u' THEN
      IF NOT cl_confirm('aim-999') THEN
         LET g_ima.ima908=g_ima_o.ima908
         DISPLAY BY NAME g_ima.ima908
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
#No.FUN-A80063 --begin
FUNCTION i103_combo()
   DEFINE comb_value LIKE type_file.chr1000
   DEFINE comb_item  LIKE type_file.chr1000
  
   IF g_ima.ima101 = '1' THEN
      LET comb_value = '1,2,3'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-042' AND ze02=g_lang
   ELSE
      LET comb_value = '1,2,3,4'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-043' AND ze02=g_lang
  END IF
#No.FUN-A80063 --begin
   IF g_ima.ima101 MATCHES '[34]' THEN
      LET comb_value = '1,2,3,4,5,6,7'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-044' AND ze02=g_lang
   END IF
#No.FUN-A80063 --end
 
  CALL cl_set_combo_items('ima102',comb_value,comb_item)
END FUNCTION
#No.FUN-A80063 --end 

#No.FUN-BB0086---start---add---
FUNCTION i103_ima45_check()
   IF NOT cl_null(g_ima.ima45) AND NOT cl_null(g_ima.ima44) THEN
      IF cl_null(g_ima.ima45) OR cl_null(g_ima44_t) OR g_ima_t.ima45 != g_ima.ima45 OR g_ima44_t != g_ima.ima44 THEN
         LET g_ima.ima45=s_digqty(g_ima.ima45,g_ima.ima44)
         DISPLAY BY NAME g_ima.ima45
      END IF
   END IF
   
   IF g_ima.ima45 < 0 #genero
      THEN CALL cl_err(g_ima.ima45,'mfg0013',0)
           LET g_ima.ima45 = g_ima_o.ima45
           DISPLAY BY NAME g_ima.ima45
           RETURN FALSE 
   END IF
   #-------------No:MOD-B30316 add
   IF NOT cl_null(g_ima.ima45) AND g_ima.ima45 != g_ima_o.ima45 THEN
      IF g_ima.ima46 >1 THEN  #採購批量<1時,不控制
         IF (g_ima.ima46 mod g_ima.ima45) != 0 THEN
            CALL aimi103_size()
         END IF
      END IF
   END IF
   #-------------No:MOD-B30316 end
   LET g_ima_o.ima45 = g_ima.ima45
   RETURN TRUE
END FUNCTION

FUNCTION i103_ima46_check()
   IF NOT cl_null(g_ima.ima46) AND NOT cl_null(g_ima.ima44) THEN
      IF cl_null(g_ima.ima46) OR cl_null(g_ima44_t) OR g_ima_t.ima46 != g_ima.ima46 OR g_ima44_t != g_ima.ima44 THEN
         LET g_ima.ima46=s_digqty(g_ima.ima46,g_ima.ima44)
         DISPLAY BY NAME g_ima.ima46
      END IF
   END IF
   
   IF g_ima.ima46 IS NULL OR g_ima.ima46 = ' '
        OR g_ima.ima46 < 0
      THEN
         CALL cl_err(g_ima.ima46,'mfg0013',0)
         LET g_ima.ima46 = g_ima_o.ima46
         DISPLAY BY NAME g_ima.ima46
         RETURN FALSE 
   END IF
   IF g_ima_o.ima46 IS NULL OR (g_ima.ima46 != g_ima_o.ima46) THEN
      IF g_ima.ima45 >1 THEN  #採購批量<1時,不控制
         IF (g_ima.ima46 mod g_ima.ima45) != 0 THEN
             CALL aimi103_size()
         END IF
      END IF
   END IF
   LET g_ima_o.ima46 = g_ima.ima46
   RETURN TRUE
END FUNCTION

FUNCTION i103_ima51_check(l_direct2,l_direct3)
   DEFINE l_direct2       LIKE type_file.chr1
   DEFINE l_direct3       LIKE type_file.chr1
   IF NOT cl_null(g_ima.ima51) AND NOT cl_null(g_ima.ima44) THEN
      IF cl_null(g_ima.ima51) OR cl_null(g_ima44_t) OR g_ima_t.ima51 != g_ima.ima51 OR g_ima44_t != g_ima.ima44 THEN
         LET g_ima.ima51=s_digqty(g_ima.ima51,g_ima.ima44)
         DISPLAY BY NAME g_ima.ima51
      END IF
   END IF
   
   IF g_ima.ima51 <= 0  #genero
      THEN  CALL cl_err(g_ima.ima51,'mfg1322',0)
         LET g_ima.ima51 = g_ima_o.ima51
         DISPLAY BY NAME g_ima.ima51
         RETURN FALSE,l_direct2,l_direct3
   END IF
   LET g_ima_o.ima51 = g_ima.ima51
   RETURN TRUE,'U','U'
END FUNCTION

FUNCTION i103_ima52_check(l_direct4)
   DEFINE l_direct4   LIKE type_file.chr1
   IF NOT cl_null(g_ima.ima52) AND NOT cl_null(g_ima.ima44) THEN
      IF cl_null(g_ima.ima52) OR cl_null(g_ima44_t) OR g_ima_t.ima52 != g_ima.ima52 OR g_ima44_t != g_ima.ima44 THEN
         LET g_ima.ima52=s_digqty(g_ima.ima52,g_ima.ima44)
         DISPLAY BY NAME g_ima.ima52
      END IF
   END IF
   
   IF g_ima.ima52 <= 0  #genero
      THEN  CALL cl_err(g_ima.ima52,'mfg1322',0)
            LET g_ima.ima52 = g_ima_o.ima52
            DISPLAY BY NAME g_ima.ima52
            RETURN FALSE,l_direct4
   END IF
   LET g_ima_o.ima52 = g_ima.ima52
   RETURN TRUE,'D'
END FUNCTION

FUNCTION i103_ima88_check(l_direct2,l_direct3)
   DEFINE l_direct2   LIKE type_file.chr1
   DEFINE l_direct3   LIKE type_file.chr1
   IF NOT cl_null(g_ima.ima88) AND NOT cl_null(g_ima.ima44) THEN
      IF cl_null(g_ima.ima88) OR cl_null(g_ima44_t) OR g_ima_t.ima88 != g_ima.ima88 OR g_ima44_t != g_ima.ima44 THEN
         LET g_ima.ima88=s_digqty(g_ima.ima88,g_ima.ima44)
         DISPLAY BY NAME g_ima.ima88
      END IF
   END IF
   
   IF g_ima.ima88 <= 0 #genero
      THEN  CALL cl_err(g_ima.ima88,'mfg1322',0)
            LET g_ima.ima88 = g_ima_o.ima88
            DISPLAY BY NAME g_ima.ima88
            RETURN FALSE,l_direct2,l_direct3
   END IF
   LET g_ima_o.ima88 = g_ima.ima88
   RETURN TRUE,'U','U'
END FUNCTION

FUNCTION i103_ima99_check()
   IF NOT cl_null(g_ima.ima99) AND NOT cl_null(g_ima.ima44) THEN
      IF cl_null(g_ima.ima99) OR cl_null(g_ima44_t) OR g_ima_t.ima99 != g_ima.ima99 OR g_ima44_t != g_ima.ima44 THEN
         LET g_ima.ima99=s_digqty(g_ima.ima99,g_ima.ima44)
         DISPLAY BY NAME g_ima.ima99
      END IF
   END IF
   
   IF g_ima.ima99 <= 0
      THEN CALL cl_err(g_ima.ima99,'mfg1322',0)
           LET g_ima.ima99 = g_ima_o.ima99
           DISPLAY BY NAME g_ima.ima99
           RETURN FALSE 
   END IF
   LET g_ima_o.ima99 = g_ima.ima99
   RETURN TRUE
END FUNCTION
#No.FUN-BB0086---END---add---

#str----add by guanyao160525
FUNCTION i103_cai()
DEFINE l_ima43_2     LIKE ima_file.ima43
DEFINE l_ima43       LIKE ima_file.ima43
   IF cl_null(g_ima.ima01) THEN 
      RETURN 
   END IF 
   SELECT ima43 INTO l_ima43 FROM ima_file WHERE ima01 = g_ima.ima01
   
   
    OPEN WINDOW i103_w_2 WITH FORM "cim/42f/cimi103_1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("cimi103_1")
 
    DISPLAY l_ima43 TO ima43_1
 
    INPUT l_ima43_2 FROM ima43_2 
 
       AFTER FIELD ima43_2
          IF cl_null(l_ima43_2) THEN     
             NEXT FIELD ima43_2
          ELSE  
            IF l_ima43 =  l_ima43_2 THEN 
               CALL cl_err('','cim-002',0)
               NEXT FIELD ima43_2
            END IF     
            CALL aimi103_peo(l_ima43_2,'a')
            IF g_chr = 'E' THEN
               CALL cl_err(l_ima43_2,'mfg1312',0)
               DISPLAY l_ima43_2 TO ima43_2
               NEXT FIELD ima43_2
            END IF
         END IF
         LET g_ima_o.ima43 = g_ima.ima43
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
       ON ACTION controlp 
          CASE 
             WHEN INFIELD(ima43_2)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.state = "c"  #add by guanyao160525
                LET g_qryparam.default1 = l_ima43_2
                CALL cl_create_qry() RETURNING l_ima43_2
                DISPLAY BY NAME l_ima43_2
                NEXT FIELD ima43_2
          END CASE 
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW i103_w_2
       RETURN
    END IF
    CLOSE WINDOW i103_w_2

    UPDATE ima_file SET ima43 = l_ima43_2 
    IF sqlca.sqlcode THEN 
       CALL cl_err3("upd","ima_file",l_ima43_2,"","cim-001","","",1)
    ELSE 
       DISPLAY l_ima43_2 TO ima43
    END IF 
END FUNCTION 
#end----add by guanyao160525

FUNCTION i103_chk_cur(p_sql)
DEFINE p_sql STRING
DEFINE l_cnt LIKE type_file.num5
DEFINE l_result LIKE type_file.chr1
DEFINE l_dbase LIKE type_file.chr21
   IF NOT cl_null(g_dbase) THEN  #指定資料庫,Table Name 前面加上資料庫名稱,如果有兩個Tablename,則此處理必須改寫
      LET l_dbase=" FROM ",s_dbstring(g_dbase)           #TQC-940178 ADD 
      CALL cl_replace_once()
      LET p_sql=cl_replace_str(p_sql," FROM ",l_dbase)
      CALL cl_replace_init()
   END IF
   CALL cl_replace_sqldb(p_sql) RETURNING p_sql     #FUN-920032    #FUN-950007 add
   PREPARE i103_chk_cur_p FROM p_sql
   DECLARE i103_chk_cur_c CURSOR FOR i103_chk_cur_p
   OPEN i103_chk_cur_c
   FETCH i103_chk_cur_c INTO l_cnt
   IF SQLCA.sqlcode OR l_cnt=0 THEN
      LET l_result=FALSE
   ELSE
      LET l_result=TRUE
   END IF
   FREE i103_chk_cur_p
   CLOSE i103_chk_cur_c
   RETURN l_result
END FUNCTION

FUNCTION i103_chk_ima109()
   IF cl_null(g_ima.ima109) THEN
      RETURN TRUE
   END IF
 
   CALL s_field_chk(g_ima.ima109,'1',g_plant,'ima109') RETURNING g_flag2
   IF g_flag2 = '0' THEN
      CALL cl_err(g_ima.ima109,'aoo-043',1)
      LET g_ima.ima109 = g_ima_o.ima109
      DISPLAY BY NAME g_ima.ima109
      RETURN FALSE
   END IF
 
   LET g_sql="SELECT COUNT(*) FROM azf_file ", #FUN-5A0027
             "WHERE azf01='",g_ima.ima109,"' AND azf02='8' ",
             "AND azfacti='Y'"
   IF NOT i103_chk_cur(g_sql) THEN #FUN-5A0027
      IF cl_null(g_dbase) THEN #FUN-5A0027
         CALL cl_err3("sel","azf_file",g_ima.ima109,"","mfg1306","","",1)  #No.FUN-660156
         LET g_ima.ima109 = g_ima_o.ima109
         DISPLAY BY NAME g_ima.ima109
         RETURN FALSE
      ELSE  #FUN-5A0027
         LET g_cnt=g_errary.getlength()+1
         LET g_errary[g_cnt].db=g_dbase
         LET g_errary[g_cnt].value=g_ima.ima109
         LET g_errary[g_cnt].field="ima109"
         LET g_errary[g_cnt].errno="mfg1306"
         RETURN TRUE
      END IF
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
