# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_in_csa.4gl
# Descriptions...: Add part's cost element
# Date & Author..: 92/02/22 By PIN
# Usage..........: CALL s_in_csa(p_part,p_ima871,p_cost,p_status,p_purchase,
#                                p_ver_cost,p_xx,p_ind_mat,p_yy,p_v)
# Input Parameter: p_part      part no. 
#                  p_ima871    material burden factor
#                  p_cost      direct material cost (下階)
#                  p_status    1.standard 2.current 3.propose
#                  p_purchase  purchase cost only for 'p' parts
#                  p_ver_cost  material cost(本階)
#                  p_xx        indirect material cost category
#                  p_ind_mat   indirect material cost
#                  p_yy        add value cost
#                  p_v         simulation version
# Return code....: NONE
# Modify.........: No.MOD-490217 04/09/10 by yiting料號欄位使用 like方式
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_in_csa
 (part_item,l_ima871,l_cost,l_status,l_purchase,l_ver_cost,xx,ind_mat,yy,p_v)
    DEFINE part_item   like csa_file.csa01,         #item no.  #No.MOD-490217
          l_ima871     LIKE ima_file.ima871,        #材料製造費用分攤率(factor)
          l_ima872     LIKE ima_file.ima872,        #材料製造費用成本項目      
          l_cost       LIKE csa_file.csa0301,       #No.FUN-680147 DECIMAL(13,5)  #下階direct material cost
	  l_status     LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1)        #1.standard 2.current 3.propose
          l_purchase   LIKE csa_file.csa0301,       #No.FUN-680147 DECIMAL(13,5)  #採購成本
          l_ver_cost   LIKE csa_file.csa0301,       #No.FUN-680147 DECIMAL(13,5)  #本階成本
	  xx           LIKE ima_file.ima872,        #材料間接成本項目
	  yy           LIKE csa_file.csa0301,       #No.FUN-680147 DECIMAL(13,5)  #ADD VALUES    COST
          ind_material LIKE csa_file.csa0301,       #No.FUN-680147 DECIMAL(13,5)  #下階間接材料
          ind_mat      LIKE csa_file.csa0301,       #No.FUN-680147 DECIMAL(13,5)  #本階間接材料
          p_v          LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)        #simulation no.
 
    LET ind_material=l_cost*l_ima871   #下階間接材料成本
    IF cl_null(ind_material)  THEN LET ind_material=0 END IF
    IF cl_null(l_cost) THEN LET l_cost=0 END IF
    IF cl_null(l_purchase) THEN LET l_purchase=0 END IF
    IF cl_null(l_ver_cost) THEN LET l_ver_cost=0 END IF
    IF cl_null(yy) THEN LET yy=0 END IF
    IF cl_null(ind_mat) THEN LET ind_mat=0 END IF
   
 
  DELETE FROM csa_file where csa01=part_item                
			 and csa02=p_v             
 
  INSERT INTO csa_file (csa01      ,csa02       ,csa03    ,
                        csa0301    ,csa0302     ,csa0303  ,
			csa0304    ,csa0305     ,csa0306  ,
			csa0307    ,csa0308     ,csa0309  ,
			csa0310    ,csa0311     ,csa0312  ,
			csa0321    ,csa0322     ,csa0323  ,
			csa0324    ,csa0325     ,csa0326  ,
			csa0327    ,csa0328     ,csa0329  ,
			csa0330    ,csa0331     ,csaacti  ,
			csauser    ,csagrup     ,csamodu  ,
			csadate    ,csaplant    ,csalegal  )   #FUN-980012 add
   VALUES  (part_item  ,p_v         ,l_status  ,
            l_ver_cost ,ind_mat     ,0         , #本階材料成本
            0          ,0           ,0         ,
            0          ,0           ,0         ,
            0          ,l_purchase  ,yy        , #採購成本
            l_cost     ,ind_material,0         , #下階人工/間接人工
            0          ,0           ,0         , 
            0          ,0           ,0         ,
            0          ,0           ,'Y'       ,
            g_user     ,g_grup      ,g_user    ,
            g_today    ,g_plant     ,g_legal)    #FUN-980012 add
#  IF SQLCA.sqlcode THEN RETURN 1 END IF			
#RETURN 0
END FUNCTION
