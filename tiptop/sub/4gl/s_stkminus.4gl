# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_stkminus.4gl
# Descriptions...: 庫存單據不同期, 要check 庫存是否為負
# Date & Author..: 05/5/20 by kim
# Memo...........: 凡系統所有出庫程式, 於過帳時應check, 如果單據日期<>現行年月
#                  (sma51/sma52),  則應重新推出該單據日期當日該[料倉儲批]庫存
#                  是否足夠, 不足應予訊息提示, 並依參數(sma894)決定庫存為負是
#                  否允許過帳, 建議寫成 sub function.
#
#                  [當日庫存的推法]:
#                  取單據日期該年月, 找出該[料倉儲批]之 imk_file 的[上期期末數
#                  量 imk09] 再累加(或減)單據日期所屬該月月初直至單據日期當日
#                  之所有 tlf_file 資料, 即可得出當日庫存.
#                  (參考寫法: aimr650.4gl)
#
#                  l_imk01(料件編號),l_imk02(倉庫編號),l_imk03(儲位編號),
#                  l_imk04(批號),l_outqty(出庫數量),l_factor(該出庫單位與庫存單位的單位轉換率),
#                  l_date(單據日期),l_sma894(負庫存是否允許過帳)
#
# Return Code....: TRUE --> check pass !
# Modify.........: No.FUN-560082 05/06/17 By kim 推日期的部分改成推那個月的最後一天
# Modify.........: No.FUN-560120 05/06/19 By kim 計算當月庫存,不可直接取imk的值,要從tlf_file撈當月1日到當月最後一天的累計異動量
# Modify.........: No.FUN-610070 06/02/19 By alex 加入錯誤訊息處理方式
# Modify.........: No.TQC-620156 06/03/06 By kim 修正FUN-610070的錯誤
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.MOD-680095 06/11/15 By pengu 加WHENEVER ERROR CALL cl_err_msg_log 的處理
# Modify.........: No.MOD-6C0039 06/12/07 By wujie 遇到MISC料號不計算庫存                                                           
# Modify.........: No.FUN-6C0083 06/12/03 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-7C0014 07/12/05 By xufeng 在庫存扣帳時,在檢查IMK時,自然年月推算會計年月有誤
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-810018 08/01/07 By lumxa l_tlfqty和l_totqty兩個變量定義 時候定義成了 l_tlfqty LIKE tlf_file.tlf12, l_totqty LIKE tlf_file.tlf12, 導致了有尾差的 問題
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
# Modify.........: No:FUN-C80107 12/09/17 By suncx 新增可按倉庫進行負庫存判斷
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:TQC-D30054 13/03/21 By lixh1 FUN-D30024所做的修改在正式區被還原,故重新過單
# Modify.........: No:TQC-D40078 13/04/27 By fengrui 負庫存函数添加营运中心参数
                                                                                                                                    
DATABASE ds         #FUN-850069  MOD-6C0039
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_stkminus(l_imk01,l_imk02,l_imk03,l_imk04,l_outqty,l_factor,l_date,l_sma894) #FUN-D30024 mark
FUNCTION s_stkminus(l_imk01,l_imk02,l_imk03,l_imk04,l_outqty,l_factor,l_date)           #FUN-D30024 add   #TQC-D30054
   DEFINE l_imk01         LIKE imk_file.imk01
   DEFINE l_imk02         LIKE imk_file.imk02
   DEFINE l_imk03         LIKE imk_file.imk03
   DEFINE l_imk04         LIKE imk_file.imk04
   DEFINE l_imk05         LIKE imk_file.imk05
   DEFINE l_imk06         LIKE imk_file.imk06
   DEFINE l_date          LIKE type_file.dat    	#No.FUN-680147 DATE
  #DEFINE l_sma894        LIKE type_file.chr1      	#No.FUN-680147 VARCHAR(1)  #FUN-D30024 mark
   DEFINE l_sql,l_tmp     STRING,
          l_imk09         LIKE imk_file.imk09,
