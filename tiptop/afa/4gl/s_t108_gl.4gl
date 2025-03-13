# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify.........: No.MOD-4A0173 04/10/12 By Kitty 產生分錄有誤
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-580148 05/08/19 By Smapmin 分錄底稿產生時,若會計科目不用輸入部門,則不給部門
# Modify.........: No.FUN-5B0051 05/11/30 By Sarah 當fbh07(累折)=0時,不insert npq_file
# Modify.........: NO.FUN-5C0015 05/12/20 By alana
# call s_def_npq.4gl 抓取異動碼default值
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/18 By Ray 多帳套修改
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah s_def_npq()時,p_key2的地方改成傳fbh02
# Modify.........: No.FUN-710028 07/02/01 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-740020 07/04/13 By atsea 會計科目加帳套
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0028 09/11/06 By liuxqa sql语法错误。
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-AA0087 11/01/28 By Mengxw 異動碼類型設定的改善
# Modify.........: No.FUN-AB0088 11/04/01 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3處理的地方加npptype判斷
# Modify.........: No.MOD-C70303 12/08/01 By Polly 財簽二幣別抓取改為faa02c
# Modify.........: No.MOD-C80200 12/10/31 By Polly 1.當npq07大於零時，才可寫入npq_file
#                                                  2.貸方科目npq03為faj53時，npq07f/npq07需再扣fbh1
# Modiyf.........: No.MOD-D20058 13/02/18 By Polly 給予g_npq25初怡值
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
#   DEFINE g_no	        LIKE type_file.chr20            #No.FUN-680070 VARCHAR(10)
   DEFINE g_no	        LIKE type_file.chr20      #No.FUN-550034          #No.FUN-680070 VARCHAR(16)
   DEFINE g_date        LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE g_type  	LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE g_chr         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE g_msg         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
   DEFINE g_npq25       LIKE npq_file.npq25         #No.FUN-9A0036
   DEFINE g_azi04_2     LIKE azi_file.azi04         #FUN-A40067
   DEFINE g_bookno      LIKE aag_file.aag00         #FUN-D10065 add
 
FUNCTION t108_gl(p_type,p_no,p_date,p_npptype,p_bookno)     #No.FUN-680028   #No.FUN-740020--add pbookno
   DEFINE p_type  	LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
#   DEFINE p_no    	LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
   DEFINE p_no    	LIKE type_file.chr20      #No.FUN-55034       #No.FUN-680070 VARCHAR(16)
   DEFINE p_date  	LIKE type_file.dat           #No.FUN-680070 DATE
   DEFINE p_npptype     LIKE npp_file.npptype     #No.FUN-680028
   DEFINE l_buf		LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(70)
   DEFINE l_chr         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE l_n  		LIKE type_file.num5         #No.FUN-680070 SMALLINT
#   DEFINE l_t1          LIKE type_file.chr3         #No.FUN-680070 VARCHAR(03)
   DEFINE l_t1          LIKE type_file.chr5        #No.FUN-550034          #No.FUN-680070 VARCHAR(05)
   DEFINE l_fahdmy3     LIKE fah_file.fahdmy3
   DEFINE p_bookno      LIKE aag_file.aag00          #No.FUN-640020
 
   WHENEVER ERROR CONTINUE
   LET g_no = p_no LET g_date = p_date LET g_type = p_type
   IF cl_null(g_no) THEN RETURN END IF
   IF p_npptype = "0" THEN   #FUN-B60140   ---Add
      IF p_date < g_faa.faa09 THEN   #立帳日期小於關帳日期
         CALL cl_err(g_no,'aap-176',1) RETURN 
      END IF
    #FUN-B60140   ---start   Add
     ELSE
        IF p_date < g_faa.faa092 THEN   #立帳日期小於關帳日期
           CALL cl_err(g_no,'aap-176',1)
           RETURN
        END IF
     END IF
    LET g_bookno = p_bookno  #FUN-D10065 add
    #FUN-B60140   ---end     Add
#   LET l_t1 = p_no[1,3]
   LET l_t1 = s_get_doc_no(p_no)       #No.FUN-550034
   LET l_fahdmy3 = ' '
  #SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1 #FUN-C30313 mark
#FUN-C30313---add---START-----
   IF p_npptype = '0' THEN
      SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
   ELSE
      SELECT fahdmy32 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
   END IF
