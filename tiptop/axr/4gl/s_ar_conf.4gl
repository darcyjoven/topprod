# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-5A0124 05/10/20 By elva 刪除帳款資料時刪除oov_file
# Modify.........: No.TQC-5B0175 05/11/28 By ice 大陸版時:確認后應更新發票金額;更新欄位oma61
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: No.FUN-640246 06/05/03 By Echo 自動執行確認功能
# Modify.........: No.TQC-5C0086 05/12/21 By Carrier AR月底重評修改
# Modify.........: No.FUN-5C0014 06/05/29 By Rainy 新增欄位oma67存放INVOICE NO.
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670047 06/07/13 By Rayven 新增使用多帳套功能
# Modify.........: No.FUN-670026 06/07/31 By Tracy 應收銷退合并 
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680022 06/08/18 By Tracy 多帳期修改   
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.MOD-6C0033 06/12/07 By Smapmin 銷退數量抓取計價數量
# Modify.........: No.TQC-6B0151 06/12/08 By Smapmin 數量應抓取計價數量
# Modify.........: No.FUN-710050 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720091 07/03/01 By Smapmin oha50 定義為單身合計值,不可因確認或取消確認時而改變
# Modify.........: No.TQC-740094 07/04/18 By Carrier 錯誤匯總功能-修改
# Modify.........: No.MOD-760035 07/06/13 By Smapmin 修改update oga54
# Modify.........: No.TQC-780094 07/08/31 By wujie   修改FUN-670026寫錯的地方
# Modify.........: No.MOD-7C0151 07/12/20 By Smapmin 取消確認時要將待抵單號清空
# Modify.........: No.MOD-820044 08/03/03 By Smapmin 確認時,發票待抵的金額未回寫至多帳期的已沖金額
# Modify.........: No.MOD-830058 08/03/07 By Smapmin 修改訂金確認時產生預收待抵的會科抓取來源
# Modify.........: No.MOD-840121 08/04/16 By Smapmin oga50/oga24回寫錯誤
# Modify.........: No.CHI-840048 08/05/05 By Smapmin 出貨立帳確認時,回寫待抵的已沖金額,應抓取原先訂單立帳的金額
# Modify.........: No.TQC-860031 08/06/18 By lumx 將預收的貸方npq23的賦值調整到賬款審核之后，因為oma19在審核之后才會產生
# Modify.........: No.MOD-860185 08/07/01 By Sarah 回寫待抵預付時,應以本次訂金金額
# Modify.........: No.FUN-980011 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980263 09/08/31 By mike 在INSERT INTO oma_file前,給予oma64預設值"0" 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990153 09/09/15 By Sarah 變數tot1,tot2為null時應給預設值0
# Modify.........: No:FUN-9C0014 09/12/07 By shiwuying 增加從不同DB抓資料
# Modify.........: No:TQC-9C0057 09/12/09 By Carrier 状况码赋值
# Modify.........: No:FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No:TQC-9C0185 09/12/30 By sherry 修正無法審核的問題
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No:MOD-A30094 10/03/16 By sabrina 取消ogb60的update
# Modify.........: No:TQC-A50130 10/05/21 By xiaofeizhu 新增act如果為空就置為0
# Modify.........: No:CHI-A50040 10/06/02 By Dido 尾款無須更新預收款
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 
# Modify.........: No.FUN-A60056 10/06/30 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No:MOD-A60199 10/06/30 By Dido 訂金分期時,分批出貨沖預收時更新金額有誤
# Modify.........: No.FUN-A50102 10/07/02 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60035 10/07/07 By chenls UPDATE ogb_file時判斷數值型是否為NULL
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:MOD-AC0236 10/12/21 By Dido 函式 s_yz_bu1 迴圈有誤 
# Modify.........: No:FUN-B40032 11/04/13 By baogc 有關應收賬款的修改
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.TQC-B60089 11/06/15 By Dido 回寫預收已沖金額邏輯調整 
# Modify.........: No.TQC-B70006 11/07/01 By wujie ogb917/ohb917对比时取绝对值
# Modify.........: No.MOD-B90260 11/09/28 By Dido 計算預收本幣金額邏輯調整 
# Modify.........: No.TQC-BB0184 11/11/20 By Dido 預收待抵原幣與本幣直接回寫無需再乘算
# Modify.........: No.TQC-C20430 12/02/28 By lutingting 零售預收修改 
# Modify.........: No.MOD-C30078 12/03/10 By Polly 回寫預收已沖金額邏輯調整
# Modify.........: No.MOD-C30842 12/03/23 By Polly ooz10/ooz16 都需要回寫至出貨單
# Modify.........: No.FUN-D40089 13/04/23 By zhangweib 批次審核的報錯,加show單據編號
# Modify.........: No.MOD-D60070 13/06/08 By SunLM 當b_omb.omb38 = '4'，這段邏輯應該用omb12去和ogb917去比


DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_oma RECORD LIKE oma_file.*
DEFINE b_omb RECORD LIKE omb_file.*
DEFINE g_oga RECORD LIKE oga_file.*
DEFINE g_ool RECORD LIKE ool_file.*  #TQC-860031
DEFINE g_ogb RECORD LIKE ogb_file.*
DEFINE g_ohb RECORD LIKE ohb_file.*
DEFINE g_oma01  LIKE oma_file.oma01      #No.FUN-680123 VARCHAR(16)  #No.FUN-550071
DEFINE tot,tot1,tot2      LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6)  #FUN-4C0013
DEFINE act            LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6)  #FUN-670026
DEFINE g_i       LIKE type_file.num5        #No.FUN-680123 SMALLINT
DEFINE g_net     LIKE oox_file.oox10    #No.TQC-5C0086 
DEFINE l_dbs     LIKE type_file.chr21   #No.FUN-9C0014 Add
DEFINE g_sql     LIKE type_file.chr1000 #No.FUN-9C0014 Add

FUNCTION s_ar_conf(p_flag,p_oma01,p_plant)   #No.FUN-9C0014 Add p_dbs #No.FUN-A10104 p_plant
  #DEFINE p_dbs           LIKE type_file.chr21#No.FUN-9C0014 Add       #No.FUN-A10104
   DEFINE p_plant         LIKE azp_file.azp01 #No.FUN-A10104 Add
   DEFINE p_flag       LIKE type_file.chr1        #'y':確認  'z':取消確認 #No.FUN-680123 VARCHAR(1)
   DEFINE p_oma01      LIKE oma_file.oma01        #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
 
   WHENEVER ERROR CONTINUE
   IF cl_null(p_oma01) THEN RETURN 1 END IF
   LET g_oma01=p_oma01
#No.FUN-A10104 -BEGIN-----
#  LET l_dbs = p_dbs      #No.FUN-9C0014 Add
   IF cl_null(p_plant) THEN
      LET l_dbs = ''
   ELSE
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
   END IF
#No.FUN-A10104 -END-------

   SELECT * INTO g_oma.* FROM oma_file WHERE oma01=g_oma01
   IF STATUS THEN 
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_oma01,'sel oma:',STATUS,1)
      ELSE
         CALL cl_err3("sel","oma_file",g_oma01,"",STATUS,"","sel oma:",1)
      END IF
      RETURN 1 
   END IF

#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT ooz09 FROM ooz_file ",
              " WHERE ooz00 = '0'"
   PREPARE t600_ooz09_p FROM g_sql
   EXECUTE t600_ooz09_p INTO g_ooz.ooz09
#FUN-B50090 add -end--------------------------
   IF g_oma.oma02<=g_ooz.ooz09 THEN 
      IF g_bgerr THEN
        #CALL s_errmsg("oma02",g_oma.oma02,"","axr-164",1)   #No.FUN-D40089   Mark
         CALL s_errmsg("oma02",g_oma.oma02,g_oma.oma01,"axr-164",1)   #No.FUN-D40089   Add
      ELSE
         CALL cl_err('','axr-164',1) 
      END IF
      RETURN 1
   END IF

   IF p_flag='y' THEN CALL s_yz_y() END IF

   IF p_flag='z' THEN CALL s_yz_z() END IF

   IF g_success='N' THEN
      RETURN 1
   ELSE
      RETURN 0
   END IF

END FUNCTION
 
FUNCTION s_yz_y()                # when g_oma.omaconf='N' (Turn to 'Y')

   CALL s_yz_y1()

END FUNCTION
 
FUNCTION s_yz_z()                # when g_oma.omaconf='Y' (Turn to 'N')

   CALL s_yz_z1()

END FUNCTION
 
FUNCTION s_yz_y1()

   UPDATE oma_file SET omaconf = 'Y',oma64 = '1' WHERE oma01 = g_oma.oma01  #No.TQC-9C0057

   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_oma.oma01,'upd omaconf',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.SQLCODE,"","upd omaconf",1)
      END IF
      LET g_success = 'N' 
      RETURN
   END IF

   #IF g_oma.oma00 = '11' THEN CALL s_yz_hu1('+') END IF     #產生預收款   #TQC-C20430
   IF g_oma.oma00 = '11' OR g_oma.oma00 = '15' THEN CALL s_yz_hu1('+') END IF     #產生預收款    #TQC-C20430
  #IF (g_oma.oma00 = '12' OR g_oma.oma00='13') AND g_oma.oma19 IS NOT NULL #No.FUN-9C0014
  #IF (g_oma.oma00 = '12' OR g_oma.oma00='13')                             #No.FUN-9C0014   #CHI-A50040 mark
   IF g_oma.oma00 = '12' THEN                                                               #CHI-A50040
      CALL s_yz_hu2('+')        #更新預收款已沖帳金額
   END IF

   IF g_oma.oma00 = '12' THEN CALL s_yz_hu3() END IF     #更新出貨單頭

   IF g_oma.oma00 MATCHES '1*' THEN CALL s_yz_oot('+') END IF    #No.A120

   DECLARE s_yz_y1_c CURSOR FOR
           SELECT * FROM omb_file WHERE omb01 = g_oma.oma01 ORDER BY omb03

   FOREACH s_yz_y1_c INTO b_omb.*
      IF STATUS THEN
         IF g_bgerr THEN
           #CALL s_errmsg('','','y1 foreach',STATUS,1)   #No.FUN-D40089   Mark
            CALL s_errmsg('oma01',g_oma.oma01,'y1 foreach',STATUS,1)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err('y1 foreach',STATUS,1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF

     #IF cl_null(l_dbs) THEN
      LET g_plant_new = b_omb.omb44
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
     #END IF

      CALL s_yz_bu1()     #更新訂單/出貨單
      IF g_success = 'N' THEN
         RETURN
      END IF
   END FOREACH

END FUNCTION
 
FUNCTION s_yz_oot(p_sw)                                                                                                             
   DEFINE p_sw        LIKE type_file.chr1         #No.FUN-680123 VARCHAR(01)                                                                                                      
   DEFINE l_cnt       LIKE type_file.num5         #No.FUN-680123 SMALLINT                                                                                                      
   DEFINE l_oot       RECORD LIKE oot_file.*                                                                                        
   DEFINE l_oot04t    LIKE oot_file.oot04t                                                                                          
   DEFINE l_oot05t    LIKE oot_file.oot05t                                                                                          
   DEFINE l_oot05     LIKE oot_file.oot05        #No.TQC-5B0175 本幣未稅                                                                 
   DEFINE l_oot05x    LIKE oot_file.oot05x       #No.TQC-5B0175 本幣稅額
                                                                                                                                    
   SELECT COUNT(*),SUM(oot04t),SUM(oot05t),SUM(oot05),SUM(oot05x)  #No.TQC-5B0175
     INTO l_cnt,l_oot04t,l_oot05t,l_oot05,l_oot05x                 #No.TQC-5B0175
     FROM oot_file                                                                                                                  
    WHERE oot03 = g_oma.oma01                                                                                                       

   IF l_cnt = 0 THEN RETURN END IF                                                                                                  
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF                                                                                
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF                                                                                
   IF cl_null(l_oot05)  THEN LET l_oot05  = 0 END IF  #No.TQC-5B0175
   IF cl_null(l_oot05x) THEN LET l_oot05x = 0 END IF  #No.TQC-5B0175

   #更新應收已衝金額                                                                                                                
   IF p_sw = '+' THEN                                                                                                               
      UPDATE oma_file SET oma55 = oma55 + l_oot04t, oma57 = oma57 + l_oot05t,                                                       
                          oma61 = oma61 - l_oot05t    #No.TQC-5B0175 更新本幣未衝金額
       WHERE oma01 = g_oma.oma01                                                                                                    
   ELSE                                                                                                                             
      UPDATE oma_file SET oma55 = oma55 - l_oot04t, oma57 = oma57 - l_oot05t,
                          oma61 = oma61 + l_oot05t    #No.TQC-5B0175 更新本幣未衝金額
       WHERE oma01 = g_oma.oma01 
   END IF                                                                                                                           
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN                                                                                           
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_oma.oma01,'upd oma55/57 #1',STATUS,0)
      ELSE
         CALL cl_err3("upd","oma_file",g_oma.oma01,"",STATUS,"","upd oma55/57 #1",0)
      END IF
      LET g_success = 'N' 
      RETURN                                                            
   END IF                                                                                                                           

   #更新發票金額
   IF p_sw = '+' THEN
      UPDATE oma_file SET oma59 = oma59 - l_oot05,
                          oma59x= oma59x- l_oot05x,
                          oma59t= oma59t- l_oot05t
       WHERE oma01 = g_oma.oma01
   ELSE
      UPDATE oma_file SET oma59 = oma59 + l_oot05,
                          oma59x= oma59x+ l_oot05x,
                          oma59t= oma59t+ l_oot05t 
       WHERE oma01 = g_oma.oma01
   END IF

   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_oma.oma01,'upd oma55/57 #1',STATUS,0)
      ELSE
         CALL cl_err3("upd","oma_file",g_oma.oma01,"",STATUS,"","upd oma55/57 #1",0)
      END IF
      LET g_success = 'N' 
      RETURN
   END IF
                                                                                                                                    
   DECLARE oot_curs CURSOR FOR                                                                                                      
    SELECT * FROM oot_file WHERE oot03 = g_oma.oma01                                                                                
   IF STATUS THEN                                                                                                                   
      IF g_bgerr THEN
         CALL s_errmsg('oot03',g_oma.oma01,'declare oot',STATUS,0)
      ELSE
         CALL cl_err('declare oot',STATUS,0)
      END IF
      LET g_success = 'N' RETURN                                                                
   END IF                                                                                                                           

   FOREACH oot_curs INTO l_oot.*                                                                                                    
      IF STATUS THEN                                                                                                                
         IF g_bgerr THEN
           #CALL s_errmsg('','','oot_curs',STATUS,0)   #No.FUN-D40089   Mark
            CALL s_errmsg('oma01',g_oma.oma01,'oot_curs',STATUS,0)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err('oot_curs',STATUS,0)
         END IF
         LET g_success = 'N' EXIT FOREACH                                                          
      END IF                                                                                                                        
      IF p_sw = '+' THEN                                                                                                            
         #更新待扺已衝金額                                                                                                          
         UPDATE oma_file SET oma55 = oma55 + l_oot.oot04t,                                                                          
                             oma57 = oma57 + l_oot.oot05t,
                             oma61 = oma61 - l_oot.oot05t   #No.TQC-5B0175 更新本幣未衝金額
          WHERE oma01 = l_oot.oot01  
      ELSE                                                                                                                          
         #更新待扺已衝金額                                                                                                          
         UPDATE oma_file SET oma55 = oma55 - l_oot.oot04t,                                                                          
                             oma57 = oma57 - l_oot.oot05t,                                                                          
                             oma61 = oma61 + l_oot.oot05t   #No.TQC-5B0175 更新本幣未衝金額
          WHERE oma01 = l_oot.oot01                                                                                                 
      END IF                                                                                                                        
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN                                                                                        
         IF g_bgerr THEN
            CALL s_errmsg('oma01',l_oot.oot01,'upd oma55/57 #2',STATUS,0)
         ELSE
            CALL cl_err3("upd","oma_file",l_oot.oot01,"",STATUS,"","upd oma55/57 #2",0)
         END IF
         LET g_success = 'N' 
         EXIT FOREACH                                                                                           
      END IF                                                                                                                        

      #更新待扺已沖金額->多帳期                                                                                                          
      IF p_sw = '+' THEN                                                                                                            
         UPDATE omc_file SET omc10 = omc10 + l_oot.oot04t,                                                                          
                             omc11 = omc11 + l_oot.oot05t,
                             omc13 = omc13 - l_oot.oot05t
          WHERE omc01 = l_oot.oot01  
      ELSE                                                                                                                          
         UPDATE omc_file SET omc10 = omc10 - l_oot.oot04t,                                                                          
                             omc11 = omc11 - l_oot.oot05t,
                             omc13 = omc13 + l_oot.oot05t
          WHERE omc01 = l_oot.oot01  
      END IF                                                                                                                        
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN                                                                                        
         IF g_bgerr THEN
            CALL s_errmsg('omc01',l_oot.oot01,'upd omc10/omc11/omc13',STATUS,0)
         ELSE
            CALL cl_err3("upd","omc_file",l_oot.oot01,"",STATUS,"","upd omc10/omc11/omc13",0)
         END IF
         LET g_success = 'N' 
         EXIT FOREACH                                                                                           
      END IF                                                                                                                        
   END FOREACH                                                                                                                      

