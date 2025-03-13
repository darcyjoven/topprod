# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Date & Author..: 05/07/25 By Elva 若存在直接收款資料
#                                 1.審核時需要新增銀存異動資料
#                                 2.且若存在溢收，則需生成單據
#                                 3.需更新已收金額
# Modify.........: No.FUN-5A0124 05/10/20 By elva 刪除帳款資料時刪除oov_file
# Modify........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.MOD-590440 05/10/26 By Carrier 依月底重評價對AP未付金額調整,修正未付金額apa73的計算方法
# Modify.........: No.TQC-5B0080 05/12/05 By ice mark cl_set_field_pic
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-640246 06/05/02 By Echo 自動執行確認功能
# Modify.........: No.FUN-5C0014 06/05/29 By rainy 新增欄位oma67存放INVOICE NO
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670047 06/07/13 By Rayven 新增使用多帳套功能 
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680022 06/08/18 By Tracy 多帳期修改   
# Modify.........: No.FUN-680123 06/09/18 By hongmei 欄位類型轉換
# Modify.........: No.FUN-710050 07/02/01 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-730032 07/03/20 By Elva 新增nme21,nme22,nme23,nme24
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.TQC-740042 07/04/09 By bnlent 用年度取帳套
# Modify.........: No.TQC-740094 07/04/18 By Carrier 錯誤匯總功能-修改
# Modify.........: No.TQC-7b0043 07/11/08 By wujie   直接付款金額按項次更新到對應的子帳期中
# Modify.........: No.MOD-890174 08/09/18 By chenl   修正：當存在收款明細多筆資料對應一筆子賬期時，審核時程序會蕩出。
# Modify.........: No.MOD-890280 08/09/26 By chenl   修正對nme22的賦值錯誤。
# Modify.........: No.FUN-890128 08/10/07 By Vicky 確認段_chk()與異動資料_upd()若只需顯示提示訊息不可用cl_err()寫法,應改為cl_getmsg()
# Modify.........: No.FUN-960140 09/06/29 By lutingting GP5.2修改
# Modify.........: No.FUN-980011 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980263 09/08/31 By mike 在INSERT INTO oma_file前,給予oma64預設值"0"  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0014 09/12/07 By shiwuying 增加從不同DB抓資料
# Modify.........: No:TQC-9C0057 09/12/09 By Carrier 状况码赋值
# Modify.........: No:MOD-9C0097 09/12/23 By sabrina (1)l_omc10應加oob09
#                                                    (2)l_omc13應減oob10 
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:MOD-AC0063 10/12/08 By wujie  调整insert nme的语法
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:TQC-AC0237 10/12/16 By wujie  MOD-AC0063改错    
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file 
# Modify.........: No.TQC-BA0135 11/10/25 By yinhy 報錯信息alm-023改為開窗
# Modify.........: No.MOD-C70289 12/07/30 By yinhy 產生nme_file時，nme03為NULL時應賦值' '
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_trno           LIKE oma_file.oma01,
        g_ooa            RECORD LIKE ooa_file.*,
        g_oma            RECORD LIKE oma_file.*,
        b_oob            RECORD LIKE oob_file.*,
        g_ooa01          LIKE ooa_file.ooa01, 
        g_sql            STRING,
        g_forupd_sql     STRING,
        g_cnt,g_i        LIKE type_file.num5,       #No.FUN-680123 SMALLINT,
        tot,tot1,tot2    LIKE type_file.num20_6,    #No.FUN-680123 DEC(20,6),
        tot3             LIKE type_file.num20_6,    #No.FUN-680123 DEC(20,6),
        un_pay1,un_pay2  LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6)
DEFINE g_net             LIKE apv_file.apv04        #MOD-590440
DEFINE l_dbs             LIKE type_file.chr21        #No.FUN-9C0014 Add
 
FUNCTION s_t300_confirm(p_trno,p_plant)             #No.FUN-9C0014 Add P_dbs #No.FUN-A10104
   DEFINE p_trno	LIKE oma_file.oma01
  #DEFINE p_dbs         LIKE type_file.chr21        #No.FUN-9C0014 Add
   DEFINE p_plant       LIKE azp_file.azp01         #No.FUN-A10104
 
   #LET g_success = 'N'    #FUN-890128 mark
   LET g_trno = p_trno CLIPPED
   IF cl_null(g_trno) THEN RETURN END IF
#No.FUN-A10104 -BEGIN-----
#  LET l_dbs = p_dbs CLIPPED                        #No.FUN-9C0014 Add
   IF cl_null(p_plant) THEN
      LET l_dbs = ''
   ELSE
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
   END IF
#No.FUN-A10104 -END-------
 
   LET g_ooa01 = NULL
   SELECT ooa01 INTO g_ooa01 FROM ooa_file WHERE ooa01 = g_trno
   IF cl_null(g_ooa01) THEN RETURN END IF
 
   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa01
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = g_trno
 
   LET g_forupd_sql = " SELECT * FROM ooa_file WHERE ooa01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_t300_con_cl CURSOR FROM g_forupd_sql
 
   # 更新該張應收帳款之已收金額
   CALL s_t300_upd_oma()
   IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
 
   #No.MOD-590440  --begin                                                                                                          
   SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'                                                                              
   #No.MOD-590440  --end
 
   # 新增銀存異動
   CALL s_t300_ins_nme()
   IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
 
   # 直接CALL應收帳款沖帳既可,生成溢收單
   CALL s_t300_y()   
 
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
END FUNCTION
 
# 更新該張應收帳款之已收金額
FUNCTION s_t300_upd_oma()
DEFINE l_oma      RECORD LIKE oma_file.*,
       l_ooa31d   LIKE ooa_file.ooa31d,
       l_ooa32d   LIKE ooa_file.ooa32d 
DEFINE l_cnt      LIKE type_file.num5       #No.FUN-680022 #No.FUN-680123 SMALLINT
DEFINE l_tot1     LIKE ooa_file.ooa31d      #No.FUN-680022
DEFINE l_tot2     LIKE ooa_file.ooa32d      #No.FUN-680022
DEFINE l_omc02    LIKE omc_file.omc02       #No.FUN-680022                                                                            
DEFINE l_omc08    LIKE omc_file.omc08       #No.FUN-680022                                                                            
DEFINE l_omc09    LIKE omc_file.omc09       #No.FUN-680022                                                                            
DEFINE l_omc10    LIKE omc_file.omc10       #No.FUN-680022                                                                            
DEFINE l_omc11    LIKE omc_file.omc11       #No.FUN-680022    
DEFINE l_oob09    LIKE oob_file.oob09       #No.TQC-7B0043    
DEFINE l_oob10    LIKE oob_file.oob10       #No.TQC-7B0043    
DEFINE l_sum09    LIKE oob_file.oob09       #No.MOD-890174
DEFINE l_sum10    LIKE oob_file.oob10       #No.MOD-890174
 
   INITIALIZE l_oma.* TO NULL
   # 若已經存在沖帳金額，則需累計
   SELECT * INTO l_oma.* FROM oma_file 
    WHERE oma01 = g_trno
   IF STATUS THEN  
#     CALL cl_err('Sel oma:',STATUS,1)    #No.FUN-660116
#     CALL cl_err3("upd","oma_file",g_trno,"",STATUS,"","Sel oma:",1)   #No.FUN-660116  #NO.FUN-710050
#NO.FUN-71026--------begin
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_trno,'Sel oma:',STATUS,0)  #No.TQC-740094
      ELSE
         CALL cl_err3("upd","oma_file",g_trno,"",STATUS,"","Sel oma:",1)
      END IF
      LET g_success = 'N'   #FUN-890128
#NO.FUN-710050-------end       
      RETURN 
   END IF
   IF cl_null(l_oma.oma55) THEN LET l_oma.oma55 = 0 END IF
   IF cl_null(l_oma.oma57) THEN LET l_oma.oma57 = 0 END IF
   
   # 計算當前直接收款金額
   LET l_ooa31d = 0
   LET l_ooa32d = 0 
   SELECT ooa31d,ooa32d INTO l_ooa31d,l_ooa32d FROM ooa_file
    WHERE ooa01 = g_trno
   IF cl_null(l_ooa31d) THEN LET l_ooa31d = 0 END IF
   IF cl_null(l_ooa32d) THEN LET l_ooa32d = 0 END IF
 
   # 更新該應收帳款實際已收金額
   # 若原幣金額＋當前直接收款原幣借方金額合計 >  原幣應收含稅金額 -> 既溢收
   IF l_oma.oma55 + l_ooa31d > l_oma.oma54t THEN
      UPDATE oma_file SET oma55 = l_oma.oma54t,
                          oma57 = l_oma.oma56t 
       WHERE oma01 = g_trno
#No.FUN-680022  --start--
      UPDATE omc_file SET omc10 = omc08,
                          omc11 = omc09
       WHERE omc01 = g_trno
