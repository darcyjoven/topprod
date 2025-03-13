# Prog. Version..: '5.25.02-11.11.22(00010)'     #
#
# Pattern name...: agli002.4gl
# Descriptions...: 聯屬公司層級維護作業
# Date & Author..: 01/09/17   BY Debbie Hsu
# Modify.........: No.MOD-490344 04/09/20 By Kitty Controlp 未加display
# Modify.........: No.MOD-490442 04/10/04 By Nicola 依工廠別開窗開不同帳別資料
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0010 04/11/02 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0048 04/12/08 By Nicola 權限控管修改
# Modify.........: No.FUN-510007 05/01/20 By Nicola 報表架構修改
# Modify.........: No.FUN-580063 05/08/12 By Sarah 1.azp02改成axz02,azp03改成axz03
#                                                  2.單身增加維護欄位: axb11, axb12,放在axb07後面
#                                                  3.單身子公司若不使用TIPTOP(axz04='N'), 則不check帳別的正確性
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
# Modify.........: No.FUN-7A0035 07/10/17 By Nicola 新增欄位長期投資科目(axb13)
# Modify.........: No.MOD-7B0223 07/11/27 By Lutingting EXECUTE 增加aag02       
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.MOD-910118 09/01/14 By Sarah 當公司階層有多階,例A-B-C,建立A-B時成功,但建立B-C時會出現agl-152訊息
# Modify.........: No.MOD-930093 09/03/10 By lilingyu 更改刪除狀態離開時,行數算錯的問題
# Modify.........: No.FUN-910001 09/05/18 By lutingting 由11區追單,axa01(群組代號)增加開窗功能  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-920110 09/05/20 BY hongmei BEFORE ROW抓取aag02要跨db 
# Modify.........: NO.FUN-920033 09/05/19 BY hongmei 
#                                1.單身axb13 長期投資科目 在輸入後無控管
#                                2.開窗資料axb13時，應以單頭上層公司axa02所輸入agli009之plant所屬DB + agls101中aaz641合併財報帳別為條件 
#                                3.單身axb13 欄位名稱「長期投資科目」-->「合併財報長期投資科目」
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: NO.FUN-930131 09/08/18 By hongmei 帳別欄位不可輸入 
# Modify.........: No:FUN-950051 09/10/30 By lutingting單頭新增欄位axa09獨立會科合并
# Modify.........: NO.FUN-920093 09/11/06 by yiting  1.單身科目axb13 開窗改為q_m_aag2
#                                                    2.科目名稱要跨DB抓取aag02顯示
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: NO.TQC-A40116 10/04/26 BY liuxqa modify sql
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A30122 10/08/19 By vealxu 取合併帳別資料庫改由s_aaz641_dbs，s_get_aaz641取合併帳別
# Modify.........: No.FUN-A90029 10/09/28 By vealxu 增加axa04/axa05/axa06 
# Modify.........: No.TQC-AA0140 10/10/28 By yinhy 查詢時,在單身的合併財報長期投資專案axb13開窗時,程式DOWN出
# Modify.........: NO.TQC-AB0296 10/11/29 BY suncx1 單身“投資股數、股本”輸入負數沒有控管；錄入時狀態頁簽的“資料所有者”等沒有默認值
# Modify.........: No.TQC-AC0192 10/12/15 By yinhy 更改單身資料時，沒有自動帶出相應"帳套"
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.MOD-B70248 11/07/27 By Polly 增加條件，下層公司如需存在不同上層公司者，其族群代號不可相同
# Modify.........: NO.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-B80192 11/11/23 by belle 移除axa09欄位
# Modify.........: NO.130717     13/07/17 by xiayan 单头增加分层合并否，单身增加纳入合并否

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
#FUN-BA0012
#FUN-B80192
#模組變數(Module Variables)
DEFINE
    g_axa           RECORD LIKE axa_file.*,
    g_axa_t         RECORD LIKE axa_file.*,
    g_axa_o         RECORD LIKE axa_file.*,
    g_axa01_t       LIKE axa_file.axa01,       #族群代號 (舊值)
    g_axa02_t       LIKE axa_file.axa02,       #上層公司 (舊值)
    g_axa03_t       LIKE axa_file.axa03,       #帳別編號 (舊值)
    g_axb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        axb04       LIKE axb_file.axb04,   #下層公司編號
        axz02b      LIKE axz_file.axz02,               #FUN-580063
        axb05       LIKE axb_file.axb05,   #帳別編號
        axb07       LIKE axb_file.axb07,   #持股比率
        axb06       LIKE axb_file.axb06,   #NO.130717 add
        axb11       LIKE axb_file.axb11,   #投資股數   #FUN-580063
        axb12       LIKE axb_file.axb12,   #股本       #FUN-580063
        axb13       LIKE axb_file.axb13,   #長期投資科目     #No.FUN-7A0035 
        aag02       LIKE aag_file.aag02,   #會計科目     #No.FUN-7A0035 
        axb08       LIKE axb_file.axb08    #異動日期
                    END RECORD,
    g_axb_t         RECORD    #程式變數(Program Variables)
        axb04       LIKE axb_file.axb04,   #下層公司編號
        axz02b      LIKE axz_file.axz02,               #FUN-580063
        axb05       LIKE axb_file.axb05,   #帳別編號
        axb07       LIKE axb_file.axb07,   #持股比率
        axb06       LIKE axb_file.axb06,   #NO.130717 add
        axb11       LIKE axb_file.axb11,   #投資股數   #FUN-580063
        axb12       LIKE axb_file.axb12,   #股本       #FUN-580063
        axb13       LIKE axb_file.axb13,   #長期投資科目     #No.FUN-7A0035 
        aag02       LIKE aag_file.aag02,   #會計科目     #No.FUN-7A0035 
        axb08       LIKE axb_file.axb08    #異動日期
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #TQC-630166     
    g_dbs_gl        LIKE type_file.chr21,                #No.FUN-680098   VARCHAR(21)
    g_rec_b         LIKE type_file.num5,               #單身筆數        #No.FUN-680098  smallint
    l_ac            LIKE type_file.num5,               #目前處理的ARRAY CNT   #No.FUN-680098 smallint
    g_axz03         LIKE axz_file.axz03,               #FUN-580063
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
DEFINE g_aaz641       LIKE aaz_file.aaz641     #FUN-920033 add
DEFINE g_dbs_axz03    LIKE type_file.chr21     #FUN-920033 add
DEFINE g_plant_axz03  LIKE type_file.chr10     #No.FUN-980025 
DEFINE g_axz02        LIKE axz_file.axz02      #FUN-920033
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5                  #No.FUN-680098     smallint
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   #IF (NOT cl_setup("AGL")) THEN  #NO.130717 mark
   IF (NOT cl_setup("CGL")) THEN  #NO.130717 modify
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   
   LET g_sql = "axa01.axa_file.axa01,",
               "axa02.axa_file.axa02,",  
               "l_axz02.axz_file.axz02,",  
               "l_axz03.axz_file.axz03,",  
               "axa03.axa_file.axa03,",  
               "axb04.axb_file.axb04,", 
               "l_axz02b.axz_file.axz02,",
               "l_axz03b.axz_file.axz03,",
               "axb05.axb_file.axb05,",
               "axb07.axb_file.axb07,",
               "axb11.axb_file.axb11,",
               "axb12.axb_file.axb12,",
               "axb13.axb_file.axb13,",     #No.FUN-7A0035 
               "aag02.aag_file.aag02,",     #No.FUN-7A0035 
               "axb08.axb_file.axb08"
 
   LET l_table = cl_prt_temptable('agli002',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,                        
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,      #TQC-A40116 mod                  
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "       #No.FUN-7A0035 
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
                
   LET g_forupd_sql = "SELECT * FROM axa_file WHERE axa01 = ? AND axa02 = ? AND axa03 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 18
   OPEN WINDOW i002_w AT p_row,p_col  #顯示畫面
     WITH FORM "cgl/42f/cgli002"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL i002_menu()
 
   CLOSE WINDOW i002_w                    #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION i002_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_axb.clear()
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_axa.* TO NULL    #No.FUN-750051
#  CONSTRUCT BY NAME g_wc ON axa01,axa02,axa03,axa09,axauser,axagrup,axamodu,axadate    #FUN-950051 add axa09   #FUN-A90029 makr
   CONSTRUCT BY NAME g_wc ON axa01,axa02,axa03,axa04,axa09,axa05,axa06,                 #FUN-A90029 add
                             axa07,   #NO.130717 add
                             axauser,axagrup,axamodu,axadate                            #FUN-A90029 add
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axa01) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.state = "c"                                                                                           
               LET g_qryparam.form ="q_axa1"                                                                                        
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO axa01                                                                                 
               NEXT FIELD axa01                                                                                                     
            WHEN INFIELD(axa02) #工廠編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_axz"      #FUN-580063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axa02
               NEXT FIELD axa02
            WHEN INFIELD(axa03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axa03
               NEXT FIELD axa03
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
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('axauser', 'axagrup')
 
 
   CONSTRUCT g_wc2 ON axb04,axb05,axb07,axb11,axb12,axb13,axb08      #螢幕上取單身條件     #No.FUN-7A0035 
                     ,axb06   #NO.130717 add
                 FROM s_axb[1].axb04,s_axb[1].axb05,s_axb[1].axb07,
                 s_axb[1].axb11,s_axb[1].axb12,s_axb[1].axb13,s_axb[1].axb08     #No.FUN-7A0035 
                ,s_axb[1].axb06   #NO.130717 add
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axb04) #下層公司編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_axz"           #FUN-580063
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axb04
               NEXT FIELD axb04
            WHEN INFIELD(axb05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axb05
               NEXT FIELD axb05
           WHEN INFIELD(axb13)
             # CALL q_m_aag(FALSE,TRUE,g_plant_axz03,g_axb[l_ac].axb13,'23',g_aaz641)   #No.FUN-980025  #No.TQC-AA0140 mark
             #     RETURNING g_axb[l_ac].axb13                                        #No.TQC-AA0140 mark
             # DISPLAY BY NAME g_axb[l_ac].axb13                                      #No.TQC-AA0140 mark 
              CALL q_m_aag2(TRUE,TRUE,g_dbs_axz03,g_axb[1].axb13,'23',g_aaz641)      #No.TQC-AA0140 mod
                  RETURNING g_qryparam.multiret                                      #No.TQC-AA0140 mod
              DISPLAY g_qryparam.multiret TO axb13                                   #No.TQC-AA0140 mod
              NEXT FIELD axb13
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
      LET g_sql = "SELECT  axa01,axa02,axa03 FROM axa_file ",#TQC-870018
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY axa01,axa02,axa03"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT axa_file. axa01,axa02,axa03 ",#TQC-870018
                  "  FROM axa_file, axb_file ",
                  " WHERE axa01 = axb01 AND axa02=axb02 AND axa03=axb03 ",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY axa01,axa02,axa03"
   END IF
 
   PREPARE i002_prepare FROM g_sql
   DECLARE i002_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i002_prepare
 
   DROP TABLE x
   LET g_sql_tmp="SELECT DISTINCT axa01,axa02,axa03 ",  #No.TQC-720019
             " FROM axa_file WHERE ", g_wc CLIPPED,
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
               IF g_axa.axa01 IS NOT NULL THEN
                  LET g_doc.column1 = "axa01"
                  LET g_doc.value1 = g_axa.axa01
                  LET g_doc.column2 = "axa02"
                  LET g_doc.value2 = g_axa.axa02
                  LET g_doc.column3 = "axa03"
                  LET g_doc.value3 = g_axa.axa03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0010
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axb),'','')
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
   CALL g_axb.clear()
   INITIALIZE g_axa.* LIKE axa_file.*             #DEFAULT 設定
   LET g_axa01_t = NULL
   LET g_axa02_t = NULL
   LET g_axa03_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_axa_o.* = g_axa.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_axa.axauser=g_user
      LET g_axa.axaoriu = g_user #FUN-980030
      LET g_axa.axaorig = g_grup #FUN-980030
      LET g_axa.axagrup=g_grup
      LET g_axa.axadate=g_today
      LET g_axa.axaacti='Y'              #資料有效
      LET g_axa.axa09 = 'N'              #獨立會科合并   #FUN-990051
      LET g_axa.axa09 = 'N'              #獨立會科合并
      LET g_axa.axa04 = 'N'              #FUN-A90029
      LET g_axa.axa05 = '1'              #FUN-A90029
      LET g_axa.axa06 = '1'              #FUN-A90029
      LET g_axa.axa07 = 'N'   #NO.130717 add

      CALL i002_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_axa.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_axa.axa01)  THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      IF cl_null(g_axa.axa02)  THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      IF cl_null(g_axa.axa03)  THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO axa_file VALUES (g_axa.*)
      IF SQLCA.sqlcode THEN   			#置入資料庫不成功
         CALL cl_err3("ins","axa_file",g_axa.axa01,g_axa.axa02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
#FUN-A90029 ----------------------add start-----------------------------
     IF g_axa.axa04 = 'Y' THEN                                                 
         UPDATE axa_file SET axa09 = g_axa.axa09,                               
                             axa05 = g_axa.axa05,                               
                             axa06 = g_axa.axa06                                
         WHERE axa01 = g_axa.axa01                                              
           AND axa04 <> 'Y'                                                     
      END IF
#FUN-A90029 ---------------------add end-------------------------------- 

      SELECT axa01 INTO g_axa.axa01 FROM axa_file
       WHERE axa01 = g_axa.axa01
         AND axa02=g_axa.axa02
         AND axa03=g_axa.axa03
 
      LET g_axa01_t = g_axa.axa01        #保留舊值
      LET g_axa02_t = g_axa.axa02        #保留舊值
      LET g_axa03_t = g_axa.axa03        #保留舊值
      LET g_axa_t.* = g_axa.*
 
      CALL g_axb.clear()
      LET g_rec_b = 0
 
      CALL i002_b()                   #輸入單身
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i002_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_axa.axa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_axa.* FROM axa_file
    WHERE axa01=g_axa.axa01
      AND axa02=g_axa.axa02
      AND axa03=g_axa.axa03
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_axa01_t = g_axa.axa01
   LET g_axa02_t = g_axa.axa02
   LET g_axa03_t = g_axa.axa03
   LET g_axa_o.* = g_axa.*
   BEGIN WORK
 
   OPEN i002_cl USING g_axa.axa01,g_axa.axa02,g_axa.axa03
   IF STATUS THEN
      CALL cl_err("OPEN i002_cl:", STATUS, 1)   
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i002_cl INTO g_axa.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axa.axa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i002_show()
 
   WHILE TRUE
      LET g_axa01_t = g_axa.axa01
      LET g_axa02_t = g_axa.axa02
      LET g_axa03_t = g_axa.axa03
      LET g_axa.axamodu=g_user
      LET g_axa.axadate=g_today
 
      CALL i002_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_axa.*=g_axa_t.*
         CALL i002_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_axa.axa01 != g_axa01_t OR        #更改key 值
         g_axa.axa02 != g_axa02_t OR
         g_axa.axa03 != g_axa03_t THEN
         UPDATE axb_file SET axb01 = g_axa.axa01,
                             axb02 = g_axa.axa02,
                             axb03 = g_axa.axa03
          WHERE axb01 = g_axa01_t
            AND axb02=g_axa02_t
            AND axb03=g_axa03_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","axb_file",g_axa01_t,g_axa02_t,SQLCA.sqlcode,"","axb",1)  #No.FUN-660123
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE axa_file SET axa_file.* = g_axa.*
      WHERE axa01 = g_axa01_t AND axa02 = g_axa02_t AND axa03 = g_axa03_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","axa_file",g_axa01_t,g_axa02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660123
         CONTINUE WHILE
      END IF
#FUN-A90029 ------------------------add start--------------------------
     IF g_axa.axa04 = 'Y' THEN                                                 
         UPDATE axa_file SET axa09 = g_axa.axa09,                               
                             axa05 = g_axa.axa05,                               
                             axa06 = g_axa.axa06                                
         WHERE axa01 = g_axa.axa01                                              
           AND axa04 <> 'Y'                                                     
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
   l_axb           RECORD LIKE axb_file.*   #MOD-790108
DEFINE 
   l_cnt           LIKE type_file.num5      #FUN-A90029 
 
   #DISPLAY BY NAME g_axa.axaoriu,g_axa.axaorig,g_axa.axauser,g_axa.axamodu,g_axa.axagrup,g_axa.axadate   #TQC-AB0296
   DISPLAY BY NAME g_axa.axauser,g_axa.axamodu,g_axa.axagrup,g_axa.axadate     #TQC-AB0296 modify
   CALL cl_set_head_visible("","YES")        #No.FUN-6B0029
 
#  INPUT BY NAME g_axa.axa01,g_axa.axa02,g_axa.axa03,g_axa.axa09 WITHOUT DEFAULTS   #FUN-950051 add axa09  #FUN-A90029 mark
   INPUT BY NAME g_axa.axa01,g_axa.axa02,g_axa.axa03,g_axa.axa04,g_axa.axa09,       #FUN-A90029 add
                 g_axa.axa05,g_axa.axa06,g_axa.axa07 WITHOUT DEFAULTS  #FUN-A90029 add #NO.130717 add axa07
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i002_set_entry(p_cmd)
         CALL i002_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

#FUN-A90029 -----------------add start--------------------------
      AFTER FIELD axa01                                                         
         IF p_cmd = 'a' THEN                                                    
            LET g_axa.axa05='1'                                                 
            LET g_axa.axa06='2'                                                 
            LET g_axa.axa09='N'                                                 
         END IF                                                                 
                                                                                
         IF (p_cmd='a'                                                          
            OR (p_cmd='u' AND g_axa.axa01<>g_axa_t.axa01)) THEN                 
            SELECT axa05,axa06,axa09                                            
              INTO g_axa.axa05,g_axa.axa06,g_axa.axa09                          
              FROM axa_file                                                     
             WHERE axa01=g_axa.axa01                                            
               AND axa04='Y'                                                    
            END IF                                                              
         DISPLAY BY NAME g_axa.axa05,g_axa.axa06,g_axa.axa09
#FUN-A90029 ----------------add end-------------------------------
 
      AFTER FIELD axa02            #上層公司編號
         IF NOT cl_null(g_axa.axa02) THEN
            CALL i002_axa02('a')
            IF NOT cl_null(g_errno) THEN
               LET g_axa.axa02 = g_axa02_t
               CALL cl_err(g_axa.axa02,g_errno,0)
               NEXT FIELD axa02
            END IF
# FUN-590014 自動帶入帳別
            SELECT axz05 INTO g_axa.axa03
              FROM axz_file
             WHERE axz01 = g_axa.axa02
            IF cl_null(g_axa.axa03) THEN
               CALL cl_err(g_axa.axa02,'aco-025',0)
               NEXT FIELD axa02
            END IF
            DISPLAY g_axa.axa03 TO axa03
            CALL cl_set_comp_entry("axa03",FALSE)
            #增加上層公司+帳別的合理性判斷,應存在agli009
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axz_file
             WHERE axz01=g_axa.axa02 AND axz05=g_axa.axa03
            IF l_n = 0 THEN
               CALL cl_err(g_axa.axa02,'agl-946',0)
               NEXT FIELD axa02
            END IF
         END IF
 
      AFTER FIELD axa03            #帳別
         IF NOT cl_null(g_axa.axa03) THEN
            IF g_axa.axa03 != g_axa03_t OR g_axa03_t IS NULL THEN
               CALL i002_axa03('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_axa.axa03 = g_axa03_t
                  CALL cl_err(g_axa.axa03,g_errno,0)
                  NEXT FIELD axa03
               END IF
            END IF
            #增加上層公司+帳別的合理性判斷,應存在agli009
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM axz_file
             WHERE axz01=g_axa.axa02 AND axz05=g_axa.axa03
            IF l_n = 0 THEN
               CALL cl_err(g_axa.axa03,'agl-946',0)
               NEXT FIELD axa03
            END IF
            IF (g_axa.axa01 != g_axa01_t) OR (g_axa01_t IS NULL) OR
               (g_axa.axa02 != g_axa02_t) OR (g_axa02_t IS NULL) OR
               (g_axa.axa03 != g_axa03_t) OR (g_axa03_t IS NULL) THEN
               SELECT count(*) INTO l_n FROM axa_file
                WHERE axa01=g_axa.axa01 AND axa02=g_axa.axa02
                  AND axa03=g_axa.axa03
               IF l_n > 0 THEN
                  CALL cl_err(g_axa.axa01,-239,0)
                  LET g_axa.axa01 = g_axa01_t
                  LET g_axa.axa02 = g_axa02_t
                  LET g_axa.axa03 = g_axa03_t
                  DISPLAY BY NAME g_axa.axa01,g_axa.axa02,g_axa.axa03
                  NEXT FIELD axa01
               END IF
            END IF
         END IF
 
#FUN-A90029 -------------------------add start--------------------------
      AFTER FIELD axa04                                                         
         IF g_axa.axa04 = 'Y' THEN                                              
            SELECT COUNT(*) INTO l_cnt FROM axa_file                            
             WHERE axa01=g_axa.axa01                                            
               AND (axa02<>g_axa.axa02                                          
                OR axa03<>g_axa.axa03)                                          
               AND axa04='Y'                                                    
            IF l_cnt>0 THEN                                                     
               CALL cl_err(g_axa.axa01,'agl-219',0)                             
               NEXT FIELD axa04                                                 
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
            WHEN INFIELD(axa01) #族群編號                                                                                           
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form ="q_axa1"                                                                                        
               CALL cl_create_qry() RETURNING g_axa.axa01                                                                           
               DISPLAY BY NAME g_axa.axa01                                                                                          
               NEXT FIELD axa01                                                                                                     
            WHEN INFIELD(axa02) #工廠編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"        #FUN-580063
               LET g_qryparam.default1 = g_axa.axa02
               CALL cl_create_qry() RETURNING g_axa.axa02
               DISPLAY BY NAME g_axa.axa02
               NEXT FIELD axa02
            WHEN INFIELD(axa03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa2"
               SELECT axz03 INTO g_axz03 FROM axz_file WHERE axz01=g_axa.axa02
               SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_axz03   #TQC-660043
               LET g_qryparam.arg1 = g_azp03
               LET g_qryparam.default1 = g_axa.axa03
               CALL cl_create_qry() RETURNING g_axa.axa03
               DISPLAY BY NAME g_axa.axa03
               NEXT FIELD axa03
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
      CALL cl_set_comp_entry("axa01,axa02",TRUE)        #FUN-930131 mod
   END IF
#FUN-A90029 ---------------add start--------------------------
   IF g_axa.axa04 = 'Y' THEN                                                    
      CALL cl_set_comp_entry("axa09,axa05,axa06",TRUE)                          
   END IF
#FUN-A90029 --------------add end----------------------------
 
END FUNCTION
 
FUNCTION i002_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("axa01,axa02",FALSE)        #FUN-930131 mod
   END IF
#FUN-A90029 -----------------------add start--------------------------
   IF g_axa.axa04 <> 'Y' THEN                                                   
      CALL cl_set_comp_entry("axa09,axa05,axa06",FALSE)                         
   END IF
#FUN-A90029 ----------------------add end------------------------------
 
END FUNCTION
 
FUNCTION  i002_axa02(p_cmd)   #FUN-580063 將本段中所有azp改成axz
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_axz02         LIKE axz_file.axz02,
       l_axz03         LIKE axz_file.axz03
 
   LET g_errno = ' '
 
   SELECT axz02, axz03 INTO l_axz02, l_axz03 FROM axz_file
    WHERE axz01 = g_axa.axa02
 
   CASE WHEN SQLCA.SQLCODE =100  LET g_errno = 'mfg9142'
                                 LET l_axz02 = NULL
                                 LET l_axz03 = NULL
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_axz02  TO FORMONLY.axz02
      DISPLAY l_axz03  TO FORMONLY.axz03
   END IF
   
  #FUN-A30122 --------------------mark start------------------------------
  #LET g_plant_new = l_axz03    #營運中心
  #LET g_plant_axz03 = l_axz03  #No.FUN-980025 add
  #CALL s_getdbs()
  #LET g_dbs_axz03 = g_dbs_new   
  #FUN-A30122 -------------------mark end---------------------------------
   
END FUNCTION
 
FUNCTION i002_axa03(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_aaa01         LIKE aaa_file.aaa01,
       l_sql           STRING         #TQC-630166     
 
    LET g_errno = ' '
    LET g_plant_new = g_axa.axa02
 
    CALL s_getdbs()
 
    LET g_dbs_gl = g_dbs_new
 
  # LET l_sql = "SELECT aaa01 FROM ",g_dbs_gl,                         #FUN-A30122 mark
    LET l_sql = "SELECT aaa01 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A30122 add 
  #             "aaa_file WHERE aaa01 = '",g_axa.axa03,"'"                         #FUN-A30122 mark
                " WHERE aaa01 = '",g_axa.axa03,"'"                                 #FUN-A30122 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A30122  
    PREPARE i002_preaxa03 FROM l_sql
    DECLARE i002_curaxa03 CURSOR FOR i002_preaxa03
 
    OPEN i002_curaxa03
    FETCH i002_curaxa03 INTO l_aaa01
    IF SQLCA.sqlcode THEN
       LET g_errno = 'agl-095'
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION i002_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_axa.* TO NULL              #No.FUN-6B0040
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axb.clear()
 
   CALL i002_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i002_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_axa.* TO NULL
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
        WHEN 'N' FETCH NEXT     i002_cs INTO g_axa.axa01,
                                             g_axa.axa02,g_axa.axa03 #TQC-870018
                                             
        WHEN 'P' FETCH PREVIOUS i002_cs INTO g_axa.axa01,
                                             g_axa.axa02,g_axa.axa03 #TQC-870018
                                            
        WHEN 'F' FETCH FIRST    i002_cs INTO g_axa.axa01,
                                             g_axa.axa02,g_axa.axa03 #TQC-870018
                                             
        WHEN 'L' FETCH LAST     i002_cs INTO g_axa.axa01,
                                             g_axa.axa02,g_axa.axa03 #TQC-870018
                                            
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
            FETCH ABSOLUTE g_jump i002_cs INTO g_axa.axa01,
                                               g_axa.axa02,g_axa.axa03 #TQC-870018
                                               
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_axa.axa01,SQLCA.sqlcode,0)
       INITIALIZE g_axa.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_axa.* FROM axa_file WHERE axa01 = g_axa.axa01 AND axa02 = g_axa.axa02 AND axa03 = g_axa.axa03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","axa_file",g_axa.axa01,g_axa.axa02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
       INITIALIZE g_axa.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_axa.axauser     #No.FUN-4C0048
       LET g_data_group = g_axa.axagrup     #No.FUN-4C0048
       CALL i002_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i002_show()
 
   LET g_axa_t.* = g_axa.*                #保存單頭舊值
   DISPLAY BY NAME                              # 顯示單頭值
       g_axa.axa01,g_axa.axa02,g_axa.axa03,g_axa.axa09,    #FUN-950051 add  axa09
       g_axa.axauser,g_axa.axagrup,g_axa.axamodu,g_axa.axadate
      ,g_axa.axa04,g_axa.axa05,g_axa.axa06                 #FUN-A90029  
      ,g_axa.axa07   #NO.130717 add

   CALL i002_axa02('d')

   CALL i002_b_fill(g_wc2)                 #單身

    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i002_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_axa.axa01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF g_axa.axaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_axa.axa01,9027,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i002_cl USING g_axa.axa01,g_axa.axa02,g_axa.axa03
   IF STATUS THEN
      CALL cl_err("OPEN i002_cl:", STATUS, 1)
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i002_cl INTO g_axa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axa.axa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i002_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i002_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "axa01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_axa.axa01      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "axa02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_axa.axa02      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "axa03"         #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_axa.axa03      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM axa_file
       WHERE axa01 = g_axa.axa01
         AND axa02=g_axa.axa02
         AND axa03=g_axa.axa03
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","axa_file",g_axa.axa01,g_axa.axa02,SQLCA.sqlcode,"","",1)  #No.FUN-660123
      END IF
 
      DELETE FROM axb_file
       WHERE axb01 = g_axa.axa01
         AND axb02=g_axa.axa02
         AND axb03=g_axa.axa03
 
      CLEAR FORM
      CALL g_axb.clear()
      CALL g_axb.clear()
 
      DROP TABLE x                        #No.TQC-720019
      PREPARE i002_pre_y2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i002_pre_y2                 #No.TQC-720019
      OPEN i002_count
      FETCH i002_count INTO g_row_count
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
   l_axz04         LIKE axz_file.axz04    #使用tiptop否   #FUN-580063
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_axa.axa01) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
   
   CALL s_aaz641_dbs(g_axa.axa01,g_axa.axa02) RETURNING g_plant_axz03  #FUN-A30122
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                 #FUN-A30122
  
  #FUN-A30122 ---------------------mark start--------------------------------- 
  #IF g_axa.axa09 = 'Y' THEN  #FUN-950051
  #   SELECT axz02, axz03 INTO g_axz02,g_axz03 FROM axz_file
  #    WHERE axz01 = g_axa.axa02
  #   LET g_plant_new = g_axz03  #營運中心
  #   LET g_plant_axz03 = g_axz03  #營運中心 #No.FUN-980025 add
  #   CALL s_getdbs()
  #   LET g_dbs_axz03 = g_dbs_new   
  #  #LET l_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102
  #   LET l_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_axz03,'aaz_file'),   #FUN-A50102
  #               " WHERE aaz00 = '0'"
  #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
  #   CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql   #FUN-A50102
  #   PREPARE i002_preaxa06 FROM l_sql
  #   DECLARE i002_curaxa06 CURSOR FOR i002_preaxa06
  #   OPEN i002_curaxa06
  #   FETCH i002_curaxa06 INTO g_aaz641
  #   IF cl_null(g_aaz641) THEN
  #       CALL cl_err(g_axz03,'agl-601',0)
  #   END IF
  #ELSE
  #   LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
  #   SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
  #END IF 
  #FUN-A30122 ------------------------------mark end---------------------------------

   LET g_forupd_sql = "SELECT axb04,'',axb05,axb07,axb06,axb11,axb12,axb13,'',axb08 FROM axb_file ",  #FUN-580063     #No.FUN-7A0035  #NO.130717 add axb06
                      "  WHERE axb01= ? AND axb02= ? AND axb03= ? AND axb04= ? ",
                      "   AND axb05= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i002_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_axb WITHOUT DEFAULTS FROM s_axb.*
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
 
         OPEN i002_cl USING g_axa.axa01,g_axa.axa02,g_axa.axa03
         IF STATUS THEN
            CALL cl_err("OPEN i002_cl:", STATUS, 1)
            CLOSE i002_cl
            ROLLBACK WORK
            RETURN
         ELSE
            FETCH i002_cl INTO g_axa.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_axa.axa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i002_cl
               ROLLBACK WORK
               RETURN
            END IF
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_axb_t.* = g_axb[l_ac].*  #BACKUP
            OPEN i002_bcl USING g_axa.axa01,g_axa.axa02,
                                g_axa.axa03,g_axb_t.axb04,g_axb_t.axb05
            IF STATUS THEN
               CALL cl_err("OPEN i002_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i002_bcl INTO g_axb[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_axb_t.axb04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         IF l_ac <= l_n THEN            #DISPLAY NEWEST
            CALL i002_axb04('d')
           #LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file",
            LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),   #FUN-A50102 
                         " WHERE aag01 = '",g_axb[l_ac].axb13,"'", 
                         "   AND aag00 = '",g_aaz641,"'" 
	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql   #FUN-A50102
             PREPARE i002_pre_2 FROM g_sql
             DECLARE i002_cur_2 CURSOR FOR i002_pre_2
             OPEN i002_cur_2
             FETCH i002_cur_2 INTO g_axb[l_ac].aag02
 
             IF SQLCA.sqlcode  THEN LET g_axb[l_ac].aag02 = '' END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axb[l_ac].* TO NULL         #900423
         INITIALIZE g_axb_t.* TO NULL             #900423
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD axb04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO axb_file(axb01,axb02,axb03,axb04,axb05,axb07,axb11,axb12,axb13,axb08,axb06)     #No.FUN-7A0035 #NO.130717 add axb06
                       VALUES(g_axa.axa01,g_axa.axa02,g_axa.axa03,
                              g_axb[l_ac].axb04,g_axb[l_ac].axb05,
                              g_axb[l_ac].axb07,g_axb[l_ac].axb11,
                              g_axb[l_ac].axb12,g_axb[l_ac].axb13,     #No.FUN-7A0035 
                              g_axb[l_ac].axb08,g_axb[l_ac].axb06)  #NO.130717 add axb06
 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axb_file",g_axa.axa01,g_axb[l_ac].axb04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD axb04    #下層公司
         IF NOT cl_null(g_axb[l_ac].axb04) THEN            
            #TQC-AC0192   --Begin 
            #CALL i002_axb04('a')
            #IF NOT cl_null(g_errno) THEN
            #   CALL cl_err(g_axb[l_ac].axb04,g_errno,0)   #TQC-740291 add
            #   LET g_axb[l_ac].axb04 = g_axb_t.axb04
            #   NEXT FIELD axb04
            #END IF
            #TQC-AC0192   --End
# FUN-590014 自動帶入帳別
            SELECT axz05 INTO g_axb[l_ac].axb05
              FROM axz_file
             WHERE axz01 = g_axb[l_ac].axb04
            IF cl_null(g_axb[l_ac].axb05) THEN
               CALL cl_err(g_axb[l_ac].axb04,'aco-025',0)
               NEXT FIELD axb04
            END IF
            DISPLAY g_axb[l_ac].axb05 TO axb05
            CALL cl_set_comp_entry("axb05",FALSE)
            #TQC-AC0192   --Begin 
            CALL i002_axb04('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axb[l_ac].axb04,g_errno,0)   #TQC-740291 add
               LET g_axb[l_ac].axb04 = g_axb_t.axb04
               NEXT FIELD axb04
            END IF
            #TQC-AC0192   --End
            #-----MOD-790108---------
            IF g_axb[l_ac].axb04 = g_axa.axa02 AND 
               g_axb[l_ac].axb05 = g_axa.axa03 THEN
               CALL cl_err(g_axb[l_ac].axb04,'agl-152',1)
               NEXT FIELD axb04
            END IF
            #檢查輸入的下層公司資料是否與單頭公司相同
            IF g_axb[l_ac].axb04 = g_axa.axa02 THEN
               CALL cl_err(g_axb[l_ac].axb04,'agl-947',0)
               NEXT FIELD axb04
            END IF
#-----------------------------No.MOD-B70248---------------------start           
            IF g_axb[l_ac].axb04 != g_axb_t.axb04 OR g_axb_t.axb04 IS NULL THEN   #TQC-B80263
                SELECT count(*) INTO l_n FROM axb_file
                 WHERE axb01 = g_axa.axa01 
                   AND axb04 = g_axb[l_ac].axb04
                   AND axb05 = g_axb[l_ac].axb05
                   AND axb06 = 'Y'   #TQC-B80263
                IF l_n > 0 THEN
                   CALL cl_err(g_axb[l_ac].axb04,'agl-210',0)
                  NEXT FIELD axb04
         END IF
            END IF        #TQC-B80263
#-----------------------------No.MOD-B70248-----------------------end
         END IF
 
      AFTER FIELD axb05
         SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01=g_axb[l_ac].axb04
         IF l_axz04='Y' THEN
            IF NOT cl_null(g_axb[l_ac].axb05) THEN
               IF g_axb[l_ac].axb04 = g_axa.axa02 AND
                  g_axb[l_ac].axb05 = g_axa.axa03 THEN
                  CALL cl_err(g_axb[l_ac].axb05,'agl-116',0)
                  NEXT FIELD axb04
               END IF
               #增加下層公司+帳別的合理性判斷,應存在agli009
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM axz_file
                WHERE axz01=g_axb[l_ac].axb04 AND axz05=g_axb[l_ac].axb05
               IF l_n = 0 THEN
                  CALL cl_err(g_axb[l_ac].axb04,'agl-946',0)
                  NEXT FIELD axb04
               END IF
               IF g_axb[l_ac].axb05 != g_axb_t.axb05 OR g_axb_t.axb05 IS NULL THEN
                  CALL i002_axb05('a')
                  IF NOT cl_null(g_errno) THEN
                     LET g_axb[l_ac].axb05 = g_axb_t.axb05
                     CALL cl_err(g_axb[l_ac].axb05,g_errno,0)
                     NEXT FIELD axb05
                  END IF
               END IF
               IF g_axb[l_ac].axb04 != g_axb_t.axb04 OR g_axb_t.axb04 IS NULL OR
                  g_axb[l_ac].axb05 != g_axb_t.axb05 OR g_axb_t.axb05 IS NULL THEN
                  SELECT count(*) INTO l_n FROM axb_file
                   WHERE axb01 = g_axa.axa01 AND axb02 = g_axa.axa02
                     AND axb03 = g_axa.axa03 AND axb04 = g_axb[l_ac].axb04
                     AND axb05 = g_axb[l_ac].axb05
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_axb[l_ac].axb04 = g_axb_t.axb04
                     LET g_axb[l_ac].axb05 = g_axb_t.axb05
                     NEXT FIELD axb05
                  END IF
               END IF
            END IF
         END IF    #FUN-580063
 
      AFTER FIELD axb07                 #折扣比率
         IF NOT cl_null(g_axb[l_ac].axb07) THEN
            IF g_axb[l_ac].axb07 < 0 OR g_axb[l_ac].axb07 > 100 THEN
              CALL cl_err(g_axb[l_ac].axb07,'mfg0013',0)
              LET g_axb[l_ac].axb07 = g_axb_t.axb07
              NEXT FIELD axb07
            END IF
         END IF

      #TQC-AB0296 modify---begin-------------------------
      AFTER FIELD axb11
         IF NOT cl_null(g_axb[l_ac].axb11) THEN
            IF g_axb[l_ac].axb11 < 0 THEN
               CALL cl_err(g_axb[l_ac].axb11,'apj-035',0)
              LET g_axb[l_ac].axb11 = g_axb_t.axb11
              NEXT FIELD axb11
            END IF
         END IF
#NO.130717 add------------------begin
         IF g_axb[l_ac].axb07>50 THEN 
            LET g_axb[l_ac].axb06 = 'Y'
         ELSE
            LET g_axb[l_ac].axb06 = 'N'
         END IF 
#NO.130717 add--------------------end

      AFTER FIELD axb12
         IF NOT cl_null(g_axb[l_ac].axb12) THEN
            IF g_axb[l_ac].axb12 < 0 THEN
               CALL cl_err(g_axb[l_ac].axb12,'apj-035',0)
              LET g_axb[l_ac].axb12 = g_axb_t.axb12
              NEXT FIELD axb12
            END IF
         END IF
      #TQC-AB0296 modify----end-------------------------- 

     AFTER FIELD axb13
       #FUN-A30122 ------------------------mark start----------------------------------- 
       ##--FUN-920033 start 一併取出此PLANT中agls101所設定合併報表帳別---
       ##LET l_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
       # LET l_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_axz03,'aaz_file'),   #FUN-A50102
       #             " WHERE aaz00 = '0'"
#       CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
       # CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql     #FUN-A50102
       # PREPARE i002_preaxa04 FROM l_sql
       # DECLARE i002_curaxa04 CURSOR FOR i002_preaxa04
       # OPEN i002_curaxa04
       # FETCH i002_curaxa04 INTO g_aaz641
       # IF cl_null(g_aaz641) THEN
       #     SELECT axz03 INTO g_axz03 FROM axz_file WHERE axz01=g_axa.axa02
       #     CALL cl_err(g_axz03,'agl-601',0)
       #     NEXT FIELD axb13
       # END IF
       ##FUN-A50102--mod--str--
       #FUN-A30122 --------------------------------mark end---------------------------------------       

        #LET l_sql = "SELECT COUNT(*) FROM ",g_dbs_axz03,
        #            "aag_file WHERE aag00 = '",g_aaz641,"'",
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),
                     " WHERE aag00 = '",g_aaz641,"'",
        #FUN-A50102--mod--end
                     "  AND aag01 = '",g_axb[l_ac].axb13,"'"
	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql     #FUN-A50102
         PREPARE i002_preaxa05 FROM l_sql
         DECLARE i002_curaxa05 CURSOR FOR i002_preaxa05
         OPEN i002_curaxa05
         FETCH i002_curaxa05 INTO l_n
         IF l_n=0 THEN
            CALL cl_err(g_axb[l_ac].axb13,'aap-021',0)
            #FUN-B20004--begin
            CALL q_m_aag2(FALSE,FALSE,g_plant_axz03,g_axb[l_ac].axb13,'23',g_aaz641) 
                 RETURNING g_axb[l_ac].axb13
            #FUN-B20004--end
            #LET g_axb[l_ac].axb13 = g_axb_t.axb13
            NEXT FIELD axb13
         ELSE
            #LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
             LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),   #FUN-A50102
                         " WHERE aag01 = '",g_axb[l_ac].axb13,"'",                
                         "   AND aag00 = '",g_aaz641,"'"                
	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql  #FUN-A50102
             PREPARE i002_pre_3 FROM g_sql
             DECLARE i002_cur_3 CURSOR FOR i002_pre_3
             OPEN i002_cur_3
             FETCH i002_cur_3 INTO g_axb[l_ac].aag02 
             IF SQLCA.sqlcode  THEN LET g_axb[l_ac].aag02 = '' END IF
             DISPLAY BY NAME g_axb[l_ac].aag02
         END IF
      
        SELECT aag02 INTO g_axb[l_ac].aag02 FROM aag_file
         WHERE aag01 = g_axb[l_ac].axb13
 
      BEFORE DELETE                            #是否取消單身
         IF (g_axb_t.axb04 > 0 OR  g_axb_t.axb04 IS NOT NULL ) AND
            g_axb_t.axb05 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM axb_file
             WHERE axb01 = g_axa.axa01
               AND axb02=g_axa.axa02
               AND axb03 = g_axa.axa03
               AND axb04 = g_axb_t.axb04
               AND axb05 = g_axb_t.axb05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axb_file",g_axa.axa01,g_axb_t.axb04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
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
            LET g_axb[l_ac].* = g_axb_t.*
            CLOSE i002_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axb[l_ac].axb04,-263,1)
            LET g_axb[l_ac].* = g_axb_t.*
         ELSE
            UPDATE axb_file SET axb04=g_axb[l_ac].axb04,
                                axb05=g_axb[l_ac].axb05,
                                axb07=g_axb[l_ac].axb07,
                                axb06 = g_axb[l_ac].axb06,   #NO.130717 add
                                axb11=g_axb[l_ac].axb11,   #FUN-580063
                                axb12=g_axb[l_ac].axb12,   #FUN-580063
                                axb13=g_axb[l_ac].axb13,     #No.FUN-7A0035 
                                axb08=g_axb[l_ac].axb08
             WHERE axb01=g_axa.axa01
               AND axb02=g_axa.axa02
               AND axb03=g_axa.axa03
               AND axb04=g_axb_t.axb04
               AND axb05=g_axb_t.axb05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","axb_file",g_axa.axa01,g_axb_t.axb04,SQLCA.sqlcode,"","",1)  #No.FUN-660123
               LET g_axb[l_ac].* = g_axb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_axb[l_ac].* = g_axb_t.*
            END IF
            CLOSE i002_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i002_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(axb04) AND l_ac > 1 THEN
            LET g_axb[l_ac].* = g_axb[l_ac-1].*
            NEXT FIELD axb04
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axb04) #下層公司編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axz"    #FUN-580063
               LET g_qryparam.default1 = g_axb[l_ac].axb04
               CALL cl_create_qry() RETURNING g_axb[l_ac].axb04
                DISPLAY BY NAME g_axb[l_ac].axb04         #No.MOD-490344
               NEXT FIELD axb04
             WHEN INFIELD(axb05)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa2"
                SELECT axz03 INTO g_axz03 FROM axz_file WHERE axz01=g_axb[l_ac].axb04
                SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_axz03   #TQC-660043
                LET g_qryparam.arg1 = g_azp03
                LET g_qryparam.default1 = g_axb[l_ac].axb05
                CALL cl_create_qry() RETURNING g_axb[l_ac].axb05
                DISPLAY BY NAME g_axb[l_ac].axb05         #No.MOD-490344
                NEXT FIELD axb05
           WHEN INFIELD(axb13)
              CALL q_m_aag2(FALSE,TRUE,g_plant_axz03,g_axb[l_ac].axb13,'23',g_aaz641) #No.FUN-980025
                  RETURNING g_axb[l_ac].axb13
              DISPLAY BY NAME g_axb[l_ac].axb13 
              NEXT FIELD axb13
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
 
   UPDATE axa_file SET axamodu = g_user,
                       axadate = g_today
    WHERE axa01=g_axa.axa01
      AND axa02=g_axa.axa02
      AND axa03=g_axa.axa03
 
   CLOSE i002_bcl
   COMMIT WORK
   CALL i002_delall()   #CHI-740039 add
 
