# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: ggli002.4gl
# Descriptions...: 聯屬公司層級維護作業
# Date & Author..: 01/09/17   BY Debbie Hsu
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-490442 04/10/04 By Nicola 依工廠別開窗開不同帳別資料
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-510007 05/01/20 By Nicola 報表架構修改
# Modify.........: No.FUN-580063 05/08/12 By Sarah 1.azp02改成asg02,azp03改成asg03
#                                                  2.單身增加維護欄位: asb11, asb12,放在asb07後面
#                                                  3.單身子公司若不使用TIPTOP(asg04='N'), 則不check帳別的正確性
# Modify.........: No.FUN-590014 05/09/08 By Dido 選擇公司別(單頭/單身)應可自動代出帳別, 且不應可以修改
# Modify.........: No.TQC-5B0064 05/11/09 By Niocla 報表修改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660043 06/06/16 By Smapmin 將資料庫代碼改為營運中心代碼
# Modify.........: No.FUN-660123 06/06/28 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/28 By yjkhero  欄位類型轉換為 LIKE型    
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0040 06/11/15 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.TQC-720019 07/02/28 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.CHI-740039 07/04/26 By Sarah 單身無輸入時,依標準作法應詢問'是否刪除....'訊息
# Modify.........: No.FUN-740175 07/04/26 By Sarah 下層公司資料不可維護同單頭公司,帳別
# Modify.........: No.TQC-740291 07/04/26 By Sarah 單頭及單身公司/帳別應要判斷agli009
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760085 07/07/25 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.MOD-790108 07/09/26 By Smapmin 上層公司與下層公司不可相同
# Modify.........: No.FUN-7A0035 07/10/17 By Nicola 新增欄位長期投資科目(asb13)
# Modify.........: No.MOD-7B0223 07/11/27 By Lutingting EXECUTE 增加aag02       
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.MOD-910118 09/01/14 By Sarah 當公司階層有多階,例A-B-C,建立A-B時成功,但建立B-C時會出現agl-152訊息
# Modify.........: No.MOD-930093 09/03/10 By lilingyu 更改刪除狀態離開時,行數算錯的問題
# Modify.........: No.FUN-910001 09/05/18 By lutingting 由11區追單,asa01(群組代號)增加開窗功能  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-920110 09/05/20 BY hongmei BEFORE ROW抓取aag02要跨db 
# Modify.........: NO.FUN-920033 09/05/19 BY hongmei 
#                                1.單身asb13 長期投資科目 在輸入後無控管
#                                2.開窗資料asb13時，應以單頭上層公司asa02所輸入agli009之plant所屬DB + agls101中aaz641合併財報帳別為條件 
#                                3.單身asb13 欄位名稱「長期投資科目」-->「合併財報長期投資科目」
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: NO.FUN-930131 09/08/18 By hongmei 帳別欄位不可輸入 
# Modify.........: No:FUN-950051 09/10/30 By lutingting單頭新增欄位asa09獨立會科合并
# Modify.........: NO.FUN-920093 09/11/06 by yiting  1.單身科目asb13 開窗改為q_m_aag2
#                                                    2.科目名稱要跨DB抓取aag02顯示
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A30122 10/08/19 By vealxu 取合併帳別資料庫改由s_aaz641_asg，s_get_aaz641_asg取合併帳別
# Modify.........: No.FUN-A90029 10/09/28 By vealxu 增加asa04/asa05/asa06 
# Modify.........: No.TQC-AA0140 10/10/28 By yinhy 查詢時,在單身的合併財報長期投資專案asb13開窗時,程式DOWN出
# Modify.........: NO.TQC-AB0296 10/11/29 BY suncx1 單身“投資股數、股本”輸入負數沒有控管；錄入時狀態頁簽的“資料所有者”等沒有默認值

# Modify.........: No.TQC-AC0192 10/12/15 By yinhy 更改單身資料時，沒有自動帶出相應"帳套"
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No:FUN-B50001 11/05/04 By zhangweib 增加asa07(分层合并否),asb06(持股比率)
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數檔改為asz_file
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60045 11/06/09 By yinhy aag02顯示錯誤
# Modify.........: No.TQC-B60046 11/06/09 By yinhy 單身asb06未INSERT到asb_file
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE                                       #FUN-BB0036
    g_asa           RECORD LIKE asa_file.*,
    g_asa_t         RECORD LIKE asa_file.*,
    g_asa_o         RECORD LIKE asa_file.*,
    g_asa01_t       LIKE asa_file.asa01,       #族群代號 (舊值)
    g_asa02_t       LIKE asa_file.asa02,       #上層公司 (舊值)
    g_asa03_t       LIKE asa_file.asa03,       #帳別編號 (舊值)
    g_asb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        asb04       LIKE asb_file.asb04,   #下層公司編號
        asg02b      LIKE asg_file.asg02,               #FUN-580063
        asb05       LIKE asb_file.asb05,   #帳別編號
        asb07       LIKE asb_file.asb07,   #持股比率
        asb06       LIKE asb_file.asb06,   #纳入合并否     #FUN-B50001 Add
        asb11       LIKE asb_file.asb11,   #投資股數   #FUN-580063
        asb12       LIKE asb_file.asb12,   #股本       #FUN-580063
        asb13       LIKE asb_file.asb13,   #長期投資科目     #No.FUN-7A0035 
        aag02       LIKE aag_file.aag02,   #會計科目     #No.FUN-7A0035 
        asb08       LIKE asb_file.asb08    #異動日期
                    END RECORD,
    g_asb_t         RECORD    #程式變數(Program Variables)
        asb04       LIKE asb_file.asb04,   #下層公司編號
        asg02b      LIKE asg_file.asg02,               #FUN-580063
        asb05       LIKE asb_file.asb05,   #帳別編號
        asb07       LIKE asb_file.asb07,   #持股比率
        asb06       LIKE asb_file.asb06,   #纳入合并否     #FUN-B50001 Add
        asb11       LIKE asb_file.asb11,   #投資股數   #FUN-580063
        asb12       LIKE asb_file.asb12,   #股本       #FUN-580063
        asb13       LIKE asb_file.asb13,   #長期投資科目     #No.FUN-7A0035 
        aag02       LIKE aag_file.aag02,   #會計科目     #No.FUN-7A0035 
        asb08       LIKE asb_file.asb08    #異動日期
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166     
    g_dbs_gl        LIKE type_file.chr21,                #No.FUN-680098   VARCHAR(21)
    g_rec_b         LIKE type_file.num5,               #單身筆數        #No.FUN-680098  smallint
    l_ac            LIKE type_file.num5,               #目前處理的ARRAY CNT   #No.FUN-680098 smallint
    g_asg03         LIKE asg_file.asg03,               #FUN-580063
    g_azp03         LIKE azp_file.azp03    #TQC-660043
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL     
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680098  smallint
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680098  integer
DEFINE g_i                   LIKE type_file.num5     #count/index for any purpose   #No.FUN-680098 smallint
DEFINE g_msg                 LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(72)
DEFINE g_row_count           LIKE type_file.num10          #No.FUN-680098 integer
DEFINE g_curs_index          LIKE type_file.num10          #No.FUN-680098 integer
DEFINE g_jump                LIKE type_file.num10          #No.FUN-680098 integer
DEFINE mi_no_ask             LIKE type_file.num5           #No.FUN-680098 smallint
DEFINE l_table        STRING,                                                   
       g_str          STRING,                                                   
       l_sql          STRING                                                    
