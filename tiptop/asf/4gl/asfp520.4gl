# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfp520.4gl            #
# Descriptions...: 工單單料移撥作業
# Date & Author..: 88/01/02 By Dennon Lai
# Modiry         : 03/04/10 By Mandy
# Modify.........: 04/07/16 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-490178 04/09/29 ching 發料型態應是 "3" 補料
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-510029 05/02/23 By Mandy 報表轉XML
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-580132 05/08/26 By Carrier 加入多單位內容
# Modify.........: No.TQC-610100 06/01/19 By kevin call i501()時,所用的單後面多加'S'
# Modify.........: NO:EXT-610018 06/03/24 By PENGU 1.CREATE TEMP TABLE 時sfp01定義成char(10) 應該是要為char(16)
                               #                   2.再產生補料單時，無法產生補料單單劇號碼
                               #                   3.call i501()時,所用的單據後面多加'S',迼成在CALL i501()時單據傳入時執
                               #                     行到i501_s()時讀取不到sfp_file的資料  
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660166 06/06/26 By saki 因流程訊息功能修改CALL i501()參數數目
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-6B0120 06/12/06 By claire 取自sfa_file而非ima_file
# Modify.........: No.TQC-6C0075 06/12/14 By Sarah q_sfa11的回傳值是三個,卻只接一個回傳值,導致按放棄時程式當出
# Modify.........: No.FUN-710026 07/02/01 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-730042 07/03/13 By pengu 若"自動扣帳"打勾時，sfpconf預設為"Y"
# Modify.........: No.FUN-730075 07/03/30 By 移除sasfi501的link改用外部呼叫方式
# Modify.........: No.FUN-740187 07/04/27 By kim 過帳段CALL sasfi501_sub.4gl
# Modify.........: No.MOD-7C0119 07/12/18 By Pengu 當執行自動扣帳時會出現-255之錯誤訊息.
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.MOD-8B0086 08/11/10 By chenyu 工單沒有取替代時，讓sfs27=sfa27
# Modify.........: No.FUN-940008 09/05/07 By hongmei 發料改善
# Modify.........: No.MOD-980075 09/08/13 By Smapmin insert into sfs_file之前要把l_sfs清空
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-980025 09/08/22 By chenmoyan 將此程序納入批序號管理
# Modify.........: No:MOD-960333 09/10/20 By Pengu 在新增img_file時會異常
# Modify.........: No:MOD-9B0167 09/11/25 By lilingyu 來源工單有某物料的發料量,在目的工單中也有此物料的欠料量,但是再移轉時,卻提示"無符合條件的工單可以挪料,請再下條件"
# ...............:                                    原因是:挪料時不應該對作業編號進行控管
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60081 10/06/08 By vealxu 製造功能優化-平行制程（批量修改） 
# Modify.........: No.FUN-A70125 10/07/27 By lilingyu 平行工藝整批修改
# Modify.........: No.FUN-AA0077 10/10/26 By zhangll 控制只能查询和选择属于该营运中心的仓库
# Modify.........: No.FUN-AA0059 10/11/01 By chenying 料號開窗控管
# Modify.........: No.TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 因asfi510新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No:FUN-B70074 11/07/25 By lixh1 增加行業別TABLE(sfsi_file)的處理
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:MOD-BA0112 11/10/14 By destiny 挪料作業在生成退料單asfi528和欠料補料單asfi513没有考慮到料號是取替代的情况
# Modify.........: No:TQC-B90236 11/10/28 By zhuhao rvbs09的地方增加判斷
# Modify.........: No:FUN-BB0084 11/12/14 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-910088 11/12/06 By chenjing 增加數量欄位小數取位
# Modify.........: No:TQC-C60072 12/06/07 By fengrui 添加rvbsplant、rvbslegal赋值
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:TQC-C90080 12/09/24 By chenjing 修改檔sma541=N時asfp5201畫面"工藝序""工藝段號"隱藏
# Modify.........: No:TQC-C90081 12/09/25 By chenjing 修改退料單號和領料單號開窗和手工key值時單別限制
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查

# Modify.........: No:TQC-D50127 13/05/30 By lixh1 修正FUN-D40103控管
# Modify.........: No:TQC-D50126 13/05/30 By lixh1 修正FUN-D40103控管

DATABASE ds
 
GLOBALS "../../config/top.global"
 
# DEFINE g_t1               VARCHAR(04)
DEFINE g_t1               LIKE oay_file.oayslip      #No.FUN-550067          #No.FUN-680121 VARCHAR(05)
DEFINE tm RECORD
           wc    LIKE type_file.chr1000,#No.FUN-680121 VARCHAR(500)#來源工單QBE
          sfb01b LIKE sfb_file.sfb01,  #目的工單
          sfa03  LIKE sfa_file.sfa03,  #料件編號
          ima02  LIKE ima_file.ima02,
          ima021 LIKE ima_file.ima021,
          ima108 LIKE ima_file.ima108,#SMT料否 
          sfa12  LIKE sfa_file.sfa12, #單位
          sfa012 LIKE sfa_file.sfa012,#FUN-A60081  製程段號
          sfa013 LIKE sfa_file.sfa013,#FUN-A60081  製程序     
          sfa08  LIKE sfa_file.sfa08, #作業編號
#         needqty LIKE ima_file.ima26,#No.FUN-680121 DEC(15,3)#需求數量
          needqty LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          a      LIKE type_file.chr1,  #No.FUN-680121 VARCHAR(1)#是否列印模擬報表
          b      LIKE type_file.chr1,  #No.FUN-680121 VARCHAR(1)#是否自動扣帳
          sfp01a  LIKE sfp_file.sfp01,#退料單號
          sfp01b  LIKE sfp_file.sfp01,#領料單號
          sfs07a LIKE sfs_file.sfs07, #一般倉庫
          sfs08a LIKE sfs_file.sfs08, #    儲位
          sfs09a LIKE sfs_file.sfs09, #    批號
          sfs07b LIKE sfs_file.sfs07, #SMT 倉庫
          sfs08b LIKE sfs_file.sfs08, #    儲位
          sfs09b LIKE sfs_file.sfs09  #    批號
       END RECORD
DEFINE g_arrcnt    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
       g_ware_flag LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_sfa DYNAMIC ARRAY OF RECORD
          sfa01  LIKE sfa_file.sfa01,
          sfa012 LIKE sfa_file.sfa012,     #No.FUN-A60081
          sfa013 LIKE sfa_file.sfa013,     #No.FUN-A60081 
          sfa08  LIKE sfa_file.sfa08,
          sfa12  LIKE sfa_file.sfa12,
          sfa05  LIKE sfa_file.sfa05,
          sfa06  LIKE sfa_file.sfa06,
#         ot_qty LIKE ima_file.ima26,        #No.FUN-680121 DEC(15,3)
#         av_qty LIKE ima_file.ima26,        #No.FUN-680121 DEC(15,3)
#         tr_qty LIKE ima_file.ima26,        #No.FUN-680121 DEC(15,3)
          ot_qty LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
          av_qty LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
          tr_qty LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
          sfa062 LIKE sfa_file.sfa062,
          sfa30  LIKE sfa_file.sfa30,
          sfa31  LIKE sfa_file.sfa31,
          tmp99  LIKE aag_file.aag01       #No.FUN-680121 VARCHAR(24)
       END RECORD
DEFINE g_sfa1            RECORD LIKE sfa_file.*
DEFINE g_sfb             RECORD LIKE sfb_file.*
DEFINE g_sfp             RECORD LIKE sfp_file.*
DEFINE g_sfq             RECORD LIKE sfq_file.*
DEFINE g_sfm             RECORD LIKE sfm_file.*
DEFINE g_sfn             RECORD LIKE sfn_file.*
DEFINE g_sfs             RECORD LIKE sfs_file.*,
       g_sfb04          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
       g_yy,g_mm        LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE g_buf            LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(80)
DEFINE g_wc,g_sql       string                        #No.FUN-580092 HCN
#DEFINE g_tqty           LIKE ima_file.ima26           #No.FUN-680121 DEC(15,3)#擬轉數量合計
DEFINE g_tqty           LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
DEFINE g_img09          LIKE img_file.img09
DEFINE g_za05           LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(40)
DEFINE p_row,p_col      LIKE type_file.num5                #No.FUN-680121 SMALLINT
DEFINE g_chr            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_i              LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE g_short_qty      LIKE sfa_file.sfa07          #FUN-940008 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_arrcnt=150
   LET g_prog='asfp520'
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0090
   OPEN WINDOW p520_w AT p_row,p_col
        WITH FORM "asf/42f/asfp520" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_comp_visible("sfa012,sfa013", g_sma.sma541 = 'Y')     #FUN-A60081 
 
 
    #CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #MOD-580222 mark  #No.FUN-6A0090
   IF g_sma.sma53 IS NOT NULL AND TODAY <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1)
   ELSE
      CALL s_yp(g_today) RETURNING g_yy,g_mm
      IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
         CALL cl_err(g_yy,'mfg6090',1)
      ELSE
         CALL p520()
      END IF
   END IF
 
   CLOSE WINDOW p520_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0090
END MAIN
 
#-------------------------------------------------------------------------
 
FUNCTION p520()
#  DEFINE   l_t1   VARCHAR(3)
   DEFINE   l_t1   LIKE oay_file.oayslip        #No.FUN-680121 VARCHAR(5)#No.FUN-550067 
   DEFINE   l_flag LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   DEFINE li_result   LIKE type_file.num5       #No.FUN-550067         #No.FUN-680121 SMALLINT
   DEFINE l_sfa    RECORD LIKE sfa_file.*       #No.FUN-940008 add
   DEFINE l_sql    STRING                       #No.FUN-940008 add 
   DEFINE l_sfa27  LIKE sfa_file.sfa27          #No.FUN-940008 add
   DEFINE l_sfa28  LIKE sfa_file.sfa28          #No.FUN-940008 add
   DEFINE li_where STRING                       #No.FUN-940008 add
   DEFINE l_sfb05  LIKE sfb_file.sfb05,         #FUN-A60081
          l_sfb06  LIKE sfb_file.sfb06,         #FUN-A60081 
          l_count  LIKE type_file.num5          #FUN-A60081   
   DEFINE l_smy73  LIKE smy_file.smy73          #TQC-AC0293
   DEFINE l_smy72  LIKE smy_file.smy72          #TQC-C90081

   WHILE TRUE
      CLEAR FORM
   CALL g_sfa.clear()
      MESSAGE ""
      INITIALIZE tm.* TO NULL
      IF g_sma.sma541 ='Y' THEN                 #No.FUN-A60081
         CALL cl_set_comp_entry("sfa08",FALSE)  #No.FUN-A60081
      END IF                                    #No.FUN-A60081 
      CALL cl_set_head_visible("grid01","YES")  #NO.FUN-6B0031
      CONSTRUCT BY NAME tm.wc ON sfb01,sfb05
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #MOD-490417
        ON ACTION controlp                  
           CASE WHEN INFIELD(sfb01) #order nubmer
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb01
                     NEXT FIELD sfb01
                WHEN INFIELD(sfb05) #item
#FUN-AA0059---------mod------------str----------------- 
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state    = "c"
#                    LET g_qryparam.form     = "q_ima"
#                    LET g_qryparam.default1 = g_sfb.sfb05
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","",g_sfb.sfb05,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------                     
                     DISPLAY g_qryparam.multiret TO sfb05
                     NEXT FIELD sfb05
           END CASE
        #--
      
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET tm.a = 'Y'
      LET tm.b = 'Y'
      CALL cl_set_head_visible("grid01","YES")  #NO.FUN-6B0031
      INPUT BY NAME 
            tm.sfb01b,tm.sfa03,tm.sfa12,tm.sfa012,tm.sfa013,tm.sfa08,tm.needqty,   #FUN-A60081 add sfa012,sfa013
            tm.a,tm.b,tm.sfp01a,tm.sfp01b,
            tm.sfs07a,tm.sfs08a,tm.sfs09a,
            tm.sfs07b,tm.sfs08b,tm.sfs09b
            WITHOUT DEFAULTS
      
            #NO:6968---
         AFTER FIELD sfb01b #目的工單
            IF cl_null(tm.sfb01b) THEN 
               #此欄位不可空白, 請輸入資料!
               CALL cl_err(tm.sfb01b,'aap-099',0)
               NEXT FIELD sfb01b 
            END IF
            SELECT COUNT(*) INTO g_cnt
              FROM snb_file
             WHERE snb01 = tm.sfb01b
               AND snbconf = 'N' 
            IF g_cnt >= 1 THEN
               #此張工單有做工單變更,但未發出,所以不可做挪料!
               CALL cl_err(tm.sfb01b,'asf-748',0)
               NEXT FIELD sfb01b
            END IF
#FUN-940008---Begin 
#           SELECT COUNT(*) INTO g_cnt
#             FROM sfa_file
#            WHERE sfa01 = tm.sfb01b
#              AND sfa07 > 0 
            LET l_sql = " SELECT * FROM sfa_file ",
                        "  WHERE sfa01 = '",tm.sfb01b,"'"
            PREPARE p520_sfa_pre FROM l_sql
            DECLARE p520_sfa CURSOR FOR p520_sfa_pre
            FOREACH p520_sfa INTO l_sfa.*
               CALL s_shortqty(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,
                               l_sfa.sfa12,l_sfa.sfa27,l_sfa.sfa012,l_sfa.sfa013)          #FUN-A60081 add sfa012 sfa013
                  RETURNING g_short_qty
               IF g_short_qty <= 0 THEN 
                  CONTINUE FOREACH
               ELSE
                  LET g_cnt = g_cnt+1               
               END IF 
            END FOREACH
