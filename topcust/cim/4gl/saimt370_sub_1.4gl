# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# Program name...: saimt370_sub.4gl
# Description....: 提供saimt370.4gl使用的sub routine
# Date & Author..: 11/05/20 by jan (FUN-B50138)
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No.TQC-B80150 11/09/08 By houlia審核時check員工編號 
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.TQC-BA0122 11/10/21 By houlia審核時check員工編號 
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.CHI-BB0033 11/12/09 By ck2yuan 在過帳段，檢查是否有存在QC單且未確認
# Modify.........: No.FUN-BC0104 12/01/18 By lixh1 將FUNCTION t370_g_bom2中新增inb_file的邏輯獨立出FUNCTION t370sub_ins_inb() 
# Modify.........: No.FUN-BC0104 12/02/07 By xianghui 撈出合格量的時候的如果有QC單時應通過QC單號和項次撈取
# Modify.........: No.FUN-C20054 12/02/09 By Lilan 若背景執行，則過帳時不輸入過帳日期，直接帶入預設值
# Modify.........: No.TQC-C20167 12/02/14 By xianghui 重撈inb09的值
# Modify.........: No.FUN-C20076 12/02/15 By lixh1 新增倉庫庫存明細
# Modify.........: No.TQC-C20194 12/02/15 By xianghui 對FUN-BC0104進行調整
# Modify.........: No.FUN-BC0061 12/02/23 By nanbing 將g_ina02 改為 全局變量
# Modify.........: No.FUN-BC0062 12/03/05 By lilingyu 使用移動加權平均成本時，需維護單價,在審核時也需check一次
# Modify.........: No.MOD-C30278 12/03/12 By xianghui 有未確認的QC單據,雜收單不可以取消確認
# Modify.........: No:CHI-C30064 12/03/15 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No:MOD-C30405 12/03/16 By bart 移除錯誤訊息的項次
# Modify.........: No:CHI-C30106 12/04/05 By Elise 批序號維護
# Modify.........: No.TQC-C40079 12/04/12 By xianghui t370sub_y_chk沒有傳p_ask_post這個參數
# Modify.........: No.TQC-C40110 12/04/13 By lixh1 撈取inb09/inb1005時過濾掉作廢的數量
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70098 12/07/24 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No.FUN-C70087 12/07/25 By bart 整批寫入img_file
# Modify.........: No:TQC-CA0028 12/10/11 By bart 離開程式前要drop temp table
# Modify.........: No:MOD-CA0100 12/10/29 By Elise 新增控卡ima159(批號控管方式)
# Modify.........: No:CHI-CB0041 12/11/15 By bart 修改TQC-CA0028問題
# Modify.........: No.FUN-CB0087 12/12/05 By qiull 庫存單據理由碼改善
# Modify.........: No:MOD-CC0203 13/01/11 By Elise 若需簽核，確認時應跳訊息
# Modify.........: No:MOD-CC0151 13/01/11 By Elise 搬移sql條件
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No:FUN-D30024 13/03/13 By lixh1 負庫存依據imd23判斷
# Modify.........: No.DEV-D30026 13/03/19 By Nina GP5.3 追版:DEV-D10001、DEV-CB0002為GP5.25 的單號
# Modify.........: No.DEV-D30037 13/03/21 By TSD.JIE 有用smyb01="2:條碼單據"的控卡的改為用單身任一筆(MIN(項次)判斷即可)料件是否為包號管理(ima931)='Y'
# Modify.........: No.DEV-D30045 13/03/26 By TSD.JIE 調整自動產生barcode
#                                                    調整自動作廢barcode
# Modify.........: No.DEV-D30040 13/04/01 By Nina 批序號相關程式,當料件使用條碼時(ima930 = 'Y'),確認時,
#                                                 若未輸入批序號資料則不需控卡單據數量與批/序號總數量是否相符 
#                                                 ex:單據數量與批/序號總數量不符，請檢查資料！(aim-011)
# Modify.........: No:FUN-D20059 13/03/26 By chenjing 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.CHI-C80013 13/04/12 By Alberti aimp880會call確認與過帳段,因aimp880有s_showmsg_init 與 s_showmsg,故增加判斷若經由aimp880呼叫則不呼叫那兩隻sub 
# Modify.........: No.DEV-D30043 13/04/17 By TSD.JIE 調整條碼自動編號(s_gen_barcode2)與條碼手動編號(s_diy_barcode)產生先後順序
# Modify.........: No.DEV-D40015 13/04/18 By Lilan 調整取消確認時條碼作廢的檢核與Transaction
# Modify.........: No.MOD-D60002 13/06/01 By fengmy 理由碼開窗邏輯一致
# Modify.........: No:FUN-D60038 13/06/07 By fengrui 庫存資料不存在于img_fiel調用s_add_img

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/aim/4gl/saimt370.global"   #DEV-D30026 add

#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
GLOBALS #FUN-BC0061
DEFINE g_ina02  LIKE ina_file.ina02
END GLOBALS #FUN-BC0061

DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD  
                        unit   LIKE ima_file.ima25,
                        fac    LIKE img_file.img21,
                        qty    LIKE img_file.img10
                END RECORD
DEFINE g_aimp880 LIKE type_file.chr1        #CHI-C80013 add                
                
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION t370sub_lock_cl()
   DEFINE l_forupd_sql STRING
   LET l_forupd_sql = "SELECT * FROM ina_file WHERE ina01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t370sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

#p_argv1:單據類別
FUNCTION t370sub_y_chk(p_ina01,p_argv1,p_ask_post)    #TQC-C40079  add  p_ask_post
DEFINE p_ina01        LIKE ina_file.ina01
DEFINE l_cnt          LIKE type_file.num10  
DEFINE l_str          STRING
DEFINE l_rvbs06       LIKE rvbs_file.rvbs06
DEFINE l_n            LIKE type_file.num10   
DEFINE l_ima15        LIKE ima_file.ima15  
DEFINE l_azf09        LIKE azf_file.azf09  
DEFINE l_acti         LIKE azf_file.azfacti
DEFINE l_flag         LIKE type_file.chr1 
#DEFINE l_imaicd08     LIKE imaicd_file.imaicd08   #FUN-BA0051 mark 
DEFINE l_ina          RECORD LIKE ina_file.*
DEFINE l_buf          LIKE gem_file.gem02
DEFINE l_inb          RECORD LIKE inb_file.*
DEFINE l_ima918       LIKE ima_file.ima918
DEFINE l_ima921       LIKE ima_file.ima921
DEFINE l_ima930       LIKE ima_file.ima930 #DEV-D30040 add
DEFINE p_argv1        LIKE ina_file.ina00
#TQC-B80150  --add houlia
DEFINE l_gen02        LIKE gen_file.gen02
DEFINE l_gen03        LIKE gen_file.gen03          
DEFINE l_genacti     LIKE gen_file.genacti
DEFINE l_m            LIKE type_file.num10
#TQC-B80150 --end houlia 
DEFINE l_inb08_fac    LIKE inb_file.inb08 #CHI-C30064
DEFINE l_img09        LIKE img_file.img09 #CHI-C30064 add
DEFINE p_ask_post     LIKE type_file.chr1 #CHI-C30106 
#FUN-C70098---add-----
DEFINE l_inbslk03     LIKE inbslk_file.inbslk03
DEFINE l_inbslk04     LIKE inbslk_file.inbslk04
DEFINE l_inbslk09     LIKE inbslk_file.inbslk09
#FUN-C70098---add--end----
DEFINE l_ima159       LIKE ima_file.ima159  #MOD-CA0100 add
DEFINE l_sql          STRING                  #FUN-CB0087 add
DEFINE l_where        STRING                  #FUN-CB0087 add
DEFINE b_inb          RECORD LIKE inb_file.*  #FUN-CB0087 add
DEFINE l_inamksg      LIKE ina_file.inamksg,  #MOD-CC0203 add
       l_ina08        LIKE ina_file.ina08     #MOD-CC0203 add


   WHENEVER ERROR CONTINUE                #忽略一切錯誤  
   
   LET g_success = 'Y'

