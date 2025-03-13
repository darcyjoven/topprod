# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: aimq842.4gl
# Descriptions...: 多工廠料件供需明細查詢
# Date & Author..: 06/03/23 By Nicola
# Modify.........: No.MOD-640059 06/04/09 By Nicola 單身加入工廠別
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/16 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-710032 07/01/12 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-780080 07/09/19 By Pengu SQL使用OUTER未按照標準程序加上table.欄位
# Modify.........: No.TQC-7A0115 07/10/31 By lumxa sql錯誤,把變量包在引號中了
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()    
# Modify.........: No.FUN-940083 09/05/18 By Cockroach 原可收量(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980091 09/09/18 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No.TQC-BB0104 11/11/10 By destiny 明细查询时不应该清空画面
# Modify.........: No:CHI-B40039 13/01/18 By Alberti 工單在製量應扣除當站下線量

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_sw            LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_wc,g_wc2      STRING
DEFINE g_sql           STRING
DEFINE g_rec_b         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_rec_b1        LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_ima           RECORD
                          ima01    LIKE ima_file.ima01,   #料號
                          ima02    LIKE ima_file.ima02,   #品名
                          ima021   LIKE ima_file.ima021,  #品名
                          ima25    LIKE ima_file.ima25,   #單位
                          ima906   LIKE ima_file.ima906,  #單位管制方式
                          ima907   LIKE ima_file.ima907   #第二單位
                       END RECORD
DEFINE g_qty           DYNAMIC ARRAY OF RECORD
                          plan     LIKE azp_file.azp01,
                          pname    LIKE azp_file.azp02,
#                         ima262   LIKE ima_file.ima262,          #FUN-A20044
#                         ima26    LIKE ima_file.ima26,           #FUN-A20044
                          avl_stk  LIKE type_file.num15_3,        #FUN-A20044
                          avl_stk_mpsmrp LIKE type_file.num15_3,  #FUN-A20044
                          qty_3    LIKE sfb_file.sfb08,
                          qty_4    LIKE sfb_file.sfb08,
                          qty_5    LIKE sfb_file.sfb08,
                          qty_2    LIKE sfb_file.sfb08,
                          qty_51   LIKE sfb_file.sfb08,
                          qty_6    LIKE sfb_file.sfb08,
                          qty_1    LIKE sfb_file.sfb08,
                          qty_7    LIKE sfb_file.sfb08
                       END RECORD
DEFINE g_sr            DYNAMIC ARRAY OF RECORD
                          ds_date    LIKE type_file.dat,   #No.FUN-690026 DATE
                          #ds_plan   VARCHAR(10),             #No.MOD-640059 #FUN-660078 remark
                          ds_plan    LIKE azp_file.azp01,  #FUN-660078
                          ds_class   LIKE ze_file.ze03,    #No.FUN-690026 VARCHAR(20),
                          #ds_no     VARCHAR(16),             #FUN-660078 remark
                          ds_no      LIKE pmm_file.pmm01,  #FUN-660078
                          ds_cust    LIKE pmm_file.pmm09,
                          ds_qlty    LIKE rpc_file.rpc13,
                          ds_total   LIKE rpc_file.rpc13
                       END RECORD,
       g_sr_s          RECORD
                          ds_date    LIKE type_file.dat,   #No.FUN-690026 DATE
                          #ds_plan   VARCHAR(10),             #No.MOD-640059 #FUN-660078 remark
                          ds_plan    LIKE azp_file.azp01,  #FUN-660078
                          ds_class   LIKE ze_file.ze03,    #No.FUN-690026 VARCHAR(20),
                          #ds_no     VARCHAR(16),             #FUN-660078 remark
                          ds_no      LIKE pmm_file.pmm01,  #FUN-660078
                          ds_cust    LIKE pmm_file.pmm09,
                          ds_qlty    LIKE rpc_file.rpc13,
                          ds_total   LIKE rpc_file.rpc13
                       END RECORD
DEFINE g_order         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_cnt1          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cha           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8           #No.FUN-6A0074
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0074
 
   LET p_row = 2 LET p_col = 2
 
   OPEN WINDOW q842_w AT p_row,p_col WITH FORM "aim/42f/aimq842"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   #-----TQC-710032---------
   CALL q842_mu_ui()
   #CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   #CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   #CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   #CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
   #
   #IF g_sma.sma122='1' THEN
   #   CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
   #   CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   #END IF
   #
   #IF g_sma.sma122='2' THEN
   #   CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
   #   CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   #END IF
   #-----END TQC-710032----- 
 
   LET g_cha = "1"
 
   CALL q842_menu()
 
   CLOSE WINDOW q842_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0074
 
END MAIN
 
