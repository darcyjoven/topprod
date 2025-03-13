# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Program name...: s_x_aglau.4gl
# Descriptions...: 多工廠環境總帳系統自動賦予傳票以單號
# Date & Author..: 92/08/28 By David
# Usage..........: CALL s_x_aglau(p_dbs,p_bookno,p_slipno,p_date,p_yy,p_mm,p_aac06)
#                       RETURNING l_stat,l_trno
# Input Parameter: p_dbs     總帳工廠 dbs name
#                  p_bookno  帳別
#                  p_slipno  單別
#                  p_date    傳票日期
#                  p_yy      會計年度
#                  p_mm      會計期別
#                  p_aac06   編號方式
# Return Code....: l_stat    執行結果 0:OK 1:FAIL
#                  l_trno    傳票單號
# Memo...........: Without COMMIT WORK
# Modify.........: No.TQC-5A0086 05/10/27 By Smapmin 單別寫死
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/30 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
    DEFINE g_waitsec LIKE type_file.num5   	#No.FUN-680147 SMALLINT
#   DEFINE g_dbs     LIKE type_file.chr21  	#No.FUN-680147 VARCHAR(21)
END GLOBALS
    DEFINE g_mxno 		LIKE type_file.num10       #No.FUN-680147 INTEGER
#    DEFINE g_mxno2 		LIKE apr_file.apr02   #TQC-5A0089 	#No.FUN-680147 VARCHAR(12)
#    DEFINE g_mxno3 		LIKE apr_file.apr02   #TQC-5A0089 	#No.FUN-680147 VARCHAR(12)
    DEFINE g_mxno2 		LIKE axi_file.axi01   #TQC-5A0089 	#No.FUN-680147 VARCHAR(16)
    DEFINE g_mxno3 		LIKE axi_file.axi01   #TQC-5A0089 	#No.FUN-680147 VARCHAR(16)
    DEFINE l_date 		LIKE type_file.chr6   #No.FUN-680147 VARCHAR(6)
    DEFINE g_msg 		LIKE zaa_file.zaa08   #No.FUN-680147 VARCHAR(72)
     DEFINE g_sql 		string  #No.FUN-580092 HCN
    DEFINE g_chr 		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
 
#FUNCTION s_x_aglau(p_dbs,p_bookno,p_slipno,p_date,p_yy,p_mm,p_aac06)    #No.FUN-980025 mark
FUNCTION s_x_aglau(p_plant,p_bookno,p_slipno,p_date,p_yy,p_mm,p_aac06)   #No.FUN-980025 
DEFINE
	p_dbs    LIKE type_file.chr21, 				#總帳工廠 dbs name 	#No.FUN-680147 VARCHAR(21)
	p_plant  LIKE type_file.chr10, 				#總帳工廠 dbs name      #No.FUN-980025
	p_bookno LIKE aaa_file.aaa01,                   #帳別   #No.FUN-670039
#	p_slipno LIKE apr_file.apr02,				#單號   #TQC-5A0089 	#No.FUN-680147 VARCHAR(12)
	p_slipno LIKE oea_file.oea01,				#單號   #TQC-5A0089 	#No.FUN-680147 VARCHAR(16)
	p_date   LIKE type_file.dat,   					#傳票日期 	#No.FUN-680147 DATE 
	p_yy     LIKE type_file.num5,  				#會計年度 	#No.FUN-680147 SMALLINT
	p_mm     LIKE type_file.num5,  				#會計期別 	#No.FUN-680147 SMALLINT
	p_aac06  LIKE aac_file.aac06,                           #編號方式(1.依月 2.依日)#No.FUN-680147 VARCHAR(1)
	l_aac06  LIKE aac_file.aac06,                           #編號方式       #No.FUN-680147 VARCHAR(1)
	l_int    LIKE type_file.num10,  	#No.FUN-680147 INTEGER