#CHI-C30107 ------------- add --------------- begin
   IF cl_null(p_ina01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_ina.* FROM ina_file WHERE ina01 = p_ina01   #MOD-CC0151 move

   IF l_ina.inaconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF l_ina.inaconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
#CHI-C30107 ------------- add --------------- end

  #CHI-C30106------S
   IF (g_action_choice='confirm' OR g_action_choice='insert') THEN #配合簽核自動確認程式,不能放在_chk()做判
      IF (l_ina.inamksg='Y') AND (l_ina.ina08 != '1') THEN
         CALL cl_err('','aws-078',1)
         LET g_success = 'N'
         RETURN
      END IF
      IF p_ask_post='Y' THEN   
         IF NOT cl_confirm('axm-108') THEN
            LET g_success='N'
            RETURN
         END IF
      END IF                  
     #MOD-CC0203---add---S
      SELECT inamksg,ina08
        INTO l_inamksg,l_ina08
        FROM ina_file
       WHERE ina01 = p_ina01
      IF l_inamksg= 'Y' THEN
         IF l_ina08 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
     #MOD-CC0203---add---E
   END IF
   #CHI-C30106------E
 
   IF cl_null(p_ina01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
 
  #SELECT * INTO l_ina.* FROM ina_file WHERE ina01 = p_ina01    #MOD-CC0151 mark
   
   IF l_ina.inaconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF
 
   IF l_ina.inaconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF

   IF NOT cl_null(l_ina.ina04) THEN
      SELECT gem02 INTO l_buf FROM gem_file
       WHERE gem01=l_ina.ina04
         AND gemacti='Y'   
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err3("sel","gem_file",l_ina.ina04,"",SQLCA.sqlcode,"","select gem",1)
         RETURN 
      END IF
   END IF
    
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM inb_file  
    WHERE inb01= p_ina01   
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   #FUN-C70098----add----begin--------------
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
       DECLARE inbslk04_curs CURSOR FOR
          SELECT inbslk03,inbslk04,inbslk09 FROM inbslk_file WHERE inbslk01 = l_ina.ina01   
       CALL s_showmsg_init()
       FOREACH inbslk04_curs INTO l_inbslk03,l_inbslk04,l_inbslk09
           IF cl_null(l_inbslk09) OR l_inbslk09 = 0 THEN
              CALL s_errmsg('', l_ina.ina01 ,l_inbslk04 ,'axr-034',1)
              LET g_success = 'N'
           END IF
       END FOREACH
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
   END IF
   #FUN-C70098----add----end----------------
   
    #TQC-B80150  --houlia check
    LET l_m = 0
    SELECT COUNT(*) INTO l_m FROM gen_file
  #  WHERE gen01 = g_ina.ina11
     WHERE gen01 = l_ina.ina11     #TQC-BA0122
       AND genacti = 'Y'
    IF l_m = 0 THEN  
      LET g_success = 'N'
      CALL cl_err('','mfg1312',0)
      RETURN
     END IF
   #TQC-B80150  --end
   
   #Cehck 單身 料倉儲批是否存在 img_file
   DECLARE t370sub_y_chk_c CURSOR FOR SELECT * FROM inb_file
                                   WHERE inb01=p_ina01

   #FUN-CB0087---add---str---
   #MOD-D60002--mark begin-------------
#   IF g_aza.aza115 = 'Y' THEN             
#      CALL s_showmsg_init()
#      FOREACH t370sub_y_chk_c INTO b_inb.*
#         IF NOT cl_null(b_inb.inb15) THEN
#            LET l_n = 0
#            LET l_flag = FALSE
#            CALL s_get_where(l_ina.ina01,'','',b_inb.inb04,b_inb.inb05,l_ina.ina11,l_ina.ina04) RETURNING l_flag,l_where
#            IF l_flag THEN
#               LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",b_inb.inb15,"' AND ",l_where
#               PREPARE ggc08_pre FROM l_sql
#               EXECUTE ggc08_pre INTO l_n
#               IF l_n < 1 THEN
#                  LET g_success='N'
#                  CALL s_errmsg('inb15',b_inb.inb15,b_inb.inb15,'aim-425',1)
#               END IF
#            ELSE
#               SELECT ima15 INTO l_ima15 FROM ima_file
#                WHERE ima01 = b_inb.inb04
#                  AND imaacti = 'Y'
#               IF STATUS THEN
#                  LET g_success='N'
#                  LET l_str="Item/sel ima15 ",b_inb.inb03,"/",b_inb.inb04,":"
#                  CALL s_errmsg('inb04',b_inb.inb04,l_str,STATUS,1)
#               END IF
#               IF g_sma.sma79='Y' AND l_ima15 = 'Y' THEN       #使用保稅系統且為保稅料件
#                  IF cl_null(b_inb.inb15) THEN RETURN FALSE END IF
#                  SELECT azf03 FROM azf_file
#                   WHERE azf01=b_inb.inb15 AND (azf02='A' OR azf02='2')
#                  IF STATUS THEN
#                     LET g_success='N'
#                     LET l_str="Item/sel azf ",b_inb.inb03,"/",b_inb.inb15,":"
#                     CALL s_errmsg('inb15',b_inb.inb15,l_str,STATUS,1)
#                  END IF
#               ELSE
#                  SELECT azf03 FROM azf_file
#                   WHERE azf01=b_inb.inb15 AND azf02='2'
#                  IF STATUS THEN
#                     LET g_success='N'
#                     LET l_str="Item/sel azf ",b_inb.inb03,"/",b_inb.inb15,":"
#                     CALL s_errmsg('inb15',b_inb.inb15,l_str,STATUS,1)
#                  END IF
#                  SELECT azf09 INTO l_azf09 FROM azf_file
#                   WHERE azf01=b_inb.inb15 AND azf02='2'
#                  IF l_azf09 != '4' OR cl_null(l_azf09) THEN
#                     LET g_success='N'
#                     LET l_str="Item/sel azf ",b_inb.inb03,"/",b_inb.inb15,":"
#                     CALL s_errmsg('inb15',b_inb.inb15,l_str,'aoo-403',1)
#                  END IF
#               END IF
#            END IF                               
#         ELSE
#            LET g_success = 'N'
#            CALL s_errmsg('inb15',b_inb.inb15,b_inb.inb15,'aim-888',1)
#         END IF
#      END FOREACH
#      CALL s_showmsg()
#   END IF
   #MOD-D60002--mark end-------------
   #FUN-CB0087---add---end---
   
   FOREACH t370sub_y_chk_c INTO l_inb.*      
      IF NOT s_chk_ware(l_inb.inb05) THEN 
         LET g_success = 'N'
         RETURN 
      END IF   

#FUN-BC0062 --begin--
      IF g_ccz.ccz28 = '6' AND (p_argv1  = '3' OR p_argv1 = '4') THEN            
         IF cl_null(l_inb.inb13) OR l_inb.inb13 <= 0 THEN
           LET g_success = 'N'
           CALL cl_err('','aim-031',1)
           RETURN
         END IF  
      END IF
#FUN-BC0062 --end--
      #Add No:TQC-AC0330 理由碼控管
      IF NOT cl_null(l_inb.inb15) THEN
      #   IF g_aza.aza115 = 'N' THEN                 FUN-CB0087 add #MOD-D60002 mark
         SELECT ima15 INTO l_ima15 FROM ima_file
          WHERE ima01 = l_inb.inb04
            AND imaacti = 'Y'
         IF STATUS THEN
            LET g_success='N'
            LET l_str="Item/sel ima15 ",l_inb.inb03,"/",l_inb.inb04,":"
            CALL cl_err(l_str,STATUS,1)
            EXIT FOREACH
         END IF
         IF g_sma.sma79='Y' AND l_ima15 = 'Y' THEN       #使用保稅系統且為保稅料件
            IF cl_null(l_inb.inb15) THEN RETURN FALSE END IF
            SELECT azf03 FROM azf_file
             WHERE azf01=l_inb.inb15 AND (azf02='A' OR azf02='2')
            IF STATUS THEN
               LET g_success='N'
               LET l_str="Item/sel azf ",l_inb.inb03,"/",l_inb.inb15,":"
               CALL cl_err(l_str,STATUS,1)
               EXIT FOREACH
            END IF
         ELSE
            SELECT azf03 FROM azf_file
             WHERE azf01=l_inb.inb15 AND azf02='2'
            IF STATUS THEN
               LET g_success='N'
               LET l_str="Item/sel azf ",l_inb.inb03,"/",l_inb.inb15,":"
               CALL cl_err(l_str,STATUS,1)
               EXIT FOREACH
            END IF
            SELECT azf09 INTO l_azf09 FROM azf_file
             WHERE azf01=l_inb.inb15 AND azf02='2'
            IF l_azf09 != '4' OR cl_null(l_azf09) THEN  
               LET g_success='N'
               LET l_str="Item/sel azf ",l_inb.inb03,"/",l_inb.inb15,":"
               CALL cl_err(l_str,'aoo-403',1)
               EXIT FOREACH
            END IF
         END IF
     #    END IF                                FUN-CB0087 add   #MOD-D60002 mark
      ELSE
         IF g_smy.smy59 = 'Y' THEN
            LET g_success='N'
            LET l_str="Item ",l_inb.inb03,":"
            CALL cl_err(l_str,'apj-201',1)
            EXIT FOREACH
         END IF
      END IF
#      判斷理由碼是否為"失效",失效情況下則不能輸入
      SELECT azfacti INTO l_acti FROM azf_file WHERE azf01 = l_inb.inb15
      IF l_acti <> 'Y' THEN
         LET g_success='N'
         LET l_str="Item ",l_inb.inb03,":"
         CALL cl_err(l_str,'aim-163',1) 
         EXIT FOREACH
      END IF

#FUN-C70087---begin
#      LET l_cnt=0
#      SELECT COUNT(*) INTO l_cnt FROM img_file WHERE img01=l_inb.inb04
#                                                 AND img02=l_inb.inb05
#                                                 AND img03=l_inb.inb06
#                                                 AND img04=l_inb.inb07
#      IF l_cnt=0 THEN
#         LET g_success='N'
#         LET l_str="Item ",l_inb.inb03,":"
#         CALL cl_err(l_str,'asf-507',1)
#         EXIT FOREACH
#      END IF
#FUN-C70087---end
      IF p_argv1='4' THEN
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM imd_file
          WHERE imd01=l_inb.inb05 AND imd10='W'
            AND imdacti = 'Y'
         IF l_n = 0 THEN
            LET g_success='N'
            LET l_str = l_inb.inb04,"/",l_inb.inb05
            CALL cl_err(l_str,'asf-724',1)
            EXIT FOREACH
         END IF
      END IF

      LET l_ima918 = ''   #DEV-D30040 add
      LET l_ima921 = ''   #DEV-D30040 add
      LET l_ima930 = ''   #DEV-D30040 add

      SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930 #DEV-D30040 add ima930,l_ima930 
        FROM ima_file
       WHERE ima01 = l_inb.inb04
         AND imaacti = "Y"
      
      IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF #DEV-D30040 add 

      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN                      
         IF l_ina.ina00 = "1" OR l_ina.ina00 = "2"    
           OR  l_ina.ina00 = "5" OR l_ina.ina00 = "6" THEN  
            SELECT SUM(rvbs06) INTO l_rvbs06
              FROM rvbs_file
             WHERE rvbs00 = g_prog
               AND rvbs01 = l_inb.inb01
               AND rvbs02 = l_inb.inb03
               AND rvbs13 = 0
               AND rvbs09 = -1
         ELSE
            SELECT SUM(rvbs06) INTO l_rvbs06
              FROM rvbs_file
             WHERE rvbs00 = g_prog
               AND rvbs01 = l_inb.inb01
               AND rvbs02 = l_inb.inb03
               AND rvbs13 = 0
               AND rvbs09 = 1
         END IF
         
         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF
         
        #CHI-C30064---Start---add
         SELECT img09 INTO l_img09 FROM img_file
          WHERE img01= l_inb.inb04 AND img02= l_inb.inb05
            AND img03= l_inb.inb06 AND img04= l_inb.inb07
         CALL s_umfchk(l_inb.inb04,l_inb.inb08,l_img09) RETURNING l_cnt,l_inb08_fac
         IF l_cnt = '1' THEN LET l_inb08_fac = 1 END IF             
        #CHI-C30064---End---add 
        #IF (l_inb.inb09 * l_inb.inb08_fac) <> l_rvbs06 THEN
         IF (((l_ima930='Y' and l_rvbs06 <> 0 ) OR l_ima930 = 'N') AND (g_prog = 'aimt302' OR g_prog = 'aimt301')) OR #DEV-D30040 add
              (g_prog <> 'aimt302' AND g_prog <> 'aimt301')THEN #DEV-D30040 add 
            IF (l_inb.inb09 * l_inb08_fac) <> l_rvbs06 THEN #CHI-C30064
               LET g_success = "N"
               CALL cl_err(l_inb.inb04,"aim-011",1)
               EXIT FOREACH
            END IF
         END IF                                                 #DEV-D30040 add 
      END IF

     #MOD-CA0100---add---S 
      LET l_ima159 = ' '
      SELECT ima159 INTO l_ima159
        FROM ima_file
       WHERE ima01 = l_inb.inb04
         AND imaacti = "Y"      
      IF l_ima159 = '1' THEN 
         IF cl_null(l_inb.inb07) THEN
            LET g_success = "N"
            CALL cl_err(l_inb.inb04,'aim-034',1)
            EXIT FOREACH
         END IF
      END IF  
     #MOD-CA0100---add---E
 
      IF s_industry('icd') THEN
         #FUN-BA0051 --START mark--
         #LET l_imaicd08 = NULL
         #SELECT imaicd08 INTO l_imaicd08
         #  FROM imaicd_file
         # WHERE imaicd00 = l_inb.inb04
         # IF l_imaicd08 = 'Y' THEN
         #FUN-BA0051 --END mark--
          IF s_icdbin(l_inb.inb04) THEN   #FUN-BA0051 
             IF p_argv1 MATCHES '[34]' THEN
                CALL s_icdchk(1,l_inb.inb04,
                                l_inb.inb05,
                                l_inb.inb06, 
                                l_inb.inb07, 
                                l_inb.inb09, 
                                l_inb.inb01, 
                                l_inb.inb03, 
                                l_ina.ina02,'')  #FUN-B80119--傳入p_plant參數''---
                     RETURNING l_flag
             ELSE
                CALL s_icdchk(-1,l_inb.inb04,
                                l_inb.inb05,
                                l_inb.inb06, 
                                l_inb.inb07, 
                                l_inb.inb09, 
                                l_inb.inb01, 
                                l_inb.inb03, 
                                l_ina.ina02,'')  #FUN-B80119--傳入p_plant參數''---
                     RETURNING l_flag
             END IF
             IF l_flag = 0 THEN
                #CALL cl_err(l_inb.inb03,'aic-056',1)  #MOD-C30405 mark
                CALL cl_err('','aic-056',1)            #MOD-C30405
                LET g_success = 'N'
                RETURN
             END IF
          END IF
      END IF
             
   END FOREACH
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post='Y' 會詢問"是否執行過帳"
FUNCTION t370sub_y_upd(p_ina01,p_ask_post,p_inTransaction)
DEFINE p_ina01         LIKE ina_file.ina01
DEFINE old_ina08       LIKE ina_file.ina08
DEFINE l_inacont       LIKE ina_file.inacont  
DEFINE p_inTransaction LIKE type_file.num5
DEFINE p_ask_post      LIKE type_file.chr1
DEFINE l_ina           RECORD LIKE ina_file.*

   SELECT * INTO l_ina.* FROM ina_file WHERE ina01 = p_ina01
 
   LET l_inacont=TIME  
  #CHI-C30106---mark---S 
  #IF (g_action_choice='confirm' OR g_action_choice='insert') THEN #配合簽核自動確認程式,不能放在_chk()做判斷
  #   IF (l_ina.inamksg='Y') AND (l_ina.ina08 != '1') THEN
  #      CALL cl_err('','aws-078',1)
  #      LET g_success = 'N'
  #      RETURN
  #   END IF
  #   IF p_ask_post='Y' THEN
  #      IF NOT cl_confirm('axm-108') THEN
  #         LET g_success='N'
  #         RETURN
  #      END IF
  #   END IF
  #END IF
  #CHI-C30106---mark---E
 
   LET g_success = 'Y'
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF
 
   CALL t370sub_lock_cl()
   OPEN t370sub_cl USING p_ina01
   IF STATUS THEN
      CALL cl_err("OPEN t370sub_cl:", STATUS, 1)
      CLOSE t370sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success = 'N' RETURN
   END IF
   FETCH t370sub_cl INTO l_ina.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(p_ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t370sub_cl
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
       LET g_success='N' RETURN
   END IF
   CLOSE t370sub_cl
   
   LET old_ina08=l_ina.ina08
   IF l_ina.inamksg<>'Y' THEN
      UPDATE ina_file SET inaconf = 'Y',ina08='1',  
                          inacont=l_inacont,inaconu = g_user,inacond = g_today    
       WHERE ina01 = p_ina01 
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ina_file",p_ina01,"",STATUS,"",
                      "upd inaconf",1)  
         LET g_success = 'N'
      END IF
   ELSE
      UPDATE ina_file SET inaconf = 'Y', 
                          inacont=l_inacont, inaconu = g_user,inacond = g_today   
       WHERE ina01 = p_ina01 
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ina_file",p_ina01,"",STATUS,"",
                      "upd inaconf",1)  
         LET g_success = 'N'
      END IF
      CASE aws_efapp_formapproval()
           WHEN 0  #呼叫 EasyFlow 簽核失敗
                LET g_success = "N"
                IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                RETURN
           WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                RETURN
      END CASE
   END IF
 
   IF g_success='Y' THEN
      IF NOT p_inTransaction THEN
         COMMIT WORK
      END IF
      CALL cl_flow_notify(p_ina01,'Y')
   ELSE
      IF NOT p_inTransaction THEN
         ROLLBACK WORK
      END IF
   END IF

   #DEV-D30045--add--begin
   #自動產生barcode
   IF g_success='Y' AND g_prog = 'aimt302' AND g_aza.aza131 = 'Y' THEN
      CALL t370sub_barcode_gen(p_ina01,'N')
   END IF
   #DEV-D30045--add--end
END FUNCTION

#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post='Y' 會詢問"是否執行過帳"
#p_date :過帳日期。IF p_date=''則打開畫面上的'過帳日期'欄位讓用戶來維護
FUNCTION t370sub_s_chk(p_ina01,p_ask_post,p_inTransaction,p_date)
DEFINE l_cnt     LIKE type_file.num5  
DEFINE l_sql     STRING   
DEFINE l_inb09   LIKE inb_file.inb09,
       l_inb04   LIKE inb_file.inb04,
       l_inb10   LIKE inb_file.inb10,
       l_qcs01   LIKE qcs_file.qcs01,
       l_qcs02   LIKE qcs_file.qcs02,
       l_qcs091c LIKE qcs_file.qcs091
DEFINE l_imaag   LIKE ima_file.imaag
DEFINE l_ina02   LIKE ina_file.ina02  
DEFINE l_yy,l_mm LIKE type_file.num5  
DEFINE l_flag1   LIKE type_file.chr1  
DEFINE l_inb05   LIKE inb_file.inb05  
DEFINE l_inb06   LIKE inb_file.inb06  
DEFINE l_inb03   LIKE inb_file.inb03 
DEFINE l_ina     RECORD LIKE ina_file.* 
DEFINE p_ina01   LIKE ina_file.ina01
DEFINE p_date    LIKE type_file.dat
DEFINE p_inTransaction LIKE type_file.num5
DEFINE p_ask_post      LIKE type_file.chr1
DEFINE l_inb44   LIKE inb_file.inb44      #FUN-BC0104
DEFINE l_inb45   LIKE inb_file.inb45      #FUN-BC0104
DEFINE l_inb1005 LIKE inb_file.inb1005    #TQC-C20167
DEFINE l_qcl05   LIKE qcl_file.qcl05      #TQC-C20194
DEFINE l_inb46   LIKE inb_file.inb46      #TQC-C20194
DEFINE l_cnt1    LIKE type_file.num5      #TQC-C20194 
DEFINE l_inb     RECORD LIKE inb_file.*    #FUN-C70087
#DEFINE l_img_table      STRING             #FUN-C70087 #FUN-CC0095
#DEFINE l_imgg_table     STRING             #FUN-C70087 #FUN-CC0095
DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087  
DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087  
DEFINE l_flag      LIKE type_file.chr1     #FUN-C70087
DEFINE l_t1     LIKE smy_file.smyslip #No:DEV-D30026--add
DEFINE l_smyb01 LIKE smyb_file.smyb01 #No:DEV-D30026--add

   #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087 #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087 #FUN-CC0095
   
   LET g_success = 'Y'
   IF s_shut(0) THEN
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
   SELECT * INTO l_ina.* FROM ina_file WHERE ina01 = p_ina01
   IF cl_null(p_ina01) THEN
       CALL cl_err('',-400,0)
       LET g_success = 'N'
       #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
       #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
       RETURN
   END IF
 
   IF l_ina.inaconf = 'N' THEN
      CALL cl_err('','aba-100',0)
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   LET l_cnt =0
   SELECT COUNT(*) INTO l_cnt FROM inb_file
    WHERE inb01=p_ina01 
   IF l_cnt=0 OR cl_null(l_cnt) THEN
      CALL cl_err('','mfg-008',0)
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   IF l_ina.inapost = 'Y' THEN
      CALL cl_err('','asf-812',0) 
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   IF l_ina.inaconf = 'X' THEN 
      CALL cl_err('',9024,0)
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
   
   #No:DEV-D30026--add--begin
   IF l_ina.ina00 MATCHES '[13]' THEN  #aimt301,aimt302
      #DEV-D30037--mark--begin
      #LET l_t1 = s_get_doc_no(l_ina.ina01)
      #SELECT smyb01 INTO l_smyb01 FROM smyb_file
      # WHERE smybslip = l_t1
      #IF cl_null(l_smyb01) THEN
      #    LET l_smyb01 = '1'
      #END IF
      #DEV-D30037--mark--end

      #DEV-D30037--add--begin
      CALL t370sub_chk_smyb2(l_ina.ina01)
         RETURNING l_smyb01
      #DEV-D30037--add--end

     #IF l_smyb01 = '2' THEN                      #DEV-D30026 mark
      #IF l_smyb01 = '2' AND cl_null(g_argv4) THEN #DEV-D30026 add #mark by guanyao160513
      IF l_smyb01 = '2'  THEN #add by guanyao160513
         #條碼類型調撥單，請從條碼作業(abat302)來執行過帳操作!
         CASE l_ina.ina00
            WHEN '1' CALL cl_err('','aba-052',1)
            WHEN '3' CALL cl_err('','aba-053',1)
         END CASE
         LET g_success = 'N'
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
         RETURN
      END IF
   END IF
   #No:DEV-D30026--add--end

   DECLARE t370sub_s_chk1 CURSOR FOR SELECT inb03,inb05,inb06 FROM inb_file 
                                   WHERE inb01=p_ina01

                                   
   IF cl_null(g_aimp880) THEN   #CHI-C80013 add
      CALL s_showmsg_init()   
   END IF                       #CHI-C80013 add
   
   FOREACH t370sub_s_chk1 INTO l_inb03,l_inb05,l_inb06                              
      CALL s_incchk(l_inb05,l_inb06,g_user) 
           RETURNING l_flag1
      IF l_flag1 = FALSE THEN
         LET g_success='N'
         LET g_showmsg=l_inb03,"/",l_inb05,"/",l_inb06,"/",g_user
         CALL s_errmsg('inb03,inb05,inb06,inc03',g_showmsg,'','asf-888',1)
      END IF
   END FOREACH
   IF cl_null(g_aimp880) THEN   #CHI-C80013 add
      CALL s_showmsg()
   END IF                       #CHI-C80013 add
   
   IF g_success='N' THEN
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   LET l_ina02 = l_ina.ina02
   IF cl_null(l_ina02) THEN
      LET l_ina02 = l_ina.ina02
   END IF

   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF
 
   CALL t370sub_lock_cl()
   OPEN t370sub_cl USING p_ina01
   IF STATUS THEN
      CALL cl_err("OPEN t370sub_cl:", STATUS, 1)
      CLOSE t370sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   FETCH t370sub_cl INTO l_ina.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(p_ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t370sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF

   IF g_action_choice = "stock_post" THEN  
      IF p_ask_post='Y' THEN
         IF NOT cl_confirm('mfg0176') THEN 
            LET g_success='N' 
            CLOSE t370sub_cl 
            IF NOT p_inTransaction THEN ROLLBACK WORK END IF
            #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
            #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
            RETURN 
          END IF
       END IF
   END IF
   
   IF cl_null(p_date) THEN #jan
      LET l_ina.ina02 = l_ina02  
      DISPLAY l_ina.ina02 TO ina02 
      IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  #FUN-C20054 add
         IF (g_action_choice CLIPPED = "stock_post") OR
            (g_action_choice CLIPPED = "insert") THEN 
             INPUT l_ina.ina02 WITHOUT DEFAULTS FROM ina02
             
               AFTER FIELD ina02
                 IF NOT cl_null(l_ina.ina02) THEN
                    IF g_sma.sma53 IS NOT NULL AND l_ina.ina02 <= g_sma.sma53 THEN
                       CALL cl_err('','mfg9999',0)
                       NEXT FIELD ina02
                    END IF
                    CALL s_yp(l_ina.ina02) RETURNING l_yy,l_mm 
             
                    IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                       CALL cl_err('','mfg6090',0)
                       NEXT FIELD ina02
                    END IF
                 END IF
             
               AFTER INPUT 
                  IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     LET g_success = 'N'
                     #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
                     #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
                     RETURN
                  END IF
                  IF NOT cl_null(l_ina.ina02) THEN
                     IF g_sma.sma53 IS NOT NULL AND l_ina.ina02 <= g_sma.sma53 THEN
                        CALL cl_err('','mfg9999',0) 
                        NEXT FIELD ina02
                     END IF
                     CALL s_yp(l_ina.ina02) RETURNING l_yy,l_mm
                     IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                        CALL cl_err(l_yy,'mfg6090',0) 
                        NEXT FIELD ina02
                     END IF
                  ELSE
                     CONTINUE INPUT
                  END IF
                  ON ACTION CONTROLG 
                      CALL cl_cmdask()
             
                  ON IDLE g_idle_seconds
                      CALL cl_on_idle()
                      CONTINUE INPUT
             END INPUT
             LET l_ina02 = l_ina.ina02  
             LET g_ina02 = l_ina.ina02 
        #str---add by guanyao160513
         ELSE 
            LET l_ina02 = l_ina.ina02  
            LET g_ina02 = l_ina.ina02 
        #end---add by guanyao160513
         END IF
     #FUN-C20054 add str---
      ELSE
         LET l_ina02 = l_ina.ina02
         LET g_ina02 = l_ina.ina02
      END IF
     #FUN-C20054 add end---
   ELSE
      LET g_ina02=p_date     #jan
      LET l_ina.ina02=p_date #jan
   END IF
 
   IF g_sma.sma53 IS NOT NULL AND l_ina.ina02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN   
   END IF
 
   CALL s_yp(l_ina.ina02) RETURNING l_yy,l_mm
 
   IF l_yy > g_sma.sma51 THEN      # 與目前會計年度,期間比較
      CALL cl_err(l_yy,'mfg6090',1)
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   ELSE
      IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
         CALL cl_err(l_mm,'mfg6091',1)
         LET g_success = 'N'
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
         RETURN
      END IF
   END IF

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t370_s_c1 CURSOR FOR SELECT * FROM inb_file
     WHERE inb01 = l_ina.ina01 
   FOREACH t370_s_c1 INTO l_inb.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM img_file
       WHERE img01 = l_inb.inb04
         AND img02 = l_inb.inb05
         AND img03 = l_inb.inb06
         AND img04 = l_inb.inb07
       IF l_cnt = 0 THEN
          #CALL s_padd_img_data(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ina.ina01,l_inb.inb03,l_ina.ina02,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ina.ina01,l_inb.inb03,l_ina.ina02) #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_inb.inb04,l_inb.inb05,
                       l_inb.inb06,l_inb.inb07,
                       l_inb.inb902) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_inb.inb902,l_ina.ina01,l_inb.inb03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_inb.inb902,l_ina.ina01,l_inb.inb03) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_inb.inb04,l_inb.inb05,
                       l_inb.inb06,l_inb.inb07,
                       l_inb.inb905) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_inb.inb905,l_ina.ina01,l_inb.inb03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_inb.inb905,l_ina.ina01,l_inb.inb03) #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_img FROM l_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM l_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_drop(l_img_table)  #FUN-CC0095
               LET g_success = 'N'
               #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #CHI-CB0041
               #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #CHI-CB0041
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_drop(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #CHI-CB0041
               #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #CHI-CB0041
               RETURN 
            END IF 
         END IF #FUN-CC0095 
      ELSE
         #CALL s_padd_img_drop(l_img_table)  #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-CC0095
         LET g_success = 'N'
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
   #FUN-C70087---end
 
   LET l_sql = " SELECT inb09,inb10,inb04,inb01,inb03,inb44,inb45,inb46 FROM inb_file ",    #FUN-BC0104 add inb44,inb45 #TQC-C20194 add inb46
               "  WHERE inb01 = '",p_ina01,"'"
 
   PREPARE t370sub_curs2 FROM l_sql
   DECLARE t370sub_pre2 CURSOR FOR t370sub_curs2
 
   FOREACH t370sub_pre2 INTO l_inb09,l_inb10,l_inb04,l_qcs01,l_qcs02,l_inb44,l_inb45,l_inb46   #FUN-BC0104 add inb44,inb45 #TQC-C20194 add l_inb46
      #TQC-C20194-add-str--
      LET l_qcl05 =''
      SELECT qcl05 INTO l_qcl05 
        FROM qcl_file
       WHERE qcl01 = l_inb46
      #TQC-C20194-add-end--
      #IF l_inb09 = 0 THEN                   #TQC-C20194 mark
      IF l_inb09 = 0 AND (l_qcl05 <>'1' AND NOT cl_null(l_qcl05)) THEN   #TQC-C20194
         CALL cl_err(l_inb04,'aim-033',1)
         LET g_success = 'N'
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
         RETURN
      END IF
      #FUN-BC0104-add-str--
      IF NOT cl_null(l_inb44) THEN 
         #TQC-C20167--add-str--
         SELECT SUM(inb09) INTO l_inb09
         # FROM inb_file           #TQC-C40110   mark
         #WHERE inb44=l_inb44      #TQC-C40110   mark
           FROM ina_file,inb_file  #TQC-C40110
          WHERE inb01=ina01        #TQC-C40110 
            AND inb44=l_inb44      #TQC-C40110 
            AND inb45=l_inb45
            AND inaconf<>'X'       #TQC-C40110
         IF cl_null(l_inb09) THEN LET l_inb09 =0 END IF
         SELECT SUM(inb1005) INTO l_inb1005
         # FROM inb_file,qcl_file                #TQC-C40110  mark  
         #WHERE inb44=l_inb44 AND inb45=l_inb45  #TQC-C40110  mark 
           FROM ina_file,inb_file,qcl_file       #TQC-C40110
          WHERE inb01=ina01                      #TQC-C40110
            AND inb44=l_inb44 AND inb45=l_inb45  #TQC-C40110
            AND inb46=qcl01 AND qcl05='1' AND inb46 IS NOT NULL
            AND inaconf<>'X'       #TQC-C40110 
              
         IF cl_null(l_inb1005) THEN LET l_inb1005 =0 END IF
         LET l_inb09 = l_inb09+l_inb1005
         #TQC-C20167--add--end--
         LET l_qcs01 = l_inb44
         LET l_qcs02 = l_inb45
      END IF
      #FUN-BC0104-add-end--
      IF l_inb10 = 'Y' THEN
         LET l_qcs091c = 0
         SELECT SUM(qcs091) INTO l_qcs091c
           FROM qcs_file
          WHERE qcs01 = l_qcs01
            AND qcs02 = l_qcs02
            AND qcs14 = 'Y'
            AND qcs09 IN ('1','3')   # 格量
 
         IF l_qcs091c IS NULL THEN
            LET l_qcs091c = 0
         END IF

         #TQC-C20194--add--str--
         IF NOT cl_null(l_inb44) AND l_qcs091c = 0 THEN 
            SELECT SUM(qcf091) INTO  l_qcs091c
              FROM qcf_file
             WHERE qcf01 = l_qcs01
               AND qcf14 = 'Y'
               AND qcf09 IN ('1','3')
            IF l_qcs091c IS NULL THEN 
               LET l_qcs091c = 0
            END IF 
         END IF 
         #TQC-C20194--add--end--
         #有 未確認QC單
         #----CHI-BB0033 add start-----------
           LET l_cnt =0
           LET l_cnt1 =0     #TQC-C20194
           SELECT COUNT(*) INTO l_cnt  FROM qcs_file WHERE qcs01 = l_qcs01  AND qcs02 = l_qcs02
           IF l_cnt=0 THEN  #無QC單
              LET l_cnt = 1 
           ELSE             #有QC單，檢核是否有未確認之QC單
              LET l_cnt =0
              SELECT COUNT(*) INTO l_cnt  FROM qcs_file WHERE qcs14 = 'N' AND qcs01 = l_qcs01  AND qcs02 = l_qcs02
           END IF 
           SELECT COUNT(*) INTO l_cnt1 FROM qcf_file WHERE qcf14 = 'N' AND qcf01 = l_qcs01                #TQC-C20194
           IF cl_null(l_cnt)  THEN LET l_cnt =0 END IF       #TQC-C20194
           IF cl_null(l_cnt1) THEN LET l_cnt1=0 END IF       #TQC-C20194
           IF l_cnt >0 OR l_cnt1>0 THEN            #TQC-C20194 add l_cnt1 >0
            CALL cl_err(l_inb04,'aim-060',1)
            LET g_success = 'N'
            #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
            #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
            RETURN
           END IF
         #----CHI-BB0033 add end------------ 

         SELECT imaag INTO l_imaag FROM ima_file
          WHERE ima01 =l_inb04
         IF NOT CL_null(l_imaag) AND l_imaag <>'@CHILD' THEN 
            CALL cl_err(l_inb04,'aim1004',1)
            LET g_success = 'N'
            #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
            #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
            RETURN
         END IF
 
         IF l_inb09 > l_qcs091c THEN
            CALL cl_err(l_inb04,'mfg3558',1)
            LET g_success = 'N'
            #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
            #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
            RETURN
         END IF
      END IF
   END FOREACH
   #CALL s_padd_img_drop(l_img_table)   #FUN-C70087  #FUN-CC0095
   #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087  #FUN-CC0095

   #DEV-D40015 add str--------
   #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND (g_prog = 'aimt301' OR g_prog = 'aimt302') THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT inb04 FROM inb_file WHERE inb01 = l_ina.ina01) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
	
      #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('post','tlfb',l_ina.ina01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
   #DEV-D40015 add end--------
END FUNCTION
 
#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_argv1:單據類別
FUNCTION t370sub_s_upd(p_ina01,p_argv1,p_inTransaction)
  DEFINE l_ina02   LIKE ina_file.ina02  
  DEFINE l_ima906  LIKE ima_file.ima906 
  DEFINE l_yy,l_mm LIKE type_file.num5 
  DEFINE p_ina01   LIKE ina_file.ina01
  DEFINE l_ina     RECORD LIKE ina_file.*
  DEFINE l_inb     RECORD LIKE inb_file.*
  DEFINE l_msg     LIKE type_file.chr1000
  DEFINE l_imm01   LIKE imm_file.imm01
  DEFINE p_argv1   LIKE ina_file.ina00
  DEFINE p_inTransaction LIKE type_file.num5
 
   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "stock_post" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  
   THEN
 
   END IF
 
  SELECT * INTO l_ina.* FROM ina_file WHERE ina01 = p_ina01
  LET l_ina02 = g_ina02
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

   LET l_ina.ina02=l_ina02 
   CALL t370sub_s1(l_ina.ina00,l_ina.ina01,l_ina.ina03,l_ina.ina07,l_ina.ina04,l_ina.ina06,p_argv1)
 
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
   END IF
  
   IF g_success = 'Y' THEN
      UPDATE ina_file SET ina02=l_ina02,inapost='Y'  WHERE ina01=p_ina01  
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ina_file",p_ina01,"",SQLCA.sqlcode,"",
                      "upd inapost",1)  
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         LET g_success = 'N'
         RETURN
      END IF
 
      IF g_success='Y' THEN
         LET l_ina.inapost='Y'
         LET l_ina.ina08='1'    
         IF NOT p_inTransaction THEN COMMIT WORK END IF
         CALL cl_flow_notify(p_ina01,'S')
      ELSE
         LET g_success = 'N'
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         RETURN
      END IF
   ELSE
      LET l_ina.inapost='N'
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      RETURN  
   END IF
 
   IF (l_ina.inapost = "N") THEN
      DECLARE t370sub_s1_c3 CURSOR FOR SELECT * FROM inb_file
                                     WHERE inb01 = p_ina01 
 
      LET l_imm01 = ""
      LET g_success = "Y"

      IF cl_null(g_aimp880) THEN   #CHI-C80013 add
         CALL s_showmsg_init()   #No.FUN-6C0083
      END IF                       #CHI-C80013 add   
 
      IF NOT p_inTransaction THEN 
         BEGIN WORK 
      END IF
 
      FOREACH t370sub_s1_c3 INTO l_inb.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_inb.inb04 
         IF g_sma.sma115 = 'Y' THEN
            IF l_ima906 = '2' THEN  #子母單位   
               LET g_unit_arr[1].unit= l_inb.inb902
               LET g_unit_arr[1].fac = l_inb.inb903
               LET g_unit_arr[1].qty = l_inb.inb904
               LET g_unit_arr[2].unit= l_inb.inb905
               LET g_unit_arr[2].fac = l_inb.inb906
               LET g_unit_arr[2].qty = l_inb.inb907
               IF l_ina.ina00 MATCHES '[1256]' THEN
                  CALL s_dismantle(l_ina.ina01,l_inb.inb03,g_ina02,   
                                   l_inb.inb04,l_inb.inb05,l_inb.inb06,
                                   l_inb.inb07,g_unit_arr,l_imm01)
                         RETURNING l_imm01
                  IF g_success='N' THEN   
                     LET g_totsuccess='N'
                     LET g_success="Y"
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF
         END IF
      END FOREACH
 
      IF g_totsuccess="N" THEN    #TQC-620156
         LET g_success="N"
      END IF
      IF cl_null(g_aimp880) THEN   #CHI-C80013 add
         CALL s_showmsg()
      END IF                       #CHI-C80013 add   
 
 
      IF g_success = 'Y' THEN
         IF l_ina.inamksg = 'Y' THEN
            CASE aws_efapp_formapproval()
                 WHEN 0  #呼叫 EasyFlow 簽核失敗
                      LET g_success = "N"
                      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                      RETURN
                 WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
                      RETURN
            END CASE
         END IF
         IF g_success='Y' THEN
            LET l_ina.ina08='1'
            LET l_ina.inapost='Y' 
            IF NOT p_inTransaction THEN COMMIT WORK END IF
            CALL cl_flow_notify(p_ina01,'Y')
         ELSE
            LET g_success = 'N'
            IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         END IF
      ELSE
         LET g_success = 'N'
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      END IF
      IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
         LET l_msg="aimt324 '",l_imm01,"'"
         CALL cl_cmdrun_wait(l_msg)
      END IF
   END IF
 
