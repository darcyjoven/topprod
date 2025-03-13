# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afap301.4gl
# Descriptions...: 攤提折舊還原作業                    
# Date & Author..: 96/07/04 By Sophia 注意:資產狀態還原(折畢)
# Modify.........: No:7750 03/08/07 By Wiky IF cl_null(l_status) 應default為1不應為2
# Modify.........: No.MOD-460529 04/09/16 By Kitty 還原前應判斷若已有當月折舊傳票產生,不允執行
# Modify.........: No.MOD-550151 05/06/02 By ching fix折畢續提問題
# Modify.........: No.MOD-590393 05/10/20 By Smapmin 針對還原當月被分攤部份 fan05 = 3 全部刪除
# Modify.........: No.MOD-620056 06/02/20 By Smapmin IF cl_null(l_status) THEN LET l_status = '2' 較為合理
# Modify.........: No.FUN-570144 06/03/03 By yiting 批次作業背景執行
# Modify.........: No.MOD-640109 06/04/09 By Smapmin l_status為NULL時,直接給予faj43的值
# Modify.........: No.MOD-640391 06/04/12 By Smapmin fan_file無法被正常的刪除
# Modify.........: No.MOD-660028 06/06/12 By Smapmin fan_file有資料時,才做DELETE
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-640183 06/07/20 By Smapmin 還原狀態與金額有誤
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710028 07/01/17 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.CHI-730024 07/03/29 By Smapmin 跨年度還原時,本期累折有誤
#                                                    當月需先折舊才能執行折舊還原
# Modify.........: No.MOD-740009 07/04/03 By Smapmin 修改ORDER BY方式
# Modify.........: No.TQC-780083 07/09/21 By Smapmin 將原本的程式段備份於afap300.bak,該張單子將程式段重新調整
# Modify.........: No.TQC-7B0060 07/11/13 By Rayven 異動單據的日期為自然年月，沒有轉換成會計月的年月，與會計年月比較，造成不可還原
# Modify.........: No.CHI-970002 09/07/24 By mike 折舊參數faa15(固定資產入帳開始提列方式)選擇4.本月(入帳日到月底比率)時,折舊還原需> 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No:MOD-9B0021 09/11/04 By Sarah 折畢再提折舊還原時,未用年限還原錯誤
# Modify.........: No:CHI-A30029 10/03/25 By Summer 增加檢核 fan19 IS NOT NULL 則不可還原
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No:MOD-A20046 10/10/05 By sabrina 刪除折舊檔時多增加 fan041='1'條件
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:MOD-B90105 11/09/16 By johung 修正afa-145/afa-146/afa-147/afa-150/afa-151未排除作廢單據
# Modify.........: No:MOD-BA0150 11/10/21 By johung 調整fan05條件
# Modify.........: No:MOD-BC0123 12/01/16 By Sakura 還原訊息afa-150之select段MOD-B90105的修改
# Modify.........: No:MOD-C20072 12/02/08 By wujie  fan_file删除条件过大
# Modify.........: No:MOD-C20126 12/02/15 By Polly 調整多部門折舊取消時，耐用年限錯誤
# Modify.........: No:TQC-C80018 12/08/09 By lujh 資產性質:faj09,資產類型:faj04,財產編號:faj02 改為開窗，資料可多選
# Modify.........: No:MOD-CA0224 12/11/02 By suncx 資產編號開窗時應為當月已折資產
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc             STRING,
       g_yy,g_mm	LIKE type_file.num5,
       l_yy,l_mm        LIKE type_file.num5,
       g_fan		RECORD LIKE fan_file.*,
       g_fbn            RECORD LIKE fbn_file.*,   #No:FUN-AB0088
       g_faj            RECORD LIKE faj_file.*,
       p_row,p_col      LIKE type_file.num5,
       g_flag           LIKE type_file.chr1,
       g_cnt2           LIKE type_file.num5,  
       g_ym             LIKE type_file.chr6    #CHI-970002 add     
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
       CALL p301()
       IF cl_sure(18,20) THEN
          LET g_cnt2 = 1
          CALL g_show_msg.clear()
          CALL p301_1()
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
             CLOSE WINDOW p301_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
    ELSE
       LET g_cnt2 = 1
       CALL g_show_msg.clear()
       CALL p301_1()
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
 