FUNCTION q842_cs()
   DEFINE l_cnt   LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   #CLEAR FORM           #TQC-BB0104
   #CALL g_sr.clear()    #TQC-BB0104
   CALL cl_opmsg('q')
 
   IF g_sw = 1 THEN
      CLEAR FORM         #TQC-BB0104
      CALL g_qty.clear() #TQC-BB0104
      CALL g_sr.clear()  #TQC-BB0104
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
      CONSTRUCT BY NAME g_wc ON ima01,ima02,ima021
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about
            CALL cl_about()
         
         ON ACTION help
            CALL cl_show_help()
         
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima01
                  NEXT FIELD ima01
            END CASE
 
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   IF g_sw = 2 THEN
      LET p_row = 6 LET p_col = 3
 
      OPEN WINDOW q842_w2 AT p_row,p_col WITH FORM "aim/42f/aimq841_2"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_locale("aimq841_2")
 
      CONSTRUCT BY NAME g_wc2 ON sfa01
 
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
 
      CLOSE WINDOW q842_w2
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      LET g_wc = "ima01 IN (SELECT sfa03 FROM sfa_file WHERE ",g_wc2 CLIPPED,")"
   END IF
 
   IF g_sw = 3 THEN
      LET p_row = 6 LET p_col = 3
 
      OPEN WINDOW q842_w3 AT p_row,p_col WITH FORM "aim/42f/aimq841_3"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_locale("aimq841_3")
 
      CONSTRUCT BY NAME g_wc2 ON oeb01
 
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
 
      CLOSE WINDOW q842_w3
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      LET g_wc = "ima01 IN (SELECT oeb04 FROM oeb_file WHERE ",g_wc2 CLIPPED,")"
   END IF
 
   IF g_sw = 4 THEN
      LET p_row = 6 LET p_col = 3
 
      OPEN WINDOW q842_w4 AT p_row,p_col WITH FORM "aim/42f/aimq841_4"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_locale("aimq841_4")
 
      CONSTRUCT BY NAME g_wc2 ON bmb01
 
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
 
      CLOSE WINDOW q842_w4
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      LET g_wc = "ima01 IN (SELECT bmb03 FROM bmb_file WHERE ",g_wc2 CLIPPED,")"
   END IF
 
   LET g_sql=" SELECT ima01,ima02,ima021,ima25,ima906,ima907 ",
             " FROM ima_file WHERE ",g_wc CLIPPED
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_sql = g_sql CLIPPED," AND imauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_sql = g_sql CLIPPED," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #      LET g_sql = g_sql CLIPPED," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql CLIPPED," ORDER BY ima01"
 
   PREPARE q842_prepare FROM g_sql
   DECLARE q842_cs SCROLL CURSOR FOR q842_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN
   #      LET g_sql = g_sql CLIPPED," AND imauser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN
   #      LET g_sql = g_sql CLIPPED," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #     LET g_sql = g_sql CLIPPED," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q842_pp  FROM g_sql
   DECLARE q842_cnt CURSOR FOR q842_pp
 
END FUNCTION
 
FUNCTION q842_menu()
 
   WHILE TRUE
      IF g_cha = "1" THEN
         CALL q842_bp("G")
      ELSE
         CALL q842_bp1("G")
      END IF
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "query"
            LET g_sw = 1
            CALL q842_q()
         WHEN "query_by_w_o"
            LET g_sw = 2
            CALL q842_q()
         WHEN "query_by_order"
            LET g_sw = 3
            CALL q842_q()
         WHEN "query_by_bom"
            LET g_sw = 4
            CALL q842_q()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sr),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q842_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL q842_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   MESSAGE "Waiting!"
 
   OPEN q842_cs
   IF SQLCA.sqlcode THEN
      CALL cl_err('q842_q:',SQLCA.sqlcode,0)
   ELSE
      OPEN q842_cnt
      FETCH q842_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q842_fetch('F')
   END IF
 
   MESSAGE ""
 
END FUNCTION
 
FUNCTION q842_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     q842_cs INTO g_ima.*
      WHEN 'P' FETCH PREVIOUS q842_cs INTO g_ima.*
      WHEN 'F' FETCH FIRST    q842_cs INTO g_ima.*
      WHEN 'L' FETCH LAST     q842_cs INTO g_ima.*
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
 
               ON ACTION help
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
            END PROMPT
 
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
 
         FETCH ABSOLUTE g_jump q842_cs INTO g_ima.*
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('Fetch:',SQLCA.sqlcode,0)
      INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
 
   CALL q842_show()
 
END FUNCTION
 
FUNCTION q842_show()
 
   DISPLAY BY NAME g_ima.*
 
   MESSAGE ' WAIT '
 
   CALL q842_b_fill()
 
   MESSAGE ''
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION q842_b_fill()
   DEFINE l_sfb02       LIKE sfb_file.sfb02,    #No.FUN-690026 SMALLINT
          I,J           LIKE type_file.num10,   #No.FUN-690026 INTEGER
          l_pmm09       LIKE pmm_file.pmm09,
          l_pmc03       LIKE pmc_file.pmc03,
          l_sfb82       LIKE sfb_file.sfb82,
          l_ima55_fac   LIKE ima_file.ima55_fac,
          qty_1,qty_2   LIKE sfb_file.sfb08,
          qty_3,qty_4   LIKE sfb_file.sfb08,
          qty_5,qty_51  LIKE sfb_file.sfb08, 
          qty_6,qty_7   LIKE sfb_file.sfb08
   DEFINE l_msg         STRING
   DEFINE l_azp01       LIKE azp_file.azp01
   DEFINE l_azp02       LIKE azp_file.azp02
   DEFINE l_azp03       LIKE azp_file.azp03
