# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_addr_val.4gl
# Descriptions...: 計算各料件之附加成本 
# Date & Author..: 92/02/22 By PIN
# Usage..........: CALL s_add_val(p_item,p_status,p_v) RETURNING l_cst
# Input Parameter:  p_item     料件編號
#                   p_status   成本計算方式
#                     1.標準成本
#                     2.現時成本
#                     3.建議成本
#                   p_v        模擬版本
# Return Code....: l_cst   料件附加成本
# Usage .........: call s_add_val(l_item,p_status)
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_add_val(l_item,p_status,p_v)
  DEFINE l_item   like csd_file.csd01,        #part no.  #No.MOD-490217
        p_status LIKE type_file.chr1,         #SQLCA.sqlcode=1.standard 2.current 3.propose 	#No.FUN-680147 VARCHAR(1)
        p_v      LIKE type_file.chr1,         #simulation version 	#No.FUN-680147 VARCHAR(1)
        l_csd02 LIKE csd_file.csd02,          #cost categroy
        l_csd04 LIKE csd_file.csd04,          #rate%         
        l_csd05 LIKE csd_file.csd05,          #fixed value    
        l_cse03 LIKE cse_file.cse03,          #ratio cost categroy
        l_csb05 LIKE csb_file.csb05,          #cost                  
        x_val   LIKE csa_file.csa0312,        #add value
        p_csa0312 LIKE csa_file.csa0312,      #add value
        i       LIKE type_file.num5    	      #No.FUN-680147 SMALLINT
 
#---->料件成本項目部份
 DECLARE add_val_cur CURSOR FOR SELECT csd02,csd04,csd05
                                 FROM  csd_file
                                 WHERE csd01=l_item #item no.
                                
    LET p_csa0312=0
    LET x_val=0
    LET i=0
	FOREACH add_val_cur INTO l_csd02,l_csd04,l_csd05 
	IF SQLCA.sqlcode !=0 THEN EXIT FOREACH END IF
        LET i=i+1
	 IF l_csd05 !=0 AND  l_csd05 IS NOT NULL
		THEN LET x_val=l_csd05            #固定金額
		ELSE DECLARE add_cur CURSOR FOR SELECT cse03 FROM cse_file
										WHERE cse01=l_item #item no
										  AND cse02=l_csd02
               LET x_val=0
			 FOREACH add_cur INTO l_cse03  #比率金額
			 IF SQLCA.sqlcode !=0 THEN EXIT FOREACH END IF
			 SELECT csb05 INTO l_csb05 FROM csb_file WHERE csb01=l_item
													 AND   csb02=p_v  
													 AND   csb03=p_status
													 AND   csb04=l_cse03
			 IF SQLCA.sqlcode !=0 THEN LET l_csb05=0 END IF
             LET x_val=x_val+(l_csb05*l_csd04/100)
			 END FOREACH
	 END IF
     IF g_sma.sma58 MATCHES '[Yy]'   #有使用成本項目結構
        THEN CALL insert_cote (l_item,l_csd02,x_val,p_status)
     END IF 
     LET p_csa0312=p_csa0312+x_val  #累計附加成本
   END FOREACH
#--------->料件分群碼部份
   IF i=0    #表無料件成本項目
      THEN DECLARE add_val_cur1 CURSOR FOR SELECT csf02,csf04,csf05
                                 FROM  csf_file
                                 WHERE csf01=l_item #item no.
                                
           LET p_csa0312=0
           LET x_val=0
           FOREACH add_val_cur1 INTO l_csd02,l_csd04,l_csd05 
          IF SQLCA.sqlcode !=0 THEN EXIT FOREACH END IF
	      IF l_csd05 !=0 OR l_csd05 IS NOT NULL
	    	THEN LET x_val=l_csd05            #固定金額
	    	ELSE DECLARE add_cur1 CURSOR FOR SELECT csg03 FROM csg_file
	    									WHERE csg01=l_item #item no
	    									  AND csg02=l_csf02
                  LET x_val=0
		    	 FOREACH add_cur1 INTO l_cse03  #比率金額
		    	 IF SQLCA.sqlcode !=0 THEN EXIT FOREACH END IF
		    	 SELECT csb05 INTO l_csb05 FROM csb_file WHERE csb01=l_item
		    											 AND   csb02=p_v
		     											 AND   csb03=p_status
			    										 AND   csb04=l_cse03
			     IF SQLCA.sqlcode !=0 THEN LET l_csb05=0 END IF
                 LET x_val=x_val+(l_csb05*l_csd04/100)
			     END FOREACH
     	 END IF
                IF g_sma.sma58 MATCHES '[Yy]'   #有使用成本項目結構
                   THEN CALL insert_cote (l_item,l_csd02,x_val,p_status)
                END IF 
                LET p_csa0312=p_csa0312+x_val  #累計附加成本
        END FOREACH
  END IF
IF cl_null(p_csa0312) THEN LET p_csa0312=0 END IF
RETURN p_csa0312
END FUNCTION
