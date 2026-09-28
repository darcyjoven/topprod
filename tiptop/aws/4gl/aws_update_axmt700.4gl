# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#                  aws_update_axmt700
# Descriptions...: 销退单提交
# Date & Author..: 2017-06-15   by   nihuan 


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"



GLOBALS
DEFINE g_oha01     LIKE oha_file.oha01      
END GLOBALS

FUNCTION aws_update_axmt700()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_update_axmt700_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE axmt700_file
     DROP TABLE axmt700_temp
END FUNCTION

FUNCTION aws_update_axmt700_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10,
           l_k        LIKE type_file.num10
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10,
           l_cnt3     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode,
           l_node3    om.DomNode
   DEFINE l_axmt700_file      RECORD                        #单身
                    ohb01      LIKE ohb_file.ohb01,         #单号
                    ohb09      LIKE ohb_file.ohb09,         #仓库
                    ohb091     LIKE ohb_file.ohb091,        #库位
                    ohb092     LIKE ohb_file.ohb092,        #批次
                    ibb01      LIKE ibb_file.ibb01,         #条码
                    ohb04      LIKE ohb_file.ohb04,         #料件编码
                    ohb12      LIKE ohb_file.ohb12          #数量
                 END RECORD
   DROP TABLE axmt700_file

   CREATE TEMP TABLE axmt700_file(
                    ohb01      LIKE ohb_file.ohb01,         #单号
                    ohb09      LIKE ohb_file.ohb09,         #仓库
                    ohb091     LIKE ohb_file.ohb091,        #库位
                    ohb092     LIKE ohb_file.ohb092,        #批次
                    ibb01      LIKE ibb_file.ibb01,         #条码
                    ohb04      LIKE ohb_file.ohb04,         #料件编码
                    ohb12      LIKE ohb_file.ohb12)         #数量             
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'

    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET g_success='N'
       RETURN
    END IF

    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET l_axmt700_file.ohb01  = aws_ttsrv_getRecordField(l_node1,"oha01")    #销退单号
        LET g_oha01 = l_axmt700_file.ohb01
        LET l_axmt700_file.ohb09  = aws_ttsrv_getRecordField(l_node1,"ohb09")
        LET l_axmt700_file.ohb091 = aws_ttsrv_getRecordField(l_node1,"ohb091")
        LET l_axmt700_file.ohb092 = aws_ttsrv_getRecordField(l_node1,"ohb092")
        LET l_axmt700_file.ibb01  = aws_ttsrv_getRecordField(l_node1,"ibb01")
        LET l_axmt700_file.ohb04  = aws_ttsrv_getRecordField(l_node1,"ohb04")
        LET l_axmt700_file.ohb12  = aws_ttsrv_getRecordField(l_node1,"ohb12")
        INSERT INTO axmt700_file VALUES (l_axmt700_file.*)
    END FOR
    IF g_success = 'Y' THEN 
       CALL t700_load()
#       IF g_success = 'Y' THEN
#         
#       ELSE
#       	  IF g_status.code='0' THEN
#            LET g_status.code = "-1"
#            LET g_status.description = "接口程序存在错误，请程序员检查，谢谢!"
#          END IF
#       END IF
    END IF
END FUNCTION
FUNCTION t700_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09

   LET g_success = "Y"
   BEGIN WORK
   CALL t700_upd_ohb()

   IF g_success = 'Y' THEN
      LET g_prog = 'axmt700'   
      CALL saxmt700sub_s('1','1',g_oha01,TRUE)
      LET g_prog = 'aws_ttsrv2' 
      IF g_success = 'N' THEN
          LET g_status.code = '-1' 
          LET g_status.description = '销售退货过账失败'
          ROLLBACK WORK
          RETURN
      ELSE 
      	  LET g_status.description = '销售退货过账成功'    
      END IF
   END IF
 