#  DEFINE l_sumqty      LIKE ima_file.ima26         #FUN-A20044
   DEFINE l_sumqty      LIKE type_file.num15_3      #FUN-A20044   
   DEFINE l_azp03_tra   LIKE azp_file.azp03         #FUN-980091
   DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,  #FUN-980091 
          l_unavl_stk      LIKE type_file.num15_3,  #FUN-980091
          l_avl_stk        LIKE type_file.num15_3   #FUN-980091
   DEFINE l_sfb05       LIKE sfb_file.sfb05    #CHI-B40039 add
   DEFINE l_shb114      LIKE shb_file.shb114   #CHI-B40039 add
   DEFINE l_sql         STRING                 #CHI-B40039 add

   CALL g_sr.clear()
   CALL g_qty.clear()
   LET g_cnt = 1
   LET g_cnt1 = 1
 
   DECLARE q842_azp CURSOR FOR
      SELECT azp01,azp02,azp03 FROM azp_file
       WHERE azp01 IN (SELECT zxy03 FROM zxy_file #FUN-980091 DB權限控管
                        WHERE zxy01 = g_user)     #FUN-980091 DB權限控管
    
   FOREACH q842_azp INTO l_azp01,l_azp02,l_azp03
      IF STATUS THEN
         CALL cl_err('sel azp',STATUS,1)
         EXIT FOREACH
      END IF
 
     #FUN-980091----------------------(S)
      LET g_plant_new = l_azp01
      CALL s_gettrandbs()
      LET l_azp03_tra = g_dbs_tra
     #FUN-980091----------------------(E)
 
      LET qty_1 = 0
      LET qty_2 = 0
      LET qty_3 = 0
      LET qty_4 = 0
      LET qty_5 = 0
      LET qty_51 = 0
      LET qty_6 = 0
      LET qty_7 = 0
 
#No.FUN-A20044 ----mark---start
#      LET g_sql = "SELECT ima26,ima262 ",
#                  #"  FROM ",l_azp03,".dbo.ima_file",             #TQC-950003 MARK                                                      
#                  "  FROM ",s_dbstring(l_azp03),"ima_file",   #TQC-950003 ADD   
#                  " WHERE ima01 = '",g_ima.ima01,"'"
#      PREPARE q842_pima FROM g_sql
#      DECLARE q842_bima CURSOR FOR q842_pima
#No.FUN-A20044 ---mark---end 

      #-->受訂量
      LET g_sql = "SELECT oeb15,'','',oeb01,occ02,(oeb12-oeb24)*oeb05_fac,0",   #No.MOD-640059
                 #"  FROM ",l_azp03,".dbo.oeb_file,",l_azp03,":oea_file,",                       #TQC-950003 MARK                       
                 #          l_azp03,".dbo.occ_file",                                             #TQC-950003 MARK                       
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"oeb_file,",s_dbstring(l_azp03),"oea_file,", #TQC-950003 ADD                        
                 #          s_dbstring(l_azp03),"occ_file",                                  #TQC-950003 ADD     
                 #-----------------------------------
#FUN-A50102--mod--str--
#                 "  FROM ",s_dbstring(l_azp03_tra),"oeb_file,",
#                           s_dbstring(l_azp03_tra),"oea_file,",
#                           s_dbstring(l_azp03),"occ_file",                                  #TQC-950003 ADD     
#                #FUN-980091----------------------(E)
                  "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'),",",
                  "       ",cl_get_target_table(g_plant_new,'oea_file'),",",
                  "       ",cl_get_target_table(g_plant_new,'occ_file'),
#FUN-A50102--mod--end
                  " WHERE oeb04 = '",g_ima.ima01,"'",
                  "   AND oeb01 = oea01",
                  "   AND occ01 = oea03",
                  "   AND oea00 <> '0'",
                  "   AND oeb70 = 'N'",
                  "   AND oeb12 > oeb24",
                  "   AND oeaconf != 'X'",
                  " ORDER BY oeb15"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091   #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs1 FROM g_sql
      DECLARE q842_bcs1 CURSOR FOR q842_pbcs1
      
      #-->在製量
      SELECT ima55_fac INTO l_ima55_fac
        FROM ima_file
       WHERE ima01 = g_ima.ima01
      IF cl_null(l_ima55_fac) THEN
         LET l_ima55_fac = 1
      END IF
      
      LET g_sql = "SELECT sfb15,'','',sfb01,gem02,",   #No.MOD-640059
                  "       (sfb08-sfb09-sfb10-sfb11-sfb12)*",l_ima55_fac,
                  "       ,0,sfb02,sfb82,sfb05",                             #CHI-B40039 add sfb05
#                 "  FROM ",l_azp03,".dbo.sfb_file,",                        #TQC-950003 MARK                                           
#                 " OUTER ",l_azp03,".dbo.gem_file",    #No.TQC-780080 add   #TQC-950003 MARK                                           
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"sfb_file,",             #TQC-950003 ADD                                            
                 #" OUTER ",s_dbstring(l_azp03),"gem_file",              #TQC-950003 ADD  
                 #-----------------------------------
#FUN-A50102--mod--str--
#                 "  FROM ",s_dbstring(l_azp03_tra),"sfb_file,",
#                 " OUTER ",s_dbstring(l_azp03),"gem_file",              #TQC-950003 ADD  
#                #FUN-980091----------------------(E)
                  "  FROM ",cl_get_target_table(g_plant_new,'sfb_file'),",",
                  " OUTER ",cl_get_target_table(g_plant_new,'gem_file'),