#FUN-940008---End          
            IF g_cnt <= 0 THEN
               #此目的工單並無備料的欠料量大於零的資料!
               CALL cl_err(tm.sfb01b,'asf-753',0)
               LET tm.sfb01b = ''
               DISPLAY BY NAME tm.sfb01b
               NEXT FIELD sfb01b
            END IF
            SELECT * INTO g_sfb.* 
              FROM sfb_file 
             WHERE sfb01 = tm.sfb01b
            IF STATUS THEN
               CALL cl_err('sel sfb:',STATUS,0) NEXT FIELD sfb01b
            END IF
            IF g_sfb.sfb04<'4' THEN
               CALL cl_err('sfb04','asf-570',0) NEXT FIELD sfb01b
            END IF
            IF g_sfb.sfb04>='8' THEN
               CALL cl_err('sfb04','asf-345',0) NEXT FIELD sfb01b
            END IF
            SELECT MIN(sfa08)  ,MIN(sfa12) 
              INTO g_sfa1.sfa08,g_sfa1.sfa12
              FROM sfa_file
             WHERE sfa01=tm.sfb01b 
               AND sfa03=tm.sfa03
            IF STATUS THEN
               #不存在工單發料底稿單身中
               CALL cl_err(tm.sfa03 CLIPPED,'asf-650',0) 
               NEXT FIELD sfa03
            END IF
            LET tm.needqty = g_sfa1.sfa07
            IF tm.ima108 = 'N' THEN
               DISPLAY BY NAME tm.sfs07a,tm.sfs08a,tm.sfs09a #一般
            ELSE
               DISPLAY BY NAME tm.sfs07b,tm.sfs08b,tm.sfs09b #SMT
            END IF
 
         AFTER FIELD sfa03 #料件編號
           #IF cl_ku() THEN
           #   NEXT FIELD sfb01b
           #END IF
            IF cl_null(tm.sfa03) THEN 
               #此欄位不可空白, 請輸入資料!
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfa03 
            END IF
            SELECT COUNT(*) INTO g_cnt
              FROM sfa_file
             WHERE sfa01 = tm.sfb01b
               AND sfa03 = tm.sfa03
            IF g_cnt <=0  THEN
               #目的工單並無此下階備料!
               CALL cl_err(tm.sfa03,'asf-752',0)
               LET tm.sfa03 = ''
               DISPLAY BY NAME tm.sfa03
               NEXT FIELD sfa03
            END IF
#FUN-940008---Begin
#           SELECT COUNT(*) INTO g_cnt
#             FROM sfa_file
#            WHERE sfa01 = tm.sfb01b
#              AND sfa03 = tm.sfa03
#              AND sfa07 > 0 
            LET l_sql = " SELECT * FROM sfa_file ",
                        "  WHERE sfa01 = '",tm.sfb01b,"'",
                        "    AND sfa03 = '",tm.sfa03,"'"
            PREPARE p520_sfa_1_pre FROM l_sql 
            DECLARE p520_sfa_1 CURSOR FOR p520_sfa_1_pre
            FOREACH p520_sfa_1 INTO l_sfa.*
               CALL s_shortqty(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,
                               l_sfa.sfa12,l_sfa.sfa27,l_sfa.sfa012,l_sfa.sfa013)     #FUN-A60081 add sfa012,sfa013
                  RETURNING g_short_qty
               IF g_short_qty <= 0 THEN 
                  CONTINUE FOREACH
               ELSE 
                  LET g_cnt = g_cnt+1
               END IF 
            END FOREACH
#FUN-940008---End          
            IF g_cnt <= 0 THEN
               #料件的欠料量為零!
               CALL cl_err(tm.sfa03,'asf-747',0)
               LET tm.sfa03 = ''
               DISPLAY BY NAME tm.sfa03
               NEXT FIELD sfa03
            END IF
            LET tm.ima02 = NULL
            LET tm.ima021= NULL
            LET tm.ima108= NULL
            SELECT ima02,ima021,ima108 INTO tm.ima02,tm.ima021,tm.ima108 #BugNo:6549
              FROM ima_file
             WHERE ima01=tm.sfa03
            IF STATUS THEN
               CALL cl_err('sel ima:',STATUS,0) NEXT FIELD sfa03
            END IF
            DISPLAY BY NAME tm.ima02,tm.ima021,tm.ima108
 
         BEFORE FIELD sfa12
            IF cl_null(tm.sfa12) THEN
               SELECT sfa08,sfa12 
                 INTO tm.sfa08,tm.sfa12
                 FROM sfa_file
                WHERE sfa01 = tm.sfb01b
                  AND sfa03 = tm.sfa03
                  AND sfa012 =  ' ' AND sfa013 = 0    #FUN-A60081 
               DISPLAY BY NAME tm.sfa08,tm.sfa12
            END IF
 
         AFTER FIELD sfa12 #單位
            IF cl_null(tm.sfa12) THEN
               #此欄位不可空白, 請輸入資料!
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfa12
            END IF
            SELECT COUNT(*) INTO g_cnt
              FROM gfe_file
             WHERE gfe01 = tm.sfa12
            IF g_cnt <=0 THEN
               #無此單位編號
               CALL cl_err('','mfg0019',0)
               NEXT FIELD sfa12
            END IF
        
         #FUN-A60081 -----------------start---------------------
         AFTER FIELD sfa012       #製程段號
            LET l_count  = 0 
            IF NOT cl_null(tm.sfa012) THEN
               SELECT COUNT(*) INTO l_count
                 FROM sfa_file 
                WHERE sfa01 = tm.sfb01b 
                  AND sfa03 = tm.sfa03
                  AND sfa012 = tm.sfa012  
               IF l_count = 0 THEN 
                  CALL cl_err('','aec-300',0)
                  NEXT FIELD sfa012
               ELSE
                  SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06
                    FROM sfb_file
                   WHERE sfb01 = tm.sfb01b
                  SELECT ecb06 INTO tm.sfa08
                    FROM ecb_file
                   WHERE ecb01 = l_sfb05 AND ecb02 = l_sfb06
                     AND ecb03 = tm.sfa013 AND ecb012 = tm.sfa012
               END IF  
            ELSE
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfa012
            END IF    
            DISPLAY BY NAME tm.sfa012,tm.sfa08
    
         AFTER FIELD sfa013       #製程序
            LET l_count = 0 
            IF NOT cl_null(tm.sfa013) THEN
               SELECT count(*) INTO l_count 
                 FROM sfa_file 
                WHERE sfa01 = tm.sfb01b
                  AND sfa03 = tm.sfa03       
                  AND sfa012 = tm.sfa012    
                  AND sfa013 = tm.sfa013
               IF l_count  = 0 THEN 
                  CALL cl_err('','aec-301',0)
                  NEXT FIELD sfa013
               ELSE 
                  SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 
                    FROM sfb_file
                   WHERE sfb01 = tm.sfb01b
                  SELECT ecb06 INTO tm.sfa08
                    FROM ecb_file 
                   WHERE ecb01 = l_sfb05 AND ecb02 = l_sfb06 
                     AND ecb03 = tm.sfa013 AND ecb012 = tm.sfa012 
               END IF 
            ELSE
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfa013
            END IF 
            DISPLAY BY NAME tm.sfa013,tm.sfa08
          #FUN-A60081 -----------------end----------------------   
 
         AFTER FIELD sfa08 #作業編號
            IF cl_null(tm.sfa08) THEN
               LET tm.sfa08 = ' ' 
            END IF
            SELECT COUNT(*) INTO g_cnt
              FROM sfa_file
             WHERE sfa01 = tm.sfb01b
               AND sfa03 = tm.sfa03
               AND sfa08 = tm.sfa08
               AND sfa12 = tm.sfa12
               AND sfa012 = ' ' AND sfa013 = 0   #FUN-A60081 
            IF g_cnt = 0 THEN
               #"料件編號"+"單位"+"作業編號"並不存在於目的工單的備料中!
               CALL cl_err('','asf-751',0)
               NEXT FIELD sfb01b
            ELSE
               SELECT * INTO g_sfa1.*
                 FROM sfa_file
                WHERE sfa01=tm.sfb01b
                  AND sfa03=tm.sfa03
                  AND sfa08=tm.sfa08
                  AND sfa12=tm.sfa12
                  AND sfa012 = ' ' AND sfa013 =  0  #FUN-A60081 
#FUN-940008---Begin add
               CALL s_shortqty(g_sfa1.sfa01,g_sfa1.sfa03,g_sfa1.sfa08,
                               g_sfa1.sfa12,g_sfa1.sfa27,g_sfa1.sfa012,g_sfa1.sfa013)         #FUN-A60081 add sfa012,sfa013
                  RETURNING g_short_qty
               IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
         #     LET tm.needqty = g_sfa1.sfa07
               LET tm.needqty = g_short_qty
#FUN-940008---End
               DISPLAY BY NAME tm.needqty
            END IF
 
         AFTER FIELD needqty
           #IF cl_ku() THEN
           #   NEXT FIELD sfa08
           #END IF
            IF tm.needqty <= 0    OR 
               tm.needqty IS NULL THEN
               #本欄位之值, 不可空白或小於等於零, 請重新輸入!
               CALL cl_err('','aap-022',0)
               NEXT FIELD needqty
            END IF
            IF tm.needqty > g_sfa1.sfa05-g_sfa1.sfa06 THEN 
               #此數為未發數量,輸入的需求數量不可大於未發數量!
               CALL cl_err(g_sfa1.sfa05-g_sfa1.sfa06,'asf-942',0)
               NEXT FIELD needqty
            END IF
 
         AFTER FIELD a #是否列印模擬報表(Y/N)
            IF tm.a NOT MATCHES "[YN]" THEN
               #欄位必須輸入Y或N,請重新輸入
               CALL cl_err('','9061',0)
               NEXT FIELD a
            END IF 
            IF cl_null(tm.a) THEN
               #欄位必須輸入Y或N,請重新輸入
               CALL cl_err('','9061',0)
               NEXT FIELD a
            END IF
 
         AFTER FIELD b #是否自動扣帳(Y/N)
            IF tm.b NOT MATCHES "[YN]" THEN
               #欄位必須輸入Y或N,請重新輸入
               CALL cl_err('','9061',0)
               NEXT FIELD b
            END IF 
            IF cl_null(tm.b) THEN
               #欄位必須輸入Y或N,請重新輸入
               CALL cl_err('','9061',0)
               NEXT FIELD b
            END IF
 
         AFTER FIELD sfp01a #退料單號
            IF cl_null(tm.sfp01a) THEN 
               #本欄位不可空白, 請重新輸入!
               CALL cl_err(tm.sfp01a,'mfg0037',0)
               NEXT FIELD sfp01a 
            END IF
            LET l_t1 = tm.sfp01a
         #No.FUN-550067 --start--                                                                                                   
            CALL s_check_no("asf",l_t1,"","4","","","")                                                                          
            RETURNING li_result,tm.sfp01a                                                                                            
            DISPLAY BY NAME tm.sfp01a                                                                                                
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD sfp01a                                                                                                    
            END IF                                                                                                                  
           #TQC-AC0293 -------------add start---------
            SELECT smy73,smy72 INTO l_smy73,l_smy72 FROM smy_file     #TQC-C90081 add smy72
             WHERE smyslip = l_t1
            IF l_smy73 = 'Y' THEN
              CALL cl_err('','asf-874',0)
              NEXT FIELD sfp01a
           END IF
           #TQC-AC0293 -------------add end------------      
          #TQC-C90081--ADD--
           IF l_smy72 <> '8' THEN
              CALL cl_err('','mfg0015',1)
              NEXT FIELD sfp01a
           END IF
          #TQC-C90081--ADD--
 
#           CALL s_mfgslip(l_t1,'asf','4')
#           IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
#              CALL cl_err(l_t1,g_errno,0) 
#              NEXT FIELD sfp01a
#           END IF
      #No.FUN-550067 ---end---   
 
         AFTER FIELD sfs07a #一般倉庫
            IF NOT cl_null(tm.sfs07a) THEN 
               SELECT imd01 INTO g_buf FROM imd_file 
                WHERE imd01=tm.sfs07a
                  AND imd10='S'
                   AND imdacti = 'Y' #MOD-4B0169
               IF STATUS THEN
                  CALL cl_err('sel imd:','mfg1100',0)
                  NEXT FIELD sfs07a
               END IF
               #---> Add No.FUN-AA0077
               IF NOT s_chk_ware(tm.sfs07a) THEN  #检查仓库是否属于当前门店
                  NEXT FIELD sfs07a
               END IF
               #---> End Add No.FUN-AA0077
            END IF
           #FUN-D40103 -------Begin--------
            IF NOT p520_ime_chk(tm.sfs07a,tm.sfs08a,'S') THEN    #TQC-D50127
               NEXT FIELD sfs08a
            END IF
           #FUN-D40103 -------End----------
 
         AFTER FIELD sfs08a #儲位
            IF NOT cl_null(tm.sfs08a) THEN
         #FUN-D40103 ------Begin-------
              #SELECT ime01 INTO g_buf FROM ime_file
              #   WHERE ime01=tm.sfs07a 
              #     AND ime02=tm.sfs08a
              #     AND ime04='S'
              #IF STATUS THEN
              #   LET tm.sfs08a=' '
              #   CALL cl_err('sel ime:','mfg1100',0) NEXT FIELD sfs08a
              #END IF
         #FUN-D40103 ------End----------
            ELSE
               LET tm.sfs08a=' '
            END IF
           #FUN-D40103 -------Begin--------
            IF NOT p520_ime_chk(tm.sfs07a,tm.sfs08a,'S') THEN 
               NEXT FIELD sfs08a
            END IF
           #FUN-D40103 -------End----------
 
         AFTER FIELD sfs07b #SMT倉庫
            IF NOT cl_null(tm.sfs07b) THEN
               SELECT imd01 INTO g_buf FROM imd_file 
                WHERE imd01=tm.sfs07b
                  AND imd10='W'
                   AND imdacti = 'Y' #MOD-4B0169
               IF SQLCA.sqlcode THEN
                  CALL cl_err('sel imd:','mfg1100',0) 
                  NEXT FIELD sfs07b
               END IF
               #---> Add No.FUN-AA0077
               IF NOT s_chk_ware(tm.sfs07b) THEN  #检查仓库是否属于当前门店
                  NEXT FIELD sfs07b
               END IF
               #---> End Add No.FUN-AA0077
            ELSE
               LET tm.sfs07b=' '
            END IF
           #FUN-D40103 -------Begin--------
            IF NOT p520_ime_chk(tm.sfs07b,tm.sfs08b,'W') THEN  #TQC-D50127 
               NEXT FIELD sfs08b
            END IF
           #FUN-D40103 -------End----------
 
         AFTER FIELD sfs08b #儲位
            IF NOT cl_null(tm.sfs08b) THEN
         #FUN-D40103 -------Begin--------
              # SELECT ime01 INTO g_buf 
              #   FROM ime_file
              #  WHERE ime01=tm.sfs07b  
              #    AND ime02=tm.sfs08b
              #    AND ime04='W'
              # IF SQLCA.sqlcode THEN
              #     LET tm.sfs08b=' '
              #     CALL cl_err('sel ime:','mfg1100',0) NEXT FIELD sfs08b
              # END IF
         #FUN-D40103 -------End---------
            ELSE
               LET tm.sfs08b=' '
            END IF
           #FUN-D40103 -------Begin--------
            IF NOT p520_ime_chk(tm.sfs07b,tm.sfs08b,'W') THEN   #TQC-D50127
               NEXT FIELD sfs08b
            END IF
           #FUN-D40103 -------End----------
 
         AFTER FIELD sfp01b #領料單號
            IF cl_null(tm.sfp01b) THEN 
               #此欄位不可空白, 請輸入資料!
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfp01b 
            END IF
            LET l_t1 = tm.sfp01b
        #No.FUN-550067 --start--                                                                                                    
            CALL s_check_no("asf",l_t1,"","3","","","")                                                                          
            RETURNING li_result,tm.sfp01b                                                                                            
            DISPLAY BY NAME tm.sfp01b                                                                                                
            IF (NOT li_result) THEN                 