END FUNCTION                                                                                                                        
 
FUNCTION s_yz_z1()

   UPDATE oma_file SET omaconf = 'N',oma64 = '0' WHERE oma01 = g_oma.oma01  #No.TQC-9C0057
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_oma.oma01,'upd omaconf',SQLCA.SQLCODE,1)
      ELSE
        CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.SQLCODE,"","upd omaconf",1)
      END IF
      LET g_success = 'N' 
      RETURN
   END IF

   #IF g_oma.oma00 = '11' THEN CALL s_yz_hu1('-') END IF     #刪除預收款   #TQC-C20430
   IF g_oma.oma00 = '11' OR g_oma.oma00 = '15' THEN CALL s_yz_hu1('-') END IF     #刪除預收款    #TQC-C20430
  #IF (g_oma.oma00 = '12' OR g_oma.oma00='13') AND g_oma.oma19 IS NOT NULL #No.FUN-9C0014
  #IF (g_oma.oma00 = '12' OR g_oma.oma00='13')                             #No.FUN-9C0014   #CHI-A50040 mark
   IF g_oma.oma00 = '12'                                                                    #CHI-A50040
      THEN CALL s_yz_hu2('-') END IF     #更新預收款已沖帳金額

   IF g_oma.oma00 MATCHES '1*' THEN CALL s_yz_oot('-') END IF    #No.A120  

   DECLARE s_yz_z1_c CURSOR FOR
           SELECT * FROM omb_file WHERE omb01 = g_oma.oma01 ORDER BY omb03

   FOREACH s_yz_z1_c INTO b_omb.*
      IF STATUS THEN
         IF g_bgerr THEN
           #CALL s_errmsg('','','z1 foreach',STATUS,1)   #No.FUN-D40089  Mark
            CALL s_errmsg('oma01',g_oma.oma01,'z1 foreach',STATUS,1)   #No.FUN-D40089  Add
         ELSE
            CALL cl_err('z1 foreach',STATUS,1)
         END IF
          LET g_success = 'N' RETURN END IF
      LET g_plant_new = b_omb.omb44
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
      CALL s_yz_bu1() IF g_success = 'N' THEN RETURN END IF     #更新訂單/出貨單
   END FOREACH

END FUNCTION
 
FUNCTION s_yz_bu1()                     #更新出貨單/銷退單身
DEFINE l_oga RECORD  LIKE oga_file.*              #MOD-C30842 add
DEFINE l_ogb RECORD  LIKE ogb_file.*              #MOD-C30842 add

   IF g_oma.oma00 = '12' AND NOT cl_null(b_omb.omb31) THEN
      IF b_omb.omb38 = '2' THEN                  #No.FUN-670026 
         SELECT SUM(abs(omb12)) INTO tot FROM omb_file, oma_file   #No.TQC-780094 
          WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
            AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
            AND oma00=g_oma.oma00
            AND oma10 IS NOT NULL AND oma10 <> ' '   #已開發票數量
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN
        #   SELECT * INTO g_ogb.* FROM ogb_file
        #    WHERE ogb01 = b_omb.omb31 AND ogb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"ogb_file",
        #               " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
        #   PREPARE sel_ogb_pre01 FROM g_sql
        #   EXECUTE sel_ogb_pre01 INTO g_ogb.*
        #END IF
         LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                     " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ogb_pre01 FROM g_sql
         EXECUTE sel_ogb_pre01 INTO g_ogb.*
        #FUN-A60056--mod--end
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg=b_omb.omb31,"/",b_omb.omb32   #No.TQC-740094
              #CALL s_errmsg('ogb01,ogb03',g_showmsg,'s_ar_conf:sel ogb',STATUS,1)  #No.TQC-740094   No.FUN-D40089   Mark
               CALL s_errmsg('ogb01,ogb03',g_showmsg,b_omb.omb01,STATUS,1)  #No.FUN-D40089   Add
            ELSE
               CALL cl_err3("sel","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_conf:sel ogb",1)
            END IF
            LET g_success = 'N' 
            RETURN
         END IF
         IF cl_null(g_ogb.ogb917) THEN LET g_ogb.ogb917 = 0 END IF
         IF tot > ABS(g_ogb.ogb917) THEN          # 發票數量大於出貨單數量   #No.TQC-B70006
            IF g_bgerr THEN
              #CALL s_errmsg('','','s_ar_conf:omb12>ogb917','axr-174',1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'s_ar_conf:omb12>ogb917','axr-174',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('s_ar_conf:omb12>ogb917','axr-174',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
         IF g_ooz.ooz16='Y' THEN      # 發票確認時將發票單價更新回出貨單(Y/N)
            LET g_ogb.ogb13 = b_omb.omb13
            LET g_ogb.ogb14 = abs(b_omb.omb14)  * g_ogb.ogb917 / b_omb.omb12
            LET g_ogb.ogb14t= abs(b_omb.omb14t) * g_ogb.ogb917 / b_omb.omb12
            LET g_ogb.ogb1013=tot
 
         END IF
#FUN-A60035 ---add begin
         IF cl_null(g_ogb.ogb1013) THEN
            LET g_ogb.ogb1013 = 0
         END IF
#FUN-A60035 ---add end
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN #No.FUN-9C0014 Add
        #UPDATE ogb_file SET
        #              ogb13=g_ogb.ogb13,
        #              ogb14=g_ogb.ogb14,
        #              ogb14t=g_ogb.ogb14t,
        #             #ogb60=tot,                   #MOD-A30094 mark
        #              ogb1013=g_ogb.ogb1013        #No.FUN-670026 
        # WHERE ogb01 = b_omb.omb31 AND ogb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ogb_file",
        #               "   SET ogb13='",g_ogb.ogb13,"',",
        #               "       ogb14='",g_ogb.ogb14,"',",
        #               "       ogb14t='",g_ogb.ogb14t,"',",
        #              #"       ogb60='",tot,"',",              #MOD-A30094 mark
        #               "       ogb1013='",g_ogb.ogb1013,"'",
        #               " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
        #   PREPARE upd_ogb_pre02 FROM g_sql
        #   EXECUTE upd_ogb_pre02
        #END IF
         #mark by maoyy20190715-s
#         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ogb_file'),
#                     "   SET ogb13='",g_ogb.ogb13,"',",
#                     "       ogb14='",g_ogb.ogb14,"',",
#                     "       ogb14t='",g_ogb.ogb14t,"',",
#                     "       ogb1013='",g_ogb.ogb1013,"'",
#                     " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#         CALL cl_parse_qry_sql(g_sql,b_omb.omb44 ) RETURNING g_sql
#         PREPARE upd_ogb_pre02 FROM g_sql
#         EXECUTE upd_ogb_pre02
       
        #FUN-A60056--mod--end
#         IF STATUS OR SQLCA.SQLCODE THEN  #TQC-9C0185 add
#            IF g_bgerr THEN
#              #CALL s_errmsg('','','upd ogb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
#               CALL s_errmsg('oma01',b_omb.omb01,'upd ogb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
#            ELSE
#               CALL cl_err3("upd","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","upd ogb60",1)
#            END IF
#            LET g_success = 'N' 
#            RETURN
#         END IF   #TQC-9C0185 add
#        #END IF   #MOD-AC0236 mark
#         IF STATUS=100 THEN
#            IF g_bgerr THEN
#              #CALL s_errmsg('','','upd ogb60','axr-134',1)   #No.FUN-D40089   Mark
#               CALL s_errmsg('oma01',b_omb.omb01,'upd ogb60','axr-134',1)   #No.FUN-D40089   Add
#            ELSE
#               CALL cl_err('upd ogb60','axr-134',1)
#            END IF
#            LET g_success = 'N' RETURN
#         END IF
          
          #mark by maoyy20190715-e
         IF g_ooz.ooz16='Y' THEN      # 發票確認時將發票金額更新回出貨單頭
           #FUN-A60056--mod--str--
           #IF cl_null(l_dbs) THEN      #No.FUN-9C0014 Add
           #SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = b_omb.omb31
           ##SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file,omb_file   #MOD-840121
           #SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file   #MOD-840121
           # WHERE ogb01 = b_omb.omb31 
           #   AND (ogb1005 ='1' or ogb1005 is null or ogb1005 = '')
           #ELSE
           #   LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oga_file ",
           #               " WHERE oga01 = '",b_omb.omb31,"'"
           #   PREPARE sel_oga_pre03 FROM g_sql
           #   EXECUTE sel_oga_pre03 INTO g_oga.*

           #   LET g_sql = "SELECT SUM(ogb14) FROM ",l_dbs CLIPPED,"ogb_file",
           #               " WHERE ogb01 = '",b_omb.omb31,"'",
           #               "   AND (ogb1005 ='1' or ogb1005 is null or ogb1005 = '')"
           #   PREPARE sel_ogb_pre04 FROM g_sql
           #   EXECUTE sel_ogb_pre04 INTO g_oga.oga50
           #END IF
            LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'oga_file'),
                        " WHERE oga01 = '",b_omb.omb31,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_oga_pre03 FROM g_sql
            EXECUTE sel_oga_pre03 INTO g_oga.*

            LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        " WHERE ogb01 = '",b_omb.omb31,"'",
                        "   AND (ogb1005 ='1' or ogb1005 is null or ogb1005 = '')"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_ogb_pre04 FROM g_sql
            EXECUTE sel_ogb_pre04 INTO g_oga.oga50
           #FUN-A60056--mod--end
 
            IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
            LET g_oga.oga21 = g_oma.oma21
            LET g_oga.oga211= g_oma.oma211
            LET g_oga.oga212= g_oma.oma212
            LET g_oga.oga213= g_oma.oma213
            LET g_oga.oga23 = g_oma.oma23
            LET g_oga.oga52 = g_oga.oga50 * g_oga.oga161/100
            LET g_oga.oga53 = g_oga.oga50 * (g_oga.oga162+g_oga.oga163)/100
           #FUN-A60056--mod--str--
           #IF cl_null(l_dbs) THEN
           #   UPDATE oga_file SET *=g_oga.* WHERE oga01 = g_oga.oga01
           #ELSE
           #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oga_file ",
           #               "   SET oga50 = ?,oga21 = ?,oga211= ?,oga212= ?,",
           #               "       oga213= ?,oga23 = ?,oga24 = ?,oga52 = ?,",
           #               "       oga53 = ?",
           #               " WHERE oga01 = '",g_oga.oga01,"'"
           #   PREPARE upd_oga_pre05 FROM g_sql
           #   EXECUTE upd_oga_pre05 USING g_oga.oga50,g_oga.oga21,g_oga.oga211,
           #                               g_oga.oga212,g_oga.oga213,g_oga.oga23,
           #                               g_oga.oga24,g_oga.oga52,g_oga.oga53
           #END IF
            
             #mark by maoyy20190715-s
#            LET g_sql = "UPDATE ",cl_get_target_table(g_oga.ogaplant,'oga_file'),
#                        "   SET oga50 = ?,oga21 = ?,oga211= ?,oga212= ?,",
#                        "       oga213= ?,oga23 = ?,oga24 = ?,oga52 = ?,",
#                        "       oga53 = ?",
#                        " WHERE oga01 = '",g_oga.oga01,"'"
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#            CALL cl_parse_qry_sql(g_sql,g_oga.ogaplant) RETURNING g_sql
#            PREPARE upd_oga_pre05 FROM g_sql
#            EXECUTE upd_oga_pre05 USING g_oga.oga50,g_oga.oga21,g_oga.oga211,
#                                        g_oga.oga212,g_oga.oga213,g_oga.oga23,
#                                        g_oga.oga24,g_oga.oga52,g_oga.oga53
          
           #FUN-A60056--mod--end
