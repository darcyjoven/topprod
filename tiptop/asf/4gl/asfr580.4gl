# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr580.4gl
# Descriptions...: 成品模擬用料明細表(單階)
# Date & Author..: 93/05/13 By Keith
# Modify.........: 94/02/17 By Apple
# Modify.........: No:8509 03/11/10 By Melody 缺料量是否不含工單未結案之需求用量(Y/N), 此段程式已無控制, 建議移除
# Modify.........: No:8430 03/10/07 By Melody ORACLE 版組SQL錯誤!--> modoify ora
# Modify.........: No:9306 04/03/05 By Melody cat 指令後應加上 ';rm ',l_name2
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: NO.FUN-550067 05/05/31 By yoyo  單據編號加大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560149 05/06/21 By pengu  因 BOM KEY值改變，無法正常執行。
# Modify.........: NO.TQC-5A0036 05/10/13 By Rosayu 按離開,會出現"是否執行本作業"的訊息
# Modify.........: NO.TQC-5B0125 05/11/14 BY yiting 料號品名位置太小
# Modify.........: No.MOD-5B0162 05/12/12 By Pengu FQC在驗量未排除"委外重工工單",造成數量錯誤
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: NO.MOD-620078 06/02/23 By Claire 報表內容重複
# Modify.........: NO.FUN-650193 06/06/01 By kim 2.0功能改善-主特性代碼
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.FUN-750097 07/06/28 By cheunl報表轉為CR報表
# Modify.........: No.TQC-780056 07/08/17 By Carrier oracle語法轉至ora文檔
# Modify.........: No.MOD-7A0159 07/10/26 By Pengu temp table 的index大於255
# Modify.........: NO.TQC-7B0143 07/11/27 By Mandy FUNCTION alloc_bom名在$SUB/s_alloc.4gl內也有相同的FUNCTION 名,所以更名為r580_alloc_bom,否則r.l2不會過
# Modify.........: No.MOD-810174 08/03/23 By Pengu 如果l_sfb11是null會造成報表在驗量顯示異常
# Modify.........: No.MOD-810144 08/03/23 By Pengu 在外量,未考慮單位換算率
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910  
# Modify.........: No.FUN-940008 09/05/14 By hongmei 發料改善
# Modify.........: No.FUN-940083 09/05/15 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modofy.........: No.FUN-A60027 10/06/12 By vealxu 製造功能優化-平行制程（批量修改） 
# Modify.........: No:FUN-A70034 10/07/19 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:FUN-A70125 10/07/28 By lilingyu 平行工藝
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:MOD-BC0312 12/06/15 By ck2yuan 修正新增一筆無法放棄編輯的問題
# Modify.........: No:CHI-C20050 12/08/22 By bart 畫面加一個選項,選擇要抓未確認、已確認、全部的資料
# Modify.........: No:MOD-D20097 13/02/20 By bart 避免抓到其餘非指定成品的sfa_file資料

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE bst   LIKE type_file.chr1        #CHI-C20050
   DEFINE tm  RECORD             # Print condition RECORD
              c     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# 是否僅列缺料(Y/N)
              END RECORD,
    g_bma DYNAMIC ARRAY OF RECORD
            cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            bma01   LIKE bma_file.bma01,
            ima02   LIKE ima_file.ima02,
            bma06   LIKE bma_file.bma06,          #FUN-650193
#           qty     LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(13,3)
            qty     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
            num     LIKE bma_file.bma02           #No.FUN-680121 VARCHAR(16)#No.FUN-550067
        END RECORD,
    g_bma_t DYNAMIC ARRAY OF RECORD
            cnt     LIKE type_file.num5,          #No.FUN-680121
            bma01   LIKE bma_file.bma01,
            ima02   LIKE ima_file.ima02,
            bma06   LIKE bma_file.bma06,        #FUN-650193
#           qty     LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(13,3)
            qty     LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044 
            num     LIKE bma_file.bma02         #No.FUN-680121 VARCHAR(16)#No.FUN-550067
        END RECORD,
# genero  script marked     g_arrno         SMALLINT,
    g_minopseq      LIKE ecb_file.ecb03,
# genero  script marked     g_bma_arrno     SMALLINT,         #程式陣列的個數(Program array no)
    g_bma_pageno    LIKE type_file.num5,          #No.FUN-680121 SMALLINT#目前單身頁數
    g_rec_b         LIKE type_file.num5,           #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5,           #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT #TQC-840066
#       l_time    LIKE type_file.chr8              #No.FUN-6A0090
    l_name          LIKE type_file.chr20,          #No.FUN-680121 VARCHAR(20)#External(Disk) file name
    l_name2         LIKE type_file.chr20,          #No.FUN-680121 VARCHAR(20)#External(Disk) file name
    l_count         LIKE type_file.num5,           #No.FUN-680121 SMALLINT
    g_chr1          LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
    g_chr2          LIKE type_file.chr1000,        #No.FUN-680121 VARCHAR(40)
    g_yld           LIKE type_file.chr1            #No.FUN-680121 VARCHAR(01)
 
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_total         LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE l_table        STRING                 #No.FUN-750097                                                                         
DEFINE g_str          STRING                 #No.FUN-750097                                                                         
DEFINE g_sql          STRING                 #No.FUN-750097
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
#No.FUN-750097 -----------start-----------------                                                                                    
    LET g_sql = " ima02.ima_file.ima02,",
                " ima021.ima_file.ima021,",
                " ima25.ima_file.ima25,",
#               " ima26.ima_file.ima26,",
                "avl_stk_mpsmrp.type_file.num15_3,",  #NO.FUN-A20044
                " bma01.bma_file.bma01,",
                " bma02.bma_file.bma02,",
                " bma06.bma_file.bma06,",
                " bmb03.bmb_file.bmb03,",
                " bmb18.bmb_file.bmb18,",
                " sfa15.sfa_file.sfa15,",
                " sfa05.sfa_file.sfa05,",
                " sfa061.sfa_file.sfa061,",
                " sfa062.sfa_file.sfa062,",
                " sfa09.sfa_file.sfa09,",
                " sfa25.sfa_file.sfa25,",
                " sfa16.sfa_file.sfa16,",
                " sfa161.sfa_file.sfa161,",
                " sfa14.sfa_file.sfa14,",
                " sfa02.sfa_file.sfa02 " 
 
    LET l_table = cl_prt_temptable('asfr580',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                          
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"                                                                                  
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#No.FUN-750097---------------end------------
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate  = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL asfr580_tm(0,0)                 # Input print condition
   ELSE
      CALL asfr580()                       # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr580_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_za05    LIKE type_file.chr1000,      #No.FUN-680121 VARCHAR(40)
          l_cmd     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1100)
 
   LET g_bma_pageno = 1                   #現在單身頁次
 
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW asfr580_w AT p_row,p_col
        WITH FORM "asf/42f/asfr580"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #FUN-650193................begin
   CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
   #FUN-650193................end
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_chr2 = ' '
   CALL r580_tmp()
