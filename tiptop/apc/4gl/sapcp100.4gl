# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: sapcp100.4gl
# Descriptions...: POS下傳批處理作業
# Date & Author..: No.FUN-C50017 12/05/08 By huangtao
# Modify.........: No:FUN-C80079 12/08/22 By huangtao 會員紀念日折扣規則明細新增字段
# Modify.........: No.FUN-C80072 12/08/28 By xumm ryd03->ryd10
# Modify.........: No:FUN-C90090 12/09/19 By shiwuying 增加ta_MachineInfo的下传逻辑
# Modify.........: No:FUN-CA0074 12/10/14 By xumm 添加ta_BaseSet,ta_BaseSetTemp,ta_BaseSetTemp_Para的下传逻辑
# Modify.........: No:FUN-CB0007 12/11/05 By shiwuying 增加下传逻辑
# Modify.........: No:FUN-CB0007 12/11/06 By xumm 添加tf_Member_Grade,tf_Member_Type的下传逻辑
# Modify.........: No:FUN-CB0112 12/11/23 By baogc tb_Goods下傳添加FSOD可訂欄位
# Modify.........: No:FUN-CC0058 12/11/27 By huangtao 修改收券規則下傳
# Modify.........: No:FUN-CC0058 12/12/07 By shiwuying 取貨門店1011下傳邏輯修改
# Modify.........: No:FUN-CC0116 13/01/14 By xumm 增加专柜抽成资料的下传逻辑
# Modify.........: No:FUN-D10060 13/01/16 By xumm 增加发送邮件功能
# Modify.........: No:FUN-D10040 13/01/18 By xumm 添加折扣券逻辑
# Modify.........: No:FUN-D20020 13/02/20 By dongsz 添加觸屏資料的下傳
# Modify.........: No:FUN-D20092 13/02/27 By baogc 券種下傳邏輯調整
# Modify.........: No:FUN-D20096 13/02/28 By dongsz 卡種增加稅別的下傳
# Modify.........: No:FUN-D30017 13/03/07 By xumm 锁资料笔数应该加上子表的笔数
# Modify.........: No:FUN-D30093 13/03/27 By dongsz 調整觸屏下傳首先下傳無效或營運中心失效的資料
# Modify.........: No:FUN-D40064 13/04/17 By xumm POS下傳添加NOT NULL屬性欄位的WHERE過濾條件

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapcp200.global" 
        
DEFINE g_posdbs     LIKE ryg_file.ryg00  #傳輸DB.
DEFINE g_posdbs_t   LIKE ryg_file.ryg00  #傳輸DB
DEFINE g_posdbs_o   LIKE ryg_file.ryg00  #傳輸DB
DEFINE g_db_links   LIKE ryg_file.ryg02  #@DB LINK
DEFINE g_db_links_t LIKE ryg_file.ryg02  #DB LINK
DEFINE g_sql        STRING
DEFINE g_wc         STRING
DEFINE g_all_plant  STRING               #当前下传门店
DEFINE g_all_plant1 STRING               #所有下传门店
DEFINE g_db_type    LIKE type_file.chr3
DEFINE g_posway     LIKE type_file.chr1
DEFINE g_pos_fld    LIKE gaq_file.gaq01 
DEFINE g_plant_fld  LIKE gaq_file.gaq01 
DEFINE g_plantstr   STRING               #指定营运中心
DEFINE g_plantstr2  STRING               #FUN-BC0015 add
DEFINE g_ryy        RECORD LIKE ryy_file.*
DEFINE g_trans_no   LIKE ryy_file.ryy01  #傳輸序號
DEFINE g_trans_no1  LIKE ryy_file.ryy01  #傳輸序號2
DEFINE g_time       LIKE type_file.chr8  #TIME   
DEFINE g_down_n     LIKE type_file.num10 #下传成功的标识
DEFINE g_lock_n     LIKE type_file.num10 #锁定个数
DEFINE g_date       LIKE type_file.dat   # 指定日期 &起始日期
DEFINE g_data_flag  LIKE type_file.chr1  #是否已经开启#数据进程控制
DEFINE g_flag       LIKE type_file.chr1  #主表执行状态标识
DEFINE g_pid        LIKE gbq_file.gbq01
DEFINE ls_date      LIKE type_file.chr20
DEFINE g_msg1       LIKE type_file.chr1000  #其他錯誤信息
DEFINE g_msg        LIKE type_file.chr1000  #錯誤訊息
DEFINE g_azw01      LIKE azw_file.azw01  #当前-营运中心 
DEFINE g_azw05      LIKE azw_file.azw05  #当前-实体DB
DEFINE g_ryk01      LIKE ryk_file.ryk01  #当前-传输的项次  
DEFINE g_ryk02      LIKE ryk_file.ryk02  #当前-传输的ERP的表 
DEFINE g_ryk03      LIKE ryk_file.ryk03  #当前-传输的POS的表 
DEFINE g_ryk04      LIKE ryk_file.ryk04  
DEFINE g_lock_flag  LIKE type_file.chr1  #是否使用锁机制
DEFINE g_err_count  LIKE type_file.num5  
DEFINE g_rcj13      LIKE rcj_file.rcj13  #FUN-D30093 add
 
FUNCTION p100_cs()
DEFINE l_wc    STRING
DEFINE l_n     LIKE type_file.num5

  #创建临时表抓取table ->实体DB,主要是同义词问题
   WHENEVER ERROR CONTINUE
   DROP TABLE azw_temp
   CREATE TEMP TABLE azw_temp(
                               azw01 LIKE azw_file.azw01,
                               azw05 LIKE azw_file.azw05,
                               ryg00 LIKE ryg_file.ryg00,
                               ryg02 LIKE ryg_file.ryg02)  

   LET g_sql = " INSERT INTO azw_temp ",
               " SELECT  azw01,azw05,ryg00,ryg02 FROM  azw_file,ryg_file " , 
               " WHERE azw01 = ryg01  AND  rygacti = 'Y' "
   IF  NOT cl_null(g_plantstr) THEN 
       LET l_wc  = "('",cl_replace_str(g_plantstr,"|","','"),"')"
  #    LET g_sql = g_sql CLIPPED," AND  ryg01 IN ",l_wc
   END IF
   IF  NOT cl_null(g_posdbs_o) THEN
       LET g_sql = g_sql CLIPPED," AND  ryg00 = '",g_posdbs_o,"'"
   END IF  
   PREPARE ins_azw_pre FROM g_sql
   EXECUTE ins_azw_pre
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('ins azw_temp','','ins azw_temp',SQLCA.sqlcode,1)
   END IF 
   LET g_sql = " SELECT COUNT(*) FROM all_synonyms,azw_temp ",               #判断是否存在同义词                        
               " WHERE  LOWER(owner) = azw05 AND table_name = UPPER('",g_ryk02 CLIPPED,"') AND azw05 <> LOWER(table_owner)" 
   PREPARE chk_synonyms FROM g_sql
   EXECUTE chk_synonyms INTO l_n 
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('l_n','','chk_synonyms',SQLCA.sqlcode,1)
   END IF
   IF l_n >0 THEN                         
      LET g_sql = " UPDATE azw_temp ",
                  " SET azw05 = (SELECT LOWER(table_owner) FROM all_synonyms ",
                  "               WHERE LOWER(owner) = azw05 ",
                  "                 AND table_name = UPPER('",g_ryk02 CLIPPED,"'))" ,
                  " WHERE EXISTS (SELECT 1 FROM all_synonyms ",
                  "                WHERE LOWER(owner) = azw05 AND table_name = UPPER('",g_ryk02 CLIPPED,"') ",
                  "                  AND azw05 <> LOWER(table_owner) )"       
      PREPARE upd_azw_pre FROM g_sql
      EXECUTE upd_azw_pre 
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL s_errmsg('','','upd azw_temp',SQLCA.sqlcode,1)
      END IF
   END IF 

  #定义CURSOR 
   LET g_sql = " SELECT DISTINCT azw05 FROM azw_temp "           #下传的实体DB
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               "  WHERE azw01 IN ",l_wc CLIPPED," ORDER BY azw05"
   END IF
   PREPARE sel_azw05_pre FROM g_sql
   DECLARE sel_azw05_cur CURSOR WITH HOLD FOR sel_azw05_pre  

   LET g_sql = " SELECT azw01,ryg00,ryg02 FROM azw_temp ",       #下传的TIPTOP营运中心
               "  WHERE  azw05 = ? ",
               "  ORDER BY azw01"
   PREPARE sel_azw01_pre FROM g_sql
   DECLARE sel_azw01_cur CURSOR WITH HOLD FOR  sel_azw01_pre

END FUNCTION

FUNCTION p100(l_posstr,l_plantstr,l_posdbs,l_date,l_posway)  #主程序入口
DEFINE l_posstr     STRING               # 指定傳輸的table对应的项次
DEFINE l_plantstr   STRING               # 指定营运中心
DEFINE l_posdbs     LIKE ryg_file.ryg00  # 指定傳輸DB
DEFINE l_date       LIKE type_file.dat   # 指定日期 
DEFINE l_posway     LIKE type_file.chr1  # 1.手工異動下傳 2.初始化下傳
DEFINE tok          base.StringTokenizer
DEFINE l_sql        STRING
DEFINE l_n          LIKE type_file.num5
DEFINE l_n1         LIKE type_file.num5  #FUN-D10060 add
DEFINE l_flag       LIKE type_file.chr1
DEFINE l_num        LIKE type_file.num20 #FUN-D30093 add
DEFINE l_str        STRING               #FUN-D30093 add
DEFINE l_str1       STRING               #FUN-D30093 add 
DEFINE l_wc  string  

   WHENEVER ERROR CALL cl_err_msg_log
   LET ls_date = g_today USING 'YYYYMMDD'   #系统日期 
   LET g_date  = l_date                     #指定日期
   LET g_pid   = FGL_GETPID()
   LET g_db_type = cl_db_get_database_type() #未使用
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
   LET g_posway = l_posway    
   LET g_trans_no = p100_trans_no()        #获取传输单号 
  #LET g_trans_no1 = p100_trans_no()
   LET g_ryy.ryy02 = g_today              
   LET g_ryy.ryy03 = TIME
   LET g_plantstr = l_plantstr              #营运中心
   LET g_posdbs_o =  l_posdbs               #中间库DB （后面可能会传多个)
   IF  g_posway = '1' THEN      #锁机制的开关  目前只支持一般下传锁定 若不需要可都改为N  
       LET g_lock_flag = 'Y' 
   ELSE 
       LET g_lock_flag = 'N'      
   END IF                       
   CALL s_showmsg_init()        #錯誤訊息統整初始化函式
   CALL p100_process_chk()      #判斷進程 
   LET g_err_count = 0  
   LET tok = base.StringTokenizer.create(l_posstr,"|")   
   WHILE tok.hasMoreTokens()                               #遍历项次（即table)
       LET g_ryk01 = tok.nextToken() 
       IF g_bgjob = "N" THEN                      
          MESSAGE g_ryk01," Begin ...." 
          CALL ui.Interface.refresh()
       END IF                                  
       SELECT ryk02,ryk03,ryk04 INTO g_ryk02,g_ryk03,g_ryk04 FROM ryk_file WHERE ryk01 = g_ryk01       
       IF SQLCA.SQLCODE THEN
	      CALL s_errmsg('ryk01',g_ryk01,'sel ryk_file','apc-142',1)
          CONTINUE WHILE
       END IF
       CALL p100_cs()               #按照表名定义遍历CURSOR
       LET g_ryk02 = DOWNSHIFT(g_ryk02)                    #ERP表名
       LET g_ryk02 = g_ryk02[1,8]
       LET g_ryk03 = DOWNSHIFT(g_ryk03)                    #POS表名
       FOREACH sel_azw05_cur INTO g_azw05                  #遍历实体DB
          IF SQLCA.sqlcode THEN  CALL s_errmsg('azw05','','sel_azw05_cur',SQLCA.sqlcode,1)  END IF
          IF cl_null(g_azw05) THEN  CONTINUE FOREACH END IF
          LET g_success = 'Y'
          LET g_lock_n  = 0 
          LET g_down_n  = 0
          LET g_azw01   = null  
          LET g_flag    = 'Y'
          BEGIN WORK              #Transaction事物开始 
             CALL p100_getplant(g_azw05) #获取一个DB下的 需要下传的下传的所有营运中心到变量 g_all_plant   用于锁定 和 回写条件
            #FUN-D30093--add--str---
             IF g_ryk01 = "207" THEN                   
                LET l_str = g_trans_no
                LET l_num = l_str.subString(2,l_str.getLength()) - 1 
                LET l_str1 = l_num
                LET l_str1 = l_str1.trimLeft()
                LET g_trans_no1 = l_str.subString(1,1),l_str1       
             ELSE                   
            #FUN-D30093--add--end---                   
                LET g_trans_no1 = p100_trans_no()       #抓删除的任务编号
             END IF                                     #FUN-D30093 add
             IF g_lock_flag ='Y' THEN                #锁定资料:更新标识锁定,区分下传中新增修改数据标识 
                CALL p100_upd_posflag(g_ryk01,'1')   #锁定单表或主表信息
                IF g_success = 'Y' AND g_lock_n = 0 THEN 
                   IF g_bgjob = "N" THEN                   
                      MESSAGE "TABLE:",g_ryk01," DB:",g_azw05," PLANT:",g_all_plant," No Data!"  
                      CALL ui.Interface.refresh()
                   END IF                                
                   ROLLBACK WORK
                   CONTINUE FOREACH
                END IF 
             END IF
             CALL p100_down()                      #下传开始
             CALL p100_upd_posflag(g_ryk01,'4')    #更新标识  
            #CALL p100_tk_TransTaskHead_ins('1')
             CALL p100_tk_TransTaskHead_ins('3')
             IF g_success = 'Y' THEN               #事物结束
                IF g_down_n  > 0 THEN 
                   LET g_ryy.ryy04 = g_today
                   LET g_ryy.ryy05 = TIME
                   SELECT COUNT(*) INTO l_n FROM ryy_file WHERE ryy01 = g_trans_no
                   IF l_n = 0 THEN
                      INSERT INTO ryy_file VALUES (g_ryy.*)
                   ELSE
                      UPDATE ryy_file SET ryy04 = g_ryy.ryy04,
                                          ryy05 = g_ryy.ryy05 
                         WHERE ryy01 = g_trans_no
                   END IF
                END IF
                IF g_bgjob = "N" THEN                  
                   MESSAGE "TABLE:",g_ryk01," DB:",g_azw05," PLANT:",g_all_plant," success!"  
                   CALL ui.Interface.refresh()
                END IF                                  
                COMMIT WORK
             ELSE
                IF g_bgjob = "N" THEN                 
                   MESSAGE "TABLE:",g_ryk01," DB:",g_azw05," PLANT:",g_all_plant," failure!"  
                  CALL ui.Interface.refresh()
                END IF                                 
                ROLLBACK WORK
                CALL p200_log(g_trans_no,g_azw01,' ',' ',g_ryk02||"->"||g_ryk03,g_errno,g_msg,'1','N',g_msg1) 
             END IF               
       END FOREACH                                           #结束DB遍历
   END WHILE
   IF g_posway = '1' THEN          #异动下传写入1 ，初始化写入4
      CALL p100_tk_TransTaskHead_ins('1')
   ELSE                         
      CALL p100_tk_TransTaskHead_ins('4')         
   END IF
   IF g_err_count > 0 THEN 
      LET g_success = 'N'
   END IF
   
   #FUN-D10060------add---str
   LET l_n1 = 0
   SELECT COUNT(*) INTO l_n1 FROM ryl_file WHERE ryl01 = g_trans_no 
   IF l_n1 > 0 THEN
      CALL s_send_mail(g_prog,g_trans_no)
   END IF
   #FUN-D10060------add---end
   CALL s_showmsg()
END FUNCTION

FUNCTION p100_upd_posflag(p_ryk01,p_type)        #更新标识
DEFINE p_ryk01 LIKE ryk_file.ryk01               #对应下传信息的项次 
DEFINE p_type  LIKE type_file.chr1               #更新类型：1下传内容限制更新，4回写更新
DEFINE l_ryk02 LIKE ryk_file.ryk02
   IF p_type = '4' THEN  
      IF g_posway  = '2' THEN RETURN END IF  #初始化下傳不回填
      IF g_down_n  =  0  THEN RETURN END IF  #无资料 不需回写
   END IF
   IF g_success = 'N' THEN RETURN END IF  #前面异常无需回写
   LET l_ryk02 = g_ryk02
   CALL p100_g_wc(g_ryk02,p_type)   RETURNING g_wc   #获取更新表的条件信息

   CASE p_ryk01                                                                               
        WHEN '101'   #门店资料
	   LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'azw_file'),
                   "                              WHERE azw01 = rtz01) ",
                   " AND rtz28 = 'Y' AND rtz01 IN  ",g_all_plant CLIPPED
       #FUN-C90090 Begin---
        WHEN '1012'  #门店收银机
           LET l_ryk02 = 'ryc_file' 
           CALL p100_g_wc('ryc_file',p_type) RETURNING g_wc 
	   LET g_wc = g_wc CLIPPED,"   AND ryc01 IN  ",g_all_plant CLIPPED
       #FUN-C90090 End-----
        WHEN '102'   #门店权限资料
               LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryr_file'),
                       " WHERE ryracti = 'Y') "
        WHEN '1021'  #门店权限资料
           LET l_ryk02 = 'ryp_file' 
           CALL p100_g_wc('ryp_file',p_type) RETURNING g_wc 
        WHEN '1022'  #门店权限资料
           LET l_ryk02 = 'ryq_file' 
           CALL p100_g_wc('ryq_file',p_type) RETURNING g_wc 
        WHEN '103'   #POS使用者资料
           LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryo_file'),
	                 " WHERE ryo01 = ryi01 AND ryo02 IN ",g_all_plant CLIPPED,")" 
	                #" WHERE ryo01 = ryi01 AND ryoacti = 'Y' AND ryo02 IN ",g_all_plant CLIPPED,")"  #Mark By shi 20120716
        WHEN '104'  #商户摊位资料(合同)
           LET g_wc = g_wc CLIPPED," AND lnt26 IN ('Y','S','E') AND lntplant IN ",g_all_plant CLIPPED
        WHEN '1041'   #商户摊位资料(预租协议)
           LET l_ryk02 = 'lih_file'
           CALL p100_g_wc('lih_file',p_type) RETURNING g_wc
           LET g_wc = g_wc CLIPPED," AND lihconf IN ('Y','S') AND lihplant IN ",g_all_plant CLIPPED
        WHEN '105'   #款别资料
               LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryd_file'),
                       " WHERE rydacti = 'Y')"
        WHEN '106'   #券种资料
           LET g_wc = g_wc CLIPPED," AND lpx15 = 'Y' ",
                                   " AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lnk_file'),
                                   "              WHERE lnk01 = lpx01 AND lnk02 = '2'  AND lnk03 IN ",g_all_plant CLIPPED," )" 
       #FUN-CC0058 Begin---
        WHEN '1061'   #收券规则
          LET l_ryk02 = 'ltp_file'
          CALL p100_g_wc('ltp_file',p_type) RETURNING g_wc
          LET g_wc = g_wc CLIPPED," AND ltpconf = 'Y' AND ltp11 = 'Y' ",
                                  " AND ltpplant IN ",g_all_plant CLIPPED     
       #FUN-CC0058 End-----
        WHEN '107'   #联盟卡种资料
               LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rxw_file'),")"
        WHEN '108'   #发票簿资料
               LET g_wc = g_wc CLIPPED," AND oom17 = 'N' AND oom15 = ' ' AND oom14 IN ",g_all_plant CLIPPED
        WHEN '109'   #税别资料
               LET g_wc = g_wc CLIPPED," AND gec011='2' "
        #FUN-CA0074------add----str
        WHEN '110'   #POS参数编号资料
               LET l_ryk02 = 'rzc_file'
               CALL p100_g_wc('rzc_file',p_type) RETURNING g_wc
        WHEN '1102'  #门店POS参数设置资料
               LET l_ryk02 = 'rze_file'
               CALL p100_g_wc('rze_file',p_type) RETURNING g_wc
               LET g_wc = g_wc CLIPPED," AND rze01 IN ",g_all_plant CLIPPED
        #FUN-CA0074------add----end
        #FUN-CC0116------add----str
        WHEN '111'   #专柜抽成资料
             LET l_ryk02 = 'rca_file'
             CALL p100_g_wc('rca_file',p_type) RETURNING g_wc
             LET g_wc = g_wc CLIPPED," AND rcaconf = 'Y'"," AND rca01 IN ",g_all_plant CLIPPED
        #FUN-CC0116------add----end
        WHEN '201'   #产品策略
           LET g_wc = g_wc CLIPPED,
                      " AND rte01||rte03 IN (SELECT DISTINCT rte01||rte03 FROM ", cl_get_target_table(g_azw01,'rte_file'),",",
                                                                                  cl_get_target_table(g_azw01,'rtd_file'),",",
                                                                                  cl_get_target_table(g_azw01,'ima_file'),",rtz_temp",
                      "                       WHERE rte01 = rtd01 AND rte03 = ima01 AND rtdconf = 'Y' ",
                      "                         AND rtz04 = rte01 AND ",g_wc CLIPPED,
                      "                       GROUP BY rte01,rte03 ",
                      "                       HAVING COUNT(DISTINCT rtz05) = ( SELECT COUNT(DISTINCT rte01||rtg01||rte03) FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                                                                                 cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
                      "                                                        WHERE  rtz05=rtg01  and rta01=rtg03 and rta03 = rtg04  and rtz04=rte01 and rte03=rtg03 ))"
        WHEN '202'   #价格策略（自定价)
           LET g_wc = g_wc CLIPPED,
                      " AND (rtg01||rtg02) IN (SELECT rtg01||rtg02 ",
                      "                          FROM ",cl_get_target_table(g_azw01,'rtf_file'),",",
                                                        cl_get_target_table(g_azw01,'rtg_file'),",",
                                                        cl_get_target_table(g_azw01,'rta_file'),",rtz_temp,",
                      "                                 (SELECT DISTINCT rte01 rte01_1, rte03 rte03_1 ",
                      "                                    FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
                                                                  cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
                      "                                   WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
                      "                                     AND rtz04 = rte01 GROUP BY rte01,rte03 ",
                      "                                   HAVING COUNT(DISTINCT rtz05)  = (SELECT COUNT(DISTINCT rte01||rtg01||rte03)",
                      "                                                                      FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                                                    cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
                      "                                                                     WHERE rtz05=rtg01  AND rtz04=rte01 AND rte03=rtg03",
                      "                                                                       AND rta01=rtg03 AND rta03 = rtg04))",
                      "                         WHERE rtf01 = rtg01 AND rtfconf = 'Y' ",
                      "                           AND rta01 = rtg03 AND rta03 = rtg04 ",
                      "                           AND ",g_wc CLIPPED,
                      "                           AND rtz05 = rtg01 AND rte01_1 = rtz04 AND rte03_1 = rtg03)"
        WHEN '2022' #自定价
           LET l_ryk02 = 'rth_file'
           CALL p100_g_wc('rth_file',p_type) RETURNING g_wc  
           LET g_wc = g_wc CLIPPED,
                      " AND rth01||rth02||rthplant IN ",
                      "     (SELECT rth01||rth02||rthplant ",
                      "        FROM ",cl_get_target_table(g_azw01,'rth_file'),",",
                                      cl_get_target_table(g_azw01,'rtf_file'),",",
                                      cl_get_target_table(g_azw01,'rtg_file'),",",
                                      cl_get_target_table(g_azw01,'rta_file'),",rtz_temp,",
                      "               (SELECT DISTINCT rte01 rte01_1, rte03 rte03_1 ",
                      "                  FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
                                                cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
                      "                 WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
                      "                   AND rtz04 = rte01 GROUP BY rte01,rte03 ",
                      "                 HAVING COUNT(DISTINCT rtz05)  = (SELECT COUNT(DISTINCT rte01||rtg01||rte03)",
                      "                                                    FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                                  cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
                      "                                                   WHERE rtz05=rtg01  AND rtz04=rte01 AND rte03=rtg03",
                      "                                                     AND rta01=rtg03 AND rta03 = rtg04))",
                      "       WHERE rth01 = rtg03 AND rth02 = rtg04 AND rtg08 = 'Y' ",
                      "         AND rtf01 = rtg01 AND rtfconf = 'Y'",
                      "         AND rta01 = rtg03 AND rta03 = rtg04 ",
                      "         AND rthplant IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
                      "         AND rtz05 = rtg01 AND rte01_1 = rtz04 AND rte03_1 = rtg03)"
        WHEN '203'   #商户摊位产品资料
               LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lmf_file'),
                                   "              WHERE lmf01 = lmv03 AND lmf06 = 'Y' AND lmfstore IN ",g_all_plant CLIPPED,")"
        WHEN '204'   #颜色
               LET g_wc = g_wc CLIPPED," AND tqaacti = 'Y' AND tqa03 = '25'"
        WHEN '205'   #尺寸
               LET g_wc = g_wc CLIPPED," AND tqaacti = 'Y' AND tqa03 = '26'"
        WHEN '206'   #单位
               LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'gfe_file'),
                       " WHERE gfeacti = 'Y')"
       #FUN-D20020--add--str---
        WHEN '207'  #觸屏資料
           LET g_wc = g_wc CLIPPED," AND rzi01 IN (SELECT rzl01 FROM ",cl_get_target_table(g_azw01,'rzl_file')," WHERE rzl02 IN ",g_all_plant CLIPPED,")"
       #FUN-D20020--add--end---
        WHEN '301'   #一般促销
           LET l_ryk02 = 'rac_file'
           LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rab_file'),",",
                                                                 cl_get_target_table(g_azw01,'rac_file'),",",
                                                                 cl_get_target_table(g_azw01,'raq_file'),
                                   "              WHERE rab01 = rac01 AND rab02 = rac02 AND rabplant = racplant ",
                                   "                AND rab01 = raq01 AND rab02 = raq02 AND rabplant = raqplant AND raq03 = '1'",
                                  #"                AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' ",
                                   "                AND rabconf = 'Y' AND raq05 = 'Y'",
                                   "                AND rabplant IN ",g_all_plant CLIPPED," AND raq04 = rabplant ) "
        WHEN '302'   #组合促销
           LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rae_file'),",",
                                                                 cl_get_target_table(g_azw01,'raq_file'),
                                   "              WHERE rae01 = raq01 AND rae02 = raq02 AND raeplant = raqplant AND raq03 = '2'",
                                  #"                AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' ",
                                   "                AND raeconf = 'Y' AND raq05 = 'Y' ",
                                   "                AND raeplant IN ",g_all_plant CLIPPED," AND raq04 = raeplant ) "
        WHEN '303'   #满额促销
           LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rah_file'),",",
                                                                 cl_get_target_table(g_azw01,'raq_file'),
                                   "              WHERE rah01 = raq01 AND rah02 = raq02 AND rahplant = raqplant AND raq03 = '3'",
                                  #"                AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' ",
                                   "                AND rahconf = 'Y' AND raq05 = 'Y'",
                                   "                AND rahplant IN ",g_all_plant CLIPPED," AND raq04 = rahplant ) "
        WHEN '401'   #会员基本资料
           LET g_wc = g_wc CLIPPED," AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lpj_file'),",",
                                                                 cl_get_target_table(g_azw01,'lnk_file'),
                                   "              WHERE lpk01 = lpj01 AND lpj02 = lnk01 AND lnk02 = '1'",
                                   "                AND lnk05 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED,") "
        WHEN '402'   #会员卡种资料                                             
           LET g_wc = g_wc CLIPPED," AND lph24 = 'Y'  AND EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lnk_file'),
	                          #" WHERE  lnk01 = lph01 AND lnk02 = '1' AND lnk05 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED," )"   
                                   " WHERE  lnk01 = lph01 AND lnk02 = '1' AND lnk03 IN ",g_all_plant CLIPPED," )"  
        WHEN '403'   #会员卡明细资料  
           LET g_wc = g_wc CLIPPED," AND (lpj01 IS NOT NULL AND lpj01 <> ' ') ",
                                   " AND lpj02 IN (SELECT lnk01 FROM ",cl_get_target_table(g_azw01,'lnk_file'),
                                   "                WHERE lnk02 ='1' AND lnk05 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED,")" 
        WHEN '404'   #积分/折扣规则
          LET g_wc = g_wc CLIPPED," AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y' ",
                                  " AND lrpplant IN ",g_all_plant CLIPPED     
        #FUN-CB0007-----------add---------str
        WHEN '405'   #会员等级
          LET g_wc = g_wc CLIPPED," AND lpc00 = '6' "
        WHEN '406'   #会员类型
          LET g_wc = g_wc CLIPPED," AND lpc00 = '7' "
        #FUN-CB0007-----------add---------end
    
   END CASE
   IF cl_null(g_pos_fld) THEN RETURN END IF #没有更新标识栏位
   IF p_type = '1' THEN
      LET g_sql = " UPDATE ",cl_get_target_table(g_azw01,l_ryk02)," SET ",g_pos_fld," = '5' WHERE ",g_wc CLIPPED 
   ELSE  
      LET g_sql = " UPDATE ",cl_get_target_table(g_azw01,l_ryk02)," SET ",g_pos_fld," = '3' WHERE ",g_wc CLIPPED
   END IF 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
   PREPARE upd_pos_pre FROM g_sql
   TRY
      EXECUTE upd_pos_pre
      IF p_type = '1' THEN 
        #FUN-D30017-----Mark&Add-----Str
        #IF p_ryk01 = '1021' OR p_ryk01 = '1022' OR p_ryk01='1041' OR 
        #   p_ryk01 = '1012' OR p_ryk01 = '1061' OR #FUN-CC0058 Add
        #   p_ryk01 = '2022' THEN 
        #   LET g_lock_n = g_lock_n + SQLCA.sqlerrd[3]
        #ELSE  
        #   LET g_lock_n = SQLCA.sqlerrd[3]
        #END IF
         LET g_lock_n = g_lock_n + SQLCA.sqlerrd[3]
        #FUN-D30017-----Mark&Add-----End
      END IF 
   CATCH 
      IF SQLCA.sqlcode THEN
         DISPLAY "ERROR SQL : ", g_sql  
         LET g_success='N'
         LET g_errno = SQLCA.sqlcode  
         CALL s_errmsg(g_pos_fld,l_ryk02,'upd xxxpos",l_ryk02||'-'||p_type,"',SQLCA.sqlcode,1)
         LET g_msg1="ryk01:",g_ryk01,"(",g_ryk04,"),DB:",g_azw05,",UPDATE_xxxpos_ERROR:",p_type 
       	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
      END IF
   END TRY
   IF p_ryk01 = '101' THEN CALL p100_upd_posflag(1012,p_type)  END IF #FUN-C90090
   IF p_ryk01 = '102' THEN CALL p100_upd_posflag(1021,p_type)  END IF 
   IF p_ryk01 = '102' THEN CALL p100_upd_posflag(1022,p_type)  END IF 
   IF p_ryk01 = '104' THEN CALL p100_upd_posflag(1041,p_type)  END IF 
   IF p_ryk01 = '106' THEN CALL p100_upd_posflag(1061,p_type)  END IF #FUN-CC0058
   IF p_ryk01 = '110' THEN CALL p100_upd_posflag(1102,p_type)  END IF #FUN-CA0074
   IF p_ryk01 = '202' THEN CALL p100_upd_posflag(2022,p_type)  END IF 
END FUNCTION

FUNCTION p100_down()                     #下传开始  根据项次执行对应FUN
   LET g_time = TIME                  
   CALL p100_g_wc(g_ryk02,'3') RETURNING g_wc  
   CASE  g_ryk01
        WHEN "101"
             CALL  p100_down_101()       #门店基本资料    rte_file->ta_ShopInfo
             CALL  p100_down_1011()      #取货门店资料    rtz_file->ta_TakeStock
             CALL  p100_down_1012()      #门店收银机资料  ryc_file->ta_MachineInfo #FUN-C90090
        WHEN "102"                       #门店权限资料    ryr_file->th_Role
             CALL  p100_down_102() 
        WHEN "103"                       #POS使用者资料   ryi_file->th_Staffs
             CALL  p100_down_103()
             CALL  p100_down_1031()
        WHEN "104"                       #商户摊位资料    lnt_file->tb_Counter
             CALL  p100_down_104()
        WHEN "105"                       #款别资料        ryd_file->ta_Payment
             CALL  p100_down_105()  
        WHEN "106"                       #券种资料        lpx_file->ta_Coupon
             CALL  p100_down_106()               
        WHEN "107"                       #联盟卡种资料    rxw_file->ta_ExpenseCard  
             CALL  p100_down_107()
        WHEN "108"                       #发票资料        oom_file->ta_InvoiceBook
             CALL  p100_down_108()
        WHEN "109"                       #税别资料        gec_file->tb_TaxCategory
             CALL  p100_down_109()
        #FUN-CA0074----add----str
        WHEN "110"
             CALL  p100_down_110()       #POS参数编号资料     rzc_file->ta_BaseSetTemp
             CALL  p100_down_1101()      #POS参数值资料       rzd_file->ta_BaseSetTemp_Para
             CALL  p100_down_1102()      #POS门店参数设置资料 rze_file->ta_BaseSet
        #FUN-CA0074----add----end
        WHEN "111"                       #FUN-CC0116
             CALL  p100_down_111()       #专柜抽成资料    rca->tb_MallCode   #FUN-CC0116
        WHEN "201"                       #产品策略        rte_file->tb_Goods
                                         #产品特征码      rte_file->tb_Feature
             CALL  p100_down_201()       
        WHEN "202"                       #价格策略        rtg_file->tb_Price  
                                         #条码            rta_file->tb_BarCode
                                         #自定价          rth_file->tb_Price_Shop
             CALL  p100_down_202()  
        WHEN "203"                       #商户产品资料    lmv_file->tb_CounterGoods  
             CALL  p100_down_203()  
        WHEN "204"                       #颜色            tqa_file->tb_Attribute1
             CALL  p100_down_204()
        WHEN "205"                       #尺寸            tqa_file->tb_Attribute2
             CALL  p100_down_205()
        WHEN "206"                       #单位            gfe_file->tb_Unit
             CALL  p100_down_206()
       #FUN-D20020--add--str---
        WHEN "207"                       #觸屏分類資料    rzj_file->tb_Class
           CALL p100_down_207()
           CALL p100_down_2071()         #觸屏產品資料    rzk_file->tb_Class_Goods
           CALL p100_tk_TransTaskDetail_del(g_ryk01)      #FUN-D30093 add
       #FUN-D20020--add--end---
        WHEN "301"                       #一般促销     
             CALL  p100_down_301()  
        WHEN "302"                       #组合促销
             CALL  p100_down_302()
        WHEN "303"                       #满额促销  
             CALL  p100_down_303()
        WHEN "401"                       #会员基本资料    lpk_file->tf_Member
                                         #                lpa_file->tf_Member_Day
             CALL  p100_down_401()
        WHEN "402"                       #会员卡种资料    lph_file->tf_CardType
             CALL  p100_down_402()
        WHEN "403"                       #会员卡明细资料  lpj_file->tf_CardType_Status
             CALL  p100_down_403()	
        WHEN "404"                       #积分/折扣规则   lrp_file->tf_CardType_Rule
             CALL  p100_down_404()
             CALL  p100_down_4041()      #                lrq_file->tf_CardType_Rule_Detail
             CALL  p100_down_4042()      #                lrr_file->tf_CardType_Rule_Ndetail
             CALL  p100_down_4043()      #                lth_file->tf_CardType_Rule_MDetail
        #FUN-CB0007-------add-----str
        WHEN "405"                       #会员等级        lpc_file->tf_Member_Grade
             CALL  p100_down_405()                         
        WHEN "406"                       #会员类型        lpc_file->tf_Member_Type
             CALL  p100_down_406()
        #FUN-CB0007-------add-----end
   END CASE
