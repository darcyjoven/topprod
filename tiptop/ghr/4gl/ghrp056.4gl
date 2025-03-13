#Prog. Version..: '5.30.03-12.09.18(00007)'     #
# 
# Pattern name...: ghrp056.4gl
# Descriptions...: 点名批处理作业
# Date & Author..: 2016/12/28 By zhuzw
DATABASE ds  

GLOBALS "../../config/top.global"
DEFINE b_date  LIKE type_file.dat
DEFINE e_date  LIKE type_file.dat
DEFINE l_type,g_hrbo06  LIKE type_file.chr1
DEFINE g_date  LIKE type_file.dat
DEFINE g_date1 LIKE type_file.dat
DEFINE g_name  LIKE type_file.chr100
DEFINE l_namet LIKE type_file.chr100
DEFINE g_hrbo  RECORD LIKE hrbo_file.*
DEFINE l_pro	LIKE type_file.num10
DEFINE g_hrat01 LIKE hrat_file.hrat01
DEFINE g_hrat02 LIKE hrat_file.hrat02
DEFINE g_hrat03 LIKE hrat_file.hrat03 
DEFINE g_hratid LIKE hrat_file.hratid
DEFINE g_hrbk03 LIKE hrbk_file.hrbk03
DEFINE g_hrbn02 LIKE hrbn_file.hrbn02
DEFINE g_hrbo02 LIKE hrbo_file.hrbo02
DEFINE g_hrbo07 LIKE hrbo_file.hrbo07
DEFINE g_hrat04 LIKE hrat_file.hrat04
DEFINE g_hrat87 LIKE hrat_file.hrat87
DEFINE g_hrat88 LIKE hrat_file.hrat88
DEFINE g_hrat90 LIKE hrat_file.hrat90
DEFINE g_hrcp04 LIKE hrcp_file.hrcp04
DEFINE g_bgjob LIKE type_file.chr1
DEFINE l_total1,l_total LIKE hrbo_file.hrbo09
DEFINE g_bs LIKE type_file.chr1
DEFINE g_hrcp22,g_hrcp22_1 LIKE hrcp_file.hrcp22
DEFINE g_hrcm02  LIKE hrcm_file.hrcm02
DEFINE g_bqjbs,g_cjjb,g_bkjb    LIKE hrcp_file.hrcp11
DEFINE g_hrat91 LIKE hrat_file.hrat91 
DEFINE g_hrbk05 LIKE hrbk_file.hrbk05 
DEFINE g_jblx LIKE hrcp_file.hrcp10
DEFINE g_hrbo04 LIKE type_file.num10
DEFINE g_hrbo05,g_hrboa02,g_hrboa05,g_jrss LIKE type_file.num10
DEFINE g_jcd   LIKE hrcp_file.hrcp10
DEFINE g_jrjb  LIKE hrbm_file.hrbm03
DEFINE g_jflog LIKE type_file.chr1
DEFINE g_qk    LIKE type_file.chr1 #记录是否缺卡

MAIN
DEFINE l_sql   STRING
DEFINE l_sql1   STRING
DEFINE l_num   LIKE type_file.num10
DEFINE l_hratid LIKE hrat_file.hratid
DEFINE l_hrby05 LIKE hrby_file.hrby05
DEFINE l_hrby06 LIKE hrby_file.hrby06
DEFINE l_hrby10 LIKE hrby_file.hrby10
DEFINE l_hrboa02  LIKE hrboa_file.hrboa02
DEFINE l_hrboa03  LIKE hrboa_file.hrboa03
DEFINE l_hrboa04  LIKE hrboa_file.hrboa04
DEFINE l_hrboa05  LIKE hrboa_file.hrboa05
DEFINE l_hrboa06  LIKE hrboa_file.hrboa06
DEFINE l_hrboa07  LIKE hrboa_file.hrboa07
DEFINE l_hrbo06   LIKE hrbo_file.hrbo06
DEFINE l_hrbo08   LIKE hrbo_file.hrbo08
DEFINE l_bdate  LIKE type_file.dat
DEFINE l_n     LIKE type_file.num5
DEFINE l_pid,l_pid1 LIKE type_file.chr20
DEFINE l_hraa01     LIKE hraa_file.hraa01     #员工所属公司编号
DEFINE l_hrdq08     LIKE hrdq_file.hrdq08     #职能排班标记
DEFINE l_hrbn02     LIKE hrbn_file.hrbn02     #员工当天考勤方式
DEFINE l_hrbk05    LIKE hrbk_file.hrbk05     #员工当天日历类型
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
   LET g_bgjob = ARG_VAL(1)#是否背景作业
   LET b_date  = ARG_VAL(2)#分析开始日期
   LET e_date  = ARG_VAL(3)#分析结束日期
   IF e_date >=g_today THEN
      LET e_date = g_today - 1
   END IF
   LET l_type  = ARG_VAL(4)#人员类型【1：人员、2:部门】   
   LET l_namet = ARG_VAL(5)#分析人员【"-"表示所有人】
   LET g_hrat03= ARG_VAL(6)#分析人员所在的公司
   LET l_pid1  = ARG_VAL(7)#主作业pid
   IF l_namet = '-' THEN
      LET l_namet=''
   END IF
                              
#删除已离职却存在点名的数据 
   DELETE   FROM hrcp_file
    WHERE EXISTS (SELECT 1
          FROM hrat_file
         WHERE hratid = hrcp02
           AND hrat77 < hrcp03 
           AND hrat19 LIKE '3%')
#end
UPDATE hrcp_file SET hrcp35='N' WHERE hrcp03 >= g_today - 5 AND hrcp08 != '91'
   CALL p056_table()#创建临时表
   IF g_bgjob='Y' THEN #只处理为关帐数据，优先取本公司的，没有取0000
      IF NOT cl_null(g_hrat03) AND b_date != e_date THEN           
         SELECT MIN(hrbl06) INTO l_bdate FROM hrbl_file WHERE hrbl01= g_hrat03 AND hrbl08='N' 
         IF cl_null(l_bdate) THEN 
            SELECT MIN(hrbl06) INTO l_bdate FROM hrbl_file WHERE hrbl01= '0000' AND hrbl08='N'
         END IF 
      ELSE 
         SELECT DISTINCT MIN(hrbl06) INTO l_bdate FROM hrbl_file WHERE  hrbl08='N'       	
      END IF     
      IF  b_date < l_bdate THEN 
          LET b_date = l_bdate
      END IF
      #add by fangyuanz171221----S  背景执行自动计算最近五天的数据
      LET b_date=g_today-5
      LET e_date=g_today-1
      #add by fangyuanz171221----E
   END IF 
#   IF g_bgjob='G'AND  b_date != e_date THEN  #开始日期不等于结束日期，背景作业调用的批次处理,-5是为了确保重新处理关张数据只做5天。
#         SELECT MAX(hrbl06),MAX(hrbl07) INTO b_date,e_date FROM hrbl_file WHERE hrbl01='0000' AND hrbl08='Y' AND hrbl07 >= SYSDATE-7
#   END IF
#add by yinbq for 调用存储过程处理数据
 
   LET l_sql = "
        SELECT HRATID,hrbk03,hrat90
          FROM HRAT_FILE
          LEFT JOIN HRBK_FILE  ON HRBK01 = '1000'
          LEFT JOIN HRCP_FILE ON HRCP02=HRATID AND HRCP03=HRBK03 
        WHERE HRBK03 BETWEEN HRAT25 AND NVL(HRAT77, TRUNC(SYSDATE))
           AND HRBK03 BETWEEN TO_DATE('",b_date,"','yy/mm/dd') AND TO_DATE('",e_date,"','yy/mm/dd')  and hratconf = 'Y' " 


   IF  g_bgjob != 'X' THEN #X参数强制执行
       LET l_sql = l_sql," AND (HRCP35='N' or hrcp35 is null)"        
   END IF  
   IF g_hrat03 = '-' THEN LET g_hrat03 = '' END IF 
   IF NOT cl_null(g_hrat03) THEN #公司不为空时，增加条件
      LET l_sql = l_sql," AND hrat03 = '",g_hrat03,"' " 
   END IF
   IF l_type = '1' THEN  #员工
      IF NOT cl_null(l_namet) THEN 
         LET l_sql = l_sql,"  AND hrat01 in ('",l_namet,"') "
      END IF 
   END IF 
   IF l_type='2' THEN #部门
      IF NOT cl_null(l_namet) THEN  
         LET l_sql = l_sql," AND hrat04 IN ('",l_namet,"') "     
      END IF 
   END IF  
   IF l_type='3' THEN #多线程
       LET l_sql = l_sql," AND hrat91 IN ('",l_namet,"') "        
       LET l_pid = FGL_GETPID()
       INSERT INTO tc_pid_file VALUES(l_pid1,l_pid)
   END IF 

   #add by fangyuanz171220----S
   LET l_sql=l_sql," order by hratid,hrcp03 "
   #add by fangyuanz171220----S
   
   PREPARE p056_cp FROM l_sql
   DECLARE p056_cl CURSOR FOR p056_cp
   FOREACH p056_cl INTO g_name,g_date,g_hrat90
      IF  g_hrat90 ='001' THEN 
          DELETE FROM hrcp_file WHERE hrcp02 = g_name AND hrcp03 = g_date
          CONTINUE FOREACH 
      END IF 
     #无数据增加一笔
     SELECT COUNT(*) INTO l_n FROM hrcp_file WHERE hrcp02 = g_name AND hrcp03 = g_date
     IF l_n = 0 THEN 
        INSERT INTO HRCP_FILE
          (HRCP01, HRCP02, HRCP03, HRCP04, HRCP05,HRCP35,HRCPACTI)
        SELECT  nvl((SELECT MAX(HRCP01) FROM HRCP_FILE) + 1,1), g_name, g_date, ' ', ' ','N','Y' FROM  dual   
     END IF  
    UPDATE hrcp_file SET hrcp09 =0 ,hrcp10 = '' ,hrcp11 = '' , hrcp12 = '' ,hrcp13 = '' ,hrcp14= '' ,
                         hrcp15 = '' ,hrcp16 = '' ,hrcp17 = '' ,hrcp18 = '' ,hrcp19 = '' ,hrcp20 = '' ,hrcp21 = '' ,
                         hrcp34='',hrcp37 = '' ,hrcp38= '' ,hrcp39 = '' ,hrcp40 = '' ,hrcp41 = '' ,hrcp42 = '',
                         hrcp22='',hrcp23='',hrcp24='',hrcp25='',hrcp26='',hrcp27='',hrcp28='',hrcp29='',
                         hrcp30='',hrcp31='',hrcp32='',hrcp33=''
     WHERE hrcp02 = g_name AND hrcp03 = g_date   
     CALL p056_banc_chk()RETURNING g_hrcp04 #获取排班
     
     #PREPARE p056_p0 FROM "CALL CP_GETRANK(?,?,?,?,?,?,?,?)"
     #EXECUTE p056_p0 USING g_name IN, g_date IN, g_hrcp04 OUT, l_hrbn02 OUT, l_hrbk05 OUT, l_hrdq08 OUT, l_hraa01 OUT,l_hrbo06 OUT  

     IF cl_null(g_hrcp04) THEN  #没有排班,更新异常类型为无排班
        UPDATE hrcp_file SET hrcp08 = '93',hrcp09 =0 ,hrcp10 = '' ,hrcp11 = '' , hrcp12 = '' ,hrcp13 = '' ,hrcp14= '' ,
                             hrcp15 = '' ,hrcp16 = '' ,hrcp17 = '' ,hrcp18 = '' ,hrcp19 = '' ,hrcp20 = '' ,hrcp21 = '' ,
                             hrcp37 = '' ,hrcp38= '' ,hrcp39 = '' ,hrcp40 = '' ,hrcp41 = '' ,hrcp42 = ''
         WHERE hrcp02 = g_name AND hrcp03 = g_date        
        CONTINUE FOREACH  
     END IF  
     
     CALL p056_oldbc()#初始化班次          
     CALL p056_qingjia() #差假及生成新班段
     CALL p056_zhuangtai()#判断各班段考勤情况
     CALL p056_updhrcp()#更新hrcp_file最新点名数据
     #处理结束，许清空临时表数据
     DELETE FROM temp01
     DELETE FROM temp01_t
     DELETE FROM temp02
     DELETE FROM temp03
     DELETE FROM temp04
     DELETE FROM temp05
   END FOREACH
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   IF l_type='3' THEN #释放线程
       DELETE FROM tc_pid_file WHERE tc_pid01  = l_pid1 AND tc_pid02 = l_pid
   END IF    