WHILE TRUE
   LET g_rec_b = 0
   CALL r580_b()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfr580_w
      EXIT WHILE
   END IF
 
   IF cl_sure(0,0) THEN
      #--->是否只列印缺料部份
#     CALL cl_prtmsg(0,0,'mfg3514',g_lang) RETURNING tm.c
      CALL cl_confirm('mfg3514') RETURNING tm.c
 
#No:8509
#     #--->是否扣除已發放尚未結案工單之下階用量
#     CALL cl_prtmsg(0,0,'mfg3515',g_lang) RETURNING g_chr1
#     CALL cl_confirm('mfg3515') RETURNING g_chr1
#     IF g_chr1 MATCHES '[yY]' THEN
#     IF g_chr1 THEN
#        LET g_chr1='Y'
#        LET g_chr2 = g_x[25] CLIPPED
#     ELSE
#        LET g_chr1='N'
#        LET g_chr2 = g_x[26] CLIPPED
#     END IF
      DELETE FROM r580_t3
      DELETE FROM r580_t2
      CALL cl_wait()
      CALL asfr580()
   ELSE
      EXIT WHILE
   END IF
   ERROR ""
 END WHILE
  DROP TABLE r580_t3 
  DROP TABLE r580_t2 
  CLOSE WINDOW asfr580_w
END FUNCTION
 
FUNCTION r580_tmp()
 
   #產生與sfa_file相同之暫存檔,需求資料
  #No.FUN-680121-BEGIN
  #No.FUN-680121-BEGIN
   CREATE TEMP TABLE r580_t3(
     xx03       LIKE ima_file.ima01,        #No.MOD-7A0159 modify
     xx05       DECIMAL(12,3));
  #No.FUN-680121-END 
   create unique index t3 on r580_t3 (xx03);
   IF SQLCA.sqlcode THEN CALL cl_err('temp error',SQLCA.sqlcode,1) END IF
 
 #No.FUN-680121-BEGIN
  CREATE TEMP TABLE r580_t2(
     xx03       LIKE ima_file.ima01,       #No.MOD-7A0159 modify
     xx05       DECIMAL(12,3),
     unalc      DECIMAL(12,3));
 #No.FUN-680121-END
   IF SQLCA.sqlcode THEN CALL cl_err('temp error',SQLCA.sqlcode,1) END IF
 #No.FUN-940008---Begin add
  CREATE TEMP TABLE r580_tmp1(
     sfa05     LIKE sfa_file.sfa05,
     sfa06     LIKE sfa_file.sfa06,
     sfa13     LIKE sfa_file.sfa13,
     sfa03     LIKE sfa_file.sfa03);
  IF SQLCA.sqlcode THEN CALL cl_err('temp error',SQLCA.sqlcode,1) END IF
 #No.FUN-940008---End 
END FUNCTION
 
FUNCTION asfr580()
   DEFINE l_tmp RECORD 
                xx03  LIKE ima_file.ima01,      #No.FUN-680121    #No.MOD-7A0159 modify
                xx05  LIKE bed_file.bed07,        #No.FUN-680121
                unalc LIKE bed_file.bed07         #No.FUN-680121
                END RECORD
   DEFINE l_name    LIKE type_file.chr20,       #No.FUN-680121
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
#         l_qq      LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(13,3)
          l_qq      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_sfb11   LIKE sfb_file.sfb11,          #No.B581 010523 BY ANN CHEN
          l_mark    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(01)
#         qty2      LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)
          qty2      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_i,l_j   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          sr     RECORD
                 mark       LIKE type_file.chr1,       #No.FUN-680121 VARCHAR(1)
                 bmb03      LIKE bmb_file.bmb03,       #料件編號
                 ima02      LIKE ima_file.ima02,       #規格說明
                 ima25      LIKE ima_file.ima25,       #庫存單位
                 xx05       LIKE sfa_file.sfa05,       #應發數量
#                use        LIKE ima_file.ima26,       #可用量
                 use        LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
                 minus      LIKE sfa_file.sfa05,       #缺料量
                 qty1       LIKE sfa_file.sfa03,       #在製量
                 qty2       LIKE sfa_file.sfa03,       #在外量
                 qty3       LIKE sfa_file.sfa03,       #在途量 -> 不用
                 qty4       LIKE sfa_file.sfa03,       #在驗量
                 unalc      LIKE sfa_file.sfa25        #未備料量
          END RECORD
   DEFINE l_ima910   LIKE ima_file.ima910         #FUN-550112
   DEFINE l_a        LIKE type_file.num5
   #FUN-940008--Begin add
   DEFINE l_sfa01     LIKE sfa_file.sfa01
   DEFINE l_sfa03     LIKE sfa_file.sfa03
   DEFINE l_sfa08     LIKE sfa_file.sfa08
   DEFINE l_sfa12     LIKE sfa_file.sfa12
   DEFINE l_sfa27     LIKE sfa_file.sfa27
   DEFINE l_sfa05     LIKE sfa_file.sfa05
   DEFINE l_sfa06     LIKE sfa_file.sfa06
   DEFINE l_sfa13     LIKE sfa_file.sfa13
   DEFINE l_short_qty LIKE sfa_file.sfa07
   DEFINE l_sfa07     LIKE sfa_file.sfa07
   DEFINE l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044   
   DEFINE l_sfa012    LIKE sfa_file.sfa012,  #FUN-A60027
          l_sfa013    LIKE sfa_file.sfa013   #FUN-A60027  
   #FUN-940008---End
   DEFINE l_sql2      STRING  #MOD-D20097
   
#No.FUN-750097-----------------start--------------                                                                                  
     CALL cl_del_data(l_table)                                                                                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                       
