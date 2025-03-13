# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrp500.4gl
# Descriptions...: 客戶應收期末結帳作業                    
# Date & Author..: 95/02/12 By Roger
# Modify.........: 97/07/29 By Sophia 確認碼為'Y'才可產生 ooo_file
# Modify.........: 97/08/28 By Sophia 新增工廠別(ooo10),帳別(ooo11)
# Modify.........: No.+212 by linda add ooo12 資料來源,不可刪除開帳資料
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-570156 06/03/09 By saki 批次背景執行
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670047 06/08/09 By Ray 增加兩帳套功能
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-710050 07/01/22 By bnlent 錯誤信息匯整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-790092 07/09/14 By rainy 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.FUN-8A0086 08/10/21 By dongbg修正FUN-710050錯誤
# Modify.........: No.CHI-8A0034 08/10/31 By Sarah 增加抓取npp_file條件為nppsys='NM' AND npp00='2'的資料寫入ooo_file
# Modify.........: No.CHI-910003 09/07/15 By baofei增加抓取npp_file條件為nppsys='NM' AND npp00='3'且nmg29='Y'的資料寫入ooo_file 
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:CHI-A10007 10/03/26 By sabrina 對沖後分錄底稿所產生的資料有誤
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-C10034 12/01/05 By Carrier 增加nppsys='FA' & npp00='4'出售功能
# Modify.........: No:MOD-D10274 13/01/30 By apo 在月結COMMIT WORK執行成功之後，再詢問是否執行年結
# Modify.........: No:FUN-D40121 13/05/31 By lujh 若參數有值，则年度期別使用參數的值

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql	string                     #No.FUN-580092 HCN
DEFINE g_yy,g_mm	LIKE type_file.num5        #No.FUN-680123 SMALLINT
DEFINE b_date,e_date	LIKE type_file.dat         #No.FUN-680123 DATE
DEFINE g_dc		LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)
DEFINE g_amt1,g_amt2	LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6)  #FUN-4C0013
DEFINE g_npq01          LIKE npq_file.npq01
DEFINE g_ooo		RECORD LIKE ooo_file.*
DEFINE p_row,p_col      LIKE type_file.num5        #No.FUN-680123 SMALLINT
DEFINE   g_chr          LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10       #No.FUN-680123 INTEGER   
DEFINE   g_change_lang  LIKE type_file.chr1        # Prog. Version..: '5.30.06-13.03.12(01)   #是否有做語言切換 No.FUN-570156
 
MAIN
#   DEFINE l_time  	LIKE type_file.chr8        #No.FUN-680123 VARCHAR(8)   #No.FUN-6A0095
   DEFINE l_flag        LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)   #No.FUN-570156 
 
   OPTIONS
        MESSAGE   LINE  LAST-1,
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570156 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy     = ARG_VAL(1)             #結帳年度
   LET g_mm     = ARG_VAL(2)             #期別
   LET g_bgjob = ARG_VAL(3)     #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570156 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570156 --start--
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
#  OPEN WINDOW p500_w AT p_row,p_col WITH FORM "axr/42f/axrp500"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#  CALL cl_ui_init()
 
