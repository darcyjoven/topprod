# Prog. Version..: '5.30.06-13.04.19(00009)'     #
#
# Pattern name...: cxcp102.4gl
# Descriptions...: 将出货未开票整批产生作业cxcp102
# Date & Author..: 150415 zhouhao


DATABASE ds   

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_aba              RECORD LIKE aba_file.*
DEFINE g_aba_t             RECORD LIKE aba_file.*
DEFINE g_abb               RECORD LIKE abb_file.*
DEFINE g_sql,g_wc,g_wc1,l_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                
DEFINE l_ac,g_cnt          LIKE type_file.num5                
DEFINE tm                  RECORD 
                           yy    LIKE type_file.num5,
                           mm    LIKE type_file.num5
                           END RECORD 
#主程式開始
DEFINE g_flag              LIKE type_file.chr1
DEFINE l_flag              LIKE type_file.chr1
DEFINE l_mm LIKE type_file.num5
DEFINE l_yy LIKE type_file.num5
DEFINE l_dd LIKE type_file.num5
DEFINE g_tc_omb001 LIKE tc_omb_file.tc_omb001
DEFINE g_tc_omb002 LIKE tc_omb_file.tc_omb002
DEFINE g_tc_omb03 LIKE tc_omb_file.tc_omb03
DEFINE g_tc_omb23 LIKE tc_omb_file.tc_omb23
DEFINE g_tc_omb24 LIKE tc_omb_file.tc_omb24
DEFINE g_tc_omb25 LIKE tc_omb_file.tc_omb25
DEFINE g_tc_omb26 LIKE tc_omb_file.tc_omb26
DEFINE g_tc_omb27 LIKE tc_omb_file.tc_omb27
DEFINE g_tc_omb28 LIKE tc_omb_file.tc_omb28
DEFINE li_result    LIKE type_file.num5
DEFINE l_tc_omb003  LIKE tc_omb_file.tc_omb003
DEFINE  g_argv1  LIKE type_file.chr1000
DEFINE g_tc_omb17 LIKE tc_omb_file.tc_omb17  #zhouxm170206 add 
DEFINE g_tc_omb18 LIKE tc_omb_file.tc_omb18  #zhouxm170206 add

 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT       


   LET tm.yy  = ARG_VAL(1)                
   LET tm.mm = ARG_VAL(2)
   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_time = TIME   
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

   WHILE TRUE
      LET g_success = 'Y'
      if not cl_null(tm.mm) and not cl_null(tm.yy) then
      else 
      CALL p102_tm()
      end if 
      IF cl_sure(18,20) THEN 	

        SELECT tc_omb902 INTO l_tc_omb003 FROM tc_omb_file WHERE tc_omb001=tm.yy AND tc_omb002=tm.mm 

        IF l_tc_omb003 IS NOT NULL  THEN 
            CALL cl_err('','cxc-001',1)
         	  EXIT  WHILE
        END IF 

           
         CALL p102_p() 
         
             IF g_success ='Y' THEN
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p102_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p102_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            EXIT  WHILE
         END IF
         CLOSE WINDOW p102_w
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p102_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
DEFINE l_aaaacti      LIKE aaa_file.aaaacti #MOD-C10133
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p102_w AT p_row,p_col WITH FORM "cxc/42f/cxcp102" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR ''
   WHILE TRUE  
   
   DIALOG ATTRIBUTE(UNBUFFERED) 

   INPUT BY NAME  tm.yy,tm.mm      
      
   BEFORE INPUT 


     
     IF cl_null(tm.yy) THEN
       LET tm.yy=year(g_today)
     END IF	 
     IF cl_null(tm.mm) THEN
       LET tm.mm=month(g_today)
     END IF	                  
     DISPLAY BY NAME  tm.yy,tm.mm
     
    AFTER FIELD tm.yy
         IF tm.yy IS not NULL THEN
         	  IF tm.yy<0 or tm.yy>2101 THEN
         	  	 NEXT FIELD tm.yy
         	  END IF
         	END IF  	 
    AFTER FIELD tm.mm
         IF tm.mm IS not NULL THEN
         	  IF tm.mm<1 or tm.mm>12 THEN
         	  	 NEXT FIELD tm.mm
         	  END IF
         	END IF
       
   END INPUT

 
           ON ACTION ACCEPT 
              ACCEPT DIALOG 

           ON ACTION CANCEL 
              LET INT_FLAG = 1
              EXIT DIALOG 

           ON ACTION CLOSE  
              LET INT_FLAG = 1
              EXIT DIALOG 
              
            ON ACTION controlg
                 CALL cl_cmdask()                                        #运行Ctrl+G窗口
           ON ACTION EXIT  
              LET INT_FLAG = 1
              EXIT DIALOG  
              
       END DIALOG

    IF cl_null(g_wc) THEN
      LET g_wc = ' 1=1' 
   END IF  
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CLOSE WINDOW p102_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

   EXIT WHILE  
