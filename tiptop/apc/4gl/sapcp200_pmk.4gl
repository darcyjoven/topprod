# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: sapcp200_sub.4gl
# Description....: COPY FROM sapmt420_sub.4gl
# Modify.........: No:FUN-A30116 10/04/17 By bnlent  改為跨DB的形式
# Modify.........: No.FUN-A50102 10/07/14 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:TQC-B20181 11/03/08 By wangxin 將上傳不成功的資料匯入log查詢檔
# Modify.........: No:FUN-B50002 11/05/03 By wangxin BUG調整

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapcp200.global"          #TQC-B20181 add
 
DEFINE g_dbs         LIKE azw_file.azw05    #No.FUN-A30116 
DEFINE g_sql         STRING            #No.FUN-A30116 

FUNCTION t420sub_y_chk(p_pmk01,p_plant)     #No.FUN-A30116 增加營運中心參數
DEFINE p_pmk01       LIKE pmk_file.pmk01
DEFINE p_plant       LIKE azp_file.azp01    #No.FUN-A30116
DEFINE l_cnt         LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE l_str         LIKE type_file.chr4    #No.FUN-680136 VARCHAR(04)
DEFINE l_pml04       LIKE pml_file.pml04
DEFINE l_pml33       LIKE pml_file.pml33	#MOD-990262
DEFINE l_pml35       LIKE pml_file.pml35	#MOD-990262
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_ima140      LIKE ima_file.ima140
DEFINE l_ima1401     LIKE ima_file.ima1401  #FUN-6A0036 add
DEFINE l_pmk         RECORD LIKE pmk_file.* #FUN-730012
DEFINE l_status      LIKE type_file.chr1    #FUN-880016
DEFINE l_t1          LIKE smy_file.smyslip  #FUN-880016
 
   #No.FUN-A30116 ...begin
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
   LET g_dbs = s_dbstring(g_dbs CLIPPED)
   #No.FUN-A30116 ...end
   LET g_success = 'Y'
   IF p_pmk01 IS NULL THEN RETURN END IF #CHI-740014
   #No.FUN-A30116 ...begin
   #SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01=p_pmk01 #CHI-740014
   #LET g_sql = " SELECT * FROM ",g_dbs,"pmk_file WHERE pmk01='",p_pmk01,"'"
   LET g_sql = " SELECT * FROM ",cl_get_target_table(g_plant_new,'pmk_file'), #FUN-A50102
               "  WHERE pmk01='",p_pmk01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
   PREPARE sel_pmk_pre FROM g_sql
   EXECUTE sel_pmk_pre INTO l_pmk.*
   #No.FUN-A30116 ...end
   #bnl#IF l_pmk.pmk18='Y' THEN                   ##當確認碼為 'Y' 時, RETURN
   #bnl#   IF g_bgerr THEN
   #bnl#      CALL s_errmsg("pmk01",p_pmk01,"","9023",1) #MOD-780137
   #bnl#      RETURN   #bnl
   #bnl#   ELSE
   #bnl#      CALL cl_err('','9023',1) #MOD-780137
   #bnl#      RETURN  #bnl
   #bnl#   END IF
   #bnl#    LET g_success = 'N'
   #bnl#END IF
   IF l_pmk.pmk18='X' THEN                    #當確認碼為 'X' 作廢時, RETURN
     IF g_bgerr THEN
        CALL s_errmsg("pmk01",p_pmk01,"","9024",1) #MOD-780137
        #TQC-B20181 add begin-----------  
        LET g_errno='9024'                           
	LET g_msg1=''||'pmk01'||g_plant_new||g_fno1
	CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	LET g_msg=g_msg[1,255]
	CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	LET g_errno=''
	LET g_msg=''
	LET g_msg1=''
        #TQC-B20181 add end-------------
         RETURN   #bnl
     ELSE
        CALL cl_err('','9024',1) #MOD-780137
         RETURN   #bnl
     END IF
     LET g_success = 'N'
   END IF
   IF l_pmk.pmkacti='N' THEN                  #當資料有效碼為 'N' 時, RETURN
     IF g_bgerr THEN
        CALL s_errmsg("pmk01",p_pmk01,"","mfg0301",1) #MOD-780137
        #TQC-B20181 add begin-----------  
        LET g_errno='mfg0301'                           
	LET g_msg1=''||'pmk01'||g_plant_new||g_fno1
	CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	LET g_msg=g_msg[1,255]
	CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	LET g_errno=''
	LET g_msg=''
	LET g_msg1=''
        #TQC-B20181 add end-------------
         RETURN   #bnl
     ELSE
        CALL cl_err('','mfg0301',1) #MOD-780137
         RETURN   #bnl
     END IF
        LET g_success = 'N'
   END IF
 
