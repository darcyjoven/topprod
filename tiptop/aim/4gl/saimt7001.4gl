# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: saimt7001
# Descriptions...: 調撥單展開
#                : p_mode: 1:工單;2.BOM
# Date & Author..:95/02/15 By Jackson
# Modify.........: No.MOD-480115 04/08/30 By Nicola 單頭輸完進入單身前 詢問時選 '3' 不應輸入工單
# Modify.........: No.MOD-4A0041 04/10/05 By Mandy 無用到,所以刪除
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-550095 05/06/03 By Mandy 特性BOM
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8)
# Modify.........: No.FUN-570249 05/07/26 By Carrier 多單位內容修改
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.MOD-650089 06/05/22 By Claire 不勾選是否展至尾階,也應該將該階元件列出
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770057 07/07/24 By rainy insert into imn_file時 imn29=null
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.TQC-7A0068 07/10/19 By rainy CHI-740001 bma_file判斷有效碼沒做OUTER轉換
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.TQC-940177 09/05/11 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980059 09/09/11 By GP5.2架構重整，修改SUB相關傳入參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980093 09/09/23 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A20044 10/03/22 By wangj ima26x改善 
# Modify.........: No.FUN-A50102 10/06/08 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现 
# Modify.........: No.FUN-B70074 11/07/25 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-BB0084 11/12/07 By lixh1 增加數量欄位小數取位
# Modify.........: No.TQC-C50034 12/05/31 By chenjing 修正sql錯誤,添加空格
# Modify.........: No.FUN-CB0087 13/01/08 By qiull 庫存單據理由碼改善
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查
# Modify.........: No.TQC-D50116 13/05/27 By fengrui 修改儲位檢查報錯信息
# Modify.........: No.TQC-D50127 13/05/30 By lixiang 儲位檢查前空值的時候先賦空格

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_imn    RECORD LIKE imn_file.*,
    tm       RECORD	
             wono  LIKE sfb_file.sfb01,
             part  LIKE ima_file.ima01,
             idate LIKE type_file.dat,     #No.FUN-690026 DATE
             a     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
             qty   LIKE sfb_file.sfb08,
             imn04 LIKE imn_file.imn04,
             imn05 LIKE imn_file.imn05,
             imn06 LIKE imn_file.imn06,
             imn09 LIKE imn_file.imn09,
             imn15 LIKE imn_file.imn15,
             imn16 LIKE imn_file.imn16,
             imn17 LIKE imn_file.imn17,
             imn20 LIKE imn_file.imn20
             END RECORD,
    g_code   LIKE bma_file.bma06,          #FUN-550095 add
    g_date   LIKE type_file.dat,           #調撥單日期  #No.FUN-690026 DATE
    g_mode   LIKE type_file.chr1,          #展開模式 (1:工單;2.BOM)  #No.FUN-690026 VARCHAR(1)
    g_out    LIKE imn_file.imn041,         #撥出工廠 #FUN-660078
    g_in     LIKE imn_file.imn151,         #撥入工廠 #FUN-660078
    g_no     LIKE type_file.num5,          #項次編號  #No.FUN-690026 SMALLINT
    g_factor LIKE ima_file.ima31_fac,      #No.FUN-690026 DECIMAL(16,8)
    g_ccc    LIKE type_file.num5           #No.FUN-690026 SMALLINT
 
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_imn9301           LIKE imn_file.imn9301  #FUN-680006
 
FUNCTION t7001(p_argv1,p_date,p_mode,p_out,p_in)
 
#     DEFINE   l_time LIKE type_file.chr8         #No.FUN-6A0074
   DEFINE l_sql      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(400)
          p_argv1    LIKE imn_file.imn01,    #調撥單號
          p_date     LIKE type_file.dat,     #調撥單日期  #No.FUN-690026 DATE
          p_mode     LIKE type_file.chr1,    #展開模式 (1:工單;2.BOM)  #No.FUN-690026 VARCHAR(1)
          p_cmd      LIKE type_file.chr1,    #展開模式 (1:工單;2.BOM)  #No.FUN-690026 VARCHAR(1)
          p_out      LIKE imn_file.imn041,   #撥出工廠 #FUN-660078
          p_in       LIKE imn_file.imn151,   #撥入工廠 #FUN-660078
          l_imd11    LIKE imd_file.imd11,
          l_ime05    LIKE ime_file.ime05,
          l_dir      LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   WHENEVER ERROR CONTINUE
    IF p_argv1 IS NULL OR p_argv1 = ' ' THEN
       CALL cl_err(p_argv1,'mfg9389',0)
       RETURN
    END IF
    LET g_ccc=0
    LET g_imn.imn01 = p_argv1
    LET g_date=p_date
    LET g_mode=p_mode
    LET g_in=p_in
    LET g_out=p_out
    INITIALIZE tm.* TO NULL
    LET tm.idate=g_today
    LET tm.a='N'
    LET tm.qty=0
    LET tm.imn04=' '
    LET tm.imn05=' '
 
WHILE TRUE
    OPEN WINDOW t7001_w WITH FORM "aim/42f/aimt7001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt7001")
 
    INPUT BY NAME tm.* WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
#      BEFORE FIELD wono
#        CALL i110_set_entry(p_cmd)
 
 
       AFTER FIELD wono
         IF NOT cl_null(tm.wono) THEN
            IF NOT(chk_wono()) THEN NEXT
               FIELD wono
            END IF
         END IF
         LET l_dir='D'
