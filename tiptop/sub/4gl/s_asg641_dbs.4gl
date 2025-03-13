# Prog. Version..: '5.30.06-13.03.12(00002)'     #
##SYNTAX	   CALL s_aaz641_dbs(p_asa01,p_asg01)
##DESCRIPTION	   输入合并族群，公司代号
##PARAMETERS       p_asa01     合并族群  
##		   p_asg01     公司代号       
##RETURNING	   合并帐别资料库 p_aaz641_dbs
# Date & Author..: 2010/08/09 FUN-A80034 by wujie     21区追单
# Modify.........: No.FUN-A30122 10/08/20 By vealxu 追单 dbs->plant
# Modify.........: No:CHI-B10030 11/01/24 By Summer 抓取上層公司所在DB
# Modify.........: NO.FUN-B50001 11/05/10 By lutingting aaz641-->asz01
# Modify.........: No.TQC-B60047 11/06/10 By lutingting 抓取上層公司加asb06 = 'Y'
# Modify.........: No.TQC-B60309 11/06/23 By zhangweib s_asg03_dbs有錯RETURN時 給回傳值
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.MOD-CC0031 12/12/05 By fengmy   發生錯誤，程序不直接關閉 

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-BB0036
#FUN-A80034
DEFINE  g_dbs_new    LIKE type_file.chr21
DEFINE  g_sql        STRING

FUNCTION s_aaz641_asg(p_asa01,p_asg01)       
DEFINE  p_asa01      LIKE asa_file.asa01
DEFINE  p_asg01      LIKE asg_file.asg01
DEFINE  l_cnt        LIKE type_file.num5
DEFINE  l_asa02      LIKE asa_file.asa02
DEFINE  l_asa02_cnt  LIKE type_file.num5    
DEFINE  l_asb04_cnt  LIKE type_file.num5    #MOD-A60031
DEFINE  l_asg03      LIKE asg_file.asg03
DEFINE  l_asg04      LIKE asg_file.asg04
DEFINE  l_asg05      LIKE asg_file.asg05
DEFINE  l_aaz641_dbs LIKE type_file.chr21
DEFINE  l_asa09      LIKE asa_file.asa09
DEFINE  l_aaz641_plant LIKE type_file.chr21    #FUN-A30122
 
   WHENEVER ERROR CONTINUE                     #MOD-CC0031

   #--先取传入的公司代号在公司基本资料agli009中的设定 
   #      营运中心代码/使用TIPTOP/原始帐别 
   SELECT asg03,asg04,asg05 
     INTO l_asg03,l_asg04,l_asg05 
     FROM asg_file 
     WHERE asg01 = p_asg01

   #(asg04)=N,表示为非TIPTOP公司
   #预设来源营运中心为目前所在DB给他(g_dbs_gl)
   IF l_asg04 = 'N' THEN 
       LET l_asg03=g_plant    
       SELECT azp03 
         INTO g_dbs_new 
         FROM azp_file
        WHERE azp01 = l_asg03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED) 
       LET l_aaz641_plant = g_plant                     #FUN-A30122 add
       
   ELSE    #取公司基本资料中的来源营运中心 
       SELECT azp03 INTO g_dbs_new FROM azp_file
        WHERE azp01 = l_asg03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED) 
       LET l_aaz641_plant = l_asg03                    #FUN-A30122 add  
   END IF

   #检查是否合并会科独立(asa09)
   #IF asa09 = 'Y' 则判断p_asg01是否为上层公司
   # 是 ->取p_asg01自己的营运中心
   # 不是->取_asg01的上层公司，代表合并帐别建立于上层公司
   #IF asa09 = 'N' 则取目前所在DB(g_plant)，代表合并帐别建立于最上层公司

   LET l_asa02_cnt = 0                #MOD-A60031
   #判断目前p_asg01是否为上层公司才能取出asa09的值
   SELECT COUNT(*) INTO l_asa02_cnt   #判断自己本身是否为上层公司
     FROM asa_file
    WHERE asa01 = p_asa01
      AND asa02 = p_asg01

   IF l_asa02_cnt > 0 THEN      #上层公司
       #抓出asa09值判断Y/N 
       SELECT asa09 INTO l_asa09 FROM asa_file     
        WHERE asa01 = p_asa01         #族群
          AND asa02 = p_asg01         #上层公司编号 
       IF l_asa09 = 'N' THEN          #合并会科不独立
           SELECT azp03 INTO g_dbs_new FROM azp_file     
            WHERE azp01 = g_plant                        
           LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED)   
           LET l_aaz641_plant = g_plant                    #FUN-A30122 add 
       ELSE
           SELECT azp03 INTO g_dbs_new FROM azp_file   
            WHERE azp01 = l_asg03                          
           IF STATUS THEN                          
              LET g_dbs_new = NULL                   
           END IF                                         
           LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED)    
           LET l_aaz641_plant = l_asg03                     #FUN-A30122 add
       END IF
   ELSE       #p_asg01 属于最下层公司
      #-MOD-A60031-add-
       LET l_asb04_cnt = 0         
       SELECT COUNT(*) INTO l_asb04_cnt   #判断自己本身是否为下层公司
         FROM asb_file
        WHERE asb01 = p_asa01
          AND asb04 = p_asg01
       IF l_asb04_cnt = 0 THEN
           CALL cl_err('','agl-221',1)
       END IF
      #-MOD-A60031-end-

       SELECT DISTINCT asb02 INTO l_asa02  #上层公司
         FROM asb_file
        WHERE asb01 = p_asa01
          AND asb04 = p_asg01
          AND asb06 = 'Y'    #TQC-B60047
       SELECT asa09 INTO l_asa09 FROM asa_file     
        WHERE asa01 = p_asa01  
          AND asa02 = l_asa02         #上层公司编号 
       IF l_asa09 = 'N' THEN          #合并会科不独立
           SELECT azp03 INTO g_dbs_new FROM azp_file  
            WHERE azp01 = g_plant                           
           LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED)  
           LET l_aaz641_plant = g_plant                    #FUN-A30122 add
       ELSE
           LET l_asg03 = ''
           SELECT asg03               #上层公司资料库
             INTO l_asg03 
             FROM asg_file 
             WHERE asg01 = l_asa02  
           SELECT azp03 INTO g_dbs_new FROM azp_file         
            WHERE azp01 = l_asg03                      
           IF STATUS THEN                       
              LET g_dbs_new = NULL                  
           END IF                                       
           LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED)    
           LET l_aaz641_plant = l_asg03                     #FUN-A30122 add
       END IF
   END IF
 # RETURN l_aaz641_dbs      #FUN-A30122 mark
   RETURN l_aaz641_plant    #FUN-A30122 add 