#FUN-C30313---add---END-------
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel fah:',STATUS,0)  #No.FUN-660136
      CALL cl_err3("sel","fah_file",l_t1,"",STATUS,"","sel fah:",0)   #No.FUN-660136
   END IF
   #---->O否拋轉傳票
   IF l_fahdmy3 != 'Y' THEN RETURN END IF
{
   IF p_date <= g_ooz.ooz09 THEN RETURN END IF
}
   IF g_type = '1' THEN
      SELECT COUNT(*) INTO l_n FROM npq_file WHERE npq01 = g_no 
                                               AND npqsys = 'FA'
                                               AND npq00 = 5
                                               AND npq011 = 1
   ELSE
      SELECT COUNT(*) INTO l_n FROM npq_file WHERE npq01 = g_no 
                                               AND npqsys = 'FA'
                                               AND npq00 = 6
                                               AND npq011 = 1
   END IF
   IF l_n > 0 THEN
      IF p_npptype = '0' THEN     #No.FUN-680028
         IF NOT s_ask_entry(g_no) THEN RETURN END IF #Genero
         #FUN-B40056--add--str--
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM tic_file
          WHERE tic04 = g_no
         IF l_n > 0 THEN
            IF NOT cl_confirm('sub-533') THEN
               RETURN
            END IF
         END IF
         #FUN-B40056--add--end--
      END IF     #No.FUN-680028
   END IF
   IF g_type = '1' THEN
      DELETE FROM npp_file WHERE npp01 = g_no AND npp00 = 5 AND nppsys = 'FA'
                             AND npp011 = 1
                             AND npptype = p_npptype     #No.FUN-680028
      DELETE FROM npq_file WHERE npq01 = g_no AND npq00 = 5 AND npqsys = 'FA'
                             AND npq011 = 1
                             AND npqtype = p_npptype     #No.FUN-680028
   ELSE
      DELETE FROM npp_file WHERE npp01 = g_no AND npp00 = 6 AND nppsys = 'FA'
                             AND npp011 = 1
                             AND npptype = p_npptype     #No.FUN-680028
      DELETE FROM npq_file WHERE npq01 = g_no AND npq00 = 6 AND npqsys = 'FA'
                             AND npq011 = 1
                             AND npqtype = p_npptype     #No.FUN-680028
   END IF
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_no
   #FUN-B40056--add--end--
   CALL s_t108(p_npptype,p_bookno)     #No.FUN-680028    #No.FUN-740020 add p_bookno
   IF g_type = '1' THEN
      DELETE FROM npq_file WHERE npq01=g_no    AND npq03='-'
                             AND npqsys = 'FA' AND npq00 = 5 AND npq011 = 1
                             AND npqtype = p_npptype     #No.FUN-680028
   ELSE
      DELETE FROM npq_file WHERE npq01=g_no    AND npq03='-'
                             AND npqsys = 'FA' AND npq00 = 6 AND npq011 = 1
                             AND npqtype = p_npptype     #No.FUN-680028
   END IF
   CALL s_t108_diff() #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021   
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
   
FUNCTION s_t108(p_npptype,p_bookno)    #No.FUN-740020 
DEFINE p_npptype  LIKE npp_file.npptype     #No.FUN-680028 
DEFINE l_fbz      RECORD LIKE fbz_file.*,
       l_fbh      RECORD LIKE fbh_file.*,
       l_fbh06    LIKE fbh_file.fbh06,
       l_fbh07    LIKE fbh_file.fbh07,
       l_fbh08    LIKE fbh_file.fbh08,
       l_faj23    LIKE faj_file.faj23,
       l_faj24    LIKE faj_file.faj24,
       l_faj53    LIKE faj_file.faj53,
       l_faj54    LIKE faj_file.faj54,
       l_aag05    LIKE aag_file.aag05,    #No:7833
       l_faj531   LIKE faj_file.faj531,   #No.FUN-680028
       l_faj541   LIKE faj_file.faj541,   #No.FUN-680028
       l_fab24    LIKE fab_file.fab24,    #No:A099
       l_fab241   LIKE fab_file.fab241,   #No.FUN-680028
       l_sql      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(600)
