# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: amdp010.4gl
# Descriptions...: 銷項資料擷取作業
# Date & Author..: 01/05/21 by
# Modify.........: 此程式由 amdi100_s() copy 過來獨立成一支新程式
# Modify.........: No:7756 03/08/08 By Wiky  LET l_sql =l_sql CLIPPED," ORDER BY ome16,ome02 "  #NO:7222
#                  在ORACLE SQL會有問題,多寫TEMP FILE去解決
# Modify.........: No:8157 03/09/09 By Wiky ome175 是 number 型態  不能有 OR ome175 = ' '
# Modify.........: No:8236 03/11/03 By Kitty 彙總開立的發票產生無法產生出明細資料
# Modify.........: No:8717 03/11/13 By Kitty 若同張帳單多筆作廢,產生發票資料會有問題
# Modify.........: No:8684 03/11/14 By Kitty CONSTRUCT應該條件都要下
# Modify.........: No:8770 03/12/01 By Kitty 設定申報格式為XX不申報但資料仍會帶入
# Modify.........: No:8708 03/12/02 By Kitty 若輸入稅藉部門後,直接ESC g_ary[1].plant未帶入值
# Modify.........: No.9017 04/01/12 By Kitty plant長度修改
# Modify.........: No.9041 04/01/15 By Kitty oma175 是 number 型態  不能有 OR oma175 = ' '
# Modify.........: No:MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No:MOD-470398 04/07/29 By Kitty  無法產生資料
# Modify.........: No:MOD-4A0266 04/10/20 By ching  確認資料不重覆產生
# Modify.........: No:FUN-4C0022 04/12/03 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No:FUN-4C0105 04/12/31 By Kitty 增加amd10 通關註記的處理
# Modify.........: No.FUN-560247 05/06/28 By day 單據編號加大
# Modify.........: No:MOD-580385 05/09/15 By Smapmin l_amd10值未清空
# Modify.........: No:TQC-590009 05/12/06 By Smapmin axrt300 '21'類別改回頭抓該銷退單號+項次對應的發票號碼(單身多筆)
# Modify.........: No:MOD-610027 06/01/06 By Smapmin insert到amd_file時,先判斷發票編號+格式是否有重複的
# Modify.........: No:FUN-610079 06/01/20 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-570123 06/03/07 By yiting 批次作業修改
# Modify.........: No:MOD-640414 06/04/12 By Smapmin 修正NOT MATCHES的語法
# Modify.........: No:MOD-640394 06/04/17 By Smapmin 同一筆銷退單有多筆發票資料時,產生媒體申報資料時,只會產生一筆資料
# Modify.........: No:MOD-650070 06/05/17 By Smapmin 修正SQL語法
# Modify.........: No:FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No:MOD-660082 06/06/20 By Smapmin 將l_sql,l_sql1設為STRING
# Modify.........: No:MOD-660145 06/06/30 By rainy  資料未拋轉成功
# Modify.........: No:FUN-680074 06/08/23 By huchenghao 類型轉換
# Modify.........: No:FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No:TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No:MOD-6C0149 06/12/21 By Smapmin 格式為36時,對方統一編號應為空
# Modify.........: No:TQC-710078 07/01/31 By Smapmin 抓取銷退資料
# Modify.........: No:MOD-730001 07/03/02 By Smapmin 外銷不開立發票的狀況,發票欄位應抓取oma10,而非oma01
# Modify.........: No:MOD-730066 07/03/15 By Smapmin 依營業稅電子資料申報繳稅作業要點,當為銷項憑證時扣抵代號應該要為空白
# Modify.........: No:MOD-740319 07/04/23 By Smapmin 修改字串取代
# Modify.........: No:MOD-740468 07/04/26 By Smapmin 外銷不開立發票者, 則產生應收時, 發票金額會default 0. 轉媒體申報時, 即會發票金額為0
# Modify.........: No:TQC-740330 07/04/30 By Smapmin 修改INSERT INTO amf_file 的條件
# Modify.........: No:MOD-750122 07/05/25 By Smapmin 作廢發票仍需要把格式建立在媒體檔中,否則媒體申報審核會不通過
# Modify.........: No:TQC-750177 07/05/28 By rainy   已開發票無法產生至amdi100
# Modify.........: No:MOD-760101 07/06/22 By Smapmin 作廢時將l_ome042設為' ',在amdr200才計算得到
# Modify.........: NO.TQC-790093 07/09/20 BY yiting Primary Key的-268訊息 程式修改
# Modify.........: No:MOD-7C0079 07/12/12 By Smapmin 是否申報以稅別申報格式為主,若稅別申報格式為XX即不申報
# Modify.........: No:MOD-7C0223 08/01/08 By Smapmin 銷退折讓轉媒體申報發票日期應為銷退折讓帳款日
# Modify.........: No:MOD-810085 08/01/16 By Smapmin 銷退折讓時,加入IF l_ome171 = '35' THEN LET l_ome171 = '33' END IF
# Modify.........: No:FUN-770040 08/06/04 By Smapmin 增加新增發票聯數到媒體申報檔
# Modify.........: No:TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No:MOD-880219 08/08/28 By Sarah 產生amf_file時,amf02應為與amd02一樣為l_n
# Modify.........: No:MOD-8A0237 08/10/31 By Sarah p010_curome CURSOR在產生資料時,不要將oga01,oma01等帳單號碼寫入發票號碼欄位
# Modify.........: No:MOD-8B0124 08/11/13 By Sarah 出售產生的應收帳款是不需再產生分錄的,此部分應收的傳票號碼必須抓出售單的傳票編號
# Modify.........: No:MOD-920379 09/02/27 By Sarah 1.CURSOR p010_curome裡以ome_file串回oma_file時,應以ome01=oma10當key值串
#                                                  2.當多張帳款合併開立發票時,回抓omb_file資料有誤,造成銷項明細(amf_file)都是空的
# Modify.........: No:MOD-950149 09/05/14 By Sarah 刪除amf_file時,amf02應等於前面amd_file的amd02的值
# Modify.........: No:FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:FUN-8B0081 09/07/30 By hongmei 拋轉至amd_file時，預設amd44 = '3'(空白)
# Modify.........: No:MOD-980192 09/08/22 By Sarah 銷退折讓單身若多筆,但發票號碼相同,拋到amdi100應還是彙總成一筆
# Modify.........: No:MOD-980244 09/08/28 By mike 在檢查資料有沒有重覆的SQL前,增加判斷若l_ome01為Null,則給予預設值' '               
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-980092 09/09/09 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No:MOD-990074 09/09/08 By Sarah 檢查amd_file資料是否重複時,SQL除了串發票號碼(amd03)外還需串帳款編號(amd01),因為外銷的發票號碼會是空的
# Modify.........: No:MOD-990101 09/09/10 By Sarah 若g_wc3裡有oma10的條件,需將它轉換成1=1
# Modify.........: No:MOD-990115 09/09/11 By mike 在delete前若l_ome01為空，應該let l_ome01 = ' ' 
# Modify.........: No:FUN-970108 09/08/20 By hongmei 申報稅籍部門，放開all的控管
# Modify.........: No:MOD-990116 09/09/14 By mike PREPARE p010_preoma2的l_sql寫法有誤
# Modify.........: No:TQC-9A0016 09/10/09 By lilingyu 程序有一段select ohb30的,應該改成跨工廠抓ohb30
# Modify.........: No:MOD-9A0019 09/10/19 By sabrina 當帳款編號(ome16)相同時，l_n需加1
# Modify.........: No:TQC-9A0177 09/10/29 By wujie   5.2SQL转标准语法
# Modify.........: No:MOD-9A0139 09/10/30 By mike p010_curoma2的l_sql应多串ome_file,WHERE条件请增加AND ohb30=ome01                  
# Modify.........: No:MOD-9C0427 09/12/29 By Sarah 1.當aza94<>'Y'時,(1)將dummy01隱藏(2)若amd22輸入ALL需顯示錯誤訊息
#                                                  2.當amd22輸入ALL時,請以ome60串amdi001抓出ama01,再將ama01寫入amd22
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No.FUN-A10039 10/01/20 By jan 作廢發票處理段，將LET l_ome172= 'D'改為LET l_ome172= 'F'
# Modify.........: No:MOD-A30012 10/03/02 By sabrina GROUP BY少了ome60
# Modify.........: No:MOD-A30179 10/03/25 By sabrina 若ome171<>'33'OR ome171<>'34'，在amdi100只可產生一筆
# Modify.........: No:MOD-A40093 10/04/19 By sabrina 直接select，無法抓到該營運中心的資料
# Modify.........: No:MOD-A50040 10/05/06 By sabrina 修改MOD-A40093錯誤
# Modify.........: No:MOD-A50126 10/05/21 By sabrina 結轉外錯AR時，結關日期有誤
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:CHI-A60029 10/07/16 By Summer 1.追單MOD-A40109
#                                                   2.外銷銷退折讓無法擷取申報
# Modify.........: No.FUN-A50102 10/07/19 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A70132 10/07/19 By sabrina 修改MOD-A50126錯誤
# Modify.........: No:MOD-A30056 10/08/03 By sabrina 若失敗或沒有產生資料要顯示錯誤訊息
# Modify.........: No:MOD-A80108 10/08/13 By Dido 銷退單單身多筆發票重複應彙總
# Modify.........: No:MOD-A80243 10/09/01 By Dido g_wc4 應增加重組 g_wc1 部分 
# Modify.........: No:MOD-A90033 10/09/07 By Dido 銷退發票增加抓取開帳發票來源(amd_file) 
# Modify.........: No:MOD-A90081 10/09/10 By Dido 延續 MOD-A90033 排除已存在 ome_file 發票 
# Modify.........: No:MOD-A90090 10/09/13 By Dido 多筆銷退單身時抓取開帳發票來源 
# Modify.........: No:MOD-A90091 10/09/13 By Dido 寫入暫存檔後抓取值須再取位 
# Modify.........: No:MOD-A90096 10/09/14 By Dido 銷退發票日期應抓取原發票日期
# Modify.........: No:MOD-AA0025 10/10/06 By Dido 清空 ome042 位置前移 
# Modify.........: No:MOD-AB0035 10/11/03 By Dido 若同帳款有作廢與正式發票只會有一筆能產生 
# Modify.........: No:MOD-AB0066 10/11/08 By Dido 增加過濾 oma00 LIKE '1%' 條件 
# Modify.........: No:MOD-AB0074 10/11/09 By Dido 倉退多筆單身時抓取資料年月調整 
# Modify.........: No:MOD-AC0351 10/12/28 By sabrina 修正MOD-AB0066的sql語法 
# Modify.........: No:MOD-B20035 11/02/11 By Dido 變數使用修改 
# Modify.........: No:MOD-B30599 11/03/18 By Sarah 當ooz64<>'Y'時,抓銷退折讓資料會抓到重複
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:MOD-B50133 11/05/16 By Dido p010_preoma2 增加 amd171 IN 31,32 條件 
# Modify.........: No:MOD-B50170 11/05/20 By Dido 資料年月應抓取發票年月 
# Modify.........: No:MOD-B70081 11/07/11 By Dido 增加外銷銷退無發票資料 
# Modify.........: No:MOD-B80174 11/08/17 By Polly 銷項擷取時應排除外銷方式(oma35) = 「8 外銷不申報」的資料
# Modify.........: No:MOD-B90066 11/09/15 By Polly 修正外銷資料擷取條件
# Modify.........: No.FUN-BA0052 11/10/28 By Belle 營業稅的外銷方式新增 8 及 9兩項
# Modify.........: No:MOD-C10058 12/01/08 By Dido 外銷出貨應收若為預收 100% 者,則抓取訂金作為媒身資料 
# Modify.........: No.MOD-C30858 12/03/26 By Polly 增加擷取axrt300類別31非應收發票(外銷)
# Modify.........: No.MOD-C30869 12/03/27 By Polly 發票日期應抓銷退單的立帳日期，取消MOD-A90096處理
# Modify.........: NO.FUN-C20121 12/07/04 BY mengying 納入簽收單時，如簽收單與出貨單同一個月份，當出貨單有結關日時，不可再重複取簽收單
# Modify.........: No.MOD-C60182 12/06/25 By Polly 增加判斷當有走簽收流程，才需抓取簽收單做控卡
# Modify.........: No.MOD-CB0048 12/11/09 By Polly 排除訂金應收，僅於開立出貨應收時，擷取全額至媒申檔中

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_ary ARRAY [08] OF RECORD
              plant   LIKE azp_file.azp01,  #No.FUN-680074 CHAR(10)#No:9017 
              dbs_new LIKE type_file.chr21, #No.FUN-680074 CHAR(21)   
              dbs_tra LIKE type_file.chr21  #FUN-980092 GP5.2 add  
             END RECORD
DEFINE g_tmp RECORD
              ome01   LIKE ome_file.ome01,  #No.FUN-680074 CHAR(16)
              ome16   LIKE ome_file.ome16,  #No.FUN-560247
              ome042  LIKE ome_file.ome042, #No.FUN-680074 CHAR(20)
              ome04   LIKE ome_file.ome04,  #No.FUN-680074 CHAR(10)  
              ome59   LIKE ome_file.ome59,  #FUN-4C0022
              ome59x  LIKE ome_file.ome59x, #FUN-4C0022
              ome59t  LIKE ome_file.ome59t, #FUN-4C0022
              ome17   LIKE ome_file.ome17,  #No.FUN-680074 CHAR(1)
              ome171  LIKE ome_file.ome171, #No.FUN-680074 CHAR(2)
              ome172  LIKE ome_file.ome172, #No.FUN-680074 CHAR(1)
              ome02   LIKE ome_file.ome02,  #No.FUN-680074 DATE
              ome21   LIKE ome_file.ome21,  #No.FUN-680074 CHAR(4)
              omevoid LIKE ome_file.omevoid,#No.FUN-680074 CAHR(1)
              ome60   LIKE ome_file.ome60,  #FUN-970108 add
              oma33   LIKE oma_file.oma33,  #No.FUN-680074 CHAR(12)
              oma02   LIKE oma_file.oma02,  #No.FUN-680074 DATE
              gec06   LIKE gec_file.gec06,  #No.FUN-680074 CHAR(01)
              gec08   LIKE gec_file.gec08,  #No.FUN-680074 CHAR(2)
              oma35   LIKE oma_file.oma35,  #No.FUN-680074 CHAR(1)
              oma36   LIKE oma_file.oma36,  #No.FUN-680074 CHAR(8)
              oma37   LIKE oma_file.oma37,  #No.FUN-680074 CHAR(16) 
              oma38   LIKE oma_file.oma38,  #No.FUN-680074 CHAR(4)
              oma39   LIKE oma_file.oma39,  #No.FUN-680074 CHAR(20)
              amd40   LIKE amd_file.amd40,  #No.FUN-680074 CHAR(10)
              amd41   LIKE amd_file.amd41,  #No.FUN-680074 CHAR(10)
              amd42   LIKE amd_file.amd42,  #No.FUN-680074 DATE
              amd43   LIKE amd_file.amd43,  #No.FUN-680074 DATE
              kind    LIKE type_file.chr1,  #No.FUN-680074 CHAR(01)
              ome212  LIKE type_file.chr1   #FUN-770040
             END RECORD
