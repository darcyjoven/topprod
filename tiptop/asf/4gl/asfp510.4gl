# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: asfp510.4gl            #
# Descriptions...: 工單變更及用料移撥作業
# Date & Author..: 87/10/30 By 舜哥
# Modify         : No:7608 apple 2003/07/15 
# Modify.........: No:7865 03/08/27 Carol asf-755判斷要拿掉..目的工單只要
#                                         已確認就可以挪
# Modify.........: 04/07/16 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490217 04/09/10 by yiting 料件欄位用like方式
# Modify.........: No.MOD-490203 04/09/14 ching 秀產生單號
# Modify.........: No.MOD-490301 04/09/16 Kammy 產生挪料單身時，資料不其全
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.FUN-510029 05/02/22 By Mandy 報表轉XML
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.FUN-580132 05/08/26 By Carrier 加入多單位內容
# Modify.........: No.MOD-590028 05/09/06 By kim 修改外部呼叫i510()傳入的參數
# Modify.........: No.MOD-590111 05/09/09 By Carrier 加入s_add_imgg的內容
# Modify.........: No.MOD-610109 06/01/19 By kevin 自動扣賬選上應能產生挪料序號
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660166 06/06/26 By saki 因流程訊息功能修改CALL i501()參數數目
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670103 06/07/31 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680033 06/08/16 By kim 其他程式呼叫asfi526時,必需額外加其他參數來區別與asfp510的不同
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.MOD-6B0070 06/12/14 By pengu 勾選要自動扣帳,但是還是未自動扣帳,因為spfconf欄位會給N 
# Modify.........: No.TQC-710118 07/03/27 By Ray LINE:691的CALL i501('1','6',l_sfp01,'')改成CALL i501('1','6',l_sfp01,'asfp510')
# Modify.........: No.FUN-730075 07/03/30 By 移除sasfi501的link改用外部呼叫方式
# Modify.........: No.FUN-740187 07/04/27 By kim 過帳段CALL sasfi501_sub.4gl
# Modify.........: No.FUN-830132 08/03/28 By hellen 行業別表拆分 INSERT/DELETE
# Modify.........: No.MOD-870001 08/07/01 By cliare sfq05不可為空,給值TODAY,同sfp02
# Modify.........: No.FUN-870051 08/07/16 By sherry 增加被替代料(sfa27)為Key 
# Modify.........: No.TQC-840017 08/04/07 By lumx 工單挪料時，如果挪的料為替代料，則來源工單可挪用量和目的工單需要用量均計算不出來
# Modify.........: No.MOD-8B0086 08/11/10 By chenyu 工單沒有取替代時，讓sfs27=sfa27
# Modify.........: No.TQC-940129 09/04/23 By chenyu insert into sfs_file的之后應該將l_sfs清空
# Modify.........: No.FUN-940008 09/05/06 By hongmei GP5.2發料改善
# Modify.........: No.TQC-940121 09/05/08 By mike 356,453行的DISPLAY BY NAME應該改為DISPLAY ..TO..
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-980025 09/09/20 By chenmoyan 納入批/序號控管
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A40021 10/04/07 By Sarah 若是取替代狀況,sfs27值會給錯,應在寫入p510_temp時就記錄sfs27的值
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60095 10/07/02 By jan 製造功能優化-平行制程(增加製程段製程序的相關處理)
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No:MOD-A90088 10/09/13 By Summer asf-672訊息內容與卡關條件不同,應調整顯示的訊息
# Modify.........: No.FUN-AA0062 10/11/05 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-AC0017 10/12/07 By wangxin 修改執行失敗後的報錯信息 
# Modify.........: No.TQC-AC0293 10/12/20 By vealxu sfp01的開窗/檢查要排除smy73='Y'的單據
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 因asfi510 新增EasyFlow整合功能影響INSERT INTO sfp_file 
# Modify.........: No.FUN-B20095 11/07/01 By lixh1 新增sfq012(製程段號)
# Modify.........: No.TQC-B70074 11/07/13 By guoch mark FUN-B20095 過單
# Modify.........: No.FUN-B70074 11/07/25 By lixh1 增加行業別TABLE(sfsi_file)的處理
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-B90236 11/10/28 By Zhuhao rvbs09的地方加判斷
# Modify.........: No:FUN-BB0084 11/12/13 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-910088 11/12/06 By chenjing 增加數量欄位小數取位
# Modify.........: No:TQC-C60072 12/06/06 By fengrui 添加rvbsplant、rvbslegal赋值
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No:MOD-D30178 13/03/19 By suncx sfp07賦值為g_grup
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查

# Modify.........: No:TQC-D50127 13/05/30 By lixh1 修正FUN-D40103控管
# Modify.........: No:TQC-D50126 13/05/30 By lixh1 修正FUN-D40103控管

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pflag            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_t1               LIKE oay_file.oayslip      #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
DEFINE g_sfb01a           LIKE sfb_file.sfb01
DEFINE g_sfb08a           LIKE sfb_file.sfb01
DEFINE g_sfb081a          LIKE sfb_file.sfb081
DEFINE g_sfb09a           LIKE sfb_file.sfb09
DEFINE g_sfb01b           LIKE sfb_file.sfb01
DEFINE g_sfb08b           LIKE sfb_file.sfb01
DEFINE g_sfb081b          LIKE sfb_file.sfb081
DEFINE g_sfb09b           LIKE sfb_file.sfb09
DEFINE g_outqty           LIKE sfb_file.sfb08
DEFINE g_sure             LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
#DEFINE g_asure           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1) #NO:6968
DEFINE g_bsure            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_csure            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_sfp01a           LIKE sfp_file.sfp01
DEFINE g_sfs07a           LIKE sfs_file.sfs07
DEFINE g_sfs08a           LIKE sfs_file.sfs08
DEFINE g_sfs09a           LIKE sfs_file.sfs09
DEFINE g_sfs07b           LIKE sfs_file.sfs07 #BugNo:6549 
DEFINE g_sfs08b           LIKE sfs_file.sfs08
DEFINE g_sfs09b           LIKE sfs_file.sfs09
DEFINE g_sfp01b           LIKE sfp_file.sfp01,
        g_ware_flag        LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_sfb             RECORD LIKE sfb_file.*
DEFINE g_sfb_s           RECORD LIKE sfb_file.* #來源工單
DEFINE g_sfb_o           RECORD LIKE sfb_file.* #目的工單
DEFINE g_sfa             RECORD LIKE sfa_file.*
DEFINE g_sfp             RECORD LIKE sfp_file.*
DEFINE g_sfq             RECORD LIKE sfq_file.*
DEFINE g_sfs             RECORD LIKE sfs_file.*
DEFINE g_sfm             RECORD LIKE sfm_file.*
DEFINE g_sfn             RECORD LIKE sfn_file.*
DEFINE g_flag           LIKE type_file.num5          #No.FUN-680121 SMALLINT#No.MOD-590111
DEFINE summary_flag     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_buf            LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(80)
DEFINE g_za05           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(40)
 DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE i,j,k            LIKE type_file.num10,        #No.FUN-680121 INTEGER
       g_yy,g_mm        LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_argv1 LIKE sfb_file.sfb01
DEFINE g_tmp RECORD
          tmp00 LIKE type_file.chr1,  #No.FUN-680121 VARCHAR(01) #旗標, 1:來源工單與目的工單之共用料
                                                              #      2:來源工單有但目的工單無
                                                              #      3:來源工單無但目的工單有
          tmp01 LIKE ima_file.ima01,  #料號  No.MOD-490217
          tmp02 LIKE gem_file.gem01,  #No.FUN-680121 VARCHAR(06)  #製程序號--->chiayi modify VARCHAR(06)
          tmp03 LIKE gfe_file.gfe01,  #No.FUN-680121 VARCHAR(04)  #單位
#         tmp04 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)    #來源工單撥出數量
#         tmp05 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)    #目的工單需求數量
#         tmp10 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)    #超領
#         tmp06 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)    #實際撥出數量
          tmp04 LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          tmp05 LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          tmp10 LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          tmp06 LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          tmp27 LIKE ima_file.ima01,  #MOD-A40021 add             #被替代料號
          tmp97 LIKE imd_file.imd01,  #No.FUN-680121 VARCHAR(10)  #倉
          tmp98 LIKE imd_file.imd01,  #No.FUN-680121 VARCHAR(10)  #儲
          tmp99 LIKE aag_file.aag01,  #No.FUN-680121 CAHR(24)     #批
#         tmp11 LIKE ima_file.ima26   #No.FUN-680121 DEC(15,3)    #備料的已發數量sfa06+超領量sfa062
          tmp11 LIKE type_file.num15_3     ###GP5.2  #NO.FUN-A20044
       END RECORD,
       g_img09   LIKE img_file.img09
   DEFINE   p_row,p_col  LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE g_gent1   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1) #Y:產生退料單
   DEFINE g_gent2   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1) #Y:產生領料單
 
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_msg           STRING  #FUN-730075
MAIN
#     DEFINE   l_time   LIKE type_file.chr8       #No.FUN-6A0090
 
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
 
 
   LET g_argv1 = ARG_VAL(1)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
   OPEN WINDOW p510_w AT p_row,p_col
        WITH FORM "asf/42f/asfp510" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
 
    #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #MOD-580222 mark  #No.FUN-6A0090
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   IF g_sma.sma53 IS NOT NULL AND TODAY <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1)
   ELSE
      CALL s_yp(g_today) RETURNING g_yy,g_mm
      IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
         CALL cl_err(g_yy,'mfg6090',1)
      ELSE
         CALL p510()
      END IF
   END IF
   CLOSE WINDOW p510_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0090
END MAIN
 
#-------------------------------------------------------------------------
 
FUNCTION p510()
   DEFINE l_t1   LIKE oay_file.oayslip        #No.FUN-680121 VARCHAR(5)
   DEFINE l_flag LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067         #No.FUN-680121 SMALLINT
   DEFINE l_smy73       LIKE smy_file.smy73          #TQC-AC0293  

   WHILE TRUE
     CLEAR FORM
     MESSAGE ""
           LET g_ware_flag='y'
           LET g_sfb01a=g_argv1
           LET g_sfb01b = NULL
           LET g_outqty = NULL 
           LET g_bsure='Y'
           LET g_csure='N'       #No:7608
           LET g_sfp01a = NULL
           LET g_sfp01b = NULL
           LET g_sfs07a = NULL
           LET g_sfs08a = NULL
           LET g_sfs09a = NULL
           LET g_sfs07b = NULL
           LET g_sfs08b = NULL
           LET g_sfs09b = NULL
   DISPLAY g_sfb01a,g_bsure,g_csure to sfb01a,b,c
     INPUT g_sfb01a,g_sfb01b,g_outqty,g_bsure,g_csure, #NO:6968
           g_sfp01a,g_sfp01b,
           g_sfs07a,g_sfs08a,g_sfs09a, 
           g_sfs07b,g_sfs08b,g_sfs09b  #BugNo:6549
           WITHOUT DEFAULTS
 
     FROM
         # sfb01a,sfb01b,outqty,FORMONLY.a,
         #No.B615 010627 mod
           sfb01a,sfb01b,outqty,FORMONLY.b,FORMONLY.c, #NO:6968
           sfp01a,sfp01b,
           sfs07a,sfs08a,sfs09a, 
           sfs07b,sfs08b,sfs09b
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
 
           ON KEY (INTERRUPT)
              LET g_pflag = 'Y'
              EXIT INPUT
 
           ON KEY (ESC)
              EXIT INPUT
           #No.B615 add
           AFTER FIELD b
              IF g_bsure IS NULL OR g_bsure NOT MATCHES '[YN]' THEN
                 NEXT FIELD b
              END IF
           AFTER FIELD c
              IF g_csure IS NULL OR g_csure NOT MATCHES '[YN]' THEN
                 NEXT FIELD c
              END IF
           #No.B615 end---
           AFTER FIELD sfb01a
              #NO:6968---
              SELECT COUNT(*) INTO g_cnt
                FROM snb_file
               WHERE snb01 = g_sfb01a
                 AND snbconf = 'N' 
              IF g_cnt >= 1 THEN
                  #此張工單有做工單變更,但未發出,所以不可做挪料!
                  CALL cl_err(g_sfb01a,'asf-748',0)
                  NEXT FIELD sfb01a
              END IF
              #NO:6968---END
              SELECT * INTO g_sfb_s.* FROM sfb_file WHERE sfb01 = g_sfb01a
              CASE
                  WHEN STATUS = NOTFOUND
                       CALL cl_err('','asf-312',0)
                       NEXT FIELD sfb01a
 
                  WHEN g_sfb_s.sfb04 = '8'
                       CALL cl_err(g_sfb01a,'asf-345',0)
                       NEXT FIELD sfb01a
 
                  WHEN g_sfb_s.sfb04 < '4'
                       CALL cl_err(g_sfb01a,'asf-570',0)
                       NEXT FIELD sfb01a
 
                  when g_sfb_s.sfb08 <=  g_sfb_s.sfb09
                       CALL cl_err(g_sfb01a,'asf-920',0)
                       NEXT FIELD sfb01a
 
              END CASE
              DISPLAY g_sfs07a,g_sfs08a,g_sfs09a TO
                      sfs07a,  sfs08a,  sfs09a
