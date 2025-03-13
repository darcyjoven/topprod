# Prog. Version..: '5.30.06-13.04.22(00002)'     #
# Pattern name...: s_gen_so(p_no)
# Descriptions...: 出通單產生出貨單副程式
# Date & Author..: No:DEV-D30047 13/04/15 By TSD.sophy
# Usage..........: CALL s_gen_so(p_no)
# Input Parameter: p_no      單據編號
# Return Code....: oga01     產生之出貨單號
# Modify.........: No:DEV-D30046 13/04/19 By TSD.sophy 調整function名稱

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../../aba/4gl/barcode.global"

DEFINE g_oga      RECORD LIKE oga_file.*
DEFINE g_oga_u    RECORD LIKE oga_file.*
DEFINE g_ogb      RECORD LIKE ogb_file.*
DEFINE g_no       LIKE type_file.chr20
DEFINE g_msg      LIKE type_file.chr1000
DEFINE exT        LIKE oax_file.oax01
DEFINE g_exdate   LIKE type_file.dat
DEFINE g_sql      STRING 

#DEV-D30046 --mod--str
#FUNCTION s_gen_shipping_order(p_no)
FUNCTION s_gen_so(p_no)
#DEV-D30046 --mod--end
DEFINE p_no       LIKE type_file.chr20
DEFINE l_oap      RECORD LIKE oap_file.*
DEFINE l_buf      LIKE type_file.chr1000

   WHENEVER ERROR CONTINUE

   LET g_no = p_no
   
   IF cl_null(g_no) THEN 
      RETURN NULL
   END IF 
   
   SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00 = '0'
   SELECT * INTO g_ibd.* FROM ibd_file WHERE ibd01 = '0'
   
   IF g_oaz.oaz81 = 'N' OR g_ibd.ibd09 = 'N' THEN 
      RETURN NULL 
   END IF 

   CALL s_gen_so_create_tmp()

   BEGIN WORK
   LET g_success = 'Y'
   
   #=== 單頭 === 
   CALL s_gen_so_ins_oga()
   IF g_success = 'N' THEN 
      ROLLBACK WORK 
      RETURN NULL
   END IF 

   IF g_oga.oga044[1,4] = 'MISC' THEN
      IF g_oga.oga09 MATCHES '[15]' AND g_oga.oga16 IS NOT NULL THEN
         LET l_buf = g_oga.oga16
      END IF
      IF g_oga.oga09 MATCHES '[2468]' THEN  
         IF g_oga.oga011 IS NOT NULL AND g_oga.oga011 != g_oga.oga01 THEN 
            LET l_buf = g_oga.oga011
         ELSE 
            LET l_buf = g_oga.oga16
         END IF
      END IF
      
      INITIALIZE l_oap.* TO NULL
      SELECT * INTO l_oap.* FROM oap_file WHERE oap01 = l_buf
      IF l_oap.oap01 IS NOT NULL THEN
         LET l_oap.oap01 = g_oga.oga01
         INSERT INTO oap_file VALUES (l_oap.*)
      END IF
   END IF

   CALL s_gen_so_ins_oao()
   
   #=== 單身 ===
   CALL s_gen_so_ins_ogb()
   IF g_success = 'N' THEN 
      ROLLBACK WORK 
      RETURN NULL
   END IF 
   
   COMMIT WORK

   RETURN g_oga.oga01
END FUNCTION 

FUNCTION s_gen_so_oga_default()
   LET g_oga.oga00 ='1'
   LET g_oga.oga06 = g_oaz.oaz41
   LET g_oga.oga08 = '1'
   LET g_oga.oga69 = g_today  
   LET g_oga.oga02 = g_today
   LET g_oga.oga14 = g_user
   LET g_oga.oga15 = g_grup
   LET g_oga.oga65 = 'N'  
   LET g_oga.oga1014 = 'N'  
   LET g_oga.oga1015 = '0'  
   LET g_oga.oga1005 = 'N'  
   IF g_oaz.oaz64 = 'O' THEN
      LET g_oga.oga07 = 'N'
   ELSE
      LET g_oga.oga07 = g_oaz.oaz64
   END IF
   LET g_oga.oga161 = 0
   LET g_oga.oga162 = 100
   LET g_oga.oga163 = 0
   LET g_oga.oga20 = 'Y'
   LET g_oga.oga211 = 0
   LET g_oga.oga50 = 0
   LET g_oga.oga52 = 0
   LET g_oga.oga53 = 0
   LET g_oga.oga54 = 0
   LET g_oga.oga57 = '1'   
   LET g_oga.oga903 = 'N'
   LET g_oga.ogaconf = 'N'
   LET g_oga.ogaspc = '0'    
   LET g_oga.oga30 = 'N'
   LET g_oga.ogapost = 'N'
   LET g_oga.ogaprsw = 0
   LET g_oga.ogauser = g_user
   LET g_oga.ogaoriu = g_user 
   LET g_oga.ogaorig = g_grup 
   LET g_data_plant = g_plant 
   LET g_oga.ogagrup = g_grup
   LET g_oga.ogadate = g_today
   LET g_oga.ogaplant = g_plant
   LET g_oga.ogalegal = g_legal
   IF g_azw.azw04 = '2' THEN      
      LET g_oga.oga94 = 'N'    
      LET g_oga.oga83 = g_plant
      LET g_oga.oga84 = g_plant  
   END IF
END FUNCTION