END FUNCTION 

FUNCTION s_get_aaz641_asg(p_plant)   #FUN-A30122 add
DEFINE p_dbs    LIKE type_file.chr21
DEFINE l_aaz641 LIKE aaz_file.aaz641
DEFINE p_plant  LIKE azp_file.azp01    #FUN-A30122 

 # LET g_sql = "SELECT aaz641 FROM ",p_dbs,"aaz_file",                            #FUN-A30122 mark
#FUN-B50001--mod--str--
#   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(p_plant,'aaz_file'),     #FUN-A30122 add     
#               " WHERE aaz00 = '0'"
   LET g_sql = "SELECT asz01 FROM ",cl_get_target_table(p_plant,'asz_file'),   
               " WHERE asz00 = '0'"
#FUN-B50001--mod--end
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql           #FUN-A30122
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A30122 
   PREPARE s_getdbs_p1 FROM g_sql
   DECLARE s_getdbs_c1 CURSOR FOR s_getdbs_p1
   OPEN s_getdbs_c1
   FETCH s_getdbs_c1 INTO l_aaz641
   IF cl_null(l_aaz641) THEN
       CALL cl_err('','agl-601',1)
   END IF
   RETURN l_aaz641
END FUNCTION

#CHI-B10030 add --start--
FUNCTION s_asg03_dbs(p_asa02)
DEFINE  p_asa02      LIKE asa_file.asa02
DEFINE  l_asg03      LIKE asg_file.asg03
DEFINE  l_asg04      LIKE asg_file.asg04

   SELECT asg03,asg04 INTO l_asg03,l_asg04 FROM asg_file WHERE asg01=p_asa02
  #IF STATUS THEN LET l_asg03 = NULL RETURN END IF    #TQC-B60309   Mark
   IF STATUS THEN LET l_asg03 = NULL RETURN l_asg03  END IF   #TQC-B60309   Add
   IF l_asg04='N' THEN LET l_asg03=g_plant END IF

   RETURN l_asg03
END FUNCTION
#CHI-B10030 add --end--
