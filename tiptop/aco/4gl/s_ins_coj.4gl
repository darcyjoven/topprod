# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name ..: s_ins_coj                  
# DESCRIPTION....: 產生合同進口材料檔(coj_file)
# Parmeter.......: p_key  申請單號(coi01)
#                  p_cmd  0->acot300 1->acot301
# Date & Author..: 00/06/13 By Kammy
# Modify.........: No.MOD-490398 04/11/16 By Carrier add coi05
# Modify.........: No.TQC-660045 06/06/12 By Czl cl_err-->cl_err3
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-740287 07/04/30 By Carol p_zaa未建立資料會出現error->不用cl_outname() 了  
# Modify.........: No.FUN-980002 09/08/06 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910088 12/01/11 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE 
   g_key  LIKE coi_file.coi01,
   l_coj  RECORD LIKE coj_file.*,
   l_coi  RECORD LIKE coi_file.*,
   l_cog  RECORD LIKE cog_file.*,
   l_name LIKE type_file.chr20                  #No.FUN-680069 VARCHAR(20)
 
FUNCTION s_ins_coj(p_key,p_cmd)
   DEFINE p_key    LIKE coi_file.coi01
   DEFINE p_cmd    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
   DEFINE l_coh03  LIKE coh_file.coh03 
   DEFINE l_coh041 LIKE coh_file.coh041       
   DEFINE l_coh05  LIKE coh_file.coh05
   DEFINE l_coh04  LIKE coh_file.coh04          #No.MOD-490398
   DEFINE l_coi04  LIKE coi_file.coi04
   DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(300)
   DEFINE sr  RECORD 
              con03  LIKE con_file.con03,
              con04  LIKE con_file.con04,
              con05  LIKE con_file.con05,
              con06  LIKE con_file.con06,
              con07  LIKE con_file.con07,
              con08  LIKE con_file.con08,        #No.MOD-490398
              qty    LIKE oeb_file.oeb12         #No.FUN-680069 DEC(12,3)
              END RECORD
 
   SELECT MAX(coj01) INTO g_key FROM coj_file WHERE coj01=p_key
   IF p_cmd='1' AND NOT cl_null(g_key) THEN
      IF NOT cl_confirm('aco-003') THEN RETURN END IF
   END IF
   IF p_cmd='0' AND NOT cl_null(g_key) THEN RETURN END IF
   #---------------------------------------------------------------------------
   INITIALIZE l_coj.* TO NULL
   LET g_success='Y' 
   LET g_key = p_key
    
   BEGIN WORK
   DELETE FROM coj_file WHERE coj01=p_key
   DELETE FROM coi_file WHERE coi01=p_key
 
   #產生單頭
   SELECT * INTO l_cog.* FROM cog_file
    WHERE cog01 = p_key
      AND cogacti !='N'   #010807增 
      AND cogconf !='X'   #CHI-C80041
   LET l_coi.coi01 = l_cog.cog01
   LET l_coi.coi02 = g_today
   LET l_coi.coi03 = l_cog.cog03
    LET l_coi.coi05 = l_cog.cog05   #No.MOD-490398
   LET l_coi.coi04 = 0
   LET l_coi.coiconf = 'N'
   LET l_coi.coiacti = 'Y'
   LET l_coi.coiuser = g_user
   LET g_data_plant = g_plant #FUN-980030
   LET l_coi.coigrup = g_grup
   LET l_coi.coidate = g_today
   LET l_coi.coiplant = g_plant #FUN-980002
   LET l_coi.coilegal = g_legal #FUN-980002
 
   LET l_coi.coioriu = g_user      #No.FUN-980030 10/01/04
   LET l_coi.coiorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO coi_file VALUES (l_coi.*)
   IF STATUS THEN
#      CALL cl_err('ins coi',STATUS,0) #No.TQC-660045
       CALL cl_err3("ins","coi_file",l_coi.coi01,"",STATUS,"","ins coi",0) #NO.TQC-660045
      LET g_success='N'
      ROLLBACK WORK
   END IF
 
   LET l_sql = " SELECT con03,con04,con05,con06,con07,con08,0 ",
               "   FROM con_file,com_file ",
               "  WHERE con01 = com01 ",
               "    AND con013= com02 ",
                "    AND con08 = com03 ",     #No.MOD-490398
               "    AND con01 = ? ",
               "    AND com02 = ? ",
                "    AND com03 = ? ",         #No.MOD-490398
               "    AND comacti !='N' ", #010806增
               " ORDER BY con03 "
 
   PREPARE con_pre FROM l_sql
   DECLARE con_cs CURSOR FOR con_pre
   
