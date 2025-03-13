# Prog. Version..: '5.30.06-13.04.19(00009)'     #
#
# Pattern name...: cxcp100.4gl
# Descriptions...: 将出货未开票整批产生作业cxcp100
# Date & Author..: 150415 zhouhao


DATABASE ds   

GLOBALS "../../../tiptop/config/top.global"
#No.FUN-AA1205
#模組變數(Module Variables)
#DEFINE g_tc_fba               RECORD LIKE tc_fba_file.*
#DEFINE g_tc_fbb               RECORD LIKE tc_fbb_file.*

DEFINE g_tc_omb               RECORD LIKE tc_omb_file.*
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
DEFINE g_oga01 LIKE oga_file.oga01
DEFINE li_result    LIKE type_file.num5
DEFINE l_tc_omb003  LIKE tc_omb_file.tc_omb003
DEFINE l_tc_omb902  LIKE tc_omb_file.tc_omb902
DEFINE l_oga08      LIKE oga_file.oga08  #add by dengsy170213
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
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
      CALL p100_tm()
      IF cl_sure(18,20) THEN 	

        SELECT tc_omb003,tc_omb902 INTO l_tc_omb003,l_tc_omb902 FROM tc_omb_file WHERE tc_omb001=tm.yy AND tc_omb002=tm.mm 

        IF l_tc_omb003 IS NOT NULL OR l_tc_omb902 IS NOT NULL  THEN 
            CALL cl_err('','cxc-001',1)
         	  EXIT WHILE
        END IF 

         
         SELECT count(*) into g_cnt FROM tc_omb_file WHERE tc_omb001=tm.yy AND tc_omb002=tm.mm 
         IF g_cnt>0 THEN
         	  IF cl_confirm('cxc-023') THEN
         	  	CALL p100_del()
           ELSE
         		 	CONTINUE WHILE
         	 END IF
         END IF

           
         CALL p100_p() 
             IF g_success ='Y' THEN
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p100_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p100_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p100_w
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p100_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
DEFINE l_aaaacti      LIKE aaa_file.aaaacti #MOD-C10133
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p100_w AT p_row,p_col WITH FORM "cxc/42f/cxcp100" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR ''
   WHILE TRUE  
   
   DIALOG ATTRIBUTE(UNBUFFERED) 

   INPUT BY NAME  tm.yy,tm.mm      
      
   BEFORE INPUT 

     DISPLAY g_plant TO azp01
     
     IF cl_null(tm.yy) THEN
       LET tm.yy=year(g_today)
     END IF	 
     IF cl_null(tm.mm) THEN
       LET tm.mm=month(g_today)
     END IF	                  
     DISPLAY BY NAME  tm.yy,tm.mm
     
    AFTER FIELD tm.yy
         IF tm.yy IS not NULL THEN
         	  IF tm.yy<0 or tm.yy>2100 THEN
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
      CLOSE WINDOW p100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

   EXIT WHILE  
END WHILE

END FUNCTION