END FUNCTION
 
#檢查工廠編號
FUNCTION i002_axb04(p_cmd)   #FUN-580063 將本段中所有的azp改成axz
 
DEFINE p_cmd           LIKE type_file.chr1,      #No.FUN-680098 VARCHAR(1)
       l_axz03         LIKE axz_file.axz03
 
   LET g_errno = ' '
   IF cl_null(g_axb[l_ac].axb05) THEN   #TQC-740291 add
     SELECT axz02, axz03 INTO g_axb[l_ac].axz02b,l_axz03 FROM axz_file
      WHERE axz01 = g_axb[l_ac].axb04
   ELSE
     SELECT axz02, axz03 INTO g_axb[l_ac].axz02b,l_axz03 FROM axz_file
      WHERE axz01 = g_axb[l_ac].axb04
        AND axz05 = g_axb[l_ac].axb05
   END IF
  
 
   CASE WHEN SQLCA.SQLCODE =100 
                     IF cl_null(g_axb[l_ac].axb05) THEN
                        LET g_errno = 'mfg9142'
                     ELSE
                        LET g_errno = 'agl-946'
                     END IF   
                     LET g_axb[l_ac].axz02b = NULL
                     LET l_axz03 = NULL
        OTHERWISE    LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i002_axb05(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
       l_aaa01         LIKE aaa_file.aaa01,
       l_sql           STRING        #TQC-630166 
 
   LET g_errno = ' '
   LET g_plant_new = g_axb[l_ac].axb04
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
 
 # LET l_sql = "SELECT aaa01 FROM ",g_dbs_gl,                                     #FUN-A30122 mark
 #             "aaa_file WHERE aaa01 = '",g_axb[l_ac].axb05,"'"                   #FUN-A30122 mark
   LET l_sql = "SELECT aaa01 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A30122 add     
               " WHERE aaa01 = '",g_axb[l_ac].axb05,"'"                           #FUN-A30122 add      
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql                        #FUN-A30122 add  
   PREPARE i002_preaxb05 FROM l_sql
   DECLARE i002_curaxb05 CURSOR FOR i002_preaxb05
 
   OPEN i002_curaxb05
   FETCH i002_curaxb05 INTO l_aaa01
   IF SQLCA.sqlcode THEN
      LET g_errno = 'agl-095'
   END IF
 
END FUNCTION
 
FUNCTION i002_b_askkey()
DEFINE
    l_wc2           STRING        #TQC-630166    
 
   CLEAR FORM                            #清除FORMONLY欄位
   CALL g_axb.clear()
   CALL g_axb.clear()
 
   CONSTRUCT l_wc2 ON axb04,axb05,axb07,axb11,axb12,axb13,axb08,axb06   # 螢幕上取單身條件     #No.FUN-7A0035 #NO.130717 add axb06 
                 FROM s_axb[1].axb04,s_axb[1].axb05,s_axb[1].axb07,
                      s_axb[1].axb11,s_axb[1].axb12,s_axb[1].axb13,s_axb[1].axb08     #No.FUN-7A0035 
                     ,s_axb[1].axb06   #NO.130717 add
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
 
   LET g_sql = "SELECT axb04,'',axb05,axb07,axb06,axb11,axb12,axb13,'',axb08",  #FUN-580063     #No.FUN-7A0035 #NO.130717 add axb06
               " FROM axb_file",
               " WHERE axb01 ='",g_axa.axa01,"' AND axb02='",g_axa.axa02,"' ",  #單頭
               "   AND axb03 ='",g_axa.axa03,"' AND ",p_wc2 CLIPPED, #單身
               " ORDER BY axb04,axb05"
   PREPARE i002_pb FROM g_sql
   DECLARE axb_curs CURSOR FOR i002_pb
 
   CALL g_axb.clear()
 
   LET g_rec_b = 0
   LET g_cnt = 1
 
   FOREACH axb_curs INTO g_axb[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      SELECT axz02 INTO g_axb[g_cnt].axz02b FROM  axz_file
       WHERE axz01 = g_axb[g_cnt].axb04
      IF SQLCA.sqlcode THEN
         LET g_axb[g_cnt].axz02b = ' '
      END IF
 
     #FUN-A30122 ---------------------------mark start-------------------------
     #IF g_axa.axa09 = 'Y' THEN   #FUN-950051
     #   LET g_axz03=''
     #   SELECT axz03 INTO g_axz03    
     #     FROM axz_file
     #    WHERE axz01 = g_axa.axa02     #上層公司
     #   
     #   LET g_plant_new = g_axz03      #營運中心
     #   CALL s_getdbs()
     #   LET g_dbs_axz03 = g_dbs_new    #所屬DB
     # 
     #  #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A50102
     #   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_axz03,'aaz_file'),   #FUN-A50102 
     #               " WHERE aaz00 = '0'"
#CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
#        CALL cl_parse_qry_sql(g_sql,g_axz03) RETURNING g_sql #FUN-A50102
#        PREPARE i002_pre FROM g_sql
#        DECLARE i002_cur CURSOR FOR i002_pre
#        OPEN i002_cur
#        FETCH i002_cur INTO g_aaz641     #合併後帳別
#        IF cl_null(g_aaz641) THEN
#            CALL cl_err(g_axz03,'agl-601',1)
#        END IF
#FUN-A30122 --------------------------mark end-------------------------------------    
         CALL s_aaz641_dbs(g_axa.axa01,g_axa.axa02) RETURNING g_plant_axz03  #FUN-A30122 add
         CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                 #FUN-A30122 add

        #LET g_sql = "SELECT aag02 FROM ",g_dbs_axz03,"aag_file",  #FUN-A50102
        #LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_axz03,'aag_file'),   #FUN-A50102   #FUN-A30122 mark
         LET g_sql = "SELECT aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), #FUN-A30122 add
                     " WHERE aag01 = '",g_axb[g_cnt].axb13,"'",                
                     "   AND aag00 = '",g_aaz641,"'"                
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
      #  CALL cl_parse_qry_sql(g_sql,g_axz03) RETURNING g_sql   #FUN-A50102   #FUN-A30122 mark
         CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql           #FUN-A30122
         PREPARE i002_pre_1 FROM g_sql
         DECLARE i002_cur_1 CURSOR FOR i002_pre_1
         OPEN i002_cur_1
         FETCH i002_cur_1 INTO g_axb[g_cnt].aag02 

         IF SQLCA.sqlcode  THEN LET g_axb[g_cnt].aag02 = '' END IF
#FUN-A30122--------------------------mark start-------------------------------
#     ELSE
#        LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#        SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
#        SELECT aag02 INTO g_axb[g_cnt].aag02 FROM aag_file
#         WHERE aag01 = g_axb[g_cnt].axb13
#           AND aag00 = g_aaz641
#     END IF 
#FUN-A30122 ---------------------------mark end-------------------------------

      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_axb.deleteElement(g_cnt)
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
   DISPLAY ARRAY g_axb TO s_axb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
   SELECT COUNT(*) INTO g_cnt FROM axb_file
    WHERE axb01=g_axa.axa01 AND axb02=g_axa.axa02 AND axb03=g_axa.axa03
   IF g_cnt = 0 THEN
      IF cl_confirm('9042') THEN   #未輸入單身資料,是否取消單頭資料(Y/N)?
         DELETE FROM axa_file
          WHERE axa01=g_axa.axa01 AND axa02=g_axa.axa02 AND axa03=g_axa.axa03
      END IF
   END IF
END FUNCTION
 
FUNCTION i002_out()
DEFINE l_i             LIKE type_file.num5,         #No.FUN-680098  smallint
       l_name          LIKE type_file.chr20,        #External(Disk) file name        #No.FUN-680098 VARCHAR(20)
       l_msg           LIKE type_file.chr1000,      #No.FUN-680098 VARCHAR(22)
       sr              RECORD
           axa01       LIKE axa_file.axa01,   #族群代號
           axa02       LIKE axa_file.axa02,   #上層公司編號
           axa03       LIKE axa_file.axa03,   #帳別
           axb04       LIKE axb_file.axb04,   #下層公司編號
           axb05       LIKE axb_file.axb05,   #帳別
           axb07       LIKE axb_file.axb07,   #持股比率
           axb11       LIKE axb_file.axb11,   #投資股數   #FUN-580063
           axb12       LIKE axb_file.axb12,   #股本       #FUN-580063
           axb13       LIKE axb_file.axb13,   #長期投資科目     #No.FUN-7A0035 
           axb08       LIKE axb_file.axb08    #異動日
                       END RECORD
   DEFINE l_aag02      LIKE aag_file.aag02    #No.MOD-7B0223
DEFINE l_axz02,l_axz02b   LIKE axz_file.axz02                                                                   
DEFINE l_axz03,l_axz03b   LIKE axz_file.axz03  
   IF cl_null(g_wc) THEN CALL cl_err('','9057',0) RETURN END IF
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-760085
   LET g_sql="SELECT axa01,axa02,axa03,",
             " axb04,axb05,axb07,axb11,axb12,axb13,axb08 ",    #FUN-580063     #No.FUN-7A0035  
             " FROM axa_file,axb_file",               
             " WHERE axb01 = axa01 AND axa02=axb02 AND axb03=axa03 ",
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
      SELECT axz02,axz03 INTO l_axz02,l_axz03 FROM axz_file                                                                      
        WHERE axz01 = sr.axa02                                                                                                    
        IF SQLCA.sqlcode THEN LET l_axz02 = ' ' LET l_axz03= ' ' END IF 
      SELECT axz02,axz03 INTO l_axz02b,l_axz03b FROM axz_file                                                                    
        WHERE axz01 = sr.axb04                                                                                                    
        IF SQLCA.sqlcode THEN LET l_axz02b = ' ' LET l_axz03b= ' ' END IF 
      SELECT aag02 INTO l_aag02 FROM aag_file     #No.MOD-7B0223                                                               
          WHERE aag01 = sr.axb13                  #No.MOD-7B0223
      EXECUTE insert_prep USING sr.axa01,sr.axa02,l_axz02,l_axz03,
                                sr.axa03,sr.axb04,l_axz02b,
                                l_axz03b,sr.axb05,sr.axb07,sr.axb11,sr.axb12,
                                sr.axb13,l_aag02,sr.axb08      #No.FUN-7A0035    #No.MOD-7B0223
   END FOREACH
 
 
   CLOSE i002_co
   ERROR ""
   IF g_zz05 = 'Y' THEN                                                       
      CALL cl_wcchp(g_wc,'axa01,axa02,axa03')                                
        RETURNING g_str                                                       
   END IF
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED         
   CALL cl_prt_cs3('agli002','agli002',l_sql,g_str)                           
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