DEFINE g_oma16        LIKE oma_file.oma16   #MOD-8B0124 add
DEFINE g_row,g_col    LIKE type_file.num5   #No.FUN-680074 SMALLINT
DEFINE g_cnt          LIKE type_file.num10  #No.FUN-680074 INTEGER
DEFINE g_wc,g_wc1     STRING,               #No:FUN-580092 HCN        #No.FUN-680074   #TQC-710078
       g_wc2,g_wc3    STRING,               #No:FUN-580092 HCN        #No.FUN-680074   #TQC-710078
       g_wc4,g_wc5    STRING,               #No:FUN-580092 HCN        #No.FUN-680074   #TQC-710078
       g_amd22        LIKE amd_file.amd22,
       g_plant_1      LIKE azp_file.azp01,
       g_plant_2      LIKE azp_file.azp01,
       g_plant_3      LIKE azp_file.azp01,
       g_plant_4      LIKE azp_file.azp01,
       g_plant_5      LIKE azp_file.azp01,
       g_plant_6      LIKE azp_file.azp01,
       g_plant_7      LIKE azp_file.azp01,
       g_plant_8      LIKE azp_file.azp01
DEFINE g_change_lang  LIKE type_file.chr1,  #No.FUN-680074 CHAR(1) #FUN-570123 
       l_flag         LIKE type_file.chr1   #FUN-570123        #No.FUN-680074 CHAR(1)
DEFINE g_ama02        LIKE ama_file.ama02   #FUN-970108 add
DEFINE begin_no       LIKE amd_file.amd01     #MOD-A30056


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc1     = ARG_VAL(1)
   LET g_wc2     = ARG_VAL(2)
   LET g_plant_1 = ARG_VAL(3)
   LET g_plant_2 = ARG_VAL(4)
   LET g_plant_3 = ARG_VAL(5)
   LET g_plant_4 = ARG_VAL(6)
   LET g_plant_5 = ARG_VAL(7)
   LET g_plant_6 = ARG_VAL(8)
   LET g_plant_7 = ARG_VAL(9)
   LET g_plant_8 = ARG_VAL(10)
   LET g_amd22   = ARG_VAL(11)
   LET g_bgjob   = ARG_VAL(12)

   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6A0068

   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'

   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p010_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            BEGIN WORK
            CALL p010_s()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p010_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p010_w
      ELSE
         CALL p010_chk_db()
         BEGIN WORK
         CALL p010_s()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

FUNCTION p010_create_tmp()
  DROP TABLE p010_tmp;
  CREATE TEMP TABLE p010_tmp(
    ome01   LIKE ome_file.ome01,   #MOD-730001
    ome16   LIKE ome_file.ome16,   #MOD-740319
    ome042  LIKE ome_file.ome042,  #MOD-740319
    ome04   LIKE ome_file.ome04,
    ome59   LIKE ome_file.ome59 NOT NULL,   #MOD-740319
    ome59x  LIKE ome_file.ome59x NOT NULL,  #MOD-740319
    ome59t  LIKE ome_file.ome59t NOT NULL,  #MOD-740319
    ome17   LIKE ome_file.ome17,    #MOD-740319 
    ome171  LIKE ome_file.ome171,    #MOD-740319
    ome172  LIKE ome_file.ome172,    #MOD-740319
    ome02   LIKE ome_file.ome02,     #MOD-740319
    ome21   LIKE ome_file.ome21,    #MOD-740319
    omevoid LIKE ome_file.omevoid,  #MOD-740319
    ome60   LIKE ome_file.ome60,            #FUN-970108
    oma33   LIKE oma_file.oma33,    #MOD-740319 
    oma02   LIKE oma_file.oma02,    #MOD-740319   
    gec06   LIKE gec_file.gec06,    #MOD-740319
    gec08   LIKE gec_file.gec08,    #MOD-740319
    oma35   LIKE oma_file.oma35,    #MOD-740319  
    oma36   LIKE oma_file.oma36,
    oma37   LIKE oma_file.oma37,    #MOD-740319
    oma38   LIKE oma_file.oma38,    #MOD-740319
    oma39   LIKE oma_file.oma39,    #MOD-740319
    amd40   LIKE amd_file.amd40,
    amd41   LIKE amd_file.amd41,
    amd42   LIKE amd_file.amd42,     #MOD-740319
    amd43   LIKE amd_file.amd43,     #MOD-740319
    kind    LIKE type_file.chr1,
    ome212  LIKE type_file.chr1,     #FUN-770040
    plant   LIKE azp_file.azp01)     #MOD-950149 add
   
   IF SQLCA.SQLCODE THEN
      LET g_success='N'
      CALL cl_err('create p010_tmp',SQLCA.SQLCODE,0)
 END IF
END FUNCTION

