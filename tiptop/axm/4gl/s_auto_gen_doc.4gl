# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern Name...: s_auto_gen_doc.4gl 
##SYNTAX        CALL s_auto_doc(p_zz01,p_oea01)
# Descriptions...: 單據自動化產生下游單據 
##PARAMETERS    p_zz01   程式代碼 (axmt410/axmt610/apmt420)(訂單/出通單/採購單)
##              p_oea01  單號
##              p_gfa03  產生的作業
##EXAMPLE       CALL s_auto_doc('axmt410','001-07030001','') 
# Date & Author..: NO.TQC-730022 07/03/09 By rainy   
# Note ..........: axmt410->apmt540/apmt420/asfi301/axmt610/axmt620
#                  axmt610->axmt620
#                  apmt420->apmt540
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構(沒改任何程式,過單用)
# Modify.........: No.MOD-740216 07/04/23 By kim 新增採購單身沒給pmn65
# Modify.........: No.MOD-740236 07/04/23 By Sarah 請購轉採購時,稅別(pmm21)塞錯成幣別
# Modify.........: No.MOD-740094 07/04/24 By rainy 請購轉採購時,若請購單無設定供應商,料件有設定供應商,會一起重復產生在未設定供應商的料件中
# Modify.........: No.MOD-740103 07/04/25 By rainy 重過
# Modify.........: No.TQC-740246 07/04/25 By rainy 請購轉採購時，請購特別說明沒轉到
# Modify.........: No.TQC-740226 07/05/02 By rainy 請購轉採購時，如單頭沒供應商，且單身的料無設定主供應商，則不可拋轉
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.TQC-760044 07/06/15 By rainy 1.確認後可自動拋轉採購單,拋轉OK後應更新apmt420單身轉採購量[pml21]
#                                                  2.是否應同apmp570/apmp500一樣,當單身統購否pml190='N'才可拋轉採購單
# Modify.........: No.TQC-790002 07/09/03 By Sarah Primary Key：複合key在INSERT INTO table前需增加判斷，如果是NULL就給值blank(字串型態) or 0(數值型態)
# Modify.........: No.MOD-730044 07/09/27 By claire 交易單位(pmn86)與採購單位(ima44)或計價單位(ima908)的轉換
# Modify.........: No.MOD-810181 08/01/22 By ve007 s_defprice()增加一個參數  
# Modify.........: No.FUN-7B0018 08/03/06 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.FUN-940083 09/06/22 By douzh VMI采購改善
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.FUN-980010 09/08/24 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No.FUN-9B0016 09/10/31 By post no  
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No.FUN-A60076 10/07/02 By vealxu 製造功能優化-平行製程
# Modify.........: No.TQC-AB0397 10/12/02 By wangxin1 p_auto_doc有設置開窗詢問自動產生採購單別，選單別畫面時點擊放棄，應該不走下面產生採購單邏輯了
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:MOD-B30397 11/03/14 By Summer 自動轉入採購單，保稅欄位應帶入料件資料中的保稅料件(ima15)資料
# Modify.........: No:FUN-B70015 11/07/07 By yangxf 經營方式默認給值'1'經銷  
# Modify.........: No:FUN-BB0085 11/11/22 By xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-BB0084 11/11/24 By lixh1 增加數量欄位小數取位
# Modify.........: No:MOD-C30011 12/06/07 By Vampire 有設定 p_auto_doc  請購轉採購，請購確認後會轉採購，單頭跟單身的狀況碼要一併處理
# Modify.........: No:FUN-D40042 13/04/15 By fengrui 請購單轉採購時，請購單備註pml06帶入採購單備註pmn100

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#訂單檔案
DEFINE  g_oea  RECORD  LIKE oea_file.*,
        g_oeb  RECORD  LIKE oeb_file.*
#出通單檔案
DEFINE  g_oga  RECORD  LIKE oga_file.*,   #NO.FUN-9B0016
        g_ogb  RECORD  LIKE ogb_file.*
#請購單檔案
DEFINE  g_pmk  RECORD  LIKE pmk_file.*,
        g_pml  RECORD  LIKE pml_file.*
 
#採購單檔案        
DEFINE  g_pmm  RECORD  LIKE pmm_file.*,
        g_pmn  RECORD  LIKE pmn_file.*
#工單檔案
DEFINE  g_sfb  RECORD  LIKE sfb_file.*,
        g_sfa  RECORD  LIKE sfa_file.*
#出貨單
DEFINE  g_oga2  RECORD  LIKE oga_file.*,
        g_ogb2  RECORD  LIKE ogb_file.*
#單據自動化設定檔
DEFINE  g_gfa   RECORD  LIKE gfa_file.*
 
DEFINE  g_ima   RECORD  LIKE ima_file.*
DEFINE  g_buf   LIKE  oay_file.oayslip,
        g_buf2  LIKE  oay_file.oayslip,
        g_sql   STRING,        
        g_msg   STRING,
        g_rec_b LIKE  type_file.num5,
        g_i     LIKE  type_file.num5,
        g_gfa03 LIKE  gfa_file.gfa03,
        g_progno LIKE zz_file.zz01,
        g_taskno LIKE type_file.chr1,
        g_cnt   LIKE type_file.num5,
        g_bno   LIKE oea_file.oea01,
        g_eno   LIKE oea_file.oea01
 
FUNCTION s_auto_gen_doc(p_zz01,p_oea01,p_gfa03)
    DEFINE p_zz01   LIKE   zz_file.zz01,
           p_oea01  LIKE   oea_file.oea01,
           p_gfa03  LIKE   gfa_file.gfa03
   
    DEFINE l_cnt    LIKE type_file.num5
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF s_shut(0) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_success = 'Y'
   LET g_progno = p_zz01
   #截取單據別
   LET g_buf = s_get_doc_no(p_oea01)
 
   CASE p_zz01
     WHEN "axmt410"  LET g_taskno = "1"
     WHEN "axmt610"  LET g_taskno = "2"
     WHEN "apmt420"  LET g_taskno = "3"
   END CASE
 
   IF cl_null(p_gfa03) THEN  #p_gfa03沒傳值表示由確認自動產生單據
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM gfa_file
       WHERE gfa01 = g_taskno
         AND gfa02 = g_buf
  
         IF l_cnt = 0 THEN LET g_success = 'N' RETURN END IF
 
      #取自動化設定值
      SELECT * INTO g_gfa.*  FROM gfa_file
       WHERE gfa01 = g_taskno
         AND gfa02 = g_buf
         AND gfaacti = 'Y'
      LET g_gfa03 = g_gfa.gfa03
   ELSE 
      LET g_gfa03 = p_gfa03
   END IF
 
 
   IF cl_null(p_gfa03) THEN
      IF g_gfa.gfa04 = '2' THEN
         CASE g_gfa03
           WHEN "apmt420"  #是否產生請購單
                IF NOT cl_confirm('axm-591') THEN
                   LET g_success = 'N'
                   RETURN 
                END IF
           WHEN "apmt540"  #是否產生採購單
                IF NOT cl_confirm('axm-592') THEN
                   LET g_success = 'N'
                   RETURN 
                END IF
           WHEN "asfi301"  #是否產生工單
                IF NOT cl_confirm('axm-593') THEN
                   LET g_success = 'N'
                   RETURN 
                END IF
           WHEN "axmt610"  #是否產生出通單
                IF NOT cl_confirm('axm-594') THEN
                   LET g_success = 'N'
                   RETURN 
                END IF
           WHEN "axmt620"  #是否產生出貨單
                IF NOT cl_confirm('axm-595') THEN
                   LET g_success = 'N'
                   RETURN 
                END IF
         END CASE 
         CALL s_auto_gen_doc_tm()
      ELSE
         LET g_buf2 = g_gfa.gfa05
      END IF
   END IF