#  CALL p500()
#  CLOSE WINDOW p500_w
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p500()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            BEGIN WORK
            CALL p500_process()
            CALL s_showmsg()    #No.FUN-710050
            IF g_success = 'Y' THEN
               COMMIT WORK
              #MOD-D10274--
               IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
                   (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
                   IF cl_confirm('axr-240') THEN
                      CALL cl_cmdrun_wait('axrp501')
                   END IF
               END IF
              #MOD-D10274--
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p500_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p500_process()
         CALL s_showmsg()    #No.FUN-710050
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #No.FUN-570156 ---end---
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN
 
FUNCTION p500()
DEFINE l_flag LIKE type_file.chr1        #No.FUN-680123 VARCHAR(1)
DEFINE lc_cmd LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(500)     #No.FUN-570156
 
   #No.FUN-570156 --start--
   OPEN WINDOW p500_w AT p_row,p_col WITH FORM "axr/42f/axrp500"
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   #No.FUN-570156 ---end---
 
   CLEAR FORM
   IF cl_null(g_yy) AND cl_null(g_mm) THEN   #FUN-D40121 add
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = g_ooz.ooz09
   END IF   #FUN-D40121 add 

   WHILE TRUE
      CALL cl_opmsg('z')
 
      LET g_bgjob = "N"       #No.FUN-570156
      INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS    #No.FUN-570156
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         AFTER FIELD g_yy
            IF g_yy IS NULL OR g_yy=0 THEN
               NEXT FIELD g_yy 
            END IF
 
         AFTER FIELD g_mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_yy
            IF g_azm.azm02 = 1 THEN
               IF g_mm > 12 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            ELSE
               IF g_mm > 13 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF g_mm IS NULL OR g_mm=0 THEN
               NEXT FIELD g_mm
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            call cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit    #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION locale #genero
            #No.FUN-570156 --start--
#           LET g_action_choice = "locale"
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE
            #No.FUN-570156 ---end---
            EXIT INPUT
     
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      #No.FUN-570156 --start--
#     IF g_action_choice = "locale" THEN  #genero
      IF g_change_lang THEN
#        LET g_action_choice = ""
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      #No.FUN-570156 ---end---
 
      IF INT_FLAG THEN
         #No.FUN-570156 --start--
         LET INT_FLAG = 0 
         CLOSE WINDOW p500_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
#        RETURN
         #No.FUN-570156 ---end---
      END IF
 
      #No.FUN-570156 --start--
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axrp500"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axrp500','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy    CLIPPED,"'",
                         " '",g_mm    CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axrp500',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p500_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
 
#     IF cl_sure(21,21) THEN
#        CALL cl_wait()
#        CALL p500_1()
#        ERROR ''
#        IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
#            (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
#            IF cl_confirm('axr-240') THEN
#               CALL cl_cmdrun_wait('axrp501')
#            END IF
#        END IF
#        IF g_success='Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#     END IF
   #No.FUN-570156 ---end---
   END WHILE
END FUNCTION
 
#No.FUN-570156 --start--
FUNCTION p500_process()
   IF g_bgjob = "N" THEN
      CALL cl_wait()
   END IF
   #No.FUN-670047 --begin
   CALL p500_1('0')
   IF g_aza.aza63 = 'Y' THEN
      CALL p500_1('1')
   END IF
   #No.FUN-670047 --end
  #MOD-D10274--mark
  #IF g_bgjob = "N" THEN
  #   ERROR ''
  #   IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
  #       (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
  #       IF cl_confirm('axr-240') THEN
  #          CALL cl_cmdrun_wait('axrp501')
  #       END IF
  #   END IF
  #END IF
  #MOD-D10274--mark
END FUNCTION
#No.FUN-570156 ---end---
 
FUNCTION p500_1(l_npptype)
  DEFINE l_npptype   LIKE npp_file.npptype
  DEFINE l_oma01     LIKE oma_file.oma01,
         l_omaconf   LIKE oma_file.omaconf,
         l_flag      LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1),
         l_name      LIKE type_file.chr20,       #No.FUN-680123 VARCHAR(10),
         l_cmd       LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(30),
         sr          RECORD
             order   LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(100),
             #add    030223  NO.A048
             npp00   LIKE npp_file.npp00,
             npq01   LIKE npq_file.npq01,
             ooo10   LIKE ooo_file.ooo10,
             ooo11   LIKE ooo_file.ooo11,
             ooo01   LIKE ooo_file.ooo01,
             ooo02   LIKE ooo_file.ooo02,
             ooo03   LIKE ooo_file.ooo03,
             ooo04   LIKE ooo_file.ooo04,
             ooo05   LIKE ooo_file.ooo05,
             dc      LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1),
             amt1    LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6),  #FUN-4C0013
             amt2    LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)  #FUN-4C0013 
             nppsys  LIKE npp_file.nppsys,       #CHI-A10007 add
             npq23   LIKE npq_file.npq23         #CHI-A10007 add
             END RECORD
              
 
    #No.FUN-670047 --begin
    IF g_aza.aza63 = 'Y' THEN
       IF l_npptype = '0' THEN
          CALL s_azmm(g_yy,g_mm,g_ooz.ooz02p,g_ooz.ooz02b) RETURNING g_chr,b_date,e_date
       ELSE
          CALL s_azmm(g_yy,g_mm,g_ooz.ooz02p,g_ooz.ooz02c) RETURNING g_chr,b_date,e_date
       END IF
    ELSE
       CALL s_azm(g_yy,g_mm) RETURNING g_chr,b_date,e_date
    END IF
    #No.FUN-670047 --end
       
    #IF g_chr='1' THEN CALL cl_err('s_azm:error','',1) RETURN END IF
    IF g_chr='1' THEN CALL cl_err('s_azm:error','agl-038',1) RETURN END IF
 
    IF g_bgjob = "N" THEN   #No.FUN-570156
       MESSAGE   "del ooo!"
       CALL ui.Interface.refresh() 
    END IF                  #No.FUN-570156
   #No.+041 010330 by plum  判斷現有筆數和所刪除筆數是否相同
   {
    DELETE FROM ooo_file WHERE ooo06=g_yy AND ooo07=g_mm
    IF STATUS THEN CALL cl_err('del ooo:',STATUS,1) RETURN END IF
   }
    SELECT COUNT(*) INTO g_cnt FROM ooo_file WHERE ooo06=g_yy AND ooo07=g_mm
                                                AND ooo12='1'   #No.+212 add
    #No.FUN-670047 --begin
    IF g_aza.aza63 = 'Y' THEN
       IF l_npptype = '0' THEN
          DELETE FROM ooo_file WHERE ooo06=g_yy AND ooo07=g_mm
                                 AND ooo12='1'    #No.+212 add
                                 AND ooo11=g_ooz.ooz02b
       ELSE
          DELETE FROM ooo_file WHERE ooo06=g_yy AND ooo07=g_mm
                                 AND ooo12='1'    #No.+212 add
                                 AND ooo11=g_ooz.ooz02c
       END IF
    ELSE
       DELETE FROM ooo_file WHERE ooo06=g_yy AND ooo07=g_mm
                              AND ooo12='1'    #No.+212 add
    END IF
    #No.FUN-670047 --end
       
    IF SQLCA.SQLERRD[3] !=g_cnt THEN
