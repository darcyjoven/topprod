# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmr855.4gl
# Descriptions...: 產品結構替換模擬查詢列印
# Input parameter:
# Return code....:
# Date & Author..: 91/08/22 By Lin
#                : 91/10/09 By Lin 修改
#  修改說明:1. 因為發現使用TEMP TABLE時,若執行相同的選擇條件二次以上,
#              程式執行結果將不正確, 因此改在database 中直接開兩個
#              TABLE (abmr855_t1,abmr855_t2) 讓此程式使用.
#           2. 庫存量已加入程式中 91/10/14 Lin
#           3. 加入被替換主件之退料元件資料列印  91/11/15 Lin
#           4. 加上發料單位對庫存單位的轉換(報表皆以庫存單位為轉換單位) 91/11/20
#           5. 程式採用先乘以'替換數量',再乘以轉換因子,如此誤差會較小 91/11/20
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: #No.FUN-550032 05/05/17 by wujie  單據編號加大
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-550093 05/06/03 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-560074 05/06/16 By pengu  CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560094 05/06/18 By kim 查詢時, 輸入主件編號還未輸入特性代碼即show BOM不存在
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-5C0008 05/12/08 By Claire 頁數未顯示
# Modify.........: No.CHI-6A0034 07/01/29 By jamie abmq655->abmr855 
# Modify.........: No.FUN-7A0071 08/04/07 By jamie 1.原產品結構 "主件料件編號" 2.新產品結構 "替換主件料件編號"增加開窗查詢功能
# Modify.........: NO.FUN-850045 08/05/14 By zhaijie 老報表修改為CR
# Modify.........: No.FUN-870144 08/07/29 By zhaijie過單
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910  
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/20 By lilingyu r.c2 fail
# Modify.........: No.FUN-A20044 10/03/19 By vealxu ima26x 調整
# Modify.........: No.FUN-A40023 10/04/12 By vealxu ima26x 調整補充
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
#CHI-6A0034 add
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD				# Print condition RECORD
		wc  	  VARCHAR(500),		# Where condition
                bma01   LIKE bma_file.bma01,    #被換主件料件編號
                ima02   LIKE ima_file.ima02,    #品名規格
                bma06_1 LIKE bma_file.bma06,    #FUN-550093
                bma02   LIKE bma_file.bma02,    #最近工程變異單單號
                bma03   LIKE bma_file.bma03,    #最近工程變異日期
                bmx07   LIKE bmx_file.bmx07,    #生效日期
                bmx08   LIKE bmx_file.bmx08,    #失效日期
                vdate1  DATE,                   #有效日期
                bma01b  LIKE bma_file.bma01,    #替換主件料件編號
                ima02b  LIKE ima_file.ima02,    #品名規格
                bma06_2 LIKE bma_file.bma06,    #FUN-550093
                bma02b  LIKE bma_file.bma02,    #最近工程變異單單號
                bma03b  LIKE bma_file.bma03,    #最近工程變異日期
                bmx07b  LIKE bmx_file.bmx07,    #生效日期
                bmx08b  LIKE bmx_file.bmx08,    #失效日期
                vdate2  DATE,                   #有效日期
                x       INTEGER,                #替換數量
                f       VARCHAR(1)                 #僅印缺料否
              END RECORD,
          g_bma01         LIKE bma_file.bma01,  #產品結構單頭
          g_bma01_a       LIKE bma_file.bma01,  #產品結構單頭
          g_bma06_1       LIKE bma_file.bma06,  #FUN-550093
          g_bma06_2       LIKE bma_file.bma06   #FUN-550093
 
DEFINE   g_chr           VARCHAR(1)
DEFINE   g_i             SMALLINT   #count/index for any purpose
#NO.FUN-850045--start---
DEFINE   g_sql     STRING
DEFINE   g_str     STRING
DEFINE   l_table   STRING 
#NO.FUN-850045---end---
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add-- 
   CALL x_tm(0,0)			# Input print condition
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
END MAIN
 
FUNCTION x_tm(p_row,p_col)
   DEFINE   p_row,p_col	  SMALLINT,
            l_one         VARCHAR(01),          	#資料筆數
            l_flag        VARCHAR(1),               #判斷必要欄位是否有輸入
            l_bmate       DATE,              	#工程變異之生效日期
            l_bmb01       LIKE bmb_file.bmb01,	#工程變異之生效日期
            l_cmd	  VARCHAR(1000)
 
 
   LET p_row = 3
   LET p_col = 2
 
   OPEN WINDOW r855_w AT p_row,p_col WITH FORM "abm/42f/abmr855"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#NO.FUN-850045--start---
    LET g_sql = "p_cmd.type_file.chr10,",
                "p_bmb03.bmb_file.bmb03,",
                "p_ima02.ima_file.ima02,",
                "p_total.bmb_file.bmb06,",
                "p_store.bmb_file.bmb06,",
                "l_ima02.ima_file.ima02,",
                "l_ima02b.ima_file.ima02,",
                "l_ima25.ima_file.ima25"
    LET l_table = cl_prt_temptable('abmr855',g_sql) CLIPPED
    IF l_table = -1 THEN
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM
    END IF   
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
       EXIT PROGRAM
    END IF