END WHILE

END FUNCTION




FUNCTION p102_p()

DEFINE l_i LIKE  type_file.num5


  LET g_cnt=1
  
   BEGIN WORK 
   
      INITIALIZE g_aba.* TO NULL
      CALL p102_ins_aba()
      
    LET l_sql = " SELECT  tc_omb001,tc_omb002,tc_omb03,tc_omb23,sum(tc_omb24),tc_omb25,sum(tc_omb26),tc_omb27,sum(tc_omb28),tc_omb17,tc_omb18 ", #zhouxm170206 add ,tc_omb17,tc_omb18
                " FROM tc_omb_file ",
                " GROUP BY  tc_omb001,tc_omb002,tc_omb03,tc_omb23,tc_omb25,tc_omb27,tc_omb17,tc_omb18 ", #zhouxm170206 add ,tc_omb17,tc_omb18
                " HAVING  tc_omb001=",tm.yy CLIPPED ," and tc_omb002= ",tm.mm CLIPPED 
   #str------ add by dengsy170212
   LET l_sql = " SELECT  tc_omb001,tc_omb002,tc_omb903,sum(tc_omb909),tc_omb904,sum(tc_omb909),tc_omb17,tc_omb18 ", #zhouxm170206 add ,tc_omb17,tc_omb18
                " FROM tc_omb_file ",
                " GROUP BY  tc_omb001,tc_omb002,tc_omb903,tc_omb904,tc_omb17,tc_omb18 ", #zhouxm170206 add ,tc_omb17,tc_omb18
                " HAVING  tc_omb001=",tm.yy CLIPPED ," and tc_omb002= ",tm.mm CLIPPED
   #end------ add by dengsy170212
   PREPARE p102_p1 FROM l_sql
   DECLARE p102_c1 CURSOR FOR p102_p1
   FOREACH p102_c1 INTO g_tc_omb001,g_tc_omb002,g_tc_omb23,g_tc_omb24,g_tc_omb25,g_tc_omb26,g_tc_omb17,g_tc_omb18#zhouxm170206 add ,tc_omb17,tc_omb18
      IF g_tc_omb28=0 THEN CONTINUE FOREACH END IF #zhouxm170206 add 
      INITIALIZE g_abb.* TO NULL
      
      CALL p102_ins_abb()
      
   END FOREACH
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
      
      UPDATE tc_omb_file SET tc_omb902=g_aba.aba01 
      WHERE tc_omb001=tm.yy AND tc_omb002=tm.mm

     
   END IF 
END FUNCTION 


FUNCTION p102_ins_aba()

DEFINE l_flag     LIKE type_file.chr1
DEFINE l_d1,l_d2  LIKE type_file.dat
DEFINE l_aba01    LIKE aba_file.aba01
DEFINE g_bookno  LIKE aaa_file.aaa01   #帳別

   CALL s_shwact(3,2,g_bookno)

   CALL s_azm(tm.yy,tm.mm) returning l_flag,l_d1,l_d2

   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz.aaz64
      LET g_aba.aba00 = g_aaz.aaz64      
   END IF
   
   LET g_aba.aba02=l_d2
   LET g_aba.aba03=tm.yy
   LET g_aba.aba04=tm.mm
   LET g_aba.aba05=g_today
   LET g_aba.aba06='GL'
   LET g_aba.aba08 = 0
   LET g_aba.aba09 = 0
   LET g_aba.aba18  ='0'
   LET g_aba.aba19  ='N'
   LET g_aba.aba20 = 0
   LET g_aba.aba24=g_user
   LET g_aba.aba35 = 'N'
   LET g_aba.abauser=g_user
   LET  g_aba.abaacti='Y'   
   LET g_aba.abasseq = 0
   LET g_aba.abapost = 'N'
   LET g_aba.abaprno = 0
   LET g_aba.abauser=g_user
   LET g_aba.abaoriu = g_user 
   LET g_aba.abaorig = g_grup 
   LET g_aba.abagrup=g_grup
   LET g_aba.abadate=g_today
   LET g_aba.abaacti='Y'           
   LET g_aba.abalegal=g_legal   

   
   SELECT UNIQUE  ooygslp INTO g_aba.aba01 FROM ooy_file WHERE ooygslp IS NOT NULL 

   CALL s_check_no("agl",g_aba.aba01,g_aba_t.aba01,"*","aba_file", "aba01",g_aba.aba00)   #No.MOD-C30079
            RETURNING li_result,g_aba.aba01
            
   CALL s_get_first_missingno(g_plant,g_dbs,g_bookno,g_aba.aba01,g_aba.aba02,1)  RETURNING l_aba01     

     IF NOT cl_null(l_aba01) THEN
       LET g_aba.aba01 = l_aba01
     END IF

    CALL s_auto_assign_no("agl",g_aba.aba01,g_aba.aba02,"","aba_file","aba01",g_plant,"",g_bookno) #FUN-980094  #MOD-AC0242
           RETURNING li_result,g_aba.aba01
           

     INSERT INTO aba_file VALUES g_aba.*