#      CALL cl_err('del ooo:',STATUS,1)   #No.FUN-660116
       CALL cl_err3("del","ooo_file",g_yy,g_mm,STATUS,"","del ooo:",1)   #No.FUN-660116
       RETURN 
    END IF
   #No.+041...end
    IF g_bgjob = "N" THEN       #No.FUN-570156
       MESSAGE   SQLCA.SQLERRD[3],' Rows deleted!'
       CALL ui.Interface.refresh() 
    END IF                      #No.FUN-570156
    CALL cl_outnam('axrp500') RETURNING l_name
    START REPORT axrp500_rep TO l_name
 
    DECLARE p500_cs CURSOR WITH HOLD FOR
     #modify 030223  NO.A048
     SELECT '',npp00,npq01,npp06,npp07,npq21,npq22,npq03,npq05,
            npq24,npq06,SUM(npq07f),SUM(npq07),nppsys,npq23                 #CHI-A10007 add nppsys,npq23
       FROM npq_file,npp_file
      WHERE npp02 BETWEEN b_date AND e_date
        AND npqsys = 'AR'
        AND npqsys=nppsys AND npq00=npp00 AND npq01=npp01
        AND npq011=npp011
        AND npqtype=npptype       #CHI-910003 
        AND npptype=l_npptype     #No.FUN-670047
      GROUP BY npp00,npq01,npp06,npp07,npq21,npq22,npq03,npq05,npq24,npq06,nppsys,npq23     #CHI-A10007 add nppsys,npq23
    #No.MOD-C10034  --Begin
     UNION
     SELECT '',npp00,npq01,npp06,npp07,npq21,npq22,npq03,npq05,
            npq24,npq06,SUM(npq07f),SUM(npq07),nppsys,npq23  
       FROM npq_file,npp_file
      WHERE npp02 BETWEEN b_date AND e_date
        AND nppsys = 'FA'
        AND npp00 = '4'
        AND npqsys=nppsys AND npq00=npp00 AND npq01=npp01
        AND npq011=npp011
        AND npqtype=npptype 
        AND npptype=l_npptype 
      GROUP BY npp00,npq01,npp06,npp07,npq21,npq22,npq03,npq05,npq24,npq06,nppsys,npq23
    #No.MOD-C10034  --End  
    #str CHI-8A0034 add
      UNION
     SELECT '',npp00,npq01,npp06,npp07,npq21,npq22,npq03,npq05,
            npq24,npq06,SUM(npq07f),SUM(npq07),nppsys,npq23                 #CHI-A10007 add nppsys,npq23
       FROM npq_file,npp_file,npn_file
      WHERE npp02 BETWEEN b_date AND e_date
        AND npqsys = 'NM' AND npp00 = '2'   #CHI-8A0034
        AND npqsys=nppsys AND npq00=npp00 AND npq01=npp01
        AND npq011=npp011
        AND npqtype=npptype       #CHI-910003 
        AND npptype=l_npptype     #No.FUN-670047
        AND npp01=npn01   AND (npn03='6' OR npn03='7')   #CHI-8A0034
      GROUP BY npp00,npq01,npp06,npp07,npq21,npq22,npq03,npq05,npq24,npq06,nppsys,npq23     #CHI-A10007 add nppsys,npq23
    #end CHI-8A0034 add
