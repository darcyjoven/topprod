# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_asfi510.4gl
# Descriptions...: 生成完工入库作业
# Date & Author..: 2017-02-23 11:20:00 by huanglf

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS 
DEFINE g_sfa01    LIKE sfa_file.sfa01        #工单号                                               
DEFINE g_ogb01    LIKE ogb_file.ogb01                      
DEFINE g_oga01    LIKE oga_file.oga01                      
DEFINE g_buf      LIKE type_file.chr2                      
DEFINE li_result  LIKE type_file.num5                      
DEFINE g_sql      STRING                                   
DEFINE tmm        RECORD                                    
                 sfb01   LIKE sfb_file.sfb01,   #工单号      
                 ime01   LIKE ime_file.ime01,    #仓库编号     
                 ibb01   LIKE ibb_file.ibb01,    #物料条码     
                 sfa30   LIKE sfa_file.sfa30,    #仓库       
                 sfa31   LIKE sfa_file.sfa31,    #库位       
                 sfa03   LIKE sfa_file.sfa03,    #发料料号     
                 ima02   LIKE ima_file.ima02,    #品名       
                 sfa05   LIKE sfa_file.sfa05,    #欠料量      
                 ibb07   LIKE ibb_file.ibb07     #实发数量     
                 END RECORD
DEFINE g_hlf01     RECORD 
        sfp01    LIKE sfp_file.sfp01
                 END RECORD                 
DEFINE g_sfa    DYNAMIC ARRAY OF RECORD    #第一单身           
                    sfa03_1     LIKE sfa_file.sfa03,       
                    ima02_1     LIKE ima_file.ima02,       
                    marry_num   LIKE ogb_file.ogb12        
                 END RECORD,                               
       g_sfa_o  RECORD    #第一单身                            
                    sfa03_1     LIKE sfa_file.sfa03,       
                    ima02_1     LIKE ima_file.ima02,       
                    marry_num   LIKE ogb_file.ogb12        
                 END RECORD                                                          
                                                           
DEFINE g_cnt     LIKE type_file.num5                       
DEFINE g_rec_b,g_rec_b1,g_rec_b2   LIKE type_file.num5     
DEFINE g_rec_b_1 LIKE type_file.num5                       
DEFINE l_ac      LIKE type_file.num10                      
DEFINE l_ac_t    LIKE type_file.num10                      
DEFINE li_step   LIKE type_file.num5                       
DEFINE g_ibb01   LIKE ibb_file.ibb01                       
DEFINE g_sfp01   LIKE sfp_file.sfp01                       
END GLOBALS             

