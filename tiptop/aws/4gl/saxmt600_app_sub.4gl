# Prog. Version..: '5.30.06-13.04.24(00010)'     #
#
# Program name...: saxmt600_app_sub.4gl
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_bookno1       LIKE aza_file.aza81          #No.FUN-730057
DEFINE   g_bookno2       LIKE aza_file.aza82          #No.FUN-730057
DEFINE   g_flag          LIKE type_file.chr1          #No.FUN-730057
DEFINE   g_flag2         LIKE type_file.chr1          #FUN-C80107 add
DEFINE   g_exdate       LIKE oga_file.oga021  #MOD-780068 add
DEFINE p_success1    LIKE type_file.chr1     #No.TQC-7C0114
DEFINE   g_ina         RECORD LIKE ina_file.*  #No.FUN-7C0017
DEFINE   g_ica         RECORD LIKE ica_file.*  #No.FUN-7B0014
DEFINE   g_inb         RECORD LIKE inb_file.*  #No.FUN-7B0014
DEFINE   g_msg         LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_msg1        LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_msg2        LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_msg3        LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_cnt         LIKE type_file.num5     #No.FUN-7B0014
DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036
DEFINE g_ima930  LIKE ima_file.ima930  #DEV-D30040 add
DEFINE g_ima906  LIKE ima_file.ima906  #MOD-C50088
DEFINE g_forupd_sql    STRING
DEFINE g_rxx04_point LIKE rxx_file.rxx04         #抵現積分              #FUN-BA0069 add
DEFINE g_oah08         LIKE oah_file.oah08     #FUN-C40089 
#DEFINE g_act           LIKE type_file.chr1     #FUN-C50136
DEFINE g_inTransaction         LIKE type_file.chr1  #MOD-CA0131 add
 
#kim 注意 : 此sub routine中請勿宣告任何global或modual變數,若有需要,請用傳遞參數的方式來解決,
#因為此處的所有FUN應該可提供外部程式獨立呼叫
 
#{
#作用:出貨單確認前的檢查
#p_oga01:本筆出貨單的單號
#p_action_choice:執行"確認"的按鈕的名稱,若外部呼叫可傳NULL #CHI-C30118 add
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,IF g_success='Y' THEN 檢查成功 ; IF g_success='N' THEN 檢查有錯誤
#}
FUNCTION t600_app_sub_y_chk(p_oga01,p_action_choice) #CHI-C30118 add p_action_choice
 DEFINE p_action_choice STRING #CHI-C30118 add
 DEFINE p_oga01 LIKE oga_file.oga01
 DEFINE l_argv0 LIKE ogb_file.ogb09
 DEFINE l_ogb09       LIKE ogb_file.ogb09,  #No.9736
        l_cnt         LIKE type_file.num5,    #No.FUN-680137 SMALLINT
        l_yy,l_mm     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
        l_oea161      LIKE oea_file.oea161,
        l_oea162      LIKE oea_file.oea162,
        l_oea163      LIKE oea_file.oea163
 DEFINE l_sql     STRING
 DEFINE l_ogb19   LIKE ogb_file.ogb19,
        l_ogb11   LIKE ogb_file.ogb11,
        l_ogb12   LIKE ogb_file.ogb12,
        l_qcs01   LIKE qcs_file.qcs01,
        l_qcs02   LIKE qcs_file.qcs02,
        l_oga09   LIKE oga_file.oga09,
        l_qcs091c LIKE qcs_file.qcs091
 DEFINE l_ogb910      LIKE ogb_file.ogb910,
        l_ogb912      LIKE ogb_file.ogb912,
        l_x1,l_x2     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
        l_msg,l_msg1,l_msg2,l_msg3  STRING    #No.TQC-7C0114
 DEFINE l_ogb1005     LIKE ogb_file.ogb1005     #No.FUN-610064
 DEFINE l_oma55   LIKE oma_file.oma55  #FUN-650105
 DEFINE l_oma54t  LIKE oma_file.oma54t #FUN-650105
 DEFINE l_oma54   LIKE oma_file.oma54  #TQC-AB0381 add
 DEFINE l_oga     RECORD LIKE oga_file.*
 DEFINE l_ogb1007     LIKE ogb_file.ogb1007,
        l_ogb1010     LIKE ogb_file.ogb1010,
        l_ogb14       LIKE ogb_file.ogb14,
        l_ogb14t      LIKE ogb_file.ogb14t,
        l_n           LIKE type_file.num5,                    #No.FUN-680137 SMALLINT
        l_max         LIKE tqw_file.tqw08,
        l_tqw08       LIKE tqw_file.tqw08,
        l_tqw081      LIKE tqw_file.tqw081,
        l_ogb31       LIKE ogb_file.ogb31,    #No.FUN-670008
        l_ogb32       LIKE ogb_file.ogb32,    #No.FUN-670008
        l_retn_amt    LIKE ohb_file.ohb14     #No.FUN-670008
 DEFINE l_ogb         RECORD LIKE ogb_file.*
 DEFINE l_ogc         RECORD LIKE ogc_file.*   #FUN-B40081
 DEFINE l_tmp         LIKE type_file.chr1000
 DEFINE l_flag        LIKE type_file.num5
 #DEFINE l_imaicd04    LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
 #DEFINE l_imaicd08    LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
 DEFINE l_rvbs06      LIKE rvbs_file.rvbs06
 DEFINE l_ogb14t_1    LIKE ogb_file.ogb14t   #No.FUN-870007
 DEFINE l_rxx04       LIKE rxx_file.rxx04    #No.FUN-870007
 DEFINE l_ogb47       LIKE ogb_file.ogb47    #No.FUN-870007
 DEFINE l_oea261      LIKE oea_file.oea261    #No:FUN-A50103
 DEFINE l_oea213      LIKE oea_file.oea213    #TQC-B30120  
#DEFINE l_imaicd13    LIKE imaicd_file.imaicd13  #FUN-A40022  #FUN-B50096
 DEFINE l_ima159      LIKE ima_file.ima159  #FUN-B50096
 DEFINE l_ogc12_t     LIKE ogc_file.ogc12   #CHI-AC0034 add
#TQC-B20053 -------------STA
 DEFINE l_ogb04       LIKE ogb_file.ogb04     
 DEFINE l_ogb05       LIKE ogb_file.ogb05     
 DEFINE l_ogb13       LIKE ogb_file.ogb13           
 DEFINE l_rtg01       LIKE rtg_file.rtg01
 DEFINE l_rtg07       LIKE rtg_file.rtg07
 DEFINE l_rtg08       LIKE rtg_file.rtg08            
 DEFINE l_rth06       LIKE rth_file.rth06
