# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfp400.4gl
# Descriptions...: 工單－逐張close_the_case作業
# Date & Author..: 92/08/06 By Nora
# Modify.........: No:8769 03/11/25 By Melody 考慮作廢碼
# Modify.........: MOD-480415 04/09/01 By echo prompt框框問是否繼續,按yes 就跳開
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-560156 05/10/25 By Pengu 應增加工單編號、料號可查詢之功能
# Modify.........: No.FUN-5C0044 05/12/21 By kim 作委外工單結案時,應可一併將其委外採購單結案
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-650116 06/09/21 By Sarah 判斷若輸入的結案日期小於最後異動日則不予結案
# Modify.........: Mo.FUN-6A0071 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730039 07/03/12 By pengu 沒有資料查詢出來,點button"結案" 顯示錯誤訊息不往下執行
# Modify.........: No.MOD-750001 07/05/03 By pengu 工單作了第一段結案後，要作第二段工時結案，查詢工單單號就查不出來了
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780244 07/09/18 By pengu 結案時該採購單其它單身工單尚未結案該採購單整張不可結案
# Modify.........: No.MOD-830229 08/04/19 By Pengu 1.不會即時反應結案碼更動狀況
#                                                  2.應不允許結案成3
# Modify.........: No.MOD-850102 08/05/09 By chenl 結案時，需判斷該工單相關的發料單，退料單，入庫單是否已審核過賬，若沒有，則該工單不可結案。
# Modify.........: No.MOD-890064 08/09/05 By claire 結案時,多考慮最後報工日
# Modify.........: No.MOD-8A0066 08/11/24 By liuxqa 結案時，需判斷拆件式工單的入庫單是否已審核過賬，若沒有，則不可結案。
# Modify.........: No.MOD-920098 09/02/10 By chenl  增加報廢日期，并作為結案的判斷條件之一。
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0117 09/12/15 By lilingyu 查詢時未顯示筆數
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No:MOD-A30037 10/03/08 By Sarah 判斷若工單型態為拆件工單與試產工單時,不作mfg5048判斷
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:CHI-A50015 10/05/13 By Summer UPDATE後增加INSERT INTO azo_file
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.TQC-AB0334 10/11/29 By chenying 資料抓取與抓取筆數的sql條件不一致
# Modify.........: No.FUN-AC0074 11/04/25 By shenyang 結案時考慮未發備置量，產生退備單
# Modify.........: No:FUN-9A0095 11/05/11 By abby MES整合追版
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:MOD-B80137 11/08/26 By Vampire 抓 tlf06 時應只撈取 asf
# Modify.........: No:TQC-BB0011 12/01/06 By lilingyu INSERT azo_file時會報錯-391
# Modify.........: No:FUN-C10065 12/02/08 By Abby MES標準整合外的工單無拋轉至MES，但在進行工單結案時卻拋轉MES並回饋工單不存在，導致該類工單結案失敗。 
# Modify.........: No:MOD-C20164 12/02/20 By ck2yuan 對結案,整批結案 加上權限控管
# Modify.........: No:MOD-C30893 12/03/30 By ck2yuan 工單已確認的才可作結案,不只有非作廢
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:TQC-C80043 12/08/10 By lixh1 增加ctrl+g ACTION
# Modify.........: No:CHI-C70042 12/11/07 By bart 檢查不可有小於工單相關庫存異動最後異動日當月的最後一天
# Modify.........: No:CHI-CB0053 12/12/17 By Elise 將g_today 改為 g_closeday
# Modify.........: No:FUN-CC0122 13/01/18 By Nina 修正MES標準整合外的工單無拋轉至MES，但在進行工單變更時卻拋轉MES並回饋工單不存在，導致該類工單變更拋轉失敗
# Modify.........: No:MOD-D10177 13/01/18 By suncx 若委外工單有收貨單,對應的(入庫量+驗退量)>=收貨數量,才可結案
# Modify.........: No:MOD-D10084 13/01/25 By bart 結案日期不可小於最後入庫日期
# Modify.........: No:MOD-D40084 13/04/15 By bart show錯誤訊息並return,應該return前將 g_success = 'N'
# Modify.........: No:CHI-D40028 13/04/16 By bart 修改結案日期條件
# Modify.........: No:MOD-D90056 13/09/14 By Alberti 修正 計算rvv17數量無加總，若入庫單有一筆以上，所撈取的rvv17只會呈現最後一次撈取數量
# Modify.........: No:MOD-DB0150 13/11/22 By suncx 判断如果是第一段发料结案,比对最后发料日和输入的结案日,如果跨月则予以提示,但不控卡;
#                                                  如果是第二段工时结案,则比对最后报工日和输入的结案日, 如果跨月也予以提示, 但不控卡

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
        g_wc,g_sql  STRING,     #WHERE CONDITION  #No.FUN-580092 HCN
	g_argv1	    LIKE sfb_file.sfb01,	#工單編號
	g_sfb	    RECORD
	   sfb01       LIKE sfb_file.sfb01,	#工單編號
           sfb02       LIKE sfb_file.sfb02,	#工單型態
	   sfb04       LIKE sfb_file.sfb04,	#工單狀態
	   sfb05       LIKE sfb_file.sfb05,	#料件編號
	   sfb08       LIKE sfb_file.sfb08,	#生產數量
	   sfb09       LIKE sfb_file.sfb09,	#完工數量
	   sfb10       LIKE sfb_file.sfb10,	#再加工數量
	   sfb11       LIKE sfb_file.sfb11,	#F.Q.C 數量
	   sfb12       LIKE sfb_file.sfb12,	#報廢數量
	   sfb13       LIKE sfb_file.sfb13,	#開工日期
	   sfb15       LIKE sfb_file.sfb15,	#完工日期
	   sfb17       LIKE sfb_file.sfb17,	#已完工作業序號
	   sfb18       LIKE sfb_file.sfb18,	#最近完工日期
	   sfb19       LIKE sfb_file.sfb19,	#最近一次完工作業時間(時:分)
	   sfb25       LIKE sfb_file.sfb25,	#最近發料日期
           sfb26       LIKE sfb_file.sfb26,	#發料日期
	   sfb28       LIKE sfb_file.sfb28,	#close_the_case狀案
	   sfb36       LIKE sfb_file.sfb36,	#發料結束日期
	   sfb37       LIKE sfb_file.sfb37,	#發料及工時結束日期
	   sfb38       LIKE sfb_file.sfb38 	#成本會計結束日期
	            END RECORD
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680121 SMALLINT   #No.FUN-6A0071
DEFINE   l_flag         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_sfk02        LIKE sfk_file.sfk02        #No.MOD-920098  最近報廢日期
DEFINE   g_sfb02        LIKE sfb_file.sfb02          #FUN-C10065 add
DEFINE   g_closeday     LIKE type_file.dat           #CHI-CB0053 add
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
   LET g_argv1 = ARG_VAL(1)         	   #參數值(1) W/O#
   LET g_closeday = g_today                #CHI-CB0053 add
 
   OPEN WINDOW p400_w WITH FORM "asf/42f/asfp400" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