FUNCTION p100_p()
  	  
  LET g_cnt=1
  
   BEGIN WORK 
    LET l_sql = "SELECT unique oga01 ",
                "  FROM oga_file ,ogb_file ",
                # " WHERE oga01 =ogb01 AND oga09 !='1' AND oga09!='5' ",  #zhouxm151123
                # "   AND oga09 !='7' AND oga09!='9' ",                   #zhouxm151123
                " WHERE oga01 =ogb01 ",
                "AND (oga09 ='2' OR oga09='3' or oga09='8') ",     #zhouxm151123
                "   AND oga65='N' ", 
                # "   AND oga53 > oga54 ",                                #zhouxm151123 mark
                # "   AND ogb12 > ogb60+ogb63+ogb64 ",                    #zhouxm151123 mark
                # "   AND ogb_file.ogb60 =0      ",                       #mark by lixiaa20150908
                "   AND (oga00 ='1'    ", 
                "    OR oga00 ='4'  or oga00 ='8')   ", 
                "   AND ogapost='Y'   "
                ," and year(oga02)*12+ month(oga02)<=",tm.yy,"*12+",tm.mm #add by dengsy170227
               #  ,"and oga01 ='XRP-23040599' " #darcy:2023/07/05 add 临时加上方便排查问题 
                #str----- add by dengsy170304  #3月之前排除外销()
              ," and ((oga01<>'8' and ((oga02<'17/03/01' and oga08='1') or (oga02>='17/03/01'))) or oga01='8')"
              #end----- add by dengsy170304
 #              "   AND year(oga02)=",tm.yy CLIPPED ," and month(oga02)=",tm.mm CLIPPED 
   #str----- mark by dengsy170227
    #IF tm.mm=1 THEN 
    #   LET l_sql=l_sql,"   AND year(oga02)<=",tm.yy CLIPPED 
    #ELSE 
    #    LET l_sql=l_sql,"   AND year(oga02)=",tm.yy CLIPPED ," and month(oga02)<=",tm.mm CLIPPED
    #END IF 
    #end----- mark by dengsy170227
#zhouxm151124 add start
     LET l_sql=l_sql," UNION SELECT unique oha01 ",
                     " FROM oha_file ",
                     " WHERE ohapost='Y' and ohaconf='Y' "
                     # ,"and 1=2 " #darcy:2023/07/05 add 临时加上方便排查问题 
                     ," and year(oha02)*12+ month(oha02)<=",tm.yy,"*12+",tm.mm #add by dengsy170227
                     #str----- add by dengsy170304  #3月之前排除外销() 
                    #," and ((oha02<'17/03/01' and oha08='1') or (oha02>='17/03/01'))" #Mark by wy20170510 销退排除外销的
                    #," and oha08='1'" #add by wy20170510   #mark by pane 210303外销也需要可以产生在cxct100
              #end----- add by dengsy170304
    #str----- mark by dengsy170227
    #IF tm.mm=1 THEN 
    #   LET l_sql=l_sql,"   AND year(oha02)<=",tm.yy CLIPPED 
    #ELSE 
    #    LET l_sql=l_sql,"   AND year(oha02)=",tm.yy CLIPPED ," and month(oha02)<=",tm.mm CLIPPED
    #END IF
    #end----- mark by dengsy170227
#zhouxm151124 add end     
    
   PREPARE p100_p1 FROM l_sql
   DECLARE p100_c1 CURSOR FOR p100_p1
   FOREACH p100_c1 INTO g_oga01
      INITIALIZE g_tc_omb.* TO NULL

       CALL p100_ins_tc_omb()
   END FOREACH
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
#--add by lifang tc_omb001,tc_omb002 200908 begin#
      #tianry add 170114
      UPDATE TC_OMB_FILE
      SET TC_OMB25='22210108'
      WHERE TC_OMB25='22210102'
      and tc_omb001 = tm.yy
      and tc_omb002 = tm.mm

      UPDATE TC_OMB_FILE
      SET TC_OMB23='600103'
          ,tc_omb903='640103'  #add by dengsy170212
      WHERE TC_OMB23='600101'
       and tc_omb001 = tm.yy
       and tc_omb002 = tm.mm

      UPDATE TC_OMB_FILE
      SET TC_OMB23='600104'
          ,tc_omb903='640104'  #add by dengsy170212
      WHERE TC_OMB23='600102'
       and tc_omb001 = tm.yy
       and tc_omb002 = tm.mm

      #str----- add by dengsy170308
      UPDATE TC_OMB_FILE
      SET tc_omb903='6402'  
      WHERE TC_OMB23='6051'
       and tc_omb001 = tm.yy
       and tc_omb002 = tm.mm
      #end----- add by dengsy170308


      UPDATE TC_OMB_FILE
      SET TC_OMB27='112204'
      WHERE TC_OMB27='112202'
       and tc_omb001 = tm.yy
       and tc_omb002 = tm.mm

      UPDATE TC_OMB_FILE
      SET TC_OMB27='112203'
      #WHERE TC_OMB27='112201'  #mark by dengsy170309
      #WHERE tc_omb27<>'112202'  #add by dengsy170309  #mark by lifang 200908
      WHERE tc_omb27<>'112204'   #add by lifang 200908
       and tc_omb001 = tm.yy
       and tc_omb002 = tm.mm
      #tianry add 170114