#TQC-B20053 -------------END 
 #FUN-BC0064------add-----str---
 DEFINE l_rxe04       LIKE rxe_file.rxe04
 DEFINE l_rxe05       LIKE rxe_file.rxe05
 DEFINE l_rxe08       LIKE rxe_file.rxe08
 DEFINE l_lqe01       LIKE lqe_file.lqe01
 DEFINE l_ogb03       LIKE ogb_file.ogb03
 DEFINE l_ima154      LIKE ima_file.ima154
 DEFINE g_sql         STRING             
 DEFINE l_ogb1001     LIKE ogb_file.ogb1001
 DEFINE l_lqw12       LIKE lqw_file.lqw12
 DEFINE l_lqw08_1_s   LIKE lqw_file.lqw08
 #FUN-BC0064------add-----end---
 DEFINE l_ogb04_1 LIKE ogb_file.ogb04   #FUN-BC0071 add
 DEFINE l_rxe02       LIKE rxe_file.rxe02  #TQC-C30129
 DEFINE l_ogb31_1       LIKE ogb_file.ogb31   #TQC-C30129
 DEFINE l_img09   LIKE img_file.img09 #CHI-C30064
 DEFINE l_ogb05_fac   LIKE ogb_file.ogb05_fac #CHI-C30064 add 
 DEFINE l_ogamksg     LIKE oga_file.ogamksg #CHI-C30118 add
 DEFINE l_oga55       LIKE oga_file.oga55   #CHI-C30118 add
 DEFINE l_ogg         RECORD LIKE ogg_file.*   #MOD-C40149 add
 DEFINE l_ogbslk03    LIKE ogbslk_file.ogbslk03   #FUN-C70098--add
 DEFINE l_ogbslk04    LIKE ogbslk_file.ogbslk04   #FUN-C70098--add
 DEFINE l_ogbslk12    LIKE ogbslk_file.ogbslk12   #FUN-C70098--add
 DEFINE l_gemacti     LIKE gem_file.gemacti       #TQC-C60211
 DEFINE l_n2          LIKE type_file.num5    #CHI-C30104 add
 DEFINE l_npq07f      LIKE npq_file.npq07f #CHI-C10016 add
 DEFINE l_oga50       LIKE oga_file.oga50  #CHI-C10016 add
 DEFINE l_oga07       LIKE oga_file.oga07  #CHI-C10016 add
 DEFINE l_ibd09       LIKE ibd_file.ibd09  #DEV-D40016 add

 WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012

 LET g_success = 'Y'
 
 IF cl_null(p_oga01) IS NULL THEN
    CALL cl_err('',-400,0)
    LET g_success = 'N'
    RETURN
 END IF
 SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01

 LET l_argv0=l_oga.oga09  #FUN-730012
 IF l_oga.oga01 IS NULL THEN
    CALL cl_err('',-400,0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 IF l_oga.ogaconf = 'X' THEN
    CALL cl_err('',9024,0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 IF l_oga.ogaconf = 'Y' THEN
    LET g_success = 'N'   #FUN-580113
    CALL cl_err('','axm-101',0)  #TQC-7C0011
    RETURN
 END IF

 #DEV-D40019 add str-------
 #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
 IF g_aza.aza131 = 'Y' AND (g_prog = 'axmt610') THEN
   #確認是否有符合條件的料件
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM ima_file
     WHERE ima01 IN (SELECT ogb04 FROM ogb_file WHERE ogb01 = l_oga.oga01) #料件
       AND ima930 = 'Y'                   #條碼使用否
       AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
      
   #確認是否已有掃描紀錄
    IF l_cnt > 0 THEN
       IF cl_null(l_oga.oga011) AND l_oga.oga09 = '1' THEN #oga09='1':出貨通知單 #DEV-D40018 add if 判斷當出通單號(oga011) 沒有值時
           IF NOT s_chk_barcode_confirm('confirm','ibj',l_oga.oga01,'','') THEN
              LET g_success = 'N'
              RETURN
           END IF
       END IF #DEV-D40018 add
    END IF
 END IF
 #DEV-D40019 add end-------

#TQC-C60211 -- add -- begin
 SELECT gemacti INTO l_gemacti FROM gem_file
  WHERE gem01 = l_oga.oga15
 IF l_gemacti = 'N' THEN
    CALL cl_err(l_oga.oga15,'asf-472',0)
    LET g_success = 'N'
    RETURN
 END IF
#TQC-C60211 -- add -- end
 SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01

 LET l_argv0=l_oga.oga09  
 IF l_oga.oga01 IS NULL THEN
    LET g_success = 'N'   
    RETURN
 END IF
 IF l_oga.ogaconf = 'X' THEN
    LET g_success = 'N'  
    RETURN
 END IF
 IF l_oga.ogaconf = 'Y' THEN
    LET g_success = 'N'   
    RETURN
 END IF
#CHI-C30107 ------------------ add ---------------- end
#CHI-C30118---add---END   
 #FUN-C40089---begin
 SELECT oah08 INTO g_oah08 FROM oah_file WHERE oah01=l_oga.oga31
 IF cl_null(g_oah08) THEN
    LET g_oah08 = 'Y'
 END IF 
 IF g_oah08= 'N' THEN
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM ogb_file
       WHERE ogb01=l_oga.oga01 AND ogb13=0
    IF l_cnt > 0 THEN
       LET g_success = 'N'
       RETURN
    END IF
 END IF
 #FUN-C40089---end
 #FUN-CB0087--add--str--
 IF g_aza.aza115='Y' AND l_argv0 MATCHES '[245689A]' THEN
    IF l_argv0 MATCHES '[2456A]' THEN
       SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE trim(ogb1001) IS NULL AND ogb01=l_oga.oga01
    ELSE  # 8 9
       SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE trim(ogb65) IS NULL AND ogb01=l_oga.oga01 AND ogb52<>0
    END IF 
    IF l_cnt>=1 THEN
       LET g_success='N'
       RETURN
    END IF
 END IF 

 
 IF g_azw.azw04='2' THEN
   #TQC-C30283--add--str--
   IF l_oga.oga57 = '2' THEN 
      SELECT COUNT(*) INTO l_n FROM ogb_file WHERE ogb01 = l_oga.oga01 AND ogb49 IS NULL 
      IF l_n > 0 THEN 
         LET g_success='N'
         RETURN
      END IF 
   END IF 
   #TQC-C30283--add--end--
   IF l_oga.oga85='1' THEN
      SELECT SUM(ogb14t) INTO l_ogb14t_1 FROM ogb_file
       WHERE ogb01=l_oga.oga01
      IF SQLCA.sqlcode=100 THEN LET l_ogb14t_1=NULL END IF                                                                       
      IF cl_null(l_ogb14t_1) THEN LET l_ogb14t_1=0 END IF  
#FUN-AB0061 -----------mark start----------------    
#     SELECT SUM(ogb47) INTO l_ogb47 FROM ogb_file                                                                           
#      WHERE ogb01=l_oga.oga01
#     IF cl_null(l_ogb47) THEN LET l_ogb47=0 END IF
#FUN-AB0061 -----------mark end----------------
      SELECT azi04 INTO t_azi04 FROM azi_file
        WHERE azi01=l_oga.oga23                  
#FUN-AB0061 -----------mark start----------------                                                  
#     IF l_oga.oga213='N' THEN                                                                                                
#        LET l_ogb47=l_ogb47*(1+l_oga.oga211/100)                                                                             
#        CALL cl_digcut(l_ogb47,t_azi04) RETURNING l_ogb47                                                                   
#     END  IF                                                                                                                
#     LET l_ogb14t_1=l_ogb14t_1-l_ogb47          
#FUN-AB0061 -----------mark end----------------                                                                                 
      CALL cl_digcut(l_ogb14t_1,t_azi04) RETURNING l_ogb14t_1     
      SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file
       WHERE rxx00='02' AND rxx01=l_oga.oga01
         AND rxx03='1' 
      IF SQLCA.sqlcode THEN 
         LET l_rxx04=NULL 
      END IF  
      IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF      
      IF l_rxx04<l_ogb14t_1 THEN
         LET g_success='N'
         RETURN
      END IF 
   END IF
 END IF

#TQC-B20053 -------------STA
#單身中項次對應的所有單價不可以低於採購策略中的最低價 
 IF g_azw.azw04='2' THEN                             
    DECLARE ogb13_curs CURSOR FOR 
       SELECT ogb04,ogb05,ogb13 FROM ogb_file 
        WHERE ogb01 = l_oga.oga01   
    FOREACH ogb13_curs INTO l_ogb04,l_ogb05,l_ogb13
        SELECT rtz05 INTO l_rtg01 FROM rtz_file 
             WHERE rtz01 = g_plant
        IF NOT cl_null(l_rtg01) AND l_ogb04 <> 'MISCCARD' THEN #FUN-C10051 add "AND l_ogb04 <> 'MISCCARD'"
           SELECT rtg07,rtg08 INTO l_rtg07,l_rtg08 FROM rtg_file,rtf_file
                WHERE rtg01=rtf01 AND rtfconf='Y'
                  AND rtg01 = l_rtg01
                  AND rtg03 = l_ogb04 AND rtg04 = l_ogb05
           IF SQLCA.sqlcode=100 THEN  
 #             CALL s_errmsg('ogb03',l_ogb04,' ','art-273',1)
              LET g_success='N'
              RETURN
           END IF
           IF l_rtg08='Y' THEN 
              SELECT rth06 INTO l_rth06 FROM rth_file
               WHERE rth01=l_ogb04                                          
                 AND rth02=l_ogb05 
                 AND rthplant=g_plant
              IF SQLCA.sqlcode=100 THEN
                 LET g_success='N'
                 RETURN
              END IF
              IF l_ogb13 < l_rth06 THEN
                 LET g_success='N'
                 RETURN
              END IF
           ELSE
              IF l_ogb13 < l_rtg07 THEN
                 LET g_success='N'
                 RETURN
              END IF
           END IF
        END IF

    END FOREACH

 END IF
#TQC-B20053 -------------END

#FUN-BC0071 -----------STA
    SELECT COUNT(*) INTO l_n  FROM ogb_file 
     WHERE ogb01 = l_oga.oga01
       AND ogb1001 = g_oaz.oaz88
     IF l_n > 0 THEN
       DECLARE l_ogb04_cur CURSOR FOR
        SELECT ogb04 FROM ogb_file
         WHERE ogb01= l_oga.oga01
           AND ogb1001 = g_oaz.oaz88
       FOREACH  l_ogb04_cur INTO l_ogb04_1 
          SELECT COUNT(*) INTO l_n FROM lpx_file,lqe_file,lqw_file
           WHERE lpx32 = l_ogb04_1 AND lpx01 = lqe02         #TQC-C20407 mod
             AND lqw08 = lqe02 AND lqw00 = '02'
              AND lqw01= l_oga.oga01
              AND lqe01 BETWEEN lqw09 AND lqw10
              AND ((lqe17 NOT IN ('5','2') AND lqe13 = l_oga.ogaplant)
                 OR (lqe17 IN ('5','2') AND lqe13  <> l_oga.ogaplant))
           IF l_n > 0 THEN
              LET g_success = "N"
              RETURN
           END IF
       END FOREACH
       IF g_success = "N" THEN
          RETURN
       END IF
     END IF
  
#FUN-BC0064-----add----str------
#產品編號的數量要於券張數一致
IF g_azw.azw04 = '2' THEN
   CALL s_showmsg_init()
      
   LET g_sql = " SELECT ogb03,ogb04,ogb12,ogb1001 FROM ogb_file ",
               "  WHERE ogb01 = '",p_oga01,"' "
   DECLARE t600_sel_ogb_cr CURSOR FROM g_sql
   FOREACH t600_sel_ogb_cr INTO l_ogb03,l_ogb04,l_ogb12,l_ogb1001
      SELECT ima154 INTO l_ima154
        FROM ima_file
       WHERE ima01 = l_ogb04
      IF l_ima154 = 'Y' THEN
         LET l_n = 0
         SELECT COUNT(*) INTO l_n
           FROM lqw_file
          WHERE lqw00 = '02'
            AND lqw01 = l_ogb04 
        IF l_n = 0 THEN
        #FUN-CA0152---------add----end
            SELECT SUM(rxe08) INTO l_rxe08
              FROM rxe_file
             WHERE rxe00 = '02'
               AND rxe01 = p_oga01
               AND rxe02 = l_ogb03
            IF cl_null(l_rxe08) THEN
               LET l_rxe08 = 0
            END IF
            IF l_ogb12 <> l_rxe08 THEN
               LET g_success = 'N'
            END IF
         END IF
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      RETURN
   END IF
   LET g_sql = " SELECT rxe02,rxe04,rxe05 FROM rxe_file ",    #TQC-C30129 add rxe02
               "  WHERE rxe01 = '",p_oga01,"' ",
               "    AND rxe00 = '02' " 
   DECLARE t620_sel_rxe_cr CURSOR FROM g_sql
   FOREACH t620_sel_rxe_cr INTO l_rxe02,l_rxe04,l_rxe05      #TQC-C30129 add rxe02
#TQC-C30129 -------------STA
      SELECT ogb31 INTO l_ogb31_1 FROM ogb_file WHERE ogb01 = p_oga01 AND ogb03 =l_rxe02
      IF NOT cl_null(l_ogb31_1 ) THEN
         CONTINUE FOREACH
      END IF
#TQC-C30129 -------------END
      LET g_sql = "SELECT lqe01 FROM lqe_file ",
                  " WHERE lqe01 BETWEEN '",l_rxe04,"' AND '",l_rxe05,"'",
                  "   AND (lqe17 <> '5' OR lqe13 <> '",l_oga.ogaplant,"')",
                  "   AND (lqe17 <> '2' OR lqe09 <> '",l_oga.ogaplant,"')"
      PREPARE sel_lqe_pre FROM g_sql 
      DECLARE sel_lqe_cs CURSOR FOR sel_lqe_pre 
      FOREACH sel_lqe_cs INTO l_lqe01
         LET g_success = 'N'
      END FOREACH  
   END FOREACH
   IF g_success = 'N' THEN
      RETURN
   END IF
END IF

#FUN-BC0064-----add----end------

#無單身資料不可確認
 LET l_cnt=0
 SELECT COUNT(*) INTO l_cnt
   FROM ogb_file
  WHERE ogb01=l_oga.oga01
 IF l_cnt=0 OR l_cnt IS NULL THEN
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF

 #FUN-C70098----add----begin--------------
 IF s_industry("slk") AND g_azw.azw04 = '2' THEN
    DECLARE ogbslk04_curs CURSOR FOR
       SELECT ogbslk03,ogbslk04,ogbslk12 FROM ogbslk_file WHERE ogbslk01 = l_oga.oga01 
    CALL s_showmsg_init()
    FOREACH ogbslk04_curs INTO l_ogbslk03,l_ogbslk04,l_ogbslk12 
         IF cl_null(l_ogbslk12) OR l_ogbslk12 = 0 THEN
            LET g_success = 'N'
         END IF
    END FOREACH
    IF g_success = 'N' THEN
       RETURN
    END IF
 END IF
 #FUN-C70098----add----end----------------
 IF (l_oga.oga08='1' AND l_cnt > g_oaz.oaz691) OR
    (l_oga.oga08 MATCHES '[23]' AND l_cnt > g_oaz.oaz692) THEN
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
 #除了簽收單之外,單身不可有數量為0者, (在出貨單中審核時判斷出貨數量時排除折扣單的資料MOD-CC0232)
 LET l_cnt = 0 
 SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file 
   WHERE oga01 = ogb01 
     AND oga01 = l_oga.oga01
     AND oeb1007 IS NULL #MOD-CC0232 add
     AND (ogb12 IS NULL OR 
          (oga09 = '8' AND ogb12 < 0) OR 
          (oga09 <> '8' AND ogb12 <= 0))
 IF l_cnt > 0 THEN
    LET g_success = 'N'
    RETURN
 END IF

 #MOD-B30697 add --start--
 #oga07為Y時,oga13不可空白
 IF l_oga.oga07 = 'Y' AND cl_null(l_oga.oga13) THEN
    LET g_success = 'N'
    RETURN
 END IF
 #MOD-B30697 add --end--
 
   IF g_azw.azw04<>'2' THEN #No.FUN-870007
      IF l_oga.oga161>0 THEN
        DECLARE ogb_curs CURSOR FOR 
          SELECT ogb31 FROM ogb_file WHERE ogb01=l_oga.oga01
        FOREACH ogb_curs INTO l_ogb31 
           SELECT SUM(oma55) INTO l_oma55
             FROM oma_file
            WHERE oma16=l_ogb31   #MOD-850221   
              AND oma00='11'
              AND omaconf='Y'
           IF SQLCA.sqlcode OR cl_null(l_oma55) THEN
              LET l_oma55=0
           END IF
           SELECT SUM(oma54t) INTO l_oma54t
             FROM oma_file
            WHERE oma16=l_ogb31   #MOD-850221   
              AND oma00='11'
              AND omaconf='Y'
           IF SQLCA.sqlcode OR cl_null(l_oma54t) THEN
              LET l_oma54t=0
           END IF
           #TQC-AB0381 add ---------------begin----------------
           SELECT SUM(oma54) INTO l_oma54
             FROM oma_file
            WHERE oma16=l_ogb31   
              AND oma00='11'
              AND omaconf='Y'
           IF SQLCA.sqlcode OR cl_null(l_oma54) THEN
              LET l_oma54=0
           END IF
           #TQC-AB0381 add ----------------end----------------- 
           #-----No:FUN-A50103-----
           SELECT oea261,oea213 INTO l_oea261,l_oea213       #TQC-B30120 add oea213
             FROM oea_file
            WHERE oea01 = l_ogb31
           IF SQLCA.sqlcode OR cl_null(l_oea261) THEN
              LET l_oea261=0
           END IF

           IF l_oga.oga00 != '3' THEN #TQC-C20023 add
#TQC-B30120 --begin--
              CASE 
                WHEN (l_oea213 = 'Y')
                   IF l_oma54t <> l_oea261 THEN 
                      CALL cl_err('','axm-135',1)
                      LET g_success='N'
                      RETURN                   
                   END IF                      
                WHEN (l_oea213 = 'N')
                   IF l_oma54 <> l_oea261 THEN 
                      IF g_aza.aza26 != '2' OR g_ooz.ooz33 = 'Y' THEN #FUN-C90105 add
                         CALL cl_err('','axm-135',1)                
                         LET g_success='N'
                         RETURN                   
                      END IF #FUN-C90105 add
                   END IF                
               END CASE                            
#              #IF l_oma54t<>l_oea261 THEN #TQC-AB0381 mark
#              IF l_oma54<>l_oea261 THEN  #TQC-AB0381 add
#                CALL cl_err('','axm-135',1)
#                LET g_success='N'
#                RETURN
#              END IF
#              #-----No:FUN-A50103 END-----
#TQC-B30120    --end--

              IF (l_oma55<l_oma54t) OR (l_oma54t=0) THEN
                CALL cl_err('','axm-135',1) #MOD-780163
                LET g_success='N'
                RETURN
              END IF
           END IF #TQC-C20023 add
        END FOREACH   #MOD-850221
      END IF
   END IF  #No.FUN-870007

#Check 倉是否為可用倉
 DECLARE t600sub_ogb09_1 CURSOR FOR
 SELECT ogb09 FROM ogb_file
  WHERE ogb01=l_oga.oga01
 FOREACH t600sub_ogb09_1 INTO l_ogb09
    IF NOT cl_null(l_ogb09) THEN
       LET l_cnt=0
       #-----MOD-B50094---------
       #SELECT count(*) INTO l_cnt FROM imd_file
       # WHERE imd01=l_ogb09
       #   AND imd11='Y'
       #   AND imdacti='Y'
       IF l_oga.oga00 = 'B' THEN
          LET l_sql = "SELECT count(*) FROM imd_file ",
                      " WHERE imd01='",l_ogb09,"'",
                      "   AND imd11='N'",
                      "   AND imdacti='Y'"
       ELSE
          LET l_sql = "SELECT count(*) FROM imd_file ",
                      " WHERE imd01='",l_ogb09,"'",
                      "   AND imd11='Y'",
                      "   AND imdacti='Y'"
       END IF
       PREPARE t600_imd_c2 FROM l_sql
       EXECUTE t600_imd_c2 INTO l_cnt
       #-----END MOD-B50094-----
       IF l_cnt=0 THEN
          #MOD-C30819 ----- add start -----
          IF l_oga.oga00 = 'B' THEN
             CALL cl_err(l_ogb09,'axm_612',0)
          ELSE
          #MOD-C30819 -----  add end  -----
             CALL cl_err(l_ogb09,'axm-993',0)
          END IF #MOD-C30819 add
          LET g_success = 'N'   #FUN-580113
          RETURN
       END IF
       #No.FUN-AA0048  --Begin
       IF NOT s_chk_ware(l_ogb09) THEN
          LET g_success = 'N'   #FUN-580113
          RETURN
       END IF
       #No.FUN-AA0048  --End  
    ELSE
       CONTINUE FOREACH
    END IF
 END FOREACH

 #No.FUN-AA0048  --Begin
 IF NOT s_chk_ware(l_oga.oga66) THEN
    LET g_success = 'N'
    RETURN
 END IF
 IF NOT s_chk_ware(l_oga.oga910) THEN
    LET g_success = 'N'
    RETURN
 END IF
 DECLARE t600sub_ware_cs1 CURSOR FOR
  SELECT ogg09 FROM ogg_file
   WHERE ogg01 = l_oga.oga01
 FOREACH t600sub_ware_cs1 INTO l_ogb09
     IF NOT s_chk_ware(l_ogb09) THEN
        LET g_success = 'N'
        RETURN
     END IF
 END FOREACH
 DECLARE t600sub_ware_cs2 CURSOR FOR
  SELECT ogc09 FROM ogc_file
   WHERE ogc01 = l_oga.oga01
 FOREACH t600sub_ware_cs2 INTO l_ogb09
     IF NOT s_chk_ware(l_ogb09) THEN
        LET g_success = 'N'
        RETURN
     END IF
 END FOREACH
 #No.FUN-AA0048  --End  
 
   DECLARE t600sub_ogbrvbs CURSOR FOR
   SELECT * FROM ogb_file
    WHERE ogb01=l_oga.oga01

   #MOD-C40149 add --start--
   LET l_sql= " SELECT * FROM ogc_file WHERE ogc01='",l_oga.oga01,"' AND ogc03=?" 
   PREPARE t600_chk_pre1 FROM l_sql
   DECLARE t600_chk_cs1 CURSOR FOR t600_chk_pre1 

   LET l_sql= " SELECT * FROM ogg_file WHERE ogg01='",l_oga.oga01,"' AND ogg03=?" 
   PREPARE t600_chk_pre2 FROM l_sql
   DECLARE t600_chk_cs2 CURSOR FOR t600_chk_pre2 
   #MOD-C40149 add --end--
 
   FOREACH t600sub_ogbrvbs INTO l_ogb.*
      #FUN-A40022--begin-----
#FUN-B50096 -------------Begin--------------
   #  IF s_industry('icd') THEN
   #     LET l_imaicd13=''                                                                                                    
   #     SELECT imaicd13 INTO l_imaicd13                                                                                      
   #       FROM imaicd_file                                                                                                   
   #      WHERE imaicd00 = l_ogb.ogb04                                                                                  
   #     IF l_imaicd13 = 'Y' AND cl_null(l_ogb.ogb092) THEN                                                             
     #CHI-C30104 add START
     #非多倉儲時 axmt640 確認時, 檢查 ogb09 倉庫別, 與 axms100 中的 oaz78(借出客戶倉庫), 是否同屬於成本倉, 或是非成本倉.
     #若不同, 則顯示錯誤訊息, 並取消確認的動作
      LET l_n = 0
      LET l_n2 = 0
      IF l_oga.oga09 = 'A' AND NOT cl_null(g_oaz.oaz78) THEN  #借貨出貨單
         SELECT COUNT(*) INTO l_n FROM jce_file WHERE jce02 = g_oaz.oaz78
         IF cl_null(l_n2) THEN LET l_n2 = 0 END IF
         IF l_ogb.ogb17 = 'N' THEN
            SELECT COUNT(*) INTO l_n2 FROM jce_file WHERE jce02 = l_ogb.ogb09
           #出貨倉為非成本倉
            IF l_n > 0 THEN
               IF l_n2 = 0 OR cl_null(l_n2) THEN
                  LET g_success = 'N'
                  RETURN
               END IF
           #出貨倉為成本倉
            ELSE
               IF l_n2 > 0 THEN
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
         END IF
        #多倉儲 axmt640 按確認時, 去檢查 ogc12 > 0 的 ogc09 倉庫別(有多筆資料), 與 axms100 中的 oaz78(借出客戶倉庫), 是否同屬於成本倉, 或是非成本倉.
        #若不同, 則顯示錯誤訊息, 並取消確認的動作.
         IF l_ogb.ogb17 = 'Y' THEN
            FOREACH t600_chk_cs1 USING l_ogb.ogb03 INTO l_ogc.*
               LET l_n2 = 0
               SELECT COUNT(*) INTO l_n2 FROM jce_file WHERE jce02 = l_ogc.ogc09
               IF cl_null(l_n2) THEN LET l_n2 = 0 END IF
               IF l_n = 0 AND l_n2 > 0 THEN   #出貨倉庫為成本倉但借出客戶倉庫為非成本倉
                  LET g_success = 'N'
                  RETURN
               END IF
               IF l_n > 0 AND l_n2 = 0 THEN   #出貨倉庫為非成本倉但借出客戶倉庫為成本倉
                  LET g_success = 'N'
                  RETURN
               END IF
            END FOREACH
         END IF
      END IF
     #CHI-C30104 add END
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = l_ogb.ogb04
      #IF l_ima159 = '1' AND cl_null(l_ogb.ogb092) THEN   #FUN-B40081 mark
      IF l_ima159 = '1' AND cl_null(l_ogb.ogb092) AND l_ogb.ogb17!='Y' 
         AND g_prog[1,7] <> 'axmt610'    #FUN-B40081    #TQC-C50149 g_prog
         AND l_oga.oga09 <>'8' THEN  #MOD-C80250 add
#FUN-B50096 -------------End----------------
            LET g_success = 'N'
            CALL cl_err(l_ogb.ogb04,'aim-034',1)                                                                        
            RETURN
   #     END IF       #FUN-B50096
      END IF
      #FUN-A40022--end--add----------
      LET g_ima918 = ''   #MOD-9C0055
      LET g_ima921 = ''   #MOD-9C0055
      LET g_ima906 = ''   #MOD-C50088 
      SELECT ima918,ima921,ima906,ima930  #MOD-C50088 add ima906  #DEV-D30040 add ima930
        INTO g_ima918,g_ima921,g_ima906,g_ima930 
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
         AND imaacti = "Y"

      IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30040 add
      
     #IF NOT (l_oga.oga09='1' AND g_oaz.oaz81='N') THEN  ##FUN-850120  #出通單要判斷參數            #MOD-B50180
      IF NOT (l_oga.oga09 MATCHES '[15]' AND g_oaz.oaz81='N') THEN  ##FUN-850120  #出通單要判斷參數 #MOD-B50180 mod
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            #MOD-C40149 add --start--
            IF l_ogb.ogb17='Y' THEN   #多倉儲出貨
               IF g_sma.sma115 = 'Y' THEN
                  FOREACH t600_chk_cs2 USING l_ogb.ogb03 INTO l_ogg.*
                     IF STATUS THEN
                        LET g_success = 'N'
                        RETURN
                     END IF
                     IF g_ima906 = '3' AND l_ogg.ogg20 = '2' THEN  #MOD-C50088 add
                     ELSE                                          #MOD-C50088 add
                        SELECT SUM(rvbs06) INTO l_rvbs06
                          FROM rvbs_file
                         WHERE rvbs00 = g_prog
                           AND rvbs01 = l_ogb.ogb01
                           AND rvbs02 = l_ogb.ogb03 
                           AND rvbs13 = l_ogg.ogg18 
                           AND rvbs09 = -1 

                        IF cl_null(l_rvbs06) THEN
                           LET l_rvbs06 = 0
                        END IF
                        
                        CALL s_umfchk(l_ogb.ogb04,l_ogg.ogg10,l_ogb.ogb05) #FUN-C80001
                           RETURNING l_flag,l_ogg.ogg15_fac  #FUN-C80001
                        
                        IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040
                           IF (l_ogg.ogg12 * l_ogg.ogg15_fac) <> l_rvbs06 THEN 
                              LET g_success = "N"
                              RETURN
                           END IF
                        END IF                                                        #DEV-D30040
                     END IF          #MOD-C50088 add
                  END FOREACH 
               ELSE
                  FOREACH t600_chk_cs1 USING l_ogb.ogb03 INTO l_ogc.*
                     IF STATUS THEN
                        LET g_success = 'N'
                        RETURN
                     END IF

                     SELECT SUM(rvbs06) INTO l_rvbs06
                       FROM rvbs_file
                      WHERE rvbs00 = g_prog
                        AND rvbs01 = l_ogb.ogb01
                        AND rvbs02 = l_ogb.ogb03 
                        AND rvbs13 = l_ogc.ogc18 
                        AND rvbs09 = -1 

                     IF cl_null(l_rvbs06) THEN
                        LET l_rvbs06 = 0
                     END IF

                     IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040
                        IF (l_ogc.ogc12 * l_ogc.ogc15_fac) <> l_rvbs06 THEN 
                           LET g_success = "N"
                           RETURN
                        END IF
                     END IF                                                        #DEV-D30040
                  END FOREACH 
               END IF
            ELSE
            #MOD-C40149 add --end--
               SELECT SUM(rvbs06) INTO l_rvbs06
                 FROM rvbs_file
                WHERE rvbs00 = g_prog
                  AND rvbs01 = l_ogb.ogb01
                  AND rvbs02 = l_ogb.ogb03    #FUN-850120
                  AND rvbs09 = -1
         
               IF cl_null(l_rvbs06) THEN
                  LET l_rvbs06 = 0
               END IF
              #CHI-C30064---Start---add
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_ogb.ogb04 AND img02= l_ogb.ogb09
                  AND img03= l_ogb.ogb091 AND img04= l_ogb.ogb092
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogb05_fac
               IF g_cnt = '1' THEN
                  LET  l_ogb05_fac = 1
               END IF                         
              #CHI-C30064---End---add            
              #IF (l_ogb.ogb12 * l_ogb.ogb05_fac) <> l_rvbs06 THEN   #No.FUN-860045
               IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040
                  IF (l_ogb.ogb12 * l_ogb05_fac) <> l_rvbs06 THEN #CHI-C30064
                     LET g_success = "N"
                     RETURN
                  END IF
               END IF                                                        #DEV-D30040
            END IF #MOD-C40149 add
         END IF
      END IF    ##FUN-850120

      #CHI-AC0034 add --start--
      #IF g_prog = "axmt628" OR g_prog= "axmt629" THEN   #FUN-B40066 mark
      IF g_prog[1,7] = "axmt628" OR g_prog[1,7] = "axmt629" THEN    #FUN-B40066   
         IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
            SELECT SUM(ogc12) INTO l_ogc12_t FROM ogc_file
             WHERE ogc01 = l_oga.oga01 AND ogc03 = l_ogb.ogb03
            IF l_ogc12_t != l_ogb.ogb12 THEN
               LET g_success = "N"
               CALL cl_err(l_ogb.ogb12,"axm-185",1)
               RETURN
            END IF
         END IF
      END IF
      #CHI-AC0034 add --end--

   END FOREACH
 
 #若現行年月大於出貨單/銷退單之年月--不允許確認
 IF l_argv0 NOT MATCHES '[15]' THEN    #No.MOD-880260   
 CALL s_yp(l_oga.oga02) RETURNING l_yy,l_mm #No.TQC-7C0070
 IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
     LET g_success = 'N'   #FUN-580113
     RETURN
 END IF
 END IF                                #No.MOD-880260 
 
 IF NOT (l_argv0 = '1' OR l_argv0 = '5')  THEN   #不是出通單 #MOD-B30665 add
    IF g_oaz.oaz03 = 'Y' AND
       g_sma.sma53 IS NOT NULL AND l_oga.oga02 <= g_sma.sma53 THEN
       LET g_success = 'N'   #FUN-580113
       RETURN
    END IF
 END IF #MOD-B30665 add
 #No.7992  多角貿易單據
 IF l_oga.oga909 = 'Y' THEN
    IF l_oga.oga905= 'Y' THEN   #拋轉否
       LET g_success = 'N'   #FUN-580113
       RETURN
    END IF
 
 
    IF l_oga.oga906 <>'Y' THEN     #是否為來源出貨單
       LET g_success = 'N'   #FUN-580113
       RETURN
    END IF
 END IF
 #若採訂單匯率立帳則幣別匯率相同才可併單
 IF NOT t600_app_sub_oea18_chk(0,l_oga.*,NULL,FALSE) THEN
    LET g_success = 'N'   #FUN-580113
    RETURN
 ELSE
    SELECT oga24 INTO l_oga.oga24 FROM oga_file WHERE oga01=g_oga.oga01 #FUN-730012 add oga24的值可能被異動,必須重抓
 END IF
 # 為防立應收不對,加上若單頭有輸入訂單號碼時,
 #                       check 訂單的訂金,出貨比率有沒有一致
  IF NOT cl_null(l_oga.oga16) THEN
     SELECT oea161,oea162,oea163 INTO l_oea161,l_oea162,l_oea163 FROM oea_file
      WHERE oea01=l_oga.oga16
     IF cl_null(l_oea161) THEN LET l_oea161=0   END IF
     IF cl_null(l_oea162) THEN LET l_oea162=100 END IF #MODNO:5230
     IF cl_null(l_oea163) THEN LET l_oea163=0   END IF
     IF l_oea161 != l_oga.oga161 OR l_oea162 !=l_oga.oga162 OR
        l_oea163 != l_oga.oga163 THEN
        LET g_success = 'N'   #FUN-580113
        RETURN
     END IF
  END IF
 
  IF g_sma.sma115= 'Y' THEN   #TQC-620100
     LET l_x1 = "Y"
     LET l_x2 = "Y"
     LET l_sql="SELECT ogb910,ogb912 FROM ogb_file ",     #No.FUN-610064
               " WHERE ogb01='",l_oga.oga01,"'",
               "   AND ogb1005='1' "
     PREPARE pre_ogb3 FROM l_sql
     DECLARE ogb_curs3 CURSOR FOR pre_ogb3
     FOREACH ogb_curs3 INTO l_ogb910,l_ogb912
        IF cl_null(l_ogb910) THEN LET l_x1 = "N" END IF
        IF cl_null(l_ogb912) THEN LET l_x2 = "N" END IF
     END FOREACH
     IF l_x1 = "N" THEN
        #出貨單位欄位不可空白
        CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1
        CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2
        LET l_msg = l_msg1 CLIPPED,l_msg2
     END IF
     IF l_x2 = "N" THEN
        #出貨數量欄位不可空白
        CALL cl_getmsg('asm-307',g_lang) RETURNING l_msg1
        CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2
        LET l_msg = l_msg CLIPPED,l_msg1 CLIPPED,l_msg2
     END IF
     IF NOT cl_null(l_msg) THEN
        LET g_success = 'N'
        RETURN
     END IF
  END IF
 
  #CHI-C10016 add -- start --
  IF g_prog[1,7] = "axmt620" THEN
     SELECT oga50,oga07 INTO l_oga50,l_oga07 FROM oga_file WHERE oga01 = p_oga01
     IF l_oga07 = 'Y' THEN
        SELECT SUM(ABS(npq07f)) INTO l_npq07f FROM npq_file
         WHERE npq01 = p_oga01
           AND npqsys= 'AR' AND npq011 = 1
           AND npqtype= '0'   
           AND npq00 = '1'
           AND (npq06 = '2' AND npq07f > 0 OR npq06 = '1' AND npq07f < 0 )
        IF cl_null(l_npq07f) THEN LET l_npq07f=0 END IF   
               
        IF l_npq07f !=(l_oga50) THEN
           LET g_success = 'N'
        END IF
     END IF
  END IF
  #CHI-C10016 add -- end --
 
  #以下的程式由upd()段移過來
      #IF g_prog <> 'atmt248' AND g_prog <> 'axmt628' THEN  #No.MOD-670123  #No.TQC-6C0085 add axmt628 #FUN-B40066 mark
      IF g_prog <> 'atmt248' AND g_prog[1,7] <> 'axmt628' THEN   #FUN-B40066
         DECLARE l_ogb_conf CURSOR FOR                #No.FUN-670008
         #SELECT ogb31,ogb32,ogb1010,ogb14,ogb14t     #No.FUN-670008
          SELECT ogb31,ogb32,ogb1010,ogb14,ogb14t,ogb1005 #TQC-B10066
            FROM ogb_file
           WHERE ogb01=l_oga.oga01
             AND ogb1005='2'
 
          FOREACH l_ogb_conf INTO l_ogb31,l_ogb32,l_ogb1010,l_ogb14,l_ogb14t,l_ogb1005  #No.FUN-670008 #TQC-B10066
             IF l_ogb1010 ='Y' THEN
                SELECT oeb14t INTO l_tqw08 FROM oeb_file
                 WHERE oeb01 =l_ogb31
                   AND oeb03 =l_ogb32
                SELECT SUM(ogb14t) INTO l_tqw081 FROM ogb_file,oga_file
                 WHERE ogb31 = l_ogb31
                   AND ogb32 = l_ogb32
                   AND oga01 = ogb01
                   AND ogapost = 'Y'
                   AND ogaconf !='X' #CHI-6B0036
                SELECT SUM(ohb14t) INTO l_retn_amt FROM ohb_file,oha_file
                 WHERE ohb33 =l_ogb31
                   AND ohb34 =l_ogb32
                   AND oha01 =ohb01
                   AND ohapost ='Y'
             ELSE
                SELECT oeb14 INTO l_tqw08 FROM oeb_file
                 WHERE oeb01 =l_ogb31
                   AND oeb03 =l_ogb32
                SELECT SUM(ogb14) INTO l_tqw081 FROM ogb_file,oga_file
                 WHERE ogb31 = l_ogb31
                   AND ogb32 = l_ogb32
                   AND oga01 = ogb01
                   AND ogapost = 'Y'
                   AND ogaconf !='X'  #CHI-6B0036
                SELECT SUM(ohb14) INTO l_retn_amt FROM ohb_file,oha_file
                 WHERE ohb33 =l_ogb31
                   AND ohb34 =l_ogb32
                   AND oha01 =ohb01
                   AND ohapost ='Y'
             END IF
             IF cl_null(l_tqw081) THEN
                LET l_tqw081 =0
             END IF
             IF cl_null(l_retn_amt) THEN
                LET l_retn_amt =0
             END IF
             LET l_tqw081 =l_tqw081-l_retn_amt
 
             LET l_max =l_tqw08 -l_tqw081
 
             IF l_ogb1010 ='Y' THEN
                IF l_max >= 0 THEN
                  #IF l_ogb14t >l_max OR l_ogb14t <= 0 THEN                       #TQC-B10066
                   IF l_ogb14t >l_max OR (l_ogb1005 = '1' AND l_ogb14t <= 0) THEN #TQC-B10066
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                      CALL cl_err(l_msg,'atm-526',1)  #No.FUn-670008
                      LET g_success='N'
                      
                      RETURN
                   END IF
                ELSE
                  #IF l_ogb14t <l_max OR l_ogb14t <= 0 THEN                       #TQC-B10066
                   IF l_ogb14t <l_max OR (l_ogb1005 = '1' AND l_ogb14t <= 0) THEN #TQC-B10066
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                      CALL cl_err(l_msg,'atm-527',1)  #No.FUN-670008
                      LET g_success='N'
                      
                      RETURN
                   END IF
                END IF
             ELSE
                IF l_max >= 0 THEN
                  #IF l_ogb14 >l_max OR l_ogb14 <= 0 THEN                       #TQC-B10066
                   IF l_ogb14 >l_max OR (l_ogb1005 = '1' AND l_ogb14 <= 0) THEN #TQC-B10066
                      LET l_msg =l_ogb32,l_ogb14     #No.FUN-670008
                      CALL cl_err(l_msg,'atm-526',1) #No.FUN-670008
                      LET g_success='N'
                      RETURN
                   END IF
                ELSE
                  #IF l_ogb14 <l_max OR l_ogb14 <= 0 THEN                       #TQC-B10066
                   IF l_ogb14 <l_max OR (l_ogb1005 = '1' AND l_ogb14 <= 0) THEN #TQC-B10066
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                      CALL cl_err(l_msg,'atm-527',1)  #No.FUN-670008
                      LET g_success='N'
                      RETURN
                   END IF
                END IF
             END IF
          END FOREACH
      END IF   #No.MOD-670123

END FUNCTION

#{
#函數作用:執行"確認"的資料更新
#函數參數:p_oga01-出貨單頭的單號
#         p_action_choice-執行"確認"的按鈕的名稱,若外部呼叫可傳NULL
#回傳值:無
#注意  :需用g_success='Y'來判斷此函數是否成功執行,g_success='N'來判斷執行失敗
#       做完確認,需重新讀取oga_file,本FUN不重新讀取
#}
FUNCTION t600_app_sub_y_upd(p_oga01,p_action_choice)
   DEFINE p_oga01       LIKE oga_file.oga01
   DEFINE p_action_choice STRING
   DEFINE l_oea904      LIKE oea_file.oea904   #NO.FUN-670007
   DEFINE l_poz00       LIKE poz_file.poz00    #NO.FUN-6700007
   DEFINE l_chr         LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)  #NO.FUN-670007
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_argv0       LIKE ogb_file.ogb09
   DEFINE l_msg         LIKE type_file.chr1000
   DEFINE l_poz     RECORD LIKE poz_file.*
   DEFINE l_ogamksg     LIKE oga_file.ogamksg
   DEFINE l_oga55       LIKE oga_file.oga55
   DEFINE l_no1         LIKE ina_file.ina01
   DEFINE l_no2         LIKE ina_file.ina01
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_ina01_out   LIKE ina_file.ina01     #雜發單號
   DEFINE l_ogb31       LIKE ogb_file.ogb31     #MOD-870278 add
   DEFINE l_t1          LIKE oay_file.oayslip   #FUN-970017 add
   DEFINE l_change_bgjob LIKE type_file.chr1    #FUN-970017 add 

   WHENEVER ERROR CONTINUE                      #忽略一切錯誤  #FUN-730012
   LET l_change_bgjob = 'N'
   LET g_success = 'Y'
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01
   LET l_argv0=l_oga.oga09  #FUN-730012
 #出貨單確認時再UPDATE oga011=本張出貨單號
  IF l_argv0 MATCHES '[246]' AND NOT cl_null(l_oga.oga011) THEN
     UPDATE oga_file SET oga011 = l_oga.oga01
      WHERE oga01 = l_oga.oga011
        AND oga09 IN ('1','5')
     IF STATUS OR SQLCA.SQLCODE THEN
        CALL cl_err('upd oga011:',SQLCA.SQLCODE,1)   #No.FUN-670092
        CALL cl_err3("upd","oga_file",l_oga.oga011,"",SQLCA.SQLCODE,"","upd oga011",1)  #No.FUN-670092
        LET g_success='N'
     END IF
  END IF
 
  IF g_success = 'Y' THEN
     CALL t600_app_sub_y1(l_oga.*)
     CALL t600_app_sub_y2(l_oga.*)   #FUN-C10040 add
  END IF
 
     LET l_oga.ogaconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
     LET l_oga.oga55='1'             #執行成功, 狀態值顯示為 '1' 已核准
     UPDATE oga_file SET oga55 = l_oga.oga55 WHERE oga01=l_oga.oga01
     IF SQLCA.sqlerrd[3]=0 THEN
        LET g_success='N'
     END IF
     #MOD-B70197 add --start--
#    IF g_oaz.oaz96='Y' THEN LET g_act ='C' END IF    #FUN-C50136
 
     #MOD-C80069 add start -----
     IF g_success='Y' THEN
        UPDATE oga_file SET oga902 = ' ' WHERE oga01=l_oga.oga01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           LET g_success = 'N'
              #TQC-D30038 add
        END IF
     ELSE
        UPDATE oga_file SET oga902 =g_oaz.oaz11 WHERE oga01=l_oga.oga01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            LET g_success = 'N'
        END IF
     END IF

     IF g_success = 'N' THEN
        RETURN
     END IF
     #MOD-C80069 add end   -----

     CALL t600_app_sub_chstatus('Y',l_oga.*) RETURNING l_oga.*
 
  IF l_argv0 MATCHES '[246]' AND NOT cl_null(l_oga.oga011) THEN
     LET l_oga.oga011= l_oga.oga01  #FUN-730012 add
  END IF
 
#確認成功後，來源如為三角出通單，即自動拋轉出通單
  IF l_argv0 = '5' THEN
      #讀取三角貿易流程代碼資料
      IF NOT cl_null(l_oga.oga16) THEN  #MOD-870278 add
        SELECT oea904 INTO l_oea904
          FROM oea_file
         WHERE oea01 = l_oga.oga16
       ELSE 
        DECLARE t600_g_ogb1 CURSOR FOR SELECT ogb31 FROM ogb_file
                                  WHERE ogb01 = g_oga.oga01
 
        FOREACH t600_g_ogb1 INTO  l_ogb31
           SELECT oea904 INTO l_oea904 
             FROM oea_file
            WHERE oea01 = l_ogb31
             EXIT FOREACH
        END FOREACH
      END IF
        IF NOT cl_null(l_oea904) THEN
            SELECT * INTO l_poz.* FROM poz_file WHERE poz01 = l_oea904
            IF STATUS THEN
                CALL cl_err('','axm-318',1) RETURN
            END IF
            SELECT poz00 INTO l_poz00   #先得到流程為銷售或代採參數
              FROM poz_file
             WHERE poz01=l_oea904
            IF l_poz00 = '1' THEN
                LET l_chr = '4'   #銷售
            ELSE
                LET l_chr = '6'   #代採
            END IF
        END IF
  END IF

 #FUN-970017--add----str---
  IF l_change_bgjob = 'Y' THEN
      LET g_bgjob = 'N'
  END IF
 #FUN-970017--add----end---

END FUNCTION

#變更狀況碼
FUNCTION t600_app_sub_chstatus(l_new,l_oga)
DEFINE l_new  LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE l_oga  RECORD LIKE oga_file.*
    LET l_oga.ogaconf=l_new
    CASE l_new
      WHEN 'N'  #取消確認
        UPDATE oga_file SET oga55='0' WHERE oga01=l_oga.oga01
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           RETURN l_oga.*
        END IF
        LET l_oga.oga55='0'
      WHEN 'Y'  #確認
          UPDATE oga_file SET oga55='1' WHERE oga01=l_oga.oga01
          IF SQLCA.sqlcode THEN
             LET g_success='N'
             RETURN l_oga.*
          END IF
          LET l_oga.oga55='1'
      WHEN 'X'  #作廢
        UPDATE oga_file SET oga55='9' WHERE oga01=l_oga.oga01
        IF SQLCA.sqlcode THEN
           LET g_success='N'
           RETURN l_oga.*
        END IF
        LET l_oga.oga55='9'
    END CASE
    RETURN l_oga.*
END FUNCTION
	
FUNCTION t600_app_sub_y1(l_oga)
   DEFINE l_slip   LIKE oay_file.oayslip
   DEFINE l_oay13  LIKE oay_file.oay13
   DEFINE l_oay14  LIKE oay_file.oay14
   DEFINE l_ogb14t LIKE ogb_file.ogb14t
   DEFINE l_oga    RECORD LIKE oga_file.*
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_oea    RECORD LIKE oea_file.*
 
   LET g_time = TIME    #FUN-A30063 ADD
   UPDATE oga_file SET ogaconf='Y',
                       ogaconu=g_user,
                       ogacond=g_today,
                       ogacont=g_time    #FUN-A30063 ADD
    WHERE oga01=l_oga.oga01
 
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","upd ogaconf",1)  #No.FUN-670008
      LET g_success = 'N'
      RETURN
   END IF
#FUN-BA0069 mark begin ----
#  #No.FUN-A20022 ADD--------UPDATE almq618&almq770 ABOUT the oga95_point----------------------------------
#   IF NOT cl_null(l_oga.oga87) THEN
#     #MOD-B10154 Begin---
#      SELECT SUM(ogb14t) INTO l_ogb14t FROM ogb_file 
#       WHERE ogb01=l_oga.oga01
#         AND ogb1005='1'
#      IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
#     #UPDATE lpj_file SET lpj07=lpj07+1,
#     #                    lpj08=g_today,
#     #                    lpj12=lpj12+l_oga.oga95
#      UPDATE lpj_file SET lpj07=COALESCE(lpj07,0)+1,
#                          lpj08=g_today,
#                          lpj12=COALESCE(lpj12,0)+l_oga.oga95,
#                          lpj14=COALESCE(lpj14,0)+l_oga.oga95,
#                          lpj15=COALESCE(lpj15,0)+l_ogb14t
#     #MOD-B10154 End-----
#       WHERE lpj03=l_oga.oga87
#      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err3("upd","lpj_file",l_oga.oga87,"",SQLCA.sqlcode,"","upd lpj12",1)
#         LET g_success = 'N'
#         RETURN
#      ELSE 
#         MESSAGE 'UPDATE lpj_file OK'
#      END IF
#      
#      INSERT INTO lsm_file VALUES( l_oga.oga87,'7',           #7:Maintain Shipping Order:axmt620
#                                   l_oga.oga01,l_oga.oga95,
#                                   g_today,'',l_oga.ogaplant) #No.FUN-A70118 Add lsm08
#      IF STATUS OR SQLCA.SQLCODE THEN
#         CALL cl_err3("ins","lsm_file","","",SQLCA.sqlcode,"","ins lsm",1)
#         LET g_success = 'N'
#         RETURN
#      ELSE
#         MESSAGE 'UPDATE lsm_file OK'
#      END IF                             
#   END IF
#  #No.FUN-A20022 END--------------------------------------------------------------------------------------
#FUN-BA0069 mark end ------
   LET l_slip=s_get_doc_no(l_oga.oga01)       #No.FUN-550052
   SELECT oay13,oay14 INTO l_oay13,l_oay14 FROM oay_file WHERE oayslip = l_slip
   IF l_oay13 = 'Y' THEN
      SELECT SUM(ogb14t) INTO l_ogb14t FROM ogb_file WHERE ogb01 = l_oga.oga01
      IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
      LET l_ogb14t = l_ogb14t * l_oga.oga24
      IF l_ogb14t > l_oay14 THEN
         CALL cl_err(l_oay14,'axm-700',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   DECLARE t600_y1_c CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=l_oga.oga01
   FOREACH t600_y1_c INTO l_ogb.*
      IF NOT cl_null(l_oga.oga16)
         AND l_ogb.ogb31!=l_oga.oga16 THEN
         CALL cl_err(l_ogb.ogb31,'axm-140',1)
         LET g_success='N'
         RETURN
      ELSE
         SELECT * INTO l_oea.* FROM oea_file
          WHERE oea01=l_ogb.ogb31
         IF l_oea.oea08 != l_oga.oga08 THEN        #國內外不符
             CALL cl_err(l_ogb.ogb31,'axm-125',0)
             LET g_success='N'
         END IF
         IF l_oea.oea03 != l_oga.oga03 THEN        #客戶不符 #No.TQC-640123
             CALL cl_err(l_ogb.ogb31,'axm-138',0)
             LET g_success='N'
          END IF
         IF l_oea.oea23 != l_oga.oga23 THEN        #幣別不符
             CALL cl_err(l_ogb.ogb31,'axm-144',0)
             LET g_success='N'
          END IF
         IF l_oea.oea21 != l_oga.oga21 THEN        #稅別不符
             CALL cl_err(l_ogb.ogb31,'axm-142',0)
             LET g_success='N'
          END IF
          IF g_success='N' THEN RETURN END IF
      END IF
#-----------------------------------------------#
     #CHI-A40029 mark --start--
     # IF l_ogb.ogb04[1,4] != 'MISC' THEN
     #     IF l_oga.oga09 NOT MATCHES  '[159]' THEN #非出貨通知單 #No.7992  #No.FUN-630061
     #        CALL t600_app_sub_chk_img(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN END IF
     #        IF l_ogb.ogb17 = 'N' THEN
     #            CALL t600_app_sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN END IF
     #        END IF
     #     END IF
     # END IF
     #CHI-A40029 mark --end--
      CALL t600_app_sub_chk_oeb(l_ogb.*) IF g_success='N' THEN RETURN END IF
      CALL t600_app_sub_bu1(l_oga.*,l_ogb.*)   #No.TQC-8C0027
      IF g_success='N' THEN RETURN END IF
   END FOREACH
END FUNCTION
#FUN-C10040------add------str-----
FUNCTION t600_app_sub_y2(l_oga)
DEFINE l_sql              STRING
DEFINE l_oga              RECORD LIKE oga_file.*
DEFINE l_ogi04            LIKE ogi_file.ogi04
DEFINE l_ogi05            LIKE ogi_file.ogi05
DEFINE l_ogi06            LIKE ogi_file.ogi06
DEFINE l_ogi07            LIKE ogi_file.ogi07
DEFINE l_ogi08            LIKE ogi_file.ogi08
DEFINE l_ogi08t           LIKE ogi_file.ogi08t
DEFINE l_ogi09            LIKE ogi_file.ogi09
DEFINE l_cnt              LIKE type_file.num5
DEFINE l_rxy05_other      LIKE rxy_file.rxy05
DEFINE l_rxy05_other_a    LIKE rxy_file.rxy05
DEFINE l_rxy05_other_b    LIKE ogh_file.ogh09
DEFINE l_rxy05_1          LIKE rxy_file.rxy05
DEFINE l_rxy05_2          LIKE rxy_file.rxy05
DEFINE l_rxy05_09         LIKE rxy_file.rxy05
DEFINE l_ogi08t_t         LIKE ogi_file.ogi08
DEFINE l_rxy12            LIKE rxy_file.rxy12
DEFINE l_rxy05_04_1       LIKE rxy_file.rxy16
DEFINE l_rxy05_04         LIKE rxy_file.rxy16
DEFINE l_gec04            LIKE gec_file.gec04
DEFINE l_gec07            LIKE gec_file.gec07
DEFINE l_ogh              RECORD LIKE ogh_file.*
DEFINE l_ogh07t           LIKE ogh_file.ogh07t    #FUN-C50047 add

   IF g_azw.azw04 = '2' THEN
      SELECT rxy05 INTO l_rxy05_09    #积分抵现金额
        FROM rxy_file 
       WHERE rxy00 = '02'
         AND rxy01 = l_oga.oga01
         AND rxy03 = '09'
      IF cl_null(l_rxy05_09) THEN
         LET l_rxy05_09 = 0
      END IF
      LET l_sql = "     SELECT rxy12,(lrz02 * rxy16),gec04,gec07 FROM rxy_file",#已開發票的禮券付款
                  " INNER JOIN lrz_file",
                  "         ON lrz01 = rxy13", 
                  "        AND lrz03 = 'Y'",
                  " INNER JOIN lpx_file",
                  "         ON lpx01 = rxy12",
                  #"        AND lpx26 = '1'",    #FUN-D10040 mark
                  "        AND lpx38 = 'Y'",     #FUN-D10040 add
                  " INNER JOIN gec_file",
                  "         ON gec01 = lpx33",
                  "        AND gec011 = '2'",
                  "      WHERE rxy00 = '02'",
                  "        AND rxy01 = '",l_oga.oga01,"'",
                  "        AND rxy03 = '04'"
      PREPARE t620_sel_rxy FROM l_sql
      DECLARE t620_sel_rxy_cs CURSOR FOR t620_sel_rxy
      FOREACH t620_sel_rxy_cs INTO l_rxy12,l_rxy05_04_1,l_gec04,l_gec07
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         IF cl_null(l_rxy05_04_1) THEN
            LET l_rxy05_04_1 = 0
         END IF
         LET l_rxy05_04 = l_rxy05_04 + l_rxy05_04_1
      END FOREACH
      SELECT SUM(rxy05) INTO l_rxy05_1     #其余付款金额
        FROM rxy_file
       WHERE rxy00 = '02'
         AND rxy01 = l_oga.oga01
         AND rxy03 NOT IN ('04','09')
          SELECT SUM(lrz02 * rxy16) INTO l_rxy05_2
            FROM rxy_file
      INNER JOIN lrz_file
              ON lrz01 = rxy13
             AND lrz03 = 'Y'
      INNER JOIN lpx_file
              ON lpx01 = rxy12
             #AND lpx26 = '2'  #FUN-D10040 mark
             AND lpx38 = 'N'   #FUN-D10040 add
           WHERE rxy00 = '02'
             AND rxy01 = l_oga.oga01
             AND rxy03 = '04'
      IF cl_null(l_rxy05_1) THEN 
         LET l_rxy05_1 = 0
      END IF
      IF cl_null(l_rxy05_2) THEN
         LET l_rxy05_2 = 0
      END IF
      LET l_rxy05_other = l_rxy05_1 + l_rxy05_2
      IF cl_null(l_rxy05_other) THEN
         LET l_rxy05_other = 0
      END IF 
      SELECT COUNT(*) INTO l_cnt
        FROM ogh_file
       WHERE ogh01 = l_oga.oga01
      IF l_cnt > 0 THEN
         DELETE FROM ogh_file WHERE ogh01 = l_oga.oga01
      END IF
      LET l_ogh.ogh01 = l_oga.oga01
      LET l_ogh.ogh09 = ' '
      LET l_ogh.oghdate = g_today
      LET l_ogh.oghgrup = g_grup
      LET l_ogh.oghlegal = g_legal
      LET l_ogh.oghmodu = ' '
      LET l_ogh.oghorig = g_grup
      LET l_ogh.oghplant = g_plant
      LET l_ogh.oghuser = g_user
      LET l_sql = " SELECT ogi04,ogi05,ogi06,ogi07,SUM(ogi08),SUM(ogi08t),SUM(ogi09)",
                  "   FROM ogi_file",
                  "  WHERE ogi01 = '",l_oga.oga01,"'",
                  "    AND ogiplant = '",l_oga.ogaplant,"'",
                  "  GROUP BY ogi04,ogi05,ogi06,ogi07",
                  "  ORDER BY ogi05 asc,ogi06 desc"   
      PREPARE t620_sel_ogi FROM l_sql 
      DECLARE t620_sel_ogi_cs CURSOR FOR t620_sel_ogi
      FOREACH t620_sel_ogi_cs INTO l_ogi04,l_ogi05,l_ogi06,l_ogi07,l_ogi08,l_ogi08t,l_ogi09
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         #固定税额大于零则直接写入到实际交易税别明细档 
         IF l_ogi06 >0 THEN
            SELECT MAX(ogh02) + 1 INTO l_ogh.ogh02
              FROM ogh_file
             WHERE ogh01 = l_oga.oga01
            IF cl_null(l_ogh.ogh02) THEN
               LET l_ogh.ogh02 = 1
            END IF 
            LET l_ogh.ogh03 = l_ogi04
            LET l_ogh.ogh04 = l_ogi05
            LET l_ogh.ogh05 = l_ogi06
            LET l_ogh.ogh06 = l_ogi07
            LET l_ogh.ogh07 = 0
            LET l_ogh.ogh07t= 0 
            LET l_ogh.ogh08 = l_ogi09
           #TQC-C30085 add START
            IF cl_null(l_ogh.ogh09) THEN
               LET l_ogh.ogh09 = 0 
            END IF
           #TQC-C30085 add END
            INSERT INTO ogh_file VALUES(l_ogh.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","ogh_file",l_oga.oga01,"",SQLCA.SQLCODE,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
         #用其他款别付款(现金）
         IF l_rxy05_other > 0 THEN
            IF l_ogi06 > 0 THEN   #先扣除固定税额大于零的税额
               IF l_rxy05_other < l_ogi09 THEN
                  LET l_rxy05_other_a = 0          
               ELSE
                  LET l_rxy05_other_a = l_rxy05_other - l_ogi09     #剩余金额
               END IF
            END IF
         END IF
         IF l_rxy05_other > 0 AND cl_null(l_rxy05_other_a) THEN
            LET l_rxy05_other_a = l_rxy05_other                  #固定税额都为0
         END IF
         IF l_rxy05_other = 0 AND cl_null(l_rxy05_other_a) THEN
            LET l_rxy05_other_a = 0
         END IF
        #FUN-C50047 add START
         IF l_rxy05_other_a = 0 THEN
            LET l_ogh07t = 0 
         ELSE
            LET l_ogh07t = l_ogi08t
         END IF
        #FUN-C50047 add END
         IF l_rxy05_other_a > 0 THEN
            IF l_ogi05 = 0  AND l_ogi06 = 0 THEN                    #扣除税率为零，固定税额为零的金额
               IF l_rxy05_other_a < l_ogi08t THEN
                  LET l_rxy05_other_a = 0
                  LET l_ogh07t = l_rxy05_other_a                    #FUN-C50047 add   
               ELSE
                  LET l_rxy05_other_a = l_rxy05_other_a - l_ogi08t  #剩余金额
                  LET l_ogh07t = l_ogi08t                           #FUN-C50047 add  
                  LET l_rxy05_other_b = 0
               END IF
            END IF
            IF l_ogi05 > 0 THEN
              #FUN-C50047 add START
               IF l_ogi08t <  l_rxy05_other_a THEN       
                  LET l_rxy05_other_a = l_rxy05_other_a - l_ogi08t 
                  LET l_ogh07t = l_ogi08t 
               ELSE 
                  LET l_ogi08t = l_ogi08t - l_rxy05_other_a 
                  LET l_ogh07t = l_rxy05_other_a   
                  LET l_rxy05_other_a = 0
               END IF
              #FUN-C50047 add END
              #LET l_ogi08t = l_rxy05_other_a            #FUN-C50047 mark
               LET l_ogi08 = l_rxy05_other_a/(1+l_ogi05/100)
               CALL cl_digcut(l_ogi08,t_azi04) RETURNING l_ogi08
               LET l_ogi09 = l_rxy05_other_a - l_rxy05_other_a/(1+l_ogi05/100)
               CALL cl_digcut(l_ogi09,t_azi04) RETURNING l_ogi09
            END IF
         END IF
         IF l_rxy05_other_a = 0 THEN                               #计算留抵金额
            IF l_rxy05_09 > 0 THEN
               IF l_ogi08t > l_rxy05_09 THEN
                  LET l_rxy05_other_b =  l_ogi08t - l_rxy05_09 
               ELSE
                  LET l_rxy05_other_b = 0
               END IF
            END IF
            IF l_rxy05_04 > 0 THEN
               IF l_rxy05_other_b > l_rxy05_04 THEN
                  LET l_rxy05_other_b = l_rxy05_04
                  LET l_ogh.ogh09 = l_rxy05_other_b - l_rxy05_other_b/(1+l_ogi05/100)
                  CALL cl_digcut(l_ogh.ogh09,t_azi04) RETURNING l_ogh.ogh09
               ELSE
                  LET l_rxy05_other_b = l_rxy05_04 - l_rxy05_other_b  
                  LET l_ogh.ogh09 = l_rxy05_other_b - l_rxy05_other_b/(1+l_ogi05/100)
                  CALL cl_digcut(l_ogh.ogh09,t_azi04) RETURNING l_ogh.ogh09
               END IF
            END IF
         END IF
         IF l_rxy05_09 = 0 AND l_rxy05_other = 0 AND l_rxy05_04 <> 0 THEN
            LET l_rxy05_other_b = l_rxy05_04 - l_ogi08t
            LET l_ogh.ogh09 = l_rxy05_other_b - l_rxy05_other_b/(1+l_ogi05/100)
            CALL cl_digcut(l_ogh.ogh09,t_azi04) RETURNING l_ogh.ogh09
         END IF
        #FUN-C50047 add START
         IF l_ogi06 = 0 THEN 
            SELECT MAX(ogh02) + 1 INTO l_ogh.ogh02
              FROM ogh_file
             WHERE ogh01 = l_oga.oga01
            IF cl_null(l_ogh.ogh02) THEN
               LET l_ogh.ogh02 = 1
            END IF
            LET l_ogh.ogh03 = l_ogi04
            LET l_ogh.ogh04 = l_ogi05
            LET l_ogh.ogh05 = l_ogi06
            LET l_ogh.ogh06 = l_ogi07
            LET l_ogh.ogh07 = l_ogh07t / (1+ l_ogh.ogh04/100)  
            CALL cl_digcut(l_ogh.ogh07,t_azi04) RETURNING l_ogh.ogh07
            LET l_ogh.ogh07t= l_ogh07t  
            LET l_ogh.ogh08 = l_ogh.ogh07t - l_ogh.ogh07 
            IF cl_null(l_ogh.ogh09) THEN
               LET l_ogh.ogh09 = 0
            END IF
            INSERT INTO ogh_file VALUES(l_ogh.*)
            IF SQLCA.SQLCODE THEN
               CALL cl_err3("ins","ogh_file",l_oga.oga01,"",SQLCA.SQLCODE,"","",1)
               LET g_success = 'N'
               RETURN
            END IF         
         END IF
        #FUN-C50047 add END 
      END FOREACH
     #FUN-C50047 mark START
     #IF l_rxy05_other_a > 0 THEN   #有剩余金额的则写入到实际交易税别明细档
     #   SELECT MAX(ogh02) + 1 INTO l_ogh.ogh02
     #     FROM ogh_file
     #    WHERE ogh01 = l_oga.oga01
     #   IF cl_null(l_ogh.ogh02) THEN
     #      LET l_ogh.ogh02 = 1
     #   END IF
     #   LET l_ogh.ogh03 = l_ogi04
     #   LET l_ogh.ogh04 = l_ogi05
     #   LET l_ogh.ogh05 = l_ogi06
     #   LET l_ogh.ogh06 = l_ogi07
     #   LET l_ogh.ogh07 = l_ogi08
     #   LET l_ogh.ogh07t= l_ogi08t
     #   LET l_ogh.ogh08 = l_ogi09
     #  #TQC-C30085 add START
     #   IF cl_null(l_ogh.ogh09) THEN
     #      LET l_ogh.ogh09 = 0
     #   END IF
     #  #TQC-C30085 add END
     #   INSERT INTO ogh_file VALUES(l_ogh.*)
     #   IF SQLCA.SQLCODE THEN
     #      CALL cl_err3("ins","ogh_file",l_oga.oga01,"",SQLCA.SQLCODE,"","",1)
     #      LET g_success = 'N'
     #      RETURN
     #   END IF
     #END IF
     #IF l_rxy05_other_b > 0 OR (l_rxy05_09 <> 0 AND l_rxy05_other = 0 AND l_rxy05_04 = 0) THEN   #没有剩余金额的则计算留抵金额
     #   SELECT MAX(ogh02) + 1 INTO l_ogh.ogh02
     #     FROM ogh_file
     #    WHERE ogh01 = l_oga.oga01
     #   IF cl_null(l_ogh.ogh02) THEN
     #      LET l_ogh.ogh02 = 1
     #   END IF
     #   LET l_ogh.ogh03 = l_ogi04
     #   LET l_ogh.ogh04 = l_ogi05
     #   LET l_ogh.ogh05 = l_ogi06
     #   LET l_ogh.ogh06 = l_ogi07
     #   LET l_ogh.ogh07 = 0
     #   LET l_ogh.ogh07t= 0
     #   LET l_ogh.ogh08 = 0
     #  #TQC-C30085 add START
     #   IF cl_null(l_ogh.ogh09) THEN
     #      LET l_ogh.ogh09 = 0
     #   END IF
     #  #TQC-C30085 add END
     #   INSERT INTO ogh_file VALUES(l_ogh.*)
     #   IF SQLCA.SQLCODE THEN
     #      CALL cl_err3("ins","ogh_file",l_oga.oga01,"",SQLCA.SQLCODE,"","",1)
     #      LET g_success = 'N'
     #      RETURN
     #   END IF
     #END IF
     #FUN-C50047 mark END
   END IF
END FUNCTION
#FUN-C10040------add------end-----
	
FUNCTION t600_app_sub_s(p_cmd,p_inTransaction,p_oga01,p_Input_oga02)            # when l_oga.ogapost='N' (Turn to 'Y')
DEFINE p_cmd     LIKE type_file.chr1,         #1.不詢問 2.要詢問  #No.FUN-680137 VARCHAR(1)
       p_inTransaction LIKE type_file.num5,   #FUN-730012 #是否要做 begin work 的指標
       p_oga01 LIKE oga_file.oga01,
       p_Input_oga02 LIKE type_file.num5,
       l_success,l_succ LIKE type_file.chr1,         #TQC-680018 add #存放g_success值
       l_occ57   LIKE occ_file.occ57
DEFINE l_sql     STRING  #NO.TQC-630166
DEFINE l_ogb19   LIKE ogb_file.ogb19,
       l_ogb11   LIKE ogb_file.ogb11,
       l_ogb12   LIKE ogb_file.ogb12,
       l_qcs01   LIKE qcs_file.qcs01,
       l_qcs02   LIKE qcs_file.qcs02,
       l_qcs091c LIKE qcs_file.qcs091
DEFINE l_ima01   LIKE ima_file.ima01,
       l_ima1012 LIKE ima_file.ima1012,
       l_ogb04   LIKE ogb_file.ogb04,
       l_ogb14   LIKE ogb_file.ogb14,
       l_ogb14t  LIKE ogb_file.ogb14t,
       l_ogb1004 LIKE ogb_file.ogb1004,
       l_tqz02   LIKE tqz_file.tqz02,
       l_sum007  LIKE tsa_file.tsa07,
       l_sum034  LIKE tsa_file.tsa07,
       l_item    LIKE tqy_file.tqy35,
       l_i       LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_j       LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE l_oga30   LIKE oga_file.oga30
DEFINE l_oay11   LIKE oay_file.oay11     #No:7647 add
DEFINE l_ogb     RECORD LIKE ogb_file.*  #No.FUN-610090
DEFINE l_oea904  LIKE oea_file.oea904    #NO.FUN-670007
DEFINE l_poz00   LIKE poz_file.poz011    #NO.FUN-670007
DEFINE l_oga02   LIKE oga_file.oga02     #FUN-650009 add
DEFINE l_oga910  LIKE oga_file.oga910    #FUN-650101 #FUN-710037
DEFINE l_imd10   LIKE imd_file.imd10     #FUN-650101
DEFINE l_imd11   LIKE imd_file.imd11     #FUN-650101
DEFINE l_imd12   LIKE imd_file.imd12     #FUN-650101
DEFINE l_yy,l_mm LIKE type_file.num5     #FUN-650009 add
DEFINE l_occ1027 LIKE occ_file.occ1017    #No.TQC-640123
DEFINE li_result LIKE type_file.num5     #FUN-730012
DEFINE lj_result LIKE type_file.chr1     #No.FUN-930108 VARCHAR(1)s_incchk()返回值
DEFINE l_argv0   LIKE ogb_file.ogb09
DEFINE l_oga     RECORD LIKE oga_file.*
DEFINE l_t1      LIKE oay_file.oayslip
DEFINE l_poz     RECORD LIKE poz_file.*
DEFINE l_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
DEFINE l_imm01   LIKE imm_file.imm01      #No.FUN-610090
DEFINE l_oea99   LIKE oea_file.oea99
DEFINE m_ogb32   LIKE ogb_file.ogb32      #MOD-830222 add
DEFINE l_oha     RECORD LIKE oha_file.*
DEFINE l_ima906  LIKE ima_file.ima906
DEFINE l_msg     LIKE type_file.chr1000
DEFINE l_flow    LIKE oea_file.oea904
DEFINE l_imm03   LIKE imm_file.imm03,  #No.FUN-740016
       l_ogb31   LIKE ogb_file.ogb31,   #CHI-880006
       l_ogb03   LIKE ogb_file.ogb03    #CHI-880006
DEFINE l_tot   LIKE oeb_file.oeb24
DEFINE l_ocn03   LIKE ocn_file.ocn03
DEFINE l_ocn04   LIKE ocn_file.ocn04
DEFINE l_cnt         LIKE type_file.num5   #MOD-8B0077
DEFINE l_flag        LIKE type_file.chr1   #MOD-940273
DEFINE l_oeb19       LIKE oeb_file.oeb19   #MOD-970237
DEFINE l_oeb905      LIKE oeb_file.oeb905  #MOD-970237
#DEFINE l_flag1  LIKE type_file.chr1        #No.CHI-9C0027 #TQC-D30044 mark
DEFINE l_agree       LIKE type_file.chr1   #FUN-970017 add #自動確認和簽核
DEFINE l_oeb24       LIKE oeb_file.oeb24   #FUN-AC0074
DEFINE l_oeb12       LIKE oeb_file.oeb12   #FUN-AC0074
DEFINE l_oeb01       LIKE oeb_file.oeb01   #FUN-AC0074
DEFINE l_oeb03       LIKE oeb_file.oeb03   #FUN-AC0074
DEFINE l_sie11       LIKE sie_file.sie11   #FUN-AC0074
DEFINE l_oeb25       LIKE oeb_file.oeb25   #TQC-B50052
DEFINE l_oea09       LIKE oea_file.oea09   #TQC-B50052
DEFINE l_oea02  LIKE oea_file.oea02        #MOD-B50047 add
DEFINE l_flag2       LIKE type_file.chr1   #FUN-B70074
DEFINE l_oebslk24    LIKE oebslk_file.oebslk24  #FUN-B90104----add
DEFINE l_ogb04_1     LIKE ogb_file.ogb04   #FUN-BC0071 add
DEFINE l_n           LIKE type_file.num5   #FUN-BC0071 add
DEFINE l_oga09  LIKE oga_file.oga09        #FUN-C40072 add
DEFINE l_ima930      LIKE ima_file.ima930  #DEV-D30026 add 
DEFINE l_ima931      LIKE ima_file.ima931  #DEV-D30026 add
DEFINE l_ogbnotiy    RECORD LIKE ogb_file.*
DEFINE l_notiy_ogb12 LIKE ogb_file.ogb12   
DEFINE l_sum_ogb12   LIKE ogb_file.ogb12



   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012

   SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01
  #FUN-970017---add----str----
   LET l_agree = 'N'
   IF l_oga.oga00 = "A" THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM imm_file
        WHERE imm09 = p_oga01
      IF l_cnt > 0 THEN
         LET g_success = 'N'  #TQC-930155 add
         RETURN
      END IF
   END IF
  #MOD-B30430 mod --start--
  #IF l_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
   IF l_oga.oga01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      IF NOT p_inTransaction THEN  
         
          
      END IF 
      LET g_success = 'N' 
      RETURN
   END IF 
  #MOD-B30430 mod --end--
   LET l_argv0=l_oga.oga09  #FUN-730012
   IF l_argv0 MATCHES '[15]' THEN       #No.7992
     #MOD-B30430 mod --start--
     #CALL cl_err('','axm-226',0) LET g_success = 'N' RETURN #CHI-A50004 add LET g_success = 'N'
      CALL cl_err('','axm-226',0) 
      IF NOT p_inTransaction THEN  
         
          
      END IF 
      LET g_success = 'N' 
      RETURN
     #MOD-B30430 mod --end--
   END IF
  #MOD-B30430 mod --start--
  #IF l_oga.ogaconf='X' THEN CALL cl_err('conf=X',9024,0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
  #IF l_oga.ogaconf='N' THEN CALL cl_err('conf=N','axm-154',0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
  #IF l_oga.ogapost='Y' THEN CALL cl_err('post=Y','mfg0175',0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
   IF l_oga.ogaconf='X' THEN 
      CALL cl_err('conf=X',9024,0) 
      IF NOT p_inTransaction THEN  
         
          
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
   IF l_oga.ogaconf='N' THEN 
      CALL cl_err('conf=N','axm-154',0) 
      IF NOT p_inTransaction THEN  
         
          
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
   IF l_oga.ogapost='Y' THEN 
      CALL cl_err('post=Y','mfg0175',0) 
      IF NOT p_inTransaction THEN  
         
          
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
  #MOD-B30430 mod --end--


#FUN-BC0071 -----------STA
    SELECT COUNT(*) INTO l_n  FROM ogb_file
     WHERE ogb01 = l_oga.oga01
       AND ogb1001 = g_oaz.oaz88
     IF l_n > 0 THEN
       DECLARE l_ogb04_cur1 CURSOR FOR
        SELECT ogb04 FROM ogb_file
         WHERE ogb01= l_oga.oga01
           AND ogb1001 = g_oaz.oaz88
       FOREACH  l_ogb04_cur1 INTO l_ogb04_1
          SELECT COUNT(*) INTO l_n FROM lpx_file,lqe_file,lqw_file
           WHERE lpx32 = l_ogb04_1 AND lpx01 = lqe02     #TQC-C20407
             AND lqw08 = lqe02 AND lqw00 = '02'
              AND lqw01= l_oga.oga01
              AND lqe01 BETWEEN lqw09 AND lqw10
              AND ((lqe17 NOT IN ('5','2') AND lqe13 = l_oga.ogaplant)
                 OR (lqe17 IN ('5','2') AND lqe13  <> l_oga.ogaplant))
           IF l_n > 0 THEN
              CALL s_errmsg("ogb04",l_ogb04_1,"",'alm1567',1)
              LET g_success = "N"
              CONTINUE FOREACH
           END IF
       END FOREACH
       IF g_success = "N" THEN
          IF NOT p_inTransaction THEN
             
             
          END IF
          RETURN
       END IF
     END IF

#FUN-BC0071 -----------END
    
   IF p_Input_oga02 = FALSE THEN  #MOD-D70161 add
      IF g_oaz.oaz03 = 'Y' AND g_sma.sma53 IS NOT NULL AND
         l_oga.oga02 <= g_sma.sma53 THEN
        #MOD-B30430 mod --start--
        #CALL cl_err('','mfg9999',0) LET g_success = 'N' RETURN #CHI-A50004 add LET g_success = 'N'
         CALL cl_err('','mfg9999',0) 
         IF NOT p_inTransaction THEN  
            
             
         END IF 
         LET g_success = 'N' 
         RETURN 
        #MOD-B30430 mod --end--
      END IF
   END IF  #MOD-D70161 add
   DECLARE ogb_s_c CURSOR FOR
      SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
   CALL s_showmsg_init()
 
   FOREACH ogb_s_c INTO l_ogb.*

      IF cl_null(l_oga.oga99) THEN
         CALL s_incchk(l_ogb.ogb09,l_ogb.ogb091,g_user)
               RETURNING lj_result
         IF NOT lj_result THEN
            LET g_success = 'N'
            LET g_showmsg = l_ogb.ogb03,"/",l_ogb.ogb09,"/",l_ogb.ogb091,"/",g_user
            CALL s_errmsg('ogb03,ogb09,ogb091,inc03',g_showmsg,'','asf-888',1)
         END IF
       END IF
      #DEV-D30026---add---str---
      IF g_aza.aza131 = 'Y' THEN
          SELECT ima930,ima931 INTO l_ima930,l_ima931
            FROM ima_file
           WHERE ima01 = l_ogb.ogb04
          IF l_ima930 = 'Y' AND l_ima931 = 'Y' THEN
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt
                FROM box_file
               WHERE box01 IN (SELECT ogb01 FROM oga_file,ogb_file
                                WHERE ogb31 = l_ogb.ogb31
                                  AND ogb32 = l_ogb.ogb32
                                  AND oga01 = ogb01
                                  AND oga09 = '1')
                 AND box02 IN (SELECT ogb03 FROM oga_file,ogb_file
                                WHERE ogb31 = l_ogb.ogb31
                                  AND ogb32 = l_ogb.ogb32
                                  AND oga01 = ogb01
                                  AND oga09 = '1')
              IF l_cnt = 0 THEN
                  LET g_success = 'N'
                  LET g_showmsg = l_ogb.ogb03,"/",l_ogb.ogb31,"/",l_ogb.ogb32,"/",l_ogb.ogb04
                  #單身料件有使用條碼(ima930)='Y'且包號管理(ima931)='Y'時,需有做配貨單才能"庫存扣帳"!
                  CALL s_errmsg('ogb03,ogb31,ogb32,ogb04',g_showmsg,'','aba-129',1)
              END IF
          END IF
      END IF
      #DEV-D30026---add---end---
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      #MOD-B30430 add --start--
      IF NOT p_inTransaction THEN  
         
          
      END IF 
      #MOD-B30430 add --end--
      RETURN
   END IF

   SELECT occ57 INTO l_occ57 FROM occ_file WHERE occ01 =l_oga.oga03   #No.TQC-640123
   IF SQLCA.sqlcode THEN LET l_occ57 = 'N' END IF
 
    IF l_argv0='4' OR l_argv0='6' THEN
       IF g_oax.oax04='Y' THEN   #NO.FUN-670007
          IF cl_null(l_oga.oga27) THEN  
             CALL cl_err('','axm-997',0)
             #MOD-B30430 add --start--
             IF NOT p_inTransaction THEN  
                
                 
             END IF 
             #MOD-B30430 add --end--
             LET g_success = 'N'   #FUN-580113
             RETURN
          ELSE
             SELECT * FROM ofa_file WHERE ofa01=l_oga.oga27 AND ofaconf='Y'    
             IF STATUS=100 THEN
                LET g_success = 'N'   #FUN-580113
                RETURN
             END IF
          END IF
       END IF
    END IF
   
   IF l_occ57 = 'Y' AND l_oga.oga30 = 'N' AND l_oga.oga09 <> '8' AND l_oga.oga09 <> 'A' THEN   #MOD-9B0149   #MOD-A60150 add oga09 <> 'A'
      #若為出貨通知單製包裝單,則再check一次,避免先轉出貨單再製包裝單無法確認
      IF g_oaz.oaz67 = '1' AND NOT cl_null(l_oga.oga011)  THEN
         LET l_oga30='N'
         SELECT oga30 INTO l_oga30
           FROM oga_file
          WHERE oga01=l_oga.oga011 AND oga09 IN ('1','5')
         IF SQLCA.SQLCODE THEN
            LET l_oga30='N'
         END IF
         IF l_oga30='N' THEN
            LET g_success = 'N' 
            RETURN 
           #MOD-B30430 mod --end--
         END IF
      ELSE
         LET g_success = 'N' 
         RETURN 
        #MOD-B30430 mod --end--
      END IF
   END IF
 
   IF NOT cl_null(l_oga.oga910) THEN #FUN-710037
      SELECT imd10,imd11,imd12 INTO l_imd10,l_imd11,l_imd12
        FROM imd_file WHERE imd01=l_oga.oga910 #FUN-710037
      IF NOT (l_imd11 MATCHES '[Yy]') THEN
         LET g_success = 'N' #CHI-A50004 add
         RETURN
      END IF
      CASE
         WHEN l_oga.oga00 MATCHES '[37]' #3.出至境外倉;7.寄銷訂單
#           IF NOT (l_imd10 MATCHES '[Ss]') THEN     #MOD-B80197 mark
            IF NOT (l_imd10 MATCHES '[Ww]') THEN     #MOD-B80197
               LET g_success = 'N' #CHI-A50004 add
               RETURN
            END IF
         OTHERWISE
 
      END CASE
      #No.FUN-AA0048  --Begin
      IF NOT s_chk_ware(l_oga.oga910) THEN
         LET g_success = 'N'
         RETURN
      END IF
      #No.FUN-AA0048  --End  
   END IF
 
   #LET l_sql = " SELECT ogb12,ogb19,ogb11,ogb01,ogb03 FROM ogb_file ",   #CHI-880006
   LET l_sql = " SELECT ogb12,ogb19,ogb11,ogb01,ogb03,ogb31,ogb32 FROM ogb_file ",   #CHI-880006
               "  WHERE ogb01 = '",l_oga.oga01,"'"
   PREPARE t600_pre1 FROM l_sql
   DECLARE t600_curs1 CURSOR FOR t600_pre1
   #FOREACH t600_curs1 INTO l_ogb12,l_ogb19,l_ogb11,l_qcs01,l_qcs02   #CHI-880006
   FOREACH t600_curs1 INTO l_ogb12,l_ogb19,l_ogb11,l_qcs01,l_qcs02,l_ogb31,m_ogb32   #CHI-880006
      IF g_prog <> 'atmt232' THEN #TQC-640151(1)
         IF l_ogb19 = 'Y' THEN
            LET l_qcs091c = 0
            #-----CHI-880006---------
            IF NOT cl_null(l_oga.oga011) THEN
               #-----MOD-A90084---------
               #SELECT ogb03 INTO l_ogb03
               #  FROM ogb_file
               # WHERE ogb01=l_oga.oga011
               #   AND ogb31=l_ogb31
               #   AND ogb32=m_ogb32
               #SELECT SUM(qcs091) INTO l_qcs091c
               #  FROM qcs_file
               # WHERE qcs01 = l_oga.oga011
               #   AND qcs02 = l_ogb03
               #   AND qcs14 = 'Y'
               SELECT SUM(qcs091) INTO l_qcs091c
                 FROM qcs_file
                WHERE qcs01 = l_oga.oga011
                  AND qcs02 = l_qcs02 
                  AND qcs14 = 'Y'
               #-----END MOD-A90084-----
            END IF
            IF cl_null(l_qcs091c) OR l_qcs091c = 0 THEN
            #-----END CHI-880006-----
               SELECT SUM(qcs091) INTO l_qcs091c
                 FROM qcs_file
                WHERE qcs01 = l_qcs01
                  AND qcs02 = l_qcs02
                  AND qcs14 = 'Y'
            END IF   #CHI-880006
 
            IF l_qcs091c IS NULL THEN
               LET l_qcs091c =0
            END IF
            IF l_argv0<>"8" OR cl_null(l_argv0) THEN #CHI-690055
               IF l_ogb12 > l_qcs091c THEN
                  LET g_success = 'N'                  #No.MOD-730004
                  RETURN
               END IF
            END IF
         END IF
      END IF
   END FOREACH
 
   IF g_aza.aza50='Y' THEN
      SELECT occ1027 INTO l_occ1027 FROM occ_file
       WHERE occ01=l_oga.oga1004
             AND occ1004='1'   #核准的
      IF l_occ1027 ='Y' AND l_oga.oga00='6'  THEN
         LET g_success='N' #FUN-730012
         RETURN
      END IF
   END IF

  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
  #IF NOT p_inTransaction THEN   #FUN-730012
  #   BEGIN WORK
  #   LET g_success = 'Y'
  #   LET g_totsuccess = 'Y' #TQC-620156
  #END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--

#FUN-BC0071 -----------------STA
#   CALL t600_upd_lqe(l_oga.*)            #TQC-C30097 mark
   IF g_success = 'Y' THEN
     CALL t600_app_ins_lsn(l_oga.*)
   END IF
   IF g_success = 'N' THEN
      RETURN
   END IF
#FUN-BC0071 -----------------END 

   LET l_oga.oga02=g_today   #FUN-650009 add
   UPDATE oga_file SET oga02=l_oga.oga02 WHERE oga01=l_oga.oga01   #FUN-650009 add
   #當帳款無法產生,此筆出貨單不可過帳-----#
     UPDATE oga_file SET ogapost='Y' WHERE oga01=l_oga.oga01
   IF NOT cl_null(l_oga.oga011) AND l_oga.oga09 <> '8' THEN #通知單號  #MOD-7A0177 不回寫產簽收單的出貨單
      UPDATE oga_file SET oga02=l_oga.oga02,ogapost='Y' WHERE oga01=l_oga.oga011   #FUN-650009 add
   END IF
   LET l_oga.ogapost='Y'
   #判斷單身料件的料件主檔資料ima_file，如果該料件的ima1012為空,則更新
   #出貨日期oga02至ima1012,否則不更新.
   DECLARE t600_ima1012 CURSOR FOR
      SELECT ima01,ima1012
        FROM ogb_file,ima_file
       WHERE  ogb01=l_oga.oga01 AND ogb04=ima01
 
   FOREACH t600_ima1012 INTO l_ima01,l_ima1012
      IF STATUS THEN
         LET g_success = 'N'    #TQC-930155 add
         EXIT FOREACH
      END IF
      IF cl_null(l_ima1012) THEN
         UPDATE ima_file
            SET ima1012=l_oga.oga69,  #FUN-650009
                imadate=g_today       #FUN-D10063 add 
          WHERE ima01=l_ima01
      ELSE
         CONTINUE FOREACH
      END IF
   END FOREACH
   LET  p_success1='Y'                    #No.TQC-7C0114
   #TQC-D30044--mark--str--
   #LET l_flag1='N'
   #IF l_argv0='4' AND l_poz.poz00='1' AND l_poz.poz011='1'
   #               AND g_sma.sma894[2,2]='N' THEN
   #   LET g_sma.sma894[2,2] = 'Y'
   #   LET l_flag1='Y'
   #END IF
    CALL t600_app_sub_s1(l_oga.*,p_cmd) RETURNING l_oha.* #FUN-9C0083  #TQC-D30060 remark
   #IF l_flag1='Y' THEN
   #   LET g_sma.sma894[2,2] = 'N'
   #END IF
   #IF sqlca.sqlcode THEN LET g_success='N' END IF
   #TQC-D30044--mark--str--
 
   #FUN-AC0074--begin--add----
   DECLARE t600sub_sie_c CURSOR FOR 
     SELECT DISTINCT ogb31,ogb32 FROM ogb_file,sie_file  #TQC-B50052 add sie_file
      WHERE ogb01=l_oga.oga01
        AND ogb31=sie05 AND ogb32=sie15 AND sie11 > 0    #TQC-B50052
   FOREACH t600sub_sie_c INTO l_oeb01,l_oeb03
      SELECT oeb24,oeb12,oeb25,oea09 INTO l_oeb24,l_oeb12,l_oeb25,l_oea09 FROM oeb_file,oea_file #TQC-B50052
       WHERE oeb01=l_oeb01 AND oeb03=l_oeb03 AND oea01=oeb01  #TQC-B50052
      IF cl_null(l_oeb24) THEN LET l_oeb24 = 0 END IF
      IF cl_null(l_oeb12) THEN LET l_oeb12 = 0 END IF
      IF cl_null(l_oeb25) THEN LET l_oeb25 = 0 END IF   #TQC-B50052
      IF cl_null(l_oea09) THEN LET l_oea09 = 0 END IF   #TQC-B50052
      SELECT SUM(sie11) INTO l_sie11 FROM sie_file
       WHERE sie05=l_oeb01 AND sie15=l_oeb03
      IF cl_null(l_sie11) THEN LET l_sie11 = 0 END IF
      IF l_sie11 > 0 THEN  #TQC-B50052
        #IF l_oeb24+l_sie11 > l_oeb12 THEN  #TQC-B50052
         IF l_oeb24+l_sie11 > (l_oeb12*((100+l_oea09)/100)+l_oeb25) THEN  #TQC-B50052
            LET g_success = 'N'
            LET g_showmsg = l_oeb01,"/",l_oeb03
            CALL cl_err(g_showmsg,'asf-881',1)
            EXIT FOREACH
         END IF
      END IF  #TQC-B50052
   END FOREACH
   ##FUN-AC0074--end--add------
    #需帶入流程序號
    IF (l_poz.poz19='Y' AND l_poz.poz18=g_plant) THEN
        LET l_sql= " SELECT oea99,ogb32 FROM oea_file,ogb_file ",  #MOD-830222 modify ogb31
                   "  WHERE oea01 = ogb31 ",
                   "    AND ogb01 = '",l_oga.oga01,"'",
                   "    AND oeaconf = 'Y' ",
                   "  ORDER BY ogb03"
        PREPARE oea_pre1 FROM l_sql
        DECLARE oea_f1 CURSOR FOR oea_pre1
        FOREACH oea_f1 INTO l_oea99,m_ogb32  #MOD-820037  #MOD-830222 modify
         IF STATUS THEN
            CALL cl_err('fetch oea99',STATUS,1)
            LET g_success = 'N'   #MOD-820037 add
         END IF
         EXIT FOREACH   #MOD-820037 add
        END FOREACH     #MOD-820037 add
        #考慮會有分批出貨中斷點問題,如此rva99會有多筆
         LET l_sql= " SELECT rva99 ",  
                    "   FROM rva_file,rvb_file,pmm_file ",
                    "  WHERE pmm01 = rvb04 ",
                    "    AND rvb01 = rva01 ",
                    "    AND rvb03 = '",m_ogb32,"' ",   #MOD-830222 add
                    "    AND pmm99 = '",l_oea99,"'",   
                    "   ORDER BY rva99 "
        PREPARE rva_pre1 FROM l_sql
        DECLARE rva_f1 CURSOR FOR rva_pre1
        FOREACH rva_f1 INTO l_oga.oga99
         IF STATUS THEN
            CALL cl_err('fetch rva99',STATUS,1)
            LET g_success = 'N'   
         END IF
         LET l_j = 0
         SELECT COUNT(*) INTO l_j FROM oga_file
          WHERE oga99 = l_oga.oga99
            AND (oga09 = '4' OR oga09 = '6' )
         IF l_j =  0 THEN
            EXIT FOREACH       #中斷後尚未有出貨單
         ELSE
            CONTINUE FOREACH   #中斷後已有出貨單
         END IF 
        END FOREACH  
         LET l_oga.oga905='Y'
         UPDATE oga_file
            SET oga99 =l_oga.oga99,
                oga905=l_oga.oga905
         WHERE oga01=l_oga.oga01
         IF STATUS OR sqlca.sqlerrd[3]=0 THEN
            CALL cl_err('update oga99',STATUS,1)
            LET g_success = 'N'
         END IF
    END IF
 
END FUNCTION
 
FUNCTION t600_app_sub_s1(l_oga,p_cmd) #FUN-9C0083
  DEFINE p_cmd LIKE type_file.chr1 #FUN-9C0083
  DEFINE l_ogc    RECORD LIKE ogc_file.*
  DEFINE l_ogc_1  RECORD LIKE ogc_file.*         #CHI-B30093  #CHI-B60054 mark CHI-B30093 内容  #FUN-C30289
  DEFINE l_oeb19  LIKE oeb_file.oeb19
  DEFINE l_oeb905 LIKE oeb_file.oeb905
  DEFINE l_flag   LIKE type_file.chr1     #No:8741  #No.FUN-680137 VARCHAR(1)
  DEFINE l_ogg    RECORD LIKE ogg_file.*
  DEFINE l_ima906 LIKE ima_file.ima906
  DEFINE l_ima25  LIKE ima_file.ima25
  DEFINE l_ima71  LIKE ima_file.ima71
  DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
  DEFINE l_cnt    LIKE type_file.num5                                                          #No.FUN-680137 SMALLINT
  DEFINE l_occ31  LIKE occ_file.occ31
  DEFINE l_tuq06  LIKE tuq_file.tuq06   #FUN-630102 modify adq->tuq
  DEFINE l_tuq07  LIKE tuq_file.tuq07   #FUN-630102 modify adq->tuq
  DEFINE l_desc   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)
  DEFINE l_t      LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(05)   #No.FUN-610064
  DEFINE l_oha53  LIKE oha_file.oha53     #No.FUN-610064
  DEFINE l_oha50  LIKE oha_file.oha50     #No.FUN-670008
  DEFINE l_oayauno LIKE oay_file.oayauno     #No.FUN-610064
  DEFINE l_oay17  LIKE oay_file.oay17     #No.FUN-610064
  DEFINE l_oay18  LIKE oay_file.oay18     #No.FUN-610064
  DEFINE l_oay20  LIKE oay_file.oay20     #No.FUN-610064
  DEFINE li_result LIKE type_file.num5                 #No.FUN-610064  #No.FUN-680137 SMALLINT
  DEFINE p_success LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)     #No.FUN-610064
  DEFINE l_unit   LIKE ogb_file.ogb05     #No.FUN-610064
  DEFINE l_oha01  LIKE oha_file.oha01     #No.FUN-610064
  DEFINE l_occ02  LIKE occ_file.occ02     #No.FUN-610064
  DEFINE l_occ1006 LIKE occ_file.occ1006  #No.FUN-610064
  DEFINE l_occ1017 LIKE occ_file.occ1017  #No.FUN-610064
  DEFINE l_occ09   LIKE occ_file.occ09    #No.FUN-610064
  DEFINE l_occ1005 LIKE occ_file.occ1005  #No.FUN-610064
  DEFINE l_occ1022 LIKE occ_file.occ1022  #No.FUN-610064
  DEFINE l_occ07   LIKE occ_file.occ07    #No.TQC-640123
  DEFINE l_occ1024 LIKE occ_file.occ1024  #No.FUN-610064
  DEFINE l_ohb03   LIKE ohb_file.ohb03    #No.FUN-610064
  DEFINE l_ohb13   LIKE ohb_file.ohb13    #No.FUN-610064
  DEFINE l_ohb13t  LIKE ohb_file.ohb13    #No.FUN-610064
  DEFINE l_ohb14   LIKE ohb_file.ohb14    #No.FUN-610064
  DEFINE l_ohb14t  LIKE ohb_file.ohb14    #No.FUN-610064
  DEFINE l_ohb1001 LIKE ohb_file.ohb1001  #No.FUN-610064
  DEFINE l_qty     LIKE ogb_file.ogb12    #No.TQC-640123
  DEFINE l_oayapr  LIKE oay_file.oayapr   #FUN-710037
  DEFINE l_argv0   LIKE ogb_file.ogb09
  DEFINE l_oga     RECORD LIKE oga_file.*
  DEFINE l_ogb     RECORD LIKE ogb_file.*
  DEFINE l_ogb12   LIKE ogb_file.ogb12 ,
         l_ogb912  LIKE ogb_file.ogb912,
         l_ogb915  LIKE ogb_file.ogb915,
         l_ogb917  LIKE ogb_file.ogb917
  DEFINE l_msg     STRING
  DEFINE l_oha     RECORD LIKE oha_file.*
  DEFINE l_ohb     RECORD LIKE ohb_file.*
  DEFINE l_tot1    LIKE ogc_file.ogc12
  DEFINE l_msg3    STRING        #No.TQC-7C0114
  DEFINE l_oah03   LIKE type_file.chr1   #FUN-820060
  DEFINE l_ima131  LIKE type_file.chr20  #FUN-820060
  DEFINE l_img18   LIKE img_file.img18    #CHI-A40029 add
  #DEFINE l_item    LIKE tqy_file.tqy35    #CHI-A40029 add   #MOD-A70017
  DEFINE l_item    LIKE ogc_file.ogc17    #MOD-A70017
  DEFINE l_ogb12_t LIKE ogb_file.ogb12  #CHI-AC0034 add
  DEFINE l_oga01   LIKE oga_file.oga01  #CHI-AC0034 add
  DEFINE l_ogc12   LIKE ogc_file.ogc12  #CHI-AC0034 add
  DEFINE l_img09   LIKE img_file.img09  #CHI-AC0034 add
  DEFINE l_tup06   LIKE tup_file.tup06  #MOD-B30651 add
  DEFINE l_ohbi   RECORD LIKE ohbi_file.* #FUN-B70074 add
  DEFINE l_idb    RECORD LIKE idb_file.*  #FUN-B40066
  DEFINE l_ogbi   RECORD LIKE ogbi_file.* #FUN-B40066 
#####
#FUN-910088--add--start--
  DEFINE l_tup05_1 LIKE tup_file.tup05,
         l_tuq07_1 LIKE tuq_file.tuq07,
         l_tuq09_1 LIKE tuq_file.tuq09
#FUN-910088--add--end--
  DEFINE l_rtz08       LIKE rtz_file.rtz08 #FUN-B80189 Add
  DEFINE l_factor  LIKE type_file.num26_10     #FUN-C50097
  DEFINE l_ogb2  DYNAMIC ARRAY OF RECORD       #FUN-C50097
                 ogb01   LIKE ogb_file.ogb01,
                 ogb03   LIKE ogb_file.ogb03,
                 ogb12   LIKE ogb_file.ogb12
                              END RECORD,
         l_ac      LIKE type_file.num5,   #FUN-C50097
         l_ogb50   LIKE ogb_file.ogb50,    #FUN-C50097   TQC-C70206              
         l_ogg12   LIKE ogg_file.ogg12,     #FUN-C50097 
         l_ogb12_t1 LIKE ogb_file.ogb12,
         l_ogb12_t2 LIKE ogb_file.ogb12,
         l_tot2    LIKE ogc_file.ogc12
 #DEFINE l_oga01_1  LIKE oga_file.oga01     #TQC-C70056 add#TQC-C70056 mark by xuxz
   DEFINE l_cnt2         LIKE type_file.num5  #MOD-CB0050

   CALL s_showmsg_init()   #No.FUN-6C0083
   LET l_argv0=l_oga.oga09  #FUN-730012
   INITIALIZE l_oha.* TO NULL #FUN-730012
   
   #INITIALIZE l_ogc_1.* TO NULL                #CHI-B30093  #CHI-B60054 mark CHI-B30093 
   
#判斷單頭出貨類型是否為代送，如果是，則必須生成一筆代送商的銷退單
   IF l_oga.oga00 = '6' THEN
      INITIALIZE l_oha.* TO NULL
      LET l_oha53=0
      ##產生銷退單別
      LET l_t = l_oga.oga01[1,g_doc_len]
      SELECT oayauno,oay17,oay18,oay20,oayapr
        INTO l_oayauno,l_oay17,l_oay18,l_oay20,l_oayapr #FUN-710037
        FROM oay_file
       WHERE oayslip = l_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","oay_file",l_t,"","atm-394","","",1)  #No.FUN-670008
         LET g_success = 'N'
         RETURN l_oha.*
      END IF
      CALL s_auto_assign_no("axm",l_oay17,l_oga.oga02,"","oha_file","oha01","","","")
               RETURNING li_result,l_oha01
      IF (NOT li_result) THEN
         CALL cl_err('','mfg3326',1)
         LET g_success = 'N'
         RETURN l_oha.*
      END IF
      LET l_oha.oha01 = l_oha01
 
      ##帳款客戶簡稱
      SELECT occ1006,occ1005,occ07,occ09,occ1022,occ1024              #No.TQC-640123
        INTO l_occ1006,l_occ1005,l_occ07,l_occ09,l_occ1022,l_occ1024  #No.TQC-640123
        FROM occ_file
       WHERE occ01=l_oga.oga1004
#根據 l_occ07取得代送商帳款客戶簡稱
      SELECT occ02 into l_occ02 FROM occ_file WHERE occ01=l_oga.oga1004   #TQC-640123
 
#給銷退單單頭各欄位賦值:
      LET l_oha.oha01 = l_oha01                  #銷退單號
      LET l_oha.oha02 = l_oga.oga02              #銷退日期
      LET l_oha.oha03 = l_oga.oga1004            #客戶編號   #TQC-640123
      LET l_oha.oha032=l_occ02                   #帳款客戶簡稱 #TQC-640123 #No.MOD-7B0198
      LET l_oha.oha1009=l_occ1006                #渠道
      LET l_oha.oha04=l_occ09                  #退貨客戶
      LET l_oha.oha1011=l_occ1022                #發票客戶
      LET l_oha.oha1001=l_occ07                  #收款客戶  TQC-640123
      LET l_oha.oha1003=l_occ1024                #業績歸屬方
      LET l_oha.oha1010=l_occ1005                #客戶所屬方
      LET l_oha.oha1017='0'                      #導物流狀況碼
      LET l_oha.oha1005 = 'Y'                    #是否計算業績
      LET l_oha.oha05 ='1'                       #單據別
      LET l_oha.oha08 ='1'                       #內銷、外銷
      LET l_oha.oha09 ='1'                       #銷退處理方式
      LET l_oha.oha14 =l_oga.oga14               #人員編號
      LET l_oha.oha15 =l_oga.oga15               #部門編號
      LET l_oha.oha21 =l_oga.oga21               #稅種
      LET l_oha.oha211=l_oga.oga211              #稅率
      LET l_oha.oha212=l_oga.oga212              #聯數
      LET l_oha.oha213=l_oga.oga213              #含稅否
      LET l_oha.oha23 =l_oga.oga23               #幣種
      LET l_oha.oha24 =l_oga.oga24               #匯率
      LET l_oha.oha25 =l_oga.oga25               #銷售分類一
      LET l_oha.oha26 =l_oga.oga26               #銷售分類二
      LET l_oha.oha31 =l_oga.oga31               #價格條件
      LET l_oha.oha41 ='N'                       #三角貿易銷退單否
      LET l_oha.oha42 ='N'                       #是否入庫存
      LET l_oha.oha43 ='N'                       #起始三角貿易銷退單否
      LET l_oha.oha44 ='N'                       #拋轉否
      LET l_oha.oha1018 =l_oga.oga01             #代送出貨單號
      LET l_oha.oha50 =0                         #原幣銷退總稅前金額
      LET l_oha.oha53 =l_oha53                   #原幣銷退應開折讓稅前金額
      LET l_oha.oha54 =0                         #原幣銷退已開折讓稅前金額
      LET l_oha.oha55 ='1'                       #狀況碼
      LET l_oha.ohaconf ='Y'                     #審核否
      LET l_oha.ohapost ='Y'                     #庫存過賬否
      LET l_oha.ohauser =l_oga.ogauser           #資料所有者
      LET l_oha.ohagrup =l_oga.ogagrup           #資料所有部門
      LET l_oha.ohadate =g_today                 #最近更改日
      LET l_oha.oha1002 = l_oay20                #債權
      LET l_oha.oha1004 = l_oay18              #退貨原因碼
      LET l_oha.oha1006 = 0                    #折扣金額(未稅)
      LET l_oha.oha1007 = 0                    #折扣金額(含稅)
      LET l_oha.oha1008 = 0                    #銷退單總含稅金額
      LET l_oha.oha1015 = 'Y'                  #代送出貨自動生成否
 
      LET l_oha.ohaplant = l_oga.ogaplant
      LET l_oha.ohalegal = l_oga.ogalegal
      IF g_azw.azw04 = '2' THEN
         LET l_oha.oha85 = l_oga.oga85
         LET l_oha.oha86 = l_oga.oga86       
         LET l_oha.oha87 = l_oga.oga87                                                                                              
         LET l_oha.oha88 = l_oga.oga88 
         LET l_oha.oha89 = l_oga.oga89                                                                                              
         LET l_oha.oha90 = l_oga.oga90                                                                                              
         LET l_oha.oha91 = l_oga.oga91                                                                                              
         LET l_oha.oha92 = l_oga.oga92   
         LET l_oha.oha93 = l_oga.oga93                                                                                              
         LET l_oha.oha94 = l_oga.oga94                                                                                              
         LET l_oha.oha95 = l_oga.oga95                                                                                              
         LET l_oha.oha96 = l_oga.oga96                                                                                              
         LET l_oha.oha97 = l_oga.oga97                                                                                              
      ELSE
         LET l_oha.oha85=' '
         LET l_oha.oha94='N'
      END IF
 
      IF cl_null(l_oayapr) THEN
         LET l_oha.ohamksg='N'
      END IF
 
      LET l_oha.ohaplant = g_plant 
      LET l_oha.ohalegal = g_legal 
 
      LET l_oha.ohaoriu = g_user      #No.FUN-980030 10/01/04
      LET l_oha.ohaorig = g_grup      #No.FUN-980030 10/01/04
      IF cl_null(l_oha.oha57) THEN LET l_oha.oha57 = '1' END IF #FUN-AC0055 add
      INSERT INTO oha_file VALUES(l_oha.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","oha_file",l_oha.oha01,"",SQLCA.sqlcode,"","",1)  #No.FUN-670008
         LET g_success = 'N'
         RETURN l_oha.*
      END IF
      #更新oga1012=銷退單,oga1014='N'
      UPDATE oga_file SET oga1012 = l_oha.oha01,oga1014='N'
       WHERE oga01 = l_oga.oga01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN l_oha.*
      END IF
 
   END IF
 #TQC-B10066 Begin---
 #DECLARE t600_s1_c CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=l_oga.oga01 AND ogb1005 = '1' #No.FUN-610064
  DECLARE t600_s1_c CURSOR FOR
   SELECT * FROM ogb_file
    WHERE ogb01=l_oga.oga01
      AND (ogb1005 = '1' OR (ogb1005='2' AND ogb03<9001))
 #TQC-B10066 End-----
  FOREACH t600_s1_c INTO l_ogb.*
      IF STATUS THEN EXIT FOREACH END IF
#MOD-B80054 -- begin --
      IF cl_null(l_ogb.ogb09) THEN LET l_ogb.ogb09 = ' ' END IF
      IF cl_null(l_ogb.ogb091) THEN LET l_ogb.ogb091 = ' ' END IF
      IF cl_null(l_ogb.ogb092) THEN LET l_ogb.ogb092 = ' ' END IF
#MOD-B80054 -- end -- 

    #CHI-A40029 add --start--
      IF l_ogb.ogb04 NOT MATCHES 'MISC*' AND l_oga.oga09 MATCHES '[2468]' THEN
         IF l_ogb.ogb17='Y' THEN   #多倉儲
            DECLARE chk_ogc2 CURSOR FOR
               SELECT *
                 FROM ogc_file
                WHERE ogc01 = l_ogb.ogb01
                  AND ogc03 = l_ogb.ogb03
            FOREACH chk_ogc2 INTO l_ogc.*
               IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
               LET l_cnt=0
               IF g_oaz.oaz23 = 'Y' AND NOT cl_null(l_ogc.ogc17) THEN
               LET l_item = l_ogc.ogc17
               ELSE
                  let l_item = l_ogb.ogb04
               END IF
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM img_file
                   WHERE img01 = l_item AND img02=l_ogc.ogc09
                     AND img03 = l_ogc.ogc091
                     AND img04 = l_ogc.ogc092
               IF l_cnt=0 THEN
#                 CALL s_add_img(l_item,l_ogb.ogb09,             #MOD-B80054 mark
#                                l_ogb.ogb091,l_ogb.ogb092,      #MOD-B80054 mark
                  CALL s_add_img(l_item,l_ogc.ogc09,             #MOD-B80054
                                 l_ogc.ogc091,l_ogc.ogc092,      #MOD-B80054
                                 l_oga.oga01,l_ogb.ogb03,l_oga.oga02)
                  IF g_errno='N' THEN
                     LET g_success = 'N'
                     RETURN l_oha.*
                  END IF
               END IF
            END FOREACH
         ELSE
#FUN-AB0011 ----------------STA
            IF s_joint_venture( l_ogb.ogb04,g_plant) OR NOT s_internal_item( l_ogb.ogb04,g_plant ) THEN  
            ELSE   
#FUN-AB0011 ----------------END
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM img_file
                WHERE img01=l_ogb.ogb04  AND img02=l_ogb.ogb09
                  AND img03=l_ogb.ogb091 AND img04=l_ogb.ogb092
               IF l_cnt = 0 THEN
                  CALL s_add_img(l_ogb.ogb04,l_ogb.ogb09,
                                 l_ogb.ogb091,l_ogb.ogb092,
                                 l_oga.oga01,l_ogb.ogb03,l_oga.oga02)
                  IF g_errno='N' THEN
                     LET g_success = 'N'
                     RETURN l_oha.*
                  END IF
               END IF
               SELECT img18 INTO l_img18 FROM img_file
                WHERE img01=l_ogb.ogb04  AND img02=l_ogb.ogb09
                  AND img03=l_ogb.ogb091 AND img04=l_ogb.ogb092
               IF l_img18 < l_oga.oga02 THEN
                  CALL cl_err(l_ogb.ogb04,'aim-400',1)  #須修改
                  LET g_success = 'N'
                  RETURN l_oha.*
               END IF
            END IF                                           #FUN-AB0011
         END IF
      END IF

      IF l_ogb.ogb04[1,4] != 'MISC' THEN
            #-----MOD-A90190---------
            #LET l_cnt=0
            #SELECT SUM(img10*img21) INTO l_qty FROM img_file
            # WHERE img01=l_ogb.ogb04 AND img02=l_ogb.ogb09
            #   AND img03=l_ogb.ogb091 AND img04=l_ogb.ogb092
            #IF l_cnt=0 THEN
            #   IF l_qty IS NULL THEN LET l_qty=0 END IF
            #   LET g_msg=NULL
            #   SELECT ze03 INTO g_msg FROM ze_file
            #    WHERE ze01='axm-246' AND ze02=p_lang
            #   ERROR g_msg CLIPPED,l_qty
            #END IF
            #-----END MOD-A90190-----
      END IF
      IF l_ogb.ogb04[1,4] != 'MISC' THEN #MOD-BB0335 add
         IF l_oga.oga09 <> '4' THEN    #MOD-A90149
            IF l_ogb.ogb17 = 'N' THEN
              #FUN-B80189 Add Begin ---
               #若料件的經營屬性為扣率代銷或者經營方式為成本代銷且代銷控制為2.非成本倉，則判斷營運中心非成本倉庫存
               IF l_ogb.ogb44 = '3' OR (l_ogb.ogb44 = '2' AND g_sma.sma146 = '2') THEN
                  LET l_qty = 0
                  LET l_rtz08 = NULL
                 #SELECT rtz08 INTO l_rtz08 FROM rtz_file WHERE rtz01 = l_ogb.ogbplant    #FUN-C90049 mark
                  CALL s_get_noncoststore(l_ogb.ogbplant,l_ogb.ogb04) RETURNING l_rtz08   #FUN-C90049 add
                  IF NOT cl_null(l_rtz08) THEN
                     SELECT SUM(img10*img21) INTO l_qty FROM img_file WHERE img01 = l_ogb.ogb04 AND img02 = l_rtz08
                     IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                    #IF l_ogb.ogb12 > l_qty THEN                  #MOD-BB0043 mark
                     IF l_ogb.ogb12 *l_ogb.ogb05_fac > l_qty THEN #MOD-BB0043
                        LET g_flag2 = NULL    #FUN-C80107 add
                       #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_rtz08) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
                        CALL s_inv_shrt_by_warehouse(l_rtz08,g_plant) RETURNING g_flag2                     #FUN-D30024 add  #TQC-D40078 g_plant
                       #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN   #FUN-C80107 mark
                        IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
                           CALL s_errmsg('',l_ogb.ogb12,'','axm-387',1)
                           LET g_success = 'N'
                           RETURN l_oha.*
                        ELSE
                           IF NOT cl_confirm('mfg3469') THEN
                              LET g_success = 'N'
                              RETURN l_oha.*
                           END IF
                        END IF
                     END IF
                  END IF
               ELSE 
               #反之則判斷營運中心成本倉庫存
                  LET l_qty = 0
                  SELECT SUM(img10*img21) INTO l_qty FROM img_file
                   WHERE img01=l_ogb.ogb04 AND img02=l_ogb.ogb09
                     AND img03=l_ogb.ogb091 AND img04=l_ogb.ogb092
                  IF l_qty IS NULL THEN LET l_qty=0 END IF
              #FUN-B80189 Add End -----
                 #IF l_ogb.ogb12 > l_qty THEN                  #MOD-BB0043 mark
                  IF l_ogb.ogb12 *l_ogb.ogb05_fac > l_qty THEN #MOD-BB0043
                     LET g_flag2 = NULL    #FUN-C80107 add
                    #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],l_ogb.ogb09) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
                     CALL s_inv_shrt_by_warehouse(l_ogb.ogb09,g_plant) RETURNING g_flag2   #FUN-D30024 add   #TQC-D40078 g_plant
                    #IF g_sma.sma894[2,2]='N' OR g_sma.sma894[2,2] IS NULL THEN   #FUN-C80107 mark
                     IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
                       #CALL cl_err(l_ogb.ogb12,'axm-280',1) #FUN-B80189 Mark
                       #CALL s_errmsg('',l_ogb.ogb12,'','axm-280',1) #FUN-B80189 Add #MOD-D10273 mark
                        LET g_showmsg = l_ogb.ogb04,"/",l_ogb.ogb12             #MOD-D10273
                        CALL s_errmsg('ogb04,ogb12',g_showmsg,'','axm-280',1)   #MOD-D10273
                        CALL s_showmsg() #TQC-C20502 add
                        LET g_success = 'N'
                        RETURN l_oha.*
                     ELSE
                        IF NOT cl_confirm('mfg3469') THEN
                           LET g_success = 'N'
                           RETURN l_oha.*
                        END IF
                     END IF
                  END IF
               END IF  #FUN-B80189 Add
            END IF
         END IF   #MOD-A90149
      END IF #MOD-BB0335 add
      IF l_ogb.ogb04[1,4] != 'MISC' THEN
          IF l_oga.oga09 NOT MATCHES  '[159]' THEN #非出貨通知單  
             CALL t600_app_sub_chk_img(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF
             #-----MOD-B10141---------
             IF l_ogb.ogb17 = 'N' THEN
                CALL t600_app_sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF  
             END IF
             #-----END MOD-B10141-----
          END IF
      END IF
    #CHI-A40029 add --end--

      #-----MOD-B10141---------
      #IF l_ogb.ogb17 = 'N' THEN
      #   CALL t600_app_sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF   #No.TQC-7C0114
      #END IF
      #-----END MOD-B10141-----

     LET l_ogb12_t = l_ogb.ogb12 #CHI-AC0034 add  #CHI-B30093 mark #CHI-B60054去掉mark
##CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--
#      SELECT SUM(ogc12) INTO l_ogb12_t FROM ogc_file
#       WHERE ogc01= l_ogb.ogb01
#         AND ogc03 =l_ogb.ogb03
#      IF cl_null(l_ogb12_t) THEN 
#         LET l_ogb12_t = 0 
#      END IF    
#CHI-B30093 --end--
##CHI-B60054  --End #MARK掉CHI-B30093更改


      #atmt629對于待驗倉庫的數量不應以單身的數量來做扣帳,因為如有驗退的數量
      #要把相應的量轉至驗退單上,所以此處就把它扣完,然后再后面處理驗退倉庫的量增加
      IF l_argv0 = '8' AND g_aza.aza26 != '2' THEN  #FUN-C50097 ADD !='2'
         SELECT ogb12,ogb912,ogb915,ogb917 INTO l_ogb12,l_ogb912,l_ogb915,l_ogb917
           FROM oga_file,ogb_file
          WHERE ogb01 = oga01
            AND oga01 = l_oga.oga011
           #AND oga09 = '2' AND oga65='Y'
           #AND (oga09 = '2' OR oga09 = '3') AND oga65='Y'  #FUN-BB0167   #FUN-C40072 mark
            AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4') AND oga65='Y' #FUN-C40072 add
            AND ogb03 = l_ogb.ogb03
          IF cl_null(l_ogb12)  THEN LET l_ogb12  = 0 END IF
          IF cl_null(l_ogb912) THEN LET l_ogb912 = 0 END IF
          IF cl_null(l_ogb915) THEN LET l_ogb915 = 0 END IF
          IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF
          LET l_ogb.ogb12 = l_ogb12
          LET l_ogb.ogb912= l_ogb912
          LET l_ogb.ogb915= l_ogb915
          LET l_ogb.ogb917= l_ogb917
         #LET l_ogb.ogb16 = l_ogb.ogb12/l_ogb.ogb15_fac #MOD-B10172 mark
          LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac #MOD-B10172
      END IF
#FUN-C50097 ADD BEG------
      IF l_argv0 = '8' AND g_aza.aza26 = '2' THEN #FUN-C50097 ADD 2
         #大陸版新增,此處暫不扣完,處理客戶簽退量
         IF g_oaz.oaz94 = 'Y' THEN
            IF l_ogb.ogb52 > 0 THEN #有签退量
               LET l_ogb.ogb12 = l_ogb.ogb12 + l_ogb.ogb52 #签退量+签收量
               LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac
               IF g_sma.sma115 = 'Y' THEN 
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=l_ogb.ogb04
                  IF l_ima906 = '2' THEN 
                  LET l_ogb.ogb912 =  (l_ogb.ogb12  mod l_ogb.ogb914)/l_ogb.ogb911    #从签收仓扣除子单位数量
                  LET l_ogb.ogb915 =  (l_ogb.ogb12   - l_ogb.ogb912*l_ogb.ogb911) / l_ogb.ogb914   #从签收仓扣除母单位数量
                  END IF 
                  IF l_ima906 = '3' THEN 
                     IF NOT cl_null(l_ogb.ogb911) THEN 
                        LET l_ogb.ogb912 = l_ogb.ogb12 / l_ogb.ogb911
                     END IF 
                     IF NOT cl_null(l_ogb.ogb914) THEN 
                        LET l_ogb.ogb915 = l_ogb.ogb12 / l_ogb.ogb914
                     END IF                  
                  END IF     
               END IF
               IF NOT cl_null(l_ogb.ogb916) THEN
                  CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb916)
                       RETURNING l_cnt,l_factor
                  IF l_cnt = 1 THEN
                     LET l_factor = 1               	  
                  END IF 
                  LET l_ogb.ogb917 = l_ogb.ogb12 * l_factor ##从签收仓扣除计价单位数量
               END IF               
            END IF 
         ELSE 
            SELECT ogb12,ogb912,ogb915,ogb917 INTO l_ogb12,l_ogb912,l_ogb915,l_ogb917
              FROM oga_file,ogb_file
             WHERE ogb01 = oga01
               AND oga01 = l_oga.oga011
              #AND oga09 = '2' AND oga65='Y'
              #AND (oga09 = '2' OR oga09 = '3') AND oga65='Y'  #FUN-BB0167   #FUN-C40072 mark
               AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4') AND oga65='Y' #FUN-C40072 add
               AND ogb03 = l_ogb.ogb03
             IF cl_null(l_ogb12)  THEN LET l_ogb12  = 0 END IF
             IF cl_null(l_ogb912) THEN LET l_ogb912 = 0 END IF
             IF cl_null(l_ogb915) THEN LET l_ogb915 = 0 END IF
             IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF
             LET l_ogb.ogb12 = l_ogb12
             LET l_ogb.ogb912= l_ogb912
             LET l_ogb.ogb915= l_ogb915
             LET l_ogb.ogb917= l_ogb917
            #LET l_ogb.ogb16 = l_ogb.ogb12/l_ogb.ogb15_fac #MOD-B10172 mark
             LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac #MOD-B10172
          END IF 
      END IF
#FUN-C50097 ADD END------  
      LET l_msg='_s1() read no:',l_ogb.ogb03 USING '#####&',
                             '--> parts: ', l_ogb.ogb04
      CALL cl_msg(l_msg)
      IF cl_null(l_ogb.ogb04) THEN CONTINUE FOREACH END IF
      CALL t600_app_sub_bu1(l_oga.*,l_ogb.*)   #No.TQC-8C0027
      IF g_success = 'N' THEN RETURN l_oha.* END IF
      IF g_oaz.oaz03 = 'N' THEN CONTINUE FOREACH END IF
      IF l_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF
 
      IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
       #TQC-C70056 mark--str-by xuxz
       ##TQC-C70056 -- add -- begin
       # IF g_prog[1,7] = "axmt628" THEN
       #    LET l_oga01_1 = l_oga.oga011
       # ELSE
       #    LET l_oga01_1 = l_oga.oga01
       # END IF
       # IF cl_null(l_oga01_1) THEN
       #    LET l_oga01_1 = ''
       # END IF
       ##TQC-C70056 -- add -- end
       #TQC-C70056 mark--end -by xuxz
         SELECT SUM(ogc12) INTO l_tot1 FROM ogc_file WHERE ogc01=l_oga.oga01           #TQC-C70056 mark#TQC-C70056 remark by xuxz
        #SELECT SUM(ogc12) INTO l_tot1 FROM ogc_file WHERE ogc01=l_oga01_1             #TQC-C70056 add#TQC-C70056 mark by xuxz
                                                     AND ogc03=l_ogb.ogb03
        #IF l_tot1 != l_ogb.ogb12 OR   		#多倉儲合計數量與產品項次不符 #CHI-AC0034 mark 
         IF l_tot1 != l_ogb12_t OR   		#多倉儲合計數量與產品項次不符 #CHI-AC0034
            cl_null(l_tot1) THEN
            LET l_msg = ''
            LET l_msg = cl_get_feldname('ogb03',g_lang)
            LET l_msg = l_msg CLIPPED,l_ogb.ogb03,'  ogc12!=ogb12:'
            CALL s_errmsg('','',l_msg,"axm-172",1)                #No.FUN-710046
            LET g_success='N' DISPLAY "1" EXIT FOREACH
         END IF
         #FUN-C50097 ADD BEGIN 120809 #判斷單身項次簽退量和多倉儲簽退量是否一致
         IF l_oga.oga09 = '8' AND g_aza.aza26='2' AND g_oaz.oaz94 = 'Y' THEN 
            SELECT SUM(ogc13) INTO l_tot2 FROM ogc_file WHERE ogc01=l_oga.oga01
                                                     AND ogc03=l_ogb.ogb03 
            IF l_tot2 != l_ogb.ogb52 OR   		#多倉儲合計數量與產品項次不符 #CHI-AC0034
               cl_null(l_tot2) THEN
               LET l_msg = ''
               LET l_msg = cl_get_feldname('ogb03',g_lang)
               LET l_msg = l_msg CLIPPED,l_ogb.ogb03,'  ogc13!=ogb52:'
               CALL s_errmsg('','',l_msg,"axm-172",1)                #No.FUN-710046
               LET g_success='N' DISPLAY "1" EXIT FOREACH
            END IF                                                                
         END IF 
         #FUN-C50097 ADD END   120809
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin-         
#         IF l_argv0 !='8' THEN 
#            IF l_ogb12_t != l_ogb.ogb12 THEN 
#               LET l_msg = ''
#               LET l_msg = cl_get_feldname('ogb03',g_lang)
#               LET l_msg = l_msg CLIPPED,l_ogb.ogb03,'  ogc12!=ogb12:'
#               CALL s_errmsg('','',l_msg,"axm-172",1)               
#               LET g_success='N' DISPLAY "1" EXIT FOREACH                       
#            END IF 
#         END IF    
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
                     
         LET l_flag=''  #No:8741
         DECLARE t600_s1_ogc_c CURSOR FOR  SELECT * FROM ogc_file
            WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
         FOREACH t600_s1_ogc_c INTO l_ogc.*
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1) #No.FUN-710046
               LET g_success='N' DISPLAY "2" EXIT FOREACH
            END IF
            LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
            CALL cl_msg(l_msg)
           #LET l_flag = 'Y'  #MOD-C10147 add  #TQC-C40244 mark
           #----------------No:CHI-A70023 add  
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt FROM ogc_file WHERE ogc01= l_oga.oga01
                     AND ogc03 = l_ogb.ogb03 AND ogc17 != l_ogb.ogb04
            IF l_cnt != 0 THEN 
               LET l_flag = 'X'
            END IF
           #----------------No:CHI-A70023 end  
#CHI-B60054  --Begin #去掉MARK CHI-B30093
#CHI-B30093 --begin--
#-------FUN-C50097 ADD BEGIN-----
           IF l_oga.oga09 = '8' THEN
              IF g_aza.aza26='2' AND g_oaz.oaz94 = 'Y' THEN
                  SELECT SUM(ogc12) INTO l_ogc12
                    FROM ogc_file
                   WHERE ogc01 = l_oga.oga011
                     AND ogc03 = l_ogb.ogb03
                     AND ogc17 = l_ogc.ogc17  
                  #No.MOD-C70145  --Begin
                     AND ogc092= l_ogc.ogc092
                  #No.MOD-C70145  --End                      
                  IF l_ogc.ogc12 != l_ogc12 THEN
                     LET l_ogc.ogc12 = l_ogc.ogc12 + l_ogc.ogc13 #銷售數量 + 銷退數量 = 本次簽收倉,過帳異動數量
                     LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
                     LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
                  END IF                                    
              ELSE 
#           #CHI-AC0034 add --start--
#           #有驗退時,在途倉仍是出全部數量(含可入庫數量、驗退數量)
#           IF l_oga.oga09 = '8' THEN #MOD-B40148 add
                  SELECT SUM(ogc12) INTO l_ogc12
                    FROM ogc_file
                   WHERE ogc01 = l_oga.oga011
                     AND ogc03 = l_ogb.ogb03
                     AND ogc17 = l_ogc.ogc17
                  #No.MOD-C70145  --Begin
                     AND ogc092= l_ogc.ogc092
                  #No.MOD-C70145  --End     
                  IF l_ogc.ogc12 != l_ogc12 THEN
                     LET l_ogc.ogc12 = l_ogc12
                     LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
                     LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
                  END IF
#           END IF #MOD-B40148 add 
               END IF 
            END IF 
#-------FUN-C50097 ADD END---------           
#           #CHI-AC0034 add --end--
#CHI-B30093 --end--
#CHI-B60054  --End #去掉MARK CHI-B30093                                   	 
            IF g_oaz.oaz23 = 'Y' AND NOT cl_null(l_ogc.ogc17) THEN
               CALL t600_app_sub_update(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                             l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) #No:8741
            ELSE
               CALL t600_app_sub_update(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                               l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*) #No:8741
            END IF
            LET l_flag='Y'  #No:8741 #MOD-C10147 mark  #TQC-C40244 remark
            IF g_success='N' THEN    #No.FUN-6C0083
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
         END FOREACH
     #MOD-BB0051 mark add -----
     # ELSE
     ##    CALL t600_chk_ima262(l_ogb.*) #BUG-4A0232,MOD-520078   #MOD-850309 #FUN-A20044
     #    CALL t600_chk_avl_stk(l_ogb.*) #BUG-4A0232,MOD-520078   #MOD-850309 #FUN-A20044
     #    CALL t600_app_sub_update(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
     #                     l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)  #No:8741  #FUN-5C0075 #FUN-730012
     #    IF g_success='N' THEN    #No.FUN-6C0083
     #       LET g_totsuccess="N"
     #       LET g_success="Y"
     #       CONTINUE FOREACH
     #    END IF
     # END IF
     #MOD-BB0051 mark add -----
         IF g_success='N' THEN RETURN l_oha.* END IF #MOD-4A0232
#--------#FUN-C50097 ADD BEGIN----------
#多倉儲出貨流程   #當爲大陸版,且立賬走開票流程,且不做發出商品管理
         IF g_success = 'Y' THEN
          IF g_aza.aza26='2' AND g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN 
             IF cl_null(g_oaz.oaz95) THEN 
                CALL cl_err('axms100/oaz95','axm-956',1)  #須修改
                LET g_success = 'N'
                RETURN l_oha.* 
             ELSE
#MOD-CB0050 add begin-------------------------------
                CALL t600_app_sub_chk_ogb1001(l_ogb.ogb1001) RETURNING l_cnt2
                IF l_cnt2 > 0 THEN 
                   #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                   #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                ELSE 
#MOD-CB0050 add end--------------------------------- 
                   IF (g_prog[1,7] = 'axmt620' OR g_prog[1,7] = 'axmp230') AND l_oga.oga65='N' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00
                      #當走直接出貨時, #TQC-D10067 add g_prog[1,7] = 'axmp230' 
                      #更新發票倉庫存和產生tlf檔案
   #FUN-C50097 ADD 120726 
   #将多仓储批的存储批号更新到发票仓
                      DECLARE t600_sub_ogc_c42 CURSOR FOR          
                       SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file 
                         WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03  
                       GROUP BY ogc17,ogc092                                             
                      FOREACH t600_sub_ogc_c42 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  
                         IF SQLCA.SQLCODE THEN
                            CALL s_errmsg('','',"Foreach t600_sub_ogc_c42:",SQLCA.sqlcode,1)
                            LET g_success='N' RETURN 
                         END IF
                         LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
                         CALL cl_msg(l_msg)
                         LET l_flag='X'                
                         SELECT img09 INTO l_img09 FROM img_file
                          WHERE img01= l_ogb.ogb04  AND img02= g_oaz.oaz95            
                            AND img03= l_oga.oga03  AND img04= l_ogc.ogc092             
                         #FUN-C50097 ADD BEG
                         IF cl_null(l_img09) THEN 
                            SELECT DISTINCT img09 INTO l_img09 FROM img_file
                             WHERE img01= l_ogb.ogb04  AND img04= l_ogc.ogc092                               
                         END IF             
                         #FUN-C50097 ADD END  
                         CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
                         LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
                         LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15) 
                         CALL t600_app_sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogc.ogc092,l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,
                         l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) 
                         IF g_success='N' THEN 
                            LET g_totsuccess="N"
                            LET g_success="Y"
                            CONTINUE FOREACH
                         END IF
                      END FOREACH    
   #FUN-C50097 ADD 120726                          
   #                  CALL t600_app_sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
             
                      IF g_success='N' THEN 
                         LET g_totsuccess="N"
                         LET g_success="Y"
                         CONTINUE FOREACH
                      END IF
                   END IF
                   IF g_prog[1,7] = 'axmt628' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00 
                   #更新發票倉庫存和產生tlf檔案,走出貨簽收時候,去掉簽退數量
                      #IF l_ogb.ogb52 > 0 THEN #有签退量                 l_ogb.ogb12  - l_ogb.ogb52
                      #   LET l_ogb.ogb12 = l_ogb.ogb12 - l_ogb.ogb52 #(签退量+签收量) -  簽退量
                      SELECT ogb12 INTO l_ogb12_t1 FROM ogb_file #出货单数量
                       WHERE ogb01 = l_oga.oga011
                         AND ogb03 = l_ogb.ogb03
                      SELECT ogb12 INTO l_ogb12_t2 FROM ogb_file #签收单数量
                       WHERE ogb01 = l_oga.oga01
                         AND ogb03 = l_ogb.ogb03 
                      IF cl_null(l_ogb12_t1) THEN LET  l_ogb12_t1 = 0 END IF 
                      IF cl_null(l_ogb12_t2) THEN LET  l_ogb12_t2 = 0 END IF  
                      IF l_ogb12_t1 - l_ogb12_t2 > 0 THEN  #出货量大于签收量
                         LET l_ogb.ogb12 = l_ogb12_t2                   
                         LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac
                          IF g_sma.sma115 = 'Y' THEN 
                             SELECT ima906 INTO l_ima906 FROM ima_file
                              WHERE ima01=l_ogb.ogb04
                             IF l_ima906 = '2' THEN 
                                LET l_ogb.ogb912 =  (l_ogb.ogb12  mod l_ogb.ogb914)/l_ogb.ogb911    #签退子单位数量
                                LET l_ogb.ogb915 =  (l_ogb.ogb12   - l_ogb.ogb912*l_ogb.ogb911) / l_ogb.ogb914   #签退母单位数量                          
                             END IF 
                             IF l_ima906 = '3' THEN 
                                IF NOT cl_null(l_ogb.ogb911) THEN 
                                   LET l_ogb.ogb912 = l_ogb.ogb12 / l_ogb.ogb911
                                END IF 
                                IF NOT cl_null(l_ogb.ogb914) THEN 
                                   LET l_ogb.ogb915 = l_ogb.ogb12 / l_ogb.ogb914
                                END IF                  
                             END IF     
                          END IF
                         IF NOT cl_null(l_ogb.ogb916) THEN
                            CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb916)
                                 RETURNING l_cnt,l_factor
                            IF l_cnt = 1 THEN
                               LET l_factor = 1               	  
                            END IF 
                            LET l_ogb.ogb917 = l_ogb.ogb12 * l_factor
                         END IF               
                      END IF
   #将多仓储批的存储批号更新到发票仓
                      DECLARE t600_sub_ogc_c43 CURSOR FOR          
                       SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file 
                         WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03  
                       GROUP BY ogc17,ogc092                                             
                      FOREACH t600_sub_ogc_c43 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  
                         IF SQLCA.SQLCODE THEN
                            CALL s_errmsg('','',"Foreach t600_sub_ogc_c43:",SQLCA.sqlcode,1)
                            LET g_success='N' RETURN 
                         END IF
                         LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
                         CALL cl_msg(l_msg)
                         LET l_flag='X'                
                         SELECT img09 INTO l_img09 FROM img_file
                          WHERE img01= l_ogb.ogb04  AND img02= g_oaz.oaz95            
                            AND img03= l_oga.oga03  AND img04= l_ogc.ogc092             
                         #FUN-C50097 ADD BEG
                         IF cl_null(l_img09) THEN 
                            SELECT DISTINCT img09 INTO l_img09 FROM img_file
                             WHERE img01= l_ogb.ogb04  AND img04= l_ogc.ogc092                               
                         END IF             
                         #FUN-C50097 ADD END  
                         CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
                         LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
                         LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15) 
                         CALL t600_app_sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogc.ogc092,l_ogc.ogc12,l_ogb.ogb05,
                         l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) 
                         IF g_success='N' THEN 
                            LET g_totsuccess="N"
                            LET g_success="Y"
                            CONTINUE FOREACH
                         END IF
                      END FOREACH    
   #FUN-C50097 ADD 120726                   
               
                      IF g_success='N' THEN 
                         LET g_totsuccess="N"
                         LET g_success="Y"
                         CONTINUE FOREACH
                      END IF                                          
                   END IF #axmt628
                END IF #MOD-CB0050 add   
             END IF
          END IF         
         END IF 