#DEFINE g_aaz641       LIKE aaz_file.aaz641     #FUN-920033 add  #FUN-B50001
DEFINE g_asz01        LIKE asz_file.asz01      #FUN-B50001
DEFINE g_dbs_asg03    LIKE type_file.chr21     #FUN-920033 add
DEFINE g_plant_asg03  LIKE type_file.chr10     #No.FUN-980025 
DEFINE g_asg02        LIKE asg_file.asg02      #FUN-920033
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5                  #No.FUN-680098     smallint
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   
   LET g_sql = "asa01.asa_file.asa01,",
               "asa02.asa_file.asa02,",  
               "l_asg02.asg_file.asg02,",  
               "l_asg03.asg_file.asg03,",  
               "asa03.asa_file.asa03,",  
               "asb04.asb_file.asb04,", 
               "l_asg02b.asg_file.asg02,",
               "l_asg03b.asg_file.asg03,",
               "asb05.asb_file.asb05,",
               "asb07.asb_file.asb07,",
               "asb11.asb_file.asb11,",
               "asb12.asb_file.asb12,",
               "asb13.asb_file.asb13,",     #No.FUN-7A0035 
               "aag02.aag_file.aag02,",     #No.FUN-7A0035 
               "asb08.asb_file.asb08"
 
   LET l_table = cl_prt_temptable('ggli002',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                        
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,      #TQC-A40116 mod                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "       #No.FUN-7A0035 
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
                
   LET g_forupd_sql = "SELECT * FROM asa_file WHERE asa01 = ? AND asa02 = ? AND asa03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW i002_w AT p_row,p_col  #顯示畫面
     WITH FORM "ggl/42f/ggli002"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i002_menu()
 
   CLOSE WINDOW i002_w                    #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i002_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_asb.clear()
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_asa.* TO NULL    #No.FUN-750051
#  CONSTRUCT BY NAME g_wc ON asa01,asa02,asa03,asa09,asauser,asagrup,asamodu,asadate    #FUN-950051 add asa09   #FUN-A90029 makr
   CONSTRUCT BY NAME g_wc ON asa01,asa02,asa03,asa04,asa09,asa05,asa06,                 #FUN-A90029 add
                             asauser,asagrup,asamodu,asadate                            #FUN-A90029 add
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asa01) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.state = "c"                                                                                           
               LET g_qryparam.form ="q_asa1"                                                                                        
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO asa01                                                                                 
               NEXT FIELD asa01                                                                                                     
            WHEN INFIELD(asa02) #工廠編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_asg"      #FUN-580063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asa02
               NEXT FIELD asa02
            WHEN INFIELD(asa03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asa03
               NEXT FIELD asa03
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('asauser', 'asagrup')
 
 
   CONSTRUCT g_wc2 ON asb04,asb05,asb07,asb06,asb11,asb12,asb13,asb08      #螢幕上取單身條件     #No.FUN-7A0035    #FUN-B50001  Add asb06
                 FROM s_asb[1].asb04,s_asb[1].asb05,s_asb[1].asb07,s_asb[1].asb06,      #FUN-B50001   Add s_asb[1].asb06
                 s_asb[1].asb11,s_asb[1].asb12,s_asb[1].asb13,s_asb[1].asb08     #No.FUN-7A0035 
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asb04) #下層公司編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_asg"           #FUN-580063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asb04
               NEXT FIELD asb04
            WHEN INFIELD(asb05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asb05
               NEXT FIELD asb05
           WHEN INFIELD(asb13)
             # CALL q_m_aag(FALSE,TRUE,g_plant_asg03,g_asb[l_ac].asb13,'23',g_aaz641)   #No.FUN-980025  #No.TQC-AA0140 mark
             #     RETURNING g_asb[l_ac].asb13                                        #No.TQC-AA0140 mark
             # DISPLAY BY NAME g_asb[l_ac].asb13                                      #No.TQC-AA0140 mark 
              #CALL q_m_aag2(TRUE,TRUE,g_dbs_asg03,g_asb[1].asb13,'23',g_aaz641)      #No.TQC-AA0140 mod #FUN-B50001
              CALL q_m_aag2(TRUE,TRUE,g_dbs_asg03,g_asb[1].asb13,'23',g_asz01)      #No.FUN-B50001
                  RETURNING g_qryparam.multiret                                      #No.TQC-AA0140 mod
              DISPLAY g_qryparam.multiret TO asb13                                   #No.TQC-AA0140 mod
              NEXT FIELD asb13
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  asa01,asa02,asa03 FROM asa_file ",#TQC-870018
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY asa01,asa02,asa03"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT asa_file. asa01,asa02,asa03 ",#TQC-870018
                  "  FROM asa_file, asb_file ",
                  " WHERE asa01 = asb01 AND asa02=asb02 AND asa03=asb03 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY asa01,asa02,asa03"
   END IF
 
   PREPARE i002_prepare FROM g_sql
   DECLARE i002_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i002_prepare
 
   DROP TABLE x
   LET g_sql_tmp="SELECT DISTINCT asa01,asa02,asa03 ",  #No.TQC-720019
             " FROM asa_file WHERE ", g_wc CLIPPED,
             " INTO TEMP x "
   PREPARE i002_temp FROM g_sql_tmp   #No.TQC-720019
   EXECUTE i002_temp
 
   LET g_sql = "SELECT COUNT(*) FROM x "
   PREPARE i002_precount FROM g_sql
   DECLARE i002_count CURSOR FOR i002_precount
 
END FUNCTION
 
FUNCTION i002_menu()
 
   WHILE TRUE
      CALL i002_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i002_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i002_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i002_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i002_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i002_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i002_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_asa.asa01 IS NOT NULL THEN
                  LET g_doc.column1 = "asa01"
                  LET g_doc.value1 = g_asa.asa01
                  LET g_doc.column2 = "asa02"
                  LET g_doc.value2 = g_asa.asa02
                  LET g_doc.column3 = "asa03"
                  LET g_doc.value3 = g_asa.asa03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asb),'','')
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION i002_a()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_asb.clear()
   INITIALIZE g_asa.* LIKE asa_file.*             #DEFAULT 設定
   LET g_asa01_t = NULL
   LET g_asa02_t = NULL
   LET g_asa03_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_asa_o.* = g_asa.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_asa.asauser=g_user
      LET g_asa.asaoriu = g_user #FUN-980030
      LET g_asa.asaorig = g_grup #FUN-980030
      LET g_asa.asagrup=g_grup
      LET g_asa.asadate=g_today
      LET g_asa.asaacti='Y'              #資料有效
      LET g_asa.asa09 = 'N'              #獨立會科合并   #FUN-990051
      LET g_asa.asa09 = 'N'              #獨立會科合并
      LET g_asa.asa04 = 'N'              #FUN-A90029
      LET g_asa.asa05 = '1'              #FUN-A90029
      LET g_asa.asa06 = '1'              #FUN-A90029
      LET g_asa.asa07 = 'Y'              #No.FUN-B50001 Add
 
      CALL i002_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_asa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_asa.asa01)  THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      IF cl_null(g_asa.asa02)  THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      IF cl_null(g_asa.asa03)  THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO asa_file VALUES (g_asa.*)
      IF SQLCA.sqlcode THEN   			#置入資料庫不成功
         CALL cl_err3("ins","asa_file",g_asa.asa01,g_asa.asa02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
#FUN-A90029 ----------------------add start-----------------------------
     IF g_asa.asa04 = 'Y' THEN                                                 
         UPDATE asa_file SET asa09 = g_asa.asa09,                               
                             asa05 = g_asa.asa05,                               
                             asa06 = g_asa.asa06                                
         WHERE asa01 = g_asa.asa01                                              
           AND asa04 <> 'Y'                                                     
      END IF
#FUN-A90029 ---------------------add end-------------------------------- 

      SELECT asa01 INTO g_asa.asa01 FROM asa_file
       WHERE asa01 = g_asa.asa01
         AND asa02=g_asa.asa02
         AND asa03=g_asa.asa03
 
      LET g_asa01_t = g_asa.asa01        #保留舊值
      LET g_asa02_t = g_asa.asa02        #保留舊值
      LET g_asa03_t = g_asa.asa03        #保留舊值
      LET g_asa_t.* = g_asa.*
 
      CALL g_asb.clear()
      LET g_rec_b = 0
 
      CALL i002_b()                   #輸入單身
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i002_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_asa.asa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_asa.* FROM asa_file
    WHERE asa01=g_asa.asa01
      AND asa02=g_asa.asa02
      AND asa03=g_asa.asa03
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_asa01_t = g_asa.asa01
   LET g_asa02_t = g_asa.asa02
   LET g_asa03_t = g_asa.asa03
   LET g_asa_o.* = g_asa.*
   BEGIN WORK
 
   OPEN i002_cl USING g_asa.asa01,g_asa.asa02,g_asa.asa03
   IF STATUS THEN
      CALL cl_err("OPEN i002_cl:", STATUS, 1)   
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i002_cl INTO g_asa.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_asa.asa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i002_show()
 
   WHILE TRUE
      LET g_asa01_t = g_asa.asa01
      LET g_asa02_t = g_asa.asa02
      LET g_asa03_t = g_asa.asa03
      LET g_asa.asamodu=g_user
      LET g_asa.asadate=g_today
 
      CALL i002_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_asa.*=g_asa_t.*
         CALL i002_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_asa.asa01 != g_asa01_t OR        #更改key 值
         g_asa.asa02 != g_asa02_t OR
         g_asa.asa03 != g_asa03_t THEN
         UPDATE asb_file SET asb01 = g_asa.asa01,
                             asb02 = g_asa.asa02,
                             asb03 = g_asa.asa03
          WHERE asb01 = g_asa01_t
            AND asb02=g_asa02_t
            AND asb03=g_asa03_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","asb_file",g_asa01_t,g_asa02_t,SQLCA.sqlcode,"","asb",1)  #No.FUN-660123
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE asa_file SET asa_file.* = g_asa.*
      WHERE asa01 = g_asa01_t AND asa02 = g_asa02_t AND asa03 = g_asa03_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","asa_file",g_asa01_t,g_asa02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
#FUN-A90029 ------------------------add start--------------------------
     IF g_asa.asa04 = 'Y' THEN                                                 
         UPDATE asa_file SET asa09 = g_asa.asa09,                               
                             asa05 = g_asa.asa05,                               
                             asa06 = g_asa.asa06                                
         WHERE asa01 = g_asa.asa01                                              
           AND asa04 <> 'Y'                                                     
      END IF
#FUN-A90029 ------------------------add end-----------------------------
 
      EXIT WHILE
   END WHILE
 
   CLOSE i002_cl
   COMMIT WORK
 
END FUNCTION
 
#處理INPUT
FUNCTION i002_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,      #判斷必要欄位是否有輸入    #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,      #a:輸入 u:更改             #No.FUN-680098 VARCHAR(1)
   l_sql           STRING,                   #TQC-630166    
   l_n,p_cnt       LIKE type_file.num5,      #No.FUN-680098  smallint
   l_asb           RECORD LIKE asb_file.*   #MOD-790108
DEFINE 
   l_cnt           LIKE type_file.num5      #FUN-A90029 
 
   #DISPLAY BY NAME g_asa.asaoriu,g_asa.asaorig,g_asa.asauser,g_asa.asamodu,g_asa.asagrup,g_asa.asadate   #TQC-AB0296
   DISPLAY BY NAME g_asa.asauser,g_asa.asamodu,g_asa.asagrup,g_asa.asadate     #TQC-AB0296 modify
   CALL cl_set_head_visible("","YES")        #No.FUN-6B0029
 
#  INPUT BY NAME g_asa.asa01,g_asa.asa02,g_asa.asa03,g_asa.asa09 WITHOUT DEFAULTS   #FUN-950051 add asa09  #FUN-A90029 mark
#  INPUT BY NAME g_asa.asa01,g_asa.asa02,g_asa.asa03,g_asa.asa04,g_asa.asa09,       #FUN-A90029 add    #FUN-B50001 Mark
#                g_asa.asa05,g_asa.asa06 WITHOUT DEFAULTS                           #FUN-A90029 add    #FUN-B50001 Mark
   INPUT BY NAME g_asa.asa01,g_asa.asa02,g_asa.asa03,g_asa.asa04,g_asa.asa07,g_asa.asa09,      #FUN-B50001 Add
                 g_asa.asa05,g_asa.asa06 WITHOUT DEFAULTS                                      #FUN-B50001 Add
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i002_set_entry(p_cmd)
         CALL i002_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

#FUN-A90029 -----------------add start--------------------------
      AFTER FIELD asa01                                                         
         IF p_cmd = 'a' THEN                                                    
            LET g_asa.asa05='1'                                                 
            LET g_asa.asa06='2'                                                 
            LET g_asa.asa09='N'                                                 
         END IF                                                                 
                                                                                
         IF (p_cmd='a'                                                          
            OR (p_cmd='u' AND g_asa.asa01<>g_asa_t.asa01)) THEN                 
            SELECT asa05,asa06,asa09                                            
              INTO g_asa.asa05,g_asa.asa06,g_asa.asa09                          
              FROM asa_file                                                     
             WHERE asa01=g_asa.asa01                                            
               AND asa04='Y'                                                    
            END IF                                                              
         DISPLAY BY NAME g_asa.asa05,g_asa.asa06,g_asa.asa09
#FUN-A90029 ----------------add end-------------------------------
 
      AFTER FIELD asa02            #上層公司編號
         IF NOT cl_null(g_asa.asa02) THEN
            CALL i002_asa02('a')
            IF NOT cl_null(g_errno) THEN
               LET g_asa.asa02 = g_asa02_t
               CALL cl_err(g_asa.asa02,g_errno,0)
               NEXT FIELD asa02
            END IF
# FUN-590014 自動帶入帳別
            SELECT asg05 INTO g_asa.asa03
              FROM asg_file
             WHERE asg01 = g_asa.asa02
            IF cl_null(g_asa.asa03) THEN
               CALL cl_err(g_asa.asa02,'aco-025',0)
               NEXT FIELD asa02
            END IF
            DISPLAY g_asa.asa03 TO asa03
            CALL cl_set_comp_entry("asa03",FALSE)
            #增加上層公司+帳別的合理性判斷,應存在agli009
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM asg_file
             WHERE asg01=g_asa.asa02 AND asg05=g_asa.asa03
            IF l_n = 0 THEN
               CALL cl_err(g_asa.asa02,'agl-946',0)
               NEXT FIELD asa02
            END IF
         END IF
 
      AFTER FIELD asa03            #帳別
         IF NOT cl_null(g_asa.asa03) THEN
            IF g_asa.asa03 != g_asa03_t OR g_asa03_t IS NULL THEN
               CALL i002_asa03('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_asa.asa03 = g_asa03_t
                  CALL cl_err(g_asa.asa03,g_errno,0)
                  NEXT FIELD asa03
               END IF
            END IF
            #增加上層公司+帳別的合理性判斷,應存在agli009
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM asg_file
             WHERE asg01=g_asa.asa02 AND asg05=g_asa.asa03
            IF l_n = 0 THEN
               CALL cl_err(g_asa.asa03,'agl-946',0)
               NEXT FIELD asa03
            END IF
            IF (g_asa.asa01 != g_asa01_t) OR (g_asa01_t IS NULL) OR
               (g_asa.asa02 != g_asa02_t) OR (g_asa02_t IS NULL) OR
               (g_asa.asa03 != g_asa03_t) OR (g_asa03_t IS NULL) THEN
               SELECT count(*) INTO l_n FROM asa_file
                WHERE asa01=g_asa.asa01 AND asa02=g_asa.asa02
                  AND asa03=g_asa.asa03
               IF l_n > 0 THEN
                  CALL cl_err(g_asa.asa01,-239,0)
                  LET g_asa.asa01 = g_asa01_t
                  LET g_asa.asa02 = g_asa02_t
                  LET g_asa.asa03 = g_asa03_t
                  DISPLAY BY NAME g_asa.asa01,g_asa.asa02,g_asa.asa03
                  NEXT FIELD asa01
               END IF
            END IF
         END IF
 
#FUN-A90029 -------------------------add start--------------------------
      AFTER FIELD asa04                                                         
         IF g_asa.asa04 = 'Y' THEN                                              
            SELECT COUNT(*) INTO l_cnt FROM asa_file                            
             WHERE asa01=g_asa.asa01                                            
               AND (asa02<>g_asa.asa02                                          
                OR asa03<>g_asa.asa03)                                          
               AND asa04='Y'                                                    
            IF l_cnt>0 THEN                                                     
               CALL cl_err(g_asa.asa01,'agl-219',0)                             
               NEXT FIELD asa04                                                 
            END IF                                                              
         END IF                                                                 
         CALL i002_set_entry(p_cmd)                                             
         CALL i002_set_no_entry(p_cmd)
#FUN-A90029 -----------------------add end--------------------------------

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asa01) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_asa1"                                                                                        
               CALL cl_create_qry() RETURNING g_asa.asa01                                                                           
               DISPLAY BY NAME g_asa.asa01                                                                                          
               NEXT FIELD asa01                                                                                                     
            WHEN INFIELD(asa02) #工廠編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg"        #FUN-580063
               LET g_qryparam.default1 = g_asa.asa02
               CALL cl_create_qry() RETURNING g_asa.asa02
               DISPLAY BY NAME g_asa.asa02
               NEXT FIELD asa02
            WHEN INFIELD(asa03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa2"
               SELECT asg03 INTO g_asg03 FROM asg_file WHERE asg01=g_asa.asa02
               SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_asg03   #TQC-660043
               LET g_qryparam.arg1 = g_azp03
               LET g_qryparam.default1 = g_asa.asa03
               CALL cl_create_qry() RETURNING g_asa.asa03
               DISPLAY BY NAME g_asa.asa03
               NEXT FIELD asa03
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION i002_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("asa01,asa02",TRUE)        #FUN-930131 mod
   END IF
#FUN-A90029 ---------------add start--------------------------
   IF g_asa.asa04 = 'Y' THEN                                                    
      CALL cl_set_comp_entry("asa09,asa05,asa06",TRUE)                          
   END IF
#FUN-A90029 --------------add end----------------------------
 
END FUNCTION
 
FUNCTION i002_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("asa01,asa02",FALSE)        #FUN-930131 mod
   END IF
#FUN-A90029 -----------------------add start--------------------------
   IF g_asa.asa04 <> 'Y' THEN                                                   
      CALL cl_set_comp_entry("asa09,asa05,asa06",FALSE)                         
   END IF
#FUN-A90029 ----------------------add end------------------------------
 
END FUNCTION
 
FUNCTION  i002_asa02(p_cmd)   #FUN-580063 將本段中所有azp改成asg
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_asg02         LIKE asg_file.asg02,
       l_asg03         LIKE asg_file.asg03
 
   LET g_errno = ' '
 
   SELECT asg02, asg03 INTO l_asg02, l_asg03 FROM asg_file
    WHERE asg01 = g_asa.asa02
 
   CASE WHEN SQLCA.SQLCODE =100  LET g_errno = 'mfg9142'
                                 LET l_asg02 = NULL
                                 LET l_asg03 = NULL
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_asg02  TO FORMONLY.asg02
      DISPLAY l_asg03  TO FORMONLY.asg03
   END IF
   
  #FUN-A30122 --------------------mark start------------------------------
  #LET g_plant_new = l_asg03    #營運中心
  #LET g_plant_asg03 = l_asg03  #No.FUN-980025 add
  #CALL s_getdbs()
  #LET g_dbs_asg03 = g_dbs_new   
  #FUN-A30122 -------------------mark end---------------------------------
   
END FUNCTION
 
FUNCTION i002_asa03(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_aaa01         LIKE aaa_file.aaa01,
       l_sql           STRING         #TQC-630166     
 
    LET g_errno = ' '
    LET g_plant_new = g_asa.asa02
 
    CALL s_getdbs()
 
    LET g_dbs_gl = g_dbs_new
 
  # LET l_sql = "SELECT aaa01 FROM ",g_dbs_gl,                         #FUN-A30122 mark
    LET l_sql = "SELECT aaa01 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A30122 add 
  #             "aaa_file WHERE aaa01 = '",g_asa.asa03,"'"                         #FUN-A30122 mark
                " WHERE aaa01 = '",g_asa.asa03,"'"                                 #FUN-A30122 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A30122  
    PREPARE i002_preasa03 FROM l_sql
    DECLARE i002_curasa03 CURSOR FOR i002_preasa03
 
    OPEN i002_curasa03
    FETCH i002_curasa03 INTO l_aaa01
    IF SQLCA.sqlcode THEN
       LET g_errno = 'agl-095'
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION i002_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_asa.* TO NULL              #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_asb.clear()
 
   CALL i002_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_asa.* TO NULL
   ELSE
      CALL i002_fetch('F')            #讀出TEMP第一筆並顯示
      OPEN i002_count
      FETCH i002_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i002_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,        #處理方式        #No.FUN-680098 VARCHAR(1)
    l_abso          LIKE type_file.num10        #絕對的筆數      #No.FUN-680098 integer
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i002_cs INTO g_asa.asa01,
                                             g_asa.asa02,g_asa.asa03 #TQC-870018
                                             
        WHEN 'P' FETCH PREVIOUS i002_cs INTO g_asa.asa01,
                                             g_asa.asa02,g_asa.asa03 #TQC-870018
                                            
        WHEN 'F' FETCH FIRST    i002_cs INTO g_asa.asa01,
                                             g_asa.asa02,g_asa.asa03 #TQC-870018
                                             
        WHEN 'L' FETCH LAST     i002_cs INTO g_asa.asa01,
                                             g_asa.asa02,g_asa.asa03 #TQC-870018
                                            
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
            FETCH ABSOLUTE g_jump i002_cs INTO g_asa.asa01,
                                               g_asa.asa02,g_asa.asa03 #TQC-870018
                                               
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_asa.asa01,SQLCA.sqlcode,0)
       INITIALIZE g_asa.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_asa.* FROM asa_file WHERE asa01 = g_asa.asa01 AND asa02 = g_asa.asa02 AND asa03 = g_asa.asa03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","asa_file",g_asa.asa01,g_asa.asa02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_asa.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_asa.asauser     #No.FUN-4C0048
       LET g_data_group = g_asa.asagrup     #No.FUN-4C0048
       CALL i002_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i002_show()
 
   LET g_asa_t.* = g_asa.*                #保存單頭舊值
   DISPLAY BY NAME                              # 顯示單頭值
       g_asa.asa01,g_asa.asa02,g_asa.asa03,g_asa.asa09,    #FUN-950051 add  asa09
       g_asa.asauser,g_asa.asagrup,g_asa.asamodu,g_asa.asadate
      ,g_asa.asa04,g_asa.asa05,g_asa.asa06                 #FUN-A90029  
      ,g_asa.asa07                                         #FUN-B50001 Add

   CALL i002_asa02('d')

   CALL i002_b_fill(g_wc2)                 #單身

    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i002_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_asa.asa01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_asa.asaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_asa.asa01,9027,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i002_cl USING g_asa.asa01,g_asa.asa02,g_asa.asa03
   IF STATUS THEN
      CALL cl_err("OPEN i002_cl:", STATUS, 1)
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i002_cl INTO g_asa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_asa.asa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i002_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "asa01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_asa.asa01      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "asa02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_asa.asa02      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "asa03"         #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_asa.asa03      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM asa_file
       WHERE asa01 = g_asa.asa01
         AND asa02=g_asa.asa02
         AND asa03=g_asa.asa03
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","asa_file",g_asa.asa01,g_asa.asa02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      END IF
 
      DELETE FROM asb_file
       WHERE asb01 = g_asa.asa01
         AND asb02=g_asa.asa02
         AND asb03=g_asa.asa03
 
      CLEAR FORM
      CALL g_asb.clear()
      CALL g_asb.clear()
 
      DROP TABLE x                        #No.TQC-720019
      PREPARE i002_pre_y2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i002_pre_y2                 #No.TQC-720019
      OPEN i002_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i002_cs
         CLOSE i002_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end-- 
      FETCH i002_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i002_cs
         CLOSE i002_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN i002_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i002_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i002_fetch('/')
      END IF
   END IF
 
   CLOSE i002_cl
   COMMIT WORK
 
END FUNCTION
 
#單身
FUNCTION i002_b()
DEFINE
   l_ac_t          LIKE type_file.num5,               #未取消的ARRAY CNT         #No.FUN-680098 smallint
   p_key           LIKE type_file.chr1,               #為確定是在新增或更新狀態, #No.FUN-680098 VARCHAR(1)
   l_n,p_cnt       LIKE type_file.num5,               #檢查重複用                #No.FUN-680098 smallint
   l_sql           STRING,                #TQC-630166    
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否         #No.FUN-680098 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態           #No.FUN-680098 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                 #可新增否           #No.FUN-680098 smallint
   l_allow_delete  LIKE type_file.num5,                 #可刪除否           #No.FUN-680098 smallint
   l_asg04         LIKE asg_file.asg04    #使用tiptop否   #FUN-580063
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_asa.asa01) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
   
   CALL s_aaz641_asg(g_asa.asa01,g_asa.asa02) RETURNING g_plant_asg03  #FUN-A30122
   #CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_aaz641                 #FUN-A30122  #FUN-B50001
   CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asz01    #FUN-B50001
  
  #FUN-A30122 ---------------------mark start--------------------------------- 
  #IF g_asa.asa09 = 'Y' THEN  #FUN-950051
  #   SELECT asg02, asg03 INTO g_asg02,g_asg03 FROM asg_file
  #    WHERE asg01 = g_asa.asa02
  #   LET g_plant_new = g_asg03  #營運中心
  #   LET g_plant_asg03 = g_asg03  #營運中心 #No.FUN-980025 add
  #   CALL s_getdbs()
  #   LET g_dbs_asg03 = g_dbs_new   
  #  #LET l_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",  #FUN-A50102
  #   LET l_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_asg03,'aaz_file'),   #FUN-A50102
  #               " WHERE aaz00 = '0'"
  #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
  #   CALL cl_parse_qry_sql(l_sql,g_plant_asg03) RETURNING l_sql   #FUN-A50102
  #   PREPARE i002_preasa06 FROM l_sql
  #   DECLARE i002_curasa06 CURSOR FOR i002_preasa06
  #   OPEN i002_curasa06
  #   FETCH i002_curasa06 INTO g_aaz641
  #   IF cl_null(g_aaz641) THEN
  #       CALL cl_err(g_asg03,'agl-601',0)
  #   END IF
  #ELSE
  #   LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
  #   SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
  #END IF 
  #FUN-A30122 ------------------------------mark end---------------------------------

#  LET g_forupd_sql = "SELECT asb04,'',asb05,asb07,asb11,asb12,asb13,'',asb08 FROM asb_file ",  #FUN-580063     #No.FUN-7A0035  #FUN-B50001  Mark
   LET g_forupd_sql = "SELECT asb04,'',asb05,asb07,asb06,asb11,asb12,asb13,'',asb08 FROM asb_file ",                            #FUN-B50001  Add
                      "  WHERE asb01= ? AND asb02= ? AND asb03= ? AND asb04= ? ",
                      "   AND asb05= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_asb WITHOUT DEFAULTS FROM s_asb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN i002_cl USING g_asa.asa01,g_asa.asa02,g_asa.asa03
         IF STATUS THEN
            CALL cl_err("OPEN i002_cl:", STATUS, 1)
            CLOSE i002_cl
            ROLLBACK WORK
            RETURN
         ELSE
            FETCH i002_cl INTO g_asa.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_asa.asa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i002_cl
               ROLLBACK WORK
               RETURN
            END IF
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_asb_t.* = g_asb[l_ac].*  #BACKUP
            OPEN i002_bcl USING g_asa.asa01,g_asa.asa02,
                                g_asa.asa03,g_asb_t.asb04,g_asb_t.asb05
            IF STATUS THEN
               CALL cl_err("OPEN i002_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i002_bcl INTO g_asb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_asb_t.asb04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         IF l_ac <= l_n THEN            #DISPLAY NEWEST
            CALL i002_asb04('d')
           #LET g_sql = "SELECT aag02 FROM ",g_dbs_asg03,"aag_file",
            LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_asg03,'aag_file'),   #FUN-A50102 
                         " WHERE aag01 = '",g_asb[l_ac].asb13,"'", 
                         #"   AND aag00 = '",g_aaz641,"'"   #FUN-B50001 
                         "   AND aag00 = '",g_asz01,"'" 
	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_asg03) RETURNING g_sql   #FUN-A50102
             PREPARE i002_pre_2 FROM g_sql
             DECLARE i002_cur_2 CURSOR FOR i002_pre_2
             OPEN i002_cur_2
             FETCH i002_cur_2 INTO g_asb[l_ac].aag02
 
             IF SQLCA.sqlcode  THEN LET g_asb[l_ac].aag02 = '' END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_asb[l_ac].* TO NULL         #900423
         INITIALIZE g_asb_t.* TO NULL             #900423
         LET g_asb[l_ac].asb06 = 'Y'     #FUN-B50001 Add
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD asb04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO asb_file(asb01,asb02,asb03,asb04,asb05,asb06,asb07,asb11,asb12,asb13,asb08)     #No.FUN-7A0035  #No.B60046 add asb06
                       VALUES(g_asa.asa01,g_asa.asa02,g_asa.asa03,
                              g_asb[l_ac].asb04,g_asb[l_ac].asb05,
                              g_asb[l_ac].asb06,                       #No.TQC-B60046
                              g_asb[l_ac].asb07,g_asb[l_ac].asb11,
                              g_asb[l_ac].asb12,g_asb[l_ac].asb13,     #No.FUN-7A0035 
                              g_asb[l_ac].asb08)
 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","asb_file",g_asa.asa01,g_asb[l_ac].asb04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD asb04    #下層公司
         IF NOT cl_null(g_asb[l_ac].asb04) THEN            
            #TQC-AC0192   --Beatk 
            #CALL i002_asb04('a')
            #IF NOT cl_null(g_errno) THEN
            #   CALL cl_err(g_asb[l_ac].asb04,g_errno,0)   #TQC-740291 add
            #   LET g_asb[l_ac].asb04 = g_asb_t.asb04
            #   NEXT FIELD asb04
            #END IF
            #TQC-AC0192   --End
