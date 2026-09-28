# Prog. Version..: '5.30.06-13.03.12(00000)'
#
# Pattern name...: cws_upd_axmt620.4gl
# Descriptions...: 一般出货单过账
# Date & Author..: 20161222 by gujq 

DATABASE ds                                               
                                                           
GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔  
    
GLOBALS
DEFINE g_ina01_1    LIKE ina_file.ina01  #杂发单号
DEFINE g_oga01_1    LIKE oga_file.oga01                   
DEFINE g_buf        LIKE type_file.chr2                      
DEFINE li_result    LIKE type_file.num5                      
DEFINE g_sql        STRING                                                                                     
DEFINE g_cnt        LIKE type_file.num5                       
DEFINE g_rec_b,g_rec_b1,g_rec_b2   LIKE type_file.num5     
DEFINE g_rec_b_1    LIKE type_file.num5                       
DEFINE l_ac         LIKE type_file.num10                      
DEFINE l_ac_t       LIKE type_file.num10                      
DEFINE li_step      LIKE type_file.num5
DEFINE g_oga_r   RECORD
                 oga01 LIKE oga_file.oga01
                 END RECORD                      
DEFINE g_uid        STRING          #add by lidj170109
DEFINE g_service    STRING          #add by lidj170109
DEFINE l_str        STRING          #add by lidj170109
DEFINE l_stime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_etime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_costtime INTERVAL HOUR TO FRACTION(3)
DEFINE l_stimestr STRING
DEFINE l_etimestr STRING
DEFINE l_logfile  STRING

DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036
DEFINE g_ima930  LIKE ima_file.ima930  #DEV-D30040 add
DEFINE g_ima906  LIKE ima_file.ima906  #MOD-C50088
DEFINE g_forupd_sql    STRING
DEFINE p_success1    LIKE type_file.chr1     #No.TQC-7C0114
DEFINE   g_flag          LIKE type_file.chr1          #No.FUN-730057
DEFINE   g_flag2         LIKE type_file.chr1          #FUN-C80107 add
DEFINE   g_msg         LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE g_inTransaction         LIKE type_file.chr1  #MOD-CA0131 add       
DEFINE g_ima918  LIKE ima_file.ima918  #No:FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No:FUN-810036
DEFINE g_ima930  LIKE ima_file.ima930  #DEV-D30059 add
DEFINE l_r       LIKE type_file.chr1   #No:FUN-860045
DEFINE g_check   LIKE type_file.chr1   #MOD-990097
DEFINE l_tmoga01 LIKE oga_file.oga01   #FUN-9B0039 mod
DEFINE g_rxx04_point LIKE rxx_file.rxx04         #抵現積分              #FUN-BA0069 add
DEFINE g_ogb1 DYNAMIC ARRAY OF RECORD                                                                                            
              ogb04  LIKE ogb_file.ogb04,                                                                                         
              ima02  LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021,
              ogb09  LIKE ogb_file.ogb09,
              ogb091 LIKE ogb_file.ogb091,
              ogb092 LIKE ogb_file.ogb092,
              img09  LIKE img_file.img09,
              qty    LIKE type_file.num5             
              END RECORD                                                                                                         
DEFINE g_ogb1_t  RECORD                                                                                            
              ogb04  LIKE ogb_file.ogb04,                                                                                         
              ima02  LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021,
              ogb09  LIKE ogb_file.ogb09,
              ogb091 LIKE ogb_file.ogb091,
              ogb092 LIKE ogb_file.ogb092,
              img09  LIKE img_file.img09,
              qty    LIKE type_file.num5                                                                                        
              END RECORD 
DEFINE l_ac1  LIKE type_file.num5 
DEFINE  g_oap041   LIKE oap_file.oap041   #tianry add 161221
DEFINE g_multi_ima01  STRING                 #FUN-AA0089  add
DEFINE g_rvbs   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  rvbs02  LIKE rvbs_file.rvbs02,
                  rvbs021 LIKE rvbs_file.rvbs021,
                  ima02a  LIKE ima_file.ima02,
                  ima021a LIKE ima_file.ima021,
                  rvbs022 LIKE rvbs_file.rvbs022,
                  rvbs04  LIKE rvbs_file.rvbs04,
                  rvbs03  LIKE rvbs_file.rvbs03,
                  rvbs05  LIKE rvbs_file.rvbs05,
                  rvbs06  LIKE rvbs_file.rvbs06,
                  rvbs07  LIKE rvbs_file.rvbs07,
                  rvbs08  LIKE rvbs_file.rvbs08,
                  rvbs13  LIKE rvbs_file.rvbs13
                END RECORD
DEFINE g_rec_b3           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac3              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
DEFINE l_ac7              LIKE type_file.num5
DEFINE g_rec_b7           LIKE type_file.num5
DEFINE g_rxe    DYNAMIC ARRAY OF RECORD
                  rxe02  LIKE rxe_file.rxe02,
                  rxe03  LIKE rxe_file.rxe03,
                  rxe04  LIKE rxe_file.rxe04,
                  rxe05  LIKE rxe_file.rxe05,
                  rxe06  LIKE rxe_file.rxe06,
                  lpx02  LIKE lpx_file.lpx02,
                  rxe07  LIKE rxe_file.rxe07,
                  lrz02  LIKE lrz_file.lrz02,
                  rxe08  LIKE rxe_file.rxe08,
                  rxe09  LIKE rxe_file.rxe09
                END RECORD
DEFINE g_rxe_t  RECORD
                  rxe02  LIKE rxe_file.rxe02,
                  rxe03  LIKE rxe_file.rxe03,
                  rxe04  LIKE rxe_file.rxe04,
                  rxe05  LIKE rxe_file.rxe05,
                  rxe06  LIKE rxe_file.rxe06,
                  lpx02  LIKE lpx_file.lpx02,
                  rxe07  LIKE rxe_file.rxe07,
                  lrz02  LIKE lrz_file.lrz02,
                  rxe08  LIKE rxe_file.rxe08,
                  rxe09  LIKE rxe_file.rxe09
                END RECORD
DEFINE g_rec_b4          LIKE type_file.num5
DEFINE g_wc4             STRING
DEFINE g_sal             LIKE type_file.chr4
DEFINE g_flag_chk        LIKE type_file.chr1
DEFINE g_flag3           LIKE type_file.chr1  
DEFINE g_ogb04_1         LIKE ogb_file.ogb04
DEFINE g_oga_l     DYNAMIC ARRAY OF RECORD
                    oga00      LIKE oga_file.oga00,
                    oga08      LIKE oga_file.oga08,   
                    oga01      LIKE oga_file.oga01,
                    oga02      LIKE oga_file.oga02,
                    oga011      LIKE oga_file.oga011,
                    oga16      LIKE oga_file.oga16,                    
                    oga03      LIKE oga_file.oga03,
                    oga032     LIKE oga_file.oga032,
                    oga14      LIKE oga_file.oga14,
                    gen02      LIKE gen_file.gen02,
                    oga15      LIKE oga_file.oga15,
                    gem02      LIKE gem_file.gem02,
                    oga55      LIKE oga_file.oga55,
                    ogaconf    LIKE oga_file.ogaconf,
                    ogapost    LIKE oga_file.ogapost,
                    ogaud04    LIKE oga_file.ogaud04,
                    ogaud05    LIKE oga_file.ogaud05  #add by huanglf170204
                    END RECORD,
       l_ac2         LIKE type_file.num5,
       g_rec_b8      LIKE type_file.num5
DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
DEFINE g_ogb05_t            LIKE ogb_file.ogb05     #No.FUN-BB0086
DEFINE g_ogb910_t           LIKE ogb_file.ogb910   #No.FUN-BB0086
DEFINE g_ogb913_t           LIKE ogb_file.ogb913   #No.FUN-BB0086
DEFINE g_ogb916_t           LIKE ogb_file.ogb916   #No.FUN-BB0086
DEFINE g_oah08              LIKE oah_file.oah08  #FUN-C40089 
DEFINE g_flag2              LIKE type_file.chr1     #FUN-C80107  add
DEFINE g_loc_flag         LIKE type_file.chr1 
DEFINE g_can_flag         LIKE type_file.chr1 
DEFINE d_ogb     DYNAMIC ARRAY OF RECORD
                 ogb03     LIKE ogb_file.ogb03,
                 ogb31     LIKE ogb_file.ogb31,
                 ogb32     LIKE ogb_file.ogb32,
                 ogb04     LIKE ogb_file.ogb04,
                 ogb06     LIKE ogb_file.ogb06,
                 ogb05     LIKE ogb_file.ogb05,
                 ogb12     LIKE ogb_file.ogb12,
                 ogb913    LIKE ogb_file.ogb913,
                 ogb914    LIKE ogb_file.ogb911,
                 ogb915    LIKE ogb_file.ogb915,
                 ogb910    LIKE ogb_file.ogb910,
                 ogb911    LIKE ogb_file.ogb911,
                 ogb912    LIKE ogb_file.ogb912,
                 ogb916    LIKE ogb_file.ogb916,
                 ogb917    LIKE ogb_file.ogb917,
                 ogb17     LIKE ogb_file.ogb17, 
                 ogb09     LIKE ogb_file.ogb09,
                 ogb091    LIKE ogb_file.ogb091,
                 ogb092    LIKE ogb_file.ogb092
                 END RECORD,
       d_ogb_t   RECORD
                 ogb03     LIKE ogb_file.ogb03,
                 ogb31     LIKE ogb_file.ogb31,
                 ogb32     LIKE ogb_file.ogb32,
                 ogb04     LIKE ogb_file.ogb04,
                 ogb06     LIKE ogb_file.ogb06,
                 ogb05     LIKE ogb_file.ogb05,
                 ogb12     LIKE ogb_file.ogb12,
                 ogb913    LIKE ogb_file.ogb913,
                 ogb914    LIKE ogb_file.ogb911,
                 ogb915    LIKE ogb_file.ogb915,
                 ogb910    LIKE ogb_file.ogb910,
                 ogb911    LIKE ogb_file.ogb911,
                 ogb912    LIKE ogb_file.ogb912,
                 ogb916    LIKE ogb_file.ogb916,
                 ogb917    LIKE ogb_file.ogb917,
                 ogb17     LIKE ogb_file.ogb17,  
                 ogb09     LIKE ogb_file.ogb09,
                 ogb091    LIKE ogb_file.ogb091,
                 ogb092    LIKE ogb_file.ogb092
                 END RECORD
DEFINE  g_flag1  LIKE type_file.chr1  #add by huanglf160922
DEFINE g_oga         RECORD LIKE oga_file.*
DEFINE g_ogb         RECORD LIKE ogb_file.*
DEFINE g_oha         RECORD LIKE oha_file.*
DEFINE g_ohb         RECORD LIKE ohb_file.*
DEFINE g_sql         LIKE type_file.chr1000
DEFINE g_rvu04       LIKE rvu_file.rvu04
DEFINE g_rvc         RECORD LIKE rvc_file.*
DEFINE g_rvg         RECORD
                   rvg03    LIKE rvg_file.rvg03,
                   ogb04    LIKE ogb_file.ogb04,
                   ogb05    LIKE ogb_file.ogb05,
                   rvg08    LIKE rvg_file.rvg08,
                   ogb14t   LIKE ogb_file.ogb14t
                     END RECORD
DEFINE g_rvv39t      LIKE rvv_file.rvv39t
DEFINE g_rvf08       LIKE rvf_file.rvf08
DEFINE g_rvu114      LIKE rvu_file.rvu114
DEFINE g_rvv17       LIKE rvv_file.rvv17
DEFINE g_alter_date  LIKE type_file.dat   #TQC-B90235 Add
DEFINE g_azw01       LIKE azw_file.azw01  #TQC-BB0161 add 
DEFINE g_azw02       LIKE azw_file.azw02  #TQC-BB0161 add  
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
DEFINE g_ima906  LIKE ima_file.ima906  #MOD-C50088
DEFINE g_forupd_sql    STRING
DEFINE g_rxx04_point LIKE rxx_file.rxx04         #抵現積分              #FUN-BA0069 add
DEFINE g_oah08         LIKE oah_file.oah08     #FUN-C40089 
DEFINE g_inTransaction         LIKE type_file.chr1  #MOD-CA0131 add
END GLOBALS               

#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION t600sub_lock_cl()
   LET g_forupd_sql = "SELECT * FROM oga_file WHERE oga01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600sub_cl CURSOR FROM g_forupd_sql
END FUNCTION


FUNCTION t600sub_imm(p_oga01)
   DEFINE p_oga01  LIKE oga_file.oga01
   DEFINE l_oga    RECORD LIKE oga_file.*
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_imm    RECORD LIKE imm_file.*
   DEFINE l_imn    RECORD LIKE imn_file.*
   DEFINE l_sql    STRING
   DEFINE li_result LIKE type_file.num5
   DEFINE l_msg    STRING
   DEFINE l_imm03  LIKE imm_file.imm03
   DEFINE l_tot    LIKE oeb_file.oeb24
   DEFINE l_tot1   LIKE oeb_file.oeb24
   DEFINE l_ocn03  LIKE ocn_file.ocn03
   DEFINE l_ocn04  LIKE ocn_file.ocn04
   DEFINE l_cnt    LIKE type_file.num5  #FUN-930038
   DEFINE l_idb    RECORD LIKE idb_file.*      #FUN-930038
   DEFINE l_flag   LIKE type_file.num5   #MOD-950143
   DEFINE l_fac    LIKE type_file.num26_10  #MOD-950143
   DEFINE l_ogg    RECORD LIKE ogg_file.*   #MOD-A70150
   DEFINE l_ogc    RECORD LIKE ogc_file.*   #MOD-A70150
   DEFINE l_ima906 LIKE ima_file.ima906     #MOD-A70150
   DEFINE l_rvbs   RECORD LIKE rvbs_file.*   #MOD-AC0060
   DEFINE l_imni   RECORD LIKE imni_file.*   #FUN-B70074
 
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01
   IF cl_null(l_oga.oga01) THEN
      CALL cl_err('',-400,0)
      RETURN ""
   END IF
 
   BEGIN WORK
 
   LET g_success = "Y"
 
   LET l_imm.imm12=""         #MOD-A60070 add

   CALL s_auto_assign_no("aim",g_oaz.oaz79,l_oga.oga02,"","imm_file",  #NO.CHI-780041   #MOD-870201
                         "imm01","","","")
               RETURNING li_result,l_imm.imm01
   IF (NOT li_result) THEN
      LET g_success = "N"
      ROLLBACK WORK   #MOD-C50142 add
      RETURN ""       #MOD-C50142 add
   END IF
 
   LET l_imm.imm02 = l_oga.oga02   #MOD-860190
   LET l_imm.imm03 = "N"
   LET l_imm.imm10 = "1"
   LET l_imm.imm14 = g_grup
   LET l_imm.immconf = "Y"
   LET l_imm.imm09 = p_oga01       #FUN-870136
   LET l_imm.immuser=g_user
   LET l_imm.immgrup=g_grup
   LET l_imm.immdate=g_today
   LET l_imm.immplant = l_oga.ogaplant  #No.FUN-870007
   LET l_imm.immlegal = l_oga.ogalegal  #No.FUN-870007
 
   LET l_imm.immplant = g_plant 
   LET l_imm.immlegal = g_legal 
 
   LET l_imm.immoriu = g_user      #No.FUN-980030 10/01/04
   LET l_imm.immorig = g_grup      #No.FUN-980030 10/01/04
   #FUN-A60034--add---str---
   #FUN-A70104--mod---str---
   LET l_imm.immmksg = 'N'          #是否簽核
   LET l_imm.imm15 = '1'            #簽核狀況  #MOD-CA0203 mod
   LET l_imm.imm16 = l_oga.oga14    #申請人
   #FUN-A70104--mod---end---
   #FUN-A60034--add---end---
   INSERT INTO imm_file VALUES (l_imm.*)
   IF STATUS THEN
      LET g_success = "N"
   END IF
 
   LET l_sql = "SELECT * FROM ogb_file WHERE ogb01='",p_oga01,"'"
 
   PREPARE pre_imn FROM l_sql
   DECLARE imn_curs CURSOR FOR pre_imn
 
   FOREACH imn_curs INTO l_ogb.*
      #MOD-D10185 add start -----
      IF l_ogb.ogb04[1,4] = 'MISC' THEN
         CONTINUE FOREACH
      END IF
      #MOD-D10185 add start -----
      #-----MOD-A70150---------
      IF l_ogb.ogb17 = 'Y' THEN
         IF g_sma.sma115 = 'Y' THEN
            LET l_sql = "SELECT * FROM ogg_file ",
                        " WHERE ogg01 = '",l_oga.oga01,"'",
                        "   AND ogg03 = ",l_ogb.ogb03
            PREPARE pre_ogg FROM l_sql
            DECLARE ogg_curs CURSOR FOR pre_ogg
            FOREACH ogg_curs INTO l_ogg.*
               IF cl_null(l_ogg.ogg17) THEN
                  LET l_ogg.ogg17 = l_ogb.ogb04  
               END IF
               LET l_imn.imn01 = l_imm.imm01
               SELECT MAX(imn02) + 1 INTO l_imn.imn02
                 FROM imn_file WHERE imn01 = l_imm.imm01
               IF l_imn.imn02 IS NULL THEN
                  LET l_imn.imn02 = 1
               END IF
               LET l_imn.imn03 = l_ogg.ogg17
               LET l_imn.imn04 = l_ogg.ogg09
               LET l_imn.imn05 = l_ogg.ogg091
               LET l_imn.imn06 = l_ogg.ogg092
               #MOD-B90118 --- start ---
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn04 
                   AND img03 = l_imn.imn05
                   AND img04 = l_imn.imn06

               IF l_cnt <= 0 THEN
                  CALL s_add_img(l_imn.imn03,l_imn.imn04,
                                 l_imn.imn05,l_imn.imn06,
                                 l_imm.imm01,l_imn.imn02,l_imm.imm02)
                  IF g_errno='N' THEN
                     LET g_success = 'N'
                  END IF
               END IF
               #MOD-B90118 ---  end  ---
               SELECT img09 INTO l_imn.imn09 FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn04 
                   AND img03 = l_imn.imn05
                   AND img04 = l_imn.imn06
               CALL s_umfchk(l_imn.imn03,l_ogg.ogg10,l_imn.imn09)
                     RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET l_fac = 1
               END IF
               LET l_imn.imn10 = l_ogg.ogg12 * l_fac
               LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #FUN-BB0084
               LET l_ima906 = ''
               SELECT ima906 INTO l_ima906 FROM ima_file 
                 WHERE ima01=l_imn.imn03
               IF l_ima906 = '3' AND l_ogg.ogg20 = '2' THEN
                  LET l_imn.imn10 = 0
               END IF
               LET l_imn.imn28 = l_ogb.ogb1001
               LET l_imn.imn29 = "N"
               IF l_ogg.ogg20 = 1 THEN 
                  LET l_imn.imn30 = l_ogg.ogg10
                  CALL s_du_umfchk(l_imn.imn03,'','','',
                                   l_imn.imn09,l_imn.imn30,'1')
                       RETURNING g_errno,l_imn.imn31
                  LET l_imn.imn32 = l_ogg.ogg12
                  LET l_imn.imn33 = ""
                  LET l_imn.imn34 = 0
                  LET l_imn.imn35 = 0
               ELSE
                  LET l_imn.imn30 = ""
                  LET l_imn.imn31 = 0
                  LET l_imn.imn32 = 0
                  LET l_imn.imn33 = l_ogg.ogg10
                  CALL s_du_umfchk(l_imn.imn03,'','','',
                                   l_imn.imn09,l_imn.imn33,'2')
                       RETURNING g_errno,l_imn.imn34
                  LET l_imn.imn35 = l_ogg.ogg12
               END IF
               LET l_imn.imn15 = g_oaz.oaz78
               LET l_imn.imn16 = " "    
               LET l_imn.imn17 = l_oga.oga03
               IF (NOT cl_null(l_imn.imn03)) 
                 AND (NOT cl_null(l_imn.imn15)) THEN 
                 SELECT * FROM img_file
                  WHERE img01=l_imn.imn03
                    AND img02=l_imn.imn15
                    AND img03=l_imn.imn16
                    AND img04=l_imn.imn17
                 IF STATUS=100 THEN
                    IF NOT cl_confirm('mfg1401') THEN
                       LET g_success = 'N'
                    ELSE
                       CALL s_add_img(l_imn.imn03,l_imn.imn15,
                                       l_imn.imn16,l_imn.imn17,
                                       l_imm.imm01,l_imn.imn02,l_imm.imm02)
                       IF g_errno='N' THEN
                           LET g_success = 'N'
                       END IF
                    END IF
                 END IF
               END IF
               SELECT img09 INTO l_imn.imn20 FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn15 
                   AND img03 = l_imn.imn16
                   AND img04 = l_imn.imn17
               IF l_ima906 = '2' OR (l_ima906 = '3' AND l_ogg.ogg20 = '2') THEN    
                  IF (NOT cl_null(l_imn.imn03)) 
                    AND (NOT cl_null(l_imn.imn15)) THEN 
                    CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                                    l_imn.imn16,l_imn.imn17,
                                    l_ogg.ogg10) RETURNING g_flag
                   IF g_flag = 1 THEN
                      IF NOT cl_confirm('mfg1401') THEN
                         LET g_success = 'N'
                      ELSE
                         CALL s_umfchk(l_imn.imn03,l_ogg.ogg10,l_ogb.ogb05)
                               RETURNING l_flag,l_fac
                         CALL s_add_imgg(l_imn.imn03,l_imn.imn15,
                                         l_imn.imn16,l_imn.imn17,
                                         l_ogg.ogg10,l_fac,
                                         l_imm.imm01,
                                         l_imn.imn02,0) RETURNING g_flag
                         IF g_flag = 1 THEN
                             LET g_success = 'N'
                         END IF
                      END IF
                    END IF
                  END IF
                  SELECT imgg09 INTO l_imn.imn20 FROM imgg_file
                    WHERE imgg01 = l_imn.imn03  
                      AND imgg02 = l_imn.imn15 
                      AND imgg03 = l_imn.imn16
                      AND imgg04 = l_imn.imn17
               END IF
               IF l_ogg.ogg20 = 1 THEN 
                  LET l_imn.imn40 = l_ogg.ogg10
                  CALL s_du_umfchk(l_imn.imn03,'','','',
                                   l_imn.imn20,l_imn.imn40,'1')
                       RETURNING g_errno,l_imn.imn41
                  LET l_imn.imn42 = l_ogg.ogg12
                  LET l_imn.imn43 = ""
                  LET l_imn.imn44 = 0
                  LET l_imn.imn45 = 0
               ELSE
                  LET l_imn.imn40 = ""
                  LET l_imn.imn41 = 0
                  LET l_imn.imn42 = 0
                  LET l_imn.imn43 = l_ogg.ogg10
                  CALL s_du_umfchk(l_imn.imn03,'','','',
                                   l_imn.imn20,l_imn.imn43,'1')
                       RETURNING g_errno,l_imn.imn44
                  LET l_imn.imn45 = l_ogg.ogg12
               END IF
               IF l_ogg.ogg20 = 1 THEN 
                  CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn40)
                        RETURNING l_flag,l_imn.imn51
                  IF l_flag = 1 THEN
                     LET l_imn.imn51 = 1
                  END IF
                  LET l_imn.imn52 = 0 
               ELSE   
                  CALL s_umfchk(l_imn.imn03,l_imn.imn33,l_imn.imn43)
                        RETURNING l_flag,l_imn.imn52
                  IF l_flag = 1 THEN
                     LET l_imn.imn52 = 1
                  END IF
                  LET l_imn.imn51 = 0 
               END IF
               LET l_imn.imn9301 = s_costcenter(l_imm.imm14)
               LET l_imn.imn9302 = l_imn.imn9301
               CALL s_umfchk(l_imn.imn03,l_imn.imn09,l_imn.imn20)
                     RETURNING l_flag,l_imn.imn21
               IF l_flag = 1 THEN
                  LET l_imn.imn21 = 1
               END IF
               LET l_imn.imn22 = l_imn.imn10 * l_imn.imn21
               LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)      #FUN-BB0084 
               INSERT INTO imn_file VALUES (l_imn.*)
               IF STATUS THEN
                  LET g_success = "N"
               #FUN-B70074-add-str--
               ELSE 
                  IF NOT s_industry('std') THEN 
                     INITIALIZE l_imni.* TO NULL
                     LET l_imni.imni01 = l_imn.imn01
                     LET l_imni.imni02 = l_imn.imn02
                     IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN 
                        LET g_success = 'N'
                     END IF
                  END IF
               #FUN-B70074-add-end--
               END IF
               #-----MOD-AC0060---------
               LET g_ima918 = ''  
               LET g_ima921 = ''  
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = l_imn.imn03
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  DECLARE t600_rvbs_1 CURSOR FOR SELECT * FROM rvbs_file
                                                 WHERE rvbs01 = l_oga.oga01
                                                   AND rvbs02 = l_ogb.ogb03
                                                   AND rvbs13 = l_ogg.ogg18
                  FOREACH t600_rvbs_1 INTO l_rvbs.*
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
                  #MOD-B50204 add --start--    
                  DELETE FROM rvbs_file WHERE rvbs00 = 'aimt324'
                                          AND rvbs01 = l_imn.imn01
                                          AND rvbs02 = l_imn.imn02
                                          AND rvbs13 = 0
                                          AND rvbs09 = 1
                  DECLARE t600_rvbs_11 CURSOR FOR SELECT * FROM rvbs_file
                                                  WHERE rvbs00 = 'aimt324'
                                                    AND rvbs01 = l_imn.imn01
                                                    AND rvbs02 = l_imn.imn02
                                                    AND rvbs13 = 0
                                                    AND rvbs09 = -1
                  FOREACH t600_rvbs_11 INTO l_rvbs.*
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
                  #MOD-B50204 add --end--
               END IF
               #-----END MOD-AC0060-----

            END FOREACH
         ELSE
            LET l_sql = "SELECT * FROM ogc_file ",
                        " WHERE ogc01 = '",l_oga.oga01,"'",
                        "   AND ogc03 = ",l_ogb.ogb03
            PREPARE pre_ogc FROM l_sql
            DECLARE ogc_curs CURSOR FOR pre_ogc
            FOREACH ogc_curs INTO l_ogc.*
               LET l_imn.imn01 = l_imm.imm01
               SELECT MAX(imn02) + 1 INTO l_imn.imn02
                 FROM imn_file WHERE imn01 = l_imm.imm01
               IF l_imn.imn02 IS NULL THEN
                  LET l_imn.imn02 = 1
               END IF
               LET l_imn.imn03 = l_ogc.ogc17
               LET l_imn.imn04 = l_ogc.ogc09
               LET l_imn.imn05 = l_ogc.ogc091
               LET l_imn.imn06 = l_ogc.ogc092
               #MOD-B90118 --- start ---
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn04 
                   AND img03 = l_imn.imn05
                   AND img04 = l_imn.imn06

               IF l_cnt <= 0 THEN
                  CALL s_add_img(l_imn.imn03,l_imn.imn04,
                                 l_imn.imn05,l_imn.imn06,
                                 l_imm.imm01,l_imn.imn02,l_imm.imm02)
                  IF g_errno='N' THEN
                     LET g_success = 'N'
                  END IF
               END IF
               #MOD-B90118 ---  end  ---
               SELECT img09 INTO l_imn.imn09 FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn04 
                   AND img03 = l_imn.imn05
                   AND img04 = l_imn.imn06
               CALL s_umfchk(l_imn.imn03,l_ogb.ogb05,l_imn.imn09)
                     RETURNING l_flag,l_fac
               IF l_flag = 1 THEN
                  LET l_fac = 1
               END IF
               LET l_imn.imn10 = l_ogc.ogc12 * l_fac
               LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #FUN-BB0084
               LET l_imn.imn15 = g_oaz.oaz78
               LET l_imn.imn16 = " "    
               LET l_imn.imn17 = l_oga.oga03
               LET l_imn.imn28 = l_ogb.ogb1001
               LET l_imn.imn29 = "N"
               LET l_imn.imn30 = ""
               LET l_imn.imn31 = 0
               LET l_imn.imn32 = 0
               LET l_imn.imn33 = ""
               LET l_imn.imn34 = 0
               LET l_imn.imn35 = 0
               LET l_imn.imn40 = ""
               LET l_imn.imn41 = 0
               LET l_imn.imn42 = 0
               LET l_imn.imn43 = ""
               LET l_imn.imn44 = 0
               LET l_imn.imn45 = 0
               LET l_imn.imn51 = 0
               LET l_imn.imn52 = 0
               LET l_imn.imn9301 = s_costcenter(l_imm.imm14)
               LET l_imn.imn9302 = l_imn.imn9301
               IF (NOT cl_null(l_imn.imn03)) 
                 AND (NOT cl_null(l_imn.imn15))
                 THEN 
                 SELECT * FROM img_file
                  WHERE img01=l_imn.imn03
                    AND img02=l_imn.imn15
                    AND img03=l_imn.imn16
                    AND img04=l_imn.imn17
                 IF STATUS=100 THEN
                    IF NOT cl_confirm('mfg1401') THEN
                       LET g_success = 'N'
                    ELSE
                       CALL s_add_img(l_imn.imn03,l_imn.imn15,
                                       l_imn.imn16,l_imn.imn17,
                                       l_imm.imm01,l_imn.imn02,l_imm.imm02)
                       IF g_errno='N' THEN
                           LET g_success = 'N'
                       END IF
                    END IF
                 END IF
               END IF
               SELECT img09 INTO l_imn.imn20 FROM img_file
                 WHERE img01 = l_imn.imn03  
                   AND img02 = l_imn.imn15 
                   AND img03 = l_imn.imn16
                   AND img04 = l_imn.imn17
               CALL s_umfchk(l_imn.imn03,l_imn.imn09,l_imn.imn20)
                     RETURNING l_flag,l_imn.imn21
               IF l_flag = 1 THEN
                  LET l_imn.imn21 = 1
               END IF
               LET l_imn.imn22 = l_imn.imn10 * l_imn.imn21
               LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)    #FUN-BB0084 
               INSERT INTO imn_file VALUES (l_imn.*)
               IF STATUS THEN
                  LET g_success = "N"
               #FUN-B70074-add-str--
               ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_imni.* TO NULL
                     LET l_imni.imni01 = l_imn.imn01
                     LET l_imni.imni02 = l_imn.imn02
                     IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN
                        LET g_success = 'N'
                     END IF
                  END IF
               #FUN-B70074-add-end--
               END IF
               #-----MOD-AC0060---------
               LET g_ima918 = ''  
               LET g_ima921 = ''  
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = l_imn.imn03
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  DECLARE t600_rvbs_2 CURSOR FOR SELECT * FROM rvbs_file
                                                 WHERE rvbs01 = l_oga.oga01
                                                   AND rvbs02 = l_ogb.ogb03
                                                   AND rvbs13 = l_ogc.ogc18
                  FOREACH t600_rvbs_2 INTO l_rvbs.*
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
                  #MOD-B50204 add --start--
                  DELETE FROM rvbs_file WHERE rvbs00 = 'aimt324'
                                          AND rvbs01 = l_imn.imn01
                                          AND rvbs02 = l_imn.imn02
                                          AND rvbs13 = 0
                                          AND rvbs09 = 1
                  DECLARE t600_rvbs_22 CURSOR FOR SELECT * FROM rvbs_file
                                                  WHERE rvbs00 = 'aimt324'
                                                    AND rvbs01 = l_imn.imn01
                                                    AND rvbs02 = l_imn.imn02
                                                    AND rvbs13 = 0
                                                    AND rvbs09 = -1
                  FOREACH t600_rvbs_22 INTO l_rvbs.*
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
                  #MOD-B50204 add --end--
               END IF
               #-----END MOD-AC0060-----
            END FOREACH
         END IF
         CONTINUE FOREACH
      END IF
      #-----END MOD-A70150-----  

      LET l_imn.imn01 = l_imm.imm01
      IF s_industry('icd') THEN #for ICD 拋轉成的調撥單項次需和出貨單項次相同,以便後續扣帳還原時,能將調撥單的刻號/BIN資料拋轉回借貨單
         LET l_imn.imn02 = l_ogb.ogb03
      ELSE
         SELECT MAX(imn02) + 1 INTO l_imn.imn02
           FROM imn_file WHERE imn01 = l_imm.imm01
         IF l_imn.imn02 IS NULL THEN
            LET l_imn.imn02 = 1
         END IF
      END IF
 
      LET l_imn.imn03 = l_ogb.ogb04
      LET l_imn.imn04 = l_ogb.ogb09
      LET l_imn.imn05 = l_ogb.ogb091
      LET l_imn.imn06 = l_ogb.ogb092
      #MOD-B90118 --- start ---
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM img_file
       WHERE img01 = l_imn.imn03
         AND img02 = l_imn.imn04
         AND img03 = l_imn.imn05
         AND img04 = l_imn.imn06

      IF l_cnt <= 0 THEN
         CALL s_add_img(l_imn.imn03,l_imn.imn04,
                        l_imn.imn05,l_imn.imn06,
                        l_imm.imm01,l_imn.imn02,l_imm.imm02)
         IF g_errno='N' THEN
            LET g_success = 'N'
         END IF
      END IF
      #MOD-B90118 ---  end  ---
      SELECT img09 INTO l_imn.imn09 FROM img_file
        WHERE img01 = l_imn.imn03
          AND img02 = l_imn.imn04
          AND img03 = l_imn.imn05
          AND img04 = l_imn.imn06
      CALL s_umfchk(l_imn.imn03,l_ogb.ogb05,l_imn.imn09)
            RETURNING l_flag,l_fac
      IF l_flag = 1 THEN
         LET l_fac = 1
      END IF
      LET l_imn.imn10 = l_ogb.ogb12 * l_fac
      LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #FUN-BB0084
      LET l_imn.imn15 = g_oaz.oaz78
      LET l_imn.imn16 = " "
      LET l_imn.imn17 = l_oga.oga03
      LET l_imn.imn28 = l_ogb.ogb1001
      LET l_imn.imn29 = "N"
      #-----MOD-AC0023--------- 
      #LET l_imn.imn30 = l_ogb.ogb05
      #LET l_imn.imn31 = 1
      #LET l_imn.imn32 = l_ogb.ogb12
      #LET l_imn.imn33 = ""
      #LET l_imn.imn34 = 0
      #LET l_imn.imn35 = 0
      #LET l_imn.imn40 = l_ogb.ogb05
      #LET l_imn.imn41 = 1
      #LET l_imn.imn42 = l_imn.imn32
      #LET l_imn.imn43 = ""
      #LET l_imn.imn44 = 0
      #LET l_imn.imn45 = 0
      #LET l_imn.imn51 = 1
      #LET l_imn.imn52 = 0
      #-----END MOD-AC0023-----
      LET l_imn.imn9301 = s_costcenter(l_imm.imm14)
      LET l_imn.imn9302 = l_imn.imn9301
      LET l_imn.imnplant = l_ogb.ogbplant  #No.FUN-870007
      LET l_imn.imnlegal = l_ogb.ogblegal  #No.FUN-870007
      IF (NOT cl_null(l_imn.imn03))
        AND (NOT cl_null(l_imn.imn15))
        THEN
        SELECT * FROM img_file
         WHERE img01=l_imn.imn03
           AND img02=l_imn.imn15
           AND img03=l_imn.imn16
           AND img04=l_imn.imn17
        IF STATUS=100 THEN
           IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012
              IF NOT cl_confirm('mfg1401') THEN
                 LET g_success = 'N'
              ELSE
                 CALL s_add_img(l_imn.imn03,l_imn.imn15,
                                 l_imn.imn16,l_imn.imn17,
                                 l_imm.imm01,l_imn.imn02,l_imm.imm02)
                 IF g_errno='N' THEN
                     LET g_success = 'N'
                 END IF
              END IF
           END IF
        END IF
        #-----MOD-AC0023---------
        IF g_sma.sma115 = 'Y' THEN 
           LET l_ima906 = ''
           SELECT ima906 INTO l_ima906 FROM ima_file 
             WHERE ima01=l_imn.imn03
           IF l_ima906 = '2' THEN 
              CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                              l_imn.imn16,l_imn.imn17,
                              l_ogb.ogb910) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF NOT cl_confirm('mfg1401') THEN
                    LET g_success = 'N'
                 ELSE
                    CALL s_add_imgg(l_imn.imn03,l_imn.imn15,
                                    l_imn.imn16,l_imn.imn17,
                                    l_ogb.ogb910,l_ogb.ogb911,
                                    l_imm.imm01,
                                    l_imn.imn02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                        LET g_success = 'N'
                    END IF
                 END IF
              END IF
           END IF
           
           IF l_ima906 = '2' OR l_ima906 = '3' THEN 
              CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                              l_imn.imn16,l_imn.imn17,
                              l_ogb.ogb913) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF NOT cl_confirm('mfg1401') THEN
                    LET g_success = 'N'
                 ELSE
                    CALL s_add_imgg(l_imn.imn03,l_imn.imn15,
                                    l_imn.imn16,l_imn.imn17,
                                    l_ogb.ogb913,l_ogb.ogb914,
                                    l_imm.imm01,
                                    l_imn.imn02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                        LET g_success = 'N'
                    END IF
                 END IF
              END IF
           END IF
        END IF
        #-----END MOD-AC0023-----
      END IF
      SELECT img09 INTO l_imn.imn20 FROM img_file
       WHERE img01 = l_imn.imn03
         AND img02 = l_imn.imn15
         AND img03 = l_imn.imn16
         AND img04 = l_imn.imn17
      CALL s_umfchk(l_imn.imn03,l_imn.imn09,l_imn.imn20)
           RETURNING l_flag,l_imn.imn21
      IF l_flag = 1 THEN
         LET l_imn.imn21 = 1
      END IF
      LET l_imn.imn22 = l_imn.imn10 * l_imn.imn21
      LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)     #FUN-BB0084
      #-----MOD-AC0023---------
      LET l_imn.imn30 = l_ogb.ogb910
      CALL s_du_umfchk(l_imn.imn03,'','','',
                       l_imn.imn09,l_imn.imn30,'1')
           RETURNING g_errno,l_imn.imn31
      LET l_imn.imn32 = l_ogb.ogb912
      LET l_imn.imn33 = l_ogb.ogb913
      CALL s_du_umfchk(l_imn.imn03,'','','',
                       l_imn.imn09,l_imn.imn33,'2')
           RETURNING g_errno,l_imn.imn34
      LET l_imn.imn35 = l_ogb.ogb915
      LET l_imn.imn40 = l_ogb.ogb910
      CALL s_du_umfchk(l_imn.imn03,'','','',
                       l_imn.imn20,l_imn.imn40,'1')
           RETURNING g_errno,l_imn.imn41
      LET l_imn.imn42 = l_ogb.ogb912
      LET l_imn.imn43 = l_ogb.ogb913
      CALL s_du_umfchk(l_imn.imn03,'','','',
                       l_imn.imn20,l_imn.imn43,'1')
           RETURNING g_errno,l_imn.imn44
      LET l_imn.imn45 = l_ogb.ogb915
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
      #-----END MOD-AC0023-----
 
      LET l_imn.imnplant = g_plant 
      LET l_imn.imnlegal = g_legal 
 
      INSERT INTO imn_file VALUES (l_imn.*)
      IF STATUS THEN
         LET g_success = "N"
      #FUN-B70074-add-str--
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_imni.* TO NULL
            LET l_imni.imni01 = l_imn.imn01
            LET l_imni.imni02 = l_imn.imn02
            IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN
               LET g_success = 'N'
            END IF
         END IF
      #FUN-B70074-add-end--
      END IF

      #-----MOD-AC0060---------
      LET g_ima918 = ''  
      LET g_ima921 = ''  
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = l_imn.imn03
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         DECLARE t600_rvbs_3 CURSOR FOR SELECT * FROM rvbs_file
                                        WHERE rvbs01 = l_oga.oga01
                                          AND rvbs02 = l_ogb.ogb03
         FOREACH t600_rvbs_3 INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
      
            LET l_rvbs.rvbs00 = 'aimt324' 
            LET l_rvbs.rvbs01 = l_imn.imn01
            LET l_rvbs.rvbs02 = l_imn.imn02
      
            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
               LET g_success = 'N'
            END IF
         END FOREACH
         #MOD-B50204 add --start--
         DELETE FROM rvbs_file WHERE rvbs00 = 'aimt324'
                                 AND rvbs01 = l_imn.imn01
                                 AND rvbs02 = l_imn.imn02
                                 AND rvbs13 = 0
                                 AND rvbs09 = 1
         DECLARE t600_rvbs_33 CURSOR FOR SELECT * FROM rvbs_file
                                         WHERE rvbs00 = 'aimt324'
                                           AND rvbs01 = l_imn.imn01
                                           AND rvbs02 = l_imn.imn02
                                           AND rvbs13 = 0
                                           AND rvbs09 = -1
         FOREACH t600_rvbs_33 INTO l_rvbs.*
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
         #MOD-B50204 add --end--
      END IF
      #-----END MOD-AC0060-----
 
      #將借貨單刻號/BIN資料拋轉至調撥單
      IF s_industry('icd') THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM idb_file
                        WHERE idb07 = l_ogb.ogb01
                          AND idb08 = l_ogb.ogb03
         IF l_cnt > 0 THEN
            UPDATE idb_file SET idb07 = l_imn.imn01,
                                idb08 = l_imn.imn02
                          WHERE idb07 = l_ogb.ogb01
                            AND idb08 = l_ogb.ogb03
            IF SQLCA.sqlerrd[3] = 0 THEN
               LET g_success='N'
               EXIT FOREACH
            END IF
            SELECT * INTO l_idb.* FROM idb_file
                          WHERE idb07 = l_imn.imn01
                            AND idb08 = l_imn.imn02
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               EXIT FOREACH
            END IF
            #調撥入需產生ida資料
            IF NOT s_icdout_insicin(l_idb.*,l_imn.imn15,l_imn.imn16,l_imn.imn17) THEN
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
      END IF
 
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
      IF s_industry('icd') THEN 
        #LET l_msg="aimt324_icd '",l_imm.imm01,"' 'A'"        #FUN-A60034 mark
         LET l_msg="aimt324_icd '",l_imm.imm01,"' ' ' 'A'"    #FUN-A60034 add
      ELSE
        #LET l_msg="aimt324 '",l_imm.imm01,"' 'A'"            #FUN-A60034 mark
         LET l_msg="aimt324 '",l_imm.imm01,"' ' ' 'A'"        #FUN-A60034 add
      END IF  #FUN-920207
      CALL cl_cmdrun_wait(l_msg)
      RETURN l_imm.imm01
   ELSE
      ROLLBACK WORK
      RETURN ""
   END IF
 
 