#---------FUN-C50097 ADD END---------                           
      ELSE

         CALL t600_app_sub_update(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                           l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)
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
                  CALL t600_app_sub_chk_ogb1001(l_ogb.ogb1001) RETURNING l_cnt2
                  IF l_cnt2 > 0 THEN 
                     #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                     #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                  ELSE 
#MOD-CB0050 add end--------------------------------- 
                     IF (g_prog[1,7] = 'axmt620' OR g_prog[1,7] = 'axmp230') AND l_oga.oga65='N' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00
                      #當走直接出貨時, #TQC-D10067 add g_prog[1,7] = 'axmp230' 
                     #更新發票倉庫存和產生tlf檔案
                        CALL t600_app_sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,   
                                             l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                        IF g_success='N' THEN 
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                     END IF 
                     IF g_prog[1,7] = 'axmt628' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00 
                     #更新發票倉庫存和產生tlf檔案,走出貨簽收時候,去掉簽退數量
                        #IF l_ogb.ogb52 > 0 THEN #有签退量                 l_ogb.ogb12  - l_ogb.ogb52
                        #   LET l_ogb.ogb12 = l_ogb.ogb12 - l_ogb.ogb52 #(签退量+签收量) -  簽退量
                        SELECT ogb12 INTO l_ogb12_t1 FROM ogb_file #出货单数量
                         WHERE ogb01 = l_oga.oga011
                           AND ogb03 = l_ogb.ogb03
                        SELECT ogb12 INTO l_ogb12_t2 FROM ogb_file #签收单数量
                         WHERE ogb01 = l_oga.oga01
                           AND ogb03 = l_ogb.ogb03 
                        IF cl_null(l_ogb12_t1) THEN LET  l_ogb12_t1 = 0 END IF 
                        IF cl_null(l_ogb12_t2) THEN LET  l_ogb12_t2 = 0 END IF  
                        IF l_ogb12_t1 - l_ogb12_t2 > 0 THEN  #出货量大于签收量
                           LET l_ogb.ogb12 = l_ogb12_t2                     
                           LET l_ogb.ogb16 = l_ogb.ogb12*l_ogb.ogb15_fac
                            IF g_sma.sma115 = 'Y' THEN 
                               SELECT ima906 INTO l_ima906 FROM ima_file
                                WHERE ima01=l_ogb.ogb04
                               IF l_ima906 = '2' THEN 
                                  LET l_ogb.ogb912 =  (l_ogb.ogb12  mod l_ogb.ogb914)/l_ogb.ogb911    #签收子单位数量
                                  LET l_ogb.ogb915 =  (l_ogb.ogb12   - l_ogb.ogb912*l_ogb.ogb911) / l_ogb.ogb914   #签收母单位数量                           
                               END IF 
                               IF l_ima906 = '3' THEN 
                                  IF NOT cl_null(l_ogb.ogb911) THEN 
                                     LET l_ogb.ogb912 = l_ogb.ogb12 / l_ogb.ogb911
                                  END IF 
                                  IF NOT cl_null(l_ogb.ogb914) THEN 
                                     LET l_ogb.ogb915 = l_ogb.ogb12 / l_ogb.ogb914
                                  END IF                  
                               END IF     
                            END IF
                           IF NOT cl_null(l_ogb.ogb916) THEN
                              CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb916)
                                   RETURNING l_cnt,l_factor
                              IF l_cnt = 1 THEN
                                 LET l_factor = 1               	  
                              END IF 
                              LET l_ogb.ogb917 = l_ogb.ogb12 * l_factor
                           END IF               
                        END IF
                        CALL t600_app_sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,   
                                             l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                        IF g_success='N' THEN 
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF                                          
                     END IF #axmt628 
                  END IF #MOD-CB0050 add    
               END IF   
            END IF            
         END IF 
         IF g_success = 'N' THEN
            LET g_totsuccess = "N"
            LET g_success = "Y"
            CONTINUE FOREACH
         END IF
        #END IF    #TQC-C50163 mark 
      #MOD-BB0051 ----- add end  -----
      END IF
      IF g_success='N' THEN RETURN l_oha.* END IF
      #更新已備置量 no.7182
     #FUN-AC0074--begin--modfiy----
     CALL s_updsie_sie(l_ogb.ogb01,l_ogb.ogb03,'2') 
     #SELECT oeb19,oeb905 INTO l_oeb19,l_oeb905 FROM oeb_file
     # WHERE oeb01=l_ogb.ogb31 AND oeb03=l_ogb.ogb32
     #IF l_oeb19 = 'Y' THEN
     #   IF l_oeb905 > l_ogb.ogb12 THEN
     #      LET l_oeb905= l_oeb905 - l_ogb.ogb12
     #   ELSE
     #      LET l_oeb905 = 0
     #   END IF
     #   UPDATE oeb_file SET oeb905 = l_oeb905
     #    WHERE oeb01 = l_ogb.ogb31
     #      AND oeb03 = l_ogb.ogb32
     #   IF STATUS THEN
     #      LET g_showmsg=l_ogb.ogb31,"/",l_ogb.ogb32               #No.FUN-710046
     #      CALL s_errmsg("obe01,obe03",g_showmsg,"UPD obe_file",SQLCA.sqlcode,1)  #No.FUN-710046
     #      LET g_success = 'N' DISPLAY "4"
     #      CONTINUE FOREACH         #No.FUN-710046
     #   END IF
     #END IF
     #FUN-AC0074--end--modify---
