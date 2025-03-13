# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmp210.4gl
# Descriptions...: 採購單整批處理作業
# Date & Author..: No.TQC-730022 07/03/13 By rainy
# Modify.........: No.FUN-740046 07/04/12 By rainy 訂單號號/序號存到 pmn24/25,pmn94/95改為 no use
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.MOD-820152 08/02/25 By claire 勾選20張單號以上串apmr900會有prepare錯誤
# Modify.........: No.FUN-930113 09/04/02 By mike oah-->pnz   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0068 09/10/28 By destiny 单身增加显示VMI管理否
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.FUN-A80150 10/09/14 By sabrina GP5.2號機管理
# Modify.........: No.TQC-B20133 11/02/28 By destiny 執行到t540_sub時會報不在交易中的錯
# Modify.........: No.MOD-C20052 12/02/09 By jt_chen 修正單身有資料時,按下任一ACTION程式即關閉的錯誤.
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_renew   LIKE type_file.num5        
DEFINE g_pmm1   DYNAMIC ARRAY OF RECORD
                  a         LIKE type_file.chr1,   #選擇
                  pmm04     LIKE pmm_file.pmm04,    
                  pmm01     LIKE pmm_file.pmm01,  
                  pmm03     LIKE pmm_file.pmm03,  
                  pmm909    LIKE pmm_file.pmm909,  
                  pmm02     LIKE pmm_file.pmm02,
                  pmm09     LIKE pmm_file.pmm09,
                  pmc03     LIKE pmc_file.pmc03,
                  pmm22     LIKE pmm_file.pmm22,
                  pmm21     LIKE pmm_file.pmm21,
                  pmm41     LIKE pmm_file.pmm41,
                  pmm20     LIKE pmm_file.pmm20,
                  pmm12     LIKE pmm_file.pmm12,
                  gen02     LIKE gen_file.gen02, 
                  pmm13     LIKE pmm_file.pmm13,
                  gem02     LIKE gem_file.gem02, 
                  pmm18     LIKE pmm_file.pmm18,
                  pmm25     LIKE pmm_file.pmm25
               END RECORD,
       g_pmm1_t RECORD
                  a         LIKE type_file.chr1,   #選擇
                  pmm04     LIKE pmm_file.pmm04,    
                  pmm01     LIKE pmm_file.pmm01,  
                  pmm03     LIKE pmm_file.pmm03,  
                  pmm909    LIKE pmm_file.pmm909,  
                  pmm02     LIKE pmm_file.pmm02,
                  pmm09     LIKE pmm_file.pmm09,
                  pmc03     LIKE pmc_file.pmc03,
                  pmm22     LIKE pmm_file.pmm22,
                  pmm21     LIKE pmm_file.pmm21,
                  pmm41     LIKE pmm_file.pmm41,
                  pmm20     LIKE pmm_file.pmm20,
                  pmm12     LIKE pmm_file.pmm12,
                  gen02     LIKE gen_file.gen02, 
                  pmm13     LIKE pmm_file.pmm13,
                  gem02     LIKE gem_file.gem02, 
                  pmm18     LIKE pmm_file.pmm18,
                  pmm25     LIKE pmm_file.pmm25
               END RECORD,
 
       g_pmn1   DYNAMIC ARRAY OF RECORD
                  pmn02    LIKE pmn_file.pmn02,  #項次
                  pmn24    LIKE pmn_file.pmn24,  #請購單號
                  pmn25    LIKE pmn_file.pmn25,  #請購項次
                  pmn65    LIKE pmn_file.pmn65,  #代買料
                  pmn41    LIKE pmn_file.pmn41,  #工單編號
                  pmn42    LIKE pmn_file.pmn42,
                  pmn16    LIKE pmn_file.pmn16,  #狀況碼
                  pmn04    LIKE pmn_file.pmn04,  #料件編號
                  att00    LIKE imx_file.imx00,  
                  att01    LIKE imx_file.imx01,  
                  att01_c  LIKE imx_file.imx01,  
                  att02    LIKE imx_file.imx02,  
                  att02_c  LIKE imx_file.imx02,  
                  att03    LIKE imx_file.imx03,  
                  att03_c  LIKE imx_file.imx03,  
                  att04    LIKE imx_file.imx04,  
                  att04_c  LIKE imx_file.imx04,  
                  att05    LIKE imx_file.imx05,  
                  att05_c  LIKE imx_file.imx05,  
                  att06    LIKE imx_file.imx06,  
                  att06_c  LIKE imx_file.imx06,  
                  att07    LIKE imx_file.imx07,  
                  att07_c  LIKE imx_file.imx07,  
                  att08    LIKE imx_file.imx08,  
                  att08_c  LIKE imx_file.imx08,  
                  att09    LIKE imx_file.imx09,  
                  att09_c  LIKE imx_file.imx09,  
                  att10    LIKE imx_file.imx10,  
                  att10_c  LIKE imx_file.imx10,  
                  pmn041   LIKE pmn_file.pmn041, #料件品名
                  ima021   LIKE ima_file.ima021, #規格
                  pmn07    LIKE pmn_file.pmn07,  #單位
                  pmn20    LIKE pmn_file.pmn20,  #採購量
                  pmn83    LIKE pmn_file.pmn83,
                  pmn84    LIKE pmn_file.pmn84,
                  pmn85    LIKE pmn_file.pmn85,
                  pmn80    LIKE pmn_file.pmn80,
                  pmn81    LIKE pmn_file.pmn81,
                  pmn82    LIKE pmn_file.pmn82,
                  pmn86    LIKE pmn_file.pmn86,
                  pmn87    LIKE pmn_file.pmn87,
                  pmn68    LIKE pmn_file.pmn68,  #Blanket PO
                  pmn69    LIKE pmn_file.pmn69,  #Blanket 項次
                  pmn31    LIKE pmn_file.pmn31,  #單價
                  pmn31t   LIKE pmn_file.pmn31t, #含稅單價     
                  pmn89    LIKE pmn_file.pmn89,  #VMI管理
                  pmn64    LIKE pmn_file.pmn64,  #保稅否      #No.FUN-9A0068
                  pmn63    LIKE pmn_file.pmn63,  #急料否
                  pmn33    LIKE pmn_file.pmn33,  #交貨日期
                  pmn34    LIKE pmn_file.pmn34,  #到廠日
                  pmn919   LIKE pmn_file.pmn919, #計畫批號    #FUN-A80150 add
                  pmn122   LIKE pmn_file.pmn122, #專案代號
                  pmn930   LIKE pmn_file.pmn930, #成本中心      
                  gem02a   LIKE gem_file.gem02,  #成本中心名稱  
                  pmn43    LIKE pmn_file.pmn43,  #本製程序
                  pmn431   LIKE pmn_file.pmn431, #下製程序
                  pmn38    LIKE pmn_file.pmn38,  #可用/不可用  
                  pmn90    LIKE pmn_file.pmn90  #取出單價     
                  #pmn94    LIKE pmn_file.pmn94,  #訂單單號    #FUN-740046 
                  #pmn95    LIKE pmn_file.pmn95   #訂單序號    #FUN-740046   
               END RECORD,
 
       g_pmn1_t RECORD
                  pmn02    LIKE pmn_file.pmn02,  #項次
                  pmn24    LIKE pmn_file.pmn24,  #請購單號
                  pmn25    LIKE pmn_file.pmn25,  #請購項次
                  pmn65    LIKE pmn_file.pmn65,  #代買料
                  pmn41    LIKE pmn_file.pmn41,  #工單編號
                  pmn42    LIKE pmn_file.pmn42,
                  pmn16    LIKE pmn_file.pmn16,  #狀況碼
                  pmn04    LIKE pmn_file.pmn04,  #料件編號
                  att00    LIKE imx_file.imx00,  
                  att01    LIKE imx_file.imx01,  
                  att01_c  LIKE imx_file.imx01,  
                  att02    LIKE imx_file.imx02,  
                  att02_c  LIKE imx_file.imx02,  
                  att03    LIKE imx_file.imx03,  
                  att03_c  LIKE imx_file.imx03,  
                  att04    LIKE imx_file.imx04,  
                  att04_c  LIKE imx_file.imx04,  
                  att05    LIKE imx_file.imx05,  
                  att05_c  LIKE imx_file.imx05,  
                  att06    LIKE imx_file.imx06,  
                  att06_c  LIKE imx_file.imx06,  
                  att07    LIKE imx_file.imx07,  
                  att07_c  LIKE imx_file.imx07,  
                  att08    LIKE imx_file.imx08,  
                  att08_c  LIKE imx_file.imx08,  
                  att09    LIKE imx_file.imx09,  
                  att09_c  LIKE imx_file.imx09,  
                  att10    LIKE imx_file.imx10,  
                  att10_c  LIKE imx_file.imx10,  
                  pmn041   LIKE pmn_file.pmn041, #料件品名
                  ima021   LIKE ima_file.ima021, #規格
                  pmn07    LIKE pmn_file.pmn07,  #單位
                  pmn20    LIKE pmn_file.pmn20,  #採購量
                  pmn83    LIKE pmn_file.pmn83,
                  pmn84    LIKE pmn_file.pmn84,
                  pmn85    LIKE pmn_file.pmn85,
                  pmn80    LIKE pmn_file.pmn80,
                  pmn81    LIKE pmn_file.pmn81,
                  pmn82    LIKE pmn_file.pmn82,
                  pmn86    LIKE pmn_file.pmn86,
                  pmn87    LIKE pmn_file.pmn87,
                  pmn68    LIKE pmn_file.pmn68,  #Blanket PO
                  pmn69    LIKE pmn_file.pmn69,  #Blanket 項次
                  pmn31    LIKE pmn_file.pmn31,  #單價
                  pmn31t   LIKE pmn_file.pmn31t, #含稅單價     
                  pmn64    LIKE pmn_file.pmn64,  #保稅否      #No.FUN-9A0068           
                  pmn63    LIKE pmn_file.pmn63,  #急料否
                  pmn33    LIKE pmn_file.pmn33,  #交貨日期
                  pmn34    LIKE pmn_file.pmn34,  #到廠日
                  pmn919   LIKE pmn_file.pmn919, #計畫批號    #FUN-A80150 add
                  pmn122   LIKE pmn_file.pmn122, #專案代號
                  pmn930   LIKE pmn_file.pmn930, #成本中心      
                  gem02a   LIKE gem_file.gem02,  #成本中心名稱  
                  pmn43    LIKE pmn_file.pmn43,  #本製程序
                  pmn431   LIKE pmn_file.pmn431, #下製程序
                  pmn38    LIKE pmn_file.pmn38,  #可用/不可用  
                  pmn90    LIKE pmn_file.pmn90  #取出單價     
                  #pmn94    LIKE pmn_file.pmn94,  #訂單單號    #FUN-740046 
                  #pmn95    LIKE pmn_file.pmn95   #訂單序號    #FUN-740046  
               END RECORD,
       g_pmm RECORD       LIKE pmm_file.*,       #採購單頭
       g_pmn RECORD       LIKE pmn_file.*,       #採購單身
       begin_no,end_no     LIKE oga_file.oga01,
       lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*,
       g_wc2,g_sql,g_ws1,g_ws2    STRING,
       g_wc_pmm       STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5          