FUNCTION s_gen_so_ins_oao()
DEFINE l_cnt   LIKE type_file.num5,
       l_ogb03 LIKE ogb_file.ogb03,
       l_ogb31 LIKE ogb_file.ogb31,
       l_ogb32 LIKE ogb_file.ogb32

   WHILE TRUE
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM oao_file
        WHERE oao01 = g_oga.oga01
          AND oao03 = 0
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN
         IF NOT cl_confirm('axm-623') THEN 
            EXIT WHILE
         END IF 
      END IF 
      
      DELETE FROM oao_tmp
      
      IF g_oga.oga09 MATCHES '[2468]' AND g_oga.oga01 != g_oga.oga011 THEN 
         INSERT INTO oao_tmp 
           SELECT * FROM oao_file WHERE oao01 = g_oga.oga011 AND oao03 = 0 
      ELSE
         INSERT INTO oao_tmp 
           SELECT * FROM oao_file WHERE oao01 = g_oga.oga16 AND oao03 = 0 
      END IF
      
      UPDATE oao_tmp SET oao01 = g_oga.oga01
      DELETE FROM oao_file WHERE oao01 = g_oga.oga01 AND oao03 = 0 
      INSERT INTO oao_file SELECT * FROM oao_tmp 
        
      EXIT WHILE
   END WHILE
END FUNCTION 