##處理境外倉庫存
      IF l_argv0='2' AND l_oga.oga00 MATCHES '[37]' THEN   #No.FUN-610064
        #CHI-AC0034 mark --start--
        #CALL t600_app_sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,     #No.TQC-6B0174
        #                  l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_oga.*,l_ogb.*)  #No.FUN-630061
        #IF g_success = 'N' THEN
        #   LET g_totsuccess="N"
        #   LET g_success="Y"
        #   CONTINUE FOREACH   #No.FUN-6C0083
        #END IF
        #CHI-AC0034 mark --end--
         #CHI-AC0034 add --start--
         LET l_flag='' 
         IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
           #DECLARE t600_s1_ogc_c2 CURSOR FOR  SELECT * FROM ogc_file
           #   WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
            DECLARE t600_s1_ogc_c2 CURSOR FOR  SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file #MOD-BA0009 add ogc092
               WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
               GROUP BY ogc17,ogc092 #MOD-BA0009 add ogc092
            FOREACH t600_s1_ogc_c2 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092 #MOD-BA0009 add ogc092
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
                  LET g_success='N' EXIT FOREACH
               END IF
              #LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
              #CALL cl_msg(l_msg)
               LET l_flag = 'X'
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_ogb.ogb04  AND img02= l_oga.oga910
                  AND img03= l_oga.oga911 AND img04= l_ogb.ogb092 
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
               LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
               LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
              #CALL t600_app_sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,  #MOD-BA0009 mark 
               CALL t600_app_sub_consign(l_oga.oga910,l_oga.oga911,l_ogc.ogc092,  #MOD-BA0009 
                             l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
               IF g_success='N' THEN  
                  LET g_totsuccess="N"
                  LET g_success="Y"
                  CONTINUE FOREACH
               END IF
               #MOD-BA0009 add --start--
               IF s_industry('icd') THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  IF l_cnt > 0 THEN
                     DECLARE t600sub_idb_c5 CURSOR FOR
                      SELECT * FROM idb_file
                       WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03 AND idb04 = l_ogc.ogc092
                     FOREACH t600sub_idb_c5 INTO l_idb.*
                        #出貨簽收單產生ida資料
                        IF NOT s_icdout_insicin(l_idb.*,l_oga.oga910,l_oga.oga911,l_ogc.ogc092) THEN
                           LET g_success='N'
                        END IF
                        IF g_success='N' THEN
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           EXIT FOREACH
                        END IF
                     END FOREACH
                  END IF
                  SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                    FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
                  CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga910,l_oga.oga911,
                       l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                       l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                       '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                       RETURNING l_flag
                  IF l_flag = 0 THEN
                     LET g_success = 'N'
                     RETURN l_oha.*
                  END IF
               END IF
               #MOD-BA0009 add --end--
            END FOREACH
         ELSE
            IF l_ogb.ogb17='Y' THEN 
               LET l_flag = 'Y'
            ELSE
               LET l_flag='' 
            END IF
            CALL t600_app_sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,   
                          l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)  
            IF g_success='N' THEN 
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
            #TQC-BA0136(S) 這段從下面移上來            
            IF s_industry('icd') THEN
               #MOD-CB0237 -- add start --
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               IF l_cnt > 0 THEN
                  DECLARE t600sub_idb_c51 CURSOR FOR
                   SELECT * FROM idb_file
                    WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                   FOREACH t600sub_idb_c51 INTO l_idb.*
                      #出貨簽收單產生ida資料
                      IF NOT s_icdout_insicin(l_idb.*,l_oga.oga910,l_oga.oga911,l_idb.idb04) THEN
                         LET g_success='N'
                      END IF
                      IF g_success='N' THEN
                         LET g_totsuccess="N"
                         LET g_success="Y"
                         EXIT FOREACH
                      END IF
                   END FOREACH
               END IF
               #MOD-CB0237 -- add end --
               SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                 FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
               CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga910,l_oga.oga911,
                    l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                    l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                    '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
                  RETURN l_oha.*
               END IF
            END IF
            #TQC-BA0136(E)
         END IF
         #CHI-AC0034 add --end--
      END IF
     #IF l_argv0 = '2' AND l_oga.oga65='Y'  THEN           #FUN-C40072 mark
      IF l_argv0 MATCHES '[2,4]' AND l_oga.oga65='Y'  THEN #FUN-C40072 add
        #CHI-AC0034 mark --start--
        #CALL t600_app_sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,     #No.TQC-6B0174
        #                  l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_oga.*,l_ogb.*)  #No.FUN-630061
        #IF g_success = 'N' THEN
        #   LET g_totsuccess="N"
        #   LET g_success="Y"
        #   CONTINUE FOREACH   #No.FUN-6C0083
        #END IF
        #CHI-AC0034 mark --end--
         #CHI-AC0034 add --start--
         LET l_flag='' 
         #No.MOD-C70145  --beg
         #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨 #No.MOD-C70145  --mark
         IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨 #No.MOD-C70145  --
         #No.MOD-C70145  --End          
           #DECLARE t600_s1_ogc_c3 CURSOR FOR  SELECT * FROM ogc_file
           #   WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
            DECLARE t600_s1_ogc_c3 CURSOR FOR  
