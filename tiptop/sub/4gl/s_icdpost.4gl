# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: s_icdpost.4gl   
# Descriptions...: 
# Return code....: 1：成功，0:失敗
# Date & Author..: NO.FUN-7B0075 07/12/13 By Sunyanchun
# Modify.........: No.MOD-890023 08/09/02 By chenyu icd版功能修改
# Modify.........: No.MOD-8B0212 08/11/24 By chenyu sql語句對應的欄位錯誤
# Modify.........: No.FUN-930106 09/03/30 By dongbg 漏過單
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:MOD-9A0043 09/11/06 By Pengu 狀態選3.未測IC 或 4.已測IC時，不應該強制做刻號/BIN管理
# Modify.........: No:FUN-AA0007 10/10/14 By jan 批號hold,在庫存未入庫之前先做hols的動作
# Modify.........: No:FUN-A50030 10/12/09 By Lilan EF簽核時不可彈出警示窗 
# Modify.........: No:FUN-AB0092 11/02/12 By jan Feature Hold Lot指定(aici022) 時，希望可以再指定到要鎖定的料件狀態
# Modify.........: No:MOD-B30497 11/03/18 By jan 增加錯誤提示信息
# Modify.........: No:MOD-B40129 11/04/18 By Summer MISC料不需要有idc_file/idd_file的資料,故在s_icdpost的一開頭就判斷,若是MISC料則RETURN
# Modify.........: No:FUN-B30187 11/06/22 By jason 增加ICD母子批號關聯檔
# Modify.........: No:TQC-B80005 11/08/03 By jason 母批由g_idb04修正為g_idb14
# Modify.........: No:FUN-B70032 11/08/16 By jason 新增icd_ins_ida、icd_ins_idb function
# Modify.........: No:CHI-B90001 11/09/02 By jason 修正SQL語法錯誤,少一空格 
# Modify.........: No:FUN-B30183 11/09/09 By jason 修正提示訊息
# Modify.........: No:FUN-B80119 11/09/13 By fengrui ICD庫存過帳程式(所有sub皆改為跨DB處理),修改icd_ida與icd_idb兩個函數
# Modify.........: No:FUN-B90012 11/09/21 By fengrui 多角的處理
# Modify.........: No.TQC-BA0136 11/11/01 By jason 存檔前判斷DIE數若為null給0
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No:FUN-B40081 11/11/14 By jason 新增icd_idb_del_multi,icd_idd_del_multi(多倉儲出貨用)
# Modify.........: No.CHI-BB0051 11/11/23 By kim 未測和以測 IC,若走刻號/BIN不應該給一個空格
# Modify.........: No.FUN-BC0036 11/12/22 By jason 新增idb26,idb27,idd33,idd34(刻號/BIN調整用)
# Modify.........: No.TQC-C20088 12/02/08 By jason 修正刻號/BIN調整單判斷idb26,idb27
# Modify.........: No.MOD-C30527 12/03/12 By bart 若idb02為NULL時,改秀apm1033
# Modify.........: No.TQC-C40050 12/04/10 By bart 判斷是否扣idc21
# Modify.........: No.FUN-C30274 12/04/11 By jason 新增function
# Modify.........: No.FUN-C30289 12/04/20 By bart 多批出貨時ida_file的刪除方法
# Modify.........: No.FUN-C30286 12/04/26 By bart 參數錯誤
# Modify.........: No.TQC-C50062 12/05/08 By Sarah 當不良BIN的片數是寫在ida11時,應將ida11寫入idc08
# Modify.........: No.FUN-C50102 12/05/24 By bart aic-323的檢查,應該只有當l_imaicd04 = '2'時才做
# Modify.........: No.FUN-C50120 12/05/25 By bart 當刪除發料單時,會詢問要不要一併刪除刻號/BIN資料,若選是,則會更新idc21(將備置量扣掉),但應該要再依工單的idb_file資料更新idc21
# Modify.........: No.FUN-C50115 12/05/28 By Sarah 當刪除出貨單時,若該出貨單是從出通單產生過來的,需依出通單的刻號/BIN資料再做備置
# Modify.........: No.TQC-C60025 12/06/12 By Sarah 修正FUN-C50120,更新idc21錯誤
# Modify.........: No.TQC-C60014 12/06/13 By bart 過帳還原時須還原datecode
# Modify.........: No.CHI-C80009 12/08/06 By Sakura ICD多角拋轉問題處理:insert idd_file相關欄位給予預設值
# Modify.........: No.MOD-CA0120 12/10/23 By Vampire FUNCTION icd_set_idb抓idc07單位轉換的地方請參考FUNCTION icd_set_ida改抓ima25
# Modify.........: No.MOD-D40074 13/04/11 By Elise 判斷料號是否使用刻號/BIN,Date否才能刪除

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_idb        RECORD LIKE idb_file.* 
DEFINE   g_ida        RECORD LIKE ida_file.*
DEFINE   g_idc2       RECORD LIKE idc_file.* 
DEFINE   g_idc        RECORD LIKE idc_file.*
DEFINE   g_idd        RECORD LIKE idd_file.*
DEFINE   g_sql         STRING
DEFINE   g_in_out      LIKE type_file.num5,   #出入庫標志
         g_idb01       LIKE idb_file.idb01,   #料件編號
         g_idb02       LIKE idb_file.idb02,   #倉庫
         g_idb03       LIKE idb_file.idb03,   #儲位
         g_idb04       LIKE idb_file.idb04,   #批號
         g_idb12       LIKE idb_file.idb12,   #單位
         g_idb11       LIKE idb_file.idb11,   #數量
         g_idb07       LIKE idb_file.idb07,   #單據編號
         g_idb08       LIKE idb_file.idb08,   #單據項次
         g_idb09       LIKE idb_file.idb09,   #單據日期
         g_idb14       LIKE idb_file.idb14,   #母批       #FUN-B40187
         g_idb15       LIKE idb_file.idb15,   #Datecode  #FUN-B40187
         g_yn          LIKE type_file.chr1
DEFINE   g_no          LIKE idb_file.idb07,   #來源單據
         g_item        LIKE idb_file.idb08,   #來源單據項次
         g_idd15    LIKE idd_file.idd15,      #母體料號
         g_idd16    LIKE idd_file.idd16       #母批
DEFINE   g_idd17    LIKE idd_file.idd17,     #DATECODE
         g_idd19    LIKE idd_file.idd19,     #YIELD
         g_idd23    LIKE idd_file.idd23      #接單料號
DEFINE   g_idb11_sum    LIKE idb_file.idb11
DEFINE   g_idc08_sum    LIKE idc_file.idc08
DEFINE   g_idc21_sum    LIKE idc_file.idc21
DEFINE   g_imaicd08     LIKE imaicd_file.imaicd08  #FUN-AA0007
DEFINE   g_imaicd01     LIKE imaicd_file.imaicd01  #FUN-AA0007
DEFINE   g_mflag        LIKE type_file.chr1  #FUN-B90012

#當 p_in_out=11/12/13 時，則表示為多角拋磚調用。 數值對應 11(1) 12(-1) 13(0)   #FUN-B90012--add-- 
FUNCTION s_icdpost(p_in_out,p_idb01,p_idb02,p_idb03,
                    p_idb04,p_idb12,p_idb11,p_idb07,
                    p_idb08,p_idb09,p_yn,p_no,p_item
#                    ,p_idb14,p_idb15) #FUN-B30187 #No.FUN-B80119--mark--
                    ,p_idb14,p_idb15,p_plant)      #No.FUN-B80119--add---
                    
   DEFINE p_in_out      LIKE type_file.num5, #出入庫
          p_idb01       LIKE idb_file.idb01, #料件編號
          p_idb02       LIKE idb_file.idb02, #倉庫別
          p_idb03       LIKE idb_file.idb03, #儲位
          p_idb04       LIKE idb_file.idb04, #批號
          p_idb12       LIKE idb_file.idb12, #單位
          p_idb11       LIKE idb_file.idb11, #出貨數量
          p_idb07       LIKE idb_file.idb07, #單據編號
          p_idb08       LIKE idb_file.idb08, #單據項次
          p_idb09       LIKE idb_file.idb09, #單據日期
          p_idb14       LIKE idb_file.idb14, #母批       FUN-B30187
          p_idb15       LIKE idb_file.idb15, #Datecode  FUN-B30187
          p_yn          LIKE type_file.chr1  #過帳否
   DEFINE p_no          LIKE idb_file.idb07, #來源單據
          p_item        LIKE idb_file.idb08, #來源單據項次
          p_plant       LIKE type_file.chr20 #No.FUN-B80119--add--
          
 
   DEFINE l_out        LIKE type_file.num20_6
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_imaicd08   LIKE imaicd_file.imaicd08  #是否做刻號管理
   DEFINE l_imaicd04   LIKE imaicd_file.imaicd04  #料件狀態
   
 
   #FUN-930106
   #FUN-930106
   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #FUN-B80119--add--    
   WHENEVER ERROR CALL cl_err_msg_log
   LET g_plant_new = p_plant  #FUN-B80119--add--
   #BEGIN---NO.FUN-7B0075
   LET g_in_out = p_in_out
   LET g_idb01 = p_idb01
   LET g_idb02 = p_idb02
   LET g_idb03 = p_idb03
   LET g_idb04 = p_idb04
   LET g_idb12 = p_idb12
   LET g_idb11 = p_idb11
   LET g_idb07 = p_idb07
   LET g_idb08 = p_idb08
   LET g_idb09 = p_idb09
   LET g_idb14 = p_idb14   #FUN-B30187 
   LET g_idb15 = p_idb15   #FUN-B30187
   LET g_yn = p_yn
   #END---NO.FUN-7B0075
   IF g_success = 'N' THEN RETURN 0 END IF
   IF g_idb01[1,4] = 'MISC' THEN RETURN 1 END IF #MOD-B40129 add
   #若料件IC(imaicd04=3,4)或imaicd08='Y'才可往下進行  #FUN-AA0007 imaicd08='N'可往下進行
   LET l_imaicd04 = NULL
   LET l_imaicd08 = NULL

   #No.FUN-B80119--start--mark---
   #SELECT imaicd04,imaicd08,imaicd01 INTO l_imaicd04,l_imaicd08,g_imaicd01 FROM imaicd_file  #FUN-AA0007
   #   WHERE imaicd00 = g_idb01
   #No.FUN-B80119---end---mark---

   #No.FUN-B80119--start--add---
   LET g_sql = "SELECT imaicd04,imaicd08,imaicd01 FROM ",cl_get_target_table(g_plant_new,'imaicd_file'),
               " WHERE imaicd00 = '", g_idb01 ,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_post_pre FROM g_sql
   DECLARE icd_post_cs CURSOR FOR icd_post_pre
   OPEN icd_post_cs
   FETCH icd_post_cs INTO l_imaicd04,l_imaicd08,g_imaicd01  
   #No.FUN-B80119---end---add---
   
   IF SQLCA.SQLCODE THEN
     #CALL cl_err('sel imaicd08',SQLCA.SQLCODE,1)                                       #FUN-A50030 mark
      CALL cl_err3("sel","ima_file",g_idb01,"",SQLCA.sqlcode,"","sel imaicd08 fail:",0) #FUN-A50030 add
      LET g_success = 'N'
      RETURN 0
   ELSE
      IF cl_null(l_imaicd04) THEN
         LET g_success = 'N'
         CALL cl_err('','sub-178',1)   #MOD-B30497
         RETURN 0
      END IF
      IF cl_null(l_imaicd08) THEN
         LET g_success = 'N'
         CALL cl_err('','aic-914',1)   #MOD-B30497
         RETURN 0
      END IF
     #--------------No:MOD-9A0043 modify
     #IF NOT(l_imaicd08 = 'Y' OR l_imaicd04 MATCHES '[34]') THEN
     #IF NOT(l_imaicd08 = 'Y') THEN  #FUN-AA0007
     #--------------No:MOD-9A0043 end
     #   RETURN 1                    #FUN-AA0007
     #END IF                         #FUN-AA0007
   END IF
   LET g_imaicd08=l_imaicd08  #FUN-AA0007
   #傳入的資料不可為空
   #MOD-C30527---begin
   IF cl_null(g_idb02) THEN 
      CALL cl_err('','apm1033',0)
   END IF 
   #MOD-C30527---end
   IF cl_null(g_in_out) OR cl_null(g_idb01) OR
      #cl_null(g_idb02) OR cl_null(g_idb12) OR   #MOD-C30527  mark
      cl_null(g_idb12) OR                        #MOD-C30527
      cl_null(g_idb11) OR cl_null(g_idb07) OR 
      cl_null(g_idb08) OR cl_null(g_idb09) OR 
      cl_null(g_yn) THEN 
      #CALL cl_err('s_icdpost()','aic-908',0)   #MOD-C30527
      CALL cl_err('','aic-908',0)               #MOD-C30527
      RETURN 0
   END IF
   IF cl_null(g_idb03) THEN LET g_idb03 = ' ' END IF  #儲位
   IF cl_null(g_idb04) THEN LET g_idb04 = ' ' END IF  #批號
   #檢查傳入參數的合理性 異動別p_in_out=0/1/-1/2
   IF NOT (p_in_out = 0 OR p_in_out = 1 OR p_in_out = -1 OR p_in_out = 2 OR p_in_out = 11 OR p_in_out = 12 OR p_in_out = 13 ) THEN #FUN-B90012
      CALL cl_err('p_in_out <> 0/1/-1/2/11/12/13','!',1)  #FUN-B90012
      RETURN 0
   END IF
   #檢查來源單據和來源項次是否有值
   IF NOT cl_null(p_no) OR NOT cl_null(p_item) THEN
      IF cl_null(p_no) THEN
         #CALL cl_err('p_no','aic-908',1)   #MOD-C30527
         CALL cl_err(p_no,'aic-908',1)      #MOD-C30527
         RETURN 0
      END IF
      IF cl_null(p_item) THEN
         #CALL cl_err('p_item','aic-908',1)  #MOD-C30527
         CALL cl_err(p_item,'aic-908',1)     #MOD-C30527
         RETURN 0
      END IF
      LET g_no = p_no
      LET g_item = p_item
   END IF

   #FUB-B90012
   LET g_mflag='N' #多角否
   CASE g_in_out
      WHEN '11'
        LET g_in_out = '1'  LET g_mflag='Y'
      WHEN '12'
        LET g_in_out = '-1' LET g_mflag='Y'
      WHEN '13'
        LET g_in_out = '0'  LET g_mflag='Y'
   END CASE
   #FUB-B90012

  #CHI-BB0051 mark(S)   
  #CASE g_in_out
  #     WHEN '-1'
  #         IF l_imaicd04 MATCHES '[34]' THEN LET g_in_out = '5' END IF
  #     WHEN '0'
  #         IF l_imaicd04 MATCHES '[34]' THEN LET g_in_out = '7' END IF
  #     WHEN '1'
  #         IF l_imaicd04 MATCHES '[34]' THEN LET g_in_out = '6' END IF
  #     WHEN '2'
  #         IF l_imaicd04 MATCHES '[34]' THEN LET g_in_out = '8' END IF
  #END CASE
  #CHI-BB0051 mark(E)
   #判斷當前單據是否完工入庫
   LET l_n = 0
   #No.FUN-B80119--start--mark---
   #SELECT COUNT(*) INTO l_n
   #   FROM sfu_file,sfv_file       #完工入庫單
   #   WHERE sfu01 = g_idb07        #單據編號
   #    AND sfv03 = g_idb08         #單據項次
   #    AND sfu01 = sfv01
   #No.FUN-B80119---end---mark---
   #No.FUN-B80119--start--add---
   LET g_sql = "SELECT COUNT(*) FROM ",
               cl_get_target_table(g_plant_new,'sfu_file'),",",
               cl_get_target_table(g_plant_new,'sfv_file'),
               " WHERE sfu01 = '",g_idb07,"' ",
               "   AND sfv03 = '",g_idb08,"' ",
               "   AND sfu01 = sfv01 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_post_ln_pre FROM g_sql
   EXECUTE icd_post_ln_pre INTO l_n
   #No.FUN-B80119---end---add---
 
   #IF l_imaicd04 = '4' AND l_imaicd08 = 'Y' AND l_n = 0 THEN #FUN-AA0007
   #CHI-BB0051 mark (S)
   #IF l_imaicd04 = '4' AND l_n = 0 THEN      #FUN-AA00007
   #   IF g_in_out = '5' THEN
   #      LET g_in_out = '-1'
   #   END IF 
   #   IF g_in_out = '6' THEN
   #      LET g_in_out = '1'
   #   END IF
   #   IF g_in_out = '7' THEN
   #      LET g_in_out = '0'
   #   END IF
   #   IF g_in_out = '8' THEN
   #      LET g_in_out = '2'
   #   END IF
   #END IF
   #CHI-BB0051 mark (E)
 
   #FUN-AA0007--begin--add------
   IF g_in_out = '-1' OR g_in_out = '2' OR g_in_out = '5' OR g_in_out = '8' THEN
      IF NOT s_icdout_holdlot(g_idb01,g_idb02,g_idb03,g_idb04) THEN RETURN 0 END IF
   END IF
   #FUN-AA0007--end--add--------
   
   IF g_yn = 'Y' THEN  #過帳
      CASE g_in_out
         WHEN 1   #WAFER入庫
              CALL icd_post1(p_plant)   #No.FUN-B80119--增加p_plant參數--    
         WHEN -1  #WAFER出庫
              CALL icd_post2(p_plant)   #No.FUN-B80119--增加p_plant參數--
         WHEN 0   #WAFER收貨
              CALL icd_post1(p_plant)   #No.FUN-B80119--增加p_plant參數--
         WHEN 2   #WAFER出通
              CALL icd_post2(p_plant)   #No.FUN-B80119--增加p_plant參數--
         #CHI-BB0051 mark (S)
         #WHEN 5   #IC出庫
         #     CALL icd_post5(p_plant)   #No.FUN-B80119--增加p_plant參數--    
         #WHEN 6   #IC入庫
         #     CALL icd_post6(p_plant)   #No.FUN-B80119--增加p_plant參數--
         #WHEN 7   #IC收貨
         #     CALL icd_post6(p_plant)   #No.FUN-B80119--增加p_plant參數--
         #WHEN 8   #IC出通
         #     CALL icd_post5(p_plant)   #No.FUN-B80119--增加p_plant參數--
         #CHI-BB0051 mark (E) 
         OTHERWISE EXIT CASE
      END CASE 
   END IF
 
   IF g_yn = 'N' THEN  #過帳還原
      CASE g_in_out                                                             
         WHEN 1   #入庫
              CALL icd_unpost1(p_plant)   #No.FUN-B80119--增加p_plant參數--    
         WHEN -1  #出庫
              CALL icd_unpost2(p_plant)   #No.FUN-B80119--增加p_plant參數--    
         WHEN 0   #其他入
              CALL icd_unpost1(p_plant)   #No.FUN-B80119--增加p_plant參數--    
         WHEN 2   #其他出
              CALL icd_unpost2(p_plant)   #No.FUN-B80119--增加p_plant參數--
         #CHI-BB0051 mark (S)
         #WHEN 5   #IC出庫
         #     CALL icd_unpost5(p_plant)   #No.FUN-B80119--增加p_plant參數--    
         #WHEN 6   #IC入庫
         #     CALL icd_unpost6(p_plant)   #No.FUN-B80119--增加p_plant參數--
         #WHEN 7   #IC收貨
         #     CALL icd_unpost6(p_plant)   #No.FUN-B80119--增加p_plant參數--
         #WHEN 8   #IC出通
         #     CALL icd_unpost5(p_plant)   #No.FUN-B80119--增加p_plant參數--
         #CHI-BB0051 mark (E)
         OTHERWISE EXIT CASE                                                    
      END CASE     
   END IF
 
   IF g_success = 'Y' THEN
      RETURN 1
   ELSE 
      RETURN 0
   END IF
END FUNCTION
 