#---MODNO:7379---無單身資料不可確認
   LET l_cnt=0
   #No.FUN-A30116 ...begin
   #SELECT COUNT(*) INTO l_cnt
   #  FROM pml_file
   # WHERE pml01=l_pmk.pmk01
   #LET g_sql = " SELECT COUNT(*) FROM ",g_dbs,"pml_file WHERE pml01='",l_pmk.pmk01,"'"
   LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'pml_file'), #FUN-A50102
               " WHERE pml01='",l_pmk.pmk01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102    
   PREPARE sel_pml_pre FROM g_sql
   EXECUTE sel_pml_pre INTO l_cnt
   #No.FUN-A30116 ...end
   IF l_cnt=0 OR l_cnt IS NULL THEN
      IF g_bgerr THEN
         CALL s_errmsg("pmk01",p_pmk01,"","mfg-009",1) #MOD-780137
         #TQC-B20181 add begin-----------  
         LET g_errno='mfg-009'                           
	 LET g_msg1=''||'pmk01'||g_plant_new||g_fno1
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
         RETURN   #bnl
      ELSE
         CALL cl_err('','mfg-009',0) #MOD-780137
         RETURN   #bnl
      END IF
      LET g_success = 'N'
   END IF
 
   LET l_cnt = 0
   #No.FUN-A30116 ...begin
   #SELECT COUNT(*) INTO l_cnt
   #  FROM pml_file
   # WHERE pml01=l_pmk.pmk01
   #   AND pml33 IS NULL
   #LET g_sql = " SELECT COUNT(*) FROM ",g_dbs,"pml_file WHERE pml01='",l_pmk.pmk01,"' AND pml33 IS NULL"
   LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'pml_file'), #FUN-A50102
               "  WHERE pml01='",l_pmk.pmk01,"' AND pml33 IS NULL"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE sel_pml_pre2 FROM g_sql
   EXECUTE sel_pml_pre2 INTO l_cnt
   #No.FUN-A30116 ...end
   IF l_cnt >=1 THEN
      #單身交貨日期尚有資料是空白的,請補齊.
      IF g_bgerr THEN
         CALL s_errmsg("pmk01",p_pmk01,"","apm-421",1) #MOD-780137
         #TQC-B20181 add begin-----------  
         LET g_errno='apm-421'                           
	 LET g_msg1=''||'pmk01'||g_plant_new||g_fno1
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
      ELSE
         CALL cl_err('','apm-421',1) #MOD-780137
      END IF
      LET g_success = 'N'
   END IF
   #bnl#   LET l_t1 = s_get_doc_no(l_pmk.pmk01) 
   #bnl#   SELECT * INTO g_smy.* FROM smy_file
   #bnl#    WHERE smyslip=l_t1
 
   #bnl#   #--------------------------------- 請採購預算控管 00/03/28 By Melody
   #bnl#   IF g_smy.smy59='Y' AND g_success='Y' THEN CALL t420sub_budchk(l_pmk.*) END IF 
 
   #bnl#   IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
   #bnl#      IF NOT cl_null(l_pmk.pmk09) THEN 
   #bnl#         IF g_smy.smy64 != '0' THEN    #要控管
   #bnl#            CALL s_showmsg_init()
   #bnl#            CALL aws_gpmcli_part(l_pmk.pmk01,l_pmk.pmk09,'','5')
   #bnl#                 RETURNING l_status
   #bnl#            IF l_status = '1' THEN   #回傳結果為失敗
   #bnl#               IF g_smy.smy64 = '2' THEN   
   #bnl#                  LET g_success = 'N'
   #bnl#                  CALL s_showmsg()
   #bnl#                  RETURN
   #bnl#               END IF
   #bnl#               IF g_smy.smy64 = '1' THEN
   #bnl#                  CALL s_showmsg()
   #bnl#               END IF
   #bnl#            END IF
   #bnl#         END IF
   #bnl#      END IF
   #bnl#   END IF       #FUN-8A0054
   #Begin No:7225  無效料件或Phase Out者不可以請購
   #No.FUN-A30116 ..begin
   # DECLARE pml_cur1 CURSOR FOR
   #    SELECT pml04,pml33,pml35 FROM pml_file WHERE pml01=l_pmk.pmk01		#MOD-990262 add pml33,pml35
   #LET g_sql = " SELECT pml04,pml33,pml35 FROM ",g_dbs,"pml_file WHERE pml01 = '",l_pmk.pmk01,"' "
   LET g_sql = " SELECT pml04,pml33,pml35 FROM ",cl_get_target_table(g_plant_new,'pml_file'), #FUN-A50102
               " WHERE pml01 = '",l_pmk.pmk01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   DECLARE pml_cur1 CURSOR FROM g_sql
   #No.FUN-A30116 ..end
   # CALL s_showmsg_init()        #No.FUN-710030   bnl mark
    FOREACH pml_cur1 INTO l_pml04,l_pml33,l_pml35 				#MOD-990262 add pml33,pml35
       IF g_success="N" THEN
          LET g_totsuccess="N"
          LET g_success="Y"
       END IF
       LET l_str = l_pml04[1,4]  #No:7225
       IF l_str = 'MISC' THEN CONTINUE FOREACH END IF #No:7225
       SELECT imaacti,ima140,ima1401 INTO l_imaacti,l_ima140,l_ima1401  #FUN-6A0036 add ima1401
         FROM ima_file
        WHERE ima01 = l_pml04
       IF SQLCA.sqlcode THEN
          IF l_pml04[1,4] <>'MISC' THEN  #NO:6808
              LET l_imaacti = 'N'
              LET l_ima140 = 'Y'
          END IF
       END IF
       IF l_imaacti = 'N' OR (l_ima140 = 'Y' AND l_ima1401 <= l_pmk.pmk04) THEN   #FUN-6A0036
          IF g_bgerr THEN
             CALL s_errmsg("pml04",l_pml04,"","apm-006",1) #FUN-980046  
             #TQC-B20181 add begin-----------  
             LET g_errno='apm-006'                           
	     LET g_msg1=''||'pml04'||g_plant_new||g_fno1
	     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	     LET g_msg=g_msg[1,255]
	     CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	     LET g_errno=''
	     LET g_msg=''
	     LET g_msg1=''
             #TQC-B20181 add end------------- 
          ELSE
             CALL cl_err(l_pml04,'apm-006',0) #MOD-780137
          END IF
          LET g_success = 'N'
       END IF
       IF l_pml33 < l_pmk.pmk04 THEN
          CALL s_errmsg("pml33",l_pml33,"","apm-027",1)    
          LET g_success = 'N'
          #TQC-B20181 add begin-----------  
          LET g_errno='apm-027'                           
	  LET g_msg1=''||'pml33'||g_plant_new||g_fno1
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
       END IF       
       IF l_pml35 < l_pmk.pmk04 THEN
          CALL s_errmsg("pml35",l_pml35,"","apm-060",1)    
          LET g_success = 'N'
          #TQC-B20181 add begin-----------  
          LET g_errno='apm-060'                           
	  LET g_msg1=''||'pml35'||g_plant_new||g_fno1
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
       END IF       
    END FOREACH
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
    #CALL s_showmsg()       #No.TQC-740093  bnl mark