#FUN-A50102--mod--end
                  " WHERE sfb05 = '",g_ima.ima01,"'",
                  "   AND sfb04 != '8'",
                  "   AND sfb_file.sfb82 = gem_file.gem01",
                  "   AND sfb08 > (sfb09+sfb10+sfb11+sfb12)",
                  "   AND sfb87 != 'X'",
                  "   AND (sfb02 != '11' AND sfb02 != '15') ",           #CHI-B40039 add
                  " ORDER BY sfb15"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091  #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs2 FROM g_sql
      DECLARE q842_bcs2 CURSOR FOR q842_pbcs2
      
      #-->請購量
      LET g_sql = "SELECT pml33,'','',pml01,pmc03,(pml20-pml21)*pml09,0",   #No.MOD-640059
#                 "  FROM ",l_azp03,".dbo.pml_file,",              #TQC-950003 MARK                                                     
#                           l_azp03,".dbo.pmk_file,",              #TQC-950003 MARK                                                     
#                 " OUTER ",l_azp03,".dbo.pmc_file",               #TQC-950003 MARK                                                     
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"pml_file,",   #TQC-950003 ADD                                                      
                 #          s_dbstring(l_azp03),"pmk_file,",   #TQC-950003 ADD                                                      
                 #-----------------------------------
#FUN-A50102--mod--str---
#                 "  FROM ",s_dbstring(l_azp03_tra),"pml_file,",
#                           s_dbstring(l_azp03_tra),"pmk_file,",
#                #FUN-980091----------------------(E)
#                 " OUTER ",s_dbstring(l_azp03),"pmc_file",    #TQC-950003 ADD 
                  "  FROM ",cl_get_target_table(g_plant_new,'pml_file'),",",
                  "       ",cl_get_target_table(g_plant_new,'pmk_file'),",",
                  " OUTER ",cl_get_target_table(g_plant_new,'pmc_file'),
#FUN-A50102--mod--end
                  " WHERE pml04 = '",g_ima.ima01,"'",
                  "   AND pml01 = pmk01",
                  "   AND pmk_file.pmk09 = pmc_file.pmc01",
                  "   AND pml20 > pml21",
                  "   AND (pml16<='2' OR pml16='S' OR pml16='R' OR pml16='W')",
                  "   AND pml011 != 'SUB'",
                  "   AND pmk18 != 'X'",
                  " ORDER BY pml33"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091  #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs3 FROM g_sql
      DECLARE q842_bcs3 CURSOR FOR q842_pbcs3
      
      #-->採購量
     #LET g_sql = "SELECT pmn33,'','',pmm01,pmc03,(pmn20-pmn50+pmn55)*pmn09,0",   #No.MOD-640059  #FUN-940083 MARK
      LET g_sql = "SELECT pmn33,'','',pmm01,pmc03,(pmn20-pmn50+pmn55+pmn58)*pmn09,0", #FUN-940083 ADD
#                 "  FROM ",l_azp03,".dbo.pmn_file,",             #TQC-950003 MARK                                                      
#                           l_azp03,".dbo.pmm_file,",             #TQC-950003 MARK                                                      
#                 " OUTER ",l_azp03,".dbo.pmc_file",              #TQC-950003 MARK                                                      
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"pmn_file,",  #TQC-950003 ADD                                                       
                 #          s_dbstring(l_azp03),"pmm_file,",  #TQC-950003 ADD                                                       
                 #" OUTER ",s_dbstring(l_azp03),"pmc_file",   #TQC-950003 ADD    
                 #-----------------------------------
#FUN-A50102--mod--str--
#                 "  FROM ",s_dbstring(l_azp03_tra),"pmn_file,",
#                           s_dbstring(l_azp03_tra),"pmm_file,",
#                 " OUTER ",s_dbstring(l_azp03),"pmc_file",
#                #FUN-980091----------------------(E)
                  "  FROM ",cl_get_target_table(g_plant_new,'pmn_file'),",",
                  "       ",cl_get_target_table(g_plant_new,'pmm_file'),",",
                  " OUTER ",cl_get_target_table(g_plant_new,'pmc_file'),
#FUN-A50102--mod--end
                  " WHERE pmn04 = '",g_ima.ima01,"'",
                  "   AND pmn01 = pmm01",
                  "   AND pmm_file.pmm09 = pmc_file.pmc01",
                # "   AND pmn20-(pmn50-pmn55)>0",       #FUN-940083 MARK
                  "   AND pmn20-(pmn50-pmn55-pmn58)>0",  #FUN-940083 ADD
                  "   AND (pmn16 <= '2' OR pmn16='S' OR pmn16='R' OR pmn16='W')",
                  "   AND pmn011 != 'SUB'",
                  "   AND pmm18 != 'X'",
                  " ORDER BY pmn33"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091  #	FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs4 FROM g_sql
      DECLARE q842_bcs4 CURSOR FOR q842_pbcs4
      
      #-->IQC 在驗量
      LET g_sql = "SELECT rva06,'','',rvb01,pmc03,(rvb07-rvb29-rvb30)*pmn09,0",   #No.MOD-640059
#TQC-950003 MARK&ADD START ------------------------                                                                                 
#                 "  FROM ",l_azp03,".dbo.rvb_file,",                                                                                   
#                           l_azp03,".dbo.rva_file,",                                                                                   
#                 " OUTER ",l_azp03,".dbo.pmc_file,",                                                                                   
#                           l_azp03,".dbo.pmn_file,",                                                                                   
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"rvb_file,",                                                                        
                 #          s_dbstring(l_azp03),"rva_file,",                                                                        
                 #" OUTER ",s_dbstring(l_azp03),"pmc_file,",                                                                        
                 #          s_dbstring(l_azp03),"pmn_file,",                                                                        
                 #------------------------------------