#    CALL cl_outnam('asfr580') RETURNING l_name
#No.FUN-750097-----------------end---------------- 
#No.FUN-550067-begin
   #LET g_len = 90
   #LET g_len = 95   #NO.TQC-5B0125 #FUN-650193
   LET g_len = 99    #FUN-650193
   FOR g_i = 1 TO g_len  LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550067-end
   SELECT zo02 INTO g_company FROM zo_file
                  WHERE zo01 = g_rlang
 
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file
                  WHERE zz01 = 'asfr580'
 
#  START REPORT asfr580_rep TO l_name                #No.FUN-750097
      FOR l_i = 1 TO g_bma.getLength()
          IF NOT cl_null(g_bma[l_i].bma01) THEN
#No.FUN-750097-------start--------------
             LET l_a = 1
#            OUTPUT TO REPORT asfr580_rep(g_bma[l_i].*)
             EXECUTE insert_prep USING
                     g_bma[l_i].ima02,'','',g_bma[l_i].qty,g_bma[l_i].bma01,g_bma[l_i].num,
                     g_bma[l_i].bma06,'','','','','','',
                     g_bma[l_i].cnt,'','','','',l_a 
#No.FUN-750097-------end-------------
             LET l_a = ' '
          END IF
      END FOR
#  FINISH REPORT asfr580_rep                         #No.FUN-750097
 
  #--No.FUN-560149
#  CALL cl_outnam('asfr580') RETURNING l_name2       #No.FUN-750097
   #LET l_name2 ='asfr580.ou1'
  #--end
#  START REPORT asfr580_rep2 TO l_name2              #No.FUN-750097
      #--->彙總相同成品編號生產總數
      FOR l_i = 1 TO g_bma.getLength()
          IF cl_null(g_bma[l_i].bma01) THEN CONTINUE FOR END IF
          FOR l_j = l_i+1 TO g_bma.getLength()
             IF cl_null(g_bma[l_j].bma01) THEN
             CONTINUE FOR
             END IF
             IF g_bma[l_i].bma01 = g_bma[l_j].bma01 THEN
                LET g_bma[l_i].qty = g_bma[l_i].qty + g_bma[l_j].qty
                INITIALIZE g_bma[l_j].* TO NULL
             END IF
          END FOR
      END FOR
      #--->下階備料資料產生
      FOR l_i = 1 TO g_bma.getLength()
         IF g_bma[l_i].bma01 IS NULL OR g_bma[l_i].bma01 = ' ' THEN
            CONTINUE FOR
         END IF
        #FUN-650193...............begin
        ##FUN-550112
        #LET l_ima910=''
        #SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=g_bma[l_i].bma01
        ##--
         LET l_ima910=g_bma[l_i].bma06
         IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
        #FUN-650193...............end
         DISPLAY 's_alloc:',l_i,'/',g_bma[l_i].bma01 AT 18,1
         CALL r580_alloc_bom(0,g_bma[l_i].bma01,l_ima910,g_bma[l_i].qty)  #FUN-550112 #TQC-7B0143
      END FOR
      #--->備料資料整理(考慮單位基準為庫存單位)
#No.FUN-940008---Begin
      DELETE FROM r580_tmp1
      LET l_sql = "SELECT sfa05,sfa06,sfa13,sfa03,sfa01,sfa08,sfa12,sfa27,sfa012,sfa013",   #FUN-A60027 add sfa012,sfa013
                  "  FROM sfa_file,sfb_file",
                  " WHERE sfa05 > sfa06 AND sfa01 = sfb01",
                  "   AND sfb04 != '8' AND sfb87! = 'X' AND sfb02!=11"
      #MOD-D20097---begin
      IF g_bma.getLength() > 0 THEN 
         LET l_sql2 = " AND sfb05 IN ("
         FOR l_i = 1 TO g_bma.getLength()
            IF l_i = 1 THEN 
               LET l_sql2 = l_sql2," '",g_bma[l_i].bma01,"' "
            ELSE
               LET l_sql2 = l_sql2," ,'",g_bma[l_i].bma01,"' "
            END IF 
         END FOR 
         LET l_sql2 = l_sql2," )"
         LET l_sql = l_sql,l_sql2
      END IF 
      #MOD-D20097---end
      PREPARE r580_tmp1_pre FROM l_sql
      DECLARE r580_tmp1_dec CURSOR FOR r580_tmp1_pre
      FOREACH r580_tmp1_dec INTO l_sfa05,l_sfa06,l_sfa13,l_sfa03,
                                 l_sfa01,l_sfa08,l_sfa12,l_sfa27,l_sfa012,l_sfa013            #FUN-A60027 add sfa012,sfa013
         CALL s_shortqty(l_sfa01,l_sfa03,l_sfa08,l_sfa12,l_sfa27,l_sfa012,l_sfa013)           #FUN-A60027 add sfa012,sfa013
              RETURNING l_short_qty
         LET l_sfa07 = l_short_qty
         IF l_sfa05 <= l_sfa06+l_sfa07 THEN
            CONTINUE FOREACH
         END IF
         IF l_sfa07 <= 0 THEN
            CONTINUE FOREACH                                                    
         END IF
         INSERT INTO r580_tmp1 VALUES(l_sfa05,l_sfa06,l_sfa13,l_sfa03)
         IF SQLCA.SQLCODE THEN CALL cl_err(1,sqlca.sqlcode,1) END IF
      END FOREACH
 
#     LET l_sql=" SELECT xx03,xx05,SUM((sfa05-sfa06)*sfa13)",
#               "   FROM r580_t3,",  #No.TQC-780056
#               " ( SELECT sfa05,sfa06,sfa13,sfa03",
#               "     FROM sfa_file, sfb_file",
#               "    WHERE sfa05 > sfa06 AND sfa01 = sfb01",
#               "      AND sfb04 != '8' AND sfb87! = 'X' AND sfb02!=11 ",
#               "      AND ((sfa_file.sfa05 > (sfa_file.sfa06+sfa_file.sfa07))",
#               "       OR (sfa_file.sfa07 > 0)))tmp",
#               " WHERE xx03 = tmp.sfa03(+) ",   #No.TQC-780056
#               " GROUP BY xx03,xx05"  
      LET l_sql = " SELECT xx03,xx05,SUM((sfa05-sfa06)*sfa13)",
                  "   FROM r580_t3",
                  "   LEFT OUTER JOIN r580_tmp1",
                  "     ON (r580_t3.xx03 = r580_tmp1.sfa03) ",
                  " GROUP BY xx03,xx05"
