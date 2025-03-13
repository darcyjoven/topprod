# Prog. Version..: '5.30.07-13.05.16(00003)'     #
#
# Pattern name...: s_t300_undoconf.4gl
# Descriptions...: 整批取消审核
# Date & Author..: No.FUN-CB0094 12/11/21 By minpp
# Modify.........: NO.TQC-D20010 13/02/18 By minpp 整批取消审核时不需要去check当前笔是否已审核
# Modify.........: No.FUN-D40089 13/04/23 By zhangweib 批次審核的報錯,加show單據編號
# Modify.........: No.MOD-D80127 13/08/20 By yinhy s_t300_omc_check 函数增加传参 
# Modify.........: No.MOD-D90076 13/11/04 By yinhy 更新oma_file錯誤
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_oma     RECORD LIKE oma_file.*
DEFINE g_oma01    LIKE oma_file.oma01
DEFINE only_one   LIKE type_file.chr1
DEFINE g_str      STRING
DEFINE g_sql      STRING
DEFINE g_t1       LIKE oay_file.oayslip
DEFINE i          LIKE type_file.num5      
DEFINE g_chr2     LIKE type_file.chr2

FUNCTION s_t300_undoconf(p_oma01)                        # when g_oma.omaconf='Y' (Turn to 'N')
 DEFINE l_n,l_cnt LIKE type_file.num5   #No.FUN-680123  SMALLINT
 DEFINE l_oga909   LIKE oga_file.oga909  #三角貿易否
 DEFINE l_yy,l_mm  LIKE type_file.num5   #No.FUN-680123 SMALLINT
 DEFINE l_oov04f   LIKE oov_file.oov04f  #FUN-590100
 DEFINE l_oov04    LIKE oov_file.oov04   #FUN-590100
 DEFINE l_cnt2     LIKE type_file.num5   #No.FUN-680123 SMALLINT    #MOD-5A0318
 DEFINE l_aba19    LIKE aba_file.aba19   #No.FUN-670060
 DEFINE l_dbs      STRING                #No.FUN-670060
 DEFINE l_sql      STRING                #No.FUN-670060
 DEFINE l_poz01    LIKE poz_file.poz01   
 DEFINE l_poz18    LIKE poz_file.poz18   
 DEFINE l_poz19    LIKE poz_file.poz19   
 DEFINE l_oaz92    LIKE oaz_file.oaz92    
 DEFINE l_wc       STRING  
 DEFINE l_omb      RECORD LIKE omb_file.*
 DEFINE p_oma01    LIKE oma_file.oma01
 DEFINE li_dbs     STRING 
 DEFINE l_omaconf  LIKE oma_file.omaconf

   WHENEVER ERROR CONTINUE
   #TQC-D20010---MARK--STR
   #查詢當前筆是否審核，未審核不可取消審核
   #SELECT omaconf  INTO l_omaconf FROM oma_file WHERE oma01 = p_oma01
   #IF l_omaconf <> 'Y' THEN
   #   CALL cl_err('','9025',0)
   #   RETURN
   #END IF
   #TQC-D20010---mark--end
   LET g_success = 'Y'
   LET only_one = '1' 
    
    OPEN WINDOW t300_w5 WITH FORM "axr/42f/axrt300_5" ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_locale("axrt300_5")
 
      LET only_one = '1'

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
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW t300_w5
         RETURN
      END IF
 
   IF only_one = '1' THEN
      LET l_wc = " oma01 = '",p_oma01,"' "
   ELSE
      CONSTRUCT BY NAME l_wc ON oma01,oma02,oma03

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oma01)
                  LET g_qryparam.state = 'c' 
                  LET g_qryparam.plant = g_plant 
                  CALL q_oma(TRUE,TRUE,p_oma01,'','')  
                  RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oma01
               WHEN INFIELD(oma03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oma03
                  NEXT FIELD oma03
               OTHERWISE EXIT CASE
            END CASE
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
         
         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         LET g_success = 'N'
         CLOSE WINDOW t300_w5
         RETURN
      END IF
   END IF 

   IF NOT cl_confirm('axr-109') THEN   #是否進行取消確認
      LET g_success = 'N'
      CLOSE WINDOW t300_w5   #FUN-530061
      RETURN
   END IF

    CALL cl_msg("WORKING !")                              #FUN-640246
 
    LET l_sql = "SELECT * FROM oma_file",
                " WHERE ",l_wc CLIPPED,   
                "   AND omaconf = 'Y' AND omavoid !='Y'"
    PREPARE t300_undo_p1 FROM l_sql
    DECLARE t300_undo_cs CURSOR WITH HOLD FOR t300_undo_p1
    
    LET g_success='Y'
    BEGIN WORK
   
    FOREACH t300_undo_cs INTO g_oma.*    #逐筆取消審核
       #單身無資料不可取消審核
       #SELECT * INTO l_omb.* FROM omb_file WHERE omb01 = p_oma01 AND omb03='1'    #TQC-D20010
       #IF STATUS THEN EXIT FOREACH END IF                                         #TQC-D20010
       IF g_success='N' THEN 
          LET g_totsuccess='N'                                                                                           
          LET g_success="Y"                                                                                                          
      END IF  
      IF NOT cl_null(g_oma.oma992) THEN
         IF only_one = '1' THEN
            CLOSE WINDOW t300_w5 
            CALL cl_err('','axr-950',1)
            LET g_success='N'
            ROLLBACK WORK
            RETURN
         ELSE
            CALL s_errmsg('','','','axr-950',1)  
            LET g_success='N'   
         END IF   
      END IF
 
      IF g_oma.oma70 = '1'  THEN
         IF only_one = '1' THEN 
            CLOSE WINDOW t300_w5
            CALL cl_err('','aap-829',0) 
            ROLLBACK WORK
            RETURN
         ELSE
            CALL s_errmsg('','','','aap-829',1)  
            LET g_success='N'   
         END IF     
      END IF

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt  FROM amd_file
       WHERE amd01 = g_oma.oma01
         AND amd021 = '3'  
      IF l_cnt > 0  THEN
         IF only_one = '1' THEN 
            CLOSE WINDOW t300_w5
            CALL cl_err('','amd-030',0) 
            ROLLBACK WORK
            RETURN
         ELSE
            CALL s_errmsg('','','','amd-030',1)  
            LET g_success='N'   
         END IF      
      END IF


      IF g_oma.oma64 = "S" THEN
         IF only_one = '1' THEN
            CLOSE WINDOW t300_w5 
            CALL cl_err("","mfg3557",0)
            LET g_success='N'
            ROLLBACK WORK
            RETURN
         ELSE
            CALL s_errmsg('','','','mfg3557',1)  
            LET g_success='N'   
         END IF       
      END IF 

      IF g_oma.oma70 ='1'  THEN
         IF only_one = '1' THEN
            CLOSE WINDOW t300_w5 
            CALL cl_err("","alm-119",0)
            ROLLBACK WORK
            LET g_success='N'
            RETURN
         ELSE
            CALL s_errmsg('','','','alm-119',1)  
            LET g_success='N'   
         END IF          
      END IF         

      IF g_oma.oma00 = '24' THEN
     #由axrt400產生的溢收單應不可作確認取消
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM ooa_file
          WHERE ooa01 = g_oma.oma16
         IF l_cnt > 0 THEN
            IF only_one = '1' THEN
               CLOSE WINDOW t300_w5
               CALL cl_err('','axr-010',0)  
               ROLLBACK WORK
               LET g_success='N'
               RETURN
            ELSE
               CALL s_errmsg('','','','axr-010',1)  
               LET g_success='N'   
            END IF      
         END IF
     #由anmt302產生的暫收單應不可作確認取消
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM nmg_file
          WHERE nmg00 = g_oma.oma01
         IF l_cnt > 0 THEN
            IF only_one = '1' THEN
               CLOSE WINDOW t300_w5
               CALL cl_err(g_oma.oma01,'axr-327',0)
               ROLLBACK WORK
               LET g_success='N'
               RETURN
            ELSE
               CALL s_errmsg('','','','axr-010',1)  
               LET g_success='N'   
            END IF         
         END IF
      END IF
      SELECT COUNT(*) INTO l_cnt2 FROM ooa_file,oob_file
       WHERE ooa01=oob01 AND oob06=g_oma.oma01 AND ooaconf<>'X'
         AND ooa00 != '2'        #No.TQC-5B0080
      IF l_cnt2 > 0 THEN
         IF only_one = '1' THEN
            CLOSE WINDOW t300_w5
            CALL cl_err('','axr-014',0)
            ROLLBACK WORK
            RETURN
         ELSE
            CALL s_errmsg('','','','axr-014',1)  
            LET g_success='N'   
         END IF           
      END IF
      SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = g_oma.oma01
      IF g_oma.omaconf='N' THEN RETURN END IF

      #重新抓取關帳日期
      SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
      IF g_oma.oma02<=g_ooz.ooz09 THEN
         IF only_one = '1' THEN
            CLOSE WINDOW t300_w5
            CALL cl_err('','axr-164',0)
            LET g_success='N'
            ROLLBACK WORK
            RETURN
         ELSE
            CALL s_errmsg('','','','axr-164',1)  
            LET g_success='N'  
         END IF    
      END IF
      IF g_ooz.ooz07 = 'Y' AND g_oma.oma23 != g_aza.aza17 THEN
         CALL s_yp(g_oma.oma02) RETURNING l_yy,l_mm
         SELECT COUNT(*) INTO l_cnt FROM oox_file WHERE (oox01*12+oox02) >=(l_yy*12+l_mm)
                                                    AND oox03 =g_oma.oma01
         IF l_cnt >0 THEN
            IF only_one = '1' THEN
               CLOSE WINDOW t300_w5
               CALL cl_err(l_mm,'axr-407',0)
               LET g_success='N'
               ROLLBACK WORK
               RETURN
            ELSE
               CALL s_errmsg('','l_mm','','axr-407',1)  
               LET g_success='N' 
            END IF 
         END IF
      END IF

      SELECT oaz92 INTO l_oaz92 FROM oaz_file 
      IF l_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
      ELSE
         IF g_ooz.ooz20 = 'Y' THEN    #MOD-840129
            IF (g_aza.aza26='2' AND g_oma.oma00='21' AND NOT cl_null(g_oma.oma10)) OR
               ( (g_oma.oma00 MATCHES '1*' OR g_oma.oma00='31') AND #No:8519
               (g_oma.oma10 IS NOT NULL AND g_oma.oma10 !=' ')) THEN #已開發票不可取消確認
               IF only_one = '1' THEN
                  CLOSE WINDOW t300_w5
                  CALL cl_err(g_oma.oma10,'axr-904',0)
                  LET g_success='N'
                  ROLLBACK WORK
                  RETURN
               ELSE
                  CALL s_errmsg('','g_oma.oam10','','axr-904',1)  
                  LET g_success='N'  
               END IF   
            END IF
         END IF   #MOD-840129
      END IF  #FUN-C60033
      SELECT COUNT(*) INTO l_cnt FROM oot_file WHERE oot03 = g_oma.oma01
      SELECT oma65 INTO g_oma.oma65 FROM oma_file WHERE oma01=g_oma.oma01
      IF g_aza.aza26 != '2' OR g_oma.oma00[1,1]!='2' OR g_ooy.ooydmy2!='Y' THEN
         IF g_oma.oma65 != '2' AND l_cnt=0 AND  #FUN-570099 若是直接收款，則不需考慮
            g_oma.oma55 != 0 AND g_oma.oma00!='31' THEN   #No:8519
            IF only_one = '1' THEN 
               CLOSE WINDOW t300_w5
               CALL cl_err(g_oma.oma01,'axr-160',0)
               LET g_success='N'
               ROLLBACK WORK
               RETURN
            ELSE
               CALL s_errmsg('','g_oma.oam10','','axr-160',1)  
               LET g_success='N'  
            END IF          
         END IF
      END IF
 
   #只要是多角貿易皆不可取消確認
      IF NOT cl_null(g_oma.oma99) THEN
         LET l_poz18=''
         LET l_poz19=''
         LET l_poz01=''
         LET li_dbs = ''    
         IF NOT cl_null(l_omb.omb44) THEN
            LET g_plant_new = l_omb.omb44
         ELSE  
            LET g_plant_new = g_plant
         END IF 

         IF g_oma.oma00 MATCHES '1*' THEN
            LET g_sql = " SELECT poz01,poz18,poz19",
                        "   FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
                                   cl_get_target_table(g_plant_new,'oea_file'),",", #FUN-A50102
                                   cl_get_target_table(g_plant_new,'poz_file'),      #FUN-A50102
                        "  WHERE oea904 = poz01",
                        "    AND ogb31 = oea01",
                        "    AND ogb01  = '",l_omb.omb31,"'",
                        "    AND ogb03  = '",l_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
            PREPARE sel_poz_pre84 FROM g_sql
            EXECUTE sel_poz_pre84 INTO l_poz01,l_poz18,l_poz19
         ELSE
            IF g_oma.oma00 MATCHES '2*' THEN
               LET g_sql = " SELECT poz01,poz18,poz19",
                           "   FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",", #FUN-A50102
                                      cl_get_target_table(g_plant_new,'oea_file'),",", #FUN-A50102
                                      cl_get_target_table(g_plant_new,'poz_file'),      #FUN-A50102
                           "  WHERE oea904 = poz01",
                           "    AND ohb33 = oea01",
                           "    AND ohb01  = '",l_omb.omb31,"'",
                           "    AND ohb03  = '",l_omb.omb32,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
               PREPARE sel_poz_pre85 FROM g_sql
               EXECUTE sel_poz_pre85 INTO l_poz01,l_poz18,l_poz19
            END IF
         END IF
         IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN  
          #已設立中斷點,單據可以取消確認
         ELSE 
            IF only_one = '1' THEN
               CLOSE WINDOW t300_w5 
               CALL cl_err3("sel","oga_file",g_oma.oma16,"","axr-373","","",1)  #No.FUN-660116
               ROLLBACK WORK
               RETURN
            ELSE
               CALL s_errmsg('','g_oma.oam16','','axr-373',1)  
               LET g_success='N'  
            END IF    
         END IF  #TQC-830007 add
      END IF
   #已有銷項發票底稿資料(不為作廢)時,則不可取消確認
      IF g_aza.aza26 = '2' AND g_aza.aza47 = 'Y' THEN
         SELECT COUNT(*) INTO l_cnt
           FROM isa_file
          WHERE isa04 = g_oma.oma01
            AND isa07 != 'V'
         IF l_cnt > 0 THEN
            IF only_one = '1' THEN
               CLOSE WINDOW t300_w5
               CALL cl_err(g_oma.oma01,'axr-016',1)
               ROLLBACK WORK
               RETURN
            ELSE
               CALL s_errmsg('','g_oma.oma01','','axr-016',1)  
               LET g_success='N'  
            END IF   
         END IF
      END IF
 
      LET l_cnt = 0 
      SELECT COUNT(*) INTO l_cnt FROM npn_file
       WHERE npn01 = g_oma.oma16
      IF l_cnt > 0 THEN
         IF only_one = '1' THEN
            CLOSE WINDOW t300_w5
            CALL cl_err('','aap-425',0)
            ROLLBACK WORK
            RETURN
         ELSE
            CALL s_errmsg('','','','aap-425',1)  
            LET g_success='N'   
         END IF   
      END IF 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
      CALL s_get_doc_no(g_oma.oma01) RETURNING g_t1
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
      IF NOT cl_null(g_oma.oma33) THEN
         IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
            IF only_one = '1' THEN
               CLOSE WINDOW t300_w5
               CALL cl_err(g_oma.oma01,'axr-370',0) 
               ROLLBACK WORK
               RETURN
            ELSE
               CALL s_errmsg('','g_oma.oma01','','axr-370',1)  
               LET g_success='N'   
            END IF   
         END IF
      END If
      IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
         LET g_plant_new=g_ooz.ooz02p CALL s_getdbs() LET l_dbs=g_dbs_new
         LET l_dbs=l_dbs.trimRight()                                                                                                    
         LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                     "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                     "    AND aba01 = '",g_oma.oma33,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102 
         PREPARE aba_pre FROM l_sql
         DECLARE aba_cs CURSOR FOR aba_pre
         OPEN aba_cs
         FETCH aba_cs INTO l_aba19
         IF l_aba19 = 'Y' THEN
            IF only_one = '1' THEN
               CLOSE WINDOW t300_w5
               CALL cl_err(g_oma.oma33,'axr-071',0)
               ROLLBACK WORK
               RETURN
            ELSE
               CALL s_errmsg('','','g_oma.oma33','axr-071',1)  
               LET g_success='N'   
            END IF    
         END IF
      END IF

      CALL s_ar_conf('z',g_oma.oma01,'') RETURNING i 
      CALL s_get_doc_no(g_oma.oma01) RETURNING g_t1
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
      CALL s_t300_w1('-',g_oma.oma01)           
      #CALL s_t300_omc_check()              #MOD-D80127 mark
      CALL s_t300_omc_check(g_oma.oma01)    #MOD-D80127 
      IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN
         CALL s_t300_del_oct(g_oma.oma00,g_oma.oma01,'0') RETURNING i
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_t300_del_oct(g_oma.oma00,g_oma.oma01,'1') RETURNING i
         END IF
      END IF
      IF i = 0  AND g_success = 'Y' THEN
         LET g_oma.omaconf = 'N'
         LET g_oma.oma64 = "0"
         #UPDATE oma_file SET oma64 = g_oma.oma64 , omaconf = g_oma.oma64  WHERE oma01 = g_oma.oma01    #MOD-D90076 mark
         UPDATE oma_file SET oma64 = g_oma.oma64 , omaconf = g_oma.omaconf  WHERE oma01 = g_oma.oma01   #MOD-D90076
         IF STATUS THEN
            LET g_success = 'N'
         END IF
      END IF
      SELECT oma65 INTO g_oma.oma65 FROM oma_file WHERE oma01=g_oma.oma01  #No.TQC-7B0165
      IF g_oma.oma65='2' THEN
         CALL s_t300_unconfirm(g_oma.oma01)
      END IF
      #IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
      IF g_success = 'N' THEN CONTINUE FOREACH END IF
 
      IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
         LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_oma.oma33,"' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT oma33 INTO g_oma.oma33 FROM oma_file
          WHERE oma01 = g_oma.oma01
      END IF
   END FOREACH
   IF g_action_choice CLIPPED = "undo_confirm" THEN CLOSE WINDOW t300_w5 END IF
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF 
END FUNCTION

#FUNCTION s_t300_omc_check()             #MOD-D80127 mark
FUNCTION s_t300_omc_check(p_oma01)       #MOD-D80127
   DEFINE l_sql     STRING    
   DEFINE l_amt     LIKE omc_file.omc08
   DEFINE l_amtf    LIKE omc_file.omc09    
   DEFINE l_sum,l_sumf  LIKE  omc_file.omc08     
   DEFINE p_oma01       LIKE  oma_file.oma01   #MOD-D80127
   DEFINE l_omc     DYNAMIC ARRAY OF RECORD   
          omc02 LIKE omc_file.omc02,
          omc08 LIKE omc_file.omc08,
          omc09 LIKE omc_file.omc09,
          omc10 LIKE omc_file.omc10,
          omc11 LIKE omc_file.omc11,
          omc13 LIKE omc_file.omc13
          END RECORD
   DEFINE l_cnt     LIKE type_file.num10
 
   CALL l_omc.clear()
   LET l_cnt =1
   
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = p_oma01    #MOD-D80127
 
   LET l_sql ="SELECT omc02,omc08,omc09,omc10,omc11,omc13",
      "  FROM omc_file",
      " WHERE omc01 = ?",
      " ORDER BY omc02"
   PREPARE s_t300_omc_p FROM l_sql                                                                                                       
   DECLARE s_omc_curs_c CURSOR FOR s_t300_omc_p
 
   LET l_sumf =0
   LET l_sum =0
   SELECT oma55,oma57 INTO l_amtf,l_amt FROM oma_file
     WHERE oma01=g_oma.oma01
   UPDATE omc_file SET omc10=0,omc11=0,omc13=0 WHERE omc01=g_oma.oma01
   FOREACH s_omc_curs_c USING g_oma.oma01 INTO l_omc[l_cnt].* 
      IF SQLCA.sqlcode THEN       
        #CALL cl_err('foreach:',SQLCA.sqlcode,1)     #No.FUN-D40089   Mark
        #No.FUN-D40089 ---add--- str
         IF g_bgerr THEN
            CALL s_errmsg('oma01',g_oma.oma01,"",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
         END IF
        #No.FUN-D40089 ---add--- end
         LET g_success='N'
         EXIT FOREACH                                         
      END IF      
      IF cl_null(l_omc[l_cnt].omc08) THEN
         LET l_omc[l_cnt].omc08 =0
      END IF
      IF cl_null(l_omc[l_cnt].omc09) THEN
         LET l_omc[l_cnt].omc09 =0
      END IF
      IF cl_null(l_omc[l_cnt].omc10) THEN
         LET l_omc[l_cnt].omc10 =0
      END IF
      IF cl_null(l_omc[l_cnt].omc11) THEN
         LET l_omc[l_cnt].omc11 =0
      END IF
      IF cl_null(l_omc[l_cnt].omc13) THEN
         LET l_omc[l_cnt].omc13 =0
      END IF
      LET l_sumf=l_sumf+ l_omc[l_cnt].omc08
      LET l_sum =l_sum + l_omc[l_cnt].omc09
      IF l_amtf <= l_omc[l_cnt].omc08 THEN   
         UPDATE omc_file SET omc10=l_amtf,
                             omc11=l_amt,
                             omc13=l_omc[l_cnt].omc09-l_amt
          WHERE omc01 = g_oma.oma01
            AND omc02 = l_omc[l_cnt].omc02
         IF SQLCA.sqlcode THEN
            IF only_one = '1' THEN
              #CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc[l_cnt].omc02,SQLCA.sqlcode,"","",1)  #No.FUN-D40089   Mark 
              #No.FUN-D40089 ---add--- str
               IF g_bgerr THEN
                  CALL s_errmsg('oma01',g_oma.oma01,"",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc[l_cnt].omc02,SQLCA.sqlcode,"","",1)
               END IF
              #No.FUN-D40089 ---add--- end
               CLOSE WINDOW t300_w5
               LET g_success='N'
               RETURN
            ELSE
               CALL s_errmsg('','','g_oma.oma01',SQLCA.sqlcode,1)  
               LET g_success='N'   
            END IF    
         END IF
         LET l_amtf = 0 #MOD-B30690  #既表示此筆沖漲以全數歸在此項次之中,因此後續無須計算 
         LET l_amt  = 0 #MOD-B30690
      ELSE
         IF l_amt >=l_omc[l_cnt].omc09 THEN
            UPDATE omc_file SET omc10=l_omc[l_cnt].omc08,
                                omc11=l_omc[l_cnt].omc09,
                                omc13= 0
             WHERE omc01=g_oma.oma01
               AND omc02 = l_omc[l_cnt].omc02
            IF SQLCA.sqlcode THEN
               IF only_one = '1' THEN
                 #CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc[l_cnt].omc02,SQLCA.sqlcode,"","",1)  #No.FUN-D40089   Mark
                 #No.FUN-D40089 ---add--- str
                  IF g_bgerr THEN
                     CALL s_errmsg('oma01',g_oma.oma01,"",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc[l_cnt].omc02,SQLCA.sqlcode,"","",1)
                  END IF
                 #No.FUN-D40089 ---add--- end
                  CLOSE WINDOW t300_w5
                  LET g_success='N'
                  ROLLBACK WORK
                  RETURN
               ELSE   
                  CALL s_errmsg('omc_file','upd','g_oma.oma01',SQLCA.sqlcode,1)  
                  LET g_success='N'   
               END IF      
            END IF
            LET l_amtf = l_amtf - l_omc[l_cnt].omc08  
            LET l_amt  = l_amt  - l_omc[l_cnt].omc09    
         ELSE
            UPDATE omc_file SET omc10=l_omc[l_cnt].omc08,
                                omc11=l_amt,
                                omc13=l_omc[l_cnt].omc09-l_amt
             WHERE omc01=g_oma.oma01
               AND omc02 = l_omc[l_cnt].omc02
            IF SQLCA.sqlcode THEN
               IF only_one = '1' THEN
                 CLOSE WINDOW t300_w5
                #CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc[l_cnt].omc02,SQLCA.sqlcode,"","",1)  #No.FUN-D40089   Mark
                 #No.FUN-D40089 ---add--- str
                  IF g_bgerr THEN
                     CALL s_errmsg('oma01',g_oma.oma01,"",SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("upd","omc_file",g_oma.oma01,l_omc[l_cnt].omc02,SQLCA.sqlcode,"","",1)
                  END IF
                 #No.FUN-D40089 ---add--- end
                 LET g_success='N'
                 ROLLBACK WORK
                 RETURN
               ELSE
                 CALL s_errmsg('','g_oma.oma01','',SQLCA.sqlcode,1)  
                 LET g_success='N'   
               END IF    
            END IF
            LET l_amtf = l_amtf - l_omc[l_cnt].omc08  
            LET l_amt =0
         END IF
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   CALL l_omc.deleteElement(l_cnt)                                                                                                  
END FUNCTION
#FUN-CB0094---end