#FUN-A50102--mod--str--
#                 "  FROM ",s_dbstring(l_azp03_tra),"rvb_file,",                                                                        
#                           s_dbstring(l_azp03_tra),"rva_file,",                                                                        
#                 " OUTER ",s_dbstring(l_azp03),"pmc_file,",                                                                        
#                           s_dbstring(l_azp03_tra),"pmn_file,",                                                                        
#                #FUN-980091----------------------(E)
##TQC-950003 END------------------------------------                
                 "  FROM ",cl_get_target_table(g_plant_new,'rvb_file'),",",
                 "       ",cl_get_target_table(g_plant_new,'rva_file'),",",
                 " OUTER ",cl_get_target_table(g_plant_new,'pmc_file'),",",
                 "       ",cl_get_target_table(g_plant_new,'pmn_file'),
#FUN-A50102--mod--end
                  " WHERE rvb05 = '",g_ima.ima01,"'",
                  "   AND rvb01 = rva01",
                  "   AND rva_file.rva05 = pmc_file.pmc01",
                  "   AND rvb04 = pmn01",
                  "   AND rvb03 = pmn02",
                  "   AND rvb07 > (rvb29+rvb30)",
                  "   AND rvaconf = 'Y'",
                  "   AND rva10 != 'SUB'",
                  " ORDER BY rva06"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091  #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs5 FROM g_sql
      DECLARE q842_bcs5 CURSOR FOR q842_pbcs5
      
      #-->FQC 在驗量
      LET g_sql = "SELECT sfb81,'','',sfb01,gem02,sfb11,0",   #No.MOD-640059
#                 "  FROM ",l_azp03,".dbo.sfb_file,",             #TQC-950003 MARK                                                      
#                 " OUTER ",l_azp03,".dbo.gem_file",              #TQC-950003 MARK                                                      
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"sfb_file,",  #TQC-950003 ADD                                                       
                 #" OUTER ",s_dbstring(l_azp03),"gem_file",   #TQC-950003 ADD    
                 #----------------------------------
#FUN-A50102--mod--str---
#                 "  FROM ",s_dbstring(l_azp03_tra),"sfb_file,",
#                 " OUTER ",s_dbstring(l_azp03),"gem_file",   #TQC-950003 ADD    
#                #FUN-980091----------------------(E)
                  "  FROM ",cl_get_target_table(g_plant_new,'sfb_file'),",",
                  " OUTER ",cl_get_target_table(g_plant_new,'gem_file'),
#FUN-A50102--mod--end
                  " WHERE sfb05 = '",g_ima.ima01,"'",
                  "   AND sfb02 <> '7'",
                  "   AND sfb87 != 'X'",
                  "   AND sfb04 < '8'",
                  "   AND sfb_file.sfb82 = gem_file.gem01",
                  "   AND sfb11 > 0"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091   #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs51 FROM g_sql
      DECLARE q842_bcs51 CURSOR FOR q842_pbcs51
      
      #-->備料量
#     LET g_sql = "SELECT sfb13,'','',sfa01,gem02,(sfa05-sfa06-sfa065)*sfa13,0",     #No.MOD-640059   #FUN-A60027
     LET g_sql = "SELECT sfb13,'','',sfa01,gem02,SUM((sfa05-sfa06-sfa065)*sfa13),0", #No.FUN-A60027 
#TQC-950003 MARK&ADD START ---------------------------------                                                                        
#                 "  FROM ",l_azp03,".dbo.sfb_file,",                                                                                   
#                           l_azp03,".dbo.sfa_file,",                                                                                   
#                 " OUTER ",l_azp03,".dbo.gem_file",                                                                                    
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"sfb_file,",                                                                        
                 #          s_dbstring(l_azp03),"sfa_file,",                                                                        
                 #" OUTER ",s_dbstring(l_azp03),"gem_file",                                                                         
                 #----------------------------------
#FUN-A50102--mod--str--
#                 "  FROM ",s_dbstring(l_azp03_tra),"sfb_file,",                                                                        
#                           s_dbstring(l_azp03_tra),"sfa_file,",                                                                        
#                 " OUTER ",s_dbstring(l_azp03),"gem_file",                                                                         
#                #FUN-980091----------------------(E)
##TQC-950003 END---------------------------------------------       
                 "  FROM ",cl_get_target_table(g_plant_new,'sfb_file'),",",
                 "       ",cl_get_target_table(g_plant_new,'sfa_file'),",",
                 " OUTER ",cl_get_target_table(g_plant_new,'gem_file'),
#FUN-A50102--mod--end
                  " WHERE sfa03 = '",g_ima.ima01,"'",
                  "   AND sfb01 = sfa01",
                  "   AND sfb_file.sfb82 = gem_file.gem01",
                  "   AND sfb04 != '8'",
                  "   AND sfa05 > 0",
                  "   AND sfa05 > sfa06+sfa065",
                  "   AND sfb87 != 'X'",
                  " GROUP BY sfb13,sfa01,gem02",    #No.FUN-A60027 add   
                  " ORDER BY sfb13"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091  #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs6 FROM g_sql
      DECLARE q842_bcs6 CURSOR FOR q842_pbcs6
      
      #-->銷售備置量
      LET g_sql = "SELECT SUM(oeb905*oeb05_fac)",