#CHI-B60054  --Begin #去掉CHI-B30093更改
#CHI-B30093 --begin--             
             SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file   #TQC-BA0136 add ogc092
              WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
              GROUP BY ogc17,ogc092   #TQC-BA0136 add ogc092
            FOREACH t600_s1_ogc_c3 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  #TQC-BA0136 add ogc092
#             SELECT * FROM ogc_file
#              WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
#            FOREACH t600_s1_ogc_c3 INTO l_ogc_1.*
#CHI-B30093 --end--            
#CHI-B60054  --End #去掉CHI-B30093更改

               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
                  LET g_success='N' EXIT FOREACH
               END IF
              #LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
              #CALL cl_msg(l_msg)
               LET l_flag='X' 
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_ogb.ogb04  AND img02= l_oga.oga66
                  #AND img03= l_oga.oga67 AND img04= l_ogb.ogb092   #TQC-BA0136 mark
                  AND img03= l_oga.oga67 AND img04= l_ogc.ogc092  #TQC-BA0136 
#CHI-B60054  --Begin #去掉CHI-B30093更改
#CHI-B30093 --begin--            
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
               LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
               LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
               #CALL t600_app_sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,  #TQC-BA0136 mark 
               CALL t600_app_sub_consign(l_oga.oga66,l_oga.oga67,l_ogc.ogc092,   #TQC-BA0136   
                             l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
#               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc_1.ogc15_fac
#               LET l_ogc_1.ogc16=l_ogc_1.ogc12*l_ogc_1.ogc15_fac
#
#               CALL t600_app_sub_consign(l_oga.oga66,l_oga.oga67,l_ogc_1.ogc092,l_ogc_1.ogc12,
#                                    l_ogb.ogb05,l_ogc_1.ogc15_fac,l_ogc_1.ogc16,l_flag,
#                                    l_ogc_1.ogc17,l_oga.*,l_ogb.*)                              
#CHI-B30093 --end--                             
#CHI-B60054  --End #去掉CHI-B30093更改
               IF g_success='N' THEN  
                  LET g_totsuccess="N"
                  LET g_success="Y"
                  CONTINUE FOREACH
               END IF
               #FUN-B40066 --START--
               IF s_industry('icd') THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  IF l_cnt > 0 THEN
                     DECLARE t600sub_idb_c1 CURSOR FOR
                      SELECT * FROM idb_file
                       WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                         AND idb04 = l_ogc.ogc092  #TQC-BA0136
                     FOREACH t600sub_idb_c1 INTO l_idb.* 
                        #出貨簽收單產生ida資料
                        IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN   #TQC-BA0136 ogb092 -> l_idb.idb04
                           LET g_success='N'
                           EXIT FOREACH
                        END IF
                        IF g_success='N' THEN  
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           EXIT FOREACH
                        END IF
                     END FOREACH
                  END IF
                  SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                   FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
                  CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga66,l_oga.oga67,
                       l_ogc.ogc092,l_ogb.ogb05,l_ogc.ogc12,   #TQC-BA0136 ogb092 -> ogc092  l_ogb.ogb12 ->l_ogc.ogc12
                       l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                       '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                       RETURNING l_flag
                  IF l_flag = 0 THEN
                     LET g_success = 'N'                     
                     RETURN l_oha.*
                  END IF
               END IF    
               #FUN-B40066 --END--
            END FOREACH
         ELSE
            IF l_ogb.ogb17='Y' THEN 
               LET l_flag = 'Y'
#CHI-B60054  --Begin #去掉CHI-B30093更改
#CHI-B30093 --begin--      
#               DECLARE t600_ogc_tlf CURSOR FOR  
#                SELECT * FROM ogc_file
#                 WHERE ogc01=l_oga.oga01 
#                   AND ogc03=l_ogb.ogb03
#               FOREACH t600_ogc_tlf INTO l_ogc_1.*             
#                  CALL t600_app_sub_consign(l_oga.oga66,l_oga.oga67,l_ogc_1.ogc092,l_ogc_1.ogc12, 
#                                      l_ogb.ogb05,l_ogc_1.ogc15_fac,l_ogc_1.ogc16,   
#                                      l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)                 
#                 IF g_success = 'N' THEN 
#                   EXIT FOREACH 
#                 END IF                      
#               END FOREACH                          
#CHI-B30093 --end--                   
#CHI-B60054  --End #去掉CHI-B30093更改
            ELSE
               LET l_flag=''                
            END IF               #CHI-B30093  #CHI-B60054 去掉CHI-B30093 mark
            CALL t600_app_sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,   
                          l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)  
            #END IF               #CHI-B30093 #CHI-B60054 mark CHI-B30093
            IF g_success='N' THEN 
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH
            END IF
            #FUN-B40066 --START--
               IF s_industry('icd') THEN
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM idb_file
                   WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  IF l_cnt > 0 THEN
                     DECLARE t600sub_idb_c2 CURSOR FOR
                      SELECT * FROM idb_file
                       WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                     FOREACH t600sub_idb_c2 INTO l_idb.* 
                        #出貨簽收單產生ida資料
                        #IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_ogb.ogb092) THEN   #FUN-C30289 
                        IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN    #FUN-C30289
                           LET g_success='N'
                           EXIT FOREACH
                        END IF
                        IF g_success='N' THEN  
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           EXIT FOREACH
                        END IF
                     END FOREACH
                  END IF
                  SELECT ogbiicd028,ogbiicd029 INTO l_ogbi.ogbiicd02,l_ogbi.ogbiicd029
                   FROM ogbi_file WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03
                  IF l_ogb.ogb17='N' THEN  #FUN-C30289
                     CALL s_icdpost(1,l_ogb.ogb04,l_oga.oga66,l_oga.oga67,
                          l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                          l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                          '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                          RETURNING l_flag
                  #FUN-C30289---begin
                  ELSE
                     DECLARE t600_ogc_icdpost CURSOR FOR
                      SELECT * FROM ogc_file WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
                     FOREACH t600_ogc_icdpost INTO l_ogc_1.*
                        CALL s_icdpost(1,l_ogc_1.ogc17,l_oga.oga66,l_oga.oga67,
                             l_ogc_1.ogc092,l_ogc_1.ogc15,l_ogc_1.ogc12,
                             l_oga.oga01,l_ogc_1.ogc03,l_oga.oga02,'Y',
                             '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') 
                        RETURNING l_flag
                     END FOREACH 
                  END IF 
                  #FUN-C30289---end
                  IF l_flag = 0 THEN
                     LET g_success = 'N'                     
                     RETURN l_oha.*
                  END IF
               END IF    
               #FUN-B40066 --END--
         END IF
         #CHI-AC0034 add --end--
      END IF
      SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=l_oga.oga03   #No.TQC-640123
      IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
      IF l_oga.oga00 ='7' THEN LET l_occ31='Y' END IF   #FUN-690083 add
       IF l_occ31 = 'N' THEN CONTINUE FOREACH END IF  #NO.MOD-4B0070
      SELECT ima25,ima71 INTO l_ima25,l_ima71
        FROM ima_file WHERE ima01=l_ogb.ogb04
      IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
      #MOD-B30651 add --start--
      IF l_ima71 = 0 THEN 
         LET l_tup06 = g_lastdat
      ELSE 
         LET l_tup06 = l_oga.oga02 + l_ima71
      END IF
      #MOD-B30651 add --end--
      #如為7.寄銷出貨，且客戶主檔中的客戶庫存管理flag(occ31)為Y時,
      #自動寫入客戶庫存記錄檔
      IF l_oga.oga00 ='7' THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tuq_file
       WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04              #No.TQC-640123
         AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
         AND tuq11 ='2'
         AND tuq12 =l_oga.oga04
         AND tuq05 = l_oga.oga01  #MOD-7A0084
         AND tuq051= l_ogb.ogb03  #MOD-7A0084
      IF l_cnt=0 THEN
         LET l_fac1=1
         IF l_ogb.ogb05 <> l_ima25 THEN
            CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0) #No.FUN-710046
               LET l_fac1=1
            END IF
         END IF
       #FUN-910088--add--start--
         LET l_tuq09_1 = l_ogb.ogb12*l_fac1
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051, #MOD-7A0084 modify tuq051
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)  #FUN-980010 add plant & legal 
         VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_oga.oga02,l_oga.oga01,l_ogb.ogb03,   #No.TQC-640123  #MOD-7A0084
             #  l_ogb.ogb05,l_ogb.ogb12,l_fac1,l_ogb.ogb12*l_fac1,'1','2',l_oga.oga04,      #FUN-910088--mark--
                l_ogb.ogb05,l_ogb.ogb12,l_fac1,l_tuq09_1,'1','2',l_oga.oga04,               #FUN-910088--add--
                g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
            CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"INS tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success ='N'
            DISPLAY "5"
            CONTINUE FOREACH       #No.FUN-710046
         END IF
      ELSE
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
          WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04           #No.TQC-640123
            AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
            AND tuq11 ='2'
            AND tuq12 =l_oga.oga04
            AND tuq05 = l_oga.oga01  #MOD-7A0084
            AND tuq051= l_ogb.ogb03  #MOD-7A0084
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
            CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"SEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success ='N'
            DISPLAY "6"
            CONTINUE FOREACH       #No.FUN-710046
         END IF
         LET l_fac1=1
         IF l_ogb.ogb05 <> l_tuq06 THEN
            CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_tuq06)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)   #No.FUN-710046
               LET l_fac1=1
            END IF
         END IF
         SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04    #No.TQC-640123
            AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
            AND tuq11 ='2'
            AND tuq12 =l_oga.oga04
            AND tuq05 = l_oga.oga01  #MOD-7A0084
            AND tuq051= l_ogb.ogb03  #MOD-7A0084
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
         IF l_tuq07+l_ogb.ogb12*l_fac1<0 THEN
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07+l_ogb.ogb12*l_fac1=0 THEN
            DELETE FROM tuq_file
             WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04          #No.TQC-640123
               AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
               AND tuq11 ='2'
               AND tuq12 =l_oga.oga04
               AND tuq05 = l_oga.oga01  #MOD-7A0084
               AND tuq051= l_ogb.ogb03  #MOD-7A0084
            IF SQLCA.sqlcode THEN
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"DEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success='N'
               DISPLAY "7"
               CONTINUE FOREACH    #No.FUN-710046
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN
               CALL s_umfchk(l_ogb.ogb04,l_tuq06,l_ima25)
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(l_ogb.ogb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
         #FUN-910088--add--start--
           LET l_tuq07_1 = l_ogb.ogb12*l_fac1
           LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
           LET l_tuq09_1 = l_ogb.ogb12*l_fac1*l_fac2
           LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
           UPDATE tuq_file SET tuq07=tuq07+l_tuq07_1,              
                                tuq09=tuq09+l_tuq09_1,                
         #FUN-910088--add--end--
         #FUN-910088--mark--start--
         #  UPDATE tuq_file SET tuq07=tuq07+l_ogb.ogb12*l_fac1,
         #                      tuq09=tuq09+l_ogb.ogb12*l_fac1*l_fac2,
         #FUN-910088--mark--end--
                                tuq10=l_desc
             WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04    #No.TQC-640123
               AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
               AND tuq11 ='2'
               AND tuq12 =l_oga.oga04
               AND tuq05 = l_oga.oga01  #MOD-7A0084
               AND tuq051= l_ogb.ogb03  #MOD-7A0084
            IF SQLCA.sqlcode THEN
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"UPD tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success='N'
               DISPLAY "8"
               CONTINUE FOREACH         #No.FUN-710046
            END IF
         END IF
      END IF
      ELSE
         IF l_oga.oga00='6' THEN CONTINUE FOREACH END IF   #TQC-7A0114 add  #No.TQC-7C0114
         IF l_oga.oga09='8' THEN CONTINUE FOREACH END IF   #TQC-7A0114 add  #No.TQC-7C0114
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM tuq_file
          WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04              #No.TQC-640123
            AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
            AND tuq11 ='1'
            AND tuq12 =l_oga.oga04
            AND tuq05 = l_oga.oga01  #MOD-7A0084
            AND tuq051= l_ogb.ogb03  #MOD-7A0084
         IF l_cnt=0 THEN
            LET l_fac1=1
            IF l_ogb.ogb05 <> l_ima25 THEN
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25)
                    RETURNING l_cnt,l_fac1
               IF l_cnt = '1'  THEN
                  CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)         #No.FUN-710046
                  LET l_fac1=1
               END IF
            END IF
          #FUN-910088--add--start--
            LET l_tuq09_1 = l_ogb.ogb12*l_fac1
            LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          #FUN-910088--add--end--
            INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,   #MOD-7A0084 modify tuq051
                                 tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                                 tuqplant,tuqlegal)  #FUN-980010 add plant & legal  
            VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_oga.oga02,l_oga.oga01,l_ogb.ogb03,   #No.TQC-640123  #MOD-7A0084 modify
               #   l_ogb.ogb05,l_ogb.ogb12,l_fac1,l_ogb.ogb12*l_fac1,'1','1',l_oga.oga04,      #FUN-910088--mark--
                   l_ogb.ogb05,l_ogb.ogb12,l_fac1,l_tuq09_1,'1','1',l_oga.oga04,               #FUN-910088--add--
                   g_plant, g_legal) 
            IF SQLCA.sqlcode THEN
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"INS tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success ='N'
               DISPLAY "5"
               CONTINUE FOREACH     #No.FUN-710046
            END IF
         ELSE
            SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
             WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04           #No.TQC-640123
               AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
               AND tuq11 ='1'
               AND tuq12 =l_oga.oga04
               AND tuq05 = l_oga.oga01  #MOD-7A0084
               AND tuq051= l_ogb.ogb03  #MOD-7A0084
            #&],0key-H*:-l&],&P$@KEY-H*:%u/`+O/d$@-S-l)l3f&l
            IF SQLCA.sqlcode THEN
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"SEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success ='N'
               DISPLAY "6"
               CONTINUE FOREACH    #No.FUN-710046
            END IF
            LET l_fac1=1
            IF l_ogb.ogb05 <> l_tuq06 THEN
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_tuq06)
                    RETURNING l_cnt,l_fac1
               IF l_cnt = '1'  THEN
                  CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0) #No.FUN-710046
                  LET l_fac1=1
               END IF
            END IF
            SELECT tuq07 INTO l_tuq07 FROM tuq_file
             WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04    #No.TQC-640123
               AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
               AND tuq11 ='1'
               AND tuq12 =l_oga.oga04
               AND tuq05 = l_oga.oga01  #MOD-7A0084
               AND tuq051= l_ogb.ogb03  #MOD-7A0084
            IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
            IF l_tuq07+l_ogb.ogb12*l_fac1<0 THEN
               LET l_desc='2'
            ELSE
               LET l_desc='1'
            END IF
            IF l_tuq07+l_ogb.ogb12*l_fac1=0 THEN
               DELETE FROM tuq_file
                WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04          #No.TQC-640123
                  AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
                  AND tuq11 ='1'
                  AND tuq12 =l_oga.oga04
                  AND tuq05 = l_oga.oga01  #MOD-7A0084
                  AND tuq051= l_ogb.ogb03  #MOD-7A0084
               IF SQLCA.sqlcode THEN
                  LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
                  CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"DEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success='N'
                  DISPLAY "7"
                  CONTINUE FOREACH    #No.FUN-710046
               END IF
            ELSE
               LET l_fac2=1
               IF l_tuq06 <> l_ima25 THEN
                  CALL s_umfchk(l_ogb.ogb04,l_tuq06,l_ima25)
                       RETURNING l_cnt,l_fac2
                  IF l_cnt = '1'  THEN
                     CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)  #No.FUN-710046
                     LET l_fac2=1
                  END IF
               END IF
            #FUN-910088--add--start--
               LET l_tuq07_1 = l_ogb.ogb12*l_fac1
               LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
               LET l_tuq09_1 = l_ogb.ogb12*l_fac1*l_fac2
               LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
               UPDATE tuq_file SET tuq07=tuq07+l_tuq07_1,
                                   tuq09=tuq09+l_tuq09_1,
            #FUN-910088--add--end--
            #FUN-910088--mark--start
            #  UPDATE tuq_file SET tuq07=tuq07+l_ogb.ogb12*l_fac1,
            #                      tuq09=tuq09+l_ogb.ogb12*l_fac1*l_fac2,
            #FUN-910088--mark--end--
                                   tuq10=l_desc
                WHERE tuq01=l_oga.oga03  AND tuq02=l_ogb.ogb04    #No.TQC-640123
                  AND tuq03=l_ogb.ogb092 AND tuq04=l_oga.oga02
                  AND tuq11 ='1'
                  AND tuq12 =l_oga.oga04
                  AND tuq05 = l_oga.oga01  #MOD-7A0084
                  AND tuq051= l_ogb.ogb03  #MOD-7A0084
               IF SQLCA.sqlcode THEN
                  LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
                  CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"UPD tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success='N'
                  DISPLAY "8"
                  CONTINUE FOREACH         #No.FUN-710046
               END IF
            END IF
         END IF
      END IF
      LET l_fac1=1
      IF l_ogb.ogb05 <> l_ima25 THEN
         CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ima25)
              RETURNING l_cnt,l_fac1
         IF l_cnt = '1'  THEN
            CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)   #No.FUN-710046
            LET l_fac1=1
         END IF
      END IF
      IF l_oga.oga00 = '7' THEN
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM tup_file
          WHERE tup01=l_oga.oga03  AND tup02=l_ogb.ogb04      #No.TQC-640123
            AND tup03=l_ogb.ogb092
           #AND ((tup08='2' AND tup09=l_oga.oga04) OR   #FUN-690083 modify #CHI-B40056 mark
           #     (tup11='2' AND tup12=l_oga.oga04))     #FUN-690083 modify #CHI-B40056 mark
            AND tup11='2' AND tup12=l_oga.oga04                            #CHI-B40056
      IF cl_null(l_ogb.ogb092) THEN LET l_ogb.ogb092=' '  END IF  #FUN-790001 add
   #FUN-910088--add--start--
      LET l_tup05_1 = l_ogb.ogb12*l_fac1
      LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
   #FUN-910088--add--end--
      IF l_cnt=0 THEN
        #INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12, #CHI-B40056 mark
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup11,tup12,             #CHI-B40056
                              tupplant,tuplegal)  #FUN-980010 add plant & legal   #MOD-9C0330  
         VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_ima25,   #No.TQC-640123
               #l_ogb.ogb12*l_fac1,l_ima71+l_oga.oga02,l_oga.oga02,'2',l_oga.oga04,'2',l_oga.oga04, #MOD-B30651 mark
               #l_ogb.ogb12*l_fac1,l_tup06,l_oga.oga02,'2',l_oga.oga04,'2',l_oga.oga04,             #MOD-B30651    #FUN-910088--mark--
               #l_tup05_1,l_tup06,l_oga.oga02,'2',l_oga.oga04,'2',l_oga.oga04,                      #FUN-910088--add-- #CHI-B40056 mark
                l_tup05_1,l_tup06,l_oga.oga02,'2',l_oga.oga04,                      #FUN-910088--add--                 #CHI-B40056
                g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092               #No.FUN-710046
            CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            DISPLAY "9"
            CONTINUE FOREACH  #No.FUN-710046
         END IF
      ELSE
      #  UPDATE tup_file SET tup05=tup05+l_ogb.ogb12*l_fac1         #FUN-910088--mark--
         UPDATE tup_file SET tup05=tup05+l_tup05_1                  #FUN-910088--add--
          WHERE tup01=l_oga.oga03  AND tup02=l_ogb.ogb04          #No.TQC-640123
            AND tup03=l_ogb.ogb092
           #AND ((tup08='2' AND tup09=l_oga.oga04) OR   #FUN-690083 modify #CHI-B40056 mark
           #     (tup11='2' AND tup12=l_oga.oga04))     #FUN-690083 modify #CHI-B40056 mark
            AND tup11='2' AND tup12=l_oga.oga04                            #CHI-B40056
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092               #No.FUN-710046
            CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            DISPLAY "10"
            CONTINUE FOREACH        #No.FUN-710046
         END IF
      END IF
      ELSE
         IF l_oga.oga00='6' THEN CONTINUE FOREACH END IF   #No.TQC-7C0114
         IF l_oga.oga09='8' THEN CONTINUE FOREACH END IF     #No.TQC-7C0114
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM tup_file
          WHERE tup01=l_oga.oga03  AND tup02=l_ogb.ogb04      #No.TQC-640123
            AND tup03=l_ogb.ogb092
           #AND ((tup08='1' AND tup09=l_oga.oga04) OR   #FUN-690083 modify #CHI-B40056 mark
           #     (tup11='1' AND tup12=l_oga.oga04))     #FUN-690083 modify #CHI-B40056 mark
            AND tup11='1' AND tup12=l_oga.oga04                            #CHI-B40056
      IF cl_null(l_ogb.ogb092) THEN LET l_ogb.ogb092=' ' END IF  #FUN-790001 add
     #FUN-910088--add--start--
      LET l_tup05_1 = l_ogb.ogb12*l_fac1
      LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
     #FUN-910088--add--end--
      IF l_cnt=0 THEN
        #INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12, #CHI-B40056 mark
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup11,tup12,             #CHI-B40056
                              tupplant,tuplegal)  #FUN-980010 add plant & legal     #MOD-9C0330
         VALUES(l_oga.oga03,l_ogb.ogb04,l_ogb.ogb092,l_ima25,   #No.TQC-640123
               #l_ogb.ogb12*l_fac1,l_ima71+l_oga.oga02,l_oga.oga02,'1',l_oga.oga04,'1',l_oga.oga04, #MOD-B30651 mark
               #l_ogb.ogb12*l_fac1,l_tup06,l_oga.oga02,'1',l_oga.oga04,'1',l_oga.oga04,             #MOD-B30651   #FUN-910088--mark---
               #l_tup05_1,l_tup06,l_oga.oga02,'1',l_oga.oga04,'1',l_oga.oga04,                      #FUN-910088--add--end-- #CHI-B40056 mark
                l_tup05_1,l_tup06,l_oga.oga02,'1',l_oga.oga04,                      #FUN-910088--add--end--                 #CHI-B40056
                g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            CALL s_errmsg("tup01",l_oga.oga03,"INS tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            DISPLAY "9"
            CONTINUE FOREACH                #No.FUN-710046
         END IF
      ELSE
     #   UPDATE tup_file SET tup05=tup05+l_ogb.ogb12*l_fac1        #FUN-910088--mark---
         UPDATE tup_file SET tup05=tup05+l_tup05_1                 #FUN-910088--add--end--
          WHERE tup01=l_oga.oga03  AND tup02=l_ogb.ogb04          #No.TQC-640123
            AND tup03=l_ogb.ogb092
           #AND ((tup08='1' AND tup09=l_oga.oga04) OR   #FUN-690083 modify #CHI-B40056 mark
           #     (tup11='1' AND tup12=l_oga.oga04))     #FUN-690083 modify #CHI-B40056 mark
            AND tup11='1' AND tup12=l_oga.oga04                            #CHI-B40056
         IF SQLCA.sqlcode THEN
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092               #No.FUN-710046
            CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            DISPLAY "10"
            CONTINUE FOREACH       #No.FUN-710046
         END IF
      END IF
      END IF
      IF g_success='N' THEN RETURN l_oha.* END IF
  END FOREACH
  IF g_success='N' THEN
     RETURN l_oha.*
  END IF
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
  RETURN l_oha.*  #FUN-730012
END FUNCTION
	
FUNCTION t600_app_ins_lsn(l_oga)
DEFINE l_oga    RECORD LIKE oga_file.*
DEFINE l_n      LIKE type_file.num5
DEFINE l_ogb14t LIKE ogb_file.ogb14t
DEFINE l_money  LIKE type_file.num20_6
DEFINE l_lsn07  LIKE lsn_file.lsn07

   SELECT COUNT(*) INTO l_n FROM ogb_file
    WHERE ogb01 = l_oga.oga01 AND ogb04= 'MISCCARD'
      AND ogb1001 = g_oaz.oaz88
      AND (ogb31 = ' ' OR ogb31 IS NULL)      #TQC-C30097 add
   IF l_n >0 THEN
     SELECT SUM(ogb14t) INTO l_ogb14t FROM ogb_file 
      WHERE ogb01 = l_oga.oga01 AND ogb04= 'MISCCARD'
        AND (ogb31 = ' ' OR ogb31 IS NULL)      #TQC-C30097 add
     SELECT SUM(ogb47+ogb14t) INTO l_money FROM ogb_file 
      WHERE ogb01 = l_oga.oga01 AND ogb04= 'MISCCARD'
        AND (ogb31 = ' ' OR ogb31 IS NULL)      #TQC-C30097 add
     UPDATE lpj_file SET lpj06 = lpj06 + l_money,
                         lpjpos = '2'             #FUN-D30007 add
      WHERE lpj03 = l_oga.oga87
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","lpj_file",'',"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N'
        RETURN
     END IF

     IF g_success = 'Y' THEN
        LET l_lsn07 = l_ogb14t/(l_money*100)
       #INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,lsnplant,lsnlegal,lsn10)                   #FUN-C70045 add lsn10  #FUN-C90102 mark 
        INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn07,lsnstore,lsnlegal,lsn10)                   #FUN-C90102 add
         VALUES (l_oga.oga87,'F',l_oga.oga01,l_money,g_today,l_lsn07,l_oga.ogaplant,l_oga.ogalegal,'1')      #FUN-C70045 add '1'
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lsn_file",'',"",SQLCA.sqlcode,"","",1)  
           LET g_success = 'N'
           RETURN
        END IF
     END IF
   END IF 

END FUNCTION

FUNCTION t600_app_sub_chk_ogb1001(p_ogb1001)
DEFINE p_ogb1001 LIKE ogb_file.ogb1001,
       l_cnt2    LIKE type_file.num5

   SELECT COUNT(*) INTO l_cnt2 FROM azf_file 
    WHERE azf01=p_ogb1001
    AND azf02 = '2' 
    AND azf08 = 'Y'   
    AND azfacti = 'Y' 
   RETURN l_cnt2
   
END FUNCTION 

FUNCTION t600_app_sub_consign(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_item,l_oga,l_ogb)  #CHI-AC0034
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
         l_cnt    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
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
#   DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_avl_stk  LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
   DEFINE l_ima71   LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_ima86   LIKE ima_file.ima86  #FUN-730018
   DEFINE l_oga   RECORD LIKE oga_file.*
   DEFINE p_flag    LIKE type_file.chr1   #CHI-AC0034 add
   DEFINE p_item    LIKE ogc_file.ogc17   #CHI-AC0034 add
   DEFINE l_msg   STRING                 #MOD-C50020
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF

    SELECT * INTO p_img.* FROM img_file
    #WHERE img01= l_ogb.ogb04 AND img02= p_ware  #No.FUN-630061 #CHI-AC0034 mark
     WHERE img01= p_item AND img02= p_ware  #CHI-AC0034
       AND img03= p_loca AND img04= p_lot
    IF STATUS <> 0 THEN            ## 新增一筆img_file
       INITIALIZE p_img.* TO NULL
      #LET p_img.img01=l_ogb.ogb04   #No.FUN-630061 #CHI-AC0034 mark
       LET p_img.img01=p_item        #CHI-AC0034
       LET p_img.img02=p_ware
       LET p_img.img03=p_loca
       LET p_img.img04=p_lot
       LET p_img.img05=l_ogb.ogb01  #No.FUN-630061
       LET p_img.img06=l_ogb.ogb03  #No.FUN-630061
       SELECT ima25 INTO p_img.img09 FROM ima_file WHERE ima01=p_img.img01
       LET p_img.img10=0
       LET p_img.img13=null   #No:7304
       LET p_img.img17=g_today
       IF g_prog[1,7] = 'axmt628' THEN #MOD-CA0048 add
          LET p_img.img18=MDY(12,31,9999)
       #MOD-CA0048 add start -----
       ELSE
          SELECT img18 INTO p_img.img18 FROM img_file
           WHERE img01 = l_ogb.ogb01 AND img02 = l_ogb.ogb09
             AND img03 = l_ogb.ogb091 AND img04 = l_ogb.ogb092
          IF STATUS THEN
             LET p_img.img18=MDY(12,31,9999)
          END IF
       END IF
       #MOD-CA0048 add end   -----
       LET p_img.img21=1
       LET p_img.img22='S'
       LET p_img.img37=l_oga.oga02   #MOD-9B0077
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
          CALL cl_err3("ins","img_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
          LET g_success='N' RETURN
       END IF
    END IF
   #CALL s_umfchk(l_ogb.ogb04,p_uom,p_img.img09) RETURNING l_cnt,l_factor  #No.FUN-630061 #CHI-AC0034 mark
    CALL s_umfchk(p_item,p_uom,p_img.img09) RETURNING l_cnt,l_factor  #CHI-AC0034
    IF l_cnt = 1 THEN
       CALL cl_err('','mfg3075',0)
      #MOD-C50020---S---
       CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
       LET l_msg = l_msg CLIPPED,":",p_item
       CALL cl_err(l_msg,'mfg3075',0)   #MOD-C50020 add l_msg
      #MOD-C50020---E---
       LET g_success='N' RETURN
    END IF
    LET l_qty2=p_qty*l_factor
 
    LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ",
                       " FROM img_file ",
                       "  WHERE img01= ?  AND img02= ? AND img03= ? ",
                       " AND img04= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock1 CURSOR FROM g_forupd_sql
 
   #OPEN img_lock1 USING l_ogb.ogb04,p_ware,p_loca,p_lot  #No.FUN-630061 #CHI-AC0034 mark
    OPEN img_lock1 USING p_item,p_ware,p_loca,p_lot  #CHI-AC0034
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock1      #No.MOD-8A0208 add
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH img_lock1 INTO l_img.*
    IF STATUS THEN
       CLOSE img_lock1    #TQC-930155 add
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
 
   #CALL s_upimg(l_ogb.ogb04,p_ware,p_loca,p_lot,1,l_qty2,g_today, #FUN-8C0084 #CHI-AC0034 mark
    CALL s_upimg(p_item,p_ware,p_loca,p_lot,1,l_qty2,g_today, #CHI-AC0034
          '','','','',l_ogb.ogb01,l_ogb.ogb03,'','','','','','','','','','','','')  #No.FUN-850100
    IF g_success='N' THEN
       CALL cl_err('s_upimg()',SQLCA.SQLCODE,1) RETURN
    END IF

    #Update ima_file
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock1 CURSOR FROM g_forupd_sql
 
   #OPEN ima_lock1 USING l_ogb.ogb04  #No.FUN-630061 #CHI-AC0034 mark
    OPEN ima_lock1 USING p_item  #CHI-AC0034
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       CLOSE ima_lock1
       LET g_success='N'
       RETURN
    END IF
 
    FETCH ima_lock1 INTO l_ima25,l_ima86 #FUN-730018
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       CLOSE ima_lock1
       LET g_success='N'
       RETURN
    END IF
 
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   #Call s_udima(l_ogb.ogb04,l_img.img23,l_img.img24,l_qty2*l_img.img21,  #No.FUN-630061 #CHI-AC0034 mark
    Call s_udima(p_item,l_img.img23,l_img.img24,l_qty2*l_img.img21,  #CHI-AC0034
                 #g_today,1)  RETURNING l_cnt   #MOD-920298
                 l_oga.oga02,1)  RETURNING l_cnt   #MOD-920298
 
   #最近一次發料日期 表發料
    IF l_cnt THEN
       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
       LET g_success='N' RETURN
    END IF
 
    IF g_success='Y' THEN
       CALL t600_app_sub_contlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty2,p_uom,l_factor,p_flag,p_item,l_oga.*,l_ogb.*,l_ima86)  #CHI-AC0034
    END IF
 
END FUNCTION

FUNCTION t600_app_sub_contlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag,p_item,l_oga,l_ogb,l_ima86)    #CHI-AC0034
   DEFINE
      p_ware     LIKE ogb_file.ogb09,       ##倉庫
      l_ogb      RECORD LIKE ogb_file.*,    #No.FUN-630061
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
      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      l_cnt      LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE l_argv0 LIKE ogb_file.ogb09
   DEFINE l_ima86 LIKE ima_file.ima86 #FUN-730018
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE p_item LIKE img_file.img01 #CHI-AC0034 add
   DEFINE p_flag LIKE type_file.chr1 #CHI-AC0034 add
   
   LET l_argv0=l_oga.oga09  #FUN-730012
   #----來源----
  #LET g_tlf.tlf01=l_ogb.ogb04         #異動料件編號  #No.FUN-630061 #CHI-AC0034 mark
   LET g_tlf.tlf01=p_item              #異動料件編號  #CHI-AC0034
   LET g_tlf.tlf02=724
   LET g_tlf.tlf020=' '
   LET g_tlf.tlf021=' '                #倉庫
   LET g_tlf.tlf022=' '                #儲位
   LET g_tlf.tlf023=' '                #批號
   LET g_tlf.tlf024=' '                #異動後庫存數量
   LET g_tlf.tlf025=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_ogb.ogb31        #出貨單號  #No.FUN-630061
   LET g_tlf.tlf027=l_ogb.ogb32        #出貨項次   #No.FUN-630061
   #---目的----
   LET g_tlf.tlf03=50                  #'Stock'
   LET g_tlf.tlf030=l_ogb.ogb08  #No.FUN-630061
   LET g_tlf.tlf031=p_ware             #倉庫
   LET g_tlf.tlf032=p_loca             #儲位
   LET g_tlf.tlf033=p_lot              #批號
   #LET g_tlf.tlf904 = p_lot             #CHI-B30093 #CHI-B60054 mark CHI-B30093
   LET g_tlf.tlf034=p_img10            #異動後數量
   LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_ogb.ogb01        #訂單單號  #No.FUN-630061
   LET g_tlf.tlf037=l_ogb.ogb03        #訂單項次   #No.FUN-630061
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oga.oga02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom	    #發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   IF cl_null(l_ogb.ogb31) THEN     #FUN-BB0167 add
      LET g_tlf.tlf13='axmt650'     #FUN-BB0167 add
   ELSE                             #FUN-BB0167 add