#No.FUN-940008---End
      PREPARE r580_p3 FROM l_sql
      DECLARE r580_c3 CURSOR FOR r580_p3
      FOREACH r580_c3 INTO l_tmp.*
        INSERT INTO r580_t2 values(l_tmp.*)
        IF SQLCA.SQLCODE THEN CALL cl_err(1,sqlca.sqlcode,1) END IF
      END FOREACH
      IF sqlca.sqlcode THEN CALL cl_err(0,sqlca.sqlcode,1) END IF 
#       ELSE
#          SELECT xx03,  xx05,  0 unalc
#            FROM r580_t3
#            INTO TEMP r580_t2
#      END IF
 
#     LET l_sql = " SELECT '',xx03, ima02,ima25,xx05 ,ima262,",  #NO.FUN-A20044 
      LET l_sql = " SELECT '',xx03, ima02,ima25,xx05 ,0,",       #NO.FUN-A20044 
                  " 0,0,0,0,0,unalc",
                  "  FROM r580_t2, OUTER ima_file", 
                  "  WHERE  r580_t2.xx03 = ima_file.ima01  "             #MOD-620078
        #          "  WHERE  r580_t2.xx03 = ima_file.ima01  "
      PREPARE out1_pre FROM l_sql
      DECLARE out1_cur CURSOR WITH HOLD FOR out1_pre
      LET l_count = 0
      FOREACH out1_cur INTO sr.*
         IF STATUS THEN CALL cl_err('for 1_cur:',STATUS,1) EXIT FOREACH END IF
         CALL s_getstock(sr.bmb03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
         LET sr.use = l_n3                                    #NO.FUN-A20044 
         #--->sr.qty1工單在製量 (需包含委外)
         SELECT SUM(sfb08-sfb09-sfb11) INTO sr.qty1
           FROM sfb_file
          WHERE sfb05 = sr.bmb03 AND sfb04 < '8'
            AND sfb02 NOT IN ('11')
            AND sfb08 > (sfb09+sfb11) AND sfb87!='X'
         IF sr.qty1 IS NULL THEN LET sr.qty1 = 0 END IF
 
         #--->sr.qty2在外量
        #SELECT SUM((pmn20-pmn50+pmn55)*pmn09) INTO sr.qty2   #No.MOD-810144 modify #FUN-940083
         SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO sr.qty2   #FUN-940083
           FROM pmn_file,pmm_file
          WHERE pmn04=sr.bmb03
            AND pmn01=pmm01
#           AND pmn20 > pmn50-pmn55       #No.FUN-9A0068 mark
            AND pmn20 > pmn50-pmn55-pmn58 #No.FUN-9A0068 
            AND pmn16 <='2'
            AND pmn011 !='SUB'
 
         IF sr.qty2 IS NULL THEN LET sr.qty2 = 0 END IF
 
         #--->qty4在驗量
         #------IQC在驗量
         SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO sr.qty4
           FROM rva_file,rvb_file,pmn_file
          WHERE rvb05 = sr.bmb03
            AND rvb01 = rva01 AND rvaconf <> 'X'
            AND rvb04 = pmn01
            AND rvb03 = pmn02
            AND rvb07 > (rvb29+rvb30)
 
         IF sr.qty4 IS NULL THEN LET sr.qty4 = 0 END IF
 
         #------FQC在驗量
#================================================================
#No.B581 010523 BY ANN CHEN
#FQC在驗量 可用 sfb11的值取得
         SELECT SUM(sfb11) INTO l_sfb11
            FROM sfb_file
           WHERE sfb05=sr.bmb03
             AND sfb04 <'8'
             #AND sfb02 <>'7' AND sfb87!='X'                   #No.MOD-5B0162 mark
             AND sfb02 <>'7' AND sfb02 <> '8' AND sfb87!='X'   #No.MOD-5B0162  add
#===============================================================
         IF cl_null(l_sfb11) THEN LET l_sfb11 = 0 ENd IF  #No.MOD-810174 add
         LET sr.qty4 = sr.qty4 + l_sfb11
 
         IF sr.unalc IS NULL OR sr.unalc = ' ' THEN LET sr.unalc = 0 END IF
         #--->是否僅列印缺料資料(可用量 - (原發數量 + 未備料量))
          LET l_qq = sr.use - (sr.xx05  + sr.unalc)
#         IF tm.c MATCHES '[yY]' THEN
         IF tm.c THEN
              LET sr.mark = 'N'
              IF l_qq >= 0 THEN CONTINUE FOREACH END IF
              LET sr.minus = l_qq * -1
         ELSE IF l_qq <= 0 THEN
                   LET sr.minus = l_qq * -1
                   LET sr.mark = 'Y'
              ELSE LET sr.mark = 'N'
                   LET sr.minus= 0
              END IF
         END IF
#No.FUN-750097----------------start--------------------------
#        OUTPUT TO REPORT asfr580_rep2(sr.*)
         LET l_count = l_count + 1
          LET l_a = 2
         EXECUTE insert_prep USING
                 '',sr.ima02,sr.ima25,'','','','',sr.bmb03,
                 l_count,sr.qty4,sr.xx05,sr.use,sr.minus,'',
                 sr.unalc,sr.qty1,sr.qty2,sr.mark,l_a
         LET l_a = ' '
   END FOREACH
#  FINISH REPORT asfr580_rep2                           #No.FUN-750097
#  LET l_cmd='cat ',l_name2,'>>',l_name,';rm ',l_name2  #No:9306
#  RUN l_cmd  WITHOUT WAITING
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
   LET g_str = ''                                                                                                                 
   CALL cl_prt_cs3('asfr580','asfr580',l_sql,g_str)
#No.FUN-750097----------------end----------------------------
END FUNCTION
 
#No.FUN-750097----------------start--------------------------
#{REPORT asfr580_rep(sr)
# DEFINE  sr  RECORD
#              cnt     LIKE type_file.num5,        #No.FUN-680121 SMALLINT
#              bma01   LIKE bma_file.bma01,
#              ima02   LIKE ima_file.ima02,
#              bma06   LIKE bma_file.bma06,        #FUN-650193
#              qty     LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(13,3)
#              num     LIKE bma_file.bma02         #No.FUN-680121 VARCHAR(16)#No.FUN-550067
#         END RECORD,
#         l_last_sw    LIKE type_file.chr1         #No.FUN-680121 VARCHAR(01)
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#   ORDER BY sr.bma01,sr.cnt
#   FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF cl_null(g_towhom) THEN
#          PRINT '';
#      ELSE
#          PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1] CLIPPED  #No.TQC-6A0087 add CLIPPED
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
#      #PRINT COLUMN 73,g_x[24] CLIPPED
#      #PRINT COLUMN 83,g_x[24] CLIPPED  #NO.TQC-5B0125
#      PRINT g_x[11] CLIPPED,
#            #COLUMN 6,g_x[12] CLIPPED,  #NO.TQC-5B0125
#            COLUMN 6,g_x[12] CLIPPED,'/',
#            #COLUMN 26,g_x[13] CLIPPED, #NO.TQC-5B0125
#            g_x[13] CLIPPED,
#            #COLUMN 58,g_x[14] CLIPPED,
#            #COLUMN 81,g_x[15] CLIPPED
#      #NO.TQC-5B0125
#            COLUMN 47,g_x[29] CLIPPED, #FUN-650193
#            COLUMN 68,g_x[14] CLIPPED, #FUN-650193 66->68
#            COLUMN 84,g_x[24] CLIPPED,g_x[15] CLIPPED #FUN-650193 81->84
#      PRINT "---- ----------------------------------------",
#            " -------------------- --------------- ----------------"
#      #NO.TQC-5B0125
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
##      PRINT COLUMN 01,sr.cnt  USING'##&',' ',
##            COLUMN 05,sr.bma01 CLIPPED,' ',
##            COLUMN 26,sr.ima02 CLIPPED,' ',
##            COLUMN 57,sr.qty USING'########&.&&&',' ',
##            COLUMN 71,sr.num
##NO.TQC-5B0125 START---
#       PRINT COLUMN 01,sr.cnt USING '###&',' ', #FUN-590118
#             COLUMN 06,sr.bma01 CLIPPED,' ',
#             COLUMN 47,sr.bma06 CLIPPED,' ',
#             COLUMN 68,cl_numfor(sr.qty,14,3),' ',
#             COLUMN 84,sr.num
#       PRINT COLUMN 06,sr.ima02 CLIPPED
# 
#ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#          SKIP 2 LINE
#      END IF
#END REPORT
# 
#REPORT asfr580_rep2(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,            #No.FUN-680121 VARCHAR(1)
#          sr     RECORD
#                 mark       LIKE type_file.chr1,       #No.FUN-680121 VARCHAR(1)
#                 bmb03      LIKE bmb_file.bmb03,       #料件編號
#                 ima02      LIKE ima_file.ima02,       #規格說明
#                 ima25      LIKE ima_file.ima25,       #庫存單位
#                 xx05       LIKE sfa_file.sfa05,       #應發數量
#                 use        LIKE ima_file.ima26,       #可用量
#                 minus      LIKE sfa_file.sfa05,       #缺料量
#                 #No.B017 010326 by plum 因ima7*已改為其他用途,在此改成別的變數
##                ima75      DECIMAL(12,3),             #在製量
##                ima76      DECIMAL(12,3),             #在外量
##                ima77      DECIMAL(12,3),#在途量
##                ima78      DECIMAL(12,3), #在驗量
#                 qty1       LIKE sfa_file.sfa03,       #在製量
#                 qty2       LIKE sfa_file.sfa03,       #在外量
#                 qty3       LIKE sfa_file.sfa03,       #在途量 -> 不用
#                 qty4       LIKE sfa_file.sfa03,       #在驗量
#                #No.B017..end
#                 unalc      LIKE sfa_file.sfa25        #未備料量
#          END RECORD,
#          l_unalc       LIKE sfa_file.sfa25,
#          l_qq          LIKE sfa_file.sfa25,
#          l_cnt         LIKE type_file.num5          #No.FUN-680121 SMALLINT
#
#   OUTPUT  TOP MARGIN g_top_margin
#           LEFT MARGIN g_left_margin
#           BOTTOM MARGIN g_bottom_margin
#           PAGE LENGTH g_page_line
#
#   ORDER BY sr.bmb03
#   FORMAT
#   PAGE HEADER
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF cl_null(g_towhom) THEN
#          PRINT '';
#      ELSE
#          PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
#      PRINT g_x[11] CLIPPED,
#            COLUMN  6,g_x[16] CLIPPED,
##NO.TQC-5B0125 START------
#            #COLUMN 28,g_x[17] CLIPPED,
#            #COLUMN 39,g_x[18] CLIPPED,
#            #COLUMN 50,g_x[19] CLIPPED,
#            #COLUMN 61,g_x[23] CLIPPED,
#            #COLUMN 72,g_x[20] CLIPPED
#            COLUMN 38,g_x[17] CLIPPED,
#            COLUMN 49,g_x[18] CLIPPED,
#            COLUMN 60,g_x[19] CLIPPED,
#            COLUMN 71,g_x[23] CLIPPED,
#            COLUMN 82,g_x[20] CLIPPED
##NO.TQC-5B0125 END----
#      PRINT COLUMN  6,g_x[13] CLIPPED,
##NO.TQC-5B0125 START----
#            #COLUMN 50,g_x[27] CLIPPED,
#            #COLUMN 61,g_x[22] CLIPPED,
#            #COLUMN 72,g_x[21] CLIPPED
#            COLUMN 60,g_x[27] CLIPPED,
#            COLUMN 71,g_x[22] CLIPPED,
#            COLUMN 82,g_x[21] CLIPPED
#      #PRINT '---- -------------------- ---------- ---------- ',
#      PRINT '---- ------------------------------ ---------- ---------- ',
##NO.TQC-5B0125 END---
#            '---------- ---------- ----------'
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#      LET l_count = l_count + 1
#      IF sr.mark ='Y' THEN PRINT '*'; END IF
#      PRINT COLUMN 2,l_count USING'##&',                 #項次
#            COLUMN 6,sr.bmb03 CLIPPED,                   #料件編號
#            #COLUMN 27,sr.xx05  USING '------&.&&',' ',  #應發量  #NO.TQC-5B0125 MARK
#            COLUMN 37,sr.xx05  USING '------&.&&',' ',  #應發量
#                      sr.use   USING '------&.&&',' ',  #可用量
#                      sr.minus USING '------&.&&',' ',  #缺料量
#                      sr.qty4  USING '------&.&&',' ',  #在驗量
#                      sr.qty1  USING '------&.&&'       #在製量
#      PRINT COLUMN 6,sr.ima02 CLIPPED,' ',              #品名規格
#                     sr.ima25 CLIPPED,                  #庫存單位
#            #COLUMN 49,sr.unalc USING '------&.&&',      #工單未備量 #NO.TQC-5B0125 MARK
#            COLUMN 59,sr.unalc USING '------&.&&',      #工單未備量
#            #No.B581 010523 BY ANN CHEN
#            #COLUMN 60,sr.qty2 USING '------&.&&',' ',  #在外量
#            #          sr.qty3 USING '------&.&&'       #在途量
#            #COLUMN 60,sr.qty2  USING '------&.&&'      #NO.TQC-5B0125 MARK
#            COLUMN 70,sr.qty2  USING '------&.&&'
#
#   ON LAST ROW
##     PRINT g_chr2 CLIPPED      #No:8509
#      PRINT g_x[28] CLIPPED
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
##         PRINT g_chr2 CLIPPED  #No:8509
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#          SKIP 2 LINE           #No:8509
#      END IF
#END REPORT}
#No.FUN-750097----------------end----------------------------
 
#FUNCTION alloc_bom(p_level,p_key,p_key2,p_total)  #FUN-550112 #TQC-7B0143
FUNCTION r580_alloc_bom(p_level,p_key,p_key2,p_total)  #FUN-550112 #TQC-7B0143
#No.FUN-A70034  --Begin
   DEFINE l_total_1    LIKE sfa_file.sfa05     #总用量
   DEFINE l_QPA        LIKE bmb_file.bmb06     #标准QPA
   DEFINE l_ActualQPA  LIKE bmb_file.bmb06     #实际QPA
#No.FUN-A70034  --End  
DEFINE
	p_level LIKE type_file.num5,        #No.FUN-680121 SMALLINT#階層
	p_key   LIKE bma_file.bma01,        #料件
        p_key2	LIKE ima_file.ima910,       #FUN-550112
	p_total LIKE csb_file.csb05,        #No.FUN-680121 DECIMAL(13,5)#總數
	sr DYNAMIC ARRAY OF RECORD
		bmb02 LIKE bmb_file.bmb02,              #項次
		bmb03 LIKE bmb_file.bmb03,              #元件
		bmb10 LIKE bmb_file.bmb10,              #發料單位
		bmb10_fac LIKE bmb_file.bmb10_fac,      #發料/料件主檔
		bmb06 LIKE bmb_file.bmb06,              #組成用量
		bmb08 LIKE bmb_file.bmb08,              #損耗率
		bmb16 LIKE bmb_file.bmb16,              #取/替代特性
		ima08 LIKE ima_file.ima08,              #來源碼
		ima25 LIKE ima_file.ima25,              #庫存單位
		ima37 LIKE ima_file.ima37,              #補貨政策
		ima64 LIKE ima_file.ima64,              #發料倍量
		ima641 LIKE ima_file.ima641,            #最少發料量
		bma01 LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)#是否有bom
                level LIKE type_file.num5,                  #No.FUN-680121 SMALLINT
                #No.FUN-A70034  --Begin
                bmb081 LIKE bmb_file.bmb081,
                bmb082 LIKE bmb_file.bmb082 
                #No.FUN-A70034  --End  
	END RECORD,
    b_seq       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    arrno       LIKE type_file.num10,         #No.FUN-680121 INTEGER
    l_pan       LIKE ima_file.ima64,
    l_double    LIKE type_file.num10,         #No.FUN-680121 INTEGER
    l_tot,l_i   LIKE type_file.num10,         #No.FUN-680121 INTEGER
    l_times     LIKE type_file.num10,         #No.FUN-680121 INTEGER
    l_cmd       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1100)
    l_totqty    LIKE sfa_file.sfa05,
    l_total     LIKE sfa_file.sfa25
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
	IF p_level > 20 THEN
		CALL cl_err('','mfg2733',1) 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   EXIT PROGRAM
   
    END IF
    LET p_level = p_level + 1
    LET arrno   = 600
	LET l_times = 1
    LET b_seq   = 0
    WHILE TRUE
        LET l_cmd=
    	   "SELECT bmb02,bmb03,bmb10,bmb10_fac,",
           "(bmb06/bmb07),bmb08,bmb16,ima08,ima25,",
           " ima37,ima64,ima641,bma01,0,",
           " bmb081,bmb082 ",    #No.FUN-A70034
           " FROM bmb_file,OUTER ima_file,OUTER bma_file",
           " WHERE bmb01='", p_key,"' ",
           "   AND bmb02 > '",b_seq,"'",
           "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
           "   AND  bma_file.bma01 = bmb_file.bmb03   AND  ima_file.ima01 = bmb_file.bmb03  ",
           "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)  ",
           "   AND (bmb05 >'",g_today,"' OR bmb05 IS NULL)",
           " ORDER BY bmb02"
       PREPARE alloc_ppp FROM l_cmd
       IF SQLCA.sqlcode THEN
          CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
       DECLARE alloc_cur CURSOR FOR alloc_ppp
 
       LET l_ac = 1
       FOREACH alloc_cur INTO sr[l_ac].*
	    	LET g_total=g_total+1
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END-- 
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF
       END FOREACH
       LET l_tot=l_ac-1
       FOR l_i = 1 TO l_tot
          #No.FUN-A70034  --Begin
          CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,0)
               RETURNING l_total_1,l_QPA,l_ActualQPA
          #No.FUN-A70034  --End  

          #---------No.FUN-670041 modify
          #IF sr[l_i].ima08 = 'X' AND g_sma.sma29 ='Y' THEN
           IF sr[l_i].ima08 = 'X' THEN
          #---------No.FUN-670041 end
             #CALL r580_alloc_bom(p_level,sr[l_i].bmb03,' ',p_total*sr[l_i].bmb06)  #FUN-550112 #TQC-7B0143#FUN-8B0035
              #No.FUN-A70034  --Begin
              #CALL r580_alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],p_total*sr[l_i].bmb06)  #FUN-8B0035
              CALL r580_alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_total_1)
              #No.FUN-A70034  --End  
           ELSE
              #--->原發數量 = BOM 中的標準用量 + 損耗率
              #No.FUN-A70034  --Begin
              #LET l_total  = (p_total * sr[l_i].bmb06 * sr[l_i].bmb10_fac)
              #                       *  ( 1 + (sr[l_i].bmb08/100))
              LET l_total  = l_total_1 * sr[l_i].bmb10_fac
              #No.FUN-A70034  --End  
              IF l_total IS NULL OR l_total = ' ' THEN LET l_total = 0 END IF
{
#modify 目前暫不考慮 by apple
              #--->考慮最小發料數量
              IF l_totqty  < sr[l_i].ima641
              THEN LET l_total = sr[l_i].ima641
              ELSE LET l_total = l_totqty
              END IF
 
              #--->考慮發料倍量
              IF sr[l_i].ima64 > 0
              THEN LET l_pan = (l_total MOD sr[l_i].ima64)
                   IF l_pan !=0
                   THEN LET l_double=(l_totqty /sr[l_i].ima64) + 1
                   ELSE LET l_double= l_totqty /sr[l_i].ima64
                   END IF
                   LET l_total  = l_double * sr[l_i].ima64
              ELSE LET l_total = l_totqty
              END IF
}
              INSERT INTO r580_t3 VALUES(sr[l_i].bmb03,l_total)
              IF SQLCA.sqlcode THEN
                 UPDATE r580_t3   SET xx05  = xx05  + l_total
                  WHERE xx03  = sr[l_i].bmb03
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                   CALL cl_err('ckp# error',SQLCA.sqlcode,1)   #No.FUN-660128
                    CALL cl_err3("upd","r580_t3",sr[l_i].bmb03,"",SQLCA.sqlcode,"","ckp# error",1)    #No.FUN-660128
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                    EXIT PROGRAM
                 END IF
              END IF
          END IF
      END FOR
      # BOM單身已讀完
      IF l_tot < arrno OR l_tot=0 THEN
         EXIT WHILE
      ELSE
         LET b_seq = sr[l_tot].bmb02
         LET l_times=l_times+1
      END IF
  END WHILE