END FUNCTION 

FUNCTION  p100_down_101()     #门店基本资料  
   LET g_ryk03 = "ta_ShopInfo" 
  #更新门店资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有门店的资料
  #关联ryg_file，不用g_all_plant，初始化时只记录初始化的门店
   LET g_sql = " UPDATE ",g_posdbs,"ta_ShopInfo",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,SHOPNAME,SHOPTYPE,SUBRate1,SUBRate2,SUBRate3,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rtz13,CASE rtz03 WHEN '3' THEN 'Y' ELSE 'N' END,rtz31,rtz32,rtz33,azwacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (SHOPNAME,SHOPTYPE,SUBRate1,SUBRate2,SUBRate3,CNFFLG) = ",
               "        (SELECT rtz13,CASE rtz03 WHEN '3' THEN 'Y' ELSE 'N' END,rtz31,rtz32,rtz33,azwacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
                                  cl_get_target_table(g_azw01,'azw_file'),
              #"          WHERE SHOP = rtz01 AND rtz01 = azw01 )",               #FUN-D40064 Mark
               #FUN-D40064------add---str
               "          WHERE SHOP = rtz01 AND rtz01 = azw01 ",
               "            AND rtz13 IS NOT NULL AND rtz31 IS NOT NULL ",
               "            AND rtz32 IS NOT NULL AND rtz33 IS NOT NULL )",
               #FUN-D40064------add---end 
               "  WHERE SHOP IN (SELECT rtz01 FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
                                                     cl_get_target_table(g_azw01,'azw_file'),
               "                  WHERE SHOP = rtz01 AND rtz01 = azw01 AND rtz28 = 'Y' ",
               "                    AND rtz13 IS NOT NULL AND rtz31 IS NOT NULL ",      #FUN-D40064 Add
               "                    AND rtz32 IS NOT NULL AND rtz33 IS NOT NULL ",      #FUN-D40064 Add
               "                    AND azw01 IN ",g_all_plant CLIPPED,
               "                    AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_ShopInfo",g_db_links," (",
                " Condition1,Condition2, ",
                " SHOP,SHOPNAME,SHOPTYPE,SUBRate1,SUBRate2,SUBRate3,CNFFLG )", 
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        rtz01,rtz13,CASE rtz03 WHEN '3' THEN 'Y' ELSE 'N' END,rtz31,rtz32,rtz33,azwacti ",
                "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
                           cl_get_target_table(g_azw01,'azw_file'),
                "  WHERE azw01 = rtz01 AND rtz28 = 'Y' ",
                "    AND rtz13 IS NOT NULL AND rtz31 IS NOT NULL ",      #FUN-D40064 Add
                "    AND rtz32 IS NOT NULL AND rtz33 IS NOT NULL ",      #FUN-D40064 Add
                "    AND azw01 IN ",g_all_plant CLIPPED,
                "    AND ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_ShopInfo",g_db_links,
                "                    WHERE Condition2 ='",g_azw05,"' AND SHOP = rtz01 )" 
   CALL p100_postable_ins(g_sql,'Y')  
   IF g_success = 'N' THEN RETURN END IF

  #写请求表:只下传到当前的门店下
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_ShopInfo',' SHOP = '||''''||azw01||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_ShopInfo',' SHOP = '||''''||azw01||''''||' AND Condition1 = '||''''||'",g_trans_no,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
                          cl_get_target_table(g_azw01,'azw_file'),
               "  WHERE azw01 = rtz01 AND rtz28 = 'Y' ",
               "    AND rtz13 IS NOT NULL AND rtz31 IS NOT NULL ",      #FUN-D40064 Add
               "    AND rtz32 IS NOT NULL AND rtz33 IS NOT NULL ",      #FUN-D40064 Add 
               "    AND ",g_wc CLIPPED,
               "    AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION p100_down_1011()    #取货门店资料    #rtz_file->ta_TakeStock
   LET g_ryk03 = "ta_TakeStock"
  #更新门店资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有门店的资料
  #关联ryg_file，不用g_all_plant，初始化时只记录初始化的门店
   LET g_sql = " UPDATE ",g_posdbs,"ta_TakeStock",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,SHOPNAME,SHOPTYPE,CNFFLG) = ",
              #"        (SELECT '",g_trans_no,"',rtz13,CASE rtz03 WHEN '3' THEN 'Y' ELSE 'N' END,azwacti "
               "        (SELECT '",g_trans_no,"',rtz13,0 ,azwacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (SHOPNAME,SHOPTYPE,CNFFLG) = ",
              #"        (SELECT rtz13,CASE rtz03 WHEN '3' THEN 'Y' ELSE 'N' END,azwacti "
               "        (SELECT rtz13,0,azwacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
                                  cl_get_target_table(g_azw01,'azw_file'),
              #"          WHERE SHOP = rtz01 AND rtz01 = azw01 )",                         #FUN-D40064 Mark
               "          WHERE SHOP = rtz01 AND rtz01 = azw01 AND rtz13 IS NOT NULL )",   #FUN-D40064 Add
               "  WHERE SHOP IN (SELECT rtz01 FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
                                                     cl_get_target_table(g_azw01,'azw_file'),
               "                  WHERE SHOP = rtz01 AND rtz01 = azw01 AND rtz28 = 'Y' ",
               "                    AND rtz13 IS NOT NULL ",         #FUN-D40064 Add       
               "                    AND Condition2 = '",g_azw05,"'", #FUN-CC0058
               "                    AND azw01 IN ",g_all_plant1 CLIPPED,
               "                    AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF
   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_TakeStock",g_db_links," (",
                " Condition1,Condition2, ",
                " SHOP,SHOPNAME,SHOPTYPE,CNFFLG )",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",        #FUN-CC0058
               #" SELECT '",g_trans_no,"','",g_azw05,"'||azw02, ", #FUN-CC0058
               #"        rtz01,rtz13,CASE rtz03 WHEN '3' THEN 'Y' ELSE 'N' END,azwacti ",
                "        rtz01,rtz13,0,azwacti ",
                "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
                           cl_get_target_table(g_azw01,'azw_file'),
                "  WHERE azw01 = rtz01 AND rtz28 = 'Y' ",
                "    AND rtz13 IS NOT NULL ",            #FUN-D40064 Add
                "    AND azw01 IN ",g_all_plant1 CLIPPED,
                "    AND ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_TakeStock",g_db_links,
                "                    WHERE Condition2 ='",g_azw05,"' AND SHOP = rtz01 )"        #FUN-CC0058
               #"                    WHERE Condition2 ='",g_azw05,"'||azw02 AND SHOP = rtz01 )" #FUN-CC0058
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表:抓同法人下所有门店,
  #如果一个门店有异动，需更新到同法人下所有门店，初始化时只更新到初始化门店，其他门店通过异动下传来做，否则会重复做同样的事情
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
  #FUN-CC0058 Begin---
  #IF g_posway ='2' THEN
  #   LET g_sql = g_sql CLIPPED,
  #            " SELECT DISTINCT azw01,' ','",g_trans_no,"','ta_TakeStock','Condition2 = '||''''||'",g_azw05,"'||azw02||'''','D' "
  #ELSE
  #   LET g_sql = g_sql CLIPPED,
  #            " SELECT DISTINCT azw01,' ','",g_trans_no,"','ta_TakeStock','Condition2 = '||''''||'",g_azw05,"'||azw02||''''||' AND  Condition1 = '||''''||'",g_trans_no,"'||'''','D' "
  #END IF
  #LET g_sql = g_sql CLIPPED,
  #            "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
  #                       cl_get_target_table(g_azw01,'azw_file'),
  #            "  WHERE azw01 = rtz01 AND rtz28 = 'Y' ",
  #            "    AND azw01 IN ",g_all_plant CLIPPED,
  #            "    AND azw02 IN (SELECT azw02 FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
  #                                                   cl_get_target_table(g_azw01,'azw_file'),
  #            "                   WHERE rtz01 = azw01 AND rtz28 = 'Y' ",
  #            "                    AND  azw01 IN ",g_all_plant CLIPPED,
  #            "                    AND ",g_wc CLIPPED,")"
  #抓所有下传门店的资料
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT azw01,' ','",g_trans_no,"','ta_TakeStock','Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT azw01,' ','",g_trans_no,"','ta_TakeStock','Condition2 = '||''''||'",g_azw05,"'||''''||' AND  Condition1 = '||''''||'",g_trans_no,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),",",
                          cl_get_target_table(g_azw01,'azw_file'),
               "  WHERE azw01 = rtz01 AND rtz28 = 'Y' ",
               "    AND rtz13 IS NOT NULL ",        #FUN-D40064 Add
               "    AND azw01 IN ",g_all_plant CLIPPED
  #FUN-CC0058 End-----
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION 

#FUN-C90090 Begin---
FUNCTION p100_down_1012()    #门店收银机资料    #ryc_file->ta_MachineInfo
   LET g_ryk03 = "ta_MachineInfo"
   CALL p100_g_wc('ryc_file','4') RETURNING g_wc
   LET g_sql = " UPDATE ",g_posdbs,"ta_MachineInfo",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Machine,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',ryc02,rycacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (Machine,CNFFLG) = ",
               "        (SELECT ryc02,rycacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'ryc_file'),
               "          WHERE SHOP = ryc01 AND Condition2 = '",g_azw05,"'||ryc01 ",
               "            AND Machine = ryc02)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryc_file'),
               "                 WHERE SHOP = ryc01 AND Condition2 = '",g_azw05,"'||ryc01 ",
               "                   AND Machine = ryc02 AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_MachineInfo",g_db_links," (",
                " Condition1,Condition2, ",
                " SHOP,Machine,CNFFLG )",
                " SELECT '",g_trans_no,"','",g_azw05,"'||ryc01, ",
                "        ryc01,ryc02,rycacti ",
                "   FROM ",cl_get_target_table(g_azw01,'ryc_file'),
                "  WHERE ryc01 IN ",g_all_plant CLIPPED,
                "    AND ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_MachineInfo",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"'||ryc01 AND SHOP = ryc01 ",
                "                       AND Machine = ryc02)"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT ryc01,' ','",g_trans_no,"','ta_MachineInfo','Condition2 = '||''''||'",g_azw05,"'||ryc01||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT ryc01,' ','",g_trans_no,"','ta_MachineInfo','Condition2 = '||''''||'",g_azw05,"'||ryc01||''''||' AND  Condition1 = '||''''||'",g_trans_no,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'ryc_file'),
               "  WHERE ryc01 IN ",g_all_plant CLIPPED,
               "    AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION 
#FUN-C90090 End-----

FUNCTION p100_down_103()   #POS使用者资料     #ryi_file->th_Staffs 
    LET g_ryk03 = "th_Staffs"
   #按照门店+POS用户的方式存储，如果生效门店由Y->N，更新对应门店的这笔用户资料有效否为N，INSERT时只抓取ryoacti=Y的资料
    LET g_sql = " UPDATE ",g_posdbs,"th_Staffs",g_db_links
    IF g_posway ='1' THEN
       LET g_sql = g_sql CLIPPED,
                "    SET (Condition1,OPNAME,PASSWORD,OPGROUP,CNFFLG) = ",
                "        (SELECT '",g_trans_no,"',gen02,ryi03,ryi07,CASE WHEN ryoacti='Y' THEN ryiacti ELSE 'N' END "
    ELSE
       LET g_sql = g_sql CLIPPED,
                "    SET (OPNAME,PASSWORD,OPGROUP,CNFFLG) = ",
                "        (SELECT gen02,ryi03,ryi07,CASE WHEN ryoacti='Y' THEN ryiacti ELSE 'N' END "
    END IF
    LET g_sql = g_sql CLIPPED,
                "           FROM ",cl_get_target_table(g_azw01,'ryi_file')," LEFT OUTER JOIN ",
                                   cl_get_target_table(g_azw01,'gen_file')," ON (ryi02 = gen01),",
                                   cl_get_target_table(g_azw01,'ryo_file'),
               #"          WHERE ryi01 = ryo01 AND OPNO = ryi01 AND Condition2 = '",g_azw05,"'||ryo02)",   #FUN-D40064 Mark
                "          WHERE ryi01 = ryo01 AND OPNO = ryi01 AND Condition2 = '",g_azw05,"'||ryo02 ",   #FUN-D40064 Add
                "            AND ryi07 IS NOT NULL)",                                                      #FUN-D40064 Add  
                "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryi_file'),",",
                                                 cl_get_target_table(g_azw01,'ryo_file'),
                "                 WHERE ryi01 = ryo01 ",  #AND ryoacti = 'Y' ",
                "                   AND ryi04 = '1'",
                "                   AND ryi07 IS NOT NULL ",       #FUN-D40064 Add 
                "                   AND ryo02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
                "                   AND ryi01 = OPNO AND Condition2 = '",g_azw05,"'||ryo02)"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #按POS用户+门店的方式下传，一个用户有多笔生效门店，下传多笔资料，Condition2记录门店+db
    LET g_sql = " INSERT INTO ",g_posdbs,"th_Staffs",g_db_links,"(",
                " Condition1,Condition2, ",
                " OPNO,OPNAME,PASSWORD,OPGROUP,CNFFLG )", 
                " SELECT '",g_trans_no,"','",g_azw05,"'||ryo02, ",
                "        ryi01,gen02,ryi03,ryi07,CASE WHEN ryoacti='Y' THEN ryiacti ELSE 'N' END ",
                "   FROM ",cl_get_target_table(g_azw01,'ryi_file')," LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'gen_file')," ON (ryi02 = gen01),",
                           cl_get_target_table(g_azw01,'ryo_file'),
                "  WHERE ryi01 = ryo01 AND ryoacti = 'Y' ",
                "    AND ryi04 = '1'",
                "    AND ryi07 IS NOT NULL ",       #FUN-D40064 Add
                "    AND ryo02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"th_Staffs",g_db_links,
                "                     WHERE Condition2 = '",g_azw05,"'||ryo02 AND OPNO = ryi01)"
    CALL p100_postable_ins(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #写请求表：按照Condition2的门店写请求表，抓对应下传门店的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
                " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION) "
    IF g_posway ='1' THEN
       LET g_sql = g_sql CLIPPED,
                " SELECT DISTINCT ryo02,' ','",g_trans_no,"','th_Staffs',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||ryo02||'''','D' "
    ELSE
       LET g_sql = g_sql CLIPPED,
                " SELECT DISTINCT ryo02,' ','",g_trans_no,"','th_Staffs',' Condition2='||''''||'",g_azw05,"'||ryo02||'''','D' "
    END IF
    LET g_sql = g_sql CLIPPED,
                "   FROM ",cl_get_target_table(g_azw01,'ryi_file'),",",
                           cl_get_target_table(g_azw01,'ryo_file'),
                "  WHERE ryi01 = ryo01 AND ryi04 = '1' ",
                "    AND ryi07 IS NOT NULL ",       #FUN-D40064 Add
                "    AND ryo02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED
    CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION p100_down_1031()   #收银员资料     #ryi_file->th_Clerk

  LET g_ryk03 = "th_Clerk"
   #按照门店+POS用户的方式存储，如果生效门店由Y->N，更新对应门店的这笔用户资料有效否为N，INSERT时只抓取ryoacti=Y的资料
    LET g_sql = " UPDATE ",g_posdbs,"th_Clerk",g_db_links
    IF g_posway ='1' THEN
       LET g_sql = g_sql CLIPPED,
                "    SET (Condition1,ClerkName,CNFFLG) = ",
                "        (SELECT '",g_trans_no,"',gen02,CASE WHEN ryoacti='Y' THEN ryiacti ELSE 'N' END "
    ELSE
       LET g_sql = g_sql CLIPPED,
                "    SET (ClerkName,CNFFLG) = ",
                "        (SELECT gen02,CASE WHEN ryoacti='Y' THEN ryiacti ELSE 'N' END "
    END IF
    LET g_sql = g_sql CLIPPED,
                "           FROM ",cl_get_target_table(g_azw01,'ryi_file')," LEFT OUTER JOIN ",
                                   cl_get_target_table(g_azw01,'gen_file')," ON (ryi02 = gen01),",
                                   cl_get_target_table(g_azw01,'ryo_file'),
               #"          WHERE ryi01 = ryo01 AND ClerkNO = ryi01 AND Condition2 = '",g_azw05,"'||ryo02)",   #FUN-D40064 Mark
                "          WHERE ryi01 = ryo01 AND ClerkNO = ryi01 AND Condition2 = '",g_azw05,"'||ryo02 ",   #FUN-D40064 Add
                "            AND ryi07 IS NOT NULL)",                                                         #FUN-D40064 Add
                "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryi_file'),",",
                                                 cl_get_target_table(g_azw01,'ryo_file'),
                "                 WHERE ryi01 = ryo01 ",  #AND ryoacti = 'Y' ",
                "                   AND ryi04 = '2'",
                "                   AND ryi07 IS NOT NULL ",          #FUN-D40064 Add
                "                   AND ryo02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
                "                   AND ryi01 = ClerkNO AND Condition2 = '",g_azw05,"'||ryo02)"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #按POS用户+门店的方式下传，一个用户有多笔生效门店，下传多笔资料，Condition2记录门店+db
    LET g_sql = " INSERT INTO ",g_posdbs,"th_Clerk",g_db_links,"(",
                " Condition1,Condition2, ",
                " ClerkNO,ClerkName,CounterNO,e_ClerkID,CNFFLG )",
                " SELECT '",g_trans_no,"','",g_azw05,"'||ryo02, ",
                "        ryi01,gen02,'','',CASE WHEN ryoacti='Y' THEN ryiacti ELSE 'N' END ",
                "   FROM ",cl_get_target_table(g_azw01,'ryi_file')," LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'gen_file')," ON (ryi02 = gen01),",
                           cl_get_target_table(g_azw01,'ryo_file'),
                "  WHERE ryi01 = ryo01 AND ryoacti = 'Y' ",
                "    AND ryi04 = '2'",
                "    AND ryi07 IS NOT NULL ",    #FUN-D40064 Add
                "    AND ryo02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"th_Clerk",g_db_links,
                "                     WHERE Condition2 = '",g_azw05,"'||ryo02 AND ClerkNO = ryi01)"
    CALL p100_postable_ins(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #写请求表：按照Condition2的门店写请求表，抓对应下传门店的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
                " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION) "
    IF g_posway ='1' THEN
       LET g_sql = g_sql CLIPPED,
                " SELECT DISTINCT ryo02,' ','",g_trans_no,"','th_Clerk',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||ryo02||'''','D' "
    ELSE
       LET g_sql = g_sql CLIPPED,
                " SELECT DISTINCT ryo02,' ','",g_trans_no,"','th_Clerk',' Condition2='||''''||'",g_azw05,"'||ryo02||'''','D' "
    END IF
    LET g_sql = g_sql CLIPPED,
                "   FROM ",cl_get_target_table(g_azw01,'ryi_file'),",",
                           cl_get_target_table(g_azw01,'ryo_file'),
                "  WHERE ryi01 = ryo01 AND ryi04 = '2' ",
                "    AND ryi07 IS NOT NULL ",      #FUN-D40064 Add
                "    AND ryo02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED
    CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')

END FUNCTION

FUNCTION p100_down_104()   #商户摊位资料         #lnt_file->tb_Counter
DEFINE l_str STRING 
    CALL p100_g_wc("lih_file",'3') RETURNING l_str  
    LET g_ryk03 = "tb_Counter"   
    LET g_sql = " UPDATE ",g_posdbs,"tb_Counter",g_db_links,
                "    SET (Condition1,COUNTERNAME,LBDATE,LEDATE,CNFFLG)= ",
                " (SELECT DISTINCT '",g_trans_no,"',  ' ',",cl_tp_tochar("lih14",'YYYYMMDD'),", ",
                "                  CASE lihconf WHEN 'S' THEN ",cl_tp_tochar("lih18",'YYYYMMDD')," ELSE ",cl_tp_tochar("lih15",'YYYYMMDD')," END, ",
                "                  CASE lihconf WHEN 'Y' THEN 'Y' ELSE 'N' END ",
                "   FROM ",cl_get_target_table(g_azw01,'lih_file'),
                "  WHERE Condition2 = '",g_azw05,"'||lihplant AND COUNTERNO = lih07 ",
                "    AND LBDATE = ",cl_tp_tochar("lih14",'YYYYMMDD'),
                "    AND LEDATE = ",cl_tp_tochar("lih15",'YYYYMMDD'),")",
                "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lih_file'),
                "                 WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lnt_file'),
                "                                    WHERE lnt06 = lih07 AND lntplant = lihplant ",
                "                                      AND lih14 = lnt17 AND lnt26 IN ('Y','S','E'))",
                "                   AND lihconf IN ('Y','S') AND ",l_str CLIPPED,
                "                   AND lihplant IN ",g_all_plant CLIPPED,
                "                   AND COUNTERNO = lih07 ",
                "                   AND LBDATE = ",cl_tp_tochar("lih14",'YYYYMMDD'),
                "                   AND LEDATE = ",cl_tp_tochar("lih15",'YYYYMMDD'),
                "                   AND Condition2 = '",g_azw05,"'||lihplant)"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

    LET g_sql = " UPDATE ",g_posdbs,"tb_Counter",g_db_links,
                "    SET (Condition1,COUNTERNAME,LBDATE,LEDATE,CNFFLG)= ",
                " (SELECT DISTINCT '",g_trans_no,"', lnt06,",cl_tp_tochar("lnt17",'YYYYMMDD'),", ",
                "                  CASE lnt26 WHEN 'S' THEN ",cl_tp_tochar("lji29",'YYYYMMDD')," ELSE ",cl_tp_tochar("lnt18",'YYYYMMDD')," END, ",
                "                  CASE lnt26 WHEN 'Y' THEN lntacti ELSE 'N' END ",
                "   FROM ",cl_get_target_table(g_azw01,'lnt_file')," LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'lji_file')," ON (lji04 = lnt01 AND ljiplant = lntplant AND lji02 = '5')",
                "  WHERE Condition2 = '",g_azw05,"'||lntplant AND COUNTERNO = lnt06 ",
                "    AND LBDATE = ",cl_tp_tochar("lnt17",'YYYYMMDD'),
                "    AND LEDATE = ",cl_tp_tochar("lnt18",'YYYYMMDD'),")",
                "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lnt_file'),
                "                 WHERE lnt26 IN ('Y','S','E') AND ",g_wc CLIPPED,
                "                   AND lntplant IN ",g_all_plant CLIPPED,
                "                   AND COUNTERNO = lnt06  ",
                "                   AND LBDATE = ",cl_tp_tochar("lnt17",'YYYYMMDD'),
                "                   AND LEDATE = ",cl_tp_tochar("lnt18",'YYYYMMDD'),
                "                   AND Condition2 = '",g_azw05,"'||lntplant)"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

    LET g_sql = " INSERT INTO ",g_posdbs,"tb_Counter",g_db_links," (",
                " Condition1,Condition2, ",
                " COUNTERNO,COUNTERNAME,LBDATE,LEDATE,CNFFLG )", 
                " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lihplant,",
                "                 lih07,' ',",cl_tp_tochar("lih14",'YYYYMMDD'),", ",
                "                 CASE lihconf WHEN 'S' THEN ",cl_tp_tochar("lih18",'YYYYMMDD')," ELSE ",cl_tp_tochar("lih15",'YYYYMMDD')," END, ",
                "                 CASE lihconf WHEN 'Y' THEN 'Y' ELSE 'N' END ",
                "   FROM ",cl_get_target_table(g_azw01,'lih_file'),
                "  WHERE NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lnt_file'),
                "                     WHERE lnt06 = lih07 AND lntplant = lihplant ",
                "                       AND lih14 = lnt17 AND lnt26 IN ('Y','S','E'))",
                "    AND lihconf IN ('Y','S') AND ",l_str CLIPPED,
                "    AND lihplant IN ",g_all_plant CLIPPED,
                "    AND NOT EXISTS( SELECT 1 FROM ",g_posdbs,"tb_Counter",g_db_links,
                "                     WHERE COUNTERNO = lih07 ",
                "                       AND LBDATE = ",cl_tp_tochar("lih14",'YYYYMMDD'),
                "                       AND ((LEDATE = ",cl_tp_tochar("lih15",'YYYYMMDD')," AND lihconf = 'Y') OR (LEDATE = ",cl_tp_tochar("lih18",'YYYYMMDD')," AND lihconf = 'S'))",
                "                       AND Condition2 = '",g_azw05,"'||lihplant)"
    CALL p100_postable_ins(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF
    LET g_sql = " INSERT INTO ",g_posdbs,"tb_Counter",g_db_links," (",
                " Condition1,Condition2, ",
                " COUNTERNO,COUNTERNAME,LBDATE,LEDATE,CNFFLG )", 
                " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lntplant, ",
                "                 lnt06,' ',",cl_tp_tochar("lnt17",'YYYYMMDD'),",",
                "                 CASE lnt26 WHEN 'S' THEN ",cl_tp_tochar("lji29",'YYYYMMDD')," ELSE ",cl_tp_tochar("lnt18",'YYYYMMDD')," END, ",
                "                 CASE lnt26 WHEN 'Y' THEN lntacti ELSE 'N' END ",
                "   FROM ",cl_get_target_table(g_azw01,'lnt_file')," LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'lji_file')," ON (lji04 = lnt01 AND ljiplant = lntplant AND lji02 = '5')",
                "  WHERE lnt26 IN ('Y','S','E')  AND ",g_wc CLIPPED,
                "    AND lntplant IN ",g_all_plant CLIPPED,
                "    AND NOT EXISTS( SELECT 1 FROM ",g_posdbs,"tb_Counter",g_db_links,
                "                     WHERE  COUNTERNO = lnt06 ",
                "                       AND LBDATE = ",cl_tp_tochar("lnt17",'YYYYMMDD'),
                "                       AND ((LEDATE = ",cl_tp_tochar("lnt18",'YYYYMMDD')," AND lnt26 <> 'S') OR (LEDATE = ",cl_tp_tochar("lji29",'YYYYMMDD')," AND lnt26 = 'S'))",
                "                       AND Condition2 = '",g_azw05,"'||lntplant)"
    CALL p100_postable_ins(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF  
    LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
                " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) ",
                " SELECT lntplant,' ','",g_trans_no,"','tb_Counter','Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||lntplant||'''','D' ",
                "   FROM  (",
                " SELECT lihplant lntplant",
                "   FROM  ",cl_get_target_table(g_azw01,'lih_file'),
                "  WHERE lihconf IN ('Y','S') AND ",l_str CLIPPED,
                "    AND lihplant IN ",g_all_plant CLIPPED,
                " UNION ",
                " SELECT lntplant ",
                "   FROM ",cl_get_target_table(g_azw01,'lnt_file'),
                "  WHERE lnt26 IN ('Y','S','E')  AND ",g_wc CLIPPED,
                "    AND lntplant IN ",g_all_plant CLIPPED,")"
    CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION 

FUNCTION p100_down_106()      #券种资料        #lpx_file->ta_Coupon
   LET g_ryk03 = "ta_Coupon" 
   #根据g_wc UPDATE中间库存在的资料,只更新券种生效范围在g_all_plant里面的券种
   LET g_sql = " UPDATE ",g_posdbs,"ta_Coupon",g_db_links,
               "    SET (Condition1,GIFTCTFName,PAYCH,MUSTCH,Spill,ISMCouponNO,ISBilling,CanReturn,AbsorbRate,LBDate,LEDate,CNFFLG,TaxCode,GIFTCTFType) = ",  #FUN-D10040 add GIFTCTFType
               "        (SELECT '",g_trans_no,"',lpx02,lpx05,lpx29,",
               "                  (CASE WHEN lpx05 = 'Y' THEN 'N' ELSE 'Y' END),",
               #"                  (CASE WHEN lpx26 = '3' THEN 'N' ELSE 'Y' END),",           #FUN-D10040 mark
               #"                  (CASE WHEN lpx26 = '1' THEN 'Y' ELSE 'N' END ),'Y','100',",#FUN-D10040 mark
               "                   'Y',lpx38,'Y','100',",                                     #FUN-D10040 add                                                    
                                  cl_tp_tochar("lpx03",'YYYYMMDD'),",",cl_tp_tochar("lpx04",'YYYYMMDD'),",lpxacti,lpx33",
               "                  ,(CASE lpx26 WHEN '1' THEN '0' WHEN '2' THEN '1' END)",      #FUN-D10040 add
               "           FROM ",cl_get_target_table(g_azw01,'lpx_file'),
               "           WHERE Condition2 = '",g_azw05,"'||lpx01 AND GIFTCTF = lpx01) ",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lpx_file'),",",
                                                cl_get_target_table(g_azw01,'lnk_file'),
               "                 WHERE lnk01 = lpx01 AND lnk02 = '2' AND lnk05 = 'Y'",
               "                   AND lpx15 = 'Y' ",
               "                   AND lnk03 IN ",g_all_plant CLIPPED ," AND ",g_wc CLIPPED,
               "                   AND GIFTCTF = lpx01 AND Condition2 = '",g_azw05,"'||lpx01)"
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

   #按db把所有满足条件的券种下传到中间库
   LET g_sql = " INSERT INTO ",g_posdbs,"ta_Coupon",g_db_links," (",
               " Condition1,Condition2, ",
               " GIFTCTF,GIFTCTFName,PAYCH,MUSTCH,Spill,ISMCouponNO, ",
               " ISBilling,CanReturn,AbsorbRate,LBDate,LEDate,CNFFLG,TaxCode,GIFTCTFType) ",  #FUN-D10040 add GIFTCTFType
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lpx01, ",
               "        lpx01,lpx02,lpx05,CAST(lpx29 AS NUMBER(12,2)),",
               "        (CASE WHEN lpx05 = 'Y' THEN 'N' ELSE 'Y' END),",
               #"        (CASE WHEN lpx26 = '3' THEN 'N' ELSE 'Y' END),",           #FUN-D10040 mark
               #"        (CASE WHEN lpx26 = '1' THEN 'Y' ELSE 'N' END ),'Y','100',",#FUN-D10040 mark
               "                   'Y',lpx38,'Y','100',",                                     #FUN-D10040 add
                        cl_tp_tochar("lpx03",'YYYYMMDD'),",",cl_tp_tochar("lpx04",'YYYYMMDD'),",lpxacti,lpx33",
               ",","              (CASE lpx26 WHEN '1' THEN '0' WHEN '2' THEN '1' END)",      #FUN-D10040 add
               "   FROM ",cl_get_target_table(g_azw01,'lpx_file'),",",
                          cl_get_target_table(g_azw01,'lnk_file'),
               "  WHERE lnk01 = lpx01 AND lnk02 = '2' AND lnk05 = 'Y'",
               "    AND lpx15 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED ," AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_Coupon",g_db_links,
               "                    WHERE GIFTCTF = lpx01 AND Condition2 = '",g_azw05,"'||lpx01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION) ",
               " SELECT DISTINCT lnk03,' ','",g_trans_no,"','ta_Coupon','Condition2='||''''||'",g_azw05,"'||lpx01||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'lpx_file'),",",
                          cl_get_target_table(g_azw01,'lnk_file'),
               "  WHERE lnk01 = lpx01 AND lnk02 = '2' AND lnk05 = 'Y'",
               "    AND lpx15 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED ," AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
   CALL p100_tk_TransTaskDetail_del(g_ryk01)            
   CALL p100_tk_TransTaskDetail_del('1061')            
   CALL p100_down_1061()
   CALL p100_down_1062() #FUN-CC0058
   CALL p100_down_1063() #FUN-CC0058
END FUNCTION

#FUNCTION p100_down_1061()   #券规则
#  LET g_ryk03 = "ta_Coupon_Rule"
#  LET g_sql = " UPDATE ",g_posdbs,"ta_Coupon_Rule",g_db_links,
#              "    SET (Condition1,ISFULFIL,ReachAMT,RecoverAMT )=",
#             #"        (SELECT '",g_trans_no,"',lpx08,lpx10,lpx35",
#              "        (SELECT '",g_trans_no,"',lpx08,CASE WHEN lpx10 IS NULL THEN 0 ELSE lpx10 END,CASE WHEN lpx35 IS NULL THEN 0 ELSE lpx35 END",
#              "           FROM ",cl_get_target_table(g_azw01,'lpx_file'),
#              "          WHERE Condition2 = '",g_azw05,"'||lpx01 AND GIFTCTF = lpx01)",
#              "  WHERE EXISTS ( SELECT 1 FROM ",cl_get_target_table(g_azw01,'lpx_file'),",",
#                                                cl_get_target_table(g_azw01,'lnk_file'),
#              "                  WHERE lnk01 = lpx01 AND lnk02 = '2' AND lnk05 = 'Y'",
#              "                    AND lpx15 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED ," AND ",g_wc CLIPPED,
#              "                    AND GIFTCTF = lpx01 AND Condition2 = '",g_azw05,"'||lpx01 )"
#   CALL p100_postable_upd(g_sql,'Y')
#   IF g_success = 'N' THEN RETURN END IF

#   LET g_sql = " INSERT INTO ",g_posdbs,"ta_Coupon_Rule",g_db_links," (",
#              " Condition1,Condition2, ",
#              " GIFTCTF,RuleWay,Exclude,ISFULFIL,ReachAMT,RecoverAMT,CNFFLG )",
#              " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lpx01, ",
#             #"        lpx01,'4','1',lpx08,lpx10,lpx35,'Y' ",
#              "        lpx01,'4','1',lpx08,CASE WHEN lpx10 IS NULL THEN 0 ELSE lpx10 END,CASE WHEN lpx35 IS NULL THEN 0 ELSE lpx35 END,'Y' ",
#              "   FROM ",cl_get_target_table(g_azw01,'lpx_file'),",",
#                         cl_get_target_table(g_azw01,'lnk_file'),
#              "  WHERE lnk01 = lpx01 AND lnk02 = '2' AND lnk05 = 'Y'",
#              "    AND lpx15 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED ," AND ",g_wc CLIPPED,
#              "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_Coupon_Rule",g_db_links,
#              "                     WHERE GIFTCTF = lpx01 AND Condition2 = '",g_azw05,"'||lpx01 )"
#  CALL p100_postable_ins(g_sql,'Y')
#  IF g_success = 'N' THEN RETURN END IF
#END FUNCTION

#FUN-CC0058 -----------STA
FUNCTION p100_down_1061()   #券规则
   LET g_ryk03 = "ta_Coupon_Rule"
   CALL p100_g_wc('ltp_file','4') RETURNING g_wc
   LET g_sql = " UPDATE ",g_posdbs,"ta_Coupon_Rule",g_db_links,
               "    SET (Condition1,RuleWay,Exclude,LBdate,LEdate,ISFULFIL,ReachAMT,RecoverAMT,CanPayCoupon,CanPayCard,CanVIPAgio )=",  #FUN-D10040 add ,CanPayCoupon,CanPayCard,CanVIPAgio
               #"        (SELECT '",g_trans_no,"',CASE ltp06 WHEN '0' THEN '4' ELSE ltp06 END,ltp07+1,",cl_tp_tochar("ltp04",'YYYYMMDD'),",",cl_tp_tochar("ltp05",'YYYYMMDD'),",ltp08,CASE WHEN ltp09 IS NULL THEN 0 ELSE ltp09 END,CASE WHEN ltp10 IS NULL THEN 0 ELSE ltp10 END ",   #FUN-D10040 mark
               "        (SELECT '",g_trans_no,"',CASE ltp06 WHEN '0' THEN '4' ELSE ltp06 END,ltp07+1,",cl_tp_tochar("ltp04",'YYYYMMDD'),",",   #FUN-D10040 add
               "               ",cl_tp_tochar("ltp05",'YYYYMMDD'),",ltp08,CASE WHEN ltp09 IS NULL THEN 0 ELSE ltp09 END,",                     #FUN-D10040 add
               "               CASE WHEN ltp10 IS NULL THEN 0 ELSE ltp10 END,'N','N','N' ",                                                    #FUN-D10040 add
               "           FROM ",cl_get_target_table(g_azw01,'ltp_file'),
               "          WHERE Condition2 = '",g_azw05,"'||ltpplant AND GIFTCTF = ltp03",
               "            AND ltpconf= 'Y' AND ltp11 = 'Y' ", #FUN-D20092 Add
               "            AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "            AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),")",
               "  WHERE EXISTS ( SELECT 1 FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                                                 cl_get_target_table(g_azw01,'lso_file'),
               "                  WHERE ltp01 = lso01 AND ltp02 = lso02 AND ltpplant = lsoplant AND ltpplant = lso04",
              #"                    AND lso03 = '3' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Mark
               "                    AND lso03 = '4' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Add
               "                    AND ltpconf= 'Y' AND ltp11 = 'Y' AND ",g_wc CLIPPED,
               "                    AND GIFTCTF = ltp03 AND Condition2 = '",g_azw05,"'||ltpplant",
               "                    AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "                    AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

    LET g_sql = " INSERT INTO ",g_posdbs,"ta_Coupon_Rule",g_db_links," (",
               " Condition1,Condition2, ",
               " GIFTCTF,RuleWay,Exclude,LBdate,LEdate,ISFULFIL,ReachAMT,RecoverAMT,CNFFLG,CanPayCoupon,CanPayCard,CanVIPAgio )", #FUN-D10040 add ,CanPayCoupon,CanPayCard,CanVIPAgio
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||ltpplant, ",
               "        ltp03,CASE ltp06 WHEN '0' THEN '4' ELSE ltp06 END,ltp07+1,",cl_tp_tochar("ltp04",'YYYYMMDD'),",",cl_tp_tochar("ltp05",'YYYYMMDD'),",ltp08,CASE WHEN ltp09 IS NULL THEN 0 ELSE ltp09 END,CASE WHEN ltp10 IS NULL THEN 0 ELSE ltp10 END,'Y','N','N','N' ",     #FUN-D10040 add 'N','N','N'
               "   FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                          cl_get_target_table(g_azw01,'lso_file'),
               "  WHERE ltp01 = lso01 AND ltp02 = lso02 AND ltpplant = lsoplant AND ltpplant = lso04",
              #"    AND lso03 = '3' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Mark
               "    AND lso03 = '4' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Add
               "    AND ltpconf= 'Y' AND ltp11 = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_Coupon_Rule",g_db_links,
               "                     WHERE GIFTCTF = ltp03 AND Condition2 = '",g_azw05,"'||ltpplant ",
               "                       AND ltpconf= 'Y' AND ltp11 = 'Y' ", #FUN-D20092 Add
               "                       AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "                       AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),")"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT ltpplant,' ','",g_trans_no,"','ta_Coupon_Rule','Condition2='||''''||'",g_azw05,"'||ltpplant||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT ltpplant,' ','",g_trans_no,"','ta_Coupon_Rule',' Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||ltpplant||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                          cl_get_target_table(g_azw01,'lso_file'),
               "  WHERE ltp01 = lso01 AND ltp02 = lso02 AND ltpplant = lsoplant AND ltpplant = lso04",
              #"    AND lso03 = '3' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Mark
               "    AND lso03 = '4' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Add
               "    AND ltpconf= 'Y' AND ltp11 = 'Y' AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
  # CALL p100_tk_TransTaskDetail_del(g_ryk01)
END FUNCTION

FUNCTION p100_down_1062()   #券规则单身一档
   LET g_ryk03 = "ta_Coupon_Rule_Detail"
   LET g_sql = " UPDATE ",g_posdbs,"ta_Coupon_Rule_Detail",g_db_links,
               "    SET (Condition1,CNFFLG)=",
               "        (SELECT '",g_trans_no,"',ltqacti",
               "           FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                                  cl_get_target_table(g_azw01,'ltq_file'),
               "          WHERE Condition2 = '",g_azw05,"'||ltpplant AND GIFTCTF = ltp03 ",
               "            AND Code = ltq03 ",
               "            AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "            AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),
               "            AND ltpconf= 'Y' AND ltp11 = 'Y' ", #FUN-D20092 Add
               "            AND ltp01 = ltq01 AND ltp02 = ltq02 AND ltpplant = ltqplant )",
               "  WHERE EXISTS ( SELECT 1 FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                                                 cl_get_target_table(g_azw01,'ltq_file'),",",
                                                 cl_get_target_table(g_azw01,'lso_file'),
               "                  WHERE ltp01 = ltq01 AND ltp02 = ltq02 AND ltpplant = ltqplant ",
               "                    AND ltp01 = lso01 AND ltp02 = lso02 AND ltpplant = lsoplant AND ltpplant = lso04",
              #"                    AND lso03 = '3' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Mark
               "                    AND lso03 = '4' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Add
               "                    AND ltpconf= 'Y' AND ltp11 = 'Y' AND ",g_wc CLIPPED,
               "                    AND GIFTCTF = ltp03 AND Condition2 = '",g_azw05,"'||ltpplant AND Code=ltq03 ",
               "                       AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "                       AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),")"
    CALL p100_postable_upd(g_sql,'N')
    IF g_success = 'N' THEN RETURN END IF
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_Coupon_Rule_Detail",g_db_links," (",
               " Condition1,Condition2, ",
               " GIFTCTF,LBDate,LEDate,Code,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||ltpplant, ",
               "        ltp03,",cl_tp_tochar("ltp04",'YYYYMMDD'),",",cl_tp_tochar("ltp05",'YYYYMMDD'),",ltq03,ltqacti",
               "   FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                          cl_get_target_table(g_azw01,'ltq_file'),",",
                          cl_get_target_table(g_azw01,'lso_file'),
               "  WHERE ltp01 = ltq01 AND ltp02 = ltq02 AND ltpplant = ltqplant ",
               "    AND ltp01 = lso01 AND ltp02 = lso02 AND ltpplant = lsoplant AND ltpplant = lso04",
              #"    AND lso03 = '3' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Mark
               "    AND lso03 = '4' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Add
               "    AND ltpconf= 'Y' AND ltp11 = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_Coupon_Rule_Detail",g_db_links,
               "                     WHERE GIFTCTF = ltp03 AND Condition2 = '",g_azw05,"'||ltpplant AND Code=ltq03 ",
               "                       AND ltpconf= 'Y' AND ltp11 = 'Y' ", #FUN-D20092 Add
               "                       AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "                       AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),")"
   CALL p100_postable_ins(g_sql,'N')
END FUNCTION

FUNCTION p100_down_1063()   #券规则单身二档
   LET g_ryk03 = "ta_Coupon_Rule_Ndetail"
   LET g_sql = " UPDATE ",g_posdbs,"ta_Coupon_Rule_Ndetail",g_db_links,
               "    SET (Condition1,CNFFLG)=",
               "        (SELECT '",g_trans_no,"',ltracti",
               "           FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                                  cl_get_target_table(g_azw01,'ltr_file'),
               "          WHERE Condition2 = '",g_azw05,"'||ltpplant AND GIFTCTF = ltp03 ",
               "            AND Code = ltr03 ",
               "            AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "            AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),
               "            AND ltpconf= 'Y' AND ltp11 = 'Y' ", #FUN-D20092 Add
               "            AND ltp01 = ltr01 AND ltp02 = ltr02 AND ltpplant = ltrplant) ",
               "  WHERE EXISTS ( SELECT 1 FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                                                 cl_get_target_table(g_azw01,'ltr_file'),",",
                                                 cl_get_target_table(g_azw01,'lso_file'),
               "                  WHERE ltp01 = ltr01 AND ltp02 = ltr02 AND ltpplant = ltrplant ",
               "                    AND ltp01 = lso01 AND ltp02 = lso02 AND ltpplant = lsoplant AND ltpplant = lso04",
              #"                    AND lso03 = '3' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Mark
               "                    AND lso03 = '4' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Add
               "                    AND ltpconf= 'Y' AND ltp11 = 'Y' AND ",g_wc CLIPPED,
               "                    AND GIFTCTF = ltp03 AND Condition2 = '",g_azw05,"'||ltpplant AND Code=ltr03 ",
               "                    AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "                    AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),")"
    CALL p100_postable_upd(g_sql,'N')
    IF g_success = 'N' THEN RETURN END IF  
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_Coupon_Rule_Ndetail",g_db_links," (",
               " Condition1,Condition2, ",
               " GIFTCTF,LBDate,LEDate,Code,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||ltpplant, ",
               "        ltp03,",cl_tp_tochar("ltp04",'YYYYMMDD'),",",cl_tp_tochar("ltp05",'YYYYMMDD'),",ltr03,ltracti",
               "   FROM ",cl_get_target_table(g_azw01,'ltp_file'),",",
                          cl_get_target_table(g_azw01,'ltr_file'),",",
                          cl_get_target_table(g_azw01,'lso_file'),
               "  WHERE ltp01 = ltr01 AND ltp02 = ltr02 AND ltpplant = ltrplant ",
               "    AND ltp01 = lso01 AND ltp02 = lso02 AND ltpplant = lsoplant AND ltpplant = lso04",
              #"    AND lso03 = '3' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Mark
               "    AND lso03 = '4' AND lso04 IN ",g_all_plant CLIPPED , #FUN-D20092 Add
               "    AND ltpconf= 'Y' AND ltp11 = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_Coupon_Rule_Ndetail",g_db_links,
               "                     WHERE GIFTCTF = ltp03 AND Condition2 = '",g_azw05,"'||ltpplant AND Code=ltr03 ",
               "                       AND ltpconf= 'Y' AND ltp11 = 'Y' ", #FUN-D20092 Add
               "                       AND LBDate = ",cl_tp_tochar("ltp04",'YYYYMMDD'),
               "                       AND LEDate = ",cl_tp_tochar("ltp05",'YYYYMMDD'),")"
   CALL p100_postable_ins(g_sql,'N')
END FUNCTION
#FUN-CC0058 -----------END 

FUNCTION p100_down_108()     #发票资料     oom_file->ta_InvoiceBook
   LET g_ryk03 = "ta_InvoiceBook"
   LET g_sql = " UPDATE ",g_posdbs,"ta_InvoiceBook",g_db_links,
               " SET (Condition1) = ",
               "     (SELECT DISTINCT '",g_trans_no,"'",   
               "        FROM ",cl_get_target_table(g_azw01,'oom_file'),
               "       WHERE Condition2 = '",g_azw05,"'||oom14 AND Year = oom01 AND  StartMonth = oom02 ",
               "         AND oom07 IS NOT NULL AND oom08 IS NOT NULL ",             #FUN-D40064 Add
               "         AND EndMonth = oom021 AND InvType = oom04 AND InvStartNo = oom07 AND InvEndNo = oom08)",
               " WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'oom_file'),
               "                 WHERE Condition2 = '",g_azw05,"'||oom14 AND Year = oom01 AND  StartMonth = oom02 ",
               "                   AND InvType = oom04 AND InvStartNo = oom07 AND InvEndNo = oom08 AND oom14 IN ",g_all_plant CLIPPED,
               "                   AND oom07 IS NOT NULL AND oom08 IS NOT NULL ",   #FUN-D40064 Add
               "                   AND oom17 = 'N' AND oom15 = ' ' AND ",g_wc CLIPPED,") "
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   LET g_sql = " INSERT INTO ",g_posdbs,"ta_InvoiceBook",g_db_links," (",
               " Condition1,Condition2, ",
               " Year,StartMonth,EndMonth,InvType,InvStartNo,InvEndNo,CnfFlg )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||oom14, ",
               "        oom01,oom02,oom021,oom04,oom07,oom08,'Y'",
               "   FROM ",cl_get_target_table(g_azw01,'oom_file'),
               "  WHERE oom14 IN ",g_all_plant CLIPPED,
               "    AND oom07 IS NOT NULL AND oom08 IS NOT NULL ",   #FUN-D40064 Add
               "    AND oom17 = 'N' AND oom15 = ' ' AND ",g_wc CLIPPED,
               "    AND  NOT EXISTS(SELECT 1 FROM ",g_posdbs,"ta_InvoiceBook",g_db_links,
               "                     WHERE Condition2 = '",g_azw05,"'||oom14 AND Year = oom01 AND  StartMonth = oom02 ",
               "                       AND InvType = oom04 AND InvStartNo = oom07 AND InvEndNo = oom08 AND oom14 IN ",g_all_plant CLIPPED,
               "                       AND oom07 IS NOT NULL AND oom08 IS NOT NULL ",   #FUN-D40064 Add 
               "                       AND oom17 = 'N' AND oom15 = ' ' AND ",g_wc CLIPPED,") "
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT oom14,' ','",g_trans_no,"','ta_InvoiceBook',' Condition2='||''''||'",g_azw05,"'||oom14||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT oom14,' ','",g_trans_no,"','ta_InvoiceBook',' Condition1='||''''||'",g_trans_no,"'||''''||' AND  Condition2='||''''||'",g_azw05,"'||oom14||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'oom_file'),
               "  WHERE oom17 = 'N' AND oom15 = ' ' AND oom14 IN ",g_all_plant CLIPPED,
               "    AND oom07 IS NOT NULL AND oom08 IS NOT NULL ",   #FUN-D40064 Add 
               "    AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION p100_down_109()     #税别资料     gec_file->tb_TaxCategory
   LET g_ryk03 = "tb_TaxCategory"
   LET g_sql = " UPDATE ",g_posdbs,"tb_TaxCategory",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,TaxName,TaxType,TaxRate,InclTax,CnfFlg) = ",
               "        (SELECT '",g_trans_no,"',gec02,gec06,gec04,gec07,gecacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (TaxName,TaxType,TaxRate,InclTax,CnfFlg) = ",
               "        (SELECT gec02,gec06,gec04,gec07,gecacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'gec_file'),
               "          WHERE TaxCode = gec01 AND gec011 = '2' )",
               "  WHERE Condition2||TaxCode IN (SELECT '",g_azw05,"'||gec01 FROM ",cl_get_target_table(g_azw01,'gec_file'),
               "                                 WHERE TaxCode = gec01 AND gec011 = '2' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"tb_TaxCategory",g_db_links," (",
               " Condition1,Condition2, ",
               " TaxCode,TaxName,TaxType,TaxRate,InclTax,CnfFlg )",
               " SELECT '",g_trans_no,"','",g_azw05,"', ",
               "        gec01,gec02,gec06,gec04,gec07,gecacti ",
               "   FROM ",cl_get_target_table(g_azw01,'gec_file'),
               "  WHERE gec011 = '2' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tb_TaxCategory",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"' AND TaxCode = gec01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
  
   #写请求表：每一个没一个门店写一笔请求表，WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tb_TaxCategory',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tb_TaxCategory',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

#FUN-CA0074---------add-----str
FUNCTION p100_down_110() #POS参数编号资料
   LET g_ryk03 = "ta_BaseSetTemp"
   CALL p100_g_wc('rzc_file','4') RETURNING g_wc
   LET g_sql = " UPDATE ",g_posdbs,"ta_BaseSetTemp",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Item,Def,Type,Length,Chsmsg,Chtmsg,Engmsg,Stype,Cnfflg) = ", 
               "        (SELECT '",g_trans_no,"',rzc01,rzc05,rzc02,rzc03, ",
               "                (SELECT ryx05 FROM ryx_file a WHERE ryx04 = '2' AND a.ryx01 = 'rzc_file' AND a.ryx02 = 'rzc01' AND a.ryx03 = rzc01), ",
               "                (SELECT ryx05 FROM ryx_file b WHERE ryx04 = '0' AND b.ryx01 = 'rzc_file' AND b.ryx02 = 'rzc01' AND b.ryx03 = rzc01), ",
               "                (SELECT ryx05 FROM ryx_file c WHERE ryx04 = '1' AND c.ryx01 = 'rzc_file' AND c.ryx02 = 'rzc01' AND c.ryx03 = rzc01), ",
               "                rzc04,rzcacti "
   ELSE         
      LET g_sql = g_sql CLIPPED,
               "    SET (Item,Def,Type,Length,Chsmsg,Chtmsg,Engmsg,Stype,Cnfflg) = ", 
               "        (SELECT rzc01,rzc05,rzc02,rzc03, ",
               "                (SELECT ryx05 FROM ryx_file a WHERE ryx04 = '2' AND a.ryx01 = 'rzc_file' AND a.ryx02 = 'rzc01' AND a.ryx03 = rzc01), ",
               "                (SELECT ryx05 FROM ryx_file b WHERE ryx04 = '0' AND b.ryx01 = 'rzc_file' AND b.ryx02 = 'rzc01' AND b.ryx03 = rzc01), ",
               "                (SELECT ryx05 FROM ryx_file c WHERE ryx04 = '1' AND c.ryx01 = 'rzc_file' AND c.ryx02 = 'rzc01' AND c.ryx03 = rzc01), ",
               "                rzc04,rzcacti "
   END IF 
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rzc_file'),
               "          WHERE Item = rzc01) ",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rzc_file'),
               "                 WHERE Item = rzc01 AND Condition2 = '",g_azw05,"' ",
               "                   AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   
  #INSERT中间库不存在的资料,条件同UPDATE,排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"ta_BaseSetTemp",g_db_links," (",
               "    Condition1,Condition2,Item,Def,Type,Length,Chsmsg,Chtmsg,Engmsg,Stype,Cnfflg )",
               " SELECT '",g_trans_no,"','",g_azw05,"', ",
               "        rzc01,rzc05,rzc02,rzc03, ",
               "        (SELECT ryx05 FROM ryx_file a WHERE ryx04 = '2' AND a.ryx01 = 'rzc_file' AND a.ryx02 = 'rzc01' AND a.ryx03 = rzc01), ",
               "        (SELECT ryx05 FROM ryx_file a WHERE ryx04 = '0' AND a.ryx01 = 'rzc_file' AND a.ryx02 = 'rzc01' AND a.ryx03 = rzc01), ",
               "        (SELECT ryx05 FROM ryx_file a WHERE ryx04 = '1' AND a.ryx01 = 'rzc_file' AND a.ryx02 = 'rzc01' AND a.ryx03 = rzc01), ",
               "        rzc04,rzcacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rzc_file'),
               "  WHERE ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_BaseSetTemp",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"' AND Item = rzc01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   
  #写请求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_BaseSetTemp',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_BaseSetTemp',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION p100_down_1101() #POS参数值资料
   LET g_ryk03 = "ta_BaseSetTemp_Para"
   LET g_sql = " UPDATE ",g_posdbs,"ta_BaseSetTemp_Para",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Item,Itemvalue,Chsmsg,Chtmsg,Engmsg,Cnfflg) = ", 
               "        (SELECT '",g_trans_no,"',rzd01,rzd02, ",
               "                (SELECT ryx05 FROM ryx_file a WHERE ryx04 = '2' AND a.ryx01 = 'rzd_file' AND a.ryx02 = 'rzd02' AND a.ryx03 = rzd01||'|'||rzd02), ",
               "                (SELECT ryx05 FROM ryx_file b WHERE ryx04 = '0' AND b.ryx01 = 'rzd_file' AND b.ryx02 = 'rzd02' AND b.ryx03 = rzd01||'|'||rzd02), ",
               "                (SELECT ryx05 FROM ryx_file c WHERE ryx04 = '1' AND c.ryx01 = 'rzd_file' AND c.ryx02 = 'rzd02' AND c.ryx03 = rzd01||'|'||rzd02), ",
               "                rzdacti "
   ELSE         
      LET g_sql = g_sql CLIPPED,
               "    SET (Item,Itemvalue,Chsmsg,Chtmsg,Engmsg,Cnfflg) = ", 
               "        (SELECT rzd01,rzd02, ",
               "                (SELECT ryx05 FROM ryx_file a WHERE ryx04 = '2' AND a.ryx01 = 'rzd_file' AND a.ryx02 = 'rzd02' AND a.ryx03 = rzd01||'|'||rzd02), ",
               "                (SELECT ryx05 FROM ryx_file b WHERE ryx04 = '0' AND b.ryx01 = 'rzd_file' AND b.ryx02 = 'rzd02' AND b.ryx03 = rzd01||'|'||rzd02), ",
               "                (SELECT ryx05 FROM ryx_file c WHERE ryx04 = '1' AND c.ryx01 = 'rzd_file' AND c.ryx02 = 'rzd02' AND c.ryx03 = rzd01||'|'||rzd02), ",
               "                rzdacti "
   END IF 
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rzd_file'),
               "          WHERE Item = rzd01 AND Itemvalue = rzd02) ",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rzd_file'),
               "                 WHERE Item = rzd01 AND Itemvalue = rzd02 AND Condition2 = '",g_azw05,"') "
              #"                   AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   
  #INSERT中间库不存在的资料,条件同UPDATE,排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"ta_BaseSetTemp_Para",g_db_links," (",
               "    Condition1,Condition2,Item,Itemvalue,Chsmsg,Chtmsg,Engmsg,Cnfflg )",
               " SELECT '",g_trans_no,"','",g_azw05,"', ",
               "        rzd01,rzd02, ",
               "        (SELECT ryx05 FROM ryx_file a WHERE ryx04 = '2' AND a.ryx01 = 'rzd_file' AND a.ryx02 = 'rzd02' AND a.ryx03 = rzd01||'|'||rzd02), ",
               "        (SELECT ryx05 FROM ryx_file b WHERE ryx04 = '0' AND b.ryx01 = 'rzd_file' AND b.ryx02 = 'rzd02' AND b.ryx03 = rzd01||'|'||rzd02), ",
               "        (SELECT ryx05 FROM ryx_file c WHERE ryx04 = '1' AND c.ryx01 = 'rzd_file' AND c.ryx02 = 'rzd02' AND c.ryx03 = rzd01||'|'||rzd02), ",
               "        rzdacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rzd_file'),
              #"  WHERE ",g_wc CLIPPED,
               "  WHERE NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_BaseSetTemp_Para",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"' AND Item = rzd01 AND Itemvalue = rzd02 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p100_down_1102() #POS门店参数设置资料
   LET g_ryk03 = "ta_BaseSet"
   CALL p100_g_wc('rze_file','4') RETURNING g_wc
   LET g_sql = " UPDATE ",g_posdbs,"ta_BaseSet",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Shop,Machine,Item,Itemvalue,Cnfflg) = ", 
               "        (SELECT '",g_trans_no,"',rze01,rze02,rze03,rze04,rzeacti "
   ELSE         
      LET g_sql = g_sql CLIPPED,
               "    SET (Shop,Machine,Item,Itemvalue,Cnfflg) = ", 
               "        (SELECT rze01,rze02,rze03,rze04,rzeacti "
   END IF 
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rze_file'),
               "          WHERE Shop = rze01 AND Machine = rze02 AND Item = rze03) ",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rze_file'),
               "                 WHERE Shop = rze01 AND Machine = rze02 AND Item = rze03 AND Condition2 = '",g_azw05,"'||rze01 ",
               "                   AND rze01 IN ",g_all_plant CLIPPED,
               "                   AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   
  #INSERT中间库不存在的资料,条件同UPDATE,排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"ta_BaseSet",g_db_links," (",
               "    Condition1,Condition2,Shop,Machine,Item,Itemvalue,Cnfflg )",
               " SELECT '",g_trans_no,"','",g_azw05,"'||rze01, ",
               "        rze01,rze02,rze03,rze04,rzeacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rze_file'),
               "  WHERE ",g_wc CLIPPED,
               "    AND rze01 IN ",g_all_plant CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_BaseSet",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rze01 AND Shop = rze01 AND Machine = rze02 AND Item=rze03) "
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   
  #写请求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rze01,' ','",g_trans_no,"','ta_BaseSet',' Condition2 = '||''''||'",g_azw05,"'||rze01||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rze01,' ','",g_trans_no,"','ta_BaseSet',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||rze01||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rze_file'),
               "  WHERE rze01 IN ",g_all_plant CLIPPED,
               "    AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION
#FUN-CA0074---------add-----end

FUNCTION p100_down_203()      #商户摊位产品资料  #lmv_file->tb_CounterGoods  
   LET g_ryk03 = "tb_CounterGoods"
   LET g_sql = " UPDATE ",g_posdbs,"tb_CounterGoods",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               " SET (Condition1,CNFFLG) = ",
               "     (SELECT DISTINCT '",g_trans_no,"',lmvacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SET (CNFFLG) = ",
               "     (SELECT DISTINCT lmvacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "        FROM ",cl_get_target_table(g_azw01,'lmv_file'),",",
                               cl_get_target_table(g_azw01,'lmf_file'),
               "       WHERE Condition2 = '",g_azw05,"'||lmfstore AND COUNTERNO = lmv03 AND PLUNO = lmv02 ",
               "         AND lmf01 = lmv03 AND lmfstore IN ",g_all_plant CLIPPED," )",
               " WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lmv_file'),",",
                                               cl_get_target_table(g_azw01,'lmf_file'),    
               "                 WHERE Condition2 = '",g_azw05,"'||lmfstore AND COUNTERNO = lmv03 AND PLUNO = lmv02 ",
               "                   AND lmf01 = lmv03 AND lmfstore IN ",g_all_plant CLIPPED,
               "                   AND lmf06 = 'Y' AND ",g_wc CLIPPED,") "
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   LET g_sql = " INSERT INTO ",g_posdbs,"tb_CounterGoods",g_db_links," (",
               " Condition1,Condition2, ",
               " COUNTERNO,PLUNO,CNFFLG )", 
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lmfstore, ",
               "        lmv03,lmv02,lmvacti ",
               "   FROM ",cl_get_target_table(g_azw01,'lmv_file'),",",
                          cl_get_target_table(g_azw01,'lmf_file'),    
               "  WHERE lmf01 = lmv03 AND lmfstore IN ",g_all_plant CLIPPED,
               "    AND lmf06 = 'Y' AND ",g_wc CLIPPED,
               "    AND  NOT EXISTS(SELECT 1 FROM ",g_posdbs,"tb_CounterGoods",g_db_links,    
               "                     WHERE COUNTERNO = lmv03 AND PLUNO = lmv02 ",
               "                       AND Condition2 = '",g_azw05,"'||lmfstore)"
   CALL p100_postable_ins(g_sql,'Y')  
   IF g_success = 'N' THEN RETURN END IF
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lmfstore,' ','",g_trans_no,"','tb_CounterGoods',' Condition2='||''''||'",g_azw05,"'||lmfstore||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lmfstore,' ','",g_trans_no,"','tb_CounterGoods',' Condition1='||''''||'",g_trans_no,"'||''''||' AND  Condition2='||''''||'",g_azw05,"'||lmfstore||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'lmv_file'),",",
                          cl_get_target_table(g_azw01,'lmf_file'),    
               "  WHERE lmf01 = lmv03 AND lmfstore IN ",g_all_plant CLIPPED,
               "    AND lmf06 = 'Y' AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION  p100_down_401()
   LET g_ryk03 = "tf_Member"
#MERGE 写法
   LET g_sql = " MERGE INTO ",g_posdbs,g_ryk03,g_db_links ,
               " USING (SELECT DISTINCT lpk01,lpk04,lpk05,lpk10,lpk13,lpk15,lpk16,lpk17,lpk18,lpk19,lpkacti,lpj02 ",
               "        FROM ",cl_get_target_table(g_azw01,'lpk_file'),",",
                               cl_get_target_table(g_azw01,'lpj_file'),",",
                               cl_get_target_table(g_azw01,'lnk_file'),  
               "        WHERE lpk01 = lpj01 AND lpj02 = lnk01 AND lnk02 = '1'",
               "          AND lnk05 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,")",
               " ON (Condition2 ='",g_azw05,"'||lpj02 AND MemberNO = lpk01 )",
               " WHEN MATCHED THEN ",
               "        UPDATE SET  MerberName = lpk04 ,BirthDay = ",cl_tp_tochar("lpk05",'YYYYMMDD'),",",
               "                    MenberGrade= lpk10 , MenberType = lpk13 , Address = lpk15 ,Postalcode = lpk16 ,",
               "                    Telephone = lpk17 , Mobile = lpk18 ,Email = lpk19 ,CNFFLG = lpkacti "
   IF  g_posway ='1' THEN LET g_sql = g_sql CLIPPED," ,Condition1 = '",g_trans_no,"'" END IF 
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "      INSERT(Condition1,Condition2,MemberNO,MerberName,BirthDay,MenberGrade,MenberType,Address,Postalcode,Telephone,Mobile,Email,CNFFLG)",
               "      VALUES('",g_trans_no,"','",g_azw05,"'||lpj02,lpk01,lpk04,",cl_tp_tochar("lpk05",'YYYYMMDD'),",lpk10,lpk13,lpk15,lpk16,lpk17,lpk18,lpk19,lpkacti)"   
   CALL p100_postable_ins(g_sql,'Y')