#CHI-910003---begin                                                                                                                 
      UNION                                                                                                                         
     SELECT '',npp00,npq01,npp06,npp07,npq21,npq22,npq03,npq05,                                                                     
            npq24,npq06,SUM(npq07f),SUM(npq07),nppsys,npq23                 #CHI-A10007 add nppsys,npq23
       FROM npq_file,npp_file,nmg_file                                                                                              
      WHERE npp02 BETWEEN b_date AND e_date                                                                                         
        AND nppsys = 'NM' AND npp00 = '3'                                                                                           
        AND nmg00 = npp01 AND nmg29 = 'Y'                                                                                           
        AND npqsys=nppsys AND npq00=npp00 AND npq01=npp01                                                                           
        AND npq011=npp011                                                                                                           
        AND npqtype=npptype       #CHI-910003                                                                                       
                                                                                                                                    
        AND npptype=l_npptype     #No.FUN-670047                                                                                    
      GROUP BY npp00,npq01,npp06,npp07,npq21,npq22,npq03,npq05,npq24,npq06,nppsys,npq23     #CHI-A10007 add nppsys,npq23
#CHI-910003---end  
      ORDER BY npp06,npp07,npp00,npq21,npq22,npq03,npq05,npq24,npq06  #01/11/15
 
    LET g_ooo.ooo06=g_yy
    LET g_ooo.ooo07=g_mm
    LET g_cnt=0
