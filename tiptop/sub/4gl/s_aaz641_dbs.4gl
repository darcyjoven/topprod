# Prog. Version..: '5.30.06-13.03.12(00010)'     #
##SYNTAX	   CALL s_aaz641_dbs(p_axa01,p_axz01)
##DESCRIPTION	   输入合并族群，公司代号
##PARAMETERS       p_axa01     合并族群  
##		   p_axz01     公司代号       
##RETURNING	   合并帐别资料库 p_aaz641_dbs
# Date & Author..: 2010/08/09 FUN-A80034 by wujie     21区追单
# Modify.........: No.FUN-A30122 10/08/20 By vealxu 追单 dbs->plant
# Modify.........: No:CHI-B10030 11/01/24 By Summer 抓取上層公司所在DB
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.TQC-B60309 11/06/23 By zhangweib s_axz03_dbs有錯RETURN時 給回傳值
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No.TQC-D20007 13/02/05 By wujie 为s_aaz641_dbs()改名
# Modify.........: No.TQC-D20008 13/02/06 By wujie 考虑不周，还是要保留aaz641_dbs()

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006
#FUN-A80034
DEFINE  g_dbs_new    LIKE type_file.chr21
DEFINE  g_sql        STRING

#FUNCTION s_aaz641_dbs(p_axa01,p_axz01)       
#FUNCTION s_aaz641_dbs1(p_axa01,p_axz01)       #No.TQC-D20007
FUNCTION s_aaz641_dbs(p_axa01,p_axz01)       #No.TQC-D20008
DEFINE  p_axa01      LIKE axa_file.axa01
DEFINE  p_axz01      LIKE axz_file.axz01
DEFINE  l_cnt        LIKE type_file.num5
DEFINE  l_axa02      LIKE axa_file.axa02
DEFINE  l_axa02_cnt  LIKE type_file.num5    
DEFINE  l_axb04_cnt  LIKE type_file.num5    #MOD-A60031
DEFINE  l_axz03      LIKE axz_file.axz03
DEFINE  l_axz04      LIKE axz_file.axz04
DEFINE  l_axz05      LIKE axz_file.axz05
DEFINE  l_aaz641_dbs LIKE type_file.chr21
DEFINE  l_axa09      LIKE axa_file.axa09
DEFINE  l_aaz641_plant LIKE type_file.chr21    #FUN-A30122
 
   #--先取传入的公司代号在公司基本资料agli009中的设定 
   #      营运中心代码/使用TIPTOP/原始帐别 
   SELECT axz03,axz04,axz05 
     INTO l_axz03,l_axz04,l_axz05 
     FROM axz_file 
     WHERE axz01 = p_axz01

   #(axz04)=N,表示为非TIPTOP公司
   #预设来源营运中心为目前所在DB给他(g_dbs_gl)
   IF l_axz04 = 'N' THEN 
       LET l_axz03=g_plant    
       SELECT azp03 
         INTO g_dbs_new 
         FROM azp_file
        WHERE azp01 = l_axz03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED) 
       LET l_aaz641_plant = g_plant                     #FUN-A30122 add
       
   ELSE    #取公司基本资料中的来源营运中心 
       SELECT azp03 INTO g_dbs_new FROM azp_file
        WHERE azp01 = l_axz03
       IF STATUS THEN
          LET g_dbs_new = NULL
       END IF
       LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED) 
       LET l_aaz641_plant = l_axz03                    #FUN-A30122 add  
   END IF

   #检查是否合并会科独立(axa09)
   #IF axa09 = 'Y' 则判断p_axz01是否为上层公司
   # 是 ->取p_axz01自己的营运中心
   # 不是->取_axz01的上层公司，代表合并帐别建立于上层公司
   #IF axa09 = 'N' 则取目前所在DB(g_plant)，代表合并帐别建立于最上层公司

   LET l_axa02_cnt = 0                #MOD-A60031
   #判断目前p_axz01是否为上层公司才能取出axa09的值
   SELECT COUNT(*) INTO l_axa02_cnt   #判断自己本身是否为上层公司
     FROM axa_file
    WHERE axa01 = p_axa01
      AND axa02 = p_axz01

   IF l_axa02_cnt > 0 THEN      #上层公司
       #抓出axa09值判断Y/N 
       SELECT axa09 INTO l_axa09 FROM axa_file     
        WHERE axa01 = p_axa01         #族群
          AND axa02 = p_axz01         #上层公司编号 
       IF l_axa09 = 'N' THEN          #合并会科不独立
           SELECT azp03 INTO g_dbs_new FROM azp_file     
            WHERE azp01 = g_plant                        
           LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED)   
           LET l_aaz641_plant = g_plant                    #FUN-A30122 add 
       ELSE
           SELECT azp03 INTO g_dbs_new FROM azp_file   
            WHERE azp01 = l_axz03                          
           IF STATUS THEN                          
              LET g_dbs_new = NULL                   
           END IF                                         
           LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED)    
           LET l_aaz641_plant = l_axz03                     #FUN-A30122 add
       END IF
   ELSE       #p_axz01 属于最下层公司
      #-MOD-A60031-add-
       LET l_axb04_cnt = 0         
       SELECT COUNT(*) INTO l_axb04_cnt   #判断自己本身是否为下层公司
         FROM axb_file
        WHERE axb01 = p_axa01
          AND axb04 = p_axz01
       IF l_axb04_cnt = 0 THEN
           CALL cl_err('','agl-221',1)
       END IF
      #-MOD-A60031-end-

       SELECT axb02 INTO l_axa02  #上层公司
         FROM axb_file
        WHERE axb01 = p_axa01
          AND axb04 = p_axz01
       SELECT axa09 INTO l_axa09 FROM axa_file     
        WHERE axa01 = p_axa01  
          AND axa02 = l_axa02         #上层公司编号 
       IF l_axa09 = 'N' THEN          #合并会科不独立
           SELECT azp03 INTO g_dbs_new FROM azp_file  
            WHERE azp01 = g_plant                           
           LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED)  
           LET l_aaz641_plant = g_plant                    #FUN-A30122 add
       ELSE
           LET l_axz03 = ''
           SELECT axz03               #上层公司资料库
             INTO l_axz03 
             FROM axz_file 
             WHERE axz01 = l_axa02  
           SELECT azp03 INTO g_dbs_new FROM azp_file         
            WHERE azp01 = l_axz03                      
           IF STATUS THEN                       
              LET g_dbs_new = NULL                  
           END IF                                       
           LET l_aaz641_dbs = s_dbstring(g_dbs_new CLIPPED)    
           LET l_aaz641_plant = l_axz03                     #FUN-A30122 add
       END IF
   END IF
 # RETURN l_aaz641_dbs      #FUN-A30122 mark
   RETURN l_aaz641_plant    #FUN-A30122 add 