#TQC-950003 MARK&ADD START-----------------------------                                                                             
#                 "  FROM ",l_azp03,".dbo.oeb_file,",                                                                                   
#                           l_azp03,".dbo.oea_file,",                                                                                   
#                           l_azp03,".dbo.occ_file",                                                                                    
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"oeb_file,",                                                                        
                 #          s_dbstring(l_azp03),"oea_file,",                                                                        
                 #          s_dbstring(l_azp03),"occ_file",                                                                         
                 #-----------------------------------
#FUN-A50102--mod--str--
#                 "  FROM ",s_dbstring(l_azp03_tra),"oeb_file,",                                                                        
#                           s_dbstring(l_azp03_tra),"oea_file,",                                                                        
#                           s_dbstring(l_azp03),"occ_file",                                                                         
#                #FUN-980091----------------------(E)
##TQC-950003 END---------------------------------------       
                  "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'),",",
                  "       ",cl_get_target_table(g_plant_new,'oea_file'),",",
                  "       ",cl_get_target_table(g_plant_new,'occ_file'),
#FUN-A50102--mod--end
                  " WHERE oeb04 = '",g_ima.ima01,"'",
                  "   AND oeb01 = oea01",
                  "   AND oea00 <> '0'",
                  "   AND oeb19 = 'Y'",
                  "   AND oeb70 = 'N'",
                  "   AND oeb12 > oeb24",
                  "   AND oea03 = occ01",
                  "   AND oeaconf != 'X'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091   #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs7 FROM g_sql
      DECLARE q842_bcs7 CURSOR FOR q842_pbcs7
 
      #-->已分配
      LET g_sql = "SELECT pny10,'','',pny03,pmc02,sfSUM(pny19*pny18),0",   #No.MOD-640059
#TQC-950003 MARK&ADD START--------------------------------------------                                                              
#                 "  FROM ",l_azp03,".dbo.pny_file,",                                                                                   
#                           l_azp03,".dbo.pnx_file,",                                                                                   
#                 " OUTER ",l_azp03,".dbo.pmc_file,",                                                                                   
                 #FUN-980091----------------------(S)
                 #"  FROM ",s_dbstring(l_azp03),"pny_file,",                                                                        
                 #          s_dbstring(l_azp03),"pnx_file,",                                                                        
                 #" OUTER ",s_dbstring(l_azp03),"pmc_file,",                                                                        
                 #----------------------------------
                #FUN-A50102--mod--str--
                # "  FROM ",s_dbstring(l_azp03_tra),"pny_file,",                                                                        
                #           s_dbstring(l_azp03_tra),"pnx_file,",                                                                        
                # " OUTER ",s_dbstring(l_azp03),"pmc_file,",                                                                        
                  "  FROM ",cl_get_target_table(g_plant_new,'pny_file'),",",
                  "       ",cl_get_target_table(g_plant_new,'pnx_file'),",",
                  " OUTER ",cl_get_target_table(g_plant_new,'pmc_file'),
                #FUN-A50102--mod--end
                 #FUN-980091----------------------(E)
#TQC-950003 END------------------------------------------------------   
                  " WHERE pnx07 = '",g_ima.ima01,"'",
                  "   AND pnx01 = pny01",
                  "   AND pnx02 = pny02",
                  "   AND pnx03 = pny03",
                  "   AND pnx04 = pny04",
                  "   AND pnx05 = pny05",
                  "   AND pnx06 = pny06",
#                 "   AND pny24 = g_pmc.pmc01",    #TQC-7A0115
                  "   AND pny_file.pny24 = pmc_file.pmc01",          #TQC-7A0115
                  "   AND pny21 IS NULL"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102 
      #CALL cl_parse_qry_sql(g_sql,l_azp01) RETURNING g_sql #FUN-980091   #FUN-A50102
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE q842_pbcs8 FROM g_sql
      DECLARE q842_bcs8 CURSOR FOR q842_pbcs8
 
      LET g_qty[g_cnt1].plan = l_azp01
      LET g_qty[g_cnt1].pname = l_azp02
 
