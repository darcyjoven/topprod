# Prog. Version..: '5.30.06-13.03.22(00010)'     #
#
# Pattern name...: axmt650_sub.4gl
# Descriptions...: 將原axmt650.4gl確認段拆解至axmt650_sub.4gl
# Date & Author..: #FUN-B10004 11/01/04 By Mandy
# Modify.........: No:MOD-B30651 11/03/30 by Summer 修改判別有效天數
# Modify.........: No:FUN-950062 11/05/12 By lixiang 庫存扣賬時回到出貨日期oga02
# Modify.........: No:TQC-BB0096 11/11/10 By zhangll 修正事物異常導致的扣帳失敗資料會寫成功的情況
# Modify.........: No.FUN-BA0051 11/11/14 By jason 一批號多DATECODE功能
# Modify.........: No:FUN-B80178 11/11/14 By jason 新增ICD確認，過帳段 
# Modify.........: No:FUN-BA0019 11/11/21 By jason ICD多倉儲批功能
# Modify.........: No:MOD-BC0188 11/12/19 By ck2yuan 寫入tlf13應為axmt650 而非axmt650_sub
# Modify.........: No:FUN-BB0086 11/12/22 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-BB0084 11/12/23 By lixh1 增加數量欄位小數取位(ogb_file)
# Modify.........: No:FUN-BB0167 12/02/22 By suncx 新增無訂單簽收相關功能
# Modify.........: No:CHI-C30064 12/03/14 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No:MOD-C30816 12/03/21 By Vampire 寫入tlff13應為axmt650 而非axmt650_sub
# Modify.........: No:CHI-C30106 12/04/06 By Elise 批序號維護
# Modify.........: No.FUN-C40089 12/05/02 By bart 判斷銷售價格條件(axmi060)的oah08,若oah08為Y則單價欄位可輸入0;若oah08為N則單價欄位不可輸入0
# Modify.........: No.FUN-C50074 12/05/18 By bart 更改錯誤訊息代碼
# Modify.........: No.TQC-C50206 12/05/25 By zhuhao 審核時加倉管員控管
# Modify.........: No.FUN-C50097 12/06/09 By SunLM 當oaz92=Y(立賬走開票流程)且大陸版時,判斷參數oaz94='Y'(出貨多次簽收)時,增加多次簽收功能
# Modify.........: No.FUN-C50136 12/07/06 By xianghui 修改信用管段，新增信用管控的方法
# Modify.........: No:TQC-C70206 12/07/27 By SunLM將FUN-C50097中，非多次多次簽收功能過單到正式區，既與oaz94無關的參數。
# Modify.........: No:MOD-CB0050 12/11/12 By SunLM 走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
# Modify.........:                                 出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
# Modify.........: No:MOD-D10093 13/01/28 By Elise 確認時檢查單身是否有數量為0
# Modify.........: No:MOD-CB0111 13/01/31 By jt_chen 修正:因FUN-630102將adq改為tuq,adp改為tup、FUN-650108已經將ATM合併至AXM
# Modify.........: No.MOD-CA0162 13/02/01 By jt_chen 無訂單出貨扣帳時tlf20沒寫入專案代碼
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷                                                  
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No.2021112601 21/11/26 By jc 自动审核扣账取消弹框询问

DATABASE ds
GLOBALS "../../config/top.global"
GLOBALS "../4gl/axmt650.global"

DEFINE g_oah08   LIKE oah_file.oah08   #FUN-C40089

FUNCTION t650sub_lock_cl() 
  DEFINE l_forupd_sql STRING

  LET l_forupd_sql = "SELECT * FROM oga_file WHERE oga01 = ?  FOR UPDATE"
  LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
  DECLARE t650sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

FUNCTION t650sub_y(p_oga01)             # when g_oga.ogaconf='N' (Turn to 'Y')
   DEFINE p_oga01         LIKE oga_file.oga01
   DEFINE l_yy,l_mm,l_n   LIKE type_file.num5 
   DEFINE g_start,g_end	  LIKE oga_file.oga01 
   DEFINE l_cnt           LIKE type_file.num5 
   DEFINE l_ogb09         LIKE ogb_file.ogb09
   WHENEVER ERROR CONTINUE

  #CHI-C30106---S---
   IF g_prog <> 'aws_ttsrv2' AND g_argv2 <> 'M' THEN    #2021112601 add g_argv2 <> 'M'
       IF NOT cl_confirm('axm-108') THEN
           LET g_success = 'N'
           ROLLBACK WORK
           RETURN 
       END IF 
   END IF  
  #CHI-C30106---E---
 
   LET g_oga.oga01 = p_oga01
   CALL t650sub_lock_cl()
   IF g_prog <> 'aws_ttsrv2' THEN
       BEGIN WORK
   END IF
 
   OPEN t650sub_cl USING g_oga.oga01
   IF STATUS THEN
      CALL cl_err("OPEN t650sub_cl:", STATUS, 1)
      LET g_errno = STATUS
      LET g_success = 'N'
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
      CLOSE t650sub_cl
      RETURN
   END IF
 
   FETCH t650sub_cl INTO g_oga.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
      LET g_errno = SQLCA.sqlcode
      LET g_success = 'N'
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
      CLOSE t650sub_cl 
      RETURN
   END IF

   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM ogb_file
    WHERE ogb01=g_oga.oga01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      LET g_errno = 'mfg-009'
      LET g_success = 'N'
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
      RETURN
   END IF
 
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
   IF g_oga.ogaconf='Y' THEN 
      CALL cl_err('',9023,0) 
      LET g_errno = '9023' #此筆資料已確認
      LET g_success = 'N'
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
      RETURN 
   END IF 
   IF g_oga.ogaconf = 'X' THEN 
      CALL cl_err('',9024,0) 
      LET g_errno = '9024'
      LET g_success = 'N'
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
      RETURN 
   END IF
   #FUN-C40089---begin
   SELECT oah08 INTO g_oah08 FROM oah_file WHERE oah01=g_oga.oga31
   IF cl_null(g_oah08) THEN
      LET g_oah08 = 'Y'
   END IF
   IF g_oah08= 'N' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ogb_file
             WHERE ogb01= g_oga.oga01 AND ogb13 = 0
      IF l_cnt > 0 THEN
         CALL cl_err('','axm-627',1)  #FUN-C50074
         LET g_success = 'N'
         IF g_prog <> 'aws_ttsrv2' THEN
             ROLLBACK WORK
         END IF
         RETURN
      END IF
   END IF

   #FUN-C40089---end
   #---若現行年月大於出貨單/銷退單之年月--不允許確認-----
   CALL s_yp(g_oga.oga02) RETURNING l_yy,l_mm
   IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
       CALL cl_err('','mfg6090',0)  
       LET g_errno = 'mfg6090'
       LET g_success = 'N'
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK
       END IF
       RETURN
   END IF
   IF g_oaz.oaz03 = 'Y' AND
      g_sma.sma53 IS NOT NULL AND g_oga.oga02 <= g_sma.sma53 THEN
       CALL cl_err('','mfg9999',0) 
       LET g_errno = 'mfg9999'
       LET g_success = 'N'
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK
       END IF
       RETURN 
   END IF

  #MOD-D10093 add start ----- 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
     WHERE oga01 = ogb01
       AND oga01 = g_oga.oga01
       AND (ogb12 IS NULL OR ogb12 <= 0)
   IF l_cnt > 0 THEN
      CALL cl_err('','mfg3348',0)
      LET g_success = 'N'
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
      RETURN
   END IF 
  #MOD-D10093 add start -----

   IF NOT s_chk_ware(g_oga.oga66) THEN
       LET g_success = 'N'
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK
       END IF
       RETURN
   END IF
   IF NOT s_chk_ware(g_oga.oga910) THEN
       LET g_success = 'N'
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK
       END IF
       RETURN
   END IF
   DECLARE t650sub_ware_cs0 CURSOR FOR
    SELECT ogb09 FROM ogb_file
     WHERE ogb01 = g_oga.oga01
   FOREACH t650sub_ware_cs0 INTO l_ogb09
       IF NOT s_chk_ware(l_ogb09) THEN
           LET g_success = 'N'
           IF g_prog <> 'aws_ttsrv2' THEN
               ROLLBACK WORK
           END IF
           RETURN
       END IF
   END FOREACH
   DECLARE t650sub_ware_cs1 CURSOR FOR
    SELECT ogg09 FROM ogg_file
     WHERE ogg01 = g_oga.oga01
   FOREACH t650sub_ware_cs1 INTO l_ogb09
       IF NOT s_chk_ware(l_ogb09) THEN
           LET g_success = 'N'
           IF g_prog <> 'aws_ttsrv2' THEN
               ROLLBACK WORK
           END IF
           RETURN
       END IF
   END FOREACH
   DECLARE t650sub_ware_cs2 CURSOR FOR
    SELECT ogc09 FROM ogc_file
     WHERE ogc01 = g_oga.oga01
   FOREACH t650sub_ware_cs2 INTO l_ogb09
       IF NOT s_chk_ware(l_ogb09) THEN
           LET g_success = 'N'
           IF g_prog <> 'aws_ttsrv2' THEN
               ROLLBACK WORK
           END IF
           RETURN
       END IF
   END FOREACH

  #CHI-C30106---mark---S---
  #IF g_prog <> 'aws_ttsrv2' THEN
  #    IF NOT cl_confirm('axm-108') THEN 
  #        LET g_success = 'N'
  #        ROLLBACK WORK 
  #        RETURN 
  #    END IF 
  #END IF
  #CHI-C30106---mark---E--- 
 
   LET g_success = 'Y'
   #若須拋轉總帳, 檢查分錄底稿平衡正確否
   IF g_oga.oga07 = 'Y' THEN
      CALL s_chknpq(g_oga.oga01,'AR',1,'0',g_bookno1)  
   END IF
#FUN-BB0167 add begin----------------------------
   IF g_prog <> 'aws_ttsrv2' THEN
      IF g_oga.oga65='Y' AND g_success = 'Y' THEN
         CALL t650sub_on_check(g_oga.*)
              RETURNING g_oga.*  #有部分的l_oga有異動,此處必須回傳
         IF g_success = 'N' THEN
            ROLLBACK WORK
            RETURN
         END IF
      END IF
   END IF
#FUN-BB0167 add end------------------------------
   CALL t650sub_y1()
   IF g_success = 'Y' THEN
      IF g_prog <> 'aws_ttsrv2' THEN
          COMMIT WORK
      END IF
      CALL cl_flow_notify(g_oga.oga01,'Y')
      IF g_oga.oga09 ='1' OR g_oga.oga20='N' THEN 
          RETURN 
      END IF
      IF g_oaz.oaz61 MATCHES "[12]" OR g_prog = 'aws_ttsrv2' THEN 
          IF g_prog = 'aws_ttsrv2' THEN
              CALL t650sub_s('1',g_oga.oga01) 
          ELSE
              CALL t650sub_s(g_oaz.oaz61,g_oga.oga01) 
          END IF
      END IF
   ELSE
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
   END IF
END FUNCTION

FUNCTION t650sub_y1()
   DEFINE l_slip   LIKE oay_file.oayslip
   DEFINE l_oay13  LIKE oay_file.oay13
   DEFINE l_oay14  LIKE oay_file.oay14
   DEFINE l_ogb14t LIKE ogb_file.ogb14t
   DEFINE l_rvbs06 LIKE rvbs_file.rvbs06   
   DEFINE l_flag        LIKE type_file.num5   #FUN-B80178
   DEFINE l_ogc         RECORD LIKE ogc_file.*       #FUN-BA0019
   DEFINE l_sql         STRING                       #FUN-BA0019
   DEFINE l_img09       LIKE img_file.img09 #CHI-C30064 add
   DEFINE l_ogb05_fac   LIKE ogb_file.ogb05_fac #CHI-C30064 add
   
   UPDATE oga_file SET ogaconf = 'Y' WHERE oga01 = g_oga.oga01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd ogaconf",1)  
      LET g_errno = SQLCA.sqlcode
      LET g_success = 'N' 
      RETURN
   END IF
   LET l_slip = s_get_doc_no(g_oga.oga01)     
   SELECT oay13,oay14 INTO l_oay13,l_oay14 FROM oay_file WHERE oayslip = l_slip
   IF l_oay13 = 'Y' THEN
      SELECT SUM(ogb14t) INTO l_ogb14t FROM ogb_file WHERE ogb01 = g_oga.oga01
      IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
      LET l_ogb14t = l_ogb14t * g_oga.oga24
      IF l_ogb14t > l_oay14 THEN
         CALL cl_err(l_oay14,'axm-700',1) 
         LET g_errno = 'axm-700'
         LET g_success='N' 
         RETURN
      END IF
   END IF
   CALL t650sub_hu1() IF g_success = 'N' THEN RETURN END IF	#信用查核
   CALL t650sub_hu2() IF g_success = 'N' THEN RETURN END IF	#最近交易
   DECLARE t650sub_y1_c CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01
   FOREACH t650sub_y1_c INTO b_ogb.*
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = b_ogb.ogb04
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = b_ogb.ogb01
            AND rvbs02 = b_ogb.ogb03
            AND rvbs09 = -1
            
         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF
        #CHI-C30064---Start---add
         SELECT img09 INTO l_img09 FROM img_file
          WHERE img01= b_ogb.ogb04 AND img02= b_ogb.ogb09
            AND img03= b_ogb.ogb091 AND img04= b_ogb.ogb092
         CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogb05_fac
         IF g_cnt = '1' THEN
            LET  l_ogb05_fac = 1
         END IF          
        #CHI-C30064---End---add
       #IF (b_ogb.ogb12 * b_ogb.ogb05_fac) <> l_rvbs06 THEN
        IF (b_ogb.ogb12 * l_ogb05_fac) <> l_rvbs06 THEN #CHI-C30064
            LET g_success = "N"
            CALL cl_err(b_ogb.ogb04,"aim-011",1)
            LET g_errno = 'aim-011'
            CONTINUE FOREACH
         END IF
      END IF
 
      IF b_ogb.ogb04[1,4] != 'MISC' THEN   #No.+182 add
         IF g_sma.sma115 = 'Y' THEN
            CALL t650sub_chk_imgg()
            IF g_success='N' THEN RETURN END IF
         ELSE
            CALL t650sub_chk_img()
            IF g_success='N' THEN RETURN END IF
         END IF
         IF b_ogb.ogb17='N' THEN     ##不為多倉儲出貨
         CALL t650sub_chk_ogb15_fac() IF g_success='N' THEN RETURN END IF  
         END IF 
      END IF
      #FUN-B80178 --START--
      IF s_industry('icd') THEN         
         #FUN-B40081 --START--
         LET l_sql= " SELECT * FROM ogc_file WHERE ogc01='",g_oga.oga01,"' AND ogc03=?"  
         PREPARE t650_icdchk_pre1 FROM l_sql
         DECLARE t650_icdchk_cs1 CURSOR FOR t650_icdchk_pre1 
         #FUN-B40081 --END--
         IF s_icdbin(b_ogb.ogb04) THEN   #FUN-BA0051
            #FUN-BA0019 --START--
             IF b_ogb.ogb17='Y' THEN   #多倉儲出貨應以多倉儲裡的資料確認
                FOREACH t650_icdchk_cs1 USING b_ogb.ogb03 INTO l_ogc.* 
                   IF STATUS THEN
                      CALL cl_err('t650_icdchk_cs1:',STATUS,0)
                      LET g_success = 'N'
                      RETURN
                   END IF             
                   CALL s_icdchk(-1,l_ogc.ogc17,
                                     l_ogc.ogc09,
                                     l_ogc.ogc091,
                                     l_ogc.ogc092,
                                     l_ogc.ogc12,
                                     g_oga.oga01,l_ogc.ogc03,
                                     g_oga.oga02,g_plant)               
                           RETURNING l_flag                    
                   IF l_flag = 0 THEN
                      CALL cl_err(b_ogb.ogb03,'aic-056',1) 
                      LET g_success = 'N'
                      RETURN
                   END IF
                END FOREACH    
             ELSE 
             #FUN-BA0019 --END--
             CALL s_icdchk(-1,b_ogb.ogb04,
                                   b_ogb.ogb09,
                                   b_ogb.ogb091,
                                   b_ogb.ogb092,
                                   b_ogb.ogb12,
                                   g_oga.oga01,b_ogb.ogb03,
                                   g_oga.oga02,g_plant) 
                      RETURNING l_flag
             IF l_flag = 0 THEN
                CALL cl_err(b_ogb.ogb03,'aic-056',1)
                LET g_success = 'N'
                RETURN
             END IF                        
             END IF    #FUN-BA0019               
          END IF 
      END IF 
      #FUN-B80178 --END--   
   END FOREACH
