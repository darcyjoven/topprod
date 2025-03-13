# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aooi503.4gl
# Descriptions...: BOM公式定義作業
# Date & Author..: 05/07/20 By Lifeng
#                  該作業用于abmi600維護BOM單身作業時,當選擇bmb30"計算方式"為"公式"的時候,供用戶進行公式
#                  的定義和測試操作.在BOM單身中,bmb03"元件料號",bmb06"元件數量"和bmb08"損耗率"三個量可以
#                  進行公式定義,為什么不放在單身里做呢?因為如果我們對某個欄位定義了一個公式,當然不可能把
#                  公式的文本存放在其中,而只能將公式的編號返回,公式編號是字符類型,而元件數量和損耗量都是
#                  整型量,所以我們這里針對每一條單身記錄規定了其公式代碼的前綴"BOM+主件+兩位流水號",每一
#                  元件記錄如果定義為公式方式則會存在三個對應公式,如:
#                        &BOM-CL-01-1& 		元件料號欄位定義的公式
#			 &BOM-CL-01-2&          元件用量欄位定義的公式
#                        &BOM-CL-01-3&          損耗率欄位定義的公式
#                  本函數返回的是統一的前綴,存放在"元件料號"欄位中.
#                  這樣的規則是系統內部集成的,用戶不能手工改變編號,否則可能會引起錯誤
#                  
# Modify.........: No.TQC-5C0013 05/12/12 By jackie 增加組條件生成公式功能
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: No.FUN-630080 06/03/28 By jackie 增加組成用量開窗組表達式功能界面
#                                06/04/13 By Lifeng 增加對網格輔助項的保存代碼      
# Modify.........: No.TQC-640171 06/04/30 By Rayven 修正自定義開窗后直接退出報錯
# Modify.........: No.TQC-650075 06/05/19 By Rayven 現將程序中涉及的imandx表改為imx表，原欄位imandx改為imx000
# Modify.........: No.TQC-660059 06/06/13 By Rayven imandx_file改imx_file有些欄位修改有誤，重新修正
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0022 09/11/05 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.MOD-CC0053 12/12/07 By suncx 函數i503_showte()中組l_str錯誤
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.TQC-5C0013 --start--
    #這個數組用于存放屏幕上各個列的顯示情況和當前值
DEFINE
   g_value ARRAY[20] OF RECORD
            fname     LIKE type_file.chr5,       #No.FUN-680102  VARCHAR(5),         #欄位名稱，從'att01'~'att10'  
            imx000    LIKE imx_file.imx000,     #No.FUN-680102   VARCHAR(8),      #該欄位在imx_file中對應的欄位名稱
            visible   LIKE type_file.chr1,           #No.FUN-680102CHAR(1),           #是否可見，'Y'或'N'       
            nvalue    STRING,
            value     DYNAMIC ARRAY OF STRING  #存放當前當前組值           
            END RECORD,
    g_bmb  DYNAMIC ARRAY OF RECORD
            att01   LIKE imx_file.imx01, # 明細屬性欄位 
            att02   LIKE imx_file.imx01, # 明細屬性欄位 
            att03   LIKE imx_file.imx01, # 明細屬性欄位 
            att04   LIKE imx_file.imx01, # 明細屬性欄位 
            att05   LIKE imx_file.imx01, # 明細屬性欄位 
            att06   LIKE imx_file.imx01, # 明細屬性欄位 
            att07   LIKE imx_file.imx01, # 明細屬性欄位 
            att08   LIKE imx_file.imx01, # 明細屬性欄位 
            att09   LIKE imx_file.imx01, # 明細屬性欄位 
            att10   LIKE imx_file.imx01, # 明細屬性欄位 
            att11   LIKE imx_file.imx01, # 明細屬性欄位 
            att12   LIKE imx_file.imx01, # 明細屬性欄位 
            att13   LIKE imx_file.imx01, # 明細屬性欄位 
            att14   LIKE imx_file.imx01, # 明細屬性欄位 
            att15   LIKE imx_file.imx01, # 明細屬性欄位 
            att16   LIKE imx_file.imx01, # 明細屬性欄位 
            att17   LIKE imx_file.imx01, # 明細屬性欄位 
            att18   LIKE imx_file.imx01, # 明細屬性欄位 
            att19   LIKE imx_file.imx01, # 明細屬性欄位 
            att20   LIKE imx_file.imx01, # 明細屬性欄位 
            bmb03_b LIKE bmb_file.bmb03, #料件編號             
#            bmb06_b LIKE bmb_file.bmb06, #組成用量             
            bmb06_b LIKE gep_file.gep05, #組成用量      #FUN-630080        
#            bmb08_b LIKE bmb_file.bmb08  #損耗率
            bmb08_b LIKE gep_file.gep05  #損耗率   #FUN-630080
        END RECORD,
    #這個記錄專門用于下條件
    g_bmb03_t       LIKE bmb_file.bmb03,     
    g_rec_b         LIKE type_file.num5,           #No.FUN-680102 SMALLINT
    g_sql           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(400),
    l_ac            LIKE type_file.num5,           #No.FUN-680102 SMALLINT
 
  #用于接收屏幕輸入的記錄                
    g_input                     RECORD
       bmb03                    LIKE gep_file.gep05,
       bmb03a                   LIKE gep_file.gep06,
       bmb06                    LIKE gep_file.gep05, 
       bmb06a                   LIKE gep_file.gep06,
       bmb08                    LIKE gep_file.gep05,
       bmb08a                   LIKE gep_file.gep06
    END RECORD                 
 
#No.TQC-5C0013 --end--  
 
DEFINE g_grdstr LIKE gep_file.gep11  #FUN-630080 Add By Lifeng ,存放網格中輸入項
 
#測試用
{MAIN
DEFINE 
  l_result STRING
 
  DEFER INTERRUPT
 
  CALL aooi503('CL','BOM-CL-01',1) RETURNING l_result
  CALL cl_err(l_result,'',0)
END MAIN}
 
#傳入作為BOM主件的母料件料號，根據當前公式表中的狀況確定是新增或修改當前表格中
#對應的公式,母料件料號用于取得對應的屬性群組代碼(以便Ctrl+J開窗時顯示其擁有的屬性)
#當p_formula為空的時候,母料號還用于生成新的公式編號.
FUNCTION aooi503(p_item,p_formula,p_page)
DEFINE
  p_item                      LIKE ima_file.ima01,         #母料件編號
  p_formula                   LIKE gep_file.gep01,         #傳入的當前可能有的公式前綴(不帶&)
  p_page                      LIKE type_file.num5,           #No.FUN-680102SMALLINT,                #窗口初始狀態下顯示的頁面序號,第一個為1
                              
  l_imaag                     LIKE ima_file.imaag,         #傳入主件的對應屬性群組代碼                            
  l_choice                    LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1),                    #右側提示選項
  l_first_in                  LIKE type_file.num5,           #No.FUN-680102 SMALLINT,                   #是否第一次進入INPUT,這時需要根據p_page判斷當前顯示的頁面
  l_i,l_cnt,l_no,l_count      LIKE type_file.num5,           #No.FUN-680102 SMALLINT,       
  lc_no                       LIKE type_file.chr2,           #No.FUN-680102CHAR(2),
  l_cond                      LIKE type_file.chr20,          #No.FUN-680102CHAR(20),
  l_maxno                     LIKE gep_file.gep01,         #當前BOM表中的最大列表
  l_formula                   LIKE gep_file.gep01,         #新生成的BOM公式前綴(只是個前綴,前后不帶&)
  l_field                     LIKE type_file.num5,           #No.FUN-680102 SMALLINT,                  #用于當出現錯誤時判斷光標停留位置的變量
  l_forex                     STRING,                      #用于顯示在公式范例頁面的范例內容字符串
  l_valid                     LIKE type_file.num5,           #No.FUN-680102 SMALLINT,               #調用方給的p_formula前綴是否有效
                              
  p_name                      LIKE gep_file.gep02,         #新生成的BOM公式名稱
                              
  l_result                    STRING,                      #生成的公式說明的字符串
 
  l_ima01                     LIKE ima_file.ima01,
  l_ges01                     LIKE ges_file.ges01,                              
  l_gep01                     LIKE gep_file.gep01,
  l_ze03                      LIKE ze_file.ze03,
  l_agb03                     LIKE agb_file.agb03,
  
  l_gep01a,l_gep01b,l_gep01c  LIKE gep_file.gep01,         #新的三個公式編號
  l_gep02a,l_gep02b,l_gep02c  LIKE gep_file.gep02,         #新的三個公式名稱
                            
  l_geq03                     LIKE geq_file.geq03,
  l_ges02                     LIKE ges_file.ges02,
  l_ger03                     LIKE ger_file.ger03,
  l_gep02aa                   LIKE gep_file.gep02,
 
  l_pos,l_len        LIKE type_file.num5,           #No.FUN-680102SMALLINT,
  l_pos_ex,l_len1    LIKE type_file.num5,           #No.FUN-680102SMALLINT,
  l_str              LIKE type_file.chr1000,        #No.FUN-680102CHAR(1000),
  str                STRING,
  l_str_tok          base.StringTokenizer,  
                          
  #用于存放三個公式分別的測試結果
  l_success01,l_success02     LIKE type_file.num5,           #No.FUN-680102  SMALLINT,           
  l_success03                 LIKE type_file.num5,           #No.FUN-680102SMALLINT,
                              
  l_bmb03_old                 LIKE gep_file.gep05,
  l_bmb06_old                 LIKE gep_file.gep05,
  l_bmb08_old                 LIKE gep_file.gep05,
                              
  g_gep                       RECORD LIKE gep_file.*       #用于存放新增的信息
 
#No.TQC-5C0013 --start--
DEFINE  g_bma01               LIKE bma_file.bma01,                             
        l_as                  LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)       #接受_construct()傳回的結果 
#No.TQC-5C0013 --end--  
 
 
 
  LET g_bma01 =  p_item
  WHENEVER ERROR CALL cl_err_msg_log