DEFINE lg_group       LIKE oay_file.oay22   #當前單身中采用的組別
DEFINE lg_smy62       LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別   
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
DEFINE g_msg          STRING              #MOD-820152 modify LIKE type_file.chr1000       
DEFINE mi_need_cons   LIKE type_file.num5
DEFINE g_dbs2         LIKE type_file.chr30   #TQC-680074
DEFINE tm RECORD			      #
          slip        LIKE oay_file.oayslip, #單據別
          dt          LIKE oeb_file.oeb16,   #出通/出貨日期
          g           LIKE type_file.chr1    #匯總方式
      END RECORD,
      g_gfa  RECORD    LIKE gfa_file.*
DEFINE t_aza41   LIKE type_file.num5        #單別位數 (by aza41)
 
 
 
 
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p210_w AT p_row,p_col WITH FORM "apm/42f/apmp210"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("pmn919",g_sma.sma1421='Y')    #FUN-A80150 add
 
   CALL p210_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL p210()
 
   CLOSE WINDOW p210_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
 
 
FUNCTION p210()
 
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p210_q()
      END IF
      CALL p210_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "select_all"   #全部選取
           CALL p210_sel_all('Y')
 
         WHEN "select_non"   #全部不選
           CALL p210_sel_all('N')
 
         WHEN "po_detail" #採購明細
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              LET g_msg = " apmt540 '", g_pmm1_t.pmm01,"'"
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
 
         WHEN "batch_confirm" #整批確認
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p210_batch_confirm()
           END IF
 
         WHEN "batch_print"    #整批列印採購單
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p210_batch_print()
           END IF
 
         WHEN "release_po"
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p210_release_po()
           END IF
 
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmm1),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
 
 
 