#           CALL s_mfgslip(l_t1,'asf','3')
#           IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
#              CALL cl_err(l_t1,g_errno,0) 
         #No.FUN-550067 ---end--- 
               NEXT FIELD sfp01b
            END IF
           #TQC-AC0293 -------------add start---------
            SELECT smy73,smy72 INTO l_smy73,l_smy72 FROM smy_file     #TQC-C90081 add smy72
             WHERE smyslip = l_t1
            IF l_smy73 = 'Y' THEN
              CALL cl_err('','asf-874',0)
              NEXT FIELD sfp01b
           END IF
           #TQC-AC0293 -------------add end------------
         #TQC-C90081--ADD--
           IF l_smy72 <> '3' THEN 
              CALL cl_err('','mfg0015',1)
              NEXT FIELD sfp01b
           END IF
         #TQC-C90081--ADD--
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sfa03) #料號
#                 CALL q_ima(0,0,tm.sfa03) RETURNING tm.sfa03
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfa03 )
                #FUN-940008---Begin
                # CALL cl_init_qry_var()
                # LET g_qryparam.form = "q_sfa11"   #MOD-6B0120 modify ""q_ima"
                # LET g_qryparam.default1 = tm.sfa03
                ##MOD-6B0120-begin-add
                # LET g_qryparam.arg1=tm.sfb01b
                # LET g_qryparam.default2 = tm.sfa08  
                # LET g_qryparam.default3 = tm.sfa12  
                ##MOD-6B0120-end-add
                ##CALL cl_create_qry() RETURNING tm.sfa03                     #TQC-6C0075 mark
#                 CALL cl_create_qry() RETURNING tm.sfa03,tm.sfa08,tm.sfa12   #TQC-6C0075
                  LET li_where = " AND sfa01 = '",tm.sfb01b,"'"
                  CALL q_short_qty(FALSE,TRUE,'',tm.sfa03,li_where,'1')
                       RETURNING tm.sfb01b,tm.sfa03,tm.sfa08,tm.sfa12,l_sfa27,tm.sfa012,tm.sfa013    #FUN-A60081 add sfa012,sfa013
#               #  CALL FGL_DIALOG_SETBUFFER( tm.sfa03 )
                #FUN-940008---End
                  DISPLAY BY NAME tm.sfa03
                  DISPLAY BY NAME tm.sfa08  #MOD-6B0120 add
                  DISPLAY BY NAME tm.sfa12  #MOD-6B0120 add
                  DISPLAY BY NAME tm.sfa012 #FUN-A60081
                  DISPLAY BY NAME tm.sfa013 #FUN-A60081
                  NEXT FIELD sfa03
               WHEN INFIELD(sfa12) #單位
#                 CALL q_gfe(3,10,tm.sfa12) RETURNING tm.sfa12
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfa12 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = tm.sfa12
                  CALL cl_create_qry() RETURNING tm.sfa12
#                  CALL FGL_DIALOG_SETBUFFER( tm.sfa12 )
                  DISPLAY BY NAME tm.sfa12
                  NEXT FIELD sfa12
               WHEN INFIELD(sfa08) #作業編號
                     CALL q_ecd(FALSE,TRUE,tm.sfa08)
                          RETURNING tm.sfa08
#                     CALL FGL_DIALOG_SETBUFFER( tm.sfa08 )
                      DISPLAY BY NAME tm.sfa08        #No.MOD-490371
                     NEXT FIELD sfa08
               WHEN INFIELD(sfp01a) #查詢單据 退料單號
#                  LET g_t1=tm.sfp01a[1,4]
                  LET g_t1=tm.sfp01a[1,g_doc_len+1]  #No.FUN-550067
                  LET g_sql = " (smy73 <> 'Y' OR smy73 IS NULL) "           #TQC-AC0293
                  LET g_sql = g_sql," AND smy72 = '8'"                      #TQC-C90081
                  CALL smy_qry_set_par_where(g_sql)                         #TQC-AC0293
                 #CALL q_smy(FALSE,FALSE,g_t1,'asf','4') RETURNING g_t1  #TQC-670008
                  CALL q_smy(FALSE,FALSE,g_t1,'ASF','4') RETURNING g_t1  #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                  LET tm.sfp01a[1,4]=g_t1
                  LET tm.sfp01a=g_t1              #No.FUN-550067
                  DISPLAY BY NAME tm.sfp01a 
                  NEXT FIELD sfp01a
                  INITIALIZE g_t1  to NULL
               WHEN INFIELD(sfp01b) #查詢單据 領料單號
#                  LET g_t1=tm.sfp01b[1,4]
                  LET g_t1=tm.sfp01b[1,g_doc_len+1]  #No.FUN-550067
                  LET g_sql = " (smy73 <> 'Y' OR smy73 IS NULL) "           #TQC-AC0293
                  LET g_sql = g_sql," AND smy72 = '3'"                      #TQC-C90081
                  CALL smy_qry_set_par_where(g_sql)                         #TQC-AC0293
                  #CALL q_smy(FALSE,FALSE,g_t1,'asf','3') RETURNING g_t1 #TQC-670008
                  CALL q_smy(FALSE,FALSE,g_t1,'ASF','3') RETURNING g_t1  #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                  LET tm.sfp01b[1,4]=g_t1
                  LET tm.sfp01b=g_t1              #No.FUN-550067
                  DISPLAY BY NAME tm.sfp01b 
                  NEXT FIELD sfp01b
                  INITIALIZE g_t1  to NULL
               WHEN INFIELD(sfb01b) #目的工單
#                 CALL q_sfb(0,0,tm.sfb01b,'4567') RETURNING tm.sfb01b
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfb01b )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb02"
                  LET g_qryparam.default1 = tm.sfb01b
                  LET g_qryparam.arg1 = "4567"
                  CALL cl_create_qry() RETURNING tm.sfb01b
#                  CALL FGL_DIALOG_SETBUFFER( tm.sfb01b )
                  DISPLAY BY NAME tm.sfb01b 
                  NEXT FIELD sfb01b
               WHEN INFIELD(sfs07a)
#                 CALL q_imd(0,0,tm.sfs07a,'S') RETURNING tm.sfs07a
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfs07a )
                 #Mod No.FUN-AA0077
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd"
                 #LET g_qryparam.default1 = tm.sfs07a
                 ##LET g_qryparam.where = " imd10 = 'S' "
                 #LET g_qryparam.arg1     = 'S'        #倉庫類別 #MOD-4A0213
                 #CALL cl_create_qry() RETURNING tm.sfs07a
                  CALL q_imd_1(FALSE,TRUE,tm.sfs07a,"S",g_plant,"","")  #只能开当前门店的
                       RETURNING tm.sfs07a
                 #End Mod No.FUN-AA0077
#                  CALL FGL_DIALOG_SETBUFFER( tm.sfs07a )
                  DISPLAY tm.sfs07a TO FORMONLY.sfs07a
                  NEXT FIELD sfs07a
               WHEN INFIELD(sfs07b)
#                 CALL q_imd(0,0,tm.sfs07b,'W') RETURNING tm.sfs07b
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfs07b )
                 #Mod No.FUN-AA0077
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd"
                 #LET g_qryparam.default1 = tm.sfs07b
                 ##LET g_qryparam.arg1 = " imd10 = 'W' "
                 #LET g_qryparam.arg1     = 'W'        #倉庫類別 #MOD-4A0213
                 #CALL cl_create_qry() RETURNING tm.sfs07b
                  CALL q_imd_1(FALSE,TRUE,tm.sfs07b,"W",g_plant,"","")  #只能开当前门店的
                       RETURNING tm.sfs07b
                 #End Mod No.FUN-AA0077
#                  CALL FGL_DIALOG_SETBUFFER( tm.sfs07b )
                  DISPLAY tm.sfs07b TO FORMONLY.sfs07b
                  NEXT FIELD sfs07b
               WHEN INFIELD(sfs08a)
#                 CALL q_ime(0,0,tm.sfs08a,tm.sfs07a,'S') RETURNING tm.sfs08a
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfs08a )
                 #Mod No.FUN-AA0077
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_ime"
                 #LET g_qryparam.default1 = tm.sfs08a
                 #LET g_qryparam.arg1 = tm.sfs07a   #倉庫編號 #MOD-4A0063
                 #LET g_qryparam.arg2 = 'S'         #倉庫類別 #MOD-4A0063
                 ##LET g_qryparam.where = " ime04 = 'S' "
                 #CALL cl_create_qry() RETURNING tm.sfs08a
                  CALL q_ime_1(FALSE,TRUE,tm.sfs08a,tm.sfs07a,"S",g_plant,"","","")
                       RETURNING tm.sfs08a
                 #End Mod No.FUN-AA0077
#                  CALL FGL_DIALOG_SETBUFFER( tm.sfs08a )
                  DISPLAY tm.sfs08a TO FORMONLY.sfs08a
                  NEXT FIELD sfs08a
               WHEN INFIELD(sfs08b)
#                 CALL q_ime(0,0,tm.sfs08b,tm.sfs07b,'W') RETURNING tm.sfs08b
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfs08b )
                 #Mod No.FUN-AA0077
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_ime"
                 #LET g_qryparam.default1 = tm.sfs08b
                 #LET g_qryparam.arg1 = tm.sfs07b   #倉庫編號 #MOD-4A0063
                 #LET g_qryparam.arg2 = 'W'         #倉庫類別 #MOD-4A0063
                 ##LET g_qryparam.where = " ime04 = 'W' "
                 #CALL cl_create_qry() RETURNING tm.sfs08b
                  CALL q_ime_1(FALSE,TRUE,tm.sfs08b,tm.sfs07b,"W",g_plant,"","","")
                       RETURNING tm.sfs08b
                 #Mod No.FUN-AA0077
#                  CALL FGL_DIALOG_SETBUFFER( tm.sfs08b )
                  DISPLAY tm.sfs08b TO FORMONLY.sfs08b
                  NEXT FIELD sfs08b
            END CASE
 
         ON ACTION qry_wo_short
#                 CALL q_sfa6(0,0,tm.sfb01b,tm.sfa03,tm.sfa08,tm.sfa12,'N') 
#                 RETURNING tm.sfb01b,tm.sfa03,tm.sfa08,tm.sfa12
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfb01b )
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfa03 )
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfa08 )
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfa12 )
#FUN-940008---Begin
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_sfa6"
#                 LET g_qryparam.default1 = tm.sfb01b
#                 LET g_qryparam.default2 = tm.sfa03
#                 LET g_qryparam.default3 = tm.sfa08
#                #LET g_qryparam.default4 = tm.sfa12
#                 CALL cl_create_qry() RETURNING tm.sfb01b,tm.sfa03,tm.sfa08
                  CALL q_short_qty(FALSE,TRUE,tm.sfb01b,'','','1')
                       RETURNING tm.sfb01b,tm.sfa03,tm.sfa08,tm.sfa12,l_sfa27,tm.sfa012,tm.sfa013 #FUN-A60081 add sfa012,sfa013
#FUN-940008---End                          
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfb01b )
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfa03 )
#                 CALL FGL_DIALOG_SETBUFFER( tm.sfa08 )
#FUN-940008---Begin 
#                 SELECT sfa12 INTO tm.sfa12 FROM sfa_file
#                  WHERE sfa07 > 0 AND sfa01 = tm.sfb01b
#                    AND sfa03 = tm.sfa03 AND sfa08 = tm.sfa08
                  IF cl_null(tm.sfa012) THEN LET tm.sfa012 = ' ' END IF     #FUN-A60081
                  IF cl_null(tm.sfa013) THEN LET tm.sfa013 = 0   END IF     #FUN-A60081
                  LET l_sql = " SELECT * FROM sfa_file ",
                              "  WHERE sfa01 = '",tm.sfb01b,"'",
                              "    AND sfa03 = '",tm.sfa03, "'",
                              "    AND sfa08 = '",tm.sfa08, "'",
                              "    AND sfa012 = '",tm.sfa012, "'",                 #FUN-A60081
                              "    AND sfa013 = '",tm.sfa013,"'"                   #FUN-A60081                   
                  PREPARE p520_sfa12_pre FROM l_sql
                  DECLARE p520_sfa12 CURSOR FOR p520_sfa12_pre
                  FOREACH p520_sfa12 INTO l_sfa.* 
                     CALL s_shortqty(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,
                                     l_sfa.sfa12,l_sfa.sfa27,l_sfa.sfa012,l_sfa.sfa013)   #FUN-A60081 add sfa012,sfa013
                        RETURNING g_short_qty
                     IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF
                     IF g_short_qty <= 0 THEN
                        CONTINUE FOREACH
                     END IF
                     LET tm.sfa12 = l_sfa.sfa12
                     EXIT FOREACH
                  END FOREACH