END FUNCTION

FUNCTION t650sub_hu1()		#客戶信用查核
#DEFINE l_oia07   LIKE oia_file.oia07    #FUN-C50136
   MESSAGE "hu1!"
   IF g_oga.oga903= 'Y' THEN RETURN END IF    #該單據信用已放行 No.B325 ADD
#  #FUN-C50136----add----str--
#  IF g_oaz.oaz96 = 'Y' THEN
#     CALL s_ccc_oia07('E',g_oga.oga03) RETURNING l_oia07
#     IF l_oia07 = 0 THEN 
#        IF g_action_choice !='confirm' THEN 
#            RETURN
#        END IF 
#     END IF
#     IF l_oia07 = 1 THEN
#        IF g_action_choice !='deduct_inventory' THEN 
#            RETURN
#        END IF
#     END IF
#  END IF
#  #FUN-C50136----add----end--
   IF g_oaz.oaz142 MATCHES "[12]" THEN
#     IF g_oaz.oaz96 = 'Y' THEN                                #FUN-C50136
#        CALL s_ccc_oia(g_oga.oga03,'E',g_oga.oga01,0,'')      #FUN-C50136
#     ELSE                                                     #FUN-C50136
         CALL s_ccc(g_oga.oga03,'1',g_oga.oga01)	# Customer Credit Check 客戶信用查核  #No.MOD-8A0126 add
#     END IF                                                   #FUN-C50136
      IF g_errno = 'N' THEN
        IF g_oaz.oaz142 = "1" THEN
            CALL cl_err('ccc','axm-104',1)
            IF g_prog <> 'aws_ttsrv2' THEN
                IF NOT cl_confirm('axm-105') THEN 
                    LET g_success = 'N' 
                    RETURN
                END IF
            END IF
        ELSE 
            CALL cl_err('ccc','axm-106',0)
            LET g_errno = 'axm-106'
            LET g_success = 'N' 
            RETURN
        END IF
      ELSE
        LET g_errno = NULL
      END IF
   END IF
END FUNCTION
 
FUNCTION t650sub_hu2()		#最近交易日
   DEFINE l_occ RECORD LIKE occ_file.*

   MESSAGE "hu2!"
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oga.oga03
   IF STATUS THEN 
       CALL cl_err('s ccc',STATUS,1) 
       LET g_errno = STATUS
       LET g_success='N' 
       RETURN 
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=g_oga.oga02 END IF
   IF l_occ.occ173 IS NULL OR l_occ.occ173 < g_oga.oga02 THEN
      LET l_occ.occ173=g_oga.oga02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=g_oga.oga03
   IF STATUS THEN CALL cl_err('u ccc',STATUS,1) 
       LET g_errno = STATUS
       LET g_success='N' 
       RETURN 
   END IF
END FUNCTION
 
FUNCTION t650sub_chk_img()
 DEFINE l_ogc  RECORD LIKE ogc_file.*,
        l_img18       LIKE img_file.img18, 
        l_oga02       LIKE oga_file.oga02  

    IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN
        RETURN
    END IF
   LET l_oga02 = NULL
   SELECT oga02 INTO l_oga02 FROM oga_file
     WHERE oga01 = b_ogb.ogb01

   LET g_cnt=0
   IF b_ogb.ogb17='Y' THEN   #多倉儲
      DECLARE chk_ogc CURSOR FOR
         SELECT *
           FROM ogc_file
          WHERE ogc01 = b_ogb.ogb01
            AND ogc03 = b_ogb.ogb03
      FOREACH chk_ogc INTO l_ogc.*
         IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM img_file
             WHERE img01=b_ogb.ogb04 AND img02=l_ogc.ogc09
               AND img03 = l_ogc.ogc091
               AND img04 = l_ogc.ogc092
         IF g_cnt=0 THEN
            CALL cl_err(b_ogb.ogb04,'axm-244',0)       #CHI-A10002 add
            LET g_errno = 'axm-244'
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_img18 = NULL
         SELECT img18 INTO l_img18 FROM img_file
             WHERE img01=b_ogb.ogb04 AND img02=l_ogc.ogc09
               AND img03 = l_ogc.ogc091
               AND img04 = l_ogc.ogc092
         IF l_img18 < l_oga02 THEN
            CALL cl_err(b_ogb.ogb04,'aim-400',1) 
            LET g_errno = 'aim-400'
            LET g_success = 'N'
            EXIT FOREACH
         END IF 
      END FOREACH
   ELSE
      SELECT COUNT(*) INTO g_cnt FROM img_file
          WHERE img01=b_ogb.ogb04 AND img02=b_ogb.ogb09
            AND img03 = b_ogb.ogb091
            AND img04 = b_ogb.ogb092
      IF g_cnt=0 THEN
         CALL cl_err(b_ogb.ogb04,'axm-244',0) 
         LET g_errno = 'axm-244'
         LET g_success = 'N' 
         RETURN    
      END IF
      LET l_img18 = NULL
      SELECT img18 INTO l_img18 FROM img_file
          WHERE img01=b_ogb.ogb04 AND img02=b_ogb.ogb09
            AND img03 = b_ogb.ogb091
            AND img04 = b_ogb.ogb092
      IF l_img18 < l_oga02 THEN
         CALL cl_err(b_ogb.ogb04,'aim-400',1) 
         LET g_errno = 'aim-400'
         LET g_success = 'N'
         RETURN
      END IF 
   END IF
END FUNCTION
 
FUNCTION t650sub_chk_imgg()
 DEFINE l_ogg     RECORD LIKE ogg_file.*
 DEFINE l_ima906  LIKE ima_file.ima906

   LET g_cnt=0
   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=b_ogb.ogb04
   IF b_ogb.ogb17='Y' THEN   #多倉儲
      DECLARE chk_ogg CURSOR FOR
         SELECT *
           FROM ogg_file
          WHERE ogg01 = b_ogb.ogb01
            AND ogg03 = b_ogb.ogb03
      FOREACH chk_ogg INTO l_ogg.*
         IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
         LET g_cnt=0
         IF l_ima906 = '1' THEN
            SELECT COUNT(*) INTO g_cnt FROM img_file
             WHERE img01=b_ogb.ogb04 AND img02=l_ogg.ogg09
               AND img03 = l_ogg.ogg091
               AND img04 = l_ogg.ogg092
            IF g_cnt=0 THEN
               CALL cl_err(b_ogb.ogb04,'axm-244',0)   
               LET g_errno = 'axm-244'
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
         IF l_ima906 = '2' THEN
            SELECT COUNT(*) INTO g_cnt FROM imgg_file
             WHERE imgg01=b_ogb.ogb04   AND imgg02=l_ogg.ogg09
               AND imgg03=l_ogg.ogg091  AND imgg04=l_ogg.ogg092
               AND imgg09=l_ogg.ogg10
            IF g_cnt=0 THEN
               CALL cl_err(b_ogb.ogb04,'axm-244',0)    
               LET g_errno = 'axm-244'
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
         IF l_ima906 = '3' THEN
            IF l_ogg.ogg20 = '1' THEN
               SELECT COUNT(*) INTO g_cnt FROM img_file
                WHERE img01=b_ogb.ogb04 AND img02=l_ogg.ogg09
                  AND img03 = l_ogg.ogg091
                  AND img04 = l_ogg.ogg092
               IF g_cnt=0 THEN
                  CALL cl_err(b_ogb.ogb04,'axm-244',0)    
                  LET g_errno = 'axm-244'
                  LET g_success = 'N'
                 EXIT FOREACH
               END IF
            END IF
            IF l_ogg.ogg20 = '2' THEN
               SELECT COUNT(*) INTO g_cnt FROM imgg_file
                WHERE imgg01=b_ogb.ogb04   AND imgg02=l_ogg.ogg09
                  AND imgg03=l_ogg.ogg091  AND imgg04=l_ogg.ogg092
                  AND imgg09=l_ogg.ogg10
               IF g_cnt=0 THEN
                  CALL cl_err(b_ogb.ogb04,'axm-244',0)   
                  LET g_errno = 'axm-244'
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
            END IF
         END IF
      END FOREACH
   ELSE
      IF l_ima906 = '1' THEN
         SELECT COUNT(*) INTO g_cnt FROM img_file
          WHERE img01=b_ogb.ogb04 AND img02=b_ogb.ogb09
            AND img03 = b_ogb.ogb091
            AND img04 = b_ogb.ogb092
         IF g_cnt=0 THEN
            CALL cl_err(b_ogb.ogb04,'axm-244',0) 
            LET g_errno = 'axm-244'
            LET g_success = 'N' 
            RETURN   
         END IF
      END IF
      IF l_ima906 = '2' THEN
         IF NOT cl_null(b_ogb.ogb910) THEN
            SELECT COUNT(*) INTO g_cnt FROM imgg_file
             WHERE imgg01 = b_ogb.ogb04  AND imgg02 = b_ogb.ogb09
               AND imgg03 = b_ogb.ogb091 AND imgg04 = b_ogb.ogb092
               AND imgg09 = b_ogb.ogb910
            IF g_cnt=0 THEN
               CALL cl_err(b_ogb.ogb04,'axm-244',0) 
               LET g_errno = 'axm-244'
               LET g_success = 'N' 
               RETURN  
            END IF
         END IF
         IF NOT cl_null(b_ogb.ogb913) THEN
            SELECT COUNT(*) INTO g_cnt FROM imgg_file
             WHERE imgg01 = b_ogb.ogb04  AND imgg02 = b_ogb.ogb09
               AND imgg03 = b_ogb.ogb091 AND imgg04 = b_ogb.ogb092
               AND imgg09 = b_ogb.ogb913
            IF g_cnt=0 THEN
               CALL cl_err(b_ogb.ogb04,'axm-244',0) 
               LET g_errno = 'axm-244'
               LET g_success = 'N' 
               RETURN     
            END IF
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION t650sub_s(p_cmd,p_oga01) 			# when g_oga.ogapost='N' (Turn to 'Y')
   DEFINE p_oga01         LIKE oga_file.oga01
   DEFINE p_cmd         LIKE type_file.chr1  		# 1.不詢問 2.要詢問  
   DEFINE b_ogb         RECORD LIKE ogb_file.*  
   DEFINE l_oga02       LIKE oga_file.oga02     #No.FUN-950062
   DEFINE l_yy,l_mm     LIKE type_file.num5     #No.FUN-950062
   DEFINE p_Input_oga02 LIKE type_file.num5     #No.FUN-950062
   DEFINE l_ogb31       LIKE ogb_file.ogb31     #No.FUN-950062
   DEFINE l_oea02       LIKE oea_file.oea02     #No.FUN-950062
   DEFINE l_flag        LIKE type_file.chr1     #No.FUN-950062
   DEFINE l_ogb         RECORD LIKE ogb_file.*  #No.TQC-C50206
   DEFINE lj_result     LIKE type_file.chr1     #No.TQC-C50206
   LET g_oga.oga01 = p_oga01
   CALL t650sub_lock_cl()
 
   IF g_prog <> 'aws_ttsrv2' THEN
       BEGIN WORK
   END IF
 
   LET p_Input_oga02=TRUE      #No.FUN-950062
   IF p_cmd = '1' THEN LET p_Input_oga02=FALSE END IF     #2021112601 add

   OPEN t650sub_cl USING g_oga.oga01
   IF STATUS THEN
      CALL cl_err("OPEN t650sub_cl:", STATUS, 1)
      LET g_errno = STATUS
      LET g_success = 'N'
      LET p_Input_oga02=FALSE      #No.FUN-950062
      CLOSE t650sub_cl
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
      RETURN
   END IF
 
   FETCH t650sub_cl INTO g_oga.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oga.oga01,SQLCA.sqlcode,0)
      LET g_errno = SQLCA.sqlcode
      LET g_success = 'N'
      LET p_Input_oga02=FALSE      #No.FUN-950062
      CLOSE t650sub_cl
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
      RETURN
   END IF

   IF s_shut(0) THEN 
       LET g_errno = '9037' #對不起, 系統目前除了查詢和列印外, 其他功能不可使用, 詳洽系統管理者!
       LET g_success = 'N'
       LET p_Input_oga02=FALSE      #No.FUN-950062
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK 
       END IF
       RETURN 
   END IF 
 
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = g_oga.oga01
   IF g_oga.oga01 IS NULL THEN 
       CALL cl_err('',-400,0) 
       LET g_errno = '-400'
       LET g_success = 'N'
       LET p_Input_oga02=FALSE      #No.FUN-950062
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK 
       END IF
       RETURN 
   END IF 
 
   IF g_oga.ogaconf='X' THEN 
       CALL cl_err('conf=X',9024,0) 
       LET g_errno = '9024'
       LET g_success = 'N'
       LET p_Input_oga02=FALSE      #No.FUN-950062
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK 
       END IF
       RETURN 
   END IF 
 
   IF g_oga.ogaconf='N' THEN 
       CALL cl_err('conf=N','axm-154',0)
       LET g_errno = 'axm-154'
       LET g_success = 'N'
       LET p_Input_oga02=FALSE      #No.FUN-950062
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK 
       END IF
       RETURN 
   END IF 
 
   IF g_oga.ogapost='Y' THEN 
       CALL cl_err('ogapost=Y','arm-800',0)
       LET g_errno = 'arm-800' #此資料已扣帳!
       LET g_success = 'N'
       LET p_Input_oga02=FALSE      #No.FUN-950062
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK 
       END IF
       RETURN 
   END IF 
 
   IF g_oaz.oaz03 = 'Y' AND
      g_sma.sma53 IS NOT NULL AND g_oga.oga02 <= g_sma.sma53 THEN
       CALL cl_err('','mfg9999',0)
       LET g_errno = 'mfg9999'
       LET g_success = 'N'
       LET p_Input_oga02=FALSE      #No.FUN-950062
       IF g_prog <> 'aws_ttsrv2' THEN
           ROLLBACK WORK 
       END IF
       RETURN 
   END IF