#   BEGIN WORK                  #No.FUN-570156
    LET g_success = 'Y'
    CALL s_showmsg_init()    #No.FUN-710050
    FOREACH p500_cs INTO sr.*
    #No.FUN-710050--Begin--
    #  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) RETURN END IF
       IF STATUS THEN 
          LET g_success = 'N'               #No.FUN-8A0086  
          CALL s_errmsg('','','foreach:',STATUS,1) 
          RETURN 
       END IF
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF             
    #No.FUN-710050--End--
       IF cl_null(sr.ooo10) THEN LET sr.ooo10=g_ooz.ooz02p  END IF
 
       #No.FUN-670047 --begin
       IF g_aza.aza63 = 'Y' THEN
          IF l_npptype = '0' THEN
             IF cl_null(sr.ooo11) THEN LET sr.ooo11=g_ooz.ooz02b  END IF
          ELSE
             IF cl_null(sr.ooo11) THEN LET sr.ooo11=g_ooz.ooz02c  END IF
          END IF
       ELSE
          IF cl_null(sr.ooo11) THEN LET sr.ooo11=g_ooz.ooz02b  END IF
       END IF
       #No.FUN-670047 --end
       #-----97/07/29 modify
        #modify 030223  NO.A048
        #No.MOD-C10034  --Begin
        #IF sr.npp00 != 4 THEN
        IF NOT (sr.nppsys = 'AR' AND sr.npp00 = 4) THEN
        #No.MOD-C10034  --End  
           LET l_oma01 = ''
           LET l_omaconf = ''
           SELECT oma01,omaconf INTO l_oma01,l_omaconf
             FROM oma_file WHERE oma01 = sr.npq01
           IF STATUS = 100 THEN    #找不到
              SELECT ooa01,ooaconf INTO l_oma01,l_omaconf
                FROM ooa_file WHERE ooa01 = sr.npq01
                                AND ooaconf != 'X' #010803增    
              IF STATUS THEN      
                #str CHI-8A0034 add
                 SELECT npn01,npnconf INTO l_oma01,l_omaconf
                   FROM npn_file WHERE npn01 = sr.npq01
                 IF STATUS THEN
                #end CHI-8A0034 add
                    #No.MOD-C10034  --Begin
                    SELECT fbe01,fbeconf INTO l_oma01,l_omaconf
                      FROM fbe_file WHERE fbe01 = sr.npq01
                    IF STATUS THEN
                       CONTINUE FOREACH
                    ELSE
                       IF l_omaconf = 'N' THEN CONTINUE FOREACH END IF
                    END IF
                    #No.MOD-C10034  --End  
                 ELSE 
                    IF l_omaconf = 'N' THEN CONTINUE FOREACH END IF
                 END IF
              #No.C10034  --Begin
              ELSE
                 IF l_omaconf = 'N' THEN CONTINUE FOREACH END IF
              #No.C10034  --End  
              END IF   #CHI-8A0034 add
           ELSE
              IF l_omaconf = 'N' THEN CONTINUE FOREACH END IF
           END IF
        END IF
       #----------------
       #CHI-A10007---add---start---
        IF sr.npp00 = '3' AND sr.nppsys = 'AR' THEN
           SELECT ooa03,ooa032 INTO sr.ooo01,sr.ooo02 FROM ooa_file,oob_file
            WHERE oob06 = sr.npq23 AND ooa01 = sr.npq01
              AND oob11 = sr.ooo03 AND ooa01 = oob01
              AND oob03 IN ('1','2') AND oob04 = '9'
        END IF
       #CHI-A10007---add---end---
        IF cl_null(sr.ooo10) THEN LET sr.ooo10= ' ' END IF #No:7935
        IF cl_null(sr.ooo11) THEN LET sr.ooo11= ' ' END IF #No:7935
        IF cl_null(sr.ooo01) THEN LET sr.ooo01= ' ' END IF #No:7935
        IF cl_null(sr.ooo02) THEN LET sr.ooo02=' '  END IF #no:6799
        IF cl_null(sr.ooo03) THEN LET sr.ooo03= ' ' END IF #No:7935
        IF cl_null(sr.ooo04) THEN LET sr.ooo04= ' ' END IF #No:7935
        IF cl_null(sr.ooo05) THEN LET sr.ooo05= ' ' END IF #No:7935
        IF cl_null(sr.dc   ) THEN LET sr.dc   = ' ' END IF #No:7935
 
        LET sr.order = sr.ooo10,sr.ooo11,sr.ooo01,sr.ooo02,
                       sr.ooo03,sr.ooo04,sr.ooo05,sr.dc,sr.nppsys,sr.npq23        #CHI-A10007 add nppsys,npq23
         OUTPUT TO REPORT axrp500_rep(sr.*)
 
    END FOREACH
    #No.FUN-710050--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
    #No.FUN-710050--End--
 
 
    FINISH REPORT axrp500_rep
   #No.+366 010705 plum
#   LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#   RUN l_cmd                                          #No.FUN-9C0009
    IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
   #No.+366..end
   #ERROR ''         #No.FUN-570156
   # CALL cl_end(0,0)
END FUNCTION
 
