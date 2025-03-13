# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: saxmt700_sub.4gl
# Descriptions...: 提供saxmt700.4gl使用的sub routine
# Date & Author..: No:DEV-D30046 13/04/03 By TSD.sophy
# Modify.........: No.CHI-CC0028 13/04/15 By bart 過帳還原需控管"有無此倉儲的過賬權限"
# Modify.........: No.DEV-D40015 13/04/19 By Nina 若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
# Modify.........: No.DEV-D40018 13/04/22 By Nina 修正DEV-D40015控卡g_prog的條件
# Modify.........: No.DEV-D40013 13/04/22 By Mandy 純過單用
# Modify.........: No:MOD-FB0135 15/11/25 By catmoon 銷退扣帳時，因為錯誤訊息被清空，導致沒有反應 #add by liy210707
# Modify.........: No.2021113001 21/11/30 By jc 销退扣账同步到SCM
 

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
             img01         LIKE img_file.img01,
             img02         LIKE img_file.img02,
             img03         LIKE img_file.img03,
             img04         LIKE img_file.img04,
             img05         LIKE img_file.img05,
             img06         LIKE img_file.img06,
             img09         LIKE img_file.img09,
             img13         LIKE img_file.img13,
             img14         LIKE img_file.img14,
             img17         LIKE img_file.img17,
             img18         LIKE img_file.img18,
             img19         LIKE img_file.img19,
             img21         LIKE img_file.img21,
             img26         LIKE img_file.img26,
             img27         LIKE img_file.img27,
             img28         LIKE img_file.img28,
             img35         LIKE img_file.img35,
             img36         LIKE img_file.img36,
             img37         LIKE img_file.img37
                           END RECORD
   
   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
             imgg00        LIKE imgg_file.imgg00,
             imgg01        LIKE imgg_file.imgg01,
             imgg02        LIKE imgg_file.imgg02,
             imgg03        LIKE imgg_file.imgg03,
             imgg04        LIKE imgg_file.imgg04,
             imgg05        LIKE imgg_file.imgg05,
             imgg06        LIKE imgg_file.imgg06,
             imgg09        LIKE imgg_file.imgg09,
             imgg10        LIKE imgg_file.imgg10,
             imgg20        LIKE imgg_file.imgg20,
             imgg21        LIKE imgg_file.imgg21,
             imgg211       LIKE imgg_file.imgg211,
             imggplant     LIKE imgg_file.imggplant,
             imgglegal     LIKE imgg_file.imgglegal
                           END RECORD
END GLOBALS
#FUN-CC0095---end
#DEV-D30046 --add--begin
DEFINE g_ima918      LIKE ima_file.ima918
DEFINE g_ima921      LIKE ima_file.ima921
DEFINE g_ima930      LIKE ima_file.ima930
DEFINE g_ima906      LIKE ima_file.ima906
DEFINE g_ima907      LIKE ima_file.ima907
DEFINE g_ima86       LIKE ima_file.ima86
DEFINE g_sql         STRING 
DEFINE g_buf         LIKE type_file.chr1000
DEFINE g_msg         LIKE type_file.chr1000
DEFINE g_msg1        LIKE type_file.chr1000
DEFINE g_cmd         LIKE type_file.chr1000
DEFINE g_chr         LIKE type_file.chr1
DEFINE g_oga01       LIKE oga_file.oga01
#DEV-D30046 --add--end

##################################
#作用    : lock cursor
#回傳值  : 無
##################################
FUNCTION saxmt700sub_lock_cl()
   DEFINE l_forupd_sql      STRING

   LET l_forupd_sql = "SELECT * FROM oha_file WHERE oha01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t700sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

##############################################
#作用    : 確認檢查
#傳入參數: p_oha01          銷退單號
#          p_action_choice  執行"確認"的按鈕的名稱,若外部呼叫可傳NULL
#回傳值  : 無
##############################################
FUNCTION saxmt700sub_y_chk(p_oha01,p_action_choice)
   DEFINE p_oha01          LIKE oha_file.oha01     #DEV-D30046 --add
   DEFINE p_action_choice  STRING                  #DEV-D30046 --add
   DEFINE l_yy,l_mm        LIKE type_file.num5     #No.FUN-680137  SMALLINT
   DEFINE l_cnt            LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE l_ohb12          LIKE ohb_file.ohb12     #No.9732
   DEFINE l_ohb            RECORD LIKE ohb_file.*  #no.FUN-860025
   DEFINE l_rvbs06         LIKE rvbs_file.rvbs06   #no.FUN-860025
   DEFINE l_rxx04          LIKE rxx_file.rxx04     #No.FUN-870007 
   DEFINE l_ohb14t         LIKE ohb_file.ohb14t    #No.FUN-870007     
   #DEFINE l_ohb67          LIKE ohb_file.ohb67    #No.FUN-870007   #FUN-AB0061 mark
   DEFINE l_ohb13          LIKE ohb_file.ohb13
   DEFINE l_ohb03          LIKE ohb_file.ohb03
   #DEFINE l_ohb33          LIKE ohb_file.ohb33    #MOD-A10016 add       #MOD-BA0171 mark
   #DEFINE l_ohb34          LIKE ohb_file.ohb34    #MOD-A10016 add       #MOD-BA0171 mark  
   #DEFINE l_imaicd13       LIKE imaicd_file.imaicd13   #FUN-A40022  #FUN-B50096
   DEFINE l_ima159         LIKE ima_file.ima159    #FUN-B50096 
   DEFINE l_ohb09          LIKE ohb_file.ohb09     #No.FUN-AA0048
   DEFINE l_ima154         LIKE ima_file.ima154    #FUN-BC0081 
   DEFINE l_rxe08          LIKE rxe_file.rxe08     #FUN-BC0081
   DEFINE l_rxe04          LIKE rxe_file.rxe04     #FUN-BC0081
   DEFINE l_rxe05          LIKE rxe_file.rxe05     #FUN-BC0081
   DEFINE l_img09          LIKE img_file.img09     #CHI-C30064 add
   DEFINE l_ohb05_fac      LIKE ohb_file.ohb05_fac #CHI-C30064 add
   #FUN-C70098-----add---begin----------
   #&ifdef SLK
   DEFINE l_ohbslk03       LIKE ohbslk_file.ohbslk03
   DEFINE l_ohbslk04       LIKE ohbslk_file.ohbslk04
   DEFINE l_ohbslk12       LIKE ohbslk_file.ohbslk12
   #&endif
   #FUN-C70098-----add---end------------
   DEFINE l_gemacti        LIKE gem_file.gemacti   #TQC-C60211
   #DEV-D30046 --add--begin
   DEFINE l_oha            RECORD LIKE oha_file.*
   DEFINE l_oah08          LIKE oah_file.oah08 
   #DEV-D30046 --add--end
   
   WHENEVER ERROR CONTINUE 

   LET g_success = 'Y'
   
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01  #DEV-D30046 --add
   
   #TQC-C70003 -- add -- begin
   IF cl_null(l_oha.oha01) THEN 
      CALL cl_err('',-400,1) 
      LET g_success = 'N'
      RETURN 
   END IF
   #TQC-C70003 -- add -- end
   #str--- add---ly1709007---begin
  IF l_oha.oha01[1,3]='XRS'  AND l_oha.oha09<>'5' THEN 
     CALL cl_err('','cxm-035',1)
     LET g_success='N'
     RETURN
   END IF
   

   #單身資料数量为0 单别非‘XRS'不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM ohb_file
    WHERE ohb01=l_oha.oha01 AND ohb12=0
   IF l_cnt>0 and l_oha.oha01[1,3]<>'XRS'  THEN
      CALL cl_err('','cxm-036',1)
      LET g_success = 'N'   
      RETURN
   END IF
    
#str----add---ly170907---end 
 
   #TQC-C60211 -- add -- begin
   SELECT gemacti INTO l_gemacti FROM gem_file
    WHERE gem01 = l_oha.oha15
   IF l_gemacti = 'N' THEN
      CALL cl_err(l_oha.oha15,'asf-472',1)
      LET g_success = 'N'
      RETURN
   END IF
   #TQC-C60211 -- add -- end
   
   #CHI-C30118---add---START
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = l_oha.oha01
   IF l_oha.ohaconf='Y' THEN LET g_success='N' CALl cl_err('','9023',0) RETURN END IF
   IF p_action_choice CLIPPED = "confirm" THEN   #按「確認」時
      IF l_oha.ohamksg='Y'   THEN
         IF l_oha.oha55 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
           #ROLLBACK WORK #CHI-C80009 mark
            RETURN
         END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN 
         LET g_success = 'N' #CHI-C80009 add
        #ROLLBACK WORK #CHI-C80009 mark 
         RETURN 
      END IF
   END IF
   #CHI-C30118---add---END
   
   #TQC-BA0032--begin
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM gen_file WHERE gen01=l_oha.oha14
   IF cl_null(l_cnt) THEN LET l_cnt= 0 END IF 
   IF l_cnt=0 THEN
      CALL cl_err('','aoo-017',1)
      LET g_success = 'N'
      RETURN
   END IF
   #TQC-BA0032--end
   
   #No.FUN-AA0048  --Begin
   DECLARE t700sub_ware_cs CURSOR FOR
    SELECT ohb09 FROM ohb_file
     WHERE ohb01 = l_oha.oha01
   FOREACH t700sub_ware_cs INTO l_ohb09
      IF NOT s_chk_ware(l_ohb09) THEN
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
   #No.FUN-AA0048  --End  
   
   #FUN-C40089---begin
   SELECT oah08 INTO l_oah08 FROM oah_file WHERE oah01=l_oha.oha31
   IF cl_null(l_oah08) THEN
      LET l_oah08 = 'Y'
   END IF  
   IF l_oah08= 'N' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ohb_file
         #WHERE ohb01=g_oga.oga01 AND ohb13=0   #FUN-C50074 mark
         WHERE ohb01=l_oha.oha01 AND ohb13=0    #FUN-C50074

      IF l_cnt > 0 THEN
         CALL cl_err('','axm-627',1)   #FUN-C50074
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #FUN-C40089---end

   #-----MOD-BA0171--------- 
   ##MOD-A10016---add---start---
   # IF l_oha.oha09 = '6' THEN
   #    DECLARE oha09_cs CURSOR FOR
   #     SELECT ohb33,ohb34 FROM ohb_file
   #      WHERE ohb01 = l_oha.oha01
   #    FOREACH oha09_cs INTO l_ohb33,l_ohb34
   #      IF cl_null(l_ohb33) OR cl_null(l_ohb34) THEN
   #         CALL cl_err('','abx-070',1)
   #         LET g_success = 'N'
   #         RETURN
   #      END IF
   #    END FOREACH
   # END IF
   ##MOD-A10016---add---end---
   #-----END MOD-BA0171-----
   
   IF g_azw.azw04='2' THEN
      IF l_oha.oha85='1' THEN
         LET l_ohb14t = 0 
         SELECT SUM(ohb14t) INTO l_ohb14t FROM ohb_file
          WHERE ohb01=l_oha.oha01
         IF cl_null(l_ohb14t) THEN LET l_ohb14t=0 END IF      
         #FUN-AB0061--------------mod----------------str--------------
         #SELECT SUM(ohb67) INTO l_ohb67 FROM ohb_file                                                                      
         # WHERE ohb01=l_oha.oha01                  
         #IF cl_null(l_ohb67) THEN LET l_ohb67=0 END IF                                                                          
         #IF l_oha.oha213='N' THEN                                                                                            
         #   LET l_ohb67=l_ohb67*(1+l_oha.oha211/100)                                                                         
         #   CALL cl_digcut(l_ohb67,t_azi04) RETURNING l_ohb67                                                               
         #END IF                                                                                                                
         #LET l_ohb14t=l_ohb14t-l_ohb67                      
         LET l_ohb14t=l_ohb14t 
         #FUN-AB0061--------------mod----------------end-------------                                                                 
         CALL cl_digcut(l_ohb14t,t_azi04) RETURNING l_ohb14t    
         LET l_rxx04 = 0    
         SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file
          WHERE rxx00='03' AND rxx01=l_oha.oha01 
            AND rxx03='-1' AND rxxplant=l_oha.ohaplant
         IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF
         IF l_ohb14t != l_rxx04 THEN
            CALL cl_err('','art-336',1)
            LET g_success = 'N'
            RETURN
         END IF 
      END IF
   END IF
   
   #無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM ohb_file
    WHERE ohb01=l_oha.oha01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N'   #FUN-580113
      RETURN
   END IF
   
   #FUN-C70098----add----begin--------------
   #&ifdef SLK
   #IF g_azw.azw04 = '2' THEN   #DEV-D30046 --mark
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN   #DEV-D30046 --add
       DECLARE ohbslk04_curs CURSOR FOR
          SELECT ohbslk03,ohbslk04,ohbslk12 FROM ohbslk_file WHERE ohbslk01 = l_oha.oha01 
       CALL s_showmsg_init()
       FOREACH ohbslk04_curs INTO l_ohbslk03,l_ohbslk04,l_ohbslk12
           IF cl_null(l_ohbslk12) OR l_ohbslk12 = 0 THEN
              CALL s_errmsg('', l_oha.oha01 ,l_ohbslk04 ,'asf-230',1)
              LET g_success = 'N'
           END IF
       END FOREACH
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
   END IF
   #&endif
   #FUN-C70098----add----end----------------
   
   # check if 單頭銷退方式='5'折讓且單身數量>0
   IF l_oha.oha09='5' THEN
      DECLARE t700sub_y_ohb12_1 CURSOR FOR
       SELECT ohb12 FROM ohb_file WHERE ohb01 = l_oha.oha01
      FOREACH t700sub_y_ohb12_1 INTO l_ohb12
         IF l_ohb12 > 0 THEN
            CALL cl_err('','axm-992',1)
            LET g_success = 'N'   #FUN-580113
            RETURN
         END IF
      END FOREACH
   ELSE
      DECLARE t700sub_y_ohb12_2 CURSOR FOR
       SELECT ohb12 FROM ohb_file WHERE ohb01 = l_oha.oha01
      FOREACH t700sub_y_ohb12_2 INTO l_ohb12
         IF l_ohb12 = 0 THEN
            CALL cl_err('','axm-607',1)
            LET g_success = 'N'   #FUN-580113
            RETURN
         END IF
      END FOREACH
   END IF
 
   DECLARE t700sub_ohbrvbs CURSOR FOR
   SELECT * FROM ohb_file
    WHERE ohb01=l_oha.oha01
 
   FOREACH t700sub_ohbrvbs INTO l_ohb.*
      #FUN-A40022--begin--add--------
      #IF s_industry('icd') THEN   #FUN-B70061 mark
      IF NOT cl_null(l_ohb.ohb04) THEN
         #FUN-B50096 ---------------Begin-------------------
         #LET l_imaicd13=''
         #SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
         # WHERE imaicd00 = l_ohb.ohb04
         #IF l_imaicd13 = 'Y' AND cl_null(l_ohb.ohb092)THEN
         LET l_ima159 = ''
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = l_ohb.ohb04 
         IF l_ima159 = '1' AND cl_null(l_ohb.ohb092) 
            AND g_oaz.oaz104='Y' THEN 
         #FUN-B50096 ---------------End---------------------
            LET g_success = 'N'
            CALL cl_err(l_ohb.ohb04,'aim-034',1)
            RETURN
         END IF
      END IF
      #END IF   #FUN-B70061 mark
      #FUN-A40022--end--add-------

      LET g_ima918 = ''   #DEV-D30040 add
      LET g_ima921 = ''   #DEV-D30040 add
      LET g_ima930 = ''   #DEV-D30040 add
      SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
        FROM ima_file
       WHERE ima01 = l_ohb.ohb04
         AND imaacti = "Y"
      
      IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = l_ohb.ohb01
            AND rvbs02 = l_ohb.ohb03    
            AND rvbs13 = 0   
           #AND rvbs09 = -1   #TQC-B90236  mark
            AND rvbs09 = 1    #TQC-B90236   add 
      
         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF
         
         #CHI-C30064---Start---add
         SELECT img09 INTO l_img09 FROM img_file
          WHERE img01= l_ohb.ohb04 AND img02= l_ohb.ohb09
            AND img03= l_ohb.ohb091 AND img04= l_ohb.ohb092
         CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_img09) RETURNING l_cnt,l_ohb05_fac
         IF l_cnt = '1' THEN
            LET  l_ohb05_fac = 1
         END IF            
         #CHI-C30064---End---add          
         
         #IF (l_ohb.ohb12 * l_ohb.ohb05_fac) <> l_rvbs06 THEN
         IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040                  
            IF (l_ohb.ohb12 * l_ohb05_fac) <> l_rvbs06 THEN #CHI-C30064
               LET g_success = "N"
               CALL cl_err(l_ohb.ohb04,"aim-011",1)
               RETURN
            END IF
         END IF                                                        #DEV-D30040
      END IF
         
      IF l_oha.oha09 = '4' AND cl_null(l_ohb.ohb31) THEN
         LET g_success = 'N'
         CALL cl_err('','axm-889',1)
         RETURN
      END IF
       
      #-----MOD-A30185---------
      LET l_cnt=0
      IF g_aza.aza50='Y' THEN
         SELECT count(*) INTO l_cnt FROM azf_file
          WHERE azf01=l_ohb.ohb50
            AND azf02='2'     
            AND azfacti='Y'
            AND azf09='2'      
      ELSE
         SELECT count(*) INTO l_cnt FROM azf_file
          WHERE azf01=l_ohb.ohb50
            AND azf02='2'   
            AND azfacti='Y'
      END IF 
      IF l_cnt=0 THEN  
         LET g_success = 'N'
         CALL cl_err('ohb50','axm-777',1)  
         RETURN 
      END IF
      #-----END MOD-A30185-----
   END FOREACH
 
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = l_oha.oha01
   IF l_oha.ohaconf='Y' THEN LET g_success='N' CALl cl_err('','9023',0) RETURN END IF   #FUN-650108
   IF g_oaz.oaz03 = 'Y' AND g_sma.sma53 IS NOT NULL
      AND l_oha.oha02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1)
      LET g_success = 'N'   #FUN-580113
      RETURN
   END IF
 
   IF l_oha.oha01 IS NULL THEN
      CALL cl_err('',-400,1)
      LET g_success = 'N'   #FUN-580113
      RETURN
   END IF
 
   # ---若現行年月大於出貨單/銷退單之年月--不允許確認-----
   CALL s_yp(l_oha.oha02) RETURNING l_yy,l_mm
   IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
       CALL cl_err('','mfg6090',1)  #MOD-790009
       LET g_success = 'N'   #FUN-580113
       RETURN
   END IF
   IF l_oha.ohaconf = 'X' THEN
      CALL cl_err('','9024',1)
      LET g_success = 'N'   #FUN-580113
      RETURN
   END IF
 
   # IF l_oha.oha09 = '1' OR  #darcy:2024/04/23 mark
   # l_oha.oha09 = '4' OR #darcy:2024/01/24 mark
   if l_oha.oha09 = '5' THEN
      DECLARE t700sub_y_price CURSOR FOR
       SELECT ohb03,ohb13 FROM ohb_file WHERE ohb01 = l_oha.oha01
       FOREACH t700sub_y_price INTO l_ohb03,l_ohb13
         IF l_ohb13 = 0 THEN
            CALL cl_err(l_ohb03,'axm-534',1)
            LET g_success = 'N'
            RETURN
         END IF
       END FOREACH
   END IF

   #FUN-BC0081 add begin ---
   DECLARE t700sel_ohb CURSOR FOR
   SELECT * FROM ohb_file
    WHERE ohb01=l_oha.oha01
   INITIALIZE l_ohb.* TO NULL 
   LET g_sql = "SELECT rxe04,rxe05 ",
               "  FROM rxe_file ",
               " WHERE rxe01 = ? ",
               "   AND rxe02 = ? ",
               "   AND rxe00 = '03'"
   PREPARE selrxe_pre FROM g_sql
   DECLARE selrxe_cs CURSOR FOR selrxe_pre
   FOREACH t700sel_ohb INTO l_ohb.*
      SELECT ima154 INTO l_ima154 
        FROM ima_file 
       WHERE ima01 = l_ohb.ohb04
      IF l_ima154 = 'Y' THEN 
         LET l_rxe08 = 0 
         SELECT sum(rxe08) INTO l_rxe08
           FROM rxe_file 
          WHERE rxe00 ='03' 
            AND rxe01 = l_ohb.ohb01
            AND rxe02 = l_ohb.ohb03
         IF cl_null(l_rxe08) THEN
            LET l_rxe08 = 0
         END IF 
         IF l_rxe08 <> l_ohb.ohb12 THEN 
            CALL cl_err(l_ohb.ohb04,'alm1540',1)
            LET g_success = 'N' 
            RETURN
         END IF 
             
      FOREACH selrxe_cs using l_ohb.ohb01,l_ohb.ohb03 INTO l_rxe04,l_rxe05 
         LET l_cnt = 0 
         SELECT COUNT(*) INTO l_cnt
           FROM lqe_file
          WHERE lqe01 BETWEEN l_rxe04 AND l_rxe05
            AND (lqe17 <> '1' OR lqe13 <> l_oha.ohaplant)
         IF l_cnt > 0 THEN
            CALL cl_err('','alm1503',1)
            LET g_success = 'N'
            RETURN
         END IF 
      END FOREACH
     END IF
   END FOREACH     
   #FUN-BC0081 add end ---

   #FUN-C10053 add begin ---  
   IF g_success = 'Y' THEN
      CALL saxmt700sub_ins_ogj(l_oha.*)  #DEV-D30046
      IF g_success = 'N' THEN
         RETURN
      END IF 
   END IF 
   #FUN-C10053 add end ---

  CALL saxmt700sub_y1(l_oha.*)  #FUN-C20116 add  #DEV-D30046

END FUNCTION

##############################################
#作用    : 確認更新
#傳入參數: p_oha01          銷退單號
#          p_action_choice  執行"確認"的按鈕的名稱,若外部呼叫可傳NULL
#          p_inTransaction  若p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#回傳值  : 無
##############################################
FUNCTION saxmt700sub_y_upd(p_oha01,p_argv0,p_action_choice,p_inTransaction)
   DEFINE p_oha01           LIKE oha_file.oha01   #DEV-D30046 --add
   DEFINE p_action_choice   STRING                #DEV-D30046 --add
   DEFINE p_inTransaction   LIKE type_file.num5   #DEV-D30046 --add
   DEFINE p_argv0           LIKE type_file.chr1   #DEV-D30046 --add
   #DEFINE l_oia07          LIKE  oia_file.oia07   #FUN-C50136
   DEFINE l_time            LIKE type_file.chr8    #CHI-C80072
   #DEV-D30046 --add--begin
   DEFINE l_oha             RECORD LIKE oha_file.*
   DEFINE l_flag            LIKE type_file.chr1
   #DEV-D30046 --add--end

   WHENEVER ERROR CONTINUE 

   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01   #DEV-D30046 --add
   
   #CHI-A50004 程式搬移 --start--
   IF NOT p_inTransaction THEN   #DEV-D30046 --add
      BEGIN WORK
   END IF   #DEV-D30046 --add 
 
   CALL saxmt700sub_lock_cl()   #DEV-D30046 --add
   
   OPEN t700sub_cl USING l_oha.oha01
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
      CLOSE t700sub_cl 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK
      END IF   #DEV-D30046 --add 
      RETURN
   END IF
 
   FETCH t700sub_cl INTO l_oha.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
      CLOSE t700sub_cl 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF   #DEV-D30046 --add 
      RETURN
   END IF
   #CHI-A50004 程式搬移 --end--

   LET g_success = 'Y'

   #CHI-C30118---mark---START 移至y_chk最上方
   #IF p_action_choice CLIPPED = "confirm" THEN   #按「確認」時
   #   IF l_oha.ohamksg='Y'   THEN
   #     IF l_oha.oha55 != '1' THEN
   #        CALL cl_err('','aws-078',1)
   #        LET g_success = 'N'
   #        ROLLBACK WORK #CHI-A50004 add
   #        RETURN
   #     END IF
   #   END IF
   #   IF NOT cl_confirm('axm-108') THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK 
   #END IF
   #CHI-C30118---mark---END
  
   #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
   #BEGIN WORK
   # 
   #OPEN t700sub_cl USING l_oha.oha01
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
   #   CLOSE t700sub_cl ROLLBACK WORK RETURN
   #END IF
   #
   #FETCH t700sub_cl INTO l_oha.*
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
   #   CLOSE t700sub_cl ROLLBACK WORK RETURN
   #END IF
   #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--
   
   LET g_success = 'Y'
   
   #FUN-C20116 mod str---
   #CALL saxmt700sub_y1()
   LET g_time=TIME #TQC-B40073
   UPDATE oha_file SET ohaconf = 'Y',
                       ohaconu=g_user,
                       ohacond=g_today
                      ,ohacont=g_time  #TQC-B40073
    WHERE oha01 = l_oha.oha01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oha_file",l_oha.oha01,"",SQLCA.sqlcode,"","upd ohaconf",1)  #No.FUN-650108
      LET g_success = 'N' 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK
      END IF   #DEV-D30046 --add 
      RETURN
   END IF
   #FUN-C20116 mod end---
 
   IF g_success = 'Y' THEN
      IF l_oha.ohamksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET l_oha.ohaconf="N"
                  LET l_oha.ohaconu=''  #No.FUN-870007 
                  LET l_oha.ohacond=''  #No.FUN-870007
                  LET g_success = "N"
                  IF NOT p_inTransaction THEN   #DEV-D30046 --add
                     ROLLBACK WORK
                  END IF   #DEV-D30046 --add 
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET l_oha.ohaconf="N"
                  LET l_oha.ohaconu=''  #No.FUN-870007
                  LET l_oha.ohacond=''  #No.FUN-870007
                  IF NOT p_inTransaction THEN   #DEV-D30046 --add
                     ROLLBACK WORK
                  END IF   #DEV-D30046 --add 
                  RETURN
         END CASE
      END IF
 
      LET l_oha.oha55='1'           #執行成功, 狀態值顯示為 '1' 已核准
      UPDATE oha_file SET oha55 = l_oha.oha55 WHERE oha01=l_oha.oha01
      IF SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
      END IF
      LET l_oha.ohaconf='Y'         #執行成功, 確認碼顯示為 'Y' 已確認
      #DEV-D30046 --mark--begin 
      #DISPLAY BY NAME l_oha.ohaconf
      #DISPLAY BY NAME l_oha.oha55
      #DEV-D30046 --mark--end 
 
      IF g_azw.azw04='2' THEN
         LET l_time = TIME    #CHI-C80072
         LET l_oha.ohaconu=g_user
         LET l_oha.ohacond=g_today
         #DISPLAY BY NAME l_oha.ohaconu,l_oha.ohacond   #DEV-D30046 --mark
        #TQC-B40073 Begin---
       # LET l_oha.ohacont=TIME    #CHI-C80072 mark
         LET l_oha.ohacont=l_time  #CHI-C80072 add
         SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=l_oha.ohaconu
         #DEV-D30046 --mark--begin 
         #DISPLAY BY NAME l_oha.ohacont
         #DISPLAY g_buf TO ohaconu_desc
         #DEV-D30046 --mark--end 
        #TQC-B40073 End-----
      END IF
 
      IF l_oha.ohamksg = 'Y' AND l_oha.oha55 = 'N' THEN
         IF g_success = 'N' THEN
            IF NOT p_inTransaction THEN   #DEV-D30046 --add
               ROLLBACK WORK
            END IF   #DEV-D30046 --add 
            RETURN
         END IF
      END IF
      CALL saxmt700sub_chstatus('Y',l_oha.oha01)   #DEV-D30046 
      CALL s_showmsg()   #No.FUN-710028
      ##FUN-C50136-add-str--
      #IF g_oaz.oaz96 ='Y' THEN 
      #   CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
      #   IF l_oia07 = '0' THEN
      #      CALL s_ccc_oia(l_oha.oha03,'G',l_oha.oha01,0,'')
      #   END IF         
      #END IF
      ##FUN-C50136-add-end--
      IF g_success = 'Y' THEN   #TQC-930155 add
         IF NOT p_inTransaction THEN   #DEV-D30046 --add
            COMMIT WORK
         END IF   #DEV-D30046 --add 
      ELSE
         IF NOT p_inTransaction THEN   #DEV-D30046 --add
            ROLLBACK WORK
         END IF   #DEV-D30046 --add 
         RETURN
      END IF
 
      CALL cl_flow_notify(l_oha.oha01,'Y')
 
      #DISPLAY BY NAME l_oha.ohaconf   #DEV-D30046 --mark
      # '5.折讓'自動做扣帳
      IF l_oha.oha09 = '5' THEN
         CALL saxmt700sub_s('1',p_argv0,l_oha.oha01,p_inTransaction)  #DEV-D30046
      ELSE
         IF g_oaz.oaz61 MATCHES "[12]" THEN
            #FUN-BA0014 add str---
            #同時具有自動確認和簽核的功能時的判斷
            #銷退單確認時,庫存扣帳方式若為'2:立刻扣帳(會詢問)',一律默認為'1:立刻扣帳(不詢問)'
            IF p_action_choice = 'efconfirm' THEN
               CALL saxmt700sub_s('1',p_argv0,l_oha.oha01,p_inTransaction)  #DEV-D30046
            ELSE
            #FUN-BA0014 add end---
            CALL saxmt700sub_s(g_oaz.oaz61,p_argv0,l_oha.oha01,p_inTransaction)  #DEV-D30046
            END IF #FUN-BA0014 add
         END IF
      END IF
      #no.7204(end)
   ELSE
      LET l_oha.ohaconf='N'
      LET l_time = TIME      #CHI-C80072
      #DISPLAY BY NAME l_oha.ohaconf   #DEV-D30046 --mark
      IF g_azw.azw04='2' THEN
         #CHI-C80072--str--
         #LET l_oha.ohaconu=''
         #LET l_oha.ohacond=''
         #LET l_oha.ohacont=''          #TQC-B40073
         #DISPLAY BY NAME l_oha.ohaconu,l_oha.ohacond
         #DISPLAY BY NAME l_oha.ohacont #TQC-B40073
         #DISPLAY ' ' TO ohaconu_desc    #TQC-B40073
         LET l_oha.ohaconu = g_user
         LET l_oha.ohacond = g_today
         LET l_oha.ohacont = l_time
         #DEV-D30046 --mark--begin
         #DISPLAY BY NAME l_oha.ohaconu,l_oha.ohacond   
         #DISPLAY BY NAME l_oha.ohacont
         #DEV-D30046 --mark--end
         SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=l_oha.ohaconu
         #DEV-D30046 --mark--begin
         #DISPLAY BY NAME l_oha.ohacont
         #DISPLAY g_buf TO ohaconu_desc
         #DEV-D30046 --mark--end
         #CHI-C80072--end
      END IF
      CALL s_showmsg()   #No.FUN-710028
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK
      END IF   #DEV-D30046 --add 
   END IF
 
   IF g_success = 'Y' AND g_oaz.oaz63='Y' AND 
     (l_oha.oha09 MATCHES '[1,4,5]') THEN #FUN-640264
      LET l_flag = 'Y'   #MOD-BB0151
      CALL saxmt700sub_CN(l_oha.oha01,l_flag)
   END IF
 
END FUNCTION