DEFINE p_bookno   LIKE aag_file.aag00          #No.FUN-640020
DEFINE l_bookno1  LIKE aag_file.aag00     #No.FUN-9A0036
DEFINE l_bookno2  LIKE aag_file.aag00     #No.FUN-9A0036
DEFINE l_flag1    LIKE type_file.chr1     #No.FUN-9A0036
DEFINE l_aaa03    LIKE aaa_file.aaa03     #FUN-A40067
#FUN-AB0088---add---str---
DEFINE l_faj232   LIKE faj_file.faj232
DEFINE l_faj242   LIKE faj_file.faj242
DEFINE l_fbh062   LIKE fbh_file.fbh062
DEFINE l_fbh072   LIKE fbh_file.fbh072
DEFINE l_fbh082   LIKE fbh_file.fbh082
DEFINE l_fbh122   LIKE fbh_file.fbh122
#FUN-AB0088---add---end---
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

 
   #-------------(單頭)-----------------------------------
   CALL s_get_bookno(YEAR(g_date)) RETURNING l_flag1,l_bookno1,l_bookno2 #No.FUN-A90036
   LET l_bookno2 = g_faa.faa02c                                          #MOD-C70303 add
   LET g_npp.nppsys = 'FA'        
   IF g_type = '1' THEN LET g_npp.npp00 = 5 ELSE LET g_npp.npp00 = 6 END IF
   LET g_npp.npp01  = g_no        LET g_npp.npp011= 1
   LET g_npp.npp02  = g_date      LET g_npp.npp03 = g_date
   LET g_npp.npptype = p_npptype     #No.FUN-680028
   LET g_npp.npplegal= g_legal       #FUN-980003 add
  #No.FUN-D40118 ---Add--- Start
   IF g_npp.npptype = '1' THEN
      LET g_bookno = l_bookno2
   ELSE
      LET g_bookno = l_bookno1
   END IF
  #No.FUN-D40118 ---Add--- End
 
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660136
      CALL cl_err3("ins","npp_file",g_npp.npp01,g_npp.npp02,STATUS,"","ins npp",1)   #No.FUN-660136
      LET g_success='N' #no.5573
   END IF
 
   #-------------(單身)-----------------------------------
   LET g_npq.npqsys = 'FA'   
   IF g_type = '1' THEN LET g_npq.npq00 = 5 ELSE LET g_npq.npq00 = 6 END IF
   LET g_npq.npq01 = g_no         LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0            LET g_npq.npq04 = NULL        
   LET g_npq.npq21 = NULL         LET g_npq.npq22 = NULL 
   LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1          
   LET g_npq.npqtype = p_npptype                              #No.FUN-680028
   LET g_npq.npqlegal= g_legal                                #FUN-980003 add
   LET g_npq25 = g_npq.npq25                                  #MOD-D20058 add
 
   SELECT * INTO l_fbz.* FROM fbz_file WHERE fbz00 = '0' 
   IF SQLCA.sqlcode THEN 
      # 收益                    損失 
      LET l_fbz.fbz11 = ' ' LET l_fbz.fbz12 = ' ' 
   END IF
 
   #No:A099
   LET l_sql = "SELECT fbh_file.*,faj23,faj24,faj53,faj531,faj54,faj541,fab24,fab241, ",     #No.FUN-680028
               "       faj232,faj242,fbh062,fbh072,fbh122 ",    #FUN-AB0088 add
               "  FROM fbh_file,faj_file LEFT OUTER JOIN fab_file ON faj04=fab01",  #No.TQC-9B0028 mod
               #"  FROM fbh_file,faj_file LEFT OUTER fab_file ON faj04=fab01",   #No.TQC-9B0028 mark
               " WHERE fbh01 = '",g_no,"'",
               "   AND fbh03  = faj_file.faj02",
               "   AND fbh031 = faj_file.faj022"
   #end No:A099
   PREPARE t108_p FROM l_sql
   DECLARE t108_c CURSOR WITH HOLD FOR t108_p
   FOREACH t108_c INTO l_fbh.*,l_faj23,l_faj24,l_faj53,l_faj531,l_faj54,l_faj541,l_fab24,l_fab241, #No:A099     #No.FUN-680028
                       l_faj232,l_faj242,l_fbh062,l_fbh072,l_fbh122    #FUN-AB0088 add  
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
      LET g_npq.npq04 = NULL    #FUN-D10065  add 
      IF SQLCA.sqlcode THEN
#No.FUN-710028 -begin
         IF g_bgerr THEN
            CALL s_errmsg('fbh01',g_no,'t108_c',SQLCA.sqlcode,0)  #No.FUN-710028
         ELSE
            CALL cl_err('t108_c',SQLCA.sqlcode,0)     
         END IF