END FUNCTION
 
#作用:lock cursor
#回傳值:無
FUNCTION t420sub_lock_cl()
   DEFINE l_forupd_sql STRING
   #LET l_forupd_sql = "SELECT * FROM ",g_dbs,"pmk_file WHERE pmk01 = ? FOR UPDATE"   #No.FUN-A30116
   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'pmk_file'), #FUN-A50102
                      " WHERE pmk01 = ? FOR UPDATE"   #No.FUN-A30116
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)
   CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql              #FUN-A50102
      CALL cl_parse_qry_sql(l_forupd_sql,g_plant_new) RETURNING l_forupd_sql  #FUN-A50102
   DECLARE t420sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
#FUNCTION t420sub_y_upd(l_pmk01,p_action_choice,p_plant)  #No.FUN-A30116 #FUN-B50002 mark
FUNCTION t420sub_y_upd(l_pmk01,p_action_choice,p_plant,p_oeb03)  #FUN-B50002 add
   DEFINE l_pmk01 LIKE pmk_file.pmk01,
          p_action_choice STRING,
          l_pmk  RECORD LIKE pmk_file.*,
          l_pmkmksg LIKE pmk_file.pmkmksg,
          l_pmk25   LIKE pmk_file.pmk25          
   DEFINE p_plant   LIKE azp_file.azp01    #No.FUN-A30116
   DEFINE p_oeb03   LIKE oeb_file.oeb03    #FUN-B50002 add
 
   WHENEVER ERROR CONTINUE #FUN-730012
 
   LET g_success = 'Y'
   #No.FUN-A30116 ...begin
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=g_dbs_tra
   LET g_dbs = s_dbstring(g_dbs CLIPPED)
   #No.FUN-A30116 ...end
 
   IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      p_action_choice CLIPPED = "insert"     #FUN-640184 
   THEN 
      SELECT pmkmksg,pmk25 
        INTO l_pmkmksg,l_pmk25
        FROM pmk_file
       WHERE pmk01=l_pmk01
      IF l_pmkmksg='Y' THEN            #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF l_pmk25 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF NOT cl_confirm('axm-108') THEN 
         LET g_success = 'N'     #TQC-740245
         RETURN 
      END IF  #詢問是否執行確認功能
   END IF
 
   #BEGIN WORK
 
   CALL t420sub_lock_cl() #FUN-730012
   OPEN t420sub_cl USING l_pmk01
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN t420sub_cl:", STATUS, 1)
      CLOSE t420sub_cl
      #ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t420sub_cl INTO l_pmk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(l_pmk.pmk01,SQLCA.sqlcode,0)
      CLOSE t420sub_cl
      #ROLLBACK WORK
      RETURN
   END IF 
   CALL t420sub_y1(l_pmk.*)
 
   IF g_success = 'Y' THEN
     #bnl# IF l_pmk.pmkmksg = 'Y' THEN  #簽核模式
     #bnl#    CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
     #bnl#         WHEN 0  #呼叫 EasyFlow 簽核失敗
     #bnl#              LET l_pmk.pmk18="N"
     #bnl#              LET g_success = "N"
     #bnl#              ROLLBACK WORK
     #bnl#              RETURN
     #bnl#         WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
     #bnl#              LET l_pmk.pmk18="N"
     #bnl#              ROLLBACK WORK
     #bnl#              RETURN
     #bnl#    END CASE
     #bnl# END IF
      #No.FUN-A30116 ...begin
      IF g_azw.azw04 = '2' THEN
        #CALL t420sub_transfer(l_pmk.*,p_plant) #FUN-B50002 mark
         CALL t420sub_transfer(l_pmk.*,p_plant,p_oeb03) #FUN-B50002 add
      END IF
      #No.FUN-A30116 ...end
      IF g_success='Y' THEN
         LET l_pmk.pmk25='1'              #執行成功, 狀態值顯示為 '1' 已核准
         LET l_pmk.pmk18='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
         #COMMIT WORK
         CALL cl_flow_notify(l_pmk.pmk01,'Y')
      ELSE
         LET l_pmk.pmk18='N'
         LET g_success = 'N'
         #ROLLBACK WORK
      END IF
   ELSE
      LET l_pmk.pmk18='N'
      LET g_success = 'N'
      #ROLLBACK WORK
   END IF
 