END MAIN

FUNCTION p056_banc_chk() #取班次
DEFINE l_sql STRING
DEFINE l_hrcp04 LIKE hrcp_file.hrcp04
DEFINE l_hrca01 LIKE hrca_file.hrca01
DEFINE l_hrca13 LIKE hrca_file.hrca13
DEFINE  l_xz,l_ys,l_n LIKE  type_file.num5
DEFINE  l_hrca06 LIKE hrca_file.hrca06
DEFINE l_hrca03 LIKE hrca_file.hrca03 
DEFINE l_hrca04 LIKE hrca_file.hrca04
DEFINE l_hrca05 LIKE hrca_file.hrca05
DEFINE l_hrca08 LIKE hrca_file.hrca08
DEFINE l_hrca09 LIKE hrca_file.hrca09
DEFINE l_hrca10 LIKE hrca_file.hrca10
DEFINE l_hrca11 LIKE hrca_file.hrca11
DEFINE l_hrcaud02 LIKE hrca_file.hrcaud02
DEFINE l_hrbk05 LIKE hrbk_file.hrbk05
DEFINE l_hrbpa02 LIKE hrbpa_file.hrbpa02
   LET l_hrcp04 = ''
   #优先级-手动修改-调班-排班计划（个人-群组-部门-公司）
   #ghri075班次调整
  # SELECT hrcq06 INTO l_hrcp04 FROM hrcq_file WHERE hrcq03 = g_name  AND hrcq02 = g_date AND hrcqconf = 'Y'
 #  IF NOT cl_null(l_hrcp04) THEN 
 #     RETURN l_hrcp04
 #  END IF 
   #ghri056手工修改班次
   SELECT hrcp04 INTO l_hrcp04 FROM hrcp_file  WHERE hrcp02 = g_name AND hrcp03 = g_date AND hrcp07 = 'Y'
#   IF NOT cl_null(l_hrcp04) THEN 
#      RETURN l_hrcp04
#   END IF 
    RETURN l_hrcp04
#   #ghri041 取排班计划
#  SELECT NVL(D.hrca01, NVL(E.hrca01,NVL(F.hrca01, G.hrca01))) INTO l_hrca01
#    FROM HRAT_FILE A
#    LEFT JOIN HRCB_FILE C ON C.HRCB05 = A.HRATID AND g_date BETWEEN C.HRCB06 AND C.HRCB07
#    LEFT JOIN hrca_file D ON D.hrca14 = A.HRATID AND g_date BETWEEN D.HRCa11 AND D.HRCa12 AND D.hrca02 = 1        #个人排班
#    LEFT JOIN hrca_file E ON E.hrca14 = C.HRCB01 AND g_date BETWEEN E.HRCa11 AND E.HRCa12 AND E.hrca02 = 4        #群组排班
#    LEFT JOIN hrca_file F ON F.hrca14 = A.HRAT04 AND g_date BETWEEN F.HRCa11 AND F.HRCa12 AND F.hrca02 = 2        #部门排班
#    LEFT JOIN hrca_file G ON G.hrca14 = A.HRAT03 AND g_date BETWEEN G.HRCa11 AND G.HRCa12 AND G.hrca02 = 3            #公司排班
#   WHERE A.HRATID = g_name  
#   IF cl_null(l_hrca01) THEN  #没有取到排班计划，跳出
#      RETURN l_hrcp04
#   ELSE 
#      SELECT NVL(D.hrca13, NVL(E.hrca13,NVL(F.hrca13, G.hrca13))) INTO l_hrca13
#       FROM HRAT_FILE A
#       LEFT JOIN HRCB_FILE C ON C.HRCB05 = A.HRATID AND g_date BETWEEN C.HRCB06 AND C.HRCB07
#       LEFT JOIN hrca_file D ON D.hrca14 = A.HRATID AND g_date BETWEEN D.HRCa11 AND D.HRCa12 AND D.hrca02 = 1  AND D.hrca01 = l_hrca01      #个人排班
#       LEFT JOIN hrca_file E ON E.hrca14 = C.HRCB01 AND g_date BETWEEN E.HRCa11 AND E.HRCa12 AND E.hrca02 = 4  AND E.hrca01 = l_hrca01     #群组排班
#       LEFT JOIN hrca_file F ON F.hrca14 = A.HRAT04 AND g_date BETWEEN F.HRCa11 AND F.HRCa12 AND F.hrca02 = 2  AND F.hrca01 = l_hrca01      #部门排班
#       LEFT JOIN hrca_file G ON G.hrca14 = A.HRAT03 AND g_date BETWEEN G.HRCa11 AND G.HRCa12 AND G.hrca02 = 3  AND G.hrca01 = l_hrca01          #公司排班
#      WHERE A.HRATID = g_name    	
#   END IF    
#   SELECT  hrca03,hrca04,hrca05,hrca06,hrca08,hrca09,hrca10,hrcaud02,hrca11 INTO l_hrca03,l_hrca04,l_hrca05,l_hrca06,l_hrca08,l_hrca09,l_hrca10,l_hrcaud02,l_hrca11 FROM hrca_file WHERE hrca01 = l_hrca01 AND hrca13 = l_hrca13
#    SELECT hrbk05 INTO l_hrbk05 FROM hrbk_file WHERE hrbk01 = l_hrcaud02 AND hrbk03 = g_date
#   IF l_hrca03 = '1' THEN #固定班次
#      IF l_hrbk05 = '001' THEN  #工作日
#         RETURN l_hrca04
#      END IF 
#      IF l_hrbk05 = '002' THEN #假日
#         IF l_hrca08 = 'Y' THEN #改休
#            RETURN l_hrca10
#         ELSE 
#         	  RETURN l_hrca04   
#         END IF 
#      END IF 
#      IF l_hrbk05 = '003' THEN #节日
#         IF l_hrca09 = 'Y' THEN  #改休
#            RETURN l_hrca10
#         ELSE 
#         	  RETURN l_hrca04   
#         END IF 
#      END IF 
#   END IF 
#   IF l_hrca03 ='2' THEN #轮班 #默认节假日改休不跳过
#      SELECT COUNT(*) INTO l_n FROM hrbpa_file WHERE hrbpa05 = l_hrca05 #取轮班笔数
#      SELECT mod(g_date - l_hrca11,l_n) INTO l_ys FROM dual #取余
#      LET l_xz = l_ys + (l_hrca06 - 1)
#      IF l_xz > l_n THEN LET l_xz = l_xz - l_n END IF 
#      SELECT hrbpa02 INTO l_hrbpa02 FROM hrbpa_file WHERE hrbpa05 = l_hrca05  AND hrbpa01 = l_xz
#      IF l_hrbk05 = '001' THEN  #工作日
#         RETURN l_hrbpa02
#      END IF 
#      IF l_hrbk05 = '002' THEN #假日
#         IF l_hrca08 = 'Y' THEN #改休
#            RETURN l_hrca10
#         ELSE 
#         	  RETURN l_hrbpa02   
#         END IF 
#      END IF 
#      IF l_hrbk05 = '003' THEN #节日
#         IF l_hrca09 = 'Y' THEN  #改休
#            RETURN l_hrca10
#         ELSE 
#         	  RETURN l_hrbpa02   
#         END IF 
#      END IF 
#   END IF  
END FUNCTION 

FUNCTION p056_qingjia() #查找请假出差数据,节假日加班
DEFINE l_cnt   LIKE type_file.num5   
DEFINE l_sql STRING
DEFINE l_hrbm14 LIKE hrbm_file.hrbm04
DEFINE l_hrcma RECORD LIKE hrcma_file.*
DEFINE l_hrcda RECORD 
               hrcda03 LIKE hrcda_file.hrcda03,
               hrcda05 LIKE hrcda_file.hrcda05,
               hrcda06 LIKE type_file.num5,
               hrcda07 LIKE hrcda_file.hrcda07,
               hrcda08 LIKE type_file.num5
               END RECORD 