#liupeng end        
   IF g_success = 'N' THEN RETURN END IF

   #写请求表,按照卡种生效门店写请求表，按卡种写where条件
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lnk03,' ','",g_trans_no,"','tf_Member',' Condition2 = '||''''||'",g_azw05,"'||lpj02||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lnk03,' ','",g_trans_no,"','tf_Member',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||lpj02||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'lpk_file'),",",
                          cl_get_target_table(g_azw01,'lpj_file'),",",
                          cl_get_target_table(g_azw01,'lnk_file'),
               "  WHERE lpk01 = lpj01 AND lpj02 = lnk01 AND lnk02 = '1' AND lnk05 = 'Y' ",
               "    AND lnk05 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
  #CALL p100_tk_TransTaskDetail_del(g_ryk01)
   IF g_success = 'N' THEN RETURN END IF
   
   CALL p100_down_401_1()
END FUNCTION

FUNCTION p100_down_401_1()
   LET g_ryk03 = "tf_Member_Day"
#MERGE 写法
   LET g_sql = " MERGE INTO ",g_posdbs,g_ryk03,g_db_links ,
               " USING (SELECT DISTINCT lpa01,lpa02,lpc02,lpa03,lpaacti,lpj02 ",
               "        FROM ",cl_get_target_table(g_azw01,'lpk_file'),",",
                               cl_get_target_table(g_azw01,'lpj_file'),",",
                               cl_get_target_table(g_azw01,'lnk_file'),",",
                               cl_get_target_table(g_azw01,'lpa_file')," LEFT OUTER JOIN ",
                               cl_get_target_table(g_azw01,'lpc_file')," ON (lpa02 = lpc01 AND lpc00 = '8')",
               "        WHERE lpk01 = lpj01 AND lpj02 = lnk01 AND lnk02 = '1'",
               "          AND lnk05 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
               "          AND lpa03 IS NOT NULL",        #FUN-D40064 Add  
               "          AND lpa01 = lpk01   )",
               " ON (Condition2 ='",g_azw05,"'||lpj02 AND MemberNO = lpa01 AND MemorialNO = lpa02 )",
               " WHEN MATCHED THEN ",
               "        UPDATE SET  Explain = lpc02 ,MDate = COALESCE(",cl_tp_tochar("lpa03",'YYYYMMDD'),",'20991231'),CNFFLG = lpaacti "
   IF  g_posway ='1' THEN LET g_sql = g_sql CLIPPED," ,Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "      INSERT(Condition1,Condition2,MemberNO,MemorialNO,Explain,MDate,CNFFLG)",
               "      VALUES('",g_trans_no,"','",g_azw05,"'||lpj02,lpa01,lpa02,lpc02,COALESCE(",cl_tp_tochar("lpa03",'YYYYMMDD'),",'20991231'),lpaacti)"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

#FUN-CC0116-----add-----str
FUNCTION  p100_down_111()
   LET g_ryk03 = "tb_MallCode"
   LET g_sql = " MERGE INTO ",g_posdbs,g_ryk03,g_db_links ,
               " USING (SELECT DISTINCT rca01,rcb05,rca02,rca03,rcbacti ",
               "        FROM ",cl_get_target_table(g_azw01,'rca_file'),",",
                               cl_get_target_table(g_azw01,'rcb_file'),
               "        WHERE rca01= rcb01 AND rca02 = rcb02 AND rca03 =rcb03",
               "          AND rcb05 IS NOT NULL ",       #FUN-D40064 Add
               "          AND rca01 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,")",
               " ON (Condition2 ='",g_azw05,"'||rca01 AND MallCode = rcb05 AND LBDate = COALESCE(",cl_tp_tochar("rca02",'YYYYMMDD'),",'20991231') AND LEDate = COALESCE(",cl_tp_tochar("rca03",'YYYYMMDD'),",'20991231'))",
               " WHEN MATCHED THEN ",
               "        UPDATE SET  CNFFLG = rcbacti " 
   IF  g_posway ='1' THEN LET g_sql = g_sql CLIPPED," ,Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "      INSERT(Condition1,Condition2,MallCode,LBDate,LEDate,CNFFLG)",
               "      VALUES('",g_trans_no,"','",g_azw05,"'||rca01,rcb05,",cl_tp_tochar("rca02",'YYYYMMDD'),",",cl_tp_tochar("rca03",'YYYYMMDD'),",rcbacti)"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

   #写请求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rca01,' ','",g_trans_no,"','tb_MallCode',' Condition2 = '||''''||'",g_azw05,"'||rca01||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rca01,' ','",g_trans_no,"','tb_MallCode',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||rca01||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rca_file'),",",
                          cl_get_target_table(g_azw01,'rcb_file'),
               "        WHERE rca01= rcb01 AND rca02 = rcb02 AND rca03 =rcb03",
               "          AND rcb05 IS NOT NULL ",       #FUN-D40064 Add
               "          AND rca01 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
#FUN-CC0116-----add-----end

