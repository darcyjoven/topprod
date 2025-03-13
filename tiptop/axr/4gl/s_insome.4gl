# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.TQC-5B0175 05/11/28 By ice 開立發票時不應再考慮待扺金額(確認時已經更新)
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.MOD-6B0009 06/11/07 By Smapmin 開立發票後更新出貨單已開發票數量
# Modify.........: No.MOD-6C0104 06/12/22 By Smapmin 雜項不用update ogb60
# Modify.........: No.FUN-710050 07/01/23 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-760035 07/06/13 By Smapmin 修改update oga54
# MOdify.........: No.CHI-790002 07/09/02 By Nicole 修正Insert Into ome_file Error
# Modify.........: No.TQC-790092 07/09/17 By rainy 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.MOD-7C0229 07/12/31 By Smapmin 開立發票時,發票客戶應抓取發票客戶
# Modify.........: No.MOD-8A0224 08/10/30 By Sarah 取消MOD-6B0009回寫ogb_file段(因已在s_ar_upinv處理)
# Modify.........: No.MOD-970131 09/07/15 By mike 若l_oma.oma04='MISC'時,ome043改給值oma69,若l_oma.oma04不為'MISC'時,依原先做法抓occ
# Modify.........: No.FUN-980011 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-970108 09/08/24 By hongmei 將oma71的值賦給ome60
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying 改為可從同法人下不同DB抓資料
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A70028 10/08/26 By Summer 寫入ome_file時需同步增加寫入到發票與帳款對照檔(omee_file)
# Modify.........: No:MOD-AA0185 10/10/29 By Dido 若客戶為 MISC 則 oma042/oma044 預設值調整為 occm02/occm04 
# Modify.........: No:MOD-AB0036 10/11/03 By Dido 應更新 oma71 
# Modify.........: No:MOD-B30597 11/03/18 By Sarah 當oma59t為0時,提示訊息"發票金額為0,不可產生發票資料!",且不產生ome_file資料
# Modify.........: No:MOD-B80016 11/08/03 By yinhy 出貨和折讓應收合并開立發票時，會多生成一筆發票類型為2的發票記錄
# Modify.........: No:FUN-B90097 11/09/22 By yangxf 因為 ome_file 新增了 not null 欄位, 導致部份作業無法成功產生發票資料.
# Modify.........: No:FUN-B90130 11/09/22 By wujie 增加ome03
# Modify.........: No:FUN-C40078 12/05/03 By Lori  Insert新增ome22預設值 
# Modify.........: No:FUN-C70030 12/07/11 By pauline INSERT ome_file 新增omecncl預設值'N'
# Modify.........: No:FUN-C80002 12/08/02 By pauline INSERT ome_file 新增ome81預設值'1'
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_insome(p_oma01,p_oma21,p_plant)   # 依 INVOICE insert into ome_file(GUI)#No.FUN-9C0014 Add p_dbs #No.FUN-A10104
   DEFINE p_oma01	LIKE oma_file.oma01   #No.FUN-680123 VARCHAR(16) # INVOICE No.#No.FUN-550071
   DEFINE p_oma21  LIKE oma_file.oma21
   DEFINE l_oma record like oma_file.*
   DEFINE l_omb record like omb_file.*   #MOD-6B0009
   DEFINE l_ome record like ome_file.*
   DEFINE l_gec record like gec_file.*
   #add 030625 NO.A083
   DEFINE l_cnt                 LIKE type_file.num5          #No.FUN-680123 SMALLINT
   DEFINE l_oot05               LIKE oot_file.oot05 
   DEFINE l_oot05x              LIKE oot_file.oot05x
   DEFINE l_oot05t              LIKE oot_file.oot05t
   DEFINE g_cnt                 SMALLINT   #MOD-760035
   DEFINE p_dbs                 LIKE type_file.chr21          #No.FUN-9C0014 Add
   DEFINE p_plant               LIKE azp_file.azp01           #No.FUN-A10104
   DEFINE l_sql                 LIKE type_file.chr1000        #No.FUN-9C0014 Add
   DEFINE l_omee RECORD LIKE omee_file.*  #CHI-A70028 add
 
   WHENEVER ERROR CONTINUE