FUNCTION s_gen_so_ins_oga()
DEFINE l_oayb01    LIKE oayb_file.oayb01
DEFINE l_ogb31     LIKE ogb_file.ogb31
DEFINE l_ogb32     LIKE ogb_file.ogb32
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_t1        LIKE oay_file.oayslip
DEFINE li_result   LIKE type_file.num5

   #取得出通單單別串oaybslip，抓出出貨單別oayb01，
   #呼叫s_auto_assign_no()取得出貨單號
   LET l_t1 = s_get_doc_no(g_no) 
   SELECT oayb01 INTO l_oayb01 FROM oayb_file WHERE oaybslip = l_t1
   
   INITIALIZE g_oga.* TO NULL
   LET g_oga.oga01 = l_oayb01
   LET g_oga.oga09 = '2'
   LET g_oga.oga011 = g_no
   
   CALL s_gen_so_oga_default()
   
   LET g_oga_u.* = g_oga.*
   
   SELECT * INTO g_oga.* FROM oga_file
    WHERE oga01 = g_oga.oga011 AND oga09 IN ('1','5')  
      AND ogaconf = 'Y' #通知
   IF STATUS THEN
      CALL cl_err3("sel","oga_file","g_oga.oga011","",SQLCA.SQLCODE,"","sel oga_file",1) 
      LET g_success = 'N'
      RETURN 
   END IF
   IF NOT cl_null(g_oga.oga16) THEN 
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM oea_file,oeb_file
       WHERE oea01 = oeb01
         AND oeb70 = 'N'
         AND oea01 = g_oga.oga16
      IF l_cnt = 0 THEN
         CALL cl_err(g_oga.oga16,'axm-169',1)
         LET g_success = 'N'
         RETURN 
      END IF
   END IF 
   
   LET g_oga.oga55 = ''     
   LET g_oga.oga99 = ''
   LET g_oga.oga905 = 'N'

   #保留原出貨單初值
   LET g_oga.oga09 = g_oga_u.oga09
   LET g_oga.oga01 = g_oga_u.oga01
   LET g_oga.oga69 = g_oga_u.oga69 
   LET g_oga.oga02 = g_oga_u.oga02
   LET g_oga.oga011 = g_oga_u.oga011
   LET g_oga.ogaconf = 'N'
   LET g_oga.ogapost = 'N'
   LET g_oga.oga903 = 'N'
   LET g_oga.ogauser = g_oga_u.ogauser
   LET g_oga.ogagrup = g_oga_u.ogagrup
   LET g_oga.ogamodu = g_oga_u.ogamodu
   LET g_oga.ogadate = g_oga_u.ogadate
   LET g_oga.ogamksg = g_oga_u.ogamksg  

   IF g_oga.oga08='1' THEN
      LET exT = g_oaz.oaz52
   ELSE
      LET exT = g_oaz.oaz70
   END IF

   IF g_oga.oga909 = 'Y' THEN
      CALL s_gen_so_chk_poz00() RETURNING exT  
   END IF 

   IF NOT cl_null(g_oga.oga021) THEN
      LET g_exdate = g_oga.oga021    #結關日期
   ELSE
      LET g_exdate = g_oga.oga02     #出貨日期
   END IF
   CALL s_curr3(g_oga.oga23,g_exdate,exT) RETURNING g_oga.oga24
   DECLARE x_ogb_cs CURSOR FOR 
      SELECT ogb31,ogb32 FROM ogb_file
       WHERE ogb01 = g_oga.oga01
   FOREACH x_ogb_cs INTO l_ogb31,l_ogb32
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
       WHERE oga01 = g_oga.oga011 
         AND oga01 = ogb01 AND oga09 IN ('1','5') 
         AND ogb31 = l_ogb31 AND ogb32 = l_ogb32
      #本訂單號不存在出貨通知單內
      IF l_cnt=0 AND l_ogb31[1,4] != 'MISC' THEN 
         LET g_msg = l_ogb31,'/',l_ogb32 CLIPPED
         CALL cl_err(g_msg,'axm-224',1) 
         LET g_success = 'N'
         RETURN 
      END IF
   END FOREACH
   #帶occ67科目別
   IF cl_null(g_oga.oga13) THEN 
      LET g_oga.oga13 = NULL
      SELECT occ67 INTO g_oga.oga13 FROM occ_file 
       WHERE occ01 = g_oga.oga03   
   END IF 

   CALL s_auto_assign_no("axm",g_oga.oga01,g_oga.oga69,"","oga_file","oga01","","","") 
     RETURNING li_result,g_oga.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF

   #重抓訂單檔的比率
   IF NOT cl_null(g_oga.oga16) THEN
      SELECT oea161,oea162,oea163
        INTO g_oga.oga161,g_oga.oga162,g_oga.oga163 FROM oea_file
       WHERE oea01 = g_oga.oga16
   END IF

   IF cl_null(g_oga.oga32) THEN
      SELECT occ45 INTO g_oga.oga32 FROM occ_file
       WHERE occ01 = g_oga.oga03
   END IF

   IF cl_null(g_oga.oga161) THEN LET g_oga.oga161 = 0 END IF
   IF cl_null(g_oga.oga162) THEN LET g_oga.oga162 = 100 END IF
   IF cl_null(g_oga.oga163) THEN LET g_oga.oga163 = 0 END IF
   IF cl_null(g_oga.oga85) THEN LET g_oga.oga85 = ' ' END IF 
   IF cl_null(g_oga.oga94) THEN LET g_oga.oga94 = 'N' END IF 
   LET g_oga.ogamksg = g_oay.oayapr
   LET g_oga.oga55 = '0'
   LET g_oga.ogaplant = g_plant 
   LET g_oga.ogalegal = g_legal  
   IF cl_null(g_oga.oga57) THEN
      LET g_oga.oga57 = '1'  
   END IF
   LET g_oga.ogaoriu = g_user     
   LET g_oga.ogaorig = g_grup      
   IF cl_null(g_oga.oga909) THEN LET g_oga.oga909 = 'N' END IF   
   IF cl_null(g_oga.ogaslk02) THEN LET g_oga.ogaslk02 = ' ' END IF 

   INSERT INTO oga_file VALUES (g_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","oga_file","g_oga.oga01","",SQLCA.SQLCODE,"","",1)  
      LET g_success = 'N'
      RETURN 
   END IF

END FUNCTION 

FUNCTION s_gen_so_ins_ogb()
DEFINE l_ogb12a   LIKE ogb_file.ogb12,
       l_ogb12b   LIKE ogb_file.ogb12
DEFINE l_ogb      RECORD LIKE ogb_file.*
DEFINE l_ogb912a  LIKE ogb_file.ogb912,
       l_ogb912b  LIKE ogb_file.ogb912,
       l_ogb915a  LIKE ogb_file.ogb915,
       l_ogb915b  LIKE ogb_file.ogb915,
       l_ogb917a  LIKE ogb_file.ogb917,
       l_ogb917b  LIKE ogb_file.ogb917
DEFINE l_ogbi     RECORD LIKE ogbi_file.* 
DEFINE l_n        LIKE type_file.num5     
DEFINE l_rvbs     RECORD LIKE rvbs_file.* 
DEFINE l_rvbs06a  LIKE rvbs_file.rvbs06  
DEFINE l_rvbs06b  LIKE rvbs_file.rvbs06 
DEFINE l_ogb05    LIKE ogb_file.ogb05   
DEFINE l_oeb70    LIKE oeb_file.oeb70   
DEFINE l_rtz04    LIKE rtz_file.rtz04  
DEFINE l_rtz06    LIKE rtz_file.rtz06  
DEFINE l_ima921   LIKE ima_file.ima921
DEFINE l_ima918   LIKE ima_file.ima918


   DELETE FROM ogb_tmp

   IF NOT cl_null(g_oga.oga011) AND NOT cl_null(g_oga.oga16) THEN
      INSERT INTO ogb_tmp
        SELECT * FROM ogb_file
         WHERE ogb01 = g_oga.oga011
           AND ogb31 = g_oga.oga16
   ELSE
      INSERT INTO ogb_tmp
        SELECT * FROM ogb_file
         WHERE ogb01 = g_oga.oga011
   END IF

   IF STATUS THEN
      CALL cl_err('into ogb_tmp',STATUS,1)
      LET g_success = 'N'
   END IF

   SELECT rtz04, rtz06 INTO l_rtz04,l_rtz06
     FROM rtz_file
    WHERE rtz01 = g_oga.ogaplant

   UPDATE ogb_tmp SET ogb01=g_oga.oga01
   IF STATUS THEN
      CALL cl_err3("upd","ogb_tmp","g_oga.oga01","",SQLCA.sqlcode,"","upd ogb_tmp",1) 
      LET g_success = 'N'
   END IF
   
   #出貨量要扣除未確認之出貨量
   DECLARE g_ogb_cs CURSOR FOR 
      SELECT * FROM ogb_tmp WHERE ogb01 = g_oga.oga01

   FOREACH g_ogb_cs INTO l_ogb.*
      #檢查出貨數必須<=通知單應出數(ogb12)-累計出貨數(ogb19)
      #對應到的出貨通知單上的數量
      LET l_ogb12a = 0
      LET l_ogb912a = 0   LET l_ogb915a = 0   LET l_ogb917a = 0
      SELECT SUM(ogb12),SUM(ogb912),SUM(ogb915),SUM(ogb917)
        INTO l_ogb12a,l_ogb912a,l_ogb915a,l_ogb917a
        FROM ogb_file,oga_file
       WHERE ogb01 = oga01 AND oga09 IN ('1','5')  
         AND oga01 = g_oga.oga011
         AND ogb03 = l_ogb.ogb03 
         AND ogb31 = l_ogb.ogb31
         AND ogb32 = l_ogb.ogb32
         AND ogb04 = l_ogb.ogb04 
         AND ogaconf != 'X'  

      IF cl_null(l_ogb12a)  THEN LET l_ogb12a = 0 END IF
      IF cl_null(l_ogb912a) THEN LET l_ogb912a= 0 END IF
      IF cl_null(l_ogb915a) THEN LET l_ogb915a= 0 END IF
      IF cl_null(l_ogb917a) THEN LET l_ogb917a= 0 END IF
       
      #此出貨通知單已耗用在出貨單的量
      LET l_ogb12b = 0
      LET l_ogb912b = 0   LET l_ogb915b = 0   LET l_ogb917b = 0
      SELECT SUM(ogb12),SUM(ogb912),SUM(ogb915),SUM(ogb917)
        INTO l_ogb12b,l_ogb912b,l_ogb915b,l_ogb917b
        FROM ogb_file,oga_file
         WHERE ogb01 = oga01 AND oga09 IN ('2','4','6') 
           AND oga011 = g_oga.oga011
           AND ogb03 = l_ogb.ogb03 
           AND ogb31 = l_ogb.ogb31
           AND ogb32 = l_ogb.ogb32
           AND ogb04 = l_ogb.ogb04 
           AND ogaconf != 'X'  
      IF cl_null(l_ogb12b)  THEN LET l_ogb12b = 0 END IF
      IF cl_null(l_ogb912b) THEN LET l_ogb912b= 0 END IF
      IF cl_null(l_ogb915b) THEN LET l_ogb915b= 0 END IF
      IF cl_null(l_ogb917b) THEN LET l_ogb917b= 0 END IF
      
      LET l_ogb.ogb12 = l_ogb12a - l_ogb12b
      LET l_ogb.ogb912= l_ogb912a- l_ogb912b
      LET l_ogb.ogb915= l_ogb915a- l_ogb915b
      LET l_ogb.ogb917= l_ogb917a- l_ogb917b
      LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb.ogb15_fac
      LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15) 

     #IF g_azw.azw04 = '2' AND NOT s_industry("slk") THEN  #130419 mark
      IF g_azw.azw04 = '2' THEN                            #130419 add
         CALL s_gen_so_t620_sub(l_ogb.ogb04,l_rtz04,g_oga.oga213,l_ogb.ogb917,l_ogb.ogb13,t_azi04)
              RETURNING l_ogb.ogb14,l_ogb.ogb14t
      ELSE
         IF g_oga.oga213 = 'N' THEN
            LET l_ogb.ogb14 =l_ogb.ogb917*l_ogb.ogb13 
            LET l_ogb.ogb14t=l_ogb.ogb14*(1+g_oga.oga211/100)
         ELSE
            LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13 
            LET l_ogb.ogb14 =l_ogb.ogb14t/(1+g_oga.oga211/100)
         END IF
      END IF  
      CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14  
      CALL cl_digcut(l_ogb.ogb14t,t_azi04)RETURNING l_ogb.ogb14t 

      LET l_oeb70 = ''
      SELECT oeb70 INTO l_oeb70 FROM oeb_file
         WHERE oeb01 = l_ogb.ogb31
           AND oeb03 = l_ogb.ogb32
      IF l_oeb70 = 'Y' THEN 
         LET l_ogb.ogb12 = 0 
      END IF

      IF cl_null(l_ogb.ogb091) THEN
         LET l_ogb.ogb091 = ' '
      END IF
      IF cl_null(l_ogb.ogb092) THEN
         LET l_ogb.ogb092 = ' '
      END IF
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
      UPDATE ogb_tmp SET ogb12 = l_ogb.ogb12,
                         ogb16 = l_ogb.ogb16,
                         ogb1014 = 'N',     
                         ogb37 = l_ogb.ogb37, 
                         ogb13 = l_ogb.ogb13, 
                         ogb14 = l_ogb.ogb14,
                         ogb14t = l_ogb.ogb14t,
                         ogb912= l_ogb.ogb912, 
                         ogb915= l_ogb.ogb915, 
                         ogb917= l_ogb.ogb917, 
                         ogb091= l_ogb.ogb091, 
                         ogb092= l_ogb.ogb092, 
                         ogb50 = l_ogb.ogb50, 
                         ogb51 = l_ogb.ogb51, 
                         ogb52 = l_ogb.ogb52, 
                         ogb53 = l_ogb.ogb53, 
                         ogb54 = l_ogb.ogb54, 
                         ogb55 = l_ogb.ogb55  
       WHERE ogb01 = l_ogb.ogb01
         AND ogb03 = l_ogb.ogb03

      LET l_ima918 = ''  
      LET l_ima921 = ''  
      SELECT ima918,ima921 INTO l_ima918,l_ima921 
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
         AND imaacti = "Y"
      
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         DECLARE g_rvbs_cs CURSOR FOR 
            SELECT * FROM rvbs_file
             WHERE rvbs01 = g_oga.oga011
               AND rvbs02 = l_ogb.ogb03
         
         FOREACH g_rvbs_cs INTO l_rvbs.*
            IF SQLCA.SQLCODE THEN
               CALL cl_err('g_rvbs_cs:',SQLCA.SQLCODE,1)
               LET g_success = 'N' 
               RETURN  
            END IF
         
           #LET l_rvbs.rvbs00 = g_prog    #130419 mark
            LET l_rvbs.rvbs00 = 'axmt620' #130419 add
            LET l_rvbs.rvbs01 = g_oga.oga01
         
            #檢查出貨數必須 =通知單應出數-累計出貨數
            #對應到的出貨通知單上的數量
            LET l_rvbs06a = 0
            SELECT SUM(rvbs06) INTO l_rvbs06a
              FROM rvbs_file
             WHERE rvbs01 = g_oga.oga011
               AND rvbs02 = l_ogb.ogb03
               AND rvbs13 = l_rvbs.rvbs13  
               AND rvbs09 = -1   
               AND rvbs022 = l_rvbs.rvbs022  
            
            IF cl_null(l_rvbs06a) THEN
               LET l_rvbs06a = 0
            END IF

            #此出貨通知單已耗用在出貨單的量
            LET l_rvbs06b = 0
            SELECT SUM(rvbs06) INTO l_rvbs06b
              FROM ogb_file,oga_file,rvbs_file
             WHERE ogb01 = oga01 AND oga09 IN ('2','4','6') 
               AND oga011 = g_oga.oga011
               AND ogb03 = l_ogb.ogb03
               AND oga01 = rvbs01
               AND ogb03 = rvbs02
               AND rvbs13 = l_rvbs.rvbs13 
               AND rvbs09 = -1  
               AND ogaconf != 'X' 
               AND rvbs022 = l_rvbs.rvbs022  

            IF cl_null(l_rvbs06b) THEN
               LET l_rvbs06b = 0
            END IF

            LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b

            LET l_rvbs.rvbsplant = g_plant 
            LET l_rvbs.rvbslegal = g_legal  
            IF l_rvbs.rvbs00 = 'axmt629' THEN
               LET l_rvbs.rvbs09 = -1 
            END IF
            
            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("ins","rvbs_file","","",SQLCA.SQLCODE,"","ins rvbs",1)
               LET g_success='N'
               RETURN  
            END IF
         
         END FOREACH
      END IF

   END FOREACH

   IF cl_null(l_ogb.ogb05_fac) THEN
     LET l_ogb.ogb05_fac = 1
   END IF

   IF cl_null(l_ogb.ogb12) THEN
     LET l_ogb.ogb12 = 0
   END IF
    
   IF cl_null(l_ogb.ogb37)  THEN           
      LET l_ogb.ogb37= 0                        
   END IF                                                                             
   
   IF cl_null(l_ogb.ogb13) THEN
     LET l_ogb.ogb13 = 0
   END IF

   IF cl_null(l_ogb.ogb14) THEN
     LET l_ogb.ogb14 = 0
   END IF

   IF cl_null(l_ogb.ogb14t) THEN
     LET l_ogb.ogb14t = 0
   END IF

   IF cl_null(l_ogb.ogb15_fac) THEN
      LET l_ogb.ogb15_fac = 1
   END IF

   IF cl_null(l_ogb.ogb16) THEN
      LET l_ogb.ogb16 = 0
   END IF

   IF cl_null(l_ogb.ogb18) THEN
      LET l_ogb.ogb18 = 0
   END IF

   IF cl_null(l_ogb.ogb60) THEN
      LET l_ogb.ogb60 = 0
   END IF

   IF cl_null(l_ogb.ogb63) THEN
      LET l_ogb.ogb63 = 0
   END IF

   IF cl_null(l_ogb.ogb64) THEN
      LET l_ogb.ogb64 = 0
   END IF

   IF cl_null(l_ogb.ogb1006) THEN
      LET l_ogb.ogb1006 = 100
   END IF

   IF g_aza.aza115 = 'Y' THEN
      LET g_sql = " UPDATE ogb_tmp ",
                  "    SET ogb1001 = (SELECT ggc08 FROM ggc_file ",
                  "                    WHERE (ggc01 = substr(ogb01,1,instr(ogb01,'-')-1) OR ggc01 ='*') ",
                  "                      AND (ggc02 = substr(ogb31,1,instr(ogb31,'-')-1) OR trim(ogb31) IS NULL OR ggc02='*') ",
                  "                      AND (ggc04 = ogb04 OR trim(ogb04) IS NULL OR ggc04='*') ",
                  "                      AND (ggc05 = ogb09 OR trim(ogb09) IS NULL OR ggc05='*') ",
                  "                      AND (ggc06 = '",g_oga.oga14,"' OR ",cl_null(g_oga.oga14),"=1 OR ggc06='*') ",
                  "                      AND (ggc07 = '",g_oga.oga15,"' OR ",cl_null(g_oga.oga15),"=1 OR ggc07='*') ",
                  "                      AND ggc09='Y' AND ggcacti='Y' AND rownum = 1) ",
                  "          WHERE  ogb12 > 0 OR ogb03 >=9001 "
      PREPARE upd_ogb_tmp FROM g_sql
      EXECUTE upd_ogb_tmp
   END IF 

   INSERT INTO ogb_file 
      SELECT * FROM ogb_tmp WHERE ogb12 > 0 OR ogb03 >=9001  
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ogb_file","","",SQLCA.sqlcode,"","ins ogb",1) 
      LET g_success = 'N'
      RETURN  
   ELSE
      INITIALIZE l_ogbi.* TO NULL
      DECLARE ins_ogbi2_cs CURSOR FOR   
       SELECT ogb01,ogb03                
         FROM ogb_tmp
        WHERE ogb12 > 0
           OR ogb03 >= 9001
      FOREACH ins_ogbi2_cs INTO l_ogbi.ogbi01,l_ogbi.ogbi03
         IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach ins_ogbi2_cs:',SQLCA.SQLCODE,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
           
         SELECT ogbiicd07 INTO l_ogbi.ogbiicd07
           FROM ogbi_file
          WHERE ogbi01 = g_oga.oga011
            AND ogbi03 = l_ogbi.ogbi03
        
        #130419 不考慮行業別先mark
        #IF NOT s_ins_ogbi(l_ogbi.*,g_plant) THEN  
        #   LET g_success = 'N'
        #   RETURN  
        #END IF
      END FOREACH   
   END IF
   CALL s_gen_so_ins_ogi(l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb917,l_ogb.ogb13) 

   # 多倉儲亦要轉
   DELETE FROM ogc_tmp 
   INSERT INTO ogc_tmp
     SELECT * FROM ogc_file WHERE ogc01 = g_oga.oga011 
   IF STATUS THEN
      CALL cl_err3("ins","ogc_tmp","g_oga.oga011","",SQLCA.sqlcode,"","into ogc_tmp",1)
      LET g_success='N'
      RETURN  
   END IF
   UPDATE ogc_tmp SET ogc01=g_oga.oga01
   IF STATUS THEN
      CALL cl_err3("upd","ogc_tmp","g_oga.oga01","",SQLCA.sqlcode,"","upd ogc_tmp",1)
      LET g_success='N'
      RETURN  
   END IF
   INSERT INTO ogc_file 
     SELECT * FROM ogc_tmp
      WHERE ogc03 IN (SELECT ogb03 FROM ogb_file WHERE ogb01=g_oga.oga01)
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err3("ins","ogc_file","","",SQLCA.sqlcode,"","ins ogc",1) 
      LET g_success='N'
      RETURN  
   END IF
    
   IF g_sma.sma115 = 'Y' THEN 
      DELETE FROM ogg_tmp
      INSERT INTO ogg_tmp
        SELECT * FROM ogg_file WHERE ogg01 = g_oga.oga011 
      IF STATUS THEN 
         CALL cl_err3("ins","ogg_tmp","g_oga.oga011","",SQLCA.sqlcode,"","into ogg_tmp",1)  
         LET g_success='N' 
         RETURN  
      END IF
      UPDATE ogg_tmp SET ogg01 = g_oga.oga01
      IF STATUS THEN 
         CALL cl_err3("upd","ogg_tmp","g_oga.oga01","",SQLCA.sqlcode,"","upd ogg_tmp",1)  
         LET g_success='N' 
         RETURN  
      END IF
      INSERT INTO ogg_file 
         SELECT * FROM ogg_tmp 
          WHERE ogg03 IN (SELECT ogb03 FROM ogb_file WHERE ogb01=g_oga.oga01)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","ogg_file","","",SQLCA.sqlcode,"","ins ogg",1)  
         LET g_success='N'
         RETURN  
      END IF
   END IF

   DELETE FROM oao_tmp
   INSERT INTO oao_tmp
     SELECT * FROM oao_file WHERE oao01 = g_oga.oga011 AND oao03 <> 0 
   UPDATE oao_tmp SET oao01 = g_oga.oga01
   DELETE FROM oao_file WHERE oao01 = g_oga.oga01 AND oao03 <> 0
   INSERT INTO oao_file SELECT * FROM oao_tmp