END FUNCTION








FUNCTION t600_ins_lsn(l_oga)
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
#FUN-BC0071 --------------END








FUNCTION t620sub1_post(p_type,p_oga01)
   DEFINE p_oga01    LIKE oga_file.oga01
   DEFINE p_type     LIKE type_file.chr1
   DEFINE l_rty05    LIKE rty_file.rty05
#FUN-B60150 ADD - BEGIN ----------------------------
   DEFINE l_rvg      RECORD 
                   rvg02    LIKE rvg_file.rvg02,
                   rvg03    LIKE rvg_file.rvg03,
                   rvg04    LIKE rvg_file.rvg04,
                   rvg05    LIKE rvg_file.rvg05,
                   rvg06    LIKE rvg_file.rvg06,
                   ogb04    LIKE ogb_file.ogb04,
                   ogb05    LIKE ogb_file.ogb05,
                   ogb14t   LIKE ogb_file.ogb14t,
                   rvg08    LIKE rvg_file.rvg08
                  END RECORD
   DEFINE l_ogb12  LIKE ogb_file.ogb12
#FUN-B60150 ADD -  END  ----------------------------


   WHENEVER ERROR CONTINUE

   IF cl_null(p_oga01) THEN RETURN END IF
   IF g_azw.azw04 <> '2' THEN RETURN END IF
   LET g_rvu04 = ''
   IF p_type = '1' THEN   #出貨單
      SELECT * INTO g_oga.* FROM  oga_file 
       WHERE oga01 = p_oga01
      LET g_alter_date = g_oga.oga02  #TQC-B90235 Add 
      LET g_azw01 = g_oga.ogaplant                #TQC-BB0161 add
      CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
      LET g_sql = "SELECT rty05,ogb_file.* FROM ogb_file,rty_file ",
                  " WHERE ogb01 = '",p_oga01,"'",
                  "   AND ogb44 = '3' ",
                  "   AND rty01 = '",g_oga.ogaplant,"'",
                  "   AND rty02 = ogb04 ",
                  " ORDER BY rty05 "
      PREPARE t620sub1_sel_ogb FROM g_sql
      DECLARE t620sub1_sel_ogb_c CURSOR FOR t620sub1_sel_ogb
      FOREACH t620sub1_sel_ogb_c INTO l_rty05,g_ogb.*
        #产生杂发/杂收单
         CALL t620sub1_insinainb(p_type)
         IF g_success = 'N' THEN RETURN END IF
        
        #产生入库单
        #FUN-BB0072 Add Begin ---
        #根據出貨金額，若為正產生入庫單，反之則產生倉退單
         IF g_ogb.ogb14t > 0 THEN
        #FUN-BB0072 Add End -----
            CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
        #FUN-BB0072 Add Begin ---
         ELSE
            CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
         END IF
        #FUN-BB0072 Add End -----
         IF g_success = 'N' THEN RETURN END IF
      END FOREACH
#FUN-B60150 - ADD - BEGIN -------------------------------------------
      IF g_sma.sma146 = '2' THEN
         INITIALIZE g_oga.* TO NULL
         SELECT * INTO g_oga.* FROM  oga_file
          WHERE oga01 = p_oga01
         LET g_azw01 = g_oga.ogaplant                #TQC-BB0161 add
         CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
         LET g_sql = "SELECT rty05,ogb_file.* FROM ogb_file,rty_file ",
                     " WHERE ogb01 = '",p_oga01,"'",
                     "   AND ogb44 = '2' ",
                     "   AND rty01 = '",g_oga.ogaplant,"'",
                     "   AND rty02 = ogb04 ",
                     " ORDER BY rty05 "
         PREPARE t620sub1_sel_ogb2 FROM g_sql
         DECLARE t620sub1_sel_ogb_c2 CURSOR FOR t620sub1_sel_ogb2
         FOREACH t620sub1_sel_ogb_c2 INTO l_rty05,g_ogb.*
           #- < 取採購協議中的單價 > -#
            SELECT rtt06t INTO g_ogb.ogb13 FROM rtt_file,rts_file,rto_file
             WHERE rts01 = rtt01 AND rts02 = rtt02 
               AND rttplant = rtsplant AND rttplant = g_oga.ogaplant
               AND rto01 = rts04 AND rtoplant = rtsplant
               AND rto05 = l_rty05 AND rtsacti = 'Y' AND rtsconf = 'Y'
               AND rto08<=g_oga.oga02 AND rto09>=g_oga.oga02 
               AND rtt04 = g_ogb.ogb04 AND rtt05 = g_ogb.ogb05 AND rtt15 = 'Y'
            LET g_ogb.ogb14t = g_ogb.ogb13 * g_ogb.ogb12
           #产生杂发/杂收单
            CALL t620sub1_insinainb(p_type)
            IF g_success = 'N' THEN RETURN END IF

           #产生入库单
           #FUN-BB0072 Add Begin ---
           #根據出貨金額，若為正產生入庫單，反之則產生倉退單
            IF g_ogb.ogb14t > 0 THEN
           #FUN-BB0072 Add End -----
               CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
           #FUN-BB0072 Add Begin ---
            ELSE
               CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
            END IF
           #FUN-BB0072 Add End -----
            IF g_success = 'N' THEN RETURN END IF
         END FOREACH
      END IF
   #TQC-BB0131 add START
      IF g_ogb.ogb44 = '3' OR (g_ogb.ogb44 = '2' AND g_sma.sma146 = '2') THEN
         CALL t620sub1_updruv13(p_oga01)
         IF g_success = 'N' THEN RETURN END IF
      END IF
   #TQC-BB0131 add END
#FUN-B60150 - ADD -  END  -------------------------------------------
  #ELSE                  #FUN-B60150 MARK
   END IF                #FUN-B60150 ADD
   IF p_type = '2' THEN  #FUN-B60150 ADD   #銷退
      SELECT * INTO g_oha.* FROM oha_file
      WHERE oha01 = p_oga01
      LET g_azw01 = g_oha.ohaplant                #TQC-BB0161 add
      CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
      LET g_alter_date = g_oha.oha02  #TQC-B90235 Add
      LET g_sql = " SELECT rty05,ohb_file.* FROM ohb_file,rty_file ",
                  " WHERE ohb01 = '",p_oga01,"'",
                  "   AND ohb64 = '3' ",
                  "   AND rty01 = '",g_oha.ohaplant,"'",
                  "   AND rty02 = ohb04 ",
                  " ORDER BY rty05 "
      PREPARE t620sub1_sel_ohb FROM g_sql
      DECLARE t620sub1_sel_ohb_c CURSOR FOR t620sub1_sel_ohb
      FOREACH t620sub1_sel_ohb_c INTO l_rty05,g_ohb.*
        #产生杂发/杂收单
         CALL t620sub1_insinainb(p_type)
         IF g_success = 'N' THEN RETURN END IF
        
        #产生仓退单
        #FUN-BB0072 Add Begin ---
        #根據銷退金額，若為正產生倉退單，反之則產生入庫單
         IF g_ohb.ohb14t > 0 THEN
        #FUN-BB0072 Add End -----
            CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
        #FUN-BB0072 Add Begin ---
         ELSE
            CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
         END IF
        #FUN-BB0072 Add End -----
         IF g_success = 'N' THEN RETURN END IF
      END FOREACH
#FUN-B60150 - ADD - BEGIN -------------------------------------------
      IF g_sma.sma146 = '2' THEN
         INITIALIZE g_oha.* TO NULL
         SELECT * INTO g_oha.* FROM oha_file
         WHERE oha01 = p_oga01
         LET g_azw01 = g_oha.ohaplant                #TQC-BB0161 add
         CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
         LET g_sql = " SELECT rty05,ohb_file.* FROM ohb_file,rty_file ",
                     " WHERE ohb01 = '",p_oga01,"'",
                     "   AND ohb64 = '2' ",
                     "   AND rty01 = '",g_oha.ohaplant,"'",
                     "   AND rty02 = ohb04 ",
                     " ORDER BY rty05 "
         PREPARE t620sub1_sel_ohb2 FROM g_sql
         DECLARE t620sub1_sel_ohb_c2 CURSOR FOR t620sub1_sel_ohb2
         FOREACH t620sub1_sel_ohb_c2 INTO l_rty05,g_ohb.*
           #- < 取採購協議中的單價 > -#
            SELECT rtt06t INTO g_ohb.ohb13 FROM rtt_file,rts_file,rto_file
             WHERE rts01 = rtt01 AND rts02 = rtt02 
               AND rttplant = rtsplant AND rttplant = g_oha.ohaplant
               AND rto01 = rts04 AND rtoplant = rtsplant
               AND rto05 = l_rty05 AND rtsacti = 'Y' AND rtsconf = 'Y'
               AND rto08<=g_oha.oha02 AND rto09>=g_oha.oha02 
               AND rtt04 = g_ohb.ohb04 AND rtt05 = g_ohb.ohb05 AND rtt15 = 'Y'
            LET g_ohb.ohb14t = g_ohb.ohb13 * g_ohb.ohb12
           #产生杂发/杂收单
            CALL t620sub1_insinainb(p_type)
            IF g_success = 'N' THEN RETURN END IF

           #产生仓退单
           #FUN-BB0072 Add Begin ---
           #根據銷退金額，若為正產生倉退單，反之則產生入庫單
            IF g_ohb.ohb14t > 0 THEN
           #FUN-BB0072 Add End -----
               CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
            ELSE
               CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
            END IF
           #FUN-BB0072 Add End -----
            IF g_success = 'N' THEN RETURN END IF
         END FOREACH
      END IF
   #TQC-BB0131 add START
      IF g_ohb.ohb64 = '3' OR (g_ohb.ohb64 = '2' AND g_sma.sma146 = '2') THEN
         CALL t620sub1_updruv13(p_oga01)
         IF g_success = 'N' THEN RETURN END IF
      END IF
   #TQC-BB0131 add END
#FUN-B60150 - ADD -  END  -------------------------------------------
   END IF
#FUN-B60150 - ADD - BEGIN -------------------------------------------
   IF p_type = '3' THEN
      SELECT rvg02,rvg03,rvg04,rvg05,rvg06,ogb04,ogb05,ogb14t,rvg08
        FROM rvg_file,ogb_file
       WHERE 1=0
        INTO TEMP t620_rvg_temp
      DELETE FROM t620_rvg_temp
      SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01 = p_oga01
      LET g_alter_date = g_rvc.rvc05 #TQC-B90235 Add
      LET g_azw01 = g_rvc.rvcplant                #TQC-BB0161 add
      CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
      LET g_sql = " SELECT rvg02,rvg03,rvg04,rvg05,rvg06,'','','',rvg08,'' ",
               "   FROM rvg_file",
               "  WHERE rvg01='",g_rvc.rvc01,"' ",
               "    AND rvg00='2' AND rvg07='Y'"
      PREPARE t620_sel_rvg FROM g_sql
      DECLARE t620_sel_rvg_cs CURSOR FOR t620_sel_rvg
      FOREACH t620_sel_rvg_cs INTO l_rvg.*
         IF l_rvg.rvg04='1' THEN
            LET g_sql = "SELECT ogb04,ogb05,ogb14t,ogb12 ",
                        "   FROM ",cl_get_target_table(l_rvg.rvg03, 'ogb_file'),
                        "  WHERE ogb01 = '",l_rvg.rvg05,"'",
                        "    AND ogb03 = '",l_rvg.rvg06,"'"
         ELSE
            LET g_sql = "SELECT ohb04,ohb05,ohb14t*(-1),ohb12 ",
                        "   FROM ",cl_get_target_table(l_rvg.rvg03, 'ohb_file'),
                        "  WHERE ohb01 = '",l_rvg.rvg05,"'",
                        "    AND ohb03 = '",l_rvg.rvg06,"'"
         END IF
         PREPARE t620_sel_ogb FROM g_sql
         EXECUTE t620_sel_ogb INTO l_rvg.ogb04,l_rvg.ogb05,l_rvg.ogb14t,l_ogb12
         IF NOT cl_null(l_rvg.ogb14t) THEN
            LET l_rvg.ogb14t = l_rvg.ogb14t * l_rvg.rvg08 / l_ogb12
         END IF
         INSERT INTO t620_rvg_temp VALUES(l_rvg.rvg02,l_rvg.rvg03,l_rvg.rvg04,l_rvg.rvg05,
                                          l_rvg.rvg06,l_rvg.ogb04,l_rvg.ogb05,
                                          l_rvg.ogb14t,l_rvg.rvg08)
      END FOREACH
      UPDATE t620_rvg_temp SET rvg08 = rvg08 * (-1) WHERE rvg04='2'
      LET g_sql = " SELECT rvg03,ogb04,ogb05,SUM(rvg08),SUM(ogb14t) FROM t620_rvg_temp",
                  "  GROUP BY rvg03,ogb04,ogb05",
                  "  ORDER BY rvg03,ogb04,ogb05"
      PREPARE t620_sel_rvg_temp FROM g_sql
      DECLARE t620_sel_rvg_temp_cs CURSOR FOR t620_sel_rvg_temp

      FOREACH t620_sel_rvg_temp_cs INTO g_rvg.*
         SELECT rty05 INTO l_rty05 FROM rty_file WHERE rty01 = g_rvg.rvg03 AND rty02 = g_rvg.ogb04
         LET g_rvv39t = 0
         LET g_rvf08  = 0
         LET g_rvv17  = 0
         LET g_rvu114 = NULL
         LET g_sql = "SELECT SUM(CASE rvv03 WHEN '1' THEN rvv39t WHEN '3' THEN rvv39t*(-1) END),",
                     "       SUM(CASE rvv03 WHEN '1' THEN rvv17 WHEN '3' THEN rvv17*(-1) END),  ",
                     "       SUM(CASE rvv03 WHEN '1' THEN rvf08 WHEN '3' THEN rvf08*(-1) END),  ",
                     "       rvu114 ",
                     "  FROM rvv_file,rvf_file,rvu_file ",
                     " WHERE rvv01 = rvf05 AND rvv02 = rvf06 ",
                     "   AND rvf01 = '",g_rvc.rvc01,"' AND rvu01 = rvv01",
                     "   AND rvf00 = '2' AND rvv31 = '",g_rvg.ogb04,"' ",
                     " GROUP BY rvu114 "
         PREPARE t620_sel_sum_rvv_pre FROM g_sql
         EXECUTE t620_sel_sum_rvv_pre INTO g_rvv39t,g_rvv17,g_rvf08,g_rvu114
         IF cl_null(g_rvu114) THEN
           LET g_rvu114 = 1
         END IF
         LET g_rvv39t = g_rvv39t * g_rvf08 / g_rvv17
         LET g_prog = "apmt720"
         CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
         CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
         LET g_prog = "artt551"
      END FOREACH
   END IF
#FUN-B60150 - ADD -  END  -------------------------------------------
END FUNCTION






FUNCTION t600sub_muticarry(l_oga,l_poz)
   DEFINE l_argv0 LIKE ogb_file.ogb09
   DEFINE l_msg LIKE type_file.chr1000
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_poz RECORD LIKE poz_file.*
 
   LET l_argv0=l_oga.oga09  #FUN-730012
   IF l_poz.poz011='1' THEN   #正拋
      LET l_msg="axmp820 '",l_oga.oga01,"'"
   ELSE                       #逆拋
      #在逆拋必須先做庫存扣帳的動作
      LET l_msg="axmp900 '",l_oga.oga01,"' '",l_argv0,"'"
   END IF
   CALL cl_cmdrun_wait(l_msg CLIPPED)
   SELECT ogapost,oga99,oga905 INTO l_oga.ogapost,l_oga.oga99,l_oga.oga905
     FROM oga_file WHERE oga01=l_oga.oga01
   DISPLAY BY NAME l_oga.ogapost,l_oga.oga99,l_oga.oga905
END FUNCTION





FUNCTION t600sub_ar(l_oha)
   DEFINE l_oha RECORD LIKE oha_file.*
   DEFINE l_msg LIKE type_file.chr1000
 
   IF l_oha.ohaconf='N' THEN CALL cl_err('conf=N','aap-717',0) RETURN END IF
   IF l_oha.ohapost='N' THEN CALL cl_err('post=N','aim-206',0) RETURN END IF
   IF l_oha.oha10 IS NOT NULL THEN RETURN END IF
   IF cl_null(l_oha.oha09) OR l_oha.oha09 NOT MATCHES '[145]' THEN
      CALL cl_err(l_oha.oha09,'axr-063',0)
      RETURN
   END IF
   LET l_msg="axrp304 '",l_oha.oha01,"' '",l_oha.oha09,"' '",l_oha.ohaplant,"'"   #FUN-A60056
   CALL cl_cmdrun_wait(l_msg)
END FUNCTION



FUNCTION t600sub_gui(l_oga)
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_oma10 LIKE oma_file.oma10
   DEFINE l_msg LIKE type_file.chr1000
 
   IF l_oga.oga09='4' THEN  RETURN END IF               #MOD-CB0064 add
   IF l_oga.oga65='Y' THEN  RETURN END IF               #FUN-630102 add
   IF l_oga.oga00 MATCHES '[237]' THEN  RETURN END IF   #FUN-630102 add
   IF l_oga.ogapost='N' THEN CALL cl_err('post=N','axm-206',0) RETURN END IF
   LET l_msg="axrp310 ",
             " '",l_oga.oga01,"'",
             " '",l_oga.oga02,"'",
             " '",l_oga.oga05,"' '",l_oga.oga212,"'"
   CALL cl_cmdrun_wait(l_msg)
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01=l_oga.oga01
   DISPLAY BY NAME l_oga.oga24,l_oga.oga10
   LET l_oma10=NULL
   SELECT oma10 INTO l_oma10 FROM oma_file WHERE oma01=l_oga.oga10
   DISPLAY l_oma10 TO oma10
END FUNCTION







#FUNCTION t600_chk_ima262(p_ogb) #MOD-4A0232   #MOD-850309 #FUN-A20044  
FUNCTION t600_chk_avl_stk(p_ogb) #FUN-A20044  
  DEFINE l_oeb19   LIKE oeb_file.oeb19
#  DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk  LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_oeb12   LIKE oeb_file.oeb12
  DEFINE l_qoh     LIKE oeb_file.oeb12
  DEFINE l_qoh_2   LIKE oeb_file.oeb12      #MOD-C30033 add
  DEFINE p_ogb     RECORD LIKE ogb_file.*   #MOD-850309將該FUNCTION底下的b_ogb.*改為p_ogb.*

    #--訂單備置為'N',須check(庫存量ima262-sum(備置量oeb12-oeb24))>出貨量
    IF NOT cl_null(p_ogb.ogb31) AND NOT cl_null(p_ogb.ogb32) THEN
       SELECT oeb19
         INTO l_oeb19
         FROM oeb_file
        WHERE oeb01 = p_ogb.ogb31
          AND oeb03 = p_ogb.ogb32
       IF STATUS THEN
          CALL cl_err3("sel","oeb_file",p_ogb.ogb31,p_ogb.ogb32,SQLCA.sqlcode,"","sel oeb:",1)  #No.FUN-670008
          LET g_success='N'
          RETURN
       END IF

      #IF l_oeb19 = 'N' THEN        #MOD-B50227 mark
       IF NOT cl_null(l_oeb19) THEN #MOD-B50227 
#          SELECT ima262
 #           INTO l_ima262
  #          FROM ima_file
   #        WHERE ima01=p_ogb.ogb04
    #      IF l_ima262 IS NULL THEN
    #          LET l_ima262 = 0
    #      END IF                            #FUN-A20044
          IF g_prog <> 'axmt628' THEN  #MOD-C20170 add
             CALL s_getstock(p_ogb.ogb04,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044  
         #MOD-C20170 add begin---------------------------
          ELSE
             LET g_sql = "SELECT SUM(img10*img21) ",
                         " FROM ", cl_get_target_table(g_plant, 'img_file'),
                         " WHERE img01 = '",p_ogb.ogb04,"' AND img23 = 'Y' ",
                         "   AND img02 = '",p_ogb.ogb09,"'",
                         "   AND img03 = '",p_ogb.ogb091,"'",
                         "   AND img04 = '",p_ogb.ogb092,"'"
             CALL cl_parse_qry_sql(g_sql,g_plant) RETURNING g_sql
             PREPARE avl_stk_pre FROM g_sql
             EXECUTE avl_stk_pre INTO l_avl_stk
          END IF
         #MOD-C20170 add end-----------------------------
          IF l_oeb19 = 'N' THEN #MOD-B50227 add
             SELECT SUM(oeb905*oeb05_fac)
               INTO l_oeb12
               FROM oeb_file,oea_file   #no.7182  #CHI-6B0036 add oea
              WHERE oeb04=p_ogb.ogb04
                AND oeb19= 'Y'
                AND oeb70= 'N'  #No.+149 010529 BY ANN CHEN
                AND oea01 = oeb01 AND oeaconf !='X' #CHI-6B0036
          #MOD-B50227 add --start
          ELSE
             SELECT SUM(oeb905*oeb05_fac)
               INTO l_oeb12
               FROM oeb_file,oea_file 
              WHERE oeb04=p_ogb.ogb04
                AND oeb19= 'Y'
                AND oeb70= 'N' 
                AND oea01 = oeb01 AND oeaconf !='X'
                AND oeb01 != p_ogb.ogb31 
          END IF
          #MOD-B50227 add --end--
          IF l_oeb12 IS NULL THEN
              LET l_oeb12 = 0
          END IF
#          LET l_qoh = l_ima262 - l_oeb12 #FUN-A20044
          LET l_qoh = l_avl_stk - l_oeb12 #FUN-A20044

          #IF l_qoh < p_ogb.ogb16 AND g_sma.sma894[2,2]='N' THEN  #量不足時,Fail   #MOD-850309   #MOD-A70059
          LET l_qoh_2 = p_ogb.ogb12 * p_ogb.ogb05_fac #MOD-C30033 add
          LET g_flag2 = NULL    #FUN-C80107 add
         #CALL s_inv_shrt_by_warehouse(g_sma.sma894[2,2],p_ogb.ogb09) RETURNING g_flag2   #FUN-C80107 add #FUN-D30024
          CALL s_inv_shrt_by_warehouse(p_ogb.ogb09,g_plant) RETURNING g_flag2                     #FUN-D30024 add  #TQC-D40078 g_plant
         #IF l_qoh < l_qoh_2 AND g_sma.sma894[2,2]='N' THEN  #量不足時,Fail #MOD-C30033 add   #FUN-C80107 mark
          IF l_qoh < l_qoh_2 AND g_flag2 = 'N' THEN    #FUN-C80107 add
          #IF l_qoh < p_ogb.ogb12 * p_ogb.ogb05_fac AND g_sma.sma894[2,2]='N' THEN  #量不足時,Fail   #MOD-850309   #MOD-A70059 #MOD-C30033 mark
             LET g_msg = 'Line#',p_ogb.ogb03 USING '<<<',' ',
                          p_ogb.ogb04 CLIPPED,'-> QOH < 0 '
             CALL cl_err(g_msg,'mfg-026',1)
             LET g_success='N' RETURN
          END IF
       END IF
    END IF
END FUNCTION






FUNCTION t600sub_s1(l_oga,p_cmd) #FUN-9C0083
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
             CALL t600sub_chk_img(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF
             #-----MOD-B10141---------
             IF l_ogb.ogb17 = 'N' THEN
                CALL t600sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF  
             END IF
             #-----END MOD-B10141-----
          END IF
      END IF
    #CHI-A40029 add --end--

      #-----MOD-B10141---------
      #IF l_ogb.ogb17 = 'N' THEN
      #   CALL t600sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF   #No.TQC-7C0114
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
      CALL t600sub_bu1(l_oga.*,l_ogb.*)   #No.TQC-8C0027
      IF g_success = 'N' THEN RETURN l_oha.* END IF
      IF g_oaz.oaz03 = 'N' THEN CONTINUE FOREACH END IF
      IF l_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF
#如為代送，同時生成一張銷退單
      IF l_oga.oga00 = '6' THEN
         INITIALIZE l_ohb.* TO NULL
         ##產生銷退單身
         SELECT MAX(ohb03)+1 INTO l_ohb03 FROM ohb_file
          WHERE ohb01 = l_oha01
         IF cl_null(l_ohb03) OR l_ohb03 = 0 THEN
            LET l_ohb03 = 1
         END IF
         #根據客戶+產品編號+單位+日期+定價類型取定價編號及單價
         IF g_sma.sma116 MATCHES '[23]' THEN
            LET l_unit =l_ogb.ogb916
         ELSE
            LET l_unit =l_ogb.ogb05
         END IF
             CALL s_fetch_price_new(l_oga.oga1004,l_ogb.ogb04,l_ogb.ogb48,l_unit,l_oga.oga02,l_oga.oga00,g_plant,   #FUN-BC0071
                                    #l_oga.oga32,l_ogb.ogb31,l_ogb.ogb32,l_oga.oga01,l_ogb.ogb03,l_ogb.ogb12,  #MOD-A60196 mark
                                    l_oga.oga23,l_oga.oga31,l_oga.oga32,l_oga.oga01,l_ogb.ogb03,l_ogb.ogb12,   #MOD-A60196 mod
                                    l_ogb.ogb1004,p_cmd)
                # RETURNING l_ohb13                 #FUN-AB0061 
                  RETURNING l_ohb13,l_ohb.ohb37     #FUN-AB0061
            #FUN-B70087 mod
            #IF l_ohb13=0 THEN CALL s_unitprice_entry(l_oga.oga1004,l_ogb.ogb31,g_plant) END IF #FUN-9C0120
            #FUN-BC0088 ----- add start ----
            IF l_ogb.ogb04[1,4] = 'MISC' THEN
            #  CALL s_unitprice_entry(l_oga.oga1004,l_ogb.ogb31,g_plant,'M')       #TQC-CA0046 mark
               CALL s_unitprice_entry(l_oga.oga1004,l_oga.oga31,g_plant,'M')       #TQC-CA0046 add
            ELSE
            #FUN-BC0088 ----- add end ----
               IF l_ohb13=0 THEN
            #     CALL s_unitprice_entry(l_oga.oga1004,l_ogb.ogb31,g_plant,'N')    #TQC-CA0046 mark
                  CALL s_unitprice_entry(l_oga.oga1004,l_oga.oga31,g_plant,'N')    #TQC-CA0046 add
               ELSE
            #     CALL s_unitprice_entry(l_oga.oga1004,l_ogb.ogb31,g_plant,'Y')    #TQC-CA0046 mark
                  CALL s_unitprice_entry(l_oga.oga1004,l_oga.oga31,g_plant,'Y')    #TQC-CA0046 add
               END IF
            END IF #FUN-BC0088 add
            #FUN-B70087 mod--end

         #TQC-AC0144 add ----begin----------------
         #根據客戶抓取對應的折扣率
         SELECT occ32 INTO l_ohb.ohb1003 FROM occ_file
          WHERE occ01 = l_oha.oha03
         IF cl_null(l_ohb.ohb1003) OR SQLCA.SQLCODE = 100 THEN
            LET l_ohb.ohb1003 = 100 
         END IF
         #TQC-AC0144 add -----end-----------------
         
         #根據單頭單價是否含稅 進行未稅、含稅金額的計算
         IF cl_null(l_ogb.ogb917) THEN
            LET l_qty = l_ogb.ogb12
         ELSE
            LET l_qty = l_ogb.ogb917
         END IF
 
         IF l_oga.oga213='N' THEN
            LET l_ohb14  = l_ohb13*l_qty*l_ogb.ogb1006/100
            LET l_ohb13t = l_ohb13*(1+l_oga.oga211/100)*l_ogb.ogb1006/100
            LET l_ohb14t = l_ohb13t*l_qty     #No.FUN-670008
         ELSE
            LET l_ohb14  = l_ohb13*l_qty*l_ogb.ogb1006/100
            LET l_ohb13  = l_ohb13*(1+l_oga.oga211/100)
            LET l_ohb14t = l_ohb13*l_ogb.ogb12*l_ogb.ogb1006/100
         END IF
 
         LET l_ohb.ohb01     = l_oha.oha01             #銷退單號
         LET l_ohb.ohb03     = l_ohb03                 #項次
         LET l_ohb.ohb04     = l_ogb.ogb04             #產品編號
         LET l_ohb.ohb05     = l_ogb.ogb05             #銷售單位
         LET l_ohb.ohb05_fac = l_ogb.ogb05_fac         #銷售/庫存單位換算率
         LET l_ohb.ohb910    = l_ogb.ogb910            #第一單位
         LET l_ohb.ohb911    = l_ogb.ogb911            #第一單位轉換率
         LET l_ohb.ohb912    = l_ogb.ogb912            #第一單位數量
         LET l_ohb.ohb913    = l_ogb.ogb913            #第二單位
         LET l_ohb.ohb914    = l_ogb.ogb914            #第二單位轉換率
         LET l_ohb.ohb915    = l_ogb.ogb915            #第二單位數量
         LET l_ohb.ohb916    = l_ogb.ogb916            #計價單位
         LET l_ohb.ohb917    = l_ogb.ogb917            #計價數量
         LET l_ohb.ohb06     = l_ogb.ogb06             #品名規格
         LET l_ohb.ohb07     = l_ogb.ogb07             #額外品名規格
         LET l_ohb.ohb08     = l_ogb.ogb08             #銷退入庫工廠
         LET l_ohb.ohb09     = l_ogb.ogb09             #銷退入庫倉庫
         LET l_ohb.ohb091    = l_ogb.ogb091            #銷退入庫庫位
         LET l_ohb.ohb092    = l_ogb.ogb092            #銷退入庫批號
   #
   IF l_ohb.ohb092=' ' THEN DISPLAY '空 ' END IF
   IF cl_null(l_ohb.ohb092) THEN DISPLAY 'null' END IF 
   #
         LET l_ohb.ohb11     = l_ogb.ogb11             #客戶產品編號
         LET l_ohb.ohb12     = l_ogb.ogb12             #銷退數量
         LET l_ohb.ohb13     = l_ohb13                 #原幣單價
         LET l_ohb.ohb14     = l_ohb14                 #原幣稅前金額
         LET l_ohb.ohb14t    = l_ohb14t                #原幣含稅金額
         LET l_ohb.ohb15     = l_ogb.ogb15             #庫存明細單位
         LET l_ohb.ohb15_fac = l_ogb.ogb15_fac         #銷售/庫存明細單位換算率
         LET l_ohb.ohb16     = l_ogb.ogb16             #數量
         LET l_ohb.ohb50     = l_oay18                 #退貨理由碼
         LET l_ohb.ohb60     = 0                       #已開折讓數量
         LET l_ohb.ohb1001   = l_ohb1001               #定價編號
         #LET l_ohb.ohb1003   = l_ogb.ogb1006           #定價編號     #TQC-AC0144 mark
         LET l_ohb.ohb1004   = 'N'                     #搭贈          #No.FUN-670008
         LET l_ohb.ohb1005   = l_ogb.ogb1005           #作業方式      #No.FUN-670008
 
         IF cl_null(l_ohb.ohb05_fac) THEN LET l_ohb.ohb05_fac=0 END IF
         IF cl_null(l_ohb.ohb12    ) THEN LET l_ohb.ohb12    =0 END IF
         IF cl_null(l_ohb.ohb13    ) THEN LET l_ohb.ohb13    =0 END IF
         IF cl_null(l_ohb.ohb14    ) THEN LET l_ohb.ohb14    =0 END IF
         IF cl_null(l_ohb.ohb14t   ) THEN LET l_ohb.ohb14t   =0 END IF
         IF cl_null(l_ohb.ohb15_fac) THEN LET l_ohb.ohb15_fac=0 END IF
         IF cl_null(l_ohb.ohb16    ) THEN LET l_ohb.ohb16    =0 END IF
         IF cl_null(l_ohb.ohb60    ) THEN LET l_ohb.ohb60    =0 END IF
         LET l_ohb.ohb930   = l_ogb.ogb930 #FUN-670063
 
         LET l_ohb.ohbplant = l_ogb.ogbplant
			LET l_ohb.ohblegal = l_ogb.ogblegal
         LET l_ohb.ohb64 = l_ogb.ogb44
         IF g_azw.azw04 = '2' THEN
            LET l_ohb.ohb65 = l_ogb.ogb45  
            LET l_ohb.ohb66 = l_ogb.ogb46  
            LET l_ohb.ohb67 = l_ogb.ogb47                                                                                           
            LET l_ohb.ohb68 = 'N'
         ELSE
            LET l_ohb.ohb64=' '
            LET l_ohb.ohb67=0
            LET l_ohb.ohb68='N'
         END IF
 
         LET l_ohb.ohbplant = g_plant 
         LET l_ohb.ohblegal = g_legal
         #FUN-AB0061----------add---------------str----------------
         IF cl_null(l_ohb.ohb37) OR l_ohb.ohb37 = 0 THEN
            LET l_ohb.ohb37 = l_ohb.ohb13
         END IF
         #FUN-AB0061----------add---------------end----------------  
         #FUN-AB0096 ----------add start--------------------------
         #IF cl_null(l_ohb.ohb71) THEN    #FUN-AC0055 mark
         #   LET l_ohb.ohb71 = '1'
         #END IF
         #FUN-AB0096 ------------add end--------------------------- 
         #FUN-CB0087---add---str---
         IF g_aza.aza115 = 'Y' THEN
            CALL s_reason_code(l_ohb.ohb01,l_ohb.ohb31,'',l_ohb.ohb04,l_ohb.ohb09,l_oha.oha14,l_oha.oha15) RETURNING l_ohb.ohb50
            IF cl_null(l_ohb.ohb50) THEN
               CALL cl_err('','aim-425',1)
               LET g_success = 'N'
               CONTINUE FOREACH 
            END IF
         END IF
         #FUN-CB0087---add---end---
         INSERT INTO ohb_file VALUES(l_ohb.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg("ohb01",l_ohb.ohb01,"INS ohb_file",SQLCA.sqlcode,1)     #No.FUN-710046
            LET g_success = 'N'
            CONTINUE FOREACH        #No.FUN-710046
#FUN-B70074--add--insert--
         ELSE
            IF NOT s_industry('std') THEN
               INITIALIZE l_ohbi.* TO NULL
               LET l_ohbi.ohbi01 = l_ohb.ohb01
               LET l_ohbi.ohbi03 = l_ohb.ohb03
               IF NOT s_ins_ohbi(l_ohbi.*,l_ohb.ohbplant ) THEN
                  LET g_success = 'N'  
                  CONTINUE FOREACH 
               END IF
            END IF 
#FUN-B70074--add--insert--
         END IF
         CALL t600sub_update_7(l_oga.*,l_oha.*,l_ohb.*)   ##銷退單庫存過帳處理(img_file,tlf_file update)
         IF g_success='N' THEN
            CONTINUE FOREACH    #No.FUN-710046
         END IF
         IF g_sma.sma115 = 'Y' THEN
            SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01=l_ohb.ohb04
            IF l_ima906 = '2' THEN  #子母單位
               IF NOT cl_null(l_ohb.ohb913) THEN
                  CALL t600sub_upd_imgg('1',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                      l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,+1,'2',l_oga.*)
                  IF g_success='N' THEN RETURN l_oha.* END IF
                  IF NOT cl_null(l_ohb.ohb915) THEN                               #CHI-860005
                    CALL t600sub_upd_tlff_oh('2',l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,l_oha.*,l_ohb.*)
                    IF g_success='N' THEN RETURN l_oha.* END IF
                  END IF
               END IF
               IF NOT cl_null(l_ohb.ohb910) THEN
                  CALL t600sub_upd_imgg('1',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                     l_ohb.ohb092,l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,+1,'1',l_oga.*)
                  IF g_success='N' THEN RETURN l_oha.* END IF
                  IF NOT cl_null(l_ohb.ohb912) THEN                                #CHI-860005
                     CALL t600sub_upd_tlff_oh('1',l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,l_oha.*,l_ohb.*)
                     IF g_success='N' THEN RETURN l_oha.* END IF
                  END IF
               END IF
            END IF
            IF l_ima906 = '3' THEN  #參考單位
               IF NOT cl_null(l_ohb.ohb913) THEN
                  CALL t600sub_upd_imgg('2',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                      l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,+1,'2',l_oga.*)
                  IF g_success='N' THEN RETURN l_oha.* END IF
                  IF NOT cl_null(l_ohb.ohb915) THEN                                #CHI-860005 
                     CALL t600sub_upd_tlff_oh('2',l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,l_oha.*,l_ohb.*)
                     IF g_success='N' THEN RETURN l_oha.* END IF
                  END IF
               END IF
            END IF
         END IF
 
         IF g_success='N' THEN
            RETURN l_oha.*
         END IF
 
         LET l_oha.oha50=l_oha.oha50+l_ohb.ohb14                                      #No.FUN-670008
         LET l_oha53=l_oha.oha50-l_oha.oha1006                                        #No.FUN-670008
         LET l_oha.oha1008 =l_oha.oha50*(l_oga.oga211+1100)/100                          #No.FUN-670008
         UPDATE oha_file SET oha53=l_oha53,oha50=l_oha.oha50,oha1008 =l_oha.oha1008   #No.FUN-670008
          WHERE oha01=l_oha.oha01
         IF SQLCA.SQLCODE THEN
            LET g_success='N'
            RETURN l_oha.*
         END IF
 
      END IF
 
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
               CALL t600sub_update(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
                             l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) #No:8741
            ELSE
               CALL t600sub_update(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,
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
     #    CALL t600sub_update(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
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
                CALL t600sub_chk_ogb1001(l_ogb.ogb1001) RETURNING l_cnt2
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
                         CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogc.ogc092,l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,
                         l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) 
                         IF g_success='N' THEN 
                            LET g_totsuccess="N"
                            LET g_success="Y"
                            CONTINUE FOREACH
                         END IF
                      END FOREACH    
   #FUN-C50097 ADD 120726                          
   #                  CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                      IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                         CALL t600sub_consign_mu(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_oga.*,l_ogb.*) 
                      END IF 
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
                         CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogc.ogc092,l_ogc.ogc12,l_ogb.ogb05,
                         l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*) 
                         IF g_success='N' THEN 
                            LET g_totsuccess="N"
                            LET g_success="Y"
                            CONTINUE FOREACH
                         END IF
                      END FOREACH    
   #FUN-C50097 ADD 120726                   
                      #CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                      IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                         CALL t600sub_consign_mu(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_oga.*,l_ogb.*)   
                      END IF
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
         IF g_sma.sma115 = 'Y' THEN
            SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01=l_ogb.ogb04
         #IF l_ogb.ogb17 = 'Y' THEN #MOD-BB0051 mark
            DECLARE t600_s1_ogg_c CURSOR FOR  SELECT * FROM ogg_file
              WHERE ogg01=l_oga.oga01 AND ogg03=l_ogb.ogb03
              ORDER BY ogg20 DESC
            FOREACH t600_s1_ogg_c INTO l_ogg.*
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"Foreach s1_ogg:",SQLCA.sqlcode,1)   #No.FUN-710046
                  LET g_success='N' DISPLAY "3" EXIT FOREACH
               END IF
               LET l_msg='_s1() read ogg02:',l_ogb.ogb03,'-',l_ogg.ogg091
               CALL cl_msg(l_msg)
#FUN-C50097 ADD BEG------120727
               IF l_oga.oga09 = '8' THEN
                  IF g_aza.aza26='2' AND g_oaz.oaz94 = 'Y' THEN
                      SELECT SUM(ogg12) INTO l_ogg12
                        FROM ogg_file
                       WHERE ogg01 = l_oga.oga011
                         AND ogg03 = l_ogb.ogb03
                         AND ogg17 = l_ogg.ogg17  
                         AND ogg092= l_ogg.ogg092                   
                      IF l_ogg.ogg12 != l_ogg12 THEN
                         LET l_ogg.ogg12 = l_ogg.ogg12 + l_ogg.ogg13 #銷售數量 + 銷退數量 = 本次簽收倉,過帳異動數量
                         LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
                         LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15)    
                      END IF                                    
                  ELSE 
                      #有驗退時,在途倉仍是出全部數量(含可入庫數量、驗退數量)
                      SELECT SUM(ogg12) INTO l_ogg12
                        FROM ogg_file
                       WHERE ogg01 = l_oga.oga011
                         AND ogg03 = l_ogb.ogb03
                         AND ogg17 = l_ogg.ogg17
                         AND ogg092= l_ogg.ogg092
                      IF l_ogg.ogg12 != l_ogg12 THEN
                         LET l_ogg.ogg12 = l_ogg12
                         LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
                         LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15) 
                      END IF
                  END IF 
               END IF               
