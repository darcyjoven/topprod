# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_card_out.4gl
# Descriptions...: 儲值卡退余額
# Date & Author..: 09/07/09 By dongbg #FUN-960141 
# Usage..........: CALL s_card_out(p_no)
# Input Parameter: p_no    儲值卡退余額單號   
# Return Code....: g_flag  0:不成功
#                          1:成功
#                  g_no    AR單號
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0013 09/12/03 By lutingting 由于almt630取消單身,但是退款充帳邏輯沒有相應調整導致審核失敗
# Modify.........: No:FUN-9C0061 09/12/11 By lutingting  cl_err3第一個參數不能為空
# Modify.........: No:FUN-9C0139 09/12/22 By lutingting  oow07單別使用31
# Modify.........: No:FUN-9C0168 09/12/29 By lutingting 款別對應銀行改由axri060抓取
# Modify.........: No:TQC-A10136 10/01/22 By lutingting 產生nme檔時原幣本幣金額給反了
# Modify.........: No:FUN-A40076 10/07/02 By xiaofeizhu 更改ooa37的默認值，如果為Y改為2，N改為1
# Modify.........: No:FUN-A50102 10/07/08 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying INSERT INTO ooa_file前給ooalegal賦值
#                                                      INSERT INTO oob_file前給ooblegal賦值
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file   
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE li_result    LIKE type_file.num5
DEFINE g_ooa01      LIKE ooa_file.ooa01
DEFINE g_lpv        RECORD LIKE lpv_file.*
DEFINE g_bookno1    LIKE aza_file.aza81
DEFINE g_bookno2    LIKE aza_file.aza82
DEFINE g_flag1      LIKE type_file.chr1
DEFINE b_oob        RECORD LIKE oob_file.*
DEFINE g_sql        LIKE type_file.chr1000
 