#No.FUN-680022  --end--
   ELSE 
      UPDATE oma_file SET oma55 = l_oma.oma55 + l_ooa31d,
                          oma57 = l_oma.oma57 + l_ooa32d 
       WHERE oma01 = g_trno
#No.FUN-680022--begin                                                                                                               
#No.TQC-7B0043 --begin
      DECLARE s_yz_h2_c CURSOR FOR                                                                                         
        SELECT omc02 FROM omc_file                                                                               
         WHERE omc01 =g_trno ORDER BY omc02                                                                             
         FOREACH s_yz_h2_c INTO l_omc02
          #No.MOD-890174--begin-- modify
          #SELECT oob09,oob10 INTO l_oob09,l_oob10 
          #  FROM oob_file
          # WHERE oob01 =g_trno
          #   AND oob19 =l_omc02
          #   AND oob02 > 0
           LET l_oob09 = 0
           LET l_oob10 = 0
           DECLARE s_oob09_oob10_cs CURSOR FOR
             SELECT oob09,oob10 FROM oob_file
              WHERE oob01 = g_trno
                AND oob19 = l_omc02
                AND oob02 > 0
           FOREACH s_oob09_oob10_cs INTO l_sum09,l_sum10
              IF cl_null(l_sum09) THEN LET l_sum09 = 0 END IF
              IF cl_null(l_sum10) THEN LET l_sum10 = 0 END IF
              LET l_oob09 = l_oob09 + l_sum09
              LET l_oob10 = l_oob10 + l_sum10
           END FOREACH
          #No.MOD-890174---end--- modify
 
           IF SQLCA.sqlcode THEN
              CONTINUE FOREACH
           END IF
 
           UPDATE omc_file SET omc10 =l_oob09,
                               omc11 =l_oob10
            WHERE omc01 =g_trno
              AND omc02 =l_omc02
         END FOREACH
 
#      DECLARE s_yz_h2_c CURSOR FOR                                                                                         
#        SELECT omc02,omc08,omc09,omc10,omc11 FROM omc_file                                                                               
#         WHERE omc01 =g_trno ORDER BY omc02                                                                             
#                                                                                                                             
#      SELECT COUNT(*) INTO l_cnt FROM omc_file                                                                                    
#       WHERE omc01 = g_trno                                                                                            
#      IF l_cnt >0 THEN     
#         LET l_tot1 = l_ooa31d                                                                                              
#         LET l_tot2 = l_ooa32d                                                                                           
#         FOREACH s_yz_h2_c INTO l_omc02,l_omc08,l_omc09,l_omc10,l_omc11                                                                    
#             IF l_omc08-l_omc10 >=l_tot1 THEN                                                                                       
#                LET l_omc10 = l_omc10 + l_tot1                                                                              
#                LET l_tot1 = 0                                                                                              
#             ELSE                                                                                                            
#                LET l_tot1 = l_tot1 - (l_omc08-l_omc10)                                                                              
#                LET l_omc10 = l_omc08                                                                                              
#             END IF                                                                                                          
#             IF l_omc09-l_omc11 >=l_tot2 THEN                                                                                       
#                LET l_omc11 = l_omc11 + l_tot2                                                                              
#                LET l_tot2 = 0                     
#             ELSE                                                                                                            
#                LET l_tot2 = l_tot2 - (l_omc09-l_omc11)                                                                              
#                LET l_omc11 = l_omc09                                                                                              
#             END IF                                                                                                          
#             UPDATE omc_file set omc10 = l_omc10,                                                                             
#                                 omc11 = l_omc11
#              WHERE omc01 = g_trno                                                                                      
#                AND omc02 = l_omc02                                                                                          
#             IF l_tot2 =0 OR l_tot1 = 0 THEN                                                                               
#                EXIT FOREACH                                                                                                 
#             END IF                                                                                                          
#         END FOREACH                                                                                                         
#      END IF                                                                                                                 
#No.FUN-680022--end     
#No.TQC-7B0043 --end
      IF l_oma.oma57 + l_ooa32d > l_oma.oma56t THEN
         UPDATE oma_file SET oma57 = l_oma.oma56t
          WHERE oma01 = g_trno
         UPDATE omc_file SET omc11 = omc09 WHERE omc01 = g_trno #No.FUN-680022 
      END IF
   END IF
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_trno,SQLCA.sqlcode,0)    #No.FUN-660116
#NO.FUN-710050-----------begin
#     CALL cl_err3("upd","oma_file",g_trno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
      IF g_bgerr THEN
         CALL s_errmsg('omc01',g_trno,g_trno,SQLCA.sqlcode,0)
      ELSE
         CALL cl_err3("upd","oma_file",g_trno,"",SQLCA.sqlcode,"","",0)
      END IF
      LET g_success = 'N'   #FUN-890128