##############################################
#作用    : 過帳
#傳入參數: p_cmd            開窗詢問是否過帳 1.不詢問 2.要詢問
#          p_argv0
#          p_oha01          銷退單號
#          p_inTransaction  若p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#回傳值  : 無
##############################################
FUNCTION saxmt700sub_s(p_cmd,p_argv0,p_oha01,p_inTransaction) 			# when l_oha.ohapost='N' (Turn to 'Y')
   DEFINE p_cmd		  LIKE type_file.chr1  # 1.不詢問 2.要詢問        #No.FUN-680137 VARCHAR(1)
   DEFINE p_argv0         LIKE type_file.chr1  #DEV-D30046 --add
   DEFINE p_oha01         LIKE oha_file.oha01  #DEV-D30046 --add
   DEFINE p_inTransaction LIKE type_file.num5  #DEV-D30046 --add
   DEFINE l_sum007        LIKE tsa_file.tsa07,
          l_sum005        LIKE tsa_file.tsa05,
          l_ohb04         LIKE ohb_file.ohb04,
          l_ohb1002       LIKE ohb_file.ohb1002,
          l_ohb12         LIKE ohb_file.ohb12,
          l_ohb14         LIKE ohb_file.ohb14,
          l_ohb14t        LIKE ohb_file.ohb14t,
          l_tqy02         LIKE tqy_file.tqy02,
          l_oay11         LIKE oay_file.oay11,
          l_tqz02         LIKE tqz_file.tqz02
   DEFINE l_imm03         LIKE imm_file.imm03   #No.FUN-740016
   DEFINE m_ohb12         LIKE ohb_file.ohb12   #No.FUN-740016
   DEFINE m_ohb61         LIKE ohb_file.ohb61   #No.FUN-740016
   DEFINE m_ohb04         LIKE ohb_file.ohb04   #No.FUN-740016
   DEFINE m_ohb01         LIKE ohb_file.ohb01   #No.FUN-740016
   DEFINE m_ohb03         LIKE ohb_file.ohb03   #No.FUN-740016
   DEFINE m_ohb31         LIKE ohb_file.ohb31   #No.FUN-A20038
   DEFINE m_ohb32         LIKE ohb_file.ohb32   #No.FUN-A20038
   DEFINE m_qcs091c       LIKE qcs_file.qcs091  #No.FUN-740016
   DEFINE l_sql           STRING                #No.FUN-740016
   #DEFINE l_imaicd04      LIKE imaicd_file.imaicd04 #NO.FUN-7B0015 #FUN-BA0051 mark
   #DEFINE l_imaicd08      LIKE imaicd_file.imaicd08 #NO.FUN-7B0015 #FUN-BA0051 mark 
   DEFINE l_flag          LIKE type_file.num10      #NO.FUN-7B0015 
   DEFINE l_ohb           RECORD LIKE ohb_file.*
   DEFINE l_tot           LIKE oeb_file.oeb25
   DEFINE l_tot1          LIKE oeb_file.oeb26    #No.CHI-8B0046
   DEFINE l_ocn03         LIKE ocn_file.ocn03
   DEFINE l_ocn04         LIKE ocn_file.ocn04
   DEFINE lj_result       LIKE type_file.chr1    #No.FUN-930108
   DEFINE l_ohg           RECORD LIKE ohb_file.* #FUN-BC0081 
   DEFINE l_rxe04         LIKE rxe_file.rxe04    #FUN-BC0081
   DEFINE l_rxe05         LIKE rxe_file.rxe05    #FUN-BC0081
   DEFINE l_rxe08         LIKE rxe_file.rxe08    #FUN-BC0081
   DEFINE l_ima154        LIKE ima_file.ima154   #FUN-BC0081
   DEFINE l_cnt           LIKE type_file.num5    #FUN-BC0081
   DEFINE l_lpj12         LIKE lpj_file.lpj12    #FUN-BA0069 add
   DEFINE max_lsm05       LIKE lsm_file.lsm05    #FUN-BA0069 add
   DEFINE l_t1            LIKE oay_file.oayslip  #MOD-C20142 add
   #DEFINE l_oia07         LIKE oia_file.oia07    #FUN-C50136
   DEFINE l_cnt_img       LIKE type_file.num5     #FUN-C70087
   DEFINE l_cnt_imgg      LIKE type_file.num5     #FUN-C70087
   DEFINE l_fg            LIKE type_file.chr1     #FUN-C70087
   DEFINE l_sum_ohb14t    LIKE ohb_file.ohb14t    #FUN-C80110 add
   DEFINE l_oea61         LIKE oea_file.oea61  #CHI-C90032 add
   DEFINE l_poz           RECORD LIKE poz_file.*   #DEV-D30046 --add
   DEFINE l_flow          LIKE poz_file.poz01      #DEV-D30046 --add
   DEFINE l_oha           RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_rxx04_point   LIKE rxx_file.rxx04      #DEV-D30046 --add
   #2021113001 add----begin----
   DEFINE l_ret        RECORD
             success   LIKE type_file.chr1,
             code      LIKE type_file.chr10,
             msg       STRING
                       END RECORD
   #2021113001 add----end----
   
   WHENEVER ERROR CONTINUE 
   
   LET g_success = 'Y'   #MOD-BB0204 add
  
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01
   
   IF l_oha.oha01 IS NULL THEN CALL cl_err('',-400,1) RETURN END IF 
   IF l_oha.ohaconf='N' THEN CALL cl_err('conf=N','axm-154',1) RETURN END IF 
   IF l_oha.ohapost='Y' THEN RETURN END IF 
   IF l_oha.ohaconf = 'X' THEN CALL cl_err('','9024',1) RETURN END IF 

      
   #CHI-A50004 程式搬移 --start--
   IF NOT p_inTransaction THEN   #DEV-D30046 --add
      BEGIN WORK
   END IF    #DEV-D30046 --add

   CALL saxmt700sub_lock_cl()   #DEV-D30046 --add
   
   OPEN t700sub_cl USING l_oha.oha01
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
      CLOSE t700sub_cl 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK
      END IF    #DEV-D30046 --add
      RETURN
   END IF
 
   FETCH t700sub_cl INTO l_oha.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
      CLOSE t700sub_cl 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF    #DEV-D30046 --add
      RETURN
   END IF
   #CHI-A50004 程式搬移 --end--
  
   DECLARE ohb_s_c CURSOR FOR 
      SELECT * FROM ohb_file WHERE ohb01 = l_oha.oha01
   
   CALL s_showmsg_init()

   #FUN-BC0081 add begin ---
   LET g_sql = "SELECT rxe04,rxe05 ",
               "  FROM rxe_file ",
               " WHERE rxe01 = ? ",
               "   AND rxe02 = ? ",
               "   AND rxe00 = '03'"
   PREPARE selrxe_pre_1 FROM g_sql
   DECLARE selrxe_cs_1 CURSOR FOR selrxe_pre_1
   #FUN-BC0081 add end --- 
   
   FOREACH ohb_s_c INTO l_ohb.*
      IF p_argv0 = '1' THEN
         CALL s_incchk(l_ohb.ohb09,l_ohb.ohb091,g_user)
              RETURNING lj_result
         IF NOT lj_result THEN
            LET g_success = 'N'
            LET g_showmsg = l_ohb.ohb03,"/",l_ohb.ohb09,"/",l_ohb.ohb091,"/",g_user
            CALL s_errmsg('ohb03,ohb09,ohb091,inc03',g_showmsg,'','asf-888',1)
         END IF
      END IF
      
      #FUN-BC0081 add begin ---
      SELECT ima154 INTO l_ima154
        FROM ima_file
       WHERE ima01 = l_ohb.ohb04
      IF l_ima154 = 'Y' THEN
         SELECT sum(rxe08) INTO l_rxe08
           FROM rxe_file
          WHERE rxe00 ='03'
            AND rxe01 = l_ohb.ohb01
            AND rxe02 = l_ohb.ohb03
         IF cl_null(l_rxe08) THEN
            LET l_rxe08 = 0
         END IF
         IF l_rxe08 <> l_ohb.ohb12 THEN
            CALL cl_err(l_ohb.ohb04,'alm1540',1)
            LET g_success = 'N'
            IF NOT p_inTransaction THEN   #DEV-D30046 --add
               ROLLBACK WORK
            END IF   #DEV-D30046 --add
            RETURN
         END IF
      END IF
      FOREACH selrxe_cs_1 using l_ohb.ohb01,l_ohb.ohb03 INTO l_rxe04,l_rxe05
         SELECT COUNT(*) INTO l_cnt
           FROM lqe_file
          WHERE lqe01 BETWEEN l_rxe04 AND l_rxe05
            AND (lqe17 <> '1' OR lqe13 <> l_oha.ohaplant)
         IF l_cnt > 0 THEN
            CALL cl_err('','alm1503',1)
            LET g_success = 'N'
            IF NOT p_inTransaction THEN   #DEV-D30046 --add
               ROLLBACK WORK
            END IF   #DEV-D30046 --add
            RETURN
         END IF
      END FOREACH
      #FUN-BC0081 add end ---
   END FOREACH
  
   CALL s_showmsg()
   IF g_success = 'N' THEN         
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK #CHI-A50004 add
      END IF   #DEV-D30046 --add
      RETURN
   END IF
   
   #FUN-BC0081 begin ---
   LET l_sql = "SELECT rxe04,rxe05 FROM rxe_file ",
               " WHERE rxe00 = '03' ",
               "   AND rxe01 = ? AND rxe02 = ? "
   PREPARE sel_rxe_p FROM l_sql 
   DECLARE sel_rxe_c CURSOR FOR sel_rxe_p
   CALL s_showmsg_init()
   FOREACH ohb_s_c INTO l_ohg.*
      SELECT ima154 INTO l_ima154
        FROM ima_file 
       WHERE ima01 = l_ohg.ohb04
       IF l_ima154 ='Y' THEN 
          FOREACH sel_rxe_c USING l_ohg.ohb01,l_ohg.ohb03 INTO l_rxe04,l_rxe05
             SELECT COUNT(*) INTO l_cnt
               FROM lqe_file
              WHERE lqe01 BETWEEN l_rxe04 AND l_rxe05
                AND (lqe17 <> '1' OR lqe13 <> l_oha.ohaplant)
             IF l_cnt > 0 THEN
                CALL cl_err('','alm1503',1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             UPDATE lqe_file SET lqe09 = l_oha.ohaplant,
                                 lqe10 = l_oha.oha02,
                                 lqe17 = '2'
              WHERE lqe01 >= l_rxe04
                AND lqe01 <= l_rxe05 
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL s_errmsg("lqe09,lqe10,lqe17",SQLCA.sqlcode,"","",1)
                LET g_success = 'N'
             END IF
          END FOREACH              
       END IF  
   END FOREACH 
   CALL s_showmsg()
    
   IF g_success = 'N' THEN         
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF   #DEV-D30046 --add
      RETURN
   END IF   
   #FUN-BC0081 end --- 
 
   IF l_oha.oha02 <= g_oaz.oaz09 THEN
      CALL cl_err('','axm-273',1) 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF   #DEV-D30046 --add
      RETURN #CHI-A50004 add ROLLBACK WORK
   END IF
   IF g_oaz.oaz03 = 'Y' AND
      g_sma.sma53 IS NOT NULL AND l_oha.oha02 <= g_sma.sma53 THEN
      CALL cl_err('','axm-273',1) 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF   #DEV-D30046 --add
      RETURN #CHI-A50004 add ROLLBACK WORK
   END IF
 
   IF p_cmd='2' THEN 
      IF NOT cl_confirm('axm-152') THEN 
         IF NOT p_inTransaction THEN   #DEV-D30046 --add
            ROLLBACK WORK 
         END IF   #DEV-D30046 --add
         RETURN 
      END IF 
   END IF  #MOD-490169在詢問是否庫存過帳之前,先做銷退日期與關帳日期的判斷 #CHI-A50004 add ROLLBACK WORK

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095

  #DEV-D40015 add str--------
  #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
  #IF g_aza.aza131 = 'Y' AND (g_prog = 'apmt110' or g_prog = 'apmt720') THEN  #DEV-D40018 mark
   IF g_aza.aza131 = 'Y' AND (g_prog = 'axmt700') THEN                        #DEV-D40018 add
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT ohb04 FROM ohb_file WHERE ohb01 = l_oha.oha01) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
	
     #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('post','tlfb',l_oha.oha01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #DEV-D40015 add end--------
   
   DECLARE t700sub_s_c1 CURSOR FOR SELECT * FROM ohb_file
     WHERE ohb01 = l_oha.oha01

   FOREACH t700sub_s_c1 INTO l_ohb.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = l_ohb.ohb04
         AND img02 = l_ohb.ohb09
         AND img03 = l_ohb.ohb091
         AND img04 = l_ohb.ohb092
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_oha.oha01,l_ohb.ohb03,l_oha.oha02,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_oha.oha01,l_ohb.ohb03,l_oha.oha02) #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_ohb.ohb04,l_ohb.ohb09,
                       l_ohb.ohb091,l_ohb.ohb092,
                       l_ohb.ohb910) RETURNING l_fg
       IF l_fg = 1 THEN
          #CALL s_padd_imgg_data(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb910,l_oha.oha01,l_ohb.ohb03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb910,l_oha.oha01,l_ohb.ohb03) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_ohb.ohb04,l_ohb.ohb09,
                       l_ohb.ohb091,l_ohb.ohb092,
                       l_ohb.ohb913) RETURNING l_fg
       IF l_fg = 1 THEN
          #CALL s_padd_imgg_data(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb913,l_oha.oha01,l_ohb.ohb03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb913,l_oha.oha01,l_ohb.ohb03) #FUN-CC0095
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
   #            " FROM ",l_imgg_table CLIPPED  #,g_cr_db_str
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
               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF #FUN-CC0095  
      ELSE
         #CALL s_padd_img_del(l_img_table) #FUN-CC0095
         #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table) #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
   #FUN-C70087---end
   
   #LET l_sql = " SELECT ohb12,ohb61,ohb04,ohb01,ohb03 FROM ohb_file ",           #No.FUN-A20038
   #LET l_sql = " SELECT ohb12,ohb61,ohb04,ohb01,ohb31,ohb32 FROM ohb_file ",     #No.FUN-A20038
   LET l_sql = " SELECT ohb12,ohb61,ohb04,ohb01,ohb03 FROM ohb_file ",           #No.MOD-BB0202
               "  WHERE ohb01 = '",l_oha.oha01,"'"
  
   PREPARE t700sub_curs1 FROM l_sql
   DECLARE t700sub_pre1 CURSOR FOR t700sub_curs1
  
   #FOREACH t700sub_pre1 INTO m_ohb12,m_ohb61,m_ohb04,m_ohb01,m_ohb03                #No.FUN-A20038
   #FOREACH t700sub_pre1 INTO m_ohb12,m_ohb61,m_ohb04,m_ohb01,m_ohb31,m_ohb32        #No.FUN-A20038
   FOREACH t700sub_pre1 INTO m_ohb12,m_ohb61,m_ohb04,m_ohb01,m_ohb03                #No.MOD-BB0202
      IF m_ohb61 = 'Y' THEN
         LET m_qcs091c = 0
         SELECT SUM(qcs091) INTO m_qcs091c
           FROM qcs_file
         #WHERE qcs01 = m_ohb01                                                  #No.FUN-A20038
         #WHERE qcs01 = m_ohb31                                                  #No.FUN-A20038
          WHERE qcs01 = m_ohb01                                                  #No.MOD-BB0202
           #AND qcs02 = m_ohb03                                                  #No.FUN-A20038
           #AND qcs02 = m_ohb32                                                  #No.FUN-A20038
            AND qcs02 = m_ohb03                                                  #No.MOD-BB0202
            AND qcs14 = 'Y'
 
         IF m_qcs091c IS NULL THEN
            LET m_qcs091c = 0
         END IF
 
         IF m_ohb12 > m_qcs091c THEN
            CALL cl_err(m_ohb04,'mfg3558',1)
            IF NOT p_inTransaction THEN   #DEV-D30046 --add
               ROLLBACK WORK #CHI-A50004 add
            END IF   #DEV-D30046 --add
            RETURN
         END IF
      END IF
   END FOREACH
 
   IF l_oha.oha09 = "6" THEN
      #MOD-D10185 add start -----
      SELECT COUNT(*) INTO l_cnt FROM ohb_file WHERE ohb01 = l_oha.oha01 AND ohb04 NOT LIKE 'MISC%'
      IF l_cnt > 0 THEN
      #MOD-D10185 add end   -----
         CALL saxmt700sub_imm(l_oha.oha01,p_inTransaction) RETURNING l_oha.oha56
         IF cl_null(l_oha.oha56) THEN
            CALL cl_err ("","abm-020",1)
            IF NOT p_inTransaction THEN   #DEV-D30046 --add
               ROLLBACK WORK #CHI-A50004 add
            END IF   #DEV-D30046 --add
            RETURN
         END IF
 
         SELECT imm03 INTO l_imm03 FROM imm_file
          WHERE imm01=l_oha.oha56
         IF l_imm03 = "Y" THEN
            LET l_oha.ohapost='Y'
            DECLARE ohb_c CURSOR FOR 
              SELECT * FROM ohb_file WHERE ohb01 = l_oha.oha01
            FOREACH ohb_c INTO l_ohb.*
               IF p_argv0 = '1' THEN
                  CALL s_incchk(l_ohb.ohb09,l_ohb.ohb091,g_user)
                     RETURNING lj_result
                  IF NOT lj_result THEN
                     CALL cl_err('oha01','axm-399',1)
                     IF NOT p_inTransaction THEN   #DEV-D30046 --add
                        ROLLBACK WORK #CHI-A50004 add
                     END IF   #DEV-D30046 --add
                     RETURN
                  END IF
               END IF
               IF NOT cl_null(l_ohb.ohb33) AND NOT cl_null(l_ohb.ohb34) THEN   #MOD-BA0171
                  SELECT oeb25,oeb26 INTO l_tot,l_tot1 FROM oeb_file    #No.CHI-8B0046
                   WHERE oeb01 = l_ohb.ohb33
                     AND oeb03 = l_ohb.ohb34
               
                  LET l_tot = l_tot+l_ohb.ohb12
                  LET l_tot1 = l_tot1+l_ohb.ohb12   #No.CHI-8B0046
               
                  UPDATE oeb_file SET oeb25=l_tot,
                                      oeb26=l_tot1   #No.CHI-8B0046
                   WHERE oeb01 = l_ohb.ohb33
                     AND oeb03 = l_ohb.ohb34
               END IF   #MOD-BA0171
               LET l_oea61 = l_oha.oha24*l_ohb.ohb14   #CHI-C90032 add
               CALL cl_digcut(l_oea61,g_azi04) RETURNING l_oea61     #CHI-C90032 add

               SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
                WHERE ocn01 = l_oha.oha14
               
              #LET l_ocn03 = l_ocn03-(l_oha.oha24*l_ohb.ohb14)  #CHI-C90032 mark
              #LET l_ocn04 = l_ocn04+(l_oha.oha24*l_ohb.ohb14)  #CHI-C90032 mark
               LET l_ocn03 = l_ocn03-l_oea61                    #CHI-C90032 add
               LET l_ocn04 = l_ocn04+l_oea61                    #CHI-C90032 add
               
               UPDATE ocn_file SET ocn03 = l_ocn03,
                                   ocn04 = l_ocn04
                WHERE ocn01 = l_oha.oha14
            END FOREACH
         ELSE
            LET l_oha.ohapost='N'
            DELETE FROM imm_file WHERE imm01=l_oha.oha56
            DELETE FROM imn_file WHERE imn01=l_oha.oha56
            LET l_oha.oha56 = ''#FUN-C10053
            IF l_imm03="A" THEN
               CALL cl_err ("","abm-020",1)
            END IF    
         END IF    
         UPDATE oha_file SET ohapost=l_oha.ohapost,
                             oha56 = l_oha.oha56
          WHERE oha01=l_oha.oha01
         #DISPLAY BY NAME l_oha.ohapost,l_oha.oha56   #DEV-D30046 --mark
         IF NOT p_inTransaction THEN   #DEV-D30046 --add
            ROLLBACK WORK #CHI-A50004 add
         END IF   #DEV-D30046 --add
         RETURN
      #MOD-D10185 add start -----
      ELSE
         LET l_oha.ohapost='Y'
         DECLARE ohb_d CURSOR FOR SELECT * FROM ohb_file WHERE ohb01 = l_oha.oha01
         FOREACH ohb_d INTO l_ohb.*
            IF NOT cl_null(l_ohb.ohb33) AND NOT cl_null(l_ohb.ohb34) THEN
               SELECT oeb25,oeb26 INTO l_tot,l_tot1 FROM oeb_file
                WHERE oeb01 = l_ohb.ohb33
                  AND oeb03 = l_ohb.ohb34

               LET l_tot = l_tot+l_ohb.ohb12
               LET l_tot1 = l_tot1+l_ohb.ohb12

               UPDATE oeb_file SET oeb25=l_tot, oeb26=l_tot1
                WHERE oeb01 = l_ohb.ohb33 AND oeb03 = l_ohb.ohb34
            END IF

            UPDATE oha_file SET ohapost = l_oha.ohapost
             WHERE oha01 = l_oha.oha01
         END FOREACH
      END IF
      #MOD-D10185 add end  -----
   END IF
 
   #CHI-C80009---mark---START-->>把銷退單拋轉的動作移至過帳後
   #IF l_oha.oha41  ='Y' THEN
   #   IF t700sub_chkpoz() THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add ROLLBACK WORK
   #   #若銷售多角且正拋，則直接拋轉不異動庫存-->#CHI-C80009 應可直接扣庫存帳
   #   IF p_argv0 = '2' AND l_poz.poz011 = '1' THEN
   #      IF g_oax.oax07 = 'Y' THEN        #FUN-670007 
   #          ROLLBACK WORK   #MOD-C20079 add
   #          CALL saxmt700sub_muticarry(l_oha.*,l_poz.*)
   #          CALL t700_chspic()
   #         #ROLLBACK WORK #CHI-A50004 add  #MOD-C20079 mark
   #          RETURN
   #      END IF                          #FUN-670007
   #   END IF
   #END IF
   #CHI-C80009---mark-----END
 
   #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
   #BEGIN WORK
   # 
   #OPEN t700sub_cl USING l_oha.oha01
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
   #   CLOSE t700sub_cl ROLLBACK WORK RETURN
   #END IF
   #
   #FETCH t700sub_cl INTO l_oha.*
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
   #   CLOSE t700sub_cl ROLLBACK WORK RETURN
   #END IF
   #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--
   #LET g_success = 'Y'   #MOD-BB0204 mark
 
 
   UPDATE oha_file SET ohapost='Y' WHERE oha01=l_oha.oha01
 
   CALL saxmt700sub_s1(l_oha.oha01)

   IF sqlca.sqlcode THEN LET g_success='N' END IF
   #FUN-B40098 Begin---
   IF g_success = 'Y' AND g_azw.azw04 = '2' THEN
      CALL t620sub1_post('2',l_oha.oha01)
   END IF
   #FUN-B40098 End-----
   
   #FUN-BA0069 ----------------STA
   #FUN-BB0024 add begin ---
   LET l_rxx04_point = 0
   SELECT SUM(rxy23) INTO l_rxx04_point
     FROM rxy_file
    WHERE rxy00 = '03'
      AND rxy01 = l_oha.oha01
      AND rxy03 = '09'
      AND rxyplant = l_oha.ohaplant
   IF cl_null(l_rxx04_point) THEN
      LET l_rxx04_point = 0
   END IF
   #FUN-BB0024 add end ---

   IF g_success = 'Y' AND g_azw.azw04 = '2' AND l_oha.oha94 = 'N' AND NOT cl_null(l_oha.oha87)  THEN
      SELECT COALESCE(lpj12,0) INTO l_lpj12 FROM lpj_file WHERE lpj03 = l_oha.oha87
      IF l_lpj12 < l_oha.oha95 THEN
         CALL cl_err('','axm-498',1)
         LET g_success = 'N'
         RETURN
      END IF
      
      #FUN-BB0024 add begin ---
      IF NOT cl_null(l_rxx04_point) AND l_rxx04_point > 0 THEN
         #FUN-C30176 mark START
         #INSERT INTO lsm_file VALUES(l_oha.oha87,'A',l_oha.oha01,l_rxx04_point,l_oha.oha02,'','',
         #                            0,l_oha.ohalegal,l_oha.ohaplant)
         #FUN-C30176 mark END
         #FUN-C30176 add START
         #INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmplant,lsm15)        #FUN-C70045 add lsm15   #FUN-C90102 mark
          INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmstore,lsm15)        #FUN-C90102 add 
          #            VALUES(l_oha.oha87,'A',l_oha.oha01,l_rxx04_point,l_oha.oha02,'','',                #TQC-C80119 mark
                       VALUES(l_oha.oha87,'A',l_oha.oha01,l_rxx04_point,l_oha.oha02,'',                   #TQC-C80119 add
                                      0,l_oha.ohalegal,l_oha.ohaplant,'1')                                #FUN-C70045 add '1'
         #FUN-C30176 add END
         IF sqlca.sqlcode THEN
            LET g_success='N'
            CALL cl_err3("ins","lsm_file",l_oha.oha87,"",SQLCA.sqlcode,"","",1)
            IF NOT p_inTransaction THEN   #DEV-D30046 --add
               ROLLBACK WORK
            END IF   #DEV-D30046 --add
            RETURN
         END IF
      END IF
      #FUN-BB0024 add end ---
       
      #FUN-C30176 mark START
      #INSERT INTO lsm_file VALUES(l_oha.oha87,'8',l_oha.oha01,l_oha.oha95*(-1),l_oha.oha02,'',''
      #                            ,l_oha.oha1008*(-1),l_oha.ohalegal,l_oha.ohaplant)
      #FUN-C30176 mark END
      #FUN-C30176 mark START
      #INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmplant,lsm15)              #FUN-C70045 add lsm15   #FUN-C90102 mark 
       INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmstore,lsm15)              #FUN-C90102 add
       #            VALUES(l_oha.oha87,'8',l_oha.oha01,l_oha.oha95*(-1),l_oha.oha02,'',''                    #TQC-C80119 mark
                    VALUES(l_oha.oha87,'8',l_oha.oha01,l_oha.oha95*(-1),l_oha.oha02,''                       #TQC-C80119 add  
                                   ,l_oha.oha1008*(-1),l_oha.ohalegal,l_oha.ohaplant,'1')                    #FUN-C70045 add '1'
      #FUN-C30176 mark END
 
      IF sqlca.sqlcode THEN
         LET g_success='N'
         CALL cl_err3("ins","lsm_file",l_oha.oha87,"",SQLCA.sqlcode,"","",1)
         IF NOT p_inTransaction THEN   #DEV-D30046 --add
            ROLLBACK WORK
         END IF   #DEV-D30046 --add
         RETURN
      END IF
      #SELECT MAX(lsm05) INTO max_lsm05 FROM lsm_file WHERE lsm01 = l_oha.oha87 AND lsm02 IN ('1', '5', '6', '7', '8')  #FUN-C70045 mark
      SELECT MAX(lsm05) INTO max_lsm05 FROM lsm_file WHERE lsm01 = l_oha.oha87 AND lsm02 IN ('2', '3', '7', '8')        #FUN-C70045 add
      
      #FUN-C80110 add begin ---
      LET l_sum_ohb14t = 0  
      SELECT SUM(ohb14t)
        INTO l_sum_ohb14t
        FROM ohb_file
       WHERE ohb01 = l_oha.oha01
      IF cl_null(l_sum_ohb14t) THEN
         LET l_sum_ohb14t = 0
      END IF 
      #FUN-C80110 add end -----
      
      UPDATE lpj_file SET lpj07 = COALESCE(lpj07,0) +1,
                          lpj08 = max_lsm05,
                         #lpj12 = COALESCE(lpj12,0) - l_oha.oha95,                   #FUN-BB0024 mark
                          lpj12 = COALESCE(lpj12,0) - l_oha.oha95 + l_rxx04_point,   #FUN-BB0024 add
                          lpj13 = COALESCE(lpj13,0) - l_rxx04_point,                 #FUN-BB0024 add
                          lpj14 = COALESCE(lpj14,0) - l_oha.oha95,
                         #lpj15 = COALESCE(lpj15,0) - l_oha.oha1008                  #FUN-C80110 mark
                          lpj15 = COALESCE(lpj15,0) - l_sum_ohb14t,                  #FUN-C80110 add
                          lpjpos = '2'                                               #FUN-D30007 add
       WHERE lpj03 = l_oha.oha87
      IF sqlca.sqlcode THEN
         LET g_success='N'
         CALL cl_err('',sqlca.sqlcode,0)
         CALL cl_err3("upd","lpj_file",l_oha.oha87,"",SQLCA.sqlcode,"","",1)
         IF NOT p_inTransaction THEN   #DEV-D30046 --add
            ROLLBACK WORK
         END IF   #DEV-D30046 --add
         RETURN
      END IF
   END IF
   #FUN-BA0069 ----------------END
   
   CALL s_showmsg()   #No.FUN-710028
   
   ##FUN-C50136-add-str--
   #IF g_oaz.oaz96 = 'Y' THEN 
   #   CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
   #   IF l_oia07 = '1' THEN
   #      CALL s_ccc_oia(l_oha.oha03,'G',l_oha.oha01,0,'')
   #   END IF      
   #END IF 
   ##FUN-C50136-add-end--
   
   IF g_success = 'Y' THEN
      LET l_oha.ohapost='Y'
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         COMMIT WORK
      END IF   #DEV-D30046 --add
      IF l_oha.oha05='4'  THEN
         CALL cl_err(g_oga01,'atm-262',1)
         SELECT oha1015,oha1018 INTO l_oha.oha1015,l_oha.oha1018
           FROM oha_file
          WHERE oha01 = l_oha.oha01
         #DISPLAY BY NAME l_oha.oha1015,l_oha.oha1018  #DEV-D30046 --mark
      END IF
      CALL cl_flow_notify(l_oha.oha01,'S')
      #DISPLAY BY NAME l_oha.ohapost  #DEV-D30046 --mark
      #2021113001 add----begin----
      IF NOT cl_null(l_oha.oha01)  AND cl_getscmparameter() THEN
        INITIALIZE l_ret TO NULL
        CALL cjc_zmx_json_task('ST1',l_oha.oha01) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN

        ELSE
          IF cl_null(l_ret.msg) THEN
            LET l_ret.msg = "销退单(",l_oha.oha01 CLIPPED,")同步失败"
          END IF
          CALL cl_err(l_ret.msg,'!',1)
        END IF
      END IF
      #2021113001 add----end----
   ELSE
      LET l_oha.ohapost='N'
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK
      END IF   #DEV-D30046 --add
      #DISPLAY BY NAME l_oha.ohapost  #DEV-D30046 --mark
   END IF
   
   IF g_aza.aza50='Y' THEN
     #IF g_success='Y' AND g_oaz.oaz62='Y' THEN    #MOD-C20142 mark
      IF g_success='Y' AND g_oaz.oaz63='Y' THEN    #MOD-C20142 add
         LET l_t1=l_oha.oha01                      #MOD-C20142 add
         LET l_t1=l_t1[1,g_doc_len]                #MOD-C20142 add
         SELECT oay11 INTO l_oay11 FROM oay_file
         #WHERE oay01=l_oga.oga01                  #MOD-C20142 mark
          WHERE oayslip=l_t1                       #MOD-C20142 add
         IF l_oay11='Y' THEN
            CALL saxmt700sub_ar(g_oga01,l_oha.oha09)      
         END IF
      END IF
   END IF

   #CHI-C80009---add---START-->>把銷退單拋轉的動作移至過帳後
   IF l_oha.oha41  ='Y' THEN
      #IF t700sub_chkpoz() THEN   #DEV-D30046 --mark
      CALL saxmt700sub_chkpoz(l_oha.*,NULL) RETURNING l_flag,l_poz.*,l_flow   #DEV-D30046 --add
      IF l_flag THEN   #DEV-D30046 --add
         IF NOT p_inTransaction THEN   #DEV-D30046 --add
            ROLLBACK WORK 
         END IF    #DEV-D30046 --add
         RETURN 
      END IF #CHI-A50004 add ROLLBACK WORK
      #若銷售多角且正拋，則直接拋轉不異動庫存-->#CHI-C80009 應可直接扣庫存帳
      IF p_argv0 = '2' AND l_poz.poz011 = '1' THEN
         IF g_oax.oax07 = 'Y' THEN        #FUN-670007
             IF NOT p_inTransaction THEN   #DEV-D30046 --add
                ROLLBACK WORK   #MOD-C20079 add
             END IF   #DEV-D30046 --add
             CALL saxmt700sub_muticarry(l_oha.*,l_poz.*)
             #CALL t700_chspic()   #DEV-D30046 --mark
             #ROLLBACK WORK #CHI-A50004 add  #MOD-C20079 mark
             RETURN
         END IF                          #FUN-670007
      END IF
   END IF
   #CHI-C80009---add-----END
 
   # 多角貿易自動拋轉
   IF g_success = 'Y' AND p_argv0 MATCHES '[2]' THEN
      IF (l_poz.poz19='Y' AND l_poz.poz18=g_plant) THEN
         #設中斷點時,不執行拋轉作業
      ELSE
         IF g_oax.oax07 = 'Y' THEN    #FUN-670007
             CALL saxmt700sub_muticarry(l_oha.*,l_poz.*)
            #MOD-B30464 mark --start--
            #SELECT oha44 INTO l_oha.oha44 FROM oha_file WHERE oha01 = l_oha.oha01
            #IF l_oha.oha44 <> 'Y' THEN
            #   CALL saxmt700sub_z('y',l_oha.oha01)    #'y' 不需再顯示扣帳畫面直接執行
            #END IF 
            #MOD-B30464 mark --end--
         END IF                       #FUN-670007
      END IF                          #MOD-950075
   END IF
   #CALL t700_chspic()   #DEV-D30046 --mark
END FUNCTION

##############################################
#作用    : 取消確認
#傳入參數: p_oha01          銷退單號
#          p_ask_conf       開窗詢問是否取消確認 Y/N
#          p_inTransaction  若p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#回傳值  : 無
##############################################
FUNCTION saxmt700sub_w(p_oha01,p_inTransaction,p_ask_conf) 			# when l_oha.ohaconf='Y' (Turn to 'N')
   DEFINE p_oha01         LIKE oha_file.oha01   #DEV-D30046 --add
   DEFINE p_inTransaction LIKE type_file.num5   #DEV-D30046 --add
   DEFINE p_ask_conf      LIKE type_file.chr1   #DEV0D30046 --add
   DEFINE l_cnt           LIKE type_file.num10  # No.FUN-680137 INTEGER #MOD-640344 add
   DEFINE l_ohb14t        LIKE ohb_file.ohb14t  #MOD-B10154
   #DEFINE l_oia07         LIKE oia_file.oia07   #FUN-C50136
   DEFINE l_yy,l_mm       LIKE type_file.num5   #CHI-C70017
   DEFINE l_time          LIKE type_file.chr8   #CHI-C80072
   DEFINE l_oha           RECORD LIKE oha_file.*  #DEV-D30046 --add

   WHENEVER ERROR CONTINUE 
   
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01  
   
   IF l_oha.ohaconf='N' THEN RETURN END IF 
   IF l_oha.ohapost='Y' AND l_oha.oha09 !='5' THEN
      CALL cl_err('ohapost=Y:','axm-208',0) 
      RETURN 
   END IF
   
   #CHI-C70017---begin
   IF g_oaz.oaz03 = 'Y' AND g_sma.sma53 IS NOT NULL
      AND l_oha.oha02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      RETURN
   END IF
   
   CALL s_yp(l_oha.oha02) RETURNING l_yy,l_mm
   IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
       CALL cl_err('','mfg6090',0)  
       RETURN
   END IF
   #CHI-C70017---end
   
   #-----MOD-A80199---------
   IF l_oha.oha09 = '5' AND l_oha.ohapost = 'Y' THEN
      CALL saxmt700sub_z('y',l_oha.oha01)
      SELECT ohapost INTO l_oha.ohapost FROM oha_file
        WHERE oha01 = l_oha.oha01
      IF l_oha.ohapost = 'Y' THEN
         RETURN 
      END IF 
   END IF
   #-----END MOD-A80199-----
   
   #CHI-A50004 程式搬移 --start--
   LET g_success = 'Y'
   IF NOT p_inTransaction THEN   #DEV-D30046 --add
      BEGIN WORK
   END IF   #DEV-D30046 --add
  
   CALL saxmt700sub_lock_cl()   #DEV-D30046 --add
   
   OPEN t700sub_cl USING l_oha.oha01
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
      CLOSE t700sub_cl 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK
      END IF   #DEV-D30046 --add
      RETURN
   END IF
  
   FETCH t700sub_cl INTO l_oha.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
      CLOSE t700sub_cl 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK  
      END IF   #DEV-D30046 --add
      RETURN
   END IF
   #CHI-A50004 程式搬移 --end--

   
   #控管若換貨訂單已產生者,不可異動!
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oea_file
    WHERE oea00='2' #退補
      AND oea12=l_oha.oha01   #CHI-A40057 oea10-->oea12
      AND oea11='2' #資料來源 (退補)
      AND oeaconf <> 'X'   #MOD-870093
   IF l_cnt >=1 THEN
      #此張單據的換貨訂單已產生,不可做異動!
      CALL cl_err(l_oha.oha01,'axm-704',1)
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK #CHI-A50004 add
      END IF   #DEV-D30046 --add
      RETURN    #MOD-750067 add
   END IF
   IF l_oha.oha55 = 'S' THEN
      CALL cl_err(l_oha.oha01,'apm-030',1)
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK #CHI-A50004 add
      END IF   #DEV-D30046 --add
      RETURN
   END IF

   #No.FUN-A50071 -----start-----
   #POS銷售否=Y時，不可取消審核
   IF l_oha.oha94 != 'N' THEN
      CALL cl_err('','axm-740',0)
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK #CHI-A50004 add
      END IF   #DEV-D30046 --add
      RETURN
   END IF 
   #No.FUN-A50071 ----end------ 
 
   IF g_oaz.oaz03 = 'Y' AND
      g_sma.sma53 IS NOT NULL AND l_oha.oha02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF   #DEV-D30046 --add
      RETURN #CHI-A50004 add
   END IF
   
   # 若此銷退單為手動立應收待抵時,不允許可取消確認
   IF l_oha.oha54 != 0 THEN CALL cl_err('','axr-265',0) 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF   #DEV-D30046 --add
      RETURN 
   END IF #CHI-A50004 add
   
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM oma_file
    WHERE oma16=l_oha.oha01 AND omavoid='N'
   IF l_cnt >0 THEN
      CALL cl_err(l_oha.oha01,'axr-265',0) 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF   #DEV-D30046 --add
      RETURN #CHI-A50004 add
   END IF
   IF l_oha.ohaconf = 'X' THEN CALL cl_err('','9024',0) 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK 
      END IF   #DEV-D30046 --add
      RETURN 
   END IF #CHI-A50004 add
   
   #若已存在OQC單,則不可取消確認
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM qcs_file
     WHERE qcs01 = l_oha.oha01
       AND qcs14 <> 'X'
   IF l_cnt > 0 THEN
      CALL cl_err(l_oha.oha01,'axm-089',1)
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK #CHI-A50004 add
      END IF   #DEV-D30046 --add
      RETURN   
   END IF
 
   IF p_ask_conf = 'Y' THEN   #DEV-D30046 --add
      IF NOT cl_confirm('axm-109') THEN 
         IF NOT p_inTransaction THEN   #DEV-D30046 --add
            ROLLBACK WORK 
         END IF   #DEV-D30046 --add
         RETURN 
      END IF #CHI-A50004 add
   END IF    #DEV-D30046 --add
   
   #-----MOD-A80199---------
   #因為取消扣帳的動作不能包在Transaction裡,故將取消扣帳的動作往前移
   # '5.折讓'自動做取消扣帳
   #IF l_oha.oha09 = '5' AND l_oha.ohapost = 'Y' THEN
   #   LET g_success = 'Y'
   #   CALL saxmt700sub_z('y',l_oha.oha01)
   #   #-----MOD-A30054---------
   #   SELECT ohapost INTO l_oha.ohapost FROM oha_file
   #     WHERE oha01 = l_oha.oha01
   #   IF l_oha.ohapost = 'Y' THEN
   #      LET g_success = 'N'
   #   END IF
   #   #-----END MOD-A30054-----
   #   IF g_success ='N' THEN ROLLBACK WORK RETURN END IF #CHI-A50004 add
   #END IF
   #-----END MOD-A80199-----
 
   #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
   #BEGIN WORK
   # 
   # OPEN t700sub_cl USING l_oha.oha01
   # IF SQLCA.sqlcode THEN
   #    CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
   #    CLOSE t700sub_cl ROLLBACK WORK RETURN
   # END IF
   #
   # FETCH t700sub_cl INTO l_oha.*
   # IF SQLCA.sqlcode THEN
   #    CALL cl_err(l_oha.oha01,SQLCA.sqlcode,0)
   #    CLOSE t700sub_cl ROLLBACK WORK RETURN
   # END IF
   #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--
 
   #TQC-B40073 Begin---
   #UPDATE oha_file SET ohaconf = 'N',ohaconu='',ohacond='' WHERE oha01 = l_oha.oha01 #No.FUN-870007
   #CHI-C80072--str--
   # UPDATE oha_file SET ohaconf = 'N',ohaconu='',
   #                     ohacond = '' ,ohacont=''
    LET l_time = TIME
    UPDATE oha_file SET ohaconf = 'N',ohaconu= g_user,
                        ohacond = g_today ,ohacont= l_time
   #CHI-C80072--end--
     WHERE oha01 = l_oha.oha01 #No.FUN-870007
   #TQC-B40073 End-----

   #FUN-BA0069 -----------------MARK ----------------------BEGIN
   ##No.FUN-A20022 ADD--------UPDATE almq618&almq770 ABOUT the oha95_point WHEN "undo_confirm"-----------------
   # IF NOT cl_null(l_oha.oha87) THEN
   #   #MOD-B10154 Begin---
   #    SELECT SUM(ohb14t) INTO l_ohb14t FROM ohb_file
   #     WHERE ohb01=l_oha.oha01
   #    IF cl_null(l_ohb14t) THEN LET l_ohb14t=0 END IF
   #   #UPDATE lpj_file SET lpj07=lpj07-1,
   #   #                    lpj12=lpj12-l_oha.oha95
   #    UPDATE lpj_file SET lpj07=COALESCE(lpj07,0)+1,
   #                        lpj08=g_today,
   #                        lpj12=COALESCE(lpj12,0)+l_oha.oha95,
   #                        lpj14=COALESCE(lpj14,0)+l_oha.oha95,
   #                        lpj15=COALESCE(lpj15,0)+l_ohb14t
   #   #MOD-B10154 End-----
   #     WHERE lpj03=l_oha.oha87
   #    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #       CALL cl_err3("upd","lpj_file",l_oha.oha87,"",SQLCA.sqlcode,"","upd lpj12",1)
   #       LET g_success = 'N'
   #       RETURN
   #    ELSE
   #       MESSAGE 'UPDATE lpj_file OK'
   #    END IF
   #
   #    DELETE FROM lsm_file WHERE lsm01= l_oha.oha87 AND lsm02='8'           #8:Maintain Sales Return Note(axmt700)
   #                           AND lsm03= l_oha.oha01
   #    IF SQLCA.SQLERRD[3]=0 THEN
   #       CALL cl_err3("del","lsm_file",l_oha.oha87,"",SQLCA.sqlcode,"","no lsm delete",1)
   #       LET g_success = 'N'
   #       RETURN
   #    ELSE
   #       MESSAGE 'DELETE lsm_file OK'
   #    END IF
   # END IF
   ##No.FUN-A20022 END--------------------------------------------------------------------------------------
   #FUN-BA0069 -----------------MARK ----------------------END
   
   #FUN-C10053 add begin ---
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt
     FROM ogj_file 
    WHERE ogj01 = l_oha.oha01 
   IF l_cnt > 0 THEN
      DELETE FROM ogj_file WHERE ogj01 = l_oha.oha01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ogj_file",l_oha.oha01,"",SQLCA.sqlcode,"","delete",1)
         LET g_success = 'N'
         RETURN
      END IF   
   END IF 
   #FUN-C10053 add end ----- 
   
   CALL saxmt700sub_chstatus('N',l_oha.oha01)  #FUN-550051
   ##FUN-C50136-add-str--
   #IF g_oaz.oaz96 ='Y' THEN 
   #   CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
   #   IF l_oia07 = '0' THEN 
   #      CALL s_ccc_rback(l_oha.oha03,'G',l_oha.oha01,0,'')
   #   END IF
   #END IF
   ##FUN-C50136-add-end--
   
   LET l_time = TIME   #CHI-C80072
   IF g_success = 'Y' THEN
      LET l_oha.ohaconf='N' 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         COMMIT WORK
      END IF   #DEV-D30046 --add
      #CHI-C80072--str--
      #LET l_oha.ohaconu=NULL  #No.FUN-870007                                                                                               
      #LET l_oha.ohacond=NULL  #No.FUN-870007
      #LET l_oha.ohacont=NULL  #TQC-B40073
      #LET g_buf = ' '         #TQC-B40073
      #DISPLAY BY NAME l_oha.ohaconf
      LET l_oha.ohaconu = g_user
      LET l_oha.ohacond = g_today
      LET l_oha.ohacont = l_time
      SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=l_oha.ohaconu
      #DISPLAY BY NAME l_oha.ohaconf   #DEV-D30046 --mark
      #CHI-C80072--end--
   ELSE
      LET l_oha.ohaconu=g_user   #No.FUN-870007                                                                                              
      LET l_oha.ohacond=g_today  #No.FUN-870007
      #LET l_oha.ohacont=TIME     #TQC-B40073   #CHI-C80072
      LET l_oha.ohacont = l_time  #CHI-C80072
      #TQC-B40073 Begin---
      SELECT gen02 INTO g_buf FROM gen_file WHERE gen01=l_oha.ohaconu
      LET l_oha.ohaconf='Y' 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK
      END IF   #DEV-D30046 --add
      #TQC-B40073 End-----
   END IF
   
   #DEV-D30046 --mark--begin
   #IF g_azw.azw04='2' THEN
   #   DISPLAY BY NAME l_oha.ohaconu,l_oha.ohacond
   #   DISPLAY BY NAME l_oha.ohacont #TQC-B40073
   #   DISPLAY g_buf TO ohaconu_desc #TQC-B40073
   #END IF
   #IF l_oha.ohaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   #CALL cl_set_field_pic(l_oha.ohaconf,"",l_oha.ohapost,"",g_chr,"")
   #DEV-D30046 --mark--end