#CHI-C70042---begin   
#   OPEN WINDOW p400_cw WITH FORM "asf/42f/asfp400c" 
#        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
# 
#   CALL cl_ui_locale("asfp400c")
#        
#   INPUT BY NAME g_today WITHOUT DEFAULTS
#      AFTER FIELD g_today
#         IF g_today IS NULL THEN
#            NEXT FIELD g_today 
#         END IF
#         IF g_today <= g_sma.sma53 THEN 
#            CALL cl_err(g_today,'axm-164',0)
#            NEXT FIELD g_today
#         END IF 
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION exit                            #加離開功能
#         LET INT_FLAG = 1
#         EXIT INPUT     
#   
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
# 
#   END INPUT
# 
#   IF INT_FLAG THEN
#      EXIT PROGRAM
#   END IF
# 
#   CLOSE WINDOW p400_cw
#CHI-C70042---end
   IF NOT cl_null(g_argv1) THEN
      CALL p400_q()
   END IF
 
   WHILE TRUE      ##040512      # MOD-480415 
      LET g_action_choice=""
      CALL p400_menu()
       IF g_action_choice="exit" THEN EXIT WHILE END IF  ##040512 #MOD-480415 
      IF l_flag THEN
          CONTINUE WHILE         # MOD-480415 
      ELSE
          EXIT WHILE             # MOD-480415 
      END IF
   END WHILE       ##040512      # MOD-480415 
 
   CLOSE WINDOW p400_w               #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818
 
END MAIN
 
