# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name ..: s_upd_cnq                                                     
# DESCRIPTION....: 更新cnq_file(進出口報關異動明細檔)                           
#                  acot500/acot510/acot520使用到
# Date & Autor...: 05/01/19 By Carrier                                          
# Modify.........: No.TQC-660045 06/06/09 By hellen  cl_err --> cl_err3
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-980002 09/08/06 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BB0084 11/12/14 By lixh1 增加數量欄位小數取位
 
DATABASE ds                                                                     
GLOBALS "../../config/top.global"    
 
FUNCTION s_upd_cnq(p_no,p_cnp02,p_cnp05,p_cnp06,p_cnp07,p_cnp08,p_chr)
  DEFINE p_no     LIKE cno_file.cno01
  DEFINE p_cnp02  LIKE cnp_file.cnp02
  DEFINE p_cnp05  LIKE cnp_file.cnp05
  DEFINE p_cnp06  LIKE cnp_file.cnp06
  DEFINE p_cnp07  LIKE cnp_file.cnp07
  DEFINE p_cnp08  LIKE cnp_file.cnp08
  DEFINE p_chr    LIKE type_file.chr1         #No.FUN-680069  VARCHAR(1)
  DEFINE l_cnp03  LIKE cnp_file.cnp03
  DEFINE l_cnp12  LIKE cnp_file.cnp12
  DEFINE l_cno    RECORD LIKE cno_file.*
  DEFINE l_cnq    RECORD LIKE cnq_file.*
 
      #---------------- 更新 cnq_file -----------------------------------
      SELECT * INTO l_cno.* FROM cno_file WHERE cno01 = p_no
      IF SQLCA.sqlcode THEN LET g_success ='N' RETURN END IF
      SELECT UNIQUE cnp03 INTO l_cnp03 FROM cnp_file  #商品編號
       WHERE cnp01 = p_no AND cnp02 = p_cnp02
      IF p_chr = 'y' THEN
         INITIALIZE l_cnq.* TO NULL
         LET l_cnq.cnq01 = l_cno.cno10   #手冊編號
         LET l_cnq.cnq02 = l_cnp03       #商品編號
         LET l_cnq.cnq03 = l_cno.cno01   #異動單號
         LET l_cnq.cnq04 = l_cno.cno02   #異動日期
         #半成品歸為成品 '3' ---> '1'
         IF l_cno.cno03 = '3' THEN LET l_cno.cno03 = '1' END IF
         LET l_cnq.cnq05 = l_cno.cno03   #型態
         LET l_cnq.cnq06 = l_cno.cno031  #交易型態
         LET l_cnq.cnq07 = l_cno.cno04   #類別
         LET l_cnq.cnq08 = p_cnp02       #備案序號
         LET l_cnq.cnq09 = l_cno.cno20   #海關代號
         LET l_cnq.cnq10 = l_cno.cno06   #報關單號
         LET l_cnq.cnq11 = l_cno.cno07   #報關日期
         LET l_cnq.cnq12 = l_cno.cno18   #折合單號/對應手冊編號
         LET l_cnq.cnq13 = p_cnp05       #異動數量
         LET l_cnq.cnq14 = p_cnp06       #單位   
         LET l_cnq.cnq13 = s_digqty(l_cnq.cnq13,l_cnq.cnq14)   #FUN-BB0084 
         LET l_cnq.cnq15 = p_cnp07       #單價   
         LET l_cnq.cnq16 = p_cnp08       #金額  
         LET l_cnq.cnqplant = g_plant  #FUN-980002
         LET l_cnq.cnqlegal = g_legal  #FUN-980002
      
         INSERT INTO cnq_file VALUES (l_cnq.*)
         IF SQLCA.sqlcode THEN
#           CALL cl_err('insert cnq_file',SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","cnq_file",l_cnq.cnq01,l_cnq.cnq02,SQLCA.sqlcode,"","insert cnq_file",0) #TQC-660045
            LET g_success ='N'
            RETURN
         END IF
      ELSE
         DELETE FROM cnq_file 
          WHERE cnq01 = l_cno.cno10  AND cnq02 = l_cnp03
            AND cnq03 = l_cno.cno01  AND cnq05 = l_cno.cno03
            AND cnq06 = l_cno.cno031 AND cnq07 = l_cno.cno04
            AND cnq08 = p_cnp02
         IF SQLCA.sqlcode THEN 
#           CALL cl_err('delete cnq_file',SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("del","cnq_file",l_cno.cno01,l_cnp03,SQLCA.sqlcode,"","delete cnq_file",0) #TQC-660045
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      #---------------- 更新 cnq_file 結束-------------------------------
END FUNCTION
