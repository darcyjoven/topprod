# Prog. Version..: '5.30.06-13.03.12(00007)'     #
# Pattern name...: afap030.4gl
# Desc/riptions...: 稅簽/財簽二基本資料預設作業
# Date & Author..: 12/01/12 FUN-BB0093 By Sakura
# Modify.........: No:FUN-BB0122 12/01/12 By Sakura faa02c-->g_faa.faa02c
# Modify.........: No:FUN-BB0131 12/01/12 By Sakura 執行預設財一資料時，僅抓取財一狀態不為5.6之資料
# Modify.........: No:FUN-BB0163 12/01/12 By Sakura 金額計算改用除的(除匯率)
# Modify.........: No:FUN-BC0014 12/01/12 By Sakura 財二會科預計為財一
# Modify.........: No:TQC-C20062 12/02/09 By Sakura 修改匯率屬性為number(20,10)
# Modify.........: No:TQC-C50152 12/05/17 By xuxz 財簽二根據幣別取位

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql       STRING
DEFINE tm      RECORD
       wc      STRING,      
       a       LIKE type_file.chr1,    # 1.稅簽、2.財簽二
       #rate    LIKE type_file.num5,    # 匯率 #No:TQC-C20062 mark  
       rate    LIKE azj_file.azj03,    # 匯率  #No:TQC-C20062 add       
       b       LIKE type_file.chr1,    # 1.與財一資料同、2.自定年限
       year    LIKE type_file.num5     # 耐用年限
       END RECORD
DEFINE p_row,p_col     LIKE type_file.num5,
       g_change_lang   LIKE type_file.chr1
DEFINE g_flag          LIKE type_file.chr1
DEFINE g_i      LIKE type_file.num5
DEFINE g_azi04_1  LIKE azi_file.azi04 #TQC-C50152 add#用於根據財簽二的幣別抓取小數位數

MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   LET tm.a     = ARG_VAL(2)
   LET tm.rate  = ARG_VAL(3)
   LET tm.b     = ARG_VAL(4)
   LET tm.year  = ARG_VAL(5)
   LET g_bgjob  = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN  #背景作業
      LET g_bgjob= "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   SET LOCK MODE TO WAIT
   IF g_bgjob ='N' THEN
      INITIALIZE tm.* TO NULL
   END IF

   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p030()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p030_1()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p030_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p030_1()
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