#QBE 查詢資料
FUNCTION p400_cs()
   DEFINE   l_cnt LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   LET g_sql=" SELECT sfb01 FROM sfb_file",
             " WHERE (sfb04 != '8' OR ( sfb04 ='8' AND sfb28 != '3' OR sfb28 IS NULL))",
            #" AND sfb87!='X' "  #No:8769    #MOD-C30893 mark
             " AND sfb87 ='Y' "   #MOD-C30893 add
   IF NOT cl_null(g_argv1) THEN
	  LET g_sql = g_sql CLIPPED," AND sfb01 = '",g_argv1,"'"
   ELSE
   INITIALIZE g_sfb.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON  				# 螢幕上取單頭條件
                sfb01,sfb05,sfb02,sfb13,sfb04,sfb15,sfb25,sfb26,
                sfb17,sfb18,sfb19,sfb08,sfb09,sfb10,sfb12,sfb11,
                sfb36,sfb37,sfb38,sfb28 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION CONTROLP  
           IF INFIELD(sfb01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_sfb902"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb01
              NEXT FIELD sfb01
           END IF
           IF INFIELD(sfb05) THEN
#FUN-AA0059---------mod------------str-----------------           
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima"
#              LET g_qryparam.state = "c"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
              DISPLAY g_qryparam.multiret TO sfb05
              NEXT FIELD sfb05
           END IF
      
         ON ACTION qbe_select
            CALL cl_qbe_select()

#TQC-C80043 ----Begin-----
         ON ACTION CONTROLG
            CALL cl_cmdask()
#TQC-C80043 ----End-------
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   	  IF INT_FLAG THEN RETURN END IF
	  LET g_sql = g_sql CLIPPED," AND ",g_wc CLIPPED
   END IF
   LET g_sql = g_sql CLIPPED," ORDER BY sfb01"
   PREPARE p400_prepare FROM g_sql
   IF STATUS THEN CALL cl_err('p1:',STATUS,1) RETURN END IF
   DECLARE p400_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR p400_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM sfb_file",
             " WHERE (sfb04 != '8' OR ( sfb04 ='8' AND sfb28 != '3' OR sfb28 IS NULL))",
#            "   AND sfb02 != 7 "   #TQC-AB0334 mark
            #"   AND sfb87!='X' "   #TQC-AB0334 add     #MOD-C30893 mark
             "   AND sfb87 ='Y' "   #MOD-C30893 add
   IF NOT cl_null(g_argv1) THEN
	  LET g_sql = g_sql CLIPPED," AND sfb01 = '",g_argv1,"'"
   ELSE
	  LET g_sql = g_sql CLIPPED," AND ",g_wc CLIPPED
   END IF
   PREPARE p400_precount FROM g_sql
   DECLARE p400_count CURSOR FOR p400_precount
END FUNCTION
 
#中文的MENU
FUNCTION p400_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL p400_q()
            END IF
 
        ON ACTION close_the_case 
           LET g_action_choice="close_the_case"     #MOD-C20164 add
           IF cl_chk_act_auth() THEN                #MOD-C20164 add
              IF cl_null(g_argv1) THEN
                 CALL p400_close()

                #FUN-9A0095 add begin ------
                 IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
                   #FUN-C10065 add str---
                    SELECT sfb02 INTO g_sfb02
                      FROM sfb_file
                     WHERE sfb01 = g_sfb.sfb01
                    IF g_sfb02 = '1' OR g_sfb02 = '5' OR g_sfb02 = '13' THEN    #FUN-CC0122 add g_sfb02 = '5'
                   #FUN-C10065 add end---
                       CALL p400_mes(g_sfb.sfb01)
                    END IF   #FUN-C10065 add
                 END IF
                #FUN-9A0095 add end --------

                 CALL s_showmsg()                           #NO.FUN-710026
                 IF g_success = 'Y' THEN
                    COMMIT WORK
                    CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
                 ELSE 
                    ROLLBACK WORK
                    CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
                 END IF
                 EXIT MENU
              END IF
           END IF                                   #MOD-C20164 add
 
        ON ACTION batch_w_o_close 
           LET g_action_choice="batch_w_o_close"    #MOD-C20164 add
           IF cl_chk_act_auth() THEN                #MOD-C20164 add
              IF cl_null(g_argv1) THEN
                 CALL cl_cmdrun_wait('asfp401 ')  #FUN-660216 add
              END IF
           END IF                                   #MOD-C20164 add
        ON ACTION help 
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION first 
           CALL p400_fetch('F')
 
        ON ACTION previous
           CALL p400_fetch('P')
 
        ON ACTION jump 
           CALL p400_fetch('/')
 
        ON ACTION next
           CALL p400_fetch('N')
 
        ON ACTION last 
           CALL p400_fetch('L')
 
#TQC-C80043 ----Begin-----
         ON ACTION CONTROLG
            CALL cl_cmdask()
#TQC-C80043 ----End-------

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
    END MENU
END FUNCTION
 
FUNCTION p400_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL p400_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN p400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN p400_count
        FETCH p400_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cn2         #TQC-9C0117        
        CALL p400_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION p400_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10,                #絕對的筆數        #No.FUN-680121 INTEGER
    l_sfbuser       LIKE sfb_file.sfbuser, #FUN-4C0035 add
    l_sfbgrup       LIKE sfb_file.sfbgrup  #FUN-4C0035 add
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p400_cs INTO g_sfb.sfb01
        WHEN 'P' FETCH PREVIOUS p400_cs INTO g_sfb.sfb01
        WHEN 'F' FETCH FIRST    p400_cs INTO g_sfb.sfb01
        WHEN 'L' FETCH LAST     p400_cs INTO g_sfb.sfb01
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0071
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump p400_cs INTO g_sfb.sfb01
            LET mi_no_ask = FALSE   #No.FUN-6A0071
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       DISPLAY g_curs_index TO FORMONLY.cn    #TQC-9C0117    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09,sfb10,sfb11,
		sfb12,sfb13,sfb15,sfb17,sfb18,sfb19,sfb25,sfb26,sfb28,
		sfb36,sfb37,sfb38,sfbuser,sfbgrup    #FUN-4C0035 add
      INTO g_sfb.*,l_sfbuser,l_sfbgrup               #FUN-4C0035 add
      FROM sfb_file 
     WHERE sfb01 = g_sfb.sfb01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660128
       INITIALIZE g_sfb.* TO NULL        #FUN-4C0035
    ELSE 
       LET g_data_owner = l_sfbuser      #FUN-4C0035
       LET g_data_group = l_sfbgrup      #FUN-4C0035
       CALL p400_show()
    END IF
 
END FUNCTION
 
FUNCTION p400_show()
   DEFINE l_d1,l_d2	 LIKE type_file.chr20          
   DISPLAY BY NAME g_sfb.sfb01,g_sfb.sfb05,g_sfb.sfb02, #顯示值
				   g_sfb.sfb13,g_sfb.sfb04,g_sfb.sfb15,
				   g_sfb.sfb25,g_sfb.sfb26,g_sfb.sfb17,
				   g_sfb.sfb18,g_sfb.sfb19,g_sfb.sfb08,
				   g_sfb.sfb09,g_sfb.sfb10,g_sfb.sfb12,
				   g_sfb.sfb11,g_sfb.sfb36,
				   g_sfb.sfb37,g_sfb.sfb38,g_sfb.sfb28 
   CALL p400_sfb05('d')
   CALL p400_sfk02(g_sfb.sfb01)    #No.MOD-920098 
   CALL s_wotype(g_sfb.sfb02) RETURNING l_d1
   CALL s_wostatu(g_sfb.sfb04) RETURNING l_d2
   DISPLAY l_d1,l_d2 TO FORMONLY.d1,FORMONLY.d2
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION  p400_sfb05(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_ima02         LIKE ima_file.ima02,
    l_ima05         LIKE ima_file.ima05,
    l_ima08         LIKE ima_file.ima08,
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima05,ima08,imaacti
        INTO l_ima02,l_ima05,l_ima08,l_imaacti
        FROM ima_file WHERE ima01 = g_sfb.sfb05
	CASE 
		WHEN l_imaacti = 'N' LET g_errno = '9027'
                WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
                WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg0002'
		OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
	END CASE
    DISPLAY l_ima02 TO ima02
    DISPLAY l_ima05 TO ima05
    DISPLAY l_ima08 TO ima08
END FUNCTION
 
FUNCTION p400_close()              #CLOSE
DEFINE l_qty,l_qty_h,l_qty_l	LIKE sfb_file.sfb09,
       l_qty_d	LIKE sfb_file.sfb09,
       l_sfa03  LIKE sfa_file.sfa03,
       l_sfa05  LIKE sfa_file.sfa05,
       l_sfa06  LIKE sfa_file.sfa06,
       l_sfa13  LIKE sfa_file.sfa13,
       l_sfa25  LIKE sfa_file.sfa25,
       l_sfa01  LIKE sfa_file.sfa01,l_sfa08  LIKE sfa_file.sfa08,l_sfa12  LIKE sfa_file.sfa12, 
       l_sfa012 LIKE sfa_file.sfa012,#FUN-A60027
       l_sfa013 LIKE sfa_file.sfa013,#FUN-A60027 
       l_pmn01  LIKE pmn_file.pmn01, #FUN-5C0044
       l_pmn02  LIKE pmn_file.pmn02, #FUN-5C0044
       l_pmn16  LIKE pmn_file.pmn16, #FUN-5C0044
       l_sql    LIKE type_file.chr1000,          #No.MOD-780244 add
       l_pmm01  LIKE pmm_file.pmm01, #No.MOD-780244 add
       l_pmm25  LIKE pmm_file.pmm25, #No.MOD-780244 add
#      l_qty1   LIKE ima_file.ima26,              #No.FUN-680121 DECIMAL(13,3) #FUN-5C0044
       l_qty1   LIKE type_file.num15_3,           ###GP5.2  #NO.FUN-A20044
       l_sta    LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1) #FUN-5C0044
       l_cnt    LIKE type_file.num5,              #FUN-5C0044        #No.FUN-680121 SMALLINT
       l_tlf06  LIKE tlf_file.tlf06,              #FUN-650116 add
       l_sfb81  LIKE sfb_file.sfb81               #FUN-650116 add
DEFINE l_cci01  LIKE cci_file.cci01,              #MOD-890064 add
       l_shb03  LIKE shb_file.shb03               #MOD-890064 add
DEFINE l_msg    STRING                            #No.MOD-850102
DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
DEFINE l_msg1    LIKE type_file.chr1000     #CHI-A50015 add
DEFINE l_msg2    LIKE type_file.chr1000     #CHI-A50015 add
DEFINE l_sie11   LIKE sie_file.sie11        #FUN-AC0074
DEFINE l_bdate   LIKE type_file.dat  #CHI-C70042
DEFINE l_edate   LIKE type_file.dat  #CHI-C70042
DEFINE l_yy      LIKE type_file.num5  #CHI-C70042
DEFINE l_mm      LIKE type_file.num5  #CHI-C70042
DEFINE l_correct LIKE type_file.chr1  #CHI-C70042
#MOD-D10177 add---S
DEFINE l_rvv17a LIKE rvv_file.rvv17,
       l_rvv17b LIKE rvv_file.rvv17,
       l_rvb07  LIKE rvb_file.rvb07
#MOD-D10177 add---E
DEFINE l_rvu03   LIKE rvu_file.rvu03  #MOD-D10084
#MOD-DB0150 add begin----------------------------
DEFINE l_yy_j    LIKE type_file.num5 
DEFINE l_yy1     LIKE type_file.num5
DEFINE l_mm_j    LIKE type_file.num5
DEFINE l_mm1     LIKE type_file.num5
DEFINE l_f       BOOLEAN 
DEFINE l_flag    LIKE type_file.chr1
DEFINE l_sfp03   LIKE sfp_file.sfp03
#MOD-DB0150 add end------------------------------

   IF g_sfb.sfb01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF   
 
   IF g_sma.sma72 = 'Y' THEN
      IF g_sfb.sfb28 = '2' THEN 
         CALL cl_err('','asf-829',1) 
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   #CHI-C70042---begin
   #SELECT MAX(tlf07) #CHI-D40028
   SELECT MAX(tlf06)
     INTO l_edate
     FROM tlf_file
     WHERE tlf62 = g_sfb.sfb01
   #CHI-D40028---begin
   #IF NOT cl_null(l_edate) THEN  
   #   CALL s_yp(l_edate) RETURNING l_yy,l_mm
   #   CALL s_azm(l_yy,l_mm) RETURNING l_correct, l_bdate, l_edate
   #   IF g_closeday <= l_edate THEN     #CHI-CB0053 mod g_today->g_closeday 
   #      LET g_closeday = l_edate + 1   #CHI-CB0053 mod g_today->g_closeday
   #   END IF 
   #END IF 
   LET g_closeday = g_today
   #CHI-D40028---end
   
   OPEN WINDOW p400_cw WITH FORM "asf/42f/asfp400c" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("asfp400c")
        
   INPUT BY NAME g_closeday WITHOUT DEFAULTS   #CHI-CB0053 mod g_today->g_closeday
      AFTER FIELD g_closeday                   #CHI-CB0053 mod g_today->g_closeday
         IF g_closeday IS NULL THEN            #CHI-CB0053 mod g_today->g_closeday
            NEXT FIELD g_closeday              #CHI-CB0053 mod g_today->g_closeday
         END IF
         IF g_closeday <= g_sma.sma53 THEN        #CHI-CB0053 mod g_today->g_closeday
            CALL cl_err(g_closeday,'axm-164',0)   #CHI-CB0053 mod g_today->g_closeday
            NEXT FIELD g_closeday                 #CHI-CB0053 mod g_today->g_closeday
         END IF
         #CHI-D40028---begin
         IF g_sma.sma72 = 'Y' THEN
            IF g_sfb.sfb28 = '1' THEN
               IF g_closeday < g_sfb.sfb36 THEN
                  CALL cl_err(g_closeday,'asf-352',0)
                  NEXT FIELD g_closeday  
               END IF 
            END IF 
         END IF 
         #CHI-D40028---end
         IF g_sma.sma72 = 'N' THEN  #CHI-D40028
            IF NOT cl_null(l_edate) THEN 
               #IF g_closeday <= l_edate THEN            #CHI-CB0053 mod g_today->g_closeday  #CHI-D40028
               IF g_closeday < l_edate THEN  #CHI-D40028
                  LET l_msg = g_closeday,'<=',l_edate   #CHI-CB0053 mod g_today->g_closeday
                  CALL cl_err(l_msg,'asf-263',0)
                  NEXT FIELD g_closeday                 #CHI-CB0053 mod g_today->g_closeday
               END IF 
            END IF 
         END IF  #CHI-D40028
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT     
   
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success ='N'
      CLOSE WINDOW p400_cw
      RETURN
   END IF
 
   CLOSE WINDOW p400_cw
   #CHI-C70042---end
   
   IF s_shut(0) THEN RETURN END IF
   IF NOT cl_sure(0,0) THEN RETURN END IF
 
   LET l_msg = NULL
   CALL p400_doc_chk() RETURNING l_msg
   IF NOT cl_null(l_msg) THEN 
      LET l_msg = l_msg, '\t'
      CALL cl_err(l_msg,'asf-794',1)
      LET g_success ='N'
      RETURN 
   END IF
#MOD-DB0150 add begin-----------------------------
   IF g_sma.sma72 = 'Y' THEN
      CALL s_yp(g_closeday) RETURNING l_yy_j,l_mm_j
      SELECT MAX(sfp03) INTO l_sfp03 FROM sfp_file,sfe_file
       WHERE sfp01 = sfe02 AND sfe01 = g_sfb.sfb01
         AND sfp04 = 'Y'   AND sfpconf = 'Y'
         AND sfp06 IN ('1','2','3','4','D')  
      CALL s_yp(l_sfp03) RETURNING l_yy1,l_mm1
      LET l_f = FALSE
      IF l_yy_j = l_yy1 THEN
         IF l_mm_j != l_mm1 THEN
            LET l_f = TRUE
         END IF
      ELSE
         LET l_f = TRUE
      END IF
      IF l_f AND cl_null(g_sfb.sfb28) THEN
         CALL cl_confirm('asf1168') RETURNING l_flag
         IF NOT l_flag THEN
            LET g_success ='N'
            RETURN
         END IF
      END IF
   END IF
#MOD-DB0150 add end-------------------------------
   #判斷若輸入的結案日期小於最後異動日則不予結案
   SELECT max(tlf06) INTO l_tlf06 FROM tlf_file
    WHERE tlf62=g_sfb.sfb01
      AND (tlf02=50 OR tlf03=50)
      AND tlf13[1,3]='asf'       #MOD-B80137 add
   SELECT sfb81 INTO l_sfb81 FROM sfb_file WHERE sfb01=g_sfb.sfb01
   IF l_tlf06 is null THEN LET l_tlf06=l_sfb81 END IF
   IF l_tlf06 is null THEN LET l_tlf06=g_sfb.sfb13 END IF
   IF g_closeday < l_tlf06 THEN     #CHI-CB0053 mod g_today->g_closeday
      CALL cl_err('','asf-974',1)   #結案日期不可小於最後異動日！
      LET g_success ='N'  #MOD-D40084
      RETURN
   END IF
 
   SELECT max(shb03) INTO l_shb03 FROM shb_file
    WHERE shb05=g_sfb.sfb01
      AND shbconf = 'Y'    #FUN-A70095
   IF l_shb03 is null THEN LET l_shb03=l_sfb81 END IF
   IF g_closeday < l_shb03 THEN     #CHI-CB0053 mod g_today->g_closeday
      CALL cl_err('','asf-974',1)   #結案日不可小於最後報工日
      LET g_success ='N'  #MOD-D40084
      RETURN
   END IF
#MOD-DB0150 add begin-----------------------------
   IF g_sma.sma72 = 'Y' THEN
      CALL s_yp(l_shb03) RETURNING l_yy1,l_mm1
      LET l_f = FALSE
      IF l_yy_j = l_yy1 THEN
         IF l_mm_j != l_mm1 THEN
            LET l_f = TRUE
         END IF
      ELSE
         LET l_f = TRUE
      END IF
      IF l_f AND g_sfb.sfb28='1' THEN
         CALL cl_confirm('asf1169') RETURNING l_flag
         IF NOT l_flag THEN
            LET g_success ='N'
            RETURN
         END IF
      END IF
   END IF
#MOD-DB0150 add end-------------------------------
   SELECT MAX(cci01) INTO l_cci01 FROM cci_file,ccj_file
    WHERE cci01=ccj01 AND ccj04=g_sfb.sfb01
      AND ccifirm = 'Y' 
   IF l_cci01 is null THEN LET l_cci01=l_sfb81 END IF
   IF g_closeday < l_cci01 THEN     #CHI-CB0053 mod g_today->g_closeday
      CALL cl_err('','asf-974',1)   #結案日不可小於最後報工日
      LET g_success ='N'  #MOD-D40084
      RETURN
   END IF 

   #MOD-D10084---begin
   #結案日期不可小於最後入庫日期
   SELECT MAX(rvu03) INTO l_rvu03
     FROM rvv_file,rvu_file
    WHERE rvv01 = rvu01 
      AND rvu08 = 'SUB'
      AND rvv18 = g_sfb.sfb01
      AND rvuconf <> 'X'
   IF cl_null(l_rvu03) THEN
      LET l_rvu03 = l_sfb81
   END IF 
   IF g_closeday < l_rvu03 THEN
      CALL cl_err('','asf-247',1)
      LET g_success ='N'  #MOD-D40084
      RETURN
   END IF 
   #MOD-D10084---end
 
  IF g_closeday < g_sfk02 THEN      #CHI-CB0053 mod g_today->g_closeday
     CALL cl_err('','asf-979',1)     #結案日不可小于最近報廢日期。
     LET g_success ='N'  #MOD-D40084
     RETURN 
  END IF
 #MOD-D10177---add---S
   #委外工單有收貨單
   LET l_cnt = 0
   SELECT COUNT(rvb01) INTO l_cnt FROM rvb_file
    WHERE rvb34 = g_sfb.sfb01
   LET l_rvv17a =0
  #SELECT rvv17 INTO l_rvv17a FROM rvv_file,rvu_file   #如委外入庫(apmt730)為多張，數量會有誤  #MOD-D90056 mark
   SELECT SUM(rvv17) INTO l_rvv17a FROM rvv_file,rvu_file                                  #MOD-D90056 add
    WHERE rvv01 = rvu01
      AND rvv18 = g_sfb.sfb01
      AND rvu00 ='1'                  #入庫量
      AND rvv31 = g_sfb.sfb05
   IF cl_null(l_rvv17a) THEN LET l_rvv17a = 0 END IF                       #MOD-D90056 add

   IF l_cnt > 0 AND l_rvv17a <= 0   THEN  #委外工單有收貨單，但未有入庫，不能結案
      LET g_success= 'N'
     #CALL cl_err('','asf006',1)      #MOD-D90056 mark
      CALL cl_err('','asf1160',1)     #MOD-D90056 add
      RETURN
   ELSE
      #(入庫量+驗退量)>=收貨數量 才可結案
      LET l_rvv17b =0
     #SELECT rvv17 INTO l_rvv17b FROM rvv_file,rvu_file                    #MOD-D90056 mark
      SELECT SUM(rvv17) INTO l_rvv17b FROM rvv_file,rvu_file               #MOD-D90056 add
       WHERE rvv01 = rvu01
         AND rvv18 = g_sfb.sfb01
         AND rvu00 ='2'                  #驗退量
         AND rvv31 = g_sfb.sfb05
      IF cl_null(l_rvv17b) THEN LET l_rvv17b = 0 END IF

      LET l_rvb07 =0
     #SELECT rvb07 INTO l_rvb07 FROM rvb_file    #收貨數量                  #MOD-D90056 mark
      SELECT SUM(rvb07) INTO l_rvb07 FROM rvb_file,rva_file    #收貨數量             #MOD-D90056 add
       WHERE rvb34 = g_sfb.sfb01
         AND rvb05 = g_sfb.sfb05
         and rva01= rvb01 and rvaconf !='X' #darcy add 221128
      IF cl_null(l_rvb07) THEN LET l_rvb07 = 0 END IF                     #MOD-D90056 add

      IF (l_rvv17a + l_rvv17b) < l_rvb07 THEN
         LET g_success= 'N'
        #CALL cl_err('','asf005',1)                                       #MOD-D90056 mark
         CALL cl_err('','asf1161',1)                                      #MOD-D90056 add
         RETURN
      END IF
   END IF
   #MOD-D10177---add---E
 
   IF g_sma.sma73 = 'Y' THEN			#工單數量是否作勾稽
      IF g_sfb.sfb02 != '11' AND g_sfb.sfb02 != '15' THEN   #MOD-A30037 add
         CALL s_get_ima153(g_sfb.sfb05) RETURNING l_ima153  #FUN-910053  
         LET l_qty = g_sfb.sfb09+g_sfb.sfb10+g_sfb.sfb11+g_sfb.sfb12
         LET l_qty_l = g_sfb.sfb08 * (100-l_ima153)/100
         LET l_qty_h = g_sfb.sfb08 * (100+l_ima153)/100
         IF l_qty > l_qty_h OR l_qty < l_qty_l THEN
            CALL cl_getmsg('mfg5048',g_lang) RETURNING g_msg
            IF NOT cl_prompt(0,0,g_msg) THEN 
               LET g_success ='N'  #MOD-D40084
               RETURN 
            END IF
         END IF
      END IF   #MOD-A30037 add
   END IF
 
   IF g_sma.sma72 = 'Y' THEN
      CASE g_sfb.sfb28
         WHEN '1' LET g_sfb.sfb28 = '2'
         WHEN '2' LET g_sfb.sfb28 = '3'
         WHEN '3' LET g_sfb.sfb28 = '3'
         OTHERWISE LET g_sfb.sfb28 = '1'
      END CASE
   ELSE
      LET g_sfb.sfb36=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      LET g_sfb.sfb37=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      LET g_sfb.sfb38=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      LET g_sfb.sfb28 = '3'
   END IF
   CASE g_sfb.sfb28
      WHEN '1' LET g_sfb.sfb36=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      WHEN '2' LET g_sfb.sfb37=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      WHEN '3' LET g_sfb.sfb38=g_closeday   #CHI-CB0053 mod g_today->g_closeday
      OTHERWISE EXIT CASE
   END CASE
 
   LET g_success = 'Y'
   BEGIN WORK
   LET l_qty = g_sfb.sfb09+g_sfb.sfb10+g_sfb.sfb11+g_sfb.sfb12
   IF cl_null(g_sfb.sfb08) THEN LET g_sfb.sfb08=0 END IF
   IF l_qty < g_sfb.sfb08 THEN
       LET l_qty_d = g_sfb.sfb08 - l_qty
   ELSE     
       LET l_qty_d = 0                  
   END IF   
   UPDATE sfb_file SET sfb28=g_sfb.sfb28,sfb36=g_sfb.sfb36,
         	       sfb37=g_sfb.sfb37,sfb38=g_sfb.sfb38,
                       sfb04='8'
                   ,sfbdate = g_today #darcy:2024/05/09 add
        	 WHERE sfb01 = g_sfb.sfb01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('sfb01',g_sfb.sfb01,'Update sfb28,sfb04 fail:',SQLCA.sqlcode,0)                 #NO.FUN-710026
      LET g_success = 'N'
      RETURN
   END IF
   #CHI-A50015 add --start--
   LET g_msg=TIME

#TQC-BB0011 --begin--
#   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
#        VALUES ('asfp400',g_user,g_today,g_msg,g_sfb_sfb01,'UPDATE sfb_file')

   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
        VALUES ('asfp400',g_user,g_today,g_msg,g_sfb_sfb01,'UPDATE sfb_file',g_plant,g_legal)
#TQC-BB0011 --end--

   #CHI-A50015 add --end--
   DECLARE pmn_cur CURSOR FOR
   SELECT pmn01,pmn02,pmn50-pmn20-pmn55,pmn16 FROM pmn_file,pmm_file
    WHERE pmm01=pmn01 AND pmm18<>'X' AND pmn41 = g_sfb.sfb01 
   CALL s_showmsg_init()    #NO.FUN-710026
   FOREACH pmn_cur INTO l_pmn01,l_pmn02,l_qty1,l_pmn16
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
 
      IF l_pmn16 MATCHES '[678]' THEN CONTINUE FOREACH END IF
      CASE
          WHEN l_qty1 = 0 LET  l_sta = '6'
          WHEN l_qty1 > 0 LET  l_sta = '7'
          WHEN l_qty1 < 0 LET  l_sta = '8'
          OTHERWISE EXIT CASE
      END CASE
      UPDATE pmn_file SET pmn16 = l_sta, pmn57=l_qty1
       WHERE pmn01 = l_pmn01 AND pmn02 = l_pmn02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
          LET g_showmsg=l_pmn01,"/",l_pmn02                                                         #NO.FUN-710026
          CALL s_errmsg('pmn01,pmn02',g_showmsg,'Update pmn16 error:',SQLCA.sqlcode,1)              #NO.FUN-710026
          LET g_success = 'N' 
          CONTINUE FOREACH                                                                          #NO.FUN-710026
      END IF
      #CHI-A50015 add --start--
      SELECT ze03 INTO l_msg2 FROM ze_file
          WHERE ze01 = 'aap-417' AND ze02 = g_lang
      LET l_msg1 = "UPDATE pmn_file,",l_msg2,":",l_pmn02 CLIPPED
      LET g_msg=TIME

#TQC-BB0011 --begin--
#   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
#        VALUES ('asfp400',g_user,g_today,g_msg,l_pmn01,l_msg1)

   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
            VALUES ('asfp400',g_user,g_today,g_msg,l_pmn01,l_msg1,g_plant,g_legal)
#TQC-BB0011 --end--

      #CHI-A50015 add --end--
   END FOREACH
   LET l_sql = "SELECT pmm01,pmm25 ",         #組合查詢句子
               " FROM pmm_file,pmn_file ",
               " WHERE pmm01=pmn01 ",
               "  AND  pmn41=? "
   PREPARE pmm_prepare FROM l_sql                 
   IF SQLCA.sqlcode THEN                          #有問題了
       CALL cl_err('PREPARE pmm_cs:',SQLCA.sqlcode,1)
       LET g_success = 'N' 
   END IF
   DECLARE pmm_cs CURSOR FOR pmm_prepare  #宣告之
   FOREACH pmm_cs  USING g_sfb.sfb01 INTO l_pmm01,l_pmm25  
       IF l_pmm25='6' THEN CONTINUE FOREACH END IF
 
       SELECT COUNT(*) INTO l_cnt FROM pmn_file
        WHERE pmn01 = l_pmm01 AND (pmn16 ='0' OR pmn16='1' OR pmn16='2')   
 
       IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
       IF l_cnt = 0  THEN
          UPDATE pmm_file SET pmm25 = '6'
           WHERE pmm01 = l_pmm01
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
             CALL s_errmsg('pmm01',l_pmm01,'Update pmm25 fail:',SQLCA.sqlcode,1)              
             LET g_success = 'N'
          END IF
          #CHI-A50015 add --start--
          LET g_msg=TIME
#TQC-BB0011 --begin--
#          INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
#               VALUES ('asfp400',g_user,g_today,g_msg,l_pmm01,'UPDATE pmm_file')

          INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
               VALUES ('asfp400',g_user,g_today,g_msg,l_pmm01,'UPDATE pmm_file',g_plant,g_legal)
#TQC-BB0011 --end--
          #CHI-A50015 add --end--
       END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
 
   DECLARE l_cc CURSOR FOR SELECT sfa01,sfa08,sfa12,sfa03,sfa05,sfa06,sfa25,sfa13,sfa012,sfa013   #FUN-A60027 add sfa012,sfa013 
                FROM sfa_file WHERE sfa01 = g_sfb.sfb01
   FOREACH l_cc INTO l_sfa01,l_sfa08,l_sfa12,l_sfa03,l_sfa05,l_sfa06,l_sfa25,l_sfa13,l_sfa012,l_sfa013    #FUN-A60027 add l_sfa012,l_sfa013
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
 
      UPDATE sfa_file SET sfa25 = l_sfa05 - l_sfa06 
       WHERE sfa_file.sfa01 = l_sfa01 AND sfa_file.sfa03 = l_sfa03 AND sfa_file.sfa08 = l_sfa08 AND sfa_file.sfa12 = l_sfa12
         AND sfa_file.sfa012 = l_sfa012 AND sfa_file.sfa013 = l_sfa013      #FUN-A60027 add  
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('sfa_file.sfa01',l_sfa01,'Update sfa25 fail:',SQLCA.sqlcode,1)      #NO.FUN-710026
         LET g_success = 'N'
      END IF
      #CHI-A50015 add --start--
      SELECT ze03 INTO l_msg2 FROM ze_file
          WHERE ze01 = 'asr-009' AND ze02 = g_lang
      LET l_msg1 = "UPDATE sfa_file,",l_msg2,":",l_sfa03 CLIPPED
      LET g_msg=TIME
#TQC-BB0011 --begi--
#      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
#             VALUES ('asfp400',g_user,g_today,g_msg,l_sfa01,l_msg1)

      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)
             VALUES ('asfp400',g_user,g_today,g_msg,l_sfa01,l_msg1,g_plant,g_legal)