#TQC-AB0397 ---begin---
#p_auto_doc有設置開窗詢問自動產生採購單別，選單別畫面時點擊放棄，應該不走下面產生採購單邏輯了
   IF g_success = 'N' THEN
      RETURN
   END IF
#TQC-AB0397 -----end---
 
  #抓來源資料
   CASE p_zz01
     WHEN "axmt410"
        CALL s_auto_gen_doc_get_oea(p_oea01)
     WHEN "axmt610"  #出通單轉出貨單
        CALL s_auto_gen_doc_get_oga(p_oea01)
     WHEN "apmt420"       #請購轉採購
        CALL s_auto_gen_doc_get_pmk(p_oea01)
   END CASE
 
  #拋轉資料
   CASE g_gfa03
     WHEN "apmt420"  #產生請購單
        CALL s_auto_gen_apmt420(p_oea01)
     WHEN "apmt540"  #產生採購單
        CALL s_auto_gen_apmt540(p_oea01)
     WHEN "asfi301"  #產生工單
       CALL s_auto_gen_asfi301(p_oea01)
     WHEN "axmt610"  #轉出通單
       CALL s_auto_gen_axmt610(p_oea01)
     WHEN "axmt620"  #轉出貨單
       CALL s_auto_gen_axmt620(p_oea01)
   END CASE 
END FUNCTION
 
 
#開窗詢問單據別
FUNCTION s_auto_gen_doc_tm()
  DEFINE tm RECORD
         slip     LIKE oay_file.oayslip  
         END RECORD 
  DEFINE l_n      LIKE type_file.num5
  DEFINE l_oayapr     LIKE oay_file.oayapr
  DEFINE p_row,p_col LIKE type_file.num5
 
  LET l_oayapr = ' '
  LET p_row = 5 LET p_col = 11
  
  OPEN WINDOW s_auto_gen_doc_w AT p_row,p_col WITH FORM "sub/42f/s_auto_gen_doc"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
     CALL cl_ui_locale("s_auto_gen_doc")
  
     LET tm.slip = g_gfa.gfa05
     INPUT BY NAME tm.slip  WITHOUT DEFAULTS
        AFTER FIELD slip
           IF NOT cl_null(tm.slip) THEN  
              CASE g_gfa03
                WHEN "apmt420"  #請購單
                  SELECT COUNT(*) INTO l_n FROM smy_file 
                   WHERE smyslip = tm.slip 
                     AND upper(smysys)  = 'APM'
                     AND smykind = '1'
 
                WHEN "apmt540"  #採購單
                  SELECT COUNT(*) INTO l_n FROM smy_file 
                   WHERE smyslip = tm.slip 
                     AND upper(smysys)  = 'APM'
                     AND smykind = '2'
 
                WHEN "asfi301"  #工單
                  SELECT COUNT(*) INTO l_n FROM smy_file 
                   WHERE smyslip = tm.slip
                     AND upper(smysys)  = 'ASF'
                     AND smykind = '1'
 
                WHEN "axmt410"  #訂單
                  SELECT COUNT(*) INTO l_n FROM oay_file 
                   WHERE oayslip = tm.slip
                     AND oaytype = '30'
 
                WHEN "axmt610"  #出通單
                  SELECT COUNT(*) INTO l_n FROM oay_file 
                   WHERE oayslip = tm.slip 
                     AND oaytype = '40'
 
                WHEN "axmt620"  #出貨單
                  SELECT COUNT(*) INTO l_n FROM oay_file 
                   WHERE oayslip = tm.slip 
                     AND oaytype = '50'
              END CASE
              IF SQLCA.sqlcode OR cl_null(tm.slip) THEN  
                 LET l_n = 0
              END IF
              IF l_n = 0 THEN
                 CALL cl_err(tm.slip,'aap-010',0)       
                 NEXT FIELD slip
              END IF
              CASE g_gfa03
                WHEN "apmt420"  #請購單
                  SELECT smyapr INTO l_oayapr 
                    FROM smy_file
                   WHERE smyslip = tm.slip
                     AND upper(smysys)  = 'APM'
                     AND smykind = '1'
 
                WHEN "apmt540"  #採購單
                  SELECT smyapr INTO l_oayapr 
                    FROM smy_file
                   WHERE smyslip = tm.slip
                     AND upper(smysys)  = 'APM'
                     AND smykind = '2'
 
                WHEN "asfi301"  #工單
                  SELECT smyapr INTO l_oayapr 
                    FROM smy_file
                   WHERE smyslip = tm.slip
                     AND upper(smysys)  = 'ASF'
                     AND smykind = '1'
 
                WHEN "axmt410"  #訂單
                  SELECT oayapr INTO l_oayapr 
                    FROM oay_file
                   WHERE oayslip = tm.slip 
                     AND oaytype = '30'
 
                WHEN "axmt610"  #出通單
                  SELECT oayapr INTO l_oayapr 
                    FROM oay_file
                   WHERE oayslip = tm.slip 
                     AND oaytype = '40'
 
                WHEN "axmt620"  #出貨單
                  SELECT oayapr INTO l_oayapr 
                    FROM oay_file
                   WHERE oayslip = tm.slip 
                     AND oaytype = '50'
              END CASE
 
              IF  l_oayapr = 'Y' THEN  #來原單據別不可為要簽核的
                CALL cl_err(tm.slip,'azz-260',1)
                NEXT FIELD slip
              END IF
           END IF
           LET g_buf2 = tm.slip
  
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_success = 'N'
           CLOSE WINDOW s_auto_gen_doc_w
           RETURN
        END IF
  
        ON ACTION controlp
           CASE
              WHEN INFIELD(slip)
                  CASE g_gfa03
                    WHEN "apmt420" #請購單  
                      CALL q_smy(FALSE,FALSE,'','APM','1') 
                         RETURNING tm.slip
 
                    WHEN "apmt540" #採購單  
                      CALL q_smy(FALSE,FALSE,'','APM','2') 
                         RETURNING tm.slip
 
                    WHEN "asfi301" #工單 
                      CALL q_smy(FALSE,FALSE,'','ASF','1') 
                         RETURNING tm.slip
 
                    WHEN "axmt610" #出通單
                      CALL q_oay(FALSE,FALSE,'','40','AXM')  
                         RETURNING tm.slip
 
                    WHEN "axmt620" #出貨單
                      CALL q_oay(FALSE,FALSE,'','50','AXM')   
                         RETURNING tm.slip
                  END CASE
                   DISPLAY BY NAME tm.slip   
                   NEXT FIELD slip
              OTHERWISE EXIT CASE
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
        LET INT_FLAG = 0
        LET g_success = 'N'
        CLOSE WINDOW s_auto_gen_doc_w
        RETURN
     END IF
 
     LET g_buf2 = tm.slip
 
     CLOSE WINDOW s_auto_gen_doc_w