DEFINE l_hrcma05,l_hrcma07,l_hrboa02,l_hrboa05,i,l_xz LIKE type_file.num10                
   SELECT hrbo06,hrbo07 INTO g_hrbo06,g_hrbo07 FROM hrbo_file WHERE hrbo02 = g_hrcp04
   LET g_jflog = 'N'
   #请假出差
   LET l_sql="SELECT hrcda03,hrcda05,TO_NUMBER(SUBSTR(hrcda06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrcda06, 4, 2)),hrcda07,TO_NUMBER(SUBSTR(hrcda08, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrcda08, 4, 2)) FROM hrcda_file,hrcd_file",
             " WHERE hrcda02=hrcd10 AND hrcd09='",g_name,"' AND hrcda16!='Y' AND  hrcdconf = 'Y'" ,
             # "   AND (hrcda05='",g_date,"' OR hrcda05='",g_date + 1,"') ",  #mark zhaohua
              "   AND (hrcda05='",g_date,"') ",
              "   order by hrcda05,hrcda06 "
    PREPARE p056_3 FROM l_sql
    DECLARE p056_s3 CURSOR FOR p056_3
    FOREACH p056_s3 INTO l_hrcda.*          
       #休息班次是否跳过此假
       SELECT hrbm14 INTO l_hrbm14 FROM hrbm_file WHERE hrbm03 = l_hrcda.hrcda03 
       IF g_hrbo06 = 'Y' AND l_hrbm14 = 'Y' THEN 
          CONTINUE FOREACH 
       END IF 
       #判断是否和班次有交集，有交集扣减掉班段，且把扣减掉的存入请假临时表
       IF l_hrcda.hrcda05 > g_date THEN LET l_hrcda.hrcda06 = l_hrcda.hrcda06 + 1440 END IF 
       IF l_hrcda.hrcda07 > g_date THEN LET l_hrcda.hrcda08 = l_hrcda.hrcda08 + 1440 END IF 
       CALL p056_newbc(l_hrcda.hrcda03,l_hrcda.hrcda06,l_hrcda.hrcda08)
    END FOREACH  
#    #ghri054中手工录入的加班结果
#    INSERT INTO temp02  SELECT hrcn09,hrcn08*60 FROM  hrcn_file WHERE  hrcn03 = g_name and hrcn14 = g_date  
#                           AND hrcnconf = 'Y' and hrcn10 ='Y'            
    SELECT MIN(hrboa02) INTO g_hrboa02 FROM temp01
    SELECT MAX(hrboa05) INTO g_hrboa05 FROM temp01                            
    #加班计划 
    IF g_hrbo07 = 'N' THEN 
      LET l_sql = "select hrcma_file.*  from hrcma_file,hrcm_file where hrcma02 = hrcm02 and hrcmconf = 'Y' and hrcm05 = 'Y'  and hrcma04 = '",g_date,"' and hrcma03 = '",g_name,"' and hrcma09 !='015' order by hrcma04,hrcma05 "
    ELSE 
    #add zhaohua 跨夜加班只抓当天数据
      LET l_sql = "select hrcma_file.*  from hrcma_file,hrcm_file where hrcma02 = hrcm02 and hrcmconf = 'Y' and hrcm05 = 'Y'  and (hrcma04 = '",g_date,"' ) and hrcma03 = '",g_name,"' and hrcma09 !='015' order by hrcma04,hrcma05 " 
    END IF 
    #LET l_sql = "select hrcma_file.*  from hrcma_file,hrcm_file where hrcma02 = hrcm02 and hrcmconf = 'Y' and hrcm05 = 'Y'  and (hrcma04 = '",g_date,"' or hrcma04 = '",g_date +1,"') and hrcma03 = '",g_name,"' and hrcma09 !='015' order by hrcma04,hrcma05 "
    PREPARE p056_10 FROM l_sql
    DECLARE p056_10s CURSOR FOR p056_10
    FOREACH p056_10s INTO l_hrcma.*    
       SELECT TO_NUMBER(SUBSTR(l_hrcma.hrcma05, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l_hrcma.hrcma05, 4, 2)),TO_NUMBER(SUBSTR(l_hrcma.hrcma07, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l_hrcma.hrcma07, 4, 2)) INTO l_hrcma05,l_hrcma07 FROM dual
       IF l_hrcma.hrcma04 = g_date + 1 THEN #垮天处理
          LET l_hrcma05 = l_hrcma05 +1440          
       END IF
       IF l_hrcma.hrcma06 = g_date + 1 THEN #垮天处理  
          LET l_hrcma07 = l_hrcma07 +1440 
       END IF
#       IF l_hrcma05 > g_hrboa05 +360 THEN #取计划开始时间小于班次结束+4小时内 
#          CONTINUE FOREACH 
#       END IF 
#        IF l_hrcma07 < g_hrboa02  - 240 THEN #取计划结束时间小于班次开始-4小时内 
#          CONTINUE FOREACH 
#       END IF     
       
          LET g_jrjb = l_hrcma.hrcma09  
          #CALL p056_xiuxi1(l_hrcma05,l_hrcma07) RETURNING  l_xz
          LET g_jrss = l_hrcma07 - l_hrcma05   
          LET g_jcd = l_hrcma.hrcma10 
          IF cl_null(g_jcd) THEN LET g_jcd = 0 END IF  
           CALL p056_newbc(l_hrcma.hrcma09,l_hrcma05,l_hrcma07)     
    END FOREACH         
END FUNCTION 

FUNCTION p056_newbc(p_hrcda03,p_btime,p_etime)#根据差假，生成新班段

DEFINE l_sql1 STRING
DEFINE p_btime,p_etime,l_hrboa05,l_hrboa02,j,l_hrboa04,l_hrboa07   LIKE type_file.num10
DEFINE l_sum        LIKE type_file.num5
DEFINE l_hrboa03,l_hrboa06 LIKE hrboa_file.hrboa03
DEFINE p_hrcda03  LIKE hrcda_file.hrcda03
DEFINE l_hrbm02   LIKE hrbm_file.hrbm02
define l_f        like type_file.chr1
        let l_f = 'N'

         DELETE FROM temp01_t #清空备份数据 
         INSERT INTO temp01_t SELECT * FROM temp01 #备份旧班段
          LET l_sum = 0 
          SELECT hrbm02 INTO l_hrbm02 FROM hrbm_file WHERE hrbm03 = p_hrcda03
          IF l_hrbm02 !='008' THEN #处理请假
             LET l_sql1 =  " select hrboa02,hrboa03,hrboa05,hrboa06 FROM temp01_t  order by hrboa02 "      
             PREPARE p056_2 FROM l_sql1
             DECLARE p056_s2 CURSOR FOR p056_2
             FOREACH p056_s2 INTO l_hrboa02,l_hrboa03,l_hrboa05,l_hrboa06 
                IF l_hrboa02 >= p_btime AND l_hrboa05 <= p_etime THEN #请假包涵整个班段
                   LET l_sum = l_sum + (l_hrboa05 - l_hrboa02) #记录请假时数
                   DELETE FROM temp01 WHERE hrboa02 = l_hrboa02 #更新考勤班段
                END IF   
                IF l_hrboa02 < p_btime AND l_hrboa05 > p_btime AND  l_hrboa05 <= p_etime THEN 
                    LET l_sum = l_sum + (l_hrboa05 - p_btime) #记录请假时数
                    UPDATE temp01 SET hrboa05 = p_btime WHERE hrboa02 = l_hrboa02 #更新考勤班段
                END IF 
                IF l_hrboa02 < p_etime AND l_hrboa05 > p_etime AND  l_hrboa02 >= p_btime THEN 
                   LET l_sum = l_sum + ( p_etime - l_hrboa02) #记录请假时数
                   UPDATE temp01 SET hrboa02 = p_etime WHERE hrboa02 = l_hrboa02 #更新考勤班段
                END IF
                IF l_hrboa02 < p_btime AND l_hrboa05 > p_etime THEN #请假为班段内
                   LET l_sum = l_sum + (p_etime - p_btime) #记录请假时数
                   INSERT INTO  temp01 VALUES(p_etime,'Y',0,l_hrboa05,l_hrboa06,0) #请假结束必打卡
                   UPDATE temp01 SET hrboa05 = p_btime,hrboa06 ='Y' WHERE hrboa02 = l_hrboa02 #请假开始必打卡
                END IF
             END FOREACH  
            #保存请假数据
             IF l_sum >0 THEN 
                INSERT INTO temp02 VALUES(p_hrcda03,l_sum)
             END IF   
          ELSE #节假日加班