#No.FUN-A10104 -BEGIN-----
   IF cl_null(p_plant) THEN
      LET p_dbs = ''
   ELSE
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET p_dbs = g_dbs_tra
   END IF
#No.FUN-A10104 -END-------
   SELECT * INTO l_oma.* FROM oma_file WHERE oma01=p_oma01
   IF STATUS THEN 
#     CALL cl_err('sel oma:',STATUS,1)   #No.FUN-660116
#     CALL cl_err3("sel","oma_file",p_oma01,"",STATUS,"","sel oma:",1)    #No.FUN-660116  #NO.FUN-710050
#NO.FUN-710050---------begin
      IF g_bgerr THEN
      CALL s_errmsg('oma01',p_oma01,'sel oma:',STATUS,1)              
      ELSE
      CALL cl_err3("sel","oma_file",p_oma01,"",STATUS,"","sel oma:",1)
      END IF
#NO.FUN-710050---------end
      LET g_success='N'
      RETURN 
   END IF
  #str MOD-B30597 add
  #當oma59t為0時,提示訊息"發票金額為0,不可產生發票資料!",且不產生ome_file資料
   IF l_oma.oma59t = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',p_oma01,'','axr-325',1)              
      ELSE
         CALL cl_err('oma01','axr-325',1)
      END IF
      LET g_success='N'
      RETURN 
   END IF
  #end MOD-B30597 add
   IF cl_null(p_oma21) THEN LET p_oma21=l_oma.oma21 END IF
   #----modify 97/07/15
   SELECT * INTO l_gec.* FROM gec_file WHERE gec01 = p_oma21 AND gec011='2'
   IF STATUS THEN 
#     CALL cl_err('sel gec:',STATUS,1)    #No.FUN-660116
#     CALL cl_err3("sel","gec_file",p_oma21,"",STATUS,"","sel gec:",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','sel gec:',STATUS,1)          
      ELSE
         CALL cl_err3("sel","gec_file",p_oma21,"",STATUS,"","sel gec:",1)            
      END IF
#NO.FUN-710050-------end      
      LET g_success='N'
      RETURN 
   END IF
 
   #add 030625 NO.A083
   SELECT COUNT(*),SUM(oot05),SUM(oot05x),SUM(oot05t)
     INTO l_cnt,l_oot05,l_oot05x,l_oot05t
     FROM oot_file 
    WHERE oot03 = l_oma.oma01
   IF cl_null(l_oot05)  THEN LET l_oot05  = 0 END IF
   IF cl_null(l_oot05x) THEN LET l_oot05x = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
 
   INITIALIZE l_ome.* TO NULL
   LET l_ome.ome00 =l_oma.oma00
   #No.MOD-B80016  --Begin
   IF l_oma.oma00 MATCHES '2*' THEN
      LET l_ome.ome00 = '1'
   END IF
   #No.MOD-B80016  --End
   LET l_ome.ome01 =l_oma.oma10
   LET l_ome.ome02 =l_oma.oma09
   LET l_ome.ome16 =l_oma.oma01
   #-----97/07/15 modify
   LET l_ome.ome171=l_gec.gec08
   LET l_ome.ome172=l_gec.gec06
   #--------
   #LET l_ome.ome04 =l_oma.oma03    #MOD-7C0229
   LET l_ome.ome04 =l_oma.oma04    #MOD-7C0229
   IF cl_null(p_dbs) THEN           #No.FUN-9C0014 Add
   SELECT occ11,occ18,occ231 INTO l_ome.ome042,l_ome.ome043,l_ome.ome044
          #FROM occ_file WHERE occ01=l_oma.oma03   #MOD-7C0229
          FROM occ_file WHERE occ01=l_oma.oma04   #MOD-7C0229
  #No.FUN-9C0014 BEGIN -----
   ELSE
      #LET l_sql = "SELECT occ11,occ18,occ231 FROM ",p_dbs CLIPPED,"occ_file",
      LET l_sql = "SELECT occ11,occ18,occ231 FROM ",cl_get_target_table(p_plant,'occ_file'), #FUN-A50102
                  " WHERE occ01='",l_oma.oma04,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102
      PREPARE sel_occ_pre01 FROM l_sql
      EXECUTE sel_occ_pre01 INTO l_ome.ome042,l_ome.ome043,l_ome.ome044
   END IF
  #No.FUN-9C0014 END -------
  #MOD-970131    ---start                                                                                                           
   IF l_oma.oma04='MISC' THEN                                                                                                       
     #SELECT oma69 INTO l_ome.ome043 FROM oma_file                            #MOD-AA0185 mark
      SELECT oma042,oma044,oma69 INTO l_ome.ome042,l_ome.ome044,l_ome.ome043  #MOD-AA0185
        FROM oma_file                                                         #MOD-AA0185
       WHERE oma01=l_oma.oma01                                                                                                      
   END IF                                                                                                                           
  #MOD-970131    ---end    
   LET l_ome.ome05 =l_oma.oma05
   LET l_ome.ome08 =l_oma.oma08
 # LET l_ome.ome21 =l_oma.oma21
 # LET l_ome.ome211=l_oma.oma211
 # LET l_ome.ome212=l_oma.oma212
 # LET l_ome.ome213=l_oma.oma213
   LET l_ome.ome21 =l_gec.gec01
   LET l_ome.ome211=l_gec.gec04 
   LET l_ome.ome212=l_gec.gec05 
   LET l_ome.ome213=l_gec.gec07 
   LET l_ome.ome59 =l_oma.oma59
   LET l_ome.ome59x=l_oma.oma59x
   LET l_ome.ome59t=l_oma.oma59t
   LET l_ome.ome03 =l_oma.oma75   #No.FUN-B90130 
