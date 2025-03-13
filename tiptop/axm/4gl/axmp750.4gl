# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp750.4gl
# Descriptions...: 銷退單入帳還原
# Date & Author..: 95/02/03 By Roher
# Modify.........: No:8467 By Melody p750_u_ima()對ima26的值更新有誤,
#                : 改成與s_udima一樣
# Modify.........: No.MOD-4B0178 u_img 傳入數量已是 img 數量(ohb16),不必再乘 對 img轉換率
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-550011 05/05/31 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-540049 雙單位內容修改
# Modify.........: No.FUN-560178 05/06/24 By Mandy 做過帳后,無法扣帳還原, 因為做庫存扣帳時有判斷數量<>0 and NOT NULL 才做 insert tlff 
# Modify.........: No.FUN-560178 05/06/24 By Mandy 相對的做扣帳還原時也要加上判斷數量<>0 and NULL 才做del tlff                              
# Modify.........: No.FUN-610062 06/01/18 By yoyo  增加代送銷退單的出貨單過帳還原
# Modify.........: NO.TQC-620156 06/03/10 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: No.TQC-640125 06/04/14 By yoyo 客戶欄位調整
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6B0169 06/12/12 By Carol 5.折讓不扣庫存
# Modify.........: No.FUN-720001 07/02/01 By Nicola 錯誤訊息匯總修改
# Modify.........: No.FUN-740016 07/05/09 By Nicola 借出管理
# Modify.........: No.FUN-7A0038 07/10/22 By Carrier 調貨出貨扣帳還原時,oha1018/oha1015賦值為NULL/N 
# Modify.........: No.MOD-7C0148 07/01/21 By claire 5.折讓應刪除tlf_file
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: NO.FUN-860025 08/06/16 BY yiting 銷退還原要處理tlfs_file
# Modify.........: No.MOD-860337 08/07/16 By Pengu 呼叫s_stkminus()時，參數原先是給b_ohb.ohb16應該給b_ohb.ohb12
# Modify.........: No.MOD-890123 08/09/25 By Smapmin 過帳還原時,產生的調撥單若不能過帳還原,整個動作應該要ROLLBACK
# Modify.........: No.MOD-890249 08/09/27 By chenyu axmt700過賬還原的時候，如果是icd版的，要增加CALL s_icdpost()
# Modify.........: No.MOD-8A0062 08/10/08 By Smapmin 因為不管數量是否為0皆有寫入tlff_file,故此處不管數量是否為0皆要刪除tlff_file
# Modify.........: No.CHI-8B0046 08/12/11 By Nicola 如為借貨訂單，update銷退量時，也一併update結案量
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 rowid
# Modify.........: No.MOD-910150 09/01/14 By Smapmin 變數使用錯誤
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯，不要rollback ，要放g_success ='N'
# Modify.........: No.MOD-950124 09/05/18 By Dido 5.折讓時,MISC料件不刪除tlf_file 
# Modify.........: No.FUN-980010 09/08/21 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No.FUN-A90049 10/10/13 By huangtao 刪除異動檔之前增加料號參數的判斷
# Modify.........: No:FUN-B40098 10/05/18 By shiwuying 扣率代銷時產生一筆非成本倉的雜收單和成本倉的倉退單
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No.FUN-B70074 11/07/21 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.TQC-B80005 11/08/03 By jason s_icdpost函數傳入參數
# Modify.........: No:MOD-B80050 11/09/07 By Summer 要一併刪除調撥單的rvbs_file
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-BA0069 11/10/24 By huangtao 將銷退單所產生的負向積分異動資料, 從 lsm_file 中刪除, 及更新 lpj_file.
# Modify.........: No.FUN-BB0024 11/11/07 By yangxf 將銷退單所產生的負向積分異動資料, 從 lsm_file 中刪除, 及更新 lpj_file.
# Modify.........: No.FUN-910088 12/01/16 By chenjing 增加數量欄位小數取位
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行
# Modify.........: No:CHI-B40056 12/02/29 By Summer tup08,tup09是No Use不使用的欄位,調整為tup11,tup12 
# Modify.........: No:FUN-C50097 12/06/04 By SunLM 當oaz92=Y(立賬走開票流程)且大陸版時,判斷參數oaz94='Y'(出貨多次簽收)時，增加多次簽收功能
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:TQC-C70206 12/07/27 By SunLM將FUN-C50097中，非多次多次簽收功能過單到正式區，既與oaz94無關的參數。
# Modify.........: No.MOD-C80104 12/09/17 By jt_chen 當axmt700單據過帳後，如果退貨方式是3會回寫ogb64，退貨方式2會回寫ogb63，沒有再判別單身料號是MISC
# Modify.........: No.TQC-C90070 12/09/20 By SunLM 大陸版多次簽收功能oha09='3'此条件下
# Modify.........: No:FUN-C80110 12/09/24 By shiwuying 计算会员卡累计消费额
# Modify.........: No.MOD-CB0083 12/11/13 By SunLM "2/3"類型的銷退單不能開立發票,同時不更新發票倉庫存
# Modify.........: No:CHI-C90032 12/12/13 By pauline 計算業務額度時將尾差去除
# Modify.........: No:MOD-CC0088 12/12/14 By jt_chen MOD-C80104調整不完整導致MISC料號，過帳還原出現負庫存數訊息
# Modify.........: No:MOD-CB0111 12/11/12 By jt_chen 修正:因FUN-630102將adq改為tuq,adp改為tup、FUN-650108已經將ATM合併至AXM
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:MOD-D10185 13/03/12 By jt_chen MISC無庫存資料，故不應該產生調撥單。扣帳還原 axmp650 也須調整
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: NO:TQC-D30066 12/03/26 By lixh1 其他作業串接時更改提示信息apm-936
# Modify.........: NO:TQC-D70054 13/07/22 By qirl 銷退單號欄位增加開窗
# Modify.........: No.2021113001 21/11/30 By jc 销退单扣账还原前同步SCM

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oha			RECORD LIKE oha_file.*
DEFINE b_ohb			RECORD LIKE ohb_file.*
DEFINE g_wc,g_wc2,g_sql         STRING  #No.FUN-580092 HCN
DEFINE g_cmd                    LIKE type_file.chr1000 #z.show畫面  y.不show畫面        #No.FUN-680137 VARCHAR(1)
DEFINE g_argv1                  LIKE oha_file.oha01
DEFINE g_argv2                  LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE g_cnt                    LIKE type_file.num5    #No.FUN-540049  #No.FUN-680137 SMALLINT
DEFINE l_oga00                  LIKE oga_file.oga00
DEFINE g_oga                    RECORD lIKE oga_file.*
DEFINE g_ogb                    RECORD lIKE ogb_file.*
DEFINE g_rxx04_point            LIKE rxx_file.rxx04         #抵現積分   #FUN-BB0024  ADD
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL 
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_oha.oha01=ARG_VAL(1)
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
#TQC-D30066 ------Begin--------
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' AND NOT cl_null(g_oha.oha01) THEN
      CALL cl_err('','apm-936',1)
      EXIT PROGRAM
   END IF
#TQC-D30066 ------End----------

#FUN-BC0062 --begin--
#  SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'   #TQC-D30066 mark
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-937',1)
      EXIT PROGRAM
   END IF
#FUN-BC0062 --end--

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   LET g_cmd = g_argv2
    #no.7204 若是銷退'5.折讓'取消確認不show畫面
    IF g_cmd = 'y' THEN
       WHILE TRUE
         SELECT * INTO g_oha.* FROM oha_file WHERE oha01=g_oha.oha01
         IF STATUS THEN 
            CALL cl_err3("sel","oha_file",g_oha.oha01,"",STATUS,"","sel oha:",1)      #FUN-660167
            EXIT WHILE 
         END IF
         IF g_sma.sma53 IS NOT NULL AND g_oha.oha02 <= g_sma.sma53 THEN
            CALL cl_err('','mfg9999',1) LET g_success = 'N' EXIT WHILE
         END IF
         CALL p750_p2()
         EXIT WHILE
       END WHILE
    ELSE
       OPEN WINDOW p750_w WITH FORM "axm/42f/axmp750"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
       CALL cl_ui_init()
 
       CALL p750_p1()
       CLOSE WINDOW p750_w
    END IF
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p750_p1()
 DEFINE l_flag LIKE type_file.num5      #No.FUN-680137 SMALLINT
 WHILE TRUE
   LET g_action_choice = ''
 
   INPUT BY NAME g_oha.oha01 WITHOUT DEFAULTS
 
     AFTER FIELD oha01
        SELECT * INTO g_oha.* FROM oha_file WHERE oha01=g_oha.oha01
        IF STATUS THEN 
           CALL cl_err3("sel","oha_file",g_oha.oha01,"",STATUS,"","sel oha:",0)      #FUN-660167
           NEXT FIELD oha01 
        END IF
        IF g_oha.ohapost='N' THEN
           CALL cl_err('ohapost=N:','axm-206',0) NEXT FIELD oha01
        END IF
	IF g_sma.sma53 IS NOT NULL AND g_oha.oha02 <= g_sma.sma53 THEN
	   CALL cl_err('','mfg9999',0) NEXT FIELD oha01
	END IF
        IF NOT cl_null(g_oha.oha10) THEN
           CALL cl_err(g_oha.oha10,'axm-603',0)
           NEXT FIELD oha01
        END IF