#TQC-BB0011 --end--
      #CHI-A50015 add --end--
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
   #FUN-AC0074--add--begin

   SELECT SUM(sie11) INTO l_sie11 FROM sie_file
     WHERE  sie05 = g_sfb.sfb01
   IF l_sie11 >0 THEN
      CALL p400_yes()
   END IF
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
   #FUN-AC0074--add--end 
   DISPLAY BY NAME g_sfb.sfb28,g_sfb.sfb36,g_sfb.sfb37,g_sfb.sfb38
    SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09,sfb10,sfb11,
		sfb12,sfb13,sfb15,sfb17,sfb18,sfb19,sfb25,sfb26,sfb28,
		sfb36,sfb37,sfb38
      INTO g_sfb.*
      FROM sfb_file 
     WHERE sfb01 = g_sfb.sfb01
     CALL p400_show()
END FUNCTION

#FUN-AC0074--add--begin
FUNCTION p400_yes()
DEFINE  l_sia  RECORD LIKE sia_file.*
DEFINE  l_sie   DYNAMIC ARRAY OF RECORD 
                sie01   LIKE sie_file.sie01,
                sie02   LIKE sie_file.sie02,
                sie03   LIKE sie_file.sie03,
                sie04   LIKE sie_file.sie04,
                sie05   LIKE sie_file.sie05,
                sie06   LIKE sie_file.sie06,
                sie07   LIKE sie_file.sie07,
                sie08   LIKE sie_file.sie08,
                sie09   LIKE sie_file.sie09, 
                sie10   LIKE sie_file.sie10,
                sie11   LIKE sie_file.sie11,
                sie12   LIKE sie_file.sie12,
                sie13   LIKE sie_file.sie13,
                sie14   LIKE sie_file.sie14,
                sie15   LIKE sie_file.sie15,
                sie16   LIKE sie_file.sie16,
                sie012  LIKE sie_file.sie012,
                sie013  LIKE sie_file.sie013
                END RECORD   