###
              LET g_sfb08a = g_sfb_s.sfb08
              LET g_sfb081a = g_sfb_s.sfb081
              LET g_sfb09a = g_sfb_s.sfb09
              DISPLAY g_sfb08a TO sfb08a
              DISPLAY g_sfb081a TO sfb081a
              DISPLAY g_sfb09a TO sfb09a
               
 
           AFTER FIELD outqty
              IF g_outqty <= 0 OR g_outqty IS NULL THEN
                 #本欄位之值不可小於零, 且不可為空白或 NULL
                 CALL cl_err('','mfg3331',0)
                 NEXT FIELD outqty
              END IF
           #FUN-BB0084 --------------Begin------------------
              IF NOT cl_null(g_outqty) THEN
                 LET g_outqty = s_digqty(g_outqty,g_sfa.sfa12)
                 DISPLAY g_outqty TO outqty
              END IF 
           #FUN-BB0084 --------------End--------------------
              IF g_outqty > g_sfb_s.sfb081 - g_sfb_s.sfb09 THEN #工單在製套數
                 #挪料套數不可大於工單在製套數!
                 #error 'quantity error'
                 CALL cl_err('','asf-907',0)
                 NEXT FIELD outqty
              END IF
              IF NOT cl_null(g_sfb01b) THEN
                 IF g_outqty > (g_sfb_o.sfb08-g_sfb_o.sfb081) THEN #工單未發套數
                    #error 'quantity error'
                    CALL cl_err('','asf-908',0) #挪料套數不可大於目的工單單頭的未發套數!
                    NEXT FIELD outqty
                 END IF
              END IF
 
           AFTER FIELD sfb01b
              IF NOT cl_null(g_sfb01b) THEN
                 #NO:6968---
                 SELECT COUNT(*) INTO g_cnt
                   FROM snb_file
                  WHERE snb01 = g_sfb01a
                    AND snbconf = 'N' 
                 IF g_cnt >= 1 THEN
                     #此張工單有做工單變更,但未發出,所以不可做挪料!
                     CALL cl_err(g_sfb01a,'asf-748',0)
                     NEXT FIELD sfb01a
                 END IF
                 #NO:6968---END
                 SELECT * INTO g_sfb_o.* FROM sfb_file WHERE sfb01 = g_sfb01b
                 CASE
                     WHEN STATUS = NOTFOUND
                          CALL cl_err(g_sfb01b,'asf-312',0)
                          NEXT FIELD sfb01b
 
                     WHEN g_sfb_o.sfb04 = '8'
                          CALL cl_err(g_sfb01b,'asf-345',0)
                          next field sfb01b
 
                     WHEN g_sfb_o.sfb04 > '4' #NO:6968 
                          ERROR "sfb04 > '4' "
                          NEXT FIELD sfb01b
                     WHEN g_sfb_o.sfb04 < '2'
                          CALL cl_err('','asf-381',0)
                          NEXT FIELD sfb01b
#No:7865
{
                     WHEN g_sfb_o.sfb081 = 0 
                          CALL cl_err('','asf-755',0)
                          NEXT FIELD sfb01b
}
##
                 END CASE
                 IF g_sfb_o.sfb82<>g_sfb_s.sfb82 AND g_sfb_s.sfb02=7 THEN
                    CALL cl_err('','asf-684',0) #MOD-A90088 mod asf-672->asf-684
                    NEXT FIELD sfb01b
                 END IF
                 LET g_sfb08b     =  g_sfb_o.sfb08
                 LET g_sfb081b    =  g_sfb_o.sfb081
                 LET g_sfb09b     =  g_sfb_o.sfb09
                 DISPLAY g_sfb08b TO sfb08b
                 DISPLAY g_sfb081b TO sfb081b
                 DISPLAY g_sfb09b TO sfb09b
                 #NO:6968
                 #目的工單,單頭已發齊套(單頭生產套數=單頭已發套數)者,不可做挪料!
                 IF g_sfb_o.sfb08 = g_sfb_o.sfb081 THEN
                     #目的工單已發齊套(單頭生產數量=單頭已發數量),不可執行本作業!
                     CALL cl_err(g_sfb01b,'asf-940',0)
                     NEXT FIELD sfb01b
                 END IF
             ELSE
                 LET g_sfb08b     =  NULL
                 LET g_sfb081b    =  NULL
                 LET g_sfb09b     =  NULL
                 DISPLAY g_sfb08b TO sfb08b
                 DISPLAY g_sfb081b TO sfb081b
                 DISPLAY g_sfb09b TO sfb09b
              END IF
 
           AFTER FIELD sfp01a
              IF cl_null(g_sfp01a) THEN
                 #本欄位不可空白, 請重新輸入!
                 CALL cl_err(g_sfp01a,'mfg0037',0)
                 NEXT FIELD sfp01a
              END IF
         #No.FUN-550067 --start--  
            LET l_t1 = g_sfp01a[1,g_doc_len]
            CALL s_check_no("asf",l_t1,"","4","","","")  
            RETURNING li_result,g_sfp01a                                                   
            LET g_sfp01a=s_get_doc_no(g_sfp01a)
           #DISPLAY BY NAME g_sfp01a #TQC-940121 
            DISPLAY g_sfp01a TO sfp01a   #TQC-940121                                                                                               
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD sfp01a                                                                                                     
            END IF                                                                                                                  
           #TQC-AC0293 -------------add start---------
            SELECT smy73 INTO l_smy73 FROM smy_file
             WHERE smyslip = l_t1 
            IF l_smy73 = 'Y' THEN
              CALL cl_err('','asf-874',0)
              NEXT FIELD sfp01a 
           END IF 
           #TQC-AC0293 -------------add end------------
#             CALL s_mfgslip(l_t1,'asf','4')
#             IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
#                 CALL cl_err(l_t1,g_errno,0) 
#                 NEXT FIELD sfp01a
#             END IF
      #No.FUN-550067 ---end---   
           BEFORE FIELD sfs07a
              IF g_ware_flag='n' THEN
# genero  script marked                  IF cl_ku() THEN NEXT FIELD PREV ELSE NEXT FIELD NEXT END IF
              END IF
           BEFORE FIELD sfs08a
              IF g_ware_flag='n' THEN
# genero  script marked                  IF cl_ku() THEN NEXT FIELD PREV ELSE NEXT FIELD NEXT END IF
              END IF
           BEFORE FIELD sfs09a
              IF g_ware_flag='n' THEN
# genero  script marked                  IF cl_ku() THEN NEXT FIELD PREV ELSE NEXT FIELD NEXT END IF
              END IF
           #{BugNo:6549
           AFTER FIELD sfs07a
              #NO:6968
             #IF cl_ku() THEN
             #    IF NOT cl_null(g_sfb01b) THEN
             #        NEXT FIELD sfp01b
             #    ELSE
             #        NEXT FIELD sfp01a
             #    END IF
             #END IF
              IF NOT cl_null(g_sfs07a) THEN 
                  SELECT imd01 INTO g_buf FROM imd_file 
                   WHERE imd01=g_sfs07a
                     AND imd10='S'
                      AND imdacti = 'Y' #MOD-4B0169
                  IF STATUS THEN
                     CALL cl_err('sel imd:','mfg1100',0) NEXT FIELD sfs07a
                  END IF
                  #No.FUN-AA0062  --Begin
                  IF NOT s_chk_ware(g_sfs07a) THEN
                    NEXT FIELD sfs07a
                  END IF
                  #No.FUN-AA0062  --End
          #FUN-D40103 -------Begin-------
                   IF NOT p510_ime_chk(g_sfs07a,g_sfs08a,'S') THEN
                      NEXT FIELD sfs08a
                   END IF
          #FUN-D40103 -------End---------
              END IF
           AFTER FIELD sfs08a
              IF NOT cl_null(g_sfs08a) THEN
                #FUN-D40103--mark--str--
                #SELECT ime01 INTO g_buf FROM ime_file
                #   WHERE ime01=g_sfs07a 
                #     AND ime02=g_sfs08a
                #     AND ime04='S'
                #IF STATUS THEN
                #    LET g_sfs08a=' '
                #    CALL cl_err('sel ime:','mfg1100',0) 
                #    NEXT FIELD sfs08a
                #END IF
                #FUN-D40103--mark--end--
              ELSE
                  LET g_sfs08a=' '
              END IF
           #FUN-D40103 -------Begin--------
               IF NOT p510_ime_chk(g_sfs07a,g_sfs08a,'S') THEN
                  NEXT FIELD sfs08a
               END IF
           #FUN-D40103 -------End----------
           AFTER FIELD sfs07b
              IF NOT cl_null(g_sfs07b) THEN
                  SELECT imd01 INTO g_buf FROM imd_file 
                   WHERE imd01=g_sfs07b
                     AND imd10='W'
                      AND imdacti = 'Y' #MOD-4B0169
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('sel imd:','mfg1100',0) 
                      NEXT FIELD sfs07b
                  END IF
                  #No.FUN-AA0062  --Begin
                  IF NOT s_chk_ware(g_sfs07b) THEN
                    NEXT FIELD sfs07b
                  END IF
                  #No.FUN-AA0062  --End
           #FUN-D40103 -------Begin--------
                   IF NOT p510_ime_chk(g_sfs07b,g_sfs08b,'W') THEN
                      NEXT FIELD sfs08b
                   END IF
           #FUN-D40103 -------End----------
              END IF
           AFTER FIELD sfs08b
              IF NOT cl_null(g_sfs08b) THEN
                #FUN-D40103--mark--str--
                #SELECT ime01 INTO g_buf 
                #  FROM ime_file
                # WHERE ime01=g_sfs07b  
                #   AND ime02=g_sfs08b
                #   AND ime04='W'
                #IF SQLCA.sqlcode THEN
                #    LET g_sfs08b=' '
                #    CALL cl_err('sel ime:','mfg1100',0) NEXT FIELD sfs08b
                #END IF
                #FUN-D40103--mark--end--
              ELSE
                  LET g_sfs08b=' '
              END IF
            #FUN-D40103 -------Begin--------
               IF NOT p510_ime_chk(g_sfs07b,g_sfs08b,'W') THEN
                  NEXT FIELD sfs08b
               END IF
            #FUN-D40103 -------End----------
           #BugNo:6549}
 
           BEFORE FIELD sfp01b
              IF cl_null(g_sfb01b) THEN NEXT FIELD sfs07a END IF
 
           AFTER FIELD sfp01b
              IF cl_null(g_sfp01b) THEN
                  #此欄位不可空白, 請輸入資料!
                  CALL cl_err('','aap-099',0)
                  NEXT FIELD sfp01b
              END IF
        #No.FUN-550067 --start-- 
            LET l_t1 = g_sfp01b[1,g_doc_len]
            CALL s_check_no("asf",l_t1,"","3","","","")  
            RETURNING li_result,g_sfp01b                                                   
            LET g_sfp01b = s_get_doc_no(g_sfp01b)
           #DISPLAY BY NAME g_sfp01b #TQC-940121    
            DISPLAY g_sfp01b TO sfp01b    #TQC-940121                                                                                                
            IF (NOT li_result) THEN                       
#             CALL s_mfgslip(l_t1,'asf','3')
#             IF NOT cl_null(g_errno) THEN                    #抱歉, 有問題
#                 CALL cl_err(l_t1,g_errno,0) 
                  NEXT FIELD sfp01b
              END IF
           #TQC-AC0293 -------------add start---------
            SELECT smy73 INTO l_smy73 FROM smy_file
             WHERE smyslip = l_t1
            IF l_smy73 = 'Y' THEN
              CALL cl_err('','asf-874',0)
              NEXT FIELD sfp01b
            END IF
           #TQC-AC0293 -------------add end------------
         #No.FUN-550067 ---end---  
 
         AFTER INPUT 
              IF cl_null(g_sfp01a) THEN
                  #此欄位不可空白, 請輸入資料!
                  CALL cl_err('','aap-099',0)
                  NEXT FIELD sfp01a
              END IF
              IF NOT cl_null(g_sfb01b) THEN
                  IF cl_null(g_sfp01b) THEN
                      #此欄位不可空白, 請輸入資料!
                      CALL cl_err('','aap-099',0)
                      NEXT FIELD sfp01b
                  END IF
                  IF g_outqty > (g_sfb_o.sfb08-g_sfb_o.sfb081) THEN #工單未發套數
                     #error 'quantity error'
                     CALL cl_err('','asf-908',0) #挪料套數不可大於目的工單單頭的未發套數!
                     NEXT FIELD outqty
                  END IF
              END IF
              IF g_outqty <= 0 OR g_outqty IS NULL THEN
                 #本欄位之值不可小於零, 且不可為空白或 NULL
                 CALL cl_err('','mfg3331',0)
                 NEXT FIELD outqty
              END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sfp01a) #查詢單据 ,退料單號
#                 LET g_t1=g_sfp01a[1,3]
                  LET g_t1 = s_get_doc_no(g_sfp01a)     #No.FUN-550067  
                  #FUN-AC0017 add -----------------begin--------------------
                  LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"   
                  LET g_sql = g_sql," AND smy72='6'" 
                  CALL smy_qry_set_par_where(g_sql)
                  #FUN-AC0017 add ------------------end---------------------
                 #CALL q_smy(FALSE,FALSE,g_t1,'asf','4') RETURNING g_t1  #TQC-670008
                  CALL q_smy(FALSE,FALSE,g_t1,'ASF','4') RETURNING g_t1  #TQC-670008
#                  LET g_sfp01a[1,4]=g_t1
                  LET g_sfp01a=g_t1                     #No.FUN-550067
                  DISPLAY g_sfp01a  TO   sfp01a 
                  NEXT FIELD sfp01a
                  INITIALIZE g_t1  to NULL
               WHEN INFIELD(sfp01b) #查詢單据 ,領料單號
#                 LET g_t1=g_sfp01b[1,3]
                  LET g_t1 = s_get_doc_no(g_sfp01b)     #No.FUN-550067      
                  #FUN-AC0017 add -----------------begin--------------------
                  LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"
                  LET g_sql = g_sql," AND smy72='1'"
                  CALL smy_qry_set_par_where(g_sql)
                  #FUN-AC0017 add ------------------end---------------------
                 #CALL q_smy( FALSE, TRUE,g_t1,'asf','3') RETURNING g_t1  #TQC-670008
                  CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1  #TQC-670008
#                  CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                 LET g_sfp01b[1,3]=g_t1
                  LET g_sfp01b=g_t1   #No.FUN-550067    
                  DISPLAY g_sfp01b  TO  sfp01b 
                  NEXT FIELD sfp01b
               WHEN INFIELD(sfb01a)