FUNCTION  p100_down_402()   #卡种下传 lph_file -> tf_CardType
   LET g_ryk03 = "tf_CardType"
 
  #根据g_wc UPDATE中间库存在的资料,只更新卡种生效范围在g_all_plant里面的卡种
   LET g_sql = " UPDATE ",g_posdbs,"tf_CardType",g_db_links,
               "    SET (Condition1,CTName,PreWay,CanPoint,DISC,",
               "         VIPPrice,Bintegral,Uintegral,ISMPassWord,IsPayScore,",
              #"         AbsorbWay,AbsorbRate,ReturnSC,ReturnRate,CNFFLG) = ",      #FUN-D20096 mark
               "         AbsorbWay,AbsorbRate,ReturnSC,ReturnRate,CNFFLG,SaleCardTaxCode,RechargeTaxCode) = ",    #FUN-D20096 add
               "        (SELECT '",g_trans_no,"',lph02,CASE WHEN lph04='Y' THEN '1' WHEN lph36='Y' THEN '2' ELSE '3' END,lph06,CAST(lph30 AS number(5)),",
               "         0,lph28,lph29,'N',lph37,",
               "         3,100,'Y',100,lphacti,lph47,lph48 ",               #FUN-D20096 add lph47,lph48
               "           FROM ",cl_get_target_table(g_azw01,'lph_file'),
               "          WHERE CTNO = lph01 )",
               "  WHERE EXISTS (SELECT 1 ",
               "                  FROM ",cl_get_target_table(g_azw01,'lph_file'),",",
                                         cl_get_target_table(g_azw01,'lnk_file'),
               "                 WHERE CTNO = lph01 AND Condition2 = '",g_azw05,"'||lph01 ",
               "                   AND lnk01 = lph01 AND lnk02 = '1' AND lnk05 = 'Y' ",
               "                   AND lnk03 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

   #按db把所有满足条件的卡种下传到中间库
   LET g_sql = " INSERT INTO ",g_posdbs,"tf_CardType",g_db_links," (",
               " Condition1,Condition2, ",
               " CTNO,CTName,PreWay,CanPoint,DISC,",
               " VIPPrice,Bintegral,Uintegral,ISMPassWord,IsPayScore,",
               " AbsorbWay,AbsorbRate,ReturnSC,ReturnRate,CNFFLG,SaleCardTaxCode,RechargeTaxCode)",  #FUN-D20096 add SaleCardTaxCode,RechargeTaxCode
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lph01, ",
               "        lph01,lph02,CASE WHEN lph04='Y' THEN '1' WHEN lph36='Y' THEN '2' ELSE '3' END,lph06,CAST(lph30 AS number(5)),",
               "        0,lph28,lph29,'N',lph37,",
               "        3,100,'Y',100,lphacti,lph47,lph48",             #FUN-D20096 add lph47,lph48
               "   FROM ",cl_get_target_table(g_azw01,'lph_file'),",",
                          cl_get_target_table(g_azw01,'lnk_file'),
               "  WHERE lnk01 = lph01 AND lnk02 = '1' AND lnk05 = 'Y' ",
               "    AND lph24 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tf_CardType",g_db_links,
               "                    WHERE CTNO = lph01 AND Condition2 = '",g_azw05,"'||lph01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

   #写请求表：根据卡种生效范围，每个卡种有几笔生效门店，写几笔请求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links,"(",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION)",
               " SELECT DISTINCT lnk03,' ','",g_trans_no,"','tf_CardType','Condition2='||''''||'",g_azw05,"'||lph01||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'lnk_file'),",",
                          cl_get_target_table(g_azw01,'lph_file'),
               "  WHERE lnk01 = lph01 AND lnk02 = '1' AND lnk05 = 'Y' ",
               "    AND lph24 = 'Y' AND ",g_wc CLIPPED,"  AND lnk03 IN ",g_all_plant CLIPPED             
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
   CALL p100_tk_TransTaskDetail_del(g_ryk01)
   CALL p100_tk_TransTaskDetail_del(401)
   CALL p100_tk_TransTaskDetail_del(403)
   CALL p100_tk_TransTaskDetail_del(404)
END FUNCTION

FUNCTION  p100_down_403()    #卡明细下传 lpj_file -> tf_CardType_Status
   LET g_ryk03 = "tf_CardType_Status"
  #初始化下传不更新Condition1
   IF cl_db_get_database_type() = 'ORA' THEN
   LET g_sql = " MERGE INTO ",g_posdbs,"tf_CardType_Status",g_db_links,
               " USING (SELECT DISTINCT lpj01,lpj02,lpj03,lpj05,lpj09 ",
               "          FROM ",cl_get_target_table(g_azw01,'lpj_file'),",",
                                 cl_get_target_table(g_azw01,'lnk_file'),
               "         WHERE lpj02 = lnk01 AND lnk02 = '1' AND lnk05 = 'Y' AND (lpj01 IS NOT NULL AND lpj01 <> ' ') ",
               "           AND lnk03 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,") ",
               "            ON (CardNO = lpj03 AND Condition2 = '",g_azw05,"'||lpj02 )",
               " WHEN MATCHED THEN ",
               "        UPDATE SET MemberNO = lpj01,CardStatus = lpj09,Validity = CASE WHEN lpj05 IS NULL THEN '20991231' ELSE ",cl_tp_tochar("lpj05",'YYYYMMDD')," END "
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"' "
   END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "        INSERT (Condition1,Condition2,",
               "                MemberNO,CTNO,CardNO,CardStatus,Validity,CNFFLG)",
               "        VALUES ('",g_trans_no,"','",g_azw05,"'||lpj02,",
               "                lpj01,lpj02,lpj03,lpj09,CASE WHEN lpj05 IS NULL THEN '20991231' ELSE ",cl_tp_tochar("lpj05",'YYYYMMDD')," END,'Y')"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   END IF
   
  #写请求表，根据卡种的生效营运中心写请求表，一个卡种对应几个门店，写几个请求表，where条件为Condtion2=db+卡种
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION) "
   IF g_posway ='2' THEN 
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lnk03,' ','",g_trans_no,"','tf_CardType_Status','Condition2='||''''||'",g_azw05,"'||lpj02||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lnk03,' ','",g_trans_no,"','tf_CardType_Status','Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||lpj02||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'lnk_file'),",",
                          cl_get_target_table(g_azw01,'lpj_file'),
               "  WHERE lnk01 = lpj02 AND lnk02 = '1' AND lnk05 = 'Y' AND (lpj01 IS NOT NULL AND lpj01 <> ' ') ",
               "    AND ",g_wc CLIPPED,"  AND lnk03 IN ",g_all_plant CLIPPED             
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
  #CALL p100_tk_TransTaskDetail_del(g_ryk01)
END FUNCTION

#产品策略跟产品特征码一起下传
FUNCTION p100_down_201()      #产品策略  #rte_file->tb_Goods #rte_file->tb_Feature
   LET g_ryk03 = "tb_Goods"
   LET g_sql = " MERGE INTO ",g_posdbs,"tb_Goods",g_db_links,
               " USING (SELECT DISTINCT rte01,rte03,ima02,ima021,rte05,",
               "               rte06,ima151,ima1006,ima131,ima1005,",
               "               ima1004,ima1007,ima1008,ima1009,ima160,",
               "               ima161,ima162,imaacti",
               "          FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
                                 cl_get_target_table(g_azw01,'rtd_file'),",",
                                 cl_get_target_table(g_azw01,'ima_file'),",rtz_temp",
               "         WHERE rte01 = rtd01 AND rte03 = ima01 AND rtdconf = 'Y' ",
               "           AND (ima151='Y' OR ((ima151='N' OR ima151 = ' ') AND imaag is null))",
               "           AND rtz04 = rte01 AND ",g_wc CLIPPED,
               "         GROUP BY rte01,rte03,ima02,ima021,rte05,rte06,ima151,ima1006,ima131,ima1005,ima1004,ima1007,ima1008,ima1009,ima160,ima161,ima162,imaacti ",
               "         HAVING COUNT(DISTINCT rtz05) = (SELECT COUNT(DISTINCT rte01||rtg01||rte03) FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                                                           cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
               "                                        WHERE rtz05=rtg01  and rta01=rtg03 and rta03 = rtg04  and rtz04=rte01 and rte03=rtg03))",
               " ON (Condition2 = '",g_azw05,"'||rte01 AND PLUNO = rte03)",
               " WHEN MATCHED THEN ",
              #"        UPDATE SET PLUName = ima02,SPEC = ima021,FSAL = rte05,FSBA = rte06,",              #FUN-CB0112 Mark
               "        UPDATE SET PLUName = ima02,SPEC = ima021,FSAL = rte05,FSBA = rte06,FSOD = rte05,", #FUN-CB0112 Add
               "                   IsFeature = ima151,Series = ima1006,SNO = ima131,Brand = ima1005,FGroup1 = ima1004, ",
               "                   FGroup2 = ima1007,FGroup3 = ima1008,FGroup4 = ima1009,IsWeight = ima160,WPLU = ima161,",
               "                   Wunit = ima162,CNFFLG = imaacti "
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"' "
   END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
              #"        INSERT (Condition1,Condition2,PLUNO,PLUName,SPEC,FSAL,FSBA,IsFeature,Series,SNO,Brand,",      #FUN-CB0112 Mark
               "        INSERT (Condition1,Condition2,PLUNO,PLUName,SPEC,FSAL,FSBA,FSOD,IsFeature,Series,SNO,Brand,", #FUN-CB0112 Add
               "                FGroup1,FGroup2,FGroup3,FGroup4,IsWeight,WPLU,Wunit,CNFFLG)",
              #"        VALUES ('",g_trans_no,"','",g_azw05,"'||rte01,rte03,ima02,ima021,rte05,rte06,ima151,ima1006,ima131,ima1005,",       #FUN-CB0112 Mark
               "        VALUES ('",g_trans_no,"','",g_azw05,"'||rte01,rte03,ima02,ima021,rte05,rte06,rte05,ima151,ima1006,ima131,ima1005,", #FUN-CB0112 Add
               "                ima1004,ima1007,ima1008,ima1009,ima160,ima161,ima162,imaacti)"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

   #写请求表：根据产品策略写请求表，异动下传关联传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION )"
   IF g_posway ='1' THEN     
      LET g_sql=g_sql CLIPPED,
               " SELECT DISTINCT rtz01,' ','",g_trans_no,"','tb_Goods',' Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||rte01||'''','D' "
   ELSE     
      LET g_sql=g_sql CLIPPED,
               " SELECT DISTINCT rtz01,' ','",g_trans_no,"','tb_Goods',' Condition2='||''''||'",g_azw05,"'||rte01||'''','D' "
   END IF
   LET g_sql=g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),",", 
                          cl_get_target_table(g_azw01,'rtd_file'),",", 
                          cl_get_target_table(g_azw01,'rte_file'),",",
                          cl_get_target_table(g_azw01,'ima_file'),
               "  WHERE rtd01 = rte01 AND rtz04 = rte01 AND rtdconf = 'Y' ",
               "    AND rte03 = ima01 AND (ima151='Y' or ((ima151='N' OR ima151 = ' ') AND imaag is null))",
               "    AND ",g_wc CLIPPED," AND rtz01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'N')                 
   IF g_success = 'N' THEN RETURN END IF
  #子料号下传，跟非子料号下传一样，（ima151='N' and imaag = '@CHILD'）为子料号，
  #都需要判断产品策略，价格策略，条码，回写已传pos否不区分多属性料号与非多属性料件
   CALL p100_down_2011()
   CALL p100_down_2012()
END FUNCTION

FUNCTION p100_down_2011()      #产品策略特征码下传  #rte_file->tb_Feature
   LET g_ryk03 = "tb_Feature"
   LET g_sql = " MERGE INTO ",g_posdbs,"tb_Feature",g_db_links,
               " USING (SELECT DISTINCT rte01,imx00,imx000,rte03,ima02,ima940,ima941,ima161,imaacti", 
               "          FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
                                 cl_get_target_table(g_azw01,'rtd_file'),",",
                                 cl_get_target_table(g_azw01,'ima_file'),",",
                                 cl_get_target_table(g_azw01,'imx_file'),",rtz_temp",
               "         WHERE rte01 = rtd01 AND rte03 = ima01 AND rtdconf = 'Y' AND (ima151='N' AND imaag = '@CHILD') ",
               "           AND rtz04=rte01 AND rte03 = imx000 AND ",g_wc CLIPPED,
               "         GROUP BY rte01,imx00,imx000,rte03,ima02,ima940,ima941,ima161,imaacti",
               "         HAVING COUNT(DISTINCT rtz05) = (SELECT COUNT(DISTINCT rte01||rtg01||rte03) FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                                                           cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",  
               "                                         WHERE rtz05=rtg01  and rta01=rtg03 and rta03 = rtg04  and rtz04=rte01 and rte03=rtg03))",
               "  ON (Condition2 ='",g_azw05,"'||rte01 AND PLUNO = imx00 AND FeatureNO = imx000 AND FeatureNO = rte03)",
               "  WHEN MATCHED THEN ",
               "       UPDATE SET SPEC = ima02,AttrNO1 = ima940,AttrNO2 = ima941,WPLU = ima161,CNFFLG = imaacti"
   IF g_posway ='1' THEN LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               "  WHEN NOT MATCHED THEN ",
               "       INSERT(Condition1,Condition2,PLUNO,FeatureNO,SPEC,AttrNO1,AttrNO2,WPLU,CNFFLG )",
               "       VALUES('",g_trans_no,"','",g_azw05,"'||rte01,imx00,rte03,ima02,ima940,ima941,ima161,imaacti)"
   CALL p100_postable_ins(g_sql,'Y')  
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：根据产品策略写请求表，异动下传关联传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION )"
   IF g_posway ='1' THEN     
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rtz01,' ','",g_trans_no,"','tb_Feature',' Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||rte01||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rtz01,' ','",g_trans_no,"','tb_Feature',' Condition2='||''''||'",g_azw05,"'||rte01||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rtz_file'),",", 
                          cl_get_target_table(g_azw01,'rtd_file'),",", 
                          cl_get_target_table(g_azw01,'rte_file'),",",
                          cl_get_target_table(g_azw01,'ima_file'),
               "  WHERE rtd01 = rte01 AND rtz04 = rte01 AND rtdconf = 'Y' ",
               "    AND rte03 = ima01 AND (ima151='N' AND imaag = '@CHILD') ",
               "    AND ",g_wc CLIPPED," AND rtz01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'N')
END FUNCTION

FUNCTION p100_down_2012()              #商品税别明细资料    #rvy_file->tb_Goods_TaxDetail
   LET g_ryk03 = "tb_Goods_TaxDetail"
   LET g_sql = " MERGE INTO ",g_posdbs,"tb_Goods_TaxDetail",g_db_links,
               " USING (SELECT DISTINCT rte01,rte03,rvy03,rvy04,rte07",
               "          FROM ",cl_get_target_table(g_azw01,'rvy_file'),",",
                                 cl_get_target_table(g_azw01,'rte_file'),",",
                                 cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
               "         WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
               "           AND rvy01 = rte01 AND rvy02 = rte02 ",
               "           AND rtz04=rte01 AND ",g_wc CLIPPED,
               "         GROUP BY rte01,rte03,rvy03,rvy04,rte07",
               "         HAVING COUNT(DISTINCT rtz05) = (SELECT COUNT(DISTINCT rte01||rtg01||rte03) FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                                                           cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
               "                                         WHERE rtz05=rtg01  and rta01=rtg03 and rta03 = rtg04  and rtz04=rte01 and rte03=rtg03))",
               "  ON (Condition2 ='",g_azw05,"'||rte01 AND PluNo = rte03 AND Item = rvy03)",
               "  WHEN MATCHED THEN ",
               "       UPDATE SET TaxCode = rvy04,CnfFlg = rte07 "
   IF g_posway ='1' THEN LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               "  WHEN NOT MATCHED THEN ",
               "       INSERT(Condition1,Condition2,PluNo,Item,TaxCode,CnfFlg)",
               "       VALUES('",g_trans_no,"','",g_azw05,"'||rte01,rte03,rvy03,rvy04,rte07)"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   
  #ERP不存在,中间库存在的税别,有效码更新为N
   LET g_sql = " UPDATE ",g_posdbs,"tb_Goods_TaxDetail",g_db_links,
               "    SET CnfFlg = 'N' ",
               "  WHERE CnfFlg = 'Y' ",
               "    AND EXISTS (SELECT 1 FROM rtz_temp WHERE Condition2 = '",g_azw05,"'||rtz04) ",
               "    AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rvy_file'),",",
                                                    cl_get_target_table(g_azw01,'rte_file'),",",
                                                    cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
               "                            WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
               "                              AND rvy01 = rte01 AND rvy02 = rte02 ",
               "                              AND rtz04 = rte01 AND ",g_wc CLIPPED,
               "                              AND Condition2 = '",g_azw05,"'||rte01 AND PluNo = rte03 AND Item = rvy03) "
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_202()      #价格策略（自定价) #rtg_file->tb_Price  # rta_file->tb_BarCode  # rth_file->tb_Price_Shop
   LET g_ryk03 = "tb_Price"
   LET g_sql = " MERGE INTO ",g_posdbs,"tb_Price",g_db_links,
               " USING (SELECT DISTINCT rtg01,rtg03,imx000,imx00, ",
              #"               CASE WHEN (ima151='N' and imaag = '@CHILD') THEN (SELECT imx00 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = rtg03) ELSE rtg03 END rtg03_1, ",
              #"               '0', ",
              #"               CASE WHEN (ima151='N' and imaag = '@CHILD') THEN rtg03 ELSE ' ' END rtg03_2,",
               "               COALESCE(imx00,rtg03) rtg03_1,",
               "               '0',",
               "               CASE WHEN (ima151='N' and imaag = '@CHILD') THEN rtg03 ELSE ' ' END rtg03_2,",
               "               rtg04,rtg05,rtg07,rtg11,rtg06,",
               "               rtg10,",cl_tp_tochar("rtg12",'YYYYMMDD')," rtg12,rtg09 ",
               "          FROM ",cl_get_target_table(g_azw01,'rtf_file'),",",
                                 cl_get_target_table(g_azw01,'rtg_file'),",",
                                 cl_get_target_table(g_azw01,'rta_file'),",",
                                 cl_get_target_table(g_azw01,'ima_file')," LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'imx_file')," ON (imx000 = ima01),rtz_temp,",
               "                 (SELECT DISTINCT rte01 rte01_1, rte03 rte03_1 ",
               "                    FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
                                           cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
               "                   WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
               "                     AND rtz04 = rte01 GROUP BY rte01,rte03 ",
               "                   HAVING COUNT(DISTINCT rtz05)  = (SELECT COUNT(DISTINCT rte01||rtg01||rte03)",
               "                                                      FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                             cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
               "                                                     WHERE rtz05=rtg01  AND rtz04=rte01 AND rte03=rtg03",
               "                                                       AND rta01=rtg03 AND rta03 = rtg04))",
               "         WHERE rtf01 = rtg01 AND rtfconf = 'Y' AND rtg03 = ima01 ",
               "           AND rta01 = rtg03 AND rta03 = rtg04 ",
               "           AND rtg04 IS NOT NULL AND rtg12 IS NOT NULL ",   #FUN-D40064 Add
               "           AND ",g_wc CLIPPED,
               "           AND rtz05 = rtg01 AND rte01_1 = rtz04 AND rte03_1 = rtg03) ",
               "    ON (Condition2 ='",g_azw05,"'||rtg01 AND ",
              #"        ((EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = PLUNO ) AND FeatureNO = rtg03) OR (FeatureNO = ' ' AND PLUNO = rtg03)) ",
               "        ((imx000 = FeatureNO AND imx00 = PLUNO AND FeatureNO = rtg03) OR (FeatureNO = ' ' AND PLUNO = rtg03))",
               "        AND Unit = rtg04 AND Item = '0' )",
               "  WHEN MATCHED THEN ",
               "       UPDATE SET Price1 = rtg05,Price2 = rtg07,Price3 = rtg11,Price4 = rtg06,",
               "                  OpenPrice = rtg10,EFFDate = rtg12,CNFFLG = rtg09 "
   IF g_posway ='1' THEN LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               "  WHEN NOT MATCHED THEN ",
               "       INSERT(Condition1,Condition2, ",
               "              PLUNO,",
               "              Item,",
               "              FeatureNO,",
               "              Unit,Price1,Price2,Price3,Price4,",
               "              OpenPrice,EFFDate,CNFFLG)",
               "       VALUES('",g_trans_no,"','",g_azw05,"'||rtg01,",
               "              rtg03_1,'0',rtg03_2,",
               "              rtg04,rtg05,rtg07,rtg11,rtg06,",
               "              rtg10,rtg12,rtg09)"
   CALL p100_postable_ins(g_sql,'Y')  
   IF g_success = 'N' THEN RETURN END IF
   
   #写请求表：根据产品策略写请求表，异动下传关联传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION )"
   IF g_posway ='1' THEN     
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rtz01,' ','",g_trans_no,"','tb_Price',' Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||rtg01||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rtz01,' ','",g_trans_no,"','tb_Price',' Condition2='||''''||'",g_azw05,"'||rtg01||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rtf_file'),",",
                                 cl_get_target_table(g_azw01,'rtg_file'),",",
                                 cl_get_target_table(g_azw01,'rtz_file'),
               "         WHERE rtf01 = rtg01 AND rtfconf = 'Y' AND rtz05=rtg01 ",
               "           AND rtg04 IS NOT NULL AND rtg12 IS NOT NULL ",    #FUN-D40064 Add 
               "           AND rtz01 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED

#  LET g_sql = g_sql CLIPPED,
#              "   FROM ",cl_get_target_table(g_azw01,'rtf_file'),",",
#                                cl_get_target_table(g_azw01,'rtg_file'),",",
#                                cl_get_target_table(g_azw01,'rta_file'),",",
#                                cl_get_target_table(g_azw01,'rtz_file'),",",
#              "                 (SELECT DISTINCT rte01 rte01_1, rte03 rte03_1 ",
#              "                    FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
#                                          cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
#              "                   WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
#              "                     AND rtz04 = rte01 GROUP BY rte01,rte03 ",
#              "                   HAVING COUNT(DISTINCT rtz05)  = (SELECT COUNT(DISTINCT rte01||rtg01||rte03)",
#              "                                                      FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
#                                                                            cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
#              "                                                     WHERE rtz05=rtg01  AND rtz04=rte01 AND rte03=rtg03",
#              "                                                       AND rta01=rtg03 AND rta03 = rtg04))",
#              "         WHERE rtf01 = rtg01 AND rtfconf = 'Y' AND rtz05=rtg01 ",
#              "           AND rta01 = rtg03 AND rta03 = rtg04 ",
#              "           AND rtz01 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
#              "           AND rte01_1 = rtz04 AND rte03_1 = rtg03"

   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')                 
   IF g_success = 'N' THEN RETURN END IF           
   CALL p100_down_2021()   #条码下传
   LET g_flag = 'Y'
   CALL p100_down_2022()   #自定价下传
END FUNCTION

FUNCTION p100_down_2021()  #条码  # rta_file->tb_BarCode
   LET g_ryk03 = "tb_BarCode"
   LET g_sql = " MERGE INTO ",g_posdbs,"tb_BarCode",g_db_links,
               " USING (SELECT DISTINCT rtg01,rta01,imx000,imx00, ",
               "               COALESCE(imx00,rta01) rta01_1,",
               "               CASE WHEN (ima151='N' and imaag = '@CHILD') THEN rta01 ELSE ' ' END rta01_2,",
               "               rta05,rta03,rtaacti",
               "          FROM ",cl_get_target_table(g_azw01,'rtf_file'),",",
                                 cl_get_target_table(g_azw01,'rtg_file'),",",
                                 cl_get_target_table(g_azw01,'rta_file'),",",
                                 cl_get_target_table(g_azw01,'ima_file')," LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'imx_file')," ON (imx000 = ima01),rtz_temp,",
               "                 (SELECT DISTINCT rte01 rte01_1, rte03 rte03_1 ",
               "                    FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
                                           cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
               "                   WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
               "                     AND rtz04 = rte01 GROUP BY rte01,rte03 ",
               "                   HAVING COUNT(DISTINCT rtz05)  = (SELECT COUNT(DISTINCT rte01||rtg01||rte03)",
               "                                                      FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                             cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
               "                                                     WHERE rtz05=rtg01  AND rtz04=rte01 AND rte03=rtg03",
               "                                                       AND rta01=rtg03 AND rta03 = rtg04))",
               "         WHERE rtf01 = rtg01 AND rtfconf = 'Y' AND rtg03 = ima01 ",
               "           AND rta01 = rtg03 AND rta03 = rtg04 ",
               "           AND rta03 IS NOT NULL ",     #FUN-D40064 Add   
               "           AND ",g_wc CLIPPED,
               "           AND rtz05 = rtg01 AND rte01_1 = rtz04 AND rte03_1 = rtg03) ",
               "    ON (Condition2 ='",g_azw05,"'||rtg01 AND ",
              #"        ((EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = PLUNO ) AND FeatureNO = rta01) OR (FeatureNO = ' ' AND PLUNO = rta01)) AND ",
               "        ((imx000 = FeatureNO AND imx00 = PLUNO AND FeatureNO = rta01) OR (FeatureNO = ' ' AND PLUNO = rta01)) AND ",
               "        PLUBarcode = rta05 AND  Unit = rta03)",
               "  WHEN MATCHED THEN ",
               "       UPDATE SET CNFFLG = rtaacti "  #PLUBarcode = rta05,Unit = rta03,CNFFLG = rtaacti "
   IF g_posway ='1' THEN LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               "  WHEN NOT MATCHED THEN ",
               "       INSERT(Condition1,Condition2, ",
               "              PLUNO,",
               "              FeatureNO,",
               "              PLUBarcode,Unit,CNFFLG)",
               "       VALUES('",g_trans_no,"','",g_azw05,"'||rtg01, ",
               "              rta01_1,",
               "              rta01_2,",
               "              rta05,rta03,rtaacti)"

   CALL p100_postable_ins(g_sql,'Y')  
   IF g_success = 'N' THEN RETURN END IF
   
   #写请求表：根据产品策略写请求表，异动下传关联传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION )"
   IF g_posway ='1' THEN     
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rtz01,' ','",g_trans_no,"','tb_BarCode',' Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||rtg01||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rtz01,' ','",g_trans_no,"','tb_BarCode',' Condition2='||''''||'",g_azw05,"'||rtg01||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rtf_file'),",",
                                 cl_get_target_table(g_azw01,'rtg_file'),",",
                                 cl_get_target_table(g_azw01,'rtz_file'),
               "         WHERE rtf01 = rtg01 AND rtfconf = 'Y' AND rtz05=rtg01 ",
               "           AND rtz01 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED

#  LET g_sql = g_sql CLIPPED,
#              "  FROM ",cl_get_target_table(g_azw01,'rtf_file'),",",
#                                cl_get_target_table(g_azw01,'rtg_file'),",",
#                                cl_get_target_table(g_azw01,'rta_file'),",",
#                                cl_get_target_table(g_azw01,'rtz_file'),",",
#              "                 (SELECT DISTINCT rte01 rte01_1, rte03 rte03_1 ",
#              "                    FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
#                                          cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
#              "                   WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
#              "                     AND rtz04 = rte01 GROUP BY rte01,rte03 ",
#              "                   HAVING COUNT(DISTINCT rtz05)  = (SELECT COUNT(DISTINCT rte01||rtg01||rte03)",
#              "                                                      FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
#                                                                            cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
#              "                                                     WHERE rtz05=rtg01  AND rtz04=rte01 AND rte03=rtg03",
#              "                                                       AND rta01=rtg03 AND rta03 = rtg04))",
#              "         WHERE rtf01 = rtg01 AND rtfconf = 'Y' ",
#              "           AND rta01 = rtg03 AND rta03 = rtg04 ",
#              "           AND rtz05 = rtg01 AND rtz01 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
#              "           AND rte01_1 = rtz04 AND rte03_1 = rtg03"
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION p100_down_2022()  #自定价  # rth_file->tb_Price_Shop
   LET g_ryk03 = "tb_Price_Shop"
   CALL p100_g_wc('rth_file','4') RETURNING g_wc
   LET g_sql = " MERGE INTO ",g_posdbs,"tb_Price_Shop",g_db_links,
               " USING (SELECT DISTINCT rthplant,rth01,imx000,imx00, ",
              #"               CASE WHEN (ima151='N' and imaag = '@CHILD') THEN (SELECT imx00 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = rth01) ELSE rth01 END rth01_1," ,
              #"               0,",
              #"               CASE WHEN (ima151='N' and imaag = '@CHILD') THEN rth01 ELSE ' ' END rth01_2,",
               "               COALESCE(imx00,rth01) rth01_1,",
               "               0,",
               "               CASE WHEN (ima151='N' and imaag = '@CHILD') THEN rth01 ELSE ' ' END rth01_2,",
               "               rth02,rth04,rth06,rth08,rth05,",
               "               rth07,",cl_tp_tochar("rth09",'YYYYMMDD')," rth09,rthacti",
               "          FROM ",cl_get_target_table(g_azw01,'rth_file'),",",
                                 cl_get_target_table(g_azw01,'rtf_file'),",",
                                 cl_get_target_table(g_azw01,'rtg_file'),",",
                                 cl_get_target_table(g_azw01,'rta_file'),",",
                                 cl_get_target_table(g_azw01,'ima_file')," LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'imx_file')," ON (imx000 = ima01),rtz_temp,",
               "                 (SELECT DISTINCT rte01 rte01_1, rte03 rte03_1 ",
               "                    FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
                                           cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
               "                   WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
               "                     AND rtz04 = rte01 GROUP BY rte01,rte03 ",
               "                   HAVING COUNT(DISTINCT rtz05)  = (SELECT COUNT(DISTINCT rte01||rtg01||rte03)",
               "                                                      FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
                                                                             cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
               "                                                     WHERE rtz05=rtg01  AND rtz04=rte01 AND rte03=rtg03",
               "                                                       AND rta01=rtg03 AND rta03 = rtg04))",
               "         WHERE rth01 = rtg03 AND rth02 = rtg04 AND rtg08 = 'Y' ",
               "           AND rtf01 = rtg01 AND rtfconf = 'Y' AND rtg03 = ima01 ",
               "           AND rta01 = rtg03 AND rta03 = rtg04 ",
               "           AND rth09 IS NOT NULL ",     #FUN-D40064 Add
               "           AND rthplant IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
               "           AND rtz05 = rtg01 AND rte01_1 = rtz04 AND rte03_1 = rtg03) ",
               "    ON (Condition2 ='",g_azw05,"'||rthplant AND ",
              #"        ((EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = PLUNO ) AND FeatureNO = rth01) OR (FeatureNO = ' ' AND PLUNO = rth01)) AND ",
               "        ((imx000 = FeatureNO AND imx00 = PLUNO AND FeatureNO = rth01) OR (FeatureNO = ' ' AND PLUNO = rth01)) AND ",
               "        Unit = rth02 AND Item = '0')",
               "  WHEN MATCHED THEN ",
               "       UPDATE SET Price1 = rth04,Price2 = rth06,Price3 = rth08,Price4 = rth05,",
               "       Price5 = '',Price6 = '',Price7 = '',Price8 = '',Price9 = '',",
               "       OpenPrice = rth07,EFFDate = rth09,CNFFLG = rthacti"
   IF g_posway ='1' THEN LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               "  WHEN NOT MATCHED THEN ",
               "       INSERT(Condition1,Condition2, ",
               "              PLUNO,",
               "              Item,",
               "              FeatureNO,",
               "              Unit,Price1,Price2,Price3,Price4,",
               "              Price5,Price6,Price7,Price8,Price9,",
               "              OpenPrice,EFFDate,CNFFLG)",
               "       VALUES('",g_trans_no,"','",g_azw05,"'||rthplant, ",
               "              rth01_1," ,
               "              0,",
               "              rth01_2,",
               "              rth02,rth04,rth06,rth08,rth05,",
               "              '','','','','',",
               "              rth07,rth09,rthacti)"
   CALL p100_postable_ins(g_sql,'Y')  
   IF g_success = 'N' THEN RETURN END IF
   
   #写请求表：根据产品策略写请求表，异动下传关联传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION )"
   IF g_posway ='1' THEN     
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rthplant,' ','",g_trans_no,"','tb_Price_Shop',' Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||rthplant||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rthplant,' ','",g_trans_no,"','tb_Price_Shop',' Condition2='||''''||'",g_azw05,"'||rthplant||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rth_file'),
              #"         WHERE rthplant IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED                         #FUN-D40064 Mark
               "         WHERE rth09 IS NOT NULL AND rthplant IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED   #FUN-D40064 Add 

#  LET g_sql = g_sql CLIPPED,
#              "  FROM ",cl_get_target_table(g_azw01,'rth_file'),",",
#                                cl_get_target_table(g_azw01,'rtf_file'),",",
#                                cl_get_target_table(g_azw01,'rtg_file'),",",
#                                cl_get_target_table(g_azw01,'rta_file'),",",
#                                cl_get_target_table(g_azw01,'rtz_file'),",",
#              "                 (SELECT DISTINCT rte01 rte01_1, rte03 rte03_1 ",
#              "                    FROM ",cl_get_target_table(g_azw01,'rte_file'),",",
#                                          cl_get_target_table(g_azw01,'rtd_file'),",rtz_temp",
#              "                   WHERE rte01 = rtd01 AND rtdconf = 'Y' ",
#              "                     AND rtz04 = rte01 GROUP BY rte01,rte03 ",
#              "                   HAVING COUNT(DISTINCT rtz05)  = (SELECT COUNT(DISTINCT rte01||rtg01||rte03)",
#              "                                                      FROM ",cl_get_target_table(g_azw01,'rtg_file'),",",
#                                                                            cl_get_target_table(g_azw01,'rta_file'),",rtz_temp",
#              "                                                     WHERE rtz05=rtg01  AND rtz04=rte01 AND rte03=rtg03",
#              "                                                       AND rta01=rtg03 AND rta03 = rtg04))",
#              "         WHERE rth01 = rtg03 AND rth02 = rtg04 AND rtg08 = 'Y' ",
#              "           AND rtf01 = rtg01 AND rtfconf = 'Y' ",
#              "           AND rta01 = rtg03 AND rta03 = rtg04 ",
#              "           AND rtz05 = rtg01 AND ",g_wc CLIPPED,
#              "           AND rte01_1 = rtz04 AND rte03_1 = rtg03"
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION  p100_down_102()     #用户单据权限表基本资料
     LET g_ryk03 = "th_Role"
  #更新用户单据权限表资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有用户单据权限表的资料
   LET g_sql = " UPDATE ",g_posdbs,"th_Role",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,OPGName,DISC,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',ryr02,ryr03,ryracti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (OPGName,DISC,CNFFLG) = ",
               "        (SELECT ryr02,ryr03,ryracti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'ryr_file'),
              #"          WHERE OPGroup = ryr01)",                       #FUN-D40064 Mark
               "          WHERE OPGroup = ryr01 AND ryr02 IS NOT NULL)", #FUN-D40064 Add
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryr_file'),
              #"                 WHERE OPGroup = ryr01 AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"                         #FUN-D40064 Mark
               "                 WHERE OPGroup = ryr01 AND ryr02 IS NOT NULL AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"   #FUN-D40064 Add
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"th_Role",g_db_links," (",
                " Condition1,Condition2, ",
                " OPGroup,OPGName,DISC,CNFFLG)",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        ryr01,ryr02,ryr03,ryracti ",
                "   FROM ",cl_get_target_table(g_azw01,'ryr_file'),
                "  WHERE  ",g_wc CLIPPED,
                "    AND ryr02 IS NOT NULL ",   #FUN-D40064 Add
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"th_Role",g_db_links,
                "                    WHERE Condition2 ='",g_azw05,"' AND OPGroup = ryr01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','th_Role',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','th_Role',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
   CALL p100_down_102_1()   #权限模块单身
   CALL p100_down_102_2()   #权限功能单身
   CALL p100_down_102_3()   #POS模块基本资料
   CALL p100_down_102_4()   #POS功能基本资料
END FUNCTION

