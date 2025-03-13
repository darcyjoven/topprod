# Prog. Version..: '5.30.07-13.05.31(00010)'     #
# Modify.........: NO:FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No:FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No:FUN-680034 06/08/25 By douzh 增加"票據科目編號二","對方科目編號二"欄位(nmh261,nmh271)
# Modify.........: No:FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No:FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No:FUN-710024 07/01/30 By Jackho 增加批處理錯誤統整功能
# Modify.........: No:FUN-740028 07/04/11 By lora  會計科目加帳套 
# Modify.........: No.FUN-9A0036 10/01/18 By chenmoyan 勾選二套帳時，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: NO.FUN-A40033 10/04/20 BY chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯兌損益時要切立科目
# Modify.........: No.FUN-A40067 10/05/04 By chenmoyan 處理第二套中本幣金額取位
# Modify.........: No:FUN-AA0087 10/11/01 By Summer 異動碼類型設定改善
# Modify.........: No.FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:TQC-B70197 11/07/27 By guoch 在大陸中恢復託收功能
# Modify.........: No:TQC-B80087 11/08/08 By Dido npplegal/npqlegal 給予預設值 
# Modify.........: No:MOD-CC0012 12/12/03 By yinhy 增加關係人核算項帶出功能
# Modify.........: No:MOD-CC0191 12/12/21 By Polly 產生貸方分錄前先將殘值清空
# Modify.........: No:MOD-D20041 12/12/03 By yinhy 補充MOD-CC0012關係人核算項帶出功能
# Modify.........: No.FUN-D10065 13/01/17 By wangrr 在調用s_def_npq前npq04=NULL
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds

GLOBALS "../../config/top.global"
   DEFINE g_nmh		RECORD LIKE nmh_file.*
   DEFINE g_nms		RECORD LIKE nms_file.*
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_trno	LIKE nmh_file.nmh01
   DEFINE g_chr         LIKE type_file.chr1    #No.FUN-680107 CHAR(1)
   DEFINE g_msg         LIKE type_file.chr1000 #No.FUN-680107 CHAR(72)
   DEFINE g_flag        LIKE type_file.chr1    #No.FUN-740028                                                                       
   DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-740028                                                                       
   DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-740028   
   DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-740028 
   DEFINE g_npq25       LIKE npq_file.npq25    #No.FUN-9A0036
   DEFINE g_azi04_2     LIKE azi_file.azi04    #FUN-A40067   
   DEFINE g_aag44       LIKE aag_file.aag44    #FUN-D40118 add
   
FUNCTION s_t200_gl(p_trno,p_npptype)
   DEFINE p_trno	LIKE nmh_file.nmh01
   DEFINE p_npptype     LIKE npp_file.npptype  #FUN-680034
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-680107 CHAR(70)
   DEFINE g_dept        LIKE nmh_file.nmh15
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-680107 SMALLINT

   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_trno = p_trno
   IF g_trno IS NULL THEN RETURN END IF
   IF p_npptype='0' THEN                      #FUN-680034
      SELECT COUNT(*) INTO l_n FROM npp_file 
       WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_trno AND npp011=1
         AND nppglno != '' AND nppglno IS NOT NULL
      IF l_n > 0 THEN
     #-----No.FUN-710024-----begin
      IF g_bgerr THEN
         CALL s_errmsg('npp01',g_trno,g_trno,'aap-122',1)
      ELSE
         CALL cl_err(g_trno,'aap-122',1)
      END IF
      #-----No.FUN-710024 -----end
         LET g_success='N'                       #FUN-680034
         RETURN
      END IF
   END IF                                     #FUN-680034     
   SELECT COUNT(*) INTO l_n FROM npp_file WHERE nppsys = 'NM' AND npp00 = 2
                                            AND npp01  = g_trno
                                            AND npp011 = 1
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_trno) THEN RETURN END IF #Genero
   END IF
   SELECT nmh_file.* INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_trno 
   IF STATUS THEN 