END FUNCTION
 
###截取來源資料
#訂單資料 
FUNCTION s_auto_gen_doc_get_oea(p_oea01)
  DEFINE p_oea01  LIKE  oea_file.oea01
 
  INITIALIZE g_oea.* TO NULL
 
  SELECT * INTO g_oea.* FROM oea_file
   WHERE oea01 = p_oea01
END FUNCTION
 
#出通單資料
FUNCTION s_auto_gen_doc_get_oga(p_oga01)
  DEFINE p_oga01  LIKE  oga_file.oga01
 
  INITIALIZE g_oga.* TO NULL
  SELECT * INTO g_oga.*  FROM oga_file
   WHERE oga01 = p_oga01
END FUNCTION
 
#請購單資料
FUNCTION s_auto_gen_doc_get_pmk(p_pmk01)
  DEFINE p_pmk01  LIKE  pmk_file.pmk01
 
  INITIALIZE g_pmk.* TO NULL
 
  SELECT * INTO g_pmk.* FROM pmk_file
   WHERE pmk01 = p_pmk01
END FUNCTION
######
 
 
 
 
#FUNCTION s_gen_gfb()
#  DEFINE  l_oeb05          LIKE  oeb_file.oeb05,
#          l_ima55          LIKE  ima_file.ima55,
#          l_ima562         LIKE  ima_file.ima562,
#          l_ima60          LIKE  ima_file.ima60
#  DEFINE  l_ima55_fac      LIKE ima_file.ima55_fac
#  DEFINE  l_time           LIKE ima_file.ima58   
#  DEFINE  l_cn,s_date      LIKE type_file.num5    
#  DEFINE   l_costcenter    LIKE gem_file.gem01 
#          
#
#  DEFINE  new DYNAMIC ARRAY OF RECORD
#                oeb03         LIKE oeb_file.oeb03,
#                new_part      LIKE ima_file.ima01,    
#                ima02         LIKE ima_file.ima02,
#                ima910        LIKE ima_file.ima910,   
#                new_qty       LIKE sfb_file.sfb08,    
#                b_date        LIKE type_file.dat,     
#                e_date        LIKE type_file.dat,     
#                sfb02         LIKE sfb_file.sfb02,    
#                new_no        LIKE oea_file.oea01,     
#                ven_no        LIKE pmc_file.pmc01,    
#                a             LIKE type_file.chr1,    
#                costcenter    LIKE gem_file.gem01, 
#                gem02c        LIKE gem_file.gem02  
#                END RECORD
#
#      LET l_costcenter=s_costcenter(g_grup) 
#      LET g_sql = "SELECT oeb03,oeb04,ima02,ima910,oeb12-oeb905,0,oeb15, ",
#                  " '1',ima111,' ','Y','','',oeb05,ima55,(1+ima562),ima60 ", 
#                  " FROM oeb_file,ima_file ",       
#                  " WHERE oeb01 = '",g_oea.oea01,"' ",
#                  "  AND oeb12>(oeb24-oeb25+oeb905) ",  
#                  "  AND oeb04 = ima01 ",
#                  "  AND ima911<>'Y' "  #FUN-640083
#      PREPARE q_oeb_prepare FROM g_sql
#      DECLARE oeb_curs CURSOR FOR q_oeb_prepare
#      LET g_i=1
#      FOREACH oeb_curs INTO new[g_i].*,l_oeb05,l_ima55,l_ima562,l_ima60    
#         IF STATUS THEN
#            EXIT FOREACH
#         END IF
#
#         LET new[g_i].new_no = g_buf2
#
#         LET l_sfb08 = 0
#         CALL s_umfchk(new[g_i].new_part,l_oeb05,l_ima55)
#                            RETURNING l_check,l_ima55_fac
#         LET new[g_i].new_qty = new[g_i].new_qty * l_ima55_fac * l_ima562
#         IF cl_null(l_ima55_fac) THEN 
#            LET l_ima55_fac = 1
#         END IF
#
#        ##-計算開工日
#         LET g_ima.ima62 = 0
#          SELECT ima62,ima59,ima61 INTO g_ima.ima62,l_ima59,l_ima61 
#            FROM ima_file 
#          WHERE ima01 = new[g_i].new_part
#         IF new[g_i].e_date IS NULL THEN
#            LET new[g_i].e_date = 0
#         END IF
#         LET l_time= (new[g_i].new_qty * l_ima60)+ l_ima59 + l_ima61 
#         IF cl_null(l_time) THEN
#            LET l_time=0
#         END IF
#         LET s_date=l_time+0.5
#         IF cl_null(s_date) THEN
#            LET s_date=0 
#         END IF
#
#         LET new[g_i].b_date=new[g_i].e_date - s_date
#
#      #--MOD-530799 計算開工日時須扣掉非工作日
#         SELECT COUNT(*) INTO l_cn FROM sme_file
#            WHERE sme01 BETWEEN new[g_i].b_date AND new[g_i].e_date AND sme02 ='N'
#         IF cl_null(l_cn) THEN
#            LET l_cn=0
#         END IF
#         LET new[g_i].b_date = new[g_i].b_date - l_cn
#      #--end
#
#         IF new[g_i].b_date < g_sfb.sfb81 THEN
#            LET new[g_i].b_date = g_sfb.sfb81
#         END IF
#         IF new[g_i].b_date > new[g_i].e_date THEN 
#            LET new[g_i].e_date = new[g_i].b_date
#         END IF
#         LET new[g_i].costcenter=l_costcenter  
#         LET new[g_i].gem02c=g_grup  
#         LET g_i=g_i+1
#      END FOREACH
#      CALL new.deleteElement(g_i) 
#      LET g_i=g_i-1
#
#
#
#END FUNCTION
 
