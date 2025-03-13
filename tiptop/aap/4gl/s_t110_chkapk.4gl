# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
#No.+111 010510 by plym add 調整apk折讓單稅額和單頭有無誤差
#no.4478 020412 by Kammy 參數加一sta '1'由saapt110串過來
#                                    '2'由 aapp112串過來(aapp112只處理apk部份)
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B30575 11/03/16 By Sarah 增加判斷幣別皆為本國幣別時,應該連原幣的apk欄位也一併調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION t110_chkapk(l_apa01,g_apa01,sta)  #l_apa01:折讓單號 g_apa01:請款單號
 DEFINE  sta            LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),
         g_apa01        LIKE apa_file.apa01,
         l_apa01        LIKE apa_file.apa01,
         g_apa00        LIKE apa_file.apa00,
         g_apa58        LIKE apa_file.apa58,
         g_apa60        LIKE apa_file.apa60,
         g_apa61        LIKE apa_file.apa61,
         g_apa61f       LIKE apa_file.apa61f,
         g_apa60f       LIKE apa_file.apa60f,
         l_apa31        LIKE apa_file.apa31,
         l_apa32        LIKE apa_file.apa32,
         l_apa34        LIKE apa_file.apa34,
         l_apa31f       LIKE apa_file.apa31f,       #MOD-B30575 add
         l_apa32f       LIKE apa_file.apa32f,       #MOD-B30575 add
         l_apa34f       LIKE apa_file.apa34f,       #MOD-B30575 add
         t_apk08        LIKE apk_file.apk08,
         t_apk07        LIKE apk_file.apk07,
         t_apk06        LIKE apk_file.apk06,
         t_apk08f       LIKE apk_file.apk08f,       #MOD-B30575 add
         t_apk07f       LIKE apk_file.apk07f,       #MOD-B30575 add
         t_apk06f       LIKE apk_file.apk06f,       #MOD-B30575 add
         l_apk06        LIKE apk_file.apk06,
         l_diffapk08    LIKE apk_file.apk08,
         l_diffapk07    LIKE apk_file.apk07,
         l_diffapk06    LIKE apk_file.apk06,
         l_diffapk08f   LIKE apk_file.apk08f,       #MOD-B30575 add
         l_diffapk07f   LIKE apk_file.apk07f,       #MOD-B30575 add
         l_diffapk06f   LIKE apk_file.apk06f,       #MOD-B30575 add
         l_apk02        LIKE apk_file.apk02,
         l_apk12        LIKE apk_file.apk12,        #MOD-B30575 add
         l_cnt          LIKE type_file.num5         #MOD-B30575 add
 
    WHENEVER ERROR CONTINUE
    DECLARE t110_apk02 CURSOR FOR
     SELECT apk02,apk06 FROM apk_file
      WHERE apk01=l_apa01 AND apk06 !=0
      ORDER BY apk06 DESC
    FOREACH t110_apk02 INTO l_apk02,l_apk06 
       EXIT FOREACH
    END FOREACH
    IF cl_null(l_apk02) OR l_apk02=0 THEN RETURN END IF

   #str MOD-B30575 add
    #折讓資料
    SELECT apa31,apa32,apa34,
           apa31f,apa32f,apa34f         #MOD-B30575 add
      INTO l_apa31,l_apa32,l_apa34,
           l_apa31f,l_apa32f,l_apa34f   #MOD-B30575 add
      FROM apa_file
     WHERE apa01=l_apa01
   #end MOD-B30575 add
     
   #IF g_apa01 != l_apa01 THEN    #處理有產生折讓的情形
    IF g_apa01 != l_apa01 AND sta = '1' THEN    #處理有產生折讓的情形
      #請款資料
       SELECT apa00,apa58,apa60,apa61,apa60f,apa61f 
         INTO g_apa00,g_apa58,g_apa60,g_apa61,g_apa60f,g_apa61f FROM apa_file
        WHERE apa01=g_apa01
     #str MOD-B30575 mark   #移到前面去
     ##折讓資料
     # SELECT apa31,apa32,apa34,
     #        apa31f,apa32f,apa34f         #MOD-B30575 add
     #   INTO l_apa31,l_apa32,l_apa34,
     #        l_apa31f,l_apa32f,l_apa34f   #MOD-B30575 add
     #   FROM apa_file
     #  WHERE apa01=l_apa01
     #end MOD-B30575 mark
       IF STATUS THEN RETURN END IF
 
       IF g_apa00='21' AND g_apa58 <>'1' THEN
          IF l_apa31 != g_apa60 OR l_apa32 !=g_apa61 THEN
              UPDATE apa_file SET apa31 =g_apa60,apa31f=g_apa60f,
                                  apa32 =g_apa61,apa32f=g_apa61f,
                                  apa34 =g_apa60+g_apa61, 
                                  apa73 =g_apa60+g_apa61,     #A059
                                  apa34f=g_apa60f+g_apa61f 
               WHERE apa00='21' AND apa01=l_apa01
              IF SQLCA.SQLCODE OR STATUS THEN
