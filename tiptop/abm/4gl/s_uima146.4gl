# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Modify.........: No.MOD-4A0074 04/10/28 By Mandy 階數計算有誤
# Modify.........: No.MOD-520081 05/03/11 By ching enhance display
# Modify.........: #No.MOD-530319 05/04/01 By Mandy p610() 真正進入此段程式的程式碼為abmi600,去做 g_prog的轉換
#                  避免CALL cl_outnam('abmp610')時抓不到相關file而產生錯誤
# Modify.........: No.FUN-570095 05/07/11 By kim 低階碼超過20碼的錯誤訊息,卻沒說是哪個料號造成
# Modify.........: No.MOD-590304 05/09/14 By kim 料號放大到40
# Modify.........: No.MOD-5B0057 05/11/15 By Pengu 1.sr array改成動態
# Modify.........: No.FUN-640241 06/04/25 By Echo 自動執行確認功能
# Modify.........: No.TQC-680054 06/08/16 By Claire 記錄原程式名稱待p610回來後再還原g_prog
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.MOD-6C0006 06/12/12 By Claire 作廢不計算
# Modify.........: No.TQC-6C0083 06/12/14 By Sarah 將sr1,sr2,l_ac,l_i搬到上面定義
# Modify.........: No.FUN-710014 07/02/26 By Carrier 錯誤訊息匯整 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-BC0048 11/12/07 By ck2yuan 非背景執行才CALL
# Modify.........: No.MOD-C20159 12/03/01 By ck2yuan 替代料也要一併update ima146
# Modify.........: No.MOD-C50024 12/05/07 By ck2yuan 特性BOM的功能有加了key值欄位,此程式漏調了
# Modify.........: No.TQC-C70142 12/07/20 By fengrui 調用s_uima146遞歸時排除替代料與主料相同
# Modify.........: No.MOD-CC0272 13/01/08 By Alberti 調整設定取替代會一直跑迴圈的問題
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.CHI-D10044 13/03/04 By bart p_level > 20則跳出

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_cnt        LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_level      LIKE type_file.num5      #No.FUN-680096 SMALLINT
DEFINE   g_msg        LIKE ze_file.ze03        #No.FUN-680096 VARCHAR(72)
DEFINE   g_status     LIKE type_file.num5      #No.FUN-680096 SMALLINT
DEFINE   sr1          DYNAMIC ARRAY OF LIKE bmb_file.bmb03    #TQC-6C0083 add
DEFINE   sr2          DYNAMIC ARRAY OF LIKE bmb_file.bmb03    #TQC-6C0083 add
DEFINE   l_ac,l_i     LIKE type_file.num5                     #TQC-6C0083 add
 
