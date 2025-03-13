# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_afamxno.4gl
# Descriptions...: 預設附號之最大值
# Date & Author..: 96/05/27 By Apple  
# Usage..........: CALL s_afamxno(p_no,p_type) 
# Input Parameter: p_no     財產編號   
#                  p_type   型態     
# Return Code....: NONE
# Modify.........: No.MOD-4B0305 04/11/30 By Nicola 固定資產維護作業(afai100)/資產底稿資料維護作業(afai101),附號不會依參數設定累加
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.MOD-6C0152 06/12/22 By Smapmin 僅修改ORA檔
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:MOD-A50116 10/05/19 By sabrina 當g_faa.faa22>=4時會有錯誤
# Modify.........: No:MOD-B20106 11/02/23 By Dido 計算長度應用 faa17 長度 
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_afamxno(p_no,p_type)
DEFINE p_no    LIKE faj_file.faj02,           #財產編號            
       p_type  LIKE faj_file.faj021,          #型態
       l_i            LIKE type_file.num5,    	#No.FUN-680147 SMALLINT
       l_area,l_beno  LIKE faa_file.faa17,    
       l_mxno         LIKE faa_file.faa17,
       l_faj_no       LIKE faj_file.faj022,
       l_fak_no       LIKE fak_file.fak022