#MOD-D20054---begin mark
#   #FUN-C40072---add---START
#      IF l_argv0 = '4' THEN
#         LET g_tlf.tlf13='axmt820'
#      ELSE
#   #FUN-C40072---add-----END
#MOD-D20054---end
         LET g_tlf.tlf13='axmt620'
#      END IF #FUN-C40072 add  #MOD-D20054
   END IF                           #FUN-BB0167 add
   LET g_tlf.tlf14=l_ogb.ogb1001    #異動原因   #MOD-870120
 
   LET g_tlf.tlf17='To Consign Warehouse'
  #IF l_argv0 = '2' AND l_oga.oga65 = 'Y' THEN #FUN-730012 #FUN-C40072 mark
   IF l_argv0 MATCHES '[2,4]' AND l_oga.oga65 = 'Y' THEN   #FUN-C40072 add
      LET g_tlf.tlf17='To On-Check Warehouse'
   END IF
   CALL s_imaQOH(l_ogb.ogb04)  #No.FUN-630061
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oga.oga03 #No.MOD-870252
   LET g_tlf.tlf20 = l_oga.oga46
   LET g_tlf.tlf61= l_ima86 #FUN-730018
   LET g_tlf.tlf62=l_ogb.ogb31    #參考單號(訂單)     #No.FUN-630061
   LET g_tlf.tlf63=l_ogb.ogb32    #訂單項次  #No.FUN-630061
   LET g_tlf.tlf64=l_ogb.ogb908   #手冊編號 no.A050  #No.FUN-630061
   LET g_tlf.tlf66=p_flag         #CHI-AC0034 add 
   LET g_tlf.tlf930=l_ogb.ogb930 #FUN-670063
   LET g_tlf.tlf20 = l_ogb.ogb41
   LET g_tlf.tlf41 = l_ogb.ogb42
   LET g_tlf.tlf42 = l_ogb.ogb43
   LET g_tlf.tlf43 = l_ogb.ogb1001

   IF g_prog[1,7] = 'axmt628' THEN   #FUN-B40066 add [1,7]
      #FUN-C50097 ADD BEG-------
      #产生发票仓tlf档案
      IF l_argv0 = '8' AND g_aza.aza26 = '2' THEN
         IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN
            LET g_tlf.tlf13='axmt628'
            LET g_tlf.tlf17='To Invoices Warehouse'
            LET g_tlf.tlf62=''    #參考單號(出貨簽收單) 
            LET g_tlf.tlf63=''    #出貨簽收單項次  
            LET g_tlf.tlf021= g_oaz.oaz95   #发票仓  
         END IF 
      END IF       
      #FUN-C50097 ADD END-------
      #LET g_prog = 'axmt629'  #FUN-B40066 mark
      #FUN-B40066 --START-- 
      IF s_industry('icd') THEN 
         LET g_prog = 'axmt629_icd'
      ELSE 
      LET g_prog = 'axmt629'
      END if 
      #FUN-B40066 --END--
      CALL s_tlf(1,0)
      #LET g_prog = 'axmt628'  #FUN-B40066 mark
      #FUN-B40066 --START-- 
      IF s_industry('icd') THEN 
         LET g_prog = 'axmt628_icd'
      ELSE 
      LET g_prog = 'axmt628'
      END if 
      #FUN-B40066 --END--      
   ELSE
      CALL s_tlf(1,0)
   END IF