FUNCTION s_decl_bmb()
DEFINE   l_sql        LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)
 
    LET l_sql="SELECT bmb03 FROM bmb_file,bma_file",  #MOD-6C0006 modify   
              " WHERE bmb01=?",
              "   AND bmb01 = bma01 ",  #MOD-6C0006 add
              "   AND bmaacti = 'Y' ",  #MOD-6C0006 add
              "   AND bma06=bmb29 ",    #MOD-C50024 add
              " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL) ", #No.8811
              " AND (bmb05 >'",g_today, "' OR bmb05 IS NULL) "
    LET l_sql = l_sql CLIPPED
 
    PREPARE bmb03_pre FROM l_sql
    DECLARE bmb03_cur CURSOR WITH HOLD FOR bmb03_pre
    IF STATUS THEN
       #No.FUN-710014  --Begin
       IF g_bgerr THEN
          LET g_showmsg=g_today,"/",g_today
          CALL s_errmsg("bmb04,bmb05",g_showmsg,"decl bmb03_cur",STATUS,0)
       ELSE
          CALL cl_err('decl bmb03_cur',STATUS,1) ##MOD-530319 加強show訊息
       END IF
       #No.FUN-710014  --End   
    END IF
 
    LET l_sql="SELECT bmb01 FROM bmb_file,bma_file",
              " WHERE bmb03=?",
              "   AND bmb01 = bma01 ",  #MOD-6C0006 add
              "   AND bmaacti = 'Y' ",  #MOD-6C0006 add
              "   AND bma06=bmb29 ",    #MOD-C50024 add
              "   AND (bmb04 <='",g_today,"' OR bmb04 IS NULL) ", #No.8811
              "   AND (bmb05 >'",g_today, "' OR bmb05 IS NULL) "
    PREPARE bmb01_pre FROM l_sql
    DECLARE bmb01_cur CURSOR WITH HOLD FOR bmb01_pre
    IF STATUS THEN
       #No.FUN-710014  --Begin
       IF g_bgerr THEN
          LET g_showmsg=g_today,"/",g_today
          CALL s_errmsg("bmb04,bmb05",g_showmsg,"decl bmb01_cur",STATUS,0)
       ELSE
          CALL cl_err('decl bmb01_cur',STATUS,1) #MOD-530319 加強show訊息
       END IF
       #No.FUN-710014  --End  
    END IF

    #MOD-C20159 str add-----
    LET l_sql="SELECT bmd04 FROM bmd_file,ima_file",
              " WHERE bmd01=?",
              "   AND bmd04 = ima01 ",
              "   AND bmdacti = 'Y' ",
              "   AND (bmd05 <='",g_today,"' OR bmd05 IS NULL) ",
              "   AND (bmd06 >'",g_today, "' OR bmd06 IS NULL) "
    PREPARE bmd04_pre FROM l_sql
    DECLARE bmd04_cur CURSOR WITH HOLD FOR bmd04_pre
    IF STATUS THEN
       IF g_bgerr THEN
          LET g_showmsg=g_today,"/",g_today
          CALL s_errmsg("bmd05,bmd06",g_showmsg,"decl bmd04_cur",STATUS,0)
       ELSE
          CALL cl_err('decl bmd04_cur',STATUS,1)
       END IF
    END IF
    #MOD-C20159 end add-----

END FUNCTION
 