#No.TQC-5B0175 --start--
#  #modify 030625 NO.A083
#  IF l_cnt > 0 THEN 
#     LET l_ome.ome59 =l_oma.oma59  - l_oot05
#     LET l_ome.ome59x=l_oma.oma59x - l_oot05x
#     LET l_ome.ome59t=l_oma.oma59t - l_oot05t
#  ELSE
#     LET l_ome.ome59 =l_oma.oma59
#     LET l_ome.ome59x=l_oma.oma59x
#     LET l_ome.ome59t=l_oma.oma59t
#  END IF
#  #add 031028 NO.A097
#No.TQC-5B0175 --end--
   IF l_oma.oma00 = '21' AND l_oma.oma34 MATCHES '[14]' THEN
      LET l_ome.ome59  = l_oma.oma59  * -1
      LET l_ome.ome59x = l_oma.oma59x * -1
      LET l_ome.ome59t = l_oma.oma59t * -1
   END IF
   #add end
   LET l_ome.omevoid='N'
   LET l_ome.omeprsw='0'
   LET l_ome.omeuser=g_user
   LET l_ome.omegrup=g_grup
   LET l_ome.omedate=TODAY
   #No.CHI-790002 START
   IF cl_null(l_ome.ome01) THEN LET l_ome.ome01=' ' END IF
   #No.CHI-790002 END  
   #FUN-970108---Begin
   SELECT oom13 INTO l_ome.ome60 FROM oom_file
    WHERE oom07 <= l_ome.ome01 
      AND oom08 >= l_ome.ome01
      AND oom03 =  l_ome.ome05
      AND (oom16 = l_ome.ome03 OR oom16 IS NULL )   #No.FUN-B90130
   #FUN-970108---End 
   LET l_ome.omelegal=g_legal #FUN-980011 add
   LET l_ome.omeoriu = g_user      #No.FUN-980030 10/01/04
   LET l_ome.omeorig = g_grup      #No.FUN-980030 10/01/04
