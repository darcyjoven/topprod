# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
##□ s_armauno
##SYNTAX                CALL s_armauno(p_slip,p_date)
##                              RETURNING l_stat,l_slip
##DESCRIPTION   自動賦予單據以單號
##PARAMETERS    p_slip  單號
##RETURNING             l_stat  結果碼 0:OK, 1:FAIL
##                              l_slip  單號
##NOTE                  WITHOUT COMMIT WORK
# Date & Author..: 94/12/22 By Danny
# NOTE...........: 1.若使用自動編號但傳入之單別有單號, 則判斷其單號
#                    是否大於已用單號, 若大於則更新已用單號
#                  2.呼叫後請判斷傳回的第一個值, 若不等於0,表示有問題
# Revise record..:
#   1992/08/03 (Lee): 因為4.0在使用PICTURE='XXX-XXXXXX'輸入後, 並不將
#                     第四個byte的'-'自動給予變數, 故在所有的處理完後
#                     將資料丟回去前, 將第四個byte指定成'-'. (對2.0版
#                     本來說是多此一舉)
# modify..........: 96-09-13 by kitty 單據編號方式如有不同,則須增加判斷
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()            
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS
DEFINE
    g_rmno         LIKE oea_file.oea01,  #No.FUN-690010 VARCHAR(10),   #
    g_waitsec      LIKE type_file.num5   #No.FUN-690010 SMALLINT
END GLOBALS
 