DEFINE l_ac         LIKE type_file.num5 
DEFINE g_sql        STRING              
DEFINE li_result    LIKE type_file.num5
DEFINE l_err        STRING
DEFINE l_flag      LIKE type_file.chr1 
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE l_fac       LIKE ima_file.ima31_fac
DEFINE l_sic07_fac LIKE sic_file.sic07_fac
DEFINE l_void          LIKE type_file.chr1
DEFINE l_sic02     LIKE sic_file.sic02
  
      LET l_sia.sia04 ='2'
      LET l_sia.sia05 = '2'
      LET l_sia.sia02 =g_today
      LET l_sia.sia03 =g_today
      LET l_sia.siaacti = 'Y'
      LET l_sia.siaconf = 'N'
      LET l_sia.siauser = g_user
      LET l_sia.siaplant = g_plant
      LET l_sia.siadate = g_today
      LET l_sia.sialegal = g_legal
      LET l_sia.siagrup = g_grup
      LET l_sia.siaoriu = g_user
      LET l_sia.siaorig = g_grup    
      LET l_sia.sia06 = g_grup 
         LET g_sql=" SELECT MAX(smyslip) FROM smy_file",
                   "  WHERE smysys = 'asf' AND smykind='5' ",
                   "    AND length(smyslip) = ",g_doc_len
         PREPARE p410_smy FROM g_sql
         EXECUTE p410_smy INTO l_sia.sia01
        CALL s_auto_assign_no("asf",l_sia.sia01,l_sia.sia02,"","sia_file","sia01","","","")
            RETURNING li_result,l_sia.sia01
        IF (NOT li_result) THEN
            LET g_success='N'
            RETURN
        END IF
      INSERT INTO sia_file(sia01,sia02,sia03,sia04,sia05,sia06,siaacti,
                    siaconf,siauser,siaplant,
                     siadate,sialegal,siagrup,siaoriu,siaorig) 
             VALUES (l_sia.sia01,l_sia.sia02,l_sia.sia03,l_sia.sia04,l_sia.sia05,g_grup,l_sia.siaacti,
                     l_sia.siaconf,l_sia.siauser,l_sia.siaplant,
                     l_sia.siadate,l_sia.sialegal,l_sia.siagrup,l_sia.siaoriu ,l_sia.siaorig)
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("ins","sia_file",l_sia.sia01,l_sia.sia02,l_err,"","ins sia:",1)
         LET g_success = 'N'
         RETURN
      END IF 
      LET l_ac =1 
      LET g_sql =
             "SELECT sie01,sie02,sie03,sie04,sie05,sie06,sie07,sie08,sie09,sie10,sie11,sie12,sie13,sie14,sie15,sie16,sie012,sie013",
             " FROM sie_file",
             " WHERE sie05 = '",g_sfb.sfb01,"' AND sie11 > 0 "
      PREPARE p400_pb2 FROM g_sql
      DECLARE sie_curs2 CURSOR FOR p400_pb2
      FOREACH sie_curs2  INTO l_sie[l_ac].*
         SELECT ima25 INTO l_ima25 FROM ima_file
           WHERE ima01 = l_sie[l_ac].sie08
         CALL s_umfchk(l_sie[l_ac].sie08,l_sie[l_ac].sie07,l_ima25)
               RETURNING l_flag,l_fac
         IF l_flag THEN 
            CALL cl_err('','',0)
            LET g_success = 'N'
            RETURN
         ELSE 
           LET l_sic07_fac = l_fac 
         END IF
         SELECT max(sic02)+1 INTO l_sic02 FROM sic_file
           WHERE sic01 = l_sia.sia01
         IF cl_NULL(l_sic02) THEN
            LET l_sic02 =1
         END IF
         INSERT INTO sic_file(sic01,sic02,sic03,sic04,sic05,
                    sic06,sic07,sic08,sic09,
                     sic10,sic11,sic012,sic013,sic15,sic12,siclegal,sicplant,sic07_fac) 
             VALUES (l_sia.sia01,l_sic02,l_sie[l_ac].sie05,l_sie[l_ac].sie08,l_sie[l_ac].sie01,
                     l_sie[l_ac].sie11,l_sie[l_ac].sie07,l_sie[l_ac].sie02,l_sie[l_ac].sie03,
                     l_sie[l_ac].sie04,l_sie[l_ac].sie06,l_sie[l_ac].sie012,l_sie[l_ac].sie013,
                     l_sie[l_ac].sie15,'',g_legal,g_plant,l_sic07_fac)  
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
         CALL cl_err3("ins","sic_file",l_sia.sia01,l_sie[l_ac].sie15,l_err,"","ins sic:",1)  #No.FUN-660128
         LET g_success = 'N'
         RETURN
      END IF 
      LET l_ac= l_ac+1
     END  FOREACH 
     CALL i610sub_y_chk(l_sia.sia01)
     IF g_success = "Y" THEN
        CALL i610sub_y_upd(l_sia.sia01,'',TRUE)  RETURNING l_sia.* 
     END IF 