#FUN-B90097 begin ---
   IF cl_null(l_ome.ome70) THEN LET l_ome.ome70 = 'N' END IF
   IF cl_null(l_ome.ome74) THEN LET l_ome.ome74 = 0 END IF
   IF cl_null(l_ome.ome75) THEN LET l_ome.ome75 = 0 END IF
   IF cl_null(l_ome.ome76) THEN LET l_ome.ome76 = 0 END IF
   IF cl_null(l_ome.ome77) THEN LET l_ome.ome77 = ' ' END IF
   IF cl_null(l_ome.ome78) THEN LET l_ome.ome78 = 0 END IF
   IF cl_null(l_ome.ome79) THEN LET l_ome.ome79 = 0 END IF
   IF cl_null(l_ome.ome80) THEN LET l_ome.ome80 = 0 END IF
   IF l_ome.ome03 IS NULL THEN LET l_ome.ome03 = ' ' END IF    #No.FUN-B90130
   IF cl_null(l_ome.ome22) THEN LET l_ome.ome22 = 'N' END IF   #FUN-C40078 add
#FUN-B90097 end ---
   IF cl_null(l_ome.omecncl) THEN LET l_ome.omecncl = 'N' END IF   #FUN-C70030 add
   IF cl_null(l_ome.ome81) THEN LET l_ome.ome81 = '1' END IF   #FUN-C80002 add
   INSERT INTO ome_file VALUES(l_ome.*)
   #IF STATUS AND STATUS!= -239 THEN                                 #TQC-790092
   IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN  #TQC-790092
#     CALL cl_err('sel oma:',STATUS,1)   #No.FUN-660116
#     CALL cl_err3("ins","ome_file",l_ome.ome01,"",STATUS,"","sel oma:",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         LET g_showmsg =l_ome.ome00,"/",l_ome.ome01                         
         CALL s_errmsg('ome00,ome01',g_showmsg,'sel oma:',STATUS,1)         
      ELSE
         CALL cl_err3("ins","ome_file",l_ome.ome01,"",STATUS,"","sel oma:",1)
      END IF
#NO.FUN-710050-------end
         LET g_success='N'
      RETURN
   #-----MOD-760035---------
   ELSE
   #  CALL s_ar_upinv(l_oma.oma01) RETURNING g_cnt #No.FUN-9C0014
   #  CALL s_ar_upinv(l_oma.oma01,p_dbs) RETURNING g_cnt #No.FUN-9C0014 #No.FUN-A10104
      CALL s_ar_upinv(l_oma.oma01,p_plant) RETURNING g_cnt #No.FUN-A10104
   #-----END MOD-760035-----
   END IF
   #IF SQLCA.SQLCODE=-239 THEN               #TQC-790092
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790092
      SELECT SUM(oma59),SUM(oma59x),SUM(oma59t)
             INTO l_oma.oma59, l_oma.oma59x, l_oma.oma59t
             FROM oma_file 
            WHERE oma10=l_ome.ome01
              AND (oma75=l_ome.ome03 OR oma75 IS NULL )   #No.FUN-B90130
      IF l_oma.oma59 IS NULL THEN
         LET l_oma.oma59 = 0 LET l_oma.oma59x= 0 LET l_oma.oma59t= 0
      END IF
#No.TQC-5B0175 --start--
#     #add 030625 NO.A083
#     SELECT SUM(oot05),SUM(oot05x),SUM(oot05t)
#       INTO l_oot05,l_oot05x,l_oot05t
#       FROM oma_file,oot_file 
#      WHERE oma01 = oot03
#        AND oma10 = l_ome.ome01
#     IF cl_null(l_oot05)  THEN LET l_oot05  = 0 END IF
#     IF cl_null(l_oot05x) THEN LET l_oot05x = 0 END IF
#     IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
#     LET l_oma.oma59  = l_oma.oma59  - l_oot05
#     LET l_oma.oma59x = l_oma.oma59x - l_oot05x
#     LET l_oma.oma59t = l_oma.oma59t - l_oot05t
#     #add 031028 NO.A097
#No.TQC-5B0175 --end--
      IF l_oma.oma00 = '21' AND l_oma.oma34 MATCHES '[14]' THEN
         LET l_oma.oma59  = l_oma.oma59  * -1
         LET l_oma.oma59x = l_oma.oma59x * -1
         LET l_oma.oma59t = l_oma.oma59t * -1
      END IF
      #add end
      UPDATE ome_file SET ome05=l_oma.oma05,   ome08=l_oma.oma08,
                          ome21=l_oma.oma21,   ome211=l_oma.oma211,
                          ome212=l_oma.oma212, ome213=l_oma.oma213,
                          ome59=l_oma.oma59,   ome59x=l_oma.oma59x,
                          ome59t=l_oma.oma59t
       WHERE ome01=l_ome.ome01
         AND (ome03 = l_ome.ome03 OR ome03 =' ')   #No.FUN-B90130
    #No.+041 010330 by plum
    #IF STATUS THEN CALL cl_err('upd ome59:',STATUS,1)LET g_success='N'RETURN
     IF STATUS OR SQLCA.SQLCODE THEN