END FUNCTION
 
FUNCTION r580_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用        #No.FUN-680121 SMALLINT
    l_modify_flag   LIKE type_file.chr1,                 #單身更改否        #No.FUN-680121 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,          #處理狀態      #No.FUN-680121 VARCHAR(1)
    l_insert        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#可新增否
    l_update        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#可更改否 (含取消)
    l_possible      LIKE type_file.num5,          #No.FUN-680121 SMALLINT#用來設定判斷重複的可能性
    l_cnt           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_pt            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    i,j             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_jump          LIKE type_file.num5,          #No.FUN-680121 SMALLINT#判斷是否跳過AFTER ROW的處理
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET bst = '3'  #CHI-C20050
    LET l_ac_t = 0
    #CHI-C20050---begin
    INPUT BY NAME bst WITHOUT DEFAULTS
       ON ACTION locale
          CALL cl_dynamic_locale()    
          CALL cl_show_fld_cont()                   
          LET g_action_choice = "locale"

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about         
          CALL cl_about()

       ON ACTION help          
          CALL cl_show_help()    
    END INPUT  
    #CHI-C20050---end
    WHILE TRUE
        CALL g_bma.clear()
        CALL g_bma_t.clear()
        LET l_exit_sw = "y"                #正常結束,除非 ^N
        LET g_bma_pageno = 1
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bma WITHOUT DEFAULTS FROM s_bma.*
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        ON ACTION locale
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT INPUT
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET g_bma_t[l_ac].* = g_bma[l_ac].*          # 900423
            LET l_lock_sw = 'N'                          #DEFAULT
            LET l_n  = ARR_COUNT()
 
            LET p_cmd='a'  #輸入新資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnt		
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bma[l_ac].* TO NULL      #900423
            LET g_bma_t[l_ac].* = g_bma[l_ac].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnt		
 
        BEFORE FIELD cnt                          #default 項次
            IF g_bma[l_ac].cnt IS NULL OR g_bma[l_ac].cnt = 0 THEN
               LET l_pt = 'N'
               LET g_bma[l_ac].cnt = 1
               FOR i = 1 TO g_bma.getLength()
                   IF cl_null(g_bma[i].cnt)  OR i = l_ac THEN
                      CONTINUE FOR
                   ELSE
                      IF g_bma[i].cnt >= g_bma[l_ac].cnt THEN
                         LET g_bma[l_ac].cnt = g_bma[i].cnt
                         LET l_pt = 'Y'
                      END IF
                   END IF
               END FOR
               IF l_pt = 'Y' THEN
                  LET g_bma[l_ac].cnt = g_bma[l_ac].cnt + 1
               END IF
            END IF
 
       #BEFORE FIELD qty #FUN-650193
        AFTER FIELD bma01 #FUN-650193
           IF NOT cl_null(g_bma[l_ac].bma01) OR NOT cl_null(g_bma_t[l_ac].bma01) THEN   #MOD-BC0312 add
            IF cl_null(g_bma[l_ac].bma01) THEN
               LET g_bma[l_ac].bma01 = g_bma_t[l_ac].bma01
               DISPLAY BY NAME g_bma[l_ac].bma01 #FUN-650193 add
               NEXT FIELD bma01
            END IF
            #--->讀取品名規格
            SELECT ima02 INTO g_bma[l_ac].ima02 FROM ima_file
                            WHERE ima01 = g_bma[l_ac].bma01
            IF SQLCA.sqlcode THEN
               LET g_bma[l_ac].bma01 = g_bma_t[l_ac].bma01
               DISPLAY BY NAME g_bma[l_ac].bma01 #FUN-650193 add
               LET g_bma[l_ac].ima02 = g_bma_t[l_ac].ima02
               DISPLAY BY NAME g_bma[l_ac].ima02 #FUN-650193 add