FUNCTION p010_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680074 SMALLINT
   DEFINE l_cmd        LIKE type_file.chr1000       #No.FUN-680074 CHAR(1000)
   DEFINE l_ama        RECORD LIKE ama_file.*
   DEFINE lc_cmd       LIKE type_file.chr1000       #No.FUN-680074 CHAR(1000)#FUN-570123

   LET g_row = 4 LET g_col = 15
   OPEN WINDOW p010_w AT g_row,g_col WITH FORM "amd/42f/amdp010"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()

   IF g_aza.aza94<>'Y' THEN
      CALL cl_set_comp_visible("dummy01",FALSE)
   ELSE
      CALL cl_set_comp_visible("dummy01",TRUE)
   END IF

   CALL cl_opmsg('p')
   WHILE TRUE
      MESSAGE ""
      CALL ui.Interface.refresh()
      CONSTRUCT BY NAME g_wc1 ON ome05,ome01
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale          #genero
            LET g_change_lang = TRUE               #FUN-570123
            EXIT CONSTRUCT

         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      END CONSTRUCT
      LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('omeuser', 'omegrup') #FUN-980030
      IF g_change_lang THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME g_wc2 ON ome02,ome16
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION locale          #genero
            LET g_change_lang = TRUE           #FUN-570123
            EXIT CONSTRUCT

         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
      END CONSTRUCT
      IF g_wc1=' 1=1' AND g_wc2 = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF   #No:8684
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF

      LET g_plant_1 = g_plant

      INPUT g_amd22,g_plant_1,g_plant_2,g_plant_3,g_plant_4,
                    g_plant_5,g_plant_6,g_plant_7,g_plant_8,
                    g_bgjob WITHOUT DEFAULTS  #NO.FUN-570123 add g_bgjob
       FROM amd22,plant_1,plant_2,plant_3,plant_4,plant_5,
            plant_6,plant_7,plant_8,g_bgjob  #NO.FUN-570123 add g_bgjob

         AFTER FIELD amd22
          IF g_amd22 <> 'ALL' THEN   #FUN-970108 add 
             IF cl_null(g_amd22) THEN
                NEXT FIELD amd22
             ELSE
                SELECT * INTO l_ama.* from ama_file
                 WHERE ama01 = g_amd22 AND amaacti= 'Y'
                SELECT ama02 INTO g_ama02 
                  FROM ama_file WHERE ama01 = g_amd22
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("sel","ama_file",g_amd22,"","amd-002","","",1)   #No:FUN-660093
                   NEXT FIELD amd22
                END IF
             END IF
          ELSE
             IF g_aza.aza94<>'Y' THEN
                CALL cl_err(g_amd22,'amd-029',0)
                NEXT FIELD amd22
             END IF
          END IF #FUN-970108 add
           
         BEFORE FIELD plant_1
            IF g_multpl='N' THEN  #不為多工廠環境
               LET g_plant_1= g_plant
               LET g_plant_new= NULL
               LET g_dbs_new=NULL
               LET g_ary[1].plant = g_plant_1
               LET g_ary[1].dbs_new = g_dbs_new CLIPPED
               EXIT INPUT       #將不會I/P plant_2 plant_3 plant_4
            END IF

         AFTER FIELD plant_1
            LET g_plant_new= g_plant_1
            IF g_plant_1 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[1].plant = g_plant_1
               LET g_ary[1].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_1) THEN
                  #check User是否有此plant的權限
                  IF NOT s_chk_plant(g_plant_1) THEN
                     NEXT FIELD plant_1
                  END IF
                  #檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT s_chknplt(g_plant_1,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_1
                  END IF
                  LET g_ary[1].plant = g_plant_1
                  CALL s_getdbs()
                  LET g_ary[1].dbs_new = g_dbs_new
               ELSE                     #輸入之工廠編號為' '或NULL
                  LET g_ary[1].plant = g_plant_1
               END IF
            END IF
            IF NOT cl_null(g_plant_1) THEN
                CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
                LET g_ary[1].dbs_tra = g_dbs_tra
            END IF

         AFTER FIELD plant_2
            LET g_plant_2 = duplicate(g_plant_2,1)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_2
            IF g_plant_2 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[2].plant = g_plant_2
               LET g_ary[2].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_2) THEN
                  #是否有此plant的權限
                  IF NOT s_chk_plant(g_plant_2) THEN
                     NEXT FIELD plant_2
                  END IF
                  #檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT s_chknplt(g_plant_2,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_2
                  END IF
                  LET g_ary[2].plant = g_plant_2
                  CALL s_getdbs()
                  LET g_ary[2].dbs_new = g_dbs_new
               ELSE                     #輸入之工廠編號為' '或NULL
                  LET g_ary[2].plant = g_plant_2
               END IF
            END IF
            IF NOT cl_null(g_plant_2) THEN
                CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
                LET g_ary[2].dbs_tra = g_dbs_tra
            END IF

         AFTER FIELD plant_3
            LET g_plant_3 = duplicate(g_plant_3,2)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_3
            IF g_plant_3 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[3].plant = g_plant_3
               LET g_ary[3].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_3) THEN
                  #是否有此plant的權限
                  IF NOT s_chk_plant(g_plant_3) THEN
                     NEXT FIELD plant_3
                  END IF
                  #檢查工廠並將新的資料庫放在g_dbs_new
                  IF NOT s_chknplt(g_plant_3,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_3
                  END IF
                  LET g_ary[3].plant = g_plant_3
                  CALL s_getdbs()
                  LET g_ary[3].dbs_new = g_dbs_new
               ELSE                     #輸入之工廠編號為' '或NULL
                  LET g_ary[3].plant = g_plant_3
               END IF
            END IF
            IF NOT cl_null(g_plant_3) THEN
                CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
                LET g_ary[3].dbs_tra = g_dbs_tra
            END IF

         AFTER FIELD plant_4
            LET g_plant_4 = duplicate(g_plant_4,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_4
            IF g_plant_4 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[4].plant = g_plant_4
               LET g_ary[4].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_4) THEN
                                        #檢查工廠並將新的資料庫放在g_dbs_new
                  #是否有此plant的權限
                  IF NOT s_chk_plant(g_plant_4) THEN
                     NEXT FIELD plant_4
                  END IF
                  IF NOT s_chknplt(g_plant_4,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_4
                  END IF
                  LET g_ary[4].plant = g_plant_4
                  CALL s_getdbs()
                  LET g_ary[4].dbs_new = g_dbs_new
               ELSE                     #輸入之工廠編號為' '或NULL
                  LET g_ary[4].plant = g_plant_4
               END IF
            END IF
            IF NOT cl_null(g_plant_4) THEN
                CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
                LET g_ary[4].dbs_tra = g_dbs_tra
            END IF

         AFTER FIELD plant_5
            LET g_plant_5 = duplicate(g_plant_5,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_5
            IF g_plant_5 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[5].plant = g_plant_5
               LET g_ary[5].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_5) THEN
                  #check User是否有此plant的權限
                  IF NOT s_chk_plant(g_plant_5) THEN
                     NEXT FIELD plant_5
                  END IF
                  IF NOT s_chknplt(g_plant_5,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_5
                  END IF
                  LET g_ary[5].plant = g_plant_5
                  CALL s_getdbs()
                  LET g_ary[5].dbs_new = g_dbs_new
               ELSE LET g_ary[5].plant = g_plant_5
               END IF
            END IF
            IF NOT cl_null(g_plant_5) THEN
                CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
                LET g_ary[5].dbs_tra = g_dbs_tra
            END IF

         AFTER FIELD plant_6
            LET g_plant_6 = duplicate(g_plant_6,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_6
            IF g_plant_6 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[6].plant = g_plant_6
               LET g_ary[6].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_6) THEN
                  #check User是否有此plant的權限
                  IF NOT s_chk_plant(g_plant_6) THEN
                     NEXT FIELD plant_6
                  END IF
                  IF NOT s_chknplt(g_plant_6,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_6
                  END IF
                  LET g_ary[6].plant = g_plant_6
                  CALL s_getdbs()
                  LET g_ary[6].dbs_new = g_dbs_new
               ELSE LET g_ary[6].plant = g_plant_6
               END IF
            END IF
            IF NOT cl_null(g_plant_6) THEN
                CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
                LET g_ary[6].dbs_tra = g_dbs_tra
            END IF

         AFTER FIELD plant_7
            LET g_plant_7 = duplicate(g_plant_7,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_7
            IF g_plant_7 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[7].plant = g_plant_7
               LET g_ary[7].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_7) THEN
                  #check User是否有此plant的權限
                  IF NOT s_chk_plant(g_plant_7) THEN
                     NEXT FIELD plant_7
                  END IF
                  IF NOT s_chknplt(g_plant_7,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_7
                  END IF
                  LET g_ary[7].plant = g_plant_7
                  CALL s_getdbs()
                  LET g_ary[7].dbs_new = g_dbs_new
               ELSE LET g_ary[7].plant = g_plant_7
               END IF
            END IF
            IF NOT cl_null(g_plant_7) THEN
                CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
                LET g_ary[7].dbs_tra = g_dbs_tra
            END IF

         AFTER FIELD plant_8
            LET g_plant_8 = duplicate(g_plant_8,3)   #不使"工廠編號"重覆
            LET g_plant_new= g_plant_8
            IF g_plant_8 = g_plant THEN
               LET g_dbs_new=''
               LET g_ary[8].plant = g_plant_8
               LET g_ary[8].dbs_new = g_dbs_new CLIPPED
            ELSE
               IF NOT cl_null(g_plant_8) THEN
                  #check User是否有此plant的權限
                  IF NOT s_chk_plant(g_plant_8) THEN
                     NEXT FIELD plant_8
                  END IF
                  IF NOT s_chknplt(g_plant_8,'AAP','AAP') THEN
                     CALL cl_err(g_plant_new,g_errno,0)
                     NEXT FIELD plant_8
                  END IF
                  LET g_ary[8].plant = g_plant_8
                  CALL s_getdbs()
                  LET g_ary[8].dbs_new = g_dbs_new
               ELSE LET g_ary[8].plant = g_plant_8
               END IF
            END IF
            IF NOT cl_null(g_plant_8) THEN
                CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
                LET g_ary[8].dbs_tra = g_dbs_tra
            END IF
            IF cl_null(g_plant_1) AND cl_null(g_plant_2) AND
               cl_null(g_plant_3) AND cl_null(g_plant_4) AND
               cl_null(g_plant_5) AND cl_null(g_plant_6) AND
               cl_null(g_plant_7) AND cl_null(g_plant_8) THEN
               CALL cl_err(0,'aap-136',0)
               NEXT FIELD plant_1
            END IF

         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(g_amd22) THEN
               DISPLAY g_amd22 TO amd22
               NEXT FIELD amd22
            END IF
            IF cl_null(g_plant_1) AND cl_null(g_plant_2) AND
               cl_null(g_plant_3) AND cl_null(g_plant_4) AND
               cl_null(g_plant_5) AND cl_null(g_plant_6) AND
               cl_null(g_plant_7) AND cl_null(g_plant_8) THEN
               CALL cl_err(0,'aap-136',0)
               NEXT FIELD plant_1
            ELSE
               LET g_ary[1].plant = g_plant_1
               LET g_ary[2].plant = g_plant_2
               LET g_ary[3].plant = g_plant_3
               LET g_ary[4].plant = g_plant_4
               LET g_ary[5].plant = g_plant_5
               LET g_ary[6].plant = g_plant_6
               LET g_ary[7].plant = g_plant_7
               LET g_ary[8].plant = g_plant_8
            END IF

         ON ACTION CONTROLP
            IF INFIELD(amd22) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ama"
               LET g_qryparam.default1 = g_amd22
               CALL cl_create_qry() RETURNING g_amd22
               DISPLAY BY NAME g_amd22
               NEXT FIELD amd22
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION exit      #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION locale                         #FUN-570123
            LET g_change_lang = TRUE              #FUN-570123
            EXIT INPUT                            #FUN-570123

         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
      END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'amdp010'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('amdp010','9031',1)
         ELSE
            LET g_wc1 = cl_replace_str(g_wc1,"'","\"")     #"
            LET g_wc2 = cl_replace_str(g_wc2,"'","\"")     #"
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc1 CLIPPED,"'",
                         " '",g_wc2 CLIPPED,"'",
                         " '",g_plant_1 CLIPPED,"'",
                         " '",g_plant_2 CLIPPED,"'",
                         " '",g_plant_3 CLIPPED,"'",
                         " '",g_plant_4 CLIPPED,"'",
                         " '",g_plant_5 CLIPPED,"'",
                         " '",g_plant_6 CLIPPED,"'",
                         " '",g_plant_7 CLIPPED,"'",
                         " '",g_plant_8 CLIPPED,"'",
                         " '",g_amd22 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('amdp010',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p010_s()
 DEFINE  l_sql          STRING,   #MOD-660082     #No.FUN-680074
         l_sql1         STRING,   #MOD-660082     #No.FUN-680074
         l_buf          LIKE type_file.chr1000,   #No.FUN-680074 CHAR(1000)
         l_k,l_l,l_n    LIKE type_file.num5,      #No.FUN-680074 SMALLINT
         l_omb          RECORD LIKE omb_file.*,
         l_ogb          RECORD LIKE ogb_file.*,
         l_oma00        LIKE oma_file.oma00,
         l_oma01        LIKE oma_file.oma01,
         l_oma33        LIKE oma_file.oma33,
         l_oma02        LIKE oma_file.oma02,
         l_oma16        LIKE oma_file.oma16,
         l_oma35        LIKE oma_file.oma35,
         l_oma36        LIKE oma_file.oma36,
         l_oma37        LIKE oma_file.oma37,
         l_oma38        LIKE oma_file.oma38,
         l_oma39        LIKE oma_file.oma39,
         l_yy,l_mm      LIKE type_file.num5,      #No.FUN-680074 SMALLINT
         l_omb03        LIKE omb_file.omb03,
         l_omb16        LIKE omb_file.omb16,
         l_omb16t       LIKE omb_file.omb16t,
         l_tax          LIKE omb_file.omb16t,
         l_ome01        LIKE ome_file.ome01,
         l_ome02        LIKE ome_file.ome02,
         l_ome04        LIKE ome_file.ome04,
         l_ome16        LIKE ome_file.ome16,
         l_ome16_t      LIKE ome_file.ome16,
         l_ome17        LIKE ome_file.ome17,
         l_ome171       LIKE ome_file.ome171,
         l_ome172       LIKE ome_file.ome172,
         l_ome39        LIKE ome_file.ome39,
         l_ome21        LIKE ome_file.ome21,
         l_ome042       LIKE ome_file.ome042,
         l_ome59        LIKE ome_file.ome59,
         l_ome59x       LIKE ome_file.ome59x,
         l_ome59t       LIKE ome_file.ome59t,
         l_ome60        LIKE ome_file.ome60,      #MOD-9C0427 add
         l_omevoid      LIKE ome_file.omevoid,
         l_oom01        LIKE oom_file.oom01,
         l_oom02        LIKE oom_file.oom02,
         l_oom07        LIKE oom_file.oom07,
         l_oom08        LIKE oom_file.oom08,
         l_gec06        LIKE gec_file.gec06,
         l_gec08        LIKE gec_file.gec08,
         l_amd10        LIKE amd_file.amd10,      #No:FUN-4C0105
         l_amd40        LIKE amd_file.amd40,
         l_amd41        LIKE amd_file.amd41,
         l_amd42        LIKE amd_file.amd42,
         l_amd43        LIKE amd_file.amd43,
         l_amb03        LIKE amb_file.amb03,      #No.FUN-680074 CHAR(2)
         l_kind         LIKE type_file.chr1,      #No.FUN-680074 CHAR(1)
         l_ome212       LIKE type_file.chr1,      #FUN-770040
         l_flag         LIKE type_file.chr1,      #No.FUN-680074 CHAR(1)
         g_idx,l_len    LIKE type_file.num5,      #No.FUN-680074 SMALLINT
         l_add_cnt      LIKE type_file.num5,      #No.FUN-680074 SMALLINT
         l_cnt,l_i      LIKE type_file.num10,     #No.FUN-680074 INTEGER    
         l_tot          LIKE type_file.num10,     #No.FUN-680074 INTEGER 
         l_omb44        LIKE omb_file.omb44,      #FUN-A60056
         l_omb31        LIKE omb_file.omb31,      #TQC-590009
        #l_omb32        LIKE omb_file.omb32,      #TQC-590009        #MOD-A80108
         l_omb18        LIKE omb_file.omb18,      #TQC-590009
         l_omb18t       LIKE omb_file.omb18t,     #TQC-590009
         l_ohb30        LIKE ohb_file.ohb30,      #TQC-590009
         l_cnt2         LIKE type_file.num5,      #MOD-610027        #No.FUN-680074 SMALLINT
         l_msg          LIKE type_file.chr20,     #No.FUN-680074 CHAR(20) #MOD-610027
         l_sql2         STRING,                   #TQC-9A0016
         li_source      STRING,                   #MOD-990101 add
         li_index       LIKE type_file.num5,      #MOD-990101 add
         l_ama01        LIKE ama_file.ama01,      #MOD-9C0427 add
         l_azp03        LIKE azp_file.azp03,      #CHI-A60029 add
         l_oga021       LIKE oga_file.oga021,     #MOD-A50126 add
         l_cnt3         LIKE type_file.num5,      #MOD-A70132 add
         l_chkoma01     LIKE oma_file.oma01       #MOD-AB0035
DEFINE l_cnt_oga        LIKE type_file.num5       #FUN-C20121 
DEFINE l_oga021_1       LIKE oga_file.oga021      #FUN-C20121
DEFINE l_month          LIKE type_file.num5       #FUN-C20121         
DEFINE l_oga65          LIKE oga_file.oga65       #MOD-C60182      

   IF g_wc1 != " 1=1 " OR g_wc2 !=" 1=1"  THEN
      LET l_buf=g_wc1 CLIPPED
      CALL cl_replace_str(l_buf,'ome05','oma05') RETURNING l_buf
      CALL cl_replace_str(l_buf,'ome01','oma10') RETURNING l_buf
      IF NOT cl_null(l_buf) THEN
         LET li_source=l_buf
         LET li_index = li_source.getIndexOf("oma10", 1)
         IF li_index >= 1 THEN   #表示條件裡有oma10
            IF l_buf[1,5]='oma10' THEN 
               LET l_buf=" 1=1 "
            ELSE
               IF l_buf[1,5]='oma05' THEN 
                  LET l_buf = li_source.subString(1, li_index-1)
                  LET l_buf = l_buf CLIPPED," 1=1 "
               ELSE
                  LET l_buf=" 1=1 "
               END IF
            END IF 
         END IF 
      ELSE
         LET l_buf=" 1=1 "
      END IF
      LET l_buf=l_buf CLIPPED," AND ",g_wc2 CLIPPED   #MOD-990101
      CALL cl_replace_str(l_buf,'ome05','oma05') RETURNING l_buf
      CALL cl_replace_str(l_buf,'ome01','oma10') RETURNING l_buf
      CALL cl_replace_str(l_buf,'ome02','oma09') RETURNING l_buf
      CALL cl_replace_str(l_buf,'ome16','oma01') RETURNING g_wc3
      IF cl_null(g_wc3) THEN
         LET g_wc3=" 1=1 "
      END IF
      LET l_buf=g_wc1 CLIPPED," AND ",g_wc2 CLIPPED
      CALL cl_replace_str(l_buf,'ome05','oma05') RETURNING l_buf
      CALL cl_replace_str(l_buf,'ome01','ohb30') RETURNING l_buf
      CALL cl_replace_str(l_buf,'ome02','oma09') RETURNING l_buf
      CALL cl_replace_str(l_buf,'ome16','oma01') RETURNING g_wc5
      IF cl_null(g_wc5) THEN
         LET g_wc5=" 1=1 "
      END IF
   END IF
  #IF g_wc2 != " 1=1 " THEN                             #MOD-A80243 mark
  #   LET l_buf=g_wc2                                   #MOD-A80243 mark
   IF g_wc1 != " 1=1 " OR g_wc2 !=" 1=1"  THEN          #MOD-A80243
      LET l_buf=g_wc1 CLIPPED," AND ",g_wc2 CLIPPED     #MOD-A80243
      CALL cl_replace_str(l_buf,'ome05','oga05') RETURNING l_buf   #MOD-A80243
      CALL cl_replace_str(l_buf,'ome01','oga01') RETURNING l_buf   #MOD-A80243 #發票編號比照 oga01 條件
      CALL cl_replace_str(l_buf,'ome02','oga02') RETURNING l_buf
      CALL cl_replace_str(l_buf,'ome16','oga01') RETURNING g_wc4
      IF cl_null(g_wc4) THEN
         LET g_wc4=" 1=1 "
      END IF
   END IF
   CALL ui.Interface.refresh()

   CALL p010_create_tmp()   #No:7756
   IF cl_null(g_wc4) THEN
      LET g_wc4=" 1=1 "
   END IF

   LET l_n=0      #MOD-950149 add
   FOR g_idx = 1 TO 8
      IF cl_null(g_ary[g_idx].plant) THEN
         CONTINUE FOR
      END IF
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=g_ary[g_idx].plant   #CHI-A60029 add
      LET g_ary[g_idx].dbs_new = s_dbstring(l_azp03 CLIPPED)        #CHI-A60029 add
      #依帳款編號讀單身資料
      LET l_sql1="SELECT * ",
                 #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," omb_file",
                 "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'omb_file'), #FUN-A50102
                 " WHERE  omb01 = ? "
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1    #FUN-750088
      CALL cl_parse_qry_sql(l_sql1,g_ary[g_idx].plant) RETURNING l_sql1 #FUN-A50102
      PREPARE p010_pomb FROM l_sql1
      DECLARE p010_omb CURSOR FOR p010_pomb
 
      #依出貨單號讀單身資料
      LET l_sql1="SELECT * ",
                 #"  FROM ",g_ary[g_idx].dbs_tra CLIPPED," ogb_file",  #FUN-980092 GP5.2 mod
                 "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'ogb_file'), #FUN-A50102
                 " WHERE  ogb01 = ? "
      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1    #FUN-750088
      CALL cl_parse_qry_sql(l_sql1,g_ary[g_idx].plant) RETURNING l_sql1 ##FUN-980092 GP5.2 add
   
      PREPARE p010_pogb FROM l_sql1
      DECLARE p010_ogb CURSOR FOR p010_pogb

      #-->銷貨部份 & 零稅率
      IF g_ooz.ooz64='Y' THEN
         LET l_sql="SELECT ome01,ome16,ome042,ome04,ome59,ome59x,ome59t,",
                   " ome17,ome171,ome172,ome02,ome21,omevoid,ome60,oma33,oma02,",  #FUN-970108 add ome60
                   " gec06,gec08,oma35,oma36,oma37,oma38,oma39, ",
                   " oma03,oma032,oma02,oma02,'1',ome212,oma16 ",   #FUN-770040   #MOD-8B0124 add oma16
                   #" FROM ",g_ary[g_idx].dbs_new CLIPPED," ome_file",
                   #" LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," oma_file ON ome01 = oma10 ",
                   #" LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file ON ome21 = gec01 ",
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ome_file'), #FUN-A50102
                   " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), #FUN-A50102
                   "  ON ome01 = oma10 ",
                  #"  AND oma00 LIKE '1%' ",                                                #MOD-AC0351 add #MOD-C30858 mark
                   "  AND (oma00 LIKE'1%' OR oma00 = '31') ",                               #MOD-C30858 add
                   " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), #FUN-A50102
                   "  ON ome21 = gec01 ",
                   " WHERE ome00 IN ('1','3') ",   #銷項發票&非應收發票
                   "   AND ome175 IS NULL ",    #流水號 #No:8157
                   "   AND ome212<>'X' ",            #No:8774 不抓不申報的格式
                  #"   AND oma00 LIKE '1%' ",  #MOD-AB0066   #MOD-AC0351 mark
                   "   AND gec011 = '2' ",     #銷項
                   "   AND ",g_wc1 CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                  #加上出至境外倉的出貨單(因為零稅率要申報,但未立AR)
                  " UNION ",
                  "SELECT '',oga01,oga033,oga03,oga50*oga24,",      #MOD-8A0237
                   "   oga50*oga211/100*oga24,oga50*oga24*(1+oga211/100),",
                   " '1','','',oga02,oga21,'N','',oga907,oga02,",   #MOD-650070 #FUN-970108 mod
                   " '','',oga35,oga36,oga37,oga38,oga39,",   #MOD-650070
                   " oga03,oga032,oga02,oga021,'3',oga212,'' ",   #FUN-770040   #MOD-8B0124 add ''
                   #" FROM ",g_ary[g_idx].dbs_tra CLIPPED,"oga_file ",  #FUN-980092 GP5.2 mod
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oga_file'), #FUN-A50102
                   #" WHERE oga00= '3' ",                   #出至境外倉        #FUN-C20121 mark
                   " WHERE ((oga00 = '3' AND oga09 IN ('2','8')) OR (oga00 = '1' AND oga09 = '2' AND oga65 ='Y'))",   #FUN-C20121
                   "   AND ogaconf = 'Y'",
                   "   AND oga08='2' ",     #外銷者
                  #"   AND oga09 IN ('2','8') ", #No.FUN-610079   #FUN-C20121 mark
                   "   AND oga35 !='A' ",                  #FUN-BA0052 外銷不申報改為A
                  #"   AND oga35 !='8' ",   #FUN-BA0052 mark #NO:3386 8.外銷不申報
                   "   AND ",g_wc4 CLIPPED
      #外銷不產生發票
      ELSE
         LET l_sql="SELECT ome01,ome16,ome042,ome04,ome59,ome59x,ome59t,",
                   " ome17,ome171,ome172,ome02,ome21,omevoid,ome60,oma33,oma02,", #FUN-970108 add ome60
                   " gec06,gec08,oma35,oma36,oma37,oma38,oma39, ",
                   " oma03,oma032,oma02,oma02,'1',ome212,oma16 ",   #FUN-770040   #MOD-8B0124 add oma16
                   #" FROM ",g_ary[g_idx].dbs_new CLIPPED," ome_file ",
                   #" LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," oma_file ON ome01 = oma10 ",
                   #" LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file ON ome21 = gec01 ",
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ome_file'), #FUN-A50102
                   " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), #FUN-A50102
                   "  ON ome01 = oma10 ",
                  #"  AND oma00 LIKE '1%' ",                                   #MOD-AC0351 add #MOD-C30858 mark
                   "  AND (oma00 LIKE'1%' OR oma00 = '31') ",                  #MOD-C30858 add
                   " LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), #FUN-A50102
                   "  ON ome21 = gec01 ",
                   " WHERE ome00 IN ('1','3') ",   #銷項發票&非應收發票
                   "   AND ome175 IS NULL ",    #流水號 #No:8157
                   "   AND ome212<>'X' ",            #No:8774 不抓不申報的格式
                  #"   AND oma00 LIKE '1%' ",  #MOD-AB0066   #MOD-AC0351 mark
                   "   AND gec011 = '2' ",     #銷項
                   "   AND ",g_wc1 CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   "  UNION ",
                  #"SELECT '',oma01,oma042,oma04,oma56,oma56x,oma56t,",                #TQC-740330 #MOD-8A0237 #MOD-CB0048 mark
                   "SELECT '',oma01,oma042,oma04,oma56+oma53,oma56x,oma56t+oma53,",    #MOD-CB0048 add
                   " oma17,oma171,oma172,oma02,oma21,omavoid,oma71,oma33,oma02,",  #FUN-970108 add oma71
                   " '','',oma35,oma36,oma37,oma38,oma39, ",   #MOD-650070
                   " oma03,oma032,oma02,oma02,'2',oma212,oma16 ",   #FUN-770040   #MOD-8B0124 add oma16
                   #" FROM ",g_ary[g_idx].dbs_new CLIPPED," oma_file ",  #MOD-660145
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), #FUN-A50102
                  #" WHERE oma00 MATCHES '1*' ",                                   #MOD-C30858 mark
                  #" WHERE (oma00 LIKE'1%' OR oma00 = '31') ",                         #MOD-C30858 add #MOD-CB0048 mark
                   " WHERE (oma00 LIKE'12' OR oma00 = '31') ",                         #MOD-CB0048 add
                  #"   AND oma175 IS NULL ",                 #流水號  #MOD-B90066 mark
                   "   AND (oma175 IS NULL OR oma175 = 0) ", #MOD-B90066 add
                   "   AND oma10 IS NULL AND oma08='2' ",
                   "   AND omaconf='Y' ",
                   "   AND omavoid='N' ",
                   "   AND ",g_wc3 CLIPPED,
                   "   AND oma35 <> 'A' ",         #FUN-BA0052 外銷不申報改為A 
                   "   AND oma161 <> 100 ",        #MOD-C10058
                  #"   AND oma35 <> '8' ",      #FUN-BA0052 mark          #No.MOD-B80174 add
                  #-MOD-C10058-add-
                  #外銷出貨應收若為 100% 預收,則改抓訂金金額
                   "  UNION ",
                   "SELECT '',oma01,oma042,oma04,oma53,oma53*oma211/100,oma53+oma53*oma211/100,",   
                   " oma17,oma171,oma172,oma02,oma21,omavoid,oma71,oma33,oma02,", 
                   " '','',oma35,oma36,oma37,oma38,oma39, ",   
                   " oma03,oma032,oma02,oma02,'2',oma212,oma16 ", 
                  #" FROM ",g_ary[g_idx].dbs_new CLIPPED," oma_file ",             #MOD-CB0048 mark
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),    #MOD-CB0048 add
                  #" WHERE oma00 MATCHES '1*' ",                                   #MOD-C30858 mark
                   " WHERE (oma00 LIKE'1%' OR oma00 = '31') ",                     #MOD-C30858 add
                   "   AND (oma175 IS NULL OR oma175 = 0) ", 
                   "   AND oma10 IS NULL AND oma08='2' ",
                   "   AND omaconf='Y' ",
                   "   AND omavoid='N' ",
                   "   AND ",g_wc3 CLIPPED,
                   "   AND oma35 <> 'A' ",       
                   "   AND oma161 = 100 ",
                  #-MOD-C10058-end-
                   #加上出至境外倉的出貨單(因為零稅率要申報,但未立AR)
                   " UNION ",
                   "SELECT '',oga01,oga033,oga03,oga50*oga24,",      #MOD-8A0237
                   "   oga50*oga211/100*oga24,oga50*oga24*(1+oga211/100),",
                   " '1','','',oga02,oga21,'N','',oga907,oga02,",   #MOD-650070  #FUN-970108 mod
                   " '','',oga35,oga36,oga37,oga38,oga39,",   #MOD-650070
                   " oga03,oga032,oga02,oga021,'3',oga212,'' ",   #FUN-770040   #MOD-8B0124 add ''
                   #" FROM ",g_ary[g_idx].dbs_tra CLIPPED,"oga_file ",  #FUN-980092 GP5.2 mod
                   " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oga_file'), #FUN-A50102
                  #" WHERE oga00= '3' ",                               #出至境外倉            #FUN-C20121 mark
                   " WHERE ((oga00 = '3' AND oga09 IN ('2','8')) OR (oga00 = '1' AND oga09 = '2' AND oga65 ='Y'))",   #FUN-C20121
                   "   AND ogaconf = 'Y'",
                   "   AND oga08='2' ",     #外銷者
                  #"   AND oga09 IN ('2','8') ",                       #No.FUN-610079    #FUN-C20121 mark
                   "   AND oga35 !='A' ",                              #FUN-BA0052 外銷不申報 改為A
                  #"   AND oga35 !='8' ",   #FUN-BA0052 mark #NO:3386 8.外銷不申報
                   "   AND ",g_wc4 CLIPPED
      END IF
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-750088
      CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql  ##FUN-980092 GP5.2 add

      PREPARE p010_preome FROM l_sql
      DECLARE p010_curome CURSOR WITH HOLD FOR p010_preome

      LET l_sql = "SELECT UNIQUE ooa33 ",
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED,"ooa_file,",
                  #" ",g_ary[g_idx].dbs_new CLIPPED,"oob_file",
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'ooa_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'oob_file'),     #FUN-A50102
                  " WHERE oob06 = ?",    #帳款編號
                  "   AND oob03 = '1'  ",               #借
                  "   AND oob04 = '3'  ",               #貸 抵
                  "   AND oob01 = ooa01",
                  "   AND ooaconf = 'Y'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-750088
      CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql   #FUN-A50102
      PREPARE p010_preooa1  FROM l_sql
      DECLARE p010_curooa1  CURSOR  FOR p010_preooa1
 
      ##先把資料塞到tmep table   ######
      FOREACH p010_curome INTO g_tmp.*,g_oma16   #MOD-8B0124 add g_oma16
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.SQLCODE,0)
            LET g_success='N'
            EXIT FOREACH
         END IF
         
         #----FUN-C20121 start--如果取到走簽收流程的出貨單沒有結關日，則取所產生的簽收單資料寫入
         #1.先找看看此單據是否來源為出貨單
         LET l_oga021 = NULL
         LET l_cnt_oga = 0 
         SELECT COUNT(*) INTO l_cnt_oga 
           FROM oga_file
          WHERE oga01 = g_tmp.ome16
            AND oga08 = '2'
         IF l_cnt_oga > 0 THEN   #來源為出貨單時取出是否有結關日期
            #SELECT oga021 INTO l_oga021_1      #MOD-C60182 mark
             SELECT oga021,oga65                #MOD-C60182 add
               INTO l_oga021_1,l_oga65          #MOD-C60182 add 
               FROM oga_file
              WHERE oga01 = g_tmp.ome16
                AND oga08 = '2'
            #IF cl_null(l_oga021_1) THEN                     #結關日為空時，則取簽收單資料 #MOD-C60182 mark
             IF cl_null(l_oga021_1) AND l_oga65 ='Y' THEN    #結關日為空時，則取簽收單資料 #MOD-C60182 add
                 LET l_month = MONTH(g_tmp.ome02)
                 LET l_sql = "SELECT '',oga01,oga033,oga03,oga50*oga24,", 
                             "   oga50*oga211/100*oga24,oga50*oga24*(1+oga211/100),",
                             " '1','','',oga02,oga21,'N','',oga907,oga02,",  
                             " '','',oga35,oga36,oga37,oga38,oga39,",  
                             " oga03,oga032,oga02,oga021,'3',oga212,'' ", 
                             #" FROM ",g_ary[g_idx].dbs_new CLIPPED," oga_file ", 
                             " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),   #TQC-C30273
                             "  WHERE oga011 = '",g_tmp.ome16,"'",
                             "    AND MONTH(oga02) ='",l_month,"'"   #要和來源出貨單同月份才能取
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql		
                 CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql  #TQC-C30273
                 PREPARE p010_oga011_p FROM l_sql
                 DECLARE p010_oga011_c CURSOR WITH HOLD FOR p010_oga011_p
                 OPEN p010_oga011_c
                 INITIALIZE g_tmp.* TO NULL
                 FETCH p010_oga011_c INTO g_tmp.*,g_oma16 
                 IF cl_null(g_tmp.ome16) THEN CONTINUE FOREACH END IF
             END IF
         END IF    
         #--FUN-C20121 end--------------------------------------------------------------------
         
         LET g_tmp.ome59x= cl_digcut(g_tmp.ome59x,g_azi04)            #MOD-C10058
         LET g_tmp.ome59t= cl_digcut(g_tmp.ome59t,g_azi04)            #MOD-C10058
        #MOD-A50126---add---start---
        #MOD-A70132---modify---start---
        #SELECT DISTINCT(omb31),omb44 INTO l_omb31,l_omb44 FROM ome_file,omb_file   #FUN-A60056 add omb44
        # WHERE ome16=omb01 AND ome01=g_tmp.ome01
         LET l_cnt3 = 0 
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
                     " WHERE omb01 = '",g_tmp.ome16,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql
         PREPARE sel_omb FROM l_sql
         EXECUTE sel_omb INTO l_cnt3
         IF l_cnt3 > 0 THEN
            LET l_sql = "SELECT DISTINCT(omb31) FROM ",cl_get_target_table(g_ary[g_idx].plant,'omb_file'),
                        " WHERE omb01 = '",g_tmp.ome16,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql
            PREPARE sel_omb31 FROM l_sql
            EXECUTE sel_omb31 INTO l_omb31 
            LET l_oga021 = null
        #MOD-A70132---modify---end---
           #FUN-A60056--mod--str--
           #SELECT oga021 INTO l_oga021 FROM oga_file
           # WHERE oga01 = l_omb31
           #   AND oga08='2'
            LET l_sql = "SELECT oga021 FROM ",cl_get_target_table(l_omb44,'oga_file'),
                        " WHERE oga01 = '",l_omb31,"'",
                        "   AND oga08 = '2'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,l_omb44) RETURNING l_sql
            PREPARE sel_oga021 FROM l_sql
            EXECUTE sel_oga021 INTO l_oga021
           #FUN-A60056--mod--end
        #MOD-A70132---add---start---
         ELSE
            LET l_sql = "SELECT oga021 FROM ",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),
                        " WHERE oga01 = '",g_tmp.ome16,"'",
                        "   AND oga08 = '2' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            #CALL cl_parse_qry_sql(l_sql,l_omb44) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql  #FUN-A50102
            PREPARE sel_oga0212 FROM l_sql
            EXECUTE sel_oga0212 INTO l_oga021
         END IF   
        #MOD-A70132---add---end--- 
         LET g_tmp.amd43 = l_oga021
        #MOD-A50126---add---end---
         IF g_ooz.ooz64='Y' THEN
            IF g_tmp.kind = '3' THEN
              #CHI-A60029---modify---start---
              #SELECT gec08,gec06,gec06,gec08
              #  INTO g_tmp.ome171,g_tmp.ome172,g_tmp.gec06,g_tmp.gec08
              #FROM gec_file WHERE gec011 = '2' AND gec01 = g_tmp.ome21     
               LET l_sql = " SELECT gec08,gec06,gec06,gec08 ",
                       #" FROM ",g_ary[g_idx].dbs_new CLIPPED,"gec_file ",
                       " FROM ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), #FUN-A50102
                       " WHERE gec011 = '2' AND gec01 = '",g_tmp.ome21,"'"  
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
               CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql
               PREPARE p010_preomeg  FROM l_sql
               EXECUTE p010_preomeg INTO g_tmp.ome171,g_tmp.ome172,g_tmp.gec06,g_tmp.gec08
              #CHI-A60029---modify---end---
            END IF
         ELSE
            IF g_tmp.kind = '2' THEN
              #CHI-A60029---modify---start---
              #SELECT gec06,gec08 INTO g_tmp.gec06,g_tmp.gec08
              #  #FROM gec_file WHERE gec011 = '2' AND gec01 = g_tmp.ome21       
               LET l_sql = "SELECT gec06,gec08 ",
                       #" FROM ",g_ary[g_idx].dbs_new CLIPPED,"gec_file ",
                       " FROM ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), #FUN-A50102
                       "  WHERE gec011 = '2' AND gec01 = '",g_tmp.ome21,"'"  
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
               CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql
               PREPARE p010_pregec  FROM l_sql
               EXECUTE p010_pregec INTO g_tmp.gec06,g_tmp.gec08
              #CHI-A60029---modify---end--- 
            END IF
            IF g_tmp.kind = '3' THEN
              #CHI-A60029---modify---start---
              #SELECT gec08,gec06,gec06,gec08
              #  INTO g_tmp.ome171,g_tmp.ome172,g_tmp.gec06,g_tmp.gec08
              #FROM gec_file WHERE gec011 = '2' AND gec01 = g_tmp.ome21       
               LET l_sql = "SELECT gec08,gec06,gec06,gec08 ",
                           #" FROM ",g_ary[g_idx].dbs_new CLIPPED,"gec_file ",
                           " FROM ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), #FUN-A50102
                           " WHERE gec011 = '2' AND gec01 = '",g_tmp.ome21,"'" 
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
               CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql
               PREPARE p010_pregec1  FROM l_sql
               EXECUTE p010_pregec1 INTO g_tmp.ome171,g_tmp.ome172,g_tmp.gec06,g_tmp.gec08 
              #CHI-A60029---modify---end--- 
            END IF
         END IF
        #出售產生的應收帳款的傳票號碼,必須回頭抓出售單的傳票編號
         IF cl_null(g_tmp.oma33) AND NOT cl_null(g_oma16) THEN
            LET g_cnt = 0
           #CHI-A60029---modify---start---
           #SELECT COUNT(*) INTO g_cnt FROM fbe_file              
           # WHERE fbe01 = g_oma16
           #IF g_cnt > 0 THEN
           #   SELECT fbe14 INTO g_tmp.oma33 FROM fbe_file       
           #    WHERE fbe01 = g_oma16
           #   IF cl_null(g_tmp.oma33) THEN LET g_tmp.oma33=' ' END IF
           #END IF
            #LET l_sql = "SELECT COUNT(*) FROM ",g_ary[g_idx].dbs_new CLIPPED,"fbe_file ", 
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ary[g_idx].plant,'fbe_file'), #FUN-A50102
                        " WHERE fbe01 = '",g_oma16,"'" 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
            CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql
            PREPARE p010_prefbe FROM l_sql
            EXECUTE p010_prefbe INTO g_cnt
            IF g_cnt > 0 THEN
               #LET l_sql = "SELECT fbe14 FROM ",g_ary[g_idx].dbs_new CLIPPED,"fbe_file ",  
               LET l_sql = "SELECT fbe14 FROM ",cl_get_target_table(g_ary[g_idx].plant,'fbe_file'), #FUN-A50102
                           " WHERE fbe01 = '",g_oma16,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
               CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql
               PREPARE p010_prefbe1 FROM l_sql
               EXECUTE p010_prefbe1 INTO g_tmp.oma33
               IF cl_null(g_tmp.oma33) THEN LET g_tmp.oma33=' ' END IF
            END IF
           #CHI-A60029---modify---end---
         END IF
         INSERT INTO p010_tmp VALUES(g_tmp.*,g_ary[g_idx].plant)  #MOD-950149
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","p010_tmp","","",SQLCA.SQLCODE,"","ins tmp:",1)   #No:FUN-660093
            LET g_success='N'
            EXIT FOREACH
         END IF
      END FOREACH
 
      LET l_sql = "SELECT ome01, ome16, ome042, ome04, ome59, ",
                  "  ome59x,ome59t,ome17,  ome171,ome172, ",
                  "  ome02, ome21, omevoid,oma33, oma02, ",
                  "  gec06, gec08, oma35,  oma36, ",
                  "  oma37, oma38, oma39,  amd40, ",
                  "  amd41, amd42,  amd43, kind,  ",
                  "  ome212, ome60 ", #FUN-770040 add ome212  #MOD-9C0427 add ome60
                  "  FROM p010_tmp ",
                  " WHERE plant='",g_ary[g_idx].plant,"'"    #MOD-950149
      IF g_aza.aza94= 'Y' THEN 
          IF g_amd22 <> 'ALL' THEN
              LET l_sql = l_sql CLIPPED, " AND ome60  = '",g_ama02,"'",
                      " ORDER BY ome16,ome02,ome01 "
          ELSE
              LET l_sql = l_sql CLIPPED, 
                      " ORDER BY ome16,ome02,ome01 "
          END IF
      ELSE
          LET l_sql = l_sql CLIPPED, 
                  " ORDER BY ome16,ome02,ome01 "
      END IF
      
      PREPARE p010_pretmp FROM l_sql
      DECLARE p010_curtmp CURSOR  FOR p010_pretmp

      FOREACH p010_curtmp INTO l_ome01,l_ome16,l_ome042,l_ome04,l_ome59,
                               l_ome59x,l_ome59t,l_ome17,l_ome171,l_ome172,
                               l_ome02,l_ome21,l_omevoid,l_oma33,l_oma02,
                               l_gec06,l_gec08,l_oma35,l_oma36,
                               l_oma37,l_oma38,l_oma39,
                               l_amd40,l_amd41,l_amd42,l_amd43,l_kind,
                               l_ome212,l_ome60   #FUN-770040 add l_ome212  #MOD-9C0427 add l_ome60
         CALL ui.Interface.refresh()
         IF SQLCA.sqlcode THEN
            LET g_success ='N'
            CALL cl_err('p010_curno',SQLCA.sqlcode,0) EXIT FOREACH
         END IF
         IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN
            CONTINUE FOREACH
         END IF
         LET l_chkoma01=l_ome16                                  #MOD-AB0035
         IF cl_null(l_ome16) THEN LET l_ome16=l_ome01 END IF     #No:7800

         LET l_cnt = l_cnt + 1
         IF cl_null(l_ome172) THEN LET l_ome172 = l_gec06 END IF
         IF cl_null(l_ome171) THEN LET l_ome171 = l_gec08 END IF
         IF cl_null(l_oma02) THEN LET l_oma02 = l_ome02 END IF
         LET l_yy    = YEAR(l_ome02)    #MOD-B50170 mod l_oma02 -> l_ome02
         LET l_mm    = MONTH(l_ome02)   #MOD-B50170 mod l_oma02 -> l_ome02
         #modify若統一編號第一碼或第二碼為英文字母則清為空白
         IF l_ome042[1,1] MATCHES '[A-Z,a-z]' OR
            l_ome042[2,2] MATCHES '[A-Z,a-z]' THEN
            LET l_ome042 = ' '
         END IF
         #--->作廢發票
         IF l_omevoid = 'Y' THEN
            LET l_ome042 = ' '  LET l_ome17 = ' '   #MOD-760101
            LET l_ome59t = 0    LET l_ome59x= 0   LET l_ome59 =  0
            LET l_ome172= 'F'   #MOD-750122 #FUN-A10039
         END IF
         #----->若傳票號碼為空白
         IF cl_null(l_oma33) THEN
            OPEN p010_curooa1 USING l_ome16
            FETCH p010_curooa1 INTO l_oma33
         END IF
         IF cl_null(l_oma33) THEN LET l_oma33 = ' ' END IF
         IF cl_null(l_ome16) THEN LET l_ome16 = ' ' END IF
         IF (l_ome16_t <> l_ome16) OR l_n=0 THEN   #NO:7222
            LET l_n=1
            LET l_ome16_t = ' '      #No:7800 Null無法判斷
         ELSE                        #MOD-9A0019 add
           #MOD-A30179---modify---start---
           #LET l_n = l_n + 1        #MOD-9A0019 add
           #IF l_ome171='33' OR l_ome171='34' THEN   #MOD-AB0035 mark
            IF NOT cl_null(l_chkoma01) THEN          #MOD-AB0035
               LET l_n = l_n + 1       
            ELSE
               CONTINUE FOREACH
            END IF
           #MOD-A30179---modify---end---
         END IF
         IF cl_null(l_ome01) THEN LET l_ome01=' ' END IF #MOD-990115         
         DELETE FROM amd_file WHERE amd03 = l_ome01 AND amd01 = l_ome16
                                AND amd021= '3'     AND amd30 = 'N'
                                AND amd02 = l_n
         LET l_ome042=l_ome042[1,10]     #MOD-470398
         LET l_amd10 = ' '   #MOD-580385
         IF (NOT cl_null(l_oma38) OR NOT cl_null(l_oma39)) AND l_ome172='2' THEN
            LET l_amd10='2'
         END IF
         IF (NOT cl_null(l_oma36) OR NOT cl_null(l_oma37)) AND l_ome172='2' THEN
            LET l_amd10='1'
         END IF

         IF cl_null(l_ome01) THEN LET l_ome01=' ' END IF #MOD-980244   
         SELECT COUNT(*) INTO g_cnt FROM amd_file
          WHERE amd03 = l_ome01 AND amd01 = l_ome16
            AND amd021= '3'     AND amd30 = 'Y'
            AND amd171= l_ome171
         IF g_cnt > 0 THEN
            IF g_bgjob = 'N' THEN  #NO.FUN-570123 
               MESSAGE l_ome01,'-->confirm and duplicate invoice data'
               CALL ui.Interface.refresh()
            END IF
            CONTINUE FOREACH
         END IF
         IF l_ome171 NOT MATCHES '3[3,4]' THEN   #MOD-640414
            LET l_cnt2=0
            IF cl_null(l_ome01) THEN LET l_ome01=' ' END IF #MOD-980244   
            SELECT COUNT(*) INTO l_cnt2 FROM amd_file
             WHERE amd03=l_ome01 AND amd171=l_ome171
               AND amd02=l_n   #MOD-950149 add
               AND amd01=l_ome16 #MOD-990074 add
            IF l_cnt2 > 0 THEN
               LET l_msg = l_ome01,'+',l_ome171
               CALL cl_err(l_msg,'amd-011',1)
               LET g_success = 'N'       #MOD-A30056 add
               LET begin_no = l_ome16    #MOD-A30056 add
               CONTINUE FOREACH
            END IF
         END IF
         IF l_ome171 = '36' THEN
            LET l_ome042 = ''
         END IF
        #MOD-A40093---modify---start---
        #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_ome60  #MOD-9C0427 add
         IF NOT cl_null(l_ome60) THEN
            SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_ome60  
         ELSE
           #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=g_amd22 #MOD-A50040 mark
            LET l_ama01 = g_amd22        #MOD-A50040 add
         END IF
        #MOD-A40093---modify---end---
         LET l_ome59 = cl_digcut(l_ome59,g_azi04)                     #MOD-A90091
         LET l_ome59x= cl_digcut(l_ome59x,g_azi04)                    #MOD-A90091
         LET l_ome59t= cl_digcut(l_ome59t,g_azi04)                    #MOD-A90091
         INSERT INTO amd_file (amd01,amd02,amd021,amd03,amd04,amd05,  #No:MOD-470041
                               amd06,amd07,amd08,amd09,amd10,amd17,
                               amd171,amd172,amd173,amd174,amd175,
                               amd22,amd25,amd26,amd27,amd28,amd29,
                               amd30,amd35,amd36,amd37,amd38,amd39,
                               amd40,amd41,amd42,amd43,amdacti,amduser,
                               #amdgrup,amdmodu,amddate,amdoriu,amdorig)   #FUN-770040
                               amdgrup,amdmodu,amddate,amd031,amd44,amdlegal)   #FUN-770040 #No:FUN-980004 #FUN-8B0081 add amd44
         VALUES(l_ome16,l_n,'3',l_ome01,l_ome042,l_ome02,
                l_ome59t,l_ome59x,l_ome59,'',l_amd10,'',        #No:FUN-4C0105   #MOD-730066
                l_ome171,l_ome172,l_yy,l_mm,'',
                l_ama01,g_ary[g_idx].plant,'','',l_oma33,'1',  #MOD-9C0427 g_amd22->l_ama01
                'N',l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,
                l_amd40,l_amd41,l_amd42,l_amd43,'Y',g_user,
                g_grup,'',g_today,l_ome212,'3',g_legal)   #FUN-770040 #No:FUN-980004 #FUN-8B0081 add'3'
         LET begin_no = l_ome16    #MOD-A30056
         IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN   #NO.TQC-790093
            CALL cl_err3("ins","amd_file",l_ome16,l_n,SQLCA.SQLCODE,"","ins amd1:",1)    #No:FUN-660093
            LET g_success='N'
            EXIT FOREACH
         END IF
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093
            IF l_ome16_t=l_ome16 THEN  #no:7222
               LET l_n=l_n+1
            END IF
            SELECT max(amd02)+1 INTO l_add_cnt
              FROM  amd_file
             WHERE amd01 = l_ome16
               AND amd021= '3'  #bug no:4892
            LET l_n = l_add_cnt
            IF l_ome171 NOT MATCHES '3[3,4]' THEN   #MOD-640414
               LET l_cnt2=0
               IF cl_null(l_ome01) THEN LET l_ome01=' ' END IF #MOD-980244   
               SELECT COUNT(*) INTO l_cnt2 FROM amd_file
                WHERE amd03=l_ome01 AND amd171=l_ome171
                  AND amd02=1       #MOD-990074 add
                  AND amd01=l_ome16 #MOD-990074 add
               IF l_cnt2 > 0 THEN
                  LET l_msg = l_ome01,'+',l_ome171
                  CALL cl_err(l_msg,'amd-011',1)
                  LET g_success = 'N'     #MOD-A30056 add
                  LET begin_no = l_ome16    #MOD-A30056
                  CONTINUE FOREACH
               END IF
            END IF
            IF l_ome171 = '36' THEN
               LET l_ome042 = ''
            END IF
           #MOD-A40093---modify---start---
           #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_ome60  #MOD-9C0427 add
            IF NOT cl_null(l_ome60) THEN
               SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_ome60  
            ELSE
              #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=g_amd22 #MOD-A50040 mark
               LET l_ama01 = g_amd22        #MOD-A50040 add
            END IF
           #MOD-A40093---modify---end---
            INSERT INTO amd_file (amd01,amd02,amd021,amd03,amd04,amd05,  #No:MOD-470041
                                  amd06,amd07,amd08,amd09,amd10,amd17,
                                  amd171,amd172,amd173,amd174,amd175,
                                  amd22,amd25,amd26,amd27,amd28,amd29,
                                  amd30,amd35,amd36,amd37,amd38,amd39,
                                  amd40,amd41,amd42,amd43,amdacti,amduser,
                                  #amdgrup,amdmodu,amddate,amdoriu,amdorig)   #FUN-770040
                                  amdgrup,amdmodu,amddate,amd031,amd44,amdlegal)   #FUN-770040 #No:FUN-980004 #FUN-8B0081 add amd44
            VALUES(l_ome16,l_n,'3',l_ome01,l_ome042,l_ome02,l_ome59t,
                   l_ome59x,l_ome59,'',l_amd10,'',l_ome171,l_ome172,          #No:FUN-4C0105   #MOD-730066
                   l_yy,l_mm,'',l_ama01,g_ary[g_idx].plant,'','',  #MOD-9C0427 g_amd22->l_ama01
                   l_oma33,'1','N',l_oma35,l_oma36,l_oma37,l_oma38,
                   l_oma39,l_amd40,l_amd41,l_amd42,l_amd43,'Y',
                   g_user,g_grup,'',g_today,l_ome212,'3',g_legal)   #FUN-770040 #No:FUN-980004 #FUN-8B0081 add'3'
            LET begin_no = l_ome16    #MOD-A30056
            IF status THEN
               CALL cl_err3("ins","amd_file",l_ome16,l_n,SQLCA.SQLCODE,"","ins amd2:",1)   #No:FUN-660093
               LET g_success = 'N'     #MOD-A30056 add
            END IF
         END IF
         #新增明細單身資料,for 零稅率清單會用到
         IF l_ome172='2' THEN                 #no:7392 零稅率才加
            DELETE FROM amf_file WHERE amf01 = l_ome16
                    AND amf02=l_n AND amf021='3'  #MOD-950149
            IF l_kind <> '3' THEN
               LET l_cnt2=0
              #CHI-A60029---modify---start---
              #SELECT COUNT(*) INTO l_cnt2 FROM oma_file WHERE oma01=l_ome16          
               #LET l_sql = " SELECT COUNT(*) FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file ",
               LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), #FUN-A50102
                           "  WHERE oma01='",l_ome16,"'"  
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
               CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql
               PREPARE p010_preoma FROM l_sql
               EXECUTE p010_preoma INTO l_cnt2 
              #CHI-A60029---modify---end---
               IF cl_null(l_cnt2) THEN LET l_cnt2=0 END IF
               #多張帳款合併開立發票,需以發票號碼(ome01)回串oma10
               LET l_sql1="SELECT oma01 ",
                          #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," oma_file"
                          "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file') #FUN-A50102
               IF l_cnt2 = 0 THEN
                  LET l_sql1=l_sql1 CLIPPED," WHERE oma10='",l_ome16,"'"
               ELSE
                  LET l_sql1=l_sql1 CLIPPED," WHERE oma01='",l_ome16,"'"
               END IF
               CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1    #FUN-750088
               CALL cl_parse_qry_sql(l_sql1,g_ary[g_idx].plant) RETURNING l_sql1
               PREPARE p010_poma FROM l_sql1
               DECLARE p010_oma CURSOR FOR p010_poma
               FOREACH p010_oma INTO l_oma01
               FOREACH p010_omb USING l_oma01 INTO l_omb.*  #MOD-920379
                  IF SQLCA.SQLCODE<>0 THEN EXIT FOREACH END IF
                  INSERT INTO amf_file(amf01,amf02,amf021,amf022,amf03,  #No:MOD-470041
                                       amf04,amf06,amf07,amflegal) #No:FUN-980004
                  VALUES(l_ome16,l_n,'3',l_omb.omb01,l_omb.omb03,   #No:8236   #MOD-880219
                         l_omb.omb04,l_omb.omb06,l_omb.omb12,g_legal) #No:FUN-980004
                  IF SQLCA.SQLCODE THEN
                     CALL cl_err3("ins","amf_file",l_ome16,"",SQLCA.SQLCODE,"","ins amf2:",1) #No:FUN-660093
                     LET g_success='N'
                     LET begin_no = l_ome16    #MOD-A30056
                     EXIT FOREACH
                  END IF
               END FOREACH
               END FOREACH   #MOD-920379 add
            ELSE
               FOREACH p010_ogb USING l_ome16 INTO l_ogb.*
                  IF SQLCA.SQLCODE<>0 THEN EXIT FOREACH END IF
                  INSERT INTO amf_file(amf01,amf02,amf021,amf022,amf03,  #No:MOD-470041
                                       amf04,amf06,amf07,amflegal) #No:FUN-980004
                  VALUES(l_ome16,l_n,'3',l_ogb.ogb01,l_ogb.ogb03, #No:8236   #TQC-740330   #MOD-880219
                         l_ogb.ogb04,l_ogb.ogb06,l_ogb.ogb12,g_legal) #No:FUN-980004
                  IF SQLCA.SQLCODE THEN
                     CALL cl_err3("ins","amf_file",l_ome16,"",SQLCA.SQLCODE,"","ins amf3:",1)    #No:FUN-660093
                     LET g_success='N'
                     LET begin_no = l_ome16    #MOD-A30056
                     EXIT FOREACH
                  END IF
               END FOREACH
            END IF
         END IF
         LET l_ome16_t=l_ome16   #NO:7222
         IF cl_null(l_ome16_t) THEN LET l_ome16_t=' ' END IF  #NO:7222
      END FOREACH
      IF g_success='N' THEN
         EXIT FOR
      END IF
     #-->銷退折讓
     IF g_ooz.ooz64='Y' THEN  #CHI-A60029 add
      LET l_sql = "SELECT oma00,oma16,oma10,oma01,oma03,occ11,",   #TQC-710078
                  " sum(omb16),sum(omb16t-omb16),sum(omb16t),oma17,oma171,oma172,",
                  " oma02,oma21,oma33,gec06,gec08, ",
                  " oma35,oma36,oma37,oma38,oma39, ",
                  " oma03,oma032,oma02,oma02, ",
                  " oma212,ome60 ",   #FUN-770040  #MOD-9C0427 add ome60
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," oma_file ",
                  #"  LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file ON oma21 = gec01 ", 
                  #"  LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," occ_file ON oma03 = occ01, ",
                  #          g_ary[g_idx].dbs_new CLIPPED," omb_file,",
                  #          g_ary[g_idx].dbs_tra CLIPPED," ohb_file,",   #FUN-980092 GP5.2 mod
                  #          g_ary[g_idx].dbs_new CLIPPED," ome_file ", #MOD-9A0139 
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), #FUN-A50102
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), #FUN-A50102
                  "  ON oma21 = gec01 ", 
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'), #FUN-A50102
                  "  ON oma03 = occ01, ",
                            cl_get_target_table(g_ary[g_idx].plant,'omb_file'),",", #FUN-A50102
                            cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",", #FUN-A50102
                            cl_get_target_table(g_ary[g_idx].plant,'ome_file'),     #FUN-A50102
                  " WHERE (oma00 = '21' OR oma00 = '25')",  #銷退折讓
                 #"   AND oma175 IS NULL ",                 #流水號  #MOD-B90066 mark
                  "   AND (oma175 IS NULL OR oma175 = 0) ", #MOD-B90066 add
                  "   AND oma01 = omb01 ",
                  "   AND omb31 = ohb01 ",
                  "   AND omb32 = ohb03 ",
                  "   AND ohb30=ome01 ",       #MOD-9A0139     
                  "   AND gec011 = '2' ",      #銷項
                  "   AND omavoid = 'N' ",
                  "   AND omaconf = 'Y' ",
                  "   AND ",g_wc5  CLIPPED     #TQC-710078
      #CHI-A60029 add --start--
      IF g_aza.aza94 = 'Y' THEN   #有要做總公司匯總申報者才需依部門為條件 
         IF g_amd22 <> 'ALL' THEN  
            LET l_sql = l_sql CLIPPED, " AND ome60  = '",g_ama02,"'"      
         END IF 
      END IF
      LET l_sql = l_sql CLIPPED,
                  " GROUP BY  oma00,oma16,oma10,oma01,oma03,occ11, ",                                                
                  "   oma17,oma171,oma172, ",                                                                                       
                  "   oma02,oma21,oma33,gec06,gec08, ",                                                                             
                  "   oma35,oma36,oma37,oma38,oma39, ",                                                                             
                  "   oma03,oma032,oma02,oma02,oma212,ome60 "   #MOD-A90033 modify , 
                 #"   ORDER BY oma01 "                          #MOD-A90033 mark
      #CHI-A60029 add --end--
     #-MOD-A90033-add-
      LET l_sql = l_sql CLIPPED,
                  " UNION ",
                  "SELECT oma00,oma16,oma10,oma01,oma03,occ11,",  
                  " sum(omb16),sum(omb16t-omb16),sum(omb16t),oma17,oma171,oma172,",
                  " oma02,oma21,oma33,gec06,gec08, ",
                  " oma35,oma36,oma37,oma38,oma39, ",
                  " oma03,oma032,oma02,oma02, ",
                  " oma212,oma71 ",   
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), 
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), 
                  "  ON oma21 = gec01 ", 
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'), 
                  "  ON oma03 = occ01, ",
                            cl_get_target_table(g_ary[g_idx].plant,'omb_file'),",", 
                            cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",", 
                            cl_get_target_table(g_ary[g_idx].plant,'amd_file'),  
                  " WHERE (oma00 = '21' OR oma00 = '25')",  #銷退折讓
                 #"   AND oma175 IS NULL ",                 #流水號  #MOD-B90066 mark
                  "   AND (oma175 IS NULL OR oma175 = 0) ", #MOD-B90066 add
                  "   AND oma01 = omb01 ",
                  "   AND omb31 = ohb01 ",
                  "   AND omb32 = ohb03 ",
                  "   AND ohb30 = amd03 ", 
                  "   AND amd171 IN ('31','32') ",      #MOD-B50133
                  "   AND ohb30 NOT IN (SELECT ome01 FROM ome_file WHERE omevoid = 'N') ",   #MOD-A90081 
                  "   AND gec011 = '2' ",                   #銷項
                  "   AND omavoid = 'N' ",
                  "   AND omaconf = 'Y' ",
                  "   AND ",g_wc5  CLIPPED     
      IF g_aza.aza94 = 'Y' THEN   #有要做總公司匯總申報者才需依部門為條件 
         IF g_amd22 <> 'ALL' THEN  
            LET l_sql = l_sql CLIPPED, " AND oma71  = '",g_ama02,"'"      
         END IF 
      END IF
      LET l_sql = l_sql CLIPPED,
                  " GROUP BY  oma00,oma16,oma10,oma01,oma03,occ11, ",                                                
                  "   oma17,oma171,oma172, ",                                                                                       
                  "   oma02,oma21,oma33,gec06,gec08, ",                                                                             
                  "   oma35,oma36,oma37,oma38,oma39, ",                                                                             
                  "   oma03,oma032,oma02,oma02,oma212,oma71 "
                 #"   ORDER BY oma01 "                 #MOD-B70081 mark
     #-MOD-A90033-end-
     #CHI-A60029 add --start--
     ELSE
      LET l_sql = "SELECT oma00,oma16,oma10,oma01,oma03,occ11,",
                  " sum(omb16),sum(omb16t-omb16),sum(omb16t),oma17,oma171,oma172,",
                  " oma02,oma21,oma33,gec06,gec08, ",
                  " oma35,oma36,oma37,oma38,oma39, ",
                  " oma03,oma032,oma02,oma02, ",
                  " oma212,ome60 ",
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," oma_file,",
                  #"  LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file ON oma21 = gec01 ", 
                  #"  LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," occ_file ON oma03 = occ01, ",
                  #          g_ary[g_idx].dbs_new CLIPPED," omb_file,",
                  #          #g_ary[g_idx].dbs_new CLIPPED," ohb_file",
                  #          g_ary[g_idx].dbs_new CLIPPED," ohb_file,",
                  #          g_ary[g_idx].dbs_new CLIPPED," ome_file,",  
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), #FUN-A50102
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), #FUN-A50102
                  "  ON oma21 = gec01 ", 
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'), #FUN-A50102
                  "  ON oma03 = occ01, ",
                            cl_get_target_table(g_ary[g_idx].plant,'omb_file'),",", #FUN-A50102
                            cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",", #FUN-A50102
                            cl_get_target_table(g_ary[g_idx].plant,'ome_file'),     #FUN-A50102    
                  " WHERE (oma00 = '21' OR oma00 = '25')",  #銷退折讓
                 #"   AND oma175 IS NULL ",                 #流水號  #MOD-B90066 mark
                  "   AND (oma175 IS NULL OR oma175 = 0) ", #MOD-B90066 add
                  "   AND oma01 = omb01 ",
                  "   AND omb31 = ohb01 ",
                  "   AND omb32 = ohb03 ",
                  "   AND ohb30=ome01 ", #MOD-9A0139      
                  "   AND gec011 = '2' ",   #銷項
                  "   AND omavoid = 'N' ",
                  "   AND omaconf = 'Y' ",
                  "   AND ",g_wc5  CLIPPED 
      IF g_aza.aza94 = 'Y' THEN   #有要做總公司匯總申報者才需依部門為條件 
         IF g_amd22 <> 'ALL' THEN  
            LET l_sql = l_sql CLIPPED, " AND ome60  = '",g_ama02,"'"      
         END IF 
      END IF
      LET l_sql = l_sql CLIPPED,
                  " GROUP BY  oma00,oma16,oma10,oma01,oma03,occ11, ",                                                
                  "   oma17,oma171,oma172, ",                                                                                       
                  "   oma02,oma21,oma33,gec06,gec08, ",                                                                             
                  "   oma35,oma36,oma37,oma38,oma39, ",                                                                             
                  "   oma03,oma032,oma02,oma02,oma212,ome60 "
     #-MOD-A90033-add-
      LET l_sql = l_sql CLIPPED,
                  " UNION ",
                  "SELECT oma00,oma16,oma10,oma01,oma03,occ11,",  
                  " sum(omb16),sum(omb16t-omb16),sum(omb16t),oma17,oma171,oma172,",
                  " oma02,oma21,oma33,gec06,gec08, ",
                  " oma35,oma36,oma37,oma38,oma39, ",
                  " oma03,oma032,oma02,oma02, ",
                  " oma212,oma71 ",   
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), 
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), 
                  "  ON oma21 = gec01 ", 
                  "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'), 
                  "  ON oma03 = occ01, ",
                            cl_get_target_table(g_ary[g_idx].plant,'omb_file'),",", 
                            cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",", 
                            cl_get_target_table(g_ary[g_idx].plant,'amd_file'),  
                  " WHERE (oma00 = '21' OR oma00 = '25')",  #銷退折讓
                 #"   AND oma175 IS NULL ",                 #流水號  #MOD-B90066 mark
                  "   AND (oma175 IS NULL OR oma175 = 0) ", #MOD-B90066 add
                  "   AND oma01 = omb01 ",
                  "   AND omb31 = ohb01 ",
                  "   AND omb32 = ohb03 ",
                  "   AND ohb30 = amd03 ", 
                  "   AND amd171 IN ('31','32') ",      #MOD-B50133
                  "   AND ohb30 NOT IN (SELECT ome01 FROM ome_file WHERE omevoid = 'N') ",   #MOD-A90081 
                  "   AND gec011 = '2' ",                   #銷項
                  "   AND omavoid = 'N' ",
                  "   AND omaconf = 'Y' ",
                  "   AND ",g_wc5  CLIPPED     
      IF g_aza.aza94 = 'Y' THEN   #有要做總公司匯總申報者才需依部門為條件 
         IF g_amd22 <> 'ALL' THEN  
            LET l_sql = l_sql CLIPPED, " AND oma71  = '",g_ama02,"'"      
         END IF 
      END IF
      LET l_sql = l_sql CLIPPED,
                  " GROUP BY  oma00,oma16,oma10,oma01,oma03,occ11, ",                                                
                  "   oma17,oma171,oma172, ",                                                                                       
                  "   oma02,oma21,oma33,gec06,gec08, ",                                                                             
                  "   oma35,oma36,oma37,oma38,oma39, ",                                                                             
                  "   oma03,oma032,oma02,oma02,oma212,oma71 "
     #-MOD-A90033-end-
     #str MOD-B30599 mark
     #LET l_sql = l_sql CLIPPED,
     #            " UNION ",
     #            "SELECT oma00,oma16,oma10,oma01,oma03,occ11,",
     #            " sum(omb16),sum(omb16t-omb16),sum(omb16t),oma17,oma171,oma172,",
     #            " oma02,oma21,oma33,gec06,gec08, ",
     #            " oma35,oma36,oma37,oma38,oma39, ",
     #            " oma03,oma032,oma02,oma02, ",
     #            " oma212,oma71 ", 
     #            #"  FROM ",g_ary[g_idx].dbs_new CLIPPED," oma_file,",
     #            #"  LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," gec_file ON oma21 = gec01 ", 
     #            #"  LEFT OUTER JOIN ",g_ary[g_idx].dbs_new CLIPPED," occ_file ON oma03 = occ01, ",
     #            #          g_ary[g_idx].dbs_new CLIPPED," omb_file,",
     #            #          g_ary[g_idx].dbs_new CLIPPED," ohb_file,",
     #            "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), #FUN-A50102
     #            "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), #FUN-A50102
     #            "  ON oma21 = gec01 ", 
     #            "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'), #FUN-A50102
     #            "  ON oma03 = occ01, ",
     #                      cl_get_target_table(g_ary[g_idx].plant,'omb_file'),",", #FUN-A50102
     #                      cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),     #FUN-A50102
     #            " WHERE (oma00 = '21' OR oma00 = '25')",  #銷退折讓
     #            "   AND oma175 IS NULL ",    #流水號
     #            "   AND oma01 = omb01 ",
     #            "   AND omb31 = ohb01 ",
     #            "   AND omb32 = ohb03 ",
     #            "   AND gec011 = '2' ",   #銷項  
     #            "   AND omavoid = 'N' ",
     #            "   AND omaconf = 'Y' ",
     #            "   AND ",g_wc5  CLIPPED
     #IF g_aza.aza94 = 'Y' THEN   #有要做總公司匯總申報者才需依部門為條件 
     #   IF g_amd22 <> 'ALL' THEN  
     #      LET l_sql = l_sql CLIPPED, " AND oma71  = '",g_ama02,"'"      
     #   END IF 
     #END IF
     #LET l_sql = l_sql CLIPPED,
     #            " GROUP BY  oma00,oma16,oma10,oma01,oma03,occ11, ",                                                
     #            "   oma17,oma171,oma172, ",                                                                                       
     #            "   oma02,oma21,oma33,gec06,gec08, ",                                                                             
     #            "   oma35,oma36,oma37,oma38,oma39, ",                                                                             
     #            "   oma03,oma032,oma02,oma02,oma212,oma71 ", 
     #            "   ORDER BY oma01 "
     #end MOD-B30599 mark
     END IF
    #-MOD-B70081-add-
     LET l_sql = l_sql CLIPPED,
                 " UNION ",
                 "SELECT oma00,oma16,oma10,oma01,oma03,occ11,",
                 " sum(omb16),sum(omb16t-omb16),sum(omb16t),oma17,oma171,oma172,",
                 " oma02,oma21,oma33,gec06,gec08, ",
                 " oma35,oma36,oma37,oma38,oma39, ",
                 " oma03,oma032,oma02,oma02, ",
                 " oma212,oma71 ", 
                 "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'), 
                 "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'gec_file'), 
                 "  ON oma21 = gec01 ", 
                 "  LEFT OUTER JOIN ",cl_get_target_table(g_ary[g_idx].plant,'occ_file'), 
                 "  ON oma03 = occ01, ",
                           cl_get_target_table(g_ary[g_idx].plant,'omb_file'),",", 
                           cl_get_target_table(g_ary[g_idx].plant,'ohb_file'), 
                 " WHERE (oma00 = '21' OR oma00 = '25')",  #銷退折讓
                #"   AND oma175 IS NULL ",                 #流水號  #MOD-B90066 mark
                 "   AND (oma175 IS NULL OR oma175 = 0) ", #MOD-B90066 add
                 "   AND oma01 = omb01 ",
                 "   AND omb31 = ohb01 ",
                 "   AND omb32 = ohb03 ",
                 "   AND oma08 = '2' ",                 
                 "   AND ohb30 IS NULL ",             
                 "   AND gec011 = '2' ",   #銷項  
                 "   AND omavoid = 'N' ",
                 "   AND omaconf = 'Y' ",
                 "   AND ",g_wc5  CLIPPED
     IF g_aza.aza94 = 'Y' THEN   #有要做總公司匯總申報者才需依部門為條件 
        IF g_amd22 <> 'ALL' THEN  
           LET l_sql = l_sql CLIPPED, " AND oma71  = '",g_ama02,"'"      
        END IF 
     END IF
     LET l_sql = l_sql CLIPPED,
                 " GROUP BY  oma00,oma16,oma10,oma01,oma03,occ11, ",                                                
                 "   oma17,oma171,oma172, ",                                                                                       
                 "   oma02,oma21,oma33,gec06,gec08, ",                                                                             
                 "   oma35,oma36,oma37,oma38,oma39, ",                                                                             
                 "   oma03,oma032,oma02,oma02,oma212,oma71 ", 
                 "   ORDER BY oma01 "
    #-MOD-B70081-end-
     #CHI-A60029 add --end--
     #str MOD-990116 mod
     #            "   GROUP BY  oma00,oma16,oma10,oma01,oma03,occ11, ",    #TQC-710078
     #            "   oma17,oma171,oma172, ",
     #            "   oma02,oma21,oma33,gec06,gec08, ",
     #            "   oma35,oma36,oma37,oma38,oma39, ",
     #            "   oma03,oma032,oma02,oma02,oma212,ome60 "       #FUN-770040    #MOD-A30012 add ome60
     #IF g_aza.aza94 = 'Y' THEN   #有要做總公司彙總申報者才需依部門為條件
     #   IF g_amd22 <> 'ALL' THEN
     #      LET l_sql = l_sql CLIPPED, " AND ome60  = '",g_ama02,"'",  #MOD-9A0139  oma71-->ome60   
     #                  "   ORDER BY oma01 " 
     #   ELSE
     #      LET l_sql = l_sql CLIPPED, 
     #                  "   ORDER BY oma01 "
     #   END IF
     #ELSE
     #   LET l_sql = l_sql CLIPPED, 
     #               "   ORDER BY oma01 "
     #END IF
     #CHI-A60029 mark --start--
     #IF g_aza.aza94 = 'Y' THEN   #有要做總公司匯總申報者才需依部門為條件 
     #   IF g_amd22 <> 'ALL' THEN  
     #      LET l_sql = l_sql CLIPPED, " AND ome60  = '",g_ama02,"'"   #MOD-9A0139  oma71-->ome60    
     #   END IF 
     #END IF
     #LET l_sql = l_sql CLIPPED,
     #            " GROUP BY  oma00,oma16,oma10,oma01,oma03,occ11, ",                                                
     #            "   oma17,oma171,oma172, ",                                                                                       
     #            "   oma02,oma21,oma33,gec06,gec08, ",                                                                             
     #            "   oma35,oma36,oma37,oma38,oma39, ",                                                                             
     #            "   oma03,oma032,oma02,oma02,oma212,ome60 ",      #MOD-A30012 add ome60
     #            "   ORDER BY oma01 "                  
     #CHI-A60029 mark --end--                                           
     #end MOD-990116 mod
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-750088
      CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql  ##FUN-980092 GP5.2 add

      PREPARE p010_preoma2 FROM l_sql
      DECLARE p010_curoma2 CURSOR WITH HOLD FOR p010_preoma2

      LET l_sql = "SELECT UNIQUE ooa33 ",
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED,"ooa_file,",
                  #          g_ary[g_idx].dbs_new CLIPPED,"oob_file",
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'ooa_file'),",", #FUN-A50102
                            cl_get_target_table(g_ary[g_idx].plant,'oob_file'),     #FUN-A50102
                  " WHERE oob06 = ?",    #帳款編號
                  "   AND oob03 = '1'  ",               #借
                  "   AND oob04 = '3'  ",               #貸 抵
                  "   AND oob01 = ooa01",
                  "   AND ooaconf = 'Y'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-750088
      CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql   #FUN-A50102
      PREPARE p010_preooa  FROM l_sql
      DECLARE p010_curooa  CURSOR  FOR p010_preooa

      LET l_sql = "SELECT UNIQUE oma33 ",
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file,",
                  #" ",g_ary[g_idx].dbs_tra CLIPPED,"oha_file",  #FUN-980092 GP5.2 mod
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),     #FUN-A50102
                  " WHERE oha01 = ? ",    #帳款編號
                  "   AND ohaconf = 'Y'",
                  "   AND oha16 = oma01",
                  "   AND omaconf = 'Y'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-750088
      CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql  ##FUN-980092 GP5.2 add

      PREPARE p010_preooa2  FROM l_sql
      DECLARE p010_curooa2  CURSOR  FOR p010_preooa2

      LET l_sql = "SELECT ome01,ome02,ome17,ome171,ome172 ",
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file,",
                  #" ",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),     #FUN-A50102
                  " WHERE oma01 = ?",    #帳款編號
                  "   AND ome212<>'X' ",   #No:8774不抓不申報的格式
                  "   AND oma10 = ome01"
      IF g_aza.aza94 = 'Y' THEN
          IF g_amd22 <> 'ALL' THEN
              LET l_sql = l_sql CLIPPED, " AND ome60  = '",g_ama02,"'"
          END IF
      END IF
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-750088
      CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql    #FUN-A50102
      PREPARE p010_preome1 FROM l_sql
      DECLARE p010_curome1 CURSOR  FOR p010_preome1

      LET l_sql = "SELECT ome01,ome02,ome17,ome171,ome172",
                  #"  FROM ",g_ary[g_idx].dbs_tra CLIPPED,"oha_file,",  #FUN-980092 GP5.2 mod
                  #" ",g_ary[g_idx].dbs_tra CLIPPED,"ohb_file,",        #FUN-980092 GP5.2 mod
                  #" ",g_ary[g_idx].dbs_tra CLIPPED,"oga_file,",        #FUN-980092 GP5.2 mod
                  #" ",g_ary[g_idx].dbs_new CLIPPED,"ome_file",
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'oga_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'ome_file'),     #FUN-A50102
                  " WHERE oha01 = ?",    #帳款編號
                  "   AND ohaconf = 'Y'",
                  "   AND oha01 = ohb01",
                  "   AND ohb31 = oga01",
                  "   AND ome212<>'X' ",   #No:8774不抓不申報的格式
                  "   AND oga10 = ome16",
                  "   AND ome01 = ohb30"                          #MOD-A90090
      IF g_aza.aza94 = 'Y' THEN
          IF g_amd22 <> 'ALL' THEN
             LET l_sql = l_sql CLIPPED, " AND ome60  = '",g_ama02,"'"
          END IF
      END IF
     #-MOD-A90090-add-
      LET l_sql = l_sql CLIPPED,
                  " UNION ",
                  "SELECT amd03,amd05,amd17,amd171,amd172",
                  #"  FROM ",g_ary[g_idx].dbs_new CLIPPED,"oha_file,",
                  #" ",g_ary[g_idx].dbs_new CLIPPED,"ohb_file,",
                  #" ",g_ary[g_idx].dbs_new CLIPPED,"amd_file,",
                  #" ",g_ary[g_idx].dbs_new CLIPPED,"ama_file",
                  "  FROM ",cl_get_target_table(g_ary[g_idx].plant,'oha_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'amd_file'),",", #FUN-A50102
                  "       ",cl_get_target_table(g_ary[g_idx].plant,'ama_file'),     #FUN-A50102
                  " WHERE oha01 = ?",    #帳款編號
                  "   AND ohaconf = 'Y'",
                  "   AND oha01 = ohb01",
                  "   AND ama01 = amd22 ", 
                  "   AND ohb30 NOT IN (SELECT ome01 FROM ome_file WHERE omevoid = 'N') ",
                  "   AND ohb30 = amd03 "
      IF g_aza.aza94 = 'Y' THEN
         IF g_amd22 <> 'ALL' THEN
            LET l_sql = l_sql CLIPPED, " AND ama02  = '",g_ama02,"'"
         END IF
      END IF
     #-MOD-A90090-end-
     #-MOD-B70081-add-
      LET l_sql = l_sql CLIPPED,
                  " UNION ",
                  "SELECT '',oha02,'1',gec08,gec06 ",
                  "  FROM ",g_ary[g_idx].dbs_new CLIPPED,"oha_file,",
                  " ",g_ary[g_idx].dbs_new CLIPPED,"ohb_file,",
                  " gec_file,oma_file ",
                  " WHERE oha01 = ?", 
                  "   AND ohaconf = 'Y'",
                  "   AND oha01 = ohb01",
                  "   AND gec01 = oha21 AND gec011 = '2' ",
                  "   AND oha10 = oma01 ", 
                  "   AND omaconf = 'Y'",
                  "   AND ohb30 IS NULL "
      IF g_aza.aza94 = 'Y' THEN
         IF g_amd22 <> 'ALL' THEN
            LET l_sql = l_sql CLIPPED, " AND oma71 = '",g_ama02,"'"
         END IF
      END IF
     #-MOD-B70081-end-
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-750088
      CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql  ##FUN-980092 GP5.2 add

      PREPARE p010_preome2 FROM l_sql
      DECLARE p010_curome2 CURSOR  FOR p010_preome2

      LET l_ome16_t = ' '   #MOD-640394
      FOREACH p010_curoma2 INTO l_oma00,l_oma16,l_ome01,l_ome16,l_ome04,
                                l_ome042,l_ome59,l_ome59x,l_ome59t,
                                l_ome17,l_ome171,l_ome172,
                                l_oma02,l_ome21,l_oma33,l_gec06,l_gec08,
                                l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,
                                l_amd40,l_amd41,l_amd42,l_amd43,l_ome212,  #FUN-770040
                                l_ome60  #MOD-9C0427 add
        IF SQLCA.sqlcode THEN
           CALL cl_err('p010_curnome2',SQLCA.sqlcode,0)
           LET g_success = 'N'              #MOD-A30056 add
           LET begin_no = l_ome16           #MOD-A30056 add
           EXIT FOR
        END IF
        CALL ui.Interface.refresh()
        DELETE FROM amd_file WHERE amd01=l_ome16
                               AND amd021='3'  AND amd30 = 'N'
                              #AND amd02 = l_n   #MOD-950149 add     #MOD-A80108  
 
        #--->銷退之傳票號碼
        IF cl_null(l_oma33) THEN
           IF l_oma00 = '25' THEN
              OPEN p010_curooa USING l_ome16    #canny(9/1)
              FETCH p010_curooa INTO l_oma33
           END IF
           IF l_oma00 = '21' THEN
              OPEN p010_curooa USING l_ome16    #canny(9/1)
              FETCH p010_curooa INTO l_oma33
           END IF
        END IF

        IF cl_null(l_ome01) THEN    #發票號碼
           IF l_oma00 = '25' THEN     #銷退
              OPEN p010_curome1 USING l_ome16
              FETCH p010_curome1 INTO l_ome01,l_ome02,
                                      l_ome17,l_ome171,l_ome172
              IF STATUS THEN
                 CALL cl_err('sel ome',STATUS,0) LET l_ome01=''
                 LET g_success = 'N'              #MOD-A30056 add
                 LET begin_no = l_ome16           #MOD-A30056 add
              END IF
           END IF
           IF l_oma00 = '21' THEN    #銷折
             #CHI-A60029---modify---start---
             #DECLARE omb_cur CURSOR FOR
             #   SELECT DISTINCT omb03,omb31,omb32,omb18,omb18t
             #     FROM oma_file,omb_file     
             #    WHERE omb01 = oma01 AND oma01 = l_ome16
             #-MOD-A80108-mod-
             #LET l_sql = " SELECT DISTINCT omb03,omb31,omb32,omb18,omb18t ",
             #            #" FROM ",g_ary[g_idx].dbs_new CLIPPED,"oma_file,",g_ary[g_idx].dbs_new CLIPPED,"omb_file ", 
             #            " FROM ",cl_get_target_table(g_ary[g_idx].plant,'oma_file'),",", #FUN-A50102
             #                     cl_get_target_table(g_ary[g_idx].plant,'omb_file'),     #FUN-A50102
             #            " WHERE omb01 = oma01 AND oma01 = '",l_ome16,"'"
              LET l_sql = " SELECT MAX(omb03),ohb01,ohb30,SUM(omb18),SUM(omb18t) ",
                          " FROM ",cl_get_target_table(g_ary[g_idx].plant,'ohb_file'),",", 
                                   cl_get_target_table(g_ary[g_idx].plant,'omb_file'),    
                          " WHERE omb01 = '",l_ome16,"' and ohb01 = omb31 and ohb03 = omb32 ",    
                          " GROUP BY ohb01,ohb30 " 
             #-MOD-A80108-end-
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql	
              CALL cl_parse_qry_sql(l_sql,g_ary[g_idx].plant) RETURNING l_sql #FUN-A50102
              DECLARE omb_cur CURSOR FROM l_sql
             #CHI-A60029---modify---end---
           END IF
        END IF
        IF cl_null(l_oma33) THEN LET l_oma33 = ' ' END IF
       #銷退折讓單身若多筆,但發票號碼相同,拋到amdi100應還是彙總成一筆
        LET l_cnt = 0
       #FUN-A60056--mod--str--
       #SELECT COUNT(DISTINCT ohb30) INTO l_cnt
       #  FROM oma_file,omb_file,ohb_file
       # WHERE oma01=omb01 AND oma01=l_ome16
       #   AND omb31=ohb01 AND omb32=ohb03
        LET l_sql = "SELECT UNIQUE omb44 FROM omb_file ",
                    " WHERE omb01 = '",l_ome16,"'"
        PREPARE sel_omb44_pre FROM l_sql
        DECLARE sel_omb44_cur CURSOR FOR sel_omb44_pre
        LET l_i = 0
        LET l_cnt = 0
        FOREACH sel_omb44_cur INTO l_omb44
           LET l_sql = "SELECT COUNT(DISTINCT ohb30) FROM oma_file,omb_file,",
                       "     ",cl_get_target_table(l_omb44,'ohb_file'),  
                       " WHERE oma01=omb01 AND oma01='",l_ome16,"'",
                       "   AND omb31=ohb01 AND omb32=ohb03"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_omb44) RETURNING l_sql
           PREPARE sel_cou_ohb30 FROM l_sql
           EXECUTE sel_cou_ohb30 INTO l_i
           LET l_cnt = l_cnt+l_i
        END FOREACH
       #FUN-A60056--mod--end
        IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
        IF l_cnt = 1 THEN
          #FUN-A60056--mod--str--
          #SELECT DISTINCT ohb30 INTO l_ome01
          #  FROM oma_file,omb_file,ohb_file
          # WHERE oma01=omb01 AND oma01=l_ome16
          #   AND omb31=ohb01 AND omb32=ohb03
           LET l_sql = "SELECT UNIQUE omb44 FROM omb_file ", 
                       " WHERE omb01 = '",l_ome16,"'"
           PREPARE sel_omb44_pre1 FROM l_sql
           DECLARE sel_omb44_cur1 CURSOR FOR sel_omb44_pre1
           FOREACH sel_omb44_cur1 INTO l_omb44
               LET l_sql = "SELECT DISTINCT ohb30 FROM oma_file,omb_file,",
                           "     ",cl_get_target_table(l_omb44,'ohb_file'),
                           " WHERE oma01=omb01 AND oma01='",l_ome16,"'",
                           "   AND omb31=ohb01 AND omb32=ohb03" 
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,l_omb44) RETURNING l_sql
               PREPARE sel_ohb30 FROM l_sql
              #EXECUTE sel_ohb30 INTO l_i      #MOD-B20035 mark
               EXECUTE sel_ohb30 INTO l_ome01  #MOD-B20035
           END FOREACH
          #FUN-A60056--mod--end
           IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN
              CONTINUE FOREACH
           END IF
          #-MOD-AA0025-add-
           IF l_ome171 = '36' THEN
              LET l_ome042 = ''
           END IF
          #-MOD-AA0025-end-
           IF cl_null(l_ome172) THEN LET l_ome172 = l_gec06 END IF
           IF cl_null(l_ome171) THEN LET l_ome171 = l_gec08 END IF
           IF l_ome171 = '31' THEN LET l_ome171 = '33' END IF
           IF l_ome171 = '35' THEN LET l_ome171 = '33' END IF   #MOD-810085
           IF l_ome171 = '32' THEN LET l_ome171 = '34' END IF
           IF l_ome171 = '36' THEN LET l_ome171 = '34' END IF
           LET l_yy    = YEAR(l_oma02)      #canny(9/1)
           LET l_mm    = MONTH(l_oma02)     #canny(9/1)
           IF l_ome042[1,1] MATCHES '[A-Z,a-z]' OR
              l_ome042[2,2] MATCHES '[A-Z,a-z]' THEN
              LET l_ome042 = ' '
           END IF
           IF l_ome171 NOT MATCHES '3[3,4]' THEN   #MOD-640414
              LET l_cnt2=0
              IF cl_null(l_ome01) THEN LET l_ome01=' ' END IF #MOD-980244   
              SELECT COUNT(*) INTO l_cnt2 FROM amd_file
               WHERE amd03=l_ome01 AND amd171=l_ome171
                 AND amd02=1       #MOD-990074 add
                 AND amd01=l_ome16 #MOD-990074 add
              IF l_cnt2 > 0 THEN
                 LET l_msg = l_ome01,'+',l_ome171
                 CALL cl_err(l_msg,'amd-011',1)
                 LET g_success = 'N'              #MOD-A30056 add
                 LET begin_no = l_ome16           #MOD-A30056 add
                 CONTINUE FOREACH
              END IF
           END IF
          #IF l_ome171 = '36' THEN   #MOD-AA0025 mark
          #   LET l_ome042 = ''      #MOD-AA0025 mark
          #END IF                    #MOD-AA0025 mark
          #MOD-A40093---modify---start---
          #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_ome60  #MOD-9C0427 add
           IF NOT cl_null(l_ome60) THEN
              SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_ome60  
           ELSE
             #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=g_amd22 #MOD-A50040 mark
              LET l_ama01 = g_amd22        #MOD-A50040 add
           END IF
          #MOD-A40093---modify---end---
         #--------MOD-C30869-------------mark
         ##-MOD-A90096-add-
         # SELECT ome02 INTO l_oma02
         #   FROM ome_file
         #  WHERE ome01 = l_ome01 
         # IF SQLCA.sqlcode THEN
         #    SELECT amd05 INTO l_oma02
         #      FROM amd_file
         #     WHERE amd03 = l_ome01
         #       AND amd171 IN ('31','32','35','36') 
         # END IF
         ##-MOD-A90096-end-
         #--------MOD-C30869-------------mark
           INSERT INTO amd_file (amd01,amd02,amd021,amd03,amd04,amd05,  #No:MOD-470041
                                 amd06,amd07,amd08,amd09,amd10,amd17,
                                 amd171,amd172,amd173,amd174,amd175,
                                 amd22,amd25,amd26,amd27,amd28,amd29,
                                 amd30,amd35,amd36,amd37,amd38,amd39,
                                 amd40,amd41,amd42,amd43,amdacti,amduser,
                                #amdgrup,amdmodu,amddate,amd031,amd44,amdoriu,amdorig)   #FUN-770040 #FUN-8B0081 add amd44
                                 amdgrup,amdmodu,amddate,amd031,amd44,amdoriu,amdorig,amdlegal)   #FUN-770040 #FUN-8B0081 add amd44 #MOD-A90033 add amdlegal
           VALUES(l_ome16,1,'3',l_ome01,l_ome042,l_oma02,l_ome59t,   #TQC-590009   #MOD-7C0223
                  l_ome59x,l_ome59,'','','',l_ome171,l_ome172,l_yy,   #TQC-710078   #MOD-730066
                  l_mm,'',l_ama01,g_ary[g_idx].plant,'','',l_oma33,  #MOD-9C0427 g_amd22->l_ama01
                  '1','N',l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,
                  l_amd40,l_amd41,l_amd42,l_amd43,'Y',g_user,g_grup,
                 #'',g_today,l_ome212,'3', g_user, g_grup)   #FUN-770040 #FUN-8B0081 add'3'      #No.FUN-980030 10/01/04  insert columns oriu, orig
                  '',g_today,l_ome212,'3', g_user, g_grup, g_legal )   #FUN-770040 #FUN-8B0081 add'3'      #No.FUN-980030 10/01/04  insert columns oriu, orig #MOD-A90033 
           LET begin_no = l_ome16    #MOD-A30056
           IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN   #NO.TQC-790093
              CALL cl_err3("ins","amd_file",l_ome16,l_omb03,SQLCA.sqlcode,"","",1)   #No:FUN-660093
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        ELSE
           CALL s_gettrandbs()         #TQC-9A0016
           LET l_yy    = YEAR(l_oma02)      #MOD-AB0074
           LET l_mm    = MONTH(l_oma02)     #MOD-AB0074
          #FOREACH omb_cur INTO l_omb03,l_omb31,l_omb32,l_omb18,l_omb18t     #MOD-A80108 mark
           FOREACH omb_cur INTO l_omb03,l_omb31,l_ohb30,l_omb18,l_omb18t     #MOD-A80108
              IF SQLCA.SQLCODE<>0 THEN EXIT FOREACH END IF
               #LET l_sql2 = "SELECT ohb30 INTO l_ohb30 FROM ",g_dbs_tra CLIPPED,"ohb_file, ",
               #              g_dbs_tra CLIPPED,"oha_file ",
              #-MOD-A80108-mark-
              #LET l_sql2 = "SELECT ohb30 INTO l_ohb30 FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",", #FUN-A50102
              #                                               cl_get_target_table(g_plant_new,'oha_file'),     #FUN-A50102
              #             " WHERE oha01 = ohb01 AND oha01 = '",l_omb31,"'",
              #             "   AND ohb03 = '",l_omb32,"'" 
              #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2              #FUN-A50102								
              #    CALL cl_parse_qry_sql(l_sql2,g_plant_new) RETURNING l_sql2 #FUN-A50102             
              #PREPARE sql2_pre FROM l_sql2
              #EXECUTE sql2_pre             
              #-MOD-A80108-end-
             #OPEN p010_curome2 USING l_omb31                       #MOD-A90090 mark
              OPEN p010_curome2 USING l_omb31,l_omb31,l_omb31       #MOD-A90090 #MOD-B70081 add omb31
              FETCH p010_curome2 INTO l_ome01,l_ome02,
                                      l_ome17,l_ome171,l_ome172
             #IF STATUS THEN #CHI-A60029 mark
              IF STATUS AND g_ooz.ooz64='Y' THEN #CHI-A60029
                 CALL cl_err('sel ome',STATUS,0) LET l_ome01=''
                 LET g_success = 'N'              #MOD-A30056 add
                 LET begin_no = l_ome16           #MOD-A30056 add
              END IF
              LET l_ome01 = l_ohb30
              LET l_ome59t= l_omb18t
              LET l_ome59x= l_omb18t-l_omb18
              LET l_ome59 = l_omb18
          
              IF cl_null(l_gec08) OR l_gec08 = 'XX' THEN
                 CONTINUE FOREACH
              END IF
             #-MOD-AA0025-add-
              IF l_ome171 = '36' THEN
                 LET l_ome042 = ''
              END IF
             #-MOD-AA0025-end-
              IF cl_null(l_ome172) THEN LET l_ome172 = l_gec06 END IF
              IF cl_null(l_ome171) THEN LET l_ome171 = l_gec08 END IF
              IF l_ome171 = '31' THEN LET l_ome171 = '33' END IF
              IF l_ome171 = '35' THEN LET l_ome171 = '33' END IF   #MOD-810085
              IF l_ome171 = '32' THEN LET l_ome171 = '34' END IF
              IF l_ome171 = '36' THEN LET l_ome171 = '34' END IF
             #LET l_yy    = YEAR(l_oma02)      #canny(9/1)         #MOD-AB0074 mark
             #LET l_mm    = MONTH(l_oma02)     #canny(9/1)         #MOD-AB0074 mark
              #若統一編號第一碼或第二碼為英文字母則清為空白
              IF l_ome042[1,1] MATCHES '[A-Z,a-z]' OR
                 l_ome042[2,2] MATCHES '[A-Z,a-z]' THEN
                 LET l_ome042 = ' '
              END IF
              IF l_ome171 NOT MATCHES '3[3,4]' THEN   #MOD-640414
                 LET l_cnt2=0
                 IF cl_null(l_ome01) THEN LET l_ome01=' ' END IF #MOD-980244   
                 SELECT COUNT(*) INTO l_cnt2 FROM amd_file
                  WHERE amd03=l_ome01 AND amd171=l_ome171
                    AND amd02=1       #MOD-990074 add
                    AND amd01=l_ome16 #MOD-990074 add
                 IF l_cnt2 > 0 THEN
                    LET l_msg = l_ome01,'+',l_ome171
                    CALL cl_err(l_msg,'amd-011',1)
                    CONTINUE FOREACH
                    LET g_success = 'N'              #MOD-A30056 add
                    LET begin_no = l_ome16           #MOD-A30056 add
                 END IF
              END IF
             #IF l_ome171 = '36' THEN     #MOD-AA0025 mark
             #   LET l_ome042 = ''        #MOD-AA0025 mark
             #END IF                      #MOD-AA0025 mark
             #MOD-A40093---modify---start---
             #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_ome60  #MOD-9C0427 add
              IF NOT cl_null(l_ome60) THEN
                 SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=l_ome60  
              ELSE
                #SELECT ama01 INTO l_ama01 FROM ama_file WHERE ama02=g_amd22 #MOD-A50040 mark
                 LET l_ama01 = g_amd22        #MOD-A50040 add
              END IF
             #MOD-A40093---modify---end---
            #--------MOD-C30869-------------mark
            ##-MOD-A90096-add-
            # SELECT ome02 INTO l_oma02
            #   FROM ome_file
            #  WHERE ome01 = l_ome01 
            # IF SQLCA.sqlcode THEN
            #    SELECT amd05 INTO l_oma02
            #      FROM amd_file
            #     WHERE amd03 = l_ome01
            #       AND amd171 IN ('31','32','35','36') 
            # END IF
            ##-MOD-A90096-end-
            #--------MOD-C30869-------------mark
              INSERT INTO amd_file (amd01,amd02,amd021,amd03,amd04,amd05,  #No:MOD-470041
                                    amd06,amd07,amd08,amd09,amd10,amd17,
                                    amd171,amd172,amd173,amd174,amd175,
                                    amd22,amd25,amd26,amd27,amd28,amd29,
                                    amd30,amd35,amd36,amd37,amd38,amd39,
                                    amd40,amd41,amd42,amd43,amdacti,amduser,
                                    amdgrup,amdmodu,amddate,amd031,amd44,amdlegal)   #FUN-770040 #No:FUN-980004 #FUN-8B0081 add amd44
              VALUES(l_ome16,l_omb03,'3',l_ome01,l_ome042,l_oma02,l_ome59t,   #TQC-590009   #MOD-7C0223
                     l_ome59x,l_ome59,'','','',l_ome171,l_ome172,l_yy,   #TQC-710078   #MOD-730066
                     l_mm,'',l_ama01,g_ary[g_idx].plant,'','',l_oma33,  #MOD-9C0427 g_amd22->l_ama01
                     '1','N',l_oma35,l_oma36,l_oma37,l_oma38,l_oma39,
                     l_amd40,l_amd41,l_amd42,l_amd43,'Y',g_user,g_grup,
                     '',g_today,l_ome212,'3',g_legal)   #FUN-770040 #No:FUN-980004 #FUN-8B0081 add'3'
              LET begin_no = l_ome16           #MOD-A30056 add
              IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN   #NO.TQC-790093
                 CALL cl_err3("ins","amd_file",l_ome16,l_omb03,SQLCA.sqlcode,"","",1)   #No:FUN-660093
                 LET g_success = 'N'
                 EXIT FOREACH
               END IF
            END FOREACH    #TQC-590009
         END IF   #MOD-980192 add
      END FOREACH
   END FOR

  #MOD-A30056---add---start---
   IF begin_no IS NULL THEN
      CALL cl_err('','aap-129',1)
      LET g_success = 'N'
   END IF
  #MOD-A30056---add---end---