#             LET l_sql1 =  " select hrboa02,hrboa03,hrboa04,hrboa05,hrboa06,hrboa07 FROM temp01_t  order by hrboa02 "      
#             PREPARE p056_13 FROM l_sql1
#             DECLARE p056_s13 CURSOR FOR p056_13
#             FOREACH p056_s13 INTO l_hrboa02,l_hrboa03,l_hrboa04,l_hrboa05,l_hrboa06,l_hrboa07 
#                IF l_hrboa02 >= p_btime AND l_hrboa05 <= p_etime THEN #请假包涵整个班段
#                  IF l_hrboa02 = g_hrboa02 THEN #第一笔
#                     IF l_hrboa05 = g_hrboa05 THEN #最后一笔 
#                        INSERT INTO temp05 VALUES(p_btime,l_hrboa03,l_hrboa04,p_etime,l_hrboa06,l_hrboa07)
#                   
#                    ELSE 
#                     	  INSERT INTO temp05 VALUES(p_btime,l_hrboa03,l_hrboa04,l_hrboa05,l_hrboa06,l_hrboa07)
#                     END IF 
#                  ELSE 
#                  	 IF l_hrboa05 = g_hrboa05 THEN #最后一笔
#                        INSERT INTO temp05 VALUES(l_hrboa02,l_hrboa03,l_hrboa04,p_etime,l_hrboa06,l_hrboa07)
#                     ELSE 
#                     	  INSERT INTO temp05 VALUES(l_hrboa02,l_hrboa03,l_hrboa04,l_hrboa05,l_hrboa06,l_hrboa07)   	
#                     END IF 
#                  END IF 	
#                  let l_f = 'Y'
#                  END IF   
#                IF l_hrboa02 < p_btime AND l_hrboa05 > p_btime AND  l_hrboa05 <= p_etime THEN 
#                  let l_f = 'Y'
#                      IF l_hrboa05 = g_hrboa05 THEN #最后一笔
#                      INSERT INTO temp05 VALUES(p_btime,l_hrboa03,l_hrboa04,l_hrboa05,l_hrboa06,l_hrboa07)
#                   ELSE 
#                    	 INSERT INTO temp05 VALUES(p_btime,l_hrboa03,l_hrboa04,p_etime,l_hrboa06,l_hrboa07)
#                   END IF 
#                END IF 
#                IF l_hrboa02 < p_etime AND l_hrboa05 > p_etime AND  l_hrboa02 >= p_btime THEN 
#                   let l_f = 'Y' 
#                  IF l_hrboa02 = g_hrboa02 THEN #第一笔
#                      INSERT INTO temp05 VALUES(p_btime,l_hrboa03,l_hrboa04,p_etime,l_hrboa06,l_hrboa07)
#                   ELSE 
#                      INSERT INTO temp05 VALUES(l_hrboa02,l_hrboa03,l_hrboa04,p_etime,l_hrboa06,l_hrboa07)	
#                   END IF                 END IF
#                IF l_hrboa02 < p_btime AND l_hrboa05 > p_etime THEN #请假为班段内
#                   let l_f = 'Y'
#                   INSERT INTO temp05 VALUES(p_btime,l_hrboa03,l_hrboa04,p_etime,l_hrboa06,l_hrboa07)
#                END IF
#                #无交集
#                IF l_hrboa02 > p_etime OR  l_hrboa05 < p_btime THEN 
#                  #  INSERT INTO temp05 VALUES(p_btime,'Y',120,p_etime,'Y',120)
#                END IF 
#             END FOREACH        	
             if l_f ='N' then
                INSERT INTO temp05 VALUES(p_btime,'Y',120,p_etime,'Y',120)
             end if  
         END IF  
          
       
END FUNCTION

FUNCTION p056_oldbc()#初始班段
 #班次开始结束时间
 
 SELECT TO_NUMBER(SUBSTR(hrbo04, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrbo04, 4, 2)),TO_NUMBER(SUBSTR(hrbo05, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrbo05, 4, 2)) INTO g_hrbo04,g_hrbo05
   FROM hrbo_file 
  WHERE hrbo02 = g_hrcp04
  #将班段插入临时表
    INSERT INTO temp01  SELECT TO_NUMBER(SUBSTR(hrboa02, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrboa02, 4, 2)),hrboa03,hrboa04,TO_NUMBER(SUBSTR(hrboa05, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrboa05, 4, 2)),hrboa06,hrboa07
         FROM hrboa_file
        WHERE hrboa15 = g_hrcp04
          AND hrboa08 = '001'
  #将休息班段插入临时表
    INSERT INTO temp04  SELECT TO_NUMBER(SUBSTR(hrboa02, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrboa02, 4, 2)),TO_NUMBER(SUBSTR(hrboa05, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrboa05, 4, 2))
         FROM hrboa_file
        WHERE hrboa15 = g_hrcp04
          AND (hrboa08 = '002' OR hrboa08 = '004' )
    #更新跨天休息班段
    UPDATE temp04 SET restb = restb + 1440
     WHERE restb < g_hrbo04
    UPDATE temp04 SET reste = reste + 1440
     WHERE reste < g_hrbo04   	         
 #更新跨天班段
 UPDATE temp01 SET hrboa02 = hrboa02 + 1440
  WHERE hrboa02 < g_hrbo04
 UPDATE temp01 SET hrboa05 = hrboa05 + 1440
  WHERE hrboa05 < g_hrbo04 
 IF g_hrbo05 <   g_hrbo04 THEN LET  g_hrbo05 = g_hrbo05 + 1440 END IF            
END FUNCTION 

FUNCTION p056_zhuangtai()#用于处理每一个班段，迟到早退旷工情况
DEFINE l_sql1,l_sql STRING
DEFINE l_i,l_j,l_sk,l_n1,l_n2,j LIKE type_file.num5
DEFINE l_boa DYNAMIC ARRAY OF RECORD 
       hrboa02 LIKE type_file.num5,
       hrboa03 LIKE hrboa_file.hrboa03,
       hrboa04 LIKE hrboa_file.hrboa04,     
       hrboa05 LIKE type_file.num5,
       hrboa06 LIKE hrboa_file.hrboa06,
       hrboa07 LIKE hrboa_file.hrboa07        
 
       END RECORD 
DEFINE l_boa1 DYNAMIC ARRAY OF RECORD 
       hrboa02 LIKE hrboa_file.hrboa02,
       hrboa04 LIKE hrboa_file.hrboa04,        
       hrboa05 LIKE hrboa_file.hrboa05,
       hrboa07 LIKE hrboa_file.hrboa07,       
       jb      LIKE type_file.chr10 #加班段标识
       
       END RECORD        