#FUN-940008---End
                  DISPLAY BY NAME tm.sfb01b,tm.sfa03,tm.sfa08,tm.sfa12
                  NEXT FIELD sfb01b
 
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(tm.sfa03) THEN 
               #此欄位不可空白, 請輸入資料!
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfa03 
            END IF
            IF cl_null(tm.sfa12) THEN
               #此欄位不可空白, 請輸入資料!
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfa12
            END IF
            IF tm.needqty <= 0    OR tm.needqty IS NULL THEN
               #本欄位之值, 不可空白或小於等於零, 請重新輸入!
               CALL cl_err('','aap-022',0)
               NEXT FIELD needqty
            END IF
            IF tm.needqty > g_sfa1.sfa05-g_sfa1.sfa06 THEN 
               #此數為未發數量,輸入的需求數量不可大於未發數量!
               CALL cl_err(g_sfa1.sfa05-g_sfa1.sfa06,'asf-942',0)
               NEXT FIELD needqty
            END IF
            IF cl_null(tm.sfa012) THEN LET tm.sfa012 = ' ' END IF    #FUN-A60081
            IF cl_null(tm.sfa013) THEN LET tm.sfa013 = 0  END IF     #FUN-A60081
            SELECT COUNT(*) INTO g_cnt
              FROM sfa_file
             WHERE sfa01 = tm.sfb01b
               AND sfa03 = tm.sfa03
               AND sfa08 = tm.sfa08
               AND sfa12 = tm.sfa12
               AND sfa012 = tm.sfa012                 #FUN-A60081
               AND sfa013 = tm.sfa013                 #FUN-A60081
            IF g_cnt = 0 THEN
               #"料件編號"+"單位"+"作業編號"並不存在於目的工單的備料中!
               CALL cl_err('','asf-751',0)
               NEXT FIELD sfb01b
            END IF
            IF cl_null(tm.sfp01a) THEN 
               #此欄位不可空白, 請輸入資料!
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfp01a 
            END IF
            IF cl_null(tm.sfp01b) THEN 
               #此欄位不可空白, 請輸入資料!
               CALL cl_err('','aap-099',0)
               NEXT FIELD sfp01b 
            END IF
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT WHILE
         END IF
 
         CALL p520_go()
         IF g_success = 'Y' THEN
           #COMMIT WORK       #NO:EXT-610018 mark
            LET g_buf = "RID=",g_sfm.sfm00,",",
                        g_x[16] CLIPPED,tm.sfp01a,",",
                        g_x[17] CLIPPED,tm.sfp01b
            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
   END WHILE
 
END FUNCTION

#FUN-D40103 --------Begin----------
FUNCTION p520_ime_chk(p_ime01,p_ime02,p_ime04)   #TQC-D50126 add p_ime04
   DEFINE p_ime01    LIKE ime_file.ime01
   DEFINE p_ime02    LIKE ime_file.ime02
   DEFINE p_ime04    LIKE ime_file.ime04
   DEFINE l_ime02    LIKE ime_file.ime02
   DEFINE l_imeacti  LIKE ime_file.imeacti
   DEFINE l_cnt      LIKE type_file.num5

   IF p_ime02 IS NOT NULL AND p_ime02 != ' ' THEN   #TQC-D50127
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ime_file
       WHERE ime01 = p_ime01
         AND ime02 = p_ime02
         AND ime04=p_ime04
      IF l_cnt = 0 THEN
         CALL cl_err(p_ime01|| ' ' ||p_ime02,'mfg1100',0)
         RETURN FALSE
      END IF
   END IF
   IF p_ime02 IS NOT NULL THEN
      LET l_imeacti = ''
      SELECT imeacti INTO l_imeacti FROM ime_file
       WHERE ime01 = p_ime01
         AND ime02 = p_ime02
      IF l_imeacti = 'N' THEN
         LET l_ime02 = p_ime02
         IF cl_null(l_ime02) THEN
            LET l_ime02 = "' '"
         END IF
         CALL cl_err_msg("","aim-507",p_ime01|| "|" ||l_ime02,0)  
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40103 --------End------------
#------------------------------------------------------------------------
FUNCTION p520_go()
 
   DEFINE l_name  LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
#  DEFINE l_order LIKE apm_file.apm08          #No.FUN-680121 VARCHAR(10)# TQC-6A0079
   #DEFINE l_sfp01 VARCHAR(11)  #No.FUN-580132
   DEFINE l_sfp01 LIKE type_file.chr20         #No.FUN-680121 VARCHAR(17)#No.FUN-580132
   DEFINE i LIKE type_file.num5                #No.FUN-680121 SMALLINT
#No.CHI-980025 --Begin
   DROP TABLE p520_rvbs
   CREATE TEMP TABLE p520_rvbs(
          rvbs03  LIKE rvbs_file.rvbs03,
          rvbs04  LIKE rvbs_file.rvbs04,
          rvbs05  LIKE rvbs_file.rvbs05,
          rvbs06  LIKE rvbs_file.rvbs06,
#         temp06  LIKE ima_file.ima26,
          temp06  LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          rvbs021 LIKE rvbs_file.rvbs021)
#No.CHI-980025 --End
 
   BEGIN WORK
   LET g_success = 'Y'
   #將來源工單與目的工單之備料資料逐筆取出並存入tmp
   CALL p520_gen_tmp()
   IF g_success = 'N' THEN 
       ROLLBACK WORK 
       RETURN 
   END IF
   CALL p520_b()
   IF g_success = 'N' THEN 
       ROLLBACK WORK 
       RETURN 
   END IF
   IF tm.a = 'Y' THEN #是否列印模擬報表(Y/N)
       CALL p520_tmp() #建立TEMP 
       CALL p520_tmp_ins()
       CALL tmp_print() 
   END IF
   IF NOT cl_sure(0,0) THEN ROLLBACK WORK RETURN END IF
   # 產生領/退料單資料 (sfp_file,sfq_file,sfs_file)
   CALL p520_gen_pqs()
   CALL s_showmsg()           #NO.FUN-710026
   COMMIT WORK    #NO:EXT-610018 add
   IF tm.b = 'Y' THEN
       # 產生領/退料單資料扣帳 (sfp_file,sfq_file,sfs_file)
       LET l_sfp01=tm.sfp01a           #TQC-610100 
       #CALL i501('2','6',l_sfp01,'')   #No.FUN-660166 #FUN-730075
      #LET g_msg="asfi520 6 '",l_sfp01,"'"," ''"  #FUN-730075移除p_link sasfi501,改用外部呼叫方式 #FUN-740187
      #CALL cl_cmdrun_wait(g_msg) #FUN-730075  #FUN-740187
       LET g_prog='asfi528'                 #No.CHI-980025 
       CALL i501sub_s('2',l_sfp01,FALSE,'N') #FUN-740187     #No.MOD-7C0119 modify
       LET g_prog='asfp520'                 #No.CHI-980025
       IF g_success='Y' THEN
          LET l_sfp01=tm.sfp01b        #TQC-610100
         #CALL i501('1','6',l_sfp01,'')  #MOD-490178  #NO:EXT-610018 modify #No.FUN-660166 #FUN-730075
         #LET g_msg="asfi520 6 '",l_sfp01,"'"," ''"  #FUN-730075移除p_link sasfi501,改用外部呼叫方式 #FUN-740187  
         #CALL cl_cmdrun_wait(g_msg) #FUN-730075     #FUN-740187  
          LET g_prog='asfi513'                 #No.CHI-980025
          CALL i501sub_s('1',l_sfp01,FALSE,'N') #FUN-740187    #No.MOD-7C0119 modify 
          LET g_prog='asfp520'                 #No.CHI-980025
       END IF
 
       UPDATE sfp_file
          SET sfp09 = 'Y',
              sfp10 = g_sfm.sfm00
        WHERE sfp01 = tm.sfp01a
           OR sfp01 = tm.sfp01b
       IF SQLCA.sqlcode THEN
           CALL cl_err('UPDATE sfp10',SQLCA.sqlcode,0)
           LET g_success = 'N'
       END IF
   END IF
 
END FUNCTION
 
#-------------------------------------------------------------------------
FUNCTION p520_gen_tmp()
   DEFINE
      i LIKE type_file.num5,                   #No.FUN-680121 SMALLINT
      l_sfa RECORD LIKE sfa_file.*,
      l_tmp_count LIKE type_file.num5          #No.FUN-680121 SMALLINT
#No.CHI-980025 --Begin
   DEFINE l_ima918         LIKE ima_file.ima918,
          l_ima921         LIKE ima_file.ima921,
          l_ima25          LIKE ima_file.ima25,
          l_img09          LIKE img_file.img09,
          l_sfp06          LIKE sfp_file.sfp06,
          l_cnt            LIKE type_file.num5,
          l_i              LIKE type_file.num5,
          l_fac            LIKE ima_file.ima55_fac,
#         l_amt            LIKE ima_file.ima26
          l_amt            LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044 
   DEFINE l_sfe     RECORD LIKE sfe_file.*,
          l_rvbs    RECORD LIKE rvbs_file.*
#No.CHI-980025 --End
 
   LET i=0
   LET g_sql="SELECT * FROM sfa_file,sfb_file",
             " WHERE sfa03 = ? ",
            #"   AND sfa08 = ? ",#NO:6968  #MOD-9B0167
             "   AND sfa12 = ? ",#NO:6968
             "   AND sfa05>0 ",
             "   AND sfa06>0 ",
             "   AND sfa01 = sfb01 ",
             "   AND sfb04 < '8'",
             "   AND sfb01 <>? ",
             "   AND ",tm.wc CLIPPED
   PREPARE p520_gen_ppp FROM g_sql
   DECLARE p520_gen_cs1 CURSOR FOR p520_gen_ppp
 
  #FOR g_cnt = 1 TO g.getLength()                   #單身 ARRAY 乾洗
  #    INITIALIZE g_sfa[g_cnt].* TO NULL
  #END FOR
   CALL g_sfa.clear()
   LET l_tmp_count = 0
  #FOREACH p520_gen_cs1 USING tm.sfa03,tm.sfa08,tm.sfa12,tm.sfb01b INTO l_sfa.*    #MOD-9B0167
   FOREACH p520_gen_cs1 USING tm.sfa03,tm.sfa12,tm.sfb01b INTO l_sfa.*             #MOD-9B0167
      SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=l_sfa.sfa01
      #NO:6968---
      SELECT COUNT(*) INTO g_cnt
        FROM snb_file
       WHERE snb01 = g_sfb.sfb01
         AND snbconf = 'N' 
      IF g_cnt >= 1 THEN
          #此張工單有做工單變更,但未發出,所以不可做挪料!
           CONTINUE FOREACH
      END IF
      #NO:6968---END
      LET i = i + 1
      LET g_sfa[i].sfa01 = l_sfa.sfa01
      LET g_sfa[i].sfa08 = l_sfa.sfa08
      LET g_sfa[i].sfa12 = l_sfa.sfa12
      LET g_sfa[i].sfa05 = l_sfa.sfa05
      LET g_sfa[i].sfa06 = l_sfa.sfa06
      LET g_sfa[i].ot_qty = g_sfb.sfb09*l_sfa.sfa161
      LET g_sfa[i].av_qty = l_sfa.sfa06 - g_sfa[i].ot_qty
      LET g_sfa[i].sfa012 = l_sfa.sfa012                            #FUN-A60081
      LET g_sfa[i].sfa013 = l_sfa.sfa013                            #FUN-A60081
      IF g_sfa[i].av_qty <=0 THEN #可移轉數為零者, 不顯示於畫面上
         INITIALIZE g_sfa[i].* TO NULL
         LET i = i - 1
         CONTINUE FOREACH
      END IF
      LET g_sfa[i].tr_qty = g_sfa[i].av_qty
      LET g_sfa[i].sfa062 = l_sfa.sfa062
      IF cl_null(tm.sfs08a) THEN LET tm.sfs08a = ' ' END IF
      IF cl_null(tm.sfs09a) THEN LET tm.sfs09a = ' ' END IF
      IF cl_null(tm.sfs08b) THEN LET tm.sfs08b = ' ' END IF
      IF cl_null(tm.sfs09b) THEN LET tm.sfs09b = ' ' END IF
      IF tm.ima108 = 'N' THEN
          LET g_sfa[i].sfa30=tm.sfs07a #倉
          LET g_sfa[i].sfa31=tm.sfs08a #儲
          LET g_sfa[i].tmp99=tm.sfs09a #批
      ELSE
          LET g_sfa[i].sfa30=tm.sfs07b #倉
          LET g_sfa[i].sfa31=tm.sfs08b #儲
          LET g_sfa[i].tmp99=tm.sfs09b #批
      END IF
      LET l_tmp_count = l_tmp_count + 1
#No.CHI-980025 --Begin
      SELECT ima25,ima918,ima921 INTO l_ima25,l_ima918,l_ima921
        FROM ima_file
       WHERE ima01 = l_sfa.sfa03
         AND imaacti = "Y"
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         DECLARE p520_sfe CURSOR FOR
          SELECT sfe_file.*,sfp06 FROM sfe_file,sfp_file
           WHERE sfe01=g_sfa[i].sfa01
             AND sfe07=l_sfa.sfa03
             AND sfp01=sfe02
             AND sfp06 IN ('1','2','3','4','5','6','D')   #FUN-C70014 add D
         FOREACH p520_sfe INTO l_sfe.*,l_sfp06
          SELECT img09 INTO l_img09 FROM img_file
           WHERE img01=l_sfe.sfe07 AND img02=l_sfe.sfe08
             AND img03=l_sfe.sfe09 AND img04=l_sfe.sfe10
            CALL s_umfchk(l_sfe.sfe07,l_sfe.sfe17,l_img09)
               RETURNING l_i,l_fac
            IF l_i = 1 THEN LET l_fac = 1 END IF
            LET l_amt = 0
 
            DECLARE p520_rvbs CURSOR FOR
             SELECT * FROM rvbs_file
              WHERE rvbs01=l_sfe.sfe02
                AND rvbs02=l_sfe.sfe28
                AND rvbs08 =' '
            FOREACH p520_rvbs INTO l_rvbs.*
#因發/退料單可能會用不同庫存單位這倉庫發料,
#故先將批/序號資料統一轉換成料件庫存單位(ima25),
               IF l_ima25 <> l_img09 THEN
                  LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_fac
               END IF
               IF l_sfp06='1' OR l_sfp06='2' OR l_sfp06='3' OR l_sfp06='D' THEN                #FUN-C70014 add l_sfp06='D'
                  LET l_amt = l_rvbs.rvbs06
               ELSE
                  LET l_amt = -1*l_rvbs.rvbs06
               END IF
               SELECT COUNT(*) INTO l_cnt FROM p520_rvbs
                WHERE rvbs021= l_rvbs.rvbs021
                  AND rvbs03 = l_rvbs.rvbs03
                  AND rvbs04 = l_rvbs.rvbs04
                  AND rvbs05 = l_rvbs.rvbs05
               IF l_cnt>0 THEN
                  UPDATE p520_rvbs SET rvbs06=rvbs06+l_amt
                   WHERE rvbs021= l_rvbs.rvbs021
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs05 = l_rvbs.rvbs05
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     ERROR "INSERT INTO p520_rvbs ERROR:",sqlca.sqlcode
                     RETURN
                  END IF
               ELSE
                  INSERT INTO p520_rvbs VALUES(l_rvbs.rvbs03,l_rvbs.rvbs04,
                              l_rvbs.rvbs05,l_amt,0,l_rvbs.rvbs021)
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     ERROR "INSERT INTO p520_rvbs ERROR:",sqlca.sqlcode
                     RETURN
                  END IF
               END IF
            END FOREACH
         END FOREACH
      END IF
