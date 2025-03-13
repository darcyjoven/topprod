# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aicq025.4gl
# Descriptions...:
# Date & Author..: 08/01/14 By hellen No.FUN-7B0018
#                  1.主要數量:等同aimq841的取得方式
#                  2.參考數量:換算每一個主要單位和參考單位之比率,
#                             再乘上供需數量
#                    受訂量: (oeb915/oeb12) *受訂量       bcs1
#                    在製量: (sfbiicd06/sfb08) *在製量    bcs2
#                    請購量: (pml83/pml20) *請購量        bcs3
#                    採購量: (pmn85/pmn20 ) *採購量       bcs4
#                    IQC在驗量: sum(qcs35/qcs06) * IQC    bcs5/bcs5_r
#                    FQC在驗量: sum(qcf35/ qcf06 ) * FQC  bcs51/bcs51_r
#                    備料量: (sfaiicd01/sfa05) * 備料量   bcs6
#                    訂單備置: (oeb915/oeb12)* 訂單備置
#Modify..........: No.FUN-7B0018 by hellen
#Modify..........: No.FUN-830076 08/03/21 by hellen 新增“相關文件”ACTION
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料為Key值
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-940083 09/05/18 By Cockroach 原可收量(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/22 By vealxu ima26x 調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_argv1      STRING                             #料號
   DEFINE g_sw         LIKE type_file.chr1
   DEFINE g_wc         STRING                             #WHERE CONDICTION
   DEFINE g_wc2        STRING                             #WHERE CONDICTION
   DEFINE g_sql        STRING
   DEFINE g_rec_b      LIKE type_file.num5
   DEFINE g_i          LIKE type_file.num5
   DEFINE g_ima        RECORD
                       ima01    LIKE ima_file.ima01,      #料號
                       ima02    LIKE ima_file.ima02,      #品名
                       ima021   LIKE ima_file.ima021,     #品名
                       ima25    LIKE ima_file.ima25,      #單位
#                      ima262   LIKE ima_file.ima262,     #庫存量                  #FUN-A20044
#                      ima26    LIKE ima_file.ima26,      #MRP可用庫存量           #FUN-A20044
                       avl_stk LIKE type_file.num15_3,                              #FUN-A20044
                       avl_stk_mpsmrp LIKE type_file.num15_3,                       #FUN-A20044 
                       ima906   LIKE ima_file.ima906,     #單位控管方式
                       ima907   LIKE ima_file.ima907,     #第二單位
#                      ima262_r LIKE ima_file.ima262,     #參考庫存量             #FUN-A20044
#                      ima26_r  LIKE ima_file.ima26,      #參考MRP可用庫存量      #FUN-A20044
                       avl_stk_r LIKE type_file.num15_3,                           #FUN-A20044
                       avl_stk_mpsmrp_r LIKE type_file.num15_3,                    #FUN-A20044 
                       imaicd11 LIKE imaicd_file.imaicd11 #作業群組
                       END RECORD
   DEFINE g_sr         DYNAMIC ARRAY OF RECORD
                       ds_date  LIKE type_file.dat,
                       ds_class LIKE type_file.chr20,
                       ds_no    LIKE type_file.chr20,
                       ima01_b1 LIKE ima_file.ima01,
                       ima02_b1 LIKE ima_file.ima02,
                       imaicd01 LIKE imaicd_file.imaicd01,
                       ima02_b2 LIKE ima_file.ima02,
                       ds_cust  LIKE pmm_file.pmm09,
                       ds_qlty  LIKE rpc_file.rpc13,
                       ref_qty  LIKE rpc_file.rpc13,
                       ds_total LIKE rpc_file.rpc13
                       END RECORD
   DEFINE g_sr_s       RECORD
                       ds_date  LIKE type_file.dat,
                       ds_class LIKE type_file.chr20,
                       ds_no    LIKE type_file.chr20,
                       ima01    LIKE ima_file.ima01,
                       ima02_1  LIKE ima_file.ima02,
                       imaicd01 LIKE imaicd_file.imaicd01,
                       ima02_2  LIKE ima_file.ima02,
                       ds_cust  LIKE pmm_file.pmm09,
                       ds_qlty  LIKE rpc_file.rpc13,
                       ref_qty  LIKE rpc_file.rpc13,
                       ds_total LIKE rpc_file.rpc13
                       END RECORD
   DEFINE g_order      LIKE type_file.num5
   DEFINE g_cnt        LIKE type_file.num10
   DEFINE g_msg        STRING
   DEFINE g_row_count  LIKE type_file.num10
   DEFINE g_curs_index LIKE type_file.num10
   DEFINE g_jump       LIKE type_file.num10
   DEFINE g_no_ask    LIKE type_file.num5
 
MAIN
   OPTIONS                                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('icd') THEN
      CALL cl_err('','aic-999',1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW q025_w WITH FORM "aic/42f/aicq025"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
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
 
   IF NOT cl_null(g_argv1) THEN
      CALL q025_q()
   END IF
 
   CALL q025_menu()
   CLOSE WINDOW q025_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q025_cs()
 
   DEFINE l_cnt LIKE type_file.num5
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "ima01 IN(",g_argv1,")"
#     LET g_wc = "ima01 ='SUI110D'"
   ELSE
      CLEAR FORM #清除畫面
      CALL g_sr.clear()
      CALL cl_opmsg('q')
      CONSTRUCT BY NAME g_wc ON ima01,ima02,imaicd11,ima021
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
      IF INT_FLAG THEN RETURN END IF
   END IF
#   LET g_sql=" SELECT ima01,ima02,ima021,ima25,ima262,ima26,",   #FUN-A20044
    LET g_sql=" SELECT ima01,ima02,ima021,ima25,' ', ' '",        #FUN-A20044
             "        ima906,ima907,0,0,imaicd11 ",
             "   FROM ima_file,imaicd_file ",
             "  WHERE ima01 = imaicd00 ",
             "    AND ",g_wc CLIPPED
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q025_prepare FROM g_sql
   DECLARE q025_cs SCROLL CURSOR FOR q025_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM ima_file,imaicd_file ",
             "  WHERE ima01 = imaicd00 ",
             "    AND ", g_wc CLIPPED
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q025_pp  FROM g_sql
   DECLARE q025_cnt CURSOR FOR q025_pp
   
END FUNCTION
 
 
FUNCTION q025_menu()
 
   WHILE TRUE
      CALL q025_bp("G")
      CASE g_action_choice
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "query"
            LET g_sw = 1
            CALL q025_q()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_sr),'','')
            END IF
         #No.FUN-830076 add 08/03/21 --begin
         WHEN "related_document"       #相關文件
            IF cl_chk_act_auth() THEN
               IF g_ima.ima01 IS NOT NULL THEN
                  LET g_doc.column1 = "ima01"
                  LET g_doc.value1 = g_ima.ima01
                  CALL cl_doc()
               END IF
            END IF
         #No.FUN-830076 add 08/03/21 --end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q025_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q025_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   MESSAGE "Waiting!"
   OPEN q025_cs                                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('q025_q:',SQLCA.sqlcode,0)
   ELSE
      OPEN q025_cnt
      FETCH q025_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q025_fetch('F')                                #讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
   