#       CALL cl_err('upd ome59:',SQLCA.SQLCODE,1)    #No.FUN-660116
#       CALL cl_err3("upd","ome_file",l_ome.ome01,"",SQLCA.SQLCODE,"","upd ome59:",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050-------begin
        IF g_bgerr THEN
           CALL s_errmsg('ome01',l_ome.ome01,'upd ome59:',SQLCA.SQLCODE,1)    
        ELSE
           CALL cl_err3("upd","ome_file",l_ome.ome01,"",SQLCA.SQLCODE,"","upd ome59:",1)
        END IF
#NO.FUN-710050-------end
           LET g_success='N' RETURN
     END IF
    #No.+041..end
   END IF
  #-MOD-AB0036-add-
   UPDATE oma_file SET oma71=l_ome.ome60
    WHERE oma01 = l_oma.oma01 
  #-MOD-AB0036-end-

   #CHI-A70028 add --start--
   INITIALIZE l_omee.* TO NULL
   LET l_omee.omee01 = l_ome.ome01 
   LET l_omee.omee02 = l_ome.ome16
   LET l_omee.omeedate = TODAY
   LET l_omee.omeegrup = g_grup
   LET l_omee.omeelegal = g_legal
   LET l_omee.omeeorig = g_grup
   LET l_omee.omeeoriu = g_user
   LET l_omee.omeeuser = g_user
   LET l_omee.omee03 = l_ome.ome03   #No.FUN-B90130 
   
   INSERT INTO omee_file VALUES(l_omee.*)
   IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN
      CALL cl_err3("ins","omee_file",l_omee.omee01,l_omee.omee02,SQLCA.SQLCODE,"","ins omee",1)
      LET g_success='N'
      RETURN
   END IF
   #CHI-A70028 add --end--
 
  #str MOD-8A0224 mark
  # #-----MOD-6B0009---------
  # DECLARE omb_c CURSOR FOR
  #   SELECT * FROM omb_file WHERE omb01 = p_oma01
  # FOREACH omb_c INTO l_omb.*
  #    #-----MOD-6C0104---------
  #    LET l_cnt = 0 
  #    SELECT COUNT(*) INTO l_cnt FROM ogb_file
  #      WHERE ogb01 = l_omb.omb31 AND ogb03 = l_omb.omb32
  #    IF l_cnt > 0 THEN 
  #    #-----END MOD-6C0104-----
  #       UPDATE ogb_file SET ogb60 = l_omb.omb12
  #         WHERE ogb01 = l_omb.omb31 AND ogb03 = l_omb.omb32
  #       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
  #         #CALL cl_err3("upd","ogb_file",l_omb.omb31,l_omb.omb32,STATUS,"","",1)       #NO.FUN-710050
  #         #NO.FUN-710050-------begin
  #          IF g_bgerr THEN
  #             CALL s_errmsg('','','',STATUS,1)        
  #          ELSE
  #             CALL cl_err3("upd","ogb_file",l_omb.omb31,l_omb.omb32,STATUS,"","",1)
  #          END IF
  #         #NO.FUN-710050-------end                                   
  #          LET g_success='N' 
  #         #RETURN                                                                      #NO.FUN-710050
  #          EXIT FOREACH                                                                #NO.FUN-710050
  #       END IF
  #    END IF   #MOD-6C0104
  # END FOREACH
  # #-----END MOD-6B0009-----
  #end MOD-8A0224 mark
END FUNCTION
