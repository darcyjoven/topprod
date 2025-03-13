# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Descriptions...: 整批取消確認
# Date & Author..: No.FUN-CB0094 12/11/22 By wangrr
# Modify.........: No:FUN-D80031 13/08/13 By yuhuabao aapt140取消審核判斷如果有生成待抵扣費單且 已沖帳則不可取消審核
# Modify.........: No:MOD-DA0183 13/10/28 By yinhy aapt140取消审核时，增加oob04为'3'也不可取消審核
# Modify.........: 201104  20/11/04 by lifang 参照aapt330回写直接付款类型为D:票据转付时的回写逻辑


DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_apa    RECORD LIKE apa_file.*
DEFINE m_apa    RECORD LIKE apa_file.*
DEFINE g_wc     STRING
DEFINE g_sql    STRING
DEFINE g_t1            LIKE oay_file.oayslip
DEFINE only_one        LIKE type_file.chr1
DEFINE g_plant_nm      LIKE type_file.chr21
DEFINE g_chr2          LIKE type_file.chr1

FUNCTION s_t110_unconfirm(p_aptype,p_apa01,p_apa41,p_apb06,p_apb37,p_plant)
   DEFINE p_apa01         LIKE apa_file.apa01,
          p_aptype        LIKE apa_file.apa00,  #帳款種類
          p_apa41         LIKE apa_file.apa41,
          p_apb06         LIKE apb_file.apb06,
          p_apb37         LIKE apb_file.apb37,
          p_plant         LIKE type_file.chr21
   DEFINE l_aba19         LIKE aba_file.aba19     
   DEFINE l_dbs           STRING                  
   DEFINE l_sql           STRING                     
   DEFINE l_n             LIKE type_file.num5     
   DEFINE l_amt           LIKE type_file.num10    
   DEFINE l_apa35         LIKE apa_file.apa35
   DEFINE l_apa01         LIKE apa_file.apa01
   DEFINE l_apk03         LIKE apk_file.apk03
   DEFINE l_apk11         LIKE apk_file.apk11     
   DEFINE l_apk171        LIKE apk_file.apk171    
   DEFINE l_apa41         LIKE apa_file.apa41
   DEFINE l_apc01         LIKE apc_file.apc01     
   DEFINE b_apa01         LIKE apa_file.apa01
   DEFINE b_apa41         LIKE apa_file.apa41
   DEFINE b_apa34         LIKE apa_file.apa34
   DEFINE b_apa34f        LIKE apa_file.apa34f,
          l_apk           RECORD LIKE apk_file.*,
          l_apc           RECORD LIKE apc_file.*, 
          l_apv           RECORD LIKE apv_file.*, 
          l_apa           RECORD LIKE apa_file.*, 
          l_amt1,l_amt2   LIKE type_file.num20_6, 
          l_apv04f        LIKE apv_file.apv04f,   
          l_apv04         LIKE apv_file.apv04,    
          l_cnt           LIKE type_file.num5     
   DEFINE l_cnt1          LIKE type_file.num5     
   DEFINE l_yy,l_mm       LIKE type_file.num5     
   DEFINE l_no       LIKE apy_file.apyslip 
   DEFINE l_apydmy3  LIKE apy_file.apydmy3 
   DEFINE l_poz01    LIKE poz_file.poz01   
   DEFINE l_poz18    LIKE poz_file.poz18   
   DEFINE l_poz19    LIKE poz_file.poz19   
   DEFINE l_gec05    LIKE apk_file.apk171  
   DEFINE l_net      LIKE apv_file.apv04
   DEFINE l_apa00    LIKE apa_file.apa00
   DEFINE m_aph      RECORD LIKE aph_file.*   #add by lifang 201104

   IF p_apa41<>'Y' THEN RETURN END IF
   LET g_success='Y'
   CALL s_showmsg_init()
   LET only_one = '1'
   LET g_plant_nm=p_plant
   OPEN WINDOW t110_u AT 8,18 WITH FORM "aap/42f/aapt110_u"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aapt110_u")
   CALL cl_set_head_visible("","YES") 

   INPUT BY NAME only_one WITHOUT DEFAULTS
      AFTER FIELD only_one
         IF NOT cl_null(only_one) THEN
            IF only_one NOT MATCHES "[12]" THEN
               NEXT FIELD only_one
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
      LET INT_FLAG = 0
      LET g_success = 'N'
      CLOSE WINDOW t110_u
      RETURN
   END IF
 
   IF only_one = '1' THEN
      LET g_wc = " apa01 = '",p_apa01,"' "
   ELSE
      CALL cl_set_head_visible("","YES")
      CONSTRUCT BY NAME g_wc ON apa01,apa02,apa21,apa22,apa06
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(apa01) #查詢單据
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_apa"
                  LET g_qryparam.arg1 = p_aptype
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa01
                  NEXT FIELD apa01
               WHEN INFIELD(apa06) #PAY TO VENDOR
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_pmc" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa06
               WHEN INFIELD(apa21) # Employee CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa21
               WHEN INFIELD(apa22) # Dept CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gem"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO apa22
               OTHERWISE EXIT CASE
            END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about        
            CALL cl_about()     
 
         ON ACTION HELP         
            CALL cl_show_help() 
 
         ON ACTION controlg     
            CALL cl_cmdask()    
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
            
         ON ACTION qbe_save
		    CALL cl_qbe_save()
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         LET g_success = 'N'
         CLOSE WINDOW t110_u
         RETURN
      END IF
   END IF
   
   LET l_sql="SELECT * FROM apa_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND apa00 = '",p_aptype,"'"
   #No.yinhy131113  --Begin
   IF only_one <> '1' THEN
      LET l_sql = l_sql ,"   AND apa41 = 'Y' "
   END IF
   #No.yinhy131113  --End
   PREPARE sel_apa_pr FROM l_sql
   DECLARE sel_apa_cs CURSOR FOR sel_apa_pr
   
   BEGIN WORK
   
   FOREACH sel_apa_cs INTO g_apa.*
      IF STATUS THEN
         IF only_one='1' THEN
            CALL cl_err('foreach sel_apa_cs',STATUS,1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','','foreach sel_apa_cs',STATUS,1)
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF         
      IF g_apa.apa41 = 'N' THEN
         IF only_one='1' THEN
            CALL cl_err(g_apa.apa01,'9025',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','',g_apa.apa01,'9025',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      IF g_apa.apa63 = 'S' THEN
         IF only_one='1' THEN
            CALL cl_err(g_apa.apa63,'apm-030',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','',g_apa.apa63,'apm-030',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF

      SELECT apa79 INTO g_apa.apa79 FROM apa_file WHERE apa01 =g_apa.apa01
      IF g_apa.apa79  <> '0'  THEN   
         IF only_one='1' THEN
            CALL cl_err('','aap-829',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN 
         ELSE
            CALL s_errmsg('','','','aap-829',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF  

      IF NOT cl_null(g_apa.apa99) THEN
          LET l_poz18=''
          LET l_poz19=''
          LET l_poz01=''
          LET l_sql = "SELECT poz01,poz18,poz19 FROM ",
                       cl_get_target_table(p_apb37,'pmm_file'),",",
                       cl_get_target_table(p_apb37,'poz_file'),
                      " WHERE pmm904 = poz01",
                      "   AND pmm01  = '",p_apb06,"'",
                      "   AND pmm901 = 'Y' AND pmm905 = 'Y'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,p_apb37) RETURNING l_sql 
          PREPARE sel_poz01 FROM l_sql
          EXECUTE sel_poz01 INTO l_poz01,l_poz18,l_poz19
           IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN  
              #已設立中斷點,單據可以取消確認
           ELSE 
              IF only_one='1' THEN
                 CALL cl_err('','tri-018',1)
                 ROLLBACK WORK
                 CLOSE WINDOW t110_u 
                 RETURN
              ELSE
                CALL s_errmsg('','','','tri-018',1)
                LET g_success='N'
                CONTINUE FOREACH
              END IF
           END IF 
      END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npl_file
         WHERE npl01 = g_apa.apa25
      IF l_cnt > 0 THEN
         IF only_one='1' THEN
            CALL cl_err('','aap-425',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','','','aap-425',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
 
     #str------- add by dengsy161223

     IF g_prog='aapt150' AND g_success='Y' THEN 
        CALL s_t110_upd_nmd55(g_apa.apa01,'N')
     END IF 
     #end------- add by dengsy161223
      #aapt140取消審核判斷如果有生成待抵扣費單且 已沖帳則不可取消審核
      #FUN-D80031 add --------- begin
      IF g_prog = 'aapt140' THEN
          SELECT COUNT(*) INTO l_cnt FROM oob_file
           WHERE oob06 IN (SELECT  DISTINCT oma01 from oma_file WHERE oma16 = g_apa.apa01)
             #AND oob04 = 'H'                               #MOD-DA0183
             AND (oob04 = 'H' OR oob04='3')                 #MOD-DA0183
          IF l_cnt > 0 THEN
             IF only_one='1' THEN
                CALL cl_err('','axr-631',1)
                ROLLBACK WORK
                CLOSE WINDOW t110_u
                RETURN
             ELSE
                CALL s_errmsg('','','','axr-631',1)
                LET g_success='N'
                CONTINUE FOREACH
             END IF
          ELSE
             CALL s_t110_accounted_del(g_apa.apa01)
             IF g_success = 'N' THEN
                CONTINUE FOREACH
             END IF
          END IF
       END IF
      #FUN-D80031 add --------- end

      #已有產生折讓發票,不可取消確認
      IF p_aptype MATCHES '1*' THEN   
         DECLARE apk_curs CURSOR FOR 
           SELECT apk03,apk11,apk171 FROM apk_file 
            WHERE apk01 = g_apa.apa01  
         LET l_apk03=''
         FOREACH apk_curs INTO l_apk03,l_apk11,l_apk171
            SELECT gec05 INTO l_gec05 FROM gec_file
             WHERE gec01 = l_apk11 AND gec011 = '1'
            IF (l_apk171 = '22' AND l_gec05 = '4') OR l_apk171 = 'XX' THEN
            ELSE 
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
                WHERE apb11 = l_apk03 AND apb01 = apa01  
                  AND apa00 MATCHES "2*" AND apa58 <> '1' 
               IF l_cnt > 0 THEN
                  IF only_one='1' THEN
                     CALL cl_err(l_apk03,'aap-666',1)
                     ROLLBACK WORK
                     CLOSE WINDOW t110_u 
                     RETURN
                  ELSE
                     CALL s_errmsg('','',l_apk03,'aap-666',1)
                     LET g_success='N'
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF      
         END FOREACH
      END IF  
 
      #已有沖暫估資料不可取消確認
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM api_file
        WHERE api01 = g_apa.apa01 AND api02='2'
       IF l_cnt > 0 AND p_aptype ='16' THEN
          IF only_one='1' THEN
             CALL cl_err(g_apa.apa01,'aap-140',1)
             ROLLBACK WORK
             CLOSE WINDOW t110_u 
             RETURN
          ELSE
             CALL s_errmsg('','',g_apa.apa01,'aap-140',1)
             LET g_success='N'
             CONTINUE FOREACH
          END IF
       END IF
 
      #已有沖帳之資料不可取消確認
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM aph_file,apf_file
       WHERE aph04 = g_apa.apa01 AND apf01=aph01
         AND apf41 != 'X'
         AND apflegal = g_legal  
      IF l_cnt > 0 THEN 
         IF only_one='1' THEN 
            CALL cl_err(g_apa.apa01,'agl-905',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','',g_apa.apa01,'agl-905',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
 
      #已沖暫估之資料不可取消確認
      IF g_apa.apa00 = '11' THEN
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM api_file
           WHERE api26 = g_apa.apa01
         IF l_cnt > 0 THEN
            IF only_one='1' THEN 
               CALL cl_err(g_apa.apa01,'aap-140',1)
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN
            ELSE
               CALL s_errmsg('','',g_apa.apa01,'aap-140',1)
               LET g_success='N'
               CONTINUE FOREACH
            END IF
         END IF
      END IF
 
      #帳款單號已經存在于進銷項維護作業（amd_file.amd01），
      #不能取消確認
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM amd_file
       WHERE amd01 = g_apa.apa01
      IF l_cnt > 0 THEN
         IF only_one='1' THEN 
            CALL cl_err(g_apa.apa01,'aap-188',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','',g_apa.apa01,'aap-188',1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
 
      #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原    
      CALL s_get_doc_no(g_apa.apa01) RETURNING g_t1 
      SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1                                                                           
      IF NOT cl_null(g_apa.apa44)  THEN                                                         
         IF NOT (g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y') THEN
            IF only_one='1' THEN      
               CALL cl_err(g_apa.apa01,'axr-370',1) 
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN 
            ELSE
               CALL s_errmsg('','',g_apa.apa01,'axr-370',1)
               LET g_success='N'
               CONTINUE FOREACH
            END IF           
         END IF                                                                                                                        
      END IF                                                                                                                           
      IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' THEN
         IF NOT cl_null(g_apa.apa44) THEN   
            LET g_plant_new=g_apz.apz02p 
            CALL s_getdbs()
            LET l_dbs=g_dbs_new
            LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_apz.apz02p,'aba_file'),
                        "  WHERE aba00 = '",g_apz.apz02b,"'",
                        "    AND aba01 = '",g_apa.apa44,"'"   
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
            CALL cl_parse_qry_sql(l_sql,g_apz.apz02p) RETURNING l_sql 
            PREPARE aba_pre FROM l_sql
            DECLARE aba_cs CURSOR FOR aba_pre
            OPEN aba_cs
            FETCH aba_cs INTO l_aba19
            IF l_aba19 = 'Y' THEN 
               IF only_one='1' THEN      
                  CALL cl_err(g_apa.apa44,'axr-071',1)                                                                 
                  CLOSE aba_cs 
                  ROLLBACK WORK
                  CLOSE WINDOW t110_u 
                  RETURN 
               ELSE
                  CALL s_errmsg('','',g_apa.apa44,'axr-071',1)
                  LET g_success='N'
                  CLOSE aba_cs 
                  CONTINUE FOREACH
               END IF                  
            END IF                                                                                                                        
            CLOSE aba_cs 
         END IF  
      END IF                                                                                                                           
 
      #重新抓取關帳日期
      SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
      #-->立帳日期不可小於關帳日期
      IF g_apa.apa02 <= g_apz.apz57 THEN
         IF only_one='1' THEN
            CALL cl_err(g_apa.apa01,'aap-176',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','',g_apa.apa01,'aap-176',1)
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
      END IF
      # 期末調匯(A008)
 
      IF g_apz.apz27 = 'Y' AND g_apa.apa13 != g_aza.aza17 THEN
         LET l_yy = YEAR(g_apa.apa02)
         LET l_mm = MONTH(g_apa.apa02)
         IF (l_yy*12+l_mm) - (g_apz.apz21*12+g_apz.apz22) = 0 THEN
            IF only_one='1' THEN
               CALL cl_err(l_mm,'axr-407',1)
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN
            ELSE
               CALL s_errmsg('','',l_mm,'axr-407',1)
               LET g_success='N' 
               CONTINUE FOREACH
            END IF
         END IF
      END IF
 
      #-->若有沖帳之資料不可取消確認 
      SELECT COUNT(*) INTO l_n 
        FROM apg_file ,apf_file
       WHERE apg04 = g_apa.apa01 
         AND apf01=apg01           
         AND apf00 !='11'          
         AND apf00 !='16'          
         AND apf41 != 'X' 
         AND apflegal = g_legal 
      IF l_n > 0 THEN  
         IF only_one='1' THEN
            CALL cl_err(g_apa.apa01,'agl-905',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','',g_apa.apa01,'agl-905',1)
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
      END IF
 
      #為請款折讓,不可取消確認,統一由AAPT110取消時再刪除
      IF g_apa.apa00='21' AND g_apa.apa58='1' AND g_apz.apz60 = 'Y' THEN
         IF only_one='1' THEN
            CALL cl_err('','aap-321',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
           CALL s_errmsg('','','','aap-321',1)
           LET g_success='N' 
           CONTINUE FOREACH
        END IF
      END IF
     
      #-->已付款沖帳不可取消確認
      IF g_prog <> 'aapt140' THEN   #FUN-D80031 add
      LET g_t1 = s_get_doc_no(g_apa.apa01)
      SELECT apydmy6 INTO g_apy.apydmy6 FROM apy_file WHERE apyslip = g_t1
      IF g_aza.aza26 != '2' OR p_aptype[1,1]!='2' OR g_apy.apydmy6!='Y' THEN
         IF (g_apa.apa35<>0 OR g_apa.apa35f<>0) AND g_apa.apa55!='2' THEN
            IF only_one='1' THEN
               CALL cl_err("apa41=Y",'aap-255',1)
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN
            ELSE
               CALL s_errmsg('','',"apa41=Y",'aap-255',1)
               LET g_success='N' 
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      END IF #FUN-D80031 add
     
      #-->待抵已沖帳不可取消確認
      IF g_apa.apa00 = '15' OR g_apa.apa00 = '17' THEN 
         SELECT apa35 INTO l_apa35 FROM apa_file
          WHERE apa08 = g_apa.apa01 
            AND (apa00 = '23' OR apa00 = '25') 
         IF l_apa35 > 0 THEN
            IF only_one='1' THEN
               CALL cl_err('23:apa35>0','aap-204',1)
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN
            ELSE
               CALL s_errmsg('','','23:apa35>0','aap-204',1)
               LET g_success='N' 
               CONTINUE FOREACH
            END IF
         END IF
      END IF
     
      #-->已結案不可取消確認
      IF g_apa.apa42 = 'Y' THEN
         IF only_one='1' THEN
            CALL cl_err("apa42=Y",'aap-165',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','',"apa42=Y",'aap-165',1)
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
      END IF
     
      #-->外購拋入不可取消確認
      IF g_apa.apa75 = 'Y' THEN
         IF only_one='1' THEN
            CALL cl_err("apa75=Y",'aap-333',1)
            ROLLBACK WORK
            CLOSE WINDOW t110_u 
            RETURN
         ELSE
            CALL s_errmsg('','',"apa75=Y",'aap-333',1)
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
      END IF
      IF g_aza.aza26 = '2' AND g_apa.apa00[1,1] = '1' THEN
         SELECT SUM(apv04),SUM(apv04f) INTO l_apv04,l_apv04f
         FROM apv_file WHERE apv03=g_apa.apa01
         IF cl_null(l_apv04) THEN LET l_apv04 = 0 END IF
         IF cl_null(l_apv04f) THEN LET l_apv04f = 0 END IF
         IF l_apv04 != 0 OR l_apv04f != 0 THEN
            IF only_one='1' THEN
               CALL cl_err('','aap-914',1)
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN
            ELSE
               CALL s_errmsg('','','','aap-914',1)
               LET g_success='N' 
               CONTINUE FOREACH
            END IF   
         END IF
      END IF
     
      #單身已分攤, 則不可取消確認
      LET l_cnt=0
      IF g_apa.apa00='11' THEN
         SELECT COUNT(*) INTO l_cnt FROM aqa_file,aqc_file
          WHERE aqc01 = aqa01
            AND aqc02 = g_apa.apa01
            AND aqaconf<> 'X' 
         IF SQLCA.SQLCODE <> 0 OR l_cnt IS NULL THEN
            LET l_cnt =0
         END IF
     
         IF l_cnt > 0 THEN
            IF only_one='1' THEN
               CALL cl_err("apb10<>apb101",'aap-291',1)
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN
             ELSE
               CALL s_errmsg('','',"apb10<>apb101",'aap-291',1)
               LET g_success='N' 
               CONTINUE FOREACH
            END IF 
         END IF
      END IF
     
      IF g_apa.apa00='12' OR g_apa.apa00 ='13' OR g_apa.apa00 ='16' OR
         g_apa.apa00='22' OR g_apa.apa00 ='15' OR g_apa.apa00 ='25' THEN 
         IF g_apa.apa00 = '15' THEN
            LET l_apa01 = ''
            SELECT apa01 INTO l_apa01 
              FROM apa_file
             WHERE apa08 = g_apa.apa01
               AND apa00 = '23'
     
            SELECT COUNT(*) INTO l_cnt
              FROM aqa_file,aqb_file
             WHERE aqb01 = aqa01
               AND aqb02 = l_apa01
               AND aqaconf<> 'X' 
         ELSE
            SELECT COUNT(*) INTO l_cnt
              FROM aqa_file,aqb_file
             WHERE aqb01 = aqa01
               AND aqb02 = g_apa.apa01
               AND aqaconf<> 'X' 
         END IF 
         IF SQLCA.SQLCODE <> 0 OR l_cnt IS NULL THEN
            LET l_cnt =0
         END IF
     
         IF l_cnt > 0 THEN
            IF only_one='1' THEN
               CALL cl_err("apb10<>apb101",'aap-291',1)
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN
            ELSE
               CALL s_errmsg('','',"apb10<>apb101",'aap-291',1)
               LET g_success='N' 
               CONTINUE FOREACH
            END IF 
         END IF
      END IF
     
      IF g_apa.apa00 = '16' OR g_apa.apa00 = '26' THEN
         LET l_cnt = 0 
         SELECT COUNT(*) INTO l_cnt FROM api_file
          WHERE api26 = g_apa.apa01
         IF l_cnt > 0 THEN
            IF only_one='1' THEN
               CALL cl_err(g_apa.apa01,'aap-140',1)
               ROLLBACK WORK
               CLOSE WINDOW t110_u 
               RETURN
            ELSE
              CALL s_errmsg('','',g_apa.apa01,'aap-140',1)
              LET g_success='N' 
              CONTINUE FOREACH
           END IF 
         END IF 
      END IF 
      IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' THEN
         IF NOT cl_null(g_apa.apa44) THEN
            LET l_sql="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_apa.apa44,"' 'Y'"
            CALL cl_cmdrun_wait(l_sql)
            SELECT apa44,apa43 INTO g_apa.apa44,g_apa.apa43 FROM apa_file 
             WHERE apa01 = g_apa.apa01
            #DISPLAY BY NAME g_apa.apa44  #yinhy131012
            IF NOT cl_null(g_apa.apa44) THEN
               IF only_one='1' THEN
                  CALL cl_err('','aap-929',1)
                  ROLLBACK WORK
                  CLOSE WINDOW t110_u 
                  RETURN
               ELSE
                  CALL s_errmsg('','','','aap-929',1)
                  LET g_success='N' 
               END IF 
            END IF
         END IF 
      END IF 
      
      IF g_apa.apa00[1,1] = '1' AND g_apa.apa60 > 0 THEN
         DECLARE apk_c SCROLL CURSOR FOR 
           SELECT apk01 FROM apk_file WHERE apk26=g_apa.apa01
         OPEN apk_c
         FETCH FIRST apk_c INTO l_apk.apk01
         CLOSE apk_c
     
         SELECT SUM(apk07+apk08) INTO l_apk.apk07 FROM apk_file
            WHERE apk01=l_apk.apk01
         LET l_amt2 = l_apk.apk07
     
         IF (g_apa.apa60+g_apa.apa61) = l_amt2 THEN
            DELETE FROM apa_file WHERE apa01=l_apk.apk01
            IF SQLCA.SQLCODE OR STATUS THEN
               IF only_one='1' THEN 
                  CALL cl_err3("del","apa_file",l_apk.apk01,"",SQLCA.sqlcode,"","del apa",1) 
               ELSE
                  CALL s_errmsg('apa01',l_apk.apk01,'del apa',SQLCA.sqlcode,1)
               END IF   
               LET g_success = 'N'
            END IF
            DELETE FROM apc_file WHERE apc01=l_apk.apk01
            IF SQLCA.SQLCODE OR STATUS THEN
               IF only_one='1' THEN 
                  CALL cl_err3("del","apc_file",l_apk.apk01,"",SQLCA.sqlcode,"","del apc",1)
               ELSE
                  CALL s_errmsg('apc01',l_apk.apk01,'del apc',SQLCA.sqlcode,1)
               END IF
               LET g_success = 'N'
            END IF
            DELETE FROM apb_file WHERE apb01=l_apk.apk01
            IF SQLCA.SQLCODE OR STATUS THEN
               IF only_one='1' THEN
                  CALL cl_err3("del","apb_file",l_apk.apk01,"",SQLCA.sqlcode,"","del apb",1)
               ELSE
                  CALL s_errmsg('apb01',l_apk.apk01,'del apb',SQLCA.sqlcode,1)
               END IF 
               LET g_success = 'N'
            END IF
            DELETE FROM apk_file WHERE apk01=l_apk.apk01
            IF SQLCA.SQLCODE OR STATUS THEN
               IF only_one='1' THEN
                  CALL cl_err3("del","apk_file",l_apk.apk01,"",SQLCA.sqlcode,"","del apk",1) 
               ELSE
                  CALL s_errmsg('apk01',l_apk.apk01,'del apk',SQLCA.sqlcode,1)
               END IF
               LET g_success = 'N'
            END IF
            DELETE FROM npp_file WHERE npp01=l_apk.apk01 AND nppsys='AP' AND
                                       npp00=1 AND npp011=1
            IF SQLCA.SQLCODE OR STATUS THEN
               IF only_one='1' THEN
                  CALL cl_err3("del","npp_file",l_apk.apk01,"",SQLCA.sqlcode,"","del npp",1)
               ELSE
                  CALL s_errmsg('npp01',l_apk.apk01,'del npp',SQLCA.sqlcode,1)
               END IF 
               LET g_success = 'N'
            END IF
            DELETE FROM npq_file WHERE npq01=l_apk.apk01 AND npqsys='AP' AND
                                       npq00=1 AND npq011=1
            IF SQLCA.SQLCODE OR STATUS THEN
               IF only_one='1' THEN
                  CALL cl_err3("del","npq_file",l_apk.apk01,"",SQLCA.sqlcode,"","del npq",1)
               ELSE
                  CALL s_errmsg('npq01',l_apk.apk01,'del npq',SQLCA.sqlcode,1)
               END IF    
               LET g_success = 'N'
            END IF
            DELETE FROM tic_file WHERE tic04 = l_apk.apk01
            IF STATUS THEN
               IF only_one='1' THEN
                  CALL cl_err3("del","tic_file",l_apk.apk01,"",SQLCA.sqlcode,"","del tic",1)
               ELSE
                  CALL s_errmsg('tic04',l_apk.apk01,'del tic',SQLCA.sqlcode,1)
               END IF   
               LET g_success = 'N'
            END IF 
            UPDATE apb_file SET apb16='N' WHERE apb01 = g_apa.apa01 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               IF only_one='1' THEN
                  CALL cl_err3("upd","apb_file",g_apa.apa01,"",SQLCA.sqlcode,"","upd apb",1)
               ELSE
                  CALL s_errmsg('apb01',g_apa.apa01,'upd apb',SQLCA.sqlcode,1)
               END IF    
               LET g_success = 'N'
            END IF
         END IF
     
         IF (g_apa.apa60+g_apa.apa61) < l_amt2 THEN
            LET l_net = 0
            IF g_apz.apz27 = 'Y' THEN
               SELECT SUM(oox10) INTO l_net FROM oox_file
                WHERE oox00 = 'AP' AND oox03 = l_apk.apk07
               IF cl_null(l_net) THEN LET l_net = 0 END IF
            END IF
            SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=l_apk.apk07
            IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
            
            UPDATE apa_file SET apa31f = apa31f - g_apa.apa60f,
                                apa31  = apa31  - g_apa.apa60,
                                apa32f = apa32f - g_apa.apa61f,
                                apa32  = apa32  - g_apa.apa61,
                                apa34f = apa34f - g_apa.apa60f-g_apa.apa61f,
                                apa34  = apa34  - g_apa.apa60 -g_apa.apa61 ,
                                apa35f = apa35f - g_apa.apa60f-g_apa.apa61f,
                                apa35  = apa35  - g_apa.apa60 -g_apa.apa61 ,
                                apa57  = apa57  - g_apa.apa60,
                                apa73  = apa73  - g_apa.apa60 - g_apa.apa61
                                                + l_net
             WHERE apa01 = l_apk.apk01 AND apa41 = 'Y'
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               IF only_one='1' THEN
                  CALL cl_err3("upd","apa_file",l_apk.apk01,"","app-047","","",1) 
               ELSE
                  CALL s_errmsg('apa01',l_apk.apk01,'upd apa_file','app-047',1)
               END IF 
               LET g_success = 'N'
            END IF
            UPDATE apc_file SET apc08 = apc08 - g_apa.apa60f-g_apa.apa61f,
                                apc09 = apc09 - g_apa.apa60 -g_apa.apa61 ,
                                apc10 = apc10 - g_apa.apa60f-g_apa.apa61f,
                                apc11 = apc11 - g_apa.apa60 -g_apa.apa61 ,
                                apc13 = apc13 - g_apa.apa60 -g_apa.apa61 +l_net          
             WHERE apc01 = l_apk.apk01 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               IF only_one='1' THEN
                  CALL cl_err3("upd","apc_file",l_apk.apk01,"",SQLCA.sqlcode,"","upd apc",1) 
               ELSE
                  CALL s_errmsg('apc01',l_apk.apk01,'upd apc_file',SQLCA.sqlcode,1)
               END IF 
               LET g_success = 'N'
            END IF
            DELETE FROM apb_file WHERE apb11=g_apa.apa08
            IF SQLCA.SQLCODE OR STATUS THEN
               IF only_one='1' THEN
                  CALL cl_err3("del","apb_file",g_apa.apa08,"",SQLCA.sqlcode,"","del apb",1) 
               ELSE
                  CALL s_errmsg('apb11',g_apa.apa08,'del apb',SQLCA.sqlcode,1)
               END IF    
               LET g_success = 'N'
            END IF
            DELETE FROM apk_file WHERE apk26=g_apa.apa01
            IF SQLCA.SQLCODE OR STATUS THEN
               IF only_one='1' THEN
                  CALL cl_err3("del","apk_file",g_apa.apa01,"",SQLCA.sqlcode,"","del apk",1) 
               ELSE
                  CALL s_errmsg('apk26',g_apa.apa01,'del apk',SQLCA.sqlcode,1)
               END IF  
               LET g_success = 'N'
            END IF
            LET l_no = s_get_doc_no(l_apk.apk01)
            SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip=l_no
            IF l_apydmy3 = 'Y' THEN 
               DELETE FROM npp_file WHERE npp01=l_apk.apk01 AND nppsys='AP' AND
                                          npp00=1 AND npp011=1
               IF SQLCA.SQLCODE OR STATUS THEN
                  IF only_one='1' THEN
                     CALL cl_err3("del","npp_file",l_apk.apk01,"",SQLCA.sqlcode,"","del npp",1)  
                  ELSE
                     CALL s_errmsg('npp01',l_apk.apk01,'del npp',SQLCA.sqlcode,1)
                  END IF  
                  LET g_success = 'N'
               END IF
               DELETE FROM npq_file WHERE npq01=l_apk.apk01 AND npqsys='AP' AND
                                          npq00=1 AND npq011=1
               IF SQLCA.SQLCODE OR STATUS THEN
                  IF only_one='1' THEN
                     CALL cl_err3("del","npq_file",l_apk.apk01,"",SQLCA.sqlcode,"","del npq",1) 
                  ELSE
                     CALL s_errmsg('npq01',l_apk.apk01,'del npq',SQLCA.sqlcode,1)
                  END IF    
                  LET g_success = 'N'
               END IF
               DELETE FROM tic_file WHERE tic04 = l_apk.apk01
               IF STATUS THEN
                  IF only_one='1' THEN
                     CALL cl_err3("del","tic_file",l_apk.apk01,"",SQLCA.sqlcode,"","del tic",1)
                  ELSE
                     CALL s_errmsg('tic04',l_apk.apk01,'del tic',SQLCA.sqlcode,1)
                  END IF 
                  LET g_success = 'N'
               END IF
 
               CALL t110_g_gl('21',l_apk.apk01,'0','') 
               IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                  CALL t110_g_gl('21',l_apk.apk01,'1','') 
               END IF
            END IF
            UPDATE apb_file SET apb16='N' WHERE apb01 = g_apa.apa01 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               IF only_one='1' THEN
                  CALL cl_err3("upd","apb_file",g_apa.apa01,"",SQLCA.sqlcode,"","upd apb",1) 
               ELSE
                  CALL s_errmsg('apb01',g_apa.apa01,'upd apb',SQLCA.sqlcode,1)
               END IF
               LET g_success = 'N'
            END IF
         END IF
      END IF
     
      LET m_apa.* = g_apa.*
     
      #----預付待抵刪除------------
      IF p_aptype= '15' OR p_aptype= '17' THEN 
         LET l_sql = "SELECT apc01 FROM apc_file,apa_file ",
                     " WHERE apc01 =apa01 ",
                     "   AND (apa00 = '23' OR apa00 = '25') ",
                     "   AND apa08 = '",g_apa.apa01 CLIPPED,"' "
         PREPARE s_t110_sel_p1 FROM l_sql
         DECLARE s_t110_sel_cs1 CURSOR FOR s_t110_sel_p1
         FOREACH s_t110_sel_cs1 INTO l_apc01
            DELETE FROM apc_file WHERE apc01 = l_apc01
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               IF only_one='1' THEN
                  CALL cl_err3("del","apc_file",l_apc01,"",SQLCA.sqlcode,"","del apc",1)
               ELSE
                  CALL s_errmsg('apc01',l_apc01,'del apc',SQLCA.sqlcode,1)
               END IF
               LET g_success = 'N'
            END IF
         END FOREACH
         DELETE FROM apa_file WHERE (apa00 = '23' OR apa00 = '25') AND apa08=g_apa.apa01 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            IF only_one='1' THEN
               CALL cl_err3("del","apa_file",g_apa.apa01,"",SQLCA.sqlcode,"","del apa",1) 
            ELSE
               CALL s_errmsg('apa08',g_apa.apa01,'del apa',SQLCA.sqlcode,1)
            END IF   
            LET g_success = 'N'
         END if
      END IF
     
      LET l_cnt1 = 0
      SELECT COUNT(*) INTO l_cnt1 FROM apb_file
       WHERE apb01 = g_apa.apa01 AND apb34 = 'Y'
      IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
      #----沖暫估AP刪除------------
      IF g_apa.apa51='UNAP' OR l_cnt1 > 0 OR g_apa.apa56='5' THEN 
         CALL s_t110_del_apg()
      END IF
     
      #----直接付款刪除------------
      IF g_apa.apa55='2' THEN
         DELETE FROM apf_file WHERE apf01=g_apa.apa01
         IF STATUS THEN
            IF only_one='1' THEN
               CALL cl_err3("del","apf_file",g_apa.apa01,"",STATUS,"","del apf:",1)
            ELSE
               CALL s_errmsg('apf01',g_apa.apa01,'del apf:',SQLCA.sqlcode,1)
            END IF  
            LET g_success='N'
         END IF
      END IF
     
      #----直接付款沖待抵帳款 
      IF m_apa.apa55='2' THEN
         CALL s_t110_aph_upd()
      END IF
     
      #刪除還款銀行異動記錄檔
      IF p_aptype = '13' AND g_apa.apa37f > 0 THEN
         CALL s_t110_del_nme()
      END IF
      #--add by lifang 201104 begin# 参照aapt330回写票据转付金额
      DECLARE t110_bu_cd1 CURSOR FOR
        SELECT * FROM aph_file WHERE aph01=g_apa.apa01
         AND aph03 = 'D'
       FOREACH t110_bu_cd1 INTO m_aph.*
            IF g_action_choice='undo_confirm' THEN
               CALL t110_del_nmh(m_aph.aph03,m_aph.aph04,m_aph.aph05f)
            END IF
       END FOREACH
      IF g_success='N' THEN
         CONTINUE FOREACH
      END IF
     #--add by lifang 201104 end#

      UPDATE apa_file SET apa41 = 'N',apa63 = '0'
       WHERE apa01=g_apa.apa01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         IF only_one='1' THEN
            CALL cl_err3("upd","apa_file",g_apa.apa01,"",SQLCA.sqlcode,"","upd apa",1)
         ELSE
            CALL s_errmsg('apa01',g_apa.apa01,'upd apa',SQLCA.sqlcode,1)
         END IF      
         LET g_success = 'N'
      END IF
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE WINDOW t110_u 
   IF g_success='Y' THEN
      IF p_apa01 IS NOT NULL THEN
         SELECT apa41,apa35f,apa35,apa63 
           INTO g_apa.apa41,g_apa.apa35f,g_apa.apa35,g_apa.apa63
           FROM apa_file
          WHERE apa01 = p_apa01
         DISPLAY BY NAME g_apa.apa41,g_apa.apa35f,g_apa.apa35,g_apa.apa63
         CALL s_t110_unpay()
      END IF
      SELECT * INTO g_apa.* FROM apa_file WHERE apa01 = p_apa01
      IF g_apa.apa63='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_apa.apa41,g_chr2,"","",g_apa.apa42,g_apa.apaacti)
   END IF
END FUNCTION

FUNCTION s_t110_del_apg()
   DEFINE l_api          RECORD LIKE api_file.*
   DEFINE l_amtf,l_amt   LIKE type_file.num20_6   
   DEFINE l_net          LIKE apv_file.apv04
   DEFINE l_apa00        LIKE apa_file.apa00
   
   DELETE FROM apf_file WHERE apf01=g_apa.apa80
   IF STATUS THEN
      IF only_one='1' THEN
         CALL cl_err3("del","apf_file",g_apa.apa80,"",STATUS,"","del apf:",1)
      ELSE
         CALL s_errmsg('apf01',g_apa.apa80,'del apf:',STATUS,1)
      END IF
      LET g_success='N'
   END IF
 
   DELETE FROM apg_file WHERE apg01=g_apa.apa80
   IF STATUS THEN
      IF only_one='1' THEN
         CALL cl_err3("del","apg_file",g_apa.apa80,"",STATUS,"","del apg:",1)
      ELSE
         CALL s_errmsg('apg01',g_apa.apa80,'del apg:',STATUS,1)
      END IF
      LET g_success='N'
   END IF
   UPDATE apa_file SET apa80 = '' WHERE apa01 = g_apa.apa01
   IF STATUS OR SQLCA.SQLCODE THEN
      IF only_one='1' THEN
         CALL cl_err3("upd","apa_file",g_apa.apa01,"",SQLCA.sqlcode,"","upd apc11",1) 
      ELSE
         CALL s_errmsg('apa01',g_apa.apa01,'upd apc11',SQLCA.sqlcode,1)
      END IF
      LET g_success='N'
   END if
 
   DECLARE api_del_c CURSOR FOR
     SELECT * FROM api_file 
      WHERE api01=g_apa.apa01 AND api02='2' AND api26 <> 'DIFF' 

   FOREACH api_del_c INTO l_api.*
      SELECT SUM(apg05f),SUM(apg05) INTO l_amtf,l_amt
        FROM apg_file,apf_file
       WHERE apg04=l_api.api26 AND apg01=apf01 AND apf41='Y'
 
      IF l_amtf IS NULL THEN
         LET l_amtf=0
      END IF
 
      IF l_amt  IS NULL THEN
         LET l_amt =0
      END IF

      LET l_net = 0
      IF g_apz.apz27 = 'Y' THEN
         SELECT SUM(oox10) INTO l_net FROM oox_file
          WHERE oox00 = 'AP' AND oox03 = l_api.api26
         IF cl_null(l_net) THEN LET l_net = 0 END IF
      END IF
      SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=l_api.api26
      IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
      UPDATE apa_file SET apa35f= l_amtf,
                          apa35 = l_amt,
                          apa73 = apa34 - l_amt + l_net
       WHERE apa01=l_api.api26
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         IF only_one='1' THEN
            CALL cl_err3("upd","apa_file",l_api.api26,"",SQLCA.sqlcode,"","upd apa35",1)
         ELSE
            CALL s_errmsg('apa01',l_api.api26,'upd apa35',SQLCA.sqlcode,1)
         END IF   
         LET g_success='N'
      END IF
      SELECT SUM(apg05f),SUM(apg05) INTO l_amtf,l_amt
        FROM apg_file,apf_file
       WHERE apg04=l_api.api26 AND apg01=apf01 AND apf41='Y'
         AND apg06 =l_api.api40
 
      IF l_amtf IS NULL THEN
         LET l_amtf=0
      END IF
 
      IF l_amt  IS NULL THEN
         LET l_amt =0
      END IF
 
      LET l_net = 0
      IF g_apz.apz27 = 'Y' THEN
         SELECT SUM(oox10) INTO l_net FROM oox_file
          WHERE oox00 = 'AP' AND oox03 = l_api.api26
            AND oox041 = l_api.api40
         IF cl_null(l_net) THEN LET l_net = 0 END IF
      END IF
      SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=l_api.api26
      IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
      UPDATE apc_file SET apc10 = l_amtf,
                          apc11 = l_amt,
                          apc13 = apc09 - l_amt + l_net        
       WHERE apc01=l_api.api26
         AND apc02=l_api.api40
      IF STATUS OR SQLCA.SQLCODE THEN
         IF only_one='1' THEN
            CALL cl_err3("upd","apc_file",l_api.api26,"",SQLCA.sqlcode,"","upd apc11",1)
         ELSE
            CALL s_errmsg('apc01',l_api.api26,'upd apc11',SQLCA.sqlcode,1)
         END IF
         LET g_success='N'
      END if
   END FOREACH
END FUNCTION
 
#刪除還款銀行異動記錄檔
FUNCTION s_t110_del_nme()
   DEFINE l_n     LIKE type_file.num5  
   DEFINE l_nme24      LIKE nme_file.nme24 
   DEFINE l_nma21      LIKE nma_file.nma21
   DEFINE l_nme01      LIKE nme_file.nme01
   DEFINE l_nme16      LIKE nme_file.nme16
   DEFINE l_aza73      LIKE aza_file.aza73
   
   IF g_apz.apz04 = 'N' THEN
      RETURN
   END IF

   DECLARE del_nme16_1 CURSOR FOR
    SELECT nme01,nme16 FROM nme_file
     WHERE nme12 = m_apa.apa01
   FOREACH del_nme16_1 INTO l_nme01,l_nme16
      LET l_nma21 = NULL
      SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = l_nme01
      IF l_nma21 IS NOT NULL AND l_nma21 >= l_nme16 THEN
         LET g_success='N'
         IF only_one='1' THEN
            CALL cl_err(l_nme16,'anm-225',1)
            RETURN
         ELSE
            CALL s_errmsg('','',l_nme16,'anm-225',1)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
 
   LET g_sql="SELECT aza73 FROM ",cl_get_target_table(g_plant_nm,'aza_file') 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_nm) RETURNING g_sql
   PREPARE t741_aza_p2 FROM g_sql
   DECLARE t741_aza_c2 CURSOR FOR t741_aza_p2
   OPEN t741_aza_c2
   FETCH t741_aza_c2 INTO l_aza73
   IF l_aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM ",cl_get_target_table(g_plant_nm,'nme_file'), 
                " WHERE nme12='",m_apa.apa01,"'", 
                "   AND nme22 = '02' "            
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_nm) RETURNING g_sql 
      PREPARE t110_z_nme_p2 FROM g_sql
      FOREACH t110_z_nme_p2 INTO l_nme24
         IF l_nme24 <> '9' THEN
            LET g_success='N'
            IF only_one='1' THEN
               CALL cl_err('','anm-043',1)
               RETURN
            ELSE
               CALL s_errmsg('','','','anm-043',1)
               CONTINUE FOREACH
            END IF
         END IF
      END FOREACH
   END IF 
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_nm,'tic_file'),
             " WHERE tic04 IN (",
             " SELECT nme12 FROM ",cl_get_target_table(g_plant_nm,'nme_file'),
             " WHERE nme12='",m_apa.apa01,"'",
             "   AND nme22 = '02')"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_nm) RETURNING g_sql 
   PREPARE t110_z_tic_p3 FROM g_sql
   EXECUTE t110_z_tic_p3
   IF STATUS THEN
      LET g_success='N'
      IF only_one='1' THEN
         CALL cl_err('del nme:',STATUS,1)
         RETURN
      ELSE
         CALL s_errmsg('','','del nme:',STATUS,1)
      END IF
      
   END IF

   LET g_sql =" DELETE FROM ",cl_get_target_table(g_plant_nm,'nme_file'),
              "  WHERE nme12 = '",m_apa.apa01,"' ",  
              "    AND nme22 = '02' "                
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql      
   CALL cl_parse_qry_sql(g_sql,g_plant_nm) RETURNING g_sql 
   PREPARE t110_z_nme_p3 FROM g_sql
   EXECUTE t110_z_nme_p3
   IF STATUS THEN
      LET g_success='N'
      IF only_one='1' THEN
         CALL cl_err('del nme:',STATUS,1)
         RETURN
      ELSE
         CALL s_errmsg('','','del nme:',STATUS,1)
      END IF
   END IF
 
   IF SQLCA.SQLERRD[3]=0 THEN
      LET g_success='N'
      IF only_one='1' THEN
         CALL cl_err('no nme deleted:','aap-161',1)
         RETURN
      ELSE
         CALL s_errmsg('','','no nme deleted:','aap-161',1)
      END IF
   END IF
END FUNCTION
  
FUNCTION s_t110_aph_upd()  
   DEFINE l_n     LIKE type_file.num5   
   DEFINE l_nme24      LIKE nme_file.nme24 
   DEFINE l_aza73      LIKE aza_file.aza73 
   DEFINE l_nma21      LIKE nma_file.nma21
   DEFINE l_nme01      LIKE nme_file.nme01
   DEFINE l_nme16      LIKE nme_file.nme16

   IF g_apz.apz04 = 'N' THEN
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM aph_file
    WHERE aph01=m_apa.apa01 AND aph03 IN ('2','B')  
 
   IF l_n = 0 THEN
      RETURN
   END IF

   DECLARE del_nme16 CURSOR FOR
    SELECT nme01,nme16 FROM nme_file
     WHERE nme12 = m_apa.apa01
   FOREACH del_nme16 INTO l_nme01,l_nme16
      LET l_nma21 = NULL
      SELECT nma21 INTO l_nma21 FROM nma_file WHERE nma01 = l_nme01
      IF l_nma21 IS NOT NULL AND l_nma21 >= l_nme16 THEN
         LET g_success='N'
         IF only_one='1' THEN
            CALL cl_err(l_nme16,'anm-225',1)
            RETURN
         ELSE
            CALL s_errmsg('','',l_nme16,'anm-225',1)
         END IF
      END IF
   END FOREACH
 
   LET l_n = 0 
   LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_nm,'nme_file'),
             " WHERE nme12='",m_apa.apa01,"'", 
             "   AND nme22 = '03' "             
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,g_plant_nm) RETURNING g_sql 
   PREPARE t110_x_nme_p FROM g_sql
   EXECUTE t110_x_nme_p INTO l_n
   IF l_n = 0 THEN
      RETURN
   END IF
 
   LET g_sql="SELECT aza73 FROM ",cl_get_target_table(g_plant_nm,'aza_file') 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
     CALL cl_parse_qry_sql(g_sql,g_plant_nm) RETURNING g_sql 
   PREPARE t741_aza_p1 FROM g_sql
   DECLARE t741_aza_c1 CURSOR FOR t741_aza_p1
   OPEN t741_aza_c1
   FETCH t741_aza_c1 INTO l_aza73
   IF l_aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM ",cl_get_target_table(g_plant_nm,'nme_file'), 
                " WHERE nme12='",m_apa.apa01,"'",  
                "   AND nme22 = '03' "            
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
      CALL cl_parse_qry_sql(g_sql,g_plant_nm) RETURNING g_sql 
      PREPARE t110_z_nme_p1 FROM g_sql
      FOREACH t110_z_nme_p1 INTO l_nme24
         IF l_nme24 <> '9' THEN
            LET g_success='N'
            IF only_one='1' THEN
               CALL cl_err('','anm-043',1)
               RETURN
            ELSE
               CALL s_errmsg('','','','anm-043',1)
            END IF
         END IF
      END FOREACH
   END IF 

   IF g_nmz.nmz70 ='1' THEN 
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_nm,'tic_file'),
                " WHERE tic04 in (",
                " SELECT nme12 FROM ",cl_get_target_table(g_plant_nm,'nme_file'),
                " WHERE nme12='",m_apa.apa01,"'",
                "   AND nme22 = '03')"
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
      PREPARE t110_z_tic_p FROM g_sql
      EXECUTE t110_z_tic_p
      IF STATUS THEN
         LET g_success='N'
         IF only_one='1' THEN
            CALL cl_err('del tic:',STATUS,1)
            RETURN
         ELSE
            CALL s_errmsg('','','del tic:',STATUS,1)
         END IF
      END IF
   END IF  

   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_nm,'nme_file'), 
             " WHERE nme12='",m_apa.apa01,"'", 
             "   AND nme22 = '03' "            
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
   CALL cl_parse_qry_sql(g_sql,g_plant_nm) RETURNING g_sql 
   PREPARE t110_z_nme_p FROM g_sql
 
   EXECUTE t110_z_nme_p
 
   IF STATUS THEN
      LET g_success='N'
      IF only_one='1' THEN
         CALL cl_err('del nme:',STATUS,1)
         RETURN
      ELSE
         CALL s_errmsg('','','del nme:',STATUS,1)
      END IF
   END IF
 
   IF SQLCA.SQLERRD[3]=0 THEN
      LET g_success='N'
      IF only_one='1' THEN
         CALL cl_err('no nme deleted:','aap-161',1)
         RETURN
      ELSE
         CALL s_errmsg('','','no nme deleted:','aap-161',1)
      END IF
   END IF
   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM aph_file
    WHERE aph01 = m_apa.apa01 AND aph09 = 'Y'
 
   IF l_n > 0 THEN
      LET g_success = 'N'
      IF only_one='1' THEN 
         CALL cl_err(m_apa.apa01,'aap-228',1)
      ELSE
         CALL s_errmsg('','',m_apa.apa01,'aap-228',1)
      END IF
   END IF
 
END FUNCTION

FUNCTION s_t110_unpay()
   DEFINE l_unpay1,l_unpay2   LIKE type_file.num20_6   
   DEFINE l_net               LIKE type_file.num20_6   
 
   LET l_unpay1 = g_apa.apa34f - g_apa.apa35f
   LET l_unpay2 = g_apa.apa34  - g_apa.apa35
   DISPLAY l_unpay1 TO apa35_uf
   DISPLAY l_unpay2 TO apa35_u
 
   IF g_apz.apz27 = 'Y' THEN
      SELECT SUM(oox10) INTO l_net FROM oox_file
       WHERE oox00 = 'AP' AND oox03 = g_apa.apa01
      IF cl_null(l_net) THEN
         LET l_net = 0
      END IF
      DISPLAY l_net TO net
   END IF
END FUNCTION

#FUN-D80031 add --------- begin
FUNCTION s_t110_accounted_del(p_apa01)
DEFINE  p_apa01      LIKE apa_file.apa01
DEFINE  l_apb RECORD LIKE apb_file.*
DEFINE  l_oma RECORD LIKE oma_file.*
   IF g_success ='N' THEN RETURN END IF

   DELETE FROM omc_file WHERE omc01 IN (SELECT DISTINCT oma01 FROM oma_file WHERE oma16=p_apa01)
   IF STATUS THEN
      CALL s_errmsg('','','del omc',STATUS,1)
      LET g_success ='N'
   END IF
   DELETE FROM oma_file WHERE oma16 = p_apa01
   IF STATUS THEN
      CALL s_errmsg('','','del oma',STATUS,1)
      LET g_success = 'N'
   END IF
   UPDATE apa_file SET apa35f = 0,apa35 =0
    WHERE apa01 = p_apa01
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL s_errmsg('','','upd apa',STATUS,1)
      LET g_success = 'N'
   END IF
END FUNCTION
#FUN-D80031 add --------- end
#FUN-CB0094---end

#str------- add by dengsy161223

FUNCTION s_t110_upd_nmd55(p_apa01,p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          p_apa01    LIKE apa_file.apa01,
          l_aph01    LIKE aph_file.aph01,
          l_aph02    LIKE aph_file.aph02,
          l_aph04    LIKE aph_file.aph04,
          l_aph05f   LIKE aph_file.aph05f,
          l_apf02    LIKE apf_file.apf02,
          l_sql      STRING

   LET l_sql="SELECT aph02,aph04,aph05f FROM aph_file ",
             " WHERE aph01='",p_apa01,"'",
             "   AND aph03='F'"
   PREPARE sel_aph_pr FROM l_sql
   DECLARE sel_aph_cr CURSOR FOR sel_aph_pr
   FOREACH sel_aph_cr INTO l_aph02,l_aph04,l_aph05f
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      IF p_cmd='Y' THEN
         UPDATE nmd_file SET nmd55=nmd55+l_aph05f,
                             nmd10=p_apa01,
                             nmd101=l_aph02
         WHERE nmd01=l_aph04
      ELSE
         #判斷該支票是否用於多次付款，如果沒有更新付款單號和項次為NULL，
         #否則更新為日期除此單號最大付款日期的單號和項次
         LET l_apf02=NULL
         SELECT MAX(apf02) INTO l_apf02 FROM apf_file,aph_file
          WHERE apf01=aph01 AND aph04=l_aph04
            AND apf41='Y'   AND apf01<> p_apa01
         IF cl_null(l_apf02) THEN
            UPDATE nmd_file SET nmd55=nmd55-l_aph05f,
                                nmd10=NULL,
                                nmd101=NULL
            WHERE nmd01=l_aph04
         ELSE
            SELECT aph01,aph02 INTO l_aph01,l_aph02 FROM apf_file,aph_file
            WHERE apf01=aph01 AND aph04=l_aph04 AND apf02=l_apf02
              AND apf41='Y'   AND apf01<> p_apa01
            UPDATE nmd_file SET nmd55=nmd55-l_aph05f,
                                nmd10=l_aph01,
                                nmd101=l_aph02
            WHERE nmd01=l_aph04
         END IF
      END IF
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","nmd_file",l_aph04,"",STATUS,"","",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#end------- add by dengsy161223
#--add by lifang 201104 begin#
FUNCTION t110_del_nmh(p_aph03,p_aph04,p_aph05f)
    DEFINE l_nmh42    LIKE  nmh_file.nmh42
    DEFINE p_aph03    LIKE aph_file.aph03
    DEFINE p_aph04    LIKE aph_file.aph04
    DEFINE p_aph05f   LIKE aph_file.aph05f

   IF p_aph03 != 'D' THEN RETURN END IF

   SELECT nmh42 INTO l_nmh42
     FROM nmh_file
    WHERE nmh01 = p_aph04

   IF cl_null(l_nmh42) THEN LET l_nmh42 = 0 END IF

   UPDATE nmh_file SET nmh42 = l_nmh42 - p_aph05f
    WHERE nmh01 = p_aph04
     IF STATUS THEN
        CALL s_errmsg('nmh01',p_aph04,'upd nmh42',STATUS,1)              #NO.FUN-710050
        LET g_success = 'N'
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmh01',p_aph04,'upd nmh42','axr-198',1) LET g_success = 'N' RETURN      #NO.FUN-710050
     END IF
END FUNCTION
#--add by lifang 201104 end#