#--add by lifang tc_omb001,tc_omb002 200908 end#

   END IF 
END FUNCTION 


FUNCTION p100_ins_tc_omb()
DEFINE l_dd3 LIKE type_file.dat #zhouxm170209 add 
DEFINE l_sum LIKE tlf_file.tlf10  #liyjf170302
DEFINE l_oga01 LIKE oga_file.oga01  #liyjf170302
LET l_dd3 = s_getlastday(MDY(tm.mm ,'1',tm.yy))

   LET l_sql =" SELECT  oga01,oga02,oga03,oga032,oga04,oga14,oga15,oga21,oga211,ogb03,", 
              " ogb04,ogb05,ogb06,ogb07,ogb31,ogb32,oga23,oga24,ogb12,ogb13,(ogb14/ogb12),(ogb14t/ogb12) ",  #add by huanglf170113
              "  ,oga08 ",  #add by dengsy170213
              " from oga_file,ogb_file  ",  
              " WHERE oga01=ogb01 ", 
              "  AND oga02<= '",l_dd3,"' ",  #zhouxm170209 add
              " AND   oga01='",g_oga01,"'" 
             ," AND ogb12 <> 0 "             #add by lifang 190409 
              
#zhouxm151124 add start
   LET l_sql=l_sql," UNION SELECT  oha01,oha02,oha03,oha032,oha04,oha14,oha15,oha21,oha211,ohb03,", 
              " ohb04,ohb05,ohb06,ohb07,ohb31,ohb32,oha23,oha24,ohb12*(-1),ohb13,(ohb14/ohb12),(ohb14t/ohb12) ",  #add by huanglf170113
              " ,oha08 ",
              " from oha_file,ohb_file  ",  
              " WHERE oha01=ohb01 ", 
              "  AND oha02<= '",l_dd3,"' ",  #zhouxm170209 add
              " AND oha01='",g_oga01,"'" 
              #,"  and ohb31 not in (select oga01 from oga_file where oga02<'17/03/01' and oga08='1')"  #add by dengsy170310 #zhouxm170311 mark
              ,"  and ohb31 not in (select oga01 from oga_file where oga02<'17/03/01' and oga08 in ('2','3'))"  #zhouxm170311 add
              #," and ((oha02<'17/03/01' and oha08='1') or (oha02>='17/03/01'))"  #add by dengsy170304 #mark by wy20170510
             #," and oha08='1'" #add by wy20170510 #mark by pane 210303
              ," and ohb12<>0 " #add by lifang 190409