FUNCTION s_card_out(p_no)
   DEFINE p_no       LIKE lpv_file.lpv01
   DEFINE l_t1       LIKE ooy_file.ooyslip
   
   IF cl_null(p_no) OR g_success = 'N' THEN RETURN END IF
   SELECT * INTO g_lpv.* FROM lpv_file WHERE lpv01 = p_no
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('lpv01',p_no,'',STATUS,1)
      ELSE
         CALL cl_err3("sel","lpv_file",p_no,"",STATUS,"","",1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL s_card_out_ins_ooa()
   CALL s_card_out_ins_oob()
   IF g_success = 'N' THEN RETURN 0,g_ooa01 END IF
   #########分錄底槁########
   LET l_t1 = s_get_doc_no(g_ooa01)
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_t1
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('ooyslip',l_t1,'sel ooy',STATUS,0)
      ELSE 
         #CALL cl_err3("","ooy_file",l_t1,"",STATUS,"sel ooy","",1)     #FUN-9C0061
         CALL cl_err3("sel","ooy_file",l_t1,"",STATUS,"sel ooy","",1)     #FUN-9C0061                                   
      END IF 
      LET g_success = 'N'
   END IF
   IF g_ooy.ooydmy1 = 'Y' THEN
      CALL s_t400_gl(g_ooa01,'0')
      IF g_aza.aza63='Y' THEN
         CALL s_t400_gl(g_ooa01,'1')
      END IF
   END IF
   IF g_success = "Y" THEN
      CALL s_card_out_y_upd()               #CALL原確認的UPDATE段
   END IF
 
   IF g_success = 'Y' THEN
      RETURN '1',g_ooa01 
   ELSE 
      RETURN '0',g_ooa01 
   END IF
 
END FUNCTION
 
FUNCTION s_card_out_ins_ooa()
  DEFINE l_ooa      RECORD LIKE ooa_file.*
  DEFINE l_occ      RECORD LIKE occ_file.*
  DEFINE l_oow07    LIKE oow_file.oow07 
 
   INITIALIZE l_ooa.* TO NULL
 
   LET l_ooa.ooa00  = '1'
   LET l_ooa.ooa02  = g_today
   LET l_ooa.ooa021 = g_today
   LET l_ooa.ooa03  = 'MISC'
   LET l_ooa.ooa032 = 'MISC'
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=l_ooa.ooa03
   LET l_ooa.ooa13 = l_occ.occ67
   LET l_ooa.ooa14 = g_user
   LET l_ooa.ooa15 = g_grup
   LET l_ooa.ooa20 = 'Y'
   LET l_ooa.ooa23 = l_occ.occ42
   IF cl_null(l_ooa.ooa23) THEN
      LET l_ooa.ooa23 = g_aza.aza17
   END IF 
   CALL s_curr3(l_ooa.ooa23,l_ooa.ooa02,'S') RETURNING l_ooa.ooa24
   LET l_ooa.ooa31d = 0
   LET l_ooa.ooa31c = 0
   LET l_ooa.ooa32d = 0
   LET l_ooa.ooa32c = 0
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_ooa.ooa23
   CALL cl_digcut(l_ooa.ooa31d,t_azi04) RETURNING l_ooa.ooa31d
   CALL cl_digcut(l_ooa.ooa31c,t_azi04) RETURNING l_ooa.ooa31c
   CALL cl_digcut(l_ooa.ooa32d,g_azi04) RETURNING l_ooa.ooa32d
   CALL cl_digcut(l_ooa.ooa32c,g_azi04) RETURNING l_ooa.ooa32c
   LET l_ooa.ooa33 = NULL
   LET l_ooa.ooa35 = '2'
   LET l_ooa.ooa36 = g_lpv.lpv01
   #LET l_ooa.ooa37 = 'Y'     #FUN-A40076
   LET l_ooa.ooa37 = '2'      #FUN-A40076
   LET l_ooa.ooa38 = '1'
   LET l_ooa.ooaconf = 'Y'
   LET l_ooa.ooaprsw = 0
   LET l_ooa.ooauser = g_user
   LET l_ooa.ooagrup = g_grup
   LET l_ooa.ooadate = g_today
   SELECT oow07 INTO l_oow07 FROM oow_file WHERE oow00='0'
   IF STATUS OR cl_null(l_oow07) THEN 
      IF g_bgerr THEN
         CALL s_errmsg('oow07',g_lpv.lpv01,'','axr-149',1)
      ELSE
         CALL cl_err3("sel","oow_file",g_lpv.lpv01,"",STATUS,"","sel oow",1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_get_bookno(year(l_ooa.ooa02)) RETURNING g_flag1,g_bookno1,g_bookno2
   IF g_flag1='1' THEN
      IF g_bgerr THEN
         CALL s_errmsg('ooa02',l_ooa.ooa02,'','aoo-081',1)
      ELSE
         #CALL cl_err3("","ooa_file",l_ooa.ooa02,"","aoo-081","","",1) #FUN-9C0061                                       
         CALL cl_err3("sel","ooa_file",l_ooa.ooa02,"","aoo-081","","",1) #FUN-9C0061
      END IF
      LET g_success = 'N'
   END IF
   #CALL s_auto_assign_no("axr",l_oow07,l_ooa.ooa02,"30","ooa_file","ooa01","","","")   #FUN-9C0139
   CALL s_auto_assign_no("axr",l_oow07,l_ooa.ooa02,"32","ooa_file","ooa01","","","")   #FUN-9C0139
      RETURNING li_result,l_ooa.ooa01
   IF (NOT li_result) THEN
      IF g_bgerr THEN
         CALL s_errmsg('oow07',g_lpv.lpv01,'','abm-621',1)
      ELSE
         #CALL cl_err3("","oow_ile","","","abm-621","","",1)    #FUN-9C0061
         CALL cl_err3("sel","oow_ile","","","abm-621","","",1)    #FUN-9C0061                                       
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_ooa.ooaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_ooa.ooaorig = g_grup      #No.FUN-980030 10/01/04
   LET l_ooa.ooalegal= g_legal     #No.FUN-A70118
   INSERT INTO ooa_file values(l_ooa.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',l_ooa.ooa01,'ins ooa',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","ooa_file",l_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_ooa01 = l_ooa.ooa01
END FUNCTION
 
FUNCTION s_card_out_ins_oob()
DEFINE l_ooa     RECORD LIKE ooa_file.*  
DEFINE l_rxx     RECORD LIKE rxx_file.*  
DEFINE l_oob     RECORD LIKE oob_file.*  
#DEFINE l_lpw04   LIKE lpw_file.lpw04   #FUN-9C0013
DEFINE l_rxx04   LIKE rxx_file.rxx04    #FUN-9C0013
DEFINE l_wc      LIKE lpw_file.lpw04
DEFINE l_sql     STRING
DEFINE i         LIKE type_file.num5
DEFINE l_oma01   LIKE oma_file.oma01
DEFINE l_aag05   LIKE aag_file.aag05
#DEFINE l_ryd05   LIKE ryd_file.ryd05    #FUN-9C0168
DEFINE l_ooe02   LIKE ooe_file.ooe02     #FUN-9C0168
DEFINE l_amt     LIKE oma_file.oma55
 
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_ooa01
 
   INITIALIZE l_oob.* TO NULL
   LET l_oob.oob01 = l_ooa.ooa01
   LET l_oob.oob03 = '1'
   LET l_oob.oob04 = '3'
   LET l_oob.oob07 = l_ooa.ooa23
   LET l_oob.oob08 = l_ooa.ooa24
   LET l_oob.oob19 = '1'
   LET l_oob.oob20 = 'N'
  #FUN-9C0001--mod--str--
  #SELECT SUM(lpw04) INTO l_lpw04 FROM lpw_file
  # WHERE lpw01=g_lpv.lpv01
  #IF cl_null(l_lpw04) THEN
  #  LET l_lpw04=0
  #END IF
  #CALL cl_digcut(l_lpw04,g_azi04) RETURNING l_lpw04
  #LET l_wc = l_lpw04 + g_lpv.lpv06
   SELECT SUM(rxx04) INTO l_rxx04
     FROM rxx_file 
    WHERE rxx01= g_lpv.lpv01 AND rxxplant= g_lpv.lpvplant
      AND rxx00='22' 
   CALL cl_digcut(l_rxx04,g_azi04) RETURNING l_rxx04
   LET l_wc = l_rxx04 + g_lpv.lpv06
  #FUN-9C0001--mod--end
   #借待扺
   LET l_sql = "SELECT oma01,oma54t-oma55  FROM oma_file ",
               " WHERE oma00 = '26' AND oma03 ='MISCCARD' and oma54t-oma55>0 order by oma02"
   PREPARE debit_prep FROM l_sql
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_lpv.lpv01,'pre err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("pre","",g_lpv.lpv01,"",SQLCA.sqlcode,"","pre",1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE debit_cs CURSOR FOR debit_prep
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_lpv.lpv01,'dec err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("dec","",g_lpv.lpv01,"",SQLCA.sqlcode,"","dec",1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
   LET i = 1
   FOREACH debit_cs INTO l_oma01,l_amt
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_lpv.lpv01,'for err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("for","",g_lpv.lpv01,"",SQLCA.sqlcode,"","for",1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_oob.oob07
      CALL cl_digcut(l_wc,t_azi04) RETURNING l_wc
      CALL cl_digcut(l_amt,t_azi04) RETURNING l_amt
      IF l_wc<=0 THEN EXIT FOREACH END IF
      IF l_wc >= l_amt THEN
         LET l_oob.oob02 = i
         LET l_wc = l_wc - l_amt
         LET l_oob.oob06 = l_oma01
         LET l_oob.oob09 = l_amt
         LET l_oob.oob10 = l_oob.oob08*l_oob.oob09
         SELECT oma18 INTO l_oob.oob11 FROM oma_file WHERE oma01=l_oma01
         IF g_aza.aza63 = 'Y' THEN
            SELECT oma181 INTO l_oob.oob111 FROM oma_file WHERE oma01=l_oma01
         END IF
      ELSE
         LET l_oob.oob02 = i
         LET l_oob.oob06 = l_oma01
         LET l_oob.oob09 = l_wc
         LET l_wc = 0
         LET l_oob.oob10 = l_oob.oob08*l_oob.oob09
         SELECT oma18 INTO l_oob.oob11 FROM oma_file WHERE oma01=l_oma01
         IF g_aza.aza63 = 'Y' THEN
            SELECT oma181 INTO l_oob.oob111 FROM oma_file WHERE oma01=l_oma01
         END IF
      END IF
      LET l_oob.ooblegal = g_legal   #No.FUN-A70118
      INSERT INTO oob_file values(l_oob.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('oob01',l_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","oob_file",l_oob.oob01,"",SQLCA.sqlcode,"","ins oob",1)                                        
         END IF
         LET g_success = 'N'
      END IF
 
      UPDATE ooa_file SET ooa31d = ooa31d + l_oob.oob09,
                          ooa32d = ooa32d + l_oob.oob10
       WHERE ooa01 = l_ooa.ooa01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('ooa01',l_ooa.ooa01,'upd ooa err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","ooa_file",l_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooa",1)
         END IF
         LET g_success = 'N'
      END IF
 
      LET i = i+1
   END FOREACH
 
   IF i = 1 THEN 
      IF g_bgerr THEN
         CALL s_errmsg('',l_ooa.ooa01,'','alm-260',1)
      ELSE
         #CALL cl_err3("","oma_file",l_ooa.ooa01,"","alm-260","","",1)   #FUN-9C0061
         CALL cl_err3("upd","oma_file",l_ooa.ooa01,"","alm-260","","",1)   #FUN-9C0061
      END IF
      LET g_success = 'N'
      RETURN
   END IF
   #借方結束
   #根據退款明細產生貸方     
   LET l_sql = "SELECT * FROM rxx_file where rxx01= '",g_lpv.lpv01 CLIPPED ,"'",
               " and rxxplant= '",g_lpv.lpvplant CLIPPED,"' and rxx00='22'"
   PREPARE credit_prep FROM l_sql
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('rxx01',g_lpv.lpv01,'pre err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("pre","",g_lpv.lpv01,"",SQLCA.sqlcode,"","pre",1)                                        
      END IF
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE credit_cs CURSOR FOR credit_prep
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('rxx01',g_lpv.lpv01,'dec err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("dec","",g_lpv.lpv01,"",SQLCA.sqlcode,"","dec",1)                                        
      END IF
      LET g_success = 'N'
      RETURN 
   END IF
   FOREACH credit_cs INTO l_rxx.*
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('rxx01',g_lpv.lpv01,'for err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("for","",g_lpv.lpv01,"",SQLCA.sqlcode,"","for",1)                                        
      END IF
      LET g_success = 'N'
      RETURN 
   END IF
     INITIALIZE l_oob.* TO NULL
     #SELECT ryd05 INTO l_ryd05 FROM ryd_file WHERE ryd01 = l_rxx.rxx02    #FUN-9C0168
     SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01 = l_rxx.rxx02     #FUN-9C0168 
     LET l_oob.oob01 = l_ooa.ooa01
     LET l_oob.oob02 = i
     LET l_oob.oob03 = '2'
     LET l_oob.oob06 = NULL
     LET l_oob.oob20 = 'N'
     LET l_oob.oob07 = l_ooa.ooa23
     LET l_oob.oob08 = l_ooa.ooa24
     LET l_oob.oob09 = l_rxx.rxx04
     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_oob.oob07
     CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09
     LET l_oob.oob10 = l_oob.oob08*l_oob.oob09
     CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10
     IF l_rxx.rxx02 MATCHES '0[1238]' THEN		           #TT
        LET l_oob.oob04 = 'A'
       #FUN-9C0168--mod--str--
       #IF NOT cl_null(l_ryd05) THEN  #款別設置了對應銀行
       #   LET l_oob.oob17 = l_ryd05
       #   SELECT nma05 INTO l_oob.oob11 FROM nma_file WHERE nma01=l_ryd05
       #   IF g_aza.aza63 = 'Y' THEN
       #      SELECT nma051 INTO l_oob.oob111 FROM nma_file WHERE nma01=l_ryd05
        IF NOT cl_null(l_ooe02) THEN  #款別設置了對應銀行
           LET l_oob.oob17 = l_ooe02
           SELECT nma05 INTO l_oob.oob11 FROM nma_file WHERE nma01=l_ooe02
           IF g_aza.aza63 = 'Y' THEN
              SELECT nma051 INTO l_oob.oob111 FROM nma_file WHERE nma01=l_ooe02
       #FUN-9C0168--mod--end
           END IF
        ELSE
        #########wating for new######
        END IF
        SELECT oow12 INTO l_oob.oob18 FROM oow_file WHERE oow00 = '0' 
        SELECT nmc05 INTO l_oob.oob21 FROM nmc_file WHERE nmc01=l_oob.oob18
        IF cl_null(l_oob.oob17) OR cl_null(l_oob.oob18) OR cl_null(l_oob.oob21) THEN
           IF g_bgerr THEN
              CALL s_errmsg('oob01',l_oob.oob01,'','alm-679',1) 
           ELSE
              CALL cl_err3("sel","",l_oob.oob01,"","alm-679","","",1)                                        
           END IF
           LET g_success = 'N'
        END IF        
     END IF
     IF l_rxx.rxx02 = '05' THEN		                       #聯盟卡
        LET l_oob.oob04 = 'E'
       #FUN-9C0168--mod--str--
       #IF NOT cl_null(l_ryd05) THEN
       #   SELECT nma05 INTO l_oob.oob11 FROM nma_file
       #     WHERE nma01=l_ryd05
       #   IF g_aza.aza63 = 'Y' THEN
       #      SELECT nma051 INTO l_oob.oob111 FROM nma_file
       #       WHERE nma01=l_ryd05
        IF NOT cl_null(l_ooe02) THEN
           SELECT nma05 INTO l_oob.oob11 FROM nma_file
            WHERE nma01=l_ooe02
           IF g_aza.aza63 = 'Y' THEN
              SELECT nma051 INTO l_oob.oob111 FROM nma_file
               WHERE nma01=l_ooe02
       #FUN-9C0168--mod--end
           END IF
        ELSE
        ##########wating for new######
        END IF
     END IF
     IF l_rxx.rxx02 = '04' THEN                               #券
        LET l_oob.oob04 = 'Q'
        LET l_oob.oob17 = NULL
        SELECT ool32 INTO l_oob.oob11 FROM ool_file WHERE ool01=l_ooa.ooa23
        IF g_aza.aza63 = 'Y' THEN
           SELECT ool321 INTO l_oob.oob111 FROM ool_file WHERE ool01=l_ooa.ooa23
        END IF
     END IF
     SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_oob.oob11 AND aag00=g_bookno1
     IF l_aag05 ='Y' THEN
        LET l_oob.oob13 = l_ooa.ooa15
     ELSE
        LET l_oob.oob13 = NULL
     END IF
     IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN 
        IF g_bgerr THEN
           CALL s_errmsg('oob111',l_oob.oob01,'oob111 is null','axr-076',1)
        ELSE
           #CALL cl_err3("","oob_file",l_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
           CALL cl_err3("sel","oob_file",l_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
        END IF
        LET g_success = 'N'
     END IF
     IF cl_null(l_oob.oob11) THEN
        IF g_bgerr THEN
           CALL s_errmsg('oob11',l_oob.oob01,'oob11 is null','axr-076',1)
        ELSE
           #CALL cl_err3("","oob_file",l_oob.oob01,"","axr-076","oob111 is null","",1)   #FUN-9C0061
           CALL cl_err3("sel","oob_file",l_oob.oob01,"","axr-076","oob111 is null","",1)   #FUN-9C0061
        END IF
        LET g_success = 'N'
     END IF
     LET l_oob.ooblegal = g_legal  #No.FUN-A70118
     INSERT INTO oob_file values(l_oob.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        IF g_bgerr THEN
           CALL s_errmsg('oob01',l_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
        ELSE 
           CALL cl_err3("ins","oob_file",l_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
        END IF
        LET g_success = 'N'
     END IF
 
     UPDATE ooa_file SET ooa31c = ooa31c + l_oob.oob09,
                         ooa32c = ooa32c + l_oob.oob10
      WHERE ooa01 = l_ooa.ooa01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        IF g_bgerr THEN
           CALL s_errmsg('ooa01',l_ooa.ooa01,'upd ooa err',SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("upd","ooa_file",l_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooa",1)
        END IF
        LET g_success = 'N'
     END IF
 
     LET i = i +1
   END FOREACH
   #根據退款明細產生貸方結束
   ###若退款時有折扣 折扣轉費用,防止axrt410單身的借貸方金額不平
   IF g_lpv.lpv06 > 0 THEN
      INITIALIZE l_oob.* TO NULL
      LET l_oob.oob01 = l_ooa.ooa01
      LET l_oob.oob06 = NULL
      LET l_oob.oob20 = 'N'
      LET l_oob.oob07 = l_ooa.ooa23
      LET l_oob.oob08 = l_ooa.ooa24
      SELECT MAX(oob02)+1 INTO l_oob.oob02 FROM oob_file WHERE oob01 = l_ooa.ooa01						
      IF cl_null(l_oob.oob02) THEN LET l_oob.oob02 = 1 END IF 
      LET l_oob.oob03 = '2'							
      LET l_oob.oob04 = 'F'							
      SELECT ool34,ool341 INTO l_oob.oob11,l_oob.oob111 FROM ool_file
       WHERE ool01 = l_ooa.ooa13
      IF g_aza.aza63 = 'N' THEN							
         LET l_oob.oob111 = NULL
      END IF
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_oob.oob11 AND aag00=g_bookno1  							
      IF l_aag05 ='Y' THEN							
         LET l_oob.oob13 = l_ooa.ooa15							
      ELSE							
         LET l_oob.oob13 = NULL							
      END IF							
      LET l_oob.oob06 = NULL							
      LET l_oob.oob09 = g_lpv.lpv06      					
      LET l_oob.oob10 = l_oob.oob08 * l_oob.oob09								
      LET l_oob.oob17 = NULL
      LET l_oob.oob18 = NULL
      LET l_oob.oob21 = NULL
      IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN 
         IF g_bgerr THEN
            CALL s_errmsg('oob111',l_oob.oob01,'oob111 is null','axr-076',1)
         ELSE
            #CALL cl_err3("","oob_file",l_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
            CALL cl_err3("sel","oob_file",l_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
         END IF
         LET g_success = 'N'
      END IF
      IF cl_null(l_oob.oob11) THEN
         IF g_bgerr THEN
            CALL s_errmsg('oob11',l_oob.oob01,'oob11 is null','axr-076',1)
         ELSE
            #CALL cl_err3("","oob_file",l_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
            CALL cl_err3("sel","oob_file",l_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C006
         END IF
         LET g_success = 'N'
      END IF
       LET l_oob.ooblegal = g_legal  #No.FUN-A70118
      INSERT INTO oob_file values(l_oob.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('oob01',l_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
         ELSE 
            CALL cl_err3("ins","oob_file",l_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
         END IF
         LET g_success = 'N'
      END IF
      
      UPDATE ooa_file SET ooa31c = ooa31c + l_oob.oob09,
                          ooa32c = ooa32c + l_oob.oob10
       WHERE ooa01 = l_ooa.ooa01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('ooa01',l_ooa.ooa01,'upd ooa err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("upd","ooa_file",l_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooa",1)
         END IF
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION
 
FUNCTION s_card_out_y_upd() 
DEFINE l_cnt  LIKE type_file.num5  
DEFINE l_ooa  RECORD LIKE ooa_file.*
 
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_ooa01
   IF l_ooa.ooa32d != l_ooa.ooa32c THEN
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',l_ooa.ooa01,'','axr-203',1)
      ELSE
         CALL cl_err('','axr-203',0)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   IF l_ooa.ooa02 <= g_ooz.ooz09 THEN
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',l_ooa.ooa01,'','axr-164',1)
      ELSE
         CALL cl_err('','axr-164',0)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01 = l_ooa.ooa01
   IF l_cnt = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',l_ooa.ooa01,'','mfg-009',1)
      ELSE
         CALL cl_err('','mfg-009',0)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oob_file,oma_file
    WHERE ( YEAR(oma02) > YEAR(l_ooa.ooa02)
       OR (YEAR(oma02) = YEAR(l_ooa.ooa02)
      AND MONTH(oma02) > MONTH(l_ooa.ooa02)) )
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = l_ooa.ooa01
 
   IF l_cnt >0 THEN
      CALL cl_err(l_ooa.ooa01,'axr-371',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ooy.ooydmy1 = 'Y' THEN
      CALL s_chknpq(l_ooa.ooa01,'AR',1,'0',g_bookno1)
      IF g_aza.aza63='Y' AND g_success='Y' THEN
         CALL s_chknpq(l_ooa.ooa01,'AR',1,'1',g_bookno2)
      END IF
      LET g_dbs_new = g_dbs CLIPPED,'.'
      LET g_plant_new = g_plant       #FUN-A50102
   END IF
 
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   SELECT * INTO l_ooa.* FROM ooa_file
       WHERE ooa01 = l_ooa.ooa01
 
   UPDATE ooa_file SET ooa34 = '1' WHERE ooa01 = l_ooa.ooa01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',l_ooa.ooa01,'upd ooa err',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","ooa_file",l_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooa",1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_card_out_y1()
END FUNCTION
 
FUNCTION s_card_out_y1()
   DEFINE n       LIKE type_file.num5   
   DEFINE l_cnt   LIKE type_file.num5   
   DEFINE l_flag  LIKE type_file.chr1   
   DEFINE l_ooa   RECORD LIKE ooa_file.*
 
 
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_ooa01
   CALL s_card_out_hu2()
 
   IF g_success = 'N' THEN
      RETURN
   END IF 
 
   DECLARE s_card_out_y1_c CURSOR FOR
   SELECT * FROM oob_file WHERE oob01 = g_ooa01 ORDER BY oob02
 
   LET l_cnt = 1
   LET l_flag = '0'
   FOREACH s_card_out_y1_c INTO b_oob.*
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg('oob01',g_ooa01,'y1 foreach',STATUS,1)
         ELSE
            CALL cl_err(g_ooa01,STATUS,1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
 
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
         CALL s_card_out_bu_13('+')
      END IF
      #IF l_ooa.ooa37 = 'Y' THEN   #FUN-A40076 mark
      IF l_ooa.ooa37 = '2' THEN    #FUN-A40076 add
         IF b_oob.oob03 = '2' AND b_oob.oob04 = 'A' THEN
            CALL s_card_out_bu_2A('+')
         END IF
      END IF
   END FOREACH
 
END FUNCTION
 
FUNCTION s_card_out_hu2()            #最近交易日
DEFINE l_occ RECORD LIKE occ_file.*
DEFINE l_ooa RECORD LIKE ooa_file.*
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01=g_ooa01
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=l_ooa.ooa03
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('occ01',l_ooa.ooa03,'sel occ',STATUS,1)
      ELSE
         CALL cl_err3("sel","occ_file",l_ooa.ooa03,"",STATUS,"","s ccc",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=l_ooa.ooa02 END IF
   IF l_occ.occ174 IS NULL OR l_occ.occ174 < l_ooa.ooa02 THEN
      LET l_occ.occ174=l_ooa.ooa02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=l_ooa.ooa03
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('occ01',l_ooa.ooa03,'upd occ',STATUS,1)
      ELSE
         CALL cl_err3("upd","occ_file",l_ooa.ooa03,"",SQLCA.sqlcode,"","u ccc",1) 
      END IF
      LET g_success='N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION s_card_out_bu_2A(p_sw)
  DEFINE p_sw            LIKE type_file.chr1
  DEFINE l_nme  RECORD   LIKE nme_file.*
  DEFINE l_ooa  RECORD   LIKE ooa_file.*
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01=g_ooa01
   IF p_sw = '+' THEN
      LET l_nme.nme00 = '0'
      LET l_nme.nme01 = b_oob.oob17
      LET l_nme.nme02 = l_ooa.ooa02
      LET l_nme.nme03 = b_oob.oob18
      #LET l_nme.nme04 = b_oob.oob10    #TQC-A10136
      LET l_nme.nme04 = b_oob.oob09     #TQC-A10136
      LET l_nme.nme07 = l_ooa.ooa24
      #LET l_nme.nme08 = b_oob.oob09    #TQC-A10136
      LET l_nme.nme08 = b_oob.oob10     #TQC-A10136
      LET l_nme.nme10 = l_ooa.ooa33
      LET l_nme.nme12 = b_oob.oob01
      LET l_nme.nme13 = l_ooa.ooa032
      LET l_nme.nme14 = b_oob.oob21
      LET l_nme.nme15 = b_oob.oob13
      LET l_nme.nme16 = l_ooa.ooa02
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=TODAY
      LET l_nme.nme21=b_oob.oob02
      LET l_nme.nme22='01'
      LET l_nme.nme23=b_oob.oob04
      LET l_nme.nme24='9'
      LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
      LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04
      LET l_nme.nmelegal = g_legal    #No.FUN-A70118

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

      INSERT INTO nme_file VALUES(l_nme.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('nme01',l_ooa.ooa01,'ins nme err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","nme_file","","",SQLCA.sqlcode,"","",1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
      CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062  
  END IF
 
END FUNCTION
 
FUNCTION s_card_out_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1    
  DEFINE l_omaconf      LIKE oma_file.omaconf, 
         l_omavoid      LIKE oma_file.omavoid, 
         l_cnt          LIKE type_file.num5    
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE tot4,tot4t     LIKE type_file.num20_6 
  DEFINE tot5,tot6      LIKE type_file.num20_6 
  DEFINE tot1,tot2,tot3 LIKE type_file.num20_6 
  DEFINE tot8           LIKE type_file.num20_6  
  DEFINE un_pay1 ,un_pay2    LIKE type_file.num20_6
  DEFINE l_omc10        LIKE omc_file.omc10,
         l_omc11        LIKE omc_file.omc11,
         l_omc13        LIKE omc_file.omc13 
  DEFINE l_ooa          RECORD LIKE ooa_file.* 
 
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01=g_ooa01
   DISPLAY "bu_13:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
# 同參考單號若有一筆以上僅沖款一次即可 --------------
  SELECT COUNT(*) INTO l_cnt FROM oob_file
   WHERE oob01=b_oob.oob01
     AND oob02<b_oob.oob02
     AND oob03='1'
     AND oob04='3'  #No.9047 add
     AND oob06=b_oob.oob06
  IF l_cnt>0 THEN RETURN END IF
 
 #預防在收款沖帳確認前,多沖待抵貨款
  SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob01=ooa01
     AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
 
  IF p_sw='+' THEN
     SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
      WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
        AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'
       IF cl_null(tot5) THEN LET tot5 = 0 END IF
       IF cl_null(tot6) THEN LET tot6 = 0 END IF
  END IF
 
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  CALL cl_digcut(tot1,t_azi04) RETURNING tot1
  CALL cl_digcut(tot2,g_azi04) RETURNING tot2
  LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
            #"  FROM ",g_dbs_new CLIPPED,"oma_file",
            "  FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
            " WHERE oma01=?"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102	          
  PREPARE s_card_out_bu_13_p1 FROM g_sql
  DECLARE s_card_out_bu_13_c1 CURSOR FOR s_card_out_bu_13_p1
  OPEN s_card_out_bu_13_c1 USING b_oob.oob06
  FETCH s_card_out_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
    IF p_sw='+' AND l_omavoid='Y' THEN
       IF g_bgerr THEN
          CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) 
       ELSE
          CALL cl_err(b_oob.oob06,'axr-103',1) 
       END IF
       LET g_success = 'N' 
       RETURN 
    END IF
    IF p_sw='+' AND l_omaconf='N' THEN
       IF g_bgerr THEN
          CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) 
       ELSE
          CALL cl_err(b_oob.oob06,'axr-104',1)
       END IF
       LET g_success = 'N' 
       RETURN 
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL s_card_out_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4 
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t
 
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN
          IF g_bgerr THEN  
             CALL s_errmsg(' ',' ','un_pay<pay#1','axr-196',1) 
          ELSE
             CALL cl_err('','axr-196',1)
          END IF
          LET g_success = 'N'
          RETURN  
       END IF
    END IF
 
    SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
     WHERE oob06=b_oob.oob06 AND oob01=ooa01  AND ooaconf = 'Y'
       AND oob03='1'  AND oob04 = '3'
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
    IF p_sw='+' THEN
       SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
        WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
          AND ooaconf = 'Y' AND oob03='1'  AND oob04 = '3'
       IF cl_null(tot5) THEN LET tot5 = 0 END IF
       IF cl_null(tot6) THEN LET tot6 = 0 END IF
 
       SELECT omc10,omc11,omc13 INTO l_omc10,l_omc11,l_omc13 FROM omc_file
        WHERE omc01=b_oob.oob06 AND omc02 = b_oob.oob19
       IF cl_null(l_omc10) THEN LET l_omc10=0 END IF
       IF cl_null(l_omc11) THEN LET l_omc11=0 END IF
       IF cl_null(l_omc13) THEN LET l_omc13=0 END IF
     END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       #取得未沖金額
       CALL s_g_np('1',l_oma00,b_oob.oob06,0) RETURNING tot3
       #未衝金額扣除待扺
       LET tot3 = tot3 - tot4t
    ELSE
       LET tot3 = un_pay2 - tot2 - tot4t
    END IF
    #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"oma_file SET oma55=?,oma57=?,oma61=? ",
    LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
              " SET oma55=?,oma57=?,oma61=? ",
              " WHERE oma01=? "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102	          
    PREPARE s_card_out_bu_13_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2
 
    EXECUTE s_card_out_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)
       ELSE 
          CALL cl_err('upd oma55,57',STATUS,1) 
       END IF
       LET g_success = 'N'
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       IF g_bgerr THEN
          CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) 
       ELSE
          CALL cl_err('upd oma55,57','axr-198',1)
       END IF
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL s_card_out_omc(p_sw)
    END IF
END FUNCTION
 
 
#取得衝帳單的待扺金額
FUNCTION s_card_out_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t
 
   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION
 
FUNCTION s_card_out_omc(p_sw)
DEFINE   l_omc10           LIKE omc_file.omc10
DEFINE   l_omc11           LIKE omc_file.omc11
DEFINE   l_omc13           LIKE omc_file.omc13
DEFINE   p_sw              LIKE type_file.chr1
DEFINE   l_oob09           LIKE oob_file.oob09
DEFINE   l_oob10           LIKE oob_file.oob10
 
  SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19
     AND oob01=ooa01  AND ooaconf = 'Y'
     AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))
  IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
  IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  CALL cl_digcut(l_oob09,t_azi04) RETURNING l_oob09
  CALL cl_digcut(l_oob10,g_azi04) RETURNING l_oob10
     #LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc10=?,omc11=? ",
     LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
               " SET omc10=?,omc11=? ",
               " WHERE omc01=? AND omc02=? "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102          
     PREPARE s_card_out_bu_13_p3 FROM g_sql
     EXECUTE s_card_out_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
     #LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc13=omc09-omc11",
     LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
               " SET omc13=omc09-omc11",
               " WHERE omc01=? AND omc02=? "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102               
     PREPARE s_card_out_bu_13_p4 FROM g_sql
     EXECUTE s_card_out_bu_13_p4 USING b_oob.oob06,b_oob.oob19
END FUNCTION
#FUN-960141