#            IF STATUS OR SQLCA.SQLCODE THEN
#               IF g_bgerr THEN
#                 #CALL s_errmsg('oga01',g_oga.oga01,'upd oga50',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
#                  CALL s_errmsg('oga01',g_oga.oga01,g_oma.oma01,SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
#               ELSE
#                  CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd ogb50",1)
#               END IF
#            END IF
            #mark by maoyy20190715-e
         END IF
        #-----------------------------MOD-C30842------------------------start
         IF g_ooz.ooz16 ='Y' AND g_oga.oga09 = '8' THEN    #出貨單走簽收流程
           #發票確認時將發票單價更新回出貨單
            LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        " WHERE ogb01 = '",g_oga.oga011,"'",
                        "   AND ogb03 = '",b_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_ogb2_pre01 FROM g_sql
            EXECUTE sel_ogb2_pre01 INTO l_ogb.*

            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg=b_omb.omb31,"/",b_omb.omb32
                 #CALL s_errmsg('ogb01,ogb03',g_showmsg,'s_ar_conf:sel ogb',STATUS,1)   #No.FUN-D40089   Mark
                  CALL s_errmsg('ogb01,ogb03',g_showmsg,b_omb.omb01,STATUS,1)   #No.FUN-D40089   Add
               ELSE
                  CALL cl_err3("sel","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_conf:sel ogb",1)
               END IF
               LET g_success = 'N'
               RETURN
            END IF
            IF cl_null(l_ogb.ogb917) THEN LET l_ogb.ogb917 = 0 END IF
            IF tot > ABS(l_ogb.ogb917) THEN          # 發票數量大於出貨單數量
               IF g_bgerr THEN
                 #CALL s_errmsg('','','s_ar_conf:omb12>ogb917','axr-174',1)   #No.FUN-D40089   Mark
                  CALL s_errmsg('oma01',b_omb.omb01,'s_ar_conf:omb12>ogb917','axr-174',1)   #No.FUN-D40089
               ELSE
                  CALL cl_err('s_ar_conf:omb12>ogb917','axr-174',1)
               END IF
               LET g_success = 'N' RETURN
            END IF
            LET l_ogb.ogb13 = b_omb.omb13
            LET l_ogb.ogb14 = abs(b_omb.omb14)  * l_ogb.ogb917 / b_omb.omb12
            LET l_ogb.ogb14t = abs(b_omb.omb14t) * l_ogb.ogb917 / b_omb.omb12
            LET l_ogb.ogb1013 = tot
            IF cl_null(l_ogb.ogb1013) THEN
               LET l_ogb.ogb1013 = 0
            END IF
            #mark by maoyy20190715-s
#            LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ogb_file'),
#                        "   SET ogb13='",l_ogb.ogb13,"',",
#                        "       ogb14='",l_ogb.ogb14,"',",
#                        "       ogb14t='",l_ogb.ogb14t,"',",
#                        "       ogb1013='",l_ogb.ogb1013,"'",
#                        " WHERE ogb01 = '",g_oga.oga011,"' AND ogb03 = '",b_omb.omb32,"'"
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#            CALL cl_parse_qry_sql(g_sql,b_omb.omb44 ) RETURNING g_sql
#            PREPARE upd_ogb2_pre02 FROM g_sql
#            EXECUTE upd_ogb2_pre02
           
#            IF STATUS OR SQLCA.SQLCODE THEN
#               IF g_bgerr THEN
#                 #CALL s_errmsg('','','upd ogb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
#                  CALL s_errmsg('oma01',b_omb.omb01,'upd ogb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
#               ELSE
#                  CALL cl_err3("upd","ogb_file",g_oga.oga011,b_omb.omb32,STATUS,"","upd ogb60",1)
#               END IF
#               LET g_success = 'N'
#               RETURN
#            END IF
#            IF STATUS=100 THEN
#               IF g_bgerr THEN
#                 #CALL s_errmsg('','','upd ogb60','axr-134',1)   #No.FUN-D40089   Mark
#                  CALL s_errmsg('oma01',b_omb.omb01,'upd ogb60','axr-134',1)   #No.FUN-D40089   Add
#               ELSE
#                  CALL cl_err('upd ogb60','axr-134',1)
#               END IF
#               LET g_success = 'N' RETURN
#            END IF
           #mark by maoyy20190715-e
           #發票確認時將發票金額更新回出貨單頭
            LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'oga_file'),
                        " WHERE oga01 = '",g_oga.oga011,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_oga2_pre03 FROM g_sql
            EXECUTE sel_oga2_pre03 INTO l_oga.*

            LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        " WHERE ogb01 = '",g_oga.oga011,"'",
                        "   AND (ogb1005 ='1' or ogb1005 is null or ogb1005 = '')"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_ogb2_pre04 FROM g_sql
            EXECUTE sel_ogb2_pre04 INTO l_oga.oga50

            IF cl_null(l_oga.oga50) THEN LET l_oga.oga50 = 0 END IF
            LET l_oga.oga21 = g_oma.oma21
            LET l_oga.oga211= g_oma.oma211
            LET l_oga.oga212= g_oma.oma212
            LET l_oga.oga213= g_oma.oma213
            LET l_oga.oga23 = g_oma.oma23
            LET l_oga.oga52 = l_oga.oga50 * l_oga.oga161/100
            LET l_oga.oga53 = l_oga.oga50 * (l_oga.oga162 + l_oga.oga163)/100
            #mark by maoyy20190715-s