##拋轉工單
##來源：axmt410(訂單)
FUNCTION s_auto_gen_asfi301(p_no)
  DEFINE p_no    LIKE oea_file.oea01 
 
  IF g_progno = 'axmt410' THEN
    #參asfp304    #訂單轉工單
    LET g_msg = " asfp304 '",p_no,"' '",g_buf2, "' '",g_gfa.gfa06,"' 'Y'"
    CALL cl_cmdrun(g_msg)
  END IF
END FUNCTION
 
#拋轉請購單
#來源：axmt410(訂單)
FUNCTION s_auto_gen_apmt420(p_no)
  DEFINE p_no    LIKE oea_file.oea01 
 
  IF g_progno = "axmt410" THEN
    CALL t400sub_exp(p_no,"A",g_buf2)
  END IF
END FUNCTION
 
 
 
#拋轉採購單
#來源：axmt410/apmt420(訂單/請購單)
FUNCTION s_auto_gen_apmt540(p_no)
  DEFINE p_no    LIKE oea_file.oea01 
  DEFINE l_msg   STRING
 
  CASE g_progno 
    WHEN "axmt410"
      #CALL saxmt400的t400_exp_po()
      CALL t400sub_exp_po(p_no,"A",g_buf2)
    WHEN "apmt420" 
      LET g_success = 'Y'
      BEGIN WORK
      LET g_bno = ''
      LET g_eno = ''
      CALL s_auto_gen_doc_ins_pmm() 
      IF g_success = 'N' THEN
        ROLLBACK WORK
      ELSE
 
        COMMIT WORK
      END IF
  END CASE
END FUNCTION
 
#拋轉出通單
#來源：axmt410(訂單)
FUNCTION s_auto_gen_axmt610(p_no)
  DEFINE p_no    LIKE oea_file.oea01 
  IF g_progno = "axmt410" THEN
      LET g_msg = " atmp201 '2' '",g_oea.oea00,"' '",p_no,"' ", "'",g_buf2,"' 'A' ","'Y' '",g_gfa.gfa06,"'"
      CALL cl_cmdrun(g_msg)
  END IF
END FUNCTION
 
#拋轉出貨單
#來源：axmt410/axmt610(訂單/出通單)
FUNCTION s_auto_gen_axmt620(p_no)
  DEFINE p_no    LIKE oea_file.oea01 
  CASE g_progno
    WHEN "axmt410"
      LET g_msg = " atmp201 '1' '",g_oea.oea00,"' '",p_no,"' ", "'",g_buf2,"' 'A' ","'Y' '",g_gfa.gfa06,"'"
      CALL cl_cmdrun(g_msg)
 
    WHEN "axmt610"
        #LET g_msg = " axmp620 '",p_no,"' ","'",g_today,"' ", "'",g_buf2,"' ","'Y' '",g_gfa.gfa06,"'"
      LET g_msg = " atmp201 '3' '",g_oga.oga00,"' '",p_no,"' ", "'",g_buf2,"' 'A' ","'Y' '",g_gfa.gfa06,"'"
      CALL cl_cmdrun(g_msg)
  END CASE
END FUNCTION 
 
 
 
#insert 採購單
FUNCTION s_auto_gen_doc_ins_pmm()
  DEFINE l_ima54    LIKE ima_file.ima54
  DEFINE l_i ,l_n   LIKE type_file.num5
  DEFINE l_pmm01  DYNAMIC ARRAY OF LIKE pmm_file.pmm01
  DEFINE l_cnt      LIKE type_file.num5   #TQC-740226 add
 
  LET g_msg = ''
  LET l_i = 0
  IF cl_null(g_pmk.pmk09) THEN  #無供應商，要拆料件的主供應商
    #TQC-740226 begin
     #如單頭無供應商，則單身每筆料一定要有主供應商，不然不可拋轉
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM pml_file,ima_file 
      WHERE pml04 = ima01 
        AND pml01 = g_pmk.pmk01 
        AND pml190='N'     #TQC-760044
        AND ima54 IS NULL
     IF l_cnt > 0 THEN
       CALL cl_err('','apm-571',1)  
       RETURN
     END IF
    #TQC-740226 end    
    LET g_sql = "SELECT DISTINCT ima54  FROM ima_file,pml_file ",
                " WHERE ima01 = pml04 ",
                " AND pml01 ='", g_pmk.pmk01 CLIPPED,"'",
                " AND pml190 = 'N'"   #TQC-760044
     PREPARE ima54_prepare1 FROM g_sql
     DECLARE ima54_cur CURSOR FOR ima54_prepare1
     FOREACH ima54_cur INTO l_ima54
        CALL s_auto_gen_doc_set_pmm(l_ima54)
        CALL s_auto_assign_no("apm",g_buf2,g_pmm.pmm04,"2","pmm_file","pmm01","","","") 
           RETURNING g_cnt,g_pmm.pmm01
        IF (NOT g_cnt) THEN 
           LET g_success = 'N'
           RETURN 
        END IF
 
        IF cl_null(g_bno) THEN
          LET g_bno = g_pmm.pmm01
        END IF
        LET g_eno = g_pmm.pmm01
#       LET g_pmm.pmm51 =  ' '   #NO.FUN-960130    #FUN-B70015  mark
        LET g_pmm.pmm51 =  '1'   #FUN-B70015
        LET g_pmm.pmmpos = 'N'   #NO.FUN-960130
 
        #FUN-980010 add plant & legal 
        LET g_pmm.pmmplant = g_plant 
        LET g_pmm.pmmlegal = g_legal 
        #FUN-980010 end plant & legal 
 
        LET g_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
        LET g_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO pmm_file VALUES (g_pmm.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)
           LET g_success = 'N' 
        END IF
        CALL s_auto_gen_doc_ins_pmn(l_ima54)
        CALL s_auto_gen_doc_ins_pmo()   #TQC-740246
        CALL s_auto_gen_doc_upd_pmm()
        #處理自動確認段
         IF g_success = 'Y' THEN
            LET l_i = l_i + 1
            LET l_pmm01[l_i] = g_pmm.pmm01
         END IF
     END FOREACH
  ELSE
    CALL s_auto_gen_doc_set_pmm('')  
    CALL s_auto_assign_no("apm",g_buf2,g_pmm.pmm04,"2","pmm_file","pmm01","","","") 
       RETURNING g_cnt,g_pmm.pmm01
    IF (NOT g_cnt) THEN 
       LET g_success = 'N'
       RETURN 
    END IF
 
    IF cl_null(g_bno) THEN
      LET g_bno = g_pmm.pmm01
    END IF
    LET g_eno = g_pmm.pmm01