END FUNCTION

##############################################
#作用    : 過帳還原
#傳入參數: p_cmd
#          p_oha01          銷退單號
#回傳值  : 無
##############################################
FUNCTION saxmt700sub_z(p_cmd,p_oha01)
   DEFINE p_oha01         LIKE oha_file.oha01   #DEV-D30046 --add
   DEFINE l_cnt           LIKE type_file.num5   #MOD-640344        #No.FUN-680137 SMALLINT
   DEFINE l_cnt1          LIKE type_file.num5   #No.MOD-7A0013 add
   DEFINE p_cmd           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
   DEFINE b_ohb           RECORD LIKE ohb_file.*  #No.FUN-610090
   DEFINE l_ohb04         LIKE ohb_file.ohb04
   DEFINE l_ohb12         LIKE ohb_file.ohb12
   DEFINE l_ohb14         LIKE ohb_file.ohb14
   DEFINE l_ohb14t        LIKE ohb_file.ohb14t
   DEFINE l_ohb1002       LIKE ohb_file.ohb1002
   DEFINE l_tqy02         LIKE tqy_file.tqy02  
   DEFINE l_tqz02         LIKE tqz_file.tqz02   
   DEFINE l_ohg           RECORD LIKE ohb_file.*   #FUN-BC0081
   DEFINE l_rxe04         LIKE rxe_file.rxe04    #FUN-BC0081
   DEFINE l_sql           STRING                 #FUN-BC0081
   DEFINE l_rxe05         LIKE rxe_file.rxe05    #FUN-BC0081
   DEFINE l_rxe           RECORD LIKE rxe_file.* #FUN-BC0081
   DEFINE l_ima154        LIKE ima_file.ima154   #FUN-BC0081  
   DEFINE l_lqe01         LIKE lqe_file.lqe01    #FUN-BC0081
   #&ifdef SLK
   DEFINE l_ogbslk04      LIKE ogbslk_file.ogbslk04   #FUN-B90103
   DEFINE l_ogbslk63      LIKE ogbslk_file.ogbslk63   #FUN-B90103
   DEFINE l_ogbslk64      LIKE ogbslk_file.ogbslk64   #FUN-B90103
   DEFINE l_oebslk25      LIKE oebslk_file.oebslk25   #FUN-B90103
   #&endif
   #DEFINE l_oia07        LIKE oia_file.oia07     #FUN-C50136
   DEFINE l_n             LIKE type_file.num5    #FUN-C60033 #FUN-C60036 remark
   #DEV-D30046 --add--begin
   DEFINE l_oha           RECORD LIKE oha_file.* 
   DEFINE l_flag          LIKE type_file.num5    
   DEFINE l_poz           RECORD LIKE poz_file.* 
   DEFINE l_flow          LIKE poz_file.poz01    
   DEFINE l_ohbslk        RECORD LIKE ohbslk_file.*  
   DEFINE l_oebslk        RECORD LIKE oebslk_file.*  
   DEFINE l_imm01         LIKE imm_file.imm01
   DEFINE l_unit_arr      DYNAMIC ARRAY OF RECORD  
             unit            LIKE ima_file.ima25,
             fac             LIKE img_file.img21,
             qty             LIKE img_file.img10
                          END RECORD
   #DEV-D30046 --add--end
   DEFINE lj_result       LIKE type_file.chr1  #CHI-CC0028

   WHENEVER ERROR CONTINUE 
   
   LET g_cmd = p_cmd
   
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01
   
   #用oha1015為判斷,不再用oha1018,可以做銷退還原
   IF l_oha.oha05 = '4' THEN
      IF l_oha.oha1015='Y' THEN   
        LET g_success = 'N'   #MOD-950186
        CALL cl_err('','atm-258',1)
        RETURN
      END IF
   END IF

   #FUN-C60033--add--str ##FUN-C60036 remark--str
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM omf_file WHERE omf11=l_oha.oha01
   IF l_n>0 THEN
      LET g_success = 'N'
      CALL cl_err('','axm-544',1)
      RETURN
   END IF
   #FUN-C60033--add--end #FUN-C60036 remark--end
   
   #MOD-C30067 add start--------------------
   #折讓且原訂單出貨時，過賬還原需要判斷是否有新的出貨單存在
   IF l_oha.oha09 = '4' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ogb_file,oga_file,ohb_file,oha_file
       WHERE oga01=ogb01 AND ogb01<>ohb31
         AND ogb31=ohb33 AND ogb32=ohb34
         AND oha01=ohb01 AND oha01='37100-1203000003'
      IF l_cnt > 0 THEN
         LET g_success = 'N'
         CALL cl_err('','axm1132',1)
         RETURN
      END IF
   END IF
   #MOD-C30067 add end----------------------

   #No.FUN-A50071 -----start----
   #POS銷售否=Y時，不可過賬還原
   #No.TQC-AA0079  --Begin
   #IF l_oha.oha94 != 'N	'THEN
   IF l_oha.oha94 != 'N' THEN
   #No.TQC-AA0079  --End  
      CALL cl_err('','axm-741',0)
      RETURN
   END IF 
   #No.FUN-A50071 -----end----- 
 
   #FUN-C40018 add START
   #單據若自於儲值卡註銷,不可扣帳還原
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM lpv_file
     WHERE lpv13 = l_oha.oha01
   IF l_cnt > 0 THEN
     CALL cl_err('','axm_120',0)
     RETURN
   END IF
   #FUN-C40018 add END
 
   #控管若換貨訂單已產生者,不可異動!
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oea_file
    WHERE oea00='2' #退補
      AND oea12=l_oha.oha01   #CHI-A40057 oea10-->oea12
      AND oea11='2' #資料來源 (退補)
      AND oeaconf <> 'X'   #MOD-870093
   IF l_cnt >=1 THEN
      #此張單據的換貨訂單已產生,不可做異動!
      LET g_success = 'N'   #MOD-950186
      CALL cl_err(l_oha.oha01,'axm-704',1)
      RETURN    #MOD-750067 add
   END IF
   IF l_oha.oha41  = 'Y' THEN
      IF l_oha.ohapost='N' THEN
         LET g_success = 'N'   #MOD-950186
         CALL cl_err(l_oha.oha01,'axm-299',0) RETURN
      END IF
      #IF l_oha.oha44 = 'Y' THEN  #CHI-8B0048 add  #若為扣帳時失敗,不再詢問是否要執行還原transation #MOD-B30464 mark
         IF NOT cl_sure(10,10) THEN 
            LET g_success = 'N'   #MOD-950186
            RETURN 
         END IF
      #END IF                      #CHI-8B0048 add #MOD-B30464 mark 
      #IF t700sub_chkpoz() THEN   #DEV-D30046 --mark
      CALL saxmt700sub_chkpoz(l_oha.*,NULL) RETURNING l_flag,l_poz.*,l_flow   #DEV-D30046 --add
      IF l_flag THEN    #DEVV-D30046 --add 
         LET g_success = 'N'   #MOD-950186
         RETURN 
      END IF
      IF g_oax.oax07 = 'Y' THEN        #FUN-670007 
          CALL saxmt700sub_undo_muticarry(l_oha.*,l_poz.*)
      END IF                           #FUN-670007
      #CHI-C80009---mark---START
      #IF l_poz.poz011 = '1' THEN 
      #   LET g_success = 'N'   #MOD-950186
      #   RETURN 
      #END IF
      #CHI-C80009---mark-----END
      SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = l_oha.oha01
      #CALL t700_chspic()   #DEV-D30046 --mark
      #若拋轉還原未成功，則不可做扣帳還原
      IF l_oha.oha44 ='Y' THEN 
         LET g_success = 'N'   #MOD-950186
         CALL cl_err('','tri-013',1) 
         RETURN 
      END IF
   END IF

   
   #FUN-BC0081 begin ---
   LET l_sql = "SELECT rxe04,rxe05 FROM rxe_file ",
               " WHERE rxe00 = '03' ",
               "   AND rxe01 = ? AND rxe02 = ? "
   PREPARE sel_rxe_p1 FROM l_sql
   DECLARE sel_rxe_c1 CURSOR FOR sel_rxe_p1
   LET g_success = 'Y'   
   DECLARE ohb_s_c_1 CURSOR FOR 
      SELECT * FROM ohb_file WHERE ohb01 = l_oha.oha01
   DECLARE rxe_s_c   CURSOR FOR
      SELECT * FROM rxe_file WHERE rxe01 = ? AND rxe02 = ?  
   LET l_sql = "SELECT lqe01 FROM lqe_file ",
               " WHERE lqe01 >= ? AND lqe01 <= ? AND lqe17 <> '2' AND lqe13 = '",l_oha.ohaplant,"'"
   PREPARE sel_lqe_p FROM l_sql 
   DECLARE lqe_s_c  CURSOR FOR sel_lqe_p
   CALL s_showmsg_init()
   FOREACH ohb_s_c_1 INTO l_ohg.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach ohb_s_c_1',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #CHI-CC0028---begin
      CALL s_incchk(l_ohg.ohb09,l_ohg.ohb091,g_user)
           RETURNING lj_result
      IF NOT lj_result THEN
         LET g_success = 'N'
         LET g_showmsg = l_ohg.ohb03,"/",l_ohg.ohb09,"/",l_ohg.ohb091,"/",g_user
         CALL s_errmsg('ohb03,ohb09,ohb091,inc03',g_showmsg,'','asf-888',1)
      END IF
      #CHI-CC0028---end
      
      SELECT * FROM rxe_file 
       WHERE rxe00 = '03'
         AND rxe01 = l_ohg.ohb01 
         AND rxe02 = l_ohg.ohb03 
      IF SQLCA.sqlcode = 100 THEN
         EXIT FOREACH
      END IF 
      FOREACH rxe_s_c USING l_ohg.ohb01,l_ohg.ohb03 INTO l_rxe.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach rxe_s_c',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         FOREACH lqe_s_c USING l_rxe.rxe04,l_rxe.rxe05 INTO l_lqe01
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach lqe_s_c',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            CALL s_errmsg(l_lqe01,"","","alm1541",1)
            LET g_success = 'N'
         END FOREACH           
      END FOREACH
      IF g_success = 'N' THEN 
         EXIT FOREACH 
      END IF 
      SELECT ima154 INTO l_ima154
        FROM ima_file 
       WHERE ima01 = l_ohg.ohb04
       IF l_ima154 ='Y' THEN 
          FOREACH sel_rxe_c1 USING l_ohg.ohb01,l_ohg.ohb03 INTO l_rxe04,l_rxe05
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach sel_rxe_c1',SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             UPDATE lqe_file SET lqe09 = '',
                                 lqe10 = '',
                                 lqe17 = '1'
              WHERE lqe01 >= l_rxe04
                AND lqe01 <= l_rxe05 
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL s_errmsg("lqe09,lqe10,lqe17",SQLCA.sqlcode,"","",1)
                LET g_success = 'N'
             END IF   
          END FOREACH           
       END IF  
   END FOREACH 
   
   ##FUN-C50136-add-str--
   #IF g_oaz.oaz96 ='Y' THEN
   #   CALL s_ccc_oia07('G',l_oha.oha03) RETURNING l_oia07
   #   IF l_oia07 = '1' THEN
   #      CALL s_ccc_rback(l_oha.oha03,'G',l_oha.oha01,0,'')
   #   END IF
   #END IF       
   ##FUN-C50136-add-end--
   
   CALL s_showmsg()
   IF g_success = 'N' THEN         
      RETURN
   END IF   
   #FUN-BC0081 end --- 

   IF l_oha.ohapost='N' THEN
      LET g_success = 'N'   #MOD-950186
      CALL cl_err(l_oha.oha01,'axm-299',0)
      RETURN     #MOD-950186
   ELSE
      IF l_oha.ohaconf='N' THEN
         LET g_success = 'N'   #MOD-950186
         CALL cl_err(l_oha.oha01,'axm-184',0)
         #DISPLAY BY NAME l_oha.ohaconf   #DEV-D30046 --mark
         RETURN   #MOD-950186
      ELSE
         IF NOT cl_null(l_oha.oha10) THEN
            LET g_success = 'N'   #MOD-950186
            CALL cl_err(l_oha.oha01,'axm-603',0)
            #DISPLAY BY NAME l_oha.oha10   #DEV-D30046 --mark
            RETURN   #MOD-950186
         ELSE
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt FROM oma_file,omb_file
             WHERE oma01=omb01
               AND omb31=l_oha.oha16
               AND oma34 = '3'
            IF  l_cnt >0 THEN
                LET g_success = 'N'   #MOD-950186
                CALL cl_err(l_oha.oha01,'axm-603',0)
                RETURN     #MOD-950186
            ELSE
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM oma_file
                WHERE oma00='21' AND oma16=l_oha.oha01 AND omavoid='N'
               IF l_cnt >0 THEN
                  LET g_success = 'N'   #MOD-950186
                  CALL cl_err(l_oha.oha01,'axm-603',0)
                  RETURN     #MOD-950186
               ELSE
                  IF l_oha.oha1018 IS NOT NULL AND l_oha.oha1015='Y' THEN
                     IF cl_confirm('axm-255') THEN
                        LET g_msg="axmp750 '",l_oha.oha01,"' '",g_cmd,"'"
                        CALL cl_cmdrun_wait(g_msg)
                        SELECT * INTO l_oha.* FROM oha_file
                         WHERE oha01=l_oha.oha01
                     ELSE
                        LET g_success = 'N'   #MOD-950186
                        RETURN
                     END IF
                  ELSE
                     LET g_msg="axmp750 '",l_oha.oha01,"' '",g_cmd,"'"
                     CALL cl_cmdrun_wait(g_msg)
                     SELECT * INTO l_oha.* FROM oha_file
                      WHERE oha01=l_oha.oha01
                  END IF #TQC-7C0045
               END IF
            END IF
         END IF
      END IF
   END IF
   
   SELECT oha56,ohapost INTO l_oha.oha56,l_oha.ohapost FROM oha_file   #No.FUN-740016
    WHERE oha01 = l_oha.oha01
   #DISPLAY BY NAME l_oha.ohapost,l_oha.oha56   #No.FUN-740016   #DEV-D30046 --mark
   
   IF l_oha.oha05='4' THEN    
      SELECT oha1015,oha1018 INTO l_oha.oha1015,l_oha.oha1018
        FROM oha_file
       WHERE oha01 = l_oha.oha01
      #DISPLAY BY NAME l_oha.oha1015,l_oha.oha1018   #DEV-D30046 --mark
   END IF
   
   #CALL t700_chspic()  #DEV-D30046 --mark
   
   DECLARE t700_s1_c3 CURSOR FOR 
     SELECT * FROM ohb_file
      WHERE ohb01 = l_oha.oha01
   FOREACH t700_s1_c3 INTO b_ohb.*
      IF g_aza.aza50='Y' THEN
         IF b_ohb.ohb1005='2' THEN                                                  
            IF b_ohb.ohb1010='Y' THEN                                                
              UPDATE tqw_file                                                       
                 SET tqw081=tqw081+b_ohb.ohb14t                                     
               WHERE tqw01=b_ohb.ohb1007                                            
            ELSE                                                                     
              UPDATE tqw_file                                                       
                 SET tqw081=tqw081+b_ohb.ohb14                                      
               WHERE tqw01=b_ohb.ohb1007                                            
            END IF                                                                   
         END IF                                                                     
      END IF                                                                      
   END FOREACH
 
   IF l_oha.ohapost = "Y" THEN
      DECLARE t700_s1_c2 CURSOR FOR SELECT * FROM ohb_file
        WHERE ohb01 = l_oha.oha01
 
      LET l_imm01 = ""
      LET g_success = "Y"
      BEGIN WORK
 
      FOREACH t700_s1_c2 INTO b_ohb.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
 
         IF g_sma.sma115 = 'Y' THEN
            IF g_ima906 = '2' THEN  #子母單位
               LET l_unit_arr[1].unit= b_ohb.ohb910
               LET l_unit_arr[1].fac = b_ohb.ohb911
               LET l_unit_arr[1].qty = b_ohb.ohb912
               LET l_unit_arr[2].unit= b_ohb.ohb913
               LET l_unit_arr[2].fac = b_ohb.ohb914
               LET l_unit_arr[2].qty = b_ohb.ohb915
               CALL s_dismantle(l_oha.oha01,b_ohb.ohb03,l_oha.oha02,
                                b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,
                                b_ohb.ohb092,l_unit_arr,l_imm01)
                      RETURNING l_imm01
            END IF
         END IF
      END FOREACH
 
      IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
         COMMIT WORK
         LET g_msg="aimt324 '",l_imm01,"'"
         CALL cl_cmdrun_wait(g_msg)
      ELSE
         ROLLBACK WORK
      END IF
   END IF

   #FUN-B90103---------add--------begin-------------
   #&ifdef SLK
   IF s_industry('slk') THEN   #DEV-D30046 --add
      DECLARE t700_s1_c1_ohbslk CURSOR FOR 
         SELECT * FROM ohbslk_file WHERE ohbslk01=l_oha.oha01
      FOREACH t700_s1_c1_ohbslk INTO l_ohbslk.*
         IF STATUS THEN EXIT FOREACH END IF
         IF NOT cl_null(l_ohbslk.ohbslk31) THEN                   #更新出貨單銷退量
            SELECT SUM(ogb63),SUM(ogb64) INTO l_ogbslk63,l_ogbslk64 FROM ogb_file, ogbi_file
             WHERE ogb01=ogbi01 AND ogb03=ogbi03 AND ogb01=l_ohbslk.ohbslk31
               AND ogbislk02=l_ohbslk.ohbslk32
            IF cl_null(l_ogbslk63) THEN LET l_ogbslk63 = 0 END IF
            IF cl_null(l_ogbslk64) THEN LET l_ogbslk64 = 0 END IF
            SELECT ogbslk04 INTO l_ogbslk04 FROM ogbslk_file
             WHERE ogbslk01=l_ohbslk.ohbslk31 AND ogbslk03=l_ohbslk.ohbslk32
 
            IF l_ohbslk.ohbslk04 = l_ogbslk04 THEN      #銷退品號與出貨品號相同才update
               UPDATE ogbslk_file SET ogbslk63=l_ogbslk63,
                                      ogbslk64=l_ogbslk64
                WHERE ogbslk01 = l_ohbslk.ohbslk31
                  AND ogbslk03 = l_ohbslk.ohbslk32
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  LET g_showmsg = l_ohbslk.ohbslk31,"/",l_ohbslk.ohbslk32
                  CALL s_errmsg('ogbslk01,ogbslk03',g_showmsg,'upd ogbslk63,64',STATUS,1)
                  LET g_success = 'N' 
                  EXIT FOREACH
               END IF
            END IF
         END IF
 
         IF l_oha.oha09 != '4' THEN RETURN END IF
         IF NOT cl_null(l_ohbslk.ohbslk33) THEN     # 訂單銷退量
            SELECT * INTO l_oebslk.* FROM oebslk_file
             WHERE oebslk01=l_ohbslk.ohbslk33 AND oebslk03=l_ohbslk.ohbslk34
            IF STATUS THEN
               CALL s_errmsg('oebslk01,oebslk03',g_showmsg,'sel oebslk',STATUS,1)
               LET g_success = 'N' 
               EXIT FOREACH
            END IF
            IF l_ohbslk.ohbslk04 = l_oebslk.oebslk04 THEN      #銷退品號與訂單品號相同才update
               SELECT SUM(oeb25) INTO l_oebslk25 FROM oeb_file,oebi_file
                 WHERE oeb01=oebi01 AND oeb03=oebi03 AND oeb01=l_ohbslk.ohbslk33
                   AND oebislk03=l_ohbslk.ohbslk34
               IF cl_null(l_oebslk25) THEN LET l_oebslk25 = 0 END IF
               UPDATE oebslk_file SET oebslk25 = l_oebslk25
                WHERE oebslk01=l_ohbslk.ohbslk33 AND oebslk03=l_ohbslk.ohbslk34
               IF STATUS THEN
                  LET g_showmsg = l_ohbslk.ohbslk33,"/",l_ohbslk.ohbslk34
                  CALL s_errmsg('oebslk01,oebslk03',g_showmsg,'upd oebslk25',STATUS,1)
                  LET g_success = 'N' 
                  EXIT FOREACH
               END IF
            END IF
         END IF
      END FOREACH
   END IF    #DEV-D30046 --add
   #&endif
   #FUN-B90103---------end--------------------------
END FUNCTION

FUNCTION saxmt700sub_y1(p_oha)
   DEFINE p_oha    RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE s_ohb12  LIKE ohb_file.ohb12
   DEFINE l_slip   LIKE oay_file.oayslip
   DEFINE l_oay13  LIKE oay_file.oay13
   DEFINE l_oay14  LIKE oay_file.oay14
   DEFINE l_ohb14t LIKE ohb_file.ohb14t
   DEFINE l_cnt    LIKE type_file.num5,     #MOD-BA0027
          l_amt    LIKE ohb_file.ohb14t     #MOD-BA0027
   #DEV-D30046 --add--begin
   DEFINE l_ohb    RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE l_msg1   LIKE type_file.chr1000
   DEFINE l_msg2   LIKE type_file.chr1000
   DEFINE l_msg3   LIKE type_file.chr1000
   DEFINE l_ohb12  LIKE ohb_file.ohb12
   DEFINE l_ohb14  LIKE ohb_file.ohb14
   DEFINE l_ogb12  LIKE ogb_file.ogb12
   DEFINE l_ogb14  LIKE ogb_file.ogb14
   DEFINE l_ogb14t LIKE ogb_file.ogb14t
   #DEV-D30046 --add--end

   #FUN-C20116 mark str--- 
   #LET g_time=TIME #TQC-B40073
   #UPDATE oha_file SET ohaconf = 'Y',
   #                    ohaconu=g_user,
   #                    ohacond=g_today
   #                   ,ohacont=g_time  #TQC-B40073
   # WHERE oha01 = p_oha.oha01
   #IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #   CALL cl_err3("upd","oha_file",p_oha.oha01,"",SQLCA.sqlcode,"","upd ohaconf",1)  #No.FUN-650108
   #   LET g_success = 'N' RETURN
   #END IF
   #FUN-C20116 mark end---

   #FUN-BA0069 ---------------------MARK-----------------BEGIN
   ##No.FUN-A20022 ADD--------UPDATE almq618&almq770 ABOUT the oha95_point----------------------------------
   #IF NOT cl_null(p_oha.oha87) THEN
   #  #MOD-B10154 Begin---
   #   SELECT SUM(ohb14t) INTO l_ohb14t FROM ohb_file
   #    WHERE ohb01=p_oha.oha01
   #   IF cl_null(l_ohb14t) THEN LET l_ohb14t=0 END IF
   #  #UPDATE lpj_file SET lpj07=lpj07+1,
   #  #                    lpj08=g_today,
   #  #                    lpj12=lpj12+p_oha.oha95
   #   UPDATE lpj_file SET lpj07=COALESCE(lpj07,0)-1,
   #                       lpj08=g_today,
   #                       lpj12=COALESCE(lpj12,0)-p_oha.oha95,
   #                       lpj14=COALESCE(lpj14,0)-p_oha.oha95,
   #                       lpj15=COALESCE(lpj15,0)-l_ohb14t
   #  #MOD-B10154 End-----
   #    WHERE lpj03=p_oha.oha87
   #   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #      CALL cl_err3("upd","lpj_file",p_oha.oha87,"",SQLCA.sqlcode,"","upd lpj12",1)
   #      LET g_success = 'N'
   #      RETURN
   #   ELSE
   #      MESSAGE 'UPDATE lpj_file OK'
   #   END IF
   #
   #   INSERT INTO lsm_file VALUES( p_oha.oha87,'8',           #8:Maintain Sales Return Note(axmt700)
   #                                p_oha.oha01,p_oha.oha95,
   #                                g_today,'',p_oha.ohaplant) #No.FUN-A70118
   #   IF STATUS OR SQLCA.SQLCODE THEN
   #      CALL cl_err3("ins","lsm_file","","",SQLCA.sqlcode,"","ins lsm",1)
   #      LET g_success = 'N'
   #      RETURN
   #   ELSE
   #      MESSAGE 'UPDATE lsm_file OK'
   #   END IF
   #END IF
   ##No.FUN-A20022 END--------------------------------------------------------------------------------------
   #FUN-BA0069 ---------------------MARK-----------------END
    
   LET l_slip = s_get_doc_no(p_oha.oha01)   #No.TQC-5A0098
   SELECT oay13,oay14 INTO l_oay13,l_oay14 FROM oay_file WHERE oayslip = l_slip
   IF l_oay13 = 'Y' AND p_oha.oha09 MATCHES '[145]' THEN
      SELECT SUM(ohb14t) INTO l_ohb14t FROM ohb_file WHERE ohb01 = p_oha.oha01
      IF cl_null(l_ohb14t) THEN LET l_ohb14t = 0 END IF
      LET l_ohb14t = l_ohb14t * p_oha.oha24
      IF l_ohb14t > l_oay14 THEN
         CALL cl_err(l_oay14,'axm-700',1) LET g_success='N' RETURN
      END IF
   END IF
   
   # check 銷退量及出貨量的控管
   DECLARE t700sub_y1_c CURSOR FOR
      SELECT * FROM ohb_file 
       WHERE ohb01 = p_oha.oha01 
         AND (ohb1005="1" OR ohb1005 IS NULL) 
         AND (ohb1004="N" OR ohb1004 IS NULL) 
       ORDER BY ohb03  #No.FUN-650108
   
   CALL s_showmsg_init()  #No.FUN-710028
   
   FOREACH t700sub_y1_c INTO l_ohb.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN
         CALL s_errmsg('ohb01',p_oha.oha01,'y1 foreach',STATUS,1) #No.FUN-710028
         LET g_success = 'N' RETURN    
      END IF
      LET g_cmd='_y1() read ohb:',l_ohb.ohb03 #FUN-840012
      CALL cl_msg(g_cmd) #FUN-840012
      
      #FUN-A60035 --Begin 服飾業在saxmt700sub_y_1()中已做過控管
      #IF NOT s_industry("slk") THEN #FUN-A60035 mark
      #FUN- A60035 --End
      IF NOT cl_null(l_ohb.ohb31) THEN
         SELECT SUM(ohb12),SUM(ohb14t),SUM(ohb14) INTO l_ohb12,l_ohb14t,l_ohb14
           FROM oha_file,ohb_file
          WHERE oha01=ohb01 AND ohb31=l_ohb.ohb31 AND ohb32=l_ohb.ohb32
            AND ohaconf='Y'
         SELECT SUM(ogb12),SUM(ogb14t),SUM(ogb14) INTO l_ogb12,l_ogb14t,l_ogb14
           FROM oga_file,ogb_file
          WHERE oga01=ogb01 AND ogb01=l_ohb.ohb31 AND ogb03=l_ohb.ohb32
         IF cl_null(l_ohb12 ) THEN LET l_ohb12 =0 END IF
         IF cl_null(l_ohb14t) THEN LET l_ohb14t=0 END IF
         IF cl_null(l_ohb14 ) THEN LET l_ohb14 =0 END IF
         IF cl_null(l_ogb12 ) THEN LET l_ogb12 =0 END IF
         IF cl_null(l_ogb14t) THEN LET l_ogb14t=0 END IF
         IF cl_null(l_ogb14 ) THEN LET l_ogb14 =0 END IF
         IF l_ogb12 - l_ohb12 <0 THEN
            LET s_ohb12=l_ohb12-l_ohb.ohb12
            IF cl_null(s_ohb12) THEN LET s_ohb12=0 END IF
            CALL cl_getmsg('axr-267',g_lang) RETURNING l_msg1
            CALL cl_getmsg('axr-274',g_lang) RETURNING l_msg2
            CALL cl_getmsg('axr-268',g_lang) RETURNING l_msg3
            LET g_msg1=l_msg1 CLIPPED,s_ohb12 USING '######&.##','+',
                       l_msg2 CLIPPED,l_ohb.ohb12 USING '######&.##',
                       l_msg3 CLIPPED
            CALL cl_getmsg('axr-266',g_lang) RETURNING l_msg1
            LET g_msg1=g_msg CLIPPED,
                       l_msg1 CLIPPED,l_ogb12 USING '######&.##'
            CALL s_errmsg('','',g_msg1,'aap-999',1)   #No.FUN-710028
            LET g_success='N' CONTINUE FOREACH        #No.FUN-710028
         END IF
         IF l_ohb14 > l_ohb14t THEN
            #若超過金額只警告不拒絕
            IF l_ogb14 - l_ohb14 <0 THEN
              CALL cl_getmsg('axr-270',g_lang) RETURNING l_msg1
              CALL cl_getmsg('axr-275',g_lang) RETURNING l_msg2
              CALL cl_getmsg('axr-269',g_lang) RETURNING l_msg3
             LET g_msg1=l_msg1 CLIPPED,l_ohb14t-l_ohb.ohb14t USING '#####&.##','+',
                        l_msg2 CLIPPED,l_ohb.ohb14t USING '#####&.##','>',
                        l_msg3 CLIPPED,l_ogb14t USING '#####&.##'
              IF NOT cl_confirm2('axr-284',g_msg1) THEN
                 LET g_success='N' CONTINUE FOREACH    #No.FUN-710028
              END IF
            END IF
         ELSE
            IF l_ogb14t - l_ohb14t <0 THEN
              CALL cl_getmsg('axr-270',g_lang) RETURNING l_msg1
              CALL cl_getmsg('axr-275',g_lang) RETURNING l_msg2
              CALL cl_getmsg('axr-269',g_lang) RETURNING l_msg3
             LET g_msg1=l_msg1 CLIPPED,l_ohb14t-l_ohb.ohb14t USING '#####&.##','+',
                        l_msg2 CLIPPED,l_ohb.ohb14t USING '#####&.##','>',
                        l_msg3 CLIPPED,l_ogb14t USING '#####&.##'
              IF NOT cl_confirm2('axr-284',g_msg1) THEN
                 LET g_success='N' CONTINUE FOREACH    #No.FUN-710028
              END IF
           END IF
         END IF
      #-----MOD-BA0027---------
      ELSE
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM ome_file
          WHERE ome01 = l_ohb.ohb30
         IF l_cnt > 0 THEN
            LET l_amt = 0
            SELECT ome59t INTO l_amt FROM ome_file
             WHERE ome01 = l_ohb.ohb30
            IF cl_digcut(l_ohb.ohb14t*p_oha.oha24,g_azi04) > l_amt THEN
               CALL cl_getmsg('aap-417',g_lang) RETURNING l_msg1
               LET g_msg1 = l_msg1,":",l_ohb.ohb03
               IF NOT cl_confirm2('axm_118',g_msg1) THEN
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
            END IF
         ELSE
            SELECT COUNT(*) INTO l_cnt FROM amd_file
             WHERE amd03 = l_ohb.ohb30
            IF l_cnt > 0 THEN
               LET l_amt = 0
               SELECT SUM(amd06) INTO l_amt FROM amd_file
                WHERE amd03 = l_ohb.ohb30
               IF cl_digcut(l_ohb.ohb14t*p_oha.oha24,g_azi04) > l_amt THEN
                  CALL cl_getmsg('aap-417',g_lang) RETURNING l_msg1
                  LET g_msg1 = l_msg1,":",l_ohb.ohb03
                  IF NOT cl_confirm2('axm_118',g_msg1) THEN
                     LET g_success='N'
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF
         END IF
      #-----END MOD-BA0027-----
      END IF
      #END IF #FUN-A60035 #FUN-A60035 mark
      IF g_success='N' THEN CONTINUE FOREACH END IF   #No.FUN-710028
   END FOREACH
   
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
END FUNCTION

