# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp470.4gl
# Descriptions...: 工單整批請購作業
# Date & Author..: 94/08/26 By Apple
# Modify.........: No.9729 04/05/13 By Wiky 在單頭轉單身後，選 2 輸入工單單號，
#                                           在 p470_w 視窗，若轉請購單為 0 者，
#                                           不應再帶出至請購單單身。
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4B0224 修改單身入庫日，卻未更新回apmt420單身交貨日．
# Modify.........: No.FUN-560084 05/06/18 By Carrier 雙單位內容修改
# Modify.........: No.MOD-5C0100 05/12/20 By Nicola 按取消時，不產生任何單身
# Modify.........: No.MOD-5B0082 05/12/20 By Pengu 本次需求量未考慮結案否
# Modify.........: No.MOD-610098 06/04/03 By pengu apmp470一連串供需計算，全部沒有考慮單位換算
# Modify.........: No.MOD-610038 06/04/03 By pengu 新增請購以(2)工單需求整批產生時,若「備料來源碼」QBE條件為P,
                                   #               則會顯示mfg2601無合乎的條件,無法找出來源碼P的下階料
# Modify.........: No.MOD-640191 06/04/09 By Mandy 預設統購否pml190抓ima913
# Modify.........: No.TQC-640132 06/04/18 By Nicola 日期調整
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.MOD-670049 06/07/11 By Tracy 在GROUP BY中增加一個欄位
# Modify.........: No.FUN-670051 06/07/13 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-690047 06/09/28 By Sarah pml38預設等於pmk45
# Modify.........: No.TQC-6A0011 06/10/12 By Mandy MOD-640191修正有筆誤
# Modify.........: NO.CHI-6A0016 06/10/27 BY yiting pml190/pml191/pml192需有預設值
# Modify.........: No.TQC-6B0124 06/12/19 By pengu 參數勾選不使用多單位但使用計價單位時，計價單位與計價數量會異常
#Modify.........: No.FUN-710030 07/02/07 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-6B0018 07/03/05 By pengu 由工單展至單身時,到庫日期運算不正確
# Modify.........: No.MOD-6B0157 07/03/05 By pengu 1.本次需求量未換算為庫存單位
#                                                  2.建議量應換算採購單位非生產單位
#                                                  3.在畫面新增"請購單位"與"換算率"欄位
# Modify.........: No.MOD-740471 07/04/25 By claire sfb25要加入key值,否則會造成apm_p470寫入時重複值的問題
# Modify.........: No.MOD-780156 07/08/20 By kim _b_fill()加作做_qty()
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-830165 08/03/20 By Dido  增加委外代買量為 0 條件
# Modify.........: No.MOD-840671 08/04/28 By claire pml18給預設值,否則值會為1899/12/31
# Modify.........: No.MOD-840364 08/04/28 By Pengu 調整日期
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-870161 08/07/18 By chenmoyan 給pml25來源項次賦空值
# Modify.........: No.FUN-870124 08/07/31 By jan 服飾作業功能完善
# Modify.........: No.FUN-880072 08/08/19 By jan 服飾作業過單
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-8B0293 08/11/28 By Smapmin 料件的入庫前置期與到廠前置期未抓取,導致到廠日與交貨日不正確
# Modify.........: No.MOD-950200 09/05/27 By Smapmin 計算請/採購數量時,要將簽核中的單據納入
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980136 09/08/19 By Smapmin pml91為空時,要給一個空白
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun 流通零售修改
# Modify.........: No.MOD-980213 09/08/28 By Dido 單身專案預設請購單頭專案代號
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0023 09/11/02 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No:FUN-9C0071 09/12/15 By huangrh 精簡程式  
# Modify.........: No:TQC-A30022 10/03/05 By lilingyu 在檢量欄位計算公式變更
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:MOD-A50021 10/05/07 By Smapmin sfb25-->sfb13
# Modify.........: No:MOD-A50029 10/05/07 By Smapmin sfb13要加入key值,否則會造成抓取apm_p470時抓到重複值
# Modify.........: No:MOD-AA0075 10/10/14 By sabrina 在驗量的公式應與saimq102一致
# Modify.........: No:FUN-AB0030 10/11/08 By lilingyu 調整工單轉請購的處理邏輯
# Modify.........: No:TQC-AB0397 10/11/30 By wangxin 給pml91默認值
# Modify.........: No.FUN-B30219 11/04/06 By chenmoyan 去除DUAL
# Modify.........: No.FUN-910088 11/11/25 By chenjing  增加數量欄位小數取位
# Modify.........: No.MOD-C20227 12/02/28 By suncx 無論是否缺料，建議請購量都應該考慮安全庫存
# Modify.........: No.MOD-C20231 12/05/11 By Vampire 當已請購量<0，則已請購量視為0
# Modify.........: No.TQC-C50143 12/05/17 By zhuhao 開立狀態和作廢狀態的工單不要開立出來
# Modify.........: No.TQC-CC0119 13/01/29 By xuxz 產生請購單時候帶入來源單號

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_pml2          RECORD LIKE pml_file.*,
    g_pmk           RECORD LIKE pmk_file.*,
    g_pnl           RECORD LIKE pnl_file.*,
    g_pml           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
                    pml02       LIKE pml_file.pml02,   #行序
                    pml42       LIKE pml_file.pml42,   #特性
                    pml04       LIKE pml_file.pml04,   #料號
                    pml041      LIKE pml_file.pml041,  #品名規格
                    pml08       LIKE pml_file.pml08,   #庫存單位
                    req_qty     LIKE pml_file.pml20,   #本次需求量
                    ima27       LIKE pml_file.pml20,   #安全庫存
                    al_qty      LIKE pml_file.pml20,   #已備料量
#                    ima262      LIKE pml_file.pml20,   #庫存可用量 #FUN-A20044
                    avl_stk      LIKE type_file.num15_3,   #庫存可用量 #FUN-A20044
                    qc_qty      LIKE pml_file.pml20,   #檢驗量
                    po_qty      LIKE pml_file.pml20,   #採購量
                    pr_qty      LIKE pml_file.pml20,   #請購量
                    wo_qty      LIKE pml_file.pml20,   #工單量
                    sh_qty      LIKE pml_file.pml20,   #缺料量
                    pml07       LIKE pml_file.pml07,   #請購單位          # No.MOD-6B0157 add
                    pml09       LIKE pml_file.pml09,   #換算率(請購/庫存) # No.MOD-6B0157 add
                    su_qty      LIKE pml_file.pml20,   #建議量
                    pml35       LIKE pml_file.pml35    #入庫日期
                    END RECORD,
    g_pml_t         RECORD
                    pml02       LIKE pml_file.pml02,   #行序
                    pml42       LIKE pml_file.pml42,   #特性
                    pml04       LIKE pml_file.pml04,   #料號
                    pml041      LIKE pml_file.pml041,  #品名規格
                    pml08       LIKE pml_file.pml08,   #庫存單位
                    req_qty     LIKE pml_file.pml20,   #本次需求量
                    ima27       LIKE pml_file.pml20,   #安全庫存
                    al_qty      LIKE pml_file.pml20,   #已備料量
#                    ima262      LIKE pml_file.pml20,   #庫存可用量 #FUN-A20044
                    avl_stk      LIKE type_file.num15_3,   #庫存可用量 #FUN-A20044
                    qc_qty      LIKE pml_file.pml20,   #檢驗量
                    po_qty      LIKE pml_file.pml20,   #採購量
                    pr_qty      LIKE pml_file.pml20,   #請購量
                    wo_qty      LIKE pml_file.pml20,   #工單量
                    sh_qty      LIKE pml_file.pml20,   #缺料量
                    pml07       LIKE pml_file.pml07,   #請購單位          # No.MOD-6B0157 add
                    pml09       LIKE pml_file.pml09,   #換算率(請購/庫存) # No.MOD-6B0157 add
                    su_qty      LIKE pml_file.pml20,   #建議量
                    pml35       LIKE pml_file.pml35    #入庫日期
                    END RECORD,
              tm  RECORD	
                    wc      LIKE type_file.chr1000, #No.FUN-680136  VARCHAR(300)
#                   bdate   LIKE type_file.dat,     #No.FUN-680136  DATE    #FUN-AB0039
#                   sudate  LIKE type_file.dat,     #No.FUN-680136  DATE    #FUN-AB0039
                    abdate  LIKE type_file.dat,                             #FUN-AB0039
                    aedate  LIKE type_file.dat,                             #FUN-AB0039
                    sfcislk01 LIKE sfci_file.sfcislk01,  #No.FUN-870124
                    a       LIKE type_file.chr1,    #No.FUN-680136  VARCHAR(01)
                    b       LIKE type_file.chr1,    #No.FUN-680136  VARCHAR(01)
                    c       LIKE type_file.chr1,    #No.FUN-680136  VARCHAR(01)
                    d       LIKE type_file.chr1,    #No.FUN-680136  VARCHAR(01)
                    e       LIKE type_file.chr1,    #No.FUN-680136  VARCHAR(01)
                    f       LIKE type_file.chr1,    #No.FUN-680136  VARCHAR(01)
                    g       LIKE type_file.chr1     #No.FUN-680136  VARCHAR(01)
                    END RECORD,
       t_pml        RECORD LIKE pml_file.*,
       g_factor     LIKE img_file.img21,
       g_ima25      LIKE ima_file.ima25,
       g_ima44      LIKE ima_file.ima44,
       g_ima906     LIKE ima_file.ima906,
       g_ima907     LIKE ima_file.ima907,
       g_argv1             LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
       g_sw                LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
       g_wc,g_wc2,g_sql    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(300)
       g_seq           LIKE type_file.num5,        #No.FUN-680136 SMALLINT
       g_cnt           LIKE type_file.num10,       #No.FUN-680136 INTEGER
       g_rec_b         LIKE type_file.num5,        #No.FUN-680136 SMALLINT #單身筆數
       l_ac            LIKE type_file.num5,        #No.FUN-680136 SMALLINT #目前處理的ARRAY CNT
       p_row,p_col     LIKE type_file.num5         #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_where      STRING                   #No.FUN-870124