#                 CALL q_sfb(0,0,g_sfb01a,'234567') RETURNING g_sfb01a
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb02"
                  LET g_qryparam.default1 = g_sfb01a
                  LET g_qryparam.arg1 = "234567"
                  CALL cl_create_qry() RETURNING g_sfb01a
                  DISPLAY g_sfb01a   TO  sfb01a  
                  NEXT FIELD sfb01a
               WHEN INFIELD(sfb01b)
#                 CALL q_sfb(0,0,g_sfb01b,'234') RETURNING g_sfb01b
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb02"
                  LET g_qryparam.default1 = g_sfb01b
                  LET g_qryparam.arg1 = "234"
                  CALL cl_create_qry() RETURNING g_sfb01b
                  DISPLAY g_sfb01b   TO  sfb01b  
                  NEXT FIELD sfb01b
               #No.BANN
               #BugNo:6549
               WHEN INFIELD(sfs07a)
#                 CALL q_imd(0,0,g_sfs07a,'S') RETURNING g_sfs07a
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = g_sfs07a
#                 #LET g_qryparam.where = " imd10 = 'S' "
#                   LET g_qryparam.arg1     = 'S'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING g_sfs07a
                  CALL q_imd_1(FALSE,TRUE,g_sfs07a,"S","","","") RETURNING g_sfs07a
#No.FUN-AA0062  --End
                  DISPLAY g_sfs07a TO FORMONLY.sfs07a
                  NEXT FIELD sfs07a
               WHEN INFIELD(sfs07b)
#                 CALL q_imd(0,0,g_sfs07b,'W') RETURNING g_sfs07b
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_imd"
#                  LET g_qryparam.default1 = g_sfs07b
#                 #LET g_qryparam.where = " imd10 = 'W' "
#                   LET g_qryparam.arg1     = 'W'        #倉庫類別 #MOD-4A0213
#                  CALL cl_create_qry() RETURNING g_sfs07b
                  CALL q_imd_1(FALSE,TRUE,g_sfs07b,"W","","","") RETURNING g_sfs07b
#No.FUN-AA0062  --End
                  DISPLAY g_sfs07b TO FORMONLY.sfs07b
                  NEXT FIELD sfs07b
               WHEN INFIELD(sfs08a)
#                 CALL q_ime(0,0,g_sfs08a,g_sfs07a,'S') RETURNING g_sfs08a
#No.FUN-AA0062  --Begin                  
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ime"
#                  LET g_qryparam.default1 = g_sfs08a
#                   LET g_qryparam.arg1     = g_sfs07a    #倉庫編號 #MOD-4A0063
#                   LET g_qryparam.arg2     = 'S'         #倉庫類別 #MOD-4A0063
#                 #LET g_qryparam.where = " ime04 = 'S' "
#                  CALL cl_create_qry() RETURNING g_sfs08a
                  CALL q_ime_1(FALSE,TRUE,g_sfs08a,g_sfs07a,"S","","","","") RETURNING g_sfs08a 
#No.FUN-AA0062  --End 
                  DISPLAY g_sfs08a TO FORMONLY.sfs08a                 
                  NEXT FIELD sfs08a
               WHEN INFIELD(sfs08b)
#                 CALL q_ime(0,0,g_sfs08b,g_sfs07b,'W') RETURNING g_sfs08b
#No.FUN-AA0062  --Begin 
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ime"
#                  LET g_qryparam.default1 = g_sfs08b
#                   LET g_qryparam.arg1     = g_sfs07b #倉庫編號 #MOD-4A0063
#                   LET g_qryparam.arg2     = 'W'      #倉庫類別 #MOD-4A0063
#                 #LET g_qryparam.where = " ime04 = 'W' "
#                  CALL cl_create_qry() RETURNING g_sfs08b
                  CALL q_ime_1(FALSE,TRUE,g_sfs08a,g_sfs07b,"W","","","","") RETURNING g_sfs08b 
#No.FUN-AA0062  --End                   
                  DISPLAY g_sfs08b TO FORMONLY.sfs08b
                  NEXT FIELD sfs08b
              #No.BANN END
 
            END CASE
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
      CALL p510_save()
      IF g_success = 'Y' THEN
         COMMIT WORK
         LET g_buf = "RID=",g_sfm.sfm00
         IF g_gent1 = 'Y' THEN
             LET g_buf = g_buf CLIPPED,",",g_x[22] CLIPPED,g_sfp01a
         END IF
         IF g_gent2 = 'Y' THEN
             LET g_buf = g_buf CLIPPED,",",g_x[23] CLIPPED,g_sfp01b
         END IF
 
          #MOD-490203
         DISPLAY g_sfp01a TO sfp01a
         DISPLAY g_sfp01b TO sfp01b
         #--
 
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

#FUN-D40103 -------Begin--------
FUNCTION p510_ime_chk(p_ime01,p_ime02,p_ime04) #TQC-D50126 add p_ime04
   DEFINE p_ime01    LIKE ime_file.ime01
   DEFINE p_ime02    LIKE ime_file.ime02
   DEFINE p_ime04    LIKE ime_file.ime04    
   DEFINE l_ime02    LIKE ime_file.ime02    #TQC-D50116
   DEFINE l_imeacti  LIKE ime_file.imeacti
   DEFINE l_cnt      LIKE type_file.num5    #TQC-D50116

   IF p_ime02 IS NOT NULL AND p_ime02 != ' ' THEN         #TQC-D50127
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ime_file
       WHERE ime01 = p_ime01
         AND ime02 = p_ime02
         AND ime04 = p_ime04
      IF l_cnt = 0 THEN
         CALL cl_err(p_ime01|| ' ' ||p_ime02,'mfg1100',0) 
         RETURN FALSE
      END IF
   END IF  
   IF p_ime02 IS NOT NULL THEN  #TQC-D50127
      LET l_imeacti = ''
      SELECT imeacti INTO l_imeacti FROM ime_file
       WHERE ime01 = p_ime01
         AND ime02 = p_ime02
    #TQC-D50116 ----Begin-----
      IF l_imeacti = 'N' THEN
         LET l_ime02 = p_ime02
         IF cl_null(l_ime02) THEN
            LET l_ime02 = "' '"
         END IF
         CALL cl_err_msg("","aim-507",p_ime01|| "|" ||l_ime02,0)
    #TQC-D50116 ----End-------
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40103 -------End----------
#------------------------------------------------------------------------
FUNCTION p510_save()
 
   DEFINE l_name        LIKE type_file.chr20         #No.FUN-680121 VARCHAR(20)
#  DEFINE l_order       LIKE apm_file.apm08          #No.FUN-680121 CAHR(10) # TQC-6A0079
#  DEFINE l_sfp01       VARCHAR(11)  #No.FUN-580132
   DEFINE l_sfp01       LIKE type_file.chr20         #No.FUN-680121 VARCHAR(17) #No.FUN-580132
   DEFINE l_i           LIKE type_file.num5          #No.FUN-680121 SMALLINT
#  DEFINE l_sum_tmp06   LIKE ima_file.ima26          #No.FUN-680121 DEC(16,3)
   DEFINE l_sum_tmp06   LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
   DROP TABLE p510_temp
 #No.FUN-680121-BEGIN
  CREATE TEMP TABLE p510_temp(
          tmp00 LIKE type_file.chr1,  
          tmp01 LIKE type_file.chr1000,
          tmp02 LIKE gem_file.gem01,
          tmp03 LIKE gfe_file.gfe01,
#         tmp04 LIKE ima_file.ima26,
#         tmp05 LIKE ima_file.ima26,
#         tmp10 LIKE ima_file.ima26,
#         tmp06 LIKE ima_file.ima26,
          tmp04 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp05 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp10 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp06 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp27 LIKE ima_file.ima01,      #MOD-A40021 add
          tmp97 LIKE imd_file.imd01,
          tmp98 LIKE imd_file.imd01,
          tmp99 LIKE aag_file.aag01,
          tmp11 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044  #FUN-A60027
          tmp12 LIKE sfa_file.sfa012,     #FUN-A60027
          tmp13 LIKE sfa_file.sfa013)     #FUN-A60027
  #No.FUN-680121-END
#No.CHI-980025 --Begin
  DROP TABLE p510_rvbs
  CREATE TEMP TABLE p510_rvbs(
          rvbs03  LIKE rvbs_file.rvbs03,
          rvbs04  LIKE rvbs_file.rvbs04,
          rvbs05  LIKE rvbs_file.rvbs05,
          rvbs06  LIKE rvbs_file.rvbs06,
          temp06  LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          rvbs021 LIKE rvbs_file.rvbs021)
#No.CHI-980025 --End
   BEGIN WORK
   LET g_success = 'Y'
   #將來源工單與目的工單之備料資料逐筆取出並存入tmp
   CALL p510_gen_tmp()
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
   CALL p510_b()
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM p510_temp
   IF g_cnt <= 0 THEN
      ROLLBACK WORK
      #無整批挪料的資料
      CALL cl_err('','asf-754',0)
      RETURN
   END IF
   SELECT SUM(tmp06) INTO l_sum_tmp06 FROM p510_temp
   IF l_sum_tmp06 <=0 THEN
      ROLLBACK WORK
      #無整批挪料的資料
      CALL cl_err('','asf-754',0)
      RETURN
   END IF
   IF g_bsure = 'Y' then
      CALL tmp_print()    # 列印工單調撥模擬報表
   END IF
   IF NOT cl_sure(0,0) THEN
      LET g_success = 'N' #FUN-AC0017 add
      ROLLBACK WORK 
      RETURN
   END IF
   IF g_success = 'Y' THEN #NO:6968
      # 產生領/退料單資料 (sfp_file,sfq_file,sfs_file)
      CALL p510_gen_pqs()
   END IF
 
   IF g_csure='Y' AND g_success = 'Y' THEN
      # 更新工單檔及備料檔資料 (sfb_file,sfa_file)
      CALL p510_up_sfba() #INSERT INTO sfm_file 工單變更紀錄檔
                          #INSERT INTO sfn_file 工單變更明細紀錄檔
   END IF
   
   IF g_csure = 'Y' AND g_success = 'Y' THEN
      # 產生領/退料單資料扣帳 (sfp_file,sfq_file,sfs_file)
      IF NOT cl_null(g_sfp01a) AND g_gent1 = 'Y' 
         THEN
        #LET l_sfp01=g_sfp01a,'S' #MOD-590028
         LET l_sfp01=g_sfp01a #MOD-590028
         #CALL i501('2','6',l_sfp01,'asfp510')           #No.FUN-660166 #FUN-680033 add 'asfp510' #FUN-730075
        #LET g_msg="asfi520 6 '",l_sfp01,"'"," 'asfp510'"  #FUN-730075移除p_link sasfi501,改用外部呼叫方式  #FUN-740187
        #CALL cl_cmdrun_wait(g_msg) #FUN-730075 #FUN-740187
         LET g_prog='asfi526'                 #No.CHI-980025 
         CALL i501sub_s('2',l_sfp01,TRUE,'N') #FUN-740187
         LET g_prog='asfp510'                 #No.CHI-980025
         UPDATE sfp_file
            SET sfp09 = 'Y',
                sfp10 = g_sfm.sfm00
          WHERE sfp01 = g_sfp01a
         IF SQLCA.sqlcode THEN
             CALL cl_err('UPDATE sfp10',SQLCA.sqlcode,0)
             LET g_success = 'N'
         END IF
      END IF
      IF g_success='Y' AND NOT cl_null(g_sfp01b) AND g_gent2 = 'Y' THEN
        #LET l_sfp01=g_sfp01b,'S' #MOD-590028
         LET l_sfp01=g_sfp01b #MOD-590028
        #CALL i501('1','1',l_sfp01)
        #CALL i501('1','6',l_sfp01,'') #MOD-590028  #No.FUN-660166      #No.TQC-710118
        #CALL i501('1','6',l_sfp01,'asfp510') #MOD-590028  #No.FUN-660166      #No.TQC-710118 #FUN-730075
        #LET g_msg="asfi520 6 '",l_sfp01,"'"," 'asfp510'"  #FUN-730075移除p_link sasfi501,改用外部呼叫方式 #FUN-740187
        #CALL cl_cmdrun_wait(g_msg) #FUN-730075  #FUN-740187
         LET g_prog='asfi511'                 #No.CHI-980025
         CALL i501sub_s('1',l_sfp01,TRUE,'N') #FUN-740187
         LET g_prog='asfp510'                 #No.CHI-980025
     
         UPDATE sfp_file
            SET sfp09 = 'Y',
                sfp10 = g_sfm.sfm00
          WHERE sfp01 = g_sfp01b
         IF SQLCA.sqlcode THEN
             CALL cl_err('UPDATE sfp10',SQLCA.sqlcode,0)
             LET g_success = 'N'
         END IF
      END IF
   END IF
 
END FUNCTION
 
#-----------------------------------------------------------------------
FUNCTION  p510_clear()
 
 INITIALIZE  g_sfb_s.*  TO  NULL
 INITIALIZE  g_sfb_o.*  TO  NULL
 INITIALIZE  g_sfb01a   TO  NULL
 INITIALIZE  g_sfb08a   TO  NULL
 INITIALIZE  g_sfb081a  TO  NULL
 INITIALIZE  g_sfb09a   TO  NULL
 INITIALIZE  g_sfb01b   TO  NULL
 INITIALIZE  g_sfb08b   TO  NULL
 INITIALIZE  g_sfb081b  TO  NULL
 INITIALIZE  g_sfb09b   TO  NULL
 INITIALIZE  g_outqty   TO  NULL
#INITIALIZE  g_asure    TO  NULL #NO:6968
 INITIALIZE  g_bsure    TO  NULL
 INITIALIZE  g_csure    TO  NULL
 INITIALIZE  g_sfp01a   TO  NULL
 INITIALIZE  g_sfs07a   TO  NULL
 INITIALIZE  g_sfs08a   TO  NULL
 INITIALIZE  g_sfs09a   TO  NULL
 INITIALIZE  g_sfp01b   TO  NULL
 
 
END FUNCTION
 
