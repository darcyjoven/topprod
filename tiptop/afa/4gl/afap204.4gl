# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: afap204.4gl
# Descriptions...: 財簽二固定資產月底結轉作業                    
# Date & Author..: No:FUN-B60140 11/08/23 By xuxz "財簽二二次改善"追單

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql       string, 
       g_yy,g_mm        LIKE type_file.num5,         
       b_date,e_date    LIKE type_file.dat,         
       g_dc             LIKE type_file.chr1,       
       g_amt1,g_amt2    LIKE type_file.num20_6,  
       g_foo            RECORD LIKE foo_file.*
DEFINE p_row,p_col      LIKE type_file.num5     
DEFINE g_chr            LIKE type_file.chr1     
DEFINE g_cnt            LIKE type_file.num10    
DEFINE l_flag           LIKE type_file.chr1,            
       g_change_lang    LIKE type_file.chr1                 #是否有做語言切換 
DEFINE l_cmd            LIKE type_file.chr1000           

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)
   LET g_mm    = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)                    #背景作業
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
         CALL p204()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p204_1('1')
            CALL s_showmsg()         
            IF g_success = 'Y' THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
            IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
               (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
               LET l_cmd = ''
               IF cl_confirm('axr-240') THEN
                  LET l_cmd = " afap205 '",g_yy,"' 'Y' '",g_success,"' "  
                  CALL cl_cmdrun_wait(l_cmd)  
               END IF
            END IF
            IF g_success = 'Y' THEN
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p204_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL p204_1('1')
         CALL s_showmsg()         
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         LET l_cmd=''
         IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
             (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
             LET l_cmd = " afap205 '",g_yy,"' 'Y' '",g_success,"' " 
             CALL cl_cmdrun_wait(l_cmd) 
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 

END MAIN

FUNCTION p204()
   DEFINE lc_cmd        LIKE type_file.chr1000        
 
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p204_w AT p_row,p_col WITH FORM "afa/42f/afap204"
    ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
 
   CLEAR FORM
 
   SELECT faa072,faa082 INTO g_yy,g_mm FROM faa_file
   DISPLAY g_yy TO FORMONLY.g_yy 
   DISPLAY g_mm TO FORMONLY.g_mm 

   IF g_mm+1 >12 THEN
      DISPLAY g_yy+1 TO FORMONLY.g_yy2
      DISPLAY 1 TO FORMONLY.g_mm2
   ELSE
      DISPLAY g_yy TO FORMONLY.g_yy2
      DISPLAY g_mm+1 TO FORMONLY.g_mm2
   END IF
 
   LET g_bgjob = "N"

   WHILE TRUE
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
            LET g_change_lang = TRUE
            EXIT INPUT
   
      END INPUT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
   
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p204_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
         RETURN
      END IF
   
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afap204"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap204','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('afap204',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p204_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      EXIT WHILE

   END WHILE

END FUNCTION

FUNCTION p204_1(l_npptype) 
   DEFINE l_npptype LIKE npp_file.npptype  

   CALL s_azmm(g_yy,g_mm,g_faa.faa02p,g_faa.faa02c) RETURNING g_chr,b_date,e_date

   IF g_chr='1' THEN 
      CALL cl_err('s_azm:error','agl-101',1) RETURN 
   END IF

   IF g_bgjob= 'N' THEN      
      MESSAGE "del foo!"
      CALL ui.Interface.refresh()
   END IF

   DELETE FROM foo_file WHERE foo03=g_yy AND foo04=g_mm
                          AND foo08=g_faa.faa02c

   IF STATUS THEN 
      CALL cl_err3("del","foo_file",g_yy,g_mm,STATUS,"","del foo:",1) 
      LET g_success = 'N'               
      RETURN 
   END IF

   IF g_bgjob= 'N' THEN      
      MESSAGE SQLCA.SQLERRD[3],' Rows deleted!'
      CALL ui.Interface.refresh()
   END IF

   DECLARE p204_cs CURSOR WITH HOLD FOR
           SELECT npq03,npq05,npq06,SUM(npq07),npp06,npp07 
             FROM npp_file,npq_file
            WHERE nppsys= npqsys
              AND npptype=l_npptype  
              AND npqsys= 'FA'
              AND npp00 = npq00 
              AND npp01 = npq01
              AND npp011= npq011
              AND npp02 BETWEEN b_date AND e_date
              AND npptype = npqtype 
            GROUP BY npq03,npq05,npq06,npp06,npp07

   LET g_foo.foo03=g_yy
   LET g_foo.foo04=g_mm
   LET g_cnt=0

   CALL s_showmsg_init()  

   FOREACH p204_cs INTO g_foo.foo01,g_foo.foo02,g_dc,g_amt1,g_foo.foo07,g_foo.foo08  
      IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,0)
         LET g_success = 'N'
         RETURN 
      END IF
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        

      LET g_cnt=g_cnt+1
      IF g_bgjob = 'N' THEN 
         MESSAGE "(",g_cnt USING '<<<<<',") fetch npq:",g_foo.foo01
         CALL ui.Interface.refresh()
      END IF

      IF g_dc = '1' THEN
         LET g_foo.foo05d=g_amt1 LET g_foo.foo06c=0
      ELSE
         LET g_foo.foo05d=0      LET g_foo.foo06c=g_amt1
      END IF

      LET g_foo.foo08 = g_faa.faa02c
      IF cl_null(g_foo.foo08) THEN
         LET g_foo.foo08 = g_faa.faa02c
      END IF

      IF cl_null(g_foo.foo07) THEN
         LET g_foo.foo07 = g_faa.faa02p
      END IF

      IF cl_null(g_foo.foo01) THEN LET g_foo.foo01 = ' ' END IF
      IF cl_null(g_foo.foo02) THEN LET g_foo.foo02 = ' ' END IF
      IF cl_null(g_foo.foo03) THEN LET g_foo.foo03 = 0 END IF
      IF cl_null(g_foo.foo04) THEN LET g_foo.foo04 = 0 END IF
      IF cl_null(g_foo.foo07) THEN LET g_foo.foo07 = ' ' END IF
      IF cl_null(g_foo.foo08) THEN LET g_foo.foo08 = ' ' END IF

      LET g_foo.foolegal = g_legal
      INSERT INTO foo_file VALUES(g_foo.*)
      IF STATUS AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN  
         LET g_showmsg = g_foo.foo01,"/",g_foo.foo02,"/",g_foo.foo03,"/",g_foo.foo04 
         CALL s_errmsg('foo01,foo02,foo03,foo04',g_showmsg,'ins foo:',STATUS,1)   
         LET g_success = 'N' 
         CONTINUE FOREACH 
      END IF

      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   
         UPDATE foo_file SET foo05d=foo05d+g_foo.foo05d,
                             foo06c=foo06c+g_foo.foo06c
          WHERE foo01=g_foo.foo01
            AND foo02=g_foo.foo02
            AND foo03=g_foo.foo03
            AND foo04=g_foo.foo04
            AND foo08=g_foo.foo08 
         IF STATUS AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN  
            LET g_showmsg = g_foo.foo01,"/",g_foo.foo02,"/",g_foo.foo03,"/",g_foo.foo04  
            CALL s_errmsg('foo01,foo02,foo03,foo04',g_showmsg,'upd foo:',STATUS,1)  
            LET g_success = 'N'     
            CONTINUE FOREACH 
         END IF
      END IF
   END FOREACH

   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          

   #-----更新系統參數檔----------
   IF NOT ((g_aza.aza02 = '1' AND g_mm = 12) OR
       (g_aza.aza02 = '2' AND g_mm = 13)) THEN
      UPDATE faa_file SET faa082 = faa082 + 1  #將現行期別加1
      IF l_npptype = '0' AND (SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0) THEN
         CALL cl_err3("upd","faa_file","","",SQLCA.SQLCODE,"","upd faa",0)
         CALL s_errmsg('faa082','','upd faa:',SQLCA.SQLCODE,1)  
         LET g_success = 'N'                   #FUN-570144
         RETURN        
      END IF
   END IF 

   ERROR ''

END FUNCTION
  #No:FUN-B60140