#過帳：入庫(1)，收貨(0)
FUNCTION icd_post1(p_plant)                 #No.FUN-B80119--增加p_plant參數--
   DEFINE l_flag  LIKE type_file.chr1
   DEFINE l_fac   LIKE type_file.num20_6
   DEFINE l_msg   LIKE type_file.chr1000
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE p_plant LIKE type_file.chr20                  #No.FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant                            #No.FUN-B80119--add---
   #IF g_imaicd08='Y' THEN                #FUN-AA0007 #FUN-BA0051 mark
   IF s_icdbin(g_idb01) THEN   #FUN-BA0051
      LET g_sql = "SELECT ida_file.* ",                                      
                  #"  FROM ida_file ",   #No.FUN-B80119--mark---
                  "  FROM ",cl_get_target_table(g_plant_new,'ida_file'),  #No.FUN-B80119--add--
                  " WHERE ida01 = '",g_idb01 ,"' ",  #料號
                  "   AND ida02 = '",g_idb02 ,"' ",  #倉庫
                  "   AND ida03 = '",g_idb03 ,"' ",  #儲位
                  "   AND ida04 = '",g_idb04 ,"' ",  #批號
                  "   AND ida07 = '",g_idb07 ,"' ",  #單據編號
                  "   AND ida08 = '",g_idb08 ,"' "   #單據項次
      #No.FUN-B80119--start--add---
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      #No.FUN-B80119---end---add---
      PREPARE cs_icd_post1_pre FROM g_sql                
      IF SQLCA.SQLCODE THEN
         CALL cl_err('cs_icd_post1_pre',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE cs_icd_post1_cs CURSOR FOR cs_icd_post1_pre
      IF SQLCA.SQLCODE THEN
         CALL cl_err('cs_icd_post1_cs',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN 
      END IF
      
      LET l_cnt = 0
      FOREACH cs_icd_post1_cs INTO g_ida.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach icd_post1',SQLCA.sqlcode,1)
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
      
         LET l_flag = NULL
         LET l_fac = NULL            #轉換率
         #CALL s_umfchkm(g_idb.idb01,g_idb12,g_ida.ida13,p_plant)  #No.FUN-B80119--s_umfchk-->s_umfchkm---  #FUN-C30286
         CALL s_umfchkm(g_idb01,g_idb12,g_ida.ida13,p_plant)  #FUN-C30286
            RETURNING l_flag,l_fac
         IF l_flag = 1 THEN
            LET l_msg = g_idb12 CLIPPED,'->',g_ida.ida13 CLIPPED
            CALL cl_err(l_msg CLIPPED,'aic-907',1)
            EXIT FOREACH
         END IF 
         #過帳數量的合理性檢查
         #檢查刻號/BIN入庫總數是否等于傳入的數量
         CALL s_icdchk(g_in_out,g_idb01,g_idb02,g_idb03,
                        g_idb04,g_idb11*l_fac,g_ida.ida07,
                        g_ida.ida08,g_ida.ida09,p_plant)         #No.FUN-B80119--增加p_plant參數--
            RETURNING l_flag
         IF l_flag = 0 THEN
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      
         CALL icd_idc(p_plant)    #更新idc_file   #No.FUN-B80119--增加p_plant參數--
         IF g_success = 'N' THEN
            EXIT FOREACH
         END IF
         CALL icd_idd(p_plant)    #No.FUN-B80119--增加p_plant參數--   
         IF g_success = 'N' THEN
            EXIT FOREACH
         END IF
         LET l_cnt = l_cnt + 1
      END FOREACH
      IF g_success = 'Y' THEN
         IF l_cnt = 0 THEN
            CALL cl_err(g_idb01,'aic-906',1)
            LET g_success = 'N'
            RETURN
         END IF
         #CALL icd_ida_del(g_idb07,g_idb08,p_plant)   # del ida_file  #FUN-B70032   #No.FUN-B80119--增加p_plant參數--  #FUN-C30289
         CALL icd_ida_del1(g_idb07,g_idb08,g_idb02,g_idb03,g_idb04,'','',p_plant) #FUN-C30289
         IF g_success = 'N' THEN
             RETURN
         END IF
      END IF
   #FUN-AA0007(S)
   ELSE
      #IF g_imaicd08='N' THEN   #FUN-B70032 #FUN-BA0051 mark
      IF NOT s_icdbin(g_idb01) THEN   #FUN-BA0051
         CALL icd_set_ida(g_idb01,g_idb02,g_idb03,g_idb04,' ',' ',g_idb07,
                          g_idb08,g_idb09,g_idb11,g_idb12,g_idb14,g_idb15,g_imaicd01,p_plant) #FUN-B70032  #No.FUN-B80119--增加p_plant參數--
      END IF   #FUN-B70032                     
      CALL icd_idc(p_plant)    #更新idc_file  #No.FUN-B80119--增加p_plant參數--
      IF g_success = 'Y' THEN
         CALL icd_idd(p_plant) #No.FUN-B80119--增加p_plant參數--
      END IF
   #FUN-AA0007(E)
   END IF
END FUNCTION
#過帳：更新idc_file
FUNCTION icd_idc(p_plant)  #No.FUN-B80119--增加p_plant參數--
   DEFINE l_idc21   LIKE idc_file.idc21
   DEFINE l_idc08   LIKE idc_file.idc08,
          l_ins_img LIKE type_file.chr1   #插入或更新的標志,Y為INSERTㄛN,N為UPDATE
   DEFINE l_ids02   LIKE ids_file.ids02   #FUN-AA0007
   DEFINE l_ids04   LIKE ids_file.ids04   #FUN-AB0092
   DEFINE p_plant   LIKE type_file.chr20  #No.FUN-B80119--add-- 
   DEFINE l_imaicd04 LIKE imaicd_file.imaicd04   #FUN-BC0036
          
   #出入庫別：其它入(0)，其它出(2),不需要更新idc_file
   IF g_in_out = 0 OR g_in_out = 2 THEN RETURN END IF
   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant      #FUN-B80119---add---
 
   INITIALIZE g_idc.* TO NULL
   #出入庫別：入庫(1)
   IF g_in_out = 1 THEN
      LET g_idc.idc01 = g_idb01         
      LET g_idc.idc02 = g_idb02          
      LET g_idc.idc03 = g_idb03
      LET g_idc.idc04 = g_idb04
      LET g_idc.idc05 = g_ida.ida05
      LET g_idc.idc06 = g_ida.ida06
      LET g_idc.idc07 = g_ida.ida13
      LET g_idc.idc08 = g_ida.ida10
      IF g_idc.idc08 = 0 AND g_ida.ida11 > 0 THEN  #TQC-C50062 add
         LET g_idc.idc08 = g_ida.ida11             #TQC-C50062 add
      END IF                                       #TQC-C50062 add
      LET g_idc.idc09 = g_ida.ida14
      LET g_idc.idc10 = g_ida.ida15
      LET g_idc.idc11 = g_ida.ida16   #DATECODE
      LET g_idc.idc12 = g_ida.ida17
      LET g_idc.idc13 = g_ida.ida18   #YIELD
      LET g_idc.idc14 = g_ida.ida19   #TEST #
      LET g_idc.idc15 = g_ida.ida20   #DEDUCT
      LET g_idc.idc16 = g_ida.ida21   #PASS BIN
      LET g_idc.idc19 = g_ida.ida22
      LET g_idc.idc20 = g_ida.ida29
      LET g_idc.idc21 = 0
      LET l_ins_img = 'N'  
      LET l_idc08 = 0
      #異動idc_file,判斷是否存在于異動表，若不存在INSERT，否則UPDATE
      LET l_idc21 = 0

      #No.FUN-B80119--start--mark---
      #SELECT idc21,idc08 INTO l_idc21,l_idc08
      #  FROM idc_file
      #   WHERE idc01 = g_idb01
      #     AND idc02 = g_idb02
      #     AND idc03 = g_idb03
      #     AND idc04 = g_idb04
      #     AND idc05 = g_ida.ida05
      #     AND idc06 = g_ida.ida06   #BIN 
      #No.FUN-B80119---end---mark--

      #No.FUN-B80119--start--add---
      LET g_sql = "SELECT idc21,idc08 FROM ",cl_get_target_table(g_plant_new,'idc_file'),
                  " WHERE idc01 = '",g_idb01,"' ",
                  "   AND idc02 = '",g_idb02,"' ",
                  "   AND idc03 = '",g_idb03,"' ",
                  "   AND idc04 = '",g_idb04,"' ",
                  "   AND idc05 = '",g_ida.ida05,"' ",
                  "   AND idc06 = '",g_ida.ida06,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE icd_idc_pre FROM g_sql
      DECLARE icd_idc_cs CURSOR FOR icd_idc_pre
      OPEN icd_idc_cs
      FETCH icd_idc_cs INTO l_idc21,l_idc08 
      #No.FUN-B80119---end---add---
      
      #若異動表idc_file中沒有此料件，則INSERT
      IF SQLCA.SQLCODE = 100 THEN LET l_ins_img = 'Y' END IF
      #若異動表idc_file中此料件已沒有庫存量(idc08)，則INSERT
      IF l_idc08 = 0 THEN
      #No.FUN-B80119--start--mark---
      #   DELETE FROM idc_file
      #      WHERE idc01 = g_idb01
      #        AND idc02 = g_idb02
      #        AND idc03 = g_idb03
      #        AND idc04 = g_idb04
      #        AND idc05 = g_ida.ida05
      #        AND idc06 = g_ida.ida06  #BIN
      #No.FUN-B80119---end---mark---

      #No.FUN-B80119--start--add---    
          LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'idc_file'),
                      " WHERE idc01 = '",g_idb01,"' ",
                      "   AND idc02 = '",g_idb02,"' ",
                      "   AND idc03 = '",g_idb03,"' ",
                      "   AND idc04 = '",g_idb04,"' ",
                      "   AND idc05 = '",g_ida.ida05,"' ",
                      "   AND idc06 = '",g_ida.ida06,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
          PREPARE del_icd_idc FROM g_sql
          EXECUTE del_icd_idc
      #No.FUN-B80119---end---add---
      
         LET l_ins_img = 'Y'
      END IF
      IF l_ins_img = 'Y' THEN
         #FUN-AA0007--begin--modify-------------------------
         LET g_idc.idc17 = 'N'
         #SELECT ids02,ids04 INTO l_ids02,l_ids04 FROM ids_file WHERE ids01=g_idb04 AND idsacti='Y'  #FUN-AB0092  #FUN-B80119--mark--
         #No.FUN-B80119--start--add---
         LET g_sql = "SELECT ids02,ids04 FROM ",cl_get_target_table(g_plant_new,'ids_file'),
                     " WHERE ids01= '",g_idb04,"' AND idsacti='Y' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE icd_idc1_pre FROM g_sql
         DECLARE icd_idc1_cs CURSOR FOR icd_idc1_pre
         OPEN icd_idc1_cs
         FETCH icd_idc1_cs INTO l_ids02,l_ids04 
         #No.FUN-B80119---end---add---
         
         IF l_ids02='1' THEN LET g_idc.idc17='Y' END IF
         IF l_ids02='2' THEN
           #LET g_idc.idc18='Y'      #FUN-AB0092
            LET g_idc.idc18=l_ids04  #FUN-AB0092
         ELSE
            LET g_idc.idc18='N'
         END IF
         #FUN-AA0007--end--modify---------------------------
         #INSERT INTO idc_file VALUES (g_idc.*)    #FUN-B80119--mark--
         IF g_idc.idc12 IS NULL THEN LET g_idc.idc12=0 END IF #TQC-BA0136
         #No.FUN-B80119--start--add---    
         LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idc_file'),"(",
                        "idc01,idc02,idc03,idc04,idc05,idc06,idc07,idc08,idc09,idc10,",
                        "idc11,idc12,idc13,idc14,idc15,idc16,idc17,idc18,idc19,idc20,",
                        "idc21) VALUES",
                        "(?,?,?,?,?,?,?,?,?,?,
                          ?,?,?,?,?,?,?,?,?,?,
                          ?) "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE ins_icd_idc FROM g_sql
         EXECUTE ins_icd_idc USING g_idc.idc01,g_idc.idc02,g_idc.idc03,g_idc.idc04,g_idc.idc05,g_idc.idc06,g_idc.idc07, 
                                   g_idc.idc08,g_idc.idc09,g_idc.idc10,g_idc.idc11,g_idc.idc12,g_idc.idc13,g_idc.idc14, 
                                   g_idc.idc15,g_idc.idc16,g_idc.idc17,g_idc.idc18,g_idc.idc19,g_idc.idc20,g_idc.idc21  
         #No.FUN-B80119---end---add---
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('ins idc_file',SQLCA.SQLCODE,1)
            LET g_success = 'N' RETURN
         END IF
         #FUN-B30187 --START--
         IF NOT icd_ins_idt(g_idc.idc10,g_idc.idc04,p_plant) THEN   #No.FUN-B80119--增加p_plant參數--
            LET g_success = 'N'
            RETURN
         END IF
         #FUN-B30187 --END--
      ELSE
         #若異動表idc_file中有此料件,且有庫存量
         IF cl_null(l_idc21) THEN LET l_idc21 = 0 END IF
         LET g_idc.idc21 = l_idc21
         #更新庫存數量(idc08增加)
         #No.FUN-B80119--start--mark---
         #UPDATE idc_file SET idc08 = idc08 + g_idc.idc08,
         #                    idc12 = idc12 + g_idc.idc12    #DIE杅
         #   WHERE idc01 = g_idb01
         #     AND idc02 = g_idb02
         #     AND idc03 = g_idb03
         #     AND idc04 = g_idb04
         #     AND idc05 = g_ida.ida05
         #     AND idc06 = g_ida.ida06
         #No.FUN-B80119---end---mark---
         IF g_idc.idc12 IS NULL THEN LET g_idc.idc12=0 END IF #TQC-BA0136
         #No.FUN-B80119--start--add---
         #FUN-BC0036 --START--
         #SELECT imaicd04 INTO L_imaicd04 FROM imaicd_file  #FUN-C50102
         SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file
          WHERE imaicd00 = g_idb01
         #IF l_imaicd04 = '1' OR l_imaicd04 = '2' THEN      #FUN-C50102 
         IF l_imaicd04 = '2' THEN
            IF (l_idc08 + l_idc21 + g_ida.ida10) > 1 THEN
               CALL cl_err('','aic-323',1)
               LET g_success = 'N' 
               RETURN
            END IF 
         END IF    
         #FUN-BC0036 --END--    
         LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
                     "   SET idc08 = idc08 + ",g_idc.idc08 ,",",
                     "       idc12 = idc12 + ",g_idc.idc12 ," ",
                     " WHERE idc01 = '",g_idb01,"' ",
                     "   AND idc02 = '",g_idb02,"' ",
                     "   AND idc03 = '",g_idb03,"' ",
                     "   AND idc04 = '",g_idb04,"' ",
                     "   AND idc05 = '",g_ida.ida05,"' ",
                     "   AND idc06 = '",g_ida.ida06,"' "    
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE upd_icd_idc FROM g_sql
         EXECUTE upd_icd_idc
         #No.FUN-B80119---end---add---
         
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err('(post:1)upd img',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         #FUN-B30187 --START--
         IF NOT icd_ins_idt(g_ida.ida15,g_idc.idc04,p_plant) THEN   #No.FUN-B80119--增加p_plant參數--
            LET g_success = 'N'
            RETURN
         END IF                     
         #FUN-B30187 --END--
      END IF
    END IF
    #出庫
    IF g_in_out = -1 THEN 
       INITIALIZE g_idc.* TO NULL
       #No.FUN-B80119--start--mark---
       #SELECT idc_file.* INTO g_idc.*
       #   FROM idc_file
       #  WHERE idc01 = g_idb01
       #    AND idc02 = g_idb02
       #    AND idc03 = g_idb03
       #    AND idc04 = g_idb04
       #    AND idc05 = g_idb.idb05
       #    AND idc06 = g_idb.idb06   #BIN
       #No.FUN-B80119---end---mark---
       #No.FUN-B80119--start--add---
       LET g_sql = "SELECT idc_file.* FROM ",cl_get_target_table(g_plant_new,'idc_file'),
                   " WHERE idc01 = '",g_idb01,"' ",  #料號
                   "   AND idc02 = '",g_idb02,"' ",  #倉庫
                   "   AND idc03 = '",g_idb03,"' ",  #儲位
                   "   AND idc04 = '",g_idb04,"' ",  #批號
                   "   AND idc05 = '",g_idb.idb05,"' ",
                   "   AND idc06 = '",g_idb.idb06,"' "   #BIN  
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
       PREPARE icd_idc2_pre FROM g_sql
       DECLARE icd_idc2_cs CURSOR FOR icd_idc2_pre
       OPEN icd_idc2_cs
       FETCH icd_idc2_cs INTO g_idc.*
       #No.FUN-B80119---end---add---
       IF SQLCA.SQLCODE THEN
          #No.FUN-B90012--start--add---
          IF SQLCA.SQLCODE = 100 AND g_mflag='Y' THEN  
             CALL icd_idc_ins_idc(p_plant)
          ELSE
          #No.FUN-B90012---end---add---
             CALL cl_err('sel img',SQLCA.SQLCODE,1)
             LET g_success = 'N' 
             RETURN 
          END IF     #No.FUN-B90012--add--   
       END IF 
       #庫存數量校驗（庫存數量-本次出庫數量<0,不能過帳）
       IF g_mflag = 'N' THEN   #No.FUN-B90012--add--
          IF (g_idc.idc08-g_idc.idc21) < 0 THEN
             CALL cl_err('QTY','aic-905',1)
             LET g_success = 'N' 
             RETURN
          END IF
       END IF                  #No.FUN-B90012--add--
       #更新庫存數量
       LET g_idc.idc08 = g_idc.idc08 - g_idb.idb11
       IF s_icdbin(g_idb01) THEN  #TQC-C40050
          #更新已出庫的數量
          IF g_mflag <> 'Y' THEN     #FUN-B90012--add--
             LET g_idc.idc21 = g_idc.idc21 - g_idb.idb11
          END IF                     #FUN-B90012--add--
       END IF                     #TQC-C40050
       #更新DIE數
       LET g_idc.idc12 = g_idc.idc12 - g_idb.idb16
       #No.FUN-B80119--start--mark---
       #UPDATE idc_file SET idc_file.* = g_idc.*
       #   WHERE idc01 = g_idb01
       #     AND idc02 = g_idb02
       #     AND idc03 = g_idb03
       #     AND idc04 = g_idb04
       #     AND idc05 = g_idb.idb05
       #     AND idc06 = g_idb.idb06
       #No.FUN-B80119---end---mark---
       #No.FUN-B80119--start--add---    
       LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
                   "   SET idc01 = ?, "," idc02 = ?, ",
                   "       idc03 = ?, "," idc04 = ?, ",
                   "       idc05 = ?, "," idc06 = ?, ",
                   "       idc07 = ?, "," idc08 = ?, ",
                   "       idc09 = ?, "," idc10 = ?, ",
                   "       idc11 = ?, "," idc12 = ?, ",
                   "       idc13 = ?, "," idc14 = ?, ",
                   "       idc15 = ?, "," idc16 = ?, ",
                   "       idc17 = ?, "," idc18 = ?, ",
                   "       idc19 = ?, "," idc20 = ?, ",
                   "       idc21 = ?  ",
                   " WHERE idc01 = '",g_idb01,"' ",
                   "   AND idc02 = '",g_idb02,"' ",
                   "   AND idc03 = '",g_idb03,"' ",
                   "   AND idc04 = '",g_idb04,"' ",
                   "   AND idc05 = '",g_idb.idb05,"' ",
                   "   AND idc06 = '",g_idb.idb06,"' "    
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
       PREPARE upd_icd_idc1 FROM  g_sql
       EXECUTE upd_icd_idc1 USING g_idc.idc01,g_idc.idc02,g_idc.idc03,g_idc.idc04,g_idc.idc05,g_idc.idc06,g_idc.idc07, 
                                  g_idc.idc08,g_idc.idc09,g_idc.idc10,g_idc.idc11,g_idc.idc12,g_idc.idc13,g_idc.idc14, 
                                  g_idc.idc15,g_idc.idc16,g_idc.idc17,g_idc.idc18,g_idc.idc19,g_idc.idc20,g_idc.idc21  
       #No.FUN-B80119---end---add---
            
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('(post:-1)upd img',SQLCA.sqlcode,1) 
          LET g_success = 'N'
          RETURN
       END IF
    END IF 
END FUNCTION
#過帳
#出入庫別：入庫(1)，其它入(0)
#FUNCTION icd_ida_del(l_idb07,l_idb08,p_plant)  #FUN-B70032  #No.FUN-B80119--增加p_plant參數-- #MOD-D40074 mark 
FUNCTION icd_ida_del(p_ida07,p_ida08,p_plant)   #MOD-D40074
  #MOD-D40074---mark---S
  #DEFINE l_idb07 LIKE idb_file.idb07   #FUN-B70032
  #DEFINE l_idb08 LIKE idb_file.idb08   #FUN-B70032
  #MOD-D40074---mark---E
  #MOD-D40074---S
   DEFINE p_ida07 LIKE ida_file.ida07
   DEFINE p_ida08 LIKE ida_file.ida08
   DEFINE l_cnt   LIKE type_file.num5
  #MOD-D40074---E
   DEFINE p_plant LIKE type_file.chr20  #FUN-B80119--add--
   
   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant            #FUN-B80119--add--
   #No.FUN-B80119--start--mark---
   #LET g_sql = "DELETE FROM ida_file ",
   #            "   WHERE ida07 = '",l_idb07 ,"' ",   #單據編號 #FUN-B70032 g_idb => l_idb
   #            "     AND ida08 = ",l_idb08           #單據項次 #FUN-B70032 g_idb => l_idb
   #No.FUN-B80119---end---mark--
   #No.FUN-B80119--start--add---    

    #MOD-D40074---add---S
     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'ida_file'),
                 " WHERE ida07 = '",p_ida07 ,"' "
     IF NOT cl_null(p_ida08) THEN
        LET g_sql=g_sql CLIPPED, "     AND ida08 = " , p_ida08
     END IF
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     PREPARE cs_cnt FROM g_sql
     EXECUTE cs_cnt INTO l_cnt
 
     IF l_cnt > 0 THEN
    #MOD-D40074---add---E    
        LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'ida_file'),
                   #"   WHERE ida07 = '",l_idb07 ,"' "  #MOD-D40074 mark
                    "   WHERE ida07 = '",p_ida07 ,"' "  #MOD-D40074 
       #MOD-D40074---mark---S
       #IF NOT cl_null(l_idb08) THEN 
       #   LET g_sql=g_sql CLIPPED, "     AND ida08 = " , l_idb08
       #END IF 
       #MOD-D40074---mark---E
       #MOD-D40074---S
        IF NOT cl_null(p_ida08) THEN
           LET g_sql=g_sql CLIPPED, "     AND ida08 = " , p_ida08
        END IF 
       #MOD-D40074---E
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
        #No.FUN-B80119---end---add---
        
        PREPARE cs_icd_delin_pre FROM g_sql
        IF SQLCA.SQLCODE THEN
           CALL cl_err('cs_icd_delin_pre',SQLCA.SQLCODE,1)
           LET g_success = 'N'
           RETURN
        END IF
        EXECUTE cs_icd_delin_pre
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('del ida',SQLCA.sqlcode,1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF  #MOD-D40074 add
END FUNCTION

#FUN-C30289---begin
FUNCTION icd_ida_del1(l_idb07,l_idb08,l_idb02,l_idb03,l_idb04,l_idb05,l_idb06,p_plant)
   DEFINE l_idb07 LIKE idb_file.idb07   
   DEFINE l_idb08 LIKE idb_file.idb08   
   DEFINE p_plant LIKE type_file.chr20  
   DEFINE l_idb02 LIKE idb_file.idb02
   DEFINE l_idb03 LIKE idb_file.idb03
   DEFINE l_idb04 LIKE idb_file.idb04
   DEFINE l_idb05 LIKE idb_file.idb05
   DEFINE l_idb06 LIKE idb_file.idb06

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF 
   LET g_plant_new = p_plant

   LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'ida_file'),
               "   WHERE ida07 = '",l_idb07 ,"' "
   IF NOT cl_null(l_idb08) THEN 
      LET g_sql=g_sql CLIPPED, "     AND ida08 = " , l_idb08
   END IF 
   IF NOT cl_null(l_idb02) THEN 
      LET g_sql=g_sql CLIPPED, "     AND ida02 = '" , l_idb02,"' "
   END IF 
   IF NOT cl_null(l_idb03) THEN 
      LET g_sql=g_sql CLIPPED, "     AND ida03 = '" , l_idb03,"' "
   END IF 
   IF NOT cl_null(l_idb04) THEN 
      LET g_sql=g_sql CLIPPED, "     AND ida04 = '" , l_idb04,"' "
   END IF 
   IF NOT cl_null(l_idb05) THEN 
      LET g_sql=g_sql CLIPPED, "     AND ida05 = '" , l_idb05,"' "
   END IF 
   IF NOT cl_null(l_idb05) THEN 
      LET g_sql=g_sql CLIPPED, "     AND ida06 = '" , l_idb06,"' "
   END IF 
   
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql

   PREPARE cs_icd_delin_pre1 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('cs_icd_delin_pre',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE cs_icd_delin_pre1
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('del ida',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION 
#FUN-C30289---end

#過帳
#出入庫別：出庫(-1)，其他出(2)
#FUNCTION icd_idb_del(l_idb07,l_idb08,p_plant)   #FUN-B70032  #No.FUN-B80119--增加p_plant參數-- #MOD-D40074 mark
FUNCTION icd_idb_del(p_idb07,p_idb08,p_plant)    #MOD-D40074
  #MOD-D40074---mark---S
  #DEFINE l_idb07 LIKE idb_file.idb07   #FUN-B70032
  #DEFINE l_idb08 LIKE idb_file.idb08   #FUN-B70032
  #MOD-D40074---mark---E
  #MOD-D40074---S
   DEFINE p_idb07 LIKE idb_file.idb07
   DEFINE p_idb08 LIKE idb_file.idb08
   DEFINE l_cnt   LIKE type_file.num5  
  #MOD-D40074---E
   DEFINE p_plant LIKE type_file.chr20  #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF    #No.FUN-B80119--add---
   LET g_plant_new = p_plant            #FUN-B80119--add--
   #No.FUN-B80119--start--mark---
   #LET g_sql = "DELETE FROM idb_file ",
   #            "  WHERE idb07 = '",l_idb07 ,"' ",   #FUN-B70032 g_idb => l_idb
   #            "    AND idb08 =  ",l_idb08          #FUN-B70032 g_idb => l_idb
   #No.FUN-B80119---end---mark---
   #No.FUN-B80119--start--add---    

    #MOD-D40074---add---S
     LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'idb_file'),
                 " WHERE idb07 = '",p_idb07 ,"' "
     IF NOT cl_null(p_idb08) THEN
        LET g_sql=g_sql CLIPPED, "     AND idb08 = " , p_idb08
     END IF
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     PREPARE cs_cnt2 FROM g_sql
     EXECUTE cs_cnt2 INTO l_cnt

     IF l_cnt > 0 THEN
    #MOD-D40074---add---E
        LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'idb_file'),
                   #"   WHERE idb07 = '",l_idb07 ,"' "  #MOD-D40074 mark
                    "   WHERE idb07 = '",p_idb07 ,"' "  #MOD-D40074
       #MOD-D40074---mark---S 
       #IF NOT cl_null(l_idb08) THEN 
       #   LET g_sql=g_sql CLIPPED, "     AND idb08 = " , l_idb08
       #END IF 
       #MOD-D40074---mark---E
       #MOD-D40074---S
        IF NOT cl_null(p_idb08) THEN
           LET g_sql=g_sql CLIPPED, "     AND idb08 = " , p_idb08
        END IF
       #MOD-D40074---E
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
        #No.FUN-B80119---end---add---
 
        PREPARE cs_icd_delout_pre FROM g_sql
        IF SQLCA.SQLCODE THEN
           CALL cl_err('cs_icd_delout_pre',SQLCA.SQLCODE,1)
           LET g_success = 'N'
           RETURN 
        END IF
        EXECUTE cs_icd_delout_pre
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                               
           CALL cl_err('del idb',SQLCA.sqlcode,1)                             
           LET g_success = 'N'                                                      
           RETURN                                                                   
        END IF     
     END IF  #MOD-D40074 add
END FUNCTION