#NO.FUN-850045---end--- 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06_1,bma06_2",g_sma.sma118='Y')
    #FUN-560021................end
 
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.vdate1 = g_today	#被換主件有效日期
   LET tm.vdate2 = g_today	#替換主件有效日期
   LET tm.x=1                   #替換數量
   LET tm.f='N'    #僅印缺料否
 
   WHILE TRUE
      DISPLAY BY NAME tm.vdate1,tm.vdate2,tm.x,tm.f
 
      INPUT BY NAME tm.bma01,tm.bma06_1,tm.vdate1,tm.bma01b,tm.bma06_2, #FUN-550093
                    tm.vdate2,tm.x,tm.f WITHOUT DEFAULTS
     ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        #FUN-7A0071---add---str---
         ON ACTION controlp
            CASE
              WHEN INFIELD(bma01) #主件料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_bma9"
                 CALL cl_create_qry() RETURNING tm.bma01,tm.bma02
                 DISPLAY tm.bma01,tm.bma02 TO formonly.bma01,formonly.ima02
                 NEXT FIELD bma01
              
              WHEN INFIELD(bma01b) #替換主件料件編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bma9"
                 CALL cl_create_qry() RETURNING tm.bma01b,tm.bma02b 
                 DISPLAY tm.bma01b,tm.bma02b TO formonly.bma01b,formonly.ima02b
                 NEXT FIELD bma01b
            END CASE 
 
        #FUN-7A0071---add---end---
 
         BEFORE FIELD bma01
            IF g_sma.sma60 = 'Y' THEN		# 若須分段輸入
               CALL s_inp5(7,21,tm.bma01)
               RETURNING tm.bma01
               DISPLAY BY NAME tm.bma01
            END IF
 
         AFTER FIELD bma01      #被替換的主件
            IF tm.bma01 IS NULL  THEN
               NEXT FIELD bma01
            ELSE
               LET g_chr=""
               CALL r855_bma01(tm.bma01,'1',' ') #FUN-560094
               IF g_chr='E' THEN
                  CALL cl_err(' ','mfg2602',0)
                  NEXT FIELD bma01
               END IF
            END IF
 
         BEFORE FIELD bma01b
            IF g_sma.sma60 = 'Y' THEN		# 若須分段輸入
               CALL s_inp5(14,21,tm.bma01b)
               RETURNING tm.bma01b
               DISPLAY BY NAME tm.bma01b
            END IF
 
         AFTER FIELD bma01b        #替換的主件
            IF tm.bma01b IS NULL  THEN
               NEXT FIELD bma01b
            ELSE
               IF g_sma.sma118!='Y' THEN
                  IF tm.bma01=tm.bma01b THEN
                     CALL cl_err(' ','mfg2713',0)
                     NEXT FIELD bma01b
                  END IF
               END IF
               LET g_chr=""
               CALL r855_bma01(tm.bma01b,'2',' ') #FUN-560094
               IF g_chr='E' THEN
                  CALL cl_err(' ','mfg2602',0)
                  NEXT FIELD bma01b
               END IF
            END IF
 
         #FUN-560094................begin
         AFTER FIELD bma06_1
            IF cl_null(tm.bma06_1) THEN
               LET tm.bma06_1=' '
            END IF
            LET g_chr=""
            CALL r855_bma01(tm.bma01,'1',tm.bma06_1) #FUN-560094
            IF g_chr='E' THEN
               CALL cl_err(' ','mfg2602',0)
               NEXT FIELD bma01
            END IF
 
         AFTER FIELD bma06_2
            IF g_sma.sma118='Y' THEN
               IF (tm.bma01=tm.bma01b) AND (tm.bma06_1=tm.bma06_2) THEN
                  CALL cl_err(' ','mfg2713',0)
                  NEXT FIELD bma01b
               END IF
            END IF
            IF cl_null(tm.bma06_2) THEN
               LET tm.bma06_2=' '
            END IF
            LET g_chr=""
            CALL r855_bma01(tm.bma01b,'2',tm.bma06_2) #FUN-560094
            IF g_chr='E' THEN
               CALL cl_err(' ','mfg2602',0)
               NEXT FIELD bma01b
            END IF
         #FUN-560094................end
 
         AFTER FIELD x          #替換數量
            IF tm.x IS NULL OR tm.x <= 0  OR tm.x=' ' THEN
               NEXT FIELD x
            END IF
 
         AFTER FIELD f          #僅印缺料否
            IF tm.f NOT MATCHES '[YN]'  OR tm.f IS NULL THEN
               NEXT FIELD f
            END IF
 
         AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF tm.bma01 IS NULL  THEN   #被替換的主件
               LET l_flag='Y'
               DISPLAY tm.bma01 TO FORMONLY.bma01
            END IF
            #FUN-560094................begin
           #IF tm.bma01b IS NULL  OR tm.bma01=tm.bma01b THEN  #替換的主件
           #   LET l_flag='Y'
           #   DISPLAY tm.bma01b TO FORMONLY.bma01b
           #END IF
            IF g_sma.sma118!='Y' THEN
               IF tm.bma01b IS NULL  OR tm.bma01=tm.bma01b THEN  #替換的主件
                  LET l_flag='Y'
                  DISPLAY tm.bma01b TO FORMONLY.bma01b
               END IF
            ELSE
               IF (tm.bma01b IS NULL)  OR ((tm.bma01=tm.bma01b) AND (tm.bma06_1=tm.bma06_2)) THEN  #替換的主件
                  LET l_flag='Y'
                  DISPLAY tm.bma01b TO FORMONLY.bma01b
               END IF
            END IF
            #FUN-560094................end
            IF tm.x IS NULL OR tm.x <= 0  OR tm.x=' ' THEN   #替換數量
               LET l_flag='Y'
               DISPLAY tm.x TO FORMONLY.x
            END IF
            IF tm.f NOT MATCHES '[YN]'  OR tm.f IS NULL THEN #僅印缺料否
               LET l_flag='Y'
               DISPLAY tm.f TO FORMONLY.f
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD bma01
            END IF
            #FUN-560094................begin
            IF cl_null(tm.bma06_1) THEN
               LET tm.bma06_1=' '
            END IF
            IF cl_null(tm.bma06_2) THEN
               LET tm.bma06_2=' '
            END IF
            #FUN-560094................end
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r855_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
         EXIT PROGRAM
      END IF
      IF cl_sure(21,20) THEN    #是否確定執行本作業
         CALL cl_wait()
         CALL r855()
      ELSE
         CLEAR FORM
         CONTINUE WHILE
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW r855_w
END FUNCTION
 