#     CALL cl_err('sel nmh',STATUS,1) FUN-660148
      #-----No.FUN-710024-----begin
      IF g_bgerr THEN
         CALL s_errmsg('nmh01',g_trno,'sel nmh',STATUS,1)
      ELSE
         CALL cl_err3("sel","nmh_file",g_trno,"",STATUS,"","sel nmh",1)     #FUN-660148
      END IF
      #-----No.FUN-710024 -----end
   END IF
   IF g_nmh.nmh38 = 'X' THEN CALL cl_err('','9024',1) RETURN END IF
  
   IF g_nmz.nmz11 = 'Y' THEN
      LET g_dept = g_nmh.nmh15
   ELSE
      LET g_dept = ' '
   END IF
   SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
   DELETE FROM npp_file 
        WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_trno AND npp011=1
        AND npptype=p_npptype              #FUN-680034      
   DELETE FROM npq_file                    
        WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_trno AND npq011=1
        AND npqtype=p_npptype              #FUN-680034 
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_trno
   #FUN-B40056--add--end--

#  CALL s_t200_gl_11()                     #FUN-680034
   CALL s_t200_gl_11(p_npptype)            #FUN-680034 
   CALL s_t200_diff()                      #FUN-A40033      
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  #TQC-B70197
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION

FUNCTION s_t200_gl_11(p_npptype)
   DEFINE g_aag05     LIKE aag_file.aag05
   DEFINE p_npptype   LIKE npp_file.npptype  #FUN-680034
   DEFINE l_aaa03     LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE l_occ37     LIKE occ_file.occ37    #MOD-CC0012
   DEFINE l_aag371    LIKE aag_file.aag371   #MOD-CC0012
   DEFINE l_flag      LIKE type_file.chr1    #FUN-D40118 add

   INITIALIZE g_npp.* TO NULL
   INITIALIZE g_npq.* TO NULL

   LET g_npp.nppsys = 'NM'
   LET g_npp.npp00  = 2
   LET g_npp.npp01  = g_nmh.nmh01
   LET g_npp.npp011 = 1
   LET g_npp.npp02 = g_nmh.nmh04
   LET g_npp.npp03 = NULL
   LET g_npp.npptype=p_npptype                 #FUN-680034
   LET g_npp.npplegal= g_legal                 #TQC-B80087
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660148
      #-----No.FUN-710024-----begin
      IF g_bgerr THEN
         CALL s_errmsg('npp01',g_npp.npp01,'ins npp',STATUS,1)
      ELSE
         CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp",1) #No.FUN-660148
      END IF
      #-----No.FUN-710024 -----end
      LET g_success='N' #no.5573
   END IF

   LET g_npq.npqsys = 'NM' 
   LET g_npq.npq00  = 2
   LET g_npq.npq01  = g_nmh.nmh01
   LET g_npq.npq011 = 1
   LET g_npq.npq02  = 0
   LET g_npq.npq24  = g_nmh.nmh03 
   LET g_npq.npq25  = g_nmh.nmh28
   LET g_npq25      = g_npq.npq25         #FUN-9A0036
   LET g_npq.npqtype=p_npptype            #TQC-B80087
   LET g_npq.npqlegal= g_legal            #TQC-B80087
   
  #借方科目產生
   LET g_npq.npq02 = g_npq.npq02 + 1
   LET g_npq.npq21 = g_nmh.nmh11 
   LET g_npq.npq22 = g_nmh.nmh30 
   LET g_npq.npq06 = '1'
#FUN-680034--begin
#  LET g_npq.npq03 = g_nmh.nmh26 
   IF p_npptype ='0' THEN
       LET g_npq.npq03 = g_nmh.nmh26
      ELSE
       LET g_npq.npq03 = g_nmh.nmh261
      END IF