FUNCTION p030()
   DEFINE lc_cmd   LIKE type_file.chr1000

   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p030_w AT p_row,p_col WITH FORM "afa/42f/afap030"
     ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('u')

   CLEAR FORM
   
   INITIALIZE tm.* TO NULL
   IF g_faa.faa31 = 'N' THEN 
      LET tm.a = '1'
      CALL p030_set_no_entry()
   ELSE 
      LET tm.a = '1'   
   END IF
   LET tm.rate = 1
   LET tm.b    = '1'
   
   WHILE TRUE
      CALL cl_opmsg('u')
      CONSTRUCT BY NAME tm.wc ON faj04,faj93,faj02

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

      ON ACTION controlp
         CASE
            WHEN INFIELD(faj02)   #財產編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_faj"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faj02
               NEXT FIELD faj02
         END CASE            

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
     
         ON ACTION EXIT
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

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
         LET INT_FLAG=0
         CLOSE WINDOW p030_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF tm.wc = " 1=1" THEN
         CALL cl_err("","abm-997",1)
         CONTINUE WHILE
      END IF

      LET g_bgjob ='N'

      INPUT BY NAME tm.a,tm.rate,tm.b,tm.year,g_bgjob WITHOUT DEFAULTS  

         BEFORE FIELD a
            IF g_faa.faa31 = 'N' THEN
               LET tm.a = '1'
               NEXT FIELD b
            END IF         

         AFTER FIELD a
            IF cl_null(tm.a) THEN
               NEXT FIELD a
            END IF
            IF tm.a = '2' THEN
               CALL p030_set_entry()
            ELSE 
               CALL p030_set_no_entry()            
            END IF  
      
         AFTER FIELD rate
            IF tm.rate <= 0 THEN
               CALL cl_err(' ','axm-987',0)
               NEXT FIELD rate
            END IF
            IF cl_null(tm.rate) THEN
               NEXT FIELD rate
            END IF
         AFTER FIELD b
            IF cl_null(tm.b) THEN
               NEXT FIELD b
            END IF
            IF tm.b = '2' THEN 
               CALL p030_set_entry()
            ELSE
               CALL p030_set_no_entry()                           
            END IF

         AFTER FIELD year
            IF tm.year <= 0 THEN
               CALL cl_err(' ','aap-022',0)
               NEXT FIELD year
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
      
         ON ACTION EXIT
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION qbe_save
            CALL cl_qbe_save()

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
         CLOSE WINDOW p030_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap030'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap030','9031',1)
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.rate CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.year CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('afap030',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p030_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION p030_set_entry()
    IF tm.a = '2' THEN
       CALL cl_set_comp_entry("rate",TRUE)
    END IF
    IF tm.b = '2' THEN
       CALL cl_set_comp_entry("year",TRUE)
    END IF 
END FUNCTION

FUNCTION p030_set_no_entry()
   IF tm.a = '1' THEN
      CALL cl_set_comp_entry("rate",FALSE)
      LET tm.rate = 1
   END IF
   IF tm.b = '1' THEN
      CALL cl_set_comp_entry("year",FALSE) 
   END IF
   IF g_faa.faa31 = 'N' THEN
      CALL cl_set_comp_entry("a",FALSE)
   END IF
END FUNCTION

FUNCTION p030_1()
 DEFINE l_faj     RECORD LIKE faj_file.*,
        l_sql     STRING,   
        l_cnt     LIKE type_file.num5,
        i         LIKE type_file.num5     

   LET g_success = 'Y'

   #LET l_sql ="SELECT * FROM faj_file WHERE ",tm.wc CLIPPED #FUN-BB0131 mark
   LET l_sql ="SELECT * FROM faj_file WHERE faj43 NOT IN ('5','6') AND ",tm.wc CLIPPED #FUN-BB0131 add 

   PREPARE p030_pre FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF   
   DECLARE p030_cur CURSOR FOR p030_pre
 
   CALL s_showmsg_init() 
   LET i = 0
   LET g_i = 0
 
   FOREACH p030_cur INTO l_faj.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF

     LET l_cnt = 0
     
     SELECT COUNT(*) INTO l_cnt
       FROM faj_file
      WHERE faj01 = l_faj.faj01
        AND faj02 = l_faj.faj02
        AND faj022 = l_faj.faj022

     IF l_cnt > 0 THEN
        CALL p030_ins_faj(l_faj.*)
        IF g_success = "Y" THEN
        END IF        
     ELSE
        LET g_showmsg=l_faj.faj01,"/",l_faj.faj02,"/",l_faj.faj022   
        CALL s_errmsg("faj01,faj02,faj022",g_showmsg,"SEL faj_file","aps-043",1)
        CONTINUE FOREACH
     END IF

   END FOREACH

   IF g_totsuccess="N" THEN                                                                                                       
      LET g_success="N"                                                                                                           
   END IF                                      

   CALL s_showmsg()                                                                                   

   ##FUN-BB0131-----being mark
   #IF g_success = 'Y' THEN
   #   COMMIT WORK
   #   CALL cl_err(g_i,'anm-905',1)
   #ELSE
   #   ROLLBACK WORK
   #END IF
   ##FUN-BB0131-----end mark
   
END FUNCTION

FUNCTION p030_ins_faj(l_faj)
   DEFINE l_faj    RECORD LIKE faj_file.*
   DEFINE l_faj143 LIKE faj_file.faj143   
   
   WHENEVER ERROR CONTINUE 

      IF tm.a = '1' THEN #稅簽
         IF NOT cl_null(l_faj.faj201) THEN 
            IF l_faj.faj201 NOT MATCHES '[01]' THEN
               RETURN
            END IF    
         END IF

         LET l_faj.faj201 = '1'
         LET l_faj.faj62  = l_faj.faj14
         LET l_faj.faj109 = l_faj.faj108
         LET l_faj.faj103 = l_faj.faj101
         LET l_faj.faj104 = l_faj.faj102
         LET l_faj.faj110 = l_faj.faj106
         LET l_faj.faj71  = l_faj.faj34
         LET l_faj.faj72  = l_faj.faj35
         LET l_faj.faj73  = l_faj.faj36
         LET l_faj.faj61  = l_faj.faj28

         IF tm.b = '1' THEN #資料預設
            LET l_faj.faj64  = l_faj.faj29
            LET l_faj.faj65  = l_faj.faj30
         ELSE 
            LET l_faj.faj64  = tm.year
            LET l_faj.faj65  = tm.year-l_faj.faj29+l_faj.faj30
            IF l_faj.faj65 <= 0 THEN
               LET l_faj.faj65 = 0 
            END IF 
         END IF

         LET l_faj.faj66  = l_faj.faj31
         LET l_faj.faj67  = l_faj.faj32
         LET l_faj.faj205 = l_faj.faj203
         LET l_faj.faj74  = l_faj.faj57
         LET l_faj.faj741 = l_faj.faj571
         LET l_faj.faj68  = l_faj.faj33
         LET l_faj.faj63  = l_faj.faj141
         LET l_faj.faj69  = l_faj.faj59
         LET l_faj.faj70  = l_faj.faj60
         LET l_faj.faj204 = l_faj.faj206
         LET l_faj.faj111 = l_faj.faj107

         UPDATE faj_file SET faj_file.* = l_faj.*    # 更新DB
           WHERE faj01 = l_faj.faj01
            AND  faj02 = l_faj.faj02
            AND  faj022 = l_faj.faj022
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            LET g_showmsg=l_faj.faj01,"/",l_faj.faj02,"/",l_faj.faj02   
            CALL s_errmsg("faj01,faj02,faj022",g_showmsg,"UPDATE faj_file",SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE 
            LET g_i = g_i + 1
         END IF
         
      ELSE #財簽二
         IF NOT cl_null(l_faj.faj432) THEN
            IF l_faj.faj432 NOT MATCHES '[01]' THEN
               RETURN
            END IF
         END IF
         LET l_faj.faj432  = '1'
         SELECT aaa03 INTO l_faj143 FROM aaa_file  WHERE aaa01 = g_faa.faa02c #FUN-BB0122 faa02c-->g_faa.faa02c
         LET l_faj.faj143  = l_faj143
         IF cl_null(tm.rate) THEN LET tm.rate = 1 END IF #FUN-BB0163 add
         LET l_faj.faj144  = tm.rate
         ##FUN-BB0163-----being mark
         #LET l_faj.faj142  = l_faj.faj14 * tm.rate
         #LET l_faj.faj1012 = l_faj.faj101 * tm.rate
         #LET l_faj.faj1022 = l_faj.faj102 * tm.rate
         ##FUN-BB0163-----end mark
         LET l_faj.faj142  = l_faj.faj14 / tm.rate   #FUN-BB0163 add
         LET l_faj.faj1012 = l_faj.faj101 / tm.rate  #FUN-BB0163 add         
         LET l_faj.faj1022 = l_faj.faj102 / tm.rate  #FUN-BB0163 add
         LET l_faj.faj1062 = l_faj.faj106
         LET l_faj.faj1072 = l_faj.faj107
         LET l_faj.faj232  = l_faj.faj23
         LET l_faj.faj242  = l_faj.faj24
         LET l_faj.faj262  = l_faj.faj26
         LET l_faj.faj272  = l_faj.faj27
         LET l_faj.faj342  = l_faj.faj34
         #LET l_faj.faj352  = l_faj.faj35 * tm.rate #FUN-BB0163 mark
         LET l_faj.faj352  = l_faj.faj35 / tm.rate  #FUN-BB0163 add
         LET l_faj.faj362  = l_faj.faj36
         LET l_faj.faj282  = l_faj.faj28         

         IF tm.b = '1' THEN #資料預設
            LET l_faj.faj292  = l_faj.faj29
            LET l_faj.faj302  = l_faj.faj30
         ELSE 
            LET l_faj.faj292  = tm.year
            LET l_faj.faj302  = tm.year-l_faj.faj29+l_faj.faj30
            IF l_faj.faj302 <= 0 THEN
               LET l_faj.faj302 = 0 
            END IF 
         END IF

         ##FUN-BB0163-----being mark  
         #LET l_faj.faj312  = l_faj.faj31  * tm.rate
         #LET l_faj.faj322  = l_faj.faj32  * tm.rate
         #LET l_faj.faj2032 = l_faj.faj203 * tm.rate
         #LET l_faj.faj332  = l_faj.faj33  * tm.rate
         ##FUN-BB0163-----end mark
         LET l_faj.faj312  = l_faj.faj31  / tm.rate #FUN-BB0163 add
         LET l_faj.faj322  = l_faj.faj32  / tm.rate #FUN-BB0163 add
         LET l_faj.faj2032 = l_faj.faj203 / tm.rate #FUN-BB0163 add
         LET l_faj.faj332  = l_faj.faj33  / tm.rate #FUN-BB0163 add         
         LET l_faj.faj572  = l_faj.faj57
         LET l_faj.faj5712 = l_faj.faj571
         #LET l_faj.faj1412 = l_faj.faj141 * tm.rate #FUN-BB0163 mark
         LET l_faj.faj1412 = l_faj.faj141 / tm.rate #FUN-BB0163 add
         LET l_faj.faj582  = l_faj.faj58
         ##FUN-BB0163-----being mark         
         #LET l_faj.faj592  = l_faj.faj59  * tm.rate
         #LET l_faj.faj602  = l_faj.faj60  * tm.rate
         #LET l_faj.faj2042 = l_faj.faj204 * tm.rate
         #LET l_faj.faj1082 = l_faj.faj108 * tm.rate
         ##FUN-BB0163-----end mark         
         LET l_faj.faj592  = l_faj.faj59  / tm.rate #FUN-BB0163 add
         LET l_faj.faj602  = l_faj.faj60  / tm.rate #FUN-BB0163 add
         LET l_faj.faj2042 = l_faj.faj204 / tm.rate #FUN-BB0163 add
         LET l_faj.faj1082 = l_faj.faj108 / tm.rate #FUN-BB0163 add        
         #-----No:FUN-BC0014-----
         LET l_faj.faj531 = l_faj.faj53
         LET l_faj.faj541 = l_faj.faj54
         LET l_faj.faj551 = l_faj.faj55
         #-----No:FUN-BC0014 END-----

         IF cl_null(l_faj.faj1012) THEN LET l_faj.faj1012 = 0   END IF
         IF cl_null(l_faj.faj1022) THEN LET l_faj.faj1022 = 0   END IF
         IF cl_null(l_faj.faj1062) THEN LET l_faj.faj1062 = 0   END IF
         IF cl_null(l_faj.faj1072) THEN LET l_faj.faj1072 = 0   END IF
         IF cl_null(l_faj.faj1082) THEN LET l_faj.faj1082 = 0   END IF
         IF cl_null(l_faj.faj1412) THEN LET l_faj.faj1412 = 0   END IF
         IF cl_null(l_faj.faj142)  THEN LET l_faj.faj142  = 0   END IF
         IF cl_null(l_faj.faj2032) THEN LET l_faj.faj2032 = 0   END IF
         IF cl_null(l_faj.faj2042) THEN LET l_faj.faj2042 = 0   END IF
         IF cl_null(l_faj.faj232)  THEN LET l_faj.faj232  = ' ' END IF
         IF cl_null(l_faj.faj282)  THEN LET l_faj.faj282  = ' ' END IF
         IF cl_null(l_faj.faj312)  THEN LET l_faj.faj312  = 0   END IF
         IF cl_null(l_faj.faj322)  THEN LET l_faj.faj322  = 0   END IF
         IF cl_null(l_faj.faj3312) THEN LET l_faj.faj3312 = 0   END IF
         IF cl_null(l_faj.faj332)  THEN LET l_faj.faj332  = 0   END IF
         IF cl_null(l_faj.faj342)  THEN LET l_faj.faj342  = ' ' END IF
         IF cl_null(l_faj.faj352)  THEN LET l_faj.faj352  = 0   END IF
         IF cl_null(l_faj.faj432)  THEN LET l_faj.faj432  = ' ' END IF
         IF cl_null(l_faj.faj592)  THEN LET l_faj.faj592  = 0   END IF
         IF cl_null(l_faj.faj602)  THEN LET l_faj.faj602  = 0   END IF

         #TQC-C50152--add--str
         SELECT azi04 INTO g_azi04_1 FROM azi_file
          WHERE azi01 = l_faj.faj143
         LET l_faj.faj142=cl_digcut(l_faj.faj142,g_azi04_1)
         LET l_faj.faj1012=cl_digcut(l_faj.faj1012,g_azi04_1)
         LET l_faj.faj1022=cl_digcut(l_faj.faj1022,g_azi04_1)
         LET l_faj.faj1082=cl_digcut(l_faj.faj1082,g_azi04_1)
         LET l_faj.faj1412=cl_digcut(l_faj.faj1412,g_azi04_1)
         LET l_faj.faj2032=cl_digcut(l_faj.faj2032,g_azi04_1)
         LET l_faj.faj2042=cl_digcut(l_faj.faj2042,g_azi04_1)
         LET l_faj.faj312=cl_digcut(l_faj.faj312,g_azi04_1)
         LET l_faj.faj322=cl_digcut(l_faj.faj322,g_azi04_1)
         LET l_faj.faj3312=cl_digcut(l_faj.faj3312,g_azi04_1)
         LET l_faj.faj332=cl_digcut(l_faj.faj332,g_azi04_1)
         LET l_faj.faj352=cl_digcut(l_faj.faj352,g_azi04_1)
         LET l_faj.faj592=cl_digcut(l_faj.faj592,g_azi04_1)
         LET l_faj.faj602=cl_digcut(l_faj.faj602,g_azi04_1) 
         #TQC-C50152--add--end
         UPDATE faj_file SET faj_file.* = l_faj.*    # 更新DB
           WHERE faj01 = l_faj.faj01
            AND  faj02 = l_faj.faj02
            AND  faj022 = l_faj.faj022         
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            LET g_showmsg=l_faj.faj01,"/",l_faj.faj02,"/",l_faj.faj022   
            CALL s_errmsg("faj01,faj02,faj022",g_showmsg,"UPDATE faj_file",SQLCA.sqlcode,1)
            LET g_success = 'N'
         ELSE 
            LET g_i = g_i + 1
         END IF
         
      END IF
      
END FUNCTION
#FUN-BB0093