END FUNCTION 
 
FUNCTION s_gen_so_create_tmp()

   DROP TABLE oao_tmp
   SELECT * FROM oao_file WHERE 1=2 INTO TEMP oao_tmp 

   DROP TABLE ogb_tmp
   SELECT * FROM ogb_file WHERE 1=2 INTO TEMP ogb_tmp 

   DROP TABLE ogc_tmp
   SELECT * FROM ogc_file WHERE 1=2 INTO TEMP ogc_tmp 
   
   DROP TABLE ogg_tmp
   SELECT * FROM ogg_file WHERE 1=2 INTO TEMP ogg_tmp 
   
END FUNCTION 

FUNCTION s_gen_so_t620_sub(p_no,p_rtz04,p_oea213,p_oeb917,p_oeb13,t_azi04)
DEFINE p_no      LIKE rte_file.rte03    #产品编号
DEFINE p_rtz04   LIKE rtz_file.rtz04    #商品策略
DEFINE p_oea213  LIKE oea_file.oea213   #含税否
DEFINE p_oeb917  LIKE oeb_file.oeb917   #计价数量
DEFINE p_oeb13   LIKE oeb_file.oeb13    #单价
DEFINE t_azi04   LIKE azi_file.azi04    #金额小数位
DEFINE l_rtz06   LIKE rtz_file.rtz06    
DEFINE l_rvy04   LIKE rvy_file.rvy04
DEFINE l_gec04   LIKE gec_file.gec04
DEFINE l_gec07   LIKE gec_file.gec07
DEFINE l_rvy06   LIKE rvy_file.rvy06
DEFINE l_oeb14   LIKE oeb_file.oeb14
DEFINE l_oeb14t  LIKE oeb_file.oeb14t
DEFINE l_oeb14_1 LIKE oeb_file.oeb14
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sum_gec04 LIKE gec_file.gec04
DEFINE l_sql       STRING
DEFINE l_sum_rvy06 LIKE rvy_file.rvy06  

   IF NOT cl_null(p_rtz04) THEN
      LET l_sql = "SELECT rvy04,gec04,gec07,rvy06",
                  "  FROM rte_file",
                  " INNER JOIN rvy_file",
                  "    ON rte01 = rvy01",
                  "   AND rte02 = rvy02",
                  " INNER JOIN gec_file",
                  "    ON gec01 = rvy04",
                  "   AND rvy05 = gec011",
                  " WHERE rte01 = '",p_rtz04,"'",
                  "   AND rte03 = '",p_no,"'",
                  "   AND rte07 = 'Y'",
                  "   AND gec011 = '2'"  
      PREPARE sel_rvy_p FROM l_sql
      DECLARE sel_rvy_c CURSOR FOR sel_rvy_p
      LET l_oeb14_1 = p_oeb917 * p_oeb13             #计算售价
      LET l_sum_gec04 = 0
      LET l_sum_rvy06 = 0
      FOREACH sel_rvy_c INTO l_rvy04,l_gec04,l_gec07,l_rvy06
         #取單價含稅未稅價時,應用稅別資料維護檔內的含稅否
        #IF g_azw.azw04 = '2' AND NOT s_industry("slk") THEN #130419 mark
         IF g_azw.azw04 = '2' THEN                           #130419 add
            IF NOT cl_null(l_gec07) THEN
               LET p_oea213 = l_gec07   
            END IF
         END IF                                              
         IF NOT cl_null(l_rvy06) THEN
            LET l_oeb14_1 = l_oeb14_1 - l_rvy06*p_oeb917 #扣除固定税额
            LET l_sum_rvy06 = l_sum_rvy06 + l_rvy06*p_oeb917
         END IF
         LET l_sum_gec04 = l_sum_gec04 + l_gec04     #累加所有税率
      END FOREACH
      IF p_oea213 = 'Y' THEN
         LET l_oeb14t =  p_oeb917 * p_oeb13   #含税价
         CALL cl_digcut(l_oeb14t,t_azi04) RETURNING l_oeb14t
         LET l_oeb14 = l_oeb14_1 / (1 + l_sum_gec04/100)
         CALL cl_digcut(l_oeb14,t_azi04) RETURNING l_oeb14
      ELSE
         LET l_oeb14 = l_oeb14_1             #未税价
         CALL cl_digcut(l_oeb14,t_azi04) RETURNING l_oeb14
         LET l_oeb14t = l_oeb14 * (1 + l_sum_gec04/100) + l_sum_rvy06
         CALL cl_digcut(l_oeb14t,t_azi04) RETURNING l_oeb14t
      END IF
   ELSE
      IF p_oea213 = 'Y' THEN
         LET l_oeb14t =  p_oeb917 * p_oeb13   #含税价
         CALL cl_digcut(l_oeb14t,t_azi04) RETURNING l_oeb14t
         LET l_oeb14 = l_oeb14t / (1 + g_oga.oga211/100)
         CALL cl_digcut(l_oeb14,t_azi04) RETURNING l_oeb14
      ELSE
         LET l_oeb14 = p_oeb917 * p_oeb13     #未税价
         CALL cl_digcut(l_oeb14,t_azi04) RETURNING l_oeb14
         LET l_oeb14t = l_oeb14 * (1 + g_oga.oga211/100)
         CALL cl_digcut(l_oeb14t,t_azi04) RETURNING l_oeb14t
      END IF
   END IF
   RETURN l_oeb14,l_oeb14t