END FUNCTION 
#FUN-AC0074 --add--end
 
FUNCTION p400_doc_chk()
DEFINE   l_cnt1      LIKE type_file.num10   #發料單未審核過賬數量
DEFINE   l_cnt2      LIKE type_file.num10   #退料單未審核過賬數量
DEFINE   l_cnt3      LIKE type_file.num10   #入庫單未審核過賬數量
DEFINE   l_cnt4      LIKE type_file.num10   #拆件式入庫單未審核過賬數量 #No.MOD-8A0066 add by liuxqa
DEFINE   l_msg       STRING
define   l_sql       string #darcy:2024/06/05 add
define   l_cnt5      like type_file.num10 #darcy:2024/06/05 add
 
    LET l_msg = NULL
 
    SELECT COUNT(*) INTO l_cnt1 FROM sfp_file,sfs_file
     WHERE sfp01=sfs01 AND sfs03=g_sfb.sfb01
       AND sfp04!='Y'  AND sfpconf != 'X' 
       AND sfp06 IN ('1','2','3','4','D')    #FUN-C70014 add 'D'
    IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
       
    SELECT COUNT(*) INTO l_cnt2 FROM sfp_file,sfs_file
     WHERE sfp01=sfs01 AND sfs03=g_sfb.sfb01
       AND sfp04!='Y'  AND sfpconf != 'X' 
       AND sfp06 IN ('6','7','8','9')
    IF cl_null(l_cnt2) THEN LET l_cnt2 = 0 END IF
    
    SELECT COUNT(*) INTO l_cnt3 FROM sfu_file,sfv_file
     WHERE sfu01=sfv01 AND sfv11=g_sfb.sfb01
       AND sfupost!='Y' AND sfuconf !='X' 
    IF cl_null(l_cnt3) THEN LET l_cnt3 = 0 END IF
 
    SELECT COUNT(*) INTO l_cnt4 FROM ksc_file,ksd_file
      WHERE ksc01=ksd01 AND ksd11 = g_sfb.sfb01
        AND kscpost !='Y' AND kscconf != 'X'
    IF cl_null(l_cnt4) THEN LET l_cnt4 = 0 END IF
 
    IF l_cnt1 > 0 THEN 
       LET l_msg = cl_getmsg('asf-791',g_lang), '(',l_cnt1, ')  \t'
    END IF
    IF l_cnt2 > 0 THEN 
       LET l_msg = l_msg,cl_getmsg('asf-792',g_lang), '(',l_cnt2, ')  \t'
    END IF
    IF l_cnt3 > 0 THEN 
       LET l_msg = l_msg,cl_getmsg('asf-793',g_lang), '(',l_cnt3, ')  \t'
    END IF
    IF l_cnt4 > 0 THEN
       LET l_msg = l_msg,cl_getmsg('asf-793',g_lang), '(',l_cnt4, ')  \t'
    END IF

   #darcy:2024/06/05 add s---
   let l_sql = "with sgm_t1 as ( 
               SELECT sgm01,sgm02,sgm03, sgm65,sgm301, sgm311, sgm313, sgm314, 
                           SUM(sgm314) OVER (PARTITION BY sgm01 ORDER BY sgm03) sgm314s, 
                           sum(sgm313) OVER (PARTITION BY sgm01 ORDER BY sgm03) sgm313s 
               FROM sgm_file  
               where sgm02 = ?
               ORDER BY sgm01, sgm03 ), 
               sgm_t2 as (  
               select sgm01, sgm02,sgm03, sgm65,sgm301, sgm311, sgm313, sgm314, 
                           sgm314s-sgm314 sgm314s,sgm313s-sgm313 sgm313s 
               from sgm_t1), 
               sgm_t3 as (  
               select sgm01,sgm02,sgm03,sgm65-sgm314s-sgm313s sgm65,sgm301,sgm311,sgm313,sgm314,sgm314s,sgm313s 
               from sgm_t2), 
               sgm_t4 as ( 
               select sgm01,sgm02,sgm03,sgm65,sgm301,sgm311,sgm313,sgm314,sgm313s,sgm314s, 
               least(sgm65,sgm301)-sgm311-sgm313 sgmwip 
               from sgm_t3),
               sgm_t5 as (
               select sgm_t4.*,LAG(sgm03) OVER (PARTITION BY sgm01 ORDER BY sgm03) AS previous_sgm03 from sgm_t4)
               select count(*) from sgm_t5 where previous_sgm03 is not null and  sgmwip > 0 "
   prepare p400_cnt_wip from l_sql
   execute p400_cnt_wip using g_sfb.sfb01 into l_cnt5
   if l_cnt5 > 0 then
      let l_msg = l_msg,cl_getmsg('csf-128',g_lang), '(',l_cnt5, ')  \t'
   end if
   #darcy:2024/06/05 add e---
 
    RETURN l_msg