FUNCTION p301()
    DEFINE   lc_cmd     LIKE type_file.chr1000            
    CLEAR FORM
    LET p_row = 10
    LET p_col = 10
    OPEN WINDOW p301_w AT p_row,p_col WITH FORM "afa/42f/afap301"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
     
    CALL cl_ui_init()
  
    WHILE TRUE
      SELECT faa07,faa08 INTO g_yy,g_mm FROM faa_file
      LET g_ym = g_yy USING '&&&&',g_mm USING '&&'   #CHI-970002 add  
      DISPLAY g_yy TO FORMONLY.yy 
      DISPLAY g_mm TO FORMONLY.mm 
      LET g_bgjob = "N"
      #No.TQC-7B0060 --start--
      #CALL s_azm(g_yy,g_mm) RETURNING l_flag,g_b1,g_e1 #CHI-A60036 mark
      #CHI-A60036 add --start--
      CALL s_get_bookno(g_yy)
         RETURNING g_flag,g_bookno1,g_bookno2
  #   IF g_aza.aza63 = 'Y' THEN
      IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
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
     
        #TQC-C80018--add--str--
        ON ACTION CONTROLP
         CASE
            WHEN INFIELD(faj09)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_faj09"
               LET g_qryparam.arg1 = g_lang
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faj09
               NEXT FIELD faj09
            WHEN INFIELD(faj04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_fab"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faj04
               NEXT FIELD faj04
            WHEN INFIELD(faj02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
              #LET g_qryparam.form ="q_faj"   #MOD-CA0224 mark
               LET g_qryparam.form ="q_fan01" #MOD-CA0224 add
               LET g_qryparam.arg1 =g_yy      #MOD-CA0224 add
               LET g_qryparam.arg2 =g_mm      #MOD-CA0224 add
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faj02
               NEXT FIELD faj02
         END CASE
        #TQC-C80018--add--end--
 
        ON ACTION exit                            #加離開功能
           LET INT_FLAG = 1
           EXIT CONSTRUCT
      
        ON ACTION qbe_select
           CALL cl_qbe_select()
      
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p301_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_wc =' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
  
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01 = "afap301"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap301','9031',1)
         ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                       " '",g_yy CLIPPED,"'",
                       " '",g_mm CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('afap301',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p301_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
      END IF
    EXIT WHILE
  END WHILE
END FUNCTION
 
FUNCTION p301_1()
 DEFINE  l_over     LIKE type_file.chr1,
         l_cnt      LIKE type_file.num5,
         l_cnt1_1   LIKE type_file.num5,   #No:FUN-AB0088
         l_cnt1_2   LIKE type_file.num5,   #No:FUN-AB0088
         l_faj30    LIKE faj_file.faj30,
         l_faj31    LIKE faj_file.faj31,    #CHI-970002 add                                                                         
         l_faj33    LIKE faj_file.faj33,    #CHI-970002 add                                                                         
         l_faj331   LIKE faj_file.faj331,   #CHI-970002 add                                                                         
         l_faj26    LIKE faj_file.faj26,    #CHI-970002 add                                                                         
         l_faj27    LIKE faj_file.faj27,    #CHI-970002 add                                                                         
         l_faj29    LIKE faj_file.faj29,    #CHI-970002 add  
         l_faj36    LIKE faj_file.faj36,    #MOD-9B0021 add
         l_faj57    LIKE faj_file.faj57,
         l_faj571   LIKE faj_file.faj571,
         l_faj43    LIKE faj_file.faj43,
         l_faj302   LIKE faj_file.faj302,   #No:FUN-AB0088
         l_faj312   LIKE faj_file.faj312,   #No:FUN-AB0088
         l_faj332   LIKE faj_file.faj332,   #No:FUN-AB0088
         l_faj3312  LIKE faj_file.faj3312,  #No:FUN-AB0088
         l_faj262   LIKE faj_file.faj262,   #No:FUN-AB0088
         l_faj272   LIKE faj_file.faj272,   #No:FUN-AB0088
         l_faj292   LIKE faj_file.faj292,   #No:FUN-AB0088
         l_faj362   LIKE faj_file.faj362,   #No:FUN-AB0088
         l_faj572   LIKE faj_file.faj572,   #No:FUN-AB0088
         l_faj5712  LIKE faj_file.faj5712,  #No:FUN-AB0088
         l_faj432   LIKE faj_file.faj432    #No:FUN-AB0088 
    DEFINE  l_yy2               LIKE type_file.chr4,   
            l_mm2               LIKE type_file.chr2,
            l_ym                LIKE type_file.chr6
    DEFINE  l_sql               STRING   
    DEFINE  l_bdate,l_bdate1    LIKE type_file.dat   #CHI-9A0021 add
    DEFINE  l_edate,l_edate1    LIKE type_file.dat   #CHI-9A0021 add
    DEFINE  l_correct           LIKE type_file.chr1  #CHI-9A0021 add
 
   #當月起始日與截止日
   #CALL s_azm(g_yy,g_mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_yy)
      RETURNING g_flag,g_bookno1,g_bookno2
#  IF g_aza.aza63 = 'Y' THEN
   IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
      CALL s_azmm(g_yy,g_mm,g_plant,g_bookno1) RETURNING l_correct,l_bdate,l_edate
   ELSE
      CALL s_azm(g_yy,g_mm) RETURNING l_correct,l_bdate,l_edate
   END IF
   #CHI-A60036 add --end--

    #取折舊明細檔中分攤類別不為'3'被分攤者,還原資產主檔
 #  LET l_cnt = 0
    LET l_cnt1_1 = 0   #No:FUN-AB0088
    LET l_cnt1_2 = 0   #No:FUN-AB0088
    LET l_sql = " SELECT COUNT(*) FROM fan_file,faj_file ",
               #"  WHERE fan03='",g_yy,"' AND fan04='",g_mm,"' AND fan05<>'3'",           #MOD-BA0150 mark
               #"  WHERE fan03='",g_yy,"' AND fan04='",g_mm,"' AND fan05 IN ('1','3')",   #MOD-BA0150 #MOD-C20126 mark
                "  WHERE fan03='",g_yy,"' AND fan04='",g_mm,"' ",                         #MOD-C20126 add
                "  AND faj02 = fan01 ",
                "  AND faj022 = fan02 ",
                "  AND fan041='1' AND ",g_wc
    PREPARE p301_p2 FROM l_sql
    DECLARE p301_cs2 CURSOR FOR p301_p2
    OPEN p301_cs2
#   FETCH p301_cs2 INTO l_cnt
    FETCH p301_cs2 INTO l_cnt1_1   #No:FUN-AB0088

   ##-----No:FUN-B60140 Mark-----
   ##-----No:FUN-AB0088-----
   #IF g_faa.faa31 = 'Y' THEN
   #   LET l_sql = " SELECT COUNT(*) FROM fbn_file,faj_file ",
   #               "  WHERE fbn03='",g_yy,"' AND fbn04='",g_mm,"' AND fbn05<>'3'",
   #               "  AND faj02 = fbn01 ",
   #               "  AND faj022 = fbn02 ",
   #               "  AND fbn041='1' AND ",g_wc
   #   PREPARE p301_p21 FROM l_sql
   #   DECLARE p301_cs21 CURSOR FOR p301_p21
   #   OPEN p301_cs21
   #   FETCH p301_cs21 INTO l_cnt1_2
   #END IF
   ##-----No:FUN-B60140 Mark END-----

 #  IF l_cnt = 0 THEN
    #IF l_cnt1_1 = 0 AND l_cnt1_2 = 0 THEN   #No:FUN-AB0088
    IF l_cnt1_1 = 0 THEN    #No:FUN-B60140
       CALL cl_err('','afa-115',1)
       RETURN
    END IF

#NO.CHI-A30029 mark-------start------- 
   # LET l_cnt = 0
   # SELECT COUNT(*) INTO l_cnt FROM npp_file
   #  WHERE nppsys='FA' AND npp00=10 
   #   #AND YEAR(npp03)=g_yy AND MONTH(npp03)=g_mm  #CHI-9A0021
   #    AND npp03 BETWEEN l_bdate AND l_edate       #CHI-9A0021
   #    AND npptype = '0'  #No:FUN-B60140
   # IF l_cnt > 0 THEN
   #    CALL cl_err(0,'afa-363',1)
   #    RETURN 
   # END IF
#NO.CHI-A30029 mark-------end-------
 
    #IF l_cnt1_1 <> 0 THEN   #No:FUN-AB0088  #No:FUN-B60140 Mark
       INITIALIZE g_fan.* TO NULL
       LET l_sql = "SELECT fan_file.* FROM fan_file,faj_file ",
                  #" WHERE fan03='",g_yy,"' AND fan04='",g_mm,"' AND fan05<>'3' ",           #MOD-BA0150 mark
                  #" WHERE fan03='",g_yy,"' AND fan04='",g_mm,"' AND fan05 IN ('1','3') ",   #MOD-BA0150 #MOD-C20126 mark
                   " WHERE fan03='",g_yy,"' AND fan04='",g_mm,"'",                           #MOD-C20126 add
                   " AND faj02 = fan01 ",
                   " AND faj022 = fan02 ",
                   " AND fan041 = '1' AND ",g_wc
       PREPARE p301_p FROM l_sql
       DECLARE p301_cs CURSOR WITH HOLD FOR p301_p
 
       FOREACH p301_cs INTO g_fan.*                  
       IF SQLCA.sqlcode  THEN
          CALL cl_err('p301_cs foreach:',STATUS,1) 
          RETURN
       END IF
       LET g_success='Y'
       BEGIN WORK
 
       IF g_fan.fan02 IS NULL THEN LET g_fan.fan02 = ' ' END IF   
       IF g_fan.fan06 IS NULL THEN LET g_fan.fan06 = ' ' END IF   
 
#NO.CHI-A30029-------start-------
       #增加檢核 fan19 IS NOT NULL 則不可還原
       IF NOT cl_null(g_fan.fan19)  THEN 
          CALL cl_getmsg("afa-363",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
          LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
          LET g_show_msg[g_cnt2].ze01   = 'afa-363'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
        CONTINUE FOREACH
       END IF
#NO.CHI-A30029-------end---------

       #不可有大於該還原月份的異動 
 
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fay_file,faz_file
         WHERE fay01=faz01 AND faz03=g_fan.fan01 AND faz031=g_fan.fan02
#No.TQC-7B0060 --start--
#          AND ((YEAR(fay02)=g_yy AND MONTH(fay02)>g_mm) OR 
#                YEAR(fay02)>g_yy)
           AND ((YEAR(fay02)=g_y1 AND MONTH(fay02)>g_m1) OR 
                 YEAR(fay02)>g_y1)
           AND fayconf <> 'X'   #MOD-B90105 add
#No.TQC-7B0060 --end--
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-145",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
          LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
          LET g_show_msg[g_cnt2].ze01   = 'afa-145'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
       
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fba_file,fbb_file
         WHERE fba01=fbb01 AND fbb03=g_fan.fan01 AND fbb031=g_fan.fan02
#No.TQC-7B0060 --start--
#          AND ((YEAR(fba02)=g_yy AND MONTH(fba02)>g_mm) OR 
#                YEAR(fba02)>g_yy)
           AND ((YEAR(fba02)=g_y1 AND MONTH(fba02)>g_m1) OR 
                 YEAR(fba02)>g_y1)
           AND fbaconf <> 'X'   #MOD-B90105 add
#No.TQC-7B0060 --end--
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-146",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
          LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
          LET g_show_msg[g_cnt2].ze01   = 'afa-146'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
       
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fbc_file,fbd_file
         WHERE fbc01=fbd01 AND fbd03=g_fan.fan01 AND fbd031=g_fan.fan02
#No.TQC-7B0060 --start--
#          AND ((YEAR(fbc02)=g_yy AND MONTH(fbc02)>g_mm) OR
#                YEAR(fbc02)>g_yy)
           AND ((YEAR(fbc02)=g_y1 AND MONTH(fbc02)>g_m1) OR
                 YEAR(fbc02)>g_y1)
           AND fbcconf <> 'X'   #MOD-B90105 add
#No.TQC-7B0060 --end--
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-147",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
          LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
          LET g_show_msg[g_cnt2].ze01   = 'afa-147'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
       
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fgh_file,fgi_file
         WHERE fgh01=fgi01 AND fgi06=g_fan.fan01 AND fgi07=g_fan.fan02
#No.TQC-7B0060 --start--
#          AND ((YEAR(fgh02)=g_yy AND MONTH(fgh02)>g_mm) OR
#                YEAR(fgh02)>g_yy)
           AND ((YEAR(fgh02)=g_y1 AND MONTH(fgh02)>g_m1) OR
                 YEAR(fgh02)>g_y1)
           AND fghconf<>'X'  #CHI-C80041
#No.TQC-7B0060 --end--
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-148",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
          LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
          LET g_show_msg[g_cnt2].ze01   = 'afa-148'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
 
       #不可有大於該還原月份的折舊
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt FROM fan_file
         WHERE fan01 = g_fan.fan01 AND fan02 = g_fan.fan02
           AND ((fan03=g_yy AND fan04>g_mm) OR fan03>g_yy) 
       IF l_cnt > 0 THEN
          CALL cl_getmsg("afa-149",g_lang) RETURNING l_msg
          LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
          LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
          LET g_show_msg[g_cnt2].ze01   = 'afa-149'
          LET g_show_msg[g_cnt2].ze03   = l_msg
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
 
      #當月起始日與截止日
      #CALL s_azm(g_y1,g_m1) RETURNING l_correct,l_bdate1,l_edate1   #CHI-9A0021 add #CHI-A60036 mark
      #CHI-A60036 add --start--
      CALL s_get_bookno(g_y1)
         RETURNING g_flag,g_bookno1,g_bookno2
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(g_y1,g_m1,g_plant,g_bookno1) RETURNING l_correct,l_bdate1,l_edate1
      ELSE
         CALL s_azm(g_y1,g_m1) RETURNING l_correct,l_bdate1,l_edate1
      END IF
      #CHI-A60036 add --end--
 
       #當月處份應提列折舊='Y',處份需先確認還原
       IF g_faa.faa23 = 'Y' THEN
          LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM fbg_file,fbh_file
            WHERE fbg01=fbh01 AND fbh03=g_fan.fan01 AND fbh031=g_fan.fan02
#             AND fbgconf='Y' AND YEAR(fbg02)=g_yy AND MONTH(fbg02)=g_mm #No.TQC-7B0060 mark
              AND fbgconf='Y'      #MOD-B90105 mark #MOD-BC0123 remark
             #AND fbgconf <> 'X'   #MOD-B90105 #MOD-BC0123 mark
             #AND YEAR(fbg02)=g_y1 AND MONTH(fbg02)=g_m1 #No.TQC-7B0060  #CHI-9A0021 mark
              AND fbg02 BETWEEN l_bdate1 AND l_edate1                    #CHI-9A0021 add
          IF l_cnt > 0 THEN
             CALL cl_getmsg("afa-150",g_lang) RETURNING l_msg
             LET g_show_msg[g_cnt2].faj02  = g_fan.fan01 
             LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
             LET g_show_msg[g_cnt2].ze01   = 'afa-150'
             LET g_show_msg[g_cnt2].ze03   = l_msg
             LET g_cnt2 = g_cnt2 + 1
             LET g_success='N'
             CONTINUE FOREACH
          END IF
          
          LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM fbe_file,fbf_file
            WHERE fbe01=fbf01 AND fbf03=g_fan.fan01 AND fbf031=g_fan.fan02
#             AND fbeconf='Y' AND YEAR(fbe02)=g_yy AND MONTH(fbe02)=g_mm #No.TQC-7B0060 mark
             #AND fbeconf='Y'      #MOD-B90105 mark
              AND fbeconf <> 'X'   #MOD-B90105
             #AND YEAR(fbe02)=g_y1 AND MONTH(fbe02)=g_m1 #No.TQC-7B0060  #CHI-9A0021 mark
              AND fbe02 BETWEEN l_bdate1 AND l_edate1                    #CHI-9A0021 add
          IF l_cnt > 0 THEN
             CALL cl_getmsg("afa-151",g_lang) RETURNING l_msg
             LET g_show_msg[g_cnt2].faj02  = g_fan.fan01 
             LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
             LET g_show_msg[g_cnt2].ze01   = 'afa-151'
             LET g_show_msg[g_cnt2].ze03   = l_msg
             LET g_cnt2 = g_cnt2 + 1
             LET g_success='N'
             CONTINUE FOREACH
          END IF
       END IF
       
       #若在折舊月份前就為先前折畢
       SELECT faj30,faj57,faj571 INTO l_faj30,l_faj57,l_faj571    
                                 FROM faj_file 
                                WHERE faj02  = g_fan.fan01 
                                  AND faj022 = g_fan.fan02 
       IF SQLCA.sqlcode THEN 
          LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
          LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
          LET g_show_msg[g_cnt2].ze01   = ''
          LET g_show_msg[g_cnt2].ze03   = 'sel faj_file'
          LET g_cnt2 = g_cnt2 + 1
          LET g_success='N'
          CONTINUE FOREACH
       END IF
       IF l_faj30 = 0 and ( l_faj57 < g_yy or
             ( l_faj57=g_yy and l_faj571< g_mm )) THEN
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
      #IF l_over = 'N' THEN                           #MOD-C20126 mark
       IF l_over = 'N' AND g_fan.fan05 != '3' THEN    #MOD-C20126 add
         #str CHI-970002 mod   
         #SELECT faj43 INTO l_faj43 FROM faj_file
          SELECT faj43,faj331,faj26,faj29,faj36            #MOD-9B0021 add faj36
            INTO l_faj43,l_faj331,l_faj26,l_faj29,l_faj36  #MOD-9B0021 add faj36
            FROM faj_file                                                                                                           
         #end CHI-970002 mod   
           WHERE faj02 = g_fan.fan01 AND faj022 = g_fan.fan02
         #str CHI-970002 add                                                                                                        
          IF g_faa.faa15 = '4' THEN                                                                                                 
             LET l_cnt = 0                                                                                                          
             SELECT COUNT(DISTINCT fan03||fan04) INTO l_cnt                                                                         
               FROM fan_file                                                                                                        
              WHERE fan01=g_fan.fan01 AND fan02 = g_fan.fan02                                                                       
             IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                            
             #如何判斷此次還原是否為殘月,                                                                                           
             #狀態為4或7可能為一般/續提折舊的最後一期,                                                                              
             #再判斷已存在折舊檔折舊次數+1是否等於耐用年限,且入帳日不為1,                                                           
             #還原時,faj30還是要為0,faj331需寫回                                                                                    
             IF (l_faj43 = '7' OR l_faj43 ='4') AND                                                                                 
                l_cnt = l_faj29+1 AND DAY(l_faj26) != 1 THEN                                                                        
                LET l_faj30=0                                                                                                       
             ELSE                                                                                                                   
                LET l_faj30=l_faj30 + 1                                                                                             
             END IF                                                                                                                 
          ELSE                                                                                                                      
         #end CHI-970002 add       
             IF l_faj43 = '7' THEN      
               #str MOD-9B0021 mod
               #LET l_faj30=1
                IF l_faj30=l_faj36 THEN
                   #第一次進入折畢再提,還原的話是要將未用年限回寫為1
                   LET l_faj30=1
                ELSE
                   LET l_faj30=l_faj30 + 1
                END IF
               #end MOD-9B0021 mod
             ELSE 
                LET l_faj30=l_faj30 + 1
             END IF
          END IF   #CHI-970002 add     
          SELECT MAX(fan03*100+fan04) INTO l_ym FROM fan_file
                 WHERE fan01=g_fan.fan01 AND fan02 = g_fan.fan02
                   AND ((fan03 = g_yy AND fan04 < g_mm)
                    OR fan03 < g_yy)
          IF STATUS THEN
             IF cl_null(l_ym) THEN     #MOD-C20126 add
                LET l_yy2 = ''
                LET l_mm2 = ''
             END IF                    #MOD-C20126 add
          ELSE
             LET l_yy2 = l_ym[1,4]
             LET l_mm2 = l_ym[5,6]
          END IF
         IF g_faa.faa15 != '4' THEN  #CHI-970002 add   
          UPDATE faj_file SET faj57  = l_yy2,                  #最近折舊年
                              faj571 = l_mm2,                  #最近折舊月
                              faj32  = faj32 - g_fan.fan07,    #累折
                              faj203 = faj203- g_fan.fan07,    #本期累折
                              faj33  = faj33 + g_fan.fan07,    #未折減額
                              faj30  = l_faj30,      
                              faj43  = g_fan.fan10              #狀態
                        WHERE faj02  = g_fan.fan01
                          AND faj022 = g_fan.fan02
            #str CHI-970002 add                                                                                                    
          ELSE                                                                                                                      
             #當最後那個殘月的折舊還原,需還原第一個月未折減額                                                                       
             SELECT faj31,faj33,faj331,faj26,faj27,faj29                                                                            
               INTO l_faj31,l_faj33,l_faj331,l_faj26,l_faj27,l_faj29                                                                
               FROM faj_file                                                                                                        
              WHERE faj02  = g_fan.fan01                                                                                            
                AND faj022 = g_fan.fan02                                                                                            
             LET l_cnt = 0                                                                                                          
             SELECT COUNT(DISTINCT fan03||fan04) INTO l_cnt                                                                         
               FROM fan_file                                                                                                        
              WHERE fan01=g_fan.fan01 AND fan02 = g_fan.fan02                                                                       
             IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                            
             #如何判斷此次還原是否為殘月,                                                                                           
             #狀態為4或7可能為一般/續提折舊的最後一期,                                                                              
             #再判斷已存在折舊檔折舊次數+1是否等於耐用年限,且入帳日不為1,                                                           
             #還原時,faj30還是要為0,faj331需寫回                                                                                    
             IF (l_faj43 = '7' OR l_faj43 ='4') AND                                                                                 
                l_cnt = l_faj29+1 AND DAY(l_faj26) != 1 THEN                                                                        
                #最後那個殘月的折舊還原                                                                                             
                UPDATE faj_file SET faj57  = l_yy2,                  #最近折舊年                                                    
                                    faj571 = l_mm2,                  #最近折舊月                                                    
                                    faj32  = faj32 - g_fan.fan07,    #累折 
                                     faj203 = faj203- g_fan.fan07,    #本期累折                                                      
                                   faj331 = faj331+ g_fan.fan07,    #第一個月未折減額                                               
                                    faj30  = l_faj30,                                                                               
                                    faj43  = g_fan.fan10             #狀態                                                          
                              WHERE faj02  = g_fan.fan01                                                                            
                                AND faj022 = g_fan.fan02                                                                            
             ELSE                                                                                                                   
                IF g_ym = l_faj27 THEN    #第一期攤提還原                                                                           
                   UPDATE faj_file SET faj57  = l_yy2,                            #最近折舊年                                       
                                       faj571 = l_mm2,                            #最近折舊月                                       
                                       faj32  = faj32 - g_fan.fan07,              #累折                                             
                                       faj203 = faj203- g_fan.fan07,              #本期累折                                         
                                       faj33  = faj33 + g_fan.fan07+ l_faj331,    #未折減額                                         
                                       faj331 = 0,                                #第一個月未折減額                                 
                                       faj30  = l_faj30,                                                                            
                                       faj43  = g_fan.fan10                       #狀態                                             
                                 WHERE faj02  = g_fan.fan01                                                                         
                                   AND faj022 = g_fan.fan02                                                                         
                ELSE                                                                                                                
                   UPDATE faj_file SET faj57  = l_yy2,                  #最近折舊年                                                 
                                       faj571 = l_mm2,                  #最近折舊月                                                 
                                       faj32  = faj32 - g_fan.fan07,    #累折                                                       
                                       faj203 = faj203- g_fan.fan07,    #本期累折                                                   
                                       faj33  = faj33 + g_fan.fan07,    #未折減額
                                       faj30  = l_faj30,                                                                            
                                       faj43  = g_fan.fan10             #狀態                                                       
                                 WHERE faj02  = g_fan.fan01                                                                         
                                   AND faj022 = g_fan.fan02                                                                         
                END IF                                                                                                              
             END IF                                                                                                                 
          END IF                                                                                                                    
         #end CHI-970002 add                              
           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
              LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
              LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
              LET g_show_msg[g_cnt2].ze01   = ''
              LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
              LET g_cnt2 = g_cnt2 + 1
              LET g_success='N'
              CONTINUE FOREACH
           END IF
       END IF
      #刪除折舊費用各期明細檔--------
      DELETE FROM fan_file WHERE fan01 = g_fan.fan01 
                              AND fan02 = g_fan.fan02 
                              AND fan03 = g_yy   
                              AND fan04 = g_mm
                              AND fan041 = '1'            #MOD-A20046 add
#No.MOD-C20072 --begin
                              AND (fan05 = g_fan.fan05 OR fan05 = '2')
                              AND fan06 = g_fan.fan06  
#No.MOD-C20072 --end
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_show_msg[g_cnt2].faj02  = g_fan.fan01
         LET g_show_msg[g_cnt2].faj022 = g_fan.fan02
         LET g_show_msg[g_cnt2].ze01   = ''
         LET g_show_msg[g_cnt2].ze03   = 'del fan_file'
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
  #END IF   #No:FUN-AB0088   #No:FUN-B60140 Mark

   ##-----No:FUN-B60140 Mark-----
   ##-----No:FUN-AB0088-----
   #IF g_faa.faa31 = 'Y' AND l_cnt1_2 <> 0 THEN
   #   INITIALIZE g_fbn.* TO NULL

   #   LET l_sql = "SELECT fbn_file.* FROM fbn_file,faj_file ",
   #               " WHERE fbn03='",g_yy,"' AND fbn04='",g_mm,"' AND fbn05<>'3' ",
   #               "   AND faj02 = fbn01 ",
   #               "   AND faj022 = fbn02 ",
   #               "   AND fbn041 = '1' AND ",g_wc

   #   PREPARE p301_p3 FROM l_sql
   #   DECLARE p301_cs3 CURSOR WITH HOLD FOR p301_p3

   #   FOREACH p301_cs3 INTO g_fbn.*
   #      IF SQLCA.sqlcode  THEN
   #         CALL cl_err('p301_cs3 foreach:',STATUS,1)
   #         RETURN
   #      END IF

   #      LET g_success='Y'

   #      BEGIN WORK

   #      IF g_fbn.fbn02 IS NULL THEN LET g_fbn.fbn02 = ' ' END IF
   #      IF g_fbn.fbn06 IS NULL THEN LET g_fbn.fbn06 = ' ' END IF

   #      #不可有大於該還原月份的異動
   #      LET l_cnt=0

   #      SELECT COUNT(*) INTO l_cnt FROM fay_file,faz_file
   #       WHERE fay01=faz01 AND faz03=g_fbn.fbn01 AND faz031=g_fbn.fbn02
   #         AND ((YEAR(fay02)=g_y1 AND MONTH(fay02)>g_m1) OR
   #               YEAR(fay02)>g_y1)
   #      IF l_cnt > 0 THEN
   #         CALL cl_getmsg("afa-145",g_lang) RETURNING l_msg
   #         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #         LET g_show_msg[g_cnt2].ze01   = 'afa-145'
   #         LET g_show_msg[g_cnt2].ze03   = l_msg
   #         LET g_cnt2 = g_cnt2 + 1
   #         LET g_success='N'
   #         CONTINUE FOREACH
   #      END IF

   #      LET l_cnt=0
   #      SELECT COUNT(*) INTO l_cnt FROM fba_file,fbb_file
   #       WHERE fba01=fbb01 AND fbb03=g_fbn.fbn01 AND fbb031=g_fbn.fbn02
   #         AND ((YEAR(fba02)=g_y1 AND MONTH(fba02)>g_m1) OR
   #               YEAR(fba02)>g_y1)
   #      IF l_cnt > 0 THEN
   #         CALL cl_getmsg("afa-146",g_lang) RETURNING l_msg
   #         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #         LET g_show_msg[g_cnt2].ze01   = 'afa-146'
   #         LET g_show_msg[g_cnt2].ze03   = l_msg
   #         LET g_cnt2 = g_cnt2 + 1
   #         LET g_success='N'
   #         CONTINUE FOREACH
   #      END IF

   #      LET l_cnt=0
   #      SELECT COUNT(*) INTO l_cnt FROM fbc_file,fbd_file
   #       WHERE fbc01=fbd01 AND fbd03=g_fbn.fbn01 AND fbd031=g_fbn.fbn02
   #         AND ((YEAR(fbc02)=g_y1 AND MONTH(fbc02)>g_m1) OR
   #               YEAR(fbc02)>g_y1)
   #      IF l_cnt > 0 THEN
   #         CALL cl_getmsg("afa-147",g_lang) RETURNING l_msg
   #         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #         LET g_show_msg[g_cnt2].ze01   = 'afa-147'
   #         LET g_show_msg[g_cnt2].ze03   = l_msg
   #         LET g_cnt2 = g_cnt2 + 1
   #         LET g_success='N'
   #         CONTINUE FOREACH
   #      END IF

   #      LET l_cnt=0
   #      SELECT COUNT(*) INTO l_cnt FROM fgh_file,fgi_file
   #       WHERE fgh01=fgi01 AND fgi06=g_fbn.fbn01 AND fgi07=g_fbn.fbn02
   #         AND ((YEAR(fgh02)=g_y1 AND MONTH(fgh02)>g_m1) OR
   #               YEAR(fgh02)>g_y1)
   #      IF l_cnt > 0 THEN
   #         CALL cl_getmsg("afa-148",g_lang) RETURNING l_msg
   #         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #         LET g_show_msg[g_cnt2].ze01   = 'afa-148'
   #         LET g_show_msg[g_cnt2].ze03   = l_msg
   #         LET g_cnt2 = g_cnt2 + 1
   #         LET g_success='N'
   #         CONTINUE FOREACH
   #      END IF

   #      #不可有大於該還原月份的折舊
   #      LET l_cnt=0
   #      SELECT COUNT(*) INTO l_cnt FROM fbn_file
   #       WHERE fbn01 = g_fbn.fbn01 AND fbn02 = g_fbn.fbn02
   #         AND ((fbn03=g_yy AND fbn04>g_mm) OR fbn03>g_yy)
   #      IF l_cnt > 0 THEN
   #         CALL cl_getmsg("afa-149",g_lang) RETURNING l_msg
   #         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #         LET g_show_msg[g_cnt2].ze01   = 'afa-149'
   #         LET g_show_msg[g_cnt2].ze03   = l_msg
   #         LET g_cnt2 = g_cnt2 + 1
   #         LET g_success='N'
   #         CONTINUE FOREACH
   #      END IF

   #      #當月處份應提列折舊='Y',處份需先確認還原
   #      IF g_faa.faa23 = 'Y' THEN
   #         LET l_cnt=0
   #         SELECT COUNT(*) INTO l_cnt FROM fbg_file,fbh_file
   #          WHERE fbg01=fbh01 AND fbh03=g_fbn.fbn01 AND fbh031=g_fbn.fbn02
   #            AND fbgconf='Y'
   #            AND fbg02 BETWEEN l_bdate02 AND l_edate02
   #         IF l_cnt > 0 THEN
   #            CALL cl_getmsg("afa-150",g_lang) RETURNING l_msg
   #            LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #            LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #            LET g_show_msg[g_cnt2].ze01   = 'afa-150'
   #            LET g_show_msg[g_cnt2].ze03   = l_msg
   #            LET g_cnt2 = g_cnt2 + 1
   #            LET g_success='N'
   #            CONTINUE FOREACH
   #         END IF

   #         LET l_cnt=0
   #         SELECT COUNT(*) INTO l_cnt FROM fbe_file,fbf_file
   #          WHERE fbe01=fbf01 AND fbf03=g_fbn.fbn01 AND fbf031=g_fbn.fbn02
   #            AND fbeconf='Y'
   #            AND fbe02 BETWEEN l_bdate02 AND l_edate02
   #         IF l_cnt > 0 THEN
   #            CALL cl_getmsg("afa-151",g_lang) RETURNING l_msg
   #            LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #            LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #            LET g_show_msg[g_cnt2].ze01   = 'afa-151'
   #            LET g_show_msg[g_cnt2].ze03   = l_msg
   #            LET g_cnt2 = g_cnt2 + 1
   #            LET g_success='N'
   #            CONTINUE FOREACH
   #         END IF
   #      END IF

   #      #若在折舊月份前就為先前折畢
   #      SELECT faj302,faj572,faj5712 INTO l_faj302,l_faj572,l_faj5712
   #        FROM faj_file
   #       WHERE faj02  = g_fbn.fbn01
   #         AND faj022 = g_fbn.fbn02
   #      IF SQLCA.sqlcode THEN
   #         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #         LET g_show_msg[g_cnt2].ze01   = ''
   #         LET g_show_msg[g_cnt2].ze03   = 'sel faj_file'
   #         LET g_cnt2 = g_cnt2 + 1
   #         LET g_success='N'
   #         CONTINUE FOREACH
   #      END IF

   #     IF l_faj302 = 0 AND (l_faj572<g_yy OR
   #                         (l_faj572=g_yy AND l_faj5712<g_mm)) THEN
   #        LET l_over = 'Y'
   #     ELSE
   #        LET l_over = 'N'
   #     END IF

   #     LET l_mm = g_mm - 1
   #     LET l_yy = g_yy

   #     IF l_mm < 1 THEN
   #        LET l_yy = g_yy - 1
   #        LET l_mm = 12
   #     END IF

   #     #還原 折舊年月,累折,未折減額,剩餘月數,資產狀態
   #     IF l_over = 'N' THEN
   #        SELECT faj432,faj3312,faj262,faj292,faj362
   #          INTO l_faj432,l_faj3312,l_faj262,l_faj292,l_faj362
   #          FROM faj_file
   #         WHERE faj02 = g_fbn.fbn01
   #           AND faj022 = g_fbn.fbn02

   #        IF g_faa.faa15 = '4' THEN
   #           LET l_cnt = 0
   #           SELECT COUNT(DISTINCT fbn03||fbn04) INTO l_cnt
   #             FROM fbn_file
   #            WHERE fbn01=g_fbn.fbn01
   #              AND fbn02 = g_fbn.fbn02
   #           IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   #           #如何判斷此次還原是否為殘月,
   #           #狀態為4或7可能為一般/續提折舊的最後一期,
   #           #再判斷已存在折舊檔折舊次數+1是否等於耐用年限,且入帳日不為1,
   #           #還原時,faj30還是要為0,faj331需寫回
   #           IF (l_faj432 = '7' OR l_faj432 ='4') AND
   #              l_cnt = l_faj292+1 AND DAY(l_faj262) != 1 THEN
   #              LET l_faj302=0
   #           ELSE
   #              LET l_faj302=l_faj302 + 1
   #           END IF
   #        ELSE
   #           IF l_faj432 = '7' THEN
   #              IF l_faj302=l_faj362 THEN
   #                 #第一次進入折畢再提,還原的話是要將未用年限回寫為1
   #                 LET l_faj302=1
   #              ELSE
   #                 LET l_faj302=l_faj302 + 1
   #              END IF
   #           ELSE
   #              LET l_faj302=l_faj302 + 1
   #           END IF
   #        END IF

   #        SELECT MAX(fbn03*100+fbn04) INTO l_ym FROM fbn_file
   #         WHERE fbn01 = g_fbn.fbn01
   #           AND fbn02 = g_fbn.fbn02
   #           AND ((fbn03 = g_yy AND fbn04 < g_mm) OR fbn03 < g_yy)
   #        IF STATUS THEN
   #           LET l_yy2 = ''
   #           LET l_mm2 = ''
   #        ELSE
   #           LET l_yy2 = l_ym[1,4]
   #           LET l_mm2 = l_ym[5,6]
   #        END IF

   #        IF g_faa.faa15 != '4' THEN
   #           UPDATE faj_file
   #              SET faj572  = l_yy2,                  #最近折舊年
   #                  faj5712 = l_mm2,                  #最近折舊月
   #                  faj322  = faj322 - g_fbn.fbn07,   #累折
   #                  faj2032 = faj2032- g_fbn.fbn07,   #本期累折
   #                  faj332  = faj332 + g_fbn.fbn07,   #未折減額
   #                  faj302  = l_faj302,
   #                  faj432  = g_fbn.fbn10             #狀態
   #            WHERE faj02   = g_fbn.fbn01
   #              AND faj022  = g_fbn.fbn02
   #        ELSE
   #           #當最後那個殘月的折舊還原,需還原第一個月未折減額
   #           SELECT faj312,faj332,faj3312,faj262,faj272,faj292
   #             INTO l_faj312,l_faj332,l_faj3312,l_faj262,l_faj272,l_faj292
   #             FROM faj_file
   #            WHERE faj02  = g_fbn.fbn01
   #              AND faj022 = g_fbn.fbn02

   #           LET l_cnt = 0

   #           SELECT COUNT(DISTINCT fbn03||fbn04) INTO l_cnt
   #             FROM fbn_file
   #            WHERE fbn01 = g_fbn.fbn01
   #              AND fbn02 = g_fbn.fbn02
   #           IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   #           #如何判斷此次還原是否為殘月,
   #           #狀態為4或7可能為一般/續提折舊的最後一期,
   #           #再判斷已存在折舊檔折舊次數+1是否等於耐用年限,且入帳日不為1,
   #           #還原時,faj30還是要為0,faj331需寫回
   #           IF (l_faj432 = '7' OR l_faj432 ='4') AND
   #              l_cnt = l_faj292+1 AND DAY(l_faj262) != 1 THEN
   #              #最後那個殘月的折舊還原
   #              UPDATE faj_file
   #                 SET faj572  = l_yy2,                  #最近折舊年
   #                     faj5712 = l_mm2,                  #最近折舊月
   #                     faj322  = faj322 - g_fbn.fbn07,   #累折
   #                     faj2032 = faj2032- g_fbn.fbn07,   #本期累折
   #                     faj3312 = faj3312+ g_fbn.fbn07,   #第一個月未折減額
   #                     faj302  = l_faj302,
   #                     faj432  = g_fbn.fbn10             #狀態
   #               WHERE faj02   = g_fbn.fbn01
   #                 AND faj022  = g_fbn.fbn02
   #           ELSE
   #              IF g_ym = l_faj272 THEN    #第一期攤提還原
   #                 UPDATE faj_file
   #                    SET faj572  = l_yy2,                            #最近折舊年
   #                        faj5712 = l_mm2,                            #最近折舊月
   #                        faj322  = faj322 - g_fbn.fbn07,             #累折
   #                        faj2032 = faj2032- g_fbn.fbn07,             #本期累折
   #                        faj332  = faj332 + g_fbn.fbn07+ l_faj3312,  #未折減額
   #                        faj3312 = 0,                                #第一個月未折減額
   #                        faj302  = l_faj302,
   #                        faj432  = g_fbn.fbn10                       #狀態
   #                  WHERE faj02   = g_fbn.fbn01
   #                    AND faj022  = g_fbn.fbn02
   #              ELSE
   #                 UPDATE faj_file
   #                    SET faj572  = l_yy2,                  #最近折舊年
   #                        faj5712 = l_mm2,                  #最近折舊月
   #                        faj322  = faj322 - g_fbn.fbn07,   #累折
   #                        faj2032 = faj2032- g_fbn.fbn07,   #本期累折
   #                        faj332  = faj332 + g_fbn.fbn07,   #未折減額
   #                        faj302  = l_faj302,
   #                        faj432  = g_fbn.fbn10             #狀態
   #                  WHERE faj02   = g_fbn.fbn01
   #                    AND faj022  = g_fbn.fbn02
   #              END IF
   #           END IF
   #        END IF

   #        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
   #           LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #           LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #           LET g_show_msg[g_cnt2].ze01   = ''
   #           LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
   #           LET g_cnt2 = g_cnt2 + 1
   #           LET g_success='N'
   #           CONTINUE FOREACH
   #        END IF
   #     END IF

   #     #刪除折舊費用各期明細檔--------
   #     DELETE FROM fbn_file WHERE fbn01 = g_fbn.fbn01
   #                            AND fbn02 = g_fbn.fbn02
   #                            AND fbn03 = g_yy
   #                            AND fbn04 = g_mm
   #                            AND fbn041 = '1'
   #     IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
   #        LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
   #        LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
   #        LET g_show_msg[g_cnt2].ze01   = ''
   #        LET g_show_msg[g_cnt2].ze03   = 'del fbn_file'
   #        LET g_cnt2 = g_cnt2 + 1
   #        LET g_success='N'
   #        CONTINUE FOREACH
   #     END IF
   #     IF g_success='Y' THEN
   #        COMMIT WORK
   #     ELSE
   #        ROLLBACK WORK
   #     END IF
   #  END FOREACH
   #END IF
   ##-----No:FUN-AB0088 END-----
   ##-----No:FUN-B60140 Mark END-----
END FUNCTION 
#TQC-780083