END FUNCTION

FUNCTION s_gen_so_chk_poz00()
DEFINE l_exT    LIKE oax_file.oax01,
       l_oea904 LIKE oea_file.oea904,
       l_poz00  LIKE poz_file.poz00

   IF NOT cl_null(g_oga.oga16) THEN 
      SELECT oea904 INTO l_oea904 
        FROM oea_file
       WHERE oea01 = g_oga.oga16
   ELSE
      DECLARE oea904_cs CURSOR FOR
         SELECT oea904 FROM ogb_file,oea_file
          WHERE ogb31 = oea01
            AND ogb01 = g_oga.oga01
      FOREACH oea904_cs INTO l_oea904
         EXIT FOREACH
      END FOREACH
   END IF 
 
   IF NOT cl_null(l_oea904) THEN
      SELECT poz011 INTO l_poz00   #先得到流程為銷售或代採參數
        FROM poz_file
       WHERE poz01=l_oea904
      IF l_poz00 = '1' THEN  #銷售
         LET l_exT = g_oax.oax01   
      ELSE
         LET l_exT = g_pod.pod01   #代採
      END IF
   ELSE 
      IF g_oga.oga09 ='4' THEN 
         LET l_exT = g_oax.oax01   
      END IF
      IF g_oga.oga09 ='6' THEN
         LET l_exT = g_pod.pod01   #代採
      END IF
      IF g_oga.oga09 ='5' THEN      #出通單
         LET l_exT = g_oax.oax01   
      END IF
   END IF 
 
   RETURN l_exT