#FUN-C10053 add begin ---
FUNCTION saxmt700sub_ins_ogj(p_oha)
DEFINE P_oha    RECORD LIKE oha_file.*   #DEV-D30046 --add
DEFINE l_sql    STRING
DEFINE l_ogk04  LIKE ogk_file.ogk04
DEFINE l_ogk05  LIKE ogk_file.ogk05
DEFINE l_ogk06  LIKE ogk_file.ogk06
DEFINE l_ogk07  LIKE ogk_file.ogk07
DEFINE l_ogk08  LIKE ogk_file.ogk08
DEFINE l_ogk08t LIKE ogk_file.ogk08t
DEFINE l_ogk09  LIKE ogk_file.ogk09
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_rxy05_other  LIKE rxy_file.rxy05
DEFINE l_rxy05_09     LIKE rxy_file.rxy05
DEFINE l_ogj02        LIKE ogj_file.ogj02
DEFINE l_rtz04        LIKE rtz_file.rtz04
DEFINE l_rtz06        LIKE rtz_file.rtz06
DEFINE l_ogk08t_t     LIKE ogk_file.ogk08
DEFINE l_ogj    RECORD LIKE ogj_file.*
DEFINE l_ogj07t       LIKE ogj_file.ogj07t    #FUN-C50047 add

   DROP TABLE ogk_temp;
   CREATE TEMP TABLE ogk_temp(
       ogk04     LIKE ogk_file.ogk04,
       ogk05     LIKE ogk_file.ogk05,
       ogk06     LIKE ogk_file.ogk06,
       ogk07     LIKE ogk_file.ogk07,
       ogk08     LIKE ogk_file.ogk08,
       ogk08t    LIKE ogk_file.ogk08t,
       ogk09     LIKE ogk_file.ogk09)
   IF g_azw.azw04 = '2' THEN
      SELECT rtz04,rtz06 INTO l_rtz04,l_rtz06
        FROM rtz_file
       WHERE rtz01 = p_oha.ohaplant
   END IF
   IF g_azw.azw04 = '2' THEN
      SELECT rxy05 INTO l_rxy05_09    #积分抵现金额
        FROM rxy_file 
       WHERE rxy00 = '03'
         AND rxy01 = p_oha.oha01
         AND rxy03 = '09'
      IF cl_null(l_rxy05_09) THEN
         LET l_rxy05_09 = 0
      END IF
      SELECT SUM(rxy05) INTO l_rxy05_other  #其余付款金额
        FROM rxy_file   
       WHERE rxy00 = '03' 
         AND rxy01 = p_oha.oha01 
         AND rxy03 NOT IN ('04','09')
      IF cl_null(l_rxy05_other) THEN
         LET l_rxy05_other = 0
      END IF 
      SELECT COUNT(*) INTO l_cnt
        FROM ogj_file
       WHERE ogj01 = p_oha.oha01
      IF l_cnt > 0 THEN
         DELETE FROM ogj_file WHERE ogj01 = p_oha.oha01
      END IF
      LET l_ogj.ogj01 = p_oha.oha01
      LET l_ogj.ogj09 = ' '
      LET l_ogj.ogjdate = g_today
      LET l_ogj.ogjgrup = g_grup
      LET l_ogj.ogjlegal = g_legal
      LET l_ogj.ogjmodu = ' '
      LET l_ogj.ogjorig = g_grup
      LET l_ogj.ogjplant = g_plant
      LET l_ogj.ogjuser = g_user
      LET l_sql = " SELECT ogk04,ogk05,ogk06,ogk07,SUM(ogk08),SUM(ogk08t),SUM(ogk09)",
                  "   FROM ogk_file",
                  "  WHERE ogk01 = '",p_oha.oha01,"'",
                  "    AND ogkplant = '",p_oha.ohaplant,"'",
                  "  GROUP BY ogk04,ogk05,ogk06,ogk07",
                 #"  ORDER BY ogk04 ASC,ogk05 DESC,ogk06 ASC"   #FUN-C50047 mark
                  "  ORDER BY ogk05 asc,ogk06 desc"             #FUN-C50047 add
      PREPARE t700sub_sel_ogk FROM l_sql
      DECLARE t700sub_sel_ogk_cs CURSOR FOR t700sub_sel_ogk
      FOREACH t700sub_sel_ogk_cs INTO l_ogk04,l_ogk05,l_ogk06,l_ogk07,l_ogk08,l_ogk08t,l_ogk09
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         #固定税额大于零则直接写入到实际交易税别明细档 
         IF l_ogk06 >0 THEN
            SELECT MAX(ogj02) + 1 INTO l_ogj.ogj02
              FROM ogj_file
             WHERE ogj01 = p_oha.oha01
            IF cl_null(l_ogj.ogj02) THEN
               LET l_ogj.ogj02 = 1
            END IF 
            LET l_ogj.ogj03 = l_ogk04
            LET l_ogj.ogj04 = l_ogk05
            LET l_ogj.ogj05 = l_ogk06
            LET l_ogj.ogj06 = l_ogk07
            LET l_ogj.ogj07 = l_ogk08
            LET l_ogj.ogj07t= l_ogk08t
            LET l_ogj.ogj08 = l_ogk09
           #TQC-C30085 add START
            IF cl_null(l_ogj.ogj09) THEN
               LET l_ogj.ogj09 = 0 
            END IF
           #TQC-C30085 add END
            INSERT INTO ogj_file VALUES(l_ogj.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","ogj_file",p_oha.oha01,"",SQLCA.SQLCODE,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
        #FUN-C50047 add START
         IF l_rxy05_other = 0 THEN
            LET l_ogj07t = 0
         ELSE
            LET l_ogj07t = l_ogk08t
         END IF
        #FUN-C50047 add END
         #用积分抵现金额付款
         IF l_rxy05_09 > 0 THEN
            IF l_ogk05 > 0 THEN     #先扣除税率大于零的金额
               IF l_rxy05_09 > l_ogk08t THEN
                  LET l_rxy05_09 = l_rxy05_09 - l_ogk08t
                  LET l_ogk08t = 0
               ELSE 
                  LET l_ogk08t = l_ogk08t - l_rxy05_09
                  LET l_rxy05_09 = 0
               END IF 
               LET l_ogk09 = l_ogk08t - l_ogk08t/(1+l_ogk05/100)
               CALL cl_digcut(l_ogk09,t_azi04) RETURNING l_ogk09
               LET l_ogk08 = l_ogk08t - l_ogk09
               IF l_ogk09 > 0 THEN
                  INSERT INTO ogk_temp(ogk04,ogk05,ogk06,ogk07,ogk08,ogk08t,ogk09)
                                VALUES(l_ogk04,l_ogk05,l_ogk06,l_ogk07,l_ogk08,l_ogk08t,l_ogk09)
                  IF SQLCA.SQLCODE THEN
                     CALL cl_err3("ins","ogk_temp",p_oha.oha01,"",SQLCA.SQLCODE,"","",1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF 
               END IF
            END IF 
         ELSE 
            IF l_ogk05 > 0 THEN  
               INSERT INTO ogk_temp(ogk04,ogk05,ogk06,ogk07,ogk08,ogk08t,ogk09)
                             VALUES(l_ogk04,l_ogk05,l_ogk06,l_ogk07,l_ogk08,l_ogk08t,l_ogk09)
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","ogk_temp",p_oha.oha01,"",SQLCA.SQLCODE,"","",1)
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF 
            END IF    
         END IF 
         #用其他款别付款
         IF l_rxy05_other > 0 THEN
            IF l_ogk06 > 0 THEN   #先扣除固定税额
               IF l_rxy05_other < l_ogk09 THEN
                  LET l_ogk09 = l_ogk09 - l_rxy05_other
                  LET l_rxy05_other = 0
               ELSE 
                  LET l_rxy05_other = l_rxy05_other - l_ogk09
                  LET l_ogk09 = 0
               END IF 
            ELSE 
               IF l_ogk05 = 0 THEN   #在扣除税率为零的金额
                  IF l_rxy05_other > l_ogk08t THEN
                     LET l_rxy05_other = l_rxy05_other - l_ogk08t
                     LET l_ogj07t = l_ogk08t   #FUN-C50047 add
                     LET l_ogk08t = 0
                  ELSE  
                     LET l_ogk08t = l_ogk08t - l_rxy05_other
                     LET l_ogj07t = l_rxy05_other          #FUN-C50047 add
                     LET l_rxy05_other = 0
                  END IF 
               END IF 
            END IF              
         END IF 
        #FUN-C50047 add START
         IF l_ogk06 = 0 AND l_ogk05 = 0 THEN
            LET l_ogk08 = l_ogj07t / (1+l_ogk05/100)
            CALL cl_digcut(l_ogk08,t_azi04) RETURNING l_ogk08
            INSERT INTO ogk_temp(ogk04,ogk05,ogk06,ogk07,ogk08,ogk08t,ogk09)
                          VALUES(l_ogk04,l_ogk05,l_ogk06,l_ogk07,l_ogk08,l_ogj07t,l_ogk09)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","ogk_temp",p_oha.oha01,"",SQLCA.SQLCODE,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
        #FUN-C50047 add END
      END FOREACH
      #含税金额等于其他付款金额则写入到实际交易税别明细档
      SELECT SUM(ogk08t) INTO l_ogk08t_t   #税率大于零的含税金额求和
        FROM ogk_temp
       WHERE ogk05 > 0
      IF cl_null(l_ogk08t_t) THEN
         LET l_ogk08t_t = 0
      END IF 
      IF l_ogk08t_t = l_rxy05_other THEN
         LET l_sql = "SELECT * FROM ogk_temp ORDER BY ogk05 desc, ogk06 asc "
         PREPARE sel_ogk_temp_p FROM l_sql
         DECLARE sel_ogk_temp CURSOR FOR sel_ogk_temp_p 
         FOREACH sel_ogk_temp INTO l_ogj.ogj03,l_ogj.ogj04,l_ogj.ogj05,l_ogj.ogj06,l_ogj.ogj07,l_ogj.ogj07t,l_ogj.ogj08
            SELECT MAX(ogj02) + 1 INTO l_ogj.ogj02
              FROM ogj_file
             WHERE ogj01 = p_oha.oha01
            IF cl_null(l_ogj.ogj02) THEN
               LET l_ogj.ogj02 = 1
            END IF
           #TQC-C30085 add START
            IF cl_null(l_ogj.ogj09) THEN
               LET l_ogj.ogj09 = 0
            END IF
           #TQC-C30085 add END
            INSERT INTO ogj_file VALUES(l_ogj.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","ogj_file",p_oha.oha01,"",SQLCA.SQLCODE,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END FOREACH
      END IF
   END IF 
END FUNCTION 
#FUN-C10053 add end ----

#變更狀況碼
FUNCTION saxmt700sub_chstatus(l_new,p_oha01)
   DEFINE l_new         LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
   DEFINE p_oha01       LIKE oha_file.oha01        #DEV-D30046 --add
   #DEFINE l_imaicd04   LIKE imaicd_file.imaicd04       #NO.FUN-7B0015 #FUN-BA0051 mark
   #DEFINE l_imaicd08   LIKE imaicd_file.imaicd08       #NO.FUN-7B0015 #FUN-BA0051 mark 
   DEFINE l_cnt        LIKE type_file.num10            #MOD-AB0253
   DEFINE l_flag       LIKE type_file.num10            #MOD-AB0253
   
   #Y;N;X
   #LET l_oha.ohaconf=l_new  #DEV-D30046 --mark 
   CASE l_new
      WHEN 'N'  #取消確認
        UPDATE oha_file SET oha55='0' WHERE oha01=p_oha01
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           RETURN
        END IF
        #LET l_oha.oha55='0'   #DEV-D30046 --mark
      WHEN 'Y'  #確認
          UPDATE oha_file SET oha55='1' WHERE oha01=p_oha01
          IF SQLCA.sqlcode THEN
             LET g_success='N'
             RETURN
          END IF
          #LET l_oha.oha55='1'   #DEV-D30046 --mark
      WHEN 'X'  #作廢
        UPDATE oha_file SET oha55='9' WHERE oha01=p_oha01
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           RETURN
        END IF
        #LET l_oha.oha55='9'   #DEV-D30046 --mark
 
        #-----MOD-AB0253---------
        #IF l_ac > 0 THEN     #MOD-960165
        #    SELECT imaicd04,imaicd08 INTO l_imaicd04,l_imaicd08
        #        FROM imaicd_file
        #        WHERE imaicd00=g_ohb1[l_ac].ohb04
        # 
        #   IF l_imaicd04 MATCHES '[0-4]' THEN
        #      DELETE FROM idd_file WHERE idd01=g_ohb1[l_ac].ohb04
        #      UPDATE idc_file SET idc01=NULL WHERE idc01=g_ohb1[l_ac].ohb04
        #   END IF
        #   IF l_imaicd04 MATCHES '[0-4]' AND l_imaicd08 ='Y' THEN
        #      DELETE FROM ida_file WHERE ida01=g_ohb1[l_ac].ohb04
        #   END IF   
        #END IF               #MOD-960165
        
        #&ifdef ICD
        IF s_industry('icd') THEN   #FUN-B70061 mark  #DEV-D30046 --add
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM ida_file
            WHERE ida07 = p_oha01
           IF l_cnt > 0 THEN
              IF NOT cl_confirm('aic-112') THEN
                 LET g_success='N'
                 RETURN
              END IF
              CALL s_icdinout_del(1,p_oha01,'','')  #FUN-B80119--傳入p_plant參數''---
                 RETURNING l_flag
              IF l_flag = 0 THEN
                 LET g_success='N'
                 RETURN
              END IF
           END IF
        END IF   #FUN-B70061 mark  #DEV-D30046 --add 
        #&endif
         
        #-----END MOD-AB0253----- 
   END CASE
   #DISPLAY BY NAME l_oha.oha55   #DEV-D30046 --mark
   #CALL t700_chspic()   #DEV-D30046 --mark
END FUNCTION

FUNCTION saxmt700sub_CN(p_oha01,p_flag)	# 產生待抵帳款 (Credit Note)
   DEFINE p_oha01     LIKE oha_file.oha01     #DEV-D30046 --add
   DEFINE p_flag      LIKE type_file.chr1     #DEV-D30046 --add
   DEFINE l_oha       RECORD LIKE oha_file.*  #DEV-D30046 --add
   
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01   #DEV-D30046 --add
   
   IF l_oha.ohaconf='N' THEN CALL cl_err('conf=N','aap-717',0) RETURN END IF
   IF l_oha.ohapost='N' THEN CALL cl_err('post=N','aim-206',0) RETURN END IF
   IF l_oha.oha10 IS NOT NULL THEN RETURN END IF
   IF cl_null(l_oha.oha09) OR l_oha.oha09 NOT MATCHES '[145]' THEN
      CALL cl_err(l_oha.oha09,'axr-063',0)
      RETURN
   END IF
   
   #FUN-BA0014 mod str---
   #LET g_msg="axrp304 '",l_oha.oha01,"' '",l_oha.oha09,"' '",l_oha.ohaplant,"' " #FUN-A60056 add ohaplant
   #LET g_msg="axrp304 '",l_oha.oha01,"' '",l_oha.oha09,"' '",l_oha.ohaplant,"' '' '' '' '' '' 'Y' "            #MOD-BB0151 mark
   #LET g_msg="axrp304 '",l_oha.oha01,"' '",l_oha.oha09,"' '",l_oha.ohaplant,"' '' '' '' '' '' '",p_flag,"' "   #MOD-BB0151  #CHI-C20015 mark
   LET g_msg="axrp304 '",l_oha.oha01,"' '",l_oha.oha09,"' '",l_oha.ohaplant,"' '' '' '' '' '' '",p_flag,"' 'Y' "   #CHI-C20015 add   #多傳一個參數,判斷是否可以開窗修改單別
   DISPLAY g_msg 
   #FUN-BA0014 mod end---
   CALL cl_cmdrun_wait(g_msg)
   
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01=l_oha.oha01
   #No.TQC-C20537  --Begin
   IF NOT cl_null(l_oha.oha10) THEN
      CALL cl_err(l_oha.oha10,'lib-284',0)
   ELSE
      CALL cl_err(l_oha.oha10,'abm-020',0)
   END IF
   #No.TQC-C20537  --End  
   #DEV-D30046 --mark--begin 
   #DISPLAY BY NAME l_oha.oha10
   #DISPLAY BY NAME l_oha.oha24
   #DEV-D30046 --mark--end 
END FUNCTION

FUNCTION saxmt700sub_imm(p_oha01,p_inTransaction)
   DEFINE p_oha01          LIKE oha_file.oha01   #DEV-D30046 --add
   DEFINE p_inTransaction  LIKE type_file.num5   #DEV-D30046 --add
   DEFINE l_oha            RECORD LIKE oha_file.*
   DEFINE l_ohb            RECORD LIKE ohb_file.*
   DEFINE l_imm            RECORD LIKE imm_file.*
   DEFINE l_imn            RECORD LIKE imn_file.*
   DEFINE l_rvbs           RECORD LIKE rvbs_file.* #MOD-B80050 add
   DEFINE l_sql            STRING
   DEFINE li_result        LIKE type_file.num5
   DEFINE l_msg            STRING 
   DEFINE l_imm03          LIKE imm_file.imm03
   DEFINE l_tot            LIKE oeb_file.oeb25
   DEFINE l_ocn03          LIKE ocn_file.ocn03
   DEFINE l_ocn04          LIKE ocn_file.ocn04
   DEFINE l_flag           LIKE type_file.num5   #MOD-950169
   DEFINE l_fac            LIKE type_file.num26_10  #MOD-950169
   #&ifndef STD            
   DEFINE l_imni           RECORD LIKE imni_file.*   #FUN-B70074
   #&endif                 
   DEFINE l_store          STRING                    #FUN-CB0087

   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01
   
   IF cl_null(l_oha.oha01) THEN
      CALL cl_err('',-400,0)
      RETURN ""
   END IF
 
   IF NOT p_inTransaction THEN   #DEV-D30046 --add
      BEGIN WORK
   END IF   #DEV-D30046 --add
   
   LET g_success = "Y"
   LET l_imm.imm12 = ""         #MOD-A60070 add
   LET l_imm.imm01 = l_oha.oha56

   IF cl_null(l_imm.imm01) THEN
      CALL s_auto_assign_no("aim",g_oaz.oaz79,l_oha.oha02,"","imm_file",  #NO.CHI-780041   #MOD-870201
                            "imm01","","","")
                  RETURNING li_result,l_imm.imm01
      IF (NOT li_result) THEN
         LET g_success = "N"
      END IF
      
      LET l_imm.imm02 = l_oha.oha02   #MOD-860259
      LET l_imm.imm03 = "N"
      LET l_imm.imm10 = "1"
      LET l_imm.imm14 = g_grup
      LET l_imm.immconf = "Y"
      LET l_imm.immuser=g_user
      LET l_imm.immgrup=g_grup
      LET l_imm.immdate=g_today
      LET l_imm.immplant = g_plant  #No.FUN-870007
      LET l_imm.immlegal = g_legal  #No.FUN-870007
 
      LET l_imm.immoriu = g_user      #No.FUN-980030 10/01/04
      LET l_imm.immorig = g_grup      #No.FUN-980030 10/01/04
      #FUN-A60034--add---str---
      #FUN-A70104--mod---str---
      LET l_imm.immmksg = 'N'          #是否簽核
      LET l_imm.imm15 = '1'            #簽核狀況   #MOD-C80085 modify 0 -> 1
      LET l_imm.imm16 = g_user         #申請人
      #FUN-A70104--mod---end---
      #FUN-A60034--add---end---
      INSERT INTO imm_file VALUES (l_imm.*)
      IF STATUS THEN
         LET g_success = "N"
      END IF
      
      LET l_sql = "SELECT * FROM ohb_file WHERE ohb01='",l_oha.oha01,"'"
      
      PREPARE pre_imn FROM l_sql
      DECLARE imn_curs CURSOR FOR pre_imn
      
      FOREACH imn_curs INTO l_ohb.*
         #MOD-D10185 add start -----
         IF l_ohb.ohb04[1,4] = 'MISC' THEN
            CONTINUE FOREACH
         END IF
         #MOD-D10185 add start ----
         
         LET l_imn.imn01 = l_imm.imm01
         SELECT MAX(imn02) + 1 INTO l_imn.imn02
           FROM imn_file WHERE imn01 = l_imm.imm01
         IF l_imn.imn02 IS NULL THEN
            LET l_imn.imn02 = 1
         END IF
         LET l_imn.imn03 = l_ohb.ohb04
         LET l_imn.imn04 = g_oaz.oaz78
         LET l_imn.imn05 = " "    
         LET l_imn.imn06 = l_oha.oha03
         SELECT img09 INTO l_imn.imn09 FROM img_file
          WHERE img01 = l_imn.imn03
            AND img02 = l_imn.imn04
            AND img03 = l_imn.imn05
            AND img04 = l_imn.imn06
         CALL s_umfchk(l_imn.imn03,l_ohb.ohb05,l_imn.imn09)
            RETURNING l_flag,l_fac
         IF l_flag = 1 THEN
            LET l_fac = 1
         END IF
         LET l_imn.imn10 = l_ohb.ohb12 * l_fac
         LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #No.TQC-C20183
         LET l_imn.imn15 = l_ohb.ohb09
         LET l_imn.imn16 = l_ohb.ohb091
         LET l_imn.imn17 = l_ohb.ohb092
         LET l_imn.imn28 = l_ohb.ohb50
         LET l_imn.imn29 = "N"
         #MOD-B10122 mark --start-- 
         #LET l_imn.imn30 = l_ohb.ohb05
         #LET l_imn.imn31 = 1
         #LET l_imn.imn32 = l_ohb.ohb12
         #LET l_imn.imn33 = ""
         #LET l_imn.imn34 = 0
         #LET l_imn.imn35 = 0
         #LET l_imn.imn40 = l_ohb.ohb05
         #LET l_imn.imn41 = 1
         #LET l_imn.imn42 = l_imn.imn32
         #LET l_imn.imn43 = ""
         #LET l_imn.imn44 = 0
         #LET l_imn.imn45 = 0
         #LET l_imn.imn51 = 1
         #LET l_imn.imn52 = 0
         #MOD-B10122 mark --end-- 
         LET l_imn.imn9301 = s_costcenter(l_imm.imm14)
         LET l_imn.imn9302 = l_imn.imn9301
         SELECT img09 INTO l_imn.imn20 FROM img_file
          WHERE img01 = l_imn.imn03
            AND img02 = l_imn.imn15
            AND img03 = l_imn.imn16
            AND img04 = l_imn.imn17

         #CHI-C20006 add begin---
         IF cl_null(l_imn.imn20) THEN
            SELECT ima25 INTO l_imn.imn20 FROM ima_file
             WHERE ima01 = l_imn.imn03
         END IF
         #CHI-C20006 add end-----

         CALL s_umfchk(l_imn.imn03,l_imn.imn09,l_imn.imn20)
              RETURNING l_flag,l_imn.imn21
         IF l_flag = 1 THEN
            LET l_imn.imn21 = 1
         END IF
         LET l_imn.imn22 = l_imn.imn10 * l_imn.imn21
         LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)   #No.TQC-C20183
         #MOD-B10122 add --start--
         LET l_imn.imn30 = l_ohb.ohb910
         CALL s_du_umfchk(l_imn.imn03,'','','',
                          l_imn.imn09,l_imn.imn30,'1')
              RETURNING g_errno,l_imn.imn31
         LET l_imn.imn32 = l_ohb.ohb912
         LET l_imn.imn33 = l_ohb.ohb913
         CALL s_du_umfchk(l_imn.imn03,'','','',
                          l_imn.imn09,l_imn.imn33,'2')
              RETURNING g_errno,l_imn.imn34
         LET l_imn.imn35 = l_ohb.ohb915
         LET l_imn.imn40 = l_ohb.ohb910
         CALL s_du_umfchk(l_imn.imn03,'','','',
                          l_imn.imn20,l_imn.imn40,'1')
              RETURNING g_errno,l_imn.imn41
         LET l_imn.imn42 = l_ohb.ohb912
         LET l_imn.imn43 = l_ohb.ohb913
         CALL s_du_umfchk(l_imn.imn03,'','','',
                          l_imn.imn20,l_imn.imn43,'1')
              RETURNING g_errno,l_imn.imn44
         LET l_imn.imn45 = l_ohb.ohb915
         CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn40)
               RETURNING l_flag,l_imn.imn51
         IF l_flag = 1 THEN
            LET l_imn.imn51 = 1
         END IF
         CALL s_umfchk(l_imn.imn03,l_imn.imn33,l_imn.imn43)
               RETURNING l_flag,l_imn.imn52
         IF l_flag = 1 THEN
            LET l_imn.imn52 = 1
         END IF
         #MOD-B10122 add --end--
         LET l_imn.imnplant = g_plant   #No.FUN-870007
         LET l_imn.imnlegal = g_legal   #No.FUN-870007
         #FUN-CB0087---qiull---add---str---
         IF g_aza.aza115 = 'Y' THEN
            LET l_store = ''
            IF NOT cl_null(l_imn.imn04) THEN
               LET l_store = l_store,l_imn.imn04
            END IF
            IF NOT cl_null(l_imn.imn15) THEN
               IF NOT cl_null(l_store) THEN
                  LET l_store = l_store,"','",l_imn.imn15
               ELSE
                  LET l_store = l_store,l_imn.imn15
               END IF
            END IF
            CALL s_reason_code(l_imn.imn01,'','',l_imn.imn03,l_store,l_imm.imm16,l_imm.imm14) RETURNING l_imn.imn28
            IF cl_null(l_imn.imn28) THEN
               CALL cl_err('','aim-425',1)
               LET g_success = 'N'
            END IF
         END IF
         #FUN-CB0087---qiull---add---end--- 

         INSERT INTO imn_file VALUES (l_imn.*)
         IF STATUS THEN
            LET g_success = "N"
         #&ifndef STD
         #FUN-B70074-add-str--
         ELSE
            IF s_industry('std') THEN   #DEV-D30046 --add
               INITIALIZE l_imni.* TO NULL
               LET l_imni.imni01 = l_imn.imn01
               LET l_imni.imni02 = l_imn.imn02
               IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN
                  LET g_success = 'N'
               END IF
            END IF    #DEV-D30046 --add
         #FUN-B70074-add-end--
         #&endif
         END IF

         #MOD-B80050 add --start--
         LET g_ima918 = ''  
         LET g_ima921 = ''  
         SELECT ima918,ima921 INTO g_ima918,g_ima921 
           FROM ima_file
          WHERE ima01 = l_imn.imn03
            AND imaacti = "Y"
               
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            DECLARE t700sub_rvbs_1 CURSOR FOR SELECT * FROM rvbs_file
                                            WHERE rvbs01 = l_ohb.ohb01
                                              AND rvbs02 = l_ohb.ohb03
            FOREACH t700sub_rvbs_1 INTO l_rvbs.*
                 IF STATUS THEN
                    CALL cl_err('rvbs',STATUS,1)
                 END IF
               
                 LET l_rvbs.rvbs00 = 'aimt324' 
                 LET l_rvbs.rvbs01 = l_imn.imn01
                 LET l_rvbs.rvbs02 = l_imn.imn02
                 LET l_rvbs.rvbs13 = 0
               
                 INSERT INTO rvbs_file VALUES(l_rvbs.*)
                 IF STATUS OR SQLCA.SQLCODE THEN
                    CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                    LET g_success = 'N'
                 END IF
            END FOREACH

            DELETE FROM rvbs_file WHERE rvbs00 = 'aimt324' 
                                    AND rvbs01 = l_imn.imn01
                                    AND rvbs02 = l_imn.imn02
                                    AND rvbs13 = 0
                                    AND rvbs09 = 1
            DECLARE t700sub_rvbs_11 CURSOR FOR SELECT * FROM rvbs_file
                                             WHERE rvbs00 = 'aimt324' 
                                              AND rvbs01 = l_imn.imn01
                                              AND rvbs02 = l_imn.imn02
                                              AND rvbs13 = 0
                                             #AND rvbs09 = -1    #TQC-B90236  mark
                                              AND rvbs09 = 1     #TQC-B90236  add
            FOREACH t700sub_rvbs_11 INTO l_rvbs.*
               IF STATUS THEN                          
                  CALL cl_err('rvbs',STATUS,1)
               END IF
                  
               LET l_rvbs.rvbs09 = 1
                  
               INSERT INTO rvbs_file VALUES(l_rvbs.*)
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                  LET g_success = 'N'
               END IF
            END FOREACH
         END IF
         #MOD-B80050 add --end--
      
      END FOREACH
   END IF
 
   IF g_success = 'Y' THEN 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         COMMIT WORK  
         #LET l_msg="aimt324 '",l_imm.imm01,"' 'A'"      #FUN-A60034 mark
         LET l_msg="aimt324 '",l_imm.imm01,"' ' ' 'A'"  #FUN-A60034 add
         CALL cl_cmdrun_wait(l_msg)
      END IF   #DEV-D30046 --add 
      RETURN l_imm.imm01
   ELSE 
      IF NOT p_inTransaction THEN   #DEV-D30046 --add
         ROLLBACK WORK
      END IF   #DEV-D30046 --add 
      RETURN ""
   END IF
END FUNCTION

#檢查多角流程代碼資料
FUNCTION saxmt700sub_chkpoz(p_oha,p_ohb31)
   DEFINE p_oha     RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE p_ohb31   LIKE ohb_file.ohb31      #DEV-D30046 --add  
   DEFINE l_poz     RECORD LIKE poz_file.*   #DEV-D30046 --add
   DEFINE l_cnt     LIKE type_file.num5      #DEV-D30046 --add
   DEFINE l_flow    LIKE poz_file.poz01      #DEV-D30046 --add
   DEFINE l_oea01   LIKE oea_file.oea01
   DEFINE l_oga01   LIKE oga_file.oga01
 
   IF cl_null(p_oha.oha16) THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM ohb_file
       WHERE ohb01=p_oha.oha01
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
      IF l_cnt=0 THEN
         LET l_oga01=p_ohb31  #No.FUN-650108
      ELSE
         #若單身的出貨單號有兩筆以上不同時,SQL有誤
         SELECT MAX(ohb31) INTO l_oga01 FROM ohb_file #讀到任可一筆單身的出貨單號即可
          WHERE ohb01 = p_oha.oha01
      END IF
   ELSE
      LET l_oga01 = p_oha.oha16
   END IF
 
   SELECT oga99[1,8] INTO l_flow FROM oga_file WHERE oga01 = l_oga01
   LET l_flow=l_flow CLIPPED #No.8881
   SELECT * INTO l_poz.* FROM poz_file WHERE poz01 = l_flow
   IF STATUS THEN
      CALL cl_err3("sel","poz_file",l_flow,"","axm-318","","",1)  #No.FUN-650108
      RETURN 1,l_poz.*,l_flow
   END IF
 
   IF p_oha.oha05='2' AND l_poz.poz00='2' THEN
      CALL cl_err(l_flow,'tri-008',1) 
      RETURN 1,l_poz.*,l_flow
   END IF
   IF p_oha.oha05='3' AND l_poz.poz00='1' THEN
      CALL cl_err(l_flow,'tri-008',1) 
      RETURN 1,l_poz.*,l_flow
   END IF
 
   RETURN 0,l_poz.*,l_flow
END FUNCTION

FUNCTION saxmt700sub_muticarry(p_oha,p_poz)
   DEFINE p_oha     RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE p_poz     RECORD LIKE poz_file.*   #DEV-D30046 --add

   IF p_poz.poz011='1' THEN   #正拋
      LET g_msg="axmp860 '",p_oha.oha01,"'"
   ELSE                       #逆拋
      LET g_msg="axmp865 '",p_oha.oha01,"' '",p_oha.oha05,"' "  #No.8981
   END IF
   CALL cl_cmdrun_wait(g_msg CLIPPED)
   SELECT ohapost,oha99,oha44  INTO p_oha.ohapost,p_oha.oha99,p_oha.oha44
     FROM oha_file WHERE oha01=p_oha.oha01
  
   #DISPLAY BY NAME p_oha.ohapost,p_oha.oha99,p_oha.oha44  #DEV-D30046 --mark
END FUNCTION

FUNCTION saxmt700sub_undo_muticarry(p_oha,p_poz)
   DEFINE p_oha     RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE p_poz     RECORD LIKE poz_file.*   #DEV-D30046 --add
   
   IF p_oha.oha44  = 'N' THEN RETURN END IF
   IF p_poz.poz011='1' THEN   #正拋
      LET g_msg="axmp870 '",p_oha.oha01,"'"
   ELSE                       #逆拋
      LET g_msg="axmp866 '",p_oha.oha01,"' '",p_oha.oha05,"' "  #No.8981
   END IF
   CALL cl_cmdrun_wait(g_msg CLIPPED)
   SELECT ohapost,oha99,oha44  INTO p_oha.ohapost,p_oha.oha99,p_oha.oha44
     FROM oha_file WHERE oha01=p_oha.oha01
   DISPLAY BY NAME p_oha.ohapost,p_oha.oha99,p_oha.oha44
END FUNCTION

FUNCTION saxmt700sub_s1(p_oha01)
   DEFINE p_oha01        LIKE oha_file.oha01      #DEV-D30046 --add
   DEFINE g_oha53        LIKE oha_file.oha53          
   DEFINE g_msg          STRING    #TQC-7C0045
   DEFINE l_oayauno      LIKE oay_file.oayauno,
          l_oay16        LIKE oay_file.oay16,
          l_oay19        LIKE oay_file.oay19,
          l_oay20        LIKE oay_file.oay20,
          l_tqk04        LIKE tqk_file.tqk04,
          l_occ02        LIKE occ_file.occ02,  
          l_occ11        LIKE occ_file.occ11,  
          l_occ07        LIKE occ_file.occ07,  
          l_occ08        LIKE occ_file.occ08,  
          l_occ09        LIKE occ_file.occ09,  
          l_occ1023      LIKE occ_file.occ1023, 
          l_occ1024      LIKE occ_file.occ1024, 
          l_occ1022      LIKE occ_file.occ1022, 
          l_occ1005      LIKE occ_file.occ1005, 
          l_occ1006      LIKE occ_file.occ1006, 
          l_oaytype      LIKE oay_file.oaytype,
          l_occ1027      LIKE occ_file.occ1027  
   DEFINE l_ogb930       LIKE ogb_file.ogb930    #FUN-670063
   DEFINE l_ogbi         RECORD LIKE ogbi_file.* #No.FUN-7B0018 
   #DEFINE l_imaicd04     LIKE imaicd_file.imaicd04    #No.MOD-890249 add #FUN-BA0051 mark
   #DEFINE l_imaicd08     LIKE imaicd_file.imaicd08    #No.MOD-890249 add #FUN-BA0051 mark
   DEFINE l_flag         LIKE type_file.num5          #No.MOD-890249 add
   DEFINE l_ohbi         RECORD LIKE ohbi_file.*      #TQC-B80005 
   #FUN-B90103--------add---
   #&ifdef SLK
   DEFINE l_ogbslk03     LIKE ogbslk_file.ogbslk03
   DEFINE l_ohbslk37     LIKE ohb_file.ohb37
   DEFINE l_ogbslk13     LIKE ogbslk_file.ogbslk13
   DEFINE l_ogbslk13t    LIKE ogbslk_file.ogbslk13
   DEFINE l_ogbslk14     LIKE ogbslk_file.ogbslk14
   DEFINE l_ogbslk14t    LIKE ogbslk_file.ogbslk14t 
   #&endif
   #FUN-B90103--------end---
   DEFINE l_oga14        LIKE oga_file.oga14  #FUN-CB0087
   DEFINE l_oga15        LIKE oga_file.oga15  #FUN-CB0087
   #DEV-D30046 --add--begin
   DEFINE l_oga          RECORD LIKE oga_file.*    
   DEFINE l_ogb          RECORD LIKE ogb_file.*    
   DEFINE l_oha          RECORD LIKE oha_file.*    
   DEFINE l_ohb          RECORD LIKE ohb_file.*    
   DEFINE l_ohbslk       RECORD LIKE ohbslk_file.*  
   DEFINE l_ogbslk       RECORD LIKE ogbslk_file.*  
   DEFINE l_msg1         LIKE type_file.chr1000
   DEFINE l_msg2         LIKE type_file.chr1000
   DEFINE l_msg3         LIKE type_file.chr1000
   DEFINE l_t            LIKE oay_file.oayslip
   DEFINE l_azf10        LIKE azf_file.azf10
   DEFINE li_result      LIKE type_file.num5
   DEFINE l_unit         LIKE gsb_file.gsb05
   DEFINE l_ogb03        LIKE ogb_file.ogb03
   DEFINE l_ogb13        LIKE ogb_file.ogb13
   DEFINE l_ogb13t       LIKE ogb_file.ogb13
   DEFINE l_ogb14        LIKE ogb_file.ogb14
   DEFINE l_ogb14t       LIKE ogb_file.ogb14
   DEFINE l_oga50        LIKE oga_file.oga50
   DEFINE l_oga51        LIKE oga_file.oga51
   DEFINE l_oga53        LIKE oga_file.oga53
   DEFINE l_oga501       LIKE oga_file.oga501
   DEFINE l_oga511       LIKE oga_file.oga511
   #DEV-D30046 --add--end
   
   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01  #DEV-30046 --add
    
   IF l_oha.oha05='4' THEN    
      INITIALIZE l_oga.* TO NULL
      LET g_oha53=0
      LET l_t = s_get_doc_no(l_oha.oha01)
      SELECT oayauno,oay16,oay19,oay20 INTO l_oayauno,l_oay16,l_oay19,l_oay20
        FROM oay_file
       WHERE oayslip = l_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","oay_file",l_t,"","atm-254","","",1)  #No.FUN-650108
         LET g_success='N'
         RETURN
      END IF
      SELECT azf10 INTO l_azf10 FROM azf_file
       WHERE azf01=l_oay19
         AND azf02='2'      #No.TQC-760054
      IF SQLCA.sqlcode THEN                                                    
         CALL cl_err3("sel","azf_file",l_oay19,"","aoo-018","","",1)  #No.FUN-650108     #No.FUN-6B0065
         LET g_success='N'                                                     
         RETURN                                                                
      END IF              
      SELECT oaytype INTO l_oaytype
        FROM oay_file
       WHERE oayslip = l_oay16
      
      CALL s_auto_assign_no("AXM",l_oay16,l_oha.oha02,l_oaytype,"oga_file","oga01","","","")
            RETURNING li_result,g_oga01
       IF (NOT li_result) THEN                                                                                                     
           LET g_success='N'
           RETURN
       END IF                                                                                                                      
 
      SELECT occ07,occ08,occ09,occ1005,occ1006,           
             occ1022,occ1024  
        INTO l_occ07,l_occ08,l_occ09,l_occ1005,l_occ1006,   
             l_occ1022,l_occ1024
        FROM occ_file
       WHERE occ01=l_oha.oha1014
      IF cl_null(l_occ07) THEN LET l_occ07=' ' END IF
      IF cl_null(l_occ08) THEN LET l_occ08=' ' END IF
      IF cl_null(l_occ09) THEN LET l_occ09=' ' END IF
      IF cl_null(l_occ1005) THEN LET l_occ1005=' ' END IF
      IF cl_null(l_occ1006) THEN LET l_occ1006=' ' END IF
      IF cl_null(l_occ1022) THEN LET l_occ1022=' ' END IF 
      IF cl_null(l_occ1024) THEN LET l_occ1024=' ' END IF 
      SELECT occ02,occ11 INTO l_occ02,l_occ11 FROM occ_file
       WHERE occ01=l_occ07
      IF cl_null(l_occ02) THEN LET l_occ02=' ' END IF
      IF cl_null(l_occ11) THEN LET l_occ11=' ' END IF 
      SELECT tqk04 INTO l_tqk04 FROM tqk_file
       WHERE tqk01=l_oha.oha1014
         AND tqk02=l_oha.oha1002
         AND tqk03=l_occ07                   #No.TQC-640125
      IF cl_null(l_tqk04) THEN LET l_tqk04=' ' END IF
      LET l_oga.oga00='1'
      LET l_oga.oga01=g_oga01
      LET l_oga.oga02=l_oha.oha02
      LET l_oga.oga03=l_oha.oha1014           
      LET l_oga.oga032=l_occ02             
      LET l_oga.oga1009=l_occ1006       
      LET l_oga.oga04=l_occ09          
      LET l_oga.oga1011=l_occ1022         
      LET l_oga.oga18=l_occ07             
      LET l_oga.oga1003=l_occ1024    
      LET l_oga.oga1010=l_occ1005  
      LET l_oga.oga033=l_occ11
      LET l_oga.oga04=l_occ09
      LET l_oga.oga05=l_occ08
      LET l_oga.oga07='N'
      LET l_oga.oga08='1'
      LET l_oga.oga09='2'
      LET l_oga.oga14=l_oha.oha14
      LET l_oga.oga15=l_oha.oha15
      LET l_oga.oga161=0
      LET l_oga.oga162=100
      LET l_oga.oga163=0
      LET l_oga.oga18=l_occ07
      LET l_oga.oga20='Y'
      LET l_oga.oga21=l_oha.oha21
      LET l_oga.oga211=l_oha.oha211
      LET l_oga.oga212=l_oha.oha212
      LET l_oga.oga213=l_oha.oha213
      LET l_oga.oga23=l_oha.oha23
      LET l_oga.oga24=l_oha.oha24
      LET l_oga.oga25=l_oha.oha25
      LET l_oga.oga26=l_oha.oha26
      LET l_oga.oga30='N'
      LET l_oga.oga31=l_oha.oha31
      LET l_oga.oga32=l_tqk04
      LET l_oga.oga50=0
      LET l_oga.oga501=0
      LET l_oga.oga51=0
      LET l_oga.oga511=0
      LET l_oga.oga52=0
      LET l_oga.oga53=0
      LET l_oga.oga54=0
      #FUN-AC0055 add ------begin------
      IF cl_null(l_oga.oga57) THEN
         LET l_oga.oga57= '1' 
      END IF
      #FUN-AC0055 add -------end-------
      LET l_oga.oga65='N'
      LET l_oga.oga903='N'
      LET l_oga.ogaconf='Y'
      LET l_oga.ogapost='N'
      LET l_oga.ogaprsw=0
      LET l_oga.ogauser=g_user
      LET l_oga.ogagrup=g_grup
      LET l_oga.ogadate=g_today
      LET l_oga.oga1002=l_oay20
      LET l_oga.oga1005='Y'
      LET l_oga.oga1006=0
      LET l_oga.oga1007=0
      LET l_oga.oga1008=0
      LET l_oga.oga1012=l_oha.oha01
      LET l_oga.oga1014='Y'
      LET l_oga.ogamksg='N'
      LET l_oga.ogaplant = g_plant
      LET l_oga.ogalegal = g_legal
      LET l_oga.oga85 = ' ' #MOD-B50039 add
      LET l_oga.oga94 = 'N' #MOD-B50039 add
      IF g_azw.azw04='2' THEN
         LET l_oga.oga85 = l_oha.oha85
         LET l_oga.oga86 = l_oha.oha86
         LET l_oga.oga87 = l_oha.oha87                                                                                             
         LET l_oga.oga88 = l_oha.oha88  
         LET l_oga.oga89 = l_oha.oha89                                                                                             
         LET l_oga.oga90 = l_oha.oha90                                                                                             
         LET l_oga.oga91 = l_oha.oha91                                                                                             
         LET l_oga.oga92 = l_oha.oha92 
         LET l_oga.oga93 = l_oha.oha93                                                                                             
         LET l_oga.oga94 = l_oha.oha94                                                                                             
         LET l_oga.oga95 = l_oha.oha95                                                                                             
         LET l_oga.oga96 = l_oha.oha96                                                                                             
         LET l_oga.oga97 = l_oha.oha97                                                                                             
      END IF
      LET l_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
      LET l_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO oga_file VALUES(l_oga.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-650108
         LET g_success='N'
         RETURN
      END IF
      UPDATE oha_file SET oha1015='N',oha1018=l_oga.oga01
       WHERE oha01 = l_oha.oha01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","oha_file",l_oha.oha01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   LET l_ogb930=s_costcenter(l_oga.oga15) #FUN-670063

   #FUN-B90103--add--------begin-------
   IF s_industry("slk") THEN   #DEV-D30046 --add
      DECLARE t700sub_s1_c_slk CURSOR FOR SELECT * FROM ohbslk_file WHERE ohbslk01=l_oha.oha01
      FOREACH t700sub_s1_c_slk INTO l_ohbslk.*
         IF l_oha.oha05='4' THEN
            INITIALIZE l_ogbslk.* TO NULL
            SELECT MAX(ogbslk03)+1 INTO l_ogbslk03 FROM ogbslk_file
             WHERE ogbslk01=g_oga01
            IF cl_null(l_ogbslk03) OR l_ogbslk03=0 THEN
               LET l_ogbslk03=1
            END IF
            
            SELECT occ1027 INTO l_occ1027 FROM occ_file
             WHERE occ01=l_oha.oha1014
               AND occ1014='3'
            IF l_occ1027='Y' THEN
               LET g_showmsg = l_oha.oha1014,"/",'3'
               CALL s_errmsg('occ01,occ1014',g_showmsg,l_oha.oha1014,'atm-255',1)
               LET g_success='N'
            END IF
             
            IF g_sma.sma116 ='2' OR g_sma.sma116='3' THEN
               LET l_unit=l_ohbslk.ohbslk05
            ELSE
               LET l_unit=l_ohbslk.ohbslk05
            END IF
              
            IF g_aza.aza50 = "Y" OR g_azw.azw04='2' THEN
               CALL s_fetch_price_new(l_oha.oha03,l_ohbslk.ohbslk04,'',l_unit,l_oha.oha02,    #FUN-BC0071
                                      '3',l_oha.ohaplant,l_oha.oha23,l_oha.oha31,'',
                                      l_oha.oha01,l_ohbslk.ohbslk03,1,
                                      '','a')
                  RETURNING l_ohbslk.ohbslk13,l_ohbslk37
               #FUN-BC0088 ---add start -----
               IF l_ohbslk.ohbslk04[1,4] = 'MISC' THEN
                  CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'M')
               ELSE
               #FUN-BC0088 ---add end -----
                  IF l_ohbslk.ohbslk13=0 THEN
                     CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'N')
                  ELSE
                     CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'Y')
                  END IF
               END IF #FUN-BC0088
               IF l_ohbslk.ohbslk13 = 0 THEN
                  CALL cl_getmsg('atm-265',g_lang) RETURNING l_msg1
                  CALL cl_getmsg('atm-266',g_lang) RETURNING l_msg2
                  CALL cl_getmsg('atm-267',g_lang) RETURNING l_msg3
                  LET g_msg = l_msg1 CLIPPED,l_oha.oha1014,' ',
                              l_msg2 CLIPPED,l_ohbslk.ohbslk03 USING '#&',' ',
                              l_msg3 CLIPPED,l_ohbslk.ohbslk04,' ',
                              'fetch price' CLIPPED
                  CALL s_errmsg('','',g_msg,'axm-952',1)
                  LET g_success='N'
                  RETURN
               END IF
               LET l_ogbslk13 = l_ohbslk.ohbslk13
            ELSE
               LET l_ogbslk13 = l_ohbslk.ohbslk13
            END IF
         
            IF l_oha.oha213='N' THEN
               LET l_ogbslk14=l_ogbslk13*l_ohbslk.ohbslk12*l_ohbslk.ohbslk1003/100
               CALL cl_digcut(l_ogbslk14,t_azi04)  RETURNING l_ogbslk14
               LET l_ogbslk13t=l_ogbslk13*(1+l_oha.oha211/100)
               CALL cl_digcut(l_ogbslk13t,t_azi03)  RETURNING l_ogbslk13t
               LET l_ogbslk14t=l_ogbslk13t*l_ohbslk.ohbslk12*l_ohbslk.ohbslk1003/100
               CALL cl_digcut(l_ogbslk14t,t_azi04)  RETURNING l_ogbslk14t
            ELSE
               LET l_ogbslk14=l_ogbslk13*l_ohbslk.ohbslk12*l_ohbslk.ohbslk1003/100
               CALL cl_digcut(l_ogbslk14,t_azi04)  RETURNING l_ogbslk14
               LET l_ogbslk13=l_ogbslk13*(1+l_oha.oha211/100)
               CALL cl_digcut(l_ogbslk13t,t_azi03)  RETURNING l_ogbslk13t
               LET l_ogbslk14t=l_ogbslk13*l_ohbslk.ohbslk12*l_ohbslk.ohbslk1003/100
               CALL cl_digcut(l_ogbslk14t,t_azi04)  RETURNING l_ogbslk14t
            END IF
            LET l_ogbslk.ogbslk01=l_oga.oga01
            LET l_ogbslk.ogbslk03=l_ogbslk03
            LET l_ogbslk.ogbslk04=l_ohbslk.ohbslk04
            LET l_ogbslk.ogbslk05=l_ohbslk.ohbslk05
            LET l_ogbslk.ogbslk05_fac=l_ohbslk.ohbslk05_fac
            LET l_ogbslk.ogbslk06=l_ohbslk.ohbslk06
            LET l_ogbslk.ogbslk07=l_ohbslk.ohbslk07
            LET l_ogbslk.ogbslk09=l_ohbslk.ohbslk09
            LET l_ogbslk.ogbslk091=l_ohbslk.ohbslk091
            LET l_ogbslk.ogbslk092=l_ohbslk.ohbslk092
            LET l_ogbslk.ogbslk11=l_ohbslk.ohbslk11
            LET l_ogbslk.ogbslk12=l_ohbslk.ohbslk12
            LET l_ogbslk.ogbslk13=l_ogbslk13
            LET l_ogbslk.ogbslk131=0
            LET l_ogbslk.ogbslk14=l_ogbslk14
            LET l_ogbslk.ogbslk14t=l_ogbslk14t
            LET l_ogbslk.ogbslk15=l_ohbslk.ohbslk15
            LET l_ogbslk.ogbslk15_fac=l_ohbslk.ohbslk15_fac
            LET l_ogbslk.ogbslk16=l_ohbslk.ohbslk16
            LET l_ogbslk.ogbslk18=l_ohbslk.ohbslk12
            LET l_ogbslk.ogbslk60=0
            LET l_ogbslk.ogbslk63=0
            LET l_ogbslk.ogbslk64=0
            LET l_ogbslk.ogbslk1013=0
            LET l_ogbslk.ogbslk1006=100
            LET l_ogbslk.ogbslkplant = l_ohbslk.ohbslkplant
            LET l_ogbslk.ogbslklegal = l_ohbslk.ohbslklegal
            IF cl_null(l_ogbslk.ogbslk12) THEN LET l_ogbslk.ogbslk12=0 END IF
            IF cl_null(l_ogbslk.ogbslk13) THEN LET l_ogbslk.ogbslk13=0 END IF
            IF cl_null(l_ogbslk.ogbslk131) THEN LET l_ogbslk.ogbslk131=0 END IF
            IF cl_null(l_ogbslk.ogbslk14) THEN LET l_ogbslk.ogbslk14=0 END IF
            IF cl_null(l_ogbslk.ogbslk14t) THEN LET l_ogbslk.ogbslk14t=0 END IF
            IF cl_null(l_ogbslk.ogbslk16) THEN LET l_ogbslk.ogbslk16=0 END IF
            IF cl_null(l_ogbslk.ogbslk18) THEN LET l_ogbslk.ogbslk18=0 END IF
            INSERT INTO ogbslk_file VALUES(l_ogbslk.*)
            IF SQLCA.sqlcode THEN
               LET g_showmsg = l_ogbslk.ogbslk01,"/",l_ogbslk.ogbslk03
               CALL s_errmsg('ogbslk01,ogbslk03',g_showmsg,'',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
         END IF
        
         DECLARE t700sub_s1_c CURSOR FOR 
            SELECT * FROM ohb_file 
             WHERE ohb01=l_oha.oha01 
               AND ohb03 IN(SELECT ohb03 FROM ohb_file,ohbi_file 
                             WHERE ohb01=ohbi01
                               AND ohb03=ohbi03
                               AND ohbi01=l_oha.oha01 
                               AND ohbislk02=l_ohbslk.ohbslk03)
         
         CALL s_showmsg_init()   #No.FUN-710028
         
         FOREACH t700sub_s1_c INTO l_ohb.*
            IF g_success='N' THEN                                                                                                         
               LET g_totsuccess='N'                                                                                                       
               LET g_success="Y"                                                                                                          
            END IF                                                                                                                        
   
            IF STATUS THEN EXIT FOREACH END IF
            LET g_cmd= '_s1() read ohb:',l_ohb.ohb03 #FUN-840012
            CALL cl_msg(g_cmd) #FUN-840012
   
            IF l_oha.oha09 = '5' THEN  
               IF l_ohb.ohb04[1,4] != 'MISC' THEN  #MOD-820075 modify #折讓時,不產tlf_file
                  CALL saxmt700sub_update1(l_oha.*,l_ohb.*)
                  IF g_success='N' THEN RETURN END IF
               END IF  #MOD-820075 add
            ELSE
               IF l_oha.oha09 != '5' THEN   #MOD-6B0169 add
                  CALL saxmt700sub_bu1(l_oha.*,l_ohb.*)     #更新出貨單銷退量
                  IF g_success = 'N' THEN 
                     CONTINUE FOREACH       #No.FUN-710028
                  END IF
               END IF                       #MOD-6B0169 add
   
               IF cl_null(l_ohb.ohb04) THEN CONTINUE FOREACH END IF
               IF cl_null(l_ohb.ohb09) THEN LET l_ohb.ohb09=' ' END IF
               IF cl_null(l_ohb.ohb091) THEN LET l_ohb.ohb091=' ' END IF
               IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF
               IF cl_null(l_ohb.ohb16) THEN LET l_ohb.ohb16=0 END IF
          
               IF g_aza.aza50='Y' THEN
                  IF l_ohb.ohb1005='2' THEN
                     IF l_ohb.ohb1010='Y' THEN
                        UPDATE tqw_file 
                           SET tqw081=tqw081-l_ohb.ohb14t
                         WHERE tqw01=l_ohb.ohb1007
                     ELSE
                        UPDATE tqw_file 
                           SET tqw081=tqw081-l_ohb.ohb14
                         WHERE tqw01=l_ohb.ohb1007
                     END IF
                  END IF
               END IF
   
               # 非MISC的料件且銷退方式不為 5.折讓的才須異動庫存
               IF l_ohb.ohb04[1,4] != 'MISC' AND l_oha.oha09 != '5' THEN #MOD-6B0169 add oha09 !='5'
                  CALL saxmt700sub_update(l_oha.*,l_ohb.*,l_oga.oga01)
                   
                  #FUN-C50097 ADD BEG------TQC-C70206
                  #當爲大陸版,且立賬走開票流程,且不做發出商品管理
                  #IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND l_oha.oha09 = '3' THEN   #TQC-C90070 add l_oha.oha09 #MOD-CB0083 mark
                  IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' 
                     AND l_oha.oha09 NOT MATCHES '[23]' THEN  #MOD-CB0083 add
                     CALL saxmt700sub_update2(l_oha.*,l_ohb.*)
                     IF g_sma.sma115 = 'Y' THEN
                        CALL saxmt700sub_update_du2(l_oha.*,l_ohb.*)
                     END IF
                     IF g_success='N' THEN RETURN END IF          
                  END IF
                  #FUN-C50097 ADD END------        
                  IF g_success='N' THEN RETURN END IF
                  IF g_sma.sma115 = 'Y' THEN
                     CALL saxmt700sub_update_du(l_oha.*,l_ohb.*)
                  END IF
                  IF g_success='N' THEN RETURN END IF
               END IF
            END IF #MOD-810169 add
    
            IF l_oha.oha05='4' AND (l_ohb.ohb1005='1' OR l_ohb.ohb1005 IS NULL) THEN 
               INITIALIZE l_ogb.* TO NULL
               SELECT MAX(ogb03)+1 INTO l_ogb03 FROM ogb_file
                WHERE ogb01=g_oga01
               IF cl_null(l_ogb03) OR l_ogb03=0 THEN
                  LET l_ogb03=1
               END IF
               SELECT occ1027 INTO l_occ1027 FROM occ_file 
                WHERE occ01=l_oha.oha1014
                  AND occ1014='3'
               IF l_occ1027='Y' THEN
                  LET g_showmsg = l_oha.oha1014,"/",'3'    #No.FUN-710028
                  CALL s_errmsg('occ01,occ1014',g_showmsg,l_oha.oha1014,'atm-255',1)   #No.FUN-710028
                  LET g_success='N'
               END IF
               IF g_sma.sma116 ='2' OR g_sma.sma116='3' THEN
                  LET l_unit=l_ohb.ohb916
               ELSE
                  LET l_unit=l_ohb.ohb05
               END IF
               IF g_aza.aza50 = "Y" OR g_azw.azw04='2' THEN #No.FUN-870007
                  CALL s_fetch_price_new(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb69,l_unit,l_oha.oha02,         #FUN-BC0071
                                         '3',l_oha.ohaplant,l_oha.oha23,l_oha.oha31,'',
                                         l_oha.oha01,l_ohb.ohb03,l_ohb.ohb917,
                                         l_ohb.ohb1002,'a')
                     #RETURNING l_ohb.ohb13  #FUN-AB0061 mark
                     RETURNING l_ohb.ohb13,l_ohb.ohb37    #FUN-AB0061 add  
                  #FUN-B70087 mod
                  #IF l_ohb.ohb13=0 THEN CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,' ') END IF #FUN-9C0120 #FUN-B70061 暫時加' ' 
                  #FUN-BC0088 ------- add start -----
                  IF l_ohb.ohb04[1,4] = 'MISC' THEN
                     CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'M')
                  ELSE
                  #FUN-BC0088 ------- add end -----
                     IF l_ohb.ohb13=0 THEN
                        CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'N')
                     ELSE
                        CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'Y')
                     END IF
                  END IF #FUN-BC0088 add
                  #FUN-B70087 mod--end
                  IF l_ohb.ohb13 = 0 THEN
                     CALL cl_getmsg('atm-265',g_lang) RETURNING l_msg1
                     CALL cl_getmsg('atm-266',g_lang) RETURNING l_msg2
                     CALL cl_getmsg('atm-267',g_lang) RETURNING l_msg3
                     LET g_msg = l_msg1 CLIPPED,l_oha.oha1014,' ',
                                 l_msg2 CLIPPED,l_ohb.ohb03 USING '#&',' ',
                                 l_msg3 CLIPPED,l_ohb.ohb04,' ',
                                 'fetch price' CLIPPED
                     CALL s_errmsg('','',g_msg,'axm-952',1)   #NO.FUN-960130-----add------
                     LET g_success='N'
                     RETURN
                  END IF
                  LET l_ogb13 = l_ohb.ohb13 #FUN-AB0061
               ELSE
                  LET l_ogb13 = l_ohb.ohb13
                  LET l_ogb.ogb1002 = l_ohb.ohb1001
               END IF
               IF l_oha.oha213='N' THEN
                  LET l_ogb14=l_ogb13*l_ohb.ohb12*l_ohb.ohb1003/100
                  CALL cl_digcut(l_ogb14,t_azi04)  RETURNING l_ogb14    #CHI-7A0036-add
                  LET l_ogb13t=l_ogb13*(1+l_oha.oha211/100)
                  CALL cl_digcut(l_ogb13t,t_azi03)  RETURNING l_ogb13t  #CHI-7A0036-add
                  LET l_ogb14t=l_ogb13t*l_ohb.ohb12*l_ohb.ohb1003/100
                  CALL cl_digcut(l_ogb14t,t_azi04)  RETURNING l_ogb14t  #CHI-7A0036-add
               ELSE
                  LET l_ogb14=l_ogb13*l_ohb.ohb12*l_ohb.ohb1003/100
                  CALL cl_digcut(l_ogb14,t_azi04)  RETURNING l_ogb14    #CHI-7A0036-add
                  LET l_ogb13=l_ogb13*(1+l_oha.oha211/100)
                  CALL cl_digcut(l_ogb13t,t_azi03)  RETURNING l_ogb13t  #CHI-7A0036-add
                  LET l_ogb14t=l_ogb13*l_ohb.ohb12*l_ohb.ohb1003/100
                  CALL cl_digcut(l_ogb14t,t_azi04)  RETURNING l_ogb14t  #CHI-7A0036-add
               END IF
              
               LET l_ogb.ogb01=l_oga.oga01
               LET l_ogb.ogb03=l_ogb03
               LET l_ogb.ogb04=l_ohb.ohb04
               LET l_ogb.ogb05=l_ohb.ohb05    
               LET l_ogb.ogb05_fac=l_ohb.ohb05_fac  
               LET l_ogb.ogb06=l_ohb.ohb06 
               LET l_ogb.ogb910=l_ohb.ohb910
               LET l_ogb.ogb911=l_ohb.ohb911
               LET l_ogb.ogb912=l_ohb.ohb912
               LET l_ogb.ogb913=l_ohb.ohb913
               LET l_ogb.ogb914=l_ohb.ohb914
               LET l_ogb.ogb915=l_ohb.ohb915
               LET l_ogb.ogb916=l_ohb.ohb916
               LET l_ogb.ogb917=l_ohb.ohb917
               LET l_ogb.ogb911=l_ohb.ohb911
               LET l_ogb.ogb07=l_ohb.ohb07 
               LET l_ogb.ogb08=l_ohb.ohb08 
               LET l_ogb.ogb09=l_ohb.ohb09 
               LET l_ogb.ogb091=l_ohb.ohb091 
               LET l_ogb.ogb19=l_ohb.ohb61   #No.FUN-740016 
               LET l_ogb.ogb092=l_ohb.ohb092 
               LET l_ogb.ogb11=l_ohb.ohb11 
               LET l_ogb.ogb12=l_ohb.ohb12
               LET l_ogb.ogb13=l_ogb13
               LET l_ogb.ogb37=l_ohb.ohb13 #FUN-AB0061
               LET l_ogb.ogb14=l_ogb14 
               LET l_ogb.ogb14t=l_ogb14t
               LET l_ogb.ogb15=l_ohb.ohb15 
               LET l_ogb.ogb15_fac=l_ohb.ohb15_fac
               LET l_ogb.ogb16=l_ohb.ohb16
               LET l_ogb.ogb1001=l_oay19
               LET l_ogb.ogb17='N'
               LET l_ogb.ogb18=l_ohb.ohb12
               LET l_ogb.ogb60=0
               LET l_ogb.ogb63=0
               LET l_ogb.ogb64=0
               LET l_ogb.ogb1006=100
               LET l_ogb.ogb1003=l_oha.oha02
               LET l_ogb.ogb1005='1'
               LET l_ogb.ogb1012='N'
               LET l_ogb.ogb930=l_ogb930 #FUN-670063
               LET l_ogb.ogbplant = l_ohb.ohbplant
               LET l_ogb.ogblegal = l_ohb.ohblegal
               LET l_ogb.ogb44=l_ohb.ohb64
               LET l_ogb.ogb47=0 #MOD-B50039 add
               IF g_azw.azw04='2' THEN
                  LET l_ogb.ogb45=l_ohb.ohb65  
                  LET l_ogb.ogb46=l_ohb.ohb66                                                                                               
                  LET l_ogb.ogb47=l_ohb.ohb67
               END IF
               #FUN-AB0061--------add-------str-----------------
               IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN
                  LET l_ogb.ogb37 = l_ogb.ogb13
               END IF 
               #FUN-AB0061--------add-------end----------------- 
               #FUN-AB0096 --------------add start-------------
               #IF cl_null(l_ogb.ogb50) THEN
               #   LET l_ogb.ogb50 = '1'
               #END IF
               #FUN-AB0096 -------------add end-------------------
               #FUN-C50097 ADD BEGIN-----
               IF cl_null(l_ogb.ogb50) THEN 
                 LET l_ogb.ogb50 = 0
               END IF 
               IF cl_null(l_ogb.ogb51) THEN 
                 LET l_ogb.ogb51 = 0
               END IF 
               IF cl_null(l_ogb.ogb52) THEN 
                 LET l_ogb.ogb52 = 0
               END IF     
               IF cl_null(l_ogb.ogb53) THEN 
                 LET l_ogb.ogb53 = 0
               END IF 
               IF cl_null(l_ogb.ogb54) THEN 
                 LET l_ogb.ogb54 = 0
               END IF 
               IF cl_null(l_ogb.ogb55) THEN 
                 LET l_ogb.ogb55 = 0
               END IF                                          
               #FUN-C50097 ADD END-------       
               #FUN-CB0087--add--str--
               IF g_aza.aza115='Y' THEN
                  SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
                  CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
                  IF cl_null(l_ogb.ogb1001) THEN
                     CALL cl_err(l_ogb.ogb1001,'aim-425',1)
                     LET g_success="N"
                     RETURN
                  END IF
               END IF
               #FUN-CB0087--add--end--
               INSERT INTO ogb_file VALUES(l_ogb.*)
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = l_ogb.ogb01,"/",l_ogb.ogb03                #No.FUN-710028
                  CALL s_errmsg('ogb01,ogb03',g_showmsg,'',SQLCA.sqlcode,1)  #No.FUN-710028
                  LET g_success='N'
                  RETURN
               ELSE
                  #IF NOT s_industry('std') THEN   #FUN-B70061 mark
                  INITIALIZE l_ogbi.* TO NULL
                  #FUN-B90103-----------------add---------------------
                  LET l_ogbi.ogbislk01=l_ogbslk.ogbslk04     #料件編號
                  LET l_ogbi.ogbislk02=l_ogbslk.ogbslk03     #項次
                  LET l_ogbi.ogbiplant = g_plant
                  LET l_ogbi.ogbilegal = g_legal
                  #FUN-B90103-----------------end---------------------
                  LET l_ogbi.ogbi01 = l_ogb.ogb01
                  LET l_ogbi.ogbi03 = l_ogb.ogb03
                  IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
                     LET g_success = 'N'
                     RETURN
                  END IF
                  #END IF   #FUN-B70061 mark
               END IF
               CALL saxmt700sub_update_7(l_oha.*,l_oga.*,l_ogb.*) 
               IF g_success='N' THEN
                  RETURN
               END IF
               IF g_sma.sma115='Y'  THEN
                  SELECT ima906 INTO g_ima906 FROM ima_file
                   WHERE ima01=l_ogb.ogb04
                  IF g_ima906='2' THEN
                     IF NOT cl_null(l_ogb.ogb913) THEN
                        CALL saxmt700sub_upd_imgg_oh('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,-1,'2',l_oga.oga02)
                        IF g_success='N' THEN RETURN END IF
                        IF NOT cl_null(l_ogb.ogb915) THEN                               #CHI-860005         
                           CALL saxmt700sub_tlff_oh('2',l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*)
                           IF g_success='N' THEN RETURN END IF
                        END IF
                     END IF
                     IF NOT cl_null(l_ogb.ogb910) THEN
                        CALL saxmt700sub_upd_imgg_oh('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,-1,'1',l_oga.oga02)
                        IF g_success='N' THEN RETURN END IF
                        IF NOT cl_null(l_ogb.ogb912) THEN                               #CHI-860005
                           CALL saxmt700sub_tlff_oh('1',l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,l_oga.*,l_ogb.*)
                           IF g_success='N' THEN RETURN END IF
                        END IF
                     END IF
                  END IF
                  IF g_ima906='3' THEN
                     IF NOT cl_null(l_ogb.ogb913) THEN
                       CALL saxmt700sub_upd_imgg_oh('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,-1,'2',l_oga.oga02)
                       IF g_success='N' THEN RETURN END IF
                       IF NOT cl_null(l_ogb.ogb915) THEN                                #CHI-860005
                          CALL saxmt700sub_tlff_oh('2',l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*)
                          IF g_success='N' THEN RETURN END IF
                       END IF
                     END IF
                  END IF
                  IF g_success='N' THEN RETURN END IF
                  LET l_oga50=l_oga.oga50+l_ogb.ogb14
                  LET l_oga51=l_oga.oga51+l_ogb.ogb14t
                  LET l_oga53=l_oga.oga53+l_ogb.ogb14        
                  LET l_oga501=l_oga.oga501+l_ogb.ogb14*l_oha.oha24
                  LET l_oga511=l_oga.oga511+l_ogb.ogb14t*l_oha.oha24
                  UPDATE oga_file SET oga50=l_oga50,
                                      oga51=l_oga51,
                                      oga53=l_oga53,
                                      oga501=l_oga501,
                                      oga511=l_oga511
                   WHERE oga01=l_oga.oga01
                  IF SQLCA.sqlcode THEN
                     LET g_success='N'
                     RETURN
                  END IF
               END IF
            END IF
         END FOREACH
         IF l_oha.oha05='4'  THEN
            CALL saxmt700sub_update_ogbslk(l_ogbslk.ogbslk03,l_oga.oga01)  #回寫數量和金額
         END IF 
      END FOREACH  #FUN-B90103--add
   #FUN-B90103-------------end-------------------
   ELSE   #DEV-D30046 --add
      DECLARE t700sub_s1_c2 CURSOR FOR SELECT * FROM ohb_file WHERE ohb01=l_oha.oha01
   
      CALL s_showmsg_init()   #No.FUN-710028
   
      FOREACH t700sub_s1_c2 INTO l_ohb.*
         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        
  
         IF STATUS THEN EXIT FOREACH END IF
         LET g_cmd= '_s1() read ohb:',l_ohb.ohb03 #FUN-840012
         CALL cl_msg(g_cmd) #FUN-840012
  
         IF l_oha.oha09 = '5' THEN  
            IF l_ohb.ohb04[1,4] != 'MISC' THEN  #MOD-820075 modify #折讓時,不產tlf_file
               CALL saxmt700sub_update1(l_oha.*,l_ohb.*)
               IF g_success='N' THEN RETURN END IF
            END IF  #MOD-820075 add
         ELSE
            IF l_oha.oha09 != '5' THEN   #MOD-6B0169 add
               CALL saxmt700sub_bu1(l_oha.*,l_ohb.*)     #更新出貨單銷退量
               IF g_success = 'N' THEN 
                  CONTINUE FOREACH       #No.FUN-710028
               END IF
            END IF                       #MOD-6B0169 add
  
            IF cl_null(l_ohb.ohb04) THEN CONTINUE FOREACH END IF
            IF cl_null(l_ohb.ohb09) THEN LET l_ohb.ohb09=' ' END IF
            IF cl_null(l_ohb.ohb091) THEN LET l_ohb.ohb091=' ' END IF
            IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF
            IF cl_null(l_ohb.ohb16) THEN LET l_ohb.ohb16=0 END IF
            
            IF g_aza.aza50='Y' THEN
               IF l_ohb.ohb1005='2' THEN
                  IF l_ohb.ohb1010='Y' THEN
                     UPDATE tqw_file 
                        SET tqw081=tqw081-l_ohb.ohb14t
                      WHERE tqw01=l_ohb.ohb1007
                  ELSE
                     UPDATE tqw_file 
                        SET tqw081=tqw081-l_ohb.ohb14
                      WHERE tqw01=l_ohb.ohb1007
                  END IF
               END IF
            END IF
            
            # 非MISC的料件且銷退方式不為 5.折讓的才須異動庫存
            IF l_ohb.ohb04[1,4] != 'MISC' AND l_oha.oha09 != '5' THEN #MOD-6B0169 add oha09 !='5'
               IF s_industry('icd') THEN   #FUN-B70061 mark  #DEV-D30046 --add
                  #TQC-B80005 --START--
                  SELECT * INTO l_ohbi.* FROM ohbi_file
                   WHERE ohbi01 = l_ohb.ohb01 AND ohbi03 = l_ohb.ohb03  
                  #TQC-B80005 --END--
                  CALL s_icdpost(1,l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                                 l_ohb.ohb092,l_ohb.ohb05,l_ohb.ohb12,
                                 l_ohb.ohb01,l_ohb.ohb03,l_oha.oha02,'Y',
                                 l_ohb.ohb31,l_ohb.ohb32,l_ohbi.ohbiicd029,l_ohbi.ohbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                     RETURNING l_flag
                  IF l_flag = 0 THEN
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF   #FUN-B70061 mark  #DEV-D30046 --add
               
               CALL saxmt700sub_update(l_oha.*,l_ohb.*,l_oga.oga01)
                
               #FUN-C50097 ADD BEG------TQC-C70206
               #當爲大陸版,且立賬走開票流程,且不做發出商品管理
               #IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND l_oha.oha09 = '3' THEN   #TQC-C90070 add l_oha.oha09 #MOD-CB0083 mark
               IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' 
                  AND l_oha.oha09 NOT MATCHES '[23]' THEN  #MOD-CB0083 add
                  CALL saxmt700sub_update2(l_oha.*,l_ohb.*)
                  IF g_sma.sma115 = 'Y' THEN
                     CALL saxmt700sub_update_du2(l_oha.*,l_ohb.*)
                  END IF
                  IF g_success='N' THEN RETURN END IF          
               END IF
               #FUN-C50097 ADD END------        
               IF g_success='N' THEN RETURN END IF
               IF g_sma.sma115 = 'Y' THEN
                  CALL saxmt700sub_update_du(l_oha.*,l_ohb.*)
               END IF
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF #MOD-810169 add
    
         IF l_oha.oha05='4' AND (l_ohb.ohb1005='1' OR l_ohb.ohb1005 IS NULL) THEN 
            INITIALIZE l_ogb.* TO NULL
            SELECT MAX(ogb03)+1 INTO l_ogb03 FROM ogb_file
             WHERE ogb01=g_oga01
            IF cl_null(l_ogb03) OR l_ogb03=0 THEN
               LET l_ogb03=1
            END IF
            SELECT occ1027 INTO l_occ1027 FROM occ_file 
             WHERE occ01=l_oha.oha1014
               AND occ1014='3'
            IF l_occ1027='Y' THEN
               LET g_showmsg = l_oha.oha1014,"/",'3'    #No.FUN-710028
               CALL s_errmsg('occ01,occ1014',g_showmsg,l_oha.oha1014,'atm-255',1)   #No.FUN-710028
               LET g_success='N'
            END IF
            IF g_sma.sma116 ='2' OR g_sma.sma116='3' THEN
               LET l_unit=l_ohb.ohb916
            ELSE
               LET l_unit=l_ohb.ohb05
            END IF
            IF g_aza.aza50 = "Y" OR g_azw.azw04='2' THEN #No.FUN-870007
               CALL s_fetch_price_new(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb69,l_unit,l_oha.oha02,         #FUN-BC0071
                                      '3',l_oha.ohaplant,l_oha.oha23,l_oha.oha31,'',
                                      l_oha.oha01,l_ohb.ohb03,l_ohb.ohb917,
                                      l_ohb.ohb1002,'a')
                  #RETURNING l_ohb.ohb13  #FUN-AB0061 mark
                  RETURNING l_ohb.ohb13,l_ohb.ohb37    #FUN-AB0061 add  
               #FUN-B70087 mod
               #IF l_ohb.ohb13=0 THEN CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,' ') END IF #FUN-9C0120 #FUN-B70061 暫時加' ' 
               #FUN-BC0088 ------- add start -----
               IF l_ohb.ohb04[1,4] = 'MISC' THEN
                  CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'M')
               ELSE
               #FUN-BC0088 ------- add end -----
                  IF l_ohb.ohb13=0 THEN
                     CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'N')
                  ELSE
                     CALL s_unitprice_entry(l_oha.oha03,l_oha.oha31,l_oha.ohaplant,'Y')
                  END IF
               END IF #FUN-BC0088 add
               #FUN-B70087 mod--end
               IF l_ohb.ohb13 = 0 THEN
                  CALL cl_getmsg('atm-265',g_lang) RETURNING l_msg1
                  CALL cl_getmsg('atm-266',g_lang) RETURNING l_msg2
                  CALL cl_getmsg('atm-267',g_lang) RETURNING l_msg3
                  LET g_msg = l_msg1 CLIPPED,l_oha.oha1014,' ',
                              l_msg2 CLIPPED,l_ohb.ohb03 USING '#&',' ',
                              l_msg3 CLIPPED,l_ohb.ohb04,' ',
                              'fetch price' CLIPPED
                  CALL s_errmsg('','',g_msg,'axm-952',1)   #NO.FUN-960130-----add------
                  LET g_success='N'
                  RETURN
               END IF
               LET l_ogb13 = l_ohb.ohb13 #FUN-AB0061
            ELSE
               LET l_ogb13 = l_ohb.ohb13
               LET l_ogb.ogb1002 = l_ohb.ohb1001
            END IF
            IF l_oha.oha213='N' THEN
               LET l_ogb14=l_ogb13*l_ohb.ohb12*l_ohb.ohb1003/100
               CALL cl_digcut(l_ogb14,t_azi04)  RETURNING l_ogb14    #CHI-7A0036-add
               LET l_ogb13t=l_ogb13*(1+l_oha.oha211/100)
               CALL cl_digcut(l_ogb13t,t_azi03)  RETURNING l_ogb13t  #CHI-7A0036-add
               LET l_ogb14t=l_ogb13t*l_ohb.ohb12*l_ohb.ohb1003/100
               CALL cl_digcut(l_ogb14t,t_azi04)  RETURNING l_ogb14t  #CHI-7A0036-add
            ELSE
               LET l_ogb14=l_ogb13*l_ohb.ohb12*l_ohb.ohb1003/100
               CALL cl_digcut(l_ogb14,t_azi04)  RETURNING l_ogb14    #CHI-7A0036-add
               LET l_ogb13=l_ogb13*(1+l_oha.oha211/100)
               CALL cl_digcut(l_ogb13t,t_azi03)  RETURNING l_ogb13t  #CHI-7A0036-add
               LET l_ogb14t=l_ogb13*l_ohb.ohb12*l_ohb.ohb1003/100
               CALL cl_digcut(l_ogb14t,t_azi04)  RETURNING l_ogb14t  #CHI-7A0036-add
            END IF
           
            LET l_ogb.ogb01=l_oga.oga01
            LET l_ogb.ogb03=l_ogb03
            LET l_ogb.ogb04=l_ohb.ohb04
            LET l_ogb.ogb05=l_ohb.ohb05    
            LET l_ogb.ogb05_fac=l_ohb.ohb05_fac  
            LET l_ogb.ogb06=l_ohb.ohb06 
            LET l_ogb.ogb910=l_ohb.ohb910
            LET l_ogb.ogb911=l_ohb.ohb911
            LET l_ogb.ogb912=l_ohb.ohb912
            LET l_ogb.ogb913=l_ohb.ohb913
            LET l_ogb.ogb914=l_ohb.ohb914
            LET l_ogb.ogb915=l_ohb.ohb915
            LET l_ogb.ogb916=l_ohb.ohb916
            LET l_ogb.ogb917=l_ohb.ohb917
            LET l_ogb.ogb911=l_ohb.ohb911
            LET l_ogb.ogb07=l_ohb.ohb07 
            LET l_ogb.ogb08=l_ohb.ohb08 
            LET l_ogb.ogb09=l_ohb.ohb09 
            LET l_ogb.ogb091=l_ohb.ohb091 
            LET l_ogb.ogb19=l_ohb.ohb61   #No.FUN-740016 
            LET l_ogb.ogb092=l_ohb.ohb092 
            LET l_ogb.ogb11=l_ohb.ohb11 
            LET l_ogb.ogb12=l_ohb.ohb12
            LET l_ogb.ogb13=l_ogb13
            LET l_ogb.ogb37=l_ohb.ohb13 #FUN-AB0061
            LET l_ogb.ogb14=l_ogb14 
            LET l_ogb.ogb14t=l_ogb14t
            LET l_ogb.ogb15=l_ohb.ohb15 
            LET l_ogb.ogb15_fac=l_ohb.ohb15_fac
            LET l_ogb.ogb16=l_ohb.ohb16
            LET l_ogb.ogb1001=l_oay19
            LET l_ogb.ogb17='N'
            LET l_ogb.ogb18=l_ohb.ohb12
            LET l_ogb.ogb60=0
            LET l_ogb.ogb63=0
            LET l_ogb.ogb64=0
            LET l_ogb.ogb1006=100
            LET l_ogb.ogb1003=l_oha.oha02
            LET l_ogb.ogb1005='1'
            LET l_ogb.ogb1012='N'
            LET l_ogb.ogb930=l_ogb930 #FUN-670063
            LET l_ogb.ogbplant = l_ohb.ohbplant
            LET l_ogb.ogblegal = l_ohb.ohblegal
            LET l_ogb.ogb44=l_ohb.ohb64
            LET l_ogb.ogb47=0 #MOD-B50039 add
            IF g_azw.azw04='2' THEN
               LET l_ogb.ogb45=l_ohb.ohb65  
               LET l_ogb.ogb46=l_ohb.ohb66                                                                                               
               LET l_ogb.ogb47=l_ohb.ohb67
            END IF
            #FUN-AB0061--------add-------str-----------------
            IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN
               LET l_ogb.ogb37 = l_ogb.ogb13
            END IF 
            #FUN-AB0061--------add-------end----------------- 
            #FUN-AB0096 --------------add start-------------
            #IF cl_null(l_ogb.ogb50) THEN
            #   LET l_ogb.ogb50 = '1'
            #END IF
            #FUN-AB0096 -------------add end-------------------
            #FUN-C50097 ADD BEGIN-----
            IF cl_null(l_ogb.ogb50) THEN 
              LET l_ogb.ogb50 = 0
            END IF 
            IF cl_null(l_ogb.ogb51) THEN 
              LET l_ogb.ogb51 = 0
            END IF 
            IF cl_null(l_ogb.ogb52) THEN 
              LET l_ogb.ogb52 = 0
            END IF     
            IF cl_null(l_ogb.ogb53) THEN 
              LET l_ogb.ogb53 = 0
            END IF 
            IF cl_null(l_ogb.ogb54) THEN 
              LET l_ogb.ogb54 = 0
            END IF 
            IF cl_null(l_ogb.ogb55) THEN 
              LET l_ogb.ogb55 = 0
            END IF                                          
            #FUN-C50097 ADD END-------       
            #FUN-CB0087--add--str--
            IF g_aza.aza115='Y' THEN
               SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
               CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
               IF cl_null(l_ogb.ogb1001) THEN
                  CALL cl_err(l_ogb.ogb1001,'aim-425',1)
                  LET g_success="N"
                  RETURN
               END IF
            END IF
            #FUN-CB0087--add--end--
            INSERT INTO ogb_file VALUES(l_ogb.*)
            IF SQLCA.sqlcode THEN
               LET g_showmsg = l_ogb.ogb01,"/",l_ogb.ogb03                #No.FUN-710028
               CALL s_errmsg('ogb01,ogb03',g_showmsg,'',SQLCA.sqlcode,1)  #No.FUN-710028
               LET g_success='N'
               RETURN
            ELSE
               IF NOT s_industry('std') THEN   #FUN-B70061 mark  #DEV-D30046 --add
                  INITIALIZE l_ogbi.* TO NULL
                  LET l_ogbi.ogbi01 = l_ogb.ogb01
                  LET l_ogbi.ogbi03 = l_ogb.ogb03
                  IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF   #FUN-B70061 mark   #DEV-D30046 --add
            END IF
            CALL saxmt700sub_update_7(l_oha.*,l_oga.*,l_ogb.*) 
            IF g_success='N' THEN
               RETURN
            END IF
            IF g_sma.sma115='Y'  THEN
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01=l_ogb.ogb04
               IF g_ima906='2' THEN
                  IF NOT cl_null(l_ogb.ogb913) THEN
                     CALL saxmt700sub_upd_imgg_oh('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,-1,'2',l_oga.oga02)
                     IF g_success='N' THEN RETURN END IF
                     IF NOT cl_null(l_ogb.ogb915) THEN                               #CHI-860005         
                        CALL saxmt700sub_tlff_oh('2',l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*)
                        IF g_success='N' THEN RETURN END IF
                     END IF
                  END IF
                  IF NOT cl_null(l_ogb.ogb910) THEN
                     CALL saxmt700sub_upd_imgg_oh('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,-1,'1',l_oga.oga02)
                     IF g_success='N' THEN RETURN END IF
                     IF NOT cl_null(l_ogb.ogb912) THEN                               #CHI-860005
                        CALL saxmt700sub_tlff_oh('1',l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,l_oga.*,l_ogb.*)
                        IF g_success='N' THEN RETURN END IF
                     END IF
                  END IF
               END IF
               IF g_ima906='3' THEN
                  IF NOT cl_null(l_ogb.ogb913) THEN
                    CALL saxmt700sub_upd_imgg_oh('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,-1,'2',l_oga.oga02)
                    IF g_success='N' THEN RETURN END IF
                    IF NOT cl_null(l_ogb.ogb915) THEN                                #CHI-860005
                       CALL saxmt700sub_tlff_oh('2',l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*)
                       IF g_success='N' THEN RETURN END IF
                    END IF
                  END IF
               END IF
               IF g_success='N' THEN RETURN END IF
               LET l_oga50=l_oga.oga50+l_ogb.ogb14
               LET l_oga51=l_oga.oga51+l_ogb.ogb14t
               LET l_oga53=l_oga.oga53+l_ogb.ogb14        
               LET l_oga501=l_oga.oga501+l_ogb.ogb14*l_oha.oha24
               LET l_oga511=l_oga.oga511+l_ogb.ogb14t*l_oha.oha24
               UPDATE oga_file SET oga50=l_oga50,
                                   oga51=l_oga51,
                                   oga53=l_oga53,
                                   oga501=l_oga501,
                                   oga511=l_oga511
                WHERE oga01=l_oga.oga01
               IF SQLCA.sqlcode THEN
                  LET g_success='N'
                  RETURN
               END IF
            END IF
         END IF
      END FOREACH
   END IF    #DEV-D30046 --add
   
   #FUN-B90103--start--
   IF NOT s_industry('slk') THEN   #DEV-D30046 --add
      DECLARE t700sub_s1_c_ohbslk CURSOR FOR 
         SELECT * FROM ohbslk_file WHERE ohbslk01=l_oha.oha01
       #CALL s_showmsg_init()   #No.FUN-710028   #MOD-FB0135 mark
      FOREACH t700sub_s1_c_ohbslk INTO l_ohbslk.*
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
         IF STATUS THEN EXIT FOREACH END IF
         IF l_oha.oha09 != '5' THEN
            CALL saxmt700sub_bu2(l_oha.*,l_ohbslk.*)    #更新訂單和出貨單
            IF g_success = 'N' THEN
               CONTINUE FOREACH
            END IF 
         END IF
      END FOREACH 
   END IF    #DEV-D30046 --add
   #FUN-B90103--end-- 

   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
   IF l_oha.oha05='4' THEN    
      IF g_success = 'Y' THEN
         #出貨單都過帳及產生tlf_file了,故這里要把ogapost置為Y
         UPDATE oga_file SET ogapost='Y'
          WHERE oga01 = l_oga.oga01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('oga01',l_oga.oga01,'',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF 
      END IF
   END IF
END FUNCTION

#此FUN僅DIS使用,因在過帳段使用,所以納入Global
FUNCTION saxmt700sub_ar(p_oga01,p_oha09)
   DEFINE p_oga01    LIKE oga_file.oga01      #DEV-D30046 --add
   DEFINE p_oha09    LIKE oha_file.oha09      #DEV-D30046 --add
   DEFINE l_oga      RECORD LIKE oga_file.*   #DEV-D30046 --add

   SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01  #DEV-D30046 --add   
   
   IF l_oga.ogaconf='N' THEN 
      CALL cl_err('conf=N','aap-717',0) RETURN 
   END IF
   IF l_oga.ogapost='N' THEN 
      CALL cl_err('post=N','aim-206',0) RETURN 
   END IF
   IF l_oga.oga10 IS NOT NULL THEN RETURN END IF
   IF l_oga.oga00 MATCHES '[23]'THEN
      CALL cl_err(p_oha09,'axr-063',0)
      RETURN
   END IF
   LET g_msg="axrp310 ",
             " '",l_oga.oga01,"'",
             " '",l_oga.oga02,"'",
             " '",l_oga.oga05,"' '",
                  l_oga.oga212,"'"
   CALL cl_cmdrun_wait(g_msg)
END FUNCTION 

FUNCTION saxmt700sub_update(l_oha,l_ohb,p_oga01)
   DEFINE l_oha       RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb       RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE p_oga01     LIKE oga_file.oga01      #DEV-D30046 --add
   DEFINE l_qty       LIKE img_file.img10,
          l_ima01     LIKE ima_file.ima01,
          l_ima25     LIKE ima_file.ima25,
          p_img       RECORD LIKE img_file.*,
          l_img       RECORD
             l_img01     LIKE img_file.img01,  # No.FUN-680137 INT    #No.TQC-940183  #No.TQC-950134
             img10       LIKE img_file.img10,
             img16       LIKE img_file.img16,
             img23       LIKE img_file.img23,
             img24       LIKE img_file.img24,
             img09       LIKE img_file.img09,
             img21       LIKE img_file.img21
                      END RECORD,
          l_cnt       LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_ima71     LIKE ima_file.ima71
   DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
   DEFINE l_occ31     LIKE occ_file.occ31
   #DEFINE l_adq06     LIKE adq_file.adq06   #MOD-CB0111 mark
   #DEFINE l_adp05     LIKE adp_file.adp05   #MOD-CB0111 mark
   #DEFINE l_adq07     LIKE adq_file.adq07   #MOD-CB0111 mark
   DEFINE l_tuq06     LIKE tuq_file.tuq06                                           
   DEFINE l_tup05     LIKE tup_file.tup05                                           
   #DEFINE l_tup08     LIKE tup_file.tup08 #CHI-B40056 mark                                          
   DEFINE l_tup11     LIKE tup_file.tup11 #CHI-B40056                                          
   DEFINE l_tuq07     LIKE tuq_file.tuq07                                           
   DEFINE l_tuq11     LIKE tuq_file.tuq11                                           
   DEFINE l_tuq12     LIKE tuq_file.tuq12      
   DEFINE l_desc      LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
   DEFINE i           LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_tup06     LIKE tup_file.tup06    #MOD-B30651 add                                       
   #TQC-C20183--add--start--
   DEFINE l_tup05_1   LIKE tup_file.tup05,
          l_tuq07_1   LIKE tuq_file.tuq07,
          l_tuq09_1   LIKE tuq_file.tuq09
   #TQC-C20183--add--end--
   DEFINE l_adq07_1   LIKE adq_file.adq07   #No.TQC-C20183
   DEFINE l_adq09_1   LIKE adq_file.adq09   #No.TQC-C20183
   DEFINE l_forupd_sql   STRING                #DEV-D30046 --add
   DEFINE l_oga       RECORD LIKE oga_file.*   #DEV-D30046 --add
   
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01   #DEV-D30046 --add
   
   #FUN-AB0059 ---------------------start---------------------------- 
   IF s_joint_venture( l_ohb.ohb04,g_plant) OR NOT s_internal_item( l_ohb.ohb04,g_plant ) THEN
      RETURN
   END IF
   #FUN-AB0059 ---------------------end------------------------------- 
   
   #MOD-BC0033 ----- modify start -----
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM img_file
    WHERE img01=l_ohb.ohb04 AND img02=l_ohb.ohb09
      AND img03=l_ohb.ohb091 AND img04=l_ohb.ohb092
   IF l_cnt = 0 THEN
   #IF l_ohb.ohb15 IS NULL THEN
   #MOD-BC0033 -----  modify end  -----
      INITIALIZE p_img.* TO NULL
      LET p_img.img01=l_ohb.ohb04
      LET p_img.img02=l_ohb.ohb09
      LET p_img.img03=l_ohb.ohb091
      LET p_img.img04=l_ohb.ohb092
      LET p_img.img09=l_ohb.ohb05
      LET p_img.img10=0
      LET p_img.img21=1
      LET p_img.img23='Y'
      LET p_img.img24='N'
      LET p_img.imgplant=g_plant    #FUN-B90103--add
      LET p_img.imglegal=g_legal    #FUN-B90103--add
      LET l_ohb.ohb15=l_ohb.ohb05
             
      #IF s_internal_item( p_img.img01,g_plant ) AND NOT s_joint_venture( p_img.img01 ,g_plant) THEN  #FUN-A90049 add     #FUN-AB0059 mark
      INSERT INTO img_file VALUES(p_img.*)
      IF STATUS THEN
         LET g_showmsg = p_img.img01,"/",p_img.img02,"/",p_img.img03,"/",p_img.img04        #No.FUN-710028
         CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'l_ohb.ohb15 null:','axm-186',1) #No.FUN-710028
         LET g_success = 'N'
         RETURN
      END IF
      #END IF              #FUN-A90049 add       #FUN-AB0059 mark
   END IF
   
   LET l_forupd_sql = "SELECT img01,img10,img16,img23,img24,img09,img21",
                      " FROM img_file ",
                      "  WHERE img01= ? AND img02= ? AND img03= ? ",
                      " AND img04= ?  FOR UPDATE "                     #no.TQC-750149
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE img_lock CURSOR FROM l_forupd_sql
   OPEN img_lock USING l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092
   IF STATUS THEN
      LET g_showmsg = l_ohb.ohb04,"/",l_ohb.ohb09,"/",l_ohb.ohb091,"/",l_ohb.ohb092  #No.FUN-710028
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'lock img fail',STATUS,1)    #No.FUN-710028
      LET g_success='N' RETURN
   END IF
 
   FETCH img_lock INTO l_img.*
   IF STATUS THEN
      LET g_showmsg = l_ohb.ohb04,"/",l_ohb.ohb09,"/",l_ohb.ohb091,"/",l_ohb.ohb092  #MOD-920056
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'lock img fail',STATUS,1)    #MOD-920056
      LET g_success='N' RETURN
   END IF
   
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 + l_ohb.ohb16
   CALL s_upimg(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,+1,l_ohb.ohb16,g_today, #FUN-8C0084
         '','','','',l_ohb.ohb01,l_ohb.ohb03,'','','','','','','','','','','','')  #NO.FUN-860025
   IF g_success='N' THEN
      CALL s_errmsg('','','s_upimg()','9050',0) RETURN  #No.FUN-710028
   END IF

   LET l_forupd_sql ="SELECT ima25,ima86 FROM ima_file ",
                     " WHERE ima01= ?  FOR UPDATE"       #no.TQC-750149
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock CURSOR FROM l_forupd_sql
   OPEN ima_lock USING l_ohb.ohb04
   IF STATUS THEN
      CALL s_errmsg('ima01',l_ohb.ohb04,'lock ima fail',STATUS,1)       #No.FUN-710028
      LET g_success='N' RETURN
   END IF
   FETCH ima_lock INTO l_ima25,g_ima86
   IF STATUS THEN
      CALL s_errmsg('','','lock ima fail',STATUS,1) LET g_success='N' RETURN    #No.FUN-710028
   END IF
                 #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   Call s_udima(l_ohb.ohb04,l_img.img23,l_img.img24,l_ohb.ohb16*l_img.img21,
                   #g_today,+1)  RETURNING l_cnt   #MOD-920298
                   l_oha.oha02,+1)  RETURNING l_cnt   #MOD-920298
        #最近一次發料日期 表發料
   IF l_cnt THEN
      CALL s_errmsg('','','Update Faile',SQLCA.SQLCODE,1)  #No.FUN-710028
      LET g_success='N' RETURN
   END IF
   IF g_success='Y' THEN
      CALL saxmt700sub_tlf(l_ima25,l_qty,l_oha.*,l_ohb.*)
   END IF
   IF g_success = 'N' THEN RETURN END IF
   
   SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=l_oha.oha03
   IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
   IF l_occ31 = 'N' THEN RETURN END IF    #occ31=.w&s:^2z'_
   
   SELECT ima25,ima71 INTO l_ima25,l_ima71
     FROM ima_file WHERE ima01=l_ohb.ohb04
   IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
   #MOD-B30651 add --start--
   IF l_ima71 = 0 THEN 
      LET l_tup06 = g_lastdat
   ELSE 
      LET l_tup06 = l_oha.oha02 + l_ima71
   END IF
   #MOD-B30651 add --end--
   
   #IF g_aza.aza50='Y' THEN      #MOD-CB0111 mark
       IF l_oga.oga00='7' THEN
          LET l_tuq11='2'
       ELSE
          LET l_tuq11='1'
       END IF
   #END IF                       #MOD-CB0111 mark
   
   #IF g_aza.aza50='Y' THEN      #MOD-CB0111 mark
      SELECT COUNT(*) INTO i FROM tuq_file                                        
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                             
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                             
         AND tuq11=l_tuq11 AND tuq12=l_oha.oha04
         AND tuq05=l_oha.oha01 AND tuq051=l_ohb.ohb03   #MOD-CB0111 add
   #MOD-CB0111 -- mark start --
   #ELSE
   #  SELECT COUNT(*) INTO i FROM adq_file
   #   WHERE adq01=l_oha.oha03  AND adq02=l_ohb.ohb04
   #    AND adq03=l_ohb.ohb092 AND adq04=l_oha.oha02
   #END IF  #No.FUN-650108
   #MOD-CB0111 -- mark end --
   IF i=0 THEN
      LET l_fac1=1
      IF l_ohb.ohb05 <> l_ima25 THEN
         CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
              RETURNING l_cnt,l_fac1
         IF l_cnt = '1'  THEN
            CALL s_errmsg('','',l_ohb.ohb04,'abm-731',0)   #No.FUN-710028
            LET l_fac1=1
         END IF
      END IF
   #IF g_aza.aza50='Y' THEN   #MOD-CB0111 mark
      LET l_tuq09_1 = l_ohb.ohb12*l_fac1*-1           #TQC-C20183 --add--
      LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)     #TQC-C20183 --add--
      INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,                      
                           tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,tuqplant,tuqlegal)  #FUN-980010 add tuqplant,tuqlegal
      VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,l_ohb.ohb03,     #No.TQC-640125
            #l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_ohb.ohb12*l_fac1*-1,'2',l_tuq11,l_oha.oha04,g_plant,g_legal) #FUN-980010 add g_plant,g_legal   #TQC-C20183 --mark-- 
             l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_tuq09_1,'2',l_tuq11,l_oha.oha04,g_plant,g_legal) #TQC-C20183 --add--
      IF SQLCA.sqlcode THEN                                                    
         LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_oha.oha02,"/",l_tuq11,"/",l_oha.oha04  #No.FUN-710028
         CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'insert tuq_file',SQLCA.sqlcode,1)          #No.FUN-710028
         LET g_success ='N'                                                    
         RETURN                                                                
      END IF       
   #MOD-CB0111 -- mark start --
   #ELSE
   #  INSERT INTO adq_file(adq01,adq02,adq03,adq04,adq05,
   #                       adq06,adq07,adq08,adq09,adq10)
   #  VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,
   #         l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_ohb.ohb12*l_fac1*-1,'2')
   #  IF SQLCA.sqlcode THEN
   #     LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_oha.oha02           #No.FUN-710028
   #     CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'insert adq_file',SQLCA.sqlcode,1)   #No.FUN-710028
   #     LET g_success ='N'
   #     RETURN
   #  END IF
   #END IF   #NO.FUN-650108
   #MOD-CB0111 -- mark end --
   ELSE
   #IF g_aza.aza50='Y' THEN   #MOD-CB0111 mark
      SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file                           
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04         
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                          
         AND tuq11=l_tuq11 and tuq12=l_oha.oha04
         AND tuq05=l_oha.oha01 AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
      IF SQLCA.sqlcode THEN                                                    
         LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_oha.oha02,"/",l_tuq11,"/",l_oha.oha04  #No.FUN-710028
         CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'select tuq06',SQLCA.sqlcode,1)             #No.FUN-650108
         LET g_success ='N'                                                    
         RETURN                                                                
      END IF        
   #MOD-CB0111 -- mark start--
   #ELSE   
   #  SELECT UNIQUE adq06 INTO l_adq06 FROM adq_file
   #   WHERE adq01=l_oha.oha03  AND adq02=l_ohb.ohb04
   #     AND adq03=l_ohb.ohb092 AND adq04=l_oha.oha02
   #  #&],0key-H*:-l&],&P$@KEY-H*:%u/`+O/d$@-S-l)l3f&l
   #  IF SQLCA.sqlcode THEN
   #     CALL cl_err3("sel","adq_file","","",SQLCA.sqlcode,"","select adq06",1)  #No.FUN-650108
   #     LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_oha.oha02        #No.FUN-710028
   #     CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'select adq06',SQLCA.sqlcode,1)   #No.FUN-710028
   #     LET g_success ='N'
   #     RETURN
   #  END IF
   #END IF  #NO.FUN-650108
   #MOD-CB0111 -- mark end--
   LET l_fac1=1
   #IF g_aza.aza50='Y' THEN   #MOD-CB0111 mark
       IF l_ohb.ohb05 <> l_tuq06 THEN                                           
         CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)                        
              RETURNING l_cnt,l_fac1                                           
          IF l_cnt = '1'  THEN            
            CALL s_errmsg('','',l_ohb.ohb04,'abm-731',0)   #No.FUN-710028                            
            LET l_fac1=1                                                       
          END IF                                                                
       END IF               
      SELECT tuq07 INTO l_tuq07 FROM tuq_file                                  
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                          
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                          
         AND tuq11=l_tuq11 AND tuq12=l_oha.oha04
         AND tuq05=l_oha.oha01 AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
      IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF                            
      IF l_tuq07-l_ohb.ohb12*l_fac1<0 THEN                                     
         LET l_desc='2'                                                        
      ELSE                                                                     
         LET l_desc='1'                                                        
      END IF   
      IF l_tuq07=l_ohb.ohb12*l_fac1 THEN                                       
         DELETE FROM tuq_file                                                  
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                       
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                       
            AND tuq11=l_tuq11 AND tuq12=l_oha.oha04
            AND tuq05=l_oha.oha01 AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN                                                 
            LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_oha.oha02,"/",l_tuq11,"/",l_oha.oha04  #No.FUN-710028
            CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'delete tuq_file',SQLCA.sqlcode,1)          #No.FUN-710028
            LET g_success='N'                                                  
            RETURN                                                             
         END IF                         
      ELSE                                                                     
         LET l_fac2=1                                                          
         IF l_tuq06 <> l_ima25 THEN                                            
            CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)                         
                 RETURNING l_cnt,l_fac2                                        
            IF l_cnt = '1'  THEN                                               
               CALL s_errmsg('','',l_ohb.ohb04,'abm-731',0)  #No.FUN-710028                        
               LET l_fac2=1                                                    
            END IF                                                             
         END IF              
         LET l_tuq07_1 = l_ohb.ohb12*l_fac1              #TQC-C20183 --add--
         LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)     #TQC-C20183 --add-
         LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2       #TQC-C20183 --add--
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)     #TQC-C20183 --add-                                                  
      #  UPDATE tuq_file SET tuq07=tuq07-l_ohb.ohb12*l_fac1,             #TQC-C20183 --mark---      
      #                      tuq09=tuq09-l_ohb.ohb12*l_fac1*l_fac2,      #TQC-C20183 --mark---      
         UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,                      #TQC-C20183 --add--
                             tuq09=tuq09-l_tuq09_1,                      #TQC-C20183 --add--
                             tuq10=l_desc                                      
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                       
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                       
            AND tuq11=l_tuq11 AND tuq12=l_oha.oha04
            AND tuq05=l_oha.oha01 AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN                                                 
            LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_oha.oha02,"/",l_tuq11,"/",l_oha.oha04  #No.FUN-710028
            CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'update tuq_file',SQLCA.sqlcode,1)          #No.FUN-710028
            LET g_success='N'                                                  
            RETURN                                                             
         END IF                                                                
      END IF                    
   #MOD-CB0111 -- mark start --
   #ELSE
   #  IF l_ohb.ohb05 <> l_adq06 THEN
   #     CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_adq06)
   #          RETURNING l_cnt,l_fac1
   #     IF l_cnt = '1'  THEN
   #        CALL s_errmsg('','',l_ohb.ohb04,'abm-731',0)  #No.FUN-710028
   #        LET l_fac1=1
   #     END IF
   #  END IF
   #  SELECT adq07 INTO l_adq07 FROM adq_file
   #   WHERE adq01=l_oha.oha03  AND adq02=l_ohb.ohb04
   #     AND adq03=l_ohb.ohb092 AND adq04=l_oha.oha02
   #  IF cl_null(l_adq07) THEN LET l_adq07=0 END IF
   #  IF l_adq07-l_ohb.ohb12*l_fac1<0 THEN
   #     LET l_desc='2'
   #  ELSE
   #     LET l_desc='1'
   #  END IF
   #  IF l_adq07=l_ohb.ohb12*l_fac1 THEN
   #     DELETE FROM adq_file
   #      WHERE adq01=l_oha.oha03  AND adq02=l_ohb.ohb04
   #        AND adq03=l_ohb.ohb092 AND adq04=l_oha.oha02
   #     IF SQLCA.sqlcode THEN
   #        LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_oha.oha02              #No.FUN-710028 
   #        CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'delete adq_file',SQLCA.sqlcode,1)      #No.FUN-710028
   #        LET g_success='N'
   #        RETURN
   #     END IF
   #  ELSE
   #     LET l_fac2=1
   #     IF l_adq06 <> l_ima25 THEN
   #        CALL s_umfchk(l_ohb.ohb04,l_adq06,l_ima25)
   #             RETURNING l_cnt,l_fac2
   #        IF l_cnt = '1'  THEN
   #           CALL cl_err(l_ohb.ohb04,'abm-731',1)
   #           LET l_fac2=1
   #        END IF
   #     END IF
   #     #No.TQC-C20183--add--begin---
   #     LET l_adq07_1 = s_digqty(l_ohb.ohb12*l_fac1,l_adq06)
   #     LET l_adq09_1 = s_digqty(l_ohb.ohb12*l_fac1*l_fac2,l_ima25)
   #     #No.TQC-C20183--add--end---
   #     UPDATE adq_file SET adq07=adq07-l_adq07_1,
   #                         adq09=adq09-l_adq09_1,
   #                         adq10=l_desc
   #      WHERE adq01=l_oha.oha03  AND adq02=l_ohb.ohb04
   #        AND adq03=l_ohb.ohb092 AND adq04=l_oha.oha02
   #     IF SQLCA.sqlcode THEN
   #        LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_oha.oha02              #No.FUN-710028 
   #        CALL s_errmsg('adq01,adq02,adq03,adq04',g_showmsg,'delete adq_file',SQLCA.sqlcode,1)      #No.FUN-710028
   #        LET g_success='N'
   #        RETURN
   #     END IF
   #  END IF
   #END IF   #No.FUN-650108
   #MOD-CB0111 -- mark end --
   END IF
    
   LET l_fac1=1
   IF l_ohb.ohb05 <> l_ima25 THEN
      CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
           RETURNING l_cnt,l_fac1
      IF l_cnt = '1'  THEN
         CALL s_errmsg('','',l_ohb.ohb04,'abm-731',0)   #No.FUN-710028
         LET l_fac1=1
      END IF
   END IF
   
   #IF g_aza.aza50='Y' THEN   #MOD-CB0111 mark
    IF l_oga.oga00='7' THEN
      #LET l_tup08='2' #CHI-B40056 mark
       LET l_tup11='2' #CHI-B40056
    ELSE 
      #LET l_tup08='1' #CHI-B40056 mark
       LET l_tup11='1' #CHI-B40056
    END IF
    SELECT COUNT(*) INTO i FROM tup_file                                        
     WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04                             
       AND tup03=l_ohb.ohb092                                                   
      #AND tup08=l_tup08 AND tup09=l_oha.oha04 #CHI-B40056 mark
       AND tup11=l_tup11 AND tup12=l_oha.oha04 #CHI-B40056
    IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF   #FUN-790001 add
    LET l_tup05_1= l_ohb.ohb12*l_fac1*-1                   #TQC-C20183  --ADD--
    LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)            #TQC-C20183  --ADD--                    
    IF i=0 THEN                                     
      #INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tupplant,tuplegal)  #FUN-980010 add tupplant,tuplegal  #CHI-B40056 mark      
       INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup11,tup12,tupplant,tuplegal)  #CHI-B40056 modfiy tup08,tup09 ->tup11,tup12
       VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_ima25,                     
             #l_ohb.ohb12*l_fac1*-1,l_ima71+l_oha.oha02,l_oha.oha02,l_tup08,l_oha.oha04,g_plant,g_legal) #FUN-980010 add g_plant,g_legal #MOD-B30651 mark         
             #l_ohb.ohb12*l_fac1*-1,l_tup06,l_oha.oha02,l_tup08,l_oha.oha04,g_plant,g_legal)             #MOD-B30651 #TQC-C20183  --mark--
              l_tup05_1,l_tup06,l_oha.oha02,l_tup11,l_oha.oha04,g_plant,g_legal)              #TQC-C20183  --ADD-- #CHI-B40056 modfiy tup08->tup11 
       IF SQLCA.sqlcode THEN                                                    
          LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092                        #No.FUN-710028
          CALL s_errmsg('tup01,tup02,tup03',g_showmsg,'insert tup_file',SQLCA.sqlcode,1)      #No.FUN-710028
          LET g_success='N'                                                     
          RETURN                                                                
       END IF                                                                   
    ELSE                                                                        
      #UPDATE tup_file SET tup05=tup05-l_ohb.ohb12*l_fac1      #TQC-C20183  --mark--
       UPDATE tup_file SET tup05=tup05+l_tup05_1               #TQC-C20183  --ADD-
        WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04                          
          AND tup03=l_ohb.ohb092                                                
         #AND tup08=l_tup08 and tup09=l_oha.oha04 #CHI-B40056 mark
          AND tup11=l_tup11 and tup12=l_oha.oha04 #CHI-B40056 add
       IF SQLCA.sqlcode THEN                                                    
          LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092,"/",l_tup11,"/",l_oha.oha04    #No.FUN-710028 #CHI-B40056 l_tup08->l_tup11
          CALL s_errmsg('tup01,tup02,tup03,tup11,tup12',g_showmsg,'insert tup_file',SQLCA.sqlcode,1)  #No.FUN-710028 #CHI-B40056 tup08,tup09->tup11,tup12
          LET g_success='N'                                                     
          RETURN                                                                
       END IF           
    END IF
   #MOD-CB0111 -- mark start --
   #ELSE
   # SELECT COUNT(*) INTO i FROM adp_file
   #  WHERE adp01=l_oha.oha03  AND adp02=l_ohb.ohb04
   #    AND adp03=l_ohb.ohb092
   # IF i=0 THEN
   #    INSERT INTO adp_file(adp01,adp02,adp03,adp04,adp05,adp06,adp07)
   #    VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_ima25,
   #          #l_ohb.ohb12*l_fac1*-1,l_ima71+l_oha.oha02,l_oha.oha02) #MOD-B30651 mark
   #           l_ohb.ohb12*l_fac1*-1,l_tup06,l_oha.oha02)             #MOD-B30651
   #    IF SQLCA.sqlcode THEN
   #       LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092                        #No.FUN-710028
   #       CALL s_errmsg('adp01,adp02,adp03',g_showmsg,'insert adp_file',SQLCA.sqlcode,1)      #No.FUN-710028
   #       LET g_success='N'
   #       RETURN
   #    END IF
   # ELSE
   #    UPDATE adp_file SET adp05=adp05-l_ohb.ohb12*l_fac1
   #     WHERE adp01=l_oha.oha03  AND adp02=l_ohb.ohb04
   #       AND adp03=l_ohb.ohb092
   #    IF SQLCA.sqlcode THEN
   #       LET g_showmsg = l_oha.oha03,"/",l_ohb.ohb04,"/",l_ohb.ohb092                   #No.FUN-710028
   #       CALL s_errmsg('adp01,adp02,adp03',g_showmsg,'update adp_file',SQLCA.sqlcode,1) #No.FUN-710028
   #       LET g_success='N'
   #       RETURN
   #    END IF
   # END IF
   #END IF   #No.FUN-650108
   #MOD-CB0111 -- mark end --