#TQC-D70054--add--star---
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(oha01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oha01"
                 LET g_qryparam.default1 = g_oha.oha01
                 CALL cl_create_qry() RETURNING g_oha.oha01
                 DISPLAY BY NAME g_oha.oha01
                 NEXT FIELD oha01
           END CASE
#TQC-D70054--add--end---
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         call cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
         LET g_action_choice='locale'
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF cl_sure(0,0) THEN
      CALL p750_p2()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
 END WHILE
END FUNCTION
 
FUNCTION p750_p2()
   DEFINE l_imm03   LIKE imm_file.imm03   #No.FUN-740016
   DEFINE l_ohb RECORD LIKE ohb_file.*
   DEFINE l_tot   LIKE oeb_file.oeb25
   DEFINE l_tot1  LIKE oeb_file.oeb26   #No.CHI-8B0046
   DEFINE l_ocn03   LIKE ocn_file.ocn03
   DEFINE l_ocn04   LIKE ocn_file.ocn04
   DEFINE l_flag    LIKE type_file.chr1    #FUN-B70074
   DEFINE max_lsm05 LIKE lsm_file.lsm05    #FUN-BA0069 add
   DEFINE l_sum_ohb14t LIKE ohb_file.ohb14t #FUN-C80110
   DEFINE l_oea61      LIKE oea_file.oea61  #CHI-C90032 add
   DEFINE l_cnt        LIKE type_file.num5  #MOD-D10185 add
   #2021113001 add----begin----
   DEFINE l_ret        RECORD
             success   LIKE type_file.chr1,
             code      LIKE type_file.chr10,
             msg       STRING
                       END RECORD
   #2021113001 add----end----
    
   IF g_oha.oha09 = "6" THEN
      #MOD-D10185 add start -----
      SELECT COUNT(*) INTO l_cnt FROM ohb_file WHERE ohb01 = g_oha.oha01 AND ohb04 NOT LIKE 'MISC%'
      IF l_cnt > 0 THEN
      #MOD-D10185 add end   -----
         CALL p750_delimm()
         SELECT imm03 INTO l_imm03 FROM imm_file
          WHERE imm01=g_oha.oha56
         IF l_imm03 = "N" THEN
            DELETE FROM imn_file WHERE imn01 = g_oha.oha56
            #FUN-B70074-add-str--
            IF NOT s_industry('std') THEN 
               LET l_flag = s_del_imni(g_oha.oha56,'','')
            END IF
            #FUN-B70074-add-end--
            DELETE FROM imm_file WHERE imm01 = g_oha.oha56
            DELETE FROM rvbs_file WHERE rvbs01 = g_oha.oha56   #MOD-B80050 add
            UPDATE oha_file SET ohapost = "N",
                                oha56 = ""
             WHERE oha01 = g_oha.oha01
            DECLARE p750_imm_c CURSOR FOR
                    SELECT * FROM ohb_file WHERE ohb01=g_oha.oha01 ORDER BY ohb03
            
            FOREACH p750_imm_c INTO l_ohb.*
               SELECT oeb25,oeb26 INTO l_tot,l_tot1 FROM oeb_file    #No.CHI-8B0046
                WHERE oeb01 = l_ohb.ohb33
                  AND oeb03 = l_ohb.ohb34
               
               LET l_tot = l_tot-l_ohb.ohb12
               LET l_tot1 = l_tot1-l_ohb.ohb12   #No.CHI-8B0046
               
               UPDATE oeb_file SET oeb25=l_tot,
                                   oeb26=l_tot1   #No.CHI-8B0046
                WHERE oeb01 = l_ohb.ohb33
                  AND oeb03 = l_ohb.ohb34
               
               LET l_oea61 = g_oha.oha24*l_ohb.ohb14   #CHI-C90032 add
               CALL cl_digcut(l_oea61,g_azi04) RETURNING l_oea61     #CHI-C90032 add
               SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
                WHERE ocn01 = g_oha.oha14
               
              #LET l_ocn03 = l_ocn03+(g_oha.oha24*l_ohb.ohb14)   #CHI-C90032 mark
              #LET l_ocn04 = l_ocn04-(g_oha.oha24*l_ohb.ohb14)   #CHI-C90032 mark
               LET l_ocn03 = l_ocn03+l_oea61                   #CHI-C90032 add
               LET l_ocn04 = l_ocn04-l_oea61                   #CHI-C90032 add
               
               UPDATE ocn_file SET ocn03 = l_ocn03,
                                   ocn04 = l_ocn04
                WHERE ocn01 = g_oha.oha14
            END FOREACH
         END IF
      #MOD-D10185 add start -----
      ELSE
         LET g_success='Y'
         UPDATE oha_file SET ohapost = "N" WHERE oha01 = g_oha.oha01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","oha_file",g_oha.oha01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
         DECLARE p750_imm_d CURSOR FOR SELECT * FROM ohb_file WHERE ohb01=g_oha.oha01 ORDER BY ohb03
         FOREACH p750_imm_d INTO l_ohb.*
            SELECT oeb25,oeb26 INTO l_tot,l_tot1 FROM oeb_file
             WHERE oeb01 = l_ohb.ohb33 AND oeb03 = l_ohb.ohb34

            LET l_tot = l_tot-l_ohb.ohb12
            LET l_tot1 = l_tot1-l_ohb.ohb12

            UPDATE oeb_file SET oeb25=l_tot, oeb26=l_tot1
             WHERE oeb01 = l_ohb.ohb33 AND oeb03 = l_ohb.ohb34
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","oeb_file",l_ohb.ohb33,l_ohb.ohb34,SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH
      END IF
     #MOD-D10185 add end   -----
      RETURN
   END IF
 
   #2021113001 add----begin----
   IF NOT cl_null(g_oha.oha01)  AND cl_getscmparameter() THEN
     INITIALIZE l_ret TO NULL
     CALL cjc_zmx_json_cancelWorktask(g_oha.oha01,'ST1') RETURNING l_ret.*
     IF l_ret.success = 'Y' THEN

     ELSE
       IF cl_null(l_ret.msg) THEN
         LET l_ret.msg = "销退单(",g_oha.oha01 CLIPPED,")撤销失败"
       END IF
       CALL cl_err(l_ret.msg,'!',1)
       LET g_success = 'N'
       RETURN
     END IF
   END IF
   #2021113001 add----end----
 
   BEGIN WORK
   LET g_success='Y'
   CALL p750_s1()
#FUN-BA0069 --------------------STA
#FUN-BB0024 add begin ---
   SELECT SUM(rxy23) INTO g_rxx04_point
     FROM rxy_file
    WHERE rxy00 = '02'
      AND rxy01 = g_oha.oha01
      AND rxy03 = '09'
      AND rxyplant = g_oha.ohaplant
   IF cl_null(g_rxx04_point) THEN
      LET g_rxx04_point = 0
   END IF
#FUN-BB0024 add end ---
   IF g_success = 'Y' AND g_azw.azw04 = '2' and g_oha.oha94 = 'N' AND NOT cl_null(g_oha.oha87) THEN
#     DELETE FROM lsm_file WHERE lsm01 = g_oha.oha87 AND lsm02 = '8' AND lsm03 = g_oha.oha01  #FUN-BB0024 MARK
#     DELETE FROM lsm_file WHERE lsm01 = g_oha.oha87 AND (lsm02 = '8' OR lsm02 = 'A') AND lsm03 = g_oha.oha01  #FUN-BB0024     #FUN-C70045 mark
      DELETE FROM lsm_file WHERE lsm01 = g_oha.oha87 AND (lsm02 = '8' OR lsm02 = 'A') AND lsm15 = '1' AND lsm03 = g_oha.oha01  #FUN-C70045 add

#    SELECT MAX(lsm05) INTO max_lsm05 FROM lsm_file WHERE lsm01 = g_oha.oha87 AND lsm02 IN ('1','5','6','7','8')     #FUN-C70045 mark
     SELECT MAX(lsm05) INTO max_lsm05 FROM lsm_file WHERE lsm01 = g_oha.oha87 AND lsm02 IN ('2','3','7','8')         #FUN-C70045 add
    #FUN-C80110 Begin---
     SELECT SUM(ohb14t) INTO l_sum_ohb14t
       FROM ohb_file
      WHERE ohb01 = g_oha.oha01
     IF cl_null(l_sum_ohb14t) THEN
        LET l_sum_ohb14t = 0
     END IF
    #FUN-C80110 End-----
     UPDATE lpj_file SET lpj07 = COALESCE(lpj07, 0) - 1,
                         lpj08 = max_lsm05,
#                        lpj12 = COALESCE(lpj12, 0) + g_oha.oha95,                   #FUN-BB0024 MARK
                         lpj12 = COALESCE(lpj12, 0) + g_oha.oha95 - g_rxx04_point,   #FUN-BB0024
                         lpj13 = COALESCE(lpj13, 0) + g_rxx04_point,                 #FUN-BB0024
                         lpj14 = COALESCE(lpj14, 0) + g_oha.oha95,
                         lpj15 = COALESCE(lpj15, 0) + l_sum_ohb14t, #FUN-C80110
                        #lpj15 = COALESCE(lpj15, 0) + g_oha.oha1008 #FUN-C80110
                         lpjpos = '2'                               #FUN-D30007 add
      WHERE lpj03 = g_oha.oha87

   END IF
#FUN-BA0069 --------------------END
  #FUN-B40098 Begin---
   IF g_success = 'Y' AND g_azw.azw04 = '2' THEN
      CALL s_showmsg_init()
      CALL t620sub1_z('2',g_oha.oha01)
      CALL s_showmsg()
   END IF
  #FUN-B40098 End-----
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION p750_s1()
  DEFINE l_flag       LIKE type_file.num5     #No.MOD-890249 add
  DEFINE l_ohbi       RECORD LIKE ohbi_file.* #TQC-B80005 
 
  CALL p750_u_oha()
 
 
  CALL s_showmsg_init()   #No.FUN-6C0083 
  
  DECLARE p750_s1_c CURSOR FOR
          SELECT * FROM ohb_file WHERE ohb01=g_oha.oha01 ORDER BY ohb03
  FOREACH p750_s1_c INTO b_ohb.*
      IF STATUS THEN LET g_success='N' RETURN END IF
      MESSAGE '_s1() read no:',b_ohb.ohb03 USING '#####&',' -> parts: ',
               b_ohb.ohb04
      CALL ui.Interface.refresh()
      IF cl_null(b_ohb.ohb04) THEN CONTINUE FOREACH END IF
     #IF b_ohb.ohb04[1,4] = 'MISC' THEN CONTINUE FOREACH END IF #MOD-950124 add   #MOD-C80104 mark
     #MOD-CC0088 -- add start --
     IF b_ohb.ohb04[1,4] = 'MISC' THEN
        CALL p750_u_oeb()
        CONTINUE FOREACH
     END IF
     #MOD-CC0088 -- add end --
 
     IF g_oha.oha09 = '5' THEN  # 5. 折讓要刪除tlf_file
       #IF b_ohb.ohb04[1,4] != 'MISC' THEN   #MOD-C80104 add   #MOD-CC0088 mark
           CALL p750_u_tlf()
           IF g_success='N' THEN 
              LET g_totsuccess="N"
              LET g_success="Y"
              CONTINUE FOREACH   
           END IF 
       #END IF   #MOD-C80104 add   #MOD-CC0088 mark
     ELSE
 
      IF s_industry('icd') THEN
         #TQC-B80005 --START--
         SELECT * INTO l_ohbi.* FROM ohbi_file
          WHERE ohbi01 = b_ohb.ohb01 AND ohbi03 = b_ohb.ohb03  
         #TQC-B80005 --END--
         CALL s_icdpost(1,b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,
                        b_ohb.ohb092,b_ohb.ohb05,b_ohb.ohb12,
                        b_ohb.ohb01,b_ohb.ohb03,g_oha.oha02,'N',
                        b_ohb.ohb31,b_ohb.ohb32,l_ohbi.ohbiicd029,l_ohbi.ohbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
              RETURNING l_flag
         IF l_flag = 0 THEN
            LET g_totsuccess = 'N'
            CONTINUE FOREACH
         END IF
      END IF
      
     #FUN-D30024--modify--str--
     #IF NOT s_stkminus(b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,
     #                  b_ohb.ohb12,b_ohb.ohb15_fac,g_oha.oha02,g_sma.sma894[7,7]) THEN
      IF NOT s_stkminus(b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,
                        b_ohb.ohb12,b_ohb.ohb15_fac,g_oha.oha02) THEN
     #FUN-D30024--modify--end--
         LET g_totsuccess="N"
         CONTINUE FOREACH   #No.FUN-720001
      END IF
      CALL p750_u_img(b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,b_ohb.ohb16)
      #FUN-C50097 ADD 更新发票仓库存(增加发票仓库存,删除tlf档案) TQC-C70206
      #IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND g_oha.oha09 = '3' THEN #TQC-C90070 #MOD-CB0083 mark
      IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y'
       AND g_oha.oha09 NOT MATCHES '[23]' THEN #MOD-CB0083 add 
         CALL p750_u_img2(g_oaz.oaz95,g_oha.oha03,' ',b_ohb.ohb16)
         CALL p750_u_tlf2()
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
            CONTINUE FOREACH  
         END IF          
      END IF 
      #FUN-C50097 ADD
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-720001
      END IF #No.+046 010404 by plum
 
      CALL p750_u_ima()
      IF g_success='N' THEN 
         RETURN
      END IF #No.+046 010404 by plum
 
      CALL p750_u_tlf()
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-720001
      END IF #No.+046 010404 by plum
 
      CALL p750_u_tlfs()
      IF g_success='N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
 
      CALL p750_du(b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,
                   b_ohb.ohb913,b_ohb.ohb914,b_ohb.ohb915,
                   b_ohb.ohb910,b_ohb.ohb911,b_ohb.ohb912)
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-720001
      END IF #No.+046 010404 by plum
 
      CALL p750_u_oeb()
      CALL p750_u_tuq_tup()
     END IF  #MOD-7C0148 add
      IF g_success='N' THEN RETURN END IF
  END FOREACH
  
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
  
  CALL s_showmsg()   #No.FUN-6C0083
 
 
  IF g_oha.oha05='4' THEN
     CALL p750_s1_7() #060310 kim : 此函數內可以做TQC-620156 庫存不足err-log 統整顯示功能,目前先不處理
     IF g_success = 'Y' THEN
        DELETE FROM ogb_file WHERE ogb01 = g_oga.oga01
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           RETURN
        ELSE
           IF NOT s_industry('std') THEN
              IF NOT s_del_ogbi(g_oga.oga01,'','') THEN
                 LET g_success = 'N'
                 RETURN
              END IF
           END IF
        END IF
        DELETE FROM oga_file WHERE oga01 = g_oga.oga01
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           RETURN
        END IF
        UPDATE oha_file SET oha1018=NULL,oha1015='N'
         WHERE oha01 = g_oha.oha01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","oha_file",g_oha.oha01,"",SQLCA.sqlcode,"","",1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
  END IF
END FUNCTION
 
FUNCTION p750_u_oha()
    MESSAGE "u_oha!"
    CALL ui.Interface.refresh()
    UPDATE oha_file SET ohapost='N' WHERE oha01=g_oha.oha01
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err3("upd","oha_file",g_oha.oha01,"",SQLCA.SQLCODE,"","upd ohapost",1)   #No.FUN-660167
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('upd ohapost:','axm-176',1) LET g_success='N' RETURN
    END IF
END FUNCTION
 
FUNCTION p750_u_img(p_ware,p_loca,p_lot,p_qty) # Update img_file
  DEFINE p_ware   LIKE ohb_file.ohb09,       ##倉庫
         p_loca   LIKE ohb_file.ohb091,      ##儲位
         p_lot    LIKE ohb_file.ohb092,      ##批號
         p_qty    LIKE ohb_file.ohb16        ##數量
 
    CALL ui.Interface.refresh()
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
#FUN-A90049 ------start
    IF s_joint_venture( b_ohb.ohb04 ,g_plant) OR NOT s_internal_item( b_ohb.ohb04,g_plant ) THEN
       RETURN 
    END IF
#FUN-A90049 ------end
    CALL ui.Interface.refresh()
    LET g_forupd_sql =
        "   SELECT img01,img02,img03,img04 FROM img_file ",
        "      WHERE img01= ?  AND img02= ?  AND img03= ?  AND img04= ? ",
        "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING b_ohb.ohb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock
       LET g_success = 'N'    #No.TQC-930155
       RETURN
    END IF
    FETCH img_lock INTO b_ohb.ohb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err('img_lock fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    CALL s_upimg(b_ohb.ohb04,p_ware,p_loca,p_lot,-1,p_qty,g_today, #FUN-8C0084
                 '','','','',b_ohb.ohb01,b_ohb.ohb03,'','','','','','','','',0,0,'','')  #NO.FUN-860025
    IF STATUS OR g_success = 'N' THEN
       CALL cl_err('p750_u_img(-1):','9050',0)
       LET g_success='N'
       RETURN
    END IF
 
END FUNCTION


#FUN-C50097 ADD BEG----
#用来增加发票仓库存
FUNCTION p750_u_img2(p_ware,p_loca,p_lot,p_qty) # Update img_file
  DEFINE p_ware   LIKE ohb_file.ohb09,       ##倉庫
         p_loca   LIKE ohb_file.ohb091,      ##儲位
         p_lot    LIKE ohb_file.ohb092,      ##批號
         p_qty    LIKE ohb_file.ohb16        ##數量
 
    CALL ui.Interface.refresh()
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
#FUN-A90049 ------start
    IF s_joint_venture( b_ohb.ohb04 ,g_plant) OR NOT s_internal_item( b_ohb.ohb04,g_plant ) THEN
       RETURN 
    END IF
#FUN-A90049 ------end
    CALL ui.Interface.refresh()
    LET g_forupd_sql =
        "   SELECT img01,img02,img03,img04 FROM img_file ",
        "      WHERE img01= ?  AND img02= ?  AND img03= ?  AND img04= ? ",
        "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE img_lock2 CURSOR FROM g_forupd_sql
 
    OPEN img_lock2 USING b_ohb.ohb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock2
       LET g_success = 'N'    #No.TQC-930155
       RETURN
    END IF
    FETCH img_lock2 INTO b_ohb.ohb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err('img_lock fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    CALL s_upimg(b_ohb.ohb04,p_ware,p_loca,p_lot,1,p_qty,g_today, #FUN-8C0084
                 '','','','',b_ohb.ohb01,b_ohb.ohb03,'','','','','','','','',0,0,'','')  #NO.FUN-860025
    IF STATUS OR g_success = 'N' THEN
       CALL cl_err('p750_u_img(1):','9050',0)
       LET g_success='N'
       RETURN
    END IF
 
END FUNCTION

#用来处理双单位,发票仓库存异动
FUNCTION p750_upd_imgg2(p_imgg00,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg10,p_imgg211,p_no)
 DEFINE p_imgg00   LIKE imgg_file.imgg00,
        p_imgg02   LIKE imgg_file.imgg02,
        p_imgg03   LIKE imgg_file.imgg03,
        p_imgg04   LIKE imgg_file.imgg04,
        p_imgg09   LIKE imgg_file.imgg09,
        p_imgg10   LIKE imgg_file.imgg10,
        p_imgg211  LIKE imgg_file.imgg211,
        p_no       LIKE type_file.chr1,        #No.FUN-680137 VARCHAR(1)
        l_ima25    LIKE ima_file.ima25,
        l_ima906   LIKE ima_file.ima906,
        l_imgg21   LIKE imgg_file.imgg21
 
   CALL ui.Interface.refresh()
 
   LET g_forupd_sql =
       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
       "   WHERE imgg01= ?  AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
       "   AND imgg09= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE imgg_lock2 CURSOR FROM g_forupd_sql
 
   OPEN imgg_lock2 USING b_ohb.ohb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL cl_err("OPEN imgg_lock2:", STATUS, 1)
      LET g_success='N'
      CLOSE imgg_lock2
      RETURN
   END IF

   FETCH imgg_lock2 INTO b_ohb.ohb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL cl_err('lock imgg fail',STATUS,1)
      LET g_success='N'
      CLOSE imgg_lock2
      RETURN
   END IF
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=b_ohb.ohb04
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",b_ohb.ohb04,"",SQLCA.sqlcode,"","ima25 null",0)   #No.FUN-660167
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(b_ohb.ohb04,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
   CALL s_upimgg(b_ohb.ohb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09,1,p_imgg10,g_oha.oha02, #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
   IF g_success = 'N' THEN
      CALL cl_err('u_upimgg(1)','9050',0) RETURN
   END IF
 
END FUNCTION
#删除发票仓tlf
FUNCTION p750_u_tlf2() #------------------------------------ Update tlf_file
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
    MESSAGE "d_tlf!"
    CALL ui.Interface.refresh()
  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",b_ohb.ohb04,"' AND tlf02=50 ",
                 "    AND  tlf036='",b_ohb.ohb01,"' AND tlf037=",b_ohb.ohb03," ",
                 "   AND tlf06 ='",g_oha.oha02,"'"     
    DECLARE p750_u_tlf_c2 CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p750_u_tlf_c2 INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     
    IF s_joint_venture( b_ohb.ohb04 ,g_plant) OR NOT s_internal_item( b_ohb.ohb04,g_plant ) THEN       #FUN-A90049
    ELSE                                                                                      #FUN-A90049
  ##NO.FUN-8C0131   add--end
       DELETE FROM tlf_file
             WHERE tlf01 =b_ohb.ohb04 AND tlf02=50
               AND tlf036=b_ohb.ohb01 #銷退單號
               AND tlf037=b_ohb.ohb03 #銷退項次
               AND tlf06 =g_oha.oha02 #銷退日期
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlf_file",b_ohb.ohb04,g_oha.oha02,SQLCA.SQLCODE,"","del tlf",1)   #No.FUN-660167
          LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlf:','axm-176',1) LET g_success='N' RETURN
       END IF
  ##NO.FUN-8C0131   add--begin
    END IF                                                                                  #FUN-A90049
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end    
END FUNCTION
#删除发票仓tlff
FUNCTION p750_tlff2() #------------------------------------ Update tlff_file
    MESSAGE "d_tlff!"
    CALL ui.Interface.refresh()
    IF s_joint_venture( b_ohb.ohb04 ,g_plant) OR NOT s_internal_item( b_ohb.ohb04,g_plant ) THEN        
    ELSE                                                                                   
       DELETE FROM tlff_file
             WHERE tlff01 =b_ohb.ohb04 AND tlff02=50
               AND tlff036=b_ohb.ohb01 #銷退單號
               AND tlff037=b_ohb.ohb03 #銷退項次
               AND tlff06 =g_oha.oha02 #銷退日期
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlff_file",b_ohb.ohb04,g_oha.oha02,SQLCA.SQLCODE,"","del tlff",1)   
          LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlff:','axm-176',1) LET g_success='N' RETURN
       END IF
    END IF                                                                                  
END FUNCTION
#FUN-C50097 ADD END----

 
FUNCTION p750_u_ima() #------------------------------------ Update ima_file
   # DEFINE l_ima26,l_ima261,l_ima262	LIKE ima_file.ima26 #FUN-A20044
    DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk 	LIKE type_file.num15_3 #FUN-A20044
 
    MESSAGE "u_ima!"
    CALL ui.Interface.refresh()
    LET l_avl_stk_mpsmrp =0 LET l_unavl_stk=0 LET l_avl_stk=0
   # SELECT SUM(img10*img21) INTO l_ima26  FROM img_file
    #       WHERE img01=b_ohb.ohb04 AND img24='Y' #No:8467 #FUN-A20044
    CALL s_getstock(b_ohb.ohb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
     # IF STATUS THEN 
      # CALL cl_err3("sel","img_file",b_ohb.ohb04,"",STATUS,"","sel sum1:",1)      #FUN-660167
      # LET g_success='N' 
  #  END IF
 #   IF l_ima26 IS NULL THEN LET l_ima26=0 END IF#FUN-A20044
 #   SELECT SUM(img10*img21) INTO l_ima261 FROM img_file
  #         WHERE img01=b_ohb.ohb04 AND img23='N'               #FUN-A20044
        ####FUN-A20044-------BEGIN
       #   IF STATUS THEN 
      #@ CALL cl_err3("sel","img_file",b_ohb.ohb04,"",STATUS,"","sel sum2:",1)       #FUN-660167 
      # LET g_success='N' 
   # END IF
   # IF l_ima261 IS NULL THEN LET l_ima261=0 END IF
   # SELECT SUM(img10*img21) INTO l_ima262 FROM img_file
    #       WHERE img01=b_ohb.ohb04 AND img23='Y'
    #IF STATUS THEN 
     #  CALL cl_err3("sel","img_file",b_ohb.ohb04,"",STATUS,"","sel sum3:",1)       #FUN-660167 
      # LET g_success='N' 
   # END IF
    #IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
   # UPDATE ima_file SET ima26=l_ima26,ima261=l_ima261,ima262=l_ima262
    #           WHERE ima01= b_ohb.ohb04
    #IF STATUS OR SQLCA.SQLCODE THEN
     #  CALL cl_err3("upd","ima_file",b_ohb.ohb04,"",SQLCA.SQLCODE,"","upd ima26*",1)   #No.FUN-660167
      # LET g_success='N' RETURN
  #  END IF
   # IF SQLCA.SQLERRD[3]=0 THEN
    #   CALL cl_err('upd ima26*:','axm-176',1) LET g_success='N' RETURN
    #END IF
END FUNCTION
 
FUNCTION p750_u_tlf() #------------------------------------ Update tlf_file
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
    MESSAGE "d_tlf!"
    CALL ui.Interface.refresh()
  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",b_ohb.ohb04,"' AND tlf03=50 ",
                 "    AND  tlf036='",b_ohb.ohb01,"' AND tlf037=",b_ohb.ohb03," ",
                 "   AND tlf06 ='",g_oha.oha02,"'"     
    DECLARE p750_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p750_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     
    IF s_joint_venture( b_ohb.ohb04 ,g_plant) OR NOT s_internal_item( b_ohb.ohb04,g_plant ) THEN       #FUN-A90049
    ELSE                                                                                      #FUN-A90049
  ##NO.FUN-8C0131   add--end
       DELETE FROM tlf_file
             WHERE tlf01 =b_ohb.ohb04 AND tlf03=50
               AND tlf036=b_ohb.ohb01 #銷退單號
               AND tlf037=b_ohb.ohb03 #銷退項次
               AND tlf06 =g_oha.oha02 #銷退日期
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlf_file",b_ohb.ohb04,g_oha.oha02,SQLCA.SQLCODE,"","del tlf",1)   #No.FUN-660167
          LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlf:','axm-176',1) LET g_success='N' RETURN
       END IF
  ##NO.FUN-8C0131   add--begin
    END IF                                                                                  #FUN-A90049
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end    
END FUNCTION


 
FUNCTION p750_u_oeb() 				#更新訂單已出貨單量
   DEFINE tot1,tot2    LIKE ohb_file.ohb12
 
   MESSAGE "u_oeb!"
   CALL ui.Interface.refresh()
   IF g_oha.oha09 = '1' THEN RETURN END IF
   IF NOT cl_null(b_ohb.ohb31) THEN 		#更新出貨單銷退量
      SELECT SUM(ohb12) INTO tot1 FROM ohb_file, oha_file
          WHERE ohb31=b_ohb.ohb31 AND ohb32=b_ohb.ohb32
            AND ohb01=oha01 AND ohapost='Y' AND oha09='2'
      SELECT SUM(ohb12) INTO tot2 FROM ohb_file, oha_file
          WHERE ohb31=b_ohb.ohb31 AND ohb32=b_ohb.ohb32
            AND ohb01=oha01 AND ohapost='Y' AND oha09='3'
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
      UPDATE ogb_file SET ogb63=tot1,ogb64=tot2
          WHERE ogb01 = b_ohb.ohb31 AND ogb03 = b_ohb.ohb32
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("upd","ogb_file",b_ohb.ohb31,b_ohb.ohb32,SQLCA.sqlcode,"","upd ogb63",1)   #No.FUN-660167
         LET g_success='N' RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd ogb63,64','axm-176',1) LET g_success = 'N' RETURN
      END IF
   END IF
   IF NOT cl_null(b_ohb.ohb33) THEN 				# 訂單銷退量
      SELECT SUM(ohb12) INTO tot1 FROM ohb_file, oha_file
          WHERE ohb33=b_ohb.ohb33 AND ohb34=b_ohb.ohb34
            AND ohb01=oha01 AND ohapost='Y' AND oha09='4'   #No.+060
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      UPDATE oeb_file SET (oeb25) = (tot1)
          WHERE oeb01 = b_ohb.ohb33 AND oeb03 = b_ohb.ohb34
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("upd","oeb_file",b_ohb.ohb33,b_ohb.ohb34,SQLCA.SQLCODE,"","upd oeb25",1)   #No.FUN-660167
         LET g_success='N' RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oeb25','axm-176',1) LET g_success = 'N' RETURN
      END IF
   END IF
END FUNCTION
 
FUNCTION p750_u_tuq_tup()
  DEFINE l_ima25  LIKE ima_file.ima25
  DEFINE l_ima71  LIKE ima_file.ima71
  DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
  DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE l_occ31  LIKE occ_file.occ31
  DEFINE l_tuq06  LIKE tuq_file.tuq06
  DEFINE l_tup05  LIKE tup_file.tup05
  DEFINE l_tuq11  LIKE tuq_file.tuq11      #No.FUN-610062
 #DEFINE l_tup08  LIKE tup_file.tup08      #No.FUN-610062 #CHI-B40056 mark
  DEFINE l_tup11  LIKE tup_file.tup11                     #CHI-B40056
  DEFINE l_tuq07  LIKE tuq_file.tuq07
  DEFINE l_desc   LIKE type_file.chr1     #No.FUN-680137  VARCHAR(01)
  DEFINE i        LIKE type_file.num5     #No.FUN-680137 SMALLINT
  DEFINE l_tup05_1 LIKE tup_file.tup05    #FUN-910088--add--
  DEFINE l_tuq07_1 LIKE tuq_file.tuq07    #FUN-910088--add--
  DEFINE l_tuq09_1 LIKE tuq_file.tuq09    #FUN-910088--add--
 
   SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=g_oha.oha03
   IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
   IF l_occ31 = 'N' THEN RETURN END IF    #occ31=.w&s:^2z'_
   SELECT ima25,ima71 INTO l_ima25,l_ima71
     FROM ima_file WHERE ima01=b_ohb.ohb04
   IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
    SELECT oga00 INTO l_oga00 FROM oga_file 
     WHERE oga01=g_oha.oha16
    IF l_oga00='7' THEN
      #LET l_tup08='2' #CHI-B40056 mark
       LET l_tuq11='2'
       LET l_tup11='2' #CHI-B40056 add
    ELSE
      #LET l_tup08='1' #CHI-B40056 mark
       LET l_tuq11='1'
       LET l_tup11='1' #CHI-B40056 add
    END IF
 
   SELECT COUNT(*) INTO i FROM tuq_file
    WHERE tuq01=g_oha.oha03  AND tuq02=b_ohb.ohb04
      AND tuq11=l_tuq11      AND tuq12=g_oha.oha04       #No.FUN-610062
      AND tuq03=b_ohb.ohb092 AND tuq04=g_oha.oha02
      AND tuq05=g_oha.oha01  AND tuq051=b_ohb.ohb03 #MOD-CB0111 add
   IF i=0 THEN
      LET l_fac1=1
      IF b_ohb.ohb05 <> l_ima25 THEN
         CALL s_umfchk(b_ohb.ohb04,b_ohb.ohb05,l_ima25)
              RETURNING l_cnt,l_fac1
         IF l_cnt = '1'  THEN
            CALL cl_err(b_ohb.ohb04,'abm-731',1)
            LET l_fac1=1
         END IF
      END IF
    #FUN-910088--add--start--
      LET l_tuq09_1 = b_ohb.ohb12*l_fac1
      LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)  
    #FUN-910088--add--end--
      INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,      
                           tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                           tuqplant,tuqlegal)   #FUN-980010 add plant & legal 
    #FUN-910088--mark--start--
    # VALUES(g_oha.oha03,b_ohb.ohb04,b_ohb.ohb092,g_oha.oha02,g_oha.oha01,b_ohb.ohb03,
    #        b_ohb.ohb05,b_ohb.ohb12,l_fac1,b_ohb.ohb12*l_fac1,'2',l_tuq11,g_oha.oha04,
    #        g_plant,g_legal)   #FUN-980010
    #FUN-910088--mark--end--
    #FUN-910088--add--start--
      VALUES(g_oha.oha03,b_ohb.ohb04,b_ohb.ohb092,g_oha.oha02,g_oha.oha01,b_ohb.ohb03,
             b_ohb.ohb05,b_ohb.ohb12,l_fac1,l_tuq09_1,'2',l_tuq11,g_oha.oha04,
             g_plant,g_legal) 
    #FUN-910088--add--end--
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",0)   #No.FUN-660167
         LET g_success ='N'
         RETURN
      END IF
   ELSE
      SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
       WHERE tuq01=g_oha.oha03  AND tuq02=b_ohb.ohb04
         AND tuq03=b_ohb.ohb092 AND tuq04=g_oha.oha02
         AND tuq11=l_tuq11  AND tuq12=g_oha.oha04       #No.FUN-610062
         AND tuq05=g_oha.oha01  AND tuq051=b_ohb.ohb03 #MOD-CB0111 add
      #&],0key-H*:-l&],&P$@KEY-H*:%u/`+O/d$@-S-l)l3f&l
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",0)   #No.FUN-660167
         LET g_success ='N'
         RETURN
      END IF
      LET l_fac1=1
      IF b_ohb.ohb05 <> l_tuq06 THEN
         CALL s_umfchk(b_ohb.ohb04,b_ohb.ohb05,l_tuq06)
              RETURNING l_cnt,l_fac1
         IF l_cnt = '1'  THEN
            CALL cl_err(b_ohb.ohb04,'abm-731',1)
            LET l_fac1=1
         END IF
      END IF
 
      LET l_fac2=1
      IF l_tuq06 <> l_ima25 THEN
         CALL s_umfchk(b_ohb.ohb04,l_tuq06,l_ima25)
              RETURNING l_cnt,l_fac2
         IF l_cnt = '1'  THEN
            CALL cl_err(b_ohb.ohb04,'abm-731',1)
            LET l_fac2=1
         END IF
      END IF
 
      SELECT tuq07 INTO l_tuq07 FROM tuq_file
       WHERE tuq01=g_oha.oha03  AND tuq02=b_ohb.ohb04
         AND tuq03=b_ohb.ohb092 AND tuq04=g_oha.oha02
         AND tuq11=l_tuq11 AND tuq12=g_oha.oha04       #No.FUN-610062
         AND tuq05=g_oha.oha01  AND tuq051=b_ohb.ohb03 #MOD-CB0111 add 
      IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
      IF l_tuq07+b_ohb.ohb12*l_fac1<0 THEN
         LET l_desc='2'
      ELSE
         LET l_desc='1'
      END IF
      IF l_tuq07+b_ohb.ohb12*l_fac1=0 THEN
         DELETE FROM tuq_file
          WHERE tuq01=g_oha.oha03  AND tuq02=b_ohb.ohb04
            AND tuq11=l_tuq11 AND tuq12=g_oha.oha04    #No.FUN-610062
            AND tuq03=b_ohb.ohb092 AND tuq04=g_oha.oha02
            AND tuq05=g_oha.oha01  AND tuq051=b_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",0)   #No.FUN-660167
            LET g_success='N'
            RETURN
         END IF
      ELSE
      #FUN-910088--add--start--
          LET l_tuq07_1 = b_ohb.ohb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = b_ohb.ohb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07+l_tuq07_1,
                              tuq09=tuq09+l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start--  
       # UPDATE tuq_file SET tuq07=tuq07+b_ohb.ohb12*l_fac1,
       #                     tuq09=tuq09+b_ohb.ohb12*l_fac1*l_fac2,
       #FUN-910088--mark--end--
                             tuq10=l_desc
          WHERE tuq01=g_oha.oha03  AND tuq02=b_ohb.ohb04
            AND tuq03=b_ohb.ohb092 AND tuq04=g_oha.oha02
            AND tuq11=l_tuq11 AND tuq12=g_oha.oha04    #No.FUN-610062
            AND tuq05=g_oha.oha01  AND tuq051=b_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",0)   #No.FUN-660167
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF
 
   LET l_fac1=1
   IF b_ohb.ohb05 <> l_ima25 THEN
      CALL s_umfchk(b_ohb.ohb04,b_ohb.ohb05,l_ima25)
           RETURNING l_cnt,l_fac1
      IF l_cnt = '1'  THEN
         CALL cl_err(b_ohb.ohb04,'abm-731',1)
         LET l_fac1=1
      END IF
   END IF
   SELECT tup05 INTO l_tup05 FROM tup_file
    WHERE tup01=g_oha.oha03  AND tup02=b_ohb.ohb04
      AND tup03=b_ohb.ohb092
     #AND tup08=l_tup08 AND tup09=g_oha.oha04    #No.FUN-610062 #CHI-B40056 mark
      AND tup11=l_tup11 AND tup12=g_oha.oha04                   #CHI-B40056 
    #FUN-910088--add--start--
      LET l_tup05_1 = b_ohb.ohb12*l_fac1
      LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)    
      UPDATE tup_file SET tup05=tup05+l_tup05_1
    #FUN-910088--add--end--
    # UPDATE tup_file SET tup05=tup05+b_ohb.ohb12*l_fac1     #FUN-910088--mark--
       WHERE tup01=g_oha.oha03  AND tup02=b_ohb.ohb04
         AND tup03=b_ohb.ohb092
        #AND tup08=l_tup08 AND tup09=g_oha.oha04      #No.FUN-610062 #CHI-B40056 mark
         AND tup11=l_tup11 AND tup12=g_oha.oha04                     #CHI-B40056
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","update tup_file",0)   #No.FUN-660167
         LET g_success='N' RETURN
      END IF
 
END FUNCTION
 
FUNCTION p750_du(p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit1,p_fac1,p_qty1)
  DEFINE p_ware     LIKE img_file.img02
  DEFINE p_loc      LIKE img_file.img03
  DEFINE p_lot      LIKE img_file.img04
  DEFINE p_unit2    LIKE img_file.img09
  DEFINE p_fac2     LIKE img_file.img21
  DEFINE p_qty2     LIKE img_file.img10
  DEFINE p_unit1    LIKE img_file.img09
  DEFINE p_fac1     LIKE img_file.img21
  DEFINE p_qty1     LIKE img_file.img10
  DEFINE p_flag     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
  DEFINE l_ima906   LIKE ima_file.ima906
 
    IF g_sma.sma115 = 'N' THEN RETURN END IF
    LET l_ima906 = NULL
    SELECT ima906 INTO l_ima906 FROM ima_file
     WHERE ima01=b_ohb.ohb04
    IF l_ima906 IS NULL OR l_ima906 = '1' THEN RETURN END IF
    IF l_ima906 = '2' THEN
       IF NOT cl_null(p_unit2) THEN
          CALL p750_upd_imgg('1',p_ware,p_loc,p_lot,
                             p_unit2,p_qty2,p_fac2,'2')
          IF g_success='N' THEN RETURN END IF
       END IF
       IF NOT cl_null(p_unit1) THEN
          CALL p750_upd_imgg('1',p_ware,p_loc,p_lot,
                             p_unit1,p_qty1,p_fac1,'1')
          IF g_success='N' THEN RETURN END IF
       END IF
       IF NOT cl_null(p_unit1) AND NOT cl_null(p_qty1) THEN   #MOD-8A0062
           CALL p750_tlff()
       END IF
       IF g_success='N' THEN RETURN END IF
       #FUN-C50097 ADD BEGIN
       #此处处理发票仓库存异动记录
       #IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND g_oha.oha09 = '3'  THEN #TQC-C90070 #MOD-CB0083 mark
       IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' 
         AND g_oha.oha09 NOT MATCHES '[23]' THEN  ##MOD-CB0083 add
          IF NOT cl_null(p_unit2) THEN
             CALL p750_upd_imgg2('1',g_oaz.oaz95,g_oha.oha03,' ',
                                p_unit2,p_qty2,p_fac2,'2')
             IF g_success='N' THEN RETURN END IF
          END IF
          IF NOT cl_null(p_unit1) THEN
             CALL p750_upd_imgg2('1',g_oaz.oaz95,g_oha.oha03,' ',
                                p_unit1,p_qty1,p_fac1,'1')
             IF g_success='N' THEN RETURN END IF             
          END IF  
          IF NOT cl_null(p_unit1) AND NOT cl_null(p_qty1) THEN   
              CALL p750_tlff2()
          END IF
          IF g_success='N' THEN RETURN END IF                  
       END IF        
       #FUN-C50097 ADD END
    END IF
    IF l_ima906 = '3' THEN
       IF NOT cl_null(p_unit2) THEN
          CALL p750_upd_imgg('2',p_ware,p_loc,p_lot,
                             p_unit2,p_qty2,p_fac2,'2')
          IF g_success='N' THEN RETURN END IF
       END IF
       IF NOT cl_null(p_unit2) AND NOT cl_null(p_qty2) THEN   #MOD-8A0062
           CALL p750_tlff()
       END IF
       IF g_success='N' THEN RETURN END IF
       #FUN-C50097 ADD BEGIN
       #此处处理发票仓库存异动记录
       #IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND g_oha.oha09 = '3' THEN #TQC-C90070 ##MOD-CB0083 mark
       IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' 
         AND g_oha.oha09 NOT MATCHES '[23]' THEN #MOD-CB0083 add
          IF NOT cl_null(p_unit2) THEN
             CALL p750_upd_imgg2('2',g_oaz.oaz95,g_oha.oha03,' ',
                                p_unit2,p_qty2,p_fac2,'2')
             IF g_success='N' THEN RETURN END IF
             IF NOT cl_null(p_unit2) AND NOT cl_null(p_qty2) THEN   #MOD-8A0062
                 CALL p750_tlff2()
             END IF
             IF g_success='N' THEN RETURN END IF             
          END IF         
       END IF        
       #FUN-C50097 ADD END       
    END IF
END FUNCTION
 
FUNCTION p750_upd_imgg(p_imgg00,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg10,p_imgg211,p_no)
 DEFINE p_imgg00   LIKE imgg_file.imgg00,
        p_imgg02   LIKE imgg_file.imgg02,
        p_imgg03   LIKE imgg_file.imgg03,
        p_imgg04   LIKE imgg_file.imgg04,
        p_imgg09   LIKE imgg_file.imgg09,
        p_imgg10   LIKE imgg_file.imgg10,
        p_imgg211  LIKE imgg_file.imgg211,
        p_no       LIKE type_file.chr1,        #No.FUN-680137 VARCHAR(1)
        l_ima25    LIKE ima_file.ima25,
        l_ima906   LIKE ima_file.ima906,
        l_imgg21   LIKE imgg_file.imgg21
 
   CALL ui.Interface.refresh()
 
   LET g_forupd_sql =
       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
       "   WHERE imgg01= ?  AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
       "   AND imgg09= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
   OPEN imgg_lock USING b_ohb.ohb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL cl_err("OPEN imgg_lock:", STATUS, 1)
      LET g_success='N'
      CLOSE imgg_lock
      RETURN
   END IF

   FETCH imgg_lock INTO b_ohb.ohb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL cl_err('lock imgg fail',STATUS,1)
      LET g_success='N'
      CLOSE imgg_lock
      RETURN
   END IF
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=b_ohb.ohb04
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",b_ohb.ohb04,"",SQLCA.sqlcode,"","ima25 null",0)   #No.FUN-660167
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(b_ohb.ohb04,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
   CALL s_upimgg(b_ohb.ohb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09,-1,p_imgg10,g_oha.oha02, #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
   IF g_success = 'N' THEN
      CALL cl_err('u_upimgg(-1)','9050',0) RETURN
   END IF
 
END FUNCTION
 
FUNCTION p750_tlff() #------------------------------------ Update tlff_file
    MESSAGE "d_tlff!"
    CALL ui.Interface.refresh()
    IF s_joint_venture( b_ohb.ohb04 ,g_plant) OR NOT s_internal_item( b_ohb.ohb04,g_plant ) THEN         #FUN-A90049
    ELSE                                                                                    #FUN-A90049
       DELETE FROM tlff_file
             WHERE tlff01 =b_ohb.ohb04 AND tlff03=50
               AND tlff036=b_ohb.ohb01 #銷退單號
               AND tlff037=b_ohb.ohb03 #銷退項次
               AND tlff06 =g_oha.oha02 #銷退日期
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlff_file",b_ohb.ohb04,g_oha.oha02,SQLCA.SQLCODE,"","del tlff",1)   #No.FUN-660167
          LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlff:','axm-176',1) LET g_success='N' RETURN
       END IF
    END IF                                                                                  #FUN-A90049
END FUNCTION
 
  
   
FUNCTION p750_s1_7()
   DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_oga01  LIKE oga_file.oga01
   DEFINE l_ima906 LIKE ima_file.ima906
  
    SELECT COUNT(*) INTO g_cnt 
      FROM omb_file,oma_file
     WHERE omb01 = oma01
       AND omavoid= 'Y'      
       AND omb31 = g_oga.oga01
    IF l_cnt > 0 THEN
       CALL cl_err('','axm-750',0)
       LET g_success = 'N'
       RETURN
    END IF
   
    SELECT * INTO g_oga.* 
      FROM oga_file
     WHERE oga1012=g_oha.oha01
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL p750_u_oga_7()
 
    DECLARE p750_s1_c_7 CURSOR FOR
     SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01 ORDER BY ogb03
    FOREACH p750_s1_c_7 INTO g_ogb.*
      IF STATUS THEN LET g_success='N' RETURN END IF
      MESSAGE '_s1() read no:',g_ogb.ogb03 USING '#####&',' -> parts: ',g_ogb.ogb04
      CALL ui.Interface.refresh()
      IF cl_null(g_ogb.ogb04) THEN CONTINUE FOREACH END IF
      IF g_ogb.ogb04[1,4] = 'MISC' THEN CONTINUE FOREACH END IF 
 
      CALL p750_u_img_7(g_ogb.ogb09,g_ogb.ogb091,g_ogb.ogb092,g_ogb.ogb16)
      IF g_success='N' THEN RETURN END IF 
  
      CALL p750_u_ima_7()
      IF g_success='N' THEN RETURN END IF 
 
      CALL p750_u_tlf_7()
      IF g_success='N' THEN RETURN END IF 
 
      IF g_sma.sma115 = 'Y' THEN
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_ogb.ogb04
         IF l_ima906 = '2' THEN 
            IF NOT cl_null(g_ogb.ogb913) THEN 
               CALL p750_u_imgg_7('1',g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,
                    g_ogb.ogb092,g_ogb.ogb913,g_ogb.ogb914,g_ogb.ogb915,+1,'2')
               IF g_success='N' THEN RETURN END IF
            END IF
 
            IF NOT cl_null(g_ogb.ogb910) THEN 
                CALL p750_u_imgg_7('1',g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,
                     g_ogb.ogb092,g_ogb.ogb910,g_ogb.ogb911,g_ogb.ogb912,+1,'1')
                IF g_success='N' THEN RETURN END IF
                IF (NOT cl_null(g_ogb.ogb912) AND g_ogb.ogb912 <> 0) OR
                   (NOT cl_null(g_ogb.ogb915) AND g_ogb.ogb915 <> 0) THEN
                   CALL p750_u_tlff_7()
                   IF g_success='N' THEN RETURN END IF
                END IF
            END IF
         END IF
 
         IF l_ima906 = '3' THEN  
            IF NOT cl_null(g_ogb.ogb913) THEN 
               CALL p750_u_imgg_7('2',g_ogb.ogb04,g_ogb.ogb09,g_ogb.ogb091,
                    g_ogb.ogb092,g_ogb.ogb913,g_ogb.ogb914,g_ogb.ogb915,+1,'2')
               IF g_success='N' THEN RETURN END IF
            END IF
 
            IF NOT cl_null(g_ogb.ogb910) THEN
               IF (NOT cl_null(g_ogb.ogb912) AND g_ogb.ogb912 <> 0) OR
                  (NOT cl_null(g_ogb.ogb915) AND g_ogb.ogb915 <> 0) THEN
                  CALL p750_u_tlff_7()
                  IF g_success='N' THEN RETURN END IF
               END IF
            END IF
         END IF
      END IF
 
      CALL p750_u_tuq_tup_7()                                                     
      IF g_success='N' THEN RETURN END IF
 
    END FOREACH
END FUNCTION 
 
FUNCTION p750_u_oga_7()
    MESSAGE "u_oga!"
    CALL ui.Interface.refresh()
    UPDATE oga_file SET ogapost='N' WHERE oga01=g_oga.oga01
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd ogapost",1)   #No.FUN-660167
       LET g_success='N' RETURN 
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('upd ogapost:','axm-176',1) LET g_success='N' RETURN
    END IF
END FUNCTION 
 
FUNCTION p750_u_img_7 (p_ware,p_loca,p_lot,p_qty)
    DEFINE p_ware   LIKE img_file.img02,
           p_loca   LIKE img_file.img03,
           p_lot    LIKE img_file.img04,
           p_qty    LIKE img_file.img10
 
    CALL ui.Interface.refresh()
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty =0   END IF

    CALL ui.Interface.refresh()
    LET g_forupd_sql = 
           "   SELECT img01,img02,img03,img04 FROM img_file ",
           "      WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
           "   FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p750_img_lock CURSOR FROM g_forupd_sql

    OPEN p750_img_lock USING g_ogb.ogb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE p750_img_lock
       LET g_success = 'N'  #No.TQC-930155
       RETURN
    END IF

    FETCH p750_img_lock INTO g_ogb.ogb04,p_ware,p_loca,p_lot 
    IF STATUS THEN
       CALL cl_err('img_lock fail',STATUS,1) LET g_success='N' RETURN
    END IF

    CALL s_upimg(g_ogb.ogb04,p_ware,p_loca,p_lot,+1,p_qty,g_today,  #FUN-8C0084
                 '','','','','','','','','','','','','','',0,0,'','')
    IF STATUS OR g_success = 'N' THEN
       CALL cl_err('p750_u_img_7(-1):','9050',0)
       LET g_success='N'
       RETURN
    END IF
END FUNCTION  
 
FUNCTION p750_u_ima_7()
  #  DEFINE l_ima26   LIKE ima_file.ima26,
   #        l_ima261  LIKE ima_file.ima261,
    #       l_ima262  LIKE ima_file.ima262    #FUN-A20044
     DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3  #FUN-A20044
    MESSAGE "u_ima!"
    CALL ui.Interface.refresh()
 
    #LET l_ima26 =0 
   # LET l_ima261=0 
    #LET l_ima262=0  #FUN-A20044
     LET l_avl_stk_mpsmrp =0
     LET l_unavl_stk =0
     LET l_avl_stk =0 
   CALL	s_getstock(g_ogb.ogb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
  ####FUN-A20044---------BEGIN
 # SELECT SUM(img10*img21) INTO l_ima26  FROM img_file
  #   WHERE img01=g_ogb.ogb04 AND img24='Y'
   # IF STATUS THEN 
    #   CALL cl_err3("sel","img_file",g_ogb.ogb04,"",STATUS,"","sel sum1:",1)      #FUN-660167  
     #  LET g_success='N' 
   # END IF
   # IF l_ima26 IS NULL THEN LET l_ima26=0 END IF
 
    #SELECT SUM(img10*img21) INTO l_ima261 FROM img_file
    # WHERE img01=g_ogb.ogb04 AND img23='N'
   # IF STATUS THEN 
    #   CALL cl_err3("sel","img_file",g_ogb.ogb04,"",STATUS,"","sel sum2:",1)      #FUN-660167   
     #  LET g_success='N' 
   # END IF   
   # IF l_ima261 IS NULL THEN LET l_ima261=0 END IF
 
    #SELECT SUM(img10*img21) INTO l_ima262 FROM img_file
     #      WHERE img01=g_ogb.ogb04 AND img23='Y'
   # IF STATUS THEN 
    #   CALL cl_err3("sel","img_file",g_ogb.ogb04,"",STATUS,"","sel sum3:",1)      #FUN-660167   
    #   LET g_success='N' 
  #  END IF
   # IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
 
   # UPDATE ima_file SET ima26=l_ima26,ima261=l_ima261,ima262=l_ima262
    # WHERE ima01= g_ogb.ogb04
  #  IF STATUS OR SQLCA.SQLCODE THEN
   #    CALL cl_err3("upd","ima_file",g_ogb.ogb04,"",SQLCA.SQLCODE,"","upd ima26*",1)   #No.FUN-660167
    #   LET g_success='N' RETURN
   # END IF
   # IF SQLCA.SQLERRD[3]=0 THEN
    #   CALL cl_err('upd ima26*:','axm-176',1) LET g_success='N' RETURN
   # END IF
       ################FUN-A20044------END
END FUNCTION
 
FUNCTION p750_u_tlf_7()
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
    MESSAGE "d_tlf!"
    CALL ui.Interface.refresh()
  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",g_ogb.ogb04,"' AND tlf02=50 ",
                 "    AND  tlf036='",g_ogb.ogb01,"' AND tlf037=",g_ogb.ogb03," ",
                 "   AND tlf06 ='",g_oga.oga02,"'"     
    DECLARE p750_u_tlf_c1 CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p750_u_tlf_c1 INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     
    IF s_joint_venture( g_ogb.ogb04 ,g_plant) OR NOT s_internal_item( g_ogb.ogb04,g_plant ) THEN     #FUN-A90049
    ELSE                                                                             #FUN-A90049
  ##NO.FUN-8C0131   add--end
       DELETE FROM tlf_file
             WHERE tlf01 =g_ogb.ogb04 
               AND tlf036=g_ogb.ogb01 
               AND tlf037=g_ogb.ogb03 
               AND tlf06 =g_oga.oga02 
               AND tlf02='50'
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlf_file",g_ogb.ogb04,g_oga.oga02,SQLCA.SQLCODE,"","del tlf",1)   #No.FUN-660167
          LET g_success='N' RETURN  
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlf:','axm-176',1) LET g_success='N' RETURN
       END IF
  ##NO.FUN-8C0131   add--begin
    END IF                                                                   #FUN-A90049
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end    
END FUNCTION
 
FUNCTION p750_u_imgg_7(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
    DEFINE p_imgg00       LIKE imgg_file.imgg00,
           p_imgg01       LIKE imgg_file.imgg01,
           p_imgg02       LIKE imgg_file.imgg02,
           p_imgg03       LIKE imgg_file.imgg03,
           p_imgg04       LIKE imgg_file.imgg04,
           p_imgg09       LIKE imgg_file.imgg09,
           p_imgg211      LIKE imgg_file.imgg211,
           p_imgg10       LIKE imgg_file.imgg10
    DEFINE p_type         LIKE type_file.num10,         #No.FUN-680137  INTEGER
           p_no           LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1)
    DEFINE l_ima25        LIKE ima_file.ima25,
           l_ima906       LIKE ima_file.ima906,
           l_imgg21       LIKE imgg_file.imgg21
    DEFINE l_cnt LIKE type_file.num5

    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",   
        "   WHERE imgg01= ?  AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) 
    DECLARE p750_imgg_lock CURSOR FROM g_forupd_sql

    OPEN p750_imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09   
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N' 
       CLOSE p750_imgg_lock
       RETURN
    END IF
    FETCH p750_imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09 
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1) 
       LET g_success='N' 
       CLOSE p750_imgg_lock
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",0)   #No.FUN-660167
       LET g_success = 'N' RETURN 
    END IF
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no ='2') THEN 
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN 
    END IF
 
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_oga.oga02,  #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION p750_u_tlff_7()
    MESSAGE "d_tlff!"
    CALL ui.Interface.refresh()
    IF s_joint_venture( g_ogb.ogb04 ,g_plant) OR NOT s_internal_item( g_ogb.ogb04,g_plant ) THEN       #FUN-A90049
    ELSE                                                                          #FUN-A90049
       DELETE FROM tlff_file
             WHERE tlff01 =g_ogb.ogb04
               AND tlff036=g_ogb.ogb01
               AND tlff037=g_ogb.ogb03 
               AND tlff06 =g_oga.oga02
               AND tlff02 = 50
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlff_file",g_ogb.ogb04,g_oga.oga02,SQLCA.SQLCODE,"","del tlff",1)   #No.FUN-660167
          LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlffyy:','axm-176',1) LET g_success='N' RETURN
       END IF
    END IF                                                                       #FUN-A90049
END FUNCTION
 
FUNCTION p750_u_tuq_tup_7()
  DEFINE l_occ31   LIKE occ_file.occ31,
         l_ima25   LIKE ima_file.ima25, 
         l_ima71   LIKE ima_file.ima71, 
         l_tuq06   LIKE tuq_file.tuq06,
         l_tuq11   LIKE tuq_file.tuq11,
         l_tuq07   LIKE tuq_file.tuq07,
        #l_tup08   LIKE tup_file.tup08, #CHI-B40056 mark
         l_tup11   LIKE tup_file.tup11, #CHI-B40056
         l_tup05   LIKE tup_file.tup05
  DEFINE l_cnt,i          LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE l_fac1,l_fac2    LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE l_desc           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
  DEFINE l_tup05_1    LIKE tup_file.tup05              #FUN-910088--add--
  DEFINE l_tuq07_1 LIKE tuq_file.tuq07                 #FUN-910088--add--
  DEFINE l_tuq09_1 LIKE tuq_file.tuq09                 #FUN-910088--add--
 
   SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=g_oga.oga03   #No.TQC-640125              
   IF cl_null(l_occ31) THEN LET l_occ31='N' END IF                              
   IF l_occ31 = 'N' THEN RETURN END IF                        
 
   SELECT ima25,ima71 INTO l_ima25,l_ima71                                      
     FROM ima_file WHERE ima01=g_ogb.ogb04                                      
   IF cl_null(l_ima71) THEN LET l_ima71=0 END IF                                
                                                                                
   IF g_oga.oga00='7' tHEN
     #LET l_tup08='2' #CHI-B40056 mark
      LET l_tuq11='2'
   ELSE
     #LET l_tup08='1' #CHI-B40056 mark
      LET l_tuq11='1'
   END IF
   SELECT COUNT(*) INTO i FROM tuq_file                                         
    WHERE tuq01=g_oga.oga03    AND tuq02=g_ogb.ogb04                              #No.TQC-640125
      AND tuq03=g_ogb.ogb092 AND tuq04=g_oga.oga02  
      AND tuq11=l_tuq11   AND tuq12=g_oga.oga04   
      AND tuq05=g_oga.oga01  AND tuq051=g_ogb.ogb03 #MOD-CB0111 add
   IF i=0 THEN
      LET l_fac1=1                                                              
      IF g_ogb.ogb05 <> l_ima25 THEN                                            
         CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,l_ima25)                         
              RETURNING l_cnt,l_fac1                                          
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(g_ogb.ogb04,'abm-731',1)                                
            LET l_fac1=1                                                        
         END IF                                                                 
      END IF                                                                    
    #FUN-910088--add--start--
       LET l_tuq09_1 = g_ogb.ogb12*l_fac1*-1
       LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
     #FUN-910088--add--end--
      INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,                       
                           tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,                       
                           tuqplant,tuqlegal)   #FUN-980010 add plant & legal 
   #FUN-910088--mark--start--
   #   VALUES(g_oga.oga03,g_ogb.ogb04,g_ogb.ogb092,g_oga.oga02,g_oga.oga01,g_ogb.ogb03,      #No.TQC-640125
   #          g_ogb.ogb05,g_ogb.ogb12*-1,l_fac1,g_ogb.ogb12*l_fac1*-1,'1',l_tuq11,g_oga.oga04,             
   #          g_plant,g_legal)   #FUN-980010
   #FUN-910088--mark--end--
   #FUN-910088--add--start--
       VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,g_oga.oga02,g_oga.oga01,
              b_ogb.ogb05,b_ogb.ogb12*-1,l_fac1,l_tuq09_1,'1','1',g_oga.oga04,b_ogb.ogb03, #No.TQC-7C0001 add b_ogb.ogb03
                            g_plant,g_legal)
   #FUN-910088--add--end--
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",0)   #No.FUN-660167
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF                                                                    
   ELSE                                                                         
      SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file                            
       WHERE tuq01=g_oga.oga03    AND tuq02=g_ogb.ogb04                            #NO.TQC-640125
         AND tuq03=g_ogb.ogb092 AND tuq04=g_oga.oga02         
         AND tuq11=l_tuq11   AND tuq12=g_oga.oga04  
         AND tuq05=g_oga.oga01  AND tuq051=g_ogb.ogb03 #MOD-CB0111 add
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",0)   #No.FUN-660167
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF                                                                    
      LET l_fac1=1                                                              
      IF g_ogb.ogb05 <> l_tuq06 THEN                                            
         CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,l_tuq06)                         
              RETURNING l_cnt,l_fac1                                            
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(g_ogb.ogb04,'abm-731',1)                                
            LET l_fac1=1                                                        
         END IF                                                                 
      END IF                                                                    
      LET l_fac2=1                                                              
      IF l_tuq06 <> l_ima25 THEN                                                
         CALL s_umfchk(g_ogb.ogb04,l_tuq06,l_ima25)                             
              RETURNING l_cnt,l_fac2                                            
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(g_ogb.ogb04,'abm-731',1)           
            LET l_fac2=1                                                        
         END IF                                                                 
      END IF                                                                    
                                                                                
      SELECT tuq07 INTO l_tuq07 FROM tuq_file                                   
       WHERE tuq01=g_oga.oga03    AND tuq02=g_ogb.ogb04                            #No.TQC-640125
         AND tuq03=g_ogb.ogb092 AND tuq04=g_oga.oga02                           
         AND tuq11=l_tuq11   AND tuq12=g_oga.oga04  
         AND tuq05=g_oga.oga01  AND tuq051=g_ogb.ogb03 #MOD-CB0111 add
      IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF                             
      IF l_tuq07-g_ogb.ogb12*l_fac1<0 THEN                                      
         LET l_desc='2'                                                         
      ELSE                                                                      
         LET l_desc='1'                                                         
      END IF                                                                    
      IF l_tuq07-g_ogb.ogb12*l_fac1=0 THEN                                      
         DELETE FROM tuq_file                                                   
          WHERE tuq01=g_oga.oga03    AND tuq02=g_ogb.ogb04                         #No.TQC-640125
            AND tuq03=g_ogb.ogb092 AND tuq04=g_oga.oga02                        
            AND tuq11=l_tuq11   AND tuq12=g_oga.oga04  
            AND tuq05=g_oga.oga01  AND tuq051=g_ogb.ogb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",0)   #No.FUN-660167
            LET g_success='N'                                                   
            RETURN                                                              
         END IF                                                
      ELSE                                                                      
      #FUN-910088--add--start--
          LET l_tuq07_1 = g_ogb.ogb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = g_ogb.ogb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                              tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start
       # UPDATE tuq_file SET tuq07=tuq07-g_ogb.ogb12*l_fac1,                    
       #                     tuq09=tuq09-g_ogb.ogb12*l_fac1*l_fac2,             
       #FUN-910088--mark--end--
                             tuq10=l_desc                                       
          WHERE tuq01=g_oga.oga03    AND tuq02=g_ogb.ogb04                         #No.TQC-640125
            AND tuq03=g_ogb.ogb092 AND tuq04=g_oga.oga02                        
            AND tuq11=l_tuq11   AND tuq12=g_oga.oga04  
            AND tuq05=g_oga.oga01  AND tuq051=g_ogb.ogb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",0)   #No.FUN-660167
            LET g_success='N'                                                   
            RETURN                                                              
         END IF                                                                 
      END IF                                                                    
   END IF                                                                       
                                                                                
   LET l_fac1=1                                                                 
   IF g_ogb.ogb05 <> l_ima25 THEN                                               
      CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,l_ima25)                            
           RETURNING l_cnt,l_fac1                                               
      IF l_cnt = '1'  THEN                                                      
         CALL cl_err(g_ogb.ogb04,'abm-731',1)                                   
         LET l_fac1=1                                                           
      END IF                                  
   END IF                                                                       
 
   SELECT tup05 INTO l_tup05 FROM tup_file                                      
    WHERE tup01=g_oga.oga03   AND tup02=g_ogb.ogb04                             #No.TQC-640125 
      AND tup03=g_ogb.ogb092                                                    
     #AND tup08=l_tup08 AND tup09=g_oga.oga04 #CHI-B40056 mark
      AND tup11=l_tup11 AND tup12=g_oga.oga04 #CHI-B40056
                                                                     
    #FUN-910088--add--start--
      LET l_tup05_1 = b_ohb.ohb12*l_fac1
      LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)    
      UPDATE tup_file SET tup05=tup05-l_tup05_1
    #FUN-910088--add--end--
    # UPDATE tup_file SET tup05=tup05-g_ogb.ogb12*l_fac1        #FUN-910088--mark--                
       WHERE tup01=g_oga.oga03 AND tup02=g_ogb.ogb04                          #No.TQC-640125 
         AND tup03=g_ogb.ogb092                                                 
        #AND tup08=l_tup08 AND tup09=g_oga.oga04 #CHI-B40056 mark
         AND tup11=l_tup11 AND tup12=g_oga.oga04 #CHI-B40056
    IF SQLCA.sqlcode THEN                                                     
       CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","update tup_file",0)   #No.FUN-660167
       LET g_success='N' 
       RETURN                                               
    END IF             
 