FUNCTION aws_asfi510()
   DEFINE l_sql,l_sql1,l_sql2,l_sql3,l_sql4       STRING
   DEFINE l_sfb01     LIKE sfb_file.sfb01
   DEFINE l_sfb81     LIKE sfb_file.sfb81
   DEFINE l_num1      LIKE type_file.num5
   DEFINE l_sum       LIKE sfa_file.sfa05
   DEFINE l_short_qty LIKE sfa_file.sfa05
   
   DEFINE l_sfp  RECORD LIKE sfp_file.*
   DEFINE l_sfq  RECORD LIKE sfq_file.*
   DEFINE l_sfs  RECORD LIKE sfs_file.*
   DEFINE l_rvbs RECORD LIKE rvbs_file.*
   DEFINE l_j,l_j2    LIKE sfs_file.sfs02
   DEFINE l_cnt0,l_cnt1 LIKE sfs_file.sfs02
   DEFINE l_sql  STRING
   DEFINE l_sfs01 LIKE sfs_file.sfs01
   DEFINE l_sfs03 LIKE sfs_file.sfs03
   DEFINE l_rvbs04_t LIKE rvbs_file.rvbs04
   DEFINE l_rvbs021_t LIKE rvbs_file.rvbs021
   DEFINE l_rvbs03_t LIKE rvbs_file.rvbs03
   DEFINE l_rvbs08_t LIKE rvbs_file.rvbs08
   DEFINE l_rvbs01_t LIKE rvbs_file.rvbs01
   DEFINE l_sfa06    LIKE sfa_file.sfa06
   DEFINE l_sfa05    LIKE sfa_file.sfa05
   DEFINE l_ima06 LIKE ima_file.ima06
   DEFINE l_flag  LIKE type_file.chr1 
   DEFINE l_cn,l_cn0    LIKE sfa_file.sfa06
   DEFINE l_factor   LIKE type_file.num26_10
   DEFINE l_ima25    LIKE ima_file.ima25
   DEFINE l_sfs06    LIKE sfs_file.sfs06
   DEFINE l_sfa03    LIKE sfa_file.sfa03,
          l_sfa30    LIKE sfa_file.sfa30,
          l_sfa31    LIKE sfa_file.sfa31,
          l_ibb07    LIKE ibb_file.ibb07,
          l_sfb01  LIKE sfb_file.sfb01,
          l_n,l_cnt11      LIKE type_file.num5
   #----單頭
   INITIALIZE l_sfp.* TO NULL
   INITIALIZE l_sfs.* TO NULL
   INITIALIZE l_sfq.* TO NULL
   CALL aws_asfi510_temp_table()


   #判断是否有可转的单子
   LET l_num1 = 0
   LET l_sql4 = "SELECT COUNT(*) FROM gls_af_file WHERE (gls_af29 = 'N' OR gls_af29 = 'F') AND gls_af27 = '",g_timestamp,"'"
   PREPARE t620_pb1 FROM l_sql4
   EXECUTE t620_pb1 INTO l_num1 
   IF l_num1 = 0 THEN
      LET g_status.code = -1
      LET g_status.description="没有可转单子!"
      RETURN ''
   END IF
 
   BEGIN WORK   
   
   SELECT gls_ao12 INTO l_sfu.sfu01 FROM gls_ao_file  #取单别  
   CALL s_auto_assign_no("asf",l_sfu.sfu01,l_sfu.sfu02,"1","sfu_file","sfu01","","","")
   RETURNING li_result,l_sfu.sfu01                                  #完工入库单单号

   LET l_sfp.sfp02 = g_today
   LET l_sfp.sfp03 = g_today

   IF cl_null(l_sfp.sfp01) THEN
      LET g_status.code = "-1"
      LET g_status.description = "没有维护此工单相应的发料单别!"
   	  LET g_success = 'N'
      RETURN ''
   END IF
   CALL s_auto_assign_no("asf",l_sfp.sfp01,l_sfp.sfp02,"","sfp_file","sfp01","","","")
        RETURNING li_result,l_sfp.sfp01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN ''
   END IF
   LET g_sfp01 = l_sfp.sfp01
   LET g_hlf01.sfp01 = g_sfp01
   LET l_sfp.sfp04 = 'N'
   LET l_sfp.sfp05 = 'N'
   LET l_cnt1 = 0
   LET l_sfp.sfp07 = g_grup
   LET l_sfp.sfp06 = '1'
   LET l_sfp.sfpuser = g_user
   SELECT gen03 INTO l_sfp.sfpgrup
     FROM gen_file
    WHERE gen01 = l_sfp.sfpuser
   LET l_sfp.sfp09 = 'N'
   LET l_sfp.sfpdate = g_today
   LET l_sfp.sfpconf = 'Y'
   
   ###新版本增加字段
   LET l_sfp.sfpplant = g_plant
   LET l_sfp.sfplegal = g_legal
   LET l_sfp.sfpmksg = 'N'
   LET l_sfp.sfp15 = '0'
   ###
   
   INSERT INTO sfp_file VALUES (l_sfp.*)
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      RETURN ''
   END IF


   

   LET l_sfq.sfq01 = l_sfp.sfp01    #发料单号


    LET l_sql1 = " SELECT sfa01,(sfa05 - sfa06 -sfa062 +sfa063) short_qty FROM sfb_file,sfa_file ",
                 "  WHERE sfa01 = sfb01 AND sfb05 = ? ",
                 "    AND sfb87 = 'Y' AND sfb04 <> '8' AND sfb08 > sfb09 ",
                 "    AND (sfa05 - sfa06 -sfa062 +sfa063) > 0 AND sfa11 <> 'E' ",    #有欠料的非消耗性料件
                 "    AND sfb02 = '1' ",
                 "    AND sfa03 = ? ",
                 "  ORDER BY sfb81,sfa01 "              
    PREPARE sel_gls_pre1 FROM l_sql1  
    DECLARE gls_curs1 CURSOR FOR sel_gls_pre1
                 
    LET l_sql = " SELECT gls_af83,gls_af25,SUM(gls_af05) FROM gls_af_file WHERE gls_af27 = '",g_timestamp,"' AND (gls_af29 = 'N' OR gls_af29 = 'F')",
                " GROUP BY gls_af83,gls_af25",
                " ORDER BY gls_af83"

   PREPARE sel_gls_pre FROM l_sql
   DECLARE gls_curs CURSOR FOR sel_gls_pre
   FOREACH gls_curs INTO l_gls_af83,l_sfs.sfs31,l_sum      #sfv31转换率

       FOREACH gls_curs1 USING l_gls_af83 INTO l_sfb01,l_sfs.sfs05
   


         SELECT MAX(sfs02)+1 INTO l_sfs.sfs02 FROM asfi510_tmp WHERE sfs01=l_sfq.sfq01 #项次
         IF cl_null(l_sfs.sfs02) THEN 
            LET l_sfs.sfs02= 1   
         END IF        
          LET l_sfs.sfs01 = l_sfp01         #发料单号
          LET l_sfs.sfs03 = l_sfb01         #工单单号
          LET l_sfs.sfs04 = l_gls_af83      #发料料号
             
          IF cl_null(l_sfs.sfs04) THEN
             LET g_success = 'N'
             LET g_status.code = "-1"
             LET g_status.description = "料号为空!"
             RETURN	''
          END IF
   
          LET l_sfs.sfs07 = ' '  #仓库
          LET l_sfs.sfs08 = ' '   #库位
          LET l_sfs.sfs09 = ' '   #批号
          
          SELECT sfa26,sfa27,sfa28,sfa12,sfa08
            INTO l_sfs.sfs26,l_sfs.sfs27,l_sfs.sfs28,l_sfs.sfs06,l_sfs.sfs10
            FROM sfa_file
           WHERE sfa01 = l_sfa01
             AND sfa03 = l_sfs.sfs04
          IF l_sfs.sfs10 IS NULL THEN LET l_sfs.sfs10 = ' ' END IF

          LET l_sfs.sfsplant = g_plant
          LET l_sfs.sfslegal = g_legal
          LET l_sfs.sfs012 = ' '
          LET l_sfs.sfs013 = 0
         
         IF l_sum > l_sfs.sfs05 THEN
            INSERT INTO asfi510_tmp VALUES(l_sfs.*)
            LET l_sum = l_sum - l_sfv.sfv09
         ELSE 
            LET l_sfs.sfs05 = l_sum
            INSERT INTO asi510_tmp VALUES(l_sfs.*)
            LET l_sum = 0
            EXIT FOREACH
         END IF
         
       END FOREACH  
       IF l_sum >0 THEN
          LET g_status.code = "-1"
          LET g_status.description = "工单已没有欠量!"
          ROLLBACK WORK
          RETURN ''
       END IF 
   END FOREACH
   #分配工单
    LET l_sql3 = " SELECT * FROM asfi510_tmp WHERE sfs05 > 0 AND sfs04 = ? ",  #找出临时表中可入库数量大于0的工单
                 " ORDER BY sfs02"  
    PREPARE sel_gls_pre3 FROM l_sql3
    DECLARE gls_curs3 CURSOR FOR sel_gls_pre3
    
    LET l_sql2 = " SELECT gls_af83,gls_af02,gls_af36,gls_af37,SUM(gls_af05) ",  #根据ERP仓储批，料件进行分组
                 " FROM  gls_af_file",
                 " WHERE gls_af27 = '",g_timestamp,"'",
                 "   AND (gls_af29 = 'N' OR gls_af29 = 'F')",
                 " GROUP BY gls_af83,gls_af02,gls_af36,gls_af37"

   PREPARE sel_gls_pre2 FROM l_sql2
   DECLARE gls_curs2 CURSOR FOR sel_gls_pre2
   
   FOREACH gls_curs2  INTO l_gls_af.gls_af83,l_gls_af.gls_af02,l_gls_af.gls_af36,
                           l_gls_af.gls_af37,l_gls_af.gls_af05
           
      FOREACH gls_curs3 USING l_gls_af.gls_af83 INTO l_sfs.*
            LET l_sfs02 = l_sfs.sfs02                                                    #临时表中的项次
            SELECT MAX(sfs02)+1 INTO l_sfs.sfs02 FROM sfs_file WHERE sfs01 = l_sfs.sfs01 #ERP中的项次
            IF cl_null(l_sfs.sfs02) THEN 
   	           LET l_sfs.sfs02 = 1
            END IF 
         
            LET l_sfs.sfs07 = l_gls_af.gls_af02 #仓库
            LET l_sfs.sfs08 = l_gls_af.gls_af36 #库位
            LET l_sfs.sfs09 = l_gls_af.gls_af37 #批号
        
            IF cl_null(l_sfs.sfs08) THEN LET l_sfs.sfs08 = ' ' END IF
            IF cl_null(l_sfs.sfs09) THEN LET l_sfs.sfs09 = ' ' END IF
            
            IF l_sfs.sfs05 > l_gls_af.gls_af05 THEN #当临时表中的发料量大于gls_af中的数量
               LET l_sfs.sfs05 = l_sfs.sfs05 - l_gls_af.gls_af05

               UPDATE asfi510_tmp SET sfs05 = l_sfs.sfs05 
               WHERE sfs01 = l_sfs.sfs01 AND sfs02 = l_sfs02

               LET l_sfs.sfs05 = l_gls_af.gls_af05
               LET l_gls_af.gls_af05 = 0
            ELSE
               UPDATE asfi510_tmp SET sfs05 = 0 
               WHERE sfs01 = l_sfs.sfs01 AND sfs03 = l_sfs03

               LET l_gls_af.gls_af05 = l_gls_af.gls_af05 - l_sfs.sfs05
            END IF 

        
            INSERT INTO sfs_file VALUES (l_sfs.*)
            IF STATUS THEN
                LET g_status.code = -1
                LET g_status.description="产生sfs_file有错误!"
                ROLLBACK WORK 
                RETURN  '' 
            END IF 
            IF  l_gls_af.gls_af05 = 0 THEN
                EXIT FOREACH 
            END IF 
            
        END FOREACH 
  
   END FOREACH 