END FUNCTION

FUNCTION saxmt700sub_update1(l_oha,l_ohb)
   DEFINE l_oha    RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb    RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE l_forupd_sql   STRING             #DEV-D30046 --add
   DEFINE l_qty    LIKE img_file.img10,
          l_ima86  LIKE ima_file.ima86,
          l_ima25  LIKE ima_file.ima25 
    
   #FUN-AB0059 ---------------------start----------------------------
   IF s_joint_venture( l_ohb.ohb04,g_plant) OR NOT s_internal_item( l_ohb.ohb04,g_plant ) THEN
       RETURN
   END IF
   #FUN-AB0059 ---------------------end-------------------------------
   LET l_forupd_sql ="SELECT ima25,ima86 FROM ima_file ",  
                     " WHERE ima01= ?  FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock1 CURSOR FROM l_forupd_sql
   OPEN ima_lock1 USING l_ohb.ohb04
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
   FETCH ima_lock1 INTO l_ima25,g_ima86
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
      CALL saxmt700sub_tlf(l_ima25,l_qty,l_oha.*,l_ohb.*)
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

#copy t700_update,用来更新发票仓库存
FUNCTION saxmt700sub_update2(l_oha,l_ohb)
   DEFINE l_oha       RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb       RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE l_qty       LIKE img_file.img10,
          l_ima01     LIKE ima_file.ima01,
          l_ima25     LIKE ima_file.ima25,
          p_img       RECORD like img_file.*,
          l_img       RECORD
             l_img01     LIKE img_file.img01,       # No.FUN-680137 INT    #No.TQC-940183  #No.TQC-950134
             img10       LIKE img_file.img10,
             img16       LIKE img_file.img16,
             img23       LIKE img_file.img23,
             img24       LIKE img_file.img24,
             img09       LIKE img_file.img09,
             img21       LIKE img_file.img21
                      END RECORD,
          l_cnt       LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_forupd_sql   STRING   #DEV-D30046 --add

   #FUN-AB0059 ---------------------start---------------------------- 
   IF s_joint_venture( l_ohb.ohb04,g_plant) OR NOT s_internal_item( l_ohb.ohb04,g_plant ) THEN
      RETURN
   END IF
   #FUN-AB0059 ---------------------end------------------------------- 
   
   #MOD-BC0033 ----- modify start -----
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM img_file
   #No.MOD-CB0199  --Begin
   #WHERE img01=l_ohb.ohb04 AND img02=l_ohb.ohb09
   #  AND img03=l_ohb.ohb091 AND img04=l_ohb.ohb092
    WHERE img01=l_ohb.ohb04 AND img02=g_oaz.oaz95
      AND img03=l_oha.oha03  AND img04=l_ohb.ohb092
   #No.MOD-CB0199  --End

   IF l_cnt = 0 THEN
   #IF l_ohb.ohb15 IS NULL THEN
   #MOD-BC0033 -----  modify end  -----
      INITIALIZE p_img.* TO NULL
      LET p_img.img01=l_ohb.ohb04
      #No.MOD-CB0199  --Begin
      #LET p_img.img02=l_ohb.ohb09
      #LET p_img.img03=l_ohb.ohb091
      #LET p_img.img04=l_ohb.ohb092
      LET p_img.img02=g_oaz.oaz95
      LET p_img.img03=l_oha.oha03
      LET p_img.img04=l_ohb.ohb092
      #No.MOD-CB0199  --End
      LET p_img.img09=l_ohb.ohb05
      LET p_img.img10=0
      LET p_img.img21=1
      LET p_img.img23='Y'
      LET p_img.img24='N'
      LET p_img.imgplant=g_plant    #FUN-B90103--add
      LET p_img.imglegal=g_legal    #FUN-B90103--add
      LET l_ohb.ohb15=l_ohb.ohb05
              
      #IF s_internal_item( p_img.img01,g_plant ) AND NOT s_joint_venture( p_img.img01 ,g_plant) THEN  #FUN-A90049 add     #FUN-AB0059 mark
      INSERT INTO img_file VALUES(p_img.*)
      IF STATUS THEN
         LET g_showmsg = p_img.img01,"/",p_img.img02,"/",p_img.img03,"/",p_img.img04        #No.FUN-710028
         CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'l_ohb.ohb15 null:','axm-186',1) #No.FUN-710028
         LET g_success = 'N'
         RETURN
      END IF
      #END IF              #FUN-A90049 add       #FUN-AB0059 mark
   END IF
   
   LET l_forupd_sql = "SELECT img01,img10,img16,img23,img24,img09,img21",
                      " FROM img_file ",
                      "  WHERE img01= ? AND img02= ? AND img03= ? ",
                      " AND img04= ?  FOR UPDATE "                     #no.TQC-750149
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE img_lock2 CURSOR FROM l_forupd_sql
   #No.MOD-CB0199  --Begin
   #OPEN img_lock2 USING l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092
   OPEN img_lock2 USING l_ohb.ohb04,g_oaz.oaz95,l_oha.oha03,l_ohb.ohb092
   #No.MOD-CB0199  --End
   IF STATUS THEN
      #No.MOD-CB0199  --Begin
      #LET g_showmsg = l_ohb.ohb04,"/",l_ohb.ohb09,"/",l_ohb.ohb091,"/",l_ohb.ohb092  #No.FUN-710028
      LET g_showmsg = l_ohb.ohb04,"/",g_oaz.oaz95,"/",l_oha.oha03,"/",l_ohb.ohb092  #No.FUN-710028
      #No.MOD-CB0199  --End
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'lock img fail',STATUS,1)    #No.FUN-710028
      LET g_success='N' RETURN
   END IF
 
   FETCH img_lock2 INTO l_img.*
   IF STATUS THEN
      #No.MOD-CB0199  --Begin
      #LET g_showmsg = l_ohb.ohb04,"/",l_ohb.ohb09,"/",l_ohb.ohb091,"/",l_ohb.ohb092  #No.FUN-710028
      LET g_showmsg = l_ohb.ohb04,"/",g_oaz.oaz95,"/",l_oha.oha03,"/",l_ohb.ohb092  #No.FUN-710028
      #No.MOD-CB0199  --End
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'lock img fail',STATUS,1)    #MOD-920056
      LET g_success='N' RETURN
   END IF
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 - l_ohb.ohb16
   #No.MOD-CB0199  --Begin
   #CALL s_upimg(l_ohb.ohb04,g_oaz.oaz95,l_oha.oha03,'',-1,l_ohb.ohb16,g_today, #FUN-8C0084
   CALL s_upimg(l_ohb.ohb04,g_oaz.oaz95,l_oha.oha03,l_ohb.ohb092,-1,l_ohb.ohb16,g_today, #FUN-8C0084
   #No.MOD-CB0199  --End
         '','','','',l_ohb.ohb01,l_ohb.ohb03,'','','','','','','','','','','','')  #NO.FUN-860025
   IF g_success='N' THEN
      CALL s_errmsg('','','s_upimg()','9050',0) RETURN  #No.FUN-710028
   END IF

   LET l_forupd_sql ="SELECT ima25,ima86 FROM ima_file ",
                     " WHERE ima01= ?  FOR UPDATE"       #no.TQC-750149
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock2 CURSOR FROM l_forupd_sql
   OPEN ima_lock2 USING l_ohb.ohb04
   IF STATUS THEN
      CALL s_errmsg('ima01',l_ohb.ohb04,'lock ima fail',STATUS,1)       #No.FUN-710028
      LET g_success='N' RETURN
   END IF
   FETCH ima_lock2 INTO l_ima25,g_ima86
   IF STATUS THEN
      CALL s_errmsg('','','lock ima fail',STATUS,1) LET g_success='N' RETURN    #No.FUN-710028
   END IF
                 #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   CALL s_udima(l_ohb.ohb04,l_img.img23,l_img.img24,l_ohb.ohb16*l_img.img21,
                   #g_today,+1)  RETURNING l_cnt   #MOD-920298
                   l_oha.oha02,+1)  RETURNING l_cnt   #MOD-920298
        #最近一次發料日期 表發料
   IF l_cnt THEN
         CALL s_errmsg('','','Update Faile',SQLCA.SQLCODE,1)  #No.FUN-710028
         LET g_success='N' RETURN
   END IF
   IF g_success='Y' THEN
      CALL saxmt700sub_tlf2(l_ima25,l_qty,l_oha.*,l_ohb.*)
   END IF
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION saxmt700sub_tlf(p_unit,p_img10,l_oha,l_ohb)
   DEFINE l_oha      RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb      RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE p_unit     LIKE ima_file.ima25,       ##單位
          p_img10    LIKE img_file.img10,   #異動後數量
          l_sfb02    LIKE sfb_file.sfb02,
          l_sfb03    LIKE sfb_file.sfb03,
          l_sfb04    LIKE sfb_file.sfb04,
          l_sfb22    LIKE sfb_file.sfb22,
          l_sfb27    LIKE sfb_file.sfb27,
          l_sta      LIKE type_file.num5,       # No.FUN-680137 SMALLINT
          l_cnt      LIKE type_file.num5        # No.FUN-680137 SMALLINT
 
   #----來源----
   LET g_tlf.tlf01=l_ohb.ohb04             #異動料件編號
   LET g_tlf.tlf02=731
   LET g_tlf.tlf020=' '
   LET g_tlf.tlf021=' '            #倉庫
   LET g_tlf.tlf022=' '            #儲位
   LET g_tlf.tlf023=' '            #批號
   LET g_tlf.tlf024=0              #異動後數量
   LET g_tlf.tlf025=' '            #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_oha.oha01    #銷退單號
   LET g_tlf.tlf027=l_ohb.ohb03    #銷退項次
   #---目的----
   LET g_tlf.tlf03=50
   LET g_tlf.tlf030=l_ohb.ohb08
   LET g_tlf.tlf031=l_ohb.ohb09    #倉庫
   LET g_tlf.tlf032=l_ohb.ohb091   #儲位
   LET g_tlf.tlf033=l_ohb.ohb092   #批號
   LET g_tlf.tlf034=p_img10        #異動後庫存數量
   LET g_tlf.tlf035=p_unit         #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_oha.oha01    #銷退單號
   LET g_tlf.tlf037=l_ohb.ohb03    #銷退項次
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oha.oha02      #銷退日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=l_ohb.ohb12      #異動數量
   LET g_tlf.tlf11=l_ohb.ohb05	    #發料單位
   LET g_tlf.tlf12 =l_ohb.ohb15_fac #發料/庫存 換算率
   LET g_tlf.tlf13='aomt800'
   LET g_tlf.tlf14=l_ohb.ohb50      #異動原因   #MOD-870120
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ohb.ohb04)
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oha.oha03 #No.MOD-870252
   SELECT oga46 INTO g_tlf.tlf20 FROM oga_file WHERE oga01=l_ohb.ohb31
   LET g_tlf.tlf61= g_ima86
   LET g_tlf.tlf62=l_ohb.ohb33    #參考單號(訂單)
   LET g_tlf.tlf64=l_ohb.ohb52    #手冊編號 NO.A093
   LET g_tlf.tlf930=l_ohb.ohb930 #FUN-670063
   SELECT ogb41,ogb42,ogb43,ogb1001 
     INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
     FROM ogb_file
    WHERE ogb01 = l_ohb.ohb31
      AND ogb03 = l_ohb.ohb32
   IF SQLCA.sqlcode THEN
     LET g_tlf.tlf20 = ' '
     LET g_tlf.tlf41 = ' '
     LET g_tlf.tlf42 = ' '
     LET g_tlf.tlf43 = ' '
   END IF
   CALL s_tlf(1,0)