#NO.FUN-710050------------end
      RETURN  
   ELSE 
      LET g_success = 'Y' 
   END IF
  
   # 更新本幣未沖金額 oma61
   INITIALIZE l_oma.* TO NULL
   SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = g_trno
 
   # 計算未沖金額－當前已沖金額 ＝ 后續未沖金額
   LET l_oma.oma61 = l_oma.oma61 - l_oma.oma57
 
   IF l_oma.oma61 < 0 THEN LET l_oma.oma61 = 0  END IF
   UPDATE oma_file SET oma61 = l_oma.oma61
    WHERE oma01 = g_trno
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_trno,SQLCA.sqlcode,0)   #No.FUN-660116
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_trno,g_trno,SQLCA.sqlcode,0)
      ELSE
         CALL cl_err3("upd","oma_file",g_trno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
      END IF
      LET g_success = 'N'   #FUN-890128
#NO.FUN-710050--------end
      RETURN  
   ELSE 
      LET g_success = 'Y' 
   END IF
   UPDATE omc_file SET omc13 = omc09 - omc11 WHERE omc01=g_trno #No.FUN-680022
END FUNCTION
 
FUNCTION s_t300_y()
DEFINE l_cnt     LIKE type_file.num5,           #No.FUN-680123 SMALLINT
       l_chr     LIKE type_file.chr1,           #TQC-5A0134 VARCHAR-->CHAR #No.FUN-680123 VARCHAR(01)
       l_ooa     RECORD LIKE ooa_file.*
DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
 
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_trno
 
   # 若作廢則返回
   IF l_ooa.ooaconf = 'X' THEN
      #No.TQC-740094  --Begin
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',g_trno,'','9024',1)
      ELSE
         CALL cl_err('','9024',0)
      END IF
      #No.TQC-740094  --End  
      LET g_success = 'N' 
      RETURN
   END IF
 
   # 若借貸不平，則返回
   IF l_ooa.ooa32d! = l_ooa.ooa32c THEN
      #No.TQC-740094  --Begin
      IF g_bgerr THEN
         CALL s_errmsg('ooa32d',l_ooa.ooa32d,'','axr-203',1)
      ELSE
         CALL cl_err('','axr-203',0)
      END IF
      #No.TQC-740094  --End  
      LET g_success = 'N' 
      RETURN
   END IF
 
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT ooz09 FROM ooz_file ",
              " WHERE ooz00 = '0'"
   PREPARE t600_ooz09_p FROM g_sql
   EXECUTE t600_ooz09_p INTO g_ooz.ooz09
#FUN-B50090 add -end--------------------------
   # 若收款日期小于關帳日期，則返回
   IF l_ooa.ooa02 <= g_ooz.ooz09 THEN
      #No.TQC-740094  --Begin
      IF g_bgerr THEN
         CALL s_errmsg('ooa02',l_ooa.ooa02,'','axr-164',1)
      ELSE
         CALL cl_err('','axr-164',0)
      END IF
      #No.TQC-740094  --End  
      LET g_success = 'N' 
      RETURN
   END IF
 
   # 若已確認，則返回
   IF l_ooa.ooaconf='Y' THEN
      LET g_success = 'N' 
      RETURN
   END IF
 
   # 若無需審核資料，則返回
   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01= g_trno
      AND oob02> 0
   IF l_cnt = 0 THEN
      #No.TQC-740094  --Begin
      IF g_bgerr THEN
         CALL s_errmsg('oob01',g_trno,'','mfg-009',1)
      ELSE
         CALL cl_err('','mfg-009',0)
      END IF
      #No.TQC-740094  --End  
      LET g_success = 'N' 
      RETURN
   END IF
 
   # 收款沖帳作業是否需沖至應收帳款項次(Y/N)
   IF g_ooz.ooz62='Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM oob_file 
       WHERE oob01 = g_trno
         AND oob03 = '2' AND oob04 = '1' 
         AND (oob06 IS NULL OR oob06 = ' ' OR
              oob15 IS NULL OR oob15 <=0 ) 
         AND oob02 > 0 
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN 
         #No.TQC-740094  --Begin
         IF g_bgerr THEN
            LET g_showmsg=g_trno,"/2/1"
            CALL s_errmsg('oob01,oob03,oob04',g_showmsg,'','axr-900',1)
         ELSE
            CALL cl_err('','axr-900',0)
         END IF
         #No.TQC-740094  --End  
         LET g_success = 'N' 
         RETURN  
      END IF
   END IF
 
   LET g_cnt=0
   SELECT COUNT(*) INTO g_cnt FROM oob_file,oma_file
    WHERE ( YEAR(oma02) > YEAR(l_ooa.ooa02) 
       OR (YEAR(oma02)  = YEAR(l_ooa.ooa02) 
      AND  MONTH(oma02) > MONTH(l_ooa.ooa02)) )
      AND oob03 = '2'    AND oob04 = '1'
      AND oob06 = oma01  AND oob01 = g_trno
      AND oob02 > 0 
   IF g_cnt >0 THEN 
      #No.TQC-740094  --Begin
      IF g_bgerr THEN
         LET g_showmsg=g_trno,"/2/1"
         CALL s_errmsg('oob01,oob03,oob04',g_showmsg,'','axr-371',1)
      ELSE
         CALL cl_err(g_trno,'axr-371',1)
      END IF
      #No.TQC-740094  --End  
      LET g_success = 'N' 
      RETURN  
   END IF
 
   LET g_success = 'Y'
   IF g_ooy.ooydmy1 = 'Y' THEN
      #No.FUN-740009 --begin
      CALL s_get_bookno(YEAR(g_oma.oma02))    #No.TQC-740042
           RETURNING l_flag,l_bookno1,l_bookno2
      IF l_flag='1' THEN #抓不到帳別
         #No.TQC-740094  --Begin
         IF g_bgerr THEN
            CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
         ELSE
            CALL cl_err(YEAR(g_oma.oma02),'aoo-081',1)
         END IF
         #No.TQC-740094  --End  
         LET g_success = 'N'
      END IF
      #No.FUN-740009 --end
#     CALL s_chknpq(g_trno,'AR',1)  #No.FUN-670047 mark
      #No.FUN-670047 --start--
#     CALL s_chknpq(g_trno,'AR',1,'0')       #No.FUN-740009
      CALL s_chknpq(g_trno,'AR',1,'0',l_bookno1)       #No.FUN-740009
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
#        CALL s_chknpq(g_trno,'AR',1,'1')        #No.FUN-740009
         CALL s_chknpq(g_trno,'AR',1,'1',l_bookno2)        #No.FUN-740009
      END IF
      #No.FUN-670047 --end--
   END IF
   IF g_success = 'N' THEN RETURN END IF
 
   OPEN s_t300_con_cl USING g_ooa01 #WITH REOPTIMIZATION
   IF STATUS THEN
      #No.TQC-740094  --Begin
      IF g_bgerr THEN
         CALL s_errmsg('','','OPEN s_t300_con_cl:',STATUS,1)
      ELSE
         CALL cl_err("OPEN s_t300_con_cl:", STATUS, 1)
      END IF
      #No.TQC-740094  --End  
      CLOSE s_t300_con_cl
      LET g_success = 'N' 
      RETURN
   END IF
   FETCH s_t300_con_cl INTO l_ooa.*             # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      #No.TQC-740094  --Begin
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',l_ooa.ooa01,'',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err(l_ooa.ooa01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      END IF
      #No.TQC-740094  --End  
      CLOSE s_t300_con_cl
      LET g_success = 'N' 
      RETURN
   END IF
   CALL s_t300_y1()
   IF g_success = 'Y'
      THEN LET l_ooa.ooaconf='Y' 
           LET l_ooa.ooa34 = '1'   #No.TQC-9C0057
           CALL cl_flow_notify(l_ooa.ooa01,'Y')
      ELSE LET l_ooa.ooaconf='N'
           LET l_ooa.ooa34 = '0'   #No.TQC-9C0057
   END IF
   #CKP
   IF l_ooa.ooaconf='X' THEN LET l_chr='Y' ELSE LET l_chr='N' END IF
#  CALL cl_set_field_pic(l_ooa.ooaconf,"","","",l_chr,"")
END FUNCTION
 
FUNCTION s_t300_y1()
DEFINE n          LIKE type_file.num5,           #No.FUN-680123 SMALLINT
       l_cnt      LIKE type_file.num5,           #No.FUN-680123 SMALLINT,
       l_flag     LIKE type_file.chr1            #TQC-5A0134 VARCHAR-->CHAR #No.FUN-680123 VARCHAR(1) 
 
   UPDATE ooa_file SET ooaconf = 'Y',ooa34 = '1' WHERE ooa01 = g_trno  #No.TQC-9C0057
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd ooaconf',SQLCA.SQLCODE,1)   #No.FUN-660116
      #No.TQC-740094  --Begin
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',g_trno,'upd ooaconf',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","ooa_file",g_trno,"",SQLCA.sqlcode,"","upd ooaconf",1)   #No.FUN-660116
      END IF
      #No.TQC-740094  --End  
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_t300_hu2() IF g_success = 'N' THEN RETURN END IF      #更新 
   DECLARE s_t300_y1_c CURSOR FOR
    SELECT * FROM oob_file WHERE oob01 = g_trno AND oob02 > 0 ORDER BY oob02
   LET l_cnt  = 1
   LET l_flag = '0'
   FOREACH s_t300_y1_c INTO b_oob.*
      IF STATUS THEN
#NO.FUN-710050------begin
         IF g_bgerr THEN
            CALL s_errmsg('oob01',g_trno,'y1 foreach',STATUS,1)  #No.FUN-740094
         ELSE
            CALL cl_err('y1 foreach',STATUS,1) 
         END IF
#NO.FUN-710050------end
         LET g_success = 'N' RETURN 
      END IF
      IF l_flag = '0' THEN LET l_flag = b_oob.oob03 END IF
      IF l_flag != b_oob.oob03 THEN
         LET l_cnt = l_cnt + 1
      END IF
      #No.FUN-960140---------start--
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
         CALL s_t300_bu_13('+')
      END IF
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '1' THEN
         CALL s_t300_bu_11('+')
      END IF
      #NO.FUN-960140---------end
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '1' THEN
         CALL s_t300_bu_21('+')
      END IF
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '9' THEN
         CALL s_t300_bu_19('+')
      END IF
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN 
         CALL s_t300_bu_22('+',l_cnt)
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH   
END FUNCTION
 
FUNCTION s_t300_hu2()            #最近交易日
DEFINE l_occ RECORD LIKE occ_file.*,
       l_ooa RECORD LIKE ooa_file.*
 
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_trno
   IF cl_null(l_dbs) THEN     #No.FUN-9C0014 Add
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01 = l_ooa.ooa03
#No.FUN-9C0014 BEGIN -----
   ELSE
      #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"occ_file ",
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                  " WHERE occ01 = '",l_ooa.ooa03,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE sel_occ_pre02 FROM g_sql
      EXECUTE sel_occ_pre02 INTO l_occ.*
   END IF
#No.FUN-9C0014 END -------
   IF STATUS THEN 
#     CALL cl_err('s ccc',STATUS,1)   #No.FUN-660116
#NO.FUN-710050------begin
      IF g_bgerr THEN
         CALL s_errmsg('occ01',l_ooa.ooa03,"s ccc",STATUS,1)
      ELSE
         CALL cl_err3("sel","occ_file",l_ooa.ooa03,"",STATUS,"","s ccc",1)   #No.FUN-660116
      END IF
#NO.FUN-710050------end
      LET g_success='N' 
      RETURN 
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16 = l_ooa.ooa02 END IF
   IF l_occ.occ174 IS NULL OR l_occ.occ174 < l_ooa.ooa02 THEN
      LET l_occ.occ174 = l_ooa.ooa02
   END IF
   IF cl_null(l_dbs) THEN     #No.FUN-9C0014 Add
   UPDATE occ_file SET * = l_occ.* WHERE occ01 = l_ooa.ooa03
#No.FUN-9C0014 BEGIN -----
   ELSE
      #LET g_sql = " UPDATE ",l_dbs CLIPPED,"occ_file ",
      LET g_sql = " UPDATE ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                  "    SET occ16 = ?,occ174 = ? ",
                  "  WHERE occ01 = '",l_ooa.ooa03,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE upd_occ_pre03 FROM g_sql
      EXECUTE upd_occ_pre03 USING l_occ.occ16,l_occ.occ174
   END IF
#No.FUN-9C0014 END -------
     IF STATUS THEN 
#       CALL cl_err('u ccc',SQLCA.SQLCODE,1)    #No.FUN-660116
#NO.FUN-710050-------begin
        IF g_bgerr THEN
           CALL s_errmsg('occ01',l_ooa.ooa03,'u ccc',SQLCA.SQLCODE,1)
        ELSE
           CALL cl_err3("upd","occ_file",l_ooa.ooa03,"",SQLCA.sqlcode,"","u ccc",1)   #No.FUN-660116
        END IF
#NO.FUN-710050-------end
      LET g_success='N' RETURN 
   END IF
END FUNCTION
 
FUNCTION s_t300_bu_19(p_sw)                   #更新 A/P 檔 (apa_file)
  DEFINE p_sw            LIKE type_file.chr1           #TQC-5A0134 VARCHAR-->CHAR  # +:更新 -:還原  #No.FUN-680123 VARCHAR(1) 
  DEFINE l_apa           RECORD LIKE apa_file.*
  DEFINE l_ooz07         LIKE ooz_file.ooz07
  DEFINE l_tot           LIKE type_file.num20_6        #FUN-4C0013 #No.FUN-680123 DEC(20,6)
 
  DISPLAY "bu_11:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
  SELECT * INTO l_apa.* FROM apa_file WHERE apa01=b_oob.oob06
  IF STATUS THEN 
#    CALL cl_err('sel apa',STATUS,1)    #No.FUN-660116
#NO.FUN-710050--------begin
     IF g_bgerr THEN
        CALL s_errmsg('apa01','b_oob.oob06','sel apa',STATUS,1)
     ELSE
        CALL cl_err3("sel","apa_file",b_oob.oob06,"",STATUS,"","sel apa",1)   #No.FUN-660116
     END IF
#NO.FUN-710050--------end
     LET g_success ='N' 
     RETURN 
  END IF
  IF l_apa.apa41 != 'Y' THEN
#NO.FUN-710050--------begin
     IF g_bgerr THEN
        CALL s_errmsg('apa41',l_apa.apa41,'apa41<>Y','axr-194',1)  #No.FUN-740094
     ELSE
        CALL cl_err('apa41<>Y','axr-194',1)
     END IF
     LET g_success ='N' RETURN 
#NO.FUN-710050--------end
  END IF
 
  # 期末調匯(A008)
  SELECT ooz07 INTO l_ooz07 FROM ooz_file WHERE ooz00 = '0'
  IF l_ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
     CALL s_g_np('2',l_apa.apa00,b_oob.oob06,b_oob.oob15) RETURNING tot
  END IF
  IF p_sw = '-' THEN
     LET l_apa.apa35f=l_apa.apa35f-b_oob.oob09
     LET l_apa.apa35 =l_apa.apa35 -b_oob.oob10
     #No.MOD-590440  --begin                                                                                                        
     IF g_apz.apz27 = 'N' THEN                                                                                                      
        LET tot = l_apa.apa34 - l_apa.apa35     #No:9443                                                                            
     ELSE                                                                                                                           
        CALL s_t300_comp_oox(b_oob.oob06) RETURNING g_net                                                                           
        LET tot = l_apa.apa34 - l_apa.apa35 + g_net    #No:9443                                                                     
     END IF                                                                                                                         
     #No.MOD-590440  --end
     UPDATE apa_file SET apa35f=l_apa.apa35f,
                         apa35 =l_apa.apa35,
                         apa73 = tot
               WHERE apa01= b_oob.oob06
     IF STATUS THEN
#       CALL cl_err('upd apa35,35f',STATUS,1)    #No.FUN-660116
#NO.FUN-710050----------begin
        IF g_bgerr THEN
            CALL s_errmsg('apa01',b_oob.oob06,'upd apa35,35f',STATUS,1)  #No.TQC-740094
        ELSE
            CALL cl_err3("upd","apa_file",b_oob.oob06,"",STATUS,"","upd apa35,35f",1)   #No.FUN-660116
        END IF
#NO.FUN-710050---------end
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
#NO.FUN-710050---------begin
        IF g_bgerr THEN
           CALL s_errmsg('apa01',b_oob.oob06,'upd apa35,35f','axr-198',1)  #No.TQC-740094
        ELSE
           CALL cl_err('upd apa35,35f','axr-198',1) 
        END IF
#NO.FUN-710050---------end
        LET g_success = 'N' RETURN
     END IF
  END IF
  IF p_sw = '+' THEN
     LET l_apa.apa35f=l_apa.apa35f+b_oob.oob09
     LET l_apa.apa35 =l_apa.apa35 +b_oob.oob10
     #No.MOD-590440  --begin                                                                                                        
     IF g_apz.apz27 = 'N' THEN                                                                                                      
        LET tot = l_apa.apa34 - l_apa.apa35     #No:9443                                                                            
     ELSE                                                                                                                           
        CALL s_t300_comp_oox(b_oob.oob06) RETURNING g_net                                                                           
        LET tot = l_apa.apa34 - l_apa.apa35 + g_net    #No:9443                                                                     
     END IF                                                                                                                         
     #No.MOD-590440  --end
     # 期末調匯(A008)
     IF l_ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
        IF l_apa.apa35f>l_apa.apa34f OR l_apa.apa35 >l_apa.apa34 THEN
#NO.FUN-710050---------begin
           IF g_bgerr THEN
              CALL s_errmsg('','','apa35>34','axr-190',1)
           ELSE
             CALL cl_err('apa35>34','axr-190',1) 
           END IF
#NO.FUN-710050--------end
           LET g_success = 'N' RETURN
        END IF
     END IF
     UPDATE apa_file SET apa35f=l_apa.apa35f,
                         apa35 =l_apa.apa35,
                         apa73 = tot 
               WHERE apa01= b_oob.oob06
     IF STATUS THEN
#       CALL cl_err('upd apa35f,35',STATUS,1)    #No.FUN-660116
#NO.FUN-710050---------begin
        IF g_bgerr THEN
           CALL s_errmsg('apa01',b_oob.oob06,'upd apa35f,35',STATUS,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("upd","apa_file",b_oob.oob06,"",STATUS,"","upd apa35f,35",1)   #No.FUN-660116
        END IF
#NO.FUN-710050---------end
        LET g_success = 'N' 
        RETURN 
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
#NO.FUN-710050---------begin
        IF g_bgerr THEN
           CALL s_errmsg('apa01',b_oob.oob06,'upd apa35f,35','axr-198',1)  #No.TQC-740094
        ELSE
           CALL cl_err('upd apa35f,35','axr-198',1) 
        END IF
#NO.FUN-710050---------end
       LET g_success = 'N' RETURN
     END IF
  END IF
END FUNCTION
 
FUNCTION s_t300_bu_21(p_sw)                  #更新應收帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)  #TQC-5A0134 VARCHAR-->CHAR         # +:更新 -:還原
  DEFINE l_omaconf      LIKE oma_file.omaconf,    #No.FUN-680123 VARCHAR(1), #TQc-5A0134 VARCHAR-->CHAR         #
         l_omavoid      LIKE oma_file.omavoid,    #No.FUN-680123 VARCHAR(1), #TQC-5A0134 VARCHAR-->CHAR
         l_cnt          LIKE type_file.num5       #No.FUN-680123 SMALLINT
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE l_omc_tot1     LIKE type_file.num5       #No.FUN-680123 SMALLINT #No.FUN-680022
  DEFINE l_omc_tot2     LIKE type_file.num5       #No.FUN-680123 SMALLINT #No.FUN-680022
  DEFINE l_omc02        LIKE omc_file.omc02       #No.FUN-680022                                                                            
  DEFINE l_omc08        LIKE omc_file.omc08       #No.FUN-680022                                                                            
  DEFINE l_omc09        LIKE omc_file.omc09       #No.FUN-680022                                                                            
  DEFINE l_omc10        LIKE omc_file.omc10       #No.FUN-680022
  DEFINE l_omc11        LIKE omc_file.omc11       #No.FUN-680022
  DEFINE l_omc13        LIKE omc_file.omc13       #No.FUN-680022
 
  DISPLAY "bu_21:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
 
  # 同參考單號若有一筆以上僅沖款一次即可
  IF g_ooz.ooz62='Y' THEN 
     SELECT COUNT(*) INTO l_cnt FROM oob_file
      WHERE oob01=b_oob.oob01 AND oob02<b_oob.oob02
        AND oob03='2'         AND oob04='1'   
        AND oob06=b_oob.oob06 AND oob15 = b_oob.oob15
        AND oob02 > 0 
  ELSE
     SELECT COUNT(*) INTO l_cnt FROM oob_file
      WHERE oob01=b_oob.oob01 AND oob02<b_oob.oob02
        AND oob03='2'         AND oob06=b_oob.oob06
        AND oob02 > 0 
  END IF 
 
  IF l_cnt>0 THEN  
#NO.FUN-710050---------begin
     IF g_bgerr THEN
        LET g_showmsg=b_oob.oob01,"/2"  #No.TQC-740094
        CALL s_errmsg('oob01,oob03',g_showmsg,b_oob.oob01,'axr-409',1)  #No.FUN-740094
     ELSE
        CALL cl_err(b_oob.oob01,'axr-409',1) 
     END IF
#NO.FUN-710050---------end
      LET g_success = 'N' 
      RETURN 
  END IF 
   
  SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
     AND oob03='2'  AND oob04='1' 
     AND oob02 > 0 
  IF cl_null(tot1) THEN LET tot1 = 0 END IF
  IF cl_null(tot2) THEN LET tot2 = 0 END IF
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  CALL cl_digcut(tot1,g_azi04) RETURNING tot1
  CALL cl_digcut(tot2,t_azi04) RETURNING tot2
  LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
            #"  FROM ",g_dbs_new,"oma_file",
            "  FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
            " WHERE oma01=?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
  PREPARE s_t300_bu_21_p1 FROM g_sql
  DECLARE s_t300_bu_21_c1 CURSOR FOR s_t300_bu_21_p1
  OPEN s_t300_bu_21_c1 USING b_oob.oob06
  FETCH s_t300_bu_21_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
    IF p_sw='+' AND l_omavoid='Y' THEN
       #No.TQC-740094  --Begin
       IF g_bgerr THEN
          CALL s_errmsg('omavoid','Y',b_oob.oob06,'axr-103',1)
       ELSE
          CALL cl_err(b_oob.oob06,'axr-103',3) 
       END IF
       LET g_success='N' RETURN
       #No.TQC-740094  --End  
    END IF
    IF p_sw='+' AND l_omaconf='N' THEN
       #No.TQC-740094  --Begin
       IF g_bgerr THEN
          CALL s_errmsg('omaconf','N',b_oob.oob06,'axr-194',1)
       ELSE
          CALL cl_err(b_oob.oob06,'axr-194',3)
       END IF
       LET g_success='N' RETURN
       #No.TQC-740094  --End  
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #期末調匯(A008)
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1 OR un_pay2 < tot2) THEN
          #No.TQC-740094  --Begin
          IF g_bgerr THEN
             CALL s_errmsg('','','un_pay<pay','axr-196',1)
          ELSE
             CALL cl_err('un_pay<pay','axr-196',3)
          END IF
          LET g_success = 'N' RETURN
          #No.TQC-740094  --End  
       END IF
    END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       #取得未沖金額
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
    ELSE
       LET tot3 = un_pay2  - tot2
    END IF
    #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"oma_file SET oma55=?,oma57=?,oma61=? ",
    LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
                " SET oma55=?,oma57=?,oma61=? ",
               " WHERE oma01=? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE s_t300_bu_21_p2 FROM g_sql
    EXECUTE s_t300_bu_21_p2 USING tot1, tot2, tot3, b_oob.oob06
    IF STATUS THEN
#      CALL cl_err('upd oma55,57',STATUS,3)    #No.FUN-660116
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("upd","oma_file",b_oob.oob06,"",STATUS,"","upd oma55,57",1)   #No.FUN-660116 
      END IF
#NO.FUN-710050--------end
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1)  #No.TQC-740094
      ELSE
         CALL cl_err('upd oma55,57','axr-198',3) 
      END IF