#No.FUN-710028 --end
         EXIT FOREACH 
      END IF
      #No:A099
      IF cl_null(l_fbh.fbh12) THEN LET l_fbh.fbh12 = 0 END IF                   
      IF cl_null(l_fbh.fbh122) THEN LET l_fbh.fbh122 = 0 END IF           #FUN-AB0088 add          
      #-------Dr.: 固定資產清理科目(fbz18) -------------                        
       IF g_faa.faa29 = 'Y' AND g_aza.aza26='2' THEN      #轉入清理科目No.MOD-4A0173                 
         LET g_npq.npq02 = g_npq.npq02 + 1                                      
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fbz.fbz18         #借:固定資產清理                 
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fbz.fbz18
         ELSE
            LET g_npq.npq03 = l_fbz.fbz181
         END IF
         #No.FUN-680028 --end
         #-->單一部門分攤才給部門                                              
         IF g_npq.npqtype = '0' THEN     #FUN-AB0088 
            IF l_faj23 = '1' THEN                                                  
               SELECT aag05 INTO l_aag05 FROM aag_file                             
                WHERE aag01=g_npq.npq03       
                  AND aag00 = p_bookno           #No.FUN-740026                                     
               IF l_aag05='Y' THEN                                                 
                  LET g_npq.npq05 =l_faj24                                         
               ELSE                                                                
                 LET g_npq.npq05 = ' '                                            
               END IF                                                              
            ELSE LET g_npq.npq05 = NULL                                            
            END IF        
         #FUN-AB0088---add---str---
         ELSE
             IF l_faj232 = '1' THEN                                                  
                SELECT aag05 INTO l_aag05 FROM aag_file                             
                 WHERE aag01=g_npq.npq03       
                   AND aag00 = p_bookno        
                IF l_aag05='Y' THEN                                                 
                   LET g_npq.npq05 =l_faj242                                         
                ELSE                                                                
                   LET g_npq.npq05 = ' '                                            
                END IF                                                              
             ELSE LET g_npq.npq05 = NULL                                            
             END IF                                                                 
         END IF
         #FUN-AB0088---add---end---                                                          
         LET g_npq.npq06 = '1'                                                  
         IF g_npq.npqtype = '0' THEN   #FUN-AB0088   
            LET g_npq.npq07f= l_fbh.fbh06 - (l_fbh.fbh07 + l_fbh.fbh12)            
            LET g_npq.npq07 = l_fbh.fbh06 - (l_fbh.fbh07 + l_fbh.fbh12) 
         #FUN-AB0088---add---str---
         ELSE
             LET g_npq.npq07f= l_fbh.fbh062 - (l_fbh.fbh072 + l_fbh.fbh122)            
             LET g_npq.npq07 = l_fbh.fbh062 - (l_fbh.fbh072 + l_fbh.fbh122) 
         END IF
         #FUN-AB0088---add---end---
         LET g_npq.npq23 = ' '                                                  
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03                                
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbh.fbh02,'',p_bookno)   #MOD-6C0140  #No.FUN-740026   add g_bookno
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,p_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
         #No.FUN-5C0015 ---end
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
#FUN-A40067 --Begin
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = l_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
#FUN-A40067 --End
            CALL s_newrate(l_bookno1,l_bookno2,g_npq.npq24,
                           g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         IF g_npq.npq07 > 0 THEN                     #MOD-C80200 add
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (g_npq.*)                                  
            IF STATUS THEN                                                         
#              CALL cl_err('ins npq#10',STATUS,1)                                     #No.FUN-660136
#No.FUN-710028 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#10', STATUS,1)               #No.FUN-710028
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#10",1)   #No.FUN-660136
               END IF
#No.FUN-710028 --end
#              LET g_success='N' EXIT FOREACH        #No.FUN-710028                                   
               LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                   
            END IF                                                                 
         END IF                                      #MOD-C80200 add
      END IF                                                                    
      #end No:A099
      #-------Dr.: 對方科目(faj53) -------------
      IF NOT cl_null(l_fbh.fbh07) AND l_fbh.fbh07!=0 THEN   #FUN-5B0051
         LET g_npq.npq02 = g_npq.npq02 + 1
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_faj54     #MOD-580148
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_faj54
         ELSE
            LET g_npq.npq03 = l_faj541
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         #-->單一部門分攤才給部門
         IF g_npq.npqtype = '0' THEN   #FUN-AB0088   
            IF l_faj23 = '1' THEN 
               #No:7833
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00 = p_bookno           #No.FUN-740026                                     
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
               ##
            ELSE LET g_npq.npq05 = NULL           
            END IF
         #FUN-AB0088---add---str---
         ELSE
           IF l_faj232 = '1' THEN                                                  
              SELECT aag05 INTO l_aag05 FROM aag_file                             
               WHERE aag01=g_npq.npq03       
                 AND aag00 = p_bookno        
              IF l_aag05='Y' THEN                                                 
                 LET g_npq.npq05 =l_faj242                                         
              ELSE                                                                
                 LET g_npq.npq05 = ' '                                            
              END IF                                                              
           ELSE LET g_npq.npq05 = NULL                                            
           END IF                                                                 
         END IF
         #FUN-AB0088---add---end--- 
         LET g_npq.npq06 = '1'
 #MOD-580148
#         IF g_type = '1' THEN 
#              LET g_npq.npq03 = l_faj54  #借:累折 
#         ELSE LET g_npq.npq03 = l_faj54    
#         END IF
 #END MOD-580148

         IF g_npq.npqtype ='0' THEN   #FUN-AB0088
            LET l_fbh07 = l_fbh.fbh07
         #FUN-AB0088---add---str---
         ELSE
             LET l_fbh07 = l_fbh.fbh072
         END IF 
         #FUN-AB0088---add---end--- 
         LET g_npq.npq07f= l_fbh07
         LET g_npq.npq07 = l_fbh07
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbh.fbh02,'',p_bookno)   #MOD-6C0140 #No.FUN-740026   add g_bookno
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,p_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
         #No.FUN-5C0015 ---end
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
#FUN-A40067 --Begin
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = l_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
#FUN-A40067 --End
            CALL s_newrate(l_bookno1,l_bookno2,g_npq.npq24,
                           g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         IF g_npq.npq07 > 0 THEN                     #MOD-C80200 add
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (g_npq.*)
            IF STATUS THEN 
#              CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                #No.FUN-710028
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#1",1)   #No.FUN-660136
               END IF
#No.FUN-710028 --end
#              LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                   
               LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                   
            END IF
         END IF                                       #MOD-C80200 add                
      END IF   #FUN-5B0051
      #No:A099
      #-------Dr.: 資產之減值準備科目(fab24) -------------                      
       IF g_npq.npqtype = '1' THEN LET l_fbh.fbh12 = l_fbh.fbh122 END IF    #FUN-AB0088 
       IF l_fbh.fbh12 > 0 AND g_aza.aza26='2' THEN     #已提列減值準備 No.MOD-4A0173 
         LET g_npq.npq02 = g_npq.npq02 + 1                                      
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fab24             #借:減值準備                     
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fab24
         ELSE
            LET g_npq.npq03 = l_fab241
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         #-->單一部門分攤才給部門           
         IF g_npq.npqtype = '0' THEN    #FUN-AB0088                                     
            IF l_faj23 = '1' THEN                                                  
               SELECT aag05 INTO l_aag05 FROM aag_file                             
                WHERE aag01=g_npq.npq03                                            
                  AND aag00 = p_bookno           #No.FUN-740026                                     
               IF l_aag05='Y' THEN                                                 
                  LET g_npq.npq05 =l_faj24                                         
               ELSE                                                                
                  LET g_npq.npq05 = ' '                                            
               END IF                                                              
            ELSE LET g_npq.npq05 = NULL                                            
            END IF         
         #FUN-AB0088---add---str---
         ELSE
            IF l_faj232 = '1' THEN                                                  
                SELECT aag05 INTO l_aag05 FROM aag_file                             
                 WHERE aag01=g_npq.npq03       
                   AND aag00 = p_bookno        
                IF l_aag05='Y' THEN                                                 
                   LET g_npq.npq05 =l_faj242                                         
                ELSE                                                                
                   LET g_npq.npq05 = ' '                                            
                END IF                                                              
             ELSE LET g_npq.npq05 = NULL                                            
             END IF
         END IF
         #FUN-AB0088---add---end---            
         LET g_npq.npq06 = '1'                                                  
         IF g_npq.npqtype = '0' THEN      #FUN-AB0088
            LET g_npq.npq07f= l_fbh.fbh12                                          
            LET g_npq.npq07 = l_fbh.fbh12         
         #FUN-AB0088---add---str---
         ELSE
             LET g_npq.npq07f= l_fbh.fbh122                                          
             LET g_npq.npq07 = l_fbh.fbh122
         END IF
         #FUN-AB0088---add---end---                                 
         LET g_npq.npq23 = ' '                                                  
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03                                
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbh.fbh02,'',p_bookno)   #MOD-6C0140  #No.FUN-740026   add g_bookno
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,p_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
         #No.FUN-5C0015 ---end
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
#FUN-A40067 --Begin
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = l_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
#FUN-A40067 --End
            CALL s_newrate(l_bookno1,l_bookno2,g_npq.npq24,
                           g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         IF g_npq.npq07 > 0 THEN                     #MOD-C80200 add
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (g_npq.*)     
            IF STATUS THEN                                                         
#              CALL cl_err('ins npq#12',STATUS,1)                                     #No.FUN-660136
#No.FUN-710028 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#12', STATUS,1)               #No.FUN-710028
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#12",1)   #No.FUN-660136
               END IF
#No.FUN-710028 --end
#              LET g_success='N' EXIT FOREACH        #No.FUN-710028                                   
               LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                   
            END IF                                                                 
         END IF                                       #MOD-C80200 add
      END IF                                                                    
      #end No:A099
      #-------Dr.: 資產之資產科目(faj53) -------
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq06 = '2'
      #No.FUN-680028 --begin
#     LET g_npq.npq03 = l_faj53   
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = l_faj53    
      ELSE
         LET g_npq.npq03 = l_faj531
      END IF
      #No.FUN-680028 --end
      LET g_npq.npq04 = NULL   #MOD-6C0140 add
      #No:7833
      IF g_npq.npqtype  = '0' THEN    #FUN-AB0088
         IF l_faj23 = '1' THEN
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00 = p_bookno           #No.FUN-740026                                     
            IF l_aag05='Y' THEN
               LET g_npq.npq05 =l_faj24
            ELSE
               LET g_npq.npq05 = ' '
            END IF
         ELSE
            LET g_npq.npq05 = NULL
         END IF
      #FUN-AB0088---add---str---
      ELSE
          IF l_faj232 = '1' THEN                                                  
             SELECT aag05 INTO l_aag05 FROM aag_file                             
              WHERE aag01=g_npq.npq03       
                AND aag00 = p_bookno        
             IF l_aag05='Y' THEN                                                 
                LET g_npq.npq05 =l_faj242                                         
             ELSE                                                                
                LET g_npq.npq05 = ' '                                            
             END IF                                                              
          ELSE LET g_npq.npq05 = NULL                                            
          END IF                                                                 
      END IF
      #FUN-AB0088---add---end---
      ##
      IF g_npq.npqtype = '0' THEN   #FUN-AB0088
         LET l_fbh06 = l_fbh.fbh06
         IF g_npq.npq03 = l_faj53 THEN              #MOD-C80200 add
            LET l_fbh06 = l_fbh06 - l_fbh.fbh12     #MOD-C80200 add
         END IF                                     #MOD-C80200 add
      #FUN-AB0088---add---str---
      ELSE
         LET l_fbh06 = l_fbh.fbh062
         IF g_npq.npq03 = l_faj53 THEN              #MOD-C80200 add
            LET l_fbh06 = l_fbh06 - l_fbh.fbh122    #MOD-C80200 add
         END IF                                     #MOD-C80200 add
      END IF
      #FUN-AB0088---add---end---
      LET g_npq.npq07f= l_fbh06 
      LET g_npq.npq07 = l_fbh06   
      LET g_npq.npq23 = ' '
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      #NO.FUN-5C0015 ---start
     #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbh.fbh02,'',p_bookno)   #MOD-6C0140 #No.FUN-740026   add g_bookno
      RETURNING g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,p_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34    #FUN-AA0087
      #No.FUN-5C0015 ---end
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
#FUN-A40067 --Begin
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = l_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
#FUN-A40067 --End
            CALL s_newrate(l_bookno1,l_bookno2,g_npq.npq24,
                           g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
      IF g_npq.npq07 > 0 THEN                     #MOD-C80200 add
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
#           CALL cl_err('ins npq#2',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#2', STATUS,1)                #No.FUN-710028
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#2",1)   #No.FUN-660136
            END IF
#No.FUN-710028 --end
#           LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                   
            LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                   
         END IF
      END IF                                       #MOD-C80200 add
       IF g_faa.faa29 = 'N' OR g_aza.aza26<>'2' THEN    #No:A099   #No.MOD-4A0173
         #------- 未折減額 > 0 即為有損失 
         IF l_fbh.fbh08 > 0 THEN 
            LET g_npq.npq02 = g_npq.npq02 + 1
 #MOD-580148
           IF g_type = '1' THEN
              #No.FUN-680028 --begin
#             LET g_npq.npq03 = l_fbz.fbz08
              IF g_npq.npqtype = '0' THEN
                 LET g_npq.npq03 = l_fbz.fbz08
              ELSE
                 LET g_npq.npq03 = l_fbz.fbz081
              END IF
              #No.FUN-680028 --end
           ELSE
              #No.FUN-680028 --begin
#             LET g_npq.npq03 = l_fbz.fbz09
              IF g_npq.npqtype = '0' THEN
                 LET g_npq.npq03 = l_fbz.fbz09
              ELSE
                 LET g_npq.npq03 = l_fbz.fbz091
              END IF
              #No.FUN-680028 --end
           END IF
 #END MOD-580148
           LET g_npq.npq04 = NULL   #MOD-6C0140 add
            #No:7833
            IF g_npq.npqtype = '0' THEN   #FUN-AB0088
               IF l_faj23 = '1' THEN
                  SELECT aag05 INTO l_aag05 FROM aag_file
                   WHERE aag01=g_npq.npq03
                     AND aag00 = p_bookno           #No.FUN-740026                                     
                  IF l_aag05='Y' THEN
                     LET g_npq.npq05 =l_faj24
                  ELSE
                     LET g_npq.npq05 = ' '
                  END IF
               ELSE
                  LET g_npq.npq05 = NULL
               END IF
            #FUN-AB0088---add---str---
            ELSE
               IF l_faj232 = '1' THEN                                                  
                  SELECT aag05 INTO l_aag05 FROM aag_file                             
                   WHERE aag01=g_npq.npq03       
                     AND aag00 = p_bookno        
                  IF l_aag05='Y' THEN                                                 
                     LET g_npq.npq05 =l_faj242                                         
                  ELSE                                                                
                     LET g_npq.npq05 = ' '                                            
                  END IF                                                              
               ELSE LET g_npq.npq05 = NULL                                            
               END IF                                                                 
            END IF  
            #FUN-AB0088---add---end---
            ##
            LET g_npq.npq06 = '1'
 #MOD-580148
#            IF g_type = '1' THEN 
#               LET g_npq.npq03 = l_fbz.fbz08
#            ELSE
#               LET g_npq.npq03 = l_fbz.fbz09
#            END IF
 #END MOD-580148
            IF g_npq.npqtype = '0' THEN   #FUN-AB0088
               LET l_fbh08 = l_fbh.fbh08 - l_fbh.fbh12   #No:A099                
            #FUN-AB0088---add---str---
            ELSE
                LET l_fbh08 = l_fbh.fbh082 - l_fbh.fbh122
            END IF 
            #FUN-AB0088---add---end---
            LET g_npq.npq07f= l_fbh08  #未折減額 
            LET g_npq.npq07 = l_fbh08   
            LET g_npq.npq23 = ' '
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            #NO.FUN-5C0015 ---start
           #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbh.fbh02,'',p_bookno)   #MOD-6C0140  #No.FUN-740026   add g_bookno
            RETURNING g_npq.*
            CALL s_def_npq31_npq34(g_npq.*,p_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
            #No.FUN-5C0015 ---end
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
#FUN-A40067 --Begin
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = l_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
#FUN-A40067 --End
            CALL s_newrate(l_bookno1,l_bookno2,g_npq.npq24,
                           g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         IF g_npq.npq07 > 0 THEN                     #MOD-C80200 add
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (g_npq.*)
            IF STATUS THEN 
#              CALL cl_err('ins npq#2',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#2', STATUS,1)                #No.FUN-710028
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#2",1)   #No.FUN-660136
               END IF
#No.FUN-710028 --end
#              LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                   
               LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                   
            END IF
         END IF                                       #MOD-C80200 add
         END IF 
         #------- 未折減額 < 0 即為有收益 
         IF l_fbh.fbh08 < 0 THEN 
            LET g_npq.npq02 = g_npq.npq02 + 1
            LET g_npq.npq06 = '2'
            IF g_type = '1' THEN 
               #No.FUN-680028 --begin
#              LET g_npq.npq03 = l_fbz.fbz08
               IF g_npq.npqtype = '0' THEN
                  LET g_npq.npq03 = l_fbz.fbz08
               ELSE
                  LET g_npq.npq03 = l_fbz.fbz081
               END IF
               #No.FUN-680028 --end
            ELSE
               #No.FUN-680028 --begin
#              LET g_npq.npq03 = l_fbz.fbz09
               IF g_npq.npqtype = '0' THEN
                  LET g_npq.npq03 = l_fbz.fbz09
               ELSE
                  LET g_npq.npq03 = l_fbz.fbz091
               END IF
               #No.FUN-680028 --end
            END IF
            LET g_npq.npq04 = NULL   #MOD-6C0140 add
            #-->單一部門分攤才給部門
            #No:7833
            IF g_npq.npqtype  = '0' THEN   #FUN-AB0088
               IF l_faj23 = '1' THEN
                  SELECT aag05 INTO l_aag05 FROM aag_file
                   WHERE aag01=g_npq.npq03
                     AND aag00 = p_bookno           #No.FUN-740026                                     
                  IF l_aag05='Y' THEN
                     LET g_npq.npq05 =l_faj24
                  ELSE
                     LET g_npq.npq05 = ' '
                  END IF
               ELSE
                  LET g_npq.npq05 = NULL
               END IF
            #FUN-AB0088---add---str---
            ELSE
               IF l_faj232 = '1' THEN                                                  
                  SELECT aag05 INTO l_aag05 FROM aag_file                             
                   WHERE aag01=g_npq.npq03       
                     AND aag00 = p_bookno        
                  IF l_aag05='Y' THEN                                                 
                     LET g_npq.npq05 =l_faj242                                         
                  ELSE                                                                
                     LET g_npq.npq05 = ' '                                            
                  END IF                                                              
               ELSE LET g_npq.npq05 = NULL                                            
               END IF                                                                 
            END IF
            #FUN-AB0088---add---end---
            ##
            IF g_npq.npqtype = '0' THEN    #FUN-AB0088
               LET l_fbh08 = l_fbh.fbh08 + l_fbh.fbh12    #No:A099
            #FUN-AB0088---add---str---
            ELSE
               LET l_fbh08 = l_fbh.fbh082 + l_fbh.fbh122
            END IF
            #FUN-AB0088---add---end---
            LET g_npq.npq07f= l_fbh08 *  (-1) #未折減額 
            LET g_npq.npq07 = l_fbh08 *  (-1) 
            LET g_npq.npq23 = ' '
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            #NO.FUN-5C0015 ---start
           #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbh.fbh02,'',p_bookno)   #MOD-6C0140 #No.FUN-740026   add g_bookno
            RETURNING g_npq.*
            CALL s_def_npq31_npq34(g_npq.*,p_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
            #No.FUN-5C0015 ---end
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
#FUN-A40067 --Begin
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = l_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
#FUN-A40067 --End
            CALL s_newrate(l_bookno1,l_bookno2,g_npq.npq24,
                           g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
            IF g_npq.npq07 > 0 THEN                     #MOD-C80200 add
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno
                  AND aag01 = g_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET g_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (g_npq.*)
               IF STATUS THEN
#                 CALL cl_err('ins npq#2',STATUS,1)   #No.FUN-660136
#No.FUN-710028 -begin
                  IF g_bgerr THEN
                     LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                     CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#2', STATUS,1)                #No.FUN-710028
                  ELSE
                     CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#2",1)   #No.FUN-660136
                  END IF
#No.FUN-710028 --end
#                 LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                   
                  LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                   
               END IF
            END IF                                       #MOD-C80200 add
         END IF 
      END IF         #end No:A099
   END FOREACH
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 -end
 
END FUNCTION
#FUN-A40033 --Begin
FUNCTION s_t108_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_bookno1        LIKE aag_file.aag00
DEFINE l_bookno2        LIKE aag_file.aag00
DEFINE l_flag1          LIKE type_file.chr1
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_date)) RETURNING l_flag1,l_bookno1,l_bookno2
      LET l_bookno2 = g_faa.faa02c                                           #MOD-C70303 add
      IF l_flag1 =  '1' THEN
         CALL cl_err(g_date,'aoo-081',1)
         RETURN
      END IF
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = l_bookno2
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
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal = g_legal
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno,l_npq1.npq03,g_prog,l_npq1.npq01,'','')
         RETURNING l_npq1.npq04
         #FUN-D10065--add--end--
         IF g_npq.npq07 > 0 THEN                     #MOD-C80200 add
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = l_bookno2
               AND aag01 = l_npq1.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq1.npq03,l_bookno2) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq1.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES(l_npq1.*)
            IF STATUS THEN                                                         
               IF g_bgerr THEN
                  LET g_showmsg = l_npq1.npq01,"/",l_npq1.npq011,"/",l_npq1.npq02,"/",l_npq1. npqsys,"/",l_npq1.npq00
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#10', STATUS,1)
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#10",1)
               END IF
               LET g_success='N'
            END IF                                                                 
         END IF                                       #MOD-C80200 add
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