FUNCTION r855_bma01(t_bma01,l_chr,p_acode) #FUN-560094
   DEFINE  t_bma01 LIKE bma_file.bma01,
           l_chr  VARCHAR(01),  #判斷是'被換主件' 或 '替換主件'
           l_ima02    LIKE   ima_file.ima02,  #品名規格
           l_bma02    LIKE   bma_file.bma02,  #最近工程變異單單號
           l_bma01    LIKE   bma_file.bma01,  #被換主件料件編號
           l_bma03    LIKE   bma_file.bma03,  #最近工程變異日期
           p_acode    LIKE   bma_file.bma06,  #FUN-560094
           l_sql      STRING,                 #FUN-560094
           l_imaacti  LIKE   ima_file.imaacti
   LET g_chr=' '
   IF cl_null(p_acode) THEN LET p_acode=' ' END IF
   SELECT ima02,imaacti      #品名規格
          INTO l_ima02,l_imaacti
          FROM ima_file
          WHERE ima01=t_bma01
   IF SQLCA.sqlcode THEN
      LET g_chr='E'
      LET l_ima02=NULL
   ELSE
      IF l_imaacti='N' THEN
         LET g_chr='E'
      END IF
   END IF
   IF g_chr !='E' THEN
       #判斷此料件是否在'產品結構單頭檔'中
       IF (g_sma.sma118!='Y') OR (INFIELD(bma01)) OR (INFIELD(bma01b)) THEN
          LET l_sql =" SELECT bma01,bma02,bma03 ",   #最近工程變異單單號,工程變異日期
                     " FROM bma_file ",
                     " WHERE bma01='",t_bma01,"'  AND bmaacti != 'N'"
                                   #AND bma06=p_acode #FUN-560094
       ELSE
          LET l_sql =" SELECT bma01,bma02,bma03 ",  #最近工程變異單單號,工程變異日期
                     " FROM bma_file ",
                     " WHERE bma01='",t_bma01,"'  AND bmaacti != 'N'",
                     " AND bma06='",p_acode,"'" #FUN-560094
       END IF
       PREPARE r855_bma01_sql FROM l_sql
       DECLARE r855_bma01 CURSOR FOR r855_bma01_sql
       OPEN r855_bma01
       IF SQLCA.sqlcode THEN
          LET g_chr='E'
       ELSE
          FOREACH r855_bma01 INTO l_bma01,l_bma02,l_bma03
             EXIT FOREACH
          END FOREACH
          IF cl_null(l_bma01) THEN
             LET g_chr='E'
          END IF
       END IF
   END IF
   IF g_chr='E' THEN RETURN END IF
   IF l_chr='1' THEN     #被換主件料件編號
       LET tm.bma02  =  l_bma02
       LET tm.bma03  =  l_bma03
       DISPLAY l_ima02   TO FORMONLY.ima02
       DISPLAY l_bma02   TO FORMONLY.bma02
       DISPLAY l_bma03   TO FORMONLY.bma03
   ELSE                  #替換主件料件編號
       DISPLAY l_ima02   TO FORMONLY.ima02b
       DISPLAY l_bma02   TO FORMONLY.bma02b
       DISPLAY l_bma03   TO FORMONLY.bma03b
       LET tm.bma02b =  l_bma02
       LET tm.bma03b =  l_bma03
   END IF
END FUNCTION
 
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
# r855()      從單頭讀取合乎條件的主件資料
# r855_bom()  處理元件及其相關的展開資料
FUNCTION r855()
   DEFINE l_name VARCHAR(20),		# External(Disk) file name
          l_time VARCHAR(8),		# Usima time for running the job
          l_sql  VARCHAR(1000),		# RDSQL STATEMENT
          l_sqlb VARCHAR(1000),		# RDSQL STATEMENT
          l_za05 VARCHAR(40),
          l_bma01 LIKE bma_file.bma01,          #被換主件料件
          l_bma01b LIKE bma_file.bma01          #替換主件料件編號
 
  #利用二個 TABLE 暫存展開後的BOM, 以便作比較
  #使用 TEMP TABLE 執行結果會有問題 (執行相同條件二次以上時)
  #因此,修改方式為:在DATABASE 中增加兩個 TABLE (abmr855_t1,abmr855_t2),
  #     此TABLE 只在此程式中使用,執行時必須先LOCK TABLE ,並且清除TABLE內
  #     所有的值.   ...........91/10/09  by lin .
{
     LOCK TABLE abmr855_t1 IN SHARE MODE
     LOCK TABLE abmr855_t2 IN SHARE MODE
     DELETE FROM abmr855_t1
     DELETE FROM abmr855_t2
}
     DROP TABLE abmr855_t1
     DROP TABLE abmr855_t2
#           CREATE TEMP TABLE abmr855_t1  #被替換主件                #FUN-A20044
#           (                                                        #FUN-A20044
#              bmb03       VARCHAR(40),  #元件料件編號               #FUN-A20044
#              ima02       VARCHAR(60),  #品名規格     #FUN-560074   #FUN-A20044
# Prog. Version..: '5.30.06-13.03.12(04),  #庫存單位                   #FUN-A20044
#              bmb02       SMALLINT,  #元件項次                      #FUN-A20044 
#              bmb06       DECIMAL(16,8),  #組成用量                 #FUN-A20044
#              bmb04       DATE,      #生效日期                      #FUN-A20044
#              bmb05       DATE,      #失效日期                      #FUN-A20044
#              bma01       VARCHAR(40),  #主件料件編號               #FUN-A20044
# Prog. Version..: '5.30.06-13.03.12(04),  #發料單位                   #FUN-A20044
#              bmb10_fac   DECIMAL(16,8), #發料對料件庫存單位轉換率  #FUN-A20044
#              #l_total     DECIMAL(10,3)  #本階用量   #FUN-550106   #FUN-A20044 
#              l_total     DECIMAL(16,8)  #本階用量   #FUN-550106    #FUN-A20044
#             )                                                      #FUN-A20044
#FUN-A20044 --Begin
          CREATE TEMP TABLE abmr855_t1(
              bmb03        LIKE bmb_file.bmb03,        
              ima02        LIKE ima_file.ima02,    
              ima25        LIKE ima_file.ima25,    
              bmb02        LIKE bmb_file.bmb02,    
              bmb06        LIKE bmb_file.bmb06,    
              bmb04        LIKE bmb_file.bmb04,    
              bmb05        LIKE bmb_file.bmb05,    
              bma01        LIKE bma_file.bma01,       
              bmb10        LIKE bmb_file.bmb10,    
              bmb10_fac    LIKE type_file.num26_10,
              l_total      LIKE type_file.num26_10)