#        CALL i110_set_no_entry(p_cmd)
 
 
       AFTER FIELD part
#          IF cl_null(tm.part) THEN NEXT FIELD part END IF
          IF NOT chk_part() THEN NEXT FIELD part END IF
 
 
#       AFTER FIELD a
#          IF cl_null(tm.a) OR tm.a NOT matches '[YN]' THEN NEXT FIELD a END IF
       AFTER FIELD qty
          IF tm.qty<=0 THEN NEXT FIELD qty END IF
          LET l_dir='U'
 
       AFTER FIELD imn04
          IF tm.imn04 IS NOT NULL THEN
             SELECT imd11 INTO l_imd11 FROM imd_file WHERE imd01=tm.imn04
                                                        AND imdacti = 'Y' #MOD-4B0169
             IF SQLCA.SQLCODE THEN
                IF SQLCA.SQLCODE=100 THEN
#                  CALL cl_err(tm.imn04,'mfg6076',2) #No.FUN-660156
                   CALL cl_err3("sel","imd_file",tm.imn04,"","mfg6076","","",1)  #No.FUN-660156
                ELSE
#                  CALL cl_err(tm.imn04,status,2)  #No.FUN-660156
                   CALL cl_err3("sel","imd_file",tm.imn04,"",STATUS,"","",1)  #No.FUN-660156
                END IF
                NEXT FIELD imn04
             ELSE
                IF l_imd11='N' THEN
                   CALL cl_err(tm.imn04,'mfg6080',2)
                END IF
             END IF
          END IF
	IF NOT t7001_imechk() THEN NEXT FIELD imn05 END IF  #FUN-D40103 add
 
       AFTER FIELD imn05
	#FUN-D40103--mark--str--
        #  IF tm.imn05 IS NULL THEN
        #     SELECT ime05 INTO l_ime05 FROM ime_file
        #      WHERE ime01=tm.imn04 AND ime02=tm.imn05
        #     IF SQLCA.SQLCODE THEN
        #        IF SQLCA.SQLCODE=100 THEN
#       #           CALL cl_err(tm.imn05,'mfg6093',2)  #No.FUN-660156
        #           CALL cl_err3("sel","ime_file",tm.imn04,tm.imn05,"mfg6093",
        #                        "","",1)  #No.FUN-660156
        #        ELSE