FUNCTION p210_p1()
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      INPUT ARRAY g_pmm1 WITHOUT DEFAULTS FROM s_pmm.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
         BEFORE ROW
             IF g_renew THEN
               LET l_ac1 = ARR_CURR()
               IF l_ac1 = 0 THEN
                  LET l_ac1 = 1
               END IF
             END IF
             CALL fgl_set_arr_curr(l_ac1)
             LET g_renew = 1
             CALL cl_show_fld_cont()
             LET l_ac1_t = l_ac1
             LET g_pmm1_t.* = g_pmm1[l_ac1].*
 
             IF g_rec_b1 > 0 THEN
               CALL p210_b_fill()
               CALL p210_bp2('')
               CALL cl_set_act_visible("select_all,select_non,po_detail,batch_confirm,batch_print,release_po", TRUE)
             ELSE
               CALL cl_set_act_visible("select_all,select_non,po_detail,batch_confirm,batch_print,release_po", FALSE)
             END IF
 
         ON CHANGE a
            IF cl_null(g_pmm1[l_ac1].a) THEN 
               LET g_pmm1[l_ac1].a = 'Y'
            END IF
 
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT
 
         ON ACTION select_all   #全部選取
            LET g_action_choice="select_all"
            EXIT INPUT
 
         ON ACTION select_non   #全部不選
            LET g_action_choice="select_non"
            EXIT INPUT
 
         ON ACTION po_detail #請購單明細
            LET g_action_choice="po_detail"
            EXIT INPUT
 
         ON ACTION batch_confirm #整批確認
            LET g_action_choice="batch_confirm"
            EXIT INPUT
         
         ON ACTION batch_print   #列印採購單
            LET g_action_choice="batch_print"
            EXIT INPUT
 
         ON ACTION release_po       #採購發出
            LET g_action_choice="release_po"
            EXIT INPUT
 
         ON ACTION view
            CALL p210_bp2('V')
 
         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT INPUT     
 
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p210_q()
   CALL p210_b_askkey()
