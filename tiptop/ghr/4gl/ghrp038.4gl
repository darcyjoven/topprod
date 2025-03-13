# Prog. Version..: '5.30.03-12.09.18(00007)'     #
#
# Pattern name...: ghrp038.4gl
# Descriptions...: 数据采集自动处理作业
# Date & Author..: 13/08/30 By jiangxt

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
                
MAIN
DEFINE l_hrbt RECORD LIKE hrbt_file.*

   OPTIONS
       INPUT NO WRAP 
   DEFER INTERRUPT	       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
      
   SELECT * INTO l_hrbt.* FROM hrbt_file 
   IF l_hrbt.hrbt01='Y' THEN 
      CALL p038_get_name(l_hrbt.hrbt011,l_hrbt.hrbt016)
   END IF 
   IF l_hrbt.hrbt02='Y' THEN 
      CALL p038_get_name(l_hrbt.hrbt021,l_hrbt.hrbt026)
   END IF 
   IF l_hrbt.hrbt03='Y' THEN
      CALL p038_get_name(l_hrbt.hrbt031,l_hrbt.hrbt036)
   END IF 
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p038_get_name(l_hrbx02,l_path_t)
DEFINE l_hrbx02 LIKE hrbx_file.hrbx02
DEFINE l_path_t STRING
DEFINE l_path   STRING
DEFINE ls_cmd   STRING
DEFINE ch_cmd   base.Channel
DEFINE l_name   LIKE type_file.chr100
DEFINE l_cnt    LIKE type_file.num5

      IF os.Path.chdir(l_path_t CLIPPED) THEN
         LET ls_cmd = "ls "||l_path_t
      END IF
      
      LET ch_cmd = base.Channel.create()
      CALL ch_cmd.openPipe(ls_cmd, "r")
      WHILE ch_cmd.read(l_name)
         SELECT count(*) INTO l_cnt FROM hrbx_file WHERE hrbx02=l_hrbx02 AND hrbx07=l_name
         IF l_cnt>0 THEN 
            CONTINUE WHILE
         END IF
         LET l_path=l_path_t CLIPPED,'/',l_name CLIPPED 
         CALL p038_ins_hrbx(l_hrbx02,l_name,l_path)
      END WHILE
      CALL ch_cmd.close()

END FUNCTION 

FUNCTION p038_ins_hrbx(p_hrbx02,p_name,p_path)
DEFINE l_hrbx    RECORD LIKE hrbx_file.*
DEFINE l_hrbx01  LIKE type_file.num20
DEFINE p_hrbx02  LIKE hrbx_file.hrbx02
DEFINE p_name    LIKE type_file.chr100
DEFINE p_path    STRING
DEFINE l_year    STRING 
DEFINE l_month   STRING
DEFINE l_day     STRING 
DEFINE l_sql     STRING 

     LET l_year=YEAR(g_today) USING "&&&&"
     LET l_month=MONTH(g_today) USING "&&"
     LET l_day=DAY(g_today) USING "&&"
     LET l_hrbx.hrbx01=l_year,l_month,l_day
     
     LET l_sql=" SELECT MAX(to_number(hrbx01)+1) FROM hrbx_file",
               "  WHERE hrbx01 LIKE '",l_hrbx.hrbx01,"%'"
     PREPARE p038_hrbx01 FROM l_sql
     EXECUTE p038_hrbx01 INTO l_hrbx01
     IF cl_null(l_hrbx01) THEN 
        LET l_hrbx.hrbx01=l_hrbx.hrbx01,'0001'
     ELSE
        LET l_hrbx.hrbx01=l_hrbx01 USING "&&&&&&&&&&&&"
     END IF
        
     LET l_hrbx.hrbx02 = p_hrbx02
     LET l_hrbx.hrbx03 = g_today
     LET l_hrbx.hrbx04 = g_user
     LET l_hrbx.hrbx05 = 'Y'
     LET l_hrbx.hrbx06 = NULL 
     LET l_hrbx.hrbx07 = p_name
     LET l_hrbx.hrbx08 = NULL 
     LET l_hrbx.hrbxuser = g_user
     LET l_hrbx.hrbxoriu = g_user
     LET l_hrbx.hrbxorig = g_grup
     LET l_hrbx.hrbxgrup = g_grup 
     LET l_hrbx.hrbxmodu = g_user
     LET l_hrbx.hrbxdate = g_today
     INSERT INTO hrbx_file VALUES (l_hrbx.*)
     IF sqlca.sqlcode THEN
        CALL cl_err3("ins","hrbx_file",l_hrbx.hrbx01,"",SQLCA.sqlcode,"","",0) 
        RETURN 
     END IF

     CALL p038_ins_hrby(l_hrbx.*,p_path) 
END FUNCTION 