END FUNCTION
 
#查找該工單的最近報廢日期。若存在最近報廢日期，則需將發料結束日期更新為最近報廢日期和最近發料日期的兩者最小值。
FUNCTION p400_sfk02(p_sfb01)
DEFINE   p_sfb01       LIKE sfb_file.sfb01 
 
    LET g_sfk02 = NULL
    SELECT MAX(sfk02) INTO g_sfk02 FROM sfk_file,sfl_file 
     WHERE sfk01 = sfl01 AND sfl02 = p_sfb01 
    IF NOT cl_null(g_sfk02) THEN  
       IF g_sfk02 > g_sfb.sfb25 OR cl_null(g_sfb.sfb25) THEN
          LET g_sfb.sfb36 = g_sfk02
       ELSE 
          LET g_sfb.sfb36 = g_sfb.sfb25
       END IF
    END IF
    DISPLAY BY NAME g_sfb.sfb36 
    DISPLAY g_sfk02 TO sfk02
END FUNCTION 

#FUN-9A0095 -- add p400_mes() for MES
FUNCTION p400_mes(p_key1)
 DEFINE p_key1   LIKE type_file.chr500
 DEFINE l_mesg01 LIKE type_file.chr30

#CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
 CASE aws_mescli('asfp400','delete',p_key1)
    WHEN 1  #呼叫 MES 成功
         MESSAGE "CLOSE O.K, CLOSE MES O.K"
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
    OTHERWISE  #其他異常
         LET g_success = 'N'
 END CASE

END FUNCTION
#FUN-9A0095 -- add end -------------

#No.FUN-9C0072 精簡程式碼 