#       #           CALL cl_err(tm.imn05,status,2) #No.FUN-660156
        #           CALL cl_err3("sel","ime_file",tm.imn04,tm.imn05,STATUS,
        #                        "","",1)  #No.FUN-660156
        #        END IF
        #        NEXT FIELD imn05
        #     ELSE
        #        IF l_ime05='N' THEN
        #           CALL cl_err(tm.imn05,'mfg6081',2)
        #        END IF
        #     END IF
        #  END IF
 	#FUN-D40103--mark--end--
	IF cl_null(tm.imn05) THEN LET tm.imn05 = ' ' END IF #TQC-D50127 add   
	 IF NOT t7001_imechk() THEN NEXT FIELD imn05 END IF  #FUN-D40103 add
       #FUN-550095 add
       ON ACTION CONTROLP
           CASE WHEN INFIELD(part)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_bma4"
                     LET g_qryparam.default1 = tm.part
                     CALL cl_create_qry() RETURNING tm.part
                     DISPLAY tm.part TO FORMONLY.part
                OTHERWISE
                     EXIT CASE
           END CASE
       #FUN-550095(end)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t7001_w RETURN END IF
    #FUN-550095 add
    LET g_code = NULL
    SELECT ima910 INTO g_code FROM ima_file
     WHERE ima01=tm.part
    IF g_code IS NULL THEN LET g_code = ' ' END IF
    #FUN-550095(end)
    CALL t7001_init()
    IF g_mode='1' THEN CALL t7001_sfb() ELSE CALL t7001_bom() END IF
    CLOSE WINDOW t7001_w
    EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF NOT g_before_input_done THEN       #No.MOD-480115
      CALL cl_set_comp_entry("wono,part,idate,a",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF g_mode='2' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("wono",FALSE)      #No.MOD-480115
   END IF
 
   IF INFIELD(wono) OR (NOT g_before_input_done) THEN
      IF g_mode = '1' THEN
         CALL cl_set_comp_entry("part,idate,a",FALSE)
      END IF
   END IF
END FUNCTION
FUNCTION t7001_init()
  ##撥出
  # LET g_imn.imn041=g_plant
    LET g_imn.imn041=g_out
    LET g_imn.imn04 =tm.imn04
    #No.FUN-570249  --begin
    IF cl_null(tm.imn05) THEN LET tm.imn05 = ' ' END IF
    IF cl_null(tm.imn06) THEN LET tm.imn06 = ' ' END IF
    IF cl_null(tm.imn16) THEN LET tm.imn16 = ' ' END IF
    IF cl_null(tm.imn17) THEN LET tm.imn17 = ' ' END IF
    #No.FUN-570249  --end  
    LET g_imn.imn05 =tm.imn05
    LET g_imn.imn06 =tm.imn06
    LET g_imn.imn07 =' '
    LET g_imn.imn08 =' '
    LET g_imn.imn09 =tm.imn09
    LET g_imn.imn091=' '
    LET g_imn.imn092=' '
    LET g_imn.imn10 =0
    LET g_imn.imn11 =0
    LET g_imn.imn12 ='N'
    LET g_imn.imn13 =g_user
   #LET g_imn.imn14 =g_today
    LET g_imn.imn14 =g_date
  ##撥入
    LET g_imn.imn151=g_in
    LET g_imn.imn15 =tm.imn15
    LET g_imn.imn16 =tm.imn16
    LET g_imn.imn17 =tm.imn17
    LET g_imn.imn18 =' '
    LET g_imn.imn19 =' '
    LET g_imn.imn20 =tm.imn20
    LET g_imn.imn201=' '
    LET g_imn.imn202=' '
    LET g_imn.imn22 =0
    LET g_imn.imn23 =0
    LET g_imn.imn24 ='N'
    LET g_imn.imn25 =' '
   #LET g_imn.imn26 =g_today
    LET g_imn.imn26 =g_date
    LET g_imn.imn27 ='N'
END FUNCTION
 
FUNCTION chk_wono()
  DEFINE l_sfb04   LIKE sfb_file.sfb04,
         l_sfbacti LIKE sfb_file.sfbacti,
         l_sfb87   LIKE sfb_file.sfb87,
         l_err     LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
     LET l_err=1
     SELECT sfb04,sfbacti,sfb87 INTO l_sfb04,l_sfbacti,l_sfb87
       FROM sfb_file WHERE sfb01=tm.wono
       CASE
         WHEN SQLCA.SQLCODE=100
#             CALL cl_err(tm.wono,'mfg2647',2) #No.FUN-660156
              CALL cl_err3("sel","sfb_file",tm.wono,"","mfg2647",
                           "","",1)  #No.FUN-660156
              LET l_err=0
         WHEN l_sfbacti = 'N'
              CALL cl_err(tm.wono,'mfg0301',2)
              LET l_err=0
         WHEN l_sfb87 = 'X'
              CALL cl_err(tm.wono,'9024',2)
              LET l_err=0
         WHEN l_sfb04 = '8'
              CALL cl_err(tm.wono,'mfg3430',2)
              LET l_err=0
         WHEN SQLCA.SQLCODE != 0
#             CALL cl_err(tm.wono,sqlca.sqlcode,2)  #No.FUN-660156
              CALL cl_err3("sel","sfb_file",tm.wono,"",sqlca.sqlcode,
                           "","",1)  #No.FUN-660156
              LET l_err=0
      END CASE
      RETURN l_err
END FUNCTION
 
FUNCTION chk_part()
  DEFINE  l_ima08    LIKE ima_file.ima08,
          l_imaacti  LIKE ima_file.imaacti,
          l_cnt      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_err      LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
         LET l_err=1
        #檢查該料件是否存在
         SELECT ima08,imaacti INTO l_ima08,l_imaacti FROM ima_file
          WHERE ima01=tm.part
             CASE
               WHEN l_ima08 != 'M'
                    LET l_err=0
               WHEN l_imaacti = 'N'
                    CALL cl_err(tm.part,'mfg0301',2)
                    LET l_err=0
               WHEN SQLCA.SQLCODE = 100
#                   CALL cl_err(tm.part,'mfg0002',2) #No.FUN-660156
                    CALL cl_err3("sel","ima_file",tm.part,"","mfg0002",
                                 "","",1)  #No.FUN-660156
                    LET l_err=0
               WHEN SQLCA.SQLCODE != 0
#                   CALL cl_err(tm.part,sqlca.sqlcode,2) #No.FUN-660156
                    CALL cl_err3("sel","ima_file",tm.part,"",sqlca.sqlcode,
                                 "","",1)  #No.FUN-660156
                    LET l_err=0
            END CASE
         IF l_err THEN
        #檢查該料件是否有產品結構
              SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb01=tm.part
                  IF SQLCA.SQLCODE THEN
                      CALL cl_err(tm.part,sqlca.sqlcode,2)
                      LET l_err=0
                  END IF
                  IF l_cnt=0 OR cl_null(l_cnt) THEN
                      CALL cl_err(tm.part,'mfg2602',2)
                      LET l_err=0
                  END IF
         END IF
    RETURN l_err
END FUNCTION
 
###工單下階料
FUNCTION t7001_sfb()
  DEFINE l_i,l_cnt   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_sfa RECORD
               sfa03 LIKE sfa_file.sfa03,
               sfa12 LIKE sfa_file.sfa12,
               sfa161 LIKE sfa_file.sfa161
         END RECORD
#No.FUN-570249  --begin
  DEFINE l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_img09_s  LIKE img_file.img09, 
         l_img09_t  LIKE img_file.img09, 
         l_factor   LIKE img_file.img21,
         l_sql      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(600)
         g_azp03    LIKE azp_file.azp03,
         l_azp03    LIKE azp_file.azp03
  DEFINE p_dbs_tra       LIKE azw_file.azw05        #FUN-980093 add
  DEFINE p_plant_new     LIKE azp_file.azp01        #FUN-980093 add
 
#No.FUN-570249  --end  
DEFINE l_sfb98   LIKE sfb_file.sfb98 #FUN-680006
DEFINE l_imni   RECORD LIKE imni_file.*    #FUN-B70074
DEFINE l_flag      LIKE type_file.chr1     #FUN-B70074
DEFINE l_store   STRING                    #FUN-CB0087 
DEFINE l_imm14   LIKE imm_file.imm14       #FUN-CB0087
DEFINE l_imm16   LIKE imm_file.imm16       #FUN-CB0087
  DECLARE sfb_cs CURSOR FOR
      SELECT sfa03,sfa12,sfa161 FROM sfa_file
       WHERE sfa01=tm.wono
  IF SQLCA.SQLCODE THEN 
     CALL cl_err('chk#1',status,2)
  END IF
  INITIALIZE l_sfa.* TO NULL
  SELECT sfb98 INTO l_sfb98 FROM sfb_file WHERE sfb01=tm.wono #FUN-680006
  LET g_no=0
  FOREACH sfb_cs INTO l_sfa.*
     IF SQLCA.SQLCODE THEN CALL cl_err('chk#1',status,2) END IF
     LET g_no=g_no+10
     LET g_imn.imn02=g_no
     LET g_imn.imn03=l_sfa.sfa03
     CALL s_umfchk(l_sfa.sfa03,l_sfa.sfa12,g_imn.imn09)
       RETURNING l_cnt,g_factor
     IF l_cnt=1 THEN
     ##Modify:98/11/13 ------單位換算率抓不到---------#
       CALL cl_err('','abm-731',1)
       EXIT FOREACH
     ###----------------------------------------------#
     ##  LET g_factor=1
     END IF
     IF cl_null(g_factor) THEN LET g_factor=1 END IF
     IF cl_null(l_sfa.sfa161) THEN LET l_sfa.sfa161=0 END IF
     LET g_imn.imn10=tm.qty*l_sfa.sfa161*g_factor
     LET g_imn.imn10=s_digqty(g_imn.imn10,g_imn.imn09)      #FUN-BB0084
     CALL s_umfchk(l_sfa.sfa03,g_imn.imn09,g_imn.imn20)
       RETURNING l_cnt,g_factor
     IF l_cnt=1 THEN
     ##Modify:98/11/13 ------單位換算率抓不到---------#
       CALL cl_err('','abm-731',1)
       EXIT FOREACH
     ###----------------------------------------------#
        LET g_factor=1
     END IF
     IF cl_null(g_factor) THEN LET g_factor=1 END IF
     LET g_imn.imn21=g_factor
     LET g_imn.imn22=g_imn.imn10*g_imn.imn21
     LET g_imn.imn22=s_digqty(g_imn.imn22,g_imn.imn20)     #FUN-BB0084
     #No.FUN-570249  --begin
     IF g_sma.sma115 = 'Y' THEN
        SELECT azp03 INTO g_azp03 FROM azp_file WHERE azp01=g_imn.imn151
        LET l_azp03 = s_madd_img_catstr(g_azp03)
 
       #--Begin FUN-980093 add----GP5.2 Modify #改抓Transaction DB
        LET g_plant_new = g_in
        CALL s_getdbs()
        LET p_plant_new = g_plant_new
        CALL s_gettrandbs()
        LET p_dbs_tra = g_dbs_tra
       #--End   FUN-980093 add-------------------------------------
        SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
          FROM ima_file WHERE ima01=g_imn.imn03
        SELECT img09 INTO l_img09_s FROM img_file
         WHERE img01=g_imn.imn03
           AND img02=g_imn.imn04
           AND img03=g_imn.imn05
           AND img04=g_imn.imn06
        IF cl_null(l_img09_s) THEN LET l_img09_s=l_ima25 END IF
        LET g_imn.imn30=g_imn.imn09
        LET l_factor = 1
        CALL s_umfchk(g_imn.imn03,g_imn.imn30,l_img09_s)
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        LET g_imn.imn31=l_factor
        LET g_imn.imn32=g_imn.imn10
        LET g_imn.imn33=l_ima907
        LET l_factor = 1
        CALL s_umfchk(g_imn.imn03,g_imn.imn33,l_img09_s)
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        LET g_imn.imn34=l_factor
        LET g_imn.imn35=0
        IF l_ima906 = '3' THEN
           LET l_factor = 1
           CALL s_umfchk(g_imn.imn03,g_imn.imn30,g_imn.imn33)
                RETURNING l_cnt,l_factor
           IF l_cnt = 1 THEN
              LET l_factor = 1
           END IF
           LET g_imn.imn35=g_imn.imn32*l_factor
           LET g_imn.imn35=s_digqty(g_imn.imn35,g_imn.imn33)    #FUN-BB0084
        END IF
       #LET l_sql=" SELECT ima25,ima906,ima907 FROM ",g_azp03 CLIPPED,".ima_file", #TQC-940177 
        #LET l_sql=" SELECT ima25,ima906,ima907 FROM ",s_dbstring(g_azp03 CLIPPED),"ima_file", #TQC-940177 #FUN-980093 mark
       #LET l_sql=" SELECT ima25,ima906,ima907 FROM ",g_dbs_new,"ima_file", #TQC-940177 #FUN-980093 add  #FUN-A50102
        LET l_sql=" SELECT ima25,ima906,ima907 FROM ",cl_get_target_table(g_plant_new,'ima_file'),   #FUN-A50102
                  "  WHERE ima01='",g_imn.imn03,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-A50102
        PREPARE s_prex1 FROM l_sql
        DECLARE s_curx1 CURSOR FOR s_prex1
        OPEN s_curx1
        FETCH s_curx1 INTO l_ima25,l_ima906,l_ima907
       #LET l_sql="SELECT img09 FROM ",g_azp03 CLIPPED,".img_file", #TQC-940177 
        #LET l_sql="SELECT img09 FROM ",s_dbstring(g_azp03 CLIPPED),"img_file", #TQC-940177 #FUN-980093 mark 
       #LET l_sql="SELECT img09 FROM ",p_dbs_tra,"img_file", #TQC-940177 #FUN-980093 add   #FUN-A50102
        LET l_sql="SELECT img09 FROM ",cl_get_target_table(p_plant_new,'img_file'),    #FUN-A50102
                  " WHERE img01='",g_imn.imn03,"'",
                  "   AND img02='",g_imn.imn04,"'",
                  "   AND img03='",g_imn.imn05,"'",
                  "   AND img04='",g_imn.imn06,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
        CALL cl_parse_qry_sql(l_sql,p_plant_new) RETURNING l_sql #FUN-980093
        PREPARE s_prex2 FROM l_sql
        DECLARE s_curx2 CURSOR FOR s_prex2
        OPEN s_curx2
        FETCH s_curx2 INTO l_img09_t
        IF cl_null(l_img09_t) THEN LET l_img09_t=l_ima25 END IF
        LET g_imn.imn40=g_imn.imn20
        LET l_factor = 1
#       CALL s_umfchk1(g_imn.imn03,g_imn.imn40,l_img09_t,l_azp03)        #No.FUN-980059
        CALL s_umfchk1(g_imn.imn03,g_imn.imn40,l_img09_t,g_imn.imn151)   #No.FUN-980059
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        LET g_imn.imn41=l_factor
        LET g_imn.imn42=g_imn.imn22
        LET g_imn.imn43=l_ima907
        LET l_factor = 1
#       CALL s_umfchk1(g_imn.imn03,g_imn.imn43,l_img09_t,l_azp03)        #No.FUN-980059
        CALL s_umfchk1(g_imn.imn03,g_imn.imn43,l_img09_t,g_imn.imn151)   #No.FUN-980059
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        LET g_imn.imn44=l_factor
        LET g_imn.imn45=0
        IF l_ima906 = '3' THEN
           LET l_factor = 1
#          CALL s_umfchk1(g_imn.imn03,g_imn.imn40,g_imn.imn43,l_azp03)      #No.FUN-980059
           CALL s_umfchk1(g_imn.imn03,g_imn.imn40,g_imn.imn43,g_imn.imn151) #No.FUN-980059
                RETURNING l_cnt,l_factor
           IF l_cnt = 1 THEN
              LET l_factor = 1
           END IF
           LET g_imn.imn45=g_imn.imn42*l_factor
           LET g_imn.imn45=s_digqty(g_imn.imn45,g_imn.imn43)    #FUN-BB0084
        END IF
        LET l_factor = 1
#       CALL s_umfchk1(g_imn.imn03,g_imn.imn30,g_imn.imn40,l_azp03)        #No.FUN-980059
        CALL s_umfchk1(g_imn.imn03,g_imn.imn30,g_imn.imn40,g_imn.imn151)   #NO.FUN-980059
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        LET g_imn.imn51=l_factor
        LET l_factor = 1
#       CALL s_umfchk1(g_imn.imn03,g_imn.imn33,g_imn.imn43,l_azp03)       #NO.FUN-980059
#       CALL s_umfchk1(g_imn.imn03,g_imn.imn33,g_imn.imn43,l_azp03)       #No.FUN-980059
        CALL s_umfchk1(g_imn.imn03,g_imn.imn33,g_imn.imn43,g_imn.imn151)  #No.FUN-980059
             RETURNING l_cnt,l_factor
        IF l_cnt = 1 THEN
           LET l_factor = 1
        END IF
        LET g_imn.imn52=l_factor
     END IF
     LET g_imn.imn29 = 'N'  #FUN-770057
     #No.FUN-570249  --end
     #FUN-680006...............begin
     IF g_aaz.aaz90='Y' THEN
        LET g_imn.imn9301=l_sfb98
        LET g_imn.imn9302=g_imn.imn9301
     END IF
     #FUN-680006...............end
     LET g_imn.imnplant = g_plant #FUN-980004 add
     LET g_imn.imnlegal = g_legal #FUN-980004 add
#TQC-C50034--add--start--
     IF g_prog = 'aimt720' THEN
        LET g_imn.imn11 = ''
        LET g_imn.imn12 = ''
        LET g_imn.imn13 = ''
        LET g_imn.imn14 = ''
        LET g_imn.imn23 = ''
        LET g_imn.imn24 = ''
        LET g_imn.imn25 = ''
        LET g_imn.imn26 = ''
        LET g_imn.imn27 = ''
     END IF
#TQC-C50034--add--end--
     #FUN-CB0087---add---str---
     IF g_aza.aza115 = 'Y' THEN
        LET l_store = ''
        IF NOT cl_null(g_imn.imn04) THEN
           LET l_store = l_store,g_imn.imn04
        END IF
        IF NOT cl_null(g_imn.imn15) THEN
           IF NOT cl_null(l_store) THEN
              LET l_store = l_store,"','",g_imn.imn15
           ELSE
              LET l_store = l_store,g_imn.imn15
           END IF
        END IF
        SELECT imm14,imm16 INTO l_imm14,l_imm16 FROM imm_file WHERE imm01 = g_imn.imn01
        LET g_imn.imn28 = s_reason_code(g_imn.imn01,'','',g_imn.imn03,l_store,l_imm16,l_imm14)
     END IF
     #FUN-CB0087---add---end---
     INSERT INTO imn_file VALUES (g_imn.*)
     IF SQLCA.SQLCODE THEN #CALL cl_err('INSERT Faild#1',status,2) END IF
         CALL cl_err3("ins","imn_file",g_imn.imn01,"",SQLCA.sqlcode,"",
                      "INSERT Faild#1",1)   #NO.FUN-640266 #No.FUN-660156
     #FUN-B70074-add-str--
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_imni.* TO NULL
           LET l_imni.imni01 = g_imn.imn01
           LET l_imni.imni02 = g_imn.imn02
           LET l_flag = s_ins_imni(l_imni.*,g_imn.imnplant)
        END IF
     #FUN-B70074-add-end--
     END IF
  END FOREACH
END FUNCTION
 
 
 
###展BOM
 FUNCTION t7001_bom()
   DEFINE l_ima562     LIKE ima_file.ima562,
          l_ima55      LIKE ima_file.ima55,
          g_errno      LIKE ze_file.ze01     #No.FUN-690026 VARCHAR(10)
 
    SELECT ima562,ima55 INTO  #FUN-560183 del ima86,ima86_fac
      l_ima562,l_ima55  #,l_ima86,l_ima86_fac #FUN-560183
        FROM ima_file
        WHERE ima01=tm.part AND imaacti='Y'
    IF SQLCA.sqlcode THEN RETURN END IF
    IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
    #FUN-680006...............begin
    IF g_aaz.aaz90='Y' THEN
       LET g_imn9301=s_costcenter(g_grup)
    END IF
    #FUN-680006...............end
    LET g_no=0
    CALL t7001_bom2(0,tm.part,g_code,tm.qty,1) #FUN-550095 add g_code
       IF g_ccc=0 THEN
           LET g_errno='asf-014'
       END IF    #有BOM但無有效者
 
    MESSAGE ""
    RETURN
END FUNCTION
 
FUNCTION t7001_bom2(p_level,p_key,p_key2,p_total,p_QPA) #FUN-550095 add p_key2
 
DEFINE
    p_level      LIKE type_file.num5,     #level code  #No.FUN-690026 SMALLINT
    p_total      LIKE bmb_file.bmb06,     #No.FUN-690026 DECIMAL(13,5)
    p_QPA        LIKE bmb_file.bmb06,     #FUN-560230
    l_QPA        LIKE bmb_file.bmb06,     #FUN-560230
    p_key        LIKE bma_file.bma01,     #assembly part number
    p_key2       LIKE bma_file.bma06,     #FUN-550095 add
    l_ac,l_i,l_x LIKE type_file.num5,     #No.FUN-690026 SMALLINT
    arrno        LIKE type_file.num5,     #BUFFER SIZE  #No.FUN-690026 SMALLINT
    b_seq        LIKE type_file.num10,    #restart sequence (line number)  #No.FUN-690026 INTEGER
    sr           DYNAMIC ARRAY OF RECORD  #array for storage
                  bmb02 LIKE bmb_file.bmb02, #項次
                  bmb03 LIKE bmb_file.bmb03, #料號
                  bmb06 LIKE bmb_file.bmb06, #QPA
                  bmb08 LIKE bmb_file.bmb08, #損耗率
                  bmb10 LIKE bmb_file.bmb10, #發料單位
                  ima08 LIKE ima_file.ima08, #來源碼
                  ima25 LIKE ima_file.ima25, #庫存單位
                  bma01 LIKE bma_file.bma01  #料號
                 END RECORD,
    l_ima08      LIKE ima_file.ima08,    #source code
#    l_ima26      LIKE ima_file.ima26,    #QOH#No.FUN-A20044
    l_chr        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_ActualQPA  LIKE bmb_file.bmb06,    #FUN-560230
    l_cnt,l_c    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_cmd        LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
#No.FUN-570249  --begin
    DEFINE l_ima25    LIKE ima_file.ima25,
           l_ima906   LIKE ima_file.ima906,
           l_ima907   LIKE ima_file.ima907,
           l_img09_s  LIKE img_file.img09, 
           l_factor   LIKE img_file.img21
#No.FUN-570249  --end  
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
    DEFINE l_imni     RECORD LIKE imni_file.*   #FUN-B70074
    DEFINE l_flag      LIKE type_file.chr1      #FUN-B70074
    DEFINE l_store     STRING                   #FUN-CB0087 
    DEFINE l_imm14   LIKE imm_file.imm14       #FUN-CB0087
    DEFINE l_imm16   LIKE imm_file.imm16       #FUN-CB0087
 
    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=" SELECT 0,bmb03,bmb06/bmb07,bmb08,bmb10,",
                  "        ima08,ima25,bma01 ",
                  "   FROM bmb_file LEFT OUTER JOIN ima_file ",
                  "    ON bmb03 = ima01 ",
                  "    LEFT OUTER JOIN bma_file ",   #TQC-C50034 
                  "    ON bmb03 = bma01",
                  "    AND bmaacti = 'Y'",           #TQC-C50034 
                  "  WHERE bmb01='",p_key,"' AND bmb02 > ? AND bmb29='",p_key2,"'",
              #   "    AND bma_file.bmaacti = 'Y'",  #CHI-740001  #TQC-7A0068   #TQC-C50034--mark
                  "    AND (bmb04 <='",tm.idate,"' OR bmb04 IS NULL) ",
                  "    AND (bmb05 >'",tm.idate,"' OR bmb05 IS NULL)",
                  " ORDER BY 1,2"
        PREPARE bom_p FROM l_cmd
        DECLARE bom_cs CURSOR FOR bom_p
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN  END IF
 
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH bom_cs
        USING b_seq
        INTO sr[l_ac].*
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
            #若換算率有問題, 則設為1
            #FUN-8B0035--BEGIN-- 
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END--
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
 
            #Actual QPA
            LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
            LET l_QPA=sr[l_i].bmb06 * p_QPA
 
            IF sr[l_i].ima08='X' THEN       ###為 X PART 由參數決定
               #--------No.FUN-670041 mark
               #IF g_sma.sma29='N' THEN #phantom
               #    CONTINUE FOR #do'nt blow through
               #END IF
               #--------No.FUN-670041 end
                IF sr[l_i].bma01 IS NOT NULL THEN
                   #CALL t7001_bom2(p_level,sr[l_i].bmb03,' ', #FUN-550095 add ' '#FUN-8B0035
                    CALL t7001_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i], #FUN-8B0035
                        p_total*sr[l_i].bmb06,l_ActualQPA)
                END IF
            END IF
 
            IF sr[l_i].ima08='M' THEN     ###為 M PART 由人決定
               IF tm.a='Y' THEN
                  IF sr[l_i].bma01 IS NOT NULL THEN
                    #CALL t7001_bom2(p_level,sr[l_i].bmb03,' ', #FUN-550095 add ' '#FUN-8B0035
                     CALL t7001_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i], #FUN-8B0035
                          p_total*sr[l_i].bmb06,l_ActualQPA)
                  ELSE
                      CONTINUE FOR
                  END IF
               #MOD-650089-begin
               #ELSE
               #   CONTINUE FOR
               #MOD-650089-end
               END IF
            END IF
            IF NOT(sr[l_i].ima08='X' OR (sr[l_i].ima08='M' AND tm.a='Y')) THEN   #MOD-650089 add tm.a='Y'
              LET g_ccc=g_ccc+1
 
              LET g_imn.imn03=sr[l_i].bmb03
              IF g_sma.sma78='1' THEN   ###使用庫存單位
                 Call s_umfchk(sr[l_i].bmb03,sr[l_i].ima25,g_imn.imn09)
                               RETURNING l_cnt,g_factor
              ELSE
                 CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,g_imn.imn09)
                               RETURNING l_cnt,g_factor
              END IF
              ##Modify:98/11/13-----單位換算率抓不到-------###
              IF l_cnt = 1 OR cl_null(g_factor) THEN
                   CALL cl_err('','abm-731',1)
                   LET g_factor = 1
              END IF
              ##-------------------------------------------###
              #### IF l_cnt=1 THEN LET g_factor=1 END IF
              #### IF cl_null(g_factor) THEN LET g_factor=1 END IF
              LET g_imn.imn10=sr[l_i].bmb06*p_total*g_factor
                               *((100+sr[l_i].bmb08))/100
              LET g_imn.imn10=s_digqty(g_imn.imn10,g_imn.imn09)   #FUN-BB0084 
              CALL s_umfchk(sr[l_i].bmb03,g_imn.imn09,g_imn.imn20)
                  RETURNING l_cnt,g_factor
              ##Modify:98/11/13-----單位換算率抓不到-------###
              IF l_cnt = 1 OR cl_null(g_factor) THEN
                   CALL cl_err('','abm-731',1)
                   LET g_factor = 1
              END IF
              ##-------------------------------------------###
             #### IF l_cnt=1 THEN LET g_factor=1 END IF
             #### IF cl_null(g_factor) THEN LET g_factor=1 END IF
             LET g_imn.imn21=g_factor
             LET g_imn.imn22=g_imn.imn10*g_imn.imn21
             LET g_imn.imn22=s_digqty(g_imn.imn22,g_imn.imn20)   #FUN-BB0084 
             ###是否有相同料
             #No.FUN-570249  --begin
             IF g_sma.sma115 = 'Y' THEN
                SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
                  FROM ima_file WHERE ima01=g_imn.imn03
                SELECT img09 INTO l_img09_s FROM img_file
                 WHERE img01=g_imn.imn03
                   AND img02=g_imn.imn04
                   AND img03=g_imn.imn05
                   AND img04=g_imn.imn06
                IF cl_null(l_img09_s) THEN LET l_img09_s=l_ima25 END IF
                LET g_imn.imn30=g_imn.imn09
                LET l_factor = 1
                CALL s_umfchk(g_imn.imn03,g_imn.imn30,l_img09_s)
                     RETURNING l_cnt,l_factor
                IF l_cnt = 1 THEN
                   LET l_factor = 1
                END IF
                LET g_imn.imn31=l_factor
                LET g_imn.imn32=g_imn.imn10
                LET g_imn.imn33=l_ima907
                LET l_factor = 1
                CALL s_umfchk(g_imn.imn03,g_imn.imn33,l_img09_s)
                     RETURNING l_cnt,l_factor
                IF l_cnt = 1 THEN
                   LET l_factor = 1
                END IF
                LET g_imn.imn34=l_factor
                LET g_imn.imn35=0
                IF l_ima906 = '3' THEN
                   LET l_factor = 1
                   CALL s_umfchk(g_imn.imn03,g_imn.imn30,g_imn.imn33)
                        RETURNING l_cnt,l_factor
                   IF l_cnt = 1 THEN
                      LET l_factor = 1
                   END IF
                   LET g_imn.imn35=g_imn.imn32*l_factor
                   LET g_imn.imn35=s_digqty(g_imn.imn35,g_imn.imn33)    #FUN-BB0084
                END IF
                LET g_imn.imn51=1
                LET g_imn.imn52=1
             END IF
             UPDATE imn_file SET imn10=imn10+g_imn.imn10,
                                 imn32=imn32+g_imn.imn32,
                                 imn35=imn35+g_imn.imn35
              WHERE imn01=g_imn.imn01 AND imn03=g_imn.imn03
             #No.FUN-570249  --end
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                IF SQLCA.SQLERRD[3]=0  THEN
                   LET g_no=g_no+10
                   LET g_imn.imn02=g_no
                   LET g_imn.imn9301=g_imn9301 #FUN-680006
                   LET g_imn.imn9302=g_imn.imn9301 #FUN-680006
                   LET g_imn.imn29 = 'N'  #FUN-770057
                   LET g_imn.imnplant = g_plant #FUN-980004 add
                   LET g_imn.imnlegal = g_legal #FUN-980004 add
            #TQC-C50034--add--start--
                   IF g_prog = 'aimt720' THEN
                      LET g_imn.imn11 = ''
                      LET g_imn.imn12 = ''
                      LET g_imn.imn13 = ''
                      LET g_imn.imn14 = ''
                      LET g_imn.imn23 = ''
                      LET g_imn.imn24 = ''
                      LET g_imn.imn25 = ''
                      LET g_imn.imn26 = ''
                      LET g_imn.imn27 = ''
                   END IF
            #TQC-C50034--add--end--
                   #FUN-CB0087---add---str---
                   IF g_aza.aza115 = 'Y' THEN
                      LET l_store = ''
                      IF NOT cl_null(g_imn.imn04) THEN
                         LET l_store = l_store,g_imn.imn04
                      END IF
                      IF NOT cl_null(g_imn.imn15) THEN
                         IF NOT cl_null(l_store) THEN
                            LET l_store = l_store,"','",g_imn.imn15
                         ELSE
                            LET l_store = l_store,g_imn.imn15
                         END IF
                      END IF
                      SELECT imm14,imm16 INTO l_imm14,l_imm16 FROM imm_file WHERE imm01 = g_imn.imn01
                      LET g_imn.imn28 = s_reason_code(g_imn.imn01,'','',g_imn.imn03,l_store,l_imm16,l_imm14)
                   END IF
                   #FUN-CB0087---add---end---
                   INSERT INTO imn_file VALUES (g_imn.*)
                   IF SQLCA.SQLCODE THEN