DEFINE g_sfcislk01  LIKE type_file.chr1000   #No.FUN-870124
DEFINE g_abdate     LIKE type_file.dat       #FUN-AB0030
DEFINE g_aedate     LIKE type_file.dat       #FUN-AB0030
 
FUNCTION p470(p_argv1,p_argv2)
   DEFINE l_time     LIKE type_file.chr8,    #No.FUN-680136 VARCHAR(8)
          l_sql      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
          p_argv1    LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01) #類別
          p_argv2    LIKE pmm_file.pmm01,    #請購單號
          l_pnl01    LIKE pnl_file.pnl01,
          l_wo       LIKE sfa_file.sfa01,    #請購單號
          l_part     LIKE sfa_file.sfa03     #請購單號
 
   WHENEVER ERROR CONTINUE
    IF p_argv2 IS NULL OR p_argv2 = ' ' THEN
       CALL cl_err(p_argv2,'mfg3527',0)
       RETURN
    END IF
    LET g_sw = 'Y'
    LET g_argv1      = p_argv1
    LET g_pmk.pmk01  = p_argv2
    DELETE FROM apm_p470
WHILE TRUE
    #-->條件畫面輸入
    IF p_argv1 = 'G' THEN
         IF g_sw != 'N' THEN
            LET p_row = 4 LET p_col = 27
            OPEN WINDOW p470_g AT p_row,p_col          #條件畫面
                   WITH FORM "apm/42f/apmp470_a"
               ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
            CALL cl_ui_locale("apmp470_a")
            IF NOT s_industry('slk') THEN
                CALL cl_set_comp_visible("sfcislk01",FALSE)
            END IF
         END IF
         CALL p470_tm()
         IF INT_FLAG THEN
            CLOSE WINDOW p470_g
            EXIT WHILE
         END IF
         #-->無符合條件資料
         IF g_sw = 'N' THEN
            CALL cl_err(g_pmk.pmk01,'mfg2601',0)
            CONTINUE WHILE
         END IF
         DELETE FROM pnl_file WHERE pnl01 = g_pmk.pmk01
         INSERT INTO pnl_file(pnl01,pnl02,pnl03,pnl04,pnl05,
                               pnl06,pnl07,pnl08,pnl09,pnl10,pnl11,pnluser,pnlplant,pnllegal,pnloriu,pnlorig)  #No.MOD-470041 #FUN-980006 add 
#                       VALUES(g_pmk.pmk01,g_wc,"",tm.sudate,   #No.TQC-640132  #FUN-AB0030
                        VALUES(g_pmk.pmk01,g_wc,tm.abdate,tm.aedate,            #FUN-AB0030
                              tm.a,tm.b,tm.c,tm.d,
                              tm.e,tm.f,tm.g,g_user,g_plant,g_legal, g_user, g_grup) #FUN-980006 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
#   ELSE SELECT pnl_file.* INTO l_pnl01,g_wc,tm.bdate,tm.sudate,   #No.TQC-640132 #FUN-AB0030
    ELSE SELECT pnl_file.* INTO l_pnl01,g_wc,tm.abdate,tm.aedate,                  #FUN-AB0030
                                tm.a,tm.b,tm.c,tm.d,
                                tm.e,tm.f,tm.g,g_user
                           FROM pnl_file WHERE pnl01 = g_pmk.pmk01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","pnl_file",g_pmk.pmk01,"","mfg3545","","",1)  #No.FUN-660129
            LET INT_FLAG = 1  EXIT WHILE
         END IF
         IF g_wc IS NULL OR g_wc = ' ' THEN LET g_wc = " 1=1 "  END IF
    END IF
    CALL cl_wait()
    CALL p470_g()
    #-->無符合條件資料
    IF g_sw = 'N' THEN
       CALL cl_err(g_pmk.pmk01,'mfg2601',0)
       CONTINUE WHILE
    END IF
    ERROR ""
    EXIT WHILE
 END WHILE
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CLOSE WINDOW p470_g
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW p470_w AT p_row,p_col
        WITH FORM "apm/42f/apmp470"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmp470")
 
    SELECT pmk02,pmk04 INTO g_pmk.pmk02,g_pmk.pmk04
                       FROM pmk_file
                      WHERE pmk01 = g_pmk.pmk01
    DISPLAY BY NAME g_pmk.pmk01
    DISPLAY BY NAME g_pmk.pmk02
    DISPLAY BY NAME g_pmk.pmk04
    CALL p470_b_fill("")
    CALL p470_b()
    CLOSE WINDOW p470_w
END FUNCTION
   
FUNCTION p470_tm()
 DEFINE  l_cnt       LIKE type_file.num5,    #No.FUN-680136 SMALLINT,
         l_wobdate   LIKE type_file.dat,     #No.FUN-680136 DATE
         l_woedate   LIKE type_file.dat,     #No.FUN-680136 DATE
         l_sql       LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(400)
         l_where     LIKE type_file.chr1000, #No.FUN-870124
         l_n         LIKE type_file.num5     #No.FUN-870124
 
    INPUT BY NAME tm.sfcislk01
    AFTER FIELD sfcislk01
      IF cl_null(tm.sfcislk01) THEN NEXT FIELD sfcislk01 END IF 
      LET l_n = 0                                                                                                                 
      LET g_where = tm.sfcislk01                                                                                                    