END FUNCTION 


FUNCTION p102_ins_abb()

   LET g_tc_omb17='RMB'
   LET g_tc_omb18=1

   LET g_abb.abb04='销售出货未开票成本'
   LET g_abb.abb00=g_aba.aba00
   LET g_abb.abb01=g_aba.aba01
   LET g_abb.abb02=g_cnt
   LET g_abb.abb03=g_tc_omb25
   LET g_abb.abb06='2'
   LET g_abb.abb07f=g_tc_omb26
   LET g_abb.abb07=g_tc_omb26*g_tc_omb18  
   LET g_abb.abb24=g_tc_omb17
   LET g_abb.abb25=g_tc_omb18
   #zhouxm170206 add end 
   LET g_abb.abblegal=g_aba.abalegal
################maoyy20170109
 
    IF g_abb.abb07<>'0'  THEN 
        
   
    
################maoyy20170109
   #tianry add 170114 
   IF  g_abb.abb03[1,4]='6001'  THEN LET g_abb.abb11='' END IF
   IF  g_abb.abb03[1,6] =  '222101'  THEN LET g_abb.abb11='' END IF
   #tianry add end 

   #str------- add by dengsy170207
   LET g_abb.abb07=cl_digcut(g_abb.abb07,2)
   LET g_abb.abb07f=cl_digcut(g_abb.abb07f,2)
   #end------- add by dengsy170207
  INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb06,
                        abb07,abb07f,abb11,abb24,abb25,abblegal )
      VALUES(g_abb.abb00,g_abb.abb01,g_abb.abb02,g_abb.abb03,g_abb.abb04,g_abb.abb06,
             g_abb.abb07,g_abb.abb07f,g_abb.abb11,g_abb.abb24,g_abb.abb25,g_abb.abblegal)
################maoyy20170109
     LET g_cnt=g_cnt+1
    END IF 
################maoyy20170109   
#贷方未税
   INITIALIZE g_abb.* TO NULL
   

   LET g_abb.abb04='销售出货未开票成本'
   LET g_abb.abb00=g_aba.aba00
   LET g_abb.abb01=g_aba.aba01
   LET g_abb.abb02=g_cnt
   LET g_abb.abb03=g_tc_omb23
   LET g_abb.abb06='1'
   LET g_abb.abb07f=g_tc_omb24
   LET g_abb.abb07=g_tc_omb24*g_tc_omb18
   LET g_abb.abb24=g_tc_omb17
   LET g_abb.abb25=g_tc_omb18
   LET g_abb.abblegal=g_aba.abalegal
################maoyy20170109
 
    IF g_abb.abb07<>'0'  THEN 
        
   
 
################maoyy20170109

  #tianry add 
  IF  g_abb.abb03[1,4]='6001'  THEN LET g_abb.abb11='' END IF
   IF  g_abb.abb03[1,6] =  '222101'  THEN LET g_abb.abb11='' END IF

   #tianry add end 
   #str------- add by dengsy170207
   LET g_abb.abb07=cl_digcut(g_abb.abb07,2)
   LET g_abb.abb07f=cl_digcut(g_abb.abb07f,2)
   #end------- add by dengsy170207
   INSERT INTO abb_file(abb00,abb01,abb02,abb03,abb04,abb06,
                        abb07,abb07f,abb11,abb24,abb25,abblegal )
      VALUES(g_abb.abb00,g_abb.abb01,g_abb.abb02,g_abb.abb03,g_abb.abb04,g_abb.abb06,
             g_abb.abb07,g_abb.abb07f,g_abb.abb11,g_abb.abb24,g_abb.abb25,g_abb.abblegal)
################maoyy20170109
    LET g_cnt=g_cnt+1
  END IF 
   
 
################maoyy20170109
   
   INITIALIZE g_abb.* TO NULL
   


END FUNCTION   


FUNCTION p102_del()

DELETE FROM tc_omb_file WHERE tc_omb001=tm.yy AND tc_omb002=tm.mm 

END FUNCTION