#插入sfq_file
LET l_sql = "SELECT DISTINCT sfs01,sfs03 FROM sfs_file WHERE sfs01 = '",l_sfp.sfp01,"'"
      PREPARE t510_sfs_p FROM l_sql
      IF STATUS THEN
          LET g_status.code = "-1"
         LET g_status.description = "组sql语句出错！" EXIT PROGRAM
      END IF
      DECLARE t510_sfs_c CURSOR FOR t510_sfs_p
      FOREACH t510_sfs_c INTO l_sfs01,l_sfs03
        IF SQLCA.SQLCODE THEN 
             LET g_success = 'N' 
             EXIT FOREACH 
        END IF
        INITIALIZE l_sfq.* TO NULL
        LET l_sfq.sfq01 = l_sfs01
        LET l_sfq.sfq02 = l_sfs03
        LET l_sfq.sfq04 = ' '
        LET l_sfq.sfq03 = 0 
        LET l_sfq.sfq05 = g_today
        LET l_sfq.sfq06 = 0
        
        ###新增版本字段
        LET l_sfq.sfqplant = g_plant
        LET l_sfq.sfqlegal = g_legal
        LET l_sfq.sfq012 = ' '
        LET l_sfq.sfq014 = ' '
        ###
        
        INSERT INTO sfq_file VALUES (l_sfq.*)
        IF SQLCA.SQLCODE THEN
        	 LET g_success = 'N'
        	  LET g_status.code = "-1"
             LET g_status.description = "插入sfq_file时出错！"
        	 RETURN ''
        END IF
        
      END FOREACH   
   

   LET g_prog='asfi511'
   CALL t620sub_s(l_sfv.sfv01,"1",TRUE,'')  #过账
   CALL i501sub_s("1",g_sfp.sfp01,TRUE,'N')
   LET g_prog='aws_ttsrv2'
   IF g_success = 'N' THEN 
       LET g_status.code = '-1' 
       LET g_status.description = '发料单过账失败'
       ROLLBACK WORK
       RETURN ''
   END IF

   #回传gls_af29状态,gls_af905ERP异动单号,gls_af09目的单号
   UPDATE gls_af_file SET gls_af29 = 'Y',gls_af09 = l_sfu.sfu01,gls_af905 = l_sfu.sfu01 
   WHERE gls_af27 = g_timestamp
   IF STATUS THEN  
      LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="产生sfu_file有错误!"
      ROLLBACK WORK 
      RETURN ''
   END IF
    COMMIT WORK
    RETURN l_sfp.sfp01

END FUNCTION
	
                                              
                     
FUNCTION aws_asfi510_temp_table()
DEFINE l_sql    STRING 
  DROP TABLE asfi510_tmp
    LET l_sql ="CREATE GLOBAL TEMPORARY TABLE asfi510_tmp AS SELECT * FROM sfs_file WHERE 1=0"
    PREPARE work_tab FROM l_sql
    EXECUTE work_tab 
END FUNCTION