#FUN-C50097 ADD END------120727               
               IF g_sma.sma117 = 'N' THEN 
                  IF g_oaz.oaz23 = 'Y' AND NOT cl_null(l_ogg.ogg17) THEN
                     IF l_ima906 <> '1' THEN    #MOD-8C0139
                        CALL t600sub_chk_imgg(l_ima906,l_ogg.ogg20,l_ogg.ogg17,
                                            l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                            l_ogg.ogg15,l_ogg.ogg15_fac,l_ogg.ogg16,'','','','','')
                     END IF   #MOD-8C0139
                  ELSE
                     IF l_ima906 <> '1' THEN    #MOD-8C0139
                        CALL t600sub_chk_imgg(l_ima906,l_ogg.ogg20,l_ogb.ogb04,
                                            l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                                            l_ogg.ogg15,l_ogg.ogg15_fac,l_ogg.ogg16,'','','','','')
                     END IF   #MOD-8C0139
                  END IF
                  IF l_ima906 <> '1' THEN    #MOD-8C0139
                     IF g_success = 'N' THEN
                        LET g_totsuccess = 'N'
                        LET g_success = 'Y'
                        CONTINUE FOREACH
                     END IF
                  END IF   #MOD-8C0139
               END IF
               #-----MOD-A20117---------
               IF l_ima906 = '1' THEN
                  CALL s_upimg_imgs(
                      #l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,
                       l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,   #No:FUN-BB0081
                       l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   
               END IF
               #-----END MOD-A20117-----
               IF l_ima906 = '2' THEN
                  IF NOT cl_null(l_ogg.ogg10) THEN
                     CALL t600sub_upd_imgg(
                         #'1',l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
						  '1',l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,   #No:FUN-BB0081
                                        l_ogg.ogg10,1,l_ogg.ogg12,-1,'1',l_oga.*)
                     IF g_success = 'N' THEN    #No.FUN-6C0083
                        LET g_totsuccess="N"
                        LET g_success="Y"
                        CONTINUE FOREACH
                     END IF
                     CALL s_upimg_imgs(
                         #l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,
                          l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,   #No:FUN-BB0081
                          l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   #MOD-A20117  
                     IF NOT cl_null(l_ogg.ogg12) AND l_ogg.ogg12 <> 0 THEN
                        CALL t600sub_tlff(
                            #l_ogg.ogg20,l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                             l_ogg.ogg20,l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,   #No:FUN-BB0081
                             l_ogg.ogg10,1,l_ogg.ogg12,l_oga.*,l_ogb.*,'1')   #No:FUN-BB0081
							 
                        IF g_success = 'N' THEN    #No.FUN-6C0083
                           LET g_totsuccess="N"
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                     END IF
                  END IF
               END IF
               IF l_ima906 = '3' THEN
                  IF l_ogg.ogg20 = '2' THEN
                     CALL t600sub_upd_imgg(
                         #'2',l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                          '2',l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,   #No:FUN-BB0081
                          l_ogg.ogg10,1,l_ogg.ogg12,-1,'2',l_oga.*)
                     IF g_success = 'N' THEN
                        LET g_totsuccess="N"   #No.FUN-6C0083
                        LET g_success="Y"
                        CONTINUE FOREACH
                     END IF
                    #MOD-BC0207 mark --start--
                    #CALL s_upimg_imgs(l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   #MOD-A20117  
                    #MOD-BC0207 mark --end--
                     IF NOT cl_null(l_ogg.ogg12) AND l_ogg.ogg12 <> 0 THEN
                        CALL t600sub_tlff(
                            #l_ogg.ogg20,l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                             l_ogg.ogg20,l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,   #No:FUN-BB0081
                             l_ogg.ogg10,1,l_ogg.ogg12,l_oga.*,l_ogb.*,'1')   #No:FUN-BB0081
                        IF g_success = 'N' THEN
                           LET g_totsuccess="N"   #No.FUN-6C0083
                           LET g_success="Y"
                           CONTINUE FOREACH
                        END IF
                     END IF
                     #MOD-BC0207 add --start--
                     IF l_ogg.ogg20 = '1' THEN
                       #CALL s_upimg_imgs(l_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   #TQC-C50097 mark
                        CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,-1,l_oga.oga01,l_ogb.ogb03,l_ogg.ogg10,'2')   #TQC-C50097 add
                     END IF
                     #MOD-BC0207 add --end--
                   END IF
               END IF
               IF g_success='N' THEN RETURN l_oha.* END IF
            END FOREACH
         #MOD-BB0051 ----- mark start -----
         #ELSE
         #   IF g_sma.sma117 = 'N' THEN 
         #      IF l_ima906 <> '1' THEN    #MOD-8C0139
         #         CALL t600sub_chk_imgg(l_ima906,'',l_ogb.ogb04,
         #                             l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
         #                             '','','',l_ogb.ogb913,l_ogb.ogb915,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912)
         #         IF g_success = 'N' THEN
         #            LET g_totsuccess = 'N'
         #            LET g_success = 'Y'
         #            CONTINUE FOREACH
         #         END IF
         #      END IF   #MOD-8C0139
         #   END IF
         #   CALL t600sub_s_du(l_oga.*,l_ogb.*)
         #   IF g_success = 'N' THEN
         #      LET g_totsuccess="N"
         #      LET g_success="Y"
         #      CONTINUE FOREACH   #No.FUN-6C0083
         #   END IF
         #END IF
         #MOD-BB0051 ----- mark end -----
      #MOD-BB0051 ----- add start  -----
         END IF    #TQC-C50163 add 
      ELSE
         IF g_prog[1,7] != 'axmt628' THEN
            CALL t600_chk_avl_stk(l_ogb.*)
         END IF 
         CALL t600sub_update(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
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
                  CALL t600sub_chk_ogb1001(l_ogb.ogb1001) RETURNING l_cnt2
                  IF l_cnt2 > 0 THEN 
                     #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                     #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                  ELSE 
#MOD-CB0050 add end--------------------------------- 
                     IF (g_prog[1,7] = 'axmt620' OR g_prog[1,7] = 'axmp230') AND l_oga.oga65='N' AND l_oga.oga00 != '2' THEN #MOD-CB0083 add oga00
                      #當走直接出貨時, #TQC-D10067 add g_prog[1,7] = 'axmp230' 
                     #更新發票倉庫存和產生tlf檔案
                        CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,   
                                             l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                        IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                           CALL t600sub_consign_mu(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_oga.*,l_ogb.*) 
                        END IF 
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
                        CALL t600sub_consign(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,   
                                             l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)                                           
                        IF g_sma.sma115 = 'Y' THEN #双单位逻辑
                           CALL t600sub_consign_mu(g_oaz.oaz95,l_oga.oga03,l_ogb.ogb092,l_oga.*,l_ogb.*)   
                        END IF
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
         #FUN-C50097 ADD END---------
         IF g_sma.sma115 = 'Y' THEN
            SELECT ima906 INTO l_ima906 FROM ima_file
             WHERE ima01 = l_ogb.ogb04

            IF g_sma.sma117 = 'N' THEN
               IF l_ima906 <> '1' THEN
                  CALL t600sub_chk_imgg(l_ima906,'',l_ogb.ogb04,
                                      l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                                      '','','',l_ogb.ogb913,l_ogb.ogb915,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912)
                  IF g_success = 'N' THEN
                     LET g_totsuccess = 'N'
                     LET g_success = 'Y'
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF
            CALL t600sub_s_du(l_oga.*,l_ogb.*)
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
        #CALL t600sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,     #No.TQC-6B0174
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
              #CALL t600sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,  #MOD-BA0009 mark 
               CALL t600sub_consign(l_oga.oga910,l_oga.oga911,l_ogc.ogc092,  #MOD-BA0009 
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
            CALL t600sub_consign(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,   
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
         IF g_sma.sma115 = 'Y' THEN  #No.FUN-630061
            CALL t600sub_consign_mu(l_oga.oga910,l_oga.oga911,l_ogb.ogb092,l_oga.*,l_ogb.*)     #No.TQC-6B0174
            IF g_success='N' THEN
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH   #No.FUN-6C0083
            END IF
         END IF                      #No.FUN-630061
      END IF
     #IF l_argv0 = '2' AND l_oga.oga65='Y'  THEN           #FUN-C40072 mark
      IF l_argv0 MATCHES '[2,4]' AND l_oga.oga65='Y'  THEN #FUN-C40072 add
        #CHI-AC0034 mark --start--
        #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,     #No.TQC-6B0174
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
               #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,  #TQC-BA0136 mark 
               CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc.ogc092,   #TQC-BA0136   
                             l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
#               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc_1.ogc15_fac
#               LET l_ogc_1.ogc16=l_ogc_1.ogc12*l_ogc_1.ogc15_fac
#
#               CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc_1.ogc092,l_ogc_1.ogc12,
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
#                  CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc_1.ogc092,l_ogc_1.ogc12, 
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
            CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,   
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
         IF g_sma.sma115 = 'Y' THEN
           #如果多仓储批出货,则生成的签收仓,批号也应该带入,t600sub_consign_mu
            CALL t600sub_consign_mu(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,l_oga.*,l_ogb.*)     #No.TQC-6B0174
            IF g_success = 'N' THEN
               LET g_totsuccess="N"
               LET g_success="Y"
               CONTINUE FOREACH   #No.FUN-6C0083
            END IF
         END IF
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
  CALL t600_tqw081_update('1')
  IF g_success='N' THEN
     RETURN l_oha.*
  END IF
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   IF g_success = 'Y' AND l_argv0 = '8' THEN
      IF g_aza.aza26 != '2' THEN  #FUN-C50097 add
         CALL t600_gen_return_note(l_oga.*)   #MOD-790150 modify l_oga.*
 #FUN-C50097 add begin---------
      ELSE
      	  IF g_oaz.oaz94 = 'Y' THEN
      	     #詢問是否產生客戶簽退單#所呼叫函数需要重新撰写120601
      	     #大陆版多次签收段逻辑
      	     LET l_cnt = 0
      	     SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
      	      WHERE oga01 = ogb01 
      	        AND oga09 = '8' 
      	        AND ogaconf != 'X'
      	        AND ogb52 > 0
      	        AND oga01 = l_oga.oga01
      	     IF l_cnt > 0 THEN    
      	        CALL t600_gen_return_note2(l_oga.*)
      	        IF g_success='N' THEN
                   RETURN l_oha.*
                END IF   
      	     ELSE 
          	     #更新出货单,累计出货签收数量
                 #更新ogb50,ogb51累计签收量和累计签退量,此时无签退量,只更新签收数量即可              
                 DECLARE t600sub_upd_ogb50 CURSOR FOR SELECT ogb01,ogb03,ogb12 FROM ogb_file WHERE ogb01= l_oga.oga01
                 CALL l_ogb2.clear()
                 LET l_ac = 1
                 FOREACH  t600sub_upd_ogb50 INTO l_ogb2[l_ac].*
                    SELECT ogb50 INTO l_ogb50 FROM ogb_file
                     WHERE ogb01 =  l_oga.oga011
                       AND ogb03 = l_ogb2[l_ac].ogb03
                    IF cl_null(l_ogb50) THEN 
                       LET l_ogb50 = 0
                    END IF          
                    LET l_ogb50 = l_ogb50 + l_ogb2[l_ac].ogb12
                    IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
                       LET l_ogb50 = 0
                    END IF 
                    UPDATE ogb_file SET ogb50 = l_ogb50
                                 WHERE  ogb01 = l_oga.oga011
                                   AND  ogb03 = l_ogb2[l_ac].ogb03           
                 END FOREACH                                         
          	     CALL l_ogb2.deleteElement(l_ac)
          	     LET  l_ac = 0	  
      	     END IF  
      	  ELSE 
      	     CALL t600_gen_return_note(l_oga.*) 
      	  END IF 	    
      END IF
#FUN-C50097 add end-----------
   END IF
  RETURN l_oha.*  #FUN-730012
END FUNCTION








FUNCTION t600sub_ind_icd_post(p_oga01,p_cmd)
   DEFINE p_oga01     LIKE oga_file.oga01
   DEFINE p_cmd       LIKE type_file.chr1
   #DEFINE l_imaicd04  LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
   #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
   DEFINE l_oga       RECORD LIKE oga_file.*
   DEFINE l_ogb       RECORD LIKE ogb_file.*
   DEFINE l_ogc       RECORD LIKE ogc_file.*   #FUN-B40081
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_err       STRING
   DEFINE l_argv0     LIKE ogb_file.ogb09
   DEFINE l_ogbi RECORD LIKE ogbi_file.*   #TQC-B80005
   DEFINE l_sql       STRING   #FUN-B40081
 
    SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01
    IF cl_null(l_oga.oga01) THEN
       CALL cl_err('',-400,0)
       RETURN ""
    END IF
    #TQC-C30062---begin
    IF l_oga.oga09 = '1' THEN
       RETURN
    END IF
    #TQC-C30062---end
    
   LET l_argv0=l_oga.oga09
   DECLARE t600_icdpost_cs CURSOR FOR
     SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01

   #FUN-B40081 --START--
   LET l_sql= " SELECT * FROM ogc_file WHERE ogc01='",l_oga.oga01,"' AND ogc03=?" 
   PREPARE t600_icdpost_pre1 FROM l_sql
   DECLARE t600_icdpost_cs1 CURSOR FOR t600_icdpost_pre1 
   #FUN-B40081 --END--     
 
   FOREACH t600_icdpost_cs INTO l_ogb.*
     IF STATUS THEN
        CALL cl_err('t600_icdpost_cs:',STATUS,0)
        LET g_success = 'N'
        EXIT FOREACH
     END IF

     #FUN-BA0051 --START mark--
     #LET l_imaicd04 = NULL  LET l_imaicd08 = NULL
     #SELECT imaicd04,imaicd08
     #  INTO l_imaicd04,l_imaicd08
     #  FROM imaicd_file
     # WHERE imaicd00 = l_ogb.ogb04
     #FUN-BA0051 --END mark-- 
     #TQC-B80005 --START--
     SELECT * INTO l_ogbi.* FROM ogbi_file
      WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03  
     #TQC-B80005 --END--
     #FUN-B40081 --START--
     IF l_ogb.ogb17='Y' THEN   #多倉儲出貨應以多倉儲裡的資料過帳
        FOREACH t600_icdpost_cs1 USING l_ogb.ogb03 INTO l_ogc.*
           IF STATUS THEN
              CALL cl_err('t600_icdpost_cs1:',STATUS,0)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           
           LET l_ogb.ogb09 =l_ogc.ogc09   #出貨倉庫編號
           LET l_ogb.ogb091=l_ogc.ogc091  #出貨儲位編號
           LET l_ogb.ogb092=l_ogc.ogc092  #出貨批號
           LET l_ogb.ogb12 =l_ogc.ogc12   #數量

           IF p_cmd = '1' THEN  # 過帳
              IF l_argv0 = '1' THEN
                 CALL s_icdpost(2,l_ogc.ogc17,l_ogc.ogc09,l_ogc.ogc091,
                                 l_ogc.ogc092,l_ogc.ogc15,l_ogc.ogc12,
                                 l_oga.oga01,l_ogc.ogc03,l_oga.oga02,'Y','',''
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag
                 IF l_flag = 0 THEN
                    LET g_success = 'N'                   
                    RETURN
                 END IF
              ELSE
                 CALL s_icdpost(-1,l_ogc.ogc17,l_ogc.ogc09,l_ogc.ogc091,
                                 l_ogc.ogc092,l_ogc.ogc15,l_ogc.ogc12,
                                 l_oga.oga01,l_ogc.ogc03,l_oga.oga02,'Y','','' 
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag
              END IF
              IF l_flag = 0 THEN
                 LET g_success = 'N'                
                 RETURN
              END IF
           ELSE                 # 過帳還原
              IF l_argv0 = '1' THEN
                 CALL s_icdpost(2,l_ogc.ogc17,l_ogc.ogc09,
                                 l_ogc.ogc091,l_ogc.ogc092,
                                 l_ogc.ogc15,l_ogc.ogc12,
                                 l_oga.oga01,l_ogc.ogc03,
                                 l_oga.oga02,'N','',''
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag
              ELSE
                 CALL s_icdpost(-1,l_ogc.ogc17,l_ogc.ogc09,
                                 l_ogc.ogc091,l_ogc.ogc092,
                                 l_ogc.ogc15,l_ogc.ogc12,
                                 l_oga.oga01,l_ogc.ogc03,
                                 l_oga.oga02,'N','',''
                                 ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
                      RETURNING l_flag
              END IF
              IF l_flag = 0 THEN
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
        END FOREACH
     ELSE     
     #FUN-B40081 --END-- 
        IF p_cmd = '1' THEN  # 過帳
           IF l_argv0 = '1' THEN
              CALL s_icdpost(2,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                              l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                              l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y','',''
                              ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119   傳入p_plant參數''   -
                   RETURNING l_flag
              IF l_flag = 0 THEN
                 LET g_success = 'N'
	          #LET l_err = l_oga.oga01 ,"-", l_ogb.ogb03    #FUN-B40066 mark
	          #CALL cl_err(l_err,'DSC017',0) #新增錯誤項次訊息 #FUN-B40066 mark
                 RETURN
              END IF
           ELSE
              CALL s_icdpost(-1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                              l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                              l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y','',''
                              ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119   傳入p_plant參數''   -
                   RETURNING l_flag
           END IF
           IF l_flag = 0 THEN
              LET g_success = 'N'
	       #LET l_err = l_oga.oga01 ,"-", l_ogb.ogb03    #FUN-B40066 mark
	       #CALL cl_err(l_err,'DSC017',0)# 新增錯誤項次訊息 #FUN-B40066 mark
              RETURN
           END IF
        ELSE                 # 過帳還原
           IF l_argv0 = '1' THEN
              CALL s_icdpost(2,l_ogb.ogb04,l_ogb.ogb09,
                              l_ogb.ogb091,l_ogb.ogb092,
                              l_ogb.ogb05,l_ogb.ogb12,
                              l_oga.oga01,l_ogb.ogb03,
                              l_oga.oga02,'N','',''
                              ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119   傳入p_plant參數''   -
                   RETURNING l_flag
           ELSE
              CALL s_icdpost(-1,l_ogb.ogb04,l_ogb.ogb09,
                              l_ogb.ogb091,l_ogb.ogb092,
                              l_ogb.ogb05,l_ogb.ogb12,
                              l_oga.oga01,l_ogb.ogb03,
                              l_oga.oga02,'N','',''
                              ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119   傳入p_plant參數''   -
                   RETURNING l_flag
           END IF
           IF l_flag = 0 THEN
              LET g_success = 'N'
              EXIT FOREACH
           END IF
        END IF
      END IF   #FUN-B40081        
   END FOREACH
 
END FUNCTION







FUNCTION t600sub_add_deduct(p_oga01)
DEFINE p_oga01        LIKE oga_file.oga01
DEFINE g_sql          STRING
DEFINE l_n            LIKE type_file.num5
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_ima154       LIKE ima_file.ima154
DEFINE l_rxy_file     RECORD LIKE rxy_file.*
DEFINE l_lqe_file     RECORD LIKE lqe_file.*
DEFINE l_lqb          RECORD LIKE lqb_file.*
DEFINE l_ogb          RECORD LIKE ogb_file.*
DEFINE l_rxe04        LIKE rxe_file.rxe04
DEFINE l_rxe05        LIKE rxe_file.rxe05
DEFINE l_lqe01        LIKE lqe_file.lqe01
DEFINE l_rxe04_1      LIKE rxe_file.rxe04
DEFINE l_rxe05_1      LIKE rxe_file.rxe05
DEFINE max_lsm05      LIKE lsm_file.lsm05     #FUN-BA0069 add
DEFINE l_rxx04_point  LIKE rxx_file.rxx04     #FUN-BA0069 add
DEFINE l_oga          RECORD LIKE oga_file.*  #FUN-BA0069 add
DEFINE l_rxe02_1      LIKE rxe_file.rxe02     #TQC-C30129 add
DEFINE l_ogb31        LIKE ogb_file.ogb31     #TQC-C30129 add

   SELECT * INTO l_oga.* FROM oga_file where oga01 = p_oga01
   #檢查券起訖編號範圍內是否有包含非5.發放或2.退回狀態的券
   CALL s_showmsg_init()   
   LET g_sql = " SELECT rxe02,rxe04,rxe05 FROM rxe_file ",
               "  WHERE rxe01 = '",p_oga01,"' ",
               "    AND rxe00 = '02' "
   DECLARE t620_sel_rxe_cr1 CURSOR FROM g_sql
   FOREACH t620_sel_rxe_cr1 INTO l_rxe02_1,l_rxe04_1,l_rxe05_1       #TQC-C30129 add rxe02
#TQC-C30129 -----------------STA
      SELECT ogb31 INTO l_ogb31 FROM ogb_file WHERE ogb01 = p_oga01 AND ogb03 = l_rxe02_1
      IF NOT cl_null(l_ogb31) THEN
         CONTINUE FOREACH
      END IF
#TQC-C30129 -----------------END
      LET g_sql = "SELECT lqe01 FROM lqe_file ",
                  " WHERE lqe01 BETWEEN '",l_rxe04_1,"' AND '",l_rxe05_1,"'",
                  "   AND (lqe17 <> '5' OR lqe13 <> '",l_oga.ogaplant,"')",
                  "   AND (lqe17 <> '2' OR lqe09 <> '",l_oga.ogaplant,"')"
      PREPARE sel_lqe_pre1 FROM g_sql
      DECLARE sel_lqe_cs1 CURSOR FOR sel_lqe_pre1
      FOREACH sel_lqe_cs1 INTO l_lqe01
         CALL s_errmsg('',l_lqe01,'','axm-685',1)
         LET g_success = 'N'
      END FOREACH
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      RETURN
   END IF
   #庫存過賬的操作
   SELECT COUNT(*) INTO l_cnt
     FROM rxy_file
    WHERE rxy00 = '02'
      AND rxy01 = p_oga01
      AND rxy03 = '04'
   IF l_cnt > 0 THEN
      LET g_sql = " SELECT * FROM rxy_file ",
                  "  WHERE rxy00 = '02'",
                  "    AND rxy01 = '",p_oga01,"' ",
                  "    AND rxy03 = '04' "
      DECLARE t600sub_sel_rxy_cr CURSOR FROM g_sql
      FOREACH t600sub_sel_rxy_cr INTO l_rxy_file.*
         UPDATE lqe_file
            SET lqe17 = '4',
                #lqe18 = l_rxy_file.rxyplant,  #FUN-D10040 mark
                #lqe19 = l_rxy_file.rxy21      #FUN-D10040 mark
                lqe24 = l_rxy_file.rxyplant,   #FUN-D10040 add
                lqe25 = l_rxy_file.rxy21       #FUN-D10040 add
          WHERE lqe01 >= l_rxy_file.rxy14
            AND lqe01 <= l_rxy_file.rxy15
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","lqe_file",p_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N' 
            RETURN
         END IF
         LET g_sql = " SELECT * FROM lqe_file ",
                     "  WHERE lqe01 >= '",l_rxy_file.rxy14,"' ",
                     "    AND lqe01 <= '",l_rxy_file.rxy15,"' "

         DECLARE t600sub_sel_lqe_cr CURSOR FROM g_sql
         FOREACH t600sub_sel_lqe_cr INTO l_lqe_file.*
            CASE l_lqe_file.lqe17
                  WHEN '0' LET l_lqb.lqb06 = l_lqe_file.lqe05
                           LET l_lqb.lqb07 = '1'
                  WHEN '1' LET l_lqb.lqb06 = l_lqe_file.lqe07
                           LET l_lqb.lqb07 = '0'
                  WHEN '2' LET l_lqb.lqb06 = l_lqe_file.lqe10
                           LET l_lqb.lqb07 = '1'
                  WHEN '3' LET l_lqb.lqb06 = l_lqe_file.lqe12
                           LET l_lqb.lqb07 = '1'
                 #WHEN '4' LET l_lqb.lqb06 = l_lqe_file.lqe19   #FUN-D10040 mark
                 #         LET l_lqb.lqb07 = '1'                #FUN-D10040 mark
                  WHEN '4' LET l_lqb.lqb06 = l_lqe_file.lqe25   #FUN-D10040 add
                           LET l_lqb.lqb07 = '0'                #FUN-D10040 add  
             END CASE
             SELECT COUNT(*) INTO l_n
               FROM lqc_file
              WHERE lqc01 = l_lqe_file.lqe01
             IF l_n = 0 THEN
                INSERT INTO lqc_file(lqc01,lqc02,lqc03,lqc04,lqc05,lqc06,lqclegal,lqcplant)
                              VALUES(l_lqe_file.lqe01,l_lqe_file.lqe17,l_lqb.lqb06,l_rxy_file.rxy21,
                                     l_lqb.lqb07,'1',l_rxy_file.rxylegal,l_rxy_file.rxyplant)
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("ins","lqc_file",l_lqe_file.lqe01,"",SQLCA.sqlcode,"","",1)
                   LET g_success = 'N'
                   RETURN
                END IF
             ELSE
                UPDATE lqc_file
                   SET lqc06 = lqc06 +1
                 WHERE lqc01 = l_lqe_file.lqe01
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","lqc_file",l_lqe_file.lqe01,"",SQLCA.sqlcode,"","",1)
                   LET g_success = 'N'
                   RETURN
                END IF
             END IF
         END FOREACH
      END FOREACH
   END IF

   LET g_sql = " SELECT * FROM ogb_file ",
               "  WHERE ogb01 = '",p_oga01,"' ",
               "    AND (ogb31 = ' ' OR ogb31 IS NULL) "     #TQC-C30129 add
           
   DECLARE t600sub_sel_ogb_cr CURSOR FROM g_sql
   FOREACH t600sub_sel_ogb_cr INTO l_ogb.*
      LET g_cnt = g_cnt +1
      SELECT ima154 INTO l_ima154
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
      IF l_ima154 = 'Y' THEN
         LET g_sql = " SELECT rxe04,rxe05 FROM rxe_file ",
                     "  WHERE rxe01 = '",l_ogb.ogb01,"' ",
                     "    AND rxe02 = '",l_ogb.ogb03,"' "
         DECLARE t600sub_sel_rxe04_rxe05_cr CURSOR FROM g_sql
         FOREACH t600sub_sel_rxe04_rxe05_cr INTO l_rxe04,l_rxe05
            UPDATE lqe_file
               SET lqe06 = l_oga.ogaplant,
                   lqe07 = l_oga.oga02,
                   lqe24 = '',         #FUN-D10040 add
                   lqe25 = '',         #FUN-D10040 add
                   lqe17 = '1'
             WHERE lqe01 >= l_rxe04
               AND lqe01 <= l_rxe05
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","lqe_file",l_lqe_file.lqe01,"",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               RETURN
            END IF
         END FOREACH
      END IF
   END FOREACH
   #FUN-BA0069 add begin ---
   SELECT SUM(rxy23) INTO l_rxx04_point
     FROM rxy_file
    WHERE rxy00 = '02'
      AND rxy01 = l_oga.oga01
      AND rxy03 = '09'
      AND rxyplant = l_oga.ogaplant
   IF cl_null(l_rxx04_point) THEN
      LET l_rxx04_point = 0
   END IF
   IF (g_success = 'Y') AND g_azw.azw04 = '2' AND l_oga.oga94 = 'N' AND NOT cl_null(l_oga.oga87) THEN
      IF NOT cl_null(l_rxx04_point) AND l_rxx04_point > 0 THEN
        #INSERT INTO lsm_file(lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmplant,lsm15)   #FUN-C70045 add lsm15  #FUN-C90102 mark
         INSERT INTO lsm_file(lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmstore,lsm15)   #FUN-C90102 add
                       VALUES(l_oga.oga87,'9',l_oga.oga01,l_rxx04_point*(-1),l_oga.oga02,'',0,l_oga.ogalegal,l_oga.ogaplant,'1') #FUN-C70045 add '1' 
      END IF
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lsm_file",l_oga.oga87,"",SQLCA.sqlcode,"","ins lsm",1)
         LET g_success = 'N'
         RETURN
      END IF
      IF cl_null(l_oga.oga51) THEN
         LET l_oga.oga51 = 0
      END IF
      #MOD-C30216--add---str-- 
      IF cl_null(l_oga.oga95) THEN
         LET l_oga.oga95 = 0
      END IF
      #MOD-C30216--add---end--
     #INSERT INTO lsm_file(lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmplant,lsm15)   #FUN-C70045 add lsm15  #FUN-C90102 mark
      INSERT INTO lsm_file(lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmlegal,lsmstore,lsm15)   #FUN-C90102 add   
                  VALUES(l_oga.oga87,'7',l_oga.oga01,l_oga.oga95,l_oga.oga02,'',l_oga.oga51,l_oga.ogalegal,l_oga.ogaplant,'1')   #FUN-C70045 add '1'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","lsm_file",l_oga.oga01,"",SQLCA.sqlcode,"","ins lsm",1)
         LET g_success = 'N'
         RETURN
      ELSE
         SELECT MAX(lsm05) INTO max_lsm05
           FROM lsm_file
          WHERE lsm01 = l_oga.oga87
#           AND lsm02 IN ('1', '5', '6', '7', '8')     #FUN-C70045 mark
            AND lsm02 IN ('2', '3', '7', '8')          #FUN-C70045 add
         UPDATE lpj_file
            SET lpj07 = COALESCE(lpj07,0) + 1,
                lpj08 = max_lsm05,
                lpj12 = COALESCE(lpj12,0) + l_oga.oga95 - l_rxx04_point,
                lpj13 = COALESCE(lpj13,0) + l_rxx04_point,
                lpj14 = COALESCE(lpj14,0) + l_oga.oga95,
                lpj15 = COALESCE(lpj15,0) + l_oga.oga51,
                lpjpos = '2'             #FUN-D30007 add
          WHERE lpj03 = l_oga.oga87
          IF SQLCA.sqlcode  THEN
             CALL cl_err3("upd","lpj_file",l_oga.oga87,"",SQLCA.sqlcode,"","",1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
   END IF
   #FUN-BA0069 add end -----
END FUNCTION







FUNCTION t600sub_chkpoz(l_oga,p_ogb31)
DEFINE l_oga    RECORD LIKE oga_file.*
DEFINE p_ogb31  LIKE ogb_file.ogb31  #FUN-730012
DEFINE l_oea01  LIKE oea_file.oea01
DEFINE l_oea99  LIKE oea_file.oea99  #MOD-6C0118
DEFINE l_sql   STRING  #NO.TQC-630166
DEFINE l_poz    RECORD LIKE poz_file.*  #FUN-730012
DEFINE l_oea904 LIKE oea_file.oea904    #FUN-730012
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_argv0 LIKE ogb_file.ogb09
 
   LET l_argv0=l_oga.oga09  #FUN-730012
   IF cl_null(l_oga.oga16) THEN     #modi in 00/02/24 by kammy
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM ogb_file
       WHERE ogb01=l_oga.oga01
 
      #kim:當新增第一筆單身資料的時候會發生l_cnt=0的狀況,
      #AFTER FIELD ogb31和ogb16 會來呼叫此函數,
      #確認和過帳段因為會先檢查無單身資料不可確認,所以l_cnt=0的狀況不會發生在確認和過帳段
 
      IF l_cnt=0 THEN
         LET l_oea01 = p_ogb31
        #MOD-6C0118-begin-add
          SELECT oea99 INTO l_oea99 FROM oea_file  #TQC-730012 modify #MOD-850026 mark ogb_file
           WHERE oea01 = p_ogb31
        #MOD-6C0118-end-add
      ELSE
        #只讀取第一筆訂單之資料
        LET l_sql= " SELECT oea01,oea99 FROM oea_file,ogb_file ",  #MOD-6C0118 add oea99
                   "  WHERE oea01 = ogb31 ",
                   "    AND ogb01 = '",l_oga.oga01,"'",
                   "    AND oeaconf = 'Y' ",  #01/08/16 mandy
                   "  ORDER BY ogb03"  #No.MOD-570362
        PREPARE oea_pre FROM l_sql
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f
        IF SQLCA.sqlcode THEN
           RETURN FALSE,l_poz.*,l_oea99,l_oea904
        END IF
        FETCH oea_f INTO l_oea01,l_oea99  #MOD-6C0118 add oea99
        IF SQLCA.sqlcode THEN
           RETURN FALSE,l_poz.*,l_oea99,l_oea904
        END IF
      END IF
   ELSE
      #讀取該出貨單之訂單
      SELECT oea01,oea99 INTO l_oea01,l_oea99  #MOD-6C0118 add oea99
        FROM oea_file
       WHERE oea01 = l_oga.oga16
         AND oeaconf = 'Y' #01/08/16 mandy
   END IF
   SELECT oea904 INTO l_oea904 FROM oea_file WHERE oea99 = l_oea99  #MOD-6C0118
   SELECT * INTO l_poz.* FROM poz_file WHERE poz01 = l_oea904
   IF STATUS THEN
      CALL cl_err('','axm-318',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   IF l_argv0 = '4' AND l_poz.poz00='2' THEN
      CALL cl_err(l_oea904,'tri-008',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   IF l_argv0 = '6' AND l_poz.poz00='1' THEN
      CALL cl_err(l_oea904,'tri-008',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   RETURN TRUE,l_poz.*,l_oea99,l_oea904   #NO.TQC-740089
END FUNCTION







FUNCTION t600sub_chk_img(l_oga,l_ogb)
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




FUNCTION t600sub_chk_ogb15_fac(l_oga,l_ogb)
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



FUNCTION t600sub_bu1(l_oga,l_ogb)   #更新訂單待出貨單量及已出貨量
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
    
   IF t600sub_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
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





FUNCTION t600sub_update_7(l_oga,l_oha,l_ohb)
   DEFINE l_qty    LIKE img_file.img10,
          l_ima01  LIKE ima_file.ima01,
          l_ima25  LIKE ima_file.ima01,
          p_img record like img_file.*,
          l_img RECORD
                img10   LIKE img_file.img10,
                img16   LIKE img_file.img16,
                img23   LIKE img_file.img23,
                img24   LIKE img_file.img24,
                img09   LIKE img_file.img09,
                img21   LIKE img_file.img21
                END RECORD,
          l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_ima71  LIKE ima_file.ima71
   DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
   DEFINE l_occ31  LIKE occ_file.occ31
   DEFINE l_tuq06  LIKE tuq_file.tuq06
   DEFINE l_tup05  LIKE tup_file.tup05
   DEFINE l_tuq07  LIKE tuq_file.tuq07
   DEFINE l_desc   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)
   DEFINE l_oha RECORD LIKE oha_file.*
   DEFINE l_ohb RECORD LIKE ohb_file.*
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_ima86 LIKE ima_file.ima86    #FUN-730018
   DEFINE l_tup06 LIKE tup_file.tup06    #MOD-B30651 add
#FUN-910088--add--start--
   DEFINE l_tup05_1   LIKE tup_file.tup05,
          l_tuq07_1   LIKE tuq_file.tuq07,
          l_tuq09_1   LIKE tuq_file.tuq09
#FUN-910088--add--end--
   DEFINE l_msg   STRING                 #MOD-C50020
 
   IF l_ohb.ohb15 IS NULL THEN
      INITIALIZE p_img.* TO NULL
      LET p_img.img01=l_ohb.ohb04
      LET p_img.img02=l_ohb.ohb09
      LET p_img.img03=l_ohb.ohb091
      LET p_img.img04=l_ohb.ohb092
      LET p_img.img09=l_ohb.ohb05
      LET p_img.img10=0
      LET l_ohb.ohb15=l_ohb.ohb05
 
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=p_img.img01
        IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
           CALL cl_err('ima25 null',SQLCA.sqlcode,0)
           LET g_success = 'N'
           RETURN
        END IF
 
        CALL s_umfchk(p_img.img01,p_img.img09,l_ima25)
             RETURNING l_cnt,p_img.img21
        IF l_cnt = 1 THEN
           CALL cl_err('','mfg3075',0)
          #MOD-C50020---S---
           CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
           LET l_msg = l_msg CLIPPED,":",p_img.img01
           CALL cl_err(l_msg,'mfg3075',0)  #MOD-C50020 add l_msg
          #MOD-C50020---E---
           LET g_success = 'N'
           RETURN
        END IF
        SELECT ime05,ime06 into p_img.img23,p_img.img24 FROM ime_file
         WHERE ime01=p_img.img02 and ime02=p_img.img03
          AND imeacti = 'Y'     #FUN-D40103
        IF SQLCA.sqlcode THEN
           SELECT imd11,imd12 into p_img.img23,p_img.img24 FROM  imd_file
            WHERE imd01=p_img.img02
        END IF
        IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
           CALL cl_err('imd23,imd24',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF
 
      LET p_img.imgplant = g_plant 
      LET p_img.imglegal = g_legal 
 
      INSERT INTO img_file VALUES(p_img.*)
      IF STATUS THEN
         CALL cl_err3("ins","img_file","","","axm-186","","l_ohb.ohb15 null:",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
   END IF

   LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21",
                      " FROM img_file ",
                      "  WHERE img01= ?  AND img02= ? AND img03= ? ",
                      " AND img04= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE img_lock7 CURSOR FROM g_forupd_sql

   OPEN img_lock7 USING l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092
   IF STATUS THEN
      CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
   END IF
 
   FETCH img_lock7 INTO l_img.*
   IF STATUS THEN
      CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
   END IF
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 + l_ohb.ohb16
   CALL s_upimg(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,+1,l_ohb.ohb16,g_today,  #FUN-8C0084
          '','','','',l_ohb.ohb01,l_ohb.ohb03,'','','','','','','','','','','','')  #No.FUN-850100
   IF g_success='N' THEN
      CALL cl_err('s_upimg()','9050',0) RETURN
   END IF

   #Update ima_file
   LET g_forupd_sql ="SELECT ima25 FROM ima_file ", #FUN-730018
                     " WHERE ima01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ima_lock7 CURSOR FROM g_forupd_sql

   OPEN ima_lock7 USING l_ohb.ohb04
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF

   FETCH ima_lock7 INTO l_ima25,l_ima86 #FUN-730018
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   Call s_udima(l_ohb.ohb04,l_img.img23,l_img.img24,l_ohb.ohb16*l_img.img21,
                #g_today,+1)  RETURNING l_cnt   #MOD-920298
                l_oha.oha02,+1)  RETURNING l_cnt   #MOD-920298
   #最近一次發料日期 表發料
   IF l_cnt THEN
      CALL cl_err('Update Faile',SQLCA.SQLCODE,2)
      LET g_success='N' RETURN
   END IF
   IF g_success='Y' THEN
      CALL t600sub_tlf_7(l_ima25,l_qty,l_oha.*,l_ohb.*,l_ima86)
   END IF
   #
   if l_ohb.ohb092=' ' then display '空 ' end if
   if cl_null(l_ohb.ohb092) then display 'null' end if
   #
   IF g_success = 'N' THEN RETURN END IF
  SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=l_oha.oha03    #No.TQC-640123
  IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
  IF l_occ31 = 'N' THEN RETURN END IF
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
   IF l_oga.oga00 ='7' THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tuq_file
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
         AND tuq11 ='2'
         AND tuq12 =l_oha.oha04
         AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
      IF l_cnt=0 THEN
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_ima25 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
             END IF
         END IF
       #FUN-910088--add--start--
         LET l_tuq09_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,  #MOD-7A0084 modify
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)   #FUN-980010 add plant & legal 
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,l_ohb.ohb03,    #No.TQC-640123  #MOD_7A0084 modify
          #      l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_ohb.ohb12*l_fac1*-1,'2','2',l_oha.oha04,    #FUN-910088--mark--
                 l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_tuq09_1,'2','2',l_oha.oha04,             #FUN-910088--add
                 g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
      ELSE
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04     #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='2'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_tuq06 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
            END IF
         END IF
         SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='2'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
         IF l_tuq07-l_ohb.ohb12*l_fac1<0 THEN
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07=l_ohb.ohb12*l_fac1 THEN
            DELETE FROM tuq_file
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04  #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='2'
               AND tuq12 =l_oha.oha04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN
               CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(l_ohb.ohb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
       #FUN-910088--add--start--
          LET l_tuq07_1 = l_ohb.ohb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                              tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start-- 
       #     UPDATE tuq_file SET tuq07=tuq07-l_ohb.ohb12*l_fac1,
       #                         tuq09=tuq09-l_ohb.ohb12*l_fac1*l_fac2,
       #FUN-910088--mark--end--
                                tuq10=l_desc
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04      #No.RTQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='2'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         END IF
      END IF
   ELSE
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tuq_file
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
         AND tuq11 ='1'
         AND tuq12 =l_oha.oha04
         AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
      IF l_cnt=0 THEN
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_ima25 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
             END IF
         END IF
       #FUN-910088--add--start--
         LET l_tuq09_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,  #MOD-7A0084 modify
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)   #FUN-980010 add plant & legal 
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,l_ohb.ohb03,     #No.TQC-640123  #MOD-7A0084 modify
              #   l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_ohb.ohb12*l_fac1*-1,'2','1',l_oha.oha04,    #FUN-910088--mark--
                  l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_tuq09_1,'2','1',l_oha.oha04,                #FUN-910088--add--
                 g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
      ELSE
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04     #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='1'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_tuq06 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
            END IF
         END IF
         SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='1'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
         IF l_tuq07-l_ohb.ohb12*l_fac1<0 THEN
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07=l_ohb.ohb12*l_fac1 THEN
            DELETE FROM tuq_file
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04  #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='1'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN
               CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(l_ohb.ohb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
        #FUN-910088--add--start--
            LET l_tuq07_1 = l_ohb.ohb12*l_fac1
            LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
            LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2
            LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
            UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                                tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start--
       #    UPDATE tuq_file SET tuq07=tuq07-l_ohb.ohb12*l_fac1,
       #                        tuq09=tuq09-l_ohb.ohb12*l_fac1*l_fac2,
       #FUN-910088-mark--end--
                                tuq10=l_desc
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04      #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='1'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         END IF
      END IF
   END IF
   LET l_fac1=1
   IF l_ohb.ohb05 <> l_ima25 THEN
      CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
           RETURNING l_cnt,l_fac1
      IF l_cnt = '1'  THEN
         CALL cl_err(l_ohb.ohb04,'abm-731',1)
         LET l_fac1=1
      END IF
   END IF
   IF l_oga.oga00 ='7' THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tup_file
       WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04    #No.TQC-640123
         AND tup03=l_ohb.ohb092
         AND ((tup08='2' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
              (tup11='2' AND tup12=l_oha.oha04))     #FUN-690083 modify
      IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF  #FUN-790001 add
      IF l_cnt=0 THEN
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12,
                              tupplant,tuplegal)   #FUN-980010 add plant & legal    #MOD-9C0330
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_ima25,   #No.TQC-640123
               #l_ohb.ohb12*l_fac1*-1,l_ima71+l_oha.oha02,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04, #MOD-B30651 mark
               #l_ohb.ohb12*l_fac1*-1,l_tup06,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04,             #MOD-B30651  #FUN-910088--mark--
                l_tup05_1,l_tup06,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04,                         #FUN-910088--add--
                g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      ELSE
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1   
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
       # UPDATE tup_file SET tup05=tup05-l_ohb.ohb12*l_fac1        #FUN-910088--mark--
         UPDATE tup_file SET tup05=tup05-l_tup05_1                 #FUN-910088--add--
          WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04   #No.TQC-640123
            AND tup03=l_ohb.ohb092
            AND ((tup08='2' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
                 (tup11='2' AND tup12=l_oha.oha04))     #FUN-690083 modify
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","update tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      END IF
   ELSE
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tup_file
       WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04    #No.TQC-640123
         AND tup03=l_ohb.ohb092
         AND ((tup08='1' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
              (tup11='1' AND tup12=l_oha.oha04))     #FUN-690083 modify
      IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF   #FUN-790001 add
      IF l_cnt=0 THEN
      #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12,
                              tupplant,tuplegal)   #FUN-980010 add plant & legal    #MOD-9C0330
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_ima25,   #No.TQC-640123
               #l_ohb.ohb12*l_fac1*-1,l_ima71+l_oha.oha02,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04, #MOD-B30651 mark
              # l_ohb.ohb12*l_fac1*-1,l_tup06,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04,             #MOD-B30651   #FUN-910088--mark--
                l_tup05_1,l_tup06,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04,                         #FUN-910088--add--
                g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      ELSE
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
      #  UPDATE tup_file SET tup05=tup05-l_ohb.ohb12*l_fac1        #FUN-910088--mark--
         UPDATE tup_file SET tup05=tup05-l_tup05_1                 #FUN-910088--add--
          WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04   #No.TQC-640123
            AND tup03=l_ohb.ohb092
            AND ((tup08='1' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
                 (tup11='1' AND tup12=l_oha.oha04))     #FUN-690083 modify
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","update tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION






FUNCTION t600sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,l_oga)
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
         p_type     LIKE type_file.num10      #No.FUN-680137 INTEGER
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_msg     STRING                 #MOD-C50020
   #TQC-D50131--add--str--
   DEFINE l_ogb     RECORD LIKE ogb_file.*   
   DEFINE l_imm01   LIKE imm_file.imm01      
   DEFINE l_unit_arr      DYNAMIC ARRAY OF RECORD    
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
   #TQC-D50131--add--end--
 
    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "  WHERE imgg01= ?  AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "    AND imgg09= ? FOR UPDATE "   #FUN-560043
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09   #FUN-560043
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-670008
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no ='2') THEN
       CALL cl_err('','mfg3075',0)
      #MOD-C50020---S---
       CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
       LET l_msg = l_msg CLIPPED,":",p_imgg01
       CALL cl_err(l_msg,'mfg3075',0)     #MOD-C50020 add l_msg
      #MOD-C50020---E---
       LET g_success = 'N' RETURN
    END IF
 
    #TQC-D50131--add--str--
    IF g_sma.sma115 = 'Y' THEN
       DECLARE t600sub_s1_c2_1 CURSOR FOR SELECT * FROM ogb_file
         WHERE ogb01 = l_oga.oga01
       FOREACH t600sub_s1_c2_1 INTO l_ogb.*
          IF STATUS THEN
             EXIT FOREACH
          END IF
 
          SELECT ima906 INTO l_ima906 FROM ima_file  
           WHERE ima01=l_ogb.ogb04                 
          IF l_ima906 = '2' THEN  #子母單位         
             LET l_unit_arr[1].unit= l_ogb.ogb910
             LET l_unit_arr[1].fac = l_ogb.ogb911
             LET l_unit_arr[1].qty = l_ogb.ogb912
             LET l_unit_arr[2].unit= l_ogb.ogb913
             LET l_unit_arr[2].fac = l_ogb.ogb914
             LET l_unit_arr[2].qty = l_ogb.ogb915
             CALL s_dismantle_1(l_oga.oga01,l_ogb.ogb03,l_oga.oga02,
                             l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                             l_ogb.ogb092,l_unit_arr,l_imm01)
                  RETURNING l_imm01
             IF g_success='N' THEN    
                LET g_totsuccess='N'
                LET g_success="Y"
                CONTINUE FOREACH
             END IF
          END IF
       END FOREACH
    END IF
    #TQC-D50131--add--end--

    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,l_oga.oga02, #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION



FUNCTION t600sub_upd_tlff_oh(p_flag,p_unit,p_fac,p_qty,l_oha,l_ohb)
DEFINE
   p_flag     LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(1)
   p_unit     LIKE img_file.img09,
   p_fac      LIKE img_file.img21,
   p_qty      LIKE img_file.img10,
   p_lineno   LIKE ogb_file.ogb03,
   l_imgg10   LIKE imgg_file.imgg10,
   l_ima25    LIKE ima_file.ima25,
   l_ima86    LIKE ima_file.ima86,
   l_oha      RECORD LIKE oha_file.*,
   l_ohb      RECORD LIKE ohb_file.*
 
   LET g_forupd_sql ="SELECT ima25,ima86 FROM ima_file ",
                     " WHERE ima01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ima_lock8 CURSOR FROM g_forupd_sql

   OPEN ima_lock8 USING l_ohb.ohb04
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
   FETCH ima_lock8 INTO l_ima25,l_ima86
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
 
   INITIALIZE g_tlff.* TO NULL
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01=l_ohb.ohb04 AND imgg02=l_ohb.ohb09
      AND imgg03=l_ohb.ohb091   AND imgg04=l_ohb.ohb092
      AND imgg09=p_unit
   IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
   LET g_tlff.tlff01=l_ohb.ohb04         #異動料件編號
   LET g_tlff.tlff02=731                 #來源碼
   LET g_tlff.tlff020=' '
   LET g_tlff.tlff021=' '                #倉庫
   LET g_tlff.tlff022=' '                #儲位
   LET g_tlff.tlff023=' '                #批號
   LET g_tlff.tlff024=0                  #異動後數量
   LET g_tlff.tlff025=' '                #庫存單位(ima_file or img_file)
   LET g_tlff.tlff026=l_oha.oha01        #銷退單號
   LET g_tlff.tlff027=l_ohb.ohb03        #銷退項次
   #---目的----
   LET g_tlff.tlff03=50
   LET g_tlff.tlff030=l_ohb.ohb08
   LET g_tlff.tlff031=l_ohb.ohb09        #倉庫
   LET g_tlff.tlff032=l_ohb.ohb091       #儲位
   LET g_tlff.tlff033=l_ohb.ohb092       #批號
   LET g_tlff.tlff034=l_imgg10           #異動後庫存數量
   LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlff.tlff036=l_ohb.ohb01        #銷退單號
   LET g_tlff.tlff037=l_ohb.ohb03        #銷退項次
 
   #-->異動數量
   LET g_tlff.tlff04= ' '             #工作站
   LET g_tlff.tlff05= ' '             #作業序號
   LET g_tlff.tlff06=l_oha.oha02      #發料日期
   LET g_tlff.tlff07=g_today          #異動資料產生日期
   LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
   LET g_tlff.tlff09=g_user           #產生人
   LET g_tlff.tlff10=p_qty            #異動數量
   LET g_tlff.tlff11=p_unit           #發料單位
   LET g_tlff.tlff12=p_fac            #發料/庫存 換算率
   LET g_tlff.tlff13='aomt800'
   LET g_tlff.tlff14=' '              #異動原因
 
   LET g_tlff.tlff17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ohb.ohb04)
        RETURNING g_tlff.tlff18
   LET g_tlff.tlff19=l_oha.oha04
   SELECT oga46 INTO g_tlff.tlff20 FROM oga_file WHERE oga01=l_ohb.ohb31
   LET g_tlff.tlff61= l_ima86 #FUN-730018
   LET g_tlff.tlff62=l_ohb.ohb32    #參考單號(訂單)
   LET g_tlff.tlff63=l_ohb.ohb33    #訂單項次
   LET g_tlff.tlff64=l_ohb.ohb52    #手冊編號 no.A050
   LET g_tlff.tlff66=p_flag         #for axcp500多倉出貨處理   #No:8741
   LET g_tlff.tlff930=l_ohb.ohb930  #FUN-670063
   IF cl_null(l_ohb.ohb915) OR l_ohb.ohb915=0 THEN
      CALL s_tlff(p_flag,NULL)
   ELSE
      CALL s_tlff(p_flag,l_ohb.ohb913)
   END IF
END FUNCTION




FUNCTION t600sub_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_item,l_oga,l_ogb) #No:8741  #FUN-5C0075 #FUN-730012
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
       CALL t600sub_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,p_flag,p_item,l_ima86,l_oga.*,l_ogb.*) #No:8741  #FUN-5C0075
    END IF
END FUNCTION



#MOD-CB0050 add begin-----------
FUNCTION t600sub_chk_ogb1001(p_ogb1001)
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





#FUNCTION t600sub_consign(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,l_oga,l_ogb)  #No.FUN-630061 #CHI-AC0034 mark
FUNCTION t600sub_consign(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_item,l_oga,l_ogb)  #CHI-AC0034
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
      #CALL t600sub_contlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty2,p_uom,l_factor,l_oga.*,l_ogb.*,l_ima86)  #No.FUN-630061 #CHI-AC0034 mark
       CALL t600sub_contlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty2,p_uom,l_factor,p_flag,p_item,l_oga.*,l_ogb.*,l_ima86)  #CHI-AC0034
    END IF
 
END FUNCTION




FUNCTION t600sub_consign_mu(p_ware,p_loca,p_lot,l_oga,l_ogb)
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
    IF l_ogb.ogb17 ='Y' THEN #要将出货单的仓储批的批号带到签收单
       #FOREACH 母单位批号 数量
       DECLARE t600_sub_ogg_c1 CURSOR FOR  
        SELECT SUM(ogg16),ogg092 FROM ogg_file   
         WHERE ogg01=l_oga.oga01 
           AND ogg03=l_ogb.ogb03
           AND ogg20='2'
         GROUP BY ogg092   
       FOREACH t600_sub_ogg_c1 INTO l_qty2,p_lot  
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
                   CALL t600sub_set_imgg(l_ogb.ogb913,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
       
                   LET l_imgg.imggplant = g_plant 
                   LET l_imgg.imgglegal = g_legal 
       
                   INSERT INTO imgg_file VALUES (l_imgg.*)
                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                      LET g_success='N' RETURN
                   END IF
                END IF
                IF l_ima906 = '2' THEN
                   CALL t600sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2',l_oga.*)
                   IF g_success='N' THEN RETURN END IF
                   IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                      CALL t600sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                         l_ogb.ogb913,l_ogb.ogb914,l_qty2,l_oga.*,l_ogb.*,'1')
                   END IF   #No.MOD-790136 add
                   IF g_success='N' THEN RETURN END IF
                ELSE
                   CALL t600sub_upd_imgg('2',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2',l_oga.*)
                   IF g_success='N' THEN RETURN END IF
                   IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                      CALL t600sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                         l_ogb.ogb913,l_ogb.ogb914,l_qty2,l_oga.*,l_ogb.*,'1')
                   END IF   #No.MOD-790136 add
                   IF g_success='N' THEN RETURN END IF
                END IF
             END IF
          END IF          
       END FOREACH 
       
       #FOREACH 子单位批号 数量
       DECLARE t600_sub_ogg_c2 CURSOR FOR  
        SELECT SUM(ogg16),ogg092 FROM ogg_file   
         WHERE ogg01=l_oga.oga01 
           AND ogg03=l_ogb.ogb03
           AND ogg20='1'
         GROUP BY ogg092   
       FOREACH t600_sub_ogg_c2 INTO l_qty1,p_lot  
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
                   CALL t600sub_set_imgg(l_ogb.ogb910,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
       
                   LET l_imgg.imggplant = g_plant 
                   LET l_imgg.imgglegal = g_legal 
       
                   INSERT INTO imgg_file VALUES (l_imgg.*)
                   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                      LET g_success='N' RETURN
                   END IF
                END IF
                CALL t600sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb910,l_ogb.ogb911,l_qty1,+1,'1',l_oga.*)
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb912) THEN                                            #CHI-860005
                   CALL t600sub_contlff('1',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb910,l_ogb.ogb911,l_qty1,l_oga.*,l_ogb.*,'1')
                END IF   #No.MOD-790136 add
                IF g_success='N' THEN RETURN END IF
             END IF
          END IF                   
       END FOREACH 
    ELSE
#FUN-C50097 ADD END -----    	 
       IF l_ima906 MATCHES '[23]' THEN
          IF NOT cl_null(l_ogb.ogb913) THEN
             SELECT * INTO l_imgg.* FROM imgg_file
              WHERE imgg01= l_ogb.ogb04
                AND imgg02= p_ware
                AND imgg03= p_loca
                AND imgg04= p_lot
                AND imgg09= l_ogb.ogb913
             IF STATUS <> 0 THEN            ## 新增一筆img_file
                CALL t600sub_set_imgg(l_ogb.ogb913,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
    
                LET l_imgg.imggplant = g_plant 
                LET l_imgg.imgglegal = g_legal 
    
                INSERT INTO imgg_file VALUES (l_imgg.*)
                IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                   LET g_success='N' RETURN
                END IF
             END IF
             IF l_ima906 = '2' THEN
                CALL t600sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2',l_oga.*)
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                   CALL t600sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'2')
                END IF   #No.MOD-790136 add
                IF g_success='N' THEN RETURN END IF
             ELSE
                CALL t600sub_upd_imgg('2',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb913,l_ogb.ogb914,l_qty2,+1,'2',l_oga.*)
                IF g_success='N' THEN RETURN END IF
                IF NOT cl_null(l_ogb.ogb915) THEN                                            #CHI-860005
                   CALL t600sub_contlff('2',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                      l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'2')
                END IF   #No.MOD-790136 add
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
                CALL t600sub_set_imgg(l_ogb.ogb910,p_ware,p_loca,p_lot,l_ogb.*) RETURNING l_imgg.*
    
                LET l_imgg.imggplant = g_plant 
                LET l_imgg.imgglegal = g_legal 
    
                INSERT INTO imgg_file VALUES (l_imgg.*)
                IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err3("ins","imgg_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
                   LET g_success='N' RETURN
                END IF
             END IF
             CALL t600sub_upd_imgg('1',l_imgg.imgg01,l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                l_ogb.ogb910,l_ogb.ogb911,l_qty1,+1,'1',l_oga.*)
             IF g_success='N' THEN RETURN END IF
             IF NOT cl_null(l_ogb.ogb912) THEN                                            #CHI-860005
                CALL t600sub_contlff('1',l_imgg.imgg02,l_imgg.imgg03,l_imgg.imgg04,
                                   l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,l_oga.*,l_ogb.*,'2')
             END IF   #No.MOD-790136 add
             IF g_success='N' THEN RETURN END IF
          END IF
       END IF
    END IF  #FUN-C50097 ADD    
 
END FUNCTION




FUNCTION t600sub_s_du(l_oga,l_ogb)
  DEFINE l_ima25   LIKE ima_file.ima25,
         u_type    LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_ima906  LIKE ima_file.ima906,
         l_ima907  LIKE ima_file.ima907,
         l_oga     RECORD LIKE oga_file.*,
         l_ogb     RECORD LIKE ogb_file.*
 
   SELECT ima906,ima907,ima25
     INTO l_ima906,l_ima907,l_ima25
     FROM ima_file
    WHERE ima01 = l_ogb.ogb04
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF cl_null(l_ima906) OR l_ima906 = '1' THEN RETURN END IF
 
   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_ogb.ogb913) THEN
         CALL t600sub_upd_imgg('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,-1,'2',l_oga.*)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ogb.ogb915) THEN                                #CHI-960005
            CALL t600sub_tlff('2',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'2')   #No:FUN-BB0081
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(l_ogb.ogb910) THEN
         CALL t600sub_upd_imgg('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,-1,'1',l_oga.*)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ogb.ogb912) THEN                                #CHI-960005
            CALL t600sub_tlff('1',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,l_oga.*,l_ogb.*,'2')   #No:FUN-BB0081
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_ogb.ogb913) THEN
         CALL t600sub_upd_imgg('2',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,-1,'2',l_oga.*)
         IF g_success='N' THEN RETURN END IF
         IF NOT cl_null(l_ogb.ogb915) THEN                                 #CHI-960005  
            CALL t600sub_tlff('2',l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_oga.*,l_ogb.*,'2')   #No:FUN-BB0081
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
 
END FUNCTION




FUNCTION t600_tqw081_update(p_code)
DEFINE p_code    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
       t_ogb     RECORD LIKE ogb_file.*

   DECLARE ogb_conf CURSOR FOR
    SELECT * FROM ogb_file
     WHERE  ogb01 = g_oga.oga01
       AND ogb_file.ogb1005='2'
    OPEN ogb_conf
    FOREACH ogb_conf INTO t_ogb.*
      IF STATUS THEN
         CALL cl_err('foreach ogb',STATUS,0)
         RETURN
      END IF
      IF p_code=1 THEN
         IF t_ogb.ogb1010='N' THEN
            UPDATE tqw_file set tqw081=tqw081+t_ogb.ogb14
             WHERE tqw01=t_ogb.ogb1007
         ELSE
            UPDATE tqw_file set tqw081=tqw081+t_ogb.ogb14t
             WHERE tqw01=t_ogb.ogb1007
         END IF
      ELSE
          IF t_ogb.ogb1010='N' THEN
             UPDATE tqw_file set tqw081=tqw081-t_ogb.ogb14
              WHERE tqw01=t_ogb.ogb1007
          ELSE
             UPDATE tqw_file set tqw081=tqw081-t_ogb.ogb14t
              WHERE tqw01=t_ogb.ogb1007
          END IF
      END IF
      IF SQLCA.SQLCODE THEN
         LET g_success='N'
         RETURN
      END IF

    END FOREACH

END FUNCTION



FUNCTION t600_gen_return_note(l_oga)   #MOD-790150 modify l_oga
DEFINE l_oga     RECORD LIKE oga_file.*,
       l_ogb     RECORD LIKE ogb_file.*,
       l_ogbi    RECORD LIKE ogbi_file.*,#No.FUN-7C0017
       l_ogb12   LIKE ogb_file.ogb12,
       l_ogb915  LIKE ogb_file.ogb12,
       l_ogb912  LIKE ogb_file.ogb12,
       l_ogb917  LIKE ogb_file.ogb12,
       li_result LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_cnt     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       tm        RECORD
                 oga01 LIKE oay_file.oayslip,  #No.FUN-680137 VARCHAR(5)
                 cware LIKE img_file.img02,
                 cloc  LIKE img_file.img03
                 END RECORD
DEFINE p_row,p_col LIKE type_file.num5
DEFINE l_t1      LIKE type_file.chr5
DEFINE p_oga01   LIKE oga_file.oga01    #MOD-790150
DEFINE l_rvbs     RECORD LIKE rvbs_file.*   #CHI-970040
DEFINE l_rvbs06a  LIKE rvbs_file.rvbs06     #CHI-970040
DEFINE l_rvbs06b  LIKE rvbs_file.rvbs06     #CHI-970040
DEFINE i          LIKE type_file.num5   #MOD-A10163
DEFINE l_msg      STRING                 #CHI-AC0034 add 
DEFINE l_tot1     LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE l_flag     LIKE type_file.chr1    #CHI-AC0034 add
DEFINE l_ogc      RECORD LIKE ogc_file.* #CHI-AC0034 add
DEFINE l_ogc12    LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE l_img09    LIKE img_file.img09    #CHI-AC0034 add
DEFINE l_idb      RECORD LIKE idb_file.*  #FUN-B40066
DEFINE l_ogg      RECORD LIKE ogg_file.*  #120725 FUN-C50097    

#DEFINE l_ogc_1    RECORD LIKE ogc_file.*     #CHI-B30093 #CHI-B60054 mark CHI-B30093
#DEFINE l_ogc12_1    LIKE ogc_file.ogc12   #TQC-B50099    #CHI-B60054 mark TQC-B50099
#DEFINE l_ogc09_1    LIKE ogc_file.ogc09   #TQC-B50099    #CHI-B60054 mark TQC-B50099
#DEFINE l_ogc091_1   LIKE ogc_file.ogc09   #TQC-B50099    #CHI-B60054 mark TQC-B50099 
   #檢查是否有驗退數量
   SELECT COUNT(*) INTO l_cnt
     FROM ogb_file b1,oga_file a1
    WHERE b1.ogb01 = l_oga.oga01
      AND a1.oga01 = b1.ogb01
      AND b1.ogb12 < (SELECT SUM(b2.ogb12) FROM oga_file a2,ogb_file b2
                       WHERE a2.oga01 = b2.ogb01
                        #AND a2.oga09 = '2'
                        #AND (a2.oga09 = '2' OR a2.oga09 = '3') #FUN-BB0167      #FUN-C40072 mark
                         AND (a2.oga09 = '2' OR a2.oga09 = '3' OR a2.oga09= '4') #FUN-C40072 add
                         AND a2.oga65 = 'Y'
                         AND a1.oga011 = a2.oga01
                         AND b1.ogb03 = b2.ogb03)
 
   IF l_cnt = 0 THEN RETURN END IF
 
   LET tm.oga01= NULL
   LET tm.cware=g_oaz.oaz76
   LET tm.cloc =g_oaz.oaz77
 
   LET p_row = 2 LET p_col = 39
 
   OPEN WINDOW t6281_w AT p_row,p_col WITH FORM "axm/42f/axmt6281"   #CHI-690060
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmt6281")   #CHI-690060
 
   INPUT BY NAME tm.oga01,tm.cware,tm.cloc WITHOUT DEFAULTS
 
      AFTER FIELD oga01
         IF NOT cl_null(tm.oga01) THEN
            CALL s_check_no("axm",tm.oga01,"","59","oga_file","oga01","")
                 RETURNING li_result,tm.oga01
            IF (NOT li_result) THEN
               NEXT FIELD oga01
            END IF
         END IF
 
      AFTER FIELD cware
         IF NOT cl_null(tm.cware) THEN
            SELECT * FROM imd_file
             WHERE imd01 = tm.cware
               AND imdacti = 'Y'
            IF STATUS <> 0 THEN
               CALL cl_err3("sel","imd_file",tm.cware,"","ams-004","","",1)  #No.FUN-670008
               NEXT FIELD cware
            END IF
 
            SELECT COUNT(*) INTO l_cnt FROM ogb_file
             WHERE ogb01 = l_oga.oga01
               AND ogb09 = tm.cware
            IF l_cnt > 0 THEN
               CALL cl_err('','axm-424',0)
               LET tm.cware=' '
               NEXT FIELD cware #No:8570
            END IF
            IF g_azw.azw04='2' THEN                                                                                                 
               LET l_cnt=0                                                                                                          
               SELECT COUNT(*) INTO l_cnt  FROM jce_file                                                                     
                WHERE jce02=tm.cware                                                                                                
               IF l_cnt !=0 THEN                                                                                             
                  CALL cl_err(tm.cware,'art-452',0)                                                                                 
                  NEXT FIELD cware                                                                                                  
               END IF                                                                                                               
               #No.FUN-AA0048  --Begin
               #LET l_cnt =0                                                                                                    
               #SELECT COUNT(*) INTO l_cnt FROM imd_file                                                                      
               # WHERE imd01=tm.cware                                                                                                
               #   AND imd20=g_plant                                                                                        
               #IF l_cnt=0 THEN                                                                                               
               #   CALL cl_err(tm.cware,'art-487',0)                                                                                 
               #   NEXT FIELD cware                                                                                                  
               #END IF                                                                                                               
               #No.FUN-AA0048  --End  
            END IF
            #No.FUN-AA0048  --Begin
            IF NOT s_chk_ware(tm.cware) THEN
               NEXT FIELD cware
            END IF
            #No.FUN-AA0048  --End  
         END IF
#FUN-D40103 -------Begin-------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc
         END IF
 #FUN-D40103 -------End---------
 
      AFTER FIELD cloc
         IF cl_null(tm.cloc) THEN   #FUN-630102 modify
            LET tm.cloc = ' '
         END IF
 #FUN-D40103 -------Begin------
       ##-----MOD-B40260---------
       ##start FUN-630102 mark
       #SELECT * FROM ime_file
       # WHERE ime01 = tm.cware
       #   AND ime02 = tm.cloc
       ##   AND ime04 = 'S'
       #IF STATUS <> 0 THEN
       #   CALL cl_err('','mfg0095',0)
       #   NEXT FIELD cloc
       #END IF
       ##end FUN-630102 mark
       ##-----END MOD-B40260-----
        IF NOT s_imechk(tm.cware,tm.cloc) THEN
           NEXT FIELD cloc
        END IF
  #FUN-D40103 -------End--------- 
 
         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01  = l_oga.oga01
            AND ogb09 = tm.cware
            AND ogb091 = tm.cloc
         IF l_cnt > 0 THEN
            CALL cl_err('','axm-424',0)
            LET tm.cloc=' '
            NEXT FIELD cware
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

  #-----MOD-B40260---------
        IF cl_null(tm.cloc) THEN LET tm.cloc = ' ' END IF
     #FUN-D40103 -----Begin-----
      # #start FUN-630102 mark
      # SELECT * FROM ime_file
      #  WHERE ime01 = tm.cware
      #    AND ime02 = tm.cloc
      # #   AND ime04 = 'S'
      # IF STATUS <> 0 THEN
      #    CALL cl_err('','mfg0095',0)
      #    LET tm.cloc=' '
      #    NEXT FIELD cloc
      # END IF
      # #end FUN-630102 mark
        IF NOT s_imechk(tm.cware,tm.cloc) THEN
           LET tm.cloc=' '
           NEXT FIELD cloc
        END IF  
     #FUN-D40103 -----End-------
        #-----END MOD-B40260-----

         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01 = l_oga.oga01 AND ogb09 = tm.cware
         IF l_cnt > 0 THEN
            CALL cl_err('','axm-424',0)
            LET tm.cloc=' '
            #NEXT FIELD tm.cware #MOD-C50194 mark
            NEXT FIELD cware     #MOD-C50194 add
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oga01)
                LET l_t1=s_get_doc_no(tm.oga01)       #No.FUN-550052
              # CALL q_oay(FALSE,TRUE,l_t1,'59',g_sys) RETURNING l_t1       #FUN-A70130 mark
                CALL q_oay(FALSE,TRUE,l_t1,'59','axm') RETURNING l_t1       #FUN-A70130
                LET tm.oga01 = l_t1            #No.FUN-550052
                DISPLAY BY NAME tm.oga01
                NEXT FIELD oga01
            WHEN INFIELD(cware)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_imd"
                 #LET g_qryparam.arg1     = 'S'        #倉庫類別 #MOD-4A0213
                 #LET g_qryparam.default1 = tm.cware
                 #CALL cl_create_qry() RETURNING tm.cware
                 CALL q_imd_1(FALSE,TRUE,tm.cware,'S',"","","") RETURNING tm.cware 
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME tm.cware
            WHEN INFIELD(cloc)
                 #No.FUN-AA0048  --Begin
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_ime"
                 #LET g_qryparam.default1 = tm.cloc
                 #LET g_qryparam.arg1     = tm.cware #倉庫編號
                 #LET g_qryparam.arg2     = "S"      #倉庫類別
                 #CALL cl_create_qry() RETURNING tm.cloc
                 CALL q_ime_1(FALSE,TRUE,tm.cloc,tm.cware,"S","","","","") RETURNING tm.cloc 
                 #No.FUN-AA0048  --End  
                 DISPLAY BY NAME tm.cloc
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET g_success = 'N'
      CLOSE WINDOW t6281_w
      RETURN
   END IF
 
   CLOSE WINDOW t6281_w
 
   LET p_oga01 = l_oga.oga01  #MOD-790150 #foreach單身key值用
 
   CALL s_auto_assign_no("axm",tm.oga01,g_today,"","oga_file","oga01","","","")
     RETURNING li_result,l_oga.oga01
 
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   IF cl_null(l_oga.oga01) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   BEGIN WORK
 
  #LET l_oga.oga02  = g_today     #MOD-B70130 mark
   LET l_oga.oga02  = l_oga.oga02 #MOD-B70130
   LET l_oga.oga011 = l_oga.oga011
   LET l_oga.oga66  = tm.cware
   LET l_oga.oga67  = tm.cloc
   LET l_oga.oga09  = '9'
   LET l_oga.ogaconf= 'Y'
   LET l_oga.ogapost= 'Y'
   LET l_oga.ogaprsw= 0
   LET l_oga.oga55  = '0'
   LET l_oga.oga57  = '1'           #FUN-AC0055 add
   LET l_oga.oga56  = p_oga01 #FUN-C50097 ADD 簽收單號
   LET l_oga.oga65  = 'N'
 
   SELECT oayapr INTO l_oga.ogamksg FROM oay_file
    WHERE oayslip = tm.oga01
   LET l_oga.oga85=' ' #No.FUN-870007
   LET l_oga.oga94='N' #No.FUN-870007
 
   LET l_oga.ogaplant = g_plant 
   LET l_oga.ogalegal = g_legal 
 
   LET l_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES (l_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('ins oga',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF
 
   DECLARE t600_ins_ogb_c2 CURSOR FOR
    SELECT * FROM ogb_file
     WHERE ogb01= p_oga01              #MOD-790150 modify l_oga.oga01
   CALL s_showmsg_init()               #No.FUN-710046
   FOREACH t600_ins_ogb_c2 INTO l_ogb.*
      IF STATUS THEN
         CALL s_errmsg('','',"t600_ins_ogb_c1 foreach:",SQLCA.sqlcode,1)   #No.FUN-710046
         LET g_success = 'N'                   #No.FUN-8A0086
         EXIT FOREACH
      END IF
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF
 
      SELECT SUM(ogb12),SUM(ogb912),SUM(ogb915),SUM(ogb917)
        INTO l_ogb12,l_ogb912,l_ogb915,l_ogb917
        FROM oga_file,ogb_file
       WHERE ogb01 = oga01
        #AND oga09 = '2'
        #AND (oga09 = '2' OR oga09 = '3')   #FUN-BB0167  #FUN-C40072 mark
         AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4') #FUN-C40072 add
         AND oga65 = 'Y'
         AND oga01 = l_oga.oga011
         AND ogaconf = 'Y'
         AND ogapost = 'Y'
         AND ogb03 = l_ogb.ogb03
 
      IF l_ogb.ogb12 < l_ogb12 THEN
         LET l_ogb.ogb12 = l_ogb12 - l_ogb.ogb12
         LET l_ogb.ogb912= l_ogb912- l_ogb.ogb912
         LET l_ogb.ogb915= l_ogb915- l_ogb.ogb915
         LET l_ogb.ogb917= l_ogb917- l_ogb.ogb917
      ELSE
         CONTINUE FOREACH
      END IF
 
      LET l_ogb.ogb01 = l_oga.oga01
      LET l_ogb.ogb09 = tm.cware
      LET l_ogb.ogb091= tm.cloc
 
      SELECT COUNT(*) INTO l_cnt FROM ogb_file,oga_file
       WHERE oga01 = ogb01
         AND oga09 = '9'
         AND oga011 = l_oga.oga011
         AND ogb03 = l_ogb.ogb03
 
      IF l_cnt > 0 THEN
         CALL s_errmsg('','',l_ogb.ogb04,"axm-421",1)    #No.FUN-710046
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
 
      CALL t600_else(l_ogb.*) RETURNING l_ogb.*
      LET l_ogb.ogb44=' ' #No.FUN-870007
      LET l_ogb.ogb47=0   #No.FUN-870007
#FUN-AB0061 -----------add start----------------                          
      IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
         LET l_ogb.ogb37=l_ogb.ogb13                         
      END IF                                                                             
#FUN-AB0061 -----------add end----------------   
      LET l_ogb.ogbplant = g_plant 
      LET l_ogb.ogblegal = g_legal 

#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--
#      IF l_ogb.ogb17 = 'Y' THEN 
#         DECLARE t629_ogc_cs CURSOR FOR 
#          SELECT * FROM ogc_file WHERE ogc01 = p_oga01
#                                   AND ogc03 = l_ogb.ogb03
#         FOREACH t629_ogc_cs INTO l_ogc_1.*
#            LET l_ogc_1.ogc01 = l_ogb.ogb01 
#            LET l_ogc_1.ogc09 = l_ogb.ogb09
#            LET l_ogc_1.ogc091= l_ogb.ogb091
#            #No.TQC-B50099  --Begin
#            SELECT ogc09,ogc091 INTO l_ogc09_1,l_ogc091_1 FROM ogc_file, OUTER img_file
#             WHERE ogc01 = l_oga.oga011 
#               AND ogc03 = l_ogb.ogb03   
#               AND img01=l_ogb.ogb04
#               AND img02=ogc09
#               AND img03=ogc091
#               AND img04=ogc092
#               AND ogc092=l_ogc_1.ogc092
#                            
#            SELECT ogc12 INTO l_ogc12_1 FROM ogc_file
#             WHERE ogc01 = l_oga.oga011
#               AND ogc03 = l_ogb.ogb03
#               AND ogc09 = l_ogc09_1
#               AND ogc091= l_ogc091_1
#               AND ogc092= l_ogc_1.ogc092
#               AND ogc17 = l_ogb.ogb04
#            IF cl_null(l_ogc12_1) THEN LET l_ogc12_1 = 0 END IF
#            LET l_ogc_1.ogc12 = l_ogc12_1 - l_ogc_1.ogc12
#            IF l_ogc_1.ogc12 = 0 THEN
#               CONTINUE FOREACH
#            END IF
#            #No.TQC-B50099  --End
#            INSERT INTO ogc_file VALUES(l_ogc_1.*)
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#                CALL s_errmsg('','',"INS ogc",SQLCA.sqlcode,1)  
#                LET g_success='N'
#                EXIT FOREACH 
#            END IF 
#         END FOREACH                                    
#      END IF 
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
 
      INSERT INTO ogb_file VALUES(l_ogb.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('','',"INS ogb",SQLCA.sqlcode,1)  #No.FUN-710046
         LET g_success='N'
         CONTINUE FOREACH  #No.FUN-710046
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_ogbi.* TO NULL
            LET l_ogbi.ogbi01 = l_ogb.ogb01
            LET l_ogbi.ogbi03 = l_ogb.ogb03
            IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      LET g_ima918 = ''   #MOD-9C0055
      LET g_ima921 = ''   #MOD-9C0055
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = l_ogb.ogb04
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        #DECLARE t600sub_g_rvbs CURSOR FOR SELECT * FROM rvbs_file #CHI-BB0057 mark
         #CHI-BB0057 add start -----
         DECLARE t600sub_g_rvbs CURSOR FOR SELECT rvbs03,rvbs04,rvbs05,rvbs08
                                             FROM rvbs_file
         #CHI-BB0057 add end   -----
                                        WHERE rvbs01 = l_oga.oga011
                                          AND rvbs02 = l_ogb.ogb03
                                     GROUP BY rvbs03,rvbs04,rvbs05,rvbs08 #CHI-BB0057 add
         
         LET i = 1   #MOD-A10163
         #FOREACH t600sub_g_rvbs INTO l_rvbs.* #CHI-BB0057 mark
         FOREACH t600sub_g_rvbs INTO l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs08 #CHI-BB0057 add
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
               LET g_success='N'
            END IF
            #-----MOD-A10163---------
            LET l_cnt = 0 
            SELECT COUNT(*) FROM rvbs_file
             WHERE rvbs00[1,7] = 'axmt629'   #FUN-B40066 add [1,7]            
               AND rvbs01 = l_oga.oga01
               AND rvbs02 = l_ogb.ogb03
               AND rvbs09 = '-1'
               AND rvbs13 = 0 
               AND rvbs03 = l_rvbs.rvbs03
               AND rvbs04 = l_rvbs.rvbs04
            IF l_cnt > 0 THEN
               CONTINUE FOREACH
            END IF
            #-----END MOD-A10163-----

            #CHI-BB0057 add start -----
              SELECT * INTO l_rvbs.*
                FROM rvbs_file
               WHERE rvbs01 = l_oga.oga011
                 AND rvbs02 = l_ogb.ogb03
                 AND rvbs03 = l_rvbs.rvbs03
                 AND rvbs04 = l_rvbs.rvbs04
                 AND rvbs05 = l_rvbs.rvbs05
                 AND rvbs08 = l_rvbs.rvbs08
            #CHI-BB0057 add end   -----

            #LET l_rvbs.rvbs00 = 'axmt629'   #FUN-B40066 mark
            #FUN-B40066 --START--
            IF s_industry('icd') THEN 
               LET l_rvbs.rvbs00 = 'axmt629_icd'
            ELSE
               LET l_rvbs.rvbs00 = 'axmt629' 
            END IF
            #FUN-B40066 --END--   
            LET l_rvbs.rvbs01 = l_oga.oga01

            #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
            LET l_rvbs06a = 0

            SELECT SUM(rvbs06) INTO l_rvbs06a
              FROM rvbs_file
             WHERE rvbs01= l_oga.oga011
               AND rvbs02= l_ogb.ogb03
              #CHI-BB0057 mark start -----
              #AND rvbs13 = l_rvbs.rvbs13  
              #AND rvbs09 = -1    #TQC-B90236 modify 
              #CHI-BB0057 mark end   -----
               #-----MOD-A10163---------
               #AND rvbs022 = l_rvbs.rvbs022   
               AND rvbs03=l_rvbs.rvbs03
               AND rvbs04=l_rvbs.rvbs04
               #-----END MOD-A10163-----
            #CHI-BB0057 add start  -----
               AND rvbs05 = l_rvbs.rvbs05
               AND rvbs08 = l_rvbs.rvbs08
            GROUP BY rvbs03,rvbs04,rvbs05,rvbs08
            #CHI-BB0057 add end   -----
            
            IF cl_null(l_rvbs06a) THEN
               LET l_rvbs06a = 0
            END IF

            #已簽收數量
            LET l_rvbs06b = 0
            LET l_rvbs.rvbs13 = 0   #MOD-A10163 
            LET l_rvbs.rvbs022 = i  #MOD-A10163

            SELECT SUM(rvbs06) INTO l_rvbs06b
              FROM ogb_file,oga_file,rvbs_file
             WHERE ogb01 = oga01 AND oga09 IN ('8') 
               AND oga011 = l_oga.oga011
               AND ogb03 = l_ogb.ogb03
               AND oga01 = rvbs01
               AND ogb03 = rvbs02
              #CHI-BB0057 mark start -----
              #AND rvbs13 = l_rvbs.rvbs13  
              #AND rvbs09 = -1
              #CHI-BB0057 mark end   -----
               AND ogaconf != 'X' 
               #-----MOD-A10163---------
               #AND rvbs022 = l_rvbs.rvbs022   
               AND rvbs03=l_rvbs.rvbs03
               AND rvbs04=l_rvbs.rvbs04
               #-----END MOD-A10163-----
            #CHI-BB0057 add start  -----
               AND rvbs05 = l_rvbs.rvbs05
               AND rvbs08 = l_rvbs.rvbs08
            GROUP BY rvbs03,rvbs04,rvbs05,rvbs08
            #CHI-BB0057 add end   -----

            IF cl_null(l_rvbs06b) THEN
               LET l_rvbs06b = 0
            END IF

            LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b

            #CHI-BB0057 add start -----
            IF l_rvbs.rvbs06 <= 0 THEN
               CONTINUE FOREACH
            END IF
            #CHI-BB0057 add end   -----

            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
               LET g_success='N'
            END IF
            LET i = i + 1 #MOD-A10163
         END FOREACH
      END IF
      #CHI-AC0034 add --start--
      #No.MOD-C70145  --beg
      #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨 #No.MOD-C70145 mark
      IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
      #No.MOD-C70145  --End      
         DECLARE t600sub_ins_ogc_c CURSOR FOR
         #SELECT * FROM ogc_file             #MOD-C70078 mark
          SELECT ogc17,ogc092 FROM ogc_file  #MOD-C70078
           WHERE ogc01= p_oga01
             AND ogc03= l_ogb.ogb03
           GROUP BY ogc17,ogc092             #MOD-C70078
        #FOREACH t600sub_ins_ogc_c INTO l_ogc.*                   #MOD-C70078 mark
         FOREACH t600sub_ins_ogc_c INTO l_ogc.ogc17,l_ogc.ogc092  #MOD-C70078
            IF STATUS THEN
               CALL s_errmsg('','',"t600sub_ins_ogc_c foreach:",SQLCA.sqlcode,1) 
               LET g_success = 'N'   
               EXIT FOREACH
            END IF
            IF g_success = "N" THEN
               LET g_totsuccess = "N"
               LET g_success = "Y"
            END IF

           #MOD-C70078---S---
            SELECT * INTO l_ogc.* FROM ogc_file
             WHERE ogc01= p_oga01
               AND ogc03= l_ogb.ogb03
               AND ogc17= l_ogc.ogc17
               AND ogc092= l_ogc.ogc092

             #No.MOD-C70145  --Begin  出货替代时，可能会有逻辑被改变的问题
             #SELECT SUM(ogc12) INTO l_ogc.ogc12 FROM ogc_file 
             # WHERE ogc01= p_oga01
             #   AND ogc03= l_ogb.ogb03
             # GROUP BY ogc17,ogc092 
             #No.MOD-C70145  --End
           #MOD-C70078---E---

            SELECT SUM(ogc12) INTO l_ogc12
              FROM ogc_file
             WHERE ogc01 = l_oga.oga011
               AND ogc03 = l_ogb.ogb03
               AND ogc17 = l_ogc.ogc17
               AND ogc092= l_ogc.ogc092   #No.MOD-C70145
            IF l_ogc.ogc12 < l_ogc12 THEN
               LET l_ogc.ogc12 = l_ogc12 - l_ogc.ogc12
               LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
               LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)   #FUN-910088--add--
            ELSE
               CONTINUE FOREACH
            END IF

            LET l_ogc.ogc01 = l_oga.oga01
            LET l_ogc.ogc09 = tm.cware
            LET l_ogc.ogc091= tm.cloc

            INSERT INTO ogc_file VALUES(l_ogc.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('','',"ins ogc",SQLCA.sqlcode,1)  
               LET g_success='N'
               CONTINUE FOREACH
            END IF

            LET g_ima918 = ''   
            LET g_ima921 = ''  
            SELECT ima918,ima921 INTO g_ima918,g_ima921 
              FROM ima_file
             WHERE ima01 = l_ogc.ogc17
               AND imaacti = "Y"

            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
               #DECLARE t600sub_g_rvbs_2 CURSOR FOR SELECT * FROM rvbs_file #CHI-BB0057 mark 
               #CHI-BB0057 add start -----
               DECLARE t600sub_g_rvbs_2 CURSOR FOR SELECT rvbs03,rvbs04,rvbs05,rvbs08,rvbs021
                                                   FROM rvbs_file
               #CHI-BB0057 add end   -----
                                              WHERE rvbs01 = l_oga.oga011                    
                                                AND rvbs02 = l_ogb.ogb03
                                           #CHI-BB0057 add start -----
                                                AND rvbs13 in (SELECT ogc18 FROM ogc_file
                                                                WHERE ogc01= l_oga.oga011
                                                                  AND ogc03= l_ogb.ogb03
                                                                  AND ogc17= l_ogc.ogc17
                                                                  AND ogc092= l_ogc.ogc092)
                                           GROUP BY rvbs03,rvbs04,rvbs05,rvbs08,rvbs021
                                           #CHI-BB0057 add start -----
                                               #AND rvbs13 = l_ogc.ogc18 #CHI-BB0057 mark
               LET i = 1
              #FOREACH t600sub_g_rvbs_2 INTO l_rvbs.* #CHI-BB0057 mark
               FOREACH t600sub_g_rvbs_2 INTO l_rvbs.rvbs03,l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs08,l_rvbs.rvbs021 #CHI-BB0057 add
                  IF STATUS THEN
                     CALL cl_err('rvbs',STATUS,1)
                     LET g_success='N'
                  END IF

                  LET l_cnt = 0 
                  SELECT COUNT(*) FROM rvbs_file
                   WHERE rvbs00[1,7] = 'axmt629'   #FUN-B40066 add [1,7]             
                     AND rvbs01 = l_oga.oga01
                     AND rvbs02 = l_ogb.ogb03
                     AND rvbs09 = '-1'
                     AND rvbs13 = 0 
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                  IF l_cnt > 0 THEN
                     CONTINUE FOREACH
                  END IF

                #CHI-BB0057 add start -----
                  SELECT * INTO l_rvbs.*
                    FROM rvbs_file
                   WHERE rvbs01 = l_oga.oga011
                     AND rvbs02 = l_ogb.ogb03
                     AND rvbs03 = l_rvbs.rvbs03
                     AND rvbs04 = l_rvbs.rvbs04
                     AND rvbs05 = l_rvbs.rvbs05
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs021= l_rvbs.rvbs021

                  LET l_rvbs.rvbs13 = l_ogc.ogc18
                #CHI-BB0057 add start -----

                  #LET l_rvbs.rvbs00 = 'axmt629' #FUN-B40066 mark
                  #FUN-B40066 --START--
                  IF s_industry('icd') THEN
                     LET l_rvbs.rvbs00 = 'axmt629_icd'
                  ELSE    
                     LET l_rvbs.rvbs00 = 'axmt629' 
                  END IF   
                  #FUN-B40066 --END--
                  LET l_rvbs.rvbs01 = l_oga.oga01

                  #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
                  LET l_rvbs06a = 0

                  SELECT SUM(rvbs06) INTO l_rvbs06a
                    FROM rvbs_file
                   WHERE rvbs01= l_oga.oga011
                     AND rvbs02= l_ogb.ogb03
                    #CHI-BB0057 mark start -----
                    #AND rvbs13 = l_rvbs.rvbs13   
                    #AND rvbs09 = -1   #TQC-B90236 modify 
                    #CHI-BB0057 mark end   -----
                     AND rvbs03=l_rvbs.rvbs03
                     AND rvbs04=l_rvbs.rvbs04
                     #CHI-BB0057 add start -----
                     AND rvbs05 = l_rvbs.rvbs05
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs021= l_rvbs.rvbs021
                     #CHI-BB0057 add end   -----
                  
                  IF cl_null(l_rvbs06a) THEN
                     LET l_rvbs06a = 0
                  END IF

                  #已簽收數量
                  LET l_rvbs06b = 0
                  LET l_rvbs.rvbs022 = i 

                  SELECT SUM(rvbs06) INTO l_rvbs06b
                    FROM ogb_file,oga_file,rvbs_file
                   WHERE ogb01 = oga01 AND oga09 IN ('8') 
                     AND oga011 = l_oga.oga011
                     AND ogb03 = l_ogb.ogb03
                     AND oga01 = rvbs01
                     AND ogb03 = rvbs02
                    #CHI-BB0057 mark start -----
                    #AND rvbs13 = l_rvbs.rvbs13  
                    #AND rvbs09 = -1
                    #CHI-BB0057 mark end   -----
                     AND ogaconf != 'X' 
                     AND rvbs03=l_rvbs.rvbs03
                     AND rvbs04=l_rvbs.rvbs04
                     #CHI-BB0057 add start -----
                     AND rvbs05 = l_rvbs.rvbs05
                     AND rvbs08 = l_rvbs.rvbs08
                     AND rvbs021= l_rvbs.rvbs021
                     #CHI-BB0057 add end   -----

                  IF cl_null(l_rvbs06b) THEN
                     LET l_rvbs06b = 0
                  END IF

                  LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b

                  #CHI-BB0057 add start -----
                  IF l_rvbs.rvbs06 <= 0 THEN
                     CONTINUE FOREACH
                  END IF
                  #CHI-BB0057 add end   -----

                  INSERT INTO rvbs_file VALUES(l_rvbs.*)
                  IF STATUS OR SQLCA.SQLCODE THEN
                     CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                     LET g_success='N'
                  END IF
                  LET i = i + 1 
               END FOREACH
            END IF
         END FOREACH
      END IF
      #CHI-AC0034 add --end--
   END FOREACH

   #MOD-C50014 add start -----
   SELECT azi03,azi04 INTO t_azi03,t_azi04
     FROM azi_file
    WHERE azi01 = l_oga.oga23

   SELECT SUM(ogb14),SUM(ogb14t) into l_oga.oga50,l_oga.oga1008
     FROM ogb_file
    WHERE ogb01 = l_oga.oga01 AND ogb1005 = '1'

   SELECT SUM(ogb14),SUM(ogb14t) into l_oga.oga1006,l_oga.oga1007
     FROM ogb_file
    WHERE ogb01 = l_oga.oga01 AND ogb1005 = '2'

   IF cl_null(l_oga.oga50) THEN
      LET l_oga.oga50 = 0
   ELSE
      CALL cl_numfor(l_oga.oga50,8,t_azi04) RETURNING l_oga.oga50
   END IF

   IF cl_null(l_oga.oga1006) THEN
      LET l_oga.oga1006 = 0
   ELSE
      CALL cl_numfor(l_oga.oga1006,8,t_azi04) RETURNING l_oga.oga1006
   END IF

   IF cl_null(l_oga.oga1008) THEN
      LET l_oga.oga1008 = 0
   ELSE
      CALL cl_numfor(l_oga.oga1008,8,t_azi04) RETURNING l_oga.oga1008
   END IF

   IF cl_null(l_oga.oga1007) THEN
      LET l_oga.oga1007 = 0
   ELSE
      CALL cl_numfor(l_oga.oga1007,8,t_azi04) RETURNING l_oga.oga1007
   END IF

    UPDATE oga_file SET oga50=l_oga.oga50,oga1008=l_oga.oga1008
                       ,oga1006=l_oga.oga1006,oga1007=l_oga.oga1007
                  WHERE oga01 = l_oga.oga01
   #MOD-C50014 add end   -----

     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
   #要處理過帳
   DECLARE t600_post_cur1 CURSOR FOR
    SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
 
   FOREACH t600_post_cur1 INTO l_ogb.*
      IF STATUS THEN
         CALL s_errmsg('','',"t600_post_cur1 foreach:",SQLCA.sqlcode,0)  #No.FUN-710046
         EXIT FOREACH
      END IF
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF
      LET l_ogb.ogb01 = l_oga.oga01
 
     #CHI-AC0034 mark --start--
     #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,     #No.TQC-6B0174
     #                  l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_oga.*,l_ogb.*)
     #IF g_success = 'N' THEN
     #   RETURN
     #END IF
     #CHI-AC0034 mark --end--
      #CHI-AC0034 add --start--
      LET l_flag='' 
      #No.MOD-C70145  --beg
      #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨 #No.MOD-C70145  --mark
      IF l_ogb.ogb17='Y' THEN
      #No.MOD-C70145  --End       
        #DECLARE t600_s1_ogc_c4 CURSOR FOR  SELECT * FROM ogc_file
        #   WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
         DECLARE t600_s1_ogc_c4 CURSOR FOR  
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--         
          SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file  #MOD-C10103 add ogc092
#           SELECT * FROM ogc_file     
            WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03  #MOD-BC0089 remark
          GROUP BY ogc17,ogc092                                             #MOD-C10103 add ogc092
         FOREACH t600_s1_ogc_c4 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092   #MOD-C10103 add ogc092 
#          FOREACH t600_s1_ogc_c4 INTO l_ogc.*   
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改

            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
               LET g_success='N' RETURN 
            END IF
            LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
            CALL cl_msg(l_msg)
            LET l_flag='X'    
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--               
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01= l_ogb.ogb04  AND img02= l_oga.oga66
            #No.MOD-C70145  --Begin
            #  AND img03= l_oga.oga67 AND img04= l_ogb.ogb092             
               AND img03= l_oga.oga67 AND img04= l_ogc.ogc092             
            #No.MOD-C70145  --End            
           CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
            LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
            LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
           #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,    #MOD-C10103 mark  
            CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc.ogc092,    #MOD-C10103 remark 
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
                          l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
            IF g_success='N' THEN  
               LET g_totsuccess="N"
               LET g_success="Y"
               #RETURN    #MOD-BB0058 mark
            END IF
            #FUN-B40066 --START--
            IF s_industry('icd') THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idb_file
                WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               IF l_cnt > 0 THEN
                  DECLARE t600sub_idb_c3 CURSOR FOR
                   SELECT * FROM idb_file
                    WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  FOREACH t600sub_idb_c3 INTO l_idb.* 
                     #出貨簽收單產生ida資料
                     IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN  #TQC-BA0136  l_ogc.ogc092->l_idb.idb04
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
                    l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                    l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                    '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'                     
                  RETURN
               END IF
            END IF    
            #FUN-B40066 --END--
         END FOREACH
      ELSE
         IF l_ogb.ogb17='Y' THEN 
            LET l_flag = 'Y'
#CHI-B60054  --Begin #mark CHI-B30093和TQC-B50099更改
            #No.TQC-B50099  --Begin #此處tlf需更新驗退倉庫
#CHI-B30093 --begin--
#            DECLARE t600_s1_ogc_c5 CURSOR FOR  
#             SELECT * FROM ogc_file      
#              WHERE ogc01=p_oga01 AND ogc03=l_ogb.ogb03
#            FOREACH t600_s1_ogc_c5 INTO l_ogc_1.*                                              
#                CALL t600sub_consign(l_ogc_1.ogc09,l_ogc.ogc091,l_ogc_1.ogc092,l_ogc_1.ogc12,
#                                     l_ogb.ogb05,l_ogc_1.ogc15_fac,l_ogc_1.ogc16,l_flag,
#                                     l_ogb.ogb04,l_oga.*,l_ogb.*)         
#            END FOREACH              
#CHI-B30093 --end--  
#CHI-B60054  --End #去掉CHI-B30093更改

#            DECLARE t600_s1_ogc_c6 CURSOR FOR  
#             SELECT * FROM ogc_file      
#              WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03
#            FOREACH t600_s1_ogc_c6 INTO l_ogc_1.*                                              
#                CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,l_ogc_1.ogc12, 
#                                     l_ogb.ogb05,l_ogc_1.ogc15_fac,l_ogc_1.ogc16,l_flag,
#                                     l_ogb.ogb04,l_oga.*,l_ogb.*)         
#            END FOREACH  
            #No.TQC-B50099  --End        
#CHI-B60054  --End #mark CHI-B30093和TQC-B50099更改
         ELSE 
            LET l_flag='' 
         END IF           #CHI-B30093 #CHI-B60054 去掉mark CHI-B30093 
             CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,   
                       l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)  
         #END IF           #CHI-B30093 #CHI-B60054 mark CHI-B30093 
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
            #RETURN   #MOD-BB0058 mark
         END IF
         #FUN-B40066 --START--
         IF s_industry('icd') THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM idb_file
             WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
            IF l_cnt > 0 THEN
               DECLARE t600sub_idb_c4 CURSOR FOR
                SELECT * FROM idb_file
                 WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               FOREACH t600sub_idb_c4 INTO l_idb.* 
                  #出貨簽收單產生ida資料
                  IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN   #TQC-BA0136  l_ogc.ogc092 ->l_idb.idb04
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
                 l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                 l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                 '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                 RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N'                     
               RETURN
            END IF
         END IF    
         #FUN-B40066 --END--
      END IF
      #CHI-AC0034 add --end--
 
      IF g_sma.sma115 = 'Y' THEN
#FUN-C50097 ADD BEGIN
#此处要生成签退单ogg_file
         IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
            DECLARE t600sub_ins_ogg_c3 CURSOR FOR
             SELECT * FROM ogg_file
              WHERE ogg01= p_oga01
                AND ogg03= l_ogb.ogb03
            FOREACH t600sub_ins_ogg_c3 INTO l_ogg.*
               IF STATUS THEN
                  CALL s_errmsg('','',"t600sub_ins_ogg_c3 foreach:",SQLCA.sqlcode,1) 
                  LET g_success = 'N'   
                  EXIT FOREACH
               END IF
               IF g_success = "N" THEN
                  LET g_totsuccess = "N"
                  LET g_success = "Y"
               END IF

               IF l_ogg.ogg13 > 0 THEN 
                  LET l_ogg.ogg12 = l_ogg.ogg13 
                  LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
                  LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15)   #FUN-910088--add--
               ELSE
                  CONTINUE FOREACH
               END IF
   
               LET l_ogg.ogg01 = l_oga.oga01
               LET l_ogg.ogg09 = tm.cware
               LET l_ogg.ogg091= tm.cloc
   
               INSERT INTO ogg_file VALUES(l_ogg.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('','',"ins ogg",SQLCA.sqlcode,1)  
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
            END FOREACH   
         END IF       
#FUN-C50097 ADD END      
         CALL t600sub_consign_mu(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,l_oga.*,l_ogb.*)     #No.TQC-6B0174
         IF g_success = 'N' THEN
            RETURN
         END IF
      END IF
   END FOREACH
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
     IF g_success = 'Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
END FUNCTION




#FUN-C50097 ADD BEGIN----------------
#大陆版多次签收copy自t600_gen_return_note 
FUNCTION t600_gen_return_note2(l_oga)   #MOD-790150 modify l_oga
DEFINE l_oga     RECORD LIKE oga_file.*,
       l_ogb     RECORD LIKE ogb_file.*,
       l_ogbi    RECORD LIKE ogbi_file.*,#No.FUN-7C0017
       l_ogb12   LIKE ogb_file.ogb12,
       l_ogb915  LIKE ogb_file.ogb12,
       l_ogb912  LIKE ogb_file.ogb12,
       l_ogb917  LIKE ogb_file.ogb12,
       li_result LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_cnt     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       tm        RECORD
                 oga01 LIKE oay_file.oayslip,  #No.FUN-680137 VARCHAR(5)
                 cware LIKE img_file.img02,
                 cloc  LIKE img_file.img03
                 END RECORD
DEFINE p_row,p_col LIKE type_file.num5
DEFINE l_t1      LIKE type_file.chr5
DEFINE p_oga01   LIKE oga_file.oga01    #MOD-790150
DEFINE l_rvbs     RECORD LIKE rvbs_file.*   #CHI-970040
DEFINE l_rvbs06a  LIKE rvbs_file.rvbs06     #CHI-970040
DEFINE l_rvbs06b  LIKE rvbs_file.rvbs06     #CHI-970040
DEFINE i          LIKE type_file.num5   #MOD-A10163
DEFINE l_msg      STRING                 #CHI-AC0034 add 
DEFINE l_tot1     LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE l_flag     LIKE type_file.chr1    #CHI-AC0034 add
DEFINE l_ogc      RECORD LIKE ogc_file.* #CHI-AC0034 add
DEFINE l_ogc12    LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE l_img09    LIKE img_file.img09    #CHI-AC0034 add
DEFINE l_idb      RECORD LIKE idb_file.*  #FUN-B40066
DEFINE l_factor   LIKE type_file.num26_10  #FUN-C50097
DEFINE l_ogb50    LIKE ogb_file.ogb50,     #FUN-C50097
       l_ogb51    LIKE ogb_file.ogb51,      #FUN-C50097
       l_ima906   LIKE ima_file.ima906,
       g_prog_t   LIKE type_file.chr20,
       l_r        LIKE type_file.chr1,
       l_qty      LIKE ogb_file.ogb12,
       l_ogb09    LIKE ogb_file.ogb09, #120712
       l_ogb091   LIKE ogb_file.ogb091, #120712 
       l_ogg      RECORD LIKE ogg_file.*  #120725     
   #檢查是否有驗退數量
   SELECT COUNT(*) INTO l_cnt
     FROM ogb_file b1,oga_file a1
    WHERE b1.ogb01 = l_oga.oga01
      AND a1.oga01 = b1.ogb01
      AND b1.ogb12 < (SELECT SUM(b2.ogb12) FROM oga_file a2,ogb_file b2
                       WHERE a2.oga01 = b2.ogb01
                        #AND a2.oga09 = '2'
                         AND (a2.oga09 = '2' OR a2.oga09 = '3') #FUN-BB0167
                         AND a2.oga65 = 'Y'
                         AND a1.oga011 = a2.oga01
                         AND b1.ogb03 = b2.ogb03)
 
   IF l_cnt = 0 THEN RETURN END IF
 
   LET tm.oga01= NULL
   LET tm.cware=g_oaz.oaz76
   LET tm.cloc =g_oaz.oaz77
 
   LET p_row = 2 LET p_col = 39
 
   OPEN WINDOW t6281_w AT p_row,p_col WITH FORM "axm/42f/axmt6281"   #CHI-690060
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmt6281")   #CHI-690060
 
   INPUT BY NAME tm.oga01,tm.cware,tm.cloc WITHOUT DEFAULTS
 
      AFTER FIELD oga01
         IF NOT cl_null(tm.oga01) THEN
            CALL s_check_no("axm",tm.oga01,"","59","oga_file","oga01","")
                 RETURNING li_result,tm.oga01
            IF (NOT li_result) THEN
               NEXT FIELD oga01
            END IF
         END IF
 
      AFTER FIELD cware
         IF NOT cl_null(tm.cware) THEN
            SELECT * FROM imd_file
             WHERE imd01 = tm.cware
               AND imdacti = 'Y'
            IF STATUS <> 0 THEN
               CALL cl_err3("sel","imd_file",tm.cware,"","ams-004","","",1)  #No.FUN-670008
               NEXT FIELD cware
            END IF
 
            SELECT COUNT(*) INTO l_cnt FROM ogb_file
             WHERE ogb01 = l_oga.oga01
               AND ogb09 = tm.cware
            IF l_cnt > 0 THEN
               CALL cl_err('','axm-424',0)
               LET tm.cware=' '
               NEXT FIELD cware #No:8570
            END IF
            IF g_azw.azw04='2' THEN                                                                                                 
               LET l_cnt=0                                                                                                          
               SELECT COUNT(*) INTO l_cnt  FROM jce_file                                                                     
                WHERE jce02=tm.cware                                                                                                
               IF l_cnt !=0 THEN                                                                                             
                  CALL cl_err(tm.cware,'art-452',0)                                                                                 
                  NEXT FIELD cware                                                                                                  
               END IF                                                                                                                
            END IF
            #No.FUN-AA0048  --Begin
            IF NOT s_chk_ware(tm.cware) THEN
               NEXT FIELD cware
            END IF
            #No.FUN-AA0048  --End  
         END IF
#FUN-D40103 -----Begin------
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc
         END IF
 #FUN-D40103 -----End--------
 
      AFTER FIELD cloc
         IF cl_null(tm.cloc) THEN   #FUN-630102 modify
            LET tm.cloc = ' '
         END IF
 #FUN-D40103 -----Begin-----
       ##-----MOD-B40260---------
       ##start FUN-630102 mark
       #SELECT * FROM ime_file
       # WHERE ime01 = tm.cware
       #   AND ime02 = tm.cloc
       ##   AND ime04 = 'S'
       #IF STATUS <> 0 THEN
       #   CALL cl_err('','mfg0095',0)
       #   NEXT FIELD cloc
       #END IF
       ##end FUN-630102 mark
       ##-----END MOD-B40260-----
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            NEXT FIELD cloc
         END IF
 #FUN-D40103 -----End------- 
 
         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01  = l_oga.oga01
            AND ogb09 = tm.cware
            AND ogb091 = tm.cloc
         IF l_cnt > 0 THEN
            CALL cl_err('','axm-424',0)
            LET tm.cloc=' '
            NEXT FIELD cware
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

 #FUN-D40103 -------Begin------
      # #start FUN-630102 mark
      # SELECT * FROM ime_file
      #  WHERE ime01 = tm.cware
      #    AND ime02 = tm.cloc
      # #   AND ime04 = 'S'
      # IF STATUS <> 0 THEN
      #    CALL cl_err('','mfg0095',0)
      #    LET tm.cloc=' '
      #    NEXT FIELD cloc
      # END IF
      # #end FUN-630102 mark
      # #-----END MOD-B40260-----
         IF NOT s_imechk(tm.cware,tm.cloc) THEN
            LET tm.cloc=' '
            NEXT FIELD cloc
         END IF
  #FUN-D40103 -------End--------

         SELECT COUNT(*) INTO l_cnt FROM ogb_file
          WHERE ogb01 = l_oga.oga01 AND ogb09 = tm.cware
         IF l_cnt > 0 THEN
            CALL cl_err('','axm-424',0)
            LET tm.cloc=' '
            NEXT FIELD tm.cware
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oga01)
                LET l_t1=s_get_doc_no(tm.oga01)       #No.FUN-550052
              # CALL q_oay(FALSE,TRUE,l_t1,'59',g_sys) RETURNING l_t1       #FUN-A70130 mark
                CALL q_oay(FALSE,TRUE,l_t1,'59','axm') RETURNING l_t1       #FUN-A70130
                LET tm.oga01 = l_t1            #No.FUN-550052
                DISPLAY BY NAME tm.oga01
                NEXT FIELD oga01
            WHEN INFIELD(cware)
                 CALL q_imd_1(FALSE,TRUE,tm.cware,'S',"","","") RETURNING tm.cware 
                 DISPLAY BY NAME tm.cware
            WHEN INFIELD(cloc)
                 CALL q_ime_1(FALSE,TRUE,tm.cloc,tm.cware,"S","","","","") RETURNING tm.cloc 
                 DISPLAY BY NAME tm.cloc
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      LET g_success = 'N'
      CLOSE WINDOW t6281_w
      RETURN
   END IF
 
   CLOSE WINDOW t6281_w
 
   LET p_oga01 = l_oga.oga01  #MOD-790150 #foreach單身key值用
 
   CALL s_auto_assign_no("axm",tm.oga01,g_today,"","oga_file","oga01","","","")
     RETURNING li_result,l_oga.oga01
 
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   IF cl_null(l_oga.oga01) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   #BEGIN WORK
 
   LET l_oga.oga02  = l_oga.oga02 #MOD-B70130
   LET l_oga.oga011 = l_oga.oga011 
   LET l_oga.oga66  = tm.cware
   LET l_oga.oga67  = tm.cloc
   LET l_oga.oga09  = '9'
   LET l_oga.ogaconf= 'Y'
   LET l_oga.ogapost= 'Y'
   LET l_oga.ogaprsw= 0
   LET l_oga.oga55  = '0'
   LET l_oga.oga57  = '1'           #FUN-AC0055 add
   LET l_oga.oga56  = p_oga01
   LET l_oga.oga65  = 'N'
 
   SELECT oayapr INTO l_oga.ogamksg FROM oay_file
    WHERE oayslip = tm.oga01
   LET l_oga.oga85=' ' #No.FUN-870007
   LET l_oga.oga94='N' #No.FUN-870007
 
   LET l_oga.ogaplant = g_plant 
   LET l_oga.ogalegal = g_legal 
 
   LET l_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO oga_file VALUES (l_oga.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('ins oga',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF

      DECLARE t600_ins_ogb_c3 CURSOR FOR
       SELECT * FROM ogb_file
        WHERE ogb01= p_oga01              #MOD-790150 modify l_oga.oga01
      CALL s_showmsg_init()               #No.FUN-710046
      FOREACH t600_ins_ogb_c3 INTO l_ogb.*
         IF STATUS THEN
            CALL s_errmsg('','',"t600_ins_ogb_c1 foreach:",SQLCA.sqlcode,1)   #No.FUN-710046
            LET g_success = 'N'                   #No.FUN-8A0086
            EXIT FOREACH
         END IF
        IF g_success = "N" THEN
           LET g_totsuccess = "N"
           LET g_success = "Y"
        END IF
        IF l_ogb.ogb52 > 0 THEN #签退数量大于0
            #更新累计签收数量和累计签退数量
            SELECT ogb50,ogb51 INTO l_ogb50,l_ogb51 FROM ogb_file
             WHERE ogb01 =  l_oga.oga011
               AND ogb03 = l_ogb.ogb03
            IF cl_null(l_ogb50) THEN 
               LET l_ogb50 = 0
            END IF 
            IF cl_null(l_ogb51) THEN 
               LET l_ogb51 = 0
            END IF           
            LET l_ogb50 = l_ogb50 + l_ogb.ogb12
            LET l_ogb51 = l_ogb51 + l_ogb.ogb52
            IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
               LET l_ogb50 = 0
            END IF 
            IF cl_null(l_ogb51) OR l_ogb51 < 0 THEN 
               LET l_ogb51 = 0
            END IF
            UPDATE ogb_file SET ogb50 = l_ogb50,
                                ogb51 = l_ogb51
                         WHERE  ogb01 = l_oga.oga011
                           AND  ogb03 = l_ogb.ogb03 
            LET l_ogb.ogb12 = l_ogb.ogb52 
            IF NOT cl_null(l_ogb.ogb916) THEN
               CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_ogb.ogb916)
                    RETURNING l_cnt,l_factor
               IF l_cnt = 1 THEN
                  LET l_factor = 1               	  
               END IF 
               LET l_ogb.ogb917 = l_ogb.ogb12 * l_factor
            END IF            
          #对母子双单位的签退数量生成
            IF g_sma.sma115 = 'Y' THEN 
               LET l_ogb.ogb912 = l_ogb.ogb53
               LET l_ogb.ogb915 = l_ogb.ogb54
               LET l_ogb.ogb917 = l_ogb.ogb55
            END IF       
            #清空ogb50,51,52這些值在簽退單中沒有意義
            LET l_ogb.ogb50 = 0
            LET l_ogb.ogb51 = 0
            LET l_ogb.ogb52 = 0
            LET l_ogb.ogb53 = 0
            LET l_ogb.ogb54 = 0
            LET l_ogb.ogb55 = 0                          	                            
         ELSE
            #只更新出货单签收数量
            SELECT ogb50 INTO l_ogb50 FROM ogb_file
             WHERE ogb01 =  l_oga.oga011
               AND ogb03 = l_ogb.ogb03
            IF cl_null(l_ogb50) THEN 
               LET l_ogb50 = 0
            END IF
            LET l_ogb50 = l_ogb50 + l_ogb.ogb12
            IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
               LET l_ogb50 = 0
            END IF             
            UPDATE ogb_file SET ogb50 = l_ogb50
                         WHERE  ogb01 = l_oga.oga011
                           AND  ogb03 = l_ogb.ogb03                         
            CONTINUE FOREACH
         END IF
    
         LET l_ogb.ogb01 = l_oga.oga01
         LET l_ogb.ogb09 = tm.cware
         LET l_ogb.ogb091= tm.cloc
    
    
         CALL t600_else(l_ogb.*) RETURNING l_ogb.*
         LET l_ogb.ogb44=' ' #No.FUN-870007
         LET l_ogb.ogb47=0   #No.FUN-870007
   #FUN-AB0061 -----------add start----------------                          
         IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
            LET l_ogb.ogb37=l_ogb.ogb13                         
         END IF                                                                             
   #FUN-AB0061 -----------add end----------------   
         LET l_ogb.ogbplant = g_plant 
         LET l_ogb.ogblegal = g_legal 
   
    
         INSERT INTO ogb_file VALUES(l_ogb.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('','',"INS ogb",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            CONTINUE FOREACH  #No.FUN-710046
         ELSE
            IF NOT s_industry('std') THEN
               INITIALIZE l_ogbi.* TO NULL
               LET l_ogbi.ogbi01 = l_ogb.ogb01
               LET l_ogbi.ogbi03 = l_ogb.ogb03
               IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
                  LET g_success = 'N'
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         IF l_ogb.ogb17='N' OR cl_null(l_ogb.ogb17) THEN
            LET g_ima918 = ''   #MOD-9C0055
            LET g_ima921 = ''   #MOD-9C0055
            LET g_ima930 = ''   #DEV-D30059 add
            SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
              FROM ima_file
             WHERE ima01 = l_ogb.ogb04
               AND imaacti = "Y"

            IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

            IF g_ima918 = "Y" OR g_ima921 = "Y" THEN           
                  LET g_prog_t = g_prog
                  IF s_industry('icd') THEN 
                     LET g_prog = 'axmt629_icd'
                  ELSE
                     LET g_prog = 'axmt629' 
                  END IF
                  #test 取签收仓的仓库和储位
                  SELECT DISTINCT ogb09 INTO l_ogb09 FROM ogb_file #120712
                   WHERE ogb01 = l_oga.oga56
                  SELECT DISTINCT ogb091 INTO l_ogb091 FROM ogb_file #120712
                   WHERE ogb01 = l_oga.oga56                 
                  IF g_ima930 = 'N' THEN                                        #DEV-D30059
                     CALL s_mod_lot(g_prog,l_oga.oga01,l_ogb.ogb03,0,      
                                    l_ogb.ogb04,l_ogb09,
                                    l_ogb091,l_ogb.ogb092,
                                    l_ogb.ogb05,l_ogb.ogb15,l_ogb.ogb15_fac,
                                    l_ogb.ogb12,'','MOD',-1)   
                        RETURNING l_r,l_qty 
                  END IF                                                        #DEV-D30059
                  LET  g_prog = g_prog_t
            END IF 
         END IF    
         #CHI-AC0034 add --start--
         #FUN-C50097此处多次签收需要调整多倉儲出貨 120718
         #No.MOD-C70145  --beg
         #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
         IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
         #No.MOD-C70145  --End          
            DECLARE t600sub_ins_ogc_c2 CURSOR FOR
             SELECT * FROM ogc_file
              WHERE ogc01= p_oga01
                AND ogc03= l_ogb.ogb03
            FOREACH t600sub_ins_ogc_c2 INTO l_ogc.*
               IF STATUS THEN
                  CALL s_errmsg('','',"t600sub_ins_ogc_c foreach:",SQLCA.sqlcode,1) 
                  LET g_success = 'N'   
                  EXIT FOREACH
               END IF
               IF g_success = "N" THEN
                  LET g_totsuccess = "N"
                  LET g_success = "Y"
               END IF

               IF l_ogc.ogc13 > 0 THEN 
                  LET l_ogc.ogc12 = l_ogc.ogc13 
                  LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
                  LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)   #FUN-910088--add--
               ELSE
                  CONTINUE FOREACH
               END IF
   
               LET l_ogc.ogc01 = l_oga.oga01
               LET l_ogc.ogc09 = tm.cware
               LET l_ogc.ogc091= tm.cloc
   
               INSERT INTO ogc_file VALUES(l_ogc.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('','',"ins ogc",SQLCA.sqlcode,1)  
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
   
               LET g_ima918 = ''   
               LET g_ima921 = ''  
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = l_ogc.ogc17
                  AND imaacti = "Y"
   
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  DECLARE t600sub_g_rvbs_3 CURSOR FOR SELECT * FROM rvbs_file
                                                 WHERE rvbs01 = l_oga.oga011
                                                   AND rvbs02 = l_ogb.ogb03
                                                   AND rvbs13 = l_ogc.ogc18
                  LET i = 1
                  FOREACH t600sub_g_rvbs_3 INTO l_rvbs.*
                     IF STATUS THEN
                        CALL cl_err('rvbs',STATUS,1)
                        LET g_success='N'
                     END IF
   
                     LET l_cnt = 0 
                     SELECT COUNT(*) FROM rvbs_file
                      WHERE rvbs00[1,7] = 'axmt629'   #FUN-B40066 add [1,7]             
                        AND rvbs01 = l_oga.oga01
                        AND rvbs02 = l_ogb.ogb03
                        AND rvbs09 = '-1'
                        AND rvbs13 = 0 
                        AND rvbs03 = l_rvbs.rvbs03
                        AND rvbs04 = l_rvbs.rvbs04
                     IF l_cnt > 0 THEN
                        CONTINUE FOREACH
                     END IF
                     #LET l_rvbs.rvbs00 = 'axmt629' #FUN-B40066 mark
                     #FUN-B40066 --START--
                     IF s_industry('icd') THEN
                        LET l_rvbs.rvbs00 = 'axmt629_icd'
                     ELSE    
                        LET l_rvbs.rvbs00 = 'axmt629' 
                     END IF   
                     #FUN-B40066 --END--
                     LET l_rvbs.rvbs01 = l_oga.oga01
   
                     #檢查銷退數必須 =出貨單上的數量-簽收單上的數量
                     LET l_rvbs06a = 0
   
                     SELECT SUM(rvbs06) INTO l_rvbs06a
                       FROM rvbs_file
                      WHERE rvbs01= l_oga.oga011
                        AND rvbs02= l_ogb.ogb03
                        AND rvbs13 = l_rvbs.rvbs13   
                        AND rvbs09 = -1   #TQC-B90236 modify 
                        AND rvbs03=l_rvbs.rvbs03
                        AND rvbs04=l_rvbs.rvbs04
                     
                     IF cl_null(l_rvbs06a) THEN
                        LET l_rvbs06a = 0
                     END IF
   
                     #已簽收數量
                     LET l_rvbs06b = 0
                     LET l_rvbs.rvbs022 = i 
   
                     SELECT SUM(rvbs06) INTO l_rvbs06b
                       FROM ogb_file,oga_file,rvbs_file
                      WHERE ogb01 = oga01 AND oga09 IN ('8') 
                        AND oga011 = l_oga.oga011
                        AND ogb03 = l_ogb.ogb03
                        AND oga01 = rvbs01
                        AND ogb03 = rvbs02
                        AND rvbs13 = l_rvbs.rvbs13  
                        AND rvbs09 = -1
                        AND ogaconf != 'X' 
                        AND rvbs03=l_rvbs.rvbs03
                        AND rvbs04=l_rvbs.rvbs04
   
                     IF cl_null(l_rvbs06b) THEN
                        LET l_rvbs06b = 0
                     END IF
   
                     LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b
   
                     INSERT INTO rvbs_file VALUES(l_rvbs.*)
                     IF STATUS OR SQLCA.SQLCODE THEN
                        CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)  
                        LET g_success='N'
                     END IF
                     LET i = i + 1 
                  END FOREACH
               END IF
            END FOREACH
         END IF
         #CHI-AC0034 add --end--
      END FOREACH

     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
   #要處理過帳
   DECLARE t600_post_cur12 CURSOR FOR
    SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
 
   FOREACH t600_post_cur12 INTO l_ogb.*
      IF STATUS THEN
         CALL s_errmsg('','',"t600_post_cur12 foreach:",SQLCA.sqlcode,0)  #No.FUN-710046
         EXIT FOREACH
      END IF
     IF g_success = "N" THEN
        LET g_totsuccess = "N"
        LET g_success = "Y"
     END IF
      LET l_ogb.ogb01 = l_oga.oga01
 
      LET l_flag='' 
      #No.MOD-C70145  --Begin
      #IF l_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨
      IF l_ogb.ogb17='Y' THEN
      #No.MOD-C70145  --End       
         DECLARE t600_s1_ogc_c42 CURSOR FOR          
          SELECT SUM(ogc12),ogc17,ogc092 FROM ogc_file  #MOD-C10103 add ogc092
#           SELECT * FROM ogc_file     
            WHERE ogc01=l_oga.oga01 AND ogc03=l_ogb.ogb03  #MOD-BC0089 remark
          GROUP BY ogc17,ogc092                                             #MOD-C10103 add ogc092
         FOREACH t600_s1_ogc_c42 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092   #MOD-C10103 add ogc092 
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"Foreach s1_ogc:",SQLCA.sqlcode,1)
               LET g_success='N' RETURN 
            END IF
            LET l_msg='_s1() read ogc02:',l_ogb.ogb03,'-',l_ogc.ogc091
            CALL cl_msg(l_msg)
            LET l_flag='X'    
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--               
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01= l_ogb.ogb04  AND img02= l_oga.oga66
            #No.MOD-C70145  --Begin
            #  AND img03= l_oga.oga67 AND img04= l_ogb.ogb092             
               AND img03= l_oga.oga67 AND img04= l_ogc.ogc092             
            #No.MOD-C70145  --End 
            #FUN-C50097 ADD BEG
            IF cl_null(l_img09) THEN 
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_ogb.ogb04  AND img02= g_oaz.oaz74
                  AND img03= l_oga.oga67 AND img04= l_ogc.ogc092                               
            END IF             
            #FUN-C50097 ADD END  
           CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
            LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
            LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15)    #FUN-910088--add--
           #CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,    #MOD-C10103 mark  
            CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogc.ogc092,    #MOD-C10103 remark 
#CHI-B30093 --end--
#CHI-B60054  --End #MARK掉CHI-B30093更改
                          l_ogc.ogc12,l_ogb.ogb05,l_ogc.ogc15_fac,l_ogc.ogc16,l_flag,l_ogc.ogc17,l_oga.*,l_ogb.*)  
            IF g_success='N' THEN  
               LET g_totsuccess="N"
               LET g_success="Y"
               #RETURN    #MOD-BB0058 mark
            END IF
            #FUN-B40066 --START--
            IF s_industry('icd') THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM idb_file
                WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               IF l_cnt > 0 THEN
                  DECLARE t600sub_idb_c6 CURSOR FOR
                   SELECT * FROM idb_file
                    WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
                  FOREACH t600sub_idb_c6 INTO l_idb.* 
                     #出貨簽收單產生ida資料
                     IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN  #TQC-BA0136  l_ogc.ogc092->l_idb.idb04
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
                    l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                    l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                    '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'                     
                  RETURN
               END IF
            END IF    
            #FUN-B40066 --END--
         END FOREACH
      ELSE
         IF l_ogb.ogb17='Y' THEN 
            LET l_flag = 'Y'
         ELSE 
            LET l_flag='' 
         END IF           #CHI-B30093 #CHI-B60054 去掉mark CHI-B30093 
         CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,   
                       l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_flag,l_ogb.ogb04,l_oga.*,l_ogb.*)  
         #END IF           #CHI-B30093 #CHI-B60054 mark CHI-B30093 
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
         END IF
         #FUN-B40066 --START--
         IF s_industry('icd') THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM idb_file
             WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
            IF l_cnt > 0 THEN
               DECLARE t600sub_idb_c42 CURSOR FOR
                SELECT * FROM idb_file
                 WHERE idb07 = l_ogb.ogb01 AND idb08 = l_ogb.ogb03
               FOREACH t600sub_idb_c42 INTO l_idb.* 
                  #出貨簽收單產生ida資料
                  IF NOT s_icdout_insicin(l_idb.*,l_oga.oga66,l_oga.oga67,l_idb.idb04) THEN   #TQC-BA0136  l_ogc.ogc092 ->l_idb.idb04
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
                 l_ogc.ogc092,l_ogb.ogb05,l_ogb.ogb12,
                 l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y',
                 '','',l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'')  #FUN-B80119--傳入p_plant參數''---
                 RETURNING l_flag
            IF l_flag = 0 THEN
               LET g_success = 'N'                     
               RETURN
            END IF
         END IF    
         #FUN-B40066 --END--
      END IF
      #CHI-AC0034 add --end--
 
      IF g_sma.sma115 = 'Y' THEN
#FUN-C50097 ADD BEGIN
#此处要生成签退单ogg_file
         IF l_ogb.ogb17='Y' THEN     ##多倉儲出貨
            DECLARE t600sub_ins_ogg_c2 CURSOR FOR
             SELECT * FROM ogg_file
              WHERE ogg01= p_oga01
                AND ogg03= l_ogb.ogb03
            FOREACH t600sub_ins_ogg_c2 INTO l_ogg.*
               IF STATUS THEN
                  CALL s_errmsg('','',"t600sub_ins_ogg_c2 foreach:",SQLCA.sqlcode,1) 
                  LET g_success = 'N'   
                  EXIT FOREACH
               END IF
               IF g_success = "N" THEN
                  LET g_totsuccess = "N"
                  LET g_success = "Y"
               END IF

               IF l_ogg.ogg13 > 0 THEN 
                  LET l_ogg.ogg12 = l_ogg.ogg13 
                  LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
                  LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15)   #FUN-910088--add--
               ELSE
                  CONTINUE FOREACH
               END IF
   
               LET l_ogg.ogg01 = l_oga.oga01
               LET l_ogg.ogg09 = tm.cware
               LET l_ogg.ogg091= tm.cloc
   
               INSERT INTO ogg_file VALUES(l_ogg.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('','',"ins ogg",SQLCA.sqlcode,1)  
                  LET g_success='N'
                  CONTINUE FOREACH
               END IF
            END FOREACH   
         END IF       
#FUN-C50097 ADD END
         CALL t600sub_consign_mu(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,l_oga.*,l_ogb.*)     #No.TQC-6B0174
         IF g_success = 'N' THEN
            RETURN
         END IF
      END IF
   END FOREACH
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
#     IF g_success = 'Y' THEN
#        COMMIT WORK
#     ELSE
#        ROLLBACK WORK
#     END IF
END FUNCTION




#銷退單過帳
FUNCTION t600sub_update_7(l_oga,l_oha,l_ohb)
   DEFINE l_qty    LIKE img_file.img10,
          l_ima01  LIKE ima_file.ima01,
          l_ima25  LIKE ima_file.ima01,
          p_img record like img_file.*,
          l_img RECORD
                img10   LIKE img_file.img10,
                img16   LIKE img_file.img16,
                img23   LIKE img_file.img23,
                img24   LIKE img_file.img24,
                img09   LIKE img_file.img09,
                img21   LIKE img_file.img21
                END RECORD,
          l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_ima71  LIKE ima_file.ima71
   DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
   DEFINE l_occ31  LIKE occ_file.occ31
   DEFINE l_tuq06  LIKE tuq_file.tuq06
   DEFINE l_tup05  LIKE tup_file.tup05
   DEFINE l_tuq07  LIKE tuq_file.tuq07
   DEFINE l_desc   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)
   DEFINE l_oha RECORD LIKE oha_file.*
   DEFINE l_ohb RECORD LIKE ohb_file.*
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_ima86 LIKE ima_file.ima86    #FUN-730018
   DEFINE l_tup06 LIKE tup_file.tup06    #MOD-B30651 add
#FUN-910088--add--start--
   DEFINE l_tup05_1   LIKE tup_file.tup05,
          l_tuq07_1   LIKE tuq_file.tuq07,
          l_tuq09_1   LIKE tuq_file.tuq09
#FUN-910088--add--end--
   DEFINE l_msg   STRING                 #MOD-C50020
 
   IF l_ohb.ohb15 IS NULL THEN
      INITIALIZE p_img.* TO NULL
      LET p_img.img01=l_ohb.ohb04
      LET p_img.img02=l_ohb.ohb09
      LET p_img.img03=l_ohb.ohb091
      LET p_img.img04=l_ohb.ohb092
      LET p_img.img09=l_ohb.ohb05
      LET p_img.img10=0
      LET l_ohb.ohb15=l_ohb.ohb05
 
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=p_img.img01
        IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
           CALL cl_err('ima25 null',SQLCA.sqlcode,0)
           LET g_success = 'N'
           RETURN
        END IF
 
        CALL s_umfchk(p_img.img01,p_img.img09,l_ima25)
             RETURNING l_cnt,p_img.img21
        IF l_cnt = 1 THEN
           CALL cl_err('','mfg3075',0)
          #MOD-C50020---S---
           CALL cl_getmsg('asf-176',g_lang) RETURNING l_msg
           LET l_msg = l_msg CLIPPED,":",p_img.img01
           CALL cl_err(l_msg,'mfg3075',0)  #MOD-C50020 add l_msg
          #MOD-C50020---E---
           LET g_success = 'N'
           RETURN
        END IF
        SELECT ime05,ime06 into p_img.img23,p_img.img24 FROM ime_file
         WHERE ime01=p_img.img02 and ime02=p_img.img03
          AND imeacti = 'Y'     #FUN-D40103
        IF SQLCA.sqlcode THEN
           SELECT imd11,imd12 into p_img.img23,p_img.img24 FROM  imd_file
            WHERE imd01=p_img.img02
        END IF
        IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
           CALL cl_err('imd23,imd24',SQLCA.sqlcode,0)
           LET g_success = 'N' RETURN
        END IF
 
      LET p_img.imgplant = g_plant 
      LET p_img.imglegal = g_legal 
 
      INSERT INTO img_file VALUES(p_img.*)
      IF STATUS THEN
         CALL cl_err3("ins","img_file","","","axm-186","","l_ohb.ohb15 null:",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
   END IF

   LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21",
                      " FROM img_file ",
                      "  WHERE img01= ?  AND img02= ? AND img03= ? ",
                      " AND img04= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE img_lock7 CURSOR FROM g_forupd_sql

   OPEN img_lock7 USING l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092
   IF STATUS THEN
      CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
   END IF
 
   FETCH img_lock7 INTO l_img.*
   IF STATUS THEN
      CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
   END IF
   IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
   LET l_qty= l_img.img10 + l_ohb.ohb16
   CALL s_upimg(l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,+1,l_ohb.ohb16,g_today,  #FUN-8C0084
          '','','','',l_ohb.ohb01,l_ohb.ohb03,'','','','','','','','','','','','')  #No.FUN-850100
   IF g_success='N' THEN
      CALL cl_err('s_upimg()','9050',0) RETURN
   END IF

   #Update ima_file
   LET g_forupd_sql ="SELECT ima25 FROM ima_file ", #FUN-730018
                     " WHERE ima01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ima_lock7 CURSOR FROM g_forupd_sql

   OPEN ima_lock7 USING l_ohb.ohb04
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF

   FETCH ima_lock7 INTO l_ima25,l_ima86 #FUN-730018
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
   END IF
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   Call s_udima(l_ohb.ohb04,l_img.img23,l_img.img24,l_ohb.ohb16*l_img.img21,
                #g_today,+1)  RETURNING l_cnt   #MOD-920298
                l_oha.oha02,+1)  RETURNING l_cnt   #MOD-920298
   #最近一次發料日期 表發料
   IF l_cnt THEN
      CALL cl_err('Update Faile',SQLCA.SQLCODE,2)
      LET g_success='N' RETURN
   END IF
   IF g_success='Y' THEN
      CALL t600sub_tlf_7(l_ima25,l_qty,l_oha.*,l_ohb.*,l_ima86)
   END IF
   #
   if l_ohb.ohb092=' ' then display '空 ' end if
   if cl_null(l_ohb.ohb092) then display 'null' end if
   #
   IF g_success = 'N' THEN RETURN END IF
  SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=l_oha.oha03    #No.TQC-640123
  IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
  IF l_occ31 = 'N' THEN RETURN END IF
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
   IF l_oga.oga00 ='7' THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tuq_file
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
         AND tuq11 ='2'
         AND tuq12 =l_oha.oha04
         AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
      IF l_cnt=0 THEN
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_ima25 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
             END IF
         END IF
       #FUN-910088--add--start--
         LET l_tuq09_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,  #MOD-7A0084 modify
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)   #FUN-980010 add plant & legal 
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,l_ohb.ohb03,    #No.TQC-640123  #MOD_7A0084 modify
          #      l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_ohb.ohb12*l_fac1*-1,'2','2',l_oha.oha04,    #FUN-910088--mark--
                 l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_tuq09_1,'2','2',l_oha.oha04,             #FUN-910088--add
                 g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
      ELSE
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04     #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='2'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_tuq06 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
            END IF
         END IF
         SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='2'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
         IF l_tuq07-l_ohb.ohb12*l_fac1<0 THEN
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07=l_ohb.ohb12*l_fac1 THEN
            DELETE FROM tuq_file
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04  #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='2'
               AND tuq12 =l_oha.oha04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN
               CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(l_ohb.ohb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
       #FUN-910088--add--start--
          LET l_tuq07_1 = l_ohb.ohb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                              tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start-- 
       #     UPDATE tuq_file SET tuq07=tuq07-l_ohb.ohb12*l_fac1,
       #                         tuq09=tuq09-l_ohb.ohb12*l_fac1*l_fac2,
       #FUN-910088--mark--end--
                                tuq10=l_desc
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04      #No.RTQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='2'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         END IF
      END IF
   ELSE
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tuq_file
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
         AND tuq11 ='1'
         AND tuq12 =l_oha.oha04
         AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
      IF l_cnt=0 THEN
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_ima25 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
             END IF
         END IF
       #FUN-910088--add--start--
         LET l_tuq09_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,  #MOD-7A0084 modify
                              tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,
                              tuqplant,tuqlegal)   #FUN-980010 add plant & legal 
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,l_ohb.ohb03,     #No.TQC-640123  #MOD-7A0084 modify
              #   l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_ohb.ohb12*l_fac1*-1,'2','1',l_oha.oha04,    #FUN-910088--mark--
                  l_ohb.ohb05,l_ohb.ohb12*-1,l_fac1,l_tuq09_1,'2','1',l_oha.oha04,                #FUN-910088--add--
                 g_plant,g_legal) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
      ELSE
         SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04     #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='1'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",1)  #No.FUN-670008
            LET g_success ='N'
            RETURN
         END IF
         LET l_fac1=1
         IF l_ohb.ohb05 <> l_tuq06 THEN
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)
                 RETURNING l_cnt,l_fac1
            IF l_cnt = '1'  THEN
               CALL cl_err(l_ohb.ohb04,'abm-731',1)
               LET l_fac1=1
            END IF
         END IF
         SELECT tuq07 INTO l_tuq07 FROM tuq_file
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04    #No.TQC-640123
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
            AND tuq11 ='1'
            AND tuq12 =l_oha.oha04
            AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
         IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
         IF l_tuq07-l_ohb.ohb12*l_fac1<0 THEN
            LET l_desc='2'
         ELSE
            LET l_desc='1'
         END IF
         IF l_tuq07=l_ohb.ohb12*l_fac1 THEN
            DELETE FROM tuq_file
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04  #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='1'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_fac2=1
            IF l_tuq06 <> l_ima25 THEN
               CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)
                    RETURNING l_cnt,l_fac2
               IF l_cnt = '1'  THEN
                  CALL cl_err(l_ohb.ohb04,'abm-731',1)
                  LET l_fac2=1
               END IF
            END IF
        #FUN-910088--add--start--
            LET l_tuq07_1 = l_ohb.ohb12*l_fac1
            LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
            LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2
            LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
            UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                                tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start--
       #    UPDATE tuq_file SET tuq07=tuq07-l_ohb.ohb12*l_fac1,
       #                        tuq09=tuq09-l_ohb.ohb12*l_fac1*l_fac2,
       #FUN-910088-mark--end--
                                tuq10=l_desc
             WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04      #No.TQC-640123
               AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02
               AND tuq11 ='1'
               AND tuq12 =l_oha.oha04
               AND tuq05=l_oha.oha01  AND tuq051=l_ohb.ohb03 #MOD-CB0111 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",1)  #No.FUN-670008
               LET g_success='N'
               RETURN
            END IF
         END IF
      END IF
   END IF
   LET l_fac1=1
   IF l_ohb.ohb05 <> l_ima25 THEN
      CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)
           RETURNING l_cnt,l_fac1
      IF l_cnt = '1'  THEN
         CALL cl_err(l_ohb.ohb04,'abm-731',1)
         LET l_fac1=1
      END IF
   END IF
   IF l_oga.oga00 ='7' THEN
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tup_file
       WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04    #No.TQC-640123
         AND tup03=l_ohb.ohb092
         AND ((tup08='2' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
              (tup11='2' AND tup12=l_oha.oha04))     #FUN-690083 modify
      IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF  #FUN-790001 add
      IF l_cnt=0 THEN
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12,
                              tupplant,tuplegal)   #FUN-980010 add plant & legal    #MOD-9C0330
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_ima25,   #No.TQC-640123
               #l_ohb.ohb12*l_fac1*-1,l_ima71+l_oha.oha02,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04, #MOD-B30651 mark
               #l_ohb.ohb12*l_fac1*-1,l_tup06,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04,             #MOD-B30651  #FUN-910088--mark--
                l_tup05_1,l_tup06,l_oha.oha02,'2',l_oha.oha04,'2',l_oha.oha04,                         #FUN-910088--add--
                g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      ELSE
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1   
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
       # UPDATE tup_file SET tup05=tup05-l_ohb.ohb12*l_fac1        #FUN-910088--mark--
         UPDATE tup_file SET tup05=tup05-l_tup05_1                 #FUN-910088--add--
          WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04   #No.TQC-640123
            AND tup03=l_ohb.ohb092
            AND ((tup08='2' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
                 (tup11='2' AND tup12=l_oha.oha04))     #FUN-690083 modify
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","update tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      END IF
   ELSE
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
       IF l_oga.oga00='6' THEN RETURN END IF   #No.TQC-7C0154
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM tup_file
       WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04    #No.TQC-640123
         AND tup03=l_ohb.ohb092
         AND ((tup08='1' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
              (tup11='1' AND tup12=l_oha.oha04))     #FUN-690083 modify
      IF cl_null(l_ohb.ohb092) THEN LET l_ohb.ohb092=' ' END IF   #FUN-790001 add
      IF l_cnt=0 THEN
      #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1*-1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
         INSERT INTO tup_file(tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12,
                              tupplant,tuplegal)   #FUN-980010 add plant & legal    #MOD-9C0330
         VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_ima25,   #No.TQC-640123
               #l_ohb.ohb12*l_fac1*-1,l_ima71+l_oha.oha02,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04, #MOD-B30651 mark
              # l_ohb.ohb12*l_fac1*-1,l_tup06,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04,             #MOD-B30651   #FUN-910088--mark--
                l_tup05_1,l_tup06,l_oha.oha02,'1',l_oha.oha04,'1',l_oha.oha04,                         #FUN-910088--add--
                g_plant,g_legal)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      ELSE
       #FUN-910088--add--start--
         LET l_tup05_1 = l_ohb.ohb12*l_fac1
         LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       #FUN-910088--add--end--
      #  UPDATE tup_file SET tup05=tup05-l_ohb.ohb12*l_fac1        #FUN-910088--mark--
         UPDATE tup_file SET tup05=tup05-l_tup05_1                 #FUN-910088--add--
          WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04   #No.TQC-640123
            AND tup03=l_ohb.ohb092
            AND ((tup08='1' AND tup09=l_oha.oha04) OR   #FUN-690083 modify
                 (tup11='1' AND tup12=l_oha.oha04))     #FUN-690083 modify
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","update tup_file",1)  #No.FUN-670008
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION




FUNCTION t620sub1_insinainb(p_type)
 DEFINE p_type     LIKE type_file.chr1
 DEFINE l_ina      RECORD LIKE ina_file.*
 DEFINE l_inb      RECORD LIKE inb_file.*
 DEFINE l_cnt      LIKE type_file.num5
 DEFINE li_result  LIKE type_file.num5
 DEFINE l_img09    LIKE img_file.img09
 DEFINE l_factor   LIKE type_file.num5
 DEFINE l_type     LIKE type_file.num5
 DEFINE l_ima906   LIKE ima_file.ima906
 DEFINE l_ima25    LIKE ima_file.ima25
 DEFINE l_imgg21   LIKE imgg_file.imgg21
 DEFINE l_imd10    LIKE imd_file.imd10
 DEFINE l_inbi     RECORD LIKE inbi_file.* #FUN-B70074 add

   IF p_type = '1' THEN
     #FUN-BB0072 Add&Mark Begin ---
     #SELECT * INTO l_ina.* FROM ina_file
     # WHERE ina10 = g_oga.oga01

      IF g_ogb.ogb14t < 0 THEN
        #出貨金額小於0，檢查是否存在雜收單
         SELECT * INTO l_ina.* FROM ina_file
          WHERE ina10 = g_oga.oga01 AND (ina00 = '3' OR ina00 = '4')
      ELSE
        #出貨金額大於0，檢查是否存在雜發單
         SELECT * INTO l_ina.* FROM ina_file
          WHERE ina10 = g_oga.oga01 AND (ina00 = '1' OR ina00 = '2')
      END IF
     #FUN-BB0072 Add&Mark End -----
   ELSE
     #FUN-BB0072 Add&Mark Begin ---
     #SELECT * INTO l_ina.* FROM ina_file
     # WHERE ina10 = g_oha.oha01

      IF g_ohb.ohb14t < 0 THEN
        #銷退金額小於0，檢查是否存在雜發單
         SELECT * INTO l_ina.* FROM ina_file
          WHERE ina10 = g_oha.oha01 AND (ina00 = '1' OR ina00 = '2')
      ELSE
        #銷退金額大於0，檢查是否存在雜收單
         SELECT * INTO l_ina.* FROM ina_file
          WHERE ina10 = g_oha.oha01 AND (ina00 = '3' OR ina00 = '4')
      END IF
     #FUN-BB0072 Add&Mark End -----
   END IF
   IF cl_null(l_ina.ina01) THEN
      SELECT imd10 INTO l_imd10 FROM imd_file,rtz_file
       WHERE imd01 = rtz08
         #AND rtz01 = g_plant  #TQC-BB0161 mark 
          AND rtz01 = g_azw01  #TQC-BB0161 add  
     #IF p_type MATCHES '[1]' THEN #FUN-BB0072 Mark
     #IF (p_type MATCHES '[1]' AND g_ogb.ogb14t > 0) OR   #FUN-BB0072 Add   #FUN-C10007 mark
     #   (p_type MATCHES '[2]' AND g_ohb.ohb14t < 0) THEN #FUN-BB0072 Add   #FUN-C10007 mark
      IF (p_type MATCHES '[1]' AND g_ogb.ogb14t >= 0) OR   #FUN-C10007 add
         (p_type MATCHES '[2]' AND g_ohb.ohb14t <= 0) THEN #FUN-C10007 add
         LET l_ina.ina00 = '1'
         IF l_imd10 = 'W' THEN
            LET l_ina.ina00 = '2'
         END IF
         IF g_prog !='apcp200' THEN #FUN-C80045 add
            #FUN-C90050 mark begin---
            #SELECT rye03 INTO l_ina.ina01 FROM rye_file 
            # WHERE rye01 = 'aim' 
            #   AND rye02 = '1'
            #FUN-C90050 mark end-----

            CALL s_get_defslip('aim','1',g_plant,'N') RETURNING l_ina.ina01    #FUN-C90050 add

         #FUN-C80045 add sta
         ELSE
            #FUN-C90050 mark begin---
            #SELECT rye04 INTO l_ina.ina01 FROM rye_file
            # WHERE rye01 = 'aim'
            #   AND rye02 = '1'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('aim','1',g_plant,'Y') RETURNING l_ina.ina01    #FUN-C90050 add
         END IF  
         #FUN-C80045 add end
         IF cl_null(l_ina.ina01) THEN
            CALL s_errmsg('ina01',l_ina.ina01,'sel_rye','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_auto_assign_no("aim",l_ina.ina01,g_today,'1',"ina_file","ina01","","","")
            RETURNING li_result,l_ina.ina01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
     #ELSE   #FUN-BB0072 Mark
      END IF #FUN-BB0072 Add
      IF (p_type MATCHES '[1]' AND g_ogb.ogb14t < 0) OR   #FUN-BB0072 Add
         (p_type MATCHES '[2]' AND g_ohb.ohb14t > 0) THEN #FUN-BB0072 Add
         LET l_ina.ina00 = '3'
         IF l_imd10 = 'W' THEN
            LET l_ina.ina00 = '4'
         END IF
         IF g_prog !='apcp200' THEN #FUN-C80045 add
            #FUN-C90050 mark begin---
            #SELECT rye03 INTO l_ina.ina01 FROM rye_file
            # WHERE rye01 = 'aim'
            #   AND rye02 = '2'
            #FUN-C90050 mark end----

            CALL s_get_defslip('aim','2',g_plant,'N') RETURNING l_ina.ina01   #FUN-C90050 add

         #FUN-C80045 add sta      
         ELSE 
            #FUN-C90050 mark begin---
            #SELECT rye04 INTO l_ina.ina01 FROM rye_file
            # WHERE rye01 = 'aim'
            #   AND rye02 = '2'  
            #FUN-C90050 mark end----- 
            CALL s_get_defslip('aim','2',g_plant,'Y') RETURNING l_ina.ina01   #FUN-C90050 add
         END IF 
         #FUN-C80045 add end      
         IF cl_null(l_ina.ina01) THEN
            CALL s_errmsg('ina01',l_ina.ina01,'sel_rye','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_auto_assign_no("aim",l_ina.ina01,g_today,'2',"ina_file","ina01","","","")
            RETURNING li_result,l_ina.ina01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
     #LET l_ina.ina02 = g_today       #TQC-B90235 Mark
      LET l_ina.ina02 = g_alter_date  #TQC-B90235 Add
      LET l_ina.ina03 = g_today 
      LET l_ina.ina04 = g_grup
      LET l_ina.ina08 = '1'
      LET l_ina.inaprsw = 0
      LET l_ina.inapost = 'Y'
      LET l_ina.inauser = g_user
      LET l_ina.inagrup = g_grup
      LET l_ina.inadate = g_today
      LET l_ina.inamksg = 'N'
      LET l_ina.inaconu = g_user
      LET l_ina.inacond = g_today
      LET l_ina.inacont = TIME
      LET l_ina.inaconf = 'Y'
      IF p_type = '1' THEN
         LET l_ina.ina10 = g_oga.oga01
      ELSE
         LET l_ina.ina10 = g_oha.oha01
      END IF
      LET l_ina.ina11 = g_user
      LET l_ina.inaspc = 0
      LET l_ina.ina103 = ''
     #LET l_ina.inaplant = g_plant   #TQC-BB0161 mark
     #LET l_ina.inalegal = g_legal   #TQC-BB0161 mark
      LET l_ina.inaplant = g_azw01   #TQC-BB0161 add
      LET l_ina.inalegal = g_azw02   #TQC-BB0161 add
      LET l_ina.ina12   = 'N'
      LET l_ina.inapos  = 'N'
      LET l_ina.inaoriu = g_user
      LET l_ina.inaorig = g_grup
      LET l_ina.ina1013 = NULL
      LET l_ina.ina1014 = NULL
      LET l_ina.ina102  = NULL
      LET l_ina.inaud13 = NULL
      LET l_ina.inaud14 = NULL
      LET l_ina.inaud15 = NULL
      INSERT INTO ina_file VALUES (l_ina.*)
      IF STATUS THEN
         CALL s_errmsg('ina01',l_ina.ina01,'ina_ins',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
     
   LET l_inb.inb01 = l_ina.ina01
   SELECT MAX(inb03)+1 INTO l_inb.inb03
     FROM inb_file
    WHERE inb01 = l_inb.inb01
   IF cl_null(l_inb.inb03) THEN
      LET l_inb.inb03 = 1
   END IF
   IF p_type = '1' THEN
      LET l_inb.inb04 = g_ogb.ogb04
      #FUN-C90049 mark begin---
      #SELECT rtz08 INTO l_inb.inb05 FROM rtz_file
      # WHERE rtz01 = g_oga.ogaplant
      #FUN-C90049 mark end-----
      CALL s_get_noncoststore(g_oga.ogaplant,l_inb.inb04) RETURNING l_inb.inb05    #FUN-C90049 add
      LET l_inb.inb08 = g_ogb.ogb05
   ELSE
      LET l_inb.inb04 = g_ohb.ohb04
      #FUN-C90049 mark begin---
      #SELECT rtz08 INTO l_inb.inb05 FROM rtz_file
      # WHERE rtz01 = g_oha.ohaplant
      #FUN-C90049 mark end----
      CALL s_get_noncoststore(g_oha.ohaplant,l_inb.inb04) RETURNING l_inb.inb05    #FUN-C90049 add
      LET l_inb.inb08 = g_ohb.ohb05
   END IF
   LET l_inb.inb06 = ' '
   LET l_inb.inb07 = ' '
   
   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01 = l_inb.inb04
      AND img02 = l_inb.inb05
      AND img03 = l_inb.inb06
      AND img04 = l_inb.inb07
   IF p_type = '1' THEN
      CALL s_umfchk(l_inb.inb04,g_ogb.ogb05,l_img09)
         RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN LET l_factor = 1 END IF
      LET l_inb.inb08_fac = l_factor
     #LET l_inb.inb09 = g_ogb.ogb12        #FUN-BB0072 Mark
      LET l_inb.inb09 = s_abs(g_ogb.ogb12) #FUN-BB0072 Add
      LET l_inb.inb902 = g_ogb.ogb910
      
      CALL s_umfchk(l_inb.inb04,l_inb.inb902,l_img09)
         RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN LET l_factor = 1 END IF
      LET l_inb.inb903 = l_factor
      LET l_inb.inb904 = g_ogb.ogb912
      LET l_inb.inb905 = g_ogb.ogb913
      LET l_inb.inb907 = g_ogb.ogb915
   ELSE
      CALL s_umfchk(l_inb.inb04,g_ohb.ohb05,l_img09)
         RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN LET l_factor = 1 END IF
      LET l_inb.inb08_fac = l_factor
     #LET l_inb.inb09 = g_ohb.ohb12        #FUN-BB0072 Mark
      LET l_inb.inb09 = s_abs(g_ohb.ohb12) #FUN-BB0072 Add
      LET l_inb.inb902 = g_ohb.ohb910
      
      CALL s_umfchk(l_inb.inb04,l_inb.inb902,l_img09)
         RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN LET l_factor = 1 END IF
      LET l_inb.inb903 = l_factor
      LET l_inb.inb904 = g_ohb.ohb912
      LET l_inb.inb905 = g_ohb.ohb913
      LET l_inb.inb907 = g_ohb.ohb915
   END IF
   LET l_inb.inb10 = 'N'
   
   CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_img09)
      RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN LET l_factor = 1 END IF
   LET l_inb.inb906 = l_factor
   LET l_inb.inb930 = s_costcenter(l_ina.ina04)
   LET l_inb.inb16 = l_inb.inb09
   LET l_inb.inb922 = l_inb.inb902
   LET l_inb.inb923 = l_inb.inb903
   LET l_inb.inb924 = l_inb.inb904
   LET l_inb.inb925 = l_inb.inb905
   LET l_inb.inb926 = l_inb.inb906
   LET l_inb.inb927 = l_inb.inb907
  #LET l_inb.inbplant = g_plant   #TQC-BB0161 mark
  #LET l_inb.inblegal = g_legal   #TQC-BB0161 mark
   LET l_inb.inbplant = g_azw01   #TQC-BB0161 add
   LET l_inb.inblegal = g_azw02   #TQC-BB0161 add 
   LET l_inb.inbud13 = NULL
   LET l_inb.inbud14 = NULL
   LET l_inb.inbud15 = NULL
   
   #FUN-CB0087-xj---add---str
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(l_ina.ina01,l_ina.ina10,'',l_inb.inb04,l_inb.inb05,l_ina.ina04,l_ina.ina11) RETURNING l_inb.inb15
      IF cl_null(l_inb.inb15) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #FUN-CB0087-xj---add---end

   INSERT INTO inb_file VALUES(l_inb.*)
   IF STATUS THEN
      CALL s_errmsg('inb01',l_ina.ina01,'inb_ins',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_inbi.* TO NULL
         LET l_inbi.inbi01 = l_inb.inb01
         LET l_inbi.inbi03 = l_inb.inb03
         IF NOT s_ins_inbi(l_inbi.*,l_inb.inbplant) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF 
#FUN-B70074--add--insert--
   END IF
   IF l_ina.ina00 MATCHES '[12]' THEN
      LET l_type = -1
   ELSE
      LET l_type = 1
   END IF

   #FUN-C50090 Add Begin ---
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM img_file
    WHERE img01 = l_inb.inb04 AND img02 = l_inb.inb05
      AND img03 = l_inb.inb06 AND img04 = l_inb.inb07
   IF l_cnt = 0 THEN 
       CALL s_add_img(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_inb.inb01,l_inb.inb03,l_ina.ina02)
       IF g_errno = 'N' THEN
          LET g_success = 'N'
          RETURN
       END IF
   END IF
   #FUN-C50090 Add End -----

   CALL s_upimg(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                l_type,l_inb.inb09*l_inb.inb08_fac,l_ina.ina02,'','','','',
                l_inb.inb01,l_inb.inb03,'','','','','','','','','','','','')
   IF l_ina.ina00 MATCHES '[12]' THEN 
      CALL t620sub1_tlf(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                        l_inb.inb09*l_inb.inb08_fac,'2',              
                        l_inb.inb11,'',l_inb.inb01,l_inb.inb03,
                        l_inb.inb08,l_inb.inb08_fac,l_ina.ina04)
   END IF 
   IF l_ina.ina00 MATCHES '[34]'  THEN                  
      CALL t620sub1_tlf(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                        l_inb.inb09*l_inb.inb08_fac,'1',
                        l_inb.inb01,l_inb.inb03,l_inb.inb11,'',
                        l_inb.inb08,l_inb.inb08_fac,l_ina.ina04)
   END IF                    
   #多單位處理
   SELECT ima906,ima25 INTO l_ima906,l_ima25 FROM ima_file WHERE ima01 =  l_inb.inb04
   IF l_ima906 = '2' THEN
      IF NOT cl_null(l_inb.inb905) THEN
         CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
                       l_inb.inb07,l_inb.inb905,l_type,
                       l_inb.inb907,l_ina.ina02,l_inb.inb04,
                       l_inb.inb05,l_inb.inb06,l_inb.inb07,
                       '',l_ina.ina01,l_inb.inb03,'',l_inb.inb905,
                       '',l_imgg21,'','','','','','','',l_inb.inb906)
         IF l_ina.ina00 MATCHES '[12]' THEN 
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'2',
                               l_inb.inb01,l_inb.inb03,l_inb.inb11,'',
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
         IF l_ina.ina00 MATCHES '[34]' THEN                  
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'1',
                               l_inb.inb11,'',l_inb.inb01,l_inb.inb03,
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
      END IF
      IF NOT cl_null(l_inb.inb902) THEN
         CALL s_umfchk(l_inb.inb04,l_inb.inb902,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
                       l_inb.inb07,l_inb.inb902,l_type,
                       l_inb.inb904,l_ina.ina02,l_inb.inb04,
                       l_inb.inb05,l_inb.inb06,l_inb.inb07,
                       '',l_ina.ina01,l_inb.inb03,'',l_inb.inb902,
                       '',l_imgg21,'','','','','','','',l_inb.inb903)
         IF l_ina.ina00 MATCHES '[12]' THEN 
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'2',
                               l_inb.inb01,l_inb.inb03,l_inb.inb11,'',
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
         IF l_ina.ina00 MATCHES '[34]' THEN                  
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'1',
                               l_inb.inb11,'',l_inb.inb01,l_inb.inb03,
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
      END IF
   END IF
   IF l_ima906 = '3' THEN
      IF NOT cl_null(l_inb.inb905) THEN
         CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
           l_inb.inb07,l_inb.inb905,l_type,l_inb.inb907,
           l_ina.ina02,l_inb.inb04,l_inb.inb05,
           l_inb.inb06,l_inb.inb07,'',l_ina.ina01,
           l_inb.inb03,'',l_inb.inb905,'',l_imgg21,'',
           '','','','','','',l_inb.inb906)
         IF l_ina.ina00 MATCHES '[12]' THEN 
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'2',
                               l_inb.inb01,l_inb.inb03,l_inb.inb11,'',
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
         IF l_ina.ina00 MATCHES '[34]' THEN                  
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'1',
                               l_inb.inb11,'',l_inb.inb01,l_inb.inb03,
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
      END IF
   END IF
END FUNCTION





FUNCTION t620sub1_insrvurvv(p_type,p_rvu00,p_rty05)
 DEFINE p_type       LIKE type_file.chr1
 DEFINE p_rvu00      LIKE rvu_file.rvu01
 DEFINE p_rty05      LIKE rty_file.rty05
 DEFINE p_pmc        RECORD LIKE pmc_file.*
 DEFINE l_rvu        RECORD LIKE rvu_file.*
 DEFINE l_rvv        RECORD LIKE rvv_file.*
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE li_result    LIKE type_file.num5
 DEFINE l_img09      LIKE img_file.img09
 DEFINE l_type       LIKE type_file.num5
 DEFINE l_ima25      LIKE ima_file.ima25
 DEFINE l_ima906     LIKE ima_file.ima906
 DEFINE l_imd10      LIKE imd_file.imd10
 DEFINE l_imd11      LIKE imd_file.imd11
 DEFINE l_imd12      LIKE imd_file.imd12
 DEFINE l_imd13      LIKE imd_file.imd13
 DEFINE l_imd14      LIKE imd_file.imd14
 DEFINE l_imd15      LIKE imd_file.imd15
 DEFINE l_imgg21     LIKE imgg_file.imgg21
 DEFINE l_ima02      LIKE ima_file.ima02
 DEFINE l_ima44      LIKE ima_file.ima44
 DEFINE l_ima908     LIKE ima_file.ima908
 DEFINE l_factor     LIKE type_file.num5
 DEFINE l_azi10      LIKE azi_file.azi10 #FUN-B60150 ADD

   IF p_type = '1' THEN
      LET g_sql = "SELECT * ",
                 #"  FROM ",cl_get_target_table(g_plant,'rvu_file'),   #TQC-BB0161 mark
                  "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),   #TQC-BB0161 add
                  " WHERE rvu00 = '",p_rvu00,"'",
                  "   AND rvu25 = '",g_oga.oga01,"'",
                  "   AND rvu04 = '",p_rty05,"' "
  #ELSE    #FUN-B60150 MARK
   END IF  #FUN-B60150 ADD
   IF p_type = '2' THEN  #FUN-B60150 ADD
      LET g_sql = "SELECT * ",
                 #"  FROM ",cl_get_target_table(g_plant,'rvu_file'),   #TQC-BB0161 mark
                  "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),   #TQC-BB0161 add 
                  " WHERE rvu00 = '",p_rvu00,"'",
                  "   AND rvu25 = '",g_oha.oha01,"'",
                  "   AND rvu04 = '",p_rty05,"' "
   END IF

#FUN-B60150 ADD - BEGIN -------------------------------------------
   IF p_type = '3' THEN
      LET g_sql = "SELECT * ",
                 #"  FROM ",cl_get_target_table(g_plant,'rvu_file'),   #TQC-BB0161 mark
                  "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),   #TQC-BB0161 add
                  " WHERE rvu00 = '",p_rvu00,"'",
                  "   AND rvu25 = '",g_rvc.rvc01,"'",
                  "   AND rvu04 = '",p_rty05,"' "
   END IF
#FUN-B60150 ADD -  END  -------------------------------------------
    
   PREPARE t620sub1_sel_rvu FROM g_sql
   EXECUTE t620sub1_sel_rvu INTO l_rvu.*
  #IF cl_null(g_rvu04) OR p_rty05 <> g_rvu04 THEN     #FUN-B60150 MARK
   IF cl_null(g_rvu04) OR p_rty05 <> g_rvu04 OR cl_null(l_rvu.rvu04) THEN     #FUN-B60150 ADD
     #IF p_type MATCHES '[1]' THEN #FUN-BB0072 Mark
     #IF (p_type ='1' AND g_ogb.ogb14t > 0) OR (p_type = '2' AND g_ohb.ohb14t < 0) THEN #FUN-BB0072 Add  #FUN-C10007 mark
      IF (p_type ='1' AND g_ogb.ogb14t >= 0) OR (p_type = '2' AND g_ohb.ohb14t <= 0) THEN   #FUN-C10007 add
         LET l_rvu.rvu00 = '1'
         IF g_prog !='apcp200' THEN #FUN-C80045 add
            #FUN-C90050 mark begin---
            #SELECT rye03 INTO l_rvu.rvu01 FROM rye_file
            # WHERE rye01 = 'apm'
            #   AND rye02 = '7'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('apm','7',g_plant,'N') RETURNING l_rvu.rvu01   #FUN-C90050 add
         #FUN-C80045 add sta
         ELSE
            #FUN-C90050 mark begin--- 
            #SELECT rye04 INTO l_rvu.rvu01 FROM rye_file
            # WHERE rye01 = 'apm'
            #   AND rye02 = '7'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('apm','7',g_plant,'Y') RETURNING l_rvu.rvu01   #FUN-C90050 add
         END IF 
         #FUN-C80045 add end           
         IF cl_null(l_rvu.rvu01) THEN
            CALL s_errmsg('rvu01',l_rvu.rvu01,'sel_rye','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'7',"rvu_file","rvu01","","","")
            RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
     #ELSE    #FUN-B60150 MARK
      END IF  #FUN-B60150 ADD
     #IF p_type = '2' THEN #FUN-B60150 ADD #FUN-BB0072 Mark
      IF (p_type = '2' AND g_ohb.ohb14t > 0) OR (p_type ='1' AND g_ogb.ogb14t < 0) THEN #FUN-BB0072 Add
         LET l_rvu.rvu00 = '3'
         IF g_prog !='apcp200' THEN #FUN-C80045 add
            #FUN-C90050 mark begin---
            #SELECT rye03 INTO l_rvu.rvu01 FROM rye_file
            # WHERE rye01 = 'apm'
            #   AND rye02 = '4'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('apm','4',g_plant,'N') RETURNING l_rvu.rvu01   #FUN-C90050 add
         #FUN-C80045 add sta
         ELSE 
            #FUN-C90050 mark begin---
            #SELECT rye04 INTO l_rvu.rvu01 FROM rye_file
            # WHERE rye01 = 'apm'
            #   AND rye02 = '4'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('apm','4',g_plant,'Y') RETURNING l_rvu.rvu01   #FUN-C90050 add
         END IF 
         #FUN-C80045 add end      
        #PREPARE t620sub1_sel_rye3 FROM g_sql               #FUN-C90050 mark
        #EXECUTE t620sub1_sel_rye3 INTO l_rvu.rvu01         #FUN-C90050 mark
         IF cl_null(l_rvu.rvu01) THEN
            CALL s_errmsg('rvu01',l_rvu.rvu01,'sel_rye','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'4',"rvu_file","rvu01","","","")
             RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF

#FUN-B60150 ADD - BEGIN -------------------------------------
      IF p_type = '3' THEN
         IF p_rvu00 = '1' THEN
            LET l_rvu.rvu00 = '1'
            IF g_prog !='apcp200' THEN #FUN-C80045 add
               #FUN-C90050 mark bebegin---
               #SELECT rye03 INTO l_rvu.rvu01 FROM rye_file
               # WHERE rye01 = 'apm'
               #   AND rye02 = '7'
               #FUN-C90050 mark end-----

               CALL s_get_defslip('apm','7',g_plant,'N') RETURNING l_rvu.rvu01    #FUN-C90050 add
            #FUN-C80045 add sta
            ELSE
               #FUN-C90050 mark begin---
               #SELECT rye04 INTO l_rvu.rvu01 FROM rye_file
               # WHERE rye01 = 'apm'
               #   AND rye02 = '7'
               #FUN-C90050 mark end-----
               CALL s_get_defslip('apm','7',g_plant,'Y') RETURNING l_rvu.rvu01    #FUN-C90050 add
            END IF     
            #FUN-C80045 add end      
            IF cl_null(l_rvu.rvu01) THEN
               CALL s_errmsg('rvu01',l_rvu.rvu01,'sel_rye','art-330',1)
               LET g_success = 'N'
               RETURN
            END IF
            CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'7',"rvu_file","rvu01","","","")
               RETURNING li_result,l_rvu.rvu01
            IF (NOT li_result) THEN
               LET g_success = 'N'
               RETURN
            END IF
         ELSE
            LET l_rvu.rvu00 = '3'
            IF g_prog !='apcp200' THEN #FUN-C80045 add
               #FUN-C90050 mark begin---
               #SELECT rye03 INTO l_rvu.rvu01 FROM rye_file
               # WHERE rye01 = 'apm'
               #   AND rye02 = '4'
               #FUN-C90050 mark end-----

               CALL s_get_defslip('apm','4',g_plant,'N') RETURNING l_rvu.rvu01   #FUN-C90050 add
            #FUN-C80045 add sta      
            ELSE
               #FUN-C90050 mark begin--- 
               #SELECT rye04 INTO l_rvu.rvu01 FROM rye_file
               # WHERE rye01 = 'apm'
               #   AND rye02 = '4'    
               #FUN-C90050 mark end-----
               CALL s_get_defslip('apm','4',g_plant,'Y') RETURNING l_rvu.rvu01   #FUN-C90050 add
            END IF
            #FUN-C80045 add end      
            IF cl_null(l_rvu.rvu01) THEN
               CALL s_errmsg('rvu01',l_rvu.rvu01,'sel_rye','art-330',1)
               LET g_success = 'N'
               RETURN
            END IF
            CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'4',"rvu_file","rvu01","","","")
                RETURNING li_result,l_rvu.rvu01
            IF (NOT li_result) THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
#FUN-B60150 ADD -  END  -------------------------------------
      
      LET g_rvu04 = p_rty05
      LET l_rvu.rvu04 = p_rty05
      SELECT pmc03,pmc17,pmc49,pmc22,pmc47
        INTO l_rvu.rvu05,l_rvu.rvu111,l_rvu.rvu112,
             l_rvu.rvu113,l_rvu.rvu115
        FROM pmc_file
       WHERE pmc01=l_rvu.rvu04
      
      SELECT gec04 INTO l_rvu.rvu12 FROM gec_file
       WHERE gec01=l_rvu.rvu115
         AND gec011='1'
      
     #SELECT rty12,rty04 INTO l_rvu.rvu22,l_rvu.rvu23
     #  FROM rty_file
     # WHERE rty01 = g_oga.ogaplant
     #   AND rty02 = p_rvg.ogb04
      
      LET l_rvu.rvupos = 'N'
      LET l_rvu.rvu02 = ''
     #LET l_rvu.rvu03 = g_today       #TQC-B90235 Mark
      LET l_rvu.rvu03 = g_alter_date  #TQC-B90235 Add
      LET l_rvu.rvu06 = g_grup
      LET l_rvu.rvu07 = g_user
      LET l_rvu.rvu08 = 'REG'
      LET l_rvu.rvu09 = ''
     #FUN-BB0044 Add&Mark Begin ---
     #LET l_rvu.rvu10 = 'N'

      IF p_rvu00 = '3'  THEN
         LET l_rvu.rvu10 = 'Y'
      ELSE
         LET l_rvu.rvu10 = 'N'
      END IF
     #FUN-BB0044 Add&Mark End -----
      LET l_rvu.rvu11 = NULL
      LET l_rvu.rvu102= NULL
      LET l_rvu.rvuud13 = NULL
      LET l_rvu.rvuud14 = NULL
      LET l_rvu.rvuud15 = NULL
      LET l_rvu.rvu20 = 'N'
      LET l_rvu.rvuconf = 'Y'
      LET l_rvu.rvucond = g_today
      LET l_rvu.rvuconu = g_user
      LET l_rvu.rvucont = TIME
      LET l_rvu.rvucrat = g_today
      LET l_rvu.rvuacti = 'Y'
      LET l_rvu.rvuuser = g_user
      LET l_rvu.rvugrup = g_grup
      LET l_rvu.rvudate = NULL
      IF g_aza.aza17 = l_rvu.rvu113 THEN
         LET l_rvu.rvu114 = 1
      ELSE
         CALL s_curr3(l_rvu.rvu113,g_today,g_sma.sma904)
            RETURNING l_rvu.rvu114
      END IF
      LET l_rvu.rvu116 = '1'
      LET l_rvu.rvu117 = ''
     #LET l_rvu.rvu21 = '3'   #FUN-B60150 MARK
#FUN-B60150 - ADD - BEGIN -----------------------------------
      IF p_type = '1' OR p_type = '2' THEN
         LET l_rvu.rvu21 = '1'        #TQC-BB0131 add
         IF g_ogb.ogb44 = '2' OR g_ohb.ohb64 = '2' THEN
           #LET l_rvu.rvu21 = '2' #FUN-BB0072 Mark
          # LET l_rvu.rvu21 = '1' #FUN-BB0072 Add   #TQC-BB0131 mark
            LET l_rvu.rvu27 = '2'
         END IF
         IF g_ogb.ogb44 = '3' OR g_ohb.ohb64 = '3' THEN
           #LET l_rvu.rvu21 = '3' #FUN-BB0072 Mark
          # LET l_rvu.rvu21 = '1' #FUN-BB0072 Add   #TQC-BB0131 mark
            LET l_rvu.rvu27 = '3'
         END IF
      END IF
      IF p_type = '3' THEN
         IF (l_rvu.rvu00 = '1' AND (g_rvg.ogb14t > 0))
            OR (l_rvu.rvu00 = '3' AND (g_rvg.ogb14t < 0)) THEN
            LET l_rvu.rvu21 = '1'
            LET l_rvu.rvu27 = '2'
         END IF
         IF (l_rvu.rvu00 = '3' AND (g_rvg.ogb14t > 0))
            OR (l_rvu.rvu00 = '1' AND (g_rvg.ogb14t < 0)) THEN
            LET l_rvu.rvu21 = '2'
            LET l_rvu.rvu27 = '2'
         END IF
      END IF
#FUN-B60150 - ADD -  END  -----------------------------------
      LET l_rvu.rvu900 = '1'
      LET l_rvu.rvu17  = '1'
      LET l_rvu.rvumksg = 'N'
      IF p_type = '1' THEN
         LET l_rvu.rvu25 = g_oga.oga01
     #ELSE  #FUN-B60150 MARK
      END IF                 #FUN-B60150 ADD
      IF p_type = '2' THEN   #FUN-B60150 ADD
         LET l_rvu.rvu25 = g_oha.oha01
      END IF
#FUN-B60150 ADD - BEGIN ---------------------
      IF p_type = '3' THEN
         LET l_rvu.rvu25 = g_rvc.rvc01
      END IF
#FUN-B60150 ADD -  END  ---------------------
     #LET l_rvu.rvuplant = g_plant    #TQC-BB0161 mark
     #LET l_rvu.rvulegal = g_legal    #TQC-BB0161 mark
      LET l_rvu.rvuplant = g_azw01    #TQC-BB0161 add
      LET l_rvu.rvulegal = g_azw02    #TQC-BB0161 add
      LET l_rvu.rvuoriu = g_user
      LET l_rvu.rvuorig = g_grup
     #LET l_rvu.rvu27   = '3'    #TQC-B60065  #FUN-B60150 MARK

      INSERT INTO rvu_file VALUES(l_rvu.*)
      IF STATUS THEN
         CALL s_errmsg('rvu01',l_rvu.rvu01,'rvu_ins',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   LET l_rvv.rvv01 = l_rvu.rvu01

   SELECT MAX(rvv02)+1 INTO l_rvv.rvv02
     FROM rvv_file
    WHERE rvv01 = l_rvv.rvv01
   IF cl_null(l_rvv.rvv02) THEN
      LET l_rvv.rvv02 = 1
   END IF
   LET l_rvv.rvv03 = l_rvu.rvu00
   LET l_rvv.rvv04 = ''
   LET l_rvv.rvv05 = ''
   LET l_rvv.rvv06 = l_rvu.rvu04
  #LET l_rvv.rvv09 = g_today       #TQC-B90235 Mark
   LET l_rvv.rvv09 = g_alter_date  #TQC-B90235 Add
   LET l_rvv.rvv18 = ''
   LET l_rvv.rvv23 = 0
   LET l_rvv.rvv25 = 'N'
   LET l_rvv.rvv26 = ''
   IF p_type = '1' THEN
     #LET l_rvv.rvv17 = g_ogb.ogb12        #FUN-BB0072 Mark
      LET l_rvv.rvv17 = s_abs(g_ogb.ogb12) #FUN-BB0072 Add
      LET l_rvv.rvv31 = g_ogb.ogb04
      LET l_rvv.rvv031 = g_ogb.ogb06
      LET l_rvv.rvv35 = g_ogb.ogb05
  #ELSE  #FUN-B60150 MARK
   END IF #FUN-B60150 ADD
   IF p_type = '2' THEN  #FUN-B60150 ADD
     #LET l_rvv.rvv17 = g_ohb.ohb12        #FUN-BB0072 Mark
      LET l_rvv.rvv17 = s_abs(g_ohb.ohb12) #FUN-BB0072 Add
      LET l_rvv.rvv31 = g_ohb.ohb04
      LET l_rvv.rvv031 = g_ohb.ohb06
      LET l_rvv.rvv35 = g_ohb.ohb05
   END IF
#FUN-B60150 ADD - BEGIN -------------------------
   IF p_type = '3' THEN
      LET l_rvv.rvv17 = g_rvg.rvg08
      LET l_rvv.rvv31 = g_rvg.ogb04
      LET g_sql = "SELECT ima02 ", 
                  "  FROM ",cl_get_target_table(g_rvg.rvg03, 'ima_file'),
                  " WHERE ima01='",g_rvg.ogb04,"'"
      PREPARE t620_sel_ima FROM g_sql
      EXECUTE t620_sel_ima INTO l_rvv.rvv031
      LET l_rvv.rvv32=''
      LET l_rvv.rvv35 = g_rvg.ogb05
   END IF
#FUN-B60150 ADD -  END  -------------------------
   IF p_type = '1' THEN
      SELECT rtz07 INTO l_rvv.rvv32 FROM rtz_file
       WHERE rtz01 = g_oga.ogaplant
  #ELSE  #FUN-B60150 MARK
   END IF #FUN-B60150 ADD
   IF p_type = '2' THEN  #FUN-B60150 ADD
      SELECT rtz07 INTO l_rvv.rvv32 FROM rtz_file
       WHERE rtz01 = g_oha.ohaplant
   END IF
#FUN-B60150 ADD - BEGIN -------------------------
   IF p_type = '3' THEN
     SELECT rtz07 INTO l_rvv.rvv32 FROM rtz_file
       WHERE rtz01 = g_rvg.rvg03
   END IF 
#FUN-B60150 ADD -  END  -------------------------
   LET l_rvv.rvv33 = ' '
   LET l_rvv.rvv34 = ' '
   CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_ima44)
      RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN LET l_factor = 1 END IF
   LET l_rvv.rvv35_fac = l_factor
   LET l_rvv.rvv36 = ''
   LET l_rvv.rvv37 = ''
   LET l_rvv.rvv40 = 'N'
   LET l_rvv.rvv41 = ''
   IF p_type = '1' THEN
      LET l_rvv.rvv80 = g_ogb.ogb910
      LET l_rvv.rvv81 = g_ogb.ogb911
      LET l_rvv.rvv82 = g_ogb.ogb912
      LET l_rvv.rvv83 = g_ogb.ogb913
      LET l_rvv.rvv84 = g_ogb.ogb914
      LET l_rvv.rvv85 = g_ogb.ogb915
      LET l_rvv.rvv86 = g_ogb.ogb916
     #LET l_rvv.rvv87 = g_ogb.ogb917        #FUN-BB0072 Mark
      LET l_rvv.rvv87 = s_abs(g_ogb.ogb917) #FUN-BB0072 Add
  #ELSE   #FUN-B60150 MARK
   END IF #FUN-B60150 ADD
   IF p_type = '2' THEN #FUN-B60150 ADD
      LET l_rvv.rvv80 = g_ohb.ohb910
      LET l_rvv.rvv81 = g_ohb.ohb911
      LET l_rvv.rvv82 = g_ohb.ohb912
      LET l_rvv.rvv83 = g_ohb.ohb913
      LET l_rvv.rvv84 = g_ohb.ohb914
      LET l_rvv.rvv85 = g_ohb.ohb915
      LET l_rvv.rvv86 = g_ohb.ohb916
     #LET l_rvv.rvv87 = g_ohb.ohb917        #FUN-BB0072 Mark
      LET l_rvv.rvv87 = s_abs(g_ohb.ohb917) #FUN-BB0072 Add
   END IF
#FUN-B60150 ADD - BEGIN -------------------------
   IF p_type = '3' THEN
      LET l_rvv.rvv80 = g_rvg.ogb05
      LET l_rvv.rvv81 = 1
      LET l_rvv.rvv82 = g_rvg.rvg08
      LET l_rvv.rvv83 = g_rvg.ogb05
      LET l_rvv.rvv84 = 1
      LET l_rvv.rvv85 = g_rvg.rvg08
      LET l_rvv.rvv86 = g_rvg.ogb05
      LET l_rvv.rvv87 = g_rvg.rvg08
   END IF
#FUN-B60150 ADD -  END  -------------------------
   SELECT azi03,azi04,azi10 INTO t_azi03,t_azi04,l_azi10
     FROM azi_file
    WHERE azi01=l_rvu.rvu113
   IF cl_null(t_azi03) THEN LET t_azi03=0 END IF
   IF cl_null(t_azi04) THEN LET t_azi04=0 END IF
  #CALL s_defprice_new(l_rvv.rvv31,l_rvu.rvu04,l_rvu.rvu113,g_today,l_rvv.rvv87,'',
  #                    l_rvu.rvu115,l_rvu.rvu12,'1',l_rvv.rvv86,'',l_rvu.rvu112,
  #                    l_rvu.rvu111,g_plant)
  #   RETURNING l_rvv.rvv38,l_rvv.rvv38t,l_rvv.rvv10,l_rvv.rvv11
   IF cl_null(l_rvv.rvv10) THEN LET l_rvv.rvv10 = '4' END IF
   IF p_type = '1' THEN
      #FUN-B60150 ADD - BEGIN --------------------------
      IF g_ogb.ogb44 = '2' AND g_sma.sma146 = '2' THEN
        #LET l_rvv.rvv39t = g_ogb.ogb14t        #FUN-BB0072 Mark
         LET l_rvv.rvv39t = s_abs(g_ogb.ogb14t) #FUN-BB0072 Add
         LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
         LET l_rvv.rvv38t = g_ogb.ogb13
         LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
      ELSE
      #FUN-B60150 ADD - END ----------------------------
         LET l_rvv.rvv39t = g_ogb.ogb14t*(g_oga.oga24/l_rvu.rvu114)*(1-g_ogb.ogb46/100)
         LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
         LET l_rvv.rvv39t = s_abs(l_rvv.rvv39t) #FUN-BB0072 Add
         LET l_rvv.rvv38t = l_rvv.rvv39t/g_ogb.ogb12
         LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
      END IF #FUN-B60150 ADD
  #ELSE   #FUN-B60150 MARK
   END IF #FUN-B60150 ADD
   IF p_type = '2' THEN #FUN-B60150 ADD
      #FUN-B60150 ADD - BEGIN --------------------------
      IF g_ohb.ohb64 = '2' AND g_sma.sma146 = '2' THEN
        #LET l_rvv.rvv39t = g_ohb.ohb14t        #FUN-BB0072 Mark
         LET l_rvv.rvv39t = s_abs(g_ohb.ohb14t) #FUN-BB0072 Add
         LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
         LET l_rvv.rvv38t = g_ohb.ohb13
         LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
      ELSE
      #FUN-B60150 ADD - END ----------------------------
         LET l_rvv.rvv39t = g_ohb.ohb14t*(g_oha.oha24/l_rvu.rvu114)*(1-g_ohb.ohb66/100)
         LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
         LET l_rvv.rvv39t = s_abs(l_rvv.rvv39t) #FUN-BB0072 Add
         LET l_rvv.rvv38t = l_rvv.rvv39t/g_ohb.ohb12
         LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
      END IF #FUN-B60150 ADD
   END IF
#FUN-B60150 ADD - BEGIN -------------------------------
   IF p_type = '3' THEN 
      LET l_rvv.rvv39t = g_rvv39t
      LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
      LET l_rvv.rvv38t = l_rvv.rvv39t/g_rvf08
      LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
   END IF
#FUN-B60150 ADD -  END  -------------------------------

   LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_rvu.rvu12/100)
   LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
   LET l_rvv.rvv38 = l_rvv.rvv38t / ( 1 + l_rvu.rvu12/100)
   LET l_rvv.rvv38 = cl_digcut( l_rvv.rvv38 , t_azi03)

   LET l_rvv.rvv88  = 0
   LET l_rvv.rvv89 = 'N'
   LET l_rvv.rvv930=s_costcenter(l_rvu.rvu06)
  #LET l_rvv.rvvplant = g_plant   #TQC-BB0161 mark
  #LET l_rvv.rvvlegal = g_legal   #TQC-BB0161 mark
   LET l_rvv.rvvplant = g_azw01   #TQC-BB0161 add
   LET l_rvv.rvvlegal = g_azw02   #TQC-BB0161 add
   LET l_rvv.rvvud13 = NULL
   LET l_rvv.rvvud14 = NULL
   LET l_rvv.rvvud15 = NULL
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu.rvu07,l_rvu.rvu06) RETURNING l_rvv.rvv26
      IF cl_null(l_rvv.rvv26) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
         RETURN 
      END IF
   END IF
   #FUN-CB0087---add---end---
   
   INSERT INTO rvv_file VALUES(l_rvv.*)
   IF STATUS THEN
      CALL s_errmsg('rvv01',l_rvu.rvu01,'rvv_ins',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file 
    WHERE ima01 = l_rvv.rvv31
   SELECT imd10,imd11,imd12,imd13,imd14,imd15
     INTO l_imd10,l_imd11,l_imd12,l_imd13,l_imd14,l_imd15
     FROM imd_file 
    WHERE imd01 = l_rvv.rvv32
   IF l_rvu.rvu00 = '1' THEN 
      SELECT COUNT(*) INTO l_cnt FROM img_file 
       WHERE img01=l_rvv.rvv31
         AND img02=l_rvv.rvv32
         AND img03=l_rvv.rvv33
         AND img04=l_rvv.rvv34
      IF l_cnt = 0  THEN 
         INSERT INTO img_file(img01,img02,img03,img04,img09,img10,img17,
                              img18,img20,img21,img22,img23,img24,img25,
                              img27,img28,imgplant,imglegal)
         VALUES(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                l_ima25,0,g_today,g_lastdat,1,1,
                l_imd10,l_imd11,l_imd12,l_imd13,l_imd14,l_imd15,
               #g_plant,g_legal)    #TQC-BB0161 mark
                g_azw01,g_azw02)    #TQC-BB0161 add
      END IF 
      CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,+1,
                   l_rvv.rvv17*l_rvv.rvv35_fac,l_rvu.rvu03,l_rvv.rvv31,
                   l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv01,
                   l_rvv.rvv02,l_rvv.rvv35,l_rvv.rvv17,l_ima25,l_rvv.rvv35_fac,
                   1,'','','','','','','')
#      IF l_rvu.rvu00 = '1' THEN    #FUN-BA0087 mark
         CALL t620sub1_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
                           l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
                           l_rvv.rvv35_fac,l_rvv.rvv06)
#FUN-BA0087 mark START
#      END IF                       
#      IF l_rvu.rvu00 = '3' THEN 
#         CALL t620sub1_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
#                           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv01,
#                           l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
#                           l_rvv.rvv35_fac,l_rvv.rvv06)
#      END IF
#FUN-BA0087 mark END
   ELSE
      CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,0,
                   l_rvv.rvv17*l_rvv.rvv35_fac,l_rvv.rvv09,'','','',
                   '',l_rvv.rvv01,l_rvv.rvv02,'','','','','','','','',
                   0,0,'','')
#FUN-BA0087 mark START
#      IF l_rvu.rvu00 = '1' THEN
#         CALL t620sub1_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
#                           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
#                           l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
#                           l_rvv.rvv35_fac,l_rvv.rvv06)
#      END IF 
#FUN-BA0087 mark END
      IF l_rvu.rvu00 = '3' THEN 
         CALL t620sub1_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                          l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
                          l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
                          l_rvv.rvv35_fac,l_rvv.rvv06)
      END IF
   END IF     
  #多單位處理
   IF l_rvu.rvu00='1' THEN
      LET l_type = +1
   ELSE
      LET l_type = 0
   END IF
   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
                       l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
                       '','','',l_rvv.rvv84)
         IF l_rvu.rvu00 = '1' THEN
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
                               l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
                               l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
            l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
            l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
            l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
      END IF
      IF NOT cl_null(l_rvv.rvv80) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv80,l_type,l_rvv.rvv82,l_rvu.rvu02,l_rvv.rvv31,
                       l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,'','','','',
                       l_rvv.rvv80,'',l_imgg21,'','','','','','','',
                       l_rvv.rvv81)
         IF l_rvu.rvu00 = '1' THEN
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
                               l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
                               l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
                               l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
                               l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
                       l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
                       '','','',l_rvv.rvv84)
         IF l_rvu.rvu00 = '1' THEN
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
                              l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
                              l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
                              l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
                              l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
      END IF
   END IF