###倉管員審核###
 #TQC-C50206 -- add -- begin
   DECLARE ogb_s_c CURSOR FOR
      SELECT * FROM ogb_file WHERE ogb01 = g_oga.oga01
   CALL s_showmsg_init()

   FOREACH ogb_s_c INTO l_ogb.*
      IF cl_null(g_oga.oga99) THEN
         CALL s_incchk(l_ogb.ogb09,l_ogb.ogb091,g_user)
               RETURNING lj_result
         IF NOT lj_result THEN
            LET g_success = 'N'
            LET g_showmsg = l_ogb.ogb03,"/",l_ogb.ogb09,"/",l_ogb.ogb091,"/",g_user
            CALL s_errmsg('ogb03,ogb09,ogb091,inc03',g_showmsg,'','asf-888',1)
         END IF
       END IF
   END FOREACH
   IF g_success = 'N' THEN
      CALL s_showmsg()
      ROLLBACK WORK
      RETURN
   END IF
 #TQC-C50206 -- add -- end 
   IF p_cmd='2' THEN
      IF NOT cl_confirm('axm-152') THEN
         LET p_Input_oga02=FALSE      #No.FUN-950062
         ROLLBACK WORK 
         RETURN
      END IF
   END IF
 
   #start FUN-950062 add
   LET l_flag = '0'
   IF p_Input_oga02 THEN
      INPUT l_oga02 WITHOUT DEFAULTS FROM oga02

         BEFORE INPUT
            LET l_flag = '1'
            LET l_oga02 = g_oga.oga02
            DISPLAY l_oga02 TO oga02

         AFTER FIELD oga02
            IF NOT cl_null(l_oga02) THEN
               IF l_oga02 < g_oga.oga69 THEN
                  LET l_oga02=g_oga.oga02
                  CALL cl_err('','axm-924',1)   #出貨日期不可小於輸入日期!!!
                  DISPLAY l_oga02 TO oga02
                  NEXT FIELD oga02
               END IF
               IF l_oga02 <= g_oaz.oaz09 THEN
                  CALL cl_err('','axm-164',0) NEXT FIELD oga02
               END IF

               DECLARE t650_oga02 CURSOR FOR
                  SELECT ogb31
                    FROM ogb_file
                   WHERE  ogb01=g_oga.oga01
               FOREACH t650_oga02 INTO l_ogb31
                  IF NOT cl_null(l_ogb31) THEN
                     SELECT oea02 INTO l_oea02 FROM oea_file
                      WHERE oea01=l_ogb31
                     IF l_oga02 < l_oea02 THEN
                        CALL cl_err('','axm-385',0)
                        NEXT FIELD oga02
                     END IF
                  END IF
               END FOREACH
               IF g_oaz.oaz03 = 'Y' AND
                  g_sma.sma53 IS NOT NULL AND l_oga02 <= g_sma.sma53 THEN
                  CALL cl_err('','mfg9999',0) NEXT FIELD oga02
               END IF
               CALL s_yp(l_oga02) RETURNING l_yy,l_mm
               IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                  CALL cl_err('','mfg6090',0)
                  NEXT FIELD oga02
               END IF
            END IF

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         LET g_success='N'
         LET g_totsuccess='N'
         CLOSE t650sub_cl
         ROLLBACK WORK
         RETURN
      END IF
   ELSE
      IF g_oga.oga02 IS NULL OR g_oga.oga02=0 THEN
         LET g_oga.oga02=g_today
      END IF
      LET l_oga02 = g_oga.oga02
   END IF

   IF l_flag = '1' THEN
      LET g_oga.oga02=l_oga02
   END IF

   UPDATE oga_file SET oga02=g_oga.oga02 WHERE oga01=g_oga.oga01
  #end FUN-950062 add

   LET g_success = 'Y'
   UPDATE oga_file SET ogapost='Y' WHERE oga01=g_oga.oga01
 
   CALL t650sub_s1()
   IF NOT cl_null(g_errno) THEN
       LET g_success = 'N'
      #RETURN    #TQC-BB0096 mark
   END IF

#  #FUN-C50136----add----str----
#  IF g_oaz.oaz96 = 'Y' THEN 
#     CALL t650sub_hu1()                            
#     IF g_success = 'N' THEN 
#        ROLLBACK WORK
#     END IF
#  END IF 
#  #FUN-C50136----add----end----
 
   IF g_success = 'Y' THEN
      LET g_oga.ogapost='Y'
      IF g_prog <> 'aws_ttsrv2' THEN
          COMMIT WORK
          CALL cl_flow_notify(g_oga.oga01,'S')
      END IF
   ELSE
      LET g_oga.ogapost='N'
      IF g_prog <> 'aws_ttsrv2' THEN
          ROLLBACK WORK
      END IF
   END IF
 
   IF g_success = 'Y' AND g_oaz.oaz62='Y' AND g_oga.oga08='1' THEN
       CALL t650sub_gui()
   END IF
   
   IF g_oga.ogapost = "N" THEN
      DECLARE t650sub_s1_c2 CURSOR FOR SELECT * FROM ogb_file
        WHERE ogb01 = g_oga.oga01
   
      LET g_imm01 = ""
      LET g_success = "Y"
      CALL s_showmsg_init()   
   
      BEGIN WORK
   
      FOREACH t650sub_s1_c2 INTO b_ogb.*
         IF STATUS THEN
            LET g_success = 'N'                
            EXIT FOREACH
         END IF
   
         IF g_sma.sma115 = 'Y' THEN
            IF g_ima906 = '2' THEN  #子母單位
               LET g_unit_arr[1].unit= b_ogb.ogb910
               LET g_unit_arr[1].fac = b_ogb.ogb911
               LET g_unit_arr[1].qty = b_ogb.ogb912
               LET g_unit_arr[2].unit= b_ogb.ogb913
               LET g_unit_arr[2].fac = b_ogb.ogb914
               LET g_unit_arr[2].qty = b_ogb.ogb915
               CALL s_dismantle(g_oga.oga01,b_ogb.ogb03,g_oga.oga02,
                                b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
                                b_ogb.ogb092,g_unit_arr,g_imm01)
                      RETURNING g_imm01
                  IF g_success='N' THEN 
                     LET g_totsuccess='N'
                     LET g_success="Y"
                     CONTINUE FOREACH  
                  END IF
            END IF
         END IF
      END FOREACH
   
      IF g_totsuccess="N" THEN   
         LET g_success="N"
      END IF
      CALL s_showmsg() 
   
      IF g_success = "Y" AND NOT cl_null(g_imm01) THEN
         COMMIT WORK
         LET g_msg="aimt324 '",g_imm01,"'"
         CALL cl_cmdrun_wait(g_msg)
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   MESSAGE ''
 
END FUNCTION
 
FUNCTION t650sub_gui()
   IF g_oga.ogapost='N' THEN CALL cl_err('post=N','axm-206',0) RETURN END IF
   IF g_prog = 'aws_ttsrv2' THEN
       COMMIT WORK
       LET g_msg="axrp310 ",
                 " '",g_oga.oga01,"'",
                 " '",g_oga.oga02,"'",
                 " '",g_oga.oga05,"' '",g_oga.oga212,"'",
                 " '' '' '' '' '' '' 'Y' '' 'N'" # 第13個參數接axrp310的 l_open_axrp310a = ARG_VAL(13)=>是否開出axrp310a的畫面
   ELSE
       LET g_msg="axrp310 ",
                 " '",g_oga.oga01,"'",
                 " '",g_oga.oga02,"'",
                 " '",g_oga.oga05,"' '",g_oga.oga212,"'"
   END IF
   CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
 
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_oga.oga01
 
END FUNCTION
 
FUNCTION t650sub_s1()
  DEFINE l_ogc    RECORD LIKE ogc_file.*
  DEFINE l_flag   LIKE type_file.chr1    
  DEFINE l_ima25  LIKE ima_file.ima25
  DEFINE l_ima71  LIKE ima_file.ima71
  DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
  DEFINE l_cnt    LIKE type_file.num5   
  DEFINE l_occ31  LIKE occ_file.occ31
 #DEFINE l_adq06  LIKE adq_file.adq06   #MOD-CB0111 mark
 #DEFINE l_adq07  LIKE adq_file.adq07   #MOD-CB0111 mark
  DEFINE l_tuq06  LIKE tuq_file.tuq06   #MOD-CB0111 add
  DEFINE l_tuq07  LIKE tuq_file.tuq07   #MOD-CB0111 add
  DEFINE l_desc   LIKE type_file.chr1  
  DEFINE i        LIKE type_file.num5 
  DEFINE l_ima906 LIKE ima_file.ima96
  DEFINE l_ogg    RECORD LIKE ogg_file.*
 #DEFINE l_adp06  LIKE adp_file.adp06 #MOD-B30651 add   #MOD-CB0111 mark
  DEFINE l_tup06  LIKE tup_file.tup06   #MOD-CB0111 add
  DEFINE l_ogbi RECORD LIKE ogbi_file.*   #FUN-B80178
  DEFINE l_sql  STRING   #FUN-BA0019
 #DEFINE l_adq09  LIKE adq_file.adq09   #No.FUN-BB0086   #MOD-CB0111 mark
  DEFINE l_tuq09  LIKE tuq_file.tuq09   #MOD-CB0111 add
#FUN-BB0167 add start-----------------
  DEFINE l_img09       LIKE img_file.img09
  DEFINE l_oha         RECORD LIKE oha_file.*
  DEFINE l_idb         RECORD LIKE idb_file.*
#FUN-BB0167 add end-------------------
  DEFINE l_msg     STRING  #FUN-C50097
  DEFINE l_cnt2         LIKE type_file.num5  #MOD-CB0050
  DEFINE l_tuq11       LIKE tuq_file.tuq11   #MOD-CB0111 add
  DEFINE l_tup11       LIKE tup_file.tup11   #MOD-CB0111 add 
  
  CALL s_showmsg_init() 
  
  DECLARE t650sub_s1_c CURSOR FOR
   SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01
 
  #FUN-BA0019 --START--
  LET l_sql= " SELECT * FROM ogc_file WHERE ogc01='",g_oga.oga01,"' AND ogc03=?" 
  PREPARE t650_icdpost_pre1 FROM l_sql
  DECLARE t650_icdpost_cs1 CURSOR FOR t650_icdpost_pre1 
  #FUN-BA0019 --END-- 
 
  FOREACH t650sub_s1_c INTO b_ogb.*
      IF STATUS THEN EXIT FOREACH END IF
      MESSAGE '_s1() read no:',b_ogb.ogb03 USING '#####&','--> parts: ',
               b_ogb.ogb04
 
      IF cl_null(b_ogb.ogb04) THEN CONTINUE FOREACH END IF
      IF g_oaz.oaz03 = 'N' THEN CONTINUE FOREACH END IF
      IF b_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF
      
      
      IF b_ogb.ogb17='Y' THEN     ##多倉儲出貨
          SELECT SUM(ogc12) INTO tot1 FROM ogc_file WHERE ogc01=g_oga.oga01   
                                                     AND ogc03=b_ogb.ogb03
          IF tot1 != b_ogb.ogb12  OR  cl_null(tot1) THEN 
                        		#多倉儲合計數量與產品項次不符
            LET g_showmsg = g_oga.oga01,"/",b_ogb.ogb03
            CALL s_errmsg('ogc01,ogc03',g_showmsg,'ogc12!=ogb12:','axm-172',1)
            LET g_errno = 'axm-172'
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
         LET l_flag='' 
         DECLARE t650sub_s1_ogc_c CURSOR FOR  SELECT * FROM ogc_file
           WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
         FOREACH t650sub_s1_ogc_c INTO l_ogc.*
            IF SQLCA.SQLCODE THEN
               LET g_showmsg =g_oga.oga01,"/",b_ogb.ogb03
               CALL s_errmsg('ogc01,ogc03',g_showmsg,'Foreach s1_ogc:',SQLCA.SQLCODE,1)
               LET g_errno = SQLCA.SQLCODE
               LET g_success='N' 
               EXIT FOREACH
            END IF
            MESSAGE '_s1() read ogc02:',b_ogb.ogb03,'-',l_ogc.ogc091
            CALL t650sub_update(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                            l_ogc.ogc12,b_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag) 
            LET l_flag='Y' 
            IF g_success='N' THEN 
               IF g_prog = 'aws_ttsrv2' THEN
                   RETURN
               END IF
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH   
            END IF
         END FOREACH
#FUN-C50097 ADD BEG--------- TQC-C70206
         IF g_success = 'Y' THEN 
            #當爲大陸版,且立賬走開票流程,且不做發出商品管理
            IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN 
               IF cl_null(g_oaz.oaz95) THEN 
                  CALL cl_err('axms100/oaz95','axm-956',1)  #須修改
                  LET g_success = 'N'
                  RETURN l_oha.* 
               ELSE 
