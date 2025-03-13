# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp220.4gl
# Descriptions...: 整批收貨作業
# Date & Author..: No.TQC-730022 07/03/26 By rainy
# Modify.........: No.MOD-740454 07/04/25 By rainy 會重複產生收貨單資料
# Modify.........: No.TQC-780007 07/08/01 By rainy 處理 img
# Modify.........: No.FUN-710060 07/08/07 By jamie 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: No.MOD-7C0234 07/12/28 By claire 應排除多角採購單
# Modify.........: No.MOD-810071 08/01/09 By claire 要排除作廢的單據
# Modify.........: No.MOD-810121 08/01/16 By claire 要為已發出採購單才可收貨
# Modify.........: No.MOD-810256 08/02/21 By claire rva04要給預設值否則造成後續帳款無法產生
# Modify.........: No.MOD-810221 08/02/22 By claire rvb07實收數應要計算未收數
# Modify.........: No.MOD-820128 08/02/22 By claire rvaprsw給預設值否則無法由apmt110印出收貨單
# Modify.........: No.FUN-7B0018 08/02/26 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-840038 08/04/03 By claire rva21進口日期需給default值否則會為99/12/31
# Modify.........: No.CHI-840008 08/04/10 By Dido 只有未收貨完全的採購單才進入
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.MOD-880217 08/08/27 By chenl  計價數量(rvb87)應為本次采購收貨實收數(rvb07)與采購單位計價單位轉換因子(pmn09)的乘積。
# Modify.........: No.MOD-8A0067 08/10/08 By chenl  修正MOD-880217修改內容，計價數量=采購單計價數量-已收貨計價數量
# Modify.........: No.CHI-8C0017 08/12/17 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-910033 09/02/12 by ve007 抓取作業編號時，委外要區分制程和非制程
# Modify.........: No.TQC-920098 09/02/27 By ve007 c2不過
# Modify.........: No.MOD-930082 09/03/09 By rainy rvb87應=pmn87-SUM(rvb87)+SUM(rvb29)
# Modify.........: No.FUN-940083 09/05/13 By zhaijie產生收貨單身資料段修改
# Modify.........: No.MOD-940376 09/05/14 by Dido 實收數量須計算未確認的收貨與倉退單
# Modify.........: No.FUN-980006 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990084 09/09/11 By Smapmin MOD-740454會重複產生收貨單的問題,應該於產生收貨單身時,判斷是否還有未收的量.
# Modify.........: No.CHI-960033 09/10/03 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No:MOD-9B0135 09/11/23 By Smapmin 排除作廢單據
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:FUN-9C0076 10/03/30 By Lilan EF整合新增欄位(rva32,rva33,rvamksg)給予預設值
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/29 By vealxu 製造功能優化-平行制程
# Modify.........: No.FUN-A80150 10/09/14 By sabrina GP5.2號機管理
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.TQC-AB0025 10/11/24 By chenying 修改Sybase問題 
# Modify.........: No:MOD-AC0133 10/12/21 By Smapmin 過濾單身已結案或取消的資料
# Modify.........: No:FUN-B40098 11/05/27 By shiwuying 扣率代銷選擇非成本倉
# Modify.........: No:FUN-B60150 11/07/05 By baogc 成本代銷時，倉庫取arti200中設置的成本rtz07
# Modify.........: No:FUN-BB0083 11/12/01 By xujing 增加數量欄位小數取位
# Modify.........: No:TQC-C60156 12/06/19 By zhuhao 依採購單產生收貨單調整
# Modify.........: No:MOD-C70184 12/07/17 By Elise 查詢資料時,action被關掉了 
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_renew   LIKE type_file.num5        
DEFINE g_pmm1   DYNAMIC ARRAY OF RECORD
                  a         LIKE type_file.chr1,   #選擇
                  pmm04     LIKE pmm_file.pmm04,    
                  pmm01     LIKE pmm_file.pmm01,  
                  pmm02     LIKE pmm_file.pmm02,
                  pmm09     LIKE pmm_file.pmm09,
                  pmc03     LIKE pmc_file.pmc03,
                  pmm22     LIKE pmm_file.pmm22,
                  pmm21     LIKE pmm_file.pmm21,
                  pmm12     LIKE pmm_file.pmm12,
                  gen02     LIKE gen_file.gen02, 
                  pmm13     LIKE pmm_file.pmm13,
                  gem02     LIKE gem_file.gem02, 
                  pmn02     LIKE pmn_file.pmn02,
                  pmn04     LIKE pmn_file.pmn04,
                  pmn041    LIKE pmn_file.pmn041,
                  pmn07     LIKE pmn_file.pmn07,
                  pmn20     LIKE pmn_file.pmn20,
                  pmn50     LIKE pmn_file.pmn50,
                  pmn53     LIKE pmn_file.pmn53,
                  pmn58     LIKE pmn_file.pmn58
               END RECORD,
       g_pmm1_t RECORD
                  a         LIKE type_file.chr1,   #選擇
                  pmm04     LIKE pmm_file.pmm04,    
                  pmm01     LIKE pmm_file.pmm01,  
                  pmm02     LIKE pmm_file.pmm02,
                  pmm09     LIKE pmm_file.pmm09,
                  pmc03     LIKE pmc_file.pmc03,
                  pmm22     LIKE pmm_file.pmm22,
                  pmm21     LIKE pmm_file.pmm21,
                  pmm12     LIKE pmm_file.pmm12,
                  gen02     LIKE gen_file.gen02, 
                  pmm13     LIKE pmm_file.pmm13,
                  gem02     LIKE gem_file.gem02, 
                  pmn02     LIKE pmn_file.pmn02,
                  pmn04     LIKE pmn_file.pmn04,
                  pmn041    LIKE pmn_file.pmn041,
                  pmn07     LIKE pmn_file.pmn07,
                  pmn20     LIKE pmn_file.pmn20,
                  pmn50     LIKE pmn_file.pmn50,
                  pmn53     LIKE pmn_file.pmn53,
                  pmn58     LIKE pmn_file.pmn58
               END RECORD,
 
       g_rvb1   DYNAMIC ARRAY OF RECORD
                  rvb01    LIKE rvb_file.rvb01,  #收貨單號
                  rvb02    LIKE rvb_file.rvb02,  #項次
                  rvb34    LIKE rvb_file.rvb34,  #委外工單號
                  rvb05    LIKE rvb_file.rvb05,  #料號
                  ima02    LIKE ima_file.ima02,  #品名
                  ima021   LIKE ima_file.ima021, #規格
                  pmn07a   LIKE pmn_file.pmn07,  #採購單位
                  rvb08    LIKE rvb_file.rvb08,  #收貨量
                  rvb33    LIKE rvb_file.rvb33,  #允收量
                  rvb30    LIKE rvb_file.rvb30,  #入庫量
                  rvb919   LIKE rvb_file.rvb919  #計畫批號    #FUN-A80150 add
               END RECORD,
 
       g_rvb1_t RECORD
                  rvb01    LIKE rvb_file.rvb01,  #收貨單號
                  rvb02    LIKE rvb_file.rvb02,  #項次
                  rvb34    LIKE rvb_file.rvb34,  #委外工單號
                  rvb05    LIKE rvb_file.rvb05,  #料號
                  ima02    LIKE ima_file.ima02,  #品名
                  ima021   LIKE ima_file.ima021, #規格
                  pmn07a   LIKE pmn_file.pmn07,  #採購單位
                  rvb08    LIKE rvb_file.rvb08,  #收貨量
                  rvb33    LIKE rvb_file.rvb33,  #允收量
                  rvb30    LIKE rvb_file.rvb30,  #入庫量
                  rvb919   LIKE rvb_file.rvb919  #計畫批號    #FUN-A80150 add
               END RECORD,
       g_pmm  RECORD  LIKE pmm_file.*,
       g_pmn  RECORD  LIKE pmn_file.*,
       g_rva  RECORD  LIKE rva_file.*,
       g_rvb  RECORD  LIKE rvb_file.*,
       begin_no,end_no     LIKE oga_file.oga01,
       lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*,
       g_wc2,g_sql    STRING,
       g_ws1          STRING,
       g_wc_pmm       STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5,          
       l_ac_t         LIKE type_file.num5          
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
DEFINE g_msg          LIKE type_file.chr1000       
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_dbs2          LIKE type_file.chr30   #TQC-680074
DEFINE tm RECORD			      #
          slip         LIKE oay_file.oayslip, #單據別
          dt           LIKE oeb_file.oeb16,   #出通/出貨日期
          g            LIKE type_file.chr1    #匯總方式
      END RECORD,
      g_pmn02          LIKE pmn_file.pmn02    #採購單號