END FUNCTION
 
#------- 請採購預算控管 00/03/28 By Melody
FUNCTION t420sub_budchk(l_pmk)
   DEFINE l_pmk    RECORD LIKE pmk_file.*
   DEFINE l_pml    RECORD LIKE pml_file.*
   DEFINE l_bud    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE over_amt LIKE pml_file.pml44 #MOD-530190
   DEFINE last_amt LIKE pml_file.pml44 #MOD-530190
   DEFINE l_msg    LIKE ze_file.ze03   #MOD-530058
   DEFINE l_bud1   LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_msg1    LIKE ze_file.ze03
   DEFINE over_amt1 LIKE pml_file.pml44 
   DEFINE last_amt1 LIKE pml_file.pml44
   DEFINE p_sum1    LIKE afc_file.afc07
   DEFINE p_sum2    LIKE afc_file.afc07
   DEFINE l_flag    LIKE type_file.num5
   DEFINE l_over    LIKE afc_file.afc07
   DEFINE l_yy      LIKE type_file.num5
   DEFINE l_mm      LIKE type_file.num5
   DEFINE l_bookno1 LIKE aaa_file.aaa01
   DEFINE l_bookno2 LIKE aaa_file.aaa01
   DEFINE l_afb07   LIKE afb_file.afb07
 
   DECLARE bud_cur CURSOR FOR
      SELECT * FROM pml_file WHERE pml01=l_pmk.pmk01
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH bud_cur INTO l_pml.*
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
      IF g_aza.aza08 = 'N' THEN
         LET l_pml.pml12 = ' '
         LET l_pml.pml121= ' '
      END IF
      #CALL s_get_bookno(YEAR(l_pml.pml33)) RETURNING l_flag,l_bookno1,l_bookno2   #MOD-A30154
      CALL s_get_bookno(YEAR(l_pmk.pmk31)) RETURNING l_flag,l_bookno1,l_bookno2   #MOD-A30154
      LET p_sum1 = l_pml.pml87 * l_pml.pml44
      LET p_sum2 = l_pml.pml87 * l_pml.pml44
      IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
      IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF
      #-----MOD-A30154---------
      #LET l_yy = YEAR(l_pml.pml33)
      #LET l_mm = MONTH(l_pml.pml33)
      LET l_yy = l_pmk.pmk31
      LET l_mm = l_pmk.pmk32
      #-----END MOD-A30154-----
      IF g_aaz.aaz90 = 'Y' THEN
         CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,
                          l_yy,l_pml.pml121,
                          l_pml.pml930,l_pml.pml12,
                          l_mm,'0','a',0,p_sum2,'1')
      ELSE
         CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,              
                          l_yy,l_pml.pml121,                 
                          l_pml.pml67,l_pml.pml12,                        
                          l_mm,'0','a',0,p_sum2,'1')
      END IF    #MOD-950284 
      IF g_aza.aza63 = 'Y' THEN
         IF g_aaz.aaz90 = 'Y' THEN
            CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,
                             l_yy,l_pml.pml121,
                             l_pml.pml930,l_pml.pml12,
                             l_mm,'1','a',0,p_sum2,'1')
         ELSE
            CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,              
                             l_yy,l_pml.pml121,                 
                             l_pml.pml67,l_pml.pml12,                        
                             l_mm,'1','a',0,p_sum2,'1')
         END IF        #MOD-950284
      END IF
      IF g_success = 'Y' THEN
         #同一筆單據中,有相同的預算資料
         #因為沒有確認..故耗用..會算不到其他單身中的金額,故此處卡總量
         #SELECT SUM(pml87*pml44) INTO p_sum1 FROM pml_file   #MOD-A30154
         SELECT SUM(pml87*pml44) INTO p_sum1 FROM pmk_file,pml_file   #MOD-A30154
          WHERE pml01 = l_pml.pml01
            AND pml90 = l_pml.pml90
            AND pml40 = l_pml.pml40
            AND pmk01 = pml01   #MOD-A30154
            #AND YEAR(pml33) = l_yy   #MOD-A30154
            AND pmk31 = l_yy   #MOD-A30154
            AND (pml121 = l_pml.pml121 OR pml121 IS NULL)
            AND pml67 = l_pml.pml67
            AND (pml12 = l_pml.pml12 OR pml12 IS NULL)
            #AND MONTH(pml33) = l_mm  #MOD-A30154
            AND pmk32 = l_mm   #MOD-A30154
         IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
         IF g_aaz.aaz90 = 'Y' THEN
            CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,
                             l_yy,l_pml.pml121,
                             l_pml.pml930,l_pml.pml12,
                             l_mm,'0','a',0,p_sum1,'2')
         ELSE
            CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,              
                             l_yy,l_pml.pml121,                 
                             l_pml.pml67,l_pml.pml12,                        
                             l_mm,'0','a',0,p_sum1,'2')
         END IF      #MOD-950284
         IF g_aza.aza63 = 'Y' THEN
            #SELECT SUM(pml87*pml44) INTO p_sum1 FROM pml_file   #MOD-A30154
            SELECT SUM(pml87*pml44) INTO p_sum1 FROM pmk_file,pml_file   #MOD-A30154
             WHERE pml01 = l_pml.pml01
               AND pml90 = l_pml.pml90
               AND pml401= l_pml.pml401
               AND pmk01 = pml01   #MOD-A30154
               #AND YEAR(pml33) = l_yy   #MOD-A30154
               AND pmk31 = l_yy   #MOD-A30154
               AND (pml121 = l_pml.pml121 OR pml121 IS NULL)
               AND pml67 = l_pml.pml67
               AND (pml12 = l_pml.pml12 OR pml12 IS NULL)
               #AND MONTH(pml33) = l_mm   #MOD-A30154
               AND pmk32 = l_mm   #MOD-A30154
            IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
            IF g_aaz.aaz90 = 'Y' THEN
               CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,
                                l_yy,l_pml.pml121,
                                l_pml.pml930,l_pml.pml12,
                                l_mm,'1','a',0,p_sum1,'2')
            ELSE
               CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,              
                                l_yy,l_pml.pml121,                 
                                l_pml.pml67,l_pml.pml12,                        
                                l_mm,'1','a',0,p_sum1,'2')
            END IF      #MOD-950284
         END IF
      END IF
 
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()                   #TQC-740093
 