#FUN-680034--end 
   IF cl_null(g_npq.npq03) THEN 
      LET g_npq.npq03=g_nms.nms22
   END IF
   LET g_npq.npq04 =  NULL            #MOD-CC0191 add
   LET g_npq.npq07f= g_nmh.nmh02
   LET g_npq.npq07 = g_nmh.nmh32
   LET g_aag05 = NULL
   LET l_aag371 = NULL  #MOD-CC0012
  #No.FUN-740028 --begin                                                                                                   
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
   IF g_flag = '1' THEN                                                                                                     
      CALL cl_err(YEAR(g_nmh.nmh04),'aoo-081',1)                                                                            
      LET g_success = 'N'                                                                                                   
   END IF                                                                                                                   
   IF g_npq.npqtype = '0' THEN                                                                                              
      LET g_bookno3 = g_bookno1                                                                                             
   ELSE                                                                                                                     
      LET g_bookno3 = g_bookno2                                                                                             
   END IF                                                                                                                   
  #No.FUN-740028 --end     
   SELECT aag05,aag371 INTO g_aag05,l_aag371 FROM aag_file  #MOD-CC0012 add aag371
    WHERE aag01 = g_npq.npq03
      AND aag00 = g_bookno1      #No.FUN-740028
   IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
      LET g_npq.npq05 = ' '
   END IF
   #No.8662
   IF g_aag05 = 'Y' THEN
      LET g_npq.npq05 = g_nmh.nmh15
   END IF
   #No.8662(end)
   MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
   IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
   LET g_npq.npq04=NULL #FUN-D10065
   # NO:FUN-5C0015 --start--
#  CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)   #No.FUN-740028
    RETURNING  g_npq.*
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087 add
   # NO:FUN-5C0015 ---end---
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
#FUN-A40067 --Begin
      SELECT aaa03 INTO l_aaa03 FROM aaa_file 
       WHERE aaa01 = g_bookno2
      SELECT azi04 INTO g_azi04_2 FROM azi_file
       WHERE azi01 = l_aaa03