#            LET g_sql = "UPDATE ",cl_get_target_table(g_oga.ogaplant,'oga_file'),
#                        "   SET oga50 = ?,oga21 = ?,oga211= ?,oga212= ?,",
#                        "       oga213= ?,oga23 = ?,oga24 = ?,oga52 = ?,",
#                        "       oga53 = ?",
#                        " WHERE oga01 = '",l_oga.oga01,"'"
#            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#            CALL cl_parse_qry_sql(g_sql,g_oga.ogaplant) RETURNING g_sql
#            PREPARE upd_oga2_pre05 FROM g_sql
#            EXECUTE upd_oga2_pre05 USING l_oga.oga50,l_oga.oga21,l_oga.oga211,
#                                        l_oga.oga212,l_oga.oga213,l_oga.oga23,
#                                        l_oga.oga24,l_oga.oga52,l_oga.oga53
#            
#            IF STATUS OR SQLCA.SQLCODE THEN
#               IF g_bgerr THEN
#                 #CALL s_errmsg('oga01',l_oga.oga01,'upd oga50',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
#                  CALL s_errmsg('oga01',l_oga.oga01,g_oma.oma01,SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
#               ELSE
#                  CALL cl_err3("upd","oga_file",l_oga.oga01,"",SQLCA.SQLCODE,"","upd ogb50",1)
#               END IF
#            END IF
             #mark by maoyy20190715-e
         END IF
        #-----------------------------MOD-C30842--------------------------end
         #未稅金額 * 出貨應收比率
         SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00=g_oma.oma00
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN
        #   UPDATE oga_file SET oga10=g_oma.oma01
        #    WHERE oga01 = b_omb.omb31
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oga_file SET oga10='",g_oma.oma01,"'",
        #               " WHERE oga01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oga_pre06 FROM g_sql
        #   EXECUTE upd_oga_pre06
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oga_file'),
                     "   SET oga10='",g_oma.oma01,"'",
                     " WHERE oga01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_oga_pre06 FROM g_sql
         EXECUTE upd_oga_pre06
        #FUN-A60056--mod--end
         IF STATUS THEN
            IF g_bgerr THEN
              #CALL s_errmsg('oga01','b_omb.omb31','upd oga54',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oga01','b_omb.omb31',b_omb.omb01,SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err3("upd","oga_file",b_omb.omb31,"",SQLCA.SQLCODE,"","upd oga54",1)
            END IF
            LET g_success = 'N' 
            RETURN
         END IF
         IF STATUS=100 THEN
            IF g_bgerr THEN
              #CALL s_errmsg('','','upd oga54','axr-134',1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'upd oga54','axr-134',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('upd oga54','axr-134',1)
            END IF
            LET g_success = 'N' 
            RETURN
         END IF
 
      END IF
      IF b_omb.omb38 = '4' THEN                  #No.FUN-670026 
        # SELECT SUM(abs(omb14)) INTO tot FROM omb_file, oma_file   #No.FUN-670026 
        SELECT SUM(abs(omb12)) INTO tot FROM omb_file, oma_file   #No.FUN-670026  #MOD-D60070omb14--->omb12 
          WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
            AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
            AND oma00=g_oma.oma00
            AND oma10 IS NOT NULL AND oma10 <> ' '   #已開發票數量
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN
        #   SELECT * INTO g_ogb.* FROM ogb_file
        #    WHERE ogb01 = b_omb.omb31 AND ogb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"ogb_file",
        #               " WHERE ogb01 ='",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
        #   PREPARE sel_ogb_pre07 FROM g_sql
        #   EXECUTE sel_ogb_pre07 INTO g_ogb.*
        #END IF
         LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                     " WHERE ogb01 ='",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ogb_pre07 FROM g_sql
         EXECUTE sel_ogb_pre07 INTO g_ogb.*
        #FUN-A60056--mod--end
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg = b_omb.omb31,"/",b_omb.omb32  #No.TQC-740094
              #CALL s_errmsg('ogb01,ogb03',g_showmsg,'s_ar_conf:sel ogb',STATUS,1)  #No.TQC-740094  #No.FUN-D40089   Mark
               CALL s_errmsg('ogb01,ogb03',g_showmsg,b_omb.omb01,STATUS,1)  #No.FUN-D40089   Add
            ELSE
               CALL cl_err3("sel","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_conf:sel ogb",1)
            END IF
            LET g_success = 'N' 
            RETURN
         END IF
         IF cl_null(g_ogb.ogb917) THEN LET g_ogb.ogb917 = 0 END IF
         IF tot > ABS(g_ogb.ogb917) THEN          # 發票數量大於出貨單數量   #No.TQC-B70006
            IF g_bgerr THEN
              #CALL s_errmsg('','','s_ar_conf:omb12>ogb917','axr-174',1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'s_ar_conf:omb12>ogb917','axr-174',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('s_ar_conf:omb12>ogb917','axr-174',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
         IF g_ooz.ooz16='Y' THEN      # 發票確認時將發票單價更新回出貨單(Y/N)
            LET g_ogb.ogb13 = b_omb.omb13
            LET g_ogb.ogb14 = b_omb.omb14 * (-1)  
            LET g_ogb.ogb14t= b_omb.omb14t* (-1)
 
         END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN  #No.FUN-9C0014 Add
        #UPDATE ogb_file SET
        #              ogb13=g_ogb.ogb13,
        #              ogb14=g_ogb.ogb14,
        #              ogb14t=g_ogb.ogb14t,
        #              ogb1013=tot        #No.FUN-670026 
        # WHERE ogb01 = b_omb.omb31 AND ogb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ogb_file",
        #               "   SET ogb13='",g_ogb.ogb13,"',",
        #               "       ogb14='",g_ogb.ogb14,"',",
        #               "       ogb14t='",g_ogb.ogb14t,"',",
        #               "       ogb1013=",tot,
        #               " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
        #   PREPARE upd_ogb_pre08 FROM g_sql
        #   EXECUTE upd_ogb_pre08
        #END IF
        #mark by pane 201201 begin#
        #LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ogb_file'),
        #            "   SET ogb13='",g_ogb.ogb13,"',",
        #            "       ogb14='",g_ogb.ogb14,"',",
        #            "       ogb14t='",g_ogb.ogb14t,"',",
        #            "       ogb1013=",tot,
        #            " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
        #CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        #CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
        #PREPARE upd_ogb_pre08 FROM g_sql
        #EXECUTE upd_ogb_pre08
        #FUN-A60056--mod--end
        #IF STATUS OR SQLCA.SQLCODE THEN
        #   IF g_bgerr THEN
        #     #CALL s_errmsg('','','upd ogb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
        #      CALL s_errmsg('oma01',b_omb.omb01,'upd ogb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
        #   ELSE
        #      CALL cl_err3("upd","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","upd ogb60",1)
        #   END IF
        #   LET g_success = 'N' 
        #   RETURN
        #END IF
        #IF STATUS=100 THEN
        #   IF g_bgerr THEN
        #     #CALl s_errmsg('','','upd ogb60','axr-134',1)   #No.FUN-D40089   Mark
        #      CALl s_errmsg('oma01',b_omb.omb01,'upd ogb60','axr-134',1)   #No.FUN-D40089   Add
        #   ELSE
        #      CALL cl_err('upd ogb60','axr-134',1)
        #   END IF
        #   LET g_success = 'N' RETURN
        #END IF
        #mark by pane 201201 end#
         IF g_ooz.ooz16='Y' THEN      # 發票確認時將發票金額更新回出貨單頭
           #FUN-A60056--mod--str--
           #IF cl_null(l_dbs) THEN      #No.FUN-9C0014 Add
           #SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = b_omb.omb31
           #SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file
           #                                    WHERE ogb01 = b_omb.omb31 
           #ELSE
           #   LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oga_file ",
           #               " WHERE oga01 = '",b_omb.omb31,"'"
           #   PREPARE sel_oga_pre09 FROM g_sql
           #   EXECUTE sel_oga_pre09 INTO g_oga.*
           #   LET g_sql = "SELECT SUM(ogb14) FROM ",l_dbs CLIPPED,"ogb_file",
           #               " WHERE ogb01 = '",b_omb.omb31,"'"
           #   PREPARE sel_ogb_pre10 FROM g_sql
           #   EXECUTE sel_ogb_pre10 INTO g_oga.oga50
           #END IF
            LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'oga_file'),
                        " WHERE oga01 = '",b_omb.omb31,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_oga_pre09 FROM g_sql
            EXECUTE sel_oga_pre09 INTO g_oga.*
 
            LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        " WHERE ogb01 = '",b_omb.omb31,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_ogb_pre10 FROM g_sql
            EXECUTE sel_ogb_pre10 INTO g_oga.oga50 
           #FUN-A60056--mod--end
            IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
            LET g_oga.oga21 = g_oma.oma21
            LET g_oga.oga211= g_oma.oma211
            LET g_oga.oga212= g_oma.oma212
            LET g_oga.oga213= g_oma.oma213
            LET g_oga.oga23 = g_oma.oma23
            LET g_oga.oga52 = g_oga.oga50 * g_oga.oga161/100
            LET g_oga.oga53 = g_oga.oga50 * (g_oga.oga162+g_oga.oga163)/100
           #FUN-A60056--mod--str--
           #IF cl_null(l_dbs) THEN
           #   UPDATE oga_file SET *=g_oga.* WHERE oga01 = g_oga.oga01
           #ELSE
           #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oga_file ",
           #               "   SET oga21 = ?,oga211 = ?,oga212 = ?,",
           #               "       oga213 = ?,oga23 = ?,oga52 = ?,",
           #               "       oga53 = ?,oga50 = ? ",
           #               " WHERE oga01 = '",g_oga.oga01,"'"
           #   PREPARE upd_oga_pre11 FROM g_sql
           #   EXECUTE upd_oga_pre11 USING g_oga.oga21,g_oga.oga211,g_oga.oga212,
           #                               g_oga.oga213,g_oga.oga23,g_oga.oga52,
           #                               g_oga.oga53,g_oga.oga50
           #END IF
         #mark by pane 201201 begin#
         #  LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oga_file'),
         #              "   SET oga21 = ?,oga211 = ?,oga212 = ?,",
         #              "       oga213 = ?,oga23 = ?,oga52 = ?,",
         #              "       oga53 = ?,oga50 = ? ",
         #              " WHERE oga01 = '",g_oga.oga01,"'"
         #  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         #  CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql 
         #  PREPARE upd_oga_pre11 FROM g_sql
         #  EXECUTE upd_oga_pre11 USING g_oga.oga21,g_oga.oga211,g_oga.oga212,
         #                              g_oga.oga213,g_oga.oga23,g_oga.oga52,
         #                              g_oga.oga53,g_oga.oga50
         # #FUN-A60056--mod--end
         #  IF STATUS OR SQLCA.SQLCODE THEN
         #     IF g_bgerr THEN
         #       #CALL s_errmsg('oga01',g_oga.oga01,'upd oga50',SQLCA.SQLCODE,1)  #No.FUN-D40089   Mark
         #        CALL s_errmsg('oga01',g_oga.oga01,b_omb.omb01,SQLCA.SQLCODE,1)  #No.FUN-D40089   add
         #     ELSE
         #        CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd ogb50",1)
         #     END IF
         #  END IF
         #mark by pane 201201 end#
         END IF
        #-----------------------------MOD-C30842------------------------start
         IF g_ooz.ooz16 ='Y' AND g_oga.oga09 = '8' THEN    #出貨單走簽收流程
           #發票確認時將發票單價更新回出貨單
            LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        " WHERE ogb01 ='",g_oga.oga011,"' AND ogb03 = '",b_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_ogb2_pre07 FROM g_sql
            EXECUTE sel_ogb2_pre07 INTO l_ogb.*
            IF STATUS THEN
               IF g_bgerr THEN
                  LET g_showmsg = g_oga.oga011,"/",b_omb.omb32
                 #CALL s_errmsg('ogb01,ogb03',g_showmsg,'s_ar_conf:sel ogb',STATUS,1)  #No.FUN-D40089   Mark
                  CALL s_errmsg('ogb01,ogb03',g_showmsg,b_omb.omb01,STATUS,1)  #No.FUN-D40089   Add
               ELSE
                  CALL cl_err3("sel","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_conf:sel ogb",1)
               END IF
               LET g_success = 'N'
               RETURN
            END IF
            IF cl_null(l_ogb.ogb917) THEN LET l_ogb.ogb917 = 0 END IF
            IF tot > ABS(l_ogb.ogb917) THEN          # 發票數量大於出貨單數量
               IF g_bgerr THEN
                 #CALL s_errmsg('','','s_ar_conf:omb12>ogb917','axr-174',1)   #No.FUN-D40089   Mark
                  CALL s_errmsg('oma01',b_omb.omb01,'s_ar_conf:omb12>ogb917','axr-174',1)   #No.FUN-D40089   Add
               ELSE
                  CALL cl_err('s_ar_conf:omb12>ogb917','axr-174',1)
               END IF
               LET g_success = 'N' RETURN
            END IF
            LET l_ogb.ogb13 = b_omb.omb13
            LET l_ogb.ogb14 = b_omb.omb14 * (-1)
            LET l_ogb.ogb14t= b_omb.omb14t* (-1)
         #mark by pane 201201 begin#
         #  LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ogb_file'),
         #              "   SET ogb13='",l_ogb.ogb13,"',",
         #              "       ogb14='",l_ogb.ogb14,"',",
         #              "       ogb14t='",l_ogb.ogb14t,"',",
         #              "       ogb1013=",tot,
         #              " WHERE ogb01 = '",g_oga.oga011,"' AND ogb03 = '",b_omb.omb32,"'"
         #  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         #  CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         #  PREPARE upd_ogb2_pre08 FROM g_sql
         #  EXECUTE upd_ogb2_pre08
         #  IF STATUS OR SQLCA.SQLCODE THEN
         #     IF g_bgerr THEN
         #       #CALL s_errmsg('','','upd ogb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
         #        CALL s_errmsg('oma01',b_omb.omb01,'upd ogb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
         #     ELSE
         #        CALL cl_err3("upd","ogb_file",g_oga.oga011,b_omb.omb32,STATUS,"","upd ogb60",1)
         #     END IF
         #     LET g_success = 'N'
         #     RETURN
         #  END IF
         #  IF STATUS=100 THEN
         #     IF g_bgerr THEN
         #       #CALl s_errmsg('','','upd ogb60','axr-134',1)   #No.FUN-D40089   Mark
         #        CALl s_errmsg('oma01',b_omb.omb01,'upd ogb60','axr-134',1)   #No.FUN-D40089   Add
         #     ELSE
         #        CALL cl_err('upd ogb60','axr-134',1)
         #     END IF
         #     LET g_success = 'N' RETURN
         #  END IF
         #mark by pane 201201 end#
           #發票確認時將發票金額更新回出貨單頭
            LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'oga_file'),
                        " WHERE oga01 = '",g_oga.oga011,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_oga2_pre09 FROM g_sql
            EXECUTE sel_oga2_pre09 INTO l_oga.*

            LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        " WHERE ogb01 = '",g_oga.oga011,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_ogb2_pre10 FROM g_sql
            EXECUTE sel_ogb2_pre10 INTO l_oga.oga50
            IF cl_null(l_oga.oga50) THEN LET l_oga.oga50 = 0 END IF
            LET l_oga.oga21 = g_oma.oma21
            LET l_oga.oga211= g_oma.oma211
            LET l_oga.oga212= g_oma.oma212
            LET l_oga.oga213= g_oma.oma213
            LET l_oga.oga23 = g_oma.oma23
            LET l_oga.oga52 = l_oga.oga50 * l_oga.oga161/100
            LET l_oga.oga53 = l_oga.oga50 * (l_oga.oga162+l_oga.oga163)/100

          #mark by pane 201201 begin#
          # LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oga_file'),
          #             "   SET oga21 = ?,oga211 = ?,oga212 = ?,",
          #             "       oga213 = ?,oga23 = ?,oga52 = ?,",
          #             "       oga53 = ?,oga50 = ? ",
          #             " WHERE oga01 = '",l_oga.oga01,"'"
          # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          # CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
          # PREPARE upd_oga2_pre11 FROM g_sql
          # EXECUTE upd_oga2_pre11 USING l_oga.oga21,l_oga.oga211,l_oga.oga212,
          #                              l_oga.oga213,l_oga.oga23,l_oga.oga52,
          #                              l_oga.oga53,l_oga.oga50
          # IF STATUS OR SQLCA.SQLCODE THEN
          #    IF g_bgerr THEN
          #      #CALL s_errmsg('oga01',l_oga.oga01,'upd oga50',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
          #       CALL s_errmsg('oga01',l_oga.oga01,b_omb.omb01,SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
          #    ELSE
          #       CALL cl_err3("upd","oga_file",l_oga.oga01,"",SQLCA.SQLCODE,"","upd ogb50",1)
          #    END IF
          # END IF
          #mark by pane 201201 end#
         END IF
        #-----------------------------MOD-C30842--------------------------end
         #未稅金額 * 出貨應收比率
         SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00=g_oma.oma00
         IF cl_null(tot) THEN LET tot = 0 END IF
         #FUN-A60056--mod--str--
         #IF cl_null(l_dbs) THEN
         #   UPDATE oga_file SET oga10=g_oma.oma01, oga54=tot
         #    WHERE oga01 = b_omb.omb31
         #ELSE
         #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oga_file ",
         #               "   SET oga10='",g_oma.oma01,"', oga54=",tot,
         #               " WHERE oga01 = '",b_omb.omb31,"'"
         #   PREPARE upd_oga_pre12 FROM g_sql
         #   EXECUTE upd_oga_pre12
         #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oga_file'),
                     "   SET oga10='",g_oma.oma01,"',",
                     "       oga54='",tot,"'",
                     " WHERE oga01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_oga_pre12 FROM g_sql
         EXECUTE upd_oga_pre12
         #FUN-A60056--mod--end
         IF STATUS THEN 
            IF g_bgerr THEN
              #CALL s_errmsg('oga01','b_omb.omb31','upd oga54',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oga01','b_omb.omb31',b_omb.omb01,SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err3("upd","oga_file",b_omb.omb31,"",SQLCA.SQLCODE,"","upd oga54",1) 
            END IF
            LET g_success = 'N' 
            RETURN
         END IF
         IF STATUS=100 THEN
            IF g_bgerr THEN
              #CALL s_errmsg('','','upd oga54','axr-134',1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'upd oga54','axr-134',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('upd oga54','axr-134',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
      END IF
 
      IF b_omb.omb38 = '3' THEN                  #No.FUN-670026 
         SELECT SUM(abs(omb12)),SUM(abs(omb14)) INTO tot,act FROM omb_file, oma_file #No.FUN-670026 
             WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
               AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
               AND oma00=g_oma.oma00
         IF cl_null(tot) THEN LET tot = 0 END IF
         IF cl_null(act) THEN LET act = 0 END IF  #No.FUN-9C0014 Add
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN
        #   SELECT ohb917 INTO g_ohb.ohb917 FROM ohb_file
        #       WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "SELECT ohb917 FROM ",l_dbs CLIPPED,"ohb_file",
        #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32 #No.FUN-9C0014
        #   PREPARE sel_ohb_pre13 FROM g_sql
        #   EXECUTE sel_ohb_pre13 INTO g_ohb.ohb917
        #END IF
         LET g_sql = "SELECT ohb917 FROM ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     " WHERE ohb01 = '",b_omb.omb31,"'",
                     "   AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ohb_pre13 FROM g_sql
         EXECUTE sel_ohb_pre13 INTO g_ohb.ohb917
        #FUN-A60056--mod--end
         IF cl_null(g_ohb.ohb917) THEN LET g_ohb.ohb917 = 0 END IF
         IF tot > ABS(g_ohb.ohb917) THEN   #No.TQC-B70006
            IF g_bgerr THEN
              #CALL s_errmsg('','','tot>ohb917','axr-174',1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'tot>ohb917','axr-174',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('tot>ohb917','axr-174',1)
            END IF
                LET g_success = 'N' RETURN
         END IF
         IF g_ooz.ooz16='Y' THEN   # 發票確認時將發票單價更新回出貨單(Y/N)
            LET g_ohb.ohb13 = b_omb.omb13
            LET g_ohb.ohb14 = b_omb.omb14 * (-1) #No.FUN-670026 
            LET g_ohb.ohb14t= b_omb.omb14t* (-1) #No.FUN-670026 
           #FUN-A60056--mod--str--
           #IF cl_null(l_dbs) THEN  #No.FUN-9C0014 Add
           #UPDATE ohb_file SET
           #       ohb13=g_ohb.ohb13,
           #       ohb14=g_ohb.ohb14,
           #       ohb14t=g_ohb.ohb14t
           # WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
           #ELSE
           #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file",
           #               "   SET ohb13='",g_ohb.ohb13,"',",
           #               "       ohb14='",g_ohb.ohb14,"',",
           #               "       ohb14t='",g_ohb.ohb14t,"'",
           #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32 #No.FUN-9C0014
           #   PREPARE upd_ohb_pre14 FROM g_sql
           #   EXECUTE upd_ohb_pre14               
           #END IF
         #mark by pane 201201 begin#
         #  LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
         #              "   SET ohb13='",g_ohb.ohb13,"',",
         #              "       ohb14='",g_ohb.ohb14,"',",
         #              "       ohb14t='",g_ohb.ohb14t,"'",
         #              " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32 
         #  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         #  CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         #  PREPARE upd_ohb_pre14 FROM g_sql
         #  EXECUTE upd_ohb_pre14
         # #FUN-A60056--mod--end

         #  IF STATUS OR SQLCA.SQLCODE THEN
         #     IF g_bgerr THEN
         #       #CALL s_errmsg('','','up ohb13,ohb14,ohb14t',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
         #        CALL s_errmsg('oma01',b_omb.omb01,'up ohb13,ohb14,ohb14t',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
         #     ELSE
         #        CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,SQLCA.SQLCODE,"","up ohb13,ohb14,ohb14t",1)
         #     END IF
         #     LET g_success = 'N' RETURN
         #  END IF
         #mark by pane 201201 end#
         END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN                  #No.FUN-9C0014 Add
        #UPDATE ohb_file SET ohb60=tot,
        #                    ohb1012 = act       #No.FUN-670026 
        # WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file SET ohb60=",tot,",",
        #               "                                     ohb1012=",act,
        #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32
        #   PREPARE upd_ohb_pre15 FROM g_sql
        #   EXECUTE upd_ohb_pre15
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     "   SET ohb60='",tot,"',",
                     "       ohb1012='",act,"'",
                     " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_ohb_pre15 FROM g_sql
         EXECUTE upd_ohb_pre15
        #FUN-A60056--mod--end
         IF STATUS THEN
            IF g_bgerr THEN
              #CALL s_errmsg('','','upd ohb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'upd ohb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,SQLCA.SQLCODE,"","up ohb60",1)
            END IF
            LET g_success = 'N' 
            RETURN
         END IF
         IF STATUS=100 THEN
            IF g_bgerr THEN
              #CALL s_errmsg('','','upd ohb60','axr-134',1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'upd ohb60','axr-134',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('upd ohb60','axr-134',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
         SELECT SUM(omb14) INTO tot1 FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00='12'
         IF cl_null(tot1) THEN LET tot1=0 END IF   #MOD-990153 add
         SELECT SUM(omb14) INTO tot2 FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00='21'
         IF cl_null(tot2) THEN LET tot2=0 END IF   #MOD-990153 add
         LET tot = tot1 * (-1) + tot2
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #UPDATE oha_file SET oha54 = tot WHERE oha01 = b_omb.omb31
        #UPDATE oha_file SET
        #       oha21=g_oma.oma21,
        #       oha211=g_oma.oma211,
        #       oha212=g_oma.oma212,
        #       oha213=g_oma.oma213,
        #       oha24=g_oma.oma24,
        #       oha54=tot
        #WHERE oha01 = b_omb.omb31
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file SET oha54 = ",tot,
        #               " WHERE oha01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oha_pre16 FROM g_sql
        #   EXECUTE upd_oha_pre16
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file ",
        #               "   SET oha21='",g_oma.oma21,"',",
        #               "       oha211='",g_oma.oma211,"',",
        #               "       oha212='",g_oma.oma212,"',",
        #               "       oha213='",g_oma.oma213,"',",
        #               "       oha24='",g_oma.oma24,"',",
        #               "       oha54=",tot,
        #               " WHERE oha01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oha_pre17 FROM g_sql
        #   EXECUTE upd_oha_pre17
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
                     "   SET oha54 ='",tot,"'",
                     " WHERE oha01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_oha_pre16 FROM g_sql
         EXECUTE upd_oha_pre16

       #mark by pane 201201 begin#
       # LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
       #             "   SET oha21='",g_oma.oma21,"',",
       #             "       oha211='",g_oma.oma211,"',",
       #             "       oha212='",g_oma.oma212,"',",
       #             "       oha213='",g_oma.oma213,"',",
       #             "       oha24='",g_oma.oma24,"',",
       #             "       oha54=",tot,
       #             " WHERE oha01 = '",b_omb.omb31,"'"
       # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       # CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
       # PREPARE upd_oha_pre17 FROM g_sql
       # EXECUTE upd_oha_pre17
       ##FUN-A60056--mod--end
       # IF STATUS THEN
       #    IF g_bgerr THEN
       #      #CALL s_errmsg('oha01','b_omb.omb31','upd oha54',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
       #       CALL s_errmsg('oha01','b_omb.omb31',b_omb.omb01,SQLCA.SQLCODE,1)   #NO.FUN-D40089   Add
       #    ELSE
       #      #CALL s_errmsg('','','upd oha54','axr-134',1)   #No.FUN-D40089   Mark
       #       CALL s_errmsg('oma01',b_omb.omb01,'upd oha54','axr-134',1)   #No.FUN-D40089   Add
       #    END IF
       #    LET g_success = 'N' 
       #    RETURN
       # END IF
       #mark by pane 201201 end#
         IF STATUS=100 THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','upd oha54','axr-134',1)
            ELSE
               CALL cl_err('upd oha54','axr-134',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
      END IF
 
      IF b_omb.omb38 = '5' THEN                  #No.FUN-670026 
         SELECT SUM(abs(omb14)) INTO tot FROM omb_file, oma_file
             WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
               AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
               AND (oma00='21' or oma00='12')
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #SELECT ohb14 INTO g_ohb.ohb14 FROM ohb_file
        #       WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "SELECT ohb14 FROM ",l_dbs CLIPPED,"ohb_file",
        #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32
        #   PREPARE sel_ohb_pre18 FROM g_sql
        #   EXECUTE sel_ohb_pre18 INTO g_ohb.ohb14
        #END IF
         LET g_sql = "SELECT ohb14 FROM ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     " WHERE ohb01 = '",b_omb.omb31,"'",
                     "   AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ohb_pre18 FROM g_sql
         EXECUTE sel_ohb_pre18 INTO g_ohb.ohb14
        #FUN-A60056--mod--end
         IF cl_null(g_ohb.ohb14) THEN LET g_ohb.ohb14 = 0 END IF
         IF tot > g_ohb.ohb14 THEN
            IF g_bgerr THEN
              #CALL s_errmsg('','','tot>ohb14','axr-174',1)   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'tot>ohb14','axr-174',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('tot>ohb14','axr-174',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
         IF g_ooz.ooz16='Y' THEN   # 發票確認時將發票單價更新回出貨單(Y/N)
            LET g_ohb.ohb13 = b_omb.omb13
            LET g_ohb.ohb14 = b_omb.omb14
            LET g_ohb.ohb14t= b_omb.omb14t
           #FUN-A60056--mod--str--
           #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
           #UPDATE ohb_file SET
           #       ohb13=g_ohb.ohb13,
           #       ohb14=g_ohb.ohb14,
           #       ohb14t=g_ohb.ohb14t
           #WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
           #ELSE
           #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file",
           #               "   SET ohb13='",g_ohb.ohb13,"',",
           #               "       ohb14='",g_ohb.ohb14,"',", 
           #               "       ohb14t='",g_ohb.ohb14t,"'",
           #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32
           #   PREPARE upd_ohb_pre19 FROM g_sql
           #   EXECUTE upd_ohb_pre19
           #END IF
          #mark by pane 201201 begin#
          # LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
          #             "   SET ohb13='",g_ohb.ohb13,"',",
          #             "       ohb14='",g_ohb.ohb14,"',",
          #             "       ohb14t='",g_ohb.ohb14t,"'",
          #             " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32
          # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          # CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
          # PREPARE upd_ohb_pre19 FROM g_sql
          # EXECUTE upd_ohb_pre19
          ##FUN-A60056--mod--end
          # IF STATUS OR SQLCA.SQLCODE THEN
          #    IF g_bgerr THEN
          #      #CALl s_errmsg('','','up ohb13,ohb14,ohb14t',SQLCA.SQLCODE,1)  #No.FUN-D40089   Mark
          #       CALl s_errmsg('oma01',b_omb.omb01,'up ohb13,ohb14,ohb14t',SQLCA.SQLCODE,1)  #No.FUN-D40080   Add
          #    ELSE
          #       CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,SQLCA.SQLCODE,"","up ohb13,ohb14,ohb14t",1)
          #    END IF
          #    LET g_success = 'N' RETURN
          # END IF
          #mark by pane 201201 end#
         END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN    #No.FUN-9C0014 Add
        #UPDATE ohb_file SET ohb1012=tot
        # WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file SET ohb1012=",tot,
        #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = ",b_omb.omb32
        #   PREPARE upd_ohb_pre20 FROM g_sql
        #   EXECUTE upd_ohb_pre20
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     "   SET ohb1012='",tot,"'",
                     " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_ohb_pre20 FROM g_sql
         EXECUTE upd_ohb_pre20
        #FUN-A60056--mod--end
         IF STATUS THEN
            IF g_bgerr THEN
              #CALl s_errmsg('','','upd ohb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
               CALl s_errmsg('oma01',b_omb.omb01,'upd ohb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,SQLCA.SQLCODE,"","up ohb60",1)
            END IF
            LET g_success = 'N' 
            RETURN
         END IF
         IF STATUS=100 THEN
            IF g_bgerr THEN
              #CALL s_errmsg('','','upd ohb60','axr-134',1)  #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'upd ohb60','axr-134',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('upd ohb60','axr-134',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
         SELECT SUM(omb14) INTO tot1 FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00='12'
         IF cl_null(tot1) THEN LET tot1=0 END IF   #MOD-990153 add
         SELECT SUM(omb14) INTO tot2 FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00='21'
         IF cl_null(tot2) THEN LET tot2=0 END IF   #MOD-990153 add
         LET tot = tot1 + tot2 * (-1)
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN    #No.FUN-9C0014 Add
        #UPDATE oha_file SET oha54 = tot WHERE oha01 = b_omb.omb31
        #UPDATE oha_file SET
        #       oha21=g_oma.oma21,
        #       oha211=g_oma.oma211,
        #       oha212=g_oma.oma212,
        #       oha213=g_oma.oma213,
        #       oha24=g_oma.oma24,
        #       #oha50=tot,   #MOD-720091
        #       oha54=tot
        #WHERE oha01 = b_omb.omb31
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file SET oha54 = '",tot,"'",
        #               " WHERE oha01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oha_pre21 FROM g_sql
        #   EXECUTE upd_oha_pre21
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file ",
        #               "   SET oha21='",g_oma.oma21,"',",
        #               "       oha211='",g_oma.oma211,"',",
        #               "       oha212='",g_oma.oma212,"',", 
        #               "       oha213='",g_oma.oma213,"',",
        #               "       oha24='",g_oma.oma24,"',",
        #               "       oha54='",tot,"'",
        #               " WHERE oha01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oha_pre22 FROM g_sql
        #   EXECUTE upd_oha_pre22
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
                     "   SET oha54 ='",tot,"'",
                     " WHERE oha01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_oha_pre21 FROM g_sql
         EXECUTE upd_oha_pre21

       #mark by pane 201201 begin#
       # LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
       #             "   SET oha21='",g_oma.oma21,"',",
       #             "       oha211='",g_oma.oma211,"',",
       #             "       oha212='",g_oma.oma212,"',",
       #             "       oha213='",g_oma.oma213,"',",
       #             "       oha24='",g_oma.oma24,"',",
       #             "       oha54='",tot,"'",
       #             " WHERE oha01 = '",b_omb.omb31,"'"
       # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       # CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
       # PREPARE upd_oha_pre22 FROM g_sql
       # EXECUTE upd_oha_pre22
       ##FUN-A60056--mod--end
       # IF STATUS THEN
       #    IF g_bgerr THEN
       #      #CALL s_errmsg('oha01','b_omb.omb31','upd oha54',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
       #       CALL s_errmsg('oha01','b_omb.omb31',b_omb.omb01,SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
       #    ELSE
       #       CALL cl_err3("upd","oha_file",b_omb.omb31,"",SQLCA.SQLCODE,"","up oha54",1)
       #    END IF
       #    LET g_success = 'N' 
       #    RETURN
       # END IF
       #mark by pane 201201 end#
         IF STATUS=100 THEN
            IF g_bgerr THEN
              #CALL s_errmsg('','','upd oha54','axr-134',1)  #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',b_omb.omb01,'upd oha54','axr-134',1)   #No.FUN-D40089   Add
            ELSE
               CALL cl_err('upd oha54','axr-134',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
      END IF
   END IF   #MOD-AC0236
   IF g_oma.oma00 = '21' AND NOT cl_null(b_omb.omb31) THEN
      IF b_omb.omb38='3' THEN
         SELECT SUM(abs(omb12)),SUM(abs(omb14)) INTO tot,act FROM omb_file, oma_file
             WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
               AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
               AND oma00=g_oma.oma00
         IF cl_null(tot) THEN LET tot = 0 END IF
         IF cl_null(act) THEN LET act = 0 END IF                   #TQC-A50130 Add  
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #SELECT ohb917 INTO g_ohb.ohb917 FROM ohb_file
        #       WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "SELECT ohb917 FROM ",l_dbs CLIPPED,"ohb_file",
        #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
        #   PREPARE sel_ohb_pre23 FROM g_sql
        #   EXECUTE sel_ohb_pre23 INTO g_ohb.ohb917
        #END IF
         LET g_sql = "SELECT ohb917 FROM ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ohb_pre23 FROM g_sql
         EXECUTE sel_ohb_pre23 INTO g_ohb.ohb917
        #FUN-A60056--mod--end
         IF cl_null(g_ohb.ohb917) THEN LET g_ohb.ohb917 = 0 END IF
         IF tot > ABS(g_ohb.ohb917) THEN    #No.TQC-B70006
         IF g_bgerr THEN
           #CALL s_errmsg('','','tot>ohb917','axr-174',1)   #No.FUN-D40089   Mark
            CALL s_errmsg('oma01',b_omb.omb01,'tot>ohb917','axr-174',1)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err('tot>ohb917','axr-174',1)
         END IF
            LET g_success = 'N' RETURN
         END IF
         IF g_ooz.ooz16='Y' THEN   # 發票確認時將發票單價更新回出貨單(Y/N)
            LET g_ohb.ohb13 = b_omb.omb13
            LET g_ohb.ohb14 = b_omb.omb14
            LET g_ohb.ohb14t= b_omb.omb14t
           #FUN-A60056--mod--str--
           #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
           #UPDATE ohb_file SET
           #       ohb13=g_ohb.ohb13,
           #       ohb14=g_ohb.ohb14,
           #       ohb14t=g_ohb.ohb14t
           # WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
           #ELSE
           #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file ",
           #               "   SET ohb13='",g_ohb.ohb13,"',",
           #               "       ohb14='",g_ohb.ohb14,"',",
           #               "       ohb14t='",g_ohb.ohb14t,"'",
           #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
           #   PREPARE upd_ohb_pre24 FROM g_sql
           #   EXECUTE upd_ohb_pre24
           #END IF 
          #mark by pane 201201 begin#
          # LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
          #             "   SET ohb13='",g_ohb.ohb13,"',",
          #             "       ohb14='",g_ohb.ohb14,"',",
          #             "       ohb14t='",g_ohb.ohb14t,"'",
          #             " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
          # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          # CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql 
          # PREPARE upd_ohb_pre24 FROM g_sql
          # EXECUTE upd_ohb_pre24
          ##FUN-A60056--mod--end
          # IF STATUS OR SQLCA.SQLCODE THEN
          # IF g_bgerr THEN
          #   #CALl s_errmsg('','','up ohb13,ohb14,ohb14t',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
          #    CALl s_errmsg('oma01',b_omb.omb01,'up ohb13,ohb14,ohb14t',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
          # ELSE
          #    CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,SQLCA.SQLCODE,"","up ohb13,ohb14,ohb14t",1)
          # END IF
          #    LET g_success = 'N' RETURN
          # END IF
          #mark by pane 201201 end#
         END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #UPDATE ohb_file SET ohb60=tot,
        #                    ohb1012=act
        # WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file",
        #               "   SET ohb60='",tot,"',ohb1012='",act,"'",
        #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
        #   PREPARE upd_ohb_pre25 FROM g_sql
        #   EXECUTE upd_ohb_pre25
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     "   SET ohb60='",tot,"',ohb1012='",act,"'",
                     " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_ohb_pre25 FROM g_sql
         EXECUTE upd_ohb_pre25
        #FUN-A60056--mod--end
         IF STATUS THEN
         IF g_bgerr THEN
           #CALl s_errmsg('','','upd ohb60',SQLCA.SQLCODE,1)                 #No.FUN-D40089   Mark
            CALl s_errmsg('oma01',b_omb.omb01,'upd ohb60',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,SQLCA.SQLCODE,"","up ohb60",1)
         END IF
            LET g_success = 'N' 
            RETURN
         END IF
         IF STATUS=100 THEN
         IF g_bgerr THEN
           #CALL s_errmsg('','','upd ohb60','axr-134',1)   #No.FUN-D40089   Mark
            CALL s_errmsg('oma01',b_omb.omb01,'upd ohb60','axr-134',1)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err('upd ohb60','axr-134',1)
         END IF
            LET g_success = 'N' RETURN
         END IF
         SELECT SUM(omb14) INTO tot1 FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00='12'
         IF cl_null(tot1) THEN LET tot1=0 END IF   #MOD-990153 add
         SELECT SUM(omb14) INTO tot2 FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00='21'
         IF cl_null(tot2) THEN LET tot2=0 END IF   #MOD-990153 add
         LET tot = tot1 * (-1) + tot2 
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #UPDATE oha_file SET oha54 = tot WHERE oha01 = b_omb.omb31
        #UPDATE oha_file SET
        #       oha21=g_oma.oma21,
        #       oha211=g_oma.oma211,
        #       oha212=g_oma.oma212,
        #       oha213=g_oma.oma213,
        #       oha24=g_oma.oma24,
        #       #oha50=tot,   #MOD-920091
        #       oha54=tot
        #WHERE oha01 = b_omb.omb31
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file SET oha54 = ",tot,
        #               " WHERE oha01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oha_pre26 FROM g_sql
        #   EXECUTE upd_oha_pre26
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file ",
        #               "   SET oha21='",g_oma.oma21,"',",
        #               "       oha211='",g_oma.oma211,"',",
        #               "       oha212='",g_oma.oma212,"',", 
        #               "       oha213='",g_oma.oma213,"',",
        #               "       oha24='",g_oma.oma24,"',",
        #               "       oha54='",tot,"'",
        #               " WHERE oha01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oha_pre27 FROM g_sql
        #   EXECUTE upd_oha_pre27
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
                     "   SET oha54 = '",tot,"'",
                     " WHERE oha01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_oha_pre26 FROM g_sql
         EXECUTE upd_oha_pre26

       #mark by pane 201201 begin#
       # LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
       #             "   SET oha21='",g_oma.oma21,"',",
       #             "       oha211='",g_oma.oma211,"',",
       #             "       oha212='",g_oma.oma212,"',",
       #             "       oha213='",g_oma.oma213,"',",
       #             "       oha24='",g_oma.oma24,"',",
       #             "       oha54='",tot,"'",
       #             " WHERE oha01 = '",b_omb.omb31,"'"
       # CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       # CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
       # PREPARE upd_oha_pre27 FROM g_sql
       # EXECUTE upd_oha_pre27 
       ##FUN-A60056--mod--end
       # IF STATUS THEN
       # IF g_bgerr THEN
       #   #CALl s_errmsg('oha01','b_omb.omb31','upd oha54',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
       #    CALl s_errmsg('oha01','b_omb.omb31',b_omb.omb01,SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
       # ELSE
       #    CALL cl_err3("upd","oha_file",b_omb.omb31,"",SQLCA.SQLCODE,"","up oha54",1)
       # END IF
       #    LET g_success = 'N' 
       #    RETURN
       # END IF
       #mark by pane 201201 end#
         IF STATUS=100 THEN
         IF g_bgerr THEN
           #CALl s_errmsg('','','upd oha54','axr-134',1)                 #No.FUN-D40089   Mark
            CALl s_errmsg('oma01',b_omb.omb01,'upd oha54','axr-134',1)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err('upd oha54','axr-134',1)
         END IF
            LET g_success = 'N' RETURN
         END IF
      END IF
 
      IF b_omb.omb38 = '5' THEN                  #No.FUN-670026 
         SELECT SUM(abs(omb14)) INTO tot FROM omb_file, oma_file
             WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
               AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
               AND (oma00='21' or oma00='12')
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #SELECT ohb14 INTO g_ohb.ohb14 FROM ohb_file
        #       WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "SELECT ohb14 FROM ",l_dbs CLIPPED,"ohb_file",
        #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
        #   PREPARE sel_oha_pre28 FROM g_sql
        #   EXECUTE sel_oha_pre28 INTO g_ohb.ohb14
        #END IF
         LET g_sql = "SELECT ohb14 FROM ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_oha_pre28 FROM g_sql
         EXECUTE sel_oha_pre28 INTO g_ohb.ohb14
        #FUN-A60056--mod--end
         IF cl_null(g_ohb.ohb14) THEN LET g_ohb.ohb14 = 0 END IF
         IF tot > g_ohb.ohb14 THEN
         IF g_bgerr THEN
           #CALL s_errmsg('','','tot>ohb14','axr-174',1)   #No.FUN-D40089   Mark
            CALL s_errmsg('oma01',b_omb.omb01,'tot>ohb14','axr-174',1)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err('tot>ohb14','axr-174',1)
         END IF
         LET g_success = 'N' RETURN
         END IF
         IF g_ooz.ooz16='Y' THEN   # 發票確認時將發票單價更新回出貨單(Y/N)
            LET g_ohb.ohb13 = b_omb.omb13
            LET g_ohb.ohb14 = b_omb.omb14
            LET g_ohb.ohb14t= b_omb.omb14t
           #FUN-A60056--mod--str--
           #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
           #UPDATE ohb_file SET
           #       ohb13=g_ohb.ohb13,
           #       ohb14=g_ohb.ohb14,
           #       ohb14t=g_ohb.ohb14t
           #WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
           #ELSE
           #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file",
           #               "   SET ohb13='",g_ohb.ohb13,"',",
           #               "       ohb14='",g_ohb.ohb14,"',",
           #               "       ohb14t='",g_ohb.ohb14t,"'",
           #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
           #   PREPARE upd_ohb_pre29 FROM g_sql
           #   EXECUTE upd_ohb_pre29
           #END IF
         #mark by pane 201201 begin#
         #  LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
         #              "   SET ohb13='",g_ohb.ohb13,"',",
         #              "       ohb14='",g_ohb.ohb14,"',",
         #              "       ohb14t='",g_ohb.ohb14t,"'",
         #              " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
         #  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         #  CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         #  PREPARE upd_ohb_pre29 FROM g_sql
         #  EXECUTE upd_ohb_pre29
         # #FUN-A60056--mod--end
         #  IF STATUS OR SQLCA.SQLCODE THEN
         #  IF g_bgerr THEN
         #    #CALl s_errmsg('','','up ohb13,ohb14,ohb14t',SQLCA.SQLCODE,1)                 #No.FUN-D40089   Mark
         #     CALl s_errmsg('oma01',b_omb.omb01,'up ohb13,ohb14,ohb14t',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add 
         #  ELSE
         #     CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,SQLCA.SQLCODE,"","up ohb13,ohb14,ohb14t",1)
         #  END IF
         #     LET g_success = 'N' RETURN
         #  END IF
         #mark by pane 201201 end#
         END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #UPDATE ohb_file SET ohb1012=tot
        # WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file SET ohb1012='",tot,"'",
        #               " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
        #   PREPARE upd_ohb_pre30 FROM g_sql
        #   EXECUTE upd_ohb_pre30
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     "   SET ohb1012='",tot,"'",
                     " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_ohb_pre30 FROM g_sql
         EXECUTE upd_ohb_pre30
        #FUN-A60056--mod--end
         IF STATUS THEN
         IF g_bgerr THEN
           #CALL s_errmsg('','','upd ohb60',SQLCA.SQLCODE,1)                #No.FUN-D40089   Add
            CALL s_errmsg('oma01',b_omb.omb01,'upd ohb60',SQLCA.SQLCODE,1)  #No.FUN-D40089   Add 
         ELSE
            CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,SQLCA.SQLCODE,"","up ohb60",1)
         END IF
            LET g_success = 'N' 
            RETURN
         END IF
         IF STATUS=100 THEN
         IF g_bgerr THEN
           #CALL s_errmsg('','','upd ohb60','axr-134',1)                 #No.FUN-D40089   Mark
            CALL s_errmsg('oma01',b_omb.omb01,'upd ohb60','axr-134',1)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err('upd ohb60','axr-134',1)
         END IF
            LET g_success = 'N' RETURN
         END IF
         SELECT SUM(omb14) INTO tot1 FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00='12'
         IF cl_null(tot1) THEN LET tot1=0 END IF   #MOD-990153 add
         SELECT SUM(omb14) INTO tot2 FROM omb_file, oma_file
           WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'
             AND oma00='21'
         IF cl_null(tot2) THEN LET tot2=0 END IF   #MOD-990153 add
         LET tot = tot1 + tot2 * (-1)
         IF cl_null(tot) THEN LET tot = 0 END IF
        #FUN-A60056--mod--str--
        #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #UPDATE oha_file SET oha54 = tot WHERE oha01 = b_omb.omb31
        #UPDATE oha_file SET
        #       oha21=g_oma.oma21,
        #       oha211=g_oma.oma211,
        #       oha212=g_oma.oma212,
        #       oha213=g_oma.oma213,
        #       oha24=g_oma.oma24,
        #       oha54=tot
        #WHERE oha01 = b_omb.omb31
        #ELSE
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file SET oha54 = ",tot,
        #               " WHERE oha01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oha_pre31 FROM g_sql
        #   EXECUTE upd_oha_pre31
        #   LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file",
        #               "   SET oha21='",g_oma.oma21,"',",
        #               "       oha211='",g_oma.oma211,"',",
        #               "       oha212='",g_oma.oma212,"',", 
        #               "       oha213='",g_oma.oma213,"',",
        #               "       oha24='",g_oma.oma24,"',",
        #               "       oha54=",tot,
        #               " WHERE oha01 = '",b_omb.omb31,"'"
        #   PREPARE upd_oha_pre32 FROM g_sql
        #   EXECUTE upd_oha_pre32
        #END IF
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
                     "   SET oha54 = '",tot,"'",
                     " WHERE oha01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE upd_oha_pre31 FROM g_sql
         EXECUTE upd_oha_pre31
   
      #mark by pane 201201 begin#
      #  LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
      #              "   SET oha21='",g_oma.oma21,"',",
      #              "       oha211='",g_oma.oma211,"',",
      #              "       oha212='",g_oma.oma212,"',",
      #              "       oha213='",g_oma.oma213,"',",
      #              "       oha24='",g_oma.oma24,"',",
      #              "       oha54=",tot,
      #              " WHERE oha01 = '",b_omb.omb31,"'"
      #  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      #  CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
      #  PREPARE upd_oha_pre32 FROM g_sql
      #  EXECUTE upd_oha_pre32
      # #FUN-A60056--mod--end
      #  IF STATUS THEN
      #  IF g_bgerr THEN
      #    #CALl s_errmsg('oha01','b_omb.omb31','upd oha54',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
      #     CALl s_errmsg('oha01','b_omb.omb31',g_oma.oma01,SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
      #  ELSE
      #     CALL cl_err3("upd","oha_file",b_omb.omb31,"",SQLCA.SQLCODE,"","up oha54",1)
      #  END IF
      #     LET g_success = 'N' 
      #     RETURN
      #  END IF
      #mark by pane 201201 end#
         IF STATUS=100 THEN
         IF g_bgerr THEN
           #CALL s_errmsg('','','upd oha54','axr-134',1)                 #No.FUN-D40089   Add
            CALL s_errmsg('oma01',g_oma.oma01,'upd oha54','axr-134',1)   #No.FUN-D40089   Add
         ELSE
            CALL cl_err('upd oha54','axr-134',1)
         END IF
            LET g_success = 'N' RETURN
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION s_yz_hu3() #更新出貨單頭
END FUNCTION
 
FUNCTION s_yz_hu1(p_sw)                    #產生/刪除預收帳款檔 (oma_file)
  DEFINE li_result      LIKE type_file.num5         #No.FUN-680123 SMALLINT
  DEFINE l_cnt          LIKE type_file.num5         #No.FUN-680123 SMALLINT
  DEFINE p_sw          LIKE type_file.chr1         #No.FUN-680123 VARCHAR(1)               # +:產生 -:刪除
  DEFINE l_oma          RECORD LIKE oma_file.*
  DEFINE l_omc          RECORD LIKE omc_file.*  #No.FUN-680022
  DEFINE l_buf          LIKE type_file.chr3         #No.FUN-680123 VARCHAR(3)
  DEFINE l_str          STRING                  
  DEFINE l_oow19        LIKE oow_file.oow19

  LET l_str = "bu_22:",g_oma.oma01 CLIPPED,' ',g_oma.oma02 CLIPPED 
  CALL cl_msg(l_str)
 
  INITIALIZE l_oma.* TO NULL
  IF p_sw = '-' THEN
     SELECT * INTO l_oma.* FROM oma_file WHERE oma01=g_oma.oma19
     IF l_oma.oma55 > 0 OR l_oma.oma57 > 0 THEN
     IF g_bgerr THEN
       #CALL s_errmsg('oma01',g_oma.oma19,'oma55,57>0','axr-206',1)  #No.FUN-D40089   Mark
        CALL s_errmsg('oma01',g_oma.oma19,g_oma.oma01,'axr-206',1)   #No.FUN-D40089   Add
     ELSE
        CALL cl_err('oma55,57>0','axr-206',1)
     END IF
         LET g_success = 'N' RETURN
     END IF
     DELETE FROM oma_file WHERE oma01 = g_oma.oma19
     IF STATUS THEN
     IF g_bgerr THEN
        CALL s_errmsg('oma01',g_oma.oma19,'del oma',STATUS,1)
     ELSE
        CALL cl_err3("del","oma_file",g_oma.oma19,"",STATUS,"","del oma",1)
     END IF
        LET g_success = 'N' 
        RETURN
     END IF
     SELECT ool21,ool211 INTO g_ool.ool21,g_ool.ool211 FROM ool_file WHERE ool01 = g_oma.oma13
     UPDATE npq_file SET npq23 = '' 
      WHERE npq01 = g_oma.oma01
        AND (npq03 = g_ool.ool21 OR npq03 = g_ool.ool211)
        AND npq06 = '2'
     IF STATUS OR SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg('npq01',g_oma.oma01,'upd npq23',SQLCA.SQLCODE,1)
        ELSE
           CALL cl_err3("upd","npq_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd npq23",1)
        END IF
        LET g_success = 'N' 
        RETURN
     END IF
     DELETE FROM omc_file WHERE omc01 = g_oma.oma19   
     IF STATUS THEN
     IF g_bgerr THEN
       #CALL s_errmsg('omc',g_oma.oma19,"del omc",STATUS,1)     #No.FUN-D40089   Mark
        CALL s_errmsg('omc',g_oma.oma19,g_oma.oma01,STATUS,1)   #No.FUN-D40089   Add
     ELSE
        CALL cl_err3("del","omc_file",g_oma.oma01,"",STATUS,"","del omc",1)
     END IF
        LET g_success = 'N' 
        RETURN
     END IF
     DELETE FROM oov_file WHERE oov01 = g_oma.oma19                   
     IF SQLCA.sqlcode THEN                                            
     IF g_bgerr THEN
       #CALl s_errmsg('oov01',g_oma.oma19,'del oov',status,1)     #No.FUN-D40089   Mark
        CALl s_errmsg('oov01',g_oma.oma19,g_oma.oma01,status,1)   #No.FUN-D40089   Add
     ELSE
        CALL cl_err3("del","oov_file",g_oma.oma19,"",STATUS,"","del oov",1)
     END IF
        LET g_success='N'                                             
     END IF        
     UPDATE oma_file SET oma19 = '' WHERE oma01=g_oma.oma01
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN 
           CALL s_errmsg('oma01',g_oma.oma01,'upd oma',status,1)
        ELSE
           CALL cl_err3("upd","oma_file",g_oma.oma01,"",STATUS,"","upd oma",1)
        END IF
        LET g_success='N'
     END IF
     #TQC-C20430--add--str--
     IF g_oma.oma00 = '15' THEN   ##更新業務待抵單的財務單號
        LET g_sql = "UPDATE ",cl_get_target_table(g_oma.oma66,'luk_file')," SET luk16 = NULL",
                    " WHERE luk05 = (SELECT lui01 FROM ",cl_get_target_table(g_oma.oma66,'lui_file')," WHERE lui04 = '",g_oma.oma16,"')"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
        PREPARE t300_upd_luk FROM g_sql
        EXECUTE t300_upd_luk
     END IF 
     #TQC-C20430--add--end
  END IF
  IF p_sw = '+' THEN
     LET l_oma.* = g_oma.*
     IF cl_null(g_oma.oma19)
        THEN LET l_oma.oma01 = g_ooz.ooz21,'-' 
        ELSE LET l_oma.oma01 = g_oma.oma19
     END IF
     #TQC-C20430--add--str--
     IF g_oma.oma00 = '15' THEN
        IF cl_null(g_oma.oma19) THEN
           SELECT oow19 INTO l_oow19 FROM oow_file WHERE oow00 = '0' 
           IF cl_null(l_oow19) THEN
               CALL s_errmsg('oow19',l_oow19,'','axr-149',1)
               LET g_success = 'N'
           ELSE
               LET l_oma.oma01 = l_oow19,'-'
           END IF
        ELSE
           LET l_oma.oma01 = g_oma.oma19
        END IF 
     END IF
     #TQC-C20430--add--end
    CALL s_auto_assign_no("axr",l_oma.oma01,l_oma.oma02,"23","oma_file","oma01","","","")
    RETURNING li_result,l_oma.oma01
    IF (NOT li_result) THEN
        LET l_oma.oma01 = l_oma.oma01,'-'
        FOR l_cnt = g_no_sp TO g_no_ep-1
        LET l_oma.oma01 = l_oma.oma01,'0'
        END FOR
        LET l_oma.oma01 = l_oma.oma01,'1'
    END IF 
    
     CALL cl_msg(l_oma.oma01)             #FUN-640246
 
     #TQC-C20430--add--str--
     IF g_oma.oma00 = '15' THEN
        LET l_oma.oma00 = '26'
     ELSE
     #TQC-C20430--add--end
        LET l_oma.oma00 = '23'     
     END IF #TQC-C20430
     LET l_oma.oma18 = NULL
     SELECT ool21 INTO l_oma.oma18 FROM ool_file
      WHERE ool01 = g_oma.oma13
     IF g_aza.aza63 = 'Y' THEN
        SELECT ool211 INTO l_oma.oma181 FROM ool_file
         WHERE ool01 = g_oma.oma13
     END IF
     LET l_oma.oma21=NULL
     LET l_oma.oma211=0
     LET l_oma.oma213='N'
     LET l_oma.oma54x=0           LET l_oma.oma56x=0          
     LET l_oma.oma54t=g_oma.oma54 LET l_oma.oma56t=g_oma.oma56
     LET l_oma.oma55=0 LET l_oma.oma57=0
     LET l_oma.oma60=l_oma.oma24                   #bug no:A060
     LET l_oma.oma61=l_oma.oma56t-l_oma.oma57      #bug no:A060
     LET l_oma.omaconf='Y' LET l_oma.omavoid='N'
     LET l_oma.oma64 = '1'                         #No.TQC-9C0057
#    LET l_oma.oma70 = '2'                         #No.FUN-9C0014 Add   #FUN-B40032 MARK
     LET l_oma.oma70 = g_oma.oma70                 #FUN-B40032 ADD
     LET l_oma.omauser=g_user
#    LET g_oma.omaoriu = g_user #FUN-980030        #FUN-B40032 MARK
#    LET g_oma.omaorig = g_grup #FUN-980030        #FUN-B40032 MARK
     LET g_oma.omaoriu = g_user                    #FUN-B40032 ADD
     LET g_oma.omaorig = g_grup                    #FUN-B40032 ADD
     LET l_oma.omadate=g_today
     LET l_oma.oma65 = '1'   #FUN-5A0124
     LET l_oma.oma66= g_oma.oma66  #FUN-630043
    #FUN-A60056--mod--str--
    #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
    #SELECT oga27 INTO l_oma.oma67 FROM oga_file
    #  WHERE oga01 = l_oma.oma16 
    #ELSE
    #   LET g_sql = "SELECT oga27 FROM ",l_dbs CLIPPED,"oga_file ",
    #               " WHERE oga01 = '",l_oma.oma16,"'"
    #   PREPARE sel_oga_pre33 FROM g_sql
    #   EXECUTE sel_oga_pre33
    #END IF
     LET g_sql = "SELECT oga27 FROM ",cl_get_target_table(l_oma.oma66,'oga_file'),
                 " WHERE oga01 = '",l_oma.oma16,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,l_oma.oma66) RETURNING g_sql
     PREPARE sel_oga_pre33 FROM g_sql
     EXECUTE sel_oga_pre33
    #FUN-A60056--mod--end
     IF g_aaz.aaz90='Y' THEN
        IF cl_null(l_oma.oma15) THEN
           LET l_oma.oma15=g_grup
        END IF
        LET l_oma.oma930=s_costcenter(l_oma.oma15)
     END IF
 
     LET l_oma.omalegal= g_legal #FUN-980011 add
     LET l_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
     LET l_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#No.FUN-AB0034 --begin
    IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
    IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
    IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
     INSERT INTO oma_file VALUES(l_oma.*)
     IF STATUS OR SQLCA.SQLCODE THEN
     IF g_bgerr THEN
        CALL s_errmsg('oma01',l_oma.oma01,'ins oma',SQLCA.SQLCODE,1)
     ELSE
        CALL cl_err3("ins","oma_file",l_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)
     END IF
       LET g_success = 'N' 
       RETURN
     END IF
     #TQC-C20430--add--str--
     IF g_oma.oma00 = '15' THEN   ##更新業務待抵單的財務單號
        LET g_sql = "UPDATE ",cl_get_target_table(g_oma.oma66,'luk_file')," SET luk16 = '",l_oma.oma01,"'",
                    " WHERE luk05 = (SELECT lui01 FROM ",cl_get_target_table(g_oma.oma66,'lui_file')," WHERE lui04 = '",g_oma.oma16,"')"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_oma.oma66) RETURNING g_sql
        PREPARE t300_upd_luk1 FROM g_sql
        EXECUTE t300_upd_luk1
     END IF 
     #TQC-C20430--add--end
     LET l_omc.omc01 = l_oma.oma01
     LET l_omc.omc02 = 1
     LET l_omc.omc03 = l_oma.oma32
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
     LET l_omc.omclegal= g_legal #FUN-980011 add
 
     INSERT INTO omc_file VALUES(l_omc.*)
     IF STATUS OR SQLCA.SQLCODE THEN
     IF g_bgerr THEN
        LET g_showmsg=l_omc.omc01,"/",l_omc.omc02
        CALL s_errmsg('omc01,omc02',g_showmsg,"ins omc",SQLCA.sqlcode,1) 
     ELSE
        CALL cl_err3("ins","omc_file",l_omc.omc01,"",SQLCA.sqlcode,"","ins omc",1)
     END IF
        LET g_success = 'N' 
        RETURN
     END IF
     UPDATE oma_file SET oma19=l_oma.oma01 WHERE oma01=g_oma.oma01
     IF STATUS OR SQLCA.SQLCODE THEN
     IF g_bgerr THEN
        CALL s_errmsg('oma01',g_oma.oma01,'upd oma19',SQLCA.SQLCODE,1)
     ELSE
        CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd oma19",1)
     END IF
       LET g_success = 'N' 
       RETURN
     END IF
     SELECT ool21,ool211 INTO g_ool.ool21,g_ool.ool211 FROM ool_file WHERE ool01 = g_oma.oma13
     UPDATE npq_file SET npq23 = l_oma.oma01 
      WHERE npq01 = g_oma.oma01
        AND (npq03 = g_ool.ool21 OR npq03 = g_ool.ool211)
        AND npq06 = '2'
     IF STATUS OR SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg('npq01',g_oma.oma01,'upd npq23',SQLCA.SQLCODE,1)
        ELSE
           CALL cl_err3("upd","npq_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd npq23",1)
        END IF
        LET g_success = 'N' 
        RETURN
     END IF
  END IF
