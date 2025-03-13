# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
##□ s_faj27  
##SYNTAX        CALL s_faj27(p_no,p_type)
##DESCRIPTION	預設附件之耐用年限        
##PARAMETERS	p_date
##		p_faa15 
##RETURNING	NONE
##NOTE		
##	
# Date & Author..: 97/01/28 By Apple  
# Revise record..:
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
GLOBALS "../../config/top.global"
 
FUNCTION s_faj27(p_date,p_faa15)  
DEFINE p_date         LIKE faj_file.faj26,  
       p_faa15        LIKE faa_file.faa15,
       l_day          LIKE type_file.num10,         #No.FUN-680070 INTEGER
       l_yy,l_mm      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_cy           LIKE type_file.chr4,         #No.FUN-680070 VARCHAR(04)
       l_cm           LIKE type_file.chr2,         #No.FUN-680070 VARCHAR(02)
       l_faj27        LIKE faj_file.faj27
 
       IF p_faa15 = '3'  THEN 
          LET l_day = DAY(p_date)
          IF l_day <= 15 
          THEN LET p_faa15 = '2' 
          ELSE LET p_faa15 = '1' 
          END IF
       END IF
       CASE 
          WHEN  p_faa15 = '1'     #次月
                LET l_yy = YEAR(p_date) 
                LET l_mm = MONTH(p_date) 
                IF l_mm = 12 THEN 
                   LET l_cy = l_yy + 1 USING '&&&&'
                   LET l_cm = '01' 
                ELSE 
                   LET l_cy = l_yy USING '&&&&'
                   LET l_cm = l_mm + 1 USING '&&'
                END IF
                LET l_faj27 = l_cy,l_cm 
          WHEN  p_faa15 = '2'     #當月
                LET l_yy = YEAR(p_date) 
                LET l_mm = MONTH(p_date)
                LET l_cy = l_yy USING '&&&&'
                LET l_cm = l_mm USING '&&'
                LET l_faj27 = l_cy,l_cm 
          WHEN  p_faa15 = '4'     #當月
                LET l_yy = YEAR(p_date) 
                LET l_mm = MONTH(p_date)
                LET l_cy = l_yy USING '&&&&'
                LET l_cm = l_mm USING '&&'
                LET l_faj27 = l_cy,l_cm 
          OTHERWISE EXIT CASE 
       END CASE 
       RETURN l_faj27
END FUNCTION