#  CALL cl_outnam('acot300') RETURNING l_name  #TQC-740287 mark
   START REPORT inscoj_rep TO 'acot300.out'    #TQC-740287 l_name->'acot300.out'
 
   DECLARE coh_cs CURSOR FOR 
     SELECT coh03,coh041,coh04,coh05 FROM coh_file WHERE coh01=p_key  #No.MOD-490398
    FOREACH coh_cs INTO l_coh03,l_coh041,l_coh04,l_coh05        #No.MOD-490398
      IF SQLCA.sqlcode THEN 
         CALL cl_err('coh_cs',SQLCA.sqlcode,0) EXIT FOREACH 
      END IF
       FOREACH con_cs USING l_coh03,l_coh041,l_coh04 INTO sr.*    #No.MOD-490398
          IF SQLCA.sqlcode THEN 
             CALL cl_err('con_cs',SQLCA.sqlcode,0) EXIT FOREACH 
          END IF
           LET sr.qty = l_coh05 * (sr.con05/(1-(sr.con06/100)))   #No.MOD-490398
          OUTPUT TO REPORT inscoj_rep(sr.*)
      END FOREACH
   END FOREACH
   FINISH REPORT inscoj_rep
 
   #回寫單頭進口總值
   SELECT SUM(coj08) INTO l_coi04 FROM coj_file
    WHERE coj01=p_key
   IF cl_null(l_coi04) THEN LET l_coi04=0 END IF
   UPDATE coi_file SET coi04=l_coi04
    WHERE coi01=p_key
   IF STATUS THEN
#      CALL cl_err('upd coi04:',STATUS,0)  #No.TQC-660045
       CALL cl_err3("upd","coi_file",p_key,"",STATUS,"","upd coi04:",0) #NO.TQC-660045
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(1)
   ELSE 
      ROLLBACK WORK
      CALL cl_rbmsg(1)
   END IF
END FUNCTION
 
REPORT inscoj_rep(sr)
   DEFINE l_cur LIKE coc_file.coc02
   DEFINE sr  RECORD
              con03  LIKE con_file.con03,
              con04  LIKE con_file.con04,
              con05  LIKE con_file.con05,
              con06  LIKE con_file.con06,
              con07  LIKE con_file.con07,
              con08  LIKE con_file.con08,        #No.MOD-490398
              qty    LIKE oeb_file.oeb12         #No.FUN-680069 dec(12,3)
              END RECORD 
 
   OUTPUT TOP MARGIN g_top_margin 
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
 
   ORDER EXTERNAL BY sr.con03
 
   FORMAT  
      AFTER GROUP OF sr.con03
         INITIALIZE l_coj.* TO NULL
         LET l_coj.coj01= g_key
         SELECT MAX(coj02)+1 INTO l_coj.coj02 FROM coj_file
          WHERE coj01=l_coj.coj01
         IF cl_null(l_coj.coj02) THEN LET l_coj.coj02=1 END IF
         LET l_coj.coj03=sr.con03
          LET l_coj.coj04=sr.con08          #No.MOD-490398
         LET l_coj.coj05= GROUP SUM(sr.qty)
         LET l_coj.coj06=sr.con04
         LET l_coj.coj05 = s_digqty(l_coj.coj05,l_coj.coj06)    #FUN-910088--add--
 
         SELECT coc02 INTO l_cur FROM coc_file
           WHERE coc03 = l_coi.coi03        #No.MOD-490398
            AND cocacti !='N' #010807 增
         SELECT cof03 INTO l_coj.coj07 FROM cof_file
          WHERE cof01 = sr.con03
            AND cof02 = l_cur
         IF cl_null(l_coj.coj07) THEN LET l_coj.coj07 = 0 END IF
     
         LET l_coj.coj08 = l_coj.coj05 * l_coj.coj07
         LET l_coj.coj09 = 0 
         LET l_coj.cojplant = g_plant #FUN-980002
         LET l_coj.cojlegal = g_legal #FUN-980002
  
         INSERT INTO coj_file VALUES (l_coj.*)
         IF STATUS THEN 
#            CALL cl_err(sr.con03,STATUS,1) #No.TQC-660045
             CALL cl_err3("ins","coj_file",l_coj.coj01,l_coj.coj02,STATUS,"","",1) #NO.TQC-660045
            LET g_success='N'  
         END IF
END REPORT