END FUNCTION

FUNCTION t370sub_s1(p_ina00,p_ina01,p_ina03,p_ina07,p_ina04,p_ina06,p_argv1)
   DEFINE l_dt     LIKE type_file.dat 
   DEFINE l_smg    STRING  
   DEFINE l_flag   LIKE type_file.num5  
   DEFINE p_ina01  LIKE ina_file.ina01 
   DEFINE l_inb    RECORD LIKE inb_file.*
   DEFINE l_inbi   RECORD LIKE inbi_file.*   #FUN-B30187
   DEFINE p_ina00  LIKE ina_file.ina00
   DEFINE p_ina03  LIKE ina_file.ina03
   DEFINE p_ina07  LIKE ina_file.ina07
   DEFINE p_ina04  LIKE ina_file.ina04
   DEFINE p_ina06  LIKE ina_file.ina06
   DEFINE p_argv1   LIKE ina_file.ina00

   IF cl_null(g_aimp880) THEN   #CHI-C80013 add
      CALL s_showmsg_init()   
   END IF                       #CHI-C80013 add
   
   DECLARE t370sub_s1_c CURSOR FOR SELECT * FROM inb_file
                                 WHERE inb01=p_ina01
 
   FOREACH t370sub_s1_c INTO l_inb.*
      IF STATUS THEN
         EXIT FOREACH
      END IF
 
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET l_smg = '_s1() read no:',l_inb.inb03 USING '#####&',' parts: ', l_inb.inb04  
         CALL cl_msg(l_smg)
      ELSE
         IF g_bgjob='N' OR cl_null(g_bgjob) THEN
            DISPLAY '_s1() read no:',l_inb.inb03 USING '#####&',' parts: ', l_inb.inb04 AT 2,1
         END IF
      END IF
 
      IF cl_null(l_inb.inb04) THEN
         CONTINUE FOREACH
      END IF
 
      IF s_industry('icd') THEN
         #FUN-B30187 --START--
         DECLARE t370sub_s2_c SCROLL CURSOR FOR SELECT * FROM inbi_file
                                                 WHERE inbi01=p_ina01 
                                                 AND inbi03 = l_inb.inb03
         OPEN t370sub_s2_c
         FETCH FIRST t370sub_s2_c INTO l_inbi.*
         IF STATUS THEN
            LET g_success = 'N'
            RETURN
         END IF
         CLOSE t370sub_s2_c 
         #FUN-B30187 --END--                                 
         CASE
           WHEN p_argv1 MATCHES '[1256]'
                CALL s_icdpost(-1,l_inb.inb04,l_inb.inb05,l_inb.inb06,
                                  l_inb.inb07,l_inb.inb08,l_inb.inb09,
                                  l_inb.inb01,l_inb.inb03,g_ina02,'Y',
                                  '','',l_inbi.inbiicd029,l_inbi.inbiicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
                  RETURN
               END IF
           WHEN p_argv1 MATCHES '[34]'
                CALL s_icdpost(1,l_inb.inb04,l_inb.inb05,l_inb.inb06,
                                 l_inb.inb07,l_inb.inb08,l_inb.inb09,
                                 l_inb.inb01,l_inb.inb03,g_ina02,'Y',
                                 '','',l_inbi.inbiicd029,l_inbi.inbiicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
                  RETURN
               END IF
         END CASE
      END IF
 
 
      IF p_argv1 MATCHES '[1256]' THEN
         LET l_dt = g_ina02
         IF l_dt IS NULL THEN
            LET l_dt = p_ina03
         END IF
      #FUN-D30024 ----------Begin------------
       # IF NOT s_stkminus(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
       #                   l_inb.inb09,l_inb.inb08_fac,l_dt,g_sma.sma894[1,1]) THEN
         IF NOT s_stkminus(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                           l_inb.inb09,l_inb.inb08_fac,l_dt) THEN 
      #FUN-D30024 ----------End--------------
            LET g_totsuccess="N" 
            CONTINUE FOREACH    
         END IF
      END IF
 
      IF g_sma.sma115 = 'Y' THEN
         CALL t370sub_update_du(p_ina00,p_ina07,p_ina04,p_ina06,l_inb.*)
      END IF
 
      #FUN-AC0074--begin--add----
      IF p_argv1 MATCHES '[12]' THEN
         CALL s_updsie_sie(l_inb.inb01,l_inb.inb03,'3')
      END IF
      #FUN-AC0074--end--add---

      IF g_success='N' THEN   #No.FUN-6C0083
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
 
      CALL t370sub_update(l_inb.inb05,l_inb.inb06,l_inb.inb07,
                       l_inb.inb09,l_inb.inb08,l_inb.inb08_fac,
                       p_ina00,p_ina07,p_ina04,l_inb.inb01,l_inb.inb03,l_inb.inb04,l_inb.inb08)
 
      IF g_success='N' THEN   #No.FUN-6C0083
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
   END FOREACH
 
   IF g_totsuccess="N" THEN    #FUN-610070
      LET g_success="N"
   END IF
   IF cl_null(g_aimp880) THEN   #CHI-C80013 add
      CALL s_showmsg()   #No.FUN-6C0083
   END IF                       #CHI-C80013 add   
 
END FUNCTION

FUNCTION t370sub_update_du(p_ina00,p_ina07,p_ina04,p_ina06,l_inb)
   DEFINE l_ima25   LIKE ima_file.ima25,
          u_type    LIKE type_file.num5,
          p_ina00   LIKE ina_file.ina00,
          p_ina07   LIKE ina_file.ina07,
          p_ina04   LIKE ina_file.ina04,
          p_ina06   LIKE ina_file.ina06,
          l_inb     RECORD LIKE inb_file.*
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_ima907  LIKE ima_file.ima907
 
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
    WHERE ima01 = l_inb.inb04
   IF l_ima906 = '1' OR l_ima906 IS NULL THEN
      RETURN
   END IF
 
   CASE WHEN p_ina00 MATCHES "[12]" LET u_type=-1
	      WHEN p_ina00 MATCHES "[34]" LET u_type=+1
	      WHEN p_ina00 MATCHES "[56]" LET u_type=0
   END CASE
 
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=l_inb.inb04
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('inb04',l_inb.inb04,'Select ima25:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("sel","ima_file",l_inb.inb04,"",SQLCA.sqlcode,"",
                      "Select ima25",1) 
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   IF l_ima906 = '2' THEN  #子母單位
      LET g_unit_arr[1].unit=l_inb.inb902
      LET g_unit_arr[1].fac =l_inb.inb903
      LET g_unit_arr[1].qty =l_inb.inb904
      LET g_unit_arr[2].unit=l_inb.inb905
      LET g_unit_arr[2].fac =l_inb.inb906
      LET g_unit_arr[2].qty =l_inb.inb907
      IF NOT cl_null(l_inb.inb905) THEN
         CALL t370sub_upd_imgg('1',l_inb.inb04,l_inb.inb05,l_inb.inb06,
                         l_inb.inb07,l_inb.inb905,l_inb.inb906,l_inb.inb907,u_type,'2',l_inb.inb01,l_inb.inb03)
         IF g_success='N' THEN
            RETURN
         END IF
         IF NOT cl_null(l_inb.inb907) THEN    
            CALL t370sub_tlff(l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ima25,
                           l_inb.inb907,0,l_inb.inb905,l_inb.inb906,u_type,'2',l_inb.*,p_ina00,p_ina07,p_ina04,p_ina06)
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
      IF NOT cl_null(l_inb.inb902) THEN
         CALL t370sub_upd_imgg('1',l_inb.inb04,l_inb.inb05,l_inb.inb06,
                            l_inb.inb07,l_inb.inb902,l_inb.inb903,l_inb.inb904,u_type,'1',l_inb.inb01,l_inb.inb03)
         IF g_success='N' THEN
            RETURN
         END IF
         IF NOT cl_null(l_inb.inb904) THEN                      
            CALL t370sub_tlff(l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ima25,
                           l_inb.inb904,0,l_inb.inb902,l_inb.inb903,u_type,'1',l_inb.*,p_ina00,p_ina07,p_ina04,p_ina06)
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_inb.inb905) THEN
         CALL t370sub_upd_imgg('2',l_inb.inb04,l_inb.inb05,l_inb.inb06,
                            l_inb.inb07,l_inb.inb905,l_inb.inb906,l_inb.inb907,u_type,'2',l_inb.inb01,l_inb.inb03)
         IF g_success = 'N' THEN
            RETURN
         END IF
         IF NOT cl_null(l_inb.inb907) THEN                                    #CHI-860005
            CALL t370sub_tlff(l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ima25,
                           l_inb.inb907,0,l_inb.inb905,l_inb.inb906,u_type,'2',l_inb.*,p_ina00,p_ina07,p_ina04,p_ina06)
            IF g_success='N' THEN
               RETURN
            END IF
         END IF
      END IF
   END IF
 
END FUNCTION

FUNCTION t370sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_ina01,p_inb03)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_no       LIKE type_file.chr1,   
         p_type     LIKE type_file.num10,
         l_cnt      LIKE type_file.num10,
         p_ina01    LIKE ina_file.ina01,
         p_inb03    LIKE inb_file.inb03,
         l_forupd_sql STRING 
 
    LET l_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
 
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
    DECLARE imgg_lock CURSOR FROM l_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('imgg01',p_imgg01,'OPEN imgg_lock:',STATUS,1) 
       ELSE
          CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       END IF
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('imgg01',p_imgg01,'lock imgg fail',STATUS,1)
       ELSE
          CALL cl_err('lock imgg fail',STATUS,1)
       END IF
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_imgg01,'ima25 null',SQLCA.sqlcode,0)
       ELSE
          CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"",
                       "sel",1)  #No.FUN-660156
       END IF
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       IF g_bgerr THEN
          LET g_showmsg = p_imgg01,"/",p_imgg09,"/",l_ima25
          CALL s_errmsg('imgg01,imgg09,ima25',g_showmsg,'','mfg3075',0)
       ELSE
          CALL cl_err('imgg01','mfg3075',0)
       END IF
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_ina02, 
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'',p_ina01,p_inb03,'',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION t370sub_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag,l_inb,p_ina00,p_ina07,p_ina04,p_ina06)
DEFINE
    p_ware     LIKE img_file.img02,       ##倉庫
    p_loca     LIKE img_file.img03,       ##儲位
    p_lot      LIKE img_file.img04,       ##批號
    p_unit     LIKE img_file.img09,
    p_qty      LIKE img_file.img10,       ##數量  
    p_img10    LIKE img_file.img10,       ##異動後數量
    p_uom      LIKE img_file.img09,       ##img 單位
    p_factor   LIKE img_file.img21,       ##轉換率
    l_imgg10   LIKE imgg_file.imgg10,
    u_type     LIKE type_file.num5,       ##+1:雜收 -1:雜發  0:報廢  
    p_flag     LIKE type_file.chr1