END FUNCTION
 
FUNCTION t420sub_y1(l_pmk)
   DEFINE l_cmd         LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
   DEFINE l_str         LIKE type_file.chr4    #No.FUN-680136 VARCHAR(04)
   DEFINE l_pml         RECORD LIKE pml_file.*
   DEFINE l_pml04       LIKE pml_file.pml04
   DEFINE l_imaacti     LIKE ima_file.imaacti
   DEFINE l_ima140      LIKE ima_file.ima140
   DEFINE l_pml20       LIKE pml_file.pml20
   DEFINE l_i           LIKE type_file.num5     #FUN-710019 #FUN-730012
   DEFINE l_cnt         LIKE type_file.num5     #FUN-710019
   DEFINE l_pmk         RECORD LIKE pmk_file.*
   DEFINE l_pml24       LIKE pml_file.pml24     #FUN-730012
   DEFINE l_pml25       LIKE pml_file.pml25     #FUN-730012
   DEFINE l_pml87       LIKE pml_file.pml87     #FUN-730012
   DEFINE l_sql         STRING    #FUN-730012
 
   IF l_pmk.pmkmksg='N' AND (l_pmk.pmk25='0' OR l_pmk.pmk25='X') THEN
      LET l_pmk.pmk25='1'
      #No.FUN-A30116 ...begin
      #UPDATE pml_file SET pml16=l_pmk.pmk25
      # WHERE pml01=l_pmk.pmk01
      #LET g_sql = "UPDATE ",g_dbs,"pml_file SET pml16= '",l_pmk.pmk25,"'  ",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'pml_file'), #FUN-A50102
                  " SET pml16= '",l_pmk.pmk25,"'  ",
                  " WHERE pml01='",l_pmk.pmk01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
      PREPARE upd_pml16_pre FROM g_sql
      EXECUTE upd_pml16_pre
      #No.FUN-A30116 ...end
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("pml01",l_pmk.pmk01,"upd pml16",STATUS,1)
            #TQC-B20181 add begin-----------  
            LET g_errno=STATUS                          
	    LET g_msg1='pml_file'||'upd pml16'||g_plant_new||g_fno1
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            #TQC-B20181 add end-------------
         ELSE
            CALL cl_err3("upd","pml_file",l_pmk.pmk01,"",STATUS,"","upd pml16",1)
         END IF
         LET g_success = 'N' RETURN
      END IF
   END IF
 
      LET l_pmk.pmkcond=g_today
      LET l_pmk.pmkconu=g_user   
      LET l_pmk.pmkcont=TIME
      #No.FUN-A30116 ...begin
      #UPDATE pmk_file SET
      #       pmk25=l_pmk.pmk25,
      #       pmkconu=l_pmk.pmkconu,      #No.FUN-870007
      #       pmkcond=l_pmk.pmkcond,      #No.FUN-870007
      #       pmkcont=l_pmk.pmkcont,      #No.FUN-870007
      #       pmk18='Y'
      # WHERE pmk01 = l_pmk.pmk01
      #LET g_sql = "UPDATE ",g_dbs,"pmk_file SET ",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'pmk_file'), #FUN-A50102
                  " SET ",
                  " pmk25='",l_pmk.pmk25,"', ",
                  " pmkconu='",l_pmk.pmkconu,"', ",      #No.FUN-870007
                  " pmkcond='",l_pmk.pmkcond,"', ",      #No.FUN-870007
                  " pmkcont='",l_pmk.pmkcont,"', ",      #No.FUN-870007
                  " pmk18='Y'  ",
                  "  WHERE pmk01 = '",l_pmk.pmk01,"' " 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
      PREPARE upd_pmk_pre FROM g_sql
      EXECUTE upd_pmk_pre
      #No.FUN-A30116 ...end
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg("pmk01",l_pmk.pmk01,"upd pmk18",STATUS,1)
         #TQC-B20181 add begin-----------  
         LET g_errno=STATUS                          
	 LET g_msg1='pmk_file'||'upd pmk18'||g_plant_new||g_fno1
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
      ELSE
         CALL cl_err3("upd","pmk_file",l_pmk.pmk01,"",STATUS,"","upd pmk18",1)
      END IF
      LET g_success = 'N' RETURN
   END IF
 