#No.CHI-980025 --End
   END FOREACH
   CLOSE p520_gen_cs1
   IF l_tmp_count = 0 THEN
       #無符合條件的來源工單可以挪料
       CALL cl_err('','asf-744',1)
       LET g_success = 'N'
       RETURN
   END IF
END FUNCTION
 
#-------------------------------------------------------------------------
 
FUNCTION p520_gen_pqs()
#  DEFINE l_t1      VARCHAR(4)
#  DEFINE l_sno     VARCHAR(10)
   DEFINE l_t1      LIKE oay_file.oayslip      #No.FUN-680121 VARCHAR(5)#No.FUN-550067   
   DEFINE l_sno     LIKE oea_file.oea01        #No.FUN-680121 VARCHAR(16)#No.FUN-550067  
   DEFINE l_itno,i  LIKE type_file.num5        #No.FUN-680121 SMALLINT
#  DEFINE l_qty     LIKE ima_file.ima26        #No.FUN-680121 DEC(15,3)
   DEFINE l_qty     LIKE type_file.num15_3     ##GP5.2  #NO.FUN-A20044
   DEFINE l_sfs RECORD LIKE sfs_file.*
   DEFINE l_sfsi RECORD LIKE sfsi_file.*       #FUN-B70074
   DEFINE l_yymm    LIKE type_file.chr4        #No.FUN-680121 VARCHAR(4)
   DEFINE li_result   LIKE type_file.num5      #No.FUN-550067         #No.FUN-680121 SMALLINT
   #No.FUN-580132  --begin
   DEFINE  l_ima25      LIKE ima_file.ima25
   DEFINE  l_ima55      LIKE ima_file.ima55
   DEFINE  l_ima906     LIKE ima_file.ima906
   DEFINE  l_ima907     LIKE ima_file.ima907
   DEFINE  l_factor     LIKE img_file.img21 
   DEFINE  l_cnt        LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_sfpconf   LIKE sfp_file.sfpconf          #No.MOD-730042 add
   #No.FUN-580132  --end   
#No.CHI-980025 --Begin
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_img09    LIKE img_file.img09
   DEFINE l_rvbs022  LIKE rvbs_file.rvbs022
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_fac      LIKE ima_file.ima55_fac
   DEFINE l_rvbs  RECORD LIKE rvbs_file.*
   DEFINE l_rvbs1 RECORD
          rvbs03     LIKE rvbs_file.rvbs03,
          rvbs04     LIKE rvbs_file.rvbs04,
          rvbs05     LIKE rvbs_file.rvbs05,
          rvbs06     LIKE rvbs_file.rvbs06,
#         temp06     LIKE ima_file.ima26,
          temp06     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044   
          rvbs021    LIKE rvbs_file.rvbs021
        END RECORD
#No.CHI-980025 --End
   DEFINE l_sfpmksg   LIKE sfp_file.sfpmksg   #FUN-AB0001 add
   DEFINE l_sfp15     LIKE sfp_file.sfp15     #FUN-AB0001 add
   DEFINE l_sfp16     LIKE sfp_file.sfp16     #FUN-AB0001 add 
   DEFINE l_cn        LIKE type_file.num5     #MOD-BA0112
   
   INITIALIZE g_sfm.* TO NULL
   LET g_sfm.sfm03=g_today
   LET l_yymm[1,2] = (YEAR(g_sfm.sfm03) MOD 100) USING '&&'
   LET l_yymm[3,4] = MONTH(g_sfm.sfm03) USING '&&'
   SELECT MAX(sfm00) INTO g_sfm.sfm00 FROM sfm_file
      WHERE sfm00[1,4]=l_yymm
   IF STATUS THEN
      LET g_sfm.sfm00=l_yymm,"0001"
   ELSE
      IF g_sfm.sfm00 IS NULL THEN LET g_sfm.sfm00[5,8]='0000' END IF
      LET g_sfm.sfm00=l_yymm,(g_sfm.sfm00[5,8]+1) USING '&&&&'
   END IF
   INITIALIZE g_sfn.* TO NULL
   LET g_sfn.sfn01=g_sfm.sfm00
   LET g_sfn.sfn02=0
       #No.FUN-550067 --start--                                                                                                     
        CALL s_auto_assign_no("asf",tm.sfp01a,TODAY,"","","","","","")                                                               
        RETURNING li_result,l_sno                                                                                                   
      IF (NOT li_result) THEN    
#  IF cl_null(tm.sfp01a[5,10]) THEN
#     LET l_t1 = tm.sfp01a[1,3]
#     CALL s_smyauno(l_t1,TODAY) RETURNING g_i,l_sno #產生退料單據號碼
#     IF g_i THEN
      #No.FUN-550067 ---end---   
         LET g_success = 'N'
         RETURN
      END IF
      LET  tm.sfp01a = l_sno
#   END IF     #No.FUN-550067
 
   #-------------No.MOD-730042 add
    IF tm.b = 'Y' THEN
       LET l_sfpconf = 'Y'
    ELSE 
       LET l_sfpconf = 'N'
    END IF
   #-------------No.MOD-730042 end
    #FUN-AB0001--add---str---
    IF tm.b = 'Y' THEN
        LET l_sfpmksg = 'N'          #是否簽核
        LET l_sfp15 = '1'            #簽核狀況
    ELSE
        LET l_sfpmksg = g_smy.smyapr #是否簽核
        LET l_sfp15 = '0'            #簽核狀況
    END IF
    LET l_sfp16 = g_user         #申請人
    #FUN-AB0001--add---end---

    INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp08,     #No.MOD-470041
                         sfp09,sfp10,sfpuser,sfpgrup,sfpmodu,sfpdate,sfpconf, #FUN-660106
                         sfpmksg,sfp15,sfp16,                                 #FUN-AB0001 add
                         sfpplant,sfplegal,sfporiu,sfporig) #FUN-980008 add
                 VALUES (tm.sfp01a,TODAY,TODAY,'N','N','8',null,null,'N',NULL,g_user,g_grup,NULL,NULL,l_sfpconf, #FUN-660106   #No.MOD-730042 modify
                         l_sfpmksg,l_sfp15,l_sfp16,                           #FUN-AB0001 add
                         g_plant,g_legal, g_user, g_grup)   #FUN-980008 add   #No.FUN-980030 10/01/04  insert columns oriu, orig
    IF STATUS THEN
      LET g_success = 'N'
      RETURN g_success
    END IF
#  SELECT MIN(sfa08) INTO g_msfa08 FROM sfa_file WHERE sfa01 = g_sfb01a
#  IF g_msfa08 IS NULL THEN LET g_msfa08 = 0 END IF
 
 
   INITIALIZE l_sfs.* TO NULL
   LET l_sfs.sfs01 = tm.sfp01a
   LET g_tqty = 0
   LET l_itno = 0
   FOR i = 1 to g_arrcnt
      IF cl_null(g_sfa[i].sfa01) THEN
         EXIT FOR
      END IF
      IF g_sfa[i].tr_qty <= 0 THEN
         CONTINUE FOR
      END IF
      INITIALIZE l_sfs.* TO NULL   #MOD-980075
      LET l_sfs.sfs01 = tm.sfp01a  #MOD-980075
      LET l_itno = l_itno + 1
      LET l_sfs.sfs02 = l_itno
      LET l_sfs.sfs03 = g_sfa[i].sfa01
      LET l_sfs.sfs04 = tm.sfa03 #料號
      LET l_sfs.sfs05 = g_sfa[i].tr_qty #數量
      LET l_sfs.sfs06 = g_sfa[i].sfa12  #單位
      LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06) #FUN-BB0084
      LET l_sfs.sfs07 = g_sfa[i].sfa30  #倉庫
      LET l_sfs.sfs08 = g_sfa[i].sfa31  #儲位
      LET l_sfs.sfs09 = g_sfa[i].tmp99  #批號
      LET l_sfs.sfs10 = g_sfa[i].sfa08  #作業編號
      LET l_sfs.sfs012 = g_sfa[i].sfa012      #FUN-A60081
      LET l_sfs.sfs013 = g_sfa[i].sfa013      #FUN-A60081
      #No.FUN-580132  --begin
      IF g_sma.sma115 = 'Y' THEN
         SELECT ima25,ima55,ima906,ima907 INTO l_ima25,l_ima55,l_ima906,l_ima907
           FROM ima_file WHERE ima01=l_sfs.sfs04
         IF cl_null(l_ima55) THEN LET l_ima55 = l_ima25 END IF
         LET l_sfs.sfs30=l_sfs.sfs06
         LET l_factor = 1
         CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_ima55) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET l_sfs.sfs31=l_factor
         LET l_sfs.sfs32=l_sfs.sfs05
         LET l_sfs.sfs33=l_ima907
         LET l_factor = 1
         CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,l_ima55) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET l_sfs.sfs34=l_factor
         LET l_sfs.sfs35=0
         IF l_ima906 = '3' THEN
            LET l_factor = 1
            CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_sfs.sfs33) 
                 RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN
               LET l_factor = 1
            END IF
            LET l_sfs.sfs35=l_sfs.sfs32*l_factor
            LET l_sfs.sfs35=s_digqty(l_sfs.sfs35,l_sfs.sfs33)    #FUN-BB0084
         END IF
         IF l_ima906 = '1' THEN
            LET l_sfs.sfs33=NULL
            LET l_sfs.sfs34=NULL
            LET l_sfs.sfs35=NULL
         END IF
      END IF
      #No.FUN-580132  --end  
      #MOD-BA0112--begin
      LET l_cn=0
      SELECT COUNT(*) INTO l_cn FROM sfa_file
       WHERE sfa01 = g_sfa[i].sfa01
         AND sfa03 = tm.sfa03
         AND (sfa26 = 'S' OR sfa26 = 'U' OR sfa26 = 'T')
      IF l_cn > 0 THEN
         SELECT sfa27 INTO l_sfs.sfs27
           FROM sfa_file
          WHERE sfa01 = g_sfa[i].sfa01
            AND sfa03 = tm.sfa03
            AND (sfa26 = 'S' OR sfa26 = 'U' OR sfa26 = 'T')
      END IF       
      #MOD-BA0112--end
      #No.MOD-8B0086 add --begin
      IF cl_null(l_sfs.sfs27) THEN
         LET l_sfs.sfs27 = l_sfs.sfs04
      END IF
      #No.MOD-8B0086 add --end
 
      LET l_sfs.sfsplant = g_plant #FUN-980008 add
      LET l_sfs.sfslegal = g_legal #FUN-980008 add
 
#FUN-A70125 --begin--
      IF cl_null(l_sfs.sfs012) THEN
         LET l_sfs.sfs012 = ' '
      END IF 
      IF cl_null(l_sfs.sfs013) THEN
         LET l_sfs.sfs013 = 0
      END IF 
#FUN-A70125 --end--
#FUN-C70014 add-- begin------------------
      IF cl_null(l_sfs.sfs014) THEN
         LET l_sfs.sfs014 = ' '
      END IF 