END FUNCTION
	
	
FUNCTION t700_upd_ohb()   #No.MOD-8A0112 add
   DEFINE li_result   LIKE type_file.num5      #No.FUN-540027  #No.FUN-680136 SMALLINT
   DEFINE l_cnt       LIKE type_file.num5
   DEFINE l_n,l_t     LIKE type_file.num5
   DEFINE p_chr       LIKE type_file.chr1      #No.MOD-8A0112 add
   DEFINE l_ohb       RECORD LIKE ohb_file.*
   DEFINE l_iba       RECORD LIKE iba_file.*  
   DEFINE l_ibb       RECORD LIKE ibb_file.*    
   DEFINE l_sql       STRING
   
   DEFINE l_ohb04     LIKE ohb_file.ohb04,
          l_ohb09     LIKE ohb_file.ohb09,
          l_ohb091    LIKE ohb_file.ohb091,
          l_ohb092    LIKE ohb_file.ohb092,
          l_sum       LIKE ohb_file.ohb09,
          l_sum1      LIKE ohb_file.ohb09,
          l_ibb01     LIKE ibb_file.ibb01
 
   
   DEFINE l_axmt700_sr      RECORD                          #单身
                    ohb05      LIKE ohb_file.ohb05,         #仓库
                    ohb06      LIKE ohb_file.ohb06,         #库位
                    ibb01      LIKE ibb_file.ibb01,         #批次条码
                    ima01      LIKE ima_file.ima01,         #料件编码
                    ohb07      LIKE ohb_file.ohb07,         #批次
                    ohb09b     LIKE ohb_file.ohb09          #数量
                 END RECORD
                 
     INITIALIZE l_ohb.* TO NULL
     INITIALIZE l_axmt700_sr.* TO NULL
     INITIALIZE g_tlfb.* TO NULL

#     UPDATE ohb_file SET ohb12=g_ohb12a WHERE ohb01=g_oha01
####add by nihuan 20170614------start------------------------------     
     DROP TABLE axmt700_temp
     LET l_sql ="CREATE GLOBAL TEMPORARY TABLE axmt700_temp AS SELECT * FROM ohb_file WHERE 1=2"
     PREPARE axmt700_work_tab FROM l_sql
     EXECUTE axmt700_work_tab
     
     LET l_sql="insert into axmt700_temp select * from ohb_file where ohb01='",g_oha01,"'"
     PREPARE axmt700_temp_ins FROM l_sql
     EXECUTE axmt700_temp_ins
     
     DELETE FROM ohb_file WHERE ohb01=g_oha01
#   CREATE TEMP TABLE axmt700_file(
#                    ohb01      LIKE ohb_file.ohb01,         #单号
#                    ohb09      LIKE ohb_file.ohb09,         #仓库
#                    ohb091     LIKE ohb_file.ohb091,        #库位
#                    ohb092     LIKE ohb_file.ohb092,        #批次
#                    ibb01      LIKE ibb_file.ibb01,         #条码
#                    ohb04      LIKE ohb_file.ohb04,         #料件编码
#                    ohb12      LIKE ohb_file.ohb12)         #数量      
     LET l_sql="select ohb04,ohb09,ohb091,ohb092,ibb01,sum(ohb12) from axmt700_file
                group by ohb04,ohb09,ohb091,ohb092,ibb01"  
     PREPARE t700_ohb_nh FROM l_sql
     DECLARE t700_ohb_curs_nh CURSOR FOR t700_ohb_nh
     FOREACH t700_ohb_curs_nh INTO l_ohb04,l_ohb09,l_ohb091,l_ohb092,l_ibb01,l_sum
        IF l_sum=0 THEN 
           CONTINUE FOREACH 
        END IF 	
        
        LET l_sum1=l_sum
        LET l_sql="select * from axmt700_temp
                   where ohb01='",g_oha01,"' and ohb04='",l_ohb04,"' and ohb12>0
                   order by ohb03"
        PREPARE t700_ohb_hn FROM l_sql
        DECLARE t700_ohb_curs_hn CURSOR FOR t700_ohb_hn
        FOREACH t700_ohb_curs_hn INTO l_ohb.*
           IF l_sum=0 THEN #数量必相等
              EXIT FOREACH 
           END IF 	
           
           IF l_sum>=l_ohb.ohb12 THEN 
           	  LET l_sum=l_sum-l_ohb.ohb12
           	  UPDATE axmt700_temp SET ohb12=0
           	  WHERE ohb01=l_ohb.ohb01 AND ohb03=l_ohb.ohb03
           ELSE	 
           	  UPDATE axmt700_temp SET ohb12=l_ohb.ohb12-l_sum
          	  WHERE ohb01=l_ohb.ohb01 AND ohb03=l_ohb.ohb03
          	  LET l_ohb.ohb12=l_sum
          	  LET l_sum=0
           END IF
           	
           SELECT MAX(nvl(ohb03,0))+1 INTO l_ohb.ohb03
           FROM ohb_file WHERE ohb01=g_oha01
           IF cl_null(l_ohb.ohb03) THEN 
              LET l_ohb.ohb03 =1
           END IF	 
           
           LET l_ohb.ohb09 =l_ohb09     #仓库
           LET l_ohb.ohb091=l_ohb091    #库位
           LET l_ohb.ohb092=l_ohb092    #批号
           	
           INSERT INTO ohb_file VALUES(l_ohb.*)
           IF SQLCA.SQLCODE THEN
              LET g_status.code = SQLCA.SQLCODE
              LET g_status.sqlcode = SQLCA.SQLCODE
              LET g_success='N'
              RETURN  
           END IF	
        END FOREACH           	