DEFINE l_inb   RECORD LIKE inb_file.*
DEFINE p_ina00 LIKE ina_file.ina00
DEFINE p_ina07 LIKE ina_file.ina07
DEFINE p_ina04 LIKE ina_file.ina04
DEFINE p_ina06 LIKE ina_file.ina06
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
    IF p_uom IS NULL THEN
       IF g_bgerr THEN
          CALL s_errmsg('img09',p_uom,'p_uom null','asf-031',1)
       ELSE
          CALL cl_err('p_uom null:','asf-031',1)
       END IF
       LET g_success = 'N'
       RETURN
    END IF
 
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=l_inb.inb04 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN
       LET l_imgg10 = 0
    END IF
 
    INITIALIZE g_tlff.* TO NULL
    LET g_tlff.tlff01=l_inb.inb04         #異動料件編號
    IF p_ina00 MATCHES "[34]" THEN
       #----來源----
       LET g_tlff.tlff02=90
       LET g_tlff.tlff026=l_inb.inb11        #來源單號
       #---目的----
       LET g_tlff.tlff03=50                  #'Stock'
       LET g_tlff.tlff030=g_plant
       LET g_tlff.tlff031=p_ware             #倉庫
       LET g_tlff.tlff032=p_loca             #儲位
       LET g_tlff.tlff033=p_lot              #批號
       #**該數量錯誤*****
       LET g_tlff.tlff034=l_imgg10           #異動後數量
       LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
       LET g_tlff.tlff036=l_inb.inb01        #雜收單號
       LET g_tlff.tlff037=l_inb.inb03        #雜收項次
    END IF
    IF p_ina00 MATCHES "[1256]" THEN
       #----來源----
       LET g_tlff.tlff02=50                  #'Stock'
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff021=p_ware             #倉庫
       LET g_tlff.tlff022=p_loca             #儲位
       LET g_tlff.tlff023=p_lot              #批號
       LET g_tlff.tlff024=l_imgg10           #異動後數量
       LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
       LET g_tlff.tlff026=l_inb.inb01        #雜發/報廢單號
       LET g_tlff.tlff027=l_inb.inb03        #雜發/報廢項次
       #---目的----
       IF p_ina00 MATCHES "[12]"
          THEN LET g_tlff.tlff03=90
          ELSE LET g_tlff.tlff03=40
       END IF
       LET g_tlff.tlff036=l_inb.inb11        #目的單號
    END IF
    LET g_tlff.tlff04= ' '             #工作站
    LET g_tlff.tlff05= ' '             #作業序號
    LET g_tlff.tlff06=g_ina02      #發料日期
    LET g_tlff.tlff07=g_today          #異動資料產生日期
    LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user           #產生人
    LET g_tlff.tlff10=p_qty            #異動數量
    LET g_tlff.tlff11=p_uom	       #發料單位
    LET g_tlff.tlff12=p_factor         #發料/庫存 換算率
    CASE WHEN p_ina00 = '1' LET g_tlff.tlff13='aimt301'
         WHEN p_ina00 = '2' LET g_tlff.tlff13='aimt311'
         WHEN p_ina00 = '3' LET g_tlff.tlff13='aimt302'
         WHEN p_ina00 = '4' LET g_tlff.tlff13='aimt312'
         WHEN p_ina00 = '5' LET g_tlff.tlff13='aimt303'
         WHEN p_ina00 = '6' LET g_tlff.tlff13='aimt313'
    END CASE
    LET g_tlff.tlff14=l_inb.inb15              #異動原因
    LET g_tlff.tlff17=p_ina07              #Remark
    LET g_tlff.tlff19=p_ina04
    LET g_tlff.tlff20=p_ina06              #Project code
 
    LET g_tlff.tlff62=l_inb.inb12    #參考單號
    LET g_tlff.tlff64=l_inb.inb901   #手冊編號  no.A050
    LET g_tlff.tlff930=l_inb.inb930 
    IF cl_null(l_inb.inb907) OR l_inb.inb907=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,l_inb.inb905)
    END IF