END FUNCTION 

#FUNCTION s_get_aaz641(p_dbs)    #FUN-A30122 mark
FUNCTION s_get_aaz641(p_plant)   #FUN-A30122 add
DEFINE p_dbs    LIKE type_file.chr21
DEFINE l_aaz641 LIKE aaz_file.aaz641
DEFINE p_plant  LIKE azp_file.azp01    #FUN-A30122 

 # LET g_sql = "SELECT aaz641 FROM ",p_dbs,"aaz_file",                            #FUN-A30122 mark
   LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(p_plant,'aaz_file'),     #FUN-A30122 add     
               " WHERE aaz00 = '0'"
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
FUNCTION s_axz03_dbs(p_axa02)
DEFINE  p_axa02      LIKE axa_file.axa02
DEFINE  l_axz03      LIKE axz_file.axz03
DEFINE  l_axz04      LIKE axz_file.axz04

   SELECT axz03,axz04 INTO l_axz03,l_axz04 FROM axz_file WHERE axz01=p_axa02
  #IF STATUS THEN LET l_axz03 = NULL RETURN END IF    #TQC-B60309   Mark
   IF STATUS THEN LET l_axz03 = NULL RETURN l_axz03  END IF   #TQC-B60309   Add
   IF l_axz04='N' THEN LET l_axz03=g_plant END IF

   RETURN l_axz03
END FUNCTION
#CHI-B10030 add --end--