#-------------------------------------------------------------------------
function p510_gen_tmp()
   DEFINE sr RECORD
          tmp00 LIKE type_file.chr1,  #No.FUN-680121 VARCHAR(1) #旗標, 1:來源工單與目的工單之共用料
                                                             #      2:來源工單有但目的工單無
                                                             #      3:來源工單無但目的工單有
          tmp01 LIKE ima_file.ima01,  #料號  No.MOD-490217
          tmp02 LIKE gem_file.gem01,  #No.FUN-680121 VARCHAR(06) #製程序號 chiayi modify
          tmp03 LIKE gfe_file.gfe01,  #No.FUN-680121 VARCHAR(04)
#         tmp04 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)   #來源工單可退數量
#         tmp05 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)   #目的工單需求數量
#         tmp10 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)   #超領
#         tmp06 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)   #來源工單實際移轉量
          tmp04 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp05 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp10 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp06 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp27 LIKE ima_file.ima01,  #MOD-A40021 add            #被替代料號
          tmp97 LIKE imd_file.imd01,  #No.FUN-680121 VARCHAR(10)
          tmp98 LIKE imd_file.imd01,  #No.FUN-680121 VARCHAR(10) #儲
          tmp99 LIKE aag_file.aag01,  #No.FUN-680121 VARCHAR(24) #批
#         tmp11 LIKE ima_file.ima26   #No.FUN-680121 DEC(15,3)
#         tmp11 LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044   #FUN-A60027
          tmp11 LIKE type_file.num15_3,   #FUN-A60027 
          tmp12 LIKE sfa_file.sfa012,     #FUN-A60027
          tmp13 LIKE sfa_file.sfa013      #FUN-A60027  
       END RECORD,
#     l_needqty LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)
#     l_atpqty  LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)#可轉出數量
      l_needqty LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      l_atpqty  LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      l_ima108  LIKE ima_file.ima108, #SMT料否
#     _sfa05_06 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)#備料的未發數量
      l_sfa05_06 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      l_sfa161  LIKE sfa_file.sfa161  #No.TQC-840017
#No.CHI-980025 --Begin
#    ,l_amt     LIKE ima_file.ima26,
     ,l_amt     LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
      l_ima25   LIKE ima_file.ima25,
      l_ima918  LIKE ima_file.ima918,
      l_ima921  LIKE ima_file.ima921,
      l_sfp06   LIKE sfp_file.sfp06,
      l_cnt     LIKE type_file.num5,
      l_i       LIKE type_file.num5,
      l_fac     LIKE ima_file.ima55_fac,
      l_sfe     RECORD LIKE sfe_file.*,
      l_rvbs    RECORD LIKE rvbs_file.*
#No.CHI-980025 --End
   #NO:6968--------------
   #====>來源工單
   DECLARE p510_gen_cs1 CURSOR FOR
      SELECT * FROM sfa_file 
       WHERE sfa01 = g_sfb01a #來源工單
         AND sfa05>0
   FOREACH p510_gen_cs1 INTO g_sfa.*
      INITIALIZE  sr.*  TO  NULL
      LET sr.tmp00 = '2'           #來源工單有
      LET sr.tmp01 = g_sfa.sfa03   #料號
      LET sr.tmp02 = g_sfa.sfa08   #作業編號
      LET sr.tmp03 = g_sfa.sfa12   #單位
      #來源工單可退數量:
      #當狀態='1'共用料或'2'僅來源工單有
      #default=擬撥出套數*qpa,但不可以大於來源工單的已發數量
#TQC-840017--begin---
      IF g_sfa.sfa26='S' OR g_sfa.sfa26='U' OR g_sfa.sfa26 = 'Z' THEN   #FUN-A20037 add 'Z'
         SELECT sfa161 INTO l_sfa161 FROM sfa_file
          where sfa01=g_sfb01a
            AND sfa03=g_sfa.sfa27
            AND sfa08=g_sfa.sfa08
            AND sfa12=g_sfa.sfa12
            AND sfa012 = g_sfa.sfa012         #FUN-A60027
            AND sfa013 = g_sfa.sfa013         #FUN-A60027 
         LET g_sfa.sfa161=l_sfa161*g_sfa.sfa28
       END IF
#TQC-840017--end-----
      LET sr.tmp04 = g_outqty*g_sfa.sfa161      #來源工單可退數量
      IF sr.tmp04 > g_sfa.sfa06 THEN
          LET sr.tmp04 = g_sfa.sfa06            #來源工單的已發數量 
      END IF
      LET sr.tmp05 = 0                          #目的工單需求數量
      LET sr.tmp10 = g_sfa.sfa062               #超領數量 
      LET sr.tmp11 = g_sfa.sfa06 + g_sfa.sfa062 #(已發+超領)
      LET sr.tmp27 = g_sfa.sfa27                #被替代料號   #MOD-A40021 add
      SELECT ima108 INTO l_ima108 FROM ima_file
       WHERE ima01 = sr.tmp01
      IF l_ima108 = 'Y' THEN
          LET sr.tmp97 = g_sfs07b #倉
          LET sr.tmp98 = g_sfs08b #儲
          LET sr.tmp99 = g_sfs09b #批
      ELSE
          LET sr.tmp97 = g_sfs07a #倉
          LET sr.tmp98 = g_sfs08a #儲
          LET sr.tmp99 = g_sfs09a #批
      END IF
      LET sr.tmp12 = g_sfa.sfa012     #FUN-A60027
      LET sr.tmp13 = g_sfa.sfa013     #FUN-A60027 
      INSERT INTO p510_temp VALUES (sr.*) 
      IF STATUS THEN
         LET g_success = 'N'
         ERROR "INSERT INTO p510_temp ERROR:",sqlca.sqlcode
         RETURN
      END IF
#No.CHI-980025 --Begin
      SELECT ima25,ima918,ima921 INTO l_ima25,l_ima918,l_ima921
        FROM ima_file
       WHERE ima01 = g_sfa.sfa03
         AND imaacti = "Y"
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         DECLARE p510_gen_cs3 CURSOR FOR
          SELECT sfe_file.*,sfp06 FROM sfe_file,sfp_file
           WHERE sfe01=g_sfa.sfa01
             AND sfe07=g_sfa.sfa03
             AND sfp01=sfe02
             AND sfp06 IN ('1','2','3','6','7','8','D')              #FUN-C70014 add 'D'
         FOREACH p510_gen_cs3 INTO l_sfe.*,l_sfp06
            SELECT img09 INTO g_img09 FROM img_file
             WHERE img01=l_sfe.sfe07 AND img02=l_sfe.sfe08
               AND img03=l_sfe.sfe09 AND img04=l_sfe.sfe10
            CALL s_umfchk(l_sfe.sfe07,l_sfe.sfe17,g_img09)
                 RETURNING l_i,l_fac
            IF l_i = 1 THEN LET l_fac = 1 END IF
            LET l_amt = 0
            DECLARE p510_gen_cs4 CURSOR FOR
             SELECT * FROM rvbs_file
              WHERE rvbs01=l_sfe.sfe02
                AND rvbs02=l_sfe.sfe28
                AND rvbs08=' '
            FOREACH p510_gen_cs4 INTO l_rvbs.*
#因發料單可能會用不同庫存單位之倉庫發料，
#故先將批/序號資料統一轉換成ima25(料件庫存單位）
               IF l_ima25 <> g_img09 THEN
                  LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_fac
               END IF
               IF l_sfp06='1' OR l_sfp06='2' OR l_sfp06='3' OR l_sfp06='D' THEN            #FUN-C70014 add l_sfp06='D'
                  LET l_amt=l_rvbs.rvbs06
               ELSE
                  LET l_amt=-1*l_rvbs.rvbs06
               END IF
                                                                                                                                    
                  SELECT COUNT(*) INTO l_cnt
                    FROM p510_rvbs
                   WHERE rvbs021= l_rvbs.rvbs021
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs05 = l_rvbs.rvbs05
                  IF l_cnt>0 THEN
                     UPDATE p510_rvbs SET rvbs06=rvbs06+l_amt
                      WHERE rvbs021= l_rvbs.rvbs021
                        AND rvbs03 = l_rvbs.rvbs03
                        AND rvbs04 = l_rvbs.rvbs04
                        AND rvbs05 = l_rvbs.rvbs05
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","p510_rvbs","","",SQLCA.sqlcode,"","",1)
                        RETURN
                     END IF
                  ELSE
                     INSERT INTO p510_rvbs
                     VALUES(l_rvbs.rvbs03,l_rvbs.rvbs04,
                            l_rvbs.rvbs05,l_amt,0,l_rvbs.rvbs021)
                     IF SQLCA.sqlcode THEN
                        CALL cl_err3("ins","p510_rvbs","","",SQLCA.sqlcode,"","",1)
                        LET g_success = 'N'
                        RETURN
                     END IF
                  END IF
            END FOREACH
         END FOREACH
      END IF
#No.CHI-980025 --End
   END FOREACH
   #====>目的工單
   DECLARE p510_gen_cs2 CURSOR FOR
      SELECT * FROM sfa_file 
       WHERE sfa01 = g_sfb01b #目的工單
         AND sfa05>0
   FOREACH p510_gen_cs2 INTO g_sfa.*
      INITIALIZE  sr.*  TO  NULL
      SELECT * INTO sr.* FROM p510_temp
         WHERE tmp01 = g_sfa.sfa03 #料號
           AND tmp02 = g_sfa.sfa08 #作業編號 
           AND tmp03 = g_sfa.sfa12 #單位
           AND tmp12 = g_sfa.sfa012  #FUN-A60095
           AND tmp13 = g_sfa.sfa013  #FUN-A60095
         LET l_needqty = g_sfa.sfa161*g_outqty
      IF STATUS THEN
         LET sr.tmp00 = '3'              #目的工單有
         LET sr.tmp01 = g_sfa.sfa03
         LET sr.tmp02 = g_sfa.sfa08
         LET sr.tmp03 = g_sfa.sfa12
         LET sr.tmp12 = g_sfa.sfa012     #FUN-A60095
         LET sr.tmp13 = g_sfa.sfa013     #FUN-A60095 
         LET sr.tmp04 = 0   #來源工單可退數量
         #目的工單需求數量:
         #當狀態='1'共用料或'3'僅目的工單有
         #default=擬撥出套數*qpa,但不可大於目的工單的未發數量 
#TQC-840017--begin---
         IF g_sfa.sfa26='S' OR g_sfa.sfa26='U' OR g_sfa.sfa26 = 'Z' THEN  #FUN-A20037 add 'Z'
            SELECT sfa161 INTO l_sfa161 FROM sfa_file
             where sfa01=g_sfb01a
               AND sfa03=g_sfa.sfa27
               AND sfa08=g_sfa.sfa08
               AND sfa12=g_sfa.sfa12
               AND sfa012 = g_sfa.sfa012   #FUN-A60027
               AND sfa013 = g_sfa.sfa013   #FUN-A60027 
            LET g_sfa.sfa161=l_sfa161*g_sfa.sfa28
          END IF
#TQC-840017--end-----
         LET sr.tmp05 = g_outqty*g_sfa.sfa161 
         IF sr.tmp05 > (g_sfa.sfa05-g_sfa.sfa06) THEN
             LET sr.tmp05 = g_sfa.sfa05-g_sfa.sfa06 #目的工單的未發數量
         END IF
         LET sr.tmp10 = 0                           #超領量
         LET sr.tmp11 = g_sfa.sfa06 + g_sfa.sfa062  #(已發+超領)
         LET sr.tmp27 = g_sfa.sfa27                 #被替代料號   #MOD-A40021 add
         SELECT ima108 INTO l_ima108 FROM ima_file
          WHERE ima01 = sr.tmp01
         IF l_ima108 = 'Y' THEN
             LET sr.tmp97 = g_sfs07b #倉
             LET sr.tmp98 = g_sfs08b #儲
             LET sr.tmp99 = g_sfs09b #批
         ELSE
             LET sr.tmp97 = g_sfs07a #倉
             LET sr.tmp98 = g_sfs08a #儲
             LET sr.tmp99 = g_sfs09a #批
         END IF
         INSERT INTO p510_temp VALUES (sr.*)
         IF STATUS THEN
             ERROR "INSERT INTO p510_temp ERROR:",sqlca.sqlcode
             LET g_success = 'N' 
             RETURN 
         END IF
      ELSE
         #目的工單需求數量:
         #當狀態='1'共用料或'3'僅目的工單有
         #default=擬撥出套數*qpa,但不可大於目的工單的未發數量 
#TQC-840017--begin---
         IF g_sfa.sfa26='S' OR g_sfa.sfa26='U' OR g_sfa.sfa26 = 'Z' THEN   #FUN-A20037 add 'Z'
            SELECT sfa161 INTO l_sfa161 FROM sfa_file
             where sfa01=g_sfb01a
               AND sfa03=g_sfa.sfa27
               AND sfa08=g_sfa.sfa08
               AND sfa12=g_sfa.sfa12
               AND sfa012 = g_sfa.sfa012    #FUN-A60027
               AND sfa013 = g_sfa.sfa013    #FUN-A60027 
            LET g_sfa.sfa161=l_sfa161*g_sfa.sfa28
          END IF
#TQC-840017--end-----
         LET sr.tmp05 = g_outqty*g_sfa.sfa161 
         IF sr.tmp05 > (g_sfa.sfa05-g_sfa.sfa06) THEN
             LET sr.tmp05 = g_sfa.sfa05-g_sfa.sfa06 #目的工單的未發數量
         END IF
         UPDATE p510_temp SET tmp00 = '1',     #共用料
                              tmp05 = sr.tmp05 #目的工單需求數量
            WHERE tmp01 = g_sfa.sfa03 
              AND tmp02 = g_sfa.sfa08
              AND tmp03 = g_sfa.sfa12
         IF STATUS THEN LET g_success = 'N' RETURN END IF
      END IF
   END FOREACH
   UPDATE p510_temp SET tmp06=tmp04 # 來源工單實際移轉量
                                    #=來源工單可退數量 
   UPDATE p510_temp SET tmp06=tmp11 #實際移轉量不可大於已發+超領
     WHERE tmp06 > tmp11
