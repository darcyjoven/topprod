# Prog. Version..: '5.30.06-13.04.22(00005)'     #
# Pattern name...: s_gen_barcode.4gl
# Descriptions...: 條碼產生副程式 
# Date & Author..: No:DEV-CA0006 12/10/17 By jingll 
# Usage..........: CALL s_gen_barcode(p1,p2,p3,p4,p5,p6)
# Input Parameter: p1:產生的條碼類型1:批號 2:序號 3:包號
#                  p2:傳入的值為一碼(A~H),各代表的意義如下
#                   A:工單(asfi301) B:FQC 品質記錄(aqct410) C:工單生產報工單(asft300)
#                   D:生產日報(asft700) E:採購入庫(apmt720) F:採購單(apmt540)
#                   G:委外採購單(apmt590) H:訂單包裝單(abai140)                          
#                  p3:來源單號
#                  p4:來源項次
#                  p5:料號
#                  p6:數量
# Modify.........: No:DEV-CB0002 12/11/07 By TSD.JIE 調整產生條碼編號abaq100
# Modify.........: No.DEV-D30025 2013/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
# Modify.........: No.DEV-D30050 2013/03/25 By TSD.JIE
# 1.新增s_tlfb_chk():控卡在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
# 2.新增s_gen_barcode_chk():單據確認時檢查，若料件數量=條碼數量，(已有後端條碼編號產生，是否使用舊條碼?) =Y
#                           則取消作廢，直接沿用；反之，則重新產生條碼
# Modify.........: No.DEV-D30045 2013/03/27 By TSD.JIE
#                  1.新增作廢條碼SUB：s_barcode_x.4gl
#                    在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可作廢
#                  2.作廢分二種：
#                  2-1.將條碼直接刪除
#                      條碼類型(iba02)=H:包號、X：製造批號-手動、Y：製造序號-手動、Z：製造批號+製造序號(用X,Y,反推的Z條碼)
#                      Z：製造批號+製造序號(用X,Y,反推的Z條碼)
#                  2-2.將條碼使用否變更成"N"
#                      其它的條碼類型
#                  3.以上都限制在aoos010當是否與M-Barcode整合(aza131='Y')時
# Modify.........: No.DEV-D40015 2013/04/15 By Nina 條碼產生前判斷若有勾選使用條碼、條碼產生時機='FG'且無勾選批/序號欄位，則條碼產生給固定值A+料號
# Modify.........: No.DEV-D30043 13/04/16 By TSD.JIE 增加產生時機='Z'
# Modify.........: No.DEV-D40016 13/04/17 By mandy <條碼產生>ACTION需控卡若有已使用的條碼存在，不可重新產生。


DATABASE ds

GLOBALS "../../config/top.global"  

DEFINE g_p1       LIKE type_file.chr1
DEFINE g_p2       LIKE type_file.chr1  #傳入的值為一碼(A~H)  
DEFINE g_p3       LIKE ibb_file.ibb03    
DEFINE g_p4       LIKE ibb_file.ibb04
DEFINE g_p5       LIKE ima_file.ima01
#DEFINE g_p6       LIKE type_file.num5 #No:DEV-CB0002--mark
DEFINE g_p6       LIKE ibb_file.ibb07 #No:DEV-CB0002--add
DEFINE g_codeprin LIKE ima_file.ima920 #編碼原則
DEFINE g_code     LIKE type_file.chr30 #編碼
DEFINE g_desc     LIKE type_file.chr30