DEFINE l_k,l_k1 LIKE type_file.chr1
DEFINE l_s      LIKE type_file.chr100
DEFINE l_date,l_date1,l_date2 LIKE type_file.dat
DEFINE l_hrby06_z,l_hrby06_z1,l_hrby06_z2,l_n LIKE type_file.num10
DEFINE l_hrby06,l_hrby06_1,l_hrby06_2 LIKE hrby_file.hrby06
#DEFINE l_hrpc22 LIKE hrby_file.hrby06 #add zhaohua
DEFINE l_hrcma RECORD LIKE hrcma_file.*
DEFINE l_hrcma05,l_hrcma07,l_hrboa02,l_hrboa05,i LIKE type_file.num10                
DEFINE l_hrbo10  LIKE hrbo_file.hrbo10
DEFINE m    INTEGER 
DEFINE l_zh LIKE type_file.num10
DEFINE l_time           LIKE type_file.num10
DEFINE l_begin          LIKE type_file.num10
DEFINE l_over           LIKE type_file.num10
DEFINE l_hrcma05_1      LIKE type_file.num10
DEFINE l_hrcma07_1      LIKE type_file.num10
DEFINE l_hrcma10        LIKE type_file.num10
DEFINE l_hrcma08        LIKE type_file.num10
DEFINE l_yushu          LIKE type_file.num10
DEFINE l_restb          LIKE hrboa_file.hrboa02 #add by nixiang 170621
DEFINE l_reste          LIKE hrboa_file.hrboa05 #add by nixiang 170621


    
    LET l_i = 1 
    LET l_j = 1  
    LET l_sk = 21
  

   #整理新班次中取卡范围
   SELECT COUNT(*) INTO l_n1 FROM temp05
   IF l_n1 >0 THEN #节假日有加班计划时
      LET l_sql1 ="select distinct * from temp05 order by hrboa02 "
   ELSE 
    	LET l_sql1 ="select distinct  * from temp01 order by hrboa02 "
   END IF 	
   PREPARE p056_1 FROM l_sql1
   DECLARE p056_s1 CURSOR FOR p056_1
   #add by wangyuz 171013    str 
    INITIALIZE l_boa[l_i].* TO NULL
    INITIALIZE l_boa1[l_i].* TO NULL
     #add by wangyuz 171013    end 
   FOREACH p056_s1 INTO l_boa[l_i].*
      IF l_i = 1 THEN #第一班段时，开始必刷卡
         LET l_boa[l_i].hrboa03 = 'Y' 
      ELSE 
         IF l_boa[l_i-1].hrboa03 ='Y' AND l_boa[l_i-1].hrboa06 ='Y' AND l_boa[l_i-1].hrboa05 != l_boa[l_i].hrboa02 THEN #上笔开始结束都刷卡
      	    LET l_boa1[l_j].hrboa02 = l_boa[l_i-1].hrboa02
      	    IF l_i = 2 THEN #第二笔时，上一笔提前取刷卡是系统设置的
      	       LET l_boa1[l_j].hrboa04 = l_boa[l_i-1].hrboa04
      	    ELSE #上一笔不是第一时，提前取刷卡为上笔开始减上上笔结束
      	    	 LET l_boa1[l_j].hrboa04 = l_boa[l_i-1].hrboa02 - l_boa[l_i-2].hrboa05 
      	    END IF 
      	    LET l_boa1[l_j].hrboa05 = l_boa[l_i-1].hrboa05      	    
      	    #上一笔不结束取刷卡为本笔开始减上笔结束
      	    LET l_boa1[l_j].hrboa07 = l_boa[l_i].hrboa02 - l_boa[l_i-1].hrboa05        	       
      	    LET l_j = l_j +1        
         END IF       	
      	 IF l_boa[l_i-1].hrboa06 ='N' OR l_boa[l_i-1].hrboa05 = l_boa[l_i].hrboa02 THEN #当上一笔下班不打卡或上一笔结束等于这一笔开始时，把当前笔和上一笔合并
      	    IF l_boa[l_i-1].hrboa05 <  l_boa[l_i].hrboa02 THEN   #有间隙 	    
               INSERT INTO temp04 VALUES(l_boa[l_i-1].hrboa05,l_boa[l_i].hrboa02)#储存休息段
            END IF 
      	    LET l_boa[l_i-1].hrboa02 = l_boa[l_i-1].hrboa02
      	    LET l_boa[l_i-1].hrboa03 = l_boa[l_i-1].hrboa03
      	    LET l_boa[l_i-1].hrboa04 = l_boa[l_i-1].hrboa04
      	    LET l_boa[l_i-1].hrboa05 = l_boa[l_i].hrboa05 
      	    LET l_boa[l_i-1].hrboa06 = l_boa[l_i].hrboa06
      	    LET l_boa[l_i-1].hrboa07 = l_boa[l_i].hrboa07  
            CONTINUE FOREACH 
      	 END IF  
      END IF 
      LET l_i = l_i +1
   END FOREACH 
   #最后一笔处理
   IF l_i >1 THEN  #有待处理的班段时
      LET l_boa[l_i-1].hrboa06 ='Y' #最后一笔结束必打卡
      IF l_boa[l_i-1].hrboa03 ='Y' AND l_boa[l_i-1].hrboa06 ='Y' THEN #上笔开始结束都刷卡
         LET l_boa1[l_j].hrboa02 = l_boa[l_i-1].hrboa02
         IF l_i = 2 THEN #第二笔时，上一笔提前取刷卡是系统设置的
            LET l_boa1[l_j].hrboa04 = l_boa[l_i-1].hrboa04
         ELSE #上一笔不是第一时，提前取刷卡为上笔开始减上上笔结束
         	 LET l_boa1[l_j].hrboa04 = l_boa[l_i-1].hrboa02 - l_boa[l_i-2].hrboa05 
         END IF 
         LET l_boa1[l_j].hrboa05 = l_boa[l_i-1].hrboa05      	    
         #上一笔不结束取刷卡为本笔开始减上笔结束
         #班次上没有跨夜，但是加班单上填单跨夜
        IF g_hrbo07 = 'N' THEN  #add zhaohua
            LET l_sql = "select COUNT(*) from hrcma_file,hrcm_file where hrcma02 = hrcm02 and hrcmconf = 'Y' and hrcm05 = 'Y'  and hrcma04 = '",g_date,"' and hrcma03 = '",g_name,"' and hrcma09 !='015' order by hrcma04,hrcma05 "
            PREPARE p056_10z FROM l_sql
            DECLARE p056_10h CURSOR FOR p056_10z
            FOREACH p056_10h INTO l_zh  
            IF l_zh > 0 THEN
                LET  l_boa1[l_j].hrboa04 = l_boa1[l_j].hrboa04+1440
            LET l_zh = 0
            END IF
            END FOREACH
        --ELSE
            --LET  l_boa1[l_j].hrboa04 = l_boa1[l_j].hrboa04+1440
        END IF
         IF l_n1 = 0 THEN          
         #   LET l_boa1[l_j].hrboa07 = l_boa[l_i-1].hrboa07 + (g_hrbo05 - l_boa[l_i-1].hrboa05) 
         --LET l_boa1[l_j].hrboa07 = l_boa[l_i-1].hrboa07 + l_boa[l_i-1].hrboa05
         --ELSE  #zhaohua
         	  LET l_boa1[l_j].hrboa07 = l_boa[l_i-1].hrboa07
         END IF 	
      END IF  
   END IF
   SELECT COUNT(*) INTO l_n2 FROM temp01
   IF g_hrcp04='B010' AND g_hrbo07='Y' AND l_n2 = 0 THEN 
        CALL l_boa1.deleteElement(l_j+1)
   END IF 
   SELECT count(*) INTO l_n1 FROM temp05
   IF g_hrcp04='REST' AND g_hrbo07='Y' AND l_n1 > 0 THEN 
         CALL l_boa1.deleteElement(l_j+1)
   END IF 
   #加班计划
   #ghri53,015延时加班计划处理
   IF g_hrbo06 = 'N' THEN 
      LET l_sql = "select hrcma_file.*  from hrcma_file,hrcm_file where hrcma02 = hrcm02 and hrcmconf = 'Y' and hrcm05 = 'Y'  and (hrcma04 = '",g_date,"') and hrcma09 = '015' and hrcma03 = '",g_name,"' order by hrcma04,hrcma05"
      PREPARE p056_11 FROM l_sql
      DECLARE p056_11s CURSOR FOR p056_11
      FOREACH p056_11s INTO l_hrcma.*    
         SELECT TO_NUMBER(SUBSTR(l_hrcma.hrcma05, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l_hrcma.hrcma05, 4, 2)),TO_NUMBER(SUBSTR(l_hrcma.hrcma07, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l_hrcma.hrcma07, 4, 2)) INTO l_hrcma05,l_hrcma07 FROM dual
         LET g_jflog = 'Y' #加班计划 
         IF l_hrcma.hrcma04 = g_date + 1 THEN #垮天处理
            LET l_hrcma05 = l_hrcma05 +1440          
         END IF
         IF l_hrcma.hrcma06 = g_date + 1 THEN #垮天处理
            LET l_hrcma07 = l_hrcma07 +1440          
         END IF
         IF l_hrcma05 > g_hrboa05 +240 THEN #取计划开始时间小于班次结束+4小时内 
            CONTINUE FOREACH 
         END IF 
         IF l_hrcma05 < g_hrboa02 THEN #取计划开始时间大于班次开始时间
            CONTINUE FOREACH 
         END IF           
         LET j = l_boa1.getlength()+1             
         LET  l_boa1[j].hrboa02 = l_hrcma05
         IF l_boa1.getlength() > 0 THEN      
            IF l_hrcma05 <= g_hrboa05 THEN #连班
               
               LET  l_boa1[j].jb = 'YN'   #标识为加班段,开始不打卡   
               LET  l_boa1[j].hrboa04 = 0
            ELSE 
               LET  l_boa1[j].hrboa04 = l_hrcma05 - l_boa1[l_boa1.getlength()].hrboa05
               LET  l_boa1[j].jb = 'YY'#标识为加班段,开始打卡 
            END IF 
         ELSE 
         	  LET  l_boa1[j].hrboa04 =  120 
         	  LET  l_boa1[j].jb = 'YY'   #标识为加班段,开始打卡         	   
         END IF 
         LET  l_boa1[j].hrboa05 = l_hrcma07
         LET  l_boa1[j].hrboa07 = 240   
       #  LET g_jflog = 'Y' #加班计划      
      END FOREACH  
   END IF      
   #匹配刷卡
   IF l_boa1.getlength()>0  THEN 
      #  IF g_hrcp04='B010' THEN 
      #      LET m=l_boa1.getlength()-1
          #  LET l_hrcp40='3.000'
      #  ELSE 
      #      LET m=l_boa1.getlength()
      #  END IF 
      FOR l_i = 1 TO l_boa1.getlength()    
         IF l_boa1[l_i].jb !='YN' OR cl_null(l_boa1[l_i].jb) THEN #加班开始不打卡
            LET l_k = 'N'       
            LET l_sql = " select hrby05,hrby06,TO_NUMBER(SUBSTR(hrby06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrby06, 4, 2)) a from hrby_file ",
                        "  where  hrby09 = '",g_name,"'    AND hrby05 = '",g_date,"' AND hrby11 IN('1','6') AND hrbyacti = 'Y'  and (hrby03 in ('1','2','3','4','5','6','7','8','9','10','18','20') or hrby12='2') "                    
            --IF l_boa1[l_i].hrboa02 - l_boa1[l_i].hrboa04 < 0 THEN #提前跨天
               --LET l_sql = l_sql," union all ",
                                  --" select hrby05,hrby06,TO_NUMBER(SUBSTR(hrby06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrby06, 4, 2)) - 1440 a from hrby_file ",
                                  --"  where  hrby09 = '",g_name,"'    AND hrby05 = '",g_date -1 ,"'   AND hrby11 IN('1','6') AND hrbyacti = 'Y' and (hrby03 in ('1','2','3','4','5','6','7','8','9','10','18','20') or hrby12='2') "                                
            --END IF 

            #IF l_boa1[l_i].hrboa02 >=1440 OR l_boa1[l_i].hrboa05 >=1440 OR l_boa1[l_i].hrboa05 + l_boa1[l_i].hrboa07 >=1440 THEN 
            #   LET l_sql = l_sql," union all ",
            #                      " select hrby05,hrby06,TO_NUMBER(SUBSTR(hrby06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrby06, 4, 2)) + 1440 a from hrby_file ",
            #                      "  where  hrby09 = '",g_name,"'    AND hrby05 = '",g_date + 1 ,"'   AND hrby11 IN('1','6') AND hrbyacti = 'Y' and (hrby03 in ('1','2','3','4','5','6','7','8','9','10') or hrby12='2') "   
            #END IF 
            #取上班卡
            LET l_sql = l_sql," order by a "
            PREPARE p056_4 FROM l_sql
            DECLARE p056_4s CURSOR FOR p056_4
            FOREACH  p056_4s INTO l_date,l_hrby06,l_hrby06_z
               #不在刷卡范围内的，跳过
               IF cl_null(l_boa1[l_i].hrboa02) OR cl_null(l_boa1[l_i].hrboa04) THEN
                   CONTINUE FOREACH 
               END IF 
          
              IF (l_hrby06_z < l_boa1[l_i].hrboa02 - l_boa1[l_i].hrboa04) OR (l_hrby06_z >  l_boa1[l_i].hrboa05) THEN    
 
                  CONTINUE FOREACH 
               END IF 
               #add by wangyuz 171016 str     
                IF g_hrcp04="B011" AND (l_hrby06_z < l_boa1[l_i].hrboa02 - l_boa1[l_i].hrboa04 )OR (l_hrby06_z > = l_boa1[l_i].hrboa05)  THEN    
 
                  CONTINUE FOREACH 
               END IF
               #add by wangyuz 171016 end 
               #刷卡被占用，跳过
               SELECT COUNT(*) INTO l_n FROM temp03
                WHERE t3 = l_hrby06_z
               IF l_n >0 THEN 
                  CONTINUE FOREACH
               END IF  
               IF l_hrby06_z > l_boa1[l_i].hrboa02  THEN #卡为异常卡
                  IF l_k = 'Y' THEN #有正常卡退出
                     EXIT FOREACH 
                  ELSE #无正常卡，第一笔异常卡保存退出
                     LET l_date1 = l_date
                     LET l_hrby06_1  = l_hrby06
                     LET l_hrby06_z1  = l_hrby06_z 
                     LET l_k = 'Y'  
                     EXIT FOREACH             	     
                  END IF 
               END IF 
               IF l_hrby06_z <= l_boa1[l_i].hrboa02 THEN  #卡为正常卡先备份
                  LET l_date1 = l_date
                  LET l_hrby06_1  = l_hrby06
                  LET l_hrby06_z1  = l_hrby06_z
                  LET l_k = 'Y'
               END IF 
       
            END FOREACH  
            
            IF l_k = 'Y' THEN #取到卡时，保存
               INSERT INTO temp03 VALUES(l_date1,l_hrby06_1,l_hrby06_z1)
            ELSE 
         	     LET l_hrby06_1 = ''   
            END IF   
            #更新刷卡到hrcp_file中     
            LET l_sk = l_sk + 1 
            LET l_s = l_sk
            LET l_s='hrcp',l_s
            LET l_sql="UPDATE hrcp_file SET ",l_s,"='",l_hrby06_1,"'",
                     " WHERE hrcp02='",g_name,"' AND hrcp03='",g_date,"'"
            PREPARE upd_pk_1 FROM l_sql
            EXECUTE upd_pk_1
         END IF    
         #取下班卡
         --IF g_hrbo07 = 'Y' THEN  
            --LET l_boa1[l_i].hrboa02 = l_boa1[l_i].hrboa02 - 1440  
         --END IF
         LET l_k1 = 'N'
         LET l_sql = " select hrby05,hrby06,TO_NUMBER(SUBSTR(hrby06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrby06, 4, 2)) a from hrby_file ",
                     "  where  hrby09 = '",g_name,"'    AND hrby05 = '",g_date,"' AND hrby11 IN('1','6') AND hrbyacti = 'Y' and (hrby03 in ('1','2','3','4','5','6','7','8','9','10','18','20') or hrby12='2') " #mark zhaohua                   
       #modify by zyq --170828--
       IF l_boa1[l_i].hrboa02 >=1440 OR l_boa1[l_i].hrboa05 >=1440 OR l_boa1[l_i].hrboa07 >=1440 THEN #add zhaohua
      #    IF l_boa1[l_i].hrboa02 >=1440 OR l_boa1[l_i].hrboa05 >=1440 OR l_boa1[l_i].hrboa05+l_boa1[l_i].hrboa07 >=1440 THEN #modi by nixiang170731 #mark zyq
      #      LET l_sql = " select hrby05,hrby06,TO_NUMBER(SUBSTR(hrby06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrby06, 4, 2)) + 1440  a from hrby_file ",   #mark zyq
      #                         "  where  hrby09 = '",g_name,"'    AND hrby05 = '",g_date + 1,"'   AND hrby11 IN('1','6') AND hrbyacti = 'Y' and (hrby03 in ('1','2','3','4','5','6','7','8','9','10') or hrby12='2') " #mark zyq  
              LET l_sql = l_sql," union all ",
                                 " select hrby05,hrby06,TO_NUMBER(SUBSTR(hrby06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrby06, 4, 2)) + 1440  a from hrby_file ",
                               "  where  hrby09 = '",g_name,"'    AND hrby05 = '",g_date + 1,"'   AND hrby11 IN('1','6') AND hrbyacti = 'Y' and (hrby03 in ('1','2','3','4','5','6','7','8','9','10','18','20') or hrby12='2') "   
      #   END IF #mark zyq
      END IF 
      #modify by zyq --170828--
        
         LET l_sql = l_sql," order by a desc  "
         PREPARE p056_5 FROM l_sql
         DECLARE p056_5s CURSOR FOR p056_5
         FOREACH  p056_5s INTO l_date,l_hrby06,l_hrby06_z
             LET l_k1 = 'N'  #add by wangyuz 171013 
            #add by zyq 170828 --start--
            IF cl_null(l_boa1[l_i].hrboa07) THEN 
            LET l_boa1[l_i].hrboa07 = 0
            END IF
            #add by zyq 170828 --end--
           #add by wangyuz 171013 str 
           IF g_hrcp04 ="B001" THEN 
              LET l_boa1[l_i].hrboa07  = 480
           END IF 
           IF g_hrcp04 ="B004" THEN 
            LET l_boa1[l_i].hrboa07  = 360
            LET l_boa1[l_i].hrboa05  = 990
           END IF 
            #不在刷卡范围内的，跳过
       
           IF (l_hrby06_z > l_boa1[l_i].hrboa05 + l_boa1[l_i].hrboa07) OR (l_hrby06_z <  l_boa1[l_i].hrboa02 + 180) THEN     
              CONTINUE FOREACH               
           END IF                   
   
            IF l_boa1[l_i].jb !='YN' THEN #连班时，最后一笔可重复
               SELECT COUNT(*) INTO l_n FROM temp03
                WHERE t3 = l_hrby06_z            
               IF l_n >0 THEN #刷卡被占用，跳过
                  CONTINUE FOREACH
               END IF  
            END IF 
            IF l_hrby06_z < l_boa1[l_i].hrboa05   THEN #卡为异常卡
               IF l_k1 = 'Y' THEN #有正常卡退出
                  EXIT FOREACH 
               ELSE #无正常卡，第一笔异常卡保存退出
                  LET l_date2 = l_date
                  LET l_hrby06_2  = l_hrby06
                  LET l_hrby06_z2  = l_hrby06_z 
                  LET l_k1 = 'Y'  
                  EXIT FOREACH             	     
               END IF 
            END IF 
            IF l_hrby06_z >= l_boa1[l_i].hrboa05  THEN  #卡为正常卡先备份
               LET l_date2 = l_date
               LET l_hrby06_2  = l_hrby06
               LET l_hrby06_z2  = l_hrby06_z
               LET l_k1 = 'Y'
               EXIT FOREACH 
            END IF             
         END FOREACH 
         IF l_k1 = 'Y' THEN #取到卡时，保存
            INSERT INTO temp03 VALUES(l_date2,l_hrby06_2,l_hrby06_z2) 
         ELSE  #marc zhaohua   #modify by zyq 170828
