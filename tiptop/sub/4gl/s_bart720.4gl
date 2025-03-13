# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# Program name...: s_bart720.4gl
# Descriptions...: 
# Date & Author..: No:DEV-D20007 2013/02/25 By Mandy
# Usage..........: CALL s_bart720(p_tlfb07,p_tlfb15)
# Return Code....: TRUE/FALSE 
# Modify.........: No:DEV-D30018 13/03/04 By Nina 修改Return值原本只傳TRUE/FALSE，改成傳字元判斷執行成功、執行失敗、無資料三種狀態
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---

DATABASE ds 
    
GLOBALS "../../config/top.global" 
GLOBALS "../../aba/4gl/barcode.global"

DEFINE g_rvu01     LIKE rvu_file.rvu01   #入庫單號
DEFINE g_rvu01_1   LIKE rvu_file.rvu01  
DEFINE g_rvu01_2   LIKE rvu_file.rvu01  
DEFINE g_rva       RECORD LIKE rva_file.*
DEFINE g_argv6     LIKE type_file.chr1
DEFINE g_tlfb15    LIKE tlfb_file.tlfb15

FUNCTION s_bart720(p_tlfb07,p_tlfb15)
DEFINE p_tlfb07     LIKE  tlfb_file.tlfb07   #收貨單號
DEFINE p_tlfb15     LIKE  tlfb_file.tlfb15   #KEY==>時間(時:分:秒.毫秒)
DEFINE l_tlfb07     LIKE  tlfb_file.tlfb07   #收貨單號
DEFINE l_tlfb08     LIKE  tlfb_file.tlfb08   #收貨項次
DEFINE l_rvv17      LIKE  rvv_file.rvv17     #異動數量
DEFINE l_ins_rvu    LIKE  type_file.chr1     #是否新增rvu_file
DEFINE l_do_foreach LIKE  type_file.chr1     #是否有跑進FOREACH

   LET g_success = 'Y'
   LET g_argv6 = '1'

   LET g_tlfb15 = p_tlfb15

   DECLARE s_tlfb_curs CURSOR WITH HOLD FOR
   SELECT tlfb07,tlfb08,SUM(tlfb05*tlfb06)
     FROM tlfb_file
    WHERE tlfb15 = p_tlfb15
      AND tlfb07 = p_tlfb07
      AND (tlfb09 IS NULL OR tlfb09 = '') #採購入庫單號為空的
    GROUP BY tlfb07,tlfb08
    ORDER BY tlfb07,tlfb08

   LET l_ins_rvu = 'Y'
   LET l_tlfb07 = NULL
   LET l_tlfb08 = NULL
   LET l_rvv17  = NULL
   LET l_do_foreach = 'N'
   FOREACH s_tlfb_curs INTO l_tlfb07,l_tlfb08,l_rvv17
      IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL cl_err('s_gen_bcl foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      IF l_ins_rvu = 'Y' THEN
          CALL s_bart720_ins_rvu(l_tlfb07,'i')
      END IF
      IF g_success = 'Y' THEN
          CALL s_bart720_ins_rvv(l_tlfb07,l_tlfb08,l_rvv17)
      END IF
      IF g_success = 'N' THEN
          EXIT FOREACH
      END IF
      LET l_ins_rvu = 'N'
      LET l_tlfb07 = NULL
      LET l_tlfb08 = NULL
      LET l_rvv17  = NULL
      LET l_do_foreach = 'Y'
   END FOREACH
   IF l_do_foreach = 'N' THEN
      #CALL cl_err('','apm1031',1) #無符合的資料產生！     #DEV-D30018 mark
      #RETURN FALSE,''                                     #DEV-D30018 mark
       RETURN 'Z',''                                       #DEV-D30018 add
   END IF
   IF g_success = 'Y' THEN
      #RETURN TRUE,g_rvu01                                 #DEV-D30018 mark
       RETURN 'Y',g_rvu01                                  #DEV-D30018 add
   ELSE
      #RETURN FALSE,''                                     #DEV-D30018 mark
       RETURN 'N',''                                       #DEV-D30018 add
   END IF

END FUNCTION

FUNCTION s_bart720_ins_rvu(p_tlfb07,p_chr)
   DEFINE p_tlfb07    LIKE tlfb_file.tlfb07
   DEFINE p_chr       LIKE type_file.chr1
   DEFINE g_qcz       RECORD LIKE qcz_file.*
   DEFINE l_rvu       RECORD LIKE rvu_file.*
   DEFINE l_smy57     LIKE type_file.chr1
   DEFINE l_t         LIKE smy_file.smyslip    
   DEFINE li_result   LIKE type_file.num5      
   DEFINE l_smydmy4   LIKE smy_file.smydmy4    
   DEFINE l_smyapr    LIKE smy_file.smyapr     
   DEFINE l_yy,l_mm   LIKE type_file.num5
   DEFINE l_cnt       LIKE type_file.num5


   #----單頭
   INITIALIZE g_rva.* TO NULL
   INITIALIZE l_rvu.* TO NULL
 
   SELECT * INTO g_rva.*
     FROM rva_file
    WHERE rva01 = p_tlfb07

   LET l_rvu.rvu00='1'   #入庫
   LET l_rvu.rvu02=g_rva.rva01   #驗收單號
   LET l_rvu.rvu03=g_today       #異動日期
 
   #若入庫日小於收貨日                                                                                                              
   IF l_rvu.rvu03<g_rva.rva06 THEN                                                                                                  
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg("","",l_rvu.rvu03,"apm-316",1)                                                                               
      ELSE                                                                                                                          
         CALL cl_err3("","","","","apm-316","",l_rvu.rvu03,1)                                                                       
      END IF                                                                                                                        
      LET g_success='N'                                                                                                             
      RETURN                                                                                                                        
   END IF                                                                                                                           
 
   #日期<=關帳日期
   IF NOT cl_null(g_sma.sma53) AND l_rvu.rvu03 <= g_sma.sma53 THEN
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg9999",1)
      ELSE
         CALL cl_err3("","","","","mfg9999","",l_rvu.rvu03,1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL s_yp(l_rvu.rvu03) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm)>(g_sma.sma51*12+g_sma.sma52)THEN #不可大於現行年月
      IF g_bgerr THEN
         CALL s_errmsg("","",l_rvu.rvu03,"mfg6091",1)
      ELSE
         CALL cl_err3("","","","","mfg6091","",l_rvu.rvu03,1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_t = s_get_doc_no(g_rva.rva01)       
  #用傳入的參數來判斷
   IF p_chr = 'o' THEN        
      SELECT smy51,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
       WHERE smyslip=l_t
   ELSE
      SELECT smy52,smy57[3,3] INTO l_rvu.rvu01,l_smy57 FROM smy_file
       WHERE smyslip=l_t
   END IF
 
   IF l_rvu.rvu01 IS NULL THEN
      IF g_bgerr THEN
         CALL s_errmsg("","","smy52=NULL","apm-272",1)
      ELSE
         CALL cl_err3("","","","","apm-272","","smy52=NULL",1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
 
   IF (l_rvu.rvu00='1' AND cl_null(g_rvu01_1)) OR
      (l_rvu.rvu00='2' AND cl_null(g_rvu01_2)) THEN
      IF l_smy57='Y' THEN
         LET l_rvu.rvu01[g_no_sp-1,g_no_ep]=g_rva.rva01[g_no_sp-1,g_no_ep] 
 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM rvu_file
          WHERE rvu01=l_rvu.rvu01
         IF l_cnt > 0 THEN   # OR MONTH(g_rva.rva08) <> MONTH(g_today)
                             #原有考慮收貨月份不等於入庫月份時應以 g_today產生單號
                             #此狀況改以原收貨月份產生單號)
 
            LET l_t = l_rvu.rvu01[1,g_doc_len]        
            CALL s_auto_assign_no("apm",l_t,g_rva.rva06,"","","","","","")
                 RETURNING li_result,l_rvu.rvu01
            IF (NOT li_result) THEN
                LET g_success='N'
            END IF
         END IF
      ELSE
         LET l_t = l_rvu.rvu01[1,g_doc_len]        
         CALL s_auto_assign_no("apm",l_t,l_rvu.rvu03,"","","","","","")
              RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
             LET g_success='N'
         END IF
      END IF
   END IF
   LET g_rvu01 = l_rvu.rvu01
 
   IF (l_rvu.rvu00='1' AND cl_null(g_rvu01_1)) THEN #入庫
      LET g_rvu01_1 = l_rvu.rvu01
   END IF
 
   IF (l_rvu.rvu00='2' AND cl_null(g_rvu01_2)) THEN #驗退
      LET g_rvu01_2 = l_rvu.rvu01
   END IF
 
   IF l_rvu.rvu00 = '1' THEN
      LET l_rvu.rvu01 = g_rvu01_1 #入庫
   ELSE
      LET l_rvu.rvu01 = g_rvu01_2 #驗退
   END IF
 
   LET l_rvu.rvu04=g_rva.rva05   #廠商編號
   SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file  #簡稱
    WHERE pmc01=g_rva.rva05
   LET l_rvu.rvu06=g_grup        #部門
   LET l_rvu.rvu07=g_user        #人員
   LET l_rvu.rvu08=g_rva.rva10   #性質
   LET l_rvu.rvu09=NULL
   LET l_rvu.rvu20='N'           #三角貿易拋轉否
   LET l_rvu.rvuconf='N'         #確認碼
   LET l_rvu.rvuacti='Y'
   LET l_rvu.rvuuser=g_user         
   LET l_rvu.rvugrup=g_grup        
   LET l_rvu.rvumodu=' '
   LET l_rvu.rvucrat=g_today  
   LET l_rvu.rvu21 = g_rva.rva29 
   LET l_rvu.rvuplant = g_rva.rvaplant
   LET l_rvu.rvulegal = g_rva.rvalegal
   LET l_rvu.rvu22 = g_rva.rva30
   LET l_rvu.rvu23 = g_rva.rva31
   LET l_rvu.rvucrat = g_today
   LET l_rvu.rvu900 = '0'
   LET l_rvu.rvumksg = 'N'
   LET l_rvu.rvupos = 'N'
   IF l_rvu.rvu21 IS NULL THEN LET l_rvu.rvu21 = '1' END IF
   LET l_rvu.rvuplant = g_plant #NO.FUN-980006 jarlin add
   LET l_rvu.rvulegal = g_legal #NO.FUN-980006 jarlin add
   LET l_rvu.rvuoriu = g_user #TQC-9B0226
   LET l_rvu.rvuorig = g_grup #TQC-9B0226
   LET l_rvu.rvu101=g_rva.rva08   #CHI-A50012 add 
   LET l_rvu.rvu102=g_rva.rva21   #CHI-A50012 add 
   LET l_rvu.rvu100=g_rva.rva100  #CHI-A50012 add 
   LET l_rvu.rvu17='0'
   LET l_t = l_rvu.rvu01[1,g_doc_len]
   SELECT smyapr INTO l_smyapr
     FROM smy_file
    WHERE smyslip = l_t
   LET l_rvu.rvumksg = l_smyapr
   LET l_rvu.rvu111 = g_rva.rva111
   LET l_rvu.rvu112 = g_rva.rva112
   LET l_rvu.rvu115 = g_rva.rva115
   LET l_rvu.rvu12  = g_rva.rva116
   LET l_rvu.rvu113 = g_rva.rva113
   LET l_rvu.rvu114 = g_rva.rva114
   LET l_rvu.rvu27 = '1'  
   INSERT INTO rvu_file VALUES (l_rvu.*)
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg("rvu01",l_rvu.rvu01,"ins rvu:1",STATUS,1)
      ELSE
         CALL cl_err3("ins","rvu_file",l_rvu.rvu01,"",STATUS,"","ins rvu:1",1)
      END IF
      LET g_success='N'
  #ELSE
  #   #產生的入庫異動單
  #   CALL cl_err(l_rvu.rvu01,'apm-112',1)
   END IF
END FUNCTION
 
FUNCTION s_bart720_ins_rvv(p_tlfb07,p_tlfb08,p_rvv17)     
 DEFINE p_tlfb07  LIKE tlfb_file.tlfb07
 DEFINE p_tlfb08  LIKE tlfb_file.tlfb08
 DEFINE p_rvv17   LIKE rvv_file.rvv17
 DEFINE g_qcz     RECORD LIKE qcz_file.*
 DEFINE l_ima44   LIKE ima_file.ima44      
 DEFINE l_rvv     RECORD LIKE rvv_file.*
 DEFINE l_smy57   LIKE type_file.chr1
 DEFINE l_t       LIKE smy_file.smyslip
 DEFINE l_flag    LIKE type_file.num5      
 DEFINE l_sql     STRING  
 DEFINE l_rvb     RECORD LIKE rvb_file.*  
 DEFINE l_pmm43   LIKE pmm_file.pmm43      
 DEFINE l_cnt     LIKE type_file.num5      
 DEFINE l_gec05   LIKE gec_file.gec05      
 DEFINE l_gec07   LIKE gec_file.gec07      
 DEFINE l_rvw06f  LIKE rvw_file.rvw06f     
 DEFINE l_img09   LIKE img_file.img09
 DEFINE l_sw      LIKE type_file.num5

   INITIALIZE l_rvb.* TO NULL
   SELECT * INTO l_rvb.*
     FROM rvb_file
    WHERE rvb01 = p_tlfb07  #收貨單號
      AND rvb02 = p_tlfb08  #收貨項次
 
   LET l_rvv.rvv01 = g_rvu01 #入庫單號
 
   SELECT * INTO g_qcz.* FROM qcz_file WHERE qcz00='0'
 
   LET l_t = s_get_doc_no(g_rva.rva01)
 
   SELECT smy57[3,3] INTO l_smy57 FROM smy_file
    WHERE smyslip=l_t
 
 
   SELECT MAX(rvv02)+1 INTO l_rvv.rvv02 FROM rvv_file   #序號
    WHERE rvv01=l_rvv.rvv01
   LET l_rvv.rvv03='1'                                  #異動類別
   #這里可以直接用本次可入庫量來賦值
   LET l_rvv.rvv17 = p_rvv17
 
  ##暫不考慮雙單位
  #IF g_sma.sma115 = 'Y' THEN
  #   LET l_rvv.rvv80=l_rvb.rvb80
  #   LET l_rvv.rvv81=l_rvb.rvb81
  #   LET l_rvv.rvv82=g_in1          
  #   LET l_rvv.rvv83=l_rvb.rvb83
  #   LET l_rvv.rvv84=l_rvb.rvb84
  #   LET l_rvv.rvv85=g_in2          
  #END IF
   LET l_rvv.rvv86=l_rvb.rvb86
   LET l_rvv.rvv87=l_rvb.rvb87
 
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02=1 END IF
   LET l_rvv.rvv04=g_rva.rva01     #驗收單號
   LET l_rvv.rvv05=l_rvb.rvb02     #驗收項次
   LET l_rvv.rvv06=g_rva.rva05     #廠商
   LET l_rvv.rvv09=g_today         #異動日
   LET l_rvv.rvv18=l_rvb.rvb34     #工單編號
   LET l_rvv.rvv23=0               #已請款匹配數量
   LET l_rvv.rvv88=0               
   LET l_rvv.rvv24=NULL
   LET l_rvv.rvv25=l_rvb.rvb35     #樣品
   LET l_rvv.rvv26=NULL
   LET l_rvv.rvv31=l_rvb.rvb05     #料號
 
   LET l_rvv.rvv89=l_rvb.rvb89     #VMI收貨否 
 
   IF cl_null(l_rvv.rvv89) THEN
      LET l_rvv.rvv89 = 'N' 
   END IF
 
   SELECT ima44 INTO l_ima44 FROM ima_file WHERE ima01=l_rvv.rvv31
 
   IF l_rvb.rvb05[1,4]='MISC' THEN      #品名
      LET l_rvv.rvv031 = l_rvb.rvb051
   ELSE
      SELECT ima02 INTO l_rvv.rvv031 FROM ima_file
       WHERE ima01=l_rvb.rvb05
   END IF
 
   LET l_rvv.rvv32=l_rvb.rvb36     #倉庫
   LET l_rvv.rvv33=l_rvb.rvb37     #儲位
   LET l_rvv.rvv34=l_rvb.rvb38     #批號
   IF cl_null(l_rvv.rvv32) THEN LET l_rvv.rvv32=' ' END IF
   IF cl_null(l_rvv.rvv33) THEN LET l_rvv.rvv33=' ' END IF
   IF cl_null(l_rvv.rvv34) THEN LET l_rvv.rvv34=' ' END IF

   LET l_rvv.rvv35 = l_rvb.rvb90

   LET l_img09 = ''
   LET l_rvv.rvv35_fac = l_rvb.rvb90_fac

   IF cl_null(l_rvv.rvv35_fac) THEN
       SELECT img09 
         INTO l_img09 
         FROM img_file
       WHERE img01=l_rvv.rvv31 
         AND img02=l_rvv.rvv32
         AND img03=l_rvv.rvv33 
         AND img04=l_rvv.rvv34
       CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_img09)
            RETURNING l_sw,l_rvv.rvv35_fac
   END IF
   
 
  ##暫不考慮雙單位
  #IF g_sma.sma115='Y' THEN
  #   CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,   #FUN-A10130
  #                       l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
  #        RETURNING l_rvv.rvv87
  #ELSE
  #   CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17, #FUN-A10130
  #                       l_rvv.rvv86,1,l_rvv.rvv35)
  #        RETURNING l_rvv.rvv87
  #END IF
 
   LET l_flag=TRUE
 
  ##不須檢查img_file的合理性
  #IF NOT cl_null(l_rvv.rvv32) AND (g_sma.sma886[7,7] = 'Y') AND (l_flag) THEN  #FUN-810038
  #   SELECT img09 INTO g_img09_t FROM img_file
  #    WHERE img01 = l_rvv.rvv31
  #      AND img02 = l_rvv.rvv32
  #      AND img03 = l_rvv.rvv33
  #      AND img04 = l_rvv.rvv34
  #   CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,g_img09_t)
  #        RETURNING g_i,l_rvv.rvv35_fac
  #   IF g_i = 1 THEN
  #      ### ------單位無法轉換--------####
  #      IF g_bgerr THEN
  #         CALL s_errmsg("","","rvv35/img09: ","abm-731",1)
  #      ELSE
  #         CALL cl_err3("","","","","abm-731","","rvv35/img09: ",1)
  #      END IF
  #      LET g_success ='N'
  #      RETURN
  #   END IF
 
  #   LET g_ima906 = NULL
  #   LET g_ima907 = NULL
  #   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
  #    WHERE ima01=l_rvv.rvv31
 
  #   IF g_sma.sma115 = 'Y' AND g_ima906 MATCHES '[23]' THEN
  #      IF NOT cl_null(l_rvv.rvv83) THEN
  #         CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
  #                         l_rvv.rvv83) RETURNING g_flag
  #         IF g_flag = 1 THEN
  #            CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
  #                            l_rvv.rvv33,l_rvv.rvv34,
  #                            l_rvv.rvv83,l_rvv.rvv84,
  #                            l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
  #            IF g_flag = 1 THEN
  #               LET g_success = 'N'
  #               RETURN
  #            END IF
  #         END IF
 
  #         CALL s_du_umfchk(l_rvv.rvv31,'','','',l_ima44,l_rvv.rvv83,g_ima906)
  #              RETURNING g_errno,l_rvv.rvv84
 
  #         IF NOT cl_null(g_errno) THEN
  #            IF g_bgerr THEN
  #               CALL s_errmsg("","","rvv83/ima44: ","abm-731",1)
  #            ELSE
  #               CALL cl_err3("","","","","abm-731","","rvv83/ima44: ",1)
  #            END IF
  #            LET g_success = 'N' RETURN
  #         END IF
  #      END IF
 
  #      IF NOT cl_null(l_rvv.rvv80) AND g_ima906 = '2' THEN
  #         CALL s_chk_imgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
  #                         l_rvv.rvv80) RETURNING g_flag
  #         IF g_flag = 1 THEN
  #            CALL s_add_imgg(l_rvv.rvv31,l_rvv.rvv32,
  #                            l_rvv.rvv33,l_rvv.rvv34,
  #                            l_rvv.rvv80,l_rvv.rvv81,
  #                            l_rvv.rvv01,l_rvv.rvv02,0) RETURNING g_flag
  #            IF g_flag = 1 THEN
  #               LET g_success = 'N'
  #               RETURN
  #            END IF
  #         END IF
 
  #         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima44)
  #              RETURNING g_i,l_rvv.rvv81
  #         IF g_i = 1 THEN
  #            IF g_bgerr THEN
  #               CALL s_errmsg("","","rvv80/ima44: ","abm-731",1)
  #            ELSE
  #               CALL cl_err3("","","","","abm-731","","rvv80/ima44: ",1)
  #            END IF
  #            LET g_success = 'N' RETURN
  #         END IF
  #      END IF
 
  #      IF g_ima906 = '3' THEN
  #         IF l_rvv.rvv85 <> 0 THEN
  #            LET l_rvv.rvv84=l_rvv.rvv82/l_rvv.rvv85
  #         ELSE
  #            LET l_rvv.rvv84=0
  #         END IF
  #      END IF
  #   END IF
 
  #      IF g_sma.sma115='Y' THEN
  #         CALL t110sub_set_rvv87(l_rvv.rvv31,l_rvv.rvv84,l_rvv.rvv85,   #FUN-A10130
  #                             l_rvv.rvv81,l_rvv.rvv82,l_rvv.rvv86,0,'')
  #              RETURNING l_rvv.rvv87
  #      ELSE
  #         CALL t110sub_set_rvv87(l_rvv.rvv31,1,0,1,l_rvv.rvv17,  #FUN-A10130
  #                             l_rvv.rvv86,1,l_rvv.rvv35)
  #              RETURNING l_rvv.rvv87
  #      END IF
  #END IF
 
   IF cl_null(l_rvv.rvv86) THEN
      LET l_rvv.rvv86 = l_rvv.rvv35
      LET l_rvv.rvv87 = l_rvv.rvv17
   ELSE
   #入庫量=實收量,收貨計價數量給予入庫數量,避免計價數量在來源是調整後的值
   #而在入庫時又重推值
    IF l_rvv.rvv17=l_rvb.rvb07  THEN
       LET l_rvv.rvv87=l_rvb.rvb87
    END IF 
   END IF
 
   LET l_rvv.rvv36=l_rvb.rvb04     #採購單號
   LET l_rvv.rvv37=l_rvb.rvb03     #採購單序號
   LET l_rvv.rvv38=l_rvb.rvb10
   LET l_rvv.rvv38t=l_rvb.rvb10t   
   LET l_rvv.rvv39=l_rvv.rvv87*l_rvv.rvv38
   LET l_rvv.rvv39t=l_rvv.rvv87*l_rvv.rvv38t   
   LET l_rvv.rvv41=l_rvb.rvb25     #手冊編號 
   LET l_rvv.rvv930=l_rvb.rvb930  #成本中心 
   LET l_rvv.rvv10 = l_rvb.rvb42
   LET l_rvv.rvv11 = l_rvb.rvb43
   LET l_rvv.rvv12 = l_rvb.rvb44
   LET l_rvv.rvv13 = l_rvb.rvb45
   IF l_rvv.rvv10 IS NULL THEN LET l_rvv.rvv10 = '1' END IF
   LET t_azi04=''            
 
   IF g_argv6='1' THEN           
      SELECT azi04 INTO t_azi04  
        FROM pmm_file,azi_file
       WHERE pmm22=azi01
         AND pmm01 = l_rvv.rvv36 #採購單號
         AND pmm18 <> 'X'
   ELSE
      SELECT azi04 INTO t_azi04 
        FROM azi_file
       WHERE azi01=g_rva.rva113
   END IF
 
   IF cl_null(t_azi04) THEN  
      LET t_azi04=0   
   END IF
 
   CALL cl_digcut(l_rvv.rvv39,t_azi04) RETURNING l_rvv.rvv39   
   CALL cl_digcut(l_rvv.rvv39t,t_azi04) RETURNING l_rvv.rvv39t 
 
   IF g_argv6='1' THEN               
      #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
      SELECT gec05,gec07,pmm43 INTO l_gec05,l_gec07,l_pmm43 FROM gec_file,pmm_file       
       WHERE gec01 = pmm21
         AND pmm01 = l_rvv.rvv36
      IF SQLCA.SQLCODE = 100 THEN
         CALL cl_err('','mfg3192',0)
         LET g_success = 'N'
         RETURN
      END IF
      IF l_gec07='Y' THEN
        IF l_gec05  MATCHES '[AT]' THEN  
           LET l_rvv.rvv38 = l_rvv.rvv38t * ( 1 - l_pmm43/100) 
           LET l_rvv.rvv38 = cl_digcut(l_rvv.rvv38, t_azi03)   
           LET l_rvw06f = l_rvv.rvv39t * (l_pmm43/100)
           LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
           LET l_rvv.rvv39 = l_rvv.rvv39t - l_rvw06f 
           LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
        ELSE
           LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_pmm43/100)
           LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
        END IF 
      ELSE
         LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + l_pmm43/100)
         LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
      END IF
   ELSE
      SELECT gec07,gec05 INTO l_gec07,l_gec05 FROM gec_file   #CHI-AC0016 add gec05
       WHERE gec01 = g_rva.rva115
      IF SQLCA.SQLCODE = 100 THEN
         CALL cl_err('','mfg3192',0)
         LET g_success = 'N'
         RETURN
      END IF
      IF l_gec07='Y' THEN
         IF l_gec05  MATCHES '[AT]' THEN  #FUN-D10128  
            LET l_rvv.rvv38 = l_rvv.rvv38t * ( 1 - g_rva.rva116/100) 
            LET l_rvv.rvv38 = cl_digcut(l_rvv.rvv38, t_azi03)        
            LET l_rvw06f = l_rvv.rvv39t * (g_rva.rva116/100)
            LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
            LET l_rvv.rvv39 = l_rvv.rvv39t - l_rvw06f 
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
         ELSE
            LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + g_rva.rva116/100)
            LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)  
         END IF 
      ELSE
         LET l_rvv.rvv39t = l_rvv.rvv39 * ( 1 + g_rva.rva116/100)
         LET l_rvv.rvv39t = cl_digcut( l_rvv.rvv39t , t_azi04)  
      END IF
   END IF
   IF l_rvv.rvv25 = 'Y' THEN
      LET l_rvv.rvv38 = 0
      LET l_rvv.rvv38t = 0
      LET l_rvv.rvv39 = 0
      LET l_rvv.rvv39t = 0
   END IF
   LET l_rvv.rvv40 = 'N'
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF
 
 
   LET l_rvv.rvv88 = 0  
   LET l_rvv.rvvlegal = g_rva.rvalegal
   LET l_rvv.rvvplant = g_plant 
   LET l_rvv.rvvlegal = g_legal 
   LET l_rvv.rvv919 = l_rvb.rvb919            
  #LET l_rvv.rvv22 = g_rvb[l_ac].rvb22    #發票編號
   INSERT INTO rvv_file VALUES (l_rvv.*)
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = l_rvv.rvv01,"/",l_rvv.rvv02
         CALL s_errmsg("rvv01,rvv02",g_showmsg,"i rvv:",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","rvv_file",l_rvv.rvv01,l_rvv.rvv02,STATUS,"","i rvv:",1)
      END IF
      LET g_success='N'
      RETURN
   END IF

   #更新ibj_file
   UPDATE ibj_file  
      SET ibj10 = 'Y'
    WHERE ibj01 = '1'
     #AND ibj13 = g_user         #該USER的掃描資訊 #mark起來 原因:收貨和入庫的人應會不同
      AND ibj08 = l_rvv.rvv04    #收貨單號
      AND ibj09 = l_rvv.rvv05    #收貨單項次
      AND ibj03 = l_rvv.rvv32    #倉庫           
      AND ibj04 = l_rvv.rvv33    #儲位
   IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL cl_err('upd ibj err:',SQLCA.sqlcode,'1')
       RETURN
   END IF

   #更新tlfb_file
   UPDATE tlfb_file 
          SET tlfb09 = l_rvv.rvv01, #目的單號
              tlfb10 = l_rvv.rvv02  #目的項次
    WHERE tlfb07 = l_rvv.rvv04      #來源單號=收貨單號
      AND tlfb08 = l_rvv.rvv05      #來源項次=收貨單項次
      AND tlfb02 = l_rvv.rvv32
      AND tlfb03 = l_rvv.rvv33
      AND tlfb15 = g_tlfb15
      AND tlfb11 = 'abat071'        #程式代號
   IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       CALL cl_err('upd tlfb err:',SQLCA.sqlcode,'1')
       RETURN
   END IF
END FUNCTION
#DEV-D20007
#DEV-D30025--add

