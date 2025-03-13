# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# □ s_duedate
# SYNTAX.........:CALL s_duedate(p_vendor,start_date,ndays)
# Descriptions...:票據到期日
# PARAMETERS.....: p_vendor     付款廠商編號
#                  start_date   應付款日
#                  ndays        允許票期
# RETURN.........: due_date     票到期日
# DATE & Author..: 99/11/5 
# Modify.........: 99/12/16 By Kammy
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
FUNCTION s_duedate(p_vendor,start_date,ndays)
   DEFINE p_vendor	        LIKE apa_file.apa06   #No.FUN-690028 VARCHAR(10)              #FUN-660117 remark
   DEFINE start_date,due_date   LIKE type_file.dat    #No.FUN-690028 DATE
   DEFINE c_date	        LIKE type_file.chr8   #No.FUN-690028 VARCHAR(8)
   DEFINE ndays,mm,dd,dd2	LIKE type_file.num5   #No.FUN-690028 SMALLINT
 
   LET due_date = start_date + ndays
   LET c_date = due_date USING 'yyyymmdd'
 
   SELECT pmc50,pmc51 INTO dd,dd2 FROM pmc_file WHERE pmc01 = p_vendor
   IF ndays > 0 THEN LET dd = dd2 END IF
   IF SQLCA.SQLCODE = 0 AND dd > 0 AND dd < 30
      THEN LET c_date = due_date USING 'yyyymmdd'
           ### 96-06-25 by charis
           IF c_date[7,8] > dd THEN
              LET c_date[5,6] = (c_date[5,6] + 1) USING '&&'
              IF c_date[5,6] > '12' THEN
                 LET c_date[1,4] = (c_date[1,4] + 1) USING '&&&&'
                 LET c_date[5,6] = (c_date[5,6] - 12) USING '&&'
              END IF
           END IF
           ####
           LET c_date[7,8] = dd USING '&&'
           LET due_date = c_date
           WHILE STATUS != 0 AND c_date[7,8] > '00'
               LET c_date[7,8] = (c_date[7,8] - 1) USING '&&'
               LET due_date = c_date
           END WHILE
   END IF
   RETURN due_date
END FUNCTION