#  IF NOT cl_user() THEN RETURN '' END IF  By Lifeng :這句話一加調用方就報錯
  IF NOT cl_setup("aoo") THEN 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM END IF
 
  #首先判斷是否進行多屬性管理，如果否 則不執行下面的操作
  IF g_sma.sma120 <> 'Y' THEN RETURN '' END IF
  #再判斷該料件是否為母料件，如果否 則不執行下面的操作
  IF NOT cl_is_multi_feature_manage(p_item) THEN RETURN '' END IF
 
  #得到該母料件對應的屬性群組
  SELECT imaag INTO l_imaag FROM ima_file WHERE ima01 = p_item
  IF cl_null(l_imaag) THEN RETURN '' END IF
 
  #得到對應的范例字符串
  LET l_forex = cl_fml_example()
 
  #修正可能有的頁面Index指定錯誤
  #將來再增加頁面時需要修改這里(范例頁面不算)
  IF ( p_page < 1 )OR( p_page > 3) THEN LET p_page = 1 END IF
 
  #初始化公式內容的顯示值并得到本次操作的BOM公式前綴(可能是沿用傳入的也可能是新生成的)
  
  #如果傳入了前綴
  IF NOT cl_null(p_formula) THEN
     #要檢查一下這個東東對不對,即在公式數據表中是否有至少一條對應的公式記錄
     LET l_str = '&',p_formula CLIPPED,'-1&'
     SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
     IF l_count > 0 THEN LET l_valid = TRUE
     ELSE 
       LET l_str = '&',p_formula CLIPPED,'-2&'
       SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
       IF l_count > 0 THEN LET l_valid = TRUE 
       ELSE 
         LET l_str = '&',p_formula CLIPPED,'-3&'
         SELECT COUNT(*) INTO l_count FROM gep_file WHERE gep01 = l_str
         IF l_count > 0 THEN LET l_valid = TRUE  
         ELSE LET l_valid = FALSE 
         END IF 
       END IF 
    END IF 
    
  ELSE
     LET l_valid = FALSE   #如果為空則下面要新建
  END IF 
  	
  #如果傳入的前綴不對,則要自己生成一個新的前綴來代替它
  IF NOT l_valid THEN 
     #如果傳入的公式編號前綴為空則按照規則新增一個公式編號
     #命名規則:&BOM-主件編號前9位-2位流水號-1位序號&
     #前綴規則: BOM-主件編號前9位-2位流水號
     LET l_cond = '_BOM-', p_item[1,9] CLIPPED, '%'  
     #特別說明□按照表達式命名規則，開頭的地方必須是&，但是LIKE &XXX的語句
     #在Oracle中被理解為參數查詢語句，所以只能在首位用通配符"_"取代，因為
     SELECT MAX(gep01) INTO l_maxno FROM gep_file 
       WHERE gep01 LIKE l_cond
     IF l_maxno IS NULL THEN
        #如果沒有找到則給一個初始號
        LET l_formula = 'BOM-',p_item[1,9] CLIPPED, '-01'
     ELSE 
        #取倒數第四,五兩位數字并加一
        #注意最后兩位必須是數字，否則這里將會引起計算錯誤，如果要進行保証則
        #可能得限制BOM公式的代碼和名稱不允許修改
        LET l_no = l_maxno[LENGTH(l_maxno CLIPPED)-4,LENGTH(l_maxno CLIPPED)-3]
        LET l_no = l_no + 1
        LET lc_no = l_no USING '&&'
        LET l_formula = 'BOM-',p_item[1,9] CLIPPED, '-',lc_no
     END IF     
  ELSE  #如果傳入的有效 
     #將傳入內容作為公式前綴
     LET l_formula = p_formula
  END IF
 
  #得到本次對應的三個公式的公式編號和公式名稱
  LET l_gep01a = '&',l_formula CLIPPED,'-1&'    #元件料號公式
  LET l_gep02a = l_formula CLIPPED,'-1'
  LET l_gep01b = '&',l_formula CLIPPED,'-2&'    #組成用量公式
  LET l_gep02b = l_formula CLIPPED,'-2'
  LET l_gep01c = '&',l_formula CLIPPED,'-3&'    #損耗率公式
  LET l_gep02c = l_formula CLIPPED,'-3'
 
  #FUN-630080 Add By Lifeng Start ---
  #得到公式對應的輔助輸入項字符串（需要填充在窗體上半部分的網格中的）
  #這部分信息是存放在子編號為1的那條公式記錄的gep11欄位中
  LET g_grdstr = ''
  SELECT gep11 INTO g_grdstr FROM gep_file WHERE gep01 = l_gep01a
  #FUN-640060 Add End ---
 
  INITIALIZE g_input.* TO NULL   #0407
 
  #先得到元件料號的公式內容
  SELECT gep05,gep06 INTO g_input.bmb03,g_input.bmb03a FROM gep_file WHERE gep01 = l_gep01a
  #再得到元件用量的公式內容
  SELECT gep05,gep06 INTO g_input.bmb06,g_input.bmb06a FROM gep_file WHERE gep01 = l_gep01b
  #再得到損耗率的公式內容
  SELECT gep05,gep06 INTO g_input.bmb08,g_input.bmb08a FROM gep_file WHERE gep01 = l_gep01c
 
  #初始化工作做完，現在開始顯示窗體并接受輸入
  OPEN WINDOW i503_w WITH FORM "aoo/42f/aooi503" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED)   
 
  CALL cl_ui_init()
  CALL cl_ui_locale("aooi503")
  CALL cl_load_act_list("aooi503")
 
 
  LET l_field = 0
  LET l_first_in = TRUE
  
  #保存編輯前的舊值
  LET l_bmb03_old = g_input.bmb03
  LET l_bmb06_old = g_input.bmb06
  LET l_bmb08_old = g_input.bmb08
 
 
  #FUN-630080 Add By Lifeng , 讀取信息填充網格
  CALL i503_loadgrid()
  
  WHILE TRUE
    INPUT g_input.bmb03,g_input.bmb06,g_input.bmb08 WITHOUT DEFAULTS
      FROM bmb03,bmb06,bmb08 ATTRIBUTE(UNBUFFERED) 
    BEFORE INPUT  
      DISPLAY l_forex        TO FORMONLY.forex
      DISPLAY g_input.bmb03a TO bmb03a
      DISPLAY g_input.bmb06a TO bmb06a
      DISPLAY g_input.bmb08a TO bmb08a
      
     CALL i503_construct(g_bma01)  RETURNING l_as  #No.TQC-5C0013
     IF l_as = 1 THEN                                                                                                               
        EXIT INPUT                                                                                                                  
     END IF 
 
     #TQC-860019-add
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     #TQC-860019-add
 
      #如果是第一次進入INPUT,即由外部調用,則要根據調用方指定的p_page來決定顯示哪一個頁面
      #否則是因為底下的檢驗代碼不通過導致的返回,這時就要根據下面指定的l_field來決定了
      IF l_first_in THEN
         #按照標識將光標停在對應的欄位上
         IF p_page = 1 THEN 
            LET l_first_in = FALSE  #以后都不算第一次了      
            NEXT FIELD bmb03 
         END IF
         IF p_page = 2 THEN 
            LET l_first_in = FALSE  #以后都不算第一次了      
            NEXT FIELD bmb06 
         END IF
         IF p_page = 3 THEN 
            LET l_first_in = FALSE  #以后都不算第一次了      
            NEXT FIELD bmb08
         END IF
      ELSE
         #按照標識將光標停在對應的欄位上
         IF l_field = 1 THEN NEXT FIELD bmb03 END IF
         IF l_field = 2 THEN NEXT FIELD bmb06 END IF
         IF l_field = 3 THEN NEXT FIELD bmb08 END IF
      END IF
 
    AFTER INPUT
      #通過比較當前值和備份值來檢查是否有未經過檢測的修改存在
      IF NOT cl_null(g_input.bmb03) THEN 
         LET l_success01 = ( g_input.bmb03 = l_bmb03_old )
      ELSE
         LET l_success01 = TRUE
      END IF
      
      IF NOT cl_null(g_input.bmb06) THEN 
         LET l_success02 = ( g_input.bmb06 = l_bmb06_old )
      ELSE
         LET l_success02 = TRUE
      END IF
 
      IF NOT cl_null(g_input.bmb08) THEN 
         LET l_success03 = ( g_input.bmb08 = l_bmb08_old )
      ELSE
         LET l_success03 = TRUE
      END IF
 
 
    #下面的三組ON ACTION代碼邏輯完全相同,換了字段而已
    
    ON ACTION act_test1
       #拿來測試的不能是空串
       IF cl_null(g_input.bmb03) THEN
          CALL cl_err('','lib-296',0)      #公式內容不能為空
          NEXT FIELD bmb03
       END IF
       #首先調用函數來解析并生成該公式的說明信息
       CALL cl_fml_trans_desc(g_input.bmb03) RETURNING l_result,l_success01
       LET g_input.bmb03a = l_result
       DISPLAY l_result TO bmb03a
       IF NOT l_success01 THEN 
          NEXT FIELD bmb03 
       ELSE   
          #調用測試函數得到公式的計算結果
          CALL cl_fml_run_content(g_input.bmb03,'',1) RETURNING l_result,l_success01
          DISPLAY l_result TO FORMONLY.res01 
          IF NOT l_success01 THEN
             NEXT FIELD bmb03
          END IF 
          #拿校驗過的內容來更新備份值
          LET l_bmb03_old = g_input.bmb03
       END IF
 
    ON ACTION act_test2
       #拿來測試的不能是空串
       IF cl_null(g_input.bmb06) THEN
          CALL cl_err('','lib-296',0)      #公式內容不能為空
          NEXT FIELD bmb06
       END IF
       #首先調用函數來解析并生成該公式的說明信息
       CALL cl_fml_trans_desc(g_input.bmb06) RETURNING l_result,l_success02
       LET g_input.bmb06a = l_result
       DISPLAY l_result TO bmb06a
       IF NOT l_success02 THEN 
          NEXT FIELD bmb06 
       ELSE   
          #調用測試函數得到公式的計算結果
          CALL cl_fml_run_content(g_input.bmb06,'',1) RETURNING l_result,l_success02
          DISPLAY l_result TO FORMONLY.res02 
          IF NOT l_success02 THEN
             NEXT FIELD bmb06
          END IF 
          #拿校驗過的內容來更新備份值
          LET l_bmb06_old = g_input.bmb06
       END IF
 
    ON ACTION act_test3
       #拿來測試的不能是空串
       IF cl_null(g_input.bmb08) THEN
          CALL cl_err('','lib-296',0)      #公式內容不能為空
          NEXT FIELD bmb08
       END IF
       #首先調用函數來解析并生成該公式的說明信息
       CALL cl_fml_trans_desc(g_input.bmb08) RETURNING l_result,l_success03
       LET g_input.bmb08a = l_result
       DISPLAY l_result TO bmb08a
       IF NOT l_success03 THEN 
          NEXT FIELD bmb08 
       ELSE   
          #調用測試函數得到公式的計算結果
          CALL cl_fml_run_content(g_input.bmb08,'',1) RETURNING l_result,l_success03
          DISPLAY l_result TO FORMONLY.res03 
          IF NOT l_success03 THEN
             NEXT FIELD bmb08
          END IF 
          #拿校驗過的內容來更新備份值
          LET l_bmb08_old = g_input.bmb08
       END IF
 
#No.TQC-5C0013 --start--
    ON ACTION act_return1
       CALL i503_construct(g_bma01) RETURNING l_as
       IF l_as = 1 THEN                                                                                                             
          EXIT INPUT                                                                                                                
       END IF 
  
    ON ACTION act_return2
       CALL i503_construct(g_bma01) RETURNING l_as
       IF l_as = 1 THEN                                                                                                             
          EXIT INPUT                                                                                                                
       END IF 
  
    ON ACTION act_return3
       CALL i503_construct(g_bma01) RETURNING l_as
       IF l_as = 1 THEN                                                                                                             
          EXIT INPUT                                                                                                                
       END IF 
#No.TQC-5C0013 --end--
  
#No.TQC-5C0013           
#    ON ACTION CONTROLH  #Control + H 開料件編號窗,只對元件料號欄位有效
    ON ACTION choose_itemno  #Control + H 開料件編號窗,只對元件料號欄位有效
       CASE 
         WHEN INFIELD(bmb03) 
           #開窗規則應該與BOM單身料件開窗規則完全一樣,但開窗完返回的內容應該是插入而不是取代
           LET l_ima01 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
#FUN-AA0059 --Begin--
         #  CALL cl_init_qry_var()
         #  LET g_qryparam.form ="q_ima"
         #  LET g_qryparam.default1 = ""
         #  CALL cl_create_qry() RETURNING l_ima01
           CALL q_sel_ima(FALSE, "q_ima", "", '', "", "", "", "" ,"",'' )  RETURNING l_ima01
#FUN-AA0059 --End--
           #得到返回字符串的長度
           LET l_ima01 = l_ima01 CLIPPED
           LET l_len = LENGTH(l_ima01)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb03 = l_ima01,l_str
           ELSE
              LET g_input.bmb03 = l_str[1,l_pos-1],l_ima01,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb03
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb03 這里一定不能有這一句話，否則光標的位置就到第一個去了
                               
          OTHERWISE
             CALL cl_err('','abm-999',1)  #No.TQC-5C0013
             EXIT CASE
       END CASE
 
#No.TQC-5C0013           
#    ON ACTION CONTROLP  #Control + P 開參數窗
    ON ACTION choose_param  #Control + P 開參數窗
       CASE
         #元件編號欄位
         WHEN INFIELD(bmb03) #公式內容Ctrl+P開變量窗            
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_ges01 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_ges"
           LET g_qryparam.default1 = ""
           CALL cl_create_qry() RETURNING l_ges01
           #得到返回字符串的長度
           LET l_ges01 = l_ges01 CLIPPED
           LET l_len = LENGTH(l_ges01)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb03 = l_ges01,l_str
           ELSE
              LET g_input.bmb03 = l_str[1,l_pos-1],l_ges01,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb03
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb03 這里一定不能有這一句話，否則光標的位置就到第一個去了    
           
         #組成用量欄位
         WHEN INFIELD(bmb06) #公式內容Ctrl+P開變量窗            
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_ges01 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_ges"
           LET g_qryparam.default1 = ""
           CALL cl_create_qry() RETURNING l_ges01
           #得到返回字符串的長度
           LET l_ges01 = l_ges01 CLIPPED
           LET l_len = LENGTH(l_ges01)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb06 = l_ges01,l_str
           ELSE
              LET g_input.bmb06 = l_str[1,l_pos-1],l_ges01,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb06
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb06 這里一定不能有這一句話，否則光標的位置就到第一個去了               
 
         #組成用量欄位
         WHEN INFIELD(bmb08) #公式內容Ctrl+P開變量窗            
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_ges01 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_ges"
           LET g_qryparam.default1 = ""
           CALL cl_create_qry() RETURNING l_ges01
           #得到返回字符串的長度
           LET l_ges01 = l_ges01 CLIPPED
           LET l_len = LENGTH(l_ges01)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb08 = l_ges01,l_str
           ELSE
              LET g_input.bmb08 = l_str[1,l_pos-1],l_ges01,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb08
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb08 這里一定不能有這一句話，否則光標的位置就到第一個去了               
 
           OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLG                                                                                                              
       CALL cl_cmdask() 