#                CALL cl_err('upd apa:',SQLCA.SQLCODE,0)   #No.FUN-660122
                 CALL cl_err3("upd","apa_file",l_apa01,"",SQLCA.sqlcode,"","upd apa:",1) #No.FUN-660122
                 LET g_success='N' RETURN
              END IF
              SELECT apa31,apa32,apa34 INTO l_apa31,l_apa32,l_apa34 
                FROM apa_file
               WHERE apa01=l_apa01
          END IF
       END IF
    END IF
    
    SELECT SUM(apk08),SUM(apk07),SUM(apk06),
           SUM(apk08f),SUM(apk07f),SUM(apk06f)        #MOD-B30575 add
      INTO t_apk08,t_apk07,t_apk06,
           t_apk08f,t_apk07f,t_apk06f                 #MOD-B30575 add
      FROM apk_file
     WHERE apk01 = l_apa01 AND apk06 !=0
    IF cl_null(t_apk08) THEN LET t_apk08=0 END IF
    IF cl_null(t_apk07) THEN LET t_apk07=0 END IF
    IF cl_null(t_apk06) THEN LET t_apk06=0 END IF
    IF cl_null(t_apk08f) THEN LET t_apk08f=0 END IF   #MOD-B30575 add
    IF cl_null(t_apk07f) THEN LET t_apk07f=0 END IF   #MOD-B30575 add
    IF cl_null(t_apk06f) THEN LET t_apk06f=0 END IF   #MOD-B30575 add

   #str MOD-B30575 add
   #判斷幣別是否皆為本國幣別
    LET l_cnt = 0
    DECLARE t110_apk12 CURSOR FOR
      SELECT UNIQUE(apk12) FROM apk_file WHERE apk01 = l_apa01
    FOREACH t110_apk12 INTO l_apk12
       LET l_cnt = l_cnt + 1
    END FOREACH
   #end MOD-B30575 add

    IF t_apk07 != l_apa32  THEN
       LET l_diffapk07=t_apk07 - l_apa32
       LET l_diffapk06=t_apk06 - l_apa34
       LET l_diffapk08=t_apk08 - l_apa31
       IF cl_null(l_diffapk07) THEN LET l_diffapk07=0 END IF
       IF cl_null(l_diffapk06) THEN LET l_diffapk06=0 END IF
       IF cl_null(l_diffapk08) THEN LET l_diffapk08=0 END IF
      #str MOD-B30575 add
      #當幣別皆為本國幣別時,需連原幣欄位也做調整
       IF g_aza.aza17 = l_apk12 AND l_cnt = 1 THEN
          LET l_diffapk07f=t_apk07f - l_apa32f
          LET l_diffapk06f=t_apk06f - l_apa34f
          LET l_diffapk08f=t_apk08f - l_apa31f
          IF cl_null(l_diffapk07f) THEN LET l_diffapk07f=0 END IF
          IF cl_null(l_diffapk06f) THEN LET l_diffapk06f=0 END IF
          IF cl_null(l_diffapk08f) THEN LET l_diffapk08f=0 END IF
          #調至金額最大的項次
          UPDATE apk_file SET apk08 =apk08 -l_diffapk08,
                              apk07 =apk07 -l_diffapk07,
                              apk06 =apk06 -l_diffapk06,
                              apk08f=apk08f-l_diffapk08f,
                              apk07f=apk07f-l_diffapk07f,
                              apk06f=apk06f-l_diffapk06f
           WHERE apk01 = l_apa01 AND apk02 =l_apk02
       ELSE
      #end MOD-B30575 add
         #調至金額最大的項次
         UPDATE apk_file SET apk08=apk08-l_diffapk08,
                             apk07=apk07-l_diffapk07,
                             apk06=apk06-l_diffapk06
          WHERE apk01 = l_apa01 AND apk02 =l_apk02
       END IF   #MOD-B30575 add
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('mod_apk:',SQLCA.sqlcode,1)   #No.FUN-660122
          CALL cl_err3("upd","apk_file",l_apa01,l_apk02,SQLCA.sqlcode,"","mod_apk:",1) #No.FUN-660122
          LET g_success='N' RETURN
       END IF
    END IF
 
END FUNCTION