#         	  LET l_hrby06_2 = l_hrby06   #modify by zyq 170828          #mark by waangyuz 170929 
              LET l_hrby06_2 =  ''                                       #add by wnangyuz  170929 

         END IF 
         #更新刷卡到hrcp_file中  
         IF l_boa1[l_i].jb ='YN' AND l_k1 = 'Y'  THEN  #连班替换卡
         ELSE 
            --LET l_sk = l_sk + 1  
         END IF 
         LET l_s = l_sk
         LET l_s='hrcp',l_s
         LET l_sql=" UPDATE hrcp_file SET hrcp23 = '",l_hrby06_2,"'",  #add zhaohua 
                   " WHERE hrcp02='",g_name,"' AND hrcp03='",g_date,"'"
         PREPARE upd_pk_2 FROM l_sql
         EXECUTE upd_pk_2   
         SELECT hrbo10 INTO l_hrbo10 FROM hrbo_file WHERE hrbo02 = g_hrcp04       
         #mark by wangyuz 170928 str 
         #add by zyq 170828 --start--
#         IF g_hrcp04='REST' AND l_s IS NOT NULL THEN
#         #  SELECT hrby06 INTO l_hrby06_2 FROM hrby_file WHERE hrby05 = g_date + 1 AND (TO_NUMBER(SUBSTR(hrby06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrby06, 4, 2)))<1200
#           UPDATE hrcp_file SET hrcp41 = 11 WHERE hrcp02 = g_name AND hrcp03 = g_date
#         END IF
         #add by zyq 170828 --end--
         #mark by wangyuz 170928   end 
         IF l_i = l_boa1.getlength() AND NOT cl_null(l_hrby06_2) AND l_hrbo10 = 'Y' THEN #最后一笔下班卡
            IF g_jflog = 'N' AND  l_hrby06_z2 - g_hrboa05 >=30 THEN #依刷卡加班
            #add by nixiang 170621 减掉加班就餐时长---s---
               SELECT restb,reste INTO l_restb,l_reste FROM (SELECT restb,reste FROM temp04 ORDER BY restb DESC )WHERE ROWNUM=1
               IF l_restb >= g_hrboa05 AND l_reste <= l_hrby06_z2 THEN
                  LET l_hrby06_z2 = l_hrby06_z2 - (l_reste - l_restb)                                    
               END IF 
            #add by nixiang 170621 减掉加班就餐时长---e---
               IF l_hrby06_z2 - g_hrboa05 >180 THEN 
                  INSERT INTO temp02 VALUES('015',180)
               
               ELSE 
               	  INSERT INTO temp02 VALUES('015',l_hrby06_z2 - g_hrboa05)
             
               END IF 	
            END IF 
         END IF
         IF l_i = l_boa1.getlength() AND NOT cl_null(l_hrby06_2) AND l_hrbo10 = 'Y' AND g_jflog = 'Y' THEN #最后一笔下班卡
             LET l_sql = "select hrcma_file.*  from hrcma_file,hrcm_file where hrcma02 = hrcm02 and hrcmconf = 'Y' and hrcm05 = 'Y'  and hrcma04 = '",g_date,"' and hrcma03 = '",g_name,"' order by hrcma04,hrcma05 "   
             PREPARE p056_10e FROM l_sql
             DECLARE p056_10u CURSOR FOR p056_10e
             FOREACH p056_10u INTO l_hrcma.* 
                 LET l_hrcma05_1 = '0' 
                 LET l_hrcma07_1 = '0'
                 LET l_hrcma10 = '0' 
                 LET l_hrcma08 = '0' 
                 SELECT TO_NUMBER(SUBSTR(l_hrcma.hrcma05, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l_hrcma.hrcma05, 4, 2)),TO_NUMBER(SUBSTR(l_hrcma.hrcma07, 1, 2)) * 60 + TO_NUMBER(SUBSTR(l_hrcma.hrcma07, 4, 2)) INTO l_hrcma05_1,l_hrcma07_1 FROM dual
                 SELECT SUBSTR(l_hrcma.hrcma10, 1, 1) * 60 + SUBSTR(l_hrcma.hrcma10, 3, 1) * 6 INTO l_hrcma10 FROM dual
                 SELECT SUBSTR(l_hrcma.hrcma08, 1, 1) * 60 + SUBSTR(l_hrcma.hrcma08, 3, 1) * 6 INTO l_hrcma08 FROM dual
                 IF l_hrby06_z2 < l_hrcma07_1 THEN
                    LET l_over = l_hrby06_z2
                 ELSE 
                    LET l_over = l_hrcma07_1
                 END IF
                 --IF l_hrby06_z > l_hrcma05_1 THEN
                    --LET l_begin = l_hrby06_z
                 --ELSE 
                    --LET l_begin = l_hrcma05_1
                 --END IF
                 LET l_time = l_over - l_hrcma05_1 #- l_hrcma10
               #add by nixiang 170621 减掉加班就餐时长---s---
               SELECT restb,reste INTO l_restb,l_reste FROM (SELECT restb,reste FROM temp04 ORDER BY restb DESC )WHERE ROWNUM=1
               IF l_restb >= g_hrboa05 AND l_reste <= l_over THEN
                  LET l_time = l_time - (l_reste - l_restb)                                    
               END IF 
               #add by nixiang 170621 减掉加班就餐时长---e---
                 SELECT MOD(l_time,60) INTO l_yushu FROM dual
                 IF l_yushu >=30 THEN
                     LET l_yushu = 30
                 ELSE 
                     LET l_yushu = 0
                 END IF
                 SELECT l_time - MOD(l_time,60) INTO l_time FROM dual
                 LET l_time = l_time + l_yushu
                 IF l_time < 0 THEN
                     LET l_time = l_time + 1440 - 60
                     INSERT INTO temp02 VALUES('016',l_time)  
                 ELSE
                     INSERT INTO temp02 VALUES('015',l_time)           
                 END IF
              END FOREACH
           END IF
         
         #处理延时加班数据
         #add by nixiang 170621 修正 依照刷卡加班并填写了加班计划后会重复计算加班时间的问题---s---
         IF l_hrbo10 = 'Y'  THEN 
            ELSE 
         IF l_boa1[l_i].jb ='YN' THEN #连班
            SELECT COUNT(*) INTO l_n FROM temp03 
            IF l_k1 = 'Y' AND l_n > 1 THEN #非当天第一笔卡时，才处理连班
               IF l_hrby06_z2 > l_boa1[l_i].hrboa05 THEN 
                  CALL p056_xiuxi('015',l_boa1[l_i].hrboa02,l_boa1[l_i].hrboa05)  
               ELSE 
               	  CALL p056_xiuxi('015',l_boa1[l_i].hrboa02,l_hrby06_z2)    
               END IF 
            END IF 
            IF l_k1 = 'N' AND l_n > 1 THEN #非当天第一笔卡时，才处理连班
               SELECT MAX(t3) INTO l_hrby06_z2 FROM temp03
               IF l_hrby06_z2 > l_boa1[l_i].hrboa05 THEN 
                  CALL p056_xiuxi('015',l_boa1[l_i].hrboa02,l_boa1[l_i].hrboa05)  
               ELSE 
               	  CALL p056_xiuxi('015',l_boa1[l_i].hrboa02,l_hrby06_z2)    
               END IF 
            END IF 
         END IF  
         IF l_boa1[l_i].jb ='YY' THEN #非连班
            IF l_k1 ='Y' AND l_k = 'Y' THEN 
               IF l_hrby06_z2 > l_boa1[l_i].hrboa05 THEN LET l_hrby06_z2 = l_boa1[l_i].hrboa05 END IF 
               IF l_hrby06_z1 < l_boa1[l_i].hrboa02 THEN LET l_hrby06_z1 = l_boa1[l_i].hrboa02 END IF 
               CALL p056_xiuxi('015',l_hrby06_z1,l_hrby06_z2) 
            END IF 
         END IF 
       END IF 
       #add by nixiang 170621 修正 依照刷卡加班并填写了加班计划后会重复计算加班时间的问题---e---
         #处理考勤异常
         IF g_hrat90 ='003' AND cl_null(l_boa1[l_i].jb) THEN #机器考勤人员需要核算异常
            #班段缺卡
            IF l_k = 'N' OR l_k1 = 'N' THEN #缺上班卡或下班卡
              #CALL p056_xiuxi('001',l_boa1[l_i].hrboa02,l_boa1[l_i].hrboa05)
              #modi by nixiang170801 缺卡应归类为旷工----s----
               LET g_qk = 'Y' #记为缺卡
               CALL p056_xiuxi('003',l_boa1[l_i].hrboa02,l_boa1[l_i].hrboa05)
               LET g_qk = 'N'
              #modi by nixiang170801 此处应归类为旷工----s----           
            END IF 
            #取到两笔卡  
            IF g_hrbo06 = 'Y' THEN #休息日不考虑休息段
               DELETE FROM temp04
            END IF 
            IF l_k ='Y' AND l_k1 = 'Y' THEN 
               IF l_boa1[l_i].hrboa02 < l_hrby06_z1 THEN  #迟到
                  CALL p056_xiuxi('001',l_boa1[l_i].hrboa02,l_hrby06_z1)
               END IF 
               IF l_boa1[l_i].hrboa05 > l_hrby06_z2 THEN  #早退
                  CALL p056_xiuxi('002',l_hrby06_z2,l_boa1[l_i].hrboa05)
               END IF 
            END IF 
         END IF           
      END FOR     
   END IF      