END FUNCTION

FUNCTION t370sub_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_ina00,p_ina07,p_ina04,p_inb01,p_inb03,p_inb04,p_inb08)
  DEFINE p_ware     LIKE img_file.img02,       #倉庫
         p_loca     LIKE img_file.img03,       #儲位
         p_lot      LIKE img_file.img04,       #批號
         p_qty      LIKE tlf_file.tlf10,       #數量
         p_uom      LIKE img_file.img09,       ##img 單位
         p_factor   LIKE ima_file.ima31_fac,   #轉換率  
         u_type     LIKE type_file.num5,       # +1:雜收 -1:雜發  0:報廢 
         l_qty      LIKE img_file.img10,  
         l_ima01    LIKE ima_file.ima01,
         l_ima25    LIKE ima_file.ima25,
         l_imaqty   LIKE type_file.num15_3,
         l_imafac   LIKE img_file.img21,
         l_img      RECORD
         img10      LIKE img_file.img10,
         img16      LIKE img_file.img16,
         img23      LIKE img_file.img23,
         img24      LIKE img_file.img24,
         img09      LIKE img_file.img09,
         img21      LIKE img_file.img21
                    END RECORD,
         l_cnt     LIKE type_file.num5   
  DEFINE p_inb01   LIKE inb_file.inb01
  DEFINE p_inb03   LIKE inb_file.inb03
  DEFINE p_inb04   LIKE inb_file.inb04
  DEFINE p_inb08   LIKE inb_file.inb08
  DEFINE p_ina00   LIKE ina_file.ina00
  DEFINE p_ina07   LIKE ina_file.ina07
  DEFINE p_ina04   LIKE ina_file.ina04
  DEFINE l_msg,l_forupd_sql     STRING        
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty =0   END IF
 
    IF p_uom IS NULL THEN
       IF g_bgerr THEN
          CALL s_errmsg('img09',p_uom,'p_uom null:','asf-031',1)
       ELSE
          CALL cl_err('p_uom null:','asf-031',1)
       END IF
       LET g_success = 'N'
       RETURN
    END IF
    CALL cl_msg("update img_file ...")                   #FUN-640245
 
    LET l_forupd_sql =
        "SELECT img10,img16,img23,img24,img09,img21 FROM img_file ",
        " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ?  FOR UPDATE "
 
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
    DECLARE img_lock CURSOR FROM l_forupd_sql
 
    OPEN img_lock USING p_inb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('img01',p_inb04,'OPEN img_lock:',STATUS,1)
       ELSE
          CALL cl_err("OPEN img_lock:", STATUS, 1)
       END IF
       LET g_success='N'
       CLOSE img_lock
       RETURN
    END IF
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('img01',p_inb04,'lock img fail',STATUS,1) 
       ELSE
          CALL cl_err('lock img fail',STATUS,1)
       END IF
       LET g_success='N'
       CLOSE img_lock
       RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF

    CASE WHEN p_ina00 MATCHES "[12]" LET u_type=-1
              LET l_qty= l_img.img10 - p_qty*p_factor 
	       WHEN p_ina00 MATCHES "[34]" LET u_type=+1
              LET l_qty= l_img.img10 + p_qty*p_factor  
	       WHEN p_ina00 MATCHES "[56]" LET u_type=0
              LET l_qty= l_img.img10 - p_qty*p_factor  
    END CASE
    CALL s_upimg(p_inb04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_ina02,
          '','','','',p_inb01,p_inb03,  
          '','','','','','','','','','','','')
    IF g_success='N' THEN
       RETURN
    END IF
    CALL cl_msg("update ima_file ...")  
 
    LET l_forupd_sql =
        "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE " 
 
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
    DECLARE ima_lock CURSOR FROM l_forupd_sql
 
    OPEN ima_lock USING p_inb04
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_inb04,'OPEN ima_lock',STATUS,1) 
       ELSE
          CALL cl_err("OPEN ima_lock:", STATUS, 1)
       END IF
       LET g_success = 'N'
       CLOSE ima_lock
       RETURN
    END IF
 
    FETCH ima_lock INTO l_ima25 
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_inb04,'lock ima fail',STATUS,1) 
       ELSE
          CALL cl_err('lock img fail',STATUS,1)
       END IF
       LET g_success = 'N'
       CLOSE ima_lock
       RETURN
    END IF
 
    IF p_inb08=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(p_inb04,p_inb08,l_ima25)
                RETURNING l_cnt,l_imafac
    ##Modify:98/11/13----單位換算率抓不到--------###
       IF l_cnt = 1 THEN
          IF g_bgerr THEN
             LET g_showmsg = p_inb04,"/",p_inb08,"/",l_ima25
             CALL s_errmsg('inb04,inb08,ima25',g_showmsg,'','abm-731',1)
          ELSE
             CALL cl_err(p_inb03,'abm-731',1)
          END IF
          LET g_success ='N'
       END IF
    END IF
 
    IF cl_null(l_imafac) THEN
       LET l_imafac = 1
    END IF
    LET l_imaqty = p_qty * l_imafac
    CALL s_udima(p_inb04,l_img.img23,l_img.img24,l_imaqty,
                    g_ina02,u_type)  RETURNING l_cnt
    IF g_success='N' THEN
       RETURN
    END IF
 
    CALL cl_msg("insert tlf_file ...")                   #FUN-640245
    IF g_success='Y' THEN
       CALL t370sub_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,
                     u_type,p_inb01,p_inb03,p_ina00,p_ina07,p_ina04)
    END IF
    LET l_msg = "seq#",p_inb03 USING'<<<',' post ok!'
    CALL cl_msg(l_msg)