DEFINE l_length       LIKE type_file.num5     #MOD-B20106
 
	WHENEVER ERROR CALL cl_err_msg_log
        #LET l_i = 4 - g_faa.faa22           #MOD-B20106 mark
         LET l_length = LENGTH(g_faa.faa17)  #MOD-B20106 
         LET l_i = l_length - g_faa.faa22    #MOD-B20106 
        #MOD-A50116---add---start---
         IF l_i <= 0 THEN
            CALL cl_err(g_faa.faa22,'afa-196',0)
            RETURN l_mxno
         END IF
        #MOD-A50116---add---end---
         IF g_faa.faa16 = 'Y' THEN 
            LET l_area = g_faa.faa17[1,l_i] clipped,'%'
            LET l_beno = g_faa.faa17
             #-----No.MOD-4B0305-----
            SELECT max(faj022) INTO l_faj_no FROM faj_file 
                              WHERE faj02 = p_no           #財編
                                AND faj022 LIKE l_area  #附號
            IF sqlca.sqlcode THEN LET l_faj_no = ' ' END IF
            IF cl_null(l_faj_no) THEN LET l_faj_no = ' ' END IF
            SELECT max(fak022) INTO l_fak_no FROM fak_file 
                              WHERE fak02 = p_no
                                AND fak022 LIKE l_area
            IF sqlca.sqlcode THEN LET l_fak_no = ' ' END IF
             #-----No.MOD-4B0305 END-----
         ELSE 
            IF p_type  = '2' THEN 
               LET l_area = g_faa.faa17[1,l_i] clipped,'%'
               LET l_beno = g_faa.faa17
            ELSE
               LET l_area = g_faa.faa18[1,l_i] clipped,'%'
               LET l_beno = g_faa.faa18
            END IF
             #-----No.MOD-4B0305-----
            SELECT max(faj022) INTO l_faj_no FROM faj_file 
                              WHERE faj02 = p_no           #財編
                                AND faj021= p_type         #型態
                                AND faj022 LIKE l_area  #附號
            IF sqlca.sqlcode THEN LET l_faj_no = ' ' END IF
            IF cl_null(l_faj_no) THEN LET l_faj_no = ' ' END IF
            SELECT max(fak022) INTO l_fak_no FROM fak_file 
                              WHERE fak02 = p_no
                                AND fak021= p_type
                                AND fak022 LIKE l_area
            IF sqlca.sqlcode THEN LET l_fak_no = ' ' END IF
             #-----No.MOD-4B0305 END-----
         END IF
          {#-----No.MOD-4B0305 Mark-----
         SELECT max(faj022) INTO l_faj_no FROM faj_file 
                           WHERE faj02 = p_no           #財編
                             AND faj021= p_type         #型態
                             AND faj022 LIKE l_area  #附號
         IF sqlca.sqlcode THEN LET l_faj_no = ' ' END IF
         IF cl_null(l_faj_no) THEN LET l_faj_no = ' ' END IF
         SELECT max(fak022) INTO l_fak_no FROM fak_file 
                           WHERE fak02 = p_no
                             AND fak021= p_type
                             AND fak022 LIKE l_area
         IF sqlca.sqlcode THEN LET l_fak_no = ' ' END IF
          #-----No.MOD-4B0305 Mark END-----}
         IF cl_null(l_fak_no) THEN LET l_fak_no = ' ' END IF
         IF cl_null(l_faj_no) AND cl_null(l_fak_no) THEN 
            IF g_faa.faa16 = 'Y' THEN 
               LET l_faj_no = g_faa.faa17 
            ELSE
               IF p_type  = '2' THEN 
                  LET l_faj_no = g_faa.faa17 
               ELSE
                  LET l_faj_no = g_faa.faa18
               END IF
            END IF
         END IF
         IF l_faj_no > l_fak_no THEN 
              CASE  
                WHEN g_faa.faa22 = 1 
                    #LET l_mxno = l_faj_no[1,3],l_faj_no[4,4] + 1 using'&'             #MOD-B20106 mark
                     LET l_mxno = l_faj_no[1,l_i],l_faj_no[l_i+1,l_i+1] + 1 using'&'   #MOD-B20106
                WHEN g_faa.faa22 = 2 
                    #LET l_mxno = l_faj_no[1,2],l_faj_no[3,4] + 1 using'&&'            #MOD-B20106 mark
                     LET l_mxno = l_faj_no[1,l_i],l_faj_no[l_i+1,l_i+2] + 1 using'&&'  #MOD-B20106
                WHEN g_faa.faa22 = 3 
                    #LET l_mxno = l_faj_no[1,1],l_faj_no[2,4] + 1 using'&&&'           #MOD-B20106 mark
                     LET l_mxno = l_faj_no[1,l_i],l_faj_no[l_i+1,l_i+3] + 1 using'&&&' #MOD-B20106
                WHEN g_faa.faa22 = 4 
                 #    LET l_mxno = l_faj_no[1,1],l_faj_no[2,4] + 1 using'&&&&'   #No.MOD-4B0305 Mark
                      LET l_mxno = l_faj_no[1,4] + 1 using'&&&&'    #No.MOD-4B0305
                OTHERWISE EXIT CASE 
              END CASE
         ELSE
              CASE  
                WHEN g_faa.faa22 = 1 
                    #LET l_mxno = l_fak_no[1,3],l_fak_no[4,4] + 1 using'&'             #MOD-B20106 mark
                     LET l_mxno = l_fak_no[1,l_i],l_fak_no[l_i+1,l_i+1] + 1 using'&'   #MOD-B20106
                WHEN g_faa.faa22 = 2 
                    #LET l_mxno = l_fak_no[1,2],l_fak_no[3,4] + 1 using'&&'            #MOD-B20106 mark
                     LET l_mxno = l_fak_no[1,l_i],l_fak_no[l_i+1,l_i+2] + 1 using'&&'  #MOD-B20106
                WHEN g_faa.faa22 = 3 
                    #LET l_mxno = l_fak_no[1,1],l_fak_no[2,4] + 1 using'&&&'           #MOD-B20106 mark
                     LET l_mxno = l_fak_no[1,l_i],l_fak_no[l_i+1,l_i+3] + 1 using'&&&' #MOD-B20106
                WHEN g_faa.faa22 = 4 
                 #    LET l_mxno = l_fak_no[1,1],l_fak_no[2,4] + 1 using'&&&&'   #No.MOD-4B0305 Mark
                      LET l_mxno = l_fak_no[1,4] + 1 using'&&&&'   #No.MOD-4B0305
                OTHERWISE EXIT CASE 
              END CASE
         END IF
         IF cl_null(l_mxno) THEN LET l_mxno = l_beno END IF
         RETURN l_mxno 
END FUNCTION
#MOD-6C0152