#MOD-CB0050 add begin-------------------------------
                  CALL t650sub_chk_ogb1001(b_ogb.ogb1001) RETURNING l_cnt2 
                  IF l_cnt2 > 0 THEN 
                     #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                     #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                  ELSE 
#MOD-CB0050 add end--------------------------------- 
                     IF g_prog[1,7] = 'axmt650' AND g_oga.oga65='N' THEN 
                      #當走直接出貨時,  
                     #更新發票倉庫存和產生tlf檔案
                       # CALL t650sub_consign(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092,   
                       #                      b_ogb.ogb12,b_ogb.ogb05,b_ogb.ogb15_fac,b_ogb.ogb16,'',b_ogb.ogb04,g_oga.*,b_ogb.*)                                           
   #将多仓储批的存储批号更新到发票仓
                        DECLARE t650_sub_ogc_c42 CURSOR FOR          
                         SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file 
                           WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03  
                         GROUP BY ogc17,ogc092                                             
                        FOREACH t650_sub_ogc_c42 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  
                           IF SQLCA.SQLCODE THEN
                              CALL s_errmsg('','',"Foreach t650_sub_ogc_c42:",SQLCA.sqlcode,1)
                              LET g_success='N' RETURN 
                           END IF
                           LET l_msg='_s1() read ogc02:',b_ogb.ogb03,'-',l_ogc.ogc091
                           CALL cl_msg(l_msg)
                           LET l_flag='X'                
                           SELECT img09 INTO l_img09 FROM img_file
                            WHERE img01= b_ogb.ogb04  AND img02= g_oaz.oaz95            
                              AND img03= g_oga.oga03  AND img04= l_ogc.ogc092             
                           #FUN-C50097 ADD BEG
                           IF cl_null(l_img09) THEN 
                              SELECT DISTINCT img09 INTO l_img09 FROM img_file
                               WHERE img01= b_ogb.ogb04  AND img04= l_ogc.ogc092                               
                           END IF             
                           #FUN-C50097 ADD END  
                           CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
                           LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
                           LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15) 
                           CALL t650sub_consign(g_oaz.oaz95,g_oga.oga03,l_ogc.ogc092,l_ogc.ogc12,b_ogb.ogb05,l_ogc.ogc15_fac,
                           l_ogc.ogc16,l_flag,l_ogc.ogc17,g_oga.*,b_ogb.*) 
                           IF g_success='N' THEN 
                              LET g_totsuccess="N"
                              LET g_success="Y"
                              CONTINUE FOREACH
                           END IF
                        END FOREACH    
     #FUN-C50097 ADD 120726                          
                        IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                           CALL t650sub_consign_mu(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092,g_oga.*,b_ogb.*) 
                        END IF                     
                        IF g_success='N' THEN 
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                     END IF 
                  END IF #MOD-CB0050 add 
               END IF 
            END IF 
         END IF
#FUN-C50097 ADD BEG---------               
      ELSE #以下為非多倉儲出貨
         CALL t650sub_chk_ogb15_fac() 
         IF g_success='N' THEN 
             RETURN 
         END IF   
         CALL t650sub_update(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                          b_ogb.ogb12,b_ogb.ogb05,b_ogb.ogb15_fac,b_ogb.ogb16,'')
         IF g_success = 'N' THEN 
            IF g_prog = 'aws_ttsrv2' THEN
                RETURN
            END IF
            LET g_totsuccess="N"
            LET g_success="Y"
            CONTINUE FOREACH   
         END IF
#FUN-C50097 ADD BEG---------
         IF g_success = 'Y' THEN 
            #當爲大陸版,且立賬走開票流程,且不做發出商品管理
            IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN 
               IF cl_null(g_oaz.oaz95) THEN 
                  CALL cl_err('axms100/oaz95','axm-956',1)  #須修改
                  LET g_success = 'N'
                  RETURN l_oha.* 
               ELSE 
#MOD-CB0050 add begin-------------------------------
                  CALL t650sub_chk_ogb1001(b_ogb.ogb1001) RETURNING l_cnt2 
                  IF l_cnt2 > 0 THEN 
                     #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                     #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                  ELSE 
#MOD-CB0050 add end---------------------------------  
                     IF g_prog[1,7] = 'axmt650' AND g_oga.oga65='N' THEN 
                      #當走直接出貨時,  
                     #更新發票倉庫存和產生tlf檔案
                        CALL t650sub_consign(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092,   
                                             b_ogb.ogb12,b_ogb.ogb05,b_ogb.ogb15_fac,b_ogb.ogb16,'',b_ogb.ogb04,g_oga.*,b_ogb.*)                                           
                        IF g_success='N' THEN 
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                        IF g_sma.sma115 = 'Y' THEN #add 120801
                           CALL t650sub_consign_mu(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092,g_oga.*,b_ogb.*) 
                        END IF 
                     END IF 
                  END IF  #MOD-CB0050 add 
               END IF 
            END IF 
         END IF