END FUNCTION





FUNCTION t620sub1_updruv13(p_oga01)
 DEFINE p_oga01      LIKE oga_file.oga01 
 DEFINE l_rvu13      LIKE rvu_file.rvu13
 DEFINE l_rvu14      LIKE rvu_file.rvu14 
 DEFINE l_rvu        RECORD LIKE rvu_file.* 
 DEFINE l_sql        STRING
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE l_cnt2       LIKE type_file.num5

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvu_file
        WHERE rvu00 = '3' AND rvu25 = p_oga01
   IF l_cnt <= 0  OR cl_null(l_cnt)THEN
      RETURN
   END IF
   LET l_sql = "SELECT * ",
   #            "  FROM ",cl_get_target_table(g_plant,'rvu_file'),  #TQC-BB0161 mark
               "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),   #TQC-BB0161 add
               " WHERE rvu00 = '3'",   #倉退
               "   AND rvu25 = '",p_oga01,"'"
    PREPARE t620sub1_sel_rvu1 FROM l_sql
    DECLARE t620sub1_sel_rvu1_c CURSOR FOR t620sub1_sel_rvu1
    FOREACH t620sub1_sel_rvu1_c INTO l_rvu.*
       IF cl_null(l_rvu.rvu01) THEN RETURN END IF

       IF l_rvu.rvu10 = 'Y' THEN
          SELECT SUM(rvv39) INTO l_rvu13 FROM rvv_file
                 WHERE rvv01 = l_rvu.rvu01
          IF l_rvu13 IS NULL OR cl_null(l_rvu13)THEN 
             LET l_rvu13 = 0 
          END IF
          LET l_rvu14=l_rvu13*l_rvu.rvu12/100
          UPDATE rvu_file 
                 SET rvu13 = l_rvu13, rvu14 = l_rvu14
               WHERE rvu01 = l_rvu.rvu01 
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('upd rvu:',SQLCA.SQLCODE,0)
             LET g_success='N'
             RETURN
          END IF
       END IF
    END FOREACH 