#zhouxm151124 add end             
   PREPARE p100_p2 FROM l_sql
   DECLARE p100_c2 CURSOR FOR p100_p2
   ###add by liyjf181220 str 防止单价为0时带的前一个的单价
   LET g_tc_omb.tc_omb01 = '' LET g_tc_omb.tc_omb02 = ''  LET g_tc_omb.tc_omb03='' LET g_tc_omb.tc_omb032=''  LET g_tc_omb.tc_omb04 = ''   
   LET g_tc_omb.tc_omb05 = '' LET g_tc_omb.tc_omb06 = ''  LET g_tc_omb.tc_omb07='' LET g_tc_omb.tc_omb08= 0   LET g_tc_omb.tc_omb10 = 0
   LET g_tc_omb.tc_omb11 = '' LET g_tc_omb.tc_omb12 = ''  LET g_tc_omb.tc_omb13='' LET g_tc_omb.tc_omb14=''   LET g_tc_omb.tc_omb15 = ''
   LET g_tc_omb.tc_omb16 = 0  LET g_tc_omb.tc_omb17 = ''  LET g_tc_omb.tc_omb18=0  LET g_tc_omb.tc_omb19=0    LET g_tc_omb.tc_omb22 =0
   LET  g_tc_omb.tc_omb24 = 0 LET g_tc_omb.tc_omb28 = 0   LET l_oga08 = ''
   ###add by liyjf181220 end
   FOREACH p100_c2 INTO  g_tc_omb.tc_omb01,g_tc_omb.tc_omb02,g_tc_omb.tc_omb03,g_tc_omb.tc_omb032,g_tc_omb.tc_omb04,
                         g_tc_omb.tc_omb05,g_tc_omb.tc_omb06,g_tc_omb.tc_omb07,g_tc_omb.tc_omb08,g_tc_omb.tc_omb10,
                         g_tc_omb.tc_omb11,g_tc_omb.tc_omb12,g_tc_omb.tc_omb13,g_tc_omb.tc_omb14,g_tc_omb.tc_omb15,
                         g_tc_omb.tc_omb16,g_tc_omb.tc_omb17,g_tc_omb.tc_omb18,g_tc_omb.tc_omb19,g_tc_omb.tc_omb22,
                         g_tc_omb.tc_omb24,g_tc_omb.tc_omb28
                         ,l_oga08  #add by dengsy170213

  { LET l_sql ="SELECT  tc_fbh14,tc_fbh15 from tc_fbh_file,tc_fbg_file where  tc_fbh01=tc_fbg01 ",
              " and tc_fbgconf='Y' and tc_fbh03='",g_tc_fbb.tc_fbb03,"' and tc_fbh04='",g_tc_fbb.tc_fbb04,"'" 
   PREPARE p100_p4 FROM l_sql
   DECLARE p100_c4 CURSOR FOR p100_p4
   FOREACH p100_c4 INTO l_tc_fbh14,l_tc_fbh15
   END FOREACH}
#add by liyjf170302 str
      {select SUM(tlf10* tlf907) INTO l_sum  FROM tlf_file WHERE tlf905 =  g_tc_omb.tc_omb01 
      AND tlf906 = g_tc_omb.tc_omb10
       IF l_sum = '0' THEN 
        SELECT oga01 INTO l_oga01 FROM oga_file WHERE oga011 = g_tc_omb.tc_omb01  AND oga09 = '8'
        LET g_tc_omb.tc_omb01  = l_oga01
      END  IF} 
#add by liyjf170302 str
     #str---- add by dengsy170304
     select SUM(tlf10* tlf907) INTO l_sum  FROM tlf_file WHERE tlf905 =  g_tc_omb.tc_omb01 
      AND tlf906 = g_tc_omb.tc_omb10
      IF l_sum=0 THEN 
        CONTINUE FOREACH 
      END IF 
     #end---- add by dengsy170304
   SELECT occ02 INTO g_tc_omb.tc_omb042 FROM occ_file WHERE occ01=g_tc_omb.tc_omb04

   #SELECT omf16 INTO g_tc_omb.tc_omb20 FROM omf_file WHERE omf11= g_tc_omb.tc_omb01   #mark by dengsy150909
#str--- add by dengsy150909
      LET g_tc_omb.tc_omb20 =0 #zhouxm151123 add 
      SELECT nvl(SUM(omf16),0) INTO g_tc_omb.tc_omb20 
      FROM omf_file
      WHERE omf11=g_tc_omb.tc_omb01 #AND omf13=g_tc_omb.tc_omb11
      AND omf12=g_tc_omb.tc_omb10   #zhouxm151123 add 
     # AND year(omf31)<=tm.yy AND month(omf31)<=tm.mm  #zhouxm151123 mark
      AND (year(omf31)<tm.yy  OR (year(omf31)=tm.yy AND month(omf31)<=tm.mm)) #zhouxm151123 add 
      AND omf08='Y'