#No.TQC-5C0013           
#    ON ACTION CONTROLJ  #Control + J 開屬性窗
    ON ACTION choose_attribute  #Control + J 開屬性窗
       #對于屬性開窗要進行特殊的處理,因為只能選擇當前母料件擁有的屬性
       #而且屬性名稱前后是不帶#的,所以要進行添加
       CASE
         #元件編號欄位
         WHEN INFIELD(bmb03) #公式內容Ctrl+J開屬性窗            
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_agb03 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_agb"
           LET g_qryparam.default1 = ""
           LET g_qryparam.arg1 = l_imaag    #傳入當前母料號的屬性群組
           CALL cl_create_qry() RETURNING l_agb03
           #得到返回字符串的長度
           LET l_agb03 = "#",l_agb03 CLIPPED,"#"
           LET l_len = LENGTH(l_agb03)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb03 = l_agb03,l_str
           ELSE
              LET g_input.bmb03 = l_str[1,l_pos-1],l_agb03,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb03
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb03 這里一定不能有這一句話，否則光標的位置就到第一個去了    
 
         #組成用量欄位
         WHEN INFIELD(bmb06) #公式內容Ctrl+J開屬性窗            
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_agb03 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_agb"
           LET g_qryparam.default1 = ""
           LET g_qryparam.arg1 = l_imaag    #傳入當前母料號的屬性群組
           CALL cl_create_qry() RETURNING l_agb03
           #得到返回字符串的長度
           LET l_agb03 = "#",l_agb03 CLIPPED,"#"
           LET l_len = LENGTH(l_agb03)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb06 = l_agb03,l_str
           ELSE
              LET g_input.bmb06 = l_str[1,l_pos-1],l_agb03,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb06
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb06 這里一定不能有這一句話，否則光標的位置就到第一個去了    
 
         #損耗率欄位
         WHEN INFIELD(bmb08) #公式內容Ctrl+J開屬性窗            
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_agb03 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_agb"
           LET g_qryparam.default1 = ""
           LET g_qryparam.arg1 = l_imaag    #傳入當前母料號的屬性群組
           CALL cl_create_qry() RETURNING l_agb03
           #得到返回字符串的長度
           LET l_agb03 = "#",l_agb03 CLIPPED,"#"
           LET l_len = LENGTH(l_agb03)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb08 = l_agb03,l_str
           ELSE
              LET g_input.bmb08 = l_str[1,l_pos-1],l_agb03,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb08
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb08 這里一定不能有這一句話，否則光標的位置就到第一個去了    
 
         OTHERWISE EXIT CASE
       END CASE
 
#No.TQC-5C0013           
#    ON ACTION CONTROLK  #Control + K 開表達式窗
    ON ACTION choose_expression  #Control + K 開表達式窗
       #公式內容Ctrl+K標識開表達式窗
       CASE 
         #元件編號欄位
         WHEN INFIELD(bmb03) 
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_gep01 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_gep"
           LET g_qryparam.default1 = ""
           CALL cl_create_qry() RETURNING l_gep01
           #得到返回字符串的長度
           LET l_gep01 = l_gep01 CLIPPED
           LET l_len = LENGTH(l_gep01)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb03 = l_gep01,l_str
           ELSE
              LET g_input.bmb03 = l_str[1,l_pos-1],l_gep01,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb03
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb03 這里一定不能有這一句話，否則光標的位置就到第一個去了
 
         #組成用量欄位
         WHEN INFIELD(bmb06) 
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_gep01 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_gep"
           LET g_qryparam.default1 = ""
           CALL cl_create_qry() RETURNING l_gep01
           #得到返回字符串的長度
           LET l_gep01 = l_gep01 CLIPPED
           LET l_len = LENGTH(l_gep01)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb06 = l_gep01,l_str
           ELSE
              LET g_input.bmb06 = l_str[1,l_pos-1],l_gep01,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb06
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb06 這里一定不能有這一句話，否則光標的位置就到第一個去了
 
         #損耗率欄位
         WHEN INFIELD(bmb08) 
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_gep01 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_gep"
           LET g_qryparam.default1 = ""
           CALL cl_create_qry() RETURNING l_gep01
           #得到返回字符串的長度
           LET l_gep01 = l_gep01 CLIPPED
           LET l_len = LENGTH(l_gep01)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb08 = l_gep01,l_str
           ELSE
              LET g_input.bmb08 = l_str[1,l_pos-1],l_gep01,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb08
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb08 這里一定不能有這一句話，否則光標的位置就到第一個去了
             
          OTHERWISE EXIT CASE
       END CASE
 
#No.TQC-5C0013
#    ON ACTION CONTROLL  #Control + L 開函數窗
    ON ACTION choose_mathfuntion  #Control + L 開函數窗
       #公式內容Ctrl+L標識開函數窗
       CASE 
         #元件料號欄位
         WHEN INFIELD(bmb03) 
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_ze03 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_fun"
           LET g_qryparam.default1 = ""
           LET g_qryparam.arg1 = g_lang  #查詢當前語言別下的提示字符串
           CALL cl_create_qry() RETURNING l_ze03
           
           #函數開窗的特別加工,因為是放在ze_file中的，所以函數的名稱和說明
           #信息是在一個字符串中的，但是我們要的返回值應該只有函數名稱，所以
           #要進行分離操作
           LET str = l_ze03 CLIPPED
           LET l_pos_ex = str.getIndexOf(' ',1)
           IF l_pos_ex = 0 THEN LET l_pos_ex = 1 END IF
           LET l_ze03 = str.subString(1,l_pos_ex)
          
           #得到返回字符串的長度
           LET l_ze03 = l_ze03 CLIPPED
           LET l_len = LENGTH(l_ze03)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb03 = l_ze03,l_str
           ELSE
              LET g_input.bmb03 = l_str[1,l_pos-1],l_ze03,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb03
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb03 這里一定不能有這一句話，否則光標的位置就到第一個去了
 
         #組成用量欄位
         WHEN INFIELD(bmb06) 
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_ze03 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_fun"
           LET g_qryparam.default1 = ""
           LET g_qryparam.arg1 = g_lang  #查詢當前語言別下的提示字符串
           CALL cl_create_qry() RETURNING l_ze03
           
           #函數開窗的特別加工,因為是放在ze_file中的，所以函數的名稱和說明
           #信息是在一個字符串中的，但是我們要的返回值應該只有函數名稱，所以
           #要進行分離操作
           LET str = l_ze03 CLIPPED
           LET l_pos_ex = str.getIndexOf(' ',1)
           IF l_pos_ex = 0 THEN LET l_pos_ex = 1 END IF
           LET l_ze03 = str.subString(1,l_pos_ex)
          
           #得到返回字符串的長度
           LET l_ze03 = l_ze03 CLIPPED
           LET l_len = LENGTH(l_ze03)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb06 = l_ze03,l_str
           ELSE
              LET g_input.bmb06 = l_str[1,l_pos-1],l_ze03,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb06
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb06 這里一定不能有這一句話，否則光標的位置就到第一個去了
 
         #損耗率欄位
         WHEN INFIELD(bmb08) 
           #注意這里的開窗后返回的內容是在文本中當前光標位置添加
           LET l_ze03 = ''
           #得到當前Field的內容
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_str
           #記錄當前光標位置
           LET l_pos = FGL_GETCURSOR()
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_fun"
           LET g_qryparam.default1 = ""
           LET g_qryparam.arg1 = g_lang  #查詢當前語言別下的提示字符串
           CALL cl_create_qry() RETURNING l_ze03
           
           #函數開窗的特別加工,因為是放在ze_file中的，所以函數的名稱和說明
           #信息是在一個字符串中的，但是我們要的返回值應該只有函數名稱，所以
           #要進行分離操作
           LET str = l_ze03 CLIPPED
           LET l_pos_ex = str.getIndexOf(' ',1)
           IF l_pos_ex = 0 THEN LET l_pos_ex = 1 END IF
           LET l_ze03 = str.subString(1,l_pos_ex)
          
           #得到返回字符串的長度
           LET l_ze03 = l_ze03 CLIPPED
           LET l_len = LENGTH(l_ze03)
           LET l_len1 = LENGTH(l_str)
           #防止在字符串為空或位于最后一個字符的時候發生下標越界錯誤
           IF l_len1 < l_pos THEN LET l_len1 = l_pos END IF
           #將返回字符串插入到當前文本中光標所在的位置
           IF l_pos = 1 THEN
              LET g_input.bmb08 = l_ze03,l_str
           ELSE
              LET g_input.bmb08 = l_str[1,l_pos-1],l_ze03,l_str[l_pos,l_len1]
           END IF
           DISPLAY BY NAME g_input.bmb08
           #將插入后的光標位置置于插入文本的末尾
           CALL FGL_DIALOG_SETCURSOR(l_pos+l_len)
           #NEXT FIELD bmb08 這里一定不能有這一句話，否則光標的位置就到第一個去了
           
         OTHERWISE EXIT CASE
       END CASE
      
    END INPUT
    IF INT_FLAG OR (l_as =1 )THEN   #No.TQC-5C0013
       LET INT_FLAG = 0
       CLOSE WINDOW i503_w
       RETURN ''
    END IF 
 
    #限制用戶必須先進行過測試并跑出正確結果了才允許保存□    
    IF NOT l_success01 THEN 
       CALL cl_err('','lib-250',1)     #在元件料號公式保存前必須先經過測試
       LET l_field = 1
       CONTINUE WHILE
    END IF
    IF NOT l_success02 THEN
       CALL cl_err('','lib-251',1)     #在組成用量公式保存前必須先經過測試
       LET l_field = 2
       CONTINUE WHILE
    END IF
    IF NOT l_success03 THEN
       CALL cl_err('','lib-252',1)     #在損耗率公式保存前必須先經過測試
       LET l_field = 3
       CONTINUE WHILE
    END IF
 
    #下面開始數據庫操作
    BEGIN WORK
    
    #刪除可能有的原來的公式記錄,單身參數記錄和單身表達式記錄
    #公式記錄
    DELETE FROM gep_file 
      WHERE gep01 = l_gep01a OR 
            gep01 = l_gep01b OR
            gep01 = l_gep01c
    IF SQLCA.sqlcode THEN