END FUNCTION

FUNCTION t370sub_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                  u_type,p_inb01,p_inb03,p_ina00,p_ina07,p_ina04)
   DEFINE
      p_ware   LIKE img_file.img02,       #倉庫     
      p_loca   LIKE img_file.img03,       #儲位   
      p_lot    LIKE img_file.img04,       #批號   
      p_qty    LIKE tlf_file.tlf10,       
      p_uom    LIKE img_file.img09,       ##img 單位
      p_factor LIKE ima_file.ima31_fac,   ##轉換率 
      p_unit   LIKE ima_file.ima25,       ##單位
      p_img10  LIKE img_file.img10,       #異動後數量
      u_type   LIKE type_file.num5,  	    # +1:雜收 -1:雜發  0:報廢 
      l_sfb02  LIKE sfb_file.sfb02,
      l_sfb03  LIKE sfb_file.sfb03,
      l_sfb04  LIKE sfb_file.sfb04,
      l_sfb22  LIKE sfb_file.sfb22,
      l_sfb27  LIKE sfb_file.sfb27,
      l_sta    LIKE type_file.num5,   
      p_inb01  LIKE inb_file.inb01,
      p_inb03  LIKE inb_file.inb03,
      p_ina00  LIKE ina_file.ina00,
      p_ina07  LIKE ina_file.ina07,
      p_ina04  LIKE ina_file.ina04 
   DEFINE l_inb   RECORD LIKE inb_file.*   
 
   SELECT * INTO l_inb.* FROM inb_file WHERE inb01=p_inb01 AND inb03=p_inb03
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01=l_inb.inb04         #異動料件編號
   IF p_ina00 MATCHES "[34]" THEN
      #----來源----
      LET g_tlf.tlf02=90
      LET g_tlf.tlf026=l_inb.inb11        #來源單號
      #---目的----
      LET g_tlf.tlf03=50                  #'Stock'
      LET g_tlf.tlf030=g_plant
      LET g_tlf.tlf031=p_ware             #倉庫
      LET g_tlf.tlf032=p_loca             #儲位
      LET g_tlf.tlf033=p_lot              #批號
      LET g_tlf.tlf034=p_img10            #異動後數量
      LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=l_inb.inb01        #雜收單號
      LET g_tlf.tlf037=l_inb.inb03        #雜收項次
   END IF
   IF p_ina00 MATCHES "[1256]" THEN
      #----來源----
      LET g_tlf.tlf02=50                  #'Stock'
      LET g_tlf.tlf020=g_plant
      LET g_tlf.tlf021=p_ware             #倉庫
      LET g_tlf.tlf022=p_loca             #儲位
      LET g_tlf.tlf023=p_lot              #批號
      LET g_tlf.tlf024=p_img10            #異動後數量
      LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=l_inb.inb01        #雜發/報廢單號
      LET g_tlf.tlf027=l_inb.inb03        #雜發/報廢項次
      #---目的----
      IF p_ina00 MATCHES "[12]"
         THEN LET g_tlf.tlf03=90
         ELSE LET g_tlf.tlf03=40
      END IF
      LET g_tlf.tlf036=l_inb.inb11        #目的單號
   END IF
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=g_ina02          #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom	          #發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
	CASE WHEN p_ina00 = '1' LET g_tlf.tlf13='aimt301'
	     WHEN p_ina00 = '2' LET g_tlf.tlf13='aimt311'
	     WHEN p_ina00 = '3' LET g_tlf.tlf13='aimt302'
	     WHEN p_ina00 = '4' LET g_tlf.tlf13='aimt312'
	     WHEN p_ina00 = '5' LET g_tlf.tlf13='aimt303'
	     WHEN p_ina00 = '6' LET g_tlf.tlf13='aimt313'
	END CASE
   LET g_tlf.tlf14=l_inb.inb15          #異動原因
   LET g_tlf.tlf17=p_ina07              #Remark
   LET g_tlf.tlf19=p_ina04
   LET g_tlf.tlf20=l_inb.inb41
   LET g_tlf.tlf41=l_inb.inb42
   LET g_tlf.tlf42=l_inb.inb43
   LET g_tlf.tlf43=l_inb.inb15
 
   LET g_tlf.tlf62=l_inb.inb12    #參考單號
   LET g_tlf.tlf64=l_inb.inb901   #手冊編號  no.A050
   LET g_tlf.tlf930=l_inb.inb930
   CALL s_tlf(1,0)
