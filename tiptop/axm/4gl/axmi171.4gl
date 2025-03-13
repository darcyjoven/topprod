# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmi171.4gl
# Descriptions...: 產品銷售預測維護作業
# Date & Author..: 00/04/13 By Kammy
# Modify.........: 01/05/14 By Wiky       #增T.計劃展至天
# Modify.........: No:9476 04/04/21 Melody 1.新增cn2/cn3(GENERO不適用)
#                : 2._y()/_z()/_w()/_s()
# Modify.........: No.MOD-480606 Melody 單頭選'依時距'後,無法輸入時距.且之後產生的單身起始,截止日也錯.
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy 匯率加開窗功能
# Modify.........: No.MOD-4B0253 04/11/23 By Carol 客戶代號允許空白但因為key值,
#                                                  so如果沒有輸入客戶代號的話,應defult為 空白不可為null
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: NO.MOD-530653 05/03/31 By Mandy 執行功能鍵:計畫展至天, 業務的計畫數量有分配至每一天, 但生管的確認數量未分配.
# Modify.........: No.MOD-550127 05/05/18 By kim Define l_gen02 VARCHAR(8) 改為 改為 like gen_file.gen02
# Modify.........: No.FUN-560237 05/07/04 By kim "確認數量修正"時,單身不可新增,刪除
# Modify.........: No.FUN-590091 05/10/20 By Smapmin 新增複製功能
# Modify.........: No.TQC-5B0110 05/11/12 By CoCo 料號位置調整
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630227 06/03/27 By pengu 執行程式以後,不要按查詢,直接新增,新增完資料後,
                                      #            按修改,在按取消,單身資料會不見
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.TQC-640066 06/04/08 By Joe 業務人員開窗帶出資料後,並未將部門帶出改善!
# Modify.........: No.TQC-640067 06/04/08 By Joe 新增資料後,無法列印問題改善,改為列印出該比資料!!
# Modify.........: No.MOD-640127 06/04/08 By Alexstar 維護計畫數量後，自動預設到確認數量中
# Modify.........: No.FUN-5A0188 06/05/03 By Sarah 當客戶編號輸入非MISC時,才需做檢查
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-650137 06/05/15 By Sarah 當提列方式4.旬, 以該月之最後一天為下旬最後一天
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0042 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0078 06/11/15 By day 修改、單身、刪除時如有RETURN時加報錯信息
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740148 07/04/22 By bnlent  字段不能小于0的控管,計提方式控管
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770045 07/07/09 By Rayven 審核的狀態下不能運行“計劃展至天”，但無提示信息
#                                                   "審核數量”為負數無控管
#                                                   "預設上筆資料"按鈕無效
#                                                   用一筆已審核過的資料復制后,新生成的資料顯示為審核過的狀態
# Modify.........: No.MOD-790168 07/09/28 By Pengu 維護單身計畫數量時會default數量確認數量後應DISPLAY
# Modify.........: No.TQC-7B0031 07/11/06 By Carrier 業務/生管確認及取消確認時加入多一些報錯信息
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810016 08/01/21 By ve007  增加制單號字段
# Modify.........: No.FUN-840156 08/04/23 By rainy 新增參數接收
# Modify.........: No.FUN-870104 08/08/01 By Mandy 跟APS串聯時,AFTER FIELD opc01多預測料號的控管
# Modify.........: No.FUN-840039 08/04/10 BY Sunyanchun 老報表轉CR
#                                08/09/24 By Cockroach CR 21-->31 
# Modify.........: No.FUN-920183 09/03/17 BY shiwuying MPR改善,更改確認/取消確認段邏輯
# Modify.........: No.TQC-960181 09/06/23 By lilingyu 建立玩資料后點擊"刪除"按鈕,資料刪除的同時該作業當出
# Modify.........: No.TQC-970057 09/07/08 By dxfwo 1. 打印過一次后，把g_wc的值替換成中文說明，第二次打印就會出錯                                                    
#                                     2. 打印出來的報表，單身的數據都是空白
# Modify.........: No.FUN-980010 09/08/20 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990040 09/09/30 By chenmoyan 增加批次復制功能
# Modify.........: No.TQC-9C0005 09/12/10 By lilingyu 單身"金額"欄位自動算出值來之后,可以手工修改為負數,不合理
# Modify.........: No:FUN-9C0121 09/12/28 By shiwuying MRP 改善
# Modify.........: No:FUN-9C0167 10/01/04 By shiwuying 料號對應的預測料號不為空，則需以預測料號輸入
# Modify.........: No:FUN-9C0071 10/01/07 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No:MOD-B30190 11/03/15 By Summer 調整批次複製邏輯  
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-BB0046 11/12/29 By Elise 增加狀態頁籤
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C60211 12/07/18 By zhuhao 審核時重新審核部門編號 調整INPUT順序
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C80122 12/08/16 By SunLM 更改生成期數opc07,增加和減少期數後,單身不會更新,造成單頭生成期數和單身期數不等 
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_opc           RECORD LIKE opc_file.*,
    g_opc_t         RECORD LIKE opc_file.*,
    g_opc_o         RECORD LIKE opc_file.*,
    g_opc01_t       LIKE opc_file.opc01,
    g_opc02_t       LIKE opc_file.opc02,
    g_opc03_t       LIKE opc_file.opc03,
    g_opc04_t       LIKE opc_file.opc04,
    g_opd           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        opd05       LIKE opd_file.opd05,
        opd06       LIKE opd_file.opd06,
        opd07       LIKE opd_file.opd07,
        opd08       LIKE opd_file.opd08,
        opd10       LIKE opd_file.opd10,
        opd11       LIKE opd_file.opd11,
        opd09       LIKE opd_file.opd09
                    END RECORD,
    g_opd_t         RECORD                 #程式變數 (舊值)
        opd05       LIKE opd_file.opd05,
        opd06       LIKE opd_file.opd06,
        opd07       LIKE opd_file.opd07,
        opd08       LIKE opd_file.opd08,
        opd10       LIKE opd_file.opd10,
        opd11       LIKE opd_file.opd11,
        opd09       LIKE opd_file.opd09
                    END RECORD,
    g_ima02         LIKE ima_file.ima02,
    g_ima021        LIKE ima_file.ima021,
    g_wc,g_wc2      STRING,   #TQC-630166   
    g_sql           STRING,   #TQC-630166  
    g_t1            LIKE type_file.chr3,                   #No.FUN-680137 VARCHAR(3)
    g_rec_b         LIKE type_file.num5,     #單身筆數     #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5,     #目前處理的ARRAY CNT   #No.FUN-680137 SMALLINT
    l_cmd           LIKE type_file.chr1000,  #No.FUN-680137 VARCHAR(200)
    g_rpg           ARRAY[36] OF LIKE type_file.num5    #第 xxx 期時距期別所含的日曆天數。 #No.FUN-680137 SMALLINT