FUNCTION p100_down_102_1()     #用户单据权限表基本资料 rys_file->th_BillPower
     LET g_ryk03 = "th_BillPower"
  #更新用户单据权限表资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有用户单据权限表的资料
   LET g_sql = " UPDATE ",g_posdbs,"th_BillPower",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,ModularNO,PowerType,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rys02,rys03,rysacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (ModularNO,PowerType,CNFFLG) = ",
               "        (SELECT rys02,rys03,rysacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rys_file'),
               "          WHERE rys01 = OPGroup AND ModularNO = rys02)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rys_file'),",",
                                                cl_get_target_table(g_azw01,'ryr_file'),
               "                 WHERE ryr01 = rys01 AND rys01 = OPGroup AND ModularNO = rys02", #FUN-CB0007
               "                   AND ryr02 IS NOT NULL ",                 #FUN-D40064 Add
               "                   AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'N')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"th_BillPower",g_db_links," (",
                " Condition1,Condition2, ",
                " OPGroup,ModularNO,PowerType,CNFFLG)",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        rys01,rys02,rys03,rysacti ",
                "   FROM ",cl_get_target_table(g_azw01,'rys_file'),",",
                           cl_get_target_table(g_azw01,'ryr_file'),
                "  WHERE ryr01 = rys01 AND ",g_wc CLIPPED,
                "    AND ryr02 IS NOT NULL ",            #FUN-D40064 Add
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"th_BillPower",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND OPGroup = rys01 AND ModularNO = rys02 )" #FUN-CB0007
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p100_down_102_2()
  LET g_ryk03 = "th_Power"
  #更新用户单据权限表资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有用户单据权限表的资料
   LET g_sql = " UPDATE ",g_posdbs,"th_Power",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,FuncNO,PowerType,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',ryt03,ryt04,rytacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (FuncNO,PowerType,CNFFLG) = ",
               "        (SELECT ryt03,ryt04,rytacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'ryt_file'),
               "          WHERE OPGroup = ryt01 AND FuncNO = ryt03)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryt_file'),",",
                                                cl_get_target_table(g_azw01,'ryr_file'),
               "                 WHERE ryr01 = ryt01 AND OPGroup = ryt01 AND FuncNO = ryt03 ", #FUN-CB0007
               "                   AND ryr02 IS NOT NULL ",            #FUN-D40064 Add
               "                   AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'N')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"th_Power",g_db_links," (",
                " Condition1,Condition2, ",
                " OPGroup,FuncNO,PowerType,CNFFLG)",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        ryt01,ryt03,ryt04,rytacti ",
                "   FROM ",cl_get_target_table(g_azw01,'ryt_file'),",",
                           cl_get_target_table(g_azw01,'ryr_file'),
                "  WHERE ryr01 = ryt01 AND ",g_wc CLIPPED,
                "    AND ryr02 IS NOT NULL ",            #FUN-D40064 Add
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"th_Power",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND OPGroup = ryt01 AND FuncNO = ryt03)" #FUN-CB0007
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_102_3()
   LET g_ryk03 = "ta_Modular"
   CALL p100_g_wc('ryp_file','4') RETURNING g_wc
  #更新用户单据权限表资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有用户单据权限表的资料
   LET g_sql = " UPDATE ",g_posdbs,"ta_Modular",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,ModularLevel,UpperModular,CHSMSG,CHTMSG,ENGMSG,CNFFLG,Ftype,ProName,Parameter) = ",
               "        (SELECT '",g_trans_no,"',ryp02,ryp03,a.ryx05,b.ryx05,c.ryx05,rypacti,ryp04,ryp05,ryp06 "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (ModularLevel,UpperModular,CHSMSG,CHTMSG,ENGMSG,CNFFLG,Ftype,ProName,Parameter) = ",
               "        (SELECT ryp02,ryp03,a.ryx05,b.ryx05,c.ryx05,rypacti,ryp04,ryp05,ryp06 "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'ryp_file')," LEFT OUTER JOIN ",
                                  cl_get_target_table(g_azw01,'ryx_file')," a ON (a.ryx01='ryp_file' AND a.ryx02='ryp01' AND a.ryx03=ryp01 AND a.ryx04='2') LEFT OUTER JOIN ",
                                  cl_get_target_table(g_azw01,'ryx_file')," b ON (b.ryx01='ryp_file' AND b.ryx02='ryp01' AND b.ryx03=ryp01 AND b.ryx04='0') LEFT OUTER JOIN ",
                                  cl_get_target_table(g_azw01,'ryx_file')," c ON (c.ryx01='ryp_file' AND c.ryx02='ryp01' AND c.ryx03=ryp01 AND c.ryx04='1') ",
               "          WHERE ModularNO = ryp01)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryp_file'),
               "                 WHERE ModularNO = ryp01 AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_Modular",g_db_links," (",
                " Condition1,Condition2, ",
                " ModularNO,ModularLevel,UpperModular,CHSMSG,CHTMSG,ENGMSG,CNFFLG,Ftype,ProName,Parameter)",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        ryp01,ryp02,ryp03,a.ryx05,b.ryx05,c.ryx05,rypacti,ryp04,ryp05,ryp06 ",
                "   FROM ",cl_get_target_table(g_azw01,'ryp_file')," LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'ryx_file')," a ON (a.ryx01='ryp_file' AND a.ryx02='ryp01' AND a.ryx03=ryp01 AND a.ryx04='2') LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'ryx_file')," b ON (b.ryx01='ryp_file' AND b.ryx02='ryp01' AND b.ryx03=ryp01 AND b.ryx04='0') LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'ryx_file')," c ON (c.ryx01='ryp_file' AND c.ryx02='ryp01' AND c.ryx03=ryp01 AND c.ryx04='1') ",
                "  WHERE ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_Modular",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND ModularNO = ryp01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_Modular',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_Modular',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION 

FUNCTION p100_down_102_4()
   LET g_ryk03 = "ta_Modular_Function"
   CALL p100_g_wc('ryq_file','4') RETURNING g_wc
  #更新用户单据权限表资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有用户单据权限表的资料
   LET g_sql = " UPDATE ",g_posdbs,"ta_Modular_Function",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,ModularNO,ISPay,CHSMSG,CHTMSG,ENGMSG,CNFFLG,Ftype,ProName,Parameter) = ",
               "        (SELECT '",g_trans_no,"',ryq02,ryq03,a.ryx05,b.ryx05,c.ryx05,ryqacti,ryq04,ryq05,ryq06  "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (ModularNO,ISPay,CHSMSG,CHTMSG,ENGMSG,CNFFLG,Ftype,ProName,Parameter) = ",
               "        (SELECT ryq02,ryq03,a.ryx05,b.ryx05,c.ryx05,ryqacti,ryq04,ryq05,ryq06  "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'ryq_file')," LEFT OUTER JOIN ",
                                  cl_get_target_table(g_azw01,'ryx_file')," a ON (a.ryx01='ryq_file' AND a.ryx02='ryq01' AND a.ryx03=ryq01 AND a.ryx04='2') LEFT OUTER JOIN ",
                                  cl_get_target_table(g_azw01,'ryx_file')," b ON (b.ryx01='ryq_file' AND b.ryx02='ryq01' AND b.ryx03=ryq01 AND b.ryx04='0') LEFT OUTER JOIN ",
                                  cl_get_target_table(g_azw01,'ryx_file')," c ON (c.ryx01='ryq_file' AND c.ryx02='ryq01' AND c.ryx03=ryq01 AND c.ryx04='1') ",
               "          WHERE FuncNO = ryq01)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryq_file'),
               "                 WHERE FuncNO = ryq01 AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_Modular_Function",g_db_links," (",
                " Condition1,Condition2, ",
                " FuncNO,ModularNO,ISPay,CHSMSG,CHTMSG,ENGMSG,CNFFLG,Ftype,ProName,Parameter)",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        ryq01,ryq02,ryq03,a.ryx05,b.ryx05,c.ryx05,ryqacti,ryq04,ryq05,ryq06 ",
                "   FROM ",cl_get_target_table(g_azw01,'ryq_file')," LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'ryx_file')," a ON (a.ryx01='ryq_file' AND a.ryx02='ryq01' AND a.ryx03=ryq01 AND a.ryx04='2') LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'ryx_file')," b ON (b.ryx01='ryq_file' AND b.ryx02='ryq01' AND b.ryx03=ryq01 AND b.ryx04='0') LEFT OUTER JOIN ",
                           cl_get_target_table(g_azw01,'ryx_file')," c ON (c.ryx01='ryq_file' AND c.ryx02='ryq01' AND c.ryx03=ryq01 AND c.ryx04='1') ",
                "  WHERE ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_Modular_Function",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND FuncNO = ryq01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：每一个用户单据权限表写一笔请求表(初始化只写初始化用户单据权限表)，WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
  #如果一个用户单据权限表有异动，需更新到所有用户单据权限表，初始化时只更新到初始化用户单据权限表，其他用户单据权限表通过异动下传来做，否则会重复做同样的事情
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_Modular_Function',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_Modular_Function',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION  p100_down_105()     #支付方式基本资料
     LET g_ryk03 = "ta_Payment"
  #更新支付方式资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新db下所有支付方式的资料
   LET g_sql = " UPDATE ",g_posdbs,"ta_Payment",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,FuncNO,PayCodeERP,PayName,MUSTCH,PCashDraw,CanSale,CNFFLG,CanCard,CanCoupon,PCounter) = ", #FUN-CB0007 Add CanCard,CanCoupon  #FUN-CC0116 add PCounter
               "        (SELECT '",g_trans_no,"',ryd06,ryd01,ryd02,ryd09,ryd07,ryd08,rydacti,ryd11,ryd12,ryd13"             #FUN-CB0007 Add ryd11,ryd12   #FUN-CC0116 add ryd13
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (FuncNO,PayCodeERP,PayName,MUSTCH,PCashDraw,CanSale,CNFFLG,CanCard,CanCoupon,PCounter) = ", #FUN-CB0007 Add CanCard,CanCoupon  #FUN-CC0116 add PCounter
               "        (SELECT ryd06,ryd01,ryd02,ryd09,ryd07,ryd08,rydacti,ryd11,ryd12,ryd13"                   #FUN-CB0007 Add ryd11,ryd12 #FUN-CC0116 add ryd13
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'ryd_file'),
              #"          WHERE PayCode = ryd03)", #FUN-C80072 mark
              #"          WHERE PayCode = ryd10)",  #FUN-C80072 add        #FUN-D40064 Mark
               "          WHERE PayCode = ryd10 AND ryd06 IS NOT NULL ",   #FUN-D40064 Add
               "            AND ryd02 IS NOT NULL AND ryd09 IS NOT NULL)", #FUN-D40064 Add
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ryd_file'),
               #"                 WHERE PayCode = ryd03 AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"  #FUN-C80072 mark
               "                 WHERE PayCode = ryd10 AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"   #FUN-C80072 add
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_Payment",g_db_links," (",
                " Condition1,Condition2, ",
                " FuncNO,PayCodeERP,PayCode,PayName,",
                " PayCH,MUSTCH,Spill,CanReturn,PCashDraw,Limit,",
                " PCounter,CanSale,e_Canrecharge,e_CanSaleCard,",
                " e_CanSaleGift,e_CanMixAccept,e_CanMixPay,CNFFLG,CanCard,CanCoupon)", #FUN-CB0007 Add CanCard,CanCoupon
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                #"         ryd06,ryd01,ryd03,ryd02,",        #FUN-C80072 mark
                "         ryd06,ryd01,ryd10,ryd02,",         #FUN-C80072 add
                "         CASE WHEN ryd01 IN ('02','03','05','06') THEN 'N' ELSE 'Y' END ,",
                #"         ryd09,CASE WHEN ryd01 = '04' THEN 'Y' ELSE 'N' END ,'Y',ryd07,0,'Y',",    #FUN-CC0116 mark
                "         ryd09,CASE WHEN ryd01 = '04' THEN 'Y' ELSE 'N' END ,'Y',ryd07,0,ryd13,",  #FUN-CC0116 add
                "         ryd08,'N','N','N','N','N',rydacti,ryd11,ryd12 ", #FUN-CB0007 Add ryd11,ryd12 
                "   FROM ",cl_get_target_table(g_azw01,'ryd_file'),
                "  WHERE ",g_wc CLIPPED,
                "    AND ryd06 IS NOT NULL AND ryd02 IS NOT NULL AND ryd09 IS NOT NULL ",       #FUN-D40064 Add 
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_Payment",g_db_links,
                #"                     WHERE Condition2 ='",g_azw05,"' AND PayCode = ryd03 )"   #FUN-C80072 mark
                "                     WHERE Condition2 ='",g_azw05,"' AND PayCode = ryd10 )"    #FUN-C80072 add
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：每一个支付方式写一笔请求表(初始化只写初始化支付方式)，WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
  #如果一个支付方式有异动，需更新到所有支付方式，初始化时只更新到初始化支付方式，其他支付方式通过异动下传来做，否则会重复做同样的事情
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_Payment',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_Payment',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION  p100_down_107()     #消费卡卡种基本资料
     LET g_ryk03 = "ta_ExpenseCard"
  #更新消费卡卡种资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有消费卡卡种的资料
   LET g_sql = " UPDATE ",g_posdbs,"ta_ExpenseCard",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,ECardName,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',CAST(rxw02 AS varchar2(30)),rxwacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (ECardName,CNFFLG) = ",
               "        (SELECT CAST(rxw02 AS varchar2(30)),rxwacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rxw_file'),
               "          WHERE ECardNO = rxw01)", 
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rxw_file'),
               "                 WHERE ECardNO = rxw01 AND Condition2 = '",g_azw05,"' AND ",g_wc CLIPPED,")"  
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"ta_ExpenseCard",g_db_links," (",
                " Condition1,Condition2, ",
                " ECardNO,ECardName,CNFFLG )",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        rxw01,CAST(rxw02 AS varchar2(30)),rxwacti ",
                "   FROM ",cl_get_target_table(g_azw01,'rxw_file'),
                "  WHERE ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"ta_ExpenseCard",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND ECardNO = rxw01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：每一个门店写一笔请求表，WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_ExpenseCard',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','ta_ExpenseCard',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION  p100_down_204()     #商品属性对照表一基本资料
   LET g_ryk03 = "tb_Attribute1"
  #更新商品属性对照表一资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有商品属性对照表一的资料
   LET g_sql = " UPDATE ",g_posdbs,"tb_Attribute1",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,AttrName,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',tqa02,tqaacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (AttrName,CNFFLG) = ",
               "        (SELECT tqa02,tqaacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'tqa_file'),
               "          WHERE AttrNO1 = tqa01 AND tqa03 = '25')",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'tqa_file'),
               "                 WHERE AttrNO1 = tqa01 AND Condition2 = '",g_azw05,"' ",
               "                   AND tqa03 = '25' AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tb_Attribute1",g_db_links," (",
                " Condition1,Condition2, ",
                " AttrNO1,AttrName,CNFFLG)",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        tqa01,tqa02,tqaacti ",
                "   FROM ",cl_get_target_table(g_azw01,'tqa_file'),
                "  WHERE  tqa03 = '25' AND ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tb_Attribute1",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND AttrNO1 = tqa01 AND tqa03 = '25')"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tb_Attribute1',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tb_Attribute1',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION  p100_down_205()     #商品属性对照表二基本资料
   LET g_ryk03 = "tb_Attribute2"
  #更新商品属性对照表一资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有商品属性对照表二的资料
   LET g_sql = " UPDATE ",g_posdbs,"tb_Attribute2",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,AttrName,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',tqa02,tqaacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (AttrName,CNFFLG) = ",
               "        (SELECT tqa02,tqaacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'tqa_file'),
               "          WHERE tqa03 = '26' AND AttrNO2 = tqa01)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'tqa_file'),
               "                 WHERE AttrNO2 = tqa01 AND Condition2 = '",g_azw05,"' ",
               "                   AND tqa03 = '26' AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tb_Attribute2",g_db_links," (",
                " Condition1,Condition2, ",
                " AttrNO2,AttrName,CNFFLG)",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        tqa01,tqa02,tqaacti ",
                "   FROM ",cl_get_target_table(g_azw01,'tqa_file'),
                "  WHERE tqa03 = '26' AND ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tb_Attribute2",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND AttrNO2 = tqa01 AND tqa03 = '26')"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：每一个该db下的门店写一笔请求表，WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tb_Attribute2',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tb_Attribute2',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION  p100_down_206()     #单位基本资料
     LET g_ryk03 = "tb_Unit"
  #更新单位资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有单位的资料
   LET g_sql = " UPDATE ",g_posdbs,"tb_Unit",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,UName,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',gfe02,gfeacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (UName,CNFFLG) = ",
               "        (SELECT gfe02,gfeacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'gfe_file'),
               "          WHERE Unit = gfe01)",
               "  WHERE Condition2||Unit IN (SELECT '",g_azw05,"'||gfe01 FROM ",cl_get_target_table(g_azw01,'gfe_file'),
               "                              WHERE  Unit = gfe01 AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tb_Unit",g_db_links," (",
                " Condition1,Condition2, ",
                " Unit,UName,CNFFLG )",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        gfe01,gfe02,gfeacti ",
                "   FROM ",cl_get_target_table(g_azw01,'gfe_file'),
                "  WHERE ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tb_Unit",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND Unit = gfe01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：每一个没一个门店写一笔请求表，WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tb_Unit',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tb_Unit',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

#FUN-D20020--add--str---
FUNCTION p100_down_207()    #觸屏分類資料
DEFINE l_sql     STRING
DEFINE l_rcj13   LIKE rcj_file.rcj13

   LET l_sql = " SELECT rcj13 FROM ",cl_get_target_table(g_azw01,'rcj_file') 
   PREPARE sel_rcj13_pre FROM l_sql
  #EXECUTE sel_rcj13_pre INTO l_rcj13    #FUN-D30093 mark
   EXECUTE sel_rcj13_pre INTO g_rcj13    #FUN-D30093 add

   LET g_ryk03 = "tb_Class"
  #FUN-D30093--mark--str---
  #LET g_sql = " UPDATE ",g_posdbs,"tb_Class",g_db_links
  #IF g_posway ='1' THEN
  #   IF l_rcj13 = '1' THEN
  #      LET g_sql = g_sql CLIPPED,
  #            "    SET (Condition1,ClassNO,ClassName,ClassLevel,UpClassNO,Priority,CNFFLG) = ",
  #            "        (SELECT DISTINCT '",g_trans_no,"',rzj03,oba02,rzj02,rzj05,rzj06,rzjacti "
  #   ELSE
  #      LET g_sql = g_sql CLIPPED,
  #            "    SET (Condition1,ClassNO,ClassName,ClassLevel,UpClassNO,Priority,CNFFLG) = ",
  #            "        (SELECT DISTINCT '",g_trans_no,"',rzj03,rzh02,rzj02,rzj05,rzj06,rzjacti "
  #   END IF
  #ELSE
  #   IF l_rcj13 = '1' THEN
  #      LET g_sql = g_sql CLIPPED,
  #            "    SET (ClassNO,ClassName,ClassLevel,UpClassNO,Priority,CNFFLG) = ",
  #            "        (SELECT DISTINCT rzj03,oba02,rzj02,rzj05,rzj06,rzjacti "
  #   ELSE
  #      LET g_sql = g_sql CLIPPED,
  #            "    SET (ClassNO,ClassName,ClassLevel,UpClassNO,Priority,CNFFLG) = ",
  #            "        (SELECT DISTINCT rzj03,rzh02,rzj02,rzj05,rzj06,rzjacti "
  #   END IF
  #END IF

  #IF l_rcj13 = '1' THEN
  #   LET g_sql = g_sql CLIPPED,
  #            "           FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",
  #                               cl_get_target_table(g_azw01,'rzi_file'),",",
  #                               cl_get_target_table(g_azw01,'rzl_file'),",",
  #                               cl_get_target_table(g_azw01,'oba_file'),
  #            "          WHERE rzl01 = rzj01 AND rzj01 = rzi01 AND rzj03 = oba01 AND ClassNO = rzj03 AND Condition2 = '",g_azw05,"'||rzj01) ",
  #            "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",
  #                                             cl_get_target_table(g_azw01,'rzi_file'),",",
  #                                             cl_get_target_table(g_azw01,'rzl_file'),
  #            "                 WHERE rzj01 = rzl01 AND rzj01 = rzi01 AND ClassNO = rzj03 AND Condition2 = '",g_azw05,"'||rzj01 ",
  #            "                   AND rzl02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,")"
  #ELSE
  #   LET g_sql = g_sql CLIPPED,
  #            "           FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",
  #                               cl_get_target_table(g_azw01,'rzi_file'),",",
  #                               cl_get_target_table(g_azw01,'rzl_file'),",",
  #                               cl_get_target_table(g_azw01,'rzh_file'),
  #            "          WHERE rzl01 = rzj01 AND rzj01 = rzi01 AND rzj03 = rzh01 AND ClassNO = rzj03 AND Condition2 = '",g_azw05,"'||rzj01) ",
  #            "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",
  #                                             cl_get_target_table(g_azw01,'rzi_file'),",",
  #                                             cl_get_target_table(g_azw01,'rzl_file'),
  #            "                 WHERE rzj01 = rzl01 AND rzj01 = rzi01 AND ClassNO = rzj03 AND Condition2 = '",g_azw05,"'||rzj01 ",
  #            "                   AND rzl02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,")"
  #END IF
  #CALL p100_postable_upd(g_sql,'Y')
  #IF g_success = 'N' THEN RETURN END IF

  ##INSERT 中間庫不存在的資料,條件同UPDATE,排除中間庫已有的資料
  #IF l_rcj13 = '1' THEN
  #   LET g_sql = " INSERT INTO ",g_posdbs,"tb_Class",g_db_links," (",
  #               "    Condition1,Condition2,ClassNO,ClassName,ClassLevel,UpClassNO,Priority,CNFFLG)",
  #               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rzj01, ",
  #               "        rzj03,oba02,rzj02,rzj05,rzj06,rzjacti ",
  #               "   FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",
  #                          cl_get_target_table(g_azw01,'rzi_file'),",", 
  #                          cl_get_target_table(g_azw01,'rzl_file'),",",
  #                          cl_get_target_table(g_azw01,'oba_file'),
  #               "  WHERE rzj01 = rzl01 AND rzj01 = rzi01 AND rzj03 = oba01 AND rzl02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
  #               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tb_Class",g_db_links,
  #               "                     WHERE Condition2 ='",g_azw05,"'||rzj01 AND ClassNO = rzj03 )"
  #ELSE 
  #   LET g_sql = " INSERT INTO ",g_posdbs,"tb_Class",g_db_links," (",
  #               "    Condition1,Condition2,ClassNO,ClassName,ClassLevel,UpClassNO,Priority,CNFFLG)",
  #               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rzj01, ",
  #               "        rzj03,rzh02,rzj02,rzj05,rzj06,rzjacti ",
  #               "   FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",
  #                          cl_get_target_table(g_azw01,'rzi_file'),",",     
  #                          cl_get_target_table(g_azw01,'rzl_file'),",",
  #                          cl_get_target_table(g_azw01,'rzh_file'),
  #               "  WHERE rzj01 = rzl01 AND rzj01 = rzi01 AND rzj03 = rzh01 AND rzl02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
  #               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tb_Class",g_db_links,
  #               "                     WHERE Condition2 ='",g_azw05,"'||rzj01 AND ClassNO = rzj03 )"
  #END IF
  #FUN-D30093--mark-end---
  #FUN-D30093--add--str---
   #MERGE 写法
   LET g_sql = " MERGE INTO ",g_posdbs,g_ryk03,g_db_links ,
               " USING (SELECT rzj01,rzj03,rzj04,rzj02,rzj05,rzj06,rzjacti ",
               "          FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",
                                 cl_get_target_table(g_azw01,'rzi_file'),",",
                                 cl_get_target_table(g_azw01,'rzl_file'),
               "         WHERE rzj01 = rzl01 AND rzj01 = rzi01 AND rzi09 = '",g_rcj13,"' AND rziacti = 'Y' AND rzlacti = 'Y' ",
               "           AND rzl02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,")",
               " ON (Condition2 ='",g_azw05,"'||rzj01 AND ClassNO = rzj03 )",
               " WHEN MATCHED THEN ",
               "        UPDATE SET ClassName = rzj04 ,ClassLevel = rzj02 ,UpClassNO = rzj05 ,",
               "                   Priority = rzj06 ,CNFFLG = rzjacti "
   IF  g_posway ='1' THEN LET g_sql = g_sql CLIPPED," ,Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "        INSERT(Condition1,Condition2,ClassNO,ClassName,ClassLevel,UpClassNO,Priority,CNFFLG)",              
               "        VALUES('",g_trans_no,"','",g_azw05,"'||rzj01,rzj03,rzj04,rzj02,rzj05,rzj06,rzjacti)"
  #FUN-D30093--add--end---
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

   #寫請求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rzl02,' ','",g_trans_no,"','tb_Class',' Condition2 = '||''''||'",g_azw05,"'||rzj01||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rzl02,' ','",g_trans_no,"','tb_Class',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||rzj01||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",        
                          cl_get_target_table(g_azw01,'rzi_file'),",",
                          cl_get_target_table(g_azw01,'rzl_file'),
               "  WHERE rzj01 = rzl01 AND rzj01 = rzi01 AND rzl02 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED,
               "    AND rziacti = 'Y' AND rzlacti = 'Y' "       #FUN-D30093 add 
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')

END FUNCTION

FUNCTION p100_down_2071()  #觸屏產品資料

   LET g_ryk03 = "tb_Class_Goods"
  #FUN-D30093--mark--str---
  #LET g_sql = " UPDATE ",g_posdbs,"tb_Class_Goods",g_db_links
  #IF g_posway ='1' THEN
  #   LET g_sql = g_sql CLIPPED,
  #            "    SET (Condition1,PLUNO,FeatureNO,Unit,Picture,ClassNO,Priority,CNFFLG) = ",
  #            "        (SELECT  '",g_trans_no,"',COALESCE(imx00,rzk02),COALESCE(imx000,' '),rzk03,rzk05,rzk04,rzk06,rzkacti " 
  #ELSE
  #   LET g_sql = g_sql CLIPPED,
  #            "    SET (PLUNO,FeatureNO,Unit,Picture,ClassNO,Priority,CNFFLG) = ",
  #            "        (SELECT  COALESCE(imx00,rzk02),COALESCE(imx000,' '),rzk03,rzk05,rzk04,rzk06,rzkacti " 
  #END IF
  #LET g_sql = g_sql CLIPPED,
  #            "           FROM ",cl_get_target_table(g_azw01,'rzk_file')," ",
  #            "LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'imx_file')," ON imx000 = rzk02 ",",",
  #                               cl_get_target_table(g_azw01,'rzi_file'),
  #            "          WHERE rzk01 = rzi01 AND rzk01 IN (SELECT rzl01 FROM ",cl_get_target_table(g_azw01,'rzl_file')," WHERE rzl02 IN ",g_all_plant CLIPPED,")"," AND PLUNO = COALESCE(imx00,rzk02) AND FeatureNO = COALESCE(imx000,' ') AND Condition2 = '",g_azw05,"'||rzk01) ",
  #            "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rzk_file')," ",
  #            "              LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'imx_file')," ON imx000 = rzk02 ",",",
  #                                             cl_get_target_table(g_azw01,'rzi_file'),
  #            "                 WHERE rzk01 = rzi01 AND PLUNO = COALESCE(imx00,rzk02) AND Condition2 = '",g_azw05,"'||rzk01 ",
  #            "                   AND rzk01 IN (SELECT rzl01 FROM ",cl_get_target_table(g_azw01,'rzl_file')," WHERE rzl02 IN ",g_all_plant CLIPPED,")"," AND ",g_wc CLIPPED,")"
  #
  #CALL p100_postable_upd(g_sql,'Y')
  #IF g_success = 'N' THEN RETURN END IF
 
  ##INSERT 中間庫不存在的資料,條件同UPDATE,排除中間庫已有的資料
  #LET g_sql = " INSERT INTO ",g_posdbs,"tb_Class_Goods",g_db_links," (",
  #            "    Condition1,Condition2,PLUNO,FeatureNO,Unit,Picture,ClassNO,Priority,CNFFLG)",
  #            " SELECT  '",g_trans_no,"','",g_azw05,"'||rzk01, ",
  #            "        COALESCE(imx00,rzk02),COALESCE(imx000,' '),rzk03,rzk05,rzk04,rzk06,rzkacti ",
  #            "   FROM ",cl_get_target_table(g_azw01,'rzk_file')," ",
  #            "   LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'imx_file')," ON imx000 = rzk02 ",",",
  #                                  cl_get_target_table(g_azw01,'rzi_file'),
  #            "  WHERE rzk01 = rzi01 ",
  #            "    AND rzk01 IN (SELECT rzl01 FROM ",cl_get_target_table(g_azw01,'rzl_file')," WHERE rzl02 IN ",g_all_plant CLIPPED,")"," AND ",g_wc CLIPPED,
  #            "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tb_Class_Goods",g_db_links,
  #            "                     WHERE Condition2 ='",g_azw05,"'||rzk01 AND PLUNO = COALESCE(imx00,rzk02) )"
  #FUN-D30093--mark--end--- 
  #FUN-D30093--add--str---
   #MERGE 写法
   LET g_sql = " MERGE INTO ",g_posdbs,g_ryk03,g_db_links ,
               " USING ( SELECT rzk01,COALESCE(imx00,rzk02) imx00,COALESCE(imx000,' ') imx000,rzk03,rzk05,rzk04,rzk06,rzkacti ",
               "           FROM ",cl_get_target_table(g_azw01,'rzk_file')," ",
               "LEFT OUTER JOIN ",cl_get_target_table(g_azw01,'imx_file')," ON imx000 = rzk02 ",",",
                                  cl_get_target_table(g_azw01,'rzi_file'), 
               "          WHERE rzk01 = rzi01 AND rzi09 = '",g_rcj13,"' AND rziacti = 'Y' ",
               "            AND rzk01 IN (SELECT rzl01 FROM ",cl_get_target_table(g_azw01,'rzl_file')," WHERE rzl02 IN ",g_all_plant CLIPPED,")"," AND ",g_wc CLIPPED,")",
               " ON (Condition2 ='",g_azw05,"'||rzk01 AND PLUNO = imx00 AND FeatureNO = imx000 )",
               " WHEN MATCHED THEN ",
               "         UPDATE SET Unit = rzk03 ,Picture = rzk05 ,",
               "                    ClassNO = rzk04 ,Priority = rzk06 ,CNFFLG = rzkacti "
   IF  g_posway ='1' THEN LET g_sql = g_sql CLIPPED," ,Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "         INSERT(Condition1,Condition2,PLUNO,FeatureNO,Unit,Picture,ClassNO,Priority,CNFFLG)",
               "         VALUES('",g_trans_no,"','",g_azw05,"'||rzk01,imx00,imx000,rzk03,rzk05,rzk04,rzk06,rzkacti)"
  #FUN-D30093--add--end---
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

END FUNCTION   
#FUN-D20020--add--end---