#end--- add by dengsy150909
    IF cl_null(g_tc_omb.tc_omb20) THEN LET g_tc_omb.tc_omb20=0 END IF 

    LET g_tc_omb.tc_omb21=g_tc_omb.tc_omb19-g_tc_omb.tc_omb20
   IF  g_tc_omb.tc_omb21 = 0  THEN CONTINUE FOREACH END IF  #zhouxm151123 add

#str----add by huanglf170113
    LET g_tc_omb.tc_omb24 = g_tc_omb.tc_omb24 * g_tc_omb.tc_omb21
    LET g_tc_omb.tc_omb28 = g_tc_omb.tc_omb28 * g_tc_omb.tc_omb21
#str----end by huanglf170113
   

    SELECT ool41 INTO g_tc_omb.tc_omb23 FROM ool_file WHERE ool01=(
     #SELECT occ67 FROM occ_file WHERE occ01=g_tc_omb.tc_omb03)  #mark by dengsy170213
     CASE WHEN l_oga08='1' THEN '01' ELSE '02' end) #add by dengsy170213
       IF cl_null(g_tc_omb.tc_omb23) THEN LET g_tc_omb.tc_omb23='  ' END IF 

     
    SELECT ool11 INTO g_tc_omb.tc_omb27 FROM ool_file WHERE ool01=(
     #SELECT occ67 FROM occ_file WHERE occ01=g_tc_omb.tc_omb03)  #mark by dengsy170213
     CASE WHEN l_oga08='1' THEN '01' ELSE '02' end) #add by dengsy170213
       IF cl_null(g_tc_omb.tc_omb27) THEN LET g_tc_omb.tc_omb27='  ' END IF 

    #str----- add by dengsy170302
    SELECT DISTINCT aag01  INTO g_tc_omb.tc_omb23 FROM aag_file,ima_file
    WHERE ima01=g_tc_omb.tc_omb11 AND ima08='P' AND aag01='6051'
    IF cl_null(g_tc_omb.tc_omb23) THEN LET g_tc_omb.tc_omb23='  ' END IF 

    SELECT DISTINCT aag01  INTO g_tc_omb.tc_omb27 FROM aag_file,ima_file
    WHERE ima01=g_tc_omb.tc_omb11 AND ima08='P' AND aag01='6402'
    IF cl_null(g_tc_omb.tc_omb27) THEN LET g_tc_omb.tc_omb27='  ' END IF 
    #end----- add by dengsy170302
  
    SELECT gec03 INTO g_tc_omb.tc_omb25 FROM gec_file WHERE gec01=g_tc_omb.tc_omb07
      IF cl_null(g_tc_omb.tc_omb25) THEN LET g_tc_omb.tc_omb25='  ' END IF 
    
    LET g_tc_omb.tc_omb26=g_tc_omb.tc_omb28-g_tc_omb.tc_omb24
      IF cl_null(g_tc_omb.tc_omb26) THEN LET g_tc_omb.tc_omb26=0 END IF 
    
    LET g_tc_omb.tc_omb29=g_tc_omb.tc_omb24*g_tc_omb.tc_omb18
      IF cl_null(g_tc_omb.tc_omb29) THEN LET g_tc_omb.tc_omb29=0 END IF 
      
    LET g_tc_omb.tc_omb30=g_tc_omb.tc_omb26*g_tc_omb.tc_omb18
     IF cl_null(g_tc_omb.tc_omb30) THEN LET g_tc_omb.tc_omb30=0 END IF 
     
    LET g_tc_omb.tc_omb31=g_tc_omb.tc_omb28*g_tc_omb.tc_omb18
     IF cl_null(g_tc_omb.tc_omb31) THEN LET g_tc_omb.tc_omb31=0 END IF 
  
    SELECT ima021 INTO g_tc_omb.tc_ombud01 FROM ima_file WHERE ima01=g_tc_omb.tc_omb11
  
  LET g_tc_omb.tc_omb001=tm.yy
  LET g_tc_omb.tc_omb002=tm.mm
  LET g_tc_omb.tc_omb005=g_cnt

