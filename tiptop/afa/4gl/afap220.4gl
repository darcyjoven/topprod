# Prog. Version..: '5.30.07-13.05.31(00004)'     #
#
# Pattern name...: afap220.4gl
# Descriptions...: 財簽二折舊傳票底稿產生
# Date & Author..: No:FUN-B60140 11/06/30 By Nicola 財簽二二次改善
# Modify.........: No.TQC-BB0087 11/11/09 By Sakura 組條件的g_wc1應改為g_wc
# Modify.........: No:CHI-BC0026 11/12/16 By ck2yuan 清單無上傳，以mail發出
# Modify.........: No.CHI-C60010 12/06/15 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.FUN-D10065 13/01/17 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql       string 
DEFINE tm RECORD
          fbn03    LIKE fbn_file.fbn03,
          fbn04    LIKE fbn_file.fbn04,
          v_no     LIKE npp_file.npp01
       END RECORD
DEFINE g_fbn   RECORD LIKE fbn_file.*
DEFINE g_npp   RECORD LIKE npp_file.*
DEFINE g_npq   RECORD LIKE npq_file.*
DEFINE p_row,p_col      LIKE type_file.num5, 
       l_flag           LIKE type_file.chr1, 
       g_change_lang   LIKE type_file.chr1,  
       ls_date         STRING                
DEFINE g_bookno1        LIKE aza_file.aza81  
DEFINE g_bookno2        LIKE aza_file.aza82  
DEFINE g_flag           LIKE type_file.chr1  
DEFINE g_wc1    string 
DEFINE g_aaa03  LIKE aaa_file.aaa03          

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   LET tm.fbn03 = ARG_VAL(2)
   LET tm.fbn04 = ARG_VAL(3)
   LET tm.v_no  = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

   IF g_faa.faa31 = 'N' THEN
      CALL cl_err('','afa-260',1)
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   SET LOCK MODE TO WAIT

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p220()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p220_process1('1')
            CALL s_showmsg()  
            IF g_success='Y' THEN
               COMMIT WORK
               DROP TABLE p220_tmp1
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               DROP TABLE p220_tmp1 
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p220_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p220_process1('1')  
         CALL s_showmsg()        
         IF g_success = "Y" THEN
            COMMIT WORK
            DROP TABLE p220_tmp1
         ELSE
            ROLLBACK WORK
            DROP TABLE p220_tmp1 
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN

FUNCTION p220()
   DEFINE l_name    LIKE type_file.chr20    
   DEFINE l_cmd     LIKE type_file.chr1000  
   DEFINE l_str     LIKE type_file.chr20    
   DEFINE l_yy      LIKE type_file.chr4     
   DEFINE l_mm      LIKE type_file.chr2     
   DEFINE l_cnt     LIKE type_file.num5,    
          l_max     LIKE type_file.num20,   
          l_aag05   LIKE aag_file.aag05,
          l_date    LIKE type_file.dat      
   DEFINE sr        RECORD
                       order1    LIKE fbn_file.fbn12,   
                       fbn       RECORD LIKE fbn_file.*,
                       faj541     LIKE faj_file.faj541      #累積折舊
                    END RECORD

   DEFINE li_result LIKE type_file.num5     
   DEFINE lc_cmd    LIKE type_file.chr1000 

   DROP TABLE p220_tmp1   

   SELECT 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order1, fbn_file.*, faj541
          ,fbn06 fbn061,fbn06 fbn062,                
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order2 
     FROM fbn_file,faj_file
    WHERE fbn01 = faj02 AND fbn02=faj022
      AND fbn01 = '@@@@@'
     INTO TEMP p220_tmp1

   IF STATUS THEN
      CALL cl_err3("sel","fbn_file,faj_file,","","",STATUS,"","create tmp2201",1)   
   END IF

   DELETE FROM p220_tmp1

   CLEAR FORM

   CALL cl_opmsg('w')

   OPEN WINDOW p220_w AT p_row,p_col WITH FORM "afa/42f/afap220"
        ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()

   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON fbn01,fbn02 

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            LET g_action_choice = "locale"   #MOD-8A0084 mark回復
            LET g_change_lang = TRUE        #->No:FUN-570144
            EXIT CONSTRUCT
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
         
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         
         #No:FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No:FUN-580031 ---end---

      END CONSTRUCT

      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p220_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      CALL cl_opmsg('a')

      SELECT faa072,faa082 INTO tm.fbn03,tm.fbn04 FROM faa_file WHERE faa00='0'

      DISPLAY BY NAME tm.fbn03,tm.fbn04 
      
      LET g_bgjob = "N"

      INPUT BY NAME tm.fbn03,tm.fbn04,tm.v_no,g_bgjob WITHOUT DEFAULTS

         BEFORE INPUT   
            IF cl_null(tm.v_no) THEN 
               LET l_yy = tm.fbn03
               LET l_mm = tm.fbn04 using '&&'
               LET l_str= l_yy,l_mm,'0001'
               LET tm.v_no=l_str 
               #-->check 是否存在
               SELECT COUNT(*) INTO l_cnt FROM npp_file
                WHERE npp01 = tm.v_no AND nppsys = 'FA' and npp00 = 10
                  AND npp011 = 1
                  AND npptype = '1'

               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF

               IF l_cnt > 0 THEN
                  LET l_str = tm.v_no[1,6]
                  SELECT MAX(npp01) INTO l_max FROM npp_file
                   WHERE npp01[1,6] = l_str AND nppsys = 'FA' and npp00 = 10
                     AND npp011 = 1
                     AND npptype = '1'
                  LET l_max = l_max +1
                  LET tm.v_no = l_max
               END IF
               DISPLAY BY NAME tm.v_no 
            END IF
         
         AFTER FIELD v_no   # default value for v_no by yymmxxxx
            IF cl_null(tm.v_no) THEN
               NEXT FIELD FORMONLY.v_no 
            END IF
            #-->check 是否存在
            SELECT COUNT(*) INTO l_cnt FROM npp_file
             WHERE npp01 = tm.v_no AND nppsys = 'FA' and npp00 = 10
               AND npp011 = 1
               AND npptype = '1' 
            IF cl_null(l_cnt) THEN
               LET l_cnt = 0 
            END IF
            IF l_cnt > 0 THEN 
               CALL cl_err(tm.v_no,'afa-368',0)
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
 
         ON ACTION locale
            LET g_change_lang = TRUE               #No:FUN-570144
            EXIT INPUT
   
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
  
         #No:FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 ---end---

      END INPUT
   
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p220_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afap220"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap220','9031',1)  
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",tm.fbn03 CLIPPED,"'",
                         " '",tm.fbn04 CLIPPED,"'",
                         " '",tm.v_no  CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'"
            CALL cl_cmdat('afap220',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p220_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      EXIT WHILE

   END WHILE

END FUNCTION
   
REPORT afap220_rep1(sr,p_npqtype)
   DEFINE p_npqtype  LIKE npq_file.npqtype 
   DEFINE l_last_sw  LIKE type_file.chr1,  
          l_aag05    LIKE aag_file.aag05,
          sr         RECORD
                       order1  LIKE type_file.chr1000, 
                       fbn     RECORD LIKE fbn_file.*,
                       faj541   LIKE faj_file.faj541,        #累積折舊
                       fbn061  LIKE fbn_file.fbn06,        #折舊科目部門 
                       fbn062  LIKE fbn_file.fbn06,        #累折科目部門 
                       order2  LIKE type_file.chr1000                    
                     END RECORD,
          l_faj541   LIKE faj_file.faj541
   DEFINE l_aag44    LIKE aag_file.aag44   #No.FUN-D40118   Add
   DEFINE l_flag     LIKE type_file.chr1   #No.FUN-d40118   Add

   OUTPUT TOP MARGIN g_top_margin
          LEFT MARGIN g_left_margin
          BOTTOM MARGIN g_bottom_margin
          PAGE LENGTH g_page_line
   
   ORDER EXTERNAL BY sr.order2,sr.order1                 
   
   FORMAT
      AFTER GROUP OF sr.order2  #累折科目 
        LET g_npq.npq02=g_npq.npq02+1
        LET g_npq.npq03=sr.faj541   #科目(累積折舊)
        LET g_npq.npq04=NULL
    
        CALL s_get_bookno(tm.fbn03) RETURNING g_flag,g_bookno1,g_bookno2   
        IF g_flag="1" THEN  #抓不到帳套
           CALL cl_err(tm.fbn03,'aoo-081',1)
        END IF
    
        SELECT aag02 INTO g_npq.npq04 FROM aag_file
         WHERE aag01=sr.faj541 AND aag00 = g_faa.faa02c  
    
        IF SQLCA.sqlcode THEN LET g_npq.npq04 = ' ' END IF

        LET g_npq.npq05  = sr.fbn062 
        LET g_npq.npq06  = '2' 
        LET g_npq.npq07f = GROUP SUM(sr.fbn.fbn07)
        LET g_npq.npq07  = g_npq.npq07f 
        LET g_npq.npq08  = ' '   LET g_npq.npq11  = ''  
        LET g_npq.npq12  = ''    LET g_npq.npq13  = ''  
        LET g_npq.npq14  = ''    LET g_npq.npq15  = ' ' 
        LET g_npq.npq21  = ' '    LET g_npq.npq22  = ' ' 
        LET g_npq.npq23  = NULL
       #LET g_npq.npq24  = g_aza.aza17    #CHI-B50013 mark
        LET g_npq.npq24  = g_aaa03        #CHI-B50013
        LET g_npq.npq25  = 1 
        LET g_npq.npqlegal = g_legal   #No:FUN-B60140
        IF g_npq.npq07<>0 THEN     
           #FUN-D10065--add--str--
           CALL s_def_npq3(g_bookno1,g_npq.npq03,g_prog,g_npq.npq01,'','')
           RETURNING g_npq.npq04
           #FUN-D10065--add--end--
          #FUN-D40118 ---Add--- Start
           SELECT aag44 INTO l_aag44 FROM aag_file
            WHERE aag00 = g_faa.faa02c
              AND aag01 = g_npq.npq03
           IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
              CALL s_chk_ahk(g_npq.npq03,g_faa.faa02c) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET g_npq.npq03 = ''
              END IF
           END IF
          #FUN-D40118 ---Add--- End
           INSERT INTO npq_file VALUES(g_npq.*)
           IF g_bgjob = 'N' THEN  
              message  g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
              CALL ui.Interface.refresh()
           END IF
           IF STATUS THEN  
              LET g_success='N' 
           END IF
        END IF 
     
      AFTER GROUP OF sr.order1  #折舊科目
        LET g_npq.npq02=g_npq.npq02+1
        LET g_npq.npq03=sr.fbn.fbn12  #折舊科目 
        LET g_npq.npq04=NULL
        SELECT aag02 INTO g_npq.npq04 FROM aag_file
         WHERE aag01=sr.fbn.fbn12 AND aag00 = g_faa.faa02c 
        IF SQLCA.sqlcode THEN LET g_npq.npq04 = ' ' END IF
        LET g_npq.npq05  = sr.fbn061     #部門  
        LET g_npq.npq06  = '1'         
        LET g_npq.npq07f = GROUP SUM(sr.fbn.fbn07)
        LET g_npq.npq07  = g_npq.npq07f 
        LET g_npq.npq08  = ' '   LET g_npq.npq11  = ''  
        LET g_npq.npq12  = ''    LET g_npq.npq13  = ''  
        LET g_npq.npq14  = ''    LET g_npq.npq15  = ' ' 
        LET g_npq.npq21  = ' '    LET g_npq.npq22  = ' ' 
        LET g_npq.npq23  = NULL
       #LET g_npq.npq24  = g_aza.aza17    #CHI-B50013 mark
        LET g_npq.npq24  = g_aaa03        #CHI-B50013
        LET g_npq.npq25  = 1 
        LET g_npq.npqlegal = g_legal   #No:FUN-B60140
        IF g_npq.npq07<>0 THEN  
           IF g_bgjob = 'N' THEN 
              message  g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
              CALL ui.Interface.refresh()
           END IF
           #FUN-D10065--add--str--
           CALL s_def_npq3(g_bookno1,g_npq.npq03,g_prog,g_npq.npq01,'','')
           RETURNING g_npq.npq04
           #FUN-D10065--add--end--
          #FUN-D40118 ---Add--- Start
           SELECT aag44 INTO l_aag44 FROM aag_file
            WHERE aag00 = g_faa.faa02c
              AND aag01 = g_npq.npq03
           IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
              CALL s_chk_ahk(g_npq.npq03,g_faa.faa02c) RETURNING l_flag
              IF l_flag = 'N'   THEN
                 LET g_npq.npq03 = ''
              END IF
           END IF
          #FUN-D40118 ---Add--- End
           INSERT INTO npq_file VALUES(g_npq.*)
           IF STATUS THEN       
              LET g_success='N'
           END IF
        END IF

END REPORT

FUNCTION p220_process1(p_npptype)
   DEFINE p_npptype LIKE npp_file.npptype  
   DEFINE l_name    LIKE type_file.chr20   
   DEFINE l_cmd     LIKE type_file.chr1000 
   DEFINE l_str     LIKE type_file.chr20   
   DEFINE l_yy      LIKE type_file.chr4    
   DEFINE l_mm      LIKE type_file.chr2    
   DEFINE l_cnt     LIKE type_file.num5,   
          l_max     LIKE type_file.chr20,  
          l_aag05   LIKE aag_file.aag05,
          l_date    LIKE type_file.dat     
   DEFINE sr        RECORD
                       order1    LIKE type_file.chr1000, 
                       fbn       RECORD LIKE fbn_file.*,
                       faj541    LIKE faj_file.faj541,       #累積折舊
                       fbn061    LIKE fbn_file.fbn06,       #折舊科目部門
                       fbn062    LIKE fbn_file.fbn06,       #累折科目部門  
                       order2    LIKE type_file.chr1000                
                    END RECORD
   DEFINE l_flag    LIKE type_file.chr1,
          l_bdate   LIKE type_file.dat, 
          l_edate   LIKE type_file.dat  
   DEFINE l_azi04       LIKE azi_file.azi04 #CHI-C60010 add

   #---->(1-1)insert 單頭
   LET g_npp.npptype = p_npptype
   LET g_npq.npqtype = p_npptype
   LET g_npp.nppsys ='FA'
   LET g_npp.npp00  = 10  
   LET g_npp.npp01  = tm.v_no
   LET g_npp.npp011 = 1

   CALL s_get_bookno(tm.fbn03) RETURNING g_flag,g_bookno1,g_bookno2

   CALL s_azmm(tm.fbn03,tm.fbn04,g_plant,g_faa.faa02c) RETURNING l_flag,l_bdate,l_edate 

  #-CHI-B50013-add-
   SELECT aaa03 INTO g_aaa03 
     FROM aaa_file
    WHERE aaa01 = g_faa.faa02c 
  #-CHI-B50013-end-

   LET g_npp.npp02 = l_edate
   LET g_npp.npp03  = NULL
   LET g_npp.nppglno= NULL

   DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 10
                          AND npp01= tm.v_no AND npp011 = 1
                          AND (nppglno=' ' OR nppglno IS NULL)
                          AND npptype = p_npptype 

   LET g_npp.npplegal = g_legal
   INSERT INTO npp_file VALUES(g_npp.*)

   IF STATUS THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF g_bgjob = 'N' THEN 
      message  g_npp.npp01
      CALL ui.Interface.refresh() 
   END IF

   #---->(1-1)insert 單身
   DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 10
                          AND npq01= tm.v_no AND npq011 = 1
                          AND npqtype = p_npptype 

   IF STATUS THEN LET g_success = 'N' RETURN END IF

   LET g_npq.npqsys ='FA'
   LET g_npq.npq00  = 10
   LET g_npq.npq01  = tm.v_no
   LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0  

   LET g_sql="SELECT '',fbn_file.*,faj541,'','',''",  
             "  FROM fbn_file LEFT OUTER JOIN faj_file ON fbn01=faj02 AND fbn02=faj022 ",
             #" WHERE ",g_wc1 CLIPPED, #No.TQC-BB0087 mark
             " WHERE ",g_wc1 CLIPPED,  #No.TQC-BB0087 add
             "   AND fbn05 IN ('1','3') ",
             "   AND fbn03=",tm.fbn03," AND fbn04=",tm.fbn04,
             "   AND fbn041 = '1'"

   PREPARE p220_prepare1 FROM g_sql
   DECLARE p220_cs1 CURSOR WITH HOLD FOR p220_prepare1
   CALL cl_outnam('afap220') RETURNING l_name
   START REPORT afap220_rep1 TO l_name
   CALL s_showmsg_init()
#CHI-C60010--add--str--#財簽二帳套對應的幣別小數位數
   IF g_faa.faa31='Y' THEN
      SELECT azi04 INTO l_azi04 FROM azi_file,aaa_file
       WHERE azi01=aaa03 AND aaa01=g_faa.faa02c
   END IF
#CHI-C60010--add--end
   FOREACH p220_cs1 INTO sr.*
      IF STATUS THEN 
         CALL s_errmsg('','','p220(foreach):',STATUS,0)
         LET g_success = 'N'   
         EXIT FOREACH
      END IF

      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    

      IF sr.fbn.fbn07 = 0 THEN 
         CONTINUE FOREACH
      END IF

      CALL s_get_bookno(tm.fbn03) RETURNING g_flag,g_bookno1,g_bookno2

      IF g_flag="1" THEN  
         CALL cl_err(tm.fbn03,'aoo-081',1)
      END IF

      LET sr.fbn061 = sr.fbn.fbn06 
      LET sr.fbn062 = sr.fbn.fbn06  

      IF cl_null(sr.faj541) THEN
         LET sr.faj541 = ' '
      END IF

      LET l_aag05 = NULL  
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = sr.fbn.fbn12  
         AND aag00 = g_faa.faa02c   

      IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
      IF l_aag05 = 'Y' THEN     #要作部門管理
         LET sr.order1= sr.fbn.fbn12,sr.fbn061 
      ELSE
         LET sr.order1 = sr.fbn.fbn12
         LET sr.fbn061 = ' '  
      END IF

      LET l_aag05 = NULL
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = sr.faj541
         AND aag00 = g_faa.faa02c 

      IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
      IF l_aag05 = 'Y' THEN     #要作部門管理
         LET sr.order2= sr.faj541,sr.fbn062
      ELSE
         LET sr.order2= sr.faj541
         LET sr.fbn062 = ' '
      END IF
#CHI-C60010--add--str--
      LET sr.fbn.fbn07=cl_digcut(sr.fbn.fbn07,l_azi04) 
      LET sr.fbn.fbn08=cl_digcut(sr.fbn.fbn08,l_azi04)
      LET sr.fbn.fbn14=cl_digcut(sr.fbn.fbn14,l_azi04)
      LET sr.fbn.fbn15=cl_digcut(sr.fbn.fbn15,l_azi04)
      LET sr.fbn.fbn16=cl_digcut(sr.fbn.fbn16,l_azi04)
      LET sr.fbn.fbn17=cl_digcut(sr.fbn.fbn17,l_azi04)
#CHI-C60010--add--end      
      INSERT INTO p220_tmp1 VALUES (sr.order1,sr.fbn.*,sr.faj541,sr.fbn061,sr.fbn062,sr.order2) 
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('','','sr Ins:',STATUS,0) 
      END IF

   END FOREACH

   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 

   DECLARE p220_tmp1cs CURSOR FOR
   SELECT * FROM p220_tmp1 ORDER BY faj541,order1

   FOREACH p220_tmp1cs INTO sr.*
      IF STATUS THEN
         CALL s_errmsg('','','order1:',STATUS,0) 
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT afap220_rep1(sr.*,p_npptype)
   END FOREACH

   FINISH REPORT afap220_rep1
   #LET l_cmd = "chmod 777 ", l_name                           #CHI-BC0026 mark
   LET l_cmd = "chmod 777 $TEMPDIR/", l_name, " 2>/dev/null"   #CHI-BC0026 add
   RUN l_cmd

   DELETE FROM p220_tmp1  

END FUNCTION
  #No:FUN-B60140