END FUNCTION

FUNCTION duplicate(l_plant,n)     #檢查輸入之工廠編號是否重覆
   DEFINE l_plant      LIKE azp_file.azp01
   DEFINE l_idx, n     LIKE type_file.num10        #No.FUN-680074 INTEGER

   FOR l_idx = 1 TO n
      IF g_ary[l_idx].plant = l_plant THEN
         LET l_plant = ''
      END IF
   END FOR
   RETURN l_plant
END FUNCTION

FUNCTION p010_chk_db()
   DEFINE l_i       LIKE type_file.num5          #No.FUN-680074 SMALLINT

   FOR l_i = 1 TO 8 STEP 1
      CASE l_i
         WHEN 1  LET g_plant_new= g_plant_1
         WHEN 2  LET g_plant_new= g_plant_2
         WHEN 3  LET g_plant_new= g_plant_3
         WHEN 4  LET g_plant_new= g_plant_4
         WHEN 5  LET g_plant_new= g_plant_5
         WHEN 6  LET g_plant_new= g_plant_6
         WHEN 7  LET g_plant_new= g_plant_7
         WHEN 8  LET g_plant_new= g_plant_8
      END CASE
      IF cl_null(g_plant_new) THEN
         CONTINUE FOR
      END IF
      IF g_plant_new = g_plant THEN
         LET g_dbs_new=''
         LET g_ary[l_i].plant = g_plant_new
         LET g_ary[l_i].dbs_new = g_dbs_new CLIPPED
      ELSE
         LET g_ary[l_i].plant = g_plant_new
         CALL s_getdbs()
         LET g_ary[l_i].dbs_new = g_dbs_new
      END IF
       CALL s_gettrandbs()            ##FUN-980092 GP5.2  #改抓Transaction DB
       LET g_ary[l_i].dbs_tra = g_dbs_tra
   END FOR
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