#         l_tlfqty        LIKE tlf_file.tlf12,  #TQC-810018
#         l_totqty        LIKE tlf_file.tlf12,  #TQC-810018
#         l_outqty        LIKE tlf_file.tlf12,  #TQC-810018
          l_tlfqty        LIKE tlf_file.tlf10,  #TQC-810018
          l_totqty        LIKE tlf_file.tlf10,  #TQC-810018
          l_outqty        LIKE tlf_file.tlf10,  #TQC-810018
          l_sdate,l_edate LIKE type_file.dat,    	#No.FUN-680147 DATE
          l_flag          LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
          l_factor        LIKE ima_file.ima31_fac       #No.FUN-680147 DECIMAL(16,8)
   DEFINE l_flag1         LIKE type_file.chr1      #FUN-C80107 add
       
  #IF l_sma894='Y' THEN  #FUN-C80107 mark
  #CALL s_inv_shrt_by_warehouse(l_sma894,l_imk02) RETURNING l_flag1  #FUN-C80107 add #FUN-D30024 mark
   CALL s_inv_shrt_by_warehouse(l_imk02,g_plant) RETURNING l_flag1   #FUN-D30024 add #TQC-D40078 g_plant
   IF l_flag1 = 'Y' THEN  #FUN-C80107 add
      RETURN TRUE
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log    #No.MOD-680095 add
   #No.TQC-7C0014  --begin--
   #LET l_imk05=YEAR(l_date)
   #LET l_imk06=MONTH(l_date)
   #No.TQC-7C0014  --end----
 
   #No.TQC-7C0014  --begin-----
   SELECT azn02,azn04 INTO l_imk05,l_imk06
     FROM azn_file
    WHERE azn01=l_date
   #No.TQC-7C0014  --end-------
   
   IF (l_imk05*12+l_imk06)=(g_sma.sma51*12+g_sma.sma52) THEN
      RETURN TRUE
   END IF
#No.MOD-6C0039--begin                                                                                                               
   IF l_imk01 MATCHES 'MISC*' THEN                                                                                                          
      RETURN TRUE                                                                                                                   
   END IF                                                                                                                           
#No.MOD-6C0039--end 
  ##FUN-560082................begin
  #SELECT imk09 INTO l_totqty FROM imk_file WHERE imk01=l_imk01
  #  AND imk02=l_imk02 AND imk03=l_imk03 AND imk04=l_imk04
  #  AND imk05=l_imk05 AND imk06=l_imk06
  #IF cl_null(l_totqty) OR SQLCA.sqlcode THEN 
  #   LET l_totqty=0 
  #END IF
  ##FUN-560082................end
 
  #LET l_tmp=l_imk05,'/',l_imk06,'/','01'
  #LET l_sdate=DATE(l_tmp)
   CALL s_azn01(l_imk05,l_imk06) RETURNING l_sdate,l_edate #FUN-560120
 
   LET l_imk06=l_imk06-1
   IF l_imk06=0 THEN
     LET l_imk06=12
     LET l_imk05=l_imk05-1   
   END IF 
 
   SELECT imk09 INTO l_imk09 FROM imk_file WHERE imk01=l_imk01
     AND imk02=l_imk02 AND imk03=l_imk03 AND imk04=l_imk04
     AND imk05=l_imk05 AND imk06=l_imk06
   IF l_imk09 IS NULL OR SQLCA.sqlcode THEN 
      LET l_imk09=0 
   END IF
 
   SELECT SUM(tlf10*tlf12*tlf907) INTO l_tlfqty FROM tlf_file WHERE tlf01=l_imk01
     AND ((l_imk02=tlf021 AND l_imk03=tlf022 AND l_imk04=tlf023 AND tlf907=-1) OR
          (l_imk02=tlf031 AND l_imk03=tlf032 AND l_imk04=tlf033 AND tlf907=1))
     AND tlf06 BETWEEN l_sdate AND l_edate    
   IF l_tlfqty IS NULL OR SQLCA.sqlcode THEN LET l_tlfqty=0 END IF
   LET l_totqty=l_imk09+l_tlfqty
 
  
#  SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_imk01
#  
#  IF l_ima25<>l_unit THEN
#     CALL s_umfchk(l_imk01,l_unit,l_ima25)
#          RETURNING l_flag,l_factor
#     IF l_flag=1 THEN
#        CALL cl_err(l_imk01,'mfg3075',1)
#        RETURN FALSE
#     ELSE
#        LET l_outqty=l_outqty*l_factor
#     END IF
#  END IF
 
   LET l_outqty=l_outqty*l_factor
 
   IF l_totqty < l_outqty THEN #kim test mark
      LET l_tmp='(s_stkminus : ',l_imk01,') '
      IF g_bgerr THEN              #No.FUN-6C0083
         CALL s_errmsg('imk01',l_imk01,l_tmp,'aim-407',1)   #No.FUN-6C0083
      ELSE
         CALL cl_err(l_tmp,'aim-407',1)
      END IF
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