FUNCTION  p100_down_301()   #rab_file -> te_Gen   一般促销主档
   LET g_ryk03 = "te_Gen"
  #更新一般促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新门店所有一般促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_Gen",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,CanFullProm,CanMeDISC,MeEnjoy,Priority,CNFFLG) = ",
               "        (SELECT DISTINCT '",g_trans_no,"',rab07,rab10,rab04,",cl_tp_tochar("raq06",'YYYYMMDD'),"||raq07[1,2]||raq07[4,5]||raq07[7,8],rabacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (CanFullProm,CanMeDISC,MeEnjoy,Priority,CNFFLG) = ",
               "        (SELECT DISTINCT rab07,rab10,rab04,",cl_tp_tochar("raq06",'YYYYMMDD'),"||raq07[1,2]||raq07[4,5]||raq07[7,8],rabacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rab_file'),",",
                                  cl_get_target_table(g_azw01,'raq_file'),
               "          WHERE PromNO = rab02 AND Condition2 = '",g_azw05,"'||rabplant ",
               "            AND rab01 = raq01 AND rab02 = raq02 AND rabplant = raqplant AND raq04 = rabplant AND raq03 = '1') ",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rab_file'),",",
                                                cl_get_target_table(g_azw01,'rac_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                WHERE PromNO = rab02 AND Condition2= '",g_azw05,"'||rabplant",
               "                  AND rab01 = rac01 AND rab02 = rac02 AND rabplant = racplant ",
               "                  AND rab01 = raq01 AND rab02 = raq02 AND rabplant = raqplant AND raq03 = '1' ",
               "                  AND rabplant IN ",g_all_plant CLIPPED," AND raq04 = rabplant ",
               "                  AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Gen",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,CanFullProm,CanMeDISC,MeEnjoy,Priority,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rabplant, ",
               "        rab02,rab07,rab10,rab04,",cl_tp_tochar("raq06",'YYYYMMDD'),"||raq07[1,2]||raq07[4,5]||raq07[7,8],rabacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rab_file'),",",
                          cl_get_target_table(g_azw01,'rac_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE raq01 = rab01 AND raq02 = rab02 AND rabplant = raqplant AND raq03 ='1' ",
               "    AND rab01 = rac01 AND rab02 = rac02 AND rabplant = racplant ",
               "    AND raq04 = rabplant AND rabplant IN ",g_all_plant CLIPPED,
               "    AND raq05 ='Y' AND raqacti = 'Y' AND rabconf = 'Y'  AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Gen",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rabplant AND PromNO = rab02)"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：按照rabplant写请求表，WHERE条件初始化时为Condition2=当前DB+门店，异动下传为Condition1=当前传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rabplant,' ','",g_trans_no,"','te_Gen',' Condition2 = '||''''||'",g_azw05,"'||rabplant||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rabplant,' ','",g_trans_no,"','te_Gen',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||rabplant||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rab_file'),",",
                          cl_get_target_table(g_azw01,'rac_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rab01 = raq01 AND rab02 = raq02 AND rabplant = raqplant AND raq03 = '1' ",
               "    AND rab01 = rac01 AND rab02 = rac02 AND rabplant = racplant ",
               "    AND raq04 = rabplant AND rabplant IN ",g_all_plant CLIPPED,
               "    AND rabconf ='Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
   CALL p100_down_301_1()   #rac_file -> te_Gen_Price   一般促销组别价格文件
   CALL p100_down_301_2()   #rak_file -> te_PromTime   促销时间文件
   CALL p100_down_301_3()   #rad_file -> te_Gen_Price_Info   一般促销信息文件
   CALL p100_down_301_4()   #rap_file -> te_Gen_Price_Vip   一般促销会员级别价格文件
   CALL p100_down_301_5()   #raq_file -> te_PromRange 一般促销生效摊位
   CALL p100_tk_TransTaskDetail_del(g_ryk01)
END FUNCTION

FUNCTION  p100_down_301_1()   #rac_file -> te_Gen_Price   一般促销组别价格文件
   LET g_ryk03 = "te_Gen_Price"
  #更新一般促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有一般促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_Gen_Price",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,GroupNO,PromWay,SpecialPrice,MeSpecialPrice,DISC,MeDISC,Rebate,MeRebate,MePromWay,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rac03,rac04,rac05,rac09,CASE WHEN rac06 IS NULL THEN 0 ELSE rac06 END,CASE WHEN rac10 IS NULL THEN 0 ELSE rac10 END,rac07,rac11,rac08,racacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (GroupNO,PromWay,SpecialPrice,MeSpecialPrice,DISC,MeDISC,Rebate,MeRebate,MePromWay,CNFFLG) = ",
               "        (SELECT rac03,rac04,rac05,rac09,CASE WHEN rac06 IS NULL THEN 0 ELSE rac06 END,CASE WHEN rac10 IS NULL THEN 0 ELSE rac10 END,rac07,rac11,rac08,racacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rac_file'),
               "          WHERE PromNO = rac02 AND GROUPNO = rac03 AND Condition2 = '",g_azw05,"'||racplant)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rac_file'),",",
                                                cl_get_target_table(g_azw01,'rab_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                        WHERE PromNO = rac02 AND GROUPNO = rac03 AND Condition2 = '",g_azw05,"'||racplant",
               "                          AND rac01 = rab01 AND rac02 = rab02 AND racplant = rabplant ",
               "                          AND rac01 = raq01 AND rac02 = raq02 AND racplant = raqplant AND raq03 = '1' ",
               "                          AND racplant IN ",g_all_plant CLIPPED," AND raq04 = racplant ",
               "                          AND raq05 = 'Y' AND raqacti = 'Y' AND rabconf = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Gen_Price",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,GroupNO,PromWay,SpecialPrice,MeSpecialPrice,DISC,MeDISC,Rebate,MeRebate,MePromWay,CNFFLG)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||racplant, ",
               "         rac02,rac03,rac04,rac05,rac09,CASE WHEN rac06 IS NULL THEN 0 ELSE rac06 END,CASE WHEN rac10 IS NULL THEN 0 ELSE rac10 END,rac07,rac11,rac08,racacti",
               "   FROM ",cl_get_target_table(g_azw01,'rac_file'),",",
                          cl_get_target_table(g_azw01,'rab_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rac01 = rab01 AND rac02 = rab02 AND racplant =rabplant ",
               "    AND rac01 = raq01 AND rac02 = raq02 AND racplant =raqplant AND raq03 = '1' ",
               "    AND raq04 = racplant AND racplant IN ",g_all_plant CLIPPED,
               "    AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Gen_Price",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||racplant AND PromNO = rac02 AND GROUPNO = rac03)"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION  p100_down_301_2()   #一般促销时间单身档   #rak_file->te_PromTime
   LET g_ryk03 = "te_PromTime"
  #更新一般促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有一般促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_PromTime",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "                rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG) = ",
               "        (SELECT rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "                rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rak_file'),
               "          WHERE PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 AND rak03 = '1'",
               "            AND Condition2 = '",g_azw05,"'||rakplant)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rak_file'),",",
                                                cl_get_target_table(g_azw01,'rab_file'),",",
                                                cl_get_target_table(g_azw01,'rac_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 AND Condition2 = '",g_azw05,"'||rakplant ",
               "                   AND rak01 = rab01 AND rak02 = rab02 AND rakplant = rabplant ",
               "                   AND rak01 = rac01 AND rak02 = rac02 AND rakplant = racplant ",
               "                   AND rak01 = raq01 AND rak02 = raq02 AND rakplant = raqplant AND raq03 = '1' ",
               "                   AND raq04 = rakplant AND rakplant IN ",g_all_plant CLIPPED,
               "                   AND rak03 = '1' AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_PromTime",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rakplant, ",
               "         rak02,rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "         rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti",
               "   FROM ",cl_get_target_table(g_azw01,'rak_file'),",",
                          cl_get_target_table(g_azw01,'rab_file'),",",
                          cl_get_target_table(g_azw01,'rac_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rak01 = rab01 AND rak02 = rab02 AND rakplant = rabplant ",
               "    AND rak01 = rac01 AND rak02 = rac02 AND rakplant = racplant ",
               "    AND rak01 = raq01 AND rak02 = raq02 AND rakplant = raqplant AND raq03 = '1' ",
               "    AND raq04 = rakplant AND rakplant IN ",g_all_plant CLIPPED,
               "    AND rak03 = '1' AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_PromTime",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rakplant ",
               "                       AND PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION  p100_down_301_3()   #一般促销促销范围单身档   #rad_file->te_Gen_Price_Info
   LET g_ryk03 = "te_Gen_Price_Info"
  #更新一般促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有一般促销的资料
   LET g_sql = " MERGE INTO ",g_posdbs,"te_Gen_Price_Info",g_db_links,
               " USING (SELECT DISTINCT raq04, ",
               "               rad02,rad03,rad04,   rad05,imx00,imx000,",
               "               COALESCE(imx00,rad05) rad05_1,",
               "               CASE WHEN rad06 IS NULL THEN ' ' ELSE rad06 END rad06,",
               "               COALESCE(imx000,' ') rad05_2,",
               "               CASE rad04 WHEN '09' THEN tqa05 ELSE 0 END tqa05,CASE rad04 WHEN '09' THEN tqa06 ELSE 0 END tqa06,radacti",
               "          FROM ",cl_get_target_table(g_azw01,'rad_file')," LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'tqa_file')," ON (tqa01 = rad05 AND tqa03 = '27') LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'imx_file')," ON (rad05 = imx000 AND rad04 = '01'),",
                                 cl_get_target_table(g_azw01,'rab_file'),",",
                                 cl_get_target_table(g_azw01,'rac_file'),",",
                                 cl_get_target_table(g_azw01,'raq_file'),
               "         WHERE rad01 = rab01 AND rad02 = rab02 AND radplant = rabplant ",
               "           AND rad01 = rac01 AND rad02 = rac02 AND radplant = racplant ",
               "           AND rad06 IS NOT NULL ",            #FUN-D40064 Add
               "           AND rad01 = raq01 AND rad02 = raq02 AND radplant = raqplant AND raq03 = '1' ",
               "           AND raq04 = radplant AND radplant IN ",g_all_plant CLIPPED,
               "           AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,") ",
               "   ON (Condition2 ='",g_azw05,"'||raq04 AND ",
               "       PromNO = rad02 AND GroupNO = rad03 AND Type = rad04 AND Unit = rad06 AND ",
               "       Code = rad05_1 AND FeatureNO = rad05_2 )",
              #"       PromNO = rad02 AND GroupNO = rad03 AND Type = rad04 AND (Unit = ' ' OR (Type = 1 AND Unit = rad06)) AND ",
              #"       ((rad04 = '01' AND Code = imx00 AND FeatureNO = rad05) OR (FeatureNO = ' ' AND Code = rad05)) )",
               " WHEN MATCHED THEN ",
              #"        UPDATE SET GroupNO = rad03,Type = rad04,",
              #"                   Code = rad05_1,",
              #"                   Unit = rad06,",
              #"                   FeatureNO = rad05_2,",
               "        UPDATE SET LBPrice = tqa05,",
               "                   LEPrice = tqa06,",
               "                   CNFFLG = radacti "
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"' "
   END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "        INSERT (Condition1,Condition2, ",
               "                PromNO,GroupNO,Type,",
               "                Code,",
               "                Unit,",
               "                FeatureNO,",
               "                LBPrice,LEPrice,CNFFLG)",
               "        VALUES ('",g_trans_no,"','",g_azw05,"'||raq04, ",
               "                 rad02,rad03,rad04,",
               "                 rad05_1,rad06,rad05_2,tqa05,tqa06,",
               "                 radacti)"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION  p100_down_301_4()   #一般促销会员等级设置   #rap_file->te_Gen_Price_Vip
   LET g_ryk03 = "te_Gen_Price_Vip"
  #更新一般促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有一般促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_Gen_Price_Vip",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,GroupNO,Code,MeSpecialPrice,MeDISC,MeRebate,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rap04,rap05,rap06,rap07,rap08,rapacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (GroupNO,Code,MeSpecialPrice,MeDISC,MeRebate,CNFFLG) = ",
               "        (SELECT rap04,rap05,rap06,rap07,rap08,rapacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rap_file'),
               "          WHERE Condition2 ='",g_azw05,"'||rapplant ",
               "            AND PromNO = rap02 AND GroupNO = rap04 AND Code = rap05 AND rap03 = '1') ",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rap_file'),",",
                                                cl_get_target_table(g_azw01,'rab_file'),",",
                                                cl_get_target_table(g_azw01,'rac_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE Condition2 ='",g_azw05,"'||rapplant ",
               "                   AND PromNO = rap02 AND GroupNO = rap04 AND Code = rap05 AND rap03 = '1' ",
               "                   AND rap01 = rab01 AND rap02 = rab02 AND rapplant = rabplant ",
               "                   AND rap01 = rac01 AND rap02 = rac02 AND rapplant = racplant ",
               "                   AND rap01 = raq01 AND rap02 = raq02 AND rapplant = raqplant AND raq03 = '1' ",
               "                   AND raq04 = rapplant AND rapplant IN ",g_all_plant CLIPPED,
               "                   AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Gen_Price_Vip",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,GroupNO,Code,MeSpecialPrice,MeDISC,MeRebate,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rapplant, ",
               "         rap02,rap04,rap05,rap06,rap07,rap08,rapacti",
               "   FROM ",cl_get_target_table(g_azw01,'rap_file'),",",
                          cl_get_target_table(g_azw01,'rab_file'),",",
                          cl_get_target_table(g_azw01,'rac_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rap01 = rab01 AND rap02 = rab02 AND rapplant = rabplant ",
               "    AND rap01 = rac01 AND rap02 = rac02 AND rapplant = racplant ",
               "    AND rap01 = raq01 AND rap02 = raq02 AND rapplant = raqplant AND raq03 = '1' ",
               "    AND raq04 = rapplant AND rapplant IN ",g_all_plant CLIPPED,
               "    AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Gen_Price_Vip",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rapplant ",
               "                       AND PromNO = rap02 AND GroupNO = rap04 AND Code = rap05 AND rap03 = '1')"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p100_down_301_5()     #raq_file -> te_PromRange 一般促销生效摊位
  LET g_ryk03 = "te_PromRange"
  #更新一般促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有一般促销的资料
  LET g_sql= " UPDATE ",g_posdbs,"te_PromRange",g_db_links
  IF g_posway ='1' THEN
     LET g_sql=g_sql,"    SET (Condition1,CNFFLG)  = ",
                     "        (SELECT DISTINCT '",g_trans_no,"',raqacti"
  ELSE
     LET g_sql=g_sql,"    SET CNFFLG = ",
                     "        (SELECT DISTINCT raqacti"
  END IF
  LET g_sql=g_sql,"        FROM ",cl_get_target_table(g_azw01,'raq_file'),
               "          WHERE PromNO = raq02 AND CounterNO = raq08 AND raq03 = '1'",
               "            AND Condition2 = '",g_azw05,"'||raqplant)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rab_file'),",",
                                                cl_get_target_table(g_azw01,'rac_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE PromNO = raq02 AND CounterNO = raq08 AND CNFFLG = raqacti AND Condition2 = '",g_azw05,"'||raqplant ",
               "                   AND raq01 = rab01 AND raq02 = rab02 AND raqplant = rabplant ",
               "                   AND raq01 = rac01 AND raq02 = rac02 AND raqplant = racplant AND raq03 = '1'  ",
               "                   AND raqplant IN ",g_all_plant CLIPPED," AND raq04 = racplant ",
               "                   AND (raq08 IS NOT NULL AND raq08 <>' ')",
               "                   AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
  CALL p100_postable_upd(g_sql,'N')
  IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_PromRange",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,CounterNO,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||raqplant, ",
               "   raq02,raq08,raqacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rab_file'),",",
                          cl_get_target_table(g_azw01,'rac_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE raq01 = rab01 AND raq02 = rab02 AND raqplant = rabplant ",
               "    AND raq01 = rac01 AND raq02 = rac02 AND raqplant = racplant AND raq03 = '1' ",
               "    AND raq04 = racplant AND raqplant IN ",g_all_plant CLIPPED,
               "    AND rabconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND (raq08 IS NOT NULL AND raq08 <>' ')",
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_PromRange",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||raqplant ",
               "                       AND PromNO = raq02 AND CounterNO = raq08  )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION  p100_down_302()   #rae_file -> te_Comb   组合促销单头
   LET g_ryk03 = "te_Comb"
  #更新组合促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有组合促销的资料
   LET g_sql = " MERGE INTO ",g_posdbs,g_ryk03,g_db_links ,
               " USING (SELECT DISTINCT rae02,rae10,rae12,rae11,rae23,",
               "               rae26,rae15,rae18,rae16,rae19,",
               "               rae17,rae20,rae21,rae27,COALESCE(rae31,0) rae31,",
               "               CASE WHEN rae29 = ' ' THEN '' ELSE rae29 END rae29,raq06,raq07,raeacti,raeplant ",
               "        FROM ",cl_get_target_table(g_azw01,'rae_file'),",",
                               cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rae01 = raq01 AND rae02 = raq02 AND raeplant = raqplant AND raq03 = '2'",
               "    AND raeplant IN ",g_all_plant CLIPPED," AND raq04 = raeplant ",
               "    AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")",
               " ON (Condition2 ='",g_azw05,"'||raeplant AND PromNO = rae02 )",
               " WHEN MATCHED THEN ",
               "        UPDATE SET  PromWay = rae10 , MePromWay = rae12, MeEnjoy = rae11 ,CanFullProm = rae23 , CanMEDISC = rae26,",
               "                    SpecialPrice = rae15, MeSpecialPrice = rae18 ,DISC = rae16 ,MeDISC = rae19, Rebate = rae17,",
               "                    MeRebate = rae20 ,CondCount = rae21 ,CanExchange =rae27 ,Optional = rae31 ,ExchangeWay = rae29,",
               "                    Priority = ",cl_tp_tochar("raq06",'YYYYMMDD'),"||raq07[1,2]||raq07[4,5]||raq07[7,8] ,CNFFLG = raeacti "
   IF  g_posway ='1' THEN LET g_sql = g_sql CLIPPED," ,Condition1 = '",g_trans_no,"'" END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "      INSERT(Condition1,Condition2,PromNO,PromWay,MePromWay,MeEnjoy,CanFullProm,CanMEDISC,",
               "             SpecialPrice,MeSpecialPrice,DISC,MeDISC,Rebate,MeRebate,CondCount,CanExchange,Optional,ExchangeWay,Priority,CNFFLG)",
               "      VALUES('",g_trans_no,"','",g_azw05,"'||raeplant,rae02,rae10,rae12,rae11,rae23,rae26,",
               "             rae15,rae18,rae16,rae19,rae17,rae20,rae21,rae27,rae31,rae29,",
               "           ",cl_tp_tochar("raq06",'YYYYMMDD'),"||raq07[1,2]||raq07[4,5]||raq07[7,8],raeacti)"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
              " SELECT DISTINCT raeplant,' ','",g_trans_no,"','te_Comb',' Condition2 = '||''''||'",g_azw05,"'||raeplant||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT raeplant,' ','",g_trans_no,"','te_Comb',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||raeplant||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rae_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rae01 = raq01 AND rae02 = raq02 AND raeplant = raqplant AND raq03 = '2'",
               "    AND raeplant IN ",g_all_plant CLIPPED," AND raq04 = raeplant ",
               "    AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
   CALL p100_down_302_1()   #raf_file -> te_Comb_Group   组合促销组别文件
   CALL p100_down_302_2()   #rag_file -> te_Comb_Group_Goods   组合促销商品信息
   CALL p100_down_302_3()   #rap_file -> te_Comb_Vip   组合促销会员等级价格文件
   CALL p100_down_302_4()   #rar_file -> te_Comb_Pre   组合促销赠送(加价购)组别档
   CALL p100_down_302_5()   #ras_file -> te_Comb_Pre_Goods   组合促销赠送(加价购)档
   CALL p100_down_302_6()   #rak_file -> te_PromTime   促销时间文件
   CALL p100_down_302_7()   #raq_file -> te_PromRange 组合促销生效摊位
   CALL p100_tk_TransTaskDetail_del(g_ryk01)
END FUNCTION

FUNCTION p100_down_302_1()   #raf_file -> te_Comb_Group   组合促销组别文件
   LET g_ryk03 = "te_Comb_Group"
  #更新组合促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有组合促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_Comb_Group",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,GroupNO,InvoWay,CondCount,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',raf03,raf04,raf05,rafacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (GroupNO,InvoWay,CondCount,CNFFLG) = ",
               "        (SELECT raf03,raf04,raf05,rafacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'raf_file'),
               "          WHERE Condition2 ='",g_azw05,"'||rafplant AND PromNO = raf02 AND GroupNO = raf03) ",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'raf_file'),",",
                                                cl_get_target_table(g_azw01,'rae_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE PromNO = raf02 AND GroupNO = raf03 AND Condition2 = '",g_azw05,"'||rafplant",
               "                   AND raf01 = rae01 AND raf02 = rae02 AND rafplant = raeplant",
               "                   AND raf01 = raq01 AND raf02 = raq02 AND rafplant = raqplant AND raq03 = '2'",
               "                   AND rafplant IN ",g_all_plant CLIPPED," AND raq04 = rafplant ",
               "                   AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Comb_Group",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,GroupNO,InvoWay,CondCount,CNFFLG)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rafplant, ",
               "        raf02,raf03,raf04,raf05,rafacti ",
               "   FROM ",cl_get_target_table(g_azw01,'raf_file'),",",
                          cl_get_target_table(g_azw01,'rae_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE raf01 = rae01 AND raf02 = rae02 AND rafplant = raeplant",
               "    AND raf01 = raq01 AND raf02 = raq02 AND rafplant = raqplant AND raq03 = '2'",
               "    AND rafplant IN ",g_all_plant CLIPPED," AND raq04 = rafplant ",
               "    AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Comb_Group",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rafplant AND PromNO = raf02 ",
               "                       AND GroupNO = raf03 )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_302_2()   #rag_file -> te_Comb_Group_Goods   组合促销商品信息
   LET g_ryk03 = "te_Comb_Group_Goods"
  #更新组合促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有组合促销的资料

   LET g_sql = " MERGE INTO ",g_posdbs,"te_Comb_Group_Goods",g_db_links,
               " USING (SELECT DISTINCT raq04, ",
               "               rag02,rag03,rag04,  rag05,imx000,imx00,",
               "               COALESCE(imx00,rag05) rag05_1,",
               "               CASE WHEN rag06 IS NULL THEN ' ' ELSE rag06 END rag06,",
               "               COALESCE(imx000,' ') rag05_2,",
               "               CASE rag04 WHEN '09' THEN tqa05 ELSE 0 END tqa05,CASE rag04 WHEN '09' THEN tqa06 ELSE 0 END tqa06,ragacti",
               "          FROM ",cl_get_target_table(g_azw01,'rag_file')," LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'tqa_file')," ON (rag05 = tqa01 AND tqa03 = '27') LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'imx_file')," ON (rag05 = imx000 AND rag04 = '01'),",
                                 cl_get_target_table(g_azw01,'rae_file'),",",
                                 cl_get_target_table(g_azw01,'raq_file'),
               "         WHERE rag01 = rae01 AND rag02 = rae02 AND ragplant = raeplant ",
               "           AND rag01 = raq01 AND rag02 = raq02 AND ragplant = raqplant AND raq03 = '2' ",
               "           AND ragplant IN ",g_all_plant CLIPPED," AND raq04 = ragplant ",
               "           AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,") ",
               "    ON (Condition2 ='",g_azw05,"'||raq04 AND PromNO = rag02 AND GroupNO = rag03 AND ",
               "        Type = rag04 AND Unit = rag06 AND",
               "        Code = rag05_1 AND FeatureNO = rag05_2 )",
              #"        Type = rag04 AND ((Type = '01' AND Unit = rag06) OR Unit = ' ') AND",
              #"        ((rag04 = '01' AND Code = imx00 AND FeatureNO = rag05) OR (FeatureNO = ' ' AND Code = rag05)) )",
               " WHEN MATCHED THEN ",
              #"        UPDATE SET GroupNO = rag03,Type = rag04,",
              #"                   Code = rag05_1,",
              #"                   Unit = rag06,",
              #"                   FeatureNO = rag05_2,",
               "        UPDATE SET LBPrice = tqa05,",
               "                   LEPrice = tqa06,",
               "                   CNFFLG = ragacti "
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"' "
   END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "        INSERT (Condition1,Condition2, ",
               "                PromNO,GroupNO,Type,",
               "                Code,",
               "                Unit,",
               "                FeatureNO,",
               "                LBPrice,LEPrice,CNFFLG)",
               "        VALUES ('",g_trans_no,"','",g_azw05,"'||raq04, ",
               "                 rag02,rag03,rag04,",
               "                 rag05_1,rag06,rag05_2,tqa05,tqa06,",
               "                 ragacti)"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_302_3()   #rap_file -> te_Comb_Vip   组合促销会员等级价格文件
   LET g_ryk03 = "te_Comb_Vip"
  #更新组合促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有组合促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_Comb_Vip",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Code,MeSpecialPrice,MeDISC,MeRebate,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rap05,rap06,rap07,rap08,rapacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (Code,MeSpecialPrice,MeDISC,MeRebate,CNFFLG) = ",
               "        (SELECT rap05,rap06,rap07,rap08,rapacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rap_file'),
               "          WHERE Condition2 ='",g_azw05,"'||rapplant AND PromNO = rap02 AND Code = rap05 ",
               "            AND rap03 = '2' )",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rap_file'),",",
                                                cl_get_target_table(g_azw01,'rae_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                  WHERE Condition2 ='",g_azw05,"'||rapplant AND PromNO = rap02 AND Code = rap05 ",
               "                    AND rap01 = rae01 AND rap02 = rae02 AND rapplant = raeplant AND rap03 = '2'",
               "                    AND rap01 = raq01 AND rap02 = raq02 AND rapplant = raqplant AND raq03 = '2'",
               "                    AND rapplant IN ",g_all_plant CLIPPED," AND raq04 = rapplant ",
               "                    AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Comb_Vip",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,Code,MeSpecialPrice,MeDISC,MeRebate,CNFFLG)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rapplant, ",
               "        rap02,rap05,rap06,rap07,rap08,rapacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rap_file'),",",
                          cl_get_target_table(g_azw01,'rae_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rap01 = rae01 AND rap02 = rae02 AND rapplant = raeplant AND rap03 = '2'",
               "    AND rap01 = raq01 AND rap02 = raq02 AND rapplant = raqplant AND raq03 = '2'",
               "    AND rapplant IN ",g_all_plant CLIPPED," AND raq04 = rapplant ",
               "    AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Comb_Vip",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rapplant AND PromNO = rap02 AND Code = rap05 ",
               "                       AND rap03 = '2')"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_302_4()   #rar_file -> te_Comb_Pre   组合促销赠送(加价购)组别档
   LET g_ryk03 = "te_Comb_Pre"
  #更新组合促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有组合促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_Comb_Pre",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Item,ExchangeCount,ExtraAMT,MeExraAMT,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rar05,rar06,rar07,rar08,raracti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (Item,ExchangeCount,ExtraAMT,MeExraAMT,CNFFLG) = ",
               "        (SELECT rar05,rar06,rar07,rar08,raracti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rar_file'),
               "          WHERE Condition2 ='",g_azw05,"'||rarplant AND PromNO = rar02 AND rar05 = Item",
               "            AND rar03 = '2')",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rar_file'),",",
                                                cl_get_target_table(g_azw01,'rae_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                        WHERE Condition2 ='",g_azw05,"'||rarplant AND PromNO = rar02 AND rar05 = Item ",
               "                          AND rar01 = rae01 AND rar02 = rae02 AND rarplant = raeplant AND rar03 = '2' ",
               "                          AND rar01 = raq01 AND rar02 = raq02 AND rarplant = raqplant AND raq03 = '2' ",
               "                          AND rarplant IN ",g_all_plant CLIPPED," AND raq04 = rarplant ",
               "                          AND raeconf = 'Y' AND rae28 = '1' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Comb_Pre",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,Item,ExchangeCount,ExtraAMT,MeExraAMT,CNFFLG)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rarplant, ",
               "        rar02,rar05,rar06,rar07,rar08,raracti ",
               "   FROM ",cl_get_target_table(g_azw01,'rar_file'),",",
                          cl_get_target_table(g_azw01,'rae_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rar01 = rae01 AND rar02 = rae02 AND rarplant = raeplant AND rar03 = '2' ",
               "    AND rar01 = raq01 AND rar02 = raq02 AND rarplant = raqplant AND raq03 = '2' ",
               "    AND rarplant IN ",g_all_plant CLIPPED," AND raq04 = rarplant ",
               "    AND raeconf = 'Y' AND rae28 = '1' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Comb_Pre",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rarplant AND PromNO = rar02",
               "                       AND Item = rar05 )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION p100_down_302_5()   #ras_file -> te_Comb_Pre_Goods   组合促销赠送(加价购)档
   LET g_ryk03 = "te_Comb_Pre_Goods"
  #更新组合促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有组合促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_Comb_Pre_Goods",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Item,Type,Code,Unit,FeatureNO,CNFFLG,LBPrice,LEPrice) = ",
               "        (SELECT '",g_trans_no,"',ras05,ras06,",
               "                CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN (SELECT imx00 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07) ELSE ras07 END,",
               "                CASE WHEN ras08 IS NULL THEN ' ' ELSE ras08 END,",
               "                CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN ras07 ELSE ' ' END,",
               "                rasacti,CASE ras06 WHEN '09' THEN tqa05 ELSE 0 END,CASE ras06 WHEN '09' THEN tqa06 ELSE 0 END "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (Item,Type,Code,Unit,FeatureNO,CNFFLG,LBPrice,LEPrice) = ",
               "        (SELECT ras05,ras06,",
               "                CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN (SELECT imx00 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07) ELSE ras07 END,",
               "                CASE WHEN ras08 IS NULL THEN ' ' ELSE ras08 END,",
               "                CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN ras07 ELSE ' ' END,",
               "                rasacti,CASE ras06 WHEN '09' THEN tqa05 ELSE 0 END,CASE ras06 WHEN '09' THEN tqa06 ELSE 0 END "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'ras_file')," LEFT OUTER JOIN ",
                                  cl_get_target_table(g_azw01,'tqa_file')," ON (ras07 = tqa01 AND tqa03 = '27') ",
               "          WHERE Condition2 ='",g_azw05,"'||rasplant AND PromNO = ras02 AND Type = ras06 AND Item = ras05 ",
               "            AND ras07 IS NOT NULL AND ras08 IS NOT NULL ",   #FUN-D40064 Add
              #"            AND ((ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = Code ) AND FeatureNO = ras07))",
              #"             OR  (FeatureNO = ' ' AND Code = ras07)) ",
               "            AND ras03 = '2')",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ras_file'),",",
                                                cl_get_target_table(g_azw01,'rae_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                        WHERE Condition2 ='",g_azw05,"'||rasplant AND PromNO = ras02 AND Type = ras06 AND Item = ras05 ",
              #"                          AND ((ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = Code ) AND FeatureNO = ras07))",
              #"                           OR  (FeatureNO = ' ' AND Code = ras07)) ",
               "                          AND ras01 = rae01 AND ras02 = rae02 AND rasplant = raeplant AND ras03 = '2' ",
               "                          AND ras01 = raq01 AND ras02 = raq02 AND rasplant = raqplant AND raq03 = '2' ",
               "                          AND ras07 IS NOT NULL AND ras08 IS NOT NULL ",   #FUN-D40064 Add
               "                          AND rasplant IN ",g_all_plant CLIPPED," AND raq04 = rasplant ",
               "                          AND raeconf = 'Y' AND rae28 = '1' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"te_Comb_Pre_Goods",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,Item,Type,Code,Unit,FeatureNO,CNFFLG,LBPrice,LEPrice)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rasplant, ",
               "        ras02,ras05,ras06,",
               "        CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN (SELECT imx00 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07) ELSE ras07 END,",
               "        CASE WHEN ras08 IS NULL THEN ' ' ELSE ras08 END,",
               "        CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN ras07 ELSE ' ' END,",
               "        rasacti,CASE ras06 WHEN '09' THEN tqa05 ELSE 0 END,CASE ras06 WHEN '09' THEN tqa06 ELSE 0 END ",
               "   FROM ",cl_get_target_table(g_azw01,'ras_file')," LEFT OUTER JOIN ",
                          cl_get_target_table(g_azw01,'tqa_file')," ON (ras07 = tqa01 AND tqa03 = '27'),",
                          cl_get_target_table(g_azw01,'rae_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE ras01 = rae01 AND ras02 = rae02 AND rasplant = raeplant AND ras03 = '2' ",
               "    AND ras01 = raq01 AND ras02 = raq02 AND rasplant = raqplant AND raq03 = '2' ",
               "    AND rasplant IN ",g_all_plant CLIPPED," AND raq04 = rasplant ",
               "    AND ras07 IS NOT NULL AND ras08 IS NOT NULL ",   #FUN-D40064 Add
               "    AND raeconf = 'Y' AND rae28 = '1' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Comb_Pre_Goods",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rasplant AND PromNO = ras02 AND Type = ras06 AND Item = ras05 ",
              #"                       AND ((ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = Code ) AND FeatureNO = ras07))",
              #"                        OR  (FeatureNO = ' ' AND Code = ras07)) )"
               "                                                                )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_302_6()   #组合促销时间单身档   #rak_file->te_PromTime
   LET g_ryk03 = "te_PromTime"
  #更新
   LET g_sql = " UPDATE ",g_posdbs,"te_PromTime",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "                rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG) = ",
               "        (SELECT rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "                rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rak_file'),
               "          WHERE PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 AND rak03 = '2'",
               "            AND Condition2 = '",g_azw05,"'||rakplant)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rak_file'),",",
                                                cl_get_target_table(g_azw01,'rae_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 AND Condition2 = '",g_azw05,"'||rakplant ",
               "                   AND rak01 = rae01 AND rak02 = rae02 AND rakplant = raeplant ",
               "                   AND rak01 = raq01 AND rak02 = raq02 AND rakplant = raqplant AND raq03 = '2' ",
               "                   AND raq04 = rakplant AND rakplant IN ",g_all_plant CLIPPED,
               "                   AND rak03 = '2' AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_PromTime",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rakplant, ",
               "         rak02,rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "         rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti",
               "   FROM ",cl_get_target_table(g_azw01,'rak_file'),",",
                          cl_get_target_table(g_azw01,'rae_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rak01 = rae01 AND rak02 = rae02 AND rakplant = raeplant ",
               "    AND rak01 = raq01 AND rak02 = raq02 AND rakplant = raqplant AND raq03 = '2' ",
               "    AND raq04 = rakplant AND rakplant IN ",g_all_plant CLIPPED,
               "    AND rak03 = '2' AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_PromTime",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rakplant ",
               "                       AND PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p100_down_302_7()     #raq_file -> te_PromRange 组合促销生效摊位
   LET g_ryk03 = "te_PromRange"
   #更新组合促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有组合促销的资料
   LET g_sql= " UPDATE ",g_posdbs,"te_PromRange",g_db_links
   IF g_posway ='1' THEN
      LET g_sql=g_sql,"    SET(Condition1,CNFFLG)  = ",
                      "        (SELECT DISTINCT '",g_trans_no,"',raqacti"
   ELSE
      LET g_sql=g_sql,"    SET CNFFLG = ",
                      "        (SELECT DISTINCT raqacti"
   END IF
   LET g_sql=g_sql,"       FROM ",cl_get_target_table(g_azw01,'raq_file'),
               "          WHERE PromNO = raq02 AND CounterNO = raq08 AND raq03 = '2'",
               "            AND Condition2 = '",g_azw05,"'||raqplant)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rae_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE PromNO = raq02 AND CounterNO = raq08 AND CNFFLG = raqacti AND Condition2 = '",g_azw05,"'||raqplant ",
               "                   AND raq01 = rae01 AND raq02 = rae02 AND raqplant = raeplant AND raq03 = '2' ",
               "                   AND raqplant IN ",g_all_plant CLIPPED," AND raq04 = raeplant ",
               "                   AND (raq08 IS NOT NULL AND raq08 <>' ')",
               "                   AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_PromRange",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,CounterNO,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||raqplant, ",
               "   raq02,raq08,raqacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rae_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE raq01 = rae01 AND raq02 = rae02 AND raqplant = raeplant AND raq03 = '2' ",
               "    AND raqplant IN ",g_all_plant CLIPPED," AND raq04 = raeplant ",
               "    AND (raq08 IS NOT NULL AND raq08 <>' ')",
               "    AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_PromRange",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||raqplant ",
               "                       AND PromNO = raq02 AND CounterNO = raq08 )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION  p100_down_303()   #rah_file -> te_Full    满额/满量促销主档
   LET g_ryk03 = "te_Full"
  #更新满额促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有满额促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_Full",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,PromWay,Extent,MeEnjoy,CanMeDISC,CanExchange,",
               "         Optional,ExchangeWay,Ladder,CondType,Priority,CNFFLG) = ",
               "        (SELECT DISTINCT '",g_trans_no,"',rah10,rah11,rah13,rah18,rah19,",
               "                CASE WHEN rah23 IS NULL THEN 0 ELSE rah23 END,",
               "                CASE WHEN rah21 = ' ' THEN '' ELSE rah21 END,",
               "                rah12,rah25,",cl_tp_tochar("raq06",'YYYYMMDD'),"||raq07[1,2]||raq07[4,5]||raq07[7,8],rahacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (PromWay,Extent,MeEnjoy,CanMeDISC,CanExchange,Optional,",
               "         ExchangeWay,Ladder,CondType,Priority,CNFFLG) = ",
               "        (SELECT DISTINCT rah10,rah11,rah13,rah18,rah19,",
               "                CASE WHEN rah23 IS NULL THEN 0 ELSE rah23 END,",
               "                CASE WHEN rah21 = ' ' THEN '' ELSE rah21 END,",
               "                rah12,rah25,",cl_tp_tochar("raq06",'YYYYMMDD'),"||raq07[1,2]||raq07[4,5]||raq07[7,8],rahacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rah_file'),",",
                                  cl_get_target_table(g_azw01,'raq_file'),
               "          WHERE Condition2 = '",g_azw05,"'||rahplant AND PromNO = rah02 ",
               "            AND rah01 = raq01 AND rah02 = raq02 AND rahplant = raqplant AND raq04 = rahplant AND raq03 = '3')",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rah_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE Condition2 = '",g_azw05,"'||rahplant AND PromNO = rah02 ",
               "                   AND rah01 = raq01 AND rah02 = raq02 AND rahplant = raqplant AND raq03 = '3' ",
               "                   AND rahplant IN ",g_all_plant CLIPPED," AND raq04 = rahplant ",
               "                   AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Full",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,PromWay,Extent,MeEnjoy,CanMeDISC,CanExchange,",
               " Optional,ExchangeWay,Ladder,CondType,Priority,CNFFLG)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rahplant, ",
               "        rah02,rah10,rah11,rah13,rah18,rah19,",
               "        CASE WHEN rah23 IS NULL THEN 0 ELSE rah23 END,",
               "        CASE WHEN rah21 = ' ' THEN '' ELSE rah21 END,",
               "        rah12,rah25,",cl_tp_tochar("raq06",'YYYYMMDD'),"||raq07[1,2]||raq07[4,5]||raq07[7,8],rahacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rah_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rah01 = raq01 AND rah02 = raq02 AND rahplant = raqplant AND raq03 = '3' ",
               "    AND rahplant IN ",g_all_plant CLIPPED," AND raq04 = rahplant ",
               "    AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Full",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rahplant AND PromNO = rah02)"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rahplant,' ','",g_trans_no,"','te_Full',' Condition2 = '||''''||'",g_azw05,"'||rahplant||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rahplant,' ','",g_trans_no,"','te_Full',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||rahplant||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM ",cl_get_target_table(g_azw01,'rah_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rah01 = raq01 AND rah02 = raq02 AND rahplant = raqplant AND raq03 = '3' ",
               "    AND rahplant IN ",g_all_plant CLIPPED," AND raq04 = rahplant ",
               "    AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
   CALL p100_down_303_1()   #rai_file -> te_Full_Price   满额/满量促销价格文件
   CALL p100_down_303_2()   #rap_file -> te_Full_Price_Vip   满额/满量促销会员等级价格文件
   CALL p100_down_303_3()   #raj_file -> te_Full_Goods   满额/满量促销商品信息
   CALL p100_down_303_4()   #rar_file -> te_Full_Price_Pre   满额/满量促销赠送(加价购)组别档
   CALL p100_down_303_5()   #ras_file -> te_Full_Price_Pre_Goods   满额/满量促销赠送(加价购)商品信息文件
   CALL p100_down_303_6()   #rak_file -> te_PromTime   促销时间文件
   CALL p100_down_303_7()     #raq_file -> te_PromRange 满额促销生效摊位
   CALL p100_tk_TransTaskDetail_del(g_ryk01)
END FUNCTION

FUNCTION p100_down_303_1()   #rai_file -> te_Full_Price   满额/满量促销价格文件
   LET g_ryk03 = "te_Full_Price"
  #更新
   LET g_sql = " UPDATE ",g_posdbs,"te_Full_Price",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Item,CondFull,DISC,MeDISC,Rebate,MeRebate,MePromWay,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rai03,rai04,rai05,rai08,rai06,rai09,rai07,raiacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (Item,CondFull,DISC,MeDISC,Rebate,MeRebate,MePromWay,CNFFLG) = ",
               "        (SELECT rai03,rai04,rai05,rai08,rai06,rai09,rai07,raiacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rai_file'),
               "          WHERE Condition2 = '",g_azw05,"'||raiplant AND PromNO = rai02 AND Item = rai03)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rai_file'),",",
                                                cl_get_target_table(g_azw01,'rah_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE Condition2 = '",g_azw05,"'||raiplant AND PromNO = rai02 AND Item = rai03 ",
               "                   AND rai01 = rah01 AND rai02 = rah02 AND raiplant = rahplant ",
               "                   AND rai01 = raq01 AND rai02 = raq02 AND raiplant = raqplant AND raq03 = '3' ",
               "                   AND raiplant IN ",g_all_plant CLIPPED," AND raq04 = raiplant ",
               "                   AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
    CALL p100_postable_upd(g_sql,'N')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"te_Full_Price",g_db_links," (",
                " Condition1,Condition2, ",
                " PromNO,Item,CondFull,DISC,MeDISC,Rebate,MeRebate,MePromWay,CNFFLG)",
                " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||raiplant, ",
                "        rai02,rai03,rai04,rai05,rai08,rai06,rai09,rai07,raiacti ",
                "   FROM ",cl_get_target_table(g_azw01,'rai_file'),",",
                           cl_get_target_table(g_azw01,'rah_file'),",",
                           cl_get_target_table(g_azw01,'raq_file'),
                "  WHERE rai01 = rah01 AND rai02 = rah02 AND raiplant = rahplant ",
                "    AND rai01 = raq01 AND rai02 = raq02 AND raiplant = raqplant AND raq03 = '3' ",
                "    AND raiplant IN ",g_all_plant CLIPPED," AND raq04 = raiplant ",
                "    AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Full_Price",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"'||raiplant AND PromNO = rai02 AND Item = rai03)"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_303_2()   #rap_file -> te_Full_Price_Vip   满额/满量促销会员等级价格文件
   LET g_ryk03 = "te_Full_Price_Vip"
  #更新
   LET g_sql = " UPDATE ",g_posdbs,"te_Full_Price_Vip",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Code,ITEM,MeDISC,MeRebate,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rap05,rap04,rap07,rap08,rapacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (Code,ITEM,MeDISC,MeRebate,CNFFLG) = ",
               "        (SELECT rap05,rap04,rap07,rap08,rapacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rap_file'),
               "          WHERE Condition2 ='",g_azw05,"'||rapplant AND PromNO = rap02 AND Code = rap05 AND ITEM = rap04 ",
               "            AND rap03 = '3')",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rap_file'),",",
                                                cl_get_target_table(g_azw01,'rah_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "            WHERE Condition2 ='",g_azw05,"'||rapplant AND PromNO = rap02 AND Code = rap05 AND ITEM = rap04 ",
               "              AND rap01 = rah01 AND rap02 = rah02 AND rapplant = rahplant AND rap03 = '3' ",
               "              AND rap01 = raq01 AND rap02 = raq02 AND rapplant = raqplant AND raq03 = '3' ",
               "              AND rapplant IN ",g_all_plant CLIPPED," AND raq04 = rapplant ",
               "              AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Full_Price_Vip",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,Code,ITEM,MeDISC,MeRebate,CNFFLG)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rapplant, ",
               "        rap02,rap05,rap04,rap07,rap08,rapacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rap_file'),",",
                          cl_get_target_table(g_azw01,'rah_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rap01 = rah01 AND rap02 = rah02 AND rapplant = rahplant AND rap03 = '3'",
               "    AND rap01 = raq01 AND rap02 = raq02 AND rapplant = raqplant AND raq03 = '3'",
               "    AND rapplant IN ",g_all_plant CLIPPED," AND raq04 = rapplant ",
               "    AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Full_Price_Vip",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rapplant AND PromNO = rap02 AND Code = rap05 AND ITEM = rap04)"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_303_3()   #raj_file -> te_Full_Goods   满额/满量促销商品信息
   LET g_ryk03 = "te_Full_Goods"
  #更新

   LET g_sql = " MERGE INTO ",g_posdbs,"te_Full_Goods",g_db_links,
               " USING (SELECT DISTINCT raq04, ",
               "               raj02,raj03,raj04,",
               "               COALESCE(imx00,raj05) raj05_1,",
               "               CASE WHEN raj06 IS NULL THEN ' ' ELSE raj06 END raj06,",
               "               COALESCE(imx000,' ') raj05_2,",
               "               CASE raj04 WHEN '09' THEN tqa05 ELSE 0 END tqa05,CASE raj04 WHEN '09' THEN tqa06 ELSE 0 END tqa06,rajacti",
               "          FROM ",cl_get_target_table(g_azw01,'raj_file')," LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'tqa_file')," ON (raj05 = tqa01 AND tqa03 = '27') LEFT OUTER JOIN ",
                                 cl_get_target_table(g_azw01,'imx_file')," ON (raj05 = imx000 AND raj04 = '01'),",
                                 cl_get_target_table(g_azw01,'rah_file'),",",
                                 cl_get_target_table(g_azw01,'raq_file'),
               "         WHERE raj01 = rah01 AND raj02 = rah02 AND rajplant = rahplant ",
               "           AND raj01 = raq01 AND raj02 = raq02 AND rajplant = raqplant AND raq03 = '3' ",
               "           AND raj05 IS NOT NULL AND raj06 IS NOT NULL ",       #FUN-D40064 Add 
               "           AND rajplant IN ",g_all_plant CLIPPED," AND raq04 = rajplant ",
               "           AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,") ",
               "    ON (Condition2 ='",g_azw05,"'||raq04 AND PromNO = raj02 AND GroupNO = raj03 AND ",
               "        Type = raj04 )",
              #"        Type = raj04 AND ((Type = '01' AND Unit = raj06) OR Unit = ' ') AND",
              #"        Code = raj05_1 AND FeatureNO = raj05_2 )",
              #"        ((raj04 = '01' AND Code = imx00 AND FeatureNO = raj05) OR (FeatureNO = ' ' AND Code = raj05)) )",
               " WHEN MATCHED THEN ",
              #"        UPDATE SET GroupNO = raj03,Type = raj04,",
               "        UPDATE SET Code = raj05_1,",
               "                   Unit = raj06,",
               "                   FeatureNO = raj05_2,",
               "                   LBPrice = tqa05,",
               "                   LEPrice = tqa06,",
               "                   CNFFLG = rajacti "
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,",Condition1 = '",g_trans_no,"' "
   END IF
   LET g_sql = g_sql CLIPPED,
               " WHEN NOT MATCHED THEN ",
               "        INSERT (Condition1,Condition2, ",
               "                PromNO,GroupNO,Type,",
               "                Code,",
               "                Unit,",
               "                FeatureNO,",
               "                LBPrice,LEPrice,CNFFLG)",
               "        VALUES ('",g_trans_no,"','",g_azw05,"'||raq04, ",
               "                 raj02,raj03,raj04,",
               "                 raj05_1,raj06,raj05_2,tqa05,tqa06,",
               "                 rajacti)"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_303_4()   #rar_file -> te_Full_Price_Pre   满额/满量促销赠送(加价购)组别档
   LET g_ryk03 = "te_Full_Price_Pre"
  #更新
   LET g_sql = " UPDATE ",g_posdbs,"te_Full_Price_Pre",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,Mitem,Item,ExchangeCount,ExtraAMT,MeExtraAMT,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rar04,rar05,rar06,rar07,rar08,raracti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (Mitem,Item,ExchangeCount,ExtraAMT,MeExtraAMT,CNFFLG) = ",
               "        (SELECT rar04,rar05,rar06,rar07,rar08,raracti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rar_file'),
               "          WHERE Condition2 ='",g_azw05,"'||rarplant AND PromNO = rar02 AND Mitem = rar04 AND Item = rar05 ",
               "            AND rar03 = '3')",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rar_file'),",",
                                                cl_get_target_table(g_azw01,'rah_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE Condition2 ='",g_azw05,"'||rarplant AND  PromNO = rar02 AND Mitem = rar04 AND Item = rar05 ",
               "                   AND rar01 = rah01 AND rar02 = rah02 AND rarplant = rahplant AND rar03 = '3' ",
               "                   AND rar01 = raq01 AND rar02 = raq02 AND rarplant = raqplant AND raq03 = '3' ",
               "                   AND rarplant IN ",g_all_plant CLIPPED," AND raq04 = rarplant ",
               "                   AND rahconf = 'Y' AND rah20 = '1' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Full_Price_Pre",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,Mitem,Item,ExchangeCount,ExtraAMT,MeExtraAMT,CNFFLG)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rarplant, ",
               "        rar02,rar04,rar05,rar06,rar07,rar08,raracti ",
               "   FROM ",cl_get_target_table(g_azw01,'rar_file'),",",
                          cl_get_target_table(g_azw01,'rah_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rar01 = rah01 AND rar02 = rah02 AND rarplant = rahplant AND rar03 = '3' ",
               "    AND rar01 = raq01 AND rar02 = raq02 AND rarplant = raqplant AND raq03 = '3' ",
               "    AND rarplant IN ",g_all_plant CLIPPED," AND raq04 = rarplant ",
               "    AND rahconf = 'Y' AND rah20 = '1' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Full_Price_Pre",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rarplant AND PromNO = rar02 AND Mitem = rar04 AND Item = rar05)"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_303_5()   #ras_file -> te_Full_Price_Pre_Goods   满额/满量促销赠送(加价购)商品信息文件
   LET g_ryk03 = "te_Full_Price_Pre_Goods"
  #更新
   LET g_sql = " UPDATE ",g_posdbs,"te_Full_Price_Pre_Goods",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,MItem,Item,Type,Code,FeatureNO,Unit,CNFFLG,LBPrice,LEPrice) = ",
               "        (SELECT '",g_trans_no,"',ras04,ras05,ras06,",
               "                CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN (SELECT imx00 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07) ELSE ras07 END,",
               "                CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN ras07 ELSE ' ' END,",
               "                CASE WHEN ras08 IS NULL THEN ' ' ELSE ras08 END,",
               "                rasacti,CASE ras06 WHEN '09' THEN tqa05 ELSE 0 END,CASE ras06 WHEN '09' THEN tqa06 ELSE 0 END "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (MItem,Item,Type,Code,FeatureNO,Unit,CNFFLG,LBPrice,LEPrice) = ",
               "        (SELECT ras04,ras05,ras06,",
               "                CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN (SELECT imx00 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07) ELSE ras07 END,",
               "                CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN ras07 ELSE ' ' END,",
               "                CASE WHEN ras08 IS NULL THEN ' ' ELSE ras08 END,",
               "                rasacti,CASE ras06 WHEN '09' THEN tqa05 ELSE 0 END,CASE ras06 WHEN '09' THEN tqa06 ELSE 0 END "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'ras_file')," LEFT OUTER JOIN ",
                                  cl_get_target_table(g_azw01,'tqa_file')," ON (ras07 = tqa01 AND tqa03 = '27') ",
               "          WHERE PromNO = ras02 AND MItem = ras04 AND Item = ras05 AND Type = ras06 AND ras03 = '3'",
              #"            AND ((ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = Code ) AND FeatureNO = ras07))",
              #"             OR  (FeatureNO = ' ' AND Code = ras07)) )",
               "            AND Condition2 ='",g_azw05,"'||rasplant  )",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'ras_file'),",",
                                                cl_get_target_table(g_azw01,'rah_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE Condition2 ='",g_azw05,"'||rasplant ",
               "                   AND PromNO = ras02 AND MItem = ras04 AND Item = ras05 AND Type = ras06 ",
              #"                   AND ((ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = Code ) AND FeatureNO = ras07))",
              #"                    OR  (FeatureNO = ' ' AND Code = ras07)) ",
               "                   AND ras01 = rah01 AND ras02 = rah02 AND rasplant = rahplant AND ras03 = '3' ",
               "                   AND ras01 = raq01 AND ras02 = raq02 AND rasplant = raqplant AND raq03 = '3' ",
               "                   AND ras07 IS NOT NULL AND ras08 IS NOT NULL ",   #FUN-D40064 Add
               "                   AND rasplant IN ",g_all_plant CLIPPED," AND raq04 = rasplant ",
               "                   AND rahconf = 'Y' AND rah20 = '1' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_Full_Price_Pre_Goods",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,MItem,Item,Type,Code,FeatureNO,Unit,CNFFLG,LBPrice,LEPrice)",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rasplant, ",
               "        ras02,ras04,ras05,ras06,",
               "        CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN (SELECT imx00 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07) ELSE ras07 END,",
               "        CASE WHEN (ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = ras07))) THEN ras07 ELSE ' ' END,",
               "        CASE WHEN ras08 IS NULL THEN ' ' ELSE ras08 END,",
               "        rasacti,CASE ras06 WHEN '09' THEN tqa05 ELSE 0 END,CASE ras06 WHEN '09' THEN tqa06 ELSE 0 END ",
               "   FROM ",cl_get_target_table(g_azw01,'ras_file')," LEFT OUTER JOIN ",
                          cl_get_target_table(g_azw01,'tqa_file')," ON (ras07 = tqa01 AND tqa03 = '27'),",
                          cl_get_target_table(g_azw01,'rah_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE ras01 = rah01 AND ras02 = rah02 AND rasplant = rahplant AND ras03 = '3' ",
               "    AND ras01 = raq01 AND ras02 = raq02 AND rasplant = raqplant AND raq03 = '3' ",
               "    AND rasplant IN ",g_all_plant CLIPPED," AND raq04 = rasplant ",
               "    AND ras07 IS NOT NULL AND ras08 IS NOT NULL ",   #FUN-D40064 Add 
               "    AND rahconf = 'Y' AND rah20 = '1' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_Full_Price_Pre_Goods",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rasplant ",
               "                       AND PromNO = ras02 AND MItem = ras04 AND Item = ras05 AND Type = ras06 ",
              #"                       AND ((ras06 = '01' AND (EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'imx_file')," WHERE imx000 = FeatureNO AND imx00 = Code ) AND FeatureNO = ras07))",
              #"                        OR  (FeatureNO = ' ' AND Code = ras07)) )"
               "                                                                )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p100_down_303_6()   #满额促销时间单身档   #rak_file->te_PromTime
   LET g_ryk03 = "te_PromTime"
  #更新满额促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有满额促销的资料
   LET g_sql = " UPDATE ",g_posdbs,"te_PromTime",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "                rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti "
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG) = ",
               "        (SELECT rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "                rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'rak_file'),
               "          WHERE PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 AND rak03 = '3'",
               "            AND Condition2 = '",g_azw05,"'||rakplant)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rak_file'),",",
                                                cl_get_target_table(g_azw01,'rah_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 AND Condition2 = '",g_azw05,"'||rakplant ",
               "                   AND rak01 = rah01 AND rak02 = rah02 AND rakplant = rahplant ",
               "                   AND rak01 = raq01 AND rak02 = raq02 AND rakplant = raqplant AND raq03 = '3' ",
               "                   AND raq04 = rakplant AND rakplant IN ",g_all_plant CLIPPED,
               "                   AND rak03 = '3' AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_PromTime",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,GroupNO,TimeNO,LBDate,LEDate,LBTime,LETime,FixedDate,Week,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||rakplant, ",
               "         rak02,rak04,rak05,",cl_tp_tochar("rak06",'YYYYMMDD'),",",cl_tp_tochar("rak07",'YYYYMMDD'),",",
               "         rak08[1,2]||rak08[4,5]||rak08[7,8],rak09[1,2]||rak09[4,5]||rak09[7,8],rak10,rak11,rakacti",
               "   FROM ",cl_get_target_table(g_azw01,'rak_file'),",",
                          cl_get_target_table(g_azw01,'rah_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rak01 = rah01 AND rak02 = rah02 AND rakplant = rahplant ",
               "    AND rak01 = raq01 AND rak02 = raq02 AND rakplant = raqplant AND raq03 = '3' ",
               "    AND raq04 = rakplant AND rakplant IN ",g_all_plant CLIPPED,
               "    AND rak03 = '3' AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_PromTime",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||rakplant ",
               "                       AND PromNO = rak02 AND GroupNO = rak04 AND TimeNO = rak05 )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p100_down_303_7()     #raq_file -> te_PromRange 满额促销生效摊位
   LET g_ryk03 = "te_PromRange"
   #更新组合促销资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有组合促销的资料
   LET g_sql= " UPDATE ",g_posdbs,"te_PromRange",g_db_links
   IF g_posway ='1' THEN
      LET g_sql= g_sql,"    SET (Condition1,CNFFLG)  = ",
                       "        (SELECT DISTINCT '",g_trans_no,"',raqacti "
   ELSE
       LET g_sql= g_sql,"    SET CNFFLG  = ",
                        "       (SELECT DISTINCT raqacti "
   END IF
   LET g_sql= g_sql,"      FROM ",cl_get_target_table(g_azw01,'raq_file'),
               "          WHERE PromNO = raq02 AND CounterNO = raq08 AND raq03 = '3'",
               "            AND Condition2 = '",g_azw05,"'||raqplant)",
               "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'rah_file'),",",
                                                cl_get_target_table(g_azw01,'raq_file'),
               "                 WHERE PromNO = raq02 AND CounterNO = raq08 AND CNFFLG = raqacti AND Condition2 = '",g_azw05,"'||raqplant ",
               "                   AND raq01 = rah01 AND raq02 = rah02 AND raqplant = rahplant AND raq03 = '3' ",
               "                   AND raqplant IN ",g_all_plant CLIPPED," AND raq04 = rahplant ",
               "                   AND (raq08 IS NOT NULL AND raq08 <>' ')",
               "                   AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,")"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF

  #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
   LET g_sql = " INSERT INTO ",g_posdbs,"te_PromRange",g_db_links," (",
               " Condition1,Condition2, ",
               " PromNO,CounterNO,CNFFLG )",
               " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||raqplant, ",
               "   raq02,raq08,raqacti ",
               "   FROM ",cl_get_target_table(g_azw01,'rah_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE raq01 = rah01 AND raq02 = rah02 AND raqplant = rahplant AND raq03 = '3' ",
               "    AND raqplant IN ",g_all_plant CLIPPED," AND raq04 = rahplant ",
               "    AND (raq08 IS NOT NULL AND raq08 <>' ')",
               "    AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'Y' AND ",g_wc CLIPPED,
               "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"te_PromRange",g_db_links,
               "                     WHERE Condition2 ='",g_azw05,"'||raqplant ",
               "                       AND PromNO = raq02 AND CounterNO = raq08 )"
   CALL p100_postable_ins(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION  p100_down_404()
   LET g_ryk03 = "tf_CardType_Rule"
   LET g_sql = " UPDATE ",g_posdbs,"tf_CardType_Rule",g_db_links
   IF g_posway ='1' THEN 
      LET g_sql=g_sql," SET (Condition1,RuleWay,Exclude) =",
                      "     (SELECT '",g_trans_no,"',lrp02,lrp03 "
   ELSE
      LET g_sql=g_sql," SET (RuleWay,Exclude)=",
                      "     (SELECT lrp02,lrp03 "
   END IF
   LET    g_sql=g_sql,"       FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                                     cl_get_target_table(g_azw01,'lso_file'),
                      "      WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant AND lrpplant = lso04 ",
                      "        AND lrp00 = RuleType AND lrp01 = CTNO ",
                      "        AND ",cl_tp_tochar("lrp04",'YYYYMMDD')," = LBDate ",
                      "        AND ",cl_tp_tochar("lrp05",'YYYYMMDD')," = LEDate ",
                      "        AND Condition2 = '",g_azw05,"'||lrpplant)",
                      "  WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                                                       cl_get_target_table(g_azw01,'lso_file'),
                      "                 WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant AND lrpplant = lso04 ",
                      "                   AND lrpplant IN ",g_all_plant,
                      "                   AND ",g_wc CLIPPED," AND lrp00 IN ('1','2') ",
                      "                   AND lrpconf = 'Y' AND lrp09 = 'Y' ",          #add by huangtao 12/07/11
                      "                   AND lrp00 = RuleType AND lrp01 = CTNO AND Condition2 ='",g_azw05,"'||lrpplant", 
                      "                   AND ",cl_tp_tochar("lrp04",'YYYYMMDD')," = LBDate ",
                      "                   AND ",cl_tp_tochar("lrp05",'YYYYMMDD')," = LEDate )"
   CALL p100_postable_upd(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF
   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tf_CardType_Rule",g_db_links," (",
                " Condition1,Condition2, ",
                " RuleType,CTNO,RuleWay,Exclude,LBDate,LEDate,CNFFLG )", 
                " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lrpplant, ",
                "          lrp00,lrp01,lrp02,lrp03,",
                           cl_tp_tochar("lrp04",'YYYYMMDD'),",",cl_tp_tochar("lrp05",'YYYYMMDD'),",'Y' ",
                "   FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                           cl_get_target_table(g_azw01,'lso_file'),
                "  WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant AND lrpplant = lso04 ",
                "    AND lrpplant IN ",g_all_plant,
                "    AND ",g_wc CLIPPED, 
                "    AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y' ",         
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tf_CardType_Rule",g_db_links,
                "                    WHERE Condition2 ='",g_azw05,"'||lrpplant AND lrp00 = RuleType AND lrp01 = CTNO ",
                "                      AND ",cl_tp_tochar("lrp04",'YYYYMMDD')," = LBDate ",
                "                      AND ",cl_tp_tochar("lrp05",'YYYYMMDD')," = LEDate )"
   CALL p100_postable_ins(g_sql,'Y')  
   IF g_success = 'N' THEN RETURN END IF 
   
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION) "
   IF g_posway ='2' THEN 
      LET g_sql = g_sql," SELECT DISTINCT lso04,' ','",g_trans_no,"','tf_CardType_Rule','Condition2='||''''||'",g_azw05,"'||lrpplant||'''','D' "
   ELSE
      LET g_sql = g_sql," SELECT DISTINCT lso04,' ','",g_trans_no,"','tf_CardType_Rule','Condition1='||''''||'",g_trans_no,"'||''''||' AND Condition2='||''''||'",g_azw05,"'||lrpplant||'''','D' "
   END IF
   LET g_sql = g_sql, "  FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                                cl_get_target_table(g_azw01,'lso_file'),
               "  WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04 ",
               "    AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y'  ",
               "    AND  ",g_wc CLIPPED,"  AND lrpplant IN ",g_all_plant CLIPPED             
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
  #CALL p100_tk_TransTaskDetail_del(g_ryk01)
END FUNCTION

FUNCTION p100_down_4041()
   LET g_ryk03 = "tf_CardType_Rule_Detail"
   LET g_sql = " UPDATE ",g_posdbs,"tf_CardType_Rule_Detail",g_db_links
   IF g_posway ='1' THEN 
      LET g_sql=g_sql," SET (Condition1,STDScore,UnitScore,DISC,CNFFLG)= ",
                      "     (SELECT '",g_trans_no,"',lrq03,lrq04,lrq05,lrqacti"
   ELSE
      LET g_sql=g_sql," SET (STDScore,UnitScore,DISC,CNFFLG)= ",
                      "     (SELECT lrq03,lrq04,lrq05,lrqacti"
   END IF
   LET  g_sql = g_sql,"       FROM ",cl_get_target_table(g_azw01,'lrq_file'),",",
                                     cl_get_target_table(g_azw01,'lrp_file'),",",
                                     cl_get_target_table(g_azw01,'lso_file'),
                      "      WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04",
                      "        AND lrq00 = RuleType AND lrq01 = CTNO AND lrq02 = Code ",
                      "        AND lrp01=lrq01 AND lrp00=lrq00 AND lrp00 IN ('1','2') ",
                      "        AND lrp04 = lrq10 AND lrp05 = lrq11 AND lrpplant=lrqplant ",
                      "        AND ",cl_tp_tochar("lrq10",'YYYYMMDD')," = LBDate ",
                      "        AND ",cl_tp_tochar("lrq11",'YYYYMMDD')," = LEDate ",
                      "        AND Condition2 ='",g_azw05,"'||lrqplant)",
                      " WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                                                      cl_get_target_table(g_azw01,'lrq_file'),",",
                                                      cl_get_target_table(g_azw01,'lso_file'),
                      "                WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04 ",
                      "                  AND lrp01=lrq01 AND lrp00=lrq00 AND lrp04 = lrq10 AND lrp05 = lrq11 AND lrpplant=lrqplant ",
                      "                  AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y'  ",
                      "                  AND lrqplant IN ",g_all_plant,
                      "                  AND ",g_wc CLIPPED," AND Condition2 ='",g_azw05,"'||lrqplant",
                      "                  AND lrq00 = RuleType AND lrq01 = CTNO AND lrq02 = Code ",
                      "                  AND ",cl_tp_tochar("lrq10",'YYYYMMDD')," = LBDate ",
                      "                  AND ",cl_tp_tochar("lrq11",'YYYYMMDD')," = LEDate)"

   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tf_CardType_Rule_Detail",g_db_links," (",
                " Condition1,Condition2, ",
                " RuleType,CTNO,Code,STDScore,UnitScore,DISC,LBDate,LEDate,CNFFLG )", 
                " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lrqplant, ",
                "          lrq00,lrq01,lrq02,lrq03,lrq04,lrq05, ",
                           cl_tp_tochar("lrq10",'YYYYMMDD'),",",cl_tp_tochar("lrq11",'YYYYMMDD'),",lrqacti",
                "   FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                           cl_get_target_table(g_azw01,'lrq_file'),",",
                           cl_get_target_table(g_azw01,'lso_file'),
                "  WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04 ",
                "    AND lrp01=lrq01 AND lrp00=lrq00 AND lrp04 = lrq10 AND lrp05 = lrq11 AND lrpplant=lrqplant ",
                "    AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y'  ",
                "    AND lrqplant IN ",g_all_plant,
                "    AND ",g_wc CLIPPED,       
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tf_CardType_Rule_Detail",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"'||lrqplant AND lrq00 = RuleType AND lrq01 = CTNO ",
                "                       AND lrq02 = Code ",
                "                       AND ",cl_tp_tochar("lrq10",'YYYYMMDD')," = LBDate ",
                "                       AND ",cl_tp_tochar("lrq11",'YYYYMMDD')," = LEDate )"
   CALL p100_postable_ins(g_sql,'N')  
   IF g_success = 'N' THEN RETURN END IF 
END FUNCTION

FUNCTION p100_down_4042()
   LET g_ryk03 = "tf_CardType_Rule_Ndetail"
   LET g_sql = " UPDATE ",g_posdbs,"tf_CardType_Rule_Ndetail",g_db_links
   IF g_posway ='1' THEN 
      LET g_sql=g_sql," SET (Condition1,CNFFLG)= (SELECT '",g_trans_no,"',lrracti"
   ELSE
      LET g_sql=g_sql," SET CNFFLG = (SELECT lrracti"
   END IF
   LET  g_sql = g_sql,"      FROM ",cl_get_target_table(g_azw01,'lrr_file'),",",
                                    cl_get_target_table(g_azw01,'lrp_file'),",",
                                    cl_get_target_table(g_azw01,'lso_file'),
                      "     WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04",
                      "       AND lrr00 = RuleType AND lrr01 = CTNO AND lrr02 = Code ",
                      "       AND lrp01=lrr01  AND lrp00=lrr00  AND lrp00 IN ('1','2') ",
                      "       AND lrp04 = lrr03 AND lrp05 = lrr04 AND lrpplant = lrrplant",
                      "       AND ",cl_tp_tochar("lrr03",'YYYYMMDD')," = LBDate ",
                      "       AND ",cl_tp_tochar("lrr04",'YYYYMMDD')," = LEDate ",
                      "       AND Condition2 ='",g_azw05,"'||lrrplant)",
                      " WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                                                      cl_get_target_table(g_azw01,'lrr_file'),",",
                                                      cl_get_target_table(g_azw01,'lso_file'),
                      "                WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04 ",
                      "                  AND lrp01=lrr01  AND lrp00=lrr00 AND lrp04 = lrr03 AND lrp05 = lrr04 AND lrpplant = lrrplant ",
                      "                  AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y'  ",
                      "                  AND lrrplant IN ",g_all_plant,
                      "                  AND ",g_wc CLIPPED," AND Condition2 ='",g_azw05,"'||lrrplant",
                      "                  AND lrr00 = RuleType AND lrr01 = CTNO AND lrr02 = Code ",
                      "                  AND ",cl_tp_tochar("lrr03",'YYYYMMDD')," = LBDate ",
                      "                  AND ",cl_tp_tochar("lrr04",'YYYYMMDD')," = LEDate)"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tf_CardType_Rule_Ndetail",g_db_links," (",
                " Condition1,Condition2, ",
                " RuleType,CTNO,Code,LBDate,LEDate,CNFFLG )", 
                " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lrrplant, ",
                "         lrr00,lrr01,lrr02, ",
                          cl_tp_tochar("lrr03",'YYYYMMDD'),",",cl_tp_tochar("lrr04",'YYYYMMDD'),",lrracti",
                "   FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                           cl_get_target_table(g_azw01,'lrr_file'),",",
                           cl_get_target_table(g_azw01,'lso_file'),
                "  WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04 ",
                "    AND lrp01=lrr01  AND lrp00=lrr00 AND lrp04 = lrr03 AND lrp05 = lrr04 AND lrpplant = lrrplant",
                "    AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y'  ",
                "    AND lrrplant IN ",g_all_plant,
                "    AND ",g_wc CLIPPED,       
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tf_CardType_Rule_Ndetail",g_db_links,
                "                    WHERE Condition2 ='",g_azw05,"'||lrrplant AND lrr00 = RuleType AND lrr01 = CTNO ",
                "                      AND lrr02 = Code ",
                "                      AND ",cl_tp_tochar("lrr03",'YYYYMMDD')," = LBDate ",
                "                      AND ",cl_tp_tochar("lrr04",'YYYYMMDD')," = LEDate )"
   CALL p100_postable_ins(g_sql,'N')  
   IF g_success = 'N' THEN RETURN END IF 
END FUNCTION 

FUNCTION p100_down_4043()
   LET g_ryk03 = "tf_CardType_Rule_MDetail"
   LET g_sql = " UPDATE ",g_posdbs,"tf_CardType_Rule_MDetail",g_db_links
   IF g_posway ='1' THEN 
      LET g_sql=g_sql," SET (Condition1,Requirement,BaseScore,MULScore,PREScore,MDISC,",
                      "     BeforeDay,AfterDay,BeginDate,EndDate,LBTime,LETime,FixedDate,Week,CNFFLG)= ",   #FUN-C80079
                      "     (SELECT '",g_trans_no,"',lth06,lth07,lth08,lth09,lth10,",      
                      "     lth11,lth12,",cl_tp_tochar("lth15",'YYYYMMDD'),",",cl_tp_tochar("lth16",'YYYYMMDD'),  #FUN-C80079 
                      "     ,lth17[1,2]||lth17[4,5]||lth17[7,8],lth18[1,2]||lth18[4,5]||lth18[7,8],lth19,lth20,lthacti"
   ELSE
      LET g_sql=g_sql," SET (Requirement, BaseScore,MULScore,PREScore,MDISC,",
                      "     BeforeDay,AfterDay,BeginDate,EndDate,LBTime,LETime,FixedDate,Week,CNFFLG)=",
                      "     (SELECT lth06,lth07,lth08,lth09,lth10,",
                      "     lth11,lth12,",cl_tp_tochar("lth15",'YYYYMMDD'),",",cl_tp_tochar("lth16",'YYYYMMDD'),
                      "     ,lth17[1,2]||lth17[4,5]||lth17[7,8],lth18[1,2]||lth18[4,5]||lth18[7,8],lth19,lth20,lthacti"
   END IF
   LET g_sql = g_sql,"         FROM ",cl_get_target_table(g_azw01,'lth_file'),",",
                                      cl_get_target_table(g_azw01,'lrp_file'),",",
                                      cl_get_target_table(g_azw01,'lso_file'),
                     "        WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04 ",
                     "          AND lth02 = CTNO AND lth05 = MemorialNO ",
                     "          AND lrp01=lth02  AND lrp00=lth01 AND lrp00 IN ('1','2')",
                     "          AND lrp04 = lth03 AND lrp05 = lth04 AND lrpplant = lthplant ",
                     "          AND CAST(lth01 AS NUMBER(5,2)) = RuleType ",
                     "          AND ",cl_tp_tochar("lth03",'YYYYMMDD')," = LBDate ",
                     "          AND ",cl_tp_tochar("lth04",'YYYYMMDD')," = LEDate ",
                     "          AND Condition2 ='",g_azw05,"'||lthplant) ",
                     " WHERE EXISTS (SELECT 1 FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                                                     cl_get_target_table(g_azw01,'lth_file'),",",
                                                     cl_get_target_table(g_azw01,'lso_file'),
                     "                WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04 ",
                     "                  AND lrp01=lth02  AND lrp00=lth01 AND lrp04 = lth03 AND lrp05 = lth04 AND lrpplant = lthplant ",
                     "                  AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y'  ",
                     "                  AND lthplant IN ",g_all_plant,
                     "                  AND ",g_wc CLIPPED," AND Condition2 ='",g_azw05,"'||lthplant ",
                     "                  AND lth02 = CTNO AND lth05 = MemorialNO ",
                     "                  AND CAST(lth01 AS NUMBER(5,2)) = RuleType ",
                     "                  AND ",cl_tp_tochar("lth03",'YYYYMMDD')," = LBDate ",
                     "                  AND ",cl_tp_tochar("lth04",'YYYYMMDD')," = LEDate)"
   CALL p100_postable_upd(g_sql,'N')
   IF g_success = 'N' THEN RETURN END IF
   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tf_CardType_Rule_MDetail",g_db_links," (",
                " Condition1,Condition2, ",
                " RuleType,CTNO,MemorialNO,Requirement,",
                " BaseScore,MULScore,PREScore,MDISC,",
                " BeforeDay,AfterDay,BeginDate,EndDate,LBTime,LETime,FixedDate,Week,LBDate,LEDate,CNFFLG)",     #FUN-C80079
                " SELECT DISTINCT '",g_trans_no,"','",g_azw05,"'||lthplant, ",
                "        lth01,lth02,lth05,lth06, lth07,lth08,lth09,lth10,",
                "        lth11,lth12,",cl_tp_tochar("lth15",'YYYYMMDD'),",",cl_tp_tochar("lth16",'YYYYMMDD'),   #FUN-C80079
                "       ,lth17[1,2]||lth17[4,5]||lth17[7,8],lth18[1,2]||lth18[4,5]||lth18[7,8],lth19,lth20,",
                         cl_tp_tochar("lth03",'YYYYMMDD'),",",cl_tp_tochar("lth04",'YYYYMMDD'),",lthacti",
                "   FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                           cl_get_target_table(g_azw01,'lth_file'),",",
                           cl_get_target_table(g_azw01,'lso_file'),
                "  WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant  AND lrpplant = lso04",
                "    AND lrp01=lth02  AND lrp00=lth01 AND lrp04 = lth03 AND lrp05 = lth04 AND lrpplant = lthplant ",
                "    AND lrp00 IN ('1','2') AND lrpconf = 'Y' AND lrp09 = 'Y'  ",
                "    AND lthplant IN ",g_all_plant,
                "    AND ",g_wc CLIPPED,       
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tf_CardType_Rule_MDetail",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"'||lthplant AND CAST(lth01 AS NUMBER(5,2)) = RuleType",
                "                       AND lth02 = CTNO AND lth05 = MemorialNO  ",
                "                       AND ",cl_tp_tochar("lth03",'YYYYMMDD')," = LBDate ",
                "                       AND ",cl_tp_tochar("lth04",'YYYYMMDD')," = LEDate )"
   CALL p100_postable_ins(g_sql,'N')  
   IF g_success = 'N' THEN RETURN END IF 
   
END FUNCTION 

#FUN-CB0007----------------add-------------str
FUNCTION  p100_down_405()     #会员等级资料
     LET g_ryk03 = "tf_Member_Grade"
  #更新单位资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有会员等级的资料
   LET g_sql = " UPDATE ",g_posdbs,"tf_Member_Grade",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,GradeNO,GradeName,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',lpc01,lpc02,lpcacti"
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (GradeNO,GradeName,CNFFLG) = ",
               "        (SELECT lpc01,lpc02,lpcacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'lpc_file'),
              #"          WHERE Condition2 ='",g_azw05,"' AND GradeNO = lpc01 AND lpc00 = '6')",                                  #FUN-D40064 Mark
               "          WHERE Condition2 ='",g_azw05,"' AND GradeNO = lpc01 AND lpc00 = '6' AND lpc02 IS NOT NULL)",            #FUN-D40064 Add
               "  WHERE Condition2||GradeNO IN (SELECT '",g_azw05,"'||lpc01 FROM ",cl_get_target_table(g_azw01,'lpc_file'),
              #"                              WHERE GradeNO = lpc01 AND lpc00 = '6' AND ",g_wc CLIPPED,")"                        #FUN-D40064 Mark
               "                              WHERE GradeNO = lpc01 AND lpc02 IS NOT NULL AND lpc00 = '6' AND ",g_wc CLIPPED,")"  #FUN-D40064 Add
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tf_Member_Grade",g_db_links," (",
                " Condition1,Condition2, ",
                " GradeNO,GradeName,CNFFLG )",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        lpc01,lpc02,lpcacti",
                "   FROM ",cl_get_target_table(g_azw01,'lpc_file'),
                "  WHERE lpc00 = '6' AND ",g_wc CLIPPED,
                "    AND lpc02 IS NOT NULL",         #FUN-D40064 Add
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tf_Member_Grade",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND GradeNO = lpc01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：每一个没一个门店写一笔请求表，WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tf_Member_Grade',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tf_Member_Grade',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

FUNCTION  p100_down_406()     #会员类型资料
     LET g_ryk03 = "tf_Member_Type"
  #更新单位资料，异动下传UPDATE已传POS否为1/2的资料，初始化下传更新所有会员等级的资料
   LET g_sql = " UPDATE ",g_posdbs,"tf_Member_Type",g_db_links
   IF g_posway ='1' THEN
      LET g_sql = g_sql CLIPPED,
               "    SET (Condition1,TypeNO,TypeName,CNFFLG) = ",
               "        (SELECT '",g_trans_no,"',lpc01,lpc02,lpcacti"
   ELSE
      LET g_sql = g_sql CLIPPED,
               "    SET (TypeNO,TypeName,CNFFLG) = ",
               "        (SELECT lpc01,lpc02,lpcacti "
   END IF
   LET g_sql = g_sql CLIPPED,
               "           FROM ",cl_get_target_table(g_azw01,'lpc_file'),
              #"          WHERE Condition2 ='",g_azw05,"' AND TypeNO = lpc01 AND lpc00 = '7')",                                   #FUN-D40064 Mark
               "          WHERE Condition2 ='",g_azw05,"' AND TypeNO = lpc01 AND lpc00 = '7' AND lpc02 IS NOT NULL)",             #FUN-D40064 Add
               "  WHERE Condition2||TypeNO IN (SELECT '",g_azw05,"'||lpc01 FROM ",cl_get_target_table(g_azw01,'lpc_file'),
              #"                                WHERE TypeNO = lpc01 AND lpc00 = '7' AND ",g_wc CLIPPED,")"                       #FUN-D40064 Mark
               "                                WHERE TypeNO = lpc01 AND lpc02 IS NOT NULL AND lpc00 = '7' AND ",g_wc CLIPPED,")" #FUN-D40064 Add
    CALL p100_postable_upd(g_sql,'Y')
    IF g_success = 'N' THEN RETURN END IF

   #INSERT中间库不存在的资料，条件同UPDATE，排除中间库已有的资料
    LET g_sql = " INSERT INTO ",g_posdbs,"tf_Member_Type",g_db_links," (",
                " Condition1,Condition2, ",
                " TypeNO,TypeName,CNFFLG )",
                " SELECT '",g_trans_no,"','",g_azw05,"', ",
                "        lpc01,lpc02,lpcacti",
                "   FROM ",cl_get_target_table(g_azw01,'lpc_file'),
                "  WHERE lpc00 = '7' AND ",g_wc CLIPPED,
                "    AND lpc02 IS NOT NULL ",     #FUN-D40064 Add 
                "    AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"tf_Member_Type",g_db_links,
                "                     WHERE Condition2 ='",g_azw05,"' AND TypeNO = lpc01 )"
   CALL p100_postable_ins(g_sql,'Y')
   IF g_success = 'N' THEN RETURN END IF

  #写请求表：每一个没一个门店写一笔请求表，WHERE条件初始化时为Condition2=当前DB，异动下传为Condition1=当前传输单号
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF g_posway ='2' THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tf_Member_Type',' Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tf_Member_Type',' Condition1 = '||''''||'",g_trans_no,"'||''''||' AND Condition2 = '||''''||'",g_azw05,"'||'''','D' "
   END IF
   LET g_sql = g_sql CLIPPED,
               "   FROM azw_temp",
               "  WHERE azw05 = '",g_azw05,"' AND azw01 IN ",g_all_plant CLIPPED
   CALL p100_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION

#FUN-CB0007----------------add-------------end
FUNCTION p100_postable_ins(p_sql,p_y)     #INSERT 中间库、INSERT possac
DEFINE p_sql   STRING
DEFINE p_y      LIKE type_file.chr1            #主表否

 IF g_success = 'N' OR g_flag = 'N' THEN RETURN END IF      #如果标示为N或者主表没有数据 则不执行子表
 IF p_y = 'N' AND g_down_n = 0 THEN RETURN END IF

 IF g_bgjob = "N" THEN
    MESSAGE g_ryk01,"(",g_ryk03,"):",g_azw05,":INSERT BEGIN:",TIME(CURRENT)
    CALL ui.Interface.refresh()
 END IF
 TRY
   CALL cl_replace_sqldb(p_sql) RETURNING p_sql 
   #CALL cl_parse_qry_sql(p_sql,p_azw01) RETURNING p_sql # 此處多個營運中心處理資料 暫不用 
   PREPARE ins_pos_pre FROM p_sql
   EXECUTE ins_pos_pre 
   CATCH
     IF SQLCA.sqlcode THEN
        DISPLAY "ERROR SQL : ", p_sql    
        LET g_success='N'
        LET g_errno = SQLCA.sqlcode  
       #CALL s_errmsg('ryk01',g_ryk03,g_azw05,SQLCA.sqlcode,1) 
        LET g_msg  = g_ryk01,"/",g_ryk03
        LET g_msg1 = g_azw05,":INSERT INTO ",g_ryk03," ERROR:"
        CALL s_errmsg('ryk01,ryk03',g_msg,g_msg1,SQLCA.sqlcode,1) 
        LET g_msg1="ryk01:",g_ryk01,"(",g_ryk04,"),DB:",g_azw05,",INS ",g_ryk03,"! DOWN_ERROR" 
        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
     END IF
     IF g_bgjob = "N" THEN                   
        MESSAGE "failure to Down"
        CALL ui.Interface.refresh()
     END IF                                  
     RETURN
   END TRY
   IF SQLCA.sqlerrd[3] >= 0  THEN
      LET g_down_n = g_down_n + SQLCA.sqlerrd[3]
   END IF
END FUNCTION 

FUNCTION  p100_process_chk() #判斷進程 
DEFINE l_ch_pipe    base.Channel
DEFINE l_n   LIKE type_file.num5  
DEFINE l_ch_cmd     STRING            

   LET l_n =0
   LET l_ch_cmd = "ps -ef | grep 'apcp100'| grep fglrun-bin | grep -v p_cron | grep -v ",g_pid," | grep -v r.d2+ | grep 42r | grep -v fgldeb | grep -v p_cron | wc -l "  
   LET l_ch_pipe =  base.Channel.create() 
   CALL l_ch_pipe.openPipe(l_ch_cmd, "r")
   WHILE l_ch_pipe.read(l_n)
   END WHILE
   CALL l_ch_pipe.close()
   IF l_n=0 THEN  #沒有進程在跑APCP100
      LET l_ch_cmd = "ps -ef | grep 'apcp101'| grep fglrun-bin | grep -v ",g_pid," | grep -v r.d2+ | grep 42r | grep -v fgldeb | grep -v p_cron | wc -l "  
      LET l_ch_pipe =  base.Channel.create() LET l_ch_pipe =  base.Channel.create()
      CALL l_ch_pipe.openPipe(l_ch_cmd, "r")
      WHILE l_ch_pipe.read(l_n)
      END WHILE
      CALL l_ch_pipe.close()
   END IF
   IF l_n=0 THEN  #沒有進程在跑
   ELSE           #有進程在跑
      IF g_bgjob='N' THEN
	     CALL cl_err('','-263',1)
      END IF
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
END FUNCTION 

FUNCTION p100_dblinks(l_db_links)  
DEFINE l_db_links LIKE ryg_file.ryg02
  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
END FUNCTION

FUNCTION p100_trans_no()
 DEFINE l_doc  LIKE type_file.chr9
 DEFINE l_doc1 LIKE type_file.chr7
 DEFINE l_no   LIKE type_file.num10
 DEFINE l_time LIKE type_file.chr30

  #LET l_doc = "D",YEAR(g_today) USING "&&&&",MONTH(g_today) USING "&&",DAY(g_today) USING "&&"
  #LET g_sql = " SELECT MAX(ryy01[10,17])+1 FROM ryy_file WHERE ryy01 LIKE '",l_doc,"%' "  
  #PREPARE trans_no_pre FROM g_sql
  #EXECUTE trans_no_pre INTO l_no
  #IF SQLCA.sqlcode THEN  LET g_success='N'  CALL s_errmsg('trans_no',"",l_doc,SQLCA.sqlcode,1) END IF
  #IF cl_null(l_no) THEN LET l_no = 1 END IF
  #LET l_doc1 = l_no USING "&&&&&&&"
  #LET g_ryy.ryy01 = l_doc CLIPPED,l_doc1 CLIPPED

   LET l_time =CURRENT YEAR TO FRACTION(4)
   LET l_time = l_time[1,4],l_time[6,7],l_time[9,10],l_time[12,13],l_time[15,16],l_time[18,19],l_time[21,23]
   LET g_ryy.ryy01 = "D",l_time CLIPPED
   RETURN g_ryy.ryy01
END FUNCTION

FUNCTION p100_getplant(p_azw05)  #获取要下传的所有营运中心
DEFINE  p_azw05  LIKE   azw_file.azw05 
DEFINE  l_wc     STRING #LIKE   type_file.chr1000
DEFINE  sr    RECORD
          azw01  LIKE azw_file.azw01,
	      ryg00  LIKE ryg_file.ryg00,
	      ryg02  LIKE ryg_file.ryg02
        END   RECORD
         
        IF NOT cl_null(g_plantstr) THEN
           LET l_wc  = "('",cl_replace_str(g_plantstr,"|","','"),"')"
        END IF

        LET g_all_plant = "("
        LET g_sql = " SELECT azw01,ryg00,ryg02 FROM azw_temp ",       #下传的TIPTOP营运中心
                    " WHERE  azw05 = '",p_azw05,"' "
        IF g_posway ='2' THEN
           LET g_sql = g_sql CLIPPED,
                    "    AND azw01 IN ",l_wc CLIPPED
        END IF
        LET g_sql = g_sql CLIPPED,
                    " ORDER BY azw01 "
        PREPARE sel_azw01_pre1 FROM g_sql
        DECLARE sel_azw01_cur1 CURSOR WITH HOLD FOR  sel_azw01_pre1
        FOREACH  sel_azw01_cur1 INTO sr.*
           IF SQLCA.sqlcode THEN  LET g_success='N' CALL s_errmsg('azw01','','sel_azw01_cur1',SQLCA.sqlcode,1) END IF
	       LET g_all_plant = g_all_plant CLIPPED,"'",sr.azw01,"',"
        END FOREACH 
        LET g_all_plant = g_all_plant.substring(1,LENGTH(g_all_plant)-1) CLIPPED,")"
        LET g_azw01 = sr.azw01
        LET g_posdbs = s_dbstring(sr.ryg00)
        LET g_db_links = p100_dblinks(sr.ryg02)

        IF g_posway ='2' THEN
           LET g_all_plant1 = "("
           FOREACH  sel_azw01_cur USING p_azw05 INTO sr.*
              IF SQLCA.sqlcode THEN  LET g_success='N' CALL s_errmsg('azw01','','sel_azw01_cur',SQLCA.sqlcode,1) END IF
              LET g_all_plant1 = g_all_plant1 CLIPPED,"'",sr.azw01,"',"
           END FOREACH
           LET g_all_plant1 = g_all_plant1.substring(1,LENGTH(g_all_plant1)-1) CLIPPED,")"
        ELSE
           LET g_all_plant1 = g_all_plant
        END IF
        CALL p100_cretemp()           #增加临时表加强效能
END FUNCTION

FUNCTION p100_g_wc(p_ryk02,p_type)               #定义资料范围主要字段xxxpos、xxxplant 
DEFINE p_type  LIKE type_file.chr1               #判断是UPDATE/LOCK/INSERT/UPDATE/ -----1.确定下传范围/2.锁定/3下传/4回写
DEFINE p_ryk02 LIKE ryk_file.ryk02
DEFINE l_gaq01 LIKE gaq_file.gaq01
DEFINE l_str   STRING
DEFINE l_n     LIKE type_file.num5
DEFINE l_wc    STRING
   
   LET l_wc = " 1=1 "
   IF p_type = '3' AND g_flag ='N' THEN RETURN l_wc END IF           #主表无资料 
   IF p_ryk02 = 'rab_file' THEN LET p_ryk02 = 'rac_file' END IF
   LET l_str   = p_ryk02
   LET l_str   = l_str.toLowerCase()
   IF l_str <> "rta" THEN                                    
      LET l_gaq01 = l_str.substring(1,3),"pos"                          #定义字段名xxxpos(下传标示) 
      SELECT COUNT(*) INTO l_n FROM gaq_file  WHERE gaq01 = l_gaq01
      IF l_n > 0 THEN  
         LET g_pos_fld = l_gaq01
      ELSE 
         LET g_pos_fld = ''
      END IF
   ELSE
      LET g_pos_fld = ''                                    
   END IF
 
  #LET l_gaq01 = l_str.substring(1,3),"plant"                         #定义字段xxxplant
  #SELECT COUNT(*) INTO l_n FROM gaq_file
  # WHERE gaq01 = l_gaq01
  #IF l_n > 0 THEN
  #   LET g_plant_fld = l_gaq01
  #ELSE 
  #   LET g_plant_fld = ''
  #END IF

   IF NOT cl_null(g_pos_fld) AND g_posway = '1'  THEN                     #下传方式：一般下传的条件 ，初始化不限定
      IF p_type = '1' THEN 
         LET l_wc = l_wc CLIPPED," AND ",g_pos_fld," IN ('1','2')"        #更新范围条件
      ELSE                                                                #锁定、下传、回写条件
         IF  g_lock_flag = 'Y' THEN 
            LET l_wc = l_wc CLIPPED," AND ",g_pos_fld CLIPPED,"  ='5' " 
	     ELSE
	        LET l_wc = l_wc CLIPPED," AND ",g_pos_fld CLIPPED," IN ('1','2') "
	     END IF    
      END IF
   END IF
   
   RETURN l_wc
END FUNCTION

FUNCTION p100_postable_upd(p_sql,p_y)
DEFINE p_sql   STRING
DEFINE p_y      LIKE type_file.chr1            #主表否

 IF g_success = 'N' OR g_flag = 'N' THEN RETURN END IF      #如果标示为N或者主表没有数据 则不执行子表
 IF p_y = 'N' AND g_down_n = 0 THEN RETURN END IF

 IF g_bgjob = "N" THEN
    MESSAGE g_ryk01,"(",g_ryk03,"):",g_azw05,":UPDATE BEGIN:",TIME(CURRENT)
    CALL ui.Interface.refresh()
 END IF

 TRY
   CALL cl_replace_sqldb(p_sql) RETURNING p_sql 
  #CALL cl_parse_qry_sql(p_sql,g_azw01) RETURNING p_sql
   PREPARE upd_pos_pre1 FROM p_sql
   EXECUTE upd_pos_pre1 
   CATCH
     IF SQLCA.sqlcode THEN
        DISPLAY "ERROR SQL : ", p_sql    
        LET g_success='N'
        LET g_errno = SQLCA.sqlcode  
       #CALL s_errmsg('ryk01',g_ryk03,g_azw05,SQLCA.sqlcode,1) 
        LET g_msg  = g_ryk01,"/",g_ryk03
        LET g_msg1 = g_azw05,":UPDATE ",g_ryk03," ERROR:"
        CALL s_errmsg('ryk01,ryk03',g_msg,g_msg1,SQLCA.sqlcode,1) 
        LET g_msg1="ryk01:",g_ryk01,"(",g_ryk04,"),DB:",g_azw05,",UPD ",g_ryk03,"! DOWN_ERROR" 
        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
     END IF
     IF g_bgjob = "N" THEN                   
        MESSAGE "failure to Down"
        CALL ui.Interface.refresh()
     END IF                                  
     RETURN
   END TRY
   IF SQLCA.sqlerrd[3] >= 0  THEN
      LET g_down_n = g_down_n + SQLCA.sqlerrd[3]
   END IF

END FUNCTION

FUNCTION p100_postable_del(p_sql,p_y)
DEFINE p_sql   STRING
DEFINE p_y      LIKE type_file.chr1            #主表否

 IF g_success = 'N' OR g_flag = 'N' THEN RETURN END IF      #如果标示为N或者主表没有数据 则不执行子表
 IF p_y = 'N' AND g_down_n = 0 THEN RETURN END IF
 TRY
   CALL cl_replace_sqldb(p_sql) RETURNING p_sql 
   CALL cl_parse_qry_sql(p_sql,g_azw01) RETURNING p_sql
   PREPARE del_pos_pre FROM p_sql
   EXECUTE del_pos_pre 
   CATCH
     IF SQLCA.sqlcode THEN
        DISPLAY "ERROR SQL : ", p_sql    
        LET g_success='N'
        LET g_errno = SQLCA.sqlcode  
       #CALL s_errmsg('ryk01',g_ryk03,g_azw01,SQLCA.sqlcode,1) 
        LET g_msg  = g_ryk01,"/",g_ryk03
        LET g_msg1 = g_azw05,":DELETE ",g_ryk03," ERROR:"
        CALL s_errmsg('ryk01,ryk03',g_msg,g_msg1,SQLCA.sqlcode,1) 
        LET g_msg1="ryk01:",g_ryk01,"(",g_ryk04,"),","DOWN_ERROR" 
        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
     END IF
     IF g_bgjob = "N" THEN                   
        MESSAGE "failure to Down"
        CALL ui.Interface.refresh()
     END IF                                  
     RETURN
   END TRY
  
END FUNCTION 

FUNCTION  p100_tk_TransTaskDetail_ins(p_sql,p_y)
DEFINE p_sql   STRING
DEFINE p_y      LIKE type_file.chr1            #主表否

 IF p_y <> 'D' THEN
    IF g_down_n = 0 THEN RETURN END IF
    IF g_success = 'N' OR g_flag = 'N' THEN RETURN END IF      #如果标示为N或者主表没有数据 则不执行子表
 END IF
 IF g_bgjob = "N" THEN
    MESSAGE g_ryk01,"(",g_ryk03,"):",g_azw05,":INSERT INTO tk_TransTaskDetail  BEGIN:",TIME(CURRENT)
    CALL ui.Interface.refresh()
 END IF

 TRY
   CALL cl_replace_sqldb(p_sql) RETURNING p_sql 
  #CALL cl_parse_qry_sql(p_sql,g_azw01) RETURNING p_sql
   PREPARE ins_transtask_pre FROM p_sql
   EXECUTE ins_transtask_pre 
   CATCH
     IF SQLCA.sqlcode THEN
        DISPLAY "ERROR SQL : ", p_sql    
        LET g_success='N'
        LET g_errno = SQLCA.sqlcode  
       #CALL s_errmsg('ryk01',g_ryk03,g_azw05,SQLCA.sqlcode,1) 
        LET g_msg  = g_ryk01,"/",g_ryk03
        LET g_msg1 = g_azw05,":INS tk_TransTaskDetail ERROR:"
        CALL s_errmsg('ryk01,ryk03',g_msg,g_msg1,SQLCA.sqlcode,1) 
        LET g_msg1="ryk01:",g_ryk01,"(",g_ryk04,"),DB:",g_azw05,",INS tk_TransTaskDetail(",g_ryk03,") DOWN_ERROR" 
        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
     END IF
     IF g_bgjob = "N" THEN                   
        MESSAGE "failure to Down"
        CALL ui.Interface.refresh()
     END IF                                  
     RETURN
   END TRY
   IF SQLCA.sqlerrd[3] = 0  THEN 
      IF  p_y='Y' THEN LET g_flag = 'N' END IF
   ELSE 
      LET g_down_n = g_down_n + SQLCA.sqlerrd[3]   
   END IF

END FUNCTION

FUNCTION p100_tk_TransTaskHead_ins(p_flag)
DEFINE  l_date LIKE type_file.chr20 
DEFINE  p_flag LIKE type_file.chr1

   LET l_date = g_today USING 'YYYYMMDD' 
   IF g_success = 'N'  THEN RETURN END IF 
   IF p_flag = '1' OR p_flag = '4' THEN 
      LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskHead",g_db_links,
                  "       (TRANS_SHOP,TRANS_MACH,TASK_NO,TASK_DIRECTION,TRANS_TYPE,TRANS_FLG,TRANS_DATE,TRANS_TIME,IMPORTDATE,IMPORTTIME)", #By shi add
                  " SELECT DISTINCT a.TRANS_SHOP,' ','",g_trans_no,"' ,'D','",p_flag,"','NP','','','",l_date,"','",g_time[1,2],g_time[4,5],g_time[7,8],"'  ",
                  "   FROM ",g_posdbs,"tk_TransTaskDetail",g_db_links," a",
                  "  WHERE a.TASK_NO = '",g_trans_no,"'",
                  "    AND NOT EXISTS( SELECT 1 FROM ",g_posdbs,"tk_TransTaskHead",g_db_links," b",
                  "                     WHERE a.TRANS_SHOP = b.TRANS_SHOP AND b.TRANS_MACH = ' ' AND a.TRANS_MACH = ' ' ",
                  "                       AND a.TASK_NO = b.TASK_NO AND b.TASK_NO = '",g_trans_no,"')"
   END IF
   IF p_flag = '3' THEN
      LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskHead",g_db_links,
                  "       (TRANS_SHOP,TRANS_MACH,TASK_NO,TASK_DIRECTION,TRANS_TYPE,TRANS_FLG,TRANS_DATE,TRANS_TIME,IMPORTDATE,IMPORTTIME)", #By shi add
                  " SELECT DISTINCT a.TRANS_SHOP,' ','",g_trans_no1,"' ,'D','3','NP','','','",l_date,"','",g_time[1,2],g_time[4,5],g_time[7,8],"' ",
                  "   FROM ",g_posdbs,"tk_TransTaskDetail",g_db_links," a",
                  "  WHERE a.TASK_NO = '",g_trans_no1,"'",
                  "    AND NOT EXISTS( SELECT 1 FROM ",g_posdbs,"tk_TransTaskHead",g_db_links," b",
                  "                     WHERE a.TRANS_SHOP = b.TRANS_SHOP AND b.TRANS_MACH = ' ' AND a.TRANS_MACH = ' ' ",
                  "                       AND a.TASK_NO = b.TASK_NO AND b.TASK_NO = '",g_trans_no1,"')"


   END IF
   TRY
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
  #CALL cl_parse_qry_sql(g_sql,g_azw01) RETURNING g_sql
   PREPARE ins_transtaskhead_pre FROM g_sql
   EXECUTE ins_transtaskhead_pre 
   CATCH
     IF SQLCA.sqlcode THEN
        DISPLAY "ERROR SQL : ", g_sql    
        LET g_success='N'
        LET g_errno = SQLCA.sqlcode  
       #CALL s_errmsg('ryk01',g_ryk03,g_azw01,SQLCA.sqlcode,1) 
        LET g_msg  = g_ryk01,"/",g_ryk03
        LET g_msg1 = g_azw05,":INS tk_TransTaskHead ERROR:"
        CALL s_errmsg('ryk01,ryk03',g_msg,g_msg1,SQLCA.sqlcode,1) 
        LET g_msg1="TABLE:",g_ryk01," DB:",g_azw05," PLANT:",g_all_plant," failure!"  
        LET g_msg1="ryk01:",g_ryk01,",DB:",g_azw05,",INS tk_TransTaskHead DOWN_ERROR" 
        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
     END IF
     IF g_bgjob = "N" THEN        
        MESSAGE "failure to Down"
        CALL ui.Interface.refresh()
     END IF                                  
     RETURN
   END TRY
         
END FUNCTION

FUNCTION p100_tk_TransTaskDetail_del(p_ryk01 )
DEFINE  p_ryk01 LIKE ryk_file.ryk01
DEFINE  l_date LIKE type_file.chr20

   LET l_date = g_today USING 'YYYYMMDD'
   IF g_success = 'N'  THEN RETURN END IF 

   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION )"
   CASE  p_ryk01  
       WHEN '101'   #门店资料  
       WHEN '106'   #券种
          LET g_sql = g_sql,
               " SELECT DISTINCT lnk03,' ','",g_trans_no1,"','ta_Coupon','Condition2='||''''||'",g_azw05,"'||lpx01||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'lpx_file'),",",
                          cl_get_target_table(g_azw01,'lnk_file'),
               "  WHERE lnk01 = lpx01 AND lnk02 = '2' AND lnk05 = 'N'",
               "    AND lpx15 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED ," AND ",g_wc CLIPPED
      #FUN-CC0058 Begin---
       WHEN '1061'   #收券规则
          LET g_sql = g_sql,
               " SELECT DISTINCT lnk03,' ','",g_trans_no1,"','ta_Coupon_Rule','Condition2='||''''||'",g_azw05,"'||ltpplant||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'lpx_file'),",",
                          cl_get_target_table(g_azw01,'lnk_file'),",",
                          cl_get_target_table(g_azw01,'ltp_file'),
               "  WHERE lnk01 = lpx01 AND lnk02 = '2' AND lnk05 = 'N'",
               "    AND ltp03 = lpx01 AND ltpplant = lnk03 AND ltpconf = 'Y' AND ltp11 = 'Y' ",
               "    AND lpx15 = 'Y' AND lnk03 IN ",g_all_plant CLIPPED ," AND ",g_wc CLIPPED
      #FUN-CC0058 End-----
       WHEN '402'   #卡种
          LET g_sql = g_sql,
               " SELECT DISTINCT lnk03,' ','",g_trans_no1,"','tf_CardType','Condition2='||''''||'",g_azw05,"'||lph01||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'lnk_file'),",",
                          cl_get_target_table(g_azw01,'lph_file'),
               "  WHERE lnk01 = lph01 AND lnk02 = '1' AND lnk05 = 'N' ",
               "    AND lph24 = 'Y' AND ",g_wc CLIPPED,"  AND lnk03 IN ",g_all_plant CLIPPED
       WHEN '401'   #会员
          LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lnk03,' ','",g_trans_no1,"','tf_Member','Condition2 = '||''''||'",g_azw05,"'||lpj02||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'lpk_file'),",",
                          cl_get_target_table(g_azw01,'lpj_file'),",",
                          cl_get_target_table(g_azw01,'lph_file'),",",
                          cl_get_target_table(g_azw01,'lnk_file'),
               "  WHERE lpk01 = lpj01 AND lpj02 = lnk01 AND lnk02 = '1' AND lnk05 = 'N' ",
               "    AND lpj02 = lph01 ",
               "    AND lnk03 IN ",g_all_plant CLIPPED," AND ",g_wc CLIPPED
       WHEN '403'   #卡状态
          LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lnk03,' ','",g_trans_no1,"','tf_CardType_Status','Condition2='||''''||'",g_azw05,"'||lpj02||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'lnk_file'),",",
                          cl_get_target_table(g_azw01,'lpj_file'),",",
                          cl_get_target_table(g_azw01,'lph_file'),
               "  WHERE lnk01 = lpj02 AND lnk02 = '1' AND lnk05 = 'N' AND (lpj01 IS NOT NULL AND lpj01 <> ' ') ",
               "    AND lph01 = lpj02 ",
               "    AND ",g_wc CLIPPED,"  AND lnk03 IN ",g_all_plant CLIPPED
      #如果卡种生效门店失效，用一下做法，删除卡种对应门店的资料
       WHEN '404'   #积分规则
          LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT lnk03,' ','",g_trans_no1,"','tf_CardType_Rule','CTNO='||''''||lrp01||''''||' AND Condition2='||''''||'",g_azw05,"'||lrpplant||'''','D'",
               "   FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
                          cl_get_target_table(g_azw01,'lph_file'),",",
                          cl_get_target_table(g_azw01,'lnk_file'),
               "  WHERE lnk01 = lrp01 AND lnk02 = '1' AND lnk05 = 'N' AND lph01 = lnk01 ",
               "    AND lrp00 IN ('1','2') AND lrpplant IN ",g_all_plant CLIPPED,
               "    AND  ",g_wc CLIPPED,"  AND lnk03 IN ",g_all_plant CLIPPED

      #如果积分规则生效门店失效，参考以下做法写请求表
      #WHEN '404'   #积分规则
      #   LET g_sql = g_sql CLIPPED,
      #        " SELECT DISTINCT lso04,' ','",g_trans_no1,"','tf_CardType_Rule','CTNO='||''''||lrp01||''''||' AND Condition2='||''''||'",g_azw05,"'||lrpplant||'''','D'",
      #        "   FROM ",cl_get_target_table(g_azw01,'lrp_file'),",",
      #                   cl_get_target_table(g_azw01,'lso_file'),",",
      #                   cl_get_target_table(g_azw01,'lph_file'),
      #        "  WHERE lso02 = lrp07 AND lso03 = lrp00 AND lso01 = lrp06 AND lrpplant =lsoplant AND lrpplant = lso04",
      #        "    AND lrp00 IN ('1','2') AND lrp01 = lph01 AND lso07 = 'N'",
      #        "    AND  ",g_wc CLIPPED,"  AND lrpplant IN ",g_all_plant CLIPPED
        
       WHEN '301'   #一般促销             #根据 促销单号+ Condition2 写入WHERE条件 ,同一门店有一个促销单失效了，其它促销单不一定失效
           LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rabplant,' ','",g_trans_no1,"','te_Gen',' PromNO = '||''''||rab02||''''||' AND Condition2 = '||''''||'",g_azw05,"'||rabplant||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'rab_file'),",",
                          cl_get_target_table(g_azw01,'rac_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rab01 = raq01 AND rab02 = raq02 AND rabplant = raqplant AND raq03 = '1' ",
               "    AND rab01 = rac01 AND rab02 = rac02 AND rabplant = racplant ",
               "    AND raq04 = rabplant AND rabplant IN ",g_all_plant CLIPPED,
               "    AND rabconf ='Y' AND raq05 = 'Y' AND raqacti = 'N' AND ",g_wc CLIPPED
       WHEN '302'   #组合促销             #根据 促销单号+ Condition2 写入WHERE条件 ,同一门店有一个促销单失效了，其它促销单不一定失效
           LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT raeplant,' ','",g_trans_no1,"','te_Comb',' PromNO = '||''''||rae02||''''||' AND Condition2 = '||''''||'",g_azw05,"'||raeplant||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'rae_file'),",", 
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rae01 = raq01 AND rae02 = raq02 AND raeplant = raqplant AND raq03 = '2'", 
               "    AND raeplant IN ",g_all_plant CLIPPED," AND raq04 = raeplant ",
               "    AND raeconf = 'Y' AND raq05 = 'Y' AND raqacti = 'N' AND ",g_wc CLIPPED
       WHEN '303'   #满额促销             #根据 促销单号+ Condition2 写入WHERE条件 ,同一门店有一个促销单失效了，其它促销单不一定失效
           LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rahplant,' ','",g_trans_no1,"','te_Full',' PromNO = '||''''||rah02||''''||' AND Condition2 = '||''''||'",g_azw05,"'||rahplant||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'rah_file'),",",
                          cl_get_target_table(g_azw01,'raq_file'),
               "  WHERE rah01 = raq01 AND rah02 = raq02 AND rahplant = raqplant AND raq03 = '3' ",
               "    AND rahplant IN ",g_all_plant CLIPPED," AND raq04 = rahplant ",
               "    AND rahconf = 'Y' AND raq05 = 'Y' AND raqacti = 'N' AND ",g_wc CLIPPED
      #FUN-D30093--add--str---
       WHEN '207'   #觸屏分類
           LET g_sql = g_sql CLIPPED,
               " SELECT DISTINCT rzl02,' ','",g_trans_no1,"','tb_Class','Condition2='||''''||'",g_azw05,"'||rzj01||'''','D' ",
               "   FROM ",cl_get_target_table(g_azw01,'rzj_file'),",",
                          cl_get_target_table(g_azw01,'rzi_file'),",",
                          cl_get_target_table(g_azw01,'rzl_file'),
               "  WHERE rzj01 = rzl01 AND rzj01=rzi01 AND (rziacti = 'N' OR rzlacti = 'N' OR rzi09 <> '",g_rcj13,"') ",
               "    AND ",g_wc CLIPPED,"  AND rzl02 IN ",g_all_plant CLIPPED
      #FUN-D30093--add--end---
   END CASE
   CALL p100_tk_TransTaskDetail_ins(g_sql,'D')

END FUNCTION

FUNCTION p100_cretemp()
  DROP TABLE rtz_temp
  SELECT rtz04,rtz05 FROM rtz_file WHERE 1=0 INTO TEMP rtz_temp

  LET g_sql = " INSERT INTO rtz_temp ",
              " SELECT DISTINCT rtz04,rtz05 FROM rtz_file  WHERE rtz01 IN ", g_all_plant1 CLIPPED
  IF g_posway ='2' THEN LET g_sql = g_sql CLIPPED," AND rtz04 IN  (SELECT rtz04 FROM rtz_file WHERE rtz01 IN ", g_all_plant CLIPPED,")" END IF
  PREPARE ins_rtz_pre FROM g_sql
  EXECUTE ins_rtz_pre
  IF SQLCA.SQLCODE THEN LET g_success ='N' END IF 
END FUNCTION
#FUN-C50017