#No.FUN-A20044 ---mark----start
#      OPEN q842_bima
#      FETCH q842_bima INTO g_qty[g_cnt1].ima26,g_qty[g_cnt1].ima262
#      IF cl_null(g_qty[g_cnt1].ima26) THEN
#         LET g_qty[g_cnt1].ima26 = 0
#      END IF
#      IF cl_null(g_qty[g_cnt1].ima262) THEN
#         LET g_qty[g_cnt1].ima262 = 0
#      END IF
#No.FUN-A20044 ---mark---end  
     CALL s_getstock(g_ima.ima01,l_azp01) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk  #FUN-A20044
     LET g_qty[g_cnt1].avl_stk_mpsmrp = l_avl_stk_mpsmrp                            #FUN-A20044
     LET g_qty[g_cnt1].avl_stk = l_avl_stk                                          #FUN-A20044

      OPEN q842_bcs7
      FETCH q842_bcs7 INTO g_qty[g_cnt1].qty_7
 
      FOREACH q842_bcs1 INTO g_sr[g_cnt].*
         IF STATUS THEN
            CALL cl_err('F1:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET g_sr[g_cnt].ds_plan = l_azp01   #No.MOD-640059
 
         LET l_msg = ''
         CALL cl_getmsg('aim-821',g_lang) RETURNING l_msg
         LET g_sr[g_cnt].ds_class = l_msg
 
         LET qty_1 = qty_1 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_qty[g_cnt1].qty_1 = qty_1
      
      #----------------------------------------------------------------------------
      FOREACH q842_bcs2 INTO g_sr[g_cnt].*,l_sfb02,l_sfb82,l_sfb05      #CHI-B40039 add l_sfb05
         IF STATUS THEN
            CALL cl_err('F2:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET g_sr[g_cnt].ds_plan = l_azp01   #No.MOD-640059
 
         LET l_msg = ''
         CALL cl_getmsg('aim-822',g_lang) RETURNING l_msg
         LET g_sr[g_cnt].ds_class = l_msg
 
         LET qty_2 = qty_2 + g_sr[g_cnt].ds_qlty
         #CHI-B40039---add---start---
         LET l_shb114 = 0
         LET l_sql ="SELECT SUM(shb114) ",
                    "  FROM ",s_dbstring(l_azp03),"shb_file,",
                              s_dbstring(l_azp03),"sfb_file ",
                    " WHERE shb05=sfb01 AND shb10=sfb05 ",
                    "   AND sfb01='",g_sr[g_cnt].ds_no,"'",
                    "   AND shb10='",l_sfb05,"'", 
                    "   AND sfb04 < '8' AND sfb87 != 'X' ",
                    "   AND (sfb02 != '11' AND sfb02 != '15') "            #CHI-B40039 add
         PREPARE q842_shb114 FROM l_sql
         EXECUTE q842_shb114 INTO l_shb114
         IF cl_null(l_shb114) THEN LET l_shb114 = 0 END IF
         LET qty_2 = qty_2 - l_shb114
         LET g_sr[g_cnt].ds_qlty = g_sr[g_cnt].ds_qlty - l_shb114
        #CHI-B40039---add---end---
 
         IF cl_null(g_sr[g_cnt].ds_cust) THEN
            SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 =l_sfb82
            IF SQLCA.sqlcode THEN
               LET l_pmc03 = ' '
            END IF
 
            IF l_sfb02 = '7' AND cl_null(l_pmc03) THEN
               SELECT pmm09,pmc03 INTO l_pmm09,l_pmc03
                 FROM pmm_file,pmc_file
                WHERE pmm01 = g_sr[g_cnt].ds_no
                  AND pmm_file.pmm09 = pmc_file.pmc01
               IF SQLCA.sqlcode THEN
                  LET l_pmc03 = ' '
               END IF
            END IF
 
            LET g_sr[g_cnt].ds_cust = l_pmc03
         END IF
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_qty[g_cnt1].qty_2 = qty_2
      
      #---------------------------------------------------------------------------
      FOREACH q842_bcs3 INTO g_sr[g_cnt].*
         IF STATUS THEN
            CALL cl_err('F3:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET g_sr[g_cnt].ds_plan = l_azp01   #No.MOD-640059
 
         LET l_msg = ''
         CALL cl_getmsg('aim-823',g_lang) RETURNING l_msg
         LET g_sr[g_cnt].ds_class = l_msg
 
         LET qty_3 = qty_3 + g_sr[g_cnt].ds_qlty
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_qty[g_cnt1].qty_3 = qty_3
      
      #----------------------------------------------------------------------------
      FOREACH q842_bcs4 INTO g_sr[g_cnt].*
         IF STATUS THEN
            CALL cl_err('F4:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET g_sr[g_cnt].ds_plan = l_azp01   #No.MOD-640059
 
         LET l_msg = ''
         CALL cl_getmsg('aim-824',g_lang) RETURNING l_msg
         LET g_sr[g_cnt].ds_class = l_msg
 
         LET qty_4 = qty_4 + g_sr[g_cnt].ds_qlty
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_qty[g_cnt1].qty_4 = qty_4
      
      #----------------------------------------------------------------------------
      FOREACH q842_bcs5 INTO g_sr[g_cnt].*
         IF STATUS THEN
            CALL cl_err('F5:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET g_sr[g_cnt].ds_plan = l_azp01   #No.MOD-640059
 
         LET l_msg = ''
         CALL cl_getmsg('aim-825',g_lang) RETURNING l_msg
         LET g_sr[g_cnt].ds_class = l_msg
 
         LET qty_5 = qty_5 + g_sr[g_cnt].ds_qlty
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_qty[g_cnt1].qty_5 = qty_5
      
      #----------------------------------------------------------------------------
      FOREACH q842_bcs51 INTO g_sr[g_cnt].*
         IF STATUS THEN
            CALL cl_err('F51:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET g_sr[g_cnt].ds_plan = l_azp01   #No.MOD-640059
 
         LET l_msg = ''
         CALL cl_getmsg('aim-826',g_lang) RETURNING l_msg
         LET g_sr[g_cnt].ds_class = l_msg
 
         LET qty_51 = qty_51 + g_sr[g_cnt].ds_qlty
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_qty[g_cnt1].qty_51 = qty_51
      
      #----------------------------------------------------------------------------
      FOREACH q842_bcs6 INTO g_sr[g_cnt].*
         IF STATUS THEN
            CALL cl_err('F6:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET g_sr[g_cnt].ds_plan = l_azp01   #No.MOD-640059
 
         LET l_msg = ''
         CALL cl_getmsg('aim-827',g_lang) RETURNING l_msg
         LET g_sr[g_cnt].ds_class = l_msg
 
         LET qty_6 = qty_6 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_qty[g_cnt1].qty_6 = qty_6
 
      #----------------------------------------------------------------------------
      FOREACH q842_bcs8 INTO g_sr[g_cnt].*
         IF STATUS THEN
            CALL cl_err('F8:',STATUS,1)
            EXIT FOREACH
         END IF
 
         LET g_sr[g_cnt].ds_plan = l_azp01   #No.MOD-640059
 
         LET l_msg = ''
         CALL cl_getmsg('apm-045',g_lang) RETURNING l_msg
         LET g_sr[g_cnt].ds_class = l_msg
 
      #  LET qty_6 = qty_6 + g_sr[g_cnt].ds_qlty
         LET g_sr[g_cnt].ds_qlty = g_sr[g_cnt].ds_qlty
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
         END IF
      END FOREACH
    # LET g_qty[g_cnt1].qty_6 = qty_6
     
      LET g_cnt1 = g_cnt1 +1 
   END FOREACH
 
   LET g_cnt = g_cnt - 1
   LET g_cnt1 = g_cnt1 - 1
   LET g_rec_b = g_cnt
   LET g_rec_b1 = g_cnt1
   
   #------------------------Bubble Sort Start !!!--------------
   FOR I= 1 TO g_cnt-1
      FOR J= g_cnt-1 TO I STEP -1
         IF (g_sr[J].ds_date > g_sr[J+1].ds_date) OR
            (g_sr[J+1].ds_date IS NULL) THEN
            LET g_sr_s.* = g_sr[J].*
            LET g_sr[J].* = g_sr[J+1].*
            LET g_sr[J+1].* = g_sr_s.*      
         END IF      
      END FOR
   END FOR
   #------------------------Bubble Sort End--------------------
 
   LET l_sumqty = 0 
 
   FOR I = 1 TO g_cnt1
#     LET l_sumqty = l_sumqty + g_qty[I].ima26             #FUN-A20044
      LET l_sumqty = l_sumqty + g_qty[I].avl_stk_mpsmrp    #FUN-A20044 
   END FOR
 
   FOR I = 1 TO g_cnt
      LET l_sumqty = l_sumqty + g_sr[I].ds_qlty
      LET g_sr[I].ds_total = l_sumqty
   END FOR
   
   DISPLAY g_rec_b TO FORMONLY.cn2
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt = 0
   LET g_cnt1 = 0
 
END FUNCTION
 
FUNCTION q842_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qty TO s_qty.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         EXIT DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END DISPLAY
 
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         CALL cl_show_fld_cont()
 
      ON ACTION first
         CALL q842_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION previous
         CALL q842_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
#        ACCEPT DISPLAY
         EXIT DISPLAY
 
      ON ACTION jump
         CALL q842_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION next
         CALL q842_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION last
         CALL q842_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL q842_mu_ui()   #TQC-710032
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
#@    ON ACTION 依料號查詢
#     ON ACTION query_by_item_no
#        LET g_action_choice="query_by_item_no"
 
#@    ON ACTION 依工單查詢
      ON ACTION query_by_w_o
         LET g_action_choice="query_by_w_o"
         EXIT DISPLAY
 
#@    ON ACTION 依訂單查詢
      ON ACTION query_by_order
         LET g_action_choice="query_by_order"
         EXIT DISPLAY
 
#@    ON ACTION 依BOM查詢
      ON ACTION query_by_bom
         LET g_action_choice="query_by_bom"
         EXIT DISPLAY
 
      ON ACTION change
         IF g_cha = "1" THEN
            LET g_cha = "2"
         ELSE
            LET g_cha = "1"
         END IF
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION q842_bp1(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
 
   END DISPLAY
 
   DISPLAY ARRAY g_qty TO s_qty.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         CALL cl_show_fld_cont()
 
      ON ACTION first
         CALL q842_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION previous
         CALL q842_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION jump
         CALL q842_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION next
         CALL q842_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION last
         CALL q842_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL q842_mu_ui()   #TQC-710032
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
#@    ON ACTION 依料號查詢
#     ON ACTION query_by_item_no
#        LET g_action_choice="query_by_item_no"
 
#@    ON ACTION 依工單查詢
      ON ACTION query_by_w_o
         LET g_action_choice="query_by_w_o"
         EXIT DISPLAY
 
#@    ON ACTION 依訂單查詢
      ON ACTION query_by_order
         LET g_action_choice="query_by_order"
         EXIT DISPLAY
 
#@    ON ACTION 依BOM查詢
      ON ACTION query_by_bom
         LET g_action_choice="query_by_bom"
         EXIT DISPLAY
 
      ON ACTION change
         IF g_cha = "1" THEN
            LET g_cha = "2"
         ELSE
            LET g_cha = "1"
         END IF
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#-----TQC-710032---------
FUNCTION q842_mu_ui()
   CALL cl_set_comp_visible("ima906",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group043",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("ima907",g_sma.sma115 = 'Y')
   CALL cl_set_comp_visible("group044",g_sma.sma115='Y')
   
   IF g_sma.sma122='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
   
   IF g_sma.sma122='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("ima907",g_msg CLIPPED)
   END IF
END FUNCTION
#-----END TQC-710032-----