FUNCTION s_gen_barcode(p1,p2,p3,p4,p5,p6)

   DEFINE p1       LIKE type_file.chr1  #條碼類型
   DEFINE p2       LIKE type_file.chr1  #傳入的值為一碼(A~H)     
   DEFINE p3       LIKE ibb_file.ibb03  
   DEFINE p4       LIKE ibb_file.ibb04
   DEFINE p5       LIKE ima_file.ima01  #料號
  #DEFINE p6       LIKE type_file.num5  # #No:DEV-CB0002--mark
   DEFINE p6       LIKE ibb_file.ibb07 #No:DEV-CB0002--add
   DEFINE l_geh04  LIKE geh_file.geh04  #類型
   DEFINE l_num    LIKE ibc_file.ibc03  #總包數
   DEFINE l_i      LIKE type_file.num5  
   DEFINE l_chr    LIKE type_file.chr1  #DEV-D30050--add
   
   LET g_p1 = p1
   LET g_p2 = p2
   LET g_p3 = p3
   LET g_p4 = p4
   LET g_p5 = p5
   LET g_p6 = p6 
   LET g_codeprin = NULL 
   IF g_p1 = '1' THEN
      SELECT ima920 INTO g_codeprin FROM ima_file WHERE ima01 = g_p5 
   END IF
   IF g_p1 = '2' THEN
      SELECT ima923 INTO g_codeprin FROM ima_file WHERE ima01 = g_p5 
   END IF
   IF g_p1 = '3' THEN
      SELECT ima933 INTO g_codeprin FROM ima_file WHERE ima01 = g_p5 
   END IF  
  
   SELECT geh04 INTO l_geh04 FROM gei_file,geh_file WHERE gei01 = g_codeprin AND gei03 = geh01 #类型 
   LET l_num = 0
   #當p1='1:批號'時,CALL 產生條碼編號的副程式s_auno，僅呼叫一次
   IF g_p1 = '1' THEN
      LET l_num = 1
   END IF
   #當p1='2:序號'時,CALL 產生條碼編號的副程式s_auno的次數為：生產數量(p6) 
   IF g_p1 = '2' THEN 
      LET l_num = g_p6
   END IF
   #當p1='3:包號'時,CALL 產生條碼編號的副程式s_auno的次數為：抓此料的包裝單(abai130),其總包數(ibc03)的值
   IF g_p1 = '3' THEN
     #SELECT SUM(ibc03) INTO l_num FROM ibc_file WHERE ibc01 = g_p5   #料號     #No:DEV-CB0002--mark
      #No:DEV-CB0002--add--begin
      SELECT DISTINCT ibc03 INTO l_num
        FROM ibc_file
       WHERE ibc00 = '1'    #類型:1.成品料號
         AND ibc01 = g_p5   #料號

      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('ibc01',g_p5,'sel ibc_file',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("sel","ibb_file","","",SQLCA.sqlcode,"","",1)
         END IF
         LET g_success = 'N'
      END IF
      #No:DEV-CB0002--add--end
   END IF
   #DEV-D30050--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode_chk(g_p1,g_p2,g_p3,g_p4,g_p5,g_p6)
         RETURNING l_chr
   END IF
   #DEV-D30050--add--end
   IF g_success = 'Y' AND l_chr = 'Y' THEN #DEV-D30050--add
   FOR l_i = 1 TO l_num
       LET g_barcode_packing = l_i #產生條碼時的包號
       LET g_barcode_no = g_p3   #產生條碼時的單據單號
       LET g_barcode_ln = g_p4   #產生條碼時的單據項次
       CALL s_auno(g_codeprin,l_geh04,g_p5) RETURNING  g_code,g_desc
       CALL s_gen_barcode_ins_ibb(l_i) #新增條碼基本資料-明細檔(ibb_file)
   END FOR 
   END IF                      #DEV-D30050--add
END FUNCTION 

FUNCTION s_gen_barcode_ins_ibb(p_li)

   DEFINE l_ibb RECORD LIKE ibb_file.* 
   DEFINE p_li  LIKE type_file.num5
  
   INITIALIZE l_ibb.* TO NULL 
   LET l_ibb.ibb01 = g_code   #編碼 
   LET l_ibb.ibb02 = g_p2   
   LET l_ibb.ibb03 = g_p3
   LET l_ibb.ibb04 = g_p4
   IF g_p1 = '1' THEN
      LET l_ibb.ibb05 = 0
      LET l_ibb.ibb07 = g_p6
      LET l_ibb.ibb08 = NULL
      LET l_ibb.ibb10 = 0
   END IF
   IF g_p1 = '2' THEN
      LET l_ibb.ibb05 = 0
      LET l_ibb.ibb07 = 1
      LET l_ibb.ibb08 = NULL
      LET l_ibb.ibb10 = 0
   END IF
   IF g_p1 = '3' THEN
      LET l_ibb.ibb05 = p_li  
      LET l_ibb.ibb07 = 1
      LET l_ibb.ibb08 = '1'
     #SELECT SUM(ibc03) INTO l_ibb.ibb10 FROM ibc_file WHERE ibc01 = g_p5   #料號 #No:DEV-CB0002--mark
      #No:DEV-CB0002--add--begin
      SELECT DISTINCT ibc03 INTO l_ibb.ibb10
        FROM ibc_file
       WHERE ibc00 = '1'    #類型:1.成品料號
         AND ibc01 = g_p5   #料號
      #No:DEV-CB0002--add--end
   END IF
   LET l_ibb.ibb06 = g_p5    #料號
   LET l_ibb.ibb09 = NULL
   LET l_ibb.ibb11 = 'Y'
   LET l_ibb.ibb12 = '0'
   LET l_ibb.ibbacti = 'Y'
   IF cl_null(l_ibb.ibb13) THEN
       LET l_ibb.ibb13 = 0
   END IF
  
   INSERT INTO ibb_file VALUES(l_ibb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
     #CALL cl_err3("ins","ibb_file","","",SQLCA.sqlcode,"","",1) #No:DEV-CB0002--mark
      #No:DEV-CB0002--add--begin
      IF g_bgerr THEN
         CALL s_errmsg('ibb01',l_ibb.ibb01,'ins ibb_file',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","ibb_file","","",SQLCA.sqlcode,"","",1)
      END IF
      LET g_success = 'N'
      #No:DEV-CB0002--add--end
      RETURN
   END IF

END FUNCTION 
#DEV-CA0006--add
#DEV-D30025--add

#DEV-D30050--add--begin
# Usage..........: CALL s_tlfb_chk(p_ibb03)
# 在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
# Input Parameter: p_ibb03:單號
# Return Code....: TRUE/FALSE
FUNCTION s_tlfb_chk(p_ibb03)
   DEFINE p_ibb03  LIKE ibb_file.ibb03
   DEFINE l_cnt    LIKE type_file.num5

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM tlfb_file
    WHERE tlfb01 IN (SELECT UNIQUE ibb01 FROM ibb_file
                      WHERE ibb03 = p_ibb03)
   IF l_cnt >=1 THEN
      #在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
      IF g_bgerr THEN
         CALL s_errmsg('ibb03',p_ibb03,'sle tlfb01','aba-127',1)
      ELSE
         CALL cl_err(p_ibb03,'aba-127',1)
      END IF
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION 

# Descriptions...: 檢查barcode是否可以產生
# Usage..........: CALL s_gen_barcode_chk(p_type,p_ibb02,p_ibb03,p_ibb04,p_ibb06,p_ibb07)
#                  此SUN作用:用來判斷後續是否要去CALL產生條碼的SUB(s_auno)
# Input Parameter: p_type:產生的條碼類型1:批號 2:序號 3:包號
#                  p_ibb02:條碼產生時機點(aimi100的ima932)
#                  p_ibb02:來源單號
#                  p_ibb04:來源項次;無項次時,此欄位傳0
#                  p_ibb06:料號
#                  p_ibb07:數量
# Return Code....: l_sta "Y":後續要CALL s_auno()
#                        "N":後續不CALL s_auno()
FUNCTION s_gen_barcode_chk(p_type,p_ibb02,p_ibb03,p_ibb04,p_ibb06,p_ibb07)
   DEFINE p_type       LIKE type_file.chr1  #條碼類型
   DEFINE p_ibb02       LIKE type_file.chr1  #傳入的值為一碼(A~H)     
   DEFINE p_ibb03       LIKE ibb_file.ibb03  
   DEFINE p_ibb04       LIKE ibb_file.ibb04
   DEFINE p_ibb06       LIKE ima_file.ima01  #料號
   DEFINE p_ibb07       LIKE ibb_file.ibb07
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_max_no1     LIKE ibb_file.ibb01
   DEFINE l_max_no2     LIKE ibb_file.ibb01


   LET g_success = 'Y'

   CASE
      WHEN p_type = '1' #"1:批號"
         #批號條碼資料若已存在,更新數量ibb07及使用否ibb11="Y"
         LET l_cnt = 0
         SELECT COUNT(*) 
           INTO l_cnt
           FROM iba_file,ibb_file
          WHERE iba01 = ibb01          #條碼編號
            AND iba02 IN ('F','G','5') #批號
            AND ibb02 = p_ibb02             #條碼產生時機點
            AND ibb03 = p_ibb03             #來源單號
            AND ibb04 = p_ibb04             #來源項次
         IF l_cnt >= 1 THEN
            UPDATE ibb_file SET ibb07 = p_ibb07,
                                ibb11 = 'Y',
                                ibb12 = 0
             WHERE ibb02 = p_ibb02
               AND ibb03 = p_ibb03
               AND ibb04 = p_ibb04
               AND EXISTS(SELECT iba01 FROM iba_file 
                           WHERE iba01 = ibb01
                             AND iba02 IN ('F','G','5'))  #批號
            IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                  LET g_showmsg = "('F','G','5')",'/',p_ibb02,'/',p_ibb03,'/',p_ibb04
                  CALL s_errmsg('iba02,ibb02,ibb03,ibb04',g_showmsg,'upd ibb07',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","ibb_file",p_ibb03,p_ibb04,SQLCA.sqlcode,"","",1)
               END IF
               LET g_success = 'N'
            END IF
            RETURN "N"
         END IF

      WHEN p_type = '2' #"2:序號"
         #l_cnt:該來源單號及來源項次已存在條碼數量
         LET l_cnt = 0
         SELECT COUNT(*) 
           INTO l_cnt
           FROM iba_file,ibb_file
          WHERE iba01 = ibb01  #條碼編號
            AND iba02 ='6'     #序號
            AND ibb02 = p_ibb02     #條碼產生時機點
            AND ibb03 = p_ibb03     #來源單號
            AND ibb04 = p_ibb04     #來源項次
         
         IF l_cnt >=1 THEN
            #l_max_no1:該來源單號及來源項次已存在的最大序號條碼編號
            LET l_max_no1 = ''
            SELECT MAX(ibb01) INTO l_max_no1
              FROM iba_file,ibb_file
             WHERE iba01 = ibb01  #條碼編號
               AND iba02 ='6'     #序號
               AND ibb02 = p_ibb02     #條碼產生時機點
               AND ibb03 = p_ibb03     #來源單號
               AND ibb04 = p_ibb04     #來源項次
            
            #l_max_no2:該料件的最大序號條碼編號
            LET l_max_no2 = ''
            SELECT MAX(ibb01) INTO l_max_no2
              FROM iba_file,ibb_file
             WHERE iba01 = ibb01       #條碼編號
               AND iba02 ='6'          #序號
               AND ibb02 = p_ibb02     #條碼產生時機點
               AND ibb06 = p_ibb06          #料號
         
            #狀況一:
            #l_max_no1 = l_max_no2 AND #p_ibb07料件數量=l_cnt條碼數量 
            #表示沒有後端條碼編號產生,所以取消作廢(將使用否ibb11更新成"Y"),
            #已存在的條碼直接沿用,故RETURN "N"
            IF l_max_no1 = l_max_no2 AND p_ibb07 = l_cnt THEN
               UPDATE ibb_file 
                  SET ibb11 = 'Y',
                      ibb12 = 0
                WHERE ibb02 = p_ibb02     #條碼產生時機點
                  AND ibb03 = p_ibb03     #來源單號
                  AND ibb04 = p_ibb04     #來源項次
                  AND EXISTS(SELECT iba01 FROM iba_file 
                              WHERE iba01 = ibb01
                                AND iba02 = '6')
         
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     LET g_showmsg = '6','/',p_ibb02,'/',p_ibb03,'/',p_ibb04
                     CALL s_errmsg('iba02,ibb02,ibb03,ibb04',g_showmsg,
                                   'upd ibb11',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("upd","ibb_file",p_ibb03,p_ibb04,SQLCA.sqlcode,
                                  "","upd ibb11",1)
                  END IF
                  LET g_success = 'N'
               END IF
               RETURN "N"
            END IF
        
            #狀況二:
            #l_max_no1 < l_max_no2 AND #p_ibb07料件數量=l_cnt條碼數量
            #表示已有後端條碼編號產生，詢問是否使用舊條碼? 若是(Y)則取消作廢(將使用否ibb11更新成"Y")，
            #已存在的條碼直接沿用,故RETURN "N"；
            #反之，則需重新產生條碼 RETURN "Y"
            IF l_max_no1 < l_max_no2 AND p_ibb07 = l_cnt THEN
               IF NOT cl_confirm('') THEN
                  RETURN "Y"
               ELSE
                  UPDATE ibb_file 
                     SET ibb11 = 'Y',
                         ibb12 = 0
                   WHERE ibb02 = p_ibb02     #條碼產生時機點
                     AND ibb03 = p_ibb03     #來源單號
                     AND ibb04 = p_ibb04     #來源項次
                     AND EXISTS(SELECT iba01 FROM iba_file 
                                 WHERE iba01 = ibb01
                                   AND iba02 = '6')
                  
                  IF SQLCA.sqlcode THEN
                     IF g_bgerr THEN
                        LET g_showmsg = '6','/',p_ibb02,'/',p_ibb03,'/',p_ibb04
                        CALL s_errmsg('iba02,ibb02,ibb03,ibb04',g_showmsg,
                                      'upd ibb11',SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("upd","ibb_file",p_ibb03,p_ibb04,SQLCA.sqlcode,
                                     "","upd ibb11",1)
                     END IF
                     LET g_success = 'N'
                  END IF
                  RETURN "N"
               END IF
            END IF
        
            #狀況三:
            #l_max_no1 = l_max_no2 AND #p_ibb07料件數量<>l_cnt條碼數量 
            #表示沒有後端條碼編號產生且User 重新調整了該張單據的數量,
            #所以需將已存在的條碼刪除,後續再重新產生條碼 RETURN "Y"
            IF l_max_no1 = l_max_no2 AND p_ibb07 <> l_cnt THEN
               DELETE FROM ibb_file 
                WHERE ibb02 = p_ibb02     #條碼產生時機點
                  AND ibb03 = p_ibb03     #來源單號
                  AND ibb04 = p_ibb04     #來源項次
                  AND EXISTS(SELECT iba01 FROM iba_file 
                              WHERE iba01 = ibb01
                                AND iba02 = '6')
         
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     LET g_showmsg = '6','/',p_ibb02,'/',p_ibb03,'/',p_ibb04
                     CALL s_errmsg('iba02,ibb02,ibb03,ibb04',g_showmsg,
                                   'del ibb_file',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("del","ibb_file",p_ibb03,p_ibb04,SQLCA.sqlcode,
                                  "","del ibb",1)
                  END IF
                  LET g_success = 'N'
               END IF
               RETURN "Y"
            END IF
         END IF

      WHEN p_type = '3' #"3:包號 "
         #l_cnt:該來源單號及來源項次已存在條碼數量
         LET l_cnt = 0
         SELECT COUNT(*) 
           INTO l_cnt
           FROM iba_file,ibb_file
          WHERE iba01 = ibb01  #條碼編號
            AND iba02 = 'H'    #序號
            AND ibb02 = p_ibb02     #條碼產生時機點
            AND ibb03 = p_ibb03     #來源單號
         IF l_cnt >=1 THEN
              DELETE FROM iba_file
               WHERE iba02 = 'H'
                 AND EXISTS(SELECT ibb01 FROM ibb_file 
                             WHERE iba01 = ibb01
                               AND ibb02 = p_ibb02
                               AND ibb03 = p_ibb03)
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    LET g_showmsg = 'H','/',p_ibb02,'/',p_ibb03
                    CALL s_errmsg('iba02,ibb02,ibb03',g_showmsg,
                                  'del ibb_file',SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("del","iba_file",p_ibb02,p_ibb03,SQLCA.sqlcode,
                                 "","del iba",1)
                 END IF
                 LET g_success = 'N'
              END IF

              DELETE FROM ibb_file
               WHERE ibb02 = p_ibb02
                 AND ibb03 = p_ibb03
                 AND EXISTS(SELECT iba01 FROM iba_file 
                             WHERE iba01 = ibb01
                               AND iba02 = 'H')
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    LET g_showmsg = 'H','/',p_ibb02,'/',p_ibb03
                    CALL s_errmsg('iba02,ibb02,ibb03',g_showmsg,
                                  'del ibb_file',SQLCA.sqlcode,1)
                 ELSE
                    CALL cl_err3("del","iba_file",p_ibb02,p_ibb03,SQLCA.sqlcode,
                                 "","del iba",1)
                 END IF
                 LET g_success = 'N'
              END IF
         END IF

   END CASE

   RETURN "Y"
END FUNCTION 
#DEV-D30050--add--end

#DEV-D30045--add--begin
# Descriptions...: barcode報表類型
# Usage..........: CALL s_gen_barcode_ibd07()
# Input Parameter: 
# Return Code....: l_ibd07
FUNCTION s_gen_barcode_ibd07()
   DEFINE l_ibd07     LIKE ibd_file.ibd07

   SELECT ibd07 INTO l_ibd07 FROM ibd_file

   RETURN l_ibd07
END FUNCTION 


# Descriptions...: 檢查該料件是否符合barcode產生時機點
# Usage..........: CALL s_gen_barcode_chktype(p_ibb02,p_ibb03,p_ln,p_seq)
# Input Parameter: p_ibb02:產生時機點
#                  p_ibb03:料件
#                  p_ln   :單據項次   (for IQC之來源項次)
#                  p_seq  :順序       (for IQC之分批順序)
# Return Code....: TRUE/FALSE
FUNCTION s_gen_barcode_chktype(p_ibb02,p_ibb03,p_ln,p_seq)
   DEFINE p_ibb02     LIKE ibb_file.ibb02
   DEFINE p_ibb03     LIKE ibb_file.ibb03
   DEFINE p_ln        LIKE type_file.num5    #單據項次
   DEFINE p_seq       LIKE type_file.num5    #順序
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_sql       STRING

   LET l_cnt = 0

   CASE p_ibb02
      WHEN 'A' #asfi301
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM sfb_file,ima_file",
                     " WHERE sfb01  = '",p_ibb03,"' ",
                     "   AND sfb05  = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
      WHEN 'B' #aqct410
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM qcf_file,ima_file",
                     " WHERE qcf01  = '",p_ibb03,"' ",
                     "   AND qcf021 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
      WHEN 'C' #asft300
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM srg_file,ima_file",
                     " WHERE srg01 = '",p_ibb03,"' ",
                     "   AND srg03 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
      WHEN 'D' #asft700
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM shb_file,ima_file",
                     " WHERE shb01 = '",p_ibb03,"' ",
                     "   AND shb10 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
      WHEN 'E' #apmt720
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM rvv_file,ima_file",
                     " WHERE rvv01 = '",p_ibb03,"' ",
                     "   AND rvv31 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
      WHEN 'F' #apmt540
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM pmn_file,ima_file",
                     " WHERE pmn01 = '",p_ibb03,"' ",
                     "   AND pmn04 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
      WHEN 'G' #apmt590
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM pmn_file,ima_file",
                     " WHERE pmn01 = '",p_ibb03,"' ",
                     "   AND pmn04 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
      WHEN 'I' #aimt302
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM inb_file,ima_file",
                     " WHERE inb01 = '",p_ibb03,"' ",
                     "   AND inb04 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 NOT IN ('H','J')"
      WHEN 'K' #apmt110
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM rvb_file,ima_file",
                     " WHERE rvb01 = '",p_ibb03,"' ",
                     "   AND rvb05 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
      WHEN 'L' #aqct110
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM qcs_file,ima_file",
                     " WHERE qcs01 = '",p_ibb03,"' ",
                     "   AND qcs02 = '",p_ln,"'",
                     "   AND qcs05 = '",p_seq,"'",
                     "   AND qcs021 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' "
   END CASE

   PREPARE s_gen_barcode_chktype_prep FROM l_sql
   EXECUTE s_gen_barcode_chktype_prep INTO l_cnt

   IF l_cnt = 0 OR cl_null(l_cnt) THEN
      RETURN FALSE
   END IF
   
   RETURN TRUE
END FUNCTION 


# Descriptions...: 條碼產生副程式 
# Usage..........: CALL s_gen_barcode2(p_ibb02,p_ibb03,p_ln,p_seq,p_ln,p_seq)
# Input Parameter: p_ibb02:產生時機點
#                  p_ibb03:來源單號
#                  p_ln   :單據項次   (for IQC之來源項次)
#                  p_seq  :順序       (for IQC之分批順序)
# Return Code....: 
FUNCTION s_gen_barcode2(p_ibb02,p_ibb03,p_ln,p_seq)
   DEFINE p_ibb02     LIKE ibb_file.ibb02    #條碼產生時機點
   DEFINE p_ibb03     LIKE ibb_file.ibb03    #來源單號
   DEFINE p_ln        LIKE type_file.num5    #單據項次
   DEFINE p_seq       LIKE type_file.num5    #順序
   DEFINE l_ibb03     LIKE ibb_file.ibb03    #來源項次
   DEFINE l_ibb04     LIKE ibb_file.ibb04    #來源項次
   DEFINE l_ibb06     LIKE ibb_file.ibb06    #料號
   DEFINE l_ibb07     LIKE ibb_file.ibb07    #數量
   DEFINE l_ima918    LIKE ima_file.ima918
   DEFINE l_ima919    LIKE ima_file.ima919
   DEFINE l_ima921    LIKE ima_file.ima921
   DEFINE l_ima922    LIKE ima_file.ima922
   DEFINE l_ima931    LIKE ima_file.ima931
   DEFINE l_ima932    LIKE ima_file.ima932
   DEFINE l_count     LIKE type_file.num10
   DEFINE l_sql       STRING
   DEFINE l_ima930    LIKE ima_file.ima930   #條碼使用否  #DEV-D40015 add

   WHENEVER ERROR CONTINUE

   LET g_success = 'Y'

  #DEV-D40016--add---str---
   LET l_count = 0
   IF p_ibb02 = 'L' THEN #IQC
       SELECT COUNT(*) INTO l_count FROM ibb_file 
        WHERE ibb03 = p_ibb03 #來源單據
          AND ibb11 = 'Y'
          AND ibb04 = p_ln  #來源項次
          AND ibb13 = p_seq #檢驗批號(分批檢驗順序)
   ELSE
       SELECT COUNT(*) INTO l_count FROM ibb_file 
        WHERE ibb03 = p_ibb03 #來源單據
          AND ibb11 = 'Y'
   END IF
   IF cl_null(l_count) THEN LET l_count = 0 END IF
   IF l_count >=1 THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','','aba-215',1) #有已使用的條碼存在，不可重新產生。 
      ELSE
         CALL cl_err('','aba-215',1)
      END IF
      LET g_success = 'N'
      RETURN
   END IF
  #DEV-D40016--add---str---


   CASE p_ibb02
      WHEN 'A' #asfi301
         LET l_sql = "SELECT sfb01,0,sfb05,sfb08,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM sfb_file,ima_file",
                     " WHERE sfb01 = '",p_ibb03,"' ",
                     "   AND sfb05 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ))",
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) "
      WHEN 'B' #aqct410
         LET l_sql = "SELECT qcf01,0,qcf021,qcf091,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM qcf_file,ima_file",
                     " WHERE qcf01 = '",p_ibb03,"' ",
                     "   AND qcf021 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ))",
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) "
      WHEN 'C' #asft300
         LET l_sql = "SELECT srg01,srg02,srg03,srg05,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM srg_file,ima_file",
                     " WHERE srg01 = '",p_ibb03,"' ",
                     "   AND srg03 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ))",
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) ",
                     " ORDER BY srg02 "
      WHEN 'D' #asft700
         LET l_sql = "SELECT shb01,0,shb10,shb111,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM shb_file,ima_file",
                     " WHERE shb01 = '",p_ibb03,"' ",
                     "   AND shb10 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ))",
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) "
      WHEN 'E' #apmt720
         LET l_sql = "SELECT rvv01,rvv02,rvv31,rvv17,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM rvv_file,ima_file",
                     " WHERE rvv01 = '",p_ibb03,"' ",
                     "   AND rvv31 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ))",
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) ",
                     " ORDER BY rvv02 "
      WHEN 'F' #apmt540
         LET l_sql = "SELECT pmn01,pmn02,pmn04,pmn20,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM pmn_file,ima_file",
                     " WHERE pmn01 = '",p_ibb03,"' ",
                     "   AND pmn04 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ) OR ",                       #DEV-D40015 add OR
                     "        (ima918 <> 'Y' AND ima921 <> 'Y' AND ",     #DEV-D40015 add
                     "         ima930  = 'Y' )) ",                        #DEV-D40015 add
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) ",
                     " ORDER BY pmn02 "
      WHEN 'G' #apmt590
         LET l_sql = "SELECT pmn01,pmn02,pmn04,pmn20,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM pmn_file,ima_file",
                     " WHERE pmn01 = '",p_ibb03,"' ",
                     "   AND pmn04 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ) OR ",                       #DEV-D40015 add OR
                     "        (ima918 <> 'Y' AND ima921 <> 'Y' AND ",     #DEV-D40015 add
                     "         ima930  = 'Y' )) ",                        #DEV-D40015 add
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) ",
                     " ORDER BY pmn02 "
      WHEN 'I' #aimt302
         LET l_sql = "SELECT inb01,inb03,inb04,inb09,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM inb_file,ima_file",
                     " WHERE inb01 = '",p_ibb03,"' ",
                     "   AND inb04 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 NOT IN ('H','J')",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ))",
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) ",
                     " ORDER BY inb03 "
      WHEN 'K' #apmt110
         LET l_sql = "SELECT rvb01,rvb02,rvb05,rvb07,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM rvb_file,ima_file",
                     " WHERE rvb01 = '",p_ibb03,"' ",
                     "   AND rvb05 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ))",
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) ",
                     " ORDER BY rvb02 "
      WHEN 'L' #aqct110
         LET l_sql = "SELECT qcs01,0,qcs021,qcs091,",
                     "       ima932, ",
                     "       ima930, ",              #DEV-D40015 add
                     "       ima918,ima919,",
                     "       ima921,ima922,ima931 ",
                     "  FROM qcs_file,ima_file",
                     " WHERE qcs01 = '",p_ibb03,"' ",
                     "   AND qcs02 = '",p_ln,"'",
                     "   AND gcs05 = '",p_seq,"'",
                     "   AND qcs021 = ima01 ",
                     "   AND ima930 = 'Y' ",
                     "   AND ima932 = '",p_ibb02,"' ",
                     "   AND ((ima918 = 'Y' AND ima919 = 'Y') OR ",
                     "        (ima921 = 'Y' AND ima922 = 'Y') OR ",
                     "        (ima931 = 'Y' ))",
                     "   AND NOT((ima918 = 'Y' AND ima919 <> 'Y') OR ",
                     "           (ima921 = 'Y' AND ima922 <> 'Y') ) "
   END CASE

   PREPARE s_gen_barcode2_prep FROM l_sql
   DECLARE s_gen_barcode2_cs CURSOR FOR s_gen_barcode2_prep
 
   FOREACH s_gen_barcode2_cs INTO l_ibb03,l_ibb04,l_ibb06,l_ibb07,
                       l_ima932,
                       l_ima930,            #DEV-D40015 add
                       l_ima918,l_ima919,
                       l_ima921,l_ima922,
                       l_ima931
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','FOREACH s_gen_barcode2_cs:',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('FOREACH s_gen_barcode2_cs:',STATUS,0)
         END IF
         LET g_success = 'N'
         EXIT FOREACH
      END IF


      IF cl_null(l_ibb07) THEN LET l_ibb07 = 0 END IF

      IF l_ima918 = 'Y' AND l_ima919 = 'Y' THEN
         CALL s_gen_barcode('1',p_ibb02,l_ibb03,l_ibb04,l_ibb06,l_ibb07)
      END IF

      IF l_ima921 = 'Y' AND l_ima922 = 'Y' THEN
         CALL s_gen_barcode('2',p_ibb02,l_ibb03,l_ibb04,l_ibb06,l_ibb07)
      END IF

      IF l_ima931 = 'Y' THEN
         CALL s_gen_barcode('3',p_ibb02,l_ibb03,l_ibb04,l_ibb06,l_ibb07)
      END IF
      
     #DEV-D40015 add str----------------
     #條碼產生前判斷，若有勾選使用條碼 & 條碼產生時機='FG'，且無勾選批/序號欄位，則條碼產生給固定值為A+料號
      IF l_ima918 <> 'Y' AND l_ima921 <> 'Y' AND l_ima930 = 'Y' AND (l_ima932  = 'F' OR l_ima932 = 'G') THEN
         CALL s_gen_barcode3(p_ibb02,l_ibb03,l_ibb04,l_ibb06,l_ibb07)
      END IF
     #DEV-D40015 add end----------------
   END FOREACH

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode_z(p_ibb03)
   END IF
   #DEV-D30043--add--end

  #DEV-D40016--mark--str---
  ##檢查barcode是否有產生
  #不需有此控卡,因為有可能是不需產生條碼
  #LET l_count = 0
  #SELECT COUNT(*) INTO l_count
  #  FROM iba_file,ibb_file
  # WHERE iba01 = ibb01
  #   AND ibb03 = p_ibb03
  #IF cl_null(l_count) THEN LET l_count = 0 END IF

  #IF l_count = 0 THEN
  #   IF g_bgerr THEN
  #      CALL s_errmsg('','','','aba-118',1)
  #   ELSE
  #      CALL cl_err('','aba-118',0)
  #   END IF
  #   LET g_success = 'N'
  #END IF
  #DEV-D40016--mark--end---