END FUNCTION

#FUN-C50097 ADD BEG-----发票仓tlf异动档
FUNCTION saxmt700sub_tlf2(p_unit,p_img10,l_oha,l_ohb)
   DEFINE l_oha      RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb      RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE p_unit     LIKE ima_file.ima25,       ##單位
          p_img10    LIKE img_file.img10,   #異動後數量
          l_sfb02    LIKE sfb_file.sfb02,
          l_sfb03    LIKE sfb_file.sfb03,
          l_sfb04    LIKE sfb_file.sfb04,
          l_sfb22    LIKE sfb_file.sfb22,
          l_sfb27    LIKE sfb_file.sfb27,
          l_sta      LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          l_cnt      LIKE type_file.num5        # No.FUN-680137 SMALLINT
 

   #----來源----
   LET g_tlf.tlf01=l_ohb.ohb04             #異動料件編號
   LET g_tlf.tlf02=50
   LET g_tlf.tlf021=g_oaz.oaz95
   LET g_tlf.tlf024=p_img10
   LET g_tlf.tlf022=l_oha.oha03      
   LET g_tlf.tlf023=l_ohb.ohb092        
   LET g_tlf.tlf025=p_unit
   LET g_tlf.tlf026=l_oha.oha01    #銷退單號
   LET g_tlf.tlf027=l_ohb.ohb03    #銷退項次    
   #---目的----
   LET g_tlf.tlf03=731
   LET g_tlf.tlf030=' '    #销退入库营运中心编号
   LET g_tlf.tlf031=' '    #倉庫
   LET g_tlf.tlf032=' '    #儲位
   LET g_tlf.tlf033=' '   #批號
   LET g_tlf.tlf034=0        #異動後庫存數量
   LET g_tlf.tlf035=p_unit         #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_oha.oha01    #銷退單號
   LET g_tlf.tlf037=l_ohb.ohb03    #銷退項次
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oha.oha02      #銷退日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=l_ohb.ohb12      #異動數量
   LET g_tlf.tlf11=l_ohb.ohb05	    #發料單位
   LET g_tlf.tlf12 =l_ohb.ohb15_fac #發料/庫存 換算率
   LET g_tlf.tlf13='aomt800'
   LET g_tlf.tlf14=l_ohb.ohb50      #異動原因   #MOD-870120
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ohb.ohb04)
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oha.oha03 #No.MOD-870252
   SELECT oga46 INTO g_tlf.tlf20 FROM oga_file WHERE oga01=l_ohb.ohb31
   LET g_tlf.tlf61= g_ima86
   LET g_tlf.tlf62=l_ohb.ohb33    #參考單號(訂單)
   LET g_tlf.tlf64=l_ohb.ohb52    #手冊編號 NO.A093
   LET g_tlf.tlf930=l_ohb.ohb930 #FUN-670063
   SELECT ogb41,ogb42,ogb43,ogb1001 
     INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43
     FROM ogb_file
    WHERE ogb01 = l_ohb.ohb31
      AND ogb03 = l_ohb.ohb32
   IF SQLCA.sqlcode THEN
     LET g_tlf.tlf20 = ' '
     LET g_tlf.tlf41 = ' '
     LET g_tlf.tlf42 = ' '
     LET g_tlf.tlf43 = ' '
   END IF
   CALL s_tlf(1,0)