#FUN-C70014 add-- end -------------------
      #FUN-CB0087---add---str---
      IF g_aza.aza115 = 'Y' THEN
         CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,g_user,'') RETURNING l_sfs.sfs37
         IF cl_null(l_sfs.sfs37) THEN
            CALL cl_err('','aim-425',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      #FUN-CB0087---add---end--
      INSERT INTO sfs_file VALUES (l_sfs.*)
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err('ins sfs1',STATUS,1)
         RETURN
#FUN-B70074 -------------------Begin-------------------
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfsi.* TO NULL
            LET l_sfsi.sfsi01 = l_sfs.sfs01
            LET l_sfsi.sfsi02 = l_sfs.sfs02
            IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
#FUN-B70074 -------------------End---------------------
      END IF
      CALL p520_insrvbs(l_sfs.sfs04,l_sfs.sfs01,l_sfs.sfs02,     #No.CHI-980025
                        l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,'1') #No.CHI-980025
      IF tm.b = 'Y' THEN #是否自動扣帳
          LET g_sfn.sfn02=g_sfn.sfn02+1
          LET g_sfn.sfn03=g_sfa[i].sfa01
          LET g_sfn.sfn04=tm.sfa03
          LET g_sfn.sfn05=g_sfa[i].sfa08
          LET g_sfn.sfn06=g_sfa[i].sfa12
          LET g_sfn.sfn07=g_sfa[i].sfa05
          LET g_sfn.sfn08=g_sfa[i].sfa06
          LET g_sfn.sfn09=g_sfa[i].ot_qty #入庫數量
          LET g_sfn.sfn09 = s_digqty(g_sfn.sfn09,g_sfn.sfn06)   #FUN-910088--add--
          LET g_sfn.sfn10=g_sfa[i].tr_qty #移轉數量
          LET g_sfn.sfn10 = s_digqty(g_sfn.sfn10,g_sfn.sfn06)   #FUN-910088--add--
          LET g_sfn.sfn11='1'
          LET g_sfn.sfn12=g_sfa[i].sfa30  #倉庫
          LET g_sfn.sfn13=g_sfa[i].sfa31  #儲位
          LET g_sfn.sfn14=g_sfa[i].tmp99  #批號
          LET g_sfn.sfn15=g_sfa[i].sfa062 #超領量 NO:6968
 
          LET g_sfn.sfnplant = g_plant #FUN-980008 add
          LET g_sfn.sfnlegal = g_legal #FUN-980008 add
 
          INSERT INTO sfn_file VALUES(g_sfn.*)
          IF STATUS THEN
             LET g_success='N'
             CALL cl_err('ins sfn:',STATUS,1)
             EXIT FOR
          END IF
      END IF
      LET g_tqty = g_tqty + g_sfa[i].tr_qty
   END FOR
       #No.FUN-550067 --start--                                                                                                     
       #CALL s_auto_assign_no("asf",tm.sfb01b,TODAY,"","","","","","")  #NO:EXT-610018 mark                                                             
        CALL s_auto_assign_no("asf",tm.sfp01b,TODAY,"","","","","","")  #NO:EXT-610018 add
        RETURNING li_result,l_sno                                                                                                   
      IF (NOT li_result) THEN         
#  IF cl_null(tm.sfp01b[5,10]) THEN
#     LET l_t1 = tm.sfp01b[1,3]
#     CALL s_smyauno(l_t1,TODAY) RETURNING g_i,l_sno #產生領料單據號碼
         #No.FUN-550067 ---end---   
     #LET tm.sfp01b = l_sno    #NO:EXT-610018 mark
   END IF
    LET tm.sfp01b = l_sno    #NO:EXT-610018 add
   #-------------No.MOD-730042 add
    IF tm.b = 'Y' THEN
       LET l_sfpconf = 'Y'
    ELSE 
       LET l_sfpconf = 'N'
    END IF
   #-------------No.MOD-730042 end
    #FUN-AB0001--add---str---
    IF tm.b = 'Y' THEN
        LET l_sfpmksg = 'N'          #是否簽核
        LET l_sfp15 = '1'            #簽核狀況
    ELSE
        LET l_sfpmksg = g_smy.smyapr #是否簽核
        LET l_sfp15 = '0'            #簽核狀況
    END IF
    LET l_sfp16 = g_user         #申請人
    #FUN-AB0001--add---end---
    INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp08, #No.MOD-470041
                         sfp09,sfp10,sfpuser,sfpgrup,sfpmodu,sfpdate,sfpconf,
                         sfpmksg,sfp15,sfp16,               #FUN-AB0001 add
                         sfpplant,sfplegal,sfporiu,sfporig) #FUN-980008 add
                 values (tm.sfp01b,TODAY,TODAY,'N','N','3',null,null,
                         'N',NULL,g_user,g_grup,NULL,NULL,l_sfpconf,    #No.MOD-730042 modify
                         l_sfpmksg,l_sfp15,l_sfp16,                     #FUN-AB0001 add
                         g_plant,g_legal, g_user, g_grup)               #FUN-980008 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
   IF STATUS THEN LET g_success = 'N' RETURN END IF
   LET l_itno = 0
   FOR i = 1 to g_arrcnt
      IF cl_null(g_sfa[i].sfa01) THEN
         EXIT FOR
      END IF
      IF g_sfa[i].tr_qty <= 0 THEN
         CONTINUE FOR
      END IF
      LET l_itno = l_itno + 1
      INITIALIZE l_sfs.* TO NULL   #MOD-980075
      LET l_sfs.sfs01 = tm.sfp01b       #領料單號
      LET l_sfs.sfs02 = l_itno          #領料項次
      LET l_sfs.sfs03 = tm.sfb01b       #目的工單
      LET l_sfs.sfs04 = tm.sfa03         #料號
      LET l_sfs.sfs05 = g_sfa[i].tr_qty #數量
      LET l_sfs.sfs06 = g_sfa[i].sfa12  #單位
      LET l_sfs.sfs05 =s_digqty(l_sfs.sfs05,l_sfs.sfs06)   #FUN-BB0084
      LET l_sfs.sfs07 = g_sfa[i].sfa30  #倉庫
      LET l_sfs.sfs08 = g_sfa[i].sfa31  #儲位
      LET l_sfs.sfs09 = g_sfa[i].tmp99  #批號
      #NO:6968
      SELECT sfa08 
        INTO l_sfs.sfs10 
        FROM sfa_file
       WHERE sfa01 = l_sfs.sfs03   #目的工單
         AND sfa03 = l_sfs.sfs04   #料號
         AND sfa12 = l_sfs.sfs06   #單位
     #LET l_sfs.sfs10 = g_sfa[i].sfa08  #作業編號
      #No.FUN-580132  --begin
      IF g_sma.sma115 = 'Y' THEN
         SELECT ima25,ima55,ima906,ima907 INTO l_ima25,l_ima55,l_ima906,l_ima907
           FROM ima_file WHERE ima01=l_sfs.sfs04
         IF cl_null(l_ima55) THEN LET l_ima55 = l_ima25 END IF
         LET l_sfs.sfs30=l_sfs.sfs06
         LET l_factor = 1
         CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_ima55) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET l_sfs.sfs31=l_factor
         LET l_sfs.sfs32=l_sfs.sfs05
         LET l_sfs.sfs33=l_ima907
         LET l_factor = 1
         CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,l_ima55) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET l_sfs.sfs34=l_factor
         LET l_sfs.sfs35=0
         IF l_ima906 = '3' THEN
            LET l_factor = 1
            CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_sfs.sfs33) 
                 RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN
               LET l_factor = 1
            END IF
            LET l_sfs.sfs35=l_sfs.sfs32*l_factor
            LET l_sfs.sfs35=s_digqty(l_sfs.sfs35,l_sfs.sfs33)      #FUN-BB0084   
         END IF
         IF l_ima906 = '1' THEN
            LET l_sfs.sfs33=NULL
            LET l_sfs.sfs34=NULL
            LET l_sfs.sfs35=NULL
         END IF
      END IF
      #No.FUN-580132  --end  
      #MOD-BA0112--begin
      LET l_cn=0
      SELECT COUNT(*) INTO l_cn FROM sfa_file
       WHERE sfa01 = tm.sfb01b
         AND sfa03 = tm.sfa03
         AND (sfa26 = 'S' OR sfa26 = 'U' OR sfa26 = 'T')
      IF l_cn > 0 THEN
         SELECT sfa27 INTO l_sfs.sfs27
           FROM sfa_file
          WHERE sfa01 = tm.sfb01b
            AND sfa03 = tm.sfa03
            AND (sfa26 = 'S' OR sfa26 = 'U' OR sfa26 = 'T')
      END IF   
      #MOD-BA0112--end   
      #No.MOD-8B0086 add --begin
      IF cl_null(l_sfs.sfs27) THEN
         LET l_sfs.sfs27 = l_sfs.sfs04
      END IF
      #No.MOD-8B0086 add --end
 
      LET l_sfs.sfsplant = g_plant #FUN-980008 add
      LET l_sfs.sfslegal = g_legal #FUN-980008 add
      LET l_sfs.sfs012 = g_sfa[i].sfa012   #FUN-A60081
      LET l_sfs.sfs013 = g_sfa[i].sfa013   #FUN-A60081
 
#FUN-A70125 --begin--
     IF cl_null(l_sfs.sfs012) THEN
        LET l_sfs.sfs012 = ' '
     END IF 
     IF cl_null(l_sfs.sfs013) THEN
        LET l_sfs.sfs013 = 0
     END IF 
#FUN-A70125 --end--
#FUN-C70014 add-- begin------------------
      IF cl_null(l_sfs.sfs014) THEN
         LET l_sfs.sfs014 = ' '
      END IF 
#FUN-C70014 add-- end -------------------
      #FUN-CB0087---add---str---
      IF g_aza.aza115 = 'Y' THEN
         CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,g_user,'') RETURNING l_sfs.sfs37
         IF cl_null(l_sfs.sfs37) THEN
            CALL cl_err('','aim-425',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      #FUN-CB0087---add---end--
      INSERT INTO sfs_file VALUES (l_sfs.*)
      IF STATUS THEN
          LET g_success = 'N'
          CALL cl_err('ins sfs2:',STATUS,1)
          RETURN
#FUN-B70074 -----------Begin-----------------
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfsi.* TO NULL
            LET l_sfsi.sfsi01 = l_sfs.sfs01
            LET l_sfsi.sfsi02 = l_sfs.sfs02
            IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
#FUN-B70074 -----------End-------------------
      END IF
      CALL p520_insrvbs(l_sfs.sfs04,l_sfs.sfs01,l_sfs.sfs02,     #No.CHI-980025                                                     
                        l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,'2') #No.CHI-980025
   END FOR
   IF tm.b = 'Y' THEN #是否自動扣帳
       LET g_sfm.sfm04=TIME
       LET g_sfm.sfm07=tm.sfp01a
       LET g_sfm.sfm08=tm.sfb01b #目的工單
       LET g_sfm.sfm09=tm.sfp01b
       LET g_sfm.sfm10='2'
       LET g_sfm.sfmuser=g_user
       LET g_sfm.sfm16=tm.needqty
       LET g_sfm.sfmplant=g_plant    #FUN-980008 add
       LET g_sfm.sfmlegal=g_legal    #FUN-980008 add
       LET g_sfm.sfmoriu = g_user      #No.FUN-980030 10/01/04
       LET g_sfm.sfmorig = g_grup      #No.FUN-980030 10/01/04
       INSERT INTO sfm_file VALUES (g_sfm.*)
       IF STATUS THEN LET g_success = 'N' RETURN END IF
   END IF
END FUNCTION
#-------------------------------------------------------------------------
 
FUNCTION p520_b()
   DEFINE i,j,l_sl  LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_exit_sw LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
#  DEFINE l_tr_qty  LIKE ima_file.ima26          #No.FUN-680121 DEC(15,3)
   DEFINE l_tr_qty  LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
   DEFINE l_tot_arrcnt LIKE type_file.num5       #No.FUN-680121 SMALLINT
#No.CHI-980025 --Begin
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima921  LIKE ima_file.ima921
#  DEFINE l_tmp   DYNAMIC ARRAY OF LIKE ima_file.ima26
   DEFINE l_tmp   DYNAMIC ARRAY OF LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
#No.CHI-980025 --End
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW p520_bw AT p_row,p_col
        WITH FORM "asf/42f/asfp5201" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asfp5201")
   CALL cl_set_comp_visible("sfa012,sfa013", g_sma.sma541 = 'Y')     #TQC-C90080
   DISPLAY tm.sfa03 ,tm.needqty,tm.ima02,
           tm.ima021,tm.sfa12  ,tm.sfa08  TO 
               sfa03,FORMONLY.needqty,FORMONLY.ima02,
     FORMONLY.ima021,FORMONLY.sfa12_d,FORMONLY.sfa08_d
 
   WHILE TRUE
      CALL p520_sum()
#No.CHI-980025 --End
      FOR i=1 to g_arrcnt
         IF g_sfa[i].sfa01 IS NULL THEN CONTINUE FOR END IF
         IF g_sfa[i].tr_qty <= 0 THEN CONTINUE FOR END IF
         LET l_tmp[i]=0
      END FOR
#No.CHI-980025 --End
      LET l_exit_sw='y'
      INPUT ARRAY g_sfa WITHOUT DEFAULTS FROM s_sfa.*
         BEFORE ROW
            LET i = ARR_CURR()
              LET l_sl = SCR_LINE()
            LET l_tr_qty=g_sfa[i].tr_qty
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tr_qty
 
         AFTER FIELD tr_qty
            IF g_sfa[i].sfa01 IS NOT NULL THEN
              #IF g_sfa[i].tr_qty < 0 OR g_sfa[i].tr_qty > g_sfa[i].av_qty
              #   OR g_sfa[i].tr_qty IS NULL THEN
              #   LET g_sfa[i].tr_qty=l_tr_qty
              #   NEXT FIELD tr_qty
              #END IF
               #NO:6968
               IF cl_null(g_sfa[i].tr_qty) OR g_sfa[i].tr_qty < 0 THEN
                   #本欄位之值,不可空白或小於零,請重新輸入!
                   CALL cl_err('','asf-745',0)
                   NEXT FIELD tr_qty
               END IF
               IF g_sfa[i].tr_qty > g_sfa[i].av_qty + g_sfa[i].sfa062 THEN
                   #本欄位之值,不可大於可移轉數量+超領量
                   CALL cl_err('','asf-746',0)
                   NEXT FIELD tr_qty
               END IF
#No.CHI-980025 --Begin
               IF g_sfa[i].tr_qty > 0 AND l_tmp[i]<>g_sfa[i].tr_qty THEN
                  SELECT ima918,ima921 INTO l_ima918,l_ima921
                    FROM ima_file
                   WHERE ima01 = tm.sfa03
                     AND imaacti = "Y"
                  IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
                     CALL p520_b_1(tm.sfa03,g_sfa[i].sfa12,g_sfa[i].tr_qty)
                  END IF
                  LET l_tmp[i] = g_sfa[i].tr_qty
               END IF
#No.CHI-980025 --End
            END IF
         AFTER FIELD sfa30 #倉
             IF NOT cl_null(g_sfa[i].sfa01) AND g_sfa[i].tr_qty > 0 THEN
                IF g_sfa[i].tr_qty > 0 THEN
                    IF cl_null(g_sfa[i].sfa30) THEN 
                        NEXT FIELD sfa30
                    END IF
                    IF tm.ima108 = 'Y' THEN
                        SELECT imd10 FROM imd_file 
                         WHERE imd01=g_sfa[i].sfa30 
                           AND imd10 = 'W'
                            AND imdacti = 'Y' #MOD-4B0169
                        IF SQLCA.sqlcode THEN
                            CALL cl_err('sel imd:','mfg1100',0) 
                            NEXT FIELD sfa30
                        END IF
                    ELSE
                        SELECT imd10 FROM imd_file 
                         WHERE imd01=g_sfa[i].sfa30 
                           AND imd10 = 'S'
                            AND imdacti = 'Y' #MOD-4B0169
                        IF SQLCA.sqlcode THEN
                            CALL cl_err('sel imd:','mfg1100',0) 
                            NEXT FIELD sfa30
                        END IF
                    END IF
                ELSE
                    IF cl_null(g_sfa[i].sfa30) THEN 
                        NEXT FIELD av_qty
                    END IF
                END IF
             END IF
             #---> Add No.FUN-AA0077
             IF NOT cl_null(g_sfa[i].sfa30) THEN
                IF NOT s_chk_ware(g_sfa[i].sfa30) THEN  #检查仓库是否属于当前门店
                   NEXT FIELD sfa30
                END IF
             END IF
             #---> End Add No.FUN-AA0077

         AFTER FIELD sfa31 #儲
             IF cl_null(g_sfa[i].sfa31) THEN LET g_sfa[i].sfa31 = ' ' END IF
         AFTER FIELD tmp99 #批
             IF cl_null(g_sfa[i].tmp99) THEN LET g_sfa[i].tmp99 = ' ' END IF
             IF NOT cl_null(g_sfa[i].sfa01) AND g_sfa[i].tr_qty > 0 THEN
                 SELECT * FROM img_file
                  WHERE img01 = tm.sfa03       #料
                    AND img02 = g_sfa[i].sfa30 #倉
                    AND img03 = g_sfa[i].sfa31 #儲
                    AND img04 = g_sfa[i].tmp99 #批
                 IF SQLCA.sqlcode = 100 THEN
                     IF NOT cl_confirm('mfg1401') THEN NEXT FIELD sfa30 END IF
                     CALL s_add_img(tm.sfa03,g_sfa[i].sfa30,g_sfa[i].sfa31,
                                    g_sfa[i].tmp99,NULL,NULL,TODAY)     #No:MOD-960333 modify
                 END IF
             END IF
 
         AFTER ROW
            IF INT_FLAG THEN
               LET g_sfa[i].tr_qty=l_tr_qty
               EXIT INPUT
            END IF
            IF NOT cl_null(g_sfa[i].sfa01) AND g_sfa[i].tr_qty > 0 THEN
                SELECT * FROM img_file
                 WHERE img01 = tm.sfa03       #料
                   AND img02 = g_sfa[i].sfa30 #倉
                   AND img03 = g_sfa[i].sfa31 #儲
                   AND img04 = g_sfa[i].tmp99 #批
                IF SQLCA.sqlcode = 100 THEN
                    #此張來源工單的料/倉/儲/批不存在!
                    CALL cl_err(g_sfa[i].sfa01,'asf-943',0)
                    NEXT FIELD sfa30
                END IF
            END IF
            CALL p520_sum()
 
         ON ACTION CONTROLN
            LET l_exit_sw='n' CALL p520_gen_tmp() EXIT INPUT
 
         ON ACTION clear_following_qty
            LET l_exit_sw='n'
            LET j=ARR_CURR()
            FOR i=j TO g_arrcnt
               IF g_sfa[i].sfa01 IS NULL THEN CONTINUE FOR END IF
               LET g_sfa[i].tr_qty = 0
            END FOR
            EXIT INPUT
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sfa30) AND tm.ima108 = 'N'
#                 CALL q_imd(0,0,g_sfa[i].sfa30,'S') RETURNING g_sfa[i].sfa30
#                 CALL FGL_DIALOG_SETBUFFER( g_sfa[i].sfa30 )
                 #---> Mod No.FUN-AA0077
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd"
                 #LET g_qryparam.default1 = g_sfa[i].sfa30
                 ##LET g_qryparam.where = " imd10 = 'S' "
                 #LET g_qryparam.arg1     = 'S'        #倉庫類別 #MOD-4A0213
                 #CALL cl_create_qry() RETURNING g_sfa[i].sfa30
                  CALL q_imd_1(FALSE,TRUE,g_sfa[i].sfa30,"S",g_plant,"","")  #只能开当前门店的
                       RETURNING g_sfa[i].sfa30
                 #---> End Mod No.FUN-AA0077