END FUNCTION
 
FUNCTION s_yz_hu2(p_sw)                                 #更新預收款已沖帳金額
   DEFINE p_sw              LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)               # +:產生 -:刪除
   DEFINE order_no          LIKE oga_file.oga01          #No.FUN-680123 VARCHAR(16)                     #No.FUN-550071
   DEFINE l_oma             RECORD LIKE oma_file.*
   DEFINE tot1_13,tot2_13   LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6)  #FUN-4C0013
   DEFINE l_tot1,l_tot2     LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6)  #FUN-4C0013
   DEFINE u_tot1,u_tot2     LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6)  #FUN-4C0013
   DEFINE l_cnt             LIKE type_file.num5          #No.FUN-680123 SMALLINT   #No.FUN-680022
   DEFINE l_omc_tot1        LIKE type_file.num20_6       #No.FUN-680123 SMALLINT   #No.FUN-680022   #CHI-840048
   DEFINE l_omc_tot2        LIKE type_file.num20_6       #No.FUN-680123 SMALLINT   #No.FUN-680022   #CHI-840048
   DEFINE l_omc02           LIKE omc_file.omc02          #No.FUN-680022                                                                            
   DEFINE l_omc08           LIKE omc_file.omc08          #No.FUN-680022                                                                            
   DEFINE l_omc09           LIKE omc_file.omc09          #No.FUN-680022                                                                            
   DEFINE l_omc10           LIKE omc_file.omc10          #No.FUN-680022                                                                            
   DEFINE l_omc11           LIKE omc_file.omc11          #No.FUN-680022    
   DEFINE l_oma_sum         LIKE oma_file.oma57          #MOD-860185 add
 
  #No.FUN-9C0014 -BEGIN----- 
   DEFINE l_omb44           LIKE omb_file.omb44
   DEFINE l_omb31           LIKE omb_file.omb31
   DEFINE l_oga19           LIKE oga_file.oga19
   DEFINE l_dbs1            LIKE type_file.chr21
   DEFINE l_occ73           LIKE occ_file.occ73