END FUNCTION
#NO:6968--------------END
 
 
#-------------------------------------------------------------------------
 
Function p510_gen_pqs()
   DEFINE g_tmp1 RECORD
          tmp00 LIKE type_file.chr1000,#No.FUN-680121 VARCHAR(1) #旗標, 1:來源工單與目的工單之共用料
                                                             #      2:來源工單有但目的工單無
                                                             #      3:來源工單無但目的工單有
          tmp01 LIKE ima_file.ima01,  #料號  #No.MOD-490217
          tmp02 LIKE gem_file.gem01,  #No.FUN-680121 VARCHAR(06)#作業編號
          tmp03 LIKE gfe_file.gfe01,  #No.FUN-680121 VARCHAR(04)#單位
#         tmp04 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)  #來源工單撥出數量
#         tmp05 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)
#         tmp10 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)  #超領
#         tmp06 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)  #實際撥出數量
          tmp04 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp05 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp10 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp06 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp27 LIKE ima_file.ima01,  #MOD-A40021 add           #被替代料號
          tmp97 LIKE imd_file.imd01,  #No.FUN-680121 VARCHAR(10)#倉
          tmp98 LIKE imd_file.imd01,  #No.FUN-680121 VARCHAR(10)#儲
          tmp99 LIKE aag_file.aag01,  #No.FUN-680121 VARCHAR(24)#批
#         tmp11 LIKE ima_file.ima26   #No.FUN-680121 DEC(15,3)  #已發+超領
#         tmp11 LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044    #FUN-A60027
          tmp11 LIKE type_file.num15_3,   #FUN-A60027
          tmp12 LIKE sfa_file.sfa012,     #FUN-A60027
          tmp13 LIKE sfa_file.sfa013      #FUN-A60027
       END RECORD
   DEFINE l_t1      LIKE oay_file.oayslip#No.FUN-680121 VARCHAR(5) #No.FUN-550067    
   DEFINE l_sno     LIKE oea_file.oea01  #No.FUN-680121 VARCHAR(16)#No.FUN-550067 
   DEFINE l_itno    LIKE type_file.num5  #No.FUN-680121 SMALLINT
#  DEFINE l_qty     LIKE ima_file.ima26  #No.FUN-680121 DEC(15,3)
   DEFINE l_qty     LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE l_sfs RECORD LIKE sfs_file.*
   DEFINE l_sfsi    RECORD LIKE sfsi_file.*    #FUN-B70074
   DEFINE l_ima108  LIKE ima_file.ima108 #BugNo:6549
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067          #No.FUN-680121 SMALLINT
   #No.FUN-580132  --begin
   DEFINE  l_ima25    LIKE ima_file.ima25
   DEFINE  l_ima55    LIKE ima_file.ima55
   DEFINE  l_ima906   LIKE ima_file.ima906
   DEFINE  l_ima907   LIKE ima_file.ima907
   DEFINE  l_factor   LIKE img_file.img21 
   DEFINE  l_cnt      LIKE type_file.num5          #No.FUN-680121 SMALLINT
   #No.FUN-580132  --end   
   DEFINE l_sfpmksg   LIKE sfp_file.sfpmksg #FUN-AB0001 add
   DEFINE l_sfp15     LIKE sfp_file.sfp15   #FUN-AB0001 add
   DEFINE l_sfp16     LIKE sfp_file.sfp16   #FUN-AB0001 add

        LET l_itno = 1
 
       #No.FUN-550067 --start--                                                                                                       
        LET l_t1 = g_sfp01a[1,g_doc_len]
        CALL s_auto_assign_no("asf",l_t1,TODAY,"4","","","","","") 
        RETURNING li_result,l_sno                                                    
      IF (NOT li_result) THEN           
         LET g_success = 'N'
         RETURN
      END IF
#   IF cl_null(g_sfp01a[5,10]) THEN
#      LET l_t1 = g_sfp01a[1,3]
#      CALL s_smyauno(l_t1,TODAY) RETURNING g_i,l_sno #產生退料單據號碼
#      IF g_i THEN
#        LET g_success = 'N'
#        RETURN
#     END IF
      #No.FUN-550067 ---end---  
      LET  g_sfp01a = l_sno
 
   #NO:6968 退料單號
   INITIALIZE l_sfs.* TO NULL
   LET l_sfs.sfs01 = g_sfp01a
   LET l_itno = 0
   DECLARE ptmp1 CURSOR FOR 
     SELECT * FROM p510_temp
      WHERE tmp00 IN ('1','2') 
        AND tmp04 > 0
   LET g_gent1 = 'N'
   FOREACH ptmp1 INTO g_tmp1.*
      #NO:6968 挪料底稿的實際移轉量<=0 則不產生發退料資料
      IF g_tmp1.tmp06 <= 0 THEN CONTINUE FOREACH END IF
 
      INITIALIZE l_sfs.* TO NULL    #No.TQC-940129 add
      LET l_sfs.sfs01 = g_sfp01a    #No.TQC-940129 add
      LET l_itno = l_itno + 1
      LET l_sfs.sfs02 = l_itno
      LET l_sfs.sfs03 = g_sfb01a
      LET l_sfs.sfs04 = g_tmp1.tmp01 #料號
      LET l_sfs.sfs05 = g_tmp1.tmp06 #數量NO:6968以來源工單實際移轉量
      LET l_sfs.sfs06 = g_tmp1.tmp03 #單位
      LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)    #FUN-BB0084
      LET l_sfs.sfs07 = g_tmp1.tmp97 #倉 NO:6968
      LET l_sfs.sfs08 = g_tmp1.tmp98 #儲
      LET l_sfs.sfs09 = g_tmp1.tmp99 #批
      IF g_tmp1.tmp02 IS NULL THEN 
          LET g_tmp1.tmp02 = ' ' 
      END IF 
      LET l_sfs.sfs10 = g_tmp1.tmp02 #作業編號
      LET l_sfs.sfs27 = g_tmp1.tmp27 #被替代料號   #MOD-A40021 add
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
         #No.MOD-590111  --begin
         IF l_ima906='2' THEN
            CALL s_chk_imgg(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
                            l_sfs.sfs09,l_sfs.sfs30)
                 RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
                               l_sfs.sfs09,l_sfs.sfs30,l_sfs.sfs31,
                               l_sfs.sfs01,l_sfs.sfs02,0)
                    RETURNING g_flag
               IF g_flag = 1 THEN
                  LET g_success = 'N' RETURN 
               END IF
            END IF
         END IF
         #No.MOD-590111  --end   
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
            LET l_sfs.sfs35=s_digqty(l_sfs.sfs35,l_sfs.sfs33)   #FUN-BB0084
         END IF
         #No.MOD-590111  --begin
         IF l_ima906 MATCHES '[23]' THEN
            CALL s_chk_imgg(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
                            l_sfs.sfs09,l_sfs.sfs33)
                 RETURNING g_flag
            IF g_flag = 1 THEN
               CALL s_add_imgg(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
                               l_sfs.sfs09,l_sfs.sfs33,l_sfs.sfs34,
                               l_sfs.sfs01,l_sfs.sfs02,0)
                    RETURNING g_flag
               IF g_flag = 1 THEN
                  LET g_success = 'N' RETURN 
               END IF
            END IF
         END IF
         #No.MOD-590111  --end   
         IF l_ima906 = '1' THEN
            LET l_sfs.sfs33=NULL
            LET l_sfs.sfs34=NULL
            LET l_sfs.sfs35=NULL
         END IF
      END IF
      #No.FUN-580132  --end  
      #FUN-670103...............begin
      IF g_aaz.aaz90='Y' THEN
         SELECT sfb98 INTO l_sfs.sfs930 FROM sfb_file
                                       WHERE sfb01=g_sfb01a
         IF SQLCA.sqlcode THEN
            LET l_sfs.sfs930=NULL
         END IF
      END IF
      #FUN-670103...............end
      #No.MOD-8B0086 add --begin
      IF cl_null(l_sfs.sfs27) THEN
         LET l_sfs.sfs27 = l_sfs.sfs04
      END IF
      #No.MOD-8B0086 add --end
 
      LET l_sfs.sfsplant = g_plant #FUN-980008 add
      LET l_sfs.sfslegal = g_legal #FUN-980008 add
      LET l_sfs.sfs012 = g_tmp1.tmp12   #FUN-A60027
      LET l_sfs.sfs013 = g_tmp1.tmp13   #FUN-A60027
      #No.FUN-A70131--begin
      IF cl_null(l_sfs.sfs012) THEN 
         LET l_sfs.sfs012=' '
      END IF 
      IF cl_null(l_sfs.sfs013) THEN 
         LET l_sfs.sfs013=0
      END IF 
      #No.FUN-A70131--end
      LET l_sfs.sfs014 = ' '      #FUN-C70014 add
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
         ERROR "INSERT INTO sfs_file ERROR:",sqlca.sqlcode
         LET g_success = 'N' RETURN 
      ELSE
#FUN-B70074 --------------Begin----------------
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfsi.* TO NULL
            LET l_sfsi.sfsi01 = l_sfs.sfs01
            LET l_sfsi.sfsi02 = l_sfs.sfs02
            IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
               LET g_success='N'
               RETURN
            END IF
         END IF
#FUN-B70074 --------------End------------------
          LET g_gent1 = 'Y' #Y:產生退料單
      END IF
      CALL p510_insrvbs(l_sfs.sfs04,l_sfs.sfs01,l_sfs.sfs02,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,'1')           #CHI-980025
   END FOREACH
 
   IF g_gent1 = 'Y' THEN #Y:產生退料單
       #FUN-AB0001--add---str---
       IF g_csure = 'Y' THEN
           LET l_sfpmksg = 'N' #是否簽核
           LET l_sfp15 = '1'            #簽核狀況
       ELSE
           LET l_sfpmksg = g_smy.smyapr #是否簽核
           LET l_sfp15 = '0'            #簽核狀況
       END IF
       LET l_sfp16 = g_user         #申請人
       #FUN-AB0001--add---end---

       INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp08, #No.MOD-470041
                            sfp09,sfp10,sfpuser,sfpgrup,sfpmodu,sfpdate,sfpconf, #FUN-660106 
                            sfpplant,sfplegal,sfpmksg,sfp15,sfp16)    #FUN-980008 add  #FUN-AB0001 add:sfpmksg,sfp15,sfp16
             #--------------No.MOD-6B0070 modify
             #VALUES (g_sfp01a,TODAY,TODAY,'N','N','6',null,null,'N',NULL,g_user,g_grup,NULL,NULL,'N') #FUN-660106
             #VALUES (g_sfp01a,TODAY,TODAY,'N','N','6',null,null,'N',NULL,g_user,g_grup,NULL,NULL,g_csure,   #MOD-D30178 mark
              VALUES (g_sfp01a,TODAY,TODAY,'N','N','6',g_grup,null,'N',NULL,g_user,g_grup,NULL,NULL,g_csure,   #MOD-D30178 add
                      g_plant,g_legal,l_sfpmksg,l_sfp15,l_sfp16)    #FUN-980008 add  #FUN-AB0001 add:sfpmksg,sfp15,sfp16
             #--------------No.MOD-6B0070 end
       IF STATUS THEN
          ERROR "INSERT INTO sfp_file ERROR:",sqlca.sqlcode
          LET g_success = 'N'
          RETURN g_success
       END IF

       #工單發料底稿單身檔
       INSERT INTO sfq_file(sfq01,sfq02,sfq03,sfq04,sfq05,sfq06,sfq012,sfq014,  #No.MOD-470041    #FUN-B20095 add sfq012  #TQC-B70074 mark sfq012  #FUN-C70014 add sfq014
                            sfqplant,sfqlegal)    #FUN-980008 add
              VALUES (g_sfp01a,g_sfb01a,g_outqty,' ',TODAY,NULL,' ',' ',  #MOD-870001          #FUN-B20095  #TQC-B70074 mark   #FUN-C70014 add ' '
                      g_plant,g_legal)      #FUN-980008 add
             #VALUES (g_sfp01a,g_sfb01a,g_outqty,' ',NULL,NULL)   #MOD-870001 mark
       IF STATUS THEN 
          ERROR "INSERT INTO sfq_file ERROR:",sqlca.sqlcode
          LET g_success = 'N' RETURN END IF
   ELSE
       LET g_sfp01a = NULL
   END IF

   LET  l_itno = 1

   IF NOT cl_null(g_sfb01b) THEN
       #No.FUN-550067 --start--                                                                                                       
        LET l_t1 = g_sfp01b[1,g_doc_len]
        CALL s_auto_assign_no("asf",l_t1,TODAY,"3","","","","","") 
        RETURNING li_result,l_sno                                                    
#      IF cl_null(g_sfp01b[5,10]) THEN
#         LET l_t1 = g_sfp01b[1,3]
#         CALL s_smyauno(l_t1,TODAY) RETURNING g_i,l_sno #產生領料單據號碼
         LET g_sfp01b = l_sno