#	l_slip   LIKE ala_file.ala71				#單別   #TQC-5A0089 	#No.FUN-680147 VARCHAR(3)
	l_slip   LIKE oay_file.oayslip                          #單別   #TQC-5A0089 	#No.FUN-680147 VARCHAR(5)
 
   ##NO.FUN-980025 GP5.2 add begin                                                                                                  
   IF cl_null(p_plant) THEN                                                                                                         
     LET p_dbs = NULL                                                                                                               
   ELSE                                                                                                                             
     LET g_plant_new = p_plant                                                                                                      
     CALL s_getdbs()                                                                                                                
     LET p_dbs = g_dbs_new                                                                                                          
 
   END IF                                                                                                                           
   ##NO.FUN-980025 GP5.2 add end  
    WHENEVER ERROR CONTINUE
	IF p_dbs = g_dbs THEN LET p_dbs = NULL END IF
	IF p_dbs IS NOT NULL AND p_dbs[21,21]!=':' THEN
           LET p_dbs[21,21]=':' 
        END IF
#	LET l_slip=p_slipno[1,3]   #TQC-5A0086
	LET l_slip=s_get_doc_no(p_slipno)   #TQC-5A0086
#       IF cl_null(p_slipno[5,12]) THEN   #TQC-5A0089
       IF cl_null(p_slipno[g_no_sp,g_no_ep]) THEN
	  IF p_aac06 MATCHES "[12]"         #編號方式
	     THEN LET l_aac06 = p_aac06
	     #ELSE LET g_sql = "SELECT aac06 FROM ",p_dbs,"aac_file",
         ELSE LET g_sql = "SELECT aac06 FROM ",cl_get_target_table(p_plant,'aac_file'), #FUN-A50102
                          " WHERE aac01 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
	          PREPARE s_x_aglau_p1 FROM g_sql
	          DECLARE s_x_aglau_c1 CURSOR FOR s_x_aglau_p1 
	             OPEN s_x_aglau_c1 USING l_slip
	            FETCH s_x_aglau_c1 INTO l_aac06
	          IF STATUS THEN LET l_aac06 = 1 END IF
	  END IF
	  IF l_aac06 = "1" THEN   #-->依年月
	     LET l_date=p_date USING "YYMMDD"
#	     LET g_mxno3=p_slipno[1,3],'-',l_date[1,4],'*'   #TQC-5A0086
	     LET g_mxno3=s_get_doc_no(p_slipno),'-',l_date[1,4],'*'   #TQC-5A0086
	  ELSE                    #-->依年月日
	     LET l_date=p_date USING "YYMMDD"
	     CASE WHEN l_date[3,4]='10' LET g_chr = 'A'
	          WHEN l_date[3,4]='11' LET g_chr = 'B'
	          WHEN l_date[3,4]='12' LET g_chr = 'C'
	          OTHERWISE             LET g_chr = l_date[4,4]
	     END CASE
#	     LET g_mxno3=p_slipno[1,3],'-',l_date[2,2],g_chr,l_date[5,6],'*'   #TQC-5A0086
	     LET g_mxno3=s_get_doc_no(p_slipno),'-',l_date[2,2],g_chr,l_date[5,6],'*'   #TQC-5A0086
	  END IF
         # LET g_sql = "SELECT MAX(axi01) FROM ",p_dbs,"axi_file",
           LET g_sql = "SELECT MAX(axi01) FROM ",cl_get_target_table(p_plant,'axi_file'), #FUN-A50102
                       " WHERE axi00=? AND axi01 MATCHES '",g_mxno3 CLIPPED,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
	  PREPARE s_x_aglau_p5 FROM g_sql
	  DECLARE s_x_aglau_c5 CURSOR FOR s_x_aglau_p5
	  OPEN s_x_aglau_c5 USING p_bookno
          FETCH s_x_aglau_c5 INTO g_mxno2      # LOCK單據性質
	  IF g_mxno2 IS NULL
          THEN LET g_mxno2 = g_mxno3[1,8],'0001'
          ELSE LET g_mxno2 = g_mxno3[1,8],(g_mxno2[9,12]+1) USING '&&&&'
          END IF
          LET p_slipno = g_mxno2
      END IF
#      LET p_slipno[4,4]='-'	  #TQC-5A0089
      #因為4.0版本的不自動加上'-', 故在此吾人須多此一舉
      RETURN 0,p_slipno
END FUNCTION