END FUNCTION

FUNCTION t600_app_sub_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_item,l_oga,l_ogb) #No:8741  #FUN-5C0075 #FUN-730012
  DEFINE l_oeb19   LIKE oeb_file.oeb19
#  DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_avl_stk  LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_oeb12   LIKE oeb_file.oeb12
  DEFINE l_qoh     LIKE oeb_file.oeb12
  DEFINE p_flag    LIKE type_file.chr1                      #No:8741  #No.FUN-680137 VARCHAR(1)
  DEFINE p_ware    LIKE ogb_file.ogb09,       ##倉庫
         p_loca    LIKE ogb_file.ogb091,      ##儲位
         p_lot     LIKE ogb_file.ogb092,      ##批號
         p_qty     LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
         p_qty2    LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         p_uom     LIKE ima_file.ima31,       ##銷售單位
         p_factor  LIKE ogb_file.ogb15_fac,   ##轉換率
         p_item    LIKE ogc_file.ogc17,       #FUN-5C0075
         l_qty     LIKE ogc_file.ogc12,       ##異動後數量
         l_ima01   LIKE ima_file.ima01,
         l_ima25   LIKE ima_file.ima25,
         l_img     RECORD
                   img10   LIKE img_file.img10,
                   img16   LIKE img_file.img16,
                   img23   LIKE img_file.img23,
                   img24   LIKE img_file.img24,
                   img09   LIKE img_file.img09,
                   img18   LIKE img_file.img18,  #No.MOD-480401
                   img21   LIKE img_file.img21
                   END RECORD,
         l_cnt     LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_oga     RECORD LIKE oga_file.*,
         l_ogb     RECORD LIKE ogb_file.*
  DEFINE l_ima86   LIKE ima_file.ima86 #FUN-730018
  DEFINE l_msg     LIKE type_file.chr1000
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF
#FUN-AB0011 -------------------------STA
 #  聯營及非企業料號不異動 img 及 tlf
    IF s_joint_venture( p_item,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN
       RETURN
    END IF
#FUN-AB0011 -------------------------END
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','axm-186',1) LET g_success = 'N' RETURN
    END IF
 
    LET g_forupd_sql ="SELECT img10,img16,img23,img24,img09,img18,img21 ", #No.MOD-480401
                       " FROM img_file ",
                      " WHERE img01= ?  AND img02= ? AND img03= ? ",
                      " AND img04= ?   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING p_item,p_ware,p_loca,p_lot #FUN-5C0075
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       CLOSE img_lock    #TQC-930155 add
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF l_img.img18 < l_oga.oga02 THEN
       CALL cl_err(l_ogb.ogb04,'aim-400',1)   #須修改
       LET g_success='N' RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    LET l_qty= l_img.img10 - p_qty2
 
    #--訂單備置為'N',須check(庫存量ima262-sum(備置量oeb12-oeb24))>出貨量
    IF NOT cl_null(l_ogb.ogb31) AND NOT cl_null(l_ogb.ogb32) THEN
       SELECT oeb19 INTO l_oeb19 FROM oeb_file
        WHERE oeb01=l_ogb.ogb31 AND oeb03 = l_ogb.ogb32
       IF STATUS THEN
          CALL cl_err3("sel","oeb_file",l_ogb.ogb31,l_ogb.ogb32,SQLCA.sqlcode,"","sel oeb:",1)  #No.FUN-670008
          LET g_success='N' RETURN
       END IF
 
       IF p_qty2 > l_img.img10 THEN
          LET g_flag2 = NULL    #FUN-C80107 add
         #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],p_ware) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
          CALL s_inv_shrt_by_warehouse(p_ware,g_plant) RETURNING g_flag2                     #FUN-D30024 add  #TQC-D40078 g_plant
         #IF g_sma.sma894[2,2]='N' THEN   #FUN-C80107 mark
          IF g_flag2 = 'N' OR g_flag2 IS NULL THEN           #FUN-C80107 add
             IF g_bgerr THEN
                CALL s_errmsg('ima01',p_item,l_msg,'mfg-026',1)
             ELSE
                CALL cl_err(l_msg,'mfg-026',1)
             END IF
             LET g_success='N' RETURN
          END IF
       END IF
        #MOD-4A0232(end)
    END IF
 
 
   #IF NOT s_stkminus(p_item,p_ware,p_loca,p_lot,p_qty,p_factor,l_oga.oga02,g_sma.sma894[2,2]) THEN  #FUN-5C0075 #FUN-D30024
    IF NOT s_stkminus(p_item,p_ware,p_loca,p_lot,p_qty,p_factor,l_oga.oga02) THEN                    #FUN-D30024 add
       LET g_success='N'
       RETURN
    END IF
 
    CALL s_upimg(p_item,p_ware,p_loca,p_lot,-1,p_qty2,g_today, #FUN-8C0084
          '','','','',l_ogb.ogb01,l_ogb.ogb03,'','','','','','','','','','','','')  #No.FUN-850100
    IF g_success='N' THEN
       CALL cl_err('s_upimg()','9050',0) RETURN
    END IF
 
    #Update ima_file
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql
 
    OPEN ima_lock USING p_item   #FUN-5C0075
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       CLOSE ima_lock
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH ima_lock INTO l_ima25,l_ima86 #FUN-730018
    IF STATUS THEN
       CLOSE ima_lock   #TQC-930155 add
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
    Call s_udima(p_item,l_img.img23,l_img.img24,p_qty2,  #FUN-5C0075 
                 #g_today,-1)  RETURNING l_cnt   #MOD-920298
                 l_oga.oga02,-1)  RETURNING l_cnt   #MOD-920298
   #最近一次發料日期 表發料
    IF l_cnt THEN
       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
       LET g_success='N' RETURN
    END IF
    IF g_success='Y' THEN                                                      #CHI-9C0009 mark #CHI-9C0037 remark 
       CALL t600_app_sub_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,p_flag,p_item,l_ima86,l_oga.*,l_ogb.*) #No:8741  #FUN-5C0075
    END IF
END FUNCTION

FUNCTION t600_app_sub_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag,p_item,l_ima86,l_oga,l_ogb) #No:8741  #FUN-5C0075
   DEFINE
      p_ware     LIKE ogb_file.ogb09,       ##倉庫
      p_loca     LIKE ogb_file.ogb091,      ##儲位
      p_lot      LIKE ogb_file.ogb092,      ##批號
      p_qty      LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
      p_uom      LIKE ima_file.ima31,       ##銷售單位
      p_factor   LIKE ogb_file.ogb15_fac,   ##轉換率
      p_unit     LIKE ima_file.ima25,       ##單位
      p_img10    LIKE img_file.img10,     ##異動後數量
      p_item     LIKE img_file.img01,     #FUN-5C0075
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      l_cnt      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      p_flag     LIKE type_file.chr1,     #No:8741  #No.FUN-680137 VARCHAR(1)
      l_ima86    LIKE ima_file.ima86,    #FUN-730018
      l_oga      RECORD LIKE oga_file.*,
      l_ogb      RECORD LIKE ogb_file.*
DEFINE l_argv0 LIKE ogb_file.ogb09 #FUN-C40072 add

   LET l_argv0=l_oga.oga09 #FUN-C40072 add
   #----來源----
   LET g_tlf.tlf01=p_item              #異動料件編號
   LET g_tlf.tlf02=50                  #'Stock'
   LET g_tlf.tlf020=l_ogb.ogb08
   LET g_tlf.tlf021=p_ware             #倉庫

#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--
#   IF g_prog = 'axmt628' THEN 
#     LET g_tlf.tlf021 = l_ogb.ogb09
#   END IF 
#CHI-B30093 --end--  
#CHI-B60054  --End #MARK掉CHI-B30093更改
   
   LET g_tlf.tlf022=p_loca             #儲位
   LET g_tlf.tlf023=p_lot              #批號
   LET g_tlf.tlf024=p_img10            #異動後數量
   LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_ogb.ogb01        #出貨單號
   LET g_tlf.tlf027=l_ogb.ogb03        #出貨項次
   #---目的----
   LET g_tlf.tlf03=724
   LET g_tlf.tlf030=' '
   LET g_tlf.tlf031=' '                #倉庫
   LET g_tlf.tlf032=' '                #儲位
   LET g_tlf.tlf033=' '                #批號
   LET g_tlf.tlf034=' '                #異動後庫存數量
   LET g_tlf.tlf035=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_ogb.ogb31        #訂單單號
   LET g_tlf.tlf037=l_ogb.ogb32        #訂單項次
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oga.oga02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom			#發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   IF cl_null(l_ogb.ogb31) THEN     #FUN-BB0167 add
      LET g_tlf.tlf13='axmt650'     #FUN-BB0167 add
   ELSE                             #FUN-BB0167 add
#MOD-D20054---begin mark
#   #FUN-C40072---add---START
#      IF l_argv0 = '4' THEN
#         LET g_tlf.tlf13='axmt820'
#      ELSE
#   #FUN-C40072---add-----END
#MOD-D20054---end
         LET g_tlf.tlf13='axmt620'
#      END IF #FUN-C40072 add  #MOD-D20054
   END IF                           #FUN-BB0167 add
   LET g_tlf.tlf14=l_ogb.ogb1001   #No.FUN-660073
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ogb.ogb04)
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oga.oga03 #No.MOD-870252
   LET g_tlf.tlf20 = l_oga.oga46
   LET g_tlf.tlf61= l_ima86 #FUN-730018
   LET g_tlf.tlf62=l_ogb.ogb31    #參考單號(訂單)
   LET g_tlf.tlf63=l_ogb.ogb32    #訂單項次
   LET g_tlf.tlf64=l_ogb.ogb908   #手冊編號 no.A050
   LET g_tlf.tlf66=p_flag         #for axcp500多倉出貨處理   #No:8741
   LET g_tlf.tlf930=l_ogb.ogb930  #FUN-670063
   LET g_tlf.tlf20 = l_ogb.ogb41
   LET g_tlf.tlf41 = l_ogb.ogb42
   LET g_tlf.tlf42 = l_ogb.ogb43
   LET g_tlf.tlf43 = l_ogb.ogb1001
   CALL s_tlf(1,0)
END FUNCTION

FUNCTION t600_app_sub_chk_oeb(l_ogb)
   DEFINE l_over LIKE oea_file.oea09
   DEFINE l_ogb  RECORD LIKE ogb_file.*
   DEFINE l_tot1 LIKE ogb_file.ogb12
   DEFINE l_tot2 LIKE oeb_file.oeb12
   DEFINE l_tot3 LIKE oeb_file.oeb12   #MOD-A50076
   DEFINE l_tot4 LIKE oeb_file.oeb12   #add by zhangym 150426
   DEFINE l_chr  LIKE type_file.chr1
   DEFINE l_buf  LIKE type_file.chr1000
   DEFINE l_argv0 LIKE oga_file.oga09   #MOD-830155
   DEFINE l_msg  STRING			#FUN-970093
 
   SELECT oga09 INTO l_argv0 FROM oga_file WHERE oga01 = l_ogb.ogb01 #MOD-830155
   IF NOT cl_null(l_ogb.ogb31) AND l_ogb.ogb31[1,4] !='MISC' THEN
      # l_argv0 : 1.出貨通知單 2.出貨單 3.無訂單通知單
 
      IF s_industry('icd') THEN
	SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file, oga_file,ogbi_file
	 WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
	   AND ogb04 = l_ogb.ogb04 #BugNo:4541
	   AND ogb01=oga01 AND ogaconf='Y' AND oga09=l_argv0
	   AND ogbiicd03 <> '2'
	   AND ogb01 = ogbi01
	   AND ogb03 = ogbi03
      ELSE
	SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file, oga_file
	 WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
	   AND ogb04 = l_ogb.ogb04 #BugNo:4541
	   AND ogb01=oga01 AND ogaconf='Y' AND oga09=l_argv0
      END IF
      IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
      LET l_chr='N'
      SELECT (oeb12*((100+oea09)/100)+oeb25),oeb70,oeahold,oea09
           INTO l_tot2,l_chr,l_buf,l_over
           FROM oeb_file, oea_file
          WHERE oeb01 = l_ogb.ogb31 AND oeb03 = l_ogb.ogb32 AND oeb01=oea01
      IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
      #-----MOD-A50076---------
      LET l_tot3 = 0 
      SELECT SUM(ogb12) INTO l_tot3 FROM ogb_file,oga_file
       WHERE oga01 = ogb01
         AND ogb31 = l_ogb.ogb31 
         AND ogb32 = l_ogb.ogb32
         AND oga09 = '9'
         AND ogaconf = 'Y'
         AND ogapost = 'Y'
      IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
      #-----END MOD-A50076----- 
      IF l_chr='Y' THEN #此訂單已結案, 不可再出貨
         CALL cl_err(l_ogb.ogb32,'axm-150',1) LET g_success = 'N' RETURN
      END IF
      IF NOT cl_null(l_buf) THEN #此訂單已設定留置, 不可出貨
         LET l_msg = l_ogb.ogb31 ,' + ', l_ogb.ogb32
         CALL cl_err(l_msg,'axm-151',1) LET g_success = 'N' RETURN
      END IF
      #no.7168 檢查備品資料
      IF t600_app_sub_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
          #SELECT oeo09 INTO l_tot2 FROM oeo_file
          SELECT oeo09 INTO l_tot4 FROM oeo_file    #mod by zhangym 150426
           WHERE oeo01 = l_ogb.ogb31 AND oeo03 = l_ogb.ogb32
             AND oeo04 = l_ogb.ogb04 AND oeo08 = '2'
          #IF cl_null(l_tot2) THEN LET l_tot2 = 0  END IF
          #LET l_tot2 = l_tot2 *((100+l_over)/100) #含超交率，備品無法考慮銷退量
          IF cl_null(l_tot4) THEN LET l_tot4 = 0  END IF                               #mod by zhangym 150426
          LET l_tot4 = l_tot4 *((100+l_over)/100) #含超交率，備品無法考慮銷退量        #mod by zhangym 150426     
      END IF
      #no.7168(end)
      #IF l_tot1 > l_tot2 THEN #確認合計數量或金額大於原數量或金額, 不可再確認   #MOD-A50076
      #IF l_tot1 > l_tot2 + l_tot3 THEN #確認合計數量或金額大於原數量或金額, 不可再確認   #MOD-A50076
      IF l_tot1 > l_tot2 + l_tot3 + l_tot4 THEN #確認合計數量或金額大於原數量或金額, 不可再確認   #MOD-A50076  #mod by zhangym 150426
         CALL cl_err(l_ogb.ogb31||' l_tot1 > oeb24','axm-174',1) LET g_success = 'N' RETURN  #MOD-940150 add
      END IF
 
# 出貨通知單出貨數量>訂單數量 --> show warning **********
      IF l_ogb.ogb12 > l_tot2 THEN #
         CALL cl_err('ogb12>l_tot2','axm-294',1)
      END IF
   END IF
END FUNCTION