END FUNCTION
 
FUNCTION q025_fetch(p_flag)
 
   
   DEFINE p_flag LIKE type_file.chr1                      #處理方式
   DEFINE l_unavl_stk  LIKE type_file.num15_3             #FUN-A20044 
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     q025_cs INTO g_ima.*
       WHEN 'P' FETCH PREVIOUS q025_cs INTO g_ima.*
       WHEN 'F' FETCH FIRST    q025_cs INTO g_ima.*
       WHEN 'L' FETCH LAST     q025_cs INTO g_ima.*
       WHEN '/'
          IF (NOT g_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0                             #add for prompt bug
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
          FETCH ABSOLUTE g_jump q025_cs INTO g_ima.*
          LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
       CALL cl_err('Fetch:',SQLCA.sqlcode,0)
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
   CALL s_getstock(g_ima.ima01,g_plant) RETURNING g_ima.avl_stk_mpsmrp,l_unavl_stk,g_ima.avl_stk
 
   CALL q025_show()
   
END FUNCTION
 
FUNCTION q025_show()
   DEFINE l_avl_stk_mpsmrp    LIKE type_file.num15_3     #FUN-A20044 
   DEFINE l_unavl_stk         LIKE type_file.num15_3     #FUN-A20044
   DEFINE l_avl_stk           LIKE type_file.num15_3     #FUN-A20044
 
   #庫存可用量的參考數量
#  SELECT SUM(imgg10 * imgg21) INTO g_ima.ima26_r                 #FUN-A20044
   SELECT SUM(imgg10 * imgg21) INTO g_ima.avl_stk_mpsmrp_r        #FUN-A20044
     FROM imgg_file,img_file
    WHERE imgg01 = g_ima.ima01
#     AND imgg23 = 'Y'
      AND imgg10 IS NOT NULL
      AND imgg21 IS NOT NULL
      AND imgg01 = img01                                  #料
      AND imgg02 = img02                                  #倉
      AND imgg03 = img03                                  #儲
      AND imgg04 = img04                                  #批
      AND img23 = 'Y'                                     #是否為可用倉儲
#   IF cl_null(g_ima.ima26_r) THEN         #FUN-A20044  mark
#      LET g_ima.ima26_r = 0               #FUN-A20044  mark
#   END IF                                 #FUN-A20044  mark
#   IF g_ima.ima906 = '1' THEN             #FUN-A20044  mark
#      LET g_ima.ima26_r = ''              #FUN-A20044  mark
#   END IF                                 #FUN-A20044  mark
#FUN-A20044 ---start---
   IF cl_null(g_ima.avl_stk_mpsmrp_r) THEN
      LET g_ima.avl_stk_mpsmrp_r = 0
   END IF 
   IF g_ima.ima906 = '1' THEN
      LET g_ima.avl_stk_mpsmrp_r = '' 
   END IF 
   
   CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
   LET g_ima.avl_stk_mpsmrp = l_avl_stk_mpsmrp
   LET g_ima.avl_stk = l_avl_stk
#FUN-A20044 ---end---


   #庫存MRP可用量的參考數量
#   SELECT SUM(imgg10 * imgg21) INTO g_ima.ima262_r      #FUN-A20044
   SELECT SUM(imgg10 * imgg21) INTO g_ima.avl_stk_r      #FUN-A20044
     FROM imgg_file,img_file
    WHERE imgg01 = g_ima.ima01 
#     AND imgg23 = 'Y' 
#     AND imgg24 = 'Y'
      AND imgg10 IS NOT NULL
      AND imgg21 IS NOT NULL
      AND imgg01 = img01                                  #料
      AND imgg02 = img02                                  #倉
      AND imgg03 = img03                                  #儲
      AND imgg04 = img04                                  #批
      AND img24 = 'Y'                                     #是否為MRP可用倉儲
#   IF cl_null(g_ima.ima262_r) THEN                       #FUN-A20044
#      LET g_ima.ima262_r = 0                             #FUN-A20044
#   END IF                                                #FUN-A20044 
#   IF g_ima.ima906 = '1' THEN                            #FUN-A20044
#      LET g_ima.ima262_r = ''                            #FUN-A20044
#   END IF                                                #FUN-A20044
#FUN-A20044 ---start---
   IF cl_null(g_ima.avl_stk_r) THEN
      LET g_ima.avl_stk_r = 0
   END IF 
   IF g_ima.ima906 = '1' THEN
      LET g_ima.avl_stk_r = ''
   END IF 
#FUN-A20044 ---end---
 
   DISPLAY BY NAME g_ima.*
   MESSAGE ' WAIT '
   CALL q025_b_fill()                                     #單身
   MESSAGE ''
   CALL cl_show_fld_cont()
    
END FUNCTION
 
FUNCTION q025_b_fill()                                    #BODY FILL UP
   DEFINE l_sfb02     LIKE type_file.num5
   DEFINE I           LIKE type_file.num10
   DEFINE J           LIKE type_file.num10
   DEFINE m_oeb12     LIKE oeb_file.oeb12
   DEFINE m_ogb12     LIKE ogb_file.ogb12
   DEFINE l_pmm09     LIKE pmm_file.pmm09
   DEFINE l_pmc03     LIKE pmc_file.pmc03
   DEFINE l_sfb82     LIKE sfb_file.sfb82
   DEFINE l_ima55_fac LIKE ima_file.ima55_fac
   DEFINE qty_1       LIKE sfb_file.sfb08
   DEFINE qty_1_r     LIKE sfb_file.sfb08
   DEFINE qty_2       LIKE sfb_file.sfb08
   DEFINE qty_2_r     LIKE sfb_file.sfb08
   DEFINE qty_3       LIKE sfb_file.sfb08
   DEFINE qty_3_r     LIKE sfb_file.sfb08
   DEFINE qty_4       LIKE sfb_file.sfb08
   DEFINE qty_4_r     LIKE sfb_file.sfb08
   DEFINE qty_5       LIKE sfb_file.sfb08
   DEFINE qty_5_r     LIKE sfb_file.sfb08
   DEFINE qty_51      LIKE sfb_file.sfb08
   DEFINE qty_51_r    LIKE sfb_file.sfb08
   DEFINE qty_6       LIKE sfb_file.sfb08
   DEFINE qty_6_r     LIKE sfb_file.sfb08
   DEFINE qty_7       LIKE sfb_file.sfb08
   DEFINE qty_7_r     LIKE sfb_file.sfb08
   DEFINE l_msg       STRING
   DEFINE m_oeb915    LIKE oeb_file.oeb915
   DEFINE l_rvb01     LIKE rvb_file.rvb01
   DEFINE l_rvb02     LIKE rvb_file.rvb02
   DEFINE l_sfb01     LIKE sfb_file.sfb01
 
   IF g_ima.ima906 = '1' THEN
      LET qty_1_r = '' 
      LET qty_2_r = ''  
      LET qty_3_r = '' 
      LET qty_4_r = ''
      LET qty_5_r = '' 
      LET qty_51_r = '' 
      LET qty_6_r = '' 
      LET qty_7_r = ''
   ELSE
      LET qty_1_r = 0 
      LET qty_2_r = 0  
      LET qty_3_r = 0 
      LET qty_4_r = 0
      LET qty_5_r = 0 
      LET qty_51_r = 0 
      LET qty_6_r = 0 
      LET qty_7_r = 0
   END IF
 
   #-->受訂量
   DECLARE q025_bcs1 CURSOR FOR
    SELECT oeb15,'',oeb01,oeb04,a.ima02,oebi_file.oebiicd01,b.ima02,
           occ02,(oeb12-oeb24+oeb25-oeb26)*oeb05_fac,(oeb915/oeb12),0
      FROM oeb_file,oea_file,occ_file,oebi_file, OUTER ima_file a,OUTER ima_file b
     WHERE oeb04 = g_ima.ima01 
       AND oeb01 = oea01
       AND oeb01 = oebi01
       AND oeb03 = oebi03
       AND occ01 = oea03
       AND oea00<>'0'
       AND oeb70 = 'N'
       AND oeb12-oeb24+oeb25-oeb26 >0
#      AND oeb12 > oeb24
       AND oeaconf !='X'
       AND oeb_file.oeb04 = a.ima01
       AND oebi_file.oebiicd01 = b.ima01
     ORDER BY oeb15
     
   #-->在製量
   SELECT ima55_fac INTO l_ima55_fac
     FROM ima_file
    WHERE ima01 = g_ima.ima01
   IF cl_null(l_ima55_fac) THEN
       LET l_ima55_fac = 1
   END IF
   DECLARE q025_bcs2 CURSOR FOR
    SELECT sfb15,'',sfb01,sfb05,a.ima02,sfbiicd14,b.ima02,
           gem02,(sfb08-sfb09-sfb10-sfb11-sfb12)*l_ima55_fac,
           (sfbiicd06/sfb08),0,sfb02,sfb82
      FROM sfb_file,sfbi_file,OUTER gem_file,OUTER ima_file a,OUTER ima_file b
     WHERE sfb05 = g_ima.ima01
       AND sfb01 = sfbi01
       AND sfb04 !='8'
       AND sfb_file.sfb82 = gem_file.gem01
       AND sfb08 > (sfb09+sfb10+sfb11+sfb12)
       AND sfb87!='X'
       AND sfb_file.sfb05 = a.ima01
       AND sfbi_file.sfbiicd14 = b.ima01
     ORDER BY sfb15
     
   #-->請購量
   DECLARE q025_bcs3 CURSOR FOR
      SELECT pml35,'',pml01,pml04,a.ima02,'','',
             pmc03,(pml20-pml21)*pml09,(pml83/pml20),0
        FROM pml_file, pmk_file, OUTER pmc_file,OUTER ima_file a
        WHERE pml04 = g_ima.ima01
          AND pml01 = pmk01
          AND pmk_file.pmk09 = pmc_file.pmc01
          AND pml20 > pml21
          AND (pml16<='2' OR pml16='S' OR pml16='R' OR pml16='W')
          AND pml011 !='SUB'
          AND pmk18 != 'X'
          AND pml_file.pml04 = a.ima01
        ORDER BY pml35
        
   #-->採購量
   DECLARE q025_bcs4 CURSOR FOR
    SELECT pmn33,'',pmm01,pmn04,a.ima02,pmniicd14,b.ima02,
         # pmc03,(pmn20-pmn50+pmn55)*pmn09,(pmn85/pmn20),0        #FUN-940083 MARK
           pmc03,(pmn20-pmn50+pmn55+pmn58)*pmn09,(pmn85/pmn20),0  #FUN-940083 ADD
      FROM pmn_file,pmm_file,pmni_file,OUTER pmc_file,
           OUTER ima_file a,OUTER ima_file b
     WHERE pmn04 = g_ima.ima01 
       AND pmn01 = pmm01
       AND pmn01 = pmni01
       AND pmn02 = pmni02
       AND pmm_file.pmm09 = pmc_file.pmc01
     # AND pmn20 -(pmn50-pmn55)>0       #FUN-940083 MARK
       AND pmn20 -(pmn50-pmn55-pmn58)>0 #FUN-940083 ADD  
       AND (pmn16 <= '2' OR pmn16='S' OR pmn16='R' OR pmn16='W')
       AND pmn011 !='SUB'
       AND pmm18 != 'X'
       AND pmn_file.pmn04 = a.ima01
       AND pmni_file.pmniicd14 = b.ima01
     ORDER BY pmn33
     
   #-->IQC 在驗量
   DECLARE q025_bcs5 CURSOR FOR
    SELECT rva06,'',rvb01,rvb05,a.ima02,rvbiicd14,b.ima02,
           pmc03,(rvb07-rvb29-rvb30)*pmn09,0,0,rvb01,rvb02
      FROM rvb_file,rva_file,rvbi_file,OUTER pmc_file, pmn_file,
           OUTER ima_file a, OUTER ima_file b
     WHERE rvb05 = g_ima.ima01
       AND rvb01 = rva01
       AND rvb01 = rvbi01
       AND rvb02 = rvbi02
       AND rva_file.rva05 = pmc_file.pmc01
       AND rvb_file.rvb04 = pmn_file.pmn01
       AND rvb_file.rvb03 = pmn_file.pmn02
       AND rvb07 > (rvb29+rvb30)
       AND rvaconf='Y'
       AND rva10 !='SUB'
       AND rvb_file.rvb05 = a.ima01
       AND rvbi_file.rvbiicd14 = b.ima01
     ORDER BY rva06
 
   #-->IQC 在驗量
   DECLARE q025_bcs5_r CURSOR FOR
    SELECT SUM(qcs35/qcs06)
      FROM rvb_file, rva_file,qcs_file
     WHERE rvb05 = g_ima.ima01
       AND rvb01 = rva01
       AND rvb07 > (rvb29+rvb30)
       AND rvaconf='Y'
       AND rva10 !='SUB'
       AND qcs01 = rvb01                                  #收貨單號
       AND qcs02 = rvb02                                  #收貨項次
       AND qcs14 != 'X'                                   #未作廢
       AND qcs06 > 0
       AND rvb01 = l_rvb01
       AND rvb02 = l_rvb02
     ORDER BY rva06
 
   #-->FQC 在驗量
   DECLARE q025_bcs51 CURSOR FOR
    SELECT sfb15,'',sfb01,sfb05,a.ima02,sfbiicd14,b.ima02,
           gem02,sfb11,0,0,sfb01
      FROM sfb_file,sfbi_file,OUTER gem_file,OUTER ima_file a,OUTER ima_file b
     WHERE sfb05 = g_ima.ima01
       AND sfb01 = sfbi01
       AND sfb02 <> '7'
       AND sfb87!='X'
       AND sfb04 <'8'
       AND sfb_file.sfb82=gem_file.gem01
       AND sfb11 > 0
       AND sfb_file.sfb05 = a.ima01
       AND sfbi_file.sfbiicd14 = b.ima01
 
   #-->FQC 在驗量
   DECLARE q025_bcs51_r CURSOR FOR
    SELECT SUM(qcf35/qcf06 )
      FROM sfb_file,qcf_file
     WHERE sfb05 = g_ima.ima01
       AND sfb02 <> '7'
       AND sfb87!='X'
       AND sfb04 <'8'
       AND sfb11 > 0
       AND qcf02 = sfb01                                  #工單單號
       AND qcf14 != 'X'                                   #未作廢之FQC單
       AND qcf06 > 0
       AND qcf02 = l_sfb01
 
   #-->備料量
   DECLARE q025_bcs6 CURSOR FOR
    SELECT sfb13,'',sfa01,sfa03,a.ima02,'','',
           gem02,(sfa05-sfa06-sfa065)*sfa13,(sfaiicd01/sfa05),0
      FROM sfb_file,sfa_file,sfai_file,OUTER gem_file,OUTER ima_file a
     WHERE sfa03 = g_ima.ima01
       AND sfa01 = sfai01
       AND sfa03 = sfai03
       AND sfa08 = sfai08
       AND sfa12 = sfai12
       AND sfa27 = sfai27 #CHI-7B0034
       AND sfb01 = sfa01
       AND sfb_file.sfb82 = gem_file.gem01
       AND sfb04 !='8' AND sfa05 > 0
       AND sfa05 > sfa06+sfa065
       AND sfb87!='X'
       AND sfb_file.sfb05 = a.ima01
     ORDER BY sfb13
 
   #-->銷售備置量
   SELECT SUM(oeb905*oeb05_fac),SUM((oeb905*oeb05_fac)*(oeb915/oeb12))
     INTO m_oeb12,m_oeb915
     FROM oeb_file, oea_file, occ_file
    WHERE oeb04 = g_ima.ima01
      AND oeb01 = oea01
      AND oea00 <>'0'
      AND oeb19 = 'Y'
      AND oeb70 = 'N'
      AND oeb12 > oeb24
      AND oea03=occ01
      AND oeaconf != 'X'
 
   IF cl_null(m_oeb12) THEN
      LET m_oeb12 = 0
   END IF
   IF cl_null(m_oeb915) THEN
      LET m_oeb915 = 0
   END IF
   IF g_ima.ima906 = '1' THEN
      LET m_oeb915 = ''
   END IF
   LET qty_7 = m_oeb12
   LET qty_7_r = m_oeb915
 
   DISPLAY BY NAME qty_7 ATTRIBUTE(REVERSE)               #銷售備置量不條列明細
   DISPLAY BY NAME qty_7_r ATTRIBUTE(REVERSE)             #銷售備置量不條列明細
 
   CALL g_sr.clear()
   LET g_cnt = 1
   LET qty_1=0
   LET qty_2=0
   LET qty_3=0
   LET qty_4=0
   LET qty_5=0
   LET qty_51=0
   LET qty_6=0
   LET qty_7=0
 
   #受訂量
   FOREACH q025_bcs1 INTO g_sr[g_cnt].*
      IF STATUS THEN
         CALL cl_err('F1:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-821',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      IF cl_null(g_sr[g_cnt].ds_qlty) THEN
         LET g_sr[g_cnt].ds_qlty = 0
      END IF
      LET qty_1 = qty_1 + g_sr[g_cnt].ds_qlty
 
      #參考數量
      LET g_sr[g_cnt].ref_qty = g_sr[g_cnt].ds_qlty*g_sr[g_cnt].ref_qty
      IF cl_null(g_sr[g_cnt].ref_qty) THEN
         LET g_sr[g_cnt].ref_qty = 0
      END IF
      IF g_ima.ima906 = '1' THEN
         LET g_sr[g_cnt].ref_qty = ''
      END IF
      LET qty_1_r = qty_1_r + g_sr[g_cnt].ref_qty
 
      #受訂量明細:用負數承現
      LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
      LET g_sr[g_cnt].ref_qty = -g_sr[g_cnt].ref_qty
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_1 ATTRIBUTE(REVERSE)
   DISPLAY BY NAME qty_1_r ATTRIBUTE(REVERSE)
 
   #在製量
   FOREACH q025_bcs2 INTO g_sr[g_cnt].*,l_sfb02,l_sfb82
      IF STATUS THEN
         CALL cl_err('F2:',STATUS,1)
         EXIT FOREACH 
      END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-822',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      IF cl_null(g_sr[g_cnt].ds_qlty) THEN
         LET g_sr[g_cnt].ds_qlty = 0
      END IF
      LET qty_2 = qty_2 + g_sr[g_cnt].ds_qlty
 
      #參考數量
      LET g_sr[g_cnt].ref_qty = g_sr[g_cnt].ds_qlty*g_sr[g_cnt].ref_qty
      IF cl_null(g_sr[g_cnt].ref_qty) THEN
         LET g_sr[g_cnt].ref_qty = 0
      END IF
      IF g_ima.ima906 = '1' THEN
         LET g_sr[g_cnt].ref_qty = ''
      END IF
      LET qty_2_r = qty_2_r + g_sr[g_cnt].ref_qty
 
      IF cl_null(g_sr[g_cnt].ds_cust) THEN
         SELECT pmc03 INTO l_pmc03
           FROM pmc_file
          WHERE pmc01 =l_sfb82
         IF SQLCA.sqlcode THEN
            LET l_pmc03 = ' '
         END IF
         IF l_sfb02 = '7' AND cl_null(l_pmc03) THEN
            SELECT pmm09,pmc03
              INTO l_pmm09,l_pmc03
              FROM pmm_file,pmc_file
             WHERE pmm01 = g_sr[g_cnt].ds_no
               AND pmm09 = pmc01
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
   DISPLAY BY NAME qty_2 ATTRIBUTE(REVERSE)
   DISPLAY BY NAME qty_2_r ATTRIBUTE(REVERSE)
 
   #請購量
   FOREACH q025_bcs3 INTO g_sr[g_cnt].*
      IF STATUS THEN
         CALL cl_err('F3:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-823',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      IF cl_null(g_sr[g_cnt].ds_qlty) THEN
         LET g_sr[g_cnt].ds_qlty = 0
      END IF
      LET qty_3 = qty_3 + g_sr[g_cnt].ds_qlty
 
      #參考數量
      LET g_sr[g_cnt].ref_qty = g_sr[g_cnt].ds_qlty*g_sr[g_cnt].ref_qty
      IF cl_null(g_sr[g_cnt].ref_qty) THEN
         LET g_sr[g_cnt].ref_qty = 0 
      END IF
      IF g_ima.ima906 = '1' THEN
         LET g_sr[g_cnt].ref_qty = ''
      END IF
      LET qty_3_r = qty_3_r + g_sr[g_cnt].ref_qty
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_3 ATTRIBUTE(REVERSE)
   DISPLAY BY NAME qty_3_r ATTRIBUTE(REVERSE)
 
   #採購量
   FOREACH q025_bcs4 INTO g_sr[g_cnt].*
      IF STATUS THEN
         CALL cl_err('F4:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-824',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      IF cl_null(g_sr[g_cnt].ds_qlty) THEN 
         LET g_sr[g_cnt].ds_qlty = 0
      END IF
      LET qty_4 = qty_4 + g_sr[g_cnt].ds_qlty
 
      #參考數量
      LET g_sr[g_cnt].ref_qty = g_sr[g_cnt].ds_qlty*g_sr[g_cnt].ref_qty
      IF cl_null(g_sr[g_cnt].ref_qty) THEN
         LET g_sr[g_cnt].ref_qty = 0
      END IF
      IF g_ima.ima906 = '1' THEN 
         LET g_sr[g_cnt].ref_qty = ''
      END IF
      LET qty_4_r = qty_4_r + g_sr[g_cnt].ref_qty
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_4 ATTRIBUTE(REVERSE)
   DISPLAY BY NAME qty_4_r ATTRIBUTE(REVERSE)
 
   #IQC在驗量
   FOREACH q025_bcs5 INTO g_sr[g_cnt].*,l_rvb01,l_rvb02
      IF STATUS THEN
         CALL cl_err('F5:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-825',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      IF cl_null(g_sr[g_cnt].ds_qlty) THEN
         LET g_sr[g_cnt].ds_qlty = 0
      END IF
      LET qty_5 = qty_5 + g_sr[g_cnt].ds_qlty
 
      #參考數量
      OPEN q025_bcs5_r
      FETCH q025_bcs5_r INTO g_sr[g_cnt].ref_qty
      LET g_sr[g_cnt].ref_qty = g_sr[g_cnt].ds_qlty*g_sr[g_cnt].ref_qty
      IF cl_null(g_sr[g_cnt].ref_qty) THEN
         LET g_sr[g_cnt].ref_qty = 0
      END IF
      IF g_ima.ima906 = '1' THEN
         LET g_sr[g_cnt].ref_qty = ''
      END IF
      LET qty_5_r = qty_5_r + g_sr[g_cnt].ref_qty
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_5 ATTRIBUTE(REVERSE)
   DISPLAY BY NAME qty_5_r ATTRIBUTE(REVERSE)
 
   #FQC在驗量
   FOREACH q025_bcs51 INTO g_sr[g_cnt].*,l_sfb01
      IF STATUS THEN
         CALL cl_err('F51:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-826',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      IF cl_null(g_sr[g_cnt].ds_qlty) THEN
         LET g_sr[g_cnt].ds_qlty = 0
      END IF
      LET qty_51 = qty_51 + g_sr[g_cnt].ds_qlty
 
      #參考數量
      OPEN q025_bcs51_r
      FETCH q025_bcs51_r INTO g_sr[g_cnt].ref_qty
      LET g_sr[g_cnt].ref_qty = g_sr[g_cnt].ds_qlty*g_sr[g_cnt].ref_qty
      IF cl_null(g_sr[g_cnt].ref_qty) THEN
         LET g_sr[g_cnt].ref_qty = 0
      END IF
      IF g_ima.ima906 = '1' THEN
         LET g_sr[g_cnt].ref_qty = ''
      END IF
      LET qty_51_r = qty_51_r + g_sr[g_cnt].ref_qty
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_51 ATTRIBUTE(REVERSE)
   DISPLAY BY NAME qty_51_r ATTRIBUTE(REVERSE)
 
   #備料量
   FOREACH q025_bcs6 INTO g_sr[g_cnt].*
      IF STATUS THEN
         CALL cl_err('F6:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_msg = ''
      CALL cl_getmsg('aim-827',g_lang) RETURNING l_msg
      LET g_sr[g_cnt].ds_class = l_msg
      IF cl_null(g_sr[g_cnt].ds_qlty) THEN
         LET g_sr[g_cnt].ds_qlty = 0
      END IF
      LET qty_6 = qty_6 + g_sr[g_cnt].ds_qlty
 
      #參考數量
      LET g_sr[g_cnt].ref_qty = g_sr[g_cnt].ds_qlty*g_sr[g_cnt].ref_qty
      IF cl_null(g_sr[g_cnt].ref_qty) THEN
         LET g_sr[g_cnt].ref_qty = 0
      END IF
      IF g_ima.ima906 = '1' THEN
         LET g_sr[g_cnt].ref_qty = ''
      END IF
      LET qty_6_r = qty_6_r + g_sr[g_cnt].ref_qty
 
      #備料量明細:用負數承現
      LET g_sr[g_cnt].ds_qlty = -g_sr[g_cnt].ds_qlty
      LET g_sr[g_cnt].ref_qty = -g_sr[g_cnt].ref_qty
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   DISPLAY BY NAME qty_6 ATTRIBUTE(REVERSE)
   DISPLAY BY NAME qty_6_r ATTRIBUTE(REVERSE)
 
   LET g_cnt = g_cnt - 1                                  #Get real number of record
   LET g_rec_b = g_cnt
 
   FOR I= 1 TO g_cnt-1
      FOR J= g_cnt-1 TO I STEP -1
      #---------- COMPARE  & SWAP ------------
         IF (g_sr[J].ds_date > g_sr[J+1].ds_date) OR
            (g_sr[J+1].ds_date IS NULL) THEN
            LET g_sr_s.* = g_sr[J].*
            LET g_sr[J].* = g_sr[J+1].*
            LET g_sr[J+1].* = g_sr_s.*
         END IF
      END FOR
   END FOR
   
   FOR I = 1 TO g_cnt
#      LET g_ima.ima26 = g_ima.ima26 + g_sr[I].ds_qlty    #FUN-A20044
#      LET g_sr[I].ds_total = g_ima.ima26                 #FUN-A20044
      LET g_ima.avl_stk_mpsmrp = g_ima.avl_stk_mpsmrp + g_sr[I].ds_qlty   #FUN-A20044
      LET g_sr[I].ds_total = g_ima.avl_stk_mpsmrp                         #FUN-A20044
   END FOR
 
   #顯示單身筆數
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION q025_bp(p_ud)
   DEFINE   p_ud   VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sr TO s_sr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()
 
      ON ACTION first
         CALL q025_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY
 
      ON ACTION previous
         CALL q025_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL q025_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL q025_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL q025_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      #No.FUN-830076 add 08/03/21 --begin
      ON ACTION related_document   #相關文件
         LET g_action_choice = "related_document"
         EXIT DISPLAY
      #No.FUN-830076 add 08/03/21 --end
 
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
#No.FUN-7B0018 Create this program