#FUN-C50097 ADD BEG---------                            
      END IF
      IF g_sma.sma115 = 'Y' THEN
         SELECT ima906 INTO l_ima906 FROM ima_file
          WHERE ima01=b_ogb.ogb04
         IF b_ogb.ogb17='Y' THEN     ##多倉儲出貨
            DECLARE t650sub_s1_ogg_c CURSOR FOR  SELECT * FROM ogg_file
              WHERE ogg01=g_oga.oga01 AND ogg03=b_ogb.ogb03
              ORDER BY ogg20 DESC
            FOREACH t650sub_s1_ogg_c INTO l_ogg.*
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','','Foreach s1_ogg:',SQLCA.SQLCODE,1)
                  LET g_errno = SQLCA.sqlcode
                  LET g_success='N' 
                  EXIT FOREACH
               END IF
               MESSAGE '_s1() read ogg02:',b_ogb.ogb03,'-',l_ogg.ogg091

               IF l_ima906 = '1' THEN
                  CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')  
               END IF
               IF l_ima906 = '2' THEN
                  IF NOT cl_null(l_ogg.ogg10) THEN
                     CALL t650sub_upd_imgg('1',b_ogb.ogb04,l_ogg.ogg09,
                                        l_ogg.ogg091,l_ogg.ogg092,
                                        l_ogg.ogg10,1,l_ogg.ogg12,-1,'1')
                     IF g_success = 'N' THEN 
                        LET g_totsuccess="N"
                        LET g_success="Y"
                        CONTINUE FOREACH  
                     END IF
                     CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')   #MOD-A20117  
                     IF NOT cl_null(l_ogg.ogg12) AND l_ogg.ogg12 <> 0 THEN
                        CALL t650sub_tlff(l_ogg.ogg20,b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,
                                       l_ogg.ogg092,l_ogg.ogg10,1,l_ogg.ogg12)
                        IF g_success = 'N' THEN 
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH  
                        END IF
                     END IF
                  END IF
               END IF
               IF l_ima906 = '3' THEN
                  IF l_ogg.ogg20 = '2' THEN
                     CALL t650sub_upd_imgg('2',b_ogb.ogb04,l_ogg.ogg09,
                                        l_ogg.ogg091,l_ogg.ogg092,
                                        l_ogg.ogg10,1,l_ogg.ogg12,-1,'2')
                     IF g_success = 'N' THEN RETURN END IF
                     CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')   #MOD-A20117  
                     IF NOT cl_null(l_ogg.ogg12) AND l_ogg.ogg12 <> 0 THEN
                        CALL t650sub_tlff(l_ogg.ogg20,b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,
                                       l_ogg.ogg092,l_ogg.ogg10,1,l_ogg.ogg12)
                        IF g_success = 'N' THEN 
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH   #No.FUN-6C0083
                        END IF
                     END IF
                   END IF
               END IF
               IF g_success='N' THEN RETURN END IF
            END FOREACH
         ELSE
            IF l_ima906 = '2' THEN
               IF NOT cl_null(b_ogb.ogb913) THEN
                  CALL t650sub_upd_imgg('1',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
                                     b_ogb.ogb092,b_ogb.ogb913,b_ogb.ogb914,
                                     b_ogb.ogb915,-1,'2')
                  IF g_success='N' THEN 
                     LET g_totsuccess="N"
                     LET g_success="Y"
                     CONTINUE FOREACH   
                  END IF
                  IF NOT cl_null(b_ogb.ogb915) THEN                                         
                     CALL t650sub_tlff('2',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                                    b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915)
                     IF g_success='N' THEN 
                        LET g_totsuccess="N"
                        LET g_success="Y"
                        CONTINUE FOREACH   
                     END IF
                  END IF
               END IF
               IF NOT cl_null(b_ogb.ogb910) THEN
                  CALL t650sub_upd_imgg('1',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
                                     b_ogb.ogb092,b_ogb.ogb910,b_ogb.ogb911,
                                     b_ogb.ogb912,-1,'1')
                  IF g_success='N' THEN 
                     LET g_totsuccess="N"
                     LET g_success="Y"
                     CONTINUE FOREACH   
                  END IF
                  IF NOT cl_null(b_ogb.ogb912) THEN                                       
                     CALL t650sub_tlff('1',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                                    b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912)
                     IF g_success='N' THEN 
                        LET g_totsuccess="N"
                        LET g_success="Y"
                        CONTINUE FOREACH
                     END IF
                  END IF
               END IF
            END IF
            IF l_ima906 = '3' THEN
               IF NOT cl_null(b_ogb.ogb913) THEN
                  CALL t650sub_upd_imgg('2',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
                                     b_ogb.ogb092,b_ogb.ogb913,b_ogb.ogb914,
                                     b_ogb.ogb915,-1,'2')
                  IF g_success='N' THEN 
                     LET g_totsuccess="N"
                     LET g_success="Y"
                     CONTINUE FOREACH  
                  END IF
                  IF NOT cl_null(b_ogb.ogb915) THEN                                       
                     CALL t650sub_tlff('2',b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                                    b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915)
                     IF g_success='N' THEN 
                        LET g_totsuccess="N"
                        LET g_success="Y"
                        CONTINUE FOREACH   
                     END IF
                  END IF
               END IF
            END IF
         END IF
      END IF
      IF g_success='N' THEN RETURN END IF
      #FUN-BB0167 --START---------------------
      IF g_oga.oga65='Y' THEN
         LET l_flag='' 
         IF b_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
            DECLARE t650_s1_ogc_c3 CURSOR FOR            
            SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file  
             WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
             GROUP BY ogc17,ogc092   
            FOREACH t650_s1_ogc_c3 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092 
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
                  LET g_success='N' 
                  EXIT FOREACH
               END IF 
               LET l_flag='X'
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= b_ogb.ogb04  AND img02= g_oga.oga66
                  AND img03= g_oga.oga67 AND img04= l_ogc.ogc092   
               CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
               LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
               IF s_industry('icd') THEN 
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = b_ogb.ogb01 AND idb08 = b_ogb.ogb03
                  IF l_cnt > 0 THEN
                     DECLARE t650sub_idb_c1 CURSOR FOR
                      SELECT * FROM idb_file
                       WHERE idb07 = b_ogb.ogb01 AND idb08 = b_ogb.ogb03
                         AND idb04 = l_ogc.ogc092  
                     FOREACH t650sub_idb_c1 INTO l_idb.* 
                        #出貨簽收單產生ida資料
                        IF NOT s_icdout_insicin(l_idb.*,g_oga.oga66,g_oga.oga67,l_idb.idb04) THEN   #TQC-BA0136 ogb092 -> l_idb.idb04
                           LET g_success='N'
                        END IF
                        IF g_success='N' THEN  
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                     END FOREACH
                  END IF
                  SELECT ogbiicd028,ogbiicd029 INTO b_ogbi.ogbiicd02,b_ogbi.ogbiicd029
                    FROM ogbi_file WHERE ogbi01 = b_ogb.ogb01 AND ogbi03 = b_ogb.ogb03
                  CALL s_icdpost(1,b_ogb.ogb04,g_oga.oga66,g_oga.oga67,
                       l_ogc.ogc092,b_ogb.ogb05,l_ogc.ogc12,  
                       g_oga.oga01,b_ogb.ogb03,g_oga.oga02,'Y',
                       '','',b_ogbi.ogbiicd029,b_ogbi.ogbiicd028,g_plant)
                       RETURNING l_flag
                  IF l_flag = 0 THEN
                     LET g_success = 'N'                     
                     RETURN l_oha.*
                  END IF
               END IF
            END FOREACH
         ELSE
            IF b_ogb.ogb17='Y' THEN 
               LET l_flag = 'Y'
            ELSE
               LET l_flag=''                
            END IF
            CALL t650sub_consign(g_oga.oga66,g_oga.oga67,b_ogb.ogb092,   
                         b_ogb.ogb12,b_ogb.ogb05,b_ogb.ogb15_fac,b_ogb.ogb16,l_flag,b_ogb.ogb04,g_oga.*,b_ogb.*)  

            IF g_success='N' THEN 
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
            
            IF s_industry('icd') THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idb_file
                WHERE idb07 = b_ogb.ogb01 AND idb08 = b_ogb.ogb03
               IF l_cnt > 0 THEN
                 DECLARE t650sub_idb_c2 CURSOR FOR
                 SELECT * FROM idb_file
                  WHERE idb07 = b_ogb.ogb01 AND idb08 = b_ogb.ogb03
                 FOREACH t650sub_idb_c2 INTO l_idb.* 
                    #出貨簽收單產生ida資料
                    IF NOT s_icdout_insicin(l_idb.*,g_oga.oga66,g_oga.oga67,b_ogb.ogb092) THEN 
                       LET g_success='N'
                    END IF
                    IF g_success='N' THEN  
                       LET g_totsuccess="N"
                       LET g_success="Y"
                       CONTINUE FOREACH
                    END IF
                 END FOREACH
              END IF
               SELECT ogbiicd028,ogbiicd029 INTO b_ogbi.ogbiicd02,b_ogbi.ogbiicd029
                 FROM ogbi_file WHERE ogbi01 = b_ogb.ogb01 AND ogbi03 = b_ogb.ogb03
               CALL s_icdpost(1,b_ogb.ogb04,g_oga.oga66,g_oga.oga67,
                    b_ogb.ogb092,b_ogb.ogb05,b_ogb.ogb12,
                    g_oga.oga01,b_ogb.ogb03,g_oga.oga02,'Y',
                    '','',b_ogbi.ogbiicd029,b_ogbi.ogbiicd028,g_plant)
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'                     
                  RETURN l_oha.*
               END IF
            END IF
         END IF
         IF g_sma.sma115 = 'Y' THEN
            CALL t650sub_consign_mu(g_oga.oga66,g_oga.oga67,b_ogb.ogb092,g_oga.*,b_ogb.*)
            IF g_success = 'N' THEN
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
         END IF
      ELSE
      #FUN-BB0167 add --end----
         #FUN-B80178 --START--
         IF s_industry('icd') THEN
            SELECT * INTO l_ogbi.* FROM ogbi_file 
              WHERE ogbi01 = b_ogb.ogb01 AND ogbi03 = b_ogb.ogb03
            #FUN-B40081 --START--
            IF b_ogb.ogb17='Y' THEN   #多倉儲出貨應以多倉儲裡的資料過帳
               FOREACH t650_icdpost_cs1 USING b_ogb.ogb03 INTO l_ogc.*
                  IF STATUS THEN
                     CALL cl_err('t650_icdpost_cs1:',STATUS,0)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                 
                  LET b_ogb.ogb09 =l_ogc.ogc09   #出貨倉庫編號
                  LET b_ogb.ogb091=l_ogc.ogc091  #出貨儲位編號
                  LET b_ogb.ogb092=l_ogc.ogc092  #出貨批號
                  LET b_ogb.ogb12 =l_ogc.ogc12   #數量
                  CALL s_icdpost(-1,l_ogc.ogc17,l_ogc.ogc09,l_ogc.ogc091,
                                l_ogc.ogc092,l_ogc.ogc15,l_ogc.ogc12,
                                 g_oga.oga01,l_ogc.ogc03,g_oga.oga02,'Y','','' 
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag           
                  IF l_flag = 0 THEN
                     LET g_totsuccess="N"
                     LET g_success="Y"
                     EXIT FOREACH              
                  END IF
               END FOREACH
               IF g_totsuccess = "N" THEN
                  CONTINUE FOREACH
               END IF 
            ELSE
               #FUN-B40081 --END--
               CALL s_icdpost(-1,b_ogb.ogb04,b_ogb.ogb09,b_ogb.ogb091,
                                 b_ogb.ogb092,b_ogb.ogb05,b_ogb.ogb12,
                                 g_oga.oga01,b_ogb.ogb03,g_oga.oga02,'Y','',''
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag  
               IF l_flag = 0 THEN
                  LET g_totsuccess="N"
                  LET g_success="Y"
                  CONTINUE FOREACH
               END IF  
            END IF   #FUN-BA0019   
         END IF 
         #FUN-B80178 --END--      
      END IF #FUN-BB0167
      SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=g_oga.oga03
      IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
      IF l_occ31 = 'N' THEN CONTINUE FOREACH END IF   
      SELECT ima25,ima71 INTO l_ima25,l_ima71
        FROM ima_file WHERE ima01=b_ogb.ogb04
      IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
      #MOD-B30651 add --start--
      IF l_ima71 = 0 THEN 
         LET l_tup06 = g_lastdat               #MOD-CB0111 l_adp06 -> l_tup06
      ELSE 
         LET l_tup06 = g_oga.oga02 + l_ima71   #MOD-CB0111 l_adp06 -> l_tup06
      END IF
      #MOD-B30651 add --end--
     #MOD-CB0111 -- mark start --
     #SELECT COUNT(*) INTO i FROM adq_file
     # WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
     #   AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
     #MOD-CB0111 -- mark end --
     #MOD-CB0111 -- add start --
      #---------------------------------#
      # 更新tuq_file客戶庫存異動明細檔  #
      # 更新tup_file客戶庫存明細檔      #
      #---------------------------------#
      LET l_tuq11 = '1'
      LET l_tup11 = '1'
      #更新tuq_file
      LET i = 0
      SELECT COUNT(*) INTO i FROM tuq_file
       WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04
         AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02
         AND tuq11 = l_tuq11
         AND tuq12 = g_oga.oga04
         AND tuq05 = g_oga.oga01
         AND tuq051= b_ogb.ogb03
     #MOD-CB0111 -- add end --
      IF i=0 THEN
         LET l_fac1=1
         IF b_ogb.ogb05 <> l_ima25 THEN
            CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL s_errmsg('','',b_ogb.ogb04,'abm-731',1)
               LET l_fac1=1
            END IF
         END IF
         #No.FUN-BB0086--add--begin--
        #LET l_adq09 = ""   #MOD-CB0111 mark
         LET l_tuq09 = ""   #MOD-CB0111 add
        #LET l_adq09 = s_digqty(b_ogb.ogb12*l_fac1,l_ima25)   #MOD-CB0111 mark
         LET l_tuq09 = s_digqty(b_ogb.ogb12*l_fac1,l_ima25)   #MOD-CB0111 add 
         LET b_ogb.ogb12 = s_digqty(b_ogb.ogb12,b_ogb.ogb05)
         #No.FUN-BB0086--add--end--  
        #MOD-CB0111 -- mark start --
        #INSERT INTO adq_file(adq01,adq02,adq03,adq04,adq05,
        #                     adq06,adq07,adq08,adq09,adq10)
        #VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,g_oga.oga02,g_oga.oga01,
        #       b_ogb.ogb05,b_ogb.ogb12,l_fac1,l_adq09,'1')   #No.FUN-BB0086 modify
        #MOD-CB0111 -- add start --
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)
         VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,g_oga.oga02,g_oga.oga01,b_ogb.ogb03,
                b_ogb.ogb05,b_ogb.ogb12,l_fac1,l_tuq09,'1',l_tuq11,g_oga.oga04,   #MOD-CB0111 modify b_ogb.ogb12*l_fac1 -> l_tuq09
                g_plant,g_legal)
        #MOD-CB0111 -- add end --
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','insert tuq_file',SQLCA.sqlcode,1)   #MOD-CB0111 adq_file -> tuq_file
            LET g_errno = SQLCA.sqlcode
            LET g_success ='N'
            CONTINUE FOREACH
         END IF
      ELSE
        #MOD-CB0111 -- mark start --
        #SELECT UNIQUE adq06 INTO l_adq06 FROM adq_file
        # WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
        #   AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
        #MOD-CB0111 -- mark end --
        #MOD-CB0111 -- add start --
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
           WHERE tuq01=g_oga.oga03  AND tuq02 = b_ogb.ogb04
             AND tuq03=b_ogb.ogb092 AND tuq04 = g_oga.oga02
             AND tuq11 = l_tuq11
             AND tuq12 = g_oga.oga04
             AND tuq05 = g_oga.oga01
             AND tuq051= b_ogb.ogb03
        #MOD-CB0111 -- add end --
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04   #MOD-CB0111 add ,"/",g_oga.oga04
           #CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'select adq06',SQLCA.sqlcode,1)              #MOD-CB0111 mark
            CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"SEL tuq_file",SQLCA.sqlcode,1)        #MOD-CB0111 add
            LET g_errno = SQLCA.sqlcode
            LET g_success ='N'
            CONTINUE FOREACH
         END IF
         LET l_fac1=1
         IF b_ogb.ogb05 <> l_tuq06 THEN                      #MOD-CB0111 l_adq06 -> l_tuq06   
            CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_tuq06)   #MOD-CB0111 l_adq06 -> l_tuq06
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL s_errmsg('','',b_ogb.ogb04,'abm-731',0)
               LET l_fac1=1
            END IF
         END IF
        #MOD-CB0111 -- mark start --
        #SELECT adq07 INTO l_adq07 FROM adq_file
        # WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
        #   AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
        #MOD-CB0111 -- mark end --
        #MOD-CB0111 -- add start --
        SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04
            AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02
            AND tuq11 = l_tuq11
            AND tuq12 = g_oga.oga04
            AND tuq05 = g_oga.oga01
            AND tuq051= b_ogb.ogb03
        #MOD-CB0111 -- add end --
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF   #MOD-CB0111 l_adq07 -> l_tuq07
         IF l_tuq07+b_ogb.ogb12*l_fac1<0 THEN            #MOD-CB0111 l_adq07 -> l_tuq07 
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07+b_ogb.ogb12*l_fac1=0 THEN            #MOD-CB0111 l_adq07 -> l_tuq07
           #MOD-CB0111 -- mark start --
           #DELETE FROM adq_file
           # WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
           #   AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
           #MOD-CB0111 -- mark end --
           #MOD-CB0111 -- add start --
            DELETE FROM tuq_file
             WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04
               AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02
               AND tuq11 = l_tuq11
               AND tuq12 = g_oga.oga04
               AND tuq05 = g_oga.oga01
               AND tuq051= b_ogb.ogb03
           #MOD-CB0111 -- add end --
            IF SQLCA.sqlcode THEN
               LET g_showmsg = g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04   #MOD-CB0111 add ,"/",g_oga.oga04
              #CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'delete adq_file',SQLCA.sqlcode,1)           #MOD-CB0111 mark
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"DEL tuq_file",SQLCA.sqlcode,1)        #MOD-CB0111 add
               LET g_errno = SQLCA.sqlcode
               LET g_success='N'
               CONTINUE FOREACH
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN                      #MOD-CB0111 l_adq06 -> l_tug06
               CALL s_umfchk(b_ogb.ogb04,l_tuq06,l_ima25)   #MOD-CB0111 l_adq06 -> l_tuq06
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(b_ogb.ogb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
            #No.FUN-BB0086--add--begin--
            LET l_tuq07 = s_digqty(b_ogb.ogb12*l_fac1,l_tuq06)         #MOD-CB0111 modify l_adq07 -> l_tuq07 、 l_adq06 -> l_tuq06 
            LET l_tuq09 = s_digqty(b_ogb.ogb12*l_fac1*l_fac2,l_ima25)  #MOD-CB0111 modify l_adq09 -> l_tuq09 
            #No.FUN-BB0086--add--end--
           #MOD-CB0111 -- mark start --
           #UPDATE adq_file SET adq07=adq07+l_adq07,   #No.FUN-BB0086 modify
           #                    adq09=adq09+l_adq09,   #No.FUN-BB0086 modify
           #                    adq10=l_desc
           # WHERE adq01=g_oga.oga03  AND adq02=b_ogb.ogb04
           #   AND adq03=b_ogb.ogb092 AND adq04=g_oga.oga02
           #MOD-CB0111 -- mark end --
           #MOD-CB0111 -- add start --
            UPDATE tuq_file SET tuq07=tuq07+l_tuq07,   #MOD-CB0111 modify b_ogb.ogb12*l_fac1 -> l_tuq07
                                tuq09=tuq09+l_tuq09,   #MOD-CB0111 modify b_ogb.ogb12*l_fac1*l_fac2 -> l_tuq09
                                tuq10=l_desc
             WHERE tuq01 = g_oga.oga03  AND tuq02 = b_ogb.ogb04
               AND tuq03 = b_ogb.ogb092 AND tuq04 = g_oga.oga02
               AND tuq11 = l_tuq11
               AND tuq12 = g_oga.oga04
               AND tuq05 = g_oga.oga01
               AND tuq051= b_ogb.ogb03
           #MOD-CB0111 -- add end --
            IF SQLCA.sqlcode THEN
               LET g_showmsg = g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04   #MOD-CB0111 add ,"/",g_oga.oga04
              #CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'update adq_file',SQLCA.sqlcode,1)           #MOD-CB0111 mark
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"UPD tuq_file",SQLCA.sqlcode,1)        #MOD-CB0111 add
               LET g_errno = SQLCA.sqlcode
               LET g_success='N'
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      #更新tup_file   #MOD-CB0111 add
      LET l_fac1=1
      IF b_ogb.ogb05 <> l_ima25 THEN
         CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ima25)
              RETURNING l_cnt,l_fac1
         IF l_cnt = '1'  THEN
            CALL s_errmsg('','',b_ogb.ogb04,'abm-731',1)
            LET l_fac1=1
         END IF
      END IF
     #MOD-CB0111 -- mark start --
     #SELECT COUNT(*) INTO i FROM adp_file
     # WHERE adp01=g_oga.oga03  AND adp02=b_ogb.ogb04
     #   AND adp03=b_ogb.ogb092
     #MOD-CB0111 -- mark end --
     #MOD-CB0111 -- add start --
      LET i = 0
      SELECT COUNT(*) INTO i FROM tup_file
       WHERE tup01 = g_oga.oga03  AND tup02 = b_ogb.ogb04
         AND tup03 = b_ogb.ogb092
         AND tup11 = l_tup11 AND tup12 = g_oga.oga04
      IF cl_null(b_ogb.ogb092) THEN LET b_ogb.ogb092 = ' '  END IF
     #MOD-CB0111 -- add end --
      IF i=0 THEN
        #MOD-CB0111 -- mark start --
        #INSERT INTO adp_file(adp01,adp02,adp03,adp04,adp05,adp06,adp07)
        #VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,l_ima25,
        #      #b_ogb.ogb12*l_fac1,l_ima71+g_oga.oga02,g_oga.oga02) #MOD-B30651 mark
        #       b_ogb.ogb12*l_fac1,l_adp06,g_oga.oga02)             #MOD-B30651
        #MOD-CB0111 -- mark end --
        #MOD-CB0111 -- add start --
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup11,tup12,
                              tupplant,tuplegal)
         VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,l_ima25,
                b_ogb.ogb12*l_fac1,l_tup06,g_oga.oga02,l_tup11,g_oga.oga04,
                g_plant,g_legal)
        #MOD-CB0111 -- add end --
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','insert tup_file',SQLCA.sqlcode,1)   #MOD-CB0111 adp_file -> tup_file
            LET g_errno = SQLCA.sqlcode
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      ELSE
        #MOD-CB0111 -- mark start --
        #UPDATE adp_file SET adp05=adp05+b_ogb.ogb12*l_fac1
        # WHERE adp01=g_oga.oga03  AND adp02=b_ogb.ogb04
        #   AND adp03=b_ogb.ogb092
        #MOD-CB0111 -- mark end --
        #MOD-CB0111 -- add start --
         UPDATE tup_file SET tup05=tup05+b_ogb.ogb12*l_fac1
          WHERE tup01 = g_oga.oga03  AND tup02 = b_ogb.ogb04
            AND tup03 = b_ogb.ogb092
            AND tup11 = l_tup11 AND tup12 = g_oga.oga04
        #MOD-CB0111 -- add end --
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb04,"/",b_ogb.ogb092   #MOD-CB0111 add ,"/",b_ogb.ogb092
           #CALL s_errmsg('adp01,adp02,adp03',g_showmsg,'update adp_file',SQLCA.sqlcode,1) #MOD-CB0111 mark
            CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1)    #MOD-CB0111 add
            LET g_errno = SQLCA.sqlcode
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
 
      IF g_success='N' THEN RETURN END IF
 
  END FOREACH
  
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
  CALL s_showmsg()
 