#     SELECT REPLACE(tm.sfcislk01,"|","','") INTO l_where FROM dual #FUN-B30219 mark                                                                
      LET l_where = cl_replace_str(tm.sfcislk01,"|","','")          #FUN-B30219
     
      LET l_where = "('",l_where,"')"                                                                                               
      LET l_sql = "SELECT COUNT(*) FROM sfci_file WHERE sfcislk01 IN ",l_where                                                      
      PREPARE p_tm FROM l_sql                                                                                                       
      DECLARE p_cur CURSOR FOR p_tm                                                                                                 
      OPEN p_cur                                                                                                                    
      FETCH p_cur INTO l_n                                                                                                        
      CLOSE p_cur                                                                                                                   
      IF l_n <= 0 THEN                                                                                                            
        CALL cl_err('','apm1018',0)                                                                                                 
        NEXT FIELD sfcislk01                                                                                                        
      END IF 
      LET g_sfcislk01 = l_where
      ON ACTION controlp
             CASE
               WHEN INFIELD(sfcislk01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_oebislk01"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    LET tm.sfcislk01 = g_qryparam.multiret
                    DISPLAY tm.sfcislk01 TO sfcislk01
                    NEXT FIELD sfcislk01
               OTHERWISE EXIT CASE
             END CASE
       IF INT_FLAG THEN RETURN END IF                                                                                                  
    END INPUT
    CONSTRUCT BY NAME g_wc ON sfb01,sfb13,ima06,ima08        #No.FUN-870124 
    BEFORE  CONSTRUCT
       CALL cl_qbe_init()
    ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sfb01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_sfb"
                    LET g_qryparam.where = " sfb87 = 'Y' "       #TQC-C50143 add
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfb01
                    NEXT FIELD sfb01
               OTHERWISE EXIT CASE
             END CASE
    ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT 
  
    ON ACTION about      
       CALL cl_about()     
 
    ON ACTION controlg      
       CALL cl_cmdask()    
 
    ON ACTION help         
       CALL cl_show_help()
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
    CALL cl_wait()
    
#FUN-AB0030 --mark    
#    #-->讀取工單最早開工日期/最晚開工日期
#  IF s_industry('slk') THEN
#    LET l_sql = "SELECT min(sfb13),max(sfb13) ",
#                "  FROM sfb_file,ima_file,sfa_file,sfci_file ",  #No.FUN-870124
#                " WHERE sfb01 = sfa01 ",
#                "   AND sfa03 = ima01 ",
#                "   AND sfci01 = sfb85 ",  #No.FUN-870124
#                "   AND sfb87!='X' ", 
#                "   AND sfcislk01 IN ",g_sfcislk01," and ",g_wc CLIPPED
# 
#  ELSE
#    LET l_sql = "SELECT min(sfb13),max(sfb13) ",
#                "  FROM sfb_file,ima_file,sfa_file ",  
#                " WHERE sfb01 = sfa01 ",
#                "   AND sfa03 = ima01 ",
#                "   AND sfb87!='X' AND ", g_wc CLIPPED
#  END IF
# 
#    PREPARE p470_predate  FROM l_sql
#    DECLARE p470_curdate CURSOR FOR p470_predate
#    LET g_sw = 'Y'
#    FOREACH p470_curdate INTO l_wobdate,l_woedate
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('p470_curdate',SQLCA.sqlcode,0)
#           EXIT FOREACH
#        END IF
#        IF (l_wobdate IS NULL OR l_wobdate = ' ') AND
#           (l_woedate IS NULL OR l_woedate = ' ')
#        THEN LET g_sw = 'N'
#             EXIT FOREACH
#        END IF
#    END FOREACH
#    
#    IF g_sw = 'N' THEN RETURN END IF
#    ERROR ""
#FUN-AB0030 --mark--    

   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 'Y'     LET tm.b = 'Y'
   LET tm.c = 'Y'     LET tm.d = 'Y'
   LET tm.e = 'Y'     LET tm.f = 'Y'
   LET tm.g = 'Y'
#  LET tm.sudate = l_woedate   #FUN-AB0030

#   INPUT BY NAME tm.sudate,tm.a,tm.b,tm.c,   #No.TQC-640132   #FUN-AB0030
    INPUT BY NAME tm.abdate,tm.aedate,tm.a,tm.b,tm.c,          #FUN-AB0030
                  tm.d,tm.e,tm.f,tm.g
                  WITHOUT DEFAULTS HELP 1

#FUN-AB0030 --begin--
#      AFTER FIELD sudate    #工單範圍中最晚開工日期前一天
#         IF tm.sudate IS NULL OR tm.sudate = ' ' THEN
#            NEXT FIELD sudate
#         END IF
      AFTER FIELD abdate
          IF tm.abdate IS NULL OR tm.abdate = ' ' THEN 
             CALL cl_err('','aws-155',0)
             NEXT FIELD CURRENT 
          END IF 
      AFTER FIELD aedate
          IF tm.aedate IS NULL OR tm.aedate = ' ' THEN 
             CALL cl_err('','aws-155',0)
             NEXT FIELD CURRENT 
          END IF           
#FUN-AB0030 --end--
         
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES'[YN]'
         THEN NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b IS NULL OR tm.b NOT MATCHES'[YN]'
         THEN NEXT FIELD b
         END IF
      AFTER FIELD c
         IF tm.c IS NULL OR tm.c NOT MATCHES'[YN]'
         THEN NEXT FIELD c
         END IF
      AFTER FIELD d
         IF tm.d IS NULL OR tm.d NOT MATCHES'[YN]'
         THEN NEXT FIELD d
         END IF
      AFTER FIELD e
         IF tm.e IS NULL OR tm.e NOT MATCHES'[YN]'
         THEN NEXT FIELD e
         END IF
      AFTER FIELD f
         IF tm.f IS NULL OR tm.f NOT MATCHES'[YN]'
         THEN NEXT FIELD f
         END IF
      AFTER FIELD g
         IF tm.g IS NULL OR tm.g NOT MATCHES'[YN]'
         THEN NEXT FIELD g
         END IF
 
        ON KEY(CONTROL-G)
            CALL cl_cmdask()
        
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
        AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
#FUN-AB0030 --begin--          
#          IF tm.sudate IS NULL AND tm.sudate = ' ' THEN 
#            NEXT FIELD sudate
#          END IF
          IF tm.abdate IS NULL OR tm.abdate = ' ' THEN 
             NEXT FIELD abdate 
          END IF 
          IF tm.aedate IS NULL OR tm.aedate = ' ' THEN 
             NEXT FIELD aedate
          END IF   
#FUN-AB0030 --end--          
          IF INT_FLAG THEN EXIT INPUT END IF
   END INPUT

#FUN-AB0030 --begin
    #-->讀取工單最早開工日期/最晚開工日期
  IF s_industry('slk') THEN
    LET l_sql = "SELECT min(sfb13),max(sfb13) ",
                "  FROM sfb_file,ima_file,sfa_file,sfci_file ",  #No.FUN-870124
                " WHERE sfb01 = sfa01 ",
                "   AND sfa03 = ima01 ",
                "   AND sfci01 = sfb85 ",  #No.FUN-870124
               #"   AND sfb87!='X' ",      #TQC-C50143 mark
                "   AND sfb87 ='Y' ",      #TQC-C50143 add
                "  AND sfb13 BETWEEN '",tm.abdate,"' AND '",tm.aedate,"'",  #FUN-AB0030                
                "   AND sfcislk01 IN ",g_sfcislk01," and ",g_wc CLIPPED
 
  ELSE
    LET l_sql = "SELECT min(sfb13),max(sfb13) ",
                "  FROM sfb_file,ima_file,sfa_file ",  
                " WHERE sfb01 = sfa01 ",
                "   AND sfa03 = ima01 ",
                "  AND sfb13 BETWEEN '",tm.abdate,"' AND '",tm.aedate,"'",  #FUN-AB0030                
               #"   AND sfb87!='X' AND ", g_wc CLIPPED   #TQC-C50143 mark
                "   AND sfb87 ='Y' AND ", g_wc CLIPPED   #TQC-C50143 add
  END IF
 
    PREPARE p470_predate  FROM l_sql
    DECLARE p470_curdate CURSOR FOR p470_predate
    LET g_sw = 'Y'
    FOREACH p470_curdate INTO l_wobdate,l_woedate
        IF SQLCA.sqlcode THEN
           CALL cl_err('p470_curdate',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
        IF (l_wobdate IS NULL OR l_wobdate = ' ') AND
           (l_woedate IS NULL OR l_woedate = ' ')
        THEN LET g_sw = 'N'
             EXIT FOREACH
        END IF
    END FOREACH
    
    IF g_sw = 'N' THEN RETURN END IF
    ERROR ""
    LET g_abdate = l_wobdate   
    LET g_aedate = l_woedate   
#FUN-AB0030 ----      

   IF INT_FLAG THEN RETURN END IF
END FUNCTION
   
FUNCTION p470_cur()
  DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(600)
 
    #--->讀取備料量(應發量-已發量)
     LET l_sql = " SELECT sum((sfa05-sfa06-sfa065)*sfa13) ",    #No.MOD-610098 modify
                 " FROM sfa_file,sfb_file",   
                 " WHERE sfa03 = ? ",
                 "   AND sfa01 = sfb01 ",
                 "   AND sfb04 != '8' ",
       #         "   AND sfb02 != '2' AND sfb02 != '11' AND sfb87!='X' ",    #TQC-C50143 mark
                 "   AND sfb02 != '2' AND sfb02 != '11' AND sfb87 ='Y' ",    #TQC-C50143 add
       #         "   AND sfb13 <='",tm.sudate,"'"    #FUN-AB0030
                 "   AND sfb13 <='",tm.aedate,"'"    #FUN-AB0030        
     PREPARE p470_presfa  FROM l_sql
     DECLARE p470_cssfa  CURSOR WITH HOLD FOR p470_presfa
 
    #--->讀取獨立性需求量(工單最晚完工日)
     LET l_sql = " SELECT sum((rpc13-rpc131)*rpc16_fac) ",  #No:8531 #No.MOD-610098 modify
                 "   FROM rpc_file WHERE rpc01 = ? ",
#                "    AND rpc12 <='",tm.sudate,"'"   #FUN-AB0030
                 "    AND rpc12 <='",tm.aedate,"'"   #FUN-AB0030 
     PREPARE p470_prerpc  FROM l_sql
     DECLARE p470_csrpc  CURSOR WITH HOLD FOR p470_prerpc
 
    #--->讀取請購量(請購量-已轉採購量)(日期區間)
     LET l_sql = " SELECT sum((pml20-pml21)*pml09) FROM pml_file,pmk_file ",   #NO.MOD-610098 maoify
                 " WHERE pmk01=pml01 AND pmk18 != 'X' ",
                 "   AND pml04 = ? ",
                 "   AND (pml16 < '6' OR pml16 = 'S' OR pml16 = 'R' OR pml16 = 'W') ",   #MOD-950200 add
                 "   AND (pml011 = 'REG' OR pml011 = 'IPO') ",
                 "   AND pml01 != '",g_pmk.pmk01,"'",
#                "   AND pml35 <= '",tm.sudate,"'"   #FUN-AB0030
                 "   AND pml35 <= '",tm.aedate,"'"   #FUN-AB0030 
 
     PREPARE p470_prepml  FROM l_sql
     DECLARE p470_cspml  CURSOR WITH HOLD FOR p470_prepml
 
    #--->讀取採購量(採購量-已交量)/檢驗量(pmn51)(日期區間)
     LET l_sql = " SELECT sum(((pmn20-(pmn50-pmn55))/pmn62)*pmn09) ",   #No.MOD-610098 modify
                 "   FROM pmn_file,pmm_file ",
                 "  WHERE pmm01=pmn01 AND pmm18 != 'X' ",
                 "    AND pmn61 = ? ",
                 "    AND (pmn16 < '6' OR pmn16 = 'S' OR pmn16 = 'R' OR pmn16 = 'W') ",   #MOD-950200 add
                 "    AND (pmn011 = 'REG' OR pmn011 = 'IPO') ",
                 "    AND (pmn20-(pmn50-pmn55)) > 0 ",
#                "    AND pmn35 <= '",tm.sudate,"'"    #FUN-AB0030
                 "    AND pmn35 <= '",tm.aedate,"'"    #FUN-AB0030

     PREPARE p470_prepmn  FROM l_sql
     DECLARE p470_cspmn  CURSOR WITH HOLD FOR p470_prepmn
 
 
    #--->讀取在驗量(rvb_file)不考慮日期
    #LET l_sql = " SELECT sum((rvb31)*pmn09) ",     #No.MOD-610098 modify   #TQC-A30022
     LET l_sql = " SELECT sum((rvb07-rvb29-rvb30)*pmn09) ",                 #TQC-A30022
                 "   FROM rvb_file,rva_file,pmn_file   ",   #No.MOD-610098 modify
                 "  WHERE rva01=rvb01 AND rvaconf = 'Y' ",
                 "   AND rvb04=pmn01 ",      #No.MOD-610098 modify
                 "   AND rvb03=pmn02 ",      #No.MOD-610098 modify
                 "   AND rva10 = 'SUB' ",    #MOD-AA0075 add
                 "   AND rvb07 > (rvb29+rvb30) ",   #MOD-AA0075 add
                 "    AND rvb05 = ?  "
     PREPARE p470_prervb FROM l_sql
     DECLARE p470_csrvb  CURSOR WITH HOLD FOR p470_prervb
 
    #--->讀取工單量(生產數量-入庫量-報廢量)(日期區間)
     LET l_sql = " SELECT sum((sfb08-sfb09-sfb12)*ima55_fac) ",  #No.MOD-610098 modify
                 "   FROM sfb_file,ima_file ", #No.MOD-610098 modify
                 "  WHERE sfb05 = ? ",
                 "    AND ima01=sfb05 ",       #No.MOD-610098 modify
                 "    AND sfb04 != '8' ",
                #"    AND sfb02 != '2' AND sfb02 != '11' AND sfb87!='X' ",     #TQC-C50143 mark
                 "    AND sfb02 != '2' AND sfb02 != '11' AND sfb87 ='Y' ",     #TQC-C50143 add
#                "    AND sfb15 <= '",tm.sudate,"'"   #FUN-AB0030 
                 "    AND sfb15 <= '",tm.aedate,"'"   #FUN-AB0030 
     PREPARE p470_p_sfb  FROM l_sql
     DECLARE p470_c_sfb  CURSOR WITH HOLD FOR p470_p_sfb
END FUNCTION
   
FUNCTION p470_g()
  DEFINE  l_sql      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(600)
          l_sfa03    LIKE sfa_file.sfa03,
          l_sfa01    LIKE sfa_file.sfa01, #TQC-CC0119 add
          l_sfa26    LIKE sfa_file.sfa26,
#         l_sfb13    LIKE sfb_file.sfb13,    #No.TQC-640132   #MOD-A50021   sfb25-->sfb13 #FUN-AB0030 mark
          req_qty    LIKE pml_file.pml20,
          al_qty     LIKE pml_file.pml20,
          rpc_qty    LIKE pml_file.pml20,
          pr_qty     LIKE pml_file.pml20,
          po_qty     LIKE pml_file.pml20,
          qc_qty     LIKE pml_file.pml20,
          wo_qty     LIKE pml_file.pml20,
          su_qty     LIKE pml_file.pml20,
          sh_qty     LIKE pml_file.pml20,
#          l_ima262   LIKE ima_file.ima262, #FUN-A20044
          l_avl_stk   LIKE type_file.num15_3, #FUN-A20044
          l_ima27    LIKE ima_file.ima27,
          l_ima45    LIKE ima_file.ima45,
          l_ima46    LIKE ima_file.ima46,
          l_supply   LIKE pml_file.pml20,
          l_pan      LIKE type_file.num10,   #No.FUN-680136 INTEGER
          l_double   LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE    l_aedate   LIKE type_file.dat      #FUN-AB0030
 
    #-->料件/替代碼/本次需求量
  IF s_industry('slk') THEN
#   LET l_sql = "SELECT UNIQUE sfa03,sfa26,sfb13,sum((sfa05-sfa06-sfa065)*sfa13) ",      #MOD-A50021 sfb25-->sfb13  #FUN-AB0030
  # LET l_sql = "SELECT UNIQUE sfa03,sfa26,sum((sfa05-sfa06-sfa065)*sfa13) ",     #FUN-AB0030#TQC-CC0119 mark 
    LET l_sql = "SELECT UNIQUE sfa01,sfa03,sfa26,sum((sfa05-sfa06-sfa065)*sfa13) ",#TQC-CC0119 add 
                "  FROM sfa_file,sfb_file,ima_file,sfci_file",   #No.FUN-870124 add sfci_file
                " WHERE sfa01 = sfb01 ",
                "  AND sfb04 != '8' ",  #No.MOD-5B0082 add
               #"  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87!='X' ",      #TQC-C50143 mark
                "  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87 ='Y' ",      #TQC-C50143 add
                "  AND sfa065 = 0 ", 
                "  AND sfci01 = sfb85 ",   #No.FUN-870124
                "  AND sfa03 = ima01 ", 
                "  AND sfb13 BETWEEN '",tm.abdate,"' AND '",tm.aedate,"'",  #FUN-AB0030
                "   AND sfcislk01 IN ",g_sfcislk01," and ",g_wc CLIPPED,
#               " GROUP BY sfa03,sfa26,sfb13",   #MOD-A50021 sfb25-->sfb13   #FUN-AB0030
               #" GROUP BY sfa03,sfa26",                                     #FUN-AB0030  #TQC-CC0119 mark 
                " GROUP BY sfa01,sfa03,sfa26",  #TQC-CC0119 add
#               " ORDER BY 1,2,3"                                            #FUN-AB0039
                " ORDER BY 1,2"                                              #FUN-AB0039 
  ELSE
#    LET l_sql = "SELECT UNIQUE sfa03,sfa26,sfb13,sum((sfa05-sfa06-sfa065)*sfa13) ",      #MOD-A50021 sfb25-->sfb13 #FUN-AB0030
    #LET l_sql = "SELECT UNIQUE sfa03,sfa26,sum((sfa05-sfa06-sfa065)*sfa13) ",        #FUN-AB0030#TQC-CC0119 mark 
     LET l_sql = "SELECT UNIQUE sfa01,sfa03,sfa26,sum((sfa05-sfa06-sfa065)*sfa13) ",#TQC-CC0119 add 
                "  FROM sfa_file,sfb_file,ima_file",
                " WHERE sfa01 = sfb01 ",
                "   AND sfb04 != '8' ",  #No.MOD-5B0082 add
               #"  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87!='X' ",      #TQC-C50143 mark
                "  AND sfb02 != '2'  AND sfb02 != '11' AND sfb87 ='Y' ",      #TQC-C50143 add
                "  AND sfa065 = 0 ",                     #MOD-830165
                "  AND sfb13 BETWEEN '",tm.abdate,"' AND '",tm.aedate,"'",  #FUN-AB0030                
                "   AND sfa03 = ima01 AND ", g_wc CLIPPED,
#                " GROUP BY sfa03,sfa26,sfb13",   #No.MOD-670049  add sfb25      #MOD-A50021 sfb25-->sfb13  #FUN-AB0030
#                " ORDER BY 1,2,3"                #MOD-740471 add 3                                         #FUN-AB0030
                #" GROUP BY sfa03,sfa26",                     #FUN-AB0030#TQC-CC0119 mark 
                " GROUP BY sfa01,sfa03,sfa26",  #TQC-CC0119 add
                 " ORDER BY 1,2"                              #FUN-AB0030
  END IF    #No.FUN-870124
    PREPARE p470_prepare FROM l_sql
    DECLARE p470_cs                         #CURSOR
        CURSOR WITH HOLD FOR p470_prepare
    #-->相關數量讀取
    CALL p470_cur()
    #-->請購單身預設值
    IF g_argv1 = 'G' THEN
       CALL p470_pmlini()
       SELECT max(pml02)+1 INTO g_seq FROM pml_file WHERE pml01 = g_pmk.pmk01
       IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0
       THEN LET g_seq = 1
       END IF
    END IF
    LET g_sw = 'N'
    LET g_success = 'Y'
    BEGIN WORK
    CALL s_showmsg_init()        #No.FUN-710030
#   FOREACH p470_cs INTO l_sfa03,l_sfa26,l_sfb13,req_qty  #No.TQC-640132     #MOD-A50021 sfb25-->sfb13 #FUN-AB0030
   #FOREACH p470_cs INTO l_sfa03,l_sfa26,req_qty   #FUN-AB0030#TQC-CC0119 mark
    FOREACH p470_cs INTO l_sfa01,l_sfa03,l_sfa26,req_qty  #TQC-CC0119 add
       IF SQLCA.sqlcode THEN
         LET g_success = 'N'  #No.FUN-8A0086
         IF g_bgerr THEN
             CALL s_errmsg("","","p470_cs",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_cs",0)
         END IF
          EXIT FOREACH
       END IF
       LET g_sw = 'Y'
          #--->產生備料數量
          OPEN p470_cssfa USING l_sfa03
          IF SQLCA.sqlcode THEN
          IF g_bgerr THEN
             CALL s_errmsg("","","p470_cssfa",SQLCA.sqlcode,1)
             CONTINUE FOREACH
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_cssfa",0)
             EXIT FOREACH
          END IF
          END IF
          FETCH p470_cssfa INTO al_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_cssfa",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_cssfa",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生獨立性數量
          OPEN p470_csrpc USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_csrpc",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_csrpc",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p470_csrpc INTO rpc_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_csrpc",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_csrpc",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生請購數量
          OPEN p470_cspml USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_cspml",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_cspml",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p470_cspml INTO pr_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_cspml",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_cspml",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生採購數量
          OPEN p470_cspmn USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_cspmn",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_cspmn",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p470_cspmn INTO po_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_cspmn",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_cspmn",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生採購檢驗量
          OPEN p470_csrvb  USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_csrvb",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_csrvb",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p470_csrvb INTO qc_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_csrvb",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_csrvb",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生工單數量
          OPEN p470_c_sfb USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_c_sfb",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_c_sfb",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p470_c_sfb INTO wo_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p470_c_sfb",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p470_c_sfb",0)
                EXIT FOREACH
             END IF
          END IF
          IF req_qty IS NULL OR req_qty = ' ' THEN LET req_qty = 0 END IF
          IF al_qty  IS NULL OR al_qty = ' '  THEN LET al_qty = 0  END IF
          IF rpc_qty IS NULL OR rpc_qty = ' ' THEN LET rpc_qty = 0 END IF
          IF pr_qty  IS NULL OR pr_qty = ' '  THEN LET pr_qty = 0  END IF
          IF po_qty  IS NULL OR po_qty = ' '  THEN LET po_qty = 0  END IF
          IF qc_qty  IS NULL OR qc_qty = ' '  THEN LET qc_qty = 0  END IF
          IF wo_qty  IS NULL OR wo_qty = ' '  THEN LET wo_qty = 0  END IF
          LET al_qty = (al_qty + rpc_qty) - req_qty
          LET l_aedate = tm.aedate       #FUN-AB0030
#         INSERT INTO apm_p470 VALUES(l_sfa03,l_sfa26,l_sfb13,req_qty,al_qty,   #MOD-740471 modify sfb25   #MOD-A50021 sfb25-->sfb13 #FUN-AB0030
          INSERT INTO apm_p470 VALUES(l_sfa03,l_sfa01,l_sfa26,l_aedate,req_qty,al_qty,    #FUN-AB0030  #add sfa01 by sx21426
                                      pr_qty,po_qty,qc_qty,wo_qty)
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             IF g_bgerr THEN
                CALL s_errmsg("sfa03",l_sfa03,"insert",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("ins","apm_p470",l_sfa03,"",SQLCA.sqlcode,"","insert",0)
                EXIT FOREACH
             END IF
          END IF
          IF g_argv1 = 'G' THEN
             #--->產生請購單身檔
             IF NOT s_industry('slk') THEN
                LET g_where = NULL
             END IF
#            CALL p470_ins_pml(l_sfa03,l_sfa26,l_sfb13,req_qty,qc_qty, #No.TQC-640132   #MOD-A50021 sfb25-->sfb13 #FUN-AB0030
            #CALL p470_ins_pml(l_sfa03,l_sfa26,g_abdate,req_qty,qc_qty,      #FUN-AB0030#TQC-CC0119 mark
             CALL p470_ins_pml(l_sfa01,l_sfa03,l_sfa26,g_abdate,req_qty,qc_qty,#TQC-CC0119 add
                               po_qty,pr_qty,wo_qty,al_qty,g_where)  #No.FUN-870124
             IF g_success = 'N' THEN EXIT FOREACH END IF
          END IF
    END FOREACH	
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
 
    CALL s_showmsg()       #No.FUN-710030
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
   
FUNCTION p470_b()
DEFINE
    l_str           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(80)
    l_sum           LIKE pml_file.pml20,
    l_ac_t          LIKE type_file.num5,    #No.FUN-680136 SMALLINT #未取消的ARRAY CNT
    l_n,l_k         LIKE type_file.num5,    #No.FUN-680136 SMALLINT #檢查重複用
    l_modify_flag   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  #單身更改否
    l_lock_sw       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  #單身鎖住否
    p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  #處理狀態
    l_ima55     LIKE ima_file.ima55,
    l_ima49     LIKE ima_file.ima49,        #MOD-4B0224
    l_ima491    LIKE ima_file.ima491,       #MOD-4B0224
    l_pml33     LIKE pml_file.pml33,        #MOD-4B0224
    l_pml34     LIKE pml_file.pml34,        #MOD-4B0224
    l_factor    LIKE ima_file.ima31_fac,    #No.FUN-680136 DEC(16,8)
    l_flag      LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(01)
    l_pml07     LIKE pml_file.pml07,        #No.FUN-680136 VARCHAR(04)
    l_insert    LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01) #可新增否
    l_update    LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01) #可更改否 (含取消)
    l_jump      LIKE type_file.num5         #No.FUN-680136 SMALLINT #判斷是否跳過AFTER ROW的處理
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pmk.pmk01 IS NULL OR g_pmk.pmk01 = ' '
    THEN RETURN
    END IF
    LET l_insert='Y'
    LET l_update='Y'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     "  SELECT pml02,pml42,pml04,pml041,pml08,0,0,0,0,0, ",
     "         0,0,0,0,pml07,pml09,pml20,pml35  ",
     "  FROM pml_file  ",
     "   WHERE pml01= ? ",
     "    AND pml02= ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p470_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
     LET l_ac_t = 0
     INPUT ARRAY g_pml WITHOUT DEFAULTS FROM s_pml.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
 
     BEFORE ROW
         LET p_cmd = ''
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_pml_t.* = g_pml[l_ac].*  #BACKUP
             OPEN p470_bcl USING g_pmk.pmk01,g_pml_t.pml02  #表示更改狀態
             IF STATUS THEN
                CALL cl_err("OPEN p470_bcl",STATUS,1)   #No.FUN-660129
                LET l_lock_sw = 'Y'
             ELSE
               FETCH p470_bcl INTO g_pml[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_pml_t.pml02,SQLCA.sqlcode,1)   #No.FUN-660129
                   LET l_lock_sw = "Y"
               END IF
             END IF
             CALL p470_qty(l_ac) #MOD-780156
             CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
     BEFORE DELETE                            #是否取消單身
         IF g_pml_t.pml02 > 0 AND
            g_pml_t.pml02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             DELETE FROM pml_file
                 WHERE pml01 = g_pmk.pmk01 AND
                       pml02 = g_pml_t.pml02
             IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pml_file",g_pmk.pmk01,g_pml_t.pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
             END IF
             IF NOT s_industry('std') THEN                                   
                IF NOT s_del_pmli(g_pmk.pmk01,g_pml_t.pml02,'') THEN              
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF                                                       
             END IF                                                          
         END IF
 
     ON ROW CHANGE
          IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_pml[l_ac].* = g_pml_t.*
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_pml[l_ac].pml02,-263,1)
             LET g_pml[l_ac].* = g_pml_t.*
          ELSE
            #畫面上已經增加"請購單位"與"換算率"，所以建議數量不須在乘上轉換率
            LET l_ima49 = ''
            LET l_ima491 = ''
            SELECT ima49,ima491 INTO l_ima49,l_ima491 FROM ima_file
              WHERE ima01 = g_pml[l_ac].pml04
             IF NOT cl_null(l_ima491) AND l_ima491 !=0 THEN
                CALL s_wkday3(g_pml[l_ac].pml35,l_ima491) RETURNING l_pml34
             ELSE
                 LET l_pml34 = g_pml[l_ac].pml35
             END IF
             LET l_pml33 = l_pml34 - l_ima49       #交貨日期
             SELECT * INTO t_pml.* FROM pml_file
              WHERE pml01=g_pmk.pmk01 AND pml02=g_pml_t.pml02
             SELECT ima25,ima44,ima906,ima907 
               INTO g_ima25,g_ima44,g_ima906,g_ima907
               FROM ima_file WHERE ima01=t_pml.pml04
             IF SQLCA.sqlcode =100 THEN                                                  
                IF t_pml.pml04 MATCHES 'MISC*' THEN                                
                   SELECT ima25,ima44,ima906,ima907 
                     INTO g_ima25,g_ima44,g_ima906,g_ima907                               
                     FROM ima_file WHERE ima01='MISC'                                    
                END IF                                                                   
             END IF                                                                      
             IF cl_null(g_ima44) THEN LET g_ima44 = g_ima25 END IF
             IF g_ima906 = '3' THEN
                LET g_factor = 1
                CALL s_umfchk(t_pml.pml04,t_pml.pml80,t_pml.pml83)
                     RETURNING g_cnt,g_factor
                IF g_cnt = 1 THEN
                   LET g_factor = 1
                END IF
                LET t_pml.pml85 = g_pml[l_ac].su_qty*g_factor
                LET t_pml.pml85 = s_digqty(t_pml.pml85,t_pml.pml83)    #FUN-910088--add--
             END IF
            #判斷若使用多單位時，單位一的數量default建議請購量
            #否則單位一數量不default任何值
             IF g_sma.sma115 = 'Y' THEN 
                LET t_pml.pml82 = g_pml[l_ac].su_qty
             ELSE 
                LET t_pml.pml82 = NULL
             END IF
            
             CALL p470_set_pml87(t_pml.pml04,t_pml.pml07,
                               t_pml.pml86,g_pml[l_ac].su_qty)
                               RETURNING t_pml.pml87
             LET t_pml.pml87 = s_digqty(t_pml.pml87,t_pml.pml86)    #FUN-910088--add--
             UPDATE pml_file SET pml20 = g_pml[l_ac].su_qty,
                                 pml82 = t_pml.pml82,        #No.TQC-6B0124 modify
                                 pml87 = t_pml.pml87,        #No.TQC-6B0124 modify 
                                 pml85 = t_pml.pml85,        #No.FUN-560084
                                 pml33 = l_pml33,  #MOD-4B0224
                                 pml34 = l_pml34,  #No.MOD-6B0018 add
                                 pml35 = g_pml[l_ac].pml35
                           WHERE CURRENT OF p470_bcl
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","pml_file",g_pmk.pmk01,g_pml_t.pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   LET g_pml[l_ac].* = g_pml_t.*
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
             IF p_cmd = 'u' THEN
                LET g_pml_t.* = g_pml[l_ac].*
             END IF
             CLOSE p470_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE p470_bcl
          COMMIT WORK
 
 
    AFTER INPUT
      IF INT_FLAG THEN EXIT INPUT END IF
 
     ON KEY(CONTROL-G)
      CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
     ON KEY(CONTROL-F)
       CASE
          WHEN INFIELD(pml02) CALL cl_fldhlp('pml02')
          WHEN INFIELD(pml04) CALL cl_fldhlp('pml04')
          OTHERWISE          CALL cl_fldhlp('    ')
       END CASE
   END INPUT
 
  CLOSE p470_bcl
  COMMIT WORK
  CALL p470_del_pml_file()  #No.9729