#  DEFINE l_oma19           DYNAMIC ARRAY OF RECORD
#           oga19           LIKE oga_file.oga19
#                           END RECORD
   DEFINE l_i               LIKE type_file.num5
   DEFINE l_n               LIKE type_file.num5
   DEFINE l_oma50           LIKE oma_file.oma50
   DEFINE l_oma56           LIKE oma_file.oma56
   #-----No:FUN-A50103-----
   DEFINE l_oma54           LIKE oma_file.oma54
   DEFINE l_oma19           LIKE oma_file.oma19
   DEFINE l_oga16           LIKE oga_file.oga16
   DEFINE l_oma16           DYNAMIC ARRAY OF RECORD
            oga16           LIKE oga_file.oga16
                            END RECORD
  #DEFINE l_oea261          LIKE oea_file.oea261    #TQC-B60089 mod oea61 -> oea261 #MOD-C30078 mark
   DEFINE l_oea61           LIKE oea_file.oea61     #MOD-C30078 add
   DEFINE l_omb14tot        LIKE omb_file.omb14
   #-----No:FUN-A50103 END-----

   DECLARE conf_cs CURSOR FOR SELECT DISTINCT omb44,omb31 FROM omb_file
                               WHERE omb01 = g_oma.oma01

   LET l_i = 1
   LET l_n = 1

   SELECT azi04 INTO t_azi04    #TQC-B60089 
     FROM azi_file              #TQC-B60089
    WHERE azi01 = g_oma.oma23   #TQC-B60089

   FOREACH conf_cs INTO l_omb44,l_omb31
      IF NOT cl_null(l_omb44) THEN
         LET g_plant_new = l_omb44
      ELSE
         LET g_plant_new = g_plant
      END IF

      CALL s_gettrandbs()

      LET l_dbs1 = g_dbs_tra

     #LET g_sql = " SELECT oga19 FROM ",l_dbs1,"oga_file",
      #LET g_sql = " SELECT oga16 FROM ",l_dbs1,"oga_file",    #No:FUN-A50103
      LET g_sql = " SELECT oga16 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                  "  WHERE oga01 = '",l_omb31,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102	            
      PREPARE sel_oga_pre68 FROM g_sql
     #EXECUTE sel_oga_pre68 INTO l_oga19
      EXECUTE sel_oga_pre68 INTO l_oga16

     #IF l_oga19 IS NULL OR l_oga19 = ' ' THEN CONTINUE FOREACH END IF
      IF l_oga16 IS NULL OR l_oga16 = ' ' THEN CONTINUE FOREACH END IF    #No:FUN-A50103

      FOR l_i = 1 TO l_n-1
        #IF l_oma19[l_i].oga19 = l_oga19 THEN
         IF l_oma16[l_i].oga16 = l_oga16 THEN    #No:FUN-A50103
            CONTINUE FOREACH
         END IF
      END FOR

     #LET l_oma19[l_n].oga19 = l_oga19
      LET l_oma16[l_n].oga16 = l_oga16    #No:FUN-A50103

      LET l_n = l_n + 1

      #LET g_sql = "SELECT occ73 FROM ",l_dbs CLIPPED,"occ_file",
      LET g_sql = "SELECT occ73 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
                  " WHERE occ01 = '",g_oma.oma68,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
      PREPARE sel_occ_pre49 FROM g_sql
      EXECUTE sel_occ_pre49 INTO l_occ73
      IF cl_null(l_occ73) THEN LET l_occ73 = 'N' END IF

     #LET g_sql = " SELECT SUM(omb14),SUM(omb16)",
     #            "   FROM omb_file,",l_dbs1,"oga_file",
     #            "  WHERE omb01 = '",g_oma.oma01,"'",
     #            "    AND omb44 = '",l_omb44,"'",
     #            "    AND omb31 = oga01",
     #            "    AND oga19 = '",l_oga19,"'"
     #PREPARE sel_oga_pre69 FROM g_sql
     #EXECUTE sel_oga_pre69 INTO l_oma50,l_oma56
     #IF cl_null(l_oma50) THEN LET l_oma50 = 0 END IF
     #IF cl_null(l_oma56) THEN LET l_oma56 = 0 END IF
   #No.FUN-9C0014 -END-------
     #IF p_sw ='+' THEN
      #No.FUN-9C0014 -BEGIN-----
      #  SELECT SUM(oma52),SUM(oma53) INTO tot1,tot2 FROM oma_file
      #   WHERE oma19=g_oma.oma19 AND oma16 = g_oma.oma16
      #     AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N'

      #-----No:FUN-A50103-----
      SELECT SUM(omb14) INTO l_omb14tot FROM omb_file
       WHERE omb01 = g_oma.oma01
         AND omb31 = l_omb31

     #LET g_sql = " SELECT oea61 FROM ",l_dbs1,"oea_file",
     #LET g_sql = " SELECT oea261 FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102 #TQC-B60090 mod oea61 -> oea261 #MOD-C30078 mark
      LET g_sql = " SELECT oea61 FROM ",cl_get_target_table(g_plant_new,'oea_file'),  #MOD-C30078 add
                  "  WHERE oea01 = '",l_oga16,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
      PREPARE sel_oea_pre68 FROM g_sql
     #EXECUTE sel_oea_pre68 INTO l_oea261  #TQC-B60089 mod oea61 -> oea261 #MOD-C30078 mark
      EXECUTE sel_oea_pre68 INTO l_oea61   #MOD-C30078 add

      #LET g_sql = " SELECT oma19 FROM ",l_dbs1,"oma_file",
      LET g_sql = " SELECT oma19 FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
                  "  WHERE oma16 = '",l_oga16,"'",
                  "    AND oma00 = '11'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
      PREPARE sel_oma_pre19 FROM g_sql
      DECLARE sel_oma_19 CURSOR FOR sel_oma_pre19

      FOREACH sel_oma_19 INTO l_oma19
      #-----No:FUN-A50103 END-----
         IF p_sw ='+' THEN
            IF l_occ73 = 'Y' THEN
               SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2
                 FROM oob_file
                WHERE oob03 = '1'
                  AND oob04 = '3'
                  AND oob06 = g_oma.oma01
            ELSE
              ##-----No:FUN-A50103-----
              #LET g_sql = " SELECT SUM(omb14),SUM(omb16)",
              #            "   FROM oma_file,omb_file,",l_dbs1,"oga_file",
              #            "  WHERE oma01 = omb01",
              #           #"    AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N'",   #CHI-A50040 mark
              #            "    AND oma00='12'  AND omaconf='Y' AND omavoid='N'",                  #CHI-A50040
              #            "    AND omb44 = '",l_omb44,"'",
              #            "    AND omb31 = oga01",
              #            "    AND oga19 = '",l_oga19,"'"
              #PREPARE sel_oga_pre69 FROM g_sql
              #EXECUTE sel_oga_pre69 INTO l_oma50,l_oma56
              #IF cl_null(l_oma50) THEN LET l_oma50 = 0 END IF
              #IF cl_null(l_oma56) THEN LET l_oma56 = 0 END IF
              #LET tot1 = l_oma50 *g_oma.oma161/100
              #LET tot2 = l_oma56 *g_oma.oma161/100

               #LET g_sql = " SELECT oma54,oma56 FROM ",l_dbs1,"oma_file",
               LET g_sql = " SELECT oma54,oma56 FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
                           "  WHERE oma01 = '",l_oma19,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
               PREPARE sel_oma_pre69 FROM g_sql
               EXECUTE sel_oma_pre69 INTO l_oma54,l_oma56
               IF g_oma.oma52 <> l_oma54 THEN                   #MOD-C30078 add               
                  LET tot1= l_oma54 * l_omb14tot / l_oea61      #TQC-B60089 mark #MOD-C30078 remark
                  LET tot2= l_oma56 * l_omb14tot / l_oea61      #TQC-B60089 mark #MOD-C30078 remark
               ELSE                                             #MOD-C30078 add
                 #LET tot1= g_oma.oma52 * l_oma54 / l_oea261    #TQC-B60089      #TQC-BB0184 mark
                  LET tot1= g_oma.oma52                         #TQC-BB0184
                 #LET tot2= g_oma.oma53 * l_oma56 / l_oea261    #TQC-B60089 #MOD-B90260 mark 
                 #LET tot2= g_oma.oma52 * l_oma56 / l_oea261    #MOD-B90260 #TQC-BB0184 mark 
                  LET tot2= g_oma.oma53                         #TQC-BB0184 
                  CALL cl_digcut(tot1,t_azi04) RETURNING tot1   #TQC-B60089 
                  CALL cl_digcut(tot2,g_azi04) RETURNING tot2   #TQC-B60089 
               END IF                                           #MOD-C30078 add
              ##-----No:FUN-A50103 END-----
            END IF
         #No.FUN-9C0014 -END-------
   
            IF cl_null(tot1) THEN LET tot1 = 0 END IF
            IF cl_null(tot2) THEN LET tot2 = 0 END IF
   
            SELECT oma54t,oma55,oma56t,oma57
              INTO l_oma.oma54t,l_oma.oma55,l_oma.oma56t,l_oma.oma57
              FROM oma_file
         #   WHERE oma01 = g_oma.oma19 #No.FUN-9C0014
            #WHERE oma01 = l_oga19     #No.FUN-9C0014
             WHERE oma01 = l_oma19    #No:FUN-A50103
   
            IF cl_null(l_oma.oma54t) THEN LET l_oma.oma54t = 0 END IF
            IF cl_null(l_oma.oma55)  THEN LET l_oma.oma55  = 0 END IF
            IF cl_null(l_oma.oma56t) THEN LET l_oma.oma56t = 0 END IF
            IF cl_null(l_oma.oma57)  THEN LET l_oma.oma57  = 0 END IF
            IF l_oma.oma54t=l_oma.oma55+tot1 THEN
               LET tot2=l_oma.oma56t-l_oma.oma57
            END IF
         ELSE
         #No.FUN-9C0014 -BEGIN-----
         #  SELECT SUM(oma52),SUM(oma53) INTO tot1,tot2 FROM oma_file
         #   WHERE oma19=g_oma.oma19 AND oma16 = g_oma.oma16
         #     AND (oma00='12' OR oma00='13') AND omaconf!='Y' AND omavoid='N'
            IF l_occ73 = 'Y' THEN
               SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2
                 FROM oob_file
                WHERE oob03 = '1'
                  AND oob04 = '3'
                  AND oob06 = g_oma.oma01
            ELSE
              ##-----No:FUN-A50103-----
              #LET g_sql = " SELECT SUM(omb14),SUM(omb16)",
              #            "   FROM oma_file,omb_file,",l_dbs1,"oga_file",
              #            "  WHERE oma01 = omb01",
              #           #"    AND (oma00='12' OR oma00='13') AND omaconf!='Y' AND omavoid='N'",   #CHI-A50040 mark
              #            "    AND oma00='12' AND omaconf!='Y' AND omavoid='N'",                   #CHI-A50040
              #            "    AND omb44 = '",l_omb44,"'",
              #            "    AND omb31 = oga01",
              #            "    AND oga19 = '",l_oga19,"'"
              #PREPARE sel_oga_pre70 FROM g_sql
              #EXECUTE sel_oga_pre70 INTO l_oma50,l_oma56
              #IF cl_null(l_oma50) THEN LET l_oma50 = 0 END IF
              #IF cl_null(l_oma56) THEN LET l_oma56 = 0 END IF
              #LET tot1 = l_oma50 *g_oma.oma161/100
              #LET tot2 = l_oma56 *g_oma.oma161/100

               #LET g_sql = " SELECT oma54,oma56 FROM ",l_dbs1,"oma_file",
               LET g_sql = " SELECT oma54,oma56 FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
                           "  WHERE oma01 = '",l_oma19,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
               PREPARE sel_oma_pre70 FROM g_sql
               EXECUTE sel_oma_pre70 INTO l_oma54,l_oma56
              IF g_oma.oma52 <> l_oma54 THEN                   #MOD-C30078 add 
                #LET tot1= l_oma54 * l_omb14tot / l_oea61      #TQC-B60089 mark #MOD-C30078 remark
                #LET tot2= l_oma56 * l_omb14tot / l_oea61      #TQC-B60089 mark #MOD-C30078 remark
              ELSE                                             #MOD-C30078 add
                #LET tot1= g_oma.oma52 * l_oma54 / l_oea261    #TQC-B60089      #TQC-BB0184 mark
                 LET tot1= g_oma.oma52                         #TQC-BB0184
                #LET tot2= g_oma.oma53 * l_oma56 / l_oea261    #TQC-B60089 #MOD-B90260 mark 
                #LET tot2= g_oma.oma52 * l_oma56 / l_oea261    #MOD-B90260 #TQC-BB0184 mark 
                 LET tot2= g_oma.oma53                         #TQC-BB0184
                 CALL cl_digcut(tot1,t_azi04) RETURNING tot1   #TQC-B60089 
                 CALL cl_digcut(tot2,g_azi04) RETURNING tot2   #TQC-B60089 
               END IF                                          #MOD-C30078 add
              ##-----No:FUN-A50103 END-----
            END IF
         #No.FUN-9C0014 -END-------
            IF cl_null(tot1) THEN LET tot1 = 0 END IF
            IF cl_null(tot2) THEN LET tot2 = 0 END IF
    
            SELECT oma54t,oma55,oma56t,oma57
              INTO l_oma.oma54t,l_oma.oma55,l_oma.oma56t,l_oma.oma57
              FROM oma_file
         #   WHERE oma01 = g_oma.oma19 #No.FUN-9C0014
            #WHERE oma01 = l_oga19     #No.FUN-9C0014
             WHERE oma01 = l_oma19    #No:FUN-A50103
            IF cl_null(l_oma.oma54t) THEN LET l_oma.oma54t = 0 END IF
            IF cl_null(l_oma.oma55)  THEN LET l_oma.oma55  = 0 END IF
            IF cl_null(l_oma.oma56t) THEN LET l_oma.oma56t = 0 END IF
            IF cl_null(l_oma.oma57)  THEN LET l_oma.oma57  = 0 END IF
            SELECT SUM(oma53) INTO l_oma_sum
              FROM oma_file
         #   WHERE oma19=g_oma.oma19 AND oma01!=g_oma.oma01 #No.FUN-9C0014
            #WHERE oma19=l_oga19 AND oma01!=g_oma.oma01     #No.FUN-9C0014
             WHERE oma19=l_oma19 AND oma01!=g_oma.oma01    #No:FUN-A50103
              #AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N'   #CHI-A50040 mark
               AND oma00='12' AND omaconf='Y' AND omavoid='N'                  #CHI-A50040
            IF cl_null(l_oma_sum) THEN LET l_oma_sum = 0 END IF
            IF l_oma.oma54t=l_oma.oma55 THEN
               LET tot2=l_oma.oma57-l_oma_sum
            END IF
         END IF
   
         IF p_sw ='-' THEN
            LET tot1 = tot1 * -1
            LET tot2 = tot2 * -1
         END IF
   
        #CALL s_ar_oox03(g_oma.oma19) RETURNING g_net  #No.TQC-5C0086 #No.FUN-9C0014
        #CALL s_ar_oox03(l_oga19) RETURNING g_net      #No.FUN-9C0014
         CALL s_ar_oox03(l_oma19) RETURNING g_net    #No:FUN-A50103
   
         UPDATE oma_file SET oma55=oma55+tot1,    #MOD-860185
                             oma57=oma57+tot2,    #MOD-860185
                            #oma61=oma56t-tot2    #No.TQC-5B0175 更新本幣未衝金額     #MOD-A60199 mark
                             oma61=oma61-tot2     #No.TQC-5B0175 更新本幣未衝金額     #MOD-A60199
        # WHERE oma01 = g_oma.oma19  #No.FUN-9C0014
         #WHERE oma01 = l_oga19      #No.FUN-9C0014
          WHERE oma01 = l_oma19    #No:FUN-A50103
    
         IF STATUS THEN
            IF g_bgerr THEN
            #  CALL s_errmsg('oam01',g_oma.oma19,'upd oma55,57',STATUS,1) #No.FUN-9C0014
              #CALL s_errmsg('oam01',l_oga19,'upd oma55,57',STATUS,1)     #No.FUN-9C0014
               CALL s_errmsg('oam01',l_oma19,'upd oma55,57',STATUS,1)    #No:FUN-A50103
            ELSE
            # CALL cl_err3("upd","oma_file",g_oma.oma19,"",SQLCA.sqlcode,"","upd oma55,oma57",1) #No.FUN-9C0014
             #CALL cl_err3("upd","oma_file",l_oga19,"",SQLCA.sqlcode,"","upd oma55,oma57",1) #No.FUN-9C0014
              CALL cl_err3("upd","oma_file",l_oma19,"",SQLCA.sqlcode,"","upd oma55,oma57",1)    #No:FUN-A50103
            END IF
            LET g_success = 'N' 
            RETURN
         END IF
   
         IF STATUS=100 THEN
            IF g_bgerr THEN
              #CALL s_errmsg('','','upd oma55,57','axr-134',1)            #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',l_oma19,'upd oma55,57','axr-134',1)  #No.FUN-D40089   Add
            ELSE
               CALL cl_err('upd oma55,57','axr-134',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
   
         IF p_sw = '+' THEN   #CHI-840048
            DECLARE s_yz_h2_c CURSOR FOR                                                                                         
              SELECT omc02,omc08,omc09,omc10,omc11 FROM omc_file                                                                               
         #     WHERE omc01 =g_oma.oma19 ORDER BY omc02 #No.FUN-9C0014
              #WHERE omc01 = l_oga19 ORDER BY omc02    #No.FUN-9C0014
               WHERE omc01 = l_oma19 ORDER BY omc02    #No:FUN-A50103
                                                                                                                                   
            SELECT count(*) INTO l_cnt FROM omc_file   #CHI-840048
         #   WHERE omc01 = g_oma.oma19                 #No.FUN-9C0014
            #WHERE omc01 = l_oga19                     #No.FUN-9C0014
             WHERE omc01 = l_oma19    #No:FUN-A50103
            IF l_cnt >0 THEN     
               LET l_omc_tot1 = tot1                                                                                              
               LET l_omc_tot2 = tot2                                                                                           
               FOREACH s_yz_h2_c INTO l_omc02,l_omc08,l_omc09,l_omc10,l_omc11                                                                    
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
                   UPDATE omc_file set omc10 = l_omc10,                                                                             
                                       omc11 = l_omc11,
                                       omc13 = omc09 - l_omc11                                                                              
                  # WHERE omc01 = g_oma.oma19  #No.FUN-9C0014
                   #WHERE omc01 = l_oga19      #No.FUN-9C0014
                    WHERE omc01 = l_oma19    #No:FUN-A50103
                      AND omc02 = l_omc02                                                                                          
                   IF STATUS THEN
                   IF g_bgerr THEN
                     #CALL s_errmsg('','',"upd omc10,omc11,omc13",SQLCA.sqlcode,1)             #No.FUN-D40089   Mark
                      CALL s_errmsg('oma01',l_oma19,"upd omc10,omc11,omc13",SQLCA.sqlcode,1)   #No.FUN-D40089   Add
                   ELSE
                     #CALL cl_err3("upd","omc_file",l_oga19,"",SQLCA.sqlcode,"","upd omc10,omc11,omc13",1)
                      CALL cl_err3("upd","omc_file",l_oma19,"",SQLCA.sqlcode,"","upd omc10,omc11,omc13",1)    #No:FUN-A50103
                   END IF
                      LET g_success = 'N' 
                      RETURN
                   END IF
                   IF l_omc_tot2 =0 OR l_omc_tot1 = 0 THEN                                                                               
                      EXIT FOREACH                                                                                                 
                   END IF                                                                                                          
               END FOREACH                                                                                                         
            END IF                                                                                                                 
        ELSE
            UPDATE omc_file set omc10 = omc10 + tot1,     #MOD-A60199 0 -> omc10 + tot1                                                                             
                                omc11 = omc11 + tot2,     #MOD-A60199 0 -> omc10 + tot2
                                omc13 = omc13 - tot2      #MOD-A60199 omc08 -> omc13 - tot2                                                                              
           # WHERE omc01 = g_oma.oma19  #No.FUN-9C0014
            #WHERE omc01 = l_oga19      #No.FUN-9C0014
             WHERE omc01 = l_oma19    #No:FUN-A50103
            IF STATUS THEN
               IF g_bgerr THEN
                 #CALL s_errmsg('','',"upd omc10,omc11,omc13",SQLCA.sqlcode,1)        #No.FUN-D40089   Mark
                  CALL s_errmsg('oma01',l_oma19,"upd omc10,omc11,omc13",SQLCA.sqlcode,1)   #No.FUN-D40089   Add
               ELSE
                 #CALL cl_err3("upd","omc_file",l_oga19,"",SQLCA.sqlcode,"","upd omc10,omc11,omc13",1)
                  CALL cl_err3("upd","omc_file",l_oma19,"",SQLCA.sqlcode,"","upd omc10,omc11,omc13",1)    #No:FUN-A50103
               END IF
               LET g_success = 'N' 
               RETURN
            END IF
        END IF   
      END FOREACH    #No:FUN-A50103
   END FOREACH  #No.FUN-9C0014 Add
END FUNCTION

FUNCTION abs(p_cmd)                                                                                                                 
  DEFINE p_cmd LIKE omb_file.omb14                                                                                                  
     IF p_cmd >= 0 THEN                                                                                                              
        RETURN p_cmd                                                                                                                
     ELSE                                                                                                                           
        RETURN p_cmd * (-1)                                                                                                         
     END IF                                                                                                                         
END FUNCTION                                                                                                                        
#No.FUN-9C0072 精簡程式碼