#NO.FUN-710050--------end
      LET g_success = 'N' RETURN
    END IF
#No.FUN-680022  --start--
    LET g_sql="SELECT omc10,omc11,omc13 ",
              #"  FROM ",g_dbs_new,"omc_file",
              "  FROM ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
              " WHERE omc01=? AND omc02=? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE s_t300_bu_21_p3 FROM g_sql
    DECLARE s_t300_bu_21_c3 CURSOR FOR s_t300_bu_21_p3
    OPEN s_t300_bu_21_c3 USING b_oob.oob06,b_oob.oob19
    FETCH s_t300_bu_21_c3 INTO l_omc10,l_omc11,l_omc13
    LET l_omc10 = l_omc10+b_oob.oob09    #MOD-9C0097 oob19 modify oob09
    LET l_omc11 = l_omc11+b_oob.oob10
    LET l_omc13 = l_omc13-b_oob.oob10    #MOD-9C0097 oob09 modify oob10
 
    #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc10=?,omc11=?,omc13=? ",
    LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
                " SET omc10=?,omc11=?,omc13=? ",
               " WHERE omc01=? AND omc02=? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE s_t300_bu_21_p4 FROM g_sql
    EXECUTE s_t300_bu_21_p4 USING l_omc10,l_omc11,
                                  l_omc13,b_oob.oob06,b_oob.oob19
    IF STATUS THEN