END FUNCTION
 
FUNCTION p750_delimm()
   DEFINE l_msg   STRING
   DEFINE l_tot   LIKE oeb_file.oeb25
   DEFINE l_ocn03 LIKE ocn_file.ocn03
   DEFINE l_ocn04 LIKE ocn_file.ocn04
 
   IF cl_null(g_oha.oha56) THEN
      CALL cl_err("g_oha.oha01","axm-145",1)
      LET g_success = "N"
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success='Y'
 
   IF g_success = 'Y' THEN 
      COMMIT WORK  
      LET l_msg="aimp378 '",g_oha.oha56,"'"
      CALL cl_cmdrun_wait(l_msg)
      RETURN 
   ELSE 
      ROLLBACK WORK
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p750_u_tlfs() #------------------------------------ Update tlfs_file
   DEFINE l_ima918   LIKE ima_file.ima918   #No.MOD-840189
   DEFINE l_ima921   LIKE ima_file.ima921   #No.MOD-840189
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = b_ohb.ohb04   #MOD-910150
      AND imaacti = "Y"
   
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
 
   IF g_bgjob = 'N' THEN
      MESSAGE "d_tlfs!"
   END IF
 
   CALL ui.Interface.refresh()
   IF s_joint_venture( b_ohb.ohb04 ,g_plant) OR NOT s_internal_item( b_ohb.ohb04,g_plant ) THEN      #FUN-A90049
   ELSE                                                                        #FUN-A90049
      DELETE FROM tlfs_file
       WHERE tlfs01 = b_ohb.ohb04
         AND tlfs10 = g_oha.oha01
         AND tlfs11 = b_ohb.ohb03
         AND tlfs111 = g_oha.oha02 
 
      IF STATUS THEN
         IF g_bgerr THEN
            LET g_showmsg = b_ohb.ohb04,'/',g_oha.oha02
            CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:',STATUS,1)
         ELSE
            CALL cl_err3("del","tlfs_file",g_oha.oha01,"",STATUS,"","del tlfs",1)
         END IF
         LET g_success='N'
         RETURN
      END IF
 
      IF SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr THEN
            LET g_showmsg = b_ohb.ohb04,'/',g_oha.oha02
            CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:','mfg0177',1)
         ELSE
            CALL cl_err3("del","tlfs_file",g_oha.oha01,"","mfg0177","","del tlfs",1) 
         END IF
         LET g_success='N'
         RETURN
      END IF
    END IF                                                                        #FUN-A90049
 
END FUNCTION
#No:FUN-9C0071--------精簡程式----- 