DEFINE p_row,p_col         LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_head1             STRING
DEFINE g_argv1   LIKE opc_file.opc01,
       g_argv2   LIKE opc_file.opc02,
       g_argv3   LIKE opc_file.opc03,
       g_argv4   LIKE opc_file.opc04
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE g_sql_tmp    STRING  #No.TQC-720019
DEFINE   g_chr      LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
DEFINE   g_cnt      LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose    #No.FUN-680137 SMALLINT
DEFINE   g_msg      LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE  l_table          STRING                      #No.FUN-840039
DEFINE  g_str            STRING                      #No.FUN-840039
DEFINE  g_opc06_t       LIKE opc_file.opc06,  #MOD-C80122
        g_opc07_t       LIKE opc_file.opc07   #MOD-C80122
         
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1     = ARG_VAL(1)         # 參數值(1) 
    LET g_argv2     = ARG_VAL(2)         # 參數值(2) 
    LET g_argv3     = ARG_VAL(3)         # 參數值(3) 
    LET g_argv4     = ARG_VAL(4)         # 參數值(4) 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_sql = "opc01.opc_file.opc01,",
                "opc02.opc_file.opc02,",
                "opc03.opc_file.opc03,",
                "opc04.opc_file.opc04,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "gen02.gen_file.gen02,",
                "opc05.opc_file.opc05,",
                "gem02.gem_file.gem02,",
                "occ02.occ_file.occ02,",
                "opc06.opc_file.opc06,",
                "opc07.opc_file.opc07,",
                "opd05.opd_file.opd05,",
                "opd06.opd_file.opd06,",
                "opd07.opd_file.opd07,",
                "opd08.opd_file.opd08,",
                "opd09.opd_file.opd09"
   LET l_table = cl_prt_temptable('axmi171',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        EXIT PROGRAM                                                                                                                 
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                 #NO.FUN-6A0094
 
    LET g_wc2=' 1=1'   #No.TQC-630227 add

    LET g_forupd_sql =
     "SELECT * FROM opc_file WHERE opc01=? AND opc02=? AND opc03=? AND opc04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i171_cl CURSOR FROM g_forupd_sql
 
    SELECT * INTO g_mpz.* FROM mpz_file WHERE mpz00='0'
 
    OPEN WINDOW i171_w WITH FORM "axm/42f/axmi171"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
      CALL i171_q()
    END IF
 
    WHILE TRUE
      LET g_action_choice = ''
      CALL i171_menu()
      IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
    CLOSE WINDOW i171_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i171_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_opd.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_opc.* TO NULL    #No.FUN-750051
    IF NOT cl_null(g_argv1) THEN
       LET g_wc ="     opc01 = '",g_argv1,"' ",
                 " AND opc02 = '",g_argv2,"' ",
                 " AND opc03 = '",g_argv3,"' ",
                 " AND opc04 = '",g_argv4,"' "
       LET g_wc2 = ' 1=1'
    ELSE #FUN-840156 end
         CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
             opc01,opc02,opc03,opc04,opc05,opc06,opc10,opc07,opc08,opc09,
             opc11,opc12,
             opcuser,opcgrup,opcmodu,opcdate,     #CHI-BB0046 add 
                             opcoriu,opcorig      #CHI-BB0046 add
                    BEFORE CONSTRUCT
                       CALL cl_qbe_init()
             ON ACTION CONTROLP
                CASE WHEN INFIELD(opc01)
#FUN-AA0059---------mod------------str-----------------                
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form = "q_ima"
#                       LET g_qryparam.state = 'c'
#                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                       DISPLAY g_qryparam.multiret TO opc01
                       NEXT FIELD opc01
                     WHEN INFIELD(opc02)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_occ"
                       LET g_qryparam.state = 'c'
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO opc02
                       NEXT FIELD opc02
                     WHEN INFIELD(opc04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gen"
                       LET g_qryparam.state = 'c'
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO opc04
                       NEXT FIELD opc04
                     WHEN INFIELD(opc05)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_gem"
                       LET g_qryparam.state = 'c'
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO opc05
                       NEXT FIELD opc05
                     WHEN INFIELD(opc10)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rpg"
                       LET g_qryparam.state = 'c'
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO opc10
                       NEXT FIELD opc10
                     WHEN INFIELD(opc08)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_azi"
                       LET g_qryparam.state = 'c'
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO opc08
                       NEXT FIELD opc08
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
     		   CALL cl_qbe_list() RETURNING lc_qbe_sn
     		   CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond('opcuser', 'opcgrup') #FUN-980030
         IF INT_FLAG THEN RETURN END IF
     
         CONSTRUCT g_wc2 ON opd05,opd06,opd07,opd08,opd10,opd11,opd09
                 FROM s_opd[1].opd05,s_opd[1].opd06,s_opd[1].opd07,
                      s_opd[1].opd08,s_opd[1].opd10,s_opd[1].opd11,
                      s_opd[1].opd09
     		BEFORE CONSTRUCT
     		   CALL cl_qbe_display_condition(lc_qbe_sn)
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
      
           ON ACTION about         #MOD-4C0121
              CALL cl_about()      #MOD-4C0121
      
           ON ACTION help          #MOD-4C0121
              CALL cl_show_help()  #MOD-4C0121
      
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
      
      
                         ON ACTION qbe_save
     		       CALL cl_qbe_save()
         END CONSTRUCT
         IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF  #FUN-840156
 
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT opc01,opc02,opc03,opc04  FROM opc_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1,2,3,4 "
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT opc01,opc02,opc03,opc04 ",
                   "  FROM opc_file, opd_file",
                   " WHERE opc01 = opd01",
                   "   AND opc02 = opd02",
                   "   AND opc03 = opd03",
                   "   AND opc04 = opd04",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1,2,3,4 "
    END IF
 
    PREPARE i171_prepare FROM g_sql
    DECLARE i171_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i171_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql_tmp="SELECT UNIQUE opc01,opc02,opc03,opc04 FROM opc_file WHERE ",g_wc CLIPPED,  #No.TQC-720019
                      " INTO TEMP x "  #No.TQC-720019
    ELSE
        LET g_sql_tmp = "SELECT opc01,opc02,opc03,opc04 ",  #No.TQC-720019
                    "  FROM opc_file, opd_file",
                    " WHERE opc01 = opd01",
                    "   AND opc02 = opd02",
                    "   AND opc03 = opd03",
                    "   AND opc04 = opd04",
                    "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                    " GROUP BY opc01,opc02,opc03,opc04 ",
                    " INTO TEMP x "
    END IF
    #因主鍵值有兩個故所抓出資料筆數有誤
    DROP TABLE x
    PREPARE i171_precount_x  FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i171_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE i171_precount FROM g_sql
    DECLARE i171_count CURSOR FOR i171_precount
    DISPLAY g_sql
 
END FUNCTION
 
FUNCTION i171_menu()
 
   WHILE TRUE
      CALL i171_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i171_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i171_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i171_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i171_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i171_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i171_b('b')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i171_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認數量修正"
         WHEN "modify_confirm_qty"
            IF cl_chk_act_auth() THEN
               CALL i171_b('d')
            END IF
       #@WHEN "計劃展至天"
         WHEN "exlpode_to_daily"
            IF cl_chk_act_auth() THEN
               CALL i171_t()
            END IF
       #@WHEN "業務確認"
         WHEN "sales_conf"
            IF cl_chk_act_auth() THEN
               CALL i171_y()
            END IF
       #@WHEN "業務取消確認"
         WHEN "undo_sales_confirm"
            IF cl_chk_act_auth() THEN
               CALL i171_z()
            END IF
       #@WHEN "生管確認"
         WHEN "qc_conf"
            IF cl_chk_act_auth() THEN
               CALL i171_s()
            END IF
       #@WHEN "生管取消確認"
         WHEN "undo_qc_conf"
            IF cl_chk_act_auth() THEN
               CALL i171_w()
            END IF
         WHEN "amortization_qry"
            IF cl_chk_act_auth() THEN
               CALL i171_2()
            END IF
         WHEN "batch_copy"
            IF cl_chk_act_auth() THEN
               CALL i171_batch_copy()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_opd),'','')
            END IF
 
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_opc.opc01 IS NOT NULL THEN
                LET g_doc.column1 = "opc01"
                LET g_doc.column2 = "opc02"
                LET g_doc.column3 = "opc03"
                LET g_doc.column4 = "opc04" 
                LET g_doc.value1 = g_opc.opc01
                LET g_doc.value2 = g_opc.opc02
                LET g_doc.value3 = g_opc.opc03
                LET g_doc.value4 = g_opc.opc04
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i171_a()
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_opd.clear()
    INITIALIZE g_opc.* LIKE opc_file.*             #DEFAULT 設定
    LET g_opc01_t = NULL
    LET g_opc02_t = NULL
    LET g_opc03_t = NULL
    LET g_opc04_t = NULL
    LET g_opc_o.* = g_opc.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_opc.opc03 = g_today          #計劃日期
        LET g_opc.opc04 = g_user           #業務員
        LET g_opc.opc05 = g_grup           #部門
        LET g_opc.opc06 = g_mpz.mpz02      #提列方式
        LET g_opc.opc10 = g_mpz.mpz03      #時距代號
        LET g_opc.opc11 = 'N'
        LET g_opc.opc12 = 'N'
        LET g_opc.opcacti = 'Y'
        LET g_opc.opcdate = g_today
        LET g_opc.opcuser = g_user
        LET g_data_plant = g_plant #FUN-980030
        LET g_opc.opcgrup = g_grup
        LET g_opc.opcplant = g_plant 
        LET g_opc.opclegal = g_legal 
        LET g_opc.opcoriu = g_user         #CHI-BB0046 add
        LET g_opc.opcorig = g_grup         #CHI-BB0046 add
        CALL i171_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_opc.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_opc.opc01 IS NULL THEN        # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_opc.opc02) THEN
           LET g_opc.opc02 = ' '
        END IF
        LET g_opc.opcoriu = g_user      #No.FUN-980030 10/01/04
        LET g_opc.opcorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO opc_file VALUES (g_opc.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","opc_file",g_opc.opc01,g_opc.opc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        SELECT opc01 INTO g_opc.opc01 FROM opc_file
            WHERE opc01 = g_opc.opc01
              AND opc02 = g_opc.opc02
              AND opc03 = g_opc.opc03
              AND opc04 = g_opc.opc04
        LET g_opc01_t = g_opc.opc01        #保留舊值
        LET g_opc02_t = g_opc.opc02        #保留舊值
        LET g_opc03_t = g_opc.opc03        #保留舊值
        LET g_opc04_t = g_opc.opc04        #保留舊值
        LET g_opc_t.* = g_opc.*
        CALL g_opd.clear()
        LET g_rec_b = 0
        CALL i171_g()                      #產生單身預設值
        CALL i171_b('b')                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i171_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_opc.opc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_opc.opc11='Y' OR g_opc.opc12='Y' THEN 
       CALL cl_err('',9023,0)  #No.TQC-6B0078
       RETURN 
    END IF
    IF g_opc.opcacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_opc.opc01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_opc01_t = g_opc.opc01
    LET g_opc02_t = g_opc.opc02
    LET g_opc03_t = g_opc.opc03
    LET g_opc04_t = g_opc.opc04    
    LET g_opc_o.* = g_opc.*
    BEGIN WORK
 
    OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
    IF STATUS THEN
       CALL cl_err("OPEN i171_cl:", STATUS, 1)
       CLOSE i171_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i171_cl INTO g_opc.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i171_cl ROLLBACK WORK RETURN
    END IF
    CALL i171_show()
    WHILE TRUE
        LET g_opc01_t = g_opc.opc01
        LET g_opc02_t = g_opc.opc02
        LET g_opc03_t = g_opc.opc03
        LET g_opc04_t = g_opc.opc04
        LET g_opc06_t = g_opc.opc06 #MOD-C80122
        LET g_opc07_t = g_opc.opc07 #MOD-C80122          
        LET g_opc.opcmodu=g_user    #CHI-BB0046 add
        LET g_opc.opcdate=g_today   #CHI-BB0046 add
        CALL i171_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_opc.*=g_opc_t.*
            CALL i171_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
 
      IF g_opc.opc01 != g_opc01_t OR g_opc.opc02 != g_opc02_t                                                                       
         OR g_opc.opc03 != g_opc03_t OR g_opc.opc04 != g_opc04_t THEN                                                               
         UPDATE opd_file SET opd01 = g_opc.opc01,                                                                                   
                             opd02 = g_opc.opc02,                                                                                   
                             opd03 = g_opc.opc03,                                                                                   
                             opd04 = g_opc.opc04                                                                                    
          WHERE opd01 = g_opc01_t                                                                                                   
            AND opd02 = g_opc02_t                                                                                                   
            AND opd03 = g_opc03_t                                                                                                   
            AND opd04 = g_opc04_t                                                                                                   
                                                                                                                                    
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                                                                              
            CALL cl_err3("upd","opd_file",g_opc01_t,g_opc02_t,SQLCA.sqlcode,"","pmx",1)                                                    
            CONTINUE WHILE                                                                                                          
         END IF                                                                                                                     
      END IF                                                                                                                        
 
        UPDATE opc_file SET opc_file.* = g_opc.*
            WHERE opc01 = g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03 AND opc04=g_opc.opc04
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","opc_file",g_opc01_t,g_opc02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i171_cl
	COMMIT WORK

	#MOD-C80122 add beg-----
  IF g_opc06_t != g_opc.opc06 OR g_opc07_t != g_opc.opc07 THEN 
     IF cl_confirm('axm-848') THEN	
        CALL i171_upd_opd()
     END IF 
  END IF 
	#MOD-C80122 add end-----
	
END FUNCTION


##MOD-C80122 add beg-----
FUNCTION i171_upd_opd()

   BEGIN WORK 
   DELETE FROM opd_file WHERE opd01 = g_opc.opc01                                                                                   
                          AND opd02 = g_opc.opc02                                                                                   
                          AND opd03 = g_opc.opc03                                                                                   
                          AND opd04 = g_opc.opc04 
   IF SQLCA.sqlcode THEN
       CALL cl_err3("delete","opd_file",g_opc01_t,g_opc02_t,SQLCA.sqlcode,"","",1) 
       ROLLBACK WORK 
       RETURN 
   END IF
   COMMIT WORK 
   CALL g_opd.clear()
   LET g_rec_b = 0
   CALL i171_g()                      #產生單身預設值
   CALL i171_b('b')                   #輸入單身   
END FUNCTION 
#MOD-C80122 add end-----

 
#處理INPUT
FUNCTION i171_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,          #判斷必要欄位是否有輸入  #No.FUN-680137 VARCHAR(1)
    l_n1            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    p_cmd           LIKE type_file.chr1           #a:輸入 u:更改           #No.FUN-680137 VARCHAR(1)
   #CHI-BB0046 ---add--start---
    DISPLAY BY NAME
        g_opc.opc01,g_opc.opc02,g_opc.opc03,
        g_opc.opc06,g_opc.opc10,g_opc.opc07,
        g_opc.opc04,g_opc.opc05,
        g_opc.opc08,g_opc.opc09,
        g_opc.opc11,g_opc.opc12,
        g_opc.opcuser,g_opc.opcgrup,g_opc.opcmodu,g_opc.opcdate,
        g_opc.opcoriu,g_opc.opcorig
   #CHI-BB0046 ---add--end---

    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT BY NAME 
        g_opc.opc01,g_opc.opc02,g_opc.opc03,
       #g_opc.opc11,g_opc.opc12,                            #TQC-C60211 mark
       #g_opc.opc04,g_opc.opc05,                            #TQC-C60211 mark
        g_opc.opc06,g_opc.opc10,g_opc.opc07,
        g_opc.opc04,g_opc.opc05,                            #TQC-C60211
        g_opc.opc08,g_opc.opc09,
        g_opc.opc11,g_opc.opc12,                            #TQC-C60211
        g_opc.opcuser,g_opc.opcgrup,g_opc.opcmodu,g_opc.opcdate,  #CHI-BB0046 add
        g_opc.opcoriu,g_opc.opcorig                               #CHI-BB0046 add

        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i171_set_entry(p_cmd)
            CALL i171_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD opc01
          IF NOT cl_null(g_opc.opc01) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_opc.opc01,"") THEN
             CALL cl_err('',g_errno,1)
             LET g_opc.opc01= g_opc_t.opc01
             NEXT FIELD opc01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
              CALL i171_opc01('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD opc01
              END IF
          END IF
 
        AFTER FIELD opc02
          IF NOT cl_null(g_opc.opc02) THEN
              CALL i171_opc02('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD opc02
              END IF
          ELSE
              LET g_opc.opc02 = ' '
          END IF
 
        AFTER FIELD opc04
          IF NOT cl_null(g_opc.opc04) THEN
             IF g_opc_t.opc01 != g_opc.opc01 OR g_opc_t.opc02 != g_opc.opc02
                OR g_opc_t.opc03 != g_opc.opc03 OR g_opc_t.opc04 != g_opc.opc04
             THEN SELECT COUNT(*) INTO l_n FROM opc_file
                   WHERE opc01=g_opc.opc01
                     AND opc02=g_opc.opc02
                     AND opc03=g_opc.opc03
                     AND opc04=g_opc.opc04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_opc.opc01 = g_opc_t.opc01
                     LET g_opc.opc02 = g_opc_t.opc02
                     LET g_opc.opc03 = g_opc_t.opc03
                     LET g_opc.opc04 = g_opc_t.opc04
                     NEXT FIELD opc01
                  END IF
             END IF
             CALL i171_opc04('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0) NEXT FIELD opc04
             END IF
             IF g_opc.opc04 != g_opc_t.opc04 OR cl_null(g_opc_t.opc04) THEN
                SELECT gen03 INTO g_opc.opc05 FROM gen_file
                 WHERE gen01=g_opc.opc04
                DISPLAY BY NAME g_opc.opc05
             END IF
          END IF
 
        AFTER FIELD opc05
          IF NOT cl_null(g_opc.opc05) THEN
              CALL i171_opc05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD opc05
              END IF
          END IF
 
        BEFORE FIELD opc06
          CALL i171_set_entry(p_cmd)
 
        AFTER FIELD opc06
          IF NOT cl_null(g_opc.opc06) THEN
             IF g_opc.opc06 NOT MATCHES '[12345]' THEN NEXT FIELD opc06 END IF
             IF g_opc.opc06 != '1' THEN
                LET g_opc.opc10 = NULL
                DISPLAY BY NAME g_opc.opc10
             END IF
          END IF
          CALL i171_set_no_entry(p_cmd)
 
        AFTER FIELD opc07
          IF g_opc.opc07 < 0 THEN
             CALL cl_err(g_opc.opc07,"axr-610",0)
             NEXT FIELD opc07
          END IF
        AFTER FIELD opc10
          IF NOT cl_null(g_opc.opc10) THEN
              SELECT rpg101,rpg102,rpg103,rpg104,rpg105,rpg106,
                     rpg107,rpg108,rpg109,rpg110,rpg111,rpg112,
                     rpg113,rpg114,rpg115,rpg116,rpg117,rpg118,
                     rpg119,rpg120,rpg121,rpg122,rpg123,rpg124,
                     rpg125,rpg126,rpg127,rpg128,rpg129,rpg130,
                     rpg131,rpg132,rpg133,rpg134,rpg135,rpg136
                  INTO
                     g_rpg[1],g_rpg[2],g_rpg[3],g_rpg[4] ,g_rpg[5] ,g_rpg[6],
                     g_rpg[7],g_rpg[8],g_rpg[9],g_rpg[10],g_rpg[11],g_rpg[12],
                     g_rpg[13],g_rpg[14],g_rpg[15],g_rpg[16],g_rpg[17],g_rpg[18],
                     g_rpg[19],g_rpg[20],g_rpg[21],g_rpg[22],g_rpg[23],g_rpg[24],
                     g_rpg[25],g_rpg[26],g_rpg[27],g_rpg[28],g_rpg[29],g_rpg[30],
                     g_rpg[31],g_rpg[32],g_rpg[33],g_rpg[34],g_rpg[35],g_rpg[36]
                  FROM rpg_file
                  WHERE rpg01 = g_opc.opc10
              IF STATUS THEN
                 CALL cl_err3("sel","rpg_file",g_opc.opc10,"",STATUS,"","",1)  #No.FUN-660167
                 NEXT FIELD opc10
              END IF
          END IF
 
        AFTER FIELD opc08
            IF NOT cl_null(g_opc.opc08) THEN
                SELECT azi01
                    FROM azi_file WHERE azi01=g_opc.opc08
                IF STATUS THEN
                    CALL cl_err3("sel","azi_file",g_opc.opc08,"",STATUS,"","select azi",1)  #No.FUN-660167
                    NEXT FIELD opc08  
                END IF
                IF g_aza.aza17 = g_opc.opc08 THEN #本幣
                    LET g_opc.opc09 = 1
                ELSE
                   #CALL s_curr3(g_opc.opc08,g_opc.opc03,'B') #FUN-640012
                    CALL s_curr3(g_opc.opc08,g_opc.opc03,g_sma.sma904) #FUN-640012
                         RETURNING g_opc.opc09
                END IF
                DISPLAY BY NAME g_opc.opc09
            END IF
 
        AFTER FIELD opc09
          IF NOT cl_null(g_opc.opc08) THEN
              IF g_opc.opc08 <=0 THEN
                  NEXT FIELD opc09
              END IF
          END IF
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(opc01)
#FUN-AA0059---------mod------------str-----------------           
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_opc.opc01
#                  CALL cl_create_qry() RETURNING g_opc.opc01
                  CALL q_sel_ima(FALSE, "q_ima","",g_opc.opc01,"","","","","",'' ) 
                    RETURNING  g_opc.opc01
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME g_opc.opc01
                  NEXT FIELD opc01
                WHEN INFIELD(opc02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.default1 = g_opc.opc02
                  CALL cl_create_qry() RETURNING g_opc.opc02
                  DISPLAY BY NAME g_opc.opc02
                  NEXT FIELD opc02
                WHEN INFIELD(opc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_opc.opc04
                  CALL cl_create_qry() RETURNING g_opc.opc04
                  DISPLAY BY NAME g_opc.opc04
                  NEXT FIELD opc04
                WHEN INFIELD(opc05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_opc.opc05
                  CALL cl_create_qry() RETURNING g_opc.opc05
                  DISPLAY BY NAME g_opc.opc05
                  NEXT FIELD opc05
                WHEN INFIELD(opc10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rpg"
                  LET g_qryparam.default1 = g_opc.opc10
                  CALL cl_create_qry() RETURNING g_opc.opc10
                  DISPLAY BY NAME g_opc.opc10
                  NEXT FIELD opc10
                WHEN INFIELD(opc08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = g_opc.opc08
                  CALL cl_create_qry() RETURNING g_opc.opc08
                  DISPLAY BY NAME g_opc.opc08
                  NEXT FIELD opc08
                WHEN INFIELD(opc09)
                   CALL s_rate(g_opc.opc08,g_opc.opc09) RETURNING g_opc.opc09
                   DISPLAY BY NAME g_opc.opc09
                   NEXT FIELD opc09
           END CASE
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
END FUNCTION
 
#Query 查詢
FUNCTION i171_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_opc.* TO NULL               #No.FUN-6A0020
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i171_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_opc.* TO NULL
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i171_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_opc.* TO NULL
    ELSE
        OPEN i171_count
        FETCH i171_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i171_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i171_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1       #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i171_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04
        WHEN 'P' FETCH PREVIOUS i171_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04
        WHEN 'F' FETCH FIRST    i171_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04
        WHEN 'L' FETCH LAST     i171_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i171_cs INTO g_opc.opc01,
                                             g_opc.opc02,g_opc.opc03,g_opc.opc04
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)
        INITIALIZE g_opc.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump          --改g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_opc.* FROM opc_file WHERE opc01 = g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03 AND opc04=g_opc.opc04
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","opc_file",g_opc.opc01,g_opc.opc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_opc.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_opc.opcuser      #FUN-4C0057 add
    LET g_data_group = g_opc.opcgrup      #FUN-4C0057 add
    LET g_data_plant = g_opc.opcplant #FUN-980030
    CALL i171_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i171_show()
    LET g_opc_t.* = g_opc.*                #保存單頭舊值
    DISPLAY BY NAME 
        g_opc.opc01,g_opc.opc02,g_opc.opc03,
        g_opc.opc06,g_opc.opc10,g_opc.opc07,
        g_opc.opc04,g_opc.opc05,
        g_opc.opc08,g_opc.opc09,
        g_opc.opc11,g_opc.opc12,
        g_opc.opcuser,g_opc.opcgrup,g_opc.opcmodu,g_opc.opcdate,g_opc.opcoriu,g_opc.opcorig  #CHI-BB0046 add

    CALL i171_opc01('d')
    CALL i171_opc02('d')
    CALL i171_opc04('d')
    CALL i171_opc05('d')
    CALL i171_b_fill(g_wc2)                 #單身
    CALL i171_sum()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i171_x()
 DEFINE  l_sure  LIKE type_file.chr1         #No.FUN-680137  VARCHAR(01) 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_opc.opc01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
    IF STATUS THEN
       CALL cl_err("OPEN i171_cl:", STATUS, 1)
       CLOSE i171_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i171_cl INTO g_opc.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i171_cl ROLLBACK WORK RETURN
    END IF
    CALL i171_show()
    IF cl_exp(0,0,g_opc.opcacti) THEN
        LET g_chr=g_opc.opcacti
        IF g_opc.opcacti='Y' THEN
            LET g_opc.opcacti='N'
        ELSE
            LET g_opc.opcacti='Y'
        END IF
        UPDATE opc_file                    #更改有效碼
            SET opcacti=g_opc.opcacti
            WHERE opc01=g_opc.opc01
              AND opc02=g_opc.opc02
              AND opc03=g_opc.opc03
              AND opc04=g_opc.opc04
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","opc_file",g_opc.opc01,g_opc.opc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_opc.opcacti=g_chr
        END IF
    END IF
    CLOSE i171_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i171_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680137  VARCHAR(01) 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_opc.opc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_opc.opc11='Y' THEN 
       CALL cl_err('',9023,0)  #No.TQC-6B0078
       RETURN 
    END IF
    IF g_opc.opc12='Y' THEN 
       CALL cl_err('',9023,0)  #No.TQC-6B0078
       RETURN 
    END IF
    BEGIN WORK
 
    OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
    IF STATUS THEN
       CALL cl_err("OPEN i171_cl:", STATUS, 1)
       CLOSE i171_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i171_cl INTO g_opc.*
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)
      CLOSE i171_cl ROLLBACK WORK  RETURN
    END IF
    CALL i171_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "opc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "opc02"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "opc03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "opc04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_opc.opc01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_opc.opc02      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_opc.opc03      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_opc.opc04      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM opc_file WHERE opc01 = g_opc.opc01
                               AND opc02 = g_opc.opc02
                               AND opc03 = g_opc.opc03
                               AND opc04 = g_opc.opc04
 
        DELETE FROM opd_file WHERE opd01 = g_opc.opc01
                               AND opd02 = g_opc.opc02
                               AND opd03 = g_opc.opc03
                               AND opd04 = g_opc.opc04
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","opd_file",g_opc.opc01,g_opc.opc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
        ELSE
           CLEAR FORM
           CALL g_opd.clear()
           INITIALIZE g_opc.* LIKE opc_file.*             #DEFAULT 設定
         IF NOT cl_null(g_sql_tmp) THEN      #TQC-960181
           DROP TABLE x  #No.TQC-720019
           PREPARE i171_precount_x2 FROM g_sql_tmp  #No.TQC-720019
           EXECUTE i171_precount_x2                 #No.TQC-720019
         END IF                            #TQC-960181
           OPEN i171_count
           #FUN-B50064-add-start--
           IF STATUS THEN
              CLOSE i171_cs
              CLOSE i171_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end-- 
           FETCH i171_count INTO g_row_count
           #FUN-B50064-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i171_cs
              CLOSE i171_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50064-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i171_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i171_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL i171_fetch('/')
           END IF
        END IF
    LET g_msg=TIME
    INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980010 add plant & legal 
       VALUES ('axmi171',g_user,g_today,g_msg,g_opc.opc01,'delete',g_plant,g_legal)
    END IF
    CLOSE i171_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i171_b(p_flag)
DEFINE
    l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT   #No.FUN-680137 SMALLINT
    l_row,l_col     LIKE type_file.num5,        #分段輸入之行,列數   #No.FUN-680137 SMALLINT  
    l_n,l_cnt,l_i   LIKE type_file.num5,        #檢查重複用          #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,        #單身鎖住否          #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,        #處理狀態            #No.FUN-680137 VARCHAR(1)
    g_cmd           LIKE gbc_file.gbc05,        #No.FUN-680137 VARCHAR(100) 
    l_possible      LIKE type_file.num5,        #No.FUN-680137 SMALLINT #用來設定判斷重複的可能性
    l_day           LIKE type_file.num10,       #No.FUN-680137 INTEGER
    l_flag          LIKE type_file.num10,       #No.FUN-680137 INTEGER
    p_flag          LIKE type_file.chr1,        #b:單身 d:確認數量    #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,        #可新增否             #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5         #可刪除否             #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF g_opc.opc01 IS NULL THEN
       CALL cl_err('',-400,0)  #No.TQC-6B0078
       RETURN 
    END IF
    IF g_opc.opcacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_opc.opc01,'aom-000',0)
        RETURN
    END IF
    IF p_flag='b' AND (g_opc.opc11='Y' OR g_opc.opc12='Y') THEN 
       CALL cl_err('',9023,0)  #No.TQC-6B0078
       RETURN
    END IF
    IF p_flag='d' AND g_opc.opc12='Y' THEN
       CALL cl_err('',9023,0)  #No.TQC-6B0078
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT opd05,opd06,opd07,opd08,opd10,opd11,opd09,'' ",
                         " FROM opd_file",
                       "  WHERE opd01= ? AND opd02= ? AND opd03= ? ",
                        "   AND opd04= ? AND opd05= ? ",
                         " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i171_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
	LET l_row = 12
	LET l_col = 15
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
        IF p_flag='d' THEN
           LET l_allow_insert = FALSE
           LET l_allow_delete = FALSE
        END IF

        INPUT ARRAY g_opd
              WITHOUT DEFAULTS
              FROM s_opd.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        APPEND ROW=l_allow_insert,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET l_n = ARR_COUNT()
            display "l_n(2)=",l_n
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
            IF STATUS THEN
               CALL cl_err("OPEN i171_cl:", STATUS, 1)
               CLOSE i171_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i171_cl INTO g_opc.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i171_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_opd_t.* = g_opd[l_ac].*  #BACKUP
 
                OPEN i171_bcl USING g_opc.opc01,g_opc.opc02,
                                    g_opc.opc03,g_opc.opc04,g_opd_t.opd05
                IF STATUS THEN
                    CALL cl_err("OPEN i171_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i171_bcl INTO g_opd[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_opd_t.opd05,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            LET g_before_input_done = FALSE
            CALL i171_set_entry_b(p_cmd)
            CALL i171_set_no_entry_b(p_cmd,p_flag)
            LET g_before_input_done = TRUE
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO opd_file(opd01,opd02,opd03,opd04,opd05,
                   opd06,opd07,opd08,opd09,opd10,opd11,opdplant,opdlegal) #FUN-980010 add plant & legal 
            VALUES(g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04,
                   g_opd[l_ac].opd05,g_opd[l_ac].opd06,
                   g_opd[l_ac].opd07,g_opd[l_ac].opd08,
                   g_opd[l_ac].opd09,g_opd[l_ac].opd10,
                   g_opd[l_ac].opd11,g_plant,g_legal)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","opd_file",g_opc.opc01,g_opd[l_ac].opd05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
	        COMMIT WORK
                LET g_rec_b = g_rec_b + 1
                DISPLAY g_rec_b TO FORMONLY.cn2   #No.TQC-970057  
                CALL i171_sum()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_opd[l_ac].* TO NULL      #900423
            LET g_opd_t.* = g_opd[l_ac].*             #新輸入資料
            LET g_opd[l_ac].opd08 = 0
            LET g_opd[l_ac].opd09 = 0
            LET g_opd[l_ac].opd10 = 0
            LET g_opd[l_ac].opd11 = 0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD opd05
 
        BEFORE FIELD opd05                            #default 序號
            IF cl_null(g_opd[l_ac].opd05) OR
               g_opd[l_ac].opd05 = 0 THEN
                SELECT max(opd05)+1 INTO g_opd[l_ac].opd05
                   FROM opd_file
                   WHERE opd01 = g_opc.opc01
                     AND opd02 = g_opc.opc02
                     AND opd03 = g_opc.opc03
                     AND opd04 = g_opc.opc04
                IF g_opd[l_ac].opd05 IS NULL THEN
                    LET g_opd[l_ac].opd05 = 1
                END IF
            END IF
 
        BEFORE FIELD opd06
            IF cl_null(g_opd[l_ac].opd05) THEN NEXT FIELD opd05 END IF
 
        AFTER FIELD opd05                        #check 序號是否重複
            IF NOT cl_null(g_opd[l_ac].opd05) THEN
                IF g_opd[l_ac].opd05 != g_opd_t.opd05 OR
                   g_opd_t.opd05 IS NULL THEN
                    SELECT count(*) INTO l_n
                        FROM opd_file
                        WHERE opd01 = g_opc.opc01
                          AND opd02 = g_opc.opc02
                          AND opd03 = g_opc.opc03
                          AND opd04 = g_opc.opc04
                          AND opd05 = g_opd[l_ac].opd05
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_opd[l_ac].opd05 = g_opd_t.opd05
                        NEXT FIELD opd05
                    END IF
                END IF
                IF g_opd[l_ac].opd05 < 0 THEN
                   CALL cl_err(g_opd[l_ac].opd05,"axr-610",0)
                   NEXT FIELD opd05
                END IF
            END IF
 
        AFTER FIELD opd07
            IF NOT cl_null(g_opd[l_ac].opd07) THEN
                IF g_opd[l_ac].opd07 < g_opd[l_ac].opd06 THEN
                   CALL cl_err('','axm-262',0)
                   NEXT FIELD opd07
                END IF
            END IF
 
 
        AFTER FIELD opd08
            IF NOT cl_null(g_opd[l_ac].opd08) THEN
                IF g_opd[l_ac].opd08 < 0 THEN
                   CALL cl_err('','mfg4012',1)
                   NEXT FIELD opd08
                END IF
                LET g_opd[l_ac].opd11 = g_opd[l_ac].opd08  * g_opd[l_ac].opd10
                LET g_opd[l_ac].opd09 = g_opd[l_ac].opd08 #MOD-640127  
                DISPLAY BY NAME g_opd[l_ac].opd09         #No.MOD-790168 add
                DISPLAY BY NAME g_opd[l_ac].opd11
            END IF
 
        AFTER FIELD opd09
            IF cl_null(g_opd[l_ac].opd09) THEN LET g_opd[l_ac].opd09 = 0 END IF
            IF g_opd[l_ac].opd09 < 0 THEN
               CALL cl_err('','mfg4012',1)
               NEXT FIELD opd09
            END IF
 
 
        AFTER FIELD opd10
            IF cl_null(g_opd[l_ac].opd10) OR g_opd[l_ac].opd10 < 0 THEN
               LET g_opd[l_ac].opd10 = 0
            END IF
            LET g_opd[l_ac].opd11 = g_opd[l_ac].opd08  * g_opd[l_ac].opd10
            DISPLAY BY NAME g_opd[l_ac].opd11
 
        BEFORE DELETE                            #是否取消單身
            IF g_opd_t.opd05 > 0 AND
               g_opd_t.opd05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM opd_file
                    WHERE opd01 = g_opc.opc01
                      AND opd02 = g_opc.opc02
                      AND opd03 = g_opc.opc03
                      AND opd04 = g_opc.opc04
                      AND opd05 = g_opd_t.opd05
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","opd_file",g_opc.opc01,g_opd_t.opd05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b = g_rec_b - 1
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL i171_sum()                  #No.TQC-970057  
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_opd[l_ac].* = g_opd_t.*
               CLOSE i171_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_opd[l_ac].opd05,-263,1)
                LET g_opd[l_ac].* = g_opd_t.*
            ELSE
                UPDATE opd_file SET
                    opd05=g_opd[l_ac].opd05,opd06=g_opd[l_ac].opd06,
                    opd07=g_opd[l_ac].opd07,opd08=g_opd[l_ac].opd08,
                    opd09=g_opd[l_ac].opd09,opd10=g_opd[l_ac].opd10,
                    opd11=g_opd[l_ac].opd11
                 WHERE opd01=g_opc.opc01
                   AND opd02=g_opc.opc02
                   AND opd03=g_opc.opc03
                   AND opd04=g_opc.opc04
                   AND opd05=g_opd_t.opd05
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","opd_file",g_opc.opc01,g_opd_t.opd05,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    LET g_opd[l_ac].* = g_opd_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
		    COMMIT WORK
                    CALL i171_sum()
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_opd[l_ac].* = g_opd_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_opd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i171_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac    #FUN-D30034 add
            CLOSE i171_bcl
            COMMIT WORK
 
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(opd05) AND l_ac > 1 THEN   #No.TQC-770045
                LET g_opd[l_ac].* = g_opd[l_ac-1].*
                LET g_opd[l_ac].opd05 = g_opd_t.opd05
                DISPLAY BY NAME g_opd[l_ac].*
                NEXT FIELD opd05
            END IF
 
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

    CLOSE i171_bcl
    COMMIT WORK
 
    MESSAGE ''
 
#   CALL i171_delall() #CHI-C30002 mark
    CALL i171_delHeader()     #CHI-C30002 add
END FUNCTION
 
#===>新增計劃展至天01/05/14
FUNCTION i171_t()
 DEFINE  l_opd     DYNAMIC ARRAY OF RECORD     #陣列
            opd01  LIKE opd_file.opd01,
            opd02  LIKE opd_file.opd02,
            opd03  LIKE opd_file.opd03,
            opd04  LIKE opd_file.opd04,
            opd05  LIKE opd_file.opd05,
            opd06  LIKE opd_file.opd06,
            opd07  LIKE opd_file.opd07,
            opd08  LIKE opd_file.opd08,
            opd10  LIKE opd_file.opd10,
            opd11  LIKE opd_file.opd11,
            opd09  LIKE opd_file.opd09,
            opd12  LIKE opd_file.opd12
                   END RECORD,
          l_opd_t  DYNAMIC ARRAY OF RECORD     #陣列
            opd01  LIKE opd_file.opd01,
            opd02  LIKE opd_file.opd02,
            opd03  LIKE opd_file.opd03,
            opd04  LIKE opd_file.opd04,
            opd05  LIKE opd_file.opd05,
            opd06  LIKE opd_file.opd06,
            opd07  LIKE opd_file.opd07,
            opd08  LIKE opd_file.opd08,
            opd10  LIKE opd_file.opd10,
            opd11  LIKE opd_file.opd11,
            opd09  LIKE opd_file.opd09,
            opd12  LIKE opd_file.opd12
                   END RECORD,
          l_i        LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          i          LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_opddate  LIKE type_file.num5,         #No.FUN-680137 SMALLINT 
          l_opdsum   LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_opd08    LIKE type_file.num5,         #No.FUN-680137 SMALLINT
          l_opd08e   LIKE ade_file.ade05,         #No.FUN-680137 dec(15,3)
           l_opd09   LIKE type_file.num5,         #No.FUN-680137 SMALLINT  #MOD-530653
           l_opd09e  LIKE ade_file.ade05          #No.FUN-680137 dec(15,3) #MOD-530653
 
    BEGIN WORK
 
    OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
    IF STATUS THEN
       CALL cl_err("OPEN i171_cl:", STATUS, 1)   
       CLOSE i171_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i171_cl INTO g_opc.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i171_cl ROLLBACK WORK RETURN
    END IF
 
   IF g_opc.opc11='Y' THEN CALL cl_err('','afa-364',0) RETURN END IF #No.TQC-770045
   IF  NOT cl_sure(15,15) THEN RETURN END IF
 
   LET l_i=1
   DECLARE i171_curs CURSOR FOR
      SELECT opd01,opd02,opd03,opd04,opd05,opd06,opd07,opd08,opd10,
             opd11,opd09,''
        FROM opd_file
       WHERE opd01=g_opc.opc01
         AND opd02=g_opc.opc02
         AND opd03=g_opc.opc03
         AND opd04=g_opc.opc04
      FOREACH  i171_curs INTO l_opd[l_i].*
          LET  l_opd_t[l_i].* = l_opd[l_i].*
          LET  l_i=l_i+1
      END FOREACH
      IF STATUS=0 THEN
         LET g_success='Y'
         DELETE FROM opd_file          #刪除單身
          WHERE opd01=g_opc.opc01
           AND  opd02=g_opc.opc02
           AND  opd03=g_opc.opc03
           AND  opd04=g_opc.opc04
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","opd_file",g_opc.opc01,g_opc.opc04,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_success='N'
            ROLLBACK WORK
            RETURN
         END IF
       END IF
       LET l_i='1'
       LET i='1'
       LET l_opddate='0'
       LET l_opdsum='0'
       WHILE TRUE
           IF l_opd[l_i].opd01 IS NOT NULL THEN
              LET  l_opddate=l_opd[l_i].opd07-l_opd[l_i].opd06+1
              LET  l_opd08=l_opd[l_i].opd08/l_opddate
               LET  l_opd09=l_opd[l_i].opd09/l_opddate #MOD-530653
              LET  l_opd[l_i].opd11=l_opd08*l_opd[l_i].opd10
              LET  l_opdsum=l_opdsum+l_opddate
              FOR i=i TO l_opdsum
                 IF l_opd[l_i].opd06 != l_opd[l_i].opd07  THEN
                 ELSE
                    LET l_opd08e=l_opd[l_i].opd08-(l_opd08*(l_opddate-1))
                    LET l_opd[l_i].opd11=l_opd08e*l_opd[l_i].opd10
                    LET l_opd08=l_opd08e
 
                     LET l_opd09e=l_opd[l_i].opd09-(l_opd09*(l_opddate-1)) #MOD-530653
                     LET l_opd09=l_opd09e                                  #MOD-530653
                 END IF
                 INSERT INTO opd_file(opd01,opd02,opd03,opd04,opd05,
                             opd06,opd07,opd08,opd09,opd10,opd11,opdplant,opdlegal)   #FUN-980010 add plant & legal 
                        VALUES(g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04,
                               i,l_opd[l_i].opd06,l_opd[l_i].opd06,
                                l_opd08,l_opd09,l_opd[l_i].opd10, #MOD-530653
                               l_opd[l_i].opd11,g_plant,g_legal)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","opd_file",g_opc.opc01,i,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    LET g_success='N'
                    RETURN
                 END IF
                 LET l_opd[l_i].opd06=l_opd[l_i].opd06+1
              END FOR
              LET  l_i=l_i+1
           ELSE
              UPDATE opc_file SET opc06 = '2'
               WHERE opc01 = g_opc.opc01
                 AND opc02 = g_opc.opc02
                 AND opc03 = g_opc.opc03
                 AND opc04 = g_opc.opc04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","opc_file",g_opc.opc01,g_opc.opc02,STATUS,"","upd opc06",1)  #No.FUN-660167
                 LET g_success = 'N'
              END IF
              EXIT WHILE
           END IF
       END WHILE
       IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
       SELECT * INTO g_opc.* FROM opc_file
               WHERE opc01 = g_opc.opc01 AND opc02 = g_opc.opc02
                 AND opc03 = g_opc.opc03 AND opc04 = g_opc.opc04
       CALL i171_show()
END FUNCTION
 
 
FUNCTION i171_sum()
 DEFINE g_opd08t LIKE opd_file.opd08
 DEFINE g_opd09t LIKE opd_file.opd09
 DEFINE g_opd11t LIKE opd_file.opd11
 
   SELECT SUM(opd08) INTO g_opd08t FROM opd_file
    WHERE opd01 = g_opc.opc01
      AND opd02 = g_opc.opc02
      AND opd03 = g_opc.opc03
      AND opd04 = g_opc.opc04
   SELECT SUM(opd09) INTO g_opd09t FROM opd_file
    WHERE opd01 = g_opc.opc01
      AND opd02 = g_opc.opc02
      AND opd03 = g_opc.opc03
      AND opd04 = g_opc.opc04
   SELECT SUM(opd11) INTO g_opd11t FROM opd_file
    WHERE opd01 = g_opc.opc01
      AND opd02 = g_opc.opc02
      AND opd03 = g_opc.opc03
      AND opd04 = g_opc.opc04
   IF cl_null(g_opd08t) THEN LET g_opd08t = 0 END IF
   IF cl_null(g_opd09t) THEN LET g_opd09t = 0 END IF
   DISPLAY g_opd08t TO FORMONLY.opd08t
   DISPLAY g_opd09t TO FORMONLY.opd09t
   DISPLAY g_opd11t TO FORMONLY.opd11t
END FUNCTION
 
FUNCTION i171_g() 
    DEFINE i       LIKE type_file.num5,     #No.FUN-680137 SMALLINT
           j       LIKE type_file.num5,     #No.FUN-680137 SMALLINT
           k       LIKE type_file.num5,     #FUN-650137 add       #No.FUN-680137 SMALLINT
           l_m1    LIKE type_file.num5,     #FUN-650137 add       #No.FUN-680137 SMALLINT
           l_mm    LIKE type_file.num5,     #月                   #No.FUN-680137 SMALLINT
           l_dd    LIKE type_file.num5,     #日                   #No.FUN-680137 SMALLINT
           l_yy    LIKE type_file.num5      #年                   #No.FUN-680137 SMALLINT
 
    LET g_success='Y'
    BEGIN WORK

    FOR i = 1 TO g_opc.opc07
        LET g_opd[i].opd05 = i
        CASE g_opc.opc06
             WHEN '1' #依時距
                  IF i = 1 THEN
                      LET g_opd[i].opd06 = g_opc.opc03 
                  ELSE
                      LET g_opd[i].opd06 = g_opd[i-1].opd07 + 1 UNITS DAY
                  END IF
                  LET g_opd[i].opd07 = g_opd[i].opd06 + (g_rpg[i] - 1) UNITS DAY
             WHEN '2' #天
                  LET g_opd[i].opd06 = g_opc.opc03 + (i-1)*1 
                  LET g_opd[i].opd07 = g_opd[i].opd06
             WHEN '3' #週
                  LET g_opd[i].opd06 = g_opc.opc03 + (i-1)*7 
                  LET g_opd[i].opd07 = g_opd[i].opd06 + 6
             WHEN '4' #旬
                 #當提列方式4.旬, 起始日期應為該月1號,
                 #以該月之最後一天為下旬最後一天
                 #LET g_opd[i].opd06 = g_opc.opc03 + (i-1)*10
                 #LET g_opd[i].opd07 = g_opd[i].opd06 + 9
                  LET l_mm = MONTH(g_opc.opc03)
                  LET l_dd = 1
                  LET l_yy = YEAR(g_opc.opc03) 
                  IF i = 1 THEN
                     LET g_opd[i].opd06 = MDY(l_mm,l_dd,l_yy)
                  ELSE
                     LET g_opd[i].opd06 = g_opd[i-1].opd07 + 1
                  END IF
                  LET k = i MOD 3
                  IF k != 0 THEN
                     LET g_opd[i].opd07 = g_opd[i].opd06 + 9
                  ELSE   #日期應抓當月最後一天
                     LET l_mm = MONTH(g_opd[i].opd06)
                     LET g_opd[i].opd07 = MDY(l_mm+1,l_dd,l_yy) - 1
                  END IF
             WHEN '5' #月
                  IF i = 1 THEN
                      LET l_mm = MONTH(g_opc.opc03)
                      LET l_dd = 1
                      LET l_yy = YEAR(g_opc.opc03) 
                      LET g_opd[i].opd06 = MDY(l_mm,l_dd,l_yy)
                  ELSE
                      LET g_opd[i].opd06 = g_opd[i-1].opd06 + 1 UNITS MONTH
                  END IF
                  LET l_mm = MONTH(g_opd[i].opd06)
                  LET l_yy = YEAR(g_opd[i].opd06)
                  CASE
                      WHEN l_mm = 1 OR l_mm = 3  OR l_mm = 5 OR l_mm = 7 OR
                           l_mm = 8 OR l_mm = 10 OR l_mm = 12
                           LET l_dd = 31
                      WHEN l_mm = 4 OR l_mm = 6 OR l_mm = 9 OR l_mm = 11
                           LET l_dd = 30
                      WHEN l_mm = 2
                           LET l_dd = 29
                           IF l_yy mod 4 = 0 THEN      #計算是否為潤年
                               IF l_yy mod 100 = 0 THEN
                                   IF l_yy mod 400 = 0 THEN
                                       LET l_dd = 29
                                   ELSE
                                       LET l_dd = 28
                                   END IF
                               ELSE
                                   LET l_dd = 29
                               END IF
                           ELSE
                               LET l_dd = 28
                           END IF
                      END CASE
                      LET g_opd[i].opd07 = MDY(l_mm,l_dd,l_yy)
        END CASE
        #----預設上一期的數量、單價、金額 (計劃日期是抓最大日期)---
        #抓還沒展至天
        SELECT opd08,opd10,opd11
          INTO g_opd[i].opd08,g_opd[i].opd10,g_opd[i].opd11
          FROM opd_file,opc_file
         WHERE opc01 = opd01 AND opc02 = opd02
           AND opc03 = opd03 AND opc04 = opd04
           AND opc06 = g_opc.opc06
           AND opd01 = g_opc.opc01
           AND opd02 = g_opc.opc02
           AND opd04 = g_opc.opc04
           AND opd06 = g_opd[i].opd06
           AND opd07 = g_opd[i].opd07
           AND opd03 = (SELECT MAX(opc03) FROM opc_file
                         WHERE opc01 = g_opc.opc01
                           AND opc02 = g_opc.opc02
                           AND opc03 < g_opc.opc03 
                           AND opc04 = g_opc.opc04)
        IF STATUS = 100 THEN
         #抓有展至天
          SELECT opd08,opd10,opd11
            INTO g_opd[i].opd08,g_opd[i].opd10,g_opd[i].opd11
            FROM opd_file,opc_file
           WHERE opc01 = opd01 AND opc02 = opd02
             AND opc03 = opd03 AND opc04 = opd04
             AND opc06 = g_opc.opc06
             AND opd01 = g_opc.opc01
             AND opd02 = g_opc.opc02
             AND opd04 = g_opc.opc04
             AND opd06 = g_opd[i].opd06
             AND opd03 = (SELECT MAX(opc03) FROM opc_file
                           WHERE opc01 = g_opc.opc01
                             AND opc02 = g_opc.opc02
                             AND opc03 < g_opc.opc03 
                             AND opc04 = g_opc.opc04)
           IF STATUS=0 THEN
             SELECT SUM(opd08) INTO g_opd[i].opd08
               FROM opd_file,opc_file
                 WHERE opc01 = opd01 AND opc02 = opd02
                   AND opc03 = opd03 AND opc04 = opd04
                   AND opc06 = g_opc.opc06
                   AND opd01 = g_opc.opc01
                   AND opd02 = g_opc.opc02
                   AND opd04 = g_opc.opc04
                   AND opd06 BETWEEN g_opd[i].opd06 AND g_opd[i].opd07
              IF STATUS=0 THEN
                 LET  g_opd[i].opd11=g_opd[i].opd08*g_opd[i].opd10
              END IF
           ELSE
           LET g_opd[i].opd08 = 0
           LET g_opd[i].opd10 = 0
           LET g_opd[i].opd11 = 0
           END IF
        END IF
        LET g_opd[i].opd09 = 0 #MOD-B30190 add
    END FOR
    #將 array 裡的資料 insert into opd_file
    FOR i = 1 TO g_opc.opc07 
        INSERT INTO opd_file (opd01,opd02,opd03,opd04,opd05,opd06,
                            opd07,opd08,opd09,opd10,opd11,opdplant,opdlegal)  #FUN-980010 add plant & legal 
                  VALUES(g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04,
                         g_opd[i].opd05,g_opd[i].opd06,g_opd[i].opd07,
                         g_opd[i].opd08,g_opd[i].opd09,g_opd[i].opd10,
                         g_opd[i].opd11,g_plant,g_legal)
        IF STATUS THEN
            CALL cl_err3("ins","opd_file",g_opc.opc01,g_opd[i].opd05,STATUS,"","ins opd",1)  #No.FUN-660167
            LET g_success='N'  
        END IF
    END FOR
    IF g_success='N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
    CALL i171_b_fill(' 1=1')
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i171_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM opc_file WHERE opc01 = g_opc.opc01
                                AND opc02=g_opc.opc02
                                AND opc03=g_opc.opc03
                                AND opc04=g_opc.opc04
         INITIALIZE g_opc.*  TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i171_delall()
#   SELECT COUNT(*) INTO g_cnt FROM opd_file
#       WHERE opd01=g_opc.opc01
#         AND opd02=g_opc.opc02
#         AND opd03=g_opc.opc03
#         AND opd04=g_opc.opc04
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM opc_file WHERE opc01 = g_opc.opc01
#                             AND opc02=g_opc.opc02
#                             AND opc03=g_opc.opc03
#                             AND opc04=g_opc.opc04
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i171_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON opd05,opd06,opd07,opd08,opd10,opd11,opd09
            FROM s_opd[1].opd05,s_opd[1].opd06,s_opd[1].opd07,s_opd[1].opd08,
                 s_opd[1].opd10,s_opd[1].opd11,s_opd[1].opd09
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
        RETURN
    END IF
    CALL i171_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i171_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,      #No.FUN-680137 VARCHAR(200)
    l_n             LIKE type_file.num5          #No.FUN-680137 SMALLINT
    LET g_sql =
        "SELECT opd05,opd06,opd07,opd08,opd10,opd11,opd09,''",
        " FROM opd_file",
        " WHERE opd01 ='",g_opc.opc01,"'",  #單頭
        "   AND opd02 ='",g_opc.opc02,"'",
        "   AND opd03 ='",g_opc.opc03,"'",
        "   AND opd04 ='",g_opc.opc04,"'",
        "   AND ",p_wc2 CLIPPED,            #單身
        " ORDER BY 1"
 
    PREPARE i171_pb FROM g_sql
    DECLARE opd_curs                       #CURSOR
        CURSOR WITH HOLD FOR i171_pb
 
    CALL g_opd.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH opd_curs INTO g_opd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_opd.deleteElement(g_cnt)
    CALL g_opd.deleteElement(g_cnt+1)
    LET g_rec_b = g_cnt - 1
    LET l_n = ARR_COUNT()
    CALL SET_COUNT(g_rec_b)
    DISPLAY "g_cnt=",g_cnt
    DISPLAY "g_rec_b",g_rec_b
    DISPLAY "l_n",l_n
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i171_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_opd TO s_opd.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i171_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i171_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i171_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i171_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i171_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認數量修正
      ON ACTION modify_confirm_qty
         LET g_action_choice="modify_confirm_qty"
         EXIT DISPLAY
    #@ON ACTION 計劃展至天
      ON ACTION exlpode_to_daily
         LET g_action_choice="exlpode_to_daily"
         EXIT DISPLAY
    #@ON ACTION 業務確認
      ON ACTION sales_conf
         LET g_action_choice="sales_conf"
         EXIT DISPLAY
    #@ON ACTION 業務取消確認
      ON ACTION undo_sales_confirm
         LET g_action_choice="undo_sales_confirm"
         EXIT DISPLAY
    #@ON ACTION 生管確認
      ON ACTION qc_conf
         LET g_action_choice="qc_conf"
         EXIT DISPLAY
    #@ON ACTION 生管取消確認
      ON ACTION undo_qc_conf
         LET g_action_choice="undo_qc_conf"
         EXIT DISPLAY
      ON ACTION amortization_qry
         LET g_action_choice="amortization_qry"
         EXIT DISPLAY
      ON ACTION batch_copy
         LET g_action_choice="batch_copy"
         EXIT DISPLAY
 
   ON ACTION accept
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
 
 
   ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION related_document                #No.FUN-6B0042  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i171_opc01(p_cmd)  #料件編號
    DEFINE l_ima02  LIKE ima_file.ima02,
           l_ima021 LIKE ima_file.ima021,
           l_imaacti LIKE ima_file.imaacti,
           l_ima133  LIKE ima_file.ima133,        #FUN-870104 add
           p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  LET g_errno = " "
  LET g_cnt = 0
  SELECT COUNT(*) INTO g_cnt
    FROM ima_file
   WHERE ima133 = g_opc.opc01
  SELECT ima02,ima021,imaacti,ima133 INTO l_ima02,l_ima021,l_imaacti,l_ima133 #FUN-870104 add ima133
    FROM ima_file
   WHERE ima01 = g_opc.opc01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL  LET l_imaacti = NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
       WHEN NOT cl_null(l_ima133) AND g_opc.opc01 <> l_ima133 AND g_cnt = 0 #No.FUN-9C0167 如果該料號是預測料號不進行判讀
            LET g_errno = 'axm-171' #請改輸入此料件的預測料號(ima133)!
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_ima02,l_ima021 TO FORMONLY.ima02,FORMONLY.ima021
  END IF
END FUNCTION
 
FUNCTION i171_opc02(p_cmd)  #客戶編號
    DEFINE l_occ02 LIKE occ_file.occ02,
           l_occacti LIKE occ_file.occacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  LET g_errno = " "
  IF cl_null(g_opc.opc02) THEN
     LET g_opc.opc02=' '
     DISPLAY ' ' TO FORMONLY.occ02
     RETURN
  END IF
 
  IF g_opc.opc02 != "MISC" THEN   #FUN-5A0188 add
     SELECT occ02,occacti INTO l_occ02,l_occacti
       FROM occ_file
      WHERE occ01 = g_opc.opc02
    
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-045'
                                    LET l_occ02 = NULL  LET l_occacti = NULL
          WHEN l_occacti='N' LET g_errno = '9028'
          WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
  END IF                          #FUN-5A0188 add
  IF cl_null(g_errno) OR p_cmd = 'd'  THEN
     DISPLAY l_occ02 TO FORMONLY.occ02
  END IF
END FUNCTION
 
FUNCTION i171_opc04(p_cmd)  #業務員
    DEFINE l_gen02 LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti,
           p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file
   WHERE gen01 = g_opc.opc04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-053'
                                 LET l_gen02 = NULL  LET l_genacti = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION
 
FUNCTION i171_opc05(p_cmd)  #部門
  DEFINE l_gem02 LIKE gem_file.gem02,
         l_gemacti LIKE gem_file.gemacti,
         p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gem02,gemacti INTO l_gem02,l_gemacti
    FROM gem_file
   WHERE gem01 = g_opc.opc05
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-039'
                                 LET l_gem02 = NULL  LET l_gemacti = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
FUNCTION i171_opc012(l_opc01)  #料件編號
    DEFINE l_ima02  LIKE ima_file.ima02,
           l_ima021 LIKE ima_file.ima021,
           l_imaacti LIKE ima_file.imaacti,
           l_opc01 LIKE opc_file.opc01
 
  LET g_errno = " "
  SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
    FROM ima_file
   WHERE ima01 = l_opc01
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL  LET l_imaacti = NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_ima02,l_ima021 TO FORMONLY.ima02,FORMONLY.ima021
  END IF
END FUNCTION
FUNCTION i171_opc022(l_opc02)  #客戶編號
    DEFINE l_occ02 LIKE occ_file.occ02,
           l_occacti LIKE occ_file.occacti,
           l_opc02   LIKE opc_file.opc02
 
  LET g_errno = " "
 
  SELECT occ02,occacti INTO l_occ02,l_occacti
    FROM occ_file
   WHERE occ01 = l_opc02
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-045'
                                 LET l_occ02 = NULL  LET l_occacti = NULL
       WHEN l_occacti='N' LET g_errno = '9028'
        WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_occ02 TO FORMONLY.occ02
  END IF
END FUNCTION
 
FUNCTION i171_opc042(l_opc04)  #業務員
    DEFINE l_gen02 LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti,
           l_opc04    LIKE opc_file.opc04
 
 
  LET g_errno = " "
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file
   WHERE gen01 = l_opc04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-053'
                                 LET l_gen02 = NULL  LET l_genacti = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION
 
FUNCTION i171_y()
   DEFINE l_gemacti     LIKE gem_file.gemacti     #TQC-C60211

   SELECT * INTO g_opc.* FROM opc_file
    WHERE opc01 = g_opc.opc01
      AND opc02 = g_opc.opc02
      AND opc03 = g_opc.opc03
      AND opc04 = g_opc.opc04
   IF STATUS THEN
      CALL cl_err3("sel","opc_file",g_opc.opc01,g_opc.opc02,STATUS,"","sel ogc",1)  #No.FUN-660167
      RETURN
   END IF
   IF g_opc.opc11='Y' THEN CALL cl_err('','axm-356',0) RETURN END IF  #No.TQC-7B0031
  #TQC-C60211 -- add -- begin
   SELECT gemacti INTO l_gemacti FROM gem_file
    WHERE gem01 = g_opc.opc05
   IF l_gemacti = 'N' THEN
      CALL cl_err(g_opc.opc05,'asf-472',0)
      RETURN
   END IF
  #TQC-C60211 -- add -- end
   IF NOT cl_confirm('axm-349') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
   IF STATUS THEN
      CALL cl_err("OPEN i171_cl:", STATUS, 1)
      CLOSE i171_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i171_cl INTO g_opc.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i171_cl ROLLBACK WORK RETURN
   END IF
   UPDATE opc_file SET opc11 = 'Y'
    WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03
      AND opc04=g_opc.opc04
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
      CALL cl_err3("upd","opc_file",g_opc.opc01,g_opc.opc02,STATUS,"","upd opc11",1)  #No.FUN-660167
      LET g_success='N' 
   ELSE                        #No.FUN-920183
      CALL i171_ins_ope('y')   #No.FUN-920183
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_opc.opc11 ='Y'
      DISPLAY BY NAME  g_opc.opc11
   ELSE
      ROLLBACK WORK
   END IF
   SELECT opc11 INTO g_opc.opc11 FROM opc_file
    WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03
      AND opc04=g_opc.opc04
   DISPLAY BY NAME  g_opc.opc11
END FUNCTION
 
FUNCTION i171_z()
   SELECT * INTO g_opc.* FROM opc_file
    WHERE opc01 = g_opc.opc01
      AND opc02 = g_opc.opc02
      AND opc03 = g_opc.opc03
      AND opc04 = g_opc.opc04
   IF g_opc.opc11='N' THEN CALL cl_err('','axm-357',0) RETURN END IF  #No.TQC-7B0031
   IF g_opc.opc12='Y' THEN CALL cl_err('','axm-353',0) RETURN END IF
   IF NOT cl_confirm('axm-350') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
   IF STATUS THEN
      CALL cl_err("OPEN i171_cl:", STATUS, 1)
      CLOSE i171_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i171_cl INTO g_opc.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i171_cl ROLLBACK WORK RETURN
   END IF
   UPDATE opc_file SET opc11 = 'N'
    WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03
      AND opc04=g_opc.opc04
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   ELSE                        #No.FUN-920183
      CALL i171_ins_ope('z')   #No.FUN-920183
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT opc11 INTO g_opc.opc11 FROM opc_file
    WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03
      AND opc04=g_opc.opc04
   DISPLAY BY NAME  g_opc.opc11
END FUNCTION
 
FUNCTION i171_s()
   DEFINE l_gemacti     LIKE gem_file.gemacti     #TQC-C60211
   SELECT * INTO g_opc.* FROM opc_file
    WHERE opc01 = g_opc.opc01
      AND opc02 = g_opc.opc02
      AND opc03 = g_opc.opc03
      AND opc04 = g_opc.opc04
   IF g_opc.opc12 = 'Y' THEN CALL cl_err('','axm-358',0) RETURN END IF  #No.TQC-7B0031
   IF g_opc.opc11 = 'N' THEN CALL cl_err('','axm-354',0) RETURN END IF
  #TQC-C60211 -- add -- begin
   SELECT gemacti INTO l_gemacti FROM gem_file
    WHERE gem01 = g_opc.opc05
   IF l_gemacti = 'N' THEN
      CALL cl_err(g_opc.opc05,'asf-472',0)
      RETURN
   END IF
  #TQC-C60211 -- add -- end
   IF NOT cl_confirm('axm-351') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
   IF STATUS THEN
      CALL cl_err("OPEN i171_cl:", STATUS, 1)
      CLOSE i171_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i171_cl INTO g_opc.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i171_cl ROLLBACK WORK RETURN
   END IF
   UPDATE opc_file SET opc12 = 'Y'
    WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03
      AND opc04=g_opc.opc04
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
         CALL cl_err3("upd","opc_file",g_opc.opc01,g_opc.opc02,STATUS,"","upd opc12",1)  #No.FUN-660167
         LET g_success='N' 
      ELSE                        #No.FUN-920183
         CALL i171_ins_ope('s')   #No.FUN-920183
      END IF
   IF g_success='Y'
      THEN COMMIT WORK LET g_opc.opc12 ='Y' DISPLAY BY NAME  g_opc.opc12
      ELSE ROLLBACK WORK
   END IF
   SELECT opc12 INTO g_opc.opc12 FROM opc_file
    WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03
      AND opc04=g_opc.opc04
   DISPLAY BY NAME  g_opc.opc12
END FUNCTION
 
FUNCTION i171_w()
   SELECT * INTO g_opc.* FROM opc_file
    WHERE opc01 = g_opc.opc01
      AND opc02 = g_opc.opc02
      AND opc03 = g_opc.opc03
      AND opc04 = g_opc.opc04
   IF g_opc.opc12='N' THEN CALL cl_err('','axm-359',0) RETURN END IF  #No.TQC-7B0031
   IF NOT cl_confirm('axm-352') THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i171_cl USING g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
   IF STATUS THEN
      CALL cl_err("OPEN i171_cl:", STATUS, 1)
      CLOSE i171_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i171_cl INTO g_opc.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_opc.opc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i171_cl ROLLBACK WORK RETURN
   END IF
   UPDATE opc_file SET opc12 = 'N'
    WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03
      AND opc04=g_opc.opc04
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT opc12 INTO g_opc.opc12 FROM opc_file
    WHERE opc01=g_opc.opc01 AND opc02=g_opc.opc02 AND opc03=g_opc.opc03
      AND opc04=g_opc.opc04
   DISPLAY BY NAME  g_opc.opc12
END FUNCTION
 
FUNCTION i171_ins_ope(p_cmd)
 DEFINE p_cmd      LIKE type_file.chr1
 DEFINE l_cnt      LIKE type_file.num5
 DEFINE l_n        LIKE type_file.num5
 DEFINE l_i        LIKE type_file.num5
 DEFINE l_ope      RECORD LIKE ope_file.*
 DEFINE l_ope06    LIKE ope_file.ope06
 DEFINE l_ope08    LIKE ope_file.ope08
 DEFINE l_ope09    LIKE ope_file.ope09
 DEFINE l_ope11    LIKE ope_file.ope11
 DEFINE l_ope081   STRING
 DEFINE l_ope091   STRING
 DEFINE l_sum1     LIKE type_file.num20 #No.FUN-9C0121
 DEFINE l_sum2     LIKE type_file.num20 #No.FUN-9C0121
 
   IF p_cmd = 'z' OR p_cmd = 's' THEN
      DELETE FROM ope_file WHERE ope01 = g_opc.opc01
                             AND ope02 = g_opc.opc02
                             AND ope03 = g_opc.opc03
                             AND ope04 = g_opc.opc04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ope_file",g_opc.opc01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
      END IF
   END IF
 
   IF (p_cmd = 'y' OR p_cmd = 's') AND g_success = 'Y' THEN
      DECLARE opd_cur CURSOR FOR
       SELECT opd01,opd02,opd03,opd04,opd05,opd06,opd07,opd08,opd09,opd10,opd11  
         FROM opd_file
        WHERE opd01 = g_opc.opc01
          AND opd02 = g_opc.opc02
          AND opd03 = g_opc.opc03
          AND opd04 = g_opc.opc04
        ORDER BY opd01,opd02,opd03,opd04,opd05
      LET l_cnt = 1 
      INITIALIZE l_ope.* LIKE ope_file.*
      FOREACH opd_cur INTO l_ope.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         IF g_sma.sma130 = '0' THEN
            INSERT INTO ope_file VALUES(l_ope.ope01,l_ope.ope02,l_ope.ope03,
                                        l_ope.ope04,l_ope.ope05,l_ope.ope06,
                                        '',l_ope.ope08,l_ope.ope09,
                                        l_ope.ope10,l_ope.ope11,g_plant,g_legal)   #FUN-980019 add plant & legal 
         ELSE
            LET l_n = s_trunc( (l_ope.ope07-l_ope.ope06+1), 0 )
            IF g_sma.sma130 = '1' THEN       #No.FUN-9C0121
               LET l_ope08 = l_ope.ope08 / l_n
               LET l_ope09 = l_ope.ope09 / l_n
           #No.FUN-9C0121 BEGIN -----
            ELSE
               LET l_ope081 = l_ope.ope08 / l_n
               LET l_ope091 = l_ope.ope09 / l_n
               LET l_ope08 = l_ope081.subString(1,l_ope081.getIndexOf('.',1))
               LET l_ope09 = l_ope091.subString(1,l_ope091.getIndexOf('.',1))
               LET l_sum1 = 0
               LET l_sum2 = 0
            END IF
            LET l_ope11 = l_ope08 * l_ope.ope10
            FOR l_i = 1 TO l_n
               IF l_i = 1 THEN
                  LET l_ope06 = l_ope.ope06
               ELSE
                  LET l_ope06 = l_ope06 + 1
               END IF
               IF l_i = l_n AND g_sma.sma130 = '2' THEN
                  LET l_ope08 = l_ope.ope08 - l_sum1
                  LET l_ope09 = l_ope.ope09 - l_sum2
                  LET l_ope11 = l_ope08 * l_ope.ope10
               ELSE
                  LET l_sum1 = l_sum1 + l_ope08
                  LET l_sum2 = l_sum2 + l_ope09
               END IF
               INSERT INTO ope_file VALUES(l_ope.ope01,l_ope.ope02,l_ope.ope03,
                                           l_ope.ope04,l_ope.ope05,l_ope06,
                                           '',l_ope08,l_ope09,
                                           l_ope.ope10,l_ope11,g_plant,g_legal)   #FUN-980019 add plant & legal 
               END FOR
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
   END IF
 
END FUNCTION
 
FUNCTION i171_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
    l_wc            LIKE type_file.chr1000,       #No.FUN-970057 
    sr              RECORD
        opc01       LIKE opc_file.opc01,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        opc02       LIKE opc_file.opc02,
        opc03       LIKE opc_file.opc03,
        opc04       LIKE opc_file.opc04,
        opc05       LIKE opc_file.opc05,
        opc06       LIKE opc_file.opc06,
        opc07       LIKE opc_file.opc07,
        opd05       LIKE opd_file.opd05,
        opd06       LIKE opd_file.opd06,
        opd07       LIKE opd_file.opd07,
        opd08       LIKE opd_file.opd08,
        opd09       LIKE opd_file.opd09
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680137 VARCHAR(20)
    l_za05          LIKE type_file.chr1000,              #No.FUN-680137 VARCHAR(40)
    l_occ02     LIKE occ_file.occ02, 
    l_gem02     LIKE gem_file.gem02, 
    l_gen02     LIKE gen_file.gen02 
    IF cl_null(g_wc) AND NOT cl_null(g_opc.opc01) 
       AND NOT cl_null(g_opc.opc02) AND NOT cl_null(g_opc.opc03) 
       AND NOT cl_null(g_opc.opc04) THEN 
       LET g_wc = " opc01 = '",g_opc.opc01,"' AND opc02 = '",g_opc.opc02,"' AND opc03 = '",
                  g_opc.opc03,"' AND opc04='",g_opc.opc04,"'" 
    END IF 
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF 
    IF g_wc2 IS NULL THEN
       LET g_wc2 = "1=1"
    END IF
    CALL cl_del_data(l_table)
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT opc01,ima02,ima021,opc02,opc03,opc04,opc05,opc06,opc07,",
              "       opd05,opd06,opd07,opd08,opd09 ",
              "  FROM opd_file,opc_file LEFT OUTER JOIN ima_file ON opc_file.opc01=ima_file.ima01 ",
              " WHERE opc01 = opd01 AND ",g_wc CLIPPED,
              "   AND opc02 = opd02 ",
              "   AND opc03 = opd03 ",
              "   AND opc04 = opd04 ",
              " ORDER BY opc01,opc02,opc03,opc04,opd05 "
    PREPARE i171_p1 FROM g_sql                # RUNTIME 編譯
    IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
    DECLARE i171_co                           # CURSOR
        CURSOR WITH HOLD FOR i171_p1
 
    LET g_rlang = g_lang                               #FUN-4C0096 add
    LET l_n = 0
    FOREACH i171_co INTO sr.*
        LET l_n = l_n + 1
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET l_occ02='' LET l_gem02='' LET l_gen02=''
        SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.opc05
        IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.opc04
        IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
        SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01=sr.opc02
        IF SQLCA.sqlcode THEN LET l_occ02 = ' ' END IF
    
        EXECUTE insert_prep USING sr.opc01,sr.opc02,sr.opc03,sr.opc04,sr.ima02,
             sr.ima021,l_gen02,sr.opc05,l_gem02,l_occ02,sr.opc06,sr.opc07,
             sr.opd05,sr.opd06,sr.opd07,sr.opd08,sr.opd09
    END FOREACH
 
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
    IF g_zz05='Y' THEN
       CALL cl_wcchp(g_wc,'opc01,opc02,opc03,opc04,opc05,opc06,opc10,opc07,                          opc08,opc09,opc11,opc12')
          RETURNING l_wc   #No.TQC-970057 
    ELSE
       LET g_wc=""
    END IF
    LET g_str = l_wc       #No.TQC-970057
    CALL cl_prt_cs3('axmi171','axmi171',g_sql,g_str)
 
    CLOSE i171_co
END FUNCTION
 
#genero
#單頭
FUNCTION i171_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
        CALL cl_set_comp_entry("opc01,opc02,opc03,opc04",TRUE)  #No.MOD-480606
   END IF
   IF INFIELD(opc06) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("opc10",TRUE)
   END IF
   IF p_cmd = 'a' THEN
        CALL cl_set_comp_entry("opc01,opc02,opc03,opc04",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i171_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("opc01,opc02,opc03,opc04",FALSE)
       END IF
   END IF
   IF INFIELD(opc06) OR (NOT g_before_input_done) THEN
       IF g_opc.opc06 != '1' THEN
           CALL cl_set_comp_entry("opc10",FALSE)
       END IF
   END IF
 
END FUNCTION
FUNCTION i171_copy()
DEFINE l_opc     RECORD LIKE opc_file.*,
       l_oldno1,l_newno1   LIKE opc_file.opc01,
       l_oldno2,l_newno2   LIKE opc_file.opc02,
       l_oldno3,l_newno3   LIKE opc_file.opc03,
       l_oldno4,l_newno4   LIKE opc_file.opc04,
       l_n       LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_opc.opc01) OR cl_null(g_opc.opc03) OR
      cl_null(g_opc.opc04) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL i171_set_entry('a')
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT l_newno1,l_newno2,l_newno3,l_newno4 FROM opc01,opc02,opc03,opc04
 
        AFTER FIELD opc01
          IF NOT cl_null(l_newno1) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(l_newno1,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD opc01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
              CALL i171_opc012(l_newno1)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD opc01
              END IF
          END IF
 
        AFTER FIELD opc02
          IF NOT cl_null(l_newno2) THEN
              CALL i171_opc022(l_newno2)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0) NEXT FIELD opc02
              END IF
          ELSE
              LET l_newno2 = ' '
          END IF
 
        AFTER FIELD opc04
          IF NOT cl_null(l_newno4) THEN
             SELECT COUNT(*) INTO l_n FROM opc_file
                    WHERE opc01=l_newno1
                      AND opc02=l_newno2
                      AND opc03=l_newno3
                      AND opc04=l_newno4
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                NEXT FIELD opc01
             END IF
             CALL i171_opc042(l_newno4)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0) NEXT FIELD opc04
             END IF
          END IF
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(opc01)
#FUN-AA0059---------mod------------str-----------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = l_newno1
#                  CALL cl_create_qry() RETURNING l_newno1
                   CALL q_sel_ima(FALSE, "q_ima","",l_newno1,"","","","","",'' ) 
                     RETURNING  l_newno1
#FUN-AA0059---------mod------------end-----------------

                  DISPLAY l_newno1 TO opc01
                  NEXT FIELD opc01
                WHEN INFIELD(opc02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.default1 = l_newno2
                  CALL cl_create_qry() RETURNING l_newno2
                  DISPLAY l_newno2 TO opc02
                  NEXT FIELD opc02
                WHEN INFIELD(opc04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = l_newno4
                  CALL cl_create_qry() RETURNING l_newno4
                  DISPLAY l_newno4 TO opc04
                  NEXT FIELD opc04
           END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_opc.opc01,g_opc.opc02,g_opc.opc03,g_opc.opc04
      RETURN
   END IF
 
   LET l_opc.* = g_opc.*
   LET l_opc.opc01 = l_newno1
   LET l_opc.opc02 = l_newno2
   LET l_opc.opc03 = l_newno3
   LET l_opc.opc04 = l_newno4
   LET l_opc.opc11 = 'N'       #No.TQC-770045
   LET l_opc.opc12 = 'N'       #No.TQC-770045
   LET l_opc.opcplant = g_plant 
   LET l_opc.opclegal = g_legal 
   LET l_opc.opcuser=g_user   #CHI-BB0046 add
   LET l_opc.opcgrup=g_grup   #CHI-BB0046 add
   LET l_opc.opcmodu=g_user   #CHI-BB0046 add
   LET l_opc.opcdate=g_today  #CHI-BB0046 add
   LET l_opc.opcacti='Y'      #CHI-BB0046 add
   BEGIN WORK
 
   LET l_opc.opcoriu = g_user      #No.FUN-980030 10/01/04
   LET l_opc.opcorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO opc_file VALUES (l_opc.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","opc_file",l_opc.opc01,l_opc.opc02,SQLCA.sqlcode,"","opc",1)  #No.FUN-660167
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM opd_file
     WHERE opd01=g_opc.opc01 AND opd02=g_opc.opc02 AND
           opd03=g_opc.opc03 AND opd04=g_opc.opc04
   INTO TEMP x
      IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_opc.opc01,g_opc.opc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
      RETURN
   END IF
 
   UPDATE x SET opd01=l_newno1,opd02=l_newno2,opd03=l_newno3,opd04=l_newno4
 
   INSERT INTO opd_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","opd_file",l_newno1,l_newno2,SQLCA.sqlcode,"","opd",1)  #No.FUN-660167
      ROLLBACK WORK
      RETURN
   END IF
 
   COMMIT WORK
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
   LET l_oldno1 = g_opc.opc01
   LET l_oldno2 = g_opc.opc02
   LET l_oldno3 = g_opc.opc03
   LET l_oldno4 = g_opc.opc04
 
   SELECT opc_file.* INTO g_opc.* FROM opc_file
      WHERE opc01=l_newno1 AND opc02=l_newno2 AND
            opc03=l_newno3 AND opc04=l_newno4
 
   CALL i171_u()
 
   CALL i171_b('')
 
   #SELECT opc_file.* INTO g_opc.* FROM opc_file   #FUN-C80046
   #   WHERE opc01=l_oldno1 AND opc02=l_oldno2 AND #FUN-C80046
   #         opc03=l_oldno3 AND opc04=l_oldno4     #FUN-C80046
 
   CALL i171_show()
END FUNCTION
 
#單身
FUNCTION i171_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("opd05,opd06,opd07,opd08,opd10,opd11,opd09",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i171_set_no_entry_b(p_cmd,p_flag)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   p_flag    LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("opd11",FALSE)  #TQC-9C0005
       IF p_flag='d' THEN
           CALL cl_set_comp_entry("opd05,opd06,opd07,opd08,opd10,opd11",FALSE)
       END IF
       IF p_flag = 'b' THEN
           CALL cl_set_comp_entry("opd09",FALSE)
       END IF
   END IF
 
END FUNCTION
FUNCTION i171_batch_copy()
DEFINE tm    RECORD
         odate         LIKE opc_file.opc03,
         ndate         LIKE opc_file.opc03
       END RECORD
DEFINE l_opc    RECORD LIKE opc_file.*
DEFINE l_opd    RECORD LIKE opd_file.*
DEFINE l_opc_t  RECORD LIKE opc_file.*
DEFINE l_success       LIKE type_file.chr1
DEFINE l_msg           LIKE type_file.chr1000
DEFINE l_opd05         LIKE opd_file.opd05      #MOD-B30190 add
DEFINE l_i             LIKE type_file.num5      #MOD-B30190 add
DEFINE l_opc03         LIKE opc_file.opc03      #MOD-B30190 add
 
   OPEN WINDOW i171_w1  WITH FORM "axm/42f/axmi1711"                  #顯示畫面
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("axmi1711")
   INPUT BY NAME tm.odate,tm.ndate WITHOUT DEFAULTS
      BEFORE INPUT
         LET tm.odate=''
         LET tm.ndate=''
         DISPLAY tm.odate TO odate
         DISPLAY tm.ndate TO ndate
 
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
      CLOSE WINDOW i171_w1
      RETURN
   END IF
   CLOSE WINDOW i171_w1
   DECLARE i171_batch_1 CURSOR FOR
    SELECT DISTINCT opc_file.*
      FROM opc_file,opd_file
    WHERE opc01=opd01
      AND opc02=opd02
      AND opc03=opd03
      AND opc04=opd04
      AND opc03=tm.odate
      AND opd06>=tm.ndate
      AND opc01=g_opc.opc01 
 
   LET l_success = 'N'
   CALL s_showmsg_init()
   FOREACH i171_batch_1 INTO l_opc.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_opc.opc11 = 'N'
      LET l_opc.opc12 = 'N'
      LET l_opc.opc03 = tm.ndate
 
      LET l_opc.opcoriu = g_user      #No.FUN-980030 10/01/04
      LET l_opc.opcorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO opc_file VALUES(l_opc.*)
      IF SQLCA.sqlcode<>0 THEN
         LET l_msg=l_opc.opc01,'/',l_opc.opc02,'/',l_opc.opc03,'/',
                   l_opc.opc04
         CALL s_errmsg("opc_file",l_msg,' ',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      DECLARE i171_batch_2 CURSOR FOR
       SELECT *
         FROM opd_file
        WHERE opd01=l_opc.opc01
          AND opd02=l_opc.opc02
          AND opd03=tm.odate
          AND opd04=l_opc.opc04
          AND opd06>=tm.ndate
      LET l_opd05 = 0 #MOD-B30190 add
      FOREACH i171_batch_2 INTO l_opd.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_opd.opd03 = tm.ndate
         #MOD-B30190 add --start--
         LET l_opd05 = l_opd05 + 1 
         LET l_opd.opd05 = l_opd05 
         LET l_opc03 = l_opd.opd07 + 1
         #MOD-B30190 add --end--
         INSERT INTO opd_file VALUES(l_opd.*)
         IF SQLCA.sqlcode<>0 THEN
            LET l_msg=l_opd.opd01,'/',l_opd.opd02,'/',l_opd.opd03,'/',
                      l_opd.opd04,'/',l_opd.opd05
            CALL s_errmsg("opd_file",l_msg,' ',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
         LET l_success = 'Y'
      END FOREACH
      #MOD-B30190 add --start--
      LET l_i = 0 
      IF l_opc.opc07 - l_opd05 > 0 THEN
         LET l_i = l_opd05
         CALL i171_ins_opd(l_i,l_opc03,tm.ndate)
      END IF
      IF g_success='Y' THEN
         LET l_success = 'Y'
      ELSE
         LET l_success = 'N'
      END IF
      #MOD-B30190 add --end--
   END FOREACH
   CALL s_showmsg()
   IF l_success='Y' THEN
      CALL cl_err('','axm-321',1)
   ELSE
      CALL cl_err('','axm-323',1)
   END IF
END FUNCTION

#MOD-B30190 add --start--
FUNCTION i171_ins_opd(p_i,p_opc03,p_ndate) 
    DEFINE i       LIKE type_file.num5,     
           j       LIKE type_file.num5,   
           k       LIKE type_file.num5,  
           l_m1    LIKE type_file.num5, 
           l_mm    LIKE type_file.num5,     #月     
           l_dd    LIKE type_file.num5,     #日   
           l_yy    LIKE type_file.num5,     #年 
           p_i     LIKE type_file.num5,     
           p_opc03 LIKE opc_file.opc03,   
           p_ndate LIKE opc_file.opc03  
 
    LET g_success='Y'

    FOR i = 1 TO g_opc.opc07 - p_i
        LET g_opd[i].opd05 = i + p_i
        CASE g_opc.opc06
             WHEN '1' #依時距
                  IF i = 1 THEN
                      LET g_opd[i].opd06 = p_opc03 
                  ELSE
                      LET g_opd[i].opd06 = g_opd[i-1].opd07 + 1 UNITS DAY
                  END IF
                  LET g_opd[i].opd07 = g_opd[i].opd06 + (g_rpg[i] - 1) UNITS DAY
             WHEN '2' #天
                  LET g_opd[i].opd06 = p_opc03 + (i-1)*1 
                  LET g_opd[i].opd07 = g_opd[i].opd06
             WHEN '3' #週
                  LET g_opd[i].opd06 = p_opc03 + (i-1)*7 
                  LET g_opd[i].opd07 = g_opd[i].opd06 + 6
             WHEN '4' #旬
                 #當提列方式4.旬, 起始日期應為該月1號,
                 #以該月之最後一天為下旬最後一天
                  LET l_mm = MONTH(p_opc03)   
                  LET l_dd = 1
                  LET l_yy = YEAR(p_opc03) 
                  IF i = 1 THEN
                     LET g_opd[i].opd06 = MDY(l_mm,l_dd,l_yy)
                  ELSE
                     LET g_opd[i].opd06 = g_opd[i-1].opd07 + 1
                  END IF
                  LET k = i MOD 3
                  IF k != 0 THEN
                     LET g_opd[i].opd07 = g_opd[i].opd06 + 9
                  ELSE   #日期應抓當月最後一天
                     LET l_mm = MONTH(g_opd[i].opd06)
                     LET g_opd[i].opd07 = MDY(l_mm+1,l_dd,l_yy) - 1
                  END IF
             WHEN '5' #月
                  IF i = 1 THEN
                      LET l_mm = MONTH(p_opc03) 
                      LET l_dd = 1
                      LET l_yy = YEAR(p_opc03) 
                      LET g_opd[i].opd06 = MDY(l_mm,l_dd,l_yy)
                  ELSE
                      LET g_opd[i].opd06 = g_opd[i-1].opd06 + 1 UNITS MONTH
                  END IF
                  LET l_mm = MONTH(g_opd[i].opd06)
                  LET l_yy = YEAR(g_opd[i].opd06)
                  CASE
                      WHEN l_mm = 1 OR l_mm = 3  OR l_mm = 5 OR l_mm = 7 OR
                           l_mm = 8 OR l_mm = 10 OR l_mm = 12
                           LET l_dd = 31
                      WHEN l_mm = 4 OR l_mm = 6 OR l_mm = 9 OR l_mm = 11
                           LET l_dd = 30
                      WHEN l_mm = 2
                           LET l_dd = 29
                           IF l_yy mod 4 = 0 THEN      #計算是否為潤年
                               IF l_yy mod 100 = 0 THEN
                                   IF l_yy mod 400 = 0 THEN
                                       LET l_dd = 29
                                   ELSE
                                       LET l_dd = 28
                                   END IF
                               ELSE
                                   LET l_dd = 29
                               END IF
                           ELSE
                               LET l_dd = 28
                           END IF
                      END CASE
                      LET g_opd[i].opd07 = MDY(l_mm,l_dd,l_yy)
        END CASE
        #----預設上一期的數量、單價、金額 (計劃日期是抓最大日期)---
        #抓還沒展至天
        SELECT opd08,opd10,opd11
          INTO g_opd[i].opd08,g_opd[i].opd10,g_opd[i].opd11
          FROM opd_file,opc_file
         WHERE opc01 = opd01 AND opc02 = opd02
           AND opc03 = opd03 AND opc04 = opd04
           AND opc06 = g_opc.opc06
           AND opd01 = g_opc.opc01
           AND opd02 = g_opc.opc02
           AND opd04 = g_opc.opc04
           AND opd06 = g_opd[i].opd06
           AND opd07 = g_opd[i].opd07
           AND opd03 = (SELECT MAX(opc03) FROM opc_file
                         WHERE opc01 = g_opc.opc01
                           AND opc02 = g_opc.opc02
                           AND opc03 < p_ndate 
                           AND opc04 = g_opc.opc04)
        IF STATUS = 100 THEN
         #抓有展至天
          SELECT opd08,opd10,opd11
            INTO g_opd[i].opd08,g_opd[i].opd10,g_opd[i].opd11
            FROM opd_file,opc_file
           WHERE opc01 = opd01 AND opc02 = opd02
             AND opc03 = opd03 AND opc04 = opd04
             AND opc06 = g_opc.opc06
             AND opd01 = g_opc.opc01
             AND opd02 = g_opc.opc02
             AND opd04 = g_opc.opc04
             AND opd06 = g_opd[i].opd06
             AND opd03 = (SELECT MAX(opc03) FROM opc_file
                           WHERE opc01 = g_opc.opc01
                             AND opc02 = g_opc.opc02
                             AND opc03 < p_ndate 
                             AND opc04 = g_opc.opc04)
           IF STATUS=0 THEN
             SELECT SUM(opd08) INTO g_opd[i].opd08
               FROM opd_file,opc_file
                 WHERE opc01 = opd01 AND opc02 = opd02
                   AND opc03 = opd03 AND opc04 = opd04
                   AND opc06 = g_opc.opc06
                   AND opd01 = g_opc.opc01
                   AND opd02 = g_opc.opc02
                   AND opd04 = g_opc.opc04
                   AND opd06 BETWEEN g_opd[i].opd06 AND g_opd[i].opd07
              IF STATUS=0 THEN
                 LET  g_opd[i].opd11=g_opd[i].opd08*g_opd[i].opd10
              END IF
           ELSE
           LET g_opd[i].opd08 = 0
           LET g_opd[i].opd10 = 0
           LET g_opd[i].opd11 = 0
           END IF
        END IF
        LET g_opd[i].opd09 = 0
    END FOR
    #將 array 裡的資料 insert into opd_file
    FOR i = 1 TO g_opc.opc07 - p_i 
        INSERT INTO opd_file (opd01,opd02,opd03,opd04,opd05,opd06,
                            opd07,opd08,opd09,opd10,opd11,opdplant,opdlegal) 
                  VALUES(g_opc.opc01,g_opc.opc02,p_ndate,g_opc.opc04,   
                         g_opd[i].opd05,g_opd[i].opd06,g_opd[i].opd07,
                         g_opd[i].opd08,g_opd[i].opd09,g_opd[i].opd10,
                         g_opd[i].opd11,g_plant,g_legal)
        IF STATUS THEN
            CALL cl_err3("ins","opd_file",g_opc.opc01,g_opd[i].opd05,STATUS,"","ins opd",1) 
            LET g_success='N'  
        END IF
    END FOR
    CALL i171_b_fill(' 1=1')
END FUNCTION
#MOD-B30190 add --end--

FUNCTION i171_2()
 DEFINE l_opd     RECORD LIKE opd_file.*
 DEFINE l_ope     DYNAMIC ARRAY OF RECORD
        ope05     LIKE ope_file.ope05,
        ope06     LIKE ope_file.ope06,
        ope08     LIKE ope_file.ope08,
        ope09     LIKE ope_file.ope09,
        ope10     LIKE ope_file.ope10,
        ope11     LIKE ope_file.ope11
                  END RECORD
 DEFINE l_ima02   LIKE ima_file.ima02
 DEFINE l_ima021  LIKE ima_file.ima021
 DEFINE l_occ02   LIKE occ_file.occ02
 DEFINE l_gen02   LIKE gen_file.gen02
 DEFINE l_gem02   LIKE gem_file.gem02

   IF g_opc.opc01 IS NULL OR l_ac = 0 THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO l_opd.*
    FROM opd_file
   WHERE opd01 = g_opc.opc01
     AND opd02 = g_opc.opc02
     AND opd03 = g_opc.opc03
     AND opd04 = g_opc.opc04
     AND opd05 = g_opd[l_ac].opd05

   DECLARE i1712_curs CURSOR FOR
    SELECT ope05,ope06,ope08,ope09,ope10,ope11
      FROM ope_file
     WHERE ope01 = l_opd.opd01
       AND ope02 = l_opd.opd02
       AND ope03 = l_opd.opd03
       AND ope04 = l_opd.opd04
       AND ope05 = l_opd.opd05
     ORDER BY ope05
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare i1712_curs',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   CALL l_ope.clear()
   LET g_cnt = 1
   FOREACH i1712_curs INTO l_ope[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach i1712_curs',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL l_ope.deleteElement(g_cnt)
   LET g_cnt = g_cnt - 1

   OPEN WINDOW i1712_w WITH FORM "axm/42f/axmi1712"
        ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("axmi1712")

   DISPLAY g_cnt TO FORMONLY.cn2
   DISPLAY BY NAME l_opd.opd01,l_opd.opd02,l_opd.opd03,l_opd.opd04,
                   l_opd.opd05,l_opd.opd06,l_opd.opd07,l_opd.opd08,
                   l_opd.opd09,l_opd.opd10,l_opd.opd11
   DISPLAY g_opc.opc05 TO FORMONLY.opc05
   SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
    WHERE ima01 = l_opd.opd01
   SELECT occ02 INTO l_occ02 FROM occ_file
    WHERE occ01 = l_opd.opd02
   SELECT gen02 INTO l_gen02 FROM gen_file
    WHERE gen01 = l_opd.opd04
   SELECT gem02 INTO l_gem02 FROM gem_file
    WHERE gem01 = g_opc.opc05
   DISPLAY l_ima02  TO FORMONLY.ima02
   DISPLAY l_ima021 TO FORMONLY.ima021
   DISPLAY l_occ02  TO FORMONLY.occ02
   DISPLAY l_gen02  TO FORMONLY.gen02
   DISPLAY l_gem02  TO FORMONLY.gem02

   DISPLAY ARRAY l_ope TO s_ope.* ATTRIBUTE(COUNT=g_cnt)

   END DISPLAY
   CLOSE WINDOW i1712_w
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