#NO.FUN-710050------begin
      IF g_bgerr THEN
         LET g_showmsg = b_oob.oob06,"/",b_oob.oob19  #No.TQC-740094
         CALL s_errmsg('omc01,omc02',g_showmsg,"upd omc10 omc11 omc13",STATUS,1)  #No.TQC-740094
      ELSE
         CALL cl_err3("upd","omc_file",b_oob.oob06,b_oob.oob19,STATUS,"
                    ","upd omc10 omc11 omc13",1)   
      END IF
#NO.FUN-710050------end
       LET g_success = 'N' 
       RETURN
    END IF
#No.FUN-680022  --end--
    # 若有指定沖帳項次, 則對項次再次檢查及更新已沖金額
    IF NOT cl_null(b_oob.oob15) AND g_ooz.ooz62='Y' THEN 
       LET tot1 = 0 LET tot2 = 0 
       SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
        WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
          AND oob03='2' AND oob15 = b_oob.oob15
          AND oob04='1' AND oob02 > 0  
       IF cl_null(tot1) THEN LET tot1 = 0 END IF
       IF cl_null(tot2) THEN LET tot2 = 0 END IF
       LET g_sql="SELECT oma00,omaconf,omb14t,omb16t ",
                 #"  FROM ",g_dbs_new CLIPPED,"omb_file,",g_dbs_new CLIPPED,"oma_file ",
                 "  FROM ",cl_get_target_table(g_plant_new,'omb_file'),",", #FUN-A50102
                           cl_get_target_table(g_plant_new,'oma_file'),     #FUN-A50102
                 " WHERE oma01=omb01 AND omb01=? AND omb03 = ? "
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE s_t300_bu_21_p1b FROM g_sql
       DECLARE s_t300_bu_21_c1b CURSOR FOR s_t300_bu_21_p1b
       OPEN s_t300_bu_21_c1b USING b_oob.oob06,b_oob.oob15
       FETCH s_t300_bu_21_c1b INTO l_oma00,l_omaconf,un_pay1,un_pay2
       IF p_sw='+' AND l_omaconf='N' THEN
          #No.TQC-740094  --Begin
          IF g_bgerr THEN
             LET g_showmsg = b_oob.oob06,"/",b_oob.oob15
             CALL s_errmsg('omb01,omb03',g_showmsg,'','axr-194',1)
          ELSE
             CALL cl_err(b_oob.oob06,'axr-194',3)
          END IF
          LET g_success='N' RETURN
          #No.TQC-740094  --End  
       END IF
       IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
       IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
       # 期末調匯(A008)
       IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
          IF p_sw='+' AND (un_pay1 < tot1 OR un_pay2 < tot2) THEN
             #No.TQC-740094  --Begin
             IF g_bgerr THEN
                CALL s_errmsg('ooz07','N','un_pay<pay','axr-196',1)
             ELSE
                CALL cl_err('un_pay<pay','axr-196',3)
             END IF
             LET g_success='N' RETURN
             #No.TQC-740094  --End  
          END IF
       END IF
       IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
          #取得未沖金額
          CALL s_g_np('1',l_oma00,b_oob.oob06,b_oob.oob15) RETURNING tot3
       ELSE
          LET tot3 = un_pay2  - tot2
       END IF
       #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"omb_file SET omb34=?,omb35=?,omb37=? ",
       LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'omb_file'), #FUN-A50102
                   " SET omb34=?,omb35=?,omb37=? ",
                 " WHERE omb01=? AND omb03=?"
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE s_t300_bu_21_p2b FROM g_sql
       EXECUTE s_t300_bu_21_p2b USING tot1, tot2, tot3, b_oob.oob06,b_oob.oob15
       IF STATUS THEN
#         CALL cl_err('upd omb34,35',STATUS,3)     #No.FUN-660116
#NO.FUN-710050-------begin
          IF g_bgerr THEN
             LET g_showmsg=b_oob.oob06,"/",b_oob.oob15  #No.TQC-740094
             CALL s_errmsg('omb01,omb03',g_showmsg,"upd omb34,35",STATUS,1)  #No.TQC-740094
          ELSE
             CALL cl_err3("upd","omb_file",b_oob.oob06,b_oob.oob15,STATUS,"","upd omb34,35",1)   #No.FUN-660116 
          END IF
#NO.FUN-710050-------end
          LET g_success = 'N' 
          RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
#NO.FUN-710050-------begin
          IF g_bgerr THEN 
             LET g_showmsg=b_oob.oob06,"/",b_oob.oob15  #No.TQC-740094
             CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35','axr-198',3)  #No.TQC-740094
          ELSE
             CALL cl_err('upd omb34,35','axr-198',3) 
          END IF
#NO.FUN-710050--------end   
          LET g_success = 'N' RETURN
       END IF