#              CALL cl_err('','mfg3403',0)   #No.FUN-660128
               CALL cl_err3("sel","ima_file","g_bma[l_ac].bma01","","mfg3403","","",0)    #No.FUN-660128
               NEXT FIELD bma01
            END IF
            DISPLAY BY NAME g_bma[l_ac].ima02 #FUN-650193 add
            #--->檢查是否存在於BOM 單頭檔
            IF bst = '3' THEN  #CHI-C20050
               SELECT COUNT(*) INTO l_cnt FROM bma_file
                               WHERE bma01 = g_bma[l_ac].bma01
            #CHI-C20050---begin
            END IF
            IF bst = '1' THEN
               SELECT COUNT(*) INTO l_cnt FROM bma_file
                               WHERE bma01 = g_bma[l_ac].bma01
                               AND bma10 = '0'
            END IF 
            IF bst = '2' THEN
               SELECT COUNT(*) INTO l_cnt FROM bma_file
                               WHERE bma01 = g_bma[l_ac].bma01
                               AND bma10 <> '0'
            END IF 
            #CHI-C20050---end            
            IF l_cnt = 0 THEN
               IF bst = '3' THEN  #CHI-C20050
                  CALL cl_err('','mfg3399',0)
               #CHI-C20050---begin
               END IF
               IF bst = '1' THEN
                  CALL cl_err('','asf-281',0)
               END IF 
               IF bst = '2' THEN
                  CALL cl_err('','asf-282',0)
               END IF 
               #CHI-C20050---end 
               LET g_bma[l_ac].bma01 = g_bma_t[l_ac].bma01
               DISPLAY BY NAME g_bma[l_ac].bma01 #FUN-650193 add
               NEXT FIELD bma01
            END IF
            #FUN-650193...............begin
            SELECT ima910 INTO g_bma[l_ac].bma06 FROM ima_file 
               WHERE ima01=g_bma[l_ac].bma01
            DISPLAY BY NAME g_bma[l_ac].bma06
            #FUN-650193...............end
           END IF    #MOD-BC0312 add
 
        AFTER FIELD qty
           IF NOT cl_null(g_bma[l_ac].qty) THEN   #MOD-BC0312 add
            IF g_bma[l_ac].qty <= 0 OR cl_null(g_bma[l_ac].qty)
            THEN CALL cl_err('','mfg3400',0)
                 NEXT FIELD qty
             END IF
           END IF   #MOD-BC0312 add
 
        BEFORE DELETE                            #是否取消單身
            IF g_bma[l_ac].bma01 > 0 THEN
