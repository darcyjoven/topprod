# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
##□ s_ins_abi
##SYNTAX	   CALL s_ins_abi(p_aaa01,p_bdate,p_edate,
##		              p_aba03,p_aba04,p_ragen)
##DESCRIPTION      輸入要結轉的起始、截止的日期、年度、期別
##PARAMETERS       p_aaa01	帳別
##		   p_bdate	起始日期
##		   p_edate	截止日期
##		   p_aba03	年度
##		   p_aba04	期別
##		   p_ragen	'RA' 傳票重新產生否 (Y/N)
##RETURNING	   NONE
# Revise record..:
# Modify..........: No.FUN-5C0015 060104 BY GILL 處理abi31~abi36
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-710023 07/01/22 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B40026 11/06/13 By zhangweib NSERT INTO abi_file 時，取消寫入abi31~abi36
# Modify.........: No:MOD-BA0179 11/10/27 By Dido 增加 abilegal 資料 
# Modify.........: No:MOD-BC0035 11/12/05 By Dido 寫入 abi_file 後若多筆則應為更新 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_ins_abi(p_aaa01,p_bdate,p_edate,p_aba03,p_aba04,p_ragen)
   DEFINE  p_aaa01     LIKE aba_file.aba00,
           p_bdate     LIKE abh_file.abh021,       #No.FUN-680098  date
           p_edate     LIKE abh_file.abh021,       #No.FUN-680098  date
           p_aba03     LIKE aba_file.aba03,
           p_aba04     LIKE aba_file.aba04,
           p_ragen     LIKE type_file.chr1,        #No.FUN-680098   VARCHAR(1)
           l_sql       LIKE type_file.chr1000,     #No.FUN-680098   VARCHAR(3001)
           l_yy,l_mm   LIKE type_file.num5,        #No.FUN-680098   smallint
           l_sw        LIKE type_file.chr1,        #No.FUN-680098   VARCHAR(1)
           sr          RECORD LIKE abi_file.*,
           sr2         RECORD LIKE abg_file.*,
           l_abi       RECORD LIKE abi_file.*,
           l_abh       RECORD LIKE abh_file.*
 
   WHENEVER ERROR CONTINUE
   LET g_success = 'Y'
   DELETE FROM abi_file WHERE abi03 = p_aba03    #年度
                          AND abi04 = p_aba04    #期別
                          AND abi00 = p_aaa01    #帳別 no.7277
   IF SQLCA.sqlcode THEN   
