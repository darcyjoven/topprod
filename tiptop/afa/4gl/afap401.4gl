# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afap401.4gl
# Descriptions...: 攤提折舊還原作業(稅簽)
# Date & Author..: 96/07/04 By Sophia
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# 注意:資產狀態還原(折畢)
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 語言按紐在鼠標點擊下無效，要按鍵盤上‘ENTER’鍵，才會有效
# Modify.........: No.CHI-840033 08/04/28 By bnlent 添加QBE條件
# Modify.........: No.CHI-860025 08/07/23 By Smapmin 將原本的程式段備份於afap401.bak,該張單子將程式段依照afap301重新調整
# Modify.........: No.MOD-880031 08/08/05 By Sarah afa-363檢核移除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No:CHI-A60036 10/07/05 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No:MOD-A20046 10/10/05 By sabrina 刪除折舊檔時多增加 fao041='1'條件
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:TQC-C50086 12/05/10 By xuxz faj65賦值修改
# Modify.........: No:MOD-C50066 12/05/11 By Elise MOD-C20126/CHI-970002/MOD-9B0021 追至 afap401
# Modify.........: No:TQC-C50190 12/05/22 By lujh 還原時報錯del fao_file，報錯信息為4筆，且無錯誤代碼，僅信息內容“del fao_file”4筆；實際afai901中的fao資料已經刪除 
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc             STRING,
       g_yy,g_mm	LIKE type_file.num5,
       l_yy,l_mm        LIKE type_file.num5,
       g_fao		RECORD LIKE fao_file.*,
       g_faj            RECORD LIKE faj_file.*,
       p_row,p_col      LIKE type_file.num5,
       g_flag           LIKE type_file.chr1,
       g_cnt2           LIKE type_file.num5,  
       g_ym             LIKE type_file.chr6  #MOD-C50066 add  
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD
                 faj02     LIKE faj_file.faj02,
                 faj022    LIKE faj_file.faj022,
                 ze01      LIKE ze_file.ze01,
                 ze03      LIKE ze_file.ze03
       END RECORD,
       l_msg,l_msg2    STRING,
       lc_gaq03  LIKE gaq_file.gaq03
 