#FUN-A20044 --End
 
#         CREATE TEMP TABLE abmr855_t2    #替換主件
#            (
#              bmb03       VARCHAR(40),   #元件料件編號        #FUN-A20044
#              ima02       VARCHAR(30),   #品名規格            #FUN-A20044
# Prog. Version..: '5.30.06-13.03.12(04),  #庫存單位             #FUN-A20044
#              bmb02       SMALLINT,   #元件項次               #FUN-A20044
#              bmb06       DECIMAL(16,8),  #組成用量           #FUN-A20044 
#              bmb04       DATE,       #生效日期               #FUN-A20044
#              bmb05       DATE,       #失效日期               #FUN-A20044
#              bma01       VARCHAR(40),   #替換主件料件編號    #FUN-A20044
# Prog. Version..: '5.30.06-13.03.12(04),  #發料單位             #FUN-A20044
#              bmb10_fac   DECIMAL(16,8),  #發料對料件庫存單位轉換率   #FUN-A20044
#              #l_total     DECIMAL(10,3)   #本階用量   #FUN-550106    #FUN-A20044
#              l_total     DECIMAL(16,8)   #本階用量   #FUN-550106     #FUN-A20044
#            )                                                         #FUN-A20044
#No.FUN-A20044 ---start---
        CREATE TEMP TABLE abmr855_t2(          
             bmb03      LIKE bmb_file.bmb03,   
             ima02      LIKE ima_file.ima02,   
             ima25      LIKE ima_file.ima25, 
             bmb02      LIKE bmb_file.bmb02,   
             bmb06      LIKE bmb_file.bmb06,   
             bmb04      LIKE bmb_file.bmb04,   
             bmb05      LIKE bmb_file.bmb05,   
             bma01      LIKE bma_file.bma01,  
             bmb10      LIKE bmb_file.bmb10,   
             bmb10_fac  LIKE type_file.num26_10,
             l_total    LIKE type_file.num26_10 ) 
#No.FUN-A20044 ---end---                     

     #No.FUN-B80100--mark--Begin---
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
     #No.FUN-B80100--mark--End-----
     CALL cl_del_data(l_table)                     #NO.FUN-850045
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'abmr855' #NO.FUN-850045
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr855'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     DELETE FROM abmr855_t1 WHERE 1=1
     DELETE FROM abmr855_t2 WHERE 1=1
 
       LET g_bma01=tm.bma01
       LET g_bma06_1=tm.bma06_1 #FUN-550093
       CALL r855_bom(0,g_bma01,1,'1',g_bma06_1)    #被替換主件展開BOM  #FUN-550093
       LET g_bma01=tm.bma01b
       LET g_bma06_2=tm.bma06_2 #FUN-550093
       CALL r855_bom(0,g_bma01,1,'2',g_bma06_2)    #替換主件展開BOM   #FUN-550093
#       CALL cl_outnam('abmr855') RETURNING l_name           #NO.FUN-850045
 
#      START REPORT r855_rep TO l_name                      #NO.FUN-850045
#      LET g_pageno=0 #TQC-5C0008                           #NO.FUN-850045
       CALL r855_comp()       #展開之後做比較缺料
       CALL r855_comp1()       #展開之後做比較退料
#     FINISH REPORT r855_rep                                #NO.FUN-850045
#NO.FUN-850009--start-----
       LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = tm.wc,";",tm.bma01,";",tm.bma02,";",tm.bma03,";",g_bma06_1,";",
                 tm.bma01b,";",tm.bma02b,";",tm.bma03b,";",g_bma06_2,";",
                 tm.x,";",tm.f,";",tm.vdate1,";",tm.vdate2
     CALL cl_prt_cs3('abmr855','abmr855',g_sql,g_str) 
#NO.FUN-850009----end----
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-850045
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
    #DISPLAY " " AT 2,1
#{
#     UNLOCK TABLE abmr855_t1
#     UNLOCK TABLE abmr855_t2
#}
END FUNCTION
 