END FUNCTION

#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post='Y' 會詢問"是否執行過帳"
FUNCTION t370sub_z(p_ina01,p_ask_post,p_inTransaction)
   DEFINE l_cnt     LIKE type_file.num5  
   DEFINE l_sql     LIKE type_file.chr1000         
   DEFINE l_inb09   LIKE inb_file.inb09,                                        
          l_inb04   LIKE inb_file.inb04,                                        
          l_inb03   LIKE inb_file.inb03,                                        
          l_inb10   LIKE inb_file.inb10,                                        
          l_qcs01   LIKE qcs_file.qcs01,                                        
          l_qcs02   LIKE qcs_file.qcs02,                                        
          l_qcs091c LIKE qcs_file.qcs091
   DEFINE p_ina01   LIKE ina_file.ina01
   DEFINE l_ina     RECORD LIKE ina_file.*
   DEFINE p_inTransaction LIKE type_file.num5
   DEFINE p_ask_post      LIKE type_file.chr1
   DEFINE l_inb44   LIKE inb_file.inb44    #FUN-BC0104
   DEFINE l_inacont       LIKE ina_file.inacont   #FUN-D20059

   IF cl_null(p_ina01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO l_ina.* FROM ina_file WHERE ina01 =p_ina01 
   IF l_ina.inaconf='N' THEN RETURN END IF
   IF l_ina.inaconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   #-->POS單號不為空時不可取消確認
   IF NOT cl_null(l_ina.ina13) THEN
      CALL cl_err(' ','axm-743',1)
      RETURN
   END IF 

   #FUN-AC0074--begin--add----
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM sie_file
     WHERE sie05=p_ina01
    IF l_cnt > 0 THEN
       CALL cl_err('','axm-248',0)
       RETURN
    END IF
    #FUN-AC0074--end--add----
 
   LET l_sql = " SELECT inb03,inb09,inb10,inb04,inb01,inb03,inb44 FROM inb_file ",    #FUN-BC0104 add inb44
               "  WHERE inb01 = '",p_ina01,"'"
 
   PREPARE t370sub_curs3 FROM l_sql
   DECLARE t370sub_pre3 CURSOR FOR t370sub_curs3
 
   FOREACH t370sub_pre3 INTO l_inb03,l_inb09,l_inb10,l_inb04,l_qcs01,l_qcs02,l_inb44     #FUN-BC0104 add inb44
      #TQC-C20194-add-str--
      IF NOT cl_null(l_inb44) THEN
         CONTINUE FOREACH
      END IF
      #TQC-C20194-add-end--
      IF l_inb10 = 'Y' THEN
         LET l_qcs091c = 0
         SELECT SUM(qcs091) INTO l_qcs091c
           FROM qcs_file
          WHERE qcs01 = p_ina01  
            AND qcs02 = l_inb03
           #AND qcs14 = 'Y'        #MOD-C30278 mark
            AND qcs14 <>'X'        #MOD-C30278
         IF cl_null(l_qcs091c) THEN
            CONTINUE FOREACH
         END IF 
         IF l_inb09 <= l_qcs091c THEN
            CALL cl_err(l_inb04,'mfg3989',1)
            RETURN
         END IF
      END IF
   END FOREACH
   IF l_ina.inapost='Y' THEN
      CALL cl_err('inapost=Y:','afa-101',0)
      RETURN
   END IF
 
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF
 
   CALL t370sub_lock_cl()
   OPEN t370sub_cl USING p_ina01
   IF STATUS THEN
      CALL cl_err("OPEN t370sub_cl:", STATUS, 1)
      CLOSE t370sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      RETURN
   END IF
   FETCH t370sub_cl INTO l_ina.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(p_ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t370sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      RETURN
   END IF
   IF p_ask_post='Y' THEN
      IF NOT cl_confirm('axm-109') THEN 
         CLOSE t370sub_cl
         IF NOT p_inTransaction THEN ROLLBACK WORK END IF
         RETURN 
      END IF
   END IF   

   LET g_success = 'Y'
 #FUN-D20059--str--
   LET l_inacont = TIME      #FUN-D20059
#   UPDATE ina_file SET inaconf = 'N',inacont = '',ina08='0', inapos='N'  
#                        ,inacond = '',inaconu = ''  
   UPDATE ina_file SET inaconf = 'N',inacont = l_inacont,ina08='0', inapos='N'
                       ,inacond = g_today,inaconu = g_user
 #FUN-D20059--end--
    WHERE ina01 = p_ina01 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
   END IF


   #DEV-D30045--add--begin
   #自動作廢barcode
   IF g_success='Y' AND g_prog = 'aimt302' AND g_aza.aza131 = 'Y' THEN
      CALL t370sub_barcode_z(p_ina01)
   END IF
   #DEV-D30045--add--end

   IF g_success = 'Y' THEN
      IF NOT p_inTransaction THEN COMMIT WORK END IF
   ELSE
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
   END IF
   CLOSE t370sub_cl   

END FUNCTION

#將FUNCTION t370_g_bom2中新增inb_file的邏輯獨立出FUNCTION t370sub_ins_inb()
FUNCTION t370sub_ins_inb(b_inb,b_inbi,p_inb09,p_inb930,p_inb15,p_inb15_1,p_inb10)  
DEFINE  p_inb09   LIKE inb_file.inb09
DEFINE  p_inb930  LIKE inb_file.inb930
DEFINE  p_inb15   LIKE inb_file.inb15
DEFINE  p_inb15_1 LIKE inb_file.inb15
DEFINE  p_inb10   LIKE inb_file.inb10  
DEFINE  b_inb     RECORD LIKE inb_file.*
DEFINE  b_inbi    RECORD LIKE inbi_file.*
DEFINE  l_ima44   LIKE ima_file.ima44
DEFINE  l_ima906  LIKE ima_file.ima906
DEFINE  l_ima907  LIKE ima_file.ima907
DEFINE  l_ima908  LIKE ima_file.ima908
DEFINE  l_cnt     LIKE type_file.num5
DEFINE  l_factor  LIKE ima_file.ima31_fac
DEFINE  l_ima15   LIKE ima_file.ima15 
DEFINE  l_flag    LIKE type_file.num5    #FUN-C20076
DEFINE  l_ina00   LIKE ina_file.ina00    #FUN-D60038 add
DEFINE  l_ina02   LIKE ina_file.ina02    #FUN-D60038 add
DEFINE  l_img_flag LIKE type_file.chr1   #FUN-D60038 add

#需要給標示位記錄成功與否  
   SELECT MAX(inb03) INTO b_inb.inb03 FROM inb_file
    WHERE inb01 = b_inb.inb01
   IF cl_null(b_inb.inb03) THEN
      LET b_inb.inb03 = 0
   END IF
   LET b_inb.inb03=b_inb.inb03+1
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
        FROM ima_file
       WHERE ima01=b_inb.inb04
      IF l_ima906 MATCHES '[23]' THEN
          SELECT ima25 INTO b_inb.inb902 FROM inb_file
           WHERE ima01 = b_inb.inb04
          LET b_inb.inb905 = b_inb.inb902
      ELSE
         SELECT ima25,ima907 INTO b_inb.inb902,b_inb.inb905
           FROM ima_file WHERE ima01 = b_inb.inb04
      END IF
      LET l_factor = 1
      CALL s_umfchk(b_inb.inb04,b_inb.inb902,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET b_inb.inb903=l_factor
      LET b_inb.inb904=b_inb.inb09
      LET b_inb.inb905=l_ima907
      LET l_factor = 1
      CALL s_umfchk(b_inb.inb04,b_inb.inb905,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET b_inb.inb906=l_factor
      LET b_inb.inb907=0
      #多單位的賦值有問題*
      IF l_ima906 = '3' THEN
         LET l_factor = 1
         CALL s_umfchk(b_inb.inb04,b_inb.inb902,b_inb.inb905)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET b_inb.inb907=b_inb.inb904*l_factor
         LET b_inb.inb907=s_digqty(b_inb.inb907,b_inb.inb905)   
      END IF
   END IF 
   SELECT ima908 INTO l_ima908
     FROM ima_file
    WHERE ima01=b_inb.inb04

   LET b_inb.inb09 = p_inb09
   LET b_inb.inb16 = p_inb09

   SELECT ima15 INTO l_ima15 FROM ima_file
    WHERE ima01 = b_inb.inb04
    
   IF g_sma.sma79 = 'Y' AND l_ima15 = 'Y' THEN
      LET b_inb.inb15 = p_inb15_1
   ELSE
      LET b_inb.inb15 = p_inb15
   END IF

   LET b_inb.inb930 = p_inb930
   LET b_inb.inb922 = b_inb.inb902     #申請單位一                
   LET b_inb.inb923 = b_inb.inb903     #申請單位一換算率          
   LET b_inb.inb924 = b_inb.inb904     #申請單位一數量            
   LET b_inb.inb10 = p_inb10 
   IF cl_null(b_inb.inb06) THEN LET b_inb.inb06 = ' ' END IF  
   IF cl_null(b_inb.inb07) THEN LET b_inb.inb07 = ' ' END IF  
   LET b_inb.inblegal = g_legal   
   LET b_inb.inbplant = g_plant   
#FUN-C20076 -----------------Begin-------------------
   IF g_sma.sma115 = 'Y' THEN
      IF l_ima906 MATCHES '[23]' THEN
         IF l_ima906 = '2' THEN
            LET l_flag = 0
            CALL s_chk_imgg(b_inb.inb04,b_inb.inb05,
                            b_inb.inb06,b_inb.inb07,
                            b_inb.inb902) RETURNING l_flag
            IF l_flag = 1 THEN
               IF g_sma.sma892[3,3] = 'Y' THEN
                  CALL s_add_imgg(b_inb.inb04,b_inb.inb05,
                                  b_inb.inb06,b_inb.inb07,
                                  b_inb.inb902,b_inb.inb903,
                                  b_inb.inb01,
                                  b_inb.inb03,0)
                       RETURNING l_flag
               END IF
               IF l_flag = 1 THEN
                  LET g_success = 'N'
                  RETURN FALSE 
               END IF
            END IF
         END IF 
  
         LET l_flag = 0
         CALL s_chk_imgg(b_inb.inb04,b_inb.inb05,
                         b_inb.inb06,b_inb.inb07,
                         b_inb.inb905) RETURNING l_flag
         IF l_flag = 1 THEN
            IF g_sma.sma892[3,3] = 'Y' THEN
               CALL s_add_imgg(b_inb.inb04,b_inb.inb05,
                               b_inb.inb06,b_inb.inb07,
                               b_inb.inb905,b_inb.inb906,
                               b_inb.inb01,
                               b_inb.inb03,0)
                 RETURNING l_flag
            END IF
            IF l_flag = 1 THEN
               LET g_success = 'N'
               RETURN FALSE
            END IF
         END IF
      END IF
   END IF
#FUN-C20076 -----------------End---------------------

   #FUN-D60038--add--str-- 寫入單身
   LET l_cnt = 0
   LET l_img_flag = ''
   SELECT ina00,ina02 INTO l_ina00,l_ina02 FROM ina_file WHERE ina01 = b_inb.inb01
   SELECT COUNT(*) INTO l_cnt FROM img_file
    WHERE img01=b_inb.inb04 AND img02=b_inb.inb05
      AND img03=b_inb.inb06 AND img04=b_inb.inb07
   IF l_cnt = 0 AND l_ina00 MATCHES '[34]' THEN
      IF cl_null(l_img_flag) THEN
         LET l_img_flag = 'Y'
         IF g_sma.sma892[3,3] = 'Y' THEN
            IF g_bgjob='N' OR cl_null(g_bgjob) THEN
               IF NOT cl_confirm('mfg1401') THEN
                  LET l_img_flag = 'N'
               END IF
            END IF
         END IF
      END IF
      IF l_img_flag = 'Y' THEN
         CALL s_add_img(b_inb.inb04,b_inb.inb05,b_inb.inb06,b_inb.inb07,b_inb.inb01,b_inb.inb03,l_ina02)
      END IF
   END IF
   #FUN-D60038--add--end--

   INSERT INTO inb_file VALUES(b_inb.*)
   IF SQLCA.SQLCODE THEN
      ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE                    
   ELSE
      IF s_industry('icd') THEN        #插入行業別資料                
         LET b_inbi.inbi01 = b_inb.inb01
         LET b_inbi.inbi03 = b_inb.inb03
         LET b_inbi.inbilegal = b_inb.inblegal
         LET b_inbi.inbiplant = b_inb.inbplant
         IF NOT s_ins_inbi(b_inbi.*,b_inb.inbplant) THEN
            RETURN FALSE
         END IF
      END IF    
   END IF  
   RETURN TRUE                   
END FUNCTION 
#FUN-B50138

#DEV-D30037--add--begin
FUNCTION t370sub_chk_smyb2(p_ina01)
   DEFINE p_ina01    LIKE ina_file.ina01
   DEFINE l_ima01    LIKE ima_file.ima01
   DEFINE l_ima931   LIKE ima_file.ima931
   DEFINE l_smyb01   LIKE smyb_file.smyb01

   LET l_smyb01 = '1'

   IF g_aza.aza131 = 'N' OR cl_null(g_aza.aza131) THEN
      RETURN l_smyb01
   END IF

   #找出第一筆資料
   LET l_ima01 = ''
   SELECT inb04 INTO l_ima01
     FROM inb_file
    WHERE inb01 = p_ina01
      AND inb03 = (SELECT MIN(inb03) FROM inb_file
                    WHERE inb01 = p_ina01)

   LET l_ima931 = ''
   SELECT ima931
     INTO l_ima931
     FROM ima_file
    WHERE ima01 = l_ima01
   IF cl_null(l_ima931) THEN LET l_ima931 = 'N' END IF

   IF l_ima931 = 'Y' THEN
      LET l_smyb01 = '2'
   END IF

   RETURN l_smyb01

END FUNCTION
#DEV-D30037--add--end

#DEV-D30045--add--begin
FUNCTION t370sub_barcode_gen(p_ina01,p_ask)
   DEFINE p_ina01   LIKE ina_file.ina01
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_ina     RECORD LIKE ina_file.*
   DEFINE l_inb03   LIKE inb_file.inb03
   DEFINE l_inb04   LIKE inb_file.inb04
   DEFINE l_inb09   LIKE inb_file.inb09
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima920  LIKE ima_file.ima920
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima923  LIKE ima_file.ima923
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_ima933  LIKE ima_file.ima933
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_ina01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_ina.* FROM ina_file WHERE ina01 = p_ina01

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('I',l_ina.ina01,'','') THEN
      RETURN
   END IF

   IF l_ina.inaconf = 'N' THEN
      CALL cl_err('','sfb-999',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF l_ina.inaconf = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk(l_ina.ina01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN   
      IF NOT cl_confirm('azz1276') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()
   BEGIN WORK

   CALL t370sub_lock_cl()

   OPEN t370sub_cl USING l_ina.ina01
   IF STATUS THEN
      CALL cl_err("OPEN t370sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t370sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t370sub_cl INTO l_ina.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_ina.ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t370sub_cl
      ROLLBACK WORK
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_ina.ina01,'','','I') THEN
   #   LET g_success = 'N'
   #END IF

   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2('I',l_ina.ina01,'','')
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2('I',l_ina.ina01,'','')
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_ina.ina01,'','','I') THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end

   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_msgany(0,0,'aba-001')
   ELSE
      ROLLBACK WORK
      #CALL cl_msgany(0,0,'aba-002')    #DEV-D40015--mark
      CALL cl_err('','aba-002',0)       #DEV-D40015--mod
   END IF
END FUNCTION

FUNCTION t370sub_barcode_z(p_ina01)
   DEFINE p_ina01   LIKE ina_file.ina01
   DEFINE l_ina     RECORD LIKE ina_file.*
   DEFINE l_inb03   LIKE inb_file.inb03
   DEFINE l_inb04   LIKE inb_file.inb04
   DEFINE l_inb09   LIKE inb_file.inb09
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima920  LIKE ima_file.ima920
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima923  LIKE ima_file.ima923
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_ima933  LIKE ima_file.ima933
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_ina01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO l_ina.* FROM ina_file WHERE ina01 =p_ina01 

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('I',l_ina.ina01,'','') THEN
      RETURN
   END IF

   IF l_ina.inaconf = 'X' THEN
      CALL cl_err(' ','9024',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk2(l_ina.ina01) THEN
      LET g_success = 'N'
      RETURN
   END IF

  #LET g_success = 'Y' #DEV-D40015 mark 
  #BEGIN WORK          #DEV-D40015 mark

   CALL t370sub_lock_cl()

   OPEN t370sub_cl USING l_ina.ina01
   IF STATUS THEN
      CALL cl_err("OPEN t370sub_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t370sub_cl
     #ROLLBACK WORK     #DEV-D40015 mark
      RETURN
   END IF
   FETCH t370sub_cl INTO l_ina.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_ina.ina01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t370sub_cl
      #ROLLBACK WORK  #DEV-D40015 mark
      RETURN
   END IF

   IF g_success='Y' THEN
      CALL s_barcode_x2('I',l_ina.ina01,'','')
   END IF

   IF g_success='Y' THEN
      #COMMIT WORK       #DEV-D40015 mark
      CALL cl_msgany(0,0,'aba-178')
   ELSE
      #ROLLBACK WORK     #DEV-D40015 mark
      CALL cl_msgany(0,0,'aba-179')
   END IF
END FUNCTION
#DEV-D30045--add--end

#CHI-C80013 str add-----
FUNCTION t370sub_aimp880()

    LET g_aimp880 = 'Y'

END FUNCTION
#CHI-C80013 end add-----