DEFINE t_aza41   LIKE type_file.num5        #單別位數 (by aza41)
DEFINE g_img07 LIKE img_file.img07,
       g_img10 LIKE img_file.img10,
       g_img09 LIKE img_file.img09,
       g_ima906 LIKE ima_file.ima906,
       g_flag   LIKE type_file.num5
DEFINE g_count LIKE type_file.num5   #MOD-990084
DEFINE l_rvb02 LIKE rvb_file.rvb02   #MOD-990084
 
 
 
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
 
   OPEN WINDOW p220_w AT p_row,p_col WITH FORM "apm/42f/apmp220"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("rvb919",g_sma.sma1421='Y')    #FUN-A80150 add 
   CALL p220_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL p220()
 
   CLOSE WINDOW p220_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
 
 
FUNCTION p220()
 
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p220_q()
      END IF
      CALL p220_p1()
      IF INT_FLAG THEN EXIT WHILE END IF
      CASE g_action_choice
         WHEN "select_all"   #全部選取
           CALL p220_sel_all('Y')
 
         WHEN "select_non"   #全部不選
           CALL p220_sel_all('N')
         
         WHEN "select_po"    #該採購單全選
           LET g_renew = 0
           CALL p220_sel_po()
 
         WHEN "carry_rec"      #收貨單產生
           IF cl_chk_act_auth() THEN
             CALL p220_carry_rec()
             LET g_renew = 0
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
 
 
 
 
FUNCTION p220_p1()
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
             CALL cl_show_fld_cont()
             LET l_ac1_t = l_ac1
             LET g_pmm1_t.* = g_pmm1[l_ac1].*
             LET g_renew = 1
 
             IF g_rec_b1 > 0 THEN
               CALL p220_b_fill()
               CALL p220_bp2('')
               CALL cl_set_act_visible("select_all,select_non,select_po,carry_rec", TRUE)
             ELSE
               CALL cl_set_act_visible("select_all,select_non,select_po,carry_rec", FALSE)
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
 
         ON ACTION select_po    #該採購單全選
            LET g_action_choice="select_po"
            EXIT INPUT
 
         ON ACTION carry_rec    #產生收貨單
            LET g_action_choice="carry_rec"
            EXIT INPUT
 
         ON ACTION view
            CALL p220_bp2('V')
 
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
 
FUNCTION p220_q()
   CALL p220_b_askkey()
END FUNCTION
 