#     END IF
         #No.FUN-550067 ---end--- 
      #NO:6968 領料單號
      LET g_sql="SELECT * FROM p510_temp WHERE tmp06 > 0 AND tmp05 > 0 "
      PREPARE ptmp2_ppp FROM g_sql
      IF STATUS THEN CALL cl_err('ptmp2_ppp:',STATUS,3) END IF
      DECLARE ptmp2 CURSOR FOR ptmp2_ppp
      LET g_gent2 = 'N' #Y:產生領料單
      FOREACH ptmp2 INTO g_tmp1.*
         #NO:6968 挪料底稿的實際移轉量<=0 則不產生發退料資料
         IF g_tmp1.tmp06 <= 0 THEN CONTINUE FOREACH END IF
 
         INITIALIZE l_sfs.* TO NULL    #No.TQC-940129 add
         LET l_itno = l_itno + 1
         LET l_sfs.sfs01 = g_sfp01b
         LET l_sfs.sfs02 = l_itno
         LET l_sfs.sfs03 = g_sfb01b
         LET l_sfs.sfs04 = g_tmp1.tmp01 #料號
         #NO:6968-------------------------------------------
         #當狀態='1' 共用料
         #取"來源工單實際移轉數量"和"目的工單需求數量" 較小者,
         #產生目的工單的成套發料單
         #(因為成套發料的發料量,不可超過備料的未發料量)
         LET l_sfs.sfs05 = g_tmp1.tmp06     #來源工單實際移轉數量
         IF g_tmp1.tmp05 < g_tmp1.tmp06 THEN
             LET l_sfs.sfs05 = g_tmp1.tmp05 #目的工單需求數量
         END IF
         #NO:6968-------------------------------------------
         LET l_sfs.sfs06 = g_tmp1.tmp03 #單位
         LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)    #FUN-BB0084
         IF cl_null(g_tmp1.tmp02) THEN LET g_tmp1.tmp02 = ' ' END IF 
         IF cl_null(g_tmp1.tmp97) THEN LET g_tmp1.tmp97 = ' ' END IF #倉 NO:6968
         IF cl_null(g_tmp1.tmp98) THEN LET g_tmp1.tmp98 = ' ' END IF #儲
         IF cl_null(g_tmp1.tmp99) THEN LET g_tmp1.tmp99 = ' ' END IF #批
         LET l_sfs.sfs07 = g_tmp1.tmp97 #倉
         LET l_sfs.sfs08 = g_tmp1.tmp98 #儲
         LET l_sfs.sfs09 = g_tmp1.tmp99 #批
         LET l_sfs.sfs10 = g_tmp1.tmp02 #作業編號
         LET l_sfs.sfs27 = g_tmp1.tmp27 #被替代料號   #MOD-A40021 add
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
            #No.MOD-590111  --begin
            IF l_ima906='2' THEN
               CALL s_chk_imgg(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
                               l_sfs.sfs09,l_sfs.sfs30)
                    RETURNING g_flag
               IF g_flag = 1 THEN
                  CALL s_add_imgg(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
                                  l_sfs.sfs09,l_sfs.sfs30,l_sfs.sfs31,
                                  l_sfs.sfs01,l_sfs.sfs02,0)
                       RETURNING g_flag
                  IF g_flag = 1 THEN
                     LET g_success = 'N' RETURN 
                  END IF
               END IF
            END IF
            #No.MOD-590111  --end   
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
            #No.MOD-590111  --begin
            IF l_ima906 MATCHES '[23]' THEN
               CALL s_chk_imgg(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
                               l_sfs.sfs09,l_sfs.sfs33)
                    RETURNING g_flag
               IF g_flag = 1 THEN
                  CALL s_add_imgg(l_sfs.sfs04,l_sfs.sfs07,l_sfs.sfs08,
                                  l_sfs.sfs09,l_sfs.sfs33,l_sfs.sfs34,
                                  l_sfs.sfs01,l_sfs.sfs02,0)
                       RETURNING g_flag
                  IF g_flag = 1 THEN
                     LET g_success = 'N' RETURN 
                  END IF
               END IF
            END IF
            #No.MOD-590111  --end   
            IF l_ima906 = '1' THEN
               LET l_sfs.sfs33=NULL
               LET l_sfs.sfs34=NULL
               LET l_sfs.sfs35=NULL
            END IF
         END IF
         #No.FUN-580132  --end  
         #FUN-670103...............begin
         IF g_aaz.aaz90='Y' THEN
            SELECT sfb98 INTO l_sfs.sfs930 FROM sfb_file
                                          WHERE sfb01=g_sfb01a
            IF SQLCA.sqlcode THEN
               LET l_sfs.sfs930=NULL
            END IF
         END IF
         #FUN-670103...............end
         #No.MOD-8B0086 add --begin
         IF cl_null(l_sfs.sfs27) THEN
            LET l_sfs.sfs27 = l_sfs.sfs04
         END IF
         #No.MOD-8B0086 add --end
 
         LET l_sfs.sfsplant = g_plant #FUN-980008 add
         LET l_sfs.sfslegal = g_legal #FUN-980008 add
         LET l_sfs.sfs012 = g_tmp1.tmp12     #FUN-A60027
         LET l_sfs.sfs013 = g_tmp1.tmp13     #FUN-A60027
         #No.FUN-A70131--begin
         IF cl_null(l_sfs.sfs012) THEN 
            LET l_sfs.sfs012=' '
         END IF 
         IF cl_null(l_sfs.sfs013) THEN 
            LET l_sfs.sfs013=0
         END IF 
         #No.FUN-A70131--end 
         LET l_sfs.sfs014 = ' '      #FUN-C70014 add
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
         IF STATUS 
         THEN
              LET g_success = 'N' 
              ERROR "INSERT INTO sfs_file ERROR:",sqlca.sqlcode
              RETURN 
         ELSE
#FUN-B70074 --------------Begin----------------
            IF NOT s_industry('std') THEN
               INITIALIZE l_sfsi.* TO NULL
               LET l_sfsi.sfsi01 = l_sfs.sfs01
               LET l_sfsi.sfsi02 = l_sfs.sfs02
               IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
                  LET g_success='N'
                  RETURN
               END IF
            END IF
#FUN-B70074 --------------End------------------
             LET g_gent2 = 'Y' #Y:產生領料單
         END IF
         CALL p510_insrvbs(l_sfs.sfs04,l_sfs.sfs01,l_sfs.sfs02,l_sfs.sfs07,l_sfs.sfs08,l_sfs.sfs09,'2')     #CHI-980025
      END FOREACH
      IF g_gent2 = 'Y' THEN
           #FUN-AB0001--add---str---
           IF g_csure = 'Y' THEN
               LET l_sfpmksg = 'N'          #是否簽核
               LET l_sfp15 = '1'            #簽核狀況
           ELSE
               LET l_sfpmksg = g_smy.smyapr #是否簽核
               LET l_sfp15 = '0'            #簽核狀況
           END IF
           LET l_sfp16 = g_user             #申請人
           #FUN-AB0001--add---end---
           INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp08, #No.MOD-470041 
                                sfp09,sfp10,sfpuser,sfpgrup,sfpmodu,sfpdate,sfpconf, #FUN-660106
                                sfpplant,sfplegal,sfpmksg,sfp15,sfp16)    #FUN-980008 add #FUN-AB0001 add:,sfpmksg,sfp15,sf16
              #-----------------No.MOD-6B0070 modify
              #VALUES (g_sfp01b,TODAY,TODAY,'N','N','1',null,null,'N',NULL,g_user,g_grup,NULL,NULL,'N') #FUN-660106
              #VALUES (g_sfp01b,TODAY,TODAY,'N','N','1',null,null,'N',NULL,g_user,g_grup,NULL,NULL,g_csure,    #MOD-D30178 mark
               VALUES (g_sfp01b,TODAY,TODAY,'N','N','1',g_grup,null,'N',NULL,g_user,g_grup,NULL,NULL,g_csure,  #MOD-D30178 add 
                       g_plant,g_legal,l_sfpmksg,l_sfp15,l_sfp16)    #FUN-980008 add #FUN-AB0001 add:l_sfpmksg,l_sfp15,l_sfp16
              #-----------------No.MOD-6B0070 end
          IF STATUS THEN LET g_success = 'N' RETURN END IF
           INSERT INTO sfq_file(sfq01,sfq02,sfq03,sfq04,sfq05,sfq06,sfq012,sfq014,  #No.MOD-470041    #FUN-B20095 add sfq012 #TQC-B70074 mark sfq012 ##FUN-C70014 add sfq014
                                sfqplant,sfqlegal)    #FUN-980008 add
               VALUES (g_sfp01b,g_sfb01b,g_outqty,' ',TODAY,NULL,' ',' ',    #MOD-870001           #FUN-B20095 #TQC-B70074 mark  #FUN-C70014 add ' '
                       g_plant,g_legal)               #FUN-980008 add
              #VALUES (g_sfp01b,g_sfb01b,g_outqty,' ',NULL,NULL)     #MOD-870001 mark
          IF STATUS THEN LET g_success = 'N' RETURN END IF
      ELSE
          LET g_sfp01b = NULL
      END IF
   END IF
END FUNCTION
#-------------------------------------------------------------------------
 
FUNCTION p510_up_sfba()
   define l_sfb    RECORD like sfb_file.*
   define l_sfb08_o       like sfb_file.sfb08  #舊生產數量
   define l_sfb08_n       like sfb_file.sfb08  #新生產數量
   DEFINE l_yymm          LIKE type_file.chr4    #No.FUN-680121 VARCHAR(04) 
 
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01 = g_sfb01a
 
   IF STATUS THEN LET g_success = 'N' RETURN END IF
 
   IF l_sfb.sfb08 IS NULL THEN
      LET l_sfb.sfb08 = 0
   END IF
 
   LET l_sfb08_o = l_sfb.sfb08
   LET l_sfb08_n = l_sfb08_o - g_outqty
#是否變更生產數(Y/N):[a]==>取消 #NO:6968
#  IF g_asure='Y' THEN
#     UPDATE sfb_file SET sfb08 = l_sfb08_n WHERE sfb01 = g_sfb01a
#     IF STATUS THEN LET g_success = 'N' RETURN END IF
#     UPDATE sfa_file SET sfa04 = sfa04 * (l_sfb.sfb08-g_outqty)/l_sfb.sfb08,
#        sfa05 = sfa05 * (l_sfb.sfb08-g_outqty)/l_sfb.sfb08
#        WHERE sfa01 = g_sfb01a 
#        # AND (sfa91 IS NULL OR sfa91<>"2") #BugNo:6587
#     IF STATUS THEN LET g_success = 'N' RETURN END IF
#  END IF
 
   LET g_sfm.sfm03=g_today
   LET l_yymm[1,2] = (YEAR(g_sfm.sfm03) MOD 100) USING '&&'
   LET l_yymm[3,4] = MONTH(g_sfm.sfm03) USING '&&'
   SELECT MAX(sfm00) INTO g_sfm.sfm00 FROM sfm_file
      WHERE sfm00[1,4]=l_yymm
   IF STATUS THEN
      LET g_sfm.sfm00=l_yymm,"0001"
   ELSE
      IF g_sfm.sfm00 IS NULL THEN LET g_sfm.sfm00[5,8]=l_yymm,'0000' END IF #No.MOD-610109
      LET g_sfm.sfm00=l_yymm,(g_sfm.sfm00[5,8]+1) USING '&&&&'
   END IF
   SELECT MAX(sfm02) INTO g_sfm.sfm02 FROM sfm_file
      WHERE sfm01=g_sfb01a
   IF g_sfm.sfm02 IS NULL THEN LET g_sfm.sfm02 = 0 END IF
   LET g_sfm.sfm02=g_sfm.sfm02+1
   LET g_sfm.sfm01=g_sfb01a
   LET g_sfm.sfm04=TIME
   LET g_sfm.sfm05=l_sfb08_o
  #LET g_sfm.sfm06=l_sfb08_n #NO:6968
   LET g_sfm.sfm06=l_sfb08_o #變更後生產數量不要更動
   LET g_sfm.sfm07=g_sfp01a 
   LET g_sfm.sfm08=g_sfb01b
   LET g_sfm.sfm09=g_sfp01b
   LET g_sfm.sfm10='1'
   LET g_sfm.sfm13 = NULL     #NO:6968
   LET g_sfm.sfm14 = NULL     #NO:6968
   LET g_sfm.sfm15 = NULL     #NO:6968
   LET g_sfm.sfm16 = g_outqty #NO:6968 挪料套數
   LET g_sfm.sfmuser=g_user
   LET g_sfm.sfmplant = g_plant #FUN-980008 add
   LET g_sfm.sfmlegal = g_legal #FUN-980008 add
 
   LET g_sfm.sfmoriu = g_user      #No.FUN-980030 10/01/04
   LET g_sfm.sfmorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO sfm_file VALUES (g_sfm.*)
   IF STATUS 
   THEN 
      ERROR "INSERT INTO sfm_file ERROR:",sqlca.sqlcode
      LET g_success = 'N' RETURN END IF
   INITIALIZE g_sfn.* TO NULL
   LET g_sfn.sfn01=g_sfm.sfm00
   LET g_sfn.sfn02=0
   DECLARE p510_sfn_cs CURSOR FOR
      SELECT * FROM p510_temp
   FOREACH p510_sfn_cs INTO g_tmp.*
      LET g_sfn.sfn02=g_sfn.sfn02+1
      LET g_sfn.sfn03=g_sfb01a    #來源工單 NO:6968
      LET g_sfn.sfn04=g_tmp.tmp01
      IF g_tmp.tmp02 IS NULL THEN LET g_tmp.tmp02 = ' ' END IF 
      LET g_sfn.sfn05=g_tmp.tmp02 #作業編號
      LET g_sfn.sfn06=g_tmp.tmp03
      LET g_sfn.sfn07=g_tmp.tmp04
      LET g_sfn.sfn08=g_tmp.tmp05
      LET g_sfn.sfn10=g_tmp.tmp06
      LET g_sfn.sfn11=g_tmp.tmp00
      LET g_sfn.sfn12=g_tmp.tmp97 #倉   NO:6968
      LET g_sfn.sfn13=g_tmp.tmp98 #儲   NO:6968
      LET g_sfn.sfn14=g_tmp.tmp99 #批   NO:6968
      LET g_sfn.sfn15=g_tmp.tmp10 #超領 NO:6968
      LET g_sfn.sfnplant = g_plant #FUN-980008 add
      LET g_sfn.sfnlegal = g_legal #FUN-980008 add
      INSERT INTO sfn_file VALUES(g_sfn.*)
      IF STATUS THEN
         LET g_success='N'
         CALL cl_err('ins sfn:',STATUS,1)
         EXIT FOREACH
      END IF
     #UPDATE sfa_file SET sfa04 = sfa04-g_sfn.sfn07,     NO:6968
     #      sfa05 = sfa05-g_sfn.sfn07
     #   WHERE sfa01 = g_sfb01a 
     #     AND sfa91="2"  #BugNo:6587
     #     AND sfa05>0
     #     AND sfa03 = g_sfn.sfn04 AND sfa08 = g_sfn.sfn05
     #     AND sfa12 = g_sfn.sfn06
     #IF STATUS THEN
     #   LET g_success = 'N'
     #   EXIT FOREACH
     #END IF