#FUNCTION s_uima146(p_bma01)  #CHI-D10044
FUNCTION s_uima146(p_bma01,p_level)  #CHI-D10044
DEFINE p_bma01   LIKE bma_file.bma01
DEFINE p_level   LIKE type_file.num5  #CHI-D10044
DEFINE l_bmb03   LIKE bmb_file.bmb03
#DEFINE sr1       ARRAY[100] OF VARCHAR(40)                 #MOD-590304    #No.MOD-5B0057 mark
#DEFINE sr1       DYNAMIC ARRAY OF LIKE bmb_file.bmb03   #MOD-590304 add      #TQC-6C0083 mark
#DEFINE l_ac,l_i  LIKE type_file.num5                    #No.FUN-680096 SMALLINT   #TQC-6C0083 mark
DEFINE l_str     STRING                                 #FUN-640241   
DEFINE l_cnt,l_cnt2,l_cnt3     LIKE type_file.num5                    #MOD-C20159 add
DEFINE l_ima146  LIKE ima_file.ima146      #MOD-CC0272 add

   IF g_success='N' THEN RETURN END IF
   #CHI-D10044---begin
   LET p_level = p_level +1  
   IF p_level > 20 THEN 
      LET g_success='N'
      RETURN 
   END IF  
   #CHI-D10044---end
  #UPDATE ima_file SET ima146='Y' WHERE ima01=p_bma01         #FUN-C30315 mark 
   UPDATE ima_file SET ima146='Y',imadate = g_today  WHERE ima01=p_bma01 #FUN-C30315 add
   IF STATUS OR sqlca.sqlerrd[3]=0 THEN
    # CALL cl_err(p_bma01,'mfg6063',1)
      #No.FUN-710014  --Begin
      IF g_bgerr THEN
         CALL s_errmsg("ima01",p_bma01,"","mfg6063",1)
      ELSE
         CALL cl_err3("upd","ima_file",p_bma01,"",'mfg6063',"","",1)   #No.TQC-660046
      END IF
      #No.FUN-710014  --End   
      LET g_success='N'
      RETURN
   END IF
   LET g_level=0
 # CALL get_mai_bom(p_bma01,'u')            #No.FUN-B80100---修改get_main_bom為get_mai_bom---
   CALL get_mai_bom(p_bma01,'u',g_level)    #No.B531 010516 by linda mod      #No.FUN-B80100---修改get_main_bom為get_mai_bom---               
 
   SELECT COUNT(*) INTO g_cnt FROM bmb_file WHERE bmb01=p_bma01
       AND (bmb04 <= g_today OR bmb04 IS NULL)  #MOD-4A0074
       AND (bmb05 >  g_today OR bmb05 IS NULL)  #MOD-4A0074
  #MOD-C20159 str add-------------------
  #IF g_cnt=0 THEN RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM bmd_file WHERE bmd01=p_bma01
       AND (bmd05 <= g_today OR bmd05 IS NULL)
       AND (bmd06 >  g_today OR bmd06 IS NULL)
   IF g_cnt=0 AND l_cnt=0 THEN RETURN END IF
   LET l_ac=1
   #抓取這顆料的取替代料
      FOREACH bmd04_cur
      USING p_bma01
      INTO sr1[l_ac]
         LET l_str = p_bma01,' -> ',sr1[l_ac]
         CALL cl_msg(l_str)

         LET l_str = 'LLC check lower level item no->',p_bma01,' -> ',sr1[l_ac],'->',l_ac
         CALL cl_msg(l_str)
        IF g_bgjob='N' OR cl_null(g_bgjob) THEN
         CALL ui.Interface.refresh()
        END IF
         LET l_ima146=''  #MOD-CC0272 add
         SELECT ima146 INTO l_ima146 FROM ima_file WHERE ima01 = sr1[l_ac]     #MOD-CC0272 add
         IF l_ima146 != 'Y' OR cl_null(l_ima146) THEN   #MOD-CC0272 add   
            LET l_ac=l_ac+1
         END IF                                         #MOD-CC0272 add 
      END FOREACH
      IF STATUS
       THEN
           IF g_bgerr THEN
              CALL s_errmsg("","","foreach bmd04_cur",STATUS,1)
           ELSE
              CALL cl_err('foreach bmd04_cur',STATUS,1)
           END IF
           LET g_success='N'
           RETURN
      END IF
 
  #LET l_ac=1
  #MOD-C20159 end add-------------------
   #抓下階
   FOREACH bmb03_cur 
   USING p_bma01
   INTO sr1[l_ac]
     #FUN-640241
     #MESSAGE p_bma01,' -> ',sr1[l_ac]
      LET l_str = p_bma01,' -> ',sr1[l_ac]
      CALL cl_msg(l_str)
      
       #MOD-520081
     #MESSAGE 'LLC check lower level item no->',p_bma01,' -> ',sr1[l_ac],'->',l_ac
      LET l_str = 'LLC check lower level item no->',p_bma01,' -> ',sr1[l_ac],'->',l_ac
      CALL cl_msg(l_str)
     #END FUN-640241
     IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #MOD-BC0048 add
      CALL ui.Interface.refresh()
     END IF                                     #MOD-BC0048 add
      LET l_ac=l_ac+1
 