FUNCTION p220_b_askkey()
   CLEAR FORM
   CALL g_pmm1.clear()
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON pmm04,pmm01,pmm02,pmm09, pmm22,pmm21,
                      pmm12,pmm13,pmn04,pmn041,pmn07,pmn20,
                      pmn50,pmn53,pmn58
                      
                 FROM s_pmm[1].pmm04,s_pmm[1].pmm01,s_pmm[1].pmm02,
                      s_pmm[1].pmm09, s_pmm[1].pmm22,s_pmm[1].pmm21,
                      s_pmm[1].pmm12,s_pmm[1].pmm13,s_pmm[1].pmn04,
                      s_pmm[1].pmn041,s_pmm[1].pmn07,s_pmm[1].pmn20, 
                      s_pmm[1].pmn50,s_pmm[1].pmn53,s_pmm[1].pmn58
                      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmm01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_pmm14"   #CHI-840008
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
 
               WHEN INFIELD(pmn04)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form = "q_ima"
#                    LET g_qryparam.state = 'c'
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY g_qryparam.multiret TO pmn04
                    NEXT FIELD pmn04
               WHEN INFIELD(pmn07) #採購單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmn07  
                    NEXT FIELD pmn07
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
 
   CALL p220_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_pmm1_t.* = g_pmm1[l_ac1].*
 
   CALL p220_b_fill()
END FUNCTION
 
FUNCTION p220_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = " SELECT 'N',  pmm04, pmm01,   pmm02,pmm09,'',",
               "        pmm22,pmm21, pmm12,'',pmm13,'',pmn02,",
               "        pmn04,pmn041,pmn07,pmn20,pmn50,pmn53,pmn58 ",
               "  FROM pmm_file,pmn_file ",
               " WHERE pmm01 = pmn01 ",
               "   AND ",p_wc2 CLIPPED,
               "   AND pmm18 = 'Y'",    #已確認的採購單
               "   AND pmm02 <> 'TRI' AND pmm02 <> 'TAP' ", #MOD-7C0234 add
               "   AND pmm25 = '2'",   #MOD-810121 add
               "   AND (pmn20-pmn50+pmn55+pmn58) > 0 ",         #No.FUN-9A0068 
               "   AND pmn16 NOT IN ('6','7','8','9') ",   #MOD-AC0133
               " ORDER BY pmm04 DESC,pmm01 "  #依採購日期降冪
 
   PREPARE p220_pb1 FROM g_sql
   DECLARE pmm_curs CURSOR FOR p220_pb1
  
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
 
 
 
 
FUNCTION p220_b_fill()
 
   LET g_sql ="SELECT rvb01,rvb02,rvb34,rvb05,'','','',",
              "       rvb08,rvb33,rvb30,rvb919 ",    #FUN-A80150 add rvb919 
              " FROM rvb_file ",
              " WHERE rvb04= '",g_pmm1_t.pmm01,"'",
              "   AND rvb03=",g_pmm1_t.pmn02,
              " ORDER BY rvb01,rvb02"
   PREPARE p220_pb FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   DECLARE p220_cs CURSOR FOR p220_pb
   CALL g_rvb1.clear()
 
   LET g_cnt=1
   FOREACH p220_cs INTO g_rvb1[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
 
      SELECT ima02,ima021 INTO g_rvb1[g_cnt].ima02,g_rvb1[g_cnt].ima021 
        FROM ima_file
       WHERE ima01=g_rvb1[g_cnt].rvb05
 
      SELECT pmn07 INTO g_rvb1[g_cnt].pmn07a 
        FROM pmn_file
       WHERE pmn01 = g_pmm1_t.pmm01
         AND pmn02 = g_pmm1_t.pmn02
 
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 1 ) 
       EXIT FOREACH
      END IF
   END FOREACH
 
 
   CALL g_rvb1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cn3
   LET g_cnt = 0
END FUNCTION
 
 
 
 
FUNCTION p220_bp2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   
  #CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-C70184 mark
 
   DISPLAY ARRAY g_rvb1 TO s_rvb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac = 0 THEN
            LET l_ac = 1
         END IF
         CALL cl_show_fld_cont()
         LET l_ac_t = l_ac
         LET g_rvb1_t.* = g_rvb1[l_ac].*
 
      ON ACTION view_rec #收貨單明細
        LET g_action_choice = "view_rec"
        IF cl_chk_act_auth() THEN
         LET g_msg = ' apmt110 ', g_rvb1_t.rvb01 CLIPPED
         CALL cl_cmdrun_wait(g_msg CLIPPED)
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
 
 
#全部選取/全部不選
FUNCTION p220_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    LET g_pmm1[l_i].a = p_flag
    DISPLAY BY NAME g_pmm1[l_i].a
  END FOR
END FUNCTION
 
FUNCTION p220_sel_po()
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    IF g_pmm1[l_i].pmm01 = g_pmm1_t.pmm01 THEN
      LET g_pmm1[l_i].a = 'Y'
    ELSE
      LET g_pmm1[l_i].a = 'N'
    END IF
    DISPLAY BY NAME g_pmm1[l_i].a
  END FOR