#                  CALL FGL_DIALOG_SETBUFFER( g_sfa[i].sfa30 )
                  DISPLAY g_sfa[i].sfa30 TO s_sfa[l_sl].sfa30
                  NEXT FIELD sfa30
               WHEN INFIELD(sfa30) AND tm.ima108 = 'Y'
#                 CALL q_imd(0,0,g_sfa[i].sfa30,'W') RETURNING g_sfa[i].sfa30
#                 CALL FGL_DIALOG_SETBUFFER( g_sfa[i].sfa30 )
                 #---> Mod No.FUN-AA0077
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_imd"
                 #LET g_qryparam.default1 = g_sfa[i].sfa30
                 ##LET g_qryparam.where = " imd10 = 'W' "
                 #LET g_qryparam.arg1     = 'W'        #倉庫類別 #MOD-4A0213
                 #CALL cl_create_qry() RETURNING g_sfa[i].sfa30
                  CALL q_imd_1(FALSE,TRUE,g_sfa[i].sfa30,"W",g_plant,"","")  #只能开当前门店的
                       RETURNING g_sfa[i].sfa30
                 #---> End Mod No.FUN-AA0077
#                  CALL FGL_DIALOG_SETBUFFER( g_sfa[i].sfa30 )
                  DISPLAY g_sfa[i].sfa30 TO s_sfa[l_sl].sfa30
                  NEXT FIELD sfa30
               WHEN INFIELD(sfa31)
#                 CALL q_ime(0,0,g_sfa[i].sfa31,g_sfa[i].sfa30,'A') RETURNING g_sfa[i].sfa31
#                 CALL FGL_DIALOG_SETBUFFER( g_sfa[i].sfa31 )
                 #---> Mod No.FUN-AA0077
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_ime"
                 #LET g_qryparam.default1 = g_sfa[i].sfa31
                 #LET g_qryparam.arg1 = g_sfa[i].sfa30 #倉庫編號 #MOD-4A0063
                 #LET g_qryparam.arg2 = 'SW'           #倉庫類別 #MOD-4A0063
                 #CALL cl_create_qry() RETURNING g_sfa[i].sfa31
                  CALL q_ime_1(FALSE,TRUE,g_sfa[i].sfa31,g_sfa[i].sfa30,"",g_plant,"","","")
                       RETURNING g_sfa[i].sfa31
                 #---> End Mod No.FUN-AA0077
#                  CALL FGL_DIALOG_SETBUFFER( g_sfa[i].sfa31 )
                  DISPLAY g_sfa[i].sfa31 TO s_sfa[l_sl].sfa31
                  NEXT FIELD sfa31
           END CASE
 
         AFTER INPUT
            IF INT_FLAG THEN RETURN END IF
            LET l_tot_arrcnt = 0 #工單單一材料挪料底稿,單身資料筆數
            CALL s_showmsg_init()    #NO.FUN-710026
            FOR i=1 to g_arrcnt
                IF cl_null(g_sfa[i].sfa01) THEN EXIT FOR END IF
                IF g_sfa[i].tr_qty <= 0    THEN CONTINUE FOR END IF
                IF cl_null(g_sfa[i].sfa31) THEN LET g_sfa[i].sfa31 = ' ' END IF
                IF cl_null(g_sfa[i].tmp99) THEN LET g_sfa[i].tmp99 = ' ' END IF
                SELECT * FROM img_file
                 WHERE img01 = tm.sfa03       #料
                   AND img02 = g_sfa[i].sfa30 #倉
                   AND img03 = g_sfa[i].sfa31 #儲
                   AND img04 = g_sfa[i].tmp99 #批
                IF SQLCA.sqlcode = 100 THEN
                    #此張來源工單的料/倉/儲/批不存在!
#                   CALL cl_err(g_sfa[i].sfa01,'asf-943',0)              
                    NEXT FIELD tr_qty
                END IF
                LET l_tot_arrcnt = l_tot_arrcnt + 1
            END FOR
          #IF l_tot_arrcnt = 0 THEN
          #    #工單單一材料挪料底稿,單身資料筆數為零
          #     CALL cl_err('','asf-734',1)
          #     LET g_success = 'N'
          #     LET l_exit_sw='y' 
          #     EXIT INPUT
          # END IF
            IF g_tqty > tm.needqty THEN
               #調撥總數大於需求數量!
               CALL cl_err('total>need','asf-743',0)
               CONTINUE INPUT
            END IF
            IF g_tqty = 0 THEN
                #移轉總數量不可為零
                CALL cl_err('','asf-736',1)
                CONTINUE INPUT
            ELSE
                IF g_tqty < tm.needqty THEN
                   CALL cl_getmsg('asf-733',g_lang) RETURNING g_msg
                   LET g_chr = ' '
                   WHILE g_chr NOT MATCHES "[12]" OR g_chr IS NULL
            LET INT_FLAG = 0 
                      PROMPT g_msg CLIPPED FOR CHAR g_chr
                         ON IDLE g_idle_seconds
                            CALL cl_on_idle()
                         #MOD-860081------add-----str---
                         ON ACTION about         
                            CALL cl_about()      
                         
                         ON ACTION controlg      
                            CALL cl_cmdask()     
                         
                         ON ACTION help          
                            CALL cl_show_help()  
                         #MOD-860081------add-----end---
                      
                      END PROMPT
                   END WHILE
                   IF g_chr='1' THEN #AUTO CHANGE NEED QTY
                     #LET tm.needqty = g_tqty
                      DISPLAY tm.needqty TO FORMONLY.needqty
                   ELSE
                      CONTINUE INPUT
                   END IF
                END IF
            END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("grid01","AUTO")                                                                                      
#NO.FUN-6B0031--END      
      END INPUT
      IF l_exit_sw='y' THEN EXIT WHILE END IF
   END WHILE
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      #<DEL> 放棄本作業
      CALL cl_err('','mfg1016',1)
      CLOSE WINDOW p520_bw
      RETURN
   END IF
   CALL p520_sum()
   CLOSE WINDOW p520_bw
END FUNCTION
 
FUNCTION p520_sum()
   DEFINE i LIKE type_file.num5          #No.FUN-680121 SMALLINT
   LET g_tqty = 0
   FOR i=1 to g_arrcnt
      IF g_sfa[i].sfa01 IS NULL THEN CONTINUE FOR END IF
      IF g_sfa[i].tr_qty <= 0 THEN CONTINUE FOR END IF
      LET g_tqty = g_tqty + g_sfa[i].tr_qty
   END FOR
   DISPLAY g_tqty TO FORMONLY.tqty
END FUNCTION
 
FUNCTION p520_tmp()
   DROP TABLE p520_tmp
  #No.FUN-680121-BEGIN
   CREATE TEMP TABLE p520_tmp (
          sfa01 LIKE sfa_file.sfa01,
          sfa08 LIKE sfa_file.sfa08,
          sfa12 LIKE sfa_file.sfa12,
          sfa05 LIKE sfa_file.sfa05,
          sfa06 LIKE sfa_file.sfa06,
#         ot_qty LIKE ima_file.ima26,
          ot_qty LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044 
#         av_qty LIKE ima_file.ima26,
#         tr_qty LIKE ima_file.ima26,
          av_qty LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tr_qty LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          sfa062 LIKE sfa_file.sfa062,
          sfa30  LIKE sfa_file.sfa30,
          sfa31  LIKE sfa_file.sfa31,
          tmp99  LIKE aag_file.aag01,
          sfa012 LIKE sfa_file.sfa012,      #FUN-A60081 
          sfa013 LIKE sfa_file.sfa013)      #FUN-A60081
  #No.FUN-680121-END        
END FUNCTION
 
FUNCTION tmp_print()
   DEFINE sr RECORD
          sfa01 LIKE sfa_file.sfa01,        #No.FUN-680121 VARCHAR(10)
          sfa08 LIKE sfa_file.sfa08,        #No.FUN-680121 VARCHAR(06)
          sfa12 LIKE sfa_file.sfa12,        #No.FUN-680121 VARCHAR(04)
          sfa05 LIKE sfa_file.sfa05,        #No.FUN-680121 dec(15,3)
          sfa06 LIKE sfa_file.sfa06,        #No.FUN-680121 dec(15,3)
#         ot_qty LIKE ima_file.ima26,       #No.FUN-680121 dec(15,3)
#         av_qty LIKE ima_file.ima26,       #No.FUN-680121 dec(15,3)
#         tr_qty LIKE ima_file.ima26,       #No.FUN-680121 dec(15,3)
          ot_qty LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          av_qty LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          tr_qty LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          sfa062 LIKE sfa_file.sfa062,      #No.FUN-680121 dec(15,3)
          sfa30  LIKE sfa_file.sfa30,       #No.FUN-680121 VARCHAR(10)
          sfa31  LIKE sfa_file.sfa31,       #No.FUN-680121 VARCHAR(10)
          tmp99  LIKE aag_file.aag01,       #No.FUN-680121 VARCHAR(24)
          sfa012 LIKE sfa_file.sfa012,      #No.FUN-A60081 VARCHAR(10)
          sfa013 LIKE sfa_file.sfa013       #No.FUN-A60081 NUMBER(5)     
         END RECORD
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
# External(Disk) file name
        l_za05          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
        l_chr           LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
    CALL cl_outnam(g_prog) RETURNING l_name
    #FUN-A60081 -------------------start---------------------
    IF g_sma.sma541 = 'Y' THEN
       LET g_zaa[38].zaa06 = 'N'
       LET g_zaa[39].zaa06 = 'N'
    ELSE
       LET g_zaa[38].zaa06 = 'Y'
       LET g_zaa[39].zaa06 = 'Y'
    END IF 
    #FUN-A60081 -------------------end----------------------   
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     #MOD-490178
    #--
    LET g_sql="SELECT * FROM p520_tmp "           # 組合出 SQL 指令
 
    PREPARE p520_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p520_curo CURSOR FOR p520_p1   
         
 
    START REPORT p520_rep TO l_name
    CALL s_showmsg_init()    #NO.FUN-710026
    FOREACH p520_curo INTO sr.*
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end 
 
        IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)               #NO.FUN-710026
            CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)       #NO.FUN-710026
            LET g_success = 'N'
#           EXIT FOREACH                                          #NO.FUN-710026
            CONTINUE FOREACH                                      #NO.FUN-710026
        END IF
        OUTPUT TO REPORT p520_rep(sr.*)
    END FOREACH
#NO.FUN-710026----begin 
    IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
    END IF 
#NO.FUN-710026----end
 
    FINISH REPORT p520_rep
 
    CLOSE p520_curo
    ERROR ""
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
REPORT p520_rep(sr)
    #MOD-490178
   DEFINE sr RECORD
          sfa01 LIKE sfa_file.sfa01,        #No.FUN-680121 VARCHAR(10)
          sfa08 LIKE sfa_file.sfa08,        #No.FUN-680121 VARCHAR(06)
          sfa12 LIKE sfa_file.sfa12,        #No.FUN-680121 VARCHAR(04)
          sfa05 LIKE sfa_file.sfa05,        #No.FUN-680121 dec(15,3)
          sfa06 LIKE sfa_file.sfa06,        #No.FUN-680121 dec(15,3)