#------No.MOD-5B0057 mark
#      IF l_ac>g_max_rec THEN CALL cl_err('array sr1 out of range','!',1) #MOD-4A0074 錯誤訊息加強
#        LET g_success='N'
#        RETURN
#     END IF
#------end
      #--
   END FOREACH
   IF STATUS
    THEN 
        #No.FUN-710014  --Begin
        IF g_bgerr THEN
           CALL s_errmsg("","","foreach bmb03_cur",STATUS,1)
        ELSE
           CALL cl_err('foreach bmb03_cur',STATUS,1) #MOD-530319 加強show訊息
        END IF
        #No.FUN-710014  --End  
        LET g_success='N'
        RETURN
   END IF
   LET l_ac=l_ac-1
  
   IF l_ac>0 THEN
     #MOD-C20159 str add-----
     #FOR l_i=1 TO l_ac
     #    CALL s_uima146(sr1[l_i])
      LET l_cnt3=l_ac
      FOR l_cnt2=1 TO l_cnt3
          IF p_bma01<>sr1[l_cnt2] THEN  #TQC-C70142 add
             #CALL s_uima146(sr1[l_cnt2])  #CHI-D10044
             CALL s_uima146(sr1[l_cnt2],p_level)  #CHI-D10044
          END IF  #TQC-C70142
     #MOD-C20159 end add-----
      END FOR
   END IF
   RETURN
END FUNCTION
 
## 尋找該料件所存在之主件(成品)
#FUNCTION get_mai_bom(p_bmb03,p_cmd)     #No.B531 mod  #No.FUN-B80100---修改get_main_bom為get_mai_bom---
FUNCTION get_mai_bom(p_bmb03,p_cmd,p_level)            #No.FUN-B80100---修改get_main_bom為get_mai_bom---
DEFINE p_bmb03   LIKE bmb_file.bmb03
DEFINE p_cmd     LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
DEFINE p_level   LIKE type_file.num5      #No.FUN-680096 SMALLINT
DEFINE l_prog    LIKE type_file.chr20     #No.FUN-680096 VARCHAR(10)
DEFINE l_bmb01   LIKE bmb_file.bmb01
#DEFINE sr2       ARRAY[3000] OF VARCHAR(40),               #MOD-590304   #No.MOD-5B0057 mark
#DEFINE sr2       DYNAMIC ARRAY OF LIKE bmb_file.bmb03,  #No.MOD-5B0057 add   #TQC-6C0083 mark
#DEFINE l_ac,l_i  LIKE type_file.num5               #No.FUN-680096 SMALLINT   #TQC-6C0083 mark
DEFINE l_str     STRING                            #FUN-640241
 
  #Debug用的
  #LET g_msg='目前是第',p_level ,'階',' 元件',p_bmb03 CLIPPED,'要去抓上階'
  #CALL cl_err(g_msg,'!',1)
 
   IF g_status>0 OR g_success='N' THEN RETURN END IF
   IF cl_null(p_bmb03) THEN RETURN END IF
 # LET g_level = p_level    #No.B531 010516 by linda add
   LET l_ac=1
   #抓上階
   FOREACH bmb01_cur 
   USING p_bmb03
   INTO sr2[l_ac]
     #FUN-640241
     #MESSAGE p_bmb03,' <- ',sr2[l_ac]
      LET l_str = p_bmb03,' <- ',sr2[l_ac]
      CALL cl_msg(l_str) 
       #MOD-520081
     #MESSAGE 'LLC check upper level item no->',p_bmb03,' -> ',sr2[l_ac],'->',l_ac
      LET l_str = 'LLC check upper level item no->',p_bmb03,' -> ',sr2[l_ac],'->',l_ac
      CALL cl_msg(l_str)
     #END FUN-640241
     IF g_bgjob='N' OR cl_null(g_bgjob) THEN    #MOD-BC0048 add
      CALL ui.Interface.refresh()
     END IF                                     #MOD-BC0048 add
      LET l_ac=l_ac+1