END FUNCTION

FUNCTION s_gen_so_ins_ogi(p_ogb03,p_ogb04,p_ogb917,p_ogb13)
DEFINE p_ogb03     LIKE ogb_file.ogb03
DEFINE p_ogb04     LIKE ogb_file.ogb04
DEFINE p_ogb917    LIKE ogb_file.ogb917
DEFINE p_ogb13     LIKE ogb_file.ogb13
DEFINE l_rtz04     LIKE rtz_file.rtz04
DEFINE l_ogi       RECORD LIKE ogi_file.*
DEFINE l_sql       STRING
DEFINE l_sum_gec04 LIKE gec_file.gec04
DEFINE l_sum_rvy06 LIKE rvy_file.rvy06
DEFINE l_ogi08     LIKE ogi_file.ogi08
DEFINE l_ogi08_1   LIKE ogi_file.ogi08

   IF g_azw.azw04 = '2' THEN
      SELECT rtz04 INTO l_rtz04
        FROM rtz_file
       WHERE rtz01 = g_oga.ogaplant
      IF NOT cl_null(l_rtz04) THEN
         SELECT SUM(gec04),SUM(rvy06) INTO l_sum_gec04,l_sum_rvy06
            FROM rte_file 
           INNER JOIN rvy_file 
              ON rte01 = rvy01
             AND rte02 = rvy02
           INNER JOIN gec_file
              ON gec01 = rvy04
             AND rvy05 = gec011
           WHERE rte01 = l_rtz04
             AND rte03 = p_ogb04
             AND rte07 = 'Y' 
         IF cl_null(l_sum_gec04) THEN
            LET l_sum_gec04 = 0
         END IF 
         IF cl_null(l_sum_rvy06) THEN
            LET l_sum_rvy06 = 0
         END IF
         LET l_ogi08 = 0
         LET l_sql = "SELECT rvy04,gec04,gec07,rvy06",
                     "  FROM rte_file",
                     " INNER JOIN rvy_file",
                     "    ON rte01 = rvy01",
                     "   AND rte02 = rvy02",
                     " INNER JOIN gec_file",
                     "    ON gec01 = rvy04",
                     "   AND rvy05 = gec011",
                     " WHERE rte01 = '",l_rtz04,"'",
                     "   AND rte03 = '",p_ogb04,"'",
                     "   AND rte07 = 'Y'",
                     " ORDER BY gec04 desc,rvy06 asc"
          PREPARE sel_rvy_p_1 FROM l_sql
          DECLARE sel_rvy_c_1 CURSOR FOR sel_rvy_p_1
          FOREACH sel_rvy_c_1 INTO l_ogi.ogi04,l_ogi.ogi05,l_ogi.ogi07,l_ogi.ogi06
             IF SQLCA.sqlcode THEN
                CALL cl_err('foreach sel_rvy_c_1',SQLCA.SQLCODE,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_ogi.ogi01 = g_oga.oga01
             LET l_ogi.ogi02 = p_ogb03
             SELECT MAX(ogi03) + 1 INTO l_ogi.ogi03
               FROM ogi_file
              WHERE ogi01 = g_oga.oga01
                AND ogi02 = p_ogb03
             IF cl_null(l_ogi.ogi03) THEN
                LET l_ogi.ogi03 = 1
             END IF
             IF cl_null(l_ogi.ogi06) THEN
                LET l_ogi.ogi06 = 0
             END IF
             IF l_ogi.ogi07 = 'Y' THEN
                LET l_ogi.ogi08t = p_ogb917 * p_ogb13
                CALL cl_digcut(l_ogi.ogi08t,t_azi04) RETURNING l_ogi.ogi08t
                IF l_ogi08 = 0 THEN
                   LET l_ogi.ogi08 = (l_ogi.ogi08t - l_sum_rvy06*p_ogb917)/(1 + l_sum_gec04/100)
                   LET l_ogi08_1 = l_ogi.ogi08
                ELSE
                   LET l_ogi.ogi08 = l_ogi08
                END IF
                CALL cl_digcut(l_ogi.ogi08,t_azi04) RETURNING l_ogi.ogi08
                IF l_ogi.ogi06 = 0 THEN
                   LET l_ogi.ogi09 = l_ogi08_1 * l_ogi.ogi05/100
                ELSE
                   LET l_ogi.ogi09 = 0 
                END IF
                LET l_ogi.ogi08t = l_ogi.ogi08 + l_ogi.ogi09 + l_ogi.ogi06 * p_ogb917 
                CALL cl_digcut(l_ogi.ogi08t,t_azi04) RETURNING l_ogi.ogi08t
             ELSE
                IF l_ogi08 = 0 THEN
                   LET l_ogi.ogi08 = p_ogb917 * p_ogb13 - l_sum_rvy06*p_ogb917
                   LET l_ogi08_1 = l_ogi.ogi08
                ELSE
                   LET l_ogi.ogi08 = l_ogi08 
                END IF
                CALL cl_digcut(l_ogi.ogi08,t_azi04) RETURNING l_ogi.ogi08
                IF l_ogi.ogi06 = 0 THEN
                   LET l_ogi.ogi09 = l_ogi08_1 * l_ogi.ogi05/100
                ELSE
                   LET l_ogi.ogi09 = 0
                END IF
                LET l_ogi.ogi08t = l_ogi.ogi08 + l_ogi.ogi09 + l_ogi.ogi06 * p_ogb917
                CALL cl_digcut(l_ogi.ogi08t,t_azi04) RETURNING l_ogi.ogi08t
             END IF
             IF l_ogi.ogi06 > 0 THEN
                LET l_ogi.ogi09 = l_ogi.ogi06 * p_ogb917
             END IF
             CALL cl_digcut(l_ogi.ogi09,t_azi04) RETURNING l_ogi.ogi09
             LET l_ogi08 = l_ogi.ogi08t
             LET l_ogi.ogidate = g_today
             LET l_ogi.ogigrup = g_oga.ogagrup
             LET l_ogi.ogilegal = g_oga.ogalegal
             LET l_ogi.ogimodu = g_oga.ogamodu
             LET l_ogi.ogiorig = g_oga.ogaorig
             LET l_ogi.ogioriu = g_oga.ogaoriu
             LET l_ogi.ogiplant = g_oga.ogaplant
             LET l_ogi.ogiuser = g_oga.ogauser
             INSERT INTO ogi_file VALUES(l_ogi.*)
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("ins","ogi_file",l_ogi.ogi01,"",SQLCA.sqlcode,"","ins ogi:",1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
         END FOREACH
      ELSE
         LET l_ogi.ogi01 = g_oga.oga01
         LET l_ogi.ogi02 = p_ogb03
         SELECT MAX(ogi03) + 1 INTO l_ogi.ogi03
           FROM ogi_file
          WHERE ogi01 = g_oga.oga01
            AND ogi02 = p_ogb03
         IF cl_null(l_ogi.ogi03) THEN
            LET l_ogi.ogi03 = 1
         END IF
         LET l_ogi.ogi04 = g_oga.oga21
         LET l_ogi.ogi05 = g_oga.oga211
         LET l_ogi.ogi06 = 0
         LET l_ogi.ogi07 = g_oga.oga213
         IF g_oga.oga213 = 'Y' THEN
            LET l_ogi.ogi08t = p_ogb917 * p_ogb13
            CALL cl_digcut(l_ogi.ogi08t,t_azi04) RETURNING l_ogi.ogi08t
            LET l_ogi.ogi08 = l_ogi.ogi08t / (1 + g_oga.oga211/100)
            CALL cl_digcut(l_ogi.ogi08,t_azi04) RETURNING l_ogi.ogi08
         ELSE
            LET l_ogi.ogi08 = p_ogb917 * p_ogb13
            CALL cl_digcut(l_ogi.ogi08,t_azi04) RETURNING l_ogi.ogi08
            LET l_ogi.ogi08t = l_ogi.ogi08 * (1 + g_oga.oga211/100)
            CALL cl_digcut(l_ogi.ogi08t,t_azi04) RETURNING l_ogi.ogi08t
         END IF
         LET l_ogi.ogi09 = l_ogi.ogi08t - l_ogi.ogi08
         LET l_ogi.ogidate = g_today
         LET l_ogi.ogigrup = g_oga.ogagrup
         LET l_ogi.ogilegal = g_oga.ogalegal
         LET l_ogi.ogimodu = g_oga.ogamodu
         LET l_ogi.ogiorig = g_oga.ogaorig
         LET l_ogi.ogioriu = g_oga.ogaoriu
         LET l_ogi.ogiplant = g_oga.ogaplant
         LET l_ogi.ogiuser = g_oga.ogauser
         INSERT INTO ogi_file VALUES(l_ogi.*)
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL cl_err3("ins","ogi_file",l_ogi.ogi01,"",SQLCA.sqlcode,"","ins ogi:",1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION
#DEV-D30047 --add