END FUNCTION 
#TQC-BB0131 add END
#FUN-B40098





#{
#參數:p_cmd - IF p_cmd='2' 則會跳出"是否執行扣帳的對話選項視窗",其他值則不會跳出
#     p_inTransaction - 呼叫此FUN時,程式是否處在Transction中,IF p_inTransaction=TRUE 則不做 Begin Work,IF p_inTransaction=FALSE 則會呼叫begin work,例如:確認段來呼叫此FUN則傳TRUE,獨立執行此FUN則傳FALSE
#     p_oga01 - 出貨單頭單號
#     p_Input_oga02 - IF TRUE 則Input oga02,IF FALSE 則不Input oga02(WHEN背景執行或外部呼叫時)
#注意 :考慮到會有外部程式來呼叫此扣帳函數,所以把原本裡面的CALL t600_chspic()移到外面作,
#      所以做完_s()後,有需要重秀圖檔的話,必須再呼叫一次t600_chspic()
#}
FUNCTION t600sub_s(p_cmd,p_inTransaction,p_oga01,p_Input_oga02)            # when l_oga.ogapost='N' (Turn to 'Y')
DEFINE p_cmd     LIKE type_file.chr1,         #1.不詢問 2.要詢問  #No.FUN-680137 VARCHAR(1)
       p_inTransaction LIKE type_file.num5,   #FUN-730012 #是否要做 begin work 的指標
       p_oga01 LIKE oga_file.oga01,
       p_Input_oga02 LIKE type_file.num5,
       l_success LIKE type_file.chr1,         #TQC-680018 add #存放g_success值
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
   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012

  #CHI-A50004 程式搬移 --start--
   IF NOT p_inTransaction THEN   #FUN-730012
      BEGIN WORK
      LET g_success = 'Y'
      LET g_totsuccess = 'Y' #TQC-620156
   END IF

  #DEV-D40015 add str--------
  #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND g_prog = 'axmt620' THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT ogb04 FROM ogb_file WHERE ogb01 = l_oga.oga01) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
	
     #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('post','tlfb',l_oga.oga01,'','') THEN
            ROLLBACK WORK
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #DEV-D40015 add end--------

   CALL t600sub_lock_cl()
   OPEN t600sub_cl USING p_oga01 #CHI-A50004 mod l_oga.oga01->p_oga01
   IF STATUS THEN
      CALL cl_err("OPEN t600sub_cl:", STATUS, 1)
      IF NOT p_inTransaction THEN   #MOD-B30430 add
         CLOSE t600sub_cl
         ROLLBACK WORK #MOD-B30430 add
      END IF #MOD-B30430 add
      LET g_success = 'N'   #TQC-930155 add
      RETURN
   END IF
 
   FETCH t600sub_cl INTO l_oga.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(l_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       IF NOT p_inTransaction THEN   #MOD-B30430 add
          CLOSE t600sub_cl
          ROLLBACK WORK #MOD-B30430 add
       END IF #MOD-B30430 add
       LET g_success = 'N'   #TQC-930155 add
       RETURN
   END IF
  #CHI-A50004 程式搬移 --end--

  #MOD-B30430 mod --start--
  #IF s_shut(0) THEN LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
   IF s_shut(0) THEN 
      IF NOT p_inTransaction THEN 
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
  #MOD-B30430 mod --end--
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01
   LET l_oga.oga02 = g_today # add by wangxt170210
  #FUN-970017---add----str----
   LET l_agree = 'N'
   #同時具有自動確認和簽核的功能時的判斷
   LET l_t1=s_get_doc_no(l_oga.oga01)
   SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=l_t1
   IF g_oay.oayconf = 'Y' AND g_oay.oayapr = 'Y' AND
      g_action_choice = 'efconfirm' THEN

      #(1)出貨單確認時,庫存扣帳方式若為'2:立刻扣帳(會詢問)',一律改為'1:立刻扣帳(不詢問)'
       IF p_cmd = '2' THEN
           LET p_cmd = '1'
       END IF

      #(2)不能 INPUT oga02
       LET p_Input_oga02 = FALSE

      #(3)出貨立刻扣帳,扣帳日期設為g_today
       LET l_agree = 'Y'
   END IF
  #FUN-970017---add----end----

   IF l_oga.oga00 = "A" THEN
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM imm_file
        WHERE imm09 = p_oga01
      IF l_cnt > 0 THEN
         CALL cl_err('post=Y','mfg0175',1)
         IF NOT p_inTransaction THEN #MOD-B30430 add 
            CLOSE t600sub_cl
            ROLLBACK WORK #MOD-B30430 add
         END IF #MOD-B30430 add
         LET g_success = 'N'  #TQC-930155 add
         RETURN
      END IF
   END IF
  #MOD-B30430 mod --start--
  #IF l_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) LET g_success = 'N' RETURN END IF #CHI-A50004 add LET g_success = 'N'
   IF l_oga.oga01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
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
         CLOSE t600sub_cl
         ROLLBACK WORK 
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
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
   IF l_oga.ogaconf='N' THEN 
      CALL cl_err('conf=N','axm-154',0) 
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      LET g_success = 'N' 
      RETURN 
   END IF 
   IF l_oga.ogapost='Y' THEN 
      CALL cl_err('post=Y','mfg0175',0) 
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
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
             CLOSE t600sub_cl
             ROLLBACK WORK
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
            CLOSE t600sub_cl
            ROLLBACK WORK 
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
         CLOSE t600sub_cl
         ROLLBACK WORK 
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
                CLOSE t600sub_cl
                ROLLBACK WORK 
             END IF 
             #MOD-B30430 add --end--
             LET g_success = 'N'   #FUN-580113
             RETURN
          ELSE
             SELECT * FROM ofa_file WHERE ofa01=l_oga.oga27 AND ofaconf='Y'    
             IF STATUS=100 THEN
                CALL cl_err3("sel","ofa_file",l_oga.oga27,"",SQLCA.sqlcode,"","sel ofa:",1)  #No.FUN-670008  
                #MOD-B30430 add --start--
                IF NOT p_inTransaction THEN  
                   CLOSE t600sub_cl
                   ROLLBACK WORK 
                END IF 
                #MOD-B30430 add --end--
                LET g_success = 'N'   #FUN-580113
                RETURN
             END IF
          END IF
       END IF
    END IF
 
   IF l_oga.oga00 = "A" THEN
      #-----MOD-A70068---------
      DECLARE ogb_c2 CURSOR FOR
        SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
      FOREACH ogb_c2 INTO l_ogb.*       
         CALL t600_chk_avl_stk(l_ogb.*) 
         IF g_success='N' THEN
            #MOD-B30430 add --start--
            IF NOT p_inTransaction THEN  
               CLOSE t600sub_cl
               ROLLBACK WORK 
            END IF 
            #MOD-B30430 add --end--
            RETURN     
         END IF    
         #MOD-B10110 add --start--
         IF l_ogb.ogb19 = 'Y' THEN
            LET l_qcs091c = 0
            IF NOT cl_null(l_oga.oga011) THEN
               SELECT SUM(qcs091) INTO l_qcs091c
                 FROM qcs_file
                WHERE qcs01 = l_oga.oga011
                  AND qcs02 = l_ogb.ogb03
                  AND qcs14 = 'Y'
            END IF
            IF cl_null(l_qcs091c) OR l_qcs091c = 0 THEN
               SELECT SUM(qcs091) INTO l_qcs091c
                 FROM qcs_file
                WHERE qcs01 = l_ogb.ogb01
                  AND qcs02 = l_ogb.ogb03
                  AND qcs14 = 'Y'
            END IF

            IF l_qcs091c IS NULL THEN
               LET l_qcs091c =0
            END IF
            IF l_argv0<>"8" OR cl_null(l_argv0) THEN 
               IF l_ogb.ogb12 > l_qcs091c THEN
                  CALL cl_err(l_ogb.ogb11,'mfg3553',1) 
                  #MOD-B30430 add --start--
                  IF NOT p_inTransaction THEN  
                     CLOSE t600sub_cl
                     ROLLBACK WORK 
                  END IF 
                  #MOD-B30430 add --end--
                  LET g_success = 'N' 
                  RETURN
               END IF
            END IF
         END IF
         #MOD-B10110 add --end--
      END FOREACH   
      #-----END MOD-A70068-----
      #MOD-D10185 add start -----
      SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE ogb01 = l_oga.oga01 AND ogb04 NOT LIKE 'MISC%'
      IF l_cnt > 0 THEN
      #MOD-D10185 add end   -----
         CALL t600sub_imm(l_oga.oga01) RETURNING l_oga.oga70
         IF cl_null(l_oga.oga70) THEN
            CALL cl_err(l_oga.oga01,"axm-145",1)
            #MOD-B30430 add --start--
            IF NOT p_inTransaction THEN  
               CLOSE t600sub_cl
               ROLLBACK WORK 
            END IF 
            #MOD-B30430 add --end--
            LET g_success = 'N' #CHI-A50004 add
            RETURN
         END IF
    
         SELECT imm03 INTO l_imm03 FROM imm_file
          WHERE imm01 = l_oga.oga70
         IF l_imm03 = "Y" THEN
            LET l_oga.ogapost='Y'
            DECLARE ogb_c CURSOR FOR
              SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
            FOREACH ogb_c INTO l_ogb.*
               SELECT oeb24 INTO l_tot FROM oeb_file 
                WHERE oeb01 = l_ogb.ogb31
                  AND oeb03 = l_ogb.ogb32
               LET l_tot = l_tot+l_ogb.ogb12
               
               UPDATE oeb_file SET oeb24=l_tot
                WHERE oeb01 = l_ogb.ogb31
                  AND oeb03 = l_ogb.ogb32
   #FUN-B90104----add---begin---
   #           IF s_industry("slk") THEN     #FUN-C20006--mark
               IF s_industry("slk") AND g_azw.azw04='2' THEN    #FUN-C20006--add
                  SELECT SUM(oeb24) INTO l_oebslk24 FROM oeb_file,oebi_file
                   WHERE oeb01=oebi01
                     AND oeb03=oebi03
                     AND oeb01=l_ogb.ogb31
                     AND oebislk03 = (SELECT oebislk03 FROM oeb_file,oebi_file
                                        WHERE oebi01=oeb01
                                          AND oebi03=oeb03
                                          AND oeb01=l_ogb.ogb31
                                          AND oeb03=l_ogb.ogb32)
   
                  UPDATE oebslk_file SET oebslk24=l_oebslk24
                   WHERE oebslk01 = l_ogb.ogb31
                     AND oebslk03 =(SELECT oebislk03 FROM oebi_file,oeb_file
                                     WHERE oebi01=oeb01
                                       AND oebi03=oeb03
                                       AND oebi01=l_ogb.ogb31
                                       AND oebi03=l_ogb.ogb32)
   
               END IF
   #FUN-B90104----add---begin---
              #CHI-C90032 MARK START 
              #SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
              # WHERE ocn01 = l_oga.oga14
              #
              #LET l_ocn03 = l_ocn03-(l_oga.oga24*l_ogb.ogb14)
              #LET l_ocn04 = l_ocn04+(l_oga.oga24*l_ogb.ogb14)
              #
              #UPDATE ocn_file SET ocn03 = l_ocn03,
              #                    ocn04 = l_ocn04
              # WHERE ocn01 = l_oga.oga14
              #CHI-C90032 MARK END
               #更新已備置量 
              #FUN-AC0074--begin--modify---
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
              #END IF
              #FUN-AC0074--end--modify----
            END FOREACH
           #FUN-AC0074--begin--add----
            DECLARE t600sub_sie_c1 CURSOR FOR
              SELECT DISTINCT ogb31,ogb32 FROM ogb_file,sie_file  #TQC-B50052 add sie_file
               WHERE ogb01=l_oga.oga01
                 AND ogb31=sie05 AND ogb32=sie15 AND sie11 > 0    #TQC-B50052
            FOREACH t600sub_sie_c1 INTO l_oeb01,l_oeb03
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
                #IF l_oeb24+l_sie11 > l_oeb12 THEN   #TQC-B50052
                 IF l_oeb24+l_sie11 > (l_oeb12*((100+l_oea09)/100)+l_oeb25) THEN  #TQC-B50052
                    LET g_success = 'N'
                    CALL cl_err('','asf-881',1)
                    IF NOT p_inTransaction THEN  
                       CLOSE t600sub_cl
                       ROLLBACK WORK 
                    END IF 
                    RETURN
                 END IF
              END IF   #TQC-B50052 
            END FOREACH
           #FUN-AC0074--end--add------
         ELSE
            LET l_oga.ogapost='N'
            DELETE FROM imm_file WHERE imm01 = l_oga.oga70
            DELETE FROM imn_file WHERE imn01 = l_oga.oga70
            #FUN-B70074-add-str--
            IF NOT s_industry('std') THEN 
               LET l_flag2 = s_del_imni(l_oga.oga70,'','')
            END IF
            #FUN-B70074-add-end--
            DELETE FROM rvbs_file WHERE rvbs01 = l_oga.oga70   #MOD-AC0060
            LET l_oga.oga70 = ''
            IF l_imm03="A" THEN
               CALL cl_err ("","abm-020",1)
            END IF
         END IF
      #MOD-D10185 add start -----
      ELSE
         LET l_oga.ogapost='Y'
         DECLARE ogb_d CURSOR FOR SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
         FOREACH ogb_d INTO l_ogb.*
            SELECT oeb24 INTO l_tot FROM oeb_file
             WHERE oeb01 = l_ogb.ogb31
               AND oeb03 = l_ogb.ogb32
            LET l_tot = l_tot+l_ogb.ogb12

            UPDATE oeb_file SET oeb24=l_tot
             WHERE oeb01 = l_ogb.ogb31
               AND oeb03 = l_ogb.ogb32
         END FOREACH
      END IF
     #MOD-D10185 add start ----
      UPDATE oga_file SET ogapost=l_oga.ogapost,
                          oga70 = l_oga.oga70
       WHERE oga01=l_oga.oga01
      #MOD-B30430 add --start--
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         COMMIT WORK 
      END IF 
      #MOD-B30430 add --end--
      RETURN
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
           #MOD-B30430 mod --start--
           #CALL cl_err(l_oga.oga01,'axm-234',0) LET g_success = 'N' RETURN #CHI-A50004 add LET g_success = 'N'
            CALL cl_err(l_oga.oga01,'axm-234',0)  
            IF NOT p_inTransaction THEN  
               CLOSE t600sub_cl
               ROLLBACK WORK 
            END IF 
            LET g_success = 'N' 
            RETURN 
           #MOD-B30430 mod --end--
         END IF
      ELSE
        #MOD-B30430 mod --start--
        #CALL cl_err(l_oga.oga01,'axm-234',0) LET g_success = 'N' RETURN #CHI-A50004 add LET g_success = 'N'
         CALL cl_err(l_oga.oga01,'axm-234',0) 
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         LET g_success = 'N' 
         RETURN 
        #MOD-B30430 mod --end--
      END IF
   END IF
 
   IF NOT cl_null(l_oga.oga910) THEN #FUN-710037
      SELECT imd10,imd11,imd12 INTO l_imd10,l_imd11,l_imd12
        FROM imd_file WHERE imd01=l_oga.oga910 #FUN-710037
      #IF NOT (l_imd11 MATCHES '[Yy]') THEN
      #   CALL cl_err(l_oga.oga910,'axm-993',0) #FUN-710037
         #MOD-B30430 add --start--
      #   IF NOT p_inTransaction THEN  
      #      CLOSE t600sub_cl
      #      ROLLBACK WORK 
      #   END IF 
         #MOD-B30430 add --end--
      #   LET g_success = 'N' #CHI-A50004 add
       #  RETURN
      #END IF
      CASE
         WHEN l_oga.oga00 MATCHES '[37]' #3.出至境外倉;7.寄銷訂單
#           IF NOT (l_imd10 MATCHES '[Ss]') THEN     #MOD-B80197 mark
            IF NOT (l_imd10 MATCHES '[Ww]') THEN     #MOD-B80197
#              CALL cl_err(l_oga.oga910,'axm-063',0) #FUN-710037        #MOD-B80197 mark
               CALL cl_err(l_oga.oga910,'axm-666',0) #MOD-B80197
               #MOD-B30430 add --start--
               IF NOT p_inTransaction THEN  
                  CLOSE t600sub_cl
                  ROLLBACK WORK 
               END IF 
               #MOD-B30430 add --end--
               LET g_success = 'N' #CHI-A50004 add
               RETURN
            END IF
         OTHERWISE
 
      END CASE
      #No.FUN-AA0048  --Begin
      IF NOT s_chk_ware(l_oga.oga910) THEN
         #MOD-B30430 add --start--
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         #MOD-B30430 add --end--
         LET g_success = 'N'
         RETURN
      END IF
      #No.FUN-AA0048  --End  
   END IF
 
   IF l_oga.oga909 ='Y' THEN
      CALL t600sub_chkpoz(l_oga.*,NULL) RETURNING li_result,l_poz.*,l_oea99,l_oea904 #FUN-730012 #FUN-730012  kim:因為進去t600sub_chkpoz後,ogb31會再抓一次(確認或過帳段不會沒有單身資料),所以p_ogb31傳任何值都可
     #MOD-B30430 mod --start--
     #IF NOT li_result THEN LET g_success = 'N' RETURN END IF #FUN-730012 #CHI-A50004 add LET g_success = 'N'
      IF NOT li_result THEN 
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         LET g_success = 'N' 
         RETURN 
      END IF 
     #MOD-B30430 mod --end--
      #-----MOD-A60153--------->把出貨單拋轉的動作移至過帳後
      ##若銷售多角且正拋，則直接拋轉不扣庫存帳 #CHI-9C0009 應可直接扣庫存帳
      #IF l_argv0 = '4' AND l_poz.poz011 = '1' THEN
      #   IF g_oax.oax07 = 'Y' THEN  #出貨單 #NO.FUN-670007
      #      CALL t600sub_muticarry(l_oga.*,l_poz.*)
      #   ELSE
      #      CALL cl_err('','axm1000',1)       #NO.TQC-740112
      #   END IF
      #END IF                                   #NO.FUN-670007
      #-----END MOD-A60153-----
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
                  CALL cl_err(l_ogb11,'mfg3553',1)     #No.MOD-730004 alter mfg3558->mfg3553
                  #MOD-B30430 add --start--
                  IF NOT p_inTransaction THEN  
                     CLOSE t600sub_cl
                     ROLLBACK WORK 
                  END IF 
                  #MOD-B30430 add --end--
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
         CALL cl_err(l_oga.oga1006,'atm-255',1)
         #MOD-B30430 add --start--
         IF NOT p_inTransaction THEN  
            CLOSE t600sub_cl
            ROLLBACK WORK 
         END IF 
         #MOD-B30430 add --end--
         LET g_success='N' #FUN-730012
         RETURN
      END IF
   END IF
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012
     #MOD-B30430 mod --start--
     #IF p_cmd='2' THEN IF NOT cl_confirm('axm-152') THEN LET g_success = 'N' RETURN END IF END IF #CHI-A50004 add LET g_success = 'N'
      IF p_cmd='2' THEN 
         IF NOT cl_confirm('axm-152') THEN 
            IF NOT p_inTransaction THEN  
               CLOSE t600sub_cl
               ROLLBACK WORK 
            END IF 
            LET g_success = 'N' 
            RETURN 
         END IF 
      END IF 
     #MOD-B30430 mod --end--
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
     CALL t600_ins_lsn(l_oga.*)
   END IF
   IF g_success = 'N' THEN
      IF NOT p_inTransaction THEN
         CLOSE t600sub_cl
         ROLLBACK WORK
      END IF
      RETURN
   END IF
#FUN-BC0071 -----------------END 

   LET l_flag = '0'    #MOD-940273
   IF p_Input_oga02 THEN
      INPUT l_oga02 WITHOUT DEFAULTS FROM oga02
 
         BEFORE INPUT
            LET l_flag = '1'   #MOD-940273
            LET l_oga02 = l_oga.oga02
            DISPLAY l_oga02 TO oga02
 
         AFTER FIELD oga02
            IF NOT cl_null(l_oga02) THEN
               #IF g_prog = 'axmt628'  THEN #CHI-A30017 add  #FUN-B40066 mark
               IF g_prog[1,7] = 'axmt628'  THEN   #FUN-B40066 
                  IF l_oga02 < l_oga.oga69 THEN
                     LET l_oga02=l_oga.oga02
                     CALL cl_err('','axm-924',1)   #出貨日期不可小於輸入日期!!!
                     DISPLAY l_oga02 TO oga02
                     NEXT FIELD oga02
                  END IF
               END IF #CHI-A30017 add
               IF l_oga02 <= g_oaz.oaz09 THEN
                  CALL cl_err('','axm-164',0) NEXT FIELD oga02
               END IF
               #MOD-B50047 add --start--
               DECLARE t600_oga02 CURSOR FOR
                  SELECT ogb31
                    FROM ogb_file
                   WHERE  ogb01=l_oga.oga01
               FOREACH t600_oga02 INTO l_ogb31
                  IF NOT cl_null(l_ogb31) THEN
                     SELECT oea02 INTO l_oea02 FROM oea_file
                      WHERE oea01=l_ogb31
                     IF l_oga02 < l_oea02 THEN
                        CALL cl_err('','axm-385',0) 
                        NEXT FIELD oga02
                     END IF
                  END IF
               END FOREACH
               #MOD-B50047 add --end--
	       IF g_oaz.oaz03 = 'Y' AND
	          g_sma.sma53 IS NOT NULL AND l_oga02 <= g_sma.sma53 THEN
	          CALL cl_err('','mfg9999',0) NEXT FIELD oga02
	       END IF
               CALL s_yp(l_oga02) RETURNING l_yy,l_mm
               IF l_argv0='1' OR l_argv0='5' THEN #No.9304
                  IF ((l_yy*12+l_mm) - (g_sma.sma51*12+g_sma.sma52) >1) THEN
                     CALL cl_err('','mfg6090',0)
                     NEXT FIELD oga02
                  END IF
               ELSE
                  IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                      CALL cl_err('','mfg6090',0)
                      NEXT FIELD oga02
                  END IF
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
         IF NOT p_inTransaction THEN
            LET g_success='N'
            LET g_totsuccess='N'
            CLOSE t600sub_cl #MOD-B30430 add
            ROLLBACK WORK
         END IF
         RETURN
      END IF
   ##當不輸入扣帳日期時,預設今日為扣帳日(WHEN背景執行或外部呼叫時)
   ELSE
      IF l_oga.oga02 IS NULL OR l_oga.oga02=0 THEN
         LET l_oga.oga02=g_today
      END IF
      LET l_oga02 = l_oga.oga02

     #FUN-970017---add----str---
     #由EasyFlow按"准",出貨日期改為g_today
      IF l_agree = 'Y' THEN
         LET l_oga02 = g_today
      END IF
     #FUN-970017---add----end---
   END IF
 
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --start--
  #CALL t600sub_lock_cl()
  #OPEN t600sub_cl USING l_oga.oga01
  #IF STATUS THEN
  #   CALL cl_err("OPEN t600sub_cl:", STATUS, 1)
  #   CLOSE t600sub_cl
  #   LET g_success = 'N'   #TQC-930155 add
  #   RETURN
  #END IF
  # 
  #FETCH t600sub_cl INTO l_oga.*          # 鎖住將被更改或取消的資料
  #IF SQLCA.sqlcode THEN
  #    CALL cl_err(l_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
  #    CLOSE t600sub_cl
  #    LET g_success = 'N'   #TQC-930155 add
  #    RETURN
  #END IF
  #CHI-A50004 程式搬移至FUNCTION一開始 mark --end--
   IF l_flag = '1' THEN   #MOD-940273
      LET l_oga.oga02=l_oga02   #FUN-650009 add
   END IF   #MOD-940273
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
    CALL t600sub_s1(l_oga.*,p_cmd) RETURNING l_oha.* #FUN-9C0083  #TQC-D30060 remark
   #IF l_flag1='Y' THEN
   #   LET g_sma.sma894[2,2] = 'N'
   #END IF
   #IF sqlca.sqlcode THEN LET g_success='N' END IF
   #TQC-D30044--mark--str--
 
   IF s_industry('icd') THEN
       CALL t600sub_ind_icd_post(l_oga.oga01,'1')
   END IF
     
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

    CALL s_showmsg()  #MOD-C30250 add  清空錯誤信息前，先進行顯示
 
  #FUN-B40098 Begin---
   IF g_azw.azw04 = '2' AND g_success = 'Y' THEN
      CALL s_showmsg_init()
      CALL t620sub1_post('1',l_oga.oga01)
      CALL s_showmsg()
   END IF
  #FUN-B40098 End-----

   CALL t600sub_add_deduct(l_oga.oga01)    #FUN-BC0064  add
#  #FUN-C50136--add--str--
#  IF g_oaz.oaz96 ='Y' THEN 
#     LET g_act = 'S' 
#     CALL t600sub_hu1(l_oga.*)
#  END IF
#  #FUN-C50136--add--end--
   IF g_success = 'Y' AND p_success1='Y' THEN  #No.TQC-7C0114
      IF NOT p_inTransaction THEN   #CHI-B80001 add
         COMMIT WORK
      END IF                        #CHI-B80001 add
      CALL cl_flow_notify(l_oga.oga01,'S')
      DISPLAY BY NAME l_oga.ogapost
      #顯示代送信息
      IF l_oga.oga00 = '6' THEN
         CALL cl_err(l_oha.oha01,'atm-393',0)
         SELECT oga1012,oga1014 INTO l_oga.oga1012,l_oga.oga1014
           FROM oga_file
          WHERE oga01 = l_oga.oga01
         DISPLAY BY NAME l_oga.oga1012
         DISPLAY BY NAME l_oga.oga1014
      END IF
   ELSE
      IF NOT p_inTransaction THEN   #MOD-C70014 add 
         ROLLBACK WORK
      END IF                        #MOD-C70014 add
      LET l_oga.ogapost='N'
   END IF
   #-----MOD-A60153--------->把出貨單拋轉的動作移至過帳後
   IF l_argv0 = '4' AND l_poz.poz011 = '1' THEN
      IF g_oax.oax07 = 'Y' THEN  
         CALL t600sub_muticarry(l_oga.*,l_poz.*)
      ELSE
         CALL cl_err('','axm1000',1)     
      END IF
   END IF                                  
   #----- END MOD-A60153-----
  #MOD-B30430 mod --start--
  #IF l_argv0 = '4' AND l_poz.poz011 = '1' THEN    RETURN   END IF             #CHI-9C0009  
   IF l_argv0 = '4' AND l_poz.poz011 = '1' THEN   
      IF NOT p_inTransaction THEN  
         CLOSE t600sub_cl
         ROLLBACK WORK 
      END IF 
      RETURN   
   END IF    
  #MOD-B30430 mod --end--
   #在判斷拆併箱之前先存舊值,因拆併箱也用此變數
    LET l_success = g_success
 
#應收處理
   IF g_success ='Y' AND g_oaz.oaz63='Y' AND l_oha.oha09='1' THEN
      LET l_t1=l_oha.oha01
      LET l_t1=l_t1[1,g_doc_len]
      SELECT oay11 INTO l_oay11 FROM oay_file
       WHERE oayslip =l_t1
      IF l_oay11 ='Y' THEN
         CALL t600sub_ar(l_oha.*)   #銷退轉應收
      END IF
   END IF
   LET l_t1=s_get_doc_no(l_oga.oga01)       #No.FUN-550052
   SELECT oay11 INTO l_oay11 FROM oay_file WHERE oayslip=l_t1
 
 
   #IF g_success = 'Y' AND g_oaz.oaz62='Y' AND l_oga.oga08='1'              #MOD-C30792 mark
   IF g_success = 'Y' AND g_oaz.oaz62='Y' AND (l_oga.oga08='1'              #MOD-C30792 add
      OR (g_ooz.ooz64 = 'Y' AND l_oga.oga08 = '2' AND g_aza.aza26 = '0'))   #MOD-C30792 add
      AND l_oay11 = 'Y' AND l_oga.oga00 NOT MATCHES '[237]' THEN  #No:7664
     #FUN-970017 ----add--- if 判斷
     #當l_agree = 'Y'代表,走EasyFlow,同時具有自動確認和簽核的功能
     #所以當l_agree = 'N'時才能做交談畫面axrp310
      IF l_agree = 'N' THEN
         #CALL t600sub_gui(l_oga.*) #MOD-CA0131 add mark
#----------#MOD-CA0131 add begin #判断此时能否call cl_cmdrun_wait
         IF NOT p_inTransaction THEN
         	  CALL t600sub_gui(l_oga.*) #MOD-CA0131 add
         ELSE 
            LET g_inTransaction = 'Y'
         END IF
#----------# MOD-CA0131 add end          
      END IF
     #FUN-970017 ----end---
   END IF

#FUN-C40072---add---START
   #由簽收單串回出貨單判斷是否為多角
   LET l_oga09 = ' '
   SELECT oga09 INTO l_oga09 FROM oga_file
     WHERE oga01 = l_oga.oga011
#FUN-C40072---add-----END
 
   #No.7992 多角貿易自動拋轉
  #IF g_success = 'Y' AND l_argv0 MATCHES '[46]' THEN  #FUN-C40072 mark
   IF g_success = 'Y' AND l_argv0 MATCHES '[468]' THEN #FUN-C40072 add 8:客戶簽收單
    IF (l_poz.poz19='Y' AND l_poz.poz18=g_plant) THEN
        #設中斷點時,不執行拋轉作業
    ELSE
      CASE
         #WHEN l_argv0 = '4'                                                   #FUN-C40072 mark
         #WHEN l_argv0 MATCHES '[48]' AND l_oga.oga65 = 'N' AND l_oga09 = '4'  #FUN-C40072 add 8:客戶簽收單,l_oga09  #MOD-CB0214 mark
          WHEN (l_argv0 ='4' AND l_oga.oga65 = 'N') OR (l_argv0 ='8' AND l_oga.oga65 = 'N' AND l_oga09 = '4') #MOD-CB0214 add
             IF g_oax.oax07 = 'Y' THEN
                  CALL t600sub_muticarry(l_oga.*,l_poz.*)
                  #MOD-B30464 mark --start--
                  #SELECT oga905 INTO l_oga.oga905 FROM oga_file WHERE oga01 = p_oga01
                  #IF l_oga.oga905 <> 'Y' THEN
                  #   CALL t600_z('y')  #扣帳時,拋轉失敗要還原扣帳
                  #END IF 
                  #MOD-B30464 mark --end--
              ELSE
                  CALL cl_err('','axm1000',1)       #NO.TQC-740112
              END IF
          WHEN l_argv0 = '6'
              IF g_pod.pod05 = 'Y' THEN
                  CALL t600sub_muticarry(l_oga.*,l_poz.*)
                  #MOD-B30464 mark --start--
                  #SELECT oga905 INTO l_oga.oga905 FROM oga_file WHERE oga01 = p_oga01
                  #IF l_oga.oga905 <> 'Y' THEN
                  #   CALL t600_z('y')  #扣帳時,拋轉失敗要還原扣帳
                  #END IF 
                  #MOD-B30464 mark --end--
              ELSE
                  CALL cl_err('','axm1000',1)    #NO.TQC-740112
              END IF
      END CASE
    END IF  #CHI-7B0041- add
   END IF
 
   #DEV-D40016--add---str---
   IF g_success = 'Y' THEN
       IF g_aza.aza131 = 'Y' AND (l_oga.oga09 = '2' OR l_oga.oga09 = '3') THEN #2:一般出貨單 3:無訂單出貨單
           CALL s_ibj_ins_tlfb('abat163',l_oga.oga011,l_oga.oga01)
       END IF
   END IF
   #DEV-D40016--add---end---

   IF l_oga.ogapost = "N" THEN
 
      LET l_imm01 = ""
      LET g_success = "Y"
      LET g_totsuccess = "Y"   #MOD-9C0439
 
 
      BEGIN WORK
 
      IF g_sma.sma115 = 'Y' THEN
         DECLARE t600sub_s1_c2 CURSOR FOR SELECT * FROM ogb_file
           WHERE ogb01 = l_oga.oga01
         FOREACH t600sub_s1_c2 INTO l_ogb.*
            IF STATUS THEN
               EXIT FOREACH
            END IF
 
            SELECT ima906 INTO l_ima906 FROM ima_file  #FUN-730012
             WHERE ima01=l_ogb.ogb04                   #FUN-730012
            IF l_ima906 = '2' THEN  #子母單位          #FUN-730012
               LET l_unit_arr[1].unit= l_ogb.ogb910
               LET l_unit_arr[1].fac = l_ogb.ogb911
               LET l_unit_arr[1].qty = l_ogb.ogb912
               LET l_unit_arr[2].unit= l_ogb.ogb913
               LET l_unit_arr[2].fac = l_ogb.ogb914
               LET l_unit_arr[2].qty = l_ogb.ogb915
               CALL s_dismantle(l_oga.oga01,l_ogb.ogb03,l_oga.oga02,
                                l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                                l_ogb.ogb092,l_unit_arr,l_imm01)
                      RETURNING l_imm01
               IF g_success='N' THEN    #No.FUN-6C0083
                  LET g_totsuccess='N'
                  LET g_success="Y"
                  CONTINUE FOREACH
               END IF
            END IF
         END FOREACH
      END IF
 
      IF g_totsuccess="N" THEN    #TQC-620156
         LET g_success="N"
      END IF
 
      IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
         COMMIT WORK
         LET l_msg="aimt324 '",l_imm01,"'"
         CALL cl_cmdrun_wait(l_msg)
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   CALL s_showmsg()   #MOD-860304
 
   #在判斷拆併箱之後還原舊值,因拆併箱也用此變數
    LET g_success = l_success
 
END FUNCTION