#No.FUN-680022  --start--
       LET g_sql="SELECT omc02,omc08,omc09,omc10,omc11,omc13 ",
                 #"  FROM ",g_dbs_new,"omc_file",
                 "  FROM ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
                 " WHERE omc01=? "
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE s_t300_bu_21_p3b FROM g_sql
       DECLARE s_t300_bu_21_c3b CURSOR FOR s_t300_bu_21_p3b
       OPEN s_t300_bu_21_c3b USING b_oob.oob06
       LET l_omc_tot1 = b_oob.oob09
       LET l_omc_tot2 = b_oob.oob10
       FOREACH s_t300_bu_21_c3b INTO l_omc02,l_omc08,l_omc09,
                                     l_omc10,l_omc11,l_omc13
          IF l_omc08-l_omc10 >=l_omc_tot1 THEN                                                                                   
             LET l_omc10 = l_omc10 + l_omc_tot1                                                                                  
             LET l_omc_tot1 = 0                                                                                                  
          ELSE                                                                                                                   
             LET l_omc_tot1 = l_omc_tot1 - (l_omc08-l_omc10)                                                                     
             LET l_omc10 = l_omc08                                                                                               
          END IF                                                                                                                 
          IF l_omc09-l_omc11 >=l_omc_tot2 THEN                                                                                   
             LET l_omc11 = l_omc11 + l_omc_tot2                                                                                  
             LET l_omc_tot2 = 0                                                                                                  
          ELSE                                                                                                                   
             LET l_omc_tot2 = l_omc_tot2 - (l_omc09-l_omc11)                                                                     
             LET l_omc11 = l_omc09                                                                                               
          END IF                                                       
          #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc10=?,omc11=?,omc13=? ",
          LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
                      " SET omc10=?,omc11=?,omc13=? ",
                    " WHERE omc01=? AND omc02=?"
 	      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
          PREPARE s_t300_bu_21_p4b FROM g_sql
          EXECUTE s_t300_bu_21_p4b USING l_omc10,l_omc11,l_omc13,
                                         b_oob.oob06,l_omc02
          IF STATUS THEN                                                         
#NO.FUN-710050--------begin
             IF g_bgerr THEN
                LET g_showmsg=b_oob.oob06,"/",l_omc02  #No.TQC-740094
                CALL s_errmsg('omc01,omc02',g_showmsg,"upd omc10,omc11,omc13",SQLCA.sqlcode,1)  #No.TQC-740094
             ELSE
                CALL cl_err3("upd","omc_file",b_oob.oob06,l_omc02,SQLCA.sqlcode,"",                                                      
                            "upd omc10,omc11,omc13",1)            
             END IF
#NO.FUN-710050--------end                                                                 
             LET g_success = 'N'                                                                                                 
             RETURN                                                                                                              
          END IF                                                                                                                 
          IF l_omc_tot2 =0 OR l_omc_tot1 = 0 THEN                                                                                
             EXIT FOREACH                                                                                                        
          END IF                                                                                                                 
       END FOREACH                                    
#No.FUN-680022  --end--
    END IF 
END FUNCTION
 
FUNCTION s_t300_bu_22(p_sw,p_cnt)                  # 產生溢收帳款檔 (oma_file)
  DEFINE p_sw            LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1) #TQC-5A0134 VARCHAR-->CHAR  # +:產生 -:刪除
  DEFINE p_cnt           LIKE type_file.num5       #No.FUN-680123 SMALLINT
  DEFINE l_oma           RECORD LIKE oma_file.*
  DEFINE l_omc	 	 RECORD LIKE omc_file.*  #No.FUN-680022
 
  IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN 
     MESSAGE "bu_22:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 
  ELSE 
     DISPLAY "bu_22:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
  END IF 
  INITIALIZE l_oma.* TO NULL
  IF p_sw = '-' THEN
     IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
        SELECT COUNT(*) INTO g_cnt FROM oob_file
         WHERE oob06 = b_oob.oob06
           AND oob03 = '1' AND oob04 = '3'
           AND oob02 > 0 
        IF g_cnt > 0 THEN 
           #No.TQC-740094  --Begin
           IF g_bgerr THEN
              LET g_showmsg=b_oob.oob06,"/1/3"
              CALL s_errmsg('oob06,oob03,oob04',g_showmsg,"","axr-206",1)
           ELSE
              CALL cl_err(b_oob.oob06,'axr-206',0)
           END IF
           LET g_success = 'N' RETURN
           #No.TQC-740094  --End  
        END IF
     END IF
     SELECT * INTO l_oma.* FROM oma_file WHERE oma01=b_oob.oob06
                                           AND omavoid = 'N'
     IF l_oma.oma55 > 0 OR l_oma.oma57 > 0 THEN
        #No.TQC-740094  --Begin
        IF g_bgerr THEN
           LET g_showmsg=b_oob.oob06,"/N"
           CALL s_errmsg('oma01,omavoid',g_showmsg,"oma55,oma57>0","axr-206",1)
        ELSE
           CALL cl_err('oma55,57>0','axr-206',1) 
        END IF
        LET g_success = 'N' RETURN
        #No.TQC-740094  --End  
     END IF
     DELETE FROM oma_file WHERE oma01 = b_oob.oob06
     IF STATUS THEN