#     CALL cl_err('del abi_file',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("del","abi_file",p_aba03,p_aba04,SQLCA.sqlcode,"","del abi_file",0)   #No.FUN-660123
      LET g_success = 'N' RETURN
   END IF
   #-------沖帳資料包含(上期abi_file 與 本期abg_file)-----------
    LET l_sql = "SELECT * FROM abh_file ",
                " WHERE abh00= ? AND abh07= ?  AND abh08= ? ",
                "   AND (abh021  BETWEEN '",p_bdate,"' AND '",p_edate,"')",
                "   AND abhconf='Y'"
    PREPARE ins_abhpre FROM l_sql  
    IF STATUS THEN 
       CALL cl_err('ins_abhpre:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    DECLARE ins_abh_curs CURSOR FOR ins_abhpre
 
   #-------期初資料包含(上期abi_file 與 本期abg_file)-----------
    IF p_aba04 = 1 THEN 
       LET l_yy = p_aba03 -1
       LET l_mm = 12
    ELSE 
       LET l_yy = p_aba03
       LET l_mm = p_aba04 - 1
    END IF
    LET l_sql = "SELECT abi_file.* FROM abi_file ",
                " WHERE abi00 = '",p_aaa01,"'",
                "   AND abi03 = ",l_yy,
                "   AND abi04 = ",l_mm,
                "   AND (abi08- abi09) > 0 "
    PREPARE ins_abi_p1 FROM l_sql
    IF STATUS THEN 
       CALL cl_err('pre ins_abi_p1:',STATUS,1) 
       LET g_success = 'N' RETURN
    END IF
    DECLARE ins_abi_c1 CURSOR FOR ins_abi_p1
    FOREACH ins_abi_c1 INTO sr.*
#NO.FUN-710023--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710023--END
       IF SQLCA.sqlcode THEN 
#         CALL cl_err('ins_abi_c1',SQLCA.sqlcode,0) #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=p_aaa01,"/",l_yy
            CALL s_errmsg('abi00,abi03',g_showmsg,'ins_abi_c1',SQLCA.sqlcode,0)
          ELSE
            CALL cl_err('ins_abi_c1',SQLCA.sqlcode,0)
          END IF
#NO.FUN-710023--END
          LET g_success='N'    #FUN-8A0086
          EXIT FOREACH
       END IF
       IF cl_null(sr.abi08) THEN 
#         CALL cl_err('error abi08 is null ',SQLCA.sqlcode,1) #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=p_aaa01,"/",l_yy
            CALL s_errmsg('abi00,abi03',g_showmsg,'error abi08 is null ',SQLCA.sqlcode,1)
          ELSE
            CALL cl_err('error abi08 is null ',SQLCA.sqlcode,1)
          END IF
#NO.FUN-710023--END
          LET g_success = 'N'
       END IF
       LET l_abi.abi00 = sr.abi00
       LET l_abi.abi01 = sr.abi01
       LET l_abi.abi02 = sr.abi02
       LET l_abi.abi03 = p_aba03  
       LET l_abi.abi04 = p_aba04   
       LET l_abi.abi05 = sr.abi05
       LET l_abi.abi06 = sr.abi06
       LET l_abi.abi07 = sr.abi07
       LET l_abi.abi08 = sr.abi08- sr.abi09
       LET l_abi.abi09 = 0 
       LET l_abi.abi10 = sr.abi10
       LET l_abi.abi11 = sr.abi11
       LET l_abi.abi12 = sr.abi12
       LET l_abi.abi13 = sr.abi13
       LET l_abi.abi14 = sr.abi14
 
       #FUN-5C0015 BY GILL --START
       LET l_abi.abi31 = sr.abi31
       LET l_abi.abi32 = sr.abi32
       LET l_abi.abi33 = sr.abi33
       LET l_abi.abi34 = sr.abi34
       LET l_abi.abi35 = sr.abi35
       LET l_abi.abi36 = sr.abi36
       #FUN-5C0015 BY GILL --END
 
       LET l_abi.abilegal = g_legal #FUN-980003 add 
      #INSERT INTO abi_file VALUES(l_abi.*)    #FUN-B40026   Mark
#FUN-B40026   ---start   Add
       INSERT INTO abi_file(abi00,abi01,abi02,abi03,abi04,abi05,
                            abi06,abi07,abi08,abi09,abi10,abi11,
                            abi12,abi13,abi14,abi15,abi16,abi37,
                            abilegal)                             #MOD-BA0179
                     VALUES(l_abi.abi00,l_abi.abi01,l_abi.abi02,
                            l_abi.abi03,l_abi.abi04,l_abi.abi05,
                            l_abi.abi06,l_abi.abi07,l_abi.abi08,
                            l_abi.abi09,l_abi.abi10,l_abi.abi11,
                            l_abi.abi12,l_abi.abi13,l_abi.abi14,
                            l_abi.abi15,l_abi.abi16,l_abi.abi37,
                            l_abi.abilegal)                       #MOD-BA0179
#FUN-B40026   ---end     Add
       IF SQLCA.sqlcode THEN
#         CALL cl_err('ins abi_file',SQLCA.sqlcode,0)   #No.FUN-660123
#         CALL cl_err3("ins","abi_file",l_abi.abi01,l_abi.abi02,SQLCA.sqlcode,"","ins abi_file",0)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=sr.abi00,"/",sr.abi01,"/",sr.abi02
            CALL cl_err3("ins","abi_file",l_abi.abi01,l_abi.abi02,SQLCA.sqlcode,"","ins abi_file",0)   
          ELSE
            CALL cl_err('ins abi_file',SQLCA.sqlcode,0)
          END IF
#NO.FUN-710023--END
          LET g_success = 'N'
       END IF
       #-->取當期沖帳資料
       FOREACH ins_abh_curs USING sr.abi00,sr.abi01,sr.abi02 INTO l_abh.*
         IF SQLCA.sqlcode THEN 
#           CALL cl_err('ins_abh_curs',SQLCA.sqlcode,0) #NO.FUN-710023
#NO.FUN-710023--BEGIN
            IF g_bgerr THEN
              LET g_showmsg=sr.abi00,"/",sr.abi01,"/",sr.abi02
              CALL s_errmsg('abh00,abh07,abh08',g_showmsg,'ins_abh_curs',SQLCA.sqlcode,0)
            ELSE
              CALL cl_err('ins_abh_curs',SQLCA.sqlcode,0)
            END IF
#NO.FUN-710023--END
            EXIT FOREACH 
         END IF
         UPDATE abi_file SET abi09 = abi09 + l_abh.abh09
                       WHERE abi00 = p_aaa01
                         AND abi01 = sr.abi01
                         AND abi02 = sr.abi02
                         AND abi03 = p_aba03
                         AND abi04 = p_aba04
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err('upd abi_file',SQLCA.sqlcode,0)   #No.FUN-660123
#              CALL cl_err3("upd","abi_file",p_aaa01,sr.abi01,SQLCA.sqlcode,"","upd abi_file",0)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
               IF g_bgerr THEN
                  LET g_showmsg=p_aaa01,"/",sr.abi01,"/",sr.abi02,"/",p_aba03,"/",p_aba04
                  CALL s_errmsg('abi00,abi01,abi02,abi03,abi04',g_showmsg,'upd abi_file',SQLCA.sqlcode,0)
               ELSE
                  CALL cl_err3("upd","abi_file",p_aaa01,sr.abi01,SQLCA.sqlcode,"","upd abi_file",0)   
               END IF
#NO.FUN-710023--END
               LET g_success = 'N'
            END IF
       END FOREACH 
    END FOREACH 
#NO.FUN-710023--BEGIN                                                           
    IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
    END IF                                                                          
#NO.FUN-710023--END
 
   #-------當期立帳(沖帳)資料先update 如果沒有則insert -----------
    LET l_sql = "SELECT abg_file.* FROM abg_file ",
                " WHERE (abg06 BETWEEN '",p_bdate,"' AND '",p_edate,"')",
                "   AND abg00 = '",p_aaa01,"'"
    PREPARE ins_abi_p2 FROM l_sql
    IF STATUS THEN 
#      CALL cl_err('pre ins_abi_p2:',STATUS,1)  #NO.FUN-710023
#NO.FUN-710023--BEGIN
       IF g_bgerr THEN
          CALL s_errmsg('abg00',p_aaa01,'pre ins_abi_p2:',STATUS,1)
       ELSE
          CALL cl_err('pre ins_abi_p2:',STATUS,1)
       END IF
#NO.FUN-710023--END
       LET g_success = 'N' RETURN
    END IF
    DECLARE ins_abi_c2 CURSOR FOR ins_abi_p2
 
    FOREACH ins_abi_c2 INTO sr2.*
#NO.FUN-710023--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710023--END
       IF SQLCA.sqlcode THEN 
#       CALL cl_err('ins_abi_c2',SQLCA.sqlcode,0) 
#NO.FUN-710023--BEGIN
        IF g_bgerr THEN
         CALL s_errmsg('abg00',p_aaa01,'ins_abi_c2',SQLCA.sqlcode,0)
        ELSE
         CALL cl_err('ins_abi_c2',SQLCA.sqlcode,0)
        END IF
#NO.FUN-710023--END
          EXIT FOREACH 
       END IF
         LET l_abi.abi00 = sr2.abg00
         LET l_abi.abi01 = sr2.abg01
         LET l_abi.abi02 = sr2.abg02
         LET l_abi.abi03 = p_aba03  
         LET l_abi.abi04 = p_aba04   
         LET l_abi.abi05 = sr2.abg03
         LET l_abi.abi06 = sr2.abg06
         LET l_abi.abi07 = sr2.abg05
         LET l_abi.abi08 = sr2.abg071
         LET l_abi.abi09 = 0 
         LET l_abi.abi10 = sr2.abg04
         LET l_abi.abi11 = sr2.abg11
         LET l_abi.abi12 = sr2.abg12
         LET l_abi.abi13 = sr2.abg13
         LET l_abi.abi14 = sr2.abg14
 
         #FUN-5C0015 BY GILL --START
         LET l_abi.abi31 = sr2.abg31
         LET l_abi.abi32 = sr2.abg32
         LET l_abi.abi33 = sr2.abg33
         LET l_abi.abi34 = sr2.abg34
         LET l_abi.abi35 = sr2.abg35
         LET l_abi.abi36 = sr2.abg36
         #FUN-5C0015 BY GILL --END
         LET l_abi.abilegal = g_legal #FUN-980003 add 
 
         LET l_sw = 'N'
       FOREACH ins_abh_curs USING sr2.abg00,sr2.abg01,sr2.abg02 INTO l_abh.*
          IF SQLCA.sqlcode THEN 
#            CALL cl_err('ins_abh_curs',SQLCA.sqlcode,0) #NO.FUN-710023
#NO.FUN-710023--BEGIN
             IF g_bgerr THEN
               LET g_showmsg=sr2.abg00,"/",sr2.abg01,"/",sr2.abg02
               CALL s_errmsg('abh00,abh07,abh08',g_showmsg,'ins_abh_curs',SQLCA.sqlcode,0)
             ELSE
                CALL cl_err('ins_abh_curs',SQLCA.sqlcode,0)
             END IF
#NO.FUN-710023--END
             EXIT FOREACH 
          END IF
          LET l_sw = 'Y'
          IF l_abh.abh09 > 0 THEN LET l_abi.abi09 = l_abh.abh09 END IF   #MOD-BC0035
         #INSERT INTO abi_file VALUES(l_abi.*)   #FUN-B40026   Mark
#FUN-B40026   ---start   Add
          INSERT INTO abi_file(abi00,abi01,abi02,abi03,abi04,abi05,
                               abi06,abi07,abi08,abi09,abi10,abi11,
                               abi12,abi13,abi14,abi15,abi16,abi37,
                               abilegal)                            #MOD-BA0179
                        VALUES(l_abi.abi00,l_abi.abi01,l_abi.abi02,
                               l_abi.abi03,l_abi.abi04,l_abi.abi05,
                               l_abi.abi06,l_abi.abi07,l_abi.abi08,
                               l_abi.abi09,l_abi.abi10,l_abi.abi11,
                               l_abi.abi12,l_abi.abi13,l_abi.abi14,
                               l_abi.abi15,l_abi.abi16,l_abi.abi37,
                               l_abi.abilegal)                      #MOD-BA0179
#FUN-B40026   ---end     Add
         #-MOD-BA0179-add-
         #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN #MOD-BC0035 mark
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN       #MOD-BC0035
         #-MOD-BC0035-mark-
         #   IF g_bgerr THEN
         #      LET g_showmsg=l_abi.abi00,"/",l_abi.abi01,"/",l_abi.abi02,"/",l_abi.abi03,"/",l_abi.abi04
         #      CALL s_errmsg('abi00,abi01,abi02,abi03,abi04',g_showmsg,'ins abi_file',SQLCA.sqlcode,0)
         #   ELSE
         #      CALL cl_err3("ins","abi_file",l_abi.abi00,l_abi.abi01,SQLCA.sqlcode,"","ins abi_file",0)   
         #   END IF
         #   LET g_success = 'N'
         #END IF
         #-MOD-BC0035-end-
         #-MOD-BA0179-end-
             UPDATE abi_file SET abi09 = abi09 + l_abh.abh09
              WHERE abi00 = p_aaa01
                AND abi01 = sr2.abg01
                AND abi02 = sr2.abg02
                AND abi03 = p_aba03
                AND abi04 = p_aba04
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#               CALL cl_err('upd abi_file',SQLCA.sqlcode,0)   #No.FUN-660123
#               CALL cl_err3("upd","abi_file",p_aaa01,sr2.abg01,SQLCA.sqlcode,"","upd abi_file",0)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
                IF g_bgerr THEN
                  LET g_showmsg=p_aaa01,"/",sr2.abg01,"/",sr2.abg02,"/",p_aba03,"/",p_aba04
                  CALL s_errmsg('abi00,abi01,abi02,abi03,abi04',g_showmsg,'upd abi_file',SQLCA.sqlcode,0)
                ELSE
                  CALL cl_err3("upd","abi_file",p_aaa01,sr2.abg01,SQLCA.sqlcode,"","upd abi_file",0)   
                END IF
#NO.FUN-710023--END
                LET g_success = 'N'
             END IF
          END IF   #MOD-BC0035
       END FOREACH 
       #--->當期有立帳沒有沖帳
       IF l_sw = 'N' THEN 
         #INSERT INTO abi_file VALUES(l_abi.*)   #FUN-B40026   Mark
#FUN-B40026   ---start   Add
       INSERT INTO abi_file(abi00,abi01,abi02,abi03,abi04,abi05,
                            abi06,abi07,abi08,abi09,abi10,abi11,
                            abi12,abi13,abi14,abi15,abi16,abi37,
                            abilegal)                            #MOD-BA0179
                     VALUES(l_abi.abi00,l_abi.abi01,l_abi.abi02,
                            l_abi.abi03,l_abi.abi04,l_abi.abi05,
                            l_abi.abi06,l_abi.abi07,l_abi.abi08,
                            l_abi.abi09,l_abi.abi10,l_abi.abi11,
                            l_abi.abi12,l_abi.abi13,l_abi.abi14,
                            l_abi.abi15,l_abi.abi16,l_abi.abi37,
                            l_abi.abilegal)                      #MOD-BA0179
#FUN-B40026   ---end     Add
         #IF SQLCA.sqlcode THEN                          #MOD-BA0179 mark
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN  #MOD-BA0179 
#            CALL cl_err('ins abi_file',SQLCA.sqlcode,0)   #No.FUN-660123
#            CALL cl_err3("ins","abi_file",l_abi.abi01,l_abi.abi02,SQLCA.sqlcode,"","ins abi_file",0)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
             IF g_bgerr THEN
               LET g_showmsg=sr2.abg00,"/",sr2.abg01,"/",sr2.abg02
               CALL s_errmsg('abi00,abi01,abi02,abi03,abi04',g_showmsg,'ins abi_file',SQLCA.sqlcode,0)
             ELSE
               CALL cl_err3("ins","abi_file",l_abi.abi01,l_abi.abi02,SQLCA.sqlcode,"","ins abi_file",0)   
             END IF
#NO.FUN-710023--END
            LET g_success = 'N' 
          END IF
       END IF
    END FOREACH 
#NO.FUN-710023--BEGIN                                                           
    IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
    END IF                                                                          
#NO.FUN-710023--END
 
END FUNCTION