# FUN-590014 自動帶入帳別
            SELECT asg05 INTO g_asb[l_ac].asb05
              FROM asg_file
             WHERE asg01 = g_asb[l_ac].asb04
            IF cl_null(g_asb[l_ac].asb05) THEN
               CALL cl_err(g_asb[l_ac].asb04,'aco-025',0)
               NEXT FIELD asb04
            END IF
            DISPLAY g_asb[l_ac].asb05 TO asb05
            CALL cl_set_comp_entry("asb05",FALSE)
            #TQC-AC0192   --Beatk 
            CALL i002_asb04('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asb[l_ac].asb04,g_errno,0)   #TQC-740291 add
               LET g_asb[l_ac].asb04 = g_asb_t.asb04
               NEXT FIELD asb04
            END IF
            #TQC-AC0192   --End
            #-----MOD-790108---------
            IF g_asb[l_ac].asb04 = g_asa.asa02 AND 
               g_asb[l_ac].asb05 = g_asa.asa03 THEN
               CALL cl_err(g_asb[l_ac].asb04,'agl-152',1)
               NEXT FIELD asb04
            END IF
            #檢查輸入的下層公司資料是否與單頭公司相同
            IF g_asb[l_ac].asb04 = g_asa.asa02 THEN
               CALL cl_err(g_asb[l_ac].asb04,'agl-947',0)
               NEXT FIELD asb04
            END IF
         END IF
 
      AFTER FIELD asb05
         SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01=g_asb[l_ac].asb04
         IF l_asg04='Y' THEN
            IF NOT cl_null(g_asb[l_ac].asb05) THEN
               IF g_asb[l_ac].asb04 = g_asa.asa02 AND
                  g_asb[l_ac].asb05 = g_asa.asa03 THEN
                  CALL cl_err(g_asb[l_ac].asb05,'agl-116',0)
                  NEXT FIELD asb04
               END IF
               #增加下層公司+帳別的合理性判斷,應存在agli009
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM asg_file
                WHERE asg01=g_asb[l_ac].asb04 AND asg05=g_asb[l_ac].asb05
               IF l_n = 0 THEN
                  CALL cl_err(g_asb[l_ac].asb04,'agl-946',0)
                  NEXT FIELD asb04
               END IF
               IF g_asb[l_ac].asb05 != g_asb_t.asb05 OR g_asb_t.asb05 IS NULL THEN
                  CALL i002_asb05('a')
                  IF NOT cl_null(g_errno) THEN
                     LET g_asb[l_ac].asb05 = g_asb_t.asb05
                     CALL cl_err(g_asb[l_ac].asb05,g_errno,0)
                     NEXT FIELD asb05
                  END IF
               END IF
               IF g_asb[l_ac].asb04 != g_asb_t.asb04 OR g_asb_t.asb04 IS NULL OR
                  g_asb[l_ac].asb05 != g_asb_t.asb05 OR g_asb_t.asb05 IS NULL THEN
                  SELECT count(*) INTO l_n FROM asb_file
                   WHERE asb01 = g_asa.asa01 AND asb02 = g_asa.asa02
                     AND asb03 = g_asa.asa03 AND asb04 = g_asb[l_ac].asb04
                     AND asb05 = g_asb[l_ac].asb05
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_asb[l_ac].asb04 = g_asb_t.asb04
                     LET g_asb[l_ac].asb05 = g_asb_t.asb05
                     NEXT FIELD asb05
                  END IF
               END IF
            END IF
         END IF    #FUN-580063
 
      AFTER FIELD asb07                 #折扣比率
         IF NOT cl_null(g_asb[l_ac].asb07) THEN
            IF g_asb[l_ac].asb07 < 0 OR g_asb[l_ac].asb07 > 100 THEN
              CALL cl_err(g_asb[l_ac].asb07,'mfg0013',0)
              LET g_asb[l_ac].asb07 = g_asb_t.asb07
              NEXT FIELD asb07
            END IF
         END IF

      #TQC-AB0296 modify---beatk-------------------------
      AFTER FIELD asb11
         IF NOT cl_null(g_asb[l_ac].asb11) THEN
            IF g_asb[l_ac].asb11 < 0 THEN
               CALL cl_err(g_asb[l_ac].asb11,'apj-035',0)
              LET g_asb[l_ac].asb11 = g_asb_t.asb11
              NEXT FIELD asb11
            END IF
         END IF

      AFTER FIELD asb12
         IF NOT cl_null(g_asb[l_ac].asb12) THEN
            IF g_asb[l_ac].asb12 < 0 THEN
               CALL cl_err(g_asb[l_ac].asb12,'apj-035',0)
              LET g_asb[l_ac].asb12 = g_asb_t.asb12
              NEXT FIELD asb12
            END IF
         END IF
      #TQC-AB0296 modify----end-------------------------- 

     AFTER FIELD asb13
       #FUN-A30122 ------------------------mark start----------------------------------- 
       ##--FUN-920033 start 一併取出此PLANT中agls101所設定合併報表帳別---
       ##LET l_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",   #FUN-A50102
       # LET l_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_asg03,'aaz_file'),   #FUN-A50102
       #             " WHERE aaz00 = '0'"
#       CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
       # CALL cl_parse_qry_sql(l_sql,g_plant_asg03) RETURNING l_sql     #FUN-A50102
       # PREPARE i002_preasa04 FROM l_sql
       # DECLARE i002_curasa04 CURSOR FOR i002_preasa04
       # OPEN i002_curasa04
       # FETCH i002_curasa04 INTO g_aaz641
       # IF cl_null(g_aaz641) THEN
       #     SELECT asg03 INTO g_asg03 FROM asg_file WHERE asg01=g_asa.asa02
       #     CALL cl_err(g_asg03,'agl-601',0)
       #     NEXT FIELD asb13
       # END IF
       ##FUN-A50102--mod--str--
       #FUN-A30122 --------------------------------mark end---------------------------------------       

        #LET l_sql = "SELECT COUNT(*) FROM ",g_dbs_asg03,
        #            "aag_file WHERE aag00 = '",g_aaz641,"'",
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_asg03,'aag_file'),
                     #" WHERE aag00 = '",g_aaz641,"'",   #FUN-B50001
                     " WHERE aag00 = '",g_asz01,"'",
        #FUN-A50102--mod--end
                     "  AND aag01 = '",g_asb[l_ac].asb13,"'"
	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_asg03) RETURNING l_sql     #FUN-A50102
         PREPARE i002_preasa05 FROM l_sql
         DECLARE i002_curasa05 CURSOR FOR i002_preasa05
         OPEN i002_curasa05
         FETCH i002_curasa05 INTO l_n
         IF l_n=0 THEN
            CALL cl_err(g_asb[l_ac].asb13,'aap-021',0)
            #FUN-B20004--beatk
            #CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asb[l_ac].asb13,'23',g_aaz641) #FUN-B50001 
            CALL q_m_aag2(FALSE,FALSE,g_plant_asg03,g_asb[l_ac].asb13,'23',g_asz01) 
                 RETURNING g_asb[l_ac].asb13
            #FUN-B20004--end
            #LET g_asb[l_ac].asb13 = g_asb_t.asb13
            NEXT FIELD asb13
         ELSE
            #LET g_sql = "SELECT aag02 FROM ",g_dbs_asg03,"aag_file",  #FUN-A50102
             LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_asg03,'aag_file'),   #FUN-A50102
                         " WHERE aag01 = '",g_asb[l_ac].asb13,"'",                
                         #"   AND aag00 = '",g_aaz641,"'" #FUN-B50001               
                         "   AND aag00 = '",g_asz01,"'"                
	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_asg03) RETURNING g_sql  #FUN-A50102
             PREPARE i002_pre_3 FROM g_sql
             DECLARE i002_cur_3 CURSOR FOR i002_pre_3
             OPEN i002_cur_3
             FETCH i002_cur_3 INTO g_asb[l_ac].aag02 
             IF SQLCA.sqlcode  THEN LET g_asb[l_ac].aag02 = '' END IF
             DISPLAY BY NAME g_asb[l_ac].aag02
         END IF
      
        SELECT aag02 INTO g_asb[l_ac].aag02 FROM aag_file
         WHERE aag01 = g_asb[l_ac].asb13
           AND aag01 = g_asz01       #No.TQC-B60045
 
      BEFORE DELETE                            #是否取消單身
         IF (g_asb_t.asb04 > 0 OR  g_asb_t.asb04 IS NOT NULL ) AND
            g_asb_t.asb05 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM asb_file
             WHERE asb01 = g_asa.asa01
               AND asb02=g_asa.asa02
               AND asb03 = g_asa.asa03
               AND asb04 = g_asb_t.asb04
               AND asb05 = g_asb_t.asb05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","asb_file",g_asa.asa01,g_asb_t.asb04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_asb[l_ac].* = g_asb_t.*
            CLOSE i002_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_asb[l_ac].asb04,-263,1)
            LET g_asb[l_ac].* = g_asb_t.*
         ELSE
            UPDATE asb_file SET asb04=g_asb[l_ac].asb04,
                                asb05=g_asb[l_ac].asb05,
                                asb06=g_asb[l_ac].asb06,   #FUN-B50001  Add
                                asb07=g_asb[l_ac].asb07,
                                asb11=g_asb[l_ac].asb11,   #FUN-580063
                                asb12=g_asb[l_ac].asb12,   #FUN-580063
                                asb13=g_asb[l_ac].asb13,     #No.FUN-7A0035 
                                asb08=g_asb[l_ac].asb08
             WHERE asb01=g_asa.asa01
               AND asb02=g_asa.asa02
               AND asb03=g_asa.asa03
               AND asb04=g_asb_t.asb04
               AND asb05=g_asb_t.asb05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","asb_file",g_asa.asa01,g_asb_t.asb04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_asb[l_ac].* = g_asb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_asb[l_ac].* = g_asb_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_asb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i002_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032 Add
         CLOSE i002_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(asb04) AND l_ac > 1 THEN
            LET g_asb[l_ac].* = g_asb[l_ac-1].*
            NEXT FIELD asb04
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asb04) #下層公司編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg"    #FUN-580063
               LET g_qryparam.default1 = g_asb[l_ac].asb04
               CALL cl_create_qry() RETURNING g_asb[l_ac].asb04
                DISPLAY BY NAME g_asb[l_ac].asb04         #No.MOD-490344
               NEXT FIELD asb04
             WHEN INFIELD(asb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa2"
                SELECT asg03 INTO g_asg03 FROM asg_file WHERE asg01=g_asb[l_ac].asb04
                SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_asg03   #TQC-660043
                LET g_qryparam.arg1 = g_azp03
                LET g_qryparam.default1 = g_asb[l_ac].asb05
                CALL cl_create_qry() RETURNING g_asb[l_ac].asb05
                DISPLAY BY NAME g_asb[l_ac].asb05         #No.MOD-490344
                NEXT FIELD asb05
           WHEN INFIELD(asb13)
              #CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asb[l_ac].asb13,'23',g_aaz641) #No.FUN-980025 #FUN-B50001
              CALL q_m_aag2(FALSE,TRUE,g_plant_asg03,g_asb[l_ac].asb13,'23',g_asz01) 
                  RETURNING g_asb[l_ac].asb13
              DISPLAY BY NAME g_asb[l_ac].asb13 
              NEXT FIELD asb13
            OTHERWISE EXIT CASE
         END CASE
 
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END INPUT
 
   UPDATE asa_file SET asamodu = g_user,
                       asadate = g_today
    WHERE asa01=g_asa.asa01
      AND asa02=g_asa.asa02
      AND asa03=g_asa.asa03
 
   CLOSE i002_bcl
   COMMIT WORK
   CALL i002_delall()   #CHI-740039 add
 
END FUNCTION
 
#檢查工廠編號
FUNCTION i002_asb04(p_cmd)   #FUN-580063 將本段中所有的azp改成asg
 
DEFINE p_cmd           LIKE type_file.chr1,      #No.FUN-680098 VARCHAR(1)
       l_asg03         LIKE asg_file.asg03
 
   LET g_errno = ' '
   IF cl_null(g_asb[l_ac].asb05) THEN   #TQC-740291 add
     SELECT asg02, asg03 INTO g_asb[l_ac].asg02b,l_asg03 FROM asg_file
      WHERE asg01 = g_asb[l_ac].asb04
   ELSE
     SELECT asg02, asg03 INTO g_asb[l_ac].asg02b,l_asg03 FROM asg_file
      WHERE asg01 = g_asb[l_ac].asb04
        AND asg05 = g_asb[l_ac].asb05
   END IF
  
 
   CASE WHEN SQLCA.SQLCODE =100 
                     IF cl_null(g_asb[l_ac].asb05) THEN
                        LET g_errno = 'mfg9142'
                     ELSE
                        LET g_errno = 'agl-946'
                     END IF   
                     LET g_asb[l_ac].asg02b = NULL
                     LET l_asg03 = NULL
        OTHERWISE    LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i002_asb05(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_aaa01         LIKE aaa_file.aaa01,
       l_sql           STRING        #TQC-630166 
 
   LET g_errno = ' '
   LET g_plant_new = g_asb[l_ac].asb04
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
 
 # LET l_sql = "SELECT aaa01 FROM ",g_dbs_gl,                                     #FUN-A30122 mark
 #             "aaa_file WHERE aaa01 = '",g_asb[l_ac].asb05,"'"                   #FUN-A30122 mark
   LET l_sql = "SELECT aaa01 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A30122 add     
               " WHERE aaa01 = '",g_asb[l_ac].asb05,"'"                           #FUN-A30122 add      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql                        #FUN-A30122 add  
   PREPARE i002_preasb05 FROM l_sql
   DECLARE i002_curasb05 CURSOR FOR i002_preasb05
 
   OPEN i002_curasb05
   FETCH i002_curasb05 INTO l_aaa01
   IF SQLCA.sqlcode THEN
      LET g_errno = 'agl-095'
   END IF
 
END FUNCTION
 
FUNCTION i002_b_askkey()
DEFINE
    l_wc2           STRING        #TQC-630166    
 
   CLEAR FORM                            #清除FORMONLY欄位
   CALL g_asb.clear()
   CALL g_asb.clear()
 
   CONSTRUCT l_wc2 ON asb04,asb05,asb07,asb11,asb12,asb13,asb08   # 螢幕上取單身條件     #No.FUN-7A0035 
                 FROM s_asb[1].asb04,s_asb[1].asb05,s_asb[1].asb07,
                      s_asb[1].asb11,s_asb[1].asb12,s_asb[1].asb13,s_asb[1].asb08     #No.FUN-7A0035 
      ON IDLE g_idle_seconds
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
 
   CALL i002_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i002_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           STRING        #TQC-630166        
 
#  LET g_sql = "SELECT asb04,'',asb05,asb07,asb11,asb12,asb13,'',asb08",  #FUN-580063     #No.FUN-7A0035 #FUN-B50001 Mark
   LET g_sql = "SELECT asb04,'',asb05,asb07,asb06,asb11,asb12,asb13,'',asb08",                            #FUN-B50001 Add
               " FROM asb_file",
               " WHERE asb01 ='",g_asa.asa01,"' AND asb02='",g_asa.asa02,"' ",  #單頭
               "   AND asb03 ='",g_asa.asa03,"' AND ",p_wc2 CLIPPED, #單身
               " ORDER BY asb04,asb05"
   PREPARE i002_pb FROM g_sql
   DECLARE asb_curs CURSOR FOR i002_pb
 
   CALL g_asb.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH asb_curs INTO g_asb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT asg02 INTO g_asb[g_cnt].asg02b FROM  asg_file
       WHERE asg01 = g_asb[g_cnt].asb04
      IF SQLCA.sqlcode THEN
         LET g_asb[g_cnt].asg02b = ' '
      END IF
 
     #FUN-A30122 ---------------------------mark start-------------------------
     #IF g_asa.asa09 = 'Y' THEN   #FUN-950051
     #   LET g_asg03=''
     #   SELECT asg03 INTO g_asg03    
     #     FROM asg_file
     #    WHERE asg01 = g_asa.asa02     #上層公司
     #   
     #   LET g_plant_new = g_asg03      #營運中心
     #   CALL s_getdbs()
     #   LET g_dbs_asg03 = g_dbs_new    #所屬DB
     # 
     #  #LET g_sql = "SELECT aaz641 FROM ",g_dbs_asg03,"aaz_file",   #FUN-A50102
     #   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_asg03,'aaz_file'),   #FUN-A50102 
     #               " WHERE aaz00 = '0'"
#CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
#        CALL cl_parse_qry_sql(g_sql,g_asg03) RETURNING g_sql #FUN-A50102
#        PREPARE i002_pre FROM g_sql
#        DECLARE i002_cur CURSOR FOR i002_pre
#        OPEN i002_cur
#        FETCH i002_cur INTO g_aaz641     #合併後帳別
#        IF cl_null(g_aaz641) THEN
#            CALL cl_err(g_asg03,'agl-601',1)
#        END IF
#FUN-A30122 --------------------------mark end-------------------------------------    
         CALL s_aaz641_asg(g_asa.asa01,g_asa.asa02) RETURNING g_plant_asg03  #FUN-A30122 add
         #CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_aaz641                 #FUN-A30122 add #FUN-B50001
         CALL s_get_aaz641_asg(g_plant_asg03) RETURNING g_asz01

        #LET g_sql = "SELECT aag02 FROM ",g_dbs_asg03,"aag_file",  #FUN-A50102
        #LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_asg03,'aag_file'),   #FUN-A50102   #FUN-A30122 mark
         LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_asg03,'aag_file'), #FUN-A30122 add
                     " WHERE aag01 = '",g_asb[g_cnt].asb13,"'",                
                     #"   AND aag00 = '",g_aaz641,"'"  #FUN-B50001               
                     "   AND aag00 = '",g_asz01,"'"                
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      #  CALL cl_parse_qry_sql(g_sql,g_asg03) RETURNING g_sql   #FUN-A50102   #FUN-A30122 mark
         CALL cl_parse_qry_sql(g_sql,g_plant_asg03) RETURNING g_sql           #FUN-A30122
         PREPARE i002_pre_1 FROM g_sql
         DECLARE i002_cur_1 CURSOR FOR i002_pre_1
         OPEN i002_cur_1
         FETCH i002_cur_1 INTO g_asb[g_cnt].aag02 

         IF SQLCA.sqlcode  THEN LET g_asb[g_cnt].aag02 = '' END IF
#FUN-A30122--------------------------mark start-------------------------------
#     ELSE
#        LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
#        SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
#        SELECT aag02 INTO g_asb[g_cnt].aag02 FROM aag_file
#         WHERE aag01 = g_asb[g_cnt].asb13
#           AND aag00 = g_aaz641
#     END IF 
#FUN-A30122 ---------------------------mark end-------------------------------

      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_asb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i002_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_asb TO s_asb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i002_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i002_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i002_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i002_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i002_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0010
         LET g_action_choice = 'exporttoexcel'
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
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i002_delall()  # 未輸入單身資料, 是否取消單頭資料
   SELECT COUNT(*) INTO g_cnt FROM asb_file
    WHERE asb01=g_asa.asa01 AND asb02=g_asa.asa02 AND asb03=g_asa.asa03
   IF g_cnt = 0 THEN
      IF cl_confirm('9042') THEN   #未輸入單身資料,是否取消單頭資料(Y/N)?
         DELETE FROM asa_file
          WHERE asa01=g_asa.asa01 AND asa02=g_asa.asa02 AND asa03=g_asa.asa03
      END IF
   END IF
END FUNCTION
 
FUNCTION i002_out()
DEFINE l_i             LIKE type_file.num5,         #No.FUN-680098  smallint
       l_name          LIKE type_file.chr20,        #External(Disk) file name        #No.FUN-680098 VARCHAR(20)
       l_msg           LIKE type_file.chr1000,      #No.FUN-680098 VARCHAR(22)
       sr              RECORD
           asa01       LIKE asa_file.asa01,   #族群代號
           asa02       LIKE asa_file.asa02,   #上層公司編號
           asa03       LIKE asa_file.asa03,   #帳別
           asb04       LIKE asb_file.asb04,   #下層公司編號
           asb05       LIKE asb_file.asb05,   #帳別
           asb07       LIKE asb_file.asb07,   #持股比率
           asb11       LIKE asb_file.asb11,   #投資股數   #FUN-580063
           asb12       LIKE asb_file.asb12,   #股本       #FUN-580063
           asb13       LIKE asb_file.asb13,   #長期投資科目     #No.FUN-7A0035 
           asb08       LIKE asb_file.asb08    #異動日
                       END RECORD
   DEFINE l_aag02      LIKE aag_file.aag02    #No.MOD-7B0223
DEFINE l_asg02,l_asg02b   LIKE asg_file.asg02                                                                   
DEFINE l_asg03,l_asg03b   LIKE asg_file.asg03  
   IF cl_null(g_wc) THEN CALL cl_err('','9057',0) RETURN END IF
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085
   LET g_sql="SELECT asa01,asa02,asa03,",
             " asb04,asb05,asb07,asb11,asb12,asb13,asb08 ",    #FUN-580063     #No.FUN-7A0035  
             " FROM asa_file,asb_file",               
             " WHERE asb01 = asa01 AND asa02=asb02 AND asb03=asa03 ",
             "  AND ",g_wc CLIPPED,
             "  AND ",g_wc2 CLIPPED
 
   PREPARE i002_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i002_co CURSOR FOR i002_p1
 
   CALL cl_del_data(l_table)                 #No.FUN-760085
   FOREACH i002_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
      END IF
      SELECT asg02,asg03 INTO l_asg02,l_asg03 FROM asg_file                                                                      
        WHERE asg01 = sr.asa02                                                                                                    
        IF SQLCA.sqlcode THEN LET l_asg02 = ' ' LET l_asg03= ' ' END IF 
      SELECT asg02,asg03 INTO l_asg02b,l_asg03b FROM asg_file                                                                    
        WHERE asg01 = sr.asb04                                                                                                    
        IF SQLCA.sqlcode THEN LET l_asg02b = ' ' LET l_asg03b= ' ' END IF 
      SELECT aag02 INTO l_aag02 FROM aag_file     #No.MOD-7B0223                                                               
          WHERE aag01 = sr.asb13                  #No.MOD-7B0223
            AND aag00 = g_asz01                   #No.TQC-B60045 
      EXECUTE insert_prep USING sr.asa01,sr.asa02,l_asg02,l_asg03,
                                sr.asa03,sr.asb04,l_asg02b,
                                l_asg03b,sr.asb05,sr.asb07,sr.asb11,sr.asb12,
                                sr.asb13,l_aag02,sr.asb08      #No.FUN-7A0035    #No.MOD-7B0223
   END FOREACH
 
 
   CLOSE i002_co
   ERROR ""
   IF g_zz05 = 'Y' THEN                                                       
      CALL cl_wcchp(g_wc,'asa01,asa02,asa03')                                
        RETURNING g_str                                                       
   END IF
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED         
   CALL cl_prt_cs3('ggli002','ggli002',l_sql,g_str)                           
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