#       CALL cl_err('del oma',STATUS,1)    #No.FUN-660116
#NO.FUN-710050--------begin
        IF g_bgerr THEN
           CALL s_errmsg('oma01',b_oob.oob06,'del oma',STATUS,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("del","oma_file",b_oob.oob06,"",STATUS,"","del oma",1)   #No.FUN-660116
        END IF
#NO.FUN-710050--------end
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
#NO.FUN-710050--------begin
        IF g_bgerr THEN
           CALL s_errmsg('oma01',b_oob.oob06,'del oma','axr-199',1)  #No.TQC-740094
        ELSE
           CALL cl_err('del oma','axr-199',1) 
        END IF
#NO.FUN-710050-------end
        LET g_success = 'N' RETURN
     END IF
#No.FUN-680022  --start--
     DELETE FROM omc_file WHERE omc01 = b_oob.oob06
     IF STATUS THEN
#NO.FUN-710050--------begin
        IF g_bgerr THEN
           CALL s_errmsg('omc01',b_oob.oob06,"del omc",STATUS,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("del","omc_file",b_oob.oob06,"",STATUS,"","del omc",1)   
        END IF
#NO.FUN-710050---------end
        LET g_success = 'N' 
        RETURN
     END IF
#No.FUN-680022  --end--
     #FUN-5A0124  --begin
     DELETE FROM oov_file WHERE oov01 = b_oob.oob06                   
     IF SQLCA.sqlcode THEN                                            
#       CALL cl_err('del oov',status,1)                                  #No.FUN-660116
#NO.FUN-710050--------begin
        IF g_bgerr THEN
           CALL s_errmsg('oov',b_oob.oob06,'del oov',status,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("del","oov_file",b_oob.oob06,"",status,"","del oov",1)   #No.FUN-660116
        END IF
#NO.FUN-710050-------end
        LET g_success='N'                                             
     END IF        
     #FUN-5A0124  --end
     UPDATE oob_file SET oob06=NULL,oob19=NULL   #No.FUN-680022 add oob19
       WHERE oob01=b_oob.oob01 AND oob02=b_oob.oob02
     IF STATUS OR SQLCA.SQLCODE THEN
#      CALL cl_err('upd oob06',SQLCA.SQLCODE,1)    #No.FUN-660116
#NO.FUN-710050-------begin
        IF g_bgerr THEN
           LET g_showmsg=b_oob.oob01,"/",b_oob.oob02       #No.TQC-740094
           CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob06',SQLCA.SQLCODE,1)  #No.TQC-740094
        ELSE
           CALL cl_err3("upd","oob_file",b_oob.oob01,b_oob.oob02,SQLCA.sqlcode,
                    "","upd oob06,oob19",1)   #No.FUN-660116 #No.FUN-680022 add oob19 
        END IF
#NO.FUN-710050-------end
       LET g_success = 'N' 
       RETURN
     ELSE    
        LET b_oob.oob06 = NULL
        LET b_oob.oob19 = NULL    #No.FUN-680022 add oob19              
     END IF
  END IF
  IF p_sw = '+' THEN
     IF cl_null(b_oob.oob06)
        THEN LET l_oma.oma01 = g_ooz.ooz22,'-' 
        ELSE LET l_oma.oma01 = b_oob.oob06
     END IF
     CALL  s_auto_assign_no("axr",l_oma.oma01,g_ooa.ooa02,'24',"oma_file","oma01","","","") RETURNING g_i,l_oma.oma01
     IF NOT g_i THEN LET g_success='N' RETURN END IF
     #MESSAGE l_oma.oma01 
     CALL cl_msg(l_oma.oma01)                      #FUN-640246
     LET l_oma.oma00 = '24'
     LET l_oma.oma02 = g_ooa.ooa02
     LET l_oma.oma03 = g_ooa.ooa03
     LET l_oma.oma032= g_ooa.ooa032
     LET l_oma.oma13 = g_ooa.ooa13
     LET l_oma.oma14 = g_ooa.ooa14
     LET l_oma.oma15 = g_ooa.ooa15
     LET l_oma.oma16 = g_ooa.ooa01
     LET l_oma.oma18 = b_oob.oob11
     LET l_oma.oma181= b_oob.oob111  #No.FUN-670047
#    LET l_oma.oma21 = g_ooa.ooa21
     LET l_oma.oma23 = b_oob.oob07
     LET l_oma.oma24 = b_oob.oob08
     LET l_oma.oma50 = 0 LET l_oma.oma50t = 0
     LET l_oma.oma52 = 0 LET l_oma.oma53 = 0
     LET l_oma.oma54 = b_oob.oob09 LET l_oma.oma54t= b_oob.oob09
     LET l_oma.oma56 = b_oob.oob10 LET l_oma.oma56t= b_oob.oob10
     LET l_oma.oma54x=0 LET l_oma.oma55=0
     LET l_oma.oma56x=0 LET l_oma.oma57=0
     LET l_oma.oma58=0 LET l_oma.oma59=0 LET l_oma.oma59x=0 LET l_oma.oma59t=0
     LET l_oma.oma60 = b_oob.oob08 
     LET l_oma.oma61 = b_oob.oob10 
     LET l_oma.omaconf='Y' LET l_oma.omavoid='N'
     LET l_oma.oma64 = '1'               #No.TQC-9C0057
     LET l_oma.omauser=g_user
     LET g_oma.omaoriu = g_user #FUN-980030
     LET g_oma.omaorig = g_grup #FUN-980030
     LET l_oma.omagrup=g_grup
     LET l_oma.omadate=g_today
     LET l_oma.oma12 = l_oma.oma02 LET l_oma.oma11 = l_oma.oma02
     LET l_oma.oma65 = '1' #FUN-5A0124
     LET l_oma.oma66= g_oma.oma66  #FUN-630043
 
#No: FUN-5C0014  --start--
     IF cl_null(l_dbs) THEN     #No.FUN-9C0014 Add
    #FUN-A60056--mod--str--
    #SELECT oga27 INTO l_oma.oma67 FROM oga_file
    # WHERE oga01 = l_oma.oma16
     LET g_sql = "SELECT oga27 FROM ",cl_get_target_table(l_oma.oma66,'oga_file'),
                 " WHERE oga01 = '",l_oma.oma16,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,l_oma.oma66) RETURNING g_sql
     PREPARE sel_oga27 FROM g_sql
     EXECUTE sel_oga27 INTO l_oma.oma67
    #FUN-A60056--mod--end
    #No.FUN-9C0014 BEGIN -----
     ELSE
        #LET g_sql = "SELECT oga27 FROM ",l_dbs CLIPPED,"oga_file ",
        LET g_sql = "SELECT oga27 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                    " WHERE oga01 = '",l_oma.oma16,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
        PREPARE sel_oga_pre01 FROM g_sql
        EXECUTE sel_oga_pre01 INTO l_oma.oma67
     END IF
    #No.FUN-9C0014 END -------
#No: FUN-5C--14  --end ---
     LET l_oma.oma930=s_costcenter(l_oma.oma15) #FUN-680006
     LET l_oma.omalegal = g_legal               #FUN-980011 add
     #No.TQC-9C0057  --Begin
     #LET l_oma.oma64='0' #MOD-980263          
     #No.TQC-9C0057  --End  
     LET l_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
     LET l_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#No.FUN-AB0034 --begin
    IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
    IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
    IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
     INSERT INTO oma_file VALUES(l_oma.*)
     IF STATUS OR SQLCA.SQLCODE THEN 
#       CALL cl_err('ins oma',SQLCA.SQLCODE,1)    #No.FUN-660116
#NO.FUN-710050-------begin
        IF g_bgerr THEN
           CALL s_errmsg('oma01',l_oma.oma01,'ins oma',SQLCA.SQLCODE,1)
        ELSE
           CALL cl_err3("ins","oma_file",l_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)   #No.FUN-660116
        END IF
#NO.FUN-710050-------end 
        LET g_success='N' 
        RETURN
     END IF
#No.FUN-680022  --start--
     LET l_omc.omc01 = l_oma.oma01
     LET l_omc.omc02 = 1
#    LET l_omc.omc03 = l_oma.oma32
     LET l_omc.omc04 = l_oma.oma11 
     LET l_omc.omc05 = l_oma.oma12
     LET l_omc.omc06 = l_oma.oma24
     LET l_omc.omc07 = l_oma.oma60
     LET l_omc.omc08 = l_oma.oma54t
     LET l_omc.omc09 = l_oma.oma56t
     LET l_omc.omc10 = 0
     LET l_omc.omc11 = 0
     LET l_omc.omc12 = l_oma.oma10
     LET l_omc.omc13 = l_omc.omc09 - l_omc.omc11
     LET l_omc.omc14 = 0
     LET l_omc.omc15 = 0
     LET l_omc.omclegal = g_legal               #FUN-980011 add
 
     INSERT INTO omc_file VALUES(l_omc.*)
     IF STATUS OR SQLCA.SQLCODE THEN
#NO.FUN-710050---------begin
        IF g_bgerr THEN
           LET g_showmsg=l_omc.omc01,"/",l_omc.omc02
           CALL s_errmsg('omc01,omc02',g_showmsg,"ins omc",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","omc_file",l_omc.omc01,"",SQLCA.sqlcode,"",
                     "ins omc",1)   
        END IF
#NO.FUN-710050--------end 
        LET g_success = 'N' 
        RETURN
     END IF
#No.FUN-680022  --end--
     UPDATE oob_file SET oob06=l_oma.oma01,oob19 = 1  #No.FUN-680022 add oob19
       WHERE oob01=b_oob.oob01 AND oob02=b_oob.oob02
     IF STATUS OR SQLCA.SQLCODE THEN
#      CALL cl_err('upd oob06',SQLCA.SQLCODE,1)   #No.FUN-660116
#NO.FUN-710050-------begin
       IF g_bgerr THEN
          LET g_showmsg=b_oob.oob01,"/",b_oob.oob02          #No.TQC-740094
          CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob06',SQLCA.SQLCODE,1)  #No.TQC-740094
       ELSE
          CALL cl_err3("upd","oob_file",b_oob.oob01,b_oob.oob02,SQLCA.sqlcode,
                    "","upd oob06,oob19",1)   #No.FUN-660116 #No.FUN-680022 add oob19
       END IF
#NO.FUN-710050-------end
       LET g_success = 'N' 
       RETURN 
     END IF
  END IF
END FUNCTION
 
#No.FUN-960140--------start--
FUNCTION s_t300_bu_13(p_sw)
  DEFINE p_sw            LIKE type_file.chr1
  DEFINE l_amt1    LIKE  oma_file.oma54
  DEFINE l_amt2    LIKE  oma_file.oma54
  DEFINE l_amt3    LIKE  oma_file.oma54
  DEFINE l_amt4    LIKE  oma_file.oma54
  IF b_oob.oob03 = '1' and b_oob.oob04 = '3' THEN
     LET l_amt1 = NULL
     LET l_amt2 = NULL
     SELECT  oma54t - oma55
        INTO l_amt1 FROM oma_file WHERE oma01 = b_oob.oob06
     #CALL s_up_money(b_oob.oob06) RETURNING l_amt2     
     LET l_amt2 = 0   #暫給這個值
     IF l_amt1 - l_amt2 < b_oob.oob09 THEN 
        IF g_bgerr THEN
           #CALL s_errmsg('','','','alm-023',0)   #TQC-BA0135
           CALL s_errmsg('','','','alm-023',1)    #TQC-BA0135
        ELSE
           CALL cl_err('','alm-023',0)
        END IF 
        LET g_success = 'N'
        RETURN
     END IF
     UPDATE oma_file SET oma55 = oma55 + b_oob.oob09,oma57 = oma57 + b_oob.oob10
       WHERE oma01 = b_oob.oob06
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        LET g_success = 'N'
        IF g_bgerr THEN
           CALL s_errmsg('oma01',b_oob.oob06,'upd oma_file',SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("upd","oma_file","","",SQLCA.sqlcode,"","",1)
        END IF 
        RETURN
     END IF
  END IF
END FUNCTION
 
FUNCTION s_t300_bu_11(p_sw)
  DEFINE p_sw            LIKE type_file.chr1
 
  IF b_oob.oob03 = 1 and b_oob.oob04 = 1  THEN
  UPDATE nmh_file SET nmh17 = nmh17 + b_oob.oob09
    WHERE nmh01 = b_oob.oob06
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_success = 'N'
      IF g_bgerr THEN
         CALL s_errmsg('nmh01',b_oob.oob06,'upd nmh_file',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","nmh_file","","",SQLCA.sqlcode,"","",1)
      END IF 
      RETURN
   END IF
  END IF
END FUNCTION
#No.FUN-960140--------end
 
FUNCTION s_t300_ins_nme()
   DEFINE l_nme     RECORD LIKE nme_file.*,
          l_ooa     RECORD LIKE ooa_file.*,
          l_oob     RECORD LIKE oob_file.*,
          l_cnt     LIKE type_file.num5       #No.FUN-680123 SMALLINT
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   IF g_ooz.ooz04 = 'N' THEN
      LET g_success = 'N' 
      RETURN 
   END IF
 
   INITIALIZE l_ooa.* TO NULL
 
   # 銀行存款異動記錄檔(轉帳) 
   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_trno
 
   DECLARE s_t300_ins_nme_c CURSOR FOR
    SELECT * FROM oob_file
     WHERE oob01 = g_trno  AND oob03 = '1' AND oob04 = '2'
       AND oob02 > 0 ORDER BY oob02
   FOREACH s_t300_ins_nme_c INTO l_oob.*
      IF STATUS THEN
         #No.TQC-740094  --Begin
         IF g_bgerr THEN
            LET g_showmsg=g_trno,"/1/2"
            CALL s_errmsg('oob01,oob03,oob04',g_showmsg,'y1 foreach',STATUS,1)
         ELSE
            CALL cl_err('y1 foreach',STATUS,1)
         END IF
         LET g_success = 'N' RETURN  
         #No.TQC-740094  --End  
      END IF
 
      IF l_oob.oob04 <>'2' THEN   #只有當類別為'2'時才可insert nme
         LET g_success = 'N' 
         RETURN
      END IF
 
      INITIALIZE l_nme.* TO NULL
      DISPLAY "INS_NME NOW...."
      LET l_nme.nme00 = 0
      LET l_nme.nme01 = l_oob.oob17
      LET l_nme.nme02 = l_ooa.ooa02
      LET l_nme.nme03 = l_oob.oob18
      IF cl_null(l_nme.nme03) THEN LET l_nme.nme03 = ' ' END IF   #MOD-C70289
      LET l_nme.nme04 = l_oob.oob09
      LET l_nme.nme07 = l_oob.oob08
      LET l_nme.nme08 = l_oob.oob10
      LET l_nme.nme10 = l_ooa.ooa33
      IF cl_null(l_nme.nme10) THEN LET l_nme.nme10 = ' ' END IF
      LET l_nme.nme11 = ' '
      LET l_nme.nme12 = l_oob.oob06
      IF cl_null(l_nme.nme12) THEN LET l_nme.nme12 = ' ' END IF   #MOD-C70289
      LET l_nme.nme13 = l_ooa.ooa032
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
       WHERE nmc01 = l_nme.nme03
      LET l_nme.nme15 = l_ooa.ooa15
      LET l_nme.nme16 = l_ooa.ooa02
      LET l_nme.nme17 = g_trno
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=TODAY
      #FUN-730032 --begin
      LET l_nme.nme21 = l_oob.oob02
     #LET l_nme.nme22 = '07'   #直接收款   #No.MOD-890280 mark
      LET l_nme.nme22 = '08'   #直接收款   #No.MOD-890280
      LET l_nme.nme24 = '9'    #未轉
      LET l_nme.nme25 = l_ooa.ooa03    #客戶編號
      #FUN-730032 --end
      LET l_nme.nmelegal = g_legal          #FUN-980011 add


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
 
      #LET g_sql="INSERT INTO ",g_dbs_new,"nme_file",
#No.MOD-AC0063 --begin
      LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'nme_file'), #FUN-A50102
                "(nme00,nme01,nme02,nme03,nme04,nme07,nme08,nme10,nme11,nme12,",
                " nme13,nme14,nme15,nme16,nme17,nmeacti,nmeuser,nmegrup,nmedate,",
#               " nme21,nme22,nme24,nme25,nmelegal)",  #FUN-730032 #FUN-980011 add    #FUN-B30166 Mark
                " nme21,nme22,nme24,nme25,nme27,nmelegal)",  #FUN-B30166 Add
#               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"             #FUN-B30166 Mark
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"             #FUN-B30166 Add
 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE s_t300_y_nme_p FROM g_sql
      EXECUTE s_t300_y_nme_p USING 
                                   l_nme.nme00,l_nme.nme01,l_nme.nme02,l_nme.nme03,l_nme.nme04,
                                   l_nme.nme07,l_nme.nme08,l_nme.nme10,l_nme.nme11,l_nme.nme12,
                                   l_nme.nme13,l_nme.nme14,l_nme.nme15,l_nme.nme16,l_nme.nme17,
                                   l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmedate,l_nme.nme21,
#                                  l_nme.nme22,l_nme.nme24,l_nme.nme25,l_nme.nmelegal     #FUN-B30166 Mark
                                   l_nme.nme22,l_nme.nme24,l_nme.nme25,l_nme.nme27,l_nme.nmelegal     #FUN-B30166 Add

#      LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'nme_file'), #FUN-A50102
#                "(nme00,nme01,nme02,nme03,nme04,nme07,nme08,nme10,nme11,nme12,",
#                " nme13,nme14,nme15,nme16,nme17,nmeacti,nmeuser,nmegrup,nmedate,",
#                " nme21,nme22,nme24,nme25,nmelegal)",  #FUN-730032 #FUN-980011 add
#                " VALUES('",l_nme.nme00,"',",
#                "'",l_nme.nme01,"',",
#                "'",l_nme.nme02,"',",
#                "'",l_nme.nme03,"',",
#                "'",l_nme.nme04,"',",
#                "'",l_nme.nme07,"',",
#                "'",l_nme.nme08,"',",
#                "'",l_nme.nme10,"',",
#                "'",l_nme.nme11,"',",
#                "'",l_nme.nme12,"',",
#                "'",l_nme.nme13,"',",
#                "'",l_nme.nme14,"',",   
#                "'",l_nme.nme15,"',",
#                "'",l_nme.nme16,"',",
#                "'",l_nme.nme17,"',",
#                "'",l_nme.nmeacti,"',",
#                "'",l_nme.nmeuser,"',",
#                "'",l_nme.nmegrup,"',",
#                "'",l_nme.nmedate,"',",
#                "'",l_nme.nme21,"',",  #FUN-730032
#                "'",l_nme.nme22,"',",  #FUN-730032
#                "'",l_nme.nme24,"',",  #FUN-730032
#                "'",l_nme.nme25,"',",   #FUN-730032
#                "'",l_nme.nmelegal,"')" #FUN-980011 add
# 
# 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
#      PREPARE s_t300_y_nme_p FROM g_sql
#No.MOD-AC0063 --end
      IF STATUS THEN
#NO.FUN-710050------begin
        IF g_bgerr THEN
           CALl s_errmsg('nme00',l_nme.nme00,'ins nme:',STATUS,1)    #No.TQC-740094
        ELSE
           CALL cl_err('ins nme:',STATUS,1)
        END IF
#NO.FUN-710050------end
         LET g_success='N'
         RETURN
      END IF
 
#     EXECUTE s_t300_y_nme_p  #No.TQC-AC0237
      DISPLAY "status", STATUS
      IF STATUS THEN
#NO.FUN-710050------begin
        IF g_bgerr THEN 
           CALL s_errmsg('nme00',l_nme.nme00,'ins nme:',STATUS,1)  #No.TQC-740094
        ELSE
           CALL cl_err('ins nme:',STATUS,1)
        END IF
#NO.FUN-710050-----end
         LET g_success='N'
         EXIT FOREACH
      END IF
 
      DISPLAY "sqlca.sqlerrd[3]=",sqlca.sqlerrd[3]
      IF SQLCA.SQLERRD[3]=0 THEN
#NO.FUN-710050-----begin
        IF g_bgerr THEN
          CALL s_errmsg('nme00',l_nme.nme00,'ins nme: ',SQLCA.SQLCODE,1)  #No.TQC-740094
        ELSE
          CALL cl_err('ins nme: ',SQLCA.SQLCODE,1)
        END IF
#NO.FUN-710050-----end
         LET g_success='N'
         RETURN
      END IF
      CALL s_flows_nme(l_nme.*,'1',g_plant_new)   #No.FUN-B90062  
   END FOREACH
 
END FUNCTION
 
#No.MOD-590440  --begin                                                                                                             
FUNCTION s_t300_comp_oox(p_apv03)                                                                                                   
DEFINE l_net     LIKE apv_file.apv04                                                                                                
DEFINE p_apv03   LIKE apv_file.apv03                                                                                                
DEFINE l_apa00   LIKE apa_file.apa00                                                                                                
                                                                                                                                    
    LET l_net = 0                                                                                                                   
    IF g_apz.apz27 = 'Y' THEN                                                                                                       
       SELECT SUM(oox10) INTO l_net FROM oox_file                                                                                   
        WHERE oox00 = 'AP' AND oox03 = p_apv03                                                                                      
       IF cl_null(l_net) THEN                                                                                                       
          LET l_net = 0                                                                                                             
       END IF                                                                                                                       
    END IF                                                                                                                          
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03                                                                     
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF                                                                   
                                                                                                                                    
    RETURN l_net                                                                                                                    
END FUNCTION                                                                                                                        
#No.MOD-590440  --end