END FUNCTION 

FUNCTION p056_tiaoxiu(p_hrbm03,p_ss)#用以处理加班生成调休数据
DEFINE l_sql  STRING
DEFINE l_hrci RECORD LIKE hrci_file.*
DEFINE p_hrbm03 LIKE hrbm_file.hrbm03
DEFINE p_ss     LIKE hrcp_file.hrcp10
DEFINE l_n      LIKE type_file.num5
DEFINE l_hrbm25 LIKE hrbm_file.hrbm25
DEFINE l_hrbm23 LIKE hrbm_file.hrbm23
DEFINE l_hrci10 LIKE hrci_file.hrci10
DEFINE  l_hrat04 like hrat_file.hrat04
  SELECT COUNT(*) INTO l_n FROM hrci_file 
   WHERE hrci02 = g_name
     AND hrci03 = g_date
  IF l_n = 0 THEN    
     SELECT to_char(MAX(to_number(hrci01))+ 1 ) INTO  l_hrci.hrci01 FROM hrci_file 
     IF cl_null(l_hrci.hrci01) THEN 
        LET l_hrci.hrci01 = '1'
     END IF      
     LET l_hrci.hrci02 = g_name
     LET l_hrci.hrci03 = g_date
     LET l_hrci.hrci04 = p_hrbm03
     LET l_hrci.hrci05 = p_ss
     LET l_hrci.hrci06 = 0
     LET l_hrci.hrci07 = p_ss
     LET l_hrci.hrci08 = 0
     LET l_hrci.hrci09 = p_ss
     SELECT hrbm25,hrbm23 INTO l_hrbm25,l_hrbm23 FROM hrbm_file WHERE hrbm03 = p_hrbm03
     IF l_hrbm23 ='Y' THEN #是否调休
        SELECT hrat04 INTO l_hrat04 FROM hrat_file WHERE hrat01 = g_name
        SELECT  last_day(g_date) INTO l_hrci.hrci10 FROM  dual  
        IF l_hrat04 = '103005' THEN #技术部
           SELECT add_months(trunc(g_date,'YYYY'),12)-1 INTO l_hrci.hrci10 FROM dual 
        END IF 
        IF l_hrat04 = '102001' THEN #总经办
           SELECT last_day(add_months(g_date,3)) INTO l_hrci.hrci10 FROM dual
           SELECT add_months(trunc(g_date,'YYYY'),12)-1 INTO l_hrci10 FROM dual  
           IF l_hrci.hrci10 > l_hrci10 THEN #不跨年
              LET l_hrci.hrci10 = l_hrci10
           END IF            
        END IF  
#        IF l_hrbm25 = '001' THEN 
#           SELECT add_months(g_date,1) INTO l_hrci.hrci10 FROM dual
#        END IF 
#        IF l_hrbm25 = '002' THEN 
#           SELECT add_months(g_date,2) INTO l_hrci.hrci10 FROM dual
#        END IF 
#        IF l_hrbm25 = '003' THEN 
#           SELECT add_months(g_date,3) INTO l_hrci.hrci10 FROM dual
#        END IF 
#        IF l_hrbm25 = '004' THEN 
#           SELECT add_months(g_date,6) INTO l_hrci.hrci10 FROM dual
#        END IF 
#        IF l_hrbm25 = '005' THEN 
#           SELECT add_months(g_date,12) INTO l_hrci.hrci10 FROM dual
#        END IF                         
     ELSE 
       RETURN 
     END IF 
     LET l_hrci.hrciacti ='Y'
     LET l_hrci.hrciconf ='Y'
     INSERT INTO hrci_file VALUES (l_hrci.*)
  ELSE
  	 UPDATE hrci_file SET hrci05 = hrci05 + p_ss ,hrci07 = hrci07 + p_ss ,hrci09 = hrci09 + p_ss - hrci08 
      WHERE hrci02 = g_name
        AND hrci03 = g_date
  END IF 

         
END FUNCTION  

FUNCTION p056_updhrcp()#最后更新hrcp_file最新点名数据
DEFINE l_hrbm03 LIKE hrbm_file.hrbm03
DEFINE l_hrbm05 LIKE hrbm_file.hrbm05
DEFINE l_hrbm06 LIKE hrbm_file.hrbm06
DEFINE l_total,l_total1 LIKE hrbo_file.hrbo08
DEFINE l_hrcp10,l_fz LIKE hrcp_file.hrcp10
DEFINE l_hrcp08 LIKE hrcp_file.hrcp08
DEFINE l_hrcp05 LIKE hrcp_file.hrcp05
DEFINE l_hrbm41 LIKE hrbm_file.hrbm41
DEFINE l_hrbm02 LIKE hrbm_file.hrbm02
DEFINE l_sql,l_sql1 STRING
DEFINE l_hrcma05,l_hrcma07,l_hrboa02,l_hrboa05,i LIKE type_file.num10                
DEFINE l_hrcpud03 LIKE hrcp_file.hrcpud03
   SELECT hrbo08 INTO l_total FROM hrbo_file WHERE hrbo02 = g_hrcp04
   LET l_total1 = l_total
   LET l_sql1 = ''
   LET l_hrcp08 ='91'
   LET l_sql1 = "hrcp08 = '",l_hrcp08,"' "