#No.TQC-7B0060 --start--
DEFINE g_y1      LIKE type_file.num5
DEFINE g_m1      LIKE type_file.num5
DEFINE g_b1      LIKE type_file.dat
DEFINE g_e1      LIKE type_file.dat
DEFINE l_flag    LIKE type_file.chr1
#No.TQC-7B0060 --end--
DEFINE g_bookno1     LIKE aza_file.aza81       #CHI-A60036 add
DEFINE g_bookno2     LIKE aza_file.aza82       #CHI-A60036 add
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)
   LET g_mm    = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)             
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE
    IF g_bgjob = "N" THEN
       CALL p401()
       IF cl_sure(18,20) THEN
          LET g_cnt2 = 1
          CALL g_show_msg.clear()
          CALL p401_1()
          IF g_show_msg.getLength() > 0 THEN 
             CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
             CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
             CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
             CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
             CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
             CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
             CONTINUE WHILE
          ELSE
             CALL cl_end2(1) RETURNING g_flag
          END IF
          IF g_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p401_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
    ELSE
       LET g_cnt2 = 1
       CALL g_show_msg.clear()
       CALL p401_1()
       IF g_show_msg.getLength() > 0 THEN 
          CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
          CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
          CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
          CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
          CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
          CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p401()
    DEFINE   lc_cmd     LIKE type_file.chr1000            
    CLEAR FORM
    LET p_row = 10
    LET p_col = 10
    OPEN WINDOW p401_w AT p_row,p_col WITH FORM "afa/42f/afap401"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
     
    CALL cl_ui_init()
  
    WHILE TRUE
      SELECT faa11,faa12 INTO g_yy,g_mm FROM faa_file 
      LET g_ym = g_yy USING '&&&&',g_mm USING '&&'    #MOD-C50066 add
      DISPLAY g_yy TO FORMONLY.yy 
      DISPLAY g_mm TO FORMONLY.mm 
      LET g_bgjob = "N"
      #No.TQC-7B0060 --start--
      #CALL s_azm(g_yy,g_mm) RETURNING l_flag,g_b1,g_e1 #CHI-A60036 mark
      #CHI-A60036 add --start--
       CALL s_get_bookno(g_yy)
          RETURNING g_flag,g_bookno1,g_bookno2
 #    IF g_aza.aza63 = 'Y' THEN  
      IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
         CALL s_azmm(g_yy,g_mm,g_plant,g_bookno1) RETURNING l_flag,g_b1,g_e1
      ELSE
         CALL s_azm(g_yy,g_mm) RETURNING l_flag,g_b1,g_e1
      END IF
      #CHI-A60036 add --end--
      LET g_y1 = YEAR(g_b1)
      LET g_m1 = MONTH(g_e1)
      #No.TQC-7B0060 --end--
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
        
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
        
         ON ACTION about       
            CALL cl_about()      
        
         ON ACTION help          
            CALL cl_show_help()  
        
         ON ACTION locale        
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
    
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p300_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      CONSTRUCT BY NAME g_wc ON  faj09,faj04,faj02
      
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
      
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()
           EXIT CONSTRUCT
      
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
      
        ON ACTION about         
           CALL cl_about()      
      
        ON ACTION help          
           CALL cl_show_help()  
      
        ON ACTION controlg      
           CALL cl_cmdask()     
     
        ON ACTION exit                            #加離開功能
           LET INT_FLAG = 1
           EXIT CONSTRUCT
      
        ON ACTION qbe_select
           CALL cl_qbe_select()
      
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p401_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_wc =' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
  
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01 = "afap401"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap401','9031',1)
         ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                       " '",g_yy CLIPPED,"'",
                       " '",g_mm CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('afap401',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p401_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
      END IF
    EXIT WHILE
  END WHILE
END FUNCTION
 
FUNCTION p401_1()
    DEFINE  l_over     LIKE type_file.chr1,
            l_cnt      LIKE type_file.num5,
            l_faj65    LIKE faj_file.faj65,
            l_faj73    LIKE faj_file.faj73, #TQC-C50086 add
            l_faj74    LIKE faj_file.faj74,
            l_faj741   LIKE faj_file.faj741,
            l_faj201   LIKE faj_file.faj201,
           #MOD-C50066---S---
            l_faj26    LIKE faj_file.faj26, 
            l_faj27    LIKE faj_file.faj27, 
            l_faj31    LIKE faj_file.faj31, 
            l_faj64    LIKE faj_file.faj64,   
            l_faj66    LIKE faj_file.faj66, 
            l_faj68    LIKE faj_file.faj68, 
            l_faj681   LIKE faj_file.faj681     
           #MOD-C50066---E---
    DEFINE  l_yy2      LIKE type_file.chr4,   
            l_mm2      LIKE type_file.chr2,
            l_ym       LIKE type_file.chr6
    DEFINE  l_sql      STRING   
    DEFINE  l_bdate    LIKE type_file.dat   #CHI-9A0021 add
    DEFINE  l_edate    LIKE type_file.dat   #CHI-9A0021 add
    DEFINE  l_correct  LIKE type_file.chr1  #CHI-9A0021 add
 
    #取折舊明細檔中分攤類別不為'3'被分攤者,還原資產主檔
    LET l_cnt = 0
    LET l_sql = " SELECT COUNT(*) FROM fao_file,faj_file ",
               #"  WHERE fao03='",g_yy,"' AND fao04='",g_mm,"' AND fao05<>'3'",  #MOD-C50066 mark
                "  WHERE fao03='",g_yy,"' AND fao04='",g_mm,"' ",                #MOD-C50066
                "  AND faj02 = fao01 ",
                "  AND faj022 = fao02 ",
                "  AND fao041='1' AND ",g_wc
    PREPARE p401_p2 FROM l_sql
    DECLARE p401_cs2 CURSOR FOR p401_p2
    OPEN p401_cs2
    FETCH p401_cs2 INTO l_cnt
    IF l_cnt = 0 THEN
       CALL cl_err('','afa-115',1)
       RETURN
    END IF
 
   #str MOD-880031 mark
   #LET l_cnt = 0
   #SELECT COUNT(*) INTO l_cnt FROM npp_file
   # WHERE nppsys='FA' AND npp00=10 
   #   AND YEAR(npp03)=g_yy AND MONTH(npp03)=g_mm
   #IF l_cnt > 0 THEN
   #   CALL cl_err(0,'afa-363',1)
   #   RETURN 
   #END IF
   #end MOD-880031 mark
 
    INITIALIZE g_fao.* TO NULL
    LET l_sql = "SELECT fao_file.* FROM fao_file,faj_file ",
               #" WHERE fao03='",g_yy,"' AND fao04='",g_mm,"' AND fao05<>'3' ",  #MOD-C50066 mark
                " WHERE fao03='",g_yy,"' AND fao04='",g_mm,"'",                  #MOD-C50066
                " AND faj02 = fao01 ",
                " AND faj022 = fao02 ",
                " AND fao041 = '1' AND ",g_wc
    PREPARE p401_p FROM l_sql
    DECLARE p401_cs CURSOR WITH HOLD FOR p401_p
 
    FOREACH p401_cs INTO g_fao.*                  
       IF SQLCA.sqlcode  THEN
          CALL cl_err('p401_cs foreach:',STATUS,1) 
          RETURN
       END IF
       LET g_success='Y'
       BEGIN WORK
 
       IF g_fao.fao02 IS NULL THEN LET g_fao.fao02 = ' ' END IF   
       IF g_fao.fao06 IS NULL THEN LET g_fao.fao06 = ' ' END IF   
 
       #不可有大於該還原月份的異動 
 
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fay_file,faz_file
         WHERE fay01=faz01 AND faz03=g_fao.fao01 AND faz031=g_fao.fao02
#No.TQC-7B0060 --start--
#          AND ((YEAR(fay02)=g_yy AND MONTH(fay02)>g_mm) OR 
#                YEAR(fay02)>g_yy)
           AND ((YEAR(fay02)=g_y1 AND MONTH(fay02)>g_m1) OR 
                 YEAR(fay02)>g_y1)
#No.TQC-7B0060 --end--
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-145",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fao.fao01
          LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
          LET g_show_msg[g_cnt2].ze01   = 'afa-145'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
       
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fba_file,fbb_file
         WHERE fba01=fbb01 AND fbb03=g_fao.fao01 AND fbb031=g_fao.fao02
#No.TQC-7B0060 --start--
#          AND ((YEAR(fba02)=g_yy AND MONTH(fba02)>g_mm) OR 
#                YEAR(fba02)>g_yy)
           AND ((YEAR(fba02)=g_y1 AND MONTH(fba02)>g_m1) OR 
                 YEAR(fba02)>g_y1)
#No.TQC-7B0060 --end--
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-146",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fao.fao01
          LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
          LET g_show_msg[g_cnt2].ze01   = 'afa-146'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
       
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fbc_file,fbd_file
         WHERE fbc01=fbd01 AND fbd03=g_fao.fao01 AND fbd031=g_fao.fao02
#No.TQC-7B0060 --start--
#          AND ((YEAR(fbc02)=g_yy AND MONTH(fbc02)>g_mm) OR
#                YEAR(fbc02)>g_yy)
           AND ((YEAR(fbc02)=g_y1 AND MONTH(fbc02)>g_m1) OR
                 YEAR(fbc02)>g_y1)
#No.TQC-7B0060 --end--
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-147",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fao.fao01
          LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
          LET g_show_msg[g_cnt2].ze01   = 'afa-147'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
       
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fgh_file,fgi_file
         WHERE fgh01=fgi01 AND fgi06=g_fao.fao01 AND fgi07=g_fao.fao02
#No.TQC-7B0060 --start--
#          AND ((YEAR(fgh02)=g_yy AND MONTH(fgh02)>g_mm) OR
#                YEAR(fgh02)>g_yy)
           AND ((YEAR(fgh02)=g_y1 AND MONTH(fgh02)>g_m1) OR
                 YEAR(fgh02)>g_y1)
           AND fghconf<>'X'  #CHI-C80041
#No.TQC-7B0060 --end--
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-148",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fao.fao01
          LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
          LET g_show_msg[g_cnt2].ze01   = 'afa-148'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
 
       #不可有大於該還原月份的折舊
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fao_file
         WHERE fao01 = g_fao.fao01 AND fao02 = g_fao.fao02
           AND ((fao03=g_yy AND fao04>g_mm) OR fao03>g_yy) 
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-149",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fao.fao01
          LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
          LET g_show_msg[g_cnt2].ze01   = 'afa-149'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
 
      #當月起始日與截止日
      #CALL s_azm(g_y1,g_m1) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add #CHI-A60036 mark
      #CHI-A60036 add --start--
       CALL s_get_bookno(g_y1)
          RETURNING g_flag,g_bookno1,g_bookno2
 #    IF g_aza.aza63 = 'Y' THEN  
      IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 
         CALL s_azmm(g_y1,g_m1,g_plant,g_bookno1) RETURNING l_correct,l_bdate,l_edate 
      ELSE
         CALL s_azm(g_y1,g_m1) RETURNING l_correct,l_bdate,l_edate
      END IF
      #CHI-A60036 add --end--
 
       #當月處份應提列折舊='Y',處份需先確認還原
       IF g_faa.faa23 = 'Y' THEN
          LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM fbg_file,fbh_file
            WHERE fbg01=fbh01 AND fbh03=g_fao.fao01 AND fbh031=g_fao.fao02
             #AND fbgconf='Y' AND YEAR(fbg02)=g_yy AND MONTH(fbg02)=g_mm #No.TQC-7B0060 mark
              AND fbgconf='Y' 
             #AND YEAR(fbg02)=g_y1 AND MONTH(fbg02)=g_m1 #No.TQC-7B0060 #CHI-9A0021 mark
              AND fbg02 BETWEEN l_bdate AND l_edate      #CHI-9A0021
 
          IF l_cnt > 0 THEN
             CALL cl_getmsg("afa-150",g_lang) RETURNING l_msg
             LET g_show_msg[g_cnt2].faj02  = g_fao.fao01 
             LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
             LET g_show_msg[g_cnt2].ze01   = 'afa-150'
             LET g_show_msg[g_cnt2].ze03   = l_msg
             LET g_cnt2 = g_cnt2 + 1
             LET g_success='N'
             CONTINUE FOREACH
          END IF
          
          LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM fbe_file,fbf_file
            WHERE fbe01=fbf01 AND fbf03=g_fao.fao01 AND fbf031=g_fao.fao02
#             AND fbeconf='Y' AND YEAR(fbe02)=g_yy AND MONTH(fbe02)=g_mm #No.TQC-7B0060 mark
              AND fbeconf='Y' 
             #AND YEAR(fbe02)=g_y1 AND MONTH(fbe02)=g_m1 #No.TQC-7B0060  #No.TQC-7B0060 mark
              AND fbe02 BETWEEN l_bdate AND l_edate      #CHI-9A0021
          IF l_cnt > 0 THEN
             CALL cl_getmsg("afa-151",g_lang) RETURNING l_msg
             LET g_show_msg[g_cnt2].faj02  = g_fao.fao01 
             LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
             LET g_show_msg[g_cnt2].ze01   = 'afa-151'
             LET g_show_msg[g_cnt2].ze03   = l_msg
             LET g_cnt2 = g_cnt2 + 1
             LET g_success='N'
             CONTINUE FOREACH
          END IF
       END IF
       
       #若在折舊月份前就為先前折畢
       SELECT faj65,faj74,faj741 INTO l_faj65,l_faj74,l_faj741    
                                 FROM faj_file 
                                WHERE faj02  = g_fao.fao01 
                                  AND faj022 = g_fao.fao02 
       IF SQLCA.sqlcode THEN 
          LET g_show_msg[g_cnt2].faj02  = g_fao.fao01
          LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
          LET g_show_msg[g_cnt2].ze01   = ''
          LET g_show_msg[g_cnt2].ze03   = 'sel faj_file'
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
       IF l_faj65 = 0 and ( l_faj74 < g_yy or
             ( l_faj74=g_yy and l_faj741< g_mm )) THEN
          LET l_over = 'Y'    
       ELSE 
          LET l_over = 'N'    
       END IF 
 
       LET l_mm = g_mm - 1      
       LET l_yy = g_yy
       IF l_mm < 1 THEN
          LET l_yy = g_yy - 1
          LET l_mm = 12 
       END IF
       #還原 折舊年月,累折,未折減額,剩餘月數,資產狀態
      #IF l_over = 'N' THEN                         #MOD-C50066 mark 
       IF l_over = 'N' AND g_fao.fao05 != '3' THEN  #MOD-C50066
         #SELECT faj201,faj73 INTO l_faj201,l_faj73 FROM faj_file  #TQC-C50086 add faj73 #MOD-C50066 mark
         #MOD-C50066---S---
          SELECT faj201,faj681,faj26,faj64,faj73              
            INTO l_faj201,l_faj681,l_faj26,l_faj64,l_faj73     
            FROM faj_file
         #MOD-C50066---E---
           WHERE faj02 = g_fao.fao01 AND faj022 = g_fao.fao02 
         #MOD-C50066---S---
          IF g_faa.faa15 = '4' THEN
             LET l_cnt = 0
             SELECT COUNT(DISTINCT fao03||fao04) INTO l_cnt
               FROM fao_file
              WHERE fao01=g_fao.fao01 AND fao02 = g_fao.fao02
             IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
             #如何判斷此次還原是否為殘月,
             #狀態為4或7可能為一般/續提折舊的最後一期,
             #再判斷已存在折舊檔折舊次數+1是否等於耐用年限,且入帳日不為1,
             #還原時,faj30還是要為0,faj331需寫回
             IF (l_faj201 = '7' OR l_faj201 ='4') AND
                l_cnt = l_faj64+1 AND DAY(l_faj26) != 1 THEN
                LET l_faj65=0
             ELSE
                LET l_faj65=l_faj65 + 1
             END IF
          ELSE
         #MOD-C50066---E---
             IF l_faj201 = '7' THEN      #TQC-C50086 mark  #MOD-C50066 remark 
                IF l_faj65=l_faj73 THEN  #TQC-C50086 add
                   LET l_faj65=1
                ELSE 
                   LET l_faj65=l_faj65 + 1
                END IF
             ELSE  #TQC-C50086 add
                LET l_faj65 = l_faj65 + 1 #TQC-C50086 add
             END IF  
          END IF  #MOD-C50066 
          SELECT MAX(fao03*100+fao04) INTO l_ym FROM fao_file
                 WHERE fao01=g_fao.fao01 AND fao02 = g_fao.fao02
                   AND ((fao03 = g_yy AND fao04 < g_mm)
                    OR fao03 < g_yy)
          IF STATUS THEN
             IF cl_null(l_ym) THEN  #MOD-C50066 add
                LET l_yy2 = ''
                LET l_mm2 = ''
             END IF                 #MOD-C50066 add
          ELSE
             LET l_yy2 = l_ym[1,4]
             LET l_mm2 = l_ym[5,6]
          END IF
          IF g_faa.faa15 != '4' THEN  #MOD-C50066 add 
             UPDATE faj_file SET faj74  = l_yy2,                  #最近折舊年
                                 faj741 = l_mm2,                  #最近折舊月
                                 faj67  = faj67 - g_fao.fao07,    #累折
                                 faj205 = faj205- g_fao.fao07,    #本期累折
                                 faj68  = faj68 + g_fao.fao07,    #未折減額
                                 faj65  = l_faj65,      
                                 faj201  = g_fao.fao10              #狀態
                           WHERE faj02  = g_fao.fao01
                             AND faj022 = g_fao.fao02 
         #MOD-C50066---S---
          ELSE
             #當最後那個殘月的折舊還原,需還原第一個月未折減額
             SELECT faj66,faj68,faj681,faj26,faj27,faj64
               INTO l_faj66,l_faj68,l_faj681,l_faj26,l_faj27,l_faj64
               FROM faj_file
              WHERE faj02  = g_fao.fao01
                AND faj022 = g_fao.fao02
             LET l_cnt = 0
             SELECT COUNT(DISTINCT fao03||fao04) INTO l_cnt
               FROM fao_file
              WHERE fao01=g_fao.fao01 AND fao02 = g_fao.fao02
             IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
             #如何判斷此次還原是否為殘月,
             #狀態為4或7可能為一般/續提折舊的最後一期,
             #再判斷已存在折舊檔折舊次數+1是否等於耐用年限,且入帳日不為1,
             #還原時,faj30還是要為0,faj331需寫回
             IF (l_faj201 = '7' OR l_faj201 ='4') AND
                l_cnt = l_faj64+1 AND DAY(l_faj26) != 1 THEN
                #最後那個殘月的折舊還原
                UPDATE faj_file SET faj74  = l_yy2,                  #最近折舊年
                                    faj741 = l_mm2,                  #最近折舊月
                                    faj67  = faj67 - g_fao.fao07,    #累折
                                    faj205 = faj205- g_fao.fao07,    #本期累折
                                    faj681 = faj681+ g_fao.fao07,    #第一個月未折減額
                                    faj65  = l_faj65,
                                    faj201 = g_fao.fao10             #狀態
                              WHERE faj02  = g_fao.fao01
                                AND faj022 = g_fao.fao02
             ELSE
                IF g_ym = l_faj27 THEN    #第一期攤提還原
                   UPDATE faj_file SET faj74  = l_yy2,                            #最近折舊年
                                       faj741 = l_mm2,                            #最近折舊月
                                       faj67  = faj67 - g_fao.fao07,              #累折
                                       faj205 = faj205- g_fao.fao07,              #本期累折
                                       faj68  = faj68 + g_fao.fao07+ l_faj331,    #未折減額
                                       faj681 = 0,                                #第一個月未折減額
                                       faj65  = l_faj65,
                                       faj201 = g_fao.fao10                       #狀態
                                 WHERE faj02  = g_fao.fao01
                                   AND faj022 = g_fao.fao02
                ELSE
                   UPDATE faj_file SET faj74  = l_yy2,                  #最近折舊年
                                       faj7411 = l_mm2,                  #最近折舊月
                                       faj67  = faj67 - g_fao.fao07,    #累折
                                       faj205 = faj205- g_fao.fao07,    #本期累折
                                       faj68  = faj68 + g_fao.fao07,    #未折減額
                                       faj65  = l_faj65,
                                       faj201 = g_fao.fao10             #狀態
                                 WHERE faj02  = g_fao.fao01
                                   AND faj022 = g_fao.fao02
                END IF
             END IF
          END IF       
         #MOD-C50066---E---

           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
              LET g_show_msg[g_cnt2].faj02  = g_fao.fao01
              LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
              LET g_show_msg[g_cnt2].ze01   = ''
              LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
              LET g_cnt2 = g_cnt2 + 1
              LET g_success='N'
              CONTINUE FOREACH
           END IF
       END IF
      #刪除折舊費用各期明細檔--------
      DELETE FROM fao_file WHERE fao01 = g_fao.fao01 
                              AND fao02 = g_fao.fao02 
                              AND fao03 = g_yy   
                              AND fao04 = g_mm
                              AND fao041 = '1'             #MOD-A20046 add
                              AND fao05 = g_fao.fao05      #TQC-C50190 add
                              AND fao06 = g_fao.fao06      #TQC-C50190 add
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_show_msg[g_cnt2].faj02  = g_fao.fao01
         LET g_show_msg[g_cnt2].faj022 = g_fao.fao02
         LET g_show_msg[g_cnt2].ze01   = ''
         LET g_show_msg[g_cnt2].ze03   = 'del fao_file'
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
    END FOREACH
END FUNCTION 
#CHI-860025