#     END FOREACH 
####add by nihuan 20170614------end--------------------------------      
     
#      LET l_sql=" select ibb01,ima01,ohb07,SUM(ohb09b) from axmt700_file",
#                " group by ibb01,ima01,ohb07"
#                PREPARE axmt700_file1 FROM l_sql
#                DECLARE axmt700_file_curs1 CURSOR FOR axmt700_file1
#                FOREACH axmt700_file_curs1 INTO l_ibb01,l_ima01,l_ohb07,l_ohb09
      SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=l_ibb01
      SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=l_ibb01
      IF cl_null(l_n) THEN LET l_n=0 END IF
      IF cl_null(l_t) THEN LET l_t=0 END IF
      IF l_n=0 AND l_t=0 THEN
         LET l_iba.iba01=l_ibb01
         INSERT INTO iba_file VALUES(l_iba.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="产生iba_file有错误!" 
             LET g_success = 'N'
             RETURN
         END IF
         LET l_ibb.ibb01=l_ibb01                 #条码编号
         LET l_ibb.ibb02='K'                     #条码产生时机点
         LET l_ibb.ibb03=g_oha01                 #来源单号
         LET l_ibb.ibb04=0                       #来源项次
         LET l_ibb.ibb05=0                       #包号
         LET l_ibb.ibb06=l_ohb04                 #料号
         LET l_ibb.ibb11='Y'                     #使用否         
         LET l_ibb.ibb12=0                       #打印次数
         LET l_ibb.ibb13=0                       #检验批号(分批检验顺序)
         LET l_ibb.ibbacti='Y'                   #资料有效码
  #       LET l_ibb.ibb17=l_ohb07                 #批号
  #       LET l_ibb.ibb14=l_ohb09                 #数量
  #       LET l_ibb.ibb20=g_today                 #生成日期
         INSERT INTO ibb_file VALUES(l_ibb.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="产生ibb_file有错误!" 
             LET g_success = 'N'
            RETURN
         END IF
      END IF
#      END FOREACH 
      #条码异动档处理
#      LET l_sql="select * from axmt700_file"
#                PREPARE axmt700_file2 FROM l_sql
#                DECLARE axmt700_file_curs2 CURSOR FOR axmt700_file2
#                FOREACH axmt700_file_curs2 INTO l_axmt700_sr.*
      INITIALIZE g_tlfb.* TO NULL
      LET g_tlfb.tlfb01 = l_ibb01          #条码编号
      LET g_tlfb.tlfb02 = l_ohb09          #仓库
      LET g_tlfb.tlfb03 = l_ohb091         #库位
      LET g_tlfb.tlfb04 = l_ohb092         #批号  ibb17
      LET g_tlfb.tlfb05 = l_sum1           #数量
      LET g_tlfb.tlfb06 =  1                          #入库
      LET g_tlfb.tlfb07 = g_oha01                     #来源单号 
      LET g_tlfb.tlfb08 = 0                           #来源项次 ??工单项次
      LET g_tlfb.tlfb09 = g_oha01                     #目的单号
      LET g_tlfb.tlfb10 = 0                           #目的项次
      LET  g_tlfb.tlfb11 = g_prog
      LET  g_tlfb.tlfb13 = g_user
      LET  g_tlfb.tlfb14 = g_today
      LET  g_tlfb.tlfb15 = g_time 
      LET  g_tlfb.tlfb16 = 'PDA'
      SELECT to_char(g_today,'hh24:mi:ss') INTO g_tlfb.tlfb15 from dual
      LET g_tlfb.tlfb905= g_oha01                     #异动单号
      LET g_tlfb.tlfb906= 1                           #异动项次
      LET g_tlfb.tlfb17 = ' '                         #杂收理由码
      LET g_tlfb.tlfb18 = ' '                         #产品分类码 
      CALL s_web_tlfb('','','','','')                 #更新条码异动档
      LET l_n=0
      LET l_sql =" SELECT COUNT(*) FROM imgb_file ",
                "WHERE imgb01='",g_tlfb.tlfb01,"'",
                " AND imgb02='",g_tlfb.tlfb02,"'",
                " AND imgb03='",g_tlfb.tlfb03,"'" ,
                " AND imgb04='",g_tlfb.tlfb04,"'"
      
      PREPARE t018_imgb_pre FROM l_sql
      EXECUTE t018_imgb_pre INTO l_n
      IF l_n = 0 THEN #没有imgb_file，新增imgb_file
        CALL s_ins_imgb(g_tlfb.tlfb01,
              g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,'')
      ELSE
        CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
         g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
         g_tlfb.tlfb05,g_tlfb.tlfb06,'')
      END IF        

     END FOREACH

END FUNCTION




	