#NO.FUN-710019  S/O拋P/R時，如P/R數量有更動要回寫到S/O
   
   #LET l_sql = "SELECT * FROM ",g_dbs,"oeb_file WHERE oeb01 = ?  AND oeb03 = ? FOR UPDATE"  #No.FUN-A30116 add g_dbs
   LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
               " WHERE oeb01 = ?  AND oeb03 = ? FOR UPDATE" 
   LET l_sql=cl_forupd_sql(l_sql)
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   DECLARE t420y1_cl CURSOR FROM l_sql
 
   #LET l_sql = "SELECT pml24,pml25,pml87 FROM ",g_dbs,"pml_file ", #No.FUN-A30116 add g_dbs
   LET l_sql = "SELECT pml24,pml25,pml87 FROM ",cl_get_target_table(g_plant_new,'pml_file'), #FUN-A50102
                                      " WHERE pml01='",l_pmk.pmk01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   DECLARE t420y2_cl CURSOR FROM l_sql
   FOREACH t420y2_cl INTO l_pml24,l_pml25,l_pml87
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pml_file",l_pmk.pmk01,"",STATUS,"","foreach",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      OPEN t420y1_cl USING l_pml24,l_pml25 #check DB 是否被他人鎖定
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err("OPEN t420y1_cl:", STATUS, 1)
         CLOSE t420y1_cl
         RETURN
      END IF
      CLOSE t420y1_cl  #無被鎖定就可以CLOSE
      #No.FUN-A30116 ..begin
      #UPDATE oeb_file 
      #   SET oeb28 = l_pml87
      # WHERE oeb01 = l_pml24
      #   AND oeb03 = l_pml25
      LET g_sql = " UPDATE oeb_file " ,
                  "   SET oeb28 = '",l_pml87,"' ",
                  " WHERE oeb01 = '",l_pml24,"' ",
                  "   AND oeb03 = '",l_pml25,"' "
      PREPARE upd_oeb_pre FROM g_sql
      EXECUTE upd_oeb_pre
      #No.FUN-A30116 ..end
   END FOREACH
