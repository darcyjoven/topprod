# Prog. Version..: '5.30.06-13.03.12(00001)'       #
#
# Pattern name...: afap206.4gl
# Descriptions...: 本期銷帳累折重計作業
# Date & Author..: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql       string,  
       g_yy,g_mm        LIKE type_file.num5,        
       b_date,e_date    LIKE type_file.dat,         
       g_a,g_b          LIKE type_file.chr1,        
       g_dc             LIKE type_file.chr1,       
       g_amt1,g_amt2    LIKE type_file.num20_6,   
       g_foo            RECORD LIKE foo_file.*,
       g_faa07,g_faa08  LIKE faa_file.faa07      
DEFINE p_row,p_col      LIKE type_file.num5     
DEFINE l_flag           LIKE type_file.chr1,   
       g_change_lang    LIKE type_file.chr1                 #是否有做語言切換 

DEFINE   g_chr           LIKE type_file.chr1 
DEFINE g_bookno1        LIKE aza_file.aza81  
DEFINE g_bookno2        LIKE aza_file.aza82  
DEFINE g_flag           LIKE type_file.chr1  

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)             #QBE條件
   LET g_yy    = ARG_VAL(2)
   LET g_mm    = ARG_VAL(3)
   LET g_a     = ARG_VAL(4)
   LET g_b     = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)                    #背景作業
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

   IF g_faa.faa31 = 'N' THEN
      CALL cl_err('','afa-260',1)
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

   SET LOCK MODE TO WAIT

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p206()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p206_1()
            CALL s_showmsg() 
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p206_w
               EXIT WHILE
            END IF
         ELSE
          CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p206_1()
         CALL s_showmsg()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p206()
   DEFINE lc_cmd     LIKE type_file.chr1000

   LET p_row = 5 LET p_col = 28

   OPEN WINDOW p206_w AT p_row,p_col WITH FORM "afa/42f/afap206"
        ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('p')

   CLEAR FORM

   SELECT faa072,faa082 INTO g_faa07,g_faa08 FROM faa_file

   LET g_yy=g_faa07  LET g_mm=g_faa08
   LET g_a = 'Y' LET g_b = 'Y' 

   DISPLAY g_yy TO FORMONLY.g_yy 
   DISPLAY g_mm TO FORMONLY.g_mm 
   DISPLAY g_a TO FORMONLY.g_a 
   DISPLAY g_b TO FORMONLY.g_b 

   CALL cl_opmsg('p')

   WHILE TRUE  
      CONSTRUCT BY NAME g_wc ON faj04,faj05,faj02,faj022 

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            LET g_change_lang = TRUE
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
 
         ON ACTION exit         #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
  
         ON ACTION qbe_select
            CALL cl_qbe_select()

      END CONSTRUCT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p206_w
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
         EXIT PROGRAM
      END IF

      IF g_wc = ' 1=1' THEN 
         CALL cl_err('','9046',0) RETURN 
      END IF
      
      LET g_bgjob = "N"    

      INPUT BY NAME g_yy,g_mm,g_a,g_b,g_bgjob WITHOUT DEFAULTS  

         AFTER FIELD g_yy
            IF cl_null(g_yy) THEN
               NEXT FIELD g_yy
            END IF 
            IF g_yy<g_faa07 THEN 
               CALL cl_err(g_faa07,'afa-370',0)
               NEXT FIELD g_yy 
            END IF
         
         AFTER FIELD g_mm
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
            IF cl_null(g_mm) OR g_mm < 1 OR g_mm > 12 THEN 
               NEXT FIELD g_mm
            END IF 
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about       
            CALL cl_about()    
         
         ON ACTION help        
            CALL cl_show_help()
         
         ON ACTION controlg    
            CALL cl_cmdask()   
         
         
         ON ACTION locale   
            LET g_change_lang = TRUE
            EXIT INPUT
         
         ON ACTION exit          #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
         
         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p206_w
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
         EXIT PROGRAM
         RETURN
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afap206"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap206','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_a  CLIPPED,"'",
                         " '",g_b  CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('afap206',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p206_w
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
         EXIT PROGRAM
      END IF

      EXIT WHILE

   END WHILE

END FUNCTION

FUNCTION p206_1()
DEFINE l_faj02  LIKE faj_file.faj02,              
       l_faj022 LIKE faj_file.faj022,
       l_fap02  LIKE fap_file.fap02,              
       l_fap021 LIKE fap_file.fap021,
       l_curr   LIKE fan_file.fan07,
       l_flag   LIKE type_file.chr1,  
       #l_rowid        LIKE type_file.num10      #No.FUN-B60140 mark 
       l_faj01  LIKE faj_file.faj01          #No.FUN-B60140 add
   CALL cl_wait()

   IF g_a = 'Y' THEN  #更新本期累折
      #LET g_sql="SELECT rowid,faj02,faj022 ",   #No.FUN-B60140 mark
      LET g_sql="SELECT faj01,faj02,faj022 ",   #No.FUN-B60140 add
                "  FROM faj_file ",
                " WHERE ",g_wc CLIPPED 
      PREPARE fan_prepare FROM g_sql 
      DECLARE fan_cs  CURSOR WITH HOLD FOR fan_prepare
   
      CALL s_showmsg_init()  

      #FOREACH fan_cs INTO l_rowid,l_faj02,l_faj022   #No.FUN-B60140 mark
      FOREACH fan_cs INTO l_faj01,l_faj02,l_faj022  #No.FUN-B60140 add
         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        

         IF g_bgjob = "N" THEN  
            MESSAGE l_faj02,' ',l_faj022 
            CALL ui.Interface.refresh()
         END IF

         LET l_curr = 0 
         
         SELECT COUNT(*) INTO l_curr FROM fbn_file   #本期累折
          WHERE fbn03= g_yy
            AND fbn04<= g_mm
            AND fbn05 !='3'  #1.單一部門 2.多部門 3.被分攤
         
         IF l_curr =0 THEN CONTINUE FOREACH END IF  
         
         LET l_curr = 0 
         
         SELECT SUM(fbn07) INTO l_curr FROM fan_file   #本期累折
          WHERE fbn01=l_faj02
            AND fbn02=l_faj022 
            AND fbn03= g_yy
            AND fbn04<= g_mm
            AND fbn05 !='3'  #1.單一部門 2.多部門 3.被分攤
         
         IF l_curr IS NULL OR l_curr = ' ' OR l_curr = 0 THEN CONTINUE FOREACH END IF
         
         #UPDATE faj_file SET faj2032 = l_curr WHERE rowid = l_rowid #No.FUN-B60140 mark
         #---#No.FUN-B60140---add----
         UPDATE faj_file SET faj2032 = l_curr
                       WHERE faj01 = l_faj01
                         AND faj02 = l_faj02
                         AND faj022 = l_faj022
         #---#No.FUN-B60140---add---end----
         IF SQLCA.SQLERRD[3] = 0 THEN 
            CALL s_errmsg('key',l_faj01,'upd faj2:',SQLCA.sqlcode,1) 
            LET g_success = 'N'
            CONTINUE FOREACH 
         END IF 

      END FOREACH 

      IF g_totsuccess="N" THEN                                                                                                        
         LET g_success="N"                                                                                                            
      END IF                                                                                                                          

   END IF 

   IF g_b = 'Y' THEN  #更新本期銷帳累折
      CALL s_get_bookno(g_yy)
         RETURNING g_flag,g_bookno1,g_bookno2

      IF g_faa.faa31 = 'Y' THEN   
         CALL s_azmm(g_yy,g_mm,g_plant,g_bookno1) RETURNING g_chr,b_date,e_date
      ELSE
         CALL s_azm(g_yy,g_mm) RETURNING g_chr,b_date,e_date
      END IF

      IF g_chr='1' THEN CALL cl_err('s_azm:error','agl-101',1) RETURN END IF

      LET b_date = MDY(1,1,g_yy)

      LET g_sql="SELECT unique fap02,fap021 FROM fap_file,faj_file ",
                "  WHERE fap03 matches '[456]' ",
                "    AND fap02 = faj02 ",
                "    AND fap021 = faj022 ",
                "   AND ",g_wc CLIPPED 
      PREPARE fap_prepare FROM g_sql 
      DECLARE fap_cs  CURSOR WITH HOLD FOR fap_prepare

      CALL s_showmsg_init()  

      FOREACH fap_cs INTO l_fap02,l_fap021 
         IF g_success='N' THEN                                                                                                         
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                                                                                                                        

         IF g_bgjob = "N" THEN 
            MESSAGE l_fap02,' ',l_fap021 
            CALL ui.Interface.refresh()
         END IF
 
          SELECT SUM(fap572) INTO l_curr FROM fap_file   #本期累折
           WHERE fap02=l_fap02 AND fap021=l_fap021 
             AND (fap04 BETWEEN b_date AND e_date ) 
             AND fap03 MATCHES '[456]' 

          IF l_curr IS NULL OR l_curr = ' ' OR l_curr = 0 THEN CONTINUE FOREACH END IF

          UPDATE faj_file SET faj2042 = l_curr
           WHERE faj02 = l_fap02 
             AND faj022= l_fap021
          IF SQLCA.SQLERRD[3] = 0 THEN 
             CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj2:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             CONTINUE FOREACH 
          END IF 

      END FOREACH 

      IF g_totsuccess="N" THEN                                                                                                        
         LET g_success="N"                                                                                                            
      END IF                                                                                                                          

   END IF 

END FUNCTION
  #No:FUN-B60140