END FUNCTION
 
FUNCTION t650sub_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag) 
  DEFINE l_chang_prog  LIKE type_file.chr1
  DEFINE p_ware   LIKE ogb_file.ogb09,       ##倉庫
         p_loca   LIKE ogb_file.ogb091,      ##儲位
         p_lot    LIKE ogb_file.ogb092,      ##批號
         p_qty    LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
         p_qty2   LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         p_uom    LIKE ima_file.ima31,            ##銷售單位
         p_factor LIKE ogb_file.ogb15_fac,  ##轉換率
         p_flag   LIKE type_file.chr1,   
         l_qty    LIKE ogc_file.ogc12,
         l_ima01  LIKE ima_file.ima01,
         l_ima25  LIKE ima_file.ima01,
         l_img RECORD
               l_img01   LIKE img_file.img01,  
               img10   LIKE img_file.img10,
               img16   LIKE img_file.img16,
               img23   LIKE img_file.img23,
               img24   LIKE img_file.img24,
               img09   LIKE img_file.img09,
               img21   LIKE img_file.img21,
               img18   LIKE img_file.img18  
               END RECORD,
         l_cnt  LIKE type_file.num5,  
         l_oga02 LIKE oga_file.oga02 
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','axm-186',1) 
       LET g_errno = 'axm-186'
       LET g_success = 'N'
       RETURN
    END IF
 
    LET g_forupd_sql = "SELECT img01,img10,img16,img23,img24,img09,img21,img18 ",   
                       " FROM img_file ",
                       "   WHERE img01= ?  AND img02 = ? AND img03= ? ",
                       "   AND img04= ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING b_ogb.ogb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock
       LET g_errno = STATUS
       LET g_success='N' 
       RETURN
    END IF
 
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1)
       CLOSE img_lock
       LET g_errno = STATUS
       LET g_success='N' 
       RETURN
    END IF

    LET l_oga02 = NULL
    SELECT oga02 INTO l_oga02 FROM oga_file 
      WHERE oga01 = b_ogb.ogb01
    IF l_img.img18 < l_oga02 THEN
       CALL cl_err(b_ogb.ogb04,'aim-400',1)  
       LET g_errno = 'aim-400'
       LET g_success='N' 
       RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
 
    LET l_qty= l_img.img10 - p_qty2
    IF NOT s_stkminus(b_ogb.ogb04,p_ware,p_loca,p_lot,
                      p_qty,b_ogb.ogb15_fac,g_oga.oga02) THEN                    #FUN-D30024 add  
                     #p_qty,b_ogb.ogb15_fac,g_oga.oga02,g_sma.sma894[2,2]) THEN  #FUN-D30024 mark
       LET g_errno = 'aim-407' #當期庫存量已<=0或異動後庫存量會<0,但參數不允許庫存不足,請查核..!
       LET g_success='N'
       RETURN
    END IF
    LET l_chang_prog = 'N'
    IF g_prog = 'aws_ttsrv2' THEN
        LET l_chang_prog = 'Y'
        LET g_prog = 'axmt650'
    END IF
    CALL s_upimg(b_ogb.ogb04,p_ware,p_loca,p_lot,-1,p_qty2,g_today, 
          '','','','',b_ogb.ogb01,b_ogb.ogb03,'','','','','','','','','','','','')  
    IF l_chang_prog = 'Y' THEN
        LET g_prog = 'aws_ttsrv2'
    END IF
    IF g_success='N' THEN
       CALL cl_err('s_upimg()','9050',0) 
       LET g_errno = '9050'
       LET g_success = 'N'
       RETURN
    END IF
 
 
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql
 
    OPEN ima_lock USING b_ogb.ogb04
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       LET g_errno = STATUS
       LET g_success='N'
       CLOSE ima_lock
       RETURN
    END IF
 
    FETCH ima_lock INTO l_ima25,g_ima86
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       LET g_errno = STATUS
       LET g_success='N'
       CLOSE ima_lock
       RETURN
    END IF
 
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
    Call s_udima(b_ogb.ogb04,l_img.img23,l_img.img24,p_qty2*l_img.img21,
                 g_oga.oga02,-1)  RETURNING l_cnt   #MOD-920298
         #最近一次發料日期 表發料
    IF l_cnt THEN
       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
       LET g_errno = SQLCA.SQLCODE
       LET g_success='N' 
       RETURN
    END IF
 
    IF g_success='Y' THEN
       CALL t650sub_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,p_flag)
       IF g_success = 'N' THEN
           LET g_errno = 'aws-703' #異動tlf_file失敗!
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t650sub_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag) 
   DEFINE
      p_ware  LIKE ogb_file.ogb09,       ##倉庫
      p_loca  LIKE ogb_file.ogb091,      ##儲位
      p_lot   LIKE ogb_file.ogb092,      ##批號
      p_qty   LIKE tlf_file.tlf10,       ###銷售數量(銷售單位)
      p_uom   LIKE ima_file.ima31,       ##銷售單位
      p_factor LIKE ogb_file.ogb15_fac,  ##轉換率
      p_unit  LIKE ima_file.ima25,       ##單位
      p_img10    LIKE img_file.img10,    #異動後數量
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,   
      g_cnt      LIKE type_file.num5,  
      p_flag     LIKE type_file.chr1  
 
   #----來源----
   LET g_tlf.tlf01=b_ogb.ogb04         #異動料件編號
   LET g_tlf.tlf02=50                  #'Stock'
   LET g_tlf.tlf020=b_ogb.ogb08
   LET g_tlf.tlf021=p_ware             #倉庫
   LET g_tlf.tlf022=p_loca             #儲位
   LET g_tlf.tlf023=p_lot              #批號
   LET g_tlf.tlf024=p_img10            #異動後數量
   LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=b_ogb.ogb01        #出貨單號
   LET g_tlf.tlf027=b_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlf.tlf03=724
   LET g_tlf.tlf030=' '
   LET g_tlf.tlf031=' '                #倉庫
   LET g_tlf.tlf032=' '                #儲位
   LET g_tlf.tlf033=' '                #批號
   LET g_tlf.tlf034=' '                #異動後庫存數量
   LET g_tlf.tlf035=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=b_ogb.ogb01        #出貨單號
   LET g_tlf.tlf037=b_ogb.ogb03        #出貨項次
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=g_oga.oga02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom			#發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   #LET g_tlf.tlf13='axmt650sub'    #MOD-BC0188 mark
   LET g_tlf.tlf13='axmt650'        #MOD-BC0188 add 
   LET g_tlf.tlf14=b_ogb.ogb1001     #異動原因   
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
 
   CALL s_imaQOH(b_ogb.ogb04) RETURNING g_tlf.tlf18
 
   LET g_tlf.tlf19=g_oga.oga04
  #LET g_tlf.tlf20 = ' '           #MOD-CA0162 mark
   LET g_tlf.tlf20 = b_ogb.ogb41   #MOD-CA0162 add
   LET g_tlf.tlf61= g_ima86
   LET g_tlf.tlf62= ' '
   LET g_tlf.tlf63= ' '
   LET g_tlf.tlf66= p_flag  #No:8741
   LET g_tlf.tlf930=b_ogb.ogb930 
   CALL s_tlf(1,0)
 
END FUNCTION
 
FUNCTION t650sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
  DEFINE l_chang_prog  LIKE type_file.chr1
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg211  LIKE imgg_file.imgg211,
         p_no       LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_imgg10   LIKE imgg_file.imgg10,
         l_imgg01    LIKE imgg_file.imgg01,   #No.FUN-680137 INT # saki 20070821 rowid chr18 -> num10 
         p_type     LIKE type_file.num10   #No.FUN-680137 INTEGER
 
    LET g_forupd_sql =
        "SELECT imgg01 FROM imgg_file ",
        "   WHERE imgg01= ?  AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO l_imgg01
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-660167
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       #CALL cl_err('','mfg3075',0)   #MOD-A20043  
       CALL cl_err(b_ogb.ogb03,'mfg3075',0)   #MOD-A20043  
       LET g_success = 'N' RETURN
    END IF
 
    LET l_chang_prog = 'N'
    IF g_prog = 'aws_ttsrv2' THEN
        LET l_chang_prog = 'Y'
        LET g_prog = 'axmt650'
    END IF
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_oga.oga02, #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF l_chang_prog = 'Y' THEN
        LET g_prog = 'aws_ttsrv2'
    END IF
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t650sub_tlff(p_flag,p_item,p_ware,p_loc,p_lot,p_unit,p_fac,p_qty)
DEFINE
   p_flag     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
   p_item     LIKE ima_file.ima01,
   p_ware     LIKE img_file.img02,
   p_loc      LIKE img_file.img03,
   p_lot      LIKE img_file.img04,
   p_unit     LIKE img_file.img09,
   p_fac      LIKE img_file.img21,
   p_qty      LIKE img_file.img10,
   p_lineno   LIKE ogb_file.ogb03,
   l_imgg10   LIKE imgg_file.imgg10
 
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=p_item  AND imgg02=p_ware
      AND imgg03=p_loc   AND imgg04=p_lot
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
   #----來源----
   LET g_tlff.tlff01=p_item              #異動料件編號
   LET g_tlff.tlff02=50                  #'Stock'
   LET g_tlff.tlff020=b_ogb.ogb08
   LET g_tlff.tlff021=p_ware             #倉庫
   LET g_tlff.tlff022=p_loc              #儲位
   LET g_tlff.tlff023=p_lot              #批號
   LET g_tlff.tlff024=l_imgg10           #異動後數量
   LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=g_oga.oga01        #出貨單號
   LET g_tlff.tlff027=b_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlff.tlff03=724
   LET g_tlff.tlff030=' '
   LET g_tlff.tlff031=' '                #倉庫
   LET g_tlff.tlff032=' '                #儲位
   LET g_tlff.tlff033=' '                #批號
   LET g_tlff.tlff034=' '                #異動後庫存數量
   LET g_tlff.tlff035=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=g_oga.oga01        #訂單單號
   LET g_tlff.tlff037=b_ogb.ogb03        #訂單項次
 
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=g_oga.oga02      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12=p_fac            #發料/庫存 換算率
   #LET g_tlff.tlff13='axmt650sub'    #MOD-C30816 mark
   LET g_tlff.tlff13='axmt650'        #MOD-C30816 add
   LET g_tlff.tlff14=' '              #異動原因
 
   LET g_tlff.tlff17=' '              #非庫存性料件編號
   CALL s_imaQOH(b_ogb.ogb04)
        RETURNING g_tlff.tlff18
   LET g_tlff.tlff19 =g_oga.oga04
   LET g_tlff.tlff20 =' '
   LET g_tlff.tlff61= g_ima86
   LET g_tlff.tlff62=' '
   LET g_tlff.tlff63=' '
   LET g_tlff.tlff66=p_flag         #for axcp500多倉出貨處理   #No:8741
   LET g_tlff.tlff930=b_ogb.ogb930  #FUN-670063
   IF cl_null(b_ogb.ogb915) OR b_ogb.ogb915=0 THEN
      CALL s_tlff(p_flag,NULL)
   ELSE
      CALL s_tlff(p_flag,b_ogb.ogb913)
   END IF
END FUNCTION

FUNCTION t650sub_chk_ogb15_fac()
DEFINE l_ogb15_fac   LIKE ogb_file.ogb15_fac
DEFINE l_ogb15       LIKE ogb_file.ogb15
DEFINE l_cnt         LIKE type_file.num5
 
  SELECT img09 INTO l_ogb15 FROM img_file
        WHERE img01 = b_ogb.ogb04 AND img02 = b_ogb.ogb09
          AND img03 = b_ogb.ogb091 AND img04 = b_ogb.ogb092
 
  CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ogb15)
            RETURNING l_cnt,l_ogb15_fac
  IF l_cnt = 1 THEN
     CALL cl_err(b_ogb.ogb03,'mfg3075',1)   
     LET g_errno = 'mfg3075'
     LET g_success='N'   
     RETURN
  END IF
  IF l_ogb15 != b_ogb.ogb15 OR 
     l_ogb15_fac != b_ogb.ogb15_fac THEN
     LET b_ogb.ogb15_fac = l_ogb15_fac
     LET b_ogb.ogb15 = l_ogb15
     LET b_ogb.ogb16 = b_ogb.ogb12 * l_ogb15_fac
     LET b_ogb.ogb16 = s_digqty(b_ogb.ogb16,b_ogb.ogb15)  #FUN-BB0084
     
     UPDATE ogb_file SET ogb15_fac=b_ogb.ogb15_fac,
                         ogb16 =b_ogb.ogb16,
                         ogb15 =b_ogb.ogb15
           WHERE ogb01=g_oga.oga01
             AND ogb03=b_ogb.ogb03
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","ogb15_fac",g_oga.oga01,b_ogb.ogb03,SQLCA.sqlcode,"","",1) 
        LET g_errno = SQLCA.sqlcode
        LET g_success='N'   
        RETURN
     END IF
  END IF
  RETURN
END FUNCTION

FUNCTION t650sub_refresh(p_oga01)
  DEFINE p_oga01 LIKE oga_file.oga01
  DEFINE l_oga RECORD LIKE oga_file.*

  SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01
  RETURN l_oga.*
END FUNCTION
#FUN-B10004