END FUNCTION
 
 
FUNCTION p220_init()
LET g_dbs2 = s_dbstring(g_dbs2 CLIPPED)
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
END FUNCTION
 
 
#產生收貨單(by採購單/by供應商/不匯總)
FUNCTION p220_carry_rec()
  DEFINE l_pmm01   LIKE  pmm_file.pmm01,  #採購單號
         l_pmm02   LIKE  pmm_file.pmm02,  #採購性質
         l_pmm09   LIKE  pmm_file.pmm09   #供應商
 
  DEFINE l_buf1    LIKE pmk_file.pmk01        #單別
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE l_wc    STRING
  LET begin_no = NULL
  LET end_no = NULL
 
  OPEN WINDOW p220_exp AT p_row,p_col WITH FORM "apm/42f/apmp220a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
  CALL cl_ui_locale("apmp220a")
  
  LET tm.dt = g_today        
  LET tm.g = "3"
 
  DISPLAY BY NAME tm.slip,tm.dt,tm.g
  LET g_success = 'Y'
  BEGIN WORK
  INPUT BY NAME tm.slip,tm.dt,tm.g  WITHOUT DEFAULTS
    AFTER FIELD slip
      IF NOT cl_null(tm.slip) THEN  
         LET g_cnt = 0
         CALL s_check_no("apm",tm.slip,'',"3","rva_file","rva01","")
           RETURNING li_result,tm.slip
         IF (NOT li_result) THEN
           CALL cl_err(tm.slip,'aap-010',0)       
           NEXT FIELD slip
         END IF
         DISPLAY BY NAME tm.slip
      END IF
  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW p220_exp
         RETURN
      END IF
  
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)
              CALL q_smy(FALSE,FALSE,tm.slip,'APM','3') 
                   RETURNING tm.slip
              DISPLAY BY NAME tm.slip
              NEXT FIELD slip
            OTHERWISE EXIT CASE
         END CASE
  
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
     LET INT_FLAG = 0
     LET g_success = 'N'
     ROLLBACK WORK      
     CLOSE WINDOW p220_exp
     RETURN
  END IF
  CLOSE WINDOW p220_exp
 
 
# LET l_wc = " pmn01 || pmn02 in ("                            #TQC-AB0025 mark
  LET l_wc = " pmn01 || CAST(pmn02 AS varchar(10)) in ("       #TQC-AB0025 add
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
     IF g_pmm1[l_i].a = 'Y' THEN
        LET l_n = l_n + 1
        IF l_n = 1 THEN
          LET l_wc = l_wc CLIPPED,"'",g_pmm1[l_i].pmm01 CLIPPED,g_pmm1[l_i].pmn02 USING '<<<<' ,"'"
        ELSE
          LET l_wc = l_wc CLIPPED,",'",g_pmm1[l_i].pmm01 CLIPPED,g_pmm1[l_i].pmn02 USING '<<<<',"'"
        END IF
     END IF
  END FOR
  LET l_wc = l_wc CLIPPED ,")"
  
 
 
  CASE tm.g
    WHEN "1"   #採購單      (pmm01)
      LET g_sql = "SELECT DISTINCT pmm01,'',"
    WHEN "2"   #供應商      (pmm09)  #依系統設定抓單據位數
      LET g_sql = "SELECT DISTINCT '','',"
    WHEN "3"   #不匯總      (pmm01+pmn02)
      LET g_sql = "SELECT DISTINCT pmm01,pmn02,"
  END CASE 
  LET g_sql = g_sql ,"pmm02,pmm09 ",
                     "  FROM  pmm_file,pmn_file ",
                     "   WHERE pmm01 = pmn01 ",
                     "     AND (pmn20-pmn50+pmn55+pmn58) > 0 ",   #No.FUN-9A0068 
                     "     AND ", l_wc ,
                     "  ORDER BY pmm02 "
  PREPARE pmm_pre FROM g_sql
  DECLARE pmm_cur2 CURSOR FOR pmm_pre
  FOREACH pmm_cur2 INTO  l_pmm01 ,g_pmn02,l_pmm02,l_pmm09
 
      ###在這一個foreach迴圈中就已經決定了要併成幾張收貨單
      CASE tm.g
        WHEN "1"  #by採購單
          LET g_sql = "SELECT pmm_file.* FROM pmm_file,pmn_file ",
                      "   WHERE pmm01 = pmn01",
                      "   AND pmm01 = '",l_pmm01 ,"'",
                      "   AND (pmn20-pmn50+pmn55+pmn58) > 0 "      #No.FUN-9A0068 
          LET g_ws1 = "   AND ",l_wc                               #No.TQC-C60156
          LET g_sql = g_sql,g_ws1,"   ORDER BY pmm01 "             #No.TQC-C60156

        WHEN "2"  #依供應商
          LET g_sql = "SELECT pmm_file.* FROM pmm_file,pmn_file ",
                      " WHERE pmm01 = pmn01 ",
                      "   AND (pmn20-pmn50+pmn55+pmn58) > 0 "      #No.FUN-9A0068 
          LET g_ws1 = "   AND pmm02 = '", l_pmm02,"'",
                      "   AND pmm09 = '", l_pmm09,"'",
                      "   AND ",l_wc
 
          LET g_sql = g_sql,g_ws1,"   ORDER BY pmm01 "
 
        WHEN "3"  #不匯總   
          LET g_sql = "SELECT pmm_file.* FROM pmm_file,pmn_file ",
                      " WHERE pmm01 = pmn01 ",
                      "   AND pmm01 ='", l_pmm01 CLIPPED, "'",
                      "   AND pmn02 =", g_pmn02,
                      "   AND (pmn20-pmn50+pmn55+pmn58) > 0 ",      #No.FUN-9A0068    
                      "  ORDER BY pmm01 "
      END CASE
 
      LET g_wc_pmm = NULL   
      PREPARE pmm_pre1  FROM g_sql
      DECLARE p220_pmm_cs  SCROLL CURSOR FOR pmm_pre1  #SCROLL CURSOR
      FOREACH p220_pmm_cs INTO g_pmm.*
         IF cl_null(g_wc_pmm) THEN
           LET g_wc_pmm = " pmn01 IN('",g_pmm.pmm01,"'"
         ELSE
           LET g_wc_pmm = g_wc_pmm,",'",g_pmm.pmm01,"'"
         END IF
      END FOREACH
      IF NOT cl_null(g_wc_pmm) THEN LET g_wc_pmm=g_wc_pmm,")" END IF
 
      CALL p220_ins_rva()
      IF g_success = 'N' THEN
        EXIT FOREACH
      END IF
  END FOREACH
 
  IF g_success = 'N' THEN
     ROLLBACK WORK
     CALL cl_err('','abm-020',1)
  ELSE
     COMMIT WORK
     IF NOT cl_null(begin_no) THEN
       LET g_msg = begin_no CLIPPED,"~",end_no CLIPPED
       CALL cl_err(g_msg CLIPPED,"mfg0101",1)
     END IF
  END IF
END FUNCTION
 
 
FUNCTION p220_ins_rva()
  DEFINE l_smyapr  LIKE smy_file.smyapr  #FUN-9C0076 add
  DEFINE l_t1      LIKE oay_file.oayslip #FUN-9C0076 add
 
  LET g_rva.rvaprsw = 'Y'  #MOD-820128
  LET g_rva.rva04   = 'N'  #MOD-810256
 
  IF g_pmm.pmm02 = 'SUB' THEN  
     LET g_rva.rva04='N'
  END IF
 
  IF tm.g = '1' OR tm.g='3' THEN
    LET g_rva.rva02 = g_pmm.pmm01
  IF NOT cl_null(g_rva.rva02) THEN
     LET g_cnt = 0
     SELECT COUNT(*) INTO g_cnt FROM alb_file
      WHERE alb04=g_rva.rva02
     IF g_cnt>0 THEN
        LET g_rva.rva04='Y'
     END IF
  END IF 
  END IF
  
  LET g_rva.rva05 = g_pmm.pmm09
  LET g_rva.rva10 = g_pmm.pmm02
  LET g_rva.rva06 = tm.dt 
  LET g_rva.rva21 = NULL            #MOD-840038
  LET g_rva.rvaconf = 'N'
  LET g_rva.rvaspc = '0'                               #FUN-680011
  LET g_rva.rvauser=g_user
  LET g_rva.rvagrup=g_grup
  LET g_rva.rvadate=g_today
  LET g_rva.rvaacti='Y'
  LET g_rva.rvaplant=g_plant        #FUN-980006 add
  LET g_rva.rvalegal=g_legal        #FUN-980006 add
  LET g_rva.rva32 = '0'             #簽核狀況  #FUN-9C0076 add
  LET g_rva.rva33 = g_user          #申請人    #FUN-9C0076 add
  LET l_t1=s_get_doc_no(tm.slip)    #FUN-9C0076 add

 #FUN-9C0076 add str ---
  SELECT smyapr INTO l_smyapr FROM smy_file
   WHERE smysys='apm' AND smykind='3' AND smyslip=l_t1   

  LET g_rva.rvamksg = l_smyapr      #是否簽核
 #FUN-9C0076 add end ---  
  
  CALL s_auto_assign_no("apm",tm.slip,g_rva.rva06,"3","rva_file","rva01","","","")
    RETURNING li_result,g_rva.rva01
  IF (NOT li_result) THEN
     LET g_success = 'N'
     RETURN
  END IF
  LET g_rva.rva00 = '1'            #FUN-940083 add
  LET g_rva.rva29 = '1'            #FUN-960130 add  #NO.FUN-9B0016
  LET g_rva.rvaoriu = g_user      #No.FUN-980030 10/01/04
  LET g_rva.rvaorig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO rva_file VALUES(g_rva.*)
  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     CALL s_errmsg('','','',SQLCA.sqlcode,1)      
     LET g_success = 'N'
     RETURN
  END IF
  LET g_count = 0    
 
  CASE tm.g
   WHEN "1"  #採購單
     LET g_sql = "SELECT pmn_file.* FROM pmn_file ",
                 " WHERE pmn01 = '",g_pmm.pmm01 CLIPPED ,"'",g_ws1,        #No.TQC-C60156
                 "   AND (pmn20-pmn50+pmn55+pmn58) > 0 "#No.FUN-9A0068  
   WHEN "2"  #供應商
     LET g_sql = "SELECT pmn_file.* FROM pmn_file,pmm_file ",
                 " WHERE pmn01 = pmm01 ",g_ws1,
                 "   AND (pmn20-pmn50+pmn55+pmn58) > 0 "#No.FUN-9A0068 
                 
   WHEN "3"  #不匯總
     LET g_sql = "SELECT pmn_file.* FROM pmn_file ",
                 " WHERE pmn01 = '",g_pmm.pmm01,"'",
                 "   AND pmn02 = ",g_pmn02,
                 "   AND (pmn20-pmn50+pmn55+pmn58) > 0 "#No.FUN-9A0068  
  END CASE
    
  LET l_rvb02 = 0
  PREPARE p220_prepare1 FROM g_sql
  IF SQLCA.sqlcode THEN 
     CALL s_errmsg('','','',SQLCA.sqlcode,1)   
     LET g_success = 'N'
     RETURN 
  END IF
   DECLARE p220_cs1 CURSOR WITH HOLD FOR p220_prepare1
   FOREACH p220_cs1 INTO g_pmn.* 
         LET l_rvb02 = l_rvb02 + 1
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)  
            LET g_success = 'N'
            RETURN 
         END IF
         LET g_rvb.rvb02  = l_rvb02     #項次
         CALL p220_ins_rvb()
         INITIALIZE g_pmn.* LIKE pmn_file.*   #DEFAULT 設定
         INITIALIZE g_rvb.* LIKE rvb_file.*   #DEFAULT 設定
   END FOREACH
   IF g_count = 0 THEN
      DELETE FROM rva_file WHERE rva01 = g_rva.rva01
   ELSE
      IF cl_null(begin_no) THEN 
         LET begin_no = g_rva.rva01
      END IF
      LET end_no=g_rva.rva01
   END IF
END FUNCTION
 
FUNCTION p220_ins_rvb()
   DEFINE l_ima491  LIKE ima_file.ima491
   DEFINE l_rvbi    RECORD LIKE rvbi_file.*   #No.FUN-7B0018
   DEFINE l_rvb87   LIKE rvb_file.rvb87       #No.MOD-8A0067
   DEFINE l_rvb29   LIKE rvb_file.rvb29       #No.MOD-930082
   DEFINE l_flag    LIKE type_file.chr1       #No.FUN-940083
   DEFINE l_fac     LIKE rvb_file.rvb90_fac   #No.FUN-940083
   DEFINE l_rtz08   LIKE rtz_file.rtz08       #FUN-B40098
   DEFINE l_rtz07   LIKE rtz_file.rtz07       #FUN-B60150 ADD
 
   LET  g_rvb.rvb01 = g_rva.rva01
   LET  g_rvb.rvb04 = g_pmn.pmn01
   LET  g_rvb.rvb03 = g_pmn.pmn02
   LET  g_rvb.rvb05 = g_pmn.pmn04
   LET  g_rvb.rvb06 = 0
 
   LET  l_rvb87 = 0
   LET  l_rvb29 = 0
   SELECT SUM(rvb87) INTO l_rvb87 FROM rva_file,rvb_file
    WHERE rvb04 = g_pmn.pmn01 AND rvb03 = g_pmn.pmn02
      AND rva01 = rvb01 AND rvaconf = 'N'
   IF cl_null(l_rvb87) THEN LET l_rvb87 = 0 END IF
 
   SELECT SUM(rvb29) INTO l_rvb29 FROM rva_file,rvb_file
    WHERE rvb04 = g_pmn.pmn01 AND rvb03 = g_pmn.pmn02
      AND rva01 = rvb01 AND rvaconf = 'N'
   IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
   LET  g_rvb.rvb07 = g_pmn.pmn20-g_pmn.pmn50+g_pmn.pmn55+g_pmn.pmn58-l_rvb87+l_rvb29 #No.FUN-9A0068 
   IF g_rvb.rvb07 <= 0 THEN
      LET l_rvb02 = l_rvb02 - 1
      RETURN
   END IF
 
   LET  g_rvb.rvb08 = g_rvb.rvb07
   LET  g_rvb.rvb09 = 0
   LET  g_rvb.rvb10 = g_pmn.pmn31
   LET  g_rvb.rvb10t = g_pmn.pmn31t
   LET  g_rvb.rvb11 = 0
   SELECT ima491 INTO l_ima491 FROM ima_file
    WHERE ima01 = g_rvb.rvb05
   IF cl_null(l_ima491) THEN
      LET l_ima491 = 0
   END IF
   IF l_ima491 > 0 THEN
      CALL s_getdate(g_rva.rva06,l_ima491) RETURNING g_rvb.rvb12
   ELSE
      IF cl_null(g_rvb.rvb12) THEN
         LET g_rvb.rvb12 = g_rva.rva06
      END IF
   END IF
   LET  g_rvb.rvb13 = NULL
   LET  g_rvb.rvb14 = NULL
   LET  g_rvb.rvb15 = 0
   LET  g_rvb.rvb16 = 0
   LET  g_rvb.rvb17 = NULL
   LET  g_rvb.rvb18 = '10'
   LET  g_rvb.rvb19 = g_pmn.pmn65
   LET  g_rvb.rvb20 = NULL
   LET  g_rvb.rvb21 = NULL
   LET  g_rvb.rvb25 = g_pmn.pmn71
   LET  g_rvb.rvb27  = 0     #NO USE
   LET  g_rvb.rvb28  = 0     #NO USE
   LET  g_rvb.rvb29  = 0     #退補量
   LET  g_rvb.rvb30  = 0     #入庫量
   LET  g_rvb.rvb31  = g_rvb.rvb07       #MOD-810221 modify 0->rvb07
   LET  g_rvb.rvb32  = 0     #NO USE
   LET  g_rvb.rvb33  = 0     #入庫量
   LET  g_rvb.rvb331  = 0    #允收量
   LET  g_rvb.rvb332  = 0    #允收量
   LET  g_rvb.rvb34 = g_pmn.pmn41
   LET  g_rvb.rvb35 = 'N'   #樣品否
   LET  g_rvb.rvb89 = g_pmn.pmn89      #VIM收貨否
   LET  g_rvb.rvb051 = g_pmn.pmn041    #品名規格
   LET  g_rvb.rvb90 = g_pmn.pmn07      #收貨單位
   #FUN-BB0083---add---str
   LET  g_rvb.rvb07 = s_digqty(g_rvb.rvb07,g_rvb.rvb90) 
   LET  g_rvb.rvb08 = s_digqty(g_rvb.rvb08,g_rvb.rvb90)
   LET  g_rvb.rvb31 = s_digqty(g_rvb.rvb31,g_rvb.rvb90)
   #FUN-BB0083---add---end
   IF g_rvb.rvb89 = 'Y' THEN
      SELECT pmc915,pmc916 INTO g_rvb.rvb36,g_rvb.rvb37
        FROM pmc_file
        WHERE pmc01 = g_rvb.rvb05
   ELSE   
      LET  g_rvb.rvb36 = g_pmn.pmn52
      LET  g_rvb.rvb37 = g_pmn.pmn54
      IF cl_null(g_rvb.rvb36) AND cl_null(g_rvb.rvb37)  THEN
         SELECT ima35,ima36 INTO g_rvb.rvb36,g_rvb.rvb37
           FROM ima_file
         WHERE ima01=g_rvb.rvb05
       #FUN-B60150 ADD&MARK BEGIN ----------------------------
       ##FUN-B40098 Begin---
       # IF g_azw.azw04 = '2' AND g_rva.rva29 = '3' THEN
       #    SELECT rtz08 INTO l_rtz08 FROM rtz_file
       #     WHERE rtz01 = g_rva.rvaplant
       #    IF NOT cl_null(l_rtz08) THEN
       #       LET g_rvb.rvb36 = l_rtz08
       #       LET g_rvb.rvb37 = ' '
       #       LET g_rvb.rvb38 = ' '
       #    END IF
       # END IF
       ##FUN-B40098 End-----

         IF g_azw.azw04 = '2' THEN
            #FUN-C90049 mark begin---
            #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
            # WHERE rtz01 = g_rva.rvaplant
            #FUN-C90049 mark end-----
            CALL s_get_defstore(g_rva.rvaplant,g_rvb.rvb05) RETURNING l_rtz07,l_rtz08     #FUN-C90049 add
             
            IF (g_rva.rva29 = '3' OR (g_rva.rva29 = '2' AND g_sma.sma146 = '2')) THEN
               IF NOT cl_null(l_rtz08) THEN
                  LET g_rvb.rvb36 = l_rtz08
                  LET g_rvb.rvb37 = ' '
                  LET g_rvb.rvb38 = ' '
               END IF
            END IF
            IF g_rva.rva29 = '2' AND g_sma.sma146 = '1' THEN
               IF NOT cl_null(l_rtz07) THEN
                  LET g_rvb.rvb36 = l_rtz07
                  LET g_rvb.rvb37 = ' '
                  LET g_rvb.rvb38 = ' '
               END IF
            END IF
         END IF
       #FUN-B60150 ADD&MARK   END ----------------------------
      END IF
   END IF                 #FUN-940083 add 
   LET  g_rvb.rvb38 = g_pmn.pmn56
   CALL p220_get_rvb39(g_rvb.rvb04,g_rvb.rvb05,g_rvb.rvb19) 
        RETURNING g_rvb.rvb39
   LET  g_rvb.rvb40 = ''    #檢驗日期 no.7143
 
   LET  g_rvb.rvb80 = g_pmn.pmn80 
   LET  g_rvb.rvb81 = g_pmn.pmn81 
   LET  g_rvb.rvb82 = g_pmn.pmn82 
   LET  g_rvb.rvb83 = g_pmn.pmn83 
   LET  g_rvb.rvb84 = g_pmn.pmn84 
   LET  g_rvb.rvb85 = g_pmn.pmn85 
   LET  g_rvb.rvb86 = g_pmn.pmn86 
   SELECT SUM(rvb87) INTO l_rvb87 FROM rva_file,rvb_file   #MOD-9B0135
    WHERE rvb04 = g_pmn.pmn01
      AND rvb03 = g_pmn.pmn02
      AND rva01 = rvb01   #MOD-9B0135
      AND rvaconf <> 'X'  #MOD-9B0135
   IF cl_null(l_rvb87) THEN LET l_rvb87 = 0 END IF
   SELECT SUM(rvb29) INTO l_rvb29 FROM rva_file,rvb_file   #MOD-9B0135
    WHERE rvb04 = g_pmn.pmn01
      AND rvb03 = g_pmn.pmn02
      AND rva01 = rvb01   #MOD-9B0135
      AND rvaconf <> 'X'  #MOD-9B0135
   IF cl_null(l_rvb29) THEN LET l_rvb29 = 0 END IF
   LET  g_rvb.rvb87 = g_pmn.pmn87 - l_rvb87 + l_rvb29
   LET  g_rvb.rvb88 = g_rvb.rvb87 * g_rvb.rvb10
   LET  g_rvb.rvb88t= g_rvb.rvb87 * g_rvb.rvb10t
   LET  g_rvb.rvb930 = g_pmn.pmn930 
   IF g_rvb.rvb38 IS NULL THEN
      LET g_rvb.rvb38=' '
   END IF
   IF g_rvb.rvb37 IS NULL THEN
      LET g_rvb.rvb37=' '
   END IF
   SELECT img09 INTO g_img09
      FROM img_file          #庫存單位
      WHERE img01=g_rvb.rvb05 AND img02=g_rvb.rvb36
        AND img03=g_rvb.rvb37 AND img04=g_rvb.rvb38
   CALL s_umfchk(g_rvb.rvb05,g_rvb.rvb90,g_img09)
        RETURNING l_flag,l_fac 
   IF l_flag THEN
      CALL cl_err(g_rvb.rvb90,'mfg7003',1)
      LET g_rvb.rvb90_fac = 1
   ELSE 
      LET g_rvb.rvb90_fac = l_fac
   END IF 
          
   LET  g_rvb.rvbplant = g_plant   #FUN-980006 add
   LET  g_rvb.rvblegal = g_legal   #FUN-980006 add
   LET  g_rvb.rvb42 =  ' '          #FUN-960130 add
   LET  g_rvb.rvb919 = g_pmn.pmn919    #FUN-A80150 add
   INSERT INTO rvb_file VALUES(g_rvb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p220_ins_rvb():",SQLCA.sqlcode,1)  
      LET g_success = 'N'
      RETURN
   ELSE
      LET g_count = g_count + 1   #MOD-990084
      IF NOT s_industry('std') THEN
         INITIALIZE l_rvbi.* TO NULL
         LET l_rvbi.rvbi01 = g_rvb.rvb01
         LET l_rvbi.rvbi02 = g_rvb.rvb02
         IF NOT s_ins_rvbi(l_rvbi.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
 
  IF NOT cl_null(g_rvb.rvb36) THEN
    IF g_sma.sma886[7,7] ='Y' THEN
      SELECT img07,img10,img09 INTO g_img07,g_img10,g_img09
        FROM img_file   #採購單位,庫存數量,庫存單位
       WHERE img01=g_rvb.rvb05 AND img02=g_rvb.rvb36
         AND img03=g_rvb.rvb37 AND img04=g_rvb.rvb38
      IF STATUS=100 AND (g_rvb.rvb36 IS NOT NULL AND g_rvb.rvb36 <> ' ') THEN
          CALL s_add_img(g_rvb.rvb05,g_rvb.rvb36,
                         g_rvb.rvb37,g_rvb.rvb38,
                         g_rva.rva01,g_rvb.rvb02,g_rva.rva06)
      END IF
      SELECT ima906 INTO g_ima906 FROM ima_file
       WHERE ima01=g_rvb.rvb05
      IF g_ima906 = '2' THEN
        IF NOT cl_null(g_rvb.rvb83) THEN
           CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                           g_rvb.rvb37,g_rvb.rvb38,
                           g_rvb.rvb83) RETURNING g_flag
           IF g_flag = 1 THEN
                CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                                g_rvb.rvb37,g_rvb.rvb38,
                                g_rvb.rvb83,g_rvb.rvb84,
                                g_rva.rva01,
                                g_rvb.rvb02,0) RETURNING g_flag
           END IF
        END IF
        IF NOT cl_null(g_rvb.rvb80) THEN
           CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                           g_rvb.rvb37,g_rvb.rvb38,
                           g_rvb.rvb80) RETURNING g_flag
           IF g_flag = 1 THEN
                CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                                g_rvb.rvb37,g_rvb.rvb38,
                                g_rvb.rvb80,g_rvb.rvb81,
                                g_rva.rva01,
                                g_rvb.rvb02,0) RETURNING g_flag
           END IF
        END IF
      END IF
 
      IF g_ima906 = '3' THEN
        IF NOT cl_null(g_rvb.rvb83) THEN
           CALL s_chk_imgg(g_rvb.rvb05,g_rvb.rvb36,
                           g_rvb.rvb37,g_rvb.rvb38,
                           g_rvb.rvb83) RETURNING g_flag
           IF g_flag = 1 THEN
                CALL s_add_imgg(g_rvb.rvb05,g_rvb.rvb36,
                                g_rvb.rvb37,g_rvb.rvb38,
                                g_rvb.rvb83,g_rvb.rvb84,
                                g_rva.rva01,
                                g_rvb.rvb02,0) RETURNING g_flag
           END IF
        END IF
      END IF
    END IF
  END IF
END FUNCTION
 
FUNCTION p220_get_rvb39(p_rvb04,p_rvb05,p_rvb19)
   DEFINE l_pmh08   LIKE pmh_file.pmh08,    
          l_pmm22   LIKE pmm_file.pmm22,
          p_rvb04   LIKE rvb_file.rvb04,
          p_rvb05   LIKE rvb_file.rvb05,
          p_rvb19   LIKE rvb_file.rvb19,
          l_rvb39   LIKE rvb_file.rvb39
   DEFINE l_ima915  LIKE ima_file.ima915   #FUN-710060 add
   DEFINE l_pmh21   LIKE pmh_file.pmh21,   #No.CHI-8C0017
          l_pmh22   LIKE pmh_file.pmh22    #No.CHI-8C0017    
  
  #IF g_sma.sma63='1' THEN #料件供應商控制方式,1: 需作料件供應商管制
  #                        #                   2: 不作料件供應商管制
   SELECT ima915 INTO l_ima915 FROM ima_file
    WHERE ima01=p_rvb05
   IF l_ima915='2' OR l_ima915='3' THEN 
      SELECT pmm22 INTO l_pmm22 FROM pmm_file
       WHERE pmm01=p_rvb04
       
      IF g_pmm.pmm02='SUB' THEN
         LET l_pmh22='2'
           IF g_pmn.pmn43 = 0 OR cl_null(g_pmn.pmn43) THEN    #NO.TQC-920098
            LET l_pmh21 =' '
         ELSE
           IF NOT cl_null(g_pmn.pmn18) THEN
            SELECT sgm04 INTO l_pmh21 FROM sgm_file
             WHERE sgm01=g_pmn.pmn18
               AND sgm02=g_pmn.pmn41
               AND sgm03=g_pmn.pmn43
               AND sgm012 = g_pmn.pmn012   #FUN-A60076 
           ELSE
            SELECT ecm04 INTO l_pmh21 FROM ecm_file 
             WHERE ecm01=g_pmn.pmn41
               AND ecm03=g_pmn.pmn43
               AND ecm012 = g_pmn.pmn012    #FUN-A60027
           END IF
         END IF     #NO.TQC-910033
      ELSE
         LET l_pmh22='1'
         LET l_pmh21=' '
      END IF
 
      SELECT pmh08 INTO l_pmh08 FROM pmh_file
       WHERE pmh01=p_rvb05
         AND pmh02=g_rva.rva05
         AND pmh13=l_pmm22
         AND pmh21 = l_pmh21                                                      #CHI-8C0017
         AND pmh22 = l_pmh22                                                      #CHI-8C0017
         AND pmh23 = ' '                                             #No.CHI-960033
         AND pmhacti = 'Y'                                           #CHI-910021         
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   ELSE
      SELECT ima24 INTO l_pmh08 FROM ima_file
       WHERE ima01=p_rvb05
 
      IF cl_null(l_pmh08) THEN
         LET l_pmh08 = 'N'
      END IF
 
      IF p_rvb05[1,4] = 'MISC' THEN
         LET l_pmh08='N'
      END IF
   END IF
 
   IF l_pmh08='N' OR     #免驗料
      (g_sma.sma886[6,6]='N' AND g_sma.sma886[8,8]='N') OR #視同免驗
      p_rvb19='2' THEN #委外代買料
      LET l_rvb39 = 'N'
   ELSE
      LET l_rvb39 = 'Y'
   END IF
 
   RETURN l_rvb39
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