#              IF NOT s_delarr(0,0) THEN
               IF (NOT cl_delete()) THEN
                  CANCEL DELETE
#                 LET l_exit_sw = "n"
#                 LET l_ac_t = l_ac
#                 EXIT INPUT
               END IF
            END IF
 
       #MOD-BC0312 -- begin --
        AFTER INSERT
           IF cl_null(g_bma[l_ac].bma01) AND
              cl_null(g_bma[l_ac].qty)   THEN
              CALL g_bma.deleteElement(l_ac)
              CANCEL INSERT
           END IF
       #MOD-BC0312 -- end --

        AFTER ROW
           #IF NOT l_jump THEN                  #MOD-BC0312 mark
            IF g_bma.getLength() >= l_ac THEN   #MOD-BC0312 add
                IF g_bma[l_ac].bma01 IS NULL THEN
                    INITIALIZE g_bma[l_ac].* TO NULL
                END IF
                IF g_bma[l_ac].qty IS NULL OR g_bma[l_ac].qty <=0
                THEN
                    INITIALIZE g_bma[l_ac].* TO NULL
                END IF
                IF p_cmd='u' THEN
                   LET g_bma_t[l_ac].* = g_bma[l_ac].*          # 900423
                END IF
            END IF
 
 
        ON ACTION CONTROLN
            LET l_exit_sw = "n"
            EXIT INPUT
 
        ON ACTION CONTROLE        # 遇不可空白欄位可 cursor up
           IF INFIELD(qty) THEN NEXT FIELD bma01 END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bma01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = 'q_bma'
                     LET g_qryparam.default1 = g_bma[l_ac].bma01
                     CALL cl_create_qry() RETURNING g_bma[l_ac].bma01
                      DISPLAY BY NAME g_bma[l_ac].bma01  #No.MOD-490371
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
           ON ACTION exit
              LET INT_FLAG = 1
              EXIT INPUT
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        END INPUT
 
        IF g_action_choice = "locale" THEN
           LET g_action_choice = ""
           CALL cl_dynamic_locale()
           CONTINUE WHILE
        END IF
 
        IF INT_FLAG THEN
           #LET INT_FLAG = 0 #TQC-5A0036
           EXIT WHILE
        END IF
{
        LET g_chr = NULL
        WHILE g_chr IS NULL OR g_chr NOT MATCHES "[12]"
            LET INT_FLAG = 0  ######add for prompt bug
           PROMPT "(1)SAVE (2)NOT SAVE:" FOR CHAR g_chr
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
#                 CONTINUE PROMPT
 
           END PROMPT
        END WHILE
        IF g_chr = '1' THEN
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
           DELETE FROM bmz_file
           FOR g_i = 1 TO 200
              IF g_bma[g_i].bma01 IS NULL THEN CONTINUE FOR END IF
              INSERT INTO bmz_file (bmz01,bmz02,bmz03
                                   ,bmz05,bmz011,bmz012,bmz013)    #FUN-A70125 add
                 VALUES (g_bma[g_i].bma01,g_bma[g_i].qty,g_bma[g_i].num
                        ,'1',' ',' ',0)   #FUN-A70125 add
           END FOR
        END IF
}
        IF l_exit_sw = "y" THEN
            EXIT WHILE                     #ESC 或 DEL 結束 INPUT
        ELSE
            CONTINUE WHILE                 #^N 結束 INPUT
        END IF
    END WHILE
 
END FUNCTION
 
FUNCTION r580_b_fill()
   DEFINE i LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DECLARE r580_bc CURSOR FOR
       SELECT 0,bmz01,ima02,bmz02,bmz03
         FROM bmz_file, OUTER ima_file
         WHERE  bmz_file.bmz01 = ima_file.ima01 
         ORDER BY 1
   LET i = 1
   FOREACH r580_bc INTO g_bma[i].*
     IF STATUS THEN EXIt FOREACH END IF
     LET g_bma[i].cnt = i
     LET g_bma_t[i].* = g_bma[i].*
     LET i = i+1
     IF i > 200 THEN EXIT FOREACH END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   CALL g_bma.deleteElement(i)
   CALL SET_COUNT(i-1)
END FUNCTION
#Patch....NO.TQC-610037 <001> #