END FUNCTION
 
FUNCTION p470_del_pml_file()
   DEFINE l_pml20   LIKE pml_file.pml20
   DEFINE r,i,j     LIKE type_file.num10   #No.FUN-680136 INTEGER
   DEFINE l_pml02   DYNAMIC ARRAY OF LIKE pml_file.pml02 #No.FUN-870124
   DEFINE l_i       LIKE type_file.num5    #No.FUN-870124
 
   BEGIN WORK
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DELETE FROM pml_file
        WHERE pml01 = g_pmk.pmk01
      IF NOT s_industry('std') THEN                                   
         IF NOT s_del_pmli(g_pmk.pmk01,'','') THEN              
            ROLLBACK WORK
         END IF                                                       
      END IF         
   ELSE
    IF NOT s_industry('std') THEN                                   
    DECLARE pml_cury CURSOR FOR
      SELECT pml02 FROM pml_file
       WHERE pml01 = g_pmk.pmk01
         AND pml20 = 0
      LET l_i = 1
      FOREACH pml_cury INTO l_pml02[l_i]
         IF NOT s_del_pmli(g_pmk.pmk01,l_pml02[l_i],'') THEN              
            ROLLBACK WORK
         END IF                                                       
      LET l_i = l_i + 1
      END FOREACH
    END IF
      DELETE FROM pml_file
        WHERE pml01 = g_pmk.pmk01
          AND pml20 = 0
   END IF  
 
   IF SQLCA.SQLCODE THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
 
   #單身項次重排
   DECLARE p470_b_c CURSOR FOR SELECT pml02
                                 FROM pml_file 
                                WHERE pml01 = g_pmk.pmk01
                                ORDER BY pml02
 
   BEGIN WORK
 
   LET g_success = 'Y'
   LET i = 0
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH p470_b_c INTO j
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","foreach",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","foreach",1)
         END IF
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
 
      LET i = i + 1
 
      UPDATE pml_file SET pml02 = i
       WHERE pml01 = g_pmk.pmk01 AND pml02 = j
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("pml02",j,"upd pml02",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("upd","pml_file",j,"",SQLCA.sqlcode,"","upd pml02",1)
            EXIT FOREACH
         END IF
      END IF
   IF NOT s_industry('std') THEN
      UPDATE pmli_file SET pmli02 = i
       WHERE pmli01 = g_pmk.pmk01
         AND pmli02 = j
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("pmli01",g_pmk.pmk01,"upd pmli02",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("upd","pmli_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","upd pmli02",1)
            EXIT FOREACH
         END IF
      END IF
   END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
   CALL s_showmsg()       #No.FUN-710030
   IF g_success = 'Y' THEN
      COMMIT WORK 
   ELSE
      ROLLBACK WORK
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p470_qty(l_i) #MOD-780156
#   DEFINE l_ima262  LIKE ima_file.ima262, #FUN-A20044
   DEFINE l_avl_stk  LIKE type_file.num15_3, #FUN-A20044
          l_ima27   LIKE ima_file.ima27,
          l_req_qty LIKE pml_file.pml20,
          l_al_qty  LIKE pml_file.pml20,
          l_pr_qty  LIKE pml_file.pml20,
          l_po_qty  LIKE pml_file.pml20,
          l_qc_qty  LIKE pml_file.pml20,
          l_wo_qty  LIKE pml_file.pml20,
          l_supply  LIKE pml_file.pml20,
          l_demand  LIKE pml_file.pml20,
          l_avl_stk_mpsmrp LIKE type_file.num15_3, #FUN-A20044
          l_unavl_stk      LIKE type_file.num15_3, #FUN-A20044
          l_i       LIKE type_file.num5 #MOD-780156
   DEFINE l_pr_qty2 LIKE pml_file.pml20 #MOD-C20231 add
           
#   SELECT ima262,ima27 INTO l_ima262,l_ima27 FROM ima_file #FUN-A20044
   SELECT ima27 INTO l_ima27 FROM ima_file #FUN-A20044
    WHERE ima01 = g_pml[l_i].pml04
   CALL s_getstock(g_pml[l_i].pml04,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 
#   IF l_ima262 IS NULL OR l_ima262 = ' ' THEN
 #     LET l_ima262 = 0 
 #  END IF    #FUN-A20044
    IF l_avl_stk IS NULL OR l_avl_stk = ' ' THEN #FUN-A20044
       LET l_avl_stk = 0               #FUN-A20044
    END IF    #FUN-A20044
   IF l_ima27 IS NULL OR l_ima27 = ' ' THEN
      LET l_ima27 = 0
   END IF
 
#   LET g_pml[l_i].ima262 = l_ima262  #FUN-A20044
   LET g_pml[l_i].avl_stk = l_avl_stk  #FUN-A20044
   LET g_pml[l_i].ima27 = l_ima27
 
   SELECT req_qty,al_qty,pr_qty,po_qty,qc_qty,wo_qty
     INTO l_req_qty,l_al_qty,l_pr_qty,l_po_qty,l_qc_qty,l_wo_qty
     FROM apm_p470
    WHERE part = g_pml[l_i].pml04
#     AND sfb13 = g_pml[l_i].pml35   #MOD-A50029 #FUN-AB0030
      AND sfb13 >= g_pml[l_i].pml35           #FUN-AB0030
 
   IF l_req_qty IS NULL OR l_req_qty = ' ' THEN LET l_req_qty = 0 END IF
   IF l_al_qty  IS NULL OR l_al_qty = ' '  THEN LET l_al_qty = 0 END IF
   IF l_pr_qty  IS NULL OR l_pr_qty = ' '  THEN LET l_pr_qty = 0 END IF
   IF l_po_qty  IS NULL OR l_po_qty = ' '  THEN LET l_po_qty = 0 END IF
   IF l_qc_qty  IS NULL OR l_qc_qty = ' '  THEN LET l_qc_qty = 0 END IF
   IF l_wo_qty  IS NULL OR l_wo_qty = ' '  THEN LET l_wo_qty = 0 END IF
   LET g_pml[l_i].req_qty= l_req_qty
   LET g_pml[l_i].al_qty= l_al_qty
   LET g_pml[l_i].pr_qty= l_pr_qty
   LET g_pml[l_i].po_qty= l_po_qty
   LET g_pml[l_i].qc_qty= l_qc_qty
   LET g_pml[l_i].wo_qty= l_wo_qty
   #-->不包含現有庫存
#   IF tm.a = 'N' THEN LET g_pml[l_i].ima262 = 0 END IF #FUN-A20044
   IF tm.a = 'N' THEN LET g_pml[l_i].avl_stk = 0 END IF #FUN-A20044
   #-->不包含請購量
   IF tm.b = 'N' THEN LET g_pml[l_i].qc_qty = 0 END IF
   #-->不包含採購量
   IF tm.c = 'N' THEN LET g_pml[l_i].pr_qty = 0 END IF
   #-->不包含檢驗量
   IF tm.d = 'N' THEN LET g_pml[l_i].po_qty = 0 END IF
   #-->不包含工單量
   IF tm.e = 'N' THEN LET g_pml[l_i].wo_qty = 0 END IF
   #-->不包含已備料
   IF tm.f = 'N' THEN LET g_pml[l_i].al_qty = 0 END IF
   #MOD-C20231 ----- add strt -----
   IF g_pml[l_i].pr_qty < 0 THEN
      LET l_pr_qty2  = 0
   ELSE
      LET l_pr_qty2  = g_pml[l_i].pr_qty
   END IF
   #MOD-C20231 ----- add end -----
   #-->缺料量 = 本次需求- [ 庫存可用- 已備料量+ QC + PO + PR + WO]
#   LET l_supply= g_pml[l_i].ima262 + g_pml[l_i].qc_qty + #FUN-A20044
   LET l_supply= g_pml[l_i].avl_stk + g_pml[l_i].qc_qty + #FUN-A20044
                 #g_pml[l_i].po_qty + g_pml[l_i].pr_qty + #MOD-C20231 mark
                 g_pml[l_i].po_qty + l_pr_qty2 +  #MOD-C20231 add
                 g_pml[l_i].wo_qty
 
   #BugNo:4711     結餘量 = 供給     -  需求 #(若供給>需求應顯示正數,反之則負數)
   LET g_pml[l_i].sh_qty = l_supply - (g_pml[l_i].req_qty + g_pml[l_i].al_qty)
 
END FUNCTION
   
FUNCTION p470_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
       l_supply  LIKE pml_file.pml20,
       l_demand  LIKE pml_file.pml20
DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044 
DEFINE l_pr_qty2 LIKE pml_file.pml20 #MOD-C20231 add

    LET g_sql =
        "SELECT pml02,pml42,pml04,pml041,pml08,",
#        " req_qty,ima27,al_qty,ima262,qc_qty,po_qty, ", #FUN-A20044
        " req_qty,ima27,al_qty,0,qc_qty,po_qty, ", #FUN-A20044
        " pr_qty,wo_qty,0,pml07,pml09,pml20,pml35 ",
        " FROM  pml_file,OUTER ima_file,OUTER apm_p470 ",
        " WHERE pml_file.pml04 = ima_file.ima01", 
        "   AND pml_file.pml04 = apm_p470.part ",
#       "   AND pml_file.pml35 = apm_p470.sfb13 ",  #MOD-740471 add   #MOD-A50021 sfb25-->sfb13 #FUN-AB0030
        "   AND pml_file.pml35 <= apm_p470.sfb13 ",  #FUN-AB0030        
        "   AND pml01 = '",g_pmk.pmk01,"'"
 
    display g_sql[1,40]
    display g_sql[41,80]
    display g_sql[81,120]
    display g_sql[121,160]
    display g_sql[161,200]
    display g_sql[201,240]
 
    PREPARE p470_pb FROM g_sql
    display 'status = ',sqlca.sqlcode
    display 'sqlca.sqlcode = ',sqlca.sqlcode
    DECLARE pml_curs  CURSOR FOR p470_pb
    CALL g_pml.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH pml_curs INTO g_pml[g_cnt].*   #單身 ARRAY 填充
    CALL s_getstock(g_pml[g_cnt].pml04,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 
    LET g_pml[g_cnt].avl_stk = l_avl_stk #FUN-A20044
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #-->不包含現有庫存
#        IF tm.a = 'N' THEN LET g_pml[g_cnt].ima262 = 0 END IF #FUN-A20044
        IF tm.a = 'N' THEN LET g_pml[g_cnt].avl_stk = 0 END IF #FUN-A20044
        #-->不包含檢驗量
        IF tm.b = 'N' THEN LET g_pml[g_cnt].qc_qty = 0 END IF
        #-->不包含請購量
        IF tm.c = 'N' THEN LET g_pml[g_cnt].pr_qty = 0 END IF
        #-->不包含採購量
        IF tm.d = 'N' THEN LET g_pml[g_cnt].po_qty = 0 END IF
        #-->不包含工單量
        IF tm.e = 'N' THEN LET g_pml[g_cnt].wo_qty = 0 END IF
        #-->不包含已分配
        IF tm.f = 'N' THEN LET g_pml[g_cnt].al_qty = 0 END IF
        #-->不包含安全庫存
        IF tm.g = 'N' THEN LET g_pml[g_cnt].ima27  = 0 END IF
        #MOD-C20231 ----- add strt -----
        IF g_pml[g_cnt].pr_qty < 0 THEN
           LET l_pr_qty2  = 0
        ELSE
           LET l_pr_qty2  = g_pml[g_cnt].pr_qty
        END IF
        #MOD-C20231 ----- add end -----
        #-->缺料量 = 本次需求 + 已備料量 - [ 庫存可用 + QC + PO + PR + WO]
#        LET l_supply= g_pml[g_cnt].ima262 + g_pml[g_cnt].qc_qty + #FUN-A20044
        LET l_supply= g_pml[g_cnt].avl_stk + g_pml[g_cnt].qc_qty + #FUN-A20044
                      #g_pml[g_cnt].po_qty + g_pml[g_cnt].pr_qty + #MOD-C20231 mark
                      g_pml[g_cnt].po_qty + l_pr_qty2 +            #MOD-C20231 add
                      g_pml[g_cnt].wo_qty
        LET l_demand= g_pml[g_cnt].req_qty + g_pml[g_cnt].al_qty
       #BugNo:4711       結餘量 = 供給     - 需求 #(若供給>需求應顯示正數,反之則負數)
        LET g_pml[g_cnt].sh_qty = l_supply - l_demand
 
        CALL p470_qty(g_cnt) #MOD-780156
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pml.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    display 'g_rec_b=',g_rec_b
END FUNCTION
   
FUNCTION p470_pmlini()
 
   SELECT pmk02,pmk25,pmk45,pmk13,pmk05 
     INTO g_pmk.pmk02,g_pmk.pmk25,g_pmk.pmk45 ,g_pmk.pmk13,g_pmk.pmk05  #FUN-690047 #No.FUN-870124 add pmk13	#MOD-980213 add pmk05
     FROM pmk_file 
    WHERE pmk01 = g_pmk.pmk01
   LET g_pml2.pml01 = g_pmk.pmk01          
   LET g_pml2.pml011 =g_pmk.pmk02
   #LET g_pml2.pml12 = g_pmk.pmk05	#MOD-980213  #mark by guanyao160704
   LET g_pml2.pml16 = g_pmk.pmk25
   LET g_pml2.pml14 = g_sma.sma886[1,1]     
   LET g_pml2.pml15  =g_sma.sma886[2,2]
   LET g_pml2.pml23 = 'Y'                   
   LET g_pml2.pml38 = g_pmk.pmk45   #FUN-690047
   LET g_pml2.pml43 = 0                     
   LET g_pml2.pml431 = 0
   LET g_pml2.pml11 = 'N'                   
   LET g_pml2.pml13  = 0
   LET g_pml2.pml21  = 0                    
   LET g_pml2.pml16 = g_pmk.pmk25
   LET g_pml2.pml30 = 0                     
   LET g_pml2.pml32 = 0
   LET g_pml2.pml18 = ' '   #MOD-840671 add
END FUNCTION
   
#FUNCTION p470_ins_pml(p_sfa03,p_sfa26,p_sfb13,p_req_qty,p_qc_qty,p_po_qty,   #MOD-A50021 sfb25-->sfb13 #FUN-AB0030
#FUNCTION p470_ins_pml(p_sfa03,p_sfa26,p_abdate,p_req_qty,p_qc_qty,p_po_qty,    #FUN-AB0030#TQC-CC0119 mark
 FUNCTION p470_ins_pml(p_sfa01,p_sfa03,p_sfa26,p_abdate,p_req_qty,p_qc_qty,p_po_qty,  #TQC-CC0119 aa
                      p_pr_qty,p_wo_qty,p_al_qty,p_sfcislk01)  
  DEFINE p_sfa03     LIKE sfa_file.sfa03,
         p_sfa01     LIKE sfa_file.sfa01,#TQC-CC0119 add
         p_sfa26     LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01)
#        p_sfb13     LIKE sfb_file.sfb13,   #No.TQC-640132   #MOD-A50021 sfb25-->sfb13 #FUN-AB0030 mark
         p_abdate    LIKE type_file.dat,    #FUN-AB0030
         p_sfcislk01 LIKE sfci_file.sfcislk01,   #No.FUN-870124
         p_req_qty   LIKE pml_file.pml20,
         p_qc_qty    LIKE pml_file.pml20,
         p_po_qty    LIKE pml_file.pml20,
         p_pr_qty    LIKE pml_file.pml20,
         p_wo_qty    LIKE pml_file.pml20,
         p_al_qty    LIKE pml_file.pml20,
         su_qty      LIKE pml_file.pml20,
         sh_qty      LIKE pml_file.pml20,
         l_ima01     LIKE ima_file.ima01,
         l_ima02     LIKE ima_file.ima02,
         l_ima05     LIKE ima_file.ima05,
         l_ima25     LIKE ima_file.ima25,
         l_ima27     LIKE ima_file.ima27,
#         l_ima262    LIKE ima_file.ima262, #FUN-A20044
         l_avl_stk    LIKE type_file.num15_3, #FUN-A20044
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima55     LIKE ima_file.ima55,
         l_factor    LIKE ima_file.ima31_fac,  #No.FUN-680136 DEC(16,8)
         l_flag      LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(01)
         l_supply    LIKE pml_file.pml20,
         l_demand    LIKE pml_file.pml20,
         l_pan       LIKE type_file.num10,     #No.FUN-680136 INTEGER
         l_double    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE  l_cnt        LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE  l_ima906     LIKE ima_file.ima906
DEFINE  l_ima907     LIKE ima_file.ima907
DEFINE  l_ima908     LIKE ima_file.ima908    #No.TQC-6B0124 add
DEFINE l_pmli        RECORD LIKE pmli_file.* #NO.FUN-7B0018
DEFINE  l_avl_stk_mpsmrp,l_unavl_stk LIKE type_file.num15_3 #FUN-A20044
DEFINE l_pr_qty2 LIKE pml_file.pml20 #MOD-C20231 add
 
#   SELECT ima01,ima02,ima05,ima25,ima262,ima27,ima44,ima44_fac, #FUN-A20044
   SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, #FUN-A20044
          ima45,ima46,ima49,ima491,ima25,ima908   #No.MOD-6B0157 modify
     INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,  #No.TQC-6B0124 add ima908
          l_ima44,l_ima44_fac,l_ima45,l_ima46,
          l_ima49,l_ima491,l_ima25,l_ima908    #No.MOD-6B0157 modify
     FROM ima_file
    WHERE ima01 = p_sfa03
   CALL s_getstock(p_sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ima_file",p_sfa03,"",SQLCA.sqlcode,"","sel ima",1)  #No.FUN-660129
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_pml2.pml24 = p_sfa01 #TQC-CC0119 add
   LET g_pml2.pml02 = g_seq
   LET g_pml2.pml04 = l_ima01
   LET g_pml2.pml041= l_ima02
   LET g_pml2.pml05 = NULL  #no.4649
   LET g_pml2.pml07 = l_ima44
   LET g_pml2.pml08 = l_ima25
   CALL s_umfchk(g_pml2.pml04,g_pml2.pml07,l_ima25) RETURNING l_cnt,g_pml2.pml09
   IF l_cnt = 1 THEN LET g_pml2.pml09=1 END IF
   LET g_pml2.pml42 = p_sfa26
   IF g_pml2.pml42  = '2' THEN LET g_pml2.pml42 = '1' END IF
   IF g_pml2.pml42  = 'S' THEN LET g_pml2.pml42 = '0' END IF
   IF g_pml2.pml42  = 'U' THEN LET g_pml2.pml42 = '0' END IF
   #-->不包含現有庫存
#   IF tm.a = 'N' THEN LET l_ima262 = 0 END IF #FUN-A20044 
   IF tm.a = 'N' THEN LET l_avl_stk = 0 END IF #FUN-A20044 
   #-->不包含檢驗量
   IF tm.b = 'N' THEN LET p_qc_qty = 0 END IF
   #-->不包含請購量
   IF tm.c = 'N' THEN LET p_pr_qty = 0 END IF
   #-->不包含採購量
   IF tm.d = 'N' THEN LET p_po_qty = 0 END IF
   #-->不包含工單量
   IF tm.e = 'N' THEN LET p_wo_qty = 0 END IF
   #-->不包含已備料
   IF tm.f = 'N' THEN LET p_al_qty = 0 END IF
   #MOD-C20231 ----- add strt -----
   IF p_pr_qty < 0 THEN
      LET l_pr_qty2  = 0
   ELSE
      LET l_pr_qty2  = p_pr_qty
   END IF
   #MOD-C20231 ----- add end -----
   #-->缺料量 = 本次需求 + 已備料量 - [ 庫存可用 + QC + PO + PR + WO]
   LET sh_qty = p_req_qty + p_al_qty -
#                (l_ima262 + p_qc_qty + p_po_qty + p_pr_qty + p_wo_qty ) #FUN-A20044
                #(l_avl_stk + p_qc_qty + p_po_qty + p_pr_qty + p_wo_qty ) #FUN-A20044 #MOD-C20231 mark
                (l_avl_stk + p_qc_qty + p_po_qty + l_pr_qty2 + p_wo_qty ) #MOD-C20231 add
 
   #-->缺料量如大於本次需求則以本次需求為主
   IF sh_qty > p_req_qty THEN
      LET su_qty = p_req_qty
   ELSE 
      LET su_qty = sh_qty
   END IF
 
   #-->建議量 = 缺料量 + 安全庫存量
  #IF tm.g = 'Y' AND su_qty > 0 THEN       #MOD-C20227 mark
   IF tm.g = 'Y' THEN                      #MOD-C20227 add 
      LET su_qty = su_qty  +  l_ima27
   END IF
 
   #-->考慮最少採購量/倍量
   IF su_qty > 0 THEN
      IF su_qty < l_ima46 THEN
         LET g_pml2.pml20 = l_ima46
      ELSE
         IF l_ima45 > 0 THEN
            LET l_pan = (su_qty*1000) MOD (l_ima45 *1000)
            IF l_pan !=0
            THEN LET l_double = (su_qty/l_ima45) + 1
            ELSE LET l_double = su_qty/l_ima45
            END IF
            LET g_pml2.pml20  = l_double * l_ima45
         ELSE
            LET g_pml2.pml20 = su_qty
         END IF
      END IF
   ELSE
      LET g_pml2.pml20 = 0
   END IF
 
   CALL s_umfchk(g_pml2.pml04,l_ima25,g_pml2.pml07) RETURNING l_flag,l_factor    
   IF l_flag THEN
      CALL cl_err(g_pml2.pml07,'mfg1206',0)
   ELSE
      LET g_pml2.pml20=g_pml2.pml20*l_factor
   END IF
   LET g_pml2.pml20 = s_digqty(g_pml2.pml20,g_pml2.pml07)   #FUN-910088--add--

#  LET g_pml2.pml35 = p_sfb13   #MOD-A50021 sfb25-->sfb13   #FUN-AB0030 mark
   LET g_pml2.pml35 = p_abdate                             #FUN-AB0030
   CALL s_aday(g_pml2.pml35,-1,l_ima491) RETURNING g_pml2.pml34
   CALL s_aday(g_pml2.pml34,-1,l_ima49) RETURNING g_pml2.pml33
 
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
        FROM ima_file 
       WHERE ima01 = g_pml2.pml04
      LET g_pml2.pml80 = g_pml2.pml07
      LET l_factor = 1
      CALL s_umfchk(g_pml2.pml04,g_pml2.pml80,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET g_pml2.pml81=l_factor
      LET g_pml2.pml82=g_pml2.pml20
      LET g_pml2.pml83=l_ima907
      LET l_factor = 1
      CALL s_umfchk(g_pml2.pml04,g_pml2.pml83,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET g_pml2.pml84=l_factor
      LET g_pml2.pml85=0
      IF l_ima906 = '3' THEN
         LET g_pml2.pml84=l_factor
         LET l_factor = 1
         CALL s_umfchk(g_pml2.pml04,g_pml2.pml80,g_pml2.pml83)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml2.pml85=g_pml2.pml82*l_factor
         LET g_pml2.pml85 = s_digqty(g_pml2.pml85,g_pml2.pml83)   #FUN-910088--add--
      END IF
   END IF
   IF cl_null(l_ima908) THEN LET l_ima908 = g_pml2.pml07 END IF
 
   IF g_sma.sma116 NOT MATCHES '[13]' THEN
      LET g_pml2.pml86 = g_pml2.pml07
   ELSE
      LET g_pml2.pml86 = l_ima908
   END IF
   CALL p470_set_pml87(g_pml2.pml04,g_pml2.pml07,
                       g_pml2.pml86,g_pml2.pml20) RETURNING g_pml2.pml87
   LET g_pml2.pml87 = s_digqty(g_pml2.pml87,g_pml2.pml86)    #FUN-910088--add--
   #預設統購否pml190
   IF cl_null(g_pml2.pml190) THEN
        SELECT ima913,ima914 INTO g_pml2.pml190,g_pml2.pml191    #NO.CHI-6A0016
         FROM ima_file
        WHERE ima01 = g_pml2.pml04
       IF STATUS = 100 THEN
          #LET g_pml2.pml04 = 'N'  #TQC-6A0011
           LET g_pml2.pml190 = 'N' #TQC-6A0011
       END IF
   END IF
   LET g_pml2.pml930=s_costcenter(g_pmk.pmk13)
   LET g_pml2.pml192 = 'N'         #NO.CHI-6A0016  #拋轉否
   INITIALIZE g_pml2.pml25 TO NULL  #No.MOD-870161
   LET g_pml2.pmlplant = g_plant #FUN-980006 add
   LET g_pml2.pmllegal = g_legal #FUN-980006 add
   IF cl_null(g_pml2.pml91) THEN LET g_pml2.pml91 = 'N' END IF   #TQC-980136 #TQC-AB0397 add 'N'
   LET g_pml2.pml49 = '1' #No.FUN-870007
   LET g_pml2.pml50 = '1' #No.FUN-870007
   LET g_pml2.pml54 = '2' #No.FUN-870007
   LET g_pml2.pml56 = '1' #No.FUN-870007
   LET g_pml2.pml92 = 'N' #FUN-9B0023
   SELECT sfb27 INTO g_pml2.pml12 FROM sfb_file WHERE sfb01 = p_sfa01   #add by guanyao160704
   INSERT INTO pml_file VALUES(g_pml2.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pml_file",g_pml2.pml01,"",SQLCA.sqlcode,"","ins pml2",1)  #No.FUN-660129
      LET g_success = 'N'
   END IF
 
   IF NOT s_industry('std') THEN
      INITIALIZE l_pmli.* TO NULL
      LET l_pmli.pmli01 = g_pml2.pml01
      LET l_pmli.pmli02 = g_pml2.pml02
      LET l_pmli.pmlislk01 = p_sfcislk01   #No.FUN-870124
      IF NOT s_ins_pmli(l_pmli.*,'') THEN
         LET g_success='N'
      END IF
   END IF
 
   LET g_seq = g_seq + 1
 
END FUNCTION
 
FUNCTION p470_set_pml87(p_pml04,p_pml07,p_pml86,p_pml20)
   DEFINE   l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE img_file.img21
   DEFINE   p_pml04  LIKE pml_file.pml04,
            p_pml07  LIKE pml_file.pml07,
            p_pml86  LIKE pml_file.pml86,
            p_pml20  LIKE pml_file.pml20 
 
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=p_pml04
    IF SQLCA.sqlcode =100 THEN
       IF p_pml04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac1=1
    LET l_qty1=p_pml20
    CALL s_umfchk(p_pml04,p_pml07,l_ima44)
          RETURNING g_cnt,l_fac1
    IF g_cnt = 1 THEN
       LET l_fac1 = 1
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
 
    LET l_tot=l_qty1*l_fac1
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
    LET l_factor = 1
    CALL s_umfchk(p_pml04,l_ima44,p_pml86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    RETURN l_tot
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