#------No.MOD-5B0057 mark
#      IF l_ac>g_max_rec THEN CALL cl_err('array sr2 out of range','!',1) #MOD-4A0074 錯誤訊息加強
#        LET g_success='N'
#     END IF
#------end
      #--
   END FOREACH
   IF STATUS
    THEN 
        #No.FUN-710014  --Begin
        IF g_bgerr THEN
           CALL s_errmsg("","","foreach bmb01_cur",STATUS,1)
        ELSE
           CALL cl_err('foreach bmb01_cur',STATUS,1)#MOD-530319 加強show訊息
        END IF
        #No.FUN-710014  --End  
        LET g_success='N'
   END IF
   LET l_ac=l_ac-1
    LET p_level = p_level + 1  #MOD-4A0074
   IF l_ac>0 THEN
      LET g_level = g_level+1 
      #IF g_level > 20  THEN CALL cl_err('','mfg2644',1) LET g_success='N' END IF #MOD-4A0074
      #IF p_level > 20  THEN CALL cl_err('','mfg2644',1) LET g_success='N' END IF #MOD-4A0074
       IF p_level > 20  THEN 
          #No.FUN-710014  --Begin
          IF g_bgerr THEN
             CALL s_errmsg("str06",20,"","mfg2644",1)
          ELSE
             CALL cl_err(p_bmb03,'mfg2644',1) 
          END IF
          #No.FUN-710014  --End  
          LET g_success='N' 
       END IF #MOD-4A0074 #FUN-570095
      IF p_cmd='u'   # verify BOM
     #THEN UPDATE ima_file SET ima146='Y' WHERE ima01=p_bmb03                    #FUN-C30315 mark 
      THEN UPDATE ima_file SET ima146='Y',imadate = g_today WHERE ima01=p_bmb03  #FUN-C30315 add
           IF STATUS OR sqlca.sqlerrd[3]=0
            THEN 
     #      CALL cl_err(p_bmb03,'mfg6063',1) #MOD-530319 加強show訊息 #No.TQC-660046
            #No.FUN-710014  --Begin
            IF g_bgerr THEN
               CALL s_errmsg("ima01",p_bmb03,"","mfg6063",1)
            ELSE
               CALL cl_err3("upd","ima_file",p_bmb03,"","mfg6063","","",1)  #MOD-530319 加強show訊息 #No.TQC-660046
            END IF
            #No.FUN-710014  --End  
                LET g_success='N'
           END IF
      END IF
    # FOR l_i=1 TO l_ac CALL get_mai_bom(sr2[l_i],p_cmd) END FOR           #No.FUN-B80100---修改get_main_bom為get_mai_bom---
    #No.B531 010516 mod by linda
      FOR l_i=1 TO l_ac CALL get_mai_bom(sr2[l_i],p_cmd,p_level) END FOR   #No.FUN-B80100---修改get_main_bom為get_mai_bom---                 
   ELSE
      LET g_level=g_level-1
      IF p_cmd='c' THEN  # verify BOM
          LET g_msg=cl_getmsg('abm-001',g_lang)
          #FUN-640241
          #MESSAGE p_bmb03,': ',g_msg CLIPPED
          LET l_str = p_bmb03,': ',g_msg CLIPPED
          CALL cl_msg(l_str)
          #END FUN-640241
          #IF p610(p_bmb03)>0 THEN LET g_status=999 END IF              #MOD-530319
           #只有abmi600有CALL get_mai_bom(g_bma.bma01,'c',1)           #MOD-530319   #No.FUN-B80100---修改get_main_bom為get_mai_bom---
          LET l_prog = g_prog  #TQC-680054 add
           IF p610(p_bmb03,'abmi600')>0 THEN LET g_success = 'N' END IF #MOD-530319
          LET g_prog = l_prog  #TQC-680054 add
      ELSE   # p_cmd='u'
         UPDATE ima_file SET ima146='0',
                             imadate = g_today  #FUN-C30315 add
          WHERE ima01=p_bmb03
         IF STATUS OR sqlca.sqlerrd[3]=0
          THEN 
   #      CALL cl_err(p_bmb03,'mfg6063',1) #MOD-530319 加強show訊息 #No.TQC-660046
          #No.FUN-710014  --Begin
          IF g_bgerr THEN
             CALL s_errmsg("ima01",p_bmb03,"","mfg6063",1)
          ELSE
             CALL cl_err3("upd","ima_file",p_bmb03,"","mfg6063","","",1)  #MOD-530319 加強show訊息  #No.TQC-660046
          END IF
          #No.FUN-710014  --End  
              LET g_success='N'
         END IF
      END IF
   END IF
END FUNCTION