#         ot_qty LIKE ima_file.ima26,       #No.FUN-680121 dec(15,3)
#         av_qty LIKE ima_file.ima26,       #No.FUN-680121 dec(15,3)
#         tr_qty LIKE ima_file.ima26,       #No.FUN-680121 dec(15,3)
          ot_qty LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          av_qty LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          tr_qty LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          sfa062 LIKE sfa_file.sfa062,      #No.FUN-680121 dec(15,3)
          sfa30  LIKE sfa_file.sfa30,       #No.FUN-680121 VARCHAR(10)
          sfa31  LIKE sfa_file.sfa31,       #No.FUN-680121 VARCHAR(10)
          tmp99  LIKE aag_file.aag01,       #No.FUN-680121 VARCHAR(24)
          sfa012 LIKE sfa_file.sfa012,      #No.FUN-A60081
          sfa013 LIKE sfa_file.sfa013       #No.FUN-A60081 
         END RECORD
    DEFINE
    #--
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
        l_chr           LIKE type_file.chr1   ,        #No.FUN-680121 VARCHAR(1)
#       l_qty           LIKE ima_file.ima26            #No.FUN-680121 dec(15,3)
        l_qty           LIKE type_file.num15_3         ###GP5.2  #NO.FUN-A20044 
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sfa01,sr.sfa08
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     
            PRINT g_dash
            #----
            PRINT g_x[10] CLIPPED,tm.sfb01b CLIPPED               #目的工單
            PRINT g_x[11] CLIPPED,tm.needqty USING '########.&&&' #需求數量
            PRINT g_x[12] CLIPPED,tm.sfa03                        #料件編號
            PRINT g_x[13] CLIPPED,tm.ima02                        #品名
            PRINT g_x[14] CLIPPED,tm.ima021                       #品名
            PRINT g_x[18] CLIPPED,tm.sfa12                        #單位
            IF g_sma.sma541 = 'Y' THEN                            #TQC-C90080
               PRINT g_x[20] CLIPPED,tm.sfa012                    #製程段號 #FUN-A60081
               PRINT g_x[21] CLIPPED,tm.sfa013                    #製程序   #FUN-A60081
            ELSE                                                  #TQC-C90080
               PRINT ' '                                          #TQC-C90080
               PRINT ' '                                          #TQC-C90080
            END IF                                                #TQC-C90080
            PRINT g_x[19] CLIPPED,tm.sfa08                        #作業編號
            PRINT ' '
            #----
            PRINT g_x[31],g_x[38],g_x[39],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37] #FUN-A60081
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
        ON EVERY ROW
# 來源工單   作業  單位    倉庫       儲位       批號    擬轉數量
#---------- ------ ---- ---------- ---------- ---------- ---------
#sfa01xxxxx sfa08x fa12 sfa30xxxxx sfa31xxxxx tmp99xxxxx tr_qtyxxx
            PRINT COLUMN g_c[31],sr.sfa01,
                  COLUMN g_c[38],sr.sfa012,                    #FUN-A60081
                  COLUMN g_c[39],sr.sfa013,                    #FUN-A60081  
                  COLUMN g_c[32],sr.sfa08,
                  COLUMN g_c[33],sr.sfa12,
                  COLUMN g_c[34],sr.sfa30,
                  COLUMN g_c[35],sr.sfa31, 
                  COLUMN g_c[36],sr.tmp99,
                  COLUMN g_c[37],cl_numfor(sr.tr_qty,37,1) 
        ON LAST ROW
            LET l_trailer_sw = 'n'
            PRINT COLUMN g_c[36],g_x[15] CLIPPED,
                  COLUMN g_c[37],cl_numfor(SUM(sr.tr_qty),37,1)
            
        PAGE TRAILER
            PRINT g_dash
            PRINT g_x[21] CLIPPED
            IF l_trailer_sw = 'y' THEN
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            END IF
END REPORT
FUNCTION p520_tmp_ins()
  DEFINE i LIKE type_file.num5          #No.FUN-680121 SMALLINT
    CALL s_showmsg_init()    #NO.FUN-710026
    FOR i = 1 TO g_arrcnt
#NO.FUN-710026-----begin add
       IF g_success='N' THEN                                                                                                          
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                    
#NO.FUN-710026-----end
        IF cl_null(g_sfa[i].sfa01) OR 
           g_sfa[i].tr_qty <= 0 THEN
           CONTINUE FOR
        END IF
        INSERT INTO p520_tmp VALUES(g_sfa[i].sfa01 ,g_sfa[i].sfa08,
                                    g_sfa[i].sfa12 ,g_sfa[i].sfa05,
                                    g_sfa[i].sfa06 ,g_sfa[i].ot_qty,
                                    g_sfa[i].av_qty, g_sfa[i].tr_qty,
                                    g_sfa[i].sfa062, g_sfa[i].sfa30 ,
                                    g_sfa[i].sfa31,g_sfa[i].tmp99,g_sfa[i].sfa012,g_sfa[i].sfa013)   #FUN-A60081 add sfa012,sfa013
        IF SQLCA.sqlcode THEN
#           LET g_success = 'N'                                      #NO.FUN-710026
#           CALL cl_err('ins p520_tmp:err',SQLCA.sqlcode,0)          #NO.FUN-710026
            CALL s_errmsg('','','ins p520_tmp:err',SQLCA.sqlcode,0)  #NO.FUN-710026
            LET g_success = 'N'                                      #NO.FUN-710026
#           RETURN                                                   #NO.FUN-710026
            CONTINUE FOR                                             #NO.FUN-710026 
        END IF
    END FOR
#NO.FUN-710026----begin 
  IF g_totsuccess="N" THEN                                                                                                         
           LET g_success="N"                                                                                                             
    END IF 
#NO.FUN-710026----end
 
END FUNCTION
#No.CHI-980025 --Begin
FUNCTION p520_b_1(p_ima01,p_gfe01,p_tmp06)
   DEFINE p_ima01           LIKE ima_file.ima01
   DEFINE p_gfe01           LIKE gfe_file.gfe01
#  DEFINE p_tmp06           LIKE ima_file.ima26
   DEFINE p_tmp06           LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE l_rvbs1    DYNAMIC ARRAY OF RECORD
              rvbs00        LIKE rvbs_file.rvbs00,
              rvbs01        LIKE rvbs_file.rvbs01,
              rvbs02        LIKE rvbs_file.rvbs02,
              rvbs022       LIKE rvbs_file.rvbs022,
              rvbs09        LIKE rvbs_file.rvbs09
            END RECORD
   DEFINE l_rvbs     DYNAMIC ARRAY OF RECORD
              rvbs03        LIKE rvbs_file.rvbs01,
              rvbs04        LIKE rvbs_file.rvbs03,
              rvbs05        LIKE rvbs_file.rvbs05,
              rvbs06        LIKE rvbs_file.rvbs06,
#             temp06        LIKE ima_file.ima26
              temp06        LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
            END RECORD
   DEFINE l_temp     RECORD
              rvbs021       LIKE rvbs_file.rvbs021,
              ima02         LIKE ima_file.ima02,
              ima021        LIKE ima_file.ima021,
              ima25         LIKE ima_file.ima25,
              fac           LIKE ima_file.ima55_fac,
#             qty           LIKE ima_file.ima26
              qty           LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
            END RECORD
#  DEFINE l_qty             LIKE ima_file.ima26
   DEFINE l_qty             LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE i                 LIKE type_file.num5
   DEFINE l_i               LIKE type_file.num5
   DEFINE l_rec_b           LIKE type_file.num5
   LET i = 1
   OPEN WINDOW asfp5101_1 WITH FORM "asf/42f/asfp5101_1"
   CALL cl_ui_locale("asfp5101_1")
   SELECT ima02,ima021,ima25
     INTO l_temp.ima02,l_temp.ima021,l_temp.ima25
     FROM ima_file
    WHERE ima01 = p_ima01
   CALL s_umfchk(p_ima01,p_gfe01,l_temp.ima25)
   RETURNING l_i,l_temp.fac
   IF l_i = 1 THEN LET l_temp.fac = 1 END IF
   LET l_temp.qty = p_tmp06 * l_temp.fac
   LET l_temp.rvbs021 = p_ima01
   DISPLAY BY NAME l_temp.rvbs021,l_temp.ima02,l_temp.ima021,
                   l_temp.ima25,l_temp.fac,l_temp.qty
   DECLARE p520_b_rvbs CURSOR FOR
    SELECT * FROM p520_rvbs
     WHERE rvbs021 = p_ima01
   FOREACH p520_b_rvbs INTO l_rvbs[i].*
      LET i = i+1
   END FOREACH
   LET l_rec_b = i-1
   CALL l_rvbs.deleteElement(i)
      INPUT ARRAY l_rvbs WITHOUT DEFAULTS FROM s_rvbs.*
        ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
         BEFORE ROW
            LET i = ARR_CURR()
            CALL cl_show_fld_cont()
            NEXT FIELD temp06
         AFTER FIELD temp06
            IF l_rvbs[i].temp06 < 0 THEN
               CALL cl_err('','asf-864',0)
               NEXT FIELD temp06
            END IF
            IF l_rvbs[i].temp06 > l_rvbs[i].rvbs06 THEN
               CALL cl_err('','asf-865',0)
               NEXT FIELD temp06
            END IF
            ON ROW CHANGE
               UPDATE p520_rvbs SET temp06=l_rvbs[i].temp06
                WHERE rvbs03=l_rvbs[i].rvbs03 AND rvbs04=l_rvbs[i].rvbs04
                  AND rvbs05=l_rvbs[i].rvbs05 AND rvbs021=p_ima01
               IF SQLCA.sqlcode THEN
                  ERROR "UPDATE rvbs_file ERROR:",sqlca.sqlcode         #FUN-B80086   ADD
                  ROLLBACK WORK
                 # ERROR "UPDATE rvbs_file ERROR:",sqlca.sqlcode        #FUN-B80086   MARK
                  RETURN
               END IF
            AFTER INPUT
                LET l_qty = 0
                FOR i=1 to l_rvbs.getLength()
                    IF cl_null(l_rvbs[i].temp06) THEN CONTINUE FOR END IF
                    LET l_qty = l_qty + l_rvbs[i].temp06
                END FOR
                IF l_qty <> l_temp.qty THEN
                    CALL cl_err('','asf-866',0)
                    NEXT FIELD temp06
                END IF
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
            ON ACTION exit
               LET INT_FLAG = 1
               EXIT INPUT
            ON ACTION cancel
               LET INT_FLAG = 1
               EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW asfp5101_1
      END IF
   CLOSE WINDOW asfp5101_1
END FUNCTION
 
FUNCTION p520_insrvbs(p_sfs04,p_sfs01,p_sfs02,p_sfs07,p_sfs08,p_sfs09,p_type)
DEFINE p_sfs04          LIKE sfs_file.sfs04
DEFINE p_sfs01          LIKE sfs_file.sfs01
DEFINE p_sfs02          LIKE sfs_file.sfs02
DEFINE p_sfs07          LIKE sfs_file.sfs07
DEFINE p_sfs08          LIKE sfs_file.sfs08
DEFINE p_sfs09          LIKE sfs_file.sfs09
DEFINE p_type           LIKE type_file.chr1
DEFINE l_ima918         LIKE ima_file.ima918
DEFINE l_ima921         LIKE ima_file.ima921
DEFINE l_ima25          LIKE ima_file.ima25
DEFINE l_i              LIKE type_file.num5
DEFINE l_fac            LIKE ima_file.ima55_fac
DEFINE l_rvbs022        LIKE rvbs_file.rvbs022
DEFINE l_temp    RECORD
           rvbs03       LIKE rvbs_file.rvbs03,
           rvbs04       LIKE rvbs_file.rvbs04,
           rvbs05       LIKE rvbs_file.rvbs05,
           rvbs06       LIKE rvbs_file.rvbs06,
#          temp06       LIKE ima_file.ima26,
           temp06       LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044  
           rvbs021      LIKE rvbs_file.rvbs021
         END RECORD
DEFINE l_rvbs    RECORD LIKE rvbs_file.*
   SELECT ima25,ima918,ima921
     INTO l_ima25,l_ima918,l_ima921
     FROM ima_file
    WHERE ima01 = p_sfs04
   IF l_ima918='Y' OR l_ima921='Y' THEN
      LET l_rvbs022 = 1
      DECLARE p520_rvbs1 CURSOR FOR
       SELECT * FROM p520_rvbs
        WHERE rvbs021 = p_sfs04
      FOREACH p520_rvbs1 INTO l_temp.*
         IF l_temp.temp06 <=0 THEN
            CONTINUE FOREACH
         END IF
         IF p_type = '1' THEN   #退料
            LET l_rvbs.rvbs00='asfi528'
         ELSE
            LET l_rvbs.rvbs00='asfi513'
         END IF
         LET l_rvbs.rvbs01=p_sfs01
         LET l_rvbs.rvbs02=p_sfs02
         LET l_rvbs.rvbs03=l_temp.rvbs03
         LET l_rvbs.rvbs04=l_temp.rvbs04
         LET l_rvbs.rvbs05=l_temp.rvbs05
         LET l_rvbs.rvbs07=' '
         LET l_rvbs.rvbs08=' '
         LET l_rvbs.rvbs021=p_sfs04
         LET l_rvbs.rvbs022=l_rvbs022
         #LET l_rvbs.rvbs09=-1     #TQC-B90236 mark
#No.TQC-B90236--------------add----begin------------
         IF p_type ='1' THEN
            LET l_rvbs.rvbs09= 1
         ELSE
            LET l_rvbs.rvbs09=-1
         END IF
#No.TQC-B90236--------------add----end--------------
         LET l_rvbs.rvbs10=0
         LET l_rvbs.rvbs11=0
         LET l_rvbs.rvbs12=0
         LET l_rvbs.rvbs13=0
#批/序號資料存入暫存檔時，全轉換為料件庫存單位（ima25），
#故在寫入時，要轉換成該倉儲之庫存單位（img09）
         SELECT img09 INTO g_img09 FROM img_file
          WHERE img01=p_sfs04 AND img02=p_sfs07
            AND img03=p_sfs08 AND img04=p_sfs09
         CALL s_umfchk(p_sfs04,g_img09,l_ima25) RETURNING l_i,l_fac
         IF l_i = 1 THEN LET l_fac = 1 END IF
         LET l_rvbs.rvbs06=l_temp.temp06*l_fac
         LET l_rvbs.rvbsplant = g_plant  #TQC-C60072 add
         LET l_rvbs.rvbslegal = g_legal  #TQC-C60072 add
         INSERT INTO rvbs_file VALUES (l_rvbs.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_rvbs022 = l_rvbs022+1
      END FOREACH
   END IF
END FUNCTION
#No.CHI-980025