#####-------------------------------------
   END FOREACH
END FUNCTION
 
function  tmp_print()
   DEFINE sr RECORD
          tmp00 LIKE type_file.chr1,  #No.FUN-680121 VARCHAR(1) #旗標, 1:來源工單與目的工單之共用料
                                                             #      2:來源工單有但目的工單無
                                                             #      3:來源工單無但目的工單有
          tmp01 LIKE ima_file.ima01,  #料號 No.MOD-490217
          tmp02 LIKE gem_file.gem01,  #No.FUN-680121 VARCHAR(06)#製程序號 chiayi modify
          tmp03 LIKE gfe_file.gfe01,  #No.FUN-680121 VARCHAR(04)#單位
#         tmp04 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)  #來源工單撥出數量
#         tmp05 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)
#         tmp10 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)  #超領
#         tmp06 LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)
          tmp04 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp05 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp10 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp06 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp27 LIKE ima_file.ima01,  #MOD-A40021 add           #被替代料號
          tmp97 LIKE imd_file.imd01,  #No.FUN-680121 VARCHAR(10)#倉
          tmp98 LIKE imd_file.imd01,  #No.FUN-680121 VARCHAR(10)#儲
          tmp99 LIKE aag_file.aag01,  #No.FUN-680121 VARCHAR(24)
#         tmp11 LIKE ima_file.ima26   #No.FUN-680121 DEC(15,3)
          tmp11 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp12 LIKE sfa_file.sfa012,   #FUN-A60095
          tmp13 LIKE sfa_file.sfa013    #FUN-A60095
       END RECORD
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20) # External(Disk) file name
        l_za05          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40) #
        l_chr           LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
    CALL cl_outnam(g_prog) RETURNING l_name
    #FUN-A60095--begin--add---------
    IF g_sma.sma541 = 'Y' THEN   
       LET g_zaa[40].zaa06 = 'N'
       LET g_zaa[41].zaa06 = 'N'
    ELSE
       LET g_zaa[40].zaa06 = 'Y' 
       LET g_zaa[41].zaa06 = 'Y'
    END IF
    #FUN-A60095--end--add------------
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM p510_temp "           # 組合出 SQL 指令
 
    PREPARE p510_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p510_curo CURSOR FOR p510_p1   
         
 
    START REPORT p510_rep TO l_name
 
    FOREACH p510_curo INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT p510_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p510_rep
 
    CLOSE p510_curo
    ERROR ""
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
END FUNCTION
 
FUNCTION p510_b()
# genero  script marked    DEFINE i,j,s_arrno   SMALLINT
    DEFINE s  DYNAMIC ARRAY  OF RECORD       #No.MOD-490301
               tmp01 LIKE ima_file.ima01,   #No.MOD-490217
               ima02 LIKE ima_file.ima02,          #No.FUN-680121 VARCHAR(30)
               ima021 LIKE ima_file.ima021,        #No.FUN-680121 VARCHAR(30)
               tmp12  LIKE sfa_file.sfa012,        #FUN-A60095
               tmp13  LIKE sfa_file.sfa013,        #FUN-A60095
               tmp02 LIKE gem_file.gem01,          #No.FUN-680121 VARCHAR(06) #作業編號
               tmp03 LIKE gfe_file.gfe01,          #No.FUN-680121 VARCHAR(04)
#              tmp04 LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
#              tmp05 LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
#              tmp06 LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
               tmp04 LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
               tmp05 LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
               tmp06 LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
               tmp00 LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#              tmp10 LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3) #超領
               tmp10 LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
               tmp97 LIKE imd_file.imd01,          #No.FUN-680121 VARCHAR(10)  #倉
               tmp98 LIKE imd_file.imd01,          #No.FUN-680121 VARCHAR(10)  #儲
               tmp99 LIKE aag_file.aag01           #No.FUN-680121 VARCHAR(24)  #批
            END RECORD
    DEFINE s_ima108  DYNAMIC ARRAY OF LIKE ima_file.ima108    #No.MOD-490301
#   DEFINE s_tmp11   DYNAMIC ARRAY OF LIKE ima_file.ima26     #No.FUN-680121 DEC(15,3) #No.MOD-490301
#   DEFINE l_tmp06_t  LIKE ima_file.ima26                     #No.FUN-680121 DEC(15,3)
    DEFINE s_tmp11   DYNAMIC ARRAY OF LIKE type_file.num15_3  ###GP5.2  #NO.FUN-A20044
    DEFINE s_tmp27   DYNAMIC ARRAY OF LIKE ima_file.ima01     #MOD-A40021 add #被替代料號
    DEFINE l_tmp06_t LIKE type_file.num15_3                   ###GP5.2  #NO.FUN-A20044
    DEFINE l_rec_b   LIKE type_file.num5                      #No.MOD-490301        #No.FUN-680121 SMALLINT
   DEFINE l_exit_sw  LIKE type_file.chr1                      #No.FUN-680121 VARCHAR(1)
#No.CHI-980025 --Begin
    DEFINE l_ima918  LIKE ima_file.ima918
    DEFINE l_ima921  LIKE ima_file.ima921
#   DEFINE l_tmp06   DYNAMIC ARRAY OF LIKE ima_file.ima26
    DEFINE l_tmp06   DYNAMIC ARRAY OF LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
#No.CHI-980025 --End
 
   LET p_row = 4 LET p_col = 2
   OPEN WINDOW p510_bw AT p_row,p_col
        WITH FORM "asf/42f/asfp5101" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asfp5101")
  
   CALL cl_set_comp_visible("tmp12,tmp13",g_sma.sma541='Y')  #FUN-A60095

    #No.MOD-490301
   CALL s.clear()
   CALL s_ima108.clear()
   CALL s_tmp11.clear()
    #No.MOD-490301(end)
   INITIALIZE l_tmp06 TO NULL    #No.CHI-980025 
 
   WHILE TRUE
      LET l_exit_sw='y'
      DECLARE p510_bcs CURSOR FOR
        #SELECT p510_temp.*,ima02,ima021,ima108
        #NO:6968
         SELECT p510_temp.tmp01,ima02,ima021,p510_temp.tmp12,p510_temp.tmp13, #FUN-A60095
                p510_temp.tmp02,p510_temp.tmp03,
                p510_temp.tmp04,p510_temp.tmp05,p510_temp.tmp06,
                p510_temp.tmp00,p510_temp.tmp10,p510_temp.tmp97,
                p510_temp.tmp98,p510_temp.tmp99,                  
                ima108,p510_temp.tmp11,p510_temp.tmp27   #MOD-A40021 add tmp27
            FROM p510_temp,ima_file
            WHERE tmp01=ima01 
            ORDER BY 1,2
      LET i = 1
      FOREACH p510_bcs INTO s[i].*,s_ima108[i],s_tmp11[i],s_tmp27[i]  #MOD-A40021 add s_tmp27[i]
         LET i=i+1
      END FOREACH
       CALL s.deleteElement(i) #No.MOD-490301
       LET l_rec_b = i - 1     #No.MOD-490301
 
      INPUT ARRAY s WITHOUT DEFAULTS FROM s_tmp.*
           #No.MOD-490301
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,  
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
           #No.MOD-490301


         BEFORE ROW
            LET i = ARR_CURR()
            LET j = SCR_LINE()
            LET l_tmp06_t=s[i].tmp06
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tmp06
         BEFORE FIELD tmp06
            IF s[i].tmp00 = '3' THEN
                #此料號的狀態='3'(僅目的工單有),所以不做挪料處理!
                CALL cl_err(s[i].tmp01,'asf-750',0)
            END IF
         AFTER FIELD tmp06
            
            IF NOT cl_null(s[i].tmp01) THEN
                #NO:6968------------------
                IF s[i].tmp06 < 0 OR
                   cl_null(s[i].tmp06) THEN
                    LET s[i].tmp06=l_tmp06_t
                    DISPLAY s[i].tmp06 TO s_tmp[j].tmp06
                    #本欄位之值,不可空白或小於零,請重新輸入!
                    CALL cl_err(s[i].tmp06,'asf-745',0)
                    NEXT FIELD tmp06
                END IF
            #FUN-BB0084 --------------Begin--------------
                IF NOT cl_null(s[i].tmp06) AND NOT cl_null(s[i].tmp03) THEN
                   LET s[i].tmp06 = s_digqty(s[i].tmp06,s[i].tmp03)
                   DISPLAY s[i].tmp06 TO s_tmp[j].tmp06
                END IF  
            #FUN-BB0084 --------------End----------------
                IF s[i].tmp06 > s[i].tmp04+s[i].tmp10 THEN
                    LET s[i].tmp06=l_tmp06_t
                    DISPLAY s[i].tmp06 TO s_tmp[j].tmp06
                    #來源工單實際移轉量不可大於"來源工單可退數量"+"超領量"   
                    CALL cl_err(s[i].tmp06,'asf-749',0)
                    NEXT FIELD tmp06
                END IF
                #NO:6968------------------END
#No.CHI-980025 --Begin                                                                                                              
                IF s[i].tmp06 > 0 
                   AND (l_tmp06[i]<>s[i].tmp06 OR cl_null(l_tmp06[i])) THEN                                                                   
                   SELECT ima918,ima921 INTO l_ima918,l_ima921                                                                      
                     FROM ima_file                                                                                                  
                    WHERE ima01 = s[i].tmp01                                                                                        
                      AND imaacti = 'Y'                                                                                             
                   IF l_ima918 = 'Y' OR l_ima921 = 'Y' THEN                                                                         
                      CALL p510_b_1(s[i].tmp01,s[i].tmp03,s[i].tmp06)                                                               
                   END IF                                                                                                           
                   LET l_tmp06[i]=s[i].tmp06                                                                                        
                END IF                                                                                                              
#No.CHI-980025 --End
            END IF
         AFTER FIELD tmp97 #倉
          IF s[i].tmp00 != '3' AND s[i].tmp06 > 0 THEN #僅目的工單有
             IF NOT cl_null(s[i].tmp01) THEN
                 IF cl_null(s[i].tmp97) THEN 
                     NEXT FIELD tmp97 
                 END IF
             END IF
             IF s_ima108[i] = 'Y' THEN
                 SELECT imd10 FROM imd_file 
                  WHERE imd01=s[i].tmp97 
                    AND imd10 = 'W'
                     AND imdacti = 'Y' #MOD-4B0169
                 IF SQLCA.sqlcode THEN
                     CALL cl_err('sel imd:','mfg1100',0) 
                     NEXT FIELD tmp97
                 END IF
             ELSE
                 SELECT imd10 FROM imd_file 
                  WHERE imd01=s[i].tmp97 
                    AND imd10 = 'S'
                     AND imdacti = 'Y' #MOD-4B0169
                 IF SQLCA.sqlcode THEN
                     CALL cl_err('sel imd:','mfg1100',0) 
                     NEXT FIELD tmp97
                 END IF
             END IF
             #No.FUN-AA0062  -Begin
             IF NOT s_chk_ware(s[i].tmp97) THEN
                NEXT FIELD tmp97
             END IF 
             #No.FUN-AA0062  -End            
          END IF
         AFTER FIELD tmp98 #儲
            IF cl_null(s[i].tmp98) THEN LET s[i].tmp98 = ' ' END IF
         AFTER FIELD tmp99 #批
            IF cl_null(s[i].tmp99) THEN LET s[i].tmp99 = ' ' END IF
          IF s[i].tmp00 != '3' AND s[i].tmp06 > 0 THEN #僅目的工單有
             SELECT * FROM img_file
              WHERE img01 = s[i].tmp01 #料
                AND img02 = s[i].tmp97 #倉
                AND img03 = s[i].tmp98 #儲
                AND img04 = s[i].tmp99 #批
             IF SQLCA.sqlcode = 100 THEN
                 IF NOT cl_confirm('mfg1401') THEN NEXT FIELD tmp97 END IF
                 CALL s_add_img(s[i].tmp01,s[i].tmp97,s[i].tmp98, s[i].tmp99,
                                null,null,g_sfp.sfp02)
             END IF
          END IF
 
         AFTER ROW
            IF INT_FLAG THEN
               LET s[i].tmp06=l_tmp06_t
               EXIT INPUT
            END IF
         AFTER INPUT 
             FOR i=1 to s.getLength()
                 IF cl_null(s[i].tmp01) THEN EXIT FOR END IF
                 IF s[i].tmp06 <= 0 THEN CONTINUE FOR END IF
                 IF cl_null(s[i].tmp98) THEN LET s[i].tmp98 = ' ' END IF
                 IF cl_null(s[i].tmp99) THEN LET s[i].tmp99 = ' ' END IF
                 IF s[i].tmp00 != '3' AND s[i].tmp06 > 0 THEN #僅目的工單有
                     SELECT * FROM img_file
                      WHERE img01 = s[i].tmp01 #料
                        AND img02 = s[i].tmp97 #倉
                        AND img03 = s[i].tmp98 #儲
                        AND img04 = s[i].tmp99 #批
                     IF SQLCA.sqlcode = 100 THEN
                         #此料號之倉儲批不存在!
                         CALL cl_err(s[i].tmp01,'apm-259',0)
                         NEXT FIELD tmp06
                     END IF
                 END IF
             END FOR
         ON ACTION CONTROLN
            LET l_exit_sw='n' EXIT INPUT
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(tmp97) #倉庫
                  IF s_ima108[i] = 'N' THEN