END FUNCTION
#FUN-C50097 ADD END-----

FUNCTION saxmt700sub_bu1(l_oha,l_ohb)   #更新出貨單銷退量 & 訂單銷退量
   DEFINE l_oha     RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb     RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE l_ogb04   LIKE ogb_file.ogb04
   DEFINE l_oeb25   LIKE oeb_file.oeb25
   DEFINE l_a       LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
   DEFINE l_ogb05   LIKE ogb_file.ogb05        #No.TQC-C20183
   DEFINE tot1,tot2 LIKE ohb_file.ohb12      #DEV-D30046 --add
   DEFINE l_oeb     RECORD LIKE oeb_file.*   #DEV-D30046 --add
   
   CALL cl_msg("bu!")
   IF l_oha.oha09 = '1' THEN RETURN END IF
 
   IF NOT cl_null(l_ohb.ohb31) THEN 			#更新出貨單銷退量
      SELECT SUM(ohb12) INTO tot1 FROM ohb_file, oha_file
       WHERE ohb31=l_ohb.ohb31 AND ohb32=l_ohb.ohb32
        AND ohb01=oha01 AND ohapost='Y' AND oha09='2'
      SELECT SUM(ohb12) INTO tot2 FROM ohb_file, oha_file
       WHERE ohb31=l_ohb.ohb31 AND ohb32=l_ohb.ohb32
         AND ohb01=oha01 AND ohapost='Y' AND oha09='3'
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
 
      LET g_chr='N'
 
      SELECT ogb04 INTO l_ogb04 FROM ogb_file
       WHERE ogb01=l_ohb.ohb31 AND ogb03=l_ohb.ohb32

      #No.TQC-C20183--add--begin--
      SELECT ogb05 INTO l_ogb05 FROM ogb_file 
       WHERE ogb01 = l_ohb.ohb31
         AND ogb03 = l_ohb.ohb32
      LET tot1 = s_digqty(tot1,l_ogb05)
      LET tot2 = s_digqty(tot2,l_ogb05)
      #No.TQC-C20183--add--end--
      IF l_ohb.ohb04 = l_ogb04 THEN      #銷退品號與出貨品號相同才update
         UPDATE ogb_file SET ogb63=tot1,
                             ogb64=tot2
          WHERE ogb01 = l_ohb.ohb31
            AND ogb03 = l_ohb.ohb32
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = l_ohb.ohb31,"/",l_ohb.ohb32                      #No.FUN-710028
            CALL s_errmsg('ogb01,ogb03',g_showmsg,'upd ogb63,64',STATUS,1)   #No.FUN-710028
            LET g_success = 'N' RETURN
         END IF
      END IF
   END IF
 
   IF l_oha.oha09 != '4' THEN RETURN END IF      #bugno:5730 add ......
 
   IF NOT cl_null(l_ohb.ohb33) THEN     # 訂單銷退量
      LET g_chr='N'
      SELECT * INTO l_oeb.* FROM oeb_file
       WHERE oeb01=l_ohb.ohb33 AND oeb03=l_ohb.ohb34
      IF STATUS THEN
         CALL s_errmsg('oeb01,oeb03',g_showmsg,'sel oeb',STATUS,1)    #No.FUN-710028
         LET g_success = 'N' RETURN
      END IF
      # (已出貨數量 - 已銷退數量(須再換貨出貨) ) < 銷退數量
      #IF (l_oeb.oeb24-l_oeb.oeb25) < l_ohb.ohb12 THEN #MOD-C30817 mark
      IF (l_oeb.oeb24-l_oeb.oeb25-l_oeb.oeb29) < l_ohb.ohb12 THEN #MOD-C30817 add
         CALL s_errmsg('','','sel oeb-bu1','axm-178',1)  #No.FUN-710028
         CALL cl_err('','axm-178',1)
         LET g_success = 'N' RETURN
        
      END IF
      IF l_oeb.oeb70 = 'Y' AND l_oha.oha09 = '4' THEN #BugNo:5710   #MOD-690019 modify
         CALL s_errmsg('','','sel oeb','axm-150',1)   #No.FUN-710028
         CALL cl_err('','axm-178',1)
         LET g_success = 'N' RETURN
      END IF
      
 
     #IF l_ohb.ohb04 = l_oeb.oeb04 THEN      #銷退品號與訂單品號相同才update #MOD-D40018 mark
         SELECT oeb25 INTO l_oeb25 FROM oeb_file
          WHERE oeb01 = l_ohb.ohb33 AND oeb03 = l_ohb.ohb34
         IF cl_null(l_oeb25) THEN LET l_oeb25 = 0 END IF
         LET l_oeb25 = l_oeb25 + l_ohb.ohb12
         UPDATE oeb_file SET oeb25 = l_oeb25
          WHERE oeb01=l_ohb.ohb33 AND oeb03=l_ohb.ohb34
         IF STATUS THEN
            LET g_showmsg = l_ohb.ohb33,"/",l_ohb.ohb34                    #No.FUN-710028
            CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd oeb25',STATUS,1)    #No.FUN-710028
            LET g_success = 'N' RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = l_ohb.ohb33,"/",l_ohb.ohb34                    #No.FUN-710028
            CALL s_errmsg('oeb01,oeb03',g_showmsg,'upd oeb25','axm-176',1) #No.FUN-710028
            LET g_success = 'N' RETURN
         END IF
     #END IF #MOD-D40018 mark
   END IF
END FUNCTION