FUNCTION s_armauno(p_slip,p_date)
DEFINE
    p_slip LIKE ton_file.ton01,    #No.FUN-690010 VARCHAR(10),                    #單號
    p_date LIKE type_file.dat,     #No.FUN-690010 DATE,                        #單據日期
    l_slip LIKE oay_file.oayslip,  #單別
    g_oay           RECORD LIKE oay_file.*,   #單據性質
    l_rmno LIKE type_file.chr6,            #No.FUN-690010 VARCHAR(6),
    l_year,l_month LIKE type_file.num10,   #No.FUN-690010 INTEGER,
    l_int          LIKE type_file.num10,   #No.FUN-690010 INTEGER,
    l_buf          LIKE type_file.chr6,    #No.FUN-690010 VARCHAR(6)
    l_date         LIKE type_file.chr6,    #No.FUN-690010 VARCHAR(6),       #96-09-13
    l_date1        LIKE type_file.chr2     #No.FUN-690010 VARCHAR(2)        #96-09-13
 
        WHENEVER ERROR CONTINUE
 
        IF p_slip[5,10]<>' ' THEN RETURN 0,p_slip END IF
        LET l_rmno = NULL
        LET g_rmno = NULL
        LET l_slip=p_slip[1,3]
        SELECT azn02,azn04 INTO l_year,l_month FROM azn_file WHERE azn01=p_date
        IF STATUS THEN 
           LET l_year =YEAR(p_date)
           LET l_month=MONTH(p_date)
        END IF
 
        SELECT * INTO g_oay.* FROM oay_file  #單據編號方式
         WHERE oayslip = l_slip
        IF SQLCA.sqlcode THEN
 #          CALL cl_err('oaydmy6:read oay:',SQLCA.sqlcode,1) #FUN-660111
           CALL cl_err3("sel","oay_file",l_slip,"",SQLCA.sqlcode,"","oaydamy6:read oay:",1) #FUN-660111
           RETURN 1,p_slip
        END IF
        IF g_oay.oaydmy6 = "1" THEN    #依流水號
           CASE 
             WHEN g_oay.oaytype MATCHES '[1-3]*'
               SELECT MAX(oea01) INTO g_rmno FROM oea_file
                WHERE oea01[1,3] = l_slip
             WHEN g_oay.oaytype ='55'
               SELECT MAX(ofa01) INTO g_rmno FROM ofa_file
                WHERE ofa01[1,3] = l_slip
             WHEN g_oay.oaytype MATCHES '[4-5]*'
               SELECT MAX(oga01) INTO g_rmno FROM oga_file
                WHERE oga01[1,3] = l_slip
             WHEN g_oay.oaytype MATCHES '60'
               SELECT MAX(rma01) INTO g_rmno FROM rma_file
                WHERE rma01[1,3] = l_slip
              #SELECT MAX(oha01) INTO g_rmno FROM oha_file
              # WHERE oha01[1,3] = l_slip
             WHEN g_oay.oaytype ='70'
               SELECT MAX(rma01) INTO g_rmno FROM rma_file
                WHERE rma01[1,3] = l_slip
             WHEN g_oay.oaytype ='71'
               SELECT MAX(rme01) INTO g_rmno FROM rme_file
                WHERE rme01[1,3] = l_slip
             WHEN g_oay.oaytype ='72'
               SELECT MAX(rmi01) INTO g_rmno FROM rmi_file
                WHERE rmi01[1,3] = l_slip
             WHEN g_oay.oaytype ='73'
               SELECT MAX(rmj01) INTO g_rmno FROM rmj_file
                WHERE rmj01[1,3] = l_slip
             WHEN g_oay.oaytype ='74'
               SELECT MAX(rmj08) INTO g_rmno FROM rmj_file
                WHERE rmj08[1,3] = l_slip
             WHEN g_oay.oaytype ='75'
               SELECT MAX(rmn01) INTO g_rmno FROM rmn_file
                WHERE rmn01[1,3] = l_slip
 
             OTHERWISE EXIT CASE
           END CASE
        ELSE             #依年度期別
           #----- modi by kitty 96-09-13 ---------------
           LET l_date = l_year USING '&&&&',l_month USING '&&'
           LET l_date1[1,1]=l_date[4,4]
                 CASE WHEN l_month = 10 LET l_date1[2,2]='A'
                      WHEN l_month = 11 LET l_date1[2,2]='B'
                      WHEN l_month = 12 LET l_date1[2,2]='C'
                      OTHERWISE         LET l_date1[2,2]=l_date[6,6]
                 END CASE
           LET l_buf=l_slip,'-',l_date1
           #-------------------------------------------
           CASE 
             WHEN g_oay.oaytype MATCHES '[1-3]*'
               SELECT MAX(oea01) INTO g_rmno FROM oea_file
                WHERE oea01[1,6] = l_buf
             WHEN g_oay.oaytype = '55'
               SELECT MAX(ofa01) INTO g_rmno FROM ofa_file
                WHERE ofa01[1,6] = l_buf
             WHEN g_oay.oaytype MATCHES '[4-5]*'
               SELECT MAX(oga01) INTO g_rmno FROM oga_file
                WHERE oga01[1,6] = l_buf
             WHEN g_oay.oaytype MATCHES '60'
               SELECT MAX(rma01) INTO g_rmno FROM rma_file
                WHERE rma01[1,6] = l_buf
              #SELECT MAX(oha01) INTO g_rmno FROM oha_file
              # WHERE oha01[1,6] = l_buf
             WHEN g_oay.oaytype = '70'
               SELECT MAX(rma01) INTO g_rmno FROM rma_file
                WHERE rma01[1,6] = l_buf
             WHEN g_oay.oaytype = '71'
               SELECT MAX(rme01) INTO g_rmno FROM rme_file
                WHERE rme01[1,6] = l_buf
             WHEN g_oay.oaytype = '72'
               SELECT MAX(rmi01) INTO g_rmno FROM rmi_file
                WHERE rmi01[1,6] = l_buf
             WHEN g_oay.oaytype = '73'
               SELECT MAX(rmj01) INTO g_rmno FROM rmj_file
                WHERE rmj01[1,6] = l_buf
             WHEN g_oay.oaytype = '74'
               SELECT MAX(rme08) INTO g_rmno FROM rme_file
                WHERE rme08[1,6] = l_buf
             WHEN g_oay.oaytype = '75'
               SELECT MAX(rmn01) INTO g_rmno FROM rmn_file
                WHERE rmn01[1,6] = l_buf
 
             OTHERWISE EXIT CASE
           END CASE
        END IF   
 
        LET l_rmno = g_rmno[5,10] 
 
        IF cl_null(p_slip[5,10]) THEN
           IF g_oay.oaydmy6 = "1" THEN                #依流水號
              IF l_rmno IS NULL OR l_rmno=' ' THEN    #最大編號未曾指定
                 LET l_rmno = '000000'
              END IF
              LET p_slip[5,10]=(l_rmno+1) USING '&&&&&&'
           ELSE                                       #依年月
              IF l_rmno IS NULL OR l_rmno=' ' THEN    #最大編號未曾指定
                 LET l_buf = l_year USING '&&&&',l_month USING '&&'
                 LET l_rmno[1,1]=l_buf[4,4]
                 CASE WHEN l_month = 10 LET l_rmno[2,2]='A'
                      WHEN l_month = 11 LET l_rmno[2,2]='B'
                      WHEN l_month = 12 LET l_rmno[2,2]='C'
                      OTHERWISE         LET l_rmno[2,2]=l_buf[6,6]
                END CASE
                LET l_rmno[3,6]='0000'
              END IF
              LET p_slip[5,10]=l_rmno[1,2],(l_rmno[3,6]+1) USING '&&&&'
          END IF
       END IF
 
    #因為4.0版本的不自動加上'-', 故在此吾人須多此一舉
    LET p_slip[4,4]='-'
    RETURN 0,p_slip
END FUNCTION