FUNCTION t600_app_sub_bu1(l_oga,l_ogb)   #更新訂單待出貨單量及已出貨量
   DEFINE l_amount LIKE oeb_file.oeb13   #出貨金額
   DEFINE l_oga    RECORD LIKE oga_file.*   #No.TQC-8C0027
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_tot3   LIKE ogb_file.ogb12
   DEFINE l_tot2   LIKE ogb_file.ogb12
   DEFINE l_tot1   LIKE ogb_file.ogb12
   DEFINE l_tot4   LIKE ogb_file.ogb12   #No.FUN-740016
   DEFINE l_tot5   LIKE ogb_file.ogb12   #MOD-AB0151
   DEFINE l_tot6   LIKE ogb_file.ogb12   #MOD-AB0151
   DEFINE l_oga011 LIKE oga_file.oga011  #MOD-AB0151
   DEFINE l_chr    LIKE type_file.chr1
   DEFINE l_buf    LIKE type_file.chr1000
   DEFINE l_oga00  LIKE oga_file.oga00   #No.FUN-740016
   DEFINE l_oea12  LIKE oea_file.oea12   #No.FUN-740016
   DEFINE l_oeb71  LIKE oeb_file.oeb71   #No.FUN-740016
   DEFINE l_oeb04  LIKE oeb_file.oeb04      
   DEFINE l_oeb24  LIKE oeb_file.oeb24      
   DEFINE l_oeb13  LIKE oeb_file.oeb13      
   DEFINE l_oeb05  LIKE oeb_file.oeb05      
   DEFINE l_oeb916 LIKE oeb_file.oeb916     
   DEFINE l_cnt    LIKE type_file.num5      
   DEFINE l_factor LIKE ima_file.ima31_fac  
   DEFINE l_tot    LIKE img_file.img10      
   DEFINE l_oea23  LIKE oea_file.oea23
   DEFINE l_oea213 LIKE oea_file.oea213
   DEFINE l_oea211 LIKE oea_file.oea211
   DEFINE l_azi04  LIKE azi_file.azi04
   DEFINE l_amt    LIKE oea_file.oea62
   DEFINE l_oeb29  LIKE oeb_file.oeb29   #No.TQC-8C0027
   DEFINE l_msg  STRING			 #FUN-970093
   DEFINE l_oebslk23  LIKE oebslk_file.oebslk23  #FUN-B90104----add
   DEFINE l_oebslk24  LIKE oebslk_file.oebslk24  #FUN-B90104----add
   DEFINE l_oga01  LIKE oga_file.oga01   #CHI-C20014
   DEFINE l_oea09  LIKE oea_file.oea09  #MOD-C90135
   DEFINE l_oeb12  LIKE oeb_file.oeb12  #MOD-C90135
   DEFINE l_ogb14  LIKE ogb_file.ogb14   #CHI-C90032 add
   DEFINE l_ocn03   LIKE ocn_file.ocn03  #CHI-C90032 add
   DEFINE l_ocn04   LIKE ocn_file.ocn04  #CHI-C90032 add
   DEFINE l_oea61   LIKE oea_file.oea61  #CHI-C90032 add
   DEFINE l_tot1_t  LIKE ogb_file.ogb12   #MOD-D70030 add
    
   IF t600_app_sub_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
      RETURN
   END IF
 
   CALL cl_msg("bu1!")
 
   IF NOT cl_null(l_ogb.ogb31) AND l_ogb.ogb31[1,4] !='MISC' THEN
      IF s_industry('icd') THEN
      SELECT SUM(ogb12) INTO l_tot3 FROM ogb_file, oga_file,ogbi_file
          WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
            AND ogb04=l_ogb.ogb04 #BugNo:4541
	    AND ogb01 = ogbi01
	    AND ogb03 = ogbi03
	    AND ogbiicd03 != '2'   #排除Spare Part的量
            AND ((oga09 IN ('1','5') AND (oga011 IS NULL OR oga011=' ')
                                       AND ogaconf='Y')
              #-----MOD-AB0151---------
              #OR (oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
              #              AND oga011 IN (SELECT oga01 FROM oga_file,ogb_file
              #                            WHERE ogb31=l_ogb.ogb31
              #                              AND ogb32=l_ogb.ogb32
              #                              AND ogb01=oga01 AND ogaconf='N'))
              #-----END MOD-AB0151-----
              #-----MOD-A50076---------
              #OR (oga09 IN ('2','4','6') AND ogaconf='Y' AND ogapost='N'))  #No.FUN-630061   
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                                         AND ogaconf='Y' AND ogapost='N')    
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                         AND ogaconf='Y' AND ogapost='Y' AND oga65='Y'
                         AND oga01 NOT IN(SELECT oga011 FROM oga_file,ogb_file
                                            WHERE ogb31=l_ogb.ogb31
                                              AND ogb32=l_ogb.ogb32
                                              AND ogb01=oga01
                                              AND ogaconf='Y'
                                              AND ogapost='Y'
                                              AND oga09='8')))  
              #-----END MOD-A50076-----
         #-----MOD-AB0151---------
         IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
         SELECT SUM(ogb12) INTO l_tot5 FROM ogb_file, oga_file
           WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
             AND ogb04=l_ogb.ogb04 
             AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         IF cl_null(l_tot5) THEN LET l_tot5 = 0 END IF
         DECLARE t600_curs_1 CURSOR FOR 
           SELECT DISTINCT oga011 FROM ogb_file, oga_file
             WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
               AND ogb04=l_ogb.ogb04 
               AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         FOREACH t600_curs_1 INTO l_oga011
           SELECT SUM(ogb12) INTO l_tot6 FROM ogb_file, oga_file
             WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
               AND ogb04=l_ogb.ogb04 
               AND oga09 IN ('2','4','6') 
               AND oga01 = l_oga011 
               AND ((ogapost = 'Y' AND oga65='N')
                   OR ( oga65='Y' AND 
                        oga01 IN (SELECT oga011 FROM oga_file,ogb_file
                                       WHERE ogb31=l_ogb.ogb31
                                         AND ogb32=l_ogb.ogb32
                                         AND ogb01=oga01
                                         AND ogaconf='Y'
                                         AND ogapost='Y'
                                         AND oga09='8')))  
           IF cl_null(l_tot6) THEN LET l_tot6 = 0 END IF
           LET l_tot5 = l_tot5 - l_tot6 
           #LET l_tot3 = l_tot3 + l_tot5   #MOD-AC0257
         END FOREACH
         LET l_tot3 = l_tot3 + l_tot5   #MOD-AC0257
      #-----END MOD-AB0151-----
      ELSE
      SELECT SUM(ogb12) INTO l_tot3 FROM ogb_file, oga_file
          WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
            AND ogb04=l_ogb.ogb04 #BugNo:4541
            AND ((oga09 IN ('1','5') AND (oga011 IS NULL OR oga011=' ')
                                       AND ogaconf='Y')
              #-----MOD-AB0151---------
              #OR (oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
              #              AND oga011 IN (SELECT oga01 FROM oga_file,ogb_file
              #                            WHERE ogb31=l_ogb.ogb31
              #                              AND ogb32=l_ogb.ogb32
              #                              AND ogb01=oga01 AND ogaconf='N'))
              #-----END MOD-AB0151-----
              #-----MOD-A50076---------
              #OR (oga09 IN ('2','4','6') AND ogaconf='Y' AND ogapost='N'))  #No.FUN-630061   
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                                         AND ogaconf='Y' AND ogapost='N')    
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                                         AND ogaconf='Y' AND ogapost='Y' AND oga65='Y'
                         AND oga01 NOT IN(SELECT oga011 FROM oga_file,ogb_file
                                            WHERE ogb31=l_ogb.ogb31
                                              AND ogb32=l_ogb.ogb32
                                              AND ogb01=oga01
                                              AND ogaconf='Y'
                                              AND ogapost='Y'
                                              AND oga09='8')))  
              #-----END MOD-A50076-----
         #-----MOD-AB0151---------
         IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
         SELECT SUM(ogb12) INTO l_tot5 FROM ogb_file, oga_file
           WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
             AND ogb04=l_ogb.ogb04 
             AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         IF cl_null(l_tot5) THEN LET l_tot5 = 0 END IF
         DECLARE t600_curs CURSOR FOR
           SELECT DISTINCT oga01, oga011 FROM ogb_file, oga_file             #CHI-C20014 add oga01 
             WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
               AND ogb04=l_ogb.ogb04 
               AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         FOREACH t600_curs INTO l_oga01, l_oga011     #CHI-C20014 add oga01
           SELECT SUM(ogb12) INTO l_tot6 FROM ogb_file, oga_file
             WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32 AND ogb01=oga01
               AND ogb04=l_ogb.ogb04 
               AND oga09 IN ('2','4','6') 
               #AND oga01 = l_oga011     #CHI-C20014 mark   #將oga01放進where條件,所以抓取已出貨量時會只抓到一筆出貨單數量,會造成一張出通單但是有多筆出貨單時出貨數量抓取錯誤
               AND oga011 = l_oga01     #CHI-C20014 add 
               AND ((ogapost = 'Y' AND oga65='N')
                   OR ( oga65='Y' AND 
                        oga01 IN (SELECT oga011 FROM oga_file,ogb_file
                                       WHERE ogb31=l_ogb.ogb31
                                         AND ogb32=l_ogb.ogb32
                                         AND ogb01=oga01
                                         AND ogaconf='Y'
                                         AND ogapost='Y'
                                         AND oga09='8')))  
           IF cl_null(l_tot6) THEN LET l_tot6 = 0 END IF
           LET l_tot5 = l_tot5 - l_tot6 
           #LET l_tot3 = l_tot3 + l_tot5   #MOD-AC0257
         END FOREACH
         LET l_tot3 = l_tot3 + l_tot5   #MOD-AC0257
      #-----END MOD-AB0151-----
      END IF
#MOD-C90135 add begin-----------#更新訂單待出貨數量的邏輯判斷,防止超過訂單允許的最大數量
      SELECT oea09 INTO l_oea09 FROM oea_file
       WHERE oea01=l_ogb.ogb31
      IF cl_null(l_oea09) THEN LET l_oea09 = 0 END IF 
      SELECT oeb12 INTO l_oeb12 FROM oeb_file 
      WHERE oeb01 = l_ogb.ogb31
        AND oeb03 = l_ogb.ogb32
      IF cl_null(l_oeb12) THEN LET l_oea09 = 0 END IF
      IF l_tot3 >= (1+l_oea09/100)*l_oeb12 THEN 
      	 LET l_tot3 = (1+l_oea09/100)*l_oeb12
      END IF 	  	
#MOD-C90135 ADD end-------------      
      IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
      #MOD-D70030 mark begin----------------- 
#      IF s_industry('icd') THEN
#	 SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file,ogbi_file
#	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
#	       AND ogb01 = ogbi01
#	       AND ogb03 = ogbi03
#	       AND ogbiicd03 <> '2'  #排除Spare Part的量
#	       AND ogb04=l_ogb.ogb04 #BugNo:4541
#               #AND ogb01=oga01 AND oga09 IN ('2','4','6','A') #No.7992  #No.FUN-630061   #MOD-A10122 oga09 add 'A'   #MOD-A50076
#	      #AND ogb1005 = '1'   #No.FUN-610064                 #TQC-B10066
#               AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001)) #TQC-B10066
#               #-----MOD-A50076---------
#	       #AND ogaconf='Y' AND ogapost='Y'  
#               AND ogb01=oga01
#               AND ((oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y') # AND oga65='N') #MOD-D70030 add
#                 OR (oga09='8' AND ogaconf='Y' AND ogapost='Y'))
#               #-----END MOD-A50076-----
#      ELSE
#	 SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file
#	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
#	       AND ogb04=l_ogb.ogb04 #BugNo:4541
#               #AND ogb01=oga01 AND oga09 IN ('2','4','6','A') #No.7992  #No.FUN-630061   #MOD-A10122 oga09 add 'A'   #MOD-A50076
#	      #AND ogb1005 = '1'   #No.FUN-610064                 #TQC-B10066
#               AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001)) #TQC-B10066
#               #-----MOD-A50076---------
#	       #AND ogaconf='Y' AND ogapost='Y'  
#               AND ogb01=oga01
#               AND ((oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y') # AND oga65='N') #MOD-D70030 add 
#                 OR (oga09='8' AND ogaconf='Y' AND ogapost='Y'))
#               #-----END MOD-A50076-----
#      END IF
      #MOD-D70030 mark end-----------------
      #MOD-D70030 add begin-----------------
      IF s_industry('icd') THEN
     	   SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file,ogbi_file
     	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
     	       AND ogb01 = ogbi01
     	       AND ogb03 = ogbi03
     	       AND ogbiicd03 <> '2'  #排除Spare Part的量
     	       AND ogb04=l_ogb.ogb04 
             AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                    AND ogb01=oga01
                    AND (oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y')
         IF g_prog[1,7]='axmt628' THEN
        	   SELECT SUM(ogb52) INTO l_tot1_t FROM ogb_file,oga_file,ogbi_file
        	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
        	       AND ogb01 = ogbi01
        	       AND ogb03 = ogbi03
        	       AND ogbiicd03 <> '2'  #排除Spare Part的量
        	       AND ogb04=l_ogb.ogb04 
                AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                AND ogb01=oga01            
                AND oga09='8' AND ogaconf='Y' AND ogapost='Y'
         END IF                  
         IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
         IF cl_null(l_tot1_t) THEN LET l_tot1_t = 0 END IF
         IF g_prog[1,7]='axmt628' THEN
            LET  l_tot1 = l_tot1 - l_tot1_t  #出货量 - 签退量 = 实际出货量
         END IF    
      ELSE
   	   SELECT SUM(ogb12) INTO l_tot1 FROM ogb_file,oga_file
   	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
   	       AND ogb04=l_ogb.ogb04 
                  AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                  AND ogb01=oga01
                  AND (oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y') 
         IF g_prog[1,7]='axmt628' THEN
      	   SELECT SUM(ogb52) INTO l_tot1_t FROM ogb_file,oga_file
      	     WHERE ogb31=l_ogb.ogb31 AND ogb32=l_ogb.ogb32
      	       AND ogb04=l_ogb.ogb04 
                     AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                     AND ogb01=oga01    
                     AND oga09='8' AND ogaconf='Y' AND ogapost='Y' 
         END IF
         IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
         IF cl_null(l_tot1_t) THEN LET l_tot1_t = 0 END IF         
         IF g_prog[1,7]='axmt628' THEN
            LET  l_tot1 = l_tot1 - l_tot1_t  #出货量 - 签退量 = 实际出货量
         END IF                                        
      END IF      
      
      
      #MOD-D70030 add end-------------------
      IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
      DISPLAY '已出貨數量為tot1=',l_tot1
      LET l_chr='N'
      SELECT (oeb12*((100+oea09)/100)+oeb25),oeb70,oeahold
           INTO l_tot2,l_chr,l_buf
           FROM oeb_file, oea_file
          WHERE oeb01 = l_ogb.ogb31 AND oeb03 = l_ogb.ogb32 AND oeb01=oea01
      IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
      IF l_chr='Y' THEN
         CALL cl_err(l_ogb.ogb32,'axm-150',1) LET g_success = 'N' RETURN
      END IF
      IF NOT cl_null(l_buf) THEN
         LET l_msg = l_ogb.ogb31 ,' + ', l_ogb.ogb32
         CALL cl_err(l_msg,'axm-151',1) LET g_success = 'N' RETURN
      END IF
      IF l_tot1 > l_tot2 THEN
         CALL cl_err(l_ogb.ogb31||' l_tot1 > oeb24','axm-174',1) LET g_success = 'N' RETURN  #MOD-940150 add
      END IF
 
      SELECT SUM(ogb12),SUM(ogb14) INTO l_tot4, l_ogb14 FROM ogb_file,oga_file    #CHI-C90032 add ogb14
          WHERE ogb31=l_ogb.ogb31
            AND ogb32=l_ogb.ogb32
            AND ogb04=l_ogb.ogb04
            AND ogb01=oga01 AND oga00='B'
            AND ogaconf='Y'
            AND ogapost='Y'  
      IF cl_null(l_tot4) THEN LET l_tot4 = 0 END IF
      IF cl_null(l_ogb14) THEN LET l_ogb14 = 0 END IF   #CHI-C90032 add 

      UPDATE oeb_file SET oeb23=l_tot3,
                          oeb24=l_tot1,
                          oeb29=l_tot4   #No.FUN-740016
       WHERE oeb01 = l_ogb.ogb31
         AND oeb03 = l_ogb.ogb32
      IF STATUS THEN
         CALL cl_err3("upd","oeb_file",l_ogb.ogb31,l_ogb.ogb32,SQLCA.sqlcode,"","upd oeb24",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oeb24','axm-134',1) LET g_success = 'N' RETURN
      END IF
#FUN-B90104----add---begin---
#     IF s_industry("slk")  THEN    #FUN-C20006--mark
      IF s_industry("slk") AND g_azw.azw04='2' THEN    #FUN-C20006--add
         SELECT SUM(oeb23),SUM(oeb24) INTO l_oebslk23,l_oebslk24 FROM oeb_file,oebi_file
          WHERE oeb01=oebi01
            AND oeb03=oebi03
            AND oeb01=l_ogb.ogb31
            AND oebislk03 = (SELECT oebislk03 FROM oeb_file,oebi_file
                               WHERE oebi01=oeb01
                                 AND oebi03=oeb03
                                 AND oeb01=l_ogb.ogb31
                                 AND oeb03=l_ogb.ogb32)

         UPDATE oebslk_file SET oebslk23=l_oebslk23,
                                oebslk24=l_oebslk24
          WHERE oebslk01 = l_ogb.ogb31
            AND oebslk03 =(SELECT oebislk03 FROM oebi_file,oeb_file
                            WHERE oebi01=oeb01
                              AND oebi03=oeb03
                              AND oebi01=l_ogb.ogb31
                              AND oebi03=l_ogb.ogb32)
                             
         IF STATUS THEN
            CALL cl_err3("upd","oebslk_file",l_ogb.ogb31,l_ogb.ogb32,SQLCA.sqlcode,"","upd oebslk24",1)
            LET g_success = 'N' RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('upd oebslk24','axm-134',1) LET g_success = 'N' RETURN
         END IF
       
      END IF
#FUN-B90104----add---begin---

      #如為借貨償價出貨單
      IF l_oga.oga00 = "B" AND l_oga.ogapost="Y" THEN 
         #抓出原借貨訂單單號
         SELECT oea12,oeb71 INTO l_oea12,l_oeb71 FROM oea_file,oeb_file 
          WHERE oeb01 = l_ogb.ogb31
            AND oeb03 = l_ogb.ogb32
            AND oea01 = oeb01
        
         #抓出原償價數量
         SELECT oeb29 INTO l_oeb29 from oeb_file
          WHERE oeb01 = l_oea12 
            AND oeb03 = l_oeb71
        
         IF cl_null(l_oeb29) THEN
            LET l_oeb29 = 0
         END IF
        
         UPDATE oeb_file SET oeb29 = l_oeb29 + l_ogb.ogb12 
          WHERE oeb01 = l_oea12 
            AND oeb03 = l_oeb71
         IF STATUS THEN
            CALL cl_err3("upd","oeb_file",l_oea12,l_oeb71,SQLCA.sqlcode,"","upd oeb29",1)  #No.FUN-670008
            LET g_success = 'N' RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('upd oeb29','axm-134',1) LET g_success = 'N' RETURN
         END IF
        #CHI-C90032 add START
        #業務額度在借貨出貨庫存扣帳時不異動,
        #業務額度在借貨償價庫存扣帳時會將業務額度加回
        #其他項目,像是一般訂單出貨單必不會異動業務額度
         LET l_oea61 = l_oga.oga24*l_ogb14
         CALL cl_digcut(l_oea61,g_azi04) RETURNING l_oea61
         SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
          WHERE ocn01 = l_oga.oga14

         LET l_ocn03 = l_ocn03-l_oea61
         LET l_ocn04 = l_ocn04+l_oea61

         UPDATE ocn_file SET ocn03 = l_ocn03,
                             ocn04 = l_ocn04
          WHERE ocn01 = l_oga.oga14
        #CHI-C90032 add END
      END IF
 
# update 出貨金額 (oea62) for prog:axmq420 ----------
      DECLARE t600_curs2 CURSOR FOR 
        SELECT oeb04,oeb24,oeb13,oeb05,oeb916 FROM oeb_file 
          WHERE oeb01 = l_ogb.ogb31
           #AND oeb03 = l_ogb.ogb32   #MOD-990092 #MOD-C40114 mark     
      LET l_amount = 0 
      FOREACH t600_curs2 INTO l_oeb04,l_oeb24,l_oeb13,l_oeb05,l_oeb916
         CALL s_umfchk(l_oeb04,l_oeb05,l_oeb916)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN 
            LET l_factor = 1
         END IF
         LET l_tot = l_oeb24 * l_factor
         SELECT oea23,oea213,oea211 INTO l_oea23,l_oea213,l_oea211 
            FROM oea_file
           WHERE oea01=l_ogb.ogb31
         SELECT azi04 INTO l_azi04 FROM azi_file 
            WHERE azi01 = l_oea23
         IF l_oea213 = 'N' THEN
           LET l_amt = l_tot * l_oeb13                        
           CALL cl_digcut(l_amt,l_azi04) RETURNING l_amt      
         ELSE
           LET l_amt = l_tot * l_oeb13                        
           CALL cl_digcut(l_amt,l_azi04) RETURNING l_amt     
           LET l_amt = l_amt/ (1+l_oea211/100)
           CALL cl_digcut(l_amt,l_azi04)  RETURNING l_amt      
         END IF
         LET l_amount = l_amount + l_amt
      END FOREACH
      IF cl_null(l_amount) THEN LET l_amount=0 END IF
      UPDATE oea_file SET oea62=l_amount
       WHERE oea01=l_ogb.ogb31
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","oea_file",l_ogb.ogb31,"",SQLCA.sqlcode,"","upd oea62",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
   END IF
END FUNCTION

 
FUNCTION t600_app_sub_chk_img(l_oga,l_ogb)
   DEFINE l_oga    RECORD LIKE oga_file.*
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_ogc    RECORD LIKE ogc_file.*
   DEFINE l_img18  LIKE img_file.img18   #No.MOD-480401
   DEFINE l_item   LIKE ogc_file.ogc17   #FUN-5C0075
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_poy11  LIKE poy_file.poy11	    	#MOD-980090
   DEFINE li_result LIKE type_file.num5     	#MOD-980090
   DEFINE l_poz     RECORD LIKE poz_file.*  	#MOD-980090
   DEFINE l_oea99   LIKE oea_file.oea99     	#MOD-980090
   DEFINE l_oea904  LIKE oea_file.oea904    	#MOD-980090
   DEFINE l_last         LIKE type_file.num5    #MOD-980090
   DEFINE l_last_plant   LIKE cre_file.cre08    #MOD-980090
 
   #判斷是否為多倉儲
   IF l_ogb.ogb17='Y' THEN   #多倉儲
      DECLARE chk_ogc CURSOR FOR
         SELECT *
           FROM ogc_file
          WHERE ogc01 = l_ogb.ogb01
            AND ogc03 = l_ogb.ogb03
      FOREACH chk_ogc INTO l_ogc.*
         IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
         LET l_cnt=0
         IF g_oaz.oaz23 = 'Y' AND NOT cl_null(l_ogc.ogc17) THEN
            LET l_item = l_ogc.ogc17
         ELSE
            let l_item = l_ogb.ogb04
         END IF
#FUN-AB0011 ---------------------STA
         IF s_joint_venture( l_item,g_plant) OR NOT s_internal_item( l_item,g_plant ) THEN
            RETURN
         END IF
#FUN-AB0011 ---------------------END
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM img_file
             WHERE img01 = l_item AND img02=l_ogc.ogc09   #FUN-5C0075
               AND img03 = l_ogc.ogc091
               AND img04 = l_ogc.ogc092
         IF l_cnt=0 THEN
            CALL cl_err(l_item,'axm-244',1) #FUN-970005     
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
   ELSE
#FUN-AB0011 ---------------------STA
      IF s_joint_venture( l_ogb.ogb04,g_plant) OR NOT s_internal_item( l_ogb.ogb04,g_plant ) THEN
     #    LET g_success = 'N'                      #FUN-AB0059   mark
         RETURN
      END IF
#FUN-AB0011 ---------------------END
      SELECT img18 INTO l_img18 FROM img_file
          WHERE img01 = l_ogb.ogb04
            AND img02 = l_ogb.ogb09
            AND img03 = l_ogb.ogb091
            AND img04 = l_ogb.ogb092
#-----MOD-A80026---------
{
      IF STATUS THEN
         IF l_oga.oga09  MATCHES  '[45]' THEN #非多角出貨單
            CALL t600sub_chkpoz(l_oga.*,NULL) RETURNING li_result,l_poz.*,l_oea99,l_oea904 
            IF NOT li_result THEN RETURN END IF 
            LET l_poy11 = ''
            IF l_poz.poz011='1' THEN   #正拋
               SELECT poy11 INTO l_poy11 
                 FROM poy_file
                WHERE poy01 = l_poz.poz01
                  AND poy02 = '0'
            ELSE
               CALL s_mtrade_last_plant(l_poz.poz01) 
                              RETURNING l_last,l_last_plant    #記錄最後一筆之家數
               SELECT poy11 INTO l_poy11 
                 FROM poy_file
                WHERE poy01 = l_poz.poz01
                  AND poy02 = l_last
            END IF
            IF l_poy11 <> l_ogb.ogb09 THEN
               CALL cl_err(l_ogb.ogb04,'axm-245',1)  #FUN-970005
               LET g_success = 'N'  #TQC-980155
               RETURN               #TQC-980155 
            END IF
         ELSE
            CALL cl_err(l_ogb.ogb04,'axm-244',1)  #FUN-970005  
            LET g_success = 'N'  #TQC-980155
            RETURN               #TQC-980155   
         END IF
      END IF
}
      IF STATUS THEN
         CALL cl_err(l_ogb.ogb04,'axm-244',1)  
         LET g_success = 'N'  
         RETURN             
      END IF
#-----END MOD-A80026-----
      IF l_img18 < l_oga.oga02 THEN
         CALL cl_err(l_ogb.ogb04,'aim-400',1)   #須修改
         LET g_success='N'
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION t600_app_sub_chk_ogb15_fac(l_oga,l_ogb)
DEFINE l_ogb15_fac   LIKE ogb_file.ogb15_fac
DEFINE l_ogb15       LIKE ogb_file.ogb15
DEFINE l_ogb         RECORD LIKE ogb_file.*
DEFINE l_oga         RECORD LIKE oga_file.*
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_msg         STRING                 #MOD-C50020
#FUN-AB0011 -----------------STA
# 聯營或非企業料號不判斷
  IF s_joint_venture( l_ogb.ogb04,g_plant) OR NOT s_internal_item( l_ogb.ogb04,g_plant ) THEN  
     RETURN
  END IF
#FUN-AB0011 -----------------END
   
  SELECT img09 INTO l_ogb15 FROM img_file
        WHERE img01 = l_ogb.ogb04 AND img02 = l_ogb.ogb09
          AND img03 = l_ogb.ogb091 AND img04 = l_ogb.ogb092
 
  CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb15)
            RETURNING l_cnt,l_ogb15_fac
  IF l_cnt = 1 THEN
     CALL cl_err('','mfg3075',1)
    #MOD-C50020---S---
     CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
     LET l_msg = l_msg CLIPPED,":",l_ogb.ogb04
     CALL cl_err(l_msg,'mfg3075',1)   #MOD-C50020 add l_msg
    #MOD-C50020---E---
     LET g_success='N'
     RETURN
  END IF
  IF l_ogb15 != l_ogb.ogb15 OR
     l_ogb15_fac != l_ogb.ogb15_fac THEN
     LET l_ogb.ogb15_fac = l_ogb15_fac
     LET l_ogb.ogb15 = l_ogb15
     LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb15_fac
 
     UPDATE ogb_file SET ogb15_fac=l_ogb.ogb15_fac,
                         ogb16 =l_ogb.ogb16,
                         ogb15 =l_ogb.ogb15
      WHERE ogb01=l_oga.oga01   #MOD-7B0208
        AND ogb03=l_ogb.ogb03   #MOD-7B0208
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","ogb15_fac",l_oga.oga01,l_ogb.ogb03,SQLCA.sqlcode,"","",1)
        LET g_success='N'
        RETURN
     END IF
  END IF
  RETURN
END FUNCTION

FUNCTION t600_app_sub_oea18_chk(p_ogb03,l_oga,p_ogb31,p_fieldchk)
   DEFINE p_ogb03   LIKE ogb_file.ogb03
   DEFINE l_oga     RECORD LIKE oga_file.* #FUN-730012
   DEFINE p_fieldchk LIKE type_file.num5   #FUN-730012
   DEFINE l_oea     RECORD LIKE oea_file.* #FUN-730012
   DEFINE p_ogb31   LIKE ogb_file.ogb31
   DEFINE l_oea18   LIKE oea_file.oea18,
          l_oea23   LIKE oea_file.oea23,
          l_oea24   LIKE oea_file.oea24,
          l_oea01   LIKE oea_file.oea01,
          o_oea18   LIKE oea_file.oea18,
          o_oea23   LIKE oea_file.oea23,
          o_oea24   LIKE oea_file.oea24,
          l_ogb03   LIKE ogb_file.ogb03,
          l_cnt     LIKE type_file.num5     #No.FUN-680137 SMALLINT
 
   IF p_fieldchk THEN
      SELECT * INTO l_oea.* FROM oea_file
       WHERE oea01=p_ogb31
      IF STATUS THEN
         CALL cl_err3("sel","oea_file",p_ogb31,"",SQLCA.sqlcode,"","sel oea",1)  #No.FUN-670008
         RETURN FALSE
      END IF
 
      IF l_oea.oea044 != l_oga.oga044 THEN
	#CALL cl_err('axm-916',STATUS,0) #MOD-C40017 mark
         CALL cl_err('','axm-916',0)     #MOD-C40017
         RETURN FALSE
      END IF
   END IF
 
   LET l_cnt=0
   IF cl_null(p_ogb03) THEN LET p_ogb03 =0 END IF
   DECLARE oea18_chk CURSOR FOR
       SELECT oea01,oea23,oea24,oea18 ,ogb03
         FROM oea_file,ogb_file
        WHERE oea01=ogb31
          AND ogb01=l_oga.oga01
   FOREACH oea18_chk INTO l_oea01,l_oea23,l_oea24,l_oea18,l_ogb03
        IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
        IF cl_null(l_oea18) THEN LET l_oea18='N' END IF
        IF p_ogb03 <> 0 AND l_ogb03=p_ogb03 THEN
           CONTINUE FOREACH
        END IF
        LET l_cnt = l_cnt+1
        IF l_cnt=1 THEN
           LET o_oea18=l_oea18
           LET o_oea23=l_oea23
           LET o_oea24=l_oea24
           IF l_oea18='Y' THEN
              LET l_oga.oga24 = l_oea24
              UPDATE oga_file
                 SET oga24 = l_oga.oga24
                WHERE oga01 = l_oga.oga01
              DISPLAY BY NAME l_oga.oga24
           END IF
        END IF
        IF l_oea18 <> o_oea18 OR
           (l_oea18='Y' AND (l_oea23 <> o_oea23 OR l_oea24 <>o_oea24)) THEN
            CALL cl_err(l_oea01,'axm-608',1)
            RETURN FALSE #FUN-730012
        END IF
   END FOREACH
   IF p_fieldchk THEN
      IF cl_null(l_oea.oea18) THEN LET l_oea.oea18='N' END IF
      #若是訂單匯率立帳, 則帶該訂單之匯率
      IF l_cnt=0 AND l_oea.oea18='Y' THEN
         LET l_oga.oga24 = l_oea.oea24
         UPDATE oga_file SET oga24 = l_oga.oga24
           WHERE oga01 = l_oga.oga01
         DISPLAY BY NAME l_oga.oga24
      END IF
      IF l_cnt > 0 AND (l_oea.oea18 <>l_oea18 OR
        (l_oea.oea18='Y' AND (l_oea23<> l_oea.oea23 OR
         l_oea24<> l_oea.oea24) )) THEN
         CALL cl_err('','axm-608',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION

#檢查是否為備品資料 no.7168
FUNCTION t600_app_sub_chkoeo(p_oeo01,p_oeo03,p_oeo04)
  DEFINE p_oeo01 LIKE oeo_file.oeo01
  DEFINE p_oeo03 LIKE oeo_file.oeo03
  DEFINE p_oeo04 LIKE oeo_file.oeo04
  DEFINE l_cnt   LIKE type_file.num5
 
  LET l_cnt=0
  SELECT COUNT(*) INTO l_cnt FROM oeo_file
   WHERE oeo01 = p_oeo01 AND oeo03 = p_oeo03
     AND oeo04 = p_oeo04 AND oeo08 = '2'
  IF l_cnt > 0 THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION
