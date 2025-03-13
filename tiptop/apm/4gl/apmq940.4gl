# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: apmq940.4gl
# Descriptions...: 多角代採買追蹤查詢作業 
# Date & Author..: No: FUN-620048 06/02/21 By TSD.kevin
# Modify.........: No.FUN-590083 06/03/30 BY Alexstar 新增資料多語言功能    
# Modify.........: NO.TQC-640119 06/04/09 by Yiting 找出來的單子不對
# Modify.........: NO.MOD-640474 06/04/14 By Mandy 1.訂單明細=>show的順序PO->SO->PO->SO
#                                                  2.出貨明細=>show的順序收/入->出->收/入->出
#                                                  3.立帳明細=>show的順序應付->應收->應付->應收
# Modify.........: NO.MOD-640474 06/04/19 By Mandy 1.訂單明細=>單價前加秀匯率
#                                                  2.出貨明細=>品名之後加倉/儲/批
#                                                  3.立帳明細=>客戶簡稱之後加類別,部門 
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: NO.TQC-6A0056 06/10/23 BY yiting poz05在3.5x版之後並無資料，己在poy04單身處理
# Modify.........: No.TQC-7C0095 07/12/08 By chenl 未過賬采購入庫單造成出貨查詢錯誤
# Modify.........: No.MOD-810220 08/01/28 By claire 採購單的金額應以計價數量計算
# Modify.........: No.MOD-860279 08/06/25 By claire (1)修改g_poy.azp03的定義(2)l_cnt的初始值
# Modify.........: No.MOD-870104 08/07/11 By claire 未排除作廢單據
# Modify.........: No.MOD-880035 08/08/07 By claire 未排除倉退單據
# Modify.........: No.MOD-890042 08/09/04 By claire 未排除折讓(銷退)單據
# Modify.........: No.MOD-910074 09/01/08 By claire 採購含稅,未稅金額;以pmn88,pmn88t計算
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()
# Modify.........: No.MOD-970211 09/07/24 By Dido 增加跨主機語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980091 09/09/18 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No:MOD-A20058 10/02/09 By Dido 若收貨對應多張入庫時,應可查詢 
# Modify.........: No.TQC-A50139 10/07/15 By houlia 查詢時，除了首站的入庫單資料的現實 
# Modify.........: No.TQC-A70070 10/07/16 By liuxqa 修正MOD-A20058，中間站的入庫單沒有抓出來。
# Modify.........: No.FUN-A50102 10/07/19 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-B10245 11/02/09 By Summer 抓取的單據都要排除作廢
# Modify.........: No:FUN-B30078 11/04/28 By lixiang 可查詢到採購入庫資料，增加"倉退"查詢
#                                                    單頭增加多角序號顯示及by多角序號查詢功能
#                                                    增加銷退查詢/多角序號查詢
# Modify.........: No:FUN-B90012 11/09/27 By fengrui 增加刻號／BIN明細 or 查詢
# Modify.........: No:MOD-BA0094 11/12/19 By Summer 出貨明細出現多筆重複的入庫單資料 
# Modify.........: No:FUN-C10021 12/04/05 By Sakura 使用dialog將單頭單身包起來，原瀏覽/回單頭Action取消 
# Modify.........: No:TQC-C80031 12/08/07 By SunLM  在出貨明細頁簽增加未稅金額欄位顯示
# Modify.........: No:FUN-CC0090 13/04/08 By jt_chen apmq940增加負向立帳資料明細

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#DEFINE g_up    LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1) #FUN-C10021 mark
DEFINE g_pmm   DYNAMIC ARRAY OF RECORD        # 採購單
               pmm01    LIKE pmm_file.pmm01,
               pmm04    LIKE pmm_file.pmm04,
               pmm09    LIKE pmm_file.pmm09,
               pmc03a   LIKE pmc_file.pmc03,
               pmm50    LIKE pmm_file.pmm50,
               pmc03b   LIKE pmc_file.pmc03,
               pmm12    LIKE pmm_file.pmm12,
               gen02    LIKE gen_file.gen02,
               pmm904   LIKE pmm_file.pmm904,
               pmm99    LIKE pmm_file.pmm99,        #No:FUN-B30078
               pmm18    LIKE pmm_file.pmm18,
               pmm905   LIKE pmm_file.pmm905
               END RECORD,
       g_oea   DYNAMIC ARRAY OF RECORD        # 訂單明細
               poy04_1  LIKE poy_file.poy04,
               ps       LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1) # 類型
               oea01    LIKE oea_file.oea01,
               oea03    LIKE oea_file.oea03,
               oea032   LIKE oea_file.oea032,
               oea31    LIKE oea_file.oea31,
               oea32    LIKE oea_file.oea32,
               oea21    LIKE oea_file.oea21,
               oea23    LIKE oea_file.oea23,
               oeb03    LIKE oeb_file.oeb03,
               oeb04    LIKE oeb_file.oeb04,
               oeb06    LIKE oeb_file.oeb06,
               oeb12    LIKE oeb_file.oeb12,
               oeb24    LIKE oeb_file.oeb24,
               oea24    LIKE oea_file.oea24, #MOD-640474 add 
               oeb13    LIKE oeb_file.oeb13,
               oeb15    LIKE oeb_file.oeb15,
               oeb14    LIKE oeb_file.oeb14,
               oeb14t   LIKE oeb_file.oeb14t,
               oea05    LIKE oea_file.oea05
               END RECORD,
       g_oga   DYNAMIC ARRAY OF RECORD        # 出貨明細
               oga99    LIKE oga_file.oga99,
               poy04_2  LIKE poy_file.poy04,
               outin    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
               oga01    LIKE oga_file.oga01,
               oga31    LIKE oga_file.oga31,
               oga32    LIKE oga_file.oga32,
               oga21    LIKE oga_file.oga21,
               oga23    LIKE oga_file.oga23,
               ogb03    LIKE ogb_file.ogb03,
               ogb04    LIKE ogb_file.ogb04,
               ogb06    LIKE ogb_file.ogb06,
               ogb09    LIKE ogb_file.ogb09,  #MOD-640474 add
               ogb091   LIKE ogb_file.ogb091, #MOD-640474 add
               ogb092   LIKE ogb_file.ogb092, #MOD-640474 add
               ogb12    LIKE ogb_file.ogb12,
               ogb13    LIKE ogb_file.ogb13,
               ogb14    LIKE ogb_file.ogb14,  #TQC-C80031 add
               oga05    LIKE oga_file.oga05
               END RECORD,
       g_oma   DYNAMIC ARRAY OF RECORD        # 立帳明細
               oma99    LIKE oma_file.oma99,
               poy04_3  LIKE poy_file.poy04,
               pay      LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
               oma01    LIKE oma_file.oma01,
               oma03    LIKE oma_file.oma03,
               oma032   LIKE oma_file.oma032,
               oma13    LIKE oma_file.oma13, #MOD-640474 add
               oma15    LIKE oma_file.oma15, #MOD-640474 add
               oma32    LIKE oma_file.oma32,
               oma21    LIKE oma_file.oma21,
               oma23    LIKE oma_file.oma23,
               oma24    LIKE oma_file.oma24,
               oma54t   LIKE oma_file.oma54t,
               oma56t   LIKE oma_file.oma56t
               END RECORD,
       #--#No:FUN-B30078--ADD--
       g_rvv   DYNAMIC ARRAY OF RECORD
               rvu99    LIKE rvu_file.rvu99,
               poy04_4  LIKE poy_file.poy04,
               kind     LIKE type_file.chr1,
               rvu01    LIKE rvu_file.rvu01,
               rvv02    LIKE rvv_file.rvv02,
               rvv31    LIKE rvv_file.rvv31,
               rvv031   LIKE rvv_file.rvv031,
               ima021   LIKE ima_file.ima021,
               rvv35    LIKE rvv_file.rvv35,
               rvv35_fac LIKE rvv_file.rvv35_fac,
               rvv17    LIKE rvv_file.rvv17,
               rvv32    LIKE rvv_file.rvv32,
               rvv33    LIKE rvv_file.rvv33,
               rvv34    LIKE rvv_file.rvv34,
               rvv38    LIKE rvv_file.rvv38,
               rvv39    LIKE rvv_file.rvv39,
               rvv39t   LIKE rvv_file.rvv39t,
               rvv26    LIKE rvv_file.rvv26,
               azf03    LIKE azf_file.azf03,
               rvv41    LIKE rvv_file.rvv41
               END RECORD,
      #--#No:FUN-B30078--END--
       g_poy   DYNAMIC ARRAY OF RECORD        
               poy02    LIKE poy_file.poy02,  # 站別 
               poy04    LIKE poy_file.poy04,  # 工廠編號 
               azp03    LIKE azp_file.azp03,  # 資料庫代號  #MOD-860279
               azp03_tra LIKE azp_file.azp03  #TRAN資料庫代號 #FUN-980091
               END RECORD,
       g_rva   DYNAMIC ARRAY OF RECORD
               rva99    LIKE rva_file.rva99   # 多角貿易流程序號
               END RECORD,
       g_pmm2  DYNAMIC ARRAY OF RECORD
               pmm99    LIKE pmm_file.pmm99   # 多角貿易流程序號
               END RECORD,
       g_wc2,g_sql    STRING,
       g_rec_b        LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       g_rec_b1       LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       g_rec_b2       LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       g_rec_b3       LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       g_rec_b4       LIKE type_file.num5,         #No.FUN-680136 SMALLINT  #No.FUN-B30078
       l_ac           LIKE type_file.num5,         #No.FUN-680136 SMALLINT
       l_ac1          LIKE type_file.num5          #No.FUN-B90012 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_cnt,l_cnt    LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE l_cnt2,l_cnt3  LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE l_i,l_j        LIKE type_file.num5          #No.FUN-680136 SMALLINT 
DEFINE l_flag         LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW q940_w AT p_row,p_col WITH FORM "apm/42f/apmq940"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL q940_menu()
 
   CLOSE WINDOW q940_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q940_menu()
 
   WHILE TRUE
      CALL q940_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q940_q()
            END IF
        #FUN-C10021---mark---START 
        #WHEN "view1"
        #     CALL q940_bp_view1()
 
        #WHEN "view2"
        #     CALL q940_bp_view2()
 
        #WHEN "view3"
        #     CALL q940_bp_view3()
        #
        #WHEN "view4"                      #No.FUN-B30078
        #     CALL q940_bp_view4()          #No.FUN-B30078
        #FUN-C10021---mark---END

         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            #LET g_up = 'R' #FUN-C10021 mark
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q940_q()
 
   CALL q940_b_askkey()
 
END FUNCTION
 
FUNCTION q940_b_askkey()
 
   CLEAR FORM
   CALL g_pmm.clear()
   CALL g_oea.clear()
   CALL g_oga.clear()
   CALL g_oma.clear()
   CALL g_rvv.clear()     #No.FUN-B30078
 
   CONSTRUCT g_wc2 ON pmm01,pmm04,pmm09,pmm50,pmm12,
                      pmm904,pmm99,pmm18,pmm905          #No.FUN-B30078  add pmm99
                 FROM s_pmm[1].pmm01,s_pmm[1].pmm04,s_pmm[1].pmm09,
                      s_pmm[1].pmm50,s_pmm[1].pmm12,s_pmm[1].pmm904,
                      s_pmm[1].pmm99,s_pmm[1].pmm18,s_pmm[1].pmm905    #No.FUN-B30078
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmm01)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmm01"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm01
                   NEXT FIELD pmm01
 
              WHEN INFIELD(pmm09)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc2"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm09
                   NEXT FIELD pmm09
 
              WHEN INFIELD(pmm50)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_pmc2"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm50
                   NEXT FIELD pmm50
 
              WHEN INFIELD(pmm12)                                             
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm12
                   NEXT FIELD pmm12
 
              WHEN INFIELD(pmm904)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_poz"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pmm904
                   NEXT FIELD pmm904
 
              OTHERWISE EXIT CASE
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
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL q940_b_fill_pmm(g_wc2)
 
   LET l_ac = 1
   
END FUNCTION
 
# 訂單明細
FUNCTION q940_b_fill_oea()
 
   CALL g_poy.clear()
   CALL g_oea.clear() 
   LET g_rec_b1 = 0
   DISPLAY g_rec_b1 TO FORMONLY.cn1  
 
   IF cl_null(g_pmm[l_ac].pmm904) THEN
      CALL cl_err('','TSD0005',0)
      RETURN 
   END IF
   IF cl_null(g_pmm2[l_ac].pmm99) THEN
      RETURN
   END IF
 
   LET l_cnt = 1
 
   LET g_sql = "SELECT poy02,poy04,azp03 ",
               "      ,'' ",#FUN-980091 azp03_tra
               "  FROM poy_file, azp_file ",     
               " WHERE poy01 = '",g_pmm[l_ac].pmm904,"' ",
               "   AND poy04 = azp01 ",
               " ORDER BY poy02 "
   PREPARE q940_pb1 FROM g_sql
   DECLARE oea_curs1 CURSOR FOR q940_pb1
  
   LET l_cnt = 2 
   LET l_cnt = 1  #MOD-860279
   LET g_cnt = 1
   LET l_flag = 'Y'
   # 取得所有站別營運中心
   FOREACH oea_curs1 INTO g_poy[l_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:oea",STATUS,0)
         EXIT FOREACH
      END IF
 
      LET g_plant_new = g_poy[l_cnt].poy04
      CALL s_gettrandbs()
      LET g_poy[l_cnt].azp03_tra = g_dbs_tra
 
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL g_poy.deleteElement(l_cnt)
   LET l_cnt = l_cnt - 1
   
   # 依資料庫撈取訂單明細
   FOR l_i = 1 TO l_cnt 
       #==>採購單
       LET g_sql = "SELECT '",g_poy[l_i].poy04,"', ",
                   "       '2',pmm01,pmm09,pmc03,pmm41,pmm20,pmm21, ",
                   "       pmm22,pmn02,pmn04,pmn041,pmn20,pmn50,pmm42,pmn31, ", #MOD-640474 add pmm42 匯率
                   "       pmn33,pmn88,pmn88t,'' ",              #MOD-910074  
                  #"  FROM ",s_dbstring(g_poy[l_i].azp03_tra),"pmm_file, ",     #FUN-A50102 mark                                                           
                  #          s_dbstring(g_poy[l_i].azp03_tra),"pmn_file, ",     #FUN-A50102 mark                                                          
                  #          s_dbstring(g_poy[l_i].azp03),"pmc_file ",          #FUN-A50102 mark     
                   "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'pmm_file'),",",  #FUN-A50102
                             cl_get_target_table(g_poy[l_i].poy04,'pmn_file'),",",  #FUN-A50102
                             cl_get_target_table(g_poy[l_i].poy04,'pmc_file'),      #FUN-A50102                                                     
                   " WHERE pmm01 = pmn01 ",
                   "   AND pmm09 = pmc01 ",
                   "   AND pmm99 = '",g_pmm2[l_ac].pmm99,"' ",
                   "   AND pmm18 <> 'X' ", #MOD-B10245 add
                   "   ORDER BY pmm01,pmn02 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql	#MOD-970211
       CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql #FUN-980091
       PREPARE q940_pb1_1 FROM g_sql
       DECLARE oea_curs1_1 CURSOR FOR q940_pb1_1
       
       #==>訂單
       LET g_sql = "SELECT '",g_poy[l_i].poy04,"', ",
                   "       '1',oea01,oea03,oea032,oea31,oea32,oea21, ",
                   "       oea23,oeb03,oeb04,oeb06,oeb12,oeb24,oea24,oeb13, ", #MOD-640474 add oea24 匯率
                   "       oeb15,oeb14,oeb14t,oea05 ",
                  #"  FROM ",s_dbstring(g_poy[l_i].azp03_tra),"oea_file, ",        #FUN-A50102 mark                                                         
                  #          s_dbstring(g_poy[l_i].azp03_tra),"oeb_file ",         #FUN-A50102 mark
                   "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'oea_file'),",",     #FUN-A50102
                             cl_get_target_table(g_poy[l_i].poy04,'oeb_file'),         #FUN-A50102                                                         
                   " WHERE oea01 = oeb01 ",
                   "   AND oea99 = '",g_pmm2[l_ac].pmm99,"' ",
                   "   AND oeaconf <> 'X' ", #MOD-B10245 add
                   "  ORDER BY oea01,oeb03 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql	#MOD-970211
       CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql #FUN-980091
       PREPARE q940_pb1_2 FROM g_sql
       DECLARE oea_curs1_2 CURSOR FOR q940_pb1_2
       IF (l_i = 1 ) THEN  # 判斷
                           #來源站先抓採購單,再抓訂單
                           #其餘  先抓訂單  ,再抓採購單
       
           # 採購單
           FOREACH oea_curs1_1 INTO g_oea[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb1_1",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 EXIT FOREACH
              END IF
           END FOREACH
           CALL g_oea.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              EXIT FOR
           END IF
 
           # 訂單
           FOREACH oea_curs1_2 INTO g_oea[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb1_2",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 EXIT FOREACH
              END IF
           END FOREACH
           CALL g_oea.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              EXIT FOR
           END IF
       ELSE
           # 訂單
           FOREACH oea_curs1_2 INTO g_oea[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb1_2",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 EXIT FOREACH
              END IF
           END FOREACH
           CALL g_oea.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              EXIT FOR
           END IF
 
           # 採購單
           FOREACH oea_curs1_1 INTO g_oea[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb1_1",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 EXIT FOREACH
              END IF
           END FOREACH
           CALL g_oea.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              EXIT FOR
           END IF
       END IF
   END FOR
 
   LET g_rec_b1 = g_cnt - 1
   MESSAGE ""
   DISPLAY g_rec_b1 TO FORMONLY.cn1
   LET g_cnt = 0
END FUNCTION
 
# 出貨明細
FUNCTION q940_b_fill_oga()
DEFINE l_k,l_l             LIKE type_file.num5          #MOD-A20058 
DEFINE l_oga01,l_oga01_old LIKE oga_file.oga01          #MOD-A20058 
DEFINE l_m                 LIKE type_file.num5          #MOD-BA0094 add
 
   CALL g_oga.clear()
   CALL g_rva.clear()
 
   LET l_cnt2 = 1
   LET g_cnt = 1
   LET l_flag = 'Y'
   LET g_sql = "SELECT rva99 ",
               "  FROM rva_file, rvb_file ",
               " WHERE rva01 = rvb01 ",
               "   AND rvaconf <> 'X' ",   #MOD-870104 add
               "   AND rvb04 = '",g_pmm[l_ac].pmm01,"' ",
               "  GROUP BY rva99 "
   PREPARE q940_pb2 FROM g_sql
   DECLARE oga_curs2 CURSOR FOR q940_pb2
   # 多角貿易流程序號(出貨)
   FOREACH oga_curs2 INTO g_rva[l_cnt2].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,0)
         EXIT FOREACH
      END IF
      LET l_cnt2 = l_cnt2 + 1
   END FOREACH 
   LET l_cnt2 = l_cnt2 - 1
 
   FOR l_i = 1 TO l_cnt
       FOR l_j = 1 TO l_cnt2     
           #==>收貨
           LET g_sql = "SELECT '",g_rva[l_j].rva99,"', ",
                       "       '",g_poy[l_i].poy04,"', ",
                       "       '1',rva01,pmm41,pmm20,pmm21,pmm22, ",
                       "       rvb02,rvb05,pmn041,rvb36,rvb37,rvb38,rvb07,rvb10,rvb88,'' ", #MOD-640474 add rvb36/rvb37/rvb38 倉/儲/批 #TQC-C80031 add rvb88
                     # "  FROM ",s_dbstring(g_poy[l_i].azp03_tra),"rva_file, ",            #FUN-A50102 mark                                                      
                     #           s_dbstring(g_poy[l_i].azp03_tra),"rvb_file, ",            #FUN-A50102 mark                                                   
                     #           s_dbstring(g_poy[l_i].azp03_tra),"pmm_file, ",            #FUN-A50102 mark                                                   
                     #           s_dbstring(g_poy[l_i].azp03_tra),"pmn_file ",             #FUN-A50102 mark
                       "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'rva_file'),",",     #FUN-A50102
                                 cl_get_target_table(g_poy[l_i].poy04,'rvb_file'),",",     #FUN-A50102
                                 cl_get_target_table(g_poy[l_i].poy04,'pmm_file'),",",     #FUN-A50102
                                 cl_get_target_table(g_poy[l_i].poy04,'pmn_file'),         #FUN-A50102                                                  
                       " WHERE rva01 = rvb01 AND pmm01 = pmn01 ",
                       "   AND rva99 = '",g_rva[l_j].rva99,"' ",
                       "   AND rvb04 = pmn01 AND rvb03 = pmn02 ",
                       "   AND rvaconf <> 'X' ",   #MOD-B10245 add
                       "   AND pmm18 <> 'X' ",     #MOD-B10245 add
                       " ORDER BY rva01,rvb02 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql	#MOD-970211
           CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql #FUN-980091
           PREPARE q940_pb2_1 FROM g_sql
           DECLARE oga_curs2_1 CURSOR FOR q940_pb2_1
 
          #-MOD-A20058-mark-
          ##==>入庫
          #LET g_sql = "SELECT '",g_rva[l_j].rva99,"', ",
          #            "       '",g_poy[l_i].poy04,"', ",
          #            "       '2',rvu01,pmm41,pmm20,pmm21,pmm22, ",
          #            "       rvv02,rvv31,rvv031,rvv32,rvv33,rvv34,rvv17,rvv38,'' ", #MOD-640474 add rvv32,rvv33,rvv34 倉/儲/批
          #            "  FROM ",s_dbstring(g_poy[l_i].azp03_tra),"rvu_file, ",                                                         
          #                      s_dbstring(g_poy[l_i].azp03_tra),"rvv_file, ",                                                         
          #                      s_dbstring(g_poy[l_i].azp03_tra),"pmm_file, ",                                                         
          #                      s_dbstring(g_poy[l_i].azp03_tra),"pmn_file ",                                                          
          #            " WHERE rvu01 = rvv01 AND pmm01 = pmn01 ",
          #            "   AND rvu99 = '",g_rva[l_j].rva99,"' ",
          #            "   AND rvu00 = '1'",                        #MOD-880035 add
          #            "   AND rvv36 = pmn01 AND rvv37 = pmn02 ",
          #            " ORDER BY rvu01,rvv02 "
          #CALL cl_replace_sqldb(g_sql) RETURNING g_sql	#MOD-970211
          #CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql #FUN-980091
          #PREPARE q940_pb2_2 FROM g_sql
          #DECLARE oga_curs2_2 CURSOR FOR q940_pb2_2
          #-MOD-A20058-end-
 
           #==>出貨
           LET g_sql = "SELECT '",g_rva[l_j].rva99,"', ",
                       "       '",g_poy[l_i].poy04,"', ",
                       "       '3',oga01,oga31,oga32,oga21,oga23, ",
                       "       ogb03,ogb04,ogb06,ogb09,ogb091,ogb092,ogb12,ogb13,ogb14,oga05 ", #MOD-640474 add ogb09,ogb091,ogb092 倉/儲/批 #TQC-C80031 add ogb14
                      #"  FROM ",s_dbstring(g_poy[l_i].azp03_tra),"oga_file, ",      #FUN-A50102 mark                                                   
                      #          s_dbstring(g_poy[l_i].azp03_tra),"ogb_file ",       #FUN-A50102 mark
                       " FROM ",cl_get_target_table(g_poy[l_i].poy04,'oga_file'),",",#FUN-A50102
                                cl_get_target_table(g_poy[l_i].poy04,'ogb_file'),    #FUN-A50102                                                    
                       " WHERE oga01 = ogb01 ",
                       "   AND oga99 = '",g_rva[l_j].rva99,"' ",
                       "   AND ogaconf <> 'X' ",   #MOD-B10245 add
                       " ORDER BY oga01,ogb03 "
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql	#MOD-970211
           CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql #FUN-980091
           PREPARE q940_pb2_3 FROM g_sql
           DECLARE oga_curs2_3 CURSOR FOR q940_pb2_3
        IF NOT cl_null(g_rva[l_j].rva99) AND g_rva[l_j].rva99 <>' ' THEN  #TQC-7C0095
           IF (l_i = 1 ) THEN  # 判斷
                               #來源站先抓收貨/入庫,再抓出貨
                               #其餘  先抓出貨     ,再抓收貨/入庫
               # 收貨單
               LET l_m = g_oga.getlength()        #MOD-BA0094 add
               IF l_m = 0 THEN LET l_m = 1 END IF #MOD-BA0094 add
               FOREACH oga_curs2_1 INTO g_oga[g_cnt].*
                  IF STATUS THEN
                     CALL cl_err("foreach:pb2_2",STATUS,0)
                     EXIT FOREACH
                  END IF
                  LET g_cnt = g_cnt + 1
                  IF g_cnt > g_max_rec THEN
                     CALL cl_err("",9035,0)
                     LET l_flag = 'N'
                     EXIT FOREACH
                  END IF
               END FOREACH
               CALL g_oga.deleteElement(g_cnt)
               IF l_flag = 'N' THEN
                  RETURN
               END IF
              #-MOD-A20058-add- 
               LET l_l = g_oga.getlength() 
               LET l_oga01_old = ' ' 
              #FOR l_k = 1 TO l_l   #MOD-BA0094 mark
               FOR l_k = l_m TO l_l #MOD-BA0094
                  LET l_oga01 = g_oga[l_k].oga01
                  IF l_oga01_old <> l_oga01 THEN 
                     LET l_oga01 = g_oga[l_k].oga01 
                     #==>入庫
                     LET g_sql = "SELECT rvu99, ",
                                 "       '",g_poy[l_i].poy04,"', ",
                                 "       '2',rvu01,pmm41,pmm20,pmm21,pmm22, ",
                                 "       rvv02,rvv31,rvv031,rvv32,rvv33,rvv34,rvv17,rvv38,rvv39,'' ", #倉/儲/批 #TQC-C80031 add rvv39
                               # "  FROM ",s_dbstring(g_poy[l_i].azp03),"rvu_file, ",           #FUN-A50102 mark                                                                   
                               #           s_dbstring(g_poy[l_i].azp03),"rvv_file, ",           #FUN-A50102 mark                                                            
                               #           s_dbstring(g_poy[l_i].azp03),"pmm_file, ",           #FUN-A50102 mark                                                               
                               #           s_dbstring(g_poy[l_i].azp03),"pmn_file ",            #FUN-A50102 mark
                                 "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'rvu_file'),",",#FUN-A50102
                                           cl_get_target_table(g_poy[l_i].poy04,'rvv_file'),",",#FUN-A50102
                                           cl_get_target_table(g_poy[l_i].poy04,'pmm_file'),",",#FUN-A50102
                                           cl_get_target_table(g_poy[l_i].poy04,'pmn_file'),    #FUN-A50102               
                                 " WHERE rvu01 = rvv01 AND pmm01 = pmn01 ",
                                 "   AND rvu02 = '",l_oga01,"' ",                        
                                 "   AND rvu00 = '1'",            
                                 "   AND rvv36 = pmn01 AND rvv37 = pmn02 ",
                                 "   AND rvuconf <> 'X' ",   #MOD-B10245 add
                                 "   AND pmm18 <> 'X' ",     #MOD-B10245 add
                                 " ORDER BY rvu01,rvv02 "
                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
                     CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql 
                     PREPARE q940_pb2_2 FROM g_sql
                     DECLARE oga_curs2_2 CURSOR FOR q940_pb2_2
                     # 入庫單
                     FOREACH oga_curs2_2 INTO g_oga[g_cnt].*
                        IF STATUS THEN
                           CALL cl_err("foreach:pb2_2",STATUS,0)
                           EXIT FOREACH
                        END IF
                        LET g_cnt = g_cnt + 1
                        IF g_cnt > g_max_rec THEN
                           CALL cl_err("",9035,0)
                           LET l_flag = 'N'
                           RETURN
                        END IF
                     END FOREACH
                     CALL g_oga.deleteElement(g_cnt)
                     LET l_l = g_oga.getlength()
                     IF l_flag = 'N' THEN
                        RETURN
                     END IF
                     LET l_oga01_old = l_oga01
                  END IF
               END FOR
              #-MOD-A20058-end
               # 出貨單
               FOREACH oga_curs2_3 INTO g_oga[g_cnt].*
                  IF STATUS THEN
                     CALL cl_err("foreach:pb2_3",STATUS,0)
                     EXIT FOREACH
                  END IF
                  LET g_cnt = g_cnt + 1
                  LET l_k = l_k + 1         #TQC-A70070 add
                  IF g_cnt > g_max_rec THEN
                     CALL cl_err("",9035,0)
                     LET l_flag = 'N'
                     EXIT FOREACH
                  END IF
               END FOREACH
               CALL g_oga.deleteElement(g_cnt)
               IF l_flag = 'N' THEN
                  RETURN
               END IF
           ELSE
               # 出貨單
               FOREACH oga_curs2_3 INTO g_oga[g_cnt].*
                  IF STATUS THEN
                     CALL cl_err("foreach:pb2_3",STATUS,0)
                     EXIT FOREACH
                  END IF
                  LET g_cnt = g_cnt + 1
                  LET l_k = l_k + 1         #TQC-A70070 add
                  IF g_cnt > g_max_rec THEN
                     CALL cl_err("",9035,0)
                     LET l_flag = 'N'
                     EXIT FOREACH
                  END IF
               END FOREACH
               CALL g_oga.deleteElement(g_cnt)
               IF l_flag = 'N' THEN
                  RETURN
               END IF
               # 收貨單
               LET l_m = g_oga.getlength()        #MOD-BA0094 add
               IF l_m = 0 THEN LET l_m = 1 END IF #MOD-BA0094 add
               FOREACH oga_curs2_1 INTO g_oga[g_cnt].*
            
                  IF STATUS THEN
                     CALL cl_err("foreach:pb2_2",STATUS,0)
                     EXIT FOREACH
                  END IF
#TQC-A70070 mark --begin
                  #TQC-A50139 add --begin
#                  IF l_oga01 <> g_oga[g_cnt].oga01 THEN
#                      LET l_oga01 = g_oga[g_cnt].oga01
#                  END IF 
                  #TQC-A50139 add --end
#TQC-A70070 mark --end
                  LET g_cnt = g_cnt + 1
                  IF g_cnt > g_max_rec THEN
                     CALL cl_err("",9035,0)
                     LET l_flag = 'N'
                     EXIT FOREACH
                  END IF
               END FOREACH
               CALL g_oga.deleteElement(g_cnt)
               IF l_flag = 'N' THEN
                  RETURN
               END IF
               # 入庫單
#TQC-A70070 add --begin
               LET l_l = g_oga.getlength() 
               LET l_oga01_old = ' ' 
              #FOR l_k = l_k TO l_l #MOD-BA0094 mark
               FOR l_k = l_m TO l_l #MOD-BA0094
                  LET l_oga01 = g_oga[l_k].oga01
                  IF l_oga01_old <> l_oga01 THEN 
                     LET l_oga01 = g_oga[l_k].oga01 
                     #==>入庫
                     LET g_sql = "SELECT rvu99, ",
                                 "       '",g_poy[l_i].poy04,"', ",
                                 "       '2',rvu01,pmm41,pmm20,pmm21,pmm22, ",
                                 "       rvv02,rvv31,rvv031,rvv32,rvv33,rvv34,rvv17,rvv38,rvv39,'' ", #倉/儲/批 #TQC-C80031 add rvv39
                               # "  FROM ",s_dbstring(g_poy[l_i].azp03),"rvu_file, ",           #FUN-A50102 mark                                                             
                               #           s_dbstring(g_poy[l_i].azp03),"rvv_file, ",           #FUN-A50102 mark                                                          
                               #           s_dbstring(g_poy[l_i].azp03),"pmm_file, ",           #FUN-A50102 mark                                                           
                               #           s_dbstring(g_poy[l_i].azp03),"pmn_file ",            #FUN-A50102 mark
                                 "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'rvu_file'),",",#FUN-A50102
                                           cl_get_target_table(g_poy[l_i].poy04,'rvv_file'),",",#FUN-A50102
                                           cl_get_target_table(g_poy[l_i].poy04,'pmm_file'),",",#FUN-A50102
                                           cl_get_target_table(g_poy[l_i].poy04,'pmn_file'),    #FUN-A50102  
                                 " WHERE rvu01 = rvv01 AND pmm01 = pmn01 ",
                                 "   AND rvu02 = '",l_oga01,"' ",                        
                                 "   AND rvu00 = '1'",            
                                 "   AND rvv36 = pmn01 AND rvv37 = pmn02 ",
                                 "   AND rvuconf <> 'X' ",   #MOD-B10245 add
                                 "   AND pmm18 <> 'X' ",     #MOD-B10245 add
                                 " ORDER BY rvu01,rvv02 "
                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
                     CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql 
                     PREPARE q940_pb2_2_1 FROM g_sql
                     DECLARE oga_curs2_2_1 CURSOR FOR q940_pb2_2_1
                     # 入庫單
                     FOREACH oga_curs2_2_1 INTO g_oga[g_cnt].*
                        IF STATUS THEN
                           CALL cl_err("foreach:pb2_2",STATUS,0)
                           EXIT FOREACH
                        END IF
                        LET g_cnt = g_cnt + 1
                        IF g_cnt > g_max_rec THEN
                           CALL cl_err("",9035,0)
                           LET l_flag = 'N'
                           RETURN
                        END IF
                     END FOREACH
                     CALL g_oga.deleteElement(g_cnt)
                     LET l_l = g_oga.getlength()
                     IF l_flag = 'N' THEN
                        RETURN
                     END IF
                     LET l_oga01_old = l_oga01
                  END IF
               END FOR
#TQC-A70070 --add --end
#TQC-A70070 --mark --begin
#               FOREACH oga_curs2_2 INTO g_oga[g_cnt].*
#                  IF STATUS THEN
#                     CALL cl_err("foreach:pb2_3",STATUS,0)
#                     EXIT FOREACH
#                  END IF
#                  LET g_cnt = g_cnt + 1
#                  IF g_cnt > g_max_rec THEN
#                     CALL cl_err("",9035,0)
#                     LET l_flag = 'N'
#                     RETURN
#                  END IF
#               END FOREACH
#               CALL g_oga.deleteElement(g_cnt)
#               IF l_flag = 'N' THEN
#                  RETURN
#               END IF
#TQC-A70070 --mark --end
           END IF
         END IF #TQC-7C0095
       END FOR
   END FOR
 
END FUNCTION
 
FUNCTION q940_b_fill_oma()
#FUN-CC0090 -- add start --
DEFINE l_rva01     LIKE rva_file.rva01
DEFINE l_rvu       DYNAMIC ARRAY OF RECORD
        rvu99      LIKE rva_file.rva99   # 多角貿易流程序號
                   END RECORD
DEFINE l_rvu99_cnt LIKE type_file.num5
#FUN-CC0090 -- add end --
 
   CALL g_oma.clear()
 
   LET g_cnt = 1
   LET l_flag = 'Y'
   #FUN-CC0090 -- add start #撈取倉退、銷退產生的多角流程代碼 --
   LET l_rvu99_cnt = 1
   LET g_sql = "SELECT DISTINCT(rvu99) FROM rvu_file,rvv_file ",
               " WHERE rvu01 = rvv01 ",
               "   AND rvuconf <> 'X' ",
               "   AND rvv36 = '",g_pmm[l_ac].pmm01,"'",
               "   AND rvu00='3' ",
               "   AND rvu08 IN ('TRI','TAP') "
   PREPARE pre_rvu99_oma FROM g_sql
   DECLARE curs_rvu99_oma CURSOR FOR pre_rvu99_oma

   FOREACH curs_rvu99_oma INTO l_rvu[l_rvu99_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:pre_rvu99_oma",STATUS,0)
         EXIT FOREACH
      END IF
      LET l_rvu99_cnt = l_rvu99_cnt + 1
   END FOREACH
   LET l_rvu99_cnt = l_rvu99_cnt - 1
   #FUN-CC0090 -- add end --
 
   FOR l_i = 1 TO l_cnt
     FOR l_j = 1 TO l_cnt2
       #==>應付
       LET g_sql = "SELECT '",g_rva[l_j].rva99,"', ",
                   "       '",g_poy[l_i].poy04,"', ",
                   "       '2',apa01,apa06,apa07,apa36,apa22,apa11,apa15, ", #MOD-640474 add apa36,apa22 類別/部門
                   "       apa13,apa14,apa34f,apa34 ",
                 # "  FROM ",s_dbstring(g_poy[l_i].azp03),"apa_file ",    #TQC-950010 ADD      #FUN-A50102 mark
                   "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'apa_file'),                 #FUN-A50102 
                   " WHERE apa99 = '",g_rva[l_j].rva99,"' ",
                   "  AND apa00 = '11' ",
                   "  AND apa42 <> 'Y' ",   #MOD-B10245 add
                   " ORDER BY apa01 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql	#MOD-970211
       CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql         #FUN-A50102
       PREPARE q940_pb3_1 FROM g_sql
       DECLARE oma_curs3_1 CURSOR FOR q940_pb3_1
 
       #==>應收
       LET g_sql = "SELECT '",g_rva[l_j].rva99,"', ",
                   "       '",g_poy[l_i].poy04,"', ",
                   "       '1',oma01,oma03,oma032,oma13,oma15,oma32,oma21, ", #MOD-640474 add oma13,oma15 類別/部門
                   "       oma23,oma24,oma54t,oma56t ",
                 # "  FROM ",s_dbstring(g_poy[l_i].azp03),"oma_file ",  #TQC-950010 ADD        #FUN-A50102 mark
                   "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'oma_file'),                 #FUN-A50102   
                   " WHERE oma99 = '",g_rva[l_j].rva99,"' ",
                   "   AND oma00 LIKE '1%' ",  #MOD-890042 add
                   "   AND omavoid <> 'Y' ",   #MOD-B10245 add
                   " ORDER BY oma01 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql	#MOD-970211
       CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql    #FUN-A50102
       PREPARE q940_pb3_2 FROM g_sql
       DECLARE oma_curs3_2 CURSOR FOR q940_pb3_2
       IF (l_i = 1 ) THEN  # 判斷
                           #來源站先抓應付,再抓應收
                           #其餘  先抓應收,再抓應付
 
           # 應付
           FOREACH oma_curs3_1 INTO g_oma[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb3_1",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 RETURN
              END IF
           END FOREACH
           CALL g_oma.deleteElement(g_cnt)
           IF l_flag = 'N' THEN 
              RETURN
           END IF
           
           # 應收
           FOREACH oma_curs3_2 INTO g_oma[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb3_1",STATUS,0)
                 EXIT FOREACH
              END IF
           
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 RETURN
              END IF
           END FOREACH
           CALL g_oma.deleteElement(g_cnt)
           IF l_flag = 'N' THEN 
              RETURN 
           END IF
       ELSE
           # 應收
           FOREACH oma_curs3_2 INTO g_oma[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb3_1",STATUS,0)
                 EXIT FOREACH
              END IF
           
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 RETURN
              END IF
           END FOREACH
           CALL g_oma.deleteElement(g_cnt)
           IF l_flag = 'N' THEN 
              RETURN 
           END IF
 
           # 應付
           FOREACH oma_curs3_1 INTO g_oma[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb3_1",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 RETURN
              END IF
           END FOREACH
           CALL g_oma.deleteElement(g_cnt)
           IF l_flag = 'N' THEN 
              RETURN
           END IF
       END IF
     END FOR
     #FUN-CC0090 -- add start --
     FOR l_j = 1 TO l_rvu99_cnt
        #倉退、銷退
        #應付
        LET g_sql = "SELECT '",l_rvu[l_j].rvu99,"', ",
                    "       '",g_poy[l_i].poy04,"', ",
                    "       '2',apa01,apa06,apa07,apa36,apa22,apa11,apa15, ",
                    "       apa13,apa14,apa34f,apa34 ",
                    "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'apa_file'),
                    " WHERE apa99 = '",l_rvu[l_j].rvu99,"' ",
                    "  AND apa00 = '21' ",
                    "  AND apa42 <> 'Y' ",
                    " ORDER BY apa01 "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql
        PREPARE q940_pb3_11 FROM g_sql
        DECLARE oma_curs3_11 CURSOR FOR q940_pb3_11
        #應收
        LET g_sql = "SELECT '",l_rvu[l_j].rvu99,"', ",
                    "       '",g_poy[l_i].poy04,"', ",
                    "       '1',oma01,oma03,oma032,oma13,oma15,oma32,oma21, ",
                    "       oma23,oma24,oma54t,oma56t ",
                    "  FROM ",cl_get_target_table(g_poy[l_i].poy04,'oma_file'),
                    " WHERE oma99 = '",l_rvu[l_j].rvu99,"' ",
                    "   AND oma00 = '21' ",
                    "   AND omavoid <> 'Y' ",
                    " ORDER BY oma01 "
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_poy[l_i].poy04) RETURNING g_sql
        PREPARE q940_pb3_21 FROM g_sql
        DECLARE oma_curs3_21 CURSOR FOR q940_pb3_21
        IF (l_i = 1 ) THEN  # 判斷
                            #來源站先抓應付,再抓應收
                            #其餘  先抓應收,再抓應付
           #應付
           FOREACH oma_curs3_11 INTO g_oma[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb3_11",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 RETURN
              END IF
           END FOREACH
           CALL g_oma.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              RETURN
           END IF
           #應收
           FOREACH oma_curs3_21 INTO g_oma[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb3_21",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 RETURN
              END IF
           END FOREACH
           CALL g_oma.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              RETURN
           END IF
        ELSE
           #應收
           FOREACH oma_curs3_21 INTO g_oma[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb3_21",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 RETURN
              END IF
           END FOREACH
           CALL g_oma.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              RETURN
           END IF
           #應付
           FOREACH q940_pb3_11 INTO g_oma[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb3_11",STATUS,0)
                 EXIT FOREACH
              END IF
              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 RETURN
              END IF
           END FOREACH
           CALL g_oma.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              RETURN
           END IF
        END IF
     END FOR
     #FUN-CC0090 -- add end --
   END FOR
 
END FUNCTION
 
#--#No:FUN-B30078--ADD--
FUNCTION q940_b_fill_rvv()
DEFINE l_rva01     LIKE rva_file.rva01

   CALL g_rvv.clear()

   LET g_cnt = 1
   LET l_flag = 'Y'
   LET l_cnt2 = 1
   LET g_sql = "SELECT DISTINCT(rva01) FROM rva_file, rvb_file ",   #FUN-CC0090 add DISTINCT()
               " WHERE rva01 = rvb01 ",
               "   AND rvaconf <> 'X' ",
               "   AND rvb04 = '",g_pmm[l_ac].pmm01,"' "
   PREPARE pre_rva01 FROM g_sql
   DECLARE curs_rva01 CURSOR FOR pre_rva01

   LET g_sql = "SELECT DISTINCT(rvu99) ",                           #FUN-CC0090 add DISTINCT()
               "  FROM rvu_file, rvv_file ",
               " WHERE rvu01 = rvv01 ",
               "   AND rvuconf <> 'X' ", 
               "   AND rvv04 = ? "
   PREPARE pre_rvu99 FROM g_sql
   DECLARE curs_rvu99 CURSOR FOR pre_rvu99
   
   FOREACH curs_rva01 INTO l_rva01
      IF STATUS THEN
         CALL cl_err("foreach:pre_rva01",STATUS,0)
         EXIT FOREACH
      END IF
      FOREACH curs_rvu99 USING l_rva01 INTO g_rva[l_cnt2].*
         IF STATUS THEN
            CALL cl_err("foreach:pre_rvu99",STATUS,0)
            EXIT FOREACH
         END IF
         LET l_cnt2 = l_cnt2 + 1
      END FOREACH 
   END FOREACH 
   LET l_cnt2 = l_cnt2 - 1 

   FOR l_i = 1 TO l_cnt
     FOR l_j = 1 TO l_cnt2
       LET g_sql="SELECT '",g_rva[l_j].rva99,"', ", 
                 "       '",g_poy[l_i].poy04,"', ",
                 "       '2',rvu01,rvv02,rvv31,rvv031,'',rvv35,rvv35_fac,rvv17,",
                 "       rvv32,rvv33,rvv34,rvv38,rvv39,rvv39t,rvv26,'',rvv41 ",
                 "  FROM ",s_dbstring(g_poy[l_i].azp03),"rvu_file, ",
                           s_dbstring(g_poy[l_i].azp03),"rvv_file ",
                 "  WHERE rvv01 = rvu01 ",
                 "    AND rvu99 = '",g_rva[l_j].rva99,"' ",
                 "    AND rvu00 = '3' ",
                 "    AND rvuconf <> 'X' ",
                 "  ORDER BY rvv02 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql     #MOD-970211
       PREPARE q940_pb4_1 FROM g_sql
       DECLARE rvv_curs4_1 CURSOR FOR q940_pb4_1

       LET g_sql="SELECT '",g_rva[l_j].rva99,"', ", 
                 "       '",g_poy[l_i].poy04,"', ",
                 "       '1',oha01,ohb03,ohb04,ohb06,'',ohb15,ohb15_fac,ohb16,",
                 "       ohb09,ohb091,ohb092,ohb13,ohb14,ohb14t,ohb50,'',ohb52 ",
                 "  FROM ",s_dbstring(g_poy[l_i].azp03),"oha_file, ",
                           s_dbstring(g_poy[l_i].azp03),"ohb_file ",
                 "  WHERE oha01 = ohb01 ",
                 "    AND oha99 = '",g_rva[l_j].rva99,"' ",
                 "    AND ohaconf <> 'X' ",
                 "  ORDER BY ohb03 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql     #MOD-970211
       PREPARE q940_pb4_2 FROM g_sql
       DECLARE rvv_curs4_2 CURSOR FOR q940_pb4_2
       IF NOT cl_null(g_rva[l_j].rva99) AND g_rva[l_j].rva99 <>' ' THEN
           FOREACH rvv_curs4_1 INTO g_rvv[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb4_1",STATUS,0)
                 EXIT FOREACH
              END IF

              SELECT ima021 INTO g_rvv[g_cnt].ima021 FROM ima_file
                      WHERE ima01=g_rvv[g_cnt].rvv31
              SELECT azf03 INTO g_rvv[g_cnt].azf03 FROM azf_file
                      WHERE azf01=g_rvv[g_cnt].rvv26 AND azf02='2'

              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 EXIT FOREACH
              END IF
           END FOREACH
           CALL g_rvv.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              EXIT FOR
           END IF

           FOREACH rvv_curs4_2 INTO g_rvv[g_cnt].*
              IF STATUS THEN
                 CALL cl_err("foreach:pb4_2",STATUS,0)
                 EXIT FOREACH
              END IF

              SELECT ima021 INTO g_rvv[g_cnt].ima021 FROM ima_file
                      WHERE ima01=g_rvv[g_cnt].rvv31
              SELECT azf03 INTO g_rvv[g_cnt].azf03 FROM azf_file
                      WHERE azf01=g_rvv[g_cnt].rvv26 AND azf02='2'

              LET g_cnt = g_cnt + 1
              IF g_cnt > g_max_rec THEN
                 CALL cl_err("",9035,0)
                 LET l_flag = 'N'
                 EXIT FOREACH
              END IF
           END FOREACH
           CALL g_rvv.deleteElement(g_cnt)
           IF l_flag = 'N' THEN
              EXIT FOR
           END IF
        END IF 
      END FOR
   END FOR

END FUNCTION
#--#No:FUN-B30078--END--
# 採購單
FUNCTION q940_b_fill_pmm(p_wc2)
   DEFINE p_wc2 STRING
  
   LET g_sql = "SELECT pmm01,pmm04,pmm09,'',pmm50,'', ",
               "       pmm12,'',pmm904,pmm99,pmm18,pmm905,pmm99",    #No-FUN-B30078  add pmm99
               "  FROM pmm_file",
               " WHERE pmm901 = 'Y' AND pmm02 = 'TAP' ",
               "  AND ",p_wc2 CLIPPED,
               "  AND pmm18 <> 'X' ",   #MOD-B10245 add
               " ORDER BY pmm01,pmm04 "
   PREPARE q940_pb FROM g_sql
   DECLARE pmm_curs CURSOR FOR q940_pb
  
   CALL g_pmm.clear()
  
   LET g_cnt = 1
 
   FOREACH pmm_curs INTO g_pmm[g_cnt].*,g_pmm2[g_cnt].pmm99
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
      # 廠商簡稱
      SELECT pmc03 INTO g_pmm[g_cnt].pmc03a FROM pmc_file
       WHERE pmc01 = g_pmm[g_cnt].pmm09
      # 最終供應商簡稱
      SELECT pmc03 INTO g_pmm[g_cnt].pmc03b FROM pmc_file
       WHERE pmc01 = g_pmm[g_cnt].pmm50
      # 採購員姓名
      SELECT gen02 INTO g_pmm[g_cnt].gen02 FROM gen_file
       WHERE gen01 = g_pmm[g_cnt].pmm12
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
   CALL g_pmm.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0
 
END FUNCTION

#FUN-C10021---mark---START 
#FUNCTION q940_bp2()
#
#   DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
#   
#      BEFORE DISPLAY
#         EXIT DISPLAY
#   
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#   
#      ON ACTION about
#         CALL cl_about()
#   
#      ON ACTION help    
#         CALL cl_show_help()
#   
#      ON ACTION controlg 
#         CALL cl_cmdask()
#   
#   END DISPLAY
#   
#   DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
#   
#      BEFORE DISPLAY
#         EXIT DISPLAY
#   
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#   
#      ON ACTION about
#         CALL cl_about()
#   
#      ON ACTION help    
#         CALL cl_show_help()
#   
#      ON ACTION controlg 
#         CALL cl_cmdask()
#   
#   END DISPLAY
#   
#   DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
#   
#      BEFORE DISPLAY
#         EXIT DISPLAY
#   
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#   
#      ON ACTION about
#         CALL cl_about()
#   
#      ON ACTION help
#         CALL cl_show_help()
#   
#      ON ACTION controlg
#         CALL cl_cmdask()
#   
#   END DISPLAY

#  #---#No:FUN-B30078---ADD--
#   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
#  
#      BEFORE DISPLAY
#         EXIT DISPLAY
#  
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#  
#      ON ACTION about
#         CALL cl_about()
#  
#      ON ACTION help
#         CALL cl_show_help()
#  
#      ON ACTION controlg
#         CALL cl_cmdask()
#  
#   END DISPLAY
#  #---#No:FUN-B30078--END--
# 
#END FUNCTION
# 
#FUNCTION q940_bp_view1()
#    DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
#    
#    LET g_action_choice = " "
#    
#    CALL cl_set_act_visible("accept,cancel", FALSE)
#    DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
#    
#       BEFORE ROW
#    
#       ON ACTION help
#          LET g_action_choice="help"
#          EXIT DISPLAY
#    
#       ON ACTION locale
#          CALL cl_dynamic_locale()
#    
#       ON ACTION exit
#          LET g_action_choice="exit"
#          EXIT DISPLAY
#    
#       ON ACTION controlg
#          LET g_up = "V"
#          LET g_action_choice="controlg"
#          EXIT DISPLAY
#    
#       ON ACTION cancel
#          LET g_action_choice="exit"
#          EXIT DISPLAY
#    
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE DISPLAY
#    
#       ON ACTION about
#         CALL cl_about()
#    
#      #瀏覽單身頁簽二：出貨資訊
#      ON ACTION view2
#         LET g_up = "V"
#         LET g_action_choice="view2"
#         EXIT DISPLAY
#    
#      #瀏覽單身頁簽三：立帳資訊
#      ON ACTION view3
#         LET g_up = "V"
#         LET g_action_choice="view3"
#         EXIT DISPLAY
#    
#      #---#No:FUN-B30078--ADD--
#    
#      #瀏覽單身頁簽四：倉退
#       ON ACTION view4
#          LET g_up = "V"
#         LET g_action_choice="view4"
#         EXIT DISPLAY
#     #---No:FUN-B30078---END
#    
#      #將focus指回單頭
#      ON ACTION return
#         LET g_up = "R"
#         LET g_action_choice="return"
#         EXIT DISPLAY
#
#   END DISPLAY
#   CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#   
#FUNCTION q940_bp_view2()
#   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
#  
#   LET g_action_choice = " "
#   LET l_ac1 = 1                 #FUN-B90012--add--
#   CALL cl_set_act_visible("accept,cancel", FALSE)
#    DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
#  
#      #FUN-B90012--add--Begin--
#      BEFORE DISPLAY
#         IF NOT s_industry("icd") THEN  
#            CALL cl_set_act_visible("aic_s_icdqry",FALSE)
#         END IF  
#      #FUN-B90012--add---End--
#  
#      BEFORE ROW
#         LET l_ac1 = ARR_CURR()  #FUN-B90012--add--
#         
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
#  
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#  
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#  
#      ON ACTION controlg
#         LET g_up = "V"
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#  
#      ON ACTION cancel
#         LET g_action_choice="exit"
#         EXIT DISPLAY
#  
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#  
#      ON ACTION about
#         CALL cl_about()
#  
#      #瀏覽單身頁簽一：訂單資訊
#      ON ACTION view1
#         LET g_up = "V"
#         LET g_action_choice="view1"
#         EXIT DISPLAY
#  
#      #瀏覽單身頁簽三：立帳資訊
#      ON ACTION view3
#         LET g_up = "V"
#         LET g_action_choice="view3"
#         EXIT DISPLAY
#  
#   #---#No:FUN-B30078--ADD--

#     #瀏覽單身頁簽四：倉退
#      ON ACTION view4
#         LET g_up = "V"
#        LET g_action_choice="view4"
#        EXIT DISPLAY
# #---No:FUN-B30078---END

#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY

#     #FUN-B90012--add--Begin--
#     ON ACTION aic_s_icdqry
#        LET g_action_choice="aic_s_icdqry"
#        IF cl_chk_act_auth() THEN
#           CALL q940_s_icdqry()
#        END IF      
#        LET g_action_choice=" "
#     #FUN-B90012--add---End---
#
#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#
#FUNCTION q940_bp_view3()
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
#
#  LET g_action_choice = " "
#
#  CALL cl_set_act_visible("accept,cancel", FALSE)
#     DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
#
#     BEFORE ROW
#
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON ACTION controlg
#        LET g_up = "V"
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#
#     ON ACTION cancel
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about
#        CALL cl_about()
#
#     #瀏覽單身頁簽一：訂單資訊
#     ON ACTION view1
#        LET g_up = "V"
#        LET g_action_choice="view1"
#        EXIT DISPLAY
#
#     #瀏覽單身頁簽二：出貨資訊
#     ON ACTION view2
#        LET g_up = "V"
#        LET g_action_choice="view2"
#        EXIT DISPLAY

#  #---#No:FUN-B30078--ADD--

#     #瀏覽單身頁簽四：倉退
#      ON ACTION view4
#         LET g_up = "V"
#        LET g_action_choice="view4"
#        EXIT DISPLAY
# #---No:FUN-B30078---END
#
#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY
#
#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
#
##---No:FUN-B30078---ADD
#FUNCTION q940_bp_view4()
#  DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 CHAR(1)

#  LET g_action_choice = " "
#  CALL cl_set_act_visible("accept,cancel", FALSE)
#     DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)

#     BEFORE ROW

#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY

#     ON ACTION locale
#        CALL cl_dynamic_locale()

#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY

#     ON ACTION controlg
#        LET g_up = "V"
#        LET g_action_choice="controlg"
#        EXIT DISPLAY

#     ON ACTION cancel
#        LET g_action_choice="exit"
#        EXIT DISPLAY

#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY

#     ON ACTION about
#        CALL cl_about()

#     #瀏覽單身頁簽一：訂單資訊
#     ON ACTION view1
#        LET g_up = "V"
#        LET g_action_choice="view1"
#        EXIT DISPLAY

#     #瀏覽單身頁簽二：出貨資訊
#     ON ACTION view2
#        LET g_up = "V"
#        LET g_action_choice="view2"
#        EXIT DISPLAY

#     #瀏覽單身頁簽三：立帳資訊
#     ON ACTION view3
#        LET g_up = "V"
#        LET g_action_choice="view3"
#        EXIT DISPLAY

#     #將focus指回單頭
#     ON ACTION return
#        LET g_up = "R"
#        LET g_action_choice="return"
#        EXIT DISPLAY

#  END DISPLAY
#  CALL cl_set_act_visible("accept,cancel", TRUE)
#END FUNCTION
##---No:FUN-B30078---END--
#FUN-C10021---mark---END
 
FUNCTION q940_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
  #FUN-C10021---mark---START 
  #IF g_up = "V" THEN
  #   RETURN
  #END IF
  #FUN-C10021---mark---END
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   #DISPLAY ARRAY g_pmm TO s_pmm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #FUN-C10021 mark 
   DIALOG ATTRIBUTES(UNBUFFERED) #FUN-C10021 add
      DISPLAY ARRAY g_pmm TO s_pmm.* ATTRIBUTE(COUNT=g_rec_b) #FUN-C10021 add
 
      BEFORE DISPLAY
         IF l_ac <> 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            CALL q940_b_fill_oea()
 
            CALL q940_b_fill_oga()
            LET g_rec_b2 = g_cnt - 1
            DISPLAY g_rec_b2 TO FORMONLY.cn2
            LET g_cnt = 0
 
            CALL q940_b_fill_oma()
            LET g_rec_b3 = g_cnt - 1
            DISPLAY g_rec_b3 TO FORMONLY.cn3
            LET g_cnt = 0

       #---No:FUN-B30078--ADD--
            CALL q940_b_fill_rvv()
            LET g_rec_b4 = g_cnt - 1
            DISPLAY g_rec_b4 TO FORMONLY.cn4
            LET g_cnt = 0
       #---No:FUN-B30078--END--
 
              #CALL q940_bp2() #FUN-C10021 mark
         END IF
         CALL cl_show_fld_cont()                   #No.FUN-590083 
    #FUN-C10021---add---START
      END DISPLAY
      
      DISPLAY ARRAY g_oea TO s_oea.* ATTRIBUTE(COUNT=g_rec_b1)
        BEFORE ROW
      END DISPLAY

      DISPLAY ARRAY g_oga TO s_oga.* ATTRIBUTE(COUNT=g_rec_b2)
        BEFORE DISPLAY
           IF NOT s_industry("icd") THEN  
              CALL cl_set_act_visible("aic_s_icdqry",FALSE)
           END IF
        BEFORE ROW
           LET l_ac1 = ARR_CURR()

        ON ACTION aic_s_icdqry
           LET g_action_choice="aic_s_icdqry"
           IF cl_chk_act_auth() THEN
              CALL q940_s_icdqry()
           END IF      
           LET g_action_choice=" " 
      END DISPLAY

      DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b3)
         BEFORE ROW
      END DISPLAY

      DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b4)
         BEFORE ROW
      END DISPLAY      
    #FUN-C10021---add---END
 
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY #FUN-C10021 mark
         EXIT DIALOG   #FUN-C10021 add
 
      ON ACTION help
         LET g_action_choice="help"
         #EXIT DISPLAY #FUN-C10021 mark
         EXIT DIALOG   #FUN-C10021 add
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY #FUN-C10021 mark
         EXIT DIALOG   #FUN-C10021 add
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY #FUN-C10021 mark
         EXIT DIALOG   #FUN-C10021 add
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         #EXIT DISPLAY #FUN-C10021 mark
         EXIT DIALOG   #FUN-C10021 add
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY #FUN-C10021 mark
         CONTINUE DIALOG   #FUN-C10021 add
 
      ON ACTION about
         CALL cl_about()
  #FUN-C10021---mark---START 
  #   ON ACTION view1
  #      LET g_action_choice = "view1"
  #      EXIT DISPLAY
 
  #   ON ACTION view2
  #      LET g_action_choice = "view2"
  #      EXIT DISPLAY
 
  #   ON ACTION view3
  #      LET g_action_choice = "view3"
  #      EXIT DISPLAY

  ##--No:FUN-B30078--ADD--
  #   ON ACTION view4
  #      LET g_action_choice = "view4"
  #      EXIT DISPLAY
  ##--No:FUN-B30078--END-- 
  #END DISPLAY
  #FUN-C10021---mark---END
   END DIALOG #FUN-C10021 add
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#FUN-B90012--add--Begin---
FUNCTION q940_s_icdqry()
DEFINE l_oga09    LIKE  oga_file.oga09,
       l_ogaconf  LIKE  oga_file.ogaconf,
       l_ogapost  LIKE  oga_file.ogapost,
       l_rvaconf  LIKE  rva_file.rvaconf,
       l_rvuconf  LIKE  rvu_file.rvuconf,
       l_plant_new LIKE type_file.chr20

   IF cl_null(g_oga[l_ac1].oga01) THEN RETURN END IF 

   LET l_oga09 = ' '
   LET l_ogaconf = ' '
   LET l_ogapost = ' '
   LET l_rvaconf = ' '
   LET l_rvuconf = ' '
   IF NOT cl_null(g_oga[l_ac1].poy04_2) THEN
      LET l_plant_new = g_oga[l_ac1].poy04_2
   ELSE
      LET l_plant_new = g_plant
   END IF
   
   CASE g_oga[l_ac1].outin
      WHEN '1' 
         LET g_sql = "SELECT DISTINCT rvaconf FROM ",cl_get_target_table(l_plant_new,'rva_file'),
                     " WHERE rva01 = '",g_oga[l_ac1].oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql 
         PREPARE q940_rvaconf FROM g_sql
         EXECUTE q940_rvaconf INTO l_rvaconf
         
         CALL s_icdqry_plant(l_plant_new)
         CALL s_icdqry(0,g_oga[l_ac1].oga01,'',l_rvaconf,'') 
         CALL s_icdqry_plant("")
      WHEN '2'
         LET g_sql = "SELECT DISTINCT rvuconf FROM ",cl_get_target_table(l_plant_new,'rvu_file'),
                     " WHERE rvu01 = '",g_oga[l_ac1].oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql 
         PREPARE q940_rvuconf FROM g_sql
         EXECUTE q940_rvuconf INTO l_rvuconf

         CALL s_icdqry_plant(l_plant_new)
         CALL s_icdqry(1,g_oga[l_ac1].oga01,'',l_rvuconf,'') 
         CALL s_icdqry_plant("")
      WHEN '3' 
         LET g_sql = "SELECT DISTINCT oga09,ogaconf,ogapost FROM ",cl_get_target_table(l_plant_new,'oga_file'),
                     " WHERE oga01 = '",g_oga[l_ac1].oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,l_plant_new) RETURNING g_sql 
         PREPARE q940_oga_1 FROM g_sql
         EXECUTE q940_oga_1 INTO l_oga09,l_ogaconf,l_ogapost

         IF NOT cl_null(g_oga[l_ac1].ogb03) THEN
            IF l_oga09 MATCHES '[15]' THEN
               CALL s_icdqry_plant(l_plant_new)
               CALL s_icdqry(2,g_oga[l_ac1].oga01,g_oga[l_ac1].ogb03,l_ogaconf,g_oga[l_ac1].ogb04)
            ELSE
               CALL s_icdqry_plant(l_plant_new)
               CALL s_icdqry(2,g_oga[l_ac1].oga01,g_oga[l_ac1].ogb03,l_ogapost,g_oga[l_ac1].ogb04)
            END IF
            CALL s_icdqry_plant("")
         END IF
   END CASE 
END FUNCTION 
#FUN-B90012--add---End----