#      CALL cl_err(p_formula,SQLCA.sqlcode,1)   #No.FUN-660131
       CALL cl_err3("del","gep_file",p_formula,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       ROLLBACK WORK
       CONTINUE WHILE
    END IF       
    #單身參數記錄
    DELETE FROM geq_file 
      WHERE geq01 = l_gep01a OR 
            geq01 = l_gep01b OR
            geq01 = l_gep01c
    IF SQLCA.sqlcode THEN
#      CALL cl_err(p_formula,SQLCA.sqlcode,1)   #No.FUN-660131
       CALL cl_err3("del","geq_file",p_formula,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       ROLLBACK WORK
       CONTINUE WHILE
    END IF     
    #單身表達式記錄
    DELETE FROM ger_file 
      WHERE ger01 = l_gep01a OR 
            ger01 = l_gep01b OR
            ger01 = l_gep01c
    IF SQLCA.sqlcode THEN
#      CALL cl_err(p_formula,SQLCA.sqlcode,1)   #No.FUN-660131
       CALL cl_err3("del","ger_file",p_formula,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
       ROLLBACK WORK
       CONTINUE WHILE
    END IF     
          
    
 
    #以下全部是按照新增操作來進行
    #公共部分
    LET g_gep.gep03 = 'Y'             #從此見面中創建的公式都算已經審核過
    LET g_gep.gep04 = g_today         #審核日期
    LET g_gep.gep07 = 'BOM'           #公式分類碼默認為'BOM'
   #LET g_gep.gep08 =
   #LET g_gep.gep09 =
   #LET g_gep.gep10 =
    LET g_gep.gepacti = 'Y'
    LET g_gep.gepuser = g_user
    #LET g_gep.geporiu = g_user #FUN-980030
    #LET g_gep.geporig = g_grup #FUN-980030
    LET g_gep.gepgrup = g_grup
    LET g_gep.gepmodu = g_user
    LET g_gep.gepdate = g_today
 
    #------------------------插入元件料號公式------------------------------
    #因為并不嚴格限制必須輸入公式文本,所以這里需要進行判斷,如果某個欄位沒有輸入
    #內容,則不插入該欄位對應的公式信息
    IF NOT cl_null(g_input.bmb03) THEN
       #元件料號公式特殊信息
       LET g_gep.gep01 = l_gep01a        #BOM公式的編號是自動建立的
       LET g_gep.gep02 = l_gep02a        #BOM公式的名稱和編號相同
       LET g_gep.gep05 = g_input.bmb03 
       LET g_gep.gep06 = g_input.bmb03a
       LET g_gep.gep11 = g_grdstr       #FUN-630080 By Lifeng , 回寫輔助項目
       #插入元件料號的公式信息
       INSERT INTO gep_file VALUES(g_gep.*)
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_gep.gep01,SQLCA.sqlcode,1)   #No.FUN-660131
          CALL cl_err3("ins","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
          ROLLBACK WORK
          CONTINUE WHILE
       END IF
       #解析元件料號公式并生成對應的geq變量信息
       CALL cl_fml_extract_param(g_gep.gep05,'$') RETURNING l_result  
       LET l_i = 0
       LET l_str_tok = base.StringTokenizer.create(l_result,'|')
       WHILE l_str_tok.hasMoretokens()
         LET l_i = l_i + 1                                               #序號
         LET l_geq03 = l_str_tok.nextToken()                             #變量代碼
         SELECT ges02 INTO l_ges02 FROM ges_file WHERE ges01 = l_geq03   #對應的變量名稱
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_geq03,'aoo-155',1)                             #變量代碼不存在,請檢查是否輸入錯誤   #No.FUN-660131
            CALL cl_err3("sel","ges_file",l_geq03,"","aoo-155","","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       
         INSERT INTO geq_file(geq01,geq02,geq03,geq04) 
           VALUES(g_gep.gep01,l_i,l_geq03,l_ges02) 
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_geq03,SQLCA.sqlcode,1)          #No.FUN-660131
            CALL cl_err3("ins","geq_file",l_geq03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF         
       END WHILE
       
       #解析元件料號公式并生成對應的ger表達式信息
       CALL cl_fml_extract_param(g_gep.gep05,'&') RETURNING l_result  
       LET l_i = 0
       LET l_str_tok = base.StringTokenizer.create(l_result,'|')
       WHILE l_str_tok.hasMoretokens()
         LET l_i = l_i + 1                                                #序號
         LET l_ger03 = l_str_tok.nextToken()                              #表達式代碼
         SELECT gep02 INTO l_gep02aa FROM gep_file WHERE gep01 = l_ger03  #對應的表達式名稱
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_ger03,'aoo-156',1)                              #表達式代碼不存在,請檢查是否輸入錯誤   #No.FUN-660131
            CALL cl_err3("sel","gep_file",l_ger03,"","aoo-156","","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       
         INSERT INTO ger_file(ger01,ger02,ger03,ger04) 
           VALUES(g_gep.gep01,l_i,l_ger03,l_gep02aa)  
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_ger03,SQLCA.sqlcode,1)          #No.FUN-660131
            CALL cl_err3("ins","ger_file",l_ger03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       END WHILE
    END IF 
 
    #------------------------插入組成用量公式------------------------------
    #因為并不嚴格限制必須輸入公式文本,所以這里需要進行判斷,如果某個欄位沒有輸入
    #內容,則不插入該欄位對應的公式信息
    IF NOT cl_null(g_input.bmb06) THEN
       #組成用量公式特殊信息
       LET g_gep.gep01 = l_gep01b        #BOM公式的編號是自動建立的
       LET g_gep.gep02 = l_gep02b        #BOM公式的名稱和編號相同
       LET g_gep.gep05 = g_input.bmb06 
       LET g_gep.gep06 = g_input.bmb06a
       #插入元件料號的公式信息
       INSERT INTO gep_file VALUES(g_gep.*)
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_gep.gep01,SQLCA.sqlcode,1)   #No.FUN-660131
          CALL cl_err3("ins","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
          ROLLBACK WORK
          CONTINUE WHILE
       END IF
       #解析元件料號公式并生成對應的geq變量信息
       CALL cl_fml_extract_param(g_gep.gep05,'$') RETURNING l_result  
       LET l_i = 0
       LET l_str_tok = base.StringTokenizer.create(l_result,'|')
       WHILE l_str_tok.hasMoretokens()
         LET l_i = l_i + 1                                               #序號
         LET l_geq03 = l_str_tok.nextToken()                             #變量代碼
         SELECT ges02 INTO l_ges02 FROM ges_file WHERE ges01 = l_geq03   #對應的變量名稱
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_geq03,'aoo-155',1)                             #變量代碼不存在,請檢查是否輸入錯誤   #No.FUN-660131
            CALL cl_err3("sel","ges_file",l_geq03,"","aoo-155","","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       
         INSERT INTO geq_file(geq01,geq02,geq03,geq04) 
           VALUES(g_gep.gep01,l_i,l_geq03,l_ges02) 
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_geq03,SQLCA.sqlcode,1)          #No.FUN-660131
            CALL cl_err3("ins","geq_file",l_geq03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF         
       END WHILE
       
       #解析元件料號公式并生成對應的ger表達式信息
       CALL cl_fml_extract_param(g_gep.gep05,'&') RETURNING l_result  
       LET l_i = 0
       LET l_str_tok = base.StringTokenizer.create(l_result,'|')
       WHILE l_str_tok.hasMoretokens()
         LET l_i = l_i + 1                                                #序號
         LET l_ger03 = l_str_tok.nextToken()                              #表達式代碼
         SELECT gep02 INTO l_gep02aa FROM gep_file WHERE gep01 = l_ger03  #對應的表達式名稱
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_ger03,'aoo-156',1)                              #表達式代碼不存在,請檢查是否輸入錯誤   #No.FUN-660131
            CALL cl_err3("sel","gep_file",l_ger03,"","aoo-156","","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       
         INSERT INTO ger_file(ger01,ger02,ger03,ger04) 
           VALUES(g_gep.gep01,l_i,l_ger03,l_gep02aa)  
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_ger03,SQLCA.sqlcode,1)          #No.FUN-660131
            CALL cl_err3("ins","ger_file",l_ger03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       END WHILE
    END IF 
 
    #------------------------插入損耗率公式------------------------------
    #因為并不嚴格限制必須輸入公式文本,所以這里需要進行判斷,如果某個欄位沒有輸入
    #內容,則不插入該欄位對應的公式信息
    IF NOT cl_null(g_input.bmb08) THEN
       #損耗率公式特殊信息
       LET g_gep.gep01 = l_gep01c        #BOM公式的編號是自動建立的
       LET g_gep.gep02 = l_gep02c        #BOM公式的名稱和編號相同
       LET g_gep.gep05 = g_input.bmb08 
       LET g_gep.gep06 = g_input.bmb08a
       #插入元件料號的公式信息
       INSERT INTO gep_file VALUES(g_gep.*)
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_gep.gep01,SQLCA.sqlcode,1)   #No.FUN-660131
          CALL cl_err3("ins","gep_file",g_gep.gep01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
          ROLLBACK WORK
          CONTINUE WHILE
       END IF
       #解析元件料號公式并生成對應的geq變量信息
       CALL cl_fml_extract_param(g_gep.gep05,'$') RETURNING l_result  
       LET l_i = 0
       LET l_str_tok = base.StringTokenizer.create(l_result,'|')
       WHILE l_str_tok.hasMoretokens()
         LET l_i = l_i + 1                                               #序號
         LET l_geq03 = l_str_tok.nextToken()                             #變量代碼
         SELECT ges02 INTO l_ges02 FROM ges_file WHERE ges01 = l_geq03   #對應的變量名稱
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_geq03,'aoo-155',1)                             #變量代碼不存在,請檢查是否輸入錯誤   #No.FUN-660131
            CALL cl_err3("sel","ges_file",l_geq03,"","aoo-155","","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       
         INSERT INTO geq_file(geq01,geq02,geq03,geq04) 
           VALUES(g_gep.gep01,l_i,l_geq03,l_ges02) 
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_geq03,SQLCA.sqlcode,1)          #No.FUN-660131
            CALL cl_err3("ins","geq_file",l_geq03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF         
       END WHILE
       
       #解析元件料號公式并生成對應的ger表達式信息
       CALL cl_fml_extract_param(g_gep.gep05,'&') RETURNING l_result  
       LET l_i = 0
       LET l_str_tok = base.StringTokenizer.create(l_result,'|')
       WHILE l_str_tok.hasMoretokens()
         LET l_i = l_i + 1                                                #序號
         LET l_ger03 = l_str_tok.nextToken()                              #表達式代碼
         SELECT gep02 INTO l_gep02aa FROM gep_file WHERE gep01 = l_ger03  #對應的表達式名稱
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_ger03,'aoo-156',1)                              #表達式代碼不存在,請檢查是否輸入錯誤   #No.FUN-660131
            CALL cl_err3("sel","gep_file",l_ger03,"","aoo-156","","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       
         INSERT INTO ger_file(ger01,ger02,ger03,ger04) 
           VALUES(g_gep.gep01,l_i,l_ger03,l_gep02aa)  
         IF SQLCA.sqlcode THEN
#           CALL cl_err(l_ger03,SQLCA.sqlcode,1)          #No.FUN-660131
            CALL cl_err3("ins","ger_file",l_ger03,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            ROLLBACK WORK
            CONTINUE WHILE
         END IF  
       END WHILE    
    END IF 
 
    #成功插入所有的新公式,可以提交了
    COMMIT WORK
    
    EXIT WHILE
  END WHILE
 
  #關閉當前窗口
  CLOSE WINDOW i503_w
 
  #將本次公式的前綴返回
  IF cl_null(g_input.bmb03) AND cl_null(g_input.bmb06) AND
     cl_null(g_input.bmb08) THEN  
     RETURN ''   #如果當前所有項目均為空,則返回一個空值(沒有定義公式)
  ELSE
     RETURN l_formula
  END IF
  
END FUNCTION
 
#No.TQC-5C0013 --start--
FUNCTION i503_construct(p_bma01)
DEFINE p_bma01         LIKE bma_file.bma01
DEFINE l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否                   #No.FUN-680102 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態                     #No.FUN-680102 VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1),             #可新增否                                                                                
       l_allow_delete  LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)              #可刪除否              
DEFINE l_agb03       LIKE agb_file.agb03
DEFINE l_agc01       LIKE agc_file.agc01
DEFINE l_agc02       LIKE agc_file.agc02
DEFINE l_agd01       LIKE agd_file.agd01
DEFINE l_agd02       LIKE agd_file.agd02
DEFINE l_agd03       LIKE agd_file.agd03
DEFINE l_ima01       LIKE ima_file.ima01,
       l_imaag       LIKE ima_file.imaag,
       l_imaag1      LIKE ima_file.imaag1
DEFINE l_msg         STRING,
       l_msg1        STRING,
       lsb_item      base.StringBuffer,                                                                                                  
       lsb_value     base.StringBuffer, 
       i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
       l_sql         LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(400),
       l_wc          LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(500),
       l_n,l_c       LIKE type_file.num5,          #No.FUN-680102 SMALLINT
       l_ac_t        LIKE type_file.num5           #No.FUN-680102 SMALLINT
 
    CREATE TEMP TABLE tmp_file(                                                                                                      
        tmp_bmb03    LIKE bmb_file.bmb03,                                                                                                    
        tmp_bmb06    LIKE bmb_file.bmb06,                                                                                                
        tmp_bmb08    LIKE bmb_file.bmb08)                                                                                                
    CREATE INDEX tmp_01 ON tmp_file(tmp_bmb03)   
 
     FOR i = 1 TO 10
         LET l_msg = 'att',2*i-1 USING '&&'
         LET l_msg1 = 'att',2*i USING '&&'
         CALL cl_set_comp_visible(l_msg,FALSE)
         CALL cl_set_comp_visible(l_msg1,FALSE)
     END FOR
 
     SELECT ima01,imaag,imaag1                                                                                                      
       INTO l_ima01,l_imaag,l_imaag1                                                                                                
       FROM ima_file                                                                                                                
      WHERE ima01 = p_bma01                                                                                                        
                                                                                                                                    
     IF NOT cl_null(l_imaag) THEN                                                                                                   
       IF l_imaag <> '@CHILD' THEN                                                                                                  
          LET l_sql = "SELECT agb03,agc01,agc02 from agb_file,aga_file,agc_file ",                                                                       
                      " WHERE agb01 = aga01",                                                                                       
                      "   AND agb01 = '",l_imaag,"'",
                      "   AND agb03 = agc01"                                                                                
       ELSE                                                                                                                         
          LET l_sql = "SELECT agb03,agc01,agc02 from agb_file,aga_file,agc_file ",                                                                       
                      " WHERE agb01 = aga01",                                                                                       
                      "   AND agb01 = '",l_imaag1,"'",                                                                               
                      "   AND agb03 = agc01"                                                                                
       END IF                                                                                                                       
     END IF                                                                                                                         
     PREPARE i503_tmp1 FROM l_sql                                                                                                  
     DECLARE tmp1_cur CURSOR FOR i503_tmp1  
 
     LET i=1                                                                                                                        
     CALL g_value.clear() 
     FOREACH tmp1_cur INTO l_agb03,l_agc01,l_agc02   
         #判斷循環的正確性                                                                                                
        IF STATUS THEN                                                                                                   
           CALL cl_err('foreach agb',STATUS,0)                                                                           
           EXIT FOREACH                                                                                                  
        END IF         
        SELECT count(*) INTO l_n
          FROM agd_file
         WHERE agd01 = l_agc01
 
        IF l_n >0 THEN 
          LET l_msg = 'att',2*i-1 USING '&&'
          LET l_msg1 = 'att',2*i USING '&&'
          CALL cl_set_comp_att_text(l_msg,l_agc02)
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_visible(l_msg1,FALSE)
 
          LET g_value[2*i-1].fname = l_msg                                                                              
          LET g_value[2*i-1].visible = 'Y'                                                                              
#         LET g_value[2*i-1].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                                       
          LET g_value[2*i-1].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                                       
          LET g_value[2*i-1].nvalue = '#',l_agc01,'#'
          LET g_value[2*i].fname = l_msg1                                                                              
          LET g_value[2*i].visible = 'N'                                                                              
#         LET g_value[2*i].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
          LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
          LET g_value[2*i].nvalue = ''
          #填充組合框中的選項                                                                                           
          LET lsb_item  = base.StringBuffer.create()                                                                    
          LET lsb_value = base.StringBuffer.create()                                                                    
          DECLARE agd_cur CURSOR FOR                                                                                    
          SELECT agd02,agd03 FROM agd_file                                                                              
           WHERE agd01 = l_agb03                                                                               
          FOREACH agd_cur INTO l_agd02,l_agd03                                                                          
            IF STATUS THEN                                                                                              
               CALL cl_err('foreach agb',STATUS,0)                 
               EXIT FOREACH                                                                                             
            END IF                                                                                                      
            #lsb_value放選項的說明 
#1222 --start--
            IF lsb_value IS NULL THEN                                                                                     
#               LET lsb_value = l_agd02 CLIPPED,":",l_agd03 CLIPPED
                CALL lsb_value.append(l_agd03 CLIPPED || ":" ||l_agd03 CLIPPED || ",")
#               CALL lsb_value.append(l_agd03 CLIPPED || ",")                                                               
            ELSE
#               LET lsb_value = lsb_value,",",l_agd02 CLIPPED,":",l_agd03 CLIPPED
                CALL lsb_value.append(lsb_value || "," ||l_agd02|| ":" ||l_agd03 CLIPPED || ",")
            END IF
            #lsb_item放選項的值                                                                                         
            IF lsb_item IS NULL THEN                                                                                     
#               CALL lsb_item.append(l_agd02 CLIPPED || ",")                                                                
#               LET lsb_item = l_agd02 CLIPPED
                CALL lsb_item.append(l_agd02 CLIPPED || ",")
            ELSE
#               LET lsb_item = lsb_item,",",l_agd02 CLIPPED
                CALL lsb_item.append(lsb_item || "," ||l_agd02 CLIPPED || ",")
            END IF
          END FOREACH                                                                                                   
          CALL cl_set_combo_items(l_msg,lsb_item.toString(),                                                            
                                   lsb_value.toString())        
        ELSE
          LET l_msg = 'att',2*i USING '&&'
          LET l_msg1= 'att',2*i-1 USING '&&'
          CALL cl_set_comp_att_text(l_msg ,l_agc02)
          CALL cl_set_comp_visible(l_msg,TRUE)
          CALL cl_set_comp_visible(l_msg1,FALSE)
          LET g_value[2*i].fname = l_msg                                                                              
          LET g_value[2*i].visible = 'Y'                                                                              
#         LET g_value[2*i].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
          LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
          LET g_value[2*i].nvalue = '#',l_agc01,'#'
          LET g_value[2*i-1].fname = l_msg1                                                                              
          LET g_value[2*i-1].visible = 'N'                                                                              
#         LET g_value[2*i-1].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
          LET g_value[2*i-1].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
          LET g_value[2*i-1].nvalue = ''
        END IF    
 
        LET i = i + 1                                                                                                
        #這里防止下標溢出導致錯誤                                                                                        
        IF i = 11 THEN EXIT FOREACH END IF                                                                             
     END FOREACH          
 
     FOR i = i TO 10
        LET l_msg = 'att',2*i-1 USING '&&'
        LET l_msg1= 'att',2*i USING '&&'
        CALL cl_set_comp_visible(l_msg,FALSE)
        CALL cl_set_comp_visible(l_msg1,FALSE)
        LET g_value[2*i-1].fname = l_msg                                                                              
        LET g_value[2*i-1].visible = 'N'                                                                              
#       LET g_value[2*i-1].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                   
        LET g_value[2*i-1].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                         
        LET g_value[2*i-1].nvalue = ''
        LET g_value[2*i].fname = l_msg1                                                                              
        LET g_value[2*i].visible = 'N'                                                                              
#       LET g_value[2*i].imx000 = 'imx000',i USING '&&'  #No.TQC-660059  MARK                                                       
        LET g_value[2*i].imx000 = 'imx',i USING '&&'  #No.TQC-660059                                                       
        LET g_value[2*i].nvalue = ''
     END FOR
 
     CALL cl_set_comp_visible('Item No',TRUE)
     CALL cl_set_comp_visible('QPA',TRUE)
     CALL cl_set_comp_visible('Wastg.%',TRUE)
 
     CALL i503_b(p_bma01)  #FUN-630080 加了傳參
     IF INT_FLAG THEN                                                                                                               
        RETURN 1                                                                                                                    
     ELSE                                                                                                                           
        RETURN 0                                                                                                                    
     END IF 
 
END FUNCTION
 
FUNCTION i503_b(p_bma01)
DEFINE p_bma01         LIKE bma_file.bma01
DEFINE l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
       l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102CHAR(1),        #可新增否                                                                                
       l_allow_delete  LIKE type_file.chr1            #No.FUN-680102CHAR(1)            #可刪除否              
DEFINE l_agb03       LIKE agb_file.agb03
DEFINE l_agc01       LIKE agc_file.agc01
DEFINE l_agc02       LIKE agc_file.agc02
DEFINE l_agd01       LIKE agd_file.agd01
DEFINE l_agd02       LIKE agd_file.agd02
DEFINE l_agd03       LIKE agd_file.agd03
DEFINE l_bmb03_b_t   LIKE bmb_file.bmb03
DEFINE l_ima01       LIKE ima_file.ima01,
       l_imaag       LIKE ima_file.imaag,
       l_imaag1      LIKE ima_file.imaag1
DEFINE l_msg         STRING,
       l_msg1        STRING,
       l_default     STRING,
       lsb_item      base.StringBuffer,                                                                                                  
       lsb_value     base.StringBuffer, 
       i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
       l_sql          LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(400),
       l_wc          LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(500),
       l_n,l_c       LIKE type_file.num5,           #No.FUN-680102 SMALLINT
       l_ac_t        LIKE type_file.num5,          #No.FUN-680102 SMALLINT
       l_result      STRING,
       l_return      STRING,
       l_success01,l_success02     LIKE type_file.num5,           #No.FUN-680102 SMALLINT               
       l_success03                 LIKE type_file.num5,           #No.FUN-680102SMALLINT
       l_bmb03_old                 LIKE gep_file.gep05,
       l_bmb06_old                 LIKE gep_file.gep05,
       l_bmb08_old                 LIKE gep_file.gep05
DEFINE l_str        LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(1000),
       l_pos1,l_len,l_len1  LIKE type_file.num5,           #No.FUN-680102SMALLINT
       l_bmb06_b     LIKE gep_file.gep05,
       l_bmb08_b     LIKE gep_file.gep05
                              
     # CALL g_bmb.clear()  #FUN-630080 Marked By Lifeng , 不需要清空原有內容                                                                                                        
     LET g_rec_b = 0  
 
     LET l_allow_insert = cl_detail_input_auth('insert')                                                                             
     LET l_allow_delete = cl_detail_input_auth('delete')                                                                             
                                                                                                                                    
     INPUT ARRAY g_bmb WITHOUT DEFAULTS FROM s_att.*
     #TQC-630106 add {MAXCOUNT = g_max_rec} 
     ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT = g_max_rec,UNBUFFERED,INSERT ROW=TRUE,                                                                
               DELETE ROW=TRUE,APPEND ROW=TRUE)  
    
     BEFORE INPUT
       IF g_rec_b != 0 THEN                                                                                                    
          CALL fgl_set_arr_curr(l_ac)                                                                                          
       END IF                      
#       LET INT_FLAG = 1
 
     BEFORE ROW
       LET l_ac = ARR_CURR()
#       LET l_lock_sw = 'N'
       BEGIN WORK       
 
       IF NOT cl_null(g_bmb[l_ac].bmb03_b) THEN
          LET g_bmb03_t = g_bmb[l_ac].bmb03_b
       ELSE
          LET g_bmb03_t = 'fdajfao'
       END IF
 
 
     BEFORE INSERT
       LET l_n = ARR_COUNT()       
       INITIALIZE g_bmb[l_ac].* TO NULL
       CALL cl_show_fld_cont()     #FUN-550037(smin)                                                                           
 
        AFTER INSERT                                                                                                                
           IF INT_FLAG THEN                                                                                                         
              CALL cl_err('',9001,0)                                                                                                
              CANCEL INSERT                                                                                                         
           END IF                  
 
        BEFORE DELETE                            #是否取消單身                                                                      
            IF l_ac> 0 THEN                                                                                              
               IF NOT cl_delb(0,0) THEN                                                                                             
                  CANCEL DELETE                                                                                                     
               END IF                                                                                                               
               MESSAGE "Delete Ok"                                                                                                  
            END IF    
 
     ON ROW CHANGE                                                                                                                  
            IF INT_FLAG THEN                 #新增程式段                                                                            
               CALL cl_err('',9001,0)                                                                                               
               ROLLBACK WORK                                                                                                        
               EXIT INPUT                                                                                                           
            END IF                                                                                                                  
                                                                                                                                    
     AFTER ROW
        LET l_ac = ARR_CURR()
        LET l_ac_t = l_ac
 
        IF INT_FLAG THEN                                                                                    
            CALL cl_err('',9001,0)                                                                                               
            ROLLBACK WORK                                                                                                        
            EXIT INPUT                                                                                                           
        END IF                                                                                                                   
 
        IF cl_null(g_bmb[l_ac].att01) AND
           cl_null(g_bmb[l_ac].att02) AND
           cl_null(g_bmb[l_ac].att03) AND
           cl_null(g_bmb[l_ac].att04) AND
           cl_null(g_bmb[l_ac].att05) AND
           cl_null(g_bmb[l_ac].att06) AND
           cl_null(g_bmb[l_ac].att07) AND
           cl_null(g_bmb[l_ac].att08) AND
           cl_null(g_bmb[l_ac].att09) AND
           cl_null(g_bmb[l_ac].att10) AND
           cl_null(g_bmb[l_ac].att11) AND
           cl_null(g_bmb[l_ac].att12) AND
           cl_null(g_bmb[l_ac].att13) AND
           cl_null(g_bmb[l_ac].att14) AND
           cl_null(g_bmb[l_ac].att15) AND
           cl_null(g_bmb[l_ac].att16) AND
           cl_null(g_bmb[l_ac].att17) AND
           cl_null(g_bmb[l_ac].att18) AND
           cl_null(g_bmb[l_ac].att19) AND
           cl_null(g_bmb[l_ac].att20)
           THEN 
            IF (NOT cl_null(g_bmb[l_ac].bmb03_b) 
              OR NOT cl_null(g_bmb[l_ac].bmb06_b)
              OR NOT cl_null(g_bmb[l_ac].bmb08_b)) THEN
                CALL cl_err('','abm-995',1)
                NEXT FIELD bmb03_b
            END IF
#060107
#           IF cl_null(g_bmb[l_ac].bmb06_b) OR g_bmb[l_ac].bmb06_b<=0 THEN
#              CALL cl_err('','mfg9243',0)
#              NEXT FIELD bmb06_b
#            END IF
#060107
          COMMIT WORK 
         END IF
         INSERT INTO tmp_file(tmp_bmb03) VALUES (g_bmb[l_ac].bmb03_b)
 
    #FUN-630080 Modified By Lifeng ,下面的AFTER FIELD有必要加IF判斷嗎？
    #如果原來是有內容的，現在把內容清空，那不就無法回寫到g_value里面了嗎？
    #以下20個欄位的IF判斷都是我注釋掉的
    AFTER FIELD att01                                                                                                           
#       IF NOT cl_null(g_bmb[l_ac].att01) THEN                                                                                      
          LET g_value[1].value[l_ac] = g_bmb[l_ac].att01 # END IF 
 
    AFTER FIELD att02                                                                                                           
#       IF NOT cl_null(g_bmb[l_ac].att02) THEN                                                                                      
          LET g_value[2].value[l_ac] = g_bmb[l_ac].att02 # END IF 
 
    AFTER FIELD att03                                                                                                           
#       IF NOT cl_null(g_bmb[l_ac].att03) THEN                                                                                      
          LET g_value[3].value[l_ac] = g_bmb[l_ac].att03 # END IF 
 
    AFTER FIELD att04                                                                                                           
#       IF NOT cl_null(g_bmb[l_ac].att04) THEN                                                                                      
          LET g_value[4].value[l_ac] = g_bmb[l_ac].att04 # END IF 
 
    AFTER FIELD att05                                                                                                           
#       IF NOT cl_null(g_bmb[l_ac].att05) THEN                                                                                      
          LET g_value[5].value[l_ac] = g_bmb[l_ac].att05 # END IF 
 
    AFTER FIELD att06                                                                                                           
 #      IF NOT cl_null(g_bmb[l_ac].att06) THEN                                                                                      
          LET g_value[6].value[l_ac] = g_bmb[l_ac].att06 # END IF 
 
    AFTER FIELD att07                                                                                                           
 #      IF NOT cl_null(g_bmb[l_ac].att07) THEN                                                                                      
          LET g_value[7].value[l_ac] = g_bmb[l_ac].att07 # END IF 
 
    AFTER FIELD att08                                                                                                           
 #      IF NOT cl_null(g_bmb[l_ac].att08) THEN                                                                                      
          LET g_value[8].value[l_ac] = g_bmb[l_ac].att08 # END IF 
 
    AFTER FIELD att09                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att09) THEN                                                                                      
          LET g_value[9].value[l_ac] = g_bmb[l_ac].att09 # END IF 
 
    AFTER FIELD att10                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att10) THEN                                                                                      
          LET g_value[10].value[l_ac] = g_bmb[l_ac].att10 # END IF 
 
    AFTER FIELD att11                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att11) THEN                                                                                      
          LET g_value[11].value[l_ac] = g_bmb[l_ac].att11 # END IF 
 
    AFTER FIELD att12                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att12) THEN                                                                                      
          LET g_value[12].value[l_ac] = g_bmb[l_ac].att12 # END IF 
 
    AFTER FIELD att13                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att13) THEN                                                                                      
          LET g_value[13].value[l_ac] = g_bmb[l_ac].att13 # END IF 
 
    AFTER FIELD att14                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att14) THEN                                                                                      
          LET g_value[14].value[l_ac] = g_bmb[l_ac].att14 # END IF 
 
    AFTER FIELD att15                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att15) THEN                                                                                      
          LET g_value[15].value[l_ac] = g_bmb[l_ac].att15 # END IF 
 
    AFTER FIELD att16                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att16) THEN                                                                                      
          LET g_value[16].value[l_ac] = g_bmb[l_ac].att16 # END IF 
 
    AFTER FIELD att17                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att17) THEN                                                                                      
          LET g_value[17].value[l_ac] = g_bmb[l_ac].att17 # END IF 
 
    AFTER FIELD att18                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att18) THEN                                                                                      
          LET g_value[18].value[l_ac] = g_bmb[l_ac].att18 # END IF 
 
    AFTER FIELD att19                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att19) THEN                                                                                      
          LET g_value[19].value[l_ac] = g_bmb[l_ac].att19 # END IF 
 
    AFTER FIELD att20                                                                                                          
 #      IF NOT cl_null(g_bmb[l_ac].att20) THEN                                                                                      
          LET g_value[20].value[l_ac] = g_bmb[l_ac].att20 # END IF 
    #FUN-630080 Modify By Lifeng End ---
 
     AFTER FIELD bmb03_b
            #FUN-AA0059 -------------------add start--------------
            IF NOT cl_null(g_bmb[l_ac].bmb03_b) THEN
               IF NOT s_chk_item_no(g_bmb[l_ac].bmb03_b,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bmb03_b
               END IF 
           END IF
           #FUN-AA0059 -----------------add end------------------
         IF NOT cl_null(g_bmb[l_ac].bmb03_b)  
#           IF NOT cl_null(g_bmb03_t) AND (g_bmb[l_ac].bmb03_b != g_bmb03_t) THEN
           AND (g_bmb[l_ac].bmb03_b != g_bmb03_t) THEN
            SELECT count(*) INTO l_c FROM ima_file
             WHERE ima01 = g_bmb[l_ac].bmb03_b
            IF l_c = 0 THEN
               CALL cl_err(g_bmb[l_ac].bmb03_b,'mfg3403',0)   
               NEXT FIELD bmb03_b
            END IF
          
            SELECT count(*) INTO l_c FROM tmp_file
             WHERE tmp_bmb03 = g_bmb[l_ac].bmb03_b
            IF l_c > 0  THEN
               CALL cl_err(g_bmb[l_ac].bmb03_b,'abm-996',0)
               NEXT FIELD bmb03_b
            END IF
         END IF
 
     ON ACTION CONTROLP     #查詢條件                                                                                            
         CASE                                                                                                                    
            WHEN INFIELD(bmb03_b) #料件主檔                                                                                        
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()                                                                                          
              #   LET g_qryparam.form = "q_ima"                                                                                   
              #   LET g_qryparam.default1 = g_bmb[l_ac].bmb03_b                                                                           
              #   CALL cl_create_qry() RETURNING g_bmb[l_ac].bmb03_b                                                                      
                 CALL q_sel_ima(FALSE, "q_ima", "", g_bmb[l_ac].bmb03_b, "", "", "", "" ,"",'' )  RETURNING g_bmb[l_ac].bmb03_b
#FUN-AA0059 --End--
                 DISPLAY BY NAME g_bmb[l_ac].bmb03_b                                                                                     
                 NEXT FIELD bmb03_b                                                                                                
#FUN-630080 --start--
            WHEN INFIELD(bmb06_b)
                 LET l_default = g_bmb[l_ac].bmb06_b
                 CALL i503_qty(p_bma01,l_default) RETURNING g_bmb[l_ac].bmb06_b
                 DISPLAY BY NAME g_bmb[l_ac].bmb06_b                                                                                     
            WHEN INFIELD(bmb08_b)
                 LET l_default = g_bmb[l_ac].bmb08_b
                 CALL i503_qty(p_bma01,l_default) RETURNING g_bmb[l_ac].bmb08_b
                 DISPLAY BY NAME g_bmb[l_ac].bmb08_b                                                                                     
#FUN-630080 --end--
            OTHERWISE EXIT CASE                                                                                                  
          END CASE     
 
     ON ACTION act_produce
        CALL formula_produce()
 
#     ON ACTION act_endinput
#        EXIT INPUT
 
     #TQC-860019-add
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     #TQC-860019-add
 
     END INPUT
 
     #FUN-630080 Add By Lifeng , 結束編輯的時候保存網格數據
     CALL i503_savegrid()
 
     DROP TABLE tmp_file
 
END FUNCTION 
 
FUNCTION formula_produce()
DEFINE l_i,l_n,l_c,h,i,j,a,b,c,l3,l6,l8,s3,s6,s8    LIKE type_file.num5,           #No.FUN-680102 SMALLINT
       l_str          STRING,   #總的SQL
       l_space3       STRING,   #控制格式用的空字符串
       l_space6       STRING,   #控制格式用的空字符串
       l_space8       STRING,   #控制格式用的空字符串
       l_str1         STRING,   #組IF 語句的字符串
       l_strr         STRING,   #i503_make_conditiong返回的字符串
       l_str3         STRING,   #bmb03_b
       l_str6         STRING,   #bmb06_b
       l_str8         STRING,   #bmb08_b
       l_strs1        DYNAMIC ARRAY OF STRING,  #得出元件編號各層級包含的IF ELSE
       l_strs2        DYNAMIC ARRAY OF STRING,  #得出組成用量各層級包含的IF ELSE
       l_strs3        DYNAMIC ARRAY OF STRING   #得出損耗率各層級包含的IF ELSE
 
     LET j = g_bmb.getlength()
     LET l_n = j - 1
     LET l_c = j
     LET h = 0 
     LET a = j
     LET b= j
     LET c= j
     LET l3= j
     LET l6= j
     LET l8= j
 
     #FUN-630080 Add By Lifeng , 按照g_bmb中的內容回寫一下g_value數組
     FOR h = 1 TO j 
         LET g_value[1].value[h] = g_bmb[h].att01
         LET g_value[2].value[h] = g_bmb[h].att02
         LET g_value[3].value[h] = g_bmb[h].att03
         LET g_value[4].value[h] = g_bmb[h].att04
         LET g_value[5].value[h] = g_bmb[h].att05
         LET g_value[6].value[h] = g_bmb[h].att06
         LET g_value[7].value[h] = g_bmb[h].att07
         LET g_value[8].value[h] = g_bmb[h].att08
         LET g_value[9].value[h] = g_bmb[h].att09
         LET g_value[10].value[h] = g_bmb[h].att10
         LET g_value[11].value[h] = g_bmb[h].att11
         LET g_value[12].value[h] = g_bmb[h].att12
         LET g_value[13].value[h] = g_bmb[h].att13
         LET g_value[14].value[h] = g_bmb[h].att14
         LET g_value[15].value[h] = g_bmb[h].att15
         LET g_value[16].value[h] = g_bmb[h].att16
         LET g_value[17].value[h] = g_bmb[h].att17
         LET g_value[18].value[h] = g_bmb[h].att18
         LET g_value[19].value[h] = g_bmb[h].att19
         LET g_value[20].value[h] = g_bmb[h].att20
     END FOR
 
     FOR h = 1 TO j
       LET l_str1 = ''
       LET i = 1
       FOR i = 1 TO 20       
         IF g_value[i].visible = 'Y' THEN
          IF NOT cl_null(g_value[i].value[l_c]) THEN
            CALL i503_make_condition(g_value[i].value[l_c],g_value[i].nvalue,'CHAR','') 
                 RETURNING l_strr
            LET l_str1 = l_str1,' ',l_strr,' AND' 
          END IF
         END IF
       END FOR
       LET l_str1 = l_str1.substring(1,length(l_str1)-3),' THEN\n'
       IF a = j THEN
         IF NOT cl_null(g_bmb[l_c].bmb03_b) THEN
            LET l_space3 = ''
            LET s3=1
            FOR s3=1 TO a
               LET l_space3 = l_space3,'  '
            END FOR
            LET l_strs1[a] = l_space3,'IF',' ',l_str1,l_space3,'  \'',g_bmb[l_c].bmb03_b,'\'\n',
                             l_space3,'ELSE\n',l_space3,'  \'  \'\n',l_space3,'ENDIF'  
            LET a = a-1
         ELSE 
            LET l3 = l3-1
         END IF   
       ELSE
         IF NOT cl_null(g_bmb[l_c].bmb03_b) THEN
            LET l_space3 = ''
            LET s3=1
            FOR s3=1 TO a
               LET l_space3 = l_space3,'  '
            END FOR
            LET l_strs1[a] = l_space3,'IF',' ',l_str1,l_space3,'  \'',g_bmb[l_c].bmb03_b,'\'\n',
                             l_space3,'ELSE\n',l_strs1[a+1],'\n',l_space3,'ENDIF'  
            LET a = a-1
         ELSE 
            LET l3 = l3-1
         END IF       
       END IF
       IF b = j THEN 
         IF NOT cl_null(g_bmb[l_c].bmb06_b) THEN
            LET l_space6 = ''
            LET s6=1
            FOR s6=1 TO b
               LET l_space6 = l_space6,'  '
            END FOR
            LET l_strs2[b] = l_space6,'IF',' ',l_str1,l_space6,'  ',g_bmb[l_c].bmb06_b,'\n', 
                             l_space6,'ELSE\n',l_space6,'  \'  \'\n',l_space6,'ENDIF'  
            LET b = b-1
         ELSE 
            LET l6 = l6-1
         END IF     
       ELSE
         IF NOT cl_null(g_bmb[l_c].bmb06_b) THEN
            LET l_space6 = ''
            LET s6=1
            FOR s6=1 TO b
               LET l_space6 = l_space6,'  '
            END FOR
            LET l_strs2[b] = l_space6,'IF',' ',l_str1,l_space6,'  ',g_bmb[l_c].bmb06_b,'\n',
                             l_space6,'ELSE\n',l_strs2[b+1],'\n',l_space6,'ENDIF'  
            LET b = b-1
         ELSE 
            LET l6 = l6-1
         END IF       
       END IF
       IF c = j THEN 
         IF NOT cl_null(g_bmb[l_c].bmb08_b) THEN
            LET l_space8 = ''
            LET s8=1
            FOR s8=1 TO c
               LET l_space8 = l_space8,'  '
            END FOR
            LET l_strs3[c] = l_space8,'IF',' ',l_str1,l_space8,'  ',g_bmb[l_c].bmb08_b,'\n',  
                             l_space6,'ELSE\n',l_space8,'  \'  \'\n',l_space8,'ENDIF'  
            LET c = c-1
         ELSE 
            LET l8 = l8-1
         END IF       
       ELSE
         IF NOT cl_null(g_bmb[l_c].bmb08_b) THEN
            LET l_space8 = ''
            LET s8=1
            FOR s8=1 TO c
               LET l_space8 = l_space8,'  '
            END FOR
            LET l_strs3[c] = l_space8,'IF',' ',l_str1,l_space8,'  ',g_bmb[l_c].bmb08_b,'\n',  
                             l_space8,'ELSE\n',l_strs3[c+1],'\n',l_space8,'ENDIF'  
            LET c = c-1
         ELSE 
            LET l8 = l8-1
         END IF       
       END IF     
       LET l_c = l_c -1
     END FOR
     IF l3 != 0 THEN 
       LET g_input.bmb03 = l_strs1[a+1]
     ELSE
       LET g_input.bmb03 = ' '
     END IF
     IF l6 != 0 THEN 
       LET g_input.bmb06 = l_strs2[b+1]
     ELSE
       LET g_input.bmb06 = ' '
     END IF
     IF l8 != 0 THEN 
       LET g_input.bmb08 = l_strs3[c+1]
     ELSE
       LET g_input.bmb08 = ' '
     END IF
     DISPLAY g_input.bmb03 TO bmb03
     DISPLAY g_input.bmb06 TO bmb06
     DISPLAY g_input.bmb08 TO bmb08
 
END FUNCTION
 
#傳入參數分別為pvalue -- 欄位的值/ma_multi_rec[pcol].value[prow]
#              pfield -- 欄位的名稱/ma_multi_rec[pcol].dbfield
#              ptype  -- 欄位的數據類型/ma_multi_rec[pcol].dbtype
#1.判斷欄位的數據類型并決定是否需要使用諸如單引號的前綴
#2.對于包含*的內容自動解析為LIKE語句%
#3.對於包含?的內容自動解析為LIKE語句_
#4.對於包含=的內容自動解析為該欄位等於其後的內容
#5.對於>n、<n、>=n、<=n或<>n解析為大於、小於、大於等於、小於等於或不等于關係
#6.對於n:m解析為BETWEEN AND關係
#7.對於x|y解析為IN關係
#8.對於[a-z]*表示第一字符為a-z中任意字符的數據
FUNCTION i503_make_condition(pvalue,pfield,ptype,ptable)
  DEFINE pvalue,pfield,ptype      STRING,
         ptable,lc_table          STRING,
         li_pos                   LIKE type_file.num5,           #No.FUN-680102SMALLINT
         ls_like                  base.stringBuffer,
         ls_left,ls_right,ls_temp STRING,
         p_value_tmp             STRING
 
  #根據是否傳入了jointable的名字來決定字段的表前綴的名稱
  IF ptable.getLength() > 0 THEN
     LET lc_table = ptable.trim(),'.'
  ELSE
     LET lc_table = ''
  END IF
  
  LET ls_like = base.stringBuffer.Create()
 
  #判斷條件中是否包含'*'字符（將把*解析為模糊匹配）
  LET li_pos = pvalue.getIndexOf('*',1)
  IF li_pos > 0 THEN
     #如果包含'*'則理解為LIKE關系，且此時數據類型只能為CHAR
     CALL ls_like.append(pvalue)
     CALL ls_like.replace('*','%',0)  #將所有*替換成%
     RETURN ''''||pfield.trim()||''''||' LIKE '''||ls_like.toString()||''''
  END IF
  
  #判斷條件中是否包含'?'字符（將被替換為單個位上的模糊匹配）
  LET li_pos = pvalue.getIndexOf('?',1)
  IF li_pos > 0 THEN
     #如果包含'*'則理解為LIKE關系，且此時數據類型只能為CHAR
     CALL ls_like.append(pvalue)
     CALL ls_like.replace('?','_',0)  #將所有?替換成_
     RETURN ''''||pfield.trim()||''''||' LIKE '''||ls_like.toString()||''''
  END IF  
  
  #判斷條件是否為'='形式
  LET li_pos = pvalue.getIndexOf('=',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(2,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        RETURN ''''||pfield.trim()||''''||' = '''||ls_right.trim()||'''' 
     ELSE
        RETURN ''''||pfield.trim()||''''||' = '||ls_right.trim()
     END IF
  END IF  
  
  #判斷條件是否為'>'形式
  LET li_pos = pvalue.getIndexOf('>',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(2,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        RETURN ''''||pfield.trim()||''''||' > '''||ls_right.trim()||'''' 
     ELSE
        RETURN ''''||pfield.trim()||''''||' > '||ls_right.trim()
     END IF
  END IF  
 
  #判斷條件是否為'<'形式
  LET li_pos = pvalue.getIndexOf('<',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(2,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        RETURN ''''||pfield.trim()||''''||' < '''||ls_right.trim()||'''' 
     ELSE
        RETURN ''''||pfield.trim()||''''||' < '||ls_right.trim()
     END IF
  END IF  
 
 
  #判斷條件是否為'>='形式
  LET li_pos = pvalue.getIndexOf('>=',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(3,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        RETURN ''''||pfield.trim()||''''||' >= '''||ls_right.trim()||'''' 
     ELSE
        RETURN ''''||pfield.trim()||''''||' >= '||ls_right.trim()
     END IF
  END IF  
  
  #判斷條件是否為'<='形式
  LET li_pos = pvalue.getIndexOf('<=',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(3,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        RETURN ''''||pfield.trim()||''''||' <= '''||ls_right.trim()||'''' 
     ELSE
        RETURN ''''||pfield.trim()||''''||' <= '||ls_right.trim()
     END IF
  END IF  
  
  #判斷條件是否為'<>'形式
  LET li_pos = pvalue.getIndexOf('<>',1)
  IF li_pos = 1 THEN
     #得到要比較的內容
     LET ls_right = pvalue.subString(3,pvalue.getLength())
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        RETURN ''''||pfield.trim()||''''||' <> '''||ls_right.trim()||'''' 
     ELSE
        RETURN ''''||pfield.trim()||''''||' <> '||ls_right.trim()
     END IF
  END IF  
  
  #判斷條件是否為'n:m'形式
  LET li_pos = pvalue.getIndexOf(':',1)
  IF li_pos > 0 THEN
     #得到兩個要比較的內容
     LET ls_left = pvalue.subString(1,li_pos-1)
     LET ls_right = pvalue.subString(li_pos+1,pvalue.getLength())
     #這裡限定必須要按照格式輸入，不准只輸入左邊或右邊，否則該條件被忽略
     IF ls_left.trim() = '' OR ls_right.trim() = '' THEN
        RETURN '1 = 1'
     END IF
     #因為可能是數值型也可能是字符型所以要判斷一下
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        RETURN ''''||pfield.trim()||''''||' BETWEEN '''||ls_left.trim()||''' AND '''||ls_right.trim()||''''
     ELSE
        RETURN ''''||pfield.trim()||''''||' BETWEEN '||ls_left.trim()||' AND '||ls_right.trim()
     END IF
  END IF  
  
  #判斷是否是屬於x|y型，這個判斷比較複雜，要做循環，因為可能有多個值同屬IN關係
  LET p_value_tmp = pvalue
  LET li_pos = p_value_tmp.getIndexOf('|',1)
  WHILE li_pos > 0
     LET ls_left = p_value_tmp.subString(1,li_pos-1)
     IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
        IF ls_temp.getLength() > 0 THEN
           LET ls_temp = ls_temp.trim()||",'"||ls_left.trim()||"'"
        ELSE
           LET ls_temp = "'"||ls_left||"'"
        END IF
     ELSE
        IF ls_temp.getLength() > 0 THEN
           LET ls_temp = ls_temp.trim()||","||ls_left.trim()
        ELSE
           LET ls_temp = ls_left
        END IF
     END IF
     LET p_value_tmp = p_value_tmp.subString(li_pos+1,p_value_tmp.getLength())
     LET li_pos = p_value_tmp.getIndexOf('|',1)
  END WHILE
  IF ls_temp.getLength() > 0 THEN
     RETURN ''''||pfield.trim()||''''||' IN('||ls_temp.trim()||')'
  END IF
  
  #如果不包含上面任何字符則理解為'='關系，并且要根據字段的類型來判斷是否需要加引號
  #判斷數據類型
  IF ptype = 'CHAR' OR ptype = 'VARCHAR2' OR ptype = 'DATE' THEN
     RETURN ''''||pfield.trim()||''''||' = '''||pvalue.trim()||'''' 
  ELSE
     RETURN ''''||pfield.trim()||''''||' = '||pvalue.trim()
  END IF
END FUNCTION
#NO.TQC-5C0013 --end--
 
#FUN-630080 --start--
FUNCTION i503_qty(p_bma01,p_default)
DEFINE l_agc01   LIKE agc_file.agc01,
       l_agc02   LIKE agc_file.agc02,
       l_ges01   LIKE ges_file.ges01,
       l_ges02   LIKE ges_file.ges02,
       l_gep01   LIKE gep_file.gep01,
       l_gep02   LIKE gep_file.gep02,
       l_ze03    LIKE ze_file.ze03,
       lsb_item      base.StringBuffer,                                                                                                  
       lsb_value     base.StringBuffer, 
       l_att     LIKE agc_file.agc01,
       l_par     LIKE ges_file.ges01,
       l_exp     LIKE gep_file.gep01,
       l_fun     LIKE ze_file.ze03,
       l_text    STRING,
       l_str     STRING,
       l_deresult  STRING,
       l_return  STRING
DEFINE p_bma01   LIKE bma_file.bma01
DEFINE p_default STRING
DEFINE l_length  LIKE type_file.num10          #No.FUN-680102INTEGER 
DEFINE l_pos     LIKE type_file.num10          #No.FUN-680102INTEGER 
DEFINE l_lr      LIKE type_file.num10          #No.FUN-680102INTEGER 
DEFINE l_imaag   LIKE ima_file.imaag,
       l_ima01   LIKE ima_file.ima01,
       l_sql     LIKE type_file.chr1000,     #No.FUN-680102CHAR(1000),
       l_agb03   LIKE agb_file.agb03,
       l_imaag1  LIKE ima_file.imaag1
 
     OPEN WINDOW i503_qty WITH FORM "aoo/42f/aooi503_1" 
        ATTRIBUTE (STYLE = "report" CLIPPED)   
   
     CALL cl_ui_init()
     CALL cl_ui_locale("aooi503_1")
     CALL cl_load_act_list("aooi503_1")
     LET l_deresult = p_default
     LET l_pos = 0
      
     INPUT l_att,l_par,l_fun,l_exp,l_text WITHOUT DEFAULTS
          FROM att,par,fun,exp,text ATTRIBUTE(UNBUFFERED) 
 
         BEFORE INPUT
              NEXT FIELD text
 
         BEFORE FIELD att
              LET lsb_item  = base.StringBuffer.create()                                                                    
              LET lsb_value = base.StringBuffer.create()                                                                    
 
               SELECT ima01,imaag,imaag1                                                                                                      
                 INTO l_ima01,l_imaag,l_imaag1                                                                                                
                 FROM ima_file                                                                                                                
                WHERE ima01 = p_bma01                                                                                                        
                                                                                                                                              
               IF NOT cl_null(l_imaag) THEN                                                                                                   
                 IF l_imaag <> '@CHILD' THEN                                                                                                  
                    LET l_sql = "SELECT agb03,agc01,agc02 from agb_file,aga_file,agc_file ",                                                                       
                                " WHERE agb01 = aga01",                                                                                       
                                "   AND agb01 = '",l_imaag,"'",
                                "   AND agb03 = agc01"                                                                                
                 ELSE                                                                                                                         
                    LET l_sql = "SELECT agb03,agc01,agc02 from agb_file,aga_file,agc_file ",                                                                       
                                " WHERE agb01 = aga01",                                                                                       
                                "   AND agb01 = '",l_imaag1,"'",                                                                               
                                "   AND agb03 = agc01"                                                                                
                 END IF                                                                                                                       
               END IF                                                                                                                         
               PREPARE agc_aa FROM l_sql                                                                                                  
               DECLARE agc_curq CURSOR FOR agc_aa  
 
               FOREACH agc_curq INTO l_agb03,l_agc01,l_agc02   
                IF STATUS THEN                                                                                              
                   CALL cl_err('foreach agc',STATUS,0)                                                                      
                   EXIT FOREACH                                                                                             
                END IF                                                                                                      
                #lsb_value放選項的說明 
                IF lsb_value IS NULL THEN                                                                                     
                    CALL lsb_value.append(l_agc01 CLIPPED || ":" ||l_agc02 CLIPPED || ",")
                ELSE
                    CALL lsb_value.append(lsb_value || "," ||l_agc01|| ":" ||l_agc02 CLIPPED || ",")
                END IF
                #lsb_item放選項的值                                                                                         
                IF lsb_item IS NULL THEN                                                                                     
                    CALL lsb_item.append(l_agc01 CLIPPED || ",")
                ELSE
                    CALL lsb_item.append(lsb_item || "," ||l_agc01 CLIPPED || ",")
                END IF
              END FOREACH                                                                                                   
              CALL cl_set_combo_items('att',lsb_item.toString(),                                                            
                                       lsb_value.toString())        
 
 
         BEFORE FIELD par
              LET lsb_item  = base.StringBuffer.create()                                                                    
              LET lsb_value = base.StringBuffer.create()                                                                    
              DECLARE ges_curq CURSOR FOR                                                                                    
              SELECT ges01,ges02 FROM ges_file                                                                              
               WHERE gesacti='Y'
              FOREACH ges_curq INTO l_ges01,l_ges02                                                                          
                IF STATUS THEN                                                                                              
                   CALL cl_err('foreach ges',STATUS,0)                                
                   EXIT FOREACH                                                                                             
                END IF                                                                                                      
                #lsb_value放選項的說明 
                IF lsb_value IS NULL THEN                                                                                     
                    CALL lsb_value.append(l_ges01 CLIPPED || ":" ||l_ges02 CLIPPED || ",")
                ELSE
                    CALL lsb_value.append(lsb_value || "," ||l_ges01|| ":" ||l_ges02 CLIPPED || ",")
                END IF
                #lsb_item放選項的值                                                                                         
                IF lsb_item IS NULL THEN                                                                                     
                    CALL lsb_item.append(l_ges01 CLIPPED || ",")
                ELSE
                    CALL lsb_item.append(lsb_item || "," ||l_ges01 CLIPPED || ",")
                END IF
              END FOREACH                                                                                                   
              CALL cl_set_combo_items('par',lsb_item.toString(),                                                            
                                       lsb_value.toString())        
 
 
         BEFORE FIELD exp
              LET lsb_item  = base.StringBuffer.create()                                                                    
              LET lsb_value = base.StringBuffer.create()                                                                    
              DECLARE exp_curq CURSOR FOR                                                                                    
              SELECT gep01,gep02 FROM gep_file                                                                              
               WHERE gepacti='Y'
              FOREACH exp_curq INTO l_gep01,l_gep02                                                                          
                IF STATUS THEN                                                                                              
                   CALL cl_err('foreach gep',STATUS,0)                                      
                   EXIT FOREACH                                                                                             
                END IF                                                                                                      
                #lsb_value放選項的說明 
                IF lsb_value IS NULL THEN                                                                                     
                    CALL lsb_value.append(l_gep01 CLIPPED || ":" ||l_gep02 CLIPPED || ",")
                ELSE
                    CALL lsb_value.append(lsb_value || "," ||l_gep01|| ":" ||l_gep02 CLIPPED || ",")
                END IF
                #lsb_item放選項的值                                                                                         
                IF lsb_item IS NULL THEN                                                                                     
                    CALL lsb_item.append(l_gep01 CLIPPED || ",")
                ELSE
                    CALL lsb_item.append(lsb_item || "," ||l_gep01 CLIPPED || ",")
                END IF
              END FOREACH                                                                                                   
              CALL cl_set_combo_items('exp',lsb_item.toString(),                                                            
                                       lsb_value.toString())        
 
 
         BEFORE FIELD fun
              LET lsb_item  = base.StringBuffer.create()                                                                    
              LET lsb_value = base.StringBuffer.create()                                                                    
              DECLARE ze_curq CURSOR FOR                                                                                    
              SELECT ze03 FROM ze_file                                                                             
               WHERE ze01>='aoo-201'
                 AND ze01<='aoo-227'
                 AND ze02='0'
              FOREACH ze_curq INTO l_ze03                                                                          
                IF STATUS THEN                                                                                              
                   CALL cl_err('foreach ze',STATUS,0)                                   
                   EXIT FOREACH                                                                                             
                END IF                                                                                                      
                #lsb_value放選項的說明 
                IF lsb_value IS NULL THEN                                                                                     
                    CALL lsb_value.append(l_ze03 CLIPPED || ",")
                ELSE
                    CALL lsb_value.append(lsb_value || "," ||l_ze03 CLIPPED || ",")
                END IF
                #lsb_item放選項的值                                                                                         
                IF lsb_item IS NULL THEN                                                                                     
                    CALL lsb_item.append(l_ze03 CLIPPED || ",")
                ELSE
                    CALL lsb_item.append(lsb_item || "," ||l_ze03 CLIPPED || ",")
                END IF
              END FOREACH                                                                                                   
              CALL cl_set_combo_items('fun',lsb_item.toString(),                                                            
                                       lsb_value.toString())        
 
 
         ON CHANGE att
            LET l_return = '#',l_att CLIPPED,'#'
            LET l_str = l_text
            LET l_lr=l_return.getlength()
 
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
            
         ON CHANGE par
            LET l_return = l_par
            LET l_str = l_text
            LET l_lr=l_return.getlength()
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
            
         ON CHANGE exp
            LET l_return = l_exp
            LET l_str = l_text
            LET l_lr=l_return.getlength()
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
            
         ON CHANGE fun
            LET l_return = l_fun[1,8]
            LET l_return = l_return CLIPPED
            LET l_str = l_text
            LET l_lr=l_return.getlength()
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
 
         BEFORE FIELD text
            IF l_pos IS NOT NULL THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos)
            ELSE
     #          LET l_length = l_text.getlength()
               CALL FGL_DIALOG_SETCURSOR(1)
      #         CALL FGL_DIALOG_SETCURSOR(l_length)
            END IF
        
         AFTER FIELD text
            LET l_pos = FGL_DIALOG_GETCURSOR()
 
     #TQC-860019-add
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     #TQC-860019-add
 
         ON ACTION add
            LET l_return = '+'
            LET l_str = l_text
            LET l_lr=l_return.getlength()
 
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
 
         ON ACTION minus
            LET l_return = '-'
            LET l_str = l_text
            LET l_lr=l_return.getlength()
 
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
 
         ON ACTION multi
            LET l_return = '*'
            LET l_str = l_text
            LET l_lr=l_return.getlength()
 
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
 
         ON ACTION divid
            LET l_return = '/'
            LET l_str = l_text
            LET l_lr=l_return.getlength()
 
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
 
         ON ACTION k1
            LET l_return = '('
            LET l_str = l_text
            LET l_lr=l_return.getlength()
 
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
 
         ON ACTION k2
            LET l_return = ')'
            LET l_str = l_text
            LET l_lr=l_return.getlength()
 
            IF INFIELD(text) THEN 
               LET l_pos = FGL_DIALOG_GETCURSOR()
            ELSE
               LET l_pos = l_pos
            END IF 
 
            CALL i503_showtest(l_return,l_str,l_pos) RETURNING l_str   
            LET l_text = l_str
            DISPLAY l_text TO FORMONLY.text        
            
            IF INFIELD(text) THEN
               CALL FGL_DIALOG_SETCURSOR(l_pos+l_lr)
               LET l_pos = l_pos+l_lr
               NEXT FIELD text
            ELSE
               LET l_pos = l_pos+l_lr
            END IF
 
     END INPUT
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW i503_qty
        RETURN l_deresult
     ELSE
        CLOSE WINDOW i503_qty
        RETURN l_text
     END IF
END FUNCTION
 
FUNCTION i503_showtest(p_return,p_str,p_pos)
DEFINE p_return  LIKE type_file.chr50,          #No.FUN-680102 VARCHAR(40),
       p_str     LIKE type_file.chr1000,        #No.FUN-680102CHAR(100),
       p_pos     LIKE type_file.num10           #No.FUN-680102INTEGER
DEFINE l_return  LIKE type_file.chr50,          #No.FUN-680102CHAR(40), 
       l_str     LIKE type_file.chr1000,        #No.FUN-680102CHAR(100),  
       l_pos     LIKE type_file.num10          #No.FUN-680102INTEGER 
DEFINE l_length  LIKE type_file.num10          #No.FUN-680102INTEGER 
DEFINE l_str1    LIKE type_file.chr1000        #MOD-CC0053
 
     LET l_return = p_return
     LET l_str = p_str
     LET l_str1 = p_str   #MOD-CC0053
     LET l_pos = p_pos
    
     IF NOT cl_null(l_str) THEN #MOD-CC0053
        LET l_length=LENGTH(l_str)
 
#       SELECT UNIQUE SUBSTR(l_str,1,l_pos-1)||l_return||SUBSTR(l_str,l_pos,l_length)                #TQC-9B0022 Mark
#         INTO l_str                                                                                 #TQC-9B0022 Mark
#         FROM sma_file                                                                              #TQC-9B0022 Mark
       #LET l_str = l_str[1,l_pos-1],l_return,l_str[l_pos,l_length]        #TQC-9B0022 Add #MOD-CC0053 mark
       #MOD-CC0053 add begin---------------------
        LET l_str = l_str[1,l_pos-1],l_return  
        IF p_pos <= l_length THEN
           LET l_str = l_str,l_str1[l_pos,l_length] 
        END IF 
       #MOD-CC0053 add end-----------------------
#       LET l_str = l_str.substring(1,l_pos-1),l_return,l_str.substring(l_pos,l_length)
#MOD-CC0053 begin------
     ELSE 
        LET l_str = l_return 
     END IF
#MOD-CC0053  end--------
     RETURN l_str
 
END FUNCTION
 
#Add By Lifeng For 網格數據存取 Start
 
#該函數將g_grdstr中保存的資料寫入到網格中，該變量在aooi503被調用的時候從
#數據庫中取出，這里直接使用
#字符串格式定義："單元格1#單元格#...#單元格n"
#  每個單元格中："行號列號內容"，中間不使用分隔符，行號和列號都是01,02類似
#  的2位對齊數據，第5位開始是內容
FUNCTION i503_loadgrid()
DEFINE
  l_tok         base.stringTokenizer,
  l_cell        STRING,
  l_row,l_col   LIKE type_file.num5           #No.FUN-680102SMALLINT
 
  CALL g_bmb.clear()
  
  LET l_tok = base.stringTokenizer.create(g_grdstr,'#')
  WHILE l_tok.hasMoreTokens() 
    LET l_cell = l_tok.nextToken()  
 
    LET l_row  = l_cell.subString(1,2)                   #行號
    LET l_col  = l_cell.subString(3,4)                   #列號
    LET l_cell = l_cell.subString(5,l_cell.getLength())  #單元格內容
 
    #將列號轉換為列名
    CASE l_col
      WHEN 1 LET g_bmb[l_row].att01 = l_cell
      WHEN 2 LET g_bmb[l_row].att02 = l_cell
      WHEN 3 LET g_bmb[l_row].att03 = l_cell
      WHEN 4 LET g_bmb[l_row].att04 = l_cell
      WHEN 5 LET g_bmb[l_row].att05 = l_cell
      WHEN 6 LET g_bmb[l_row].att06 = l_cell
      WHEN 7 LET g_bmb[l_row].att07 = l_cell
      WHEN 8 LET g_bmb[l_row].att08 = l_cell
      WHEN 9 LET g_bmb[l_row].att09 = l_cell
      WHEN 10 LET g_bmb[l_row].att10 = l_cell
      WHEN 11 LET g_bmb[l_row].att11 = l_cell
      WHEN 12 LET g_bmb[l_row].att12 = l_cell
      WHEN 13 LET g_bmb[l_row].att13 = l_cell
      WHEN 14 LET g_bmb[l_row].att14 = l_cell
      WHEN 15 LET g_bmb[l_row].att15 = l_cell
      WHEN 16 LET g_bmb[l_row].att16 = l_cell
      WHEN 17 LET g_bmb[l_row].att17 = l_cell
      WHEN 18 LET g_bmb[l_row].att18 = l_cell
      WHEN 19 LET g_bmb[l_row].att19 = l_cell
      WHEN 20 LET g_bmb[l_row].att20 = l_cell
      WHEN 21 LET g_bmb[l_row].bmb03_b = l_cell
      WHEN 22 LET g_bmb[l_row].bmb06_b = l_cell
      WHEN 23 LET g_bmb[l_row].bmb08_b = l_cell
    END CASE
  END WHILE
 
END FUNCTION
 
#和上面的過程正好相反，將網格中的內容寫到g_grdstr中去
#在保存公式的時候會把g_grdstr中的內容寫回gep11中去
FUNCTION i503_savegrid()
DEFINE
  l_i       LIKE type_file.num5,          #No.FUN-680102 SMALLINT
  lc_i      STRING
 
  LET g_grdstr = ''
 
  FOR l_i=1 TO g_bmb.getLength()
      LET lc_i = l_i USING '&&'
 
      IF NOT cl_null(g_bmb[l_i].att01) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'01',g_bmb[l_i].att01      
      END IF
      IF NOT cl_null(g_bmb[l_i].att02) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'02',g_bmb[l_i].att02      
      END IF
      IF NOT cl_null(g_bmb[l_i].att03) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'03',g_bmb[l_i].att03      
      END IF
      IF NOT cl_null(g_bmb[l_i].att04) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'04',g_bmb[l_i].att04      
      END IF
      IF NOT cl_null(g_bmb[l_i].att05) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'05',g_bmb[l_i].att05      
      END IF
      IF NOT cl_null(g_bmb[l_i].att06) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'06',g_bmb[l_i].att06      
      END IF
      IF NOT cl_null(g_bmb[l_i].att07) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'07',g_bmb[l_i].att07      
      END IF
      IF NOT cl_null(g_bmb[l_i].att08) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'08',g_bmb[l_i].att08      
      END IF
      IF NOT cl_null(g_bmb[l_i].att09) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'09',g_bmb[l_i].att09      
      END IF
      IF NOT cl_null(g_bmb[l_i].att10) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'10',g_bmb[l_i].att10      
      END IF
      IF NOT cl_null(g_bmb[l_i].att11) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'11',g_bmb[l_i].att11      
      END IF
      IF NOT cl_null(g_bmb[l_i].att12) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'12',g_bmb[l_i].att12      
      END IF
      IF NOT cl_null(g_bmb[l_i].att13) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'13',g_bmb[l_i].att13      
      END IF
      IF NOT cl_null(g_bmb[l_i].att14) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'14',g_bmb[l_i].att14      
      END IF
      IF NOT cl_null(g_bmb[l_i].att15) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'15',g_bmb[l_i].att15      
      END IF
      IF NOT cl_null(g_bmb[l_i].att16) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'16',g_bmb[l_i].att16      
      END IF
      IF NOT cl_null(g_bmb[l_i].att17) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'17',g_bmb[l_i].att17      
      END IF
      IF NOT cl_null(g_bmb[l_i].att18) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'18',g_bmb[l_i].att18      
      END IF
      IF NOT cl_null(g_bmb[l_i].att19) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'19',g_bmb[l_i].att19      
      END IF
      IF NOT cl_null(g_bmb[l_i].att20) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'20',g_bmb[l_i].att20      
      END IF
      IF NOT cl_null(g_bmb[l_i].bmb03_b) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'21',g_bmb[l_i].bmb03_b      
      END IF
      IF NOT cl_null(g_bmb[l_i].bmb06_b) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'22',g_bmb[l_i].bmb06_b      
      END IF
      IF NOT cl_null(g_bmb[l_i].bmb08_b) THEN
         LET g_grdstr = g_grdstr,'#',lc_i,'23',g_bmb[l_i].bmb08_b      
      END IF
 
  END FOR
  IF NOT cl_null(g_grdstr) THEN   #No.TQC-640171
     LET g_grdstr = g_grdstr[3,LENGTH(g_grdstr CLIPPED)]
  END IF   #No.TQC-640171
 
END FUNCTION
#Add By Lifeng End
 
#FUN-630080 --end--
 
