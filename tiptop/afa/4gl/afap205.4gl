# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: afap205.4gl
# Descriptions...: 財簽二固定資產年底結轉作業                    
# Date & Author..: No:FUN-B60140 11/08/23 By xuxz  "財簽二二次改善"追單

DATABASE ds

GLOBALS "../../config/top.global"

 DEFINE g_wc,g_sql	string, 
        g_yy,g_mm	LIKE type_file.num5,     
       b_date,e_date	LIKE type_file.dat,     
       g_dc		LIKE type_file.chr1,    
       g_amt1,g_amt2	LIKE type_file.num20_6, 
       g_foo		RECORD LIKE foo_file.*
DEFINE p_row,p_col      LIKE type_file.num5       
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE l_flag          LIKE type_file.chr1,        
       g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL

   LET g_yy    = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)    #背景作業
   LET g_success = ARG_VAL(3)  

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
         CALL p205()
         IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
            (g_aza.aza02 = '2' AND g_mm = 13)) THEN
            #IF NOT cl_sure(0,0) THEN RETURN END IF  
            IF NOT cl_sure(0,0) THEN EXIT WHILE END IF  
         ELSE
            CALL cl_err(' ','afa-131',1)
            #RETURN  
            EXIT WHILE 
         END IF
         LET g_success = 'Y'
         BEGIN WORK
         CALL p205_1()
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
            CLOSE WINDOW p205_w
            EXIT WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'   
         CALL p205_1()
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

FUNCTION p205()
   DEFINE lc_cmd      LIKE type_file.chr1000  

   LET p_row = 5 LET p_col = 28
   
   OPEN WINDOW p205_w AT p_row,p_col WITH FORM "afa/42f/afap205"
     ATTRIBUTE (STYLE = g_win_style)
   
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   
   CLEAR FORM

   SELECT faa072,faa082 INTO g_yy,g_mm FROM faa_file
   DISPLAY g_yy TO FORMONLY.g_yy 
   
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
         CLOSE WINDOW p205_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
         RETURN
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afap205"

         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap205','9031',1)  
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                       " '",g_yy    CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('afap205',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p205_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      EXIT WHILE

   END WHILE

END FUNCTION

FUNCTION p205_1()
   DEFINE next_yy LIKE type_file.num5    
   #DEFINE l_rowid LIKE type_file.num10  #FUN-B60140xuxz
   #---FUN-B60140---add-----
   DEFINE l_faj RECORD
          faj01  LIKE faj_file.faj01,
          faj02  LIKE faj_file.faj02,
          faj022 LIKE faj_file.faj022
          END RECORD
   #---FUN-B60140---add---end----
   LET next_yy = g_yy + 1

   IF g_bgjob = 'N' THEN 
      MESSAGE "del next year's foo!"
      CALL ui.Interface.refresh()
   END IF

   DELETE FROM foo_file WHERE foo03 = next_yy AND foo04=0 AND foo08 = g_faa.faa02c

   DECLARE p205_eoy_c CURSOR FOR
      SELECT foo01,foo02,foo07,foo08,SUM(foo05d-foo06c)  
        FROM foo_file
       WHERE foo03 = g_yy
         AND foo08 = g_faa.faa02c
       GROUP BY foo07,foo08,foo01,foo02    

   LET g_cnt=1

   LET g_foo.foo03=next_yy

   LET g_foo.foo04=0

   FOREACH p205_eoy_c INTO g_foo.foo01,g_foo.foo02,g_foo.foo07,g_foo.foo08, 
                           g_foo.foo05d

      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) RETURN END IF   
   
      IF g_foo.foo05d < 0 THEN
         LET g_foo.foo06c = -g_foo.foo05d
         LET g_foo.foo05d=0
      ELSE
         LET g_foo.foo06c = 0
      END IF

      LET g_cnt=g_cnt+1

      IF g_bgjob = 'N' THEN  
         MESSAGE "(",g_cnt USING '<<<<<',") ins foo:",g_foo.foo01
         CALL ui.Interface.refresh()
      END IF
   
      IF cl_null(g_foo.foo01) THEN LET g_foo.foo01 = ' ' END IF
      IF cl_null(g_foo.foo02) THEN LET g_foo.foo02 = ' ' END IF
      IF cl_null(g_foo.foo03) THEN LET g_foo.foo03 = 0 END IF
      IF cl_null(g_foo.foo04) THEN LET g_foo.foo04 = 0 END IF
      IF cl_null(g_foo.foo07) THEN LET g_foo.foo07 = ' ' END IF
      IF cl_null(g_foo.foo08) THEN LET g_foo.foo08 = ' ' END IF

      LET g_foo.foolegal =  g_legal
      INSERT INTO foo_file VALUES (g_foo.*)

   END FOREACH

   #-----更新系統參數檔(faa_file.faa07)
   UPDATE faa_file SET faa072 = faa072 + 1, faa082 = 1 
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","faa_file","","",SQLCA.sqlcode,"","upd faa",0)
      RETURN
   END IF

   #-----更新系固定資產(faj_file.faj203/faj204)
   #DECLARE p205_faj_c CURSOR FOR SELECT rowid FROM faj_file WHERE 1= 1 #FUN-B60140 mark 
   DECLARE p205_faj_c CURSOR FOR SELECT faj01,faj02,faj022 FROM faj_file WHERE 1= 1   #FUN-B60140 add

   CALL s_showmsg_init()  

   #FOREACH p205_faj_c INTO l_rowid #FUN-B60140 mark
   FOREACH p205_faj_c INTO l_faj.*  #FUN-B60140 add
      IF SQLCA.sqlcode THEN 
         CALL s_errmsg('','','p205_faj_c',SQLCA.sqlcode,0) 
         LET g_success = 'N'                               
         EXIT FOREACH 
      END IF

      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        

      UPDATE faj_file SET faj2032 = 0,
                          faj2042 = 0 
                   # WHERE rowid = l_rowid  #FUN-B60140 mark
                    #---FUN-B60140---add----
                    WHERE faj01 = l_faj.faj01
                      AND faj02 = l_faj.faj02
                      AND faj022 = l_faj.faj022
                    #---FUN-B60140---add---end----
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         #CALL s_errmsg('rowid',l_rowid,'up faj_file ',SQLCA.sqlcode,1)  #FUN-B60140 mark
         CALL s_errmsg('key',l_faj.faj01 AND l_faj.faj02 AND l_faj.faj022,'up faj_file ',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CONTINUE FOREACH  
      END IF
   END FOREACH  

   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
   
   ERROR ''

END FUNCTION
  #No:FUN-B60140