#   LET g_pmm.pmm51 =  ' '   #NO.FUN-960130     #FUN-B70015  mark
    LET g_pmm.pmm51 =  '1'   #FUN-B70015
    LET g_pmm.pmmpos = 'N'   #NO.FUN-960130
 
    #FUN-980010 add plant & legal 
    LET g_pmm.pmmplant = g_plant 
    LET g_pmm.pmmlegal = g_legal 
    #FUN-980010 end plant & legal 
 
    INSERT INTO pmm_file VALUES (g_pmm.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    #CALL s_auto_gen_doc_ins_pmn('')    #MOD-740094
    CALL s_auto_gen_doc_ins_pmn('@')    #MOD-740094
    CALL s_auto_gen_doc_ins_pmo()   #TQC-740246
    CALL s_auto_gen_doc_upd_pmm()
    #處理自動確認段
     IF g_success = 'Y' THEN
        LET l_i = 1
        LET l_pmm01[l_i] = g_pmm.pmm01
     END IF
  END IF
  LET g_msg = ''
  IF cl_null(g_eno) THEN
    LET g_msg= g_bno
  ELSE
    LET g_msg = g_bno,"~",g_eno
  END IF
  IF NOT cl_null(g_msg) THEN
     LET g_msg = g_msg CLIPPED
     CALL cl_err(g_msg,'mfg0101',0)
  END IF       
 
  FOR l_n = 1 TO l_i
    CALL s_auto_pmm_confirm(l_pmm01[l_n])
  END FOR
END FUNCTION
 
FUNCTION s_auto_gen_doc_ins_pmo()
   DEFINE  g_pmp   RECORD  LIKE  pmp_file.*,
           g_pmo   RECORD  LIKE  pmo_file.*,
           l_pmp,l_pmo     LIKE type_file.num5,
           l_pmo03         LIKE pmo_file.pmo03
 
    #----- insert 重要備註檔(單頭)
   LET g_sql = "SELECT pmp01,pmp02,pmp03,pmp04,pmp05 ",
               " FROM pmp_file ",
               " WHERE pmp01 ='",g_pmk.pmk01,"' ",
               "       AND pmp02='0' ",
               " ORDER BY 1"
   PREPARE pmp_pre FROM g_sql
   DECLARE pmp_cs CURSOR FOR pmp_pre    #CURSOR
 
   SELECT COUNT(*) INTO l_pmp
      FROM pmp_file WHERE pmp01=g_pmm.pmm01 AND pmp02='1'
   IF l_pmp <= 0 THEN
      FOREACH pmp_cs INTO g_pmp.*
       LET g_pmp.pmp01=g_pmm.pmm01
         LET g_pmp.pmp02='1'
 
         #FUN-980010 add plant & legal 
         LET g_pmp.pmpplant = g_plant 
         LET g_pmp.pmplegal = g_legal 
         #FUN-980010 end plant & legal 
 
         INSERT INTO pmp_file VALUES (g_pmp.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
      LET l_pmp=1
   END IF
    #----- insert 特殊說明檔(單頭)
   LET g_sql = "SELECT pmo01,pmo02,pmo03,pmo04,pmo05,pmo06 ",
                " FROM pmo_file ",
                " WHERE pmo01 ='",g_pmk.pmk01,"' ",
                "   AND pmo02='0' AND pmo03=0 ",
                " ORDER BY 1"
   PREPARE pmo_pre FROM g_sql
   DECLARE pmo_cs  CURSOR FOR pmo_pre  #CURSOR
   SELECT COUNT(*) INTO l_pmo FROM pmo_file
      WHERE pmo01=g_pmm.pmm01 AND pmo02='1' AND pmo03='0'
   IF l_pmo <= 0 THEN
      FOREACH pmo_cs INTO g_pmo.*          #單身 ARRAY 填充
         LET g_pmo.pmo01=g_pmm.pmm01
         LET g_pmo.pmo02='1'
         LET g_pmo.pmo03=0
 
         #FUN-980010 add plant & legal 
         LET g_pmo.pmoplant = g_plant 
         LET g_pmo.pmolegal = g_legal 
         #FUN-980010 end plant & legal 
 
         INSERT INTO pmo_file VALUES (g_pmo.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err3("ins","pmo_file",g_pmo.pmo01,g_pmo.pmo02,SQLCA.sqlcode,"","ins pmo",1)
            RETURN
         END IF
      END FOREACH
      LET l_pmo=1
   END IF
 #----- insert 特殊說明檔(單身)
   LET g_sql = "SELECT pmo01,pmo02,pmo03,pmo04,pmo05,pmo06 ",
                " FROM pmo_file ",
                " WHERE pmo01 ='",g_pmk.pmk01,"' ",
                "   AND pmo02='0' AND pmo03 <> 0",
                " ORDER BY 1"
   PREPARE pmo_pre2 FROM g_sql
   DECLARE pmo_cs2 CURSOR FOR pmo_pre2  #CURSOR
   FOREACH pmo_cs2 INTO g_pmo.*          #單身 ARRAY 填充
     SELECT pmn02 INTO  l_pmo03  FROM pmn_file
      WHERE pmn24 = g_pmk.pmk01  AND  pmn25 = g_pmo.pmo03
 
     LET g_pmo.pmo01=g_pmm.pmm01
     LET g_pmo.pmo02='1'
     LET g_pmo.pmo03=l_pmo03
 
     #FUN-980010 add plant & legal 
     LET g_pmo.pmoplant = g_plant 
     LET g_pmo.pmolegal = g_legal 
     #FUN-980010 end plant & legal 
 
     INSERT INTO pmo_file VALUES (g_pmo.*)
     IF SQLCA.sqlcode THEN
        LET g_success='N'
        CALL cl_err3("ins","pmo_file",g_pmo.pmo01,g_pmo.pmo02,SQLCA.sqlcode,"","ins pmo",1)
        RETURN
     END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_auto_pmm_confirm(p_pmm01) 
  DEFINE p_pmm01        LIKE pmm_file.pmm01
 
   IF g_gfa.gfa06 = 'Y' THEN
      #CALL apmt540的確認段
      CALL t540sub_y_chk(g_pmm.*)          #CALL 原確認的 check 段
      IF g_success = "Y" THEN
         CALL t540sub_y_upd(p_pmm01,'')       #CALL 原確認的 update 段 #FUN-740034
      END IF
   END IF
END FUNCTION
 
FUNCTION s_auto_gen_doc_ins_pmn(p_pmk09)
  DEFINE p_pmk09  LIKE pmk_file.pmk09
  DEFINE l_pmn02  LIKE pmn_file.pmn02
  DEFINE l_pmc914 LIKE pmc_file.pmc914          #No.FUN-9A0068
  DEFINE l_pmni   RECORD LIKE pmni_file.*       #No.FUN-7B0018
 
  LET g_sql = "SELECT * FROM pml_file,ima_file ",
              " WHERE pml01 ='",g_pmk.pmk01,"'",
              "   AND pml04 = ima01 ",
              "   AND pml190='N'"     #TQC-760044
 #MOD-740094 begin
  #IF NOT cl_null(p_pmk09) THEN
  #  LET g_sql = g_sql ," AND ima54 ='",p_pmk09 CLIPPED,"'"
  #END IF
  IF NOT cl_null(p_pmk09) THEN
    IF p_pmk09 <> "@" THEN       #MOD-740094  "@"代表請購單上有指定供應商，所以不用再以供應商過濾資料，全部抓出來
      LET g_sql = g_sql ," AND ima54 ='",p_pmk09 CLIPPED,"'"
    END IF
  ELSE                           
    LET g_sql = g_sql ," AND (ima54 ='' OR ima54 IS NULL) "
  END IF
 #MOD-740094 end
 
  PREPARE get_pml_prepare1 FROM g_sql
  DECLARE get_pml_cur CURSOR FOR get_pml_prepare1
  LET l_pmn02 = 0
  FOREACH get_pml_cur INTO g_pml.*
    INITIALIZE g_pmn.* TO NULL
    LET l_pmn02 = l_pmn02 + 1
    LET g_pmn.pmn01 = g_pmm.pmm01
    LET g_pmn.pmn02 = l_pmn02
  ##NO.FUN-9A0068 GP5.2 add--begin
    SELECT pmc914 INTO l_pmc914 FROM pmc_file
     WHERE pmc01 = p_pmk09    
      IF l_pmc914 = 'Y'  THEN
        LET g_pmn.pmn89 = 'Y'
      ELSE 
        LET g_pmn.pmn89 = 'N'
      END IF 
  ##NO.FUN-9A0068 GP5.2 add--end
    CALL s_auto_gen_doc_set_pmn()
    IF cl_null(g_pmn.pmn02) THEN LET g_pmn.pmn02 = 0 END IF   #TQC-790002 add
    #LET g_pmn.pmn73 = ' '   #NO.FUN-960130
    IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 = '4' END IF  #TQC-AC0257 add
    #FUN-980010 add plant & legal 
    LET g_pmn.pmnplant = g_plant 
    LET g_pmn.pmnlegal = g_legal 
    #FUN-980010 end plant & legal 
 
    IF cl_null(g_pmn.pmn58) THEN LET g_pmn.pmn58 = 0 END IF   #TQC-9B0203
    IF cl_null(g_pmn.pmn012) THEN LET g_pmn.pmn012 = ' ' END IF #FUN-A60076 
    INSERT INTO pmn_file VALUES (g_pmn.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","pmn_file",g_pmn.pmn01,g_pmn.pmn02,SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
       EXIT FOREACH
    #No.FUN-7B0018 080306 add --begin
    ELSE
       IF NOT s_industry('std') THEN
          INITIALIZE l_pmni.* TO NULL
          LET l_pmni.pmni01 = g_pmn.pmn01
          LET l_pmni.pmni02 = g_pmn.pmn02
          IF NOT s_ins_pmni(l_pmni.*,'') THEN
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       END IF
    #No.FUN-7B0018 080306 add --end
    END IF
    LET g_pmn.pmn20 =s_digqty(g_pmn.pmn20,g_pml.pml07)   #FUN-BB0085
  #TQC-760044 begin
    #UPDATE 回pml
    UPDATE pml_file SET pml21 = g_pmn.pmn20,pml16 = '2' #MOD-C30011 add ,pml16='2'
     WHERE pml01 = g_pmn.pmn24
       AND pml02 = g_pmn.pmn25
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","pml_file",g_pmn.pmn24,g_pmn.pmn25,SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
       EXIT FOREACH
    #MOD-C30011 add start -----
    ELSE
       UPDATE pmk_file SET pmk25 = '2' WHERE pmk01 = g_pmn.pmn24
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","pmk_file",g_pmn.pmn24,"",SQLCA.sqlcode,"","",1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
    #MOD-C30011 add end   -----
    END IF
  #TQC-760044 end
  END FOREACH
END FUNCTION
 
FUNCTION s_auto_gen_doc_upd_pmm()
  DEFINE l_tot_pmm40   LIKE pmm_file.pmm40,
         l_tot_pmm40t  LIKE pmm_file.pmm40t
  DEFINE t_azi04  LIKE azi_file.azi04
 
  SELECT SUM(pmn88),SUM(pmn88t)
    INTO l_tot_pmm40,l_tot_pmm40t
    FROM pmn_file
   WHERE pmn01 = g_pmm.pmm01
  IF SQLCA.sqlcode OR l_tot_pmm40 IS NULL THEN
     LET l_tot_pmm40 = 0
     LET l_tot_pmm40t= 0
  END IF
 
  SELECT azi04 INTO t_azi04 FROM azi_file
   WHERE azi01 = g_pmm.pmm22 AND aziacti = 'Y'
 
  CALL cl_digcut(l_tot_pmm40,t_azi04) RETURNING l_tot_pmm40
  CALL cl_digcut(l_tot_pmm40t,t_azi04) RETURNING l_tot_pmm40t
 
 UPDATE pmm_file SET pmm40 = l_tot_pmm40,  #未稅總金額
                     pmm40t= l_tot_pmm40t  #含稅總金額
   WHERE pmm01 = g_pmm.pmm01
 IF SQLCA.sqlcode THEN
     CALL cl_err3("upd","pmm_file",g_pmm.pmm01,"",SQLCA.sqlcode,"","update pmm40",0)
     LET g_success = 'N'
 END IF
 
END FUNCTION
 
FUNCTION s_auto_gen_doc_set_pmn()
  DEFINE l_flag LIKE type_file.num5
  DEFINE l_ima49   LIKE ima_file.ima49,
         l_ima491  LIKE ima_file.ima491
 
   LET g_pmn.pmn011 = g_pml.pml011        #單據性質
   LET g_pmn.pmn03 = g_pml.pml03          #詢價單號
   LET g_pmn.pmn04 = g_pml.pml04          #料號
   LET g_pmn.pmn041 = g_pml.pml041        #品名
   LET g_pmn.pmn05 = g_pml.pml05          #APS單號
   SELECT  pmh04,pmh24 INTO g_pmn.pmn06,g_pmn.pmn89 FROM pmh_file       #FUN-940083 add pmh89
          WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
            AND pmh13 = g_pmm.pmm22
            AND pmh21 = " "                                             #CHI-860042                                                 
            AND pmh22 = '1'                                             #CHI-860042
            AND pmh23 = ' '                                             #No.CHI-960033
            AND pmhacti = 'Y'                                           #CHI-910021
#FUN-940083--begin
  IF cl_null(g_pmn.pmn89) THEN
     SELECT pmc914 INTO g_pmn.pmn89 FROM pmc_file,pmk_file
      WHERE pmc01 = pmk09
        AND pmk01 = g_pml.pml01
     IF SQLCA.SQLCODE THEN
        LET g_pmn.pmn89 = 'N' 
     END IF
  END IF
#FUN-940083--end
 
  IF g_pml.pml04[1,4] <> 'MISC' THEN
    SELECT ima44 INTO g_pmn.pmn07  #採購單位
      FROM ima_file
     WHERE ima01 = g_pmn.pmn04
    LET g_pmn.pmn08 =  g_pml.pml08          #庫存單位
    CALL s_umfchk(g_pml.pml04,g_pmn.pmn07,g_pml.pml08)
         RETURNING l_flag,g_pmn.pmn09      #取換算率(採購對庫存)
    IF l_flag=1 THEN
        CALL cl_err('pmn07/pml08: ','abm-731',1)
        LET g_success ='N'
    END IF
    CALL s_umfchk(g_pmn.pmn04,g_pmn.pmn07,g_pml.pml07)
                RETURNING l_flag,g_pmn.pmn121
    IF l_flag=1 THEN
        LET g_pmn.pmn121 = 1
    END IF
  ELSE
    LET g_pmn.pmn07 = g_pml.pml07
    LET g_pmn.pmn08 = g_pml.pml08
    LET g_pmn.pmn09 = 1
    LET g_pmn.pmn121 = 1  
  END IF
 
 
   LET g_pmn.pmn122 = g_pml.pml12        #專案代號
   LET g_pmn.pmn123 = g_pml.pml123       #廠牌
   LET g_pmn.pmn13 = g_pml.pml13         #超短交限率
   LET g_pmn.pmn14 = g_pml.pml14         #部份交貨否
   LET g_pmn.pmn15 = g_pml.pml15         #提前交貨否
   LET g_pmn.pmn16 = '0'                 #狀況碼
   LET g_pmn.pmn20 = g_pml.pml20         #採購量
   LET g_pmn.pmn20 = s_digqty(g_pmn.pmn20,g_pmn.pmn07)  #FUN-BB0084
   LET g_pmn.pmn23 = ''                  #送貨地址
   LET g_pmn.pmn24 = g_pml.pml01         #請購單號
   LET g_pmn.pmn25 = g_pml.pml02         #請購單序號
   LET g_pmn.pmn30 = g_pml.pml30         #標準價格
   LET g_pmn.pmn86 = g_pml.pml86         #MOD-730044 
   LET g_pmn.pmn87 = g_pml.pml87         #MOD-730044  
   IF g_pml.pml04[1,4] <> 'MISC' THEN
    # CALL s_defprice(g_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,g_pmn.pmn87,'',g_pmm.pmm21,g_pmm.pmm43,'1',g_pmn.pmn86)  #MOD-730044 modify  
      #TQC-9B0214-------start-------
      #CALL s_defprice(g_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,g_pmn.pmn87,'',g_pmm.pmm21,g_pmm.pmm43,'1',g_pmn.pmn86,'',
      #                g_pmm.pmm41,g_pmm.pmm20)#MOD-810181     #No.FUN-930148 addpmm20,pmm41     
      CALL s_defprice_new(g_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,g_pmn.pmn87,'',g_pmm.pmm21,g_pmm.pmm43,'1',g_pmn.pmn86,'',
                      g_pmm.pmm41,g_pmm.pmm20,g_plant)
       RETURNING g_pmn.pmn31,g_pmn.pmn31t, 
                 g_pmn.pmn73,g_pmn.pmn74    #TQC-AC0257 add 
      #TQC-9B0214-------end------- 
   ELSE            
     LET g_pmn.pmn31 = g_pml.pml31         #單價
     LET g_pmn.pmn31t = g_pml.pml31t       #含稅單價 
   END IF
   LET g_pmn.pmn34 =  g_pml.pml34
  SELECT ima49,ima491 INTO l_ima49,l_ima491 FROM ima_file
  WHERE ima01=g_pmn.pmn04
  CALL s_aday(g_pmn.pmn34,-1,l_ima49) RETURNING g_pmn.pmn33
  CALL s_aday(g_pmn.pmn34,1,l_ima491) RETURNING g_pmn.pmn35
   IF cl_null(g_pmn.pmn33) THEN LET g_pmn.pmn33 = g_today END IF
   LET g_pmn.pmn36 = NULL                  #最近確認交貨日期
   LET g_pmn.pmn37 = NULL                  #最後一次到廠日期
   LET g_pmn.pmn38 = g_pml.pml38           #可用/不可用
   LET g_pmn.pmn40 = g_pml.pml40           #會計科目
   LET g_pmn.pmn41 = g_pml.pml41          #工單號碼
   LET g_pmn.pmn42 = g_pml.pml42          #替代碼
   LET g_pmn.pmn43 = g_pml.pml43          #作業序號
   LET g_pmn.pmn431 =g_pml.pml431        #下一站作業序號 
   LET g_pmn.pmn44 = g_pmn.pmn31 * g_pmm.pmm42  #本幣單價
   LET g_pmn.pmn45 = NULL
   LET g_pmn.pmn50 = 0                     #交貨量
   LET g_pmn.pmn51 = 0                     #在驗量
   LET g_pmn.pmn53 = 0                     #入庫量
   SELECT ima35,ima36 INTO g_pmn.pmn52,g_pmn.pmn54 FROM ima_file
    WHERE ima01=g_pmn.pmn04
 
   LET g_pmn.pmn55 = 0                     #驗退量
   LET g_pmn.pmn56 = ' '                   #批號
   LET g_pmn.pmn57 = 0                     #超短交量
   LET g_pmn.pmn58 = 0                     #無交期性採購單已轉量
   LET g_pmn.pmn59 = ' '                   #退貨單號
   LET g_pmn.pmn60 = ' '                   #項次
   LET g_pmn.pmn61 = g_pmn.pmn04           #被替代料號
   LET g_pmn.pmn62 = 1
   LET g_pmn.pmn63 = 'N'                   #急料否
   #MOD-B30397 add --start--
   SELECT ima15 INTO g_pmn.pmn64
    FROM ima_file
   WHERE ima01 = g_pmn.pmn04
   #MOD-B30397 add --end--
   LET g_pmn.pmn65 = '1'                   #MOD-740216
   LET g_pmn.pmn66 = g_pml.pml66
   LET g_pmn.pmn67 = g_pml.pml67
   LET g_pmn.pmn68 = ''
   LET g_pmn.pmn69 = ''
   LET g_pmn.pmn70 = 0
   LET g_pmn.pmn80 = g_pml.pml80
   LET g_pmn.pmn81 = g_pml.pml81
   LET g_pmn.pmn82 = g_pml.pml82
   LET g_pmn.pmn83 = g_pml.pml83
   LET g_pmn.pmn84 = g_pml.pml84
   LET g_pmn.pmn85 = g_pml.pml85
  #LET g_pmn.pmn86 = g_pml.pml86                  #MOD-730044 mark
  #LET g_pmn.pmn87 = g_pml.pml87                  #MOD-730044 mark 
   LET g_pmn.pmn88 = g_pmn.pmn31  * g_pmn.pmn87   #未稅金額
   LET g_pmn.pmn88t =g_pmn.pmn31t * g_pmn.pmn87   #含稅金額 
   LET g_pmn.pmn930 =g_pmn.pmn930 
   LET g_pmn.pmn90 = g_pmn.pmn31
   LET g_pmn.pmn100= g_pml.pml06                  #FUN-D40042 add
END FUNCTION
 
FUNCTION s_auto_gen_doc_set_pmm(p_pmk09)
  DEFINE p_pmk09   LIKE  pmk_file.pmk09
 
  LET g_pmm.pmm02 = g_pmk.pmk02      #採購性質 
  IF g_pmk.pmk02 = 'TAP' THEN
      LET g_pmm.pmm02  ='TAP'             #單據性質
      LET g_pmm.pmm901 = 'Y'
      LET g_pmm.pmm902 = 'N'
      LET g_pmm.pmm905 = 'N'
      LET g_pmm.pmm906 = 'Y'
  ELSE
      LET g_pmm.pmm901 = 'N'         #非三角貿易代買單據
      LET g_pmm.pmm905 = 'N'         #非三角貿易代買單據
  END IF
 
  LET g_pmm.pmm03 = 0                #更動序號
  LET g_pmm.pmm04 = g_today          #採購日期
  LET g_pmm.pmm05 = ''               #專案號碼
  LET g_pmm.pmm06 = g_pmk.pmk06      #預算號碼
  LET g_pmm.pmm07 = g_pmk.pmk07      #單據分類
  LET g_pmm.pmm08 = g_pmk.pmk08      #PBI批號
  IF NOT cl_null(p_pmk09) THEN
     LET g_pmm.pmm09 = p_pmk09           #供應廠商
    #SELECT pmc15,pmc16,pmc17,pmc22,pmc49   #MOD-740236 mark
     SELECT pmc15,pmc16,pmc17,pmc47,pmc49   #MOD-740236
       INTO g_pmm.pmm10,g_pmm.pmm11,g_pmm.pmm20,g_pmm.pmm21,g_pmm.pmm41
       FROM pmc_file
      WHERE pmc01 = g_pmm.pmm09 AND pmc30 IN ('1','3')
  ELSE
     LET g_pmm.pmm09 = g_pmk.pmk09
     LET g_pmm.pmm10 = g_pmk.pmk10      #送貨地址  
     LET g_pmm.pmm11 = g_pmk.pmk11      #帳單地址
     LET g_pmm.pmm20 = g_pmk.pmk20       #付款方式
     LET g_pmm.pmm21 = g_pmk.pmk21       #稅別       #
     LET g_pmm.pmm41 = g_pmk.pmk41       #價格條件    #
  END IF
  LET g_pmm.pmm12 = g_user            #採購人員
  LET g_pmm.pmm13 = g_grup            #採購部門
  LET g_pmm.pmm14 = g_pmk.pmk14      #收貨部門 
  LET g_pmm.pmm15 = g_pmk.pmk15      #確認人
  LET g_pmm.pmm16 = g_pmk.pmk16      #運送方式
  LET g_pmm.pmm17 = g_pmk.pmk17      #代理商
  LET g_pmm.pmm18 = "N"
  LET g_pmm.pmm22 = g_pmk.pmk22       #幣別       #
  LET g_pmm.pmm25 = '0'               #狀況碼
  LET g_pmm.pmm26 = NULL              #理由碼
  LET g_pmm.pmm27 = g_today           #狀況異動日期
  LET g_pmm.pmm28 = g_pmk.pmk28       #會計分類
  LET g_pmm.pmm29 = g_pmk.pmk29       #會計科目
  LET g_pmm.pmm30 = g_pmk.pmk30       #驗收單列印否
  LET g_pmm.pmm31 = g_pmk.pmk31       #會計年度  #
  LET g_pmm.pmm32 = g_pmk.pmk32       #會計期間  #
  LET g_pmm.pmm40 = 0                 #總金額
  LET g_pmm.pmm40t = 0                #含稅金額
  LET g_pmm.pmm401 = 0                #代買總金額
  LET g_pmm.pmm42 = g_pmk.pmk42       #匯率        #
  LET g_pmm.pmm43 = g_pmk.pmk43       #稅別        #
  LET g_pmm.pmm44 = '1'               #稅處理
  LET g_pmm.pmm45 = g_pmk.pmk45       #可用/不可用
  LET g_pmm.pmm46 = 0                 #預付比率
  LET g_pmm.pmm47 = 0                 #預付金額
  LET g_pmm.pmm48 = 0                 #已結帳金額
  LET g_pmm.pmm49 = 'N'               #預付發票否
  LET g_pmm.pmm909 = '2'
  LET g_pmm.pmmprsw = g_pmk.pmkprsw   #列印抑制
  LET g_pmm.pmmprno = 0               #已列印次數
  LET g_pmm.pmmprdt = NULL            #最後列印日期
  SELECT smyapr INTO g_pmm.pmmmksg
    FROM smy_file WHERE smyslip=g_buf2
  IF STATUS THEN LET g_pmm.pmmmksg='N' END IF
  LET g_pmm.pmmsseq = 0             #已簽順序
  LET g_pmm.pmmsmax = 0             #應簽順序
  LET g_pmm.pmmacti = 'Y' 
  LET g_pmm.pmmuser = g_user
  LET g_pmm.pmmoriu = g_user #FUN-980030
  LET g_pmm.pmmorig = g_grup #FUN-980030
  LET g_data_plant = g_plant #FUN-980030
  LET g_pmm.pmmgrup = g_grup
  LET g_pmm.pmmdate = g_today
END FUNCTION
#TQC-730022
#FUN-730018 過單用
#MOD-740103