FUNCTION p038_ins_hrby(g_hrbx,l_path)
DEFINE g_hrbx           RECORD LIKE hrbx_file.*
DEFINE l_path           STRING 
DEFINE l_channel        base.Channel
DEFINE s                STRING
DEFINE s_t              LIKE type_file.chr100
DEFINE l_hrbu           RECORD LIKE hrbu_file.* 
DEFINE l_i              LIKE type_file.num5
DEFINE l_n              LIKE type_file.num5 
DEFINE l_length1        LIKE type_file.num5
DEFINE l_length2        LIKE type_file.num5
DEFINE l_hrbx08         LIKE hrbx_file.hrbx08
DEFINE l_year           STRING
DEFINE l_month          STRING
DEFINE l_day            STRING
DEFINE l_date           LIKE type_file.dat
DEFINE l_sql            STRING         
DEFINE l_end            LIKE type_file.num5
DEFINE l_enda           LIKE type_file.num5
DEFINE l_endb           LIKE type_file.num5

       CREATE TEMP TABLE tmp_file(
          usestr LIKE type_file.chr100,
          usenum LIKE hrby_file.hrby02);
       DELETE FROM tmp_file
       
       LET l_channel=base.channel.create()
       CALL l_channel.openfile(l_path,"r" ) 
       IF STATUS THEN
          CALL l_channel.close()
          RETURN 
       END IF 

       SELECT hrbu_file.*,greatest(hrbu05,hrbu07,hrbu09,hrbu11,hrbu13,hrbu15,hrbu17,hrbu19,hrbu21) 
         INTO l_hrbu.*,l_length2 
         FROM hrbu_file
        WHERE hrbu01=g_hrbx.hrbx02

       LET l_n=1
       WHILE TRUE
           LET s = l_channel.readLine()
           IF l_channel.isEof() THEN EXIT WHILE END IF 
           IF s IS NULL OR s=" " THEN   
             CONTINUE WHILE 
           END IF 

           LET l_length1=s.getLength()
           IF l_length1<l_length2 THEN
              CONTINUE WHILE
           END IF

           LET l_year=s.subString(l_hrbu.hrbu08,l_hrbu.hrbu09)
           LET l_month=s.subString(l_hrbu.hrbu10,l_hrbu.hrbu11)
           LET l_day=s.subString(l_hrbu.hrbu12,l_hrbu.hrbu13)
           IF l_hrbu.hrbu09-l_hrbu.hrbu08='1' THEN 
              LET l_year='20',l_year
           END IF 
           LET l_year=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED
           LET l_sql=" SELECT to_date('",l_year,"','yyyymmdd') FROM DUAL"
           PREPARE get_hrby05 FROM l_sql
           EXECUTE get_hrby05 INTO l_date
          
           LET s_t=s
           INSERT INTO tmp_file VALUES(s_t,l_n)
           INSERT INTO hrby_file(hrby01,hrby02,hrby05,hrby11,hrby12,hrbyacti) VALUES(g_hrbx.hrbx01,l_n,l_date,'0','1','Y')
           LET l_n=l_n+1
       END WHILE

       LET l_end=l_hrbu.hrbu05-l_hrbu.hrbu04+1
       LET l_sql="UPDATE hrby_file SET hrby03=(SELECT substr(usestr,",l_hrbu.hrbu04,",",l_end,") FROM tmp_file WHERE hrby02=usenum)",
                 " WHERE hrby01='",g_hrbx.hrbx01,"'" 
       PREPARE ins_p2 FROM l_sql
       EXECUTE ins_p2

       LET l_end=l_hrbu.hrbu07-l_hrbu.hrbu06+1
       LET l_sql="UPDATE hrby_file SET hrby04=(SELECT substr(usestr,",l_hrbu.hrbu06,",",l_end,") FROM tmp_file WHERE hrby02=usenum)",
                 " WHERE hrby01='",g_hrbx.hrbx01,"'" 
       PREPARE ins_p3 FROM l_sql
       EXECUTE ins_p3

       LET l_end=l_hrbu.hrbu15-l_hrbu.hrbu14+1
       LET l_enda=l_hrbu.hrbu17-l_hrbu.hrbu16+1
       LET l_endb=l_hrbu.hrbu19-l_hrbu.hrbu18+1
       IF l_hrbu.hrbu19>0 THEN 
          LET l_sql="UPDATE hrby_file SET hrby06=(SELECT substr(usestr,",l_hrbu.hrbu14,",",l_end,")||':'||substr(usestr,",l_hrbu.hrbu16,",",l_enda,")||':'||substr(usestr,",l_hrbu.hrbu18,",",l_endb,") FROM tmp_file WHERE hrby02=usenum)"
       ELSE
          LET l_sql="UPDATE hrby_file SET hrby06=(SELECT substr(usestr,",l_hrbu.hrbu14,",",l_end,")||':'||substr(usestr,",l_hrbu.hrbu16,",",l_enda,") FROM tmp_file WHERE hrby02=usenum)"
       END IF 
       LET l_sql=l_sql CLIPPED," WHERE hrby01='",g_hrbx.hrbx01,"'" 
       PREPARE ins_p4 FROM l_sql
       EXECUTE ins_p4

       IF l_hrbu.hrbu21>0 THEN
          LET l_end=l_hrbu.hrbu21-l_hrbu.hrbu20+1
          LET l_sql=" UPDATE hrby_file SET hrby07=(SELECT substr(usestr,",l_hrbu.hrbu20,",",l_end,") FROM tmp_file WHERE hrby02=usenum)",
                    " WHERE hrby01='",g_hrbx.hrbx01,"'" 
          PREPARE ins_p5 FROM l_sql
          EXECUTE ins_p5
       END IF 
       
       IF l_length1>l_length2 THEN
          LET l_end=l_length1-l_length2+1
          LET l_sql="UPDATE hrby_file SET hrby08=(SELECT substr(usestr,",l_length2,",",l_end,") FROM tmp_file WHERE hrby02=usenum)",
                    " WHERE hrby01='",g_hrbx.hrbx01,"'" 
          PREPARE ins_p6 FROM l_sql
          EXECUTE ins_p6
       END IF 
       
       LET l_sql="UPDATE hrby_file SET hrby11='2' WHERE hrby03 NOT IN",
                 " (SELECT hrbv01 FROM hrbv_file) AND hrby01='",g_hrbx.hrbx01,"'"
       PREPARE ins_p7 FROM l_sql
       EXECUTE ins_p7

       LET l_sql="UPDATE hrby_file SET hrby09=(SELECT hrcx01 FROM hrcx_file",
                 " WHERE rownum=1 AND hrcx04||hrcx05<=hrby05||hrby06",
                 "   AND (hrcx06='' OR hrcx06||hrcx07>=hrby05||hrby06)",
                 "   AND hrcx02=hrby04) WHERE hrby11='0' AND hrby01='",g_hrbx.hrbx01,"'"
       PREPARE ins_p8 FROM l_sql
       EXECUTE ins_p8

       LET l_sql="UPDATE hrby_file SET hrby09=(SELECT hrbw01 FROM hrbw_file", 
                 " WHERE rownum=1 AND hrbw05<=hrby05 AND hrbw02=hrby04 ",
                 "   AND (hrbw06='' OR  hrbw06>=hrby05)) WHERE hrby11='0'",
                 "   AND hrby09 IS NULL AND hrby01='",g_hrbx.hrbx01,"'"
       PREPARE ins_p9 FROM l_sql
       EXECUTE ins_p9
       
       LET l_sql="UPDATE hrby_file SET hrby11='3' WHERE hrby01='",g_hrbx.hrbx01,"' AND hrby09 IS NULL AND hrby11='0'"
       PREPARE ins_p10 FROM l_sql
       EXECUTE ins_p10

       LET l_sql="UPDATE hrby_file SET hrby11='1' WHERE hrby01='",g_hrbx.hrbx01,"' AND hrby11='0'"
       PREPARE ins_p11 FROM l_sql
       EXECUTE ins_p11
          
       IF l_hrbu.hrbu21>0 THEN 
          LET l_sql="UPDATE hrby_file SET hrby10=(SELECT hrbua03 FROM hrbua_file",
                    " WHERE hrbua01=hrby03 AND hrbua02=hrby07 ) WHERE hrby01='",g_hrbx.hrbx01,"'"
       ELSE 
          LET l_sql="UPDATE hrby_file SET hrby10=(SELECT hrbv04 FROM hrbv_file",
                    " WHERE hrbv01=hrby03 ) WHERE hrby01='",g_hrbx.hrbx01,"'",
                    "   AND hrby11<>'2'"
       END IF 
       PREPARE ins_p12 FROM l_sql
       EXECUTE ins_p12


       LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                 "( SELECT hrby09||hrby05 FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
       PREPARE upd_p1 FROM l_sql
       EXECUTE upd_p1
      
       LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                 "( SELECT hrby09||(hrby05+1) FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
       PREPARE upd_p2 FROM l_sql
       EXECUTE upd_p2

       LET l_sql="UPDATE hrcp_file SET hrcp35='N' WHERE hrcp02||hrcp03 IN",
                 "( SELECT hrby09||(hrby05-1) FROM hrby_file WHERE hrby11='1' AND hrby01='",g_hrbx.hrbx01,"')"
       PREPARE upd_p3 FROM l_sql
       EXECUTE upd_p3

       SELECT max(hrby02) INTO l_hrbx08 FROM hrby_file WHERE hrby01=g_hrbx.hrbx01
       IF cl_null(l_hrbx08) THEN LET l_hrbx08=0 END IF 
       UPDATE hrbx_file SET hrbx08=l_hrbx08 WHERE hrbx01=g_hrbx.hrbx01

END FUNCTION 