END FUNCTION 


# Descriptions...: 檢查barcode是否可以作廢 
# Usage..........: CALL s_tlfb_chk2(p_ibb03)
#                  在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可作廢
# Input Parameter: p_ibb03:單號
# Return Code....: TRUE/FALSE
FUNCTION s_tlfb_chk2(p_ibb03)
   DEFINE p_ibb03  LIKE ibb_file.ibb03
   DEFINE l_cnt    LIKE type_file.num5

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM tlfb_file
    WHERE tlfb07 = p_ibb03
#   WHERE tlfb01 IN (SELECT UNIQUE ibb01 FROM ibb_file
#                     WHERE ibb03 = p_ibb03
#                       AND SUBSTR(ibb01,1,1) NOT IN ('5','F','G','X') #批號
#                         )
   IF l_cnt >=1 THEN
      #在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可作廢
      IF g_bgerr THEN
         CALL s_errmsg('ibb03',p_ibb03,'sle tlfb01','aba-182',1)
      ELSE
         CALL cl_err(p_ibb03,'aba-182',1)
      END IF
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION 


# Descriptions...: 條碼作廢副程式 
# Usage..........: CALL s_barcode_x2(p_ibb02,p_ibb03,p_ln,p_seq)
# Input Parameter: p_ibb02:產生時機點
#                  p_ibb03:來源單號
#                  p_ln   :單據項次   (for IQC之來源項次)
#                  p_seq  :順序       (for IQC之分批順序)
# Return Code....: 
FUNCTION s_barcode_x2(p_ibb02,p_ibb03,p_ln,p_seq)
   DEFINE p_ibb02     LIKE ibb_file.ibb02    #條碼產生時機點
   DEFINE p_ibb03     LIKE ibb_file.ibb03    #來源單號
   DEFINE p_ln        LIKE type_file.num5    #單據項次
   DEFINE p_seq       LIKE type_file.num5    #順序
   DEFINE l_ibb03     LIKE ibb_file.ibb03    #來源項次
   DEFINE l_ibb04     LIKE ibb_file.ibb04    #來源項次
   DEFINE l_ibb06     LIKE ibb_file.ibb06    #料號
   DEFINE l_ibb07     LIKE ibb_file.ibb07    #數量
   DEFINE l_ima918    LIKE ima_file.ima918
   DEFINE l_ima919    LIKE ima_file.ima919
   DEFINE l_ima921    LIKE ima_file.ima921
   DEFINE l_ima922    LIKE ima_file.ima922
   DEFINE l_ima931    LIKE ima_file.ima931
   DEFINE l_ima932    LIKE ima_file.ima932
   DEFINE l_sql       STRING
   DEFINE l_ima930    LIKE ima_file.ima930   #使用條碼否    #DEV-D40015 add
 
   WHENEVER ERROR CONTINUE

   #DEV-D40016--add---str---
   DROP TABLE iba_tmp1
   CREATE TEMP TABLE iba_tmp1(
       iba01     LIKE iba_file.iba01)      
  #DELETE FROM iba_tmp1
   #DEV-D40016--add---end---


   LET g_success = 'Y'

   #==>取條碼(D/H/X/Y/Z)要刪除的條碼至iba_tmp1
   #==>D:訂單包裝單
   #==>H:包號
   #==>X:製造批號-手動
   #==>Y:製造序號-手動
   #==>Z:製造批序號-因為是組合出來的條碼,所以不管是由手動或自動所產生的,皆刪除
   LET l_sql = "INSERT INTO iba_tmp1 ",
               " SELECT iba01 FROM iba_file ",
               "  WHERE iba01 IN (SELECT ibb01 FROM ibb_file",
               "                   WHERE SUBSTR(ibb01,1,1) IN ('D','H','X','Y','Z') ",
              #"                     AND ibb02 = '",p_ibb02,"'", #條碼產生時機點
               "                     AND ibb03 = '",p_ibb03,"'"  #來源單據
   IF p_ibb02 = 'L' THEN #條碼產生時機點:IQC
       LET l_sql = l_sql CLIPPED, " AND ibb04 = ",p_ln,"'", " AND ibb13 = ",p_seq,"'"
   END IF
   LET l_sql = l_sql CLIPPED, ")"
   PREPARE s_barcode_p1 FROM l_sql
   EXECUTE s_barcode_p1
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','s_barcode_p1:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('s_barcode_p1:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF

   #==>刪除iba_file
   LET l_sql = "DELETE FROM iba_file ",
               " WHERE iba01 IN (SELECT iba01 FROM iba_tmp1) "
   PREPARE s_barcode_p3 FROM l_sql
   EXECUTE s_barcode_p3
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','s_barcode_p3:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('s_barcode_p3:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF

   #==>刪除ibb_file
   LET l_sql = "DELETE FROM ibb_file ",
               " WHERE ibb01 IN (SELECT iba01 FROM iba_tmp1) "
   PREPARE s_barcode_p4 FROM l_sql
   EXECUTE s_barcode_p4
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','s_barcode_p4:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('s_barcode_p4:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF

   #==>UPDATE ibb_file
   #條碼F/G/5/6 ==>手動產生條碼的,UPDATE 使用否='N'
   #F:條碼批號-料號
   #G:條碼批號-工單
   #5:製造批號
   #6:序號編號
   LET l_sql = "UPDATE ibb_file ",
               "   SET ibb11 = 'N',", #使用否
               "       ibb12 = 0 ",   #列印次數
               " WHERE SUBSTR(ibb01,1,1) IN ('F','G','5','6') ",
              #"   AND ibb02 = '",p_ibb02,"'", #條碼產生時機點
               "   AND ibb03 = '",p_ibb03,"'"  #來源單據
   IF p_ibb02 = 'L' THEN #條碼產生時機點:IQC
       LET l_sql = l_sql CLIPPED, " AND ibb04 = ",p_ln,"'", " AND ibb13 = ",p_seq,"'"
   END IF
   PREPARE s_barcode_p5 FROM l_sql
   EXECUTE s_barcode_p5
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','s_barcode_p5:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('s_barcode_p5:',SQLCA.sqlcode,1)
      END IF
      LET g_success = 'N'
   END IF

END FUNCTION 
#DEV-D30045--add--end

#DEV-D40015 add str---------
# Descriptions...: 條碼產生副程式 
# Usage..........: CALL s_gen_barcode3(l_p1,l_p2,l_p3,l_p4,l_p5)
#              p1:F:採購單(apmt540)
#                 G:委外採購單(apmt590)
#              p2:來源單號
#              p3:來源項次
#              p4:料號
#              p5:數量
FUNCTION s_gen_barcode3(l_p1,l_p2,l_p3,l_p4,l_p5)
   DEFINE l_iba      RECORD LIKE iba_file.*
   DEFINE l_ibb      RECORD LIKE ibb_file.*
   DEFINE l_p1       LIKE type_file.chr1  #條碼產生時機點:F:採購單(apmt540)/G:委外採購單(apmt590)
   DEFINE l_p2       LIKE ibb_file.ibb03  #來源單號
   DEFINE l_p3       LIKE ibb_file.ibb04  #來源項次
   DEFINE l_p4       LIKE ima_file.ima01  #料號
   DEFINE l_p5       LIKE ibb_file.ibb07  #數量
   DEFINE l_cnt      LIKE type_file.num5
 
   LET l_iba.iba01 = 'F',l_p4 #條碼編號:F+料號(aooi401裡設定類別為F:條碼批號-料號,故代入F)
   LET l_iba.iba02 = 'F'      #條碼類型:F:條碼批號-料號
   LET l_iba.iba03 = l_p4     #條碼組成2:料號
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM iba_file
    WHERE iba01 = l_iba.iba01
   IF NOT(l_cnt > 0 AND l_iba.iba02 MATCHES '[5FGH]') THEN
      INSERT INTO iba_file VALUES(l_iba.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("ins","iba_file","","",SQLCA.sqlcode,"","",1)
          LET g_success='N'
          RETURN
      END IF
   END IF
 
   LET l_ibb.ibb01 = l_iba.iba01 #條碼編號
   LET l_ibb.ibb02 = l_p1        #
   LET l_ibb.ibb03 = l_p2        #來源單號
   LET l_ibb.ibb04 = l_p3        #來源項次
   LET l_ibb.ibb05 = 0           #包號
   LET l_ibb.ibb06 = l_p4        #料號
   LET l_ibb.ibb07 = l_p5        #數量
   LET l_ibb.ibb08 = NULL
   LET l_ibb.ibb09 = NULL
   LET l_ibb.ibb10 = 0           #總包數
   LET l_ibb.ibb11 = 'Y'
   LET l_ibb.ibb12 = 0
   LET l_ibb.ibbacti = 'Y'
   INSERT INTO ibb_file VALUES(l_ibb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("ins","ibb_file","","",SQLCA.sqlcode,"","",1)
       LET g_success='N'
   END IF
END FUNCTION
#DEV-D40015 add end---------

#DEV-D30043--add--begin
# Descriptions...: 條碼產生副程式-產生狀況:Z
# Usage..........: CALL s_gen_barcode_z(p_ibb03)
FUNCTION s_gen_barcode_z(p_ibb03)
   DEFINE p_ibb03     LIKE ibb_file.ibb03    #來源單號
   DEFINE l_sql       STRING
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_flag      LIKE type_file.chr1
   DEFINE l_iba       RECORD LIKE iba_file.*
   DEFINE l_ibb       RECORD LIKE ibb_file.*
   DEFINE l_iba01     LIKE iba_file.iba01
   DEFINE l_iba01_6   LIKE iba_file.iba01
   DEFINE l_ibb04     LIKE ibb_file.ibb04
   
   #批號
   LET l_sql = " SELECT iba01,ibb04 ",
               "   FROM iba_file,ibb_file",
               "  WHERE iba01 = ibb01",
               "    AND iba02 IN ('5','F','G')",
               "    AND ibb03 = '",p_ibb03,"'",
               "    AND ibb11 = 'Y'"
   PREPARE s_gen_barcode_z_pr FROM l_sql
   DECLARE s_gen_barcode_z_cs CURSOR FOR s_gen_barcode_z_pr

   #序號
   LET l_sql = " SELECT iba01,ibb_file.* ",
               "   FROM iba_file,ibb_file",
               "  WHERE iba01 = ibb01",
               "    AND iba02 = '6'",
               "    AND ibb03 = '",p_ibb03,"'",
               "    AND ibb04 = ? ",
               "    AND ibb11 = 'Y'"
   PREPARE s_gen_barcode_z_pr2 FROM l_sql
   DECLARE s_gen_barcode_z_cs2 CURSOR FOR s_gen_barcode_z_pr2
 
   FOREACH s_gen_barcode_z_cs INTO l_iba01,l_ibb04
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','FOREACH s_gen_barcode_z_cs:',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('FOREACH s_gen_barcode_z_cs:',STATUS,0)
         END IF
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      LET l_flag = 'N'
      FOREACH s_gen_barcode_z_cs2 USING l_ibb04 INTO l_iba01_6,l_ibb.*
         IF STATUS THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','FOREACH s_gen_barcode_z_cs2:',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('FOREACH s_gen_barcode_z_cs2:',STATUS,0)
            END IF
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         LET l_flag = 'Y'

         INITIALIZE l_iba.* TO NULL 
         LET l_iba.iba01 = 'Z',l_iba01,l_iba01_6
         LET l_iba.iba02 = 'Z'
         LET l_iba.iba03 = l_iba01
         LET l_iba.iba04 = l_iba01_6
 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM iba_file
          WHERE iba01 = l_iba.iba01
         IF l_cnt = 0 THEN
            INSERT INTO iba_file VALUES(l_iba.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               IF g_bgerr THEN
                  CALL s_errmsg('iba01',l_iba.iba01,'ins iba_file',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","iba_file","","",SQLCA.sqlcode,"","",1)
               END IF
               LET g_success='N'
               RETURN
            END IF
         END IF

         LET l_ibb.ibb01 = l_iba.iba01
         LET l_ibb.ibb10 = 0           #總包數
         LET l_ibb.ibb11 = 'Y'
         LET l_ibb.ibb12 = 0
         LET l_ibb.ibbacti = 'Y'
         LET l_ibb.ibb13 = 0
         INSERT INTO ibb_file VALUES(l_ibb.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            IF g_bgerr THEN
               CALL s_errmsg('iba01',l_iba.iba01,'ins iba_file',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","iba_file","","",SQLCA.sqlcode,"","",1)
            END IF
            LET g_success='N'
            RETURN
         END IF

         #序號
         UPDATE ibb_file SET ibb11 = 'N'
          WHERE ibb01 = l_iba01_6
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            IF g_bgerr THEN
               CALL s_errmsg('iba01',l_iba.iba01,'upd ibb11',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","iba_file","","",SQLCA.sqlcode,"","",1)
            END IF
            LET g_success='N'
            RETURN
         END IF
      END FOREACH

      IF l_flag = 'Y' THEN
         #批號
         UPDATE ibb_file SET ibb11 = 'N'
          WHERE ibb01 = l_iba01
            AND ibb04 = l_ibb04
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            IF g_bgerr THEN
               CALL s_errmsg('iba01',l_iba.iba01,'upd ibb11',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","iba_file","","",SQLCA.sqlcode,"","",1)
            END IF
            LET g_success='N'
            RETURN
         END IF
      END IF
   END FOREACH
END FUNCTION
#DEV-D30043--add--end