FUNCTION r855_bom(p_level,p_key,p_total,l_chrs,p_acode) #FUN-550093
   DEFINE p_level	SMALLINT,            #階層
          p_acode       LIKE bma_file.bma06, #FUN-550093
          #p_total       DECIMAL(10,3),   #組成用量   #FUN-550106
          p_total       DECIMAL(16,8),   #組成用量   #FUN-550106
          #l_total       DECIMAL(10,3),   #用量   #FUN-550106
          l_total       DECIMAL(16,8),   #用量   #FUN-550106
          l_chrs        VARCHAR(01),        #判斷是'被換主件' 或 '替換主件'
          p_key		LIKE bma_file.bma01, #主件料件編號
          l_ac,i	SMALLINT,
          arrno		SMALLINT,	         #BUFFER SIZE (可存筆數)
          b_seq		SMALLINT,	         #當BUFFER滿時,重新讀單身之起始序號
          l_chr  VARCHAR(1),
          l_ima06 LIKE ima_file.ima06,   #分群碼
          l_bma02 LIKE bma_file.bma02,   #工程變異單號
          l_bma03 LIKE bma_file.bma03,   #工程變異日期
          l_bma04 LIKE bma_file.bma04,   #組合模組參考
          l_cmd	 VARCHAR(1000),
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              ima02 LIKE ima_file.ima02,    #品名規格
              ima25 LIKE ima_file.ima25,    #庫存單位
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb06 LIKE bmb_file.bmb06,    #QPA
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bma01 LIKE bma_file.bma01,    #主件料號
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb10_fac LIKE bmb_file.bmb10_fac   #發料/庫存單位換算率
          END RECORD
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
	IF p_level > 25 THEN
           CALL cl_err('','mfg2733',1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
           EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    IF p_level = 1 THEN
        INITIALIZE sr[1].* TO NULL
        LET sr[1].bmb03 = p_key
    END IF
    LET arrno = 600
    WHILE TRUE
        LET l_cmd=            #組SQL,讀取合乎條件的元件料件資料
            "SELECT bmb03,ima02,ima25,",
            "bmb02,(bmb06/bmb07),",
            "bmb04,bmb05,",
            "bma01,bmb10,bmb10_fac",
#           " FROM bmb_file, OUTER ima_file, OUTER bma_file",              #091020
            " FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01",    #091020
            " LEFT OUTER JOIN bma_file ON bmb03 = bma01",                  #091020
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,
#            " AND bmb_file.bmb03 = ima_file.ima01",                       #091020
#            " AND bmb_file.bmb03=bma_file.bma01",                         #091020
            " AND bmb29='",p_acode,"'" #FUN-550093
 
        #---->生效日及失效日的判斷
        IF l_chrs='1' THEN
           IF tm.vdate1 IS NOT NULL  OR tm.vdate1 != ' ' THEN
                LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.vdate1,
                "' OR bmb04 IS NULL) AND (bmb05 >'",tm.vdate1,
                "' OR bmb05 IS NULL)"
           END IF
        ELSE
           IF tm.vdate2 IS NOT NULL OR tm.vdate2 != ' ' THEN
                LET l_cmd=l_cmd CLIPPED, " AND (bmb04 <='",tm.vdate2,
                "' OR bmb04 IS NULL) AND (bmb05 >'",tm.vdate2,
                "' OR bmb05 IS NULL)"
           END IF
        END IF
 
        #---->排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY bmb03"
        PREPARE r855_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('P1:',SQLCA.sqlcode,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--
           EXIT PROGRAM
        END IF
        DECLARE r855_cur CURSOR FOR r855_ppp
 
        LET l_ac = 1
        FOREACH r855_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            #FUN-8B0035--END--
            LET l_ac = l_ac + 1			# 但BUFFER不宜太大
            IF l_ac >= arrno THEN EXIT FOREACH END IF
         END FOREACH
         FOR i = 1 TO l_ac-1			# 讀BUFFER傳給REPORT
            #將本階用量乘以'替換數量',再乘以'發料單位對庫存單位的轉換率'
            IF sr[i].bmb10_fac IS NULL THEN LET sr[i].bmb10_fac=1 END IF
            LET l_total=p_total*sr[i].bmb06*tm.x*sr[i].bmb10_fac
            IF sr[i].bma01 IS NOT NULL THEN
              LET g_bma01=sr[i].bma01
             #CALL r855_bom(p_level,sr[i].bmb03,p_total*sr[i].bmb06,l_chrs,' ') #FUN-550093#FUN-8B0035
              CALL r855_bom(p_level,sr[i].bmb03,p_total*sr[i].bmb06,l_chrs,l_ima910[i]) #FUN-8B0035
            ELSE
               IF sr[i].bmb10_fac IS NULL OR sr[i].bmb10_fac = ' '
               THEN LET sr[i].bmb10_fac=1
               END IF
               IF l_chrs='1' THEN     #被換主件料件
                  INSERT INTO abmr855_t1 VALUES (sr[i].bmb03,
                         sr[i].ima02,sr[i].ima25,sr[i].bmb02,sr[i].bmb06,
                         sr[i].bmb04,sr[i].bmb05,sr[i].bma01,sr[i].bmb10,
                         sr[i].bmb10_fac,l_total)
               ELSE                   #替換主件料件
                  INSERT INTO abmr855_t2 VALUES (sr[i].bmb03,
                         sr[i].ima02,sr[i].ima25,sr[i].bmb02,sr[i].bmb06,
                         sr[i].bmb04,sr[i].bmb05,sr[i].bma01,sr[i].bmb10,
                         sr[i].bmb10_fac,l_total)
               END IF
            END IF
        END FOR
        IF l_ac < arrno OR l_ac=1 THEN                 # BOM單身已讀完
            EXIT WHILE
        ELSE
            LET b_seq = sr[arrno].bmb02
        END IF
    END WHILE
END FUNCTION
 
#NO.FUN-870144
FUNCTION r855_comp()
     DEFINE l_bmb03 LIKE bmb_file.bmb03,    #元件編號
            l_ima02 LIKE ima_file.ima02,    #品名規格
            l_bmb   LIKE bmb_file.bmb03,    #元件編號
            l_ima   LIKE ima_file.ima02,    #品名規格
            l_ima25 LIKE ima_file.ima25,    #庫存單位
#           l_ima262 LIKE ima_file.ima262,  #庫存數量  #FUN-A20044
#           l_ima262  LIKE type_file.num15_3,          #FUN-A40023   #FUN-A40023 
            l_img09 LIKE img_file.img09,    #庫存單位
            l_img10 LIKE img_file.img10,    #庫存數量
            l_img21 LIKE img_file.img21,    #單位數量換算率-對料件庫存單位
            l_tol,l_sum   DECIMAL(10,3),    #被換主件的某一元件之總用量
            #l_totals  DECIMAL(10,3),        #替換主件的某一元件之總用量   #FUN-550106
            l_totals  DECIMAL(16,8),        #替換主件的某一元件之總用量   #FUN-550106
            l_store   DECIMAL(10,3),        #庫存量
            l_flag    VARCHAR(1),
            l_time  VARCHAR(8),
            l_name  VARCHAR(20)
     DEFINE l_ima02a   LIKE ima_file.ima02                  #NO.FUN-850045
     DEFINE l_ima02b   LIKE ima_file.ima02                  #NO.FUN-850045
     DEFINE l_avl_stk_mpsmrp   LIKE type_file.num15_3,      #No.FUN-A20044
            l_unavl_stk        LIKE type_file.num15_3,      #No.FUN-A20044
            l_avl_stk          LIKE type_file.num15_3       #No.FUN-A20044

     LET l_flag='N'
     DROP TABLE tm1
     DROP TABLE tm2
     #將相同的元件之組成用量相加之後, 存在TEMP TABLE
     SELECT abmr855_t1.bmb03,abmr855_t1.ima02,SUM(l_total)  totals
         FROM abmr855_t1
         GROUP BY abmr855_t1.bmb03,abmr855_t1.ima02
         INTO TEMP tm1
 
     SELECT abmr855_t2.bmb03,abmr855_t2.ima02,SUM(l_total) totals
         FROM abmr855_t2
         GROUP BY abmr855_t2.bmb03,abmr855_t2.ima02
         INTO TEMP tm2
     LET l_store=0     #庫存量
 
     DECLARE r855_cusr CURSOR  FOR
#          SELECT tm2.bmb03,tm2.ima02,tm2.totals FROM tm2    #091020
           SELECT bmb03,ima02,totals FROM tm2                #091020
           ORDER BY 1
 
     #讀取一筆'替換主件之元件資料'後,去搜尋'被換主件'中是否
     #有此元件, 若無則印出其資料, 若有則比較其用量
     FOREACH r855_cusr INTO l_bmb03,l_ima02,l_totals
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach error',SQLCA.sqlcode,0) EXIT FOREACH
        END IF
#        SELECT ima25,ima262 INTO l_ima25,l_ima262   #FUN-A20044
        SELECT ima25 INTO l_ima25                    #FUN-A20044  
          FROM ima_file
         WHERE ima01=l_bmb03
           #找某一料件在各可用倉庫的總數量
           DECLARE r855_store CURSOR  FOR
              SELECT img09,img10,img21
                FROM img_file
               WHERE img01=l_bmb03  AND img23='Y'
           LET l_store=0
           IF g_sma.sma12='Y' THEN      #多倉儲管理
               FOREACH r855_store INTO l_img09,l_img10,l_img21
                   IF SQLCA.sqlcode=100 THEN EXIT FOREACH END IF
                   LET l_store=l_store+l_img10* l_img21
               END FOREACH
#          ELSE  LET l_store=l_ima262    #單一倉儲管理  #FUN-A20044
           ELSE
              CALL s_getstock(l_bmb03,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk    #FUN-A20044
              LET l_store = l_avl_stk                                                      #FUN-A20044    
           END IF
 
           SELECT tm1.bmb03 ,tm1.ima02,tm1.totals INTO l_bmb,l_ima,l_tol
              FROM tm1
              WHERE tm1.bmb03=l_bmb03
              #---->表示'被換主件'中無此'替換主件之元件'
              IF SQLCA.sqlcode THEN
                 LET l_flag='Y'
                 #用量必須乘以'替換數量'
                 LET l_sum = l_totals
               IF tm.f='Y' THEN             #僅印缺料
                   IF l_store < l_sum  THEN     #庫存量 < 缺料
#                       OUTPUT TO REPORT r855_rep('A',l_bmb03,l_ima02,l_sum,
#                                                 l_store)     #NO.FUN-850045
#NO.FUN-850045---START----
        SELECT ima02  INTO l_ima02a
             FROM ima_file
             WHERE ima01=tm.bma01
        SELECT ima02  INTO l_ima02b
             FROM ima_file
             WHERE ima01=tm.bma01b  
        LET l_ima25=NULL
        SELECT ima25 INTO l_ima25
         FROM ima_file WHERE ima01=l_bmb03
        EXECUTE insert_prep USING
          'A',l_bmb03,l_ima02,l_sum,l_store,l_ima02a,l_ima02b,l_ima25
#NO.FUN-850045---end----
                   END IF
               ELSE
#                   OUTPUT TO REPORT r855_rep('A',l_bmb03,l_ima02,l_sum,
#                                              l_store)   #NO.FUN-850045
#NO.FUN-850045---START----
        SELECT ima02  INTO l_ima02a
             FROM ima_file
             WHERE ima01=tm.bma01
        SELECT ima02  INTO l_ima02b
             FROM ima_file
             WHERE ima01=tm.bma01b  
        LET l_ima25=NULL
        SELECT ima25 INTO l_ima25
         FROM ima_file WHERE ima01=l_bmb03
        EXECUTE insert_prep USING
          'A',l_bmb03,l_ima02,l_sum,l_store,l_ima02a,l_ima02b,l_ima25
#NO.FUN-850045---end----
               END IF
           ELSE
              #---->比較其用量
              # 被換元件用量 : 替換元件用量
              IF l_tol < l_totals THEN
                 LET l_flag='Y'
                 LET l_sum = (l_totals - l_tol)
                 IF tm.f='Y' THEN               #僅印缺料
                     IF l_store < l_sum  THEN   #庫存量 < 缺料
#                        OUTPUT TO REPORT
#                          r855_rep('A',l_bmb03,l_ima02,l_sum,l_store) #NO.FUN-850045
#NO.FUN-850045---START----
        SELECT ima02  INTO l_ima02a
             FROM ima_file
             WHERE ima01=tm.bma01
        SELECT ima02  INTO l_ima02b
             FROM ima_file
             WHERE ima01=tm.bma01b  
        LET l_ima25=NULL
        SELECT ima25 INTO l_ima25
         FROM ima_file WHERE ima01=l_bmb03
        EXECUTE insert_prep USING
          'A',l_bmb03,l_ima02,l_sum,l_store,l_ima02a,l_ima02b,l_ima25
#NO.FUN-850045---end----
                     END IF
                 ELSE
#                     OUTPUT TO REPORT
#                       r855_rep('A',l_bmb03,l_ima02,l_sum,l_store)  #NO.FUN-850045
#NO.FUN-850045---START----
        SELECT ima02  INTO l_ima02a
             FROM ima_file
             WHERE ima01=tm.bma01
        SELECT ima02  INTO l_ima02b
             FROM ima_file
             WHERE ima01=tm.bma01b  
        LET l_ima25=NULL
        SELECT ima25 INTO l_ima25
         FROM ima_file WHERE ima01=l_bmb03
        EXECUTE insert_prep USING
          'A',l_bmb03,l_ima02,l_sum,l_store,l_ima02a,l_ima02b,l_ima25
#NO.FUN-850045---end----
                 END IF
              END IF
           END IF
     END FOREACH
     IF l_flag='N' THEN
#        OUTPUT TO REPORT r855_rep('A',' ',' ',0,0)         #NO.FUN-850045
#NO.FUN-850045---START----
        SELECT ima02  INTO l_ima02a
             FROM ima_file
             WHERE ima01=tm.bma01
        SELECT ima02  INTO l_ima02b
             FROM ima_file
             WHERE ima01=tm.bma01b  
        LET l_ima25=NULL
        SELECT ima25 INTO l_ima25
         FROM ima_file WHERE ima01=''
        LET l_sum = 0
        LET l_store = 0
        EXECUTE insert_prep USING
          'A',' ',' ',l_sum,l_store,l_ima02a,l_ima02b,l_ima25
#NO.FUN-850045---end----
     END IF
     CLOSE r855_cusr
END FUNCTION
 
FUNCTION r855_comp1()
     DEFINE l_bmb03 LIKE bmb_file.bmb03,  #元件編號
            l_ima02 LIKE ima_file.ima02,  #品名規格
            l_bmb   LIKE bmb_file.bmb03,  #元件編號
            l_ima   LIKE ima_file.ima02,  #品名規格
            l_ima25 LIKE ima_file.ima25,  #庫存單位
#            l_ima262 LIKE ima_file.ima262,  #庫存數量  #FUN-A20044
            l_avl_stk LIKE type_file.num15_3,            #FUN-A20044
            l_img09 LIKE img_file.img09,  #庫存單位
            l_img10 LIKE img_file.img10,  #庫存數量
            l_img21 LIKE img_file.img21,  #單位數量換算率-對料件庫存單位
            l_tol,l_sum   DECIMAL(10,3),      #被換主件的某一元件之總用量
            #l_totals  DECIMAL(10,3),      #替換主件的某一元件之總用量   #FUN-550106
            l_totals  DECIMAL(16,8),      #替換主件的某一元件之總用量   #FUN-550106
            l_flag    VARCHAR(1),
            l_time  VARCHAR(8),
            l_name  VARCHAR(20)
     DEFINE l_ima02a   LIKE ima_file.ima02                  #NO.FUN-850045
     DEFINE l_ima02b   LIKE ima_file.ima02                  #NO.FUN-850045
     DEFINE l_store    LIKE bmb_file.bmb06                  #NO.FUN-850045
     LET l_flag='N'
 
     DECLARE r855_cusr2 CURSOR  FOR
           SELECT tm1.bmb03,tm1.ima02,tm1.totals FROM tm1
           ORDER BY 1
     #讀取一筆'替換主件之元件資料'後,去搜尋'被換主件'中是否
     #有此元件, 若無則印出其資料, 若有則比較其用量
     FOREACH r855_cusr2 INTO l_bmb03,l_ima02,l_totals
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach error',SQLCA.sqlcode,0) EXIT FOREACH
     END IF
#          SELECT tm2.bmb03 ,tm2.ima02,tm2.totals INTO l_bmb,l_ima,l_tol   #091020
           SELECT bmb03 ,ima02,totals INTO l_bmb,l_ima,l_tol   #091020
              FROM tm2
#             WHERE tm2.bmb03=l_bmb03
              WHERE bmb03=l_bmb03     #091020
           IF SQLCA.sqlcode THEN       #表示'被換主件'中無此'替換主件之元件'
              LET l_flag='Y'
              LET l_sum = l_totals
#              OUTPUT TO REPORT r855_rep('B',l_bmb03,l_ima02,l_sum,0) #NO.FUN-850045
#NO.FUN-850045---START----
        SELECT ima02  INTO l_ima02a
             FROM ima_file
             WHERE ima01=tm.bma01
        SELECT ima02  INTO l_ima02b
             FROM ima_file
             WHERE ima01=tm.bma01b  
        LET l_ima25=NULL
        SELECT ima25 INTO l_ima25
         FROM ima_file WHERE ima01=l_bmb03
        LET l_store = 0
        EXECUTE insert_prep USING
          'B',l_bmb03,l_ima02,l_sum,l_store,l_ima02a,l_ima02b,l_ima25
#NO.FUN-850045--END---
           ELSE
              IF l_tol < l_totals THEN     #比較其用量
                 LET l_flag='Y'
                 LET l_sum = (l_totals - l_tol)           
#                 OUTPUT TO REPORT                             #NO.FUN-850045
#                        r855_rep('B',l_bmb03,l_ima02,l_sum,0) #NO.FUN-850045
#NO.FUN-850045---START----
        SELECT ima02  INTO l_ima02a
             FROM ima_file
             WHERE ima01=tm.bma01
        SELECT ima02  INTO l_ima02b
             FROM ima_file
             WHERE ima01=tm.bma01b  
        LET l_ima25=NULL
        SELECT ima25 INTO l_ima25
         FROM ima_file WHERE ima01=l_bmb03
        LET l_store = 0 
        EXECUTE insert_prep USING
          'B',l_bmb03,l_ima02,l_sum,l_store,l_ima02a,l_ima02b,l_ima25
#NO.FUN-850045--END---
              END IF
           END IF
     END FOREACH
     IF l_flag='N' THEN
        #OUTPUT TO REPORT r855_rep('B',' ',' ',0,0)         #NO.FUN-850045
#NO.FUN-850045---START----
        SELECT ima02  INTO l_ima02
             FROM ima_file
             WHERE ima01=tm.bma01
        SELECT ima02  INTO l_ima02b
             FROM ima_file
             WHERE ima01=tm.bma01b  
        LET l_ima25=NULL
        SELECT ima25 INTO l_ima25
         FROM ima_file WHERE ima01=''
        LET l_sum = 0
        LET l_store = 0
        EXECUTE insert_prep USING
          'B',' ',' ',l_sum,l_store,l_ima02,l_ima02b,l_ima25
#NO.FUN-850045--END---     
     END IF
     DROP TABLE tm1
     DROP TABLE tm2
END FUNCTION
#NO.FUN-850045---end----
#REPORT r855_rep(p_cmd,p_bmb03,p_ima02,p_total,p_store)
#   DEFINE l_last_sw VARCHAR(1),
#          p_cmd         VARCHAR(01),
#          p_bmb03       LIKE bmb_file.bmb03,  #No.MOD-490217
#          p_ima02       VARCHAR(30),
#          #p_total       DECIMAL(10,3),   #FUN-550106
#          p_total       LIKE bmb_file.bmb06,   #FUN-550106 #FUN-560227
#          p_store       DECIMAL(10,3),
#          l_ima02 LIKE ima_file.ima02,    #品名規格
#          l_ima25 LIKE ima_file.ima25,    #庫存單位
#          l_use_flag    VARCHAR(2),
#          l_ute_flag    VARCHAR(2),
#          l_now        SMALLINT
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY p_cmd,p_bmb03
#  FORMAT
#   PAGE HEADER
#      #公司名稱
#      PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      #報表名稱
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      LET g_pageno = g_pageno + 1   #TQC-5C000
#      #有效日期
#      PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#            COLUMN (g_len-FGL_WIDTH(g_user)-5),
#            g_x[3] CLIPPED
#           g_pageno USING '<<<'
#            ,g_pageno USING '<<<'    #TQC-5C0008
#      PRINT g_dash[1,g_len]
#      SELECT ima02  INTO l_ima02
#             FROM ima_file
#             WHERE ima01=tm.bma01
 
##------No.TQC-5B0030 modify
#      PRINT COLUMN  1,g_x[11] CLIPPED,tm.bma01,
#            COLUMN 41,g_x[12] CLIPPED,tm.bma02
#      PRINT COLUMN 1,g_x[13] CLIPPED,tm.bma03,         #No.FUN-550032
#            COLUMN 41,g_x[30],g_bma06_1
#      PRINT COLUMN 1,g_x[20] CLIPPED,l_ima02 #FUN-550093
#      SKIP 1 LINE
#      LET l_ima02=NULL
#      SELECT ima02  INTO l_ima02
#             FROM ima_file
#             WHERE ima01=tm.bma01b
#      PRINT COLUMN  1,g_x[14] CLIPPED,tm.bma01b,
#            COLUMN 41,g_x[12] CLIPPED,tm.bma02b
#      PRINT COLUMN 1,g_x[13] CLIPPED,tm.bma03b,          #No.FUN-550032
#            COLUMN 41,g_x[30],g_bma06_2
#-------end
#
#      PRINT COLUMN 1,g_x[20] CLIPPED,l_ima02 #FUN-550093
#      SKIP 1 LINE
#      PRINT g_x[15] CLIPPED,tm.x,'          ',g_x[21] CLIPPED,' ',tm.f
#      SKIP 1 LINE
#      PRINT g_x[29]
#      IF p_cmd='A' THEN
#         PRINT g_x[22] CLIPPED
#         SKIP 1 LINE
#------No.TQC-5B0030 modify
#         PRINT g_x[16],COLUMN 57,g_x[17] CLIPPED
#         PRINT g_x[28] CLIPPED
#         PRINT g_x[18],COLUMN 55,g_x[19] CLIPPED
#      ELSE
#         #SKIP 1 LINE
#         PRINT g_x[23] CLIPPED
#         SKIP 1 LINE
#         PRINT g_x[24],COLUMN 45,g_x[25] CLIPPED
#         PRINT g_x[28] CLIPPED
#         PRINT g_x[26],COLUMN 42,g_x[27] CLIPPED
##--------end
#      END IF
#      LET l_last_sw = 'n'
 
#   BEFORE GROUP OF p_cmd
#      IF (PAGENO > 1 OR LINENO > 19)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#    ON EVERY ROW
#       LET l_ima25=NULL
#       SELECT ima25 INTO l_ima25
#         FROM ima_file WHERE ima01=p_bmb03
#       IF p_cmd='A' THEN
#          NEED 2 LINES
 
#------------No.TQC-5B0030 modify
#          PRINT COLUMN  1,p_bmb03,
#                #COLUMN 22,p_total USING '########&.&&',  #FUN-550106
#                COLUMN 42,p_total USING '###&.&&&&&',   #FUN-550106
#                COLUMN 55,p_store USING '########&.&&',
#                COLUMN 70,l_ima25
#          PRINT COLUMN 1,p_ima02
#       ELSE
#          PRINT COLUMN  1,p_bmb03,
#                #COLUMN 22,p_total USING '########&.&&',   #FUN-550106
#                COLUMN 42,p_total USING '###&.&&&&&',   #FUN-550106
#                COLUMN 57,l_ima25
#          PRINT COLUMN 1,p_ima02 CLIPPED
#       END IF
#-----------------end
 
#   ON LAST ROW
#      LET l_last_sw = 'y'
 
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw = 'y'
##        OR g_pageno = 0
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      END IF
#END REPORT
#Patch....NO.TQC-610035 <001> #
#NO.FUN-850045---end----