##銷退數量需要更新到ogbslk63,ogbslk64,oebslk25
FUNCTION saxmt700sub_bu2(l_oha,l_ohbslk)   #更新出貨單銷退量 & 訂單銷退量
   DEFINE l_oha        RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohbslk     RECORD LIKE ohbslk_file.*   #DEV-D30046 --add
   DEFINE l_ogbslk04   LIKE ogb_file.ogb04   
   DEFINE l_oebslk25   LIKE oebslk_file.oebslk25
   DEFINE l_a          LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
   DEFINE l_oebslk     RECORD LIKE oebslk_file.*  #DEV-D30046 --add
   DEFINE tot1,tot2    LIKE ohb_file.ohb12        #DEV-D30046 --add
   
   CALL cl_msg("bu2!")
   IF l_oha.oha09 = '1' THEN RETURN END IF

   IF NOT cl_null(l_ohbslk.ohbslk31) THEN                   #更新出貨單銷退量
      SELECT SUM(ogb63),SUM(ogb64) INTO tot1,tot2 FROM ogb_file, ogbi_file
        WHERE ogb01=ogbi01 AND ogb03=ogbi03 AND ogb01=l_ohbslk.ohbslk31
          AND ogbislk02=l_ohbslk.ohbslk32
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
      LET g_chr='N'

      SELECT ogbslk04 INTO l_ogbslk04 FROM ogbslk_file
       WHERE ogbslk01=l_ohbslk.ohbslk31 AND ogbslk03=l_ohbslk.ohbslk32

      IF l_ohbslk.ohbslk04 = l_ogbslk04 THEN      #銷退品號與出貨品號相同才update
         UPDATE ogbslk_file SET ogbslk63=tot1,
                                ogbslk64=tot2
          WHERE ogbslk01 = l_ohbslk.ohbslk31
            AND ogbslk03 = l_ohbslk.ohbslk32
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = l_ohbslk.ohbslk31,"/",l_ohbslk.ohbslk32
            CALL s_errmsg('ogbslk01,ogbslk03',g_showmsg,'upd ogbslk63,64',STATUS,1)
            LET g_success = 'N' RETURN
         END IF
      END IF
   END IF

   IF l_oha.oha09 != '4' THEN RETURN END IF
   IF NOT cl_null(l_ohbslk.ohbslk33) THEN     # 訂單銷退量
      LET g_chr='N'
      SELECT * INTO l_oebslk.* FROM oebslk_file
       WHERE oebslk01=l_ohbslk.ohbslk33 AND oebslk03=l_ohbslk.ohbslk34
      IF STATUS THEN
         CALL s_errmsg('oebslk01,oebslk03',g_showmsg,'sel oebslk',STATUS,1)
         LET g_success = 'N' RETURN
      END IF
      IF l_ohbslk.ohbslk04 = l_oebslk.oebslk04 THEN      #銷退品號與訂單品號相同才update
         SELECT SUM(oeb25) INTO l_oebslk25 FROM oeb_file,oebi_file
           WHERE oeb01=oebi01 AND oeb03=oebi03 AND oeb01=l_ohbslk.ohbslk33
             AND oebislk03=l_ohbslk.ohbslk34
         IF cl_null(l_oebslk25) THEN LET l_oebslk25 = 0 END IF
         UPDATE oebslk_file SET oebslk25 = l_oebslk25
          WHERE oebslk01=l_ohbslk.ohbslk33 AND oebslk03=l_ohbslk.ohbslk34
         IF STATUS THEN
            LET g_showmsg = l_ohbslk.ohbslk33,"/",l_ohbslk.ohbslk34
            CALL s_errmsg('oebslk01,oebslk03',g_showmsg,'upd oebslk25',STATUS,1)
            LET g_success = 'N' RETURN
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION saxmt700sub_update_7(l_oha,l_oga,l_ogb)
   DEFINE l_oha         RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_oga         RECORD LIKE oga_file.*   #DEV-D30046 --add
   DEFINE l_ogb         RECORD LIKE ogb_file.*   #DEV-D30046 --add
   DEFINE l_qty         LIKE img_file.img10,
          l_occ31       LIKE occ_file.occ31,
          l_ima01       LIKE ima_file.ima01,
          l_ima25       LIKE ima_file.ima25,
          l_ima71       LIKE ima_file.ima71,
          l_ima86       LIKE ima_file.ima86,
          p_img         RECORD LIKE img_file.*,
          l_fac1,l_fac2 LIKE ogb_file.ogb15_fac,
          l_img         RECORD                                                          
             l_imgg01      LIKE imgg_file.imgg01,       # No.FUN-680137  INT                                              #No.TQC-940183  #No.TQC-950134
             img10         LIKE img_file.img10,                                    
             img16         LIKE img_file.img16,                                    
             img23         LIKE img_file.img23,                                    
             img24         LIKE img_file.img24,                                    
             img09         LIKE img_file.img09,                                    
             img21         LIKE img_file.img21                                     
                        END RECORD,     
          l_cnt         LIKE type_file.num5           #No.FUN-680137 SMALLINT
   DEFINE l_tuq06       LIKE tuq_file.tuq06                                          
   DEFINE l_tuq11       LIKE tuq_file.tuq11                                          
   DEFINE l_tup05       LIKE tup_file.tup05                                          
   #DEFINE l_tup08      LIKE tup_file.tup08   #CHI-B40056 mark                                       
   DEFINE l_tup11       LIKE tup_file.tup11   #CHI-B40056 add                                       
   DEFINE l_tuq07       LIKE tuq_file.tuq07                                          
   DEFINE l_desc        LIKE type_file.chr1        # No.FUN-680137  VARCHAR(01) 
   DEFINE i             LIKE type_file.num5             #No.FUN-680137 SMALLINT
   DEFINE l_tup06       LIKE tup_file.tup06    #MOD-B30651 add                                       
   #TQC-C20183--add--start--
   DEFINE l_tup05_1     LIKE tup_file.tup05,
          l_tuq07_1     LIKE tuq_file.tuq07,
          l_tuq09_1     LIKE tuq_file.tuq09
   #TQC-C20183--add--end-- 
   DEFINE l_forupd_sql  STRING    #DEV-D30046 --add 
   
   #FUN-AB0059 ---------------------start---------------------------- 
   IF s_joint_venture( l_ogb.ogb04,g_plant) OR NOT s_internal_item( l_ogb.ogb04,g_plant ) THEN
      RETURN
   END IF
   #FUN-AB0059 ---------------------end-------------------------------           
   
   IF l_ogb.ogb15 IS NULL THEN
      INITIALIZE  p_img.*  TO  NULL
      LET p_img.img01 = l_ogb.ogb04
      LET p_img.img02 = l_ogb.ogb09       
      LET p_img.img03 = l_ogb.ogb091
      LET p_img.img04 = l_ogb.ogb092
      LET p_img.img09 = l_ogb.ogb05
      LET p_img.img10 = 0
      LET p_img.imgplant = g_plant #FUN-980010 add
      LET p_img.imglegal = g_legal #FUN-980010 add
      LET l_ogb.ogb15 = l_ogb.ogb05
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=p_img.img01
      IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
         CALL s_errmsg('ima01',p_img.img01,'ima25 null',SQLCA.sqlcode,1)  #No.FUN-710028 
         LET g_success='N' 
         RETURN
      END IF
      CALL s_umfchk(p_img.img01,p_img.img09,l_ima25) RETURNING l_cnt,p_img.img21
      IF l_cnt =1 THEN
         CALL s_errmsg('','',' ','mfg3075',1)   #No.FUN-710028
         LET g_success='N'
         RETURN
      END IF
      SELECT imd11,imd12 INTO p_img.img23,p_img.img24 FROM imd_file
       WHERE imd01=p_img.img02
      IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
         CALL s_errmsg('imd01',p_img.img02,'imd23,imd24',SQLCA.sqlcode,1)   #No.FUN-710028
         LET g_success='N'
      END IF
      INSERT INTO img_file VALUES(p_img.*)
      IF STATUS THEN
         LET g_showmsg = p_img.img01,"/",p_img.img02,"/",p_img.img03,"/",p_img.img04          #No.FUN-710028
         CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'l_ogb.ogb15 null:','axm-186',1)   #No.FUN-710028
         LET g_success='N'
         RETURN
      END IF
   END IF
   
   LET l_forupd_sql="SELECT img01,img10,img16,img23,img24,img09,img21",
                    "  FROM img_file ",
                    "  WHERE img01= ? AND img02= ? AND img03= ?",
                    "   AND img04=? FOR UPDATE "               #no.TQC-750149
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE img_lock7 CURSOR FROM l_forupd_sql
   OPEN img_lock7 USING l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092
   IF STATUS THEN
      CALL s_errmsg('','','lock img_file',STATUS,1)   #No.FUN-710028
      LET g_success='N'
      RETURN
   END IF
   FETCH img_lock7 INTO l_img.*
   IF STATUS THEN
      LET g_showmsg = l_ogb.ogb04,"/",l_ogb.ogb09,"/",l_ogb.ogb091,"/",l_ogb.ogb092  #MOD-920056
      CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'lock img fail',STATUS,1)    #MOD-920056
      LET g_success='N'
      RETURN
   END IF
   IF cl_null(l_img.img10) THEN 
      LET l_img.img10=0
   END IF
   LET l_qty=l_img.img10-l_ogb.ogb16

   CALL s_upimg(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,-1,l_ogb.ogb16, #FUN-8C0084
                g_today,' ',' ','','','','','','','','','','','','','','','','')  #FUN-8C0084
   IF g_success='N' THEN
      CALL s_errmsg('','','s_upimg','9050',0)   #No.FUN-710028
      RETURN
   END IF
   
   LET l_forupd_sql ="SELECT ima25,ima86 FROM ima_file ",
                     " WHERE ima01= ?  FOR UPDATE "  #no.TQC-750149
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock9 CURSOR FROM l_forupd_sql
   OPEN ima_lock9 USING l_ogb.ogb04
   IF STATUS THEN
      CALL s_errmsg('','','lock ima fail',STATUS,1)   #No.FUN-710028
      LET g_success='N'
      RETURN
   END IF
   FETCH ima_lock9 INTO l_ima25,l_ima86
   IF STATUS THEN
      CALL s_errmsg('','','lock ima fail',STATUS,1)   #No.FUN-710028
      LET g_success='N'
      RETURN
   END IF
   CALL s_udima(l_ogb.ogb04,l_img.img23,l_img.img24,l_ogb.ogb16*l_img.img21,
                l_oga.oga02,-1)  RETURNING l_cnt   #MOD-920298
   IF l_cnt THEN
      CALL s_errmsg('','','Update Faile',SQLCA.SQLCODE,1)  #No.FUN-710028
      LET g_success='N' RETURN
   END IF
   IF g_success='Y' THEN
      CALL saxmt700sub_tlf_7(l_img.img09,l_qty,l_oga.*,l_ogb.*)
   END IF
   IF g_success = 'N' THEN 
      RETURN 
   END IF                                       
   SELECT occ31 INTO l_occ31 FROM occ_file 
    WHERE occ01=l_oga.oga03          
   IF cl_null(l_occ31) THEN 
      LET l_occ31='N' 
   END IF
   IF l_occ31 = 'N' THEN 
      RETURN 
   END IF
   SELECT ima25,ima71 INTO l_ima25,l_ima71                                     
     FROM ima_file 
    WHERE ima01=l_ogb.ogb04                                     
   IF cl_null(l_ima71) THEN 
      LET l_ima71=0 
   END IF                             
   #MOD-B30651 add --start--
   IF l_ima71 = 0 THEN 
      LET l_tup06 = g_lastdat
   ELSE 
      LET l_tup06 = l_oga.oga02 + l_ima71
   END IF
   #MOD-B30651 add --end--
    IF l_oga.oga00='7' THEN
       LET l_tuq11='2'
    ELSE
       LET l_tuq11='1'
    END IF
   SELECT COUNT(*) INTO i FROM tuq_file                                        
    WHERE tuq01=l_oga.oga03    
      AND tuq02=l_ogb.ogb04                             
      AND tuq03=l_ogb.ogb092 
      AND tuq11=l_tuq11
      AND tuq12= l_oga.oga04
      AND tuq04=l_oga.oga02
   IF i=0 THEN
      LET l_fac1=1                                                             
      IF l_ogb.ogb05 <> l_ima25 THEN                                           
          CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25)                        
               RETURNING l_cnt,l_fac1                                           
         IF l_cnt = '1'  THEN                                                  
            CALL s_errmsg('','',l_ogb.ogb04,'abm-731',0)  #No.FUN-710028
            LET l_fac1=1
         END IF
      END IF
      LET l_tuq09_1 = l_ogb.ogb12*l_fac1*1            #TQC-C20183 --add--
      LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)     #TQC-C20183 --add-
      INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,                      
                        tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,tuqplant,tuqlegal)  #FUN-980010 add tuqplant,tuqlegal
      VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_oga.oga02,l_oga.oga01,l_ogb.ogb03,    
            #l_ogb.ogb05,l_ogb.ogb12*1,l_fac1,l_ogb.ogb12*l_fac1*1,'1',l_tuq11,l_oga.oga04,g_plant,g_legal)  #FUN-980010 add g_plant,g_legal   #TQC-C20183 --mark-- 
             l_ogb.ogb05,l_ogb.ogb12*1,l_fac1,l_tuq09_1,'1',l_tuq11,l_oga.oga04,g_plant,g_legal)  #TQC-C20183 add
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_tuq11,"/",l_oga.oga04  #No.FUN-710028
         CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'insert tuq_file',SQLCA.sqlcode,1)   #No.FUN-710028
         LET g_success ='N'                                                    
         RETURN                                                                
      END IF  
   ELSE                                                                        
      SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file                           
       WHERE tuq01=l_oga.oga03                      
         AND tuq02=l_ogb.ogb04                          
         AND tuq03=l_ogb.ogb092
         AND tuq04=l_oga.oga02                          
         AND tuq11=l_tuq11
         AND tuq12=l_oga.oga04
      IF SQLCA.sqlcode THEN                                                    
         LET g_showmsg = l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_tuq11,"/",l_oga.oga04  #No.FUN-710028
         CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'select tuq06',SQLCA.sqlcode,1)             #No.FUN-710028
         LET g_success ='N'                                                    
         RETURN                                                                
      END IF                                                                   
      LET l_fac1=1                                                             
      IF l_ogb.ogb05 <> l_tuq06 THEN                                           
         CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_tuq06)                        
              RETURNING l_cnt,l_fac1                                           
         IF l_cnt = '1'  THEN            
            CALL s_errmsg('','',l_ogb.ogb04,'abm-731',0)   #No.FUN-710028
            LET l_fac1=1                                                       
         END IF                                                                
      END IF                                                                   
      SELECT tuq07 INTO l_tuq07 FROM tuq_file                                  
       WHERE tuq01=l_oha.oha03        
         AND tuq02=l_ogb.ogb04                          
         AND tuq03=l_ogb.ogb092 
         AND tuq04=l_oga.oga02
         AND tuq11=l_tuq11
         AND tuq12=l_oga.oga04
      #MOD-B50039 add --start--
      IF SQLCA.sqlcode THEN                                                    
         LET g_showmsg = l_oha.oha03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_tuq11,"/",l_oga.oga04 
         CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'select tuq07',SQLCA.sqlcode,1) 
         LET g_success ='N'                                                    
         RETURN                                                                
      END IF                                                                   
      #MOD-B50039 add --end--
      IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF                            
      IF l_tuq07+l_ogb.ogb12*l_fac1<0 THEN                                     
         LET l_desc='2'                                                        
      ELSE                                                                     
         LET l_desc='1'                                                        
      END IF                                                                   
      IF l_tuq07=l_ogb.ogb12*l_fac1 THEN                                       
         DELETE FROM tuq_file                                                  
               WHERE tuq01=l_oga.oga03    #No.TQC-640125
                 AND tuq02=l_ogb.ogb04                       
                 AND tuq03=l_ogb.ogb092 
                 AND tuq04=l_oga.oga02
                 AND tuq11=l_tuq11
                 AND tuq12=l_oga.oga04
         IF SQLCA.sqlcode THEN
             LET g_showmsg = l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_tuq11,"/",l_oga.oga04  #No.FUN-710028
             CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'delete tuq_file',SQLCA.sqlcode,1)          #No.FUN-710028
             LET g_success='N'
             RETURN
         END IF
      ELSE
         LET l_fac2=1
         IF l_tuq06 <> l_ima25 THEN                                            
            CALL s_umfchk(l_ogb.ogb04,l_tuq06,l_ima25)                         
                RETURNING l_cnt,l_fac2                                        
            IF l_cnt = '1'  THEN                                               
                CALL s_errmsg('','',l_ogb.ogb04,'abm-731',0)  #No.FUN-710028        
                LET l_fac2=1                                                    
            END IF                                                             
         END IF                                                                
         LET l_tuq07_1 = l_ogb.ogb12*l_fac1              #TQC-C20183 --add--
         LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)     #TQC-C20183 --add-
         LET l_tuq09_1 = l_ogb.ogb12*l_fac1*l_fac2       #TQC-C20183 --add--
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)     #TQC-C20183 --add-
         UPDATE tuq_file 
           #SET tuq07=tuq07+l_ogb.ogb12*l_fac1,          #TQC-C20183 --mark--         
           #    tuq09=tuq09+l_ogb.ogb12*l_fac1*l_fac2,   #TQC-C20183 --mark--         
            SET tuq07=tuq07+l_tuq07_1,                   #TQC-C20183 --add--
                tuq09=tuq09+l_tuq09_1,                   #TQC-C20183 --add--
                tuq10=l_desc                                      
          WHERE tuq01=l_oga.oga03      
            AND tuq02=l_ogb.ogb04                       
            AND tuq03=l_ohb.ohb092 
            AND tuq04=l_oha.oha02
            AND tuq11=l_tuq11
            AND tuq12=l_oga.oga04
         IF SQLCA.sqlcode THEN
            LET g_showmsg = l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_tuq11,"/",l_oga.oga04  #No.FUN-710028
            CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'update tuq_file',SQLCA.sqlcode,1)          #No.FUN-710028
            LET g_success='N'                                                  
            RETURN                                                             
         END IF                                                                
       END IF                                                                   
   END IF               
   LET l_fac1=1                                                                
   IF l_ogb.ogb05 <> l_ima25 THEN                                              
      CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25) 
           RETURNING l_cnt,l_fac1                                              
      IF l_cnt = '1'  THEN                                                     
         CALL s_errmsg('','',l_ogb.ogb04,'abm-731',0)   #No.FUN-710028                               
         LET l_fac1=1
      END IF
   END IF
   IF l_oga.oga00='7' THEN
     #LET l_tup08='2'   #CHI-B40056 mark
      LET l_tup11='2'   #CHI-B40056 add
   ELSE
     #LET l_tup08='1'   #CHI-B40056 mark
      LET l_tup11='1'   #CHI-B40056 add
   END IF
   SELECT COUNT(*) INTO i FROM tup_file                                        
    WHERE tup01=l_oga.oga03     
      AND tup02=l_ogb.ogb04                             
     #AND tup08=l_tup08       #CHI-B40056 mark
     #AND tup09=l_oga.oga04   #CHI-B40056 mark
      AND tup11=l_tup11 AND tup12=l_oga.oga04  #CHI-B40056 add
      AND tup03=l_ogb.ogb092
   IF cl_null(l_ogb.ogb092) THEN LET l_ogb.ogb092=' ' END IF   #FUN-790001 add
   LET l_tup05_1= l_ogb.ogb12*l_fac1*1                    #TQC-C20183  --ADD--
   LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)            #TQC-C20183  --ADD--
   IF i=0 THEN
     #INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tupplant,tuplegal)  #FUN-980010 add  tupplant,tuplegal #CHI-B40056 mark     
      INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup11,tup12,tupplant,tuplegal)  #FUN-980010 add  tupplant,tuplegal #CHI-B40056 modfiy tup08,tup09 ->tup11,tup12
      VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_ima25,     
            #l_ogb.ogb12*l_fac1*1,l_ima71+l_oga.oga02,l_oga.oga02,l_tup08,l_oga.oga04,g_plant,g_legal)   #TQC-930128 #FUN-980010 add g_plant,g_legal #MOD-B30651 mark
            #l_ogb.ogb12*l_fac1*1,l_tup06,l_oga.oga02,l_tup08,l_oga.oga04,g_plant,g_legal)      #TQC-C20183 --mark--                                                     #MOD-B30651 
             l_tup05_1,l_tup06,l_oga.oga02,l_tup11,l_oga.oga04,g_plant,g_legal)                 #TQC-C20183 --add--  #MOD-B30651 #CHI-B40056 modfiy tup08 ->tup11 
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_tuq11,"/",l_oga.oga04  #No.FUN-710028
         CALL s_errmsg('tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'insert tuq_file',SQLCA.sqlcode,1)          #No.FUN-710028
         LET g_success='N'                                                     
         RETURN                                                                
      END IF                                                                   
   ELSE                                                                        
      UPDATE tup_file 
        #SET tup05=tup05+l_ogb.ogb12*l_fac1           #TQC-C20183 --mark--
         SET tup05=tup05+l_tup05_1                    #TQC-C20183 --add--
       WHERE tup01=l_oga.oga03    
         AND tup02=l_ogb.ogb04                          
         AND tup03=l_ogb.ogb092
        #AND tup08=l_tup08      #CHI-B40056 mark
        #AND tup09=l_oga.oga04  #CHI-B40056 mark
         AND tup11=l_tup11 AND tup12=l_oga.oga04  #CHI-B40056 add
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_tup11,"/",l_oga.oga04   #No.FUN-710028  #CHI-B40056 modfiy l_tup08->l_tup11
         CALL s_errmsg('tup01,tup02,tup03,tup11,tup12',g_showmsg,'update tup_file',SQLCA.sqlcode,1) #No.FUN-710028  #CHI-B40056 modfiy tup08,tup09 ->tup11,tup12
         LET g_success='N'                                                     
         RETURN                                                                
      END IF                                                                   
   END IF    
END FUNCTION

FUNCTION saxmt700sub_update_du(l_oha,l_ohb)
   DEFINE l_oha     RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb     RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE l_ima25   LIKE ima_file.ima25,
          u_type    LIKE type_file.num5        # No.FUN-680137  SMALLINT
   
   #FUN-AB0059 ---------------------start---------------------------- 
   IF s_joint_venture( l_ohb.ohb04,g_plant) OR NOT s_internal_item( l_ohb.ohb04,g_plant ) THEN
      RETURN
   END IF
   #FUN-AB0059 ---------------------end-------------------------------
   
   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
    WHERE ima01 = l_ohb.ohb04
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF cl_null(g_ima906) or g_ima906 = '1' THEN
      RETURN
   END IF
 
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_ohb.ohb913) THEN
         CALL saxmt700sub_upd_imgg('1',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,+1,'2',l_oha.oha02)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ohb.ohb915) THEN                             #CHI-860005  
            CALL saxmt700sub_tlff('2',l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,l_oha.*,l_ohb.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(l_ohb.ohb910) THEN
         CALL saxmt700sub_upd_imgg('1',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,+1,'1',l_oha.oha02)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ohb.ohb912) THEN                             #CHI-860005 
            CALL saxmt700sub_tlff('1',l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,l_oha.*,l_ohb.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_ohb.ohb913) THEN
         CALL saxmt700sub_upd_imgg('2',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,+1,'2',l_oha.oha02)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ohb.ohb915) THEN                             #CHI-860005
            CALL saxmt700sub_tlff('2',l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,l_oha.*,l_ohb.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
END FUNCTION

#更新发票仓的多单位,库存异动记录
FUNCTION saxmt700sub_update_du2(l_oha,l_ohb)
   DEFINE l_oha     RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb     RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE l_ima25   LIKE ima_file.ima25,
          u_type    LIKE type_file.num5        # No.FUN-680137  SMALLINT
   
   #FUN-AB0059 ---------------------start---------------------------- 
   IF s_joint_venture( l_ohb.ohb04,g_plant) OR NOT s_internal_item( l_ohb.ohb04,g_plant ) THEN
      RETURN
   END IF
   #FUN-AB0059 ---------------------end-------------------------------
   
   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
    WHERE ima01 = l_ohb.ohb04
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF cl_null(g_ima906) or g_ima906 = '1' THEN
      RETURN
   END IF
 
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_ohb.ohb913) THEN
         CALL saxmt700sub_upd_imgg('1',l_ohb.ohb04,g_oaz.oaz95,l_oha.oha03,l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,-1,'2',l_oha.oha02)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ohb.ohb915) THEN                             #CHI-860005  
            CALL saxmt700sub_tlff2('2',l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,l_oha.*,l_ohb.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(l_ohb.ohb910) THEN
         CALL saxmt700sub_upd_imgg('1',l_ohb.ohb04,g_oaz.oaz95,l_oha.oha03,l_ohb.ohb092,l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,-1,'1',l_oha.oha02)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ohb.ohb912) THEN                             #CHI-860005 
            CALL saxmt700sub_tlff2('1',l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,l_oha.*,l_ohb.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_ohb.ohb913) THEN
         CALL saxmt700sub_upd_imgg('2',l_ohb.ohb04,g_oaz.oaz95,l_oha.oha03,l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,-1,'2',l_oha.oha02)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ohb.ohb915) THEN                             #CHI-860005
            CALL saxmt700sub_tlff2('2',l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,l_oha.*,l_ohb.*)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION saxmt700sub_update_ogbslk(p_ogbslk03,p_oga01)
   DEFINE p_oga01      LIKE oga_file.oga01   #DEV-D30046 --add
   DEFINE l_ogb12      LIKE ogb_file.ogb12
   DEFINE l_ogb14      LIKE ogb_file.ogb14
   DEFINE l_ogb14t     LIKE ogb_file.ogb14t
   DEFINE l_ogb16      LIKE ogb_file.ogb16
   DEFINE l_ogb18      LIKE ogb_file.ogb18
   DEFINE l_ogb60      LIKE ogb_file.ogb60
   DEFINE l_ogb63      LIKE ogb_file.ogb63
   DEFINE l_ogb64      LIKE ogb_file.ogb64
   DEFINE l_ogb1013    LIKE ogb_file.ogb1013
   DEFINE p_ogbslk03   LIKE ogbslk_file.ogbslk03
  
   SELECT SUM(ogb12),SUM(ogb14),SUM(ogb14t),SUM(ogb16),SUM(ogb18),SUM(ogb60),SUM(ogb63),SUM(ogb64),SUM(ogb1013)
     INTO l_ogb12,l_ogb14,l_ogb14t,l_ogb16,l_ogb18,l_ogb60,l_ogb63,l_ogb64,l_ogb1013
     FROM ogb_file,ogbi_file
   WHERE ogb01=ogbi01 AND ogb03=ogbi03 AND ogbislk02=p_ogbslk03 AND ogb01=p_oga01

   IF SQLCA.sqlcode OR cl_null(l_ogb12) THEN
      LET l_ogb12 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_ogb14) THEN
      LET l_ogb14 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_ogb14t) THEN
      LET l_ogb14t = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_ogb16) THEN
      LET l_ogb16 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_ogb18) THEN
      LET l_ogb18 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_ogb60) THEN
      LET l_ogb60 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_ogb63) THEN
      LET l_ogb63 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_ogb64) THEN
      LET l_ogb64 = 0
   END IF
   IF SQLCA.sqlcode OR cl_null(l_ogb1013) THEN
      LET l_ogb1013 = 0
   END IF
   UPDATE ogbslk_file SET ogbslk12=l_ogb12,ogbslk14=l_ogb14,ogbslk14t=l_ogb14t,
                          ogbslk16=l_ogb16,ogbslk18=l_ogb18,ogbslk60=l_ogb60,
                          ogbslk63=l_ogb63,ogbslk64=l_ogb64,ogbslk1013=l_ogb1013
     WHERE ogbslk01=p_oga01 AND ogbslk03=p_ogbslk03
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ogbslk_file","","",SQLCA.sqlcode,"","",1)
   END IF
END FUNCTION

FUNCTION saxmt700sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                          p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_oha02)
   DEFINE p_imgg00       LIKE imgg_file.imgg00,
          p_imgg01       LIKE imgg_file.imgg01,
          p_imgg02       LIKE imgg_file.imgg02,
          p_imgg03       LIKE imgg_file.imgg03,
          p_imgg04       LIKE imgg_file.imgg04,
          p_imgg09       LIKE imgg_file.imgg09,
          p_imgg211      LIKE imgg_file.imgg211,
          p_no           LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1)
          l_ima25        LIKE ima_file.ima25,
          l_ima906       LIKE ima_file.ima906,
          l_imgg21       LIKE imgg_file.imgg21,
          p_imgg10       LIKE imgg_file.imgg10,
          p_type         LIKE type_file.num10       # No.FUN-680137 INTEGER
   DEFINE p_oha02        LIKE oha_file.oha02   #DEV-D30046 --add
   DEFINE l_forupd_sql   STRING                #DEV-D30046 --add
   DEFINE l_cnt          LIKE type_file.num5   #DEV-D30046 --add
 
   LET l_forupd_sql =
       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
       " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
       "   AND imgg09= ? FOR UPDATE "                  #no.TQC-750149 
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE imgg_lock CURSOR FROM l_forupd_sql
 
   OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL s_errmsg('','',"OPEN imgg_lock:", STATUS, 1)  #No.FUN-710028
      LET g_success='N'
      CLOSE imgg_lock
      CALL s_showmsg()   #No.FUN-710028
      RETURN
   END IF

   FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09 
   IF STATUS THEN
      CALL s_errmsg('','','lock imgg fail',STATUS,1)  #No.FUN-710028
      LET g_success='N'
      CLOSE imgg_lock
      CALL s_showmsg()   #No.FUN-710028
      RETURN
   END IF
 
   SELECT ima25,ima906 INTO l_ima25,l_ima906
     FROM ima_file WHERE ima01=p_imgg01
   IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
      CALL s_errmsg('ima01',p_imgg01,'ima25 null',SQLCA.sqlcode,1)   #No.FUN-710028
      LET g_success = 'N' RETURN
   END IF
 
   CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
      RETURNING l_cnt,l_imgg21
   IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
      CALL s_errmsg('','','','mfg3075',1)   #No.FUN-710028
      LET g_success = 'N' RETURN
   END IF
 
   CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_oha02,  #FUN-8C0084
         '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
   IF g_success='N' THEN RETURN END IF
END FUNCTION

FUNCTION saxmt700sub_upd_imgg_oh(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_oga02)
   DEFINE l_ima25        LIKE ima_file.ima25,
          l_ima906       LIKE ima_file.ima906,
          p_imgg00       LIKE imgg_file.imgg00,
          p_imgg01       LIKE imgg_file.imgg01,
          p_imgg02       LIKE imgg_file.imgg02,
          p_imgg03       LIKE imgg_file.imgg03,
          p_imgg04       LIKE imgg_file.imgg04,
          p_imgg09       LIKE imgg_file.imgg09,
          p_imgg10       LIKE imgg_file.imgg10,
          p_imgg21       LIKE imgg_file.imgg21,
          p_imgg211      LIKE imgg_file.imgg211,
          l_imgg211      LIKE imgg_file.imgg211,
          l_imgg21       LIKE imgg_file.imgg21,
          l_imgg10       LIKE imgg_file.imgg10,
          p_type         LIKE aba_file.aba18,      # No.FUN-680137  VARCHAR(2)
          P_no           LIKE type_file.chr1        # No.FUN-680137  VARCHAR(1)
   DEFINE p_oga02        LIKE oga_file.oga01   #DEV-D30046 --add
   DEFINE l_forupd_sql   STRING                #DEV-D30046 --add
   DEFINE l_cnt          LIKE type_file.num5   #DEV-D30046 --add
   
   #FUN-AB0059 ---------------------start---------------------------- 
   IF s_joint_venture( p_imgg01,g_plant) OR NOT s_internal_item( p_imgg01,g_plant ) THEN
      RETURN
   END IF
   #FUN-AB0059 ---------------------end-------------------------------
   
   LET l_forupd_sql="SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
                    " WHERE imgg01= ? AND imgg02= ?",
                    "   AND imgg03=? AND imgg04=?",
                    "   AND imgg09=? FOR UPDATE "  #NO.TQC-750149
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE imgg_lock1 CURSOR FROM l_forupd_sql

   OPEN imgg_lock1 USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL s_errmsg('','','open imgg_lock:',STATUS,1)  #No.FUN-710028
      LET g_success='N'
      CLOSE imgg_lock1
      CALL s_showmsg()   #No.FUN-710028
      RETURN
   END IF

   FETCH imgg_lock1 INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09 
   IF STATUS THEN
      CALL s_errmsg('','','lock imgg fail',STATUS,1)   #No.FUN-710028
      LET g_success='N'
      CLOSE imgg_lock1
      CALL s_showmsg()   #No.FUN-710028
      RETURN  
   END IF

   SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file
    WHERE ima01=p_imgg01
   IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
      CALL s_errmsg('ima01',p_imgg01,'ima25 null',SQLCA.sqlcode,1)  #No.FUN-710028
      LET g_success='N'
      RETURN
   END IF
   CALL s_umfchk(p_imgg01,p_imgg09,l_ima25) RETURNING l_cnt,l_imgg21
   IF l_cnt=1 AND NOT (l_ima906='3' AND p_no='2') THEN
      CALL s_errmsg('','','','mfg3075',1)   #No.FUN-710028
      LET g_success='N' RETURN
   END IF
   CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_oga02, #FUN-8C0084
                 '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg21)     #FUN-8C0084
   IF g_success='N' THEN RETURN END IF
END FUNCTION

FUNCTION saxmt700sub_tlff_oh(p_flag,p_unit,p_fac,p_qty,l_oga,l_ogb)
   DEFINE l_oga          RECORD LIKE oga_file.*   #DEV-D30046 --add
   DEFINE l_ogb          RECORD LIKE ogb_file.*   #DEV-D30046 --add
   DEFINE l_ima25        LIKE ima_file.ima25,
          l_ima86        LIKE ima_file.ima86,
          l_imgg10       LIKE imgg_file.imgg10,
          p_flag         LIKE type_file.chr1,      # No.FUN-680137 VARCHAR(4) #TQC-840066
          p_unit         LIKE ogb_file.ogb913,      # No.FUN-680137 VARCHAR(4) #TQC-840066
          p_fac          LIKE pml_file.pml09,      # No.FUN-680137  DECIMAL(16,8)
          p_qty          LIKE ogb_file.ogb915      # No.FUN-680137  DECIMAL(13,3) #TQC-840066
   DEFINE l_forupd_sql   STRING   #DEV-D30046 --add
 
   #FUN-AB0059 ---------------------start---------------------------- 
   IF s_joint_venture( l_ogb.ogb04,g_plant) OR NOT s_internal_item( l_ogb.ogb04,g_plant ) THEN
      RETURN
   END IF
   #FUN-AB0059 ---------------------end-------------------------------
   
   LET l_forupd_sql="SELECT ima25,ima86 FROM ima_file ",
                    " WHERE ima01=? FOR UPDATE"         #NO.TQC-750149
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock7 CURSOR FROM l_forupd_sql
   OPEN ima_lock7 USING l_ogb.ogb04
   IF STATUS THEN
      CALL s_errmsg('','','lock ima_file',STATUS,1)  #No.FUN-710028
      LET g_success='N'
      RETURN
   END IF
   FETCH ima_lock7 INTO l_ima25,l_ima86
   IF STATUS THEN
      CALL s_errmsg('','','lock ima_file',STATUS,1)  #No.FUN-710028
      LET g_success='N'
      RETURN
   END IF
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=l_ogb.ogb04
      AND imgg02=l_ogb.ogb09
      AND imgg03=l_ogb.ogb091
      AND imgg04=l_ogb.ogb092
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN
      LET l_imgg10=0
   END IF
   LET g_tlff.tlff02=50
   LET g_tlff.tlff020=l_ogb.ogb08
   LET g_tlff.tlff021=l_ogb.ogb09
   LET g_tlff.tlff022=l_ogb.ogb091
   LET g_tlff.tlff023=l_ogb.ogb092
   LET g_tlff.tlff024=l_imgg10
   LET g_tlff.tlff025=p_unit  
   LET g_tlff.tlff026=l_oga.oga01
   LET g_tlff.tlff027=l_ogb.ogb03  
   LET g_tlff.tlff01=l_ogb.ogb04 
   #目的
   LET g_tlff.tlff03=724
   LET g_tlff.tlff030=' '                 
   LET g_tlff.tlff031=' '
   LET g_tlff.tlff032=' '
   LET g_tlff.tlff033=' '
   LET g_tlff.tlff034=0
   LET g_tlff.tlff035=' '
   LET g_tlff.tlff036=l_oga.oga01
   LET g_tlff.tlff037=l_ogb.ogb03  
   LET g_tlff.tlff04=' '                 
   LET g_tlff.tlff05=' '
   LET g_tlff.tlff06=l_oga.oga02
   LET g_tlff.tlff07=g_today
   LET g_tlff.tlff08=TIME
   LET g_tlff.tlff09=g_user
   LET g_tlff.tlff10=p_qty
   LET g_tlff.tlff11=p_unit
   LET g_tlff.tlff12=p_fac
   LET g_tlff.tlff13='axmt620'
   LET g_tlff.tlff14=' '
   LET g_tlff.tlff17=' '
   CALL s_imaQOH(l_ogb.ogb04) RETURNING g_tlff.tlff18
   LET g_tlff.tlff19=l_oga.oga04
   LET g_tlff.tlff61=l_ima86
   LET g_tlff.tlff64=l_ogb.ogb908
   LET g_tlff.tlff930=l_ogb.ogb930 #FUN-670063
   IF cl_null(l_ogb.ogb915) OR l_ogb.ogb915=0 THEN
      CALL s_tlff(p_flag,NULL)
   ELSE
      CALL s_tlff(p_flag,l_ogb.ogb913)
   END IF
END FUNCTION

FUNCTION saxmt700sub_tlf_7(p_unit,p_img10,l_oga,l_ogb)
   DEFINE l_oga    RECORD LIKE oga_file.*   #DEV-D30046 --add
   DEFINE l_ogb    RECORD LIKE ogb_file.*   #DEV-D30046 --add
   DEFINE p_unit   LIKE gsb_file.gsb05,      # No.FUN-680137 VARCHAR(4)
          p_img10  LIKE img_file.img10
          
    LET g_tlf.tlf01=l_ogb.ogb04
    LET g_tlf.tlf02=50
    LET g_tlf.tlf021=l_ogb.ogb09
    LET g_tlf.tlf024=p_img10
    LET g_tlf.tlf022=l_ogb.ogb091     
    LET g_tlf.tlf023=l_ogb.ogb092        
    LET g_tlf.tlf025=p_unit
    
    LET g_tlf.tlf03=724
    LET g_tlf.tlf030=' '
    LET g_tlf.tlf031=' '
    LET g_tlf.tlf032=' '
    LET g_tlf.tlf033=' '
    LET g_tlf.tlf034=0
    LET g_tlf.tlf035=' '
    LET g_tlf.tlf036=l_oga.oga01
    LET g_tlf.tlf037=l_ogb.ogb03
    
    LET g_tlf.tlf04=' '
    LET g_tlf.tlf05=' '
    LET g_tlf.tlf06=l_oga.oga02
    LET g_tlf.tlf07=g_today
    LET g_tlf.tlf08=TIME
    LET g_tlf.tlf09=g_user
    LET g_tlf.tlf10=l_ogb.ogb12
    LET g_tlf.tlf11=l_ogb.ogb05
    LET g_tlf.tlf12=l_ogb.ogb15_fac
    LET g_tlf.tlf13='axmt620'
    LET g_tlf.tlf14=l_ogb.ogb1001   #MOD-870120
    
    LET g_tlf.tlf17=' '
    CALL s_imaQOH(l_ogb.ogb04) RETURNING g_tlf.tlf18
    LET g_tlf.tlf19=l_oga.oga03 #No.MOD-870252
    LET g_tlf.tlf61=g_ima86
    LET g_tlf.tlf64=l_ogb.ogb908
    LET g_tlf.tlf930=l_ogb.ogb930 #FUN-670063
    LET g_tlf.tlf20 = l_ogb.ogb41
    LET g_tlf.tlf41 = l_ogb.ogb42
    LET g_tlf.tlf42 = l_ogb.ogb43
    LET g_tlf.tlf43 = l_ogb.ogb1001
    CALL s_tlf(1,0)
END FUNCTION 

FUNCTION saxmt700sub_tlff(p_flag,p_unit,p_fac,p_qty,l_oha,l_ohb)
   DEFINE l_oha      RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb      RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE p_flag     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_unit     LIKE img_file.img09,
          p_fac      LIKE img_file.img21,
          p_qty      LIKE img_file.img10,
          l_imgg10   LIKE imgg_file.imgg10
 
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=l_ohb.ohb04  AND imgg02=l_ohb.ohb09
      AND imgg03=l_ohb.ohb091 AND imgg04=l_ohb.ohb092
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
   #----來源----
   LET g_tlff.tlff01=l_ohb.ohb04     #異動料件編號
   LET g_tlff.tlff02=731
   LET g_tlff.tlff020=' '
   LET g_tlff.tlff021=' '            #倉庫
   LET g_tlff.tlff022=' '            #儲位
   LET g_tlff.tlff023=' '            #批號
   LET g_tlff.tlff024=0              #異動後數量
   LET g_tlff.tlff025=' '            #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=l_oha.oha01    #銷退單號
   LET g_tlff.tlff027=l_ohb.ohb03    #銷退項次
   #---目的----
   LET g_tlff.tlff03=50
   LET g_tlff.tlff030=l_ohb.ohb08
   LET g_tlff.tlff031=l_ohb.ohb09    #倉庫
   LET g_tlff.tlff032=l_ohb.ohb091   #儲位
   LET g_tlff.tlff033=l_ohb.ohb092   #批號
   LET g_tlff.tlff034=l_imgg10       #異動後庫存數量
   LET g_tlff.tlff035=p_unit         #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=l_oha.oha01    #銷退單號
   LET g_tlff.tlff037=l_ohb.ohb03    #銷退項次
 
 
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=l_oha.oha02      #銷退日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12=p_fac            #發料/庫存 換算率
   LET g_tlff.tlff13='aomt800'                            #TQC-630210
   LET g_tlff.tlff14=' '              #異動原因
 
  LET g_tlff.tlff17=' '              #非庫存性料件編號
  CALL s_imaQOH(l_ohb.ohb04)
       RETURNING g_tlff.tlff18
  LET g_tlff.tlff19=l_oha.oha04
  SELECT oga46 INTO g_tlff.tlff20 FROM oga_file WHERE oga01=l_ohb.ohb31
  LET g_tlff.tlff61= g_ima86
  LET g_tlff.tlff62=l_ohb.ohb33    #參考單號(訂單)
  LET g_tlff.tlff64=l_ohb.ohb52    #手冊編號 NO.A093
  LET g_tlff.tlff930=l_ohb.ohb930  #FUN-670063
  IF cl_null(l_ohb.ohb915) OR l_ohb.ohb915 = 0 THEN
     CALL s_tlff(p_flag,NULL)
  ELSE
     CALL s_tlff(p_flag,l_ohb.ohb913)
  END IF
END FUNCTION

#发票仓tlff异动记录
FUNCTION saxmt700sub_tlff2(p_flag,p_unit,p_fac,p_qty,l_oha,l_ohb)
   DEFINE l_oha      RECORD LIKE oha_file.*   #DEV-D30046 --add
   DEFINE l_ohb      RECORD LIKE ohb_file.*   #DEV-D30046 --add
   DEFINE p_flag     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          p_unit     LIKE img_file.img09,
          p_fac      LIKE img_file.img21,
          p_qty      LIKE img_file.img10,
          l_imgg10   LIKE imgg_file.imgg10
 
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=l_ohb.ohb04  AND imgg02=g_oaz.oaz95
      AND imgg03=l_oha.oha03 AND imgg04=l_ohb.ohb092
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
   #----來源----
   LET g_tlff.tlff01=l_ohb.ohb04     #異動料件編號 
   LET g_tlff.tlff02=50
   LET g_tlff.tlff020=l_ohb.ohb08
   LET g_tlff.tlff021=g_oaz.oaz95    #倉庫
   LET g_tlff.tlff022=l_oha.oha03    #儲位
   LET g_tlff.tlff023=l_ohb.ohb092   #批號
   LET g_tlff.tlff024=l_imgg10       #異動後數量
   LET g_tlff.tlff025=p_unit         #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=l_oha.oha01    #銷退單號
   LET g_tlff.tlff027=l_ohb.ohb03    #銷退項次
   #---目的----
   LET g_tlff.tlff03=731
   LET g_tlff.tlff030=' '
   LET g_tlff.tlff031=' '    #倉庫
   LET g_tlff.tlff032=' '    #儲位
   LET g_tlff.tlff033=' '   #批號
   LET g_tlff.tlff034=0       #異動後庫存數量
   LET g_tlff.tlff035=' '         #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=l_oha.oha01    #銷退單號
   LET g_tlff.tlff037=l_ohb.ohb03    #銷退項次    
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=l_oha.oha02      #銷退日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12=p_fac            #發料/庫存 換算率
   LET g_tlff.tlff13='aomt800'                            #TQC-630210
   LET g_tlff.tlff14=' '              #異動原因
 
  LET g_tlff.tlff17=' '              #非庫存性料件編號
  CALL s_imaQOH(l_ohb.ohb04)
       RETURNING g_tlff.tlff18
  LET g_tlff.tlff19=l_oha.oha04
  SELECT oga46 INTO g_tlff.tlff20 FROM oga_file WHERE oga01=l_ohb.ohb31
  LET g_tlff.tlff61= g_ima86
  LET g_tlff.tlff62=l_ohb.ohb33    #參考單號(訂單)
  LET g_tlff.tlff64=l_ohb.ohb52    #手冊編號 NO.A093
  LET g_tlff.tlff930=l_ohb.ohb930  #FUN-670063
  IF cl_null(l_ohb.ohb915) OR l_ohb.ohb915 = 0 THEN
     CALL s_tlff(p_flag,NULL)
  ELSE
     CALL s_tlff(p_flag,l_ohb.ohb913)
  END IF
END FUNCTION

FUNCTION saxmt700sub_refresh(p_oha01)
   DEFINE p_oha01       LIKE oha_file.oha01
   DEFINE l_oha         RECORD LIKE oha_file.*

   SELECT * INTO l_oha.* FROM oha_file WHERE oha01 = p_oha01
   
   RETURN l_oha.*
END FUNCTION 

#DEV-D30046 --add
#DEV-D40013 --add