REPORT axrp500_rep(sr)
DEFINE   sr          RECORD
             order   LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(100),
             #add 030223  NO.A048
             npp00   LIKE npp_file.npp00,
             npq01   LIKE npq_file.npq01,
             ooo10   LIKE ooo_file.ooo10,
             ooo11   LIKE ooo_file.ooo11,
             ooo01   LIKE ooo_file.ooo01,
             ooo02   LIKE ooo_file.ooo02,
             ooo03   LIKE ooo_file.ooo03,
             ooo04   LIKE ooo_file.ooo04,
             ooo05   LIKE ooo_file.ooo05,
             dc      LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1),
             amt1    LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)  #FUN-4C0013
             amt2    LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)  #FUN-4C0013 
             nppsys  LIKE npp_file.nppsys,       #CHI-A10007 add
             npq23   LIKE npq_file.npq23         #CHI-A10007 add
             END RECORD
 
ORDER EXTERNAL BY sr.order   #01/11/15 增EXTERNAL
FORMAT
 
     AFTER GROUP OF sr.order    #客戶,科目,部門,幣別 
        LET g_amt1 = GROUP SUM(sr.amt1)
        LET g_amt2 = GROUP SUM(sr.amt2)
        LET g_cnt=g_cnt+1
        LET g_ooo.ooo01 = sr.ooo01
        LET g_ooo.ooo02 = sr.ooo02
        LET g_ooo.ooo03 = sr.ooo03
        LET g_ooo.ooo04 = sr.ooo04
        LET g_ooo.ooo05 = sr.ooo05
        LET g_ooo.ooo10 = sr.ooo10
        LET g_ooo.ooo11 = sr.ooo11
        IF g_bgjob = "N" THEN        #No.FUN-570156
           MESSAGE   "(",g_cnt USING '<<<<<',") fetch npq:",g_ooo.ooo01
           CALL ui.Interface.refresh() 
        END IF                       #No.FUN-570156
        IF sr.dc = '1'
           THEN LET g_ooo.ooo08d=g_amt1 LET g_ooo.ooo08c=0
                LET g_ooo.ooo09d=g_amt2 LET g_ooo.ooo09c=0
           ELSE LET g_ooo.ooo08d=0      LET g_ooo.ooo08c=g_amt1
                LET g_ooo.ooo09d=0      LET g_ooo.ooo09c=g_amt2
        END IF
        LET g_ooo.ooo12='1'    #No.+212 add
        LET g_ooo.ooolegal = g_legal #FUN-980011 add
        INSERT INTO ooo_file VALUES(g_ooo.*)
        #IF STATUS AND STATUS!=-239 AND STATUS!=-268 THEN                   #TQC-790092
        IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN   #TQC-790092
#          CALL cl_err('ins ooo:',SQLCA.SQLCODE,1)    #No.FUN-660116
           CALL cl_err3("ins","ooo_file",g_ooo.ooo01,g_ooo.ooo03,SQLCA.sqlcode,"","ins ooo:",1)   #No.FUN-660116
           LET g_success = 'N'
        END IF
        #IF STATUS=-239 OR STATUS=-268 THEN      #TQC-790092
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790092
           UPDATE ooo_file SET ooo08d=ooo08d+g_ooo.ooo08d,
                               ooo08c=ooo08c+g_ooo.ooo08c,
                               ooo09d=ooo09d+g_ooo.ooo09d,
                               ooo09c=ooo09c+g_ooo.ooo09c
             WHERE ooo01=g_ooo.ooo01
               AND ooo02=g_ooo.ooo02
               AND ooo03=g_ooo.ooo03
               AND ooo04=g_ooo.ooo04
               AND ooo05=g_ooo.ooo05
               AND ooo06=g_ooo.ooo06
               AND ooo07=g_ooo.ooo07
               AND ooo10=g_ooo.ooo10
               AND ooo11=g_ooo.ooo11
               AND ooo12 = g_ooo.ooo12   #No.+212
            #IF STATUS AND STATUS!=-239 AND STATUS!=-268 THEN                   #TQC-790092
            IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN   #TQC-790092
#              CALL cl_err('upd ooo:',SQLCA.SQLCODE,1)   #No.FUN-660116
               CALL cl_err3("upd","ooo_file",g_ooo.ooo01,g_ooo.ooo03,SQLCA.sqlcode,"","upd ooo:",1)   #No.FUN-660116
               LET g_success = 'N'
            END IF
         END IF
 
END REPORT
