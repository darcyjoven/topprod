# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_asfi511_s.4gl
# Descriptions...: 依工单发料作业
# Date & Author..: 20170510   by nihuan

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
            

FUNCTION aws_asfi511_s()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_asfi511_s_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序

 
END FUNCTION

FUNCTION aws_asfi511_s_process()
   DEFINE l_sql,l_sql1,l_sql2,l_sql3,l_sql4       STRING
   DEFINE l_sfb01     LIKE sfb_file.sfb01
   DEFINE l_sfb81     LIKE sfb_file.sfb81
   DEFINE l_num1      LIKE type_file.num5
   DEFINE l_sum       LIKE sfa_file.sfa05
   DEFINE li_result   LIKE type_file.num5 
   DEFINE li_step   LIKE type_file.num5
   DEFINE l_sfp    RECORD LIKE sfp_file.*
   DEFINE l_sfq    RECORD LIKE sfq_file.*
   DEFINE l_sfs    RECORD LIKE sfs_file.*
   DEFINE l_sfa    RECORD LIKE sfa_file.*
   DEFINE l_cnt0,l_cnt1,l_i LIKE sfs_file.sfs02
   DEFINE l_node1  om.DomNode
   DEFINE l_sfs01 LIKE sfs_file.sfs01
   DEFINE l_sfs03 LIKE sfs_file.sfs03
   DEFINE l_sfa06    LIKE sfa_file.sfa06
   DEFINE l_sfa05    LIKE sfa_file.sfa05
   DEFINE l_ima06 LIKE ima_file.ima06
   DEFINE l_flag  LIKE type_file.chr1 
   DEFINE l_factor   LIKE type_file.num26_10
   DEFINE l_ima25    LIKE ima_file.ima25
   DEFINE l_doc_no       LIKE sfq_file.sfq02        #来源单号退料单
   DEFINE l_qty          LIKE sfq_file.sfq03
   DEFINE l_sfs06    LIKE sfs_file.sfs06
   DEFINE l_sfa03    LIKE sfa_file.sfa03,
          l_sfa30    LIKE sfa_file.sfa30,
          l_sfa31    LIKE sfa_file.sfa31,
          l_n,l_cnt11      LIKE type_file.num5
   DEFINE l_sfs02    LIKE sfs_file.sfs02
   #----單頭
   WHENEVER ERROR CONTINUE  
   
   INITIALIZE l_sfp.* TO NULL
   INITIALIZE l_sfs.* TO NULL
   INITIALIZE l_sfq.* TO NULL
   CALL aws_asfi511_s_temp_table()


   BEGIN WORK   
   
   LET l_sfp.sfp02 = g_today
   LET l_sfp.sfp03 = g_today
#   LET l_sfp.sfpud06=l_doc_no
   
   
   SELECT smyslip INTO l_sfp.sfp01 FROM smy_file
   WHERE smy72='1' AND smykind='3' AND smysys='asf'	
   
   CALL s_auto_assign_no("asf",l_sfp.sfp01,l_sfp.sfp02,"","sfp_file","sfp01","","","")
        RETURNING li_result,l_sfp.sfp01                               #发料单单号
   IF (NOT li_result) THEN
      LET g_status.code = "-1"
      LET g_status.description = "单号产生有误,请检查!"
   	  ROLLBACK WORK
      RETURN ''
   END IF
   LET l_sfp.sfp04 = 'N'              #扣账码
   LET l_sfp.sfp05 = 'N'              #打印码
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
   
#   ###新版本增加字段
#   LET l_sfp.sfpplant = g_plant
#   LET l_sfp.sfplegal = g_legal
#   LET l_sfp.sfpmksg = 'N'
#   LET l_sfp.sfp15 = '0'
#   ###
   
   INSERT INTO sfp_file VALUES (l_sfp.*)
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN ''
   END IF
    
   LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

   IF l_cnt1 = 0 THEN
      LET g_status.code = "-1"
      LET g_status.description = "No recordset processed!"
      RETURN 
   END IF

   FOR l_i = 1 TO l_cnt1
       LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點                        
  
       LET l_doc_no = aws_ttsrv_getRecordField(l_node1,"doc_no")          #传入工单号
       LET l_qty    = aws_ttsrv_getRecordField(l_node1,"qty")             #传入数量
       
       SELECT trim(l_doc_no) INTO l_doc_no FROM dual 
       SELECT trim(l_qty)    INTO l_qty FROM dual    
       
       IF cl_null(l_doc_no) THEN 
          LET g_status.code = -1
          LET g_status.description="工单号不可为空!"
          RETURN ''
       END IF 
       
       IF cl_null(l_qty) THEN 
          LET g_status.code = -1
          LET g_status.description="数量不可为空!"
          RETURN ''
       END IF 
                 
   LET l_sql2="select * from sfa_file 
               where sfa01='",l_doc_no,"' "
   
   PREPARE sel_gls_pre2 FROM l_sql2
   DECLARE gls_curs2 CURSOR FOR sel_gls_pre2
   
   FOREACH gls_curs2 INTO l_sfa.*
           LET l_sfs.sfs01 = l_sfp.sfp01         #发料单号