#FUN-BB0167 add start--------------------------------------------
FUNCTION t650sub_on_check(l_oga)
   DEFINE l_n    LIKE type_file.num5    
   DEFINE tm     RECORD
                 cware     LIKE img_file.img02, 
                 cloc      LIKE img_file.img03  
                 END RECORD
   DEFINE l_imd  RECORD LIKE imd_file.* 
   DEFINE l_oga  RECORD LIKE oga_file.*
 
   LET tm.cware=l_oga.oga66
   LET tm.cloc =l_oga.oga67
   IF cl_null(tm.cware) THEN
      LET tm.cware=g_oaz.oaz74
      LET tm.cloc =g_oaz.oaz75
   END IF
 
   OPEN WINDOW t6271_w AT 2,39 WITH FORM "axm/42f/axmt6271"  
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("axmt6271")   
 
   INPUT BY NAME tm.cware,tm.cloc WITHOUT DEFAULTS
      AFTER FIELD cware
         IF NOT cl_null(tm.cware) THEN  #genero,per檔加not required
            SELECT * INTO l_imd.* FROM imd_file 
             WHERE imd01 = tm.cware
               AND imdacti = 'Y' 
            IF STATUS <> 0 THEN
               CALL cl_err3("sel","imd_file",tm.cware,"","ams-004","","",1)  
               NEXT FIELD cware
            END IF
            IF NOT (l_imd.imd11 MATCHES '[Yy]') THEN
               CALL cl_err(g_oaz.oaz74,'axm-993',0)
               NEXT FIELD cware
            END IF
            IF NOT (l_imd.imd10 MATCHES '[Ww]') THEN 
               CALL cl_err(g_oaz.oaz74,'axm-666',0) 
               NEXT FIELD cware
            END IF
            IF NOT (l_imd.imd12 MATCHES '[Nn]') THEN
               CALL cl_err(tm.cware,'axm-067',0) 
               NEXT FIELD cware
            END IF
 
            SELECT COUNT(*) INTO l_n FROM ogb_file
             WHERE ogb01 = l_oga.oga01
               AND ogb09 = tm.cware
            IF l_n > 0 THEN
               CALL cl_err('','axm-419',0)
               LET tm.cware=' '
               NEXT FIELD cware 
            END IF
            IF g_azw.azw04='2' THEN                                                                                                 
               LET l_n=0                                                                                                            
               SELECT COUNT(*) INTO l_n  FROM jce_file                                                                              
                WHERE jce02=tm.cware                                                                                                
               IF l_n !=0 THEN                                                                                                      
                  CALL cl_err(tm.cware,'art-452',0)                                                                                 
                  NEXT FIELD cware                                                                                                  
               END IF                                                                                                               
            END IF
            IF NOT s_chk_ware(tm.cware) THEN
               NEXT FIELD cware
            END IF
         END IF
         #FUN-D40103 -----Begin-------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc 
         END IF
         #FUN-D40103 -----End---------
 
      AFTER FIELD cloc
         IF cl_null(tm.cloc) THEN  
            LET tm.cloc = ' '
         END IF
 
         #FUN-D40103 ----Begin----
       # SELECT * FROM ime_file
       #  WHERE ime01 = tm.cware
       #    AND ime02 = tm.cloc
       # IF STATUS <> 0 THEN
       #    CALL cl_err('','mfg0095',0)
       #    NEXT FIELD cware
       # END IF
      #FUN-D40103 ----End------
         SELECT COUNT(*) INTO l_n FROM ogb_file
          WHERE ogb01  = l_oga.oga01
            AND ogb09 = tm.cware
            AND ogb091 = tm.cloc
         IF l_n > 0 THEN
            CALL cl_err('','axm-419',0)
            LET tm.cloc=' '
            NEXT FIELD cware
        END IF
        #FUN-D40103 -----Begin-------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc 
         END IF
      #FUN-D40103 -----End---------
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF

         IF cl_null(tm.cloc) THEN LET tm.cloc = ' ' END IF
         SELECT * FROM ime_file
          WHERE ime01=tm.cware AND ime02=tm.cloc 
          AND imeacti = 'Y'  #FUN-D40103
         IF STATUS <> 0 THEN
            CALL cl_err('','mfg0095',0)
            LET tm.cloc=' '
            NEXT FIELD cloc
         END IF
         SELECT COUNT(*) INTO l_n FROM ogb_file
          WHERE ogb01 = l_oga.oga01 AND ogb09 = tm.cware
         IF l_n > 0 THEN
            CALL cl_err('','axm-419',0)
            LET tm.cloc=' '
            NEXT FIELD tm.cware
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cware)
                 CALL q_imd_1(FALSE,TRUE,tm.cware,'W',"","","imd11='Y' AND imd12 = 'N'") RETURNING tm.cware #S->W 
                 DISPLAY BY NAME tm.cware
            WHEN INFIELD(cloc)
                 CALL q_ime_1(FALSE,TRUE,tm.cloc,tm.cware,"W","","","","") RETURNING tm.cloc #mod S->W
                 DISPLAY BY NAME tm.cloc
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 
         
      ON ACTION controlg      
         CALL cl_cmdask()     
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET g_success = 'N'
      CLOSE WINDOW t6271_w
      RETURN l_oga.*
   END IF
 
   CLOSE WINDOW t6271_w
 
   IF cl_null(tm.cloc) THEN  
      LET tm.cloc=' '
   END IF
 
   UPDATE oga_file SET oga66 = tm.cware,
                       oga67 = tm.cloc
    WHERE oga01 = l_oga.oga01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('upd ogaconf',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN l_oga.*
   END IF
 
   LET l_oga.oga910 = tm.cware
   LET l_oga.oga911 = tm.cloc
   RETURN l_oga.* #因為此處有異動oga_file的資料,所以必須回傳回去
END FUNCTION

FUNCTION t650sub_consign_mu(p_ware,p_loca,p_lot,l_oga,l_ogb)
  DEFINE l_ogb    RECORD LIKE ogb_file.*
  DEFINE p_ware   LIKE ogb_file.ogb09,       ##倉庫
         p_loca   LIKE ogb_file.ogb091,      ##儲位
         p_lot    LIKE ogb_file.ogb092,      ##批號
         l_qty2   LIKE img_file.img10,
         l_qty1   LIKE img_file.img10,
         l_ima906 LIKE ima_file.ima906,
         l_imgg   RECORD LIKE imgg_file.*,
         l_oga    RECORD LIKE oga_file.*
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
    LET l_qty2=l_ogb.ogb915
    LET l_qty1=l_ogb.ogb912
    IF cl_null(l_qty1)  THEN LET l_qty1=0 END IF
    IF cl_null(l_qty2)  THEN LET l_qty2=0 END IF
 
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_ogb.ogb04
    #FUN-C50097 ADD BEGIN----
    IF l_ogb.ogb17 ='Y' THEN #要将出货单的仓储批的批号带到签收单\发票仓
       #FOREACH 母单位批号 数量
       DECLARE t650_sub_ogg_c1 CURSOR FOR  
        SELECT SUM(ogg16),ogg092 FROM ogg_file   
         WHERE ogg01=l_oga.oga01 
           AND ogg03=l_ogb.ogb03
           AND ogg20='2'
         GROUP BY ogg092   
       FOREACH t650_sub_ogg_c1 INTO l_qty2,p_lot  
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('','',"Foreach s1_ogg_c1:",SQLCA.sqlcode,1)
             LET g_success='N' EXIT FOREACH
          END IF       
          IF l_ima906 MATCHES '[23]' THEN
             IF NOT cl_null(l_ogb.ogb913) THEN
                SELECT * INTO l_imgg.* FROM imgg_file
                 WHERE imgg01= l_ogb.ogb04
                   AND imgg02= p_ware
                   AND imgg03= p_loca
                   AND imgg04= p_lot
                   AND imgg09= l_ogb.ogb913
                IF STATUS <> 0 THEN            ## 新增一筆img_file
                   CALL t650sub_set_imgg(l_ogb.ogb913,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
       
                   LET l_imgg.imggplant = g_plant 
                   LET l_imgg.imgglegal = g_legal 
       
                   INSERT INTO imgg_file VALUES (l_imgg.*)
                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                      LET g_success='N' RETURN
                   END IF
                END IF
                IF l_ima906 = '2' THEN
                   CALL t650sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2')
                   IF g_success='N' THEN RETURN END IF
                   IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                      CALL t650sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                         l_ogb.ogb913,l_ogb.ogb914,l_qty2,l_oga.*,l_ogb.*,'1')
                   END IF   #No.MOD-790136 add
                   IF g_success='N' THEN RETURN END IF
                ELSE
                   CALL t650sub_upd_imgg('2',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2')
                   IF g_success='N' THEN RETURN END IF
                   IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                      CALL t650sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                         l_ogb.ogb913,l_ogb.ogb914,l_qty2,l_oga.*,l_ogb.*,'1')
                   END IF   #No.MOD-790136 add
                   IF g_success='N' THEN RETURN END IF
                END IF
             END IF
          END IF          
       END FOREACH 
       
       #FOREACH 子单位批号 数量
       DECLARE t650_sub_ogg_c2 CURSOR FOR  
        SELECT SUM(ogg16),ogg092 FROM ogg_file   
         WHERE ogg01=l_oga.oga01 
           AND ogg03=l_ogb.ogb03
           AND ogg20='1'
         GROUP BY ogg092   
       FOREACH t650_sub_ogg_c2 INTO l_qty1,p_lot  
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('','',"Foreach sub_ogg_c2:",SQLCA.sqlcode,1)
             LET g_success='N' EXIT FOREACH
          END IF 
          IF l_ima906 ='2' THEN
             IF NOT cl_null(l_ogb.ogb910) THEN
                SELECT * INTO l_imgg.* FROM imgg_file
                 WHERE imgg01= l_ogb.ogb04 AND imgg02= p_ware
                   AND imgg03= p_loca      AND imgg04= p_lot
                   AND imgg09= l_ogb.ogb910
                IF STATUS <> 0 THEN            ## 新增一筆img_file
                   CALL t650sub_set_imgg(l_ogb.ogb910,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
       
                   LET l_imgg.imggplant = g_plant 
                   LET l_imgg.imgglegal = g_legal 
       
                   INSERT INTO imgg_file VALUES (l_imgg.*)
                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                      LET g_success='N' RETURN
                   END IF
                END IF
                CALL t650sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb910,l_ogb.ogb911,l_qty1,+1,'1')                                  
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb912) THEN                                            #CHI-860005
                   CALL t650sub_contlff('1',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb910,l_ogb.ogb911,l_qty1,l_oga.*,l_ogb.*,'1')                                      
                END IF   #No.MOD-790136 add
                IF g_success='N' THEN RETURN END IF
             END IF
          END IF                   
       END FOREACH     
    ELSE  #非多仓储 FUN-C50097           	
       IF l_ima906 MATCHES '[23]' THEN
          IF NOT cl_null(l_ogb.ogb913) THEN
             SELECT * INTO l_imgg.* FROM imgg_file
              WHERE imgg01= l_ogb.ogb04
                AND imgg02= p_ware
                AND imgg03= p_loca
                AND imgg04= p_lot
                AND imgg09= l_ogb.ogb913
             IF STATUS <> 0 THEN            ## 新增一筆img_file
                CALL t650sub_set_imgg(l_ogb.ogb913,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
    
                LET l_imgg.imggplant = g_plant 
                LET l_imgg.imgglegal = g_legal 
    
                INSERT INTO imgg_file VALUES (l_imgg.*)
                IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                   LET g_success='N' RETURN
                END IF
             END IF
             IF l_ima906 = '2' THEN
                CALL t650sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2')
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                   #CALL t650sub_tlff('2',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04, #FUN-C50097 MARK 120801
                   #                   l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915)
                   CALL t650sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'')                                                        
                END IF  
                IF g_success='N' THEN RETURN END IF
             ELSE
                CALL t650sub_upd_imgg('2',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2')
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                   #CALL t650sub_tlff('2',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04, #FUN-C50097 MARK 120801
                   #                   l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915)
                   CALL t650sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'')                   
                END IF  
                IF g_success='N' THEN RETURN END IF
             END IF
          END IF
       END IF
       IF l_ima906 ='2' THEN
          IF NOT cl_null(l_ogb.ogb910) THEN
             SELECT * INTO l_imgg.* FROM imgg_file
              WHERE imgg01= l_ogb.ogb04 AND imgg02= p_ware
                AND imgg03= p_loca      AND imgg04= p_lot
                AND imgg09= l_ogb.ogb910
             IF STATUS <> 0 THEN            ## 新增一筆img_file
                CALL t650sub_set_imgg(l_ogb.ogb910,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
    
                LET l_imgg.imggplant = g_plant 
                LET l_imgg.imgglegal = g_legal 
    
                INSERT INTO imgg_file VALUES (l_imgg.*)
                IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                   LET g_success='N' RETURN
                END IF
             END IF
             CALL t650sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                l_ogb.ogb910,l_ogb.ogb911,l_qty1,+1,'1')
             IF g_success='N' THEN RETURN END IF
             IF NOT cl_null(l_ogb.ogb912) THEN                                            #CHI-860005
                #CALL t650sub_tlff('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04, #FUN-C50097 MARK 120801
                #                   l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912)
                CALL t650sub_contlff('1',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,l_oga.*,l_ogb.*,'')                
             END IF   
             IF g_success='N' THEN RETURN END IF
          END IF
       END IF
    END IF #FUN-C50097 120801   
 
END FUNCTION

FUNCTION t650sub_set_imgg(p_unit,p_ware,p_loca,p_lot,l_ogb)  
   DEFINE l_imgg     RECORD LIKE imgg_file.*,
          p_ware     LIKE img_file.img02,
          l_ogb      RECORD LIKE ogb_file.*,
          p_loca     LIKE img_file.img03,
          p_lot      LIKE img_file.img04,
          p_unit     LIKE ima_file.ima25,
          l_img09    LIKE img_file.img09,
          l_ima25    LIKE ima_file.ima25,
          l_cnt      LIKE type_file.num5
   DEFINE l_factor   LIKE img_file.img21
   DEFINE l_ima906   LIKE ima_file.ima906   #MOD-9B0189
   INITIALIZE l_imgg.* TO NULL
   SELECT ima906 INTO l_ima906 FROM ima_file
     WHERE ima01=l_ogb.ogb04
   IF l_ima906 = '2' THEN LET l_imgg.imgg00 = '1' END IF
   IF l_ima906 = '3' THEN LET l_imgg.imgg00 = '2' END IF
   LET l_imgg.imgg01=l_ogb.ogb04
   LET l_imgg.imgg02=p_ware
   LET l_imgg.imgg03=p_loca
   LET l_imgg.imgg04=p_lot
   LET l_imgg.imgg05=l_ogb.ogb01
   LET l_imgg.imgg06=l_ogb.ogb03
   LET l_imgg.imgg09=p_unit
   LET l_imgg.imgg10=0
   LET l_imgg.imgg13=null   #No:7304
   LET l_imgg.imgg17=g_today
   LET l_imgg.imgg18=MDY(12,31,9999)
   SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_ogb.ogb04
   LET l_factor=1
   CALL s_umfchk(l_ogb.ogb04,l_imgg.imgg09,l_ima25)
        RETURNING l_cnt,l_factor
   IF l_cnt THEN
      LET l_factor = 1
   END IF
   LET l_imgg.imgg21=l_factor
   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01= l_ogb.ogb04 AND img02= p_ware
      AND img03= p_loca      AND img04= p_lot
   LET l_factor=1
   CALL s_umfchk(l_ogb.ogb04,l_imgg.imgg09,l_img09)
        RETURNING l_cnt,l_factor
   IF l_cnt THEN
      LET l_factor = 1
   END IF
   LET l_imgg.imgg211=l_factor
 
   LET l_imgg.imgg22='S'
   SELECT imd10,imd11,imd12,imd13 INTO
          l_imgg.imgg22, l_imgg.imgg23, l_imgg.imgg24, l_imgg.imgg25
     FROM imd_file WHERE imd01=l_imgg.imgg02
   LET l_imgg.imgg30=0
   LET l_imgg.imgg31=0
   LET l_imgg.imgg32=0
   LET l_imgg.imgg33=0
   LET l_imgg.imgg34=1
   IF l_imgg.imgg02 IS NULL THEN LET l_imgg.imgg02 = ' ' END IF
   IF l_imgg.imgg03 IS NULL THEN LET l_imgg.imgg03 = ' ' END IF
   IF l_imgg.imgg04 IS NULL THEN LET l_imgg.imgg04 = ' ' END IF
   RETURN l_imgg.*
 