#                     CALL cl_err('INSERT Faild#2',status,2)
                      CALL cl_err3("ins","imn_file",g_imn.imn01,"",
                                    SQLCA.sqlcode,"","INSERT Faild#2",1)   #NO.FUN-640266 #No.FUN-660156
                   #FUN-B70074-add-str--
                   ELSE
                      IF NOT s_industry('std') THEN
                         INITIALIZE l_imni.* TO NULL
                         LET l_imni.imni01 = g_imn.imn01
                         LET l_imni.imni02 = g_imn.imn02
                         LET l_flag = s_ins_imni(l_imni.*,g_imn.imnplant)
                      END IF
                   #FUN-B70074-add-end--
                   END IF
                ELSE
#                  CALL cl_err('UPDATE Faild#2',status,2) #No.FUN-660156 
                   CALL cl_err3("upd","imn_file",g_imn.imn01,g_imn.imn03,
                                 SQLCA.sqlcode,"","UPDATE Faild#2",1)   #NO.FUN-640266 #No.FUN-660156
                END IF
             END IF
          END IF
        END FOR
        IF l_x < arrno OR l_ac=1 THEN #nothing left
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_x].bmb02
        END IF
    END WHILE
    # 避免 'X' PART 重複計算
    IF p_level >1 THEN
       RETURN
     END IF