END FUNCTION
 
FUNCTION t420sub_refresh(p_pmk01)
  DEFINE p_pmk01 LIKE pmk_file.pmk01
  DEFINE l_pmk RECORD LIKE pmk_file.*
 
  SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01=p_pmk01
  RETURN l_pmk.*
END FUNCTION
 
FUNCTION t420sub_bud(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,p_afc041,
                     p_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2,p_flag1)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE p_flag1     LIKE type_file.chr1  #1.單筆檢查 2.單身total檢查
  DEFINE p_cmd       LIKE type_file.chr1
  DEFINE p_sum1      LIKE afc_file.afc06 
  DEFINE p_sum2      LIKE afc_file.afc06 
  DEFINE l_flag      LIKE type_file.num5
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE l_over      LIKE afc_file.afc07
  DEFINE l_msg       LIKE ze_file.ze03      #FUN-890128
 
      CALL s_budchk1(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,        
                     p_afc041,p_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2)
          RETURNING l_flag,l_afb07,l_over
      IF l_flag = FALSE THEN
         LET g_success = 'N'
         LET g_showmsg = p_afc00,'/',p_afc01,'/',p_afc02,'/',
                         p_afc03 USING "<<<&",'/',p_afc04,'/',
                         p_afc041,'/',p_afc042,'/',
                         p_afc05 USING "<&",p_sum2,'/',l_over
         IF p_flag1 = '2' THEN
            LET g_errno = 'agl-232'
         END IF
         IF g_bgerr THEN
            CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05,npl05',g_showmsg,'t420sub_bud',g_errno,1)
            #TQC-B20181 add begin-----------  
            LET g_errno='agl-232'                         
	    LET g_msg1='afc_file'||'t420sub_bud'||g_plant_new||g_fno1
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            #TQC-B20181 add end-------------
         ELSE
            CALL cl_err(g_showmsg,g_errno,1)
         END IF
      ELSE
         IF l_afb07 = '2' AND l_over < 0 THEN
            IF p_flag1 = '2' THEN
               LET g_errno = 'agl-232'
            END IF
            LET g_showmsg = p_afc00,'/',p_afc01,'/',p_afc02,'/',
                            p_afc03 USING "<<<&",'/',p_afc04,'/',
                            p_afc041,'/',p_afc042,'/',
                            p_afc05 USING "<&",p_sum2,'/',l_over
            IF g_bgerr THEN
               CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05,npl05',g_showmsg,'t420sub_bud',g_errno,1)
               #TQC-B20181 add begin-----------  
               LET g_errno='agl-232'                         
	       LET g_msg1='afc_file'||'t420sub_bud'||g_plant_new||g_fno1
	       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	       LET g_msg=g_msg[1,255]
	       CALL p200_log(g_trans_no,g_plant_new,g_fno1,'02','POSFAB',g_errno,g_msg,'0','N',g_msg1)
	       LET g_errno=''
	       LET g_msg=''
	       LET g_msg1=''
               #TQC-B20181 add end-------------
            ELSE
               LET l_msg = cl_getmsg(g_errno,g_lang)
               LET l_msg = g_showmsg CLIPPED, l_msg CLIPPED
               CALL cl_msgany(10,20,l_msg)
            END IF
            LET g_errno = ' '
         END IF
      END IF