#   UPDATE hrci_file SET hrci05 = 0 ,hrci07= 0,hrci09 = 0 
#    WHERE hrci02 = g_name AND hrci03 = g_date  

   IF g_hrbo06 = 'Y' THEN 
      IF g_jrjb != '0' THEN #有节假日加班计划时，工时转加班
         SELECT hrbm05 INTO l_hrbm05 FROM hrbm_file WHERE hrbm03 = g_jrjb
         #扣减掉迟到早退
         LET l_sql = "select hrcda03,fenzhong,hrbm05,hrbm06,hrbm02  from temp02,hrbm_file where hrbm03 = hrcda03 and hrbm02 in('001','002','003') "
         PREPARE p056_14 FROM l_sql
         DECLARE p056_14s CURSOR FOR p056_14
         FOREACH p056_14s INTO l_hrbm03,l_fz,l_hrbm05,l_hrbm06,l_hrbm02
            IF l_hrbm02 = '003' THEN LET l_fz = l_fz*60 END IF 
            LET g_jrss = g_jrss - l_fz
         END FOREACH          
     #    SELECT floor(g_jrss/l_hrbm05/60) * l_hrbm05 INTO l_hrcp10 FROM dual
         INSERT INTO temp02 VALUES (g_jrjb,g_jrss) 
      END IF  
      LET l_total1 = 0  
   END IF 
   #处理假勤类别数据核算量
   LET l_sql = "select hrcda03,hrbm05,hrbm06,hrbm02,hrbm41,sum(fenzhong)  from temp02,hrbm_file where hrbm03 = hrcda03  group by hrcda03,hrbm05,hrbm06,hrbm02,hrbm41  "
   PREPARE p056_6 FROM l_sql
   DECLARE p056_6s CURSOR FOR p056_6
   FOREACH p056_6s INTO l_hrbm03,l_hrbm05,l_hrbm06,l_hrbm02,l_hrbm41,l_fz
      IF l_hrbm02 ='001' OR l_hrbm02 ='002' OR l_hrbm02 ='003' THEN LET l_hrcp08 = '92' END IF 
      CASE l_hrbm06
          WHEN '001' #天
            SELECT ceil(l_fz/l_total/l_hrbm05)*l_hrbm05 INTO l_hrcp10 FROM dual
            LET  l_total1 = l_total1 - l_total1 * l_hrcp10      
        WHEN '003' #小时
             IF l_hrbm02 ='008' THEN #加班向下核算
                SELECT floor(l_fz/l_hrbm05/60) * l_hrbm05 INTO l_hrcp10 FROM dual
             ELSE 
          	    SELECT ceil(l_fz/l_hrbm05/60) * l_hrbm05 INTO l_hrcp10 FROM dual   
                LET  l_total1 = l_total1 -  l_hrcp10 * 60 
            END IF  
        WHEN '004' #分
             LET l_hrcp10 =  l_fz           
         WHEN '005' #次
             LET l_hrcp10 =  1   
      END CASE
      LET l_fz = l_hrcp10     
      #IF l_hrbm02 = '008' THEN #加班转调休
     #    CALL p056_tiaoxiu(l_hrbm03,l_fz)
     # END IF 
      IF  l_hrbm02 = '008' AND g_hrbo06 = 'Y' THEN 
          LET l_fz = l_fz  - g_jcd
          IF l_fz < 0 THEN CONTINUE FOREACH END IF 
      END IF 
      IF g_hrbo06 = 'Y' AND (l_hrbm02 ='001' OR l_hrbm02 ='002' OR l_hrbm02 ='003' ) THEN 
        CONTINUE FOREACH 
      END IF 
      LET l_sql1 = l_sql1 ,',',l_hrbm41,'=',l_fz   
      
   END FOREACH 
   #更新hrcp_file
   #更新hrcp_fil   
   
   IF g_hrbo06 = 'Y' THEN LET l_hrcp08 = '91'    LET l_total1 = 0   END IF #休息日无异常
   IF l_total1 < 0 THEN LET l_total1 = 0 END IF 
  # 处理时间
   SELECT to_char(systimestamp, 'yy/mm/dd hh24:mi:ss') INTO  l_hrcpud03 FROM dual
   SELECT hrbo15 INTO l_hrcp05 FROM hrbo_file WHERE hrbo02 = g_hrcp04
   LET l_sql= "UPDATE hrcp_file SET hrcpud03='",l_hrcpud03,"',hrcp09 ='",l_total1/60,"', hrcp35 = 'Y',hrcp04 = '",g_hrcp04,"',hrcp05=nvl('",l_hrcp05,"',' '),",l_sql1,
                    " WHERE hrcp02='",g_name,"' ",
                    "   AND hrcp03='",g_date,"' "
         PREPARE p056_8 FROM l_sql
         EXECUTE p056_8 
  UPDATE hrcp_file SET hrcp08 = l_hrcp08 WHERE hrcp02 = g_name AND hrcp03 = g_date 
              
END FUNCTION

FUNCTION p056_table()#临时表
#存储班段数据
DROP TABLE temp01
CREATE TEMP TABLE temp01(
        
        hrboa02   DEC(5),
        hrboa03   VARCHAR(5),
        hrboa04   DEC(5),
        hrboa05   DEC(5),
        hrboa06   VARCHAR(5),
        hrboa07   DEC(5))
        ;
DELETE FROM TEMP01
#备份班段数据
DROP TABLE temp01_t
CREATE TEMP TABLE temp01_t(
        hrboa02   DEC(5),
        hrboa03   VARCHAR(5),
        hrboa04   DEC(5),
        hrboa05   DEC(5),
        hrboa06   VARCHAR(5),
        hrboa07   DEC(5))
        ;
DELETE FROM TEMP01_t
#存储假勤类别数据
DROP TABLE temp02
CREATE TEMP TABLE temp02(
        hrcda03   VARCHAR(5),
        fenzhong  DEC(15,3)
        )
DELETE FROM TEMP02
#存储刷卡数据
DROP TABLE temp03
CREATE TEMP TABLE temp03(
        t1   DATE,
        t2   VARCHAR(20),
        t3   DEC(5)
        )
DELETE FROM TEMP03
#存储休息段数据
DROP TABLE temp04
CREATE TEMP TABLE temp04(
        restb   DEC(5),
        reste   DEC(5) )
DELETE FROM TEMP04
#存储班段数据
DROP TABLE temp05 #节假日加班使用
CREATE TEMP TABLE temp05(
        
        hrboa02   DEC(5),
        hrboa03   VARCHAR(5),
        hrboa04   DEC(5),
        hrboa05   DEC(5),
        hrboa06   VARCHAR(5),
        hrboa07   DEC(5))
        ;
DELETE FROM TEMP05
END FUNCTION
#add by zhuzw 20160421 start 异常扣除时，考虑中间是否含有就餐，如有扣减
FUNCTION p056_xiuxi(p_hrbm02,p_btime,p_etime)
DEFINE p_btime,p_etime,l_hrboa05,l_hrboa02,p_yc   LIKE type_file.num10
DEFINE l_sql1 STRING
DEFINE l_hrboa01 LIKE hrboa_file.hrboa01
DEFINE p_hrbm02 LIKE hrbm_file.hrbm02
DEFINE l_hrbm03 LIKE hrbm_file.hrbm03
       LET p_yc = p_etime - p_btime
       LET l_sql1 =  " select distinct * FROM temp04 order by restb "
       PREPARE p056_jckcp2 FROM l_sql1
       DECLARE p056_jckcsp2 CURSOR FOR p056_jckcp2
       FOREACH p056_jckcsp2 INTO l_hrboa02,l_hrboa05    
          IF l_hrboa02 >= p_btime AND l_hrboa05 <= p_etime THEN
             LET  p_yc = p_yc - (l_hrboa05 - l_hrboa02)                                    
          END IF 
          IF l_hrboa02 < p_btime AND l_hrboa05 < p_etime AND l_hrboa05 > p_btime THEN
             LET  p_yc = p_yc - (l_hrboa05 - p_btime) 
             
          END IF
          IF l_hrboa02 > p_btime AND l_hrboa02 < p_etime AND l_hrboa05 >= p_etime THEN
             LET  p_yc = p_yc - (l_hrboa05 - l_hrboa02) 
          END IF
          IF l_hrboa02 < p_btime AND l_hrboa05 >= p_etime THEN
             LET  p_yc = 0
          END IF
       END FOREACH 
       IF p_yc >0 THEN #大于0
          IF p_hrbm02 = '015' THEN  #延时加班
             INSERT INTO temp02 values(p_hrbm02,p_yc)
          ELSE             #异常
             --SELECT hrbm03 INTO l_hrbm03 FROM hrbm_file 
              --WHERE p_yc > hrbm11 AND p_yc <= hrbm12
                --AND (hrbm02 = p_hrbm02 OR hrbm02 = '003')
             IF p_hrbm02 = '003' AND g_qk ='Y' THEN  #如果缺卡，则不考虑考核起始和结束时间，直接算做旷工
                SELECT hrbm03 INTO l_hrbm03 FROM hrbm_file 
                  WHERE hrbm02 = p_hrbm02           
             ELSE 
                SELECT hrbm03 INTO l_hrbm03 FROM hrbm_file 
                  WHERE p_yc > hrbm11 AND p_yc <= hrbm12 AND hrbm02 = p_hrbm02
             END IF 
             IF NOT cl_null(l_hrbm03) THEN 
                INSERT INTO temp02 VALUES(l_hrbm03,p_yc)
             END IF    
          END IF 
       END IF  
END FUNCTION  

FUNCTION p056_xiuxi1(p_btime,p_etime)
DEFINE p_btime,p_etime,l_hrboa05,l_hrboa02,p_yc   LIKE type_file.num10
DEFINE l_sql1 STRING
DEFINE l_hrboa01 LIKE hrboa_file.hrboa01
DEFINE p_hrbm02 LIKE hrbm_file.hrbm02
DEFINE l_hrbm03 LIKE hrbm_file.hrbm03
       LET p_yc = p_etime - p_btime
       LET l_sql1 =  " select distinct * FROM temp04 order by restb "
       PREPARE p056_jckcp12 FROM l_sql1
       DECLARE p056_jckcsp12 CURSOR FOR p056_jckcp12
       FOREACH p056_jckcsp12 INTO l_hrboa02,l_hrboa05    
          IF l_hrboa02 >= p_btime AND l_hrboa05 <= p_etime THEN
             LET  p_yc = p_yc - (l_hrboa05 - l_hrboa02)                                    
          END IF 
          IF l_hrboa02 < p_btime AND l_hrboa05 < p_etime AND l_hrboa05 > p_btime THEN
             LET  p_yc = p_yc - (l_hrboa05 - p_btime) 
             
          END IF
          IF l_hrboa02 > p_btime AND l_hrboa02 < p_etime AND l_hrboa05 >= p_etime THEN
             LET  p_yc = p_yc - (l_hrboa05 - l_hrboa02) 
          END IF
          IF l_hrboa02 < p_btime AND l_hrboa05 > p_etime THEN
             LET  p_yc = 0
          END IF
       END FOREACH 
       RETURN p_yc
END FUNCTION 