END FUNCTION
 
	#FUN-D40103--add--str--
FUNCTION t7001_imechk()
   DEFINE l_n              LIKE type_file.num5
   DEFINE l_ime05          LIKE ime_file.ime05
   DEFINE l_imeacti        LIKE ime_file.imeacti
   DEFINE l_err            LIKE ime_file.ime02   #TQC-D50116 add

   IF tm.imn05 IS NOT NULL AND tm.imn05 != ' ' THEN 
      SELECT COUNT(*) INTO l_n FROM ime_file
       WHERE ime01=tm.imn04 AND ime02=tm.imn05
      IF l_n = 0 THEN 
         CALL cl_err(tm.imn05,'mfg1101',1)
         RETURN FALSE 
      END IF 
   END IF
   IF tm.imn05 IS NOT NULL THEN
      SELECT ime05,imeacti INTO l_ime05,l_imeacti FROM ime_file
       WHERE ime01=tm.imn04 AND ime02=tm.imn05
      IF l_imeacti='N' THEN
         LET l_err = tm.imn05                             #TQC-D50116 add
         IF cl_null(l_err) THEN LET l_err = "' '" END IF  #TQC-D50116 add
         CALL cl_err_msg("","aim-507",tm.imn04 || "|" || l_err ,0)  #TQC-D50116 
         RETURN FALSE
      END IF 
      IF l_ime05='N' THEN
         CALL cl_err(tm.imn05,'mfg6081',2)
         RETURN FALSE
      END IF
   END IF 
   RETURN TRUE
END FUNCTION
#FUN-D40103--add--end--