#FUN-B40081 --START--
FUNCTION icd_idb_del_multi(l_idb01,l_idb02,l_idb03,l_idb04,l_idb07,l_idb08,p_plant)
   DEFINE l_idb01 LIKE idb_file.idb01
   DEFINE l_idb02 LIKE idb_file.idb02   
   DEFINE l_idb03 LIKE idb_file.idb03   
   DEFINE l_idb04 LIKE idb_file.idb04   
   DEFINE l_idb07 LIKE idb_file.idb07   
   DEFINE l_idb08 LIKE idb_file.idb08   
   DEFINE p_plant LIKE type_file.chr20 

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF    
   LET g_plant_new = p_plant               
   LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'idb_file'),
               "   WHERE idb01 = '",l_idb01 ,"' AND idb02 = '", l_idb02 ,"' ",
               "     AND idb03 = '",l_idb03 ,"' AND idb04 = '", l_idb04 ,"' ",  
               "     AND idb07 = '",l_idb07 ,"' AND idb08 = '", l_idb08 ,"' "
   
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   
   PREPARE cs_icd_delout_pre2 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('cs_icd_delout_pre2',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN 
   END IF
   EXECUTE cs_icd_delout_pre2  
   IF SQLCA.sqlcode THEN                                     
      CALL cl_err('del idb',SQLCA.sqlcode,1)                             
      LET g_success = 'N'                                                      
      RETURN                                                                   
   END IF     
END FUNCTION
#FUN-B40081 --END--

#過帳：出庫(-1)
FUNCTION icd_post2(p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE l_flag  LIKE type_file.chr1
   DEFINE l_fac   LIKE type_file.num20_6
   DEFINE l_msg   LIKE type_file.chr1000
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE p_plant LIKE type_file.chr20  #FUN-B80119--add--
   DEFINE l_idb26 LIKE idb_file.idb26   #FUN-BC0036
   DEFINE l_idb27 LIKE idb_file.idb27   #FUN-BC0036

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant            #FUN-B80119--add--
   #IF g_imaicd08='Y' THEN  #FUN-AA0007 #FUN-BA0051 mark
   IF s_icdbin(g_idb01) THEN   #FUN-BA0051
      LET g_sql = "SELECT idb_file.* ",                                      
                  #"  FROM idb_file  ", #No.FUN-B80119--mark--
                  "  FROM ",cl_get_target_table(g_plant_new,'idb_file'),  #No.FUN-B80119--add--
                  " WHERE idb01 = '",g_idb01 ,"' ",   #料號
                  "   AND idb02 = '",g_idb02 ,"' ",   #倉庫
                  "   AND idb03 = '",g_idb03 ,"' ",   #儲位
                  "   AND idb04 = '",g_idb04 ,"' ",   #批號
                  "   AND idb07 = '",g_idb07 ,"' ",   #單據編號
                  "   AND idb08 =  ",g_idb08          #單據項次
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #No.FUN-B80119--add--
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #No.FUN-B80119--add--
      PREPARE cs_icd_post2_pre FROM g_sql  
      IF SQLCA.SQLCODE THEN
         CALL cl_err('pre cs_icd_post2_pre',SQLCA.SQLCODE,1)
         LET g_success = 'N' 
         RETURN
      END IF
      DECLARE cs_icd_post2_cs CURSOR FOR cs_icd_post2_pre
      IF SQLCA.SQLCODE THEN
         CALL cl_err('cs_icd_post2_cs',SQLCA.SQLCODE,1)
         LET g_success = 'N' 
         RETURN
      END IF
      
      LET l_cnt = 0
      FOREACH cs_icd_post2_cs INTO g_idb.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach icd_post2',SQLCA.sqlcode,1)
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
         #FUN-BC0036 --STATR--
         IF NOT cl_null(g_idb.idb26) OR NOT cl_null(g_idb.idb27) THEN  
            LET l_idb26 = g_idb.idb26
            LET l_idb27 = g_idb.idb27
            LET g_idb.idb26 = g_idb.idb05
            LET g_idb.idb27 = g_idb.idb06
            LET g_idb.idb05 = l_idb26
            LET g_idb.idb06 = l_idb27
         END IF   
         #FUN-BC0036 --END--      
         LET l_flag = NULL  #是否有此單位轉換:1,錯誤；0，OK
         LET l_fac = NULL   #轉換率
         #兩料件單位間轉換率的計算與檢查
         #g_idb.idb01：料件
         #g_idb12：來源單位
         #g_idb.idb12:資料庫名稱
         CALL s_umfchkm(g_idb.idb01,g_idb12,g_idb.idb12,p_plant)    #No.FUN-B80119--s_umfchk-->s_umfchkm---
            RETURNING l_flag,l_fac
         IF l_flag = 1 THEN
            LET l_msg = g_idb12 CLIPPED,'->',g_idb.idb12 CLIPPED
            CALL cl_err(l_msg CLIPPED,'aic-907',1)
            EXIT FOREACH 
         END IF
         #出庫過帳，數量的合理性檢查
         #檢查出貨數量是否等于傳入數量
         #參數依次為：出入庫別、料件編號、倉庫、儲位
         #批號、數量、單據編號、單據項次、單據日期
         #返回1成功，0失敗
         CALL s_icdchk(g_in_out,g_idb01,g_idb02,g_idb03,
                        g_idb04,g_idb11*l_fac,g_idb.idb07,
                        g_idb.idb08,g_idb.idb09,p_plant)     #No.FUN-B80119--增加p_plant參數--
            RETURNING l_flag
         IF l_flag = 0 THEN
            LET g_success = 'N'
            EXIT FOREACH 
         END IF
         #若料件的庫存狀態(idc17)為Y，則不允許出庫
         CALL icd_out_chk(p_plant)   #No.FUN-B80119--增加p_plant參數--
         IF g_success = 'N' THEN
            EXIT FOREACH
         END IF
         #INSERT或UPDATE idc_file
         CALL icd_idc(p_plant)       #No.FUN-B80119--增加p_plant參數--
         IF g_success = 'N' THEN
            EXIT FOREACH 
         END IF
         #INSERT或UPDATE idd_file
         CALL icd_idd(p_plant)       #No.FUN-B80119--增加p_plant參數--
         IF g_success = 'N' THEN
            EXIT FOREACH
         END IF 
         LET l_cnt = l_cnt + 1
      END FOREACH 
      IF g_success = 'Y' THEN
         IF l_cnt = 0 THEN
            CALL cl_err(g_idb01,'aic-906',1)
            LET g_success = 'N'
            RETURN
         END IF
         #刪除對應idb_file中的資料
         #CALL icd_idb_del(g_idb07,g_idb08,p_plant)   #No.FUN-B80119--增加p_plant參數-- #FUN-B40081 mark
         CALL icd_idb_del_multi(g_idb01,g_idb02,g_idb03,g_idb04,g_idb07,g_idb08,p_plant)   #FUN-B40081
         IF g_success = 'N' THEN
            RETURN
         END IF
      END IF
   #FUN-AA0007(S)
   ELSE
      #IF g_imaicd08='N' THEN #FUN-B70032 #FUN-BA0051 mark 
      IF NOT s_icdbin(g_idb01) THEN   #FUN-BA0051
         CALL icd_set_idb(g_idb01,g_idb02,g_idb03,g_idb04,' ',' ',g_idb07,
                          g_idb08,g_idb09,g_idb11,g_idb12,g_idb14,g_idb15,g_imaicd01,p_plant) #FUN-B70032  #No.FUN-B80119--增加p_plant參數--
      END IF #FUN-B70032                           
      CALL icd_idc(p_plant)    #更新idc_file   #No.FUN-B80119--增加p_plant參數--
      IF g_success = 'Y' THEN
         CALL icd_idd(p_plant) #No.FUN-B80119--增加p_plant參數--
      END IF
   END IF   
   #FUN-AA0007(E)
END FUNCTION

#過帳：產生idd_file
FUNCTIOn icd_idd(p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--
   INITIALIZE g_idd.* TO NULL
   #出入庫別：入庫1，其它入0
   IF g_in_out = 1 OR g_in_out = 0 THEN 
      LET g_idd.idd01 = g_idb01
      LET g_idd.idd02 = g_idb02
      LET g_idd.idd03 = g_idb03 
      LET g_idd.idd04 = g_idb04
      LET g_idd.idd05 = g_ida.ida05
      LET g_idd.idd06 = g_ida.ida06
      LET g_idd.idd07 = g_ida.ida13
      LET g_idd.idd08 = g_ida.ida09
      LET g_idd.idd09 = g_today
      LET g_idd.idd10 = g_idb07
      LET g_idd.idd11 = g_idb08
      LET g_idd.idd12 = g_in_out
      LET g_idd.idd13 = g_ida.ida10
      LET g_idd.idd14 = ' '
      LET g_idd.idd15 = g_ida.ida14
      LET g_idd.idd16 = g_ida.ida15
      LET g_idd.idd17 = g_ida.ida16
      LET g_idd.idd18 = g_ida.ida17
      LET g_idd.idd19 = g_ida.ida18   #YIELD
      LET g_idd.idd20 = g_ida.ida19   #TEST #
      LET g_idd.idd21 = g_ida.ida20   #DEDUCT
      LET g_idd.idd22 = g_ida.ida21   #PASS BIN
      LET g_idd.idd23 = g_ida.ida22
      LET g_idd.idd24 = g_ida.ida26
      LET g_idd.idd25 = g_ida.ida29
      LET g_idd.idd26 = g_ida.ida11
      LET g_idd.idd27 = g_ida.ida12
      LET g_idd.idd28 = g_ida.ida27
      LET g_idd.idd29 = 0           #CHI-C80009 add #庫存數量 
      LET g_idd.idd30 = g_ida.ida30
      LET g_idd.idd31 = g_ida.ida31
      LET g_idd.idd32 = 'N' #FUN-AA0007      
      LET g_idd.idd33 = ' '         #CHI-C80009 add #變更後刻號 
      LET g_idd.idd34 = ' '         #CHI-C80009 add #變更後BIN
   END IF
   #出入庫別：出庫-1，其他出2
   IF g_in_out = -1 OR g_in_out = 2 THEN 
      LET g_idd.idd01 = g_idb01
      LET g_idd.idd02 = g_idb02                                    
      LET g_idd.idd03 = g_idb03                                    
      LET g_idd.idd04 = g_idb04 
      LET g_idd.idd05 = g_idb.idb05
      LET g_idd.idd06 = g_idb.idb06
      LET g_idd.idd07 = g_idb.idb12
      LET g_idd.idd08 = g_idb.idb09
      LET g_idd.idd09 = g_today
      LET g_idd.idd10 = g_idb07
      LET g_idd.idd11 = g_idb08
      LET g_idd.idd12 = g_in_out
      LET g_idd.idd13 = g_idb.idb11
      LET g_idd.idd14 = ' ' #unconfirm
      LET g_idd.idd15 = g_idb.idb13
      LET g_idd.idd16 = g_idb.idb14
      LET g_idd.idd17 = g_idb.idb15
      LET g_idd.idd18 = g_idb.idb16
      LET g_idd.idd19 = g_idb.idb17
      LET g_idd.idd20 = g_idb.idb18
      LET g_idd.idd21 = g_idb.idb19 
      LET g_idd.idd22 = g_idb.idb20
      LET g_idd.idd23 = g_idb.idb21
      LET g_idd.idd24 = 'N'         #CHI-C80009 add #入庫否 
      LET g_idd.idd25 = g_idb.idb25
#CHI-C80009---add---START
      LET g_idd.idd26 = 0           #不良數量
      LET g_idd.idd27 = 0           #報廢數量
      LET g_idd.idd28 = 'N'         #轉入否
#CHI-C80009---add-----END
      LET g_idd.idd29 = g_idb.idb10
      LET g_idd.idd30 = ' '         #CHI-C80009 add #來源單據
      LET g_idd.idd31 = ' '         #CHI-C80009 add #來源單據項次
      LET g_idd.idd32='N'  #FUN-AA0007
      LET g_idd.idd33 = g_idb.idb26   #FUN-BC0036
      LET g_idd.idd34 = g_idb.idb27   #FUN-BC0036      
   END IF
 
   #LET g_idd.iddplant = g_plant  #FUN-980012 add     #FUN-B80119--mark--
   LET g_idd.iddplant = p_plant  #FUN-980012 add      #FUN-B80119--add---
   LET g_idd.iddlegal = g_legal  #FUN-980012 add
   IF g_idd.idd18 IS NULL THEN LET g_idd.idd18=0 END IF #TQC-BA0136 
   #-->insert idd_file
   #INSERT INTO idd_file VALUES(g_idd.*)  #FUN-B80119--mark--
   #No.FUN-B80119--start--add---    
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idd_file'),"(",
                 "idd01,idd02,idd03,idd04,idd05,idd06,idd07,idd08,idd09,idd10,",
                 "idd11,idd12,idd13,idd14,idd15,idd16,idd17,idd18,idd19,idd20,",
                 "idd21,idd22,idd23,idd24,idd25,idd26,idd27,idd28,idd29,idd30,",
                 "idd31,iddplant,iddlegal,idd32,idd33,idd34) VALUES",   #FUN-BC0036 add idd33,34
                 "(?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?) "   #FUN-BC0036 add ,?,?
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE ins_icd_idd FROM g_sql
   EXECUTE ins_icd_idd USING g_idd.idd01,g_idd.idd02,g_idd.idd03,g_idd.idd04,g_idd.idd05,
                             g_idd.idd06,g_idd.idd07,g_idd.idd08,g_idd.idd09,g_idd.idd10, 
                             g_idd.idd11,g_idd.idd12,g_idd.idd13,g_idd.idd14,g_idd.idd15,
                             g_idd.idd16,g_idd.idd17,g_idd.idd18,g_idd.idd19,g_idd.idd20,  
                             g_idd.idd21,g_idd.idd22,g_idd.idd23,g_idd.idd24,g_idd.idd25,
                             g_idd.idd26,g_idd.idd27,g_idd.idd28,g_idd.idd29,g_idd.idd30,
                             g_idd.idd31,g_idd.iddplant,g_idd.iddlegal,g_idd.idd32,
                             g_idd.idd33,g_idd.idd34   #FUN-BC0036
   #No.FUN-B80119---end---add---
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('ins idd_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
END FUNCTION
#過帳還原：入庫1，其它0
FUNCTION icd_unpost1(p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE p_plant LIKE type_file.chr20  # No.FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant            # No.FUN-B80119--add--
   
   LET g_sql = "SELECT idd_file.* ",    
               #"  FROM idd_file ",     #FUN-B80119--mark--
               "  FROM ",cl_get_target_table(g_plant_new,'idd_file'),  #FUN-B80119--add--
               " WHERE idd01 = '",g_idb01 ,"' ",  #料號
               "   AND idd02 = '",g_idb02 ,"' ",  #倉庫
               "   AND idd03 = '",g_idb03 ,"' ",  #儲位
               "   AND idd04 = '",g_idb04 ,"' ",  #批號
               "   AND idd10 = '",g_idb07 ,"' ",  #單據編號
               "   AND idd11 =  ",g_idb08 ,       #單據項次
               "   AND idd12 =  ",g_in_out        #出入庫別
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #No.FUN-B80119--add--
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #No.FUN-B80119--add--
   PREPARE cs_icd_unpost1_pre FROM g_sql      
   IF SQLCA.SQLCODE THEN
      CALL cl_err('cs_icd_unpost1_pre',SQLCA.SQLCODE,1)
      LET g_success = 'N' 
      RETURN
   END IF
   DECLARE cs_icd_unpost1_cs CURSOR FOR cs_icd_unpost1_pre
   IF SQLCA.SQLCODE THEN
      CALL cl_err('cs_icd_unpost1_cs',SQLCA.SQLCODE,1)
      LET g_success = 'N' 
      RETURN
   END IF
   INITIALIZE g_idd.* TO NULL
 
   LET l_cnt = 0
   FOREACH cs_icd_unpost1_cs INTO g_idd.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach icd_unpost1',SQLCA.sqlcode,1)
         LET g_success = 'N' 
         EXIT FOREACH
      END IF
      CALL icd_img2(p_plant)    #還原idc_file  #No.FUN-B80119--增加p_plant參數--
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
      CALL icd_ida(g_in_out,g_idd.*,p_plant)    #還原ida_file   #No.FUN-B80119--增加g_in_out,g_idd.*,p_plant參數--
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_success = 'Y' THEN
      #查無此單據項次的刻號明細庫存異動檔(idd_file)，無法進行還原,請核查
      IF l_cnt = 0 THEN
         CALL cl_err(g_idb01,'aic-904',1)
         LET g_success = 'N'
         RETURN
      END IF
      #刪除對應idd_file中的資料
      #CALL icd_idd_del(p_plant)   #No.FUN-B80119--增加p_plant參數-- #TQC-BA0136 mark
      CALL icd_idd_del_multi(p_plant)    #TQC-BA0136
      IF g_success = 'N' THEN
         RETURN
      END IF
   END IF
END FUNCTION
#過帳還原：還原idc_file
FUNCTION icd_img2(p_plant) # update idc_file  #No.FUN-B80119--增加p_plant參數--
   DEFINE l_idc08    LIKE idc_file.idc08,
          l_idc21    LIKE idc_file.idc21
   DEFINE l_msg      LIKE type_file.chr1000                  
   DEFINE p_plant    LIKE type_file.chr20    #FUN-B80119--add--
   DEFINE l_idd13    LIKE idd_file.idd13     #FUN-B90012--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   
   #出入庫別：其它入0，其它出2，不需要異動idc_file
   IF g_in_out = 0 OR g_in_out = 2 THEN RETURN END IF
   LET g_plant_new = p_plant              #FUN-B80119--add--
   INITIALIZE g_idc.* TO NULL
   #出入庫別：入庫1
   IF g_in_out = 1 THEN
      #先檢查庫存是否夠做過帳還原
      LET l_idc08 = 0 
      LET l_idc21 = 0
      #No.FUN-B80119--start--mark---
      #SELECT idc08,idc21 INTO l_idc08,l_idc21
      #   FROM idc_file
      #   WHERE idc01 = g_idb01
      #     AND idc02 = g_idb02
      #     AND idc03 = g_idb03
      #     AND idc04 = g_idb04
      #     AND idc05 = g_idd.idd05
      #     AND idc06 = g_idd.idd06  #BIN
      #No.FUN-B80119---end---mark---
      #No.FUN-B80119--start--add---
      LET g_sql = "SELECT idc08,idc21 FROM ",cl_get_target_table(g_plant_new,'idc_file'),
                  " WHERE idc01 = '",g_idb01,"' ",
                  "   AND idc02 = '",g_idb02,"' ",
                  "   AND idc03 = '",g_idb03,"' ",
                  "   AND idc04 = '",g_idb04,"' ",
                  "   AND idc05 = '",g_idd.idd05,"' ",
                  "   AND idc06 = '",g_idd.idd06,"' "   
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE icd_img2_pre FROM g_sql
      DECLARE icd_img2_cs CURSOR FOR icd_img2_pre
      OPEN icd_img2_cs
      FETCH icd_img2_cs INTO l_idc08,l_idc21
      #No.FUN-B80119---end---add---

      IF SQLCA.SQLCODE THEN
         CALL cl_err('sel img(qty)',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
      #庫存不足，不允許過帳還原
      IF g_mflag <> 'Y' THEN    #FUN-B90012--add-- 
         IF (l_idc08 - l_idc21 - g_idd.idd13) < 0 THEN
            LET l_msg = "[LineNO:",g_idb08 USING '<<<<<',",",
                        " PartNO:",g_idb01,"]"
            CALL cl_err(l_msg,'aic-903',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF 
      #還原庫存的數量(扣掉)
      #No.FUN-B80119--start--mark---
      #UPDATE idc_file SET idc08 = idc08 - g_idd.idd13,
      #                    idc12 = idc12 - g_idd.idd18
      #   WHERE idc01 = g_idb01
      #     AND idc02 = g_idb02
      #     AND idc03 = g_idb03
      #     AND idc04 = g_idb04
      #     AND idc05 = g_idd.idd05
      #     AND idc06 = g_idd.idd06  #BIN
      #No.FUN-B80119---end---mark---
      IF g_idd.idd18 IS NULL THEN LET g_idd.idd18=0 END IF #TQC-BA0136
      #No.FUN-B80119--start--add---    
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
                  "   SET idc08 = idc08 - ",g_idd.idd13 ,",",
                  "       idc12 = idc12 - ",g_idd.idd18 ,",",
                  "       idc11 = '",g_idb15,"' ",  #TQC-C60014
                  " WHERE idc01 = '",g_idb01,"' ",
                  "   AND idc02 = '",g_idb02,"' ",
                  "   AND idc03 = '",g_idb03,"' ",
                  "   AND idc04 = '",g_idb04,"' ",
                  "   AND idc05 = '",g_idd.idd05,"' ",
                  "   AND idc06 = '",g_idd.idd06,"' "    
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE upd_icd_img2 FROM g_sql
      EXECUTE upd_icd_img2
      #No.FUN-B80119---end---add---
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('(1)unpost img',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN 
      END IF
   END IF
   #出入庫別：出庫-1
   IF g_in_out = -1 THEN 
      #還原庫存數量，本次出貨數量加起來
      #No.FUN-B80119--start--mark---
      #UPDATE idc_file SET idc08 = idc08 + g_idd.idd13,
      #                       idc21 = idc21 + g_idd.idd13,
      #                       idc12 = idc12 + g_idd.idd18
      #  WHERE idc01 = g_idb01
      #    AND idc02 = g_idb02
      #    AND idc03 = g_idb03
      #    AND idc04 = g_idb04
      #    AND idc05 = g_idd.idd05
      #    AND idc06 = g_idd.idd06  #BIN
      #No.FUN-B80119---end---mark---
      IF s_icdbin(g_idb01) THEN  #TQC-C40050
         #FUN-B90012--start--add--
         IF g_mflag <> 'Y' THEN
            LET l_idd13 = g_idd.idd13
         ELSE
            LET l_idd13 = 0
         END IF
         #FUN-B90012---end---add--
      ELSE                       #TQC-C40050
         LET l_idd13 = 0         #TQC-C40050
      END IF                     #TQC-C40050
      IF g_idd.idd18 IS NULL THEN LET g_idd.idd18=0 END IF #TQC-BA0136
      #No.FUN-B80119--start--add---    
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
                  "   SET idc08 = idc08 + ",g_idd.idd13 ,",",
                  "       idc21 = idc21 + ",l_idd13 ,",",    #FUN-B90012
                  "       idc12 = idc12 + ",g_idd.idd18 ,",",
                  "       idc11 = '",g_idb15,"' ",  #TQC-C60014
                  " WHERE idc01 = '",g_idb01,"' ",
                  "   AND idc02 = '",g_idb02,"' ",
                  "   AND idc03 = '",g_idb03,"' ",
                  "   AND idc04 = '",g_idb04,"' ",
                  "   AND idc05 = '",g_idd.idd05,"' ",
                  "   AND idc06 = '",g_idd.idd06,"' "    
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE upd_icd_img2_1 FROM g_sql
      EXECUTE upd_icd_img2_1
      #No.FUN-B80119---end---add---
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('(-1)unpost img',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF 
END FUNCTION

#TQC-BA0136 --START mark--
##過帳還原，刪除idd_file的資料
#FUNCTION icd_idd_del(p_plant) # del idd_file   #No.FUN-B80119--增加p_plant參數--
#   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--
#
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
#   LET g_plant_new = p_plant              #FUN-B80119--add--
# 
#   #LET g_sql = " DELETE FROM idd_file ", #FUN-B80119--mark--
#   LET g_sql = " DELETE FROM ",cl_get_target_table(g_plant_new,'idd_file'),  #FUN-B80119--add--
#               "    WHERE idd10 = '",g_idb07 CLIPPED,"' ", 
#               "      AND idd11 =  ",g_idb08 CLIPPED,
#               "      AND idd12 =  ",g_in_out
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #No.FUN-B80119--add--
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #No.FUN-B80119--add--
#   PREPARE cs_icd_delidd_pre FROM g_sql
#   IF SQLCA.SQLCODE THEN
#      CALL cl_err('cs_icd_delidd_pre',SQLCA.SQLCODE,1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#   EXECUTE cs_icd_delidd_pre
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('del idd_file',SQLCA.sqlcode,1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#  
#END FUNCTION
#TQC-BA0136 --END mark--

#FUN-B40081 --START--
#過帳還原，刪除idd_file的資料(多倉儲出貨)
FUNCTION icd_idd_del_multi(p_plant)
   DEFINE p_plant LIKE type_file.chr20    

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  
   LET g_plant_new = p_plant              
 
   LET g_sql = " DELETE FROM ",cl_get_target_table(g_plant_new,'idd_file'),
               "    WHERE idd10 = '",g_idb07 CLIPPED,"' ", 
               "      AND idd01 = '",g_idb01 ,"' ",
               "      AND idd02 = '",g_idb02 ,"' ",
               "      AND idd03 = '",g_idb03 ,"' ",
               "      AND idd04 = '",g_idb04 ,"' ",
               "      AND idd11 =  ",g_idb08 CLIPPED,
               "      AND idd12 =  ",g_in_out
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql     
   PREPARE cs_icd_delidd_multi_pre FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('cs_icd_delidd_multi_pre',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
   EXECUTE cs_icd_delidd_multi_pre
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('del idd_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
  
END FUNCTION
#FUN-B40081 --END--

#過帳還原：出庫-1
FUNCTION icd_unpost2(p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE l_flag  LIKE type_file.chr1
   DEFINE l_fac   LIKE type_file.num20_6
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--
 
   LET g_sql = "SELECT idd_file.* ",                                      
               #"  FROM idd_file ",   #FUN-B80119--mark--
               "  FROM ",cl_get_target_table(g_plant_new,'idd_file'),  #FUN-B80119--add--   
               " WHERE idd01 = '",g_idb01 ,"' ",
               "   AND idd02 = '",g_idb02 ,"' ",
               "   AND idd03 = '",g_idb03 ,"' ",
               "   AND idd04 = '",g_idb04 ,"' ",
               "   AND idd10 = '",g_idb07 ,"' ",
               #"   AND idd11 = '",g_idb08 ,"' ", #BIN #TQC-BA0136 mark
               "   AND idd11 =  ",g_idb08 ,"  ", #TQC-BA0136
               "   AND idd12 =  ",g_in_out
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #No.FUN-B80119--add--
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #No.FUN-B80119--add--
   PREPARE cs_icd_unpost2_pre FROM g_sql      
   IF SQLCA.SQLCODE THEN
      CALL cl_err('cs_icd_unpost2_pre',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE cs_icd_unpost2_cs CURSOR FOR cs_icd_unpost2_pre
   IF SQLCA.SQLCODE THEN
      CALL cl_err('cs_icd_unpost2_cs',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_cnt = 0
   FOREACH cs_icd_unpost2_cs INTO g_idd.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach unpost2',SQLCA.sqlcode,0)
         LET g_success = 'N' 
         EXIT FOREACH
      END IF
      CALL icd_img2(p_plant)  #還原（更新idc_file）  #No.FUN-B80119--增加p_plant參數--
      IF g_success = 'N' THEN
         RETURN
      END IF
      CALL icd_idb(g_idd.*,p_plant) #還原（更新第百–file）    #No.FUN-B80119--增加g_idd.*,p_plant參數--
      IF g_success = 'N' THEN
         RETURN
      END IF 
      LET l_cnt = l_cnt + 1
   END FOREACH 
   IF g_success = 'Y' THEN
      IF l_cnt = 0 THEN
         CALL cl_err(g_idb01,'aic-904',1)
         LET g_success = 'N'
         RETURN
      END IF
 
      #CALL icd_idd_del(p_plant)   #刪除idd_file的資料  #No.FUN-B80119--增加p_plant參數-- #FUN-B40081 mark  
      CALL icd_idd_del_multi(p_plant)   #FUN-B40081
      IF g_success = 'N' THEN
         RETURN
      END IF
   END IF
END FUNCTION
#過帳還原
#出入庫別：入庫1，其它0；還原ida_file
#No.FUN-B80119--修改為外部傳參--start---   
FUNCTION icd_ida(p_in_out,p_idd,p_plant) # insert ida_file  #No.FUN-B80119--增加p_in_out,p_idd,p_plant參數--
   #No.FUN-B80119--start--add--- 
   DEFINE p_idd    RECORD LIKE idd_file.*
   DEFINE p_in_out LIKE type_file.num5
   DEFINE p_plant LIKE type_file.chr20  
   #No.FUN-B80119---end---add---    

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  
   #No.FUN-B80119--start--add--- 
   IF cl_null(g_imaicd08) THEN 
      CALL icd_imaicd04(p_idd.idd01,p_plant)
   END IF 
   #No.FUN-B80119---end---add---
   #IF g_imaicd08='N' THEN RETURN END IF   #FUN-AA0007 #FUN-BA0051 mark
   IF NOT s_icdbin(p_idd.idd01) THEN RETURN END IF   #FUN-BA0051 
   INITIALIZE g_ida.* TO NULL
   LET g_plant_new = p_plant              #FUN-B80119--add--
   LET g_ida.ida01 = p_idd.idd01
   LET g_ida.ida02 = p_idd.idd02
   LET g_ida.ida03 = p_idd.idd03
   LET g_ida.ida04 = p_idd.idd04
   LET g_ida.ida05 = p_idd.idd05
   LET g_ida.ida06 = p_idd.idd06     #BIN
   LET g_ida.ida07 = p_idd.idd10
   LET g_ida.ida08 = p_idd.idd11
   LET g_ida.ida09 = p_idd.idd08
   LET g_ida.ida10 = p_idd.idd13
   LET g_ida.ida11 = p_idd.idd26
   LET g_ida.ida12 = p_idd.idd27
   LET g_ida.ida13 = p_idd.idd07
   LET g_ida.ida14 = p_idd.idd15
   LET g_ida.ida15 = p_idd.idd16
   LET g_ida.ida16 = p_idd.idd17     #DATECODE
   LET g_ida.ida17 = p_idd.idd18  
   LET g_ida.ida18 = p_idd.idd19     #YIELD
   LET g_ida.ida19 = p_idd.idd20     #TEST
   LET g_ida.ida20 = p_idd.idd21     #DEDUCT
   LET g_ida.ida21 = p_idd.idd22     #PASS BIN
   LET g_ida.ida22 = p_idd.idd23
   LET g_ida.ida27 = p_idd.idd28
   LET g_ida.ida28 = p_in_out
   LET g_ida.ida29 = p_idd.idd25
   LET g_ida.ida26 = p_idd.idd24
   LET g_ida.ida30 = p_idd.idd30
   LET g_ida.ida31 = p_idd.idd31
 
   #LET g_ida.idaplant = g_plant  #FUN-980012 add  #FUN-B80119--mark--
   LET g_ida.idaplant = p_plant  #FUN-980012 add   #FUN-B80119--add---
   LET g_ida.idalegal = g_legal  #FUN-980012 add
   IF g_ida.ida17 IS NULL THEN LET g_ida.ida17=0 END IF #TQC-BA0136
   
   #INSERT INTO ida_file VALUES(g_ida.*)     #FUN-B80119--mark--
   #No.FUN-B80119--start--add---    
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'ida_file'),"(",
                 "ida01,ida02,ida03,ida04,ida05,ida06,ida07,ida08,ida09,ida10,",
                 "ida11,ida12,ida13,ida14,ida15,ida16,ida17,ida18,ida19,ida20,",
                 "ida21,ida22,ida23,ida24,ida25,ida26,ida27,ida28,ida29,ida30,",
                 "ida31,idaplant,idalegal) VALUES",
                 "(?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?,
                   ?,?,?) "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE ins_icd_ida FROM g_sql
   EXECUTE ins_icd_ida USING g_ida.ida01,g_ida.ida02,g_ida.ida03,g_ida.ida04,g_ida.ida05,
                             g_ida.ida06,g_ida.ida07,g_ida.ida08,g_ida.ida09,g_ida.ida10,
                             g_ida.ida11,g_ida.ida12,g_ida.ida13,g_ida.ida14,g_ida.ida15,
                             g_ida.ida16,g_ida.ida17,g_ida.ida18,g_ida.ida19,g_ida.ida20,
                             g_ida.ida21,g_ida.ida22,g_ida.ida23,g_ida.ida24,g_ida.ida25,
                             g_ida.ida26,g_ida.ida27,g_ida.ida28,g_ida.ida29,g_ida.ida30,
                             g_ida.ida31,g_ida.idaplant,g_ida.idalegal
   #No.FUN-B80119---end---add---
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('ins ida',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#No.FUN-B80119--修改為外部傳參--end--- 
#過帳還原
#出入庫別：出庫-1，還原idb_file(insert)
#No.FUN-B80119--修改為外部傳參--start---  
FUNCTION icd_idb(p_idd,p_plant)   #No.FUN-B80119--增加p_idd,p_plant參數--
   #No.FUN-B80119--start--add--- 
   DEFINE p_idd    RECORD LIKE idd_file.*
   DEFINE p_plant  LIKE type_file.chr20    
   #No.FUN-B80119---end---add--- 

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   #No.FUN-B80119--start--add--- 
   IF cl_null(g_imaicd08) THEN 
      CALL icd_imaicd04(p_idd.idd01,p_plant)
   END IF 
   #No.FUN-B80119---end---add---
   #IF g_imaicd08='N' THEN RETURN END IF   #FUN-AA0007 #FUN-BA0051 mark 
   IF NOT s_icdbin(p_idd.idd01) THEN RETURN END IF   #FUN-BA0051
   LET g_plant_new = p_plant              #FUN-B80119--add--
   INITIALIZE g_idb.* TO NULL
   LET g_plant_new = p_plant              #FUN-B80119--add--
   LET g_idb.idb01 = p_idd.idd01
   LET g_idb.idb02 = p_idd.idd02
   LET g_idb.idb03 = p_idd.idd03
   LET g_idb.idb04 = p_idd.idd04
   LET g_idb.idb05 = p_idd.idd05
   LET g_idb.idb06 = p_idd.idd06
   LET g_idb.idb07 = p_idd.idd10
   LET g_idb.idb08 = p_idd.idd11
   LET g_idb.idb09 = p_idd.idd08
   LET g_idb.idb10 = p_idd.idd29
   LET g_idb.idb11 = p_idd.idd13
   LET g_idb.idb12 = p_idd.idd07
   LET g_idb.idb13 = p_idd.idd15
   LET g_idb.idb14 = p_idd.idd16
   LET g_idb.idb15 = p_idd.idd17
   LET g_idb.idb16 = p_idd.idd18
   LET g_idb.idb17 = p_idd.idd19
   LET g_idb.idb18 = p_idd.idd20
   LET g_idb.idb19 = p_idd.idd21
   LET g_idb.idb20 = p_idd.idd22
   LET g_idb.idb21 = p_idd.idd23
   LET g_idb.idb25 = p_idd.idd25

   #FUN-BC0036 --START--
   IF NOT cl_null(p_idd.idd33) OR NOT cl_null(p_idd.idd34) THEN #刻號/BIN調整單    
      LET g_idb.idb05 = p_idd.idd33   
      LET g_idb.idb06 = p_idd.idd34
      LET g_idb.idb26 = p_idd.idd05   
      LET g_idb.idb27 = p_idd.idd06      
   END IF   
   #FUN-BC0036 --END--
    
   #LET g_idb.idbplant = g_plant  #FUN-980012 add #FUN-B80119--mark--
   LET g_idb.idbplant = p_plant  #FUN-980012 add  #FUN-B80119--add---
   LET g_idb.idblegal = g_legal  #FUN-980012 add
   IF g_idb.idb16 IS NULL THEN LET g_idb.idb16=0 END IF #TQC-BA0136
   #INSERT INTO idb_file VALUES(g_idb.*)   #FUN-B80119--mark--
   #No.FUN-B80119--start--add---    
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idb_file'),"(",
                 "idb01,idb02,idb03,idb04,idb05,idb06,idb07,idb08,idb09,idb10,",
                 "idb11,idb12,idb13,idb14,idb15,idb16,idb17,idb18,idb19,idb20,",
                 "idb21,idb22,idb23,idb24,idb25,idb26,idb27,idbplant,idblegal) VALUES",   #FUN-BC0036 add idb26,27
                 "(?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?) "   #FUN-BC0036 add ,?,?
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE ins_icd_idb FROM g_sql
   EXECUTE ins_icd_idb USING g_idb.idb01,g_idb.idb02,g_idb.idb03,g_idb.idb04,g_idb.idb05,
                             g_idb.idb06,g_idb.idb07,g_idb.idb08,g_idb.idb09,g_idb.idb10,
                             g_idb.idb11,g_idb.idb12,g_idb.idb13,g_idb.idb14,g_idb.idb15,
                             g_idb.idb16,g_idb.idb17,g_idb.idb18,g_idb.idb19,g_idb.idb20,
                             g_idb.idb21,g_idb.idb22,g_idb.idb23,g_idb.idb24,g_idb.idb25,
                             g_idb.idb26,g_idb.idb27,   #FUN-BC0036
                             g_idb.idbplant,g_idb.idblegal
   #No.FUN-B80119---end---add---
   
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('ins idb',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
END FUNCTION
#CHI-BB0051 mark (S)
#No.FUN-B80119--修改為外部傳參--end---  
#5.IC出庫，8.IC出通，過帳
#FUNCTION icd_post5(p_plant)     #No.FUN-B80119--增加p_plant參數--
#   DEFINE l_flag      LIKE type_file.chr1
#   DEFINE l_fac       LIKE type_file.num20_6
#   DEFINE l_img09     LIKE img_file.img09   #庫存單位
#   DEFINE l_msg       LIKE type_file.chr1000
#   DEFINE p_plant     LIKE type_file.chr20    #FUN-B80119--add--
#
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
#   LET g_plant_new = p_plant                  #FUN-B80119--add--
#
#   #No.FUN-B80119--start--mark---   
#   # SELECT img09 INTO l_img09 FROM img_file 
#   # WHERE img01 = g_idb01   #料號
#   #   AND img02 = g_idb02   #倉庫
#   #   AND img03 = g_idb03   #儲位
#   #   AND img04 = g_idb04   #批號
#   #No.FUN-B80119---end---mark---
#   #No.FUN-B80119--start--add---
#   LET g_sql = "SELECT img09 FROM ",cl_get_target_table(g_plant_new,'img_file'),
#               " WHERE img01 = '",g_idb01,"' ",  #料號
#               "   AND img02 = '",g_idb02,"' ",  #倉庫
#               "   AND img03 = '",g_idb03,"' ",  #儲位
#               "   AND img04 = '",g_idb04,"' "   #批號
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE icd_post5_pre FROM g_sql
#   DECLARE icd_post5_cs CURSOR FOR icd_post5_pre
#   OPEN icd_post5_cs
#   FETCH icd_post5_cs INTO l_img09
#   #No.FUN-B80119---end---add---
#   
#   IF SQLCA.SQLCODE THEN
#      #No.FUN-B90012--start--add---
#      IF SQLCA.SQLCODE =100 AND g_mflag='Y' THEN  
#         LET g_sql = "SELECT img25 FROM ",cl_get_target_table(g_plant_new,'img_file'),
#                     " WHERE img01 = '",g_idb01,"' ",  #料號
#                     "   AND img02 = '",g_idb02,"' ",  #倉庫
#                     "   AND img03 = '",g_idb03,"' ",  #儲位
#                     "   AND img04 = '",g_idb04,"' "   #批號
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#         PREPARE icd_post5_img25 FROM g_sql
#         EXECUTE icd_post5_img25 INTO l_img09
#      ELSE 
#      #No.FUN-B90012---end---add---
#         CALL cl_err('select img09',SQLCA.SQLCODE,1)
#         LET g_success = 'N' RETURN
#      END IF #No.FUN-B90012--add-- 
#   END IF
#   CALL s_umfchkm(g_idb01,g_idb12,l_img09,p_plant)   #No.FUN-B80119--s_umfchk-->s_umfchkm---
#        RETURNING l_flag,l_fac
#   #無此單位轉換率
#   IF l_flag = 1 THEN
#      LET l_msg = g_idb12 CLIPPED,'->',l_img09 CLIPPED
#      CALL cl_err(l_msg CLIPPED,'aic-907',1)
#      LET g_success = 'N' RETURN
#   END IF
#   LET g_idb11 = g_idb11 * l_fac
#   LET g_idb12 = l_img09         #單位
#   INITIALIZE g_idc.* TO NULL
#   #No.FUN-B80119--start--mark---   
#   #SELECT idc_file.* INTO g_idc.*
#   #   FROM idc_file
#   #  WHERE idc01 = g_idb01  #料號
#   #    AND idc02 = g_idb02  #倉庫
#   #    AND idc03 = g_idb03  #儲位
#   #    AND idc04 = g_idb04  #批號
#   #    AND idc05 = ' '      #刻號
#   #    AND idc06 = ' '      #BIN
#   #No.FUN-B80119---end---mark---
#   #No.FUN-B80119--start--add---
#   LET g_sql = "SELECT idc_file.* FROM ",cl_get_target_table(g_plant_new,'idc_file'),
#               " WHERE idc01 = '",g_idb01,"' ",  #料號
#               "   AND idc02 = '",g_idb02,"' ",  #倉庫
#               "   AND idc03 = '",g_idb03,"' ",  #儲位
#               "   AND idc04 = '",g_idb04,"' ",  #批號
#               "   AND idc05 = ' ' ",            #刻號
#               "   AND idc06 = ' ' "             #BIN
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE icd_post5_1_pre FROM g_sql
#   DECLARE icd_post5_1_cs CURSOR FOR icd_post5_1_pre
#   OPEN icd_post5_1_cs
#   FETCH icd_post5_1_cs INTO g_idc.*
#   #No.FUN-B80119---end---add---
#   
#   IF SQLCA.SQLCODE THEN
#      #No.FUN-B90012--start--add---
#      IF SQLCA.SQLCODE =100 AND g_mflag='Y' THEN  
#         CALL icd_post5_ins_idc(p_plant)
#      ELSE  
#      #No.FUN-B90012---end---add---
#         CALL cl_err('sel img',SQLCA.SQLCODE,1)
#         LET g_success = 'N'
#         RETURN
#      END IF   #No.FUN-B90012--add--
#   END IF
#   LET g_idd15 = ''
#   LET g_idd16 = ''
#   LET g_idd15 = g_idc.idc09
#   LET g_idd16 = g_idc.idc10
#   #出入庫別，IC出通，不需異動idc_file
#   IF g_in_out = 5 THEN 
#      IF g_mflag='N' THEN  #No.FUN-B90012--add--g_mflag--
#         #庫存數量校驗
#         IF (g_idc.idc08-g_idb11) < 0 THEN
#            CALL cl_err('QTY','aic-905',1)
#            LET g_success = 'N' 
#            RETURN
#         END IF
#      END IF    #No.FUN-B90012--add--
#      LET g_idc.idc08 = g_idc.idc08 - g_idb11  #庫存數量-出貨數量
#      LET g_idc.idc12 = g_idc.idc12 - g_idb11  #DIE數-出貨數量
#      #No.FUN-B80119--start--mark--- 
#      #UPDATE idc_file SET idc_file.* = g_idc.*
#      # WHERE idc01 = g_idb01  
#      #   AND idc02 = g_idb02
#      #   AND idc03 = g_idb03
#      #   AND idc04 = g_idb04
#      #   AND idc05 = ' '
#      #   AND idc06 = ' '
#      #No.FUN-B80119---end---mark---
#      #No.FUN-B80119--start--add---    
#      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
#                  "   SET idc01 = ?, idc02 = ?, ",
#                        " idc03 = ?, idc04 = ?, ",
#                        " idc05 = ?, idc06 = ?, ",
#                        " idc07 = ?, idc08 = ?, ",
#                        " idc09 = ?, idc10 = ?, ",
#                        " idc11 = ?, idc12 = ?, ",
#                        " idc13 = ?, idc14 = ?, ",
#                        " idc15 = ?, idc16 = ?, ",
#                        " idc17 = ?, idc18 = ?, ",
#                        " idc19 = ?, idc20 = ?, ",
#                        " idc21 = ?  ",
#                  " WHERE idc01 = '",g_idb01,"' ",
#                  "   AND idc02 = '",g_idb02,"' ",
#                  "   AND idc03 = '",g_idb03,"' ",
#                  "   AND idc04 = '",g_idb04,"' ",
#                  "   AND idc05 = ' ' ",
#                  "   AND idc06 = ' ' "    
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE upd_icd_post5 FROM  g_sql
#      EXECUTE upd_icd_post5 USING g_idc.idc01,g_idc.idc02,g_idc.idc03,g_idc.idc04,g_idc.idc05,g_idc.idc06,g_idc.idc07, 
#                                  g_idc.idc08,g_idc.idc09,g_idc.idc10,g_idc.idc11,g_idc.idc12,g_idc.idc13,g_idc.idc14, 
#                                  g_idc.idc15,g_idc.idc16,g_idc.idc17,g_idc.idc18,g_idc.idc19,g_idc.idc20,g_idc.idc21  
#      #No.FUN-B80119---end---add---
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err('(post:-1)upd img',SQLCA.sqlcode,1) 
#         LET g_success = 'N'
#         RETURN
#      END IF
#   END IF
#  
#   CALL icd_idd_56(p_plant)   #No.FUN-B80119--增加p_plant參數--
#END FUNCTION
##6.IC入庫，7.IC收貨、過帳
#FUNCTION icd_post6(p_plant)   #No.FUN-B80119--增加p_plant參數--
#   DEFINE l_flag      LIKE type_file.chr1
#   DEFINE l_fac       LIKE type_file.num20_6
#   DEFINE l_img09     LIKE img_file.img09
#   DEFINE l_msg       LIKE type_file.chr1000
#   DEFINE l_count     LIKE type_file.num10
#   DEFINE l_ids02     LIKE ids_file.ids02   #FUN-AA0007
#   DEFINE l_ids04     LIKE ids_file.ids04   #FUN-AB0092
#   DEFINE p_plant     LIKE type_file.chr20  #FUN-B80119--add--
#
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
#   LET g_plant_new = p_plant                #FUN-B80119--add--
#   LET g_idd15 = ''   #母體料號
#   LET g_idd16 = ''   #母批
#   #No.FUN-B80119--start--mark---
#   #SELECT idd15,idd16 INTO g_idd15,g_idd16
#   #   FROM idd_file
#   #  WHERE idd10 = g_no
#   #    AND idd11 = g_item
#   #No.FUN-B80119---end---mark---
#   #No.FUN-B80119--start--add---
#   LET g_sql = "SELECT idd15,idd16 FROM ",cl_get_target_table(g_plant_new,'idd_file'),
#               " WHERE idd10 = '",g_no  ,"' ",  
#               "   AND idd11 = '",g_item,"' "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE icd_post6_pre FROM g_sql
#   DECLARE icd_post6_cs CURSOR FOR icd_post6_pre
#   OPEN icd_post6_cs
#   FETCH icd_post6_cs INTO g_idd15,g_idd16
#   #No.FUN-B80119---end---add---
#   #母料編號
#   IF cl_null(g_idd15) THEN
#      #No.FUN-B80119--start--mark---
#      #SELECT ima01 INTO g_idd15
#      #  FROM ima_file
#      # WHERE ima01 = g_idb01
#      #No.FUN-B80119---end---mark---
#      #No.FUN-B80119--start--add---
#      LET g_sql = "SELECT ima01 FROM ",cl_get_target_table(g_plant_new,'ima_file'),
#                  " WHERE ima01 = '",g_idb01,"' "
#        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#        PREPARE icd_post6_1_pre FROM g_sql
#        EXECUTE icd_post6_1_pre INTO g_idd15
#      #No.FUN-B80119---end---add--- 
#   END IF
#   #母批
#   IF cl_null(g_idd16) THEN
#      LET g_idd16 = g_idb14    #庫存批號 #TQC-B80005
#   END IF
#   ##################################
#   LET l_count = 0 
#   #No.FUN-B80119--start--mark---
#   #SELECT count(*) INTO l_count
#   #  FROM rvv_file
#   # WHERE rvv01 = g_idb07   #單據編號
#   #   AND rvv02 = g_idb08   #單據項次
#   #No.FUN-B80119---end---mark---
#   #No.FUN-B80119--start--add---
#   LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'rvv_file'),
#               " WHERE rvv01 = '",g_idb07,"' ",
#               "   AND rvv02 = '",g_idb08,"' "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE icd_post6_2_pre FROM g_sql
#   EXECUTE icd_post6_2_pre INTO l_count
#   #No.FUN-B80119---end---add---
#   IF l_count > 0 THEN
#      #No.FUN-B80119--start--mark---
#      #SELECT rvviicd02 INTO g_idd17    #DATECODE
#      #   FROM rvvi_file
#      #WHERE rvvi01 = g_idb07
#      #   AND rvvi02 = g_idb08
#      #No.FUN-B80119--start--mark---
#      #No.FUN-B80119--start--add---
#      LET g_sql = "SELECT rvviicd02 FROM ",cl_get_target_table(g_plant_new,'rvvi_file'),
#                  " WHERE rvvi01 = '",g_idb07,"' ",
#                  "   AND rvvi02 = '",g_idb08,"' "
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE icd_post6_3_pre FROM g_sql
#      EXECUTE icd_post6_3_pre INTO g_idd17
#      #No.FUN-B80119---end---add---
#   END IF 
#   ########################################## 
#   #No.FUN-B80119--start--mark---
#   #SELECT img09 INTO l_img09 FROM img_file 
#   # WHERE img01 = g_idb01
#   #   AND img02 = g_idb02
#   #   AND img03 = g_idb03
#   #   AND img04 = g_idb04
#   #No.FUN-B80119--start--mark---
#   #No.FUN-B80119--start--add---
#   LET g_sql = "SELECT img09 FROM ",cl_get_target_table(g_plant_new,'img_file'),
#            " WHERE img01 = '",g_idb01,"' ",
#            "   AND img02 = '",g_idb02,"' ",
#            "   AND img03 = '",g_idb03,"' ",
#            "   AND img04 = '",g_idb04,"' "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE icd_post6_4_pre FROM g_sql
#   EXECUTE icd_post6_4_pre INTO l_img09
#   #No.FUN-B80119---end---add---
#   IF SQLCA.SQLCODE THEN
#      #No.FUN-B90012--start--add---
#      IF SQLCA.SQLCODE =100 AND g_mflag='Y' THEN  
#         LET g_sql = "SELECT img25 FROM ",cl_get_target_table(g_plant_new,'img_file'),
#                     " WHERE img01 = '",g_idb01,"' ",  #料號
#                     "   AND img02 = '",g_idb02,"' ",  #倉庫
#                     "   AND img03 = '",g_idb03,"' ",  #儲位
#                     "   AND img04 = '",g_idb04,"' "   #批號
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#         PREPARE icd_post6_img25 FROM g_sql
#         EXECUTE icd_post6_img25 INTO l_img09
#      ELSE 
#      #No.FUN-B90012---end---add---
#         CALL cl_err('select img09',SQLCA.SQLCODE,1)
#         LET g_success = 'N' RETURN
#      END IF  #No.FUN-B90012--add--
#   END IF
#   CALL s_umfchkm(g_idb01,g_idb12,l_img09,p_plant)  #No.FUN-B80119--s_umfchk-->s_umfchkm---
#        RETURNING l_flag,l_fac
#   IF l_flag = 1 THEN
#      LET l_msg = g_idb12 CLIPPED,'->',l_img09 CLIPPED
#      CALL cl_err(l_msg CLIPPED,'aic-907',1)
#      LET g_success = 'N' 
#      RETURN
#   END IF
#   LET g_idb11 = g_idb11 * l_fac
#   LET g_idb12 = l_img09
# 
#   INITIALIZE g_idc.* TO NULL
#   #出入庫別，7.收貨，不需異動idc_file
#   IF g_in_out = 6 THEN
#      LET g_idc.idc01 = g_idb01
#      LET g_idc.idc02 = g_idb02
#      LET g_idc.idc03 = g_idb03
#      LET g_idc.idc04 = g_idb04
#      LET g_idc.idc05 = ' '
#      LET g_idc.idc06 = ' '                    #BIN
#      LET g_idc.idc07 = g_idb12
#      LET g_idc.idc08 = g_idb11
#      LET g_idc.idc09 = g_idd15
#      LET g_idc.idc10 = g_idd16
#      LET g_idc.idc11 = g_idd17            #DATECODE
#      LET g_idc.idc12 = g_idb11          
#      LET g_idc.idc13 = g_idd19	      #YIELD
#      LET g_idc.idc14 = NULL                   #TEST #
#      LET g_idc.idc15 = NULL                   #DEDUCT
#      LET g_idc.idc16 = NULL                   #PASS BIN
#      LET g_idc.idc19 = g_idd23
#      LET g_idc.idc20 = NULL
#      LET g_idc.idc21 = 0
#      LET g_idc.idc17 = 'N'  
#      #異動idc_file,判斷不存在INSERT，否則UPDATE
#      #No.FUN-B80119--start--mark---
#      #SELECT * FROM idc_file
#      #   WHERE idc01 = g_idb01
#      #     AND idc02 = g_idb02
#      #     AND idc03 = g_idb03
#      #     AND idc04 = g_idb04
#      #     AND idc05 = ' '
#      #     AND idc06 = ' '                    #BIN
#      #No.FUN-B80119--start--mark---
#      #No.FUN-B80119--start--add---
#      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'idc_file'),
#                  " WHERE idc01 = '",g_idb01,"' ",
#                  "   AND idc02 = '",g_idb02,"' ",
#                  "   AND idc03 = '",g_idb03,"' ",
#                  "   AND idc04 = '",g_idb04,"' ",
#                  "   AND idc05 = ' ' ",
#                  "   AND idc06 = ' ' "
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE icd_post6_5_pre FROM g_sql
#      EXECUTE icd_post6_5_pre
#      #No.FUN-B80119---end---add---
#      IF SQLCA.SQLCODE = 100 THEN             #insert
#         #FUN-AA0007--begin--modify-------------------------
#         LET g_idc.idc17 = 'N'
#         #SELECT ids02,ids04 INTO l_ids02,l_ids04 FROM ids_file WHERE ids01=g_idb04 AND idsacti='Y'  #FUN-AB0092  #FUN-B80119--mark--
#         #No.FUN-B80119--start--add---
#         LET g_sql = "SELECT ids02,ids04 FROM ",cl_get_target_table(g_plant_new,'ids_file'),
#                     " WHERE ids01= '",g_idb04,"' AND idsacti='Y' "
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#         PREPARE icd_post6_6_pre FROM g_sql
#         DECLARE icd_post6_6_cs CURSOR FOR icd_post6_6_pre
#         OPEN icd_post6_6_cs
#         FETCH icd_post6_6_cs INTO l_ids02,l_ids04
#         #No.FUN-B80119---end---add---
#         IF l_ids02='1' THEN LET g_idc.idc17='Y' END IF
#         IF l_ids02='2' THEN
#           #LET g_idc.idc18='Y'      #FUN-AB0092
#            LET g_idc.idc18=l_ids04  #FUN-AB0092
#         ELSE
#            LET g_idc.idc18='N'
#         END IF
#         #FUN-AA0007--end--modify---------------------------
#         #INSERT INTO idc_file VALUES (g_idc.*)   #FUN-B80119--mark--
#         IF g_idc.idc12 IS NULL THEN LET g_idc.idc12=0 END IF #TQC-BA0136         
#         #No.FUN-B80119--start--add---    
#         LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idc_file'),"(",
#                        "idc01,idc02,idc03,idc04,idc05,idc06,idc07,idc08,idc09,idc10,",
#                        "idc11,idc12,idc13,idc14,idc15,idc16,idc17,idc18,idc19,idc20,",
#                        "idc21) VALUES",
#                        "(?,?,?,?,?,?,?,?,?,?,
#                          ?,?,?,?,?,?,?,?,?,?,
#                          ?) "
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#         PREPARE ins_icd_post6 FROM g_sql
#         EXECUTE ins_icd_post6 USING g_idc.idc01,g_idc.idc02,g_idc.idc03,g_idc.idc04,g_idc.idc05,g_idc.idc06,g_idc.idc07, 
#                                     g_idc.idc08,g_idc.idc09,g_idc.idc10,g_idc.idc11,g_idc.idc12,g_idc.idc13,g_idc.idc14, 
#                                     g_idc.idc15,g_idc.idc16,g_idc.idc17,g_idc.idc18,g_idc.idc19,g_idc.idc20,g_idc.idc21  
#         #No.FUN-B80119---end---add---
#         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('ins idc_file',SQLCA.SQLCODE,1)
#            LET g_success = 'N' 
#            RETURN
#         END IF
#         #FUN-B30187 --START--
#         IF NOT icd_ins_idt(g_idc.idc10,g_idc.idc04,p_plant) THEN   #No.FUN-B80119--增加p_plant參數--
#            LET g_success = 'N'
#            RETURN
#         END IF
#         #FUN-B30187 --END--
#      ELSE                   #update
#         #No.FUN-B80119--start--mark---
#         #UPDATE idc_file SET idc08 = idc08 + g_idc.idc08,
#         #                    idc12 = idc12 + g_idc.idc12
#         #   WHERE idc01 = g_idb01
#         #     AND idc02 = g_idb02
#         #     AND idc03 = g_idb03
#         #     AND idc04 = g_idb04
#         #     AND idc05 = ' '
#         #     AND idc06 = ' '
#         #No.FUN-B80119---end---mark---
#         IF g_idc.idc12 IS NULL THEN LET g_idc.idc12=0 END IF #TQC-BA0136
#         #No.FUN-B80119--start--add---    
#         LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
#                     "   SET idc08 = idc08 + ",g_idc.idc08 ,",",
#                     "       idc12 = idc12 + ",g_idc.idc12 ," ",
#                     " WHERE idc01 = '",g_idb01,"' ",
#                     "   AND idc02 = '",g_idb02,"' ",
#                     "   AND idc03 = '",g_idb03,"' ",
#                     "   AND idc04 = '",g_idb04,"' ",
#                     "   AND idc05 = ' ' ",
#                     "   AND idc06 = ' ' "    
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#         PREPARE upd_icd_post6 FROM g_sql
#         EXECUTE upd_icd_post6
#         #No.FUN-B80119---end---add---
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#            CALL cl_err('(post:1)upd img',SQLCA.sqlcode,1)
#            LET g_success = 'N'
#            RETURN
#         END IF
#         #FUN-B30187 --START--
#         IF NOT icd_ins_idt(g_ida.ida15,g_idc.idc04,p_plant) THEN  #No.FUN-B80119--增加p_plant參數--
#            LET g_success = 'N'
#            RETURN
#         END IF
#         #FUN-B30187 --END--
#      END IF
#   END IF
#   CALL icd_idd_56(p_plant)    #No.FUN-B80119--增加p_plant參數--
#END FUNCTION
#CHI-BB0051 mark (E)

#CHI-BB0051 mark (S)
##5.IC出庫,8.IC出通貨、過帳還原
#FUNCTION icd_unpost5(p_plant)  #No.FUN-B80119--增加p_plant參數--
#   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--
#
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
#   LET g_plant_new = p_plant              #FUN-B80119--add--
#   IF g_in_out = 5 THEN  
#      INITIALIZE g_idd.* TO NULL
#      #No.FUN-B80119--start--mark---
#      #SELECT * INTO g_idd.* FROM idd_file
#      # WHERE idd01 = g_idb01
#      #   AND idd02 = g_idb02
#      #   AND idd03 = g_idb03
#      #   AND idd04 = g_idb04
#      #   AND idd05 = ' '
#      #   AND idd06 = ' '
#      #   AND idd10 = g_idb07
#      #   AND idd11 = g_idb08
#      #   AND idd12 = g_in_out
#      #No.FUN-B80119---end---mark---
#      #No.FUN-B80119--start--add---
#      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'idd_file'),
#                  " WHERE idd01 = '",g_idb01,"' ",  
#                  "   AND idd02 = '",g_idb02,"' ",  
#                  "   AND idd03 = '",g_idb03,"' ",  
#                  "   AND idd04 = '",g_idb04,"' ",  
#                  "   AND idd05 = ' ' ",            
#                  "   AND idd06 = ' ' ",             
#                    " AND idd10 = '",g_idb07,"' ",  
#                    " AND idd11 = '",g_idb08,"' ",
#                    " AND idd12 = ",g_in_out," "     #FUN-B40081
#                    #" AND idd12 = '",g_in_out,"' "  #FUN-B40081 mark
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE icd_unpost5_pre FROM g_sql
#      DECLARE icd_unpost5_cs CURSOR FOR icd_unpost5_pre
#      OPEN icd_unpost5_cs
#      FETCH icd_unpost5_cs INTO g_idd.*
#      #No.FUN-B80119---end---add---
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err('sel idd',SQLCA.SQLCODE,1)
#         LET g_success = 'N' 
#         RETURN
#      END IF
#      #還原庫存數量，含本次出貨（加回來）
#      #No.FUN-B80119--start--mark---
#      #UPDATE idc_file SET idc08 = idc08 + g_idd.idd13,
#      #                       idc12 = idc12 + g_idd.idd18
#      #  WHERE idc01 = g_idb01
#      #    AND idc02 = g_idb02
#      #    AND idc03 = g_idb03
#      #    AND idc04 = g_idb04
#      #    AND idc05 = ' '
#      #    AND idc06 = ' '
#      #No.FUN-B80119---end---mark---
#      IF g_idd.idd18 IS NULL THEN LET g_idd.idd18=0 END IF #TQC-BA0136
#      #No.FUN-B80119--start--add---    
#      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
#                  "   SET idc08 = idc08 + ",g_idd.idd13 ,",",
#                  "       idc12 = idc12 + ",g_idd.idd18 ," ",
#                  " WHERE idc01 = '",g_idb01,"' ",
#                  "   AND idc02 = '",g_idb02,"' ",
#                  "   AND idc03 = '",g_idb03,"' ",
#                  "   AND idc04 = '",g_idb04,"' ",
#                  "   AND idc05 = ' ' ",
#                  "   AND idc06 = ' ' "    
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE upd_icd_unpost5 FROM g_sql
#      EXECUTE upd_icd_unpost5
#      #No.FUN-B80119---end---add---
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('(-1)unpost img',SQLCA.SQLCODE,1)
#         LET g_success = 'N'
#         RETURN
#      END IF
#   END IF 
#   CALL icd_idd_del_56(p_plant)  #No.FUN-B80119--增加p_plant參數-- #FUN-B40081 mark
#   CALL icd_idd_del_56_multi(p_plant)  #FUN-B40081
#END FUNCTION
##6.IC入庫，7.IC收貨 過帳還原
#FUNCTION icd_unpost6(p_plant)    #No.FUN-B80119--增加p_plant參數--
#   DEFINE l_idc08 LIKE idc_file.idc08
#   DEFINE l_msg   LIKE type_file.chr1000
#   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--
#
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
#   LET g_plant_new = p_plant              #FUN-B80119--add--
#   INITIALIZE g_idc.* TO NULL
# 
#   IF g_in_out = 6 THEN
#      INITIALIZE g_idd.* TO NULL
#      #No.FUN-B80119--start--mark---
#      #SELECT * INTO g_idd.* FROM idd_file
#      # WHERE idd01 = g_idb01
#      #   AND idd02 = g_idb02
#      #   AND idd03 = g_idb03
#      #   AND idd04 = g_idb04
#      #   AND idd05 = ' '
#      #   AND idd06 = ' '
#      #   AND idd10 = g_idb07
#      #   AND idd11 = g_idb08
#      #   AND idd12 = g_in_out
#      #No.FUN-B80119---end---mark---
#      #No.FUN-B80119--start--add---
#      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'idd_file'),
#                  " WHERE idd01 = '",g_idb01,"' ",  
#                  "   AND idd02 = '",g_idb02,"' ",  
#                  "   AND idd03 = '",g_idb03,"' ",  
#                  "   AND idd04 = '",g_idb04,"' ",  
#                  "   AND idd05 = ' ' ",            
#                  "   AND idd06 = ' ' ",             
#                  "   AND idd10 = '",g_idb07,"' ",  
#                  "   AND idd11 = '",g_idb08,"' ",
#                  "   AND idd12 = '",g_in_out,"' "  
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE icd_unpost6_pre FROM g_sql
#      DECLARE icd_unpost6_cs CURSOR FOR icd_unpost6_pre
#      OPEN icd_unpost6_cs
#      FETCH icd_unpost6_cs INTO g_idd.*
#      #No.FUN-B80119---end---add---
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err('sel idd',SQLCA.SQLCODE,1)
#         LET g_success = 'N' 
#         RETURN
#      END IF
#      #檢查庫存是否夠做過帳還原
#      LET l_idc08 = 0 
#      #No.FUN-B80119--start--mark---
#      #SELECT idc08 INTO l_idc08
#      #  FROM idc_file
#      # WHERE idc01 = g_idb01
#      #   AND idc02 = g_idb02
#      #   AND idc03 = g_idb03
#      #   AND idc04 = g_idb04
#      #   AND idc05 = ' '
#      #   AND idc06 = ' '
#      #No.FUN-B80119---end---mark---
#      #No.FUN-B80119--start--add---
#      LET g_sql = "SELECT idc08 FROM ",cl_get_target_table(g_plant_new,'idc_file'),
#                  " WHERE idc01 = '",g_idb01,"' ",  
#                  "   AND idc02 = '",g_idb02,"' ",  
#                  "   AND idc03 = '",g_idb03,"' ",  
#                  "   AND idc04 = '",g_idb04,"' ",  
#                  "   AND idc05 = ' ' ",            
#                  "   AND idc06 = ' ' "
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE icd_unpost6_1_pre FROM g_sql
#      EXECUTE icd_unpost6_1_pre INTO l_idc08
#      #No.FUN-B80119---end---add---
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err('sel img(qty)',SQLCA.SQLCODE,1)
#         LET g_success = 'N'
#         RETURN
#      END IF
#      #庫存不夠
#      IF g_mflag <> 'Y' THEN    #FUN-B90012--add--
#         IF (l_idc08 - g_idd.idd13) < 0 THEN
#            LET l_msg = "[LineNO:",g_idb08 USING '<<<<<',",",
#                        " PartNO:",g_idb01,")"
#            CALL cl_err(l_msg,'aic-903',1)
#            LET g_success = 'N'
#            RETURN
#         END IF
#      END IF                    #FUN-B90012--add--
#      #庫存夠，還原庫存數量（扣掉）
#      #No.FUN-B80119--start--mark---
#      #UPDATE idc_file SET idc08 = idc08 - g_idd.idd13,
#      #                    idc12 = idc12 - g_idd.idd18
#      # WHERE idc01 = g_idb01     
#      #   AND idc02 = g_idb02 
#      #   AND idc03 = g_idb03 
#      #   AND idc04 = g_idb04
#      #   AND idc05 = ' ' 
#      #   AND idc06 = ' '                 #BIN
#      #No.FUN-B80119---end---mark---
#      IF g_idd.idd18 IS NULL THEN LET g_idd.idd18=0 END IF #TQC-BA0136
#      #No.FUN-B80119--start--add---  
#      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
#                  "   SET idc08 = idc08 - ",g_idd.idd13 ,",",
#                  "       idc12 = idc12 - ",g_idd.idd18 ," ",
#                  " WHERE idc01 = '",g_idb01,"' ",
#                  "   AND idc02 = '",g_idb02,"' ",
#                  "   AND idc03 = '",g_idb03,"' ",
#                  "   AND idc04 = '",g_idb04,"' ",
#                  "   AND idc05 = ' ' ",
#                  "   AND idc06 = ' ' "    
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE upd_icd_unpost6 FROM g_sql
#      EXECUTE upd_icd_unpost6
#      #No.FUN-B80119---end---add---
#      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('(1)unpost img',SQLCA.SQLCODE,1)
#         LET g_success = 'N'
#         RETURN 
#      END IF
#      #過帳還原，若已無庫存，則刪除idc_file中的資料
#      LET l_idc08 = 0 
#      #No.FUN-B80119--start--mark---
#      #SELECT idc08 INTO l_idc08 
#      #   FROM idc_file
#      #  WHERE idc01 = g_idb01
#      #    AND idc02 = g_idb02
#      #    AND idc03 = g_idb03
#      #    AND idc04 = g_idb04
#      #    AND idc05 = ' '
#      #    AND idc06 = ' '                 #BIN
#      #No.FUN-B80119---end---mark---
#      #No.FUN-B80119--start--add---
#      LET g_sql = "SELECT idc08 FROM ",cl_get_target_table(g_plant_new,'idc_file'),
#                  " WHERE idc01 = '",g_idb01,"' ",  
#                  "   AND idc02 = '",g_idb02,"' ",  
#                  "   AND idc03 = '",g_idb03,"' ",  
#                  "   AND idc04 = '",g_idb04,"' ",  
#                  "   AND idc05 = ' ' ",            
#                  "   AND idc06 = ' ' "
#      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#      PREPARE icd_unpost6_2_pre FROM g_sql
#      EXECUTE icd_unpost6_2_pre INTO l_idc08
#      #No.FUN-B80119---end---add---
#      IF l_idc08 = 0 THEN
#         #No.FUN-B80119--start--mark---
#         #DELETE FROM idc_file
#         #   WHERE idc01 = g_idb01
#         #     AND idc02 = g_idb02
#         #     AND idc03 = g_idb03
#         #     AND idc04 = g_idb04
#         #     AND idc05 = ' '
#         #     AND idc06 = ' '            #BIN
#         #No.FUN-B80119---end---mark---
#         #No.FUN-B80119--start--add---    
#         LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'idc_file'),
#                     " WHERE idc01 = '",g_idb01,"' ",
#                     "   AND idc02 = '",g_idb02,"' ",
#                     "   AND idc03 = '",g_idb03,"' ",
#                     "   AND idc04 = '",g_idb04,"' ",
#                     "   AND idc05 = ' ' ",
#                     "   AND idc06 = ' ' "
#         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#         PREPARE del_icd_unpost6 FROM g_sql
#         EXECUTE del_icd_unpost6
#         #No.FUN-B80119---end---add---
#      END IF
#   END IF
#   CALL icd_idd_del_56(p_plant)   #No.FUN-B80119--增加p_plant參數--
#END FUNCTION
##過帳：產生idd_file
#FUNCTION icd_idd_56(p_plant)      #No.FUN-B80119--增加p_plant參數--
#   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--
#
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
#   LET g_plant_new = p_plant              #FUN-B80119--add--
#   INITIALIZE g_idd.* TO NULL
#   LET g_idd.idd01 = g_idb01
#   LET g_idd.idd02 = g_idb02
#   LET g_idd.idd03 = g_idb03
#   LET g_idd.idd04 = g_idb04
#   LET g_idd.idd05 = ' '
#   LET g_idd.idd06 = ' '                    #BIn
# 
#   LET g_idd.idd07 = g_idb12
#   LET g_idd.idd08 = g_idb09
#   LET g_idd.idd09 = g_today
#   LET g_idd.idd10 = g_idb07
#   LET g_idd.idd11 = g_idb08
#   LET g_idd.idd12 = g_in_out
#   LET g_idd.idd13 = g_idb11
#   LET g_idd.idd14 = ' '
#   LET g_idd.idd15 = g_idd15
#   LET g_idd.idd16 = g_idd16
#   LET g_idd.idd17 = g_idd17            #DATECODE
#   LET g_idd.idd18 = g_idb11 
#   LET g_idd.idd19 = g_idd19            #YIELD
#   LET g_idd.idd20 = NULL                   #TEST #
#   LET g_idd.idd21 = NULL                   #DEDUCT
#   LET g_idd.idd22 = NULL                   #PASS BIN
#   LET g_idd.idd23 = g_idd23
#   LET g_idd.idd25 = NULL
#   LET g_idd.idd26 = 0 
#   LET g_idd.idd27 = 0 
#   LET g_idd.idd28 = 'N'
#   LET g_idd.idd32='N'  #FUN-AA0007
#   #LET g_idd.iddplant = g_plant  #FUN-980012 add  #FUN-B80119--mark--
#   LET g_idd.iddplant = p_plant  #FUN-980012 add   #FUN-B80119--add---
#   LET g_idd.iddlegal = g_legal  #FUN-980012 add
#   IF g_idd.idd18 IS NULL THEN LET g_idd.idd18=0 END IF #TQC-BA0136
#   #-->insert idd_file
#   #INSERT INTO idd_file VALUES(g_idd.*)   #FUN-B80119--mark--
#   #No.FUN-B80119--start--add---    
#   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idd_file'),"(",
#                 "idd01,idd02,idd03,idd04,idd05,idd06,idd07,idd08,idd09,idd10,",
#                 "idd11,idd12,idd13,idd14,idd15,idd16,idd17,idd18,idd19,idd20,",
#                 "idd21,idd22,idd23,idd24,idd25,idd26,idd27,idd28,idd29,idd30,",
#                 "idd31,iddplant,iddlegal,idd32) VALUES",
#                 "(?,?,?,?,?,?,?,?,?,?,
#                   ?,?,?,?,?,?,?,?,?,?,
#                   ?,?,?,?,?,?,?,?,?,?,
#                   ?,?,?,?) "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE ins_icd_idd_56 FROM g_sql
#   EXECUTE ins_icd_idd_56 USING g_idd.idd01,g_idd.idd02,g_idd.idd03,g_idd.idd04,g_idd.idd05,
#                                g_idd.idd06,g_idd.idd07,g_idd.idd08,g_idd.idd09,g_idd.idd10, 
#                                g_idd.idd11,g_idd.idd12,g_idd.idd13,g_idd.idd14,g_idd.idd15,
#                                g_idd.idd16,g_idd.idd17,g_idd.idd18,g_idd.idd19,g_idd.idd20,  
#                                g_idd.idd21,g_idd.idd22,g_idd.idd23,g_idd.idd24,g_idd.idd25,
#                                g_idd.idd26,g_idd.idd27,g_idd.idd28,g_idd.idd29,g_idd.idd30,
#                                g_idd.idd31,g_idd.iddplant,g_idd.iddlegal,g_idd.idd32
#   #No.FUN-B80119---end---add---
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('ins idd_file',SQLCA.sqlcode,1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#END FUNCTION
# 
##過帳還原：刪除idd_file中相應的資料
#FUNCTION icd_idd_del_56(p_plant)          #No.FUN-B80119--增加p_plant參數--
#   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--
#
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
#   LET g_plant_new = p_plant              #FUN-B80119--add--
#   #No.FUN-B80119--start--mark---
#   #DELETE FROM idd_file 
#   # WHERE idd10 = g_idb07
#   #   AND idd11 = g_idb08 
#   #   AND idd12 = g_in_out
#   #No.FUN-B80119---end---mark---
#   #No.FUN-B80119--start--add---    
#   LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'idd_file'),
#               " WHERE idd10 = '",g_idb07,"' ",
#               "   AND idd11 = '",g_idb08,"' ",
#               "   AND idd12 = '",g_in_out,"' "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE del_icd_idd_del_56 FROM g_sql
#   EXECUTE del_icd_idd_del_56
#   #No.FUN-B80119---end---add---
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('del idd_file',SQLCA.sqlcode,1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#END FUNCTION
#
##FUN-B40081 --END--
##過帳還原：刪除idd_file中相應的資料(多倉儲)
#FUNCTION icd_idd_del_56_multi(p_plant)          
#   DEFINE p_plant LIKE type_file.chr20    
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  
#   LET g_plant_new = p_plant              #FUN-B80119--add--      
#   LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'idd_file'),
#               " WHERE idd01 = '",g_idb01,"' ",
#               "   AND idd02 = '",g_idb02,"' ",
#               "   AND idd03 = '",g_idb03,"' ",
#               "   AND idd04 = '",g_idb04,"' ",
#               "   AND idd10 = '",g_idb07,"' ",
#               "   AND idd11 = '",g_idb08,"' ",
#               "   AND idd12 = ",g_in_out," "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE del_icd_idd_del_56_multi FROM g_sql
#   EXECUTE del_icd_idd_del_56_multi
#   #No.FUN-B80119---end---add---
# 
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_err('del idd_file',SQLCA.sqlcode,1)
#      LET g_success = 'N'
#      RETURN
#   END IF
#END FUNCTION
##FUN-B40081 --END--
#CHI-BB0051 mark (E)

#若料號的庫存狀態(idc17)為Y，不允許出庫
FUNCTION icd_out_chk(p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE l_idc17 LIKE idc_file.idc17
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--
   LET l_idc17 = ' '
   #No.FUN-B80119--start--mark---
   #SELECT idc17 INTO l_idc17
   #       FROM idc_file
   #      WHERE idc01 = g_idb01
   #        AND idc02 = g_idb02
   #        AND idc03 = g_idb03
   #        AND idc04 = g_idb04
   #        AND idc05 = g_idb.idb05
   #        AND idc06 = g_idb.idb06 
   #No.FUN-B80119---end---mark---
   #No.FUN-B80119--start--add---
   LET g_sql = "SELECT idc17 FROM ",cl_get_target_table(g_plant_new,'idc_file'),
               " WHERE idc01 = '",g_idb01,"' ",  
               "   AND idc02 = '",g_idb02,"' ",  
               "   AND idc03 = '",g_idb03,"' ",  
               "   AND idc04 = '",g_idb04,"' ",  
               "   AND idc05 = '",g_idb.idb05,"' ",
               "   AND idc06 = '",g_idb.idb06,"' "   
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_out_chk_pre FROM g_sql
   EXECUTE icd_out_chk_pre INTO l_idc17
   #No.FUN-B80119---end---add---
   IF l_idc17 = 'Y' THEN
      CALL cl_err('chk Hold:','aic-902',1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION 

#CHI-BB0051 mark (S) #未使用故mark
#FUNCTION cs_icdpost_wo(p_plant)   #No.FUN-B80119--增加p_plant參數--
#   DEFINE l_sfv11  LIKE sfv_file.sfv11
#   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--
#
#   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
#   LET g_plant_new = p_plant              #FUN-B80119--add--
#   
#   LET g_idd17 = '' 
#   LET g_idd23 = '' 
#   LET g_idd19 = 0  
# 
#   LET l_sfv11 = '' 
#   #No.FUN-B80119--start--mark---
#   #SELECT sfv11 INTO l_sfv11 
#   #   FROM sfu_file,sfv_file
#   #WHERE sfu01 = g_idb07
#   #    AND sfv03 = g_idb08 
#   #    AND sfu01 = sfv01
#   #No.FUN-B80119---end---mark---
#   #No.FUN-B80119--start--add---
#   LET g_sql = "SELECT sfv11 FROM ",cl_get_target_table(g_plant_new,'sfu_file'),
#                                ",",cl_get_target_table(g_plant_new,'sfv_file'),
#               " WHERE sfu01 = '",g_idb07,"' ",  
#               "   AND sfv03 = '",g_idb08,"' ",  
#               "   AND sfu01 = sfv01  "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE cs_icdpost_wo_pre FROM g_sql
#   EXECUTE cs_icdpost_wo_pre INTO l_sfv11
#   #No.FUN-B80119---end---add---
#   IF SQLCA.SQLCODE THEN
#      RETURN
#   END IF
#   IF (l_sfv11 != g_no) OR g_item != 0 THEN
#      RETURN
#   END IF
#
#   #No.FUN-B80119--start--mark---
#   #SELECT sfbiicd14,sfbiicd07,sfbiicd08
#   #  INTO g_idd15,g_idd17,g_idd23
#   #   FROM sfbi_file 
#   #  WHERE sfbi01 = l_sfv11 
#   #No.FUN-B80119---end---mark---
#   #No.FUN-B80119--start--add---
#   LET g_sql = "SELECT sfbiicd14,sfbiicd07,sfbiicd08 FROM ",cl_get_target_table(g_plant_new,'sfbi_file'),
#               " WHERE sfbi01= '",l_sfv11,"' "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE cs_icdpost_wo1_pre FROM g_sql
#   DECLARE cs_icdpost_wo1_cs CURSOR FOR cs_icdpost_wo1_pre
#   OPEN cs_icdpost_wo1_cs
#   FETCH cs_icdpost_wo1_cs INTO g_idd15,g_idd17,g_idd23
#   #No.FUN-B80119---end---add--
#
#   #No.FUN-B80119--start--mark---
#   #DECLARE lot_dec CURSOR FOR
#   #   SELECT sfe10 FROM sfe_file
#   #      WHERE sfe01 = l_sfv11
#   #        AND sfe06 IN ('1','2','3') 
#   #     ORDER BY sfe04 DESC
#   #No.FUN-B80119---end---mark---
#   #No.FUN-B80119--start--add---
#   LET g_sql = "SELECT sfe10 FROM ",cl_get_target_table(g_plant_new,'sfe_file'),
#               " WHERE sfe01= '",l_sfv11,"' ",
#               "   AND sfe06 IN ('1','2','3') ",
#               "   ORDER BY sfe04 DESC "
#   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
#   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
#   PREPARE lot_dec_pre FROM g_sql
#   DECLARE lot_dec CURSOR FOR lot_dec_pre
#   #No.FUN-B80119---end---add--
#   OPEN lot_dec
#   FETCH lot_dec INTO g_idd16    
#   CLOSE lot_dec
#   IF cl_null(g_idd16) THEN
#      LET g_idd16 = g_idb14 #TQC-B80005   
#   END IF
#END FUNCTION 
#CHI-BB0051 mark (E)
#檢查出入庫的總數是否等于傳入的數量(p_idb11-->出貨數量)
#返回1表示成功，0表示失敗
FUNCTION s_icdchk(p_in_out,p_idb01,p_idb02,p_idb03,
                   p_idb04,p_idb11,p_idb07,
                   #p_idb08,p_idb09)          #FUN-B80119--mark--
                   p_idb08,p_idb09,p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE p_in_out      LIKE type_file.num10,       #出入庫別
          p_idb01 LIKE idb_file.idb01, #料件編號
          p_idb02 LIKE idb_file.idb02, #倉庫
          p_idb03 LIKE idb_file.idb03, #儲位
          p_idb04 LIKE idb_file.idb04, #批號
          p_idb11 LIKE idb_file.idb11, #數量
          p_idb07 LIKE idb_file.idb07, #單據編號
          p_idb08 LIKE idb_file.idb08, #單據項次
          p_idb09 LIKE idb_file.idb09  #單據日期
   DEFINE l_out           LIKE type_file.num20_6
   DEFINE l_n             LIKE type_file.num10
   DEFINE l_msg           LIKE type_file.chr1000
   DEFINE p_plant         LIKE type_file.chr20    #FUN-B80119--add--
   DEFINE l_idb11_sum_str STRING   #FUN-B30183 
   DEFINE l_idb11_str     STRING   #FUN-B30183 
   DEFINE l_imaicd04      LIKE imaicd_file.imaicd04  #料件狀態   #TQC-C50062 add

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--
   
   WHENEVER ERROR CALL cl_err_msg_log

   #MOD-C30527---begin
   IF cl_null(p_idb02) THEN 
      CALL cl_err('','apm1033',0)
   END IF 
   #MOD-C30527---end
   #傳入的資料不可以為NULL
   IF cl_null(p_in_out) OR
      #cl_null(p_idb01) OR cl_null(p_idb02) OR   #MOD-C30527
      cl_null(p_idb01) OR                        #MOD-C30527
      cl_null(p_idb11) OR cl_null(p_idb07) OR 
      cl_null(p_idb08) OR cl_null(p_idb09) THEN 
      #CALL cl_err('cs_icdchk()','aic-908',1)  #MOD-C30527
      CALL cl_err('','aic-908',1)              #MOD-C30527
      RETURN 0
   END IF
 
   #CHK傳入的p_in_out是否合理
   IF NOT (p_in_out = 0 OR p_in_out = 1 OR p_in_out = -1 OR p_in_out = 2) THEN
      CALL cl_err('p_in_out <> 0/1/-1/2','!',1)
      RETURN 0
   END IF
 
   IF cl_null(p_idb03) THEN
      LET p_idb03 = ' '   #儲位
   END IF
   IF cl_null(p_idb04) THEN
      LET p_idb04 = ' '   #批號
   END IF
   SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file  #TQC-C50062 add
    WHERE imaicd00 = p_idb01                         #TQC-C50062 add

   #檢查出入庫的總數是否等于傳入的數量(p_idb11-->出貨數量)
   #檢查idb_file中的出貨數量總和SUM(idb11-->出貨數量)是否等于p_idb11
   LET g_idb11_sum = 0
    #出入庫別(p_in_out):入庫(1),其它入(0),出庫(-1),其它出(2)
   IF p_in_out = 1 OR p_in_out = 0 THEN   
     #str TQC-C50062 mod
     #LET g_sql = "SELECT SUM(ida10) ",            #實收數量
      IF l_imaicd04 = '2' THEN
         LET g_sql = "SELECT SUM(ida10)+SUM(ida11) " #實收數量
      ELSE
         LET g_sql = "SELECT SUM(ida10) "            #實收數量
      END IF
     #end TQC-C50062 mod
      LET g_sql = g_sql CLIPPED,                                          #TQC-C50062 add
                  #"  FROM ida_file ",                                    #FUN-B80119--mark--
                  "  FROM ",cl_get_target_table(g_plant_new,'ida_file'),  #FUN-B80119--add--
                  " WHERE ida01 = '",p_idb01 ,"' ", #料號 #CHI-B90001 多一空格 
                  "  AND ida02 = '",p_idb02 ,"' ", #倉庫
                  "  AND ida03 = '",p_idb03 ,"' ", #儲位
                  "  AND ida04 = '",p_idb04 ,"' ", #批號
                  "  AND ida07 = '",p_idb07 ,"' ", #單據編號
                  "  AND ida08 = '",p_idb08 ,"' "  #單據項次
   ELSE
      LET g_sql = "SELECT SUM(idb11) ",            #出貨數量
                  #"  FROM idb_file ",                                    #FUN-B80119--mark--
                  "  FROM ",cl_get_target_table(g_plant_new,'idb_file'),  #FUN-B80119--add--
                  " WHERE idb01 = '",p_idb01 ,"' ", #料號 #CHI-B90001 多一空格 
                  #"  AND idb02 = '",p_idb02 ,"' ", #倉庫 #FUN-B30274 mark
                  #"  AND idb03 = '",p_idb03 ,"' ", #儲位 #FUN-B30274 mark
                  #"  AND idb04 = '",p_idb04 ,"' ", #批號 #FUN-B30274 mark
                  "  AND idb07 = '",p_idb07 ,"' ", #單據編號
                  "  AND idb08 = '",p_idb08 ,"' "  #單據項次

                  #FUN-C30274 --START--
                  IF NOT cl_null(p_idb02) THEN
                     LET g_sql = g_sql, "  AND idb02 = '",p_idb02 ,"' " #倉庫
                                        #"  AND idb03 = '",p_idb03 ,"' ", #儲位 #FUN-C30289
                                        #"  AND idb04 = '",p_idb04 ,"' " #批號  #FUN-C30289
                  END IF 
                  #FUN-C30289---begin
                  IF NOT cl_null(p_idb03) THEN
                     LET g_sql = g_sql, "  AND idb03 = '",p_idb03 ,"' " #儲位
                  END IF 
                  IF NOT cl_null(p_idb04) THEN
                     LET g_sql = g_sql, "  AND idb04 = '",p_idb04 ,"' " #批號
                  END IF    
                  #FUN-C30289---end
                  #FUN-C30274 --END--
   END IF 

   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #No.FUN-B80119--add--
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #No.FUN-B80119--add--
   PREPARE s_icdchk_pre FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('s_icdchk_pre',SQLCA.SQLCODE,1)
      LET g_success = 'N' 
      RETURN 0
   END IF
   DECLARE s_icdchk_cs CURSOR FOR s_icdchk_pre       
   IF SQLCA.SQLCODE THEN
      CALL cl_err('s_icdchk_cs',SQLCA.SQLCODE,1)
      LET g_success = 'N' 
      RETURN 0
   END IF
   OPEN s_icdchk_cs 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('open s_icdchk_cs',SQLCA.SQLCODE,1)
      RETURN 0
   END IF
   FETCH s_icdchk_cs INTO g_idb11_sum
   IF SQLCA.sqlcode THEN
      CALL cl_err('fetch s_icdchk_cs',SQLCA.sqlcode,1)
      RETURN 0
   END IF 
   IF cl_null(g_idb11_sum) THEN
      LET g_idb11_sum = 0 
   END IF
   #檢查出入庫的總數不等于傳入的數量(p_idb11-->出貨數量)
   IF g_idb11_sum != p_idb11 THEN
      #FUN-B30183 --START mark--
      #LET l_msg = "[LineNO:",p_idb08 USING '<<<<<',",",
                  #"PartNO:",p_idb01,",",
                  #"ICD Qty:",g_idb11_sum,",",
                  #"img10:",p_idb11,"]"
      #FUN-B30183 --END mark--                  
      #FUN-B30183 --START --      
      LET l_idb11_sum_str = g_idb11_sum
      LET l_idb11_str = p_idb11
      LET l_msg = "(", l_idb11_sum_str.trim(), " <> ", l_idb11_str.trim(), ") "
      #FUN-B30183 --END --  
      CALL cl_err(l_msg CLIPPED,'aic-901',1) 
      RETURN 0
   END IF  
   RETURN 1
END FUNCTION

FUNCTION s_icdinout_del(p_type,p_no,p_item,p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE p_type LIKE type_file.num5,    #異動別(1：入庫，0：其它入，-1：出庫，2：其它出)
          p_no   LIKE ida_file.ida07,    #單據編號
          p_item LIKE ida_file.ida08      #單據項次
 
   DEFINE l_flag LIKE type_file.num10,
          l_sql  STRING
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--

   WHENEVER ERROR CALL cl_err_msg_log
 
   LET l_flag = 1
 
   #檢查傳入參數杅
   IF cl_null(p_type) THEN
      #CALL cl_err('p_type','aic-908',1)   #MOD-C30527
      CALL cl_err(p_type,'aic-908',1)      #MOD-C30527
      LET l_flag = 0   RETURN l_flag
   END IF
   IF cl_null(p_no) THEN
      #CALL cl_err('p_no','aic-908',1)   #MOD-C30527
      CALL cl_err(p_no,'aic-908',1)      #MOD-C30527
      LET l_flag = 0   RETURN l_flag
   END IF
 
   IF NOT (p_type = 0 OR p_type = 1 OR p_type = -1 OR p_type = 2) THEN
      CALL cl_err('p_type <> 0/1/-1/2','!',1)
      LET l_flag = 0
      RETURN l_flag
   END IF
 
   #資料處理
   CASE 
      WHEN p_type = 0 OR p_type = 1
         #LET l_sql = "DELETE FROM ida_file ",    #FUN-B80119--mark--
         LET l_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'ida_file'),  #FUN-B80119--add--
                     "   WHERE ida07 = '",p_no CLIPPED,"'"
         IF NOT cl_null(p_item) THEN
            LET l_sql = l_sql CLIPPED, " AND ida08=",p_item CLIPPED
         END IF
      WHEN p_type = -1 OR p_type = 2
         #-->刪除idb_file前，先將idc_file的idc21扣掉
         CALL s_icd_un_idc(p_type,p_no,p_item,p_plant) RETURNING l_flag   #No.FUN-B80119--增加p_plant參數--
         IF NOT(l_flag) THEN   #有異常
            RETURN 0
         END IF 
 
         #LET l_sql = "DELETE FROM idb_file ",  #FUN-B80119--mark--
         LET l_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'idb_file'),  #FUN-B80119--add--
                     "   WHERE idb07 = '",p_no CLIPPED,"'"
         IF NOT cl_null(p_item) THEN
            LET l_sql = l_sql CLIPPED, " AND idb08=",p_item CLIPPED
         END IF
   END CASE
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #No.FUN-B80119--add--
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql      #No.FUN-B80119--add--
   PREPARE icd_del_pre FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('icd_del_pre',SQLCA.SQLCODE,1)
      LET l_flag = 0
      RETURN l_flag
   END IF
   EXECUTE icd_del_pre
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('','aic-900',1)
      LET l_flag = 0
   END IF
   
   #LET INT_FLAG = 0
   RETURN l_flag
END FUNCTION
#l_flag 1:成功  0:失敗
#在未過帳前，刪除相對應的idb_file中的資料
#要同步將idc_file中的idc21扣掉
FUNCTION s_icd_un_idc(p_type,p_no,p_item,p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE p_type LIKE type_file.num5,
          p_no   LIKE ida_file.ida07,
          p_item LIKE ida_file.ida08
   DEFINE l_sql  STRING   
   DEFINE l_idb  RECORD LIKE idb_file.*
   DEFINE l_oga011    LIKE oga_file.oga011,
          l_n         LIKE type_file.num5
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--
   DEFINE l_sfs03 LIKE sfs_file.sfs03     #FUN-C50120
   DEFINE l_idb1  RECORD LIKE idb_file.*  #FUN-C50120

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--
  
   INITIALIZE l_idb.* TO NULL
 
   #LET l_sql = " SELECT * FROM idb_file ",  #FUN-B80119--mark--
   LET l_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'idb_file'),  #FUN-B80119--add--
               "    WHERE idb07 = '",p_no CLIPPED,"'"
   IF NOT cl_null(p_item) THEN
     #LET l_sql = l_sql CLIPPED, " AND idb080=",p_item CLIPPED  #No.MOD-8B0212 mark
      LET l_sql = l_sql CLIPPED, " AND idb08=",p_item CLIPPED   #No.MOD-8B0212 add #idb080-->idb08
   END IF
   
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #No.FUN-B80119--add--
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql      #No.FUN-B80119--add--
   PREPARE icd_un_idc_pre FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('icd_un_idc_pre',SQLCA.SQLCODE,1)
      RETURN 0
   END IF
   DECLARE icd_un_idc_cs CURSOR FOR icd_un_idc_pre
   IF SQLCA.SQLCODE THEN
      CALL cl_err('icd_un_idc_cs',SQLCA.SQLCODE,1)
      RETURN 0
   END IF
   FOREACH icd_un_idc_cs INTO l_idb.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach un_idc_cs',SQLCA.SQLCODE,1)
         RETURN 0
      END IF
      IF p_type = -1 THEN
         LET l_oga011 = NULL
         #No.FUN-B80119--start--mark---
         #SELECT oga011 INTO l_oga011 FROM oga_file
         #   WHERE oga01 = l_idb.idb07
         #     AND oga09 = '2'     #一般出貨單
         #No.FUN-B80119---end---mark---
         
         #No.FUN-B80119--start--add---
         LET g_sql = "SELECT oga011 FROM ",cl_get_target_table(g_plant_new,'oga_file'),
                      " WHERE oga01 = '",l_idb.idb07,"' ",
                      "   AND oga09 = '2' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE s_icd_un_idc_pre FROM g_sql
         EXECUTE s_icd_un_idc_pre INTO l_oga011
         #No.FUN-B80119---end---add---        
 
         IF NOT cl_null(l_oga011) THEN
            LET l_n = 0 
           #No.MOD-8B0212 modify --begin
           #icd_file-->idd_file
           #SELECT COUNT(*) INTO l_n FROM icd_file
           #   WHERE icd10 = l_oga011      
           #    AND icd01 = l_idb.idb01    
           #    AND icd02 = l_idb.idb02    
           #    AND icd03 = l_idb.idb03    
           #    AND icd04 = l_idb.idb04    
           #    AND icd05 = l_idb.idb05    
           #    AND icd06 = l_idb.idb06    #BIN
           #    AND icd13 >= l_idb.idb11   
           #No.FUN-B80119--start--mark---
           # SELECT COUNT(*) INTO l_n FROM idd_file
           #    WHERE idd10 = l_oga011      
           #      AND idd01 = l_idb.idb01    
           #      AND idd02 = l_idb.idb02    
           #      AND idd03 = l_idb.idb03    
           #      AND idd04 = l_idb.idb04    
           #      AND idd05 = l_idb.idb05    
           #      AND idd06 = l_idb.idb06    #BIN
           #      AND idd13 >=l_idb.idb11   
           #No.FUN-B80119---end---mark---
           #No.MOD-8B0212 modify --end
            #No.FUN-B80119--start--add---
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'idd_file'),
                        " WHERE idd10 = '",l_oga011,"' ",
                        "   AND idd01 = '",l_idb.idb01,"' ",
                        "   AND idd02 = '",l_idb.idb02,"' ",
                        "   AND idd03 = '",l_idb.idb03,"' ",
                        "   AND idd04 = '",l_idb.idb04,"' ",
                        "   AND idd05 = '",l_idb.idb05,"' ",
                        "   AND idd06 = '",l_idb.idb06,"' ",
                        "   AND idd13 >='",l_idb.idb11,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
            PREPARE s_icd_un_idc1_pre FROM g_sql
            EXECUTE s_icd_un_idc1_pre INTO l_n
            #No.FUN-B80119---end---add---
            IF l_n > 0 THEN
               RETURN 1
            END IF
         END IF
      END IF
      #更新idc21，扣除出貨數量
     #No.MOD-890023 mark --begin
     #UPDATE idc_file             
     #   SET idc210 = idc210 - l_idb.idb110
     #  WHERE idc010 = l_idb.idb01
     #    AND idc020 = l_idb.idb02
     #    AND idc030 = l_idb.idb03
     #    AND idc040 = l_idb.idb04
     #    AND idc050 = l_idb.idb05
     #    AND idc060 = l_idb.idb06
     #No.MOD-890023 mark --end
     #No.MOD-890023 add --begin
     #No.FUN-B80119--start--mark---
     # UPDATE idc_file             
     #    SET idc21 = idc21 - l_idb.idb11
     #   WHERE idc01 = l_idb.idb01
     #     AND idc02 = l_idb.idb02
     #     AND idc03 = l_idb.idb03
     #     AND idc04 = l_idb.idb04
     #     AND idc05 = l_idb.idb05
     #     AND idc06 = l_idb.idb06
     #No.FUN-B80119---end---mark---
     #No.MOD-8B0212 modify --end
     #No.MOD-890023 add --end
     #FUN-BC0036 --START--
     #IF NOT cl_null(l_idb.idb05) AND NOT cl_null(l_idb.idb06) THEN  #TQC-C20088 mark
     IF NOT cl_null(l_idb.idb26) OR NOT cl_null(l_idb.idb27) THEN    #TQC-C20088
        LET l_idb.idb05 = l_idb.idb26
        LET l_idb.idb06 = l_idb.idb27
     END IF   
     #FUN-BC0036 --END--
      #No.FUN-B80119--start--add---    
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
                  "   SET idc21 = idc21 - ",l_idb.idb11 ," ",
                  " WHERE idc01 = '",l_idb.idb01,"' ",
                  "   AND idc02 = '",l_idb.idb02,"' ",
                  "   AND idc03 = '",l_idb.idb03,"' ",
                  "   AND idc04 = '",l_idb.idb04,"' ",
                  "   AND idc05 = '",l_idb.idb05,"' ",
                  "   AND idc06 = '",l_idb.idb06,"' "  
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE upd_s_icd_un_idc FROM g_sql
      EXECUTE upd_s_icd_un_idc
     #No.FUN-B80119---end---add---
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
     #   CALL cl_err('upd idc210(-)',SQLCA.SQLCODE,1)  #No.MOD-890023 mark
         CALL cl_err('upd idc21(-)',SQLCA.SQLCODE,1)   #No.MOD-890023 add
         LET g_success = 'N' 
         RETURN 0
      END IF

      #扣除發料單數量後 加回工單數量
      #FUN-C50120---begin
      SELECT sfs03 INTO l_sfs03 FROM sfs_file
       WHERE sfs01 = l_idb.idb07 AND sfs02 = l_idb.idb08
        
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
                  "   SET idc21 = idc21 + ? ",
                  " WHERE idc01 = ? AND idc02 = ? AND idc03 = ? ",
                  "   AND idc04 = ? AND idc05 = ? AND idc06 = ? "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE upd_s_icd_un_idc_1 FROM g_sql

      INITIALIZE l_idb1.* TO NULL 
      DECLARE idb_curs2 CURSOR FOR
         SELECT * FROM idb_file
          WHERE idb07 = l_sfs03
            AND idb01 = l_idb.idb01 AND idb02 = l_idb.idb02
            AND idb03 = l_idb.idb03 AND idb04 = l_idb.idb04
            AND idb05 = l_idb.idb05 AND idb06 = l_idb.idb06  #TQC-C60025 add
      FOREACH idb_curs2 INTO l_idb1.* 
         EXECUTE upd_s_icd_un_idc_1 USING l_idb1.idb11,
                                          l_idb1.idb01,l_idb1.idb02,l_idb1.idb03,
                                          l_idb1.idb04,l_idb1.idb05,l_idb1.idb06
         IF SQLCA.SQLCODE THEN
            CALL cl_err('upd idc21:',SQLCA.SQLCODE,1) 
            LET g_success = 'N' 
            RETURN 0
         END IF
      END FOREACH
      #FUN-C50120---end
   END FOREACH
   RETURN 1   #成功
END FUNCTION

#FUN-C30274 --START--
FUNCTION s_icdinout_del_2(p_type,p_no,p_item,p_plant,p_idb01,p_idb02,p_idb03,p_idb04)   
   DEFINE p_type LIKE type_file.num5,    #異動別(1：入庫，0：其它入，-1：出庫，2：其它出)
          p_no   LIKE ida_file.ida07,    #單據編號
          p_item LIKE ida_file.ida08,    #單據項次
          p_idb01 LIKE idb_file.idb01,
          p_idb02 LIKE idb_file.idb02,
          p_idb03 LIKE idb_file.idb03,
          p_idb04 LIKE idb_file.idb04     
 
   DEFINE l_flag LIKE type_file.num10,
          l_sql  STRING
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--

   WHENEVER ERROR CALL cl_err_msg_log
 
   LET l_flag = 1
 
   #檢查傳入參數杅
   IF cl_null(p_type) THEN
      #CALL cl_err('p_type','aic-908',1)   #MOD-C30527
      CALL cl_err(p_type,'aic-908',1)      #MOD-C30527
      LET l_flag = 0   RETURN l_flag
   END IF
   IF cl_null(p_no) THEN
      #CALL cl_err('p_no','aic-908',1)   #MOD-C30527
      CALL cl_err(p_no,'aic-908',1)      #MOD-C30527
      LET l_flag = 0   RETURN l_flag
   END IF
 
   IF NOT (p_type = 0 OR p_type = 1 OR p_type = -1 OR p_type = 2) THEN
      CALL cl_err('p_type <> 0/1/-1/2','!',1)
      LET l_flag = 0
      RETURN l_flag
   END IF
 
   #資料處理
   CASE 
      WHEN p_type = 0 OR p_type = 1
         #LET l_sql = "DELETE FROM ida_file ",    #FUN-B80119--mark--
         LET l_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'ida_file'),  #FUN-B80119--add--
                     "   WHERE ida07 = '",p_no CLIPPED,"'",
                     "   AND ida01 = '", p_idb01 ,"'",
                     "   AND ida02 = '", p_idb02 ,"'",
                     "   AND ida03 = '", p_idb03 ,"'",
                     "   AND ida04 = '", p_idb04 ,"'"                      
         IF NOT cl_null(p_item) THEN
            LET l_sql = l_sql CLIPPED, " AND ida08=",p_item CLIPPED
         END IF
      WHEN p_type = -1 OR p_type = 2
         #-->刪除idb_file前，先將idc_file的idc21扣掉
         CALL s_icd_un_idc_2(p_type,p_no,p_item,p_plant,p_idb01,p_idb02,p_idb03,p_idb04) RETURNING l_flag   #No.FUN-B80119--增加p_plant參數--
         IF NOT(l_flag) THEN   #有異常
            RETURN 0
         END IF 
 
         #LET l_sql = "DELETE FROM idb_file ",  #FUN-B80119--mark--
         LET l_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'idb_file'),  #FUN-B80119--add--
                     "   WHERE idb07 = '",p_no CLIPPED,"'",
                     "   AND idb01 = '", p_idb01 ,"'",
                     "   AND idb02 = '", p_idb02 ,"'",
                     "   AND idb03 = '", p_idb03 ,"'",
                     "   AND idb04 = '", p_idb04 ,"'"
         IF NOT cl_null(p_item) THEN
            LET l_sql = l_sql CLIPPED, " AND idb08=",p_item CLIPPED
         END IF
   END CASE
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #No.FUN-B80119--add--
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql      #No.FUN-B80119--add--
   PREPARE icd_del_pre_2 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('icd_del_pre_2',SQLCA.SQLCODE,1)
      LET l_flag = 0
      RETURN l_flag
   END IF
   EXECUTE icd_del_pre_2
   #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
   #   CALL cl_err('','aic-900',1)
   #   LET l_flag = 0
   #END IF
   
   #LET INT_FLAG = 0
   RETURN l_flag
END FUNCTION
#l_flag 1:成功  0:失敗
#在未過帳前，刪除相對應的idb_file中的資料
#要同步將idc_file中的idc21扣掉
FUNCTION s_icd_un_idc_2(p_type,p_no,p_item,p_plant,p_idb01,p_idb02,p_idb03,p_idb04)   #No.FUN-B80119--增加p_plant參數--
   DEFINE p_type LIKE type_file.num5,
          p_no   LIKE ida_file.ida07,
          p_item LIKE ida_file.ida08,
          p_idb01 LIKE idb_file.idb01,
          p_idb02 LIKE idb_file.idb02,
          p_idb03 LIKE idb_file.idb03,
          p_idb04 LIKE idb_file.idb04
   DEFINE l_sql  STRING   
   DEFINE l_idb  RECORD LIKE idb_file.*
   DEFINE l_oga011    LIKE oga_file.oga011,
          l_n         LIKE type_file.num5
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--
  
   INITIALIZE l_idb.* TO NULL
 
   #LET l_sql = " SELECT * FROM idb_file ",  #FUN-B80119--mark--
   LET l_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'idb_file'),  #FUN-B80119--add--
               "    WHERE idb07 = '",p_no CLIPPED,"'",
               "    AND idb01 = '", p_idb01 ,"'",
               "    AND idb02 = '", p_idb02 ,"'",
               "    AND idb03 = '", p_idb03 ,"'",
               "    AND idb04 = '", p_idb04 ,"'"
   IF NOT cl_null(p_item) THEN
     #LET l_sql = l_sql CLIPPED, " AND idb080=",p_item CLIPPED  #No.MOD-8B0212 mark
      LET l_sql = l_sql CLIPPED, " AND idb08=",p_item CLIPPED   #No.MOD-8B0212 add #idb080-->idb08
   END IF
   
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #No.FUN-B80119--add--
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql      #No.FUN-B80119--add--
   PREPARE icd_un_idc_pre_2 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('icd_un_idc_pre_2',SQLCA.SQLCODE,1)
      RETURN 0
   END IF
   DECLARE icd_un_idc_cs_2 CURSOR FOR icd_un_idc_pre_2
   IF SQLCA.SQLCODE THEN
      CALL cl_err('icd_un_idc_cs_2',SQLCA.SQLCODE,1)
      RETURN 0
   END IF
   FOREACH icd_un_idc_cs_2 INTO l_idb.*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('foreach un_idc_cs_2',SQLCA.SQLCODE,1)
         RETURN 0
      END IF
      IF p_type = -1 THEN
         LET l_oga011 = NULL
         #No.FUN-B80119--start--mark---
         #SELECT oga011 INTO l_oga011 FROM oga_file
         #   WHERE oga01 = l_idb.idb07
         #     AND oga09 = '2'     #一般出貨單
         #No.FUN-B80119---end---mark---
         
         #No.FUN-B80119--start--add---
         LET g_sql = "SELECT oga011 FROM ",cl_get_target_table(g_plant_new,'oga_file'),
                      " WHERE oga01 = '",l_idb.idb07,"' ",
                      "   AND oga09 = '2' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
         PREPARE s_icd_un_idc_pre_2 FROM g_sql
         EXECUTE s_icd_un_idc_pre_2 INTO l_oga011
         #No.FUN-B80119---end---add---        
 
         IF NOT cl_null(l_oga011) THEN
            LET l_n = 0 
           #No.MOD-8B0212 modify --begin
           #icd_file-->idd_file
           #SELECT COUNT(*) INTO l_n FROM icd_file
           #   WHERE icd10 = l_oga011      
           #    AND icd01 = l_idb.idb01    
           #    AND icd02 = l_idb.idb02    
           #    AND icd03 = l_idb.idb03    
           #    AND icd04 = l_idb.idb04    
           #    AND icd05 = l_idb.idb05    
           #    AND icd06 = l_idb.idb06    #BIN
           #    AND icd13 >= l_idb.idb11   
           #No.FUN-B80119--start--mark---
           # SELECT COUNT(*) INTO l_n FROM idd_file
           #    WHERE idd10 = l_oga011      
           #      AND idd01 = l_idb.idb01    
           #      AND idd02 = l_idb.idb02    
           #      AND idd03 = l_idb.idb03    
           #      AND idd04 = l_idb.idb04    
           #      AND idd05 = l_idb.idb05    
           #      AND idd06 = l_idb.idb06    #BIN
           #      AND idd13 >=l_idb.idb11   
           #No.FUN-B80119---end---mark---
           #No.MOD-8B0212 modify --end
            #No.FUN-B80119--start--add---
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'idd_file'),
                        " WHERE idd10 = '",l_oga011,"' ",
                        "   AND idd01 = '",l_idb.idb01,"' ",
                        "   AND idd02 = '",l_idb.idb02,"' ",
                        "   AND idd03 = '",l_idb.idb03,"' ",
                        "   AND idd04 = '",l_idb.idb04,"' ",
                        "   AND idd05 = '",l_idb.idb05,"' ",
                        "   AND idd06 = '",l_idb.idb06,"' ",
                        "   AND idd13 >='",l_idb.idb11,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
            PREPARE s_icd_un_idc1_pre_2 FROM g_sql
            EXECUTE s_icd_un_idc1_pre_2 INTO l_n
            #No.FUN-B80119---end---add---
            IF l_n > 0 THEN
               RETURN 1
            END IF
          END IF
      END IF
      #更新idc21，扣除出貨數量
     #No.MOD-890023 mark --begin
     #UPDATE idc_file             
     #   SET idc210 = idc210 - l_idb.idb110
     #  WHERE idc010 = l_idb.idb01
     #    AND idc020 = l_idb.idb02
     #    AND idc030 = l_idb.idb03
     #    AND idc040 = l_idb.idb04
     #    AND idc050 = l_idb.idb05
     #    AND idc060 = l_idb.idb06
     #No.MOD-890023 mark --end
     #No.MOD-890023 add --begin
     #No.FUN-B80119--start--mark---
     # UPDATE idc_file             
     #    SET idc21 = idc21 - l_idb.idb11
     #   WHERE idc01 = l_idb.idb01
     #     AND idc02 = l_idb.idb02
     #     AND idc03 = l_idb.idb03
     #     AND idc04 = l_idb.idb04
     #     AND idc05 = l_idb.idb05
     #     AND idc06 = l_idb.idb06
     #No.FUN-B80119---end---mark---
     #No.MOD-8B0212 modify --end
     #No.MOD-890023 add --end
     #FUN-BC0036 --START--
     #IF NOT cl_null(l_idb.idb05) AND NOT cl_null(l_idb.idb06) THEN  #TQC-C20088 mark
     IF NOT cl_null(l_idb.idb26) OR NOT cl_null(l_idb.idb27) THEN    #TQC-C20088
        LET l_idb.idb05 = l_idb.idb26
        LET l_idb.idb06 = l_idb.idb27
     END IF   
     #FUN-BC0036 --END--
      #No.FUN-B80119--start--add---    
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
                  "   SET idc21 = idc21 - ",l_idb.idb11 ," ",
                  " WHERE idc01 = '",l_idb.idb01,"' ",
                  "   AND idc02 = '",l_idb.idb02,"' ",
                  "   AND idc03 = '",l_idb.idb03,"' ",
                  "   AND idc04 = '",l_idb.idb04,"' ",
                  "   AND idc05 = '",l_idb.idb05,"' ",
                  "   AND idc06 = '",l_idb.idb06,"' "  
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE upd_s_icd_un_idc_2 FROM g_sql
      EXECUTE upd_s_icd_un_idc_2
     #No.FUN-B80119---end---add---
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
     #   CALL cl_err('upd idc210(-)',SQLCA.SQLCODE,1)  #No.MOD-890023 mark
         CALL cl_err('upd idc21(-)',SQLCA.SQLCODE,1)   #No.MOD-890023 add
         LET g_success = 'N' 
         RETURN 0
      END IF
   END FOREACH
   RETURN 1   #成功
END FUNCTION
#FUN-C30274 --END--

#str FUN-C50115 add
FUNCTION s_icdinout_repost(p_no)
   DEFINE p_no     LIKE idb_file.idb07
   DEFINE l_idb    RECORD LIKE idb_file.*

   LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'idc_file'),
               "   SET idc21 = idc21 + ? ",
               " WHERE idc01 = ? AND idc02 = ? AND idc03 = ? ",
               "   AND idc04 = ? AND idc05 = ? AND idc06 = ? "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE repost_idc FROM g_sql

   #加回出通單數量
   DECLARE idb_curs CURSOR FOR
      SELECT * FROM idb_file WHERE idb07 = p_no
   FOREACH idb_curs INTO l_idb.*
      EXECUTE repost_idc USING l_idb.idb11,
                               l_idb.idb01,l_idb.idb02,l_idb.idb03,
                               l_idb.idb04,l_idb.idb05,l_idb.idb06
      IF SQLCA.SQLCODE THEN
         CALL cl_err('upd idc21:',SQLCA.SQLCODE,1) 
         LET g_success = 'N' 
         RETURN 0
      END IF
   END FOREACH 

   RETURN 1
END FUNCTION
#end FUN-C50115 add

#FUN-B70032 --START--
FUNCTION icd_ins_ida(l_idb01,l_idb02,l_idb03,l_idb04,l_idb05,l_idb06,l_idb07,
                     l_idb08,l_idb09,l_idb11,l_idb12,l_idb14,l_idb15,l_imaicd01,p_plant)   #No.FUN-B80119--增加p_plant參數--
   DEFINE l_idb01 LIKE idb_file.idb01,
          l_idb02 LIKE idb_file.idb02,
          l_idb03 LIKE idb_file.idb03,
          l_idb04 LIKE idb_file.idb04,
          l_idb05 LIKE idb_file.idb05,
          l_idb06 LIKE idb_file.idb06,
          l_idb07 LIKE idb_file.idb07,
          l_idb08 LIKE idb_file.idb08,
          l_idb09 LIKE idb_file.idb09,
          l_idb11 LIKE idb_file.idb11,
          l_idb12 LIKE idb_file.idb12,          
          l_idb14 LIKE idb_file.idb14,
          l_idb15 LIKE idb_file.idb15,
          l_imaicd01 LIKE imaicd_file.imaicd01 
   DEFINE p_plant LIKE type_file.chr20         #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant                   #FUN-B80119--add--
   CALL icd_set_ida(l_idb01,l_idb02,l_idb03,l_idb04,l_idb05,l_idb06,l_idb07,
                    l_idb08,l_idb09,l_idb11,l_idb12,l_idb14,l_idb15,l_imaicd01,p_plant)  #No.FUN-B80119--增加p_plant參數--
                    
   IF cl_null(g_ida.idalegal) THEN LET g_ida.idalegal = g_legal END IF
   #IF cl_null(g_ida.idaplant) THEN LET g_ida.idaplant = g_plant END IF    #FUN-B80119--mark--
   IF cl_null(g_ida.idaplant) THEN LET g_ida.idaplant = p_plant END IF     #FUN-B80119--add---
   
   IF g_ida.ida17 IS NULL THEN LET g_ida.ida17=0 END IF #TQC-BA0136
   #INSERT INTO ida_file VALUES (g_ida.*)   #FUN-B80119--mark--
   #No.FUN-B80119--start--add---    
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'ida_file'),"(",
                 "ida01,ida02,ida03,ida04,ida05,ida06,ida07,ida08,ida09,ida10,",
                 "ida11,ida12,ida13,ida14,ida15,ida16,ida17,ida18,ida19,ida20,",
                 "ida21,ida22,ida23,ida24,ida25,ida26,ida27,ida28,ida29,ida30,",
                 "ida31,idaplant,idalegal) VALUES",
                 "(?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?,
                   ?,?,?) "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE ins_icd_ins_ida FROM g_sql
   EXECUTE ins_icd_ins_ida USING g_ida.ida01,g_ida.ida02,g_ida.ida03,g_ida.ida04,g_ida.ida05,
                             g_ida.ida06,g_ida.ida07,g_ida.ida08,g_ida.ida09,g_ida.ida10,
                             g_ida.ida11,g_ida.ida12,g_ida.ida13,g_ida.ida14,g_ida.ida15,
                             g_ida.ida16,g_ida.ida17,g_ida.ida18,g_ida.ida19,g_ida.ida20,
                             g_ida.ida21,g_ida.ida22,g_ida.ida23,g_ida.ida24,g_ida.ida25,
                             g_ida.ida26,g_ida.ida27,g_ida.ida28,g_ida.ida29,g_ida.ida30,
                             g_ida.ida31,g_ida.idaplant,g_ida.idalegal
   #No.FUN-B80119---end---add---
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      RETURN FALSE 
   END IF   
   RETURN TRUE  
END FUNCTION
#FUN-B70032 --END--

#FUN-AA0007--begin--add--------------
FUNCTION icd_set_ida(l_idb01,l_idb02,l_idb03,l_idb04,l_idb05,l_idb06,l_idb07,
                     l_idb08,l_idb09,l_idb11,l_idb12,l_idb14,l_idb15,l_imaicd01,p_plant)   #FUN-B70032   #No.FUN-B80119--增加p_plant參數--
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_fac     LIKE type_file.num20_6
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_count   LIKE type_file.num5
   #FUN-B70032 --START--
   DEFINE l_idb01 LIKE idb_file.idb01,
          l_idb02 LIKE idb_file.idb02,
          l_idb03 LIKE idb_file.idb03,
          l_idb04 LIKE idb_file.idb04,
          l_idb05 LIKE idb_file.idb05,
          l_idb06 LIKE idb_file.idb06,
          l_idb07 LIKE idb_file.idb07,
          l_idb08 LIKE idb_file.idb08,
          l_idb09 LIKE idb_file.idb09,
          l_idb11 LIKE idb_file.idb11,
          l_idb12 LIKE idb_file.idb12,          
          l_idb14 LIKE idb_file.idb14,
          l_idb15 LIKE idb_file.idb15,
          l_imaicd01 LIKE imaicd_file.imaicd01      
   #FUN-B70032 --END--
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--
   #IF g_imaicd08='Y' THEN #FUN-B70032 mark
   #   RETURN              #FUN-B70032 mark 
   #END IF                 #FUN-B70032 mark

   INITIALIZE g_ida.* TO NULL

   LET g_ida.ida01 = l_idb01 #料件編號 #FUN-B70032 g_idb => l_idb
   LET g_ida.ida02 = l_idb02 #倉庫編號 #FUN-B70032 g_idb => l_idb
   LET g_ida.ida03 = l_idb03 #儲位編號 #FUN-B70032 g_idb => l_idb
   LET g_ida.ida04 = l_idb04 #批號    #FUN-B70032 g_idb => l_idb
   LET g_ida.ida05 = l_idb05 #刻號    #FUN-B70032 ' ' => l_idb
   LET g_ida.ida06 = l_idb06 #Bin    #FUN-B70032 ' ' => l_idb 
   LET g_ida.ida07 = l_idb07         #FUN-B70032 g_idb => l_idb
   LET g_ida.ida08 = l_idb08         #FUN-B70032 g_idb => l_idb  
   LET g_ida.ida09 = l_idb09         #FUN-B70032 g_idb => l_idb

   #No.FUN-B80119--start--mark---
   #SELECT ima25,imaicd01 INTO g_ida.ida13,g_ida.ida14
   #  FROM ima_file,imaicd_file
   # WHERE ima01=l_idb01              #FUN-B70032 g_idb => l_idb
   #   AND ima01=imaicd00
   #No.FUN-B80119---end---mark---
   #No.FUN-B80119--start--add---
   LET g_sql = "SELECT ima25,imaicd01 FROM ",cl_get_target_table(g_plant_new,'ima_file'),
                                         ",",cl_get_target_table(g_plant_new,'imaicd_file'),
               " WHERE ima01 = '", l_idb01 ,"' ",
               "   AND ima01 = imaicd00 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_set_ida_pre FROM g_sql
   DECLARE icd_set_ida_cs CURSOR FOR icd_set_ida_pre
   OPEN icd_set_ida_cs
   FETCH icd_set_ida_cs INTO g_ida.ida13,g_ida.ida14
   #No.FUN-B80119---end---add---
   LET l_flag = NULL
   LET l_fac = NULL            #轉換率
   CALL s_umfchkm(l_idb01,l_idb12,g_ida.ida13,p_plant)   #FUN-B70032 g_idb => l_idb   #No.FUN-B80119--s_umfchk-->s_umfchkm---
      RETURNING l_flag,l_fac
   IF l_flag = 1 THEN
      LET l_msg = l_idb12 CLIPPED,'->',g_ida.ida13 CLIPPED   #FUN-B70032 g_idb => l_idb
      CALL cl_err(l_msg CLIPPED,'aic-907',1)
      LET g_success='N' RETURN
   END IF

   IF cl_null(g_ida.ida10) THEN LET g_ida.ida10=0 END IF
   LET g_ida.ida10=l_idb11*l_fac #數量 #FUN-B70032 g_idb => l_idb
   LET g_ida.ida11=0
   LET g_ida.ida12=0
   LET g_ida.ida14=l_imaicd01   #FUN-B70032 g_imaicd01 => l_imaicd01
   #FUN-B30187 --START--
   LET g_ida.ida15 = l_idb14   #母批 
   LET g_ida.ida16 = l_idb15   #Datecode   
   #LET g_ida.ida15 =' '
   #IF g_yn = 'Y' AND (g_in_out='6' OR g_in_out='7') THEN
   #   LET l_count = 0
   #   SELECT count(*) INTO l_count
   #     FROM rvv_file
   #    WHERE rvv01 = g_idb07   #單據編號
   #      AND rvv02 = g_idb08   #單據項次
   #   IF l_count > 0 THEN
   #      SELECT rvviicd02 INTO g_ida.ida16    #DATECODE
   #        FROM rvvi_file
   #       WHERE rvvi01 = g_idb07
   #         AND rvvi02 = g_idb08
   #   END IF
   #END IF
   #FUN-B30187 --END--
   LET g_ida.ida17 = 0
   LET g_ida.ida18 = 100    #YIELD
   LET g_ida.ida19 = ' '    #TEST #
   LET g_ida.ida20 = ' '    #DEDUCT
   LET g_ida.ida21 = ' '    #PASS BIN
   LET g_ida.ida22 = ' '
   LET g_ida.ida29 = ' '
   LET g_ida.idaplant=p_plant             #FUN-B80119--add-- 
END FUNCTION

#FUN-B70032 --START--
FUNCTION icd_ins_idb(l_idb01,l_idb02,l_idb03,l_idb04,l_idb05,l_idb06,l_idb07,
                     l_idb08,l_idb09,l_idb11,l_idb12,l_idb14,l_idb15,l_imaicd01,p_plant)  #No.FUN-B80119--增加p_plant參數--
   DEFINE l_idb01 LIKE idb_file.idb01,
          l_idb02 LIKE idb_file.idb02,
          l_idb03 LIKE idb_file.idb03,
          l_idb04 LIKE idb_file.idb04,
          l_idb05 LIKE idb_file.idb05,
          l_idb06 LIKE idb_file.idb06,
          l_idb07 LIKE idb_file.idb07,
          l_idb08 LIKE idb_file.idb08,
          l_idb09 LIKE idb_file.idb09,
          l_idb11 LIKE idb_file.idb11,
          l_idb12 LIKE idb_file.idb12,          
          l_idb14 LIKE idb_file.idb14,
          l_idb15 LIKE idb_file.idb15,
          l_imaicd01 LIKE imaicd_file.imaicd01 
   DEFINE p_plant LIKE type_file.chr20    #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--

   CALL icd_set_idb(l_idb01,l_idb02,l_idb03,l_idb04,l_idb05,l_idb06,l_idb07,
                    l_idb08,l_idb09,l_idb11,l_idb12,l_idb14,l_idb15,l_imaicd01,p_plant)  #No.FUN-B80119--增加p_plant參數--

   IF cl_null(g_idb.idblegal) THEN LET g_idb.idblegal = g_legal END IF
   #IF cl_null(g_idb.idbplant) THEN LET g_idb.idbplant = g_plant END IF   #FUN-B80119--mark--
   IF cl_null(g_idb.idbplant) THEN LET g_idb.idbplant = p_plant END IF    #FUN-B80119--add---
   
   IF g_idb.idb16 IS NULL THEN LET g_idb.idb16=0 END IF #TQC-BA0136   
   #INSERT INTO idb_file VALUES (g_idb.*)  #FUN-B80119--mark--
   #No.FUN-B80119--start--add---    
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idb_file'),"(",
                 "idb01,idb02,idb03,idb04,idb05,idb06,idb07,idb08,idb09,idb10,",
                 "idb11,idb12,idb13,idb14,idb15,idb16,idb17,idb18,idb19,idb20,",
                 "idb21,idb22,idb23,idb24,idb25,idbplant,idblegal) VALUES",
                 "(?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?,?,?,?,
                   ?,?,?,?,?,?,?) "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE ins_icd_ins_idb FROM g_sql
   EXECUTE ins_icd_ins_idb USING g_idb.idb01,g_idb.idb02,g_idb.idb03,g_idb.idb04,g_idb.idb05,
                                 g_idb.idb06,g_idb.idb07,g_idb.idb08,g_idb.idb09,g_idb.idb10,
                                 g_idb.idb11,g_idb.idb12,g_idb.idb13,g_idb.idb14,g_idb.idb15,
                                 g_idb.idb16,g_idb.idb17,g_idb.idb18,g_idb.idb19,g_idb.idb20,
                                 g_idb.idb21,g_idb.idb22,g_idb.idb23,g_idb.idb24,g_idb.idb25,
                                 g_idb.idbplant,g_idb.idblegal
   #No.FUN-B80119---end---add---
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      RETURN FALSE 
   END IF   
   RETURN TRUE  
END FUNCTION
#FUN-B70032 --END--

FUNCTION icd_set_idb(l_idb01,l_idb02,l_idb03,l_idb04,l_idb05,l_idb06,l_idb07,
                     l_idb08,l_idb09,l_idb11,l_idb12,l_idb14,l_idb15,l_imaicd01,p_plant) #FUN-B70032  #No.FUN-B80119--增加p_plant參數--
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_fac     LIKE type_file.num20_6
   DEFINE l_msg     LIKE type_file.chr1000 
   DEFINE l_idc07   LIKE idc_file.idc07
   DEFINE l_idc08   LIKE idc_file.idc08
   DEFINE l_count   LIKE type_file.num10
   DEFINE p_plant   LIKE type_file.chr20    #FUN-B80119--add--
   #FUN-B70032 --START--
   DEFINE l_idb01 LIKE idb_file.idb01,
          l_idb02 LIKE idb_file.idb02,
          l_idb03 LIKE idb_file.idb03,
          l_idb04 LIKE idb_file.idb04,
          l_idb05 LIKE idb_file.idb05,
          l_idb06 LIKE idb_file.idb06,
          l_idb07 LIKE idb_file.idb07,
          l_idb08 LIKE idb_file.idb08,
          l_idb09 LIKE idb_file.idb09,
          l_idb11 LIKE idb_file.idb11,
          l_idb12 LIKE idb_file.idb12,          
          l_idb14 LIKE idb_file.idb14,
          l_idb15 LIKE idb_file.idb15,
          l_imaicd01 LIKE imaicd_file.imaicd01   
   #FUN-B70032 --END--

   #IF g_imaicd08='Y' THEN #FUN-B70032 mark
   #   RETURN              #FUN-B70032 mark
   #END IF                 #FUN-B70032 mark
   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant              #FUN-B80119--add--
   INITIALIZE g_idb.* TO NULL

   LET g_idb.idb05 = l_idb05 #FUN-B70032 ' ' => l_idb05
   LET g_idb.idb06 = l_idb06 #FUN-B70032 ' ' => l_idb06
   #No.FUN-B80119--start--mark---
   #SELECT idc07,idc08 INTO l_idc07,l_idc08
   #   FROM idc_file
   #  WHERE idc01 = l_idb01             #FUN-B70032 g_idb => l_idb
   #    AND idc02 = l_idb02             #FUN-B70032 g_idb => l_idb 
   #    AND idc03 = l_idb03             #FUN-B70032 g_idb => l_idb 
   #    AND idc04 = l_idb04             #FUN-B70032 g_idb => l_idb
   #    AND idc05 = g_idb.idb05
   #    AND idc06 = g_idb.idb06   #BIN
   #No.FUN-B80119---end---mark--
   #No.FUN-B80119--start--add---
   #LET g_sql = "SELECT idc07,idc08 FROM ",cl_get_target_table(g_plant_new,'idc_file'), #MOD-CA0120 mark
   LET g_sql = "SELECT idc08 FROM ",cl_get_target_table(g_plant_new,'idc_file'),        #MOD-CA0120 add
                  " WHERE idc01 = '",l_idb01,"' ",
                  "   AND idc02 = '",l_idb02,"' ",
                  "   AND idc03 = '",l_idb03,"' ",
                  "   AND idc04 = '",l_idb04,"' ",
                  "   AND idc05 = '",g_idb.idb05,"' ",
                  "   AND idc06 = '",g_idb.idb06,"' "   #BIN
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_set_idb_pre FROM g_sql
   DECLARE icd_set_idb_cs CURSOR FOR icd_set_idb_pre
   OPEN icd_set_idb_cs
   #FETCH icd_set_idb_cs INTO l_idc07,l_idc08 #MOD-CA0120 mark 
   FETCH icd_set_idb_cs INTO l_idc08          #MOD-CA0120 add 
   #No.FUN-B80119---end---add---

   #MOD-CA0120 add start -----
   LET g_sql = "SELECT ima25 FROM ",cl_get_target_table(g_plant_new,'ima_file'),
               " WHERE ima01 = '",l_idb01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE icd_set_ima_pre FROM g_sql
   DECLARE icd_set_ima_cs CURSOR FOR icd_set_ima_pre
   OPEN icd_set_ima_cs
   FETCH icd_set_ima_cs INTO l_idc07
   #MOD-CA0120 add end   -----

   LET l_flag = NULL
   LET l_fac = NULL            #轉換率
   CALL s_umfchkm(l_idb01,l_idb12,l_idc07,p_plant)   #FUN-B70032 g_idb => l_idb  #No.FUN-B80119--s_umfchk-->s_umfchkm---
      RETURNING l_flag,l_fac
   IF l_flag = 1 THEN
      LET l_msg = l_idb12 CLIPPED,'->',l_idc07 CLIPPED   #FUN-B70032 g_idb => l_idb
      CALL cl_err(l_msg CLIPPED,'aic-907',1)
      LET g_success='N' RETURN
   END IF

   LET g_idb.idb01 = l_idb01   #FUN-B70032 g_idb => l_idb
   LET g_idb.idb02 = l_idb02   #FUN-B70032 g_idb => l_idb
   LET g_idb.idb03 = l_idb03   #FUN-B70032 g_idb => l_idb
   LET g_idb.idb04 = l_idb04   #FUN-B70032 g_idb => l_idb
   LET g_idb.idb05 = l_idb05   #FUN-B70032 ' ' => l_idb05
   LET g_idb.idb06 = l_idb06   #FUN-B70032 ' ' => l_idb06
   LET g_idb.idb12 = l_idc07
   LET g_idb.idb09 = l_idb09   #FUN-B70032 g_idb => l_idb
   LET g_idb.idb07 = l_idb07   #FUN-B70032 g_idb => l_idb
   LET g_idb.idb08 = l_idb08   #FUN-B70032 g_idb => l_idb
   LET g_idb.idb11 = l_idb11*l_fac   #數量    #FUN-B70032 g_idb => l_idb
   LET g_idb.idb13 = l_imaicd01 #FUN-B70032 g_imaicd01 => l_imaicd01 
   #FUN-B30187 --START--
   LET g_idb.idb14 = l_idb14   #母批          #FUN-B70032 g_idb => l_idb 
   LET g_idb.idb15 = l_idb15   #Datecode     #FUN-B70032 g_idb => l_idb
   #LET g_idb.idb14 = ' '
   #IF g_yn = 'Y' AND (g_in_out='6' OR g_in_out='7') THEN
   #   LET l_count = 0
   #   SELECT count(*) INTO l_count
   #     FROM rvv_file
   #    WHERE rvv01 = g_idb07   #單據編號
   #      AND rvv02 = g_idb08   #單據項次
   #   IF l_count > 0 THEN
   #      SELECT rvviicd02 INTO g_idb.idb15    #DATECODE
   #        FROM rvvi_file
   #       WHERE rvvi01 = g_idb07
   #         AND rvvi02 = g_idb08
   #   END IF
   #END IF
   #FUN-B30187 --END--
   LET g_idb.idb16 = 0
   LET g_idb.idb17 = 100
   LET g_idb.idb18 = ' '
   LET g_idb.idb19 = 0
   LET g_idb.idb20 = 'Y'
   LET g_idb.idb21 = ' '
   LET g_idb.idb25 = ' '
   LET g_idb.idbplant=p_plant   #FUN-B80119--add---
   IF l_idc08 IS NULL THEN LET l_idc08 = 0 END IF
   LET g_idb.idb10 = l_idc08
END FUNCTION
#FUN-AA0007--end--add-----------

#FUN-B30187 --START--
FUNCTION icd_ins_idt(p_idt01,p_idt02,p_plant)  #No.FUN-B80119--增加p_plant參數--
   DEFINE p_idt01          LIKE idt_file.idt01
   DEFINE p_idt02          LIKE idt_file.idt02
   DEFINE l_idt_cnt        LIKE type_file.num10
   DEFINE l_idt     RECORD LIKE idt_file.*   
   DEFINE p_plant          LIKE type_file.chr20 #FUN-B80119--add--

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  #No.FUN-B80119--add---
   LET g_plant_new = p_plant                    #FUN-B80119--add--
   
   IF cl_null(p_idt01) THEN
      LET p_idt01 = ' '
   END IF
   IF cl_null(p_idt02) THEN
      LET p_idt02 = ' '
   END IF  
   #No.FUN-B80119--start--mark---
   #SELECT count(*) INTO l_idt_cnt from idt_file
   #                WHERE idt01 = p_idt01 AND idt02 = p_idt02
   #No.FUN-B80119---end---mark---
   
   #No.FUN-B80119--start--add---
   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'idt_file'),
               " WHERE idt01 = '",p_idt01,"' ",
               "   AND idt02 = '",p_idt02,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_ins_idt_pre FROM g_sql
   EXECUTE icd_ins_idt_pre INTO l_idt_cnt
   #No.FUN-B80119---end---add---
   IF l_idt_cnt = 0 THEN

      INITIALIZE l_idt.* TO NULL
      LET l_idt.idt01 = p_idt01
      LET l_idt.idt02 = p_idt02
      LET l_idt.idtacti = 'Y'
      LET l_idt.idtdate = g_today
      LET l_idt.idtgrup = g_grup      
      LET l_idt.idtorig = g_grup
      LET l_idt.idtoriu = g_user
      LET l_idt.idtuser = g_user      
      
      #INSERT INTO idt_file VALUES (l_idt.*)  #FUN-B80119--mark--
      #No.FUN-B80119--start--add---    
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idt_file'),"(",
                     "idt01,idt02,idtacti,idtdate,idtgrup,idtmodu,idtorig,idtoriu,idtuser) VALUES",
                     "(?,?,?,?,?,?,?,?,?) "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE ins_icd_ins_idt FROM g_sql
      EXECUTE ins_icd_ins_idt USING l_idt.idt01,l_idt.idt02,l_idt.idtacti,l_idt.idtdate,l_idt.idtgrup,
                                    l_idt.idtmodu,l_idt.idtorig,l_idt.idtoriu,l_idt.idtuser
      #No.FUN-B80119---end---add---
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
         CALL cl_err('ins idt_file',SQLCA.SQLCODE,1)
         RETURN FALSE 
      END IF
   END IF 
   RETURN TRUE 
END FUNCTION 
#FUN-B30187 --END--
#FUN-B80119--add--
FUNCTION icd_imaicd04(p_idd01,p_plant)
   DEFINE p_idd01     LIKE  idd_file.idd01
   DEFINE l_imaicd08  LIKE  imaicd_file.imaicd08  #是否做刻號管理
   DEFINE p_plant  LIKE type_file.chr20       

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  
   LET g_plant_new = p_plant
   LET g_sql = "SELECT imaicd08 FROM ",cl_get_target_table(g_plant_new,'imaicd_file'),
                " WHERE imaicd00 = '", p_idd01 ,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_post_pre1 FROM g_sql
   DECLARE icd_post_cs1 CURSOR FOR icd_post_pre1
   OPEN icd_post_cs1
   FETCH icd_post_cs1 INTO l_imaicd08 
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("sel","ima_file",g_idb01,"",SQLCA.sqlcode,"","sel imaicd08 fail:",0) 
      LET g_success = 'N'
      RETURN 0
   END IF
   LET g_imaicd08=l_imaicd08 
END FUNCTION 
#FUN-B80119--end--
#FUN-B90012--add--
#新增IDC_FILE资料 
FUNCTION icd_idc_ins_idc(p_plant)
DEFINE p_plant    LIKE type_file.chr20       
DEFINE l_ids02    LIKE ids_file.ids02    
DEFINE l_ids04    LIKE ids_file.ids04   

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  
   LET g_plant_new = p_plant
   LET g_idc.idc01 = g_idb01         
   LET g_idc.idc02 = g_idb02          
   LET g_idc.idc03 = g_idb03
   LET g_idc.idc04 = g_idb04
   LET g_idc.idc05 = g_idb.idb05
   LET g_idc.idc06 = g_idb.idb06
   LET g_idc.idc07 = g_idb.idb12
   LET g_idc.idc08 = 0             #数量
   LET g_idc.idc09 = g_idb.idb13
   LET g_idc.idc10 = g_idb.idb14
   LET g_idc.idc11 = g_idb.idb15   #DATECODE
   LET g_idc.idc12 = 0
   LET g_idc.idc13 = g_idb.idb17   #YIELD
   LET g_idc.idc14 = g_idb.idb18   #TEST #
   LET g_idc.idc15 = g_idb.idb19   #DEDUCT
   LET g_idc.idc16 = g_idb.idb20   #PASS BIN
   LET g_idc.idc19 = g_idb.idb21
   LET g_idc.idc20 = g_idb.idb25
   LET g_idc.idc21 = 0
             
   LET g_idc.idc17 = 'N'

   LET l_ids02 = ''
   LET l_ids04 = '' 
   LET g_sql = "SELECT ids02,ids04 FROM ",cl_get_target_table(g_plant_new,'ids_file'),
               " WHERE ids01= '",g_idb04,"' AND idsacti='Y' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_idc3_pre FROM g_sql
   DECLARE icd_idc3_cs CURSOR FOR icd_idc3_pre
   OPEN icd_idc3_cs
   FETCH icd_idc3_cs INTO l_ids02,l_ids04 

   IF l_ids02='1' THEN LET g_idc.idc17='Y' END IF
   IF l_ids02='2' THEN LET g_idc.idc18=l_ids04  
   ELSE LET g_idc.idc18='N' END IF  
   IF g_idc.idc12 IS NULL THEN LET g_idc.idc12=0 END IF #TQC-BA0136
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idc_file'),"(",
               "idc01,idc02,idc03,idc04,idc05,idc06,idc07,idc08,idc09,idc10,",
               "idc11,idc12,idc13,idc14,idc15,idc16,idc17,idc18,idc19,idc20,",
               "idc21) VALUES",
               "(?,?,?,?,?,?,?,?,?,?,
                 ?,?,?,?,?,?,?,?,?,?,
                 ?) "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
   PREPARE ins_icd_idc1 FROM g_sql
   EXECUTE ins_icd_idc1 USING g_idc.idc01,g_idc.idc02,g_idc.idc03,g_idc.idc04,g_idc.idc05,g_idc.idc06,g_idc.idc07, 
                              g_idc.idc08,g_idc.idc09,g_idc.idc10,g_idc.idc11,g_idc.idc12,g_idc.idc13,g_idc.idc14, 
                              g_idc.idc15,g_idc.idc16,g_idc.idc17,g_idc.idc18,g_idc.idc19,g_idc.idc20,g_idc.idc21  
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('ins idc_file',SQLCA.SQLCODE,1)
      LET g_success = 'N' RETURN
   END IF
END FUNCTION 
#FUN-B90012--end--
#FUN-B90012--add--
#新增IDC_FILE资料 
FUNCTION icd_post5_ins_idc(p_plant)
DEFINE p_plant     LIKE type_file.chr20       
DEFINE l_count     LIKE type_file.num10    
DEFINE l_ids02     LIKE ids_file.ids02   
DEFINE l_ids04     LIKE ids_file.ids04     

   IF cl_null(p_plant) THEN LET p_plant=g_plant END IF  
   LET g_plant_new = p_plant
   LET g_sql = "SELECT idd15,idd16 FROM ",cl_get_target_table(g_plant_new,'idd_file'),
               " WHERE idd10 = '",g_no  ,"' ",  
               "   AND idd11 = '",g_item,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_post5_2_pre FROM g_sql
   DECLARE icd_post5_2_cs CURSOR FOR icd_post5_2_pre
   OPEN icd_post5_2_cs
   FETCH icd_post5_2_cs INTO g_idd15,g_idd16

   IF cl_null(g_idd15) THEN
      LET g_sql = "SELECT ima01 FROM ",cl_get_target_table(g_plant_new,'ima_file'),
                  " WHERE ima01 = '",g_idb01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE icd_post5_3_pre FROM g_sql
      EXECUTE icd_post5_3_pre INTO g_idd15
   END IF
   IF cl_null(g_idd16) THEN
      LET g_idd16 = g_idb14    #庫存批號 
   END IF

   LET l_count = 0 
   LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'rvv_file'),
               " WHERE rvv01 = '",g_idb07,"' ",
               "   AND rvv02 = '",g_idb08,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_post5_4_pre FROM g_sql
   EXECUTE icd_post5_4_pre INTO l_count
   IF l_count > 0 THEN
      LET g_sql = "SELECT rvviicd02 FROM ",cl_get_target_table(g_plant_new,'rvvi_file'),
                  " WHERE rvvi01 = '",g_idb07,"' ",
                  "   AND rvvi02 = '",g_idb08,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE icd_post5_5_pre FROM g_sql
      EXECUTE icd_post5_5_pre INTO g_idd17
   END IF 
         
   LET g_idc.idc01 = g_idb01
   LET g_idc.idc02 = g_idb02
   LET g_idc.idc03 = g_idb03
   LET g_idc.idc04 = g_idb04
   LET g_idc.idc05 = ' '
   LET g_idc.idc06 = ' '                #BIN
   LET g_idc.idc07 = g_idb12
   LET g_idc.idc08 = 0                  #数量
   LET g_idc.idc09 = g_idd15
   LET g_idc.idc10 = g_idd16
   LET g_idc.idc11 = g_idd17            #DATECODE
   LET g_idc.idc12 = 0          
   LET g_idc.idc13 = g_idd19	          #YIELD
   LET g_idc.idc14 = NULL               #TEST #
   LET g_idc.idc15 = NULL               #DEDUCT
   LET g_idc.idc16 = NULL               #PASS BIN
   LET g_idc.idc19 = g_idd23
   LET g_idc.idc20 = NULL
   LET g_idc.idc21 = 0
   LET g_idc.idc17 = 'N'
     
   LET g_sql = "SELECT ids02,ids04 FROM ",cl_get_target_table(g_plant_new,'ids_file'),
               " WHERE ids01= '",g_idb04,"' AND idsacti='Y' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE icd_post5_6_pre FROM g_sql
   DECLARE icd_post5_6_cs CURSOR FOR icd_post5_6_pre
   OPEN icd_post5_6_cs
   FETCH icd_post5_6_cs INTO l_ids02,l_ids04

   IF l_ids02='1' THEN LET g_idc.idc17='Y' END IF
   IF l_ids02='2' THEN LET g_idc.idc18=l_ids04  
   ELSE
      LET g_idc.idc18='N'
   END IF
   IF g_idc.idc12 IS NULL THEN LET g_idc.idc12=0 END IF #TQC-BA0136
   LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'idc_file'),"(",
               "idc01,idc02,idc03,idc04,idc05,idc06,idc07,idc08,idc09,idc10,",
               "idc11,idc12,idc13,idc14,idc15,idc16,idc17,idc18,idc19,idc20,",
               "idc21) VALUES",
               "(?,?,?,?,?,?,?,?,?,?,
               ?,?,?,?,?,?,?,?,?,?,
               ?) "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE ins_icd_post5 FROM g_sql
   EXECUTE ins_icd_post5 USING g_idc.idc01,g_idc.idc02,g_idc.idc03,g_idc.idc04,g_idc.idc05,g_idc.idc06,g_idc.idc07, 
                               g_idc.idc08,g_idc.idc09,g_idc.idc10,g_idc.idc11,g_idc.idc12,g_idc.idc13,g_idc.idc14, 
                               g_idc.idc15,g_idc.idc16,g_idc.idc17,g_idc.idc18,g_idc.idc19,g_idc.idc20,g_idc.idc21  

   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('ins idc_file',SQLCA.SQLCODE,1)
      LET g_success = 'N' 
      RETURN
   END IF  
END FUNCTION 
#FUN-B90012--end--