#                    CALL q_imd(0,0,s[i].tmp97,'S') RETURNING s[i].tmp97
#No.FUN-AA0062  --Begin
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_imd"
#                     LET g_qryparam.default1 = s[i].tmp97
#                    #LET g_qryparam.where = " imd10 = 'S' "
#                      LET g_qryparam.arg1     = 'S'        #倉庫類別 #MOD-4A0213
#                     CALL cl_create_qry() RETURNING s[i].tmp97
                     CALL q_imd_1(FALSE,TRUE,s[i].tmp97,"S","","","") RETURNING s[i].tmp97
#No.FUN-AA0062  --End
                     DISPLAY s[i].tmp97 TO tmp97 #No.MOD-490301
                     NEXT FIELD tmp97
                  ELSE
#                    CALL q_imd(0,0,s[i].tmp97,'W') RETURNING s[i].tmp97
#No.FUN-AA0062  --Begin
#                     CALL cl_init_qry_var()
#                     LET g_qryparam.form = "q_imd"
#                     LET g_qryparam.default1 = s[i].tmp97
#                    #LET g_qryparam.where = " imd10 = 'W' "
#                      LET g_qryparam.arg1     = 'W'        #倉庫類別 #MOD-4A0213
#                     CALL cl_create_qry() RETURNING s[i].tmp97
                      CALL q_imd_1(FALSE,TRUE,s[i].tmp97,"W","","","") RETURNING s[i].tmp97
#No.FUN-AA0062  --End
                      DISPLAY s[i].tmp97 TO tmp97 #No.MOD-490301
                     NEXT FIELD tmp97
                  END IF
               WHEN INFIELD(tmp98) #儲位
#                 CALL q_ime(0,0,s[i].tmp97,s[i].tmp98,'A') RETURNING s[i].tmp98
#No.FUN-AA0062  --Begin
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ime"
#                  LET g_qryparam.default1 = s[i].tmp98
#                   LET g_qryparam.arg1     = s[i].tmp97 #倉庫編號 #MOD-4A0063
#                   LET g_qryparam.arg2     = 'SW'         #倉庫類別 #MOD-4A0063
#                  CALL cl_create_qry() RETURNING s[i].tmp98
                   CALL q_ime_1(FALSE,TRUE,s[i].tmp98,s[i].tmp97,"","","","","") RETURNING s[i].tmp98
#No.FUN-AA0062  --End
                   DISPLAY s[i].tmp98 TO tmp98    #No.MOD-490301
                  NEXT FIELD tmp98
            END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
      
      END INPUT
      IF l_exit_sw='y' THEN EXIT WHILE END IF
   END WHILE
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      #<DEL> 放棄本作業
      CALL cl_err('','mfg1016',1)
      CLOSE WINDOW p510_bw
      RETURN
   END IF
   CLOSE WINDOW p510_bw
# genero  script marked    LET s_arrno=ARR_COUNT()
   DELETE FROM p510_temp WHERE 1=1
   FOR i=1 to s.getLength()
      IF s[i].tmp01 IS NULL THEN CONTINUE FOR END IF
      IF cl_null(s[i].tmp98) THEN LET s[i].tmp98 = ' ' END IF
      IF cl_null(s[i].tmp99) THEN LET s[i].tmp99 = ' ' END IF
      INSERT INTO p510_temp VALUES(s[i].tmp00,s[i].tmp01,s[i].tmp02,
             s[i].tmp03,s[i].tmp04,s[i].tmp05,s[i].tmp10,s[i].tmp06,
             s_tmp27[i],s[i].tmp97,s[i].tmp98,s[i].tmp99,s_tmp11[i],  #MOD-A40021 add s_tmp27[i]
             s[i].tmp12,s[i].tmp13)  #FUN-A60095           
      IF STATUS THEN
         CALL cl_err('ins temp:',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOR
END FUNCTION
 
FUNCTION p510_new_sfa(l_sfs)
   DEFINE l_sfs   RECORD LIKE sfs_file.*
   DEFINE l_sfa   RECORD LIKE sfa_file.*,
          l_sfb08 LIKE sfb_file.sfb08,
          l_ima25 LIKE ima_file.ima25
   DEFINE l_sfai  RECORD LIKE sfai_file.*  #No.FUN-830132
 
   INITIALIZE l_sfa.* TO NULL
   LET l_sfa.sfa01=l_sfs.sfs03
   LET l_sfa.sfa03=l_sfs.sfs04
   LET l_sfa.sfa30=l_sfs.sfs07 #WareHouse
   LET l_sfa.sfa31=l_sfs.sfs08 #Location
   SELECT ima63 INTO l_sfa.sfa12
      FROM ima_file WHERE ima01=l_sfa.sfa03
   SELECT MIN(sfa08) INTO l_sfa.sfa08 FROM sfa_file #製程序號
      WHERE sfa01=l_sfa.sfa01
   SELECT sfb02,sfb05,sfb08 INTO l_sfa.sfa02,l_sfa.sfa29,l_sfb08
      FROM sfb_file #工單型態,生產料號,生產數量
      WHERE sfb01=l_sfa.sfa01
   LET l_sfa.sfa06 = 0
   LET l_sfa.sfa061= 0 LET l_sfa.sfa062= 0 LET l_sfa.sfa063= 0
   LET l_sfa.sfa064= 0 LET l_sfa.sfa065= 0 LET l_sfa.sfa066= 0
#  LET l_sfa.sfa07 = 0  #FUN-940008 mark
   LET l_sfa.sfa11 = 'E' #設為消耗料件, 才不會卡到入庫動作
   LET l_sfa.sfa25 = 0 LET l_sfa.sfa26 = '0'
   LET l_sfa.sfa27 = l_sfa.sfa03 LET l_sfa.sfa28 = 1
   LET l_sfa.sfaacti='Y'
   LET l_sfa.sfa05=l_sfs.sfs05
   LET l_sfa.sfa05 = s_digqty(l_sfa.sfa05,l_sfa.sfa12)     #FUN-910088--add--
   LET l_sfa.sfa161=l_sfa.sfa05/l_sfb08
#  LET l_sfa.sfa91='2' #發料加入備料底稿之材料 #BugNo:6587
   LET l_sfa.sfa16 = l_sfa.sfa161
   LET l_sfa.sfa04 = l_sfa.sfa05
   LET l_sfa.sfa14 = l_sfa.sfa12
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_sfa.sfa03
   CALL s_umfchk(l_sfa.sfa03,l_sfa.sfa12,l_ima25)
       RETURNING g_cnt,l_sfa.sfa13
   IF g_cnt THEN LET l_sfa.sfa13=1 END IF
   LET l_sfa.sfa15 = l_sfa.sfa13
   LET l_sfa.sfa99 = l_sfa.sfa05
   LET l_sfa.sfa09 = 0
   LET l_sfa.sfa100 = 0
   LET l_sfa.sfaplant = g_plant #FUN-980008 add
   LET l_sfa.sfalegal = g_legal #FUN-980008 add
   LET l_sfa.sfa012 = l_sfs.sfs012    #FUN-A60027
   LET l_sfa.sfa013 = l_sfs.sfs013    #FUN-A60027
   #No.FUN-A70131--begin
   IF cl_null(l_sfa.sfa012) THEN 
      LET l_sfa.sfa012=' '
   END IF 
   IF cl_null(l_sfa.sfa013) THEN 
      LET l_sfa.sfa013=0
   END IF 
   #No.FUN-A70131--end       
   INSERT INTO sfa_file VALUES (l_sfa.*)
   IF STATUS THEN
      LET g_success='N'
      CALL cl_err('ins sfa:',STATUS,1)
   #No.FUN-830132 080328 add --begin
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfai.* TO NULL
         LET l_sfai.sfai01 = l_sfa.sfa01
         LET l_sfai.sfai03 = l_sfa.sfa03
         LET l_sfai.sfai08 = l_sfa.sfa08
         LET l_sfai.sfai12 = l_sfa.sfa12
         LET l_sfai.sfai27 = l_sfa.sfa27     #No.FUN-870051
         LET l_sfai.sfai012 = l_sfa.sfa012   #No.FUN-A60027
         LET l_sfai.sfai013 = l_sfa.sfa013   #No.FUN-A60027
         IF NOT s_ins_sfai(l_sfai.*,'') THEN
            LET g_success = 'N'
         END IF
      END IF
   #No.FUN-830132 080328 add --end
   END IF
END FUNCTION
#------------------------------------------------------------------------
 
 
REPORT p510_rep(sr)
   DEFINE sr RECORD
          tmp00 LIKE type_file.chr1,  #No.FUN-680121 VARCHAR(1) #旗標, 1:來源工單與目的工單之共用料
                                                             #      2:來源工單有但目的工單無
                                                             #      3:來源工單無但目的工單有
          tmp01 LIKE ima_file.ima01, #料號  No.MOD-490217
          tmp02 LIKE gem_file.gem01, #No.FUN-680121 VARCHAR(06) #製程序號 chiayi modify
          tmp03 LIKE gfe_file.gfe01, #No.FUN-680121 VARCHAR(04) #單位
#         tmp04 LIKE ima_file.ima26, #No.FUN-680121 DEC(15,3)   #來源工單撥出數量
#         tmp05 LIKE ima_file.ima26, #No.FUN-680121 DEC(15,3)
#         tmp10 LIKE ima_file.ima26, #No.FUN-680121 DEC(15,3)   #超領
#         tmp06 LIKE ima_file.ima26, #No.FUN-680121 DEC(15,3)
          tmp04 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp05 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp10 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp06 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp27 LIKE ima_file.ima01, #MOD-A40021 add            #被替代料號
          tmp97 LIKE imd_file.imd01, #No.FUN-680121 VARCHAR(10) #倉
          tmp98 LIKE imd_file.imd01, #No.FUN-680121 VARCHAR(10) #儲
          tmp99 LIKE aag_file.aag01, #No.FUN-680121 VARCHAR(24)#批
#         tmp11 LIKE ima_file.ima26  #No.FUN-680121 DEC(15,3) 
          tmp11 LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
          tmp12 LIKE sfa_file.sfa012,  #FUN-A60095
          tmp13 LIKE sfa_file.sfa013   #FUN-A60095

       END RECORD
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_chr           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#       l_qty           LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)
        l_qty           LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
        l_ima02         LIKE ima_file.ima02, #FUN-510029
        l_ima021        LIKE ima_file.ima021 #FUN-510029
 
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.tmp00,sr.tmp01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_x[15] CLIPPED,g_sfb01a clipped
            PRINT g_x[16] CLIPPED,g_sfb01b clipped
            PRINT g_x[17] CLIPPED,g_outqty using '########.&&&'
            PRINT g_head CLIPPED,pageno_total     
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[40],g_x[41],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37] #FUN-A60095
            PRINTX name=H2 g_x[38]
            PRINTX name=H3 g_x[39]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            SELECT ima02,ima021 INTO l_ima02,l_ima021
              FROM ima_file
             WHERE ima01=sr.tmp01
 
            PRINTX name=D1 COLUMN g_c[31],sr.tmp01 CLIPPED ,
                           COLUMN g_c[40],sr.tmp12 CLIPPED,  #FUN-A60095
                           COLUMN g_c[41],sr.tmp13 CLIPPED,  #FUN-A60095
                           COLUMN g_c[32],sr.tmp02,
                           COLUMN g_c[33],sr.tmp03 CLIPPED ,
                           COLUMN g_c[34],cl_numfor(sr.tmp04,34,2),
                           COLUMN g_c[35],cl_numfor(sr.tmp05,35,2),
                           COLUMN g_c[36],cl_numfor(sr.tmp06,36,2),
                           COLUMN g_c[37],sr.tmp00 CLIPPED
            PRINTX name=D2 COLUMN g_c[38],l_ima02
            PRINTX name=D3 COLUMN g_c[39],l_ima021
 
        ON LAST ROW
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            PRINT g_dash
            PRINT g_x[21] CLIPPED
            IF l_trailer_sw = 'y' THEN
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            END IF
END REPORT
#No.CHI-980025 --Begin
FUNCTION p510_b_1(p_ima01,p_gfe01,p_tmp06)
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
 
   DECLARE p510_b_rvbs CURSOR FOR
    SELECT * FROM p510_rvbs
     WHERE rvbs021 = p_ima01
   FOREACH p510_b_rvbs INTO l_rvbs[i].*
      LET i = i+1
   END FOREACH
   CALL l_rvbs.deleteElement(i)
   LET l_rec_b = i-1
 
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
               UPDATE p510_rvbs SET temp06=l_rvbs[i].temp06
                WHERE rvbs03=l_rvbs[i].rvbs03 AND rvbs04=l_rvbs[i].rvbs04
                  AND rvbs05=l_rvbs[i].rvbs05 AND rvbs021=p_ima01
               IF SQLCA.sqlcode THEN
                  ERROR "UPDATE rvbs_file ERROR:",sqlca.sqlcode       #FUN-B80086   ADD
                  ROLLBACK WORK
                 # ERROR "UPDATE rvbs_file ERROR:",sqlca.sqlcode      #FUN-B80086   MARK
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
 
FUNCTION p510_insrvbs(p_sfs04,p_sfs01,p_sfs02,p_sfs07,p_sfs08,p_sfs09,p_type)
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
           temp06       LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
           rvbs021      LIKE rvbs_file.rvbs021
         END RECORD
DEFINE l_rvbs    RECORD LIKE rvbs_file.*
   SELECT ima25,ima918,ima921
     INTO l_ima25,l_ima918,l_ima921
     FROM ima_file
    WHERE ima01 = p_sfs04
   IF l_ima918='Y' OR l_ima921='Y' THEN
      LET l_rvbs022 = 1
      DECLARE p510_rvbs CURSOR FOR
       SELECT * FROM p510_rvbs
        WHERE rvbs021 = p_sfs04
      FOREACH p510_rvbs INTO l_temp.*
         IF l_temp.temp06 <=0 THEN
            CONTINUE FOREACH
         END IF
         IF p_type = '1' THEN   #退料
            LET l_rvbs.rvbs00='asfi526'
         ELSE
            LET l_rvbs.rvbs00='asfi511'
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