#zhouxm170209 add start
  LET g_tc_omb.tc_omb24 = cl_digcut(g_tc_omb.tc_omb24,2)
  LET g_tc_omb.tc_omb26 = cl_digcut(g_tc_omb.tc_omb26,2)
  LET g_tc_omb.tc_omb28 = cl_digcut(g_tc_omb.tc_omb28,2)
  LET g_tc_omb.tc_omb29 = cl_digcut(g_tc_omb.tc_omb29,2)
  LET g_tc_omb.tc_omb30 = cl_digcut(g_tc_omb.tc_omb30,2)
  LET g_tc_omb.tc_omb31 = cl_digcut(g_tc_omb.tc_omb31,2)
#zhouxm170209 add end 
  #str------ add by dengsy170212
  SELECT ima39 INTO g_tc_omb.tc_omb904 FROM ima_file WHERE ima01=g_tc_omb.tc_omb11
  #end------ add by dengsy170212
       
   INSERT INTO tc_omb_file(tc_omb001,tc_omb002,tc_omb005,
                           tc_omb01,tc_omb02,tc_omb03,tc_omb032,tc_omb04,
                           tc_omb05,tc_omb06,tc_omb07,tc_omb08,tc_omb10,
                           tc_omb11,tc_omb12,tc_omb13,tc_omb14,tc_omb15,
                           tc_omb16,tc_omb17,tc_omb18,tc_omb19,tc_omb22,
                           tc_omb24,tc_omb28,tc_omb042,tc_omb20,tc_omb21,
                           tc_omb23,tc_omb25,tc_omb26,tc_omb27,tc_omb29,
                           tc_omb30,tc_omb31,tc_ombud01 ,tc_omb904) #add tc_omb904 by dengsy170212
                         
      VALUES(g_tc_omb.tc_omb001,g_tc_omb.tc_omb002,g_tc_omb.tc_omb005,
             g_tc_omb.tc_omb01,g_tc_omb.tc_omb02,g_tc_omb.tc_omb03,g_tc_omb.tc_omb032,g_tc_omb.tc_omb04,
             g_tc_omb.tc_omb05,g_tc_omb.tc_omb06,g_tc_omb.tc_omb07,g_tc_omb.tc_omb08,g_tc_omb.tc_omb10,
             g_tc_omb.tc_omb11,g_tc_omb.tc_omb12,g_tc_omb.tc_omb13,g_tc_omb.tc_omb14,g_tc_omb.tc_omb15,
             g_tc_omb.tc_omb16,g_tc_omb.tc_omb17,g_tc_omb.tc_omb18,g_tc_omb.tc_omb19,g_tc_omb.tc_omb22,
             g_tc_omb.tc_omb24,g_tc_omb.tc_omb28,g_tc_omb.tc_omb042,g_tc_omb.tc_omb20,g_tc_omb.tc_omb21,
             g_tc_omb.tc_omb23,g_tc_omb.tc_omb25,g_tc_omb.tc_omb26,g_tc_omb.tc_omb27,g_tc_omb.tc_omb29,
             g_tc_omb.tc_omb30,g_tc_omb.tc_omb31,g_tc_omb.tc_ombud01,g_tc_omb.tc_omb904) #add tc_omb904 by dengsy170212
   
   INITIALIZE g_tc_omb.* TO NULL
   LET g_cnt=g_cnt+1
 
  END FOREACH 
END FUNCTION


FUNCTION p100_del()

DELETE FROM tc_omb_file WHERE tc_omb001=tm.yy AND tc_omb002=tm.mm 

END FUNCTION