END FUNCTION
#FUNCTION t420sub_transfer(l_pmk,p_plant) #FUN-B50002 mark 
FUNCTION t420sub_transfer(l_pmk,p_plant,l_oeb03) #FUN-B50002 add
DEFINE l_ruc RECORD LIKE ruc_file.*
DEFINE l_pmk RECORD LIKE pmk_file.*
DEFINE l_flag  LIKE type_file.chr1
DEFINE l_rate  LIKE ruc_file.ruc17
DEFINE p_plant LIKE azw_file.azw01
DEFINE l_oeb03 LIKE oeb_file.oeb03 #FUN-B50002 add
       
   LET g_sql="SELECT '','',pml01,pml02,pml04,'','','',pml24,pml25,pml48,pml49,pml50,'',",
             " pml47,pml041,pml07,'',pml20,'','','','',",
             " pml51,pml52,pml53,'',pml33,pml54,'',pml191,pml55 ",        #No.FUN-9C0069
             #" FROM ",g_dbs,"pml_file WHERE pml01='",l_pmk.pmk01,"' ORDER BY pml02 "
             " FROM ",cl_get_target_table(g_plant_new,'pml_file'), #FUN-A50102
             " WHERE pml01='",l_pmk.pmk01,"'",
             " AND pml02='",l_oeb03,"'", #FUN-B50002 add
             " ORDER BY pml02 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102           
   PREPARE t420_prepsel FROM g_sql
   DECLARE t420_curssel CURSOR FOR t420_prepsel 
   FOREACH t420_curssel INTO l_ruc.*
      IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
      END IF
      SELECT ima25 INTO l_ruc.ruc13 FROM ima_file WHERE ima01=l_ruc.ruc04
      IF SQLCA.sqlcode=100 THEN LET l_ruc.ruc13=NULL END IF
      CALL s_umfchk(l_ruc.ruc04,l_ruc.ruc16,l_ruc.ruc13)
         RETURNING l_flag,l_rate
      IF l_flag='0' THEN
         LET l_ruc.ruc17=l_rate
      END IF
      LET l_ruc.ruc00='1'
      LET l_ruc.ruc01=l_pmk.pmkplant
      LET l_ruc.ruc05=g_today
      LET l_ruc.ruc06=l_pmk.pmk47
      IF cl_null(l_ruc.ruc06) THEN
         LET l_ruc.ruc06 = l_pmk.pmkplant
         LET l_ruc.ruc29 = 'Y' 
      ELSE
         LET l_ruc.ruc29 = 'N' 
      END IF
      SELECT rty04 INTO l_ruc.ruc26 FROM rty_file
       WHERE rty01=l_ruc.ruc06 AND rty02=l_ruc.ruc04
      LET l_ruc.ruc07=l_pmk.pmk46
      IF l_pmk.pmk46='1' THEN
         LET l_ruc.ruc08=l_pmk.pmk01
         LET l_ruc.ruc09=l_ruc.ruc03
      END IF
      LET l_ruc.ruc19='0'
      LET l_ruc.ruc20='0'
      LET l_ruc.ruc21='0'
      LET l_ruc.ruc22=NULL
      IF l_ruc.ruc12='2' OR l_ruc.ruc12='3' OR l_ruc.ruc12 ='4' THEN  #No.FUN-A10037
         INSERT INTO ruc_file VALUES(l_ruc.*) 
         IF STATUS THEN                                                                                                       
            CALL cl_err3("ins","ruc_file",l_pmk.pmk01,"",SQLCA.sqlcode,"","",1) 
            EXIT FOREACH                                                                                              
         END IF
      END IF
      IF NOT cl_null(l_ruc.ruc23) AND l_ruc.ruc23<>p_plant THEN #No.FUN-A30116
       #LET g_sql =" UPDATE ",g_dbs,"pml_file SET pml11='Y' WHERE pml01='",l_ruc.ruc02,"' AND pml02='",l_ruc.ruc03,"' "
       LET g_sql =" UPDATE ",cl_get_target_table(g_plant_new,'pml_file'), #FUN-A50102
                  " SET pml11='Y' WHERE pml01='",l_ruc.ruc02,"' AND pml02='",l_ruc.ruc03,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
       PREPARE upd_pml11_pre FROM g_sql
       EXECUTE upd_pml11_pre 
         IF STATUS THEN                                                                                                             
            CALL cl_err3("upd","pml_file",l_pmk.pmk01,"",SQLCA.sqlcode,                                                             
                               "","",1)                                                                                             
            EXIT FOREACH                                                                                                            
         END IF    
      END IF 
      INITIALIZE l_ruc.* TO NULL 
   END FOREACH                             
END FUNCTION
#No.FUN-9C0071 ---------------------精簡程式------------------------
#No.FUN-A30116