END FUNCTION

FUNCTION t650sub_consign(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_item,l_oga,l_ogb)  #CHI-AC0034
  DEFINE p_ware   LIKE ogb_file.ogb09,       ##倉庫
         l_ogb    RECORD LIKE ogb_file.*,    #No.FUN-630061
         p_loca   LIKE ogb_file.ogb091,      ##儲位
         p_lot    LIKE ogb_file.ogb092,      ##批號
         p_qty    LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
         p_qty2   LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         l_qty2   LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         p_uom    LIKE ima_file.ima31,       ##銷售單位
         p_factor LIKE ogb_file.ogb15_fac,   ##轉換率
         l_factor LIKE ogb_file.ogb15_fac,   ##轉換率
         l_qty    LIKE ogc_file.ogc12,       ##異動後數量
         l_cnt    LIKE type_file.num5,    
         l_ima01  LIKE ima_file.ima01,
         l_ima25  LIKE ima_file.ima25,
         p_img    RECORD LIKE img_file.*,
         l_img    RECORD
                  img10   LIKE img_file.img10,
                  img16   LIKE img_file.img16,
                  img23   LIKE img_file.img23,
                  img24   LIKE img_file.img24,
                  img09   LIKE img_file.img09,
                  img21   LIKE img_file.img21
                  END RECORD
   DEFINE l_oeb19   LIKE oeb_file.oeb19
   DEFINE l_avl_stk  LIKE type_file.num15_3 
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
   DEFINE l_ima71   LIKE type_file.num5    
   DEFINE l_ima86   LIKE ima_file.ima86  
   DEFINE l_oga   RECORD LIKE oga_file.*
   DEFINE p_flag    LIKE type_file.chr1   
   DEFINE p_item    LIKE ogc_file.ogc17   
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF

    SELECT * INTO p_img.* FROM img_file
     WHERE img01= p_item AND img02= p_ware  
       AND img03= p_loca AND img04= p_lot
    IF STATUS <> 0 THEN            ## 新增一筆img_file
       INITIALIZE p_img.* TO NULL
       LET p_img.img01=p_item       
       LET p_img.img02=p_ware
       LET p_img.img03=p_loca
       LET p_img.img04=p_lot
       LET p_img.img05=l_ogb.ogb01  
       LET p_img.img06=l_ogb.ogb03  
       SELECT ima25 INTO p_img.img09 FROM ima_file WHERE ima01=p_img.img01
       LET p_img.img10=0
       LET p_img.img13=null   
       LET p_img.img17=g_today
       LET p_img.img18=MDY(12,31,9999)
       LET p_img.img21=1
       LET p_img.img22='S'
       LET p_img.img37=l_oga.oga02   
       SELECT imd10,imd11,imd12,imd13 INTO
              p_img.img22, p_img.img23, p_img.img24, p_img.img25
         FROM imd_file WHERE imd01=p_img.img02
       LET p_img.img30=0
       LET p_img.img31=0
       LET p_img.img32=0
       LET p_img.img33=0
       LET p_img.img34=1
       IF p_img.img02 IS NULL THEN LET p_img.img02 = ' ' END IF
       IF p_img.img03 IS NULL THEN LET p_img.img03 = ' ' END IF
       IF p_img.img04 IS NULL THEN LET p_img.img04 = ' ' END IF
 
       LET p_img.imgplant = g_plant 
       LET p_img.imglegal = g_legal 
 
       INSERT INTO img_file VALUES (p_img.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","img_file","","",SQLCA.sqlcode,"","ins img:",1)  
          LET g_success='N' RETURN
       END IF
    END IF
    CALL s_umfchk(p_item,p_uom,p_img.img09) RETURNING l_cnt,l_factor  
    IF l_cnt = 1 THEN
       CALL cl_err('','mfg3075',0)
       LET g_success='N' RETURN
    END IF
    LET l_qty2=p_qty*l_factor
 
    LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ",
                       " FROM img_file ",
                       "  WHERE img01= ?  AND img02= ? AND img03= ? ",
                       " AND img04= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock1 CURSOR FROM g_forupd_sql
 
    OPEN img_lock1 USING p_item,p_ware,p_loca,p_lot  
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock1      
       LET g_success = 'N'  
       RETURN
    END IF
 
    FETCH img_lock1 INTO l_img.*
    IF STATUS THEN
       CLOSE img_lock1   
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
 
    CALL s_upimg(p_item,p_ware,p_loca,p_lot,1,l_qty2,g_today, 
          '','','','',l_ogb.ogb01,l_ogb.ogb03,'','','','','','','','','','','','')  
    IF g_success='N' THEN
       CALL cl_err('s_upimg()',SQLCA.SQLCODE,1) RETURN
    END IF

    #Update ima_file
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock1 CURSOR FROM g_forupd_sql

    OPEN ima_lock1 USING p_item  
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       CLOSE ima_lock1
       LET g_success='N'
       RETURN
    END IF
 
    FETCH ima_lock1 INTO l_ima25,l_ima86 
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       CLOSE ima_lock1
       LET g_success='N'
       RETURN
    END IF
 
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
    Call s_udima(p_item,l_img.img23,l_img.img24,l_qty2*l_img.img21,  
                 l_oga.oga02,1)  RETURNING l_cnt   
 
   #最近一次發料日期 表發料
    IF l_cnt THEN
       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
       LET g_success='N' RETURN
    END IF
 
    IF g_success='Y' THEN
       CALL t650sub_contlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty2,p_uom,l_factor,p_flag)  
    END IF
 
END FUNCTION

FUNCTION t650sub_contlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag)
   DEFINE
      p_ware     LIKE ogb_file.ogb09,       ##倉庫 
      p_loca     LIKE ogb_file.ogb091,      ##儲位
      p_lot      LIKE ogb_file.ogb092,      ##批號
      p_qty      LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
      p_uom      LIKE ima_file.ima31,       ##銷售單位
      p_factor   LIKE ogb_file.ogb15_fac,   ##轉換率
      p_unit     LIKE ima_file.ima25,       ##單位
      p_img10    LIKE img_file.img10,       #異動後數量
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    
      l_cnt      LIKE type_file.num5    
   DEFINE p_item LIKE img_file.img01
   DEFINE p_flag LIKE type_file.chr1

   #----來源----
   LET g_tlf.tlf01=b_ogb.ogb04         #異動料件編號 
   LET g_tlf.tlf02=724
   LET g_tlf.tlf020=' '
   LET g_tlf.tlf021=' '                #倉庫
   LET g_tlf.tlf022=' '                #儲位
   LET g_tlf.tlf023=' '                #批號
   LET g_tlf.tlf024=' '                #異動後庫存數量
   LET g_tlf.tlf025=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=b_ogb.ogb31        #出貨單號 
   LET g_tlf.tlf027=b_ogb.ogb32        #出貨項次  
   #---目的----
   LET g_tlf.tlf03=50                  #'Stock'
   LET g_tlf.tlf030=b_ogb.ogb08  
   LET g_tlf.tlf031=p_ware             #倉庫
   LET g_tlf.tlf032=p_loca             #儲位
   LET g_tlf.tlf033=p_lot              #批號
   LET g_tlf.tlf034=p_img10            #異動後數量
   LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=b_ogb.ogb01        #訂單單號 
   LET g_tlf.tlf037=b_ogb.ogb03        #訂單項次  
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=g_oga.oga02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom            #發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   LET g_tlf.tlf13='axmt650'
   LET g_tlf.tlf14=b_ogb.ogb1001    #異動原因

   LET g_tlf.tlf17='To Consign Warehouse'
   IF g_oga.oga65 = 'Y' THEN 
      LET g_tlf.tlf17='To On-Check Warehouse'
   END IF
   CALL s_imaQOH(b_ogb.ogb04)  
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=g_oga.oga03
   LET g_tlf.tlf20 = g_oga.oga46
   LET g_tlf.tlf61= g_ima86
   LET g_tlf.tlf62=b_ogb.ogb31    #參考單號(訂單)
   LET g_tlf.tlf63=b_ogb.ogb32    #訂單項次
   LET g_tlf.tlf64=b_ogb.ogb908   #手冊編號
   LET g_tlf.tlf66=p_flag        
   LET g_tlf.tlf930=b_ogb.ogb930
   LET g_tlf.tlf20 = b_ogb.ogb41
   LET g_tlf.tlf41 = b_ogb.ogb42
   LET g_tlf.tlf42 = b_ogb.ogb43
   LET g_tlf.tlf43 = b_ogb.ogb1001

   IF g_prog[1,7] = 'axmt628' THEN   
      IF s_industry('icd') THEN
         LET g_prog = 'axmt629_icd'
      ELSE
         LET g_prog = 'axmt629'
      END if

      CALL s_tlf(1,0)

      IF s_industry('icd') THEN
         LET g_prog = 'axmt628_icd'
      ELSE
         LET g_prog = 'axmt628'
      END if

   ELSE
      CALL s_tlf(1,0)
   END IF

END FUNCTION
#FUN-BB0167 add end------------------------------------

#FUN-C50097 ADD  BEGIN 120801 copy saxmt600_sub
FUNCTION t650sub_contlff(p_flag,p_ware,p_loc,p_lot,p_unit,p_fac,p_qty,l_oga,l_ogb,p_type) #No.FUN-630061
   DEFINE
      p_flag     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
      l_ogb      RECORD LIKE ogb_file.*,    #No.FUN-630061
      p_ware     LIKE ogb_file.ogb09,       ##倉庫
      p_loc      LIKE ogb_file.ogb091,      ##儲位
      p_lot      LIKE ogb_file.ogb092,      ##批號
      p_unit     LIKE ima_file.ima25,
      p_fac      LIKE img_file.img21,
      p_qty      LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
      l_imgg10   LIKE img_file.img10,       #異動後數量
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      #g_cnt      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      l_ima86    LIKE ima_file.ima86,    #FUN-730018
      l_oga      RECORD LIKE oga_file.*
DEFINE l_argv0 LIKE ogb_file.ogb09 #FUN-C40072 add
DEFINE p_type     LIKE type_file.chr1  #FUN-C50097 ADD  #多仓储出货

   LET l_argv0=l_oga.oga09 #FUN-C40072 add
 
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=l_ogb.ogb04  AND imgg02=p_ware
      AND imgg03=p_loc        AND imgg04=p_lot
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
   SELECT ima86 INTO l_ima86 FROM ima_file
                            WHERE ima01=l_ogb.ogb04
   #----來源----
   LET g_tlff.tlff01=l_ogb.ogb04         #異動料件編號
   LET g_tlff.tlff02=724
   LET g_tlff.tlff020=' '
   LET g_tlff.tlff021=' '                #倉庫
   LET g_tlff.tlff022=' '                #儲位
   LET g_tlff.tlff023=' '                #批號
   LET g_tlff.tlff024=' '                #異動後庫存數量
   LET g_tlff.tlff025=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=l_ogb.ogb31        #出貨單號
   LET g_tlff.tlff027=l_ogb.ogb32        #出貨項次
   #---目的----
   LET g_tlff.tlff03=50                  #'Stock'
   LET g_tlff.tlff030=l_ogb.ogb08
   LET g_tlff.tlff031=p_ware             #倉庫
   LET g_tlff.tlff032=p_loc              #儲位
   LET g_tlff.tlff033=p_lot              #批號
   LET g_tlff.tlff034=l_imgg10           #異動後數量
   LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=l_ogb.ogb01        #訂單單號
   LET g_tlff.tlff037=l_ogb.ogb03        #訂單項次
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=l_oga.oga02      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12 =p_fac           #發料/庫存 換算率
#FUN-C40072---add---START
   IF l_argv0 = '4' THEN
      LET g_tlff.tlff13='axmt820'
   ELSE
#FUN-C40072---add-----END
      LET g_tlff.tlff13='axmt650'
   END IF #FUN-C40072 add
   LET g_tlff.tlff14=' '              #異動原因
   LET g_tlff.tlff17='To Consign Warehouse'
   CALL s_imaQOH(l_ogb.ogb04)
        RETURNING g_tlff.tlff18
   LET g_tlff.tlff19=l_oga.oga04
   LET g_tlff.tlff20 = l_oga.oga46
   LET g_tlff.tlff61= l_ima86 #FUN-730018
   LET g_tlff.tlff62=l_ogb.ogb31    #參考單號(訂單)
   LET g_tlff.tlff63=l_ogb.ogb32    #訂單項次
   LET g_tlff.tlff64=l_ogb.ogb908   #手冊編號 no.A050
   LET g_tlff.tlff930=l_ogb.ogb930 #FUN-670063
   IF p_type = "1" THEN   #No:FUN-C50097
      CALL s_tlff(p_flag,NULL)   #No:FUN-C50097
   ELSE   #No:FUN-C50097
      IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915=0 THEN
         CALL s_tlff(p_flag,NULL)
      ELSE
         CALL s_tlff(p_flag,l_ogb.ogb913) 
      END IF
   END IF 
END FUNCTION
#FUN-C50097 ADD END 120801


#MOD-CB0050 add begin-----------
FUNCTION t650sub_chk_ogb1001(p_ogb1001)
DEFINE p_ogb1001 LIKE ogb_file.ogb1001,
       l_cnt2    LIKE type_file.num5

   SELECT COUNT(*) INTO l_cnt2 FROM azf_file 
    WHERE azf01=p_ogb1001
    AND azf02 = '2' 
    AND azf08 = 'Y'   
    AND azfacti = 'Y' 
   RETURN l_cnt2
   
END FUNCTION     
#MOD-CB0050 add end-------------