#FUN-A40067 --End   
      CALL s_newrate(g_bookno1,g_bookno2,
                     g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067      
   END IF
#No.FUN-9A0036 --End
   #No.MOD-CC0012  --Begin
   IF l_aag371 MATCHES '[234]' THEN
      SELECT occ37 INTO l_occ37 FROM occ_file
       WHERE occ01 = g_nmh.nmh11
      IF l_aag371=2 OR l_aag371=3 THEN
         LET g_npq.npq37 = g_nmh.nmh11
      ELSE
        IF l_occ37 = 'Y' THEN
           LET g_npq.npq37 = g_nmh.nmh11
        ELSE
           LET g_npq.npq37 = ''
        END IF
      END IF
   END IF
   #No.MOD-CC0012  --End
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = g_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
   #FUN-D40118--add--end--
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN 
#     CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660148
      #-----No.FUN-710024-----begin
      IF g_bgerr THEN
         LET g_showmsg=g_npq.npq00,"/",g_npq.npq01
         CALL s_errmsg('npp00,npq01',g_showmsg,'ins npq#1',STATUS,1)
      ELSE
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#1",1) #No.FUN-660148
      END IF
      #-----No.FUN-710024 -----end
      LET g_success='N' #no.5573
   END IF

  #貸方科目產生
   LET g_npq.npq02 = g_npq.npq02 + 1
   LET g_npq.npq06 = '2'
#FUN-680034--begin
#  LET g_npq.npq03 = g_nmh.nmh27 
   IF p_npptype ='0' THEN
      LET g_npq.npq03 = g_nmh.nmh27
   ELSE
      LET g_npq.npq03 = g_nmh.nmh271
   END IF
#FUN-680034--end
   IF cl_null(g_npq.npq03) THEN
#FUN-680034--begin 
#     LET g_npq.npq03=g_nms.nms21
      IF p_npptype='0' THEN
         LET g_npq.npq03=g_nms.nms21
      ELSE
         LET g_npq.npq03=g_nms.nms211
      END IF
#FUN-680034--end
   END IF
   LET g_npq.npq07f= g_nmh.nmh02
   LET g_npq.npq07 = g_nmh.nmh32
   LET g_aag05 = NULL
   LET l_aag371 = NULL  #MOD-D20041
   #No.FUN-740028 --begin                                                                                                           
           CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
           IF g_flag = '1' THEN                                                                                                     
              CALL cl_err(YEAR(g_nmh.nmh04),'aoo-081',1)                                                                            
              LET g_success = 'N'                                                                                                   
           END IF                                                                                                                   
           IF g_npq.npqtype = '0' THEN                                                                                              
              LET g_bookno3 = g_bookno1                                                                                             
           ELSE                                                                                                                     
              LET g_bookno3 = g_bookno2                                                                                             
           END IF                                                                                                                   
   #No.FUN-740028 --end                 
   SELECT aag05,aag371 INTO g_aag05,l_aag371 FROM aag_file   #MOD-CC0012 add aag371
    WHERE aag01 = g_npq.npq03
      AND aag00 = g_bookno1       #No.FUN-740028
   IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
      LET g_npq.npq05 = ' '
   END IF
   #No.8662
   IF g_aag05 = 'Y' THEN
      LET g_npq.npq05 = g_nmh.nmh15
   END IF
   #No.8662(end)
   MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
   IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
   LET g_npq.npq04=NULL #FUN-D10065
   # NO:FUN-5C0015 --start--
#  CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740028
    RETURNING  g_npq.*
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087 add
   # NO:FUN-5C0015 ---end---
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
#FUN-A40067 --Begin
      SELECT aaa03 INTO l_aaa03 FROM aaa_file 
       WHERE aaa01 = g_bookno2
      SELECT azi04 INTO g_azi04_2 FROM azi_file
       WHERE azi01 = l_aaa03
#FUN-A40067 --End   
      CALL s_newrate(g_bookno1,g_bookno2,
                     g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067      
   END IF
#No.FUN-9A0036 --End
   #No.MOD-CC0012  --Begin
   IF l_aag371 MATCHES '[234]' THEN
      SELECT occ37 INTO l_occ37 FROM occ_file
       WHERE occ01 = g_nmh.nmh11
      IF l_aag371=2 OR l_aag371=3 THEN
         LET g_npq.npq37 = g_nmh.nmh11
      ELSE
        IF l_occ37 = 'Y' THEN
           LET g_npq.npq37 = g_nmh.nmh11
        ELSE
           LET g_npq.npq37 = ''
        END IF
      END IF
   END IF
   #No.MOD-CC0012  --End
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = g_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
   #FUN-D40118--add--end-- 
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN 
#     CALL cl_err('ins npq#2',STATUS,1)    #No.FUN-660148
      #-----No.FUN-710024-----begin
      IF g_bgerr THEN
         LET g_showmsg=g_npq.npq00,"/",g_npq.npq01
         CALL s_errmsg('npp00,npq01',g_showmsg,'ins npq#2',STATUS,1)
      ELSE
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#2",1) #No.FUN-660148
      END IF
      #-----No.FUN-710024 -----end
      LET g_success='N' #no.5573
   END IF

END FUNCTION

#FUN-A40033 --Begin
FUNCTION s_t200_diff() #處理第二套帳由于匯率問題，會存在帳不平的可能   
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
      IF g_flag = '1' THEN                                                                                                     
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)                                                                            
         LET g_success = 'N'                                                                                                   
      END IF                                                                                                                   
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp.npp00
            AND npq01 = g_npp.npp01
            AND npq011= g_npp.npp011
            AND npqsys= g_npp.nppsys
         LET l_npq1.npqtype = g_npp.npptype
         LET l_npq1.npq00 = g_npp.npp00
         LET l_npq1.npq01 = g_npp.npp01
         LET l_npq1.npq011= g_npp.npp011
         LET l_npq1.npqsys= g_npp.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq04 = NULL                 #MOD-CC0191 add
         LET l_npq1.npq07f = l_npq1.npq07
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq1.npq00,"/",l_npq1.npq01
               CALL s_errmsg('npp00,npq01',g_showmsg,'ins npq#1',STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq1.npq00,l_npq1.npq01,STATUS,"","ins npq#1",1) #No.FUN-660148
            END IF
            LET g_success='N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