#                SELECT DISTINCT sfe01 INTO l_sfs.sfs03 FROM sfe_file WHERE sfe02=l_gls_af.gls_af07
#                  #工单单号
           LET l_sfs.sfs03 = l_doc_no
           LET l_sfs.sfs04 = l_sfa.sfa03   #发料料号
       
           SELECT sfa26,sfa27,sfa28,sfa12,sfa08
           INTO l_sfs.sfs26,l_sfs.sfs27,l_sfs.sfs28,l_sfs.sfs06,l_sfs.sfs10
                  FROM sfa_file
                 WHERE sfa01 = l_sfs.sfs03
                   AND sfa03 = l_sfs.sfs04
           LET l_sfs.sfs26 = l_sfa.sfa26 
           LET l_sfs.sfs27 = l_sfa.sfa27 
           LET l_sfs.sfs28 = l_sfa.sfa28 
           LET l_sfs.sfs06 = l_sfa.sfa12 
           LET l_sfs.sfs10 = l_sfa.sfa08 
                  
           IF l_sfs.sfs10 IS NULL THEN LET l_sfs.sfs10 = ' ' END IF
                
           LET l_sfs.sfsplant = g_plant
           LET l_sfs.sfslegal = g_legal
           LET l_sfs.sfs012 = ' '
           LET l_sfs.sfs013 = 0
           SELECT MAX(sfs02)+1 INTO l_sfs.sfs02 FROM sfs_file WHERE sfs01 = l_sfs.sfs01 #ERP中的项次
           IF cl_null(l_sfs.sfs02) THEN 
   	          LET l_sfs.sfs02 = 1
           END IF 
           LET l_sfs.sfs014 = ' '              #RUNCARD

           LET l_sfs.sfsud02 = l_sfa.sfa30   
           SELECT tc_aec01 INTO l_sfs.sfs07 FROM tc_aec_file WHERE tc_aec03 =l_sfa.sfa08
           IF cl_null(l_sfs.sfs07) THEN 
              LET l_sfs.sfs07 = 'XBC'
           END IF 
           CALL i511_s_chk_ima64(l_sfs.sfs04, l_sfs.sfs05) RETURNING l_sfs.sfsud07
           
           SELECT ecd07 INTO l_sfs.sfs08 FROM ecd_file WHERE ecd01=l_sfa.sfa08


           LET l_sfs.sfs31 = l_sfa.sfa13 #转换率
           IF cl_null(l_sfs.sfs08) THEN LET l_sfs.sfs08 = ' ' END IF
           IF cl_null(l_sfs.sfs09) THEN LET l_sfs.sfs09 = ' ' END IF
           LET l_sfs.sfs05 = l_qty*l_sfa.sfa161 #数量
               
           INSERT INTO sfs_file VALUES (l_sfs.*)
           IF STATUS THEN
              LET g_status.code = -1
              LET g_status.description="产生sfs_file有错误!"
              ROLLBACK WORK
              RETURN  ''
           END IF
   END FOREACH

#插入sfq_file
        INITIALIZE l_sfq.* TO NULL
        LET l_sfq.sfq01 = l_sfp.sfp01
        LET l_sfq.sfq02 = l_doc_no
        LET l_sfq.sfq04 = ' '
        LET l_sfq.sfq03 = l_qty 
        LET l_sfq.sfq05 = g_today
        LET l_sfq.sfq06 = 0
        
        INSERT INTO sfq_file VALUES (l_sfq.*)
        IF SQLCA.SQLCODE THEN
        	  LET g_success = 'N'
        	  LET g_status.code = "-1"
            LET g_status.description = "插入sfq_file时出错！"
            ROLLBACK WORK
        	  RETURN ''
        END IF
#  
   END FOR 

   LET g_prog='asfi510'
   CALL i501sub_s("1",l_sfp.sfp01,TRUE,'N') #过账
   LET g_prog='aws_ttsrv2'
   IF g_success = 'N' THEN 
       LET g_status.code = '-1' 
       LET g_status.description = '发料单过账失败'
       ROLLBACK WORK
       RETURN ''
   END IF

   IF STATUS THEN  
      LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="产生sfp_file有错误!"
      ROLLBACK WORK 
      RETURN ''
   END IF
    COMMIT WORK
    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_sfp))

END FUNCTION
	
                                              
                     
FUNCTION aws_asfi511_s_temp_table()
DEFINE l_sql    STRING 
 DROP TABLE asfi511_s_tmp
    LET l_sql ="CREATE GLOBAL TEMPORARY TABLE asfi511_s_tmp AS SELECT * FROM sfs_file WHERE 1=0"
    PREPARE work_tab FROM l_sql
    EXECUTE work_tab 
END FUNCTION

FUNCTION i511_s_chk_ima64(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE ima_file.ima641   #No.FUN-680121 DEC(15,3)
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10   #No.FUN-680121 INTEGER
 
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641 FROM ima_file
   WHERE ima01=p_part
  IF STATUS THEN RETURN p_qty END IF
 
  IF l_ima108='Y' THEN RETURN p_qty END IF
 
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF
 
  IF l_ima64<>0 THEN
#     IF g_sfp.sfp06 ='6' THEN    #CHI-C90017 add
#        LET i=p_qty / l_ima64
#     ELSE                        #CHI-C90017 add
        LET i=p_qty / l_ima64 + 0.999999
#     END IF                      #CHI-C90017 add
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty
 
END FUNCTION