END FUNCTION
 
FUNCTION p210_b_askkey()
   CLEAR FORM
   CALL g_pmm1.clear()
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON pmm04,pmm01,pmm03,pmm909,pmn02,pmm09,pmm22,
                      pmm21,pmm41,pmm20,pmm12, pmm13,pmm18,pmm25
                      
                 FROM s_pmm[1].pmm04, s_pmm[1].pmm01,s_pmm[1].pmm03,
                      s_pmm[1].pmm909,s_pmm[1].pmm02,s_pmm[1].pmm09,
                      s_pmm[1].pmm22, s_pmm[1].pmm21,s_pmm[1].pmm41,
                      s_pmm[1].pmm20, s_pmm[1].pmm12,s_pmm[1].pmm13,
                      s_pmm[1].pmm18, s_pmm[1].pmm25
                      
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmm01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_pmm12"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmm01
                  NEXT FIELD pmm01
 
               WHEN INFIELD(pmm09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm09
                    NEXT FIELD pmm09
 
               WHEN INFIELD(pmm22)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azi"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm22
                    NEXT FIELD pmm22
 
               WHEN INFIELD(pmm21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gec"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm21
                    NEXT FIELD pmm21
 
               WHEN INFIELD(pmm41)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pnz01" #FUN-930113    
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm41
                   NEXT FIELD pmm41
 
               WHEN INFIELD(pmm20)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pma"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm20
                   NEXT FIELD pmm20
 
               WHEN INFIELD(pmm12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm12
                    NEXT FIELD pmm12
 
               WHEN INFIELD(pmm13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmm13
                    NEXT FIELD pmm13
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup') #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL p210_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_pmm1_t.* = g_pmm1[l_ac1].*
 
   CALL p210_b_fill()
END FUNCTION
 
FUNCTION p210_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = " SELECT 'N',pmm04,pmm01,pmm03,pmm909,pmm02,pmm09,'',",
               "        pmm22,pmm21,pmm41,pmm20,pmm12,'',pmm13,'',",
               "        pmm18,pmm25",
               "  FROM pmm_file ",
               " WHERE ",p_wc2 CLIPPED,
               " ORDER BY pmm04 DESC "  #依採購日期降冪
 
   PREPARE p210_pb1 FROM g_sql
   DECLARE pmm_curs CURSOR FOR p210_pb1
  
   CALL g_pmm1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH pmm_curs INTO g_pmm1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF
 
 
      SELECT pmc03 INTO g_pmm1[g_cnt].pmc03
        FROM pmc_file
       WHERE pmc01 = g_pmm1[g_cnt].pmm09
 
      SELECT gen02 INTO g_pmm1[g_cnt].gen02
        FROM gen_file
       WHERE gen01 = g_pmm1[g_cnt].pmm12
 
      SELECT gem02 INTO g_pmm1[g_cnt].gem02
        FROM gem_file
       WHERE gem01 = g_pmm1[g_cnt].pmm13
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_pmm1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
 
 
FUNCTION p210_b_fill()
 
   LET g_sql ="SELECT pmn02,pmn24,pmn25,pmn65,pmn41,pmn42,pmn16,pmn04,",
              "       '','','','','','','','','','','','','','','','','','','','','',",
              "       pmn041,ima021,pmn07,pmn20,pmn83,pmn84,pmn85,",
              "       pmn80,pmn81,pmn82,pmn86,pmn87,pmn68,pmn69,pmn31,",
             #"       pmn31t,pmn64,pmn63,pmn33,pmn34,pmn122,pmn930,'',pmn43,",          #No.FUN-9A0068
              "       pmn31t,pmn89,pmn64,pmn63,pmn33,pmn34,pmn919,pmn122,pmn930,'',pmn43,",    #No.FUN-9A0068  #FUN-A80150 add pmn919
              #"       pmn431 ,pmn38,pmn90,pmn94,pmn95 ",  #FUN-740046
              "       pmn431 ,pmn38,pmn90 ",               #FUN-740046
              " FROM pmn_file,OUTER ima_file ",
              " WHERE pmn01= '",g_pmm1_t.pmm01,"'",
              "   AND pmn_file.pmn04=ima_file.ima01 ",
              " ORDER BY pmn02"
   PREPARE p210_pb FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE p210_cs CURSOR FOR p210_pb
   CALL g_pmn1.clear()
 
   LET g_cnt=1
   FOREACH p210_cs INTO g_pmn1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN              
         #得到該料件對應的父料件和所有屬性
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,
                imx07,imx08,imx09,imx10 INTO
                g_pmn1[g_cnt].att00,g_pmn1[g_cnt].att01,g_pmn1[g_cnt].att02,
                g_pmn1[g_cnt].att03,g_pmn1[g_cnt].att04,g_pmn1[g_cnt].att05,
                g_pmn1[g_cnt].att06,g_pmn1[g_cnt].att07,g_pmn1[g_cnt].att08,
                g_pmn1[g_cnt].att09,g_pmn1[g_cnt].att10
           FROM imx_file WHERE imx000 = g_pmn1[g_cnt].pmn04
 
           LET g_pmn1[g_cnt].att01_c = g_pmn1[g_cnt].att01
           LET g_pmn1[g_cnt].att02_c = g_pmn1[g_cnt].att02
           LET g_pmn1[g_cnt].att03_c = g_pmn1[g_cnt].att03
           LET g_pmn1[g_cnt].att04_c = g_pmn1[g_cnt].att04
           LET g_pmn1[g_cnt].att05_c = g_pmn1[g_cnt].att05
           LET g_pmn1[g_cnt].att06_c = g_pmn1[g_cnt].att06
           LET g_pmn1[g_cnt].att07_c = g_pmn1[g_cnt].att07
           LET g_pmn1[g_cnt].att08_c = g_pmn1[g_cnt].att08
           LET g_pmn1[g_cnt].att09_c = g_pmn1[g_cnt].att09
           LET g_pmn1[g_cnt].att10_c = g_pmn1[g_cnt].att10
      END IF
 
      SELECT gem02 INTO g_pmn1[g_cnt].gem02a 
        FROM gem_file
       WHERE gem01=g_pmn1[g_cnt].pmn930
 
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 1 ) 
       EXIT FOREACH
      END IF
   END FOREACH
 
 
   CALL g_pmn1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cn3
   LET g_cnt = 0
END FUNCTION
 
 
 
 
FUNCTION p210_bp2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   
  IF g_pmm1_t.pmm909 ='3' THEN
     CALL cl_getmsg('axr-500',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("pmn24",g_msg CLIPPED)
     CALL cl_getmsg('apm-040',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("pmn25",g_msg CLIPPED)
  ELSE
     CALL cl_getmsg('apm-041',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("pmn24",g_msg CLIPPED)
     CALL cl_getmsg('apm-042',g_lang) RETURNING g_msg
     CALL cl_set_comp_att_text("pmn25",g_msg CLIPPED)
  END IF
 
   #CALL cl_set_act_visible("accept,cancel", FALSE)       #MOD-C20052 mark
 
   DISPLAY ARRAY g_pmn1 TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION return
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
      
      ON ACTION controlg 
         CALL cl_cmdask()
   END DISPLAY
END FUNCTION
 
 
 
FUNCTION p210_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62    
  DEFINE li_col_count       LIKE type_file.num5    
  DEFINE li_i, li_j         LIKE type_file.num5    
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF ( g_sma.sma120 = 'Y' )AND( g_sma.sma907 = 'Y' )AND(lg_smy62 IS NOT NULL) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_pmn1.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_pmn1.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_pmn1[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_pmn1[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN 
            LET lg_group = l_compare
         #以后是比較   
         ELSE 
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
       END FOR 
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替pmn04子料件編號來顯示
     #得到當前語言別下pmn04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = 'apmt540' AND gae02 = 'pmn04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'pmn04,pmn041'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'pmn04,pmn041'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'pmn04'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
 
END FUNCTION
 
#全部選取/全部不選
FUNCTION p210_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    LET g_pmm1[l_i].a = p_flag
    DISPLAY BY NAME g_pmm1[l_i].a
  END FOR
END FUNCTION
 
 
FUNCTION p210_init()
   LET lg_smy62 = ''                                                                                                             
   LET lg_group = ''                                                                                                             
   CALL p210_refresh_detail()                                                                                                    
 
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
END FUNCTION
 
 
FUNCTION p210_chk_pmm()
  DEFINE l_i,l_n  LIKE type_file.num5
 
  LET l_n = 0  
  FOR l_i = 1 TO g_rec_b1
    IF g_pmm1[l_i].a = 'Y' THEN  #有勾選
      #要是"已確認"且"已核准"的資料
      IF NOT (g_pmm1[l_i].pmm18 = 'Y' AND g_pmm1[l_i].pmm25 = '1')  THEN
        LET g_pmm1[l_i].a = 'N'  #將勾勾拿掉
      ELSE
        LET l_n = l_n + 1
      END IF 
    END IF
  END FOR
 
  IF l_n > 0 THEN
    RETURN TRUE
  ELSE
    RETURN FALSE
  END IF
END FUNCTION
 
 
 
FUNCTION p210_batch_confirm()
  DEFINE l_i,l_n        LIKE type_file.num5
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_pmm1[l_i].a = 'Y' THEN
       IF g_pmm1[l_i].pmm18 <> 'N' THEN
          LET g_pmm1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n >  0 THEN
    IF NOT cl_confirm('axm-596') THEN
      RETURN
    END IF
  ELSE RETURN
  END IF
 
  FOR l_i = 1 TO g_rec_b1
    IF g_pmm1[l_i].a = 'Y' THEN
         SELECT pmm_file.* INTO g_pmm.* FROM pmm_file
          WHERE pmm01 = g_pmm1[l_i].pmm01
 
 
          CALL t540sub_y_chk(g_pmm.*)          #CALL 原確認的 check 段
          IF g_success = "Y" THEN
             #CALL t540sub_y_upd(g_pmm1[l_i].pmm01,'')  #CALL apmt540 原確認的 update 段 #FUN-740034       #TQC-B20133   
             CALL t540sub_y_upd(g_pmm1[l_i].pmm01,'update')  #CALL apmt540 原確認的 update 段 #FUN-740034  #TQC-B20133
             CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* 
             LET g_pmm1[l_i].pmm18 = g_pmm.pmm18
             LET g_pmm1[l_i].pmm25 = g_pmm.pmm25
             LET g_pmm1_t.* = g_pmm1[l_i].*
          END IF
          INITIALIZE g_pmm.* TO NULL
    END IF
  END FOR
END FUNCTION
 
 
#採購發出
FUNCTION p210_release_po()
  DEFINE l_i,l_n        LIKE type_file.num5
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_pmm1[l_i].a = 'Y' THEN
       IF g_pmm1[l_i].pmm18 <> 'Y' THEN
          LET g_pmm1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('axm-598') THEN
      RETURN
    END IF
  ELSE RETURN
  END IF
 
  FOR l_i = 1 TO g_rec_b1
    IF g_pmm1[l_i].a = 'Y' THEN
       SELECT pmm_file.* INTO g_pmm.* FROM pmm_file
        WHERE pmm01 = g_pmm1[l_i].pmm01
 
        CALL t540sub_issue(g_pmm.pmm01,FALSE)
        CALL t540sub_refresh(g_pmm.pmm01) RETURNING g_pmm.* 
        LET g_pmm1[l_i].pmm25 = g_pmm.pmm25
        LET g_pmm1_t.* = g_pmm1[l_i].*
        INITIALIZE g_pmm.* TO NULL
    END IF
  END FOR
END FUNCTION
 
FUNCTION p210_batch_print()
  DEFINE l_wc STRING
  DEFINE l_i,l_n  LIKE type_file.num5
         
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
    IF g_pmm1[l_i].a = 'Y' THEN
      LET l_n = l_n + 1
    END IF
  END FOR 
 
  IF l_n = 0 THEN RETURN END IF  #都沒勾選
  
  LET l_n = 0 
  LET l_wc = " pmm01 IN ("
  FOR l_i = 1 TO g_rec_b1
     IF g_pmm1[l_i].a = 'Y' THEn
        LET l_n = l_n + 1
        IF l_n = 1 THEN
           LET l_wc = l_wc CLIPPED,"'",g_pmm1[l_i].pmm01 CLIPPED,"'"
        ELSE
           LET l_wc = l_wc CLIPPED,",'",g_pmm1[l_i].pmm01 CLIPPED,"'"
        END IF
     END IF
  END FOR
  LET l_wc = l_wc CLIPPED,")"                                                                                     
  LET l_wc = cl_replace_str( l_wc , "'" , "\"" )
 
   LET g_msg = " apmr900 ",
               " '",g_today,"'",
               " '",g_user CLIPPED,"'",
               " '",g_lang,"'",
               " 'Y' '' '1' ",
               " '",l_wc CLIPPED,"' ",
               " 'N' 'Y' '0' 'default' 'default' 'template1' '' '' ''"
  CALL cl_cmdrun(g_msg CLIPPED)
END FUNCTION
 
#TQC-730022
